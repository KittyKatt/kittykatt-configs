#!/bin/bash
#
# (c) Copyright (c) 2006-2008, Diomidis Spinellis. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# Monitor the progress of the specified command
#
# For each file the specified command is reading, display the percentage
# that has been read.  This command is modelled after a similar facility
# available on Permin-Elmer/Concurrent OS32
#
# Requires:
# - trap notification in wait (bash)
# - /proc[0-9]*/fdinfo (Linux 2.6.22 and later)
# - stat(1) (or substitute ls(1) with appropriate output parsing)
#
# Tested under SUSE Linux 10.3 with kernel 2.6.22.19
#
# $Id: monitor-linux.sh,v 1.2 2008/10/27 12:19:25 dds Exp $
#

CMD=$1

trap : USR1 INT TERM

display()
{
	cd /proc/$PID/fdinfo
	for i in `grep -l '^pos:' *`
	do
		readlink -n ../fd/$i
		awk '/^pos:/{print " " $2}' $i
	done |
	# Obtain the offset and print it as a percentage
	awk '
		BEGIN { CONVFMT = "%.2f" }
		{
			fname = $1
			offset = $2
			"stat -c %s '\''" fname "'\''" | getline
			len = $0
			if (len > 0)
				print fname, offset / len * 100 "%"
		}
	' 1>&2
}

# Execute the specified command in the background so as to catch signals
# asynchronously
$@ &
PID=$!

# React to signals and termination
while :
do
	wait $PID
	STATUS=$?
	if [ $STATUS -eq 138 -a -d /proc/$PID ]
	then
		display
	else
		kill $PID 2>/dev/null
		exit $STATUS
	fi
done

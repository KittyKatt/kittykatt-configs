#!/bin/bash
# Openbox Pipe Menu for xcompmgr
# Written for CrunchBang Linux <http://crunchbang.org/projects/linux/>
# by Philip Newborough (aka corenominal) <mail@philipnewborough.co.uk>
# mods by arpinux <arplinuxnet@gmail.com> for pekwm

# Set xcompmgr command options
EXEC='xcompmgr -c -t-5 -l-5 -r4.2 -o.55' #basic
#EXEC='xcompmgr -cCfF -t-5 -l-5 -r4.2 -o.55 -D6' #more effects

# Toggle compositing. Call with "pekwm_xcompmgr.sh --startstop"
if [ "$1" = "--startstop" ]; then 
    if [ ! "$(pidof xcompmgr)" ]; then
      $EXEC
    else
      killall xcompmgr
    fi
    exit 0
fi
# Output PeKwm menu
if [ ! "$(pidof xcompmgr)" ]; then
    echo "Dynamic {"
    echo " Entry = \"enable compositing\" { Actions = \"Exec ~/.pekwm/scripts/pekwm_xcompmgr.sh --startstop \" } "
    echo " }"
else
    echo "Dynamic {"
    echo " Entry = \"full opacity\" { Actions = \"Exec transset 1 \" } "
    echo " Entry = \"75% opacity\" { Actions = \"Exec transset .75 \" } "
    echo " Entry = \"50% opacity\" { Actions = \"Exec transset .50 \" } "
    echo " Entry = \"25% opacity\" { Actions = \"Exec transset .25 \" } "
    echo " Entry = \"disable effects\" { Actions = \"Exec ~/.pekwm/scripts/pekwm_xcompmgr.sh --startstop \" } "
    echo " }"
fi
exit 0

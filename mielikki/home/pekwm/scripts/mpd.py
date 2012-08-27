#!/usr/bin/env python2
#
# Author: Brett Bohnenkamper <kittykatt@archlinux.us>
# License: GPL 2.0
#
# This script depends on py-libmpdclient2 which you can get from 
# http://incise.org/index.cgi/py-libmpdclient2
#
# Usage:
# Save this script as "mpd.py" in the folder ~/.pekwm/scripts/ and make it
# executable ("chmod +x ~/.pekwm/scripts/mpd.py" in terminal).
#
# Put an entry in ~/.pekwm/menu wherever you would like it to be displayed:
# Submenu = "MPD" {
#      Entry { Actions = "Dynamic /home/YOURUSERNAME/.pekwm/scripts/mpd.py" }
# }
#
# Please also make sure to replace the YOURUSERNAME above with your actual username
# in /home and replace all YOURUSERNAME values in the following code with your actual
# username in /home.
#
# Yes, I do know that some of this is awful coding. I'll fix it up as soon as I have time.
#
# Originally Based on the ob-mpd.py code for OpenBox by John Eikenberry <jae@zhar.net>
#
# Ported to PekWM by me. Enjoy.
#

import os, sys, socket
import mpdclient2

argv = sys.argv

# The default port for MPD is 6600.  If for some reason you have MPD
# running on a different port, change this setting.
mpdPort = 6600

# determin path to this file
# my_path = sys.modules[__name__].__file__
# if this fails for some reason, just set it manually.
# Eg.
my_path = "/home/YOURUSERNAME/.pekwm/scripts/mpd.py"


try:
    connect = mpdclient2.connect(port=mpdPort)
except socket.error:
    # If MPD is not running.
    if len(argv) > 1 and argv[1] == 'start':
            os.execl('/usr/bin/mpd','$HOME/.mpdconf')
    else:
        print "Dynamic {"
	print "SubMenu = \"MPD\" {"
        print "Entry = \"%s\" { Actions = \"Exec my_path \"%s\" &\" }" % ('MPD is not running  [start]','start')
	print "}"
        print "}"

else: # part of connect try block
        
    song = connect.currentsong()
    stats = connect.stats()
    status = connect.status()

    if status['state'] == "stop":
        display_state = "Not playing"
    else:
        try:
            display_state = "%s - %s" % (song.artist, song.title)
        except (AttributeError, KeyError): # no id3 tags
            display_state = os.path.basename(song.file)
        if status['state'] == "pause":
            display_state += " (paused)"
    display_state = display_state.replace('"',"'")
    display_state = display_state.replace('&','&amp;')

    if len(argv) > 1:

        state = status.state
        def play():
            if state == "stop" or state == "pause":
                connect.play()

        def pause():
            if state == "play":
                connect.pause(1)
            elif state == "pause":
                connect.play()

        def stop():
            if state == "play" or state == "pause":
                connect.stop()

        def prev():
            if state == "play":
                connect.previous()

        def next():
            if state == "play":
                connect.next()

        random_state = int(status.random)
        def random():
            if random_state:
                connect.random(0)
            else:
                connect.random(1)

        repeat_state = int(status.repeat)
        def repeat():
            if repeat_state:
                connect.repeat(0)
            else:
                connect.repeat(1)

        single_state = int(status.single)
        def single():
            if single_state:
                connect.single(0)
            else:
                connect.single(1)

        consume_state = int(status.consume)
        def consume():
            if consume_state:
                connect.consume(0)
            else:
                connect.consume(1)

        def kill():
            try:
                connect.kill()
            except EOFError:
                pass

        def update():
            connect.update()
        
        def volume(setto):
            relative = (setto[0] in ['+','-'])
            setto = int(setto)
            if relative:
                newvol = int(status.volume) + setto
                newvol = newvol <= 100 or 100
                newvol = newvol >= 0 or 0
            connect.setvol(setto)

        def client():
            os.execlp('x-terminal-emulator','-e','ncmpc')

        def enable(output_id):
            connect.enableoutput(int(output_id))

        def disable(output_id):
            connect.disableoutput(int(output_id))

        def load(list_name):
            connect.load(list_name)

        def clear():
            connect.clear()

        if   (argv[1]     == "play"):    play()
        elif (argv[1]     == "pause"):   pause()
        elif (argv[1]     == "stop"):    stop()
        elif (argv[1][:4] == "prev"):    prev()
        elif (argv[1]     == "next"):    next()
        elif (argv[1]     == "random"):  random()
        elif (argv[1]     == "repeat"):  repeat()
        elif (argv[1]     == "volume"):  volume(argv[2])
        elif (argv[1]     == "client"):  client()
        elif (argv[1]     == "kill"):    kill()
        elif (argv[1]     == "update"):  update()
        elif (argv[1]     == "enable"):  enable(argv[2])
        elif (argv[1]     == "disable"): disable(argv[2])
        elif (argv[1]     == "load"):    load(argv[2])
        elif (argv[1]     == "clear"):   clear()

    else:
	print "Dynamic {"
	print "Submenu = \"Stats\" {"
        print "Entry = \"%s\" { Actions = \"mpc current\" }" % (display_state)
        print "Entry = \"%s\" { Actions = \"Exec echo 'kbs'\" }" % ('%s kbs' % status.bitrate)
	print "Separator {}"
        print "Entry = \"%s\" { Actions = \"Exec echo 'artists'\" }" % ("Artists in DB: %s" % stats.artists)
        print "Entry = \"%s\" { Actions = \"Exec echo 'albums'\" }" % ("Albums in DB: %s" % stats.albums)
        print "Entry = \"%s\" { Actions = \"Exec echo 'songs'\" }" % ("Songs in DB: %s" % stats.songs)
	print "}"
        print "Separator {}"
        print "Entry = \"Next\" { Actions = \"Exec mpc next\" }"
        print "Entry = \"Prev\" { Actions = \"Exec mpc prev\" }"
	if status['state'] == "pause":
		print "Entry = \"Play\" { Actions = \"Exec mpc play\" }"
	if status['state'] == "play":
		print "Entry = \"Pause\" { Actions = \"Exec mpc pause\" }"
        print "Entry = \"Stop\" { Actions = \"Exec mpc stop\" }"
        print "Separator {}"
        print "Entry = \"%s\" { Actions = \"Exec mpc %s\" }" % ('Toggle random %s' % (
            int(status.random) and '[On]' or '[Off]'), 'random')
        print "Entry = \"%s\" { Actions = \"Exec mpc %s\" }" % ('Toggle repeat %s' % (
            int(status.repeat) and '[On]' or '[Off]'), 'repeat')
        print "Entry = \"%s\" { Actions = \"Exec mpc %s\" }" % ('Toggle random %s' % (
            int(status.single) and '[On]' or '[Off]'), 'single')
        print "Entry = \"%s\" { Actions = \"Exec mpc %s\" }" % ('Toggle single %s' % (
            int(status.consume) and '[On]' or '[Off]'), 'consume')
        print "Separator {}"
        print "Submenu = \"%s\" {" % ("Volume: %s%%" % status.volume)
        print "Entry = \"%s\" { Actions = \"Exec mpc volume 100\" }" % ('[100%]')
        print "Entry = \"%s\" { Actions = \"Exec mpc volume 90\" }" % ('[90%]')
        print "Entry = \"%s\" { Actions = \"Exec mpc volume 80\" }" % ('[80%]')
        print "Entry = \"%s\" { Actions = \"Exec mpc volume 70\" }" % ('[70%]')
        print "Entry = \"%s\" { Actions = \"Exec mpc volume 60\" }" % ('[60%]')
        print "Entry = \"%s\" { Actions = \"Exec mpc volume 50\" }" % ('[50%]')
        print "Entry = \"%s\" { Actions = \"Exec mpc volume 40\" }" % ('[40%]')
        print "Entry = \"%s\" { Actions = \"Exec mpc volume 30\" }" % ('[30%]')
        print "Entry = \"%s\" { Actions = \"Exec mpc volume 20\" }" % ('[20%]')
        print "Entry = \"%s\" { Actions = \"Exec mpc volume 10\" }" % ('[10%]')
        print "Entry = \"%s\" { Actions = \"Exec mpc volume 0\" }" % ('[Mute]')
        print "}"
        print "Submenu = \"Playlist\" {"
	print "Entry = \"Clear\" { Actions = \"Exec mpc clear\" }"
        print "Separator {}"
        for entity in connect.lsinfo():
            if 'playlist' in entity:
                playlist = entity['playlist']
                print "Entry = \"%s\" { Actions = \"Exec mpc %s\" }" % (playlist, 'load %s' % playlist)
        print "}"
        print "Separator {}"
        print "Entry = \"%s\" { Actions = \"Exec mpc %s\" }" % ('Update Database','update')
        print "Entry = \"%s\" { Actions = \"Exec killall mpd\" }" % ('Kill MPD')
	print "}"

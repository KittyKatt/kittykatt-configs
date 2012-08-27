#!/usr/bin/env python2
import sys
import os
import subprocess

# root filesystem
print "${voffset -2}${color0}${font Poky:size=15}y${font}${color}${offset 6}${voffset -7}Root: ${font Droid Sans:style=Bold:size=8}${color1}${fs_used_perc /}%${color}${font}"
print "${voffset 2}${color0}${fs_bar 4,20 /}${color}${offset 8}${voffset -2}F:${color2}${fs_free /}${color} U:${color2}${fs_used /}${color}"

# /home folder (if its a separate mount point)
if os.path.ismount("/home"):
	print "${voffset -2}${color0}${font Poky:size=15}y${font}${color}${offset 6}${voffset -7}Home: ${font Droid Sans:style=Bold:size=8}${color1}${fs_used_perc /home}%${color}${font}"
	print "${voffset 2}${color0}${fs_bar 4,20 /home}${color}${offset 8}${voffset -2}F:${color2}${fs_free /home}${color} U:${color2}${fs_used /home}${color}${font}"

# /home/kittykatt/.mpd/music - Music Partition
if os.path.ismount("/home/kittykatt/.mpd/music"):
	print "${voffset -2}${color0}${font Poky:size=15}y${font}${color}${offset 6}${voffset -7}Music: ${font Droid Sans:style=Bold:size=8}${color1}${fs_used_perc /home/kittykatt/.mpd/music}%${color}${font}"
	print "${voffset 2}${color0}${fs_bar 4,20 /home/kittykatt/.mpd/music}${color}${offset 8}${voffset -2}F:${color2}${fs_free /home/kittykatt/.mpd/music}${color} U:${color2}${fs_used /home/kittykatt/.mpd/music}${color}${font}"

# /home/kittykatt/sshfs - SSHFS Mounted Partitions
for device in os.listdir("/home/kittykatt/sshfs/"):
	if os.path.ismount('/home/kittykatt/sshfs/'+device):
		print "${voffset -2}${color0}${font Poky:size=15}y${font}${color}${offset 6}${voffset -7}"+device.capitalize()+": ${font Droid Sans:style=Bold:size=8}${color1}${fs_used_perc /home/kittykatt/sshfs/"+device+"}%${color}${font}"
		print "${voffset 2}${color0}${fs_bar 4,20 /home/kittykatt/sshfs/"+device+"}${color}${offset 8}${voffset -2}F:${color2}${fs_free /home/kittykatt/sshfs/"+device+"}${color} U:${color2}${fs_used /home/kittykatt/sshfs/"+device+"}${color}"

# folder in /media
for device in os.listdir("/media/"):
	if (not device.startswith("cdrom")) and (os.path.ismount('/media/'+device)):
		print "${voffset -2}${color0}${font Poky:size=15}y${font}${color}${offset 6}${voffset -7}"+device.capitalize()+": ${font Droid Sans:style=Bold:size=8}${color1}${fs_used_perc /media/"+device+"}%${color}${font}"
		print "${voffset 2}${color0}${fs_bar 4,20 /media/"+device+"}${color}${offset 8}${voffset -2}F:${color2}${fs_free /media/"+device+"}${color} U:${color2}${fs_used /media/"+device+"}${color}"

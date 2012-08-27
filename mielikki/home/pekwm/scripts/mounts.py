#!/usr/bin/python2
import commands

file_manager = 'thunar'

mounts_full = commands.getoutput('mount')
mounts_sep = mounts_full.split('\n')

print "Submenu = \"Mounts\" {"

for line in mounts_sep:
	drop_front = line.split(' on ')
	drop_rear = drop_front[1].split(' type ')
	mount_point = drop_rear[0]
        print "Entry = \"%s \" { Actions = \"Exec %s \"%s\" &\" }"%(mount_point,file_manager,mount_point)

print "}"


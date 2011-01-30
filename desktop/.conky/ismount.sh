#!/bin/bash

findMount () {
	_command=
	_mountpoint=$1 
	_command=$(mount | awk -v mnt=$_mountpoint '{if ($3 == mnt) print $0}')
}

mntlocal () {
	_mntbase="/"
	_mntpoint="home"
	findMount "$_mntbase$_mntpoint"
	if [ "$_command" ]; then
		printf "\n\${voffset -12}\${color0}\${offset 1}\${font Poky:size=15}y\${font}\${color}\${offset 8}\${voffset -7}$_mntpoint: \${font DejaVu Sans Mono:style=Bold:size=8}\${color1}\${fs_used_perc $_mntbase$_mntpoint}%%\${color}\${font}"
		echo -e "\n"
		printf "\${voffset -10}\${color0}\${fs_bar 4,20 $_mntbase$_mntpoint}\${color}\${offset 8}\${voffset -4}F: \${color2}\${fs_free $_mntbase$_mntpoint}\${color} U: \${color2}\${fs_used $_mntbase$_mntpoint}\${color}"
	fi
}

mntsshfs () {
	_mntbase="/home/kittykatt/sshfs/"
	_mntpoint="lloth-srv"
	findMount "$_mntbase$_mntpoint"
	if [ "$_command" ]; then
		printf "\n\n\${voffset -12}\${color0}\${offset 1}\${font Poky:size=15}y\${font}\${color}\${offset 8}\${voffset -7}$_mntpoint: \${font DejaVu Sans Mono:style=Bold:size=8}\${color1}\${fs_used_perc $_mntbase$_mntpoint}%%\${color}\${font}"
		echo -e "\n"
		printf "\${voffset -10}\${color0}\${fs_bar 4,20 $_mntbase$_mntpoint}\${color}\${offset 8}\${voffset -4}F: \${color2}\${fs_free $_mntbase$_mntpoint}\${color} U: \${color2}\${fs_used $_mntbase$_mntpoint}\${color}"
	fi
	_mnt_point="/home/kittykatt/sshfs/lloth-home"
	findMount $_mnt_point
	if [ "$_command" ]; then
		printf "\n\n\${voffset -12}\${color0}\${offset 1}\${font Poky:size=15}y\${font}\${color}\${offset 8}\${voffset -7}$_mntpoint: \${font DejaVu Sans Mono:style=Bold:size=8}\${color1}\${fs_used_perc $_mntbase$_mntpoint}%%\${color}\${font}"
		echo -e "\n"
		printf "\${voffset -10}\${color0}\${fs_bar 4,20 $_mntbase$_mntpoint}\${color}\${offset 8}\${voffset -4}F: \${color2}\${fs_free $_mntbase$_mntpoint}\${color} U: \${color2}\${fs_used $_mntbase$_mntpoint}\${color}"
	fi
	_mnt_point="/home/kittykatt/sshfs/lloth-extra"
	findMount $_mnt_point
	if [ "$_command" ]; then
		printf "\n\n\${voffset -12}\${color0}\${offset 1}\${font Poky:size=15}y\${font}\${color}\${offset 8}\${voffset -7}$_mntpoint: \${font DejaVu Sans Mono:style=Bold:size=8}\${color1}\${fs_used_perc $_mntbase$_mntpoint}%%\${color}\${font}"
		echo -e "\n"
		printf "\${voffset -10}\${color0}\${fs_bar 4,20 $_mntbase$_mntpoint}\${color}\${offset 8}\${voffset -4}F: \${color2}\${fs_free $_mntbase$_mntpoint}\${color} U: \${color2}\${fs_used $_mntbase$_mntpoint}\${color}"
	fi
	_mnt_point="/home/kittykatt/sshfs/mysta-home"
	findMount $_mnt_point
	if [ "$_command" ]; then
		printf "\n\n\${voffset -12}\${color0}\${offset 1}\${font Poky:size=15}y\${font}\${color}\${offset 8}\${voffset -7}$_mntpoint: \${font DejaVu Sans Mono:style=Bold:size=8}\${color1}\${fs_used_perc $_mntbase$_mntpoint}%%\${color}\${font}"
		echo -e "\n"
		printf "\${voffset -10}\${color0}\${fs_bar 4,20 $_mntbase$_mntpoint}\${color}\${offset 8}\${voffset -4}F: \${color2}\${fs_free $_mntbase$_mntpoint}\${color} U: \${color2}\${fs_used $_mntbase$_mntpoint}\${color}"
	fi
}

printf "\${voffset -2}\${color0}\${offset 1}\${font Poky:size=15}y\${font}\${color}\${offset 8}\${voffset -7}root: \${font DejaVu Sans Mono:style=Bold:size=8}\${color1}\${fs_used_perc /}%%\${color}\${font}"
echo -e "\n"
printf "\${voffset -10}\${color0}\${fs_bar 4,20 /}\${color}\${offset 8}\${voffset -4}F: \${color2}\${fs_free /}\${color} U: \${color2}\${fs_used /}\${color}"
echo -ne "\n"

mntlocal
mntsshfs
#!/bin/sh

c=$(tput cols)
i=0
while [ $i -lt 256 ]
do
    if [ "$1" = n ] # Color the numbers too
    then printf '\033[38;05;%dm%03d\033[00m \033[48;05;%dm  \033[00m' $i $i $i
    else printf '%03d \033[48;05;%dm  \033[00m' $i $i
    fi
    # The length of the resulting string is 6 (be careful if you change it)
    # Plus we'll put 2 spaces between each string
    # So this is how we decide when to put a newline:
    if [ $((8*(i+1-(c/8+c%8/6)*l)+6)) -gt $c ]
    # Remember all divisions are rounded down immediately
    # We add 1 to i because it started from 0
    then l=$((l+1)); echo
    else printf '  '
    fi
    i=$((i+1))
done
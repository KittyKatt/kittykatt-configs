#!/bin/sh

callonexit() {
rm /tmp/sllflash.pid; xset -led named "Scroll Lock";exit
}


if ! [ -e /tmp/sllflash.pid ]; then


trap 'callonexit' 0

echo $$ > /tmp/sllflash.pid
while true; do sleep .5 && xset led named "Scroll Lock" && sleep .5 && xset -led named "Scroll Lock"; done
fi
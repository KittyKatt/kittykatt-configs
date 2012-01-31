#!/bin/bash
echo "Dynamic {"
echo "Submenu = \"`date +'%I:%M'`\" {"
echo "  Entry = \"`date +'%a %d'`\" { Actions = \"Exec roxterm --geometry 65x37+565+0 -e cal -y \" } "
echo "  Entry = \"meteo\" { Actions = \"Exec conky -q -c ~/.pekwm/scripts/conkyrc_weather &\" } "
echo "  Entry = \"news\" { Actions = \"Exec conky -q -c ~/.pekwm/scripts/conkyrc_news &\" } "
echo "}"

#!/usr/bin/python
import time, calendar, re

localtime = time.localtime(time.time())
calendar.setfirstweekday(calendar.SUNDAY)
cal = calendar.month(localtime[0], localtime[1])

parts = cal.split('\n')
cal = '${alignc}${offset -8}' + '\n${offset 37}'.join(parts)

regex = '(?<= )%s(?= )|(?<=\n)%s(?= )|(?<= )%s(?=\n)' % (localtime[2], localtime[2], localtime[2])
replace = '${color 3465A4}%s${color white}' % localtime[2]
newCal = re.sub(regex, replace, cal)
print newCal
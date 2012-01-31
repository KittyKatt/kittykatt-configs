#! /bin/bash
# gmail script for pekwm
# usage
#   Submenu = "Mails" {
#      Entry = "" { Actions = "Dynamic ~/.pekwm/scripts/pekwm_gmail.sh" }
#   }
############################################
gmail_login="zeldarealm"
gmail_password="selene"
dane="$(wget --secure-protocol=TLSv1 --timeout=3 -t 1 -q -O - \
https://${gmail_login}:${gmail_password}@mail.google.com/mail/feed/atom \
--no-check-certificate | grep 'fullcount' \
| sed -e 's/.*<fullcount>//;s/<\/fullcount>.*//' 2>/dev/null)"

echo "Dynamic {"
if [ -z "$dane" ]; then
echo " Entry = \"No connection\" { Actions = \"Exec firefox http://mail.google.com/mail/?hl=fr&amp;shva=1#inbox & \" }"
elif [ $dane = 0 ]; then
echo " Entry = \"$dane\" courrier { Actions = \"Exec firefox http://mail.google.com/mail/?hl=fr&amp;shva=1#inbox & \" }"
elif [ $dane = 1 ]; then
echo " Entry = \"1 mail\" { Actions = \"Exec firefox http://mail.google.com/mail/?hl=fr&amp;shva=1#inbox & \" }"
else
echo " Entry = \"$dane\" mails    { Actions = \"Exec firefox http://mail.google.com/mail/?hl=fr&amp;shva=1#inbox & \" }"
fi
echo "}"
exit

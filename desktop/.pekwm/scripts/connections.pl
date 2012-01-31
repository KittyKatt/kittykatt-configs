#!/usr/bin/perl
################## Active Internet Connections of Netstat v.1.0 #######################
#EXTREMELLY Compressed script to pipe the active internet connections of netstat out to a pekwm
#menu.
#
####How to install ##########
#1.Chmod this file +x
#
#2.Copy this file to your scripts directory ex: /usr/share/pekwm/scripts
#
#3.Finally add the following lines to your pekwm menu config
#
#SubMenu = "Connections" {
#	Entry = { Actions = "Dynamic /usr/share/pekwm/scripts/connections.pl" }
#}
##############################
#
#Made by Bladdo - Bladdo.net - bladdo@bladdo.net(previously Milo - Milo.Psunit.com - TinyTux@gmail.com)
#Feel Free to edit in any way you wish                         
########################################################################################
($parta,$partb) = split(/Active UNIX domain socket/,`netstat`);
($partc,$partd) = split(/State/,$parta);

(@process) = split(/\n/,$partd);



$count = 0;

print "Dynamic {\n";


foreach $temp (@process) {
	$count++;
	

	if ($count eq 1) { } else {
	($a,$b,$c,$d,$f,$h) = split(/ +/,$temp);
	($d,$e) = split(/:/,$d);
	($f,$g) = split(/:/,$f);
	$a =~ s/\b(\w)/\U$1/g;

	print "Submenu = \"$f\" {\n";
		print "Submenu = \"Local\" {\n";
		print "Entry = \"IP:$d\" { Actions = \"Exec \" }\n";
		print "Entry = \"Port:$e\" { Actions = \"Exec \" }\n";
		print "}\n";	
		print "Submenu = \"Remote\" {\n";
		print "Entry = \"IP:$f\" { Actions = \"Exec \" }\n";
		print "Entry = \"Port:$g\" { Actions = \"Exec \" }\n";
		print "}\n";
	print "Entry = \"Proto:$a\" { Actions = \"Exec \" }\n";

	print "}\n";

	}
	
} 


print "}\n";

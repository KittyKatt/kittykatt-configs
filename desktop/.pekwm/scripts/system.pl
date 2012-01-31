#!/usr/bin/perl
################## System PekWM Pipe Menu by Bladdo #######################
#Bunch of system information
#Comment out what you want if you dont want it there
####How to install ##########
#1.Chmod this file +x
#
#2.Copy this file to your scripts directory ex: /usr/share/pekwm/scripts
#
#3.Finally add the following lines to your pekwm menu config
#
#SubMenu = "System" {
#	Entry = { Actions = "Dynamic /usr/share/pekwm/scripts/system.pl" }
#}
##############################################################################
#
#Made by Bladdo - Bladdo.net - Bladdo@bladdo.net
#Feel Free to edit in any way you wish                         
########################################################################################

##starts menu#######
print "Dynamic {\n";

###ram/memory section --> shows used memory###
($parta,$partb) = split(/Mem:/,`free -m`);
($partc,$partd) = split(/^           /,$partb);
($partf,$partg) = split(/        /,$partd);
$partg =~ s/ //g;
print "Submenu = \"Memory\" {\n";
	print "Entry = \"$partg/$partf mb\" { Actions = \"Exec \" }\n";
print "}\n";	
###end ram section################

###processes section ---> shows processes by order of cpu usage###
($pa,$pb) = split(/COMMAND\n/,`ps -e -o pcpu,cpu,nice,state,cputime,args --sort pcpu | sed '/^ 0.0 /d'`);
(@array) = split(/\n/,$pb);

print "Submenu = \"CPU Usage\" {\n";

foreach $temp (@array) {
        $temp =~ s/^ //;
        ($percent,$process) = split(/ .{19}/,$temp);
	if ($process =~ /\//) {
        	($pops,$use) = split(/\/(?!.*\/)/,$process);
	} else {
		$use = $process;
	}	
	print "Entry = \"$use:$percent" . "%\" { Actions = \"Exec \" }\n";

}

print "}\n";	
 
###end processes section############
	

##end dynamic menu##
print "}\n";

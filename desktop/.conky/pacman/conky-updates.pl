#! /usr/bin/perl -w
use strict;
# November 15, 2006
# Daniel Vredenburg (Vredfreak)
# This is a program that checks for package updates for Arch Linux users.

open (MYINPUTFILE, "/home/kittykatt/.conky/pacman/updates.log") or die "No such file or directory: $!";

my $i = 0;
while(<MYINPUTFILE>)
{
        if (/^(.*)\/(.*)(\..*\..*\.)/)  {
                #print " \n";
                $i++;
        }

}
if ($i == 0) {
        print "None Available";
} else {
        print "($i) Available";
}
close(MYINPUTFILE);

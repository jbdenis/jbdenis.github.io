#!/usr/bin/perl -w
#
# 19_10_16
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/phoges";
use phoges; 
use lib "/home/jbdenis/o/info/perl/uie";
use uie;
#
#
my $fifi = "phoges-fiu-stf.txt";
system("cat $fifi > toto.txt");
system("cat $fifi >> toto.txt");
#
system("cat toto.txt");
print ("\n\n"," - "x12,"\n");
#
&uie::check8err(obj=>&phoges::purge8st7f(fil=>"toto.txt",imp=>1));
#
print (" - "x12,"\n");
system("cat toto.txt");
print ("\n\n"," - "x12,"\n");
#
print "-"x4,"End of testing 'purge8st7f'","-"x25,"\n";
#
#############################################

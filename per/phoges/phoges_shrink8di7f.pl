#!/usr/bin/perl -w
#
# 19_10_06 19_10_07
#
use strict;
use warnings;
#
use lib "/home/jbdenis/o/info/perl/phoges";
use phoges; 
#
my $fifi = "phoges-fit";
my $fofo = "toto";
my $ii = 2;
#
&uie::check8err(obj=>&phoges::shrink8di7f(idi=>$fifi,odi=>$fofo,inc=>$ii,new=>0));
#
system "cat $fofo-dif.txt";
#
print "\n","-"x4,"Fin du test de shrink8di7f.pl","-"x25,"\n";
#
#############################################

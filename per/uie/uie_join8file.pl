#!/usr/bin/perl -w
#
# 19_10_06 19_10_11
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/uie";
use uie; 
#
my @fifi = <uie-fi?.txt>;
my $fifi = \@fifi;
my $toto = "toto-o.txt";
&uie::check8err(obj=>&uie::join8file(lfi=>$fifi,ofi=>$toto));
system("less $toto");
#
#
print "-"x4,"test de 'join8file' terminé","-"x25,"\n";
#
# fin du code
#
#############################################

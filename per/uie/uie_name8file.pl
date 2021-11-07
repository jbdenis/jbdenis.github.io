#!/usr/bin/perl -w
#
# 20_01_05
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/uie";
use uie; 
#
my @fifi = ("toto","toto.PNG","toto.tutu.sH");
print length($fifi[1]),"\n";
foreach my $fi (@fifi) { foreach my $ncp (1,2,-1,-2) { foreach my $waa ("YES",[3],[8,11],["AAA",".BB"]) {
    &uie::la(str=>&uie::name8file(ina=>$fi,cpt=>$ncp,wha=>$waa),mes=>"ina = $fi and cpt = $ncp ");
}}}
#
#
print "-"x4,"test de 'file9' terminé","-"x25,"\n";
#
# fin du code
#
#############################################

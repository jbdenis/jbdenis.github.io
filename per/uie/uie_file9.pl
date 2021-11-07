#!/usr/bin/perl -w
#
# 20_01_05
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/uie";
use uie; 
#
my @fifi = ("toto","toto.PNG","toto.sH","toto.ogg");
foreach my $fi (@fifi) {
    &uie::la(str=>&uie::file9(fil=>$fi),mes=>$fi);
}
#
#
print "-"x4,"test de 'file9' terminé","-"x25,"\n";
#
# fin du code
#
#############################################

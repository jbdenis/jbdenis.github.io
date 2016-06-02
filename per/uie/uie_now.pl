#!/usr/bin/perl -w
#
# 16_05_31
#
use strict;
use warnings;
use uie; 
#
my ($quoi,$format,$separateur);
#
for my $wh ("s","d","hms","dhm","ms","ds") {
    print "*"x12," $wh\n";
    for my $fm ("red","long") {
        print " "x15,&uie::now(wha=>$wh,fmt=>$fm),"\n";
    }
}
&uie::pause;
#
#
print "-"x4,"Fin du test de justn","-"x25,"\n";
#
# fin du code
#
#############################################

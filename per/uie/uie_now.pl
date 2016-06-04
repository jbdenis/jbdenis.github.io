#!/usr/bin/perl -w
#
# 16_05_31
#
use strict;
use warnings;
use uie; 
#
print &uie::now(wha=>"ds",fmt=>"long",whe=>[0,16,7,16,10,49]),"\n";;
&uie::pause;
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

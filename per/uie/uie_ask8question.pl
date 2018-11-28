#!/usr/bin/perl -w
#
# 16_03_07 16_03_08 16_03_09 16_03_11 16_03_13
# 16_03_14 16_03_15 16_04_11 16_04_13 16_05_08
# 17_04_04
#
use File::Copy;
use strict;
use uie; 

#
#
print "<<",&uie::ask8question(que=>"a value to be considered numerically?",typ=>1),">>\n"; sleep 1;
print "<<",&uie::ask8question(que=>"a simple string of yours?",typ=>0),">>\n"; sleep 1;
print "<<",&uie::ask8question(que=>"a numerical value again?",typ=>1,
                              fmt=>{apr=>" ::: ",lon=>30}),">>\n"; sleep 1;
print "<<",&uie::ask8question(que=>"another simple string of yours?",typ=>0,
                              fmt=>{ava=>" ::: ",lon=>30,just=>"L"}),">>\n"; sleep 1;
#
print "-"x4,"Fin du test de ask8question","-"x21,"\n";
#
# fin du code
#
#############################################

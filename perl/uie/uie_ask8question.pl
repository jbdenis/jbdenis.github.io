#!/usr/bin/perl -w
#
# 16_03_07 16_03_08 16_03_09 16_03_11 16_03_13
# 16_03_14 16_03_15 16_04_11 16_04_13
#
use File::Copy;
use strict;
use uie; 

#
#
print "<<",&uie::ask8question(ques=>"a value to be considered numerically?",type=>1),">>\n"; sleep 1;
print "<<",&uie::ask8question(ques=>"a simple string of yours?",type=>0),">>\n"; sleep 1;
print "<<",&uie::ask8question(ques=>"a numerical value again?",type=>1,
                              form=>{apres=>" ::: ",long=>30}),">>\n"; sleep 1;
print "<<",&uie::ask8question(ques=>"another simple string of yours?",type=>0,
                              form=>{avant=>" ::: ",long=>30,just=>"L"}),">>\n"; sleep 1;
#
print "-"x4,"Fin du test de ask8question","-"x21,"\n";
#
# fin du code
#
#############################################

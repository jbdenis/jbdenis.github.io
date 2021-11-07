#!/usr/bin/perl -w
#
# 20_01_12
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/uie";
use uie; 
#
#
my $inina = ["aa.bb.cc.dd.ee","AA.BB.CC.DD","ZZ"];
my $forma = ["-1","-1;","-2;","1;-2;2","1&-2&2"];
my $res;
#
for my $nam (@$inina) { for my $form (@$forma) {
    $res = &uie::check8err(obj=>&uie::extract8name(ina=>$nam,fmt=>$form),
                           wha=>1,sig=>"$nam with $form");
    &uie::la(str=>$res,mes=>"$nam WITH $form");
}}
#
print "-"x4,"Fin du test de extract8name","-"x25,"\n";
#
# fin du code
#
#############################################

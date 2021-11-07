#!/usr/bin/perl -w
#
# 18_03_25 19_03_26 19_03_29 19_03_31 19_04_05
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/phoges";
use phoges; 
#
#
my $kol;

for my $type ("IND","COL","cir","ind","col","add") { for my $re (0,1) {
    #&uie::la(str=>&phoges::new7pi(wha=>$type),mes=>$type);
    $kol = &uie::check8err(obj=>&phoges::new7pi(wha=>$type,fil=>$re),wha=>1);
    unless (&uie::err9(obj=>$kol)) { &phoges::print8pi(xpi=>$kol);}
    else { &uie::print8err(err=>$kol);}
    #&uie::la(str=>$kol);
    &uie::pause(mes=>$type." ($re)"); 
}}
#
#
#
print "-"x4,"End of testing 'new7pi'","-"x25,"\n";
#
#############################################

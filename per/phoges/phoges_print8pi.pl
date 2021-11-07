#!/usr/bin/perl -w
#
# 18_03_26
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/phoges";
use phoges; 
#
#
my $kol;
for my $type ("ind","IND","col","COL","cir","bof") {
for my $fil (0,1) {    
    $kol = &phoges::new7pi(wha=>$type,fil=>$fil);
    if (not(&uie::err9(obj=>$kol))) {
        for (0,1) {
            my $ver = &phoges::print8pi(xpi=>$kol,eve=>$_);
            &uie::la(str=>$ver,mes=>"avec type = $type, eve = $_ et fil = $fil");
        }
    } else {
        &uie::print8err(err=>$kol);
    }
    &uie::la(str=>"",mes=>"type = $type"); 
}}
#
#
#
print "-"x4,"End of testing 'print8pi'","-"x25,"\n";
#
#############################################

#!/usr/bin/perl -w
#
# 18_03_25 18_03_26
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
#
my $kol;
for my $type ("ind","col","cir","add") {
    $kol = &uie::check8err(obj=>&phoges::new7pi(wha=>$type),wha=>1);
    &uie::la(str=>$kol,mes=>$type); 
}
#
#
#
print "-"x4,"End of testing 'new7pi'","-"x25,"\n";
#
#############################################

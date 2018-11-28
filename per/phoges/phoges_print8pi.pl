#!/usr/bin/perl -w
#
# 18_03_26
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
#
my $kol;
for my $type ("ind","col","cir","add") {
    $kol = &phoges::new7pi(wha=>$type);
    if (not(&uie::err9(obj=>$kol))) {
        for (0,1) {
            my $ver = &phoges::print8pi(xpi=>$kol,eve=>$_);
            unless ($ver) { &uie::la(str=>$ver,mes=>"pas bon");}
        }
    } else {
        &uie::print8err(err=>$kol);
    }
    &uie::la(str=>"",mes=>"type = $type"); 
}
#
#
#
print "-"x4,"End of testing 'print8pi'","-"x25,"\n";
#
#############################################

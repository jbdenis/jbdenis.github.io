#!/usr/bin/perl -w
#
# 18_01_07
#
use strict;
use jours; 
use lib "/home/jbdenis/liana/info/perl/jours";

# 
for my $y   ("2017_17",
             "1949_10_15",
             "1954_06_24",
             "1954_02_29",
             "1980_06_31",
             "1980_16_31",
             "1980_06",
             "zzzz_06_13"
            ) {
    my $r = &jours::check8day(ymd=>$y);
    print " date = $y \n";
    &uie::print8err(err=>$r);
}
# 
#
print "-"x4,"Fin du test de check8day.pl","-"x25,"\n";
#
#############################################

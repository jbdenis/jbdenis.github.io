#!/usr/bin/perl -w
#
# 18_01_07 18_04_02
#
use strict;
use jours; 
use lib "/home/jbdenis/liana/info/perl/jours";

# 
for my $y   ("1949_10_15|1954_06_24",
             "1954_06_24|1954_05_24",
             "1954_02_29",
             "1954_02_29|",
             "1980_06_31|2000_01_01",
             "1980_16_31|1980_06",
             "zzzz_06_13|1987",
             "zzzz_06_13|"
            ) {
    my $r = &jours::check8tipe(tip=>$y);
    print " time period = $y \n";
    &uie::print8err(err=>$r);
}
# 
#
print "-"x4,"Fin du test de check8tipe.pl","-"x25,"\n";
#
#############################################

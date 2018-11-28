#!/usr/bin/perl -w
#
# 18_01_07
#
use strict;
use jours; 
use lib "/home/jbdenis/liana/info/perl/jours";

# 
for my $y   ("1949_10_15|1949_12_31",
             "1954_01_01|1954_06_24",
             "1949_10_15|1954_06_24",
             "1954_06_24|1954_07_24",
             "1949_10_15|2018_01_08",
             "1949_10_15|1949_10_15",
             "1980_06_24|1980_06_24",
             "1980_12_31|1981_01_01"
            ) {
    my $r = &jours::duration(tip=>$y);
    print " time period = $y ";
    if (not(&uie::err9(obj=>$r))) {
        print " duration = $r days\n";
    } else {
        print "\n";
        &uie::print8err(err=>$r);
    }
}
# 
#
#print "02"+"09","\n";
print "-"x4,"Fin du test de duration","-"x25,"\n";
#
#############################################

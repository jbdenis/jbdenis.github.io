#!/usr/bin/perl -w
#
# 18_01_07 18_04_02
#
use strict;
use jours; 
use lib "/home/jbdenis/liana/info/perl/jours";

# 
for my $y   ("1949","1949_10",
             "1954_01_01",
             "1954_06",
             "2000_02",
             "1900_02",
             "1981",
             "",
             "2018_17"
            ) {
    for my $w (0,1) {
        my $r = &jours::cano8day(day=>$y,war=>$w);
        print " initial day = $y war = $w ";
        if (not(&uie::err9(obj=>$r))) {
            print " final day = <$r>\n";
        } else {
            print "\n";
            &uie::print8err(err=>$r);
        }
    }
}
# 
#
print "-"x4,"Fin du test de cano8day","-"x25,"\n";
#
#############################################

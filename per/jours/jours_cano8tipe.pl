#!/usr/bin/perl -w
#
# 18_01_08 18_04_02
#
use strict;
use jours; 
use lib "/home/jbdenis/liana/info/perl/jours";

# 
for my $y   ("2013_13",
             "",
             "|",
             "1949","1949_10",
             "1954_01_01",
             "2000_02",
             "1900_02",
             "1954_06|1976",
             "1981|",
             "|1981",
            ) {
    my $r = &jours::cano8tipe(tip=>$y);
    print " initial tipe = <$y> ";
    if (not(&uie::err9(obj=>$r))) {
        print " canonical tipe = $r \n";
    } else {
        print "\n";
        &uie::print8err(err=>$r);
    }
    &uie::pause();
}
# 
#
print "-"x4,"Fin du test de cano8day","-"x25,"\n";
#
#############################################

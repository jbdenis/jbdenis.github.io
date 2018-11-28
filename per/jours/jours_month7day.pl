#!/usr/bin/perl -w
#
# 18_01_07
#
use strict;
use jours; 
use lib "/home/jbdenis/liana/info/perl/jours";

# 
for my $y (1956..1980,1900,2000,4000) {
    my $r = &jours::month7day(yyy=>$y);
    print "year = $y => $r days\n";
}
# 
for my $y (1956..1960) { for my $m (1..12) {
    my $r = &jours::month7day(yyy=>$y,mmm=>$m);
    print "year = $y month $m => $r days\n";
}}
print "-"x4,"Fin du test de month7day.pl","-"x25,"\n";
#
#############################################

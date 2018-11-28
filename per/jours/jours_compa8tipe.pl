#!/usr/bin/perl -w
#
# 18_01_08
#
use strict;
use jours; 
use lib "/home/jbdenis/liana/info/perl/jours";

# 
my @s1 = ("|","1949","1949_10","1954_01_01","2000_02","1900_02","1954_06|1976","1981|","|1981");
my @s2 = ("1977_02_23","1980_03_26","1985_01_02","1949");
#
for my $t1 (@s1) { for my $t2 (@s2) {
    my $tt1 = &jours::cano8tipe(tip=>$t1);
    my $tt2 = &jours::cano8tipe(tip=>$t2);
    my $rr1 = &jours::compa8tipe(tp1=>$tt1,tp2=>$tt2);
    my $rr2 = &jours::compa8tipe(tp1=>$tt2,tp2=>$tt1);
    print "($tt1<>$tt2) -> $rr1 | $rr2 \n";
}}
# 
#
print "-"x4,"Fin du test de compa8tipe","-"x25,"\n";
#
#############################################

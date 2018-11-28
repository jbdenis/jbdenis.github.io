#!/usr/bin/perl -w
#
# 17_09_23 17_10_01
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
#
my @noms = ("2013_12_11.oui.jpg","pc11123.jpg","tutu.jpg");
my @dates = ("2000","NON","");
foreach my $n (@noms) { foreach my $d (@dates) {
    my $resu = &phoges::get8date(nam=>$n,tim=>$d);
    print(" ($n and $d) give $resu\n");
}}
#
#
print "-"x4,"Fin de phoges_get8date.pl","-"x25,"\n";
#
# fin du code
#
#############################################

#!/usr/bin/perl -w
#
# 16_04_16
#
use strict;
use warnings;
use uie; 
#
my $fnu;
#
foreach ((-12..12)) {
    print "-"x27,"\n";
    $fnu = &uie::justn(numb=>$_,digi=>3,deci=>5);
    print $fnu," from ",$_,"\n";
    $fnu = &uie::justn(numb=>$_/10,digi=>3,deci=>5);
    print $fnu," from ",$_/10,"\n";
    $fnu = &uie::justn(numb=>$_,digi=>3,deci=>0);
    print $fnu," from ",$_," (avec zéro décimales)\n";
}
#
#
print "-"x4,"Fin du test de justn","-"x25,"\n";
#
# fin du code
#
#############################################

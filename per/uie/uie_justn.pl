#!/usr/bin/perl -w
#
# 16_04_16 16_05_23 16_06_29 17_04_05
#
use strict;
use warnings;
use uie; 
#
print " 9.00 =  ",&uie::justn(num=> 9,   dig=>-1,dec=>2)," ?\n";
print " 9.45 =  ",&uie::justn(num=> 9.45,dig=>-1,dec=>2)," ?\n";
print " 9.45 =  ",&uie::justn(num=> 9.45,dig=>-1,dec=>2)," ?\n";
print "12.34 =  ",&uie::justn(num=>12.34,dig=>-1,dec=>2)," ?\n";
&uie::pause;
#
my ($fnu,$gnu,$hnu,$inu);
#
foreach (-10..10) {
    $fnu = &uie::justn(num=>  $_/10,dec=>0);
    $gnu = &uie::justn(num=> -$_/10,dec=>0);
    $hnu = &uie::justn(num=> $_/100,dec=>1);
    $inu = &uie::justn(num=>-$_/100,dec=>1);
    print "$_ \t: \t($fnu,$gnu) - \t($hnu,$inu)\n";
}
&uie::pause;
#
foreach ((-12..12)) {
    print "-"x27,"\n";
    $fnu = &uie::justn(num=>$_,dig=>3,dec=>5);
    print $fnu," from ",$_,"\n";
    $fnu = &uie::justn(num=>$_/10,dig=>3,dec=>5);
    print $fnu," from ",$_/10,"\n";
    $fnu = &uie::justn(num=>$_,dig=>3,dec=>0);
    print $fnu," from ",$_," (avec zéro décimales)\n";
}
#
#
print "-"x4,"Fin du test de justn","-"x25,"\n";
#
# fin du code
#
#############################################

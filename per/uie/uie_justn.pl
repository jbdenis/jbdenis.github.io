#!/usr/bin/perl -w
#
# 16_04_16 16_05_23
#
use strict;
use warnings;
use uie; 
#
my ($fnu,$gnu,$hnu,$inu);
#
foreach (-10..10) {
    $fnu = &uie::justn(numb=>  $_/10,deci=>0,roun=>1);
    $gnu = &uie::justn(numb=> -$_/10,deci=>0,roun=>1);
    $hnu = &uie::justn(numb=> $_/100,deci=>1,roun=>1);
    $inu = &uie::justn(numb=>-$_/100,deci=>1,roun=>1);
    print "$_ \t: \t($fnu,$gnu) - \t($hnu,$inu)\n";
}
&uie::pause;
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

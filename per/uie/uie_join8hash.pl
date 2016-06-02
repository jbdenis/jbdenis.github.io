#!/usr/bin/perl -w
#
# 16_04_25 16_05_02
#
use strict;
use warnings;
use uie; 
#
my $hhh = { JB => 1949,
            J => 54,
            S => 77,
            Y => 80,
            H => 85
          };
#
#
&uie::print8structure(stru=>$hhh);
print("\n");
my $test;
#
my $f1 = {
          JB => {k=>[10,"c","(",")papapa "],v=>[10,"c","G","G - "]},
           J => {k=>[10,"c","(",")mama "],v=>[10,"c","F","F - "]},
           S => {k=>[10,"c","(",")gag "],v=>[10,"c","g","g - "]},
           H => {k=>[10,"l","(",")fi "],v=>[10,"c","f","f - "]}
         };
$test = &uie::join8hash(hash=>$hhh,sepa=>0,form=>$f1,sepa=>0);
&uie::print8structure(stru=>$test);
&uie::pause(mess=>"Format Spécifique individuel (0)!");
$test = &uie::join8hash(hash=>$hhh,sepa=>0,form=>$f1,sepa=>1);
&uie::print8structure(stru=>$test);
print "  clefs: ",$$test[0],"\n";
print "valeurs: ",$$test[1],"\n";
&uie::pause(mess=>"Format Spécifique individuel (1)!");
$test = &uie::join8hash(hash=>$hhh,sepa=>0,form=>$f1,sepa=>2);
&uie::print8structure(stru=>$test);
&uie::pause(mess=>"Format Spécifique individuel (2)!");
#
my $f2 = {
          k=>[10,"l"," <<",">> "],v=>[10,"r","((",")) - "]
         };
$test = &uie::join8hash(hash=>$hhh,form=>$f2);
&uie::print8structure(stru=>$test);
&uie::pause(mess=>"Format Spécifique commun !");
#
my $hh2 = { JB => undef,
            J => 54,
            S => undef,
            Y => undef,
            H => 85
          };
foreach my $f3 ("k","v","s") {
    $test = &uie::join8hash(hash=>$hhh,form=>$f3);
    &uie::print8structure(stru=>$test);
    $test = &uie::join8hash(hash=>$hh2,form=>$f3);
    &uie::print8structure(stru=>$test);
    &uie::pause(mess=>"Format standard (sans et avec données manquantes) : ".$f3);
}
#
foreach ("k","K","v","V","n","N") {
    $test = &uie::join8hash(hash=>$hhh,orde=>$_);
    &uie::print8structure(stru=>$test);
    &uie::pause(mess=>"ordre des clefs = ".$_);
}
#
$test = &uie::join8hash(hash=>$hhh,orde=>"N",sepa=>1);
&uie::print8structure(stru=>$test);
&uie::pause(mess=>"Et sur différentes composantes...");
#
my $f4 = {
          k=>[12,"r","",":"],v=>[12,"l","",""]
         };
$test = &uie::join8hash(hash=>$hhh,orde=>"N",form=>$f4,sepa=>0);
&uie::print8structure(stru=>$test);
&uie::pause(mess=>"Longueur de 25 et rapprochement");
#
#
#
print "-"x4,"Fin du test de join8hash","-"x25,"\n";
#
# fin du code
#
#############################################

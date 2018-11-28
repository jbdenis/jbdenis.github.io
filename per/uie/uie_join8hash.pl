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
&uie::print8structure(str=>$hhh);
print("\n");
my $test;
#
my $f1 = {
          JB => {k=>[10,"c","(",")papapa "],v=>[10,"c","G","G - "]},
           J => {k=>[10,"c","(",")mama "],v=>[10,"c","F","F - "]},
           S => {k=>[10,"c","(",")gag "],v=>[10,"c","g","g - "]},
           H => {k=>[10,"l","(",")fi "],v=>[10,"c","f","f - "]}
         };
$test = &uie::join8hash(has=>$hhh,fmt=>$f1,sep=>0);
&uie::print8structure(str=>$test);
&uie::pause(mes=>"Format Spécifique individuel (0)!");
$test = &uie::join8hash(has=>$hhh,fmt=>$f1,sep=>1);
&uie::print8structure(str=>$test);
print "  clefs: ",$$test[0],"\n";
print "valeurs: ",$$test[1],"\n";
&uie::pause(mes=>"Format Spécifique individuel (1)!");
$test = &uie::join8hash(has=>$hhh,fmt=>$f1,sep=>2);
&uie::print8structure(str=>$test);
&uie::pause(mes=>"Format Spécifique individuel (2)!");
#
my $f2 = {
          k=>[10,"l"," <<",">> "],v=>[10,"r","((",")) - "]
         };
$test = &uie::join8hash(has=>$hhh,fmt=>$f2);
&uie::print8structure(str=>$test);
&uie::pause(mes=>"Format Spécifique commun !");
#
my $hh2 = { JB => undef,
            J => 54,
            S => undef,
            Y => undef,
            H => 85
          };
foreach my $f3 ("k","v","s") {
    $test = &uie::join8hash(has=>$hhh,fmt=>$f3);
    &uie::print8structure(str=>$test);
    $test = &uie::join8hash(has=>$hh2,fmt=>$f3);
    &uie::print8structure(str=>$test);
    &uie::pause(mes=>"Format standard (sans et avec données manquantes) : ".$f3);
}
#
foreach ("k","K","v","V","n","N") {
    $test = &uie::join8hash(has=>$hhh,ord=>$_);
    &uie::print8structure(str=>$test);
    &uie::pause(mes=>"ordre des clefs = ".$_);
}
#
$test = &uie::join8hash(has=>$hhh,ord=>"N",sep=>1);
&uie::print8structure(str=>$test);
&uie::pause(mes=>"Et sur différentes composantes...");
#
my $f4 = {
          k=>[12,"r","",":"],v=>[12,"l","",""]
         };
$test = &uie::join8hash(has=>$hhh,ord=>"N",fmt=>$f4,sep=>0);
&uie::print8structure(str=>$test);
&uie::pause(mes=>"Longueur de 25 et rapprochement");
#
#
#
print "-"x4,"Fin du test de join8hash","-"x25,"\n";
#
# fin du code
#
#############################################

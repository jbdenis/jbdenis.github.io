#!/usr/bin/perl -w
#
# 16_03_31 16_04_01 16_04_14
#
use warnings;
use strict;
use uie; 
#
# a depth three hash
my $hhh = {a=>1, 
           A=>{b=>2,c=>3,d=>4},
           B=>{C=>{e=>5,f=>6,g=>7},D=>{h=>8,i=>9,j=>0},E=>{}}};

foreach my $prmxv (1..3) { foreach my $prprv (0..1) { foreach my $prinv (0..2) { 
    &uie::print8structure(stru=>$hhh,prpr=>$prprv,prin=>$prinv,prmx=>$prmxv);
    &uie::pause(mess=>"prmx = $prmxv prprv = $prprv  prin = $prinv");
}}}
#
# a depth three array
my $aaa = [1, 
           [2,3,4],
           [[5,6,7],[8,9,0],[]]];

foreach my $prmxv (1..3) { foreach my $prprv (0..1) { foreach my $prinv (0..2) { 
    &uie::print8structure(stru=>$aaa,prpr=>$prprv,prin=>$prinv,prmx=>$prmxv);
    &uie::pause(mess=>"prmx = $prmxv prprv = $prprv  prin = $prinv");
}}}
#
# a simple hash
my $hache = {a=>1,b=>undef,c=>3};
foreach my $pri (0,1) {
    &uie::print8structure(stru=>$hache,prmx=>1,prin=>$pri);
    &uie::pause(mess=>"prin=$pri");
}
&uie::pause(mess=>"A Simple Hash");
# a simple array
&uie::print8structure(stru=>[1..3,undef,5..7]);
&uie::pause(mess=>"A Simple Array");
#
foreach my $prprv (0..1) { foreach my $prinv (0..2) {
    &uie::print8structure(stru=>[1..3],titr=>"variations",prpr=>$prprv,prin=>$prinv);
    &uie::pause(mess=>"prprv = $prprv et prin = $prinv");
}}
#
my $inp = [
           "A",
           ["a","b"],
           [1,2,[11,["ouf","fond"],13]],
           "D"
          ];
foreach my $prmxv (0..5) {
    &uie::print8structure(stru=>$inp,titr=>"plus compliqué",
                          prmx=>$prmxv,prin=>1);
    &uie::pause(mess=>"Emboîtement de vecteurs prmx=$prmxv");
}
#
&uie::print8structure("HELP");
&uie::pause(mess=>"Aide en Ligne");
#
&uie::print8structure(stru=>[1..5],titr=>"de un à cinq");
&uie::pause(mess=>"Un simple vecteur");
#
foreach my $titi (0..2) { foreach my $depr (0..1) {
print "depr = $depr \n";
    &uie::print8structure(stru=>$inp,titr=>"variations",prpr=>$depr,prin=>$titi);
    &uie::pause(mess=>"idem avec num = $depr et paren = $titi");
}}
#
my $inq = [
           "A",
           ["a","b"],
           [1,2,[11,{K1=>"ouf",K2=>"fond"},13,\5,\4]],
           undef,
           "D"
          ];
&uie::print8structure(stru=>$inq,titr=>"encore plus compliqué");
&uie::pause(mess=>"incluant aussi un hash, deux scalaires et une valeur non définie");
&uie::print8structure(stru=>$inq,titr=>"le même",addi=>1);
&uie::pause(mess=>"avec nouvelle ligne");
#
print "-"x4,"Fin de uie_print8structure","-"x25,"\n";
#
# fin du code
#
#############################################

#!/usr/bin/perl -w
#
# 16_03_31 16_04_01 16_04_14 16_08_13 17_04_03
# 17_04_05
#
use warnings;
use strict;
use uie; 
#
# an empty array
my $sa = [];
&uie::print8structure(str=>$sa,pri=>2);
&uie::pause(mes=>"Empty Array");
#
# an empty hash
my $sh = {};
&uie::print8structure(str=>$sh,pri=>2);
&uie::pause(mes=>"Empty Hash");
#
# a depth three hash
my $hhh = {a=>1, 
           A=>{b=>2,c=>3,d=>4},
           B=>{C=>{e=>5,f=>6,g=>7},D=>{h=>8,i=>9,j=>0},E=>{}}};

foreach my $prmxv (1..3) { foreach my $prprv (0..1) { foreach my $prinv (0..2) { 
    &uie::print8structure(str=>$hhh,prp=>$prprv,pri=>$prinv,prm=>$prmxv);
    &uie::pause(mes=>"prmx = $prmxv prprv = $prprv  prin = $prinv");
}}}
#
# a depth three array
my $aaa = [1, 
           [2,3,4],
           [[5,6,7],[8,9,0],[]]];

foreach my $prmxv (1..3) { foreach my $prprv (0..1) { foreach my $prinv (0..2) { 
    &uie::print8structure(str=>$aaa,prp=>$prprv,pri=>$prinv,prm=>$prmxv);
    &uie::pause(mes=>"prmx = $prmxv prprv = $prprv  prin = $prinv");
}}}
#
# a simple hash
my $hache = {a=>1,b=>undef,c=>3};
foreach my $pri (0,1) {
    &uie::print8structure(str=>$hache,prm=>1,pri=>$pri);
    &uie::pause(mes=>"prin=$pri");
}
&uie::pause(mes=>"A Simple Hash");
# a simple array
&uie::print8structure(str=>[1..3,undef,5..7]);
&uie::pause(mes=>"A Simple Array");
#
foreach my $prprv (0..1) { foreach my $prinv (0..2) {
    &uie::print8structure(str=>[1..3],prp=>$prprv,pri=>$prinv);
    &uie::pause(mes=>"prprv = $prprv et prin = $prinv");
}}
#
my $inp = [
           "A",
           ["a","b"],
           [1,2,[11,["ouf","fond"],13]],
           "D"
          ];
foreach my $prmxv (0..5) {
    &uie::print8structure(str=>$inp,
                          prm=>$prmxv,pri=>1);
    &uie::pause(mes=>"Emboîtement de vecteurs prmx=$prmxv");
}
#
&uie::print8structure("HELP");
&uie::pause(mes=>"Aide en Ligne");
#
&uie::print8structure(str=>[1..5]);
&uie::pause(mes=>"Un simple vecteur");
#
foreach my $titi (0..2) { foreach my $depr (0..1) {
print "depr = $depr \n";
    &uie::print8structure(str=>$inp,prp=>$depr,pri=>$titi);
    &uie::pause(mes=>"idem avec num = $depr et paren = $titi");
}}
#
my $inq = [
           "A",
           ["a","b"],
           [1,2,[11,{K1=>"ouf",K2=>"fond"},13,\5,\4]],
           undef,
           "D"
          ];
&uie::print8structure(str=>$inq);
&uie::pause(mes=>"incluant aussi un hash, deux scalaires et une valeur non définie");
&uie::print8structure(str=>$inq);
&uie::pause(mes=>"avec nouvelle ligne");
#
print "-"x4,"Fin de uie_print8structure","-"x25,"\n";
#
# fin du code
#
#############################################

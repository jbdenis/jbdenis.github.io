#!/usr/bin/perl -w
#
# 17_11_18
#
use warnings;
use strict;
use uie; 
#
my ($deb,$fin);
#
$deb = {1=>"un",2=>"deux","trois"=>3};
&uie::print8structure(str=>$deb);
$fin = &uie::write8structure(str=>$deb,fil=>"toto.txt");
$fin = &uie::write8structure(str=>$deb);
&uie::pause(mes=>"simple hash");
#
$deb = [1,2,"trois"];
&uie::print8structure(str=>$deb);
$fin = &uie::write8structure(str=>$deb);
&uie::pause(mes=>"simple array");
#
$deb = [[[1,2,3],4,5],[6,7],8,9];
&uie::print8structure(str=>$deb);
$fin = &uie::write8structure(str=>$deb);
&uie::pause(mes=>"stacked arrays");
#
$deb = "COUAC";
&uie::print8structure(str=>$deb);
$fin = &uie::write8structure(str=>$deb);
&uie::pause(mes=>"a simple string");
#
$deb = {};
&uie::print8structure(str=>$deb);
$fin = &uie::write8structure(str=>$deb);
&uie::pause(mes=>"Empty Hash");
#
$deb = {a=>1, 
        A=>{b=>2,c=>3,d=>4},
        B=>{C=>{e=>5,f=>6,g=>7},D=>{h=>8,i=>9,j=>0},E=>{}}};
&uie::print8structure(str=>$deb);
$fin = &uie::write8structure(str=>$deb);
&uie::pause(mes=>"Nested hashes");
#
# a depth three array
$deb = [1, 
           [2,3,4],
           [[5,6,7],[8,9,0],[]]];
&uie::print8structure(str=>$deb);
$fin = &uie::write8structure(str=>$deb);
&uie::pause(mes=>"Three level with modification");
#
print "-"x4,"Fin de uie_write8structure","-"x25,"\n";
#
# fin du code
#
#############################################

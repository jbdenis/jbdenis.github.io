#!/usr/bin/perl -w
#
# 17_10_05 17_10_06
#
use warnings;
use strict;
use uie; 
#
my ($deb,$fin);
$deb = [[[1,2,3],4,5],[6,7],8,9];
$fin = &uie::copy8structure(str=>$deb);
&uie::print8structure(str=>$deb);
&uie::print8structure(str=>$fin);
&uie::pause(mes=>"stacked arrays");
#
$deb = "COUAC";
$fin = &uie::copy8structure(str=>$deb);
&uie::print8structure(str=>$deb);
&uie::print8structure(str=>$fin);
&uie::pause(mes=>"a simple string");
#
$deb = {};
$fin = &uie::copy8structure(str=>$deb);
&uie::print8structure(str=>$deb);
&uie::print8structure(str=>$fin);
&uie::pause(mes=>"Empty Hash");
#
$deb = {a=>1, 
        A=>{b=>2,c=>3,d=>4},
        B=>{C=>{e=>5,f=>6,g=>7},D=>{h=>8,i=>9,j=>0},E=>{}}};
$fin = &uie::copy8structure(str=>$deb);
&uie::print8structure(str=>$deb);
&uie::print8structure(str=>$fin);
&uie::pause(mes=>"Nested hashes");
#
#
# a depth three array
$deb = [1, 
           [2,3,4],
           [[5,6,7],[8,9,0],[]]];
$fin = &uie::copy8structure(str=>$deb);
$deb->[2]->[2] = "modified";
&uie::print8structure(str=>$deb);
&uie::print8structure(str=>$fin);
&uie::pause(mes=>"Three level with modification");
#
print "-"x4,"Fin de uie_copy8structure","-"x25,"\n";
#
# fin du code
#
#############################################

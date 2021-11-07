#!/usr/bin/perl -w
#
# 17_04_11 17_05_08 17_12_08 19_02_19
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/uie";
use uie; 
#
my $resu; my $init;
#
my $kwd3 = {"y"=>"Y","e"=>"E",a=>"A",o=>"O",i=>"I"};
$init = "je n'y crois pas";
&uie::pause(mes=>"$init -> ".&uie::replace8string(str=>$init,kwd=>$kwd3));
#
my $kwd0 = {"À"=>"&Agrave;","Ù"=>"&Ugrave;",a=>"<A>",e=>"<E>",u=>"<Y>"};
$init = "À BOÙT : jaune";
&uie::pause(mes=>"$init -> ".&uie::replace8string(str=>$init,kwd=>$kwd0));
#
my $arr1 = ["il f_#a#_ut","que je me f_#a#_sse","à cette idée","bien util_#e#_"," ","","s'il en ait"];
my $kwd1 = {a=>"AA",e=>"EE"};
&uie::print8structure(str=>$arr1);
my $brr1 = &uie::replace8string(str=>$arr1,kwd=>$kwd1,bef=>"_#",aft=>"#_");
&uie::print8structure(str=>$brr1);
&uie::pause;
#
$arr1 = ["il f<<a>>ut","que je me f<<a>>sse","à cette idée","bien util<<e>>"," ","","s'il en ait"];
$kwd1 = {a=>"AA",e=>"EE"};
&uie::print8structure(str=>$arr1);
$brr1 = &uie::replace8string(str=>$arr1,kwd=>$kwd1,bef=>"<<",aft=>">>");
&uie::print8structure(str=>$brr1);
&uie::pause;
#
my $arr2 = "Bonjour <prénom> <nom>, puis-je vous rappeler votre cotisation ?";
my $kwd2 = {"<nom>"=>"MARTIN","<prénom>"=>"Julienne"};
&uie::print8structure(str=>$arr2);
my $brr2 = &uie::replace8string(str=>$arr2,kwd=>$kwd2);
&uie::print8structure(str=>$brr2);
&uie::pause;
#
print "-"x4,"Fin du test de replace8string","-"x25,"\n";
#
# fin du code
#
#############################################

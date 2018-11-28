#!/usr/bin/perl -w
#
# 16_09_02 17_04_05
#
use strict;
use warnings;
use uie; 
#
my $resu;
#
my $str5 = "  il faut  //  que je me fasse // à cette  [[idée // bien utile s'il en ait//!";
print "<$str5>\n";
$resu = &uie::split8string(str=>$str5,sep=>"//",err=>0);
&uie::print8structure(str=>\$resu);
&uie::pause(mes=>"erreur provoquée sur non fermeture d'encadrement");
#
my $str2 = "a b c\"d e\"f g h\"i j k\"l m\" n o p q r s t\"!";
print "<$str2>\n";
$resu = &uie::split8string(str=>$str2,enc=>['"','"']);
&uie::print8structure(str=>$resu);
&uie::pause(mes=>"encadrement par des guillemets");
#
my $str1 = "  il faut   que je me fasse [[ à cette  idée ]] bien [[utile]] [[s'il en ait]]!";
print "<$str1>\n";
$resu = &uie::split8string(str=>$str1);
&uie::print8structure(str=>$resu);
&uie::pause;
#
my $str3 = "  il faut   que je me fasse \" à cette  idée \" bien \"utile\" \"s'il en ait\"!";
print "<$str3>\n";
$resu = &uie::split8string(str=>$str3,enc=>undef);
&uie::print8structure(str=>$resu);
&uie::pause(mes=>"juste des blancs");
#
my $str4 = "  il faut  //  que je me fasse // à cette  idée // bien utile s'il en ait//!";
print "<$str4>\n";
$resu = &uie::split8string(str=>$str4,enc=>undef,sep=>"//");
&uie::print8structure(str=>$resu);
&uie::pause(mes=>"avec les séparateurs '//'");
#
#
print "-"x4,"Fin du test de split8string","-"x25,"\n";
#
# fin du code
#
#############################################

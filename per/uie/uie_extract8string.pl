#!/usr/bin/perl -w
#
# 16_09_06 16_09_22 20_01_13
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/uie";
use uie; 
my ($resu,$resv);
#
my $str0 = "  il faut   que je me fasse[à cette  idée]bien [utile] [s'il en ait]!";
$str0 = "moment[o]difficile[1]vraiment";
$resu = &uie::extract8string(str=>$str0,enc=>['[',']']);
$resv = &uie::extract8string(str=>$str0,enc=>['[',']'],wit=>0);
print "<$str0>\n";
&uie::print8structure(str=>$resu);
&uie::print8structure(str=>$resv);
&uie::pause;
#
my $str1 = "  il faut   que je me fasse [[ à cette  idée ]] bien [[utile]] [[s'il en ait]]!";
$resu = &uie::extract8string(str=>$str1,enc=>['[[',']]']);
$resv = &uie::extract8string(str=>$str1,enc=>['[[',']]'],wit=>0);
print "<$str1>\n";
&uie::print8structure(str=>$resu);
&uie::print8structure(str=>$resv);
&uie::pause;
#
my $str2 = "  il faut   que je me fasse \" à cette  idée \" bien \"utile\" \"s'il en ait\"!";
$resu = &uie::extract8string(str=>$str2,enc=>['"','"']);
$resv = &uie::extract8string(str=>$str2,enc=>['"','"'],wit=>0);
print "<$str2>\n";
&uie::print8structure(str=>$resu);
&uie::print8structure(str=>$resv);
&uie::pause;
#
my $str4 = "  il faut  //  que je me fasse // à cette  idée // bien utile s'il en ait//!";
$resu = &uie::extract8string(str=>$str4,enc=>["//","//"]);
$resv = &uie::extract8string(str=>$str4,enc=>["//","//"],wit=>0);
print "<$str4>\n";
&uie::print8structure(str=>$resu);
&uie::print8structure(str=>$resv);
&uie::pause;
#
my $str5 = "  il faut  []  que je me fasse [ à cette  'idée ][ bien utile s'il en ait][!";
$resu = &uie::extract8string(str=>$str5,err=>0);
$resv = &uie::extract8string(str=>$str5,err=>0,wit=>0);
print "<$str5>\n";
&uie::print8structure(str=>$resu);
&uie::print8structure(str=>$resv);
&uie::pause;
#
#
print "-"x4,"Fin du test de extract8string","-"x25,"\n";
#
# fin du code
#
#############################################

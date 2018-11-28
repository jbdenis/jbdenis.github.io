#!/usr/bin/perl -w
#
# 17_10_12 17_10_13
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
my $res;
#
my $cha = "{{un deux trois deux   quatre}}";
$res = &phoges::str2kwd(str=>$cha);
&uie::print8structure(str=>$res);
&uie::pause(mes=>"une simple chaîne");
#
my $st1 = ["a","b","c","b","b"," ","w"];
$res = &phoges::str2kwd(str=>$st1);
&uie::print8structure(str=>$res);
&uie::pause(mes=>"une petite structure");
#
my $st2 = ["a z","b z e d c","c","b","b"," ","w"];
$res = &phoges::str2kwd(str=>$st2);
&uie::print8structure(str=>$res);
&uie::pause(mes=>"une moyenne structure");
#
my $st3 = ["a z","b [[z e d]] c","c","b","b"," ","w"];
$res = &phoges::str2kwd(str=>$st3);
&uie::print8structure(str=>$res);
&uie::pause(mes=>"a structure with a multiwords key");
#
my $st4 = [" a z [[  a z ]]","b [[z e d]] [[c]] [[a z]]","[[c ]]","b","[[b z]]"," ","w"];
$res = &phoges::str2kwd(str=>$st4);
&uie::print8structure(str=>$res);
&uie::pause(mes=>"a structure with multiwords keys");
#
#
print "-"x4,"Fin du test de str2kwd","-"x25,"\n";
#
#############################################

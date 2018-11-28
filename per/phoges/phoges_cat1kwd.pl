#!/usr/bin/perl -w
#
# 17_12_22
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
my ($res,$cha);
#
$cha = "[[1 2]] [[ma préférée]] [[ville sous la mer]] deux encore fl vc";
$res = &phoges::cat1kwd(c1k=>$cha,cat=>["fl","deux"]);
print "<<<$cha>>>\n";
&uie::print8structure(str=>$res);
&uie::pause(mes=>"a complexe case");
#
$cha = "un deux trois deux   quatre";
$res = &phoges::cat1kwd(c1k=>$cha);
print "<<<$cha>>>\n";
&uie::print8structure(str=>$res);
&uie::pause(mes=>"only keywords");
#
$cha = "a zb [[z e d]] c   w";
$res = &phoges::cat1kwd(c1k=>$cha);
print "<<<$cha>>>\n";
&uie::print8structure(str=>$res);
&uie::pause(mes=>"a structure with a multiwords key");
#
$cha = "a zb [[z e d]] c   w e ";
$res = &phoges::cat1kwd(c1k=>$cha,cat=>["e","zb"]);
print "<<<$cha>>>\n";
&uie::print8structure(str=>$res);
&uie::pause(mes=>"a structure with a multiwords key and categories");
#
#
#
print "-"x4,"Fin du test de cat1kwd","-"x25,"\n";
#
#############################################

#!/usr/bin/perl -w
#
# 18_03_26 18_03_27
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
#
my $pi6 = {"y"=>"add",k=>[[]]};
&uie::la(str=>$pi6);
my $re6 = &phoges::check8pi(xpi=>$pi6);
&uie::la(str=>$re6,mes=>"Le Résultat");
#
my $pi1 = {"y"=>"cir",l=>2,c=>"Un Beau Titre"};
&uie::la(str=>$pi1);
my $re1 = &phoges::check8pi(xpi=>$pi1);
&uie::la(str=>$re1,mes=>"Le Résultat");
#
my $pi2 = &phoges::new7pi(wha=>"cir");
&uie::la(str=>$pi2);
my $re2 = &phoges::check8pi(xpi=>$pi2);
&uie::print8err(err=>$re2);
&uie::la(str=>$re2,mes=>"Le Résultat");
#
my $pi3 = &phoges::new7pi(wha=>"add");
&uie::la(str=>$pi3);
my $re3 = &phoges::check8pi(xpi=>$pi3);
&uie::print8err(err=>$re3);
&uie::la(str=>$re3,mes=>"Le Résultat");
#
my $pi4 = &phoges::new7pi(wha=>"ind");
&uie::la(str=>$pi4);
my $re4 = &phoges::check8pi(xpi=>$pi4);
&uie::print8err(err=>$re4);
&uie::la(str=>$re4,mes=>"Le Résultat");
#
my $pi5 = &phoges::new7pi(wha=>"col");
&uie::la(str=>$pi5);
my $re5 = &phoges::check8pi(xpi=>$pi5);
&uie::print8err(err=>$re5);
&uie::la(str=>$re5,mes=>"Le Résultat");
#
#
#
print "-"x4,"End of testing 'check8pi'","-"x25,"\n";
#
#############################################

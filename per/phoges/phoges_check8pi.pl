#!/usr/bin/perl -w
#
# 18_03_26 18_03_27 19_03_31 19_04_01
#
use strict;
use warnings;
#
use lib "/home/jbdenis/o/info/perl/phoges";
use phoges; 
#
my $pi5 = &phoges::new7pi(wha=>"COL");
$pi5->{c} = [["ENFIN","pas trop tôt !"],["déjà"],["attends","fini"]];
$pi5->{m} = [["Je m'étais mal réveillé ce jour-là..."],[""],["SI"]];
$pi5->{p} = [["Magny-En-Vexin,Estreez"],["Archemont"],[""]];
$pi5->{q} = [["jbd"]];
$pi5->{k} = [["un","deux"]];
$pi5->{g} = [[""]];
$pi5->{d} = "../../ori";
&uie::la(str=>$pi5);
my $re5 = &phoges::check8pi(xpi=>$pi5);
&uie::la(str=>$re5,mes=>"pi5");
#
$pi5 = &phoges::new7pi(wha=>"col");
$pi5->{c} = ["ENFIN"];
$pi5->{m} = ["Je m'étais mal réveillé ce jour-là..."];
$pi5->{p} = ["Magny-En-Vexin"];
$pi5->{q} = ["jbd"];
$pi5->{k} = ["un","deux"];
$pi5->{g} = [""];
$pi5->{d} = "../../ori";
&uie::la(str=>$pi5);
$re5 = &phoges::check8pi(xpi=>$pi5,whi=>"ind");
&uie::la(str=>$re5,mes=>"pi5");
#
my $pi4 = &phoges::new7pi(wha=>"ind");
$pi4->{d} = "Aujourd'hui";
$pi4->{m} = ["Je le croyais sympathique","Enfin jusqu'à ce jour !"];
$pi4->{c} = ["Un titre oublié"];
&uie::la(str=>$pi4);
my $re4 = &phoges::check8pi(xpi=>$pi4);
&uie::la(str=>$re4,mes=>"pi4");
#
$pi4 = &phoges::new7pi(wha=>"ind");
$pi4->{d} = "Aujourd'hui";
$pi4->{m} = ["Je le croyais sympathique","Enfin jusqu'à ce jour !"];
&uie::la(str=>$pi4);
$re4 = &phoges::check8pi(xpi=>$pi4);
&uie::la(str=>$re4,mes=>"pi4");
#
my $pi4b = &uie::copy8structure(str=>$pi4);
$pi4b->{m} = "Je le croyais sympathique//Enfin jusqu'à ce jour !";
&uie::la(str=>$pi4b);
$re4 = &phoges::check8pi(xpi=>$pi4b);
&uie::la(str=>$re4,mes=>"pi4b");
#
my $pi6 = {"y"=>"add",k=>[[]]};
&uie::la(str=>$pi6);
my $re6 = &phoges::check8pi(xpi=>$pi6);
&uie::la(str=>$re6,mes=>"pi6");
#
my $pi1 = {"y"=>"cir",l=>2,C=>"Un Beau Titre"};
&uie::la(str=>$pi1);
my $re1 = &phoges::check8pi(xpi=>$pi1);
&uie::la(str=>$re1,mes=>"pi1");
#
my $pi2 = &phoges::new7pi(wha=>"cir");
&uie::la(str=>$pi2);
my $re2 = &phoges::check8pi(xpi=>$pi2);
&uie::la(str=>$re2,mes=>"pi2");
#
#
#
print "-"x4,"End of testing 'check8pi'","-"x25,"\n";
#
#############################################

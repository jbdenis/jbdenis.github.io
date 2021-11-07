#!/usr/bin/perl -w
#
# 19_03_03 19_03_04 19_03_05 19_09_19
#
# introducing l7e in lhattmel was a fight to allow
# latex accept my usual way of naming picture file
# comprising "aaaa_mm_dd" date since underscore is
# understood as the start of a sub-index in math mode.
# Also, I was pleased to be able to use '&' in text.
#
use strict;
use warnings;
use File::Copy;
use lib "/home/jbdenis/o/info/perl/lhattmel";
use lhattmel; 
#
my $test1 = 'Le 2019_03_04, il a bien fallu voir que Paul & Pierre étaient amis \!\!';
#print $test1,"\n";
my $resu1 = &lhattmel::l7e(cha=>$test1);
#&uie::la(str=>$resu1,mes=>"resu1");
#
my $test2 = ['Le 2019_03_04, il a bien fallu voir que Paul & Pierre étaient amis \!\!',
	     'Les charactères spéciaux de Latex sont :   & % $ # _ { } ~ ^ \ ',
             'Seront-il bien traduits ?'];
my $test3 = ['Ici, je fais un paragraphe qui comprend des sauts de lignes\newlinequi doivent \newlineêtre \newline respectés \newline !!! Là',
             'La ligne ci-dessus (entre "Ici" et "Là") devrait comprendre 4 passages à la ligne.'];
#&uie::la(str=>$test2,mes=>"test2");
my $resu2 =  &lhattmel::l7e(cha=>$test2);
#&uie::la(str=>$test2,mes=>"test2");
#&uie::la(str=>$resu2,mes=>"resu2");
my $para = {tit=>"19_03_05",aut=>"J&JB S & Y & H",par=>["Oui & Non"]};
#
# starting a document with an image
#
my $sou = [];
push @$sou, @{&lhattmel::start(par=>$para)};
push @$sou, @{&lhattmel::subtit(tit=>$test1)};
push @$sou, @{&lhattmel::parag(prg=>[$test1])};
push @$sou, @{&lhattmel::parag(prg=> $test2 )};
push @$sou, @{&lhattmel::parag(prg=> $test3 )};
push @$sou, @{&lhattmel::subtit(tit=>"Two small pictures",lev=>2)};
#
my $fim = "2000_01_01.toto.jpg";
unless (copy("i44.jpg",$fim)) { die ("pas possible de copier i44.jpg en $fim");}
my $ima = [{fil=>$fim}];
#my $ima = [{fil=>"i44.jpg"}];
push @$sou, @{lhattmel::picture1item(ima=>$ima)};
#
push @$sou, @{&lhattmel::end()};
#
#
open(TOTO,">","toto.tex");
foreach (@$sou) { print TOTO $_,"\n";}
close(TOTO);
if (system("pdflatex toto.tex")) {
    print "Compilation latex non réussie !\n";
    print "Le source est dans toto.tex\n";
    die;
} else {
    print "HAVE A LOOK TO 'toto.pdf'\n";
}

print "-"x4,"End of lhattmel_l7e.pl","-"x25,"\n";
#
#############################################

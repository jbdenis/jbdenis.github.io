#!/usr/bin/perl -w
#
# 18_02_06 18_04_08
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/lhattmel";
use lhattmel; 
#
my ($para,$sou,@res,$liste);
my $test = "toto";
$para = {tit=>"Pour COMMENCER"};
$liste = "un;;premier;;deux;;second;;trois;;dernier";
foreach my $typ ("l","h") {
    $sou = [];
    push @$sou, @{&lhattmel::start(par=>$para,typ=>$typ)};
    push @$sou, @{&lhattmel::subtit(tit=>"Première Partie",typ=>$typ)};
    push @$sou, @{&lhattmel::parag(prg=>["Tout bon texte doit comprendre une introduction"],
                                   typ=>$typ)};
    for my $lt ("B","N","D","b","n","d") {
        push @$sou, @{&lhattmel::parag(prg=>["<<$lt>>","LISTE$lt ".$liste],typ=>$typ)};
    }
    push @$sou, @{&lhattmel::subtit(tit=>"introduction",lev=>2,typ=>$typ)};
    push @$sou, @{&lhattmel::parag(prg=>["Une bonne introduction annonce la suite.",
                                         "Mais elle ne doit pas dévoiler le contenu du texte.",
                                         "Celui-si est réservé au développement !"],
                                   typ=>$typ)};
    push @$sou, @{&lhattmel::subtit(tit=>"développement",lev=>2,typ=>$typ)};
    push @$sou, @{&lhattmel::subtit(tit=>"conclusion",lev=>2,typ=>$typ)};
    push @$sou, @{&lhattmel::subtit(tit=>"Considérations Générales",typ=>$typ)};
    push @$sou, @{&lhattmel::end(typ=>$typ)};
    if ($typ eq "l") {
	open(TOTO,">","$test.tex");
	foreach (@$sou) { print TOTO $_,"\n";}
	close(TOTO);
	if (system("pdflatex $test.tex $test.pdf")) {
	    print "Compilation latex non réussie !\n";
	    print "Le source est dans $test.tex\n";
	    die;
        }
    } else {
	open(TOTO,">","$test.html");
	foreach (@$sou) { print TOTO $_,"\n";}
	close(TOTO);
    }
}
#
system("ls -lrt $test.*");
#
#
#
print "-"x4,"End of lhattmel_start.pl","-"x25,"\n";
#
#############################################

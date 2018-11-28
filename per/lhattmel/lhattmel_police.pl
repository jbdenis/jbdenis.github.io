#!/usr/bin/perl -w
#
# 18_02_10
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/lhattmel";
use lhattmel; 
#
my ($para,$sou,@res);
my $test = "toto";
$para = {tit=>"Pour COMMENCER"};
my $li1 = ["L'avantage _*principal*_ d'être le premier est que les autres sont derrière vous, ils ne peuvent donc pas vous bloquer ! Maintenant, il y a aussi _+quelques+_ inconvénients. Par exemple, vous ne pouvez pas les surveiller et vous rendre compte s'ils complotent ou pas _%quelque chose contre vous%_...","second","troisième"];
my $li2 = ["tree","_*good*_ morning","singe hurleur"];
foreach my $typ ("l","h") {
    $sou = [];
    push @$sou, @{&lhattmel::start(par=>$para,typ=>$typ)};
    push @$sou, @{&lhattmel::subtit(tit=>"_*Première*_ Partie",typ=>$typ)};
    push @$sou, @{&lhattmel::parag(prg=>["Tout bon texte doit comprendre une introduction"],
                                   typ=>$typ)};
    push @$sou, @{&lhattmel::subtit(tit=>"introduction",lev=>2,typ=>$typ)};
    push @$sou, @{&lhattmel::parag(prg=>["Une bonne introduction annonce la suite.",
                                         "Mais elle ne doit pas dévoiler le contenu du texte.",
                                         "Celui-si est réservé au développement !"],
                                   typ=>$typ)};
    push @$sou, @{&lhattmel::subtit(tit=>"développement",lev=>2,typ=>$typ)};
    push @$sou, @{&lhattmel::list(lst=>$li1,tli=>"b",typ=>$typ)};
    push @$sou, @{&lhattmel::subtit(tit=>"conclusion",lev=>2,typ=>$typ)};
    push @$sou, @{&lhattmel::list(lst=>$li1,tli=>"n",typ=>$typ)};
    push @$sou, @{&lhattmel::subtit(tit=>"Considérations Générales",typ=>$typ)};
    push @$sou, @{&lhattmel::list(lst=>$li1,lna=>$li2,tli=>"d",typ=>$typ)};
    push @$sou, @{&lhattmel::end(typ=>$typ)};
    $sou = &lhattmel::police(txt=>$sou,typ=>$typ);
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

#!/usr/bin/perl -w
#
# 18_02_13 18_02_21 18_03_09 18_04_04 18_04_06
# 18_10_01 18_10_02 18_10_04 18_10_13
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/phoges";
use phoges; 
use lib "/home/jbdenis/o/info/perl/lhattmel";
use lhattmel; 
#
my ($fifi,$res,$fofo);
#
$fifi = "phoges-fiq";
$res = &uie::check8err(obj=>&phoges::di7f2tex1htm(dif=>$fifi,
                                                 cap=>"mtpqkgI"));
system("pdflatex $fifi-dif.tex");
my $fresu = $fifi."-dif.pdf";
print "Have a look to $fifi-dif.pdf\n";
die("FINI : à retirer à la fin");
#
$fifi = "phoges-fin";
$fofo = "toto.txt";
if (-e $fofo) {
    unless (unlink($fofo)) {
        pause(mes=>"Unable to destroy $fofo !");
        exit 0;
    }
}
$res = &uie::check8err(obj=>&phoges::di7f2tex1htm(dif=>$fifi,
                                                  ppa=>{aut=>"Madelon",two=>1,nus=>1,red=>0.8,
                                                        cfraon => "Le nom du fichier est",
                                                        cfracp => "...c'était le lieu!",
                                                        cfraom => "(((",
                                                        cfracm => ")))",
                                                        sepbq => "-+-",gilab=> 1
                                                       },
                                                 cap=>"mtpqkgI"));
print ("\n\nres = $res\n\n");
#&uie::pause(mes=>"Avant le pdf");
system("pdflatex phoges-fin-dif.tex");
my $fresu = $fifi."-dif.pdf";
print "Have a look to $fresu\n";
#
#&uie::pause(mes=>"The test of the html result was not yet made");
print "-"x54,"\n";
print "-"x4,"Fin du test de di7f2tex1htm.pl","-"x25,"\n";
print "-"x54,"\n";
#
#############################################

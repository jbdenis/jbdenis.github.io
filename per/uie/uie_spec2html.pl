#!/usr/bin/perl -w
#
# 17_04_22 17_04_29 17_12_06
#
use strict;
use warnings;
use uie; 
#
my $resu;
#
my $texte = "À savoir qu'en Français, les caractères sont compliqués: œufs.";
&uie::pause(mes=>&uie::spec2html(str=>$texte,htm=>1));
#
#
# transforming some files for other testing
if (0) {
    foreach my $ff ("9","b") {
        open(UU,"<","uie-fi${ff}.txt" ) or die("erreur 1");
        open(VV,">","uie-fi${ff}b.txt") or die("erreur 2");
        while (<UU>) {
            my $tt = &uie::spec2html(str=>$_);
            print VV $tt;
        }
        close(UU); close(VV);
    }
    die("Transfo Finie");
}
#
print "-"x4,"Fin du test de spec2html","-"x25,"\n";
#
# fin du code
#
#############################################

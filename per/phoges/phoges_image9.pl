#!/usr/bin/perl -w
#
# 18_03_16 19_02_01
#
use strict;
use warnings;
#
use lib "/home/jbdenis/o/info/perl/phoges";
use phoges; 
#
my @lignes = (
              "toto.jpg",
              "2018_03_16.boudu.png",
              "{<",
              "phoges-pic03.jpg"
             );
#
foreach my $tou ("","e","s","S","o","tout") {
    foreach my $lig (@lignes) {
	my $res = &phoges::image9(ifi=>$lig,out=>$tou);
	&uie::la(str=>$res,mes=>$lig." avec $tou");
    }
}
#
#
print "-"x4,"Fin de phoges_image9.pl","-"x25,"\n";
#
# fin du code
#
#############################################

#!/usr/bin/perl -w
#
# 18_02_22 19_04_03
#
use strict;
use warnings;
#
use lib "/home/jbdenis/o/info/perl/phoges";
use phoges; 
#
my @lignes = (
              "toto = 45 // tutu = 5 cm // titi = ."
             );
my %default = (tata=>"abracadabra");
#
foreach my $lig (@lignes) {
    my $res = &uie::check8err(obj=>&phoges::analyze8named7vector(lin=>$lig,sep=>"//",def=>\%default));
    &uie::print8structure(str=>$res);
}
#
#
print "-"x4,"Fin de phoges_analyze8named7vector.pl","-"x25,"\n";
#
# fin du code
#
#############################################

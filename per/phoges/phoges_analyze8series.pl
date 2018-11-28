#!/usr/bin/perl -w
#
# 18_02_22
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
#
my @lignes = (
              "toto = 45 // tutu = 5 cm // titi = ."
             );
my %default = (tata=>"abracadabra");
#
foreach my $lig (@lignes) {
    my $res = &uie::check8err(obj=>&phoges::analyze8series(lin=>$lig,sep=>"//",def=>\%default));
    &uie::print8structure(str=>$res);
}
#
#
print "-"x4,"Fin de phoges_analyze8series.pl","-"x25,"\n";
#
# fin du code
#
#############################################

#!/usr/bin/perl -w
#
# 18_03_16
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
#
my @lignes = (
              "toto.jpg",
              "2018_03_16.boudu.png",
              "{<"
             );
#
foreach my $lig (@lignes) {
    my $res = &uie::check8err(obj=>&phoges::image9(nam=>$lig));
    print "\n lig = $lig : $res \n";
}
#
#
print "-"x4,"Fin de phoges_image9.pl","-"x25,"\n";
#
# fin du code
#
#############################################

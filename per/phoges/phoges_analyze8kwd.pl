#!/usr/bin/perl -w
#
# 18_02_23
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
#
my @lignes = (
              "boum bam [[aïe aïe]] sauf [[  non tout perdu]] stop   "
             );
#
foreach my $lig (@lignes) {
    print "\n lig = $lig \n";
    my $res = &uie::check8err(obj=>&phoges::analyze8kwd(lin=>$lig));
    &uie::print8structure(str=>$res);
}
#
#
print "-"x4,"Fin de phoges_analyze8kwd.pl","-"x25,"\n";
#
# fin du code
#
#############################################

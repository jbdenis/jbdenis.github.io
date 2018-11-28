#!/usr/bin/perl -w
#
# 18_03_22
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
my (@cha);
#
# the test is incoporated within 'analyze8line'
#
my @ch1 = (
        " (( commentaire )) [|Deux mille|](|St Aubin|){{C5,C3}}<<PRT,SCN>><[boudou=B,cayo=C]>{| /home/jbdenis/photos/reportages |} [[ Jeanie, Jean-Baptiste, Marie-Hortense, Paco, Marie-Jo, Francisco]]",
        "(( La pluie est de la partie // Bel arc-en-ciel))",
        " [[Ambre, Sophie, Jean Luc]] [|2018_03_22 |]",
        " {{ vert, bleu, rouge }} {| /home/jbdenis/photos/reportages |} [[ Jeanie, Jean-Baptiste, Marie-Hortense, Paco, Marie-Jo, Francisco]]"
          );
foreach my $ligne (@ch1) {
    print "\n",$ligne,"\n\n";
    my $new = &uie::check8err(obj=>&phoges::analyze8line(lin=>$ligne),wha=>1);
    &uie::la(str=>$new,mes=>"On continue ?");
}
#
#
#
print "-"x4,"End of testing 'check8col7pi'","-"x25,"\n";
#
#############################################

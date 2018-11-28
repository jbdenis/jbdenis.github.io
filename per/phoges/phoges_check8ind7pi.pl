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
        "p23.jpg (( La pluie est de la partie // Bel arc-en-ciel))",
        "pkk.png [[Ambre, Sophie, Jean Luc]] [|2018_03_22 |]",
        "uno.png <| Voyage Ibérique // Vigo // Pombasle // Sevilla |> {{ vert, bleu, rouge }} {| /home/jbdenis/photos/reportages |} [[ Jeanie, Jean-Baptiste, Marie-Hortense, Paco, Marie-Jo, Francisco]]"
          );
foreach my $ligne (@ch1) {
    print "\n",$ligne,"\n\n";
    my $new = &uie::check8err(obj=>&phoges::analyze8line(lin=>$ligne),wha=>1);
    &uie::la(str=>$new,mes=>"On continue ?");
}
#
#
#
print "-"x4,"End of testing 'check8ind7pi'","-"x25,"\n";
#
#############################################

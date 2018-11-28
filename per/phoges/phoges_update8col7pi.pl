#!/usr/bin/perl -w
#
# 17_11_20 18_03_07 18_03_12 18_03_27 18_03_28
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
my (@cha);
#
my $ch1 = [
        "<(0)> ESSAI POUR VOIR",
        "((Quelques courses sont nécessaires // ne pas oublier la carte)) <[ HH=53]> [|2018|]",
        "(( )) [|   |] <[]> [[ moi, toi ,nous]]",
        "((The same, except for this comment )) [|   |] <[]> [[ moi, toi ,nous]]",
        "[[]]",
        "<(1)> Guyancourt",
        "<(2)> Auchan Tonnerre",
        "<(1)> Séjour aux Forges",
        "(( La pluie est de la partie // Bel arc-en-ciel))",
        "((La maison est bien froide en hiver // Et chaude en été)) (|Jully|) <[]>",
        "(( ))",
        "((Champ de tournesols décimé))",
        "<(2)> Passage à Noyers",
        "{{ Divers}}",
        "(| Gigny|) [|2018_03_07|]",
        "<(2)> Fête nocturne à Stigny",
        "<(2)> Eglise de Fulvy",
        "<(2)> Vide-grenier à Lézinne",
        "[[Ambre, Sophie, Jean Luc]] [| |]",
        "<(1)> Sur la route de Montbard",
        "<(1)> Brocante à Cry",
        "((Enfin à la maison))"
       ];
my $kopi = &phoges::new7pi(wha=>"col");
#
foreach my $chai ($ch1) {
  @cha = @$chai;
  foreach (@cha) {
      my $new = &uie::check8err(obj=>&phoges::analyze8line(lin=>$_));
      #&uie::la(str=>$new,mes=>"nouveau: $_");
      $kopi = &uie::check8err(obj=>&phoges::update8col7pi(cop=>$kopi,sup=>$new),wha=>1);
      if (&uie::err9(obj=>$kopi)) { &uie::print8err(err=>$kopi)}
      else {&phoges::print8pi(xpi=>$kopi);}
      print "Input was: $_\n";
      &uie::pause(mes=>"On continue ?");
  }
}
#
#
#
print "-"x4,"End of testing 'update8col7pi'","-"x25,"\n";
#
#############################################

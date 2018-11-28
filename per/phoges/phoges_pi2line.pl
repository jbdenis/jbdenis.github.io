#!/usr/bin/perl -w
#
# 18_03_20 18_03_28
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
my (@cha);
#
my @ch1 = (
        "<(0)> ESSAI POUR VOIR",
        "((Quelques courses sont nécessaires // ne pas oublier la carte)) <[ HH=53]>",
        "p01.jpg (( La pluie est de la partie // Bel arc-en-ciel))",
        "<(1)> Guyancourt",
        "<(1)> Séjour aux Forges",
        "((La maison est bien froide en hiver // Et chaude en été)) (|Jully|) <[]>",
        "(( ))",
        "<(2)> Auchan Tonnerre",
        "((Champ de tournesols décimé))",
        "p02.jpg (( Quelle Tristesse))",
        "<(2)> Passage à Noyers",
        "{{ Divers}}",
        "(| Gigny|) [|2018_03_07|]",
        "<(2)> Fête nocturne à Stigny",
        "<(2)> Eglise de Fulvy",
        "<(2)> Vide-grenier à Lézinne",
        "[[Ambre, Sophie, Jean Luc]] [| |]",
        "p03.jpg (( Après la Pluie le Beau Temps))",
        "p04.jpg (( Bel arc-en-ciel du côté du couchant))",
        "<(1)> Sur la route de Montbard",
        "<(1)> Brocante à Cry",
        "((Enfin à la maison))",
        "p05.jpg {{ dodo, chauffage éteint, frigo en panne}}"
       );
my $kopi;
my $ligne; my $last = &phoges::new7pi(wha=>"ind");
for my $whi ("icf","dif") {
   $kopi = &phoges::new7pi(wha=>"col");
   foreach my $chai (@ch1) {
      print "\n",$chai,"\n\n";
      my $new = &uie::check8err(obj=>&phoges::analyze8line(lin=>$chai));
      if ($new->{y} eq "ind") {
          # an image
          my $ima = &uie::check8err(obj=>&phoges::col7pi2ind7pi(cpi=>$kopi,ipi=>$new,lpi=>$last,whi=>$whi));
          $ligne = &uie::check8err(obj=>&phoges::pi2line(xpi=>$ima));
          # displaying the result
          print ">>>$ligne<<<\n";
      } else {
          # an additional pi (add or cir)
          if ($new->{y} eq "cir") {
              $ligne = &uie::check8err(obj=>&phoges::pi2line(xpi=>$new));
              # displaying the result
              print ")))$ligne(((\n";
          }
          $kopi = &uie::check8err(obj=>&phoges::update8col7pi(cop=>$kopi,sup=>$new));
          #&uie::la(str=>$kopi->{c},mes=>"Circumstance Hierarchy");
          $ligne = &uie::check8err(obj=>&phoges::pi2line(xpi=>$kopi));
          # displaying the result
          unless ($whi eq "icf") { print ">>>$ligne<<<\n";}
      }
      &uie::la(str=>$whi,mes=>"On continue ?");
   }
}
#
#
#
print "-"x4,"End of testing 'pi2line'","-"x25,"\n";
#
#############################################

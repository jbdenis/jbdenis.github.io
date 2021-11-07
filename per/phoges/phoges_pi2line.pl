#!/usr/bin/perl -w
#
# 18_03_20 18_03_28 19_04_02
#
use strict;
use warnings;
#
use lib "/home/jbdenis/o/info/perl/phoges";
use phoges; 
#
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
   $kopi = &phoges::new7pi(wha=>"COL");
   foreach my $chai (@ch1) {
      print "\n",$chai,"\n\n";
      my $new = &uie::check8err(obj=>&phoges::analyze8line(lin=>$chai));
      unless ($new->{y} eq "col") {
          my $lig = &uie::check8err(obj=>&phoges::pi2line(xpi=>$new));
	  print "-"x5,$lig,"-"x5,"\n";
      } else {
          print "+"x5," Normally 'col' pi is not possible but an exception can be raised","+"x5,"\n";
          my $lig = &uie::check8err(obj=>&phoges::pi2line(xpi=>$new,xco=>1));
	  print "-"x5,$lig,"-"x5,"\n";
      }
      &uie::la(str=>"",mes=>"On continue ?");
   }
#
#
#
print "-"x4,"End of testing 'pi2line'","-"x25,"\n";
#
#############################################

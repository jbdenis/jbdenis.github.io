#!/usr/bin/perl -w
#
# 18_03_08 18_03_12 18_03_15 18_03_16 18_03_17
# 18_03_18 18_03_22 18_03_25 18_03_27 18_04_12
#
use strict;
use warnings;
use phoges; 
use uie;
#
use lib "/home/jbdenis/o/info/perl/phoges";
use lib "/home/jbdenis/o/info/perl/uie";
my (@cha);
my $short = {"kwd"=>{"bof"=>"pas vraiment convaincu","pif"=>"Une grande claque sur la joue droite"},
             "qui"=>{"jb"=>"Jean-Baptiste","j"=>"Jeanie"}};
&uie::la(str=>$short,mes=>"shortcuts");
#
my $ch1 = [
        "(*) Un très beau commentaire",
        "pkk.jpg (| canal // chemin |) [[ Pierre, Marie, Jean ,Lucette, Odette ,Louis Denis]] bof j",
        "[[]] [||]",
        "((Quelques courses sont nécessaires // ne pas oublier la carte)) <[ HH=53]> [|2018|] jbd jjb jb",
        "(( )) [|   |] <[]> [[ moi, toi ,nous]]",
        "<(0)> ESSAI POUR VOIR",
        "<[ wid= 5cm, hei =   3   cm, profondeur=1km]>  {{ kwd1 ,kwd2, kwd7, château d'eau,  kwd9 }}[|2011|]",
        "uu.jpg <| Séjour dans l'Yonne // Sortie     de, dimanche  après-midi // Brocante à Cry |>pif",
        "pjj.jpg chouette",
        " (| canal // chemin |)",

        "<< cat1  , cat2 , cat7 >><| photos//courant//belles|>",
        "[| 2018_03_07|03_08 |] (| Fulvy // petite église|)",
        "{| ori |}",
        "<(1)> - Guyancourt - ",
        "(( Sur le bord de la route //  Champ de tournesols décimé // fleur noire))",
        "[[ Pierre, Marie, Jean, Lucette, Odette ,Louis Denis]]",
        "((Enfin à la maison))"
       ];
#
foreach my $chai ($ch1) {
  @cha = @$chai;
  foreach (@cha) {
      my $r1 = &uie::check8err(obj=>&phoges::analyze8line(lin=>$_,lit=>"",sht=>$short),wha=>1);
      unless (&uie::err9(obj=>$r1)) {
          &uie::check8err(obj=>&phoges::print8pi(xpi=>$r1));
      } else {
          &uie::print8err(err=>$r1);
      }
      print "\nLINE = ",$_,"\n";
      &uie::pause(mes=>"next line?");
  }
}
#
#
#
print "-"x4,"End of testing 'analyze8line'","-"x25,"\n";
#
#############################################

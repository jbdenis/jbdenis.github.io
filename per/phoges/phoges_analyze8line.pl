#!/usr/bin/perl -w
#
# 18_03_08 18_03_12 18_03_15 18_03_16 18_03_17
# 18_03_18 18_03_22 18_03_25 18_03_27 18_04_12
# 19_03_31 20_03_28
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/phoges";
use phoges; 
use lib "/home/jbdenis/o/info/perl/uie";
use uie;
#
#
my @resu = ("MAUVAIS","BON");
my $resu;
#
my (@cha);
my $short = {"kwd"=>{"bof"=>"pas vraiment convaincu","pif"=>"Une grande claque sur la joue droite"},
             "qui"=>{"jb"=>"Jean-Baptiste","j"=>"Jeanie","jjb"=>"Jeanie & Jean-Baptiste"}};
&uie::la(str=>$short,mes=>"shortcuts which are used below");
#
my @ch1 = (
        "uno.jpg <| Voyage Ibérique // Vigo // Pombasle // Sevilla |> {{ vert, bleu, rouge }} {| /home/jbdenis/photos/reportages |} [[ Jeanie, Jean-Baptiste, Marie-Hortense, Paco, Marie-Jo, Francisco]]",
        " [[Ambre, Sophie, Jean-Luc]] [|2018_03_22 |] [(elle)]",
        "<< cat1  , cat2 , cat7 >> <| photos//courant//belles|>",
        " <(3)> nouveau paragraphe",
        " (( commentaire )) [|Deux mille|](|St Aubin|){{C5,C3}}<<PRT,SCN>><[boudou=B,cayo=C]>{| /home/jbdenis/photos/reportages |} [[ jjb, Marie-Hortense, Paco, Marie-Jo, Francisco]] [(la photographe)]",
        "(( La pluie est de la partie // Bel arc-en-ciel))",
        " {{ vert, bleu, rouge }} {| /home/jbdenis/photos/reportages |} [[ Jeanie, Jean-Baptiste, Marie-Hortense, Paco, Marie-Jo, Francisco]]",
        "p23.jpg (( La pluie est de la partie // Bel arc-en-ciel))",
        "pkk.png [[Ambre, Sophie, Jean Luc]] [|2018_03_22 |]",
        "<(1)>EMV Jazz Big Band",
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
        "[| 2018_03_07|03_08 |] (| Fulvy // petite église|)",
        "{| ori |}",
        "<(1)> - Guyancourt - ",
        "(( Sur le bord de la route //  Champ de tournesols décimé // fleur noire))",
        "[[ Pierre, Marie, Jean, Lucette, Odette ,Louis Denis]]",
        "((Enfin à la maison))"
          );
#
##
#
foreach my $ligne (@ch1) {
    for my $rac (0,1) {
	print "\n",$ligne,"\n\n";
	my $ssh = {}; my $comm = " (without shortcuts) ";
	if ($rac) { $ssh = $short; $comm = " (with shortcuts) ";}
	my $new = &phoges::analyze8line(lin=>$ligne,sht=>$ssh);
	if (&uie::err9(obj=>$new)) {
	    &uie::la(str=>$new,mes=>"Bad line found");
	} else {
	    &phoges::print8pi(xpi=>$new,chk=>0);
            $resu = &phoges::check8pi(xpi=>$new);
	    if (&uie::err9(obj=>$resu)) {
                &uie::la(str=>$resu,mes=>"$comm Fine but unvalid");
	    } else {
		&uie::pause(mes=>(" "x12)."$comm GOOD!");
	    }
        }
    }
}
#
#
#
#
print "-"x4,"End of testing 'analyze8line'","-"x25,"\n";
#
#############################################

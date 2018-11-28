#!/usr/bin/perl -w
#
# 17_04_24 17_04_29
#
use strict;
use warnings;
use uie; 
#
#
my $resu;
my $fifi = "toto.html";
#
my $tutu = ["<1> Titre Principal",
            "<o> Première section",
            "<o> Première sous-section"];
$resu = &uie::text2html(str=>$tutu);
&uie::print8structure(str=>$resu);
&uie::pause(mes=>"finishing with a list");
#
   $tutu = ["<1> Titre Principal",
            "<2> Première section",
            "<3> Première sous-section",
            "<4> Première sous-sous-section",
            "<5> Première sous-sous-sous-section",
            "<6> Première sous-sous-sous-sous-section",
            "<> Un petit texte"];
$resu = &uie::text2html(str=>$tutu);
&uie::print8structure(str=>$resu);
&uie::pause(mes=>"juxtaposition de deux headings");
#
my $text1 = ["<1>Un bon titre",
             "<#> Introduction en premier",
             "<#> Développement en second",
             "<#> Conclusion en troisième",
             "<2>Une introduction",
             "<->Il faut savoir énumérer",
             "proprement quelques composantes:",
             "<o> Première",
             "Autrement dit, ce qui vient en premier.",
             "<o> Seconde",
             "<o> Troisième",
             "Dans notre cas, ce qui vient en dernier malgré",
             "les apparences.",
             "<>Ceci constituait la conclusion de l'introduction.",
             "<2>Un développement",
             "<>C'est normalement la partie la plus importante du ",
             "texte...",
             "Si tout va comme je l'ai prévu",
             "il suffit d'une ligne vierge au milieu d'un texte",
             "",
             "pour déclencher un nouveau paragraphe",
             "il devrait y en avoir un entre 'texte' et 'pour' ?",
             "<>Pas vraiment le cas ici !",
             "<->...",
             "<->",
             "<->",
             "<2>Une conclusion",
             "<>C'est la fin du fin"];
$resu = &uie::text2html(str=>$text1);
&uie::print8structure(str=>$resu);
&uie::pause(mes=>"Si pas arrêt, stocké dans $fifi");
open(TOTO,">$fifi") or die("Can't open $fifi");
foreach (@$resu) { print TOTO $_,"\n";}
close(TOTO);
&uie::pause(mes=>"Displaying it in Konqueror");
system("konqueror $fifi &");
#
my $text2 = ["Et voici un texte sans aucune balise !",
             "(ou presque !)",
             "",
             "La génération des paragraphes se fait",
             "simplement par des lignes blanches.",
             "    ",
             "Ces lignes blanches peuvent contenir",
             "(ou pas) un ou plusieurs espaces. Ainsi",
             "la découpe doit s'adapter à la largeur",
             "de la fenêtre.",
             " ",
             "Ainsi, on évite le besoin du taggage",
             "Mais celui-ci peut tout aussi bien cohabiter",
             "<>Ceci constituait la conclusion de l'introduction.",
             "<3>Jean-",
             "Baptiste",
             "",
             "DENIS"];
$resu = &uie::text2html(str=>$text2);
&uie::print8structure(str=>$resu);
&uie::pause(mes=>"Si pas arrêt, stocké dans $fifi");
open(TOTO,">$fifi") or die("Can't open $fifi");
foreach (@$resu) { print TOTO $_,"\n";}
close(TOTO);
#
#
print "-"x4,"Fin du test de text2html","-"x25,"\n";
#
# fin du code
#
#############################################

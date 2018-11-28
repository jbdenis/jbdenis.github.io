#!/usr/bin/perl -w
#
# 16_09_06 17_04_04
#
use strict;
use warnings;
use uie; 
#
my $resu;
#
my $arr4 = [" # un fichier simple pour le nouveau type 2",
            " a 1 il était une fois;; a 2 un petit ## chaperon ",
            "a 3 rouge"];
foreach my $d (1) { foreach my $n (1) { foreach my $s (3) {
    $resu = &uie::clean8string(str=>$arr4,dbl=>$d,nun=>$n,spa=>$s);
    my $res2 = &uie::clean8string(str=>$arr4,dbl=>$d,nun=>$n,spa=>$s,sep=>";;");
    &uie::print8structure(str=>$arr4);
    &uie::print8structure(str=>$resu);
    &uie::print8structure(str=>$res2);
    &uie::pause(mes=>"dbl=$d nun=$n spa=$s");
}}}
#
my $arr3 = ["  il faut","   que je me fasse "," à cette  idée "," bien ","utile"," ","s'il en ait"];
foreach my $d (0,1) { foreach my $n (0,1) { foreach my $s (0..3) {
    $resu = &uie::clean8string(str=>$arr3,dbl=>$d,nun=>$n,spa=>$s);
    &uie::print8structure(str=>$arr3);
    &uie::print8structure(str=>$resu);
    &uie::pause(mes=>"dbl=$d nun=$n spa=$s");
}}}
#
my $arr2 = ["  il faut","   que je me fasse "," à cette  idée "," bien ","utile"," ","s'il en ait"];
$resu = &uie::clean8string(str=>$arr2);
&uie::print8structure(str=>$arr2);
&uie::print8structure(str=>$resu);
&uie::pause;
#
my $str0 = ["# un commentaire complet",
            "ouh ouh ## un commentaire partiel",
            "  il faut   que je me fasse  à l'idée "
           ];
$resu = &uie::clean8string(str=>$str0,spa=>0,nun=>0);
&uie::print8structure(str=>$str0);
&uie::print8structure(str=>$resu);
&uie::pause(mes=>"contrôle des commentaires");
#
my $str1 = ["  il faut   que je me fasse [[ à cette  idée ]] bien [[utile]] [[s'il en ait]]!"];
$resu = &uie::clean8string(str=>$str1);
&uie::print8structure(str=>$str1);
&uie::print8structure(str=>$resu);
&uie::pause;
#
#
print "-"x4,"Fin du test de clean8string","-"x25,"\n";
#
# fin du code
#
#############################################

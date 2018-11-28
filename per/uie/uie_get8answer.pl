#!/usr/bin/perl -w
#
# 16_03_21 16_04_04 16_04_14 16_06_03 17_04_04
#
use strict;
use uie; 

#
&uie::get8answer("help");
&uie::pause(mes=>"Voici la liste des arguments de '&get8answer'");
#
my %an = ("ques"=>"En quelle année ?",
          "help"=>("Le numéro de l'année\n doit etre un entier :\n\ncompris entre les valeurs minimales et maximales incluses !\n.....(cf. ci-dessus)"),
          "chec"=>["n",1970,2049,2],
          "defa"=>2016);
my %mois = ("ques"=>"Pour quel mois ?",
          "help"=>("Un mois parmi les douze possibles"),
          "chec"=>["a","janvier","février","mars","avril",
                       "mai","juin","juillet","août",
                       "septembre","octobre","novembre","décembre"],
          "defa"=>undef);
my %jour = ("ques"=>"Et quel jour ?",
            "help"=>("Le numero du jour doit etre un entier\n  \n respectant les limites ci-dessus"),
            "chec"=>["n",1,31,0],
            "defa"=>1);
my %qq = ("an"  => \%an,
          "mois"=> \%mois,
	  "jour"=> \%jour);
my @oo = ("jour","mois","an");
my $cc = {jour=>[10,"l"],mois=>[10,"c"],an=>[10,"r"]};
#
for my $con ("k","v","s") {
    my $ans1 = &uie::get8answer(rpl=>[],rqu=>\%qq,ror=>\@oo,con=>$con);
    &uie::print8structure(str=>$ans1);
    &uie::pause(mes=>"Premier appel de '&get8answer' avec trois questions et l'affichage progressif de type $con");
}
#
my $rju = {avant=>"-<( ",apres=>" )>- : ",long=>35,just=>"r"};
my $form = {an=>$rju,mois=>$rju,jour=>$rju};
my $ans2 = &uie::get8answer(rpl=>[\"avec introduction"],rqu=>\%qq, #"
                             ror=>\@oo,rfo=>$form);
&uie::print8structure(str=>$ans2);
&uie::pause(mes=>"Second appel de '&get8answer' avec trois questions formattées");
#
print "-"x4,"Fin du test de get8answer","-"x21,"\n";
#
# fin du code
#
#############################################

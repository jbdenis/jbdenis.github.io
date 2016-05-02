#!/usr/bin/perl -w
#
# 16_03_21 16_04_04 16_04_14
#
use strict;
use uie; 

#
&uie::get8answers("help");
&uie::pause(mess=>"Voici la liste des arguments de '&get8answers'");
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
    my $ans1 = &uie::get8answers(rplaca=>[],rquest=>\%qq,rordre=>\@oo,construc=>$con);
    &uie::print8structure(stru=>$ans1);
    &uie::pause(mess=>"Premier appel de '&get8answers' avec trois questions et l'affichage progressif de type $con");
}
#
my $rju = {avant=>"-<( ",apres=>" )>- : ",long=>35,just=>"r"};
my $form = {an=>$rju,mois=>$rju,jour=>$rju};
my $ans2 = &uie::get8answers(rplaca=>[\"avec introduction"],rquest=>\%qq, #"
                             rordre=>\@oo,rforma=>$form);
&uie::print8structure(stru=>$ans2);
&uie::pause(mess=>"Second appel de '&get8answers' avec trois questions formattées");
#
print "-"x4,"Fin du test de get8answers","-"x21,"\n";
#
# fin du code
#
#############################################

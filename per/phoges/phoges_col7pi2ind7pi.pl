#!/usr/bin/perl -w
#
# 18_03_11 19_03_28 19_04_02
#
use strict;
use warnings;
#
use lib "/home/jbdenis/o/info/perl/phoges";
use phoges; 
#
my $last = &phoges::new7pi(wha=>"ind");
$last->{"n"} = "UltimE.png";
#
$last->{"m"} = ["juste pour dire quelque chose"];
$last->{"p"} = ["dernier"];
$last->{"q"} = ["Dernier"];
$last->{"k"} = ["dernieR"];
$last->{"g"} = ["DERNIER"];
#
$last->{"t"} = "dernier";
&uie::check8err(obj=>&phoges::check8pi(xpi=>$last),sig=>"pi last");
#
# specific test for the dimension
my $ipi = &phoges::new7pi(wha=>"ind");
#$ipi->{h}->{wid} = "3cm";
my $cp1 = &phoges::new7pi(wha=>"col");
$cp1->{h}->{WID} = "7cm";
$cp1->{c} = ["titre","section"];
&phoges::print8pi(xpi=>$ipi);
&phoges::print8pi(xpi=>$cp1);
&uie::pause(mes=>"les pi.s");
my $npi = &phoges::col7pi2ind7pi(cpi=>$cp1,ipi=>$ipi,lpi=>$last,cum=>"");
&phoges::print8pi(xpi=>$npi);
&uie::pause(mes=>"résultat");
#
my $regard = 1;
#
my $cpis = 
           {"y"=>"COL",
            #
            "c"=>[["Grandes Villes"],["Paris"],["XVème"]],
            "m"=>[["Les Grandes Villes se généralisent sur toute la surface de la terre"],
                  ["Capitale de la France"],
                  ["Arrondissement d'arrivée des Bretons"]],
            "p"=>[[""],[""],["Strasbourg"]],
            "q"=>[["Jeanie"],["Jean"],["Baptiste"]],
            "g"=>[[""],[""],["PTR","PAY"]],
            "k"=>[["rond"],["carré"],["triangle"]],
            #
            "t"=>"2017",
            "o"=>"moi",
            "d"=>"../photos",
            #
            "h"=>{"pour"=>"voir"},
           };
&uie::check8err(obj=>&phoges::check8pi(xpi=>$cpis),sig=>"pi cpis");
#
my $ind1 = &phoges::new7pi(wha=>"ind");
$ind1->{n} = "pc250123.jpg";
my $ind2 = &phoges::new7pi(wha=>"ind");
$ind2->{n} = "pc310789.jpg";
$ind2->{p} = ["rue de Vaugirard"];
$ind2->{h} = {wid=>"4cm",hei=>"5cm"};
$ind2->{g} = ["SCE","--q--"];
$ind2->{k} = ["porte","serrure","poignée","numéro"];
$ind2->{q} = ["Jean","Luc","Mathieu","Marc"];
$ind2->{d} = "ori";
my $ipis = [$ind1,$ind2];
#
my @serie = ("mqk","tod","");
foreach my $cp ($cpis) {
    &uie::check8err(obj=>&phoges::print8pi(xpi=>$cp));&uie::pause(mes=>"The COLLECTIVE PI'S");
    foreach my $ip (@$ipis) {
        &uie::check8err(obj=>&phoges::print8pi(xpi=>$ip));&uie::pause(mes=>"The INDIVIDUAL PI'S");
        foreach my $quoi (@serie) {
            my $rpi = &uie::check8err(obj=>&phoges::col7pi2ind7pi(cpi=>$cp,ipi=>$ip,lpi=>$last,cum=>$quoi));
            &uie::check8err(obj=>&phoges::print8pi(xpi=>$rpi));
            &uie::pause(mes=>"RESULT FOR $quoi\n Another Example?");
        }
    }
}
#       
#
print "-"x4,"End of testing 'col7pi2ind7pi'","-"x25,"\n";
#
#############################################

#!/usr/bin/perl -w
#
# 18_03_11
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
#
my $regard = 1;
#
my $last = {
            "t"=>"dernier",
            "p"=>[["dernier"]],
            "q"=>[["dernier"]],
            "g"=>[["dernier"]],
            "k"=>[["dernier"]],
            "c"=>["LE TITRE"],
            "m"=>[["dernier"]],
            "h"=>{},"d"=>""
           };
my $cpis = [
           {"y"=>"col",
            "t"=>"2017",
            "p"=>[[undef],[undef],["Strasbourg"]],
            "q"=>[["Jeanie"],["Jean"],["Baptiste"]],
            "g"=>[[undef],[undef],["PTR","PAY"]],
            "k"=>[["rond"],["carré"],["triangle"]],
            "c"=>["Grandes Villes","Paris","XVème"],
            "m"=>[["Les Grandes Villes se généralisent sur toute la surface de la terre"],
                  ["Capitale de la France"],
                  ["Arrondissement d'arrivée des Bretons"]],
            "h"=>{"pour"=>"voir"},
            "d"=>"../photos"
           },
          ];
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
my @serie = ("icf","dif");
foreach my $cp (@$cpis) {
    &uie::check8err(obj=>&phoges::print8pi(xpi=>$cp));&uie::pause(mes=>"The COLLECTIVE PI'S");
    foreach my $ip (@$ipis) {
        &uie::check8err(obj=>&phoges::print8pi(xpi=>$ip));&uie::pause(mes=>"The INDIVIDUAL PI'S");
        foreach my $quoi (@serie) {
            my $rpi = &uie::check8err(obj=>&phoges::col7pi2ind7pi(cpi=>$cp,ipi=>$ip,lpi=>$last,whi=>$quoi));
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

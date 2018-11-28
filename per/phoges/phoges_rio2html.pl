#!/usr/bin/perl -w
#
# 17_11_15
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
my ($ret,$res,$rio,$fic);
#
$fic = "phoges-fi5.txt";
$rio = &phoges::read8ic7f(icf=>$fic,cat=>["xc","nn","pvv"]);
#&uie::print8structure(str=>$rio); &uie::pause(mes=>"Looking at the rio object");
if (&uie::err9(obj=>$rio)) {
    &uie::print8err(err=>$rio);
    print(" AN ERROR was found with $fic!\n");
} else {
    $res = &phoges::rio2html(rio=>$rio,fil=>"toto.html",opt=>"h3c2k2",tit=>"Essai avec fi5");
    if (&uie::err9(obj=>$res)) {
        &uie::print8err(err=>$res);
        print(" AN ERROR was found with the 'rio' built from $fic!\n");
    } else {
        #&uie::pause(mes=>"sorties intermédiaires");
        die("was not able to open 'toto.html'") unless (open TT,"<toto.html");
        while (<TT>) { print $_;}
        print(" test with $fic SEEMS GOOD!\n");
    }
}
#
#
print "-"x4,"Fin du test de rio2html","-"x25,"\n";
#
#############################################

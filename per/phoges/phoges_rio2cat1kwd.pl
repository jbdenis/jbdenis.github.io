#!/usr/bin/perl -w
#
# 17_10_19 17_11_05 17_11_10 17_11_11
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
if (&uie::err9(obj=>$rio)) {
    &uie::print8err(err=>$rio);
    print(" AN ERROR was found with $fic!\n");
} else {
    #&uie::print8structure(str=>$rio); &uie::pause(mes=>"See the rio object"); 
    $res = &phoges::rio2cat1kwd(rio=>$rio);
    if (&uie::err9(obj=>$res)) {
        &uie::print8err(err=>$res);
        print(" AN ERROR was found with the 'rio' built from $fic!\n");
    } else {
        &uie::print8structure(str=>$res);
        &uie::pause(mes=>"Les Catégories");
    }
    $res = &phoges::rio2cat1kwd(rio=>$rio,qoi=>"key");
    if (&uie::err9(obj=>$res)) {
        &uie::print8err(err=>$res);
        print(" AN ERROR was found with the 'rio' built from $fic!\n");
    } else {
        &uie::print8structure(str=>$res);
        &uie::pause(mes=>"Les Mot-Clefs");
    }
}
#
#
print "-"x4,"Fin du test de rio2cat1kwd","-"x25,"\n";
#
#############################################

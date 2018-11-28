#!/usr/bin/perl -w
#
# 17_10_16 17_11_14
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
my ($res,$fic);
#
$fic = "phoges-fi9.txt";
$res = &phoges::read8ic7f(icf=>$fic,cat=>["nn","pvv"]);
if (&uie::err9(obj=>$res)) {
    &uie::print8err(err=>$res);
    print(" AN ERROR was found with $fic!\n",
          "Normal it is a test...\n");
} else {
    &uie::print8structure(str=>$res,rtd=>10);
    print(" NO ERROR found with $fic!\n");
}
&uie::pause(mes=>"test with a bigger file");
#
#
$fic = "phoges-fi5.txt";
$res = &phoges::read8ic7f(icf=>$fic,cat=>["nn","pvv","xc"]);
if (&uie::err9(obj=>$res)) {
    &uie::print8err(err=>$res);
    print(" AN ERROR was found with $fic!\n");
} else {
    &uie::print8structure(str=>$res->{cir},rtd=>-10);
    print(" NO ERROR found with $fic!\n");
}
&uie::pause(mes=>"test with a small file");
#
#
print "-"x4,"Fin du test de read8ic7f","-"x25,"\n";
#
#############################################

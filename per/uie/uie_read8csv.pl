#!/usr/bin/perl -w
#
# 17_03_31 17_04_06 17_04_11
#
use strict;
use warnings;
use uie; 
#
my $fi7 = "uie-fi7.txt";
my $re7 = &uie::read8csv(csv=>$fi7);
if (&uie::err9(obj=>$re7)) {
    &uie::print8err(err=>$re7);
} else {
    &uie::print8structure(str=>$re7);
}
&uie::pause(mes=>"Résultat pour $fi7");
#
my $fi8 = "uie-fi8.txt";
my $re8 = &uie::read8csv(csv=>$fi8);
if (&uie::err9(obj=>$re8)) {
    &uie::print8err(err=>$re8);
} else {
    &uie::print8structure(str=>$re8);
}
&uie::pause(mes=>"Résultat pour $fi8 'must be wrong ;+)' !!!");
#
#
print "-"x4,"test de 'read8csv' terminé","-"x25,"\n";
#
# fin du code
#
#############################################

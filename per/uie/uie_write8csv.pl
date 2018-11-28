#!/usr/bin/perl -w
#
# 18_02_07
#
use strict;
use warnings;
use uie; 
#
my $fi7 = "uie-fi7.txt";
my $toto = "toto.txt";
my $re7 = &uie::check8err(obj=>&uie::read8csv(csv=>$fi7));
&uie::print8structure(str=>$re7);
&uie::check8err(obj=>&uie::write8csv(str=>$re7,csv=>$toto));
my $re8 = &uie::check8err(obj=>&uie::read8csv(csv=>$toto));
&uie::print8structure(str=>$re8);
#unlink($toto);
#
#
print "-"x4,"test de 'write8csv' terminé","-"x25,"\n";
#
# fin du code
#
#############################################

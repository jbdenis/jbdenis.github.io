#!/usr/bin/perl -w
#
# 16_05_10
#
use lib "/home/jbdenis/o/info/perl/uie";
use strict;
use warnings;
use compta; 
#
#
# reading the journal
my $fjou = "compta-joujou.txt";
my $rjou = &compta::read8journal(fic=>$fjou);
#
# getting all the first three transactions
my $transas = &compta::transa4journal(rjou=>$rjou,tran=>[1,3]);
&uie::print8structure(str=>$transas);
&uie::pause;
#
#
print "-"x4,"Fin du test de transa4journal","-"x25,"\n";
#
# fin du code
#
#############################################

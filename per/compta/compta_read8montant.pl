#!/usr/bin/perl -w 
#
# 16_03_30 16_05_05
#
use lib "/home/jbdenis/liana/info/perl/uie";
use File::Copy;
use strict;
use compta; 
#
print "\nTests are made for:\n\n";
print "     - &read8montant\n";
print "\n\n";
&uie::pause;
#
my $fimo = "compta-solsol.txt";
my $resu = &compta::read8montant(mon=>$fimo);
&uie::print8structure(stru=>$resu);
#
print "-"x4,"Fin du test de read8montant","-"x25,"\n";
#
# fin du code
#
#############################################

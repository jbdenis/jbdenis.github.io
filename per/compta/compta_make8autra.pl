#!/usr/bin/perl -w 
#
# 16_03_05 16_03_06 16_03_30 16_05_05
#
use lib "/home/jbdenis/o/info/perl/uie";
use File::Copy;
use strict;
use compta; 
#
print "\nTests are made for:\n\n";
print "     - &make8autra\n";
print "\n\n";
&uie::pause;
#
my $fide = "compta-defdef.txt";
my $fiou = "toto-opeaut.txt";
#
my $defi = &compta::read8definition(fdef=>$fide);
my $mois = "12"; my $an = "2016";
#
&compta::make8autra(ropau=>$$defi{"Op-Auto"},
                    month=>$mois,year=>$an,journal=>$fiou);
system("cat $fiou");
#
print "-"x4,"Fin du test de make8autra","-"x25,"\n";
#
# fin du code
#
#############################################

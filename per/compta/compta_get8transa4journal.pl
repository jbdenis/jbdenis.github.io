#!/usr/bin/perl -w
#
# 16_03_15 16_03_16 16_03_30 16_04_13 16_04_15
# 16_05_05
#
use lib "/home/jbdenis/o/info/perl/uie";
use File::Copy;
use strict;
use compta; 
use Term::ANSIColor;
#use Term::ReadKey;
my $fide = "compta-defdef.txt";

print "\nTests are made for:\n\n";
print "     - &get8transa\n";
print "     - &questions4transactions\n";
print "\n\n";
&uie::pause;
#
#
my $fiou = "toto-opeaut.txt";
# reading the definition file
my $rdefi = &compta::read8definition(fdef=>$fide);
# constituting the series of questions
my $rques = &compta::questions4transactions(rdefi=>$rdefi);
&uie::print8structure(str=>$rques);
&uie::pause(mes=>"La définition des questions par '&questions4transactions'");
#
# getting a transaction
my $rordr = ["p","t","y","m","d","re","e",
             "r","rr","hm","ds"];
#
my $rtran = &compta::get8transa4journal(rquest=>$rques,rordre=>$rordr,
                                        journal=>"toto-get1.txt");
&uie::pause(mes=>"Call of '&get8transa4journal'");
#
#
print "-"x4,"Fin de compta_get8transa4journal","-"x21,"\n";
#
# fin du code
#
#############################################

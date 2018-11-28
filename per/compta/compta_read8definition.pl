#!/usr/bin/perl -w 
#
# 16_02_28 16_03_30 16_05_05
#
use lib "/home/jbdenis/o/info/perl/uie";
use File::Copy;
use strict;
use compta; 
#
print "\nTests are made for:\n\n";
print "     - &read8definition\n";
print "\n\n";
&uie::pause;
#
my $fide = "compta-defdef.txt";
#
my $res = &compta::read8definition(fdef=>$fide);
print join(" - ",keys %$res),"\n";
foreach (keys %$res) {
    print "\n<< $_ >>\n";
    my @poste = @{$$res{$_}};
    foreach my $uu (@poste) {
	print "@$uu\n";
    }
}
print "-"x4,"Fin du test de read8definition","-"x25,"\n";
#
# fin du code
#
#############################################

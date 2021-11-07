#!/usr/bin/perl -w
#
# 19_11_05
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/uie";
use uie;
#
my @clg = (["niveau0","A","B","C"]);
#
foreach my $i (0..4) {
    foreach my $cll (@clg) {
	foreach my $ss ("s","e","r","MESSAGE") {
            &uie::trace8script(cal=>$cll,typ=>$ss,sty=>$i+100*$i);
	}
	&uie::pause(mes=>"\nstyle was $i");
    }		       
}
#
print "-"x4,"test de 'trace8script' terminé","-"x25,"\n";
0;
#
# fin du code
#
#############################################

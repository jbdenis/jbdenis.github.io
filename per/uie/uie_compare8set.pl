#!/usr/bin/perl -w
#
# 16_09_27 17_04_04
#
use strict;
use warnings;
use uie; 
#
my ($s1,$s2,$is);
#
foreach my $d1 (1,5) {
    foreach my $f1 ($d1+0,$d1+3) {
        foreach my $d2 (2,8) {
            foreach my $f2 ($d2+0,$d2+2) {
                $s1 = [$d1..$f1];
                $s2 = [$d2..$f2];
                foreach my $op ("i","u","d","a","b") {
                    $is = &uie::compare8set(se1=>$s1,se2=>$s2,ope=>$op);
                    print "[$op]: ",join(" | ",@$is),"\n";
                }
                &uie::pause(mes=>"[$d1..$f1] et [$d2..$f2]");
	    }
	}
    }
}
#
#
#
print "-"x4,"test de 'compare8set' terminé","-"x25,"\n";
#
# fin du code
#
#############################################

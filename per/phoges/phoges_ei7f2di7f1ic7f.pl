#!/usr/bin/perl -w
#
# 17_12_27 17_12_31 18_01_07 18_01_09 18_01_10
# 18_01_17 18_01_18 18_02_13 18_02_23 18_03_09
# 18_01_10 18_03_12 18_03_13 18_03_20 18_03_29
# 18_04_04 18_09_30
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
my ($fifi,$res,$fofo,$fcfc);
#
#
$fifi = "phoges-fij";
#$fifi = "phoges-fil";
$fofo = "toto";
#
foreach my $slf ("","phoges-fip") {
foreach my $type ("dif","icf") {
    $fcfc = $fofo."-".$type.".txt";
    if (-e $fcfc) {
	unless (unlink($fcfc)) {
	    pause(mes=>"Unable to destroy $fcfc!");
	    exit 0;
	}
    }
    $res = &uie::check8err(obj=>&phoges::ei7f2di7f1ic7f(eif=>$fifi,out=>$fofo,
			    new=>1,typ=>$type,slf=>$slf));
    print "-"x50,"\n";
    open(FOFO,"<$fcfc") or die("pas ouvert !");
    while (<FOFO>) {
	print $_;
    }
    print "-"x50,"\n";
    &uie::pause(mes=>"Then?");
}}
#
print "-"x4,"Fin du test de ei7f2di7f1ic7f.pl","-"x25,"\n";
#
#############################################

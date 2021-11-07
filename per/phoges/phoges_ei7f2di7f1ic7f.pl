#!/usr/bin/perl -w
#
# 17_12_27 17_12_31 18_01_07 18_01_09 18_01_10
# 18_01_17 18_01_18 18_02_13 18_02_23 18_03_09
# 18_01_10 18_03_12 18_03_13 18_03_20 18_03_29
# 18_04_04 18_09_30 18_12_31 19_01_06 19_01_24
# 19_04_17 19_04_18 19_10_07 19_10_08
#
use strict;
use warnings;
use lib "/home/jbdenis/u/perl";
use lhattmel; 
use jours;
use lib "/home/jbdenis/o/info/perl/phoges";
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
my ($res,$fofo,$fcfc);
#
my $noufi = "phoges-tea"; my $cas = "icf";
$cas = "dif";
&uie::check8err(obj=>&phoges::ei7f2di7f1ic7f(eif=>$noufi,out=>"toto",new=>0,typ=>$cas));
system("cat toto-$cas.txt");
&uie::pause(mes=>"Premier passé : toto...");
#
$fofo = "toto";
#
foreach my $fifi ("phoges-fij","phoges-fil") {
#foreach my $fifi ("phoges-fil") {
#foreach my $slf ("phoges-fip","") {
foreach my $slf ("") {
foreach my $type ("icf","dif") {
#foreach my $type ("dif") {
    $fcfc = $fofo."-".$type.".txt";
    if (-e $fcfc) {
	unless (unlink($fcfc)) {
	    pause(mes=>"Unable to destroy $fcfc!");
	    exit 0;
	}
    }
    $res = &phoges::ei7f2di7f1ic7f(eif=>$fifi,out=>$fofo,
				   new=>1,typ=>$type,slf=>$slf);
    if (&uie::err9(obj=>$res)) {
	&uie::print8err(err=>$res);
    } else {
        print "-"x50,"\n";
        open(FOFO,"<$fcfc") or die("pas ouvert !");
        while (<FOFO>) {
	    print $_;
	}
    }
    print "-"x50,"\n";
    &uie::pause(mes=>"Then?");
}}}
#
print "-"x4,"Fin du test de ei7f2di7f1ic7f.pl","-"x25,"\n";
#
#############################################

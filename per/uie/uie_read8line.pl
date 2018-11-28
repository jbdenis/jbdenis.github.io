#!/usr/bin/perl -w
#
# 16_08_05 16_09_01 16_09_08 16_09_09 16_09_11
# 17_04_05 17_04_06 17_09_24 17_09_25 18_09_30
#
use File::Copy;
use strict;
use uie; 
#
#
my $fipeb = "uie-fi5b.txt";
my $res0b = &uie::read8line(fil=>$fipeb);
&uie::print8structure(str=>$res0b);
&uie::pause(mes=>"Checking line treatment");
#
$fipeb = "uie-fi5c.txt";
$res0b = &uie::read8line(fil=>$fipeb);
&uie::print8structure(str=>$res0b);
&uie::pause(mes=>"Idem previous removing some lines");
#
my $rvo = &uie::read8line(fil=>"uie-fid.txt",
                           typ=>2,
                           khh=>{kwd=>{},cat=>{},com=>{}}
                          );
&uie::print8structure(str=>$rvo);
&uie::pause(mes=>"checking a reference file for phoges");
#
my $fich = "uie-fi4.txt";
my $k1 = ["a"]; my $k2 = [@$k1,"r","c"]; my $k3 = [@$k2,"STD"];
for my $kk ($k1,$k2,$k3) { for my $ordre (0,1) {
    my $kkk = {};
    foreach (@$kk) { $kkk->{$_} = $ordre;}
    my $res0 = &uie::read8line(fil=>$fich,typ=>2,khh=>$kkk);
    &uie::print8structure(str=>$res0);
    &uie::pause(mes=>"Hash avec ".join("-",@$kk)." et ordre = ".$ordre);
}}
#
&uie::print8err(err=>&uie::read8line(fil=>"tuto"));
&uie::pause(mes=>"Detecting the file doesn't exist");
#
my $fipe = "uie-fi5.txt";
my $res0 = &uie::read8line(fil=>$fipe);
&uie::print8structure(str=>$res0);
&uie::pause(mes=>"simplest reading");
#
my $fifi = "uie-fi5.txt";
my @khal = (["STD"],["a"],["b"]); my @khhl = ({"b"=>1},{"c"=>0},{"STD"=>1});
my $t = 2; my ($ka,$kh);
foreach my $ii (0..3) {
    if ($ii < 3) {
        $ka = $khal[$ii]; $kh = $khhl[$ii];
    } else {
        $t = 1;
    }
    if ($ii == 2) { $fifi = "uie-fi6.txt";}
    my $res1 = &uie::read8line(fil=>$fifi,fio=>"toto.txt",
                typ=>$t,kha=>$ka,khh=>$kh);
    &uie::print8structure(str=>$res1);
    my @ii = keys(%$kh);
    &uie::pause(mes=>"typ = $t kha = $$ka[0] khh = $ii[0]"); 
}
#
print "-"x4,"Fin du test de read8line","-"x25,"\n";
#
# fin du code
#
#############################################

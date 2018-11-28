#!/usr/bin/perl -w
#
# 16_03_08 17_04_05 17_11_12
#
use strict;
use warnings;
use uie; 

# removing multiple spaces
my $cha = " je ne   comprends   pas bien  ";
my $res = &uie::juste(cha=>$cha,tri=>0,spa=>"s",lon=>0);
print "res = <$res>\n";
&uie::pause(mes=>"No More Multiple ?");
#
my @ch = ("ABCDEFGHIJKLMNOPQRSTUVWXYZ",
          "JE ne veux plus voir un tel DESASTRE !");
foreach my $ch (@ch) {
foreach my $long (1..5,8,19,26,30,50) { 
for my $jus ("R","r","C","c","L","l","n") {
    for my $typ ("n","U","L","C","c") {
        print "($long $jus $typ) ";
        my %aaa = (cha=>$ch,tri=>0    ,ava=>"",ulc=>$typ,
                   apr=>"" ,lon=>$long, jus=>$jus);
        print "<",&uie::juste(%aaa),">\n";
    }
    &uie::pause(mes=>"OK ?");
}}}
#
print "-"x4,"Fin du test de juste","-"x25,"\n";
#
# fin du code
#
#############################################

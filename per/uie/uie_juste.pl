#!/usr/bin/perl -w
#
# 16_03_08
#
use strict;
use warnings;
use uie; 

#
my @ch = ("ABCDEFGHIJKLMNOPQRSTUVWXYZ",
          "JE ne veux plus voir un tel DESASTRE !");
foreach my $ch (@ch) {
foreach my $long (1..5,8,19,26,30,50) { 
for my $jus ("R","r","C","c","L","l","n") {
    for my $typ ("n","U","L","C","c") {
        print "($long $jus $typ) ";
        my %aaa = (chain=>$ch,trim=>0    ,avant=>"",ulca=>$typ,
                   apres=>"" ,long=>$long, just=>$jus);
        print "<",&uie::juste(%aaa),">\n";
    }
    &uie::pause(mess=>"OK ?");
}}}
#
print "-"x4,"Fin du test de juste","-"x25,"\n";
#
# fin du code
#
#############################################

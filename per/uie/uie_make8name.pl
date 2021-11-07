#!/usr/bin/perl -w
#
# 20_01_12 20_01_14 20_01_15
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/uie";
use uie; 
#
#
my $inina = [{nom=>["A.truc","B.machin","C.bidule"],
              num=>{nb2=>3,dig=>4},ada=>{wha=>"d"}},
             {}
            ];
my $forma = ["<ada> <nom[1]>/utile/<num[toto]>.jpg","SIMPLE-CHAINE"];
my $res;
#
for my $nam (@$inina) { for my $form (@$forma) {
    my $msi = "{".join("-",keys(%$nam))."} with $form";
    $res = &uie::check8err(obj=>&uie::make8name(ini=>$nam,fmt=>$form,len=>3),
                           wha=>1,sig=>$msi);
    &uie::la(str=>$res,mes=>$msi);
}}
#
print "-"x4,"Fin du test de make8name","-"x25,"\n";
#
# fin du code
#
#############################################

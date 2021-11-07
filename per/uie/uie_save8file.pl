#!/usr/bin/perl -w
#
# 19_05_02
#
use strict;
use warnings;
use lib '.';
use uie;
use File::Copy;
use File::Basename;

# creating a file
my $fic = "toto.txt";
foreach ("a","b","c") {
    my $toto = "toto-$_.txt";
    copy("uie.pm",$toto) or die("ne pus pas créer $toto");
}
#
foreach my $wa ("p","r","s","d") {
    &uie::check8err(obj=>&uie::save8file(fil=>"toto-*.txt",wha=>$wa,imp=>1),sig=>"wha vaut $wa");
    &uie::pause(mes=>$wa);
}
#
print "-"x4,"Fin du test de save8file","-"x25,"\n";
#
# fin du code
#
#############################################

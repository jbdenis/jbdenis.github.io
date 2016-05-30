#!/usr/bin/perl -w
#
# releve pour se passer de MSW
#
# 15_08_14 16_01_28 16_01_29 16_03_11 16_03_20
#
use File::Copy;
use strict;
use uie; 

# les variables
my ($saisie,$brut,$trad);
#
print "Entrer quelques caractères : ";
chomp($saisie = <STDIN>);
$brut = &uie::numerical(cha=>$saisie,tra=>0);
$trad = &uie::numerical(cha=>$saisie);
print "Voici ce que j'ai compris : <",$brut,"> et <",$trad,">\n";
#
# fin du code
#
#############################################

#!/usr/bin/perl -w
#
# 16_03_20 16_04_11 17_04_05
#
use strict;
use warnings;
use uie; 
#
my $answer;
#
&uie::pause("help");
&uie::pause;
&uie::pause("HELP");
&uie::pause;
#
&uie::pause(mes=>"a message");
#
$answer = &uie::pause(mes=>"give something to be returned...",con=>"CONT");
print "'$answer' a été renvoyé\n";
#
$answer = &uie::pause(mes=>"give something to be returned...");
print "'$answer' a été renvoyé\n";
#
$answer = &uie::pause(sto=>"ss",mes=>"ne pas stopper pour voir la suite !");
print "'$answer' a été renvoyé\n";
#
$answer = &uie::pause(mes=>"J'ajouter une question\n en deux lignes");
print "'$answer' a été renvoyé\n";
#
$answer = &uie::pause(mes=>"Rien à dire, cela marche...",sto=>"stop");
print "'$answer' a été renvoyé\n";
#
print "-"x4,"test de 'pause' terminé","-"x25,"\n";
#
# fin du code
#
#############################################

#!/usr/bin/perl -w
#
# 16_03_20 16_04_11
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
&uie::pause("mess");
&uie::pause;
&uie::pause("stst");
&uie::pause;
#
$answer = &uie::pause(mess=>"give something to be returned...");
print "'$answer' a été renvoyé\n";
#
$answer = &uie::pause(stst=>"ss",mess=>"ne pas stopper pour voir la suite !");
print "'$answer' a été renvoyé\n";
#
$answer = &uie::pause(mess=>"J'ajouter une question\n en deux lignes");
print "'$answer' a été renvoyé\n";
#
$answer = &uie::pause(mess=>"Rien à dire, cela marche...",stst=>"stop");
print "'$answer' a été renvoyé\n";
#
print "-"x4,"test de 'pause' terminé","-"x25,"\n";
#
# fin du code
#
#############################################

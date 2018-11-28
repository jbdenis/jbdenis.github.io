#!/usr/bin/perl -w
#
# 16_01_28 16_01_29 16_02_20 16_03_19 16_03_20
# 16_04_04 16_04_13 17_04_04
#
use strict;
use warnings;
use uie; 

#
# l'aide en ligne
&uie::check8ref("help");
&uie::pause;
&uie::check8ref("ref");
&uie::pause;
&uie::check8ref("typ");
&uie::pause;
#
# une référence
print &uie::check8ref(ref=>[1..5]),"\n";
&uie::pause(mes=>"simple référence of an array");
#
# les variables
my $test=0;
my @test;
my %test = map { $_ => 1 } (1..6);
foreach (keys %test) {
    print $_," : ",$test{$_},"\n";
}
#
my @typ = ("s","a","h","sa","sh","ah","sah");
#
for (@typ) {
    my $res = &uie::check8ref(ref=>\1,typ=>$_);
    print " "x40, "référence to numeric avec $_ donne $res\n";
}
&uie::pause;
print "-"x4,"Première phase du test de check8ref","-"x25,"\n";
#
for (@typ) {
    my $res = &uie::check8ref(ref=>\$test,typ=>$_);
    print " "x40, "référence scalaire avec $_ donne $res\n";
}
&uie::pause;
print "-"x4,"Seconde phase du test de check8ref","-"x25,"\n";
#
for (@typ) {
    my $res = &uie::check8ref(ref=>\@test,typ=>$_);
    print " "x40, "référence de tableau avec $_ donne $res\n";
}
&uie::pause;
print "-"x4,"Troisième phase du test de check8ref","-"x25,"\n";
#
@test = ("a","b","C");
for my $i (2..4) {
    my $res = &uie::check8ref(ref=>\@test,typ=>"a",rlo=>[1,$i]);
    print " "x40, "référence de tableau avec longueur maximale $i donne $res\n";
}
&uie::pause;
print "-"x4,"Troisième phase bis du test de check8ref","-"x25,"\n";
#
for (@typ) {
    my $res = &uie::check8ref(ref=>\%test,typ=>$_);
    print " "x40, "référence de hachage avec $_ donne $res\n";
}
&uie::pause;
print "-"x4,"Quatrième phase du test de check8ref","-"x25,"\n";
#
for my $i (5..7) {
    my $res = &uie::check8ref(ref=>\%test,typ=>"h",rlo=>[1,$i]);
    print " "x40, "référence de hachage avec longueur maximale de $i donne $res\n";
}
&uie::pause;
print "-"x4,"Quatrième phase bis du test de check8ref","-"x25,"\n";
#
for (@typ) {
    my $res = &uie::check8ref(ref=>\%test,typ=>$_,key=>[1..6]);
    print " "x40, "référence de hachage plus bonnes clefs avec $_ donne $res\n";
}
&uie::pause;
print "-"x4,"Cinquième phase du test de check8ref","-"x25,"\n";
#
for (@typ) {
    my $res = &uie::check8ref(ref=>\%test,typ=>$_,key=>[1..3]);
    print " "x40, "référence de hachage plus mauvaises clefs avec $_ donne $res\n";
}
&uie::pause;
print "-"x4,"Sixième phase du test de check8ref","-"x25,"\n";
#
# fin du code
#
#############################################

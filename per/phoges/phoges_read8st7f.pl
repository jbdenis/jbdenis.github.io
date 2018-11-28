#!/usr/bin/perl -w
#
# 16_08_13 16_08_14 16_09_10 16_09_12 17_09_24
# 17_10_02 17_10_06 18_04_09
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
my $fifi;
#
$fifi = "phoges-fi1.txt";
my $res1 = &phoges::read8st7f(fil=>$fifi);
if (&uie::err9(obj=>$res1)) {
    print "Error was found when reading the reference file\n";
    &uie::print8err(err=>$res1);
} else {
    print "No error was found when reading the reference file\n";
    &uie::print8structure(str=>$res1);
}
&uie::pause(mes=>"A tiny shortcut file");
#
$fifi = "phoges-fi2.txt";
my $res2 = &phoges::read8st7f(fil=>$fifi,ref=>$res1);
if (&uie::err9(obj=>$res2)) {
    print "Error was found when reading the reference file\n";
    &uie::print8err(err=>$res2);
} else {
    print "No error was found when reading the reference file\n";
    print "\n\n\n<1> \$res1 ";
    &uie::print8structure(str=>$res1);
    print "\n\n\n<2> \$res2 ";
    &uie::print8structure(str=>$res2);
}
&uie::pause(mes=>"A reference file with cumulation");
#
$fifi = "phoges-fi3.txt";
my $rese = &phoges::read8st7f(fil=>$fifi,ref=>$res1);
if (&uie::err9(obj=>$rese)) {
    print "Error was found when reading the reference file\n";
    &uie::print8err(err=>$rese);
} else {
    print "No error was found when reading the reference file\n";
    &uie::print8structure(str=>$rese);
}
&uie::pause(mes=>"A reference file with some error");
#
$fifi = "phoges-fififi.txt";
my $resf = &phoges::read8st7f(fil=>$fifi);
if (&uie::err9(obj=>$resf)) {
    print "Error was found when reading the reference file\n";
    &uie::print8err(err=>$resf);
} else {
    print "No error was found when reading the reference file\n";
    &uie::print8structure(str=>$resf);
}
&uie::pause(mes=>"When the reference file doesn't exist!");
#
print "-"x4,"Fin du test de read8st7f.pl","-"x25,"\n";
#
#############################################

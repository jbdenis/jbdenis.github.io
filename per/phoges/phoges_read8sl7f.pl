#!/usr/bin/perl -w
#
# 18_01_05
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
my $fifi;
#
$fifi = "phoges-fi2.txt";
my $rese = &phoges::read8sl7f(fil=>$fifi);
if (&uie::err9(obj=>$rese)) {
    print "Error was found when reading the selection file\n";
    &uie::print8err(err=>$rese);
} else {
    print "No error was found when reading the selection file\n";
    &uie::print8structure(str=>$rese);
}
&uie::pause(mes=>"A selection file without any selection");
#
$fifi = "phoges-fififi.txt";
my $resf = &phoges::read8sl7f(fil=>$fifi);
if (&uie::err9(obj=>$resf)) {
    print "Error was found when reading the selection file\n";
    &uie::print8err(err=>$resf);
} else {
    print "No error was found when reading the selection file\n";
    &uie::print8structure(str=>$resf);
}
&uie::pause(mes=>"When the selection file doesn't exist!");
#
$fifi = "phoges-fid.txt";
my $res1 = &phoges::read8sl7f(fil=>$fifi);
if (&uie::err9(obj=>$res1)) {
    print "Error was found when reading the selection file\n";
    &uie::print8err(err=>$res1);
} else {
    print "No error was found when reading the selection file\n";
    &uie::print8structure(str=>$res1);
}
&uie::pause(mes=>"First Try");
#
print "-"x4,"Fin du test de read8sl7f.pl","-"x25,"\n";
#
#############################################

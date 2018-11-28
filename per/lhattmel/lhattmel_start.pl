#!/usr/bin/perl -w
#
# 17_12_22 18_02_02
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/lhattmel";
use lhattmel; 
#
my ($para,$re1,$re2,$res,@res);
my $test = "toto";
$para = {tit=>"Pour COMMENCER"};
$re1 = &lhattmel::start(par=>$para);
$re2 = &lhattmel::end();
@res = (@$re1,@$re2);
open(TOTO,">","$test.tex");
foreach (@res) { print TOTO $_,"\n";}
close(TOTO);
if (system("pdflatex $test.tex $test.pdf")) {
    print "Compilation latex non réussie !\n";
    print "Le source est dans $test.tex\n";
    die;
}
$re1= &lhattmel::start(par=>$para,typ=>"h");
$re2 = &lhattmel::end(typ=>"h");
@res = (@$re1,@$re2);
open(TOTO,">","$test.html");
foreach (@res) { print TOTO $_,"\n";}
close(TOTO);
system("ls -lrt $test.*");
#
#
#
print "-"x4,"End of lhattmel_start.pl","-"x25,"\n";
#
#############################################

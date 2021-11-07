#!/usr/bin/perl -w
#
# 18_03_09 18_03_18 19_04_06
#
use strict;
use warnings;
#
use lib "/home/jbdenis/o/info/perl/phoges";
use phoges; 
#
my (@cha);
my $pi1 = &phoges::new7pi(wha=>"col");
$pi1->{"q"} = ["Jean","Paul","x1","x2","p4","PAY"];
$pi1->{"p"} = ["carrée","p3"];
$pi1->{"k"} = ["rond","p1","p2","triangle","y1","y2","x3"];
$pi1->{"g"} = ["PTR"];
#
my $stc = &phoges::read8st7f(fil=>"phoges-fio.txt");
print "STF\n";
&uie::print8structure(str=>$stc);
foreach my $ss ($stc) {
    print "AVANT\n"; &uie::print8structure(str=>$pi1);
    #
    my $pi2 = &phoges::update8st7pi(xpi=>$pi1,stc=>$ss);
    #
    &uie::la(str=>$pi2,mes=>"APRÈS");
}
#
#
print "-"x4,"End of testing 'update8st7pi'","-"x25,"\n";
#
#############################################

#!/usr/bin/perl -w
#
# 18_03_09 18_03_18
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
my (@cha);
#
my $pi1 = {
            "q"=>["Jean","Paul","x1","x2","p4","PAY"],
            "p"=>["carrée","p3"],
            "k"=>["rond","p1","p2","triangle","y1","y2","x3"],
            "g"=>["PTR"]
           };
#
my $stc = &phoges::read8st7f(fil=>"phoges-fio.txt");
print "STF\n";
&uie::print8structure(str=>$stc);
my $nul = {};
foreach my $ss ($stc,$nul) {
    print "AVANT\n"; &uie::print8structure(str=>$pi1);
    #
    my $pi2 = &phoges::update8st7pi(pis=>$pi1,stc=>$ss);
    #
    print "APRÈS\n"; &uie::print8structure(str=>$pi2);
    &uie::pause(mes=>"First with stf; Second without");
}
#
#
print "-"x4,"End of testing 'update8st7pi'","-"x25,"\n";
#
#############################################

#!/usr/bin/perl -w
#
# 20_01_10
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/uie";
use uie; 
#
#
my $nb1 = 98; my $nb2 = 109; my $nb3 = 11;
my $res;
#
$res = &uie::check8err(obj=>&uie::seqn(nb1=>3,nb2=>4,typ=>2,bef=>"<<",aft=>">>",wit=>"|.|"),
		       wha=>1,sig=>"Crossed Numbering");
&uie::la(str=>$res,mes=>"Crossed Numbering");
#
for my $dig (undef,-1,0,5) {
    $res = &uie::check8err(obj=>&uie::seqn(nb1=>$nb1,nb2=>$nb2,dig=>$dig,bef=>"avant",aft=>"après"),
                           wha=>1,sig=>"$nb1 - $nb2 with $dig");
    &uie::la(str=>$res,mes=>"$nb1 - $nb2 with $dig");
    $res = &uie::check8err(obj=>&uie::seqn(nb2=>$nb3,dig=>$dig),
                           wha=>1,sig=>"$nb3 with $dig");
    &uie::la(str=>$res,mes=>"$nb3 with $dig");
}
#
print "-"x4,"Fin du test de seqn","-"x25,"\n";
#
# fin du code
#
#############################################

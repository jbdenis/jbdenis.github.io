#!/usr/bin/perl -w
#
# 20_09_19 20_09_22 20_09_23
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/uie";
#use lib "/home/jbdenis/liane/o/info/perl/uie";
use uie;
#
my $x = [
         [],
         ["Un beau Paragraphe"],"",
         "z",
         ["e","f","E"],
         [[[[[[["e","f"]]]]]],"E"],
         "simple chain followed by an empty one","",
         ["a",["B","B"],"c",[["d","R",[["rr"]]]]],
         [["c1","c2",undef,"","123"]],
	 ["c"],
	 [[["c11","c12"],"mA",[],["","BO"],["c21"]]],
	 [[["c11","c12"],[],undef,[""],["c21"]]],
	 [[[["c111","c112"],["c121",""],[""],[]],
	   [["c211","c212"],["c221","c222","c223"]],
	   [[],undef,undef,[]]
	  ]]
	];
#
my %quoi = (cto=>0,cun=>0,cvo=>0,cfi=>0,
                          ato=>0,avo=>0,afi=>0,
                          nmn=>0,nre=>0,
	    var=>[],vch=>"");
#
foreach my $ii (0..$#$x) {
    &uie::la(str=>$x->[$ii]);
    my $resu = &uie::check8narray(xxx=>$x->[$ii],lmx=>8);
    #&uie::la(str=>$resu->{ale},mes=>"Result");
    &uie::la(str=>$resu,mes=>"Result");
}
#
print "-"x4,"test de 'check8array' terminé","-"x25,"\n";
0;
#
# fin du code
#
#############################################

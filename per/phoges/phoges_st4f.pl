#!/usr/bin/perl -w
#
# 19_10_12
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/phoges";
use phoges; 
use lib "/home/jbdenis/o/info/perl/uie";
use uie;
#
#
my $fifi = "phoges-fiu-stf.txt";
system("cat $fifi"); &uie::pause(mes=>"shortcut input file");
#
&uie::la(str=>&phoges::st4f(fil=>$fifi),mes=>"default");
&uie::la(str=>&phoges::st4f(fil=>$fifi,whi=>[]),mes=>"tout");
&uie::la(str=>&phoges::st4f(fil=>$fifi,whi=>["kwd","pla"]),mes=>"kwd,pla");
&uie::la(str=>&phoges::st4f(fil=>$fifi,whi=>["pla","kwd"]),mes=>"pla,kwd");
#
#
#
print "-"x4,"End of testing 'st4f'","-"x25,"\n";
#
#############################################

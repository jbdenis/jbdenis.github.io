#!/usr/bin/perl -w 
#
# 16_02_01 16_02_09 16_02_12 16_02_18 16_02_23
# 16_03_22 16_03_30 16_05_05
#
use lib "/home/jbdenis/liana/info/perl/uie";
use File::Copy;
use strict;
use compta; 
#
print "\nTests are made for:\n\n";
print "     - &print8transaction\n";
print "     - &split8transaction\n";
print "     - &join8transaction\n";
print "\n\n";
&uie::pause;
#
my $tra = "2011/ 1/ 2 ec1->7  -14-CBJB=     74.23|Intermarché : : repas anni d'H|";
my $res = &compta::split8transaction(transa=>$tra);
foreach (keys %$res) {
    print $_,"\t",$$res{$_},"\n";
}
&uie::pause(mess=>"Une transaction a dû être découpée ?");
#
&compta::print8transaction(rtransa=>$res,details=>1);
&uie::pause(mess=>"Elle vient d'être affichée !");
#
my $transa = &compta::join8transaction(rtransa=>$res);
print $transa,"\n";
&uie::pause(mess=>"La transaction a été reconstituée.");
#
print "-"x4,"Fin du test de *8transaction","-"x25,"\n";
#
# fin du code
#
#############################################

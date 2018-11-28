#!/usr/bin/perl -w
#
# 17_04_02 17_09_24
#
use strict;
use warnings;
use uie; 
#
#
print "======= Tests of 'err9'\n\n";
my $re = &uie::err9(obj=>"z");
print "0? $re,\n";
#
$re = &uie::err9(obj=>[]);
print "0? $re\n";
#
$re = &uie::err9(obj=>["uu","vv"]);
print "0? $re\n";
#
$re = &uie::err9(obj=>[$uie::err_ide,"vv"]);
print "1? $re\n";
&uie::pause;
#
#
print "\n======= Tests of 'add8err'\n\n";
my $ero = "no";
$ero = &uie::add8err(err=>$ero,nsu=>"1",erm=>["un"]);
$ero = &uie::add8err(err=>$ero,nsu=>"2",erm=>["deux","dos"]);
$ero = &uie::add8err(err=>$ero,nsu=>"3",erm=>["trois","tres","three"]);
$ero = &uie::add8err(err=>$ero,nsu=>"3bis",erm=>["trois","tres","three"]);
$ero = &uie::add8err(err=>$ero,nsu=>"zero",erm=>["bof","null"]);
&uie::print8structure(str=>$ero);
&uie::pause;
#
print "\n======= Tests of 'print8err'\n\n";
&uie::print8err(err=>$ero);
&uie::pause;
my $err = [$uie::err_ide,"vv","w","xxx","yyyy"];
&uie::print8err(err=>$err);
&uie::pause;
#
print "\n======= Tests of 'conca8err'\n\n";
my $ess = &uie::conca8err(er1=>$err,er2=>$ero);
&uie::print8err(err=>$ess);
#
print "-"x4,"test des 'errors' terminé","-"x25,"\n";
#
# fin du code
#
#############################################

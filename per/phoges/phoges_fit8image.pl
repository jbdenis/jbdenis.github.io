#!/usr/bin/perl -w
#
# 18_12_30 19_03_07 19_10_03
#
use strict;
use warnings;
use lib "/home/jbdenis/u/perl";
use lhattmel; 
use jours;
use lib "/home/jbdenis/o/info/perl/phoges";
use phoges; 
#
my ($fifi,$res,$fofo);
unlink(("toto0.jpg","toto1.jpg","toto2.jpg"));
#
$fifi = "phoges-pic21.jpg";
$res = &uie::check8err(obj=>&phoges::fit8image(ppi=>-345,orf=>$fifi,def=>"toto0.jpg",imp=>3));
$res = &uie::check8err(obj=>&phoges::fit8image(ppi=>-543,orf=>$fifi,def=>"totoX.jpg",imp=>3));
#$res = &uie::check8err(obj=>&phoges::fit8image(ppi=>0,orf=>$fifi,def=>"toto2.jpg",imp=>3));
#$res = &uie::check8err(obj=>&phoges::fit8image(ppi=>0,orf=>$fifi,def=>"toto2.jpg",imp=>3));
#$res = &uie::check8err(obj=>&phoges::fit8image(ppi=>30,orf=>$fifi,def=>"toto0.jpg",hei=>"5cm",wid=>undef,imp=>3));
#$res = &uie::check8err(obj=>&phoges::fit8image(ppi=>30,orf=>$fifi,def=>"totoX.jpg",hei=>"5cm"           ,imp=>3));
#$res = &uie::check8err(obj=>&phoges::fit8image(ppi=>30,orf=>$fifi,def=>"toto1.jpg",hei=>"5cm",wid=>undef,imp=>3,auo=>1));
#$res = &uie::check8err(obj=>&phoges::fit8image(orf=>$fifi,def=>"toto1.jpg",hei=>"10cm ",wid=>"3cm",imp=>3));
#$res = &uie::check8err(obj=>&phoges::fit8image(orf=>$fifi,def=>"toto2.jpg",wid=>"10cm",imp=>3));
print "-"x54,"\n";
print "-"x4,"Fin du test de fit8image","-"x25,"\n";
print "-"x54,"\n";
#
#############################################

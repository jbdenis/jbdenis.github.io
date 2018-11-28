#!/usr/bin/perl -w
#
# 18_10_11
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/phoges";
use phoges; 
use lib "/home/jbdenis/o/info/perl/lhattmel";
use lhattmel; 
#
my ($fifi,$res);
#
$fifi = "phoges-fin";
$res = &uie::check8err(obj=>&phoges::update8image4di7f(dif=>$fifi,
                                                  ppa=>{aut=>"Madelon",two=>1,nus=>1,red=>0.8,
                                                        cfraon => "Le nom du fichier est",
                                                        cfracp => "...c'était le lieu!",
                                                        cfraom => "(((",
                                                        cfracm => ")))",
                                                        sepbq => "-+-",gilab=> 1
                                                       },
                                                 cap=>"mtpqkgI"));
#
print "-"x54,"\n";
print "-"x4,"Fin du test de update8image4di7f","-"x25,"\n";
print "-"x54,"\n";
#
#############################################

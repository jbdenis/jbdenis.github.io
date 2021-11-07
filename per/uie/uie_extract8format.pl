#!/usr/bin/perl -w
#
# 20_01_14
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/uie";
use uie; 
#
#
my $forma = ["<nom[1]>.utile.<num[toto]>.jpg","Voir.jpg"];
my $res;
#
&uie::la(str=>$forma);
foreach my $form (@$forma) {
    print "\n    <<$form>>\n\n";
    $res = &uie::check8err(obj=>&uie::extract8format(fmt=>$form),
                           wha=>1,sig=>"WITH $form");
    &uie::la(str=>$res,mes=>"WITH $form");
}
#
print "-"x4,"Fin du test de extract8format","-"x25,"\n";
#
# fin du code
#
#############################################

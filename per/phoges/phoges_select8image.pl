#!/usr/bin/perl -w
#
# 18_01_05 18_03_31 18_04_02
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
#
# reading the criteria selection file
my $selec = &uie::check8err(obj=>&phoges::read8sl7f(fil=>"phoges-fid"));
#&uie::la(str=>$selec,mes=>"Criteria Selection from File");
#
my $image = &phoges::new7pi(wha=>"ind");
&uie::check8err(obj=>&phoges::check8pi(xpi=>$image),sig=>"Dans Programme de Test");
#
foreach my $crit (['ean',"Diffi"]) { 
foreach my $type ("IIB","IUB","XIB","XUB") {
        my $cri = {$type=>$crit};
        $image->{p} = ["place St Jean"];
        $image->{q} = ["Jeanie"];
        $image->{m} = ["Difficile d'y croire"];
        $image->{k} = ["villes","villages","hameaux"];
        $image->{g} = ["PTR"];
        &phoges::print8pi(xpi=>$image);
        my $res1 = &phoges::select8image(ima=>$image,cri=>$cri);
        &uie::pause(mes=>"\nFor $type | (@$crit) | ..... the result is $res1\n");
}}
&uie::pause(mes=>"It Was the Selection on place/people/keyword/category/comment");
#
$image = &phoges::new7pi(wha=>"ind");
foreach my $crit (['oire$',"^f"]) { 
for my $valu (["fête"],[],["boire"],["fête","boire"]) {
foreach my $type ("IIc","IUc","XIc","XUc") {
        my $cri = {$type=>$crit};
        $image->{c} = $valu;
        &phoges::print8pi(xpi=>$image);
        my $res1 = &phoges::select8image(ima=>$image,cri=>$cri);
        &uie::pause(mes=>"\nFor $type | (@$crit) | (@$valu), the result is $res1\n");
}}}
&uie::pause(mes=>"It Was the Selection on circumstances");
#
$image = &phoges::new7pi(wha=>"ind");
foreach my $crit (["U","^p"]) { 
for my $valu ([],["Un"],["pun"],["pun","Un"]) {
foreach my $type ("IIg","IUg","XIg","XUg") {
        my $cri = {$type=>$crit};
        $image->{g} = $valu;
        &phoges::print8pi(xpi=>$image);
        my $res1 = &phoges::select8image(ima=>$image,cri=>$cri);
        &uie::pause(mes=>"\nFor $type | (@$crit) | (@$valu), the result is $res1\n");
}}}
&uie::pause(mes=>"It Was the Selection on Categories");
#
$image = &phoges::new7pi(wha=>"ind");
foreach my $date ("2018_07_14","","2017_06") {
foreach my $type ("IIt","IUt","XIt","XUt") {
foreach my $crit (["2018_07_14"],["2017"],["2017_06"]) {
    $image->{t} = $date;
    my $sele = {$type=>$crit};
    my $res1 = &uie::check8err(obj=>&phoges::select8image(ima=>$image,cri=>$sele));
    &phoges::print8pi(xpi=>$image);
    &uie::pause(mes=> "For $type -> $crit->[0] :|: the result is $res1\n");
}}}
&uie::pause(mes=>"Time Selection Done");
#
#
print "-"x4,"Fin du test de select8image.pl","-"x25,"\n";
#
#############################################

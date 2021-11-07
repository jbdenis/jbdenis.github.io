#!/usr/bin/perl -w
#
# 19_04_03
#
use strict;
use warnings;
#
use lib "/home/jbdenis/o/info/perl/phoges";
use phoges;
#
my @compo = ("c","m","p","q","k","g","t","o","d","h");
my ($re5);
#
my $pi5 = &phoges::new7pi(wha=>"COL");
$pi5->{c} = [["ENFIN","pas trop tôt !"],["déjà"],["attends","fini"]];
$pi5->{m} = [["Je m'étais mal réveillé ce jour-là..."],[""],["SI"]];
$pi5->{p} = [["Magny-En-Vexin,Estreez"],["Archemont"],[""]];
$pi5->{q} = [["jbd"]];
$pi5->{k} = [["un","deux"]];
$pi5->{g} = [[""]];
$pi5->{d} = "../../ori";
&uie::la(str=>$pi5);
foreach (@compo) {
    $re5 = &phoges::pi9(xpi=>$pi5,wha=>$_);
    print "( $_ = $re5 )    ";
}
&uie::pause(mes=>"COL???");
#
$pi5 = &phoges::new7pi(wha=>"col");
$pi5->{m} = [["Je m'étais mal réveillé ce jour-là..."],[""],["SI"]];
$pi5->{p} = [["Magny-En-Vexin,Estreez"],["Archemont"],[""]];
$pi5->{o} = "jbd";
$pi5->{k} = [["un","deux"]];
$pi5->{g} = [[""]];
$pi5->{d} = "../../ori";
&uie::la(str=>$pi5);
foreach (@compo) {
    $re5 = &phoges::pi9(xpi=>$pi5,wha=>$_);
    print "( $_ = $re5 )    ";
}
&uie::pause(mes=>"col???");
#
$pi5 = &phoges::new7pi(wha=>"ind");
$pi5->{n} = "BelleImage.jpg";
$pi5->{m} = [["Je m'étais mal réveillé ce jour-là..."],[""],["SI"]];
$pi5->{p} = [["Magny-En-Vexin,Estreez"],["Archemont"],[""]];
$pi5->{o} = "jbd";
$pi5->{k} = [["un","deux"]];
$pi5->{g} = [[""]];
$pi5->{h} = {WID=>"5cm"};
&uie::la(str=>$pi5);
foreach (@compo) {
    $re5 = &phoges::pi9(xpi=>$pi5,wha=>$_);
    print "( $_ = $re5 )    ";
}
&uie::pause(mes=>"ind???");
#
$pi5 = &phoges::new7pi(wha=>"IND");
$pi5->{n} = "BelleImage.jpg";
$pi5->{c} = [["Une fois"],["Deux fois"],["Trois fois"]];
$pi5->{m} = [["Je m'étais mal réveillé ce jour-là..."],[""],["SI"]];
$pi5->{p} = [["Magny-En-Vexin,Estreez"],["Archemont"],[""]];
$pi5->{o} = "jbd";
$pi5->{k} = [["un","deux"]];
$pi5->{g} = [[""]];
$pi5->{h} = {WID=>"5cm"};
&uie::la(str=>$pi5);
foreach (@compo) {
    $re5 = &phoges::pi9(xpi=>$pi5,wha=>$_);
    print "( $_ = $re5 )    ";
}
&uie::pause(mes=>"IND???");
#
#
#
print "-"x4,"End of testing 'pi9'","-"x25,"\n";
#
#############################################

#!/usr/bin/perl -w
#
# 17_10_20 17_11_14 18_03_09
#
use strict;
use warnings;
use phoges; 
#
use lib "/home/jbdenis/o/info/perl/phoges";
my ($ret,$res,$rio,$fic);
my $fifi = "toto.txt"; 
#
# getting a raw index object
if (-e $fifi) { unlink($fifi);}
$fic = "phoges-fi5.txt";
$rio = &phoges::read8ic7f(icf=>$fic,cat=>["nn","pvv"]);
if (&uie::err9(obj=>$rio)) {
    &uie::print8err(err=>$rio);
    print(" AN ERROR was found with $fic!\n");
}
#
my $rip = $rio->{pic};
#
# making some selection with categories, keywords and comments
my @caca = ("pvv","nn");
my @keke = ("vvc","vx");
my @gaga = ("vv","x","c");
#
$res = &phoges::get8picture4rio(rip=>$rip,tys=>"ku",wha=>\@gaga);
&uie::print8structure(str=>$res);
&uie::pause(mes=>"unying keywords strictly in gaga");
$res = &phoges::get8picture4rio(rip=>$rip,tys=>"ki",wha=>\@gaga);
&uie::print8structure(str=>$res);
&uie::pause(mes=>"intersecting keywords strictly in gaga");
#ne trouve rien !
#
$res = &phoges::get8picture4rio(rip=>$rip,tys=>"KU",wha=>\@keke);
&uie::print8structure(str=>$res);
&uie::pause(mes=>"unying keywords strictly in keke");
$res = &phoges::get8picture4rio(rip=>$rip,tys=>"KI",wha=>\@keke);
&uie::print8structure(str=>$res);
&uie::pause(mes=>"intersecting keywords strictly in keke");
#
$res = &phoges::get8picture4rio(rip=>$rip,tys=>"cu",wha=>\@caca);
&uie::print8structure(str=>$res);
&uie::pause(mes=>"unying categories in caca");
$res = &phoges::get8picture4rio(rip=>$rip,tys=>"ci",wha=>\@caca);
&uie::print8structure(str=>$res);
&uie::pause(mes=>"intersecting categories in caca");
#
# making some selection from line numbers
my @lili = (0,5,10,16,undef);
for (my $ii = 1; $ii < scalar(@lili); $ii++) {
    my $i1 = $lili[$ii-1]; my $ii2;
    my $i2 = $lili[$ii]; if (defined($i2)) { $ii2 = $i2; } else { $ii2 = "undef";}
    print "In Between $i1 and ",$ii2," alors ",defined($i2)," :\n";
    $res = &phoges::get8picture4rio(rip=>$rip,tys=>"be",wha=>[$i1,$i2]);
    &uie::print8structure(str=>$res);
    print "In Between $i1 and ",$ii2," :\n";
    &uie::pause();
}
&uie::pause(mes=>"test with a small file");
#
#
print "-"x4,"Fin du test de get8picture4rio","-"x25,"\n";
#
#############################################

#!/usr/bin/perl -w
#
# 17_04_22 17_04_29
#
use strict;
use warnings;
use uie; 
#
my $didi = "~/t/a";
#
my $ff = "u";
my $resff = &uie::retrouve(dir=>$didi,qoi=>0,frg=>$ff);
if (&uie::err9(obj=>$resff)) {
    &uie::print8err(err=>$resff);
} else {
    &uie::print8structure(str=>$resff);
}
&uie::pause(mes=>"every file from $didi with ".$ff);
#
$ff = "~\$"; $didi = "~/t/corbeille";
$resff = &uie::retrouve(dir=>$didi,qoi=>0,frg=>$ff);
if (&uie::err9(obj=>$resff)) {
    &uie::print8err(err=>$resff);
} else {
    &uie::print8structure(str=>$resff);
}
&uie::pause(mes=>"every file from $didi with ".$ff);
#
#
print "-"x4,"uie_retrouve finished","-"x25,"\n";
exit 0;
#

#!/usr/bin/perl -w
#
# 17_04_27
#
use strict;
use warnings;
use uie; 
#
my $resu;
my $txtfi = "uie-fi9.txt";
my $txtfib = "uie-fi9b.txt";
my $txtf2 = "uie-fic.txt";
my $htmfi = "uie-fia.txt";
my $htmf2 = "uie-fib.txt";
my $htmf2b = "uie-fibb.txt";
my $imafi = "uie-im1.png";
my $imaf2 = "uie-im2.png";
my $toto = "toto.eml";
my $add = 'jjbdenis@gmail.com'; # to be adapted
$add = ['jjbdenis@gmail.com','jjbdenis@wanadoo.fr','yolande.agresta@free.fr'];
#
# A series of one part sendings
$resu = &uie::make8eml(
                 fil => "$toto",
                 sbj => "ONE UTF8 text",
                 tow => $add,
                 txt => $txtfi,
                );
if (&uie::err9(obj=>$resu)) {
    &uie::print8err(err=>$resu);
    &uie::pause(mes=>"The test failed!");
} else {
    my $menvoi = "sendmail -t -F EX1 < $toto";
    system($menvoi);
}
#
$resu = &uie::make8eml(
                 fil => "$toto",
                 sbj => "ONE PURE ASCII text",
                 tow => $add,
                 txt => $txtfib,
                );
if (&uie::err9(obj=>$resu)) {
    &uie::print8err(err=>$resu);
    &uie::pause(mes=>"The test failed!");
} else {
    my $menvoi = "sendmail -t -F EX2 < $toto";
    system($menvoi);
}
#
$resu = &uie::make8eml(
                 fil => "$toto",
                 sbj => "ONE UTF8 HTML",
                 tow => $add,
                 htm => $htmf2,
                );
if (&uie::err9(obj=>$resu)) {
    &uie::print8err(err=>$resu);
    &uie::pause(mes=>"The test failed!");
} else {
    my $menvoi = "sendmail -t -F EX3 < $toto";
    system($menvoi);
}
#
$resu = &uie::make8eml(
                 fil => "$toto",
                 sbj => "ONE PURE ASCII HTML",
                 tow => $add,
                 htm => $htmf2b,
                );
if (&uie::err9(obj=>$resu)) {
    &uie::print8err(err=>$resu);
    &uie::pause(mes=>"The test failed!");
} else {
    my $menvoi = "sendmail -t -F EX4 < $toto";
    system($menvoi);
}
#
$resu = &uie::make8eml(
                 fil => "$toto",
                 sbj => "JUST ONE PICTURE",
                 tow => $add,
                 b64 => $imafi,
                );
if (&uie::err9(obj=>$resu)) {
    &uie::print8err(err=>$resu);
    &uie::pause(mes=>"The test failed!");
} else {
    my $menvoi = "sendmail -t -F EX5 < $toto";
    system($menvoi);
}
#
&uie::pause(mes=>"five messages must have been sent");
#
#
$resu = &uie::make8eml(
                 fil => "$toto",
                 sbj => "a message with 2 text messages, 2 html messages and 1 image",
                 tow => $add,
                 cco => 'jjbdenis@wanadoo.fr',
                 txt => [$txtfi,$txtf2],
                 htm => [$htmfi,$htmf2],
                 b64 => [$imafi,$imaf2]
                );
#
if (&uie::err9(obj=>$resu)) {
    &uie::print8err(err=>$resu);
    &uie::pause(mes=>"The test failed!");
} else {
    my $menvoi = "sendmail -t -F OUF < $toto";
    system($menvoi);
}
&uie::pause(mes=>"A message comprising five parts (2T2H1I) must have been sent");
#
#
$resu = &uie::make8eml(
                 fil => "$toto",
                 sbj => "Just to help you",
                 tow => 'jb@denis.fr',
                 cco => 'dgebi@denis.fr',
                 bcc => 'jd@denis.fr',
                 txt => $txtfi,
                 htm => "",
                 b64 => "",
                );
#
if (&uie::err9(obj=>$resu)) {
    &uie::print8err(err=>$resu);
    &uie::pause(mes=>"The test failed!");
} else {
    open(TOTO,"<$toto") or die("Can't open $txtfi");
    foreach (<TOTO>) { print $_;}
    close(TOTO);
}
&uie::pause(mes=>"Composition d'un premier message");
#
#
$resu = &uie::make8eml(
                 fil => "$toto",
                 sbj => "a text message 4",
                 tow => $add,
                 txt => $txtfi,
                 htm => "",
                 b64 => "",
                );
#
if (&uie::err9(obj=>$resu)) {
    &uie::print8err(err=>$resu);
    &uie::pause(mes=>"The test failed!");
} else {
    my $menvoi = "sendmail -t -F TUTU < $toto";
    system($menvoi);
}
&uie::pause(mes=>"A text message must have been sent");
#
#
$resu = &uie::make8eml(
                 fil => "$toto",
                 sbj => "a text message plus one image 1",
                 tow => $add,
                 txt => $txtfi,
                 htm => "",
                 b64 => $imafi,
                );
#
if (&uie::err9(obj=>$resu)) {
    &uie::print8err(err=>$resu);
    &uie::pause(mes=>"The test failed!");
} else {
    my $menvoi = "sendmail -t -F TITI < $toto";
    system($menvoi);
}
&uie::pause(mes=>"A text message with an attached image must have been sent");
#
#
$resu = &uie::make8eml(
                 fil => "$toto",
                 sbj => "an html message (1)",
                 tow => $add,
                 txt => "",
                 htm => $htmfi,
                 b64 => "",
                );
#
if (&uie::err9(obj=>$resu)) {
    &uie::print8err(err=>$resu);
    &uie::pause(mes=>"The test failed!");
} else {
    my $menvoi = "sendmail -t -F TATA < $toto";
    system($menvoi);
}
&uie::pause(mes=>"An html message must have been sent");
#
#
$resu = &uie::make8eml(
                 fil => "$toto",
                 sbj => "an html message plus one image (1)",
                 tow => $add,
                 txt => "",
                 htm => $htmfi,
                 b64 => $imafi,
                );
#
if (&uie::err9(obj=>$resu)) {
    &uie::print8err(err=>$resu);
    &uie::pause(mes=>"The test failed!");
} else {
    my $menvoi = "sendmail -t -F TARATATA < $toto";
    system($menvoi);
}
&uie::pause(mes=>"An html message plus image must have been sent");
#
#
$resu = &uie::make8eml(
                 fil => "$toto",
                 sbj => "a second html message (1)",
                 tow => $add,
                 txt => "",
                 htm => $htmf2,
                 b64 => "",
                );
#
if (&uie::err9(obj=>$resu)) {
    &uie::print8err(err=>$resu);
    &uie::pause(mes=>"The test failed!");
} else {
    my $menvoi = "sendmail -t -F TATATA < $toto";
    system($menvoi);
}
&uie::pause(mes=>"An second html message (with headers) must have been sent");
#
#
#
print "-"x4,"Fin du test de make8ml","-"x25,"\n";
#
# fin du code
#
#############################################

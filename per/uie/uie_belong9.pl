#!/usr/bin/perl -w
#
# 16_03_23 16_03_26 16_08_30 17_04_04 17_11_03
#
use strict;
use warnings;
use uie; 
#
my ($answer,@b,$resu,@resu);
#
@b = (" soif  ","triste","soif","faim");
@resu = &uie::belong9(sca=>\"oi",arr=>\@b,com=>["=~ /","/"],sen=>1);
&uie::print8structure(str=>\@resu);
&uie::pause(mes=>"essai simple d'occurrence non stricte");
#
$resu = "    soif "=~ /^\s*soif\s*$/;
print("<",$resu,">\n");
@b = (" soif  ","soif");
print "< ",&uie::belong9(sca=>\"soif",arr=>\@b,com=>["=~ /^\\s*","\\s*\$/"])," >\n"; #"
&uie::pause(mes=>"en retirant les espaces des bouts (doubles '\' recommandés)");
#
@b = ("abc","CDe");
print "< ",&uie::belong9(sca=>\"cde",arr=>\@b,low=>1)," >\n";
print "< ",&uie::belong9(sca=>\"CDE",arr=>\@b,low=>1)," >\n";
&uie::pause(mes=>"deux fois < 1 > ?");
#
print "< ",&uie::belong9(sca=>\"cde",arr=>\@b,low=>1,com=>['eq "','"'])," >\n";
print "< ",&uie::belong9(sca=>\"CDE",arr=>\@b,low=>1,com=>['eq "','"'])," >\n";
&uie::pause(mes=>"deux fois < 1 > (avec opérateur de l'usager?");
#
&uie::belong9("help");
&uie::pause(mes=>"Liste des Arguments");
#
&uie::belong9("com");
&uie::pause(mes=>"Aide sur argument 'com'");
#
&uie::belong9("HELP");
&uie::pause(mes=>"Aide Générale");
#
my @a = 1..10;
print scalar &uie::belong9(sca=> \1,arr=>\@a),"\n";
print scalar &uie::belong9(sca=>\11,arr=>\@a),"\n";
&uie::pause(mes=>"1 puis 0 ?");
#
print "<",&uie::belong9(sca=> \1,arr=>\@a,low=>1),">\n";
print "<",&uie::belong9(sca=>\11,arr=>\@a,low=>1),">\n";
&uie::pause(mes=>"<0> puis <> ?");
#
print "< ",&uie::belong9(sca=>\"c",arr=>\@b,low=>0,com=>[" =~ /","/"])," >\n";
print "< ",&uie::belong9(sca=>\"c",arr=>\@b,low=>1,com=>[" =~ /","/"])," >\n";
&uie::pause(mes=>" <  > puis <  > ?");
#
my @B = ("B");
print "< ",&uie::belong9(sca=>\"abc",arr=>\@B,low=>0,com=>[" =~ /","/"])," >\n";
print "< ",&uie::belong9(sca=>\"abc",arr=>\@B,low=>1,com=>[" =~ /","/"])," >\n";
&uie::pause(mes=>" <  > puis < 0 > ?");
#
#
print "-"x4,"test de 'belong9' terminé","-"x25,"\n";
#
# fin du code
#
#############################################

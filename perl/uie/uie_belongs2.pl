#!/usr/bin/perl -w
#
# 16_03_23 16_03_26
#
use strict;
use warnings;
use uie; 
#
my $answer;
#
my @b = ("abc","CDe");
print "< ",&uie::belongs2(sca=>\"cde",arr=>\@b,low=>1)," >\n";
print "< ",&uie::belongs2(sca=>\"CDE",arr=>\@b,low=>1)," >\n";
&uie::pause(mess=>"deux fois < 1 > ?");
#
print "< ",&uie::belongs2(sca=>\"cde",arr=>\@b,low=>1,com=>['eq "','"'])," >\n";
print "< ",&uie::belongs2(sca=>\"CDE",arr=>\@b,low=>1,com=>['eq "','"'])," >\n";
&uie::pause(mess=>"deux fois < 1 > (avec opérateur de l'usager?");
#
&uie::belongs2("help");
&uie::pause(mess=>"Liste des Arguments");
#
&uie::belongs2("com");
&uie::pause(mess=>"Aide sur argument 'com'");
#
&uie::belongs2("HELP");
&uie::pause(mess=>"Aide Générale");
#
my @a = 1..10;
print scalar &uie::belongs2(sca=> \1,arr=>\@a),"\n";
print scalar &uie::belongs2(sca=>\11,arr=>\@a),"\n";
&uie::pause(mess=>"1 puis 0 ?");
#
print "<",&uie::belongs2(sca=> \1,arr=>\@a,low=>1),">\n";
print "<",&uie::belongs2(sca=>\11,arr=>\@a,low=>1),">\n";
&uie::pause(mess=>"<0> puis <> ?");
#
print "< ",&uie::belongs2(sca=>\"c",arr=>\@b,low=>0,com=>[" =~ /","/"])," >\n";
print "< ",&uie::belongs2(sca=>\"c",arr=>\@b,low=>1,com=>[" =~ /","/"])," >\n";
&uie::pause(mess=>" <  > puis <  > ?");
#
my @B = ("B");
print "< ",&uie::belongs2(sca=>\"abc",arr=>\@B,low=>0,com=>[" =~ /","/"])," >\n";
print "< ",&uie::belongs2(sca=>\"abc",arr=>\@B,low=>1,com=>[" =~ /","/"])," >\n";
&uie::pause(mess=>" <  > puis < 0 > ?");
#
#
print "-"x4,"test de 'belongs2' terminé","-"x25,"\n";
#
# fin du code
#
#############################################

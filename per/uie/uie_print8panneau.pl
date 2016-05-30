#!/usr/bin/perl -w
#
# 16_03_07 16_03_08 16_03_09 16_03_11 16_03_13
# 16_03_14 16_03_15 16_03_20 16_03_31 16_04_13
#
use File::Copy;
use strict;
use uie; 

#
&uie::print8panneau("help");
&uie::print8panneau("HELP");
&uie::pause;
#
&uie::print8panneau(rpan=>[],bfra=>undef,tfra=>undef,
                    tvoi=>0,bvoi=>0);
&uie::pause(mess=>"D'abord un panneau vide");
#
my $line1 = "Juste Pour Voir";
my $line2 = "UN PANNEAU";
my $line3 = "de trois lignes";
my $beaup = [\$line1,\$line2,\$line3];
for my $jj ('l','c','r') {
    &uie::print8panneau(rpan=>$beaup,just=>$jj);
    &uie::pause;
}
&uie::print8panneau(rpan=>$beaup,tfra=>"^"x45,tvoi=>3,lfra=>"[ ",rfra=>" ]",bvoi=>2,bfra=>"v"x45,just=>["l","c","r"],tcol=>undef);
&uie::pause;
&uie::print8panneau(rpan=>$beaup,tfra=>"^"x45,tvoi=>3,lfra=>"[ ",rfra=>" ]",bvoi=>2,bfra=>"v"x45,just=>["l","c","r"],tcol=>'red');
&uie::pause;
&uie::print8panneau(rpan=>$beaup,tfra=>"^"x45,tvoi=>3,lfra=>"[ ",rfra=>" ]",bvoi=>2,bfra=>"v"x45,just=>["l","c","r"],tcol=>['blue','white','red']);
&uie::pause;
#
&uie::print8panneau(rpan=>$beaup,tfra=>"^"x45,tvoi=>3,lfra=>"[ ",rfra=>" ]",bvoi=>2,bfra=>"v"x45,just=>["l","c","r"],fcol=>'on_blue blue');
&uie::pause(mess=>"Et pour finir, la coloration du seul cadre en gris");
#
print "-"x4,"Fin du test de print8panneau","-"x25,"\n";
#
# fin du code
#
#############################################

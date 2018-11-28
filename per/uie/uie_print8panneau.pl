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
&uie::print8panneau(rpa=>[],bfr=>undef,tfr=>undef,
                    tvo=>0,bvo=>0);
&uie::pause(mes=>"D'abord un panneau vide");
#
my $line1 = "Juste Pour Voir";
my $line2 = "UN PANNEAU";
my $line3 = "de trois lignes";
my $beaup = [\$line1,\$line2,\$line3];
for my $jj ('l','c','r') {
    &uie::print8panneau(rpa=>$beaup,jus=>$jj);
    &uie::pause;
}
&uie::print8panneau(rpa=>$beaup,tfr=>"^"x45,tvo=>3,lfr=>"[ ",rfr=>" ]",bvo=>2,bfr=>"v"x45,jus=>["l","c","r"],tco=>undef);
&uie::pause;
&uie::print8panneau(rpa=>$beaup,tfr=>"^"x45,tvo=>3,lfr=>"[ ",rfr=>" ]",bvo=>2,bfr=>"v"x45,jus=>["l","c","r"],tco=>'red');
&uie::pause;
&uie::print8panneau(rpa=>$beaup,tfr=>"^"x45,tvo=>3,lfr=>"[ ",rfr=>" ]",bvo=>2,bfr=>"v"x45,jus=>["l","c","r"],tco=>['blue','white','red']);
&uie::pause;
#
&uie::print8panneau(rpa=>$beaup,tfr=>"^"x45,tvo=>3,lfr=>"[ ",rfr=>" ]",bvo=>2,bfr=>"v"x45,jus=>["l","c","r"],fco=>'on_blue blue');
&uie::pause(mes=>"Et pour finir, la coloration du seul cadre en gris");
#
print "-"x4,"Fin du test de print8panneau","-"x25,"\n";
#
# fin du code
#
#############################################

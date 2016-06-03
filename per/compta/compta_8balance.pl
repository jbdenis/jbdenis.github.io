#!/usr/bin/perl -w
#
# 16_05_09 16_05_24
#
use lib "/home/jbdenis/liana/info/perl/uie";
use strict;
use warnings;
use compta; 
#
print "\nTests are made for:\n\n";
print "     - &make8balance\n";
print "     - &write8balance\n";
print "\n\n";
&uie::pause;
#
# reading the compulsory structures
my $fdef = "compta-defdef.txt";
my $fmon = "compta-solsol.txt";
my $fjou = "compta-joujou.txt";
my $rdef = &compta::read8definition(fdef=>$fdef);
my $rmon = &compta::read8montant(mon=>$fmon);
my $rjou = &compta::read8journal(fic=>$fjou);
#
# making the balance
unlink "tutu.txt";
my $rbalance = &compta::make8balance(rdef=>$rdef,rmon=>$rmon,rjou=>$rjou);
&compta::print8balance(rbal=>$rbalance,file=>"tutu.txt",rdef=>$rdef);
open(TUTU,"tutu.txt") or die "Peux Pas Ouvrir tutu.txt : $!.\n";
while(my $l = <TUTU>) {
    print $l;
}
close TUTU;
&uie::pause(mess=>"Bilan sur tout le journal");
#
unlink "tutu.txt";
my $rbalance = &compta::make8balance(rdef=>$rdef,rmon=>$rmon,rjou=>$rjou,peri=>["2011/01/08","2011/01/09"]);
&compta::print8balance(rbal=>$rbalance,file=>"tutu.txt",rdef=>$rdef);
open(TUTU,"tutu.txt") or die "Peux Pas Ouvrir tutu.txt : $!.\n";
while(my $l = <TUTU>) {
    print $l;
}
close TUTU;
&uie::pause(mess=>"Bilan sur une partie du journal");
#
unlink "tutu.txt";
my $rbalance = &compta::make8balance(rdef=>$rdef,rmon=>$rmon,rjou=>$rjou,rele=>"eb");
&compta::print8balance(rbal=>$rbalance,file=>"tutu.txt",rdef=>$rdef);
open(TUTU,"tutu.txt") or die "Peux Pas Ouvrir tutu.txt : $!.\n";
while(my $l = <TUTU>) {
    print $l;
}
close TUTU;
&uie::pause(mess=>"Bilan jusqu'au relevé 'eb'");
#
#
print "-"x4,"Fin du test de 8balance","-"x25,"\n";
#
# fin du code
#
#############################################

#!/usr/bin/perl -w
#
# 16_02_01 16_02_09 16_02_12 16_02_15 16_02_18
# 16_02_23 16_02_24 16_02_25 16_03_22 16_03_24
# 16_05_05
#
use lib "/home/jbdenis/liana/info/perl/uie";
use File::Copy;
use strict;
use warnings;
use compta; 
#
print "\nTests are made for:\n\n";
print "     - &read8journal\n";
print "     - &write8journal\n";
print "     - &sort8journal\n";
print "     - &select8journal\n";
print "\n\n";
&uie::pause;
#
my $fichier = "compta-joujou.txt";
my $journal = &compta::read8journal(fic=>$fichier);
print "référence = ",$journal," \n";
print "les clefs = ",join("+",keys %$journal)," \n";
print "les montants = ",join(" ",@{$journal->{hm}})," \n";
print "les postes = ",join(" ",@{$journal->{p}})," \n";
&uie::pause(mess=>"Fin du test de read8journal");
#
my $resu = "toto-journal.txt";
&compta::write8journal(rjou=>$journal,jour=>$resu);
system("ls -l $resu");
my $re2 = &compta::read8journal(fic=>$resu);
print $re2," \n";
&uie::pause(mess=>"Fin du test de write8journal");
#
my $joutri;
foreach ("date","from","to","FROM","TO","poste","type","val") {
    print $_,"\n";
    $joutri = &compta::sort8journal(rjou=>$journal,sor=>$_);
    &compta::write8journal(rjou=>$joutri,jour=>"toto-$_.txt");
}
$joutri = &compta::sort8journal(rjou=>$journal,sor=>[9,10]);
&compta::write8journal(rjou=>$joutri,jour=>"toto-day.txt");
$joutri = &compta::sort8journal(rjou=>$journal,sor=>[37,38]);
&compta::write8journal(rjou=>$joutri,jour=>"toto-cents.txt");
system("ls -l toto*txt");
#
print "-"x4,"Fin du test de sort8journal","-"x25,"\n";
&uie::pause;
#
my $jousel;
my %quoi = ("date"=>"gt '2011/01/10'",
            "from"=>"==5",
            "to"=>"!=7",
            "FROM"=>"=~ /^ /",
            "TO"=>"=~ /.eb/",
            "poste"=>"eq '14'",
            "type"=>"=~ /OA.0/",
            "val"=>">= 200.00");
#
foreach (keys %quoi) {
    $jousel = &compta::select8journal(rjou=>$journal,sele=>$_,oper=>$quoi{$_});
    &compta::write8journal(rjou=>$jousel,jour=>"totosel-$_.txt");
}
#
$jousel = &compta::select8journal(rjou=>$journal,sele=>[9,10],oper=>"eq 11");
&compta::write8journal(rjou=>$jousel,jour=>"toto-day.txt");
$jousel = &compta::sort8journal(rjou=>$journal,sort=>[37,38]);
&compta::write8journal(rjou=>$jousel,jour=>"toto-cents.txt");
system("ls -l toto*txt");
#
print "-"x4,"Fin du test de 8journal","-"x25,"\n";
#
# fin du code
#
#############################################

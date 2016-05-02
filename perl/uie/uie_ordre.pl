#!/usr/bin/perl -w
#
# test de la sub pour le tri entraine
#
# 16_02_15 16_03_20
#
use strict;
use uie; 

# tri numérique
print "^"x32,"\n";
my @vector = (2,5,3,2,7,1,0);
my $rord;
#
$rord = &uie::ordre(rar=>\@vector,num=>1);
for (my $i=0; $i < scalar @vector; $i++) {
    print $i," : ",$vector[$i]," - ",$$rord[$i]," - ",$vector[$$rord[$i]],"\n";
}
uie::pause(mess=>"sur un vecteur numérique");
print "^"x32,"\n";
#
$rord = &uie::ordre(rar=>\@vector,inc=>0,num=>1);
for (my $i=0; $i < scalar @vector; $i++) {
    print $i," : ",$vector[$i]," - ",$$rord[$i]," - ",$vector[$$rord[$i]],"\n";
}
uie::pause(mess=>"sur un vecteur numérique décroissant");
print "^"x32,"\n";
#
# tri alphabétique
print "^"x32,"\n";
@vector = ("Paul","Julie","Souad","David","Maurice",
	      "Claire","Eric","Catherine","Louis","Henriette");
$rord = &uie::ordre(rar=>\@vector);
for (my $i=0; $i < scalar @vector; $i++) {
    print $i," : ",$vector[$i]," - ",$$rord[$i]," - ",$vector[$$rord[$i]],"\n";
}
uie::pause(mess=>"sur un vecteur alphabétique croissant");
print "^"x32,"\n";
#
$rord = &uie::ordre(rar=>\@vector,inc=>0);
for (my $i=0; $i < scalar @vector; $i++) {
    print $i," : ",$vector[$i]," - ",$$rord[$i]," - ",$vector[$$rord[$i]],"\n";
}
uie::pause(mess=>"sur un vecteur alphabétique décroissant");
print "^"x32,"\n";
#
print "-"x4,"Fin du test de ordre","-"x25,"\n";
#
# fin du code
#
#############################################

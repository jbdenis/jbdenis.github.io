#!/usr/bin/perl -w
#
# 16_09_28 17_04_05
#
use strict;
use warnings;
use uie; 
#
my $hm = {
          v1 => [1..4],
          v2 => ["un","deux","trois","quatre"],
          v3 => ["Il 'etait une fois","une belle jeune fille","et un roi trop m'echant","..."],
         ORD => ["v3","v2","v1"]
         };
#
foreach my $wi (5,12,25) {
    print ("\n width = $wi \n\n");
    my $resu = &uie::print8hmat(hma=>$hm,wid=>$wi);
    if (!$resu) {
        print @{$uie::sei};
        print "\n";
    }
}
&uie::pause(mes=>"Impression avec ORD");
#
delete($hm->{$uie::ORD});
foreach my $wi (5,12,25) {
    print ("\n width = $wi \n\n");
    my $resu = &uie::print8hmat(hma=>$hm,wid=>$wi);
    if (!$resu) {
        print @{$uie::sei};
        print "\n";
    }
}
&uie::pause(mes=>"Impression sans ORD");
#
#
#
print "-"x4,"test de 'print8hmat' terminé","-"x25,"\n";
#
# fin du code
#
#############################################

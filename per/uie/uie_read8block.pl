#!/usr/bin/perl -w
#
# 16_01_30 16_03_20 16_03_26 16_03_28 17_04_05
# 17_11_14
#
use File::Copy;
use strict;
use uie; 

#
my $res2 = &uie::read8block(fil=>"uie-fi1.txt",
                            com=>undef,
                            bbl=> "<Comptes>",
                            ebl=>"</Comptes>");
foreach my $ligne (@$res2) {
    print(join(" <+> ",@$ligne),"\n");
}
&uie::pause(mes=>"tous, avec commentaires");
#
my $res1 = &uie::read8block(fil=>"uie-fi1.txt",
                            bbl=> "<Comptes>",
                            ebl=>"</Comptes>");
foreach my $ligne (@$res1) {
    print(join(" <+> ",@$ligne),"\n");
}
&uie::pause(mes=>"tous, sans commentaires");
#
my $res3 = &uie::read8block(fil=>"uie-fi1.txt",
                            bbl=> "<Comptes>",
                            ebl=>"</Comptes>",
                            uni=>1);
foreach my $ligne (@$res3) {
    print(join(" <+> ",@$ligne),"\n");
}
&uie::pause(mes=>"premier, sans commentaires");
#
my $res4 = &uie::read8block(fil=>"uie-fi1.txt",
                            bbl=> "<Comptes>",
                            ebl=>"</Comptes>",
                            sep=>undef,
                            uni=>1);
foreach my $ligne (@$res4) {
    print("'",$ligne,"'\n");
}
&uie::pause(mes=>"premier, sans commentaires, sans séparation");
#
print "-"x4,"Fin du test de read8block","-"x25,"\n";
#
# fin du code
#
#############################################

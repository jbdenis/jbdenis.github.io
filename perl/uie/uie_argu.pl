#!/usr/bin/perl -w
#
# 16_03_25 16_04_11
#
use strict;
use warnings;
use uie; 

sub essai {
    # dealing with the arguments
    my $help = {ars =>[ undef,"s","The element to be checked."],
                und =>[ undef,'cu',"either a chain or 'undef' to",
                                   "be indicated by the call"],
                ara =>[[1..5],"a","Some numbers in an array"],
                arh =>[ undef,"ha","Le troisième argument",
                                   "(either a reference to a hash",
                                   " or to an array)."],
                arn =>[     0,"nu","Une valeur numérique ou undef"],
                arc =>[ undef,"c","une chaine d'espoir"]
               };
    my $argu   = &uie::argu("essai",$help,@_);
    if ($argu == 1) { return 1;}
    my $ars = $argu->{ars};
    my $und = $argu->{und};
    my $ara = $argu->{ara};
    my $arh = $argu->{arh};
    my $arn = $argu->{arn};
    my $arc = $argu->{arc};
    # making the job
    print "Argument ars    = ",$ars,"\n";
    if (defined($und)) {
        print "Argument und = ",$und,"\n";
    } else {
        print "Argument und = is 'undef'\n";
    }
    print "Argument ara    =  @$ara  \n";
    if (ref($arh) eq "HASH") {
        print "Argument arh    =  It's a hash\n";
        &uie::print8structure(stru=>$arh);
    } else {
        print "Argument arh    =  It's an array: @$arh\n";
    }
    if (defined($arn)) {
        print "Argument arn    = It's a number $arn \n";
    } else {
        print "Argument arn    = is 'undef'\n";
    }
    print "Argument arc    = ",$arc,"\n";
    # returning
    "Fine!";
}
#
my $aa = 'A';
#
&essai(ars=>\$aa,
       arh=>["A"],
       arc=>"A",
       und=>"chaine pour und");
&uie::pause(mess=>" (1) und par une chaine");
#
&essai(ars=>\$aa,
       arh=>["A"],
       arc=>"A",
       und=>undef);
&uie::pause(mess=>" (1) und par undef");
#
&essai(ars=>\$aa,
       arh=>["A"],
       arc=>"A",
       und=>"chaine pour und");
&uie::pause(mess=>" (2) arn par defaut");
#
&essai(ars=>\$aa,
       arh=>["A"],
       arc=>"A",
       arn=>5,
       und=>"chaine pour und");
&uie::pause(mess=>" (2) arn par 5");
#
&essai(ars=>\$aa,
       arh=>["A"],
       arc=>"A",
       arn=>undef,
       und=>"chaine pour und");
&uie::pause(mess=>" (2) arn par undef");
#
&essai("help");
&uie::pause(mess=>"List of arguments");
#
&essai("ara");
&uie::pause(mess=>"Details of one argument");
#
&essai(ars=>\22,
       arh=>{a=>"A",d=>"D",z=>"Z"},
       arc=>"A la prochaine !");
&uie::pause(mess=>"Calling the subroutine (1)");
#
&essai(ars=>\22,
       arh=>["A","D","Z"],
       arc=>"A la prochaine !");
&uie::pause(mess=>"Calling the subroutine (2)");
#
print "-"x4,"Fin du test de argu","-"x25,"\n";
#
# fin du code
#
#############################################

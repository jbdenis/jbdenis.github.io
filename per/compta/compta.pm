#
# functions to be used in perl scripts for accounting
#
# 15_08_14 16_01_28 16_02_04 16_02_08 16_02_13
# 16_02_14 16_02_17 16_02_18 16_02_23 16_02_24
# 16_02_26 16_03_05 16_03_11 16_03_17 16_03_18
# 16_03_23 16_03_24 16_03_26 16_03_29 16_03_30
# 16_04_13 16_04_16 16_04_22 16_05_03 16_05_05
# 16_05_08 16_05_12 16_05_22 16_05_23 16_05_24
# 16_06_03 16_06_29 16_08_28 16_11_02 17_05_01
# 17_05_05 17_05_06 17_05_07 18_01_24 18_11_16
# 18_11_20 
#
package compta;
use strict;
use warnings;
use Term::ReadKey;
use Scalar::Util qw(looks_like_number);
use List::Util qw(min max);
use uie;
#
###<<<
# This module was written to get rid of using
# two delphi programs I wrote in 1988 running
# under MSWindow.
#
# Not sure its subroutines can be of use for somebody else.
# Its writting was the occasion to start the 
# module /uie/.
# 
# There are three main file types used for
# the compta system.
#  [ i ] The 'definition' files where are
#        defined the different 'comptes',
#        'groupements de comptes', 'postes',
#        'groupements de postes', 'types de transaction',
#        'transactions mensuelles automatiques'.
#  [ ii] The 'montant' files where can be precised
#        initial amounts of different 'comptes'.
#  [iii] The 'transaction' files, or 'journal' files
#        where are enumerated a number of
#        elementary operations.
#  The three of them are text files and must 
#  follow some specific format which are described
#  in the "read8*" respective subroutines.
#  Also comment lines (startint with '#') are accepted
#  everywhere in these files.
#
###>>>
#############################################
#############################################
# Some general constants
#############################################
## titles for the different components of a transaction
# Only the keys of this hash are used in the
# program code, the values are of use only
# for printing purposes.
my %trint = ("y"=>"an","m"=>"mois","d"=>"jour",
             "re"=>"relE","e"=>"E",
             "r"=>"R","rr"=>"relR",
             "p"=>"poste","t"=>"type",
             "hm"=>"montant","ds"=>"descr.");
## tags for the different lists of the definition files
my %detag = ("c"=>"Comptes","gc"=>"GComptes",
             "p"=>"Postes", "gp"=>"GPostes",
             "tt"=>"TTypes","ta"=>"TSystematiques");
## separator for the montant files 
my $inasep = "=>";
#
#############################################
#############################################
# decomposing a transaction extracted from a "journal"
#############################################
#
##<<
sub split8transaction {
    #
    # title : split a transaction into its components
    # 
    # output : a reference to a hash of references in the following order:
    #          the year (integer),
    #          the month (integer),
    #          the day within the month (integer),
    #          an index insuring the order of the dates
    #                   (year-1900)*380 + month*31 + day
    #          the issuing account (one character),
    #          its associated statement (two characters),
    #          the receiving account (one character),
    #          its associated statement (two characters),
    #          aim of the transaction (two characters),
    #          type of the transaction (four characters),
    #          value of the transaction (numerical value),
    #          description of the transaction (string of characters).
    # The consistency of the transaction is checked for the separators only
    #
    # arguments
    my $hrsub = {transa  =>[undef,"c","The string describing the transaction"]
                };
##>>
    my $argu   = &uie::argu("split8transaction",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $transa = $argu->{transa};
    #
    # checking the separators of the transaction
    my @sepa = ("/","/","->","-","-","=","|","|");
    my @posi = (  4,  7,  14, 19, 22, 27, 38,-1);
    my @long = (  1,  1,   2,  1,  1,  1,  1, 1);
    for (my $i = 0; $i < scalar(@sepa); $i++) {
        if (substr($transa,$posi[$i],$long[$i]) ne $sepa[$i]) {
            print "in '&split8transaction'\n<$transa>\n";
            die("The ",$i+1,"th separator($sepa[$i]) was wrong!");
	}
    }
    # getting the different components of the transaction
    my @clef = ("y", "m", "d","re", "e", "r","rr", "p", "t","hm");
    @posi =    (  0,  5,    8,  11,  13,  16,  17,  20,  23,  28);
    @long =    (  4,  2,    2,   2,   1,   1,   2,   2,   4,  10);
    my $rres = {};
    for (my $i = 0; $i < scalar(@clef); $i++) {
        $$rres{$clef[$i]} = substr($transa,$posi[$i],$long[$i]);
    }
    $$rres{"ds"} = substr($transa,39,length($transa)-40);
    # returning
    $rres;
}
#############################################
#############################################
# printing a decomposed transaction
#############################################
#
##<<
sub print8transaction {
    #
    # title : print a transaction
    #
    # output : nothing but a display is produced on the screen.
    #
    #
    # arguments
    my $hrsub = {rtransa  =>[undef,"h","Reference to the hash giving the decomposed transaction by '&split8transaction'"],
                 details  =>[0,"n","Must all details be displayed?"]
                };
##>>
    my $argu   = &uie::argu("print8transaction",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $rtransa = $argu->{rtransa};
    my $details = $argu->{details};
    # printing
    print "Le $$rtransa{'d'}/$$rtransa{'m'}/$$rtransa{'y'}";
    print "  de $$rtransa{'e'}";
    if ($$rtransa{'re'} ne '  ') {
	print "($$rtransa{'re'}) "; 
    } else {
        print " "x5;
    }
    print "vers $$rtransa{'r'}";
    if ($$rtransa{'rr'} ne '  ') { 
        print "($$rtransa{'rr'})";
    } else {
        print " "x4;
    }
    print "<",$$rtransa{'p'},">";
    print " $$rtransa{'hm'} euros";
    # the details
    if ($details) {
        print " /$$rtransa{'ds'}/$$rtransa{'p'}/$$rtransa{'t'}/";
    }
    print "\n";
    # returning
    1;
}
#############################################
#############################################
# recomposed a transaction
#############################################
#
##<<
sub join8transaction {
    #
    # title : reconstitute a transaction from the individual components
    #
    # output : the transaction such it is in a journal line
    #
    #
    # arguments
    my $hrsub = {rtransa  =>[undef,"h","Reference to the hash giving the decomposed transaction by '&split8transaction'"]
                };
##>>
    my $argu   = &uie::argu("join8transaction",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $rtransa = $argu->{rtransa};
    # recomposing
    my $res = "$$rtransa{y}/";
    $res = $res.&uie::juste(cha=>$$rtransa{m},lon=>2,jus=>"r")."/";
    $res = $res.&uie::juste(cha=>$$rtransa{d},lon=>2,jus=>"r");
    $res = $res." ";
    $res = $res."$$rtransa{re}$$rtransa{e}";
    $res = $res."->";
    $res = $res."$$rtransa{r}$$rtransa{rr}";
    $res = $res."-".&uie::juste(cha=>$$rtransa{p},lon=>2,jus=>"r");
    $res = $res."-$$rtransa{t}=";
    $res = $res.&uie::juste(cha=>"$$rtransa{hm}",lon=>10,jus=>"r");
    $res = $res."|$$rtransa{ds}|";
    # returning
    $res;
}
#############################################
#############################################
# reading a "journal" from a file
#############################################
#
##<<
sub read8journal {
    #
    # title : read a journal file
    #
    # output : a reference to a hash of references, each associated
    #         to one array providing one column of the journal
    #         The keys of %trint (global variable) are used for the keys
    #         of the hash of references.
    #
    # Comment lines (starting with '#') are neglected
    #
    #
    # arguments
    my $hrsub = {fic  =>[undef,"c","File name of the journal to read"]
                };
##>>
    my $argu   = &uie::argu("read8journal",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $fic = $argu->{fic};
    #
    my $nbmo = 100;
    # opening the file
#    open(FIC,'<:encoding(UTF-8)',$fic) or 
    open(FIC,'<',$fic) or 
	die "'read8journal cannot open > $fic file: $!";
    # reading the file
    my $nbt = 0;
    # the reference to the hash 
    my %tran = %trint;
    foreach (keys %tran) {
        $tran{$_} = [];
    }
    $| = 1;
    while (<FIC>) { if (!(m/^#/)) {
	my $trs= $_;
        chomp $trs; $nbt++;
        if (($nbt % $nbmo) == 0) { print $nbt," ";}
	my $rtransa = &split8transaction(transa=>$trs);
	foreach my $cle (keys %trint) {
	    @{$tran{$cle}} = (@{$tran{$cle}},$$rtransa{$cle});
	}
        #print8transaction(rtransa=>$rtransa,details=>0);
    }}
    print "\n";
    # closing the file
    print "'read8journal' read a total of $nbt transactions\n";
    close(FIC);
    # returning
    \%tran;
}
#############################################
#############################################
# writing a "journal" from its reading
#############################################
#
##<<
sub write8journal {
    #
    # title : write a journal file
    #
    # output : 1 (in fact nothing is to be returned)
    #
    # From the reference to a text journal is constituted and 
    #          stored into text file.
    #       No comment lines are introduced.
    #
    # See &read8journal for the description of the referred variables
    #
    # arguments
    my $hrsub = {rjou =>[undef,"h","A reference such it is returned by '&read8journal'"],
                 jour =>[undef,"c","File name of the journal to write",
                                   "When '' the printing is done on the screen"]
                };
##>>
    my $argu   = &uie::argu("write8journal",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $jour = $argu->{jour};
    my $rjou = $argu->{rjou};
    # opening the file
#    open(my $fjou,'>:encoding(UTF-8)',$jour) or die "cannot open > $jour: $!";
    my $ou = 1; my $fjou;
    if ($jour eq "") { $ou = 0;}
    if ($ou) {
        open($fjou,'>',$jour) or die "cannot open > $jour: $!";
    }
    # checking
    if (!check8journal(rjou=>$rjou)) {
	die("The proposed journal was not checked as consistent");
    }
    my $nbt = scalar @{$$rjou{y}};
    # writing the transactions
    for( my $i=0; $i<$nbt; $i++ ) {
	my %tra = ();
	foreach my $j (keys %trint) {
	    $tra{$j} = ${$$rjou{$j}}[$i];
	}
        if ($ou) {
          print $fjou &join8transaction(rtransa=>\%tra);
          print $fjou "\n";
        } else {
          print &join8transaction(rtransa=>\%tra);
          print "\n";
        }
    }
    # closing the file
    print "'write8journal' wrote a total of $nbt transactions\n";
    if ($ou) { close($fjou);}
    # returning
    1;
}
#############################################
#############################################
# Checking a journal
#############################################
#
##<<
sub check8journal {
    #
    # title : check the consistency of a journal structure
    #
    # output : 1 when the check is positive, 0 if not.
    #           When 'O' some warning indications are printed.
    # arguments
    my $hrsub = {rjou  =>[undef,"h","A reference such it is returned by '&read8journal'"]
                };
##>>
    my $argu   = &uie::argu("check8journal",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $rjou = $argu->{rjou};
    # checking it is a reference to an hash of the different components
    my @uke = keys %trint; 
    my $fch = &uie::check8ref(ref=>$rjou,typ=>"h",
                         rlo=>[scalar @uke,scalar @uke],key=>\@uke);
    if ($fch == 0) {
        print "The initial reference was wrong (check8journal)\n";
        return 0;
    } else {
        my $nbt = 0;
        foreach my $compo (@uke) {
            my $rco = $$rjou{$compo};
            my $sch = &uie::check8ref(ref=>$rco,typ=>"a");
            if ($sch == 0) {
		print "The reference to component $compo was wrong (check8journal)\n";
		return 0;
	    } else {
                my @colo = @$rco;
                if ($nbt == 0) {
		    $nbt = scalar @colo;
		} else {
		    if ($nbt != scalar @colo) {
			print "Component $compo was found with a different length that other component (check8journal)\n";
			return 0;
		    }
		}
	    }
	}
    }
    # returning
    1;
}
#############################################
#############################################
# reading initial "montants" from a file
#############################################
#
##<<
sub read8montant {
    #
    # title : read the file giving the initial amount of each account
    #      from a text file where comment lines (starting with '#') 
    #      are neglected.
    #
    #      Each non comment line is associated to an account, 
    #      it must have two fields separated with '=>':
    #        the name of the account and the amount of its.
    #
    # output : a reference to a hash of the initial amount of each account.
    #         (keys are account names)
    #
    # arguments
    my $hrsub = {mon  =>[undef,"c","Text file to be read"]
                };
##>>
    my $argu   = &uie::argu("read8montant",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $mon = $argu->{mon};
    # opening the file
#    open(my $fic,'<:encoding(UTF-8)',$mon) 
    open(my $fic,'<',$mon) 
	or die "'read8montant cannot open > $mon file: $!";
    # reading the file
    my $nbt = 0;
    my %ina = ();
    my @ligne;
    while (<$fic>) { if (!(m/^#/)) {
        chomp; $nbt++;
	@ligne = split($inasep,$_);
	if (scalar @ligne !=2) {
	    print $_,"\n";
	    print join(" <-> ",@ligne),"\n";
            print "The number of fields: ",scalar @ligne," is not TWO as expected.\n";
	    die("'read8montant' found a non acceptable line for a 'compte'");
	}
        my $clef = &uie::juste(cha=>$ligne[0],jus=>"n");
        my $vale = &uie::juste(cha=>$ligne[1],jus=>"n");
	$ina{$clef} = $vale;
    }}
    # closing the file
    print "'read8montant' read $nbt 'comptes'\n";
    close($fic);
    # returning
    \%ina;
}
#############################################
#############################################
# sorting a "journal" 
#############################################
#
##<<
sub sort8journal {
    #
    # title : sort a journal structure
    #
    # output : $res: the reference to the sorted journal
    #
    # arguments
    my $hrsub = {rjou  =>[undef,"h","Reference such as returned by '&read8journal'"],
                 sort  =>["date","ca","Defines the type of sorting. Can be:",
                                   "'date' for the day",
                                   "'from' for the issuer",
                                   "'to' for the receiver",
                                   "'FROM' for the issuer and its annotation",
                                   "'TO' for the receiver and its annotation",
                                   "'poste' for the poste",
                                   "'type' for the type",
                                   "'val' for the amount of the transactions",
                                   "'\$ref' a reference to an array of two components giving",
                                   "   the first and last columns of the set of columns",
                                   "   to be used for an alphabetical sorting."],
                incr  =>[1,"c","1 for increasing order, 0 for decreasing order"]
               };
##>>
    my $argu   = &uie::argu("sort8journal",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $rjou = $argu->{rjou};
    my $sort = $argu->{sort};
    my $incr = $argu->{incr};
    # checking the journal
    if (!&check8journal(rjou=>$rjou)) {
	die "The journal given to 'sort8journal' was not found valid!\n";
    }
    # getting the vector leading the sorting 
    if ($sort eq "date") {
        $sort = [1,10];
    }
    if ($sort eq "FROM") {
        $sort = [12,14];
    }
    if ($sort eq "TO") {
        $sort = [17,19];
    }
    my @lvec=();
    if ($sort eq "from") {
        @lvec = @{$$rjou{"e"}};
    } elsif ($sort eq "to") {
        @lvec = @{$$rjou{"r"}};
    } elsif ($sort eq "poste" ) {
        @lvec = @{$$rjou{"p"}};
    } elsif ($sort eq "type") {
        @lvec = @{$$rjou{"t"}};
    } elsif ($sort eq "val" ) {
        @lvec = @{$$rjou{"hm"}};
    } else {
        my $sch = &uie::check8ref(ref=>$sort,typ=>"a",rlo=>[2,2]);
	if ($sch == 0) {
	    print "A reference to an array of the two columns was expected (sort8journal)\n.";
	}
	my ($co1,$co2) = @$sort;
        if ($co1>$co2) {
	    ($co1,$co2) = ($co2,$co1);
	}
	# getting the transaction
	my $nbt = scalar @{$$rjou{"y"}};
	for( my $i=0; $i<$nbt; $i++ ) {
	    my %tra = ();
	    foreach my $j (keys %trint) {
		$tra{$j} = ${$$rjou{$j}}[$i];
	    }
	    my $transa = join8transaction(rtransa=>\%tra);
	    $lvec[$i] = substr($transa,$co1-1,$co2-$co1+1);
	}
    }
    # getting the sorting permutation
    my $permu = &uie::ordre(rar=>\@lvec,inc=>$incr,num=>0);
    # building the permuted journal
    my $res = {};
    foreach (keys %trint) { $$res{$_} = [];}
    my $nbt = scalar @{$$rjou{"y"}};
    for( my $i=0; $i<$nbt; $i++ ) {
        foreach my $j (keys %trint) {
	    ${$$res{$j}}[$i] = ${$$rjou{$j}}[$$permu[$i]]; 
        }
    }
    # returning
    $res;
}
#############################################
#############################################
# selecting transaction into a "journal" 
#############################################
#
##<<
sub select8journal {
    #
    # title : select some transaction from a journal structure and create
    #      a new one from them
    #
    # output : $res: the reference to the journal after selection
    #
    # Remark : to select over an interval, 'select8journal' must be applied twice.
    #
    # arguments
    my $hrsub = {rjou  =>[undef,"c","Text file to be read"],
                 sele  =>["date","ca","The field on which to make the selection.",
                                    " Possibilities are:",
                                   "'date' for the day",
                                   "'from' for the issuer",
                                   "'to' for the receiver",
                                   "'FROM' for the issuer and its annotation",
                                   "'TO' for the receiver and its annotation",
                                   "'poste' for the poste",
                                   "'type' for the type",
                                   "'val' for the amount of the transactions",
                                   "'\$ref' a reference to an array of two components giving",
                                   "     the first and last columns of the set of columns",
                                   "     to be used for an alphabetical sorting. So '[1,10]'",
                                   "     must equivalent to 'date'."],
                 oper  =>["gt '2015/12/31'","c","Operand used to make the selection.",
                                   "'gt '2001/12/31'' applied to date will select all transaction",
                                   "            from years equal to 2002, 2003,...",
                                   "'>= '100.00'' applied to val will select all transactions",
                                   "            with an amount greater than 99.99.",
                                   "'eq '2000'' applied to [1,4] will select all transactions",
                                   "            of the year 2000.",
                                   " //DON'T FORGET the quotation marks!//"]
                };
##>>
    my $argu   = &uie::argu("select8journal",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $rjou = $argu->{rjou};
    my $sele = $argu->{sele};
    my $oper = $argu->{oper};
    # checking the journal
    if (!&check8journal(rjou=>$rjou)) {
	die "The journal given to 'select8journal' was not found valid!\n";
    }
    my $nbt = scalar @{$$rjou{"y"}};
    # getting the vector leading the selection 
    my @lvec=();
    if ($sele eq "date") {
        $sele = [1,10];
    }
    if ($sele eq "FROM") {
        $sele = [12,14];
    }
    if ($sele eq "TO") {
        $sele = [17,19];
    }
    #
    if ($sele eq "from") {
        @lvec = @{$$rjou{"e"}};
    } elsif ($sele eq "to") {
        @lvec = @{$$rjou{"r"}};
    } elsif ($sele eq "poste" ) {
        @lvec = @{$$rjou{"p"}};
    } elsif ($sele eq "type") {
        @lvec = @{$$rjou{"t"}};
    } elsif ($sele eq "val" ) {
        @lvec = @{$$rjou{"hm"}};
    } else {
        my $sch = &uie::check8ref(ref=>$sele,typ=>"a",rlo=>[2,2]);
	if ($sch == 0) {
	    print "found <$sele>\n";
	    print "A reference to an array of the two columns was expected (select8journal)\n.";
	}
	my ($co1,$co2) = @$sele;
        if ($co1>$co2) {
	    ($co1,$co2) = ($co2,$co1);
	}
	# getting the transaction
	for( my $i=0; $i<$nbt; $i++ ) {
	    my %tra = ();
	    foreach my $j (keys %trint) {
		$tra{$j} = ${$$rjou{$j}}[$i];
	    }
	    my $transa = join8transaction(rtransa=>\%tra);
	    $lvec[$i] = substr($transa,$co1-1,$co2-$co1+1);
	}
    }
    # getting the selecting indicator
    my @indic = ();
    for (my $i = 0; $i < $nbt; $i++) {
	my $expr = '$lvec[$i] '.$oper;
        my $resu = eval $expr;
	#print $lvec[$i]," - {$expr}",'  $resu:'," <$resu>\n";
	push @indic,$resu*1;
    }
    # building the selected journal
    my $res = {}; my $ii = -1;
    foreach (keys %trint) { $$res{$_} = [];}
    for( my $i=0; $i<$nbt; $i++ ) { if ($indic[$i]) {
	$ii++;
        foreach my $j (keys %trint) {
	    ${$$res{$j}}[$ii] = ${$$rjou{$j}}[$i]; 
        }
    }}
    print "'select8journal' selected a total of ",$ii+1," transactions\n";
    # returning
    $res;
}
#############################################
#############################################
# reading a definition file
#############################################
#
##<<
sub read8definition {
    #
    # title : read a definition file to get all accounts, systematic 
    #       transactions... proposed as standard blocks as defined
    #       in '&uie::read8block' subroutine.
    #
    # Every line of the file starting with expression such as '<titi>'
    #       is supposed to indicate the existence of a block named 'titi'.
    #       As a consequence a further line starting with '</titi>' is
    #       expected. Be aware that no space is allowed so '<ti ti>'
    #       will not be considered as a begining of a block. Every
    #       character after '>' is ignored.
    # Any block name is accepted.
    #
    # Comment lines (starting with '#') are neglected
    #
    # The used separator is encoded with the scalar variable '$sep'.
    #
    #
    # output : a reference to a hash having as keys the different block names
    #         and values reference ot blocks as produced by '&uie::read8block'.
    #
    # constants
    my $sep = '::'; my $com = '#';
    # arguments
    my $hrsub = {fdef  =>[undef,"c","Text file to be read as a definition file"]
                };
##>>
    my $argu   = &uie::argu("read8definition",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $fdef = $argu->{fdef};
    # opening the file
#    open(my $fic,'<:encoding(UTF-8)',$fdef) 
    open(my $fic,'<',$fdef) 
	or die "'read8definition cannot open > $fdef file: $!";
    # looking for the block names
    my @blocs = ();
    while (<$fic>) { if (!(m/^#/)) {
	if ((/^<.*>/) and (!(/^<\//))) {
	    chomp;
	    my $string = $_;
            if ( $string =~ /<(.*?)>/ ) {
	        #print $1,"\n";
                push @blocs,$1;
	    }
	}
    }}
    # reading each blocks and storing
    my $res = {};
    foreach my $uu (@blocs) {
	print "<$uu>\n";
	$$res{$uu} = &uie::read8block(com=>$com,sep=>$sep,
                                      fil=>$fdef,
                                      bbl=>"<$uu>",ebl=>"</$uu>"
                                     );
    }
    print "'read8definition' found ",scalar keys %$res," 'blocks'\n";
    close($fic);
    # returning
    $res;
}
#############################################
#############################################
# creating a journal with automatical transactions
#############################################
#
##<<
sub make8autra {
    #
    # title : from a definition, produce a journal file of
    #      automatic transaction for a precised month.
    #
    # output : 1 if everything was fine, if not a fatal error is issued.
    #
    # arguments
    my $hrsub = {ropau    =>[undef,"a","reference to the array of automatic transaction",
                                       "such as produced by 'read8definition' subroutine",
                                       "in its resulting referred hash."],
                 month    =>[undef,"c","month to consider for automatic transactions"],
                 year     =>[undef,"c","year to consider for automatic transactions"],
                 journal  =>[undef,"c","Text file to be written/appended as a journal file"]
                };
##>>
    my $argu   = &uie::argu("make8autra",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $ropau   = $argu->{ropau};
    my $month   = $argu->{month};
    my $year    = $argu->{year};
    my $journal = $argu->{journal};
    # opening the file
#    open(my $fic,'>>:encoding(UTF-8)',$journal) 
    open(my $fic,'>>',$journal) 
	or die "'make8autra cannot open > $journal file: $!";
    # looping on the different automatic transactions
    my $nbopau = 0;
    for my $rtransa (@$ropau) {
	my @transa = @$rtransa;
        # looking if to be consider
        my $oui = 0;
        my @mois = split(" ",$transa[9]);
	for my $mois (@mois) { if ($mois eq $month) {$oui =1;}}
	if ($oui) {
	    $nbopau++;
	    my $trec = &uie::juste(cha=>$year,lon=>4)."/".
                       &uie::justn(num=>$month,dig=>2)."/".
                       &uie::justn(num=>$transa[1],dig=>2);
	    $trec = $trec."   ".&uie::juste(cha=>$transa[3],lon=>1)."->".
                                &uie::juste(cha=>$transa[4],lon=>1)."  ";
	    $trec = $trec."-".&uie::justn(num=>$transa[2],dig=>2)."-";
	    $trec = $trec.&uie::juste(cha=>$transa[0],ava=>"OA",lon=>4)."=";
            $trec = $trec.&uie::juste(cha=>$transa[8],lon=>10,jus=>"r")."|";
            $trec = $trec.$transa[5].":";
            $trec = $trec.$transa[6].":";
            $trec = $trec.$transa[7]."|";
	    print $fic $trec."\n";
	}
    }
    print "'make8autra' wrote $nbopau transactions in $journal\n";
    close($fic);
    # returning
    1;
}
#############################################
#############################################
# questions for asking transactions
#############################################
#
##<<
sub questions4transactions {
    #
    # title : provides questions for each component of a transaction
    #
    # output : a reference to a series of questions such as used
    #                 by '&uie::get8answer'
    #
    # arguments
    my $hrsub = {rdefi  =>[undef,"h","A reference to a structure as produced by '&read8definition'"],
                 askfo  =>[    0,"n","Must some default value be asked interactively to the user?"]
                };
##>>
    my $argu   = &uie::argu("questions4transactions",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $rdefi = $argu->{rdefi};
    my $askfo = $argu->{askfo};
    #
    my %champs = %trint;
    delete($champs{i});
    my $rquestions = \%champs;
    #
    my @poss_comptes; 
    my $aide_comptes = "Les différents comptes sont :";
    for (my $i = 0; $i < scalar @{$rdefi->{Comptes}}; $i++) {
	push @poss_comptes,($rdefi->{Comptes}->[$i]->[0]);
        $aide_comptes = $aide_comptes."\n".join(" : ",@{$rdefi->{Comptes}->[$i]});
    }
    #
    my @poss_postes; 
    my $aide_postes = "les différents postes sont :";
    my $maxpos = 1;
    for (my $i = 0; $i < scalar @{$rdefi->{Postes}}; $i++) {
	my $nupo = $rdefi->{Postes}->[$i]->[0];
	push @poss_postes,$nupo;
        if ($maxpos < $nupo) {$maxpos = $nupo;}
        if (($i % 3) == 0) { $aide_postes = $aide_postes."\n";}
        my $listep = join(" : ",($rdefi->{Postes}->[$i][0],
                                 $rdefi->{Postes}->[$i][1]));
        $listep = &uie::juste(cha=>$listep,lon=>30);
        $aide_postes = $aide_postes.$listep;
    }
    # getting the date
    my($month, $year)=(localtime)[4,5];
    $month++;
    $year = $year+1900;
    #
    # year
    if ($askfo) {
        my $pyear = ask8question(ques=>"Default year? [$year if 'Enter']",type=>"n");
        if (looks_like_number($pyear)) {
            $year = $pyear;
        }
    }
    my %quesy = ("ques"=>"Quelle année ?",
                 "help"=>("Numéro de l'année sur QUATRE chiffres"),
                 "chec"=>["n",1970,2049,0],
                 "defa"=>$year);
    $rquestions->{"y"} = \%quesy;
    # mois
    if ($askfo) {
        my $pmonth = ask8question(ques=>"Default month? [$month if 'Enter']",type=>"n");
        if (looks_like_number($pmonth)) {
            $month = $pmonth;
        }
    }
    my %quesm = ("ques"=>"Quel mois ?",
             "help"=>("Numéro du mois sur UN ou DEUX chiffres"),
             "chec"=>["n",1,12,0],
             "defa"=>$month);
    $rquestions->{"m"} = \%quesm;
    # jour
    my %quesd = ("ques"=>"Quel jour ?",
             "help"=>("Numéro du jour sur UN ou DEUX chiffres"),
             "chec"=>["n",1,31,0],
             "defa"=>undef);
    $rquestions->{"d"} = \%quesd;
    # relevé emetteur
    my %quesre = ("ques"=>"Relevé Emetteur ?",
             "help"=>("deux lettres minuscules ou deux espaces"),
             "chec"=>["p",'^(([a-z][a-z])|(\s\s))$'],
             "defa"=>'  ');
    $rquestions->{"re"} = \%quesre;
    # numéro emetteur
    my %quese = ("ques"=>"Emetteur ?",
             "help"=>("Selon le fichier de définition\n".$aide_comptes),
             "chec"=>["a",@poss_comptes],
             "defa"=>undef);
    $rquestions->{"e"} = \%quese;
    # numéro récepteur
    my %quesr = ("ques"=>"Récepteur ?",
             "help"=>("Selon le fichier de définition\n".$aide_comptes),
             "chec"=>["a",@poss_comptes],
             "defa"=>undef);
    $rquestions->{"r"} = \%quesr;
    # relevé récepteur
    my %quesrr = ("ques"=>"Relevé Récepteur ?",
             "help"=>("deux lettres minuscules ou deux espaces"),
             "chec"=>["p",'^(([a-z][a-z])|(\s\s))$'],
             "defa"=>'  ');
    $rquestions->{"rr"} = \%quesrr;
    # poste
    my %quesp = ("ques"=>"Pour quel poste ?",
             "help"=>("Selon le fichier de définition, ".$aide_postes),
             "chec"=>["n",1,$maxpos,0],
             "defa"=>undef);
    $rquestions->{"p"} = \%quesp;
    # type de transaction
    my %quest = ("ques"=>"De quel type ?",
             "help"=>("Selon les formats suivant"),
             "chec"=>["p",'^((\d\d\d\d)|(OA\d\d)|(Virt)|(Cheq)|(Plvt)|(\sCBJ)|(CBJB)|(Liqu))$'],
             "defa"=>undef);
    $rquestions->{"t"} = \%quest;
    # montant de transaction
    my %queshm = ("ques"=>"De quel montant ?",
             "help"=>("En Euros avec deux décimales"),
             "chec"=>["n",0,100000,2],
             "defa"=>undef);
    $rquestions->{"hm"} = \%queshm;
    # Description de la transaction
    my %quesds = ("ques"=>" partenaire : bénéficiare : objet",
             "help"=>("Ne pas oublier les deux séparateurs [:] "),
             "chec"=>["p",'^[^:]*[:][^:]*[:][^:]*$'],
             "defa"=>undef);
    $rquestions->{"ds"} = \%quesds;
    #
    # returning
    $rquestions;
}
#############################################
#############################################
# getting a series of transactions from the terminal
#############################################
#
##<<
sub get8transa4journal {
    #
    # title : get a series of transaction and constitute a journal from them
    #
    # output : reference to the hash of accepted answers. 
    #
    # constants
    my @trana = ("A","B","C","D","E");
    # arguments
    my $hrsub = {rquest  =>[undef,"h","reference to the hash of questions to ask.",
                                      " (to be given to 'get8answer' see its comments",
                                      "  for details)"],
                 rordre  =>[undef,"a","reference to an array of 'keys %\$rquest'", 
                                      "in the desired asking order to be given",
                                      "to '&uie::get8answer'"],
                 journal =>[undef,"c","File name where to write as a journal the received transactions",
                                      " (written in append mode)"] ,
                 largeur=>[100,"n","width of the two pannels"],
                 longhelp=>[17,"n","number of lines for the help pannel, just before questions"]
                };
##>>
    my $nbtra = scalar @trana;
    my $argu   = &uie::argu("get8transa4journal",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $rquest  = $argu->{rquest};
    my $rordre  = $argu->{rordre};
    my $journal = $argu->{journal};
    my $largeur = $argu->{largeur};
    my $longhelp = $argu->{longhelp};
    # checking consistency between questions and question order is done within '&uie::get8answer'
    # adding the question to continue or not
    # type de transaction
    my %quesui = ("ques"=>"Comment Continuer ?",
             "help"=>("s pour saisie; r recommencer; q pour quitter; ou lettre pour modifier une transa affichée"),
             "chec"=>["a",("s","r","q",@trana)],
             "defa"=>"s");
    $rquest->{"QQ"} = \%quesui;
    push @$rordre,"QQ";
    my $continuer = 1;
    # initializing the first pannel
    my $rien = "";
    my @rplaca = ();
    foreach (1..$nbtra) { push @rplaca,$rien;}
    my @controle;
    # opening the file
#    open(FIC,'>>:encoding(UTF-8)',$journal) or 
    open(FIC,'>>',$journal) or 
	die "'get8transa4journal' cannot open $journal file: $!";
    my $nbtran = 0;
    # asking the different transactions
    while ($continuer) {
        # preparing the already entered transactions
        for (my $i = 0; $i < $nbtra; $i++) {
            my $numero = $nbtran-$nbtra+1+$i;
            if ($numero < 0) { $numero = 0;}
            my $coco = &uie::juste(cha=>$numero,lon=>3,jus=>"r");
            $coco = $coco." <".$trana[$i]."> ".$rplaca[$i];
            $controle[$i] = \$coco;
	}
        # getting a new transaction
        my $noutra = &uie::get8answer(rpl=>\@controle,
                                       rqu=>$rquest,ror=>$rordre,
                                       lah=>$largeur,loh=>$longhelp,
                                       con=>"s");
	$nbtran++;
        # what to do
        my $suite = $noutra->{"QQ"};
        my $quel = "";
        if (&uie::belong9(sca=>\$suite,arr=>\@trana)) {
            # a stored transaction must be deleted
            my @quel = &uie::belong9(sca=>\$suite,arr=>\@trana);
            $quel = $quel[0];
        }
        # 
        if ($suite eq "q") { 
            $continuer = 0;
            $suite = "s";
        }
        # managing the stack of awaiting transactions
        if ($suite eq "s") {
            # the newly entered transaction is valid
            # fitting decimal for the amount
            $noutra->{hm} = &uie::justn(num=>$noutra->{hm},dec=>2,dig=>-1);
            # reconstituting the transaction
            my $ntran = &join8transaction(rtransa=>$noutra);
            print $ntran,"\n";
            # updating @rplaca
            my $tobestored = $rplaca[0];
            shift @rplaca;
            push @rplaca,$ntran;
            # adding the shifted transaction to the journal
            if ($tobestored ne $rien) {
                print FIC $tobestored,"\n";
	    }
        } elsif ( $quel ne "") {
            # the newly entered transaction is valid
            # fitting decimal for the amount
            $noutra->{hm} = &uie::justn(num=>$noutra->{hm},dec=>2,dig=>-1);
            # reconstituting the transaction
            my $ntran = &join8transaction(rtransa=>$noutra);
            # getting the transaction to remove
            my $toredo = $rplaca[$quel];
            # checking it is not a void transaction
            if ($toredo ne $rien) {
                # storing it into $noutra for the defaults
                $noutra = &split8transaction(transa=>$toredo);
                # removing it
                splice @rplaca,$quel,1;
            }
            # adding the new transaction
            push @rplaca,$ntran;
        }
        # loading the defaults for a possible following transaction
        if ($suite eq "r") {
            # defaults are taken from the just entered transaction
            foreach ("e","r","m","d","y","t","re","rr","p","hm","ds") {
                $rquest->{$_}->{defa} = $noutra->{$_};
	    }
        } elsif ( $quel ne "") {
            # defaults are taken from the transaction to re-enter
            foreach ("e","r","m","d","y","t","re","rr","p","hm","ds") {
                $rquest->{$_}->{defa} = $noutra->{$_};
	    }
        } else {
            # defaults for a new transaction
            foreach ("p","hm","ds","hm") {
                $rquest->{$_}->{defa} = undef;
	    }
            foreach ("e","r","m","d","y","t","re","rr") {
                $rquest->{$_}->{defa} = $noutra->{$_};
	    }
            if (looks_like_number($rquest->{t}->{defa})) {
                $rquest->{t}->{defa}++;
	    }
        }
    }
    # emptying the buffer
    foreach (@rplaca) {
        if ($_ ne $rien) {
            print FIC $_,"\n";
	}
    }
    # closing the file
    close FIC;
    # returning
    1;
}
#############################################
#############################################
# making the balance of a journal
#############################################
#
##<<
sub make8balance {
    #
    # title : make the balance of a journal (and initial amounts)
    #                       based on a definition set.
    #
    # output : reference to the hash of the balance
    #                       (see &print8balance for details). 
    #
    # arguments
    my $hrsub = {rdef =>[undef,"h","reference to the hash of a definition set."],
                 rmon =>[undef,"h","reference to the hash of montant values."], 
                 rjou =>[undef,"h","reference to the hash of the journal to scrutinize."],
                 peri =>[["1900/01/01","3000/12/31"],"a",
                                   "Two dates (included) defining the period to consider."],
                 rele =>[["zz"],"c","Last mark of releve to use for the accounts."]
                };
##>>
    my $argu   = &uie::argu("make8balance",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $rdef = $argu->{rdef};
    my $rmon = $argu->{rmon};
    my $rjou = $argu->{rjou};
    my $peri = $argu->{peri};
    my $rele = $argu->{rele};
    # getting the different posts
    my $postes = {};
    foreach (@{$rdef->{Postes}}) {
        $$postes{$_->[0]} = $_->[1];
    }
    # getting the different accounts
    my $comptes = {};
    foreach (@{$rdef->{Comptes}}) {
        $$comptes{$_->[0]} = $_->[1];
    }
    # checking some consistency between the three sets
    # preparing the matrix output
    my $res = [];
    # the title line
    my $nuli = 0;
    $res->[$nuli] = [" "]; 
    foreach (sort keys %$comptes) {
        #push @$res[$nuli],$_.":".$comptes->{$_};
        push @{$res->[$nuli]},$_.":".$comptes->{$_};
    }
    # initializing the initial amounts
    my %idc = ();
    foreach my $p ("INITIAL") {
        $nuli++;
        $res->[$nuli] = [$p];
        my $nuc = 1;
        foreach my $c (sort keys %$comptes) {
            my $v = $comptes->{$c};
            #push @$res[$nuli],$rmon->{$v};
            push @{$res->[$nuli]},$rmon->{$v};
            $idc{$c} = $nuc; $nuc++;
        }
    }
    # initializing the core
    my %idp = ();
    foreach my $p (sort keys %$postes) {
        $nuli++;
        $res->[$nuli] = [$p.":".$postes->{$p}];
        foreach my $c (sort keys %$comptes) {
            #push @$res[$nuli],0;
            push @{$res->[$nuli]},0;
            $idp{$p} = $nuli;
        }
    }
    # initializing the differents sums
    my %idm = ();
    my $num = 1;
    foreach my $p ("Mouvt(+)","Mouvt(-)","MOUVT",) {
        $nuli++;
        $res->[$nuli] = [$p];
        foreach my $c (sort keys %$comptes) {
            #push @$res[$nuli],0;
            push @{$res->[$nuli]},0;
        }
        $idm{$num} = $nuli; $num++;
    }
    # initializing the final amounts
    my %idr = ();
    my $nur = 1;
    foreach my $p ("RELEVÉ","FINAL",) {
        $nuli++;
        $res->[$nuli] = [$p];
        foreach my $c (sort keys %$comptes) {
            my $v = $comptes->{$c};
            #push @$res[$nuli],$rmon->{$v};
            push @{$res->[$nuli]},$rmon->{$v};
        }
        $idr{$nur} = $nuli; $nur++;
    }
    # scrutinizing the journal
    my $njou = &compta::transa4journal(rjou=>$rjou);
    foreach (@$njou) {
        # filtrage sur la date
        my $an = $_->{y};
        my $mo = $_->{m}; $mo = &uie::justn(num=>$mo,dig=>2);
        my $jo = $_->{d}; $jo = &uie::justn(num=>$jo,dig=>2);
        my $da = "$an/$mo/$jo";
        # 
        if ($da lt $$peri[0]) {
            ## the transaction is before the period
	    # extraction de la transaction
	    my $monta = $_->{hm};
	    my $poste = $_->{p};
	    if ($poste < 10) { $poste = &uie::justn(num=>$poste,dig=>1);}
	    my $emett = $_->{e};
	    my $recep = $_->{r};
	    my $relem = $_->{re};
	    my $relre = $_->{rr};
	    my $i = $idp{$poste};
	    my $j1 = $idc{$emett};
	    my $j2 = $idc{$recep};
	    # mise à jour des relevés
	    if (($relre ne "  ") and ($relre le $rele)) {
		$res->[$idr{1}]->[$j2] = $res->[$idr{1}]->[$j2] + $monta;
	    }
	    if (($relem ne "  ") and ($relem le $rele)) {
		$res->[$idr{1}]->[$j1] = $res->[$idr{1}]->[$j1] - $monta;
	    }
	    # mise à jour des soldes
	    $res->[$idr{2}]->[$j2] = $res->[$idr{2}]->[$j2] + $monta;
	    $res->[$idr{2}]->[$j1] = $res->[$idr{2}]->[$j1] - $monta;
        } elsif (($da ge $$peri[0]) and ($da le $$peri[1])) {
            ## the transaction belongs to the indicated period
	    # extraction de la transaction
	    my $monta = $_->{hm};
	    my $poste = $_->{p};
	    if ($poste < 10) { $poste = &uie::justn(num=>$poste,dig=>2);}
	    my $emett = $_->{e};
	    my $recep = $_->{r};
	    my $relem = $_->{re};
	    my $relre = $_->{rr};
	    my $i = $idp{$poste};
	    my $j1 = $idc{$emett};
	    my $j2 = $idc{$recep};
	    # mise à jour du core
	    if (!defined($i)) { die("poste <$poste> of the journal was not defined");}
	    if (!defined($j1)) { die("emeter <$emett> of the journal was not defined");}
	    if (!defined($j2)) { die("receiver <$recep> of the journal was not defined");}
	    $res->[$i]->[$j1] = $res->[$i]->[$j1] - $monta;
	    $res->[$i]->[$j2] = $res->[$i]->[$j2] + $monta;
	    # mise à jour des mouvements
	    $res->[$idm{1}]->[$j2] = $res->[$idm{1}]->[$j2] + $monta;
	    $res->[$idm{2}]->[$j1] = $res->[$idm{2}]->[$j1] + $monta;
	    $res->[$idm{3}]->[$j2] = $res->[$idm{3}]->[$j2] + $monta;
	    $res->[$idm{3}]->[$j1] = $res->[$idm{3}]->[$j1] - $monta;
	    # mise à jour des relevés
	    if (($relre ne "  ") and ($relre le $rele)) {
		$res->[$idr{1}]->[$j2] = $res->[$idr{1}]->[$j2] + $monta;
	    }
	    if (($relem ne "  ") and ($relem le $rele)) {
		$res->[$idr{1}]->[$j1] = $res->[$idr{1}]->[$j1] - $monta;
	    }
	    # mise à jour des soldes
	    $res->[$idr{2}]->[$j2] = $res->[$idr{2}]->[$j2] + $monta;
	    $res->[$idr{2}]->[$j1] = $res->[$idr{2}]->[$j1] - $monta;
        }
    }
    # returning
    $res;
}
#############################################
#############################################
# printing a balance result into a file
#############################################
#
##<<
sub print8balance {
    #
    # title : print a balance made by &make8balance
    #                       
    #
    # output : 1 but a file has been created
    #
    # arguments
    my $hrsub = {rbal =>[undef,"a","reference to the array containing the balance."],
                 file =>[undef,"c","the file where to write it in appending mode."],
                 rdef =>[undef,"h","reference to the hash of a definition set (for the synthesis)."],
                 form =>[[12,8],"a","widths for the title and the amounts"],
                 mont =>["","c","File name where to write the ammount, default means no writing"]
                };
##>>
    my $argu   = &uie::argu("print8balance",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $rbal = $argu->{rbal};
    my $file = $argu->{file};
    my $rdef = $argu->{rdef};
    my $form = $argu->{form};
    my $mont = $argu->{mont};
    # getting the number of postes and accounts
    my $nbp = (scalar @$rbal) - 7;
    my $nba = scalar @{$rbal->[0]};
    my @fmt = @$form;
    my $sepa = "-"x($fmt[0]);
    foreach (2..$nba) { 
        push @fmt,$form->[1];
        $sepa = $sepa." "."-"x($fmt[1]-1);
    }
    $sepa = $sepa."\n";
    # opening the output file
    open(TUTU,'>>',$file);
    print TUTU $sepa;
    my $quel = 0;
    # printing the account titles
    for (my $j=0; $j < $nba; $j++) {
        my $cic = $rbal->[$quel]->[$j]; 
        print TUTU &uie::juste(cha=>$cic,lon=>$fmt[$j],jus=>"r");
    }
    print TUTU "\n";
    $quel++;
    print TUTU $sepa;
    # printing the initial amounts
    foreach my $i (1) {
        my $cic = $rbal->[$quel]->[0]; 
        print TUTU &uie::juste(cha=>$cic,lon=>$fmt[0],jus=>"L");
	for (my $j=1; $j < $nba; $j++) {
	    my $cic = $rbal->[$quel]->[$j]; 
            $cic = &uie::justn(num=>$cic,dec=>0,dig=>-1);
	    print TUTU &uie::juste(cha=>$cic,lon=>$fmt[$j],jus=>"r");
	}
	print TUTU "\n";
        $quel++;
    }
    print TUTU $sepa;
    # printing the core matrix
    foreach my $i (1..$nbp) {
        my $cic = $rbal->[$quel]->[0]; 
        print TUTU &uie::juste(cha=>$cic,lon=>$fmt[0],jus=>"L");
	for (my $j=1; $j < $nba; $j++) {
	    my $cic = $rbal->[$quel]->[$j]; 
            $cic = &uie::justn(num=>$cic,dec=>0,dig=>-1);
	    print TUTU &uie::juste(cha=>$cic,lon=>$fmt[$j],jus=>"r");
	}
	print TUTU "\n";
        $quel++;
    }
    print TUTU $sepa;
    # printing the three totals
    foreach my $i (1..3) {
        my $cic = $rbal->[$quel]->[0]; 
        print TUTU &uie::juste(cha=>$cic,lon=>$fmt[0],jus=>"L");
	for (my $j=1; $j < $nba; $j++) {
	    my $cic = $rbal->[$quel]->[$j]; 
            $cic = &uie::justn(num=>$cic,dec=>0,dig=>-1);
	    print TUTU &uie::juste(cha=>$cic,lon=>$fmt[$j],jus=>"r");
	}
	print TUTU "\n";
        $quel++;
    }
    print TUTU $sepa;
    # printing the final amounts
    my $bibi = 1;
    if ($mont ne "") {
        unless (open(BIBI,'>',$mont)) {
            print "\n\n WAS NOT POSSIBLE TO WRITE THE AMOUNT FILE: $mont\n\n\n";
            $bibi = 0;
        } else {
	    print BIBI "#\n# created on ",&uie::now(),"\n#\n";
        }
    } else {
        $bibi = 0;
    }
    my $fquel = $quel+1;
    foreach my $i (1..2) {
        my $cic = $rbal->[$quel]->[0]; 
        print TUTU &uie::juste(cha=>$cic,lon=>$fmt[0],jus=>"L");
	for (my $j=1; $j < $nba; $j++) {
	    my $cic = $rbal->[$quel]->[$j]; 
            if ($bibi) {
                if ($i == 2) {
                    my $libb = $rbal->[0]->[$j];
                    $libb =~ s/^.+://;
                    print BIBI "  ",$libb," => ",$cic,"\n";
                }
	    }
            $cic = &uie::justn(num=>$cic,dec=>0,dig=>-1);
	    print TUTU &uie::juste(cha=>$cic,lon=>$fmt[$j],jus=>"r");
	}
	print TUTU "\n";
        $quel++;
    }
    if ($bibi) {
        print BIBI "# End of the file\n";
        close(BIBI);
    }
    print TUTU $sepa;
    $quel = 0;
    # printing the account titles
    for (my $j=0; $j < $nba; $j++) {
        my $cic = $rbal->[$quel]->[$j]; 
        print TUTU &uie::juste(cha=>$cic,lon=>$fmt[$j],jus=>"r");
    }
    print TUTU "\n";
    print TUTU $sepa;
    # printing some synthesis
    print TUTU "\n";
    my $gcomptes = $rdef->{"G-Comptes"};
    for (my $j=0; $j < scalar @$gcomptes; $j++) {
        print TUTU "\t",$gcomptes->[$j]->[1],": ","\t";
        my @wha = split " ",$gcomptes->[$j]->[3];
        my $tota = 0;
        foreach (@wha) {
            my $cic = $rbal->[$fquel]->[$_]; 
            $tota = $tota + $cic;
        }
        print TUTU "\t",
              &uie::justn(num=>$tota,dec=>0,dig=>-1),
              "  (@wha)",
              "\n";
    }
    # closing the output file
    close(TUTU);
    # returning
    1;
}
#############################################
#############################################
# transforms a journal into a series of transactions
#############################################
#
##<<
sub transa4journal {
    #
    # title : extracts transactions from a journal
    #                       
    #
    # output : a reference to an array of the transactions (a reference to a hash each)
    #
    # arguments
    my $hrsub = {rjou =>[undef,"h","reference to a journal such those produced by &read8journal."],
                 tran =>[[0,0],"a","definition of the transactions to be returned.",
                               "[0,0] means all of them,",
                               "[10,12] means the tenth, eleventh and twelfth",
                               "[1,1] means the first not the second!"]
                };
##>>
    my $argu   = &uie::argu("transa4journal",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $rjou = $argu->{rjou};
    my $tran = $argu->{tran};
    # checking the journal
    if (!&check8journal(rjou=>$rjou)) {
        die("The proposed journal was not accepted!");
    }
    # getting the number of transactions in the journal
    my $nbt = scalar @{$rjou->{hm}};
    # finding the transaction series to return
    if (($$tran[0]==0) or ($$tran[1]==0)) { 
        $tran = [1,$nbt];
    } else {
        $$tran[0] = max(1,$$tran[0]);
        $$tran[1] = min($nbt,$$tran[1]);
    }
    # initializing the series of transactions
    my $res = [];
    my @clefs = ("y", "m", "d","re", "e", "r","rr", "p", "t","hm","ds");
    # getting the transactions
    foreach my $it ($$tran[0]..$$tran[1]) {
        my $transa = {}; 
        foreach (@clefs) {
            $transa->{$_} = $rjou->{$_}->[$it-1];
        }
        push @$res,$transa;
    }
    # returning
    $res;
}
#############################################
1;

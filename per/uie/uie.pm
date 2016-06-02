#
# general functions to be used in perl 
#
# 16_03_18 16_03_19 16_03_20 16_03_21 16_03_23
# 16_03_28 16_03_31 16_04_01 16_04_07 16_04_10
# 16_04_11 16_04_13 16_04_15 16_04_16 16_04_24
# 16_04_25 16_04_27 16_04_28 16_04_29 16_05_03
# 16_05_08 16_05_22 16_05_23 16_05_31 16_06_02
#
package uie;
use strict;
use warnings;
use Term::ReadKey;
use Term::ANSIColor;
use Devel::StackTrace;
use Scalar::Util qw(looks_like_number);
use Date::Calc qw(:all);
 
###<<<
#
# 'uie' are the three vocals of the French word 'UtIlEs',
#       to remind the basic aim of the proposed subroutines.
#
# The module comprises a series of subroutines that I found of
# use to have at hand. Probably, most of them already exist
# somewhere else in a more efficient code... but it was a 
# good exercise for me.
#
###>>>
#
#############################################
# some general constants
#############################################
my $width = 80;
#
#
##<<
sub argu {
    #
    # title : decoding and checking arguments given through hashes
    #
    # aim : from the hash proposed by the user
    #           and the hash defining the arguments 
    #           necessary for the subroutine,
    #       checks the validity of the user proposal and
    #       returns the completed hash. The arguments
    #       are scalars, 
    #
    # input : ($sub,$rhsub,@argu)
    #         $sub is the name of the concerned subroutine
    #         $rhsub is the hash defining the arguments
    #         necessary to '$sub' by means of a reference
    #         to a small array where:
    #           [0] is the default value (undef when there is not)
    #           [1] is the type of the argument:
    #                undef for no check.
    #                'u' for 'undef'
    #                'h' for a reference to a hash
    #                'a' for a reference to an array
    #                's' for a reference to a scalar
    #                'r' for a reference
    #                'n' for a numerical value
    #                'c' for a chain of characters
    #                or a combination of the above
    #                   when there is more than one 
    #                   possibility e.g. 'sh' for a
    #                   reference either to a scalar
    #                   or a hash
    #           [2..] the description of the argument
    #                 to be use as an help; may not exist.
    # Notice that 'undef' cannot be a default value since such
    #        a value for [0]  means that the argument must 
    #        be provided by the call.
    #        Nevertheless, it is an acceptable value when [1] 
    #        comprises 'u'.
    #
    # Be aware that quite not understable messages can be the 
    # consequence that a hash or an array be proposed instead of a
    # reference... since values are interpreted as a hash when the
    # total number is even.
    #
    #         @arg is the array proposed by the user to be decoded
    #              or when it comprises only one pertinent element
    #                 some help is provided about the arguments
    #                 of the subroutine. More precisely when 'HELP' the
    #                 description of all arguments is displayed,
    #                 when 'help' the list of arguments is displayed,
    #                 when an argument name, the description of it.
    #
    # output: reference to the completed hash
    #         or 1 when help is asked for.
    #
##>>
    # arguments
    if ((scalar @_) < 2) {
        print "\nhere the arguments separated with '::'\n";
        print((scalar @_),"...<",join("::",@_),">\n");
        print "\nhere the stack of the calls before the error\n";
	my $trace = Devel::StackTrace->new;
	print $trace->as_string;
	die("An array of length at least TWO is expected by '&argu'\n ");
    }
    #
    my $sub = shift @_; my $rhsub = shift @_;
    die("in '&argu' called by '&$sub', the second  argument is not a hash reference\n ") 
    unless (ref($rhsub)eq"HASH");
    #
    my @arg = @_;
    # help asked to be displayed
    if (scalar(@arg) == 1) {
        my $aide = $arg[0];
	my $oui = 0;
        if ($aide eq "HELP") { $oui = 1;}
	if ($aide eq "help") { $oui = 1;}
        for my $cl (keys %$rhsub) {
            if ($aide eq $cl) { $oui = 1;}
	}
        if ($oui) {
	    if ($aide eq "help") {
                print "The ",scalar keys %$rhsub," argument names of '&$sub' are: ",
                      join(" & ",keys %$rhsub),"\n";
	    } else {
                if ($aide eq "HELP") {
         	    print "Definitions of arguments of '&$sub':\n";
		} else {
                    print "Definition of argument '$aide' of '&$sub:\n";
		}
	    }
	    foreach (keys %{$rhsub}) {
                if (($aide eq "HELP") or ($aide eq $_)) {
		    print "<< $_ >>\n";
		    my $def = $rhsub->{$_}->[0];
		    print "       default: "; 
		    if (!defined($def)) {
			print "'undef'\n";
		    } elsif (ref($def) eq "ARRAY") {
			my $lga = scalar @{$def};
			print "reference to ARRAY of length $lga ( @{$def} )\n";
		    } elsif (ref($def) eq "HASH") {
			my $lgh = scalar(%{$def}) / 2;
			print "reference to the following HASH of length $lgh \n";
			foreach (keys %{$def}) {
			    print "  <<$_>> $def->{$_} \n";
			}
		    } elsif (ref($def) eq "SCALAR") {
			if (defined(${$def})) {
			    print "reference to SCALAR ${$def} \n";
			} else {
			    print "reference to 'undef' \n";
			}
		    } else {
			print "       default: '",$rhsub->{$_}->[0],"'\n";
		    }
		    my $typ = $rhsub->{$_}->[1];
		    if (defined($typ)) {
			print "          type: '",$typ,"'\n";
		    } else {
			print "          type: 'undef'\n";
		    }
		    for (my $i=2; $i < scalar @{$rhsub->{$_}}; $i++) {
			if ($i==2) { print "   description: ";}
			else       { print "              : ";}
			print $rhsub->{$_}->[$i],"\n";
		    }
		}
	    }
	    return 1;
	}
    }
    # decoding arguments
    # checking @arg
    ((scalar @arg % 2)==0) or 
    die("in '&argu', the third argument is not a flatenned hash\n".
        "Probably a hash was not given as arguments in '&$sub'?\n ");
    for (my $i = 0; $i < (scalar @arg)/2; $i++) {
        if (!defined($arg[$i*2])) {
	    print ("The key number ",$i+1," of the hash for argments of $sub is not defined.\n");
	    print ("  Its value is $arg[$i*2+1] \n");
	    die ("This is not acceptable!\n ");
	    }
    }
    # checking $rhsub
    foreach (keys %$rhsub) {
        if (!defined($rhsub->{$_}->[1])) {
            print "The type of argument '$_' of '&$sub' is not defined in ",'$rhsub',"!\n";
            die("This is not accepted by '&uie::argu'.");
        }
    }
    # initialization
    my %arg = @arg;
    # initialisation
    my $res = {};
    # checking the arguments
    foreach my $k (keys %$rhsub) {
        # filling the argument
        my $usager = 0;
        foreach my $kk (keys %arg) { if ($kk eq $k) { $usager = 1;}}
        if (($usager==1) or 
            ($rhsub->{$k}->[1] =~ /.*u.*/)) {
            $res->{$k} = $arg{$k};
            if (($usager==0) and (defined($rhsub->{$k}->[0]))) {
                $res->{$k} = $rhsub->{$k}->[0];
	    }
	} else {
	    if (defined($rhsub->{$k}->[0])) {
                $res->{$k} = $rhsub->{$k}->[0];
	    } else {
                if (defined($rhsub->{$k}->[2])) {
                    print "Argument '$k' seems missing in '&$sub'.\n";
		    for (my $i=2; $i < scalar @{$rhsub->{$k}}; $i++) {
                        print $rhsub->{$k}->[$i],"\n";
		    }
		}
                print '$k = ',$k,' and $sub = ',$sub,"\n";
	        print("Argument '$k' was not given in '&$sub' and it has got no default value\n ");
	        die;
	    }
	}
        # checking the argument
        if (defined($rhsub->{$k}->[1])) {
            my $verif = 0;
            my $type = $rhsub->{$k}->[1];
            my @message = ("");
            if ($type =~ /.*u.*/) {
                if (defined($res->{$k})) {
                    push @message,"Argument $k is defined.";
		} else {
		    $verif++;
		}
            }
            if (defined($res->{$k})) {
		if ($type =~ /.*s.*/) {
		    if (ref($res->{$k})ne"SCALAR") {
			push @message,"Argument $k is not a reference to a scalar.";
		    } else {
			$verif++;
		    }
		}
		if ($type =~ /.*h.*/) {
		    if (ref($res->{$k})ne"HASH") {
			push @message,"Argument $k is not a reference to a hash.";
		    } else {
			$verif++;
		    }
		}
		if ($type =~ /.*a.*/) {
		    if (ref($res->{$k})ne"ARRAY") {
			push @message,"Argument $k is not a reference to an array.";
		    } else {
			$verif++;
		    }
		}
		if ($type =~ /.*r.*/) {
		    if (ref($res->{$k}) eq "") {
			push @message,"Argument $k is not a reference.";
		    } else {
			$verif++;
		    }
		}
		if ($type =~ /.*n.*/) {
		    # just a regular scalar numerical value
		    if (!(looks_like_number($res->{$k}))) {
			push @message,"Argument $k is not a numerical value.";
		    } else {
			$verif++;
		    }
		}
		if ($type =~ /.*c.*/) {
		    # just a regular scalar chain string
		    $verif++;
		}
	    }
            #
            if ($verif == 0) {
                print "The type ($type) of argument '$k' of subroutine '&$sub' is bad\n";
                print "Possible errors are :\n";
                foreach my $mes (@message) {
                    print ".....$mes\n";
                    print ".....\n";
		    for (my $i=2; $i < scalar @{$rhsub->{$k}}; $i++) {
                        print $rhsub->{$k}->[$i],"\n";
		    }
		}
                die "Must be corrected\n ";
	    }
	}
    }
    # returning
    $res;
}
#############################################
#
##<<
sub now{
    #
    # title : present moment
    #
    # aim : generates a string giving time and/or date
    #       according to different ways.
    #
    # output: the string
    #
    # arguments
    my $hrsub = {wha =>["dm","c","comprises 'd' for day; 'h' for hour; 'm' for minute; 's' for second."],
                 fmt =>["red","c","'red' to get a reduced way if not a verbose one"],
                 sep =>[["_","@",":"],"a","The three separators to use in case of a reduced format"]
                };
##>>
    my $argu   = &argu("now",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $wha = $argu->{wha}; 
    if ($wha=~"s") { $wha = $wha."hm";}
    if ($wha=~"m") { $wha = $wha."h";}
    my $fmt = $argu->{fmt};
    my $sep = $argu->{sep};
    # getting the time
    my($seco,$minu, $heure, $jour, $mois, $an)=(localtime)[0,1,2,3,4,5];
    $mois = $mois+1; $an = $an+1900;
    my $res = "";
    if ($fmt eq "red") {
        if ($wha=~"d") {
            $mois = &justn(numb=>$mois,digi=>2);
            $jour = &justn(numb=>$jour,digi=>2);
            $res = join($sep->[0],($an,$mois,$jour));
            if ($wha=~"h") { $res = $res.$sep->[1];}
        }
        if ($wha=~"h") {
            $res = $res.&justn(numb=>$heure,digi=>2);
            if ($wha=~"m") { $res = $res.$sep->[2];}
        }
        if ($wha=~"m") {
            $res = $res.&justn(numb=>$minu,digi=>2);
            if ($wha=~"s") { $res = $res.$sep->[2];}
        }
        if ($wha=~"s") {
            $res = $res.&justn(numb=>$seco,digi=>2);
        }
    } else {
        my @njou = ("","lundi","mardi","mercredi",
                    "jeudi","vendredi","samedi","dimanche");
        my @nmoi = ("","janvier","février","mars","avril",
                    "mai","juin","juillet","août",
		    "septembre","octobre","novembre","décembre");
        if ($wha=~"d") {
            my $wday = Day_of_Week($an,$mois,$jour);
            if ($jour eq "1") { $jour = "1er";}
            $res = join(" ",("Le",$njou[$wday],$jour,$nmoi[$mois],$an));
            if ($wha=~"h") { $res = $res." à ";}
        } else {
            if ($wha=~"h") { $res = $res."À ";}
	}
        if ($wha=~"h") {
            $res = $res.$heure." heures";
            if ($wha=~"m") { $res = $res." et ";}
        }
        if ($wha=~"m") {
            $res = $res.$minu." minutes";
            if ($wha=~"s") { $res = $res." ";}
        }
        if ($wha=~"s") {
            $res = $res.$seco." secondes";
        }
    }
    # returning
    $res;
}
#############################################
#
##<<
sub pause{
    #
    # title : pausing to see and get answer
    #
    # aim : generates a pause within a program run
    #           to see some results giving the possibility
    #           either to continue or to stop the program.
    #         Another use is to get a string answer.
    #
    # output: the resulting answer
    #
    # arguments
    my $hrsub = {stst =>["q","c","Answer to exit the program. The chain is lowercased for the test."],
                 mess =>["","c","When not the empty string, a message to add."]
                };
##>>
    my $argu   = &argu("pause",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $stop = $argu->{stst};
    my $mess = $argu->{mess};
    # asking
    if ($mess) {
        print $mess,"\n";
    }
    print "Enter '$stop' to stop the program: ";
    my $res = <>; chomp $res;
    if (lc($res) eq $stop) {
	die "YOUR answer exited the program\n ";
    }
    # returning
    $res;
}
#############################################
#
##<<
sub belongs2{
    #
    # title : scalar belongs to array
    #
    # aim : test if a scalar belongs to a given array
    #
    # output: an array of the element numbers of occurrence.
    #         so () means not found
    #            (0,7) found in the first and eigth element
    #
    # arguments
    my $hrsub = {sca =>[undef,"s","The element to be checked."],
                 arr =>[undef,"a","The array where are stored the possible elements."],
                 low =>[0,    "n","Must the comparison be made after lower casing?"],
                 com =>[["=~ /^","\$/"],"a","A reference to an array of two elements",
                                           "to be used for the comparison with the",
                                           "included operator. Default is the matching",
                                           "operator and the strict equality pattern;",
                                           "it is equivalent to ['eq ','']"]
                };
##>>
    my $argu   = &argu("belongs2",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $sca = $argu->{sca};
    my $arr = $argu->{arr};
    my $low = $argu->{low};
    my $com = $argu->{com};
    # initialization
    my $scav;
    if ($low) { $scav = lc($$sca);}
    else { $scav = $$sca;}
    my @arrv = @$arr;
    my $resu;
    my @res = ();
    # checking
    my $i = 0;
    foreach my $elem (@arrv) {
	if ($low) { $elem = lc($elem);}
        my $tocheck = '"'.$scav.'"'.$com->[0].$elem.$com->[1];
        #print $tocheck," ::\n";
        my $resu = eval $tocheck;
        if ($resu) { push @res,$i;}
        $i++;
    }
    # returning
    @res;
}
#############################################
#
##<<
sub check8ref {
    #
    # title : checking references
    #
    # aim : check a reference and a little more
    #
    # output: 1 when the check is positive, 0 if not.
    #           When 'O' some warning indications are printed.
    #
    # For the moment, only scalar, array and hash are checked. 
    #     Giving 'check8ref' a reference of another type will
    #     be considered faultly.
    #
    # arguments
    my $hrsub = {ref =>[undef,"r","The reference to be checked"],
                 typ =>[ "sah","c","Type of the reference 'h','a','s' or a combination of them"],
                 rlo =>[ [0,0],"a","minimum and maximum lengths when reference to array or to hash",
                                   " ('[0,0]' means no check)"],
                 key =>[ [],"a","Possible key values in the referred array when reference to a hash",
                                " ('[]' means no check)"]
                };
##>>
    my $argu   = &argu("check8ref",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $ref = $argu->{ref};
    my $rref = ref($ref);
    my %veri = ("SCALAR"=>"s","ARRAY"=>"a","HASH"=>"h");
    if(!exists($veri{$rref})) {
	print "The proposed reference doesn't belong to ",join("|",keys %veri),"\n";
        print "It is $rref\n";
        return 0;
    }
    my $typ = $argu->{typ};
    my $ttyp = $veri{$rref};
    if ($typ !~ $ttyp) {
	print "$rref was not accepted with $typ (type argument of 'check8ref')\n";
        return 0;
    }
    # checking the length for an array or a hash
    my @rlo = @{$argu->{rlo}};
    if ((scalar @rlo) != 2) {
        die ("The third argument of '&check8ref' refers to an array of length ".scalar(@rlo).
             "must be of length two\n ");
    }
    my $rlocheck = (($rlo[0]!=0) or ($rlo[1]!=0));
    if (($ttyp ne "s") and ($rlocheck)) {
        if ($ttyp eq "a") {
	    if ( (scalar @$ref < $rlo[0]) or (scalar @$ref > $rlo[1])) {
		print "The length of the referred array is not valid\n";
		print "$rlo[0] <= length(array)=",scalar @$ref," <= $rlo[1] IS NOT TRUE\n";
	        return 0;
	    }
	} elsif ($ttyp eq "h") {
	    if ( (scalar keys %$ref < $rlo[0]) or (scalar keys %$ref > $rlo[1])) {
		print "The length of the referred array is not valid\n";
		print "$rlo[0] <= length(array)=",scalar keys %$ref," <= $rlo[1] IS NOT TRUE\n";
		return 0;
		}
	} else {
	    die "'check8ref' itself seems faulty: sorry for that !\n ";
	}
    }
    # checking keys of a hash
    my @key = @{$$argu{key}};
    if (($ttyp eq "h") and (scalar @key > 0)) {
	my $kk = 0;
	my %key = map { $_ => 1 } @key;
	foreach (keys %$ref) { if (defined($key{$_})) { $kk++;}} 
        if ($kk == scalar keys %$ref) {
	    $kk = 1;
	} else {
	    $kk = 0;
	}
        if ($kk == 0) {
	    print "The keys of the hash: ",join("|",keys %$ref),"\n";
	    print "were not all in the possible keys: ",join("|",@key),"\n";
	}
	return $kk;
    }
    # returning
    1;
}
#############################################
#
##<<
sub juste {
    #
    # title : justifying a string
    #
    # aim: justify a string
    #
    # output: the fitted string
    #
    # remark: in case of truncation, a '+' is inserted in the
    #         border leading to the loss of an additional 
    #         character.
    #
    # arguments
    my $hrsub = {chain=>[undef,"c","The chain to be justified"],
                 trim =>[    1,"n","Must ending spaces be removed?"],
                 avant=>[   "","c","Chain to introduce before"],
                 apres=>[   "","c","Chain to introduce after"],
                 long =>[   64,"n","Length of the justified chain",
                                   " (when <= 0 no justification"],
                 just =>[  "l","c","Type of justification can be:",
                                   "   'l' for to the left without truncation",
                                   "   'L' for to the left with    truncation",
                                   "   'c' for centering without truncation",
                                   "   'C' for centering with    truncation",
                                   "   'r' for to the right without truncation",
                                   "   'R' for to the right with    truncation",
                                   "   'n' for no justification then",
                                   "       long is not considered."],
                 ulca =>[  "n","c","Type of capitalization can be:",
                                   "   'n' nothing",
                                   "   'U' every word uppercased",
                                   "   'L' every word lowercased",
                                   "   'c' first letter of each word uppercased",
                                   "   'C' first letter of each word uppercased",
                                   "       and remaining letters lowercased"]
                };
##>>
    # constants
    my $ma = "+";
    # arguments
    my $argu   = &argu("juste",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my %argu = %{$argu};
    my $chaine = $argu{chain}; my $trim  = $argu{trim};
    my $avant  = $argu{avant}; my $apres = $argu{apres};
    my $long   = $argu{long} ; my $just  = $argu{just};
    my $ulca  = $argu{ulca};
    # trimming
    if ($trim) {
	$chaine  =~ s/^\s+|\s+$//g;
    }
    # casing
    if ($ulca eq "U") {
        $chaine = uc($chaine);
    } elsif ($ulca eq "L") {
        $chaine = lc($chaine);
    } elsif ($ulca eq "C") {
        my @mots = split(" ",$chaine);
        for (my $i=0; $i < scalar @mots; $i++) {
            $mots[$i] = ucfirst($mots[$i]);
        }
        $chaine = join(" ",@mots);
    } elsif ($ulca eq "c") {
        my @mots = split(" ",$chaine);
        for (my $i=0; $i < @mots; $i++) {
            $mots[$i] = ucfirst(lc($mots[$i]));
        }
        $chaine = join(" ",@mots);
    }
    # surrounding
    $chaine = $avant.$chaine.$apres;
    # no justification
    if (($just eq "n")or($long<=0)) { $long = length($chaine);}
    # possible truncation
    if (length($chaine) > $long) {
        if ($just eq "L") {
	    $chaine = substr($chaine,0,$long-1).$ma;
	} elsif ($just eq "R") {
	    $chaine = $ma.substr($chaine,length($chaine)-$long+1,$long-1);
	} elsif ($just eq "C") {
	    if ($long < 3) {
		$chaine = ${ma}x$long;
	    } else {
		my $ll = length($chaine)-$long+2;
		my $rg = int($ll/2);
		$chaine = $ma.substr($chaine,$rg-1,$long-2).$ma;
	    }
	}
    } 
    # possible truncation
    if (length($chaine) < $long) {
        if (lc($just) eq "l") {
	    while (length($chaine) < $long) { $chaine = "$chaine ";}
	} elsif (lc($just) eq "r") {
	    while (length($chaine) < $long) { $chaine = " $chaine";}
	} elsif (lc($just) eq "c") {
	    while (length($chaine) < $long) { $chaine = " $chaine ";}
	    if (length($chaine) > $long) {
		$chaine = substr($chaine,1,length($chaine)-1);
	    }
	}
    }
    # returning
    $chaine;
}
#############################################
#
##<<
sub ordre {
    #
    # title : find a permutation reordering the element of an array
    # 
    # output: a reference to an array of same length
    #         containing a permutation (starting at 0)
    #         ordering @$rar.
    #
    # arguments
    my $hrsub = {rar  =>[undef,"a","Reference to the array to virtually sort"],
                 inc  =>[    1,"n","Must the sorting be increasing?"],
                 num  =>[    0,"n","Must the comparison be numerical?"]
                };
##>>
    my $argu   = &argu("ordre",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $rar = $argu->{rar};
    my $inc = $argu->{inc};
    my $num = $argu->{num};
    #
    my @arr = @$rar;
    my $nbe = scalar @arr;
    my @res = (0..$nbe);
    my $matrice = [];
    for (my $i=0; $i < $nbe; $i++) {
        @$matrice = (@$matrice,[$arr[$i],$res[$i]]);
    } 
    # sorting
    my @maper;
    if ($num) {
	if ($inc) {
	    @maper = sort { $a->[0] <=> $b->[0] } @$matrice;
	} else {
	    @maper = sort { $b->[0] <=> $a->[0] } @$matrice;
	}
    } else {
	if ($inc) {
	    @maper = sort { $a->[0] cmp $b->[0] } @$matrice;
	} else {
	    @maper = sort { $b->[0] cmp $a->[0] } @$matrice;
	}
    }
    my @permu = ();
    for (my $i=0; $i < $nbe; $i++) {
	@permu = (@permu,${$maper[$i]}[1]);
    }
    # returning
    \@permu;
}
#############################################
#
##<<
sub numerical {
    #
    # title : keyboard interpretation of numerical values
    #
    # aim: translate a string according to the numerical
    #      keys of a French keyboard.
    #
    # input : see the included help hash
    #          
    # output: the character string translated
    #
    #
    # arguments
    my $hrsub = {cha  =>[undef,"c","The character string to transform"],
                 tra  =>[    1,"c","Must the transformation be performed?"]
                };
##>>
    my $argu   = &argu("numerical",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $cha = $argu->{cha};
    my $tra = $argu->{tra};
    #
    my $res = $cha;
    if ($tra) {
	$res =~ tr{&}{1};
	$res =~ tr{"}{3};
	$res =~ tr{'}{4};
	$res =~ tr{(}{5};
	$res =~ tr{-}{6};
	$res =~ tr{_}{8};
	$res =~ tr{u}{4};
	$res =~ tr{i}{5};
	$res =~ tr{o}{6};
	$res =~ tr{j}{1};
	$res =~ tr{k}{2};
	$res =~ tr{l}{3};
	$res =~ tr{,}{0};
	$res =~ tr{U}{4};
	$res =~ tr{I}{5};
	$res =~ tr{O}{6};
	$res =~ tr{J}{1};
	$res =~ tr{K}{2};
	$res =~ tr{L}{3};
	$res =~ tr{?}{0};
#
	$res =~ s/é/2/g;
	$res =~ s/è/7/g;
	$res =~ s/ç/9/g;
	$res =~ s/à/0/g;
#
	$res =~ s/;/\./g;
	$res =~ s/:/\./g;
	$res =~ s/\//\./g;
    }
    # returning
    $res;
}
#############################################
#
##<<
sub read8block {
    #
    # title : reading a block from a text file
    #
    # aim: read a block of lines between two tags.
    #               '<$blo>' at the beginning of the tag to open the block
    #                   (the end of this line is not considered)
    #               '</$blo>' at the beginning of the tag to close the block
    #
    # output: a reference to an array of references associated
    #         to each line of the block, these references point
    #         towards arrays of the different components of each
    #         lines.
    #
    # arguments
    my $hrsub = {com  =>[  "#","uc","Lines beginning with it are neglected.",
                                   "When 'undef' every line is considered."],
                 sep  =>[ "::","cu","Separator between fields within each line.",
                                   "When 'undef' no separation is performed."],
                 fil  =>[undef,"c","Name of the file to be read."],
                 bbl  =>["##<<","c","Tag to begin a block"],
                 ebl  =>["##>>","c","Tag to   end a block"],
                 uni  =>[    0,"n","Must the reading be restricted to the first block?"]
                };
##>>
    my $argu   = &argu("read8block",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $com = $argu->{com};
    my $sep = $argu->{sep};
    my $fil = $argu->{fil};
    my $bbl = $argu->{bbl};
    my $ebl = $argu->{ebl};
    my $uni = $argu->{uni};
    #
    # reading the file eliminating the comment lines
#    open(my $fic,'<:encoding(UTF-8)',$fil) or die "cannot open > $fil: $!\n ";
    open(my $fic,'<',$fil) or die "cannot open > $fil: $!\n ";
    my $rres = [];
    my $oui = 0; my $nublo = 0;
    while (<$fic>) {
        chomp $_;
        if (!$oui) {
	    $oui = ($_ =~ /^$bbl/);
	    if ($oui) { $nublo++;}
	} elsif ((!defined($com)) or ((defined($com)) and ($_ !~ m/^$com/))){
	    $oui = ($_ !~ /^$ebl/);
            if (($uni) and ($nublo > 1)) { $oui = 0;}
            if ($oui) {
                # adding the record
                my @cpts;
                if (defined($sep)) {
                    @cpts = split($sep);
                } else {
                    @cpts = $_;
                }
                @$rres = (@$rres,\@cpts);
	    }
	}
    }
    close($fic);
    # returning
    $rres;
}
#############################################
#
##<<
sub print8panneau {
    #
    # title : printing a pannel
    #
    # aim: display a pannel on the terminal
    #
    # remark: The length of '$tfra' indicates the total width of
    #         the pannel, too long line will be shortened. It must
    #         be equal to the length of '$bfra'.
    #         If '$tfra' is not defined '$bfra' is used instead,
    #         if the latter is not defined, 'uie::width' is used.
    #
    # output: 1
    #
    # arguments
    my $hrsub = {rpan =>[undef,  "a","Reference to an array of references to strings",
                                     "  (each associated to a line of the pannel)",
                                     "  (of course can be '[]' for an empty pannel"],
                 tfra =>["*"x80, "cu"," line to be added before the pannel",
                                     "    when 'undef' no line is added.",
                                     "    and the constant 'uie::width' is used",
                                     "    to define the width of the pannel."],
                 tvoi =>[1,      "n"," number of empty lines after the added line"],
                 lfra =>["* ",   "c"," string to be added before each line"],
                 rfra =>[" *",   "c"," string to be included to finish each line"],
                 bvoi =>[1,      "n"," number of empty lines before the last line"],
                 bfra =>["*"x80, "cu"," line to be added at the end of the pannel",
                                     "    when 'undef' no line is added."],
                 just =>[  "l","c"," type of justification for each line ('l', 'c' or 'r')",
                                     "  either a scalar then the same justification",
                                     "  is applied to all the lines, or a reference",
                                     '  to an array having the same length than "@$rpan"',
                                     "  specifying the justification for each line."],
                 tcol =>["green","cua"," text coloration: either 'undef' for no coloration",
                                     "   or a scalar containing the color to apply to every line",
                                     "   or a reference to an array containing the color".
                                     "   for each line."],
                 fcol =>["white","cu"," frame coloration: either 'undef' for no coloration",
                                     "   or a scalar containing the color to apply to the",
                                     "   vertical and horizontal parts of the frame.",
                                     "   Notice that you can also defined the foreground",
                                     "   color and painting this way the frame for instance",
                                     "   with 'on_blue blue'"]
    };
##>>
#
    my $argu   = &argu("print8panneau",$hrsub,@_);
    if ($argu == 1) { return 1;}
    #
    my $rpan = $argu->{rpan};
    my $tfra = $argu->{tfra};
    my $tvoi = $argu->{tvoi};
    my $lfra = $argu->{lfra};
    my $rfra = $argu->{rfra};
    my $bvoi = $argu->{bvoi};
    my $bfra = $argu->{bfra};
    my $just = $argu->{just};
    my $tcol = $argu->{tcol};
    my $fcol = $argu->{fcol};
    #
    # getting the width
    my $wid = $width;
    if (defined($tfra)) {
        $wid = length($tfra);
    } else {
        if (defined($bfra)) {
            $wid = length($bfra);
        }
    }
    if (defined($bfra)) { if (length($bfra)!=$wid) {
	die("Top and Bottom Lines of the frame have different lengths\n ");
    }}
    my $uwi = $wid - length($lfra) - length($rfra);
    if ($uwi < 0) {
	die "Useful width of the pannel is negative\n ";
    }
    #
    # coloring the frame
    if (defined($fcol)) {
        if (defined($tfra)) {
           $tfra = Term::ANSIColor::color($fcol).$tfra.Term::ANSIColor::color("reset");
        }
        if (defined($bfra)) {
            $bfra = Term::ANSIColor::color($fcol).$bfra.Term::ANSIColor::color("reset");
        }
        $rfra = Term::ANSIColor::color($fcol).$rfra.Term::ANSIColor::color("reset");
        $lfra = Term::ANSIColor::color($fcol).$lfra.Term::ANSIColor::color("reset");
    }
    my $nbli = scalar @$rpan;
    my @just; 
    if (ref($just) eq "ARRAY") {
	@just = @$just;
    } else {
	for (my $i = 0; $i < $nbli; $i++) {
	    $just[$i] = $just;
	}
    }
    if ((scalar @just) != $nbli) {
	die("Array proposed in '$just' seems a bad one\n ");
    }
    my @tcol; 
    if (defined $tcol) {
	if (ref($tcol) eq "ARRAY") {
	    @tcol = @$tcol;
	} else {
	    for (my $i = 0; $i < $nbli; $i++) {
		$tcol[$i] = $tcol;
	    }
	}
	if ((scalar @tcol) != $nbli) {
	    die("Array proposed in '$tcol' seems a bad one\n ");
	}
    }
    # preparing the void lines
    my $vlin = $lfra." "x$uwi.$rfra;
    # printing the top of the frame
    if (defined($tfra)) { print $tfra,"\n";}
    my $kk = 0;
    while ($kk < $tvoi) {
	print $vlin,"\n"; $kk++;
    }
    # printing the content of the pannel
    my $ii = 0;
    foreach (@$rpan) {
        print $lfra;
	if (defined($tcol)) { print Term::ANSIColor::color($tcol[$ii]);}
        print &juste(chain=>$$_,trim=>1,avant=>"",apres=>"",
                     long=>$uwi,just=>$just[$ii]);
	if (defined($tcol)) { print Term::ANSIColor::color("reset");}
        print $rfra,"\n";
	$ii++;
    }
    # printing the bottom of the frame
    $kk = 0;
    while ($kk < $bvoi) {
	print $vlin,"\n"; $kk++;
    }
    if (defined($bfra)) { print $bfra,"\n";}
    #
    # returning
    1;
}
#############################################
#
##<<
sub ask8question {
    #
    # title : asking one question on the screen without check
    #
    # aim: ask a question to the screen and get the answer
    #      given by means of the keyboard.
    #
    # output: the proposed answer by the user
    #             without any checking
    #
    # 
    # arguments
    my $hrsub = {ques  =>[undef,"c","The question to be raised"],
                 type  =>[    0,"n","Must the input numerically transformed?"],
                 form  =>[{avant=>"=> ",apres=>" : ",long=>60,just=>"r"},"h",
                          "The way the question be justified\n  ('{}' for no justification)"]
                };
##>>
    my $argu   = &argu("ask8question",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $ques = $argu->{ques};
    my $type = $argu->{type};
    my $form = $argu->{form};
    if (!defined($form->{avant})) {
        $form->{avant} = "=> ";
    }
    if (!defined($form->{apres})) {
        $form->{apres} = " : ";
    }
    if (!defined($form->{long})) {
        $form->{long} = 60;
    }
    if (!defined($form->{just})) {
        $form->{just} = "r";
    }
    #
    my $repon = "";
    # asking
    if (ref($form) eq "HASH") {
        print &juste(chain=>$ques,avant=>$form->{avant},
                                  apres=>$form->{apres},
                                  long =>$form-> {long},
                                  just =>$form-> {just});
    } else {
        print $ques," : ";
    }
    # reading and reprinting the answer
    if ($type) {
        ReadMode 4; # Turn off controls keys
        my $touche=".";
        while ($touche ne "\n") {
            while (not defined ($touche = ReadKey(-2))) {
            # No key yet
            }
	    $touche = &numerical(cha=>$touche,num=>1);
            if ($touche ne "\n") {
                $repon = $repon.$touche;
	        print $touche;
            }
	}
        ReadMode 0; # Reset tty mode before exiting
                    # for some doubled characters
    } else {
        $repon = <STDIN>;
    }
    #
    if (!defined($repon)) { $repon = "";}
    chomp($repon);
    if (($type) and (length($repon) > 0)) {
        $repon = &numerical(cha=>$repon,num=>1);
    }
    #
    # returning
    $repon;
}
#############################################
#
##<<
sub get8answers {
    #
    # title : asking a series of questions from the terminal
    #
    # aim: get some answers from a series of questions
    #
    # output: reference to the hash of accepted answers. 
    #
    # Notice that questions are asked again when not correctly answered.
    #
    # constants
    my $skip = "ssss"; 
    my $quit = "SSSS"; 
    my $stop = "ZZZZ"; 
    my $halting = "Type '$skip/$quit/$stop' as first four characters to quit the question/call/program";
    # arguments
    my $hrsub = {rplaca=> [undef,"a","reference to an array.\n".
                                     "   to be printed with '&print8panneau'"],
                 rquest=> [undef,"h","reference to the hash of questions to ask.\n".
                                     "keys identifies the questions and values are\n".
                                     "references to hashes of the different components\n".
                                     "of the questions, each with the following keys:\n".
                                     "  - 'ques' giving the question formula.\n".
                                     "  - 'help' giving some hints about the formula to answer\n".
                                     "           with the help of an array.\n".
                                     "  - 'chec' a reference to an array specifying the possible answers.\n".
                                     "      [0] is either 'n' for numeric, 'a' for alphabetical,\n".
                                     "                 or 'p' for perl matching and anything else for no check.\n".
                                     "              . when numeric [1..3] give respectively the \n".
                                     "                      minimum [1], maximum [2] of accepted values\n".
                                     "                      and the number of decimals of truncation [3].\n".
                                     "              . when alphabetic the list of accepted values follow.\n".
                                     "              . when perl matching [1] is any expression to be enclosed\n".
                                     "                     into slashes; for instance ^[a-z][a-z]\$ to impose\n".
                                     "                     just two lower case letters.\n".
                                     "       Be aware that when [0] is 'n', the &numerical subroutine\n".
                                     "                                          is applied to the answer.",
                                     "  - 'defa' the default valeu proposed if a simple 'Enter' key is hit"],
                 rordre=> [undef,"a","reference to an array of 'keys %\$rquest' in the desired asking order."],
                 rforma=> [{}   ,"h","reference to a hash of references to arrays giving for each\n",
                                      "question, the way to display them on the screen just above\n",
                                      "the questionning line. Individual arrays gives the necessary\n",
                                      "argument for a call to '&juste': \$avant,\$apres,\$long,\$just",
                                      "or '[]' when no formatting is desired for this question.\n",
                                      "Also when the hash is empty no formatting is done for any question."],
                 largeur=>[100,"n","width of the help pannel before the question"],
                 longhelp=>[17,"n","number of lines for the help pannel, just before questions"],
                 construc=>["s","hc","Value for argument 'form' of '&join8hash' used when constructing",
                                     "the progressive set of answers"]
                };
##>>
    my $argu   = &argu("get8answers",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $rplaca = $argu->{rplaca};
    my $rquest = $argu->{rquest};
    my $rordre = $argu->{rordre};
    my $rforma = $argu->{rforma};
    my $largeur = $argu->{largeur};
    my $longhelp = $argu->{longhelp};
    my $construc = $argu->{construc};
    #
    # checking consistency between questions and question order labels
    my $conts = 0;
    foreach my $ii (@$rordre) {
	if (!belongs2(sca=>\$ii,arr=>[keys %$rquest])) { 
            $conts++;
            print "Label $_ of ",'@$rordre doesn\'t correspond to a question\n';
	}
    }
    if ($conts) { die $conts,' bad labels of @$rordre';}
    # initializing the progessive construction
    my %const = ();
    # checking consistency between questions and $rforma keys
    if ((keys %$rforma) == 0) {
        for my $iq (keys %$rquest) {
            $$rforma{$iq} = {};
	}
    } else {
        my $conts = 0;
        foreach my $kk (keys %$rforma) {
            if (!belongs2(sca=>\$kk,arr=>[keys $rforma])) { 
                $conts++;
                print "Label $_ of ",'%$rforma doesn\'t correspond to a question\n';
            }
        }
        if ($conts) { die $conts,' bad keys of %$rforma';}
    }
    #
    # looping on the questions
    my $repon; my %res;
    foreach (@$rordre) {
	my $valid = -1;
        while ($valid<=0) {
            # displaying the placard of the first argument
            if (scalar(@$rplaca) > 0) {
                &print8panneau(rpan=>$rplaca,tfra=>"+"x$largeur,tvoi=>0,
                               lfra=>"+ ",rfra=>" +",bvoi=>0,bfra=>"+"x$largeur,
                               just=>"l",colo=>"bright_green");
	    }
            # displayong the placard of help
	    my $rien = " "; my $placard = [];
	    for (my $i =0; $i < $longhelp; $i++) {
		$$placard[$i] = \$rien;
	    }
            my $nbpla = 0;
            #
	    $placard->[$nbpla++] = \$halting;
	    #$nbpla++;
	    if (${$$rquest{$_}}{chec}[0] eq 'n') {
                my $limites = "MINImum value = ".${$$rquest{$_}}{chec}[1].
                              " and MAXImum value = ".${$$rquest{$_}}{chec}[2];
        	$$placard[$nbpla++] = \$limites;
                my @aide = split("\n",$$rquest{$_}{help});
                for (my $i = 0; $i+$nbpla < $longhelp; $i++) {
                    if ($i < scalar @aide) {
			$$placard[$i+$nbpla] =  \$aide[$i];
		    } else {
			$$placard[$i+$nbpla] = \$rien;
		    }
		}
	    } elsif (${$$rquest{$_}}{chec}[0] eq 'a') {
                my @aide = split("\n",$$rquest{$_}{help});
                my @choix = @{${$$rquest{$_}}{chec}};
		splice @choix,0,1;
		my $choix = "Possible Values: ".join(" | ",@choix);
		#$nbpla++;
		$placard->[$nbpla++] = \$choix;
		#$nbpla++;
                for (my $i = 0; $i+$nbpla < $longhelp; $i++) {
                    if ($i < scalar @aide) {
			$$placard[$i+$nbpla] =  \$aide[$i];
		     } else {
			$$placard[$i+$nbpla] = \$rien;
		     }
		}
	    } elsif (${$$rquest{$_}}{chec}[0] eq 'p') {
                my @aide = split("\n",$$rquest{$_}{help});
		my $pattern = $rquest->{$_}->{chec}->[1];
		$pattern = "Format : /".$pattern."/";
                $nbpla++;
		$placard->[$nbpla++] = \$pattern;
                for (my $i = 0; $i+$nbpla < $longhelp; $i++) {
                    if ($i < scalar @aide) {
			$$placard[$i+$nbpla] =  \$aide[$i];
		    } else {
			$$placard[$i+$nbpla] = \$rien;
		    }
		}
	    }
            # default value
	    #$nbpla++;
	    if (defined $rquest->{$_}->{defa}) {
		my $defaut = "Default value:  <".$rquest->{$_}->{defa}.">";
		$placard->[$longhelp-3] = \$defaut;
	    }
            # progressive answer
            my $prog = &join8hash(hash=>\%const,orde=>$rordre,form=>$construc);
            $placard->[$longhelp-2] = \$$prog[0];
            $placard->[$longhelp-1] = \$$prog[1];
            &print8panneau(rpan=>$placard,tfra=>"*"x$largeur,tvoi=>1,
                           lfra=>"* ",rfra=>" *",bvoi=>1,bfra=>"*"x$largeur,
                           just=>"l",colo=>"bright_red");
	    # asking
            my $numero;
            if (${$$rquest{$_}}{chec}[0] eq "n") {
		$numero = 1;
	    } else {
		$numero = 0;
	    }
            my $qqq = ${$$rquest{$_}}{ques};
            if ($valid == 0) {
		$qqq = "¡¡¡<$repon> is not accepted!!! -> ".$qqq;
	    }
            if (ref($rforma) eq "HASH") {
                $repon = &ask8question(ques=>$qqq,
                                       type=>$numero,
                                       form=>$rforma->{$_});
	    } else {
                $repon = &ask8question(ques=>$qqq,
                                       type=>$numero);
	    }
	    if ($repon =~ /^$skip/) { last;}
	    if ($repon =~ /^$quit/) { print "\n"; return undef;}
	    if ($repon =~ /^$stop/) { print "\n"; exit;}
	    if (length($repon)==0) { 
                if (defined($rquest->{$_}->{defa})) {
                    $repon = "".$rquest->{$_}->{defa};
	        }
	    }
	    print " "x30," : ",$repon,"\n";
	    # checking
	    $valid = 1;
	    if (${$$rquest{$_}}{chec}[0] eq 'n') {
                # getting a numerical value when non answer
                if ($repon eq "") { $repon = 0;}
                # a numerical value is expected
                if (looks_like_number($repon)) {
                    if (($repon < ${$$rquest{$_}}{chec}[1]) or ($repon > ${$$rquest{$_}}{chec}[2])) {
		        $valid = 0;
		    } else {
                        # fitting the number of decimals
                        $repon = &uie::justn(numb=>$repon,digi=>-1,
                                             deci=>${$$rquest{$_}}{chec}[3]);
                        # giving it back its numerical statute
                        $repon = 1*$repon;
                    }
                } else {
                    $valid = 0;
                }
	    } elsif (${$$rquest{$_}}{chec}[0] eq 'a') {
                # an alphabetical value belonging to a set of possibilities is expected
		$valid = 0;
		my @choix = @{${$$rquest{$_}}{chec}};
		splice @choix,0,1;
		foreach my $k (@choix) {
		    if ($repon eq $k) {
			$valid = 1;
		    }
		}
	    } elsif (${$$rquest{$_}}{chec}[0] eq 'p') {
                # an alphabetical value satisfying a Perl regular expression
		my $pattern = $rquest->{$_}->{chec}->[1];
		if ($repon =~ /$pattern/) {
                    $valid = 1;
		} else {
		    $valid = 0;
		}
	    }
	}
	$res{$_} = $repon;
        $const{$_} = $repon;
    }
    #
    # returning
    \%res;
}
#############################################
#
##<<
sub print8structure {
    #
    # title : printing a hierarquical structure of references
    #
    # aim : print a structure recursively when referred hashes
    #        and array contains references. Admitted values
    #        are scalars and references to scalars, arrays and
    #        hashes.
    #
    # output: 1
    #
    # arguments
    my $hrsub = {stru =>[undef,"csahu","The structure to be displayed"],
                 inde =>[{h=>"xx",a=>"++","s"=>'..',p=>"  "},"h",
                         "The way to make indentation:",
                         " h for hash reference, a for array reference",
                         " s for scalar reference and p for printing."],
                 prof =>[0,"n","The depth of the display",
                               "  (used for indentation and recursivity)."],
                 prin =>[0,"n","Must types of reference be added?",
                               "0 for no, 1 for starting and 2 for also ending."],
                 addi =>[0,"n","Must a new line added after a reference?"],
                 prmx =>[5,"n","The maximum depth admitted for recursivity"],
                 prpr =>[0,"n","Must the depth degree be printed before each line?"],
                 clef =>["","c","For the hash keys (internal use)"]
                };
##>>
    my $argu   = &argu("print8structure",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $stru = $argu->{stru};
    my $clef = $argu->{clef};
    my $prof = $argu->{prof};
    my $prmx = $argu->{prmx};
    my $inde = $argu->{inde};
    my $addi = $argu->{addi};
    my $prin = $argu->{prin};
    my $prpr = $argu->{prpr};
    # checking the depth
    if ( $prof > $prmx) { return 1;}
    # numbering the level
    my ($nu0,$nu1);
    if ($prpr) {
        $nu0 = &juste(chain=>$prof,  avant=>"<",apres=>">",long=>5,just=>"l");
        $nu1 = &juste(chain=>$prof+1,avant=>"<",apres=>">",long=>5,just=>"l");
    } else {
        $nu0 = $nu1 = "";
    }
    if ($clef ne "") {
        $nu0 = $nu0.$$inde{p}x  $prof  ." $clef ";
        $nu1 = $nu1.$$inde{p}x($prof+1)." $clef ";
    }
    # printing recursively
    if (!defined($stru)) {
        print $nu0,$$inde{p}x$prof," undef\n";
    } elsif (ref($stru) eq "ARRAY") {
        if ($prin>0) { print $nu0,$$inde{a}x($prof+1)," ARRAY\n";
        } else { print $nu0,"\n";}
        my $kk = -1;
        for my $svar (@$stru) {
            $kk++;
            &print8structure(stru=>$svar,prof=>$prof+1,
                             clef=>"[".$kk."]",addi=>$addi,
                             prpr=>$prpr,prin=>$prin,
                             inde=>$inde,prmx=>$prmx);
	}
        if ($prin>1) { print $nu0,$$inde{a}x($prof+1)," array\n";
        }
	if ($addi) { print "\n";}
    } elsif (ref($stru) eq "HASH") {
        if ($prin>0) { print $nu0,$$inde{h}x($prof+1)," HASH\n";
        } else { print $nu0,"\n";}
        for my $kk (keys %$stru) {
            &print8structure(stru=>$stru->{$kk},prof=>$prof+1,
                             clef=>"{".$kk."}",addi=>$addi,
                             prpr=>$prpr,prin=>$prin,
                             inde=>$inde,prmx=>$prmx);
	}
        if ($prin>1) { print $nu0,$$inde{h}x($prof+1)," hash\n";
        }
	if ($addi) { print "\n";}
    } elsif (ref($stru) eq "SCALAR") {
        if ($prin>0) { print $nu0,$$inde{s}x($prof+1)," SCALAR\n";
        }
        print $nu1," ",$$stru,"\n";
        if ($prin>1) { print $nu0,$$inde{s}x($prof+1)," scalar\n";
        }
	if ($addi) { print "\n";}
        return 1;
    } else {
        print $nu0," ",$stru,"\n";
        return 1;
    }
    return 1;
}
#############################################
#
##<<
sub justn {
    #
    # title : justifying a number
    #
    # aim: justify a number, that transforming it as a string
    #      with a precised number of decimals, a fixed number
    #      of digits. For instance 12 is turned into "0012.00"
    #      for two decimals and four digits.
    #
    # output: the fitted string
    #
    # remark: no truncation for digits, 1000000 with four digits will
    #         remain "1000000" but truncation for decimals 0.1001 with
    #         two decimals will become "0.10".
    #
    # arguments
    my $hrsub = {numb =>[undef,"n","The number to be justified"],
                 deci =>[    0,"n","Desired number of decimals.",
                                   "Negative value means no modification."],
                 digi =>[    3,"n","Desired number of digits",
                                   "Negative value means no modification."],
                 roun =>[    0,"n","Must a true rounding be done when the number",
                                   "of decimals is precised?"]
                };
##>>
    my $argu   = &argu("justn",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my %argu = %{$argu};
    my $numb = $argu{numb};
    my $deci = $argu{deci};
    my $digi = $argu{digi};
    my $roun = $argu{roun};
    if ($roun != 0) { $roun=1;}
    # negative value
    my $neg = 0;
    if ($numb < 0) { 
        $neg = 1;
        $numb = -$numb;
    }
    # truncating the decimal number
    if ($deci >= 0) {
        $roun =  $roun * 0.5 / (10**$deci);
        if ($numb < 0) { $roun = -$roun;}
        $numb = int(($numb * (10**$deci)) / (10**$deci) + $roun);
    }
    # turning into a string and adding necessary decimals
    my $res;
    if ($deci > 0) {
        $res = int($numb * (10**$deci));
        $res = "$res";
        $res = substr($res,0,length($res)-$deci).".".substr($res,-$deci);
        if (int($numb) == 0) {
            $res = "0".$res;
        }
    } elsif ($deci == 0) {
        $res = int($numb);
    } else {
        $res = "$numb";
    }
    # adding zeroes to digits
    if ($digi >= 0) {
        my $nu = int($numb);
        my $nus = "$nu"; my $zeros = "";
        while (length($nus) < $digi) {
            $nus = "0$nus";
            $zeros = "0$zeros";
        }
        $res = $zeros.$res;
    }
    # negativity restitution
    if ($neg) {
        $res = "-$res";
    }
    # returning
    $res;
}
#############################################
#
##<<
sub join8hash {
    #
    # title : concatening a hash
    #
    # aim: prepares an array of strings displaying in
    #      a convenient way the contents of a hash
    #
    # output: the reference ot the prepared array
    #
    # arguments
    my $hrsub = {hash =>[undef,"h","The reference to the hash to be prepared"],
                 orde =>[    "k","ac","defined the order to be used.",
                                      " -'k' increasing alphabetical order of the keys",
                                      " -'K' decreasing alphabetical order of the keys",
                                      " -'v' increasing alphabetical order of the values",
                                      " -'V' decreasing alphabetical order of the values",
                                      " -'n' increasing numerical order of the values",
                                      " -'N' decreasing numerical order of the values",
                                      " - or the reference to an array of the keys",
                                      "      in the desired order"],
                 form =>[    "s","hc","Format to use for the presentation",
                                      " -'s' standard way, that is each key between",
                                      "      parentheses before it values",
                                      " -'k' only the keys surrounded with parentheses",
                                      "           and separated with a blank",
                                      " -'v' only the values separated a blank",
                                      " - or the reference to an hash with two keys",
                                      "      ('k' and 'v') indicating respectively",
                                      "      the way to prepare keys ans values:",
                                      "      'undef' means that must not be included",
                                      "      a reference to an array of four components",
                                      "      giving (i) the length of the string to indicate",
                                      "                 to &juste,",
                                      "             (ii) the type of justification to indicate",
                                      "                 to &juste,",
                                      "             (iii) the string to introduce before and",
                                      "             (iv) the string to put after.",
                                      "      (here the same format is applied to every",
                                      "       couple key/value in the next possibility",
                                      "       they can be different)",
                                      " - or the reference to an hash having keys belonging",
                                      "      to those of '\%\$hash', when a key is not present",
                                      "      the corresponding couple is not represented.",
                                      "      The values of this hash are reference with the",
                                      "      same pattern as in the previous possibility."],                     
                 sepa =>[    1, "n","How to present the couples of key/value.",
                                      " - 0 in a single string",
                                      " - 1 in an array of two components, for keys and for values",
                                      " - 2 in different components of an array for each couple"]
                };
##>>
    my $argu   = &argu("join8hash",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my %argu = %{$argu};
    my $hash = $argu{hash}; 
    my $sepa = $argu{sepa};
    my $orde = $argu{orde};
    my $form = $argu{form};
    # dertimining the order of the keys
    my @ele;
    if (ref($orde) eq "ARRAY") {
        # imposed order
        @ele = @$orde;
    } else {
        # standard order
        my $inc = 1; my $num = 0; 
        my @values = keys %$hash;
        if ($orde eq "K") {
           $inc = 0; $num = 0; @values = keys %$hash; 
        } elsif ($orde eq "v") {
            $inc = 1; $num = 0; @values = values %$hash;
        } elsif ($orde eq "V") {
            $inc = 0; $num = 0; @values = values %$hash;
        } elsif ($orde eq "n") {
            $inc = 1; $num = 1; @values = values %$hash;
        } elsif ($orde eq "N") {
            $inc = 0; $num = 1; @values = values %$hash;
        }
        my $ordu = &ordre(rar=>\@values,inc=>$inc,num=>$num);
        my @clef = keys %$hash;
        for (my $i=0; $i < scalar @clef; $i++) {
            $ele[$i] = $clef[$ordu->[$i]];
        }
    }
    # preparing the formatting
    if (ref($form) ne "HASH") {
        if ($form eq "k") {
            $form = {k=>[0,"n","{","} "],v=>undef};
        } elsif ($form eq "v") {
            $form = {k=>undef,v=>[0,"n"," "," "]};
        } else {
            $form = {k=>[0,"n","{","} "],v=>[0,"n"," "," "]};
        }
    }
    my @clefs = keys %$form;
    if (ref($form) eq "HASH") {
        if (scalar @clefs eq 2) {
            my $vk = belongs2(sca=>\"k",arr=>\@clefs);
	    my $vv = belongs2(sca=>\"v",arr=>\@clefs);
            if ($vk+$vv == 2) {
                foreach (keys %$hash) {
                    $form->{$_} = {k=>$form->{k},v=>$form->{v}};
                }
            }
        }
    } else {
        die("Sorry : internal error !!!");
    }
    # preparing
    my @compok; my @compov; my $ii = -1;
    @clefs = keys %$form;
    for (my $i=0; $i < scalar @ele; $i++) {
        my $clef = $ele[$i];
        if (belongs2(sca=>\$clef,arr=>\@clefs)) {
            $ii++;
            my $fk = "";
            if (defined($form->{$clef}->{k})) {
                $fk = $form->{$clef}->{k}->[2].
                      $clef.
                      $form->{$clef}->{k}->[3];
                $fk = &juste(chain=>$fk,long=>$form->{$clef}->{k}->[0],
                                        just=>$form->{$clef}->{k}->[1],trim=>0);
            }
            my $fv = "";
            if (defined($form->{$clef}->{v})) {
                if (defined($$hash{$ele[$i]})) {
                    $fv = $form->{$clef}->{v}->[2].
                          $$hash{$ele[$i]}.
                          $form->{$clef}->{v}->[3];
                    $fv = &juste(chain=>$fv,long=>$form->{$clef}->{v}->[0],
                                 just=>$form->{$clef}->{v}->[1],trim=>0);
		} else {
                    $fv = $form->{$clef}->{v}->[2].
                          "undef".
                          $form->{$clef}->{v}->[3];
                    $fv = &juste(chain=>$fv,long=>$form->{$clef}->{v}->[0],
                                 just=>$form->{$clef}->{v}->[1],trim=>0);
		}
            }
            $compok[$ii] = $fk;
            $compov[$ii] = $fv;
        }
    }
    # returning 
    my $res;
    if ($sepa==0) {
        $res = "";
        for (my $i=0; $i < scalar @compok; $i++) {
            $res = $res.$compok[$i].$compov[$i];
        }
    } elsif ($sepa==1) {
        $res = ["",""];
        for (my $i=0; $i < scalar @compok; $i++) {
            my $lk = length($compok[$i]);
            my $lv = length($compov[$i]);
            if ($lk < $lv) { $lk = $lv;}
            $$res[0] = $$res[0].&juste(chain=>$compok[$i],trim=>0,long=>$lk);
            $$res[1] = $$res[1].&juste(chain=>$compov[$i],trim=>0,long=>$lk);
        }
    } else {
        $res = [];
        for (my $i=0; $i < scalar @compok; $i++) {
            $$res[$i] = $compok[$i].$compov[$i];
        }
    }
    $res;
}
###>>>
1;

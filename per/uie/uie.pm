#
# general functions to be used in perl 
#
# 16_03_18 16_03_19 16_03_20 16_03_21 16_03_23
# 16_03_28 16_03_31 16_04_01 16_04_07 16_04_10
# 16_04_11 16_04_13 16_04_15 16_04_16 16_04_24
# 16_04_25 16_04_27 16_04_28 16_04_29 16_05_03
# 16_05_08 16_05_22 16_05_23 16_05_31 16_06_02
# 16_06_03 16_06_04 16_06_29 16_08_05 16_08_06
# 16_08_07 16_08_08 16_08_31 16_09_01 16_09_05
# 16_09_07 16_09_08 16_09_09 16_09_11 16_09_15
# 16_09_16 16_09_19 16_09_21 16_09_22 16_09_27
# 16_09_28 16_11_02 17_03_31 17_04_02 17_04_03
# 17_04_04 17_04_05 17_04_06 17_04_08 17_04_11
# 17_04_14 17_04_22 17_04_24 17_04_26 17_04_27
# 17_04_28 17_05_05 17_05_07 17_05_09 17_05_11
# 17_05_14 17_06_28 17_09_11 17_09_24 17_09_26
# 17_10_04 17_10_05 17_10_10 17-10_17 17_10_18
# 17_10_30 17_11_04 17_11_12 17_11_13 17_11_14
# 17_11_15 17_11_17 17_11_18 17_11_19 17_11_26
# 17_11_30 17_12_06 18_01_01 18_01_08 17_01_09
# 18_01_25 18_01_26 18_01_30 18_02_07 18_02_09
# 18_03_13 18_04_10 18_09_29 18_09_30 18_10_24
#
package uie;
use strict;
use warnings;
use Term::ReadKey;
use Term::ANSIColor;
use Devel::StackTrace;
use Scalar::Util qw(looks_like_number);
use Date::Calc qw(:all);
use MIME::Base64;
 
###<<<
#
# 'uie' are the three vocals of the French word 'UtIlEs',
#       to remind the basic aim of the proposed subroutines.
#
# The module comprises a series of subroutines that I found of
# use to have at hand. Surely, most of them already exist
# somewhere else in a more efficient code... but it was a 
# good exercise for me.
#
# Except for 'argu', the use of arguments is somehow standardized: 
#         (i) only character chains and references
#             are used, 
#         (ii) they are given with a hash of imposed
#              keys of three characters (as 'uie'),
#         (iii) if possible, sensible default values are
#               provided,
#         (iv) as far as possible, a check is done about
#              the values which are proposed (done by
#              subroutine 'argu').
#
# Reporting errors is a major concern of programmation
# with nested calls of routines. To help a general
# strategy has been attempted by some kind of an
# error object which is no more than a reference
# to an array whose first component contains
# the value of constant '$uie::err_ide'. Other components
# are error messages cumulated within the nested calls.
#
# It is worth distinguishing two levels:
#  - different messages within an error
#  - different errors within an error object
# 
# This can be implemented with the following 
# subroutines:
# 'error9' to detect if a scalar is an error object.
# 'add8err' to add a message to an error, possibly
#             creating it.
# 'conca8err' to concatenate an additional error a
#             pre-existing error object, possibly 
#             creating it.
# 'print8err' to print the content of an error object
#             putting in light the two levels.
#
# TO BE DONE
#   make the documentation index not with the simple
#   subroutine names but with keywords deduced from
#   the name splitting with digits.
#
###>>>
#
#############################################
# some general constants
#############################################
# delimitation chain for e-mail
our $limit_part = "ZZZLiMiTeSZZZ";
# extended character set
my $char_set = "UTF8";
# identification of error object
our $err_ide = "ErReUr";
# number of characters for presentations
our $width = 80;
# reserved words for &read8line
our $STD = "STD";
our $ORD = "ORD";
# to pass extra-information outside a subroutine
our $sei = []; 
#
#############################################
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
    #       All keys of the proposed hash (@argu) must be described
    #                into the hash referenced by $rhsub.
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
    #                 to be used as an help; may not exist.
    # Notice that 'undef' cannot be a default value since such
    #        a value for [0]  means that the argument must 
    #        be provided by the call.
    #        Nevertheless, it is an acceptable value when [1] 
    #        comprises 'u'.
    #
    # Be aware that quite not understandable messages can be the 
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
         	    print "Definitions of arguments for '&$sub':\n";
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
    if ((scalar @arg % 2)!=0) {
        print("in '&argu', the third argument is not a flatenned hash\n".
              "Probably a hash was not given as arguments in '&$sub'?");
        print ("\nPossible argument(s) are:\n");
        print ("   <<< ",join(" | ",keys %$rhsub)," >>>\n");
        die ("This is a fatal error");
    }
    for (my $i = 0; $i < (scalar @arg)/2; $i++) {
        my $ake = $arg[$i*2];
        if (!defined($ake)) {
	    print ("The key number ",$i+1," of the hash for arguments of $sub is not defined.\n");
	    print ("  Its value is $arg[$i*2+1] \n");
            print ("\nPossible argument(s) are:\n");
            print ("   <<< ",join(" | ",keys %$rhsub)," >>>\n");
	    die ("This is not acceptable!\n ");
	}
        # checking it belongs to the possible set
        my $koui = 0;
        foreach (keys %$rhsub) {
            if ($_ eq $ake) { $koui = 1;}
        }
        if (!$koui) {
	    print ("In position ",$i+1,", the proposed argument is named '$ake'.\n");
	    print ("  '$ake' is not in the list of possible arguments for subroutine '$sub'\n");
            print ("\nPossible argument(s) are:\n");
            print ("   <<< ",join(" | ",keys %$rhsub)," >>>\n");
	    die (" --->'$ake' is not accepted!\n ");
        }
    }
    # checking $rhsub
    foreach (keys %$rhsub) {
        if (!defined($rhsub->{$_}->[1])) {
            print "The type of argument '$_' of '&$sub' is not defined in ",'$rhsub',"!\n";
            print ("\nPossible argument(s) are:\n");
            print ("   <<< ",join(" | ",keys %$rhsub)," >>>\n");
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
                print ("\nPossible argument(s) are:\n");
                print ("   <<< ",join(" | ",keys %$rhsub)," >>>\n");
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
			push @message,"Argument $k is not a REFERENCE to a scalar.";
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
                print ("\nPossible argument(s) are:\n");
                print ("   <<< ",join(" | ",keys %$rhsub)," >>>\n");
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
sub now {
    #
    # title : present moment (or any)
    #
    # aim : generates a string giving time and/or date
    #       according to different ways.
    #
    # output: the string
    #
    # arguments
    my $hrsub = {wha =>["dm","c","comprises 'd' for day; 'h' for hour; 'm' for minute; 's' for second."],
                 fmt =>["red","c","'red' to get a reduced way if not a verbose one"],
                 sep =>[["_","@",":"],"a","The three separators to use in case of a reduced format"],
                 whe =>["now","ca","either 'now' or a reference to the equivalent of 'localtime[0,1,2,3,4,5]'"]
                };
##>>
    my $nsub = (caller(0))[3]; 
    my $argu   = &argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $wha = $argu->{wha}; 
    if ($wha=~"s") { $wha = $wha."hm";}
    if ($wha=~"m") { $wha = $wha."h";}
    my $fmt = $argu->{fmt};
    my $sep = $argu->{sep};
    my $whe = $argu->{whe};
    # getting the time
    my @when = (localtime)[0,1,2,3,4,5];
    if (ref($whe) eq "ARRAY") {
        @when = @$whe;
    }
    my($seco,$minu, $heure, $jour, $mois, $an)=@when;
    $mois = $mois+1; $an = $an+1900;
    my $res = "";
    if ($fmt eq "red") {
        if ($wha=~"d") {
            $mois = &justn(num=>$mois,dig=>2);
            $jour = &justn(num=>$jour,dig=>2);
            $res = join($sep->[0],($an,$mois,$jour));
            if ($wha=~"h") { $res = $res.$sep->[1];}
        }
        if ($wha=~"h") {
            $res = $res.&justn(num=>$heure,dig=>2);
            if ($wha=~"m") { $res = $res.$sep->[2];}
        }
        if ($wha=~"m") {
            $res = $res.&justn(num=>$minu,dig=>2);
            if ($wha=~"s") { $res = $res.$sep->[2];}
        }
        if ($wha=~"s") {
            $res = $res.&justn(num=>$seco,dig=>2);
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
    # output: the resulting answer when the program is not
    #           stopped.
    #
    # arguments
    my $hrsub = {sto =>["q","c","Answer to exit the program. The chain is lowercased for the test."],
                 mes =>["" ,"c","When not the empty string, a message to add."],
                 con =>["" ,"c","Answer to continue the program (also lowercased).",
                                "When '' (default) this option is not considered,",
                                "if not: takes the priority over argument 'sto'."]
                };
##>>
    my $nsub = (caller(0))[3]; 
    my $argu   = &argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $stop = $argu->{sto};
    my $mess = $argu->{mes}; # lc($argu->{mes});
    my $cont = lc($argu->{con});
    # asking
    if ($mess) {
        print $mess,"\n";
    }
    my $res;
    if ($cont eq "") {
        print "Enter '$stop' TO STOP the program: ";
        $res = <STDIN>; chomp $res;
        if (lc($res) eq $stop) {
            die "YOUR answer exited the program\n ";
        }
    } else {
        print "Enter '$cont' TO CONTINUE the program: ";
        $res = <STDIN>; chomp $res;
        if (lc($res) ne $cont) {
            die "YOUR answer exited the program\n ";
        }
    }
    # returning
    $res;
}
#############################################
#
##<<
sub belong9 {
    #
    # title : scalar belongs to array?
    #
    # aim : test if a scalar belongs to a given array
    #
    # output: an array of the element numbers of occurrence.
    #         so () means not found
    #            (0,7) found in the first and eigth elements
    #
    # arguments
    my $hrsub = {sca =>[undef,"s","The element to be checked."],
                 arr =>[undef,"a","The array where are stored the possible elements."],
                 low =>[0,    "n","Must the comparison be made after lower casing?"],
                 com =>[["=~ /^","\$/"],"a","A reference to an array of two elements",
                                           "to be used for the comparison with the",
                                           "included operator. Default is the matching",
                                           "operator and the strict equality pattern;",
                                           "it is equivalent to ['eq ','']",
                                           "Some care must be taken with the '\', for",
                                           "instance to remove spaces at the end, one",
                                           'must enter: ["=~ /^\\s*","\\s*\$/"]'],
                 sen =>[0,    "n","Must the comparison made 'array[#] =~ /...scalar.../'",
                                  "or the opposite which is the default behavior",
                                  "i.e. 'scalar =~ /...array[#].../'"]
                };
##>>
    my $nsub = (caller(0))[3]; 
    my $argu   = &argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $sca = $argu->{sca};
    my $arr = $argu->{arr};
    my $low = $argu->{low};
    my $com = $argu->{com};
    my $sen = $argu->{sen};
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
        my $tocheck;
        if ($sen) {
            $tocheck = '"'.$elem.'"'.$com->[0].$scav.$com->[1];
        } else {
            $tocheck = '"'.$scav.'"'.$com->[0].$elem.$com->[1];
        }
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
sub compare8set {
    #
    # title : compare the elements of two arrays
    #
    # aim : two arrays are interpreted as two sets of
    #       strings and this subroutine performs some
    #       set operations on them
    #
    # output: a reference to an array of the element 
    #         resulting from the operation onto the 
    #         two sets.
    #
    # arguments
    my $hrsub = {se1 =>[undef,"a","Reference to the first set"],
                 se2 =>[undef,"a","Reference to the second set"],
                 ope =>[  "d","c","The operation to perform onto the two sets",
                                   "Possibilities are:",
                                   "   'i' for intersection",
                                   "   'u' for union",
                                   "   'd' for symmetric difference",
                                   "   'a' for complement of se2 in se1",
                                   "   'b' for complement of se1 in se2"],
                 rep =>[    1,"n","Must repetitions be considered (if not eliminated)."]
                };
##>>
    my $nsub = (caller(0))[3]; 
    my $argu   = &argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $set1 = $argu->{se1};
    my $set2 = $argu->{se2};
    my $oper = $argu->{ope};
    my $repe = $argu->{rep};
    # initialization
    my $res = [];
    # checking
    if ($oper !~ /^[iudab]$/) {
        die "'compare8set': argument 'oper' must be i, u, d, a or b\n";
    }
    # eliminating repetitions
    if (!$repe) {
        my @set = @$set1;
        @$set1 = do { my %seen; grep { !$seen{$_}++ } @set };
        @set = @$set2;
        @$set2 = do { my %seen; grep { !$seen{$_}++ } @set };
    }
    # computing the three elementary subsets
    my @A = (); my @B = (); my @C = @$set2;
    foreach my $ele (@$set1) {
        my @app = &belong9(sca=>\$ele,arr=>\@C);
        if (scalar(@app) > 0) {
            splice @C,$app[0],1;
            push @B,$ele;
        } else {
            push @A,$ele;
        }
    }
    # preparing the output
    if ($oper eq "i") {
        @$res = @B;
    } elsif ($oper eq "u") {
        @$res = (@A,@B,@C);
    } elsif ($oper eq "d") {
        @$res = (@A,@C);
    } elsif ($oper eq "a") {
        @$res = @A;
    } elsif ($oper eq "b") {
        @$res = @C;
    }
    # returning
    $res;
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
    #     Giving 'check8ref' a reference to another type will
    #     be considered faultly.
    #
    # arguments
    my $hrsub = {ref =>[undef,"r","The reference to be checked"],
                 typ =>[ "sah","c","Type of the reference 'h','a','s' or a combination of them"],
                 rlo =>[ [-1,-1],"a","minimum and maximum lengths when reference to array or to hash",
                                   " ('[-1,-1]' means no check)"],
                 key =>[ [],"a","Possible key values in the referred array when reference to a hash",
                                " ('[]' means no check)"]
                };
##>>
    my $nsub = (caller(0))[3]; 
    my $argu   = &argu($nsub,$hrsub,@_);
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
    my $rlocheck = (($rlo[0]>=0) and ($rlo[1]>=0));
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
    my $hrsub = {cha =>[undef,"c","The chain to be justified"],
                 tri =>[    1,"n","Must ending spaces be removed?"],
                 ava =>[   "","c","Chain to introduce before"],
                 apr =>[   "","c","Chain to introduce after"],
                 lon =>[   64,"n","Length of the justified chain",
                                  " (when <= 0 no justification"],
                 jus =>[  "l","c","Type of justification can be:",
                                  "   'l' for to the left without truncation",
                                  "   'L' for to the left with    truncation",
                                  "   'c' for centering without truncation",
                                  "   'C' for centering with    truncation",
                                  "   'r' for to the right without truncation",
                                  "   'R' for to the right with    truncation",
                                  "   'n' for no justification then",
                                  "       long is not considered."],
                 ulc =>[  "n","c","Type of capitalization can be:",
                                  "   'n' nothing",
                                  "   'U' every word uppercased",
                                  "   'L' every word lowercased",
                                  "   'c' first letter of each word uppercased",
                                  "   'C' first letter of each word uppercased",
                                  "       and remaining letters lowercased"],
                 spa =>[  "n","c","Prior modifications (can comprise several",
                                  "       modif, then performed in this order;",
                                  "       then the presence of 'n' implies that",
                                  "       nothing is done)",
                                  "   'n' nothing",
                                  "   's' multiple consecutive spaces are removed"]
                };
##>>
    # constants
    my $ma = "+";
    # arguments
    my $nsub = (caller(0))[3]; 
    my $argu   = &argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my %argu = %{$argu};
    my $chaine = $argu{cha}; my $trim  = $argu{tri};
    my $avan  = $argu{ava}; my $apre = $argu{apr};
    my $long   = $argu{lon} ; my $just  = $argu{jus};
    my $ulca  = $argu{ulc};
    my $spac  = $argu{spa};
    # prior modification
    if (!($spac =~ /n/)) {
        if ($spac =~ /s/) {
	    $chaine =~ s/ +/ /g;
        }
    }
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
    $chaine = $avan.$chaine.$apre;
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
    my $nsub = (caller(0))[3]; 
    my $argu   = &argu($nsub,$hrsub,@_);
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
    my $nsub = (caller(0))[3]; 
    my $argu   = &argu($nsub,$hrsub,@_);
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
    #               'bbl' at the beginning of the tag to open the block
#                   (the end of this line is not considered)
#               'ebl' at the beginning of the tag to close the block
#               Ending components can be cleared out from their 
#                      starting and ending blanks characters.
#
# output: a reference to an array of references associated
#         to each line of the block, these references point
#         towards arrays of the different components of each
#         lines except when 'sep' is 'undef' where the referred
#         array is just the array of the lines.
#
# arguments
my $hrsub = {com  =>[  "#","uc","Lines beginning with it are neglected.",
			       "When 'undef' every line is considered."],
	     sep  =>[ "::","cu","Separator between fields within each line.",
			       "When 'undef' no separation is performed."],
	     fil  =>[undef,"c","Name of the file to be read."],
	     bbl  =>["##<<","c","Tag to begin a block"],
	     ebl  =>["##>>","c","Tag to   end a block"],
             bla  =>[    0,"n","Must framing blanks be removed?"],
	     uni  =>[    0,"n","Must the reading be restricted to the first block?"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my $com = $argu->{com};
my $sep = $argu->{sep};
my $fil = $argu->{fil};
my $bbl = $argu->{bbl};
my $ebl = $argu->{ebl};
my $bla = $argu->{bla};
my $uni = $argu->{uni};
#
# reading the file eliminating the comment lines
#    open(my $fic,'<:encoding(UTF-8)',$fil) or die "cannot open > $fil: $!\n ";
open(my $fic,'<',$fil) or die "cannot open $fil: $!\n ";
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
            # removing blanks
            if ($bla) {
                foreach my $cpt (@cpts) {
                    $cpt = &juste(cha=>$cpt,jus=>"n")
                }
            }
            if (defined($sep)) {
                push @$rres,\@cpts;
            } else {
                push @$rres,@cpts;
            }
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
my $hrsub = {rpa =>[undef,  "a","Reference to an array of references to strings",
				"  (each associated to a line of the pannel)",
				"  (of course can be '[]' for an empty pannel"],
	     tfr =>["*"x80, "cu"," line to be added before the pannel",
				"    when 'undef' no line is added.",
				"    and the constant 'uie::width' is used",
				"    to define the width of the pannel."],
	     tvo =>[1,      "n"," number of empty lines after the added line"],
	     lfr =>["* ",   "c"," string to be added before each line"],
	     rfr =>[" *",   "c"," string to be included to finish each line"],
	     bvo =>[1,      "n"," number of empty lines before the last line"],
	     bfr =>["*"x80, "cu"," line to be added at the end of the pannel",
				"    when 'undef' no line is added."],
	     jus =>[  "l","c"," type of justification for each line ('l', 'c' or 'r')",
				"  either a scalar then the same justification",
				"  is applied to all the lines, or a reference",
				'  to an array having the same length than "@$rpa"',
				"  specifying the justification for each line."],
	     tco =>["green","cua"," text coloration: either 'undef' for no coloration",
				"   or a scalar containing the color to apply to every line",
				"   or a reference to an array containing the color".
				"   for each line."],
	     fco =>["white","cu"," frame coloration: either 'undef' for no coloration",
				"   or a scalar containing the color to apply to the",
				"   vertical and horizontal parts of the frame.",
				"   Notice that you can also defined the foreground",
				"   color and painting this way the frame for instance",
				"   with 'on_blue blue'"]
};
##>>
#
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
#
my $rpan = $argu->{rpa};
my $tfra = $argu->{tfr};
my $tvoi = $argu->{tvo};
my $lfra = $argu->{lfr};
my $rfra = $argu->{rfr};
my $bvoi = $argu->{bvo};
my $bfra = $argu->{bfr};
my $just = $argu->{jus};
my $tcol = $argu->{tco};
my $fcol = $argu->{fco};
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
    print &juste(cha=>$$_,tri=>1,ava=>"",apr=>"",
		 lon=>$uwi,jus=>$just[$ii]);
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
my $hrsub = {que  =>[undef,"c","The question to be raised"],
	     typ  =>[    0,"n","Must the input numerically transformed?"],
	     fmt  =>[{avant=>"=> ",apres=>" : ",long=>60,just=>"r"},"h",
		     "The way the question be justified\n  ('{}' for no justification)"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my $ques = $argu->{que};
my $type = $argu->{typ};
my $form = $argu->{fmt};
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
print "<$ques>\n";
    print &juste(cha=>$ques,ava=>$form->{avant},
			    apr=>$form->{apres},
			    lon=>$form-> {long},
			    jus=>$form-> {just});
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
	$touche = &numerical(cha=>$touche,tra=>1);
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
    $repon = &numerical(cha=>$repon,tra=>1);
}
#
# returning
$repon;
}
#############################################
#
##<<
sub get8answer {
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
my $hrsub = {rpl=> [undef,"a","reference to an array.\n".
				 "   to be printed with '&print8panneau'"],
	     rqu=> [undef,"h","reference to the hash of questions to ask.\n".
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
	     ror=> [undef,"a","reference to an array of 'keys %\$rquest' in the desired asking order."],
	     rfo=> [{}   ,"h","reference to a hash of references to arrays giving for each\n",
				  "question, the way to display them on the screen just above\n",
				  "the questionning line. Individual arrays gives the necessary\n",
				  "argument for a call to '&juste': \$avant,\$apres,\$long,\$just",
				  "or '[]' when no formatting is desired for this question.\n",
				  "Also when the hash is empty no formatting is done for any question."],
	     lah=>[100,"n","width of the help pannel before the question"],
	     loh=>[17,"n","number of lines for the help pannel, just before questions"],
	     con=>["s","hc","Value for argument 'form' of '&join8hash' used when constructing",
				 "the progressive set of answers"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my $rplaca = $argu->{rpl};
my $rquest = $argu->{rqu};
my $rordre = $argu->{ror};
my $rforma = $argu->{rfo};
my $largeur = $argu->{lah};
my $longhelp = $argu->{loh};
my $construc = $argu->{con};
#
# checking consistency between questions and question order labels
my $conts = 0;
foreach my $ii (@$rordre) {
    if (!&belong9(sca=>\$ii,arr=>[keys %$rquest])) { 
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
	if (!&belong9(sca=>\$kk,arr=>[keys %$rforma])) { 
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
	    &print8panneau(rpa=>$rplaca,tfr=>"+"x$largeur,tvo=>0,
			   lfr=>"+ ",rfr=>" +",bvo=>0,bfr=>"+"x$largeur,
			   jus=>"l",fco=>"bright_green");
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
	my $prog = &join8hash(has=>\%const,ord=>$rordre,fmt=>$construc);
	$placard->[$longhelp-2] = \$$prog[0];
	$placard->[$longhelp-1] = \$$prog[1];
	&print8panneau(rpa=>$placard,tfr=>"*"x$largeur,tvo=>1,
		       lfr=>"* ",rfr=>" *",bvo=>1,bfr=>"*"x$largeur,
		       jus=>"l",fco=>"bright_red");
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
	if (defined $rquest->{$_}->{defa}) {
	    $qqq = $qqq." <".$rquest->{$_}->{defa}.">";
	}
	if (ref($rforma) eq "HASH") {
	    $repon = &ask8question(que=>$qqq,
				   typ=>$numero,
				   fmt=>$rforma->{$_});
	} else {
	    $repon = &ask8question(que=>$qqq,
				   typ=>$numero);
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
		    $repon = &uie::justn(num=>$repon,dig=>-1,
					 dec=>${$$rquest{$_}}{chec}[3]);
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
    #        hashes. In case of a hash, the printing is done
    #        after sorting.
    #
    # output: 1
    #
# arguments
my $hrsub = {str =>[undef,"csahu","The structure to be displayed"],
             rtd =>[0,"n","Possibly a restriction for arrays and hashes",
                      "0: all components displayed",
                      "'#': only component from 1 to '#'",
                      "'-#': only component from last+1-'#' to last"],
	     ind =>[{h=>"xx",a=>"++","s"=>'..',p=>"  "},"h",
		    "The way to make indentation:",
		    " h for hash reference, a for array reference",
		    " s for scalar reference and p for printing."],
	     pro =>[0,"n","The depth of the display",
			  "  (used for indentation and recursivity)."],
	     pri =>[0,"n","Must types of reference be added?",
			  "0 for no, 1 for starting and 2 for also ending."],
	     add =>[0,"n","Must a new line added after a reference?"],
	     prm =>[5,"n","The maximum depth admitted for recursivity"],
	     prp =>[0,"n","Must the depth degree be printed before each line?"],
	     cle =>["","c","For the hash keys (internal use)"]
	    };
## To be corrected: when a value of a hash is empty array, the key appears twice! 
##                  See also the case of empty hashes.
##                  When restriction is applied on components (argument 'rtd')
##                       the mark with '. . . . ...' doesn't appear on some levels?
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my $stru = $argu->{str};
my $redu = $argu->{rtd};
my $clef = $argu->{cle};
my $prof = $argu->{pro};
my $prmx = $argu->{prm};
my $inde = $argu->{ind};
my $addi = $argu->{add};
my $prin = $argu->{pri};
my $prpr = $argu->{prp};
# checking the depth
if ( $prof > $prmx) { return 1;}
# numbering the level
my ($nu0,$nu1);
if ($prpr) {
    $nu0 = &juste(cha=>$prof,  ava=>"<",apr=>">",lon=>5,jus=>"l");
    $nu1 = &juste(cha=>$prof+1,ava=>"<",apr=>">",lon=>5,jus=>"l");
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
    my $loar = scalar @$stru;
    if ($loar == 0) {
	print $nu0,$$inde{a}x($prof+2)," Empty Array\n";
    } else {
	for my $svar (@$stru) {
	    $kk++;
            my $oui = 1;
            if ($redu > 0) {
                if ($kk >= $redu) { $oui = 0;}
                if ($kk == (1+$redu)) {
                    print ". "x25,"\n";
                }
            }
            if ($redu < 0) {
                if ($kk <= (scalar(@$stru)+$redu-1)) { $oui = 0;}
                if ($kk == (scalar(@$stru)+$redu-2)) {
                    print ". "x25,"\n";
                }
            }
            if ($oui) {
                &print8structure(str=>$svar,rtd=>$redu,pro=>$prof+1,
		    	         cle=>"[".$kk."]",add=>$addi,
			         prp=>$prpr,pri=>$prin,
			         ind=>$inde,prm=>$prmx);
            }
	}
    }
    if ($prin>1) { print $nu0,$$inde{a}x($prof+1)," array\n";
    }
    if ($addi) { print "\n";}
} elsif (ref($stru) eq "HASH") {
    if ($prin>0) { print $nu0,$$inde{h}x($prof+1)," HASH\n";
    } else { print $nu0,"\n";}
    my $loar = scalar (keys %$stru);
    if ($loar == 0) {
	print $nu0,$$inde{a}x($prof+2)," Empty Hash\n";
    } else {
        my $kkkk = -1;
	for my $kk (sort(keys(%$stru))) {
            $kkkk++;
            my $oui = 1;
            if ($redu > 0) {
                if ($kkkk >= $redu) { $oui = 0;}
                if ($kkkk == (1+$redu)) {
                    print ". "x25,"\n";
                }
            }
            if ($redu < 0) {
                if ($kkkk <= (scalar(keys(%$stru))+$redu-1)) { $oui = 0;}
                if ($kkkk == (scalar(keys(%$stru))+$redu-2)) {
                    print ". "x25,"\n";
                }
            }
            if ($oui) {
	        &print8structure(str=>$stru->{$kk},rtd=>$redu,pro=>$prof+1,
			         cle=>"{".$kk."}",add=>$addi,
			         prp=>$prpr,pri=>$prin,
			         ind=>$inde,prm=>$prmx);
            }
	}
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
sub write8structure {
    #
    # title : write a structure in a file for future use
    #
    # aim : similar to &print8structure but to produce a
    #        piece of code, reusable with &read8structure.
    #
    # remarks: - references to scalar are transformed to scalars.
    #          - numerical values are transformed to character strings.
    #
    # output:  the cumulated string when everything was right. 
    #          If the file exists and must not a fatal error is raised.
    #
# arguments
my $hrsub = {str =>[undef,"csahu","The structure to be written"],
             fil =>[   "","c","Name of the file to be created",
                              "when '' a display on the screen"],
             cfi =>[    0,"n","Must the non existence of the file",
                              "be checked? If not a pre-existing",
                              "file will be replaced."],
	     prm =>[20,"n","The maximum depth admitted for recursivity"],
	     pro =>[0,"n","The depth of the display (used for recursivity)."],
	     res =>["","c","String for recursive accumulation."]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my $stru = $argu->{str};
my $file = $argu->{fil};
my $cfil = $argu->{cfi};
my $prmx = $argu->{prm};
my $prof = $argu->{pro};
my $resu = $argu->{res};
# checking the depth
if ( $prof > $prmx) { return 1;}
# cumulating recursively
if (!defined($stru)) {
    $resu = $resu." undef\n";
} elsif (ref($stru) eq "ARRAY") {
    my $kk = -1;
    my $loar = scalar @$stru;
    if ($loar == 0) {
	$resu = $resu." [] ";
    } else {
	for my $svar (@$stru) {
	    $kk++;
            if ($kk == 0) { 
                $resu = $resu." [";
            }
            $resu = &write8structure(str=>$svar,fil=>$file,cfi=>$cfil,
                             pro=>$prof+1,prm=>$prmx,res=>$resu);
            if ((1+$kk) == $loar) { 
                $resu = $resu."]\n";
            }
            else { 
                $resu = $resu.",";
            }
	}
    }
} elsif (ref($stru) eq "HASH") {
    my $loar = scalar (keys %$stru);
    if ($loar == 0) {
	$resu = $resu." {}";
    } else {
        my $kkkk = -1;
	for my $kk (sort(keys(%$stru))) {
            $kkkk++;
            if ($kkkk == 0) { 
                $resu = $resu." {";
            }
            $resu = $resu."\"$kk\"=>";
            $resu = &write8structure(str=>$stru->{$kk},res=>$resu,
                             fil=>$file,cfi=>$cfil,
                             pro=>$prof+1,prm=>$prmx);
            if ((1+$kkkk) == $loar) { 
                $resu = $resu."}\n";
            } else { 
                $resu = $resu.",";
            }
	}
    }
} elsif (ref($stru) eq "SCALAR") {
    $resu = $resu.'"'.$$stru.'"';
} else {
    $resu = $resu.'"'.$stru.'"';
}
# writting the file
if ( $prof == 0) {
    if ($file ne "") {
        if ($cfil) {
            if (-e $file) {
                die("$nsub: file $file must not exist!");
            }
        }
        open(FIFI,">$file");
        print FIFI $resu,"\n";
    } else {
        print $resu,"\n";
    }
}
# returning
return $resu;
}
#############################################
#
##<<
sub read8structure {
    #
    # title : read a structure previoulsy stored in a file
    #
    # aim : reads a file produced with '&write8structure' where
    #        a structure has been stored giving back the structure.
    #
    # remarks: - no more scalar references,
    #          - no more numerical values.
    #
    # output: a reference to the structure or an error to be checked 
    #           when something went wrong
    #         
    #
# arguments
my $hrsub = {fil =>[undef,"c","Name of the file to be read"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my $file = $argu->{fil};
my $res;
# reading the file
my @slurp;
unless (-e $file) {
    $res = &add8err(err=>"",nsu=>$nsub,
                   erm=>["The file $file doesn't exist!"]);
    return($res);
} else {
    open(FIFI,"<$file");
    @slurp = <FIFI>;
    close(FIFI);
}
my $slurp = join(" ",@slurp);
# building the code
my $cod = '$res = '.$slurp;
# getting the structure
my $exe = eval($cod);
unless (defined($exe)) {
    $res = &add8err(err=>"",nsu=>$nsub,
                   erm=>["The following code is faulty!",
                         "    code = $cod",
                         "Imagine why!"]);
}
# returning the reference
return $res;
}
#############################################
#
##<<
sub copy8structure {
    #
    # title : copy a hierarquical structure of references
    #
    # aim : when one wants to get an independent copy
    #        of a structure of references, a complete
    #        exploration of the structure is necessary,
    #        this is tedious and hazardous. This subroutine
    #        makes the job for you. See also '&print8structure'.
    #
    # output: the copied structure or an error message
    #         (or 1 if help was asked about the arguments)
    #
# arguments
my $hrsub = {str =>[undef,"csahu","The structure to be copied"],
	     pro =>[0,"n","The depth of the copy (used for recursivity)."],
	     prm =>[12,"n","The maximum depth admitted for recursivity",
                           "when attained 0 is returned"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;} 
my $stru = $argu->{str};
my $prof = $argu->{pro};
my $prmx = $argu->{prm};
my $res;
sub quoi {
    my $tu = $_[0];
    ((ref($tu) eq "ARRAY") or (ref($tu) eq "HASH"));
}
# checking the depth
if ( $prof > $prmx) {
    return &add8err(err=>undef,nsu=>$nsub,
		    erm=>["Maximum Depth was exceeded"]);;
}
# copying recursively
if (ref($stru) eq "ARRAY") {
    $res = [@$stru];
    for( my $i = 0; $i < scalar(@$stru); $i = $i + 1 ){
        if (&quoi($$res[$i])) {
            $$res[$i] = &copy8structure(str=>$$res[$i],pro=>$prof+1,prm=>$prmx);
        } else {
            $$res[$i] = $$stru[$i];
        }
    }
} elsif (ref($stru) eq "HASH") {
    $res = {%$stru};
    for my $k (keys(%$stru)) {
        if (&quoi($$res{$k})) {
            $$res{$k} = &copy8structure(str=>$$res{$k},pro=>$prof+1,prm=>$prmx);
        } else {
            $$res{$k} = $$stru{$k};
        }
    }
} else {
    $res = $stru;
}
$res;
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
my $hrsub = {num =>[undef,"n","The number to be justified"],
	     dec =>[    0,"n","Desired number of decimals.",
			      "Negative value means no modification."],
	     dig =>[    3,"n","Desired number of digits",
			      "Negative value means no modification."]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my %argu = %{$argu};
my $numb = $argu{num};
my $deci = $argu{dec};
my $digi = $argu{dig};
# negative value
my $neg = 0;
if ($numb < 0) { 
    $neg = 1;
    $numb = -$numb;
}
# truncating the decimal number
if ($deci >= 0) {
    my $forma = "%.${deci}f";
    my $numbr;
    my $expr = '$numbr = sprintf("'.$forma.'",$numb);';
    my $rou = eval $expr;
    if ($rou) { $numb = $numbr;} 
}
# turning into a string and adding necessary decimals
my $res = $numb;
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
    # output: the reference to the prepared array
    #
# arguments
my $hrsub = {has =>[undef,"h","The reference to the hash to be prepared"],
	     ord =>[    "k","ac","defined the order to be used.",
				 " -'k' increasing alphabetical order of the keys",
				 " -'K' decreasing alphabetical order of the keys",
				 " -'v' increasing alphabetical order of the values",
				 " -'V' decreasing alphabetical order of the values",
				 " -'n' increasing numerical order of the values",
				 " -'N' decreasing numerical order of the values",
				 " - or the reference to an array of the keys",
				 "      in the desired order"],
	     fmt =>[    "s","hc","Format to use for the presentation",
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
	     sep =>[    1, "n","How to present the couples of key/value.",
				 " - 0 in a single string",
				 " - 1 in an array of two components, for keys and for values",
				 " - 2 in different components of an array for each couple"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my %argu = %{$argu};
my $hash = $argu{has}; 
my $sepa = $argu{sep};
my $orde = $argu{ord};
my $form = $argu{fmt};
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
	my $vk = &belong9(sca=>\"k",arr=>\@clefs);
	my $vv = &belong9(sca=>\"v",arr=>\@clefs);
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
    if (&belong9(sca=>\$clef,arr=>\@clefs)) {
	$ii++;
	my $fk = "";
	if (defined($form->{$clef}->{k})) {
	    $fk = $form->{$clef}->{k}->[2].
		  $clef.
		  $form->{$clef}->{k}->[3];
	    $fk = &juste(cha=>$fk,lon=>$form->{$clef}->{k}->[0],
				  jus=>$form->{$clef}->{k}->[1],tri=>0);
	}
	my $fv = "";
	if (defined($form->{$clef}->{v})) {
	    if (defined($$hash{$ele[$i]})) {
		$fv = $form->{$clef}->{v}->[2].
		      $$hash{$ele[$i]}.
		      $form->{$clef}->{v}->[3];
		$fv = &juste(cha=>$fv,lon=>$form->{$clef}->{v}->[0],
			     jus=>$form->{$clef}->{v}->[1],tri=>0);
	    } else {
		$fv = $form->{$clef}->{v}->[2].
		      "undef".
		      $form->{$clef}->{v}->[3];
		$fv = &juste(cha=>$fv,lon=>$form->{$clef}->{v}->[0],
			     jus=>$form->{$clef}->{v}->[1],tri=>0);
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
	$$res[0] = $$res[0].&juste(cha=>$compok[$i],tri=>0,lon=>$lk);
	$$res[1] = $$res[1].&juste(cha=>$compov[$i],tri=>0,lon=>$lk);
    }
} else {
    $res = [];
    for (my $i=0; $i < scalar @compok; $i++) {
	$$res[$i] = $compok[$i].$compov[$i];
    }
}
$res;
}
#############################################
#
##<<
sub clean8string {
    #
    # title : removes spacing and more into a string
    #
    # aim: from a reference to an array of strings
    #      returns it after some processing about spaces and
    #      comments to each of its components. Actions follow
    #      the presentation order of the arguments.
    #      Be aware that when a line is splitted due
    #         to the existence of a separator,
    #         additionnal components are introduced.
    #
    # output: a reference to an array of strings
    #
    #
# arguments
my $hrsub = {str =>[undef,"ac","The reference to an array of strings to modify"],
             sep =>[undef,"cu","Separator when some lines must be splitted",
                              "'undef' means no splitting"],
	     dbl =>[    1,"n","Transforms multiple spaces into unique spaces"],
	     spa =>[    3,"n","0: nothing, 1: remove starting spaces,",
			      "2: remove trailing spaces, 3: 1+2."],
	     co1 =>[  "#","uc","If defined, any string starting with it is reduced to ' '"],
	     co2 =>[ "##","uc","If defined, only the part of the string before it is retained"],
	     nun =>[    1,"n","Must the space components be removed?"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my %argu = %{$argu};
my $stri = $argu{str};
my $dble = $argu{dbl};
my $spac = $argu{spa};
my $com1 = $argu{co1};
my $com2 = $argu{co2};
my $nunu = $argu{nun};
my $sese = $argu{sep};
# initialization
my @res = @$stri;
my $res = \@res;
# splitting
if (defined($sese)) {
    my @stri = @res;
    $res = [];
    foreach my $ss (@stri) {
        my @resu = split($sese,$ss);
        push @$res,@resu;
    }
}
# multiple spaces
if ($dble) { foreach my $comp (@$res) {
    $comp =~ s/\s+/ /g;
}}
# removing trailing spaces
if ($spac>0) { foreach (@$res) {
    # removing at the beginning
    if (($spac==1) or ($spac==3)) {
	$_ =~ s/^\s+//;
    }
    # removing at the end
    if ($spac>1) {
	$_ =~ s/\s+$//;
    }
}}
# taking care of the comments
if (defined($com1)) {
    foreach my $comp (@$res) {
	if ($comp =~ /^$com1/) {
	    $comp = " ";
	}
    }
}
if (defined($com2)) { 
    foreach my $comp (@$res) {
	my @morceau = split $com2,$comp;
	if (scalar(@morceau)>0) {
	    $comp = $morceau[0];
	}
    }
}
# removing space components
if ($nunu) { for (my $ii = scalar(@$res)-1; $ii >= 0; $ii--) {
    if (defined($res->[$ii])) {
	if ($res->[$ii] =~ /^\s*$/) {
	   splice(@$res,$ii,1);
	}
    } else {
	splice(@$res,$ii,1);
    }
}}
# returning
if (ref($stri) ne "ARRAY") {
    $res = $$res[0];
}
$res;
}
#############################################
#
##<<
sub extract8string {
    #
    # title : extracting substrings from a string
    #
    # aim: from a string of characters extracts 
    #      substrings designated by some framing.
    #
    # output: a reference to the array of the found substrings
    #         (or a string in case of error when erro=0).
    #         The extracted substrings can be the framed ones
    #         (default) or their complementary ones. Be aware
    #         that framing sequences are never returned, 
    #         whatever be the choice.
    #
    #
# arguments
my $hrsub = {str =>[undef,"c","The string to extract from"],
	     enc =>[ ['[',"]"],"a","Must be of length two,",
				 "the framing pair of tags."],
	     wit =>[    1,"n","to return substrings within the",
			      "framing tags if no in between."],
	     err =>[    1,"n","In case of error (framing not closed),",
			      "0: returns a string with error",
			      "1: prints the error and stops"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my %argu = %{$argu};
my $stri = $argu{str};
my $enca = $argu{enc};
my $with = $argu{wit};
my $erro = $argu{err};
if (scalar(@$enca) != 2) {
    die("the 2d paramater of 'extract8string' must be ".
	"a reference to an array of length 2!");
}
# initialization
my $res = [];
# looking for the substrings in turn
my $style = 1; my $fra = $$enca[0];
my $ou; my $la;
while (length($stri) > 0) {
    my $ou = index($stri,$fra);
    if ($style) {
	# beginning search
	if ($ou < 0) {
	    # end of the search
	    if (!$with) { push @$res,$stri;}
	    $stri ="";
	} else {
	    # shortening the string
	    if (!$with) { push @$res,substr($stri,0,$ou-1);}
	    $stri = substr($stri,$ou+length($fra));
	}
	$style = 0;
	$fra = $$enca[1];
    } else {
	# closing search
	if ($ou < 0) {
	    # not found which is not consistent
	    my $err = "extract8string: a closing bracket (".$$enca[1].
		      ") was expected in <<".$stri.">>";
	    if ($erro) {
		die $err;
	    } else {
		return $err;
	    }
	} else {
	    if ($with) { push @$res,substr($stri,0,$ou);}
	    $stri = substr($stri,$ou+length($fra));
	}
	$style = 1;
	$fra = $$enca[0];
    }
}
# returning
$res;
}
#############################################
#
##<<
sub split8string {
    #
    # title : splitting a string in different ways
    #
    # aim: from a string of characters structured in some
    #      ways returns an array of individual locutions.
    #      It is basically as split except that separators
    #      can be included with framing. Typically analyzing
    #      strings like 'one two "three or four" five "6 7 8"'.
    #
    # output: a reference to the array of substrings
    #
    #
# arguments
my $hrsub = {str =>[undef,"c","The string to decompose"],
	     enc =>[ ['[',"]"],"au","When of length two the framing pair of locutions. Notice",
				 "that the opening and closing can be",
				 "identical. When 'undef' not used."], 
	     sep =>[ " ","c","Separator between locutions."],
	     cle =>[{dble=>1,spac=>3,com1=>undef,com2=>undef,nunu=>1},
			 "h","Parameters to give",
			      "to 'clean8string' when applied to each",
			      "extracted sub-string"],
	     err =>[    1,"n","In case of error (framing not closed),",
			      "0: returns a string with error",
			      "1: prints the error and stops"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my %argu = %{$argu};
my $stri = $argu{str};
my $enca = $argu{enc};
my $sepa = $argu{sep};
my $clea = $argu{cle};
my $erro = $argu{err};
# initialization
my $res = []; my $sstri = $stri;
## splitting
if (not(defined($enca))) { $enca = [$sepa,$sepa];}
# looking for the next break in turn
my $style = 1; my $fra = $$enca[0];
my $ou; my $la;
while (length($stri) > 0) {
    my $ou1 = index($stri,$sepa);
    my $ou2 = index($stri,$fra);
    if ($ou1+$ou2 == -2) {
	push @$res,$stri;
	$stri = "";
    } else {
	if ($style == 0) { $ou1 = length($stri);}
	if ($ou1 < 0) { $ou1 = length($stri);}
	if ($ou2 < 0) { $ou2 = length($stri);}
	if ($ou1 <= $ou2) {
	    # breaking with $sepa
	    $ou = $ou1; 
	    $la = length($sepa);
	} else {
	    # breaking with the frame
	    $ou = $ou2;
	    if ($style == 1) {
		$la = length($fra);
		$fra = $$enca[1];
		$style = 0;
	    } else {
		$la = length($fra);
		$fra = $$enca[0];
		$style = 1;
	    }
	}
	my $encore = 1;
	if ($ou == length($stri)) {
	    $ou--; $encore = 0;
	}
	push @$res,substr($stri,0,$ou);
	if ($encore) { 
	    $stri = substr($stri,$la+$ou);
	} else {
	    $stri = "";
	}
    }
}
if ($style != 1) {
    my $mist = "With framing given by ['".join("' & '",@$enca).
	       "'] framing was not closed for the string\n".
	       "<:$sstri:>! error found by &split8string";
    if ($erro) {
	die($mist);
    } else {
	return($mist);
    }
}
# cleaning the found sub-strings
$res = &clean8string(str=>$res,dbl=>$clea->{dble},
		     co1=>$clea->{com1},co2=>$clea->{com2},
		     spa=>$clea->{spac},nun=>$clea->{nunu});
# returning
$res;
}
#############################################
#
##<<
sub read8line {
    #
    # title : reading lines from a text file
    #
    # aim: reads a text file giving back its lines after some processing
    #               (removing comments, splitting and concatinating
    #                initial lines) in a variety of way according to the
    #                arguments). True lines can be splitted or concatanated.
    #      The processing of the file follows the order of the presentation
    #                of the arguments.
    #
    # output: either (typ=1) a reference to an array. One element of it
    #                    for each meaningful line of the file;
    #             or (typ=2) a reference to a hash. Its possible keys are
    #                    indicated by arguments plus (possibly) the special
    #                    word '$STD'. Except for '$STD', the keys can be found
    #                    as first word of lines, zero, one or more time. 
    #                    These keys (including '$STD') belongs to two categories
    #                    pointing to an array or to an hash. 
    #                    When it is an array, the remaining part of the line
    #                    is the content of one element of the array.
    #                    When it is a hash, the second word of the line is
    #                    one key (so must be unique) of the hash, the remaining
    #                    part being the value.
    #                    When '$STD' is not indicated, lines not starting
    #                    with an indicated key are ignored.
    #                    Empty lines are ignored not having a key.
    #                    Second level hashes can be completed with a special key
    #                    named '$ORD' refering to an array containing the other keys in 
    #                    the order they are in the file. The length of 
    #                    this array gives the dimension of the hash, especially
    #                    when it is null.
    #         When the file is not consistent, an error is returned with
    #                    an associated message.
    #         Be aware that some care must be taken when using characters having
    #               a special meaning in regular expressions... Particularly for the
    #               argument 'con' there is no mean to introduce '++'!
    #
# arguments
my $hrsub = {fil  =>[undef,"c","Name of the file to be read."],
             stp  =>["<STOP>","c","lines starting with it indicates that the",
                                  "following lines must be ignored until",
                                  "a restart line be found",
                                  "(remaining part of this line is ignored)."],
             str  =>["<START>","c","lines starting with it cancel the effect",
                                   "of a stopping line",
                                   "(remaining part of this line is ignored)."],
	     cl1  =>[{dbl=>1,spa=>3,co1=>"#",co2=>"##",nun=>1,sep=>";;"},
			  "h","The parameters to be transmitted",
			       "to 'clean8string' when applied to each",
			       "line of the file (see its documentation).",
                               "BE AWARE that if the default values are",
                               "used, you must provide the 6 values."],
	     con  =>[  "plus","uc","Lines starting with it are concatenated",
				 "to the previous one. When 'undef' no",
				 "concatenation is attempted."],
	     spl  =>[  ";;","uc","Lines are split according to it, allowing",
				 "to introduce more than one line at once.",
			       "When 'undef' no split is attempted."],
	     sep  =>[  " ","c","Separator used to determine the identifier of lines",
			       "when typ=2."],
	     cl2 =>[{dbl=>1,spa=>3,co1=>undef,co2=>undef,nun=>0},
			  "h","Parameters to give",
			       "to 'clean8string' when applied to each",
			       "remaining parts of the lines",
                               "so 'sep'arator argument is not used.",
                               "Be aware that when default is not used",
                               "the 5 components must be given even if",
                               "with default values."],
	     fio  =>[   "","c","Name of the file to write after pre-processing",
			       "containing only the meaningful lines. '' means",
			       "no such output."],
	     typ  =>[     1,"n","The type of analysis to perform: 0 nothing, [1-2]",
				"as explained in the general description."],
	     khh  =>[ {},"h","When typ=2, reference to a hash defining the keys",
			     "pointing to second level hashes. Its keys give the",
			     "specific keys to use and its values indicate if",
			     "an 'order' key must be added. The reserved key '$STD' must",
				"placed here to introduced lines not starting",
				"with a specific key. Notice that if it is the",
				"only key, all lines will be incorporated in",
				"it!"],
	     kha  =>[ [],"a","When typ=2, reference to an array defining the keys",
			     "pointing to arrays. The reserved key '$STD' must",
				"placed here to introduced lines not starting",
				"with a specific key. Notice that if it is the",
				"only key, the result is similar to the one",
				"obtained for typ=1"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my $fil = $argu->{fil};
my $stp = $argu->{stp};
my $str = $argu->{str};
my $cl1 = $argu->{cl1};
my $con = $argu->{con};
my $spl = $argu->{spl};
my $sep = $argu->{sep};
my $cl2 = $argu->{cl2};
my $fio = $argu->{fio};
my $typ = $argu->{typ};
my $khh = $argu->{khh};
my $kha = $argu->{kha};
#
# reading the file and practising the first framing
my $fic;
if (!open($fic,'<',$fil)) {
    my $err = &add8err(err=>"no",
		       nsu=>$nsub,
		       erm=>["file '$fil' cannot be openned ($!)"]);
    return($err);
}
my $res = [];
my $oui = 1; # read lines must be retained
while (<$fic>) {
    chomp $_;
    if ($_ =~ /^$stp/) { 
        # following lines must not be retained
        $oui = 0;
    } elsif ($_ =~ /^$str/) {
        # following lines must be retained
        $oui = 1;
    } else {
        if ($oui) {
            my $qq = &clean8string(str=>[$_],dbl=>$cl1->{dbl},sep=>$cl1->{sep},
                                   co1=>$cl1->{co1},co2=>$cl1->{co2},
                                   spa=>$cl1->{spa},nun=>$cl1->{nun});
            if (defined($$qq[0])) { push @$res,@$qq;}
        }
    }
}
#print8structure(str=>$res);pause(mes=>"LECTURE INITIALE");
# closing the file
close($fic);
# concatenating lines
if (defined($con)) {
    my @rr = ();
    my $lon = scalar @$res;
    my $i = -1;
    for (my $ii = 0; $ii < $lon; $ii++) {
	if ($$res[$ii]=~/^$con/) {
	    $rr[$i] = $rr[$i].substr($$res[$ii],length($con)); 
	} else {
	    $i++;
	    $rr[$i] = $$res[$ii];
	}
    }
    $res = [];
    foreach (@rr) {
	push @$res,$_;
    }
}
# splitting lines
if (defined($spl)) {
    my @rr = ();
    foreach (@$res) {
	my @morceau = split $spl;
	push @rr,@morceau;
    }
    $res = [];
    foreach (@rr) {
	push @$res,$_;
    }
}
# outputting a file
if ($fio ne "") {
    open(FIO,">".$fio) or die "read8line: cannot open > $fio: $!\n ";
    foreach (@$res) {
	print FIO $_,"\n";
    }
    close(FIO);
}
if ($typ == 0) {
    # nothing to do
    return undef;
} elsif ($typ == 1) {
    # a reference to an array of the lines
    my @rr = @$res;
    $res = [];
    foreach (@rr) {
	push @$res,$_;
    }
} elsif ($typ == 2) {
    # the keys
    my @khh = keys %$khh;
    # checking for non redundancy
    foreach (@khh) {
	my @che = &belong9(sca=>\$_,arr=>$kha);
	if (scalar(@che) > 0) {
	    print "<read8line>: the same keys were found for array and hash!\n";
	    print "    array: ",join("-",@$kha),"\n";
	    print "     hash: ",join("-",keys %$khh),"\n";
	    die("Not consistent!");
	}
    }
    # initialization
    my @rr = @$res;
    $res = {};
    foreach (@$kha) {
	$res->{$_} = [];
    }
    foreach (@khh) {
	$res->{$_} = {};
	if ($khh->{$_}) { $res->{$_}->{$ORD} = [];}
    }
    # loading line after line
    my $bon = 0; 
    foreach (@rr) {
	my @tk = split($sep,$_);
	if (scalar(@tk) > 0) {
	   my $tk = $tk[0];
	   # looking for the statute of the line
	   my $sl = ""; # not considered
	   if    (&belong9(sca=>\$tk,arr=> $kha)) { $sl = "ua"; } # keyword for array
	   elsif (&belong9(sca=>\$tk,arr=>\@khh)) { $sl = "uh"; } # keyword for hash
	   if ($sl eq "") {
	       if    (&belong9(sca=>\$STD,arr=> $kha)) {$sl = "sa";} # standard array
	       elsif (&belong9(sca=>\$STD,arr=>\@khh)) {$sl = "sh";} # standard hash
	   }
	   if (($sl eq "uh") and (scalar(@tk)==2)) { $sl = "";}
	   # adding the line in the structure
	   if ($sl eq "ua") {
	       # for a keyword array
	       splice(@tk,0,1); 
	       my $uk = join($sep,@tk);
	       $uk = &clean8string(str=>[$uk],         dbl=>$cl2->{dbl},
				   co1=>$cl2->{co1},co2=>$cl2->{co2},
				   spa=>$cl2->{spa},nun=>$cl2->{nun});
	       #if (defined($$uk[0])) { push $$res{$tk},@$uk;}
	       if (defined($$uk[0])) { push @{$$res{$tk}},@$uk;}
	   } elsif ($sl eq "sa") {
	       # for the standard array
	       my $uk = join($sep,@tk);
	       $uk = &clean8string(str=>[$uk],         dbl=>$cl2->{dbl},
				   co1=>$cl2->{co1},co2=>$cl2->{co2},
				   spa=>$cl2->{spa},nun=>$cl2->{nun});
	       #if (defined($$uk[0])) { push $$res{$STD},@$uk;}
	       if (defined($$uk[0])) { push @{$$res{$STD}},@$uk;}
	   } elsif ($sl eq "uh") {
	       # for a keyword hash
	       my $tkk = $tk[1];
	       if (defined($res->{$tk}->{$tkk})) {
		   $bon++;
		   print "key $tk[1] of $tk was found to be duplicated ($bon)\n";
	       } else {
		   splice(@tk,0,2);
		   $res->{$tk}->{$tkk} = join($sep,@tk);
		   if ($khh->{$tk}) {
		       $tkk = &clean8string(str=>[$tkk],        dbl=>$cl2->{dbl},
					    co1=>$cl2->{co1},co2=>$cl2->{co2},
					    spa=>$cl2->{spa},nun=>$cl2->{nun});
		       #if (defined($$tkk[0])) {push $res->{$tk}->{$ORD},$$tkk[0];}
		       if (defined($$tkk[0])) {push @{$res->{$tk}->{$ORD}},$$tkk[0];}
		   } 
	       }
	   } elsif ($sl eq "sh") {
	       if (defined($res->{$STD}->{$tk})) {
		   $bon++;
		   print "key $tk of '$STD' was found to be duplicated ($bon)\n";
	       } else {
		   splice(@tk,0,1);
		   $res->{$STD}->{$tk} = join($sep,@tk);
		   if ($khh->{$STD}) {
		       $tk = &clean8string(str=>[$tk],         dbl=>$cl2->{dbl},
					   co1=>$cl2->{co1},co2=>$cl2->{co2},
					   spa=>$cl2->{spa},nun=>$cl2->{nun});
		       #if (defined($$tk[0])) { push $res->{$STD}->{$ORD},$$tk[0];}
		       if (defined($$tk[0])) { push @{$res->{$STD}->{$ORD}},$$tk[0];}
		   } 
	       }
	   }
	}
    }
    if ($bon>0) {
	die("read8line: DUPLICATED KEYS ($bon times)");
    }
} else {
    die "read8line: typ = $typ but the possible values are 0|1|2";
}
# returning
$res;
}
#############################################
#
##<<
sub print8hmat {
    #
    # title : print (and check) a hash matrix
    #
    # aim : print what is called a hash matrix, that is
    #        a reference to a hash whose keys are associated
    #        to columns of a matrix and values are references
    #        to arrays providing the values of each columns.
    #        The lengths of the columns must be identical.
    #
    #       Possibly a special key '$uie::ORD' gives the order
    #        of the columns with an array containing the keys.
    #        When it exists, it is used.
    #
    #       In case of inconsistency '@$uie::sei' is completed
    #        with an appropriate message and the subroutines
    #        returns 0.
    #
    # output: 1 (or 0 in case of inconsistency).
    #
# arguments
my $hrsub = {
	     hma =>[undef,"h","The structure to be printed"],
	     wid =>[   10,"n","Width to give to each column"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my $hmat = $argu->{hma};
my $widt = $argu->{wid};
# some checking
my $nbco = scalar(keys %$hmat);
my $nbli = -1;
my @kk = keys(%$hmat);
foreach (keys %$hmat) {
    if ($_ eq $ORD) {
	$nbco--; 
	my $check = &check8ref(ref=>$hmat->{$_},typ=>"a",rlo=>[$nbco,$nbco]);
	if (!$check) {
	    push @$sei,"print8hmat: array $ORD has got a length different of $nbco",
		       "or is not a reference to an array",
		       "(".join("|",keys %$hmat).")";
	    return 0;
	}
	my @hh = (@{$hmat->{$_}},$ORD);
	$check = &compare8set(se1=>\@hh,se2=>\@kk);
	if (scalar(@$check) > 0) {
	    push @$sei,'print8hmat: values of $ORD differ form the keys of $hmat',
		       "hmat: (".join("|",keys %$hmat).")",
		       " ORD: (".join("|",@{$hmat->{$ORD}}).")";
	    return 0;
	}
	@kk = @{$hmat->{$_}};
    } else {
	if ($nbli < 0) {
	    my $check = &check8ref(ref=>$hmat->{$_},typ=>"a");
	    if (!$check) {
		push @$sei,"print8hmat: the key $_ of hmat is not a reference to an array";
		return 0;
	    }
	    $nbli = scalar(@{$hmat->{$_}});
	} else {
            #print "$_ :: $nbli & ",scalar(@{$hmat->{$_}})," ::\n";
	    my $check = &check8ref(ref=>$hmat->{$_},typ=>"a",rlo=>[$nbli,$nbli]);
	    if (!$check) {
		push @$sei,"print8hmat: array $_ has got a length different of $nbli",
			   "or is not a reference to an array";
		return 0;
	    }
	}
    }
}
# printing the column names
foreach (@kk) {
    print &juste(cha=>$_,jus=>"C",lon=>$widt);
}
print "\n";
foreach (@kk) {
    my $sou = "-" x ($widt -2);
    print &juste(cha=>$sou,jus=>"C",lon=>$widt);
}
print "\n";
# printing the line values
for (my $ii = 0;$ii < $nbli; $ii++) {
    foreach (@kk) {
	print &juste(cha=>$hmat->{$_}->[$ii],jus=>"R",lon=>$widt);
    }
    print "\n";
}
# returning
return 1;
}
#############################################
#
##<<
sub read8csv {
    #
    # title : reading a CSV file
    #
    # aim: read a Coma Separated Values file whose first line
    #               gives the names of the columns
    #
    # remarks: - Every line must count the same number of separators
    #            which is the number of columns minus one. Empty
    #            values are possible.
    #          - Of course empty names of columns are prohibited.
    #
    # output: a reference to a hash whose keys are the column
    #         names and the values are references associated
    #         to arrays of the columns (first line being removed).
    #         But when an inconsistence is detected, the output
    #         is an error object.
    #
# arguments
my $hrsub = {csv  =>[undef,"c","Name of the CSV file to extract",],
	     sep  =>[  ";","c","Separator between fields within each line."],
	     com  =>[  "#","c","Starting characters of comment lines to be ignored."]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my $csv = $argu->{csv};
my $sep = $argu->{sep};
my $com = $argu->{com};
#
# reading the file eliminating the comment lines
sub compte {
    my $chaine = shift @_;
    my $sss = shift @_;
    my $chai = $chaine;
    $chai =~ s/$sss//g;
    1 + length($chaine)-length($chai);
}
my $fic;
if (!open($fic,'<',$csv)) {
    my $err = &add8err(err=>"no",
		       nsu=>$nsub,
		       erm=>["file '$csv' cannot be openned ($!)"]);
    return($err);
}
my $res = {};
my $nblig = -1; my $nbcol; my @cname;
while (<$fic>) {
    chomp $_;
    if ($_ !~ /^$com/) {
	$nblig++;
	if ($nblig == 0) {
	    # it is the first line with column names
            $nbcol = &compte($_,$sep);
	    @cname = split($sep,$_);
	    if ($nbcol != @cname) {
                $res = &uie::add8err(nsu=>$nsub,err=>"no",
                                     erm=>["Something wrong in the definition of the column names",
                                           "$_",
                                           "The number of values returned by 'split' does not fit",
                                           "with the number of separator ($sep)",
                                           "Some trailing separator left?"]);
                return($res);
            }
	    for (my $i=0; $i < $nbcol; $i++) {
		$cname[$i] = &juste(cha=>$cname[$i],lon=>-1);
		$res->{$cname[$i]} = [];
	    }
	    if ($nbcol != (keys %$res)) {
                $res = &uie::add8err(nsu=>$nsub,err=>"no",
                                     erm=>["Something wrong in the definition of the column names",
                                           "$_",
                                           "It seems that at least one name was given at least twice!"]);
                return($res);
            }
	} else {
	    # it is a line supposed to get values
            # as Perl seems to delete empty last fields, 
            # I added an ugly trick :+((
            my $laid = $_."Z";
	    my @cvalu = split(/$sep/,$laid);
            $cvalu[-1] = substr($cvalu[-1],0,-1);
	    if (@cvalu != $nbcol) {
		my $err = &add8err(err=>"no",
				   nsu=>$nsub,
				   erm=>["Value line number $nblig of file $csv",
					 "\"$_\"",
					 "has got ".scalar(@cvalu)." values and",
					 "doesn't have $nbcol values",
					 "as asked with column names",
					 "\"".join(" $sep ",@cname)."\""]);
		return($err);
	    } else {
		for (my $i = 1; $i <= $nbcol; $i++) {
		    $res->{$cname[$i-1]}->[$nblig-1] = &juste(cha=>$cvalu[$i-1],lon=>-1);
		}
	    }
	}
    }
}
close($fic);
# returning
$res;
}
#############################################
#
##<<
sub write8csv {
    #
    # title : writing a CSV file
    #
    # aim: write a csv file from an hash.
    #            Its keys will be the names of the csv columns,
    #            Associated values must be references to arrays
    #            having the same number of components: the values
    #            for the csv table to write into a file
    #
    # output: 1 if everything was fine and error which can be 
    #           filtred with &check8err.
    #
# arguments
my $hrsub = {str  =>[undef,"h","hash to be written as a CSV file"],
             csv  =>[undef,"c","Name of the CSV file to write"],
	     sep  =>[  ";","c","Separator between fields within each line."]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my $str = $argu->{str};
my $csv = $argu->{csv};
my $sep = $argu->{sep};
my $res = 1;
# checking the consistency of the hash
my $nbe = -1;
foreach (keys %$str) {
    unless (&uie::check8ref(ref=>$str->{$_},typ=>"a")) {
        my $err = &add8err(err=>"no",
                           nsu=>$nsub,
		           erm=>["Some component of the hash is not array reference"]);
        return($err);
    }
    if ($nbe < 0) { $nbe = scalar(@{$str->{$_}});}
    else {
        if ( scalar(@{$str->{$_}}) != $nbe ) {
	    my $err = &add8err(err=>"no",
			       nsu=>$nsub,
			       erm=>["array are not with identical length"]);
	    return($err);
        }
    }
}
# opening the file
my $fic;
if (!open($fic,'>',$csv)) {
    my $err = &add8err(err=>"no",
		       nsu=>$nsub,
		       erm=>["file '$csv' cannot be openned ($!)"]);
    return($err);
}
# writing the table
my @cles = keys %$str;
print $fic join($sep,@cles),"\n";
for (my $ii = 0 ; $ii < $nbe ; $ii++) {
    my @vale = ();
    foreach (@cles) { push @vale,$str->{$_}->[$ii];}
    my $ligne = join($sep,@vale);
    print $fic $ligne,"\n";
}
# closing the file
close $fic;
# returning
$res;
}
#############################################
#
##<<
sub dim4csv {
    #
    # title : returns the dimensions of a csv table
    #
    # aim: from reference to a matrix as obtained with
    #      'read8csv', returns its dimensions.
    #
    # output: a reference to an array of length 2 with
    #         the number of lines et the number of columns
    #         '[nblig,nbcol]'.
    #
# arguments
my $hrsub = {mat  =>[undef,"h","The matrix, as returned by 'read8csv'"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my $mat = $argu->{mat};
#
# getting the names of the columns
my @colnam = keys %$mat;
my $nbcol = scalar @colnam;
my $nblig = 0;
if ($nbcol > 0) {
    $nblig = scalar(@{$$mat{$colnam[0]}});
}
# returning
[$nblig,$nbcol];
}
#############################################
#
##<<
sub line4csv {
    #
    # title : returns one line of a csv table
    #
    # aim: from reference to a matrix as obtained with
    #      'read8csv', returns a line defined by its
    #      number?
    #
    # output: a reference to a hash whose keys are
    #         the column names of the matrix and the
    #         values, those of the asked line.
    #
# arguments
my $hrsub = {mat  =>[undef,"h","The matrix, as returned by 'read8csv'"],
	     lin  =>[    1, "n","The number of the line to extract.",
				"Be Aware that the first line is number 1",
				"not following Perl standard conventions!"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my $mat = $argu->{mat};
my $lin = $argu->{lin};
# some checking
my $nlm = &dim4csv(mat=>$mat)->[0];
if ($nlm < $lin) {
    print("$nsub: line number $lin was asked BUT\n",
	  "          there are only $nlm lines!\n");
    die("Considered as a fatal error");
}
if ($lin < 1) {
    print("$nsub: line number $lin was asked BUT\n",
	  "          line numbering is starting from ONE!\n",
	  "          NOT FOLLOWING *PERL* conventions...\n");
    die("Considered as a fatal error");
}
# getting the names of the columns
my @colnam = keys %$mat;
my $res = {};
foreach (@colnam) {
    $res->{$_} = ${$mat->{$_}}[$lin-1];
}
# returning
$res;
}
#############################################
#
##<<
sub err9 {
    #
    # title : detecting an error object
    #
    # aim: detecting an error object if the first argument
    #      is reference to a non empty array whose first
    #      component is '$uie::err_ide'.
    #
    # output: 1 if it is, 0 otherwise.
    #
# arguments
my $hrsub = {obj  =>[undef,'uhasrnc',"Possible error object"]
	    };
##>>
my $nsub = (caller(0))[3];
my $argu   = &argu($nsub,$hrsub,@_);
my $obj = $argu->{obj};
# checking
if (ref($obj) ne "ARRAY")   { return(0);}
if (scalar(@$obj) == 0)     { return(0);}
if ($obj->[0] ne $err_ide) { return(0);}
# returning
1;
}
#############################################
#
##<<
sub add8err {
    #
    # title : creating and/or adding error messages
    #
    # aim: adding, possibly for the first time in that
    #      case it is also a creation, some error messages
    #      to an error object
    #      See also &conca8err      
    #
    # output: the increased error object
    #
# arguments
my $hrsub = {err => [undef,'ac',"Error object, give a string if it is a creation"],
	     nsu => [undef,'c',"Identification string,",
			       "usually the name of the calling subroutine"],
	     erm => [undef,'a',"The error message"]
	    };
##>>
my $nsub = (caller(0))[3];
my $argu   = &argu($nsub,$hrsub,@_);
my $err = $argu->{err};
my $nsu = $argu->{nsu};
my $erm = $argu->{erm};
my @res;
# creation
if (!&err9(obj=>$err)) { 
    @res = ($err_ide);
} else {
    @res = @$err;
}
# addition
foreach (@$erm) {
    @res = (@res,$nsu.$err_ide.$_);
}
# returning
\@res;
}
#############################################
#
##<<
sub conca8err { 
    #
    # title : concatanating two error objects
    #         (formerly 'cum8err')
    #
    # aim: to cumulate a new error with older ones
    #      null error are accepted.
    #      See also &add8err      
    #
    # output: the created error object
    #
# arguments
my $hrsub = {er1 => [undef,'ac',"Initial error object"],
	     er2 => [undef,'ac',"Error object to cumulate at the end"]
	    };
##>>
my $nsub = (caller(0))[3];
my $argu   = &argu($nsub,$hrsub,@_);
my $er1 = $argu->{er1};
my $er2 = $argu->{er2};
# initialization
my $res;
# creation
if (&err9(obj=>$er1)) { 
    # error 1 is not empty
    $res = $er1;
    if (&err9(obj=>$er2)) {
	# concatanation must be done
	my $i = -1;
	foreach (@$er2) {
	    $i++;
	    if ($i > 0) {
		@$res = (@$res,$_);
	    }
	}
    }
} else {
    # error 1 is empty
    $res = $er2;
}
# returning
$res;
}
#############################################
#
##<<
sub print8err {
    #
    # title : printing an error object
    #
    # aim: prints the first argument to be
    #      supposed an error object when it is
    #      not the case, nothing is printed.
    #
    # output: 1
    #
# arguments
my $hrsub = {err => [undef,'ac',"Error object to print"]
	    };
##>>
my $nsub = (caller(0))[3];
my $argu   = &argu($nsub,$hrsub,@_);
my $err = $argu->{err};
# creation
if (&err9(obj=>$err)) { 
    my $nu = 0; my $para = $err_ide;
    foreach (@$err) {
	if ($nu > 0) {
	    my @erro = split($err_ide,$_);
	    if ($erro[0] ne $para) {
		$para = $erro[0];
		print " "x3,"-"x10,"<$para>\n";
	    }
	    if (defined($erro[1])) {print " "x20,$erro[1],"\n";}
	}
	$nu++;
    }
}
# returning
1;
}
#############################################
#
##<<
sub check8err {
    #
    # title : check for an error object
    #
    # aim: when an error object, prints it and
    #      possibly die.
    #
    # output: the checked object if it is not an error
    #
# arguments
my $hrsub = {obj => [undef,'uhasrnc',"Possible error object"],
             wha => [    0,'n',"When '0' dies in case of error",
                               "When '1' returns the error message"],
             sig => [   "","c","A signature to add when printing the error"]
	    };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &argu($nsub,$hrsub,@_);
    my $obj = $argu->{obj};
    my $wha = $argu->{wha};
    my $sig = $argu->{sig};
    # creation
    if (&err9(obj=>$obj)) { 
        if ($sig ne "") {
            print (" "x20,"<<<<<\n");
            print (" "x25,"ERROR DETECTED IN $sig\n");
            print (" "x20,">>>>>\n");
        }
        print8err(err=>$obj);
        unless($wha) { exit;}
    }# returning
    $obj;
}
#############################################
#
##<<
sub replace8string {
    #
    # title : replaces keywords into a string
    #
    # aim: from a string (or a reference to an array of strings)
    #      returns it after replacement of keywords with
    #      given values.
    #      Remark: when giving values to the two tags ('bef' and 'aft')
    #              don't forget to backslash special characters of
    #              Perl substitution!
    #              Special characters are : . * ? + [ ] ( ) { } ^ $ | \
    #              A good choice could be '<<' and '>>' 
    #                another one '#_' and '_#'.
    #
    # output: a string (or a reference to an array of strings)
    #
    #
# arguments
my $hrsub = {str =>[undef,"ca","The string (or reference to an array of strings) to modify"],
	     kwd =>[undef,"h","Reference to the hash giving the replacements to performs.",
			      "Key of the hash are replaced by the associated value."],
	     bef =>["","c","tag to add before the value to be replaced."],
	     aft =>["","c","tag to add before the value to be replaced."]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my %argu = %{$argu};
my $str = $argu{str};
my $kwd = $argu{kwd};
my $bef = $argu{bef};
my $aft = $argu{aft};
# initialization
my $res;
if (ref($str) eq "ARRAY") {
    my @res = @$str;
    $res = \@res;
} else {
    $res = [$str];
}
# replacing
foreach my $cle (keys %$kwd) {
    my $val = $$kwd{$cle};
    my $clf = $bef.$cle.$aft;
    foreach my $chai (@$res) {
	#$chai =~ s/\Q$clf\E/\Q$val\E/g;
	#$chai =~ s/$clf/$val/g;
	$chai =~ s/\Q$clf\E/$val/g;
    }
}
# returning
if (ref($str) ne "ARRAY") {
    $res = $$res[0];
}
$res;
}
#############################################
#
##<<
sub spec2html {
    #
    # title : replace special characters with html (or reduced) coding
    #
    # aim: from a string (or a reference to an array of strings)
    #      returns it after replacement of é, è, ô, ç, ï,...
    #      in standard ascii html coding or standard ascii 
    #      characters compatible for file names (as a consequence
    #      spaces are replaced with underscores.
    #
    #      Use is made of subroutine 'replace8string
    #
    # output: a string (or a reference to an array of strings)
    #
    #
# arguments
my $hrsub = {str =>[undef,"ca","The string (or reference to an array of strings) to modify"],
             htm =>[    1,"n","1: replacement made with html coding",
                              "2: (and 0 for historical reason), simplification keeping '/'",
                              "3: simplification replacing '/' with '-'"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my %argu = %{$argu};
my $str = $argu{str};
my $htm = $argu{htm};
if ($htm == 0) { $htm = 2;}
# coding
my $coht = {
            "€"=>"&euro;",
	    "À"=>"&Agrave;",
	    "Ù"=>"&Ugrave;",
	    "È"=>"&Egrave;",
	    "É"=>"&Eacute;",
	    "à"=>"&agrave;",
	    "ù"=>"&ugrave;",
	    "è"=>"&egrave;",
	    "é"=>"&eacute;",
	    "Â"=>"&Acirc;",
	    "Ê"=>"&Ecirc;",
	    "Î"=>"&Icirc;",
	    "Ô"=>"&Ocirc;",
	    "Û"=>"&Ucirc;",
	    "Ä"=>"&Auml;",
	    "Ë"=>"&Euml;",
	    "Ï"=>"&Iuml;",
	    "Ö"=>"&Ouml;",
	    "Ü"=>"&Uuml;",
	    "â"=>"&acirc;",
	    "ê"=>"&ecirc;",
	    "î"=>"&icirc;",
	    "ô"=>"&ocirc;",
	    "û"=>"&ucirc;",
	    "ä"=>"&auml;",
	    "ë"=>"&euml;",
	    "ï"=>"&iuml;",
	    "ö"=>"&ouml;",
	    "ü"=>"&uuml;",
	    "Ç"=>"&Ccedil;",
	    "ç"=>"&ccedil;",
	    "°"=>"&deg;",
	    "œ"=>"&oelig;"
	   };
my $cosi = {" "=>"_",
            ";"=>".",
            ","=>".",
            "'"=>"-",
            "("=>"-",
            ")"=>"-",
            "["=>"-",
            "]"=>"-",
            "{"=>"-",
            "}"=>"-",
            "<"=>"-",
            ">"=>"-",
            "&"=>"-",
            "€"=>"E",
            "À"=>"A",
            "Ù"=>"U",
            "È"=>"E",
            "É"=>"E",
            "à"=>"a",
            "ù"=>"u",
            "è"=>"e",
            "é"=>"e",
            "Â"=>"A",
            "Ê"=>"E",
            "Î"=>"I",
            "Ô"=>"O",
            "Û"=>"U",
            "Ä"=>"A",
            "Ë"=>"E",
            "Ï"=>"I",
            "Ö"=>"o",
            "Ü"=>"U",
            "â"=>"a",
            "ê"=>"e",
            "î"=>"i",
            "ô"=>"o",
            "û"=>"u",
            "ä"=>"a",
            "ë"=>"e",
            "ï"=>"i",
            "ö"=>"o",
            "ü"=>"u",
            "Ç"=>"C",
            "ç"=>"c",
            "°"=>"o",
            "œ"=>"oe",
            "æ"=>"ae"
           };
my $codi = $coht;
if ($htm > 1) { $codi = $cosi;}
if ($htm > 2) { $codi->{"/"} = "-";}
# replacing
$str = &replace8string(str=>$str,kwd=>$codi);
# last precaution
my $res;
if (ref($str) eq "ARRAY") {
    my @res = @$str;
    $res = \@res;
} else {
    $res = [$str];
}
foreach my $chai (@$res) {
    $chai  =~ s/[[:^ascii:]]/!/g;
}
# returning
if (ref($str) ne "ARRAY") {
    $res = $$res[0];
}
$res;
}
#############################################
#
##<<
sub text2html {
    #
    # title : transforms a text into an html version
    #
    # aim: from a reference to an array of strings
    #      returns it after introducing some html tags.
    #      (For convenience in a paragraph context, an empty line 
    #       is considered as a paragraph separator).
    #      See also 'spec2html'
    #
    # output: a reference to an array of strings
    #
    # remarks: (1) when choosing new values for tags be aware that
    #              the special characters: . * ? + [ ] ( ) { } ^ $ | \
    #              will cause troubles!
    #          (2) when some html formatting is not available
    #              there is no harm in introducing it by hand.
    #              For instances :
    #                   <strong> What to remember: </strong>
    #                   <ol><li>Premier</li><li>Second</li></ol>
    #
# arguments
my $hrsub = {str =>[undef,"ca","The string (or reference to an array of strings) to translate"],
	     tit =>["Generated with 'uie'","c","Title to give to the generate page."],
	     b8c =>[1    ,"n","Indicates if beginning and closing tags of the page",
			      "must be included."],
	     pse =>["<>" ,"c","Lines starting with it start a new paragraph:",
			      "close the previous tag and open a new paragraph.",
                              "Also when a paragraph comprises an empty line,",
                              "it is interpreted as the start of a new paragraph.",
                              "Also the default value when no tag is a new paragraph."],
	     lig =>["<->","c","Lines starting with it start a new paragraph after",
			      "introduction of an horizontal rule"],
	     hdo =>[  "<","c","Opening of headings."],
	     hdc =>[  ">","c","Closing of headings",
                              "(with defaults lines starting with '<#>'",
                              " are interpreted as heading # only when",
                              " # belongs to 1..6!)."],
	     bul =>["<o>","c","Lines starting with it are item lines"],
	     nul =>["<#>","c","Lines starting with it are numbered lines"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my %argu = %{$argu};
my $tit = $argu{tit};
my $b8c = $argu{b8c};
my $str = $argu{str};
my $pse = $argu{pse};
my $lig = $argu{lig};
my $hdo = $argu{hdo};
my $hdc = $argu{hdc};
my $bul = $argu{bul};
my $nul = $argu{nul};
# initializing
my $hd1 = $hdo."1".$hdc;
my $hd2 = $hdo."2".$hdc;
my $hd3 = $hdo."3".$hdc;
my $hd4 = $hdo."4".$hdc;
my $hd5 = $hdo."5".$hdc;
my $hd6 = $hdo."6".$hdc;
my %tps = (pse=>$pse,
	   lig=>$lig,
	   hd1=>$hd1,hd2=>$hd2,hd3=>$hd3,
	   hd4=>$hd4,hd5=>$hd5,hd6=>$hd6,
	   bul=>$bul,
	   nul=>$nul);
my $res = [];
# tag construction: 
my $debt = {non=>"",pse=>"</p>",
            hd1=>"</h1>",hd2=>"</h2>",hd3=>"</h3>",
            hd4=>"</h4>",hd5=>"</h5>",hd6=>"</h6>",
            bua=>"</li>",bul=>"</li>",buz=>"</li></ul>",
            nua=>"</li>",nul=>"</li>",nuz=>"</li></ol>"};
#
my $fint = {non=>"",pse=>"<p>",
            hd1=>"<h1>",hd2=>"<h2>",hd3=>"<h3>",
            hd4=>"<h4>",hd5=>"<h5>",hd6=>"<h6>",
            bua=>"<ul><li>",bul=>"<li>",buz=>"<li>",
            nua=>"<ol><li>",nul=>"<li>",nuz=>"<li>"};
#
my $lata = {non=>"</p>",pse=>"</p>",
            hd1=>"</h1>",hd2=>"</h2>",hd3=>"</h3>",
            hd4=>"</h4>",hd5=>"</h5>",hd6=>"</h6>",
            bul=>"</li></ul>",nul=>"</li></ol>"};
    # starting
    if ($b8c) {
	push (@$res,'<html>',' <head>');
	push (@$res,'  <meta http-equiv="content-type" content="text/html; charset=UTF-8">',
		    '  <meta name="creation" content="'.&uie::now(wha=>"d").'">',
		    "  <title>$tit</title>",
		    '  <meta http-equiv="charset" content="utf8">');
	push (@$res,' </head>','<body>');
    }
    ## translating
    my $lta = "non"; my $pl = 1; my $deco = "";
    #
    my @stri;
    if (ref($str) ne "ARRAY") {
        @stri = ($str);
    } else {
        @stri = @$str;
    }
    my $prem = 1;
    foreach my $li (@stri) {
        my $quoi = "";
        # looking for the line type
        my $ltc = "non"; 
        foreach (keys %tps) {
            my $tag = $tps{$_};
            if ($li =~ /^$tag/) { $ltc = $_;}
        }
        # new paragraph at first
        if ( $prem and ($ltc eq "non")) { $ltc = "pse";}
        $prem = 0;
        # starting the job accordingly
        my $lt1 = $lta; my $lt2 = $ltc;
        if ($ltc ne "non") {
            # removing the starting tag
            if ($li =~ /^$tps{$ltc}/) {
                $li = substr($li,length($tps{$ltc}));
            }
        } elsif ($pl == 1) {
            $lt2 = "pse";
        }
        if ($lt2 eq "lig") {
            $deco = "lig";
            $lt2 = "pse"; $ltc = "pse";
        }        
        if (($lta eq "pse") and ($li =~ /^ *$/)) {
            $lt2 = "pse"; $ltc = "pse";
        }
        # dealing with first and last items
        if (($lt2 eq "bul") and  ($lt1 ne "bul") and ($lt1 ne "bua")) { $lt2 = "bua";}
        if (($lt2 ne "bul") and (($lt1 eq "bul") or ($lt1 eq "bua"))) { $lt1 = "buz";}
        #
        if (($lt2 eq "nul") and  ($lt1 ne "nul") and ($lt1 ne "nua")) { $lt2 = "nua";}
        if (($lt2 ne "nul") and (($lt1 eq "nul") or ($lt1 eq "nua"))) { $lt1 = "nuz";}
        $pl = 0;
        # introducing the possible decoration
        if ($deco eq "lig") {
            $deco = "<hr>";
        }
        # introducing the corresponding tag
        if ($lt2 ne "non") { $quoi = $debt->{$lt1}.$deco.$fint->{$lt2};}
        if ($quoi ne "") {
            # adding the tag line
            push (@$res,$quoi);
            # changing the old tag with the new one
            $lta = $ltc;
        }
        $deco = "";
        # adding the text
        if (defined $li) {push (@$res,$li);}
    }
    # closing the last tag
    #if (($lta eq "bul") or ($lta eq "bua")) { $lta = "buz";}
    #if ((not(defined($lata->{$lta})))) {print "lta = ",$lta," lata = UNDEF\n";&uie::pause()}
    push (@$res,$lata->{$lta});
    # closing the html page
    if ($b8c) {
        push (@$res,'</body>','</html>');
    }
    # returning
    $res;
}
#############################################
#
##<<
sub make8eml {
    #
    # title : builds an electronic message for 'sendmail'
    #
    # aim: from the different parts of a message, builds
    #      a text file supposed to satisfy the MIME format
    #      possibly comprising attached files transformed
    #      into base64 code. 
    #      Notice that the message must comprise at least
    #      one part and that they are introduced in the order
    #      of the description of the arguments. Also the
    #      list of main recipients cannot be empty.
    #
    # output: the output is stored into a file and returns 1.
    #         BUT if something wrong no creation of file and
    #         an error object is returned.
    #         
    #
    #
    # arguments
    my $hrsub = {fil =>[undef,"c","Name of the file to create or replace"],
                 sbj =>[undef,"c","Subject of the mail"],
                 tow =>[undef,"ca","The string (or reference to an array of strings)",
                                   "giving the recipients of the message"],
                 cco =>["","ca","The string (or reference to an array of strings)",
                                   "giving the recipients for information of the message;",
                                   "'' which is the default value means none of them."],
                 bcc =>["","ca","The string (or reference to an array of strings)",
                                   "giving the hidden recipients of the message",
                                   "'' which is the default value means none of them."],
                 txt =>["","ca","The string (or reference to an array of strings)",
                                   "giving the series of files to be included as plain",
                                   "text parts of the message;",
                                   "'' which is the default value means none of them."],
                 htm =>["","ca","The string (or reference to an array of strings)",
                                   "giving the series of files to be included as html",
                                   "parts of the message; they are supposed to include",
                                   "the necessary tags (which can be done with 'text2html';",
                                   "'' which is the default value means none of them."],
                 b64 =>["","ca","The string (or reference to an array of strings)",
                                   "giving the series of files to be included after encoding",
                                   "in base64 format (images, pdf,...);",
                                   "'' which is the default value means none of them."],
                 chs =>[$char_set,"c","Specification of the character set to be used in",
                                      "text and html messages"]
                };
##>>
    my $nsub = (caller(0))[3]; 
    my $argu   = &argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my %argu = %{$argu};
    my $fil = $argu{fil};
    my $sbj = $argu{sbj};
    my $tow = $argu{tow};
    my $cco = $argu{cco};
    my $bcc = $argu{bcc};
    my $txt = $argu{txt};
    my $htm = $argu{htm};
    my $b64 = $argu{b64};
    my $chs = $argu{chs};
    # initialization
    my $err = "no"; my $res;
    my $ntp = 0; my $nhp = 0; my $nbp = 0;
    # constituting the lists of main recipients
    if (ref($tow) ne "ARRAY") { $tow = [$tow];}
    my $etow = 0;
    if (scalar($tow) == 0) { $etow = 1;}
    elsif ($tow->[0] eq "") { $etow = 1;}
    if ($etow) {
         $err = &add8err(err=>$err,nsu=>$nsub,erm=>
                         ["AT LEAST ONE MAIN RECIPIENT must be provided"]);
    }
    $tow = join(",",@$tow);
    # constituting the lists of cc recipients 
    if (ref($cco) ne "ARRAY") { $cco = [$cco];}
    if (scalar($cco) == 0) { $cco = undef;}
    elsif ($cco->[0] eq "") { $cco = undef;}
    else { $cco = join(",",@$cco);}
    # constituting the lists of hidden recipients 
    if (ref($bcc) ne "ARRAY") { $bcc = [$bcc];}
    if (scalar($bcc) == 0) { $bcc = undef;}
    elsif ($bcc->[0] eq "") { $bcc = undef;}
    else { $bcc = join(",",@$bcc);}
    # checking the list of text parts of the message
    if (ref($txt) ne "ARRAY") {
        if ($txt =~ /^(\s)*$/) { $txt = [];}
        else { $txt = [$txt];}
    }
    foreach (@$txt) {
        $ntp++;
        unless (-e $_) {
            $err = &add8err(err=>$err,nsu=>$nsub,
                               erm=>["text file <$_> [number $ntp] is not found"]);
        }
    }
    # checking the list of html parts of the message
    if (ref($htm) ne "ARRAY") {
        if ($htm =~ /^(\s)*$/) { $htm = [];}
        else { $htm = [$htm];}
    }
    foreach (@$htm) {
        $nhp++;
        unless (-e $_) {
            $err = &add8err(err=>$err,nsu=>$nsub,
                               erm=>["html file <$_> [number $nhp] is not found"]);
        }
    }
    # checking the list of parts of the message to be encoded
    if (ref($b64) ne "ARRAY") {
        if ($b64 =~ /^(\s)*$/) { $b64 = [];}
        else { $b64 = [$b64];}
    }
    foreach (@$b64) {
        $nbp++;
        unless (-e $_) {
            $err = &add8err(err=>$err,nsu=>$nsub,
                            erm=>["to be encoded file <$_> [number $nbp] is not found"]);
        }
    }
    # checking that the message will not be empty
    if ($ntp+$nhp+$nbp == 0) {
            $err = &add8err(err=>$err,nsu=>$nsub,
                            erm=>["NO ONE FILE proposed for the message"]);
    }
    if (&err9(obj=>$err)) {
        # no way to make the mail
        $res = $err;
    } else {
        if (!open(MAIL,">",$fil)) {
                $res = &add8err(err=>$err,nsu=>$nsub,
                                erm=>["Not possible to open file $fil"]);
	} else {
            ## building the mail
            # writing the header
            print MAIL "To: $tow\n";
            if (defined($cco)) { print MAIL "Cc: $cco\n";}
            if (defined($bcc)) { print MAIL "Bcc: $bcc\n";}
            print MAIL "Subject: $sbj\n";
            print MAIL "MIME-Version: 1.0\n";
            print MAIL 'Content-Type: MULTIPART/MIXED; BOUNDARY="'.$limit_part.'"',"\n";
            print MAIL "\n";
            print MAIL "This is a multipart message in MIME format.\n";
            # writing the text parts
            foreach (@$txt) {
                print MAIL "\n--$limit_part\n";
                print MAIL "Content-Type: TEXT/PLAIN; charset=$chs\n\n";
                open(THB,"<",$_) or die("Despite previous checking, file $_ was not available");
                foreach my $li (<THB>) { print MAIL $li;}
                close(THB);
            }
            # writing the html parts
            foreach (@$htm) {
                print MAIL "\n--$limit_part\n";
                print MAIL "Content-Type: TEXT/HTML; charset=$chs\n\n";
                open(THB,"<",$_) or die("Despite previous checking, file $_ was not available");
                while (<THB>) { print MAIL $_;}
                close(THB);
            }
            # writing the encoded parts
            foreach (@$b64) {
                print MAIL "\n\n--$limit_part\n";
                print MAIL 'Content-Type: APPLICATION/octet-stream; name="'.$_.'"'."\n";
                print MAIL "Content-Transfer-Encoding: BASE64\n";
                print MAIL 'Content-ID: <Pine.LNX.4.21.0005191023160.8452@penguin.example.com>\n';
                print MAIL 'Content-Description: '.$_."\n";
                print MAIL 'Content-Disposition: attachment; filename="'.$_.'"'."\n";
	        print MAIL "\n";
                open(THB,"<",$_) or die("Despite previous checking, file $_ was not available");
                # encoding
                binmode THB;
                # Undef the file record separator so we can read the
                # whole file to attach in one go.
                my $sauvele = $/;
                undef $/;
                my $contents = <THB>;
                $/ = $sauvele;  
                close(THB); 
                # encoding
                my $encont = encode_base64($contents);
                print MAIL $encont;
            }
            #
            close(MAIL);
            $res = 1;
        }
    }
    # returning
    $res;
}
#############################################
#
##<<
sub retrouve {
    #
    # title : find directories or files
    #
    # aim: from a starting directory returns either all
    #      subdirectories or all fill included in its
    #      ramification.
    #
    # output: a reference to an array of strings containing
    #         the result, unless an error be encontoured in
    #         that case an error message is returned (to be
    #         tested with &err9.
    #
# arguments
my $hrsub = {dir =>[".","c","The starting directory"],
             qoi =>[   1,"n","1 for searching directories,",
                            "0 for searching files"],
             frg =>[  "","c","the regular expression to filter",
                           "what must be included in the result"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my %argu = %{$argu};
my $dir = $argu{dir};
my $qoi = $argu{qoi};
my $frg = $argu{frg};
#
my $res;
# removing the possible trailing /
if ($dir =~ /\/$/) { $dir = substr($dir,0,-1);}
# globbing if necessary, then the found first
# directory will be used
if (!(-d $dir)) {
  my @didir = glob($dir);
  $dir = $didir[0];
}
# in case the initial directory was not found
unless (-d $dir) {
    $res = &add8err(err=>"",nsu=>$nsub,
                    erm=>["'$dir' seems not a directory"]);
    return $res;
}
my @fichiers; my @repertoires;
# following code was borrowed from somebody else
if (opendir my $dh, $dir) {
    # Capture entries first, so we don't descend with an
    # open dir handle.
    my @list; my $file;
    push @repertoires, $dir;
    while ($file = readdir $dh) {
        push @list, $file;
    }
    closedir $dh;
    for $file (@list) {
        # Unix file system considerations.
        next if $file eq '.' || $file eq '..';
        # Swap these two lines to follow symbolic links into
        # directories.  Handles circular links by entering an
        # infinite loop.
        push @fichiers, "$dir/$file"        if -f "$dir/$file";
        if (-d "$dir/$file") {
	    my $rrr = &retrouve (dir=>"$dir/$file",qoi=>$qoi,frg=>$frg);
            if ($qoi==0) {
                push    @fichiers,@$rrr;
            } else {
                push @repertoires,@$rrr;
            }
        }
    }
}
# getting the desired result
if ($qoi==0) {
    $res = \@fichiers;
} else {
    # adding the trailing /
    foreach my $mrp (@repertoires) {
        if (!($mrp =~ /\/$/)) { $mrp = $mrp."/";}
    }
    $res = \@repertoires;
}
# filtering
if ($frg ne "") {
    for (my $ii = (scalar(@$res)-1) ; $ii >= 0 ; $ii--) {
        if ($res->[$ii] !~ /$frg/) {
            splice(@$res,$ii,1);
        }
    }
}
# returning
$res;
}
#############################################
#
##<<
sub la {
    #
    # title : short call to 'print8structure' and 'pause'
    #
    # aim : mainly to use when debugging.
    #        'la' is a shortcut for 'look at'.
    #
    # output: 1
    #
# arguments
my $hrsub = {str =>[undef,"csahu","The structure to be displayed"],
             mes =>[   "","c","The associated message to the pause call",
                              "When empty string (default) pause is not called"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my $str = $argu->{str};
my $mes = $argu->{mes};
&print8structure(str=>$str);
if ($mes ne "") {
    &pause(mes=>$mes);
}
return 1;
}
#############################################
1;

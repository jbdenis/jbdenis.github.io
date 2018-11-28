#
# general functions to be used in perl 
#
# 18_01_07 18_01_30 18_04_02
#
package jours;
use strict;
use warnings;
use lib "../uie";
use uie; 
use Scalar::Util qw(looks_like_number);

###<<<
#
# 'jours' gives access to some subroutines to handle my
#       favorite way of coding the day dates.
#
###>>>
#
#############################################
#############################################
#
##<<
sub month7day {
    #
    # title : gives the number of days of a given month
    #
    # aim: takes care of leap years
    #
    # output: the number of days of the month or the number
    #         of days of the year when the month doesn't exist
    #         returns 0.
    #
# arguments
my $hrsub = {yyy =>[undef,"c","the year"],
             mmm =>["" ,"c","the month"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &uie::argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my %argu = %{$argu};
my $yyy = $argu{yyy};
my $mmm = $argu{mmm};
#
my $mon = $mmm;
my $yea = 1*$yyy;
my $res = 0;
# constant
my @nbr = (31,28,31,30,31,30,31,31,30,31,30,31);
if (($yea % 4) == 0) {
    $nbr[1] = 29;
    if (($yea % 100) == 0) {
        $nbr[1] = 28;
        if (($yea % 400) == 0) {
            $nbr[1] = 29;
         }
    }
}
if ($mon eq "") {
    foreach (@nbr) {$res = $res + $_;}
} else {
    $res = $nbr[$mon-1];
}
unless (defined($res)) { $res = 0;}
# returning
$res;
}
#############################################
#
##<<
sub check8day {
    #
    # title : check the format of a day
    #
    # aim: to detect errors without too much trouble
    #
    # output: the input or an error message when
    #         an inconsistency was detected.
    #         An idea could be to call it through 
    #         a call to &uie::check9err.
# arguments
my $hrsub = {ymd =>[undef,"c","the yyyy_mm_dd to check"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &uie::argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my %argu = %{$argu};
my $ymd = $argu{ymd};
#
my $res = "";
# 
my @ymd = split("_",$ymd);
if (scalar(@ymd) != 3) {
    $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>
                 ["$ymd is not a valid day",
"$ymd",
                  "three components needed"]);
    return($res);
}
if (!(looks_like_number($ymd[0]))) {
    $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>
                 ["$ymd is not a valid day",
                  "First component not a number"]);
} 
if (!(looks_like_number($ymd[1]))) {
    $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>
                 ["$ymd is not a valid day",
                  "Second component not a number"]);
} 
if (!(looks_like_number($ymd[2]))) {
    $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>
                 ["$ymd is not a valid day",
                  "Third component not a number"]);
}
if (&uie::err9(obj=>$res)) { return $res;}
#
if (($ymd[1] < 1) or ($ymd[1]>12)) {
    $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>
                 ["$ymd is not a valid day",
                  "the second component is not a month"]);
    return($res);
}
my $nmd = &month7day(yyy=>$ymd[0],mmm=>$ymd[1]);
if (($ymd[2] < 1) or ($ymd[2]>$nmd)) {
    $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>
                 ["$ymd is not a valid day",
                  "the third component is not a valid day"]);
    return($res);
}
# returning
$ymd;
}
#############################################
#
##<<
sub check8tipe {
    #
    # title : check the canonical format of a time period
    #
    # aim: to detect errors without too much trouble
    #
    # output: the input or an error message when
    #         an inconsistency was detected.
    #         An idea could be to call it through 
    #         a call to &uie::check9err.
# arguments
my $hrsub = {tip =>[undef,"c","the time period to check"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &uie::argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my %argu = %{$argu};
my $tip = $argu{tip};
#
my $res = $tip;
# 
my @tip = split("\Q|\E",$tip);
if (scalar(@tip) != 2) {
    $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>
                 ["$tip is not a valid time period",
                  "two components needed"]);
    return($res);
}
my $rr = &check8day(ymd=>$tip[0]);
if (&uie::err9(obj=>$rr)) {
    $res = &uie::conca8err(er1=>$res,er2=>$rr);
    $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>
                 ["$tip is not a valid time period",
                  "First component is not a valid yyyy_mm_dd"]);
    return($res);
}
my $ss = &check8day(ymd=>$tip[1]);
if (&uie::err9(obj=>$ss)) {
    $res = &uie::conca8err(er1=>$res,er2=>$ss);
    $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>
                 ["$tip is not a valid time period",
                  "Second component is not a valid yyyy_mm_dd"]);
    return($res);
}
if (not(&uie::err9(obj=>$res))) {
    if ($tip[0] gt $tip[1]) {
        $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>
                     ["$tip is not a valid time period",
                      "First component more recent than the second one"]);
        
    }
}
# returning
$res;
}
#############################################
#
##<<
sub duration {
    #
    # title : duration of a time period
    #
    # aim: computes the duration in days of a time period
    #
    # output: the number of days or an error if the input
    #         is not consistent.
    #         The limit days are included so "2018_01_07|2018_01_07"
    #         will give one day.
    #
# arguments
my $hrsub = {tip =>[undef,"c","the time period to evaluate"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &uie::argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my %argu = %{$argu};
my $tip = $argu{tip};
my $res = "";
# checking the input
my $ch = &check8tipe(tip=>$tip);
if (&uie::err9(obj=>$ch)) {
    $res = $ch;
    $res = &uie::add8err(err=>$ch,nsu=>$nsub,
                         erm=>"$tip is not a valid time period");
    return $res;
}
# computing the duration
$res = 0;
my @dd = split("\Q|\E",$tip);
my @d1 = split("_",$dd[0]);
my @d2 = split("_",$dd[1]);
if ($d1[0] != $d2[0]) {
    # years are different
    if ( $d2[0] > $d1[0]+1) {
        # some complete years to add
        for my $y (($d1[0]+1)..($d2[0]-1)) {
            $res = $res + month7day(yyy=>$y);
        }
    }
    # plus end of the first year
    $res = $res + &duration(tip=>"$dd[0]"."|"."$d1[0]_12_31");
    # plus the beginnig of the last year
    $res = $res + &duration(tip=>"$d2[0]_01_01"."|"."$dd[1]");
} else {
    # years are identical
    if ($d1[1] != $d2[1]) {
        # months are different
        if ( $d2[1] > $d1[1]+1) {
            # some complete years to add
            for my $m( ($d1[1]+1)..($d2[1]-1)) {
                $res = $res + month7day(yyy=>$d1[0],mmm=>$m);
            }
        }
        # plus end of the first month
        $res = $res + &month7day(yyy=>$d1[0],mmm=>$d1[1]) - $d1[2] + 1;
        # plus the beginnig of the last month
        $res = $res + $d2[2];
     } else {
        # months are identical
        $res = $d2[2] - $d1[2] + 1;
    }
}
# returning
$res;
}
#############################################
#
##<<
sub cano8day {
    #
    # title : gives a canonical format to a reduced day
    #
    # aim: the canonical format of a day is
    #        'yyyy_mm_dd'
    #
    #      Accepted reduced formats by this subroutines are:
    #      yyyy             -> yyyy_01_01 or yyyy_12_31
    #      yyyy_mm          -> yyyy_mm_01 or yyyy_mm_[28,29,30,31]
    #
    # remark: the not available time '' is accepted and not modified
    #
    # output: a chain giving the canonical form or an error
    #         when inconsistency is found when analyzing
    #         the input.
    #
# arguments
my $hrsub = {day =>[undef,"c","The proposed day"],
             war =>[undef,"n","0 for before / 1 for after"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &uie::argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my %argu = %{$argu};
my $day = $argu{day};
my $war = $argu{war};
# not available day
if ($day eq "") { return $day;}
#
my $res;
my @day = split("_",$day);
if (scalar(@day) == 3) {
    # the day is already complete
    $res = &check8day(ymd=>$day);
} elsif (scalar(@day) == 2) {
    # the day is supposed missing
    if ($war) {
        # adding on the ending side
        my $ed = &month7day(yyy=>$day[0],mmm=>$day[1]);
        if (&uie::err9(obj=>$ed)) {
            $res = &uie::add8err(err=>$ed,nsu=>$nsub,erm=>
                                 ["$day seems not to be an acceptable day"]);
        } else {
            $res = $day."_".$ed;
            $res = &check8day(ymd=>$res);
        }
    } else {
        # adding on the starting side
        $res = $day."_01";
        $res = &check8day(ymd=>$res);
    }
} elsif (scalar(@day) == 1) {
    # month and day are supposed missing
    if ($war) {
        $res = $day."_12_31";
        $res = &check8day(ymd=>$res);
    } else {
        # adding on the starting side
        $res = $day."_01_01";
        $res = &check8day(ymd=>$res);
    }
} else {
    $res = &uie::add8err(err=>"",nsu=>$nsub,erm=>
                         ["<$day> is not an acceptable yyyy_mm_dd",
                          "even after completion, it doesn't have three components"]);
}
# returning
$res;
}
#############################################
#
##<<
sub cano8tipe {
    #
    # title : gives a canonical format to a reduced time period
    #
    # aim: the canonical format of a time period is
    #        'yyyy_mm_dd|zzzz_nn_ee'
    #      where each substring before and after '|' is
    #      the mere indication of a day, the first day
    #      must be identical or before the second day,
    #      both days must exist (past or future).
    #
    #      Accepted reduced formats by this subroutines are:
    #      yyyy             -> yyyy_01_01|yyyy_12_31
    #      yyyy_mm          -> yyyy_mm_01|yyyy_mm_[28,29,30,31]
    #      yyyy_mm_dd       -> yyyy_mm_dd|yyyy_mm_dd
    #      yyyy_mm_dd|ee    -> yyyy_mm_dd|yyyy_mm_ee
    #      yyyy_mm_dd|nn_ee -> yyyy_mm_dd|yyyy_nn_ee
    #      yyyy|zzzz        -> yyyy_01_01|zzzz_12_31
    #      yyyy|zzzz_nn     -> yyyy_01_01|zzzz_mm_[28,29,30,31]
    #      yyyy|            -> yyyy_01_01|4000_12_31
    #          |zzzz        -> 1000_01_12|zzzz_12_31
    #          |            -> 1000_01_12|4000_12_31
    #                       -> 1000_01_12|4000_12_31
    #      and so on.
    #
    # output: a chain giving the canonical form or an error
    #         when inconsistency is found when analyzing
    #         the input.
    #
# arguments
my $hrsub = {tip =>[undef,"c","The proposed time period"]
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &uie::argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my %argu = %{$argu};
my $tip = $argu{tip}; if ($tip eq "") { $tip = "|";}
#
my ($d1,$d2);
my $res = ""; my $tipi = $tip;
if ($tip !~ /\Q|\E/) {
    # only one day is given
    $d1 = &cano8day(day=>$tip,war=>0);
    $d2 = &cano8day(day=>$tip,war=>1);
} else {
    # filling empty sides when necessary
    if ($tip =~ /^\s*\|/) { $tip = "1000_01_01".$tip;}
    if ($tip =~ /\|\s*$/) { $tip = $tip."4000_12_31";}
    my @tip = split("\Q|\E",$tip);
    # possibly completing the first component
    $d1 =  &cano8day(day=>$tip[0],war=>0);
    # possibly completing the second component
    my @ymd1 = split("_",$tip[0]);
    my @ymd2 = split("_",$tip[1]);
    if (length($ymd2[0]) == 4) {
        # year indicated so no need of first day
        $d2 =  &cano8day(day=>$tip[1],war=>1);
    } elsif (scalar(@ymd2) == 2) {
        # month and day given
        $d2 = &cano8day(day=>$ymd1[0]."_".$tip[1],war=>1);
    } else {
        # only the day number is given
        $d2 = &cano8day(day=>$ymd1[0]."_".$ymd1[1]."_".$tip[1],war=>1);
    }
}
my $e1 = &uie::err9(obj=>$d1);
my $e2 = &uie::err9(obj=>$d2);
if ($e1) {
    $res = &uie::conca8err(er1=>$res,er2=>$d1);
    &uie::print8err(err=>$res);
}
if ($e2) {
    $res = &uie::conca8err(er1=>$res,er2=>$d2);
    &uie::print8err(err=>$res);
}
unless ($e1 or $e2) {
    # building the tipe
    $res = $d1."|".$d2;
    # checking the proposal
    my $che = &check8tipe(tip=>$res);
    if (&uie::err9(obj=>$che)) {
        my $rrr = $res;
        $res = &uie::add8err(err=>$che,nsu=>$nsub,erm=>
                             ["The proposed tipe ($tipi) leads to",
                              "a bad canonical tipe ($rrr)"]);
    }
}
# returning
$res;
}
#############################################
#
##<<
sub compa8tipe {
    #
    # title : Makes a crude comparison of two tipes
    #
    # aim: the comparison of two discrete segments
    #      is not that obvious... It seems not to be
    #      symmetrical. Here six cases are distinguished
    #
    #      Let the first segment be [a,A] and the 
    #      second one be [b,B].
    #      
    #      In square brackets, the returned value:
    #      
    #       1: b <= B <  a <= A  ["GT"]
    #       2: a <= A <  b <= B  ["LT"]
    #       3: b =  a <= A =  B  ["EQ"]
    #       4: b <  a <= A <  B  ["IN"]
    #       5: a <  b <= B <  A  ["OU"]
    #       6: <remaining cases> ["??"]
    #     
    # Remark: the comparison of two discrete segments
    #      is not that obvious... It seems not to be
    #      symmetrical. 
    #      Let the first segment be [a,A] and the 
    #      second one be [b,B].
    #      
    #      11 cases have to be distinguished, in 
    #      square bracket, possible returned values:
    #      
    #       1: b <= B <  a <= A [ 5]
    #       2: b <  B =  a <  A [ 4]
    #       3: b <  a <  B <  A [ 3]
    #       4: b <  a <  B =  A [ 2]
    #       5: b =  a <  B <  a [ 1]
    #       6: b =  a <= A =  B [ 0]
    #       7: a <  b <  A =  B [-1]
    #       8: a =  b <  A <  B [-2]
    #       9: a <  b <  A <  B [-3]
    #      10: a <  b =  A <  B [-4]
    #      11: a <= A <  b <= B [-5]
    #     
    #  This is not satisfactory... to be thought again     
    #
    # output: the obtained answer unless unconsistency
    #         of one of the tipe which rises a fatal 
    #         error after the printing of a message.
    #
# arguments
my $hrsub = {tp1 =>[undef,"c","The  first time period"],
             tp2 =>[undef,"c","The second time period"],
	    };
##>>
my $nsub = (caller(0))[3]; 
my $argu   = &uie::argu($nsub,$hrsub,@_);
if ($argu == 1) { return 1;}
my %argu = %{$argu};
my $tp1 = $argu{tp1};
my $tp2 = $argu{tp2};
#
# checking
my $c1 = &uie::check8err(obj=>&check8tipe(tip=>$tp1),wha=>0);
my $c2 = &uie::check8err(obj=>&check8tipe(tip=>$tp2));
if (&uie::err9(obj=>$c1)) { exit;}
# initializing
my ($a,$A) = split(/\Q|\E/,$tp1);
my ($b,$B) = split(/\Q|\E/,$tp2);
my $res = "??";
# comparing
if (($a eq $b) and ($A eq $B)) { $res = "EQ";}
elsif ($A lt $b) { $res = "LT";}
elsif ($B lt $a) { $res = "GT";}
elsif (($b lt $a) and ($A lt $B)) { $res = "IN";}
elsif (($a lt $b) and ($B lt $A)) { $res = "OU";}
# returning
$res;
}
#############################################
1;

#
# functions to be used in perl scripts for annotation
#
# 16_08_09 16_08_11 16_08_12 16_08_14 16_08_15
# 16_08_30 16_08_31 16_09_06 16_09_09 16_09_10
# 16_09_11 16_09_12 16_09_13 16_09_16 16_09_17
# 16_09_19 16_09_20 16_09_21 16_09_22 16_09_23
# 16_09_24 16_09_25 16_09_26 17_09_23 17_10_01
# 17_10_02 17_10_06 17_10_09 17_10_10 17_10_11
# 17_10_14 17_10_17 17_10_18 17_10_19 17_10_27
# 17_11_04 17_11_05 17_11_06 17_11_11 17_11_12
# 17_11_13 17_11_15 17_11_16 17_11_20 17_11_22
# 17_11_27 17_12_14 17_12_15 17_12_27 17_12_30
# 18_01_02 18_01_03 18_01_04 18_01_05 18_01_07
# 18_01_09 18_01_10 18_01_11 18_01_12 18_01_13
# 18_01_14 18_01_17 18_01_18 18_01_28 18_02_02
# 18_02_13 18_02_14 18_02_16 18_02_19 18_02_21
# 18_02_23 18_02_24 18_02_27 18_03_01 18_03_02
# 18_03_06 18_03_07 18_03_08 18_03_09 18_03_10
# 18_03_11 18_03_12 18_03_13 18_03_14 18_03_15
# 18_03_16 18_03_17 18_03_18 18_03_20 18_03_21
# 18_03_22 18_03_23 18_03_24 18_03_25 18_03_26
# 18_03_27 18_03_28 18_03_29 18_03_30 18_03_31
# 18_04_02 18_04_03 18_04_04 18_04_05 18_04_06
# 18_04_07 18_04_08 18_04_09 18_04_11 18_04_12
# 18_09_17 18_09_30 18_10_01 18_10_02 18_10_04
# 18_10_05 18_10_09 18_10_11 18_10_13 18_10_14
#
## components of annotation
our $lino;
our $pi7check = 1; # must the pi checks be made?
our %can = (
           );
# TODO LIST
#    + concommittant wid,hei with orthonormality
#    + affichage individuel d'image sous html
#    + technical parameter and comments at the title level
# 
package phoges;
use strict;
use warnings;
#
use Scalar::Util qw(looks_like_number);
use lib "/home/jbdenis/o/info/perl/uie";
use uie;
use lib "/home/jbdenis/o/info/perl/jours";
use jours;
use lib "/home/jbdenis/o/info/perl/lhattmel";
use lhattmel;
use Scalar::Util qw(looks_like_number);
#
###<<<
#
# 'phoges' for 'photo-gestion'.
#
# This module was written to support a series of
# programs focused to the annotation of my photos. Principles
# are presented in a small document named 'annotation-photo'.
#
# Nevertheless some words have to be added here to precise
# which Perl structures are associated to the different concepts.
#
# To each picture can be associated:
#    - a name, but take care that the same name cannot be attributed
#              to different pictures even in different directories !!!
#    - a set of nested circumstances, comprising at least one element
#    - a time period, "0000" when it is missing,
#    - a set of places, possibly empty,
#    - a set of people, possibly empty,
#    - a set of keywords, possibly empty,
#    - a set of categories, possibly empty,
#    - a set of paragraphs for the comment, possibly empty.
# 
# The storage of this information is done through four important
# structures : individual pi's, collective pi's, circumstance pi's
# and additional pi's. Empty ones can be created with &new7pi (where
# they are implicitly descrived and their validity checked with
# check8pi.
#
# A set of pictures ('sepi') is coded with a hash whose keys
# are their names and the value is a reference to
# an array of size 5 such that
#   [0] refers to a string giving the date,
#   [1] refers to an array of the circumstances,
#   [2] refers to an array of the categories,
#   [3] refers to an array of the keywords,
#   [4] refers to an array of the comment paragraphs.
#
# IT IS STRONGLY SUGGESTED TO READ THE DOCUMENT
# <annotation-photo.pdf> WHERE THE GENERAL
# APPROACH WHICH IS USED IS DESCRIBED.
#
###>>>
#############################################
#############################################
# Some general constants
#############################################
# 
## list of pi codes
our @pco = ("n","t","p","q","g","k","c","m","h","d");
## definition of names for the pi's of image caption at a collective level
our %ipi = (n=>"N=",t=>"Quand: ",p=>"Où: ","q"=>"Qui: ",k=>"Clé(s): ",g=>"Catégorie(s): ",
            'm'=>"Commentaires: ",h=>"Technik: ");
## definition of indicators for keywords, people, place and categories
our %idrf = (k=>"kwd",g=>"cat",p=>"pla",q=>"qui");
## indicators for annotation files
our %idif = (stf=>"stf");
## separators for paragraphs within comments and so on in eif file
our %sepa = ("m"=>"//",c=>"//",p=>"//",
             h=>",",k=>",",g=>",","q"=>",",
             "d"=>"/");
## separators for paragraphs within comments and so on when building the captions
our %sepb = ("m"=>"//",p=>"//",
             k=>",",g=>",","q"=>",");
## framing for caption components
our %cfra = (
             "n"=>["(",") "],   # name
             "t"=>["<","> "],   # date
             "p"=>[" [","] "],  # place
             "q"=>[" [","] "],  # who
             "g"=>["[[","]] "], # category
             "k"=>["[[","]] "], # keyword
             "m"=>["/","/ "]    # comment
            );
## profile of images
our %prim = (jpg=>'[j|J][p|P][g|G]$',
             png=>'[p|P][n|N][g|G]$');
## framing tags in eif files
our %fram = (
             "t"=>["[|","|]"],
             "p"=>["(|","|)"],
             "q"=>["[[","]]"],
             "g"=>["<<",">>"],
             "k"=>["{{","}}"],
             "C"=>["<(",")>"],
             "c"=>["<|","|>"],
             "m"=>["((","))"],
             "h"=>["<[","]>"],
             "d"=>["{|","|}"]
            );
## default parameters for lhattmel::start call see its documentation for details
our %pls = (cod=>"utf8",tit=>"",aut=>"",dat=>1,
                          toc=>1,npa=>1,two=>0,lma=>"15mm",
                          rma=>"15mm",tma=>"15mm",bma=>"15mm",
                          lgu=>"french",par=>[]
	     );
## default parameters for some interpretation of the latex elaboration
our %plt = (nus=>1,red=>1);
## tag to introduce an additional paragraph
our $parin = "(*)";
## command at individual level to be introduced as category/keyword.
our $kom = "--";
##   allow (i) to prevent collective [pi]s at individual level
# for instance
#     '--k--' means not to introduce collective keywords and categories
#     '--kp--' the same escaping plus the possible collective place
# coding are
#     'c' -> circumstance
#     't' -> time
#     'p' -> place
#     'q' -> people (qui in French)
#     'k' -> keyword and category
#     'm' -> comment
#     'h' -> technical parameters
# also 'A' -> 'ctpqkmh'
#      'K' -> 'k'
#      'C' -> 'cm'
# then 'KC' -> 'kcm'
#
##   allow (ii) to reproduce the annotation of the previous image
# for instance
#     --i-- copy the time, place, people, categories, keywords and comments of the previous picture
#           when NOT PROVIDED in the picture annotation
# These 'identical' commands have priority on the other so
#     --iI-- will be interpreted as --I--
#
## indication of a representative picture of the current section
our $rpi = "xc"; # must be in the category set
## to store extra information
our $sei = [];
## tags for output files
our %tag = (
           # for ...
           );
# default values for the collective technical parameters
our $cdefa = {wid=>"",hei=>"",WID=>"",HEI=>"",                
             nbi=>1,gnl=>1,gnc=>1,cap=>""}; 
# default values for the individual technical parameters
our $idefa = {wid=>"",hei=>"",rot=>0}; 
#
## selection criteria
my %sety1 = (I=>"Included",X=>"eXcluded");
my %sety2 = (I=>"Intersection",U=>"Union");
my %sety3 = (c=>"Circumstances",
             t=>"Time period",
             p=>"Place",
             q=>"people",
             k=>"Keyword",
             g=>"cateGory",
            "m"=>"coMment",
             h=>"tecHnical parameter",
             A=>"All except time period",
             B=>"All except time period and circumstance");
#
# tags for lines to be introduced in transformed files
my %telquel = (l=>"<LATEX>",h=>"<HTML>");
#
# global variables
my $oldat; my $identi = 0;
#############################################
#
##<<
sub get8date {
    #
    # title : date of a picture
    #
    # aim : determine the date of a picture
    # 
    # output : a string associated to the date,
    #         possibly "".
    #
    # arguments
    my $hrsub = {nam  =>[undef,  "c","The file name of the picture"],
                 tim  =>[   "",  "cu","The date proposed by the annotation file,",
                                      "can be the year when 'pmdd*' coding",
                                      "not taken into account when the name is",
                                      "formatted 'yyyy_mm_dd.*'."]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $name = $argu->{nam};
    my $date = $argu->{tim};
    unless (defined($date)) { $date = "";}
    # constant
    my %mois = (
              1=>"01",2=>"02",3=>"03",4=>"04",
              5=>"05",6=>"06",7=>"07",8=>"08",
              9=>"09",a=>"10",b=>"11",c=>"12"
               );
    my $yemi = "0000";
    # initialization
    my $res;
    # computation
    $name = lc($name);
    if ($name =~ /^(\d\d\d\d_\d\d_\d\d)/) {
        # the date is in the name prefix
        $res = $1;
    } elsif ( $name =~ /^p([1-9a-c])(\d\d)/) {
        my $mois = $1; my $jour = $2;
        # coding used by my old Olympus camaras
        if ($date !~ /^\d\d\d\d$/) {
            # the year is not supplied by the annotation
            push @$phoges::sei,"'get8date' was not provided a year for name ".
                               "$name and introduced $yemi instead of.";
            $date = $yemi;
        }
        $res = $date."_".$mois{$mois}."_".$jour;
    } else {
        if ($date eq "") { $res = $yemi;
        } else { $res = $date;}
    }
    # returning
    $res;
}
#############################################
#
##<<
sub check8pi {
    #
    # title : check the validity of an collective pi series
    #
    # aim : to ease the programming task. Can be avoid with
    #      the global variable pi7check.
    # 
    #  Have a look to the code to know what are the components of
    #      of the different types of pi's. These are given by
    #      '$xpi->{y} which is compulsory and can take the
    #      following six values: 
    #        'ind' pi of a precise image (individual)
    #        'col' pi for a set of images (collective)
    #        'cir' circumstances
    #        'add' for additional pi
    #        'ext' for external paragraph
    #        'spe' for specific lines external to phoges
    #
    #   - All components must be present except for 
    #         the 'add' and 'spe' types
    #   - Array components must be [] when empty
    #   - String components must be "" when empty
    #
    # output : 1 when right if not an error
    #
    # arguments
    my $hrsub = {xpi  =>[undef,  "h","The series of pi's to check"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $xpi = $argu->{xpi};
    # no check?
    if (not($pi7check)) { return 1;}
    # proceeding according to the type
    my $res = "";
    unless (defined($xpi->{y})) {
        my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                erm=>["The proposed 'xpi' doesn't have 'y' as a key to indicate its type"]);
        return $rrr;
    }
    #
    if ($xpi->{y} eq "ind") {
        # INDIVIDUAL PI'S
        # checking the name
        if (not(defined($xpi->{n}))) {
            $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                 erm=>["key <n> is missing in xpi argument indicated as individual pi's"]);
        } elsif (ref($xpi->{n}) ne "") {
            $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                 erm=>["key <n> is a reference not simple chain for an individual pi's"]);
        }
        # checking single components
        foreach my $compo ("t","d") {
            if (not(defined($xpi->{$compo}))) {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is missing in xpi argument"]);
            } elsif (ref($xpi->{$compo}) ne "") {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is a reference not simple chain"]);
            }
        }
        # checking array components
        foreach my $compo ("p","q","k","g","c","m") {
            if (not(defined($xpi->{$compo}))) {
                 $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is missing in xpi argument"]);
            } elsif (ref($xpi->{$compo}) ne "ARRAY") {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is not a reference to an array"]);
            } else {
                foreach my $arr (@{$xpi->{$compo}}) {
                    if (!defined($arr)) {
                        $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                             erm=>["One of the component of xpi<$compo> is not defined"]);
                    } elsif (ref($arr) ne "") {
                         $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                        erm=>["One of the component of xpi<$compo> is a reference not simple chain"]);
                    }
                }
            }
        }
        # checking hash components
        foreach my $compo ("h") {
            if (not(defined($xpi->{$compo}))) {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is missing in xpi argument"]);
            } elsif (ref($xpi->{$compo}) ne "HASH") {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is not a reference to a hash"]);
            }
        }
    } elsif ($xpi->{y} eq "col") {
        # COLLECTIVE PI'S
        # checking there no name
        if (defined($xpi->{n})) {
            $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                 erm=>["key <n> is present in xpi argument",
                                       "not accepted for a collective pi series (collective)"]);
        }
        # checking single components
        foreach my $compo ("t","d") {
            if (not(defined($xpi->{$compo}))) {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is missing in xpi argument (collective)"]);
            } elsif (ref($xpi->{$compo}) ne "") {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is a reference not simple chain (collective)"]);
            }
        }
        # checking the {c} component
        my $nbco;
        if (defined($xpi->{c})) {
            $nbco = scalar(@{$xpi->{c}});
            foreach my $ci (@{$xpi->{c}}) {
                if (ref($ci) ne "") {
                    $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                         erm=>["a component of key <c> is a reference (".ref($ci).") must be a string (collective)"]);
                }
            }
        } else {
            $nbco = 1;
        }
        # checking array components
        foreach my $compo ("p","q","k","g","m") {
            if (not(defined($xpi->{$compo}))) {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is missing in xpi argument (collective)"]);
            } elsif (ref($xpi->{$compo}) ne "ARRAY") {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is not a reference to an array (collective)"]);
            } elsif (scalar(@{$xpi->{$compo}}) != $nbco) {
                 $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                erm=>["One of the component of xpi<$compo> is not an array of length $nbco",
                                      "which is the number of circumstance levels"]);
            } else {
                foreach my $arr (@{$xpi->{$compo}}) {
                    if (!defined($arr)) {
                        $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                             erm=>["One of the component of xpi<$compo> is not defined (collective)"]);
                    } elsif (ref($arr) ne "ARRAY") {
                         $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                        erm=>["One of the component of xpi<$compo> is not a reference to an array (collective)"]);
                    }
                }
            }
        }
        # checking hash components
        foreach my $compo ("h") {
            if (not(defined($xpi->{$compo}))) {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is missing in xpi argument (collective)"]);
            } elsif (ref($xpi->{$compo}) ne "HASH") {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is not a reference to a hash (collective)"]);
            }
        }
    } elsif ($xpi->{y} eq "cir") {
        # CIRCUMSTANCE PI'S
        # checking the number of components
        my $nbco = scalar(keys %$xpi);
        if ($nbco != 3) {
            $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                 erm=>["The number of components is not three but $nbco",
                                       "(must be {y}, {l} and {c}).",
                                       "They are {".join("},{",keys %$xpi)."}!",
                                       "not accepted for a circumstance pi series (circumstance)"]);
            return $res;
        }
        # checking the two components of use
        foreach my $compo ("l","c") {
            if (not(defined($xpi->{$compo}))) {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is missing in xpi argument (circumstance)"]);
                return $res;
            } elsif (ref($xpi->{$compo}) ne "") {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is a reference not a simple chain (circumstance)"]);
                return $res;
            }
        }
        # checking the {l} component as numerical
        unless ( looks_like_number($xpi->{l}) ) {
            $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                 erm=>["key <$xpi->{l}> is not a number (circumstance)"]);
        } else {
            my $toto = 1. * ($xpi->{l});
            if (($toto < 0) or ($toto > 6)) {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$xpi->{l}> is out of range (circumstance)"]);
            }
        }
    } elsif ($xpi->{y} eq "add") {
        # ADDITIONAL PI'S
        # checking there is no name
        if (defined($xpi->{n})) {
            $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                 erm=>["key <n> is present in xpi argument",
                                       "not accepted for an additional pi series (additional)"]);
        }
        # checking there is no circumstance
        if (defined($xpi->{c})) {
            $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                 erm=>["key <c> is present in xpi argument",
                                       "not accepted for an additional pi series (additional)"]);
        }
        # checking single components
        foreach my $compo ("t","d") { if (defined($xpi->{$compo})) {
            if (ref($xpi->{$compo}) ne "") {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is a reference not simple chain (additional)"]);
            }
        }}
        # checking array components
        foreach my $compo ("p","q","k","g","m") { if (defined($xpi->{$compo})) {
            if (ref($xpi->{$compo}) ne "ARRAY") {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is not a reference to an array (additional)"]);
            } else {
                foreach my $arr (@{$xpi->{$compo}}) {
                    if (!defined($arr)) {
                        $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                             erm=>["One of the component of xpi<$compo> is not defined (additional)"]);
                    } elsif (ref($arr) ne "") {
                        &uie::la(str=>$xpi);
                         $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                        erm=>["One of the component of xpi<$compo> is a reference not simple chain (additional)"]);
                    }
                }
            }
        }}
        # checking hash components
        foreach my $compo ("h") { if (defined($xpi->{$compo})) {
            if (ref($xpi->{$compo}) ne "HASH") {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is not a reference to a hash (additional)"]);
            }
        }}
    } elsif ($xpi->{y} eq "ext") {
        unless (defined($xpi->{p})) {
            $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                 erm=>["The paragraph {p} is not present in the external paragraph line"]);
        }
    } elsif ($xpi->{y} eq "spe") {
        unless (defined($xpi->{c})) {
            $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                 erm=>["The content {c} is not present in the specific line"]);
        }
    } else {
        $res = &uie::add8err(err=>$res,nsu=>$nsub,
                             erm=>["type <$xpi->{y}> is not known as indicating any pi's"]);
    }
    # returning
    unless (&uie::err9(obj=>$res)) { $res = 1;}
    $res;
}
#############################################
#
##<<
sub analyze8line {
    #
    # title : get type and content from an eif line
    #
    # aim : the line to analyze can be
    #      (0) a specific line to be ignored 
    #          starting with a value of %telquel
    #      (i) an image line with all possible pi's
    #          leading to an ind7pi
    #     (ii) a circumstance line, then this is
    #          its only pi leading to a cir7pi
    #    (iii) a additional line, proposing pi's
    #          for futher images leading to a col7pi
    #      
    #      Other line types are considered as
    #          an error.
    # 
    #      'lit' argument is reserved for self calls
    #          it provides the type of pi to be
    #          analyzed.
    #
    # output : 
    #        In case of (0) a pi of type 'spe' is returned 
    #         with the complete content is key 'c'.
    #        If not the associated pi to the line.
    #         Of course, an error message when some
    #         inconsistency in the input is found.
    #         ((or its contents when the type is given in input,
    #           'undef' when not present.)).
    #        In case of inconsistency an error is returned.
    #
    # remarks :
    #           * shortcuts are not transformed
    #
    # arguments
    my $hrsub = {lin  => [undef,"c","The line to analyze"],
                 sht  => [   {},"h","Definition of the shortcuts"],
                 lit  => [   "","c","When '', line type is asked for",
                                    "else must be a valid line type and",
                                    "the content will be returned whereever it is."]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $li0 = $argu->{lin}; my $lin = $li0;
    my $sht = $argu->{sht};
    my $lit = $argu->{lit};
    my $res = undef;
    # preparation
    $lin =~ s/\s+/ /g; $lin =~ s/^ //; $lin =~ s/ $//;
    # the case of a specific line
    my $speci = 0;
    foreach my $tag (values %telquel) { if ($lin =~ /^$tag/) { $speci = 1;} }
    if ($speci) { return {"y"=>"spe","c"=>$lin};}
    # performing
    if ($lit eq "") {
        # escaping the additionnal comment
        if ($lin =~ /^\Q$parin\E/) {
            my $res = {"y"=>"ext"};
            $res->{"p"} = substr($lin,length($parin));
            return $res;
        }
        # checking that no double definition is present
        my $rrr = "";
        foreach my $ferme (keys %fram) {
            my @nbo = ($lin =~ /\Q$fram{$ferme}->[0]\E/g);
            my @nbf = ($lin =~ /\Q$fram{$ferme}->[1]\E/g);
            my $nbo = scalar(@nbo); my $nbf = scalar(@nbf);
            if ($nbo > 1) {
                # more one openning parenthesis
                $rrr = &uie::add8err(err=>$rrr,nsu=>$nsub,
                                        erm=>["Analyzing $lin",
                                              "the openning for pi<$ferme> \"$fram{$ferme}->[0]\"".
                                              " was found more than once"]);
            }
            if ($nbf > 1) {
                # more one closing parenthesis
                $rrr = &uie::add8err(err=>$rrr,nsu=>$nsub,
                                        erm=>["Analyzing $lin",
                                              "the closing for pi<$ferme> \"$fram{$ferme}->[1]\"".
                                              " was found more than once"]);
            }
            if (($nbo == 1) and ($nbf == 1)) {
                if ($lin =~ /\Q$fram{$ferme}->[1]\E.*\Q$fram{$ferme}->[0]\E/) {
                    $rrr = &uie::add8err(err=>$rrr,nsu=>$nsub,
                                            erm=>["Analyzing $lin",
                                                  "the brackets for pi<$ferme> \"$fram{$ferme}->[0]\" and \"$fram{$ferme}->[1]\"",
                                                  " are not in the right order"]);
                }
            }
        }
        if (&uie::err9(obj=>$rrr)) { return $rrr;}
        # looking for the line type
        my $typ;
        if ($lin =~ /\Q$fram{C}->[0]\E(.*)\Q$fram{C}->[1]\E\s*(.*)\s*$/) {
            # a collective circumstance
            my $nle = $1;
            $res = $2;
            $res =~ s/\s+/ /g; $res =~ s/^\s+//; $res =~ s/\s+$//;
            $res = { "y"=>"cir","l"=>$nle, "c"=>$res };
        } else {
            $lin =~ /^(\S+)\s*/;
            if (&image9(nam=>$1)) {
                # an image line
                $res = &new7pi(wha=>"ind");
                $lin =~ s/^(\S+)\s*//;
                $res->{n} = $1;
                $lino = $lin;
                foreach my $copo ("p","h","t","q","g","k","c","m","d") {
                    my $rrr = &analyze8line(lin=>$lin,lit=>$copo);
                    if (defined($rrr)) {
                        $res->{$copo} = $rrr;
                    }
                }
                # looking for free shortcuts
                unless ($lino =~ /^\s*$/) {
                    $lino =~ s/,/ /g;
                    $lino =~ s/\s+/ /g;
                    my @free = split(/ /,$lino);
                    for my $cop ("p","q","k","g") {
                        my $copo = $idrf{$cop};
                        for (my $ii = scalar(@free)-1; $ii >= 0; $ii--) {
                            my $mot = $free[$ii];
                            if (defined($sht->{$copo}->{$mot})) {
                                if (defined($res->{$cop})) {
                                    #push $res->{$cop},$mot;
                                    push @{$res->{$cop}},$mot;
                                } else {
                                    $res->{$cop} = [$mot];
                                }
                                splice(@free,$ii,1);
                            }
			}
                    }
                    $lino = join(" ",@free);
                }                
                #
                unless ($lino =~ /^\s*$/) {
                    # unexpectedly something was left
                    my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                            erm=>["Analyzing $lin",
                                                  "as an image line, something was not interpreted:",
                                                  "<<:$lino:>>"]);
                    return $rrr;
                }
            } else {
                # must be a additional pi line
                $res = &new7pi(wha=>"add");
                $lino = $lin;
                my $rci = &analyze8line(lin=>$lin,lit=>"c");
                if (defined($rci)) {
                    my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                            erm=>["Analyzing $lin",
                                                  "as a additional line, a {c} component was found!"]);
                    return $rrr;
                }
                #
                foreach my $copo ("t","p","q","g","k","m","h","d") {
                    my $rrr = &analyze8line(lin=>$lin,lit=>$copo);
                    if (defined($rrr)) {
                        if ($copo =~ /[pqkgm]/) {
                            @{$res->{$copo}} = @$rrr;
                        } elsif ($copo =~ /[h]/) {
                            %{$res->{$copo}} = %$rrr;
                        } else {
                            $res->{$copo} = $rrr;
                        }
                    }
                }
                # looking for free shortcuts
                unless ($lino =~ /^\s*$/) {
                    $lino =~ s/,/ /g;
                    $lino =~ s/\s+/ /g;
                    my @free = split(/ /,$lino);
                    for my $cop ("p","q","k","g") {
                        my $copo = $idrf{$cop};
                        for (my $ii = scalar(@free)-1; $ii >= 0; $ii--) {
                            my $mot = $free[$ii];
                            if (defined($sht->{$copo}->{$mot})) {
                                if (defined($res->{$cop})) {
                                    #push $res->{$cop},$mot;
                                    push @{$res->{$cop}},$mot;
                                } else {
                                    $res->{$cop} = [$mot];
                                }
                                splice(@free,$ii,1);
                            }
			}
                    }
                    $lino = join(" ",@free);
                }                
                #
                unless ($lino =~ /^\s*$/) {
                # unexpectedly something was left
                my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                        erm=>["Analyzing $lin",
                                              "as a additional line, something was not interpreted:",
                                              "<<:$lino:>>"]);
                return $rrr;
                }
            }
        }
        my $ver = &check8pi(xpi=>$res);
        if (&uie::err9(obj=>$ver)) { $res = $ver;}
        return $res;
    } else {
        # a specific content is looked for
        $res = undef;
        if (not(defined($lino))) { return $res;
        } elsif ($lit =~ /^[t,d]$/) {
            if ($lino =~ s/\Q$fram{$lit}->[0]\E\s*(.*)\s*\Q$fram{$lit}->[1]\E//) {
                $res = $1;
            }
        } elsif ($lit =~ /^[pqgkmc]$/) {
            if ($lino =~ s/\Q$fram{$lit}->[0]\E(.*)\Q$fram{$lit}->[1]\E//) {
                if ($1 =~ /^\s*$/) {
                    $res = [];
                } else {
                    @$res = split(/$sepa{$lit}/,$1);
                    foreach my $com (@$res) {
                        $com =~ s/\s+/ /g; $com =~ s/^ //; $com =~ s/ $//;
                    }
                }
            }
        } elsif ($lit eq "h") {
            if ($lino =~ s/\Q$fram{$lit}->[0]\E\s*(.*)\s*\Q$fram{$lit}->[1]\E//) {
                if ($1 =~ /^\s*$/) {
                    $res = {}
                } else {
                    $res = &analyze8series(lin=>$1,sep=>$sepa{$lit});
                }
            }
        } else {
            # lit was found inconsistent
            print "The proposed line was <",$lin,">\n";
            my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                    erm=>["Value of argument lit ($lit) was not found consistent"]);
            return $rrr;
        }
    }
    # final check
    if ($lit eq "") {
        if (defined($res->{n})) {
            # individual line
            my $rrr = &check8ind7pi(ipi=>$res);
            if (&uie::err9(obj=>$rrr)) {
                my $rr = &uie::add8err(err=>"",nsu=>$nsub,
                                       erm=>["Surprisingly, $nsub produced a bad indpi..."]);
                $res = &uie::conca8err(er1=>$rr,er2=>$rrr);
            }
        } else {
            # additional line
            my $rrr = &check8col7pi(cpi=>$res);
            if (&uie::err9(obj=>$rrr)) {
                my $rr = &uie::add8err(err=>"",nsu=>$nsub,
                                       erm=>["Surprisingly, $nsub produced a bad colpi..."]);
                $res = &uie::conca8err(er1=>$rr,er2=>$rrr);
            }
        }
    }
    # returning
    $res;
}
#############################################
#
##<<
sub read8st7f {
    #
    # title : reading a stf file
    #
    # aim : read and developp the content of a stf file.
    #      'stf' means ShortcuT definition File".
    # 
    # output : a reference to a hash having as keys
    #            the values of %phoges::idrf.
    #         The associated values are references to hashes
    #           having shortcuts for keys and their definition
    #           for values.
    #
    #         BUT in case of inconsistency, an error object is
    #         returned which can be checked with &uie::err9 and
    #         displayed with &uie::print8err.
    #
    # arguments
    my $hrsub = {fil  =>[undef,  "c","The file to be read"],
                 ref  =>[{},  "h","The previous reference to complete.",
                                   "It is advised that it be the result",
                                   "of a previous call with 'read8st7f.",
                                   "Particularly, only specific keys", '(%idrf)',
                                   "are admitted."]
                };
##>>
    my $nsub = (caller(0))[3]; 
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $file = $argu->{fil};
    my $refe = $argu->{ref};
    # initialization
    my @uuu = values(%idrf);
    my %khh = ();
    foreach (@uuu) { $khh{$_} = 0;}
    my $res = {};
    my $err = [];
    # checking the proposed reference if any
    if (scalar(%$refe)) {
        $res = &uie::copy8structure(str=>$refe); 
        foreach (keys(%$res)) {
            if (scalar(&uie::belong9(sca=>\$_,arr=>\@uuu))==0) {
                $err = &uie::add8err(err=>$err,nsu=>$nsub,erm=>
                       ["The proposed previous reference 'refe' has got key '$_'",
                        " not belonging to expected keys which are: ",
                        join("|",@uuu)]);
            }
        }
    }
    #
    # reading the proposed file
    my $nouveau = &uie::read8line(fil=>$file,typ=>2,khh=>\%khh);
    if (&uie::err9(obj=>$nouveau)) {
        my $res = &uie::add8err(err=>"",nsu=>$nsub,
                          erm=>["Bad reading for $file as a stf file"]);
        $res = &uie::conca8err(er1=>$res,er2=>$nouveau);
        return $res;
    }
    # completing with the new values, checking for redundancies
    foreach my $typ (@uuu) {
        my @alke = keys(%{$res->{$typ}});
        foreach (keys (%{$nouveau->{$typ}})) {
            if (scalar(&uie::belong9(sca=>\$_,arr=>\@alke))) {
                $err = &uie::add8err(err=>$err,nsu=>$nsub,erm=>
                       ["key $typ '$_' proposed in the current file $file ",
                        "was already present in the previous reference set"]);
            } else {
                my $sstt = $nouveau->{$typ}->{$_};
                if ($typ eq $idrf{k}) {
                    # dealing with mutliple keywords
                    my $rsst = uie::split8string(str=>$sstt,enc=>undef,
                                                 sep=>$sepa{k},err=>0);
                    if (ref($rsst) ne "ARRAY") {
                        # an error was found
                        $err = &uie::add8err(err=>$err,nsu=>$nsub,erm=>
                               ["An error with some keyword which was printed at that time"]);
                        print "Erroneous keyword: ",$rsst,"\n";
                    } else {
                        $sstt = join($sepa{k},@$rsst);
                    }
                }
                $res->{$typ}->{$_} = $sstt;
            }
        }
    }
    # returning
    if (&uie::err9(obj=>$err)) { return($err);}
    $res;
}
#############################################
#
##<<
sub read8sl7f {
    #
    # title : reading a slf file
    #
    # aim : read, check and developp the content of a slf file.
    #      'slf' means SeLection definition File".
    # 
    # output : a reference to a hash having as keys
    #            the possible combinations of selection types defined
    #            in phoges::sety[1,2,3] hashes.
    #         The associated values are reference to an
    #           array having the words (or time period) defining
    #           the criteria selection.
    #
    #         BUT in case of inconsistency, an error object is
    #         returned which can be checked with &uie::err9 and
    #         displayed with &uie::print8err.
    #
    # arguments
    my $hrsub = {fil  =>[undef,  "c","The file to be read"]
                };
##>>
    my $nsub = (caller(0))[3]; 
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $file = $argu->{fil};
    # initialization
    my $cles = [];
    foreach my $t1 (keys %sety1) {
    foreach my $t2 (keys %sety2) {
    foreach my $t3 (keys %sety3) {
        push @$cles,$t1.$t2.$t3;
    }}}
    # reading the file
    unless (-e $file) {
        my $ret = &uie::add8err(err=>"no",nsu=>$nsub,
                                erm=>["file $file was not found"]);
        return $ret;
    }
    my $res = &uie::read8line(fil=>$file,typ=>2,kha=>$cles);
    foreach (keys %$res) {
        if (defined($res->{$_}->[0])) {
            my @ax = split(" ",$res->{$_}->[0]);
            $res->{$_} = \@ax;
        } else {
            delete $res->{$_};
        }
    }
    # returning
    $res;
}
#############################################
#
##<<
sub select8image {
    #
    # title : selection of images
    #
    # aim : basic function for selection
    # 
    # output : 1 if selected 0 if not,
    #         or an error in case of any inconsistency.
    #
    # arguments
    my $hrsub = {ima  =>[undef,  "h","The pi's describing the image"],
                 cri  =>[undef,  "h","array of the criteria for selection,",
                                     "simple regulars expression are admissible."]
                };
##>>
    my $nsub = (caller(0))[3]; 
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $ima = $argu->{ima};
    my $cri = $argu->{cri};
    my $res = 1; my $res0 = 0;
    # preliminary checks
    my $ch1 = &check8pi(xpi=>$ima);
    if (&uie::err9(obj=>$ch1)) {
        $res = &uie::add8err(err=>"",nsu=>$nsub,
                                erm=>["Proposed image ('ima') is not valid."]);
        $res = &uie::conca8err(er1=>$res,er2=>$ch1);
        return $res;
    }
    if ($ima->{y} ne "ind") {
        $res = &uie::add8err(err=>"",nsu=>$nsub,
                                erm=>["Proposed image ('ima') is not an image since its type is '$ima->{y}'."]);
        return $res;
    }
    # applying in turn every simple criterium
    for my $typ (keys %$cri) {
        # decomposing the type
        my ($t1,$t2,$t3) = split("",$typ);
        # preliminary check
        if (not(defined($sety1{$t1})) or 
            not(defined($sety2{$t2})) or
            not(defined($sety3{$t3}))) {
            print("$nsub found a bad type ($typ) of selection, must be among the keys of:\n");
            &uie::print8structure(str=>\%sety1);
            &uie::print8structure(str=>\%sety2);
            &uie::print8structure(str=>\%sety3);
            $res = &uie::add8err(err=>"",nsu=>$nsub,
                                 erm=>["$nsub found a bad type ($typ) of selection,",
                                       "must be among the keys of the printed hashes"]);
            return $res;
        }
        # matching every criteria except time
        if ($t3 ne "t") { 
            my $sum = 0; my $tout = scalar(@{$cri->{$typ}});
            my @vals = ($t3);
            if ($t3 eq "A") {
                @vals = ("c","p","g","k","m");
            } elsif ($t3 eq "B") {
                @vals = (    "p","g","k","m");
            }
            #&uie::la(str=>\@vals,mes=>"vals");
            foreach my $pi (@vals) {
                #print "pi = $pi\n";
                my @val = @{$ima->{$pi}};
                #&uie::la(str=>$ima->{$pi},mes=>"ima de pi = $pi");
                #&uie::la(str=>$cri->{$typ},mes=>"cri de typ = $typ");
                foreach my $cr (@{$cri->{$typ}}) {
                    my $isom = 0;
                    foreach my $va (@val) {
                        #print "  $isom ";
                        if ($va =~ /$cr/) { $isom++;}
                        #print " -> $isom va = $va --- cr = $cr => $isom \n";
                    }
                    if ($isom > 0) { $sum++;}
                }
                #print "sum = $sum (tout = $tout)\n";
                if ($t1 eq "I") { 
                    if ($t2 eq "I") { $res0 = ($sum == $tout);}
                    else { $res0 = ($sum > 0);}
                } else {
                    if ($t2 eq "I") { $res0 = ($sum < $tout);}
                    else { $res0 = ($sum == 0);}
                }
                if ($res0 eq "") { $res0 = 0;}
                last if ($res0); 
            }
        } else {
            # selecting for the time period
            my $longueur = scalar(@{$cri->{$typ}});
            if ($longueur != 1) {
                &uie::print8structure(str=>$cri);
                my $sss = &uie::add8err(err=>"",nsu=>$nsub,
                                        erm=>["A unique criterion was expected for the time period",
                                              "(Selection Type = $typ of length = $longueur)"]);
                return $sss;
            }
            my $ctp = &jours::cano8tipe(tip=>$cri->{$typ}->[0]);
            my $itp = &jours::cano8tipe(tip=>$ima->{t});
            my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                    erm=>["description of the time criterion is not valid",
                                          "ctp = <$cri->{$typ}->[0]>",
                                          "tip = <$ima->{t}>"]);
            my $bon = 1;
            if (&uie::err9(obj=>$ctp)) { $rrr = &uie::conca8err(er1=>$rrr,er2=>$ctp); $bon = 0;}
            if (&uie::err9(obj=>$itp)) { $rrr = &uie::conca8err(er1=>$rrr,er2=>$itp); $bon = 0;}
            unless ($bon) { return $rrr;}
            if ($t2 eq "I") { $rrr = &jours::compa8tipe(tp1=>$itp,tp2=>$ctp);}
            else            { $rrr = &jours::compa8tipe(tp1=>$ctp,tp2=>$itp);}
            
            if (&uie::err9(obj=>$rrr)) { return $rrr;}
            if (($rrr eq "IN") or ($rrr eq "EQ")) { $res0 = 1;}
            else { $res0 = 0;}
            if ($t1 eq "X") { $res0 = 1-$res0;}
        }
        unless ($res0) { return $res0;}
    }
    # returning
    $res;
}
#############################################
#
##<<
sub update8col7pi {
    #
    # title : update the collective pi's
    #
    # aim : an ancillary functions to update the current collective pi's.
    # 
    # output : the updated collective pi
    #         or an error when something was not
    #         acceptable
    #
    # arguments
    my $hrsub = {cop  =>[undef,  "h","The colpi to be updated"],
                 sup  =>[undef,  "h","The additional addpi or cirpi to use"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $co0 = $argu->{cop}; my $cop = &uie::copy8structure(str=>$co0);
    my $sup = $argu->{sup}; 
    # some checking according to '$pi7check'
    my $rrr = "";
    my $rrr1 = &check8pi(xpi=>$cop);
    my $rrr2 = &check8pi(xpi=>$sup);
    if (&uie::err9(obj=>$rrr1)) {
        $rrr = &uie::add8err(err=>$rrr,nsu=>$nsub,
                             erm=>["'cop' argument was not a genuine pi"]);
        $rrr = &uie::conca8err(er1=>$rrr,er2=>$rrr1);
    }
    if (&uie::err9(obj=>$rrr2)) {
        $rrr = &uie::add8err(err=>$rrr,nsu=>$nsub,
                             erm=>["'sup' argument was not a genuine pi"]);
        $rrr = &uie::conca8err(er1=>$rrr,er2=>$rrr2);
    }
    if ( &uie::err9(obj=>$rrr)) { return $rrr;}
    if ($cop->{y} ne "col") {
        &uie::print8structure(str=>$cop);
        my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                erm=>["'cop' argument is not a collective  pi but $cop->{y}"]);
        return $rrr;
    }
    #
    my $nbc = scalar(@{$cop->{c}});
    if ( $sup->{y} eq "cir" ) {
        # just the circumstance levels have to be adjusted
        if ( $sup->{l} eq "0") {
            # defining a title
            if ($nbc > 1) {
                &print8pi(xpi=>$cop);
                my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                        erm=>["Defining a title while some circumstance(s) were already present"]);
                return $rrr;
            }
            $cop->{c}->[0] = $sup->{c};
            for my $ii ("p","q","k","g","m") { $cop->{$ii}->[0] = [];}
            for my $ii ("d","t") { $cop->{$ii} = "";}
            for my $ii ("h") { $cop->{$ii} = {};}
        } else {
            # modifying the hierarchy
            if ($sup->{l} > $nbc) {
                &print8pi(xpi=>$sup);
                my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                        erm=>["Defining a circumstance too high for the present colpi",
                                              "(colpi: ".($nbc-1)."; new circumstance: ".$sup->{l}.")"]);
                return $rrr;
            }
            # initialization
            my $lbc = $sup->{l};
            my $tit = $sup->{c};
            # proceeding
            if ($nbc == $lbc) {
                # a new level of circumstances is added
                push @{$cop->{"c"}},$tit;
                foreach my $hh (keys %$cop) {
                    unless ($hh eq "c") {
                        if ($hh =~ /[pqgkm]/) {
                            push @{$cop->{$hh}},[];
                        }
                    }
                }
            } elsif ($nbc > $lbc) {
                # modification of the present hierarchy
                $cop->{"c"}->[$lbc] = $tit;
                splice(@{$cop->{"c"}},$lbc+1);
                foreach my $hh (keys %$cop) {
                    if ($hh =~ /[pqgkm]/) {
                        $cop->{$hh}->[$lbc] = [];splice(@{$cop->{$hh}},$lbc+1);
                    }
                }
            }
        }
    } else {
        # additional information must be incorporated
        foreach my $wha (keys %$sup) { unless ($wha eq "y") {
            my $val = $sup->{$wha};
            # some pi to update
            if (defined($val)) { 
                if (ref($val) eq "ARRAY") {
                    if (scalar(@$val) == 0) { $val = [];}
                    else {
                        my $nul = 0;
                        foreach (@$val) { if ( $_ =~ /^\s*$/) { $nul++;}}
                        if (scalar(@$val) == $nul) { $val = [];}
                    }
                } elsif (ref($val) eq "HASH") {
                    if (scalar(keys %$val)==0 ) { $val = {};}
                } elsif ($val =~ /^\s*$/) {
                    $val = "";
                }
                if ($wha =~ /[pqgkm]/) {
                    $cop->{$wha}->[$nbc-1] = $val;
                } elsif ($wha =~ /[dth]/) {
                    $cop->{$wha} = $val;
                }
            }
        }}
    }
    # final check
    $rrr1 = &check8pi(xpi=>$cop);
    if (&uie::err9(obj=>$rrr1)) {
        $rrr = &uie::add8err(err=>$rrr,nsu=>$nsub,
                             erm=>["'cop' produced by $nsub is not a genuine colpi!!!",
                                   "Sorry for that!!!"]);
        $cop = &uie::conca8err(er1=>$rrr,er2=>$rrr1);
    }
    # returning
    $cop;
}
#############################################
#
##<<
sub pi2line {
    #
    # title : generates a line from a series of pi's
    #
    # aim : an ancillary functions to write
    #        lines of dif and icf.
    #      When a collective pi's the following pi's
    #        are gathered "t","p","q","g","k","m","h","d"
    #        where last circumstance levels are taken
    #        for "p","q","g","k","m".
    #      When an individual pi's are given only non empty
    #        components are considered.
    #
    # remarks: + as 'add' pi's must not be written
    #            their occurrence produces an error
    #          + a resulting white line is turned to a comment line
    #
    # output : a single string
    #         or an error when something was not
    #         acceptable
    #
    # arguments
    my $hrsub = {xpi  =>[undef,  "h","The colpis to translate"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $xpi = $argu->{xpi};
    # initialization
    my $res = "";
    # checking
    my $err = &check8pi(xpi=>$xpi);
    if (&uie::err9(obj=>$err)) { return $err;}
    my $typ = $xpi->{y};
    if ($typ eq "add") {
        my $err = &uie::add8err(err=>"",nsu=>$nsub,
                                erm=>["This type of pi's ($typ) cannot be transformed into a line"]);
        return $err;
    }
    # performing
    if ($typ eq "col") {
        # collective pi's
        my $nbc = scalar(@{$xpi->{c}}) - 1;
        if (scalar(keys %{$xpi->{h}}) > 0) {
            $res = $res.$fram{h}->[0];
            my @ru = ();
            foreach my $ele (keys %{$xpi->{h}}) {
                push @ru,$ele."=".$xpi->{h}->{$ele};
            }
            my $ru = join($sepa{h},@ru);
            $res = $res.$ru.$fram{h}->[1];
        }
        foreach my $pi ("t","d") {
            if ($xpi->{$pi} !~ /^\s*$/) {
                $res = $res." ".$fram{$pi}->[0].$xpi->{$pi}.$fram{$pi}->[1];
            }
        }
        foreach my $pi ("p","q","g","k","m") {
            if (scalar(@{$xpi->{$pi}->[$nbc]})) {
                $res = $res." ".$fram{$pi}->[0].
                                join($sepa{$pi},@{$xpi->{$pi}->[$nbc]}).
                                $fram{$pi}->[1];
            }
        }
    } elsif ($typ eq "cir") {
        # a circumstance line
        $res = $res.$fram{C}->[0].$xpi->{l}.$fram{C}->[1]." ".$xpi->{c};
    } else {
        # individual pi's
        $res = $res.$xpi->{n}." ";
        if (scalar(keys %{$xpi->{h}}) > 0) {
            $res = $res.$fram{h}->[0];
            my @ru = ();
            foreach my $ele (keys %{$xpi->{h}}) {
                push @ru,$ele."=".$xpi->{h}->{$ele};
            }
            my $ru = join($sepa{h},@ru);
            $res = $res.$ru.$fram{h}->[1];
        }
        foreach my $pi ("t","d") {
            if ($xpi->{$pi} !~ /^\s*$/) {
                $res = $res." ".$fram{$pi}->[0].$xpi->{$pi}.$fram{$pi}->[1];
            }
        }
        foreach my $pi ("p","q","g","k","m","c") {
            if (scalar(@{$xpi->{$pi}})) {
                $res = $res." ".$fram{$pi}->[0].
                                join($sepa{$pi},@{$xpi->{$pi}}).
                                $fram{$pi}->[1];
            }
        }
    }
    if ($res =~ /^\s*$/) { $res = "#";}
    # returning
    $res;
}
#############################################
#
##<<
sub image9 {
    #
    # title : image name?
    #
    # aim : check if a string is considered as
    #      an image name from the format profiles
    #      defined in '%prim'
    # 
    # output : 1 if true, 0 if not
    #
    # arguments
    my $hrsub = {nam  =>[undef,  "c","The name to investigate"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $name = $argu->{nam};
    my $res = 0;
    # looking for 
    foreach (keys %prim) {
        if ($name =~ /$prim{$_}/) { $res = 1;}
    }
    # returning
    $res;
}
#############################################
#
##<<
sub new7pi {
    #
    # title : return an empty pi or complete a add
    #
    # aim : create a pi which can be:
    #      - an [ind]ividual pi, describing an image
    #        (the compulsory name is set to 'NULL.PNG')
    #      - a [col]lective pi, all information
    #        gathered outside image descriptions
    #      - a [cir]cumstance
    #      - an [add]ition for a collective pi
    #        (if an already created 'add' is proposed
    #         as argument, its non existing pi's
    #         are completed with null values)
    #
    # output : the empty newly created/completed pi
    #         (possibly an error)
    #
    # arguments
    my $hrsub = {wha  =>[undef,  "ch","The type to create 'ind'/'col'/'cir'/'add'",
                                      "(or the add pi to be completed with void values"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $wha = $argu->{wha};
    my $res;
    unless (ref($wha) eq "HASH") {
        # creation
        if ($wha eq "ind") {
            # individual pi's
            $res   = {
                "y"=>"ind", # the type
                n=>"NULL.PNG", # file name
                t=>"", # time period
                p=>[], # place
                "q"=>[], # people series
                g=>[], # categories
                k=>[], # keywords
                c=>[], # circumstances
                "m"=>[], # comment
                h=>{}, # technical parameter
                d=>""  # directory
            };
        } elsif ($wha eq "col") {
            # collective pi's
            $res   = {
                "y"=>"col", # the type
                c=>[], # circumstance stack
                t=>"", # time period
                p=>[], # place
                "q"=>[], # people series
                g=>[], # categories
                k=>[], # keywords
                "m"=>[], # comment
                h=>{}, # technical parameter
                d=>""  # directory
            };
        } elsif ($wha eq "cir") {
            # collective pi's
            $res   = {
                "y"=>"cir", # the type
                c=>"", # circumstance value
                l=>0 # circumstance level
            };
        } elsif ($wha eq "add") {
            # collective pi's
            $res   = {
                "y"=>"add" # the type
                    # other not compulsory possibilities are:
                    #t=>"", # time period
                    #p=>[], # place
                    #"q"=>[], # people series
                    #g=>[], # categories
                    #k=>[], # keywords
                    #"m"=>[], # comment
                    #h=>{}, # technical parameter
                    #d=>""  # directory
            };
        } else {
            # collective pi's
            $res   = &uie::add8err(err=>"",nsu=>$nsub,
                                   erm=>["The proposed type ($wha) is not accepted."]);
        }
    } else {
        # completing what is supposed to be a add pi
        my $rrr = &check8pi(xpi=>$wha);
        if (&uie::err9(obj=>$rrr)) {
            my $rr2 = &uie::add8err(err=>"",nsu=>$nsub,
                                 erm=>["Proposed argument is a hash not being a 'pi'"]);
            return &uie::conca8err(er1=>$rr2,er2=>$rrr);
        }
        unless ($wha->{y} eq "add") {
            my $rr2 = &uie::add8err(err=>"",nsu=>$nsub,
                                 erm=>["Proposed pi isn't a 'add' one but a $wha->{y}"]);
            return $rr2;
        }
        $res = &uie::copy8structure(str=>$wha);
        unless (defined($res->{"c"})) { $res->{"c"} = [];} # circumstance stack
        unless (defined($res->{"t"})) { $res->{"t"} = "";} # time period
        unless (defined($res->{"p"})) { $res->{"p"} = [];} # place
        unless (defined($res->{"q"})) { $res->{"q"} = [];} # people series
        unless (defined($res->{"g"})) { $res->{"g"} = [];} # categories
        unless (defined($res->{"k"})) { $res->{"k"} = [];} # keywords
        unless (defined($res->{"m"})) { $res->{"m"} = [];} # comment
        unless (defined($res->{"h"})) { $res->{"h"} = {};} # technical parameter
        unless (defined($res->{"d"})) { $res->{"d"} = "";}  # directory
        
    }
    # returning
    $res;
}
#############################################
#
##<<
sub print8pi {
    #
    # title : print any pi
    #
    # aim : print a small title and the structure itself
    #
    # output : 1 or an error when the pi is checked [$pi7check].
    #
    # arguments
    my $hrsub = {xpi  =>[undef,  "h","The pi's to print"],
                 eve  =>[    0,  "n","Must empty components be displayed for types 'col' and 'ind'?"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $xp0 = $argu->{xpi}; my $xpi = &uie::copy8structure(str=>$xp0);
    my $eve = $argu->{eve};
    my $res;
    # the check
    $res = &check8pi(xpi=>$xpi);
    if (&uie::err9(obj=>$res)) { return $res;}
    # the title
    my $type = $xpi->{y};
    my %title = ("ind"=>"INDIVIDUAL","col"=>"COLLECTIVE",
                 "cir"=>"CIRCUMSTANCE","add"=>"ADDITIONAL",
                 "ext"=>"EXTERNAL COMMENT");
    print "\n\n $title{$type} PI SERIES:\n\n";
    # removing empty structures for 'ind' and 'col' types
    my @moins = ();
    unless ($eve) { if (($type eq "ind") or ($type eq "col")) {
        for my $kk (keys %$xpi) {
            if ($kk =~ /[td]/) {
                if ($xpi->{$kk} =~ /^\s*$/) {
                    delete $xpi->{$kk};
                    push @moins,$kk;
                }
            }
            if ($kk =~ /[pqkgm]/) {
                my @tableau = @{$xpi->{$kk}}; 
                if ($type eq "col") {
                    my $total = 0;
                    for my $tu (@tableau) {
                        if (scalar(@$tu) == 0) { $total++;}
                    }
                    if ($total == scalar(@tableau)) {
                        delete $xpi->{$kk};
                        push @moins,$kk;
                    }
                } else {
                    # ind type
                    if (scalar(@tableau) == 0) {
                        delete $xpi->{$kk};
                        push @moins,$kk;
                    }
                }
            }
            if ($kk =~ /[h]/) {
                if (scalar(keys(%{$xpi->{$kk}}))==0) {
                    delete $xpi->{$kk};
                    push @moins,$kk;
                }
            }
        }
        unless (scalar(@moins) == 0) {
            print "(The empty components <",join("-",@moins),"> are not displayed)\n";
        }
    }}
    # the structure
    &uie::la(str=>$xpi);
    # returning
    $res;
}
#############################################
#
##<<
sub str2kwd {
    #
    # title : getting the collection of keywords
    #
    # aim : ancillary subroutine to gather the set
    #      of keywords included into a structure
    #      into a simple array where framing is
    #      kept only for multiword keywords
    # notice that set of keywords framing is
    #      supposed to be already eliminated
    #      when 'str' is a reference to an array
    #      but it can be present in a simple
    #      string of characters.
    # 
    # output : the reference to the resulting array
    #
    # arguments
    my $hrsub = {str  =>[undef,  "ca","The structure to investigate",
                                      "can be a simple character chain"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $stru = $argu->{str};
    if (ref($stru) ne "ARRAY") {
        # removing the possible frame
        $stru =~ s/^\Q$can{kko}\E//;
        $stru =~ s/\Q$can{kkc}\E$//;
        # getting the standard structure
        $stru = [$stru];
    }
    my $res = [];
    # cumulating 
    foreach my $cha (@$stru) {
        while ($cha =~ s/\Q$can{ko}\E(.*?)\Q$can{kc}\E//) {
            my $kkk = &uie::juste(cha=>$1,jus=>"n");
            if ($kkk =~ / /) {
                $kkk = $can{ko}.$kkk.$can{kc};
            }
            push @$res,$kkk;
        }
        push @$res,split(/ /,$cha);
    }
    # removing void values
    my $lres = scalar(@$res);
    for (reverse(1..$lres)) {
        if ($$res[$_-1] =~ /^\s*$/) { splice @$res,$_-1,1;}
    }
    # removing duplicated values
    @$res = sort @$res;
    $lres = scalar(@$res);
    for (reverse(2..$lres)) {
        if ($$res[$_-2] eq $$res[$_-1] ) { splice @$res,$_-1,1;}
    }
    # returning
    $res;
}
#############################################
#
##<<
sub cat1kwd {
    #
    # title : sorting out categories and keywords
    #
    # aim : ancillary subroutine of 'read8ic7f'
    #      to separate categories from keywords
    #
    # notice that repetitions are not eliminated
    # 
    # output : the reference to an hash with 
    #         two components: {cat} and {kwd}
    #         referring to arrays of the categories
    #         and the keywords.
    #
    # arguments
    my $hrsub = {c1k  =>[undef,  "c","The string to investigate",
                                      "must be given as a reference",
                                      "to be modified."],
                 cat  =>[   [],  "a","Array of the possible categories"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $c1k = $argu->{c1k};
    my $cat = $argu->{cat};
    # getting out the framed keywords
    my @kwd = (); my @cat = ();
    while ( $c1k =~ s/(\Q$can{ko}\E.*?\Q$can{kc}\E)//) {
        my $un = $1;
        $un =~ s/\Q$can{ko}\E//;
        $un =~ s/\Q$can{kc}\E//;
        push @kwd,$un;
    }
    # from the remaining, distinguish categories and keywords
    my @reste = split(" ",$c1k);
    foreach my $toto (@reste) {
        if (&uie::belong9(sca=>\$toto,arr=>$cat)) {
            push @cat,$toto;
        } else {
            push @kwd,$toto;
        }
    }
    # returning
    my $res = {cat=>[@cat],kwd=>[@kwd]};
    $res;
}
#############################################
#
##<<
sub get8picture4rio {
    #
    # title : selecting pictures
    #
    # aim : according different alternative criteria
    #      a set of picture is extracted from
    #      a raw index object.
    #
    # output : array of the keys of the selected pictures
    #
    # arguments
    my $hrsub = {rip  =>[undef,  "h","The hash from which to get the images",
                                     "({pic} of a rio)"],
                 sel  =>[    1, "na","Indicates a possible selection of images",
                                     "within the rip to explore. When 1 all",
                                     "images are considered, if not must be",
                                     "the array of their keys. Non existing labels",
                                     "are not considered faulty"],
                 tys  =>[undef,  "c","Type of selection among the following possibilities:",
                                     " - 'be' between two lines",
                                     " - 'ck' the presence of at least a category and/or a keyword",
                                     " - 'ci' checking a set of categories using 'and'",
                                     " - 'cu' checking a set of categories using 'or'",
                                     " - 'KI' checking a set of keywords strictly using 'and'",
                                     " - 'KU' checking a set of keywords strictly using 'or'",
                                     " - 'ki' checking a set of keywords loosely using 'and'",
                                     " - 'ku' checking a set of keywords loosely using 'or'",
                                     " - 'CI' checking a sub-string into comments unsing 'and'",
                                     " - 'CU' checking a sub-string into comments unsing 'or'"], 
                 wha  =>[undef,  "a","Reference to an array providing details about the",
                                     "selection to perform:",
                                     " - 'be' first and last lines not included",
                                     "       [0,undef] means all lines",
                                     " - 'ci','cu' categories to use for the selections",
                                     " - 'KI','KU' same for keywords strictly /^keyword$/",
                                     " - 'ki','ku' same for keywords loosely /keyword/",
                                     " - 'CI','CU' same for comments loosely"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $rip = $argu->{rip};
    my $sel = $argu->{sel};
    my $tys = $argu->{tys};
    my $wha = $argu->{wha};
    my $res = [];
    # initializing the set of images to consider
    my $sele = [];
    if (ref($sel) ne "ARRAY") {
        push @$sele,keys(%{$rip});
    } else {
        my @clefs = keys(%{$rip});
        foreach (@$sel) {
            if (&uie::belong9(sca=>\$_,arr=>\@clefs)) {
                push @$sele,$_;
            }
        }
    }
    # gathering the corresponding picture
    if ($tys =~ /^be$/) {
        # gathering within lines
        my $largeur = length((keys %{$rip})[0]);
        if (not(defined($largeur))) { $largeur = 1;}
        $$wha[0] = &uie::justn(num=>$$wha[0],dig=>$largeur);
        if (defined($$wha[1])) {
            $$wha[1] = &uie::justn(num=>$$wha[1],dig=>$largeur);
        } else {
            $$wha[1] = "ZZ";
        }
        unless (scalar(@$wha) == 2) { die("$nsub: when tys eq 'b' two values are expected in \@wha");}
        foreach my $kk (@$sele) {
            if (($kk gt $$wha[0]) and ($kk lt $$wha[1])) {
                push @$res,$kk;
            }
        }
    } elsif ($tys =~ /^ck$/) {
        # gathering for any category or keyword
        foreach my $kk (@$sele) {
            my $oui = ((scalar(@{$rip->{$kk}->[2]}) > 0 ) or (scalar(@{$rip->{$kk}->[3]}) > 0 ));
            if ($oui) { push @$res,$kk;}
        }
    } elsif ($tys =~ /^ci$/) {
        # gathering for categories in intersection
        unless (scalar(@$wha) > 0) { 
            &uie::print8structure(str=>$wha);
            die("$nsub: when tys eq 'ci' at least a category is expected in \@wha");
        }
        foreach my $kk (@$sele) {
            my $non = 0;
            foreach (@$wha) {
                if (not(&uie::belong9(sca=>\$_,arr=>$rip->{$kk}->[2]))) {
                    $non = 1;
                }
                last if ($non);
            }
            if (not($non)) { push @$res,$kk;}
        }
    } elsif ($tys =~ /^cu$/) {
        # gathering for categories in union
        unless (scalar(@$wha) > 0) { 
            &uie::print8structure(str=>$wha);
            die("$nsub: when tys eq 'cu' at least a category is expected in \@wha");
        }
        foreach my $kk (@$sele) {
            my $oui = 0;
            foreach (@$wha) {
                if (&uie::belong9(sca=>\$_,arr=>$rip->{$kk}->[2])) {
                    $oui = 1;
                }
                last if ($oui);
            }
            if ($oui) { push @$res,$kk;}
        }
    } elsif ($tys =~ /^KI$/) {
        # gathering for keywords strictly in intersection
        unless (scalar(@$wha) > 0) { 
            &uie::print8structure(str=>$wha);
            die("$nsub: when tys eq 'KI' at least a keyword is expected in \@wha");
        }
        foreach my $kk (@$sele) {
            my $non = 0;
            foreach (@$wha) {
                if (not(&uie::belong9(sca=>\$_,arr=>$rip->{$kk}->[3]))) {
                    $non = 1;
                }
                last if ($non);
            }
            if (not($non)) { push @$res,$kk;}
        }
    } elsif ($tys =~ /^KU$/) {
        # gathering for keywords strictly in union
        unless (scalar(@$wha) > 0) { 
            &uie::print8structure(str=>$wha);
            die("$nsub: when tys eq 'KU' at least a keyword is expected in \@wha");
        }
        foreach my $kk (@$sele) {
            my $oui = 0;
            foreach (@$wha) {
                if (&uie::belong9(sca=>\$_,arr=>$rip->{$kk}->[3])) {
                    $oui = 1;
                }
                last if ($oui);
            }
            if ($oui) { push @$res,$kk;}
        }
    } elsif ($tys =~ /^ki$/) {
        # gathering for keywords strictly in intersection
        unless (scalar(@$wha) > 0) { 
            &uie::print8structure(str=>$wha);
            die("$nsub: when tys eq 'ki' at least a keyword is expected in \@wha");
        }
        foreach my $kk (@$sele) {
            my $non = 0;
            foreach (@$wha) {
                if (not(&uie::belong9(sca=>\$_,arr=>$rip->{$kk}->[3],
                                       com=>["=~ /","/"],sen=>1))) {
                    $non = 1;
                }
                last if ($non);
            }
            if (not($non)) { push @$res,$kk;}
        }
    } elsif ($tys =~ /^ku$/) {
        # gathering for keywords strictly in union
        unless (scalar(@$wha) > 0) { 
            &uie::print8structure(str=>$wha);
            die("$nsub: when tys eq 'ku' at least a keyword is expected in \@wha");
        }
        foreach my $kk (@$sele) {
            my $oui = 0;
            foreach (@$wha) {
                if (&uie::belong9(sca=>\$_,arr=>$rip->{$kk}->[3],
                                       com=>["=~ /","/"],sen=>1)) {
                    $oui = 1;
                }
                last if ($oui);
            }
            if ($oui) { push @$res,$kk;}
        }
    } elsif ($tys =~ /^CI$/) {
        # gathering for comments loosely in intersection
        unless (scalar(@$wha) > 0) { 
            &uie::print8structure(str=>$wha);
            die("$nsub: when tys eq 'CI' at least a word is expected in \@wha");
        }
        foreach my $kk (@$sele) {
            my $non = 0;
            foreach (@$wha) {
                if (not(&uie::belong9(sca=>\$_,arr=>$rip->{$kk}->[4],
                                       com=>["=~ /","/"],sen=>1))) {
                    $non = 1;
                }
                last if ($non);
            }
            if (not($non)) { push @$res,$kk;}
        }
    } elsif ($tys =~ /^CU$/) {
        # gathering for keywords strictly in union
        unless (scalar(@$wha) > 0) { 
            &uie::print8structure(str=>$wha);
            die("$nsub: when tys eq 'CU' at least a word is expected in \@wha");
        }
        foreach my $kk (@$sele) {
            my $oui = 0;
            foreach (@$wha) {
                if (&uie::belong9(sca=>\$_,arr=>$rip->{$kk}->[4],
                                       com=>["=~ /","/"],sen=>1)) {
                    $oui = 1;
                }
                last if ($oui);
            }
            if ($oui) { push @$res,$kk;}
        }
    } else {
        print "In $nsub the suggested type of selection (ty) is $tys\n",
        "This type is not implemented\n";
        die("  sorry for that!");
    }
    # returning
    @$res = sort @$res;
    $res;
}
#############################################
#
##<<
sub read8ic7f7ax {
    #
    # title : ancillary function for 'read8ic7f'
    #
    # aim : deal with the nested circumstances
    # 
    # output : the new three necessary structures.
    #          (see the code for details)
    #
    # arguments
    my $hrsub = {nli  =>[undef,  "c","the new level line"],
                 old  =>[undef,  "h","The three necessary structures"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $nli = $argu->{nli};
    my $old = $argu->{old};
    if ((!defined($old->{lci})) or
        (!defined($old->{nci})) or
        (!defined($old->{tit}))) {
        &uie::print8structure(str=>$old);
        die("$nsub: this is not a convenient \$old argument");
    }
    if (ref($old->{tit}) ne "ARRAY") {
        &uie::print8structure(str=>$old);
        die("$nsub: \$old->{tit} must a reference to an array");
    }
    if ($nli !~ /^\Q$can{nco}\E(.*)\Q$can{ncc}\E(.*)$/) {
        die("[1] $nsub: something wrong in 'read8ic7f'");
    }
    my $erreurs = "";
    #
    my $olc = $old->{lci};
    my $onl = $old->{nci};
    my $oti = $old->{tit};
    my $nlc = $1;
    unless (looks_like_number($1)) {
        print "\n\n in $nsub ::::::::::::::\n";
        print " "x30,"line : \"$nli\"\n";
        print " "x30,"This doesn't fit a line circumstance as identified\n";
        die "Fit this difficulty...";
    }
    my $nnl = 0;
    my $nti = [@$oti];
    if ($olc eq "") {
        # must be the first circumstance
        if ($1 == 1) {
            $nnl = 1;
            $nti->[0] = $2;
        } else {
            $erreurs = &uie::add8err(err=>$erreurs,nsu=>$nsub,
                                    erm=>["The first circumstance must be '1'!",
                                          $nli]);
            return($erreurs);
        }
    } elsif ($1 eq "") {
        # no more possible to close a level 
        $erreurs = &uie::add8err(err=>$erreurs,nsu=>$nsub,
                                 erm=>["No more possible to close a level without defining a new one!",
                                       "Just introduce a miscellaneous section with the current level",
                                       "     Current level is: $olc",
                                       "     New proposal with $nli"]);
        return($erreurs);
    } else {
        # first find the circumstance levels
        my @leci = split(/\./,$onl);
        # build the new one
        if ((scalar(@leci)+1) < $1) {
            # skipping is not accepted
            print("onl : $onl \n");
            &uie::print8structure(str=>[@leci]);
            $erreurs = &uie::add8err(err=>$erreurs,nsu=>$nsub,
                                     erm=>["A circumstance level was skipped!",
                                           "Current level is: $olc",
                                           "New proposal: $nli ($1)"]);
       
        } elsif ($1 == 1) {
            # starting a new first level
            my @tut = split('\.',$onl);
            $nnl = 1+$tut[0];
            $nti = [$2];
        } else {
            # standard case
            if (!defined($leci[$1-1])) {
                $leci[$1-1] = 0;
            }
            if (scalar(@leci)>$1) {
                splice @leci,$1;
                splice @$nti,$1;
            }
            $leci[$1-1] = 1+$leci[$1-1];
            $nnl = join(".",@leci);
            $nti->[$1-1] = $2;
        }
    }
    # returning
    my $res;
    if (&uie::err9(obj=>$erreurs)) { $res = $erreurs;}
    else { $res = {lci=>$nlc,nci=>$nnl,tit=>$nti}}
    $res;
}
#############################################
#
##<<
sub read8ic7f {
    #
    # title : read a raw index file
    #
    # aim : produce a raw index object where all
    #      information is coded into a structure.
    # 
    # output : either the built structure
    #         or an error something went wrong
    #
    # The structure is a reference to a hash 
    # with few components: com,dir,cir,pic.
    # Each are a reference to another hash
    # having as keys the numbering of the lines
    # of the read file; associated values
    # are references to arrays described
    # as follow and depending on the type:
    # for {com} comment lines (starting with '#')
    # for {dir} relative directories
    # for {cr} reference to an array containing
    #        [0] the depth of the circumstance (e.g. 2),
    #        [1] the hierarquical coding of the levels (e.g. 3.2),
    #        [2] the strict title (e.g. "labrador")
    #            When the level is just the close of 
    #            some level then without any new title
    #            it is replaced with a number of hyphens.
    #        [3] reference to an array with the nested (1..depth) titles
    #                (e.g. '["chien","labrador"]')
    #        [4] reference to the array of collective comments
    #        [5] reference to the array of individual comments
    #            given at the image level.
    #        [6] reference to the array of
    #            keys of the representative
    #            pictures of the section
    #        [7] reference to the array of
    #            keys of all the pictures of
    #            the section
    #        [8] reference to the array of
    #            the pictures having at least a category or a keyword
    # for {pic} reference to an array comprising 5 components:
    #        [0] the name of the image (e.g. PC12003.JPG),
    #        [1] the time period of the image,
    #        [2] a reference to an array of associated categories,
    #        [3] a reference to an array of associated keywords.
    #        [4] the string of all associated comments,
    #
    #
    # arguments
    my $hrsub = {icf  =>[undef,  "c","The name of the raw index file"],
                 cat  =>[   [],  "a","Array of the category names"]   
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $icf = $argu->{icf};
    my $cat = $argu->{cat};
    my $resi = {com=>{},dir=>{},cir=>{},pic=>{}};
    my $resc = {};
    # reading the file
    unless (open(FIL,"<$icf")) {
        $resi = &uie::add8err(err=>"",nsu=>$nsub,
                             erm=>["1:Not possible to open $icf file!"]);
        return $resi;
    } else {
        # just not to get an error message!
        while (<FIL>) {
            last;
        }
    }
    ######
    ## dealing with the first block
    my $fibl = &uie::read8block(fil=>$icf,com=>undef,sep=>undef,
                                bbl=>"<<<IMA>>>",ebl=>"<<</IMA>>>");
    if (scalar(@$fibl)==0) {
        my $ret = &uie::add8err(err=>"no",nsu=>$nsub,
                                erm=>["No one image found in the first block of <$icf>!",
                                     "Perhaps no first block 'IMA'?"]);
        return $ret;
    }
    # getting the number of lines
    my $nul = scalar(@$fibl);
    # number of necessary digits
    my $nbd = 1;
    while (10**$nbd <= $nul) { $nbd++;}
    # dealing with each line of the file
    $nul = 0; my $lci = ""; my $erreurs = "";
    my $nci = ""; my $tit = [];
    foreach (@$fibl) {
        my $lig = $_;
        $nul++; my $sul = &uie::justn(num=>$nul,dig=>$nbd);
        if ($lig =~ /^#(.*)/) {
            # a comment line
            $resi->{com}->{$sul} = $1;
        } elsif ($lig =~ /^\Q$idif{dir}\E(.*)/) { 
            # a directory line
            $resi->{dir}->{$sul} = $1;
        } elsif ($lig =~ /^\Q$can{nco}\E(.*)\Q$can{ncc}\E(.*)$/) {
            # a circumstance line
            my $vieux = {lci=>$lci,nci=>$nci,tit=>$tit};
            my $nouve = &read8ic7f7ax(nli=>$lig,old=>$vieux);
            if (&uie::err9(obj=>$nouve)) {
                $erreurs = &uie::conca8err(er1=>$erreurs,er2=>$nouve);
            } else {
                $lci = $nouve->{lci};
                $nci = $nouve->{nci};
                $tit = $nouve->{tit};
                $resi->{cr}->{$sul} = [$lci,$nci,@$tit];
            }
        } else {
            my @idec = split(" ",$lig);
            my $ima = &image9(nam=>$idec[0]);
            if (!(&uie::err9(obj=>$ima))) {
                # description of one image
                # name
                my $nam = $idec[0];
                # time period
                my $dat = undef;
                if ($lig =~ /\Q$can{to}\E(.*)\Q$can{tc}\E/) {
                    $dat = $1;
                }
                # categories and keywords
                my $ctg = []; my $kwd = [];
                if ($lig =~ /\Q$can{kko}\E(.*)\Q$can{kkc}\E/) {
                    my $de = &cat1kwd(c1k=>$1,cat=>$cat);
                    $ctg = $de->{cat};
                    $kwd = $de->{kwd};
                }
                # comments
                my $com = [];
                if ($lig =~ /\Q$can{coo}\E(.*)\Q$can{coc}\E/) {
                    my @com = split($sepa{m},$1);
                    $com = [@com];
                }
                # storing
                $resi->{pic}->{$sul} = [$nam,$dat,$ctg,$kwd,$com];
            } else {
                $erreurs = &uie::conca8err(er1=>$erreurs,er2=>$ima);
                $erreurs = &uie::add8err(err=>$erreurs,nsu=>$nsub,
                                     erm=>["The following line is not accepted in a 'raw index file'",
                                           "$lig"]);
            }
        }
    }
    # getting the numbering of the circumstances
    my $nuci = []; 
    #my @nuci = sort keys($resi->{cr});
    my @nuci = sort keys(%{$resi->{cr}});
    foreach my $kk (@nuci) {
        push @$nuci,$resi->{cr}->{$kk}->[1];
    }
    ######
    ## dealing with the second block
    my $sebl = &uie::read8block(fil=>$icf,com=>undef,sep=>undef,
                                bbl=>"<<<CIR>>>",ebl=>"<<</CIR>>>");
    if (scalar(@$sebl)==0) {
        my $ret = &uie::add8err(err=>"no",nsu=>$nsub,
                                erm=>["Seems as file $icf doesn't have a 'CIR' block?"]);
        return $ret;
    }
    my $nuse = -1; my $eti = "";
    foreach my $lig (@$sebl) {
        # section line
        if ($lig =~ /^\Q$can{nco}\E(.*)\Q$can{ncc}\E(.*)$/) {
            # just for the awaiting 
            my $lilili = &uie::juste(cha=>$lig,lon=>40,jus=>"L");
            print $lilili;
            my $titi = ("-"x50);
            $nuse++; 
            $eti = $nuci[$nuse];
            my @inti = @{$resi->{cr}->{$eti}};
            if ( $1 ne "") { $titi= $inti[scalar(@inti)-1];}
            my $nouv = [@inti[(0,1)],$titi,
                        [@inti[2..(scalar(@inti)-1)]],[],[]];
            $resi->{cr}->{$eti} = $nouv;
            # about associated images
            my $sui = undef;
            if ($nuse < (scalar(@$nuci)-1)) { $sui = $nuci[$nuse+1];}
            my $nbi = &get8picture4rio(rip=>$resi->{pic},tys=>"be",wha=>[$eti,$sui]);
            $resi->{cr}->{$eti}->[7] = $nbi; # the images
            my $car = &get8picture4rio(rip=>$resi->{pic},tys=>"ci",wha=>[$rpi],sel=>$nbi);
            $resi->{cr}->{$eti}->[6] = $car; # the representative images
            if (scalar(@$car) == 0) {
                print "\t  WARNING NO REPRESENTATIVE IMAGE\n";
            } else {
                print "\n";
            }
            my $nai = &get8picture4rio(rip=>$resi->{pic},tys=>"ck",wha=>[],sel=>$nbi);
            $resi->{cr}->{$eti}->[8] = $nai; # the annotated images
        # specific comment
        } elsif ($lig =~ /\Q$can{coo}\E(.*)\Q$can{coc}\E/) {
            push @{$resi->{cr}->{$eti}->[5]},$1;
        # collective comment
        } else {
            push @{$resi->{cr}->{$eti}->[4]},$lig;
        }
        if ($eti eq "") {
            $erreurs = &uie::add8err(err=>$erreurs,nsu=>$nsub,
                                     erm=>["Not exact correspondance into 'icf' $icf",
                                           "between the two blocks!",
                                           "Would '&read8ic7f' be faulty or badly used?"]);
        }
    }
    # returning
    if (&uie::err9(obj=>$erreurs)) { $resi = $erreurs;}
    $resi;
}
#############################################
#
##<<
sub rio2cat1kwd {
    #
    # title : list of categories/keywords
    #
    # aim : explorates a rio and find out
    #      all used categories/keywords and their
    #      scores.
    # 
    # output : either an error object if something
    #         was wrong, or a hash whose keys are
    #         a generated alphabetical sequence
    #         such that more referred categories
    #         appears first;
    #         associated values are arrays with:
    #         [0] the name of the category/keyword
    #         [1] the number of pictures referring it
    #         [2] reference to the array of
    #             keys of all the pictures 
    #             referring it.
    #
    #
    # arguments
    my $hrsub = {rio  =>[undef,  "h","The raw index object"],
                 qoi  =>["cat",  "c","'cat' for categories if not keywords"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $rio = $argu->{rio};
    my $qoi = $argu->{qoi};
    my $ou = 3;
    if ($qoi eq "cat") { $ou = 2;}
    # initialization
    my $res = {}; my $ctg = {}; my $pct = {};
    # getting the list and frequences of the categories
    #foreach my $ima (keys($rio->{pic})) {
    foreach my $ima (keys(%{$rio->{pic}})) {
        my $cate = $rio->{pic}->{$ima}->[$ou];
        foreach (@$cate) {
            if (defined($ctg->{$_})) {
                $ctg->{$_}++;
                push @{$pct->{$_}},$ima
            } else {
                $ctg->{$_} = 1;
                $pct->{$_} = [$ima];
            }
        }
    }
    # number of necessary digits
    my $nbd = 1;
    while (10**$nbd <= scalar(keys %$ctg)) { $nbd++;}
    # sorting them
    my @cles = sort { $ctg->{$b} <=> $ctg->{$a} } keys(%$ctg);
    my $kom = 0;
    foreach (@cles) {
        $kom++; my $kkk = &uie::justn(num=>$kom,dig=>$nbd);
        $res->{$kkk} = [$_,$ctg->{$_},$pct->{$_}];
    }
    # returning
    $res;
}
#############################################
#
##<<
sub rio2html {
    #
    # title : create an html page from a rio
    #
    # aim : writes an html file displaying
    #      the content of a rio more or less
    #      precisely according to the argument.
    # 
    # output : either 1 or an error object if something
    #         was wrong
    #
    # arguments
    my $hrsub = {rio  =>[undef,  "h","The raw index object to exploit"],
                 fil  =>[undef,  "c","Name of the file to create"],
                 tit  =>[""   ,  "c","Titre de la page"],
                 opt  =>["nh1c0k0","c","chain indicating which options are retained",
                                     " 'n' the file to create must not exist",
                                     "'h0' table of contents",
                                     "'h1' h0 plus numbers of contents",
                                     "'h2' h1 plus comments",
                                     "'h3' h2 plus image names",
                                     "'c0' list of categories and image numbers",
                                     "'c1' c0 plus image names",
                                     "'k0' list of keywords and image numbers",
                                     "'k1' k0 plus image names"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $rio = $argu->{rio};
    my $fil = $argu->{fil};
    my $tit = $argu->{tit};
    my $opt = $argu->{opt};
    # initialization
    my $res = 1; my $txt = [];
    # openning the output file
    if ($opt =~ /n/) {
        if (-e $fil) {
            $res = &uie::add8err(err=>"",nsu=>$nsub,
                                 erm=>["File $fil already exists and replacing not accepted!"]);
            return $res;
        }
    }
    unless (open(HH,">$fil")) {
        $res = &uie::add8err(err=>"",nsu=>$nsub,
                             erm=>["Not possible to open $fil file in writing mode!"]);
        return $res;
    }
    # preparing the text array
    if ( $opt =~ /h[0,1,2,3]/) {
        push @$txt,"<1> Table of Contents";
        # some table of contents is asked for
        #foreach (sort keys($rio->{cr})) {
        foreach (sort keys(%{$rio->{cr}})) {
            my $circo = $rio->{cr}->{$_};
            my $nbim = scalar(@{$circo->[7]});
            my $nbai = scalar(@{$circo->[8]});
            push @$txt,"<".(1+$circo->[0])."> ".$circo->[1]." ".$circo->[2];
            if ($nbim) {
                my $fim = $rio->{pic}->{${$circo->[7]}[0]}[0];
                my $lim = $rio->{pic}->{${$circo->[7]}[$nbim-1]}[0];
                push @$txt,"<> (".$nbai."/".$nbim."): [".$fim," - ",$lim,"]";
            }
            if ( $opt =~ /h[1,2,3]/) {
                push @$txt,"<> This circumstance comprises: ";
                if ($nbim == 0) {
                    push @$txt,"<o> No images";
                } else {
                    push @$txt,"<o> ".$nbim. " images.";
                    push @$txt,"<o> ".$nbai. " of them are annotated.";
                    if (scalar(@{$circo->[6]}) == 0) {
                        push @$txt,"<o> No one was declared representative";
                    } else {
                        push @$txt,"<o> ".scalar(@{$circo->[6]}). " of them are representative.";
                    }
                }
                if (scalar(@{$circo->[4]}) == 0) {
                    push @$txt,"<o> No collective comment";
                } else {
                    push @$txt,"<o> ".scalar(@{$circo->[4]}). " collective comments.";
                }
                if (scalar(@{$circo->[5]}) == 0) {
                    push @$txt,"<o> No individual comment";
                } else {
                    push @$txt,"<o> ".scalar(@{$circo->[5]}). " individual comments.";
                }
                if ( $opt =~ /h[2,3]/) {
                    if (scalar(@{$circo->[4]}) > 0) {
                        push @$txt,"<> Collective comments are:";
                        foreach (@{$circo->[4]}) {
                            push @$txt,"<o>".$_;
                        }
                    }
                    if (scalar(@{$circo->[5]}) > 0) {
                        push @$txt,"<> Individual comments are:";
                        push @$txt,"<o> ".join(" // ",@{$circo->[5]});
                    }
                }
                if ( $opt =~ /h3/) {
                    if (scalar(@{$circo->[6]}) > 0) {
                        push @$txt,"<> Representative images are:";
                        my @rim = ();
                        foreach (@{$circo->[6]}) {
                            push @rim,$rio->{pic}->{$_}->[0];
                        }
                        my $rim = join(" // ",@rim);
                        push @$txt,"<> ".$rim;
                    }
                    if ($nbim > 0) {
                        push @$txt,"<> Included images are:";
                        my @rim = ();
                        foreach (@{$circo->[7]}) {
                            push @rim,$rio->{pic}->{$_}->[0];
                        }
                        my $rim = join(" // ",@rim);
                        push @$txt,"<> ".$rim;
                    }
                }
            }
        }
    }
    #
    if ( $opt =~ /c[0,1]/) {
        # categories are asked for
        my $kc = &rio2cat1kwd(rio=>$rio,qoi=>"cat");
        my $nbkc = scalar(keys %$kc);
        push @$txt,"<1> Categories";
        if ($nbkc == 0) {
            push @$txt,"<> No One Category was found";
        } else {
            push @$txt,"<> ".$nbkc." categories were found";
            my $kom = 0;  my $tt;
            foreach (sort keys %$kc) {
                $kom++;
                my $rim;
                if ( $opt =~ /c1/) {
                    $tt = "<> ($kom: $kc->{$_}->[1]): <b>$kc->{$_}->[0]</b>";
                    my @rim = ();
                    foreach (@{$kc->{$_}->[2]}) {
                        push @rim,$rio->{pic}->{$_}->[0];
                    }
                    $rim = join(" // ",@rim);
                    $rim = " :: ".$rim;
                    push @$txt,$tt,$rim;  
                } else {
                    if ($kom == 1) { $tt = "<> ";}
                    $tt = $tt."($kom: $kc->{$_}->[1]): <b>$kc->{$_}->[0]</b>".("&nbsp;"x5);
                    if ($kom == ($nbkc -1)) { push @$txt,$tt;}
                }
            }
        }
    }
    #
    if ( $opt =~ /k[0,1]/) {
        # keywords are asked for
        my $kc = &rio2cat1kwd(rio=>$rio,qoi=>"key");
        my $nbkc = scalar(keys %$kc);
        push @$txt,"<1> Keywords";
        if ($nbkc == 0) {
            push @$txt,"<> No One Keyword was found";
        } else {
            push @$txt,"<> ".$nbkc." keywords were found";
            my $kom = 0; my $tt;
            foreach (sort keys %$kc) {
                $kom++;
                my $rim;
                if ( $opt =~ /k1/) {
                    $tt = "<> ($kom: $kc->{$_}->[1]): <b>$kc->{$_}->[0]</b>";
                    my @rim = ();
                    foreach (@{$kc->{$_}->[2]}) {
                        push @rim,$rio->{pic}->{$_}->[0];
                    }
                    $rim = join(" // ",@rim);
                    $rim = " :: ".$rim;
                    push @$txt,$tt,$rim;  
                } else {
                    if ($kom == 1) { $tt = "<> ";}
                    $tt = $tt."($kom: $kc->{$_}->[1]): <b>$kc->{$_}->[0]</b>".("&nbsp;"x5);
                    if ($kom == ($nbkc -1)) { push @$txt,$tt;}
                }
            }
        }
    }
    # translating
    my $htm = &uie::text2html(str=>$txt,tit=>$tit);
    foreach my $li (@$htm) {
        print HH $li,"\n";
    }
    # returning
    close(HH);
    $res;
}
#############################################
#
##<<
sub di7f2tex1htm {
    #
    # title : generates a latex|html file from a dif file
    #
    # aim : produce catalogues from series of annotated
    #      pictures.
    # 
    # output : either an error object if something
    #         was wrong, or just 1.
    #
    # remarks :(x) Preexisting tex and html files will be destroyed.
    #          (x) For the moment, only the following technical parameters
    #              are taken into account. They can be collective [C] and/or
    #              individual [I]  (as examples):
    #                 - [CI] 'wid=3cm' width of the images,
    #                 - [CI] 'hei=5cm' height of the images
    #                 - [C]  'WID=3cm' width of the images,
    #                 - [C]  'HEI=5cm' height of the images
    #                 - [I]  'rot=-90' the rotation to apply to the image (default 0),
    #                 - [C]  'nbi=3' number of images to introduce into a grid (default 1),
    #                 - [C]  'gnl=2' number of lines into the grid (default 1),
    #                 - [C]  'gnc=2' number of columns of the grid (default 1)
    #                 - [C]  'cap=common features are...' possible collective caption for a
    #                               a grid of images
    #                    (See below to know how they are used),
    #          (x) Be aware that some collective pi's can be lost if not associated to 
    #                 a set of images. The aim is to annotate, not to build a text.
    #                 For that, other tools are available, in particular lines starting
    #                 with '(*)'. The loss is made when building the DIF from the EIF.
    #
    #
    #  Here are the main rules about the technical parameters [TP]:
    #   * Individual TPs only apply to the present image.
    #   * When 'wid' and/or 'hei' is present in individual TP,
    #     collective 'wid/hei/WID/HEI' are not considered for the present image
    #     but are still considered for the following ones until they be
    #     resetted.
    #   * 'nbi','gnl','gnc','cap' are only possible at a collective level, they apply only to 
    #     the following grid (reset to the default afterwards).
    #   * 'rot' is only possible at an individual level.
    #   * For the moment, 'cap' is reduced to a simple comment.
    #   * A collective line with explicit technical parameters 'nbi' is supposed to be followed by
    #                 'nbi' image lines. If not a fatal error is raised.
    #   * A new collective TP line resets previous values to the default if not defined
    #     except 'WID/HEI' which are resetted only by a void collective TP
    #   * To retrieve all default values of collective TPs just introduce a void one '<[]>'.
    #   * When 'wid' and 'WID' are defined, 'wid' is used
    #   * When 'hei' and 'HEI' are defined, 'hei' is used
    #
    #
    # arguments
    my $hrsub = {dif  =>[undef,  "c","Name root of the dif (decoded index file)"],
                 roo  =>[    0,  "c","Prefix of the latex/html files to generate",
                                     " (without '.tex' or '.html' suffix)",
                                     "When '0' the default value, the name is taken from the dif."],
                 ppa  =>[{},"h","hash allowing to modify a number of default parameters,",
                                "more precisely:",
                                " - the argument 'par' of &lhattmel::start, default values in %pls",
                                " - some latex specifications (default in %plt):",
                                "       . num=>0 for the sections,... not to be numbered (default 1)",
                                "       . red=>0.5 to get the picture half the size which is specified",
                                "                  in the technical parameters (default 1)",
                                " - framing used when building the picture captions (default in %cfra):",
                                "     'cfraon' for the 'o'pening of the 'n'ame",
                                "     'cfracp' for the 'c'losing of the 'p'lace",
                                "              and so on (see the 'cfra' definition)",
                                " - separating components when building the picture captions (default in %sepb):",
                                "     'sepbn' for the 'n'ame",
                                "     'sepbp' for the 'p'lace",
                                "              and so on (see the 'cfra' definition)"],
                 cap  =>["Intpmx","c","Define the way to compute individual captions:",
                                      "'I' for identifying the different components (see %phoges::id)",
                                      "'B' for introducing a new line between the components: doesn't work",
                                      "'X' for indicating missing fields",
                                      " 'n','t','p','q','k','g','m' to introduce them.",
                                      "(Notice that the technical parameters 'h' cannot be included",
                                      " since it is not an array but a hash so the same algorithm",
                                      "cannot be used.)"],
                 typ  =>[  "l",  "c","type of the output : 'l' for latex, 'h' for html"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $dif = $argu->{dif}; $dif = $dif."-dif.txt";
    my $roo = $argu->{roo};
    my $ppa = $argu->{ppa};
    my $cap = $argu->{cap};
    my $typ = $argu->{typ};
    # initialization
    my $res = 1;
    if ($roo eq "0") {
        my @deco = split(/\./,$dif);
        if (@deco > 1) {
            splice @deco,-1;
            $roo = join(".",@deco);
        } else {
            $res = &uie::add8err(nsu=>$nsub,err=>"no",
                                 erm=>["When no prefix (argument roo) is given the dif name must be composed",
                                       "here it is <$dif>!"]);
            return($res);
        }
    }
    my $ouf = $roo.".tex";
    if ($typ eq "h") { $ouf = $roo.".html";}
    my $cod = [];
    # reading the input file
    my $fifi = &uie::read8line(fil=>$dif);
    if (&uie::err9(obj=>$fifi)) {
        $res = &uie::add8err(err=>"",nsu=>$nsub,
                             erm=>["Bad reading for $dif as an edited index file"]);
        $res = &uie::conca8err(er1=>$res,er2=>$fifi);
        return $res;
    }
    # looking for the possible title line
    my $titre = "";
    my $nbli = scalar(@$fifi) - 1;
    for (my $ii = 0; $ii < $nbli; $ii++) {
        my $lue = &uie::check8err(obj=>&analyze8line(lin=>$fifi->[$ii]),
                                  sig=>"(Called by $nsub)");
        if ($lue->{y} eq "cir") {
            # it is a circumstance line
            if ($lue->{l} eq "0") {
                # it is a title line
                $titre = splice(@$fifi,$ii,1);
                $titre =~ s/<\(0\)>//;
                $titre =~ s/^\s+//;
                $titre =~ s/\s+$//;
            }
        }
        if ($titre) { last;}
    }
    # default title
    unless ($titre) {
        $titre = $roo;
    }
    # looking for the category definitions (not used for the moment)
    my $catd = {};
    $nbli = scalar(@$fifi) - 1;
    for (my $ii = $nbli; $ii >= 0; $ii--) {
        if ($fifi->[$ii] =~ /^\Q$idrf{g}\E/) {
            my $categ = splice(@$fifi,$ii,1);
            $categ =~ s/\s+$//;
            my @dd = split(/ /,$categ);
            if (scalar(@dd) < 3) {
                print "<$categ>\n";
                my $rr = add8err(err=>"",nsu=>$nsub,
                                 erm=>["A category line must comprise at least three words"]);
                return $rr;
            }
            shift @dd; my $ide = shift @dd;
            $catd->{$ide} = join(" ",@dd);
        }
    }
    ########################################################
    # filling the parameters for the beginning of the latex file
    foreach (keys %pls) {
        if (defined($ppa->{$_})) { $pls{$_} = $ppa->{$_};}
    }
    if ($titre) { $pls{tit} = $titre;}
    # filling the parameters for the corpus of the latex file
    foreach (keys %plt) {
        if (defined($ppa->{$_})) { $plt{$_} = $ppa->{$_};}
    }
    # modifying the default framing for the picture captions
    if (defined($ppa->{cfraon})) { $cfra{n}[0] = $ppa->{cfraon};}
    if (defined($ppa->{cfraot})) { $cfra{t}[0] = $ppa->{cfraot};}
    if (defined($ppa->{cfraop})) { $cfra{p}[0] = $ppa->{cfraop};}
    if (defined($ppa->{cfraoq})) { $cfra{q}[0] = $ppa->{cfraoq};}
    if (defined($ppa->{cfraog})) { $cfra{g}[0] = $ppa->{cfraog};}
    if (defined($ppa->{cfraok})) { $cfra{k}[0] = $ppa->{cfraok};}
    if (defined($ppa->{cfraom})) { $cfra{m}[0] = $ppa->{cfraom};}
    #
    if (defined($ppa->{cfracn})) { $cfra{n}[1] = $ppa->{cfracn};}
    if (defined($ppa->{cfract})) { $cfra{t}[1] = $ppa->{cfract};}
    if (defined($ppa->{cfracp})) { $cfra{p}[1] = $ppa->{cfracp};}
    if (defined($ppa->{cfracq})) { $cfra{q}[1] = $ppa->{cfracq};}
    if (defined($ppa->{cfracg})) { $cfra{g}[1] = $ppa->{cfracg};}
    if (defined($ppa->{cfrack})) { $cfra{k}[1] = $ppa->{cfrack};}
    if (defined($ppa->{cfracm})) { $cfra{m}[1] = $ppa->{cfracm};}
    # modifying the default separators for the picture captions
    if (defined($ppa->{sepbp})) { $sepb{p} = $ppa->{sepbp};}
    if (defined($ppa->{sepbq})) { $sepb{q} = $ppa->{sepbq};}
    if (defined($ppa->{sepbg})) { $sepb{g} = $ppa->{sepbg};}
    if (defined($ppa->{sepbk})) { $sepb{k} = $ppa->{sepbk};}
    if (defined($ppa->{sepbm})) { $sepb{m} = $ppa->{sepbm};}
    # monitoring label within image grids
    my $gilab = 1;
    if (defined($ppa->{gilab})) { $gilab = $ppa->{gilab};}
    # starting the output file
    push @$cod,@{&lhattmel::start(par=>\%pls,typ=>$typ)};
    my $hhh = &uie::copy8structure(str=>$cdefa);
    my $nbeil = 0; # the number of expected image lines, when positive
                   # an image line must be found!
    my $taim = [];
    # dealing the input file line by line
    foreach my $lig (@$fifi) {
        print "-(<$lig)>-\n";
        my $lue = &analyze8line(lin=>$lig);
        if (&uie::err9(obj=>$lue)) {
            # the line was not consistent
            my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                    erm=>["Found a non acceptable line",
                                          "<$lig>"]);
            $rrr = &uie::conca8err(er1=>$rrr,er2=>$lue);
            return $rrr;            
        }
        if ($lue->{y} eq "cir") {
            #  a circumstance line is identified
            if ($nbeil > 0) {
                $res = &uie::add8err(err=>"no",nsu=>$nsub,erm=>
                ["A IMAGE LINE WAS EXPECTED since nbeil = $nbeil ",
                 "  instead of the following line was found:",
                 "  <$lig>\n",
                 "Probably the number of images indicated in the technical",
                 " parameters must be revised?",
                 "Be aware that technical parameters are not following the hierarchy changes",
                 "and are reported until a change from an 'eif' to a 'dif' !",
                 "TO BE FIXED\n"]);
                return $res;
            }
            my $niv = $lue->{l}; unless ($plt{nus}) { $niv = -$niv;}
            push @$cod,@{&lhattmel::subtit(tit=>$lue->{c},lev=>$niv,typ=>$typ)};
        } elsif ($lue->{y} eq "add") {
            # an additional collective line is identified
            $lue = &uie::check8err(obj=>&new7pi(wha=>$lue));
            if ($nbeil > 0) {
                $res = &uie::add8err(err=>"no",nsu=>$nsub,erm=>
                ["A IMAGE LINE WAS EXPECTED since nbeil = $nbeil ",
                 "  instead of the following line was found:",
                 "  <$lig>\n",
                 "Probably the number of images indicated in the collective technical",
                 " parameters must be revised?",
                 "Be aware that technical parameters are not following the hierarchy changes",
                 "and are reported until a change from an 'eif' to a 'dif' !",
                 "TO BE FIXED\n"]);
                return $res;
            }
            # introducing the possible comments
            push @$cod,@{&lhattmel::parag(prg=>$lue->{m},typ=>$typ)};
            # introducing the possible time
            if ( $lue->{t} ) {
                my $temps = $lue->{t};
                $temps =~ s/_/-/g; # to prevent the underscore not compatible with latex
                push @$cod,@{&lhattmel::parag(prg=>["$ipi{t}: $temps"],typ=>$typ)};
            }
            # introducing the possible other pi's
            for my $pi ("p","q","k","g") { if ($cap =~ /\Q$pi\E/) { 
                if ( scalar(@{$lue->{$pi}}) ) {
                    my @intro = @{$lue->{$pi}};
                    $intro[0] = $ipi{$pi}.$intro[0];
                    push @$cod,@{&lhattmel::parag(prg=>\@intro,typ=>$typ)};
                }
            }}
            # deal with the possible technical parameters
            if (defined($lue->{h})) {
                ## resetting values
                # is it a void TP?
                my $vtp = keys %{$lue->{h}};
                my @sau = ($hhh->{WID},$hhh->{HEI});
                $hhh = &uie::copy8structure(str=>$cdefa);
                if ($vtp) {
                    $hhh->{WID} = $sau[0];
                    $hhh->{HEI} = $sau[1];
                } 
                # introducing the new values
		foreach my $kk ("wid","hei","WID","HEI","nbi","gnl","gnc","cap") {
		    if (defined($lue->{h}->{$kk})) {
			if ($kk !~ /(hei)|(wid)|(HEI)|(WID)|(cap)/) {
			    if (looks_like_number($lue->{h}->{$kk})) {
				if ($kk eq "nbi") { $nbeil = $lue->{h}->{$kk};}
			    } else {
				&uie::pause(mes=>"WARNING: \$lue->{h}->{$kk} = $lue->{h}->{$kk} must be a number.");
			    }
			}
			$hhh->{$kk} = $lue->{h}->{$kk};
		    }
		}
	    }
        } elsif ($lue->{y} eq "ext") {
            # an additional paragraph is to introduce
            push @$cod,@{&lhattmel::parag(prg=>[$lue->{p}],typ=>$typ)};
        } elsif ($lue->{y} eq "spe") {
            # a user specific command has to be introduced
            my $lili = $lue->{c};
            unless (defined($lili)) {
                $res = &uie::add8err(err=>"no",nsu=>$nsub,erm=>
                ["THE CONTENT OF A SPECIFIC LINE WAS NOT FOUND ",
                 "  here is the line:",
                 "\n  <$lig>\n",
                 "phoges error?",
                 "TO BE FIXED\n"]);
                return $res;
            }
            # getting its type
            my $stype = "none";
            foreach my $tty ("l","h") {
                if ($lili =~ /^$telquel{$tty}/) {
                    $stype = $tty; $lili =~ s/^$telquel{$tty}//;
                }
            }
            if ($stype eq "none") {
                $res = &uie::add8err(err=>"no",nsu=>$nsub,erm=>
                ["THE PREFIX OF A SPECIFIC LINE WAS NOT FOUND ",
                 "  here is the line:",
                 "\n  <$lig>\n",
                 "phoges error?",
                 "TO BE FIXED\n"]);
                return $res;
            }
            push @$cod,$lili;
        } else {
            ## an image line is expected
            unless ($lue->{y} eq "ind") {
                $res = &uie::add8err(err=>"no",nsu=>$nsub,erm=>
                ["A IMAGE LINE WAS EXPECTED ",
                 "  instead of the following line was found:",
                 "\n  <$lig>\n",
                 "Bad syntax?",
                 "TO BE FIXED\n"]);
                return $res;
            }
            #
            if ($nbeil > 0) { $nbeil--;}
            # preparing the caption
            my @caption = ();
            #----------------<START of lege>-------------------------------------
            sub lege {
                # builds a component of the caption, 
                # needs an array of references
                #  [0] the component to possibly deal with (e.g. 'n' or 'q')
                #  [1] string of the components to be deal with (e.q. 'nmt' or 'nmtpqkg')
                #  [2] the xpi, from which the component is extracted
                #  [3] ??? seems not to be used ???
                my $q = shift @_; my $cap = shift @_; my $lue = shift @_; my $typ = shift @_;
                my $ax = "";
                if ($cap =~ /\Q$q\E/) {
                    # this component must be included
                    $ax = "";
                    if ("nt" =~ /\Q$q\E/) {
                        # it is a scalar component
                        $ax = $lue->{$q};
                    } else {
                        # it is a vectorial component
                        $ax = join($sepb{$q},@{$lue->{$q}});
                    }
                    #
                    if ($ax eq "") {
                        # no value was given
                        if ($cap =~ /X/) {
                            # but missing values must be indicated
                            if ($cap =~ /I/) { $ax = $ipi{$q};} # identification of the component is asked for
                            $ax = $ax."???";
                        }
                    } else {
                        # some information was provided
                        if ($cap =~ /I/) { $ax = $ipi{$q}.$ax;} # identification of the component is asked for
                        # adding the frame
                        $ax = $cfra{$q}[0].$ax.$cfra{$q}[1];
                        # to avoid '_' not very compatible with latex
                        $ax =~ s/_/-/g;
                    }
                }
                $ax;
            }
            #----------------<END of lege>-------------------------------------
            # loading the individual technical paramaters
            my $hhi = &uie::copy8structure(str=>$idefa);
            foreach my $tk (keys %$hhi) {
                if (defined($lue->{h}->{$tk})) {
                    $hhi->{$tk} = $lue->{h}->{$tk};
	        }
            }
            # fitting them with the collective parameters
            my $didi = (($hhi->{wid} ne "") or ($hhi->{hei} ne ""));
            unless ($didi) { 
                # wid/WID hei/HEI are considered
                for my $dime ("wid","hei") {
                    if ($hhh->{$dime} eq "") {
                        $hhi->{$dime} = $hhh->{uc($dime)};
                    } else {
                        $hhi->{$dime} = $hhh->{$dime};
                    }
                }
	    }
            #
            for my $quoi ('n','t','p','q','k','g','m') {
                my $aj = &lege($quoi,$cap,$lue,$typ);
                if ($aj) { push @caption,$aj;}
            }
            #
            my $lopt = "H";
            if ($cap =~ /B/) { $lopt = $lopt."l";}
            if ($cap eq "") { $lopt = $lopt."X";}
            my $nima = {fil=>$lue->{n},cap=>\@caption};
            #----------------<START of redu>-------------------------------------
            sub redu { my $cha = $_[0];
           	       my ($val) = $cha =~ /(\d+)/; $val = $val * $plt{red};
           	       my ($uni) = $cha =~ /([a-zA-Z]+)/;
           	       $val.$uni;
                     }
            #----------------<END of redu>-------------------------------------
            if ($hhi->{wid} ne "") { $nima->{wid} = &redu($hhi->{wid});}
            if ($hhi->{hei} ne "") { $nima->{hei} = &redu($hhi->{hei});}
            if ($hhi->{rot} != 0 ) { $nima->{rot} = $hhi->{rot};}
            push @$taim,$nima;
            if ($nbeil == 0) {
                unless ($gilab) {$lopt = $lopt."X";} # removing labels to images in grid
                push @$cod,@{&lhattmel::picture(ima=>$taim,
                                                dim=>[$hhh->{gnl},$hhh->{gnc}],
                                                cca=>[$hhh->{cap}],
                                                opt=>$lopt."b",
                                                typ=>$typ)};
                # resetting
                $taim = [];
                for my $rt ("nbi","gnl","gnc","cap") {
                    $hhh->{$rt} = $cdefa->{$rt};
                }
            }
        }
    }
    if (scalar(@$taim)) { 
        &uie::la(str=>$taim);
        &uie::pause(mes=>"some final image(s) was not included!");
    }
    # ending the output file
    push @$cod,@{&lhattmel::end(typ=>$typ)};
    # creating the output file
    unless (open(TOUTOU,">$ouf")) {
        $res = &uie::add8err(err=>"",nsu=>$nsub,
                             erm=>["Not possible to open <$ouf> as an output file!"]);
        return $res;
    }
    foreach (@$cod) { print TOUTOU $_,"\n";}
    close TOUTOU;
    # returning
    $res;
}
#############################################
#
##<<
sub analyze8series {
    #
    # title : get the values of a line similar to technical ones
    #
    # aim : an axillary function to aliviate
    #      and secure the programming task
    #      when getting different components similar to
    #      technical parameters
    #
    # output : an error object if something
    #         was wrong, if not a hash with
    #         different components using natural keys
    #
    # arguments
    my $hrsub = {lin  =>[undef, "uc","The string to analyze"],
                 sep  =>[undef, "c","Separators between components"],
                 def  =>[   {}, "h","Default values for some components"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $lin = $argu->{lin};
    my $sep = $argu->{sep};
    my $def = $argu->{def};
    # initialization
    my $res   = {};
    unless (defined($lin)) { return undef;}
    my @tpa = split(/\Q$sep\E/,$lin);
    # storing the proposed values
    foreach my $hh (@tpa) { 
        if ( $hh =~ /^\s*(\S*)\s*=\s*(.*)\s*$/ ) {
            $res->{$1} = $2;
        }
    }
    # completing with the default values
    foreach my $cle (keys %$def) {
        unless(defined($res->{$cle})) { $res->{$cle} = $def->{$cle};}
    }
    # returning
    $res;
}
#############################################
#
##<<
sub analyze8kwd {
    #
    # title : get the values of a line similar to keywords
    #
    # aim : the difficulty is that keywords can comprise
    #      several words indicated with some framing
    #
    # output : an error object if something
    #         was wrong, if not an array reference giving
    #         in the same order the different components
    #
    # arguments
    my $hrsub = {lin  =>[              undef, "c","The string to analyze"],
                 sep  =>[           $sepa{k}, "c","Separator between components"],
                 fra  =>[[$can{ko},$can{kc}], "a","Framing for multiple word components"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $lin = $argu->{lin};
    my $sep = $argu->{sep};
    my $fra = $argu->{fra};
    # initialization
    my $res   = [];
    # getting the components
    my $ax = &uie::juste(cha=>$lin,jus=>"n",spa=>"s");
    my @ax = split(/\Q$sep\E/,$ax);
    my $err = &uie::add8err(err=>"no",nsu=>$nsub,
                            erm=>[$lin,
                            "Unaccepted string as a series of keywords!",
                            "Probably some bad matching with $fra->[0] and $fra->[1]?"]);
    $ax = 0; my ($cnt,$cas);
    foreach my $bx (@ax) {
        # detecting the case
        if ( $bx =~ /^\Q$fra->[0]\E(.*)\Q$fra->[1]\E$/ ) {
            # framing both sides
            if ($ax) { return $err;}
            $cnt = $1; $cas = 3; $ax = 0;
        } elsif (  $bx =~ /^\Q$fra->[0]\E(.*)$/ ) {
            # framing at the beginning
            if ($ax) { return $err;}
            $cnt = $1; $cas = 1; $ax = 1;
        } elsif (  $bx =~ /(.*)\Q$fra->[1]\E$/ ) {
            # framing at the end
            unless ($ax) { return $err;}
            $cnt = $cnt." ".$1; $cas = 2; $ax = 0;
        } else {
            # without any framing
            if ($ax) {
                $cnt = $cnt." ".$bx; $cas = 0; $ax = 1;
            } else {
                $cnt = $bx; $ax = 0;
            }
        }
        # action
        unless ( $ax ) {
            push @$res,&uie::juste(cha=>$cnt,jus=>"n",spa=>"s");
        }
    }
    # returning
    $res;
}
#############################################
#
##<<
sub update8st7pi {
    #
    # title : replace shortcuts by their values
    #
    # aim : copy and transform a [ind,col] pi replacing
    #      and relocalizing shortcuts with
    #      their associated values.
    # 
    # output : an error object if something
    #         was wrong, if not the transformed
    #         pi.
    #
    #
    # arguments
    my $hrsub = {xpi  =>[undef,  "h","Initial pi's with possible shortcuts"],
                 stc  =>[   {},  "h","Definition of the shortcuts, as provided",
                                     "by 'read8st7f"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $xpi = $argu->{xpi};
    my $stc = $argu->{stc};
    my $res = &uie::copy8structure(str=>$xpi);
    ## checking the type 
    if (($res->{y} ne "col") and ($res->{y} ne "ind")) {
        my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                erm=>["pi with type $res->{y} must not be proposed for shortcut replacement"]);
    }
    my $llev;
    my $col = 0;
    if ($res->{y} eq "col") { $col = 1; $llev = scalar(@{$res->{k}}) - 1;}
    ## proceeding
    my @geke = ("p","q","g","k");
    foreach my $k (@geke) {
        # for each component of the present pi's
        my $kl;
        if ($col) { 
            $kl = scalar(@{$res->{$k}->[$llev]})-1;
        } else {
            $kl = scalar(@{$res->{$k}})-1;
        }
        for (my $kk = $kl; $kk >= 0; $kk--) {
            # for each of its values
            foreach my $kka (@geke) {
                my $kkk = $idrf{$kka};
                # for each possible shortcut
                my $vval;
                if ($col) {
                    $vval = $res->{$k}->[$llev]->[$kk];
                } else {
                    $vval = $res->{$k}->[$kk];
                }
                if (defined($stc->{$kkk}->{$vval})) {
                    # the value a shortcut?
                    if ($k eq $kka) {
                        # for the same type
                        unless ($k eq "g") {
                            # not for category, just the other
                            if ($col) {
                                $res->{$k}->[$llev]->[$kk] = $stc->{$kkk}->{$res->{$k}->[$llev]->[$kk]};
                            } else {
                                $res->{$k}->[$kk] = $stc->{$kkk}->{$res->{$k}->[$kk]};
                            }
                        }
                    } else {
                        # the type is different, must be shift
                        if ($kka eq "g") {
                            # category exception
                            if ($col) {
                                #push $res->{$kka}->[$llev],$res->{$k}->[$llev]->[$kk];
                                push @{$res->{$kka}->[$llev]},$res->{$k}->[$llev]->[$kk];
                            } else {
                                #push $res->{$kka},$res->{$k}->[$kk];
                                push @{$res->{$kka}},$res->{$k}->[$kk];
                            }
                        } else {
                            # other keywords
                            if ($col) {
                                #push $res->{$kka}->[$llev],$stc->{$kkk}->{$res->{$k}->[$llev]->[$kk]};
                                push @{$res->{$kka}->[$llev]},$stc->{$kkk}->{$res->{$k}->[$llev]->[$kk]};
                            } else {
                                #push $res->{$kka},$stc->{$kkk}->{$res->{$k}->[$kk]};
                                push @{$res->{$kka}},$stc->{$kkk}->{$res->{$k}->[$kk]};
                            }
                        }
                        if ($col) {
                            #splice $res->{$k}->[$llev],$kk,1;
                            splice @{$res->{$k}->[$llev]},$kk,1;
                        } else {
                            #splice $res->{$k},$kk,1;
                            splice @{$res->{$k}},$kk,1;
                        }
                    }
                    last;
                }
            }
        }
    }
    # returning
    $res;
}
#############################################
#
##<<
sub col7pi2ind7pi {
    #
    # title : prepare a individual pi's
    #
    # aim : using the current collective pi's
    #        adapt an individual pi's according
    #        to the planned file (dif/icf).
    # 
    # output : an error object if something
    #         was wrong, if not a hash with
    #         different pi's corresponding
    #         to the individual pi series.
    #
    # remarks: only for 'icf' output, the individual pi is
    #          modified. This is done with the following rules.
    #         (i) escaped pi's are left are they are
    #             (escaping commands are looked within the
    #              categories).
    #         (ii) collective time is used only when there
    #              is no individual time. Nevertheless, missing
    #              year can be taken from the collective time.
    #         (iii) collective technical parameters are used
    #               when there are no individual ones.
    #         (iii) collective directory is integrated if any
    #         (iv) p-q-k-g-m pi's are integrated
    #         (v) the stack of circumstances is introduced
    #
    # arguments
    my $hrsub = {cpi  =>[undef,  "h","collective pi's"],
                 ipi  =>[undef,  "h","Individual pi's to adjust"],
                 lpi  =>[undef,  "h","pi's of the last image in case of 'identical'"],
                 whi  =>[undef,  "c","'dif' or 'icf' to indicate which type of file",
                         "will be created"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $cpi = $argu->{cpi};
    my $ipi = $argu->{ipi};
    my $lpi = $argu->{lpi};
    my $whi = $argu->{whi};
    if ($whi eq "dif") { return $ipi;}
    my $rrr = "";
    unless ($whi eq "icf") {
        $rrr = &uie::add8err(err=>$rrr,nsu=>$nsub,
                             erm=>["Proposed 'whi' argument ($whi) not accepted",
                                   "(must be 'dif' or 'icf')."]);
    }
    my $res = &uie::copy8structure(str=>$ipi);
    # getting first the possible commands
    my $ident = 0; my $escap = "";
    my @cate = [];
    if (defined($ipi->{g})) { @cate = @{$ipi->{g}};}
    foreach (@cate) {
        if (($_ =~ /^${kom}I${kom}$/) and ($ident < 1)) { $ident = 1;}
        if ($_ =~ /^${kom}c${kom}$/) { $escap = $escap."c";}
        if ($_ =~ /^${kom}t${kom}$/) { $escap = $escap."t";}
        if ($_ =~ /^${kom}p${kom}$/) { $escap = $escap."p";}
        if ($_ =~ /^${kom}q${kom}$/) { $escap = $escap."q";}
        if ($_ =~ /^${kom}k${kom}$/) { $escap = $escap."k";}
        if ($_ =~ /^${kom}m${kom}$/) { $escap = $escap."m";}
        if ($_ =~ /^${kom}h${kom}$/) { $escap = $escap."h";}
        if ($_ =~ /^${kom}A${kom}$/) { $escap = $escap."ctpqkmh";}
        if ($_ =~ /^${kom}K${kom}$/) { $escap = $escap."k";}
        if ($_ =~ /^${kom}C${kom}$/) { $escap = $escap."cm";}
    }
    # time period
    unless (defined($ipi->{t})) {
        # no individual time
        if ($ident) {
            # possibly getting the last time
            if (defined($lpi->{t})) { $res->{t} = $lpi->{t};}
        } else {
            # possibly getting the collective time
            unless ($escap =~ /t/) {
                $res->{t}->[0] = &get8date(nam=>$ipi->{n}->[0],tim=>$cpi->{t}->[0]);
            }
        }
    }
    # hierarchical array pi's
    my $nbc = scalar(@{$cpi->{c}}) - 1;
    # cumulating the circumstances
    @{$res->{c}} = @{$cpi->{c}};
    foreach my $kpi ("p","q","g","k","m") { unless ($escap =~ /\Q$kpi\E/) {
        # cumulating the complete hierarchy
        my @cumu = ();
        for (0..$nbc) { if ($cpi->{$kpi}->[$_]->[0]) {
            push @cumu,@{$cpi->{$kpi}->[$_]};
        }}
        if ($ipi->{$kpi}->[0]) { push @cumu,@{$ipi->{$kpi}};}
        @{$res->{$kpi}} = @cumu;
    }}
    # directory pi
    unless ($escap =~ /d/) {
        my @cumu = ();
        if ($cpi->{d} ne "") { push @cumu,$cpi->{d};}
        if ($ipi->{d} ne "") { push @cumu,$ipi->{d};}
        $res->{d} = join($sepa{d},@cumu);
    }
    # technical parameter pi
    unless ($escap =~ /h/) {
        for my $ke (keys %{$cpi->{h}}) {
            unless (defined($ipi->{h}->{$ke})) {
                $res->{h}->{$ke} = $cpi->{h}->{$ke};
            }
        }
    }
    # final check
    my $resu = &check8pi(xpi=>$res);
    if (&uie::err9(obj=>$resu)) {
        # program error!
        &uie::la(str=>$res);
        $res = &uie::add8err(err=>"",nsu=>$nsub,
                         erm=>["Bad result, programming error... Sorry for that"]);
        $res = &uie::conca8err(er1=>$res,er2=>$resu);
    }
    # returning
    if (&uie::err9(obj=>$rrr)) { return $rrr;}
    $res;
}
#############################################
#
#
##<<
sub ei7f2di7f1ic7f {
    #
    # title : transforming an eif into a dif or a icf
    #
    # aim : produces either a decoded index file (dif) 
    #      or a image centered file (icf) from an edited
    #      index file (eif)
    # 
    # output : 1 when the analysis of the edited
    #         file was without trouble, if not an 
    #         error message testable with '&uie::err9'
    #         and printable with '&uie::print8err'.
    #
    #   The definition of shortcuts for people, categories and keywords
    #         can be done within the eif and/or through specialized
    #         stf files indicated with a stf line.
    #
    #   A dif is just the eif after:
    #           - replacing shortcuts by their value (except for categories)
    #           - including all used categories within the index file
    #             (and only the necessary ones)
    #           - attributing at an individual level time period,
    #             place, people, category, keyword.
    #
    #   A icf is the list of images after integrating in them all
    #           collective attributions, including the title,
    #           only are left the directory lines and those
    #           defining the categories plus, of course, image lines.
    #
    #   To the transformation can be added a selection of the retained
    #          images according to some criteria (defined in a slf file).
    #
    #   BE AWARE THAT SOME COLLECTIVE PI'S CAN BE LOST if not associated to 
    #          a set of images. The aim is to annotate, not to build a text,
    #          so information not focused to annotation of pictures is 
    #          not considered.
    #
    #   Nevertheless, you can write paragraphs (then also lists, see lhattmel::parag
    #          subroutine) with the specific lines starting with (*).
    #
    #   To give more flexibility in producing documents, specific lines are
    #          reproduce without interpretation or checking in the dif file. These are
    #          marked up with values of %telquel.
    #
    #   As the subroutine is quite long and intricated, possible intermediary
    #          printing can be asked by modifying the local variable $impint.
    #
    # arguments
    my $hrsub = {eif  =>[undef,  "c","The root of the edited index file to transform",
                                     "('-eif.txt' suffix will be added)."],
                 out  =>[undef,  "c","The root of the transformed file to create",
                                     "('-dif.txt' or '-icf.txt' suffix will be added)."],
                 typ  =>["dif",  "c","Type of the created file if not must be 'icf'"],
                 new  =>[    1,  "n","Must not the 'out' file to already exist?",
                                     "If so a message error is issued."],
                 slf  =>[   "",  "c","Root of the selection definition file to use",
                                     "when '', no selection is performed",
                                     "('-slf.txt' suffix will be added)."]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $eif = $argu->{eif}; $eif = $eif."-eif.txt";
    my $typ = $argu->{typ};
    my $dif = 1; if ($typ eq "icf") { $dif = 0;} else { $typ = "dif";}
    my $out = $argu->{out}; $out = $out."-$typ.txt";
    my $new = $argu->{new};
    my $slf = $argu->{slf}; unless ($slf eq "") { $slf = $slf."-slf.txt";}
    my $res = 1;
    # to print intermediate results
    my $impint = "pau.ipi.cpi.sel.pi.ima.cat.kwd.lig";
    $impint = "ima";
    $impint = "pau.cat.kwd";
    $impint = "ima";
    $impint = "ppi.pau";
    $impint = "ima.pau";
    $impint = "lig";
    $impint = "pau.ipi.cpi.sel.pi.ima.cat.kwd.lig";
    $impint = "pau.stf";
    $impint = "sel.pau";
    $impint = "pau";
    # reading the input file
    my $fifi = &uie::read8line(fil=>$eif);
    if (&uie::err9(obj=>$fifi)) {
        $res = &uie::add8err(err=>"",nsu=>$nsub,
                             erm=>["Bad reading for $eif as an edited index file"]);
        $res = &uie::conca8err(er1=>$res,er2=>$fifi);
        return $res;
    }
    # reading the slf file
    my $selec = undef;
    unless ($slf eq "") {
        $selec = &uie::check8err(obj=>&read8sl7f(fil=>$slf),sig=>$nsub);
        if ($impint =~ /slf/) {
            &uie::print8structure(str=>$selec);
            if ($impint =~ /pau/) { &uie::pause(mes=>"The selection criteria");}
        }
    }
    # openning the output file
    if ($new) {
        if (-e $out) {
            $res = &uie::add8err(err=>"",nsu=>$nsub,
                                 erm=>["File $out already exists and appending isn't accepted!"]);
            return $res;
        }
    }
    unless (open(TOUTOU,">>$out")) {
        $res = &uie::add8err(err=>"",nsu=>$nsub,
                             erm=>["Not possible to open $out file!"]);
        return $res;
    }
    # some informative lines
    print TOUTOU "# \n";
    print TOUTOU "# file created/completed by '&phoges::ei7f2di7f1ic7f' on ",
                 &uie::now(fmt=>""),"\n";
    print TOUTOU "# the input eif file was $eif \n";
    if ($slf eq "") {
        print TOUTOU "# no slf file was used \n";
    } else {
        print TOUTOU "# the input slf file was $slf \n";
    }
    if ($dif) {
        print TOUTOU "# a dif (decoded index file) was asked for \n";
    } else {
        print TOUTOU "# a icf (image centered file) was asked for \n";
    }
    print TOUTOU "# \n# \n";
    #
    unless ($dif) {
        # opening the first block
        print TOUTOU "<<<IMA>>>\n";
    }
    # initializations
    my @cico = (); # to store the circumstance comments when ($dif = 0)
                   # for the second bloc 'CIR'
    my $colpi  = &new7pi(wha=>"col"); # to store the current collective pi's
    my $laspic = &new7pi(wha=>"ind"); # last picture to refer to it
    my $pkad = {}; # to store the collection of shortcuts
    my $reline; # retired line
    my $nbli = scalar(@$fifi) - 1; # number of lines of the eif to exploit
    # looking for possible stf files to read
    $nbli = scalar(@$fifi) - 1;
    for (my $ii = $nbli; $ii >= 0; $ii--) {
        if ($fifi->[$ii] =~ /^\Q$idif{stf}\E/) {
            my $line = splice(@$fifi,$ii,1);
            my @ax = split(" ",$line);
            if (scalar(@ax) != 2) {
                $res = &uie::add8err(err=>"",nsu=>$nsub,
                                     erm=>["'$idif{stf}' lines must comprise only 2 words",
                                           $line." was found."]);
            } else {
                $pkad = &read8st7f(fil=>$ax[1],ref=>$pkad);
                if (&uie::err9(obj=>$pkad)) {
                    $res = &uie::conca8err(er1=>$res,er2=>$pkad);
                }
                if ($impint =~ /stf/) {
                     &uie::print8structure(str=>$pkad);
                     if ($impint =~ /pau/) { &uie::pause(mes=>"stf content after $ax[1]");}
                }
            }
        }
    }
    # getting the shortcuts included in the eif file
    $pkad = &read8st7f(fil=>$eif,ref=>$pkad);
    if (&uie::err9(obj=>$pkad)) {
        $res = &uie::conca8err(er1=>$res,er2=>$pkad);
    }
    if ($impint =~ /stf/) {
         &uie::print8structure(str=>$pkad);
         if ($impint =~ /pau/) { &uie::pause(mes=>"stf content after the $eif file");}
    }
    # getting rid of the possible shortcut lines
    $nbli = scalar(@$fifi) - 1;
    for (my $ii = $nbli; $ii >= 0; $ii--) {
        my $faite = 0;
        foreach my $indi (values(%idrf)) {
            if ($fifi->[$ii] =~ /^$indi\s/) {
                my $line = splice(@$fifi,$ii,1);
                $faite = 1;
            }
        }
    }
    # looking for the compulsory title line
    $nbli = scalar(@$fifi) - 1;
    my $titre = 0;
    for (my $ii = 0; $ii < $nbli; $ii++) {
        my $lue = &uie::check8err(obj=>&analyze8line(sht=>$pkad,lin=>$fifi->[$ii]),
                                  sig=>"(Called by $nsub)");
        if ($lue->{y} eq "cir") {
            # it is a circumstance line
            if ($lue->{l} eq "0") {
                # it is a title line
                $titre = 1;
                $colpi = &uie::check8err(obj=>&update8col7pi(cop=>$colpi,sup=>$lue),
                                                    sig=>"In $nsub, the proposed title failed!");
                $reline = splice(@$fifi,$ii,1);
            }
        }
        if ($titre) { last;}
    }
    unless ($titre) {
        $res = &uie::add8err(err=>"",nsu=>$nsub,
                             erm=>["No title was found in $eif.",
                                   "However it is compulsory and must be unique.",
                                   "Must be given as a line:",
                                   $fram{"C"}->[0]."0".$fram{"C"}->[1]." Un Titre Informatif et Attractif"]);
        return $res;
    }
    if ($dif) { print TOUTOU "$reline\n";}
    else { push @cico,("$reline");}
    #
    # exploring the different lines
    my $newpic = 1; # indication that a new sequence of picture has to be started
    foreach my $li (@$fifi) {
        # dealing with a line
        if ($impint =~ /lig/) { print "<<|| $li|| >>\n"; }
        # dealing with possible specific line to reproduce
        my $speci = 0;
        foreach my $tag (values %telquel) { if ($li =~ /^$tag/) { $speci = 1;} }
        if ($speci) {
            # line to copy as it is
            print TOUTOU $li,"\n";
        } else {
            # line to be analyzed
	    my $lue = &uie::check8err(obj=>&analyze8line(sht=>$pkad,lin=>$li),sig=>"(From $nsub [1])");
	    # 
	    unless ($lue->{y} eq "ind") {
		# it is not a line describing an image
		if ($lue->{y} eq "ext") {
		    # it is an external paragraph
		    if ($dif) { print TOUTOU $li,"\n";}
		    # forgotten line for ICF
		} else {
		    if ($lue->{y} eq "cir") {                 # a new circumstance occurs
			#($li eq $fifi->[scalar(@$fifi)-1]) ) {  # or it is the last line: doesn't care
			# must the col pit be written? NEVER: GOAL IS ANNOTATION!
			# it is a new circumstance
			my $cirm = &pi2line(xpi=>$lue);
			if ($dif) { print TOUTOU $cirm,"\n";}
			else { push @cico,($cirm);}
		    }
		    # the current collective pi's must be updated
		    $colpi = &uie::check8err(obj=>&update8col7pi(cop=>$colpi,sup=>$lue),
					     sig=>"(From $nsub [1])");
		    # 
		    $newpic = 1; # a new sequence of image has to be started
		}
	    } else {
		# the line describes a new image
		# is this image selected?
		my $imasel = 1;
		if ($selec) {
		    # incoporating the collective pi's in the found image
		    my $sima = &uie::check8err(obj=>&col7pi2ind7pi(cpi=>$colpi,ipi=>$lue,lpi=>$laspic,whi=>"icf"),
					      sig=>"(From $nsub [-2])");
		    # replacing shortcuts with their values
		    $sima = &update8st7pi(xpi=>$sima,stc=>$pkad);
		    unless (&uie::check8err(obj=>&select8image(ima=>$sima,cri=>$selec))) {
			if ($impint =~ /sel/) {
			    &print8pi(xpi=>$sima); 
			    if ($impint =~ /pau/) { &uie::pause(mes=>"not selected");}
			    else { print "  -> not selected\n";}
			}
			$imasel = 0;
		    } else {
			if ($impint =~ /sel/) {
			    &print8pi(xpi=>$sima); 
			    if ($impint =~ /pau/) { &uie::pause(mes=>"SELECTED");}
			    else { print "  -> SELECTED\n";}
			}
		    }
		}
		if ($imasel) {
		    # incoporating the collective pi's in the found image
		    my $vam = &uie::check8err(obj=>&col7pi2ind7pi(cpi=>$colpi,ipi=>$lue,lpi=>$laspic,whi=>$typ),
					  sig=>"(From $nsub [2])");
		    # replacing shortcuts with their values
		    my $vamt = &update8st7pi(xpi=>$vam,stc=>$pkad);
		    # the image was selected, some writing to do
		    if ($newpic and $dif) {
			# write the additionnal pi after replacing its shortcuts
			my $colpit = &update8st7pi(xpi=>$colpi,stc=>$pkad);
			print TOUTOU &pi2line(xpi=>$colpit),"\n";
		    }
		    # write the picture itself
		    print TOUTOU &pi2line(xpi=>$vamt),"\n";
		    # keeping the future last picture
		    $laspic = &uie::copy8structure(str=>$vam);
		    $newpic = 0; # collective pi's already written in case of DIF
                    ## removing non permanent collective pi
                    for my $rt ("nbi","gnl","gnc","cap") {
                        $colpi->{h}->{$rt} = $cdefa->{$rt};
                    }

		}
	    }
	}
    }
    # introducting the categories
    my $nbcat = scalar(keys %{$pkad->{cat}});
    if ($nbcat) {
        print TOUTOU "# $nbcat categories were introduced\n";
        foreach (keys %{$pkad->{cat}}) {
            print TOUTOU "cat $_ $pkad->{cat}->{$_} \n";
        }
    }
    #
    unless ($dif) {
        # closing the first block
        print TOUTOU "<<</IMA>>>\n";
        # starting the second block
        print TOUTOU "<<<CIR>>>\n";
        foreach (@cico) {
            print TOUTOU $_,"\n";
        }
        # closing the second block
        print TOUTOU "<<</CIR>>>\n";
    }
    #
    close(TOUTOU);
    # returning
    $res;
}
#############################################
#
##<<
sub update8image4di7f {
    #
# faire plus général d'extraction de pi
    # title : updates a set of reduced images
    #
    # aim : produces images with convenient sizes
    #      from an original image base, accordingly
    #      with the dimensions they will be printed.
    #      Already prepared images are not rebuilt.
    #
    #      Basically three input are used:
    #         a dif file indicating which images
    #             are needed and the dimensions
    #             they will be displayed.
    #         a directory of original images, supposed
    #             to contain of the used images
    #         a directory where the reduced images
    #             will be stored, not repeated
    #             when present in the right sizes
    # 
    #      To which some specifications about the
    #             level of reduction to apply:
    #          (i) must it be computed on the
    #              /w/idth, the /h/eight, the /l/argest
    #              dimension of both, the /s/mallest of 
    #              both or the /a/rea.
    #              Notice that if the rotation is not 0
    #              or 180, width and height are shifted.
    #         (ii) how many pixels are asked for one inch
    #         
    #      Also, the desired accuracy to decide if
    #              a preexisting image must be rebuilt
    #              or not.
    #
    # notice that care can be taken from the portrait shots
    #        with the auto-orient option of ImageMagick::convert
    #
    # output : the number of replaced images
    #         or an error message when something went wrong
    #
    # remarks : x For simplicity, but not for safety original and reduced images 
    #             have the same name. To prevent the destruction of original
    #             images, when a replaced image has got more pixels that the
    #             original one, a precautionary question is raised on the screen.
    #             Nevertheless, it can be desactivated.
    #           x ImageMagick facilities are used for the reduction
    #           x Perl module Image::Size is used to know image dimensions
    #
    # arguments
    my $hrsub = {dif  =>[undef,  "c","Name root of the dif (decoded index file)"],
                 ori  =>[undef,  "c","Directory where the original images can be found"],
                 red  =>[undef,  "c","Directory where the reduced images can be found or must be introduced"],
                 opt  =>[{typ=>"a",ppi=>300}, "h","'typ' indicates the way the scale is computed as explained",
                                                "in the general comments. 'ppi' is the number of pixels per inch",
                                                "(Be aware that when changing any default value(s), all components",
                                                " of the hash must be provided: default is global"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $dif = $argu->{dif}; $dif = $dif."-dif.txt";
    my $ori = $argu->{ori};
    my $red = $argu->{red};
    my $opt = $argu->{opt};
    # initialization
    my $res = 0;
# à vérifier
my ($nbeil,$cap,$gilab,$cod,$typ,$ouf);
    # reading the input file
    my $fifi = &uie::read8line(fil=>$dif);
    if (&uie::err9(obj=>$fifi)) {
        $res = &uie::add8err(err=>"",nsu=>$nsub,
                             erm=>["Bad reading for $dif as an edited index file"]);
        $res = &uie::conca8err(er1=>$res,er2=>$fifi);
        return $res;
    }
    # default values for the collective technical parameters
    my $cdefa = {wid=>"",hei=>"",WID=>"",HEI=>"",                
                nbi=>1,gnl=>1,gnc=>1,cap=>""}; 
    # default values for the individual technical parameters
    my $idefa = {wid=>"",hei=>"",rot=>0}; 
    my $hhh = &uie::copy8structure(str=>$cdefa);
    my $taim = [];
    # dealing the input file line by line
    foreach my $lig (@$fifi) {
        print "-(<$lig)>-\n";
        my $lue = &analyze8line(lin=>$lig);
        if (&uie::err9(obj=>$lue)) {
            # the line was not consistent
            my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                    erm=>["Found a non acceptable line",
                                          "<$lig>"]);
            $rrr = &uie::conca8err(er1=>$rrr,er2=>$lue);
            return $rrr;            
        }
        if ($lue->{y} eq "cir") {
            #  a circumstance line is identified
        } elsif ($lue->{y} eq "add") {
            # an additional collective line is identified
            $lue = &uie::check8err(obj=>&new7pi(wha=>$lue));
            # deal with the possible technical parameters
            if (defined($lue->{h})) {
                ## resetting values
                # is it a void TP?
                my $vtp = keys %{$lue->{h}};
                my @sau = ($hhh->{WID},$hhh->{HEI});
                $hhh = &uie::copy8structure(str=>$cdefa);
                if ($vtp) {
                    $hhh->{WID} = $sau[0];
                    $hhh->{HEI} = $sau[1];
                } 
                # introducing the new values
		foreach my $kk ("wid","hei","WID","HEI","nbi","gnl","gnc","cap") {
		    if (defined($lue->{h}->{$kk})) {
			if ($kk !~ /(hei)|(wid)|(HEI)|(WID)|(cap)/) {
			    if (looks_like_number($lue->{h}->{$kk})) {
				if ($kk eq "nbi") { $nbeil = $lue->{h}->{$kk};}
			    } else {
				&uie::pause(mes=>"WARNING: \$lue->{h}->{$kk} = $lue->{h}->{$kk} must be a number.");
			    }
			}
			$hhh->{$kk} = $lue->{h}->{$kk};
		    }
		}
	    }
        } elsif ($lue->{y} eq "ext") {
            # an additional paragraph is to introduce
        } elsif ($lue->{y} eq "spe") {
            # a user specific command has to be introduced
        } else {
            ## an image line is expected
            unless ($lue->{y} eq "ind") {
                $res = &uie::add8err(err=>"no",nsu=>$nsub,erm=>
                ["A IMAGE LINE WAS EXPECTED ",
                 "  instead of the following line was found:",
                 "\n  <$lig>\n",
                 "Bad syntax?",
                 "TO BE FIXED\n"]);
                return $res;
            }
            #
            if ($nbeil > 0) { $nbeil--;}
            # preparing the caption
            my @caption = ();
            #----------------<START of lege>-------------------------------------
            sub legege {
                # builds a component of the caption, 
                # needs an array of references
                #  [0] the component to possibly deal with (e.g. 'n' or 'q')
                #  [1] string of the components to be deal with (e.q. 'nmt' or 'nmtpqkg')
                #  [2] the xpi, from which the component is extracted
                #  [3] ??? seems not to be used ???
                my $q = shift @_; my $cap = shift @_; my $lue = shift @_; my $typ = shift @_;
                my $ax = "";
                if ($cap =~ /\Q$q\E/) {
                    # this component must be included
                    $ax = "";
                    if ("nt" =~ /\Q$q\E/) {
                        # it is a scalar component
                        $ax = $lue->{$q};
                    } else {
                        # it is a vectorial component
                        $ax = join($sepb{$q},@{$lue->{$q}});
                    }
                    #
                    if ($ax eq "") {
                        # no value was given
                        if ($cap =~ /X/) {
                            # but missing values must be indicated
                            if ($cap =~ /I/) { $ax = $ipi{$q};} # identification of the component is asked for
                            $ax = $ax."???";
                        }
                    } else {
                        # some information was provided
                        if ($cap =~ /I/) { $ax = $ipi{$q}.$ax;} # identification of the component is asked for
                        # adding the frame
                        $ax = $cfra{$q}[0].$ax.$cfra{$q}[1];
                        # to avoid '_' not very compatible with latex
                        $ax =~ s/_/-/g;
                    }
                }
                $ax;
            }
            #----------------<END of lege>-------------------------------------
            # loading the individual technical paramaters
            my $hhi = &uie::copy8structure(str=>$idefa);
            foreach my $tk (keys %$hhi) {
                if (defined($lue->{h}->{$tk})) {
                    $hhi->{$tk} = $lue->{h}->{$tk};
	        }
            }
            # fitting them with the collective parameters
            my $didi = (($hhi->{wid} ne "") or ($hhi->{hei} ne ""));
            unless ($didi) { 
                # wid/WID hei/HEI are considered
                for my $dime ("wid","hei") {
                    if ($hhh->{$dime} eq "") {
                        $hhi->{$dime} = $hhh->{uc($dime)};
                    } else {
                        $hhi->{$dime} = $hhh->{$dime};
                    }
                }
	    }
            #
            for my $quoi ('n','t','p','q','k','g','m') {
# à vérifier
my $typ="";my $cap="";
                my $aj = &legege($quoi,$cap,$lue,$typ);
                if ($aj) { push @caption,$aj;}
            }
            #
            my $lopt = "H";
            if ($cap =~ /B/) { $lopt = $lopt."l";}
            if ($cap eq "") { $lopt = $lopt."X";}
            my $nima = {fil=>$lue->{n},cap=>\@caption};
            #----------------<START of redu>-------------------------------------
            sub redudu { my $cha = $_[0];
           	       my ($val) = $cha =~ /(\d+)/; $val = $val * $plt{red};
           	       my ($uni) = $cha =~ /([a-zA-Z]+)/;
           	       $val.$uni;
                     }
            #----------------<END of redu>-------------------------------------
            if ($hhi->{wid} ne "") { $nima->{wid} = &redu($hhi->{wid});}
            if ($hhi->{hei} ne "") { $nima->{hei} = &redu($hhi->{hei});}
            if ($hhi->{rot} != 0 ) { $nima->{rot} = $hhi->{rot};}
            push @$taim,$nima;
            if ($nbeil == 0) {
                unless ($gilab) {$lopt = $lopt."X";} # removing labels to images in grid
                my $ccp = [];
                if (defined($hhh->{cap})) { $ccp = [$hhh->{cap}];}
                push @$cod,@{&lhattmel::picture(ima=>$taim,
                                                dim=>[$hhh->{gnl},$hhh->{gnc}],
                                                cca=>$ccp,
                                                opt=>$lopt."b",
                                                typ=>$typ)};
                # resetting
                $taim = [];
                for my $rt ("nbi","gnl","gnc") {
                    $hhh->{$rt} = $cdefa->{$rt};
                }
            }
        }
    }
    if (scalar(@$taim)) { 
        &uie::la(str=>$taim);
        &uie::pause(mes=>"some final image(s) was not included!");
    }
    # ending the output file
    push @$cod,@{&lhattmel::end(typ=>$typ)};
    # creating the output file
    unless (open(TOUTOU,">$ouf")) {
        $res = &uie::add8err(err=>"",nsu=>$nsub,
                             erm=>["Not possible to open <$ouf> as an output file!"]);
        return $res;
    }
    foreach (@$cod) { print TOUTOU $_,"\n";}
    close TOUTOU;
    # returning
    $res;
}
#############################################
#############################################
1;

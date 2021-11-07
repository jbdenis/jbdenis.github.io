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
# 18_12_03 18_12_29 18_12_31 19_01_04 19_01_05
# 19_01_06 19_01_07 19_01_08 19_01_09 19_01_10
# 19_01_23 19_01_24 19_01_25 19_02_01 19_02_04
# 19_02_12 19_02_15 19_03_02 19_03_07 19_03_08
# 19_03_10 19_03_12 19_03_15 19_03_16 19_03_26
# 19_03_27 19_03_29 19_03_31 19_04_01 19_04_02
# 19_04_03 19_04_04 19_04_06 19_04_07 19_04_09
# 19_04_18 19_04_27 19_04_30 19_06_20 19_10_03
# 19_10_04 19_10_06 19_10_07 19_10_08 19_10_10
# 19_10_11 19_10_13 19_10_16 19_10_22 19_12_02
# 20_01_05 20_02_26 20_03_28 20_03_29 21_07_04
#
#
print ("\n  IL FAUT UTILISER 'fit8image' et 'image9' DE PHOMAN ET NON DE PHOGES !\n\n");
#&uie::la(str=>"STOP",mes=>"Cette version est fautive par une mauvaise modification de la reconnaissance des fichiers 'jpg' et autre ! phoges.2020_02_25.pm est une version qui marche... faire la comparaison avec lui !!!");
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
use File::Basename;
use File::Copy;
use lib "/home/jbdenis/u/perl";
use uie;
use jours;
use Image::Size;
use lhattmel;
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
# structures : individual pi.s, collective pi.s, circumstance pi.s
# and additional pi.s. Empty ones can be created with &new7pi (where
# they are implicitly described and their validity checked with
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
# 'annotation-photo.pdf' WHERE THE GENERAL
# APPROACH IS PRESENTED.
#
###>>>
#############################################
#############################################
# Some general constants
#############################################
# 
## list of suffixes
our %sufix = ("e"=>"-eif.txt","d"=>"-dif.txt",
              "i"=>"-icf.txt","l"=>".tex",
              "p"=>".pdf","h"=>".html");
## list of pi codes
our @pco = ("n","t","p","q","g","k","c","m","h","d");
## definition of names for the pi.s of image caption at a collective level
our %ipi = (n=>"N=",t=>"Quand: ",p=>"Où: ","q"=>"Qui: ",k=>"Clé(s): ",g=>"Catégorie(s): ",
            'm'=>"Commentaires: ",o=>"Origine:",h=>"Technik: ");
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
             k=>",",g=>",","q"=>", ");
## framing for caption components
our %cfra = (
    "n"=>["(",") "],   # name
    "m"=>["((",")) "], # comment
    "p"=>[" [","] "],  # place
    "q"=>[" [","] "],  # who
    "k"=>["[[","]] "], # keyword
    "g"=>["[[","]] "], # category
    "t"=>["<","> "],   # date
    "o"=>[" [","] "]   # origin
            );
## profile of image.item
our %prim = (jpg=>'oui',
             png=>'oui',
             ogg=>'oui');
## framing tags in eif files
our %fram = (
             "C"=>["<(",")>"],
             "c"=>["<|","|>"],
             "m"=>["((","))"],
             "p"=>["(|","|)"],
             "q"=>["[[","]]"],
             "k"=>["{{","}}"],
             "g"=>["<<",">>"],
             "t"=>["[|","|]"],
             "o"=>["[(",")]"],
             "d"=>["{|","|}"],
             "h"=>["<[","]>"]
            );
## default parameters for lhattmel::start call: see its documentation for details
our %pls = (cod=>"utf8",tit=>"",aut=>"",dat=>1,
                          toc=>1,npa=>1,two=>0,lma=>"15mm",
                          rma=>"15mm",tma=>"15mm",bma=>"15mm",
                          lgu=>"french",par=>[],fig=>"Ph."
             );
## default parameters for some interpretation of the latex elaboration
our %plt = (nus=>1,  # must the sections be numbered
            red=>1,  # reduction factor for image sizes
            pbn=>1   # until which section level a page break must be introduced?
           );
## tag to introduce an additional paragraph
our $parin = "(*)";
## value for missing time pi
#our $yemi = "0000";
our $yemi = "quand?";
##########################
## definition of the escaping commands
## command at individual level to be introduced as category.
our $kom = "--"; # opening and ending tags to distinguish this special category
##   allow (i) to prevent collective [pi]s at individual level
# for instance
#     '--kg--' means not to introduce collective keywords and categories
#     '--kgp--' the same escaping plus the possible collective place
# coding are
#     'c' -> circumstance
#     'm' -> comment
#     'p' -> place
#     'q' -> people (qui in French)
#     'k' -> keyword 
#     'g' -> category
#     't' -> time
#     'o' -> origin
#     'd' -> directory
#     'h' -> technical parameters
# also 'A' -> 'cmpqkgtodhmh'
#      'K' -> 'kg'
#      'C' -> 'cm'
# then 'KC' -> 'kgcm'
#
##   allow (ii) to reproduce the annotation of the previous image
# for instance
#     --I-- copy the m/p/q/k/g/t/o/d/h of the previous picture
#                EVEN WHEN PROVIDED in the picture annotation
# These 'identical' commands have priority on the other so
#     --mI-- will be interpreted as --I--
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
              wha=>"",chk=> 1,WHA=>"",CHK=> 1,
              nbi=>1,gnl=>1,gnc=>1,cap=>""}; 
# default values for the individual technical parameters
our $idefa = {wid=>"",hei=>"",rot=> 0,
              wha=>"",chk=> 1,vsp=>2}; 
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
my %telquel = (l=>"<LATEX>",h=>"<HTML>",c=>"cat");
my $incfile = "<FILE>";
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
sub image9 { 
    #
    # title : return some characteristics of an image
    #
    # aim : first the size, to be futher extended
    # 
    # output : when 'out' eq 'tout':
    #          a reference to a hash having, among others:
    #            suf => 0|1 if reckonized suffix (belongs to %prim)
    #            exi => 0|1 if 
    #            siz => [wid,hei,type] numbers of pixels of the image if it is plus the detected type
    #            ori =>  1|8|3|6 corresponding to a needed rotation of 0|90|180|270 degrees
    #          if not the asked component
    #
    #   Identify from ImageMagick is invoked only when the orientation is asked for
    #            or when a complete scan of the image characteristics (default 'out')
    #            is required.
    #
    # arguments
    my $hrsub = {ifi  =>[undef,  "c","Image File Name"],
                 out  =>[   "",  "c","'e' for existence of the file",
                                     "'s' for image suffix",
                                     "'S' for a reference to an array of size but undef if not an image",
                                     "'o' for the orientation",
                                     "'tout' to get everything within a hash"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    my $ifi = $argu->{ifi};
    my $out = $argu->{out};
    # initialization
    my $res = {};
    # is it reckonized?
    my $rek = 0;
    if (&uie::file9(fil=>$ifi,typ=>\%prim)->[1] eq "oui") {
        $rek = 1;
    }
    if ($rek) {
        $res->{suf} = 1;
    } else {
        $res->{suf} = 0;
    }
    if ($out eq "s") { return $res->{suf};}
    # does it exist?
    $res->{exi} = 1;
    unless (-e $ifi) {
        $res->{exi} = 0;
    }
    if ($out eq "e") { return $res->{exi};}
    # getting characteristics
    if (($res->{suf}) & ($res->{exi})) {
        if ($out eq "o") {
            ## with ImageMagick identify command
            # standard
            my $resu = `identify $ifi`;
            my @resu = split(/ /,$resu);
            $res->{nam} = $resu[0];
            $res->{typ} = $resu[1];
            my $sisi = $resu[2];
            my @sisi = split("x",$sisi);
            $res->{siz} = \@sisi;
            # plus orientation
            $resu = `identify -format '%[EXIF:Orientation]' $ifi`;
            $res->{ori} = $resu;
        } else {
            ## using imgsize from Image::Size
            my @sisi = imgsize($ifi);
            $res->{siz} = \@sisi;
        }
    }
    # returning
    if ($out eq "S") { return $res->{siz};}
    if ($out eq "o") { return $res->{ori};}
    $res;
}
#############################################
#
##<<
sub check8pi {
    #
    # title : check the validity of a pi series
    #
    # aim : to ease the programming task. Can be avoid with
    #      the global variable $pi7check.
    # 
    #  Have a look to the code to know what are the components of
    #      of the different types of pi.s. These are given by
    #      '$xpi->{y} which is compulsory and can take the
    #      following six values: 
    #        'ind' pi of a precise image (individual)    
    #              where c-pi are forbidden, nevertheless
    #              they must exist but void.
    #        'IND' pi of a precised image (individual in ICF)
    #              where c-pi are compulsory
    #        'col' for a collective definition of pi from a line
    #        'COL' for the current state of collective pi through
    #              the exploration of EIF/DIF comprising the
    #              complete record of the hierarchy
    #        'cir' circumstances
    #        'ext' for external paragraph
    #        'spe' for specific lines external to phoges
    #
    #   - Array components must be [] when empty
    #   - String components must be "" when empty
    #
    # output : 1 when right if not an error
    #
    # arguments
    my $hrsub = {xpi  =>[undef,  "h","The series of pi.s to check"],
                 whi  =>[   "",  "c","The expected type of pi; default is any type"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $xpi = $argu->{xpi};
    my $whi = $argu->{whi};
    # no check?
    unless ($pi7check) { return 1;}
    # checking the type
    unless (defined($xpi->{y})) {
        my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                erm=>["The proposed 'xpi' doesn't have 'y' as a key to indicate its type"]);
        return $rrr;
    }
    unless ($xpi->{y} =~ /^(ind)|(IND)|(col)|(COL)|(cir)|(spe)|(ext)$/) {
        my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                erm=>["type <$xpi->{y}> is not known as indicating any pi.s"]);
        return $rrr;
    }
    # checking the asked pi-type
    unless ($whi eq "") {
        if ($xpi->{y} ne $whi) {
            my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                    erm=>["The proposed 'xpi' is a '$xpi->{y}' type! Not '$whi' as asked."]);
            return $rrr;
        }
        
    }
    # proceeding according to the type using the common parts
    #
    my $res = "";
    if ($xpi->{y} =~ /^(ind)|(IND)|(col)|(COL)$/) {
        ## checking the common pi.s
        # checking single components
        foreach my $compo ("t","o","d") { if (($xpi->{y} eq "col") and (defined($xpi->{$compo})) ) {
            if (not(defined($xpi->{$compo}))) {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is missing in xpi argument"]);
            } elsif (ref($xpi->{$compo}) ne "") {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is a reference not a simple chain"]);
            }
	}}
        # checking hash components
        foreach my $compo ("h") { if (($xpi->{y} eq "col") and (defined($xpi->{$compo})) ) {
            if (not(defined($xpi->{$compo}))) {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is missing in xpi argument"]);
            } elsif (ref($xpi->{$compo}) ne "HASH") {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["key <$compo> is not a reference to a hash"]);
            }
        }}
    }
    #
    if ($xpi->{y} =~ /^(ind)|(IND)|(col)$/) {
        # checking array components
        foreach my $compo ("c","m","p","q","k","g") { if (($xpi->{y} eq "col") and (defined($xpi->{$compo})) ) {
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
        }}
    }
    #
    if ($xpi->{y} =~ /^(ind)$/) {
        # the array component must be void
        if (scalar(@{$xpi->{c}})) {
             $res = &uie::add8err(err=>$res,nsu=>$nsub,
                            erm=>["For 'ind' pi series, the c-pi must be void. Here it is not: '$xpi->{c}->[0]'"]);
        }
    }
    #
    if ($xpi->{y} =~ /^(IND)$/) {
        # the array component must not be void
        unless (scalar(@{$xpi->{c}})) {
             $res = &uie::add8err(err=>$res,nsu=>$nsub,
                            erm=>["For 'IND' pi series, the c-pi must NOT be void. Here it is!"]);
        }
    }
    #
    if ($xpi->{y} =~ /^(COL)$/) {
        # checking array components
        foreach my $compo ("c","m","p","q","k","g") {
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
                    } elsif (ref($arr) ne "ARRAY") {
                         $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                        erm=>["One of the component of xpi<$compo> is not a reference to an array"]);
                    }
                }
            }
        }
        # checking the content of the c-hierarchy
        my $numcom = 0;
        for my $titre (@{$xpi->{"c"}}) {
            $numcom++;
            if (ref($titre) ne "ARRAY") {
                &uie::la(str=>$titre);
                $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                     erm=>["COL pi series: key <c> has not got an array reference! (displayed above)"]);
            } else {
            my $lencou = scalar(@$titre);
                if ($lencou != 1) {
                    $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                         erm=>["COL pi series: key <c> has got more than ONE title in component $numcom: $titre->[0] and $titre->[1]..."]);
                }
            }
        }
        # checking the length of pi.s associated to the hierarchy
        my $collen = scalar(@{$xpi->{"c"}});
        foreach my $compo ("m","p","q","k","g") {
            my $colcou = scalar(@{$xpi->{$compo}});
            if ($colcou != $collen) {
                 $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                      erm=>["key <$compo> is not consistent with the hierarchy of circumstances: $colcou instead of $collen"]);
            }
        }
    }
    #
    if ($xpi->{y} =~ /^(ind)|(IND)$/) {
        # checking specfic components of individual series
        unless (defined($xpi->{n})) {
            $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                 erm=>["key <n> is missing in xpi argument indicated as individual pi.s"]);
        } elsif (ref($xpi->{n}) ne "") {
            $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                 erm=>["key <n> is a reference not simple chain for an individual pi.s"]);
        }
    }
    #
    if ($xpi->{y} =~ /^(col)|(COL)$/) {
        # checking specfic components of collective series
        if (defined($xpi->{n})) {
            $res = &uie::add8err(err=>$res,nsu=>$nsub,
                                 erm=>["key <n> is present in xpi argument",
                                       "not accepted for a collective pi series (collective)"]);
        }
    }
    ##
    if ($xpi->{y} eq "cir") {
        ## CIRCUMSTANCE PI.S
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
        foreach my $compo ("l","C") {
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
    #      (i) an image line with all possible pi.s
    #          leading to an ind-pi
    #     (ii) a circumstance line, then this is
    #          its only pi leading to a cir-pi
    #    (iii) a collective line, proposing pi.s
    #          for futher images leading to a col-pi
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
    #         with the complete content in key 'c'.
    #        If not the associated pi to the line.
    #         Of course, an error message when some
    #         inconsistency in the input is found.
    #         ((or its contents when the type is given in input,
    #           'undef' when not present.)).
    #        In case of inconsistency an error is returned.
    #
    # remarks :
    #           * shortcuts are not transformed but attibuted to
    #             pi-type
    #           * they is no distinction between 'ind'/'IND' or
    #             'col'/'COL' series so c-pi.s can be included
    #             and the pi-type attributed in ->{y} will be
    #             'ind' or 'col' according to the image presence
    #             at the beginning of the line. The true type
    #             must be attributed after the call to 'analyze8line'
    #             and the consistency of the content check at this
    #             moment.
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
            $res = { "y"=>"cir","l"=>$nle, "C"=>$res };
        } else {
            $lin =~ /^(\S+)\s*/;
            if (&image9(ifi=>$1,out=>"s")) {
                # an image/item line
                $res = &new7pi(wha=>"ind");
                $lin =~ s/^(\S+)\s*//;
                $res->{n} = $1;
                $lino = $lin;
                foreach my $copo ("c","m","p","q","k","g","t","o","d","h") {
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
                # must be a collective pi line
                $res = &new7pi(wha=>"col");
                $lino = $lin;
                #
                foreach my $copo ("c","m","p","q","k","g","t","o","d","h") {
                    my $rrr = &analyze8line(lin=>$lin,lit=>$copo);
                    if (defined($rrr)) {
                        if ($copo =~ /[cmpqkg]/) {
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
                                              "as a collective line, something was not interpreted:",
                                              "<<:$lino:>>"]);
                return $rrr;
                }
            }
        }
        # no check because ind/col can have c-pi.s
        # (see the remarks in the general comments)
        #my $ver = &check8pi(xpi=>$res);
        #if (&uie::err9(obj=>$ver)) { $res = $ver;}
        return $res;
    } else {
        # checking that the proposed type is valid
        unless ( $lit =~ /^[mpqkgctodh]$/) {
            $res = &uie::add8err(err=>"",nsu=>$nsub,
                                 erm=>["Argument \$lit ($lit) is not valid"]);
            return $res;
        }
        # a specific content is looked for
        $res = undef;
        if (not(defined($lino))) { return $res;
        } elsif ($lit =~ /^[tod]$/) {
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
                    $res = &analyze8named7vector(lin=>$1,sep=>$sepa{$lit});
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
    #      'stf' means ShortcuT Definition File".
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
    my $hrsub = {ima  =>[undef,  "h","The pi.s describing the image"],
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
    unless ($ima->{y} =~ /^(ind)|(IND)$/) {
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
            my $ctp = &jours::huma2cano(tip=>$cri->{$typ}->[0]);
            my $itp = &jours::huma2cano(tip=>$ima->{t});
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
    # title : update the collective pi.s
    #
    # aim : an ancillary functions to update the current collective pi.s.
    # 
    # output : the updated collective pi
    #         or an error when something was not
    #         acceptable
    #
    # arguments
    my $hrsub = {cop  =>[undef,  "h","The COL pi series to be updated"],
                 sup  =>[undef,  "h","The col-pi series or cir-pi to use"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $co0 = $argu->{cop}; my $cop = &uie::copy8structure(str=>$co0);
    my $sup = $argu->{sup}; 
    # checking with '$pi7check'
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
    # checking the pi types
    if ($cop->{y} ne "COL") {
        &uie::print8structure(str=>$cop);
        my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                erm=>["'cop' argument is not a collective  COL-pi but $cop->{y}"]);
        return $rrr;
    }
    unless ($sup->{y} =~ /^(col)|(cir)$/) {
        &uie::print8structure(str=>$sup);
        my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                erm=>["'sup' argument is not a collective  COL-pi or a cir-pi BUT $sup->{y}"]);
        return $rrr;
    }
    # performing
    my $nbc = scalar(@{$cop->{c}});
    if ( $sup->{y} eq "cir" ) {
        # just the circumstance levels have to be adjusted
        if ( $sup->{l} eq "0") {
            # defining a title, then initialization
            unless (&pi9(xpi=>$cop,wha=>"c")>0) {
                if ($nbc > 1) {
                    &print8pi(xpi=>$cop);
                    my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                            erm=>["Defining a title while some circumstance(s) were already present"]);
                    return $rrr;
                }
            }
            $cop = &new7pi(wha=>"COL");
            $cop->{c} = [[$sup->{C}]];
            foreach ("m","p","q","k","g") { $cop->{$_} = [[""]];}
        } else {
            # modifying the hierarchy
            if ($sup->{l} > $nbc) {
                &print8pi(xpi=>$cop);
                &print8pi(xpi=>$sup);
                my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                        erm=>["Defining a circumstance too high for the present colpi",
                                              "(colpi: ".($nbc-1)."; new circumstance: ".$sup->{l}.")"]);
                return $rrr;
            }
            # initialization
            my $lbc = $sup->{l};
            my $tit = $sup->{C};
            # proceeding
            if ($nbc == $lbc) {
                # a new level of circumstances is added
                push @{$cop->{"c"}},[$tit];
                foreach my $hh (keys %$cop) {
                    if ($hh =~ /[mpqkg]/) {
                        push @{$cop->{$hh}},[""];
                    }
                }
            } elsif ($nbc > $lbc) {
                # modification of the present hierarchy
                $cop->{"c"}->[$lbc] = [$tit];
                splice(@{$cop->{"c"}},$lbc+1);
                foreach my $hh (keys %$cop) {
                    if ($hh =~ /[mpqkg]/) {
                        $cop->{$hh}->[$lbc] = [""];
                        splice(@{$cop->{$hh}},$lbc+1);
                    }
                }
            }
        }
    } else {
        ## additional information must be incorporated with the help of a col-pi
        # vectorial pi.s
        foreach my $wha ("m","p","q","k","g") {
            if (&pi9(xpi=>$sup,wha=>$wha) >= 0) {
                # this one must be updated possibly erased
                $cop->{$wha}->[$nbc-1] = &uie::copy8structure(str=>$sup->{$wha});
            }
        }
        # scalar pi.s
        foreach my $wha ("t","o","d") {
            if (&pi9(xpi=>$sup,wha=>$wha) >= 0) {
                # this one must be updated possibly erased
                $cop->{$wha} = $sup->{$wha};
            }
        }
        # technical parameters
        foreach my $wha ("h") {
            if (&pi9(xpi=>$sup,wha=>$wha) > 0) {
                # technical parameters must be updated
                # emptying them except upper cased
                foreach my $ktp (keys %{$cop->{$wha}}) {
                    unless ($ktp =~ /^[A-Z]+$/) {
                        delete $cop->{$wha}->{$ktp};
                    }
		}
                # except dimension conditionnaly
                my $Dsup = (defined($sup->{$wha}->{WID}) or defined($sup->{$wha}->{HEI}));
                my $Dcop = (defined($cop->{$wha}->{WID}) or defined($cop->{$wha}->{HEI}));
                if ($Dcop and $Dsup) {
		    # upper cased dimension must also be deleted
		    delete $cop->{$wha}->{WID};
		    delete $cop->{$wha}->{HEI};
		}
                # filling them including upper cased
                foreach my $nn (keys %{$sup->{$wha}}) {
                    $cop->{$wha}->{$nn} = $sup->{$wha}->{$nn};
                }
            }
        }
    }
    # final check
    $rrr1 = &check8pi(xpi=>$cop);
    if (&uie::err9(obj=>$rrr1)) {
        $cop = &uie::add8err(err=>$rrr1,nsu=>$nsub,
                             erm=>["'cop' produced by $nsub is not a genuine colpi!!!",
                                   "Sorry for that!!!"]);
        #$cop = &uie::conca8err(er1=>$rrr,er2=>$rrr1);
    }
    # returning
    $cop;
}
#############################################
#
##<<
sub pi2line {
    #
    # title : generates a line from a series of pi.s
    #
    # aim : mainly used to write lines when creating dif and icf.
    #       Of course, non-empty components are included.
    #       The line is different according to the pi series type
    #       which can be 'ind', 'COL' or 'cir' for dif,
    #                    'IND' for icf
    #       but no care of the file being created at this level.
    #        for "m","p","q","k","g".
    #      When an individual pi are given only non empty
    #        components are considered.
    #
    # remarks: + in case of COL-pi.s, only the components to the last
    #            level are considered 
    #
    # output : a single string
    #          or an error when something is not
    #            acceptable
    #
    # arguments
    my $hrsub = {xpi  =>[undef,  "h","The pi-series to translate"],
                 xco  =>[    0,  "n","Must a 'col' be accepted?",
                                     " (exception introduced for 'shrink8dif')"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $xpi = $argu->{xpi};
    my $xco = $argu->{xco};
    # initialization
    my $res = "";
    # checking
    my $err = &check8pi(xpi=>$xpi);
    if (&uie::err9(obj=>$err)) {
        return $err;
        $err = &uie::add8err(err=>$err,nsu=>$nsub,
                                erm=>["The argument 'xpi' is not valid, must be a pi of type ind/COL/cir/IND"]);
    }
    my $typ = $xpi->{y};
    my $xpt = lc($typ);
    sub tpi { 
        my ($ty,$pi) = @_;
	if (($ty eq "col") and ($pi==0)) {return 1;}
        return ($pi>0);
    }
    unless ($typ =~ /^(ind)|(COL)|(cir)|(IND)$/) {
	unless (($typ =~ /^col$/) and ($xco)) {
	    my $err = &uie::add8err(err=>"",nsu=>$nsub,
				    erm=>["This type of pi.s ($typ) cannot be transformed into a line"]);
	    return $err;
        }
    }
    # performing
    if ($typ =~ /^(ind)|(IND)$/) {
        # introducing the name
        $res = $res.$xpi->{n}." ";
    }
    #
    if ($typ =~ /^(ind)|(COL)|(IND)|(col)$/) {
        # adding the scalar pi.s
        foreach my $pi ("t","o","d") {
            if (&tpi($xpt,&pi9(xpi=>$xpi,wha=>$pi))) {
                $res = $res." ".$fram{$pi}->[0].$xpi->{$pi}.$fram{$pi}->[1];
            }
        }
        # adding the named vectorial pi.s
        foreach my $pi ("h") {
            if (&tpi($xpt,&pi9(xpi=>$xpi,wha=>$pi))) {
                $res = $res.$fram{h}->[0];
                my @ru = ();
                foreach my $ele (keys %{$xpi->{$pi}}) {
                    push @ru,$ele."=".$xpi->{$pi}->{$ele};
                }
                my $ru = join(" ".$sepa{h}." ",@ru);
                $res = $res.$ru.$fram{h}->[1];
            }
        }
    }
    #
    if ($typ =~ /^(ind)|(IND)|(col)$/) {
        # adding the vectorial pi.s
        foreach my $pi ("c","m","p","q","k","g") {
            if (&tpi($xpt,&pi9(xpi=>$xpi,wha=>$pi))) {
                $res = $res." ".$fram{$pi}->[0].
                                join(" ".$sepa{$pi}." ",@{$xpi->{$pi}}).
                                $fram{$pi}->[1];
            }
        }
    }
    #
    if ($typ =~ /^(COL)$/) {
        # last level to introduce
        my $lale = scalar(@{$xpi->{c}});
        # adding the vectorial pi.s
        foreach my $pi ("c","m","p","q","k","g") {
            if (&tpi($xpt,&pi9(xpi=>$xpi,wha=>$pi))) {
                $res = $res." ".$fram{$pi}->[0].
                                join(" ".$sepa{$pi}." ",@{$xpi->{$pi}->[$lale-1]}).
                                $fram{$pi}->[1];
            }
        }
    }
    #
    if ($typ eq "cir") {
        # a circumstance line
        $res = $res.$fram{"C"}->[0].$xpi->{l}.$fram{"C"}->[1]." ".$xpi->{C};
    }
    if ($res =~ /^\s*$/) { $res = "#";}
    # returning
    $res;
}
#############################################
#
##<<
sub new7pi {
    #
    # title : return a pi series
    #
    # aim : create a void|complete pi which can be:
    #         - an [ind|IND]ividual pi, describing an image
    #         - a [col|COL]lective pi, all information
    #           gathered outside image descriptions
    #         - a [cir]cumstance
    #
    # remarks - compulsory name is set to 'NULL.PNG'
    #         - compulsory hierarchical structure in COL series
    #           is set to ["",""] and associated vector pi.s
    #           to [[],[]]
    #
    # output : the empty|complete newly created
    #          or an error when the input is not accepted.
    #
    # arguments
    my $hrsub = {wha  =>[undef,  "c","The type to create 'ind | IND | col | COL | cir'"],
                 fil  =>[    0,  "n","Indicate if the pi series must be filled"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $wha = $argu->{wha};
    my $fil = $argu->{fil};
    my $res;
    #
    if ($wha !~ /^(ind)|(IND)|(col)|(COL)|(cir)$/) {
        $res = &uie::add8err(err=>"",nsu=>$nsub,
                             erm=>["Asked pi series type '$wha' is not accepted.",
                                   "Must be ind/IND/col/COL/cir"]);
    }
    #
    if ($wha =~ /^(col)$/) {
        #
        $res   = {"y"=>$wha};
        if ($fil) {
            $res->{"m"} = ["A first comment","A final comment"];
        }
    }
    # 
    if ($wha =~ /^(ind)|(IND)$/) {
        #
        $res   = {"y"=>$wha};
        if ($wha =~ /^(ind)|(IND)$/) { $res->{"n"} ="NULL.PNG"};
        #
        for my $cp ("c","m","p","q","k","g") {
            $res->{$cp} = [];
        }
        for my $cp ("t","o","d") {
            $res->{$cp} = "";
        }
        for my $cp ("h") {
            $res->{$cp} = {};
        }
        if ($wha eq "IND") {
            $res->{c} = ["0","1"];
        }
        if ($fil) {
            $res->{"m"} = ["A first comment","A final comment"];
            $res->{"p"} = ["LA","downtown"];
            $res->{"q"} = ["You","He","I"];
            $res->{"k"} = ["group"];
            $res->{"t"} = "Midnight";
            $res->{"o"} = "jbd";
            $res->{"d"} = "./";
        }
    }
    # 
    if ($wha =~ /^(COL)$/) {
        #
        $res   = {"y"=>$wha};
        $res->{c} = [["0"],["1"]];
        #
        for my $cp ("m","p","q","k","g") {
            $res->{$cp} = [[""],[""]];
        }
        for my $cp ("t","o","d") {
            $res->{$cp} = "";
        }
        for my $cp ("h") {
            $res->{$cp} = {};
        }
        #
        if ($fil) {
            $res->{"m"} = [["A first comment","A final comment"],["Nothing to add!"]];
            $res->{"p"} = [["LA","downtown"],["Paris by night"]];
            $res->{"q"} = [["You","He","I"],["the baby dog"]];
            $res->{"k"} = [["group"],["family"]];
            $res->{"t"} = "Midnight";
            $res->{"o"} = "jbd";
            $res->{"d"} = "./";
        }
    }
    #
    if ($wha eq "cir") {
        $res   = {"y"=>$wha,C=>"",l=>0};
        if ($fil) {
            $res   = {"y"=>$wha,C=>"At Summer Time",l=>1};
        };
    }
    #
    # returning
    $res;
}
#############################################
#
##<<
sub pi9 {
    #
    # title : test the existence of pi into a pi series
    #
    # aim : just for pi series ind/IND/col/COL/cir
    #         detects if the asked pi is not void
    #
    # remarks: not a great subroutine but a good way 
    #          to define what is considered as void for
    #          the different pi.s.
    #          As the aim is not to check the pi series,
    #          voidness is extended to non existence.
    #          Take care that the output is not a boolean.
    #
    # output : -1 doesn't exist
    #           0 exists and void
    #           1 exists and filled
    #
    #          in case of inconsistency: a fatal error.
    #
    # arguments
    my $hrsub = {xpi  =>[undef,  "h","The pi series to scan; must be 'ind | IND | col | COL | cir'"],
                 wha  =>[undef,  "c","The component to look for voidness"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $xpi = $argu->{xpi};
    my $wha = $argu->{wha};
    my $res;
    # some check
    unless (&uie::check8ref(ref=>$xpi,typ=>"h")) {
        &uie::la(str=>$xpi);
        print "$nsub: asked for scanning a pi series which is not a hash!",
              " (structure printed above)\n\n";
        die;
    }
    unless (defined($xpi->{y})) {
        &uie::la(str=>$xpi);
        print "$nsub: asked for a $wha pi.s series not having key 'y'!\n\n";
        die;
    }
    unless ($xpi->{y} =~ /^(ind)|(IND)|(col)|(COL)|(cir)$/) {
        print "$nsub: asked for a $wha pi.s series not accepted!\n\n";
        die ("(only 'ind|IND|col|COL|cir' are)");
    }
    #
    # checking
    #
    unless (defined($xpi->{$wha})) { return -1;}
    else {
        # cir pi series
        if ($xpi->{y} =~ /^(cir)$/) {
            for my $comp ("y","C","l") {
                if ($comp eq $wha) {
                    if ($xpi->{$wha} eq "") { return 0;}
                    else { return 1;}
                }
            }
        }
        # ind/IND/col/COL pi series
        if ($xpi->{y} =~ /^(ind)|(IND)|(col)|(COL)$/) {
            # scalar components
            for my $comp ("y","n","t","o","d") {
                if ($comp eq $wha) {
                    if ($xpi->{$wha} eq "") { return 0;}
                    else { return 1;}
                }
            }
            # vectorial components
            for my $comp ("c","m","p","q","k","g") {
                if ($comp eq $wha) {
                    unless (defined($xpi->{$wha}->[0])) { return 0; } 
                    if ($xpi->{y} eq "COL") {
                        my $rempli = 0;
                        foreach my $ccomp (@{$xpi->{$wha}}) {
                            if (defined($ccomp->[0])) { if ($ccomp->[0] ne "") { $rempli++;}}
                        }
                        if ($rempli) { return 1;} else { return 0;}
                    } else {
                        if ($xpi->{$wha}->[0] eq "") { return 0;} else { return 1;}
                    }
                }
            }
            # named vectorial components
            for my $comp ("h") {
                if ($comp eq $wha) {
                    if (scalar(keys(%{$xpi->{$wha}}))) { return 1;} else { return 0;}
                }
            }
        }
    }
    # the component was not listed
    &uie::la(str=>$xpi);
    print "$nsub: asked for scanning a pi type '$wha' which doesn't exist!",
          " (structure printed above)\n\n";
    die;
    # returning
    1;
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
    # output : 1 or an error when the pi is valid according to $pi7check.
    #
    # arguments
    my $hrsub = {xpi  =>[undef,  "h","The pi.s to print"],
                 eve  =>[    0,  "n","Must empty components be displayed for types ind/IND/col/COL?"],
                 chk  =>[    1,  "n","Must the validity of the 'pi' be checked before printing?"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $xp0 = $argu->{xpi}; my $xpi = &uie::copy8structure(str=>$xp0);
    my $eve = $argu->{eve};
    my $chk = $argu->{chk};
    my $res;
    # the check
    if ($chk) { 
        $res = &check8pi(xpi=>$xpi);
        if (&uie::err9(obj=>$res)) {
            &uie::print8err(err=>$res);
            print "\n"." "x10,"From $nsub: the 'xpi' was checked unvalid and not printed!\n\n";
            return $res;
        }
    }
    # the title
    my $type = $xpi->{y};
    my %title = ("ind"=>"Individual","col"=>"Collective",
                 "IND"=>"INDIVIDUAL","COL"=>"COLLECTIVE",
                 "cir"=>"Circumstance","ext"=>"External Comment");
    print "\n\n $title{$type} PI SERIES:\n\n";
    # removing empty structures for 'ind' and 'col' types
    my @moins = ();
    unless ($eve) { if ($type =~ /^(ind)|(IND)|(col)|(COL)$/) {
        for my $kk (keys %{$xpi}) { 
            unless (&pi9(xpi=>$xpi,wha=>$kk) == 1) {
                delete $xpi->{$kk};
                push @moins,$kk;
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
sub read8ic7f {
    #
    # title : read an icf file to extract some components
    #         for the collection of pictures
    #
    # aim : get information about images, a typical
    #       example is required sizes.
    # 
    # output : a hash whose keys are the picture names
    #          the values being references to a hash whose
    #          keys are the asled types and values the
    #          reference to the type value.
    #
    # arguments
    my $hrsub = {icf  =>[undef,  "c","The name of the raw index file"],
                 typ  =>[  "h",  "c","String of the types to be extracted.",
                                     "For instance 'tp' to obtain only the time and place pi.",
                                     'Possible constants are listed in the local @titi']   
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $icf = $argu->{icf};
    my $typ = $argu->{typ};
    my $res = {};
    # constant
    my @titi = ("t","p","q","k","g","m","h","c","d");
    # reading the file
    unless (open(FIL,"<$icf")) {
        $res = &uie::add8err(err=>"",nsu=>$nsub,
                             erm=>["1:Not possible to open $icf file!"]);
        return $res;
    } else {
        # just not to get an error message!
        while (<FIL>) {
            last;
        }
    }
    ######
    ## dealing only  with the first block
    my $fibl = &uie::read8block(fil=>$icf,sep=>undef,
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
    my %veri = (); my %dupli = ();
    foreach my $lig (@$fibl) {
        # eliminating lines defining a category
        unless ($lig =~ /^\Q$idrf{"g"}\E/) {
            my $pil = &uie::check8err(obj=>&analyze8line(lin=>$lig,lit=>""),sig=>"From $nsub");
            if ($pil->{y} eq "ind") {
                my $nomi = $pil->{n};
                if (defined($veri{$nomi})) {
                    if (defined($dupli{$nomi})) { $dupli{$nomi}++;}
                    else { $dupli{$nomi} = 2;}
                } else {
                    $veri{$nomi} = 1;
                    foreach my $tyy (@titi) {
                        if ($tyy =~ /[\Q$typ\E]/) {
                            $res->{$nomi}->{$tyy} = $pil->{$tyy};
                        }
                    }
                }
            }
        }
    }
    # case of duplicated images
    my $nbdi = scalar(keys %dupli);
    if ($nbdi > 0) {
        &uie::print8structure(str=>\%dupli); print "\n";
        $res = &uie::add8err(err=>"no",nsu=>$nsub,
                             erm=>["$nbdi images were found duplicated in the input ICF $icf",
                                   "Their list was just displayed",
                                              " This is not valid!"]);
    }
    # returning
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
    #                 - [CI] 'wha=nhw' what to introduce instead of image/item
    #                 - [CI] 'chk=0'   must the presence of the file be checked
    #                 - [C]  'WID=3cm' width of the images,
    #                 - [C]  'HEI=5cm' height of the images
    #                 - [C]  'WHA=nhw' what to introduce instead of image/item
    #                 - [C]  'CHK=0'   must the presence of the file be checked
    #                 - [I]  'rot=-90' the rotation to apply to the image (default 0),
    #                 - [I]  'vsp= 2' the vertical space to introduce between image and caption,
    #                 - [C]  'nbi=3' number of images to introduce into a grid (default 1),
    #                 - [C]  'gnl=2' number of lines into the grid (default 1),
    #                 - [C]  'gnc=2' number of columns of the grid (default 1)
    #                 - [C]  'cap=common features are...' possible collective caption for a
    #                               a grid of images
    #                    (See below to know how they are used),
    #          (x) Be aware that some collective pi.s can be lost if not associated to 
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
    #     except TP 'WID/HEI/WHA/CHK' which are resetted only by a void collective TP
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
                                " - the argument 'par' of &lhattmel::start, description and default values in %pls",
                                " - some latex specifications (default in %plt):",
                                "       . num=>0 for the sections,... not to be numbered (default 1)",
                                "       . red=>0.5 to get the picture half the size which is specified",
                                "                  in the technical parameters (default 1)",
                                "       . pbn=>2 to indicate until which section level a page break must be introduced",
                                " - framing used when building the picture captions (default in %cfra):",
                                "     'cfraon' for the 'o'pening of the 'n'ame",
                                "     'cfracp' for the 'c'losing of the 'p'lace",
                                "              and so on (see the 'cfra' definition)",
			        " - 'subdir' as a logical to indicate if subdirectories indicated within",
			        "            the <dif> input must be used or not",
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
                 rdi  =>[  ".",  "c","root directory from which images including their private directories",
                                     "can be found"],
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
    my $rdi = $argu->{rdi}; unless ( $rdi =~ /\/$/ ) { $rdi = $rdi."/";}
    my $typ = $argu->{typ};
    # subdirectories ?
    my $subdir = 1;
    if (defined($ppa->{subdir})) {
	if ($ppa->{subdir}) { $subdir = 1;} else { $subdir = 0;}
    }
    # constant
    my %ptp = (WID=>"wid",HEI=>"hei",WHA=>"wha",CHK=>"chk");
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
#&uie::la(str=>$fifi,mes=>"fifi 0");
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
    if (defined($ppa->{cfraoo})) { $cfra{o}[0] = $ppa->{cfraoo};}
    #
    if (defined($ppa->{cfracn})) { $cfra{n}[1] = $ppa->{cfracn};}
    if (defined($ppa->{cfract})) { $cfra{t}[1] = $ppa->{cfract};}
    if (defined($ppa->{cfracp})) { $cfra{p}[1] = $ppa->{cfracp};}
    if (defined($ppa->{cfracq})) { $cfra{q}[1] = $ppa->{cfracq};}
    if (defined($ppa->{cfracg})) { $cfra{g}[1] = $ppa->{cfracg};}
    if (defined($ppa->{cfrack})) { $cfra{k}[1] = $ppa->{cfrack};}
    if (defined($ppa->{cfracm})) { $cfra{m}[1] = $ppa->{cfracm};}
    if (defined($ppa->{cfraco})) { $cfra{o}[1] = $ppa->{cfraco};}
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
        #
        my $lue = &analyze8line(lin=>$lig);
#print "lig = -(<$lig)>-\n";
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
            my $pabr = {pb=>($plt{pbn}>=abs($niv))};
            push @$cod,@{&lhattmel::subtit(tit=>$lue->{C},lev=>$niv,
                                           par=>$pabr,typ=>$typ)};
        } elsif ($lue->{y} eq "col") {
            # an additional collective line is identified
            my $clu = &uie::check8err(obj=>&check8pi(xpi=>$lue));
            if (&uie::err9(obj=>$clu)) {
                $res = &uie::add8err(err=>$clu,nsu=>$nsub,erm=>
                                     ["Something went wrong with a 'col' line",
                                      "<<$lig>>"]);
                return $res;
            }
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
            if (defined($lue->{m})) {	    
                push @$cod,@{&lhattmel::parag(prg=>$lue->{m},typ=>$typ)};
	    }
            # introducing the possible time
            if ( $lue->{t} ) {
                my $temps = $lue->{t};
                #$temps =~ s/_/-/g; # to prevent the underscore not compatible with latex
                push @$cod,@{&lhattmel::parag(prg=>["$ipi{t}: $temps"],typ=>$typ)};
            }
            # introducing the possible other pi.s
            #for my $pi ("p","q","k","g") { if ($cap =~ /\Q$pi\E/) { 
            for my $pi ("p","q","k","g","o") { if ($cap =~ /\Q$pi\E/) {
		my $luepi = $lue->{$pi};
                if ((defined($luepi)) and ($luepi ne "")){
		    if ($pi eq "o") { $luepi = [$luepi];}
		    if ( scalar(@{$luepi}) ) {
			my @intro = @{$luepi};
			$intro[0] = $ipi{$pi}.$intro[0];
			push @$cod,@{&lhattmel::parag(prg=>\@intro,typ=>$typ)};
                    }
                }
            }}
            # deal with the possible technical parameters
            if (defined($lue->{h})) {
                ## resetting values
                # is it a void TP?
                my $vtp = keys %{$lue->{h}};
                #my @sau = ($hhh->{WID},$hhh->{HEI});
                my %sau = ();
                foreach (keys %ptp) { $sau{$_} = $hhh->{$_};}
                $hhh = &uie::copy8structure(str=>$cdefa);
                if ($vtp) {
                    foreach (keys %ptp) { $hhh->{$_} = $sau{$_};}
                    #&&$hhh->{WID} = $sau[0];
                    #&&$hhh->{HEI} = $sau[1];
                } 
                # introducing the new values
                #&&foreach my $kk ("wid","hei","WID","HEI","nbi","gnl","gnc","cap") {
                foreach my $kk ((keys %ptp),(values %ptp),"nbi","gnl","gnc","cap") {
                    if (defined($lue->{h}->{$kk})) {
                        if ($kk !~ /(hei)|(HEI)|(wid)|(WID)|(wha)|(WHA)|(cap)/) { # ICI PAS D'USAGE DE %ptp :+(
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
            # deal with the possible relative directory
#&uie::la(str=>$lue->{dir},mes=>"LUE");
            if (defined($lue->{d})) {
                $hhh->{dir} = $lue->{d};
                unless ($hhh->{dir} eq "") {
                    $hhh->{dir} =~ s/^\///;
                    unless ($hhh->{dir} =~ /\/$/) { $hhh->{dir} = $hhh->{dir}.'/';}
                }
            }
#&uie::la(str=>$hhh->{dir},mes=>"hhh d apres lue");
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
            # something to directly introduce
            if ( $lili =~ /^\s*$incfile/) {
                # the content of a file must be introduced
                $lili =~ s/\s*$incfile//;
                $lili =~ s/^\s*//;
                $lili =~ s/\s*$//;
                unless (-e $lili) {
                    $res = &uie::add8err(err=>"no",nsu=>$nsub,erm=>
                    ["THE FILE TO INTRODUCE '$lili' WAS NOT FOUND ",
                     "  here is the line:",
                     "\n  <$lig>\n"]);
                    return $res;
                } else {
                    open(ICFL,"<$lili") or die("Not able to open $incfile");
                    while (<ICFL>) { chomp; push @$cod,$_;}
                    close(ICFL);
                }               
            } else {
                # just the content of this line to introduce
                push @$cod,$lili;
            }
        } else {
#&uie::la(str=>$lue,mes=>"lue à l'origine");
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
                    if ("nto" =~ /\Q$q\E/) {
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
                        #$ax =~ s/_/-/g;
                    }
                }
                $ax;
            }
            #----------------<END of lege>-------------------------------------
            # loading the individual technical paramaters
            my $hhi = &uie::copy8structure(str=>$idefa);
#&uie::la(str=>$hhi,mes=>"hhi 1");
            foreach my $tk (keys %$hhi) {
                if (defined($lue->{h}->{$tk})) {
                    $hhi->{$tk} = $lue->{h}->{$tk};
                }
            }
#&uie::la(str=>$hhi,mes=>"hhi 2");
            # fitting them with the collective parameters
            ## width and height which are linked technical parameters
#&uie::la(str=>$hhh,mes=>"hhh");
            my $didi = (($hhi->{wid} ne "") or ($hhi->{hei} ne ""));
            unless ($didi) {
                # as both individual wid and hei are not defined,
                # they are taken from the collective definition
                #   upper case when collective lower case is not defined
                #              else collective lower case
                for my $dime ("wid","hei") {
                    if ($hhh->{$dime} eq "") {
                        $hhi->{$dime} = $hhh->{uc($dime)};
                    } else {
                        $hhi->{$dime} = $hhh->{$dime};
                    }
                }
            }
            ## other collective parameters
            for my $dime ("wha","chk") {
                if ($hhh->{$dime} eq "") {
                    $hhi->{$dime} = $hhh->{uc($dime)};
                } else {
                    $hhi->{$dime} = $hhh->{$dime};
                }
            }
            #
            for my $quoi ('n','t','p','q','k','g','m','o') {
                my $aj = &lege($quoi,$cap,$lue,$typ);
                if ($aj) { push @caption,$aj;}
            }
            #
            my $lopt = "H";
            if ($cap =~ /B/) { $lopt = $lopt."l";}
            if ($cap eq "") { $lopt = $lopt."X";}
            my $nima = {fil=>$lue->{n},cap=>\@caption};
            if (defined($lue->{d})) {
                my $diaj = $lue->{d};
                $diaj =~ s/^\///;
                unless ($diaj =~ /\/$/) { $diaj = $diaj.'/';}
                if ($diaj eq "/") { $diaj = "";}
                $nima->{dir} = $diaj;
            }
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
            if ($hhi->{wha} ne "") { $nima->{wha} = $hhi->{wha};}
            $nima->{vsp} = $hhi->{vsp};
            push @$taim,$nima;
            if ($nbeil == 0) {
                unless ($gilab) {$lopt = $lopt."X";} # removing labels to images in grid
                #
                # replacing the directory if an individual is indicated
                # 
                my $taimb = &uie::copy8structure(str=>$taim);
                foreach my $iimm (@$taimb) {
                    my $reper = $rdi;
		    if ($subdir) {
			# relative directory must be added
			if ($iimm->{dir}) {
			    # the individual directory must be used
			    $reper = $reper.$iimm->{dir};
			} else {
			    if (defined( $hhh->{dir})) {
				# the collective directory must be used
				$reper = $reper. $hhh->{dir};
			    }
			}
		    }
                    $iimm->{fil} = $reper.$iimm->{fil};
                }
                push @$cod,@{&lhattmel::picture1item(ima=>$taimb,
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
sub analyze8named7vector {
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
    my $hrsub = {xpi  =>[undef,  "h","Initial pi.s with possible shortcuts"],
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
    ## checking the validity
    my $rrr = &check8pi(xpi=>$res);
    if (&uie::err9(obj=>$rrr)) {
        $rrr = &uie::add8err(err=>$rrr,nsu=>$nsub,
                             erm=>["The proposed pi series is not valid!"]);
        return $rrr;
    }
    ## checking the type
    unless ($res->{y} =~ /^(ind)|(IND)|(col)|(COL)$/) {
        my $rrr = &uie::add8err(err=>"",nsu=>$nsub,
                                erm=>["pi with type $res->{y} must not be proposed for shortcut replacement"]);
        return $rrr;
    }
    my $llev;
    my $col = 0;
    if ($res->{y} eq "COL") { $col = 1; $llev = scalar(@{$res->{k}}) - 1;}
    ## proceeding
    my @geke = ("p","q","k","g");
    foreach my $k (@geke) {
        # for each component of the present pi.s
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
                                push @{$res->{$kka}->[$llev]},$res->{$k}->[$llev]->[$kk];
                            } else {
                                push @{$res->{$kka}},$res->{$k}->[$kk];
                            }
                        } else {
                            # other keywords
                            if ($col) {
                                push @{$res->{$kka}->[$llev]},$stc->{$kkk}->{$res->{$k}->[$llev]->[$kk]};
                            } else {
                                push @{$res->{$kka}},$stc->{$kkk}->{$res->{$k}->[$kk]};
                            }
                        }
                        if ($col) {
                            splice @{$res->{$k}->[$llev]},$kk,1;
                        } else {
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
    # title : prepare an individual pi.s
    #
    # aim : using the current collective pi.s
    #        adapt an individual pi.s.
    # 
    # output : an error object if something
    #         was wrong, if not a hash with
    #         different pi.s corresponding
    #         to the individual pi series:
    #         'ind' or 'IND' according to
    #         the absence/presence of 'c' in
    #         argument 'cum'
    #
    # remarks:
    #         (i) escaped pi.s are left are they are
    #             (escaping commands are looked for within the
    #              categories). For instance '--kg--' means that
    #              k-pi and g-pi must not be introduced.
    #              Beware that when a pi is escaped, it is not
    #              introduced even if asked with the argument 'cum'
    #
    # arguments
    my $hrsub = {cpi  =>[undef,  "h","collective pi.s"],
                 ipi  =>[undef,  "h","Individual pi.s to adjust"],
                 lpi  =>[undef,  "h","pi.s of the last image in case of 'identical'"],
                 cum  =>[undef,  "c","A string indicating which pi.s must be cumulated.",
                                     "For instance 'mkgd' indicates that only collective",
                                     "comments, keywords, categories and directory must",
                                     "be cumulated"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $cpi = $argu->{cpi};
    my $ipi = $argu->{ipi};
    my $lpi = $argu->{lpi};
    my $cum = $argu->{cum};
    # initialization
    my $res = &uie::copy8structure(str=>$ipi);
    if ($cum =~ /c/) {
	# upper cased individual pi.s
	$res->{y} = "IND";
    }
    # getting first the possible commands
    my $ident = 0; my $escap = "";
    my @cate = [];
    if (defined($ipi->{g})) { @cate = @{$ipi->{g}};}
    foreach (@cate) {
        # is it a command?
        if ($_ =~ /^${kom}.+${kom}$/) {
            my $reste = $_;
            $reste =~ s/^${kom}//;
            $reste =~ s/${kom}$//;
            # does identical prevail?
            if ($reste =~ /I/) {
                $ident = 1;
            } else {
                # looking for other escaping
                if ($reste =~ /A/) { $escap = $escap."cmpqkgtodh";}
                if ($reste =~ /K/) { $escap = $escap."kg";}
                if ($reste =~ /C/) { $escap = $escap."cm";}
                $escap = $escap.$reste;
            }
        }
    }
    # identical ?
    if ($ident) {
        $res = &uie::copy8structure(str=>$lpi);
        $res->{n} = $ipi->{n};
        return $res;
    }
    ## not identical
    # scalar pi.s
    foreach my $scal ("t","o","d") {
        if ($cum =~ /$scal/) { unless ($escap =~ /$scal/) {
            # cumulation is asked for
            unless ($res->{$scal}) { ## PEUT-ÊTRE faut-il utiliser 'defined' ???
                # effective only when the pi isn't already provided
                if ($scal eq "t") {
                    # special case of the time
                    $res->{t} = &get8date(nam=>$ipi->{n},tim=>$cpi->{t});
                } else {
                    # standard case
                    if ($ipi->{$scal} eq "") { $res->{$scal} = $cpi->{$scal};}
                }
            }
        }}
    }
    # vectorial pi.s
    my $nbc = scalar(@{$cpi->{c}}) - 1;
    foreach my $scal ("c","m","p","q","k","g") {
        if ($cum =~ /$scal/) { unless ($escap =~ /$scal/) {
            # getting the part to cumulate
            my @cumu = ();
            for (0..$nbc) { if ($cpi->{$scal}->[$_]->[0]) { 
                push @cumu,@{$cpi->{$scal}->[$_]};
            }}
            # adding when it exists, the individual part
            if ($ipi->{$scal}->[0]) { push @cumu,@{$ipi->{$scal}};}
            # filling the value
            @{$res->{$scal}} = @cumu;
        }}
    }    
    # technical parameter pi
    unless ($escap =~ /h/) {
        # non dimension cases
        for my $ke (keys %{$cpi->{h}}) {
            unless ($ke =~ /(WID)|(wid)|(HEI)|(hei)/) {
		# not the case of dimension
                unless (defined($ipi->{h}->{$ke})) {
		    # the parameter is not defined at the individual level
		    if (defined($cpi->{h}->{$ke})) {
			# defined at the collective level
                        $res->{h}->{$ke} = $cpi->{h}->{$ke};
		    } elsif (defined($cpi->{h}->{uc($ke)})) {
			# defined at the COLLECTIVE level
                        $res->{h}->{$ke} = $cpi->{h}->{uc($ke)};
		    }
                }
            }
        }
        # the tricky dimension case
        unless (defined($ipi->{h}->{wid}) or defined($ipi->{h}->{hei})) {
            # no dimension was defined as the individual level
            if (defined($cpi->{h}->{wid}) or defined($cpi->{h}->{hei})) {
                # dimension was defined as the collective lower case
                if (defined($cpi->{h}->{wid})) { $res->{h}->{wid} = $cpi->{h}->{wid};}
                if (defined($cpi->{h}->{hei})) { $res->{h}->{hei} = $cpi->{h}->{hei};}
            } else {
                if (defined($cpi->{h}->{WID}) or defined($cpi->{h}->{HEI})) {
                    # dimension was defined as the collective upper case
                    if (defined($cpi->{h}->{WID})) { $res->{h}->{wid} = $cpi->{h}->{WID};}
                    if (defined($cpi->{h}->{HEI})) { $res->{h}->{hei} = $cpi->{h}->{HEI};}
                }
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
    #      index file (eif). A central subroutine for
    #      the pg.album program since all used conventions
    #      are implemented in it.
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
    #   BE AWARE THAT SOME COLLECTIVE PI.S CAN BE LOST if not associated to 
    #          a set of images. The aim is to annotate, not to build a text,
    #          so information not focused to annotation of pictures is 
    #          not considered. Nevertheless upper case technical parameters
    #          are not lost except when an empty set is proposed.
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
    # TO DO: Clarify and improve the management of collective pi, Why not
    #        allow successive definition for upper case technical parameters?
    #        Why no repeat them at the beginning of each new circumstance in 
    #        the produced eif, even if they are not modified?
    #
    # arguments
    my $hrsub = {eif  =>[undef,  "c","The root of the edited index file to transform",
                                     "('-eif.txt' suffix will be added)."],
                 out  =>[undef,  "c","The root of the transformed file to create",
                                     "('-dif.txt' or '-icf.txt' suffix will be added)."],
                 typ  =>["dif",  "c","Type of the created file if not must be 'icf'"],
                 new  =>[    1,  "n","Must not the 'out' file to already exist?",
                                     "If so and 'bsk' is not provided a message error is",
                                     "returned. Whenissued. When 'bsk' is provided,",
                                     "it is replaced after being saved into the basket."],
                 slf  =>[   "",  "c","Root of the selection definition file to use",
                                     "when '', no selection is performed",
                                     "('-slf.txt' suffix will be added).",
			             "Only selected images are left in the output file"],
		 bsk  =>[   "",  "c","The basket where to save the output file",
			             "if it exists and 'new' is 1 except to the default",
			             "value ''."]
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
    my $bsk = $argu->{bsk};
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
    $impint = "sel.pau.slf";
    $impint = "pau";
    # to check duplication of images (now forbidden)
    my %verdup = ();
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
	    unless ($bsk) {
		$res = &uie::add8err(err=>"",nsu=>$nsub,
				     erm=>["File $out already exists and appending isn't accepted!"]);
		return $res;
            } else {
		$res = &uie::save8file(fil=>$out,wha=>"p",cor=>$bsk);
		if (&uie::err9(obj=>$res)) { return $res;}
	    }
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
    my $colpi  = &new7pi(wha=>"COL"); # to store the current collective pi.s
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
                $pkad = &read8st7f(fil=>"$ax[1]-$idif{stf}.txt",ref=>$pkad);
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
#            if ($fifi->[$ii] =~ /^$indi\s/) {
            if (defined($fifi->[$ii])) {if ($fifi->[$ii] =~ /^$indi\s/) {
                my $line = splice(@$fifi,$ii,1);
                $faite = 1;
#            }
	}}
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
            # line to copy as it is when a dif is aimed to
            # exception raised on 18_12_31
            if ($typ eq "dif") { print TOUTOU $li,"\n";}
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
                    # the current collective pi.s must be updated
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
                    # incoporating the collective pi.s in the found image just to know if it must be selected
                    my $sima = &uie::check8err(obj=>&col7pi2ind7pi(cpi=>$colpi,ipi=>$lue,lpi=>$laspic,cum=>"cmpqkgtod"),
                                              sig=>"(From $nsub [-2])");
                    #&uie::la(str=>$sima,mes=>"sima");
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
                    # incoporating the collective pi.s in the found image
		    my $ymettre = "to";
		    if ($typ eq "icf") { $ymettre = "cmpqkgtod";}
                    my $vam = &uie::check8err(obj=>&col7pi2ind7pi(cpi=>$colpi,ipi=>$lue,lpi=>$laspic,cum=>$ymettre),
                                          sig=>"(From $nsub [2])");
                    #&uie::la(str=>$vam,mes=>"vam");
                    # replacing shortcuts with their values
                    my $vamt = &update8st7pi(xpi=>$vam,stc=>$pkad);
                    # the image was selected, some writing to do
                    if ($newpic and $dif) {
                        # write the additionnal pi after replacing its shortcuts
                        my $colpit = &update8st7pi(xpi=>$colpi,stc=>$pkad);
                        print TOUTOU &pi2line(xpi=>$colpit),"\n";
                    }
                    # check for possible duplication
                    my $nono = $vamt->{"n"};
                    if (defined($verdup{$nono})) {
                        $verdup{$nono}++;
                        #&uie::la(str=>$vam,mes=>"vam");
                    } else {
                        $verdup{$nono} = 1;
                    }
                    # write the picture itself
                    print TOUTOU &pi2line(xpi=>$vamt),"\n";
                    # keeping the future last picture
                    $laspic = &uie::copy8structure(str=>$vam);
                    $newpic = 0; # collective pi.s already written in case of DIF
                    ## removing non permanent collective pi
                    for my $rt ("nbi","gnl","gnc","cap") {
                        $colpi->{h}->{$rt} = $cdefa->{$rt};
                    }

                }
            }
        }
    }
    # introducing the categories
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
    # checking for duplication
    foreach (keys %verdup) {
        unless ($verdup{$_} > 1) {delete $verdup{$_};}
    }
    my $nbdi = scalar(keys %verdup);
    if ($nbdi > 0) {
        &uie::print8structure(str=>\%verdup); print "\n";
        $res = &uie::add8err(err=>"no",nsu=>$nsub,
                             erm=>["$nbdi images were found duplicated in the input EIF $eif",
                                   "Their list was just displayed. This is not valid!",
                                   "If you want the same images more than once in your output",
                                   "copy it with different names...",
                                   "EVEN if they are coming from different directories,",
                                   "PHOGES forces you to give them a different name"
                                  ]);
    }
    # returning
    $res;
}
#############################################
#
##<<
sub fit8image {
    #
    # title : transform one image to an exact precision
    #
    # aim : produce images with convenient sizes
    #         from an original image base, accordingly
    #         with the dimensions they will be printed.
    #      When both height and width of the destination
    #         image are given, the resulting image
    #         can be not homothetic to the original one,
    #         this is why usually either only one dimension
    #         is given, the other is computed
    #      Already prepared (according to epr and eps 
    #         criteria) images are not rebuilt.
    #      The original image cannot be modified.
    #
    # notice that care can be taken from the portrait shots
    #        with the auto-orient option of ImageMagick::convert
    #
    # remarks : x ImageMagick facilities are used
    #           x Perl module Image::Size is used to know image dimensions
    #           x a temporary original is created, possibly
    #             auto-oriented, and then deleted.
    #           x Resulting image can be a magnified image
    #
    # TO REMEMBER : in a first step, I gave the same name
    #               for the temporary file but PERL was to fast
    #               with respect to the file copy/delete that
    #               this produced a terrific mess!
    #
    # output : [$orient,$transf]
    #           $orient = 1 if auto-orientation was applied
    #                     0 if not
    #           $transf = 1 when the image has been transformed
    #                     0 a convenient image was already present
    #
    #           or an error message when something went wrong
    #
    # arguments
    my $hrsub = {orf  =>[undef,  "c","Name of the original picture file"],
                 def  =>[undef,  "c","Name of the destination picture file"],
                 auo  =>[    0,  "n","Must auto-orientation transformation be applied",
                                     "on the original image (will be kept untouched)",
                                     "before the potential selection for transformation?"],
                 hei  =>["0mm",  "cu","Height dimension of the printed picture (eg: 5.4cm),", 
                                     "must be given 'cm' or 'mm' (lower case), can be 'undef'",
                                     "A value of '0' or 'undef' means that this argument must not be considered",
                                     "but either 'hei' or 'wid' must be given if not 'wid' will be put to '8cm'"],
                 wid  =>["0mm",  "cu","Width dimension of the printed picture (same details as 'hei')"],
                 ppi  =>[  300,  "n","Desired number of pixels per inch for the destination picture.",
                                      "When zero, the original image will just copied",
                                      "When negative, the number of pixels for the greater dimension"],
                 eps  =>[  0.02, "n","Relative tolerance limit to accept an already existing destination file"],
                 qua  =>[    85, "n","Quality percentage to use with the 'convert' commande"],
                 imp  =>[    1,  "n","0: no message; 1: found dimensions displayed,",
                                     "2: convert displayed, 3: 1+2"],
                 tmp  =>["."  ,  "c","directory where to place the temporary copy of the original image file"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $orf = $argu->{orf};
    my $def = $argu->{def};
    my $auo = $argu->{auo};
    my $hei = $argu->{hei}; unless (defined($hei)) { $hei = "0mm";}; $hei = &uie::clean8string(str=>$hei); if ($hei eq "") { $hei = "0mm";}
    my $wid = $argu->{wid}; unless (defined($wid)) { $wid = "0mm";}; $wid = &uie::clean8string(str=>$wid); if ($wid eq "") { $wid = "0mm";}  
    my $ppi = $argu->{ppi};
    my $imp = $argu->{imp};
    my $eps = $argu->{eps};
    my $qua = $argu->{qua};
    my $tmp = $argu->{tmp};
    my $res = "";
    # further checking and transformation of the arguments
    unless (-e $orf) {
        $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>["The original image file ($orf) was not found"]);
    }
    if (-e $def) { if ($orf eq $def) {
        $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>["Original and destination image files ($orf) must not be the same"]);
    }}
    unless (defined($hei) or defined($wid)) {
        $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>["At least either height or width of the destination image must be defined"]);
    } else {
        if (defined($hei)) {
            unless ($hei =~ /[c,m]m$/) {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>["Height must be defined in 'cm' or 'mm'"]);
            } else {
                my $coef = 1;
                if ($hei =~ /cm$/) { $hei =~ s/cm$//; $coef=10}
                if ($hei =~ /mm$/) { $hei =~ s/mm$//;}
                unless (looks_like_number($hei)) {
                    $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>["The value for height is not a number: $hei"]);
                } else { $hei = abs($coef*$hei);}
            }
        }
        if (defined($wid)) {
            unless ($wid =~ /[c,m]m$/) {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>["Width must be defined in 'cm' or 'mm'"]);
            } else {
                my $coef = 1;
                if ($wid =~ /cm$/) { $wid =~ s/cm$//; $coef=10}
                if ($wid =~ /mm$/) { $wid =~ s/mm$//;}
                unless (looks_like_number($wid)) {
                    $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>["The value for width is not a number: $wid"]);
                } else { $wid = abs($coef*$wid);}
            }
        }
        if (&uie::err9(obj=>$res)) { return $res;}
        else {
            if (($hei+$wid == 0) and ($ppi)) {
		$wid = "80"; 
                #$res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>["Both height and width cannot be zero, one of them must be defined"]);
                #return $res;
            }
        }
    }
    # duplicating the original image, possibly auto-orientating it
    # HERE USING THE SAME TEMPORARY FILE GIVE ME SOME HOURS
    # TO DISCOVER A MESS..
    my @toto = split(/\//,$orf);
    my $temporfi = $tmp."/totototototo.".$toto[$#toto];
    unless (copy($orf,$temporfi)) {
        $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>["Not possible to copy $orf as $temporfi"]);
        return $res;
    }
    # practicing the auto-orientation
    my $mgf = 0;
    if ($auo) {
        my $orientation = &image9(ifi=>$temporfi,out=>"o");
        if ( $orientation != 1) {
            $mgf = 1;
            my $com = "mogrify -auto-orient $temporfi";
            if (system($com)) {
                $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>["$com line command was unsuccessful!"]);
                return $res;
            }
        }
    }
    # looking for the original image size
    my $transi =  &image9(ifi=>$temporfi,out=>"S");
    my ($orw,$orh) = @{$transi}[0,1];
    unless (defined($orw) and defined($orh)) {
        $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>["Not possible to find the dimensions of image: $orf (copied as $temporfi)"]);
        return $res;
    }
    # computing the pixel size of the desired destination file
    my ($dew,$deh);
    if ($ppi >= 0) {
	# according the indicated density (or just a copy)
	if ($wid == 0) { $wid = $hei / $orh * $orw;}
	if ($hei == 0) { $hei = $wid / $orw * $orh;}
	$dew = int($wid / 25.4 * $ppi + 0.5);
	$deh = int($hei / 25.4 * $ppi + 0.5);
    } else {
	# imposing the pixel number
	$ppi = -$ppi;
	if ($orw >= $orh) {
	    $dew = $ppi;
	    $deh = $orh / $orw * $dew;
	} else {
	    $deh = $ppi;
	    $dew = $orw / $orh * $deh;
	}
    }
    if (($imp == 1) or ($imp == 3)) {
        my @fifi = fileparse($orf);
        my $fifi = $fifi[0].$fifi[2];
        my @fofo = fileparse($def);
        my $fofo = $fofo[0].$fofo[2];
        print "<$fifi> \t($orw,$orh) \t=> \t<$fofo> \t(",int($dew),",",int($deh),")  ";
    }
    # building or accepting the destination image
    my $faire = 1;
    if (-e $def) {
        # destination file already exists
        my ($ddw,$ddh) = @{&image9(ifi=>$def,out=>"S")};
        if (($imp == 1) or ($imp == 3)) {
            print "[",$ddw,",",$ddh,"]";
        }
        # are its dimension compatible?
        if ($ppi == 0) {
            my $testgood = `diff $orf $def`;
            unless ($testgood) {$faire = 0;}
        } else {
            unless ((abs(($ddw-$dew)/$dew) > $eps) or (abs(($ddh-$deh)/$deh) > $eps)) { $faire = 0;}
        }
    }
    if (($imp == 1) or ($imp == 3)) {
        if ( $faire) {
            if (-e $def) { print "\tRECREATED\n";}
            else { print "\t  CREATED\n";}
        } else {
            print "\tALREADY present and acceptable\n";
        }
    }
    # if finished returning
    unless ($faire) {
        unlink($temporfi);
        return [$mgf,0];
    }
    # proceeding to the transformation
    if ($ppi) {
        $dew = int($dew+0.5);  $deh = int($deh+0.5);
        my $com = "convert -quality $qua -geometry ${dew}x${deh}! $temporfi $def";
        if ($imp > 1) { print ">>>>>   ",$com,"\n";}
        my $rst = system $com;
    } else {
        unless (copy($orf,$def)) {
            $res = &uie::add8err(err=>$res,nsu=>$nsub,erm=>["Cannot copy <$orf> as <$def>"]);
        } else {
            print "|||||  <$orf> copied as <$def>\n";
        }
    }
    unlink($temporfi);
    # returning
    unless (&uie::err9(obj=>$res)) { $res = [$mgf,1];}
    $res;
}
#############################################
#
#
##<<
sub shrink8di7f {
    #
    # title : shrink a dif and increase its levels
    #
    # aim : from a decoded index file (dif) produce
    #      a reduced one to its circumstances comprising
    #      images. And, possibly, increasing by the same
    #      number all its circumstances.
    # 
    # output : 1 when the analysis of the edited
    #         file was without trouble, if not an 
    #         error message testable with '&uie::check8err'.
    #
    # arguments
    my $hrsub = {idi  =>[undef,  "c","The root of the input dif file to transform",
                                     "('-dif.txt' suffix will be added)."],
                 odi  =>[undef,  "c","The root of the transformed file to create",
                                     "('-dif.txt' suffix will be added)."],
                 inc  =>[    0,  "n","The amount of levels to add to each circumstance"],
                 new  =>[    1,  "n","Must not the 'out' file to already exist?",
                                     "If so a message error is issued."]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $idi = $argu->{idi}; $idi = $idi."-dif.txt";
    my $odi = $argu->{odi}; $odi = $odi."-dif.txt";
    my $inc = $argu->{inc};
    my $new = $argu->{new};
    my $err = "";
    # about the output file
    if ($new) {
        if (-e $odi) {
            $err = &uie::add8err(err=>$err,nsu=>$nsub,
                                 erm=>["File $odi already exists and appending isn't accepted!"]);
            return $err;
        }
    }
    # reading the input dif
    my $idic = &uie::read8line(fil=>$idi);
    if (&uie::err9(obj=>$idic)) {
	$err = $idic;
	$err = &uie::add8err(err=>$err,nsu=>$nsub,
			     erm=>["called by"]);
	return $err;
    }
    my $res = []; my $cod = [];
    # analyzing the dif
    # each line can be a circumstance [coded by its initial level],
    # an image [coded by -20] or another line [coded by -10]
    foreach my $lig (@$idic) {
        if ($lig =~ /\Q$phoges::fram{C}->[0]\E(.*)\Q$phoges::fram{C}->[1]\E\s*(.*)\s*$/) {
            # a collective circumstance
            my $nle = $1 + $inc;
            my $con = $2;
	    my $nli = "$phoges::fram{C}->[0]$nle$phoges::fram{C}->[1] $con";
	    push @$res,$nli; push @$cod,$1;
	} else {
	    my $voir = &ima7line9(lin=>$lig);
	    if (&uie::err9(obj=>$voir)) { return $voir;}
            if ($voir) {
		# a line not to be reproduced
		push @$res,$lig; push @$cod,-20;
	    } else {
		# an ordinary line to be reproduced
		push @$res,$lig; push @$cod,-10;
	    }
		    }
    }
    ## shrinking the dif
    my $nbt = scalar(@$res) - 1;
    # keeping every line
    my @kept = map {1} (0..$nbt);
    # a priori removing circumstance lines
    for (my $i = 0; $i <= $nbt; $i++) {
	if ($cod->[$i] >= 0) {
	    $kept[$i] = 0;
	}
    }
    # keeping only circumstance lines associated to some image
    for (my $i = 0; $i <= $nbt; $i++) {
	if ($cod->[$i] < -15) {
	    my $vcir = 100; # to follow the hierarchy of the image
	    # it is an image line
	    for (my $j = $i-1; $j >= 0; $j--) {
		if ($cod->[$j] >= 0) {
		    # it is a circumstance line
		    if ($vcir == 100) {
			# nearest level
			$kept[$j] = 1;
			$vcir = $cod->[$j];
		    } else {
			if ($cod->[$j] == ($vcir - 1)) {
			    # this one belong to the hierarchy
			    $kept[$j] = 1;
			    $vcir--;
			}
		    }
		}
	    }
	}
    }
    # from the circumstance to remove, detect which collective line must be filtered
    my @filt = map {0} (0..$nbt);
    for (my $i = 0; $i <= $nbt; $i++) {
	if (($cod->[$i] >= 0) and ($kept[$i] == 0)) {
	    # this circumstance level must be removed
	    my $oui = 1;
	    for (my $j = $i+1; $j <= $nbt; $j++) {
		if ($oui) {
		    if ($cod->[$j] >= 0) {
			if ($cod->[$j] <= $cod->[$i]) {
			    $oui = 0;
			}
		    } elsif ($cod->[$j] == -10) {
			$filt[$j] = 1;
		    }
		}
	    }
	}
    }
    # filtering out the detected lines
    for (my $i = 0; $i <= $nbt; $i++) {
	if ($filt[$i]) {
	    my $pis = &analyze8line(lin=>$res->[$i]);
            my $dete = analyze8line(lin=>$res->[$i]);
	    if ($dete->{y} eq "col") { 
		if (&uie::err9(obj=>$pis)) {
		    print "\n\n\n";
		    print "line 'res->[$i] was not a collective line within $nsub\n";
		    print "\n\n\n";
		    return $pis;
		}
		# removing the non-significant pi.s
		foreach my $ipis ("m","p","q","k","g") {
		    if (defined($pis->{$ipis})) { delete($pis->{$ipis});}
		}
		my $lpis = &pi2line(xpi=>$pis,xco=>1);
		if (&uie::err9(obj=>$lpis)) {
		    print "\n\n\n";
		    print "line 'res->[$i] was not a collective line within $nsub\n";
		    print "\n\n\n";
		    return $lpis;
		}
		$res->[$i] = $lpis;
            } else {
		# another type of line to remove
		$kept[$i] = 0;
	    }
	}
    }
    # writing the resulting dif
    open(TOU,">$odi") or die("Not possible to open $odi to write the resulting 'dif' in it");
    my $nunu = 0;
    foreach (@$res) {
	if ($kept[$nunu]) {
	    print TOU $res->[$nunu],"\n";
	}
	$nunu++;
    }
    close(TOU);
    #
#my $kk = 0;
#foreach (@$res) {
#    print $kk," : ",$kept[$kk]," : ",$filt[$kk]," : ",$cod->[$kk]," : ",$res->[$kk],"\n";
#    $kk++;
#}
    # returning
    1;
}
#############################################
#
#
##<<
sub ima7line9 {
    #
    # title : is it an image line?
    #
    # aim : test if the line of eif/dif/icf describes
    #       an image
    # 
    # output : 1 if yes, 0 if not
    #          or possibly an error message
    #
    # arguments
    my $hrsub = {lin  =>[undef,  "c","The line to test"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $lin = $argu->{lin};
    #
    my $res;
    # testing
    my $tes = &analyze8line(lin=>$lin);
    if (&uie::err9(obj=>$tes)) { return $tes;}
    $res = ($tes->{y} eq "ind");
    # returning
    $res;
}
#############################################
#
#
##<<
sub st4f {
    #
    # title : get shortcuts from a 'stf' 
    #
    # aim : read the 'stf' file and returns
    #       the asked shorcuts
    # 
    # output : a reference to a hash having
    #            shortcuts as keys and definitions
    #            as associated values,
    #          or possibly an error message.
    #
    # arguments
    my $hrsub = {fil  =>[  undef,  "c","The file to scrutate"],
		 whi  =>[["cat"],  "a","Reference to the array of the desired",
			               "type shortcuts. When empty, all types",
                                       "are considered"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $fil = $argu->{fil};
    my $whi = $argu->{whi};
    if (scalar(@$whi) == 0) { $whi = [values %idrf]; }
    #
    #
    # reading the shortcut files
    my %khh;
    foreach (values(%phoges::idrf)) { $khh{$_} = 0;}
    my $tst = &uie::check8err(obj=>&uie::read8line(fil=>$fil,typ=>2,khh=>\%khh),
                              sig=>$nsub,wha=>1);
    if (&uie::err9(obj=>$tst)) { return $tst;}
    # getting asked shortcuts
    my $res = {};
    foreach (@$whi) {
	if (defined($tst->{$_})) {
	    foreach my $i (keys %{$tst->{$_}}) {
		$res->{$i} = $tst->{$_}->{$i};
	    }
	}
    }
    # returning
    $res;
}
#############################################
#
#
##<<
sub purge8st7f {
    #
    # title : eliminate multiple definition of shortcuts
    #
    # aim : read a file possibly containing shortcuts
    #       and retain only the first one (other
    #       lines are eliminated.
    # 
    # output : 1 if work is well done, if not
    #            an error message.
    #
    # arguments
    my $hrsub = {fil  =>[  undef,  "c","The file to scrutate"],
		 imp  =>[      0,  "n","Must multiple occurrence be displayed?"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $fil = $argu->{fil};
    my $imp = $argu->{imp};
    #
    # reading the file to purge
    my $ifi = &uie::check8err(obj=>&uie::read8line(fil=>$fil),
                                sig=>$nsub,wha=>1);
    if (&uie::err9(obj=>$ifi)) { return $ifi;}
    #
    # detecting multiple occurrence
    my $ccc = {};
    foreach my $i (values %idrf) { $ccc->{$i} = {};}
    #
    my @lfi = map {1} @$ifi;
    for (my $i = 0; $i < scalar @lfi; $i++) {
	my $line = $ifi->[$i];
	my @deco = split / /,$line;
	foreach my $cle (values %idrf) {
	    if ($deco[0] eq $cle) {
		shift @deco;
		my $rac = shift @deco;
		my $con = join " ",@deco;
		if (defined($ccc->{$cle}->{$rac})) {
		    $lfi[$i] = 0;
		    if ($imp) {
			print "The following line will be suppressed:\n";
			print "<$line>\n\n";
		    }
		} else {
		    $ccc->{$cle}->{$rac} = $con;
		}
	    }
	}
    }
    #
    # writing again the file without dectected lines
    open(TOTO,">$fil") or die("Cannot Open $fil to rewrite it!");
    for (my $i = 0; $i < scalar @lfi; $i++) {
	if ($lfi[$i]) {
	    print TOTO $ifi->[$i],"\n";
	}
    }
    close TOTO;
    #
    # returning
    1;
}
#############################################
#############################################
1;

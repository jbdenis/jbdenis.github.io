#
# functions to be used in perl scripts
#           to generate latex/pdf  files
# 
# 17_12_22 18_02_02 18_02_06 18_02_10 18_02_11
# 18_02_12 18_02_13 18_02_18 18_02_10 18_02_22
# 18_02_27 18_03_02 18_03_03 18_04_08 18_04_09
# 18_04_10 18_04_11 18_10_04 18_11_15 19_01_16
# 19_01_21 19_01_23 19_02_04 19_02_11 19_02_12
# 19_03_03 19_03_04 19_11_14 20_04_06
#
package lhattmel;
use strict;
use warnings;
#
use List::Util qw[min max];
use lib "/home/jbdenis/u/perl";
use uie;
#
###<<<
#
# 'lhattmel' for 'LATEx/HTML Generator'.
#
# This module was written to automatically produce pdf files
# first of all to generate albums from annotated series of
# pictures. As the task is quite general, I decided to give
# it an independent development.
#
# As html and latex files have got similar structures, both
# developments were undertaken at the same time.
#
# TO DO:
#      * allow the monitoring of the order of the
#        pi's when building an image caption.
#
#
###>>>
#############################################
#############################################
# Some general constants
#############################################
our %brli = (l=>"\\hspace{\\textwidth}",h=>"<br>");
# In LATEX breaklines are not effective...
$brli{l} = "";
# 
our %sepa = (liste=>";;",flat=>" - ",);
#
our $vsp7fig7cap = 2;
#
#############################################
##<<
sub l7e {
    #
    # title : escaping special characters for latex
    #
    # aim : allow the easy use of '_' which I like very much
    #       Other special Latex characters are also considered
    #       But some latex command, are preserved:
    #         \newpage \newline \quad \medskip
    # 
    # output : reference to the transformed array of strings
    #          or the transformed string
    #
    # remark: this routine was found on internet, the original
    #         name was 'latex_escape'
    #
    # arguments
    my $hrsub = {cha  =>[undef,"ac","The string or array of string to transform"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $cha = $argu->{cha};
    # initialization
    my $inp = $cha; my $res=[];
    unless (ref($cha) eq "ARRAY") { $inp = [$cha];}
    # simple loop
    foreach my $aaa (@$inp) {
        my $aa = $aaa; # necessary to avoid the argument to be transformed !!!
        # Replace a \ with $\backslash$
        # This is made more complicated because the dollars will be escaped
        # by the subsequent replacement. Easiest to add \backslash
        # now and then add the dollars
        $aa =~ s/\\/\\backslash/g;

        # Must be done after escape of \ since this command adds latex escapes
        # Replace characters that can be escaped
        $aa =~ s/([\$\#&%_{}])/\\$1/g;
        # Replace ^ characters with \^{} so that $^F works okay
        $aa =~ s/(\^)/\\$1\{\}/g;
        # Replace tilde (~) with \texttt{\~{}}
        $aa =~ s/~/\\texttt\{\\~\{\}\}/g;
        # Now add the dollars around each \backslash
        $aa =~ s/(\\backslash)/\$$1\$/g;
	# preserving some latex commands
        $aa =~ s/(\$\\backslash\$newpage)/\\newpage /g;
        $aa =~ s/(\$\\backslash\$newline)/\\newline /g;
        $aa =~ s/(\$\\backslash\$quad)/\\quad /g;
        $aa =~ s/(\$\\backslash\$medskip)/\\medskip /g;
        # storing
        push @$res,$aa;
    }
    # returning
    unless (ref($cha) eq "ARRAY") { $res = $res->[0];}
    $res;
}
#############################################
##<<
sub indent {
    #
    # title : just add some spaces before a string
    #
    # aim : ease the presentation of latex/html source
    # 
    # output : the transformed string
    #
    # arguments
    my $hrsub = {cha  =>[undef,"ac","The string or array of string to transform"],
                 ind  =>[    1,"n","Number of indentations to add"],
                 siz  =>[    2,"n","Size of each indentation"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $cha = $argu->{cha};
    my $ind = $argu->{ind};
    my $siz = $argu->{siz};
    # initialization
    my $inp = $cha; my $res=[];
    unless (ref($cha) eq "ARRAY") { $inp = [$cha];}
    # transformation
    my $ajou = " " x ($ind*$siz);
    foreach my $aa (@$inp) {
        unless ($aa =~ /^\s*$/) { push @$res,$ajou.$aa;}
    }
    # returning
    unless (ref($cha) eq "ARRAY") { $res = $res->[0];}
    $res;
}
#############################################
#
##<<
sub start {
    #
    # title : constitutes the document head
    #
    # aim : according to the type, necessary
    #      tagging is produced.
    # 
    # output : an array of characters
    #
    # arguments
    my $hrsub = {typ  =>["l",  "c","type of the document: 'l' for latex, 'h' for html."],
                 par  =>[{cod=>"utf8",tit=>"",aut=>"",dat=>1,
                          toc=>1,npa=>1,two=>0,lma=>"15mm",
                          rma=>"15mm",tma=>"15mm",bma=>"15mm",
                          lgu=>"french",par=>[],bpa=>'\vspace {25mm}',
                          },
                            "h","The different parameters for the heading:",
                                      "cod: encoding",
                                      "tit: the title",
                                      "aut: the author",
                                      "dat: the date (when '0' no date, when '1' present day",
                                      "toc: 1 to get the table of contents",
                                      "npa: 1 to get a new page after the preamble",
                                      "two: 1 to get two columns (only for latex)",
                                      "lma: left margin (only for latex)",
                                      "rma: right margin (only for latex)",
                                      "tma: top margin (only for latex)",
                                      "bma: bottom margin in mm (only for latex)",
                                      "lgu: language (only for latex)",
                                      "fig: label for the numeration of items (only for latex)",
                                      "par: some paragraph to add after the title (can comprise lists)",
                                      "bpa: the latex tag to add before introducing 'par'",
                                      "      (it only used when 'par' is not empty)"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $typ = $argu->{typ};
    my $par = $argu->{par};
    # giving default to non attributed keys
    if (!defined($par->{cod})) { $par->{cod} = "utf8";}
    if (!defined($par->{tit})) { $par->{tit} = "~";}
    if (!defined($par->{aut})) { $par->{aut} = "";}
    if (!defined($par->{dat})) { $par->{dat} = 1;}
    if (!defined($par->{toc})) { $par->{toc} = 1;}
    if (!defined($par->{npa})) { $par->{npa} = 0;}
    if (!defined($par->{two})) { $par->{two} = 0;}
    if (!defined($par->{lma})) { $par->{lma} = "15mm";}
    if (!defined($par->{rma})) { $par->{rma} = "15mm";}
    if (!defined($par->{tma})) { $par->{tma} = "15mm";}
    if (!defined($par->{bma})) { $par->{bma} = "15mm";}
    if (!defined($par->{lgu})) { $par->{lgu} = "french";}
    if (!defined($par->{fig})) { $par->{fig} = "Ph.";}
    if (!defined($par->{bpa})) { $par->{bpa} = '\vspace {25mm}';}
    # computing some values
    if ($par->{dat} eq "0") { $par->{dat} = "";}
    if ($par->{dat} eq "1") {
        $par->{dat} = &uie::now(fmt=>"ver");
    }
    # initialisation
    my $res = [];
    if ($typ eq "l") {
        # latex type
        push @$res,"%";
        push @$res,"%% created with 'latex1html4file' on ".&uie::now();
        push @$res,"%";
        my $colonnes = "";
        if ($par->{two} == 1) {
            $colonnes = "twocolumn,";
        }
        my $ax = "\\documentclass[12pt,".$colonnes.$par->{lgu}."]{article}";
        push @$res,$ax;
        push @$res,"\\usepackage[T1]{fontenc}";
        push @$res,"\\usepackage{float}";
        push @$res,"\\usepackage[".$par->{cod}."]{inputenc}";
        push @$res,"\\usepackage[a4paper]{geometry}";
        push @$res,"\\geometry{verbose,tmargin=".$par->{tma}.
                                     ",bmargin=".$par->{bma}.
                                     ",lmargin=".$par->{lma}.
                                     ",rmargin=".$par->{rma}."}";
        push @$res,"\\usepackage{graphicx}";
        push @$res,"\\usepackage{babel}";
        push @$res,"\\usepackage{pdflscape}";
        push @$res,"\\addto\\captions".$par->{lgu}."{";
        push @$res,"\\renewcommand{\\figurename}{".$par->{fig}."}";
        push @$res,"}";
        #
        if ($par->{two}) { 
            push @$res,"\\usepackage{tocloft}";
            push @$res,"\\renewcommand{\\cftsecleader}{\\cftdotfill{\\cftdotsep}}";
        }
        push @$res,"%";
        push @$res,"\\begin{document}";
        my $titi = 0;
        if ($par->{tit} ne "") {
            push @$res,"\\title{".&lhattmel::l7e(cha=>$par->{tit})."}";
            $titi = 1;
        }
        push @$res,"\\author{".&lhattmel::l7e(cha=>$par->{aut})."}";
        if ($par->{dat} ne "") {
            push @$res,"\\date{".$par->{dat}."}";
            $titi = 1;
        }
        if ($titi) {
            push @$res,"\\maketitle";
        }
        if ($par->{toc}) {
            push @$res,"\\tableofcontents";
        }
        if ($par->{npa}) {
            push @$res,"\\newpage";
        }
        if ($par->{par}) {
            #&uie::la(str=>$par->{bpa},mes=>"bpa");
	    if ($par->{bpa}) {
                push @$res,($par->{bpa});
	    }
            push @$res,@{&parag(prg=>$par->{par})};
        }
    } elsif ($typ eq "h") {
        # html type
        # opening
        push @$res,"<html>";
        # commenting
        push @$res,"<!-- created with 'latex1html4file' on ".&uie::now()." -->";
        # heading
        push @$res,"  <head>";
        push @$res,"  <meta http-equiv=\"content-type\" content=\"text/html; charset=".$par->{cod}."\">";
        if ($par->{tit} ne "") {
            push @$res,"  <title>".$par->{tit}."</title>";
        }
        push @$res,"  </head>";
        #
        push @$res,"  <body>";
        if ($par->{tit} ne "") {
            push @$res,"    <h1>".$par->{tit}."</h1>";
        }
        if ($par->{aut} ne "") {
            push @$res,"    <h3>".$par->{aut}."</h3>";
        }
        if ($par->{dat} ne "") {
            push @$res,"    <h3>".$par->{dat}."</h3>";
        }
        # TO BE DONE SOMETIME
        #    # making the table of contents
        #    if (param$taoco) {
        #      if (length(sectit) > 0) {
        #        # removing firts the null sections
        #        nuse <- which(belong9(substr(names(sectit),1,2),"0.",how="v"));
        #        if (length(nuse)>0) { sectit <- sectit[-nuse];}
        #        if (length(sectit) > 0) {
        #          if (param$langu == "french") {
        #            res <- c(res,"<h2> Table des Matie`res </h2>");
        #          } else {
        #            res <- c(res,"<h2> Table of Contents </h2>");
        #          }
        #          for (ico in bf(sectit)) {
        #            # getting the level of the section
        #            nala <- names(sectit)[ico];
        #            ise <- as.numeric(substr(nala,1,1));
        #            res <- c(res,paste0('<h',ise+2,'> ',
        #                                '<a href="#',nala,'">[',ise,']</a> ',
        #                                sectit[ico],
        #                                '</h',ise+2,'>'));
        #          }
        #        }
        #      }
        #    }

        push @$res,"    <hr>";
    }
    # returning
    $res;
}
#############################################
##<<
sub end {
    #
    # title : constitutes the document end
    #
    # aim : according to the type, necessary
    #      tagging is produced.
    # 
    # output : an array of characters
    #
    # arguments
    my $hrsub = {typ  =>["l",  "c","type of the document: 'l' for latex, 'h' for html."]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $typ = $argu->{typ};
    # initialisation
    my $res = [];
    if ($typ eq "l") {
        # latex type
        push @$res,"%","\\end{document}","%";
    } elsif ($typ eq "h") {
        # html type
        push @$res,"  </body>","</html>";
    }
    # returning
    $res;
}
#############################################
##<<
sub subtit {
    #
    # title : constitutes a document subtitle
    #
    # aim : according to the type, necessary
    #      tagging is produced.
    # 
    # output : an array of characters
    #
    # arguments
    my $hrsub = {tit  =>[undef,"c","Title for this subtitle"],
                 lev  =>[1,  "n","level of the subtitle, from 1 to 6",
                                 "negative values means not numbering the subtitle in Latex"],
                 par  =>[{pb=>0}, "h","Further indication on the subtitle presentation.",
                                      " For the moment only 'pb' indicating if a page break must",
                                      "  previously added in latex case"],
                 typ  =>["l",  "c","type of the document: 'l' for latex, 'h' for html."]                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $tit = $argu->{tit};
    my $lev = int $argu->{lev};
    my $par = $argu->{par};
    my $typ = $argu->{typ}; if ($typ eq "l") { $tit = &lhattmel::l7e(cha=>$tit);} 
    my $num = 1;
    if ($lev < 0) {
        $lev = -$lev;
        $num = 0;
    }
    unless ($lev > 0) { $lev = 1;}
    unless ($lev < 5) { $lev = 5;}
    $lev = int($lev);
    # initialisation
    my $res = []; 
    if ($typ eq "l") {
        # latex type
        # Breaking first the page ?
        if ($par->{pb}) {
            push @$res,"\\clearpage";
        }
        my $ltag;
        if ($lev == 1) { $ltag = "\\section";}
        elsif ($lev == 2) { $ltag = "\\subsection";}
        elsif ($lev == 3) { $ltag = "\\subsubsection";}
        elsif ($lev == 4) { $ltag = "\\paragraph";}
        elsif ($lev == 5) { $ltag = "\\subparagraph";}
        unless ($num) { $ltag = $ltag."*";}
        $ltag = $ltag."{";
        push @$res,"%",$ltag.$tit."}","%";
    } elsif ($typ eq "h") {
        # html type
        push @$res,"<h".$lev.">".$tit."</h".$lev.">";
    }
    # returning
    $res;
}
#############################################
##<<
sub parag {
    #
    # title : constitutes a series of paragraphes
    #
    # aim : according to the type, necessary
    #      tagging is produced.
    #
    # remark : When the first word of a paragraph is
    #         'LISTEx' where x =~ /[BNDbnd]/,
    #         the paragraph is interpreted,respectively, as
    #         a itemized/flat bullet, numbered or definition list.
    #         The format is described from the following
    #         simple examples comprising each three items:
    #            'LISTEB First Item;;Second Item;;Last Item'
    #            'LISTEN First Item;;Second Item;;Last Item'
    #            'LISTED premier;;First Item;;second;;Second Item;;dernier;;Last Item'
    #
    # output : an array of characters
    #
    # arguments
    my $hrsub = {prg  =>[undef,"a","Array of the different paragraphs to introduce"],
                 typ  =>["l",  "c","type of the document: 'l' for latex, 'h' for html."]                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $prg = $argu->{prg}; $prg = &lhattmel::l7e(cha=>$prg);
    my $typ = $argu->{typ};
    # initialisation
    my $res = []; 
    if ($typ eq "l") {
        # latex type
        push @$res,"";
        foreach my $pa (@$prg) {
            if ($pa !~ /^LISTE[BNDbnd]/) {
                # it is a standard paragraph
                push @$res,$pa;
                push @$res,"";
            } else {
                # must be a list
                my $lity = substr($pa,length("LISTE"),1);
                my @pa = split(/\Q$sepa{liste}\E/,substr($pa,length("LISTEX")));
                my $lilili = &list(lst=>\@pa,tli=>$lity,typ=>$typ);
                push @$res,@{$lilili};
            }
        }
    } elsif ($typ eq "h") {
        # html type
        foreach (@$prg) {
            push @$res,"<p>";
            push @$res,$_;
            push @$res,"</p>";
        }
    }
    # returning
    $res;
}
#############################################
##<<
sub list {
    #
    # title : constitutes a list
    #
    # aim : according to the type, necessary
    #      tagging is produced.
    # 
    # output : an array of characters
    #
    # arguments
    my $hrsub = {lst  =>[undef,"ah","Array of the different items to introduce",
                                    "for bullet and numbered list. Hash of the different",
                                    "items for definition list, however array of successive",
                                    "(key,value) pairs are admitted but the size of the",
                                    "array must be even; in fact this is a way to keep",
                                    "the order of the components"],
                 tli  =>["B",  "c","Indication of the list type: 'B' for bullet,",
                                   "'N' for number, 'D' for definition and also",
                                   "'b' for flat bullet list, 'n' for flat numbered list and",
                                   "'d' for flat definition list",
		                   " (a flat list is a list without carriage return)."],
		 sel  =>[  0,  "an","The possible selection of items when a definition list.",
			            "When numeric no selection, when array the set of items",
			            "to be retained in that order (another way to impose the",
                                    "order of the item list).",
                                    "Be aware that this imply that every definition item must be unique!"],
                 typ  =>["l",  "c","type of the document: 'l' for latex, 'h' for html."]                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $lst = $argu->{lst};
    my $tli = $argu->{tli};
    my $sel = $argu->{sel};
    my $typ = $argu->{typ};
    # initialisation
    my $res = []; 
    unless ($tli =~ /[BNDbdn]/) {
        print "Asked type list proposed in $nsub is <$tli> which is not accepted!\n";
        die("Please fix the call");
    }
    if (($tli =~ /[Dd]/) and (ref($lst) eq "ARRAY")) {
        if ((scalar(@$lst) % 2) != 0) {
            &uie::la(str=>$lst);
            die("In $nsub the array is given with an odd number: not possible to produce an hash: to be fixed");
        }
    }
    if (($tli !~ /[Dd]/) and (ref($lst) eq "HASH")) {
        die("In $nsub a hash is accepted only for definition lists");
    }
    # introducing the possible selection / order
    if (ref($sel) eq "ARRAY") {
	my %hachis;
	# getting first a hash when an array
	if (ref($lst) eq "ARRAY") {
	    my $nb = scalar(@$lst)/2;
	    for (my $i = 0; $i < $nb; $i++) {
		$hachis{$lst->[2*$i]} = $lst->[1+2*$i];
	    }
	    if ($nb != scalar(keys %hachis)) {
		print 'When transforming the array $lst as a hash, some elements were lost!\n';
		print "This means that keys given as even components are not all distinct!\n";
		die("Then $nsub cannot proceed!");
	    }
	} else {
	    %hachis = %$lst;
	}
	my $bad = 0;
	# going back to the array structure
	$lst = [];
	foreach my $ele (@$sel) {
	    unless (defined($hachis{$ele})) {
		print " "x12," KEY <$ele> to be selected was not found into the list!\n";
		$bad++;
	    } else {
		push @$lst,$ele,$hachis{$ele};
	    }
	}
	if ($bad) {
	    die("Then $nsub found $bad errors and cannot proceed!");
	}
    }
    if (ref($lst) eq "HASH") {
        $lst = [%$lst];
    }
    #
    if ($typ eq "l") {
        # latex type
        if ($tli =~ /[BND]/) {
            # Itemized list
            my $tind = "itemize";
            if ($tli eq "D") { $tind = "description";}
            elsif ($tli eq "N") { $tind = "enumerate";}
            push @$res,("",'\begin{'.$tind.'}');
            if ($tli eq "D") {
                for (my $ii = 0; $ii < scalar(@$lst); $ii=$ii+2) {
                    push @$res,'\item ['.$lst->[$ii].'] '.$lst->[$ii+1];
                }
            } else {
                foreach (@$lst) {push @$res,'\item '.$_;}
            }
            push @$res,('\end{'.$tind.'}',"");
        } else {
            # a flat list
            push @$res,"";
            if ($tli eq "d") {
                my @lili = ();
                for (my $ii = 0; $ii < scalar(@$lst); $ii=$ii+2) {
                    push @lili,"\\textbf\{$lst->[$ii]\}: ".$lst->[$ii+1];
                }
                push @$res,join($sepa{flat},@lili);
            } elsif ( $tli eq "n" ) {
                my @lili = ();
                my $num = 0;
                for (@$lst) { $num++; push @lili,"($num): ".$_;}
                push @$res,join($sepa{flat},@lili);
            } else {
                push @$res,join($sepa{flat},@$lst);
            } 
            push @$res,"";
        }
    } elsif ($typ eq "h") {
        # html type
        &uie::pause(mes=>" to be finished!");
        my $tind = "ul";
        if ($tli eq "d") { $tind = "dl";}
        elsif ($tli eq "n") { $tind = "ol";}
        push @$res,("",'<'.$tind.'>');
        if ($tli eq "d") {
            my $kk = 0;
            foreach (@$lst) {
                $kk++;
            }
        } else {
            foreach (@$lst) {push @$res,'<li> '.$_.'</li>';}
        }
        push @$res,("",'</'.$tind.'>');
    }
    # returning
    $res;
}
#############################################
##<<
sub police {
    #
    # title : introduce police style modification
    #
    # aim : replace simple tags in appropriate tags
    #      according to the type
    # 
    # output : the array of characters after modification
    #
    #      Usually this subroutine is called once the o
    #      complete text has been elaborated
    #
    #  standard tags are introduced as constants and can be
    #      easily modified:
    my %ttxt = (bo=>'_*',bc=>'*_',
                io=>'_+',ic=>'+_',
                eo=>'_%',ec=>'%_');
    my %ttex = (bo=>'\textbf{',bc=>'}',
                io=>'\textit{',ic=>'}',
                eo=>'\emph{'  ,ec=>'}');
    my %thtm = (bo=>'<b>',bc=>'</b>',
                io=>'<i>',ic=>'</i>',
                eo=>'<em>',ec=>'</em>');
    #
    # arguments
    my $hrsub = {txt  =>[undef,"a","Array of the text to be transformed"],
                 typ  =>["l",  "c","type of the document: 'l' for latex, 'h' for html."]                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $txt = $argu->{txt};
    my $typ = $argu->{typ};
    # initialisation
    my @cles = ("bo","bc","io","ic","eo","ec");
    my $res = []; my %tags = %ttex;
    if ($typ eq "h") { %tags = %thtm;}
    #
    foreach my $lig (@$txt) {
        # looping on each line
        foreach my $cle (@cles) {
            $lig =~ s/\Q$ttxt{$cle}\E/$tags{$cle}/g;
        }
        push @$res,$lig;
    }
    # returning
    $res;
}
#############################################
##<<
sub picture1item {
    #
    # title : introduce a table of pictures (or items) into the document
    #
    # aim : replace simple tags in appropriate tags
    #      according to the type. At first, only images
    #      were considered, then item names (and more) were also
    #      introduced. In the following explanations,
    #      'image' must be understood as 'image (or item)'.
    # 
    # output : the array of characters after modification
    #
    # details: Images are always introduced
    #          into a table (1x1 at minimum).
    #          There is no obligation to fill every cell,
    #          even more, empty cells can not be the last
    #          one but calls must be made in the order.
    #          Individual captions are gathered into
    #          a general table caption and a collective
    #          caption is also possible.
    #
    # to do: implement the rotation of images for html outputs
    #        escaping "\" before { in caption to be suppressed
    #
    # arguments
    my $hrsub = {ima  =>[undef,"a","Array of references of hashes describing each image/item.",
                                   "hash keys must be: 'fil' (c) for the file; 'wid' (c) for the width;",
                                   "'hei' (c) for the height;'cap' (a) for the individual captions;",
                                   "'rot' (n) for the rotation to apply in degrees; 'dur' (c) for the",
                                   "duration; 'chk' (n) to indicate if the existence of the file must be performed;",
                                   "'vsp' (n) to indicate the vertical space between the tabular and the caption in mm",
                                   "(default 4). Different vertical spaces can be provided for each image of the",
                                   "tabular but only the one of the first one is used ;",
                                   " 'wha' (c) to indicate what to introduce either the image when '' or undef",
                                   "or a character string indicating which components",
                                   "of this hash to introduce and their order: 'n' for 'fil', 'w' for",
                                   "'wid', 'h' for 'hei', 'd' for 'dur'."],
                 dim  =>[[1,1],"a","Array of size 2 giving the number of lines and the number",
                                   "of columns of the table"],
                 pla  =>[    0,"na","Cells to give to each image in the table. When '0' images",
                                    "are placed in the natural order. If not an array of same",
                                    "length of 'ima' giving references to arrays of size 2",
                                    "giving the line and column placement. Any inconsistency",
                                    "will produce a fatal error"],
                 cca  =>[[],"a","Array of the collective caption; each component is a paragraph"],
                 opt  =>["HIb","c","General options:",
                                      " 'H' to place the table here,",
                                      " 'I' to add the image name in the caption,",
                                      " 'X' not to introduce the designation of the cell '[i,j]' in the caption,",
                                      " 'c' to break lines between paragraphs of the collective captions,",
                                      " 'b' to break lines between collective and individual captions",
                                      "      ('b' is implied by 'c' and 'i'),",
                                      " 'i' to break lines between the individual captions,",
                                      " 'l' to break lines between the paragraphs of the individual captions.",
                                      " 'n' to force the numbering of images by latex when the caption is empty",
                                      " 'B' to place the caption Before the image(s)",
                                    "FOR THE MOMENT BREAKING LINES DOESN'T WORK PROPERLY!!!"
                        ],
                 typ  =>["l",  "c","type of the document: 'l' for latex, 'h' for html."]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $ima = $argu->{ima};
    my $dim = $argu->{dim};
    my $pla = $argu->{pla};
    my $ccb = $argu->{cca}; my $cca = &uie::copy8structure(str=>$ccb);
    my $opt = $argu->{opt};
    my $typ = $argu->{typ};
    # initialisation
    my $espa = "~";
    if ($typ eq "h") { $espa = "&nbsp;";}
    my $res = [];
    # some checking
    my $nbima = scalar(@$ima);
    my $vespa = $lhattmel::vsp7fig7cap;
    if (defined($ima->[0]->{vsp})) {
            $vespa = $ima->[0]->{vsp};
    }
    unless (@$dim == 2) {
        die("In $nsub, argument 'dim' must of size 2");
    }
    my $nblig = $dim->[0]; my $nbcol = $dim->[1];
    my $nbcel = $nblig * $nbcol;
    if ($nbima > $nbcel) {
        die("In $nsub, a table $nblig x $nbcol is not sufficient for $nbima pictures");
    }
    # building the default placement
    unless (ref($pla)) { 
        $pla = [];
        for my $kk (1..$nbima) {
            my $jj = 1 + ($kk-1) % $nbcol;
            my $ii = 1 + (($kk - $jj) / $nbcol);
            push @$pla,[$ii,$jj];
        }
    }
    # checking consistency of $ima and $pla
    unless ( @$pla == $nbima) {
        die("In $nsub, arrays 'ima' and 'pla' must have same size");
    }
    # checking the consistency of placements
    # and existence of image files
    my @bpla = ();
    for (1..($nblig*$nbcol)) { push @bpla,-1;}
    for (my $kk = 0; $kk < $nbima; $kk++) {
        my $ii = $pla->[$kk]->[0]; 
        my $jj = $pla->[$kk]->[1]; 
        if (($ii > $nblig) or ($ii < 1) or
            ($jj > $nbcol) or ($jj < 1)) {
            print "kk = $kk nblig = $nblig nbcol = $nbcol \n";
            &uie::print8structure(str=>$pla->[$kk]);
            die("In $nsub, placement kk is not accepted");
        }
        my $npla = $jj + ($ii-1)*$nbcol;
        unless ($bpla[$npla-1] < 0) {
            print "npla = ",$npla,"\n";
            print "bpla[npla-1] = ",$bpla[$npla-1],"\n";
            print "bpla = ",join(" - ",@bpla),"\n";
            &uie::print8structure(str=>$pla);
            die("In $nsub, cell($ii,$jj) was attributed at least twice");
        } else {
            $bpla[$npla-1] = $kk;
        }
        if (defined($ima->[$kk]->{chk})) { if ($ima->[$kk]->{chk}) {
            # checking image existence
            unless (-e $ima->[$kk]->{fil}) {
                &uie::print8structure(str=>$ima->[$kk]);
                die("In $nsub, file associated to image/item $kk isn't available");
            }
        }}
        # in case of no caption
        unless (defined($ima->[$kk]->{cap})) {
            $ima->[$kk]->{cap} = [];
        }
        # checking correctness of caption
        if (ref($ima->[$kk]->{cap}) ne "ARRAY") {
            &uie::print8structure(str=>$ima->[$kk]);
            print "$nsub: component {cap} of image descriptions must be an array of strings\n";
            print "  TO BE CORRECTED!\n";
            die;
        } 
    }
    # finding the image to introduced in the ordered cells
    my @opla;
    # looking for the order of introducing images
    foreach my $ii (1..$nblig) {
        foreach my $jj (1..$nbcol) {
            my $zz = -1;
            for my $kkk (1..$nbima) {
                if (($ii == $pla->[$kkk-1]->[0]) and ($jj == $pla->[$kkk-1]->[1])) {
                    $zz = $kkk-1;
                }
            }
            push @opla,$zz;
        }
    }
#&uie::la(str=>$cca,mes=>"cca1");
    # determining the file names
    foreach my $kk (1..$nbima) {
        my $file = $ima->[$kk-1]->{fil};
        my @ax = split(/\//,$file);
        $file = $ax[-1];
        $ima->[$kk-1]->{nfi} = $file;
    }
    ## building the caption, especially adding individual captions to the collective caption
    ## and dealing with quite complicated breaking lines
    # taking care of implications
    if ($opt =~ /l/) { $opt = $opt."i";}
    if ($opt =~ /[i,c]/) { $opt = $opt."b";}
    # line breaks for collective caption
    if ($opt =~ /c/) { foreach my $ll (@$cca) { $ll = $ll." ".$brli{$typ};}}
    # line break for between collective and individual captions
    elsif ($opt =~ /b/) { push @$cca,$brli{$typ};}
#&uie::la(str=>$cca,mes=>"cca2");
    # dealing with individual captions
    foreach my $kkk (1..scalar(@opla)) {
        my $kk = $opla[$kkk-1];
        if ($kk >= 0) {
            my $jjj = $pla->[$kk]->[1];
            my $iii = $pla->[$kk]->[0];
            if (($opt =~ /I/) or ($ima->[$kk]->{cap})) {
                my @aju = ();
                unless (($nblig*$nbcol == 1)or($opt=~/X/)) { push @aju,"[$iii,$jjj]$espa: ";}
                #if ($opt =~ /I/) { push @aju,"\\\{$ima->[$kk]->{nfi}\\\} ";}
                if ($opt =~ /I/) { push @aju,"$ima->[$kk]->{nfi} ";}
#&uie::la(str=>\@aju,mes=>"aju pour kk $kk");
                foreach (@{$ima->[$kk]->{cap}}) {
                    push @aju,$_;
                    if ($opt =~ /l/) { push @aju,$brli{$typ};}
                }
                push @$cca,@aju;
            }
            if (($opt !~ /l/) and ($opt =~ /i/)) { push @$cca," $brli{$typ}";}
        }
#&uie::la(str=>$cca,mes=>"cca kkk = $kkk");
    }
    #
    unless ($typ eq "h") {
        ## latex output
        # starting the figure
        my $ax = "\\begin{figure}";
        if ($opt =~ /H/) { $ax = $ax."[H]";}
        push @$res,&indent(cha=>$ax,ind=>1);
        # building the caption 
        my @maleg = ();
        if ($opt =~ /n/) { unless (@$cca) {
            $cca = ["~"];
        }}
        if (@$cca) {
#&uie::la(str=>$cca,mes=>"cca");
            push @maleg,&indent(cha=>"\\caption{",ind=>2),
                        #@{&indent(cha=>$cca,ind=>3)},
                        @{&indent(cha=>&lhattmel::l7e(cha=>$cca),ind=>3)},
                        &indent(cha=>"}",ind=>2);
        }
        # building some vertical space between caption and image
        my @masep= (&indent(cha=>"\\vspace{".$vespa."mm}",ind=>2)); 
        # adding some formatting and labelling
        push @$res,&indent(cha=>"\\label{$ima->[0]->{nfi}}",ind=>2); 
        push @$res,&indent(cha=>"\\noindent \\centering{}",ind=>2); 
        # building the tabular
        my @matab = ();
        # starting the tabular
        $ax = "\\begin{tabular}{|";
        foreach my $ii (1..$nbcol) { $ax = $ax."c\|";}
        $ax = $ax."}"; 
        push @matab,&indent(cha=>$ax,ind=>2);
        push @matab,&indent(cha=>"\\hline",ind=>3);
        # the different cells
        foreach my $ii (1..$nblig) {
            foreach my $jj (1..$nbcol) {
                # looking for the image to introduce
                my $kkk = $jj-1 + ($ii-1)*$nbcol;
                my $kk = $opla[$kkk];;
                if (1+$kk) {
                    # some image/item in the cell
                    # image or item?
                    my $item = 0;
                    if (defined($ima->[$kk]->{wha})) {
                        if ($ima->[$kk]->{wha} ne "") {
                            $item = 1;
                        }
                    }
                    unless ($item) {
                        # image to introduce
                        my $roro = 0;
                        if (defined($ima->[$kk]->{rot})) {
                            $roro = $ima->[$kk]->{rot};
                        }
                        $ax = "\\includegraphics[origin=c,angle=$roro";
                        if (defined($ima->[$kk]->{wid}) or
                            defined($ima->[$kk]->{hei})) {
                            if (defined($ima->[$kk]->{wid})) { $ax = $ax.",width=$ima->[$kk]->{wid}";}
                            if (defined($ima->[$kk]->{hei})) { $ax = $ax.",height=$ima->[$kk]->{hei}";}
                        }
                        $ax = $ax."]";
                        my $fnom = $ima->[$kk]->{fil};
                        my @fnom = split(/\./,$fnom);
                        ##
                        $fnom = &lhattmel::l7e(cha=>$fnom);
                        ##
                        $fnom = "{".join(".",@fnom[0..(scalar(@fnom)-2)])."}.".$fnom[scalar(@fnom)-1];
                        $ax = $ax."{$fnom}";
                    } else {
                        # item description to introduce
                        my $quoi = $ima->[$kk]->{wha};
                        my @quoi = split //,$quoi;
                        $ax = "~";
                        foreach (@quoi) {
                            if ($_ eq "n") { $ax = $ax."(".$ima->[$kk]->{fil}.")";}
                            if ($_ eq "w") {
                                if (defined($ima->[$kk]->{wid})) {
                                    $ax = $ax."; w=".$ima->[$kk]->{wid};
                                } else {
                                    $ax = $ax."; w undef";
                                }
                            }
                            if ($_ eq "h") {
                                if (defined($ima->[$kk]->{hei})) {
                                    $ax = $ax."; h=".$ima->[$kk]->{hei};
                                } else {
                                    $ax = $ax."; h undef";
                                }
                            }
                            if ($_ eq "d") {
                                if (defined($ima->[$kk]->{dur})) {
                                    $ax = $ax."; d=".$ima->[$kk]->{dur};
                                } else {
                                    $ax = $ax."; d undef";
                                }
                            }
                        }
                    }
                    push @matab,&indent(cha=>$ax,ind=>5); 
                } else {
                    # no image/item in this cell
                    push @matab,&indent(cha=>$espa,ind=>4);
                }
                unless ($jj == $nbcol) { push @matab,&indent(cha=>"&",ind=>4);}
            }
            push @matab,&indent(cha=>"\\tabularnewline \\hline",ind=>4);
        }
        # ending the tabular
        push @matab,&indent(cha=>"\\end{tabular}",ind=>2);
        # introducing caption/image
        if ($opt =~ /B/) {
            push @$res,@maleg,@masep;
        }
        push @$res,@matab;        
        unless ($opt =~ /B/) {
            push @$res,@masep,@maleg;
        }
        # ending the figure
        push @$res,&indent(cha=>"\\end{figure}",ind=>1);
    } else {
        ## html output
        # starting the figure
        my $ax = "<TABLE BORDER=\"1\">";
        push @$res,$ax;
        # adding the caption
        if (@$cca) {
            push @$res,&indent(cha=>"<CAPTION>",ind=>2),
                       @{&indent(cha=>$cca,ind=>3)},
                       &indent(cha=>"</CAPTION>",ind=>2);
        }
        foreach my $ii (1..$nblig) {
            push @$res,&indent(cha=>"<TR>",ind=>3);
            foreach my $jj (1..$nbcol) {
                push @$res,&indent(cha=>"<TD>",ind=>4);
                # looking for the image to introduce
                my $kkk = $jj-1 + ($ii-1)*$nbcol;
                my $kk = $opla[$kkk];;
                if (1+$kk) {
                    # some image in the cell
                    #<#<# image rotation is not implemented yet:            #>#>#
                    #<#<# use of javascript function or CSS being necessary #>#>#
                    my $roro = 0;
                    if (defined($ima->[$kk]->{rot})) {
                        $roro = $ima->[$kk]->{rot};
                    }
                    $ax = "<IMG "; #\\includegraphics[origin=c,angle=$roro";
                    if (defined($ima->[$kk]->{wid}) or
                        defined($ima->[$kk]->{hei})) {
                        $ax = $ax." STYLE=\"";
                        if (defined($ima->[$kk]->{wid})) { $ax = $ax. "WIDTH:$ima->[$kk]->{wid};";}
                        if (defined($ima->[$kk]->{hei})) { $ax = $ax."HEIGHT:$ima->[$kk]->{hei};";}
                        $ax = $ax."\" ";
                    }
                    $ax = $ax." SRC=\"$ima->[$kk]->{fil}\" ";
                    $ax = $ax." ALT=\"$ima->[$kk]->{nfi}\" ";
                    $ax = $ax.">";
                    push @$res,&indent(cha=>$ax,ind=>5); 
                } else {
                    # no image in this cell
                    push @$res,&indent(cha=>$espa,ind=>4);
                }
                push @$res,&indent(cha=>"</TD>",ind=>4);
            }
            push @$res,&indent(cha=>"</TR>",ind=>3);
        }
        # ending the table
        $ax = &indent(cha=>"</TABLE>",ind=>1);
        push @$res,$ax;
    }
    # returning
    $res;
}
#############################################
##<<
sub latex2pdf {
    #
    # title : produce a pdf file from a latex file
    #
    # aim : compile a latex file with 'pdflatex -interaction=batchmode'
    # 
    # output : 1 when job was fine, an error if not
    #
    # remarks : - if it exists the pdf file will be replaced
    #             without saving it.
    #           - no able for the moment to detect
    #             errors when running 'pdflatex'
    #
    # arguments
    my $hrsub = {tex =>[undef,"c","File of the latex source"],
                 nbc =>[    3,"n","Number of compilation to perform"],
                 slt =>[    0,"n","Must 'pdflatex' run silently?"]
                };
##>>
    my $nsub = (caller(0))[3];
    my $argu   = &uie::argu($nsub,$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $tex = $argu->{tex};
    my $nbc = $argu->{nbc}; 
    $nbc = int($nbc+0.5); $nbc = min(3,$nbc); $nbc = max(3,$nbc);
    my $slt = $argu->{slt};
    #
    my $command = "pdflatex -interaction=batchmode $tex";
    if ($slt) { $command = $command." > /dev/null";}
    if ($nbc > 0) { foreach (1..$nbc) {
        my $cpl = system($command);
        if ($cpl) {
            print "cpl = $cpl \n";
            my $rrr = &uie::add8err(err=>"no",nsu=>$nsub,
                                    erm=>["Latex compilation failed!",
                                         "Latex source can be investigated in $tex"]);
            return $rrr;
        }
    }}    
    # returning
    my $res = 1;
    $res;
}
#############################################
#############################################
#############################################
1;

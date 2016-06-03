#!/usr/bin/perl -w
#
# 16_03_26 16_03_29 16_03_30 16_05_05 16_05_26
# 16_05_30 16_05_31 16_06_01 16_06_02
#
use lib "/home/jbdenis/liana/info/perl/uie";
use strict;
use Getopt::Std;
use File::Basename;
use uie;

##########################################
# subroutines to extend and place into
# a new module afterwards
#############################################
#
##<<
sub blancs{
    #
    # title : introducing spaces
    #
    # aim : replaces multiples spaces with '&nbsp;' and one space
    #       in the proposed character string(s).
    #
    # output: the transformed string or array
    #
    # arguments
    my $hrsub = {stri =>[undef,"ca","The string or the reference to an array of strings"]
                };
##>>
    my $argu   = &uie::argu("blancs",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $stri = $argu->{stri};
    my $cas = "c";
    if (ref($cas) ne "ARRAY") {
        $stri = [$stri];
    }
    # transforming
    foreach my $cha (@$stri) {
        die "à finir...";
    }
    # returning
    "to be done";
}
#
#############################################
#
##<<
sub starting{
    #
    # title : starting a html file
    #
    # aim : construct the heading of an html page
    #       until the <body> tag.
    #
    # output: an array, an element a line
    #
    # arguments
    my $hrsub = {titl =>["-","c","title to introduce"],
                 auth =>["-","cu","author when undef none"],
                 enco =>["utf8","c","encoding class"],
                 type =>["h","c","either 't' for text or 'h' for html"]
                };
##>>
    my $argu   = &uie::argu("starting",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $titl = $argu->{titl};
    my $auth = $argu->{auth};
    my $enco = $argu->{enco};
    my $type = $argu->{type};
    my @res = (); my $num = 0;
    if ($type eq "t") {
        $res[$num++] = (" "x12).("-"x10);
        $res[$num++] = (" "x12).$titl;
        if (defined($auth)) {
            $res[$num++] = (" "x14)."($auth)";
        }
        $res[$num++] = (" "x12).("-"x10);
    } else {
	$res[$num++] = "<html>";
        $res[$num++] = "<head>";
        $res[$num++] = "  <meta http-equiv=\"content-type\" content=\"text/html; charset=".$enco."\">";
        if (defined($auth)) {
            $res[$num++] = "  <meta name=\"authors\" content=\"".$auth."\">";
        }
        $res[$num++] = "  <meta name=\"creation\" content=\" ".&uie::now." \">";
        $res[$num++] = "  <meta http-equiv=\"charset\" content=\"".$enco."\">";
        $res[$num++] = "  <title>".$titl."</title>";
        $res[$num++] = "</head>";
        $res[$num++] = "<body>";
    }
    # returning
    @res;
}
#
##########################################
#
##<<
sub closing{
    #
    # title : closing a html file
    #
    # aim : finishing an html page
    #       from the </body> tag included.
    #
    # output: an array, an element a line
    #
    # arguments
    my $hrsub = {
                 type =>["h","c","either 't' for text or 'h' for html"]
                };
##>>
    my $argu   = &uie::argu("closing",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $type = $argu->{type};
    #
    my @res = (); my $num = 0;
    if ($type eq "t") {
        $res[$num++] = (" "x12).("-"x10);
        $res[$num++] = (" "x12)."The End";
        $res[$num++] = (" "x12).("-"x10);
    } else {
        $res[$num++] = "</body>";
	$res[$num++] = "</html>";
    }
    # returning
    @res;
}
#
##########################################
#
##<<
sub block{
    #
    # title : include a new block
    #
    # aim : construct the heading of an html page
    #       until the </body> tag.
    #
    # output: an array, an element a line
    #
    # arguments
    my $hrsub = {titl =>[undef,"c","title to use"],
                 atit =>["","c","anchor name to give to the title; '' means no anchor"],
                 bloc =>[undef,"a","the block to include, a component a line"],
                 type =>["h","c","either 't' for text or 'h' for html"]
                };
##>>
    my $argu   = &uie::argu("block",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $titl = $argu->{titl};
    my $atit = $argu->{atit};
    my $bloc = $argu->{bloc};
    my $type = $argu->{type};
    my @res = (); my $num = 0;
    if ($type eq "t") {
        # the title
        $res[$num++] = " ";
        $res[$num++] = " ";
        $res[$num++] = (" "x12).("."x10);
        $res[$num++] = (" "x12).$titl;
        $res[$num++] = (" "x12).("."x10);
        $res[$num++] = " ";
        # the block itself
        foreach (@$bloc) {
            $res[$num++] = @$_[0];
        }
    } else {
        # the title
	$res[$num++] = "<h2>";
        if (length($atit)>0) {
            $res[$num++] = "<a name=\"".$atit."\"></a>";
        }
        $res[$num++] = $titl;
	$res[$num++] = "</h2>";
        # the block itself
        $res[$num++] = "<p><pre>";
        foreach (@$bloc) {
            $res[$num++] = @$_[0];
        }
        $res[$num++] = "</pre></p>";
    }
    # returning
    @res;
}
#
##########################################
##########################################
#
##<<
sub liste{
    #
    # title : include a list
    #
    # aim : construct a list of item, numbered or not.
    #
    # output: an array, an element a line
    #
    # arguments
    my $hrsub = {befo =>[[],"a","A paragraph to introduce before, a component a line"],
                 list =>[undef,"a","the list to include, a component an item"],
                 rlis =>[[],"a","references for each component of the list"],
                 afte =>[[],"a","A paragraph to introduce after, a component a line"],
                 tlis =>["u","c","Type of the list: 'u' for unordered and 'o' for ordered"],
                 type =>["h","c","either 't' for text or 'h' for html"]
                };
##>>
    my $argu   = &uie::argu("block",$hrsub,@_);
    if ($argu == 1) { return 1;}
    my $befo = $argu->{befo};
    my $list = $argu->{list};
    my $rlis = $argu->{rlis};
    my $afte = $argu->{afte};
    my $tlis = $argu->{tlis};
    my $type = $argu->{type};
    my @res = (); my $num = 0;
    if ($type eq "t") {
        # before
        if ((scalar @$befo) > 0) {
            foreach (@$befo) {
                $res[$num++] = $_;
            }
        }
        # the list
        my $numero = 0;
        foreach (@$list) {
            $numero++;
            my $item = $_;
            if ($tlis =~ /o/) { $item = "$numero  ".$item;}
            $item = (" "x5).$item;
            $res[$num++] = $item;
        }
        # after
        if ((scalar @$afte) > 0) {
            foreach (@$afte) {
                $res[$num++] = $_;
            }
        }
    } else {
        # before
        if ((scalar @$befo) > 0) {
            $res[$num++] = "<p>";
            foreach (@$befo) {
                $res[$num++] = $_;
            }
            $res[$num++] = "</p>";
        }
        # the list
        my $ltag = "ul";
        if ($tlis =~ /o/) { $ltag = "ol";}
        $res[$num++] = "<$ltag>";
        for (my $ni=0; $ni < scalar(@$list); $ni++)  {
            $res[$num++] = "<li>";
            if (scalar(@$rlis)>0) {
                $res[$num++] = "<a href=\"".$rlis->[$ni]."\">";
            }
            $res[$num++] = $list->[$ni];
            if (scalar(@$rlis)>0) {
                $res[$num++] = "</a>";
            }
            $res[$num++] = "</li>";
        }
        $res[$num++] = "</$ltag>";
        # after
        if ((scalar @$afte) > 0) {
            $res[$num++] = "<p>";
            foreach (@$afte) {
                $res[$num++] = $_;
            }
            $res[$num++] = "</p>";
        }
    }
    # returning
    @res;
}
#
##########################################


# signature
my $pro = "mado";
my $defi = "    # title :";
# tags
my $gotag = "###<<<"; my $gctag = "###>>>";
my $otag  =   "##<<"; my $ctag  =   "##>>";
my($minu, $heure, $jour, $mois, $an)=(localtime)[1,2,3,4,5];
my $maintenant = "$heure:$minu le $jour/".($mois+1)."/".($an+1900);
#
# inline help if no arguments
if ((scalar @ARGV) == 0) { 
  print "<<< $pro >>>

     generates a raw html (or txt) page presenting the module,
     when conveniently marked to extract the documentation
     information scanning a module file.

     The sorted names of the subroutines (with their definition
     if any) is proposed.

     Then a general overview of the module is displayed
     tagged in between $gotag and $gctag.

     Also, all lines comprised in between
     beginning ($otag) and closing ($ctag) tags, identifying
     the name of subroutine which is supposed to be in them
     following the keyword 'sub' in first position in its line,
     and any desired explanation, including the definition 
     in one line starting with '$defi'...

     These lines are simply outputted after an alphabetical 
     sorting of the subroutines.

     Finally the series of testing scripts named after the 
     module name ('mod') as 'mod_*.pl' are listed with links
     over them.

     For html output some useful links are introduced.

     One (or two) argument(s) is(are) asked for:
  
     '-f mod' the module (named 'mod') to scrutinize supposed to be
          in file 'mod.pm' of the working directory.

     '-o t' to get a text output, default html.

     Output is directed to STDOUT

     Module 'uie.pm' can serve as a good example.

     Exemples:
          $pro -f uie > uie.docu.html
          $pro | less
\n\n";
} else {
  # getting the options
  getopt('fo'); 
  # getting the file to read
  my ($file,$raci);
  if (defined our $opt_f) {
      $raci = "$opt_f";
      $file = $raci.".pm";
  } else {
      die("argument '-f' is compulsory");
  }
  # getting the output type
  my $outp = "h";
  if (defined our $opt_o) {
      if ($opt_o eq "t") { $outp = "t";}
  }
  # checking the accessibiliy of the proposed file
  if (!(-e $file)) {
      die("'$file' seems not an existing file!");
  }
  if (!(-r $file)) {
      die("'$file' seems not a readable file!");
  }
  if (!(-T $file)) {
      die("'$file' seems not a text file!");
  }
  #
  # starting
  my @ente = &starting(titl=>$file,type=>$outp,auth=>undef);
  foreach (@ente) { print $_,"\n";}
  # extracting the global presentation
  my $pres = &uie::read8block(com=>undef,sep=>undef,fil=>$file,
                              bbl=>"###<<<",ebl=>"###>>>");
  my @gpre = &block(bloc=>$pres,titl=>"General Presentation of $file",type=>$outp);
  foreach (@gpre) { print $_,"\n";}
  # extracting the documentation for each subroutine
  my $docu = &uie::read8block(com=>undef,sep=>undef,fil=>$file);
  # ordering the different subroutines by means of a hash
  my %subr = (); my $subr = undef; my %titles = ();
  foreach my $ligne (@$docu) {
      my $lig = join(" <+> ",@$ligne);
      if ($lig =~ /^sub /) {
          $subr = $lig;
          $subr{$subr} = [];
      } else {
          if (defined($subr)) {
              push @{$subr{$subr}},[$lig];
              foreach my $titi (@$ligne) {
                  if ($titi =~ /^$defi/) {
                      my $tutu = substr($titi,length($defi)+1);
                      $titles{$subr} = $tutu;
                  }
	      }
	  }
      }
  }
  # displaying the list of subroutines
  my $before = ["&nbsp;","&nbsp;","A total of ".scalar(keys(%subr))." subroutines was detected:","&nbsp;"];
  my $lissub = []; my $refsub = [];
  foreach my $ss (sort keys %subr) {
      my $elem = &uie::juste(chain=>$ss,long=>30,just=>"l");
      if (defined($titles{$ss})) {
          $elem = $elem."(".$titles{$ss}.")";
      }
      push @$lissub,$elem;
      push @$refsub,"#".$ss;
  }
  my @lili = &liste(befo=>$before,list=>$lissub,
                    rlis=>$refsub,
                    tlis=>"o",type=>$outp);
  foreach (@lili) { print $_,"\n";}
  # displaying the subroutine documentations
  my $nb = 0;
  foreach my $ss (sort keys %subr) {
      $nb++;
#      print "\n","="x50,"\n";
#      print &uie::juste(chain=>$nb,long=>3,just=>"r"),
#            "\t",$ss,"\n";
#      print "="x50,"\n";&&
#      foreach my $ll (@{$subr{$ss}}) {
#          print $ll,"\n";
#      }
      my @susu = &block(bloc=>$subr{$ss},atit=>$ss,
                        titl=>$nb." ".$ss,type=>$outp);
      foreach (@susu) { print $_,"\n";}
  }
  # looking for the test scripts of the subroutines
  my @tests = sort glob($raci."_*.pl");
  my $ttes = "A total of ".scalar(@tests)." test scripts was detected:";
  my @ttes = &block(titl=>$ttes,bloc=>[],type=>$outp);
  foreach (@ttes) { print $_,"\n";}
  my @tete = &liste(list=>\@tests,tlis=>"o",
                    rlis=>\@tests,type=>$outp);
  foreach (@tete) { print $_,"\n";}
  my @fini = &closing(type=>$outp);
  foreach (@fini) { print $_,"\n";}
}
#
# fin du code
#


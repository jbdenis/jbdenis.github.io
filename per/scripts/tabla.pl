#!/usr/bin/perl
#!/usr/local/bin/perl
#
# tabla (for TABLeau Ascii)
#
# 2015_05_29 2015_05_30 2015_05_31 2015_06_01 2015_06_02
# 2015_06_03 2015_06_05 2015_06_08 2015_06_10 2015_06_11
# 2015_06_12 2015_06_18 2015_06_19 2015_06_22 2015_06_07
# 2015_06_29 2015_06_30 2015_07_03 2015_07_04 2015_07_31
#
# <<<IDEAS TO IMPROVE THE CODE>>>
#
# <Simplify The Algorithm>
#   (1) A step to extract the table to print
#       (this can comprise the creation of new columns)
#   (2) A step to specify the format of columns and rows
#       (independent of the output type but to the extracted
#        table in step one)
#   (3) A step to produce the output 
#
# <More Suggestions>
#   (*) Give the extracted table a 2 dimension structure
#   (*) Possible repetitions of the first row not included
#       in the extracted table
#   (*) Looping once, a subroutine dealing with the 
#       different output types inside the two loops.
#
# <About Parameter Dealing>
#   (not very good because global variables are used!)
#   (*) They are successively stored into the hash %argu
#   (*) But it exists an array @argu used to get those in
#       the parameter file.
#   (*) And also an array @ARGU to handle the inline ones
#
use File::Copy;
use strict; 
#
# some constants
#
my $printhelp = 0;
my $nom = "tabla"; my $lala;
my $ver = "0.85 (2015-06-30)";
my $sig = $nom." ".$ver;
my $avant = "<"x10; my $apres = ">"x10;
my $bandeau = $avant." ".$sig." ".$apres;
my ($jou,$moi,$ann) = (localtime)[3,4,5];
$moi++; $ann = $ann + 1900;
if ($moi < 10) { $moi = "0$moi";}
if ($jou < 10) { $jou = "0$jou";}
my $dat = $ann."-".$moi."-".$jou;
my $log = "parameter.log";
my %argu = (); my @argu; my @lar = (); my $la; my $lla;
my $lnu; my $hl; my $nbc;
my $jbd; my $jd; my $sd; my $yd; my $hd; my $hdd;
my $larg; my $nbcl; my $element; my $numlig; my $numcol;
my $fentree; my $fsortie; my $nbae; my $nbaef;
my $k; my $v; my $defdef; my %defdef; my @defdef;
my %or; my $nbr; my $para;
my @ARGU;
my @titre = ();   my @titrefile = ();
my @legende = (); my @legendefile = ();

#############################################
#
# beginning mini help pages
#

my %aide = ();
$aide{A} = "Introduction

 $sig produces a formatted table from a 
simple ascii file similar to those produced by commom softwares when
exporting in \"txt\" mode. The main rule is one file record for each
table line; cell values {column/field} being determined with the
help of a unique separator.

The possible output formats are: 
 ascii:      \"txt\",
 html:       \"html\",
 latex:      \"tex\",
 input file: \"tt\".

The last format allow the user to link together different runs of $nom,
as an example to make selections using several fields.

Four styles of output are proposed (except for the 'input file' format).
 0: \"table\",
 1: \"bullet list\", 
 2: \"definition list\", 
 3: \"label structure\".

The name of the output file can be imposed or deduced from the input 
file name. Various parameters (or instructions inserted into the proper
input file) allow some useful possibilities.
";

$aide{B} = "Structure of the input file

    (*) Records of the input file starting with \"#\" (or whatever you
    prefer according to parameter \"incom\") are not considered by
    tabla.

    (*) Those starting with \":T:\" give the title of the table; they
    are concatanated.

    (*) Those starting with \":C:\" are those giving its caption; a
    line, a paragraph.

    (*) Records of the input file starting with \":F:\" are
    instructions for varying the format of the lines in the output
    (not yet implemented).

    (*) Space characters next to separators can be excluded from the
    field (argument = \"inbla\"nk; default=yes).

    (*) Empty fields are obtained by two successive separators.

    (*) The number of columns of the resulting table is the maximum
    number of fields of input records. When a record does not have
    this number of fields, the last fields are considered as empty.
    ";

$aide{C} = "Parameters (1): a first touch

 Most options are indicated through parameters : all of them have
default values which can be changed either by inline arguments or file
parameters (and further with \":F:\" lines of the input table).

 If a parameter is defined several times, the last definition is
retained following the (default, parameter file, inline, input file)
order (title and caption definitions are not considered as parameters).

 All parameters are designated with five characters. The first two
ones are *in* for input file; *ou* for output file; *pa* for
parameter; *ro* for row of the table; *co* for column of the
table. The last three characters are more or less indicative of their
roles.  ";

$aide{D} = "Parameters (2): inline parameters (including HELP)

 Two uses of $nom must be distinguished (i) asking help
          and (ii) transforming a table.

 (i) asking help
     \"tabla\" provides the list of the chapters and the way to get details
     \"tabla -h G\" provides details about chapter \"G\" and so on
     \"tabla -h all\" provides all chapters (for instance for printing)
     \"tabla -h par\" provides the list of all parameters
     \"tabla -h par pa\" provides the list of all parameters starting with 'pa'
     \"tabla -h par pafil\" provides details on parameter \"pafil\"
     \"tabla -h par all\" provides details on all parameters
     
 (ii) transforming a table
     \"tabla <parameters> <input file>\"

     <parameters> is a collection of even numbered arguments like
     '-inpar %f% -incom \"this line is a comment\" -rosor 3'
     that is pairs are on model \"-type value\", hyphen is compulsory
     although redundant with the position of the argument.

     <input file> is just the [path]name of the input file
     (only one for the moment)
";

$aide{E} = "Parameters (3): through a parameter file

 parameters defined inside the parameter file follow the same syntax
 that inline parameters except that <EoL> (or \"\\n\") are equivalent
 to blank characters and lines beginning with a \"#\" are not taken
 into account. Also, included title and caption must be on lines
 starting with standard tags \":T:\" and \":C:\".

 notice that \"#\" cannot be replaced by another value contrary to
 the input file; the same for tags \":T:\" and \":C:\".

 be careful, an empty line is necessary at the end of this file
             if not a bad number of arguments will be detected.

 remark: log files produced by $nom are valid parameter files.

 The parameter file also allows the use of different title and
 caption that those indicated in the input file using the same
 syntax with lines starting with \":T:\" and \":C:\".
";

$aide{F} = "Parameters (4): formating the columns

 NOT YET IMPLEMENTED

 A subset of columns can be given an identical format precising if it
must italicized 'i', bolded 'b'; if the aligment must be left 'l',
right 'r' or centered 'c'; if the words must be uppered 'U', lowered
'L', capitalisized 'C'; the range of accepted number of characters; if
the font must be small 's', normal 'n' or big 'b'. Definition
with some examples:

i<r>/U\\[3:5]{n}(1,2) means that columns one and two must be
italicised, uppered, right aligned, have 3,4 or 5 characters and be of
size normal.

{b}(4)/C\\ means that column 4 must be bolded and capitalized.

(*){c} means that all columns must be centered.

Default values are: no bolding, no italicising, left aligment, no
modification, normal size.  ";

$aide{G} = "Parameters (5): within the input file

 NOT YET IMPLEMENTED...

 A line starting with \":F:param (4)\" within the input file modifies
the current value of parameter \"param\" for the next 4 rows of the
table. When the number within the parentheses (here 4) is replaced
with \"*\", then the modification applies to all the remaining rows.

 To be precised at the moment of the implementation... Not all the
parameters can be modified this way but it is planned that new
parameters will be introduced.
";

$aide{H} = "Some Examples

 (1) [perl ]tabla data.txt
     transforms the data.txt file with all defaults 
     except those given in itself

 (2) [perl ]tabla -h par
     displays the types and possible values for \"inline parameters\"

 (3) [perl ]tabla -h par rosor
     displays the comment associated to \"rosor\" parameter

 (4) [perl ]tabla -insep ; -rosor 1N -o html blup
     transforms the blup table 
         - according to separator \";\" 
         - sorting the rows according to column 1
         - producing an html file named \"blup.html\"

 More extensive examples using tabla can be found in shell scripts
named tabla.ex#1-#2 using tabla.da#1 as input files; all files
generated when using them start with 'ex#1'. At last, the script
'tabla.exe' launches all these scripts. This way all necessary files
are 'tabla*' and all files denominated 'ex*' can be deleted without
any consequence.  ";

$aide{I} = "Log file

 When transforming a table, tabla produces a log file in which are put
all details concerning what it is doing (see an example).

 This file is written such that it is a valid future \"parameter
 file\".

 The default name is \"$log\" but can be changed with parameter
'palog'. Nevertheless a \"$log\" file is firstly created and then the
name is changed to yours. So if such a file preexists, it will be
destroyed (protection seems of no value).

 ";

$aide{J} = "Further planned improvements

 (*) increase the example sets demostrating more possibilities

 (*) think about a proper use of column labels in case of
     preparing input subtables. 

 (*) finish the \"t3\" output with the automatic numbering

 (*) implement \"parameter (4)\" section
 
 (*) implement \"parameter (5)\" section
 
 (*) allow the possibility of gathering some columns together
     [e.g. to form \"Mr. John Gower\" in a single cell] 

";

$aide{K} = "Error to be corrected

 (*) 'inbla' seems not to work

 ";

$aide{L} = "More details

 (*) All spaces around the separators are eliminated except if
     you use the \"inbla\" parameter

 (*) The specific \"tt\" output format:
     This quite specific output was created to allow successive
     transformations of the input file before obtaining the desired
     formated output. For instance you want to perform simultaneously
     a selection of the rows from two differents columns...
     Remarks:
     (+) comments are definitively lost
     (+) operational title and captions are introduced if they exist
     (+) \"ousep\" string is used as separator so if you want to 
         use \"insep\" you need to force it by yourself

 (*) To obtain a definition of the list not in first column you can
     use the \"cosor\" parameter

 ";

$aide{M} = "Conclusion

Any suggestion, reaction, comment are welcome, thanks to send them to
\"jjbdenis\@gmail.com\".
";

#
# ending mini help pages
#
#############################################

#############################################
#
# beginning parameter definitions
#
### when the possible values of a parameter are restricted then
###      the hash whose name is the parameter name gives 
###         - by its keys the list of possible values
###         - by its values the explanation of the values
###         - by the value of compulsory key "default" the default value
###
### when the possible values of a parameter are free: such a hash
###      have no more than the default component
###
### %parameters gives the list of possible parameters
###
### no further comments because all is included in the code

my %parameters = ();

$parameters{pafil} = "name of the parameter file; 0 means there is no";
my %pafil = ();
$pafil{default} = 0; 

$parameters{inbla} = "must spaces around separators be eliminated?";
my %inbla = ();
$inbla{default} = "y";
$inbla{y} = "spaces around separators must     be eliminated";
$inbla{n} = "spaces around separators must not be eliminated";

$parameters{outyp} = "type of the output file to produce";
my %outyp = ();
$outyp{default} = "h0";
$outyp{h0} = "html output file with table";
$outyp{l0} = "latex output file with table";
$outyp{t0} = "text output file with table";
$outyp{h1} = "html output file with bullet list";
$outyp{l1} = "latex output file with bullet list";
$outyp{t1} = "text output file with bullet list";
$outyp{h2} = "html output file with definition list";
$outyp{l2} = "latex output file with definition list";
$outyp{t2} = "text output file with definition list";
$outyp{h3} = "html output file with label structure";
$outyp{l3} = "latex output file with label structure";
$outyp{t3} = "text output file with label structure";
$outyp{if} = "text following input structure [see chapter L]";

$parameters{oufil} = "name of the output file; 0 means constructed 
         from the input file with standard suffix";
my %oufil = ();
$oufil{default} = 0;

$parameters{rosel} = "indicates which rows must be selected.
     Three ways are possible.

 (1) Provide a series of numbers separated by \"/\" like \"/3/1/4/\".
Note that (i) the numbering is this of the input file, i.e. including
\"no data lines\" as comments or title lines; (ii) whatever is the
order of the numbers, the original order is preserved so \"/3/1/4/\"
is identical to \"/1/3/4/\" or \"/3/1/4/3/\".

 (2) A numerical or string comparison indicated with 'col|op|val'.
   \"2|<=|45\" means that only rows such that the second column be numerically
               less or equal to 45.
   \"3|ne|stop\" means that only rows with a third column different of 'stop'.

 (3) A regular *Perl* expression preceded by the number of the column.
   \"5/but/\" only rows with the fifth column containing \"but\".
   \"3/^T/\" only rows with a third column starting with \"T\".
Note.1 Row selecting columns need not to be selected
Note.2 some special characters can cause trouble (\"@\" and \"$\" were
       corected but other may be troubleful) see subroutine selecrow.

\"0\" or non consistent syntax implies no selection.
";
my %rosel = ();
$rosel{default} = 0;

$parameters{rosor} = "sorting or ordering-selecting the rows :

      - 0 means all rows are displayed in the input file order
      - a positive number followed by \"A\", \"a\", \"N\" or \"n\"
        indicates the column number from which a sorting must be
        performed : \"A\" : increasing alphabetical sorting; \"a\" :
        decreasing alphabetical sorting; \"N\" : increasing numerical
        sorting; \"n\" : decreasing numerical sorting. For instance
        \"6N\" implies sorting in increasing numerical order according
        to column number 6.
      - a series of numbers separated by \"/\" indicates the order 
          to adopt with possible repetitions and missings. Syntax
          is \"/3/1/4/3/\"

Note(1): this is done AFTER that \"rosel\" parameter operation has been
performed, so the numbering of rows may be not this of the input file.
Note(2): in case, you don't want the labelling row to be sorted, you must
use the *rorep* argument, possibly with a big value to escape a non desired
repetition.
";
my %rosor = ();
$rosor{default} = 0;

$parameters{rorep} = "repeating the first row

      - 0 means no repeating
      - \"n\" means repeating the first row every n rows, that is
            inserting in between \"n\" and \"n+1\", and \"2*n\" and \"2*n+1\"
            and so on until reaching the end of the file.

Note: this is done AFTER that \"rosel\" and \"rosor\" has been
performed, so the numbering of rows may be not this of the input file.
";
my %rorep = ();
$rorep{default} = 0;

$parameters{ronbr} = "numbering the rows
      - 0 means no numbering
      - \"n\#\" means numbering in an additional \"\#\"th column/field
                (including the -no data lines-)
      - \"N\#\" means numbering in an additional \"\#\"th column/field
                (excluding the -no data lines-)
";
my %ronbr = ();
$ronbr{default} = 0;

$parameters{robol} = "number of the row/record to be bolded; \"0\" means no bolding
       the numbering is applied BEFORE any sorting but AFTER
       removing 'no-date-line'";
my %robol = ();
$robol{default} = 1;

$parameters{roita} = "number of the row to be italicized; \"0\" means no one
       the numbering is applied before any sorting";
my %roita = ();
$roita{default} = 0;

##############
$parameters{cobol} = "number of the column/field to be bolded; \"0\" means no bolding
       the numbering is applied before any sorting";
my %cobol = ();
$cobol{default} = 0;

$parameters{coita} = "number of the column/field to be italicized; \"0\" means no one
       the numbering is applied before any sorting";
my %coita = ();
$coita{default} = 0;

$parameters{coupc} = "number of the column/field to be upper cased; \"0\" means no upper casing
       the numbering is applied before any sorting";
my %coupc = ();
$coupc{default} = 0;

$parameters{coali} = "type of alignment within columns or within labels";
my %coali = ();
$coali{default} = "c";
$coali{c} = "centered columns";
$coali{l} = "left aligned columns";
$coali{r} = "right aligned columns";

$parameters{comiw} = "minimum width in characters of columns/fields (only for table/label output)";
my %comiw = ();
$comiw{default} = 1;

$parameters{comaw} = "maximum width in characters of columns/fields (only for table/label output)";
my %comaw = ();
$comaw{default} = 20;
##############

$parameters{cofor} = "defines the format to give to the columns (to be done)
  (see chapter 'parameter (4)' for details)";
my %cofor = ();
$cofor{default} = "<c>[C]{n}(*)";

$parameters{cosor} = "sorting and ordering the columns :

 similar to \"rosor\" for the rows. Notice that
 a selection of columns can be made with the third way.
";
my %cosor = ();
$cosor{default} = 0;

$parameters{colab} = "(only for label structure)
          the absolute value gives the number of characters of labels;
          records are proposed by rows.";
my %colab = ();
$colab{default} = 3;

$parameters{roupc} = "number of the row/record to be upper cased; \"0\" means no upper casing
       the numbering is applied before any sorting";
my %roupc = ();
$roupc{default} = 0;

$parameters{incom} = "comment line: character(s) placed at the very beginning of a line in the input file to indicate that it is must be neglected (for instance a commentary)";
my %incom = ();
$incom{default} = "#";

$parameters{inpar} = "character(s) placed at the very beginning of a line in the input file to indicate that a parameter line is starting (for instance to put bold characters to the next line)";
my %inpar = ();
$inpar{default} = ":F:";

$parameters{insep} = "separator, a character or a character string (without blanks) placed between the cell values of the input table";
my %insep = ();
$insep{default} = ";;";

$parameters{palog} = "final name of the log file (a valid path can be included)";
my %palog = ();
$palog{default} = "parameter.log";

$parameters{oumis} = "character string to replace a non filled value (last cells) of a row";
my %oumis = ();
$oumis{default} = "-";

$parameters{intit} = "Starting sequence indicating the title of the table.";
my %intit = ();
$intit{default} = ":T:";

$parameters{incap} = "Starting sequence indicating the caption of the table.";
my %incap = ();
$incap{default} = ":C:";

$parameters{ousep} = "delimiter to use between elements for lists
         this parameter is overloaded in case of latex tables";
my %ousep = ();
$ousep{default} = " / ";

$parameters{oujup} = "number of labels before a small jump
         (only for \"t3\" output; see parameter \"outyp\")";
my %oujup = ();
$oujup{default} = 5;

#
# ending parameter definitions
#
#############################################

#############################################
#
# beginning of subroutines 
#

### displaying the table of help contents
sub tableaide {
    print $bandeau,"\n";
    print "\n   Table of Contents\n\n";
    foreach (sort keys %aide) {
        print $_,": ";
        print substr($aide{$_},0,index($aide{$_},"\n")),"\n";
    }
    print "\n   just type \"tabla -h all\"       to get the complete help...";
    print "\n          or \"tabla -h X\"         to only get chapter X";
    print "\n          or \"tabla -h par\"       to get the list of parameters";
    print "\n          or \"tabla -h par pp\"    to get details about parameters pp???";
    print "\n          or \"tabla -h par ppqqq\" to get details about parameter ppqqq\n";
}

### decoding possible help among arguments
sub aidons {
    # displaying help
    my ($i,$quelh,$chapitre,$res);
    $res = -1;
    if ($#ARGU < 0) {
        # no arguments => the table of contents
	&tableaide;
        $res = 1;
    }
    else {
	$quelh = -1;
        for ($i = 0; $i <= $#ARGU; $i++) {
            if (($ARGU[$i] eq "-h") || ($ARGU[$i] eq "-H")) {
	        $quelh = $i;
	    }
        }
        if ($quelh > -1) {
	    $res = 1;
	    $chapitre = $ARGU[$quelh+1];
	    if (exists($aide{$chapitre})) {
                print $bandeau,"\n";
                print $chapitre,":     ",$aide{$chapitre},"\n";
	    }
	    elsif ($chapitre eq "all") {
                print "\n   Manual of $sig\n\n";
                foreach (sort keys %aide) {
		    print "\n",$bandeau;
                    print $_,":\n       ";
                    print $aide{$_},"\n";
		}
	    }
	    elsif ($chapitre eq "par") {
		print $bandeau;
		$para = $ARGU[$quelh+2];
		if (exists($parameters{$para})) { &printpara($para); }
		elsif ($para eq "all") {
		    foreach my $paraa (sort keys %parameters) { print "-"x25; &printpara($paraa); }
		}
                elsif (($para eq "co") or 
                       ($para eq "in") or
                       ($para eq "ou") or
                       ($para eq "pa") or
                       ($para eq "ro") 
                      ) {
		    print "\n\n \"inline\" parameters starting with '$para'\n\n";
		    $~ = "parameters";
                    foreach (sort keys %parameters) {
			if ($para eq substr($_,0,2)) {
                            write;
			}
                    }
                }
		else {
		    print "\n List of all \"inline\" parameters\n\n";
		    $~ = "parameters";
		    foreach (sort keys %parameters) { write; }
		    print "\n\n For more details on parameter toto, run \"tabla -h par toto\"\n\n";
		}
	    }
	    else {
                # bad request => the table of contents
		&tableaide;
	    }
	}
    }
    $res;
}

### printing information about parameter $para
sub printpara {
    my $para = $_[0];
    print "\nabout parameter <<",$para,">>:\n\n";
    print "role is: ",$parameters{$para},"\n\n";
    my $aaa = "\$defdef = \$".$para."{default};";
    eval($aaa);
    print "default value is: \"",$defdef,"\"\n\n";
    $aaa = "%defdef = %".$para.";";
    eval($aaa); delete($defdef{default}); @defdef = keys(%defdef);
    if ($#defdef < 0) {
	print "no check for the values of this parameter !\n\n";
    }
    else {
        print "possible values are: \n\n";
        $~ = "parameterdetails";
        foreach(sort keys %defdef) { write; }
	print "\n";
    }
}

### writing a message in $log before dying
sub didi {
    print LOG "#FATAL#ERROR# ",$_[0],"\n";
    die(("<*ERREUR*FATALE*>"x5)."\n".$_[0]."\n   $sig is very sorry!");
}

### writing a message in $log and a warning to the monitor
sub wawa {
    print LOG "###warning: ",$_[0],"\n";
    print $_[0],"\n";
}

### reading the parameters from a file
sub fileparameters {
    open(ARGU,"".$_[0]) || didi ("(?) can't access to parameter file \"".$_[0],"\"");
    while(<ARGU>) { 
        chop; 
        unless ((/^\#/) or (/^:T:/) or (/^:C:/)) {
              while ($_ =~ /^ /) {$_ = substr($_,1);}
              @argu = (@argu,split(/ +/,$_));
	      }
    }
    close(ARGU);
}

### reading title and caption from the parameter file
sub filetitcap {
    open(ARGU,"".$_[0]) || didi ("(?2) can't access to parameter file \"".$_[0],"\"");
    while(<ARGU>) { 
        chop; 
        if (/^:T:/) { 
            push @titrefile,substr($_,length(":T:"));
	}
	if (/^:C:/) {
	    push @legendefile,substr($_,length(":C:"));
	}
    }
    close(ARGU);
}

### some checking and transforming the inline arguments into parameters
sub arguparameters {
    $nbae = int((scalar(@ARGU)-1) / 2); 
    if (scalar(@ARGU) != 2 * $nbae +1) {didi("$sig(2): ".scalar(@ARGU)." is a bad number of arguments (must be even plus file name)!")}
    for (my $na = 0; $na < $nbae; $na++) {
        if (substr($ARGU[2*$na],0,1) ne "-") {
	    didi("$sig(3): missing \"-\" for argument type number ",$na+1,": sorry we were asked to be strict!");
	}
        $ARGU[2*$na] = substr($ARGU[2*$na],1);
    }
}

### some checking and transforming the parameter file arguments into parameters
sub argufparameters {
    $nbaef = int(scalar(@argu) / 2); 
    if (scalar(@argu) != 2 * $nbaef ) {didi("(?): ".scalar(@argu)." is a bad number of arguments for the parameter file (must be even)!")}
    for (my $na = 0; $na < $nbaef; $na++) {
        if (substr($argu[2*$na],0,1) ne "-") {
	    didi("(?): missing \"-\" for argument type number ",$na+1,": sorry we were asked to be strict!");
	}
        if ($argu[2*$na] eq "pafil") {
	    $argu[2*$na] = $argu{pafil};
	}
	else {
	    $argu[2*$na] = substr($argu[2*$na],1);
	}
    }
}

### normalizing the options
sub normaoptions {
    my @check;
    # checking every parameter
    foreach (keys %parameters) {
        # is checking of necessity ?
        my $aaa = "\@check = %".$_.";";
        eval $aaa;
	if ($#check > 1) {
            # check must be done
	    my $aargu = "&checkoption($_,%".$_.");";
	    eval $aargu;
	}
    }

}

### checking one options
sub checkoption {
    my ($jbd,%jd) = @_;
    if (!(exists($jd{$argu{$jbd}}))) {
	wawa("value of parameter \"".$jbd."\" is wrong [".$argu{$jbd}."], and was forced to default: \"".$jd{default}."\"");
        $argu{$jbd} = $jd{default};
    }
}

### answering if the possible row $_[0] is selected according to $argu{rosel}
sub selecrow {
    my ($nuco,$nbco,@val,$uuu,$vvv,$proteg,$opera,$valeur);
    if ($argu{rosel} eq 0) {
        # no selection
        return 1;
    }
    elsif (substr($argu{rosel},0,1) =~ /\d/) {
        # selection according to a column value
        if ($argu{rosel} =~ /\|/ ) {
          # selection by comparison
	  @val = split(/$argu{insep}/,$_);
	  $nbco = $#val + 1; # column number
	  $nuco = substr($argu{rosel},0,index($argu{rosel},"|")); # designated column
          # column; operator; value
          ($nuco,$opera,$valeur) = split(/\|/,$argu{rosel});
	  if (($nuco > ($nbco+1)) or ($nuco <= 0)) {
	      print $_,"\n";
            print join("+",@val),"\n";
            print join(":",($nbco,$nuco,$opera,$valeur)),"\n";
            print join(":",split(/\|/,$argu{rosel})),"\n";
            didi("(?) bad \"rosel\" parameter ($argu{rosel}) the column for matching does not exist in input file line number $nbr");
          }
	  # a series of protection to continue...
	  $proteg = $val[$nuco-1];
	  $proteg =~ s/@/\\@/;
	  $proteg =~ s/\$/\\\$/;
	  $uuu = "\$vvv = (\"".$proteg."\"".$opera."\" ".$valeur."\");";
          eval($uuu);
          return($vvv);
        } else {
          # selection by matching
	  @val = split(/$argu{insep}/,$_);
	  $nbco = $#val + 1;
	  $nuco = substr($argu{rosel},0,index($argu{rosel},"/"));
	  # a series of protection to continue...
	  $proteg = $val[$nuco-1];
	  $proteg =~ s/@/\\@/;
	  $proteg =~ s/\$/\\\$/;
	  if ($nuco > ($nbco+1)) {
            didi("(?) bad \"rosel\" parameter the column for matching does not exist in input file line number $nbr");
          }
	  $uuu = "\$vvv = (\"".$proteg."\" =~ ".substr($argu{rosel},index($argu{rosel},"/")).")";
	  # (je ne suis pas satisfait de ce qui suit car j'aurais voulu sélectionner en cas de mauvaise syntaxe !)
	  if (eval($uuu)) { return (1);}
	  else { return 0;}
      }
    }
    else {
        # selection by row numbers
        @val = split(/\//,substr($argu{rosel},1));
        $nuco = 0;
        foreach (@val) { if ($_ == $nbr) { $nuco++;}}
        return $nuco;
    }
}

### ordering according to the distinct options
sub ordre {
    my ($nbr,$typ,$cha,$quoi,$val) = @_[0..4];
    my (@val,@res);
    for (my $i=0; $i < @$val; $i++) {
        $val[$i] = $val->[$i];
    }

    if ($typ eq "0")    { foreach (1..$nbr) {$res[$_-1] = $_; }}
    elsif ($typ eq "D") {
        # leaving out the first and last character
        chop($cha); $cha = reverse($cha);
        chop($cha); $cha = reverse($cha);
	@res = split(/\//,$cha);
    }
    else {
        my $i = 0;
        foreach (@val) {
	    $i++;
            $or{$i} = $_;
	}
	if ($typ eq "A") {@res = sort sortA keys(%or);}
	if ($typ eq "a") {@res = sort sorta keys(%or);}
	if ($typ eq "N") {@res = sort sortN keys(%or);}
	if ($typ eq "n") {@res = sort sortn keys(%or);}
    }
    for (my $i = 0; $i <= $#res; $i++) {
        if (($res[$i] < 1) || ($res[$i] > $nbr)) {
	    wawa(">".$res[$i]."< is a bad value for ".$quoi." order forced to 1!");
	    $res[$i] = 1;
	}
    }
    return @res;
}

### for &order use
sub sortA { $or{$a} cmp $or{$b};}
sub sorta { $or{$b} cmp $or{$a};}
sub sortN { $or{$a} <=> $or{$b};}
sub sortn { $or{$b} <=> $or{$a};}

### determining if one row/column is used for sorting
sub socr {
    my $nu = $_[0];
    my $ar = $_[0];
    my $ap = $_[1];
    my $ty = "D";
    if ($nu =~ /^\d+/) { 
        if ($ar ne "0") {
	    $ty = substr($nu,-1,1);
	    if (!($ty =~ /A|a|N|n/)) {
		&wawa("unknown sorting specification forced to \"A\" in \"-$ap $ar\"");
		$ty = "A";
	    }
	    $nu = substr($nu,0,length($nu)-1);
	    if (!($nu =~ /\d+/)) {
		&didi("(?) bad sorting specification in \"-$ap $ar\"");
	    }
	}
	else {
	    $ty = "0";
	}
    }
    return ($nu,$ty);
}

### normalizing an array of text
sub stdtext{
    my @res = ();
    foreach(@_) {
	chomp;
        s/ +/ /;
        s/^\s+|\s+$//g;
        push @res,$_;
    }
    return @res;
}

### aligning on left or right or centered
sub aligne {
    # $_[0] is the string to align, i.e. to complete or reduce
    # $_[1] is the size of the string to attain (10 as default)
    # $_[2] "l" for left (default), "r" for rigth, "c" for centered
    # $_[3] "character" for completing on left (" " is the default)
    # $_[4] "character" for completing on rigth (" " is the default)
    # $_[5] "s" if implied truncation must be done
    # $_[6] when truncation is performed this string is added
    #       to indicate it ("$" is the default)
    # 
    # filling the parameters

    my ($res,$lon,$typ,$fig,$fir,$cut,$ooo,$nau);
    if ($#_ >= 0) { $res = $_[0];} else {
        die("\"aligne\" needs at least one argument\n");
    } 
     if ($#_ >= 1) { $lon = $_[1];} else { $lon = 10;}
     if ($lon < 1) { $lon = 10;}
     if ($#_ >= 2) { $typ = $_[2];} else { $typ = "l";}
     if (($typ ne "r") && ($typ ne "c")) {$typ = "l";}
     if ($#_ >= 3) { $fig = $_[3];} else { $fig = " ";}
     if (length($fig) > 1) { $fig = substr($fig,0,1); }
     if ($#_ >= 4) { $fir = $_[4];} else { $fir = " ";}
     if (length($fir) > 1) { $fir = substr($fir,0,1); }
     if ($#_ >= 5) { $cut = $_[5];} else { $cut = "n";}
     if ($#_ >= 6) { $nau = $_[6];} else { $nau = "\$";}
     if ($cut ne "s") {$cut = "n";}

     $ooo = 1; if ($typ eq "r") { $ooo = -1;}
     while (length($res) < $lon) {
         if ($ooo > 0) {$res = $res.$fir; }
         else {$res = $fig.$res; }
         if ($typ eq "c") { $ooo = -1 * $ooo; }
     }
     if ($cut eq "s") {
         $ooo = 1; if ($typ eq "r") { $ooo = -1;}
         while (length($res) > $lon) {
             if ($ooo > 0) {
                 $res = substr($res,0,length($res)-1-length($nau)).$nau;
             }
             else {
                 $res = $nau.substr($res,1+length($nau));
             }
             if ($typ eq "c") { $ooo = -1 * $ooo; }
         }
     }
     return $res;
}

#
# ending subroutines
#
#############################################

#############################################
#
#  beginning formats
#

format parameters =
@>>>>>>>>>>:  @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<...
$_,$parameters{$_}
.

format parameterdetails =
@>>>>>>>>>>:  @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$_,$defdef{$_}
.

format arguments =
@>>>>>>>>>>>>>>   @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
"-".$k,$v
.

#
#   ending formats
#
#############################################

#############################################
#
# beginning tags
#

my %entet = ("h","<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\"
    \"http://www.w3.org/TR/html4/loose.dtd\">
<html>
<head>
  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />
  <title> $sig </title>
</head>

<body>
",
"l"," %% document created by $sig
 
 \\documentclass{article}
 \\usepackage[utf8]{inputenc}
 \\usepackage[T1]{fontenc} 
 \\begin{document} 
",
"t",
"\n".("="x40)."\n"."table produced by $sig\n");

my %basde = ("h","</body></html>\n",
          "l","\\end{document}\n",
          "t","\n"."="x40);


my %bdate = ("h","<p><small>created with <b>$sig</b> on </small>",
          "l","\\title{Created with $sig}\n\\date{",
          "t","(created with *$sig* on ");
my %edate = ("h","</p>\n",
          "l","}\n\\maketitle\n",
          "t",")\n\n");

my %btitr = ("h","<h1>",   "l","\\section*{","t","< ");
my %etitr = ("h","</h1>\n","l","}\n",       "t"," >\n\n");

my %bcapt = ("h","<p>",   "l","","t","- ");
my %ecapt = ("h","</p>\n","l","\\\\\n\n",       "t"," -\n\n");

my %bstru = ("h0","<table border=\"1\"><tbody>\n",
          "h1","<ul>\n",
          "h2","<dl>\n",
          "h3","<table border=\"1\"><tbody>\n",
          "l0","\\bigskip\n\\begin{tabular}\n[c]",
          "l1","\\begin{itemize}\n",
          "l2","\\begin{description}\n",
          "l3","\\begin{tabular}\n[c]",
          "t0","\n",
          "t1","\n\n",
          "t2","\n\n",
          "if","");
my %estru = ("h0","</tbody></table>\n",
          "h1","</ul>\n",
          "h2","</dl>\n",
          "h3","</tbody></table>\n",
          "l0","\\end{tabular}\n",
          "l1","\\end{itemize}\n",
          "l2","\\end{description}\n",
          "l3","\\end{tabular}\n",
          "t0","\n",
          "t1","\n\n",
          "t2","\n\n",
          "if","");

my %bbold = ("h","<strong>", "l","\\textbf{","t","*");
my %ebold = ("h","</strong>","l","}",        "t","*");
my %bital = ("h","<em>",     "l","\\textit{","t","{");
my %eital = ("h","</em>",    "l","}",        "t","}");

#
# ending tags
#
#############################################

#############################################
#
# beginning code
#

@ARGU = @ARGV;

### giving some help if asked
my $affichage_aide = &aidons;

### if not, performing some transformation
if ($affichage_aide < 0) {
    # preparing the log file
    open(LOG,">$log") || die ("$sig: can't create $log");
    print LOG "#"x3,"   log file of tabla\n";
    print LOG "#"x3,"\n";
    print LOG "#"x3,"   <<< $sig >>>\n";
    print LOG "#"x3,"\n";
    print LOG "#"x3,"   used at ",scalar(localtime()),"\n";
    print LOG "#"x3,"\n";

    # dealing with parameter arguments
    &arguparameters;
    # determining the input file
    $fentree = $ARGU[$#ARGU];
    open(ENTREE,$fentree) || didi("$sig(???): unreachable input file $fentree");
    # loading the default parameters
    foreach (keys %parameters) {
        my $aaa = "\$argu{\$_} = \$".$_."{default};";
        eval $aaa; 
    }
    # overloading the inline parameters
    for (my $na = 0; $na < $nbae; $na++) {
        $argu{$ARGU[2*$na]} = $ARGU[1+2*$na];
    }
    # checking the consistency of inline parameters
    &normaoptions;
    #print "1: ",$argu{rosor},"\n";
    # is there a parameter file?
    if ($argu{pafil} ne "0") {
        # opening the parameter file
        &fileparameters($argu{pafil});
        # checking and dealing with these ones
        &argufparameters;
        # overloading the file parameters into %argu from @argu
        for (my $na = 0; $na < $nbaef; $na++) {
            $argu{$argu[2*$na]} = $argu[1+2*$na];
        }
        # checking the consistency of the new parameters
        &normaoptions;
        # getting possible title and caption in it
        &filetitcap($argu{pafil});
    }
    #print "2: ",$argu{rosor},"\n";
    # re-overloading the inline parameters to give them the first priority
    for (my $na = 0; $na < $nbae; $na++) {
        $argu{$ARGU[2*$na]} = $ARGU[1+2*$na];
    }
    #print "3: ",$argu{rosor},"\n";
    # checking once more the consistency of parameters
    &normaoptions;
    ### printing the arguments in the log file
    my $oldhandle = select(LOG); $~ = "arguments"; select($oldhandle);
    print LOG "#\n# Arguments Retained:","\n#","-"x19,"\n#\n";
    while (($k,$v) = each %argu) {
        print LOG "#\n# ",substr($parameters{$k},0,25),"...\n";
        write LOG;
    }
    ### this part is quite raw: to be thought another time
    my $tp     = $argu{outyp};
    my $sortyp = substr($tp,0,1); 
    ### specific modifications according to the type of output
    if ($tp eq "if") {
	$basde{$sortyp} = "";
	$entet{$sortyp} = "";
    }

    if ($tp eq "l0") { $argu{ousep} = " & "; }
    if ($tp eq "l3") { $argu{ousep} = " \\\\\n "; }
    ### determining the outfile name
    if ($argu{oufil} eq "0") {
        if ($fentree =~ /\.txt$/) { $fsortie = substr($fentree,0,length($fentree)-4);}
        else { $fsortie = $fentree; }
        if    ($sortyp eq "h") {$fsortie = $fsortie.".html";}
        elsif ($sortyp eq "l") {$fsortie = $fsortie.".tex";}
        elsif ($sortyp eq "t") {$fsortie = $fsortie.".txt";}
        else                    {$fsortie = $fsortie.".tt";}
        if ($fentree eq $fsortie) {
            $fsortie = substr($fentree,0,length($fentree)-4)."bis.txt";
        }
    }
    else { $fsortie = $argu{oufil}; }
    open(SORTIE,">$fsortie") || didi("(?): [$fsortie] not writable as output file"); 
    ### giving some news
    print " "x3," $sig is transforming \"$fentree\" file \n";
    print " "x7,"- into \"$fsortie\" file\n";
    print " "x7,"- with format $tp\n";
    print LOG "###\n";
    print LOG "###      input file: ",$fentree,"\n";
    print LOG "###     output file: ",$fsortie,"\n";
    print LOG "###\n";

    ### determining if some rows or columns must be retained for sorting
    my ($nurow,$tycol) = &socr($argu{cosor},"cosor");
    my ($nucol,$tyrow) = &socr($argu{rosor},"rosor");

    ##### First Reading to select the different type of information
    my @parlig = ();
    my @lignes = (); my @nulig = (); my $ininulig = 0;
    while (<ENTREE>) {
      $ininulig++;
      if (!(/^$argu{incom}/)) {
        if    (/^$argu{inpar}/) { push @parlig,  $_;}
        elsif (/^$argu{intit}/) { 
          push @titre,substr($_,length($argu{intit}));
        }
        elsif (/^$argu{incap}/) {
          push @legende,substr($_,length($argu{incap}));
        }
        else {
          push @lignes, $_;
          push @nulig, $ininulig;
        }
      }
    }

    ### scrutinizing every line and 
    ###     - storing retained data into a vector
    ###     - looking for the number of retained rows
    ###     - looking for the number of retained columns
    #
    # initializing
    my $nbcols = 0; my $nbrows = 0;
    my @tout = (); my @sortcol = (); my @sortrow = ();
    if (scalar @titrefile > 0) { @titre = @titrefile;}
    if (scalar @legendefile > 0) { @legende = @legendefile;}
    @titre = &stdtext(@titre);
    my $titre = join(" ", @titre);
    @legende = &stdtext(@legende);
    foreach (@lignes) {
            # is the line selected
            if (&selecrow($_)) {
                $nbrows++;
                chop;
                # accounting for the column number
                $nbcl = split(/$argu{insep}/,$_);
                if ($nbcl == 0) {didi("(?) : a row of input data is empty !\ MAYBE, it is the LAST line?");}
                if ($nbcols < $nbcl) { $nbcols = $nbcl;}
                if ($argu{inbla} eq "y") {
                    # removing all spaces around the seperators
                    while ($_ =~ / $argu{insep}/) { s/ $argu{insep}/$argu{insep}/;}
                    while ($_ =~ /$argu{insep} /) { s/$argu{insep} /$argu{insep}/;}
                    # removing all spaces at the beginning and the end
                    while ($_ =~ /^ /) { s/^ //;}
                    while ($_ =~ / $/) { s/ $//;}
	        }
		my @vale = split(/$argu{insep}/,$_);
                if ($nucol > 0) {
                    if ($nucol > $nbcl) { push @sortcol, $argu{oumis};}
		    else { push @sortcol, $vale[$nucol-1];}
		}
		if ($nurow == $nbrows) { @sortrow = @vale;}
                push @tout, $_;
		}
	    }

    print " "x7,"- $nbcols is the column number\n";
    print " "x7,"- $nbrows is the row    number\n";
    if ($nbcols == 0) {&wawa("NO ONE COLUMN was obtained... see if you agree!");}
    if ($nbrows == 0) {&wawa("NO ONE ROW was obtained... see if you agree!");}
    if ($nurow > $nbrows) {
        &didi("(?) you asked sorting columns with a row which does not exist!");
    }
    if ($nucol > $nbcols) {
        &didi("(?) you asked sorting rows with a column which does not exist!");
    }

    ### completing the missing cells
    for ($jbd = 0; $jbd <= $#tout; $jbd++) {
        $nbcl = split(/$argu{insep}/,$tout[$jbd]);
        for ($jd = 1; $jd <= $nbcols - $nbcl; $jd++) {
            $tout[$jbd] = $tout[$jbd].$argu{insep}.$argu{oumis};
        }
    }

    ### determining the rows and columns to display
    my @ordrerow = &ordre($nbrows,$tyrow,$nucol,"rows",   \@sortcol);
    my @ordrecol = &ordre($nbcols,$tycol,$nurow,"columns",\@sortrow);

    ### repeating if asked the first row
    if ($argu{rorep} > 0) {
        $hl = int($#ordrerow / $argu{rorep});
	my $ll = $ordrerow[0];
	for my $hh (1..$hl) {
	    my $lll = $hh*($argu{rorep}+1);
	    splice(@ordrerow,$lll,0,$ll);
	}
    }

    ### dealing with column width for the text output
    # the following exploration is necessary to know the adjusted width for
    # each column which is stored into @lar
    if (($tp eq "t0") || ($tp eq "h0") || ($tp eq "l0") ||
        ($tp eq "t3") || ($tp eq "h3") || ($tp eq "l3")) { $la = 1; } else { $la = 0; }
    if ($la) {
        if ($sortyp eq "l") { $lla = "\\\$";} else { $lla = "\$";}
	if ($argu{comiw} > $argu{comaw}) {
	    &didi("(?) you said that minimum width was more that maximum!");
	}
        for ($jbd = 0; $jbd < $nbcols; $jbd++) {$lar[$jbd]=$argu{comiw};}
        for ($jbd = 0; $jbd <= $#tout; $jbd++) {
            $nbcl = split(/$argu{insep}/,$tout[$jbd]);
            # ajoût des éventuelles valeurs manquantes
            for ($jd = 1; $jd <= $nbcols - $nbcl; $jd++) {
                $tout[$jbd] = $tout[$jbd].$argu{insep}.$argu{oumis};
            }
            my @larg = split(/$argu{insep}/,$tout[$jbd]);
            for ($sd = 0; $sd < $nbcols; $sd++) {
                $larg = length($larg[$sd]);
                # this to prevent bolding or italicizing but not both of them!
                if ($sortyp eq "t") { $larg = $larg + 2; }
                if ($lar[$sd] < $larg) {$lar[$sd] = $larg; }
                if ($lar[$sd] > $argu{comaw}) {$lar[$sd] = $argu{comaw}; }
            }
        }
	if (($tp eq "t3") || ($tp eq "h3") || ($tp eq "l3")) {
            # giving the same width for all columns in case of labels
            foreach (@lar) { if ($lala < $_) { $lala = $_; }}
            foreach (@lar) { $_ = $lala; }
	}
    }



    ### adding the typographical transformations and applying the width restriction
    $numlig = 0;
    foreach $hdd (0..$#tout) {
	$numlig++;
        $hd = $tout[$hdd];
        my @larg = split(/$argu{insep}/,$hd);
        foreach (0..$#larg) {
	    $numcol = $_ + 1;
	    $element = $larg[$_];
            # putting it the right width if necessary
            if (($la) and ($sortyp ne "t")) {
                $element = &aligne($element,$lar[$_],$argu{coali}," "," ","s",$lla);
	    }
            # upper casing
            if (($argu{coupc} == $numcol) ||($argu{roupc} == $numlig)) {
		$element = uc($element);
	    }
            # bolding
            if (($argu{cobol} == $numcol) ||($argu{robol} == $numlig)) {
		$element = $bbold{$sortyp}.$element.$ebold{$sortyp};
	    }
            # italicizing
            if (($argu{coita} == $numcol) ||($argu{roita} == $numlig)) {
		$element = $bital{$sortyp}.$element.$eital{$sortyp};
	    }
            if (($la) and ($sortyp eq "t")) {
                $element = &aligne($element,$lar[$_],$argu{coali}," "," ","s",$lla);
	    }
            if ($_ == 0) {
		$hd = $element;
	    }
	    else {
		$hd = $hd.$argu{insep}.$element;
	    }
	    if ($printhelp) { warn($hd); }
        }    
        $tout[$hdd] = $hd;
    }

    ### preparing the numbering
    if ($argu{ronbr} > 0) {
        # determing the width of this new field
        if    ($#tout < 9)    {$lnu = 1;}
        elsif ($#tout < 99)   {$lnu = 2;}
        elsif ($#tout < 999)  {$lnu = 3;}
        elsif ($#tout < 9999) {$lnu = 4;}
        else                  {$lnu = 5;} 
    }

    ### recording some values...
    if ($printhelp) {
	warn "\$sortyp      = ",$sortyp;
	warn "\$tp          = ",$tp;
        warn "\$argu{colab} = ",$argu{colab};
    }
    

    ### writing the output file 
    if ($tp ne "if") {
        ## writing the heading
        print SORTIE $entet{$sortyp};
        ## writing the date
        print SORTIE $bdate{$sortyp},$dat,$edate{$sortyp};
        ## writing the title
        if ($titre ne "") {
            print SORTIE $btitr{$sortyp},$titre,$etitr{$sortyp};
        }
        ## writing the caption
        foreach(@legende) {
            print SORTIE $bcapt{$sortyp},$_,$ecapt{$sortyp};
        }
    }
    else {
        if ($titre ne "") {print SORTIE $argu{intit},$titre,"\n";}
        foreach(@legende) {
            print SORTIE $argu{incap},$_,"\n";
        }
    }
 
    ## heading of structure
    print SORTIE $bstru{$tp};
    #####################
    ##> text table
    if ($tp eq "t0") {
        my %tag = (blign => "   ", elign => "\n", bcolo => "", ecolo => " ");
	$hl = 0;
        foreach (@ordrerow) {
	    $hl++;
	    print SORTIE $tag{blign};
	    my @larg = split(/$argu{insep}/,$tout[$_-1]);
            ## looping onto columns
	    $yd = 0;
            foreach (@ordrecol) {
		$yd++;
		if ($yd == $argu{ronbr}) {
		    print SORTIE $tag{bcolo};
		    print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
		    print SORTIE $tag{ecolo};
		}
                print SORTIE $tag{bcolo};
                print SORTIE $larg[$_-1];
                print SORTIE $tag{ecolo};
            }    
	    if (($#ordrecol +1) < $argu{ronbr}) {
		print SORTIE $tag{bcolo};
		print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
		print SORTIE $tag{ecolo};
	    }
	    print SORTIE $tag{elign};
        }
    }
    #####################
    ##> html table
    elsif ($tp eq "h0") {
        my  %tag = (blign => "<tr>\n", elign => "</tr>\n", bcolo => "<td>", ecolo => "</td>");
	$hl = 0;
        foreach (@ordrerow) {
	    $hl++;
	    print SORTIE $tag{blign};
	    my @larg = split(/$argu{insep}/,$tout[$_-1]);
            ## looping onto columns
	    $yd = 0;
            foreach (@ordrecol) {
		$yd++;
		if ($yd == $argu{ronbr}) {
		    print SORTIE $tag{bcolo};
		    print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
		    print SORTIE $tag{ecolo};
		}
                print SORTIE $tag{bcolo};
                print SORTIE $larg[$_-1];
#		if ($printhelp) { warn($larg[$_-1]);}
                print SORTIE $tag{ecolo};
            }    
	    if (($#ordrecol +1) < $argu{ronbr}) {
		print SORTIE $tag{bcolo};
		print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
		print SORTIE $tag{ecolo};
	    }
	    print SORTIE $tag{elign};
        }
    }
    #####################
    ##> latex table
    elsif ($tp eq "l0") {
        my %tag = (blign => "",
                   elign => "\\\\\\hline\n",
                  );
        $hl = $nbcols;
        if ($argu{ronbr} > 0) {$hl++;}
        print SORTIE "{|","$argu{coali}|"x$hl,"}\\hline\n";
	$hl = 0;
        foreach (@ordrerow) {
	    $hl++;
	    print SORTIE $tag{blign};
	    my @larg = split(/$argu{insep}/,$tout[$_-1]);
            ## looping onto columns
            $nbc = 0;
            foreach (@ordrecol) {
                $nbc++;
                if ($nbc > 1) {print SORTIE $argu{ousep};}
		if ($nbc == $argu{ronbr}) {
		    print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
		    print SORTIE $argu{ousep};
		}
                print SORTIE $larg[$_-1];
                if (($_ eq $ordrecol[$#ordrecol]) and ($tp eq "l3")) { 
                    print SORTIE "\\\\\n";
                }
            }
	    if (($#ordrecol + 1) < $argu{ronbr}) {
		print SORTIE $argu{ousep};
		print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
	    }
	    print SORTIE $tag{elign};
        }
    }
    #####################
    ##> text bullet list
    elsif ($tp eq "t1") {
        my %tag = (
                blign => "\n   (*)   ",
                elign => "\n",
		);
	$hl = 0;
        foreach (@ordrerow) {
	    $hl++;
	    print SORTIE $tag{blign};
	    my @larg = split(/$argu{insep}/,$tout[$_-1]);
            ## looping onto columns
            $nbc = 0;
            foreach (@ordrecol) {
                $nbc++;
                if ($nbc > 1) {print SORTIE $argu{ousep};}
		if ($nbc == $argu{ronbr}) {
		    print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
		    print SORTIE $argu{ousep};
		}
                print SORTIE $larg[$_-1];
            }
	    if (($#ordrecol + 1) < $argu{ronbr}) {
		print SORTIE $argu{ousep};
		print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
	    }
	    print SORTIE $tag{elign};
        }
    }
    #####################
    ##> html bullet list
    elsif ($tp eq "h1") {
        my %tag = (
                blign => "<li>\n",
                elign => "</li>\n",
		);
	$hl = 0;
        foreach (@ordrerow) {
	    $hl++;
	    print SORTIE $tag{blign};
            # latex label structure
	    my @larg = split(/$argu{insep}/,$tout[$_-1]);
            ## looping onto columns
            $nbc = 0;
            foreach (@ordrecol) {
                $nbc++;
                if ($nbc > 1) {print SORTIE $argu{ousep};}
		if ($nbc == $argu{ronbr}) {
		    print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
		    print SORTIE $argu{ousep};
		}
                print SORTIE $larg[$_-1];
            }
	    if (($#ordrecol + 1) < $argu{ronbr}) {
		print SORTIE $argu{ousep};
		print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
	    }
	    print SORTIE $tag{elign};
        }
    }
    #####################
    ##> latex bullet list
    elsif ($tp eq "l1") {
        my %tag = (
                blign => "\\item ",
                elign => "\\\\\n",
		);
	$hl = 0;
        foreach (@ordrerow) {
	    $hl++;
	    print SORTIE $tag{blign};
            # latex label structure
	    my @larg = split(/$argu{insep}/,$tout[$_-1]);
            ## looping onto columns
            $nbc = 0;
            foreach (@ordrecol) {
                $nbc++;
                if ($nbc > 1) {print SORTIE $argu{ousep};}
		if ($nbc == $argu{ronbr}) {
		    print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
		    print SORTIE $argu{ousep};
		}
                print SORTIE $larg[$_-1];
            }
	    if (($#ordrecol + 1) < $argu{ronbr}) {
		print SORTIE $argu{ousep};
		print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
	    }
	    print SORTIE $tag{elign};
        }
    }
    #####################
    ##> text definition list
    elsif ($tp eq "t2") {
        my %tag = (
                blign => "\n   ",
                elign => "\n",
                bcolo => "",
                ecolo => " ",
                blist => "<",
                elist => ">:  ",
		);
	$hl = 0;
        foreach (@ordrerow) {
	    $hl++;
	    print SORTIE $tag{blign};
	    my @larg = split(/$argu{insep}/,$tout[$_-1]);
            ## looping onto columns
            $nbc = 0;
            foreach (@ordrecol) {
                $nbc++;
                if ($nbc == 1) {
		    if ($nbc == $argu{ronbr}) {
			print SORTIE $tag{blist};
			print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
			print SORTIE $tag{elist};
			print SORTIE $tag{bcolo};
			print SORTIE $larg[$_-1];
		    }
		    else {
			print SORTIE $tag{blist};
			print SORTIE $larg[$_-1];
			print SORTIE $tag{elist};
		    }
		}
                elsif ( $nbc == 2) {
		    if ($nbc == $argu{ronbr}) {
			print SORTIE $tag{bcolo};
			print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
			print SORTIE $argu{ousep};
			print SORTIE $larg[$_-1];
		    }
		    else {
			if (1 == $argu{ronbr}) { print SORTIE $argu{ousep};}
                        else {print SORTIE $tag{bcolo};}
			print SORTIE $larg[$_-1];
		    }
		}
		else {
		    if ($nbc == $argu{ronbr}) {
			print SORTIE $argu{ousep};
			print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
			print SORTIE $argu{ousep};
			print SORTIE $larg[$_-1];
		    }
		    else {
			print SORTIE $argu{ousep};
			print SORTIE $larg[$_-1];
		    }
		}
            }
	    if (($#ordrecol + 1) < $argu{ronbr}) {
		print SORTIE $argu{ousep};
		print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
	    }
	    print SORTIE $tag{ecolo};
	    print SORTIE $tag{elign};
        }
    }
    #####################
    ##> html definition list
    elsif ($tp eq "h2") {
        my %tag = (
                blign => "<dl>\n",
                elign => "</dl>\n",
                bcolo => "<dd>",
                ecolo => "</dd>",
                blist => "<dt>",
                elist => "</dt>",
		);
	$hl = 0;
        foreach (@ordrerow) {
	    $hl++;
	    print SORTIE $tag{blign};
	    my @larg = split(/$argu{insep}/,$tout[$_-1]);
            ## looping onto columns
            $nbc = 0;
            foreach (@ordrecol) {
                $nbc++;
                if ($nbc == 1) {
		    if ($nbc == $argu{ronbr}) {
			print SORTIE $tag{blist};
			print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
			print SORTIE $tag{elist};
			print SORTIE $tag{bcolo};
			print SORTIE $larg[$_-1];
		    }
		    else {
			print SORTIE $tag{blist};
			print SORTIE $larg[$_-1];
			print SORTIE $tag{elist};
		    }
		}
                elsif ( $nbc == 2) {
		    if ($nbc == $argu{ronbr}) {
			print SORTIE $tag{bcolo};
			print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
			print SORTIE $argu{ousep};
			print SORTIE $larg[$_-1];
		    }
		    else {
			if (1 == $argu{ronbr}) { print SORTIE $argu{ousep};}
                        else {print SORTIE $tag{bcolo};}
			print SORTIE $larg[$_-1];
		    }
		}
		else {
		    if ($nbc == $argu{ronbr}) {
			print SORTIE $argu{ousep};
			print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
			print SORTIE $argu{ousep};
			print SORTIE $larg[$_-1];
		    }
		    else {
			print SORTIE $argu{ousep};
			print SORTIE $larg[$_-1];
		    }
		}
            }
	    if (($#ordrecol + 1) < $argu{ronbr}) {
		print SORTIE $argu{ousep};
		print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
	    }
	    print SORTIE $tag{ecolo};
	    print SORTIE $tag{elign};
        }
    }
    #####################
    ##> latex definition list
    elsif ($tp eq "l2") {
        my %tag = (
                blign => "\\item",
                elign => "\\\\\n",
                bcolo => "",
                ecolo => "",
                blist => " [",
                elist => "] ",
		);
	$hl = 0;
        foreach (@ordrerow) {
	    $hl++;
	    print SORTIE $tag{blign};
	    my @larg = split(/$argu{insep}/,$tout[$_-1]);
            ## looping onto columns
            $nbc = 0;
            foreach (@ordrecol) {
                $nbc++;
                if ($nbc == 1) {
		    if ($nbc == $argu{ronbr}) {
			print SORTIE $tag{blist};
			print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
			print SORTIE $tag{elist};
			print SORTIE $tag{bcolo};
			print SORTIE $larg[$_-1];
		    }
		    else {
			print SORTIE $tag{blist};
			print SORTIE $larg[$_-1];
			print SORTIE $tag{elist};
		    }
		}
                elsif ( $nbc == 2) {
		    if ($nbc == $argu{ronbr}) {
			print SORTIE $tag{bcolo};
			print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
			print SORTIE $argu{ousep};
			print SORTIE $larg[$_-1];
		    }
		    else {
			if (1 == $argu{ronbr}) { print SORTIE $argu{ousep};}
                        else {print SORTIE $tag{bcolo};}
			print SORTIE $larg[$_-1];
		    }
		}
		else {
		    if ($nbc == $argu{ronbr}) {
			print SORTIE $argu{ousep};
			print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
			print SORTIE $argu{ousep};
			print SORTIE $larg[$_-1];
		    }
		    else {
			print SORTIE $argu{ousep};
			print SORTIE $larg[$_-1];
		    }
		}
            }
	    if (($#ordrecol + 1) < $argu{ronbr}) {
		print SORTIE $argu{ousep};
		print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
	    }
	    print SORTIE $tag{ecolo};
	    print SORTIE $tag{elign};
        }
    }
    #####################
    ##> text label
    if ($tp eq "t3") {
        if ($argu{oujup} < 1) { $argu{oujup} = $oujup{default}; }
	my $J = $#ordrecol;
	my $I = $#ordrerow;
	my $C = $argu{colab} - 1;
        my $R = ($I - ($I % ($C+1))) / ($C + 1) ;
        my $N = ($R+1)*($C+1)*($J+1) - 1;
        my ($j,$jj,$i,$ii,$c,$r,$n,$val);
        foreach $n (0..$N) {
            $c = $n % ($C+1);
            $r = int($n / (($C+1)*($J+1)));
            $i = $r * ($C+1) + $c; $ii = $ordrerow[$i];
            $j = (int($n/($C+1))) % ($J+1); $jj = $ordrecol[$j];
            # computing what must be printed out
            if ($i <= $I) {
		my @larg = split(/$argu{insep}/,$tout[$i]);
                $val = $larg[$j];
            }
            else { $val = " "x$lala; }
            # doing the right tagging and printing
            if (($c == 0) and ($j == 0)) {
                print SORTIE "+";
                for my $jbd (0..$C) { print SORTIE "-"x$lala,"+"; }
                print SORTIE "\n";
            }
            # printing the cell
            if ($c == 0) { print SORTIE "|"; }
            print SORTIE $val,"|";
            if ($c == $C) { print SORTIE "\n"; }
            if ($n == $N) {
                print SORTIE "+";
                for my $jbd (0..$C) { print SORTIE "-"x$lala,"+"; }
                print SORTIE "\n";
            }
            # introducing some separation
            if ( ($n != $N) and ($c == $C) and 
                 ($j == $J) and ((($r+1) % $argu{oujup})) == 0) {
                print SORTIE "+";
                for my $jbd (0..$C) { print SORTIE "-"x$lala,"+"; }
                print SORTIE "\n";
                print SORTIE "\n"x3;
	    }
        }
    }
    #####################
    ##> html label
    if ($tp eq "h3") {
        my %tag = (
                blign => "\n<table border=\"0\"><tbody>\n",
                elign => "</tbody></table>\n",
                bcolo => "<tr><td>",
                ecolo => "</td></tr>",
                bgrow => "<tr><td>",
                egrow => "</td></tr>",
                bgcol => "<td>",
                egcol => "</td>",
		);
	$hl = 0;
        foreach (@ordrerow) {
	    $hl++;
            if (($hl % $argu{colab}) == 1) {
                print SORTIE $tag{bgrow};
            }
            else { print SORTIE $tag{bgcol};}
	    print SORTIE $tag{blign};
	    my @larg = split(/$argu{insep}/,$tout[$_-1]);
            ## looping onto columns
	    $yd = 0;
            foreach (@ordrecol) {
		$yd++;
		if ($yd == $argu{ronbr}) {
		    print SORTIE $tag{bcolo};
		    print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
		    print SORTIE $tag{ecolo};
		}
                print SORTIE $tag{bcolo};
                print SORTIE $larg[$_-1];
                print SORTIE $tag{ecolo};
            }    
	    if (($#ordrecol +1) < $argu{ronbr}) {
		print SORTIE $tag{bcolo};
		print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
		print SORTIE $tag{ecolo};
	    }
	    print SORTIE $tag{elign};
            if (($hl % $argu{colab}) == 0) {
                print SORTIE $tag{egrow};
            }
            else { print SORTIE $tag{egcol};}
        }
    }
    #####################
    ##> latex label
    elsif ($tp eq "l3") {
        my %tag = (
                blign => "\n\\begin{tabular}\n[c]",
                elign => "\n\\end{tabular}\n",
                bcolo => " & ",
                ecolo => "",
                bgrow => "",
                egrow => "\\\\\\hline\n",
                bgcol => "",
                egcol => " & \n",
		);
        # simple list style or latex tabular
        print SORTIE "{|","$argu{coali}|"x$argu{colab},"}\\hline\n";
	$hl = 0;
        foreach (@ordrerow) {
	    $hl++;
            if (($hl % $argu{colab}) == 1) {
                print SORTIE $tag{bgrow};
            }
            else { print SORTIE $tag{bgcol};}
	    print SORTIE $tag{blign};
            print SORTIE "{$argu{coali}}\n";
	    my @larg = split(/$argu{insep}/,$tout[$_-1]);
            ## looping onto columns
            $nbc = 0;
            foreach (@ordrecol) {
                $nbc++;
                if ($nbc > 1) {print SORTIE $argu{ousep};}
		if ($nbc == $argu{ronbr}) {
		    print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
		    print SORTIE $argu{ousep};
		}
                print SORTIE $larg[$_-1];
                if ($_ eq $ordrecol[$#ordrecol]) { print SORTIE "\\\\\n";}
            }
	    if (($#ordrecol + 1) < $argu{ronbr}) {
		print SORTIE $argu{ousep};
		print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
	    }
	    print SORTIE $tag{elign};
            if ((($hl % $argu{colab}) == 0) or ($_ eq $ordrerow[$#ordrerow])){
                print SORTIE $tag{egrow};
	    }
            else { print SORTIE $tag{egcol};}
	}
    }
    #####################
    ##> input table
    elsif ($tp eq "if") {
        my %tag = (
                   blign => "  ",
                   elign => "\n",
		   );
	$hl = 0;
        foreach (@ordrerow) {
	    $hl++;
	    print SORTIE $tag{blign};
	    my @larg = split(/$argu{insep}/,$tout[$_-1]);
            ## looping onto columns
            $nbc = 0;
            foreach (@ordrecol) {
                $nbc++;
                if ($nbc > 1) {print SORTIE $argu{ousep};}
		if ($nbc == $argu{ronbr}) {
		    print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
		    print SORTIE $argu{ousep};
		}
                print SORTIE $larg[$_-1];
            }
	    if (($#ordrecol + 1) < $argu{ronbr}) {
		print SORTIE $argu{ousep};
		print SORTIE " ((".&aligne($hl,$lnu,"r","0").")) ";
	    }
        print SORTIE $tag{elign};
        }
    }

    ## bottom of table
    print SORTIE $estru{$tp};
    ## writing the bottom
    print SORTIE $basde{$sortyp};


    ### closing files
    close(SORTIE);close(LOG);close(ENTREE);
    if ($argu{palog} ne $log) {
        ### giving another name to the log file
        move($log,$argu{palog}) || 
        didi("(?) cannot rename the log file into $argu{palog}");
    }
}

#
# ending code
#
#############################################

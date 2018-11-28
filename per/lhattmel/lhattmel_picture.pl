#!/usr/bin/perl -w
#
# 18_02_10 18_02_11 18_04_11 18_10_03
#
use strict;
use warnings;
use lib "/home/jbdenis/o/info/perl/lhattmel";
use lhattmel; 
#
my ($para,$ri0,$reun,$re000,$re00,$re0,$re1,$ri1,$ri21,$ri22,$ri23,$ri24,$ri3,$re2,@res);
my $imaun = [ {fil=>"pa01.jpg",hei=>"8cm"} ];
my $ima00 = [
              {fil=>"pa01.jpg",cap=>["hei=4cm"],hei=>"4cm"},
              {fil=>"po01.jpg",cap=>["hei=4cm"],hei=>"4cm"},
              {fil=>"pa01r.jpg",cap=>["hei=4cm"],hei=>"4cm"},
              {fil=>"po01r.jpg",cap=>["hei=4cm"],hei=>"4cm"},
           ];
my $ima000 = [
              {fil=>"pa01.jpg",cap=>["wid=4cm"],wid=>"4cm"},
              {fil=>"po01.jpg",cap=>["wid=4cm"],wid=>"4cm"},
              {fil=>"pa01r.jpg",cap=>["wid=4cm"],wid=>"4cm"},
              {fil=>"po01r.jpg",cap=>["wid=4cm"],wid=>"4cm"},
           ];
my $ima0 = [
              {fil=>"i41.jpg",cap=>["hei=4cm, angle= 0"],hei=>"4cm"},
              {fil=>"i41.jpg",cap=>["hei=4cm, angle=90"],hei=>"4cm",rot=>90},
              {fil=>"i41.jpg",cap=>["wid=4cm, angle=0"],wid=>"4cm"},
              {fil=>"i41.jpg",cap=>["wid=4cm, angle=90"],wid=>"4cm",rot=>90},
           ];
my $ima1 = [
              {fil=>"i41.jpg",cap=>["Lampe paysage"],wid=>"4cm"},
              {fil=>"i42.jpg",cap=>["Lampe portrait"],rot=>-90,hei=>"4cm"},
              {fil=>"i43.jpg",wid=>"4cm",rot=>90,cap=>["Sapin"]},
              {fil=>"i44.jpg",cap=>["Branche dans ciel"],wid=>"4cm",rot=>90}
             ];
my $ima2 = [
              {fil=>"i41.jpg",cap=>["Lampe","paysage"],wid=>"2cm"},
              {fil=>"i42.jpg",cap=>["Lampe","portrait"],rot=>-90,hei=>"2cm"},
              {fil=>"i44.jpg",cap=>["Branche","dans","ciel"],wid=>"2cm",rot=>90}
             ];
my $ima3 = [
              {fil=>"i41.jpg",cap=>["Lampe","paysage"],wid=>"2cm"},
              {fil=>"i44.jpg",cap=>["Branche","dans","ciel"],wid=>"2cm",rot=>90}
             ];
my $pla2 = [[2,2],[1,1],[2,1]];
my $cca = ["C'est bien de commenter chaque image.",
           "Mais il est aussi bien utile de donner une unité à la table complète !"];
my $ccb = ["Image Rajoutée"];
my $test = "toto";
$para = {tit=>"Pour COMMENCER",toc=>0,two=>1};
$para = {tit=>"Voir les retours de ligne",aut=>"Toto",toc=>0,two=>0};
foreach my $ti ("h","l") {
    $re1 = &lhattmel::start(par=>$para,typ=>$ti);
    ## adding some pictures
    $reun = &lhattmel::picture(ima=>$imaun,dim=>[1,1],opt=>"Hn");
    $re000 = &lhattmel::picture(ima=>$ima000,dim=>[2,2],opt=>"X");
    $re00 = &lhattmel::picture(ima=>$ima00,dim=>[2,2]);
    $re0 = &lhattmel::picture(ima=>$ima0,dim=>[2,2]);
    $ri0 = &lhattmel::picture(ima=>$ima3,dim=>[1,2],
			      cca=>$ccb,typ=>$ti,opt=>"c",typ=>$ti);
    $ri1 = &lhattmel::picture(ima=>$ima1,dim=>[2,2],
			      cca=>$cca,typ=>$ti,opt=>"c",typ=>$ti);
    #&uie::print8structure(str=>$ri1); &uie::pause();
    my $vopt = "b";
    $ri21 = &lhattmel::picture(ima=>$ima2,dim=>[2,2],pla=>$pla2,typ=>$ti,cca=>["premier",$vopt],
                              opt=>$vopt,typ=>$ti);
    $vopt = "c";
    $ri22 = &lhattmel::picture(ima=>$ima2,dim=>[2,2],pla=>$pla2,typ=>$ti,cca=>["deux","second",$vopt],
                              opt=>$vopt,typ=>$ti);
    $vopt = "i";
    $ri23 = &lhattmel::picture(ima=>$ima2,dim=>[2,2],pla=>$pla2,typ=>$ti,cca=>["troisieme",$vopt],
                              opt=>$vopt,typ=>$ti);
    $vopt = "l";
    $ri24 = &lhattmel::picture(ima=>$ima2,dim=>[2,2],pla=>$pla2,typ=>$ti,cca=>["quatrieme",$vopt],
                              opt=>$vopt,typ=>$ti);
    $ri3 = &lhattmel::picture(ima=>[{fil=>"i42.jpg",cap=>["Lampe portrait"],rot=>-90,hei=>"4cm"}],
                              cca=>["Une SEULE image"],typ=>$ti,opt=>"l",typ=>$ti);
    #&uie::print8structure(str=>$ri2); &uie::pause();
    $re2 = &lhattmel::end(typ=>$ti,typ=>$ti);
    @res = (@$re1,@$reun,@$re0,@$re000,@$re00,@$ri0,@$ri21,@$ri22,@$ri23,@$ri24,@$re2);
    if ($ti eq "l") {
        open(TOTO,">","$test.tex");
        foreach (@res) { print TOTO $_,"\n";}
        close(TOTO);
        if (system("pdflatex $test.tex $test.pdf")) {
            print "Compilation latex non réussie !\n";
            print "Le source est dans $test.tex\n";
            die;
	} 
    } else {
        open(TOTO,">","$test.html");
        foreach (@res) { print TOTO $_,"\n";}
        close(TOTO);
    }
    if ($ti eq "l") {
        #system("evince toto.pdf");
    }
}
system("ls -lrt $test.*");
#
#
print "-"x4,"End of lhattmel_start.pl","-"x25,"\n";
#
#############################################

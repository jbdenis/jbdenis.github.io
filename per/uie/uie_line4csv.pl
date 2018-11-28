#!/usr/bin/perl -w
#
# 17_04_11 18_02_09
#
use strict;
use warnings;
use uie; 
#
#
my $mat1 = {col1=>["l1","l2","l3"],col2=>["A","B","C"]};
&uie::print8structure(str=>$mat1);
my $dim0 = &uie::line4csv(mat=>$mat1,lin=>0);
&uie::print8structure(str=>$dim0);
&uie::pause(mes=>"non existing line of mat1");
my $dim1 = &uie::line4csv(mat=>$mat1,lin=>2);
&uie::print8structure(str=>$dim1);
&uie::pause(mes=>"second line of mat1");
#
my $mat2 = {a=>[30],b=>[40]};
&uie::print8structure(str=>$mat2);
my $dim2 = &uie::line4csv(mat=>$mat2);
&uie::print8structure(str=>$dim2);
&uie::pause(mes=>"dimension of mat2");
#
my $mat3 = {col1=>[1..3],col2=>[11..13],col3=>[21..23],col4=>[31..41]};
&uie::print8structure(str=>$mat3);
my $dim3 = &uie::line4csv(mat=>$mat3);
&uie::print8structure(str=>$dim3);
&uie::pause(mes=>"dimension of mat3");
#
print "-"x4,"test de 'line4csv' terminé","-"x25,"\n";
#
# fin du code
#
#############################################

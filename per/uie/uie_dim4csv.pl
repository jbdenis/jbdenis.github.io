#!/usr/bin/perl -w
#
# 17_04_11
#
use strict;
use warnings;
use uie; 
#
#
my $mat1 = {col1=>["l1","l2","l3"],col2=>["A","B","C"]};
&uie::print8structure(str=>$mat1);
my $dim1 = &uie::dim4csv(mat=>$mat1);
&uie::print8structure(str=>$dim1);
&uie::pause(mes=>"dimension of mat1");
#
my $mat2 = {};
&uie::print8structure(str=>$mat2);
my $dim2 = &uie::dim4csv(mat=>$mat2);
&uie::print8structure(str=>$dim2);
&uie::pause(mes=>"dimension of mat2");
#
my $mat3 = {col1=>[],col2=>[],col3=>[],col4=>[]};
&uie::print8structure(str=>$mat3);
my $dim3 = &uie::dim4csv(mat=>$mat3);
&uie::print8structure(str=>$dim3);
&uie::pause(mes=>"dimension of mat3");
#
print "-"x4,"test de 'dim4csv' terminé","-"x25,"\n";
#
# fin du code
#
#############################################

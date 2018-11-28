#!/usr/bin/perl -w
#
# 17_11_19
#
use warnings;
use strict;
use uie; 
#
my ($deb,$fin,$res);
#
$deb =
 {"cir"=> {"02"=> ["1","1"," Preparation", [" Preparation"]
, ["Les bagages doivent être préparés"]
, ["no comment!"]
, [] , ["03"]
]
,"04"=> ["1","2"," Voyage en Espagne", [" Voyage en Espagne"]
, ["Nous voilà partis"]
, [] , [] , [] ]
,"05"=> ["2","2.1"," Cordoue", [" Voyage en Espagne"," Cordoue"]
, ["un commentaire intermédiaire","on change le commentaire"]
, [] , [] , ["06","07","08","09","10"]
]
,"11"=> ["2","2.2"," Bordeaux", [" Voyage en Espagne"," Bordeaux"]
, [] , [] , [] , [] ]
,"12"=> ["3","2.2.1"," Le port", [" Voyage en Espagne"," Bordeaux"," Le port"]
, ["un autre commentaire intermédiaire (SECOND)"]
, ["vue imprenable","image unique"]
, [] , ["13","14"]
]
,"15"=> ["3","2.2.2"," La gare", [" Voyage en Espagne"," Bordeaux"," La gare"]
, [] , [] , [] , ["16"]
]
,"17"=> ["2","2.2","--------------------------------------------------", [" Voyage en Espagne"," Bordeaux"]
, [] , [] , [] , ["18","19"]
]
,"20"=> ["1","3"," Retour en France", [" Retour en France"]
, [] , [] , [] , [] ]
,"21"=> ["2","3.1"," Visite chez les filles", [" Retour en France"," Visite chez les filles"]
, [] , [] , [] , ["22","23"]
]
,"24"=> ["2","3.2"," Passage des garçons", [" Retour en France"," Passage des garçons"]
, [] , [] , [] , ["25","26"]
]
}
,"com"=> {},"dir"=> {"01"=>" /home/jbdenis/a"}
,"pic"=> {"03"=> ["P01.jpg","0000", [] , ["1 2","ma préférée","ville sous la mer","cultivated plants","deux","encore","flowers"]
, ["<(1)>Les bagages doivent être préparés","<(0)>no comment!"]
]
,"06"=> ["P02.jpg","0000", [] , ["natural plants","fleurs artificielles","vvx"]
, [] ]
,"07"=> ["P03.JPG","0000", [] , ["nn"]
, ["<(1)>Nous voilà partis","<(2)>un commentaire intermédiaire"]
]
,"08"=> ["P03b.jpg","0000", [] , [] , ["<(1)>Nous voilà partis","<(2)>on change le commentaire"]
]
,"09"=> ["P03c.jpg","0000", [] , [] , ["<(1)>Nous voilà partis","<(2)>on change le commentaire"]
]
,"10"=> ["P03d.jpg","0000", [] , ["eau","essence","vin"]
, ["<(1)>Nous voilà partis","<(2)>on change le commentaire"]
]
,"13"=> ["P04.png","2007", [] , [] , ["<(0)>vue imprenable"]
]
,"14"=> ["P05.jpg","2000_12", [] , ["très personnelle","zoo"]
, ["<(1)>Nous voilà partis","<(3)>un autre commentaire intermédiaire (SECOND)","<(0)>image unique"]
]
,"16"=> ["P06.png","2007", ["pv"]
, ["nn","v","xc"]
, [] ]
,"18"=> ["P07.jpg","2007", [] , ["pvv","vvc","vvx","plants"]
, ["<(1)>Nous voilà partis"]
]
,"19"=> ["2012_04_04.P08.jPG","2012_04_04", [] , [] , ["<(1)>Nous voilà partis"]
]
,"22"=> ["P07bb.jpg","2007", [] , ["pvv","vvc","vvx","plants"]
, [] ]
,"23"=> ["toto.png","2007", [] , [] , [] ]
,"25"=> ["pc12ttt.png","2007_12_12", [] , [] , [] ]
,"26"=> ["p430uuu.png","2007_04_30", [] , ["pvv"]
, [] ]
}
}

;
&uie::print8structure(str=>$deb);
$fin = &uie::write8structure(str=>$deb,fil=>"toto.txt");
$res = &uie::read8structure(fil=>"toto.txt");
&uie::print8structure(str=>$res);
&uie::pause(mes=>"sophisticated hash");
#
$deb = {1=>"un",2=>"deux","trois"=>3};
&uie::print8structure(str=>$deb);
$fin = &uie::write8structure(str=>$deb,fil=>"toto.txt");
$res = &uie::read8structure(fil=>"toto.txt");
&uie::print8structure(str=>$res);
&uie::pause(mes=>"simple hash");
#
$deb = [1,2,"trois"];
&uie::print8structure(str=>$deb);
$fin = &uie::write8structure(str=>$deb,fil=>"toto.txt");
$res = &uie::read8structure(fil=>"toto.txt");
&uie::print8structure(str=>$res);
&uie::pause(mes=>"simple array");
#
$deb = [[[1,2,3],4,5],[6,7],8,9];
&uie::print8structure(str=>$deb);
$fin = &uie::write8structure(str=>$deb,fil=>"toto.txt");
$res = &uie::read8structure(fil=>"toto.txt");
&uie::print8structure(str=>$res);
&uie::pause(mes=>"stacked arrays");
#
$deb = "COUAC";
&uie::print8structure(str=>$deb);
$fin = &uie::write8structure(str=>$deb,fil=>"toto.txt");
$res = &uie::read8structure(fil=>"toto.txt");
&uie::print8structure(str=>$res);
&uie::pause(mes=>"a simple string");
#
$deb = {};
&uie::print8structure(str=>$deb);
$fin = &uie::write8structure(str=>$deb,fil=>"toto.txt");
$res = &uie::read8structure(fil=>"toto.txt");
&uie::print8structure(str=>$res);
&uie::pause(mes=>"Empty Hash");
#
$deb = {a=>1, 
        A=>{b=>2,c=>3,d=>4},
        B=>{C=>{e=>5,f=>6,g=>7},D=>{h=>8,i=>9,j=>0},E=>{}}};
&uie::print8structure(str=>$deb);
$fin = &uie::write8structure(str=>$deb,fil=>"toto.txt");
$res = &uie::read8structure(fil=>"toto.txt");
&uie::print8structure(str=>$res);
&uie::pause(mes=>"Nested hashes");
;
#
# a depth three array
$deb = [1, 
           [2,3,4],
           [[5,6,7],[8,9,0],[]]];
&uie::print8structure(str=>$deb);
$fin = &uie::write8structure(str=>$deb,fil=>"toto.txt");
$res = &uie::read8structure(fil=>"toto.txt");
&uie::print8structure(str=>$res);
&uie::pause(mes=>"Three level with modification");
#
unlink("toto.txt");
#
print "-"x4,"Fin de uie_read8structure","-"x25,"\n";
#
# fin du code
#
#############################################

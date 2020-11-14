prologues := 2;
outputtemplate := "%j-%c.%o";
outputformat := "svg";
outputformatoptions := "format=rgba antialias=fast";

beginfig(1);
  draw (0,0)--(1cm,0)--(1cm,1cm)--(0,1cm)--cycle;
endfig;

beginfig(2);
  draw (0,0)..(1cm,0)..(1cm,1cm)..(0,1cm)..cycle;
endfig;

beginfig(3);
  z0 = (0,0);
  z1 = (60,40);
  z2 = (40,90);
  z3 = (10,70);
  z4 = (30,50);
  draw z0..z1..z2..z3..z4;
endfig;

beginfig(4);
  z0 = (0,0);
  z1 = (6cm,0);
  for a=0 upto 9:
    draw z0{dir 45}..{dir 10a}z1;
  endfor
  dotlabel.bot("(0,0)", z0);
  dotlabel.top("(6cm,0)", z1);
endfig;

beginfig(5);
  z1=-z2=(.2in,0);
  x3=-x6=.3in;
  x3+y3=x6+y6=1.1in;
  z4=1/3[z3,z6];
  z5=2/3[z3,z6];
  z20=whatever[z1,z3]=whatever[z2,z4];
  z30=whatever[z1,z4]=whatever[z2,z5];
  z40=whatever[z1,z5]=whatever[z2,z6];
  draw z1--z20--z2--z30--z1--z40--z2;
  pickup pencircle scaled 1pt;
  draw z1--z2;
endfig;

beginfig(6);
  path p;
  p = (-1cm,0)..(0,-1cm)..(1cm,0);
  fill p{up}..(0,0){-1,-2}..{up}cycle;
  draw p..(0,1cm)..cycle;
  draw bbox currentpicture;
endfig;

end

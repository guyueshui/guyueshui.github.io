% 3 - embedding font
% 2 - no font info, file size much smaller
prologues := 2;

outputtemplate := "%j-%c.%o";
%outputformat := "mps";
outputformat := "svg";
%
%% Only works for PNG output.
%outputformat := "png";
%outputformatoptions := "format=rgba antialias=fast";
%hppp := 0.5;
%vppp := 0.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Global variables                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
color tyblue; tyblue=(102/256,204/256,1); % 天依蓝
color gray; gray=0.6white;

beginfig(0);
fill fullcircle scaled 100 withcolor red;
endfig;

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
  % draw bbox currentpicture;
endfig;

beginfig(7);
    color OrangeRed;
    color Cerulean;
    OrangeRed = (236/256,13/256,88/256);
    Cerulean = (19/256,163/256,229/256);
    pair A,B,C,D;
    A := (-2.5cm,0); B := (2.5cm,0); C := (0,-2.5cm); D := (0,2.5cm);
    numeric pi; pi := 3.1415926;
    numeric radian; radian := 180/pi;
    drawarrow A -- B;
    drawarrow C -- D;
    label.rt  (btex $x$ etex,B);
    label.top (btex $y$ etex,D);
    label.llft(btex $0$ etex,origin);
    label.urt (btex $\theta$ etex,origin) shifted (0.25cm,0cm) withcolor OrangeRed;
    label.bot (btex $r$ etex,origin) shifted (0.75cm,0cm) withcolor OrangeRed;
    label.urt (btex $r$ etex,origin) shifted (1.35cm,0.6cm) withcolor OrangeRed;
    label.rt  (btex $\theta=1$ radian etex,C) shifted (1.5cm,0.3cm);
    draw fullcircle scaled 3cm withcolor Cerulean;
    drawarrow (0,0) -- 2cm*dir 0 withcolor OrangeRed;
    drawarrow (0,0) -- 2cm*dir radian withcolor OrangeRed;
    draw 1.5cm * dir 0 {dir 90} ..
         1.5cm * dir radian {dir(90+radian)} withcolor OrangeRed;
    drawarrow 0.75cm * dir 0 {dir 90} ..
              0.75cm * dir radian {dir(90+radian)} withcolor OrangeRed;

endfig;

beginfig(8)
  z0 = origin; % short form for (0,0)
  z1 = (60,40); z2 = (40,90);
  z3 = (10,70); z4 = (30,50);
  pickup pencircle scaled 1mm;
  draw z0; draw z1; draw z2;
  draw z3; draw z4;
  pickup defaultpen;
  draw z0--z1--z2--z3--z4 withcolor blue;
  draw z0..z1..z2..z3..z4 withcolor red;
  draw z0..z1..z2..z3..z4..z0 withcolor green;
endfig;

beginfig(9)
  z0 = origin;
  z1 = (60,40); z2 = (40,90);
  z3 = (10,70); z4 = (30,50);
  pickup pencircle scaled 1mm;
  for a = 0 upto 4:
    draw z[a];
  endfor
  pickup defaultpen;
  draw
    for a = 0 upto 3:
      z[a]--
    endfor
    z4 withcolor blue;  % This is one statement that expands to `draw z0--z1--z2--z3--z4 withcolor blue;`
  draw
    for a = 0 upto 4:
      z[a]..
    endfor
    cycle withcolor red;
  draw
    for a = 0 upto 4:
      z[a]..
    endfor
    z0 withcolor green;
endfig;

beginfig(10)
  z0 = origin;
  z2 = (40mm, 0);
  z1 = 0.5(z0+z2);
  pickup pencircle scaled 1mm;
  draw z0; draw z1; draw z2;
  pickup defaultpen;
  draw z0..z1{dir -70}..z2 withcolor red;
  draw z0..z1{dir 0}..z2 withcolor green;
  draw z0..z1{dir 70}..{right}z2 withcolor blue;
endfig;

beginfig(11)
  z0 = origin;
  z3 = right*30mm; % same as (30mm, 0)
  x1 = 0.2[x0,x3]; % mediation 'on the way between'
  x2 = 0.8[x0,x3];
  y1 = y2 = 0.3x3;
  pickup pencircle scaled 1mm;
  for i = 0 upto 3:
    draw z[i];
  endfor
  pickup defaultpen;
  draw z0..z1.. tension 1 ..z2..z3;
  draw z0..z1.. tension 1.2 ..z2..z3 withcolor red;
  draw z0..z1.. tension 2 ..z2..z3 withcolor green;
  draw z0..z1.. tension 5 ..z2..z3 withcolor blue;
endfig;

% beginfig(12)
%   z0 = origin;
%   z1 = right*30mm;
%   z2 = z1 + up*20mm;
%   pickup pencircle scaled 1mm;
%   for i = 0 upto 2:
%     draw z[i];
%   endfor
%   pickup defaultpen;
%   path p, q, r;
%   p = z0--z1;
%   q = z1..z2;
%   r = p & q & cycle;
%   draw r;
%   dotlabel.bot("(0,0)", origin);
% endfig;

beginfig(13)
  for i=0 upto 100:
    fill unitsquare
      scaled ((100-i)*0.1mm)
      rotated 31i
      withcolor (0.01i)[red,blue];
  endfor
endfig;

beginfig(14)
  % A clock pane.
  z0 = up*28mm;
  z1 = up*29mm;
  z2 = up*30mm;
  z3 = up*25mm;
  draw origin;
  for i=60 step -1 until 1:
    if (i mod 5)=0:
      label(decimal(i/5), z3 rotated (360-6i));
      draw (z0--z2) rotated 6i;
    fi
    draw (z1--z2) rotated 6i;
  endfor
  draw fullcircle scaled 60mm;
  path h, m;
  h = origin--(z2 rotated 210 scaled 0.5);
  m = origin--(z2 rotated 240 scaled 0.7);
  drawarrow h;
  drawarrow m;
endfig;

% Pythagorean Tree.
beginfig(15)
  u:=1cm; branchrotation:=60;
  offset := 180-branchrotation;
  thinning := 0.7;
  shortening := 0.8;
  def drawit(expr p, linethickness) =
    draw p withpen pencircle scaled linethickness;
  enddef;
  vardef tree(expr A, B, n, size) =
    save C,D,thickness;
    pair C,D;
    thickness := size;
    C := shortening[B, A rotatedaround(B, offset+uniformdeviate(branchrotation))];
    D := shortening[B, A rotatedaround(B, -offset-uniformdeviate(branchrotation))];
    if n > 0:
      drawit(A--B, thickness);
      thickness := thinning*thickness;
      tree(B, C, n-1, thickness);
      tree(B, D, n-1, thickness);
    else:
      drawit(A--B, thickness);
      thickness := thinning*thickness;
      drawit(B--C, thickness);
      drawit(B--D, thickness);
    fi;
  enddef;
  tree((0,0), (0,u), 10, 2mm);
endfig;

beginfig(16)
  u:=2mm;
  z1 = up*10u; z2 = left*10u; z3 = down*10u; z4 = right*10u;
  def drawtick(expr p, offset, rotation) =
    draw p shifted (right*offset) rotated (rotation);
  enddef;
  draw z1--z3;
  draw z2--z4;
  path short, long;
  short = (0,-0.25u)--(0,0.25u);
  long = (0,-0.5u)--(0,0.5u);
  for i=0 step 90 until 270:
    for j=0 step u until 10u:
      if (j mod 5u)=0:
        drawtick(long, j, i);
      else:
        drawtick(short, j, i);
      fi
    endfor
  endfor
endfig;

beginfig(17)
  pair A,B,C; u:=6cm;
  A=u*dir(-30); B=u*dir(90); C=u*dir(210);

  % draw A withpen pencircle scaled 1mm;
  % dotlabel("A", A);
  % draw B withpen pencircle scaled 1mm;
  % dotlabel("B", B);
  % draw C withpen pencircle scaled 1mm;
  % dotlabel("C", C);

  transform T;
  A transformed T = 1/6[A,B];
  B transformed T = 1/6[B,C];
  C transformed T = 1/6[C,A];

  color yellow; yellow = (1,1,0);

  path p; p = A--B--C--cycle;
  for i=0 upto 60:
    draw p;
    fill p withcolor (0.2i)[1.2blue,tyblue];
    p := p transformed T;
  endfor
endfig;

beginfig(18)
  u := 3cm;
  pair p[];
  p[0]=(0,0); p1=(2u,3u); p2=(3u,2u);
  def drawpoint(expr z, c) =
    draw z withpen pencircle scaled 3 withcolor c;
  enddef;
  
  path q; q:=p0..p1..p2;
  for i=0 upto length(q):
    drawpoint(point i of q, black);
    p3 := precontrol i of q;
    p4 := postcontrol i of q;
    draw p3--p4 withcolor gray;
    drawpoint(p3, gray);
    drawpoint(p4, gray);
  endfor
  draw q;
endfig;

% Draw a Taichi.
beginfig(19)
  u := 3cm;
  % draw fullcircle scaled 2u withcolor gray;
  z0 = origin; z1 = up*u; z2 = right*u; z3 = down*u; z4 = left*u;
  path p,q;
  p := z1..z2..z3;
  q := p{left}..{right}z0{right}..{left}cycle;
  fill q withcolor black;
  draw p..z4..cycle;
  fill fullcircle scaled 0.15u shifted 0.5[z0,z1] withcolor black;
  fill fullcircle scaled 0.15u shifted 0.5[z0,z3] withcolor white;
endfig;

end

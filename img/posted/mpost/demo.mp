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
  u:=1cm;
  pair a,b; path p; pen mypen;
  a = (0,0); b = (3u,4u);
  p = a--b;
  mypen = pencircle scaled 1mm;
  pickup mypen;
  draw p;
endfig;

end

program TryingGraphics;
{$N+,E-}
uses CRT,GrafComp,Graf3d,graph;
type
  tsurf=array[-20..19,-20..19] of vector;
  psurf=^tsurf;
var
  {surface:array[-19..19,-19..18] of vector;}
  surface:psurf;
  i,j:integer;
  r:float;
  c,p:vector;
  s:sight;
  k,l,m,n:integer;

function tg(a:float):float;
begin
  tg:=sin(a)/cos(a);
end;

begin
  clrscr;
  new(surface);
  initvector(0,0,0,p);
  initvector(10,10,0,c);
  {readvector(c,'свои координаты');}
  setgraph;
  setcolor(green);
  setwritemode(0);
  initsight(p,c,s,'noname');
  s.dfi:=pi/60;
  s.dteta:=pi/60;
  s.dhi:=pi/60;
  s.djota:=pi/60;         {center}
  setsight(s);
  r:=0.1;
  k:=15;
  while true do begin
    for i:=-20 to 19 do
      for j:=-20 to 19 do begin
        surface^[i,j][1]:=i*0.2*Pi;
        surface^[i,j][2]:=j*0.2*Pi;
        surface^[i,j][3]:=
           {sin( sqrt( sqr(surface^[i,j][1]) + sqr(surface^[i,j][2]) ) - r );{}
           exp(sin(surface^[i,j][1] + r) + cos(surface^[i,j][2] + r));{}
        surface^[i,j][4]:=1;
      end;
    for i:=-20 to 19 do
      for j:=-20 to 19 do
        VectorxMatrix(Egen,surface^[i,j],surface^[i,j],true);
{──────────────────────────────────────────────────────────────────────────────}
    for i:=-20 to 19 do
      for j:=-20 to 18 do
        line( gx(surface^[i,j  ][1]*k), gy(surface^[i,j  ][3]*k),
              gx(surface^[i,j+1][1]*k), gy(surface^[i,j+1][3]*k)  );
    for i:=-20 to 18 do
      for j:=-20 to 19 do
        line(gx(surface^[i  ,j][1]*k), gy(surface^[i  ,j][3]*k),
             gx(surface^[i+1,j][1]*k), gy(surface^[i+1,j][3]*k));

    delay(500);
    ClearDevice;{}
    if keypressed and (readkey=#0) then with s do begin
    case readkey of
      #59:break;

      #72:turnaround(-dfi,0);
      #80:turnaround(dfi,0);
      #75:turnaround(0,-dteta);
      #77:turnaround(0,dteta);

      #71:directlook(-dhi,0);
      #79:directlook(dhi,0);
      #83:directlook(0,-djota);
      #81:directlook(0,djota);
    end;
    while keypressed do readkey;
    end;
    r:=r+0.2;
  end;
  closegraph;
  dispose(surface);
end.
program TryingGraphics;
{$N+,E-}
uses CRT,GrafComp,Graf3d,graph;
const pr=19;
type
  tsurf=array[-20..19,-20..19] of vector;
  tcolors=array[-20..18,-20..18] of integer;
  psurf=^tsurf;
  pcolors=^tcolors;

function sign(x:float):integer;
begin
  if x=0 then sign:=0
  else if x<0 then sign:=-1
  else sign:=1;
end;

var
  {surface:array[-19..19,-19..18] of vector;}
  surface:psurf;
  colors:pcolors;
  i,j:integer;
  page:integer;
  hi,jota:float;
  r:float;
  c,p:vector;
  s:sight;
  k,l,m,n,cvet:integer;
  beta:double;
  v1,v2,v3,v4,light:vector;
  piece:array[1..5] of pointtype;

begin
  clrscr;
  new(surface);
  new(colors);
  initvector(0,0,0,p);     {объект}
  initvector(10,10,10,c);    {глаз}
  initvector(0,0,10,light);
{  readvector(light,'свет:');{}
  startg(3);
  for i:=1 to 255 do
    setrgbpalette(i,i,0,0);
  setcolor(green);
  setwritemode(0);
  initsight(c,p,s,'noname');
  s.dfi:=pi/60;
  s.dteta:=pi/60;
  s.dhi:=pi/60;
  s.djota:=pi/60;         {center}
  setsight(s);
  r:=0.1;
  k:=20;
  while true do begin
    {setactivepage(page);{}
  {вычисление поверхности}
    for i:=-20 to 19 do
      for j:=-20 to 19 do begin
        surface^[i,j][1]:=i*0.05*Pi;
        surface^[i,j][2]:=j*0.05*Pi;
        surface^[i,j][3]:=
          exp( sqrt( sqr(surface^[i,j][1]) + sqr(surface^[i,j][2]))/2 );{}
           {2*sin( sqrt( sqr(surface^[i,j][1]) + sqr(surface^[i,j][2]) ) - r );{}
           {0.5*exp(sin(surface^[i,j][1] + r) + cos(surface^[i,j][2] + r));{}
        surface^[i,j][4]:=1;
      end;
  {вычисление цветов}
    for i:=-20 to 18 do
      for j:=-20 to 18 do begin
        VectorSubtr(surface^[i,j+1],surface^[i,j],v1);
        VectorSubtr(surface^[i+1,j],surface^[i,j],v2);
        VectorProduct(v2,v1,v3);
        VectorSubtr(surface^[i+1,j],surface^[i+1,j+1],v1);
        VectorSubtr(surface^[i,j+1],surface^[i+1,j+1],v2);
        VectorProduct(v2,v1,v4);
        VectorSum(v3,v4,v3);
        MultiVector(0.5,v3,v3);
        beta:=(  VectorScalProduct(v3,light)/
                  ( VectorLength(v3)*VectorLength(light) )  ) + 1 ;
        colors^[i,j]:=round( beta/2*255 );
      end;
  {перевод в видовую систему}
    for i:=-20 to 19 do
      for j:=-20 to 19 do
        VectorxMatrix(Egen,surface^[i,j],surface^[i,j],true);
  {прорисовка}
    for i:=-20 to 18 do
      for j:=-20 to 18 do begin
        setcolor(colors^[i,j]);
        setfillstyle(1,colors^[i,j]);{}
        piece[1].x:=gx(surface^[i  ,j  ][1]*k); piece[1].y:=gy(surface^[i  ,j  ][3]*k);
        piece[2].x:=gx(surface^[i  ,j+1][1]*k); piece[2].y:=gy(surface^[i  ,j+1][3]*k);
        piece[3].x:=gx(surface^[i+1,j+1][1]*k); piece[3].y:=gy(surface^[i+1,j+1][3]*k);
        piece[4].x:=gx(surface^[i+1,j  ][1]*k); piece[4].y:=gy(surface^[i+1,j  ][3]*k);
        piece[5]:=piece[1];
        fillpoly(5,piece);{}
        {delay(50);{}
        {bar(gx(i*pr),    gy(j*pr),
            gx(i*pr+pr), gy(j*pr+pr) );{}
        line( gx(surface^[i,j  ][1]*k), gy(surface^[i,j  ][3]*k),
              gx(surface^[i,j+1][1]*k), gy(surface^[i,j+1][3]*k)  );{}
      end;
    {sound(800);
    delay(500);
    nosound; {}
    delay(1000);{}

    if keypressed and (readkey=#0) then with s do begin
    case readkey of
      #59:break; {конец}
      #60:repeat until keypressed; {пауза}

      #63:begin
            genrotmatrix(p,0,0,0.3,Rgen);
            VectorxMatrix(Rgen,light,light,true);
         end;
      #64:begin
            genrotmatrix(p,0,0,-0.3,Rgen);
            VectorxMatrix(Rgen,light,light,true);
         end;
      #65:begin
            defineangles(light,hi,jota);
            genrotmatrix(p,hpi,jota-hpi,0.3,Rgen);
            VectorxMatrix(Rgen,light,light,true);
         end;
      #66:begin
            defineangles(light,hi,jota);
            genrotmatrix(p,hpi,jota-hpi,-0.3,Rgen);
            VectorxMatrix(Rgen,light,light,true);
         end;

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
    cleardevice;{}
    r:=r+0.1;
    {setvisualpage(page);
    page:=1-page;{}
  end;
  closegraph;
  dispose(surface);
  dispose(colors);
end.
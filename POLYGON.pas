program polygon;
uses crt,graph,graf3d,grafcomp;
const
  anglenum=10;
  radius=200;
var
  polyg :array[1..anglenum] of vector;
  polydr:array[1..anglenum+1] of pointtype;
  i:integer;

begin
  initvector(radius,0,0,polyg[1]);
  genrotmatrix(nulvector,pi/2,pi/2,2*pi/anglenum,rgen);
  for i:=1 to anglenum-1 do
    VectorxMatrix(rgen,polyg[i],polyg[i+1],true);

  genrotmatrix(nulvector,pi/3,pi/5,0.1,rgen);

  setwritemode(1);
  setcolor(255);

  while not keypressed do begin

    for i:=1 to anglenum do begin
      polydr[i].x:=gx(polyg[i][1]);
      polydr[i].y:=gy(polyg[i][3]);
    end;
    polydr[anglenum+1]:=polydr[1];

    drawpoly(anglenum+1,polydr);
    delay(2000);
    cleardevice;

    for i:=1 to anglenum do
      VectorxMatrix(rgen,polyg[i],polyg[i],true);

  end;

  closegraph;

end.


program shar;
{$N+}
uses graph,graf3d,grafcomp,crt;
const
  light:vector=(-10,-10,-10,1);
  radius=300;
  anglenum=300;
var
  circle,circonst:array[1..anglenum] of vector;
  points:array[1..anglenum+1] of pointtype;
  i,j,pr:integer;
  p,c:vector;
  s:sight;
  v:vector;

begin
  setwritemode(copyput);
  GenRotMatrix(nulvector,pi/2,0,2*pi/anglenum,Rgen);
  initvector(0,0,radius,circonst[1]);
  for i:=2 to anglenum do
    VectorxMatrix(Rgen,circonst[i-1],circonst[i],true);
  circle:=circonst;
  GenRotMatrix(nulvector,pi/2,3*pi/2,pi/1000/2,Rgen);
  pr:=0;
  while (not keypressed)and(pr<1000) do begin
    for i:=1 to anglenum do begin
      points[i].x:=gx(circle[i][1]);
      points[i].y:=gy(circle[i][2]);
    end;
    points[anglenum+1]:=points[1];

    for i:=1 to anglenum-1 do begin
      {vectorsubtr(circle[i],circle[i+1],v);{}
      j:=round( frac(VectorsAngle(circle[i],light)/pi/0.5)*39+7  );
      setcolor(j+1);
      line(points[i].x,points[i].y,points[i+1].x,points[i+1].y);
    end;
    {vectorsubtr(circle[anglenum],circle[1],v);{}
    setcolor(round(VectorsAngle(circle[anglenum],light)/pi*39));
    line(points[anglenum].x,points[anglenum].y,points[anglenum+1].x,points[anglenum+1].y);

    for i:=1 to anglenum do
      VectorxMatrix(Rgen,circle[i],circle[i],true);
    inc(pr);
  end;
  readln;


  closegraph;
end.
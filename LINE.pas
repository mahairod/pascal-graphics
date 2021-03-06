program frftf;
uses grafcomp,graf3D,graph,crt;

var
  i,j:integer;
  a,b,c:vector;
  center:vector;
  rgen:matrix;
  br:boolean;
  s:sight;
begin
  Setgraph;

  a[1]:=-50;
  a[2]:=-50;
  a[3]:=-50;
  b[1]:=50;
  b[2]:=50;
  b[3]:=50;
  c[1]:=-50;
  c[2]:=150;
  c[3]:=150;
  initvector(10,5000,50,center);
  setcolor(green);
  SetWriteMode(1);
  Genrotmatrix(center,0.1,1.6,0.01,Rgen);
  repeat
      VectorXmatrix(rgen,a,a,true);  {вращение}
      VectorXmatrix(rgen,b,b,true);
      VectorXmatrix(rgen,c,c,true);
      line( gx(a[1]),gy(a[3]),gx(b[1]),gy(b[3]) );
      line( gx(c[1]),gy(c[3]),gx(b[1]),gy(b[3]) );
      line( gx(a[1]),gy(a[3]),gx(c[1]),gy(c[3]) );
      putpixel(gx(a[1]),gy(a[3]),yellow);
      putpixel(gx(b[1]),gy(b[3]),red);
      putpixel(gx(c[1]),gy(c[3]),blue);

      line( gx(a[1]),gy(a[3]),gx(b[1]),gy(b[3]) );
      line( gx(c[1]),gy(c[3]),gx(b[1]),gy(b[3]) );
      line( gx(a[1]),gy(a[3]),gx(c[1]),gy(c[3]) );
  until keypressed;
  closegraph;
end.
                                                                     
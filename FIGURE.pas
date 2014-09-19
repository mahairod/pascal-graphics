program figure;
  {$n+,e-}
uses crt,graph,graf3d,grafcomp;
type direction=(down,up,left,right);
const
  xc:integer=0;
  yc:integer=0;
  turnings=30;
var
  flatfig:array[0..200,1..2] of integer;
  spacefig:array[0..200] of vector;
  visfig:array[0..200] of vector;
  pnum:integer;
  x,y,ox,oy:integer;
  a,b:vector;
  i,j:integer;
  hi,jota:float;
  s:sight;
  c,p:vector;
  r1:matrix;

procedure choosepoint(d:direction;var x,y,ox,oy:integer);
begin
  setcolor(0);
  setfillstyle(1,0);
  pieslice(ox,oy,0,360,3);
  case d of
    up:y:=y-2;
    down:y:=y+2;
    left:x:=x-2;
    right:x:=x+2;
  end;
  ox:=x;
  oy:=y;
  setcolor(100);
  setfillstyle(1,100);
  pieslice(x,y,0,360,3);
end;

procedure addpoint(var x,y,ox,oy:integer);
const c=100;
var oldcol:byte;
begin
  flatfig[pnum,1]:=x-absXc;
  flatfig[pnum,2]:=-y+absYc;
  pnum:=pnum+1;
  {line(ox,oy,x,y);}
  oldcol:=getcolor;
  setcolor(c);
  setfillstyle(1,c);
  pieslice(x,y,0,360,3);
  delay(500);
  setfillstyle(1,0);
  setcolor(0);
  pieslice(x,y,0,360,3);
  setcolor(oldcol);
  putpixel(x,y,oldcol);
  ox:=x;
  oy:=y;
end;

procedure move(d:direction;var x,y,ox,oy:integer);
begin
  setcolor(getmaxcolor);
  line(ox,oy,x,y);
  case d of
    up:y:=y-2;
    down:y:=y+2;
    left:x:=x-2;
    right:x:=x+2;
  end;
  line(ox,oy,x,y);

end;


begin
  xc:=getmaxx div 2;
  yc:=getmaxy div 2;
  setwritemode(xorput);

  pnum:=0;
  ox:=xc;
  x:=xc;
  oy:=yc;
  y:=yc;
{---------строим каркас-------------------------------------------------------------}

  setcolor(100);
  setfillstyle(1,100);
  pieslice(x,y,0,360,3);
  repeat
    if readkey=#13 then begin
                     addpoint(x,y,ox,oy);
                     break;
                   end else
    case readkey of
      #59:break;{}

      #72:choosepoint(up,x,y,ox,oy);
      #80:choosepoint(down,x,y,ox,oy);
      #75:choosepoint(left,x,y,ox,oy);
      #77:choosepoint(right,x,y,ox,oy);

    end;
  until false;

  repeat
    if readkey=#13 then begin
                     addpoint(x,y,ox,oy);
                   end else
    case readkey of
      #59:break;{}

      #72:move(up,x,y,ox,oy);
      #80:move(down,x,y,ox,oy);
      #75:move(left,x,y,ox,oy);
      #77:move(right,x,y,ox,oy);

    end;
  until false;
  cleardevice;

{--------------------------------------------------------------------------}
  for i:=0 to pnum-1 do begin      {преобразование в 3д-коорд}
    spacefig[i][1]:=flatfig[i,1];
    spacefig[i][2]:=flatfig[i,2];
    spacefig[i][3]:=0;
    spacefig[i][4]:=1;
  end;



  vectorsubtr(spacefig[pnum-1],spacefig[0],a);
  defineangles(a,hi,jota);
  initvector(0,0,0,p);
  initvector(10,10,10,c);
  initsight(c,p,s,'');
  setsight(s);

  GenRotMatrix(spacefig[0],hi,jota,2*pi/turnings,Rgen);
  PrepareEMatrix(pi/4,pi/4,10,Egen);
  setcolor(37);
  setwritemode(0);
  while true do begin
    {spacefig:=spacefigst;{}
    cleardevice;{}
    genrotmatrix(spacefig[0], pi/4, 0, 0.02, r1);{}

    for i:=0 to pnum-1 do
      vectorXmatrix(r1,spacefig[i],spacefig[i],true);{}
    {vectorXmatrix(r1,a,a,true);{}
    vectorsubtr(spacefig[pnum-1],spacefig[0],a);{}
    MultiVector(0.5,a,b);

    defineangles(a,hi,jota);
    GenRotMatrix(spacefig[0],hi,jota,2*pi/turnings,Rgen);{}

    for j:=1 to turnings do begin
      for i:=0 to pnum-1 do begin
        vectorXmatrix(Rgen,spacefig[i],spacefig[i],true);
        vectorXmatrix(Egen,spacefig[i],visfig[i],true);
        flatfig[i,1]:=gx(visfig[i][1]);
        flatfig[i,2]:=gy(visfig[i][2]);
      end;
      for i:=0 to pnum-2 do begin
        line(flatfig[i,1],flatfig[i,2],flatfig[i+1,1],flatfig[i+1,2]);
      end;
    end;

    if keypressed and (readkey=#0) then begin
      case readkey of
        #59:break;

        #72:turnaround(-0.05,0);
        #80:turnaround(0.05,0);
        #75:turnaround(0,-0.05);
        #77:turnaround(0,0.05);
      end;
    end;
  end;
end.
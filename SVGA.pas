program ghfg;
uses crt,graph,graf3d,grafcomp;


var
  i,j:integer;
  s:string;
const
  size=25;

begin
  setcolor(125);
  str(getmaxx,s);
  outtextxy(120,120,s);
  str(getmaxy,s);
  outtextxy(220,120,s);
  setlinestyle(0,0,3);
  {readkey;}
  for i:=0 to 185 do begin
    setfillstyle(1,i);
    bar(i mod 31 * size,i div 31 * size,(i mod 31+1)  * size-1,(i div 31+1) * size-1);
  end;
  for i:=186 to 217 do begin
    setfillstyle(1,i);
    bar((i-186)*size,6*size,(i-185)*size-1,7*size-1);
  end;
  for i:=218 to 255 do begin
    setfillstyle(1,i);
    bar((i-218)*size,7*size,(i-217)*size-1,8*size-1);
  end;

  for i:=0 to 255 do begin
    setcolor(i);
    line(i*3,size*11,i*3,size*15);
  end;

  readkey;
  closegraph;
end.
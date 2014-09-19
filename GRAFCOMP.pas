unit GrafComp;
{$N+,E-}
interface
uses CRT,DOS;

type
  float=extended;
  vector=array[1..4] of float;
  matrix=array[1..4,1..4] of float;
  str10=string[10];

const
  Epi=pi;
  Hpi=pi/2;
  Tpi=pi*2;

var
  regs:registers;
  SourceM:^matrix;

function  ArcCos(a:float):float;
function  VectorLength(a:vector):float;
procedure VectorSum(a,b:vector;var v:vector);
procedure VectorSubtr(a,b:vector;var v:vector);
procedure MultiVector(a:float;b:vector;var v:vector);
function  VectorScalProduct(a,b:vector):float;
function  VectorsAngle(a,b:vector):float;
procedure VectorProj(a,b:vector;var v:vector);
procedure VectorProduct(a,b:vector;var v:vector);
procedure VectorxMatrix(const a:matrix;b:vector;var v:vector;size:boolean);
procedure MatrixSum(a,b:matrix;var m:matrix;size:boolean);
procedure MatrixProduct(a,b:matrix;var m:matrix;size:boolean);
procedure MatrixPrint(m:matrix;name:str10);
procedure TakeMatrix(var m:matrix;ready:boolean);


implementation

function ArcCos(a:float):float;
var
  t:float;
begin
  if a=0 then ArcCos:=Hpi else
  if a>0
     then ArcCos:=arctan(+sqrt (1/sqr(a)) -1)
     else ArcCos:=arctan(-sqrt (1/sqr(a)) -1)+Hpi;
end;

function VectorLength(a:vector):float;
begin
  VectorLength:=sqrt( sqr(a[1]) + sqr(a[2]) + sqr(a[3]) );
end;

procedure VectorSum(a,b:vector;var v:vector);
begin
  v[1]:=a[1]+b[1];
  v[2]:=a[2]+b[2];
  v[3]:=a[3]+b[3];
  v[4]:=1.0;
end;

procedure VectorSubtr(a,b:vector;var v:vector);
begin
  v[1]:=a[1]-b[1];
  v[2]:=a[2]-b[2];
  v[3]:=a[3]-b[3];
  v[4]:=1.0;
end;

procedure MultiVector(a:float;b:vector;var v:vector);
var
  i:integer;
begin
  for i:=1 to 3 do
    v[i]:=a*b[i];
  v[4]:=1.0;
end;

function VectorScalProduct(a,b:vector):float;
var
  i:integer;
  s:float;
begin
  s:=0.0;
  for i:=1 to 3 do
    s:=s+a[i]*b[i];
    VectorScalProduct:=s;
end;

function VectorsAngle(a,b:vector):float;
begin
  VectorsAngle:=arccos(
               VectorScalProduct(a,b)/
            ( VectorLength(a) * VectorLength(b) )  );
end;

procedure VectorProj(a,b:vector;var v:vector);
var
  t:float;
begin
  t:=VectorScalProduct(a,b)/sqr( VectorLength(b) );
  MultiVector(t,b,v);
end;

procedure VectorProduct(a,b:vector;var v:vector);
begin
  v[1]:=a[2]*b[3]-a[3]*b[2];
  v[2]:=a[3]*b[1]-a[1]*b[3];
  v[3]:=a[1]*b[2]-a[2]*b[1];
  v[4]:=1.0;
end;

procedure VectorxMatrix(const a:matrix;b:vector;var v:vector;size:boolean);
var
  i,j,n:integer;
  s:float;
begin
  if size
    then n:=4
    else n:=3;

  for i:=1 to n do begin
    s:=0.0;
    for j:=1 to n do
      s:=s+a[i,j]*b[j];
    v[i]:=s;
  end;
end;

procedure MatrixSum(a,b:matrix;var m:matrix;size:boolean);
var
  i,j,n:integer;
begin
  if size
    then n:=4
    else n:=3;

  for i:=1 to n do
    for j:=1 to n do
      m[i,j]:=a[i,j]+b[i,j];

  if not size
     then begin
       for i:=1 to 3 do begin
         m[i,4]:=0.0;
         m[4,i]:=0.0;
       end;
       m[4,4]:=1.0;
     end;
end;

procedure MatrixProduct(a,b:matrix;var m:matrix;size:boolean);
var
  i,j,k,n:integer;
  s:float;
begin
  if size
    then n:=4
    else n:=3;
  for i:=1 to n do
    for j:=1 to n do begin
      s:=0.0;
      for k:=1 to n do
        s:=s+a[i,k]*b[k,j];
      m[i,j]:=s;
    end;

  if not size
     then begin
       for i:=1 to 3 do begin
         m[i,4]:=0.0;
         m[4,i]:=0.0;
       end;
       m[4,4]:=1.0;
     end;
end;

procedure MatrixPrint(m:matrix;name:str10);
const
  s=9; {Ширина вывода}
var
  i,j,l,y:word;
begin
  y:=WhereY;
  gotoxy(1,y+1);
  write(name,' = ');
  l:=length(name)+4;
  gotoxy(l,y);
  write('┌');
  for i:=1 to 4 do begin
    gotoxy(l,y+i);
    write('│');
    for j:=1 to 4 do
      write(m[i,j]:s:4);
    write('│');
  end;
  gotoxy(l,y+5);
  write('└');
  gotoxy(l+s*4+1,y);
  write('┐');
  gotoxy(l+s*4+1,y+5);
  writeln('┘');
end;

procedure TakeMatrix(var m:matrix;ready:boolean);
const
  current=121;
  other=15;
  str1='1. Чтение из файла';
  str2='2. Ручное заполнение';
var
  y,i,j,a,b,c:word;
  s:string;
  choice:integer;
  r:float;
  f:file;
begin
  if ready then begin
             move(SourceM^,m,sizeof(float)*16);
             exit;
           end;

  y:=whereY;
  writeln;
  regs.ax:=$100;
  regs.cx:=$2607;
  intr($10,regs);
  writeln('Инициализация матрицы. Способы:');
  choice:=1;
  repeat
    if choice=1 then textattr:=current else textattr:=other;
    writeln(str1);
    if choice=2 then textattr:=current else textattr:=other;
    writeln(str2);
    repeat
    until keypressed and (readkey=#0);
    case readkey of
      #72,#80:choice:=2-choice;
          #13:break;
    end;
    gotoxy(1,y+2);
  until false;
  clrscr;

  regs.ax:=$100;
  regs.cx:=$506;
  intr($10,regs);
  case choice of
    1:begin
      write('Имя файла и номер записи:');
      readln(s,i);
      assign(f,s);
      reset(f,sizeof(float)*16 );
      seek(f,i-1);
      blockread(f,m,1);
      close(f);
     end;
    2:begin
      for i:=1 to 4 do begin
        gotoxy(1,i);
        write('│');
        gotoxy(50,i);
        write('│');
      end;
      for i:=0 to 3 do
        for j:=0 to 3 do begin
          gotoxy(i*12+1,j);
          read(s);
          if s[1]<>'!' then s:= '!    ' + s;
          a:=pos('/',s);
          if a=0 then begin
                   a:=length(s)+1;
                   s:=s+'/1';
                 end;
          val( copy(s,6,a-6), b, y );
          val( copy(s,a+1,length(s)-a), c, y );
          r:=b/c;
          if copy(s,2,3)='sin' then m[i,j]:=sin(r*Pi/180);
          if copy(s,2,3)='cos' then m[i,j]:=cos(r*Pi/180);
          if copy(s,2,3)='sqr' then m[i,j]:=sqrt(r);
          if copy(s,2,3)='   ' then m[i,j]:=r;
          if copy(s,2,3)='tan' then m[i,j]:=sin(r*Pi/180)/cos(r*Pi/180);
          if copy(s,2,3)='squ' then m[i,j]:=sqr(r);
          if copy(s,2,3)='cub' then m[i,j]:=sqr(r)*r;
        end;
      end;
  end;
end;

end.
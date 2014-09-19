unit Graf3d;
{$N+,E-,S-}
interface
uses GrafComp,Graph;

var
  center,point,eye:vector;
  fi,teta,ro:float;
  movector:vector;
  CMat,RMat,Rgen,EMat,TMat,Egen:matrix;
  dfi,dteta,dro:float;
  dhi,djota:float;

var
  absXc,absYc:word;

type
  pLnInfo=^LnInfo;
  LnInfo=record
    p1,p2,
    tp1,tp2:vector;
    vis:boolean;
    NextLn:pLnInfo;
  end;

  sight=record
    name:string;
    center,point,eye:vector;
    fi,teta,ro:float;
    dfi,dteta,dro:float;
    dhi,djota:float;
    movector:vector;
    EMat,TMat,Egen:matrix;
  end;

  RGBtype=(r,g,b);
  tpalette=array[0..255,r..b] of byte;

const
   MinimalDistance=5;
   NulVector:vector = (0,0,0,1);
   OneMatrix:matrix= ( (1, 0, 0, 0),
                       (0, 1, 0, 0),
                       (0, 0, 1, 0),
                       (0, 0, 0, 1) );

   palette16:tpalette=(
             {1} (0,0, 2),(0,0, 4),(0,0, 6),(0,0, 8),(0,0,10),(0,0,12),(0,0,14),(0,0,16),(0,0,18),(0,0,20),
       {blue}{11}(0,0,22),(0,0,24),(0,0,26),(0,0,28),(0,0,30),(0,0,32),(0,0,34),(0,0,36),(0,0,38),(0,0,40),
             {21}(0,0,42),(0,0,44),(0,0,46),(0,0,48),(0,0,50),(0,0,52),(0,0,54),(0,0,56),(0,0,58),(0,0,60),
             {31}   (0,0,63),(7,7,63),(14,14,63),(21,21,63),(28,28,63),(35,35,63),(42,42,63),(49,49,63),(56,56,63),{39}

                 (0, 2,0),(0, 4,0),(0, 6,0),(0, 8,0),(0,10,0),(0,12,0),(0,14,0),(0,16,0),(0,18,0),(0,20,0),
       {green}   (0,22,0),(0,24,0),(0,26,0),(0,28,0),(0,30,0),(0,32,0),(0,34,0),(0,36,0),(0,38,0),(0,40,0),
                 (0,42,0),(0,44,0),(0,46,0),(0,48,0),(0,50,0),(0,52,0),(0,54,0),(0,56,0),(0,58,0),(0,60,0),
                    (0,63,0),(7,63,7),(14,63,14),(21,63,21),(28,63,28),(35,63,35),(42,63,42),(49,63,49),(56,63,56),

                 ( 2,0,0),( 4,0,0),( 6,0,0),( 8,0,0),(10,0,0),(12,0,0),(14,0,0),(16,0,0),(18,0,0),(20,0,0),
       {red}     (22,0,0),(24,0,0),(26,0,0),(28,0,0),(30,0,0),(32,0,0),(34,0,0),(36,0,0),(38,0,0),(40,0,0),
                 (42,0,0),(44,0,0),(46,0,0),(48,0,0),(50,0,0),(52,0,0),(54,0,0),(56,0,0),(58,0,0),(60,0,0),
                    (63,0,0),(63,7,7),(63,14,14),(63,21,21),(63,28,28),(63,35,35),(63,42,42),(63,49,49),(63,56,56),

                 (0, 2, 2),(0, 4, 4),(0, 6, 6),(0, 8, 8),(0,10,10),(0,12,12),(0,14,14),(0,16,16),(0,18,18),(0,20,20),
       {GB}      (0,22,22),(0,24,24),(0,26,26),(0,28,28),(0,30,30),(0,32,32),(0,34,34),(0,36,36),(0,38,38),(0,40,40),
                 (0,42,42),(0,44,44),(0,46,46),(0,48,48),(0,50,50),(0,52,52),(0,54,54),(0,56,56),(0,58,58),(0,60,60),
                    (0,63,63),(12,63,63),(25,63,63),(37,63,63),(50,63,63),

                 ( 2, 2,0),( 4, 4,0),( 6, 6,0),( 8, 8,0),(10,10,0),(12,12,0),(14,14,0),(16,16,0),(18,18,0),(20,20,0),
       {RG}      (22,22,0),(24,24,0),(26,26,0),(28,28,0),(30,30,0),(32,32,0),(34,34,0),(36,36,0),(38,38,0),(40,40,0),
                 (42,42,0),(44,44,0),(46,46,0),(48,48,0),(50,50,0),(52,52,0),(54,54,0),(56,56,0),(58,58,0),(60,60,0),
                    (63,63,0),(63,63,12),(63,63,25),(63,63,37),(63,63,50),

                 ( 2,0, 2),( 4,0, 4),( 6,0, 6),( 8,0, 8),(10,0,10),(12,0,12),(14,0,14),(16,0,16),(18,0,18),(20,0,20),
       {RB}      (22,0,22),(24,0,24),(26,0,26),(28,0,28),(30,0,30),(32,0,32),(34,0,34),(36,0,36),(38,0,38),(40,0,40),
                 (42,0,42),(44,0,44),(46,0,46),(48,0,48),(50,0,50),(52,0,52),(54,0,54),(56,0,56),(58,0,58),(60,0,60),
                    (63,0,63),(63,12,63),(63,25,63),(63,37,63),(63,50,63),

                    ( 0, 0, 0),
                 ( 2, 2, 2),( 4, 4, 4),( 6, 6, 6),( 8, 8, 8),(10,10,10),(12,12,12),(14,14,14),(16,16,16),(18,18,18),(20,20,20),
                 (22,22,22),(24,24,24),(26,26,26),(28,28,28),(30,30,30),(32,32,32),(34,34,34),(36,36,36),(38,38,38),(40,40,40),
                 (42,42,42),(44,44,44),(46,46,46),(48,48,48),(50,50,50),(52,52,52),(54,54,54),(56,56,56),(58,58,58),(60,60,60),
                    (63,63,63),

                 (31,31,31),(31,31,31)


                         );


procedure PrepareRzMatrix(a:float;var m:matrix);
procedure PrepareRyMatrix(a:float;var m:matrix);
procedure PrepareInvMatrix(m:matrix;var n:matrix);
procedure FillTMatrix(const v:vector;var m:matrix);
procedure DefineAngles(const v:vector;var fi,teta:float);
procedure GenRotMatrix(c:vector;hi,jota,alfa:float;var Rgen:matrix);
procedure PrepareEMatrix(fi,teta,ro:float;var m:matrix);
procedure InitVector(const a,b,c:float;var v:vector);
procedure ReadVector(var v:vector;const s:string);
procedure InitSight(const c,p:vector;var D:sight;s:string);
procedure SetSight(const D:sight);
procedure Visible(var l:LnInfo);
procedure SetGraph(gm:integer);
function gx(x:float):longint;
function gy(y:float):longint;
procedure TurnAround(const dfi,dteta:float);
procedure DirectLook(const dhi,dteta:float);
Procedure SetRGBArray(Index,Count:Integer;var RGB);
procedure startg(mode:integer);


implementation


procedure PrepareRzMatrix(a:float;var m:matrix);
begin
  m:=OneMatrix;
  m[1,1]:=cos(a);
  m[2,2]:=m[1,1];
  m[2,1]:=sin(a);
  m[1,2]:=-m[2,1];
end;   {PrepareRzMatrix}

procedure PrepareRyMatrix(a:float;var m:matrix);
begin
  m:=OneMatrix;
  m[1,1]:=cos(a);
  m[3,3]:=m[1,1];
  m[1,3]:=sin(a);
  m[3,1]:=-m[1,3];
end;    {PrepareRyMatrix}

procedure PrepareInvMatrix(m:matrix;var n:matrix);
begin
  n:=m;
  n[1,2]:=-m[1,2];
  n[1,3]:=-m[1,3];
  n[2,3]:=-m[2,3];
  n[2,1]:=-m[2,1];
  n[3,1]:=-m[3,1];
  n[3,2]:=-m[3,2];
end;    {PrepareInvMatrix}


procedure FillTMatrix(const v:vector;var m:matrix);
var i:word;
begin
  m:=OneMatrix;
  for i:=1 to 3 do
    m[i,4]:=v[i];
end;    {FillTMatrix}

procedure DefineAngles(const v:vector;var fi,teta:float);
begin
  fi:=arccos(v[3]/VectorLength(v));
  if v[1]<>0
    then if v[1]>0
           then teta:=arctan(v[2]/v[1])
           else teta:=arctan(v[2]/v[1])+Epi
    else if v[2]>=0
           then teta:=Hpi
           else teta:=3*Hpi;
end;    {DefineAngles}

procedure GenRotMatrix(c:vector;hi,jota,alfa:float;var Rgen:matrix);
var
  Temp,InvRy,InvRz:matrix;
begin
  PrepareRzMatrix(jota,Rgen);
  PrepareRyMatrix(hi,Temp);
  PrepareInvMatrix(Rgen,InvRz);
  PrepareInvMatrix(Temp,InvRy);
  MatrixProduct(Rgen,Temp,Rgen,false);
  PrepareRzMatrix(alfa,Temp);
  MatrixProduct(Rgen,Temp,Rgen,false);
  MatrixProduct(Rgen,InvRy,Rgen,false);
  MatrixProduct(Rgen,InvRz,Rgen,false);
  FillTMatrix(c,Temp);
  MatrixProduct(Temp,Rgen,Rgen,true);
  VectorSubtr(NulVector,c,c);
  FillTMatrix(c,Temp);
  MatrixProduct(Rgen,Temp,Rgen,true);
end;      {GenRotMatrix}

procedure PrepareEMatrix(fi,teta,ro:float;var m:matrix);
var
  sf,cf,st,ct:float;
begin
  m:=OneMatrix;

  sf:=sin(fi);
  cf:=cos(fi);
  st:=sin(teta);
  ct:=cos(teta);

  m[3,4]:=ro;
  m[1,1]:=-st;
  m[1,2]:=ct;
  m[2,1]:=-cf*ct;
  m[2,2]:=-cf*st;
  m[2,3]:=sf;
  m[3,1]:=-sf*ct;
  m[3,2]:=-sf*st;
  m[3,3]:=-cf;
end;      {PrepareEMatrix}

procedure InitVector(const a,b,c:float;var v:vector);
begin
  v[1]:=a;
  v[2]:=b;
  v[3]:=c;
  v[4]:=1;
end;      {InitVector}

procedure ReadVector(var v:vector;const s:string);
begin
  write('¢®€ ¢¥ªâ®à  - '+s+':');
  readln(v[1],v[2],v[3]);
  v[4]:=1;
end;

procedure InitSight(const c,p:vector;var D:sight;s:string);
var
  t:vector;
begin
with D do begin
  point:=p;
  center:=c;
  name:=s;
  VectorSubtr(center,point,eye);
  DefineAngles(eye,fi,teta);
  ro:=VectorLength(eye);
  if ro<MinimalDistance then begin
                          writeln('«šèª®¬ ¡«š§ª® ª point! /Too little distance from point!');
                          readln;
                          halt;
                        end;
  PrepareEMatrix(fi,teta,ro,EMat);
  VectorSubtr(NulVector,point,t);
  FillTMatrix(t,TMat);
  MatrixProduct(EMat,TMat,Egen,true);
  dfi:=0;     dhi:=0;
  dteta:=0;   djota:=0;
  dro:=0;
  movector:=NulVector;
end;
end;      {InitSight}

procedure SetSight(const D:sight);
var
  t:vector;
begin
  center:=d.center;
  point:=d.point;
  eye:=d.eye;
  fi:=d.fi;
  teta:=d.teta;
  ro:=d.ro;
  movector:=d.movector;
  EMat:=d.EMat;
  TMat:=d.TMat;
  Egen:=d.Egen;
  dfi:=d.dfi;
  dteta:=d.dteta;
  dhi:=d.dhi;
  djota:=d.djota;
  dro:=d.dro;
end;       {SetSight}


{ÍÍÍÍÍÍÍÍÍÍÍÍÍvisibleÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ}
procedure Visible(var l:LnInfo);
var
  fi,teta,t:float;

procedure XXX(arg:word);
var
  s,b,k,tga:float;
  cross:vector;
  paral:boolean;

procedure Cut(const p1:vector;var p2:vector;arg:word;k:float);
label m1;
var x:float;
begin
  if paral then begin
                  p2[3]:=k*abs(p2[arg]);
                  exit;
                end;
  if k=tga then goto m1;
  x:=b/(k-tga);
  if p1[arg] > p2[arg]
    then begin
      if (x>p1[arg]) or (x<p2[arg]) then goto m1;  end
    else
      if (x<p1[arg]) or (x>p2[arg]) then goto m1;
  p2[arg]:=x;
  if p2[3]>=0 then exit;

       m1:
  k:=-k;
  p2[arg]:=b*(k-tga);
  p2[3]:=k*p2[arg];
  if p2[3]<0 then begin
                    writeln('!èš¡ª  ®âá¥ç¥­šï «š­šš (pr.Visible/XXX/Cut)');
                    readln;
                    halt;
                  end;
end;   {Cut}


begin     {XXX}
with l do begin
   if k*abs(tp1[arg]) > tp1[3] then tp1[4]:=0 else tp1[4]:=1;
   if k*abs(tp2[arg]) > tp2[3] then tp2[4]:=0 else tp2[4]:=1;
   s:=tp1[4]+tp2[4];
{1}if s=2 then vis:=true
          else begin
   paral:=tp1[arg]=tp2[arg];
   if not paral then begin
                  tga:=(tp2[3]-tp1[3])/(tp2[arg]-tp1[arg]);
                  b:=tp1[3]-tga*tp1[arg];
                end;
{2}if s=1 then begin
            vis:=true;
            if tp2[4]=0 then Cut(tp1,tp2,arg,k)
               		else Cut(tp2,tp1,arg,k)
            end else
{3}if ( (tp1[arg]>0) and (tp2[arg]<0) or (tp1[arg]<0) and (tp2[arg]>0) )
      and (b>0)
     then begin
       vis:=true;
       cross[3]:=b;
       cross[arg]:=0;
       Cut(cross,tp1,arg,k);
       Cut(cross,tp2,arg,k);
     end
{4}else vis:=false;

  end;
  tp1[4]:=1;
  tp2[4]:=1;

end;
end;  {XXX}


begin    {Visible}
with l do begin
  VectorSubtr(p2,p1,tp1);
  DefineAngles(tp1,fi,teta);
  tp1:=p1;
  tp2:=p2;
  xxx(1);
  if not vis then exit;
  if (teta<>Hpi) and (teta<>3*Hpi)
    then begin
      t:=sin(fi)/cos(fi);
      tp1[2]:=p1[2] + (tp1[1]-p1[1])*t;
      tp2[2]:=p2[2] + (tp2[1]-p2[1])*t;
    end
    else if fi<>hpi
      then begin
        t:=sin(fi)/cos(fi);
        tp1[2]:=p1[2] + (tp1[3]-p1[3])*t;
        tp2[2]:=p2[2] + (tp2[3]-p2[3])*t;
      end;
  xxx(2);
  if not vis then exit;
  if (teta<>0) and (teta<>Epi)
    then begin
      t:=cos(teta)/sin(teta);
      tp1[1]:=p1[1] + (tp1[2]-p1[2])*t;
      tp2[1]:=p2[1] + (tp2[2]-p2[2])*t;
    end
    else if fi<>hpi
      then begin
        t:=sin(fi)/cos(fi);
        tp1[1]:=p1[1] + (tp1[3]-p1[3])*t;
        tp2[1]:=p2[1] + (tp2[3]-p2[3])*t;
      end;
end;
end;    {Visible}

{ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ}

procedure SetGraph(gm:integer);
var
  gd,error:integer;
begin
  gd:=installuserdriver('svga',nil);
  {svga: 1 1024;2 640;3 640;4 800;5 1024}
  initgraph(gd,gm,'');

  {Gd:=InstallUserDriver('SVGA256',nil);
  Gm:=3;}
  error:=graphresult;
  if error<>0 then begin
                      Writeln('¥â £à äšªš1! / No graphics!');
                      writeln(grapherrormsg(error));
                      readln;
                      halt;
                    end;
  InitGraph(GD,GM,'');
  error:=graphresult;
  if error<>0 then begin
                      Writeln('¥â £à äšªš 2! / No graphics 2!');
                      writeln(grapherrormsg(error));
                      readln;
                      halt;
                    end;
end;     {SetGraph}

function gx(x:float):longint;
begin
  gx:=absXc+round(x);
end;

function gy(y:float):longint;
begin
  gy:=absYc-round(0.7*y);
end;

procedure TurnAround(const dfi,dteta:float);
begin
  fi:=fi+dfi;
  teta:=teta+dteta;
  if fi>=tpi then fi:=fi-tpi else
  if fi<0 then fi:=fi+tpi;
  if fi>epi then fi:=fi-epi;
  if teta>=tpi then teta:=teta-tpi else
  if teta<0 then teta:=teta+tpi;
  eye[3]:=ro*sin(fi);
  eye[1]:=eye[3]*cos(teta);
  eye[2]:=eye[3]*sin(teta);
  eye[3]:=ro*cos(fi);
  VectorSum(point,eye,center);
  PrepareEMatrix(fi,teta,ro,EMat);
  MatrixProduct(EMat,TMat,Egen,true);
end;

procedure DirectLook(const dhi,dteta:float);
var
  t:vector;
begin
  fi:=fi+dhi;
  teta:=teta+djota;
  if fi>=tpi then fi:=fi-tpi else
  if fi<0 then fi:=fi+tpi;
  if fi>epi then fi:=fi-epi;
  if teta>=tpi then teta:=teta-tpi else
  if teta<0 then teta:=teta+tpi;
  eye[3]:=ro*sin(fi);
  eye[1]:=eye[3]*cos(teta);
  eye[2]:=eye[3]*sin(teta);
  eye[3]:=ro*cos(fi);
  VectorSubtr(center,eye,point);
  PrepareEMatrix(fi,teta,ro,EMat);
  VectorSubtr(NulVector,point,t);
  FillTMatrix(t,Tmat);
  MatrixProduct(EMat,TMat,Egen,true);
end;


Procedure SetRGBArray(Index,Count:Integer;var RGB);assembler;
asm
 LES DX,RGB
 MOV BX,Index
 MOV CX,Count
 MOV AX,1012H
 INT 10H
end;


procedure Palette16p;
var i:integer;
begin
  for i:=0 to 31 do begin
    setrgbpalette(i, 0,0,i*2);
    setrgbpalette(32+i, 0,i*2,0);
    setrgbpalette(64+i, i*2,0,0);

    setrgbpalette(96+i, 0,i*2,i*2);
    setrgbpalette(128+i, i*2,i*2,0);
    setrgbpalette(160+i, i*2,0,i*2);

    setrgbpalette(192+i, i*2,i*2,i*2);
  end;
end;

procedure startg(mode:integer);
begin
  setgraph(mode);
  absXc:=getmaxx div 2;
  absYc:=getmaxY div 2;
  {palette16p;}
  setrgbarray(0,256,palette16);

end;

begin
  startg(4);
end.
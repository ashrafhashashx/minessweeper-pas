unit main;
{$APPTYPE CONSOLE}
Interface
Implementation

type playerstate=(loser,winner,notyet);
var
 b(*when b=true that means player has lost*)
 :boolean;
 key:char;
 i,j,
 ii(*number of lines*),
 jj(*number of columns*),
 inow(*i of the pointed blank*),
 jnow(*j of the pointed blank*),
 mines(*number of mines*)
 :byte;
 map(*mines map*),
 clicked(*map for clicked blanks*)
 :array[1..60,1..60]of boolean;
 board(*contains the blanks values must be shown to user*)
 :array[1..60,1..60]of char;

procedure writeit; var i1,j1:byte; begin
 clrscr;
 write(char(201));
 for j1:=1 to jj do write(char(205),char(205));
 writeln(char(187));
 for i1:=1 to ii do begin
  write(char(186));
  for j1:=1 to jj do
   if (i1=inow) and (j1=jnow) then write(char(178),' ') else
    if board[i1,j1]='0' then write('. ') else
     write(board[i1,j1],' ');
  writeln(char(186));
  end;
 write(char(200));
 for j1:=1 to jj do write(char(205),char(205));
 writeln(char(188));
 end;

function player:playerstate; var i2,j2,u:byte; ch:char; begin
 u:=0;
 if b=true then player:=loser else begin
  for i2:=1 to ii do for j2:=1 to jj do
   if clicked[i2,j2]=false then u:=u+1;
  if u=mines then player:=winner;
  end;
 end;

procedure moveup;    begin if inow>1  then inow:=inow-1; end;
procedure moveleft;  begin if jnow>1  then jnow:=jnow-1; end;
procedure moveright; begin if jnow<jj then jnow:=jnow+1; end;
procedure movedown;  begin if inow<ii then inow:=inow+1; end;

function surrounding_mines(i3,j3:byte):byte; var kk:byte; begin
 kk:=0;
 if i3<ii then if map[i3+1,j3]=true then kk:=kk+1;
 if i3>1  then if map[i3-1,j3]=true then kk:=kk+1;
 if j3<jj then if map[i3,j3+1]=true then kk:=kk+1;
 if j3>1  then if map[i3,j3-1]=true then kk:=kk+1;
 if (i3<ii) and (j3<jj) then if map[i3+1,j3+1]=true then kk:=kk+1;
 if (i3>1)  and (j3<jj) then if map[i3-1,j3+1]=true then kk:=kk+1;
 if (i3<ii) and (j3>1)  then if map[i3+1,j3-1]=true then kk:=kk+1;
 if (i3>1)  and (j3>1)  then if map[i3-1,j3-1]=true then kk:=kk+1;
 surrounding_mines:=kk;
 end;

procedure click(i4,j4:byte); begin
 clicked[i4,j4]:=true;
 if map[i4,j4]=true then b:=true else
  board[i4,j4]:=char(48+surrounding_mines(i4,j4));
 end;

procedure click_around_Os; var i5,j5:byte; begin
 for i5:=1 to ii do for j5:=1 to jj do
  if (surrounding_mines(i5,j5)=0) and (clicked[i5,j5]=true) then begin
   if not (board[i5+1,j5]=char(6)) then click(i5+1,j5);
   if not (board[i5-1,j5]=char(6)) then click(i5-1,j5);
   if not (board[i5,j5+1]=char(6)) then click(i5,j5+1);
   if not (board[i5,j5-1]=char(6)) then click(i5,j5-1);
   if not (board[i5+1,j5+1]=char(6)) then click(i5+1,j5+1);
   if not (board[i5-1,j5-1]=char(6)) then click(i5-1,j5-1);
   if not (board[i5+1,j5-1]=char(6)) then click(i5+1,j5-1);
   if not (board[i5-1,j5+1]=char(6)) then click(i5-1,j5+1);
   end;
 end;

procedure mine_sign; begin
 if board[inow,jnow]='#' then board[inow,jnow]:=char(6) else
  if board[inow,jnow]=char(6) then board[inow,jnow]:='#';
 end;

begin
 repeat
 b:=false;
 clrscr;
 write('columns(1..35) = ');readln(jj);
 write('lines(1..20) = ');readln(ii);
 write('mines=');readln(mines);
 for i:=1 to ii do for j:=1 to jj do begin
  board[i,j]:='#';
  map[i,j]:=false;
  clicked[i,j]:=false;
  end;
 randomize;
 for i:=1 to mines do map[random(ii)+1,random(jj)+1]:=true;
 writeit;
 inow:=1;
 jnow:=1;
 repeat
  key:=readkey;
  if key=#13 then click(inow,jnow);
  if key=#32 then mine_sign;
  if key=#72 then moveup;
  if key=#75 then moveleft;
  if key=#77 then moveright;
  if key=#80 then movedown;
  for i:=1 to 5 do
   click_around_Os;
  writeit;
  until (player=winner) or (player=loser);
  if player=loser then inow:=0 else
   board[inow,jnow]:=char(48+surrounding_mines(inow,jnow));
  for i:=1 to ii do for j:=1 to jj do
   if map[i,j]=true then board[i,j]:=char(15) else
    board[i,j]:=char(48+surrounding_mines(i,j));
  writeit;
  writeln;
  writeln;
  gotoxy(jj*2+4,2);
  if player=loser then writeln('U LOSE!') else writeln('U WIN!');
  gotoxy(0,0);
  readln;
 until inow=9999;
 end.


unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls,Math, StdCtrls, Buttons;

type

TRPoint=record
 x,y:single;
 end;

TLine=record
 P1,P2:TRPoint;
end;

TLink=record
 Length:single;
 Angle:single;
end;

TLinks=array of TLink;
TLines=array of TLine;
TPoints=array of TRPoint;

TFractal=record
 Links:TLinks;
 Length:single;
end;

type TMatrix=record
Value:array of array of byte;
View:array of array of boolean;
end;


type
  TForm1 = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    Create1: TMenuItem;
    hisFractal1: TMenuItem;
    Bevel1: TBevel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Edit1: TEdit;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    Bevel2: TBevel;
    Bevel3: TBevel;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    Bevel4: TBevel;
    N2: TMenuItem;

    Function RPoint(x,y:single):TRPoint;
    Function GetLine(P1,P2:TRPoint):TLine;
    Function GetAngle(p1,p2:TRPoint):single;
    Function Dist(P1,P2:TRPoint):single;
    Function LineToLink(Line:TLine):TLink;
    Function GetLength(Links:TLinks):single;   //Fractal Length
    Function LinkToPoint(k,Angle:single; Link:TLink):TRPoint;
    Function CreateLines(Line:TLine; Fractal:TFractal):TLines;
    Function MatrixToFractal(Matrix:TMatrix):TFractal;
    Function BuildFractal(Lines:TLines; Fractal:TFractal; Steps:integer):TLines;
    Procedure AddLines(var GlobalLines:TLines; Lines:TLines); //AddLines=GlobalLines+Lines
    Procedure Path(Matrix:TMatrix; y:integer; var Points:TPoints);
    Procedure DrawFractal(Lines:TLines; Canvas:TCanvas);

    procedure Privjazka(Enabled:boolean; Img:TImage);
    procedure RandomColors(Links:TLinks);
    procedure VisiblePoints(Vis:boolean);
    procedure NewFractal;
    procedure SaveFractal(FileName:string);
    procedure LoadFractal(FileName:string);

    procedure ShowLines(Lines:TLines);
    procedure ShowPoints(Points:TPoints);
    procedure ShowLinks(Links:TLinks);
    procedure ShowMatrix(Matrix:TMatrix);
    

    procedure FormShow(Sender: TObject);
    procedure NewPoint1Click(Sender: TObject);
    procedure CreatePoint(x,y:integer);
    procedure DblClickPoint(Sender: TObject);
    procedure ClickPoint(Sender: TObject);
    procedure MovePoint(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SelectPoint(Tag:integer; Color:TColor);
    function FindPoint(tag:integer):TImage;
    function FindPointByTag(Tag:integer):TRPoint;
    procedure Draw;
    procedure DrawBlueLine(Tag1,Tag2:integer; Canvas:TCanvas);
    procedure Image1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure hisFractal1Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Num,C,Now,Last:integer;
  Fasten:boolean;
  B1,B2:integer;
   Mass:TMatrix;
   Frac:TFractal;
   NLines:TLines;
  Colors:Array of TColor;
implementation

uses Unit3, Unit2;

{$R *.dfm}
{$R Data *.res}

Function TForm1.RPoint(x,y:single):TRPoint;
begin
 Result.x:=x;
 Result.y:=y;
end;

Function TForm1.GetLine(P1,P2:TRPoint):TLine;
begin
 Result.P1:=P1;
 Result.P2:=P2;
end;

Function TForm1.Dist(P1,P2:TRPoint):single;
begin
 Result:=sqrt(sqr(P1.X-P2.X)+sqr(P1.Y-P2.Y));
end;

Function TForm1.LineToLink(Line:TLine):TLink;
begin
 Result.Angle:=GetAngle(Line.P1,Line.P2);
 Result.Length:=Dist(Line.P1, Line.P2);
end;

Function TForm1.GetLength(Links:TLinks):single;
var
i:integer;
D:real;
begin
D:=0;
for i:=0 to High(Links) do begin
 D:=D+Links[i].Length*cos(pi*Links[i].Angle/180);
end;
Result:=D;
end;

Function TForm1.LinkToPoint(k,Angle:single; Link:TLink):TRPoint;
var
Len,Rad:Real;
begin
Len:=k*Link.Length;
Rad:=pi*(Link.Angle+Angle)/180;
Result:=RPoint(Len*cos(Rad),Len*sin(Rad));
end;

Function TForm1.CreateLines(Line:TLine; Fractal:TFractal):TLines;
var
k,Angle,Comp,Len:real;
i:integer;
p:TRPoint;
Lines:TLines;
begin
SetLength(Lines,0);
k:=Dist(Line.P1,Line.p2)/Fractal.Length;
Comp:=GetAngle(Line.P1,Line.P2);
 for i:=0 to High(Fractal.Links) do begin
  SetLength(Lines,Length(Lines)+1);
   P:=LinkToPoint(k,Comp,Fractal.Links[i]);
   if i=0                   then Lines[High(Lines)].P1:=Line.P1 else Lines[High(Lines)].P1:=Lines[High(Lines)-1].P2;
   if i=High(Fractal.Links) then Lines[High(Lines)].P2:=Line.P2 else Lines[High(Lines)].P2:=RPoint(Lines[High(Lines)].P1.x+P.x,Lines[High(Lines)].P1.y+P.y);
 end;
Result:=Lines;
end;



function TForm1.GetAngle(p1,p2:TRPoint):single;
var
a:real;
begin
 a:=180*ArcTan2(P2.Y-P1.Y, P2.x-P1.x)/pi;
 result:=a;
end;

procedure TForm1.AddLines(var GlobalLines:TLines; Lines:TLines);
var
i,h:integer;
begin
h:=High(GlobalLines)+1;
SetLength(GlobalLines,Length(GlobalLines)+Length(Lines));
for i:=0 to High(Lines) do GlobalLines[h+i]:=Lines[i];
end;

function TForm1.BuildFractal(Lines:TLines; Fractal:TFractal; Steps:integer):TLines;
var
ELines:TLines;
i,j,h:integer;
begin
SetLength(ELines,0);
j:=-1;
 while j<High(Lines) do begin
  j:=j+1;
  Form3.ProgressBar2.Position:=j;
  AddLines(ELines,CreateLines(Lines[j], Fractal));
 end;
Result:=ELines;
end;

procedure TForm1.DrawFractal(Lines:TLines; Canvas:TCanvas);
var
i,j:integer;
begin
Canvas.FillRect(Canvas.ClipRect);
Canvas.Pen.Color:=ClBlack;
j:=-1;
 for i:=0 to High(Lines) do begin
  if SpeedButton11.Tag=1 then begin
   j:=j+1;
   if j>High(Colors) then j:=0;
   Canvas.Pen.Color:=Colors[j];
  end;
  Canvas.MoveTo(Round(Lines[i].p1.x),Round(Lines[i].p1.y-28+2));
  Canvas.LineTo(Round(Lines[i].p2.x),Round(Lines[i].p2.y-28+2));
 end;
end;


procedure TForm1.Path(Matrix:TMatrix; y:integer; var Points:TPoints);
var
x:integer;
begin
for x:=0 to High(Matrix.Value) do begin
 if (Matrix.Value[x,y]=1) and (Matrix.View[x,y]=false)  then begin
   Matrix.View[x,y]:=true;
   Matrix.View[y,x]:=true;
   SetLength(Points,Length(Points)+1);
   Points[High(Points)]:=RPoint(y,x);
   Path(Matrix, x, Points);
 end;
end;
end;

Function TForm1.MatrixToFractal(Matrix:TMatrix):TFractal;
var
Points:TPoints;
Link:TLink;
Fractal:TFractal;
Comp:Real;
i,x,y:integer;
begin
 SetLength(Fractal.Links,0);
 Comp:=GetAngle(FindPointByTag(B1),FindPointByTag(B2));
 Path(Matrix,B1,Points);
 for i:=0 to High(Points) do begin
  SetLength(Fractal.Links,Length(Fractal.Links)+1);
  Link:=LineToLink(GetLine(FindPointByTag(Round(Points[i].x)),FindPointByTag(Round(Points[i].y))));
  Link.Angle:=Link.Angle-Comp;
  Fractal.Links[High(Fractal.Links)]:=Link;
 end;
for y:=0 to High(Matrix.view) do
 for x:=0 to High(Matrix.view) do
  Matrix.View[x,y]:=false;
Fractal.Length:=GetLength(Fractal.Links);
Result:=Fractal;
end;

//-------------------------------------------------------

//-------------------------------------------------------


procedure TForm1.CreatePoint(x,y:integer);
begin
SetLength(Mass.Value,Length(Mass.Value)+1,Length(Mass.Value)+1);
SetLength(Mass.View,Length(Mass.View)+1,Length(Mass.View)+1);
 with TImage.Create(Self) do begin
  Autosize:=true;
  Picture.Bitmap.LoadFromResourceName(Hinstance,'Point');
  Left:=x;
  Top :=y;
  Tag:=Num;
   OnClick:=ClickPoint;
   OnDblClick:=DblClickPoint;
   OnMouseMove:=MovePoint;
  Parent:=Form1;
 end;
Num:=Num+1;
end;

procedure TForm1.MovePoint(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
i:integer;
begin
if Shift=[ssLeft] then begin
 (sender as Timage).Left:=(sender as Timage).Left+x-3;
 (sender as Timage).top :=(sender as Timage).top+y-3;
  Privjazka(Fasten,(sender as Timage));
 Draw;
end;
end;

procedure TForm1.ClickPoint(Sender: TObject);
begin
if c=0 then Last:=(Sender as TImage).Tag;
c:=1;
end;

procedure TForm1.DblClickPoint(Sender: TObject);
var
Img1,Img2:TImage;
begin
if c=1 then begin
 Now:=(Sender as TImage).Tag;
if (Now<>Last) then begin
 if Mass.Value[Now,Last]=0 then begin
  Mass.Value[Now,Last]:=1;
  Mass.Value[Last,Now]:=1;
 end else begin
  Mass.Value[Now,Last]:=0;
  Mass.Value[Last,Now]:=0;
 end;
Mass.View[Now,Last]:=false;
Mass.View[Last,Now]:=false;
end;
end;
c:=0;
Last:=-1;
Now:=-1;
Draw;
end;

procedure TForm1.SelectPoint(Tag:integer; Color:TColor);
var
 Point:TRPoint;
begin
Point:=FindPointByTag(Tag);
With Image1.Canvas do begin
 Pen.Color:=Color;
 Pen.Width:=3;
 Ellipse(Round(Point.x)-5,Round(Point.y)-33,Round(Point.x)+15,Round(Point.y)-13);
 Pen.Color:=clblack;
 Pen.Width:=1;
end;
end;

function TForm1.FindPointByTag(Tag:integer):TRPoint;
var
i:integer;
begin
for i:=0 to ComponentCount-1 do begin
 if (Components[i] is TImage) and (TImage(Components[i]).Tag=Tag) and (TImage(Components[i]).Name<>'Image1') then begin
  Result:=RPoint(TImage(Components[i]).Left,TImage(Components[i]).top);
  exit;
 end;
end;
Result:=RPoint(-1,-1);
end;

function TForm1.FindPoint(tag:integer):TImage;
var
i:integer;
begin
for i:=0 to ComponentCount-1 do begin
 if (Components[i] is TImage) and (TImage(Components[i]).Tag=Tag) and (TImage(Components[i]).Name<>'Image1') then begin
  Result:=TImage(Components[i]);
  exit;
 end;
end;
Result:=nil;
end;
///------------------------------------------------
procedure TForm1.DrawBlueLine(Tag1,Tag2:integer; Canvas:TCanvas);
var
P1,P2:TRPoint;
begin
Canvas.Pen.color:=rgb(198,216,245);
 P1:=FindPointByTag(Tag1);
 P2:=FindPointByTag(Tag2);
Canvas.MoveTo(Round(P1.x+5),Round(P1.y+5-28));
Canvas.LineTo(Round(P2.x+5),Round(P2.y+5-28));
Canvas.Pen.color:=clblack;
end;

procedure TForm1.Draw;
var
img1,img2:TImage;
y,x:integer;
begin
Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
DrawBlueLine(B1,B2,Image1.Canvas);
for y:=0 to high(mass.value) do begin
 for x:=0 to high(mass.value) do begin
  if (x<>y) and (Mass.Value[x,y]=1) then begin
   Img1:=FindPoint(y);
   Img2:=FindPoint(x);
   Image1.Canvas.MoveTo(Img1.Left+5,Img1.Top+5-28);
   Image1.Canvas.LineTo(Img2.Left+5,Img2.Top+5-28);
  end;
 end;
end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
NewFractal;
Form2.CheckListBox1.Checked[0]:=true;
Form2.CheckListBox1.Checked[1]:=true;
end;

procedure TForm1.NewPoint1Click(Sender: TObject);
begin
CreatePoint(50,50);
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
c:=0;
end;

procedure TForm1.ShowLines(Lines:TLines);
var
m:string;
i:integer;
begin
for i:=0 to High(Lines) do begin
 m:=m+floattostr(RoundTo(Lines[i].p1.x,-2))+' '+floattostr(RoundTo(Lines[i].p1.y,-2))+'      '+floattostr(RoundTo(Lines[i].p2.x,-2))+' '+floattostr(RoundTo(Lines[i].p2.y,-2))+#13#10;
end;
showmessage(m);
end;

procedure TForm1.ShowPoints(Points:TPoints);
var
m:string;
i:integer;
begin
 for i:=0 to High(Points) do begin
  m:=m+floattostr(Points[i].x)+' '+floattostr(Points[i].y)+#13#10;
 end;
Showmessage(m);
end;

procedure TForm1.ShowLinks(Links:TLinks);
var
m:string;
i:integer;
begin
for i:=0 to High(Links) do begin
 m:=m+floattostr(Links[i].Angle)+' '+floattostr(Links[i].Length)+#13#10;
end;
showmessage(m);
end;

procedure TForm1.ShowMatrix(Matrix:TMatrix);
var
x,y:integer;
m:string;
begin
for y:=0 to High(Matrix.Value) do begin
 for x:=0 to High(Matrix.Value) do begin
  m:=m+' '+inttostr(matrix.Value[x,y]);
 end;
 m:=m+#13#10;
end;
showmessage(m);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
CreatePoint(50,50);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
i:integer;
begin
Form3.Show;
Form3.ProgressBar1.Max:=StrToInt(Edit1.Text);
Application.ProcessMessages;
for i:=1 to StrToInt(Edit1.Text) do begin
 with Form3 do begin
  ProgressBar2.Max:=High(NLines);
  ProgressBar2.Position:=0;
  ProgressBar1.Position:=i;
 end;
 NLines:=Form1.BuildFractal(NLines,Frac,1);
 Application.ProcessMessages;
end;
Form3.Close;
DrawFractal(NLines,Image1.Canvas);
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
var
i:integer;
P1,P2:TRPoint;
begin
if Num>2 then begin
Randomize;
 Frac:=MatrixToFractal(Mass);
 SetLength(NLines,1);
 NLines[0]:=GetLine(FindPointByTag(B1),FindPointByTag(B2));
 RandomColors(Frac.Links);
Showmessage('Фрактал создан.');
end else Showmessage('Должно быть более двух вершин.');
end;

procedure TForm1.RandomColors(Links:TLinks);
var
i:integer;
begin
if SpeedButton11.Tag=1 then begin
SetLength(Colors,Length(Links));
for i:=0 to High(Colors) do Colors[i]:=rgb(Random(255),Random(255),Random(255));
end;
end;

procedure TForm1.VisiblePoints(Vis:boolean);
var
i:integer;
begin
for i:=0 to COmponentCount-1 do begin
 if (Components[i] is Timage) and (TImage(Components[i]).Name<>'Image1') then begin
  TImage(Components[i]).Visible:=Vis;
 end;
end
end;

procedure TForm1.Privjazka(Enabled:boolean; Img:TImage);
var
a,d:single;
dx,dy,i:integer;
begin
if Enabled=true then
for i:=0 to ComponentCount-1 do begin
 if (Components[i] is Timage) and (TImage(Components[i]).Name<>'Image1') then begin
  dx:=TImage(Components[i]).Left-Img.Left;
  dy:=TImage(Components[i]).Top-Img.Top;
  if form2.CheckListBox1.checked[0]=true then
  if Abs(dx)<=3 then begin
    Img.left:=Img.Left+dx;
  end;
  if form2.CheckListBox1.checked[1]=true then
  if Abs(dy)<=3 then begin
    Img.top:=Img.top+dy;
  end;
 end;
end;
end;

procedure TForm1.NewFractal;
var
flag:boolean;
i:integer;
begin
Num:=0; C:=0; B1:=0; B2:=1; Fasten:=true;
SetLength(Mass.Value,0);
SetLength(Mass.View,0);
Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
repeat
flag:=false;
for i:=0 to COmponentCount-1 do begin
 if (Components[i] is Timage) and (TImage(Components[i]).Name<>'Image1') then begin
  TImage(Components[i]).Free;
  flag:=true;
  break;
 end;
end
until flag=false;
end;

procedure TForm1.SaveFractal(FileName:string);
var
P:TRPoint;
i,x,y:integer;
begin
AssignFile(output,FileName);
Rewrite(output);
Writeln(B1,' ',B2,' ',Num-1,' ',Length(Mass.Value));
for i:=0 to Num-1 do begin
 P:=FindPointByTag(i);
 Writeln(Round(P.x),' ',Round(P.y));
end;
for y:=0 to High(Mass.value) do begin
 for x:=0 to High(Mass.value) do begin
  Writeln(Mass.value[x,y]);
 end;
end;
CloseFile(output);
Showmessage('Сохранено.');
end;

procedure TForm1.LoadFractal(FileName:string);
var
count,i,x,y,l:integer;
begin
 AssignFile(input,FileName);
 Reset(input);
 Readln(B1,B2,Count,l);
 for i:=0 to Count do begin
  Readln(x,y);
  CreatePoint(x,y);
 end;
 SetLength(Mass.Value,l,l);
 SetLength(Mass.View,l,l);
 for y:=0 to l-1 do begin
  for x:=0 to l-1 do begin
   Readln(Mass.Value[x,y]);
   Mass.View[x,y]:=false;
  end;
 end;
 Draw;
 CloseFile(input);
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
if SpeedButton4.Tag=0 then begin
  SpeedButton4.Glyph.LoadFromResourceName(Hinstance,'UNVISPOINT');
  VisiblePoints(False);
  SpeedButton4.Tag:=1;
end else begin
  SpeedButton4.Glyph.LoadFromResourceName(Hinstance,'VISPOINT');
  VisiblePoints(true);
  SpeedButton4.Tag:=0;
end;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
NewFractal;
end;

procedure TForm1.SpeedButton8Click(Sender: TObject);
begin
if B1<Num-1 then B1:=B1+1 else B1:=0;
Draw;
end;

procedure TForm1.SpeedButton9Click(Sender: TObject);
begin
if B2>0 then B2:=B2-1 else B2:=Num-1;
Draw;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
Form1.DoubleBuffered:=true;
end;

procedure TForm1.SpeedButton10Click(Sender: TObject);
begin
Image1.Picture.SaveToFile('Snap.bmp');
end;

procedure TForm1.hisFractal1Click(Sender: TObject);
begin
Showmessage('Автор программы Бышин Артем'+#13#10+
            'Версия программы 1.0');
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
SaveFractal('Fractal.f');
end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
begin
NewFractal;
LoadFractal('Fractal.f');
end;

procedure TForm1.SpeedButton11Click(Sender: TObject);
begin
if SpeedButton11.Tag=0 then begin
  SpeedButton11.Glyph.LoadFromResourceName(Hinstance,'COLORS');
  SpeedButton11.Tag:=1;
end else begin
  SpeedButton11.Glyph.LoadFromResourceName(Hinstance,'MONOCHROME');
  SpeedButton11.Tag:=0;
end;
end;

procedure TForm1.SpeedButton13Click(Sender: TObject);
begin
Form2.show;
end;

procedure TForm1.SpeedButton12Click(Sender: TObject);
begin
if SpeedButton12.Tag=0 then begin
  SpeedButton12.Glyph.LoadFromResourceName(Hinstance,'FASTENDISABLED');
  fasten:=false;
  SpeedButton12.Tag:=1;
end else begin
  SpeedButton12.Glyph.LoadFromResourceName(Hinstance,'FASTENENABLED');
  fasten:=true;
  SpeedButton12.Tag:=0;
end;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
NewFractal;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
SaveFractal('Fractal.f');
end;

procedure TForm1.N5Click(Sender: TObject);
begin
NewFractal;
LoadFractal('Fractal.f');
end;

procedure TForm1.N6Click(Sender: TObject);
begin
Form1.Close;
end;

end.

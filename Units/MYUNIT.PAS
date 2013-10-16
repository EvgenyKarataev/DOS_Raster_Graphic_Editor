unit MyUnit;
                  INTERFACE
const
  ToDraw = 1;
  ToAdd = 2;

type
  Mas = record
    ar: array[1..10] of record
                          X1, Y1, X2, Y2: Integer;
                          Value: Word;
                        end;
    N: Integer;
  end;

  TWin = record
    Left, Top, Right, Bottom: Integer;
    HTitle: Word;
    Title: string;
    ColBk, ColBor, ColTitle: Word;
  end;

  TFile = record
    Left, Top, Right, Bottom: Integer;
    Name: string;
    ColBkFile, ColBor: Word;
  end;

  TBt = record
    Left, Top, Right, Bottom: Integer;
    Title: string;
    ColBt, ColBor: Word;
  end;

{Родитель всех моих объектов}
  TObject =  object
  private
    Left, Top, Right, Bottom: Integer;  {координаты углов}
    Visible: Boolean;         {видимость}
    Border: Integer;
    Col, BorderCol, Style: Word;
    Width, Height: Integer;
  public
    function GetLeft: Integer;             {получает левую координату}
    function GetRight: Integer;            {получает правую координату}
    function GetTop: Integer;              {получает верхнюю координту}
    function GetBottom: Integer;           {получает нижнюю координату}
    function GetVisible: Boolean;          {получает видимость}
    function GetBorder: Integer;           {получает толщину граници}
    function GetCol: Word;
    function GetBorderCol: Word;
    function GetStyle: Word;
    function GetWidth: Integer;
    function GetHeight: Integer;

    procedure SetLeft(Value: Integer);     {устанавливает левую координату}
    procedure SetWidth(Value: Integer);    {устанавливает правую координату}
    procedure SetTop(Value: Integer);      {устанавливает верхнюю координату}
    procedure SetHeight(Value: Integer);   {устанавливает нижнюю координату}
    procedure SetVisible(Value: Boolean);  {устанавливает видимость}
    procedure SetBorder(Value: Integer);   {устанавливает толщину граници}
    procedure SetCol(Value: Word);
    procedure SetBorderCol(Value: Word);
    procedure SetStyle(Value: Word);

    procedure Draw;

    constructor Create;
    destructor Free;
  end;
{=======================TObject==============================}

{=======================TButton==============================}
  TButton = object(TObject)
  private
    Butt: Word;
    Key: Word;
  public
    function GetButt: Word;
    function GetKey: Word;

    procedure SetButt(Value: Word);
    procedure SetKey(Value: Word);
  end;
{=======================TButton==============================}

  TRec = record
    X1, Y1, X2, Y2: Integer;
  end;

{=======================TProgress==============================}
  TProgress = object(TObject)
  private
    Step: Integer;
    Position: Integer;
    Rec: TRec;
    StepColor: Word;
  public
    function GetStep: Integer;
    function GetPosition: Integer;
    function GetStepColor: Word;

    procedure SetStep(Value: Integer);
    procedure SetPosition;
    procedure KillPosition;
    procedure SetStepColor(Value: Word);
    procedure Visibly(Value: Boolean; Color, BC: Word);
  end;
{=======================TProgress==============================}

procedure MouseDown(Mask, Buttons, X, Y, DX, DY: Integer);
procedure MouseUp(Mask, Buttons, X, Y, DX, DY: Integer);
procedure DDots(Left, Top: Integer; Col: Word);
procedure DRubber(Left, Top, Wid, Height, Depth: Integer; Col: Word);
procedure DPencil(Left, Top: Integer; Col: Word);
procedure DBrush(Left, Top: Integer; Col: Word);
procedure DSt_Line(Left, Top: Integer; Col: Word);
procedure DPolyline(Left, Top: Integer; Col: Word);
procedure DOval(Left, Top: Integer; Col: Word);
procedure DRec(Left, Top: Integer; Col: Word);
procedure DSpray(Left, Top: Integer; Col: Word);
procedure DFill(Left, Top: Integer; Col: Word);
procedure DEraserModes(Left, Top, Right, Bottom, N: Integer;
            Col: Word; var ar: Mas; Count: Word);
procedure DBrushModes(Left, Top, Right, Bottom, N: Integer;
            Col: Word; var ar: Mas; Count: Word);
procedure DLineModes(Left, Top, Right, Bottom, N: Integer;
                           Col: Word; var ar: Mas; Count: Word);
procedure DFilModes(Left, Top, Right, Bottom, N: Integer;
            Col: Word; var ar: Mas; Count: Word);
procedure DSprayModes(Left, Top, Right, Bottom, N: Integer;
            Col: Word; var ar: Mas; Count: Word);
procedure DDialog(Win: TWin; Fil: TFile; Bt1, Bt2: TBt);

                IMPLEMENTATION
uses GRAPH, F_Mouse;
{==================TObject===============================}
constructor TObject.Create;
begin
end;

destructor TObject.Free;
begin
end;

function TObject.GetLeft: Integer;
{получает левую координату}
begin
  GetLeft := Left;
end;

function TObject.GetRight: Integer;
{получает правую координату}
begin
  GetRight := Right;
end;

function TObject.GetTop: Integer;
{получает верхнюю координату}
begin
  GetTop := Top;
end;

function TObject.GetBottom: Integer;
{получает нижнюю координату}
begin
  GetBottom := Bottom;
end;

function TObject.GetVisible: Boolean;
{получает видимость}
begin
  GetVisible := Visible;
end;

function TObject.GetBorder: Integer;
{получает толщину граници}
begin
  GetBorder := Border;
end;

function TObject.GetCol: Word;
begin
  GetCol :=Col;
end;

function TObject.GetBorderCol: Word;
begin
  GetBorderCol :=Col;
end;

function TObject.GetStyle: Word;
begin
  GetStyle := Style;
end;

function TObject.GetWidth: Integer;
begin
  GetWidth := Right - Left;
end;

function TObject.GetHeight: Integer;
begin
  GetHeight := Bottom - Top;
end;

procedure TObject.SetLeft(Value: Integer);
{устанавливает левую координату}
begin
  Left := Value;
end;

procedure TObject.SetWidth(Value: Integer);
{устанавливает правую координату}
begin
  Right := Left + Value;
end;

procedure TObject.SetTop(Value: Integer);
{устанавливает верхнюю координату}
begin
  Top := Value;
end;

procedure TObject.SetHeight(Value: Integer);
{устанавливает нижнюю координату}
begin
  Bottom := Top + Value;
end;

procedure TObject.SetVisible(Value: Boolean);
{устанавливает видимость}
begin
  Visible := Value;
end;

procedure TObject.SetBorder(Value: Integer);
{устанавливает толщину граници}
begin
  Border := Value;
end;

procedure TObject.Draw;
var
  OldCol: Word;
begin
  OldCol := GetColor;
  SetFillStyle(Style, Col);
  Bar(Left, Top, Right, Bottom);
  SetFillStyle(SolidFill, OldCol);
  if Border > 0 then
    begin
      SetColor(BorderCol);
      Rectangle(Left, Top, Right, Bottom);
      SetColor(OldCol);
    end;
end;

procedure TObject.SetCol(Value: Word);
begin
  Col := Value;
end;

procedure TObject.SetBorderCol(Value: Word);
begin
  BorderCol := Value;
end;

procedure TObject.SetStyle(Value: Word);
begin
  Style := Value;
end;
{==================End TObject ==========================}

{=====================TButton============================}
function TButton.GetKey: Word;
begin
  GetKey := Key;
end;

function TButton.GetButt: Word;
begin
  GetButt := Butt;
end;

procedure TButton.SetKey(Value: Word);
begin
  Key := Value;
end;

procedure TButton.SetButt(Value: Word);
begin
  Butt := Value;
end;
{===================End TButton==========================}

{=====================TProgress==========================}
function TProgress.GetStep: Integer;
begin
  GetStep := Step;
end;

function TProgress.GetPosition: Integer;
begin
  GetPosition := Position;
end;

function TProgress.GetStepColor: Word;
begin
  GetStepColor := StepColor;
end;

procedure TProgress.SetStep(Value: Integer);
begin
  Step := Value;
end;

procedure TProgress.SetStepColor(Value: Word);
begin
  StepColor := Value;
end;

procedure TProgress.SetPosition;
var
  OldCol: Word;
begin
  Position := Position + Step;
  if Position < Right - Left - 1 then
  with Rec do
  begin
    X2 := X1 + Position;
    OldCol := GetColor;
    SetFillStyle(Style, StepColor);
    Bar(X1, Y1, X2, Y2);
    SetFillStyle(SolidFill, OldCol);
  end;
end;

procedure TProgress.KillPosition;
begin
  Position := 0;
end;

procedure TProgress.Visibly(Value: Boolean; Color, BC: Word);
begin
  with Rec do
    begin
      X1 := Left + 1;
      Y1 := Top + 1;
      X2 := X1;
      Y2 := Bottom - 1;
    end;

  Col := Color;
  BorderCol := BC;
  Draw;
end;
{==================End TProgress=========================}

procedure MouseDown(Mask, Buttons, X, Y, DX, DY: Integer);
begin
  OutTextXY(X,Y + 30,'Down');
end;
procedure MouseUp(Mask, Buttons, X, Y, DX, DY: Integer);
begin
  OutTextXY(X,Y - 30,'Up');
end;

procedure DDots(Left, Top: Integer; Col: Word);
var
  i: Integer;
  Radius, OldCol: Word;
begin
  Radius := 1;
  OldCol := GetColor;
  SetColor(Col);
  for i := 0 to 2 do
    begin
      PieSlice(Left - Radius + i * 4 * Radius, Top - Radius, 0, 360, Radius);
    end;
  SetColor(OldCol);
end;

procedure DRubber(Left, Top, Wid, Height, Depth: Integer; Col: Word);
var
  FillInfo : FillSettingsType;
  OldCol: Word;
begin
  GetFillSettings(FillInfo);   { Сохраняем стиль и цвет закраски }
  OldCol := GetColor;
  SetFillStyle(SolidFill, Col);
  SetColor(Col);
  Bar3D(Left, Top, Left + Wid, Top + Height, Depth, True);
  With FillInfo Do SetFillStyle(Pattern, Color);
  SetColor(OldCol);
end;

procedure DPencil(Left, Top: Integer; Col: Word);
var
  High: Word;
  OldCol: Word;
begin
  OldCol := GetColor;
  SetColor(Col);

  High := 7;

  Line(Left, Top, Left, Top - 2);
  Line(Left, Top - 2, Left + 2, Top);
  Line(Left + 2, Top, Left, Top);
  Line(Left, Top - 2, Left + 8, Top - 6);
  Line(Left + 8, Top - 6, Left + 10, Top - 4);
  Line(Left + 10, Top - 4, Left + 2, Top);

  SetColor(OldCol);
end;

procedure DBrush(Left, Top: Integer; Col: Word);
var
  OldCol: Word;
begin
  OldCol := GetColor;
  SetColor(Col);
  Line(Left, Top, Left + 4, Top);
  Line(Left + 4, Top, Left + 4, Top + 1);
  Line(Left + 4, Top + 1, Left + 11, Top + 1);
  Line(Left + 11, Top + 1, Left + 11, Top + 3);
  Line(Left + 11, Top + 3, Left + 4, Top + 3);
  Line(Left + 4, Top + 3, Left + 4, Top + 4);
  Line(Left + 4, Top + 4, Left, Top + 4);
  Line(Left, Top + 4, Left, Top);
  Line(Left, Top, Left - 2, Top);
  Line(Left, Top + 2, Left - 2, Top + 2);
  Line(Left, Top + 4, Left - 2, Top + 4);
  SetColor(OldCol);
end;

procedure DSt_Line(Left, Top: Integer; Col: Word);
var
  OldCol: Word;
begin
  OldCol := GetColor;
  SetColor(Col);
  Line(Left + 10, Top, Left, Top + 5);
  SetColor(OldCol);
end;

procedure DPolyline(Left, Top: Integer; Col: Word);
var
  OldCol: Word;
begin
  OldCol := GetColor;
  SetColor(Col);
  Line(Left, Top + 5, Left + 5, Top);
  Line(Left + 5, Top, Left + 10, Top + 3);
  Line(Left + 10, Top + 3, Left + 5, Top + 6);
  SetColor(OldCol);
end;

procedure DOval(Left, Top: Integer; Col: Word);
var
  OldCol: Word;
begin
  OldCol := GetColor;
  SetColor(Col);

  Ellipse(Left + 6, Top + 4, 0, 360, 5, 3);

  SetColor(OldCol);
end;

procedure DRec(Left, Top: Integer; Col: Word);
var
  OldCol: Word;
begin
  OldCol := GetColor;
  SetColor(Col);

  Rectangle(Left, Top, Left + 9, Top + 6);

  SetColor(OldCol);
end;

procedure DSpray(Left, Top: Integer; Col: Word);
var
  OldCol: Word;
  i, k, y: Integer;
begin
  OldCol := GetColor;
  SetFillStyle(SolidFill, Col);
  SetColor(Col);
  MoveTo(Left + 3, Top);
  lineTo(Left + 5, Top);
  lineTo(Left + 5, Top + 3);
  lineTo(Left + 7, Top + 3);
  lineTo(Left + 7, Top + 6);
  lineTo(Left, Top + 6);
  lineTo(Left, Top + 3);
  lineTo(Left + 2, Top + 3);
  lineTo(Left + 2, Top);
  bar(Left, Top + 5, Left + 7, Top + 8);

  Line(Left - 5, Top , Left - 1, Top);
  Line(Left - 5, Top + 3, Left - 1, Top);
  Line(Left - 5, Top + 6, Left - 1, Top + 2);

  SetColor(OldCol);
  SetFillStyle(SolidFill, OldCol);
end;

procedure DFill(Left, Top: Integer; Col: Word);
var
  OldCol: Word;
  i, k, y: Integer;
begin
  OldCol := GetColor;
  SetFillStyle(SolidFill, Col);
  SetColor(Col);
  MoveTo(Left + 2, Top);
  LineTo(Left + 7, Top);
  LineTo(Left + 7, Top + 1);
  LineTo(Left + 8, Top + 2);
  LineTo(Left + 9, Top + 3);
  LineTo(Left + 9, Top + 6);
  LineTo(Left + 8, Top + 7);
  LineTo(Left + 1, Top + 7);
  LineTo(Left, Top + 6);
  LineTo(Left, Top + 3);
  LineTo(Left + 1, Top + 2);
  LineTo(Left + 2, Top + 1);

  bar(Left, Top + 4, Left + 8, Top + 6);

  SetColor(OldCol);
  SetFillStyle(SolidFill, OldCol);
end;

procedure DEraserModes(Left, Top, Right, Bottom, N: Integer;
            Col: Word; var ar: Mas; Count: Word);
var
  OldCol: Word;
  OldStyle : LineSettingsType;
  Item: MouseItemType;
begin
  OldCol := GetColor;
  GetLineSettings(OldStyle);
  SetColor(Col);
  ar.N := 2;

  SetLineStyle(SolidLn, 0, 1);
  SetFillStyle(SolidFill, 15);
  bar((Left + Right) div 2 - 3, Top + 3, (Left + Right) div 2 + 3, Top + 9);
  Rectangle((Left + Right) div 2 - 3, Top + 3, (Left + Right) div 2 + 3, Top + 9);
  ar.ar[1].Value := 5;

  Item.X1 := Left + 4;
  Item.Y1 := Top + 2;
  Item.X2 := Right - 4;
  Item.Y2 := Top + 10;
  Item.Butt := LeftButton;
  Item.Key := N;
  AddMouseItem(Item);
  ar.ar[1].X1 := Item.X1;
  ar.ar[1].Y1 := Item.Y1;
  ar.ar[1].X2 := Item.X2;
  ar.ar[1].Y2 := Item.Y2;

  bar((Left + Right) div 2 - 4, Top + 13, (Left + Right) div 2 + 4, Top + 21);
  Rectangle((Left + Right) div 2 - 4, Top + 13, (Left + Right) div 2 + 4, Top + 21);
  ar.ar[2].Value := 8;

  Item.X1 := Left + 4;
  Item.Y1 := Top + 13;
  Item.X2 := Right - 4;
  Item.Y2 := Top + 21;
  Item.Butt := LeftButton;
  Item.Key := N + 1;
  AddMouseItem(Item);
  ar.ar[2].X1 := Item.X1;
  ar.ar[2].Y1 := Item.Y1;
  ar.ar[2].X2 := Item.X2;
  ar.ar[2].Y2 := Item.Y2;

  SetColor(OldCol);
  SetFillStyle(SolidFill, OldCol);
  with OldStyle Do SetLineStyle(LineStyle, Pattern, Thickness);
end;


procedure DBrushModes(Left, Top, Right, Bottom, N: Integer;
            Col: Word; var ar: Mas; Count: Word);
var
  OldCol: Word;
  OldStyle : LineSettingsType;
  Item: MouseItemType;
begin
  OldCol := GetColor;
  GetLineSettings(OldStyle);
  SetColor(Col);
  ar.N := 2;

  SetLineStyle(SolidLn, 0, 1);
  SetFillStyle(SolidFill, Col);
  PieSlice((Left + Right) div 2, Top + 6, 0, 360, 3);
  ar.ar[1].Value := 1;

  Item.X1 := Left + 4;
  Item.Y1 := Top + 2;
  Item.X2 := Right - 4;
  Item.Y2 := Top + 10;
  Item.Butt := LeftButton;
  Item.Key := N;
  AddMouseItem(Item);
  ar.ar[1].X1 := Item.X1;
  ar.ar[1].Y1 := Item.Y1;
  ar.ar[1].X2 := Item.X2;
  ar.ar[1].Y2 := Item.Y2;

  bar((Left + Right) div 2 - 3, Top + 14, (Left + Right) div 2 + 3, Top + 20);
  ar.ar[2].Value := 3;

  Item.X1 := Left + 4;
  Item.Y1 := Top + 13;
  Item.X2 := Right - 4;
  Item.Y2 := Top + 21;
  Item.Butt := LeftButton;
  Item.Key := N + 1;
  AddMouseItem(Item);
  ar.ar[2].X1 := Item.X1;
  ar.ar[2].Y1 := Item.Y1;
  ar.ar[2].X2 := Item.X2;
  ar.ar[2].Y2 := Item.Y2;

  SetColor(OldCol);
  SetFillStyle(SolidFill, OldCol);
  with OldStyle Do SetLineStyle(LineStyle, Pattern, Thickness);
end;

procedure DLineModes(Left, Top, Right, Bottom, N: Integer;
            Col: Word; var ar: Mas; Count: Word);
var
  OldCol: Word;
  OldStyle : LineSettingsType;
  Item: MouseItemType;
begin
  OldCol := GetColor;
  SetFillStyle(SolidFill, Col);
  GetLineSettings(OldStyle);
  SetColor(Col);
  ar.N := 2;

  SetLineStyle(SolidLn, 0, 1);
  Line(Left + 4, Top + 6, Right - 4, Top + 6);
  ar.ar[1].Value := 1;

  Item.X1 := Left + 4;
  Item.Y1 := Top + 2;
  Item.X2 := Right - 4;
  Item.Y2 := Top + 10;
  Item.Butt := LeftButton;
  Item.Key := N;
  AddMouseItem(Item);
  ar.ar[1].X1 := Item.X1;
  ar.ar[1].Y1 := Item.Y1;
  ar.ar[1].X2 := Item.X2;
  ar.ar[1].Y2 := Item.Y2;

  SetLineStyle(SolidLn, 0, 3);
  Line(Left + 4, Top + 17, Right - 4, Top + 17);
  ar.ar[2].Value := 3;

  Item.X1 := Left + 4;
  Item.Y1 := Top + 13;
  Item.X2 := Right - 4;
  Item.Y2 := Top + 21;
  Item.Butt := LeftButton;
  Item.Key := N + 1;
  AddMouseItem(Item);
  ar.ar[2].X1 := Item.X1;
  ar.ar[2].Y1 := Item.Y1;
  ar.ar[2].X2 := Item.X2;
  ar.ar[2].Y2 := Item.Y2;

  SetColor(OldCol);
  SetFillStyle(SolidFill, OldCol);
  with OldStyle Do SetLineStyle(LineStyle, Pattern, Thickness);
end;

procedure DFilModes(Left, Top, Right, Bottom, N: Integer;
            Col: Word; var ar: Mas; Count: Word);
var
  OldCol: Word;
  OldStyle : LineSettingsType;
  Item: MouseItemType;
begin
  OldCol := GetColor;
  GetLineSettings(OldStyle);
  SetColor(Col);
  ar.N := 2;

  SetLineStyle(SolidLn, 0, 1);
  Rectangle(Left + 4, Top + 4, Right - 4, Top + 8);
  ar.ar[1].Value := 1;

  Item.X1 := Left + 4;
  Item.Y1 := Top + 2;
  Item.X2 := Right - 4;
  Item.Y2 := Top + 10;
  Item.Butt := LeftButton;
  Item.Key := N;
  AddMouseItem(Item);
  ar.ar[1].X1 := Item.X1;
  ar.ar[1].Y1 := Item.Y1;
  ar.ar[1].X2 := Item.X2;
  ar.ar[1].Y2 := Item.Y2;

  SetFillStyle(SolidFill, Col);
  bar(Left + 4, Top + 15, Right - 4, Top + 19);
  ar.ar[2].Value := 3;

  Item.X1 := Left + 4;
  Item.Y1 := Top + 13;
  Item.X2 := Right - 4;
  Item.Y2 := Top + 21;
  Item.Butt := LeftButton;
  Item.Key := N + 1;
  AddMouseItem(Item);
  ar.ar[2].X1 := Item.X1;
  ar.ar[2].Y1 := Item.Y1;
  ar.ar[2].X2 := Item.X2;
  ar.ar[2].Y2 := Item.Y2;

  SetColor(OldCol);
  SetFillStyle(SolidFill, OldCol);
  with OldStyle Do SetLineStyle(LineStyle, Pattern, Thickness);
end;

procedure DSprayModes(Left, Top, Right, Bottom, N: Integer;
            Col: Word; var ar: Mas; Count: Word);
var
  OldCol: Word;
  OldStyle : LineSettingsType;
  Item: MouseItemType;
  k, i, ang, r: Integer;
begin
  OldCol := GetColor;
  GetLineSettings(OldStyle);
  SetColor(Col);
  ar.N := 2;

  SetLineStyle(SolidLn, 0, 1);
  for k := 0 to 3 do
    for i := 1 to 3 do
      begin
        ang := (k + 1) * i * i * 3+ k * 90;
        if i * (i + k) div (k + 1) > 4 then
          r := 4 - k
        else
          r := i * (i + k) div (k + 1) - 1;
        Arc((Left + Right) div 2, Top + 6, ang, ang + 1, r);
      end;
  ar.ar[1].Value := 4;

  Item.X1 := Left + 4;
  Item.Y1 := Top + 2;
  Item.X2 := Right - 4;
  Item.Y2 := Top + 10;
  Item.Butt := LeftButton;
  Item.Key := N;
  AddMouseItem(Item);
  ar.ar[1].X1 := Item.X1;
  ar.ar[1].Y1 := Item.Y1;
  ar.ar[1].X2 := Item.X2;
  ar.ar[1].Y2 := Item.Y2;

  SetFillStyle(SolidFill, Col);
  for k := 0 to 3 do
    for i := 1 to 4 do
      begin
        ang := (k + 1) * i * i * 5+ k * 90;
        if i * (i + k) div (k + 1) > 6 then
          r := 6 - k
        else
          r := i * (i + k) div (k + 1) - 1;
        Arc((Left + Right) div 2, Top + 17, ang, ang + 1, r);
      end;
  ar.ar[2].Value := 8;

  Item.X1 := Left + 4;
  Item.Y1 := Top + 13;
  Item.X2 := Right - 4;
  Item.Y2 := Top + 22;
  Item.Butt := LeftButton;
  Item.Key := N + 1;
  AddMouseItem(Item);
  ar.ar[2].X1 := Item.X1;
  ar.ar[2].Y1 := Item.Y1;
  ar.ar[2].X2 := Item.X2;
  ar.ar[2].Y2 := Item.Y2;

  SetColor(OldCol);
  SetFillStyle(SolidFill, OldCol);
  with OldStyle Do SetLineStyle(LineStyle, Pattern, Thickness);
end;

procedure DDialog(Win: TWin; Fil: TFile; Bt1, Bt2: TBt);
var
  OldCol: Word;
  OldStyleT : TextSettingsType;
  FillInfo : FillSettingsType;
  N: Integer;
  Items: array[1..2] of MouseItemType;  {границы нажатия кнопок}
begin
  GetTextSettings(OldStyleT);
  GetFillSettings(FillInfo);   { Сохраняем стиль и цвет закраски }
  OldCol := GetColor;

  with Win do
  begin
    SetFillStyle(SolidFill, ColBk);
    bar(Left, Top, Right, Bottom);
    SetFillStyle(SolidFill, ColTitle);
    Bar(Left, Top, Right, Top + HTitle);
    SetColor(White);
    OutTextXY(Left + 4, Top + 4, Title);
    SetColor(ColBor);
    Rectangle(Left, Top, Right, Bottom);
  end;

  with Fil do
  begin
    SetColor(White);
    OutTextXY(Left, Top - TextHeight(Name) - 2, Name);
    SetFillStyle(SolidFill, ColBkFile);
    if Left <> Right then
    begin
      bar(Left, Top, Right, Bottom);
      SetColor(ColBor);
      Rectangle(Left, Top, Right, Bottom);
    end;
  end;

  N := 0;

  with Bt1 do
  begin
    SetFillStyle(SolidFill, ColBt);
    bar(Left, Top, Right, Bottom);
    SetColor(White);
    OutTextXY(Left + (Right - Left - TextWidth(Title)) div 2,
              Top + TextHeight(Title) div 2 - 1, Title);
    SetColor(ColBor);
    Rectangle(Left, Top, Right, Bottom);

    Inc(N);
    Items[N].X1 := Left;
    Items[N].Y1 := Top;
    Items[N].X2 := Right;
    Items[N].Y2 := Bottom;
    Items[N].Butt := LeftButton;
    Items[N].Key := 1;
    AddMouseItem(Items[N]);
  end;

  with Bt2 do
  begin
    SetFillStyle(SolidFill, ColBt);
    bar(Left, Top, Right, Bottom);
    SetColor(White);
    OutTextXY(Left + (Right - Left - TextWidth(Title)) div 2,
              Top + TextHeight(Title) div 2 - 1, Title);
    SetColor(ColBor);
    Rectangle(Left, Top, Right, Bottom);

    Inc(N);
    Items[N].X1 := Left;
    Items[N].Y1 := Top;
    Items[N].X2 := Right;
    Items[N].Y2 := Bottom;
    Items[N].Butt := LeftButton;
    Items[N].Key := 2;
    AddMouseItem(Items[N]);
  end;

  with OldStyleT Do
  begin
    SetTextJustify(Horiz, Vert);
    SetTextStyle(Font, Direction, CharSize);
  end;
  with FillInfo Do SetFillStyle(Pattern, Color);

  SetColor(OldCol);
end;

end.
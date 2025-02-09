unit G_DRAWS;
                  INTERFACE
const
  EraserTab = 2;                 {����� �� ��誨}
  BrushRadius = 3;

type
  EraserD = record               {��� ���ᮢ�� १����}
    X, Y: Integer;               {�� ���न����}
    Col: Word;                   {� 梥�}
  end;

procedure Doters(MWX1, MWY1, MWX2, MWY2: Integer; AcCol: Word);
procedure GetColsEraserCut(Value: Integer);
procedure DrawEraser(Value: Integer);
procedure Eraser(MWX1, MWY1, MWX2, MWY2: Integer; Value: Integer);
procedure Pencil(MWX1, MWY1, MWX2, MWY2: Integer; AcCol: Word);
procedure Painbrush(MWX1, MWY1, MWX2, MWY2: Integer; AcCol, Brush: Word);
procedure Straight_line(MWX1, MWY1, MWX2, MWY2: Integer; AcCol, Thik: Word);
procedure Polyline(MWX1, MWY1, MWX2, MWY2: Integer; AcCol, Thik: Word);
procedure Oval(MWX1, MWY1, MWX2, MWY2: Integer; AcCol, Thik, Fil: Word);
procedure Rec(MWX1, MWY1, MWX2, MWY2: Integer; AcCol, Thik, Fil: Word);
procedure Spray(MWX1, MWY1, MWX2, MWY2: Integer; AcCol, Value: Word);
procedure Filling(MWX1, MWY1, MWX2, MWY2: Integer; AcCol: Word);

var
  EraserAr: array[1..10,1..4] of EraserD;  {梥� �� ����� ������뢠����}
  XEraser, YEraser: Integer;                  {��������� १����}

                IMPLEMENTATION
uses F_MOUSE, GRAPH, MyUnit;

var
  CutCols: array[1..10000] of EraserD;   {梥� ����� ����뢠�� १����}

procedure Doters(MWX1, MWY1, MWX2, MWY2: Integer; AcCol: Word);
var
  MWX, MWY: Integer;
begin
  MWX := 0;       MWY := 0;
  while true do
  begin
    MouseWindow(MWX1, MWY1, MWX2, MWY2);
    if MousePressed then
      if (MWX <> MouseWhereX)or(MWY <> MouseWhereY) then
        begin
          PutPixel(MouseWhereX - 2, MouseWhereY - 2, AcCol);
          MWX := MouseWhereX;   MWY := MouseWhereY;
        end
      else
    else
      begin
        MouseScreen;
        break;
      end;
  end;
end;
{=================End Doters===================================}

procedure GetColsEraserCut(Value: Integer);
{��࠭�� 梥�, ����� ������� �ᮢ���� १����
VAlye - �ਭ� १����}
var
  i: Integer;
  WX, WY: Integer;
begin
  WX := MouseWhereX;  WY := MouseWhereY;

  for i := 1 to Value + 1 do
      begin
    {᫥�� ���ࠢ� ������ �����}
        EraserAr[i, 1].Col := GetPixel(WX - Value - EraserTab - 1 + i,
                                   WY - Value - EraserTab);
        EraserAr[i, 1].X := WX - Value - EraserTab - 1 + i;
        EraserAr[i, 1].Y := WY - Value - EraserTab;
    {ᢥ��� ���� �ࠢ��}
        EraserAr[i, 2].Col := GetPixel(WX - EraserTab,
                                   WY - Value - EraserTab - 1 + i);
        EraserAr[i, 2].X := WX - EraserTab;
        EraserAr[i, 2].Y := WY - Value - EraserTab - 1 + i;
    {᫥�� �� �ࠢ� ������}
        EraserAr[i, 3].Col := GetPixel(WX - Value - EraserTab - 1 + i,
                                   WY - EraserTab);
        EraserAr[i, 3].X := WX - Value - EraserTab - 1 + i;
        EraserAr[i, 3].Y := WY - EraserTab;
    {ᢥ��� ���� �����}
        EraserAr[i, 4].Col := GetPixel(WX - Value - EraserTab,
                                   WY - Value - EraserTab - 1 + i);
        EraserAr[i, 4].X := WX - Value - EraserTab;
        EraserAr[i, 4].Y := WY - Value - EraserTab - 1 + i;
     end;
  XEraser := MouseWhereX;    YEraser := MouseWhereY;
end;
{=================End GetColEraserCut===================================}

procedure DrawEraser(Value: Integer);
var
  i, j: Integer;
  OldCol: Word;
begin
  HideMouse;
  if (XEraser = 0) and (YEraser = 0) then
    begin
    {��室 � ������ ���孥�� �� �ᮢ�� ��५��}

     GetColsEraserCut(Value);

     OldCol := GetColor;
     SetColor(Black);
     Rectangle(MouseWhereX - Value - EraserTab, MouseWhereY - Value - EraserTab,
               MouseWhereX - EraserTab, MouseWhereY - EraserTab);
     SetColor(OldCol);
    end
  else
    begin
      for i := 1 to Value + 1 do
        for j := 1 to 4 do
          PutPixel(EraserAr[i, j].X, EraserAr[i, j].Y, EraserAr[i, j].Col);

      GetColsEraserCut(Value);
      OldCol := GetColor;   SetColor(Black);
      Rectangle(MouseWhereX - Value - EraserTab, MouseWhereY - Value - EraserTab,
               MouseWhereX - EraserTab, MouseWhereY - EraserTab);
      SetColor(OldCol);
    end;
  ShowMouse;
end;
{=================End DrawEraser===================================}

procedure Eraser(MWX1, MWY1, MWX2, MWY2: Integer; Value: Integer);
var
  OldCol: Word;
  i, j: Integer;
  WX, WY: Integer;
begin
  OldCol := GetColor;  WX := 0;      WY := 0;
  while true do
  begin
    MouseWindow(MWX1, MWY1, MWX2, MWY2);
    if MousePressed then
       if (WX <> MouseWhereX)or(WY <> MouseWhereY) then
         begin
           DrawEraser(Value);  SetColor(White);
           SetFillStyle(SolidFill, White);
           Bar(MouseWhereX - Value - EraserTab, MouseWhereY - Value - EraserTab,
               MouseWhereX - EraserTab, MouseWhereY - EraserTab);
           SetColor(OldCol);   DrawEraser(Value);
           WX := XEraser;    WY := YEraser;
         end
       else
    else
      begin
        MouseScreen;
        break;
      end;
  end;
  SetFillStyle(SolidFill, OldCol);
end;
{=================End Eraser===================================}

procedure Pencil(MWX1, MWY1, MWX2, MWY2: Integer; AcCol: Word);
var
  OldStyle : LineSettingsType;
  OldCol: Word;
  X1, Y1: Integer;
begin
  GetLineSettings(OldStyle);    OldCol := GetColor;
  X1 := 0;      Y1 := 0;

  while true do
  begin
    MouseWindow(MWX1, MWY1, MWX2, MWY2);
    if MousePressed then
     if (X1>0)and(Y1>0) then
      if ((X1 <> MouseWhereX - 2)or(Y1 <> MouseWhereY - 2)) then
        begin
          HideMouse;
          SetLineStyle(0, 0, NormWidth);  SetColor(AcCol);
          LineTo(MouseWhereX - 2, MouseWhereY - 2);
          X1 := MouseWhereX - 2;   Y1 := MouseWhereY - 2;
          ShowMouse;
        end
       else   {if ((X1 <> MouseWhereX - 2)or(Y1 <> MouseWhereY - 2))}
     else {(X1>0)and(Y1>0)}
        begin
          X1 := MouseWhereX - 2;    Y1 := MouseWhereY - 2;
          MoveTo(X1, Y1);
        end
    else
      begin
        MouseScreen;
        break;
      end;
  end;

  SetColor(OldCol);
  with OldStyle Do SetLineStyle(LineStyle, Pattern, Thickness);
end;
{=================End Pencil===================================}

procedure Painbrush(MWX1, MWY1, MWX2, MWY2: Integer; AcCol, Brush: Word);
var
  OldStyle : FillSettingsType;
  OldCol: Word;
  X1, Y1, i: Integer;
  MX, MY: Integer;
  Yc: Integer;
begin
  GetFillSettings(OldStyle);   OldCol := GetColor;
  X1 := 0;               Y1 := 0;
  SetFillStyle(SolidFill, AcCol);     SetColor(AcCol);
  while true do
  begin
    MouseWindow(MWX1, MWY1, MWX2, MWY2);
    if MousePressed then
     if (X1>0)and(Y1>0) then
      if ((X1 <> MouseWhereX - 2)or(Y1 <> MouseWhereY - 2)) then
        begin
          HideMouse;
          MX := MouseWhereX - 2;  MY := MouseWhereY - 2;
          if X1 > MX then
            for i := X1 downto MX do
              begin
                Yc := ((i - X1) * (MY - Y1) div (MX - X1) + Y1);
                if Brush = 1 then
                  PieSlice(i - 2, Yc - 2, 0, 359, BrushRadius)
                else
                  bar(i - 2 - BrushRadius, Yc - 2 - BrushRadius,
                      i - 2 + BrushRadius, Yc - 2 + BrushRadius);
              end
          else
            if X1 < MX then
              for i := X1 to MX do
              begin
                Yc := ((i - X1) * (MY - Y1) div (MX - X1) + Y1);
                if Brush = 1 then
                  PieSlice(i - 2, Yc - 2, 0, 359, BrushRadius)
                else
                  bar(i - 2 - BrushRadius, Yc - 2 - BrushRadius,
                      i - 2 + BrushRadius, Yc - 2 + BrushRadius);
              end
            else if Y1 > MY then
                   for i := Y1 downto MY do
                     if Brush = 1 then
                       PieSlice(X1 - 2, i - 2, 0, 359, BrushRadius)
                     else
                       bar(X1 - 2 - BrushRadius, i - 2 - BrushRadius,
                           X1 - 2 + BrushRadius, i - 2 + BrushRadius)
                 else
                   for i := Y1 to MY do
                     if  Brush = 1 then
                       PieSlice(X1 - 2, i - 2, 0, 359, BrushRadius)
                     else
                       bar(X1 - 2 - BrushRadius, i - 2 - BrushRadius,
                           X1 - 2 + BrushRadius, i - 2 + BrushRadius);
          X1 := MouseWhereX - 2;     Y1 := MouseWhereY - 2;
          ShowMouse;
        end
       else   {if ((X1 <> MouseWhereX - 2)or(Y1 <> MouseWhereY - 2))}
     else {(X1>0)and(Y1>0)}
        begin
          HideMouse;
          X1 := MouseWhereX - 2;     Y1 := MouseWhereY - 2;

          if Brush = 1 then
            PieSlice(X1 - 2, Y1 - 2, 0, 359, BrushRadius)
          else
            bar(X1 - 2 - BrushRadius, Y1 - 2 - BrushRadius,
                X1 - 2 + BrushRadius, Y1 - 2 + BrushRadius);
          ShowMouse;
        end
    else
      begin
        MouseScreen;
        break;
      end;
  end;
  SetColor(OldCol);   with OldStyle Do SetFillStyle(Pattern, Color);
end;
{=================End Painbrush===================================}

procedure Straight_line(MWX1, MWY1, MWX2, MWY2: Integer; AcCol, Thik: Word);
var
  OldStyle : LineSettingsType;
  OldCol: Word;
  X1, Y1, X2, Y2, X1z, Y1z, X2z, Y2z, i: Integer;
  Yc, Xc, buf: Integer;
  P1, P2, P3, P4: Pointer;
  Size1, Size2, Size3, Size4: Integer;
begin
  GetLineSettings(OldStyle);  OldCol := GetColor;
  MouseWindow(MWX1, MWY1, MWX2, MWY2);
  X1 := MouseWhereX;  Y1 := MouseWhereY;
  X1z := X1;  Y1z := Y1;  X2 := X1;  Y2 := Y1;  X2z := X2;  Y2z := Y2;
  SetColor(AcCol);
  SetLineStyle(0, 0, Thik);
  P1 := Nil;  P2 := Nil;  P3 := Nil;  P4 := Nil;
  if Thik = 3 then
    buf := 3
  else
    buf := 0;


  while MousePressed do
  if (X2 <> MouseWhereX)or(Y2 <> MouseWhereY) then
  begin
     HideMouse;
     if P1 <> nil then
       begin
         PutImage(X1z - buf, Y1z - buf, P1^, NormalPut);
         FreeMem(P1, Size1);  P1 := nil;
       end;
     if P2 <> nil then
       begin
         PutImage(abs(Xc) - buf, Y1z - buf, P2^, NormalPut);
         FreeMem(P2, Size2);  P2 := nil;
       end;
     if P3 <> nil then
       begin
         PutImage(X1z - buf, abs(Yc) - buf, P3^, NormalPut);
         FreeMem(P3, Size3);  P3 := nil;
       end;
     if P4 <> nil then
       begin
         PutImage(abs(Xc) - buf, abs(Yc) - buf, P4^, NormalPut);
         FreeMem(P4, Size4);  P4 := nil;
       end;
     if X1 > X2 then
       begin
         X1z := X2;  X2z := X1;
       end
     else
       begin
         X1z := X1;  X2z := X2;
       end;
     if Y1 > Y2 then
       begin
         Y1z := Y2;  Y2z := Y1;
       end
     else
       begin
         Y1z := Y1;  Y2z := Y2;
       end;

     Xc := (X2z - X1z) div 2 + X1z;  Yc := (Y2z - Y1z) div 2 + Y1z;

     Size1 := ImageSize(X1z - buf, Y1z - buf, abs(Xc) + buf, abs(Yc) + buf);
     GetMem(P1, Size1);  GetImage(X1z - buf, Y1z - buf, abs(Xc) + buf, abs(Yc) + buf, P1^);

     Size2 := ImageSize(abs(Xc) - buf, Y1z - buf, X2z + buf, abs(Yc) + buf);
     GetMem(P2, Size2);  GetImage(abs(Xc) - buf, Y1z - buf, X2z + buf, abs(Yc) + buf, P2^);

     Size3 := ImageSize(X1z - buf, abs(Yc) - buf, abs(Xc) + buf, Y2z + buf);
     GetMem(P3, Size3);  GetImage(X1z - buf, abs(Yc) - buf, abs(Xc) + buf, Y2z + buf, P3^);

     Size4 := ImageSize(abs(Xc) - buf, abs(Yc) - buf, X2z + buf, Y2z + buf);
     GetMem(P4, Size4);  GetImage(abs(Xc) - buf, abs(Yc) - buf, X2z + buf, Y2z + buf, P4^);

     Line(X1, Y1, X2, Y2);

     X2 := MouseWhereX;  Y2 := MouseWhereY;
     ShowMouse;
  end;
  MouseScreen;  SetColor(OldCol);
  with OldStyle Do SetLineStyle(LineStyle, Pattern, 1);
end;
{=================End Straight_line===================================}

procedure Polyline(MWX1, MWY1, MWX2, MWY2: Integer; AcCol, Thik: Word);
var
  OldStyle : LineSettingsType;
  OldCol: Word;
  X1, Y1: Integer;
  Butt, X, Y: Integer;
begin
  GetLineSettings(OldStyle); OldCol := GetColor; GetMouseState(Butt, X, Y);
  X1 := 0;   Y1 := 0;
  MouseWindow(MWX1, MWY1, MWX2, MWY2);
  while true do
    if MousePressed then
    begin
      GetMouseState(Butt, X, Y);
      if (X1 > 0)and(Y1 > 0) then
        if (Butt = 1)and((X <> X1)or(Y <> Y1)) then
          begin
            HideMouse;  SetColor(AcCol);
            SetLineStyle(0, 0, Thik);
            LineTo(X - 2, Y - 2);
            X1 := X;   Y1 := Y;
            ShowMouse;
          end  {(Butt = 1)and((X <> X1)or(Y <> Y1))}
        else if Butt = 2 then
               break
             else {Butt = 2}
      else {(X1 > 0)and(Y1 > 0)}
        begin
          HideMouse;  X1 := X;  Y1 := Y;
          MoveTo(X1 - 2, Y1 - 2);
          PutPixel(X - 2, Y - 2, AcCol);
          ShowMouse;
        end; {(X1 > 0)and(Y1 > 0)}
    end;
  MouseScreen;  SetColor(OldCol);
  with OldStyle Do SetLineStyle(LineStyle, Pattern, 1);
end;
{=================End Polyline===================================}

procedure MyOval(Left, Top, Right, Bottom: Integer);
type
  TOval = record
    X, Y: Integer;
  end;
var
  i, y, Xc, Yc, Xr, Yr, Index: Integer;
  ar: array[1..1000] of TOval;
begin
  Xr := (Right - Left) div 2;
  Yr := (Bottom - Top) div 2;
  Xc := Left + Xr;
  Yc := Top + Yr;

  Index := 0;


  for i := abs(Xr) downto - abs(Xr) do
  begin
    inc(Index);
    ar[Index].X := Xc + i;

    y := Round(Yr * sqrt(1 - sqr( i / Xr)));

    ar[Index].Y := Yc - y;
  end;

  FillPoly(SizeOf(TOval) * Index Div SizeOf(PointType), ar);

  Index := 0;
  for i := - abs(Xr) to abs(Xr) do
  begin
    inc(Index);
    ar[Index].X := Xc + i;

    y := Round(Yr * sqrt(1 - sqr( i / Xr)));

    ar[Index].Y := Yc + y;
  end;
  FillPoly(SizeOf(TOval) * Index Div SizeOf(PointType), ar);
end;

procedure Oval(MWX1, MWY1, MWX2, MWY2: Integer; AcCol, Thik, Fil: Word);
var
  X1, Y1, Xc, Yc, Xr, Yr, Y: Integer;
  X2, Y2: Integer;
  OldCol: Word;
  Size1, Size2, Size3, Size4: Integer;
  P1, P2, P3, P4: Pointer;
  Buf: Integer;
  OldStyle : LineSettingsType;
begin
  GetLineSettings(OldStyle);
  OldCol := GetColor;  MouseWindow(MWX1, MWY1, MWX2, MWY2);
  X1 := MouseWhereX;   Y1 := MouseWhereY;
  X2 := X1;            Y2 := Y1;
  P1 := nil;  P2 := nil;  P3 := nil;  P4 := nil;   buf := 0;

  SetColor(AcCOl);
  SetLineStyle(0, 0, Thik);
  while MousePressed do
  if (X2 <> MouseWhereX) or (Y2 <> MouseWhereY) then
  begin
    HideMouse;

    if P1 <> nil then
      begin
        PutImage(Xc - abs(Xr) - Buf, Yc - abs(Yr) - Buf, P1^, NormalPut);
        FreeMem(P1, Size1);  P1 := nil;
      end;

    if P2 <> nil then
      begin
        PutImage(Xc - Buf, Yc - abs(Yr) - Buf, P2^, NormalPut);
        FreeMem(P2, Size2);  P2 := nil;
      end;

    if P3 <> nil then
      begin
        PutImage(Xc - abs(Xr) - Buf, Yc - Buf, P3^, NormalPut);
        FreeMem(P3, Size3);  P3 := nil;
      end;

    if P4 <> nil then
      begin
        PutImage(Xc - Buf, Yc - Buf, P4^, NormalPut);
        FreeMem(P4, Size4);  P4 := nil;
      end;

    Xr := (X2 - X1) div 2;  Yr := (Y2 - Y1) div 2;
    Xc := Xr + X1;          Yc := Yr + Y1;

    if (Xr = 0) or (Yr = 0) or (Thik = 3) then
      buf := 3
    else
      buf := 0;

    Size1 := ImageSize(Xc - abs(Xr) - Buf, Yc - abs(Yr) - Buf, Xc + Buf, Yc + Buf);
    GetMem(P1, Size1);   { ���।��塞 ������ � ��� }
    GetImage(Xc - abs(Xr) - Buf, Yc - abs(Yr) - Buf, Xc + Buf, Yc + Buf, P1^);

    Size2 := ImageSize(Xc - Buf, Yc - abs(Yr) - Buf, Xc + abs(Xr) + Buf, Yc + Buf);
    GetMem(P2, Size2);   { ���।��塞 ������ � ��� }
    GetImage(Xc - Buf, Yc - abs(Yr) - Buf, Xc + abs(Xr), Yc + Buf, P2^);

    Size3 := ImageSize(Xc - abs(Xr) - Buf, Yc - Buf, Xc + Buf, Yc + abs(Yr) + Buf);
    GetMem(P3, Size3);   { ���।��塞 ������ � ��� }
    GetImage(Xc - abs(Xr) - Buf, Yc - Buf, Xc, Yc + abs(Yr) + Buf, P3^);

    Size4 := ImageSize(Xc - Buf, Yc - Buf, Xc + abs(Xr) + Buf, Yc + abs(Yr) + Buf);
    GetMem(P4, Size4);   { ���।��塞 ������ � ��� }
    GetImage(Xc - Buf, Yc - Buf, Xc + abs(Xr) + Buf, Yc + abs(Yr) + Buf, P4^);

    if (Xr = 0)or(Yr = 0) then
      line(X1, Y1, X2, Y2)
    else
      if Fil = 3 then
        begin
          SetFillStyle(SolidFill, AcCol);
          MyOval(X1, Y1, X2, Y2);
        end
      else
       begin
         SetColor(AcCol);
         Ellipse(Xc, Yc, 0, 360, Xr, Yr);
       end;


    X2 := MouseWhereX;  Y2 := MouseWhereY;   ShowMouse;
  end
  else
    begin
      X2 := MouseWhereX;  Y2 := MouseWhereY;
    end;
  SetColor(OldCol);  MouseScreen;
  with OldStyle Do SetLineStyle(LineStyle, Pattern, 1);
end;
{=================End Oval===================================}

procedure Rec(MWX1, MWY1, MWX2, MWY2: Integer; AcCol, Thik, Fil: Word);
var
  X1, Y1, X2, Y2, Xc, Xr, Yc, Yr: Integer;
  OldCol: Word;
  Count: Integer;
  OldStyle : LineSettingsType;
  P1, P2, P3, P4: Pointer;
  Size1, Size2, Size3, Size4: Integer;
  Buf: Integer;
  FillInfo : FillSettingsType;
begin
  GetLineSettings(OldStyle);  GetFillSettings(FillInfo);   { ���࠭塞 �⨫� � 梥� ����᪨ }
  OldCol := GetColor;  MouseWindow(MWX1, MWY1, MWX2, MWY2);
  X1 := MouseWhereX;   Y1 := MouseWhereY;
  X2 := X1;            Y2 := Y1;
  P1 := nil;  P2 := nil;  P3 := nil;  P4 := nil;   buf := 0;

  SetColor(AcCol);
  SetFillStyle(SolidFill, AcCol);   { ���� �⨫� }
  SetLineStyle(0, 0, Thik);
  while MousePressed do
  if (X2 <> MouseWhereX) or (Y2 <> MouseWhereY) then
  begin
    HideMouse;

    if P1 <> nil then
      begin
        PutImage(Xc - abs(Xr) - Buf, Yc - abs(Yr) - Buf, P1^, NormalPut);
        FreeMem(P1, Size1);  P1 := nil;
      end;

    if P2 <> nil then
      begin
        PutImage(Xc - Buf, Yc - abs(Yr) - Buf, P2^, NormalPut);
        FreeMem(P2, Size2);  P2 := nil;
      end;

    if P3 <> nil then
      begin
        PutImage(Xc - abs(Xr) - Buf, Yc - Buf, P3^, NormalPut);
        FreeMem(P3, Size3);  P3 := nil;
      end;

    if P4 <> nil then
      begin
        PutImage(Xc - Buf, Yc - Buf, P4^, NormalPut);
        FreeMem(P4, Size4);  P4 := nil;
      end;

    Xr := (X2 - X1) div 2;  Yr := (Y2 - Y1) div 2;
    Xc := Xr + X1;          Yc := Yr + Y1;

    if (Xr = 0) or (Yr = 0) or (Thik = 3) then
      buf := 3
    else
      buf := 1;

    Size1 := ImageSize(Xc - abs(Xr) - Buf, Yc - abs(Yr) - Buf, Xc + Buf, Yc + Buf);
    GetMem(P1, Size1);   { ���।��塞 ������ � ��� }
    GetImage(Xc - abs(Xr) - Buf, Yc - abs(Yr) - Buf, Xc + Buf, Yc + Buf, P1^);

    Size2 := ImageSize(Xc - Buf, Yc - abs(Yr) - Buf, Xc + abs(Xr) + Buf, Yc + Buf);
    GetMem(P2, Size2);   { ���।��塞 ������ � ��� }
    GetImage(Xc - Buf, Yc - abs(Yr) - Buf, Xc + abs(Xr) + Buf, Yc + Buf, P2^);

    Size3 := ImageSize(Xc - abs(Xr) - Buf, Yc - Buf, Xc + Buf, Yc + abs(Yr) + Buf);
    GetMem(P3, Size3);   { ���।��塞 ������ � ��� }
    GetImage(Xc - abs(Xr) - Buf, Yc - Buf, Xc, Yc + abs(Yr) + Buf, P3^);

    Size4 := ImageSize(Xc - Buf, Yc - Buf, Xc + abs(Xr) + Buf, Yc + abs(Yr) + Buf);
    GetMem(P4, Size4);   { ���।��塞 ������ � ��� }
    GetImage(Xc - Buf, Yc - Buf, Xc + abs(Xr) + Buf, Yc + abs(Yr) + Buf, P4^);

    if Fil = 3 then
      bar(X1, Y1, X2, Y2)
    else
      Rectangle(X1, Y1, X2, Y2);

    X2 := MouseWhereX;  Y2 := MouseWhereY;   ShowMouse;
  end
  else
    begin
      X2 := MouseWhereX;  Y2 := MouseWhereY;
    end;
  SetColor(OldCol);  MouseScreen;
  with OldStyle Do SetLineStyle(LineStyle, Pattern, 1);
  with FillInfo Do SetFillStyle(Pattern, Color);
end;
{=================End Rec===================================}

procedure Spray(MWX1, MWY1, MWX2, MWY2: Integer; AcCol, Value: Word);
var
  i, k, rx: Integer;
  Xc, Yc, ang: Integer;
  OldCol: Word;
begin
  OldCol := GetColor;  MouseWindow(MWX1, MWY1, MWX2, MWY2);
  SetColor(AcCol);

  while MousePressed do
  begin
    Randomize;  HideMouse;
    Xc := MouseWhereX;  Yc := MouseWhereY;

    for k := 0 to 3 do
    for i := 1 to 2 * Value div 3 do
      begin
        ang := random(91) + k * 90;
        Arc(Xc, Yc, ang, ang + 1, random(Value) + 1);
      end;
    ShowMouse;
  end;
  SetColor(OldCol);  MouseScreen;
end;
{=================End Spray===================================}

procedure Filling(MWX1, MWY1, MWX2, MWY2: Integer; AcCol: Word);
type
  List = ^TFill;
  TFill = record
    X, Y: Integer;
    Prev: List;
  end;
  Cor = record
    X, Y: Integer;
  end;
var
  OldCol: Word;
  First, Tek: List;
  was, Ending: Boolean;
  ar: array[1..1500] of Cor;
  Index: Integer;

  function Fill(X, Y, MWX1, MWY1, MWX2, MWY2: Integer; Col: Word): Boolean;
  var
    P: List;
    mem: Integer;
  label again;
  begin
    Ending := False;
    Index := 0;
  again:
    PutPixel(X, Y, AcCol);
    if (GetPixel(X + 1, Y) = Col)and(X + 1 <= MWX2)  then
         if not Ending then
         begin
           GetMem(P, SizeOf(TFill));  P^.X := X + 1;  P^.Y := Y;  P^.Prev := Tek;  Tek := P;
           was := True;  Inc(X);

           if MemAvail < 3 * SizeOf(P)  then Ending := True;
           goto again
         end
         else
             if Tek^.Prev = nil then Fill := True
             else
             begin
                 Inc(Index);
                 ar[Index].X := Tek^.X + 1;
                 ar[Index].Y := Tek^.Y;
                 P := Tek;
                 Tek := Tek^.Prev;
                         if P = nil then
                           P := nil
                         else
                           FreeMem(P, SizeOf(TFill));
                 P := nil;
                 X := Tek^.X;
                 Y := Tek^.Y;
                 goto again;
             end
    else if (GetPixel(X, Y + 1) = Col)and(Y + 1 <= MWY2) then
           if not Ending then
           begin
             GetMem(P, SizeOf(TFill));;  P^.X := X;  P^.Y := Y + 1;  P^.Prev := Tek;  Tek := P;
             was := True;  Inc(Y);

             if MemAvail < 3 * SizeOf(P)  then  Ending := True;
             goto again
           end
           else
               if Tek^.Prev = nil then Fill := True
               else
               begin
                 Inc(Index);
                 ar[Index].X := Tek^.X;
                 ar[Index].Y := Tek^.Y + 1;
                 P := Tek;  Tek := Tek^.Prev;
                         if P = nil then
                           P := nil
                         else
                           FreeMem(P, SizeOf(TFill));
                 P := nil;
                 X := Tek^.X;
                 Y := Tek^.Y;
                 goto again;
               end
         else if (GetPixel(X - 1, Y) = Col)and(X - 1 >= MWX1) then
                if not Ending then
                begin
                  GetMem(P, SizeOf(TFill));  P^.X := X - 1;   P^.Y := Y;
                  P^.Prev := Tek;  Tek := P;   was := True;
                  Dec(X);
                  if MemAvail < 3 * SizeOf(P)  then Ending := True;
                  goto again;
                 end
                else
                  if Tek^.Prev = nil then Fill := True
                  else
                    begin
                      Inc(Index);
                      ar[Index].X := Tek^.X - 1;
                      ar[Index].X := Tek^.Y;
                      P := Tek;  Tek := Tek^.Prev;
                         if P = nil then
                           P := nil
                         else
                           FreeMem(P, SizeOf(TFill));
                      P := nil;
                      X := Tek^.X;
                      Y := Tek^.Y;
                      goto again;
                    end
              else if (GetPixel(X, Y - 1) = Col)and(Y - 1 >= MWY1) then
                     if not Ending then
                     begin
                       GetMem(P, SizeOf(TFill));  P^.X := X;   P^.Y := Y - 1;
                       P^.Prev := Tek;  Tek := P;  was := True;
                       Dec(Y);
                       if MemAvail < 3 * SizeOf(P)  then Ending := True;
                       goto again
                     end
                     else
                       if Tek^.Prev = nil then Fill := True
                       else
                       begin
                         Inc(Index);
                         ar[Index].X := Tek^.X;
                         ar[Index].Y := Tek^.Y - 1;
                         P := Tek;
                         Tek := Tek^.Prev;
                         if P = nil then
                           P := nil
                         else
                           FreeMem(P, SizeOf(TFill));

                         P := nil;
                         X := Tek^.X;
                         Y := Tek^.Y;
                         goto again;
                       end
                   else
                      if Tek^.Prev = nil then fill := true
                      else
                        begin
                          P := Tek;     Tek := Tek^.Prev;
                         if P = nil then
                           P := nil
                         else
                           FreeMem(P, SizeOf(TFill));

                          P := nil;
                          X := Tek^.X;  Y := Tek^.Y;
                          goto again;
                        end
  end;
begin
  HideMouse;  OldCol := GetColor;

  New(First);  New(Tek);
  First^.X := MouseWhereX;    First^.Y := MouseWhereY;
  First^.Prev := nil;         Tek := First;

  was := True;
  fill(First^.X, First^.Y, MWX1, MWY1, MWX2, MWY2, GetPixel(First^.X, First^.Y));
  Dispose(First);  ShowMouse;
end;
{=================End Filling===================================}

end.

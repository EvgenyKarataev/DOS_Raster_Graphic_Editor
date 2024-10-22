{
11-doters
2-eraser
3-pencil
4-painbrush
5-straight_line
6-polyline
7-oval
8-rec
9-spray
10-filling
 }
uses F_MOUSE, GRAPH, CRT, MyUnit, G_Draws;
type
  kep = file of Word;            {�ଠ� 䠩��}

const
  Title1 = '"Graphic Editor 5.9"';  {������� � ���������}
  Title = Title1 + ' |  kzheka@sibmail.com  TUSUR, KSUP  |  Copyright 2007';
  TLBTitle = 'F6 Clear |  F2  Save  |  F3  Open'; {�뢮� ⥪��}
  TRBTitle = 'F10  Exit';            {� �� ������ ⥪��}
  NCol = 16;                     {������� 梥⮢}
  NButs = 10;                    {������⢮ ������ � ������}
  NButsLine = 2;                 {������� ������ � ���}
  ButWidth = 20;                 {�ਭ� ������}
  ModeWid = 36;
  ModeHeight = 25;
  ButHeight = 12;                {���� ������}
  TabBut = 5;                    {����� �� �ࠥ� � �� ��㣨� ������}
  SelButCol = 9;
  ColBut = DarkGray;             {梥� ������}
  ColBottomPanel = LightBlue;    {梥� ������ ������}
  ColHeadPanel = LightBlue;      {梥� ���孥� ������}
  ColPanel = LightGray;          {梥� ������}
  BorCol = Black;                {梥� �࠭��}
  BorWidth = 1;                  {�ਭ� �࠭��}
  BottomPanelHeight = 17;        {���� ������ ������}
  HeadPanelHeight = 17;          {���� ���孥� ������}
  TabTextX = 10;                 {����ﭨ� ����� ������ﬨ}
  PrHeight = 10;                 {���� ������ �ண���}
  ColWid = 10;                   {�ਭ� � ���� ������� � 梥⮬}
  LineWid = 1;                   {�ਭ� �����}
  ShMCol = 1;
  LMCol = 1;

var
  ButPanel: array[1..NButs + NCol + 5] of TButton;   {ᮤ�ন� ������}
  Modes: TObject;
  ar: Mas;
  OldBut: Integer;                        {���� ������ �� ����⨨}
  Items: array[1..NButs + 10 + NCol] of MouseItemType;  {�࠭��� ������ ������}
  LeftPanel, BottomPanel, HeadPanel: TObject;      {�����쪨}
  Table: TObject;                              {���� ��� �ᮢ����}
  N: Integer;                                {������� �������}
  OldMouseX, OldMouseY: Integer;      {���न���� ��� ��� ����⠭�������}
  Progress: TProgress;
  AcCol, AcCol1: Word;                        {⥪�騩 梥�}
  AcThick: Word;
  AcBut, AcColIndex: Integer;                     {⥪��� ������}
  k, z, i: Integer;               {?}
  MWX, MWY: Integer;            {��� ���� � ��� ���� �}
  OldXMode, OldYMode: Integer;
  Thik, Fil, Brush, EraserWid, Radius: Byte;
  ModeVis, Modify, BCL: Boolean;
  Ch1, Ch2: Char;
  Path: string;
  Win: TWin;
  FilBk: TFIle;
  Bt1, Bt2: TBt;
  AfterOkOrCancel: Word;

procedure InitG;
{����⮢�� ����᪮�� ०���}
var
  d, r, h: Integer;
  Path: string;
begin
  clrscr;
  d := Detect;
  readln(Path);
  InitGraph(d, r, Path);
  if GraphResult <> grOk then           {�᫨ �訡�� � ��室}
    begin
      writeln('Error');
      readkey;
      exit;
    end;

  TextRatioY := 1;                      {�����樥��� �८�ࠧ������}
  TextRatioX := 1;                                   {-//-}
end;
{=================End InitGraph===================================}

procedure InitPanels;
{���ᮢ�� �������}
var
   TabY: Integer;
begin
  N := 0;            {�砫� ��� �������}

  with LeftPanel do  {������ � �������� ᫥��}
  begin
    SetLeft(0);             {���� ���न��� 0}
    SetTop(HeadPanelHeight);      {������ ����㯠�� �� ����� ���������}
    SetWidth(ButWidth * NButsLine + TabBut * (NButsLine + 1));{�ਭ�}
    SetHeight(GetMaxY - BottomPanelHeight);            {����}
    SetStyle(SolidFill);      {�⨫� = ��������� ����訢���}
    SetCol(ColPanel);         {梥� �����쪨}
    SetBorder(BorWidth);

    Draw;                     {� �� ���ᮢ��}
  end;

  with Modes do
  begin
    SetLeft((LeftPanel.GetWidth - ModeWid) div 2);             {���� ���न��� 0}
    SetTop(TabBut *  (NButs + 5) + ButHeight * (NButs div 2) + HeadPanel.GetBottom);
    SetWidth(ModeWid);{�ਭ�}
    SetHeight(ModeHeight);            {����}
    SetStyle(SolidFill);      {�⨫� = ��������� ����訢���}
    SetCol(ColPanel);         {梥� �����쪨}
    SetBorder(BorWidth);
    SetBorderCol(DarkGray);
    Draw;               {� �� ���ᮢ��}
  end;

  with HeadPanel do      {���������}
  begin
    SetLeft(0);          {����� ���न���}
    SetTop(0);           {������}
    SetWidth(GetMaxX);         {�ਭ� �� ���� ��࠭}
    SetHeight(HeadPanelHeight);    {�� ����}
    SetStyle(SolidFill);    {�⨫� = ��������� ����訢���}
    SetCol(ColHeadPanel);   {ᨭ�� 梥�}
    SetBorder(BorWidth);    {� �� ���� �࠭��}
    SetBorderCol(BorCol);   {� � ��� ���� �� 梥�}
    Draw;                  {� �� ���ᮢ��}

    OutTextXY(TabTextX, (HeadPanelHeight - TextHeight(Title)) div 2, Title);
  end;

  with Table do      {ࠡ��� ������}
  begin
    SetLeft(LeftPanel.GetRight + 1);  {����� ���न���}
    SetTop(HeadPanelHeight + 1);                {������}
    SetWidth(GetMaxX - LeftPanel.GetRight - 2); {�ਭ�}
    SetHeight(GetMaxY - BottomPanelHeight - 1 - HeadPanelHeight - 1);{����}
    SetStyle(SolidFill);  {�⨫� = ��������� ����訢���}
    SetCol(White);       {梥� ����}
    Draw;              {� �� ���ᮢ��}

    Inc(N);
    Items[N].X1 := GetLeft;   {������                      }
    Items[N].Y1 := GetTop;          {��                   }
    Items[N].X2 := GetRight;              {���न���         }
    Items[N].Y2 := GetBottom;
    Items[N].Butt := LeftButton;   {� �� ����� ������ ���� ॠ��஢���}
    Items[N].Key := 5;          {�� ᮮ⢥���� ��� 5}
    AddMouseItem(Items[N]);   {������塞 �� �ᥬ}
  end;

  with BottomPanel do  {��������� ������}
  begin
    SetLeft(0);                         {������                }
    SetTop(GetMaxY - BottomPanelHeight);     {  ��             }
    SetWidth(GetMaxX);                         {   ���न���}
    SetHeight(BottomPanelHeight);
    SetStyle(SolidFill);              {�⨫� = ��������� ����訢���}
    SetCol(ColBottomPanel);           {�� 梥�}
    SetBorder(BorWidth);            {� ⠪�� ���� �࠭��}
    SetBorderCol(BorCol);          {� �� 梥�}
    Draw;                          {�� ���ᮢ��}

    OutTextXY(TabTextX,
        GetTop + (BottomPanelHeight - TextHeight(TLBTitle)) div 2, TLBTitle);

    OutTextXY(GetMaxX - TabTextX - TextWidth(TRBTitle),
          GetTop + (BottomPanelHeight - TextHeight(TRBTitle)) div 2, TRBTitle);

    {� ⥯��� ����� ॠ��� �� ������ �� ⥪���}
    {����� ���� �6}
    Inc(N);
    Items[N].X1 := 1;              {������    }
    Items[N].Y1 := GetTop + 1;            {���न��� }
    Items[N].X2 := 90;                           {    ⥪��}
    Items[N].Y2 := GetBottom - 1;
    Items[N].Butt := LeftButton;         {� �� ����� ������ ॠ��஢���}
    Items[N].Key := 64 shl 8;          {� �� ���}
    AddMouseItem(Items[N]);          {������塞 �� �ᥬ �������}

    {������ ��࠭��� �2}
    Inc(N);
    Items[N].X1 := 95;
    Items[N].Y1 := GetTop + 1;
    Items[N].X2 := 195;
    Items[N].Y2 := GetBottom - 1;
    Items[N].Butt := LeftButton;
    Items[N].Key := 60 shl 8;
    AddMouseItem(Items[N]);

    {������ ������ �3}
    Inc(N);
    Items[N].X1 := 198;
    Items[N].Y1 := GetTop + 1;
    Items[N].X2 := 300;
    Items[N].Y2 := GetBottom - 1;
    Items[N].Butt := LeftButton;
    Items[N].Key := 61 shl 8;
    AddMouseItem(Items[N]);

    {������ ��室 �10}
    Inc(N);
    Items[N].X1 := GetMaxX - 87;
    Items[N].Y1 := GetTop + 1;
    Items[N].X2 := GetMaxX - TabTextX + 2;
    Items[N].Y2 := GetBottom - 1;
    Items[N].Butt := LeftButton;
    Items[N].Key := 68 shl 8;
    AddMouseItem(Items[N]);
  end;

  with Progress do {����� �����}
  begin
    SetLeft(GetMaxX - 200);     {�� ���न����}
    TabY := (BottomPanel.GetBottom - BottomPanel.GetTop - PrHeight) div 2;
    SetTop(BottomPanel.GetTop + TabY);
    SetWidth((Table.GetRight - Table.GetLeft) div 6);
    SetHeight(PrHeight);        {����}
    SetStyle(SolidFill);        {�⨫� = ��������� ����訢���}
    SetStepColor(LightMagenta); {梥� ����������}
    SetBorder(1);               {�࠭�� = 1}
    SetBorderCol(Yellow);       {梥� �࠭���}
    SetStep(1);                 {����稭�� 蠣�}
  end;
end;
{=================End InitPanels===================================}

procedure DrawButton(Value: Integer);
{���� ������ � ������
 Value - ����� ������}
begin
  with ButPanel[Value] do
  case Value of
    1: DDots(GetLeft + 7, GetTop + 7, White);  {�窨}
    2: DRubber(GetLeft + 7, GetTop + 6, 4, 2, 3, White); {१����}
    3: DPencil(GetLeft + 5, GetTop + 9, White);          {��࠭���}
    4: DBrush(GetLeft + 5, GetTop + 4, White);           {�����}
    5: DSt_Line(GetLeft + 5, GetTop + 4, White);         {��ﬠ�}
    6: DPolyline(GetLeft + 5, GetTop + 3, White);        {�������}
    7: DOval(GetLeft + 4, GetTop + 2, White);            {����}
    8: DRec(GetLeft + 5, GetTop + 3, White);             {��אַ㣮�쭨�}
    9: DSpray(GetLeft + 8, GetTop + 2, White);
    10: DFill(GetLeft + 6, GetTop + 3, White);
  end;
end;
{=================End DrawButtons===================================}

procedure InitButtons;
{���ᮢ�� ������}
var
  i: Integer;
begin
  for i := 1 to NButs do  {������ �ᮢ����}
  with ButPanel[i] do
  begin
    if odd(i) then  {�᫨ �� ����� ������, �}
      begin
        SetLeft(TabBut);   {����� ���न��� = ������}
        SetTop(TabBut * i + ButHeight * ((i - 1) div 2) + HeadPanel.GetBottom);
      end
    else
      begin  {��ன �⮫���}
        SetLeft(2 * TabBut + ButWidth); {����� �� ������ ᫥��}
        SetTop(ButPanel[i - 1].GetTop); {� ���� ⠪�� ��}
      end;

      SetWidth(ButWidth);      {�ਭ�}
      SetHeight(ButHeight);           {����}

      SetBorder(BorWidth);      {⮫騭� �࠭��� �࠭���}
      SetBorderCol(BorCol);    {梥� �࠭���}
      SetButt(LeftButton);    {�� ����� ������ ॠ��஢���}
      SetKey(i + 5);        {� ����� ��� �� ᮮ⢥����}
      SetStyle(SolidFill);    {��������� ����訢���}

      if i = 1 then           {�᫨ �� ��ࢠ� ������, � �뤥�塞 ��}
        SetCol(SelButCol)
      else
        SetCol(ColBut);

      Draw;                    {���ᮢ뢥�   ������  �  }
      DrawButton(i);                                     { ������}

      Items[i + N].X1 := GetLeft;     {� ������   }
      Items[i + N].Y1 := GetTop;                {������ ॠ��஢����}
      Items[i + N].X2 := GetRight;
      Items[i + N].Y2 := GetBottom;
      Items[i + N].Butt := GetButt;    {�� ����� ������ = �����}
      Items[i + N].Key := GetKey;      {����� ���}

      AddMouseItem(Items[i + N]);
  end;

  for i := NButs + 1 to NButs + NCol do    {������ � 梥⠬�}
  with ButPanel[i] do
  begin
    if odd(i) then
      begin   {�᫨ �� ���� ��}
        SetLeft((LeftPanel.GetWidth - TabBut) div 2 - ColWid);
        SetTop(BottomPanel.GetTop - NCol div 2 * (ColWid + TabBut)
               - 4 * ColWid + (i - NButs) * (ColWid + TabBut) div 2 - TabBut);
      end
    else
      begin   {�᫨ �ࠢ� �}
        SetLeft((LeftPanel.GetWidth + TabBut) div 2);
        SetTop(ButPanel[i - 1].GetTop);
      end;

      SetWidth(ColWid);
      SetHeight(ColWid);

      SetBorder(BorWidth);
      SetBorderCol(Black);
      SetButt(LeftButton);
      SetKey(i + 5);
      SetStyle(SolidFill);
      SetCol(i - NButs - 1);

      Draw;

      Items[i + N].X1 := GetLeft + 1;
      Items[i + N].Y1 := GetTop + 1;
      Items[i + N].X2 := GetRight - 1;
      Items[i + N].Y2 := GetBottom - 1;
      Items[i + N].Butt := GetButt;
      Items[i + N].Key := GetKey;

      AddMouseItem(Items[i + N]);
  end;

  i := NButs + NCol + 1;    {��⨢�� 梥�}
  with ButPanel[i] do
  begin
    SetLeft((LeftPanel.GetWidth - TabBut) div 2 - ColWid);
    SetTop(ButPanel[NButs + NCol].GetBottom + ButHeight);
    SetWidth(2 * ColWid + TabBut);
    SetHeight(2 * ColWid + TabBut);
    SetBorder(BorWidth);
    SetBorderCol(BorCol);
    SetButt(LeftButton);
    SetStyle(SolidFill);
    SetCol(Black);
    Draw;
  end;

  OldBut := N + 1;              {���� ������ 㦥 ��ࢠ�}
  AcBut := 1;                   {��⨢��� ⮦� ��ࢠ�}
  AcCol := Black;  {� ��⨢�� 梥�}
  Thik := 1;  Fil := 1;  Brush := 1;  EraserWid := 5;
  Radius := 4;
  ModeVis := False;
end;
{=================End InitButtons===================================}

procedure DrawDialog(VTitle: string; OnExit: Boolean);
begin
  with Win do
  begin
    Left := GetMaxX div 2 - 125;         {100 + 200;}
    Top := 100;
    Right := GetMaxX div 2 + 125;        {350 + 200;}
    Bottom := 175;
    ColBk := LightGray;
    ColBor := DarkGray;
    Title := VTitle;
    HTitle := 15;
    ColTitle := LightBlue;
  end;

  with FilBk do
  begin
    Left := Win.Left + 10;
    Top := Win.Top + 30;
    if OnExit and (Path <> '') then
      Right := Left
    else
      Right := Win.Right - 10;
    Bottom := Top + 13;
    ColBkFile := 6;
    if OnExit then
      Name := 'Do you want to save changes?'
    else
      Name := 'Name';
    ColBor := DarkGray;
  end;

  with Bt1 do
  begin
    Left := Win.Left + 50;
    Top := Win.Top + 53;
    Right := Left + 60;
    Bottom := Top + 12;
    Title := 'Ok';
    ColBt := Green;
    ColBor := Win.ColBor;
  end;

  with Bt2 do
  begin
    Left := Win.Left + 130;
    Top := Win.Top + 53;
    Right := Left + 60;
    Bottom := Top + 12;
    Title := 'Cancel';
    ColBt := Green;
    ColBor := Win.ColBor;
  end;

  DDialog(Win, FilBk, Bt1, Bt2);
end;

procedure AddChar(Ch: Char);
var
  OldCol: Word;
  OldStyleT : TextSettingsType;
  OutPath: string;
begin
  OldCol := GetColor;
  GetTextSettings(OldStyleT);

  with FilBk do
      begin
        SetColor(White);
        OutTextXY(Left, Top - TextHeight(Name) - 2, Name);
        SetFillStyle(SolidFill, ColBkFile);
        bar(Left, Top, Right, Bottom);
        SetColor(ColBor);
        Rectangle(Left, Top, Right, Bottom);
      end;

  if ord(Ch) = 8 then
      Delete(Path, Length(Path), 1)
  else
    Path := Path + Ch;

  OutPath := Path;

  SetTextStyle(2, 0, 0);

  if TextWidth(Path) >= FilBk.Right - FilBk.Left then
    while TextWidth(OutPath) >= FilBk.Right - FilBk.Left  do
    begin
      Delete(OutPath, 1, 1);
    end;

  SetColor(White);
  OutTextXY(FilBk.Left + 3, FilBk.Top + 1, OutPath);
  SetColor(OldCol);
  with OldStyleT Do
  begin
    SetTextJustify(Horiz, Vert);
    SetTextStyle(Font, Direction, CharSize);
  end;
end;


procedure SelectMode(Value: Word);
var
  FillInfo : FillSettingsType;
begin
  if not MouseIn(LeftPanel.GetLeft, LeftPanel.GetTop,
                 LeftPanel.GetRight, LeftPanel.GetBottom) then
     exit;
  if ModeVis then
  case AcBut of
       2: if EraserWid = ar.ar[Value].Value then exit;
       4: if Brush = ar.ar[Value].Value then exit;
    5, 6: if Thik = ar.ar[Value].Value then exit;
    7, 8: if Fil = ar.ar[Value].Value then exit;
       9: if Radius = ar.ar[Value].Value then exit;
  end;


  GetFillSettings(FillInfo);   { ���࠭塞 �⨫� � 梥� ����᪨ }

  HideMouse;
  Modes.Draw;   {�����쪠 ��� ��� ����ࠥ���}

  SetFillStyle(SolidFill, 14);   { ���� �⨫� }

  bar(ar.ar[Value].X1, ar.ar[Value].Y1,
      ar.ar[Value].X2, ar.ar[Value].Y2);
  ClearMouseItems;
  SetMouseItem(N + NButs + NCol, Items);

  case AcBut of
       2: begin
            with Modes do
            begin
              DEraserModes(GetLeft, GetTop, GetRight, GetBottom, 32, LMCol, ar, N);
            end;
           EraserWid := ar.ar[Value].Value;
          end;
       4: begin
            with Modes do
            begin
              DBrushModes(GetLeft, GetTop, GetRight, GetBottom, 34, LMCol, ar, N);
            end;
           Brush := ar.ar[Value].Value;
          end;
    5, 6: begin
            with Modes do
            begin
              DLineModes(GetLeft, GetTop, GetRight, GetBottom, 36, LMCol, ar, N);
            end;
           Thik := ar.ar[Value].Value;
          end;
    7, 8: begin
            with Modes do
            begin
              DFilModes(GetLeft, GetTop, GetRight, GetBottom, 38, ShMCol, ar, N);
            end;
           Fil := ar.ar[Value].Value;
          end;
       9: begin
            with Modes do
            begin
              DSprayModes(GetLeft, GetTop, GetRight, GetBottom, 40, ShMCol, ar, N);
            end;
           Radius := ar.ar[Value].Value;
          end;
  end;

  ShowMouse;
  With FillInfo Do SetFillStyle(Pattern, Color);
  ModeVis := True;
end;

procedure ClickButton(Value: Integer);
{����⨥ �� ������
V�lue - ����� ������}
begin
  if not MouseIn(ButPanel[1].GetLeft, ButPanel[1].GetTop,
                 ButPanel[NButs].GetRight, ButPanel[NButs].GetBottom) then
                    exit;
  if AcBut = Value then exit;

  ModeVis := False;

  HideMouse;       {����� ����}
  Modes.Draw;

  ButPanel[OldBut - N].SetCol(ColBut);  {�������� ����� ������    }
  ButPanel[OldBut - N].Draw;                              {   梥� � }
  DrawButton(OldBut - N);                                        {������}

  ButPanel[Value].SetCol(SelButCol);       {�뤥��� ����� ������}
  ButPanel[Value].Draw;            {� ����ᮢ뢠�� � ���� 梥⮬}
  DrawButton(Value);                                             {� ������}

  OldBut := Value + N;  {����� ��ன �����= ����� ������ � ���-�� �������}
  OldMouseX := MouseWhereX;  {��� �뫠 ���� �� �}
  OldMouseY := MouseWhereY;  {��� �뫠 ���� �� �}

  ClearMouseItems;
  SetMouseItem(N + NButs + NCol, Items);
  ShowMouse;

  AcBut := Value;

  case AcBut of
       2: begin
          with Modes do
            DEraserModes(GetLeft, GetTop, GetRight, GetBottom, 32, LMCol, ar, N);
          if EraserWid = 5 then
            SelectMode(1)
          else
            SelectMode(2);
          end;
       4: begin
          with Modes do
            DLineModes(GetLeft, GetTop, GetRight, GetBottom, 34, LMCol, ar, N);
          if Brush = 1 then
            SelectMode(1)
          else
            SelectMode(2);
          end;
    5, 6: begin
          with Modes do
            DLineModes(GetLeft, GetTop, GetRight, GetBottom, 36, LMCol, ar, N);
          if Thik = 1 then
            SelectMode(1)
          else
            SelectMode(2);
          end;
    7, 8: begin
          with Modes do
            DFilModes(GetLeft, GetTop, GetRight, GetBottom, 38, ShMCol, ar, N);
          if Fil = 1 then
            SelectMode(1)
          else
            SelectMode(2);
          end;
       9: begin
          with Modes do
            DSprayModes(GetLeft, GetTop, GetRight, GetBottom, 40, ShMCol, ar, N);
          if Radius = 4 then
            SelectMode(1)
          else
            SelectMode(2);
          end;
  end;
end;
{=================End ClickButton===================================}

procedure ClearTable;
var
  i, j: Integer;
  OldCol: Word;
  Text: string;
  OldStyle : TextSettingsType;
begin
  HideMouse;

  GetTextSettings(OldStyle);
  SetTextStyle(2, 0, 0);

  OldCol := GetColor;
  Text := 'Clearing...';

  with Progress do
  OutTextXY(GetLeft - TextWidth(Text) - 2, GetTop +
                (GetHeight - TextHeight(Text)) div 2 - 1, Text);

  Progress.KillPosition;
  Progress.Visibly(True, ColBut, Yellow);
  for i := Table.GetLeft to Table.GetRight do
  begin
    if i mod 6 = 0 then
      Progress.SetPosition;
    for j := Table.GetTop to Table.GetBottom do
      PutPixel(i, j, White);
  end;

  SetFillStyle(SolidFill, BottomPanel.GetCol);
  with Progress do
  Bar(GetLeft - TextWidth(Text) - 2, GetTop + (GetHeight - TextHeight(Text) - 2) div 2,
      GetLeft + TextWidth(Text), GetTop + GetHeight);

  ShowMouse;
  SetColor(OldCol);
  Progress.Visibly(False, BottomPanel.GetCol, BottomPanel.GetCol);
  Modify := True;
  with OldStyle Do
  begin
    SetTextJustify(Horiz, Vert);
    SetTextStyle(Font, Direction, CharSize);
  end;
end;
{=================End ClearTable===================================}

procedure Save(Value: string);
var
  f: kep;
  i, j: Integer;
  pic, OldCol: Word;
  Text: string;
  OldStyle : TextSettingsType;
begin
  {$I-}
  if Pos('.kep', Value) <> 0 then
    assign(f, Value)
  else
    assign(f, Value + '.kep');
  rewrite(f);
  if IOresult <> 0 then exit;
  {$I+}

  if Value = '' then exit;
  if  not Modify then exit;
  HideMouse;

  GetTextSettings(OldStyle);
  SetTextStyle(2, 0, 0);

  OldCol := GetColor;
  Text := 'Saving...';
  with Progress do
  OutTextXY(GetLeft - TextWidth(Text) - 2, GetTop +
                (GetHeight - TextHeight(Text)) div 2 - 1, Text);

  Progress.KillPosition;
  Progress.Visibly(True, ColBut, Yellow);
  for i := Table.GetLeft to Table.GetRight do
  begin
    if i mod 6 = 0 then
      Progress.SetPosition;

    for j := Table.GetTop to Table.GetBottom do
      begin
        pic := GetPixel(i, j);
        write(f, pic);
      end;
  end;
  close(f);
  ShowMouse;

  SetFillStyle(SolidFill, BottomPanel.GetCol);
  with Progress do
  Bar(GetLeft - TextWidth(Text) - 2, GetTop + (GetHeight - TextHeight(Text) - 2) div 2,
      GetLeft + TextWidth(Text), GetTop + GetHeight);

  SetColor(OldCol);
  Progress.Visibly(False, ColBottomPanel, ColBottomPanel);
  Modify := False;
  with OldStyle Do
  begin
    SetTextJustify(Horiz, Vert);
    SetTextStyle(Font, Direction, CharSize);
  end;
end;
{=================End Save===================================}

procedure Open(Value: string);
var
  f: kep;
  i, j: Integer;
  pic, OldCol: Word;
  X, Y: Integer;
  Text: string;
  OldStyle : TextSettingsType;
begin
  {$I-}
  if Pos('.kep', Value) <> 0 then
    assign(f, Value)
  else
    assign(f, Value + '.kep');
  reset(f);
  if IOresult <> 0 then exit;
  {$I+}

  HideMouse;
  X := MouseWhereX;
  Y := MouseWhereY;
  GetTextSettings(OldStyle);
  SetTextStyle(2, 0, 0);

  Text := 'Opening...';
  OldCol := GetColor;
  with Progress do
  OutTextXY(GetLeft - TextWidth(Text) - 2, GetTop +
                (GetHeight - TextHeight(Text)) div 2 - 1, Text);


  Progress.KillPosition;
  Progress.Visibly(True, ColBut, Yellow);
  for i := Table.GetLeft to Table.GetRight do
  begin
    if i mod 6 = 0 then
      Progress.SetPosition;

    for j := Table.GetTop to Table.GetBottom do
      begin
        read(f, pic);
        PutPixel(i, j, pic);
      end;
  end;
  close(f);
  ShowMouse;

  SetFillStyle(SolidFill, BottomPanel.GetCol);
  with Progress do
  Bar(GetLeft - TextWidth(Text) - 2, GetTop + (GetHeight - TextHeight(Text) - 2) div 2,
      GetLeft + TextWidth(Text), GetTop + GetHeight);

  Progress.Visibly(False, ColBottomPanel, ColBottomPanel);
  Modify := False;
  with OldStyle Do
  begin
    SetTextJustify(Horiz, Vert);
    SetTextStyle(Font, Direction, CharSize);
  end;
end;
{=================End Open===================================}

procedure OpenSaveDialogPaint(Value: Char; OnExit: Boolean);
var
  Size: Integer;      OldImageUnderSave: Pointer;
  Ch3: Char;
  OldPath: string;
begin
  OldPath := Path;
  if (Value = #61) or (Path = '') or OnExit then
   begin
     HideMouse;
     ClearMouseItems;
     Size := ImageSize(GetMaxX div 2 - 125, 100,
     GetMaxX div 2 + 125, 175);
     GetMem(OldImageUnderSave, Size);
     GetImage(GetMaxX div 2 - 125, 100,
              GetMaxX div 2 + 125, 175,
              OldImageUnderSave^);
     if Value = #60 then
       if OnExit then
         DrawDialog('Picture was modified', OnExit)
       else
         DrawDialog('Save...', OnExit)
     else
       DrawDialog('Open...', OnExit);

     if not OnExit then Path := '';
     ShowMouse;
     BCL := False;
     while not BCL do
       if KeyOrMousePressed then
         begin
            Ch3 := ReadKeyOrMouse;
            case Ch3 of
              chr(1), chr(13):if Path <> '' then
                              begin
                                 HideMouse;
                                 BCL := True;
                                 PutImage(Win.Left, Win.Top,
                                          OldImageUnderSave^, NormalPut);
                                 FreeMem(OldImageUnderSave, Size);
                                 OldImageUnderSave := nil;

                                 if Value = #60 then
                                   Save(Path)
                                 else
                                   Open(Path);
                               end;
             chr(2), chr(27): begin
                                 HideMouse;
                                 BCL := True;
                                 PutImage(Win.Left, Win.Top,
                                 OldImageUnderSave^, NormalPut);
                                 FreeMem(OldImageUnderSave, Size);
                                 OldImageUnderSave := nil;
                                 Path := OldPath;
                              end;
            'a'..'z','A'..'Z',
            '0'..'9','(',')','-',
            ':', '.', '\', chr(8): {if not OnExit then} AddChar(Ch3);
            end;
          end;
       ShowMouse;
       SetMouseItem(N + NButs + NCol, Items);
   end
   else
     Save(Path);
end;

begin
{  clrscr;
  readln;
  assign(f, 'KURS/Ver3_2.pas');
  reset(f);
  sch := 0;
  while not EOF(f) do
  begin
    inc(sch);
    readln(f, s);
    writeln(s);
    if sch = 20 then
      begin
        delay(20000);
        sch := 0;
      end;
  end;
readkey;}

  InitG;          {�����⮢�� ����᪮�� ०���}
  InitMouse;      {�����⮢�� ���}
  InitPanels;     {���ᮢ�� �������}
  InitButtons;    {���ᮢ�� ������}
  Modify := True;
  AfterOkOrCancel := 0;


  ShowMouse;
  XEraser := 0;  YEraser := 0;
  Path := '';

  while true do
   begin
    if AcBut = 2 then
       if MouseIn(Table.GetLeft + EraserWid + EraserTab,
               Table.GetTop + EraserWid + EraserTab,
               TAble.GetRight + 1, Table.GetBottom) and
         ((MouseWhereX <> XEraser)or(MouseWhereY <> YEraser)) then
            DrawEraser(EraserWid)
       else if not MouseIn(Table.GetLeft + EraserWid + EraserTab,
               Table.GetTop + EraserWid + EraserTab,
               TAble.GetRight, Table.GetBottom) then
              begin
                for k := 1 to EraserWid + 1 do
                  for z := 1 to 4 do
                      PutPixel(EraserAr[k, z].X, EraserAr[k, z].Y,
                                   EraserAr[k, z].Col);
              end;


    if KeyOrMousePressed then
     case ReadKeyOrMouse of
       #0: begin
            Ch2 := ReadKeyOrMouse;
            case Ch2 of
              #60, #61:  begin
                           OpenSaveDialogPaint(Ch2, False);
                           AfterOkOrCancel := 13000;
                           continue;
                         end;
                #63: begin
                       LeftPanel.Draw;  BottomPanel.Draw;
                       HeadPanel.Draw;  Modes.Draw;
                       for i := 1 to NButs + NCol + 1 do    {��⨢�� 梥�}
                         begin
                           ButPanel[i].Draw;
                           if i <= NButs then
                              DrawButton(i);
                         end;
                         {� �뢮� �⮩ ������}
                       OutTextXY(TabTextX,
                           (HeadPanelHeight - TextHeight(Title)) div 2, Title);
                       with BottomPanel do  {��������� ������}
                       begin
                         OutTextXY(TabTextX,
                           GetTop + (BottomPanelHeight - TextHeight(TLBTitle)) div 2, TLBTitle);
                         OutTextXY(GetMaxX - TabTextX - TextWidth(TRBTitle),
                           GetTop + (BottomPanelHeight - TextHeight(TRBTitle)) div 2, TRBTitle);
                       end;
                     end;
                #64: ClearTable;
                #68: begin
                       if Modify then
                         OpenSaveDialogPaint(#60, True);
                       exit;
                     end;
           end;
           end;
       chr(6)..chr(15): begin
                          ClickButton(ord(ReadKeyorMouse) - 5);
                          AfterOkOrCancel := 0;
                        end;
       chr(16)..chr(31):  if AcColIndex <> ord(ReadKeyorMouse) - 5 then
                          if MouseIn(ButPanel[NButs + 1].GetLeft,
                                    ButPanel[NButs + 2].GetTop,
                                    ButPanel[NButs + NCol].GetRight,
                                    ButPanel[NButs + NCol].GetBottom) then
                           with ButPanel[ord(ReadKeyorMouse) - 5] do
                           begin
                             AcColIndex := ord(ReadKeyOrMouse) - 5;
                             ButPanel[NButs + NCol + 1].SetCol(GetCol);
                             ButPanel[NButs + NCol + 1].Draw;
                             AcCol := ButPanel[NButs + NCol + 1].GetCol;
                           end;
       chr(5): if AfterOkOrCancel  > 0 then
                 Dec(AfterOkOrCancel)
               else
               begin
               Modify := True;
                case AcBut of
                  1: Doters(Table.GetLeft + 1, Table.GetTop + 1,
                        Table.GetRight + 1, Table.GetBottom + 1, AcCol);
                  2: Eraser(Table.GetLeft + EraserWid + EraserTab - 2,
                            Table.GetTop + EraserWid + EraserTab - 2,
                            Table.GetRight + 2, Table.GetBottom + 2,
                            EraserWid);
                  3: Pencil(Table.GetLeft + 1, Table.GetTop + 1,
                            Table.GetRight + 1, Table.GetBottom + 1, AcCol);
                  4: Painbrush(Table.GetLeft + 3 + BrushRadius,
                               Table.GetTop + 3 + BrushRadius,
                               Table.GetRight - BrushRadius + 3,
                               Table.GetBottom - BrushRadius + 3,
                               AcCol, Brush);
                  5: Straight_line(Table.GetLeft - 1 + Thik div 2 ,
                                   Table.GetTop - 1 + Thik div 2 ,
                                   Table.GetRight - 1 - Thik div 2 * 2 ,
                                   Table.GetBottom - 1  - Thik div 2 ,
                                   AcCol, Thik);
                  6: Polyline(Table.GetLeft + 2 + Thik div 2 ,
                              Table.GetTop + 2  + Thik div 2 ,
                              Table.GetRight + 2 - Thik div 2 ,
                              Table.GetBottom + 2 - Thik div 2 ,
                              AcCol, Thik);
                  7: Oval(Table.GetLeft - 1 + Thik div 2 ,
                          Table.GetTop - 1 + Thik div 2 ,
                          Table.GetRight - 1 - Thik div 2 ,
                          Table.GetBottom - 1 - Thik div 2 ,
                          AcCol, Thik, Fil);
                  8: Rec(Table.GetLeft - 1 + Thik div 2 ,
                         Table.GetTop  - 1 + Thik div 2 ,
                         Table.GetRight - 1 - Thik div 2 * 2,
                         Table.GetBottom - 1 - Thik div 2 ,
                         AcCol, Thik, Fil);
                  9: if Radius = 4 then
                       Spray(Table.GetLeft + Radius div 2 + 1,
                           Table.GetTop + Radius div 2,
                           Table.GetRight - 2 - Radius div 2,
                           Table.GetBottom - 3 - Radius div 2,
                           AcCol, Radius)
                     else
                       Spray(Table.GetLeft + 3 + Radius div 2,
                           Table.GetTop + 2 + Radius div 2,
                           Table.GetRight - 4 - Radius div 2,
                           Table.GetBottom - 5 - Radius div 2,
                           AcCol, Radius);
                  10:  Filling(Table.GetLeft, Table.GetTop,
                              Table.GetRight, Table.GetBottom, AcCol);
                end;
               end;
       chr(32), chr(33): SelectMode(ord(ReadKeyorMouse) + 1 - 32);
       chr(34), chr(35): SelectMode(ord(ReadKeyorMouse) + 1 - 34);
       chr(36), chr(37): SelectMode(ord(ReadKeyorMouse) + 1 - 36);
       chr(38), chr(39): SelectMode(ord(ReadKeyorMouse) + 1 - 38);
       chr(40), chr(41): SelectMode(ord(ReadKeyorMouse) + 1 - 40);
     end;
   end;
  readkey;
end.
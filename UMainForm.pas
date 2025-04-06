unit UMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DelphiZXingQRCode,
  Vcl.ExtCtrls, Vcl.ExtDlgs;

type
  TFrmMainForm = class(TForm)
    btnGenQRCode: TButton;
    btnRePaint: TButton;
    edAccNo: TEdit;
    edAmt: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    PaintBox1: TPaintBox;
    edAccName: TEdit;
    btnSaveToFile: TButton;
    SavePictureDialog1: TSavePictureDialog;
    btnCopyToCB: TButton;
    procedure btnGenQRCodeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure btnRePaintClick(Sender: TObject);
    procedure btnSaveToFileClick(Sender: TObject);
    procedure btnCopyToCBClick(Sender: TObject);
  private
    { Private declarations }
    QRCodeBitmap: TBitmap;
    procedure DrawQrCode(data: String);

  public
    { Public declarations }
  end;

var
  FrmMainForm: TFrmMainForm;

implementation

{$R *.dfm}

uses UQrCodeLib ,clipbrd;

procedure TFrmMainForm.btnCopyToCBClick(Sender: TObject);
var
  tmpBitmap: TBitmap;
  Source: TRect;
  Dest: TRect;
begin
  tmpBitmap := TBitmap.Create;
  try
    with tmpBitmap do
    begin
      Width  := paintBox1.Width;
      Height := paintBox1.Height;
      Dest := Rect(0, 0, Width, Height);
    end;

      Source := Rect(0, 0, paintBox1.Width, paintBox1.Height);
      tmpBitmap.Canvas.CopyRect(Dest, paintBox1.Canvas, Source);
      clipboard.Assign(tmpBitmap);
  finally
    tmpBitmap.Free;
  end;

end;

procedure TFrmMainForm.btnGenQRCodeClick(Sender: TObject);
var qrText: String;
begin
  qrText := generatePayload(edAccNo.Text, edAmt.Text);
  Memo1.Lines.text := qrText;

  DrawQrCode(Memo1.Lines.text);

end;

procedure TFrmMainForm.btnRePaintClick(Sender: TObject);
begin
    DrawQrCode(Memo1.Lines.text);
end;

procedure TFrmMainForm.btnSaveToFileClick(Sender: TObject);
var
  tmpBitmap: TBitmap;
  Source: TRect;
  Dest: TRect;
begin
  tmpBitmap := TBitmap.Create;
  try
    with tmpBitmap do
    begin
      Width  := paintBox1.Width;
      Height := paintBox1.Height;
      Dest := Rect(0, 0, Width, Height);
    end;

      Source := Rect(0, 0, paintBox1.Width, paintBox1.Height);
      tmpBitmap.Canvas.CopyRect(Dest, paintBox1.Canvas, Source);
      if SavePictureDialog1.Execute then
         tmpBitmap.SaveToFile(SavePictureDialog1.FileName);
  finally
    tmpBitmap.Free;
  end;
end;

procedure TFrmMainForm.DrawQrCode(data : String);
var
  QRCode: TDelphiZXingQRCode;
  Row, Column , textwidth , paddingCenter : Integer;
  paddingLeft ,padding : Smallint;
begin
  QRCode := TDelphiZXingQRCode.Create;
  try
    QRCode.Data := Trim(data);
    QRCode.Encoding  := TQRCodeEncoding.qrISO88591;
    QRCode.QuietZone := 3;
    QRCodeBitmap.SetSize(QRCode.Rows, QRCode.Columns);
    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if (QRCode.IsBlack[Row, Column]) then
        begin
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack;
        end else
        begin
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
        end;
      end;
    end;
  finally
    QRCode.Free;
  end;

  // Re-Draw Qr-Code
  PaintBox1.Repaint;


  if (Trim(edAccName.text) <> '') then
     begin
      // Draw Name
      PaintBox1.Canvas.Font.Name := 'Sarabun';
      PaintBox1.Canvas.Font.Size := 14;

      // Align Center
      textwidth  := Canvas.TextWidth(edAccName.text);
      padding    := 10;
      paddingLeft   := -10;
      paddingCenter := Round(((PaintBox1.Width - (padding*2)) - textwidth)/2);

      /// TextOut( Left , Top , Text )
      PaintBox1.Canvas.TextOut(paddingLeft + paddingCenter, PaintBox1.Height - 50, edAccName.text);
    end;
end;

procedure TFrmMainForm.FormCreate(Sender: TObject);
begin
  QRCodeBitmap := TBitmap.Create;
end;

procedure TFrmMainForm.FormDestroy(Sender: TObject);
begin
  QRCodeBitmap.Free;
end;

procedure TFrmMainForm.PaintBox1Paint(Sender: TObject);
var
  Scale: Double;
begin
  PaintBox1.Canvas.Brush.Color := clWhite;
  PaintBox1.Canvas.FillRect(Rect(0, 0, PaintBox1.Width, PaintBox1.Height));
  if ((QRCodeBitmap.Width > 0) and (QRCodeBitmap.Height > 0)) then
  begin
    if (PaintBox1.Width < PaintBox1.Height) then
    begin
      Scale := PaintBox1.Width / QRCodeBitmap.Width;
    end else
    begin
      Scale := PaintBox1.Height / QRCodeBitmap.Height;
    end;
    PaintBox1.Canvas.StretchDraw(Rect(0, 0, Trunc(Scale * QRCodeBitmap.Width), Trunc(Scale * QRCodeBitmap.Height)), QRCodeBitmap);
  end;
end;

end.

object FrmMainForm: TFrmMainForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Gen Qr-Code Promptpay'
  ClientHeight = 397
  ClientWidth = 699
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    699
    397)
  PixelsPerInch = 96
  TextHeight = 18
  object Label1: TLabel
    Left = 23
    Top = 43
    Width = 51
    Height = 18
    Caption = 'Acc.No.'
  end
  object Label2: TLabel
    Left = 23
    Top = 73
    Width = 51
    Height = 18
    Caption = 'Amount'
  end
  object PaintBox1: TPaintBox
    Left = 358
    Top = 10
    Width = 333
    Height = 375
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clHighlight
    ParentColor = False
    OnPaint = PaintBox1Paint
  end
  object Label3: TLabel
    Left = 32
    Top = 102
    Width = 289
    Height = 18
    Caption = '* '#3606#3657#3634#3618#3629#3604#3648#3591#3636#3609#3648#3611#3655#3609' 0 '#3592#3632#3648#3611#3655#3609#3649#3610#3610#3605#3657#3629#3591#3585#3619#3629#3585#3618#3629#3604#3648#3591#3636#3609
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 35
    Top = 11
    Width = 39
    Height = 18
    Caption = 'Name'
  end
  object edAccNo: TEdit
    Left = 82
    Top = 40
    Width = 178
    Height = 26
    TabOrder = 1
    Text = '0123456789'
    TextHint = #3648#3621#3586#3610#3633#3597#3594#3637' '#3610#3633#3605#3619#3611#3619#3632#3594#3634#3594#3609' '#3627#3619#3639#3629' '#3627#3617#3634#3618#3648#3621#3586#3650#3607#3619#3624#3633#3614#3607#3660
  end
  object edAmt: TEdit
    Left = 82
    Top = 70
    Width = 178
    Height = 26
    TabOrder = 2
    Text = '15000'
    TextHint = #3592#3635#3609#3623#3609#3648#3591#3636#3609' ('#3594#3656#3629#3591#3623#3656#3634#3591' '#3627#3619#3639#3629' 0 '#3588#3639#3629#3585#3619#3629#3585#3592#3635#3609#3623#3609#3607#3637#3656#3649#3629#3611#3608#3609#3634#3588#3634#3619')'
  end
  object btnGenQRCode: TButton
    Left = 82
    Top = 126
    Width = 178
    Height = 50
    Caption = #3626#3619#3657#3634#3591#3588#3636#3623#3629#3634#3619#3660#3650#3588#3657#3604' Qr-Code'
    TabOrder = 3
    OnClick = btnGenQRCodeClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 188
    Width = 333
    Height = 133
    TabOrder = 4
  end
  object btnRePaint: TButton
    Left = 23
    Top = 327
    Width = 101
    Height = 50
    Caption = #3623#3634#3604#3651#3627#3617#3656
    TabOrder = 5
    OnClick = btnRePaintClick
  end
  object edAccName: TEdit
    Left = 82
    Top = 8
    Width = 239
    Height = 26
    TabOrder = 0
    Text = #3623#3619#3648#3614#3594#3619'  '#3648#3619#3639#3629#3591#3614#3619#3623#3636#3626#3640#3607#3608#3636#3660
    TextHint = #3594#3639#3656#3629#3610#3633#3597#3594#3637' ('#3606#3657#3634#3605#3657#3629#3591#3585#3634#3619')'
  end
  object btnSaveToFile: TButton
    Left = 130
    Top = 327
    Width = 101
    Height = 50
    Caption = #3610#3633#3609#3607#3638#3585
    TabOrder = 6
    OnClick = btnSaveToFileClick
  end
  object btnCopyToCB: TButton
    Left = 237
    Top = 327
    Width = 101
    Height = 50
    Caption = 'Copy'
    TabOrder = 7
    OnClick = btnCopyToCBClick
  end
  object SavePictureDialog1: TSavePictureDialog
    DefaultExt = 'bmp'
    FileName = 'Qrcode'
    Title = #3610#3633#3609#3607#3638#3585#3621#3591#3652#3615#3621#3660' (BMP)'
    Left = 376
    Top = 336
  end
end

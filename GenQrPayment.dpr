program GenQrPayment;

uses
  Vcl.Forms,
  UMainForm in 'UMainForm.pas' {FrmMainForm},
  UQrCodeLib in 'UQrCodeLib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMainForm, FrmMainForm);
  Application.Run;
end.

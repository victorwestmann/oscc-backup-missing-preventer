program osccBMP;

uses
  System.SysUtils,
  Vcl.Forms,
  uMain in 'uMain.pas' {frmPrincipal},
  uSplash in 'uSplash.pas' {SplashBKP};

{$R *.res}

begin
  Application.Initialize;
//  Application.CreateForm(TSplashBKP, SplashBKP);
  SplashBKP := TSplashBKP.Create(nil) ;
  SplashBKP.Show;
  SplashBKP.Update;
  Sleep(2000);
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  SplashBKP.Hide;
  SplashBKP.Free;
  Application.Run;
end.

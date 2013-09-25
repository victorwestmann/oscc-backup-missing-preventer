unit uSplash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, jpeg, Vcl.Imaging.pngimage;
   

type
  TSplashBKP = class(TForm)
    imgSpash: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SplashBKP: TSplashBKP;

implementation

{$R *.DFM}

end.

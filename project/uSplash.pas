unit uSplash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, jpeg, Vcl.Imaging.pngimage;
   

type
  TfrmSplash = class(TForm)
    imgSpash: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Splash: TSplash;

implementation

{$R *.DFM}

end.

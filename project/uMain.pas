unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.FileCtrl, Vcl.Consts,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Samples.Gauges, Vcl.ImgList, Vcl.Menus,
  ZipMstr, Vcl.Imaging.pngimage;

type
  TfrmPrincipal = class(TForm)
    FileListBox: TFileListBox;
    gpbDataBackup: TGroupBox;
    lblHoje: TLabel;
    dtpHoje: TDateTimePicker;
    btnCompactar: TButton;
    rdgLocalBackup: TRadioGroup;
    btnProcurarMDB: TButton;
    stbBarraDeStatus: TStatusBar;
    SaveDialog: TSaveDialog;
    ZipMaster: TZipMaster;
    Gauge1: TGauge;
    pgbStatus: TProgressBar;
    rdgTipoBackup: TRadioGroup;
    Image1: TImage;
    Image2: TImage;
    lblAuthor: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnProcurarMDBClick(Sender: TObject);
    procedure btnCompactarClick(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
    procedure ProcuraArquivo(dir : string);
    function GetDesktopPath: string;
  end;
Const
 Dir1 = 'C:\Program Files (x86)\Siemens';
 Dir2 = 'C:\Program Files\Siemens';
 Dir3 = 'D:\Program Files (x86)\Siemens';
 Dir4 = 'D:\Program Files\Siemens';

var
  frmPrincipal   : TfrmPrincipal;
  FileFound : Boolean;

implementation

{$R *.dfm}

uses
ShlObj,   {Constantes que guardam diversos caminhos das pastas do windows}
uSplash;  {Splash do programa}


procedure TfrmPrincipal.btnProcurarMDBClick(Sender: TObject);
var
  ArqProgPidl: PItemIDList;
  ArqProgPath: array [0 .. MAX_PATH] of Char;
  ArqProgDir : String;
begin
  SHGetSpecialFolderLocation(0, CSIDL_PROGRAM_FILES, ArqProgPidl);
  SHGetPathFromIDList(ArqProgPidl, ArqProgPath);
  ArqProgDir := IncludeTrailingPathDelimiter(ArqProgPath);
  if (ArqProgDir <> '') then
    begin
      stbBarraDeStatus.Panels.Items[0].Text := 'OpenScape ContactCenter encontrado em '+ArqProgDir;
      ProcuraArquivo(ArqProgDir);
    end
  else
    begin
      stbBarraDeStatus.Panels.Items[0].Text := 'OpenScape ContactCenter não instalado nesta máquina!' ;
    end
end;

procedure TfrmPrincipal.btnCompactarClick(Sender: TObject);
var
  ZipArquivo,Arquivo : String;
  i                  : integer;
  DataArq,DestinoArq : string;
  DateArq            : TDateTime;
  OrigemArq          : string;
  NomeArq            : string;
begin

  if (rdgLocalBackup.ItemIndex = 1) then
    begin
      SaveDialog.Filter := 'Arquivos compactados .zip|*.ZIP|Todos os arquivos (*.*)|*.*';
      SaveDialog.Execute();
      ZipArquivo        := SaveDialog.FileName;
      DestinoArq        := ZipArquivo;
    end
  else
    begin
      ZipArquivo := FileListBox.Directory + '\ArquivoMDB.zip';  //Nome do arquivo a ser gerado
      if FileExists(ZipArquivo) then                            // se ja existir eu apago
      DeleteFile(ZipArquivo);
      DestinoArq := GetDesktopPath+'ArquivoMDB.zip';            //aqui para onde ele será copiado
    end;

  ZipMaster.ZipFileName := ZipArquivo;
  Gauge1.MaxValue := FileListBox.Count;
  pgbStatus.Max := FileListBox.Count;
  for i := 0 to (FileListBox.Count -1) do
    begin
      NomeArq := '';
      Arquivo := FileListBox.Items[i];
      DateArq := FileDateToDateTime(FileAge(FileListBox.Directory+'\'+Arquivo));  //aqui eu guardo a data do arquivo
      DataArq := FormatDateTime('dd/mm/yyyy',DateArq); // aqui eu formato em string para facilitar a comparação
      //    if (DataArq = formatDateTime('dd/mm/yyyy',Now)) then //Comparo a data do arquivo formatanto também a data de hoje
      if (DataArq = formatDateTime('dd/mm/yyyy',dtpHoje.DateTime)) then //Comparo a data do arquivo formatanto também a data de hoje
        begin
          NomeArq  := FileListBox.Directory+'\'+Arquivo;
          ZipMaster.FSpecArgs.Add(NomeArq); //se o arquivo for da mesma data de hoje, nessa linha eu adiciono ele ao zip
          ZipMaster.Add;
        end;
      Gauge1.Progress := Gauge1.Progress +1;
      pgbStatus.StepIt;
      pgbStatus.StepBy(1);
    end;
  OrigemArq  := FileListBox.Directory + '\ArquivoMDB.zip'; //aqui eu resgato o caminho do arquivo criado
  CopyFile(pchar(OrigemArq),Pchar(DestinoArq),true); // aqui eu copio
  ShowMessage('Processo Terminado.');
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  {Recebe a data de hoje como parametro}
  dtpHoje.DateTime := Date;
  FileListBox.Clear;
end;

function TfrmPrincipal.GetDesktopPath: string;  //Função que retorna o caminho do Desktop da maquina
var
  DesktopPidl: PItemIDList;
  DesktopPath: array [0..MAX_PATH] of Char;
begin
  SHGetSpecialFolderLocation(0, CSIDL_DESKTOP, DesktopPidl);
  SHGetPathFromIDList(DesktopPidl, DesktopPath);
  Result := IncludeTrailingPathDelimiter(DesktopPath);
end; (*GetDesktopPath*)

procedure TfrmPrincipal.ProcuraArquivo(dir : string);
var
  NomeArquivo,Arquivo : string;
  DataArq             : string;
  DateArq             : TDateTime;
  i                   : integer;
begin
  FileFound := False;
  try
    NomeArquivo := Dir +'Siemens\HiPath ProCenter\tmcmain.exe';
  except
    stbBarraDeStatus.Panels.Items[0].Text := '''Programa "Manager" não encontrado!''';
    raise;
  end;

  if FileExists(NomeArquivo) then
    begin
      FileListBox.Directory :=  Dir +'Siemens\HiPath ProCenter\ShareData\AdministrationData';
      FileListBox.Mask      :=  '*.mdb';
    end;
  if FileListBox.Count>0 then
   begin
    for I := 0 to FileListBox.Count -1 do
    begin
      Arquivo := FileListBox.Items[i];
      DateArq := FileDateToDateTime(FileAge(FileListBox.Directory+'\'+Arquivo));  //aqui eu guardo a data do arquivo
      DataArq := FormatDateTime('dd/mm/yyyy',DateArq); // aqui eu formato em string para facilitar a comparação
      if (DataArq = formatDateTime('dd/mm/yyyy',dtpHoje.DateTime)) then //Comparo a data do arquivo formatanto também a data de hoje
      begin
        FileFound := True;
        btnCompactar.Enabled := True;
        exit;
      end;
    end;
   end;
end;


end.

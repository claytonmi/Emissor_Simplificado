unit FrmSplashArt;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, MNPrincipal,
  Vcl.Imaging.pngimage;

type
  TFrmSplash = class(TForm)
    lblStatus: TLabel;
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    ImageLogo: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    procedure IniciarSistema;
  public
    procedure labEdit(labeltext: string);
    procedure processCout(process: Integer);
    { Public declarations }
  end;

var
  hMutex: THandle;
  MutexName: string; // Nome do Mutex
  FrmSplash: TFrmSplash;

implementation

uses
  uDataModulePrincipal;  // Mover para c�!

{$R *.dfm}

procedure TFrmSplash.labEdit(labeltext: string);
begin
    lblStatus.Caption := labeltext;
    lblStatus.Repaint;
end;

procedure TFrmSplash.processCout(process: Integer);
begin
    ProgressBar1.Position := process;
end;

procedure TFrmSplash.FormShow(Sender: TObject);
var
  ExeName: string;
begin
  // Obt�m o nome do execut�vel sem a extens�o
  ExeName := ChangeFileExt(ExtractFileName(ParamStr(0)), '');
  MutexName := 'Mutex_' + ExeName; // Nome �nico baseado no execut�vel
  // Criar Mutex para impedir m�ltiplas inst�ncias
  hMutex := CreateMutex(nil, True, PChar(MutexName));
  if (hMutex = 0) or (GetLastError = ERROR_ALREADY_EXISTS) then
  begin
    MessageBox(0, 'O programa j� est� em execu��o.', 'Aviso', MB_OK or MB_ICONWARNING);
    Halt; // Encerra o programa
  end;
  labEdit('Inicializando...');
  ProgressBar1.Position := 0;
  Timer1.Enabled := True;
end;


procedure TFrmSplash.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  IniciarSistema;
end;

procedure TFrmSplash.IniciarSistema;
begin
  labEdit('Verificando Banco de Dados...');
  processCout(20);
  Application.ProcessMessages;
  try
    DataModulePrincipal := TDataModulePrincipal.Create(nil);
    Application.ProcessMessages;
    labEdit('Carregamento conclu�do!');
    FrmSplashArt.FrmSplash.processCout(100);
    Application.ProcessMessages;
    Sleep(500);
    // Esconde o splash
    FrmSplash.Hide;
    Application.MainFormOnTaskbar := True;
    // Cria o formul�rio principal e exibe
    Application.CreateForm(TEmissorPrincipal, EmissorPrincipal);
    EmissorPrincipal.Show;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao inicializar o sistema: ' + E.Message);
      Application.Terminate;
    end;
  end;
end;

end.

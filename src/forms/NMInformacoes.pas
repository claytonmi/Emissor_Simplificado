unit NMInformacoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFInformações = class(TForm)
    MemoInformações: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FInformações: TFInformações;

implementation

{$R *.dfm}

end.

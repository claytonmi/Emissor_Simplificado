unit NMPesquisaPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDataModulePrincipal, Vcl.StdCtrls;

type
  TNMPesquisaDePedido = class(TForm)
    ComboBoxPesquisaDePedido: TComboBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NMPesquisaDePedido: TNMPesquisaDePedido;

implementation

{$R *.dfm}

procedure TNMPesquisaDePedido.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  Selecionado: string;
  IDVenda: Integer;
begin
  if ComboBoxPesquisaDePedido.ItemIndex = -1 then
  begin
    ShowMessage('Selecione um pedido!');
    Exit;
  end;
  Selecionado := ComboBoxPesquisaDePedido.Text;
  IDVenda := StrToInt(Copy(Selecionado, 1, Pos(' - ', Selecionado) - 1));
  ModalResult := mrOk;
  Tag := IDVenda; // Passa o ID do pedido via propriedade Tag
end;

procedure TNMPesquisaDePedido.FormCreate(Sender: TObject);
begin
  // Limpa os itens existentes no ComboBox
  ComboBoxPesquisaDePedido.Items.Clear;

  // Verifica o tipo de banco de dados
  if dbType = 'SQLite' then
  begin
    // Configura a consulta usando FDQuery para SQLite
    with DataModulePrincipal.FDQueryPedido do
    begin
      Close; // Garante que a consulta está fechada
      SQL.Text := 'SELECT IDVenda, NomeCliente, Data FROM Pedido'; // Consulta para buscar os pedidos
      Open; // Executa a consulta

      // Preenche o ComboBox com os pedidos no formato desejado
      while not Eof do
      begin
        ComboBoxPesquisaDePedido.Items.Add(
          Format('%d - %s - %s', [
            FieldByName('IDVenda').AsInteger,
            FieldByName('NomeCliente').AsString,
            FieldByName('Data').AsString
          ])
        );
        Next;
      end;

      Close; // Fecha a consulta após o uso
    end;
  end
  else if dbType = 'SQL Server' then
  begin
    // Configura a consulta usando ADOQuery para SQL Server
    with DataModulePrincipal.ADOQueryPedido do
    begin
      Close; // Garante que a consulta está fechada
      SQL.Text := 'SELECT IDVenda, NomeCliente, Data FROM Pedido'; // Consulta para buscar os pedidos
      Open; // Executa a consulta

      // Preenche o ComboBox com os pedidos no formato desejado
      while not Eof do
      begin
        ComboBoxPesquisaDePedido.Items.Add(
          Format('%d - %s - %s', [
            FieldByName('IDVenda').AsInteger,
            FieldByName('NomeCliente').AsString,
            FieldByName('Data').AsString
          ])
        );
        Next;
      end;

      Close; // Fecha a consulta após o uso
    end;
  end;
end;


end.

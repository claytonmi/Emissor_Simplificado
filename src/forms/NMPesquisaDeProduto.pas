unit NMPesquisaDeProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, uDataModulePrincipal,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls;

type
  TNMPesquisaProduto = class(TForm)
    DBComboBoxPesquisaProduto: TComboBox;
    procedure FormCreate(Sender: TObject);
  private
    FSelecionadoID: Integer;
  public
    property SelecionadoID: Integer read FSelecionadoID;
  end;

var
  NMPesquisaProduto: TNMPesquisaProduto;

implementation

{$R *.dfm}

procedure TNMPesquisaProduto.FormCreate(Sender: TObject);
begin
  // Limpa os itens anteriores do ComboBox
  DBComboBoxPesquisaProduto.Clear;

  // Verifica o tipo de banco de dados
  if dbType = 'SQLite' then
  begin
    // Para SQLite, mantém o código original com FDQuery
    DataModulePrincipal.FDQueryProduto.SQL.Text := 'SELECT IDProduto, NomeProduto FROM Produto';
    DataModulePrincipal.FDQueryProduto.Open;

    // Preenche o ComboBox com os dados dos produtos
    while not DataModulePrincipal.FDQueryProduto.Eof do
    begin
      DBComboBoxPesquisaProduto.Items.AddObject(
        DataModulePrincipal.FDQueryProduto.FieldByName('NomeProduto').AsString,
        TObject(DataModulePrincipal.FDQueryProduto.FieldByName('IDProduto').AsInteger)
      );
      DataModulePrincipal.FDQueryProduto.Next;
    end;
  end
  else if dbType = 'SQL Server' then
  begin
    // Para SQL Server, usa o ADOQuery
    DataModulePrincipal.ADOQueryProduto.SQL.Text := 'SELECT IDProduto, NomeProduto FROM Produto';
    DataModulePrincipal.ADOQueryProduto.Open;

    // Preenche o ComboBox com os dados dos produtos
    while not DataModulePrincipal.ADOQueryProduto.Eof do
    begin
      DBComboBoxPesquisaProduto.Items.AddObject(
        DataModulePrincipal.ADOQueryProduto.FieldByName('NomeProduto').AsString,
        TObject(DataModulePrincipal.ADOQueryProduto.FieldByName('IDProduto').AsInteger)
      );
      DataModulePrincipal.ADOQueryProduto.Next;
    end;
  end;
end;


end.


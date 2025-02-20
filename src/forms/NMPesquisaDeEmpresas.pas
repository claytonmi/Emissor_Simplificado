unit NMPesquisaDeEmpresas;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, FireDAC.Comp.Client;

type
  TNMPesquisaDeEmpresa = class(TForm)
    ComboBoxPesquisaDeEmpresa: TComboBox;
    lbPesquisa: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CarregarEmpresas;
  end;

var
  NMPesquisaDeEmpresa: TNMPesquisaDeEmpresa;
  IDEmpresaSelecionada: Integer;

implementation

uses NMCadastroDeEmpresa, uDataModulePrincipal;

{$R *.dfm}

// Carrega as empresas no ComboBox quando o formulário é aberto
procedure TNMPesquisaDeEmpresa.CarregarEmpresas;
begin
  ComboBoxPesquisaDeEmpresa.Clear;
  try
    if dbType = 'SQLite' then
    begin
      // Código para SQLite
      DataModulePrincipal.FDQueryEmpresa.Close;
      DataModulePrincipal.FDQueryEmpresa.SQL.Text := 'SELECT IDEmpresa, NomeEmpresa FROM Empresa ORDER BY NomeEmpresa';
      // Executa a consulta com um timeout
      DataModulePrincipal.FDQueryEmpresa.Open;
      // Processa os dados retornados da consulta
      while not DataModulePrincipal.FDQueryEmpresa.Eof do
      begin
        ComboBoxPesquisaDeEmpresa.Items.AddObject(
          DataModulePrincipal.FDQueryEmpresa.FieldByName('NomeEmpresa').AsString,
          TObject(DataModulePrincipal.FDQueryEmpresa.FieldByName('IDEmpresa').AsInteger)
        );
        DataModulePrincipal.FDQueryEmpresa.Next;
      end;
    end
    else if dbType = 'SQL Server' then
    begin
      // Código para SQL Server
      DataModulePrincipal.ADOQueryEmpresa.Close;
      DataModulePrincipal.ADOQueryEmpresa.SQL.Text := 'SELECT IDEmpresa, NomeEmpresa FROM Empresa ORDER BY NomeEmpresa';
      // Executa a consulta com um timeout
      DataModulePrincipal.ADOQueryEmpresa.Open;
      // Processa os dados retornados da consulta
      while not DataModulePrincipal.ADOQueryEmpresa.Eof do
      begin
        ComboBoxPesquisaDeEmpresa.Items.AddObject(
          DataModulePrincipal.ADOQueryEmpresa.FieldByName('NomeEmpresa').AsString,
          TObject(DataModulePrincipal.ADOQueryEmpresa.FieldByName('IDEmpresa').AsInteger)
        );
        DataModulePrincipal.ADOQueryEmpresa.Next;
      end;
    end;

    // Seleciona o primeiro item automaticamente, se houver
    if ComboBoxPesquisaDeEmpresa.Items.Count > 0 then
      ComboBoxPesquisaDeEmpresa.ItemIndex := 0;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao carregar as empresas: ' + E.Message);
    end;
  end;

  // Fechar a consulta e a conexão após o uso
  if dbType = 'SQLite' then
    DataModulePrincipal.FDQueryEmpresa.Close
  else if dbType = 'SQLServer' then
    DataModulePrincipal.ADOQueryEmpresa.Close;
end;


procedure TNMPesquisaDeEmpresa.FormShow(Sender: TObject);
begin
  CarregarEmpresas;
end;
// Dispara quando o formulário é fechado
procedure TNMPesquisaDeEmpresa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Se houver uma empresa selecionada, pega o IDEmpresa
  if ComboBoxPesquisaDeEmpresa.ItemIndex <> -1 then
    IDEmpresaSelecionada := Integer(ComboBoxPesquisaDeEmpresa.Items.Objects[ComboBoxPesquisaDeEmpresa.ItemIndex]);
end;
end.


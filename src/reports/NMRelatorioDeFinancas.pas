unit NMRelatorioDeFinancas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, FRelatorioDeFinancas,uDataModulePrincipal,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls;

type
  TNMRelatorioFinancas = class(TForm)
    LabelDataInicio: TLabel;
    LabelDataFim: TLabel;
    BtImprimir: TButton;
    DateTimePickerInicial: TDateTimePicker;
    DateTimePickerFinal: TDateTimePicker;
    Label1: TLabel;
    LabelCliente: TLabel;
    ComboBoxProduto: TComboBox;
    procedure BtImprimirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NMRelatorioFinancas: TNMRelatorioFinancas;

implementation

{$R *.dfm}

procedure TNMRelatorioFinancas.BtImprimirClick(Sender: TObject);
var
 DataInicial, DataFim: TDateTime;
 FormRelatorio: TFRelatorioFinancas;

begin
  // Obtém a data inicial do DateTimePicker
  DataInicial := DateTimePickerInicial.Date;
  DataFim :=  DateTimePickerFinal.Date;


  // Instancia o formulário de relatório
  FormRelatorio := TFRelatorioFinancas.Create(Self);
  try
    // Chama a procedure para gerar o relatório passando o ID da empresa (ou 0 caso não tenha sido selecionada)
    FormRelatorio.GerarRelatorio(DataInicial, DataFim,ComboBoxProduto.Text);
  finally
    // Libera o formulário da memória
    FormRelatorio.Free;
  end;
end;

procedure TNMRelatorioFinancas.FormCreate(Sender: TObject);
begin
  DateTimePickerInicial.Date := Now - 15;
  DateTimePickerFinal.Date := Now + 15;


  if dbType = 'SQLite' then
  begin
    DataModulePrincipal.FDQueryPedido.Close;
    DataModulePrincipal.FDQueryPedido.SQL.Text :=
      'SELECT NomeProduto, ' +
      '  CASE WHEN NomeProduto = ''--- Todos ---'' THEN 0 ELSE 1 END AS Ordem ' +
      'FROM (' +
      '  SELECT ''--- Todos ---'' AS NomeProduto ' +
      '  UNION ' +
      '  SELECT DISTINCT NomeProduto FROM ItemPedido' +
      ') ' +
      'ORDER BY Ordem, NomeProduto';

    DataModulePrincipal.FDQueryPedido.Open;

    ComboBoxProduto.Items.Clear;
    while not DataModulePrincipal.FDQueryPedido.Eof do
    begin
      ComboBoxProduto.Items.Add(DataModulePrincipal.FDQueryPedido.FieldByName('NomeProduto').AsString);
      DataModulePrincipal.FDQueryPedido.Next;
    end;

    // Seleciona a primeira opção: '--- Todos ---'
    if ComboBoxProduto.Items.Count > 0 then
      ComboBoxProduto.ItemIndex := 0;
  end
  else if dbType = 'SQL Server' then
  begin
    DataModulePrincipal.ADOQueryPedido.Close;
    DataModulePrincipal.ADOQueryPedido.SQL.Text :=
      'SELECT NomeProduto FROM (' +
      '  SELECT ''--- Todos ---'' AS NomeProduto ' +
      '  UNION ' +
      '  SELECT DISTINCT NomeProduto FROM ItemPedido' +
      ') AS Produtos ' +
      'ORDER BY CASE WHEN NomeProduto = ''--- Todos ---'' THEN 0 ELSE 1 END, NomeProduto';

    DataModulePrincipal.ADOQueryPedido.Open;

    ComboBoxProduto.Items.Clear;
    while not DataModulePrincipal.ADOQueryPedido.Eof do
    begin
      ComboBoxProduto.Items.Add(DataModulePrincipal.ADOQueryPedido.FieldByName('NomeProduto').AsString);
      DataModulePrincipal.ADOQueryPedido.Next;
    end;
    // Seleciona a primeira opção: '--- Todos ---'
    if ComboBoxProduto.Items.Count > 0 then
      ComboBoxProduto.ItemIndex := 0;
  end;
end;

end.

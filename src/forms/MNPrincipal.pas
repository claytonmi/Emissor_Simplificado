unit MNPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus,
  MNRelatorioSemanal, NMPesquisaPedido, MNCadastroCliente, NMInformacoes, NMCadastroDeProduto, NMCadastroDeEmpresa,
  uDataModulePrincipal,
  System.IOUtils, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids,
  System.Generics.Collections,
  Data.DB, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.DBCtrls,
  Vcl.Buttons, Math, Vcl.ComCtrls,  NMConfiguracao;

type
  TEmissorPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    Cadastro1: TMenuItem;
    MNCadastroProduto: TMenuItem;
    MNCadastrodeCliente: TMenuItem;
    Relatrio1: TMenuItem;
    Rodape: TPanel;
    RodaPeVersion: TPanel;
    RodaPeHora: TPanel;
    Panel1: TPanel;
    PNButoes: TPanel;
    BtNovoPedido: TButton;
    PanelListaItens: TPanel;
    Panel4: TPanel;
    BtSalvar: TButton;
    BtCancelarPedido: TButton;
    BtFecharPedido: TButton;
    BtInserirItem: TButton;
    EdQtdItem: TEdit;
    EdCodigoVenda: TEdit;
    EdCodigoCliente: TEdit;
    EdTelefoneCliente: TEdit;
    EdEmail: TEdit;
    BtEditarPedido: TButton;
    EdValorItem: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel2: TPanel;
    EdNomeCliente: TComboBox;
    CBEdNomeProduto: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    StringGridList: TStringGrid;
    BtEditarItem: TBitBtn;
    BtGravarItem: TButton;
    BtExcluirItem: TButton;
    PanelObs: TPanel;
    LabTotal: TLabel;
    LabValorTotal: TLabel;
    Label10: TLabel;
    LabDescItens: TLabel;
    LabObs: TLabel;
    MemoOBS: TMemo;
    EdDescItem: TEdit;
    Label11: TLabel;
    N1: TMenuItem;
    NMCadastrodeEmpresas: TMenuItem;
    EdDataPedido: TDateTimePicker;
    LabelContador: TLabel;
    Configurao1: TMenuItem;
    Configurao2: TMenuItem;
    Backupdobanco1: TMenuItem;
    BalloonHintComoUsar: TBalloonHint;
    N2: TMenuItem;
    ComousaroSistema1: TMenuItem;
    N3: TMenuItem;
    Informaes1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MNCadastrodeClienteClick(Sender: TObject);
    procedure MNCadastroProdutoClick(Sender: TObject);
    procedure BtNovoPedidoClick(Sender: TObject);
    procedure EdNomeCliente1Change(Sender: TObject);
    procedure BtSalvarClick(Sender: TObject);
    procedure BtInserirItemClick(Sender: TObject);
    procedure CBEdNomeProdutoChange(Sender: TObject);
    procedure BtEditarItemClick(Sender: TObject);
    procedure StringGridListDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure BtGravarItemClick(Sender: TObject);
    procedure BtExcluirItemClick(Sender: TObject);
    procedure BtFecharPedidoClick(Sender: TObject);
    procedure BtCancelarPedidoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtEditarPedidoClick(Sender: TObject);
    procedure CarregarPedidoEdicao(IDVenda: Integer);
    procedure Relatrio1Click(Sender: TObject);
    procedure EdQtdItemKeyPress(Sender: TObject; var Key: Char);
    procedure EdQtdItemExit(Sender: TObject);
    procedure EdValorItemKeyPress(Sender: TObject; var Key: Char);
    procedure EdDescItemKeyPress(Sender: TObject; var Key: Char);
    procedure EdDescItemExit(Sender: TObject);
    procedure MemoOBSKeyPress(Sender: TObject; var Key: Char);
    procedure MemoOBSChange(Sender: TObject);
    procedure NMCadastrodeEmpresasClick(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure MemoOBSExit(Sender: TObject);
    procedure Configurao1Click(Sender: TObject);
    procedure Backupdobanco1Click(Sender: TObject);
    procedure ComousaroSistema1Click(Sender: TObject);
    procedure StringGridListSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Informaes1Click(Sender: TObject);

  private
    { Private declarations }
    BasePath: string; // Vari�vel para o caminho base do sistema
    FValorOriginal: Double;
    FUpdatingMemo: Boolean;
    FValorItemAlterado: Boolean;
    FDescItemAlterado: Boolean;
    FQtdItemAlterado: Boolean;
    TutorialAtivo: Boolean;
    procedure CarregarClientes;
    procedure AtualizarGridItens;
    procedure CarregarProdutos;
    procedure SalvarEdicaoItem;
    procedure IniciarTransacao;
    procedure FinalizarTransacao(Sucesso: Boolean);
    procedure CarregarUltimoPedido;
    function PedidoTemItens(PedidoID: Integer): Boolean;
    function ObterIDProduto(IDProduto: Integer): Integer;
    function ObterPrecoProduto(idProduto: Integer): Double;
    function QuebrarTextoMemo(const Texto: string; TamanhoLinha: Integer): string;

  public
    procedure AtualizarConfiguracoes;

    { Public declarations }
  end;

var
  EmissorPrincipal: TEmissorPrincipal;

implementation

{$R *.dfm}

uses FrmSplashArt;

function TEmissorPrincipal.QuebrarTextoMemo(const Texto: string; TamanhoLinha: Integer): string;
var
  i, PosInicio: Integer;
begin
  Result := '';
  PosInicio := 1;
  while PosInicio <= Length(Texto) do
  begin
    i := PosInicio + TamanhoLinha - 1;
    if i > Length(Texto) then
      i := Length(Texto);
    Result := Result + Copy(Texto, PosInicio, i - PosInicio + 1) + sLineBreak;
    PosInicio := i + 1;
  end;
end;


procedure TEmissorPrincipal.Backupdobanco1Click(Sender: TObject);
var
  CaminhoBanco, CaminhoBackup, DestinoBackup: string;
  QtdDias: Integer;
  DataLimite, DataAtual: TDateTime;
begin
  // Obt�m o caminho do banco de dados em uso
  CaminhoBanco := DataModulePrincipal.FDConnection.Params.Values['Database'];
  // Busca o caminho de backup na tabela Configuracao
  with DataModulePrincipal.FDQueryConfiguracao do
  begin
    DataModulePrincipal.FDQueryConfiguracao.Close;
    DataModulePrincipal.FDQueryConfiguracao.SQL.Text := 'SELECT CaminhoBackup FROM Configuracao WHERE NomeConfiguracao = :Nome';
    DataModulePrincipal.FDQueryConfiguracao.ParamByName('Nome').AsString := 'CaminhoDoBackupDoBanco';
    DataModulePrincipal.FDQueryConfiguracao.Open;
    if IsEmpty then
    begin
      ShowMessage('O caminho de backup n�o est� configurado.');
      Exit;
    end;
    CaminhoBackup := DataModulePrincipal.FDQueryConfiguracao.FieldByName('CaminhoBackup').AsString;
  end;
  // Define o caminho final do backup
  DestinoBackup := IncludeTrailingPathDelimiter(CaminhoBackup) + 'Vendas_Backup_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.db';
  // Confirma��o do usu�rio
 if MessageDlg('ATEN��O: O local do backup deve permitir a cria��o e c�pia de arquivos.' + sLineBreak +
                'Deseja continuar com o backup para o caminho:' + sLineBreak + DestinoBackup + '?',
                mtWarning, [mbYes, mbNo], 0) = mrNo then
    Exit;
  try
    // Desconecta o banco antes de copiar
    DataModulePrincipal.FDConnection.Connected := False;
    // Copia o arquivo do banco para o local de backup
    if FileExists(CaminhoBanco) then
      CopyFile(PChar(CaminhoBanco), PChar(DestinoBackup), False)
    else
    begin
      ShowMessage('Arquivo do banco de dados n�o encontrado!');
      Exit;
    end;
    // Reconecta ao banco
    DataModulePrincipal.FDConnection.Connected := True;
    ShowMessage('Backup realizado com sucesso em: ' + DestinoBackup);

     // Agora verifica o valor de QtdDiasParaLimparBanco
    with DataModulePrincipal.FDQueryConfiguracao do
    begin
      Close;
      SQL.Text := 'SELECT QtdDias FROM Configuracao WHERE NomeConfiguracao = ''QtdDiasParaLimparBanco''';
      Open;

      if not IsEmpty then
      begin
        QtdDias := FieldByName('QtdDias').AsInteger;

        if QtdDias > 0 then
        begin
          // Calcula a data limite (data atual menos QtdDias)
          DataAtual := Date;
          DataLimite := DataAtual - QtdDias;

          // Exibe a mensagem informando ao usu�rio que QtdDias > 0
          MessageDlg('A configura��o de limpeza de or�amentos est� ativada.' + sLineBreak +
                     'Os or�amentos e itens do or�amento com data anterior a ' + DateToStr(DataLimite) +
                     ' ser�o exclu�dos. Apenas os or�amentos realizados a partir dessa data ser�o mantidos.',
                     mtWarning, [mbOK], 0);

          // Apaga os itens de pedido mais antigos
          DataModulePrincipal.FDQueryConfiguracao.Close;
          DataModulePrincipal.FDQueryConfiguracao.SQL.Text :=
            'DELETE FROM ItemPedido WHERE IDVenda NOT IN (SELECT IDVenda FROM Pedido WHERE Data >= :DataLimite)';
          DataModulePrincipal.FDQueryConfiguracao.ParamByName('DataLimite').AsDateTime := DataLimite;
          DataModulePrincipal.FDQueryConfiguracao.ExecSQL;

          // Apaga os pedidos mais antigos que a data limite
          DataModulePrincipal.FDQueryConfiguracao.SQL.Text :=
            'DELETE FROM Pedido WHERE Data < :DataLimite';
          DataModulePrincipal.FDQueryConfiguracao.ParamByName('DataLimite').AsDateTime := DataLimite;
          DataModulePrincipal.FDQueryConfiguracao.ExecSQL;
          DataModulePrincipal.FDQueryConfiguracao.Close;

          // Informa o usu�rio sobre a exclus�o
          ShowMessage('Pedidos e itens de pedidos antigos foram apagados com sucesso.');
        end;
      end;
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao fazer backup: ' + E.Message);
  end;
end;

procedure TEmissorPrincipal.BtCancelarPedidoClick(Sender: TObject);
var
  PedidoCount: Integer;
begin
  // Verifica se o pedido foi salvo (status 'A' - Ativo)
  if EdCodigoVenda.Text = '' then
  begin
    ShowMessage('Nenhum pedido selecionado para cancelar.');
    Exit;
  end;

  if MessageDlg('Tem certeza que deseja cancelar este pedido?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      // Deleta os itens do pedido
      with DataModulePrincipal.FDQueryItemPedido do
      begin
        Close;
        SQL.Text := 'DELETE FROM ItemPedido WHERE IDVenda = :IDVenda';
        ParamByName('IDVenda').AsInteger := StrToInt(EdCodigoVenda.Text);
        ExecSQL;
      end;

      // Deleta o pedido
      with DataModulePrincipal.FDQueryPedido do
      begin
        Close;
        SQL.Text := 'DELETE FROM Pedido WHERE IDVenda = :IDVenda';
        ParamByName('IDVenda').AsInteger := StrToInt(EdCodigoVenda.Text);
        ExecSQL;
      end;
      DataModulePrincipal.FDConnection.Commit;

      // Limpa todos os campos da tela
      EdCodigoVenda.Clear;
      EdDataPedido.Date := Now;
      EdCodigoCliente.Clear;
      EdTelefoneCliente.Clear;
      EdEmail.Clear;
      CBEdNomeProduto.ItemIndex := -1;  // Limpa a sele��o do ComboBox
      EdNomeCliente.ItemIndex := -1;
      EdValorItem.Clear;
      EdQtdItem.Clear;
      EdTelefoneCliente.Enabled := False;
      EdEmail.Enabled := False;
      EdNomeCliente.Clear;
      EdNomeCliente.Enabled := False;
      EdTelefoneCliente.Enabled := False;
      EdEmail.Enabled := False;
      BtInserirItem.Enabled := False;
      BtEditarItem.Enabled := False;
      BtGravarItem.Enabled := False;
      BtExcluirItem.Enabled := False;
      CBEdNomeProduto.Enabled := False;
      BtFecharPedido.Enabled := False;
      EdValorItem.Enabled := False;
      EdQtdItem.Enabled := False;
      EdDataPedido.Enabled := false;
      MemoOBS.Clear;
      MemoOBS.Enabled := false;
      CBEdNomeProduto.Color := clWindow;
      LabelContador.Caption := '0/500';

      MNCadastroProduto.Enabled := True;
      MNCadastrodeCliente.Enabled := True;
      NMCadastrodeEmpresas.Enabled := True;
      // Limpa os dados do StringGrid
      StringGridList.RowCount := 1; // Mant�m apenas o cabe�alho

      // Verifica se ainda existem pedidos na tabela
      PedidoCount := DataModulePrincipal.FDConnection.ExecSQLScalar('SELECT COUNT(*) FROM Pedido');

      // Atualiza o estado dos bot�es
      BtNovoPedido.Enabled := True;
      BtEditarPedido.Enabled := PedidoCount > 0; // Habilita apenas se houver pedidos
      BtCancelarPedido.Enabled := False; // Desabilita o bot�o de cancelar ap�s o pedido ser cancelado

      ShowMessage('Pedido cancelado com sucesso.');
    except
      on E: Exception do
      begin
        DataModulePrincipal.FDConnection.Rollback; // Rollback caso ocorra erro
        ShowMessage('Erro ao cancelar o pedido: ' + E.Message);
      end;
    end;
  end;
end;



procedure TEmissorPrincipal.BtEditarItemClick(Sender: TObject);
var
  ProdutoNome: string;
  Qtd: Integer;
  ValorUnitario, EdDesc: Double;
begin
  if StringGridList.Row < 1 then
  begin
    ShowMessage('Selecione um item para editar.');
    Exit;
  end;

  // Obtem os valores do item selecionado na StringGrid
  ProdutoNome := StringGridList.Cells[1, StringGridList.Row];
  ValorUnitario := StrToFloatDef(StringGridList.Cells[2, StringGridList.Row],
    0); // Corrigido o uso de StrToFloatDef para evitar exce��o
  Qtd := StrToIntDef(StringGridList.Cells[3, StringGridList.Row], 0);
  EdDesc := StrToFloatDef(StringGridList.Cells[4, StringGridList.Row], 0);

  // Preenche os campos de edi��o
  CBEdNomeProduto.Text := ProdutoNome;
  EdQtdItem.Text := IntToStr(Qtd);
  EdValorItem.Text := FormatFloat('0.00', ValorUnitario);
  EdDescItem.Text :=  FormatFloat('0.00', EdDesc);;


  // Habilita os campos para edi��o
  CBEdNomeProduto.Enabled := true;
  EdQtdItem.Enabled := true;
  EdValorItem.Enabled := true;
  EdDescItem.Enabled := true;
  BtGravarItem.Enabled := true;
  BtInserirItem.Enabled := false;
  BtExcluirItem.Enabled := false;

    if TutorialAtivo then
  begin
    // Esconde o bal�o anterior e mostra no bot�o BtSalvar
    BalloonHintComoUsar.HideHint;
    BalloonHintComoUsar.Title := 'Passo 8: Gravar altera��o';
    BalloonHintComoUsar.Description := 'Agora clique aqui para salvar a edi��o do item.';
    BalloonHintComoUsar.ShowHint(BtGravarItem);
  end;
end;

procedure TEmissorPrincipal.BtExcluirItemClick(Sender: TObject);
var
  IDItem: Integer;
begin
  if StringGridList.Row < 1 then
  begin
    ShowMessage('Selecione um item para excluir.');
    Exit;
  end;

  if MessageDlg('Tem certeza de que deseja excluir o item selecionado?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      // Obtem o ID do item a ser exclu�do
      IDItem := StrToIntDef(StringGridList.Cells[0, StringGridList.Row], 0);

      // Remove o item do banco de dados
      with DataModulePrincipal.FDQueryItemPedido do
      begin
        Close;
        SQL.Text := 'DELETE FROM ItemPedido WHERE IDItem = :IDItem';
        ParamByName('IDItem').AsInteger := IDItem;
        ExecSQL;
      end;
      DataModulePrincipal.FDConnection.Commit;

    AtualizarGridItens;


    except
      on E: Exception do
        ShowMessage('Erro ao excluir o item: ' + E.Message);
    end;
  end;
end;

procedure TEmissorPrincipal.BtFecharPedidoClick(Sender: TObject);
begin

  try
    // Atualiza o pedido para indicar que foi fechado
    with DataModulePrincipal.FDQueryPedido do
    begin
      Close;
      SQL.Text :=
        'UPDATE Pedido SET FlStatus = :FlStatus, Observacao = :Observacao, TotalPedido = :TotalPed WHERE IDVenda = :IDVenda';
      ParamByName('FlStatus').AsString := 'F';
      ParamByName('IDVenda').AsInteger := StrToInt(EdCodigoVenda.Text);
      ParamByName('Observacao').AsString := MemoOBS.Text;
      ParamByName('TotalPed').AsFloat := StrToFloatDef(LabValorTotal.Caption, 0.00);
      ExecSQL;
    end;

    // Finaliza a transa��o
    DataModulePrincipal.FDConnection.Commit;
    ShowMessage('Pedido fechado com sucesso.');
  except
    on E: Exception do
    begin
      DataModulePrincipal.FDConnection.Rollback;
      ShowMessage('Erro ao fechar pedido: ' + E.Message);
      Exit;
    end;
  end;

  // Limpar os campos do pedido
  EdCodigoVenda.Clear;
  EdDataPedido.Date := Now;
  EdCodigoCliente.Clear;
  EdTelefoneCliente.Clear;
  EdEmail.Clear;
  CBEdNomeProduto.ItemIndex := -1; // Limpa a sele��o do ComboBox
  EdValorItem.Clear;
  EdQtdItem.Clear;
  EdNomeCliente.ItemIndex := -1;
  EdNomeCliente.Clear;
  MemoOBS.Clear;
  MemoOBS.Enabled := false;
  EdDescItem.Enabled := false;
  EdDataPedido.Enabled := false;
  LabDescItens.Caption := '0.00';
  LabValorTotal.Caption := '0.00';
  LabelContador.Caption := '0/500';


  // Limpa os dados do StringGrid
  StringGridList.RowCount := 1; // Mant�m apenas o cabe�alho
  StringGridList.Rows[0].Clear;

  // Atualiza o estado dos bot�es
  BtFecharPedido.Enabled := false;
  BtSalvar.Enabled := false;
  BtCancelarPedido.Enabled := false;
  BtNovoPedido.Enabled := true;
  BtInserirItem.Enabled := false;
  BtEditarItem.Enabled := false;
  BtExcluirItem.Enabled := false;
  BtGravarItem.Enabled := false;
  BtEditarPedido.Enabled := True;
  MNCadastroProduto.Enabled := True;
  MNCadastrodeCliente.Enabled := true;
  NMCadastrodeEmpresas.Enabled := True;
  CBEdNomeProduto.Enabled := false;
  EdQtdItem.Enabled := false;
  EdValorItem.Enabled := false;
end;

procedure TEmissorPrincipal.BtGravarItemClick(Sender: TObject);
begin
  try
    // Salva o item editado
    SalvarEdicaoItem;

    // Desativa os campos ap�s salvar
    EdQtdItem.Enabled := false;
    EdDescItem.Enabled := false;
    EdValorItem.Enabled := false;
    BtGravarItem.Enabled := false;
    BtInserirItem.Enabled := true;
    BtExcluirItem.Enabled := true;

  except
    on E: Exception do
      ShowMessage('Erro ao salvar o item: ' + E.Message);
  end;

  if TutorialAtivo then
  begin
    if Assigned(BalloonHintComoUsar) then
    begin
      BalloonHintComoUsar.HideHint;
      BalloonHintComoUsar.Free;
      BalloonHintComoUsar := TBalloonHint.Create(Self); // Cria novamente para resetar
    end;
    TutorialAtivo := False;
  end;
end;

procedure TEmissorPrincipal.SalvarEdicaoItem;
var
  ProdutoNome: string;
  IDProduto, Qtd, IDItem: Integer;
  ValorUnitario, EdDesc, ValorTotal, ValorOriginal, ValorDigitado: Double;
begin
  if StringGridList.Row < 1 then
  begin
    ShowMessage('Selecione um item para editar.');
    Exit;
  end;
  IDItem := StrToInt(StringGridList.Cells[0, StringGridList.Row]);
  IDProduto := ObterIDProduto(IDItem);
  ValorOriginal := ObterPrecoProduto(IDProduto);
  ProdutoNome := CBEdNomeProduto.Text;
  EdDesc := StrToFloatDef(EdDescItem.Text, 0);
  Qtd := StrToIntDef(EdQtdItem.Text, 1);
  ValorDigitado := StrToFloatDef(EdValorItem.Text, 0);
  // Define o ValorUnitario conforme a altera��o do usu�rio
  if FValorItemAlterado then
  begin
    if EdDesc > 0 then
     begin
       ValorUnitario := ValorDigitado - (ValorDigitado * (EdDesc / 100));
     end
      else
     begin
         ValorUnitario := ValorDigitado;
     end;
  end
  else if FDescItemAlterado  then
  begin
   if EdDesc > 0 then
   begin
      ValorUnitario := ValorOriginal - (ValorOriginal * (EdDesc / 100));
   end
   else
   begin
      ValorUnitario := ValorOriginal;
   end;
  end
  else
  begin
    ValorUnitario := ValorDigitado;
  end;
  ValorTotal := Qtd * ValorUnitario;
  // Atualiza no banco de dados
  with DataModulePrincipal.FDQueryItemPedido do
  begin
    Close;
    SQL.Text := 'UPDATE ItemPedido ' +
      'SET NomeProduto = :NomeProduto, Quantidade = :Quantidade, Valor = :Valor, Desc = :Desc, Total = :Total ' +
      'WHERE IDItem = :IDItem';
    ParamByName('NomeProduto').AsString := ProdutoNome;
    ParamByName('Quantidade').AsInteger := Qtd;
    ParamByName('Valor').AsFloat := ValorUnitario;
    ParamByName('Desc').AsFloat := EdDesc;
    ParamByName('Total').AsFloat := ValorTotal;
    ParamByName('IDItem').AsInteger := IDItem;
    ExecSQL;
  end;
  DataModulePrincipal.FDConnection.Commit;
  AtualizarGridItens;
  // Limpa os campos e reseta as flags
  CBEdNomeProduto.ItemIndex := -1;
  CBEdNomeProduto.Clear;
  EdQtdItem.Clear;
  EdDescItem.Clear;
  EdValorItem.Clear;
  BtSalvar.Enabled := False;
  BtInserirItem.Enabled := True;
  FValorItemAlterado := False;
  FDescItemAlterado := False;
  CarregarProdutos;
end;

function TEmissorPrincipal.ObterIDProduto(IDProduto: Integer): Integer;
begin
  Result := 0; // Valor padr�o caso n�o encontre o produto

  with DataModulePrincipal.FDQueryItemPedido do
  begin
    DataModulePrincipal.FDQueryItemPedido.Close;
    DataModulePrincipal.FDQueryItemPedido.SQL.Text := 'SELECT IDProduto FROM ItemPedido  where IDItem = :IDProduto';
    DataModulePrincipal.FDQueryItemPedido.ParamByName('IDProduto').AsInteger := IDProduto;
    DataModulePrincipal.FDQueryItemPedido.Open;

    if not IsEmpty then
      Result := DataModulePrincipal.FDQueryItemPedido.FieldByName('IDProduto').AsInteger;
  end;
end;




function TEmissorPrincipal.ObterPrecoProduto(idProduto: Integer): Double;
begin
  // Defina a vari�vel para armazenar o pre�o
  var PrecoProduto: Double;

  // Execute a consulta para buscar o pre�o do produto
  DataModulePrincipal.FDQueryProduto.Close;
  DataModulePrincipal.FDQueryProduto.SQL.Text := 'SELECT Preco FROM Produto WHERE IDProduto = :idProduto';
  DataModulePrincipal.FDQueryProduto.ParamByName('idProduto').AsInteger := idProduto;
  DataModulePrincipal.FDQueryProduto.Open;

  // Verifica se o produto foi encontrado
  if not DataModulePrincipal.FDQueryProduto.IsEmpty then
  begin
    PrecoProduto := DataModulePrincipal.FDQueryProduto.FieldByName('Preco').AsFloat;
  end
  else
  begin
    // Se n�o encontrar o produto, retorna 0 ou outro valor padr�o
    PrecoProduto := 0.00;
  end;

  // Retorna o pre�o
  Result := PrecoProduto;
end;


procedure TEmissorPrincipal.StringGridListDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if gdSelected in State then
  begin
    StringGridList.Canvas.Brush.Color := clHighlight;
    StringGridList.Canvas.Font.Color := clHighlightText;
    StringGridList.Canvas.FillRect(Rect);
    StringGridList.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2,
      StringGridList.Cells[ACol, ARow]);
  end;
end;

procedure TEmissorPrincipal.StringGridListSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if TutorialAtivo then
  begin
    // Esconde o bal�o anterior e mostra no bot�o BtSalvar
    BalloonHintComoUsar.HideHint;
    BalloonHintComoUsar.Title := 'Passo 7: Editar Item';
    BalloonHintComoUsar.Description := 'Agora clique aqui para editar o item selecionado.';
    BalloonHintComoUsar.ShowHint(BtEditarItem);
  end;
end;

procedure TEmissorPrincipal.BtInserirItemClick(Sender: TObject);
var
  IDProduto, IDVenda, Qtd: Integer;
  ProdutoNome: string;
  ValorUnitario, ValorTotal, EdDesc: Double;
begin
  if (CBEdNomeProduto.ItemIndex = -1) or (EdQtdItem.Text = '') or
    (EdValorItem.Text = '') then
  begin
    ShowMessage('Selecione um produto para inserir no pedido.');
    Exit;
  end;

  try
    ProdutoNome := CBEdNomeProduto.Text;

    // Obt�m o IDProduto diretamente do ComboBox
    IDProduto := Integer(CBEdNomeProduto.Items.Objects[CBEdNomeProduto.ItemIndex]);
    // Remove o IDProduto e o tra�o para obter apenas o NomeProduto
    Delete(ProdutoNome, 1, Pos(' - ', ProdutoNome) + 2);
    Qtd := StrToInt(EdQtdItem.Text);
    ValorUnitario := StrToFloat(EdValorItem.Text);
    IDVenda := StrToInt(EdCodigoVenda.Text);
    EdDesc := StrToFloatDef(EdDescItem.Text, 0);

    if EdDesc > 0 then
      ValorUnitario := ValorUnitario - (ValorUnitario * (EdDesc / 100));

    // Obt�m o IDProduto diretamente do ComboBox
    IDProduto := Integer(CBEdNomeProduto.Items.Objects[CBEdNomeProduto.ItemIndex]);

    // Calcula o valor total
    ValorTotal := Qtd * ValorUnitario;

    // Insere os dados na tabela `ItemPedido`
    with DataModulePrincipal.FDQueryItemPedido do
    begin
      Close;
      SQL.Text :=
        'INSERT INTO ItemPedido (IDVenda, IDProduto, NomeProduto, Quantidade, Valor, Total, Desc, DataInsercao) ' +
        'VALUES (:IDVenda, :IDProduto, :NomeProduto, :Quantidade, :Valor, :Total, :Desc, :DataInsercao)';
      ParamByName('IDVenda').AsInteger := IDVenda;
      ParamByName('IDProduto').AsInteger := IDProduto;
      ParamByName('NomeProduto').AsString := ProdutoNome;
      ParamByName('Quantidade').AsInteger := Qtd;
      ParamByName('Valor').AsFloat := ValorUnitario;
      ParamByName('Total').AsFloat := ValorTotal;
      ParamByName('Desc').AsFloat := EdDesc;
      ParamByName('DataInsercao').AsDateTime := Now;
      ExecSQL;
    end;
    DataModulePrincipal.FDConnection.Commit;

    // Atualiza o grid para exibir o item inserido
    AtualizarGridItens;

    // Limpa os campos para nova inser��o
    EdDescItem.Clear;
    CBEdNomeProduto.ItemIndex := -1;
    EdQtdItem.Clear;
    EdValorItem.Clear;
    BtExcluirItem.Enabled := True;
    BtEditarItem.Enabled := True;
    EdQtdItem.Enabled := False;
    EdValorItem.Enabled := False;
  except
    on E: Exception do
      ShowMessage('Erro ao inserir item: ' + E.Message);
  end;

  if TutorialAtivo then
  begin
    // Esconde o bal�o anterior e mostra no bot�o BtSalvar
    BalloonHintComoUsar.HideHint;
    BalloonHintComoUsar.Title := 'Passo 6: Selecione um item';
    BalloonHintComoUsar.Description := 'Agora selecione um produto na lista de itens.';
    BalloonHintComoUsar.ShowHint(StringGridList);
  end;
end;


procedure TEmissorPrincipal.AtualizarGridItens;
var
  i: Integer;
  TotalDescontos, TotalGeral: Double;
begin

if DataModulePrincipal.VerificarExibirDataInsercao then
begin
  AtualizarConfiguracoes;
  i := 1;
  TotalDescontos := 0; // Resetar antes da soma
  TotalGeral := 0;     // Resetar antes da soma

  // A consulta agora � realizada a cada chamada da fun��o
  with DataModulePrincipal.FDQueryItemPedido do
  begin
    SQL.Text :=
      'SELECT IDItem, NomeProduto, Valor, Quantidade, Desc, Total, DataInsercao ' +
      'FROM ItemPedido WHERE IDVenda = :IDVenda';
    ParamByName('IDVenda').AsInteger := StrToInt(EdCodigoVenda.Text);

    Open;

    // Preenche a grid com os dados da consulta
    while not EOF do
    begin
      if i >= StringGridList.RowCount then
        StringGridList.RowCount := i + 1;

      // Preenche os dados
      StringGridList.Cells[0, i] := IntToStr(FieldByName('IDItem').AsInteger);
      StringGridList.Cells[1, i] := FieldByName('NomeProduto').AsString;
      StringGridList.Cells[2, i] := FormatFloat('0.00', FieldByName('Valor').AsFloat);
      StringGridList.Cells[3, i] := FieldByName('Quantidade').AsString;
      StringGridList.Cells[4, i] := FormatFloat('0.00', FieldByName('Desc').AsFloat);
      StringGridList.Cells[5, i] := FormatFloat('0.00', FieldByName('Total').AsFloat);
      StringGridList.Cells[6, i] := FormatDateTime('dd/mm/yyyy', FieldByName('DataInsercao').AsDateTime);

      // Acumula os valores de desconto e total
      TotalDescontos := TotalDescontos + FieldByName('Desc').AsFloat;
      TotalGeral := TotalGeral + FieldByName('Total').AsFloat;

      Inc(i);
      Next;
    end;

    Close;
  end;
end
else
begin
  AtualizarConfiguracoes;
  i := 1;
  TotalDescontos := 0; // Resetar antes da soma
  TotalGeral := 0;     // Resetar antes da soma

  // A consulta agora � realizada a cada chamada da fun��o
  with DataModulePrincipal.FDQueryItemPedido do
  begin
    SQL.Text :=
      'SELECT IDItem, NomeProduto, Valor, Quantidade, Desc, Total ' +
      'FROM ItemPedido WHERE IDVenda = :IDVenda';
    ParamByName('IDVenda').AsInteger := StrToInt(EdCodigoVenda.Text);

    Open;

    // Preenche a grid com os dados da consulta
    while not EOF do
    begin
      if i >= StringGridList.RowCount then
        StringGridList.RowCount := i + 1;

      // Preenche os dados
      StringGridList.Cells[0, i] := IntToStr(FieldByName('IDItem').AsInteger);
      StringGridList.Cells[1, i] := FieldByName('NomeProduto').AsString;
      StringGridList.Cells[2, i] := FormatFloat('0.00', FieldByName('Valor').AsFloat);
      StringGridList.Cells[3, i] := FieldByName('Quantidade').AsString;
      StringGridList.Cells[4, i] := FormatFloat('0.00', FieldByName('Desc').AsFloat);
      StringGridList.Cells[5, i] := FormatFloat('0.00', FieldByName('Total').AsFloat);

      // Acumula os valores de desconto e total
      TotalDescontos := TotalDescontos + FieldByName('Desc').AsFloat;
      TotalGeral := TotalGeral + FieldByName('Total').AsFloat;

      Inc(i);
      Next;
    end;

    Close;
  end;
end;

  // Atualiza os labels com os valores totais corretamente formatados
  LabDescItens.Caption := FormatFloat('0.00', TotalDescontos);
  LabValorTotal.Caption := FormatFloat('0.00', TotalGeral);

  // Ajusta n�mero de linhas se necess�rio
  if i < StringGridList.RowCount then
    StringGridList.RowCount := Max(2, i);

  // Verifica se h� itens para habilitar/desabilitar bot�es
  if i = 1 then
  begin
    BtEditarItem.Enabled := False;
    BtExcluirItem.Enabled := False;
    BtFecharPedido.Enabled := False;
  end
  else
  begin
    BtEditarItem.Enabled := True;
    BtExcluirItem.Enabled := True;
    BtFecharPedido.Enabled := True;
  end;

  // Se n�o houver itens, exibe uma linha vazia
  if i = 1 then
  begin
    StringGridList.RowCount := 2;
    StringGridList.Rows[1].Clear;
  end;
end;

procedure TEmissorPrincipal.BtNovoPedidoClick(Sender: TObject);
begin
  if TutorialAtivo then
  begin
    BalloonHintComoUsar.HideHint;
    BalloonHintComoUsar.Title := 'Passo 2: Nome do Cliente';
    BalloonHintComoUsar.Description := 'Selecione um cliente antes de continuar.';
    BalloonHintComoUsar.ShowHint(EdNomeCliente);
  end;


  // Limpa a grid ao iniciar um novo pedido
  StringGridList.RowCount := 2; // Mant�m o cabe�alho e a linha de dados
  StringGridList.Rows[1].Clear; // Limpa a linha de dados

  // Ativar campos do cabe�alho
  EdNomeCliente.Enabled := true;
  CarregarClientes;

  // Limpar valores antigos
  EdCodigoVenda.Clear;
  EdCodigoCliente.Clear;
  EdTelefoneCliente.Clear;
  EdEmail.Clear;
  EdDataPedido.Date := Now;
  MemoOBS.Clear;
  MemoOBS.Enabled := true;
  EdDataPedido.Enabled := true;
  EdDataPedido.Enabled := true;

  // Preparar o ComboBox de produtos
  CBEdNomeProduto.Enabled := false;
  BtNovoPedido.Enabled := false;
  MNCadastroProduto.Enabled := false;
  MNCadastrodeCliente.Enabled := False;
  NMCadastrodeEmpresas.Enabled := False;
  BtEditarPedido.Enabled := false;
end;

procedure TEmissorPrincipal.BtSalvarClick(Sender: TObject);
var
  NovoIDVenda: Integer;
begin
  if EdDataPedido.Date > Date then
  begin
    ShowMessage('A data do pedido n�o pode ser futura!');
    EdDataPedido.Date := Now;
    Exit;
  end;
  try
    // Insere o pedido no banco de dados
    DataModulePrincipal.FDQueryPedido.Close;
    DataModulePrincipal.FDQueryPedido.SQL.Text :=
      'INSERT INTO Pedido (IDCliente, NomeCliente, TelefoneCliente, EmailCliente, Data) '
      + 'VALUES (:IDCliente, :NomeCliente, :TelefoneCliente, :EmailCliente, COALESCE(:Data, CURRENT_DATE))';

    DataModulePrincipal.FDQueryPedido.ParamByName('IDCliente').AsInteger :=
      StrToIntDef(EdCodigoCliente.Text, 0);
    DataModulePrincipal.FDQueryPedido.ParamByName('NomeCliente').AsString :=
      EdNomeCliente.Text;
    DataModulePrincipal.FDQueryPedido.ParamByName('TelefoneCliente').AsString :=
      EdTelefoneCliente.Text;
    DataModulePrincipal.FDQueryPedido.ParamByName('EmailCliente').AsString :=
      EdEmail.Text;
    DataModulePrincipal.FDQueryPedido.ParamByName('Data').AsDate := EdDataPedido.Date;

    DataModulePrincipal.FDQueryPedido.ExecSQL;
    DataModulePrincipal.FDConnection.Commit;

    // Recupera o ID do �ltimo pedido gerado
    DataModulePrincipal.FDQueryPedido.SQL.Text :=
      'SELECT LAST_INSERT_ROWID() AS IDVenda';
    DataModulePrincipal.FDQueryPedido.Open;
    NovoIDVenda := DataModulePrincipal.FDQueryPedido.FieldByName('IDVenda')
      .AsInteger;

    // Atualiza o campo EdCodigoVenda
    EdCodigoVenda.Text := IntToStr(NovoIDVenda);

    // Desabilita os campos do cliente
    EdNomeCliente.Enabled := false;
    EdTelefoneCliente.Enabled := false;
    EdEmail.Enabled := false;
    EdDataPedido.Enabled := false;

    // Habilita a sele��o de produtos
    CBEdNomeProduto.Enabled := true;
    StringGridList.Options := StringGridList.Options + [goRowSelect];


    BtSalvar.Enabled := false;
    BtCancelarPedido.Enabled := true;
    BtNovoPedido.Enabled := false;
    CBEdNomeProduto.Color := clLime;


    CarregarProdutos;
  except
    on E: Exception do
      ShowMessage('Erro ao salvar pedido: ' + E.Message);
  end;
  if TutorialAtivo then
  begin
    // Esconde o bal�o anterior e mostra no bot�o BtSalvar
    BalloonHintComoUsar.HideHint;
    BalloonHintComoUsar.Title := 'Passo 4: Nome do Produto';
    BalloonHintComoUsar.Description := 'Agora selecione um produto para o or�amento.';
    BalloonHintComoUsar.ShowHint(CBEdNomeProduto);
  end;
end;

procedure TEmissorPrincipal.EdDescItemExit(Sender: TObject);
var
  Valor: Integer;
begin
  if TryStrToInt(EdDescItem.Text, Valor) then
  begin
    if (Valor < 0) or (Valor > 100) then
    begin
      ShowMessage('O valor deve estar entre 0 e 100.');
      EdDescItem.Text := '0'; // Define um valor padr�o v�lido
      EdDescItem.SetFocus; // Retorna o foco ao campo para corrigir
    end;
  end
  else
    EdDescItem.Text := '0'; // Se o valor n�o for v�lido, define como 0
end;

procedure TEmissorPrincipal.EdDescItemKeyPress(Sender: TObject; var Key: Char);
begin
 // Permite apenas n�meros e Backspace
  if not (Key in ['0'..'9', #8]) then
  begin
    Key := #0; // Cancela a entrada do caractere inv�lido
    Exit;
  end;


  // Se algo foi digitado, marca que o usu�rio alterou o campo
  FDescItemAlterado := True;
end;

procedure TEmissorPrincipal.EdNomeCliente1Change(Sender: TObject);
var
  ClienteID: Integer;
  ClienteInfo: TStringList;
begin
  if TutorialAtivo then
  begin
    // Esconde o bal�o anterior e mostra no bot�o BtSalvar
    BalloonHintComoUsar.HideHint;
    BalloonHintComoUsar.Title := 'Passo 3: Salvar Or�amento';
    BalloonHintComoUsar.Description := 'Clique aqui para salvar o Or�amento.';
    BalloonHintComoUsar.ShowHint(BtSalvar);
  end;


  // Verifica se algum item foi selecionado
  if EdNomeCliente.ItemIndex >= 0 then
  begin
    ClienteInfo := TStringList.Create;

    EdTelefoneCliente.Enabled := true;
    EdEmail.Enabled := true;
    EdTelefoneCliente.Clear;
    EdEmail.Clear;

    try
      // Supondo que os itens do ComboBox est�o no formato "ID - Nome"
      ExtractStrings(['-'], [' '],
        PChar(EdNomeCliente.Items[EdNomeCliente.ItemIndex]), ClienteInfo);

      // Garantir que o ID foi extra�do corretamente
      if ClienteInfo.Count > 0 then
      begin
        ClienteID := StrToIntDef(Trim(ClienteInfo[0]), 0);

        // Consultar o banco de dados para preencher os campos do cliente
        if ClienteID > 0 then
        begin
          DataModulePrincipal.FDQueryCliente.Close;
          DataModulePrincipal.FDQueryCliente.SQL.Text :=
            'SELECT IDCliente, Telefone, Email FROM Cliente WHERE IDCliente = :IDCliente';
          DataModulePrincipal.FDQueryCliente.ParamByName('IDCliente').AsInteger
            := ClienteID;
          DataModulePrincipal.FDQueryCliente.Open;

          if not DataModulePrincipal.FDQueryCliente.IsEmpty then
          begin
            EdCodigoCliente.Text := DataModulePrincipal.FDQueryCliente.
              FieldByName('IDCliente').AsString;
            EdTelefoneCliente.Text :=
              DataModulePrincipal.FDQueryCliente.FieldByName
              ('Telefone').AsString;
            EdEmail.Text := DataModulePrincipal.FDQueryCliente.FieldByName
              ('Email').AsString;
            BtSalvar.Enabled := true;
          end;
        end;
      end;
    finally
      ClienteInfo.Free;
    end;
  end;
end;

procedure TEmissorPrincipal.EdQtdItemExit(Sender: TObject);
var
  Valor: Integer;
begin
  if TryStrToInt(EdQtdItem.Text, Valor) then
  begin
    if Valor < 0 then
      EdQtdItem.Text := '1';  // Corrige para 0 se o valor for negativo
  end
  else
    EdQtdItem.Text := '1';  // Se n�o for um n�mero v�lido, define como 0
end;

procedure TEmissorPrincipal.EdQtdItemKeyPress(Sender: TObject; var Key: Char);
begin
if not (Key in ['0'..'9', #8]) then
    Key := #0;  // Bloqueia qualquer caractere que n�o seja n�mero ou Backspace

FQtdItemAlterado := true;
end;

procedure TEmissorPrincipal.EdValorItemKeyPress(Sender: TObject; var Key: Char);
begin
  // Permite n�meros, v�rgula, ponto e Backspace
  if not (Key in ['0'..'9', ',', '.', #8]) then
    Key := #0;
  // Impede mais de um ponto ou v�rgula
  if (Key in [',', '.']) and (Pos(Key, EdValorItem.Text) > 0) then
    Key := #0;
  // Impede inser��o do sinal de menos '-'
  if Key = '-' then
    Key := #0;
  // Se algo foi digitado, marca que o usu�rio alterou o campo
  FValorItemAlterado := True;
end;

procedure TEmissorPrincipal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  if DataModulePrincipal.FDConnection.InTransaction then
    DataModulePrincipal.FDConnection.Commit;

  // Aguarda at� que todas as conex�es e queries estejam inativas
  while (DataModulePrincipal.FDConnection.InTransaction or
    DataModulePrincipal.FDQueryItemPedido.Active or
    DataModulePrincipal.FDQueryPedido.Active or
    DataModulePrincipal.FDQueryCliente.Active or
    DataModulePrincipal.FDQueryProduto.Active or
    DataModulePrincipal.FDQuerySistema.Active or
    DataModulePrincipal.FDQueryEmpresa.Active or
    DataModulePrincipal.FDQueryRelatorioDePedidos.Active or
    DataModulePrincipal.FDQueryConfiguracao.Active) do
  begin
    // Tenta desativar queries e liberar recursos
    DataModulePrincipal.FDQueryItemPedido.Active := false;
    DataModulePrincipal.FDQueryPedido.Active := false;
    DataModulePrincipal.FDQueryCliente.Active := false;
    DataModulePrincipal.FDQueryProduto.Active := false;
    DataModulePrincipal.FDQuerySistema.Active := false;
    DataModulePrincipal.FDQueryEmpresa.Active := false;
    DataModulePrincipal.FDQueryRelatorioDePedidos.Active := false;
    DataModulePrincipal.FDQueryConfiguracao.Active := false;

    // Libera tempo para o sistema processar as opera��es
    Application.ProcessMessages;
  end;

    if Assigned(FrmSplash) then
    FrmSplash.Release;
  // Termina a aplica��o ap�s fechar o formul�rio principal
  Application.Terminate;

  // Ap�s finalizar todos os processos, libera o formul�rio
  Action := caFree;
end;

procedure TEmissorPrincipal.FormCreate(Sender: TObject);
begin
  if not Assigned(DataModulePrincipal) then
    DataModulePrincipal := TDataModulePrincipal.Create(Self);

  RodaPeVersion.Caption := 'Vers�o:' + DataModulePrincipal.VersaoAtual;
  RodaPeHora.Caption := 'Hora: ' + TimeToStr(Now);
  AtualizarConfiguracoes;
  CarregarUltimoPedido;
end;

procedure TEmissorPrincipal.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
   case Msg.CharCode of
    VK_F1: // Simular clique no bot�o "Novo Item"
    begin
      BtInserirItem.Click;
      Handled := True; // Indica que a tecla foi tratada
    end;
    VK_F2: // Simular clique no bot�o "Remover Item"
    begin
      BtGravarItem.Click;
      Handled := True;
    end;
    VK_F3: // Simular clique no bot�o "Salvar Or�amento"
    begin
      BtEditarItem.Click;
      Handled := True;
    end;
    VK_F4: // Simular clique no bot�o "Salvar Or�amento"
    begin
      BtExcluirItem.Click;
      Handled := True;
    end;
  end;
end;

procedure TEmissorPrincipal.CarregarUltimoPedido;
var
  PedidoID: Integer;
begin
  try
    // Consulta o �ltimo pedido
    with DataModulePrincipal.FDQueryPedido do
    begin
      Close;
      SQL.Text := 'SELECT * FROM Pedido WHERE FlStatus = ''A'' ORDER BY IDVenda DESC LIMIT 1;';
      Open;

      // Verifica se h� resultados
      if not EOF then
      begin
        // Carrega os dados do pedido nos campos
        EdCodigoVenda.Text := FieldByName('IDVenda').AsString;
        EdCodigoCliente.Text := FieldByName('IDCliente').AsString;
        EdNomeCliente.Text := FieldByName('NomeCliente').AsString;
        EdTelefoneCliente.Text := FieldByName('TelefoneCliente').AsString;
        EdEmail.Text := FieldByName('EmailCliente').AsString;
        EdDataPedido.Date := FieldByName('Data').AsDateTime;  // Usando a propriedade Date
        MemoOBS.Text := FieldByName('Observacao').AsString;

        // Atualiza os itens do pedido na StringGrid
        AtualizarGridItens;

        // Ativa os bot�es e campos necess�rios
        BtInserirItem.Enabled := True;
        CBEdNomeProduto.Enabled := True;
        BtEditarPedido.Enabled := false;
        EdNomeCliente.Enabled := false;
        BtEditarPedido.Enabled := false;
        MNCadastroProduto.Enabled := false;
        MNCadastrodeCliente.Enabled := False;
        NMCadastrodeEmpresas.Enabled := False;
        MemoOBS.Enabled := True;

        CarregarProdutos;

        // Verifica se o pedido possui itens
        PedidoID := FieldByName('IDVenda').AsInteger;
        if PedidoTemItens(PedidoID) then
        begin
          BtEditarItem.Enabled := True;
          BtExcluirItem.Enabled := True;
          BtNovoPedido.Enabled := false;
          BtCancelarPedido.Enabled := true;
        end
        else
        begin
          BtNovoPedido.Enabled := false;
          BtEditarPedido.Enabled := false;
          BtCancelarPedido.Enabled := true;
          BtEditarItem.Enabled := False;
          BtExcluirItem.Enabled := False;
        end;

      end
      else
      begin
        // Pedido ativo encontrado
        ShowMessage('Nenhum pedido ativo encontrado.');
        // Desativar campos no in�cio
        EdNomeCliente.Enabled := false;
        EdCodigoCliente.Enabled := false;
        EdTelefoneCliente.Enabled := false;
        EdEmail.Enabled := false;
        CBEdNomeProduto.Enabled := false;
        EdQtdItem.Enabled := false;
        EdValorItem.Enabled := false;
        MemoOBS.Enabled := false;
        BtSalvar.Enabled := false;
        BtNovoPedido.Enabled := true;
        BtEditarPedido.Enabled := true;
        // Desativa bot�es e campos
        BtInserirItem.Enabled := False;
        BtEditarItem.Enabled := False;
        BtExcluirItem.Enabled := False;
        MNCadastroProduto.Enabled := true;
        MNCadastrodeCliente.Enabled := true;

      end;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao carregar o �ltimo pedido: ' + E.Message);
    end;
  end;
end;

// Fun��o auxiliar para verificar se o pedido possui itens
function TEmissorPrincipal.PedidoTemItens(PedidoID: Integer): Boolean;
begin
  Result := False;
  with DataModulePrincipal.FDQueryItemPedido do
  begin
    Close;
    SQL.Text := 'SELECT COUNT(*) AS Total FROM ItemPedido WHERE IDVenda = :IDVenda;';
    ParamByName('IDVenda').AsInteger := PedidoID;
    Open;

    Result := FieldByName('Total').AsInteger > 0;
  end;
end;


procedure TEmissorPrincipal.Relatrio1Click(Sender: TObject);
begin
  if not Assigned(RelatorioSemanal) then
    RelatorioSemanal := TRelatorioSemanal.Create(Self);

  RelatorioSemanal.Show;
end;

procedure TEmissorPrincipal.CarregarProdutos;
begin
  if not Assigned(DataModulePrincipal) then
    raise Exception.Create('DataModulePrincipal n�o est� inicializado.');

  if not DataModulePrincipal.FDConnection.Connected then
    DataModulePrincipal.FDConnection.Connected := True;

  DataModulePrincipal.FDQueryProduto.Close;
  DataModulePrincipal.FDQueryProduto.SQL.Text :=
    'SELECT IDProduto, NomeProduto FROM Produto';
  try
    DataModulePrincipal.FDQueryProduto.Open;

    // Preencher o ComboBox de produtos
    CBEdNomeProduto.Items.Clear;
    while not DataModulePrincipal.FDQueryProduto.EOF do
    begin
      CBEdNomeProduto.Items.AddObject(
        Format('%d - %s', [DataModulePrincipal.FDQueryProduto.FieldByName('IDProduto').AsInteger,
        DataModulePrincipal.FDQueryProduto.FieldByName('NomeProduto').AsString]),
        TObject(DataModulePrincipal.FDQueryProduto.FieldByName('IDProduto').AsInteger));

      DataModulePrincipal.FDQueryProduto.Next;
    end;

    CBEdNomeProduto.ItemIndex := -1; // Nenhum produto selecionado inicialmente
  except
    on E: Exception do
      raise Exception.Create('Erro ao carregar produtos: ' + E.Message);
  end;
end;


procedure TEmissorPrincipal.CBEdNomeProdutoChange(Sender: TObject);
var
  PrecoProduto, EdDesc: Double;
  ProdutoID: Integer;
begin
  CBEdNomeProduto.Color := clWindow;
  try
    // Obt�m o ID do produto selecionado no combo
    if CBEdNomeProduto.ItemIndex >= 0 then
    begin
      ProdutoID := Integer(CBEdNomeProduto.Items.Objects
        [CBEdNomeProduto.ItemIndex]);

      // Busca o pre�o do produto no banco de dados
      DataModulePrincipal.FDQueryProduto.Close;
      DataModulePrincipal.FDQueryProduto.SQL.Text :=
        'SELECT Preco FROM Produto WHERE IDProduto = :IDProduto';
      DataModulePrincipal.FDQueryProduto.ParamByName('IDProduto').AsInteger :=
        ProdutoID;
      DataModulePrincipal.FDQueryProduto.Open;

      // Verifica se encontrou o produto e obt�m o pre�o
      if not DataModulePrincipal.FDQueryProduto.IsEmpty then
      begin
        PrecoProduto := DataModulePrincipal.FDQueryProduto.FieldByName
          ('Preco').AsFloat;

        // Preenche os campos com os valores
        EdQtdItem.Text := '1'; // Sugest�o de quantidade inicial
        EdValorItem.Text := FormatFloat('0.00', PrecoProduto);
        EdDescItem.Text := FormatFloat('0.00', EdDesc);


        // Habilita os campos e o bot�o
        EdQtdItem.Enabled := true;
        EdValorItem.Enabled := true;
        BtInserirItem.Enabled := true;
        EdDescItem.Enabled := true;
      end
      else
        raise Exception.Create('Produto n�o encontrado.');
    end
    else
      ShowMessage('Nenhum produto selecionado.');
  except
    on E: Exception do
      ShowMessage('Erro ao selecionar produto: ' + E.Message);
  end;
  if TutorialAtivo then
  begin
    // Esconde o bal�o anterior e mostra no bot�o BtSalvar
    BalloonHintComoUsar.HideHint;
    BalloonHintComoUsar.Title := 'Passo 5: Novo Item';
    BalloonHintComoUsar.Description := 'Clique aqui para adicionar o item na lista de itens do or�amento.';
    BalloonHintComoUsar.ShowHint(BtInserirItem);
  end;
end;

procedure TEmissorPrincipal.ComousaroSistema1Click(Sender: TObject);
begin
  TutorialAtivo := True;
  // Inicia o tutorial mostrando o bal�o no bot�o BtNovoPedido
  BalloonHintComoUsar.Title := 'Passo 1: Novo Or�amento';
  BalloonHintComoUsar.Description := 'Clique aqui para iniciar um novo or�amento.';
  BalloonHintComoUsar.ShowHint(BtNovoPedido);

end;

procedure TEmissorPrincipal.Configurao1Click(Sender: TObject);
begin
  try
    NMConfig := TNMConfig.Create(Self);
    NMConfig.ShowModal;
  finally
    FreeAndNil(NMConfig);
  end;
end;

procedure TEmissorPrincipal.CarregarClientes;
begin
  if not Assigned(DataModulePrincipal) then
    raise Exception.Create('DataModulePrincipal n�o est� inicializado.');

  if not DataModulePrincipal.FDConnection.Connected then
    DataModulePrincipal.FDConnection.Connected := true;

  DataModulePrincipal.FDQueryCliente.Close;
  DataModulePrincipal.FDQueryCliente.SQL.Text :=
    'SELECT IDCliente, Nome FROM Cliente';
  try
    DataModulePrincipal.FDQueryCliente.Open;

    // Preencher o ComboBox de nomes de clientes
    EdNomeCliente.Items.Clear;
    while not DataModulePrincipal.FDQueryCliente.EOF do
    begin
      // Adiciona cada cliente no formato "ID - Nome" para o ComboBox
      EdNomeCliente.Items.Add(Format('%d - %s',
        [DataModulePrincipal.FDQueryCliente.FieldByName('IDCliente').AsInteger,
        DataModulePrincipal.FDQueryCliente.FieldByName('Nome').AsString]));
      DataModulePrincipal.FDQueryCliente.Next;
    end;

    // Configura��es adicionais, se necess�rio
    EdNomeCliente.ItemIndex := -1; // Nenhum cliente selecionado inicialmente
  except
    on E: Exception do
      raise Exception.Create('Erro ao carregar clientes: ' + E.Message);
  end;
end;

procedure TEmissorPrincipal.MemoOBSChange(Sender: TObject);
var
  TotalCaracteres: Integer;
begin
  TotalCaracteres := Length(MemoOBS.Text);
  // Atualiza o label com a contagem de caracteres
  LabelContador.Caption := Format(' %d / 500', [TotalCaracteres]);
  // Impede que ultrapasse 500 caracteres
  if TotalCaracteres > 500 then
    MemoOBS.Text := Copy(MemoOBS.Text, 1, 500);
end;


procedure TEmissorPrincipal.MemoOBSExit(Sender: TObject);
var
  Texto, NovaTexto, Linha: string;
  i, CharCount: Integer;
begin
  Texto := Trim(MemoOBS.Text); // Remove espa�os e quebras extras no in�cio e fim
  NovaTexto := '';
  Linha := '';
  CharCount := 0;

  i := 1;
  while i <= Length(Texto) do
  begin
    // Se encontrar uma quebra de linha manual, processa corretamente
    if (Texto[i] = #13) or (Texto[i] = #10) then
    begin
      // Adiciona a linha atual ao resultado antes da quebra
      if Linha <> '' then
      begin
        NovaTexto := NovaTexto + Linha + sLineBreak;
        Linha := '';
        CharCount := 0;
      end;

      // Pula caracteres extras de quebra de linha (para evitar linhas duplas)
      while (i <= Length(Texto)) and ((Texto[i] = #13) or (Texto[i] = #10)) do
        Inc(i);

      Continue; // Evita processamento duplo
    end;

    // Adiciona caracteres � linha atual
    Linha := Linha + Texto[i];
    Inc(CharCount);

    // Quebra a linha exatamente a cada 47 caracteres
    if CharCount = 47 then
    begin
      NovaTexto := NovaTexto + Linha + sLineBreak;
      Linha := '';
      CharCount := 0;
    end;

    Inc(i);
  end;

  // Adiciona a �ltima linha, se houver texto restante
  if Linha <> '' then
    NovaTexto := NovaTexto + Linha;

  // Remove quebras de linha extras no final
  NovaTexto := TrimRight(NovaTexto);

  // Apenas altera se necess�rio para evitar reprocessamento desnecess�rio
  if MemoOBS.Text <> NovaTexto then
    MemoOBS.Text := NovaTexto;
end;




procedure TEmissorPrincipal.MemoOBSKeyPress(Sender: TObject; var Key: Char);
begin
  if Length(MemoOBS.Text) >= 500 then
  begin
    // Impede a digita��o de mais caracteres (exceto Backspace)
    if not (Key in [#8, #13, #27]) then
      Key := #0;
  end;
end;

procedure TEmissorPrincipal.MNCadastrodeClienteClick(Sender: TObject);
begin
  FCadastroCliente := TFCadastroCliente.Create(Self);
  // Cria o formul�rio secund�rio
  try
    FCadastroCliente.ShowModal; // Exibe o formul�rio de forma modal
  finally
    FCadastroCliente.Free; // Libera a mem�ria do formul�rio ap�s seu fechamento
  end;
end;

procedure TEmissorPrincipal.MNCadastroProdutoClick(Sender: TObject);
begin
  NMCadastroProduto := TNMCadastroProduto.Create(Self);
  // Cria o formul�rio secund�rio
  try
    NMCadastroProduto.ShowModal; // Exibe o formul�rio de forma modal
  finally
    NMCadastroProduto.Free;
    // Libera a mem�ria do formul�rio ap�s seu fechamento
  end;
end;

procedure TEmissorPrincipal.NMCadastrodeEmpresasClick(Sender: TObject);
begin
  FCadastroDeEmpresa := TFCadastroDeEmpresa.Create(Self);
  // Cria o formul�rio secund�rio
  try
    FCadastroDeEmpresa.ShowModal; // Exibe o formul�rio de forma modal
  finally
    FCadastroDeEmpresa.Free;
    // Libera a mem�ria do formul�rio ap�s seu fechamento
  end;
end;

procedure TEmissorPrincipal.Informaes1Click(Sender: TObject);
var
  FInforma��es: TFInforma��es;
begin
  FInforma��es := TFInforma��es.Create(Self);
  try
    FInforma��es.ShowModal; // Abre de forma modal
  finally
    FInforma��es.Free; // Libera o formul�rio da mem�ria
  end;
end;

procedure TEmissorPrincipal.IniciarTransacao;
begin
  DataModulePrincipal.FDConnection.StartTransaction;
end;

procedure TEmissorPrincipal.FinalizarTransacao(Sucesso: Boolean);
begin
  if Sucesso then
    DataModulePrincipal.FDConnection.Commit
  else
    DataModulePrincipal.FDConnection.Rollback;
end;

procedure TEmissorPrincipal.BtEditarPedidoClick(Sender: TObject);
var
  FormPesquisaDePedido: TNMPesquisaDePedido; // Nome corrigido para refletir o tipo correto
  IDVenda: Integer;
begin
  // Cria o formul�rio de pesquisa de pedidos
  FormPesquisaDePedido := TNMPesquisaDePedido.Create(Self);
  try
    // Exibe o formul�rio e verifica se o usu�rio confirmou a sele��o (mrOk)
    if FormPesquisaDePedido.ShowModal = mrOk then
    begin
      // Recupera o IDVenda do pedido selecionado, armazenado na propriedade Tag
      IDVenda := FormPesquisaDePedido.Tag;
      // Chama o m�todo para carregar os dados do pedido no formul�rio principal
      CarregarPedidoEdicao(IDVenda);
      MNCadastroProduto.Enabled := false;
      MNCadastrodeCliente.Enabled := False;
      NMCadastrodeEmpresas.Enabled := False;
    end;
  finally
    // Libera a mem�ria alocada para o formul�rio
    FormPesquisaDePedido.Free;
  end;
end;

procedure TEmissorPrincipal.CarregarPedidoEdicao(IDVenda: Integer);
var
  i: Integer;
  TotalDesconto, TotalValor: Double;
begin
  // Inicializa as vari�veis de soma
  TotalDesconto := 0.00;
  TotalValor := 0.00;

  // Consulta o pedido selecionado
  with DataModulePrincipal.FDQueryPedido do
  begin
    Close;
    SQL.Text := 'SELECT * FROM Pedido WHERE IDVenda = :IDVenda';
    ParamByName('IDVenda').AsInteger := IDVenda;
    Open;

    if not IsEmpty then
    begin
      // Preenche os campos do formul�rio
      EdCodigoCliente.Text := FieldByName('IDCliente').AsString;
      EdNomeCliente.Text := FieldByName('NomeCliente').AsString;
      EdTelefoneCliente.Text := FieldByName('TelefoneCliente').AsString;
      EdEmail.Text := FieldByName('EmailCliente').AsString;
      EdCodigoVenda.Text := FieldByName('IDVenda').AsString;
      EdDataPedido.Date := FieldByName('Data').AsDateTime;
      MemoOBS.Text := FieldByName('Observacao').AsString;

      // Altera o status do pedido para "A"
      Edit;
      FieldByName('FlStatus').AsString := 'A';
      Post;
    end;

    Close;
  end;

  if DataModulePrincipal.VerificarExibirDataInsercao then
  begin
     AtualizarConfiguracoes;

    // Consulta os itens do pedido
    with DataModulePrincipal.FDQueryItemPedido do
    begin
      Close;
      SQL.Text := 'SELECT * FROM ItemPedido WHERE IDVenda = :IDVenda';
      ParamByName('IDVenda').AsInteger := IDVenda;
      Open;

      // Limpa a grid e reseta contadores
      StringGridList.RowCount := 1; // Mant�m apenas a linha de cabe�alho
      i := 1;

      while not Eof do
      begin
        StringGridList.RowCount := StringGridList.RowCount + 1;
        StringGridList.Cells[0, i] := FieldByName('IDItem').AsString;
        StringGridList.Cells[1, i] := FieldByName('NomeProduto').AsString;
        StringGridList.Cells[2, i] := FormatFloat('0.00', FieldByName('Valor').AsFloat);
        StringGridList.Cells[3, i] := FieldByName('Quantidade').AsString;
        StringGridList.Cells[4, i] := FormatFloat('0.00', FieldByName('Desc').AsFloat);
        StringGridList.Cells[5, i] := FormatFloat('0.00', FieldByName('Total').AsFloat);
        StringGridList.Cells[6, i] := FormatDateTime('dd/mm/yyyy', FieldByName('DataInsercao').AsDateTime);

        // Soma os valores de desconto e total
        TotalDesconto := TotalDesconto + FieldByName('Desc').AsFloat;
        TotalValor := TotalValor + FieldByName('Total').AsFloat;

        Inc(i);
        Next;
      end;

      Close;
    end;
  end
  else
  begin
      AtualizarConfiguracoes;


      // Consulta os itens do pedido
      with DataModulePrincipal.FDQueryItemPedido do
      begin
        Close;
        SQL.Text := 'SELECT * FROM ItemPedido WHERE IDVenda = :IDVenda';
        ParamByName('IDVenda').AsInteger := IDVenda;
        Open;

        // Limpa a grid e reseta contadores
        StringGridList.RowCount := 1; // Mant�m apenas a linha de cabe�alho
        i := 1;

        while not Eof do
        begin
          StringGridList.RowCount := StringGridList.RowCount + 1;
          StringGridList.Cells[0, i] := FieldByName('IDItem').AsString;
          StringGridList.Cells[1, i] := FieldByName('NomeProduto').AsString;
          StringGridList.Cells[2, i] := FormatFloat('0.00', FieldByName('Valor').AsFloat);
          StringGridList.Cells[3, i] := FieldByName('Quantidade').AsString;
          StringGridList.Cells[4, i] := FormatFloat('0.00', FieldByName('Desc').AsFloat);
          StringGridList.Cells[5, i] := FormatFloat('0.00', FieldByName('Total').AsFloat);

          // Soma os valores de desconto e total
          TotalDesconto := TotalDesconto + FieldByName('Desc').AsFloat;
          TotalValor := TotalValor + FieldByName('Total').AsFloat;

          Inc(i);
          Next;
        end;

        Close;
      end;
  end;


  // Atualiza os labels com os valores calculados
  LabDescItens.Caption := FormatFloat('0.00', TotalDesconto);
  LabValorTotal.Caption := FormatFloat('0.00', TotalValor);

  CarregarProdutos;

  // Ativar/desativar bot�es e campos
  BtEditarItem.Enabled := True;
  BtExcluirItem.Enabled := True;
  BtFecharPedido.Enabled := True;
  BtCancelarPedido.Enabled := True;
  CBEdNomeProduto.Enabled := True;
  MemoOBS.Enabled := true;

  BtEditarPedido.Enabled := False;
  BtNovoPedido.Enabled := False;
  BtSalvar.Enabled := False;
end;

procedure TEmissorPrincipal.AtualizarConfiguracoes;
begin
  if DataModulePrincipal.VerificarExibirDataInsercao then
  begin
    StringGridList.ColCount := 7;
    StringGridList.Cells[0, 0] := 'C�digo';
    StringGridList.Cells[1, 0] := 'Nome do Produto';
    StringGridList.Cells[2, 0] := 'Valor';
    StringGridList.Cells[3, 0] := 'Quantidade';
    StringGridList.Cells[4, 0] := 'Desconto';
    StringGridList.Cells[5, 0] := 'Total';
    StringGridList.Cells[6, 0] := 'Data';

    StringGridList.ColWidths[0] := 64;
    StringGridList.ColWidths[1] := 190;
    StringGridList.ColWidths[2] := 80;
    StringGridList.ColWidths[3] := 80;
    StringGridList.ColWidths[4] := 60;
    StringGridList.ColWidths[5] := 80;
    StringGridList.ColWidths[6] := 90;
  end
  else
  begin
    StringGridList.ColCount := 6;
    StringGridList.Cells[0, 0] := 'C�digo';
    StringGridList.Cells[1, 0] := 'Nome do Produto';
    StringGridList.Cells[2, 0] := 'Valor';
    StringGridList.Cells[3, 0] := 'Quantidade';
    StringGridList.Cells[4, 0] := 'Desconto';
    StringGridList.Cells[5, 0] := 'Total';

    StringGridList.ColWidths[0] := 70;
    StringGridList.ColWidths[1] := 250;
    StringGridList.ColWidths[2] := 100;
    StringGridList.ColWidths[3] := 100;
    StringGridList.ColWidths[4] := 90;
    StringGridList.ColWidths[5] := 100;
  end;
end;





end.

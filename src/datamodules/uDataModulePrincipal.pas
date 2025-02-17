unit uDataModulePrincipal;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client, FireDAC.Stan.Def,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.DApt, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Async,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Comp.UI, FireDAC.Stan.Error,
  FireDAC.Phys.Intf, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  Data.DB, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, System.IOUtils, Vcl.Forms, Vcl.Dialogs, Winapi.Windows, SHFolder;

type
  TDataModulePrincipal = class(TDataModule)
    FDConnection: TFDConnection;
    FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
    DataSourceCliente: TDataSource;
    FDQueryCliente: TFDQuery;
    DataSourceProduto: TDataSource;
    FDQueryProduto: TFDQuery;
    DataSourcePedido: TDataSource;
    FDQueryPedido: TFDQuery;
    FDQueryItemPedido: TFDQuery;
    DataSourceItemPedido: TDataSource;
    FDQuerySistema: TFDQuery;
    DataSourceSistema: TDataSource;
    DataSourceEmpresa: TDataSource;
    FDQueryEmpresa: TFDQuery;
    DataSourceRelatorioDePedidos: TDataSource;
    FDQueryRelatorioDePedidos: TFDQuery;
    DataSourceConfiguracao: TDataSource;
    FDQueryConfiguracao: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure CriarTabelas;

  private
    function TabelaExiste(const TabelaNome: string): Boolean;
    function RegistraConfiguracaoExistente(NomeConfiguracao: string): Boolean;
    procedure ConfigurarConexao(const DatabasePath: string);
    procedure CriarBancoDeDados(const DatabasePath: string; ComDadosTeste: Boolean);
    function VerificarOuCriarColuna(const Tabela, Coluna, Tipo: string): Boolean;
    function VerificarAtualizacaoSistema(VersaoAtual: string): Boolean;

  public
    function  VersaoAtual: string;
    function VerificarExibirDataInsercao: Boolean;
  end;

var
  DataModulePrincipal: TDataModulePrincipal;
const
  VERSAO_ATUAL = '1.2';

implementation

uses
  FrmSplashArt;  // Mover para c�!

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function  TDataModulePrincipal.VersaoAtual: string;
begin
  Result := VERSAO_ATUAL;
end;

procedure TDataModulePrincipal.DataModuleCreate(Sender: TObject);
var
  BasePath, DatabasePath: string;
  Resposta: Integer;
begin
  FrmSplashArt.FrmSplash.labEdit('Conectando ao banco de dados...');
  FrmSplashArt.FrmSplash.processCout(40);
  Sleep(500);
  BasePath := IncludeTrailingPathDelimiter(TPath.GetDocumentsPath) + 'MeuSistema\';

  if not TDirectory.Exists(BasePath) then
  begin
    try
      TDirectory.CreateDirectory(BasePath);
    except
      on E: Exception do
      begin
        ShowMessage('Erro ao criar o diret�rio de dados: ' + E.Message);
        Halt;
      end;
    end;
  end;

  DatabasePath := BasePath + 'Vendas.db';

  // Verifica se o banco existe
  if not FileExists(DatabasePath) then
  begin
    // Pergunta ao usu�rio como deseja iniciar o sistema
  Resposta := Application.MessageBox('Deseja iniciar com dados de teste?', 'Confirma��o', MB_YESNO + MB_ICONQUESTION);

  if Resposta = IDYES then
  begin
      FrmSplashArt.FrmSplash.labEdit('Inserindo dados de testes....');
      FrmSplashArt.FrmSplash.processCout(50);
      CriarBancoDeDados(DatabasePath, True)  // Banco com dados de teste
  end
  else
  begin
     CriarBancoDeDados(DatabasePath, False); // Banco zerado
  end;

  end;

  // Configurar conex�o e conectar
  ConfigurarConexao(DatabasePath);
  try
    FDConnection.Connected := True;

    CriarTabelas;

     // Verifica se a vers�o do banco de dados � a mesma que a do sistema

    if not VerificarAtualizacaoSistema(VERSAO_ATUAL) then
    begin
      // Adiciona novas colunas se necess�rio
      VerificarOuCriarColuna('Pedido', 'Observacao', 'TEXT');
      VerificarOuCriarColuna('Pedido', 'TotalPedido', 'REAL');
      VerificarOuCriarColuna('ItemPedido', 'Desc', 'REAL');
      VerificarOuCriarColuna('Cliente', 'Endereco', 'TEXT');
      VerificarOuCriarColuna('Configuracao', 'UsarMoeda', 'TEXT');
      VerificarOuCriarColuna('Configuracao', 'Idioma', 'TEXT');
      if TabelaExiste('Configuracao') then
      begin
        // Inserir os registros na tabela Configuracao, somente se a tabela existir
        if not RegistraConfiguracaoExistente('ExibirDataInsercaoNoOrcamento') then
          FDConnection.ExecSQL(
            'INSERT INTO Configuracao (NomeConfiguracao, FLATIVO) ' +
            'VALUES (''ExibirDataInsercaoNoOrcamento'', ''S'');'
          );
        if not RegistraConfiguracaoExistente('ExibirDataInsercaoNoRelatorio') then
          FDConnection.ExecSQL(
            'INSERT INTO Configuracao (NomeConfiguracao, FLATIVO) ' +
            'VALUES (''ExibirDataInsercaoNoRelatorio'', ''S'');'
          );
        if not RegistraConfiguracaoExistente('ExibirEmpresaNoRelatorio') then
          FDConnection.ExecSQL(
            'INSERT INTO Configuracao (NomeConfiguracao, FLATIVO) ' +
            'VALUES (''ExibirEmpresaNoRelatorio'', ''S'');'
          );
        if not RegistraConfiguracaoExistente('CaminhoDoBackupDoBanco') then
          FDConnection.ExecSQL(
            'INSERT INTO Configuracao (NomeConfiguracao, CaminhoBackup, FLATIVO) ' +
            'VALUES (''CaminhoDoBackupDoBanco'', ''C:\Users\Default\Downloads'', ''S'');'
          );
        if not RegistraConfiguracaoExistente('QtdDiasParaLimparBanco') then
          FDConnection.ExecSQL(
            'INSERT INTO Configuracao (NomeConfiguracao, FLATIVO) ' +
            'VALUES (''QtdDiasParaLimparBanco'', ''S'');'
          );
        if not RegistraConfiguracaoExistente('MoedaApresentadaNoRelatorio') then
          FDConnection.ExecSQL(
            'INSERT INTO Configuracao (NomeConfiguracao, UsarMoeda, FLATIVO) ' +
            'VALUES (''MoedaApresentadaNoRelatorio'', ''Real Brasileiro'', ''S'');'
          );
        if not RegistraConfiguracaoExistente('UsaIdiomaNoRelatorio') then
          FDConnection.ExecSQL(
            'INSERT INTO Configuracao (NomeConfiguracao, Idioma, FLATIVO) ' +
            'VALUES (''UsaIdiomaNoRelatorio'', ''Portugu�s'', ''S'');'
          );
      end;
    end;

    if FDConnection.Connected then
    begin
      FrmSplashArt.FrmSplash.labEdit('Conectando tabelas ao sistema....');
      FrmSplashArt.FrmSplash.processCout(65);
      Sleep(200);
      FDQueryItemPedido.Active := True;
      FDQueryPedido.Active := True;
      FDQueryCliente.Active := True;
      FDQueryProduto.Active := True;
      FDQuerySistema.Active := True;
      FDQueryEmpresa.Active := True;
      FDQueryRelatorioDePedidos.Active := True;
      FDQueryConfiguracao.Active := True;
    end
    else
      FrmSplashArt.FrmSplash.labEdit('A conex�o com o banco de dados n�o foi estabelecida....');
      FrmSplashArt.FrmSplash.processCout(65);
      Sleep(1000);
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao conectar ou criar o banco de dados: ' + E.Message +
        sLineBreak + 'Caminho do banco de dados: ' + DatabasePath);
      FDConnection.Connected := False;
      Halt;
    end;
  end;

  FrmSplashArt.FrmSplash.labEdit('Banco de dados conectado com sucesso...');
  FrmSplashArt.FrmSplash.processCout(90);
  Sleep(1000);
end;


procedure TDataModulePrincipal.ConfigurarConexao(const DatabasePath: string);
begin
  FDConnection.Params.Clear; // Limpa os par�metros para evitar conflitos
  FDConnection.Params.DriverID := 'SQLite';
  FDConnection.Params.Database := DatabasePath;
  FDConnection.Params.Values['LockingMode'] := 'Exclusive';
  FDConnection.Params.Values['LoginTimeout'] := '60';
  FDConnection.Params.Values['BusyTimeout'] := '30000';
  FDConnection.Params.Values['Timeout'] := '30';
  FDConnection.Params.Values['SharedCache'] := 'True';
  FDConnection.Params.Values['Charset'] := 'UTF-8';
  FDConnection.LoginPrompt := False; // Desabilita prompt de login
end;

procedure TDataModulePrincipal.CriarBancoDeDados(const DatabasePath: string; ComDadosTeste: Boolean);
var
  I: Integer;
begin
  ConfigurarConexao(DatabasePath);
  FDConnection.Connected := True;

  // Cria��o das tabelas
  CriarTabelas;

  // Se o usu�rio escolheu iniciar com dados de teste, insere os dados
  if ComDadosTeste then
  begin
    if FDConnection.ExecSQLScalar('SELECT COUNT(*) FROM Produto') = 0 then
    begin
      FDConnection.StartTransaction;
      try
        for I := 1 to 50 do
        begin
          FDConnection.ExecSQL(
            'INSERT INTO Produto (NomeProduto, Preco) VALUES (:NomeProduto, :Preco)',
            ['Produto de testes ' + IntToStr(I), 0.07]
          );

          FDConnection.ExecSQL(
            'INSERT INTO Cliente (Nome, Telefone, Email) VALUES (:Nome, :Telefone, :Email)',
            ['Cliente de testes ' + IntToStr(I), '(48) 9 9999-9999', 'testes' + IntToStr(I) + '@teste.com']
          );
        end;
        FDConnection.Commit;
      except
        FDConnection.Rollback;
        raise;
      end;
    end;
  end;
end;

function TDataModulePrincipal.VerificarExibirDataInsercao: Boolean;
begin
  Result := False; // Valor padr�o caso n�o encontre o registro
  with FDQueryConfiguracao do
  begin
    Close;
    SQL.Text := 'SELECT FLAtivo FROM Configuracao WHERE NomeConfiguracao = :Nome';
    ParamByName('Nome').AsString := 'ExibirDataInsercaoNoOrcamento';
    Open;
    if not IsEmpty then
      Result := FieldByName('FLAtivo').AsString = 'S'; // Retorna True se for 'S'
  end;
end;

procedure TDataModulePrincipal.CriarTabelas;
begin
  FrmSplashArt.FrmSplash.labEdit('Analisando tabelas....');
  FrmSplashArt.FrmSplash.processCout(55);
  Sleep(500);
  // Cria��o da tabela Pedido
 if not TabelaExiste('Pedido') then
  FDConnection.ExecSQL(
    'CREATE TABLE IF NOT EXISTS Pedido (' +
    'IDVenda INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'IDCliente INTEGER, ' +
    'NomeCliente TEXT, ' +
    'TelefoneCliente TEXT, ' +
    'EmailCliente TEXT, ' +
    'FlStatus char(1)DEFAULT ''A'', '+
    'Observacao TEXT,'+
    'TotalPedido REAL,'+
    'Data DATE DEFAULT (CURRENT_DATE));'
  );

  // Cria��o da tabela ItemPedido
if not TabelaExiste('ItemPedido') then
    FDConnection.ExecSQL(
      'CREATE TABLE IF NOT EXISTS ItemPedido (' +
      'IDItem INTEGER PRIMARY KEY, ' +
      'IDVenda INTEGER, ' +
      'IDProduto INTEGER, ' +
      'NomeProduto TEXT, ' +
      'Valor REAL, ' +
      'Desc REAL, ' +
      'Quantidade INTEGER, ' +
      'Total REAL, ' +
      'DataInsercao DATE DEFAULT (CURRENT_DATE), ' +  // Data de inser��o do item no pedido especifico para um fluxo de um cliente
      'FOREIGN KEY(IDVenda) REFERENCES Pedido(IDVenda));'
    );

  // Cria��o da tabela Cliente
 if not TabelaExiste('Cliente') then
    FDConnection.ExecSQL(
      'CREATE TABLE IF NOT EXISTS Cliente (' +
      'IDCliente INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'Nome TEXT, ' +
      'Telefone TEXT, ' +
      'Email TEXT, ' +
      'Endereco TEXT);'
    );

  // Verifica e cria a tabela Produto
  if not TabelaExiste('Produto') then
    FDConnection.ExecSQL(
      'CREATE TABLE IF NOT EXISTS Produto (' +
      'IDProduto INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'NomeProduto TEXT, ' +
      'Preco REAL);'
    );

  if not TabelaExiste('Empresa') then
    FDConnection.ExecSQL(
      'CREATE TABLE IF NOT EXISTS Empresa (' +
      'IDEmpresa INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'NomeEmpresa TEXT, ' +
      'Telefone TEXT, ' +
      'NomeFantasia TEXT, ' +
      'CNPJ TEXT, ' +
      'Endereco TEXT, ' +
      'Bairro TEXT, ' +
      'Cidade TEXT, ' +
      'Estado TEXT, ' +
      'ImgLogo BLOB, ' +
      'FlDefault char(1)DEFAULT ''S'');'
    );

  if not TabelaExiste('Configuracao') then
  begin
     FDConnection.ExecSQL(
    'CREATE TABLE IF NOT EXISTS Configuracao (' +
    'IDConfiguracao INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'NomeConfiguracao TEXT NOT NULL, ' +
    'CaminhoBackup TEXT,' +
    'QtdDias INTEGER DEFAULT 0,' +
    'UsarMoeda TEXT,' +
    'Idioma TEXT,' +
    'FLATIVO CHAR(1) NOT NULL CHECK(FLATIVO IN (''S'', ''N''))' +
    ');'
    );
  end;

  if not TabelaExiste('Sistema') then
  begin
    FDConnection.ExecSQL(
      'CREATE TABLE IF NOT EXISTS Sistema (' +
      'IDSistema INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'VersaoSistema TEXT, ' +
      'FlPrimeiroAcesso char(1)DEFAULT ''P'');'
    );

    FDConnection.ExecSQL('INSERT INTO Sistema (VersaoSistema) VALUES (''0.0'');');
  end;
end;

function TDataModulePrincipal.RegistraConfiguracaoExistente(NomeConfiguracao: string): Boolean;
begin
  Result := False;
  FDQueryConfiguracao.SQL.Text := 'SELECT COUNT(*) FROM Configuracao WHERE NomeConfiguracao = :NomeConfiguracao';
  FDQueryConfiguracao.ParamByName('NomeConfiguracao').AsString := NomeConfiguracao;
  FDQueryConfiguracao.Open;
  Result := FDQueryConfiguracao.Fields[0].AsInteger > 0;
end;

function TDataModulePrincipal.VerificarAtualizacaoSistema(VersaoAtual: string): Boolean;
var
  VersaoBanco: string;
begin
  FrmSplashArt.FrmSplash.labEdit('Verificando vers�es....');
  FrmSplashArt.FrmSplash.processCout(55);
  Sleep(500);
  Result := False;
  // Obt�m a vers�o do banco de dados
  FDQuerySistema.SQL.Text := 'SELECT VersaoSistema FROM Sistema LIMIT 1';
  FDQuerySistema.Open;

  if not FDQuerySistema.IsEmpty then
  begin
    VersaoBanco := FDQuerySistema.FieldByName('VersaoSistema').AsString;

    // Se a vers�o do banco for igual � vers�o do sistema, retorna verdadeiro
    if VersaoBanco = VersaoAtual then
    begin
      Result := True;
    end
    else if (VersaoBanco < VersaoAtual) then
    begin
      if Assigned(FrmSplash) then
      FrmSplashArt.FrmSplash.labEdit('Atualizados banco de dados...');
      FrmSplashArt.FrmSplash.processCout(70);
      Sleep(600);
      FDQuerySistema.Close;  // Certifique-se de fechar o query ap�s o uso
      // Atualiza a vers�o no banco de dados
      FDConnection.ExecSQL('UPDATE Sistema SET VersaoSistema = '''+VersaoAtual+''';');
      Sleep(300);

      try
        Result := False;  // Retorna verdadeiro ap�s a atualiza��o bem-sucedida
      except
        on E: Exception do
        begin
          ShowMessage('Erro ao atualizar a vers�o do sistema: ' + E.Message);
          Result := True;
        end;
      end;
    end;
  end
  else
  begin
    ShowMessage('Tabela "Sistema" est� vazia ou n�o foi encontrada.');
  end;


end;


function TDataModulePrincipal.VerificarOuCriarColuna(const Tabela, Coluna, Tipo: string): Boolean;
var
  Query: TFDQuery;
  ColunaExiste: Boolean;
begin
  ColunaExiste := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FDConnection;
    Query.SQL.Text := 'PRAGMA table_info(' + Tabela + ');';
    Query.Open;

    // Percorre as colunas da tabela para verificar se j� existe
    while not Query.Eof do
    begin
      if Query.FieldByName('name').AsString = Coluna then
      begin
        ColunaExiste := True;
        Break;
      end;
      Query.Next;
    end;

    // Se a coluna n�o existir, adiciona
    if not ColunaExiste then
    begin
      FDConnection.ExecSQL('ALTER TABLE ' + Tabela + ' ADD COLUMN ' + Coluna + ' ' + Tipo + ';');
    end;

    Result := not ColunaExiste; // Retorna True se criou a coluna, False se j� existia
  finally
    Query.Free;
  end;
end;


function TDataModulePrincipal.TabelaExiste(const TabelaNome: string): Boolean;
var
  QueryTemp: TFDQuery;
begin
  Result := False;
  QueryTemp := TFDQuery.Create(nil);
  try
    QueryTemp.Connection := FDConnection;
    QueryTemp.SQL.Text := 'SELECT name FROM sqlite_master WHERE type="table" AND name="' + TabelaNome + '"';
    QueryTemp.Open;
    Result := not QueryTemp.IsEmpty;
  finally
    QueryTemp.Free;
  end;
end;


end.


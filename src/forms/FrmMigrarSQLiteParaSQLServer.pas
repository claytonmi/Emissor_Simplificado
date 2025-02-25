unit FrmMigrarSQLiteParaSQLServer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDataModulePrincipal, Vcl.ComCtrls, IniFiles, System.IOUtils,
  Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB, Data.Win.ADODB, FireDAC.Comp.Client, System.TypInfo, System.Generics.Collections,
  Vcl.Buttons;

type
  TNMMigrarSQLiteParaSQLServer = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    BtnMigrarSQLiteParaSQLServer: TButton;
    ProgressBarMigracao: TProgressBar;
    Panel4: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EditServidor: TEdit;
    EditBanco: TEdit;
    EditUser: TEdit;
    EditSenha: TEdit;
    MemoLog: TMemo;
    Titulo: TLabel;
    BtnVerSenha: TBitBtn;
    procedure EditServidorChange(Sender: TObject);
    procedure EditBancoChange(Sender: TObject);
    procedure EditUserChange(Sender: TObject);
    procedure EditSenhaChange(Sender: TObject);
    procedure BtnMigrarSQLiteParaSQLServerClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnVerSenhaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnVerSenhaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  private
    function ObterCaminhoSQLite: string;
    procedure ValidarCampos;
    procedure MigrarDados;
    procedure AtualizarArquivoINI;
    procedure AdicionarLog(Mensagem: string);
    function BinToHexString(const AData: TBytes): string;
    procedure ImportaTabelasSimples;
    procedure ImportaPedido;
    procedure ImportaItemPedido;

    { Private declarations }
  public

    { Public declarations }
  end;

var
  NMMigrarSQLiteParaSQLServer: TNMMigrarSQLiteParaSQLServer;
  MigracaoBemSucedida: Boolean;
  QrySQLite: TFDQuery;
  QrySQLiteIDVenda: TFDQuery;
  QrySQLServer: TADOQuery;
  ColunasSQLite: TStringList;
  ColunasValidas: TStringList;
  MapeamentoIDs: TDictionary<Integer, Integer>;
  Tabela: string;
  ValoresSQL: string;
  MapeamentoColunas: TDictionary<string, string>;


implementation

{$R *.dfm}

procedure TNMMigrarSQLiteParaSQLServer.BtnMigrarSQLiteParaSQLServerClick(
  Sender: TObject);
begin
  MemoLog.Lines.Add('Iniciando migração...');
  // Configura a conexão ADO (SQL Server)
  BtnMigrarSQLiteParaSQLServer.Enabled:=false;
  EditServidor.ReadOnly:=True;
  EditBanco.ReadOnly:=True;
  EditUser.ReadOnly:=True;
  EditSenha.ReadOnly:=True;
  BtnVerSenha.Enabled:=false;

  DataModulePrincipal.ADOConnection.Close;
  DataModulePrincipal.ADOConnection.LoginPrompt := False;

 if (EditUser.Text <> '') and (EditSenha.Text <> '') then
    begin
        // Autenticação com usuário e senha (SQL Server Authentication)
        DataModulePrincipal.ADOConnection.ConnectionString :=
          'Provider=SQLOLEDB;' +
          'Data Source=' + EditServidor.Text + ';' +
          'Initial Catalog=' + EditBanco.Text + ';' +
          'User ID=' + EditUser.Text + ';' +
          'Password=' + EditSenha.Text + ';';
    end
    else
    begin
        // Autenticação do Windows (Windows Authentication)
        DataModulePrincipal.ADOConnection.ConnectionString :=
          'Provider=SQLOLEDB.1;' +
          'Integrated Security=SSPI;' +  // Usa o usuário do Windows
          'Initial Catalog=' + EditBanco.Text + ';' +
          'Data Source=' + EditServidor.Text + ';';
    end;

  try
    DataModulePrincipal.ADOConnection.Connected := True;
    if DataModulePrincipal.ADOConnection.Connected then
    begin
      AdicionarLog('Conexão com SQL Server estabelecida com sucesso.');
      try
        MigrarDados;  // Agora, apenas erros dentro de MigrarDados serão capturados separadamente
      except
        on E: Exception do
        begin
          AdicionarLog('Erro ao migrar os dados: ' + E.Message);
          Exit;
        end;
      end;
    end
    else
    begin
      AdicionarLog('Falha na conexão com SQL Server.');
    end;
  except
    on E: Exception do
    begin
      AdicionarLog('Erro ao conectar ao SQL Server: ' + E.Message);
    end;
  end;
end;

procedure TNMMigrarSQLiteParaSQLServer.BtnVerSenhaMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  BtnVerSenha.Glyph.LoadFromFile('Img\Visivel.bmp');
  EditSenha.PasswordChar := #0;
end;

procedure TNMMigrarSQLiteParaSQLServer.BtnVerSenhaMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  BtnVerSenha.Glyph.LoadFromFile('Img\Oculto.bmp');
  EditSenha.PasswordChar := '*';
end;

function TNMMigrarSQLiteParaSQLServer.ObterCaminhoSQLite: string;
var
  ConfigPath: string;
  IniFile: TIniFile;
begin
  ConfigPath := TPath.Combine(TPath.GetHomePath, 'config.ini');
  IniFile := TIniFile.Create(ConfigPath);
  try
    Result := IniFile.ReadString('Database', 'CaminhoSQLite', '');
    AdicionarLog('Banco SQLite encontrado em: ' + Result);
  finally
    IniFile.Free;
  end;
end;


procedure TNMMigrarSQLiteParaSQLServer.MigrarDados;
begin

  // Verificar se a conexão com SQLite está ativa
  if not DataModulePrincipal.FDConnection.Connected then
  begin
    AdicionarLog('Erro: Conexão com SQLite não está ativa.');
    Exit;
  end;

   AdicionarLog('Conexão com SQLite verificada.');
   DataModulePrincipal.dbTypeMigracao := 'SQL Server';
  // Verificar se o banco de dados é SQL Server e criar as tabelas se necessário
  if not DataModulePrincipal.TabelaExiste('Cliente') then
  begin
    AdicionarLog('Banco de dados SQL Server identificado. Criando tabelas...');
    try
      DataModulePrincipal.CriarTabelas; // Chama a criação de tabelas no SQL Server
      AdicionarLog('Tabelas criadas com sucesso no SQL Server.');
    except
      on E: Exception do
      begin
        AdicionarLog('Erro ao criar tabelas no SQL Server: ' + E.Message);
        Exit;
      end;
    end;
  end;

  // Mapeamento de colunas específicas (Exemplo: Desc -> Desconto)
  MapeamentoColunas := TDictionary<string, string>.Create;
  try
    MapeamentoColunas.Add('Desc', 'Desconto'); // Mapeamento de coluna
    ImportaTabelasSimples;
    ImportaPedido;
    AdicionarLog('Migração finalizada.');
    MigracaoBemSucedida := True;
    Application.MessageBox('Migração concluída com sucesso! O sistema será reiniciado ao fechar esta janela.', 'Aviso', MB_OK or MB_ICONINFORMATION);
finally
  MapeamentoColunas.Free;
end;
end;

procedure TNMMigrarSQLiteParaSQLServer.ImportaTabelasSimples;
begin
    for Tabela in ['Cliente', 'Produto', 'Empresa', 'Configuracao', 'Sistema'] do
    begin
      AdicionarLog('Migrando tabela: ' + Tabela);
      QrySQLite := TFDQuery.Create(nil);
      QrySQLServer := TADOQuery.Create(nil);
      ColunasSQLite := TStringList.Create;  // Criando antes do try
      ColunasValidas := TStringList.Create; // Criando antes do try
      try
        QrySQLite.Connection := DataModulePrincipal.FDConnection;
        QrySQLServer.Connection := DataModulePrincipal.ADOConnection;
        // Obter as colunas do SQLite
        QrySQLite.SQL.Text := 'PRAGMA table_info(' + Tabela + ')';
        QrySQLite.Open;
        while not QrySQLite.Eof do
        begin
          ColunasSQLite.Add(QrySQLite.FieldByName('name').AsString);
          QrySQLite.Next;
        end;
        QrySQLite.Close;
        // Obter as colunas do SQL Server, ignorando as colunas IDENTITY
        QrySQLServer.SQL.Text := 'SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS ' +
          'WHERE TABLE_NAME = ' + QuotedStr(Tabela) +
          ' AND COLUMNPROPERTY(OBJECT_ID(' + QuotedStr(Tabela) + '), COLUMN_NAME, ''IsIdentity'') = 0';
        QrySQLServer.Open;
        while not QrySQLServer.Eof do
        begin
          if ColunasSQLite.IndexOf(QrySQLServer.Fields[0].AsString) <> -1 then
            ColunasValidas.Add(QrySQLServer.Fields[0].AsString);
          QrySQLServer.Next;
        end;
        QrySQLServer.Close;
        // Se não há colunas válidas, pular a migração
        if ColunasValidas.Count = 0 then
        begin
          AdicionarLog('Nenhuma coluna correspondente na tabela ' + Tabela);
          Continue;
        end;
        // Migrar os dados
        QrySQLite.SQL.Text := 'SELECT ' + ColunasValidas.CommaText + ' FROM ' + Tabela;
        QrySQLite.Open;
        ProgressBarMigracao.Max := QrySQLite.RecordCount;
        ProgressBarMigracao.Position := 0;
        while not QrySQLite.Eof do
        begin
          ValoresSQL := ''; // Inicializa a variável
          var InsertSQL := 'INSERT INTO ' + Tabela + ' (' + ColunasValidas.CommaText + ') VALUES (';
          for var I := 0 to ColunasValidas.Count - 1 do
          begin
            var Campo := ColunasValidas[I];
            if I > 0 then
              ValoresSQL := ValoresSQL + ', ';
            var Field := QrySQLite.FieldByName(Campo);
            if Field.IsNull then
              ValoresSQL := ValoresSQL + 'NULL'
            else if Field.DataType in [ftString, ftWideString, ftMemo, ftWideMemo] then
              ValoresSQL := ValoresSQL + QuotedStr(StringReplace(Trim(Field.AsString), '''', '''''', [rfReplaceAll])) // Corrige aspas
            else if Field.DataType in [ftFloat, ftCurrency] then
            begin
              var ValorFloat := StringReplace(Trim(Field.AsString), ',', '.', [rfReplaceAll]);
              if ValorFloat.Contains('.') then
                ValoresSQL := ValoresSQL + ValorFloat
              else
                ValoresSQL := ValoresSQL + ValorFloat + '.00';
            end
            else if Field.DataType = ftDate then
            begin
              var DataFormatada := FormatDateTime('yyyy-mm-dd', Field.AsDateTime);
              ValoresSQL := ValoresSQL + QuotedStr(DataFormatada);
            end
            else if Field.DataType = ftBlob then
            begin
              var BlobField := Field as TBlobField;
              var BlobData: TMemoryStream := TMemoryStream.Create;
              try
                BlobField.SaveToStream(BlobData);
                BlobData.Position := 0;
                var BinaryData: TBytes;
                SetLength(BinaryData, BlobData.Size);
                BlobData.Read(BinaryData, BlobData.Size);
                ValoresSQL := ValoresSQL + '0x' + BinToHexString(BinaryData);
              finally
                BlobData.Free;
              end;
            end
            else
              ValoresSQL := ValoresSQL + Field.AsString;
          end;
          InsertSQL := InsertSQL + ValoresSQL + ')';
          AdicionarLog('Executando: ' + InsertSQL);
          try
            QrySQLServer.SQL.Text := InsertSQL;
            QrySQLServer.ExecSQL;
          except
            on E: Exception do
            begin
              AdicionarLog('Erro ao inserir na tabela ' + Tabela + ': ' + E.Message);
              Exit;
            end;
          end;
          ProgressBarMigracao.Position := ProgressBarMigracao.Position + 1;
          QrySQLite.Next;
        end;
        AdicionarLog('Tabela ' + Tabela + ' migrada com sucesso.');
      finally
        QrySQLite.Free;
        QrySQLServer.Free;
        ColunasSQLite.Free;
        ColunasValidas.Free;
      end;
    end;
end;

procedure TNMMigrarSQLiteParaSQLServer.ImportaPedido;
begin
  AdicionarLog('Migrando tabela: Pedido');
  QrySQLite := TFDQuery.Create(nil);
  QrySQLServer := TADOQuery.Create(nil);
  ColunasSQLite := TStringList.Create;
  ColunasValidas := TStringList.Create;
  MapeamentoIDs := TDictionary<Integer, Integer>.Create;
  try
    QrySQLite.Connection := DataModulePrincipal.FDConnection;
    QrySQLServer.Connection := DataModulePrincipal.ADOConnection;

    // Obter as colunas do SQLite
    QrySQLite.SQL.Text := 'PRAGMA table_info(Pedido)';
    QrySQLite.Open;
    while not QrySQLite.Eof do
    begin
      ColunasSQLite.Add(QrySQLite.FieldByName('name').AsString);
      QrySQLite.Next;
    end;
    QrySQLite.Close;

    // Obter as colunas do SQL Server, ignorando as colunas IDENTITY
    QrySQLServer.SQL.Text := 'SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS ' +
                             'WHERE TABLE_NAME = ''Pedido'' ' +
                             'AND COLUMNPROPERTY(OBJECT_ID(''Pedido''), COLUMN_NAME, ''IsIdentity'') = 0';
    QrySQLServer.Open;
    while not QrySQLServer.Eof do
    begin
      if ColunasSQLite.IndexOf(QrySQLServer.Fields[0].AsString) <> -1 then
        ColunasValidas.Add(QrySQLServer.Fields[0].AsString);
      QrySQLServer.Next;
    end;
    QrySQLServer.Close;

    // Remover a coluna IDVenda (auto incremento no SQL Server)
    var Index := ColunasValidas.IndexOf('IDVenda');
    if Index >= 0 then
      ColunasValidas.Delete(Index);

    // Iniciar a migração dos pedidos
    QrySQLite.SQL.Text := 'SELECT IDVenda, ' + ColunasValidas.CommaText + ' FROM Pedido';
    QrySQLite.Open;
    ProgressBarMigracao.Max := QrySQLite.RecordCount;
    ProgressBarMigracao.Position := 0;

    while not QrySQLite.Eof do
    begin
      var IDVendaAntigo := QrySQLite.FieldByName('IDVenda').AsInteger;
      var IDVendaNovo: Integer;
      var ValoresSQL := '';
      var InsertSQL := 'INSERT INTO Pedido (' + ColunasValidas.CommaText + ') OUTPUT INSERTED.IDVenda VALUES (';

      // Construir os valores para o INSERT
      for var I := 0 to ColunasValidas.Count - 1 do
      begin
        var Campo := ColunasValidas[I];
        if I > 0 then
          ValoresSQL := ValoresSQL + ', ';
        var Field := QrySQLite.FieldByName(Campo);

        if Field.IsNull then
          ValoresSQL := ValoresSQL + 'NULL'
        else if Field.DataType in [ftString, ftWideString, ftMemo, ftWideMemo] then
          ValoresSQL := ValoresSQL + QuotedStr(StringReplace(Trim(Field.AsString), '''', '''''', [rfReplaceAll]))
        else if Field.DataType in [ftFloat, ftCurrency] then
        begin
          var ValorFloat := StringReplace(Trim(Field.AsString), ',', '.', [rfReplaceAll]);
          if ValorFloat.Contains('.') then
            ValoresSQL := ValoresSQL + ValorFloat
          else
            ValoresSQL := ValoresSQL + ValorFloat + '.00';
        end
        else if Field.DataType = ftDate then
        begin
          var DataFormatada := FormatDateTime('yyyy-mm-dd', Field.AsDateTime);
          ValoresSQL := ValoresSQL + QuotedStr(DataFormatada);
        end
        else
          ValoresSQL := ValoresSQL + Field.AsString;
      end;

      InsertSQL := InsertSQL + ValoresSQL + ')';

      AdicionarLog('Executando: ' + InsertSQL);
      try
        // Executar a inserção e capturar o IDVenda gerado
        QrySQLServer.SQL.Text := InsertSQL;
        QrySQLServer.Open;
        IDVendaNovo := QrySQLServer.FieldByName('IDVenda').AsInteger;

        // Mapear o ID antigo para o novo
        MapeamentoIDs.Add(IDVendaAntigo, IDVendaNovo);
      except
        on E: Exception do
        begin
          AdicionarLog('Erro ao inserir na tabela Pedido: ' + E.Message);
          Exit;
        end;
      end;

      ProgressBarMigracao.Position := ProgressBarMigracao.Position + 1;
      QrySQLite.Next;
    end;

    AdicionarLog('Tabela Pedido migrada com sucesso.');
  finally
    QrySQLite.Free;
    QrySQLServer.Free;
    ColunasSQLite.Free;
    ColunasValidas.Free;
    ImportaItemPedido;
    MapeamentoIDs.Free;
  end;
end;

procedure TNMMigrarSQLiteParaSQLServer.ImportaItemPedido;
begin
  AdicionarLog('Migrando tabela: ItemPedido');
  QrySQLite := TFDQuery.Create(nil);
  QrySQLServer := TADOQuery.Create(nil);
  ColunasSQLite := TStringList.Create;
  ColunasValidas := TStringList.Create;
  try
    QrySQLite.Connection := DataModulePrincipal.FDConnection;
    QrySQLServer.Connection := DataModulePrincipal.ADOConnection;

    // Obter as colunas do SQLite
    QrySQLite.SQL.Text := 'PRAGMA table_info(ItemPedido)';
    QrySQLite.Open;
    while not QrySQLite.Eof do
    begin
      ColunasSQLite.Add(QrySQLite.FieldByName('name').AsString);
      QrySQLite.Next;
    end;
    QrySQLite.Close;

    // Obter as colunas do SQL Server, ignorando colunas IDENTITY
    QrySQLServer.SQL.Text := 'SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS ' +
                             'WHERE TABLE_NAME = ''ItemPedido'' ' +
                             'AND COLUMNPROPERTY(OBJECT_ID(''ItemPedido''), COLUMN_NAME, ''IsIdentity'') = 0';
    QrySQLServer.Open;
    while not QrySQLServer.Eof do
    begin
      var NomeColunaSQL := QrySQLServer.Fields[0].AsString;
      var NomeColunaSQLite := NomeColunaSQL;
      // Percorre o dicionário para encontrar o nome correspondente no SQLite
      for var Chave in MapeamentoColunas.Keys do
        if MapeamentoColunas[Chave] = NomeColunaSQL then
          NomeColunaSQLite := Chave; // Nome original no SQLite
      // Adiciona a coluna mapeada se existir no SQLite
      if ColunasSQLite.IndexOf(NomeColunaSQLite) <> -1 then
        ColunasValidas.Add(NomeColunaSQL);
      QrySQLServer.Next;
    end;
    QrySQLServer.Close;

    // Iniciar a migração dos itens de pedido
    QrySQLite.SQL.Text := 'SELECT * FROM ItemPedido';
    QrySQLite.Open;
    ProgressBarMigracao.Max := QrySQLite.RecordCount;
    ProgressBarMigracao.Position := 0;

    while not QrySQLite.Eof do
    begin
      var IDVendaAntigo := QrySQLite.FieldByName('IDVenda').AsInteger;

      // Verifica se o IDVenda antigo foi migrado corretamente
      if MapeamentoIDs.ContainsKey(IDVendaAntigo) then
      begin
        var IDVendaNovo := MapeamentoIDs[IDVendaAntigo];
        var ValoresSQL := '';
        var InsertSQL := 'INSERT INTO ItemPedido (' + ColunasValidas.CommaText + ') VALUES (';

          for var I := 0 to ColunasValidas.Count - 1 do
          begin
            var NomeColunaSQL := ColunasValidas[I]; // Nome da coluna no SQL Server
            // Verifica se há um mapeamento de NomeColunaSQL -> NomeColunaSQLite
            var NomeColunaSQLite := NomeColunaSQL;
            for var Chave in MapeamentoColunas.Keys do
              if MapeamentoColunas[Chave] = NomeColunaSQL then
                NomeColunaSQLite := Chave; // Nome original no SQLite
            if I > 0 then
              ValoresSQL := ValoresSQL + ', ';
            var Field := QrySQLite.FieldByName(NomeColunaSQLite); // Usa o nome correto no SQLite
            // Substituir IDVendaAntigo pelo IDVendaNovo
            if NomeColunaSQL = 'IDVenda' then
              ValoresSQL := ValoresSQL + IntToStr(IDVendaNovo)
            else if Field.IsNull then
              ValoresSQL := ValoresSQL + 'NULL'
            else if Field.DataType in [ftString, ftWideString, ftMemo, ftWideMemo] then
              ValoresSQL := ValoresSQL + QuotedStr(StringReplace(Trim(Field.AsString), '''', '''''', [rfReplaceAll]))
            else if Field.DataType in [ftFloat, ftCurrency] then
            begin
              var ValorFloat := StringReplace(Trim(Field.AsString), ',', '.', [rfReplaceAll]);
              if ValorFloat.Contains('.') then
                ValoresSQL := ValoresSQL + ValorFloat
              else
                ValoresSQL := ValoresSQL + ValorFloat + '.00';
            end
            else if Field.DataType = ftDate then
            begin
              var DataFormatada := FormatDateTime('yyyy-mm-dd', Field.AsDateTime);
              ValoresSQL := ValoresSQL + QuotedStr(DataFormatada);
            end
            else
              ValoresSQL := ValoresSQL + Field.AsString;
          end;

        InsertSQL := InsertSQL + ValoresSQL + ')';

        AdicionarLog('Executando: ' + InsertSQL);
        try
          QrySQLServer.SQL.Text := InsertSQL;
          QrySQLServer.ExecSQL;
          AdicionarLog('ItemPedido migrado com sucesso. IDVenda: ' + IntToStr(IDVendaNovo));
        except
          on E: Exception do
          begin
            AdicionarLog('Erro ao inserir na tabela ItemPedido: ' + E.Message);
            Exit;
          end;
        end;
      end
      else
      begin
        AdicionarLog('Aviso: Pedido ID ' + IntToStr(IDVendaAntigo) + ' não encontrado na migração.');
      end;

      ProgressBarMigracao.Position := ProgressBarMigracao.Position + 1;
      QrySQLite.Next;
    end;

    AdicionarLog('Tabela ItemPedido migrada com sucesso.');
  finally
    QrySQLite.Free;
    QrySQLServer.Free;
    ColunasSQLite.Free;
    ColunasValidas.Free;
  end;
end;


function TNMMigrarSQLiteParaSQLServer.BinToHexString(const AData: TBytes): string;
const
  HexDigits: array[0..15] of Char = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
var
  I: Integer;
begin
  SetLength(Result, Length(AData) * 2);
  for I := 0 to High(AData) do
  begin
    Result[2 * I + 1] := HexDigits[AData[I] shr 4];
    Result[2 * I + 2] := HexDigits[AData[I] and $0F];
  end;
end;

procedure TNMMigrarSQLiteParaSQLServer.AtualizarArquivoINI;
var
  ConfigPath: string;
  IniFile: TIniFile;
begin
  ConfigPath := TPath.Combine(TPath.GetHomePath, 'config.ini');
  IniFile := TIniFile.Create(ConfigPath);
  try
    IniFile.WriteString('Database', 'Tipo', 'SQL Server');
    IniFile.WriteString('Database', 'NomeBanco', EditBanco.Text);
    IniFile.WriteString('Database', 'ServidorSQLServer', EditServidor.Text);
    IniFile.WriteString('Database', 'UsuarioSQLServer', EditUser.Text);
    IniFile.WriteString('Database', 'SenhaSQLServer', EditSenha.Text);
    AdicionarLog('Arquivo INI atualizado para usar SQL Server.');
  finally
    IniFile.Free;
  end;
end;



procedure TNMMigrarSQLiteParaSQLServer.EditBancoChange(Sender: TObject);
begin
ValidarCampos;
end;

procedure TNMMigrarSQLiteParaSQLServer.EditSenhaChange(Sender: TObject);
begin
ValidarCampos;
end;

procedure TNMMigrarSQLiteParaSQLServer.EditServidorChange(Sender: TObject);
begin
ValidarCampos;
end;

procedure TNMMigrarSQLiteParaSQLServer.EditUserChange(Sender: TObject);
begin
ValidarCampos;
end;

procedure TNMMigrarSQLiteParaSQLServer.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if MigracaoBemSucedida then
  begin
    AtualizarArquivoINI;
    Application.Terminate; // Fecha completamente o sistema
  end;
end;

procedure TNMMigrarSQLiteParaSQLServer.ValidarCampos;
begin
  BtnMigrarSQLiteParaSQLServer.Enabled :=
    (Trim(EditServidor.Text) <> '') and
    (Trim(EditBanco.Text) <> '') and
    (Trim(EditUser.Text) <> '') and
    (Trim(EditSenha.Text) <> '');
end;

procedure TNMMigrarSQLiteParaSQLServer.AdicionarLog(Mensagem: string);
begin
  MemoLog.Lines.Add(Mensagem); // Adiciona a mensagem ao Memo
  MemoLog.SelStart := Length(MemoLog.Text); // Move o cursor para o final do texto
  SendMessage(MemoLog.Handle, WM_VSCROLL, SB_BOTTOM, 0); // Move o scroll para o final
end;

end.

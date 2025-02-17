object DataModulePrincipal: TDataModulePrincipal
  OnCreate = DataModuleCreate
  Height = 668
  Width = 330
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=C:\Users\clayt\OneDrive\Documentos\MeuSistema\Vendas.db'
      'DriverID=SQLite')
    FetchOptions.AssignedValues = [evAutoClose]
    ResourceOptions.AssignedValues = [rvCmdExecTimeout]
    ResourceOptions.CmdExecTimeout = 30
    LoginPrompt = False
    Left = 56
    Top = 24
  end
  object FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink
    Left = 176
    Top = 24
  end
  object DataSourceCliente: TDataSource
    DataSet = FDQueryCliente
    Left = 56
    Top = 128
  end
  object FDQueryCliente: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'select * from cliente;')
    Left = 160
    Top = 128
  end
  object DataSourceProduto: TDataSource
    DataSet = FDQueryProduto
    Left = 56
    Top = 192
  end
  object FDQueryProduto: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'select * from Produto;')
    Left = 160
    Top = 192
  end
  object DataSourcePedido: TDataSource
    DataSet = FDQueryPedido
    Left = 56
    Top = 256
  end
  object FDQueryPedido: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'select * from Pedido;')
    Left = 160
    Top = 256
  end
  object FDQueryItemPedido: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT IDProduto FROM ItemPedido  where IDItem = 7')
    Left = 160
    Top = 328
  end
  object DataSourceItemPedido: TDataSource
    DataSet = FDQueryItemPedido
    Left = 56
    Top = 328
  end
  object FDQuerySistema: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'select * from sistema')
    Left = 160
    Top = 384
  end
  object DataSourceSistema: TDataSource
    DataSet = FDQuerySistema
    Left = 56
    Top = 384
  end
  object DataSourceEmpresa: TDataSource
    DataSet = FDQueryEmpresa
    Left = 56
    Top = 448
  end
  object FDQueryEmpresa: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'select * from Empresa'
      '')
    Left = 160
    Top = 448
  end
  object DataSourceRelatorioDePedidos: TDataSource
    DataSet = FDQueryRelatorioDePedidos
    Left = 56
    Top = 512
  end
  object FDQueryRelatorioDePedidos: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT '
      '    p.IDVenda, '
      '    p.NomeCliente, '
      '    c.Endereco, '
      '    p.TelefoneCliente, '
      '    p.Data AS DataPedido, '
      '    p.Observacao,'
      '    p.TotalPedido, '
      '    i.NomeProduto, '
      '    i.Quantidade, '
      '    i.Valor, '
      '    i.DataInsercao, '
      '    i.Total'
      'FROM '
      '    Pedido p'
      'INNER JOIN '
      '    ItemPedido i ON p.IDVenda = i.IDVenda'
      'LEFT JOIN '
      '    Cliente c ON p.IDCliente = c.IDCliente'
      'ORDER BY '
      '    p.IDVenda, i.DataInsercao;'
      '')
    Left = 160
    Top = 512
  end
  object DataSourceConfiguracao: TDataSource
    DataSet = FDQueryConfiguracao
    Left = 56
    Top = 576
  end
  object FDQueryConfiguracao: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'select * from configuracao')
    Left = 160
    Top = 576
  end
end

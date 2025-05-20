object DataModulePrincipal: TDataModulePrincipal
  OnCreate = DataModuleCreate
  Height = 739
  Width = 707
  object FDConnection: TFDConnection
    Params.Strings = (
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
      'SELECT * FROM ItemPedido;')
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
  object ADOConnection: TADOConnection
    Provider = 'SQLOLEDB.1'
    Left = 424
    Top = 24
  end
  object ADOQueryCliente: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    SQL.Strings = (
      'select * from cliente;')
    Left = 488
    Top = 120
  end
  object ADOQueryProduto: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    SQL.Strings = (
      'select * from Produto;')
    Left = 488
    Top = 184
  end
  object ADOQueryPedido: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    SQL.Strings = (
      'select * from Pedido;')
    Left = 488
    Top = 248
  end
  object ADOQueryItemPedido: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    SQL.Strings = (
      'select * from ItemPedido;')
    Left = 488
    Top = 312
  end
  object ADOQuerySistema: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    SQL.Strings = (
      'select * from sistema')
    Left = 488
    Top = 376
  end
  object ADOQueryEmpresa: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    SQL.Strings = (
      'select * from Empresa;')
    Left = 488
    Top = 440
  end
  object ADOQueryRelatorioDePedidos: TADOQuery
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM '
      '    Pedido ')
    Left = 488
    Top = 496
  end
  object ADOQueryConfiguracao: TADOQuery
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from configuracao')
    Left = 488
    Top = 560
  end
  object DataSourceRelatorioFinancas: TDataSource
    DataSet = ADOQueryRelatorioFinancas
    Left = 56
    Top = 640
  end
  object FDQueryRelatorioFinancas: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT '
      '    ip.NomeProduto,'
      '    SUM(ip.Quantidade) AS QuantidadeVendida,'
      '    AVG(ip.Valor) AS PrecoVenda,'
      '    pr.PrecoCusto,'
      '    SUM('
      '        CASE '
      '            WHEN pr.PrecoCusto IS NULL OR pr.PrecoCusto = 0 '
      '                THEN ip.Quantidade * ip.Valor'
      '            ELSE ip.Quantidade * (ip.Valor - pr.PrecoCusto)'
      '        END'
      '    ) AS LucroTotal,'
      '    ('
      '        SELECT '
      '            SUM('
      '                CASE '
      
        '                    WHEN pr2.PrecoCusto IS NULL OR pr2.PrecoCust' +
        'o = 0 '
      '                        THEN ip2.Quantidade * ip2.Valor'
      
        '                    ELSE ip2.Quantidade * (ip2.Valor - pr2.Preco' +
        'Custo)'
      '                END'
      '            )'
      '        FROM ItemPedido ip2'
      '        JOIN Produto pr2 ON ip2.IDProduto = pr2.IDProduto'
      '    ) AS TotalGeral'
      'FROM ItemPedido ip'
      'JOIN Pedido pd ON ip.IDVenda = pd.IDVenda'
      'JOIN Produto pr ON ip.IDProduto = pr.IDProduto'
      'GROUP BY ip.NomeProduto, pr.PrecoCusto'
      'ORDER BY ip.NomeProduto;')
    Left = 160
    Top = 640
  end
  object ADOQueryRelatorioFinancas: TADOQuery
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT'
      '    p.NomeProduto,'
      '    SUM(ip.Quantidade) AS QuantidadeVendida,'
      '    pr.Preco AS PrecoVenda,'
      '    pr.PrecoCusto,'
      '    SUM('
      '        CASE'
      '            WHEN pr.PrecoCusto IS NULL OR pr.PrecoCusto = 0'
      '                THEN ip.Quantidade * pr.Preco'
      '            ELSE ip.Quantidade * (pr.Preco - pr.PrecoCusto)'
      '        END'
      '    ) AS LucroTotal,'
      '    ('
      '        SELECT'
      '            SUM('
      '                CASE'
      
        '                    WHEN pr2.PrecoCusto IS NULL OR pr2.PrecoCust' +
        'o = 0'
      '                        THEN ip2.Quantidade * pr2.Preco'
      
        '                    ELSE ip2.Quantidade * (pr2.Preco - pr2.Preco' +
        'Custo)'
      '                END'
      '            )'
      '        FROM ItemPedido ip2'
      '        JOIN Produto pr2 ON ip2.IDProduto = pr2.IDProduto'
      '    ) AS TotalGeral'
      'FROM ItemPedido ip'
      'JOIN Pedido pd ON ip.IDVenda = pd.IDVenda'
      'JOIN Produto pr ON ip.IDProduto = pr.IDProduto'
      'JOIN Produto p ON p.IDProduto = ip.IDProduto'
      'GROUP BY p.NomeProduto, pr.Preco, pr.PrecoCusto'
      'ORDER BY p.NomeProduto;'
      '')
    Left = 488
    Top = 640
  end
end

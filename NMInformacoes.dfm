object FInformações: TFInformações
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Informa'#231#245'es'
  ClientHeight = 143
  ClientWidth = 415
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object MemoInformações: TMemo
    Left = 0
    Top = 0
    Width = 415
    Height = 143
    Align = alClient
    Alignment = taCenter
    CharCase = ecUpperCase
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    Lines.Strings = (
      'FLUXO DE UTILIZA'#199#195'O DO CADASTRO DE CLIENTE'
      ''
      'PRIMEIRO FLUXO'
      '- INFORME OS DADOS DO CLIENTE E CLIQUE NO BOT'#195'O '#39'SALVAR'#39
      ''
      'SEGUNDO FLUXO'
      '- CLIQUE NO BOT'#195'O '#39'EDITAR'#39' E SELECIONE UM CLIENTE NO COMBO'
      '- FECHE O FORMUL'#193'RIO'
      '- EDITE O CLIENTE E CLIQUE NO BOT'#195'O '#39'SALVAR'#39)
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    ExplicitHeight = 206
  end
end

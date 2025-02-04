program EmissorSimplificado;

uses
  Vcl.Forms,
  MNPrincipal in '..\forms\MNPrincipal.pas' {EmissorPrincipal},
  MNRelatorioSemanal in '..\reports\MNRelatorioSemanal.pas' {RelatorioSemanal},
  MNCadastroCliente in '..\forms\MNCadastroCliente.pas' {FCadastroCliente},
  uDataModulePrincipal in '..\datamodules\uDataModulePrincipal.pas' {DataModulePrincipal: TDataModule},
  NMPesquisaCliente in '..\forms\NMPesquisaCliente.pas' {NMDePesquisaCliente},
  NMInformacoes in '..\forms\NMInformacoes.pas' {FInformações},
  NMCadastroDeProduto in '..\forms\NMCadastroDeProduto.pas' {NMCadastroProduto},
  NMPesquisaDeProduto in '..\forms\NMPesquisaDeProduto.pas' {NMPesquisaProduto},
  NMPesquisaPedido in '..\forms\NMPesquisaPedido.pas' {NMPesquisaDePedido},
  FRelatorioReportSemanal in '..\reports\FRelatorioReportSemanal.pas' {NMRelatorioReport},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModulePrincipal, DataModulePrincipal);
  Application.CreateForm(TEmissorPrincipal, EmissorPrincipal);
  Application.Run;
end.

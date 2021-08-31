program TesteMaurilioToshiro;

uses
  Vcl.Forms,
  UPedidoVenda in 'UPedidoVenda.pas' {FrmPedidoVenda},
  ClassConexao in 'Classes\ClassConexao.pas',
  ClassProduto in 'Classes\ClassProduto.pas',
  ClassCliente in 'Classes\ClassCliente.pas',
  ClassPedido in 'Classes\ClassPedido.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPedidoVenda, FrmPedidoVenda);
  Application.Run;
end.

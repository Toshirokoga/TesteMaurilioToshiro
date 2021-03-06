unit UPedidoVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Datasnap.DBClient, Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Phys.MySQLDef,
  FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.MySQL, Vcl.Buttons, Vcl.ComCtrls;

type
  TFrmPedidoVenda = class(TForm)
    pnlInferior: TPanel;
    btnFechar: TButton;
    btnGravarPedido: TButton;
    pnlCabecalho: TPanel;
    pnlItens: TPanel;
    CDSItens: TClientDataSet;
    DItens: TDataSource;
    DBGridItens: TDBGrid;
    pnlCadastroItem: TPanel;
    EditCliente: TLabeledEdit;
    btnPesqPedidos: TSpeedButton;
    EditDtEmissao: TDateTimePicker;
    Label1: TLabel;
    EditNomeCliente: TEdit;
    EditVlrTotal: TLabeledEdit;
    Panel1: TPanel;
    btnInserirItem: TButton;
    btnAlterarItem: TButton;
    btnExcluirItem: TButton;
    CDSItensProduto: TIntegerField;
    CDSItensDescricao: TStringField;
    CDSItensQuantidade: TFloatField;
    CDSItensVlr_Unit: TFloatField;
    CDSItensVlr_Total: TFloatField;
    Panel2: TPanel;
    BtnCancelarItem: TButton;
    btnConfirmarItem: TButton;
    EditProduto: TLabeledEdit;
    EditDescricaoProduto: TEdit;
    EditVlrUnit: TLabeledEdit;
    EditQtde: TLabeledEdit;
    lblTotalPedido: TLabel;
    EditPedido: TLabeledEdit;
    EditCidade: TEdit;
    EditUF: TEdit;
    pnlPedido: TPanel;
    EditPedidoPesquisa: TLabeledEdit;
    btnConfirmaPedidoPesquisa: TButton;
    CDSItensItem: TIntegerField;
    procedure btnFecharClick(Sender: TObject);
    procedure EditClienteExit(Sender: TObject);
    procedure EditClienteEnter(Sender: TObject);
    procedure btnExcluirItemClick(Sender: TObject);
    procedure DBGridItensKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGridItensKeyPress(Sender: TObject; var Key: Char);
    procedure DBGridItensDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridItensDblClick(Sender: TObject);
    procedure btnAlterarItemClick(Sender: TObject);
    procedure BtnCancelarItemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditProdutoExit(Sender: TObject);
    procedure btnConfirmarItemClick(Sender: TObject);
    procedure btnInserirItemClick(Sender: TObject);
    procedure EditVlrUnitExit(Sender: TObject);
    procedure EditQtdeExit(Sender: TObject);
    procedure btnPesqPedidosClick(Sender: TObject);
    procedure btnConfirmaPedidoPesquisaClick(Sender: TObject);
    procedure btnGravarPedidoClick(Sender: TObject);
  private
    function StringToValor(pValor: String): Double;
    function ValorToString(pValor: Double; const pMoeda: Boolean = True): String;
    function FormataVlrString(pValor: String): String;
    function ItemValido: Boolean;
    procedure LimparTelaItens;
    procedure CarregaItem;
    procedure CalculaTotal;
    procedure ChamaTelaItem;
    procedure FechaTelaItem;
    procedure CarregaPedido(pPedido: Integer);
    procedure GravarPedido;
    function PedidoValido: Boolean;
    procedure LimparTela;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPedidoVenda: TFrmPedidoVenda;

implementation

{$R *.dfm}

uses ClassCliente, ClassConexao, ClassProduto, ClassPedido;

procedure TFrmPedidoVenda.btnAlterarItemClick(Sender: TObject);
begin
  CDSItens.Edit;
  CarregaItem;
  ChamaTelaItem;
end;

procedure TFrmPedidoVenda.CarregaItem;
begin
  EditProduto.Text := CDSItensProduto.AsString;
  EditDescricaoProduto.Text := CDSItensDescricao.AsString;
  EditQtde.Text             := ValorToString(CDSItensQuantidade.AsFloat, False);
  EditVlrUnit.Text          := ValorToString(CDSItensVlr_Unit.AsFloat);
end;

procedure TFrmPedidoVenda.BtnCancelarItemClick(Sender: TObject);
begin
  LimparTelaItens;
  FechaTelaItem;
end;

procedure TFrmPedidoVenda.ChamaTelaItem;
begin
  if EditCliente.Text <> '' then begin
    pnlInferior.Enabled     := False;
    pnlCadastroItem.Visible := True;
    EditProduto.SetFocus;
  end else begin
    Application.MessageBox('Informe o cliente ou selecione um pedido para continuar.', 'Aten??o', MB_ICONINFORMATION + MB_OK);
  end;
end;

procedure TFrmPedidoVenda.FechaTelaItem;
begin
  pnlInferior.Enabled     := True;
  pnlCadastroItem.Visible := False;
end;

procedure TFrmPedidoVenda.btnExcluirItemClick(Sender: TObject);
begin
  if not CDSItens.IsEmpty then begin
    if Application.MessageBox(PChar('Deseja realmente excluir o produto: ' + CDSItensProduto.AsString + '?'),
                              'Aten??o', MB_ICONINFORMATION + MB_YESNO) = mrYes then begin
      CDSItens.Delete;
      CalculaTotal;
    end;
  end;
end;

procedure TFrmPedidoVenda.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmPedidoVenda.btnGravarPedidoClick(Sender: TObject);
begin
  if PedidoValido then begin
    GravarPedido;
    LimparTela;
  end;
end;

procedure TFrmPedidoVenda.LimparTela;
begin
  CDSItens.EmptyDataSet;
  CDSItens.Close;
  CDSItens.Open;
  EditDtEmissao.Date := Date;
  EditCliente.Clear;
  EditNomeCliente.Clear;
  EditCidade.Clear;
  EditUF.Clear;
  EditVlrTotal.Text := ValorToString(0);
  EditPedido.Clear;
  CalculaTotal;
  EditCliente.SetFocus;
end;

procedure TFrmPedidoVenda.GravarPedido;
var
  Pedido: TPedido;
  nI: Integer;
begin
  Pedido := TPedido.Create;
  try
    if EditPedido.Text <> '' then begin
      Pedido.NumPedido := StrToInt(EditPedido.Text);
    end;
    Pedido.DtEmissao := EditDtEmissao.DateTime;
    Pedido.VlrTotal  := StringToValor(EditVlrTotal.Text);
    Pedido.CodCliente:= StrToInt(EditCliente.Text);

    CDSItens.First;
    while not CDSItens.Eof do begin
      Pedido.ListaItens.Add(TPedido.TItensPedido.Create);
      nI := Pedido.ListaItens.Count - 1;

      Pedido.ListaItens[nI].Item        := CDSItensItem.AsInteger;
      Pedido.ListaItens[nI].NumPedido   := Pedido.NumPedido;
      Pedido.ListaItens[nI].CodProduto  := CDSItensProduto.AsInteger;
      Pedido.ListaItens[nI].Quantidade  := CDSItensQuantidade.AsFloat;
      Pedido.ListaItens[nI].VlrUnit     := CDSItensVlr_Unit.AsFloat;
      Pedido.ListaItens[nI].VlrTotal    := CDSItensVlr_Total.AsFloat;
      CDSItens.Next;
    end;
    if Pedido.GravarPedido then begin
      Application.MessageBox(PChar('Pedido: ' + IntToStr(Pedido.NumPedido) + ' realizado com sucesso.'), 'Aten??o', MB_ICONINFORMATION + MB_OK);
    end else begin
      Application.MessageBox(PChar('Erro ao gravar pedido. Erro :' + Pedido.MsgErro), 'Erro', MB_ICONERROR + MB_OK);
    end;
  finally
    FreeAndNil(Pedido);
  end;
end;

function TFrmPedidoVenda.PedidoValido: Boolean;
begin
  Result := True;

  if (EditCliente.Text = '') or (EditCliente.Color = clRed) then begin
    Application.MessageBox('Cliente inv?lido. Favor verificar!', 'Aten??o', MB_ICONINFORMATION + MB_OK);
    EditCliente.SetFocus;
    Result := False;
  end;

  if (EditDtEmissao.Date < Date) and (Result) then begin
    Application.MessageBox('Data deve ser maior ou igual a data atual. Favor verificar!', 'Aten??o', MB_ICONINFORMATION + MB_OK);
    EditDtEmissao.SetFocus;
    Result := False;
  end;

//  if (EditPedido.Text = '') and (Result) then begin
//    Application.MessageBox('N?mero do pedido deve ser informado. Favor verificar!', 'Aten??o', MB_ICONINFORMATION + MB_OK);
//    EditPedido.SetFocus;
//    Result := False;
//  end;

  if CDSItens.IsEmpty then begin
    Application.MessageBox('Pedido sem itens. Favor verificar!', 'Aten??o', MB_ICONINFORMATION + MB_OK);
    Result := False;
  end;
end;

procedure TFrmPedidoVenda.btnConfirmaPedidoPesquisaClick(Sender: TObject);
begin
  if EditPedidoPesquisa.Text <> '' then begin
    CarregaPedido(StrToInt(EditPedidoPesquisa.Text));
  end else begin
    pnlPedido.Visible := False;
//    Application.MessageBox('Informe o c?digo do pedido para pesquisar.', 'Aten??o', MB_ICONINFORMATION + MB_OK);
  end;
end;

procedure TFrmPedidoVenda.btnConfirmarItemClick(Sender: TObject);
var
  bFechaTela: Boolean;
begin
  if ItemValido then begin
    bFechaTela                := CDSItens.State in [dsEdit];
    CDSItensItem.AsInteger    := CDSItens.RecordCount + 1;
    CDSItensProduto.AsInteger := StrToInt(EditProduto.Text);
    CDSItensDescricao.AsString:= EditDescricaoProduto.Text;
    CDSItensQuantidade.AsFloat:= StringToValor(EditQtde.Text);
    CDSItensVlr_Unit.AsFloat  := StringToValor(EditVlrUnit.Text);
    CDSItensVlr_Total.AsFloat := CDSItensQuantidade.AsFloat * CDSItensVlr_Unit.AsFloat;
    CDSItens.Post;

    LimparTelaItens;
    CalculaTotal;
    if bFechaTela then begin
      FechaTelaItem;
    end else begin
      CDSItens.Insert;
      EditProduto.SetFocus;
    end;
  end;
end;

procedure TFrmPedidoVenda.CalculaTotal;
var
  nTotal: Double;
begin
  CDSItens.First;
  nTotal := 0;
  while not CDSItens.Eof do begin
    nTotal := nTotal + CDSItensVlr_Total.AsFloat;
    CDSItens.Next;
  end;

  EditVlrTotal.Text := ValorToString(nTotal);
  lblTotalPedido.Caption := 'Valor Total: ' + ValorToString(nTotal);
end;

procedure TFrmPedidoVenda.btnInserirItemClick(Sender: TObject);
begin
  CDSItens.Insert;
  ChamaTelaItem;
end;

procedure TFrmPedidoVenda.btnPesqPedidosClick(Sender: TObject);
begin
  pnlPedido.Visible := True;
  EditPedidoPesquisa.SetFocus;
end;

procedure TFrmPedidoVenda.CarregaPedido(pPedido: Integer);
var
  Pedido: TPedido;
  Produto: TProduto;
  nI: Integer;
begin
  Pedido  := TPedido.Create;
  Produto := TProduto.Create;
  try
    if Pedido.CarregaPedido(StrToInt(EditPedidoPesquisa.Text)) then begin
      EditPedido.Text        := IntToStr(Pedido.NumPedido);
      EditDtEmissao.DateTime := Pedido.DtEmissao;
      EditVlrTotal.Text      := ValorToString(Pedido.VlrTotal);
      EditCliente.Text       := IntToStr(Pedido.CodCliente);

      for nI := 0 to Pedido.ListaItens.Count - 1 do begin
        CDSItens.Insert;

        CDSItensItem.AsInteger      := Pedido.ListaItens[nI].Item;
        CDSItensProduto.AsInteger   := Pedido.ListaItens[nI].CodProduto;
        Produto.ValidaExiste(CDSItensProduto.AsInteger);
        CDSItensDescricao.AsString  := Produto.Descricao;
        CDSItensQuantidade.AsFloat  := Pedido.ListaItens[nI].Quantidade;
        CDSItensVlr_Unit.AsFloat    := Pedido.ListaItens[nI].VlrUnit;
        CDSItensVlr_Total.AsFloat   := Pedido.ListaItens[nI].VlrTotal;
        CDSItens.Post;
      end;

      CalculaTotal;

      EditClienteExit(EditCliente);
      pnlPedido.Visible := False;
    end else begin
      Application.MessageBox('Pedido n?o encontrado.', 'Aten??o', MB_ICONINFORMATION + MB_OK);
      LimparTela;
      EditPedidoPesquisa.SetFocus;
    end;
  finally
    FreeAndNil(Produto);
    FreeAndNil(Pedido);
  end;
end;

procedure TFrmPedidoVenda.LimparTelaItens;
begin
  CDSItens.Cancel;
  EditProduto.Text          := '';
  EditDescricaoProduto.Text := '';
  EditQtde.Text             := ValorToString(0, False);
  EditVlrUnit.Text          := ValorToString(0);
end;

function TFrmPedidoVenda.ItemValido: Boolean;
begin
  Result := True;

  if (EditProduto.Text = '') or (EditProduto.Color = clRed) then begin
    Application.MessageBox('Produto inv?lido. Favor verificar!', 'Aten??o', MB_ICONINFORMATION + MB_OK);
    EditProduto.SetFocus;
    Result := False;
  end;

  if (StringToValor(EditQtde.Text) = 0) and (Result) then begin
    Application.MessageBox('Quantidade deve ser informada. Favor verificar!', 'Aten??o', MB_ICONINFORMATION + MB_OK);
    EditQtde.SetFocus;
    Result := False;
  end;

  if (StringToValor(EditVlrUnit.Text) = 0) and (Result) then begin
    Application.MessageBox('Valor unit?rio deve ser informado. Favor verificar!', 'Aten??o', MB_ICONINFORMATION + MB_OK);
    EditVlrUnit.SetFocus;
    Result := False;
  end;
end;

procedure TFrmPedidoVenda.DBGridItensDblClick(Sender: TObject);
begin
  btnAlterarItem.Click;
end;

procedure TFrmPedidoVenda.DBGridItensDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if not CDSItens.IsEmpty then begin
    if not odd(DItens.DataSet.RecNo) then begin
      if not (gdSelected in State) then begin
        DBGridItens.Canvas.Brush.Color := clGradientActiveCaption;
        DBGridItens.Canvas.FillRect(Rect);
        DBGridItens.DefaultDrawDataCell(rect,Column.Field,State);
        DBGridItens.DefaultDrawColumnCell(rect,DataCol,Column,state);
      end;
    end;
  end;
end;

procedure TFrmPedidoVenda.DBGridItensKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then begin
    btnExcluirItem.Click;
  end;
end;

procedure TFrmPedidoVenda.DBGridItensKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    btnAlterarItem.Click;
  end;
end;

procedure TFrmPedidoVenda.EditClienteEnter(Sender: TObject);
begin
  TLabeledEdit(Sender).Color := clWindow;
end;

procedure TFrmPedidoVenda.EditClienteExit(Sender: TObject);
var
  Cliente: TCliente;
begin
  if EditCliente.Text <> '' then begin
    Cliente := TCliente.Create;
    try
      if Cliente.ValidaExiste(StrToInt(EditCliente.Text)) then begin
        EditNomeCliente.Text := Cliente.Nome;
        EditCidade.Text      := Cliente.Cidade;
        EditUF.Text          := Cliente.UF;
        EditCliente.Color    := clGreen;
      end else begin
        Application.MessageBox('Cliente n?o cadastrado. Favor verificar!', 'Aten??o', MB_ICONEXCLAMATION+MB_OK);
        EditCliente.Color := clRed;
      end;
    finally
      Cliente.Free;
    end;
  end else begin
    EditCliente.Color := clRed;
//    LimparTela;
  end;
  btnPesqPedidos.Visible := EditCliente.Text = '';
end;

procedure TFrmPedidoVenda.EditProdutoExit(Sender: TObject);
var
  Produto: TProduto;
begin
  if EditProduto.Text <> '' then begin
    Produto := TProduto.Create;
    try
      if Produto.ValidaExiste(StrToInt(EditProduto.Text)) then begin
        EditDescricaoProduto.Text := Produto.Descricao;
        EditVlrUnit.Text          := ValorToString(Produto.PrecoVenda);
        EditProduto.Color         := clGreen;
      end else begin
        Application.MessageBox('Produto n?o cadastrado. Favor verificar!', 'Aten??o', MB_ICONEXCLAMATION+MB_OK);
        EditProduto.Color         := clRed;
      end;
    finally
      Produto.Free;
    end;
  end else begin
    EditProduto.Color := clRed;
  end;

end;

procedure TFrmPedidoVenda.EditQtdeExit(Sender: TObject);
begin
  EditQtde.Text := ValorToString(StringToValor(EditQtde.Text), False);
end;

procedure TFrmPedidoVenda.EditVlrUnitExit(Sender: TObject);
begin
  EditVlrUnit.Text := ValorToString(StringToValor(EditVlrUnit.Text));
end;

procedure TFrmPedidoVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CDSItens.Close;
end;

procedure TFrmPedidoVenda.FormShow(Sender: TObject);
begin
  CDSItens.CreateDataSet;
  LimparTela;
end;

function TFrmPedidoVenda.ValorToString(pValor: Double; const pMoeda: Boolean = True): String;
begin
  if pMoeda then begin
    Result := FormatCurr('R$ ###,##0.00', pValor);
  end else begin
    Result := FormatFloat('#,##0.00', pValor);
  end;
end;

function TFrmPedidoVenda.StringToValor(pValor: String): Double;
begin
  Result := StrToFloat(FormataVlrString(pValor));
end;

function TFrmPedidoVenda.FormataVlrString(pValor: String): String;
begin
  Result := StringReplace(pValor, '.', '', [rfReplaceAll]);
  Result := StringReplace(Result, 'R', '', [rfReplaceAll]);
  Result := StringReplace(Result, '$', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' ', '', [rfReplaceAll]);
end;

end.

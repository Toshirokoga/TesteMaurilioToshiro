unit ClassPedido;

interface

uses System.Generics.Collections, ClassConexao, Data.DB;

type

  TPedido = Class

    public type

      TItensPedido = Class
        private
          FVlrTotal   : Double;
          FNumPedido  : Integer;
          FItem       : Integer;
          FQuantidade : Double;
          FVlrUnit    : Double;
          FCodProduto : Integer;

          procedure SetCodProduto(const Value: Integer);
          procedure SetItem(const Value: Integer);
          procedure SetNumPedido(const Value: Integer);
          procedure SetQuantidade(const Value: Double);
          procedure SetVlrTotal(const Value: Double);
          procedure SetVlrUnit(const Value: Double);

        public
          property Item       : Integer   read FItem        write SetItem;
          property NumPedido  : Integer   read FNumPedido   write SetNumPedido;
          property CodProduto : Integer   read FCodProduto  write SetCodProduto;
          property Quantidade : Double    read FQuantidade  write SetQuantidade;
          property VlrUnit    : Double    read FVlrUnit     write SetVlrUnit;
          property VlrTotal   : Double    read FVlrTotal    write SetVlrTotal;

      End;

    private
      FVlrTotal   : Double;
      FCodCliente : Integer;
      FListaItens : TObjectList<TItensPedido>;
      FNumPedido  : Integer;
      FDtEmissao  : TDateTime;
      Conexao     : TConexao;
      FMsgErro    : String;

      procedure SetCodCliente(const Value: Integer);
      procedure SetDtEmissao(const Value: TDateTime);
      procedure SetVlrTotal(const Value: Double);
      procedure SetMsgErro(const Value: String);
      function RetNumPedido: Integer;
    function ValidaExiste(pPedido: Integer): Boolean;

    public
      constructor Create;
      destructor Destroy; override;
      function GravarPedido: Boolean;
      function CarregaPedido(pPedido: Integer): Boolean;

      property NumPedido  : Integer                   read FNumPedido   write FNumPedido;
      property DtEmissao  : TDateTime                 read FDtEmissao   write SetDtEmissao;
      property CodCliente : Integer                   read FCodCliente  write SetCodCliente;
      property VlrTotal   : Double                    read FVlrTotal    write SetVlrTotal;
      property ListaItens : TObjectList<TItensPedido> read FListaItens  write FListaItens;
      property MsgErro    : String                    read FMsgErro     write SetMsgErro;
  End;

implementation

uses
  System.SysUtils;

{ TPedido.TItensPedido }

procedure TPedido.TItensPedido.SetCodProduto(const Value: Integer);
begin
  FCodProduto := Value;
end;

procedure TPedido.TItensPedido.SetItem(const Value: Integer);
begin
  FItem := Value;
end;

procedure TPedido.TItensPedido.SetNumPedido(const Value: Integer);
begin
  FNumPedido := Value;
end;

procedure TPedido.TItensPedido.SetQuantidade(const Value: Double);
begin
  FQuantidade := Value;
end;

procedure TPedido.TItensPedido.SetVlrTotal(const Value: Double);
begin
  FVlrTotal := Value;
end;

procedure TPedido.TItensPedido.SetVlrUnit(const Value: Double);
begin
  FVlrUnit := Value;
end;

{ TPedido }

constructor TPedido.Create;
begin
  FListaItens := TObjectList<TItensPedido>.Create;
  Conexao     := TConexao.Create;
  FNumPedido  := RetNumPedido;
end;

destructor TPedido.Destroy;
begin
  Conexao.Free;
  FreeAndNil(FListaItens);
  inherited;
end;

function TPedido.ValidaExiste(pPedido: Integer): Boolean;
var
  cSQL: String;
  bConectado: Boolean;
begin
  Result      := False;
  bConectado  := Conexao.Conectado;

  if not bConectado then begin
    bConectado := Conexao.Conectar(FMsgErro);

    if FMsgErro <> '' then begin
      Result := False;
      Exit;
    end;
  end;

  if bConectado then begin
    cSQL := 'SELECT *                        ' +
            'FROM PEDIDO                     ' +
            'WHERE NUM_PEDIDO = :PNUM_PEDIDO ';
    Conexao.PreparaQuery(cSQL);
    Conexao.PassaParametro('PNUM_PEDIDO', pPedido, ftInteger);
    Conexao.AbreQuery(FMsgErro);

    if FMsgErro <> '' then begin
      Result := False;
      Exit;
    end;

    Result := not Conexao.Query.IsEmpty;
  end;
end;

function TPedido.GravarPedido: Boolean;
var
  cSQL,
  cSQLItem: String;
  bConectado,
  bExistePedido: Boolean;
  nI: Integer;
begin
  Result      := True;
  bConectado  := Conexao.Conectado;

  if not bConectado then begin
    bConectado := Conexao.Conectar(FMsgErro);
    if FMsgErro <> '' then begin
      Result := False;
      Exit;
    end;
  end;

  if bConectado then begin
    bExistePedido := ValidaExiste(FNumPedido);
    if bExistePedido then begin
      cSQL := 'UPDATE PEDIDO SET DT_EMISSAO = :PDT_EMISSAO, ' +
              '                  COD_CLI    = :PCOD_CLI,    ' +
              '                  VLR_TOTAL  = :PVLR_TOTAL   ' +
              'WHERE NUM_PEDIDO = :PNUM_PEDIDO              ';
    end else begin
      cSQL := 'INSERT INTO PEDIDO(  DT_EMISSAO,   COD_CLI,   VLR_TOTAL) '+
              '            VALUES(:PDT_EMISSAO, :PCOD_CLI, :PVLR_TOTAL) ';
    end;
    Conexao.PreparaQuery(cSQL);
    Conexao.PassaParametro('PDT_EMISSAO', FDtEmissao  , ftDate);
    Conexao.PassaParametro('PCOD_CLI'   , FCodCliente , ftInteger);
    Conexao.PassaParametro('PVLR_TOTAL' , FVlrTotal   , ftFloat);
    if bExistePedido then begin
      Conexao.PassaParametro('PNUM_PEDIDO', FNumPedido , ftInteger);
    end;

    Conexao.ExecutaQuery(FMsgErro);

    if FMsgErro <> '' then begin
      Result := False;
      Exit;
    end;

    if bExistePedido then begin
      cSQLItem := 'DELETE FROM ITENS_PEDIDO WHERE NUM_PEDIDO = :PNUM_PEDIDO';
      Conexao.PreparaQuery(cSQLItem);
      Conexao.PassaParametro('PNUM_PEDIDO', FNumPedido , ftInteger);
      Conexao.ExecutaQuery(FMsgErro);

      if FMsgErro <> '' then begin
        Result := False;
        Exit;
      end;
    end;

    cSQLItem := 'INSERT INTO ITENS_PEDIDO(  NUM_PEDIDO,   ITEM,   COD_PROD,   QUANTIDADE,   VLR_UNIT,   VLR_TOTAL) '+
                '                  VALUES(:PNUM_PEDIDO, :PITEM, :PCOD_PROD, :PQUANTIDADE, :PVLR_UNIT, :PVLR_TOTAL) ';

    for nI := 0 to ListaItens.Count - 1 do begin
      Conexao.PreparaQuery(cSQLItem);
      Conexao.PassaParametro('PNUM_PEDIDO', ListaItens[nI].NumPedido);
      Conexao.PassaParametro('PITEM'      , ListaItens[nI].Item);
      Conexao.PassaParametro('PCOD_PROD'  , ListaItens[nI].CodProduto);
      Conexao.PassaParametro('PQUANTIDADE', ListaItens[nI].Quantidade);
      Conexao.PassaParametro('PVLR_UNIT'  , ListaItens[nI].VlrUnit);
      Conexao.PassaParametro('PVLR_TOTAL' , ListaItens[nI].VlrTotal);
      Conexao.ExecutaQuery(FMsgErro);

      if FMsgErro <> '' then begin
        Result := False;
        Exit;
      end;
    End;
  end;
end;

function TPedido.CarregaPedido(pPedido: Integer): Boolean;
var
  cSQL: String;
  bConectado: Boolean;
  nI: Integer;
begin
  Result      := False;
  bConectado  := Conexao.Conectado;

  if not bConectado then begin
    bConectado := Conexao.Conectar(FMsgErro);
    if FMsgErro <> '' then begin
      Exit;
    end;
  end;

  if bConectado then begin
    cSQL := 'SELECT NUM_PEDIDO, DT_EMISSAO, COD_CLI, VLR_TOTAL '+
            'FROM PEDIDO WHERE NUM_PEDIDO = :PNUM_PEDIDO       ';
    Conexao.PreparaQuery(cSQL);
    Conexao.PassaParametro('PNUM_PEDIDO', pPedido  , ftInteger);
    Conexao.AbreQuery(FMsgErro);

    if FMsgErro <> '' then begin
      Exit;
    end;

    if not Conexao.Query.IsEmpty then begin
      FNumPedido   := Conexao.Query.FieldByName('NUM_PEDIDO').AsInteger;
      FDtEmissao   := Conexao.Query.FieldByName('DT_EMISSAO').AsDateTime;
      FCodCliente  := Conexao.Query.FieldByName('COD_CLI').AsInteger;
      FVlrTotal    := Conexao.Query.FieldByName('VLR_TOTAL').AsFloat;
      Result       := True;
    end;

    cSQL := 'SELECT NUM_PEDIDO, ITEM, COD_PROD, QUANTIDADE, VLR_UNIT, VLR_TOTAL '+
            'FROM ITENS_PEDIDO WHERE NUM_PEDIDO = :PNUM_PEDIDO                  '+
            'ORDER BY ITEM                                                      ';
    Conexao.PreparaQuery(cSQL);
    Conexao.PassaParametro('PNUM_PEDIDO', pPedido  , ftInteger);
    Conexao.AbreQuery(FMsgErro);

    if FMsgErro <> '' then begin
      Exit;
    end;

    while not Conexao.Query.Eof do begin
      ListaItens.Add(TPedido.TItensPedido.Create);
      nI := ListaItens.Count - 1;

      ListaItens[nI].Item        := Conexao.Query.FieldByName('NUM_PEDIDO').AsInteger;
      ListaItens[nI].NumPedido   := Conexao.Query.FieldByName('ITEM').AsInteger;
      ListaItens[nI].CodProduto  := Conexao.Query.FieldByName('COD_PROD').AsInteger;
      ListaItens[nI].Quantidade  := Conexao.Query.FieldByName('QUANTIDADE').AsFloat;
      ListaItens[nI].VlrUnit     := Conexao.Query.FieldByName('VLR_UNIT').AsFloat;
      ListaItens[nI].VlrTotal    := Conexao.Query.FieldByName('VLR_TOTAL').AsFloat;
      Conexao.Query.Next;
    end;
  end;
end;

function TPedido.RetNumPedido: Integer;
var
  cSQL: String;
  bConectado: Boolean;
begin
  Result := 0;
  bConectado  := Conexao.Conectado;

  if not bConectado then begin
    bConectado := Conexao.Conectar(FMsgErro);
    if FMsgErro <> '' then begin
      Exit;
    end;
  end;

  if bConectado then begin
    cSQL := 'SELECT COALESCE(MAX(NUM_PEDIDO),0) + 1 NUM_PEDIDO FROM PEDIDO ';
    Conexao.PreparaQuery(cSQL);
    Conexao.AbreQuery(FMsgErro);

    if FMsgErro <> '' then begin
      Exit;
    end;

    if not Conexao.Query.IsEmpty then begin
      Result := Conexao.Query.FieldByName('NUM_PEDIDO').AsInteger;
    end;
  end;
end;

procedure TPedido.SetCodCliente(const Value: Integer);
begin
  FCodCliente := Value;
end;

procedure TPedido.SetDtEmissao(const Value: TDateTime);
begin
  FDtEmissao := Value;
end;

procedure TPedido.SetMsgErro(const Value: String);
begin
  FMsgErro := Value;
end;

procedure TPedido.SetVlrTotal(const Value: Double);
begin
  FVlrTotal := Value;
end;

end.

unit ClassProduto;

interface

uses ClassConexao, Data.DB;

type

  TProduto = class

    private
      FCodigo     : Integer;
      FDescricao  : String;
      FPrecoVenda : Double;
      Conexao     : TConexao;
      FMsgErro    : String;

      procedure SetCodigo(const Value: Integer);
      procedure SetDescricao(const Value: String);
      procedure setPrecoVenda(const Value: Double);
      procedure SetMsgErro(const Value: String);

    protected

    public
      constructor Create;
      destructor Destroy; override;
      function ValidaExiste(pProduto: Integer): Boolean;

      property Codigo         : Integer   read FCodigo     write SetCodigo;
      property Descricao      : String    read FDescricao  write SetDescricao;
      property PrecoVenda     : Double    read FPrecoVenda write setPrecoVenda;
      property MsgErro        : String    read FMsgErro    write SetMsgErro;
  end;

implementation

uses
  System.SysUtils;


{ TProduto }

constructor TProduto.Create;
begin
  Conexao := TConexao.Create;
end;

destructor TProduto.Destroy;
begin
  Conexao.Free;
  inherited;
end;

procedure TProduto.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TProduto.SetDescricao(const Value: String);
begin
  FDescricao := Value;
end;

procedure TProduto.SetMsgErro(const Value: String);
begin
  FMsgErro := Value;
end;

procedure TProduto.setPrecoVenda(const Value: Double);
begin
  FPrecoVenda := Value;
end;

function TProduto.ValidaExiste(pProduto: Integer): Boolean;
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
    cSQL := 'SELECT COD_PROD, DESCRICAO, PRECO_VENDA ' +
            'FROM PRODUTOS                           ' +
            'WHERE COD_PROD = :PCOD_PROD             ';
    Conexao.PreparaQuery(cSQL);
    Conexao.PassaParametro('PCOD_PROD', pProduto);
    Conexao.AbreQuery(FMsgErro);

    if FMsgErro <> '' then begin
      Result := False;
      Exit;
    end;

    if not Conexao.Query.IsEmpty then begin
      FCodigo     := Conexao.Query.FieldByName('COD_PROD').AsInteger;
      FDescricao  := Conexao.Query.FieldByName('DESCRICAO').AsString;
      FPrecoVenda := Conexao.Query.FieldByName('PRECO_VENDA').AsFloat;
      Result      := True;
    end;
  end;
end;

end.

unit ClassCliente;

interface

uses ClassConexao, Data.DB;

type

  TCliente = class

  private
    FCodigo : Integer;
    FNome   : String;
    FCidade : String;
    FUF     : String;
    FMsgErro: String;
    Conexao : TConexao;

    procedure SetCidade(const Value: String);
    procedure SetCodigo(const Value: Integer);
    procedure SetNome(const Value: String);
    procedure SetUF(const Value: String);
    procedure SetMsgErro(const Value: String);

  protected

  public
    constructor Create;
    destructor Destroy; override;
    function ValidaExiste(pCliente: Integer): Boolean;

    property Codigo  : Integer   read FCodigo   write SetCodigo;
    property Nome    : String    read FNome     write SetNome;
    property Cidade  : String    read FCidade   write SetCidade;
    property UF      : String    read FUF       write SetUF;
    property MsgErro : String    read FMsgErro  write SetMsgErro;
  end;

implementation

uses
  System.SysUtils;


{ TCliente }

constructor TCliente.Create;
begin
  Conexao := TConexao.Create;
end;

destructor TCliente.Destroy;
begin
  Conexao.Free;
  inherited;
end;

procedure TCliente.SetCidade(const Value: String);
begin
  FCidade := Value;
end;

procedure TCliente.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TCliente.SetMsgErro(const Value: String);
begin
  FMsgErro := Value;
end;

procedure TCliente.SetNome(const Value: String);
begin
  FNome := Value;
end;

procedure TCliente.SetUF(const Value: String);
begin
  FUF := Value;
end;

function TCliente.ValidaExiste(pCliente: Integer): Boolean;
var
  cSQL: String;
  bConectado: Boolean;
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
    cSQL := 'SELECT COD_CLI, NOME, CIDADE, UF ' +
            'FROM CLIENTES                    ' +
            'WHERE COD_CLI = :PCOD_CLI        ';
    Conexao.PreparaQuery(cSQL);
    Conexao.PassaParametro('PCOD_CLI', pCliente);
    Conexao.AbreQuery(FMsgErro);

    if FMsgErro <> '' then begin
      Result := False;
      Exit;
    end;

    if not Conexao.Query.IsEmpty then begin
      FCodigo   := Conexao.Query.FieldByName('COD_CLI').AsInteger;
      FNome     := Conexao.Query.FieldByName('NOME').AsString;
      FCidade   := Conexao.Query.FieldByName('CIDADE').AsString;
      FUF       := Conexao.Query.FieldByName('UF').AsString;
      Result    := True;
    end;
  end;
end;

end.


unit ClassConexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Dapt, FireDAC.Stan.Param, System.Variants, System.IniFiles;

type

  TConexao = class

  private
    FConection : TFDConnection;
    FMsgErro   : String;
    FQuery     : TFDQuery;

    procedure GetConfiguracao;
    procedure SetMsgErro(const Value: String);

  public
    constructor Create;
    destructor Destroy; override;
    function Conectar(var pErro: String): Boolean;
    function Conectado: Boolean;
    procedure PreparaQuery(pSQSL: String);
    procedure AbreQuery(var pErro: String);
    procedure PassaParametro(cParametro: String; pValor: Variant; const pTipo: TFieldType = ftUnknown);
    procedure ExecutaQuery(var pErro: String);
    procedure LimpaQuery;

    property MsgErro: String    read FMsgErro write SetMsgErro;
    property Query  : TFDQuery  read FQuery   write FQuery;

  end;

implementation

uses
  Vcl.Forms;

{ TConexao }

constructor TConexao.Create;
begin
  FConection := TFDConnection.Create(nil);
  Self.GetConfiguracao;
  FQuery := TFDQuery.Create(FConection);
  FQuery.Connection := FConection;
end;

destructor TConexao.Destroy;
begin
  FreeAndNil(FQuery);
  FreeAndNil(FConection);
  inherited;
end;

procedure TConexao.ExecutaQuery(var pErro: String);
begin
  try
    FQuery.ExecSQL;
  except
    on E: Exception do begin
      pErro := E.Message;
    end;
  end;
end;

procedure TConexao.AbreQuery(var pErro: String);
begin
  try
    FQuery.Open;
  except
    on E: Exception do begin
      pErro := E.Message;
    end;
  end;
end;

function TConexao.Conectado: Boolean;
begin
  Result := FConection.Connected;
end;

function TConexao.Conectar(var pErro: String): Boolean;
begin
  Result := True;
  try
    FConection.Connected    := True;
  except
    on E: Exception do begin
      pErro   := E.Message;
      Result  := False;
    end;
  end;
end;

procedure TConexao.GetConfiguracao;
var
  aArqINI: TIniFile;
  cArquivo,
  cValor: String;
Begin
  cArquivo := ExtractFilePath(Application.ExeName) + 'Config.ini';
  aArqINI  := TIniFile.Create(cArquivo);

  try
    FConection.Params.Clear;
    cValor := aArqINI.ReadString('CONEXAO', 'DriverID', cValor);
    FConection.Params.Add('DriverID=' + cValor);
    
    cValor := aArqINI.ReadString('CONEXAO', 'Database', cValor);
    FConection.Params.Add('Database=' + cValor);
    
    cValor := aArqINI.ReadString('CONEXAO', 'User_Name', cValor);
    FConection.Params.Add('User_Name='+ cValor);

    cValor := aArqINI.ReadString('CONEXAO', 'Password', cValor);
    FConection.Params.Add('Password=' + cValor);

    cValor := aArqINI.ReadString('CONEXAO', 'Server', cValor);
    FConection.Params.Add('Server='   + cValor);

    cValor := aArqINI.ReadString('CONEXAO', 'Port', cValor);
    FConection.Params.Add('Port='     + cValor);
    FConection.LoginPrompt  := False;
    
  finally
    FreeAndNil(aArqINI);
  end;
  

end;


procedure TConexao.LimpaQuery;
begin
  FQuery.SQL.Clear;
end;

procedure TConexao.PassaParametro(cParametro: String; pValor: Variant; const pTipo: TFieldType = ftUnknown);
begin
  if pTipo = ftDate then begin
    FQuery.ParamByName(cParametro).AsDate     := pValor;
  end else if pTipo = ftDateTime then begin
    FQuery.ParamByName(cParametro).AsDateTime := pValor;
  end else if pTipo = ftInteger then begin
    FQuery.ParamByName(cParametro).AsInteger  := pValor;
  end else if pTipo = ftString then begin
    FQuery.ParamByName(cParametro).AsString   := pValor;
  end else if pTipo = ftFloat then begin
    FQuery.ParamByName(cParametro).AsFloat    := pValor;
  end else begin
    FQuery.ParamByName(cParametro).Value      := pValor;
  end;
end;

procedure TConexao.PreparaQuery(pSQSL: String);
begin
  LimpaQuery;
  FQuery.SQL.Add(pSQSL);
end;

procedure TConexao.SetMsgErro(const Value: String);
begin
  FMsgErro := Value;
end;

end.

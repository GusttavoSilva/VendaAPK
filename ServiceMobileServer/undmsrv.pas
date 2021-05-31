unit undmsrv;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Win.Registry,
  System.IOUtils,
  System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.SvcMgr, Vcl.Dialogs, uConsts, inifiles, ServerUtils;

type
  TRestDWsrv = class(TService)
    procedure ServiceCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
  end;

var
  RestDWsrv: TRestDWsrv;

implementation

uses
  uDmService;

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}
{ Tdmsrv }

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  RestDWsrv.Controller(CtrlCode);
end;

function TRestDWsrv.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TRestDWsrv.ServiceCreate(Sender: TObject);
var
  ArqIni: TIniFile;
  LDirIni: string;
  LPort: Integer;
begin
  try
    try
      LDirIni := CPathIniFile;
      ArqIni := TIniFile.Create(CPathIniFile + '\cfg.ini');
      LPort := ArqIni.ReadInteger('Dados', 'Porta', 0);
      RESTServicePooler.ServerMethodClass := TServerMethodDM;
      RESTServicePooler.AuthenticationOptions.AuthorizationOption := rdwAOBasic;
      TRDWAuthOptionBasic(RESTServicePooler.AuthenticationOptions.OptionParams)
        .Username := 'testserver';
      TRDWAuthOptionBasic(RESTServicePooler.AuthenticationOptions.OptionParams)
        .Password := 'testserver';

      RESTServicePooler.ServicePort := LPort;
      RESTServicePooler.SSLPrivateKeyFile := '';
      RESTServicePooler.SSLPrivateKeyPassword := '';
      RESTServicePooler.SSLCertFile := '';
      RESTServicePooler.SSLRootCertFile := '';
      RESTServicePooler.Active := True;
{$IFDEF DEBUG}
      WriteLn('Conectado na porta: ' + LPort.ToString);
{$ENDIF}
    except
{$IFDEF DEBUG}
      on e: exception do
        WriteLn('Erro:' + inttostr(LPort) + #13 + 'Ocorreu o seguinte erro: ' +
          e.message);
{$ENDIF}
    end;
  finally
    ArqIni.Free;
  end;

end;

end.

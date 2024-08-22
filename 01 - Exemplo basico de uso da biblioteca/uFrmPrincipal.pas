unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  MeuAtributo = class(TCustomAttribute)
  end;

  [MeuAtributo]
  TFrmPrincipal = class(TForm)
  published
    { Published declarations }
    MeuCampo: TStringList;
  private
    { Private declarations }
    [MeuAtributo]
    FMeuCampo: string;
  protected
    { Protected declarations }
    procedure SetMeuCampo(const AValue: string);
  public
    { Public declarations }
    procedure MinhaProcedure;

    [MeuAtributo]
    property MinhaPropriedade: string read FMeuCampo write SetMeuCampo;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

uses
  System.Rtti;

{ TFrmPrincipal }

procedure TFrmPrincipal.MinhaProcedure;
var
  LContext: TRttiContext;
  LType   : TRttiType;
begin
  LContext := TRttiContext.Create;
  LType    := LContext.GetType(TFrmPrincipal);
end;

procedure TFrmPrincipal.SetMeuCampo(const AValue: string);
begin
  FMeuCampo := AValue;
end;

end.

unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.TypInfo;

type
  TFrmPrincipal = class(TForm)
    mmoProperties: TMemo;
    pnlButtons: TPanel;
    btnGetProperties: TButton;
    btnSetProperties: TButton;
    procedure btnGetPropertiesClick(Sender: TObject);
    procedure btnSetPropertiesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  C_VALID_TYPES = [
    // Tipo Char
    tkChar, tkWChar,

    // Tipo String
    tkString, tkLString, tkWString, tkUString
  ];

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses
  System.Rtti;

{$R *.dfm}

procedure TFrmPrincipal.btnGetPropertiesClick(Sender: TObject);
var
  LContext : TRttiContext;
  LType    : TRttiType;
  LProperty: TRttiProperty;
  LValue   : string;
begin
  LContext := TRttiContext.Create;
  LType    := LContext.GetType(TFrmPrincipal);

  mmoProperties.Lines.Clear;
  for LProperty in LType.GetProperties do
  begin
    if LProperty.DataType.TypeKind in C_VALID_TYPES then
    begin
      LValue := LProperty.GetValue(FrmPrincipal).AsString;

      if not mmoProperties.Lines.ContainsName(LProperty.Name) then
        mmoProperties.Lines.AddPair(LProperty.Name, '');

      if not LValue.IsEmpty then
        mmoProperties.lines.Values[LProperty.Name] := LValue;
    end;
  end;
end;

procedure TFrmPrincipal.btnSetPropertiesClick(Sender: TObject);
var
  LContext : TRttiContext;
  LType    : TRttiType;
  LProperty: TRttiProperty;
  LValue   : TValue;
begin
  LContext := TRttiContext.Create;
  LType    := LContext.GetType(TFrmPrincipal);

  for LProperty in LType.GetProperties do
  begin
    if LProperty.DataType.TypeKind in C_VALID_TYPES then
    begin
      if not mmoProperties.Lines.ContainsName(LProperty.Name) then
        Continue;

      LValue := TValue.From<string>(mmoProperties.lines.Values[LProperty.Name]);

      if LValue.IsEmpty then
        Continue;

      LProperty.SetValue(FrmPrincipal, LValue);
    end;
  end;
end;

end.

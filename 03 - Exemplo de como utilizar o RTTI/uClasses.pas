unit uClasses;

interface

uses
  System.TypInfo,
  System.Classes,
  System.SysUtils,
  System.Generics.Collections;

type
  TBaseClass = class(TObject)
  private
    FNome: string;
  public
    function GetRepresentacao: string;

    property Nome: string read FNome write FNome;
  end;

  TLivro = class(TBaseClass)
  private
    FTitulo        : string;
    FAutor         : string;
    FDataPublicacao: TDateTime;
    FAnoDeAquisição: Integer;
  public
    property Titulo          : string    read FTitulo         write FTitulo;
    property Autor           : string    read FAutor          write FAutor;
    property DataDePublicacao: TDateTime read FDataPublicacao write FDataPublicacao;
    property AnoDeAquisicao  : Integer   read FAnoDeAquisição write FAnoDeAquisição;
  end;

implementation

uses
  System.Rtti;

{ TBaseClass }

function TBaseClass.GetRepresentacao: string;
const
  C_TYPE_STRING = [
    tkChar, tkWChar, tkString, tkLString, tkWString, tkUString
  ];
  C_TYPE_FLOAT = [
    tkFloat
  ];
  C_TYPE_INTEGER = [
    tkInteger, tkInt64
  ];
var
  LContext : TRttiContext;
  LType    : TRttiType;
  LProperty: TRttiProperty;
  LResult  : TStringList;
  LValue   : TValue;
  LValueStr: string;
begin
  LContext := TRttiContext.Create;
  LType    := LContext.GetType(Self.ClassType);

  LResult := TStringList.Create;
  try
    for LProperty in LType.GetProperties do
    begin
      LValueStr := '';
      LValue    := LProperty.GetValue(Self);

      if LValue.IsEmpty then
        Continue;

      if LProperty.DataType.TypeKind in C_TYPE_STRING then
        LValueStr := LValue.AsString
      else if LProperty.DataType.TypeKind in C_TYPE_FLOAT then
      begin
        if LProperty.DataType.QualifiedName.Contains('TDateTime') then
          LValueStr := FormatDateTime('dd/mm/yyyy', LValue.AsExtended)
        else
          LValueStr := FormatFloat('0.00', LValue.AsExtended);
      end
      else if LProperty.DataType.TypeKind in C_TYPE_INTEGER then
        LValueStr := IntToStr(LValue.AsInt64);

      if LValueStr.IsEmpty then
        Continue;

      LResult.AddPair(LProperty.Name, LValueStr);
    end;
  finally
    Result := LResult.Text;
    FreeAndNil(LResult);
  end;
end;

end.

unit uClasses;

interface

uses
  System.TypInfo,
  System.Classes,
  System.SysUtils,
  System.RegularExpressions,
  System.Generics.Collections;

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
  C_TYPE_CLASS = [
    tkClass, tkClassRef
  ];

type
  TBaseClass = class(TObject)
  private
    FNome: string;
  public
    constructor Create;
    destructor Destroy; override;

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

  TEstante = class(TBaseClass)
  private
    FLivros: TList<TLivro>;
  public
    property Livros: TList<TLivro> read FLivros write FLivros;
  end;

  TBiblioteca = class(TBaseClass)
  private
    FEstantes: TList<TEstante>;
  public
    property Estantes: TList<TEstante> read FEstantes write FEstantes;
  end;

implementation

uses
  System.Rtti;

{ TBaseClass }

constructor TBaseClass.Create;
var
  LContext : TRttiContext;
  LType    : TRttiType;
  LProperty: TRttiProperty;
  LValue   : TValue;
  LMethod  : TRttiMethod;
begin
  inherited;

  LContext := TRttiContext.Create;
  LType    := LContext.GetType(Self.ClassType);

  for LProperty in LType.GetProperties do
  begin
    LValue := TValue.Empty;

    if LProperty.DataType.TypeKind in C_TYPE_CLASS then
    begin
      for LMethod in LProperty.DataType.GetMethods('Create') do
      begin
        if Length(LMethod.GetParameters) = 0 then
        begin
          LValue := LMethod.Invoke(LProperty.DataType.AsInstance.MetaclassType, []);
          Break;
        end;
      end;
    end;

    if LValue.IsEmpty then
      Continue;

    LProperty.SetValue(Self, LValue);
  end;
end;

destructor TBaseClass.Destroy;
var
  LContext : TRttiContext;
  LType    : TRttiType;
  LProperty: TRttiProperty;
  LValue   : TValue;
  LMethod  : TRttiMethod;
begin
  LContext := TRttiContext.Create;
  LType    := LContext.GetType(Self.ClassType);

  for LProperty in LType.GetProperties do
  begin
    LValue := LProperty.GetValue(Self);

    if LProperty.DataType.TypeKind in C_TYPE_CLASS then
    begin
      for LMethod in LProperty.DataType.GetMethods('Destroy') do
      begin
        if Length(LMethod.GetParameters) = 0 then
        begin
          LMethod.Invoke(LValue, []);
          Break;
        end;
      end;
    end;
  end;

  inherited;
end;

function TBaseClass.GetRepresentacao: string;
var
  LContext : TRttiContext;
  LType    : TRttiType;
  LProperty: TRttiProperty;
  LResult  : TStringList;
  LOtherRes: TStringList;
  LValue   : TValue;
  LValueStr: string;
  LGeneric : TRttiType;
  LGenClass: string;
  LMethod  : TRttiMethod;
  LCount   : Integer;
  LItemVal : TValue;
begin
  LContext := TRttiContext.Create;
  LType    := LContext.GetType(Self.ClassType);

  LResult   := TStringList.Create;
  LOtherRes := TStringList.Create;
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
        LValueStr := IntToStr(LValue.AsInt64)
      else if LProperty.DataType.TypeKind in C_TYPE_CLASS then
      begin
        if LProperty.DataType.QualifiedName.Contains('TList<') then
        begin
          LGenClass := LProperty.DataType.QualifiedName;
          LGenClass := Copy(LGenClass, Pos('<', LGenClass) + 1);
          SetLength(LGenClass, Length(LGenClass) - 1);

          LGeneric := LContext.FindType(LGenClass);
          if LGeneric.AsInstance.MetaclassType.InheritsFrom(TBaseClass) then
          begin
            for LMethod in LProperty.DataType.GetMethods('ToArray') do
            begin
              if Length(LMethod.GetParameters) = 0 then
              begin
                LValue := LMethod.Invoke(LValue, []);
                Break;
              end;
            end;

            for LMethod in LGeneric.GetMethods('GetRepresentacao') do
            begin
              if Length(LMethod.GetParameters) = 0 then
              begin
                for LCount := 0 to (LValue.GetArrayLength - 1) do
                begin
                  LItemVal := LMethod.Invoke(LValue.GetArrayElement(LCount), []);

                  LOtherRes.Add(LItemVal.AsString);
                end;

                Break;
              end;
            end;
          end;
        end;
      end;

      if LValueStr.IsEmpty then
        Continue;

      LResult.AddPair(LProperty.Name, LValueStr);
    end;
  finally
    if not LOtherRes.IsEmpty then
      LResult.Add(TRegEx.Replace(LOtherRes.Text.TrimRight([#10]),
        '^', '    ', [roIgnoreCase, roMultiLine]));
    Result := LResult.Text.TrimRight([#10]);
    FreeAndNil(LResult);
    FreeAndNil(LOtherRes);
  end;
end;

end.

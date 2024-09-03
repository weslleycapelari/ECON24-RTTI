unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFrmPrincipal = class(TForm)
    mmoRepresentacao: TMemo;
    pnlButtons: TPanel;
    btnGenerate: TButton;
    procedure btnGenerateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses
  uClasses;

{$R *.dfm}

procedure TFrmPrincipal.btnGenerateClick(Sender: TObject);
var
  LBiblioteca: TBiblioteca;
  LEstante   : TEstante;
  LLivro     : TLivro;
begin
  LBiblioteca := TBiblioteca.Create;
  LEstante    := TEstante.Create;
  LLivro      := TLivro.Create;
  try
    with LLivro do
    begin
      Titulo           := 'APRENDA A PROGRAMAR COM BORLAND DELPHI 7.0';
      Autor            := 'Fabíola Ventavoli';
      DataDePublicacao := StrToDate('04/11/2014');
      AnoDeAquisicao   := 2015;
    end;

    with LEstante do
    begin
      Nome := 'Estante 01';
      Livros.Add(LLivro);
    end;

    with LBiblioteca do
    begin
      Nome := 'Biblioteca 01';
      Estantes.Add(LEstante);
    end;

    mmoRepresentacao.Lines.Text := LBiblioteca.GetRepresentacao;
  finally
    FreeAndNil(LLivro);
    FreeAndNil(LEstante);
    FreeAndNil(LBiblioteca);
  end;
end;

end.

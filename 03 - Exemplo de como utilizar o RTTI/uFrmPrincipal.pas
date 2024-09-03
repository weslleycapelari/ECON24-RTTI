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
  LLivro: TLivro;
begin
  LLivro := TLivro.Create;
  try
    with LLivro do
    begin
      Titulo           := 'APRENDA A PROGRAMAR COM BORLAND DELPHI 7.0';
      Autor            := 'Fabíola Ventavoli';
      DataDePublicacao := StrToDate('04/11/2014');
      AnoDeAquisicao   := 2015;
    end;

    mmoRepresentacao.Lines.Text := LLivro.GetRepresentacao;
  finally
    FreeAndNil(LLivro);
  end;
end;

end.

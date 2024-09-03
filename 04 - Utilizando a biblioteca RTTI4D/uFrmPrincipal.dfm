object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Exemplo 04'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object mmoRepresentacao: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 618
    Height = 394
    Align = alClient
    TabOrder = 0
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 400
    Width = 624
    Height = 41
    Align = alBottom
    TabOrder = 1
    object btnGenerate: TButton
      AlignWithMargins = True
      Left = 432
      Top = 4
      Width = 188
      Height = 33
      Align = alRight
      Caption = 'Gerar Inst'#226'ncia(s) e Representar'
      TabOrder = 0
      OnClick = btnGenerateClick
    end
  end
end

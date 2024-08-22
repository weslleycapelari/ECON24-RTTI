object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Exemplo 02'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object mmoProperties: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 618
    Height = 394
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
    WantTabs = True
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 400
    Width = 624
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitLeft = 232
    ExplicitTop = 224
    ExplicitWidth = 185
    object btnGetProperties: TButton
      AlignWithMargins = True
      Left = 366
      Top = 4
      Width = 124
      Height = 33
      Align = alRight
      Caption = 'Buscar Propriedades'
      TabOrder = 0
      OnClick = btnGetPropertiesClick
      ExplicitLeft = 496
    end
    object btnSetProperties: TButton
      AlignWithMargins = True
      Left = 496
      Top = 4
      Width = 124
      Height = 33
      Align = alRight
      Caption = 'Definir Propriedades'
      TabOrder = 1
      OnClick = btnSetPropertiesClick
    end
  end
end

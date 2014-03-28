object Form1: TForm1
  Left = 204
  Top = 266
  Width = 733
  Height = 501
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 112
    Top = 208
    Width = 137
    Height = 13
    Caption = 'lbl1'
  end
  object btn1: TBitBtn
    Left = 16
    Top = 200
    Width = 75
    Height = 25
    Caption = #19978#20256
    TabOrder = 0
    OnClick = btn1Click
  end
  object dbgrd1: TDBGrid
    Left = 8
    Top = 56
    Width = 697
    Height = 121
    DataSource = ds1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object chk1: TCheckBox
    Left = 288
    Top = 208
    Width = 97
    Height = 17
    Caption = 'stop'
    TabOrder = 2
  end
  object ds1: TDataSource
    DataSet = tbl1
    Left = 16
    Top = 16
  end
  object con1: TADOConnection
    LoginPrompt = False
    Left = 48
    Top = 16
  end
  object tbl1: TADOTable
    Connection = con1
    TableName = 'xhzd_surnfu'
    Left = 80
    Top = 16
  end
end

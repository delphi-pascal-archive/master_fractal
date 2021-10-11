object Form2: TForm2
  Left = 192
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1055#1088#1080#1074#1103#1079#1082#1080
  ClientHeight = 93
  ClientWidth = 215
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 53
    Height = 13
    Caption = #1055#1088#1080#1074#1103#1079#1082#1080':'
  end
  object SpeedButton1: TSpeedButton
    Left = 72
    Top = 64
    Width = 65
    Height = 25
    Caption = 'OK'
    OnClick = SpeedButton1Click
  end
  object CheckListBox1: TCheckListBox
    Left = 8
    Top = 24
    Width = 201
    Height = 33
    ItemHeight = 13
    Items.Strings = (
      #1043#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1099#1077
      #1042#1077#1088#1090#1080#1082#1072#1083#1100#1085#1099#1077)
    TabOrder = 0
  end
end

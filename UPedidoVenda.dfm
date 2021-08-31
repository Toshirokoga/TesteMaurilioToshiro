object FrmPedidoVenda: TFrmPedidoVenda
  Left = 0
  Top = 0
  ActiveControl = EditCliente
  BorderStyle = bsDialog
  Caption = 'Pedido de Venda'
  ClientHeight = 589
  ClientWidth = 691
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlInferior: TPanel
    Left = 0
    Top = 535
    Width = 691
    Height = 54
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 467
    object lblTotalPedido: TLabel
      AlignWithMargins = True
      Left = 22
      Top = 25
      Width = 160
      Height = 19
      Align = alCustom
      Alignment = taCenter
      Caption = 'Valor total: R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 19
      ExplicitTop = 22
    end
    object btnFechar: TButton
      Left = 596
      Top = 1
      Width = 94
      Height = 52
      Align = alRight
      Caption = 'Fechar'
      TabOrder = 0
      OnClick = btnFecharClick
    end
    object btnGravarPedido: TButton
      Left = 502
      Top = 1
      Width = 94
      Height = 52
      Align = alRight
      Caption = 'Gravar Pedido'
      TabOrder = 1
      OnClick = btnGravarPedidoClick
    end
  end
  object pnlCabecalho: TPanel
    Left = 0
    Top = 0
    Width = 691
    Height = 169
    Align = alTop
    TabOrder = 1
    object btnPesqPedidos: TSpeedButton
      Left = 87
      Top = 24
      Width = 25
      Height = 21
      Hint = 'Pesquisar Pedidos'
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnClick = btnPesqPedidosClick
    end
    object Label1: TLabel
      Left = 87
      Top = 58
      Width = 58
      Height = 13
      Caption = 'Data Pedido'
    end
    object EditCliente: TLabeledEdit
      Left = 16
      Top = 24
      Width = 65
      Height = 21
      EditLabel.Width = 33
      EditLabel.Height = 13
      EditLabel.Caption = 'Cliente'
      NumbersOnly = True
      TabOrder = 0
      TextHint = 'C'#243'd. Cliente'
      OnEnter = EditClienteEnter
      OnExit = EditClienteExit
    end
    object EditDtEmissao: TDateTimePicker
      Left = 87
      Top = 72
      Width = 97
      Height = 21
      Date = 44436.740164791660000000
      Time = 44436.740164791660000000
      TabOrder = 5
    end
    object EditNomeCliente: TEdit
      Left = 120
      Top = 24
      Width = 305
      Height = 21
      Color = clGradientActiveCaption
      ReadOnly = True
      TabOrder = 1
      TextHint = 'Nome do cliente'
    end
    object EditVlrTotal: TLabeledEdit
      Left = 566
      Top = 72
      Width = 113
      Height = 21
      EditLabel.Width = 61
      EditLabel.Height = 13
      EditLabel.Caption = 'Valor Total'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'Tahoma'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
    end
    object Panel1: TPanel
      Left = 1
      Top = 112
      Width = 689
      Height = 56
      Align = alBottom
      Caption = 'Itens Pedido'
      TabOrder = 7
      ExplicitTop = 80
      object btnInserirItem: TButton
        Left = 1
        Top = 1
        Width = 75
        Height = 54
        Align = alLeft
        Caption = 'Inserir'
        TabOrder = 0
        OnClick = btnInserirItemClick
      end
      object btnAlterarItem: TButton
        Left = 76
        Top = 1
        Width = 75
        Height = 54
        Align = alLeft
        Caption = 'Alterar'
        TabOrder = 1
        OnClick = btnAlterarItemClick
      end
      object btnExcluirItem: TButton
        Left = 151
        Top = 1
        Width = 75
        Height = 54
        Align = alLeft
        Caption = 'Excluir'
        TabOrder = 2
        OnClick = btnExcluirItemClick
      end
    end
    object EditPedido: TLabeledEdit
      Left = 16
      Top = 72
      Width = 65
      Height = 21
      EditLabel.Width = 47
      EditLabel.Height = 13
      EditLabel.Caption = 'N'#186' Pedido'
      NumbersOnly = True
      ReadOnly = True
      TabOrder = 4
      TextHint = 'N'#186' Pedido'
    end
    object EditCidade: TEdit
      Left = 432
      Top = 24
      Width = 210
      Height = 21
      Color = clGradientActiveCaption
      ReadOnly = True
      TabOrder = 2
      TextHint = 'Cidade'
    end
    object EditUF: TEdit
      Left = 649
      Top = 24
      Width = 30
      Height = 21
      Color = clGradientActiveCaption
      ReadOnly = True
      TabOrder = 3
      TextHint = 'UF'
    end
    object pnlPedido: TPanel
      Left = 257
      Top = 16
      Width = 144
      Height = 65
      TabOrder = 8
      Visible = False
      object EditPedidoPesquisa: TLabeledEdit
        Left = 40
        Top = 20
        Width = 65
        Height = 21
        Alignment = taCenter
        EditLabel.Width = 136
        EditLabel.Height = 13
        EditLabel.Caption = 'Informe o n'#250'mero do pedido'
        NumbersOnly = True
        TabOrder = 0
        TextHint = 'N'#186' Pedido'
      end
      object btnConfirmaPedidoPesquisa: TButton
        Left = 1
        Top = 47
        Width = 142
        Height = 17
        Align = alBottom
        Caption = 'Confirmar'
        TabOrder = 1
        OnClick = btnConfirmaPedidoPesquisaClick
        ExplicitTop = 72
      end
    end
  end
  object pnlItens: TPanel
    Left = 0
    Top = 169
    Width = 691
    Height = 366
    Align = alClient
    TabOrder = 2
    ExplicitTop = 137
    ExplicitHeight = 398
    object DBGridItens: TDBGrid
      Left = 1
      Top = 1
      Width = 689
      Height = 364
      Align = alClient
      DataSource = DItens
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDrawColumnCell = DBGridItensDrawColumnCell
      OnDblClick = DBGridItensDblClick
      OnKeyDown = DBGridItensKeyDown
      OnKeyPress = DBGridItensKeyPress
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'Produto'
          Title.Alignment = taCenter
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Descricao'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'Quantidade'
          Title.Alignment = taCenter
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'Vlr_Unit'
          Title.Alignment = taCenter
          Title.Caption = 'Vlr. Unit'#225'rio'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'Vlr_Total'
          Title.Alignment = taCenter
          Title.Caption = 'Vlr. Total'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Visible = True
        end>
    end
  end
  object pnlCadastroItem: TPanel
    Left = 120
    Top = 256
    Width = 425
    Height = 153
    TabOrder = 3
    Visible = False
    object Panel2: TPanel
      Left = 1
      Top = 111
      Width = 423
      Height = 41
      Align = alBottom
      TabOrder = 4
      object BtnCancelarItem: TButton
        Left = 347
        Top = 1
        Width = 75
        Height = 39
        Align = alRight
        Caption = 'Cancelar'
        TabOrder = 1
        OnClick = BtnCancelarItemClick
      end
      object btnConfirmarItem: TButton
        Left = 272
        Top = 1
        Width = 75
        Height = 39
        Align = alRight
        Caption = 'Confirmar'
        TabOrder = 0
        OnClick = btnConfirmarItemClick
      end
    end
    object EditProduto: TLabeledEdit
      Left = 17
      Top = 24
      Width = 65
      Height = 21
      EditLabel.Width = 38
      EditLabel.Height = 13
      EditLabel.Caption = 'Produto'
      NumbersOnly = True
      TabOrder = 0
      TextHint = 'C'#243'd. Produto'
      OnEnter = EditClienteEnter
      OnExit = EditProdutoExit
    end
    object EditDescricaoProduto: TEdit
      Left = 88
      Top = 24
      Width = 321
      Height = 21
      Color = clGradientActiveCaption
      ReadOnly = True
      TabOrder = 1
      TextHint = 'Nome do cliente'
    end
    object EditVlrUnit: TLabeledEdit
      Left = 104
      Top = 72
      Width = 80
      Height = 21
      EditLabel.Width = 64
      EditLabel.Height = 13
      EditLabel.Caption = 'Valor Unit'#225'rio'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'Tahoma'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      TextHint = 'Valor Unit'#225'rio'
      OnExit = EditVlrUnitExit
    end
    object EditQtde: TLabeledEdit
      Left = 17
      Top = 72
      Width = 80
      Height = 21
      EditLabel.Width = 56
      EditLabel.Height = 13
      EditLabel.Caption = 'Quantidade'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'Tahoma'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      TextHint = 'Quantidade'
      OnExit = EditQtdeExit
    end
  end
  object CDSItens: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 600
    Top = 177
    object CDSItensItem: TIntegerField
      FieldName = 'Item'
    end
    object CDSItensProduto: TIntegerField
      FieldName = 'Produto'
    end
    object CDSItensDescricao: TStringField
      FieldName = 'Descricao'
      Size = 50
    end
    object CDSItensQuantidade: TFloatField
      FieldName = 'Quantidade'
      DisplayFormat = '#,##0.00'
      EditFormat = '#,##0.00'
    end
    object CDSItensVlr_Unit: TFloatField
      FieldName = 'Vlr_Unit'
      DisplayFormat = '#,##0.00'
      EditFormat = '#,##0.00'
    end
    object CDSItensVlr_Total: TFloatField
      FieldName = 'Vlr_Total'
      DisplayFormat = '#,##0.00'
      EditFormat = '#,##0.00'
    end
  end
  object DItens: TDataSource
    DataSet = CDSItens
    Left = 648
    Top = 177
  end
end

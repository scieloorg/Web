VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.1#0"; "COMCTL32.OCX"
Begin VB.Form FormConfig 
   Caption         =   "Configuration"
   ClientHeight    =   5250
   ClientLeft      =   465
   ClientTop       =   750
   ClientWidth     =   7485
   Icon            =   "Config.frx":0000
   LinkTopic       =   "Form5"
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   5250
   ScaleWidth      =   7485
   Begin VB.CommandButton CmdAjuda 
      Caption         =   "Help"
      Height          =   375
      Left            =   6600
      TabIndex        =   3
      Top             =   2160
      Width           =   735
   End
   Begin VB.CommandButton CmdCan 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   6600
      TabIndex        =   2
      Top             =   1560
      Width           =   735
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "OK"
      Height          =   375
      Left            =   6600
      TabIndex        =   1
      Top             =   960
      Width           =   735
   End
   Begin TabDlg.SSTab SSTabConfig 
      Height          =   5055
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   6375
      _ExtentX        =   11245
      _ExtentY        =   8916
      _Version        =   327680
      Tab             =   2
      TabHeight       =   529
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      TabCaption(0)   =   "Directory Tree"
      TabPicture(0)   =   "Config.frx":030A
      Tab(0).ControlCount=   2
      Tab(0).ControlEnabled=   0   'False
      Tab(0).Control(0)=   "MsgWhatisit"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "DirTree"
      Tab(0).Control(1).Enabled=   0   'False
      TabCaption(1)   =   "Tags"
      TabPicture(1)   =   "Config.frx":0326
      Tab(1).ControlCount=   2
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "FramTag"
      Tab(1).Control(0).Enabled=   0   'False
      Tab(1).Control(1)=   "CmdTagEdit"
      Tab(1).Control(1).Enabled=   0   'False
      TabCaption(2)   =   "Others"
      TabPicture(2)   =   "Config.frx":0342
      Tab(2).ControlCount=   2
      Tab(2).ControlEnabled=   -1  'True
      Tab(2).Control(0)=   "Frame2"
      Tab(2).Control(0).Enabled=   0   'False
      Tab(2).Control(1)=   "Frame1"
      Tab(2).Control(1).Enabled=   0   'False
      Begin VB.Frame Frame1 
         Caption         =   "Web Browser Program"
         Height          =   1455
         Left            =   120
         TabIndex        =   24
         Top             =   2280
         Width           =   6135
         Begin VB.TextBox TxtBrowserPath 
            Height          =   285
            Left            =   120
            Locked          =   -1  'True
            TabIndex        =   27
            Tag             =   "Text"
            Top             =   240
            Width           =   5175
         End
         Begin VB.CommandButton CmdFind 
            Caption         =   "Find"
            Height          =   375
            Left            =   5400
            TabIndex        =   26
            Top             =   240
            Width           =   615
         End
         Begin VB.ComboBox ComboIdiomHelp 
            Height          =   315
            Left            =   120
            Style           =   2  'Dropdown List
            TabIndex        =   25
            Tag             =   "ComboIdiomHelp"
            Top             =   960
            Width           =   3255
         End
         Begin VB.Label Label1 
            Caption         =   "Idiom of interface"
            Height          =   255
            Left            =   120
            TabIndex        =   28
            Top             =   720
            Width           =   1335
         End
      End
      Begin VB.CommandButton CmdTagEdit 
         Caption         =   "Accept edition"
         Height          =   495
         Left            =   -69960
         TabIndex        =   13
         Top             =   2640
         Visible         =   0   'False
         Width           =   975
      End
      Begin VB.Frame Frame2 
         Caption         =   "Sigla"
         Height          =   1695
         Left            =   120
         TabIndex        =   8
         Top             =   420
         Width           =   3375
         Begin VB.TextBox TxtSupplNo 
            Height          =   285
            Left            =   1920
            TabIndex        =   17
            Tag             =   "Text"
            Top             =   1320
            Width           =   1335
         End
         Begin VB.TextBox TxtSupplVol 
            Height          =   285
            Left            =   1920
            TabIndex        =   16
            Tag             =   "Text"
            Top             =   600
            Width           =   1335
         End
         Begin VB.TextBox TxtSglNro 
            Height          =   285
            Left            =   1920
            TabIndex        =   10
            Tag             =   "Text"
            Top             =   960
            Width           =   1335
         End
         Begin VB.TextBox TxtSglVol 
            Height          =   285
            Left            =   1920
            TabIndex        =   9
            Tag             =   "Text"
            Top             =   240
            Width           =   1335
         End
         Begin VB.Label labSupplNo 
            Caption         =   "Number Supplement"
            Height          =   255
            Left            =   120
            TabIndex        =   15
            Top             =   1320
            Width           =   1575
         End
         Begin VB.Label LabSupplVol 
            Caption         =   "Volume Supplement"
            Height          =   255
            Left            =   120
            TabIndex        =   14
            Top             =   600
            Width           =   1455
         End
         Begin VB.Label LabSglVol 
            Caption         =   "Volume"
            Height          =   255
            Left            =   120
            TabIndex        =   12
            Top             =   240
            Width           =   1335
         End
         Begin VB.Label LabSglNro 
            Caption         =   "Number"
            Height          =   255
            Left            =   120
            TabIndex        =   11
            Top             =   960
            Width           =   1575
         End
      End
      Begin VB.Frame FramTag 
         Height          =   4575
         Left            =   -74880
         TabIndex        =   4
         Top             =   360
         Width           =   6135
         Begin VB.TextBox TxtSubf 
            Height          =   285
            Left            =   4920
            Locked          =   -1  'True
            TabIndex        =   21
            Top             =   1560
            Width           =   975
         End
         Begin VB.ComboBox ComboTags 
            Height          =   315
            ItemData        =   "Config.frx":035E
            Left            =   960
            List            =   "Config.frx":0360
            Style           =   2  'Dropdown List
            TabIndex        =   19
            Top             =   240
            Width           =   2775
         End
         Begin VB.TextBox TxtField 
            Height          =   285
            Left            =   4920
            Locked          =   -1  'True
            TabIndex        =   6
            Top             =   960
            Width           =   975
         End
         Begin VB.ListBox ListTag 
            BackColor       =   &H00C0C0C0&
            Height          =   3660
            IntegralHeight  =   0   'False
            Left            =   120
            TabIndex        =   5
            Top             =   720
            Width           =   4575
         End
         Begin VB.Label LabSubf 
            AutoSize        =   -1  'True
            Caption         =   "Subfield"
            Height          =   195
            Left            =   4920
            TabIndex        =   20
            Top             =   1320
            Width           =   570
         End
         Begin VB.Label LabTpTags 
            AutoSize        =   -1  'True
            Caption         =   "Data Base"
            Height          =   195
            Left            =   120
            TabIndex        =   18
            Top             =   360
            Width           =   750
         End
         Begin VB.Label LabField 
            AutoSize        =   -1  'True
            Caption         =   "Field Tag"
            Height          =   195
            Left            =   4920
            TabIndex        =   7
            Top             =   720
            Width           =   660
         End
      End
      Begin ComctlLib.TreeView DirTree 
         Height          =   4095
         Left            =   -74880
         TabIndex        =   23
         Top             =   840
         Width           =   6135
         _ExtentX        =   10821
         _ExtentY        =   7223
         _Version        =   327680
         HideSelection   =   0   'False
         LineStyle       =   1
         Style           =   4
         Appearance      =   1
         MouseIcon       =   "Config.frx":0362
      End
      Begin VB.Label MsgWhatisit 
         Caption         =   "What is it?"
         Height          =   255
         Left            =   -74760
         TabIndex        =   22
         Top             =   480
         Width           =   5655
      End
   End
End
Attribute VB_Name = "FormConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private NormalHeight As Long
Private NormalWidth As Long

Private OldHeight As Long
Private OldWidth As Long

Private ISISTags As ColTag


Private Sub CmdFind_Click()
    frmFindBrowser.ViewPath
    TxtBrowserPath.Text = frmFindBrowser.FindBrowserPath
End Sub



Private Sub Form_Load()
    Set GlVar("SglVol").ObjText = TxtSglVol
    Set GlVar("SglNo").ObjText = TxtSglNro
    Set GlVar("SglVolSuppl").ObjText = TxtSupplVol
    Set GlVar("SglNoSuppl").ObjText = TxtSupplNo
    Set GlVar("BrowserPath").ObjText = TxtBrowserPath
    Set GlVar("CurrIdiomHelp").ObjText = ComboIdiomHelp

    ShowConfigValues
    
    MakeTree
    
    OldHeight = Height
    OldWidth = Width
    NormalHeight = Height
    NormalWidth = Width
End Sub

Private Sub ShowConfigValues()
    Dim i As Long
    
    ComboTags.AddItem ("DB Titles")
    ComboTags.AddItem ("DB Sections")
    ComboTags.AddItem ("DB Issues")
    ComboTags.AddItem ("DB Issues Idioms")
    ComboTags.ListIndex = 0
    
    'ConfigvarsShow
    For i = 1 To GlVar.Count
        Select Case GlVar(i).ObjText.tag
        Case "Text"
            GlVar(i).ObjText.Text = GlVar(i).Value
        End Select
    Next
    
    ComboIdiomHelp.Clear
    For i = 1 To IdiomHelp.Count
        ComboIdiomHelp.AddItem IdiomsInfo(IdiomHelp(i).More).label
    Next
    ComboIdiomHelp.Text = IdiomsInfo(GlVar("CurrIdiomHelp").Value).label

End Sub

Private Sub SetISISTags()
    
    Set ISISTags = New ColTag
    
    Select Case ComboTags.Text
    Case "DB Titles"
        Set ISISTags = DBTitleTags
    Case "DB Sections"
        Set ISISTags = DBSectionTags
    Case "DB Issues"
        Set ISISTags = DBIssueTags
    Case "DB Issues Idioms"
        Set ISISTags = DBIssIdiomTags
    End Select
End Sub

Private Sub ShowTags()
    Dim i As Long
    
    SetISISTags
    ListTag.Clear
    For i = 1 To ISISTags.Count
        ListTag.AddItem (ISISTags(i).label)
    Next
    ListTag.ListIndex = 0
End Sub

Private Sub ConfigVarsLet(Key)
    With GlVar.Item(Key)
    Select Case .ObjText.tag
    Case "List"
        GetList (Key)
    Case "Combo"
        GetList (Key)
    Case "Text"
        .Value = .ObjText.Text
    End Select
    End With
End Sub

Private Sub CmdAjuda_Click()
    Call frmFindBrowser.CallBrowser(FormMenuPrin.DirStruct.Nodes("Help of Configuration").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Help of Configuration").Text)
End Sub

Private Sub CmdCan_Click()
    Unload Me
End Sub

Private Sub CmdOK_Click()
    'CmdGetValuesFromForm
    Dim i As Long
    
    For i = 1 To GlVar.Count
        ConfigVarsLet (i)
    Next
    ChangeInterfaceIdiom = IdiomHelp(ComboIdiomHelp.ListIndex + 1).More

    If CheckINI Then Unload Me

End Sub

Private Sub CmdTagEdit_Click()
    SetISISTags
    ISISTags.Item(ListTag.ListIndex + 1).Value = TxtField.Text
    ISISTags(ListTag.ListIndex + 1).Subf = TxtSubf.Text
    ISISTags.CheckTags (ListTag.ListIndex + 1)
End Sub

Private Sub ComboTags_Change()
    ShowTags
End Sub

Private Sub ComboTags_Click()
    ShowTags
End Sub

Private Sub listTag_Click()
    TagSelect
End Sub

Private Sub TagSelect()
    SetISISTags
    TxtField.Text = ISISTags(ListTag.ListIndex + 1).Value
    TxtSubf.Text = ISISTags(ListTag.ListIndex + 1).Subf
End Sub

Private Sub Form_Resize()
    Resize
End Sub

Private Sub Resize()
    Dim x As Double
    Dim Y As Double
    
    If WindowState <> vbMinimized Then
        If Height < NormalHeight Then
            'OldHeight = Height
            Height = NormalHeight
        ElseIf Width < NormalWidth Then
            'OldWidth = Width
            Width = NormalWidth
        Else
            x = Width / OldWidth
            Y = Height / OldHeight
            Call Posicionar(x, Y)
            OldHeight = Height
            OldWidth = Width
        End If
    End If
End Sub

Private Sub Posicionar(x As Double, Y As Double)
    Dim i As Long
    Dim atual As Long
    
    Call Redimensionar(CmdOK, x, 1, 1, 1)
    Call Redimensionar(CmdCan, x, 1, 1, 1)
    Call Redimensionar(CmdAjuda, x, 1, 1, 1)
    Call Redimensionar(SSTabConfig, x, Y, x, Y)
    
    atual = SSTabConfig.Tab
    
    For i = 0 To SSTabConfig.Tabs - 1
        SSTabConfig.Tab = i
        Call PosicionarTab(i, x, Y)
    Next
    SSTabConfig.Tab = atual
End Sub

Private Sub Redimensionar(obj As Object, Left As Double, Top As Double, Width As Double, Height As Double)
    On Error GoTo erro
    obj.Left = Left * obj.Left
    obj.Top = Top * obj.Top
    If Height <> 1 Then obj.Height = CLng(Height * obj.Height)
    If Width <> 1 Then obj.Width = Width * obj.Width
Exit Sub
erro:
Debug.Print
End Sub

Private Sub PosicionarTab(idx As Long, x As Double, Y As Double)
    Dim i As Integer

    Select Case idx
    Case 0
        Call Redimensionar(MsgWhatisit, x, Y, 1, 1)
        Call Redimensionar(DirTree, x, Y, x, Y)
    Case 2

    Case 1
        Call Redimensionar(LabTpTags, x, Y, 1, 1)
        Call Redimensionar(LabField, x, Y, 1, 1)
        Call Redimensionar(LabSubf, x, Y, 1, 1)
        Call Redimensionar(ComboTags, x, Y, 1, 1)
        Call Redimensionar(TxtField, x, Y, 1, 1)
        Call Redimensionar(TxtSubf, x, Y, 1, 1)
        Call Redimensionar(FramTag, x, Y, x, Y)
        Call Redimensionar(ListTag, x, Y, x, Y)
        Call Redimensionar(CmdTagEdit, x, Y, 1, 1)

    End Select
End Sub

Sub SetList(lista As ListBox, v As String)
    Dim Elem() As String
    Dim q As Long
    Dim j As Long
            
    lista.Clear
    q = GetElemStr(v, ",", Elem)
    For j = 1 To q
        lista.AddItem Elem(j)
    Next
End Sub

Sub GetList(i)
    Dim j As Long
        
    With GlVar(i)
        .Value = ""
        For j = 1 To .ObjText.ListCount - 1
            .Value = .Value + "," + .ObjText.List(j)
        Next
        If .ObjText.ListCount > 0 Then .Value = .ObjText.List(0) + .Value
    End With
End Sub

Private Sub DirTree_BeforeLabelEdit(Cancel As Integer)
    Cancel = True
End Sub

Private Sub DirTree_DblClick()
    DirTree.SelectedItem.Expanded = True
End Sub

Private Sub DirTree_NodeClick(ByVal Node As ComctlLib.Node)
    MsgWhatisit.Caption = Node.Text + " is " + Node.Key
End Sub

Private Sub MakeTree()
    Dim i As Long
  
    For i = 1 To Counter
        Call CreateNode(NodeInfo(i), NodeChild(i), NodeFatherKey(i))
    Next
End Sub
Private Sub CreateNode(Info As String, Child As String, Father As String)
    
    If Len(Father) > 0 Then
        Call DirTree.Nodes.Add(Father, tvwChild, Info, Child)
    Else
        Call DirTree.Nodes.Add(, , Info, Child)
    End If
    DirTree.Nodes(Info).Expanded = True
End Sub


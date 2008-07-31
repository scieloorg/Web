VERSION 5.00
Begin VB.Form FormConfig 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Configuration"
   ClientHeight    =   1935
   ClientLeft      =   450
   ClientTop       =   735
   ClientWidth     =   8010
   Icon            =   "frmConfig.frx":0000
   LinkTopic       =   "Form5"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   1935
   ScaleWidth      =   8010
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame Frame1 
      Height          =   1695
      Left            =   120
      TabIndex        =   6
      Top             =   120
      Width           =   6615
      Begin VB.ComboBox ComboBV 
         Height          =   315
         Left            =   3480
         TabIndex        =   8
         Text            =   "Combo1"
         Top             =   1200
         Width           =   2895
      End
      Begin VB.ComboBox ComboIdiomHelp 
         Height          =   315
         Left            =   120
         Style           =   2  'Dropdown List
         TabIndex        =   2
         Tag             =   "ComboIdiomHelp"
         Top             =   1200
         Width           =   3255
      End
      Begin VB.CommandButton CmdFind 
         Caption         =   "Find"
         Height          =   375
         Left            =   5400
         TabIndex        =   1
         Top             =   480
         Width           =   1095
      End
      Begin VB.TextBox TxtBrowserPath 
         Height          =   285
         Left            =   120
         Locked          =   -1  'True
         TabIndex        =   0
         Tag             =   "Text"
         Top             =   480
         Width           =   5175
      End
      Begin VB.Label LabWebBrowserProgram 
         Caption         =   "Web Browser Program"
         Height          =   255
         Left            =   120
         TabIndex        =   10
         Top             =   240
         Width           =   2055
      End
      Begin VB.Label LabBV 
         Caption         =   "Virtual Library"
         Height          =   255
         Left            =   3480
         TabIndex        =   9
         Top             =   960
         Width           =   1575
      End
      Begin VB.Label LabIdiomInterf 
         AutoSize        =   -1  'True
         Caption         =   "Idiom of interface"
         Height          =   195
         Left            =   120
         TabIndex        =   7
         Top             =   960
         Width           =   1215
      End
   End
   Begin VB.CommandButton CmdAjuda 
      Caption         =   "Help"
      Height          =   375
      Left            =   6840
      TabIndex        =   5
      Top             =   1200
      Width           =   1095
   End
   Begin VB.CommandButton CmdCan 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   6840
      TabIndex        =   4
      Top             =   720
      Width           =   1095
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "OK"
      Height          =   375
      Left            =   6840
      TabIndex        =   3
      Top             =   240
      Width           =   1095
   End
End
Attribute VB_Name = "FormConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private BrPath As String

Private NormalHeight As Long
Private NormalWidth As Long

Private OldHeight As Long
Private OldWidth As Long

Private Sub CmdFind_Click()
    Dim newbrowserpath As String
    frmFindBrowser.ViewPath
    newbrowserpath = frmFindBrowser.FindBrowserPath
    If Len(newbrowserpath) > 0 Then TxtBrowserPath.Text = newbrowserpath
End Sub

Private Sub Form_Load()
    
    OldHeight = Height
    OldWidth = Width
    NormalHeight = Height
    NormalWidth = Width
    
    CmdAjuda.Visible = (help <> "0")
    
End Sub

Private Sub CmdAjuda_Click()
    Call frmFindBrowser.CallBrowser(ConvertDirTree.DirNodes("Help of Configuration").Parent.FullPath, ConvertDirTree.DirNodes("Help of Configuration").Text)
End Sub

Private Sub CmdCan_Click()
    Unload Me
End Sub

Private Sub cmdOK_Click()
    MousePointer = vbHourglass
    'ChangeInterfaceIdiom = CodeIdiom(ComboIdiomHelp.Text).code
    Currbv = ComboBV.Text
    CurrIdiomHelp = ComboIdiomHelp.Text
    MousePointer = vbArrow
'    if bv(currbv).LoadFilestoConverterProgram Then
'        Unload Me
'    End If
    ConfigSet
    Unload Me
End Sub

Sub OpenConfig()
    Dim i As Long
    
    ComboIdiomHelp.Clear
    For i = 1 To IdiomHelp.Count
        ComboIdiomHelp.AddItem IdiomHelp(i).Label
    Next
    ComboIdiomHelp.Text = CurrIdiomHelp
    
    ComboBV.Clear
    For i = 1 To BV.Count
        ComboBV.AddItem BV(i).BVname
    Next
    If Len(Currbv) > 0 Then ComboBV.Text = BV(Currbv).BVname
    'With ConfigLabels
    'Caption = PROGRAM_CAPTION + .mnConfiguration
    'Frame1.Caption = .Config_WebBrowserPath
    'Label1.Caption = .Config_InterfaceIdiom
    'CmdFind.Caption = .Config_FindPath
    'CmdOK.Caption = .ButtonOK
    'CmdCan.Caption = .ButtonCancel
    'CmdAjuda.Caption = .mnHelp
    'End With
    
    Caption = InterfaceLabels("formConfig_Caption").elem2
    If Len(Currbv) > 0 Then Caption = BV(Currbv).BVname + " - " + Caption
    LabWebBrowserProgram.Caption = InterfaceLabels("formConfig_LabWebBrowserProgram").elem2
    CmdFind.Caption = InterfaceLabels("CmdFind").elem2
    LabIdiomInterf.Caption = InterfaceLabels("formConfig_LabIdiomInterf").elem2
    LabBV.Caption = InterfaceLabels("formConfig_LabBV").elem2
    CmdOK.Caption = InterfaceLabels("CmdOK").elem2
    CmdCan.Caption = InterfaceLabels("CmdCancel").elem2
    CmdAjuda.Caption = InterfaceLabels("CmdHelp").elem2
    
    
    TxtBrowserPath.Text = DEFAULTBROWSERPATH
    
    'Call FillCombo(ComboIdiomHelp, CodeIdiom)
    'ComboIdiomHelp.ListIndex = 0
    
    Show vbModal
End Sub

VERSION 5.00
Begin VB.Form FormConfig 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Configuration"
   ClientHeight    =   1710
   ClientLeft      =   450
   ClientTop       =   735
   ClientWidth     =   7800
   Icon            =   "frmConfig.frx":0000
   LinkTopic       =   "Form5"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   1710
   ScaleWidth      =   7800
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame Frame1 
      Caption         =   "Web Browser Program"
      Height          =   1455
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   6495
      Begin VB.ComboBox ComboIdiomHelp 
         Height          =   315
         Left            =   120
         Style           =   2  'Dropdown List
         TabIndex        =   6
         Tag             =   "ComboIdiomHelp"
         Top             =   960
         Width           =   3255
      End
      Begin VB.CommandButton CmdFind 
         Caption         =   "Find"
         Height          =   375
         Left            =   5400
         TabIndex        =   5
         Top             =   240
         Width           =   855
      End
      Begin VB.TextBox TxtBrowserPath 
         Height          =   285
         Left            =   120
         Locked          =   -1  'True
         TabIndex        =   4
         Tag             =   "Text"
         Top             =   240
         Width           =   5175
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "Idiom of interface"
         Height          =   195
         Left            =   120
         TabIndex        =   7
         Top             =   720
         Width           =   1215
      End
   End
   Begin VB.CommandButton CmdAjuda 
      Caption         =   "Help"
      Height          =   375
      Left            =   6840
      TabIndex        =   2
      Top             =   1200
      Width           =   855
   End
   Begin VB.CommandButton CmdCan 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   6840
      TabIndex        =   1
      Top             =   720
      Width           =   855
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "OK"
      Height          =   375
      Left            =   6840
      TabIndex        =   0
      Top             =   240
      Width           =   855
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
    frmFindBrowser.ViewPath
    TxtBrowserPath.Text = frmFindBrowser.FindBrowserPath
End Sub

Private Sub Form_Load()
    
    OldHeight = Height
    OldWidth = Width
    NormalHeight = Height
    NormalWidth = Width
    
End Sub

Private Sub CmdAjuda_Click()
    Call frmFindBrowser.CallBrowser(FormMenuPrin.DirStruct.Nodes("Help of Configuration").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Help of Configuration").Text)
End Sub

Private Sub CmdCan_Click()
    Unload Me
End Sub

Private Sub cmdOK_Click()
    MousePointer = vbHourglass
    ChangeInterfaceIdiom = CodeIdiom(ComboIdiomHelp.Text).Code
    MousePointer = vbArrow
    Unload Me
End Sub

Sub OpenConfig()

    With ConfigLabels
    Caption = App.Title + " - " + .mnConfiguration
    Frame1.Caption = .Config_WebBrowserPath
    Label1.Caption = .Config_InterfaceIdiom
    CmdFind.Caption = .Config_FindPath
    CmdOK.Caption = .ButtonOK
    CmdCan.Caption = .ButtonCancel
    CmdAjuda.Caption = .mnHelp
    End With
    TxtBrowserPath.Text = BrowserPath
    Call FillCombo(ComboIdiomHelp, CodeIdiom)
    ComboIdiomHelp.ListIndex = 0
    
    Show vbModal
End Sub

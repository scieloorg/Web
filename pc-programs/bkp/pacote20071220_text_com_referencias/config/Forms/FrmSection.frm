VERSION 5.00
Begin VB.Form FrmSection 
   Caption         =   "Config - Section's database"
   ClientHeight    =   5460
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7710
   Icon            =   "FrmSection.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5460
   ScaleWidth      =   7710
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame FrameViewSections 
      Caption         =   "To view section's list "
      Height          =   1215
      Index           =   1
      Left            =   240
      TabIndex        =   15
      Top             =   2520
      Width           =   7215
      Begin VB.ListBox ListSection 
         Height          =   645
         Left            =   2160
         TabIndex        =   18
         Top             =   480
         Width           =   4935
      End
      Begin VB.ComboBox ComboIdiom 
         Height          =   315
         Index           =   1
         Left            =   120
         Style           =   2  'Dropdown List
         TabIndex        =   16
         Top             =   480
         Width           =   1935
      End
      Begin VB.Label labListSection 
         AutoSize        =   -1  'True
         Caption         =   "Code and title of the section"
         Height          =   195
         Index           =   1
         Left            =   2160
         TabIndex        =   19
         Top             =   240
         Width           =   1980
      End
      Begin VB.Label LabIdioms 
         AutoSize        =   -1  'True
         Caption         =   "Idiom"
         Height          =   195
         Index           =   1
         Left            =   120
         TabIndex        =   17
         Top             =   240
         Width           =   375
      End
   End
   Begin VB.CommandButton CmdHelp 
      Caption         =   "Help"
      Height          =   375
      Left            =   2520
      TabIndex        =   9
      Top             =   5040
      Width           =   855
   End
   Begin VB.CommandButton CmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   1320
      TabIndex        =   8
      Top             =   5040
      Width           =   855
   End
   Begin VB.CommandButton CmdSave 
      Caption         =   "Save"
      Height          =   375
      Left            =   120
      TabIndex        =   7
      Top             =   5040
      Width           =   855
   End
   Begin VB.Frame FrameSection 
      Caption         =   "Section edition "
      Height          =   4815
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   7455
      Begin VB.Frame FrameRemoveSection 
         Caption         =   "To remove a section from the database "
         Height          =   975
         Index           =   0
         Left            =   120
         TabIndex        =   10
         Top             =   3720
         Width           =   7215
         Begin VB.CommandButton CmdRem 
            Caption         =   "Remove"
            Height          =   375
            Left            =   6360
            TabIndex        =   14
            Top             =   360
            Width           =   735
         End
         Begin VB.ComboBox ComboSection 
            Height          =   315
            Left            =   2160
            Style           =   2  'Dropdown List
            TabIndex        =   13
            Top             =   480
            Width           =   4095
         End
         Begin VB.ComboBox ComboIdiom 
            Height          =   315
            Index           =   2
            Left            =   120
            Style           =   2  'Dropdown List
            TabIndex        =   12
            Top             =   480
            Width           =   1935
         End
         Begin VB.Label labListSection 
            AutoSize        =   -1  'True
            Caption         =   "Code and title of the section"
            Height          =   195
            Index           =   2
            Left            =   2160
            TabIndex        =   23
            Top             =   240
            Width           =   1980
         End
         Begin VB.Label LabIdioms 
            AutoSize        =   -1  'True
            Caption         =   "Idiom"
            Height          =   195
            Index           =   2
            Left            =   120
            TabIndex        =   11
            Top             =   240
            Width           =   375
         End
      End
      Begin VB.Frame FrameAddSection 
         Caption         =   "To add a section in the database "
         Height          =   2055
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Width           =   7215
         Begin VB.ComboBox Combo1 
            Height          =   315
            Left            =   120
            TabIndex        =   27
            Text            =   "ComboCode"
            Top             =   480
            Width           =   1695
         End
         Begin VB.ListBox ListSec 
            Height          =   255
            Index           =   2
            Left            =   240
            TabIndex        =   26
            Top             =   1320
            Visible         =   0   'False
            Width           =   735
         End
         Begin VB.ListBox ListSec 
            Height          =   255
            Index           =   3
            Left            =   240
            TabIndex        =   25
            Top             =   1560
            Visible         =   0   'False
            Width           =   735
         End
         Begin VB.ListBox ListSec 
            Height          =   255
            Index           =   1
            Left            =   240
            TabIndex        =   24
            Top             =   1080
            Visible         =   0   'False
            Width           =   735
         End
         Begin VB.TextBox TxtSecTitle 
            Height          =   285
            Index           =   1
            Left            =   1920
            TabIndex        =   22
            Text            =   "Text3"
            Top             =   480
            Width           =   4335
         End
         Begin VB.TextBox TxtSecTitle 
            Height          =   285
            Index           =   2
            Left            =   1920
            TabIndex        =   21
            Text            =   "Text3"
            Top             =   1080
            Width           =   4335
         End
         Begin VB.TextBox Text3 
            Height          =   285
            Index           =   4
            Left            =   1920
            TabIndex        =   20
            Text            =   "Text3"
            Top             =   1680
            Width           =   4335
         End
         Begin VB.CommandButton CmdAdd 
            Caption         =   "Adiciona"
            Height          =   375
            Left            =   6360
            TabIndex        =   6
            Top             =   1080
            Width           =   735
         End
         Begin VB.Label LabIdiom 
            Caption         =   "Spanish title"
            Height          =   255
            Index           =   3
            Left            =   1920
            TabIndex        =   5
            Top             =   1440
            Width           =   1455
         End
         Begin VB.Label LabIdiom 
            Caption         =   "Portuguese title"
            Height          =   255
            Index           =   2
            Left            =   1920
            TabIndex        =   4
            Top             =   840
            Width           =   1935
         End
         Begin VB.Label LabIdiom 
            Caption         =   "English title"
            Height          =   255
            Index           =   1
            Left            =   1920
            TabIndex        =   3
            Top             =   240
            Width           =   1935
         End
         Begin VB.Label LabSecCode 
            Caption         =   "Section code"
            Height          =   255
            Left            =   120
            TabIndex        =   2
            Top             =   240
            Width           =   1095
         End
      End
   End
End
Attribute VB_Name = "FrmSection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Sub OpenSection()
    With ConfigLabels
    FrameAddSection.Caption = .Sec_FrameAddSection
    FrameViewSections.Caption = .Sec_FrameViewSections
    FrameRemoveSection.Caption = .Sec_FrameRemSection
    LabSecCode.Caption = .Sec_SectionCode
    LabIdiom(1).Caption = .Sec_Idiom
    LabIdiom(2).Caption = .Sec_Idiom
    labListSection(1).Caption = .Sec_SectionTitle
    labListSection(2).Caption = .Sec_SectionTitle
    CmdAdd.Caption = .Sec_CmdADD
    CmdRem.Caption = .Sec_CmdRem
    CmdSave.Caption = .ButtonSave
    CmdCancel.Caption = .ButtonCancel
    CmdHelp.Caption = .mnHelp
    End With
End Sub

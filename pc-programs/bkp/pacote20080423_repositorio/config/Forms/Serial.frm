VERSION 5.00
Begin VB.MDIForm FrmSerial 
   BackColor       =   &H8000000C&
   Caption         =   "MDIForm1"
   ClientHeight    =   4605
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8835
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox Frame4 
      Align           =   1  'Align Top
      BackColor       =   &H00C0C0C0&
      Height          =   1095
      Left            =   0
      ScaleHeight     =   1035
      ScaleWidth      =   8775
      TabIndex        =   0
      Top             =   0
      Width           =   8835
      Begin VB.ComboBox ComboTitle 
         Height          =   315
         Left            =   960
         Sorted          =   -1  'True
         TabIndex        =   3
         Text            =   "Combo1"
         Top             =   240
         Width           =   6735
      End
      Begin VB.TextBox TxtISSN 
         Height          =   285
         Left            =   960
         TabIndex        =   2
         Top             =   600
         Width           =   1935
      End
      Begin VB.CommandButton CmdOpenTitle 
         Caption         =   "Open"
         Height          =   375
         Left            =   7920
         TabIndex        =   1
         Top             =   240
         Width           =   615
      End
      Begin VB.Label LabTitleOpen 
         AutoSize        =   -1  'True
         Caption         =   "Title"
         Height          =   195
         Left            =   240
         TabIndex        =   5
         Top             =   240
         Width           =   300
      End
      Begin VB.Label LabISSNOpen 
         AutoSize        =   -1  'True
         Caption         =   "ISSN"
         Height          =   195
         Left            =   240
         TabIndex        =   4
         Top             =   600
         Width           =   375
      End
   End
End
Attribute VB_Name = "FrmSerial"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub CmdOpenTitle_Click()
    FrmInfo.Show
    FrmSerial2.Show
End Sub

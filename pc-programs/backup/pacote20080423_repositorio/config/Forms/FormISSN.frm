VERSION 5.00
Begin VB.Form FormISSN 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Title and ISSN"
   ClientHeight    =   2025
   ClientLeft      =   1695
   ClientTop       =   2040
   ClientWidth     =   6450
   Icon            =   "FormISSN.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2025
   ScaleWidth      =   6450
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton CmdHelp 
      Caption         =   "Help"
      Height          =   375
      Left            =   4440
      TabIndex        =   5
      Top             =   1560
      Width           =   1935
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   2280
      TabIndex        =   2
      Top             =   1560
      Width           =   2055
   End
   Begin VB.CommandButton Command1 
      Caption         =   "OK"
      Height          =   375
      Left            =   120
      TabIndex        =   1
      Top             =   1560
      Width           =   2055
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Left            =   120
      TabIndex        =   0
      Text            =   "Combo1"
      Top             =   1080
      Width           =   6255
   End
   Begin VB.Label Label2 
      Caption         =   "Other possibility is the data in database are not correct, then click Cancel and correct the wrong data."
      Height          =   435
      Left            =   120
      TabIndex        =   4
      Top             =   480
      Width           =   6315
   End
   Begin VB.Label Label1 
      Caption         =   "Probably the new title and  ISSN are not correct. Choose the correct data and click OK."
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   6255
   End
End
Attribute VB_Name = "FormISSN"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public choice As String

Private Sub CmdHelp_Click()
    Call frmFindBrowser.CallBrowser(FormMenuPrin.DirStruct.Nodes("Help of ISSN").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Help of ISSN").Text)
End Sub

Private Sub Command1_Click()
    choice = Combo1.Text
    Unload Me
End Sub

Private Sub Command2_Click()
    Unload Me
End Sub

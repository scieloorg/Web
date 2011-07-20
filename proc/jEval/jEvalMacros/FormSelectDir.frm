VERSION 5.00
Begin VB.Form FormSelectDir 
   Caption         =   "Select the path"
   ClientHeight    =   8190
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   7395
   LinkTopic       =   "Form1"
   ScaleHeight     =   8190
   ScaleWidth      =   7395
   StartUpPosition =   3  'Windows Default
   Visible         =   0   'False
   Begin VB.CommandButton CommandCancel 
      Caption         =   "Cancel"
      Height          =   495
      Left            =   6120
      TabIndex        =   3
      Top             =   7440
      Width           =   1095
   End
   Begin VB.CommandButton CommandOK 
      Caption         =   "OK"
      Height          =   495
      Left            =   5040
      TabIndex        =   2
      Top             =   7440
      Width           =   975
   End
   Begin VB.DirListBox Dir1 
      Height          =   6390
      Left            =   120
      TabIndex        =   1
      Top             =   840
      Width           =   7095
   End
   Begin VB.DriveListBox Drive1 
      Height          =   315
      Left            =   120
      TabIndex        =   0
      Top             =   360
      Width           =   7095
   End
End
Attribute VB_Name = "FormSelectDir"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public selectedpath As String

Private Sub CommandOK_Click()
    selectedpath = Dir1.Path
    FormSelectDir.Hide
End Sub
Private Sub CommandCancel_Click()
    selectedpath = ""
    FormSelectDir.Hide
End Sub

Private Sub Drive1_Change()
    Dir1.Path = Drive1.Drive
End Sub


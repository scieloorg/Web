VERSION 5.00
Begin VB.Form Section_1 
   Caption         =   "Config - Open Existing Serial"
   ClientHeight    =   5460
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7710
   Icon            =   "FrmSection1.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5460
   ScaleWidth      =   7710
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton CmdNext 
      Caption         =   "Next"
      Height          =   375
      Left            =   6600
      TabIndex        =   3
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   120
      TabIndex        =   2
      Top             =   5040
      Width           =   975
   End
   Begin VB.Frame FrameOpenSerial 
      Caption         =   "Select Serial to Open"
      Height          =   4815
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   7455
      Begin VB.ListBox ListExistingSerial 
         Height          =   4155
         Left            =   120
         Sorted          =   -1  'True
         TabIndex        =   1
         Top             =   360
         Width           =   7215
      End
   End
End
Attribute VB_Name = "Section_1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CmdCancel_Click()
    Unload Me
End Sub

Private Sub CmdNext_Click()
    If Len(ListExistingSerial.Text) > 0 Then
        FrmSection.MyOpenSerial (ListExistingSerial.Text)
    Else
        MsgBox ConfigLabels.Select_to_Open
    End If
End Sub

Sub OpenExistingSerial()
    
    With ConfigLabels
    Caption = "Config - " + .NewSerial
    FrameOpenSerial.Caption = .Select_to_Open
    CmdNext.Caption = .ButtonNext
    CmdCancel.Caption = .ButtonCancel
    End With
    
    Call GetExistingSerials(ListExistingSerial)
    Show 'vbModal
    
End Sub


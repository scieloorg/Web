VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmConv 
   Caption         =   "1.0 - 2.0 - 3.0"
   ClientHeight    =   2850
   ClientLeft      =   45
   ClientTop       =   345
   ClientWidth     =   2115
   OleObjectBlob   =   "frmConv.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "frmConv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Public flagOK As Boolean

Private Sub CommandButton1_Click()
  flagOK = True
  frmConv.Hide
End Sub

Private Sub CommandButton2_Click()
  flagOK = False
  Unload frmConv
End Sub

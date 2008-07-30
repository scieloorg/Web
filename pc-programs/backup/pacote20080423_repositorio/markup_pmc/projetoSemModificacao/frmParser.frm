VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmParser 
   Caption         =   "UserForm1"
   ClientHeight    =   2505
   ClientLeft      =   45
   ClientTop       =   345
   ClientWidth     =   4695
   OleObjectBlob   =   "frmParser.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "frmParser"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Public flagOK As Boolean

Private Sub CB_Cancel_Click()
  flagOK = False
  frmParser.Hide
End Sub

Private Sub CB_OK_Click()
  flagOK = True
  With frmParser
    If .OB_Exit1.value = True Or .OB_EXit2.value = True Or _
       .OB_Exit3.value = True Then
      .Hide
    End If
  End With
End Sub

Private Sub UserForm_Initialize()
  Dim conf As New clsConfig
  '------------------------
  conf.LoadPublicValues
  With frmParser
    .Caption = conf.titlefrmArticle
    .Frame_Exit.Caption = conf.titleFinish
    .OB_Exit1.Caption = conf.msgExit1
    .OB_EXit2.Caption = conf.msgExit2
    .OB_Exit3.Caption = conf.msgExit3
    .CheckBox1.Visible = False
    
    .CB_OK.Caption = conf.textOK
    .CB_Cancel.Caption = conf.textCANCEL
    '-
    .OB_Exit1.value = False
    .OB_EXit2.value = False
    .OB_Exit3.value = False
    
    .CB_Cancel.SetFocus
  End With
  '------------------------
  Set conf = Nothing
End Sub

Private Sub UserForm_Terminate()
  flagOK = False
End Sub

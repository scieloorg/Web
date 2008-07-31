VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmConfig 
   Caption         =   "Markup Configuration"
   ClientHeight    =   2595
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6420
   OleObjectBlob   =   "frmConfig.frx":0000
   StartUpPosition =   1  'CenterOwner
   WhatsThisHelp   =   -1  'True
End
Attribute VB_Name = "frmConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Public flagOK As Boolean
Public language As String
Public responsible As String
Private mErr As New clsErrList
Const errIDObj As String = "003"

Private Sub CommandButton_cancel_Click()
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  frmConfig.Hide
  Unload Me
  frmConfig.flagOK = False
  Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub

Private Sub CommandButton_clear_Click()
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  With frmConfig.TextBox_responsible
    .text = ""
    .SetFocus
  End With
  Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub

Private Sub CommandButton_OK_Click()
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo errLOG
  
  If VerifyFrmConfig = True Then
    SetGlobalValues
    CommandButton_record_Click
    frmConfig.flagOK = True
    frmConfig.Hide
    'Unload Me
  End If
  Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub

Private Sub CommandButton_record_Click()
  Dim f As Integer
  'Const projDir = "C:\Scielo\Bin\Markup\"
  Dim projdir As String
  
  Const defaultFile = "default.mds"
  Const errIDMet As String = "04"
  '-----------------------------
  On Error GoTo errLOG
  projdir = MainModule.MarkupPrg
  
  f = FreeFile
  If VerifyFrmConfig = True Then
    SetGlobalValues
    Open projdir & defaultFile For Output As #f
    Print #f, "language"; ","; language
    Print #f, "responsible"; ","; responsible
    Close #f
  End If
  Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub

Private Sub UserForm_Initialize()
  Dim f As Integer
  'Const projDir = "C:\Scielo\Bin\Markup\"
  Dim projdir As String
  Const defaultFile = "default.mds"
  Const errIDMet As String = "05"
  '-----------------------------
  On Error GoTo errLOG
  
  For Each template In Templates
    If template.Name = "markup.prg" Then
        MainModule.MarkupPrg = template.path & "\"
        'MsgBox MarkupPrg
    End If
  Next
  projdir = MainModule.MarkupPrg
    
  f = FreeFile
  Open projdir & defaultFile For Input As #f
  Input #f, aux, language
  Input #f, aux, responsible
  Close #f
  With frmConfig
    Select Case language
      Case "en"
        .OptionButton_en.value = True
      Case "pt"
        .OptionButton_pt.value = True
      Case "sp"
        .OptionButton_sp.value = True
    End Select
    .TextBox_responsible.text = responsible
  End With
  Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub

Private Sub UserForm_Terminate()
  Const errIDMet As String = "06"
  '-----------------------------
  On Error GoTo errLOG
  
  CommandButton_cancel_Click
  Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub

Public Function VerifyFrmConfig() As Boolean
  Dim conf As New clsConfig
  Const errIDMet As String = "07"
  '-----------------------------
  On Error GoTo errLOG
  
  conf.LoadPublicValues
  VerifyFrmConfig = True
  With frmConfig
    If .OptionButton_en.value = False And _
       .OptionButton_pt.value = False And _
       .OptionButton_sp.value = False Then
      VerifyFrmConfig = False
      MsgBox conf.msgInvalid & " : language", vbCritical, conf.titleConfig
      Exit Function
    ElseIf Len(Trim$(.TextBox_responsible.text)) = 0 Then
      VerifyFrmConfig = False
      MsgBox conf.msgInvalid & " : Markup Responsible", vbCritical, conf.titleConfig
      Exit Function
    End If
  End With
  Set conf = Nothing
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Function

Public Sub SetGlobalValues()
  Const errIDMet As String = "08"
  '-----------------------------
  On Error GoTo errLOG
  
  With frmConfig
    If .OptionButton_en.value = True Then
      language = "en"
    ElseIf .OptionButton_pt.value = True Then
      language = "pt"
    ElseIf .OptionButton_sp.value = True Then
      language = "sp"
    End If
    responsible = .TextBox_responsible.text
  End With
  Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub

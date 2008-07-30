VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsErrList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private ErrList As New collection
'--------------------------
Private mErr As New clsErrList
Const errIDObj As String = "210"

Public Sub LoadErr(conf As clsConfig)
  Dim err As New clsErr, fstring As New clsToken
  Dim line As String, aux As String, f As Integer
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  f = FreeFile
  Open conf.directory & conf.fileErr For Input As #f
  While Not EOF(f)
    Line Input #f, line
    If Len(Trim$(line)) > 0 Then
      With fstring
        .GetTokens line, aux: err.errID = aux
        .GetTokens line, aux: err.errMSG = aux
        .GetTokens line, aux: err.errObjName = aux
        .GetTokens line, aux: err.errMethodName = aux
      End With
      ErrList.add err, err.errID
      Set err = Nothing
    End If
  Wend
  Close #f
  Set err = Nothing: Set fstring = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  '----------------
  Close #f
  Set err = Nothing: Set fstring = Nothing
End Sub

Public Function ReturnErr(k As String) As clsErr
  On Error Resume Next
  k = Trim$(k)
  'If val(k) = 0 Then
    Set ReturnErr = ErrList.Item(k)
    If err.Number <> 0 Then
      ReturnErr = Nothing
    End If
  'Else
  '  Set ReturnErr = ErrList.Item(val(k))
  'End If
End Function

Public Sub LastExit(listbar As clsListBar, m As clsMarkup, conf As clsConfig, listattr As clsAttrList)
  Dim inter As New clsInterface, ret As Integer, Path As String
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  conf.SetLastHour
  m.DisableScreen
  listbar.KillBars
  With CommandBars("Markup")
    .Visible = False
  End With
  inter.EnableWordBars
  With m
    .BuildLog conf, listattr
  End With
  ret = MsgBox(conf.msgMoreLater, vbYesNo + vbQuestion, conf.titleFinish)
  Select Case ret
    Case vbYes
      With m
        .ChangeSTAGO_TAGC conf, listbar
        .EnableScreen
      End With
      'With ActiveDocument
      '  .SaveAs fileformat:=wdFormatText
      '  path = .FullName
      '  .Close
      'End With
      'Documents.Open fileName:=path
    Case vbNo
      ActiveDocument.Save
  End Select
  '------------------
  Set inter = Nothing
  Set conf = Nothing: Set listbar = Nothing: Set m = Nothing
  Set listattr = Nothing: Set listIssue = Nothing
  Set listLink = Nothing: Set bar = Nothing
  End
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set inter = Nothing
  Set conf = Nothing: Set listbar = Nothing: Set m = Nothing
  Set listattr = Nothing: Set listIssue = Nothing
  Set listLink = Nothing: Set bar = Nothing
  End
End Sub

Public Sub BuildLog(Key As String, conf As clsConfig)
  Dim Path As String
  Dim err As New clsErr
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo errLOG
  
  Set err = ReturnErr(Key)
  err.BuildErrLog conf
  err.DisplayErr conf
  Set ErrList = Nothing
  '----------------
  Set err = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set err = Nothing
End Sub

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

Public Sub LoadErr(Conf As clsConfig)
  Dim err As New clsErr, fstring As New clsToken
  Dim Line As String, aux As String, f As Integer
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo ERRLOG
  
  f = FreeFile
  Open Conf.directory & Conf.fileErr For Input As #f
  While Not EOF(f)
    Line Input #f, Line
    If Len(Trim$(Line)) > 0 Then
      With fstring
        .GetTokens Line, aux: err.errID = aux
        .GetTokens Line, aux: err.errMSG = aux
        .GetTokens Line, aux: err.errObjName = aux
        .GetTokens Line, aux: err.errMethodName = aux
      End With
      ErrList.add err, err.errID
      Set err = Nothing
    End If
  Wend
  Close #f
  Set err = Nothing: Set fstring = Nothing
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
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

Public Sub LastExit(listBar As clsListBar, m As clsMarkup, Conf As clsConfig, listattr As clsAttrList)
  Dim inter As New clsInterface, ret As Integer, path As String
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo ERRLOG
  
  Conf.SetLastHour
  m.DisableScreen
  listBar.KillBars
  With CommandBars("Markup")
    .Visible = False
  End With
  inter.EnableWordBars
  With m
    .BuildLog Conf, listattr
  End With
  ret = MsgBox(Conf.msgMoreLater, vbYesNo + vbQuestion, Conf.titleFinish)
  Select Case ret
    Case vbYes
      With m
        .ChangeSTAGO_TAGC Conf, listBar
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
  Set Conf = Nothing: Set listBar = Nothing: Set m = Nothing
  Set listattr = Nothing: Set listIssue = Nothing
  Set listLink = Nothing: Set bar = Nothing
  End
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set inter = Nothing
  Set Conf = Nothing: Set listBar = Nothing: Set m = Nothing
  Set listattr = Nothing: Set listIssue = Nothing
  Set listLink = Nothing: Set bar = Nothing
  End
End Sub

Public Sub BuildLog(Key As String, Conf As clsConfig)
  Dim path As String
  Dim err As New clsErr
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo ERRLOG
  
  Set err = ReturnErr(Key)
  err.BuildErrLog Conf
  err.DisplayErr Conf
  Set ErrList = Nothing
  '----------------
  Set err = Nothing
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set err = Nothing
End Sub

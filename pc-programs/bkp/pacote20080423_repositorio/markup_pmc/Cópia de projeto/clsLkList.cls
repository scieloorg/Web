VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsLkList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private linkList As New collection
'---------------------------------
Private mErr As New clsErrList
Const errIDObj As String = "216"

Public Sub InsertLink(l As clsLink)
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  linkList.add l, l.tagName
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

Public Function ReturnLink(k As String) As clsLink
  On Error Resume Next
  If val(Trim$(k)) = 0 Then
    Set ReturnLink = linkList.Item(k)
    If err.Number <> 0 Then
      ReturnLink = Nothing
    End If
  Else
    Set ReturnLink = linkList.Item(val(Trim$(k)))
  End If
End Function

Public Function ReturnCount() As Integer
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  ReturnCount = linkList.count
  Exit Function
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Function

Public Sub LoadLink(conf As clsConfig)
  Dim l As New clsLink, stg As New clsToken, f As Integer
  Dim token As String, line As String, ok As Boolean
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo errLOG
  
  f = FreeFile
  Open conf.directory & conf.fileLink For Input As #f
  While Not EOF(f)
    Line Input #f, line
    If Len(Trim$(line)) <> 0 Then
      ok = True
      With l
        .tagName = Trim$(line)
        Line Input #f, line
        While ok = True
          ok = stg.GetTokens(line, token)
          .InsertAttr token
        Wend
      End With
      InsertLink l
      Set l = Nothing
    End If
  Wend
  Close #f
  Set l = Nothing
  Set stg = Nothing: Set v = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Close #f
  Set l = Nothing
  Set stg = Nothing: Set v = Nothing
End Sub

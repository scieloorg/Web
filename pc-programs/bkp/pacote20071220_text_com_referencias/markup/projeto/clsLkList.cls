VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsLkList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private linkList As New Collection
'---------------------------------
Private mErr As New clsErrList
Const errIDObj As String = "216"

Public Sub InsertLink(l As clsLink)
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  linkList.Add l, l.tagName
  Exit Sub
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
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
  
  ReturnCount = linkList.Count
  Exit Function
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Function

Public Sub LoadLink(Conf As clsConfig)
  Dim l As New clsLink, stg As New clsToken, F As Integer
  Dim token As String, Line As String, ok As Boolean
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo errLOG
  
  F = FreeFile
  Open Conf.directory & Conf.fileLink For Input As #F
  While Not EOF(F)
    Line Input #F, Line
    If Len(Trim$(Line)) <> 0 Then
      ok = True
      With l
        .tagName = Trim$(Line)
        Line Input #F, Line
        While ok = True
          ok = stg.GetTokens(Line, token)
          .InsertAttr token
        Wend
      End With
      InsertLink l
      Set l = Nothing
    End If
  Wend
  Close #F
  Set l = Nothing
  Set stg = Nothing: Set v = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Close #F
  Set l = Nothing
  Set stg = Nothing: Set v = Nothing
End Sub

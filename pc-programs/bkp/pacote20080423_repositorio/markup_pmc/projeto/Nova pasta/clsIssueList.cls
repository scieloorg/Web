VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsIssueList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private issueList As New collection
'----------------------------------
Private mErr As New clsErrList
Const errIDObj As String = "213"

Public Sub InsertIssue(i As clsIssue)
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  If ExistIssue(i.primaryKey) Is Nothing Then
      issueList.add i, i.primaryKey
  End If
  Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet & i.primaryKey, conf
  End With
  Set conf = Nothing
End Sub

Public Function ReturnIssue(k As String) As clsIssue
  On Error Resume Next
  
  If val(Trim$(k)) = 0 Then
    Set ReturnIssue = issueList.Item(k)
    If err.Number <> 0 Then
        Set ReturnIssue = Nothing
    End If
  Else
    Set ReturnIssue = issueList.Item(val(Trim$(k)))
  End If
End Function

Public Function ExistIssue(v As String) As clsIssue
'  On Error Resume Next
  Dim Item As clsIssue
  Dim i As Long
  Dim found As Boolean
  
    
  Set Item = New clsIssue
  If issueList.count > 0 Then
    Set Item = ReturnIssue(v)
    If Item Is Nothing Then
        While Not found And i < issueList.count
            i = i + 1
            
            found = (StrComp(myReplace(issueList.Item(i).primaryKey, "  ", " "), myReplace(v, "  ", " ")) = 0)
        Wend
        If found Then
            Set Item = issueList.Item(i)
        End If
    End If
  Else
    'MsgBox "issuelist.count=0"
    Set Item = Nothing
  End If
  Set ExistIssue = Item
End Function


Public Function ReturnCount() As Integer
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  ReturnCount = issueList.count
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

Public Sub LoadIssue(conf As clsConfig)
  Dim issue As New clsIssue, v As New clsValue, f As Integer
  Dim line1 As String, line2 As String, ok As Boolean, token1 As String
  Dim stg1 As New clsToken, stg2 As New clsToken, token2 As String
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo errLOG
  
  f = FreeFile
  Open conf.directory & conf.fileIssue For Input As #f
  While Not EOF(f)
    Line Input #f, line1
    If Len(Trim$(line1)) <> 0 Then
      ok = True
      With issue
        'MsgBox "primary=" & line1
        .primaryKey = Trim$(line1)
        Line Input #f, line1
        stg1.GetTokens line1, token1: .stitle = token1
        stg1.GetTokens line1, token1: .volid = token1
        stg1.GetTokens line1, token1: .supplvol = token1
        stg1.GetTokens line1, token1: .issueno = token1
        stg1.GetTokens line1, token1: .supplno = token1
        stg1.GetTokens line1, token1: .dateiso = token1
        stg1.GetTokens line1, token1: .issn = token1
        stg1.GetTokens line1, token1: .status = token1
        Set stg1 = Nothing
        Line Input #f, line1: Line Input #f, line2
        While ok = True
          ok = stg1.GetTokens(line1, token1): v.extValue = token1
          ok = stg2.GetTokens(line2, token2): v.abbrValue = token2
          .InsertSec v
          Set v = Nothing
        Wend
        '----alteracao
        Line Input #f, line1
        ok = True
        While ok = True
            ok = stg1.GetTokens(line1, token1)
            .scheme.add token1
        Wend
        Line Input #f, line1
        ok = True
        While ok = True
            ok = stg1.GetTokens(line1, token1)
            .standard.add token1
        Wend
        '-------------
        InsertIssue issue
        Set issue = Nothing
      End With
    End If
  Wend
  Close #f
  Set issue = Nothing
  Set stg1 = Nothing: Set stg2 = Nothing
  Set v = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Close #f
  Set issue = Nothing
  Set stg1 = Nothing: Set stg2 = Nothing
  Set v = Nothing
End Sub

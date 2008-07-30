VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsAutoMarkupList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private automataList As New collection
'-------------------------------------
Private mErr As New clsErrList
Const errIDObj As String = "205"

Public Sub LoadAutomata(conf As clsConfig)
  Dim automata As New clsAutoMarkup, token As New clsToken
  Dim line As String, aux As String, f As Integer
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  f = FreeFile
  Open conf.directory & conf.fileAutomata For Input As #f
  While Not EOF(f)
    Line Input #f, line
    
    If Len(Trim$(line)) > 0 Then
      With token
        .GetTokens line, aux: automata.stitle = aux
        .GetTokens line, aux: automata.initialTag = aux
        .GetTokens line, aux: automata.automataFile = aux
        .GetTokens line, aux: automata.tagsFile = aux
      End With
      automataList.add automata, automata.stitle
      Set automata = Nothing
    End If
  Wend
  Close #f
  '---------------------
  Set automata = Nothing: Set token = Nothing
  Exit Sub
errLOG:

  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set automata = Nothing: Set token = Nothing
End Sub

Public Function ReturnAutomata(stitle As String) As clsAutoMarkup
  On Error Resume Next
  stitle = Trim$(stitle)
  If val(stitle) = 0 Then
    Set ReturnAutomata = automataList.Item(stitle)
    If err.Number <> 0 Then
      ReturnAutomata = Nothing
    End If
  Else
    Set ReturnAutomata = automataList.Item(val(stitle))
  End If
End Function

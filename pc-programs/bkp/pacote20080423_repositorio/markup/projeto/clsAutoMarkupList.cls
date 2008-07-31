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

Public Sub LoadAutomata(Conf As clsConfig)
  Dim automata As New clsAutoMarkup, token As New clsToken
  Dim Line As String, aux As String, f As Integer
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo ERRLOG
  f = FreeFile
  Open Conf.directory & Conf.fileAutomata For Input As #f
  While Not EOF(f)
    Line Input #f, Line
    
    If Len(Trim$(Line)) > 0 Then
      With token
        .GetTokens Line, aux: automata.stitle = aux
        .GetTokens Line, aux: automata.initialTag = aux
        .GetTokens Line, aux: automata.automataFile = aux
        .GetTokens Line, aux: automata.tagsFile = aux
      End With
      automataList.add automata, automata.stitle
      Set automata = Nothing
    End If
  Wend
  Close #f
  '---------------------
  Set automata = Nothing: Set token = Nothing
  Exit Sub
ERRLOG:

  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
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

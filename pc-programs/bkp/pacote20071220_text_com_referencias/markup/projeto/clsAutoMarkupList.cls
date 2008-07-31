VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsAutoMarkupList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private automataList As New Collection
'-------------------------------------
Private mErr As New clsErrList
Const errIDObj As String = "205"

Public Sub LoadAutomata(Conf As clsConfig)
  Dim automata As New clsAutoMarkup, token As New clsToken
  Dim Line As String, aux As String, F As Integer
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  F = FreeFile
  Open Conf.directory & Conf.fileAutomata For Input As #F
  While Not EOF(F)
    Line Input #F, Line
    
    If Len(Trim$(Line)) > 0 Then
      With token
        .GetTokens Line, aux: automata.stitle = aux
        .GetTokens Line, aux: automata.initialTag = aux
        .GetTokens Line, aux: automata.automataFile = aux
        .GetTokens Line, aux: automata.tagsFile = aux
      End With
      automataList.Add automata, automata.stitle
      Set automata = Nothing
    End If
  Wend
  Close #F
  '---------------------
  Set automata = Nothing: Set token = Nothing
  Exit Sub
errLOG:

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

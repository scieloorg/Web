VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsToken"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private mErr As New clsErrList
Const errIDObj As String = "218"

Public Function GetTokens(s As String, ByRef tk As String) As Boolean
  Dim c As String
  Static iEnd As Integer
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  tk = ""
  While (iEnd <= Len(s) And Len(s) <> 0)
    iEnd = iEnd + 1
    c = Mid(s, iEnd, 1)
    Select Case c
      Case Chr(34)  'aspas
        'nao faz nada
      Case Chr(59)  'ponto e virgula === > antigo 44 -> virgula
        GetTokens = True: Exit Function
      Case Else
        tk = tk & c
    End Select
  Wend
  iEnd = 0
  GetTokens = False
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

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsListBar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private listOfBar As New Collection
Private listOfTag As New Collection
'---------------------------------
Private mErr As New clsErrList
Const errIDObj As String = "215"

Public Function FoundTag(t As String) As Boolean
  Dim tag As String
  '----------------
  On Error Resume Next
  tag = listOfTag.Item(t)
  If err.Number <> 0 Then
    FoundTag = False
  Else
    FoundTag = True
  End If
End Function

Public Sub InsertBar(b As clsBar)
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  listOfBar.Add b, b.GetName
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

Public Function ReturnBar(b As String) As clsBar
  On Error Resume Next
  b = Trim$(b)
  If val(b) = 0 Then
    Set ReturnBar = listOfBar(b)
    If err.Number <> 0 Then
      ReturnBar = Nothing
    End If
  Else
    Set ReturnBar = listOfBar(val(b))
  End If
End Function

Public Function LenListOfBar() As Integer
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  LenListOfBar = listOfBar.Count
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

Public Sub LoadBars(Conf As clsConfig)
  Dim Line As String, token As String, ok As Boolean, iBar As Long
  Dim fstring As New clsToken, button As New clsButton
  Dim bar As New clsBar, F As Integer
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo errLOG
  
  F = FreeFile
  Open Conf.directory & Conf.fileBar For Input As #F
  While Not EOF(F)
    ok = True
    Input #F, Line
    fstring.GetTokens Line, token: bar.SetName (token)
    fstring.GetTokens Line, token: bar.SetUpLevel (token)
    Line Input #F, Line
    While Len(Line) > 0 And ok = True
      fstring.GetTokens Line, token
      If token = LCase("down") Then
        button.SetShortTag (Conf.tooltipsDown)
        fstring.GetTokens Line, token: button.SetDownLevel (token)
      Else
        button.SetTag (token)
        '--cria uma lista das tags existentes na marcacao
        If FoundTag(token) = False Then
          listOfTag.Add token, token
        End If
        '--
        fstring.GetTokens Line, token: button.SetShortTag (token)
        fstring.GetTokens Line, token: button.SetColor (token)
        fstring.GetTokens Line, token: button.SetRepetitive (token)
        fstring.GetTokens Line, token: button.SetAttrib (token)
        fstring.GetTokens Line, token: button.SetDownLevel (token)
      End If
      bar.InsertButton button, Conf
      If Not EOF(F) Then
        Line Input #F, Line
      Else
        ok = False
      End If
      Set button = Nothing
    Wend
    If iBar > 3 Then
      button.SetShortTag (Conf.tooltipsUp): bar.InsertButton button, Conf
      Set button = Nothing
    End If
    InsertBar bar: Set bar = Nothing: iBar = iBar + 1
  Wend
  Close #F
  Set fstring = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Close #F
  Set fstring = Nothing
End Sub

Public Sub CreateBars(Conf As clsConfig)
  Dim cBars As Integer, i As Integer
  Dim cBut As Integer, j As Integer
  Dim bar As New clsBar, but As New clsButton
  Dim b As CommandBarButton
  Const errIDMet As String = "04"
  '-----------------------------
  On Error GoTo errLOG
  
  cBars = LenListOfBar
  For i = 1 To cBars
    Set bar = ReturnBar(str(i)): cBut = bar.LenListOfButton
      CommandBars.Add(Name:=bar.GetName).Visible = False
      CommandBars(bar.GetName).Protection = msoBarNoChangeVisible + msoBarNoCustomize
      For j = 1 To cBut
        CommandBars(bar.GetName).Controls.Add Type:=msoControlButton, Before:=j
        Set b = CommandBars(bar.GetName).Controls.Item(j)
        Set but = bar.ReturnButton(str(j))
        If but.GetShortTag = Conf.tooltipsDown Then
          b.FaceId = 40: b.Style = msoButtonIcon
        ElseIf but.GetShortTag = Conf.tooltipsUp Then
          b.FaceId = 38: b.Style = msoButtonIcon: b.BeginGroup = True
        Else
          b.Caption = but.GetTag: b.Style = msoButtonCaption
        End If
        b.OnAction = Conf.MainModule: b.TooltipText = but.GetShortTag
        b.DescriptionText = bar.GetName
      Next j
      With CommandBars(bar.GetName)
        If .Width > 710 Then
          .Height = 73
        End If
      End With
  Next i
  '----------------------------------
  With CommandBars("Markup").Controls
    .Item(1).TooltipText = Conf.buttonStop
    .Item(2).TooltipText = Conf.buttonChange
    .Item(3).TooltipText = Conf.buttonDelete
    .Item(4).TooltipText = Conf.buttonAutomatic
    .Item(5).TooltipText = Conf.buttonHelp
  End With
  '-----------------------------
  Set bar = Nothing: Set but = Nothing: Set b = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set bar = Nothing: Set but = Nothing: Set b = Nothing
End Sub

Public Sub KillBars()
  Dim cBars As Integer, i As Integer
  Dim bar As New clsBar
  Const errIDMet As String = "05"
  '-----------------------------
  On Error GoTo errLOG
  
  cBars = LenListOfBar
  For i = 1 To cBars
    Set bar = ReturnBar(str(i))
    CommandBars(bar.GetName).Delete
  Next i
  Set bar = Nothing
  Exit Sub
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing: Set bar = Nothing
End Sub

Public Sub EnableBar(b As String)
  Const errIDMet As String = "06"
  '-----------------------------
  On Error GoTo errLOG
  
  CommandBars(b).Visible = True
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

Public Sub DisableBar(b As String)
  Const errIDMet As String = "07"
  '-----------------------------
  On Error GoTo errLOG
  
  CommandBars(b).Visible = False
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

Public Sub MoveBarDefault(b As String)
  Const errIDMet As String = "08"
  '-----------------------------
  On Error GoTo errLOG
  
  CommandBars(b).Position = msoBarBottom
  CommandBars(b).Left = (Application.Width - CommandBars(b).Width) / 2
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

Public Sub MoveBarTop(b As String)
  Const errIDMet As String = "09"
  '-----------------------------
  On Error GoTo errLOG
  
  CommandBars(b).Position = msoBarTop
  CommandBars(b).Left = Application.Width + CommandBars(b).Width
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

Public Sub BuildTempFile()
  Dim i As Long, j As Long, F As Integer
  Dim Path As String
  Const errIDMet As String = "10"
  '-----------------------------
  On Error GoTo errLOG
  
  With ActiveDocument
    Path = Mid$(.FullName, 1, InStr(.FullName, ".")) & "mkt"
  End With
  F = FreeFile
  Open Path For Output As #F
  For i = 1 To LenListOfBar
    Print #F, ReturnBar(str$(i)).GetName
    For j = 1 To ReturnBar(str$(i)).LenListOfButton
      If ReturnBar(str$(i)).ReturnButton(str$(j)).GetTag <> Empty Then
        Print #F, ReturnBar(str$(i)).ReturnButton(str$(j)).GetTag; ";"; ReturnBar(str$(i)).ReturnButton(str$(j)).Count
      End If
    Next j
    Print #F,
  Next i
  Close #F
  Exit Sub
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
  Close #F
End Sub

Public Sub LoadTempFile()
  Dim token As New clsToken, F As Integer, Path As String, aux As String
  Dim b As New clsButton, bar As String, Line As String
  Const errIDMet As String = "11"
  '-----------------------------
  On Error GoTo errLOG
  
  With ActiveDocument
    Path = Mid$(.FullName, 1, InStr(.FullName, ".")) & "mkt"
  End With
  F = FreeFile
  On Error Resume Next
  Open Path For Input As #F
  If err.Number = 0 Then
    On Error GoTo errLOG
    While Not EOF(F)
      Line Input #F, bar
      Do
        Line Input #F, Line
        If Len(Trim$(Line)) > 0 Then
          token.GetTokens Line, aux
          Set b = ReturnBar(bar).ReturnButton(aux)
          token.GetTokens Line, aux
          b.Count = val(aux)
          Set b = Nothing
        End If
      Loop While Len(Trim$(Line)) > 0
    Wend
    Close #F
  End If
  Set token = Nothing: Set b = Nothing
  Exit Sub
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
  Close #F
  Set token = Nothing: Set b = Nothing
End Sub

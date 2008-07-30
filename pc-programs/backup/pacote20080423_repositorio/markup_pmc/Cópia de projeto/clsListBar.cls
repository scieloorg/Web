VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsListBar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private listOfBar As New collection
Private listOfTag As New collection
'---------------------------------
Private mErr As New clsErrList
Const errIDObj As String = "215"

Public Function FoundTag(t As String) As Boolean
  Dim tag As String
  '----------------
  On Error Resume Next
  tag = listOfTag.Item(t)
  If err.Number = 0 Or t = "text-ref" Then
        FoundTag = True
  Else
        FoundTag = False
  End If
End Function

Public Sub InsertBar(b As clsBar)
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  listOfBar.add b, b.GetName
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

Public Function ReturnBar(b As String) As clsBar
  On Error Resume Next
  b = Trim$(b)
  If val(b) = 0 Then
    Set ReturnBar = listOfBar(b)
    If err.Number <> 0 Then
      Set ReturnBar = Nothing
    End If
  Else
    Set ReturnBar = listOfBar(val(b))
  End If
End Function

Public Function LenListOfBar() As Integer
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  LenListOfBar = listOfBar.count
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

Public Sub LoadBars(conf As clsConfig)
  Dim line As String, token As String, ok As Boolean, iBar As Long
  Dim fstring As New clsToken, button As New clsButton
  Dim bar As New clsBar, f As Integer
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo errLOG
  
  f = FreeFile
  Open conf.directory & conf.fileBar For Input As #f
  While Not EOF(f)
    ok = True
    Input #f, line
    fstring.GetTokens line, token: bar.SetName (token)
    fstring.GetTokens line, token: bar.SetUpLevel (token)
    Line Input #f, line
    While Len(line) > 0 And ok = True
      fstring.GetTokens line, token
      If token = LCase("down") Then
        button.SetShortTag (conf.tooltipsDown)
        fstring.GetTokens line, token: button.SetDownLevel (token)
      Else
        button.SetTag (token)
        '--cria uma lista das tags existentes na marcacao
        If FoundTag(token) = False Then
          listOfTag.add token, token
        End If
        '--
        fstring.GetTokens line, token: button.SetShortTag (token)
        fstring.GetTokens line, token: button.SetColor (token)
        fstring.GetTokens line, token: button.SetRepetitive (token)
        fstring.GetTokens line, token: button.SetAttrib (token)
        fstring.GetTokens line, token: button.SetDownLevel (token)
      End If
      bar.InsertButton button, conf
      If Not EOF(f) Then
        Line Input #f, line
      Else
        ok = False
      End If
      Set button = Nothing
    Wend
    If iBar > 3 Then
      button.SetShortTag (conf.tooltipsUp): bar.InsertButton button, conf
      Set button = Nothing
    End If
    InsertBar bar: Set bar = Nothing: iBar = iBar + 1
  Wend
  Close #f
  Set fstring = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Close #f
  Set fstring = Nothing
End Sub

Public Sub CreateBars(conf As clsConfig)
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
      CommandBars.add(Name:=bar.GetName).Visible = False
      CommandBars(bar.GetName).Protection = msoBarNoChangeVisible + msoBarNoCustomize
      For j = 1 To cBut
        CommandBars(bar.GetName).Controls.add Type:=msoControlButton, Before:=j
        Set b = CommandBars(bar.GetName).Controls.Item(j)
        Set but = bar.ReturnButton(str(j))
        If but.GetShortTag = conf.tooltipsDown Then
          b.FaceId = 40: b.Style = msoButtonIcon
        ElseIf but.GetShortTag = conf.tooltipsUp Then
          b.FaceId = 38: b.Style = msoButtonIcon: b.BeginGroup = True
        Else
          b.Caption = but.GetTag: b.Style = msoButtonCaption
        End If
        b.OnAction = conf.MainModule: b.TooltipText = but.GetShortTag
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
    .Item(1).TooltipText = conf.buttonStop
    .Item(2).TooltipText = conf.buttonChange
    .Item(3).TooltipText = conf.buttonDelete
    .Item(4).TooltipText = conf.buttonAutomatic
    .Item(5).TooltipText = conf.buttonAutomaticWS
      .Item(6).TooltipText = conf.buttonSave
      .Item(7).TooltipText = conf.buttonParser
      .Item(8).TooltipText = conf.buttonGenerateXML
      .Item(9).TooltipText = conf.buttonCheckXML
      .Item(10).TooltipText = conf.buttonViewMarkup
      .Item(11).TooltipText = conf.buttonHelp
      
      
  End With
  '-----------------------------
  Set bar = Nothing: Set but = Nothing: Set b = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
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
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing: Set bar = Nothing
End Sub

Public Sub EnableBar(b As String)
  Const errIDMet As String = "06"
  '-----------------------------
  On Error GoTo errLOG
  
  CommandBars(b).Visible = True
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

Public Sub DisableBar(b As String)
  Const errIDMet As String = "07"
  '-----------------------------
  On Error GoTo errLOG
  
  CommandBars(b).Visible = False
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

Public Sub MoveBarDefault(b As String)
  Const errIDMet As String = "08"
  '-----------------------------
  On Error GoTo errLOG
  
  CommandBars(b).Position = msoBarBottom
  CommandBars(b).Left = (Application.Width - CommandBars(b).Width) / 2
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

Public Sub MoveBarTop(b As String)
  Const errIDMet As String = "09"
  '-----------------------------
  On Error GoTo errLOG
  
  CommandBars(b).Position = msoBarTop
  CommandBars(b).Left = Application.Width + CommandBars(b).Width
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

Public Sub BuildTempFile()
  Dim i As Long, j As Long, f As Integer
  Dim Path As String
  Const errIDMet As String = "10"
  '-----------------------------
  On Error GoTo errLOG
  
  With ActiveDocument
    Path = Mid$(.FullName, 1, InStr(.FullName, ".")) & "mkt"
  End With
  f = FreeFile
  Open Path For Output As #f
  For i = 1 To LenListOfBar
    Print #f, ReturnBar(str$(i)).GetName
    For j = 1 To ReturnBar(str$(i)).LenListOfButton
      If ReturnBar(str$(i)).ReturnButton(str$(j)).GetTag <> Empty Then
        Print #f, ReturnBar(str$(i)).ReturnButton(str$(j)).GetTag; ";"; ReturnBar(str$(i)).ReturnButton(str$(j)).count
      End If
    Next j
    Print #f,
  Next i
  Close #f
  Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
  Close #f
End Sub

Public Sub LoadTempFile()
  Dim token As New clsToken, f As Integer, Path As String, aux As String
  Dim b As New clsButton, bar As String, line As String
  Const errIDMet As String = "11"
  '-----------------------------
  On Error GoTo errLOG
  
  With ActiveDocument
    Path = Mid$(.FullName, 1, InStr(.FullName, ".")) & "mkt"
  End With
  f = FreeFile
  On Error Resume Next
  Open Path For Input As #f
  If err.Number = 0 Then
    On Error GoTo errLOG
    While Not EOF(f)
      Line Input #f, bar
      Do
        Line Input #f, line
        If Len(Trim$(line)) > 0 Then
          token.GetTokens line, aux
          Set b = ReturnBar(bar).ReturnButton(aux)
          token.GetTokens line, aux
          b.count = val(aux)
          Set b = Nothing
        End If
      Loop While Len(Trim$(line)) > 0
    Wend
    Close #f
  End If
  Set token = Nothing: Set b = Nothing
  Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
  Close #f
  Set token = Nothing: Set b = Nothing
End Sub

Sub getJournalStandard(conf As clsConfig, standard As String, standard_barName As String, standard_tagName As String, ref_barName As String, ref_tagName As String)
  '-----------------------------
  Dim j As Long
  Dim RefButtonBar As clsBar, RefButton As clsButton
  
    Set RefButtonBar = New clsBar
    Set RefButton = New clsButton
    

  
    For j = 1 To LenListOfBar
        Set RefButtonBar = ReturnBar(str$(j))
        If RefButtonBar Is Nothing Then
        Else
            Set RefButton = RefButtonBar.ReturnButton(standard)
            If RefButton Is Nothing Then
                
            Else
                If RefButton.GetTag <> Empty Then
                  Exit For
                End If
            End If
        End If
    Next j
    standard_barName = ReturnBar(RefButtonBar.getUpLevel).GetName ' back
    standard_tagName = RefButtonBar.GetName ' vancouv
    ref_barName = RefButtonBar.GetName ' vancouv
    ref_tagName = RefButton.GetTag ' vcitat
End Sub

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsMarkupRange"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private mErr As New clsErrList
Const errIDObj As String = "400"
Private temp1 As String
Private temp2 As String

Private mvarconf As New clsConfig
Private mvarMyRange As range
Private mvarListBar As New clsListBar

Property Get listbar() As clsListBar
    Set listbar = mvarListBar
End Property

Property Set listbar(v As clsListBar)
    Set mvarListBar = v
End Property
Public Property Set MyRange(v As range)
    Set mvarMyRange = v
End Property
Public Property Get MyRange() As range
    Set MyRange = mvarMyRange
End Property

Public Property Set conf(v As clsConfig)
    Set mvarconf = v
End Property
Public Property Get conf() As clsConfig
    Set conf = mvarconf
End Property

'inuse
Public Function InsertTag(doc As range, tag As String, colorI As Long, attributes As String, Optional attl As clsAttrList, Optional linkl As clsLkList, Optional inter As clsInterface, Optional button As clsButton) As Boolean
  Dim sTag As String, fTag As String
  Dim range As range
  Dim pEnd As Long
  
  
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG

  If doc.start < doc.End - 1 Then

  With doc
  temp = "1"
    sTag = BuildStartTag(tag, attributes, attl, linkl, inter)
  temp = "2"
    fTag = BuildFinishTag(tag)
  temp = "3"
   
    If tag = "p" Then
  temp = "4"
        doc.End = doc.End - 1
    End If
    'If tag = "table" Then
    '    doc.start = doc.start - 1
    '    doc.End = doc.End + 1
    'End If
temp = "5 " & CStr(doc.start) & " " & CStr(doc.End)
      
    .InsertBefore sTag
temp = "6"
    .InsertAfter fTag
temp = "7"
    pEnd = .End
temp = "8"
    
    Call .SetRange(.start, .start + Len(sTag))
temp = "9"
    
    FormatText doc, colorI
temp = "10"
    
    Call .SetRange(pEnd - Len(fTag), pEnd)
temp = "11"
    
    FormatText doc, colorI
temp = "12"
    
  End With
  End If
  Exit Function
errLOG:

MsgBox err.Description & " " & temp

  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

'in use
Public Sub FormatText(txt As range, color As Long)
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo errLOG
  
  Dim c As Long
  
  c = color
  
  With txt.font
    .AllCaps = False
    .Animation = wdAnimationNone
    .Bold = True
    .ColorIndex = c
    .DoubleStrikeThrough = False
    .Emboss = False
    .Engrave = False
    .Hidden = False
    .Italic = False
    .Name = "Verdana"
    .Outline = False
    .Shadow = False
    .Size = 9
    .SmallCaps = False
    .StrikeThrough = False
    .Subscript = False
    .Superscript = False
    .Underline = wdUnderlineNone
  End With
  Exit Sub
errLOG:
  
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub
'inuse
Public Function BuildStartTag(tag As String, attributes As String, Optional attl As clsAttrList, Optional linkl As clsLkList, Optional inter As clsInterface) As String
  Dim StartTag As String  'STAGO + TAG + ATTR + TAGC
  Dim l As New clsLink, at As New clsAttribute, i As Integer
  Dim fpage As String, lpage As String, pages As String
  Dim posHif As Integer, posVirg As Integer, posAux As Integer
  Dim listPeriod As New collection
  Const errIDMet As String = "04"
  '-----------------------------
  On Error GoTo errLOG
  
  StartTag = conf.STAGO & tag & Space(1)
  Select Case tag
    Case "article", "text", "translat"
      
      
    Case Else
      If linkl Is Nothing Then
      
      Else
        Set l = linkl.ReturnLink(tag)
        If l.tagName <> Empty Then
          With l
            For i = 1 To .ReturnCount
              Set at = attl.ReturnAttr(.ReturnAttr(str$(i)))
              With inter
                  If Trim$(.attrib(i)) <> Empty And Len(Trim$(.attrib(i))) <> 0 Then
                      StartTag = StartTag & at.attrName & "="
                      StartTag = StartTag & .attrib(i) & Space(1)
                  End If
              End With
            Next i
          End With
        End If
    End If

End Select
  StartTag = Trim$(StartTag)
  If Len(attributes) > 0 Then StartTag = Trim$(StartTag) & " " & attributes
  StartTag = StartTag & conf.TAGC: StartTag = Trim$(StartTag)

  BuildStartTag = StartTag
  
  Set l = Nothing: Set at = Nothing: Set listPeriod = Nothing
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set l = Nothing: Set at = Nothing: Set listPeriod = Nothing
End Function
'inuse
Public Function BuildFinishTag(tag As String) As String
  Dim finishTag As String
  Const errIDMet As String = "05"
  '-----------------------------
  On Error GoTo errLOG
  
  Select Case tag
    Case "head", "dperiod", "deposit"
      'empty tag
    Case Else
      With conf
        finishTag = finishTag & .ETAGO & tag & .TAGC
      End With
  End Select
  BuildFinishTag = finishTag
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function


Public Function CheckInsertTag(range As range, tag As String) As Boolean
    Dim p As Long
    Dim r As Boolean
    Dim originalStart As Long, originalEnd As Long
    
    p = range.start
    originalStart = range.start
    originalEnd = range.End
    
    Call range.SetRange(p - 1, 1)
    If range.text <> conf.TAGC Then
        r = True
    Else
        p = p - 1
        Call range.SetRange(p, 1)
        While p > 0 And range.text <> conf.STAGO
            p = p - 1
            Call range.SetRange(p, 1)
        Wend
        If p > 0 And range.text = conf.STAGO Then
        
        MsgBox range.text
            Call range.SetRange(p + 1, p + Len(tag))
            If range.text <> tag Then
                r = True
            End If
        End If
    End If
    Call range.SetRange(originalStart, originalEnd)
    CheckInsertTag = r
End Function

Public Function VerifyInsertInto(listbar As clsListBar) As Boolean
  Const MAXCH As Integer = 300
  Dim count As Integer, iSTAGO As Long, iSTAGOBKP As Long
  Dim iRange As Long, fRange As Long
  Dim okSTAGO As Boolean, okTAGC As Boolean, text As String, continue As Boolean
  '-----------------
  On Error Resume Next
  okSTAGO = True: okTAGC = True: continue = False: count = 0
  With selection
    iRange = .start: fRange = .End
  End With
  While okSTAGO = True And continue = False And count <= MAXCH
    With ActiveDocument
      text = .range(start:=iRange - 1, End:=iRange)
      If err.Number <> 0 Then
        continue = True
      Else
        Select Case text
          Case conf.STAGO
            okSTAGO = False
          Case conf.TAGC
            continue = True
          Case conf.slash
            okSTAGO = False
          Case Else
            iRange = iRange - 1
        End Select
      End If
    End With
    count = count + 1
  Wend
  continue = False: count = 0
  While okTAGC = True And continue = False And count <= MAXCH
    With ActiveDocument
      text = .range(start:=fRange, End:=fRange + 1)
      If err.Number <> 0 Then
        continue = True
      Else
        Select Case text
          Case conf.STAGO
            continue = True
          Case conf.TAGC
            okTAGC = False
          Case conf.slash
            okTAGC = False
          Case Else
            fRange = fRange + 1
        End Select
      End If
    End With
    count = count + 1
  Wend
  If okTAGC = False Or okSTAGO = False Then
    text = ActiveDocument.range(start:=iRange, End:=fRange).text
    If okSTAGO = False And okTAGC = True Then
      text = Mid$(text, 1, InStr(text, conf.TAGC) - 1)
      If InStr(text, Space(1)) <> 0 Then
        text = Mid$(text, 1, InStr(text, Space(1)) - 1)
      End If
      If listbar.FoundTag(text) = True Then
        VerifyInsertInto = False
      Else
        VerifyInsertInto = True
      End If
    End If
    If okTAGC = False And okSTAGO = True Then
      iSTAGO = 1
      Do
        iSTAGOBKP = iSTAGO
        iSTAGO = InStr(iSTAGO + 1, text, conf.STAGO)
      Loop While iSTAGO <> 0
      text = Mid$(text, iSTAGOBKP + 1, Len(text) - InStr(text, conf.STAGO))
      If Mid$(text, 1, 1) = conf.slash Then
        text = Mid$(text, 2)
      End If
      If InStr(text, Space(1)) <> 0 Then
        text = Mid$(text, 1, InStr(text, Space(1)) - 1)
      End If
      If listbar.FoundTag(text) = True Then
        VerifyInsertInto = False
      Else
        VerifyInsertInto = True
      End If
    End If
    If okSTAGO = False And okTAGC = False Then
      iSTAGO = 1
      Do
        iSTAGOBKP = iSTAGO
        iSTAGO = InStr(iSTAGO + 1, text, conf.STAGO)
      Loop While iSTAGO <> 0
      If iSTAGOBKP <> 1 Then
        text = Mid$(text, iSTAGOBKP + 1, Len(text) - InStr(text, conf.STAGO))
      End If
      If Mid$(text, 1, 1) = conf.slash Then
        text = Mid$(text, 2)
      End If
      If InStr(text, Space(1)) <> 0 Then
        text = Mid$(text, 1, InStr(text, Space(1)) - 1)
      End If
      If listbar.FoundTag(text) = True Then
        VerifyInsertInto = False
      Else
        VerifyInsertInto = True
      End If
    End If
  Else
    VerifyInsertInto = True
  End If
  If VerifyInsertInto = False Then
    With selection
      .End = .start
    End With
  End If
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Public Function VerifyHierarchy(listbar As clsListBar, currentBar As String, tag As String) As Boolean
  Dim iRange As Long, fRange As Long, start As Boolean
  Dim previousText As String, nextText As String
  Dim bar As New clsBar, button As New clsButton
  Dim ok1 As Boolean, ok2 As Boolean
  Const errIDMet As String = "09"
  '-----------------------------
  On Error GoTo errLOG
  
  ok1 = True: ok2 = True
  Set bar = listbar.ReturnBar(currentBar)
  '--------------------
  If currentBar = "start" Then 'Or currentBar = "ifloat" Then
    VerifyHierarchy = True: Exit Function
  End If
  
  With selection
    iRange = .start: fRange = .End
  End With
  If TestExistTag(listbar) = True Then
    With selection
      .start = iRange: .End = iRange
    End With
    If currentBar = "ifloat" Then
      If TestExistFloat(listbar, bar, currentBar, tag) = True Then
        ok1 = True: ok2 = True
      Else
        ok1 = False: ok2 = False
      End If
    Else
      With selection
        .start = iRange: .End = iRange
      End With
      If FindTag(listbar, False, start, previousText) = True Then
        If start = True Then
          If TestFatherTag(listbar, previousText, tag, bar) = False Then
            ok1 = False
          End If
        Else
          If TestOwnSisterTag(listbar, previousText, tag, bar, False) = False Then
            ok1 = False
          End If
        End If
        With selection
          .start = fRange: .End = fRange
        End With
        If FindTag(listbar, True, start, nextText) = True Then
          If start = True Then
            If TestOwnSisterTag(listbar, nextText, tag, bar, True) = False Then
              ok2 = False
            End If
          Else
            If TestFatherTag(listbar, nextText, tag, bar) = False Then
              ok2 = False
            End If
          End If
        Else
          ok2 = False
        End If
      Else
        ok1 = False
      End If
    End If
  Else
    ok1 = False: ok2 = False
  End If
  If ok1 = False Or ok2 = False Then
    With selection
      .start = iRange: .End = iRange
    End With
    VerifyHierarchy = False
  Else
    With selection
      .start = iRange: .End = fRange
    End With
    VerifyHierarchy = True
  End If
  
  '-----------------
  Set bar = Nothing: Set button = Nothing
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  
  '-----------------
  Set bar = Nothing: Set button = Nothing
End Function


Public Sub ChangeSTAGO_TAGC(listbar As clsListBar)
  Dim ok As Boolean, slash As Boolean, okFind As Boolean
  Dim iFind As Long, fFind As Long, text As String
  Const errIDMet As String = "15"
  '-----------------------------
  On Error GoTo errLOG
  
  ActiveWindow.DisplayVerticalScrollBar = False
  With selection
    .start = 0: .End = 0
  End With
  ok = True
  While ok = True
    okFind = False
    selection.find.ClearFormatting
    With selection.find
      .text = conf.STAGO: .Replacement.text = "": .forward = True
      .Wrap = wdFindStop: .Format = False: .MatchCase = False
      .MatchWholeWord = False: .MatchWildcards = False
      .MatchSoundsLike = False: .MatchAllWordForms = False
    End With
    selection.find.Execute
    If selection.find.found = True Then
      iFind = selection.End
      text = ActiveDocument.range(start:=iFind, End:=iFind + 1).text
      Select Case text
        Case conf.slash
          slash = True: iFind = iFind + 1
        Case Else
          slash = False
      End Select
      With selection
        .start = .End
      End With
      selection.find.ClearFormatting
      With selection.find
        .text = conf.TAGC: .Replacement.text = "": .forward = True
        .Wrap = wdFindStop: .Format = False: .MatchCase = False
        .MatchWholeWord = False: .MatchWildcards = False
        .MatchSoundsLike = False: .MatchAllWordForms = False
      End With
      selection.find.Execute
      If selection.find.found = True Then
        fFind = selection.start
        Select Case slash
          Case True
            text = ActiveDocument.range(start:=iFind, End:=fFind).text
            If listbar.FoundTag(text) = False Then
              With ActiveDocument
                If InStr(.range(start:=iFind, End:=fFind).text, conf.STAGO) = 0 Then
                  .range(start:=fFind, End:=fFind + 1).text = conf.entityTAGC
                End If
                .range(start:=iFind - 1, End:=iFind).text = conf.entitySTAGO
                okFind = True
              End With
            End If
          Case False
            With ActiveDocument
              If InStr(.range(start:=iFind, End:=fFind).text, Space(1)) <> 0 Then
                text = Mid$(.range(start:=iFind, End:=fFind).text, 1, InStr(.range(start:=iFind, End:=fFind).text, Space(1)) - 1)
                If listbar.FoundTag(text) = False Then
                  With ActiveDocument
                    If InStr(.range(start:=iFind, End:=fFind).text, conf.STAGO) = 0 Then
                      .range(start:=fFind, End:=fFind + 1).text = conf.entityTAGC
                    End If
                    .range(start:=iFind - 1, End:=iFind).text = conf.entitySTAGO
                    okFind = True
                  End With
                End If
              Else
                text = ActiveDocument.range(start:=iFind, End:=fFind).text
                If listbar.FoundTag(text) = False Then
                  With ActiveDocument
                    If InStr(.range(start:=iFind, End:=fFind).text, conf.STAGO) = 0 Then
                      .range(start:=fFind, End:=fFind + 1).text = conf.entityTAGC
                    End If
                    .range(start:=iFind - 1, End:=iFind).text = conf.entitySTAGO
                    okFind = True
                  End With
                End If
              End If
            End With
        End Select
        With selection
          If okFind = False Then
            .start = .End
          Else
            .start = iFind: .End = iFind
          End If
        End With
      Else
        ok = False
      End If
    Else
      ok = False
    End If
  Wend
  ok = True
  While ok = True
    okFind = False
    selection.find.ClearFormatting
    With selection.find
      .text = conf.TAGC: .Replacement.text = "": .forward = False
      .Wrap = wdFindStop: .Format = False: .MatchCase = False
      .MatchWholeWord = False: .MatchWildcards = False
      .MatchSoundsLike = False: .MatchAllWordForms = False
    End With
    selection.find.Execute
    If selection.find.found = True Then
      fFind = selection.start
      With selection
        .start = .End
      End With
      selection.find.ClearFormatting
      With selection.find
        .text = conf.STAGO: .Replacement.text = "": .forward = False
        .Wrap = wdFindStop: .Format = False: .MatchCase = False
        .MatchWholeWord = False: .MatchWildcards = False
        .MatchSoundsLike = False: .MatchAllWordForms = False
      End With
      selection.find.Execute
      If selection.find.found = True Then
        iFind = selection.End
        text = ActiveDocument.range(start:=iFind, End:=iFind + 1).text
        Select Case text
          Case conf.slash
            slash = True: iFind = iFind + 1
          Case Else
            slash = False
        End Select
        Select Case slash
          Case True
            text = ActiveDocument.range(start:=iFind, End:=fFind).text
            If listbar.FoundTag(text) = False Then
              With ActiveDocument
                If InStr(.range(start:=iFind, End:=fFind).text, conf.TAGC) <> 0 Then
                  .range(start:=fFind, End:=fFind + 1).text = conf.entityTAGC
                End If
                okFind = True
              End With
            End If
          Case False
            With ActiveDocument
              With ActiveDocument
                If InStr(.range(start:=iFind, End:=fFind).text, conf.TAGC) <> 0 Then
                  .range(start:=fFind, End:=fFind + 1).text = conf.entityTAGC
                End If
                okFind = True
              End With
            End With
        End Select
        With selection
          If okFind = False Then
            .start = .End
          Else
            .start = fFind: .End = fFind
          End If
        End With
      Else
        ok = False
      End If
    Else
      ok = False
    End If
  Wend
  ActiveWindow.DisplayVerticalScrollBar = True
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Sub

Public Sub ChangeFields()
  Const errIDMet As String = "16"
  '-----------------------------
  On Error GoTo errLOG
  
  If ActiveWindow.ActivePane.View.ShowAll = False Then
    ActiveWindow.ActivePane.View.ShowAll = True
  End If
  selection.find.ClearFormatting
  selection.find.Replacement.ClearFormatting
  With selection.find
    .text = "^d"      'fields
    .Replacement.text = ""
    .forward = True
    .Wrap = wdFindContinue
    .Format = False
    .MatchCase = False
    .MatchWholeWord = False
    .MatchWildcards = False
    .MatchSoundsLike = False
    .MatchAllWordForms = False
  End With
  selection.find.Execute replace:=wdReplaceAll
  ActiveWindow.ActivePane.View.ShowAll = False
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  ActiveWindow.ActivePane.View.ShowAll = False
End Sub


Public Sub ChangeEntity()
'opcao = 0  -> troca colchetes por entidade
'opcao = 1  -> troca entidade por colchetes
  Dim texto As range
  Dim dash(1) As String
  Dim i As Integer
  Const errIDMet As String = "18"
  '-----------------------------
  On Error GoTo errLOG
  
  dash(0) = "^+": dash(1) = "^="
  '0 - em dash | 1 - en dash
  '----------------------------------------------
  'esta macro tem por finalidade trocar os caracteres '[' ']'
  'por entidades, afim de evitar problemas com os delimitadore
  'da tag da marcacao.
  'nessa funcao, troca-se en dash e em dash por hifen, tb.
  Set texto = ActiveDocument.content
  For i = 0 To 1
    With texto
      .find.Execute findText:=dash(i), replacewith:="-", replace:=wdReplaceAll
      'troca en dash e em dash por hifen
    End With
  Next i
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Sub

Public Function FindTag(listbar As clsListBar, forward As Boolean, start As Boolean, tag As String, Optional sX As Long, Optional fX As Long) As Boolean
  Dim iFind As Long, fFind As Long, pos As Integer, ok As Boolean
  Dim a As Long, b As Long
  
  Const errIDMet As String = "19"
  '-----------------------------
  On Error GoTo errLOG
  '-------------------
  FindTag = True: ok = False
  While ok = False
    Select Case forward
      Case True
        If findText(mvarconf.STAGO, forward, a, b) = True Then
          With ActiveDocument
            iFind = selection.End
            If .range(start:=iFind, End:=iFind + 1).text = conf.slash Then
              iFind = selection.End + 1
              start = False
            Else
              start = True
            End If
            With selection
              .start = .End
            End With
            If findText(conf.TAGC, forward, a, b) = True Then
              fFind = selection.start
            Else
              FindTag = False: ok = True
            End If
          End With
          With selection
            .start = .End
          End With
        Else
          FindTag = False: ok = True
        End If
      Case False
        If findText(conf.TAGC, forward, a, b) = True Then
          fFind = selection.start
          With selection
            .End = .start
          End With
          If findText(conf.STAGO, forward, a, b) = True Then
            With ActiveDocument
              iFind = selection.End
              If .range(start:=iFind, End:=iFind + 1).text = conf.slash Then
                iFind = selection.End + 1
                start = False
              Else
                start = True
              End If
              With selection
                .End = .start
              End With
            End With
          Else
            FindTag = False: ok = True
          End If
        Else
          FindTag = False: ok = True
        End If
    End Select
    If ok = False Then
      With ActiveDocument
        pos = InStr(.range(start:=iFind, End:=fFind).text, Space(1))
        sX = iFind
        If pos <> 0 Then
          tag = .range(start:=iFind, End:=iFind + pos - 1).text
          fX = iFind + pos - 1
        Else
          tag = .range(start:=iFind, End:=fFind).text
          fX = fFind
        End If
        If listbar.FoundTag(tag) = True Then
          ok = True
        Else
          With selection
            Select Case forward
              Case True
                .start = iFind: .End = iFind
              Case False
                .start = fFind: .End = fFind
            End Select
          End With
        End If
      End With
    End If
  Wend
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function
' in use
Public Function findText(t As String, f As Boolean, Optional ByRef sPos As Long, Optional ByRef fPos As Long) As Boolean
  Const errIDMet As String = "20"
  '-----------------------------
  On Error GoTo errLOG
  
  'MsgBox "findText antes (s,e) = " & CStr(MyRange.start) & " " & CStr(MyRange.End)
  
  findText = False
  With MyRange.find
    .text = t: .Replacement.text = "": .forward = f
    .Wrap = wdFindStop: .Format = False: .MatchCase = False
    .MatchWholeWord = False: .MatchWildcards = False
    .MatchSoundsLike = False: .MatchAllWordForms = False
  End With
  
  MyRange.find.Execute
  If MyRange.find.found = True Then
    With MyRange
      sPos = .start: fPos = .End
  'MsgBox "found depois (s,e) = " & CStr(MyRange.start) & " " & CStr(MyRange.End) & " " & MyRange.text
    
    End With
    findText = True
  End If
  Exit Function
errLOG:
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Function

Public Function TestExistTag(listbar As clsListBar) As Boolean
  Dim finishPos As Long, tag As String, start As Boolean
  Dim button As New clsButton, pilha As New collection
  Const errIDMet As String = "21"
  '-----------------------------
  On Error GoTo errLOG
  
  TestExistTag = True
  With selection
    finishPos = .End
    .End = .start
  End With
  While selection.End <= finishPos
    If FindTag(listbar, True, start, tag) = True Then
      If selection.End <= finishPos Then
        If start = True Then
          If listbar.FoundTag(tag) = True Then
            Set button = listbar.ReturnBar("ifloat").ReturnButton(tag)
            If button.GetTag = Empty Then
              If pilha.count = 0 Then
                TestExistTag = False: Exit Function
              End If
            Else
              pilha.add button
            End If
          End If
        Else
          If listbar.FoundTag(tag) = True Then
            Set button = listbar.ReturnBar("ifloat").ReturnButton(tag)
            If button.GetTag = Empty Then
              If pilha.count = 0 Then
                TestExistTag = False: Exit Function
              End If
            Else
              With pilha
                Set button = .Item(.count)
                If button.GetTag = tag Then
                  .remove .count
                End If
              End With
            End If
          End If
        End If
      Else
        If pilha.count > 0 Then
          TestExistTag = False
        End If
      End If
    Else
      TestExistTag = False: finishPos = -1
    End If
  Wend
  Set button = Nothing: Set pilha = Nothing
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set button = Nothing: Set pilha = Nothing
End Function

Public Function TestExistFloat(listbar As clsListBar, bar As clsBar, currentBar As String, tagInsert As String) As Boolean
  Dim button As New clsButton, tag As String, start As Boolean
  Dim barAux As New clsBar, pilha As New collection
  Dim i As Integer
  Const errIDMet As String = "22"
  '-----------------------------
  On Error GoTo errLOG
  
  TestExistFloat = True
  Set barAux = bar: pilha.add barAux
  If FindTag(listbar, False, start, tag) = True Then
    If start = True Then
      With pilha
        While .count > 0
          Set barAux = .Item(.count): .remove (.count)
          Set button = barAux.ReturnButton(tag)
          If button.GetTag = Empty Then
            For i = 1 To barAux.LenListOfButton
              Set button = barAux.ReturnButton(str$(i))
              If button.GetDownLevel <> Empty Then
                pilha.add listbar.ReturnBar(button.GetDownLevel)
              End If
            Next i
          Else
            TestExistFloat = False
          End If
        Wend
      End With
    Else
      Set button = barAux.ReturnButton(tag)
      If button.GetTag = Empty Then
        With pilha
          While .count > 0
            Set barAux = .Item(.count): .remove (.count)
            Set button = barAux.ReturnButton(tag)
            If button.GetTag = Empty Then
              For i = 1 To barAux.LenListOfButton
                Set button = barAux.ReturnButton(str$(i))
                If button.GetDownLevel <> Empty Then
                  pilha.add listbar.ReturnBar(button.GetDownLevel)
                End If
              Next i
            Else
              TestExistFloat = False
            End If
          Wend
        End With
      End If
    End If
  Else
    TestExistFloat = False
  End If
  
  Set button = Nothing: Set barAux = Nothing: Set pilha = Nothing
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set button = Nothing: Set barAux = Nothing: Set pilha = Nothing
End Function

Public Function TestFatherTag(listbar As clsListBar, tagFind As String, tagInsert As String, bar As clsBar) As Boolean
  Dim button As New clsButton
  Const errIDMet As String = "23"
  '-----------------------------
  On Error GoTo errLOG
  
  TestFatherTag = False
  Set button = listbar.ReturnBar(bar.getUpLevel).ReturnButton(tagFind)
  If button.GetTag <> Empty Then
    If button.GetDownLevel = bar.GetName Then
      TestFatherTag = True
    End If
  Else
    Select Case tagFind
      Case "head", "dperiod", "deposit"
        Set button = bar.ReturnButton(tagFind)
        If button.GetTag <> Empty And tagFind <> tagInsert Then
          TestFatherTag = True
        End If
      Case Else
        'return false
    End Select
  End If
  Set button = Nothing
  Exit Function
errLOG:
  
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing: Set button = Nothing
End Function

Public Function TestOwnSisterTag(listbar As clsListBar, tagFind As String, tagInsert As String, bar As clsBar, forward As Boolean) As Boolean
  Dim button As New clsButton, ok As Boolean, tag As String, start As Boolean
  Dim pilha As New collection, aux As String
  Const errIDMet As String = "24"
  '-----------------------------
  On Error GoTo errLOG
  
  TestOwnSisterTag = True: ok = False
  If tagFind = tagInsert Then
    Set button = bar.ReturnButton(tagInsert)
    If button.GetRepetitive = False Then
      TestOwnSisterTag = False
    End If
  Else
    Set button = bar.ReturnButton(tagFind)
    If button.GetTag <> Empty Then
      Set button = bar.ReturnButton(tagInsert)
      If button.GetRepetitive = False Then
        pilha.add tagFind
        While ok = False
          If FindTag(listbar, forward, start, tag) = True Then
            If start = False Then
              pilha.add tag
            Else
              With pilha
                If .count > 0 Then
                  .remove .count
                End If
              End With
            End If
            If tag = tagInsert Then
              With pilha
                If .count > 0 Then
                  aux = .Item(.count)
                Else
                  aux = tag
                End If
                If .count <= 1 And tag = aux Then
                  TestOwnSisterTag = False
                End If
              End With
            Else
              If TestFatherTag(listbar, tag, tagInsert, bar) = True Then
                ok = True
              End If
            End If
          Else
            TestOwnSisterTag = False
          End If
        Wend
      End If
    Else
      Set button = listbar.ReturnBar("ifloat").ReturnButton(tagFind)
      If button.GetTag = Empty Then
        TestOwnSisterTag = False
      Else
        TestOwnSisterTag = True
      End If
    End If
  End If
  
  Set button = Nothing: Set pilha = Nothing
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set button = Nothing: Set pilha = Nothing
End Function

Function getContent(tag As String) As String
    Dim tagstart As String
    Dim tagend As String
    Dim sPos As Long, ePos As Long
    
        
    tagstart = conf.STAGO + tag
    tagend = conf.ETAGO + tag + conf.TAGC
    
    MsgBox "ClearFormatting"
    selection.find.ClearFormatting
    
    With selection.find
      .text = tagstart
      .Replacement.text = ""
      .forward = True
      .Wrap = wdFindStop
      .Format = False
      .MatchCase = False
      .MatchWholeWord = False
      .MatchWildcards = False
      .MatchSoundsLike = False
      .MatchAllWordForms = False
    End With
    
    MsgBox "Selection.Find.Execute "
    selection.find.Execute
    If selection.find.found = True Then
        sPos = selection.start
        MsgBox "selection 1 :  " & selection.text & "  pos: " & sPos
    End If

    MsgBox "ClearFormatting"
    selection.ClearFormatting
    
    selection.find.ClearFormatting
    
    With selection.find
      .text = tagend
      .Replacement.text = ""
      .forward = True
      .Wrap = wdFindStop
      .Format = False
      .MatchCase = False
      .MatchWholeWord = False
      .MatchWildcards = False
      .MatchSoundsLike = False
      .MatchAllWordForms = False
    End With
    
    MsgBox "Selection.Find.Execute " & tagend
    selection.find.Execute
    If selection.find.found = True Then
        ePos = selection.End
        MsgBox "selection 2 :  " & selection.text & "  pos: " & ePos
    End If
    selection.start = sPos
    selection.End = ePos
    
    MsgBox selection.text
    getContent = selection.text
End Function

Function myFindTag(myString As String, ByRef selectedRange As range) As Boolean
    
    selectedRange.find.ClearFormatting
    With selectedRange.find
      .text = myString
      .Replacement.text = ""
      .forward = True
      .Wrap = wdFindStop
      .Format = False
      .MatchCase = False
      .MatchWholeWord = False
      .MatchWildcards = False
      .MatchSoundsLike = False
      .MatchAllWordForms = False
    End With
    
    'MsgBox "selectedRange.Find.Execute " & myString
    selectedRange.find.Execute
   
    myFindTag = selectedRange.find.found
End Function

Sub formatMarks(references As range)

    Dim sPos1 As Long, fPos1 As Long
    Dim sPos2 As Long, fPos2 As Long
    Dim color As Long
    Dim tagInicial As Long, tagFinal As Boolean
    
    Dim originalEnd As Long
    
    Set MyRange = references
    originalEnd = references.End
    color = 10
    
    While findText("[", True, sPos1, fPos1)
        
        Call MyRange.SetRange(sPos1 + 1, sPos1 + 2)
        tagFinal = (MyRange.text = "/")
        
        If Not tagFinal Then
            color = color + 1
        End If
        
        Call MyRange.SetRange(sPos1, originalEnd)
        If findText("]", True, sPos2, fPos2) Then
            Call MyRange.SetRange(sPos1, fPos2)
            
            Call FormatText(MyRange, color)
            Call MyRange.SetRange(sPos2 + 1, originalEnd)
        End If
        
        If tagFinal Then
            color = color - 1
        End If
    Wend
End Sub

Function findNextOpenTag(p As Long) As String
    Dim found As Boolean
    Dim pEnd As Long
    Dim pStart As Long
    Dim r As String
    Dim cont As Boolean
    Dim mrEnd As Long
    
    
    found = False
    pStart = p
    cont = True
    p = 0
    mrEnd = MyRange.End
    
    Do
        If findText("[", True, pStart, pEnd) Then
            If Mid(MyRange.text, pStart + 1, 1) = "/" Then
                pStart = pStart + 1
            Else
                found = True
                p = pStart
            End If
        Else
            cont = False
        End If
        Call MyRange.SetRange(pStart, mrEnd)
    Loop While Not found And cont
    
    If found Then
        Call MyRange.SetRange(p, mrEnd)
        found = findText("]", True, pStart, pEnd)
        If found Then
            Call MyRange.SetRange(p, pEnd)
            r = MyRange.text
        Else
            r = ""
        End If
    End If
    findNextOpenTag = r
End Function


Function findOpenTag(s As Long, e As Long, contentStart As Long) As String
    Dim t As String
    Dim tag As String
    Dim pStart As Long, pEnd As Long
    
    temp = temp & vbCrLf & vbCrLf & "findOpenTag " & CStr(s) & "," & CStr(e) & ";" & CStr(MyRange.start) & "," & CStr(MyRange.End)
    
    contentStart = 0
    MyRange.start = s
    MyRange.End = s
    
    temp = temp & vbCrLf & "selection.End = s " & CStr(s) & "," & CStr(e) & ";" & CStr(MyRange.start) & "," & CStr(MyRange.End)
    
    t = conf.TAGC
    If findText(t, True, pStart, pEnd) Then
        temp = temp & vbCrLf & "findText " & CStr(s) & "," & CStr(e) & ";" & CStr(pStart) & "," & CStr(pEnd)
        temp = temp & vbCrLf & ActiveDocument.range(s, pStart).text
        If pEnd > s And pEnd < e Then
            Call MyRange.SetRange(s, pStart)
            
            tag = MyRange.text
            temp = temp & vbCrLf & tag
            
            contentStart = pStart + 1
            
            If Len(tag) > 0 Then
                If InStr(tag, " ") > 0 Then
                    tag = Mid(tag, 1, InStr(tag, " ") - 1)
                End If
            End If
        End If
    End If
    temp = temp & vbCrLf & "fim " & CStr(s) & "," & CStr(e) & ";" & CStr(pStart) & "," & CStr(pEnd)
    MsgBox temp

    findOpenTag = tag
End Function


Function existTAGCBeforeSTAGO(s As Long, e As Long, pStart As Long) As Boolean
    Dim t As String
    Dim pTAGC As Long
    Dim pSTAGO As Long
    Dim r As Boolean
    
    temp = temp & vbCrLf & vbCrLf & "existTAGCBeforeSTAGO " & CStr(s) & "," & CStr(e) & ";" & CStr(MyRange.start) & "," & CStr(MyRange.End)
    
    pStart = 0
    MyRange.End = s
    MyRange.start = s
    temp = temp & vbCrLf & "myrange.end = s " & CStr(s) & "," & CStr(e) & ";" & CStr(MyRange.start) & "," & CStr(MyRange.End)
    
    ' encontrar ], que esteja entre s e e
    t = conf.TAGC
    If findText(t, True, pTAGC) Then
        If pTAGC > e Then
            pTAGC = 0
        End If
    End If
    
    temp = temp & vbCrLf & "encontrou pTAGC " & CStr(s) & "," & CStr(e) & ";" & CStr(MyRange.start) & "," & CStr(MyRange.End)
    
    
    ' encontrar [
    MyRange.End = s
    MyRange.start = s
    temp = temp & vbCrLf & "myrange.end = s " & CStr(s) & "," & CStr(e) & ";" & CStr(MyRange.start) & "," & CStr(MyRange.End)
    t = conf.STAGO
    If findText(t, True, pSTAGO) Then
        If pSTAGO >= e Then
            pSTAGO = 0
        End If
    End If
    
    temp = temp & vbCrLf & "encontrou pSTAGO " & CStr(s) & "," & CStr(e) & ";" & CStr(MyRange.start) & "," & CStr(MyRange.End)
    
    If pSTAGO > 0 Then
    
        If ActiveDocument.range(pSTAGO + 1, pSTAGO + 2).text = conf.slash Then
            r = True
        Else
            pStart = pSTAGO
            If pTAGC > 0 Then
                If pTAGC < pSTAGO Then
                    r = True
                End If
            End If
        End If
    Else
        r = (pTAGC > 0)
    End If
    temp = temp & vbCrLf & "Fim " & CStr(s) & "," & CStr(e) & ";" & CStr(MyRange.start) & "," & CStr(MyRange.End)
    temp = temp & vbCrLf & "ptagc  " & pTAGC
    temp = temp & vbCrLf & "pstago  " & pSTAGO
    
    
    existTAGCBeforeSTAGO = r
End Function
Function existSTAGOAfterTAGC(s As Long, e As Long) As Boolean
    Dim t As String
    Dim pTAGC As Long
    Dim pSTAGO As Long
    Dim r As Boolean
    
    
    temp = temp & vbCrLf & vbCrLf & "existSTAGOAfterTAGC " & CStr(s) & "," & CStr(e) & ";" & CStr(MyRange.start) & "," & CStr(MyRange.End)

    MyRange.End = s
    temp = temp & vbCrLf & "myrange.end = s" & CStr(s) & "," & CStr(e) & ";" & CStr(MyRange.start) & "," & CStr(MyRange.End)

    ' encontrar o ]
    t = conf.TAGC
    If findText(t, True, pTAGC) Then
        
        If pTAGC > e Then
            pTAGC = 0
        End If
    End If
    
    temp = temp & vbCrLf & "encontrou  pTAGC " & CStr(pTAGC) & " " & CStr(s) & "," & CStr(e) & ";" & CStr(MyRange.start) & "," & CStr(MyRange.End)

    MyRange.End = s
    temp = temp & vbCrLf & "myrange.end = s " & CStr(s) & "," & CStr(e) & ";" & CStr(MyRange.start) & "," & CStr(MyRange.End)
    
    ' encontrar o [
    t = conf.STAGO
    If findText(t, True, pSTAGO) Then
        
        If pSTAGO >= e Then
            pSTAGO = 0
        End If
    End If
    temp = temp & vbCrLf & "encontrou  psTAGo " & CStr(pSTAGO) & " " & CStr(s) & "," & CStr(e) & ";" & CStr(MyRange.start) & "," & CStr(MyRange.End)

    If pSTAGO > 0 Or pTAGC > 0 Then
        r = True
    End If
    temp = temp & vbCrLf & CStr(r)

    existSTAGOAfterTAGC = r
End Function
Function findSTAGO(s As Long, e As Long) As Long
    Dim t As String
    Dim pStart As Long
    Dim p As Long
    MyRange.End = s
    t = conf.STAGO
    If findText(t, True, p) Then
        If p > 0 And p < e Then
            If ActiveDocument.range(p + 1, p + 2).text <> conf.slash Then
                pStart = p
            End If
        End If
    End If
    findSTAGO = pStart
End Function

Function findCloseTag(s As Long, e As Long, tag As String, contentEnd As Long, closeTagEnd As Long) As Boolean
    Dim t As String
    Dim r As Boolean
    Dim pStart As Long, pEnd As Long
    
    temp = temp & vbCrLf & vbCrLf & "findCloseTag recebe parametros " & CStr(s) & "," & CStr(e) & ";" & CStr(MyRange.start) & "," & CStr(MyRange.End)
    contentEnd = 0
    closeTagEnd = 0
    
    MyRange.End = s
    MyRange.start = s
    
    
    temp = temp & vbCrLf & "myrange.start = s " & CStr(s) & "," & CStr(e) & ";" & CStr(MyRange.start) & "," & CStr(MyRange.End)
    t = conf.ETAGO & tag & conf.TAGC
    temp = temp & vbCrLf & t
    If findText(t, True, pStart, pEnd) Then
    
    Call MyRange.SetRange(pStart, pEnd)
    
        If pEnd > 0 And pEnd <= e Then
            contentEnd = pStart - 1
            closeTagEnd = pEnd
            r = True
        End If
    End If
    
    temp = temp & vbCrLf & "findCloseTag encontrou " & CStr(r) & " " & CStr(s) & "," & CStr(e) & ";" & CStr(MyRange.start) & "," & CStr(MyRange.End)
    findCloseTag = r
End Function



Function findPreviousMark(limInf As Long, currentPosition As Long) As Long
    Dim pStart As Long
    
    MyRange.End = currentPosition
    MyRange.start = MyRange.End
    
    If findText(conf.STAGO, False, pStart) Then
        If pStart < limInf Then
            pStart = 0
        End If
    End If
    findPreviousMark = pStart
End Function

Function findNextMark(limSup As Long, currentPosition As Long) As Long
    Dim pEnd As Long
    
    MyRange.End = currentPosition
    MyRange.start = currentPosition
    
    If findText(conf.TAGC, True, pEnd) Then
        If pEnd >= limSup Then
            pEnd = 0
        End If
    End If
    findNextMark = pEnd
End Function


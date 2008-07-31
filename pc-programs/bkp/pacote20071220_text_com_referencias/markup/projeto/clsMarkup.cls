VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsMarkup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private mErr As New clsErrList
Const errIDObj As String = "217"

Public Function InsertTag(tag As String, colorI As Long, Conf As clsConfig, Optional attl As clsAttrList, Optional linkl As clsLkList, Optional inter As clsInterface, Optional button As clsButton) As Boolean
  Dim start As Long, finish As Long
  Dim sTag As String, fTag As String, doc As Range
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  InsertTag = True: DisableScreen
  If tag = "article" Or tag = "text" Then
    ActiveDocument.Select
    With Selection
      Set doc = ActiveDocument.Range(start:=.start, End:=.End - 1)
    End With
  Else
    With Selection
      If .start = .End And tag <> "head" And tag <> "dperiod" Then
        With Conf
          MsgBox .msgSelection, vbCritical + vbOKOnly, .titleStart
          InsertTag = False: Exit Function
        End With
      Else
        Set doc = ActiveDocument.Range(start:=.start, End:=.End)
      End If
    End With
  End If
  With doc
    sTag = BuildStartTag(tag, Conf, attl, linkl, inter)
    fTag = BuildFinishTag(tag, Conf)
    .InsertBefore sTag: .InsertAfter fTag
    start = .start: finish = .End
    With ActiveDocument
      FormatText .Range(start:=start, End:=start + Len(sTag)), colorI
      FormatText .Range(start:=finish - Len(fTag), End:=finish), colorI
    End With
  End With
  With Selection
    If button.GetDownLevel = Empty Then
      .start = finish: .End = finish
    Else
      .End = start
      .MoveRight unit:=wdCharacter, Count:=Len(sTag)
    End If
  End With
  EnableScreen
  Exit Function
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Public Function DeleteTag(Conf As clsConfig, listBar As clsListBar, Optional tagDel As String) As Boolean
  Dim st As Long, iRange As Long, fRange As Long, tRange As Long
  Dim tag As String, text As String, iStart As Long, textFound As String
  Dim iDel As Long, fDel As Long, i As Long, slash As Boolean
  Dim ok As Boolean, pilha As New Collection, coord As New Collection
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  DeleteTag = True: DisableScreen
  ok = False
  With Selection
    If .start = .End Then
      MsgBox Conf.msgDeleting, vbCritical + vbOKOnly, Conf.titleDelete
      DeleteTag = False
    Else
      tag = Trim$(Selection.text)
      If .start <> 0 Then
        text = ActiveDocument.Range(start:=.start - 1, End:=.start).text
      End If
      If listBar.FoundTag(tag) = False Or text = Conf.slash Then
        MsgBox Conf.msgDeleting, vbCritical + vbOKOnly, Conf.titleDelete
        DeleteTag = False
      Else
        tagDel = tag
        iRange = .start: st = iRange - 1: .start = .End: iStart = st
        Selection.find.ClearFormatting
        With Selection.find
          .text = Conf.ETAGO & tag & Conf.TAGC
          .Replacement.text = "": .forward = True: .Wrap = wdFindStop
          .Format = False: .MatchCase = False: .MatchWholeWord = False
          .MatchWildcards = False: .MatchSoundsLike = False
          .MatchAllWordForms = False
        End With
        Selection.find.Execute
        If Selection.find.found = False Then
          Select Case tag
            Case "head", "dperiod"
              iDel = st
              With ActiveDocument
                Do
                  text = .Range(start:=st, End:=st + 1)
                  st = st + 1
                Loop While text <> Conf.TAGC
                fDel = st
                .Range(start:=iDel, End:=fDel).Delete
              End With
            Case Else
              MsgBox Conf.msgDeleting, vbCritical + vbOKOnly, Conf.titleDelete
              DeleteTag = False
          End Select
        Else
          tRange = .End
          With Selection
            .start = iStart: .End = iStart
          End With
          While ok = False
            Selection.find.ClearFormatting
            With Selection.find
              .text = Conf.STAGO
              .Replacement.text = "": .forward = True: .Wrap = wdFindStop
              .Format = False: .MatchCase = False: .MatchWholeWord = False
              .MatchWildcards = False: .MatchSoundsLike = False
              .MatchAllWordForms = False
            End With
            Selection.find.Execute
            iDel = Selection.start: iRange = iDel + 1
            If ActiveDocument.Range(start:=iDel + 1, End:=iDel + 2).text = Conf.slash Then
              slash = True: iRange = iDel + 2
            Else
              slash = False
            End If
            With Selection
              .start = .End
            End With
            Selection.find.ClearFormatting
            With Selection.find
              .text = Conf.TAGC
              .Replacement.text = "": .forward = True: .Wrap = wdFindStop
              .Format = False: .MatchCase = False: .MatchWholeWord = False
              .MatchWildcards = False: .MatchSoundsLike = False
              .MatchAllWordForms = False
            End With
            Selection.find.Execute
            fDel = Selection.End: fRange = fDel - 1
            text = ActiveDocument.Range(start:=iRange, End:=fRange).text
            If InStr(text, Space(1)) <> 0 Then
              textFound = Mid$(text, 1, InStr(text, Space(1)) - 1)
            Else
              textFound = text
            End If
            If slash = True Then
              If tag = text Then
                ok = True
              End If
            End If
            If listBar.FoundTag(textFound) = True Then
              coord.Add iDel: coord.Add fDel
              pilha.Add coord
              Set coord = Nothing
            Else
              '.End = iRange + 1
              .End = iRange
            End If
            With Selection
              .start = .End
            End With
          Wend
          With pilha
            For i = .Count To 1 Step -1
              Set coord = .Item(i)
              With coord
                ActiveDocument.Range(.Item(1), .Item(2)).Delete
              End With
            Next i
          End With
          With Selection
            .start = iStart: .End = iStart
          End With
        End If
      End If
    End If
  End With
  '--
  EnableScreen
  Set pilha = Nothing: Set coord = Nothing
  Exit Function
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  EnableScreen
  Set pilha = Nothing: Set coord = Nothing
End Function

Public Sub FormatText(txt As Range, color As Long)
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo errLOG
  
  With txt.Font
    .AllCaps = False
    .Animation = wdAnimationNone
    .Bold = False
    .ColorIndex = color
    .DoubleStrikeThrough = False
    .Emboss = False
    .Engrave = False
    .Hidden = False
    .Italic = False
    .Name = "Arial"
    .Outline = False
    .Shadow = False
    .Size = 11
    .SmallCaps = False
    .StrikeThrough = False
    .Subscript = False
    .Superscript = False
    .Underline = wdUnderlineNone
  End With
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

Public Function BuildStartTag(tag As String, Conf As clsConfig, Optional attl As clsAttrList, Optional linkl As clsLkList, Optional inter As clsInterface) As String
  Dim StartTag As String  'STAGO + TAG + ATTR + TAGC
  Dim l As New clsLink, at As New clsAttribute, i As Integer
  Dim fpage As String, lpage As String, pages As String
  Dim posHif As Integer, posVirg As Integer, posAux As Integer
  Dim listPeriod As New Collection
  Const errIDMet As String = "04"
  '-----------------------------
  On Error GoTo errLOG
  
  StartTag = Conf.STAGO & tag & Space(1)
  Select Case tag
    Case "article", "text"
      With inter
        '-----modificacao para suportar lpage, fpage------------
        pages = .pages
        posAux = 1
        Do
          posVirg = InStr(posAux, pages, ",")
          If posVirg > 0 Then
            listPeriod.Add Mid$(pages, posAux, posVirg - posAux)
            posAux = posVirg + 1
          ElseIf posVirg = 0 And listPeriod.Count = 0 Then
            listPeriod.Add pages
            Exit Do
          Else
            If listPeriod.Count > 0 Then
              listPeriod.Add Mid$(pages, posAux, Len(pages) - posAux + 1)
            End If
            Exit Do
          End If
        Loop
        With listPeriod
          For i = 1 To .Count
            pages = .Item(i)
            posHif = InStr(pages, "-")
            fpage = fpage & Mid$(pages, 1, posHif - 1) & Space(1)
            lpage = lpage & Mid$(pages, posHif + 1, Len(pages) - posHif) & Space(1)
          Next i
        End With
        fpage = Trim$(fpage): posAux = InStr(fpage, Chr(34))
        If posAux > 0 Then
          fpage = fpage & Chr(34)
        End If
        lpage = Trim$(lpage): posAux = InStr(lpage, Chr(34))
        If posAux > 0 Then
          lpage = Chr(34) & lpage
        End If
        '-------------------------------------------------------
        StartTag = StartTag & "pii=" & .pii & Space(1) & "doctopic=" & .doctopicAbbr & Space(1) & _
                   "language=" & .languageAbbr & Space(1) & "ccode=" & .ccodeAbbr & Space(1) & _
                   "status=" & .status & Space(1) & "version=" & .versionAbbr & Space(1) & _
                   "type=" & .typeAbbr & Space(1) & "order=" & .order & Space(1) & "seccode=" & _
                   .seccodeAbbr & Space(1)
        If .versionAbbr = "3.1" Or .versionAbbr = "3.0" Then
          StartTag = StartTag & "sponsor=" & .sponsorAbbr & Space(1)
        End If
        StartTag = StartTag & "stitle=" & .stitle & Space(1)
        
        If .volid <> Empty Then
          StartTag = StartTag & "volid=" & .volid & Space(1)
        End If
        If .supplvol <> Empty Then
          StartTag = StartTag & "supplvol=" & .supplvol & Space(1)
        End If
        If .issueno <> Empty Then
          StartTag = StartTag & "issueno=" & .issueno & Space(1)
        End If
        If .supplno <> Empty Then
          StartTag = StartTag & "supplno=" & .supplno & Space(1)
        End If

        '---------------modificacao para suporte a fpage e lpage
        'StartTag = StartTag & "dateiso=" & .dateiso & Space(1) & "pages=" & .pages & Space(1) & _
                   "issn=" & .issn
        StartTag = StartTag & "dateiso=" & .dateiso & Space(1) & "fpage=" & fpage & Space(1) & _
                   "lpage=" & lpage & Space(1) & "issn=" & .issn
        '-------------------------------------------------------
        If tag = "text" Then
          StartTag = StartTag & Space(1) & "toccode=" & .toccodeAbbr
        End If
        If .newPid <> Empty Then
            StartTag = StartTag & Space(1) & getPidAttribute() & .newPid
        End If
        If .ahpdate <> Empty Then
            StartTag = StartTag & Space(1) & "ahpdate=" & .ahpdate
        End If
        
      End With
      
    Case Else
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
  End Select
  
  StartTag = Trim$(StartTag)
  StartTag = StartTag & Conf.TAGC: StartTag = Trim$(StartTag)
  BuildStartTag = StartTag
  
  Set l = Nothing: Set at = Nothing: Set listPeriod = Nothing
  Exit Function
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set l = Nothing: Set at = Nothing: Set listPeriod = Nothing
End Function

Public Function BuildFinishTag(tag As String, Conf As clsConfig) As String
  Dim finishTag As String
  Const errIDMet As String = "05"
  '-----------------------------
  On Error GoTo errLOG
  
  Select Case tag
    Case "head", "dperiod"
      'empty tag
    Case Else
      With Conf
        finishTag = finishTag & .ETAGO & tag & .TAGC
      End With
  End Select
  BuildFinishTag = finishTag
  Exit Function
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Public Sub DisableScreen()
  Const errIDMet As String = "06"
  '-----------------------------
  On Error GoTo errLOG
  
  System.Cursor = wdCursorWait
  Application.ScreenUpdating = False
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

Public Sub EnableScreen()
  Const errIDMet As String = "07"
  '-----------------------------
  On Error GoTo errLOG
  
  System.Cursor = wdCursorNormal
  Application.ScreenUpdating = True
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

Public Function ChangeAttribute(Conf As clsConfig, listBar As clsListBar, linkl As clsLkList, listattr As clsAttrList, i As clsInterface, issuel As clsIssueList, Optional fPos As Long, Optional id As String) As Boolean
  Dim ch As String, text As String, iRange As Long, fRange As Long
  Dim st As Long, tagMarkup As String, b As New clsLink
  Static tg As String
  Const errIDMet As String = "08"
  '-----------------------------
  On Error GoTo errLOG
  
  ChangeAttribute = True
  With Selection
    If .start = .End Then
      ChangeAttribute = False
    Else
      text = Trim$(.text)
      If listBar.FoundTag(text) = False Then
        ChangeAttribute = False
      Else
        iRange = .start - 1: st = iRange
        If ActiveDocument.Range(start:=iRange, End:=iRange + 1).text = Conf.slash Then
          ChangeAttribute = False
        Else
          Do
            With ActiveDocument
              ch = .Range(start:=st, End:=st + 1)
              st = st + 1
            End With
          Loop While ch <> Conf.TAGC
          fRange = st: fPos = st
          Select Case text
            Case "article", "text"
              frmArticle.flagChange = True
              With i
                .SetFrmArticle issuel, listattr, text
                .ShowFrmArticleEdit Conf, ActiveDocument.Range(start:=iRange, End:=fRange).text, listattr
                If frmArticle.flagOK = True Then
                  .ExitFrmArticle Conf, listattr, issuel, id
                  tagMarkup = BuildStartTag(text, Conf, , , i)
                  DisableScreen
                  ActiveDocument.Range(start:=iRange, End:=fRange).text = tagMarkup
                  ChangeAttribute = True
                Else
                  ChangeAttribute = True
                End If
                .EndFrmArticle
              End With
            Case Else
              frmAttribute.flagChange = True
              Set b = linkl.ReturnLink(text)
              If tg <> text Then
                frmAttribute.CB_Conv.value = False
                tg = text
              End If
              If b.tagName <> Empty Then
                With i
                    .SetFrmAttribute listattr, linkl, text, issuel, id
                  If frmAttribute.CB_Conv.value = False Then
                    .ShowFrmAttribute Conf
                  Else
                    frmAttribute.flagOK = True
                  End If
                  If frmAttribute.flagOK = True Then
                    .ExitFrmAttribute listattr
                    tagMarkup = BuildStartTag(text, Conf, listattr, linkl, i)
                    DisableScreen
                    ActiveDocument.Range(start:=iRange, End:=fRange).text = tagMarkup
                    ChangeAttribute = True
                  Else
                    ChangeAttribute = True
                  End If
                  .EndFrmAttribute
                End With
              Else
                ChangeAttribute = False
              End If
          End Select
        End If
      End If
    End If
  End With
  EnableScreen
  '--------------
  Set b = Nothing
  Exit Function
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set b = Nothing
End Function

Public Function VerifyInsertInto(Conf As clsConfig, listBar As clsListBar) As Boolean
  Const MAXCH As Integer = 300
  Dim Count As Integer, iSTAGO As Long, iSTAGOBKP As Long
  Dim iRange As Long, fRange As Long
  Dim okSTAGO As Boolean, okTAGC As Boolean, text As String, continue As Boolean
  '-----------------
  On Error Resume Next
  okSTAGO = True: okTAGC = True: continue = False: Count = 0
  With Selection
    iRange = .start: fRange = .End
  End With
  While okSTAGO = True And continue = False And Count <= MAXCH
    With ActiveDocument
      text = .Range(start:=iRange - 1, End:=iRange)
      If err.Number <> 0 Then
        continue = True
      Else
        Select Case text
          Case Conf.STAGO
            okSTAGO = False
          Case Conf.TAGC
            continue = True
          Case Conf.slash
            okSTAGO = False
          Case Else
            iRange = iRange - 1
        End Select
      End If
    End With
    Count = Count + 1
  Wend
  continue = False: Count = 0
  While okTAGC = True And continue = False And Count <= MAXCH
    With ActiveDocument
      text = .Range(start:=fRange, End:=fRange + 1)
      If err.Number <> 0 Then
        continue = True
      Else
        Select Case text
          Case Conf.STAGO
            continue = True
          Case Conf.TAGC
            okTAGC = False
          Case Conf.slash
            okTAGC = False
          Case Else
            fRange = fRange + 1
        End Select
      End If
    End With
    Count = Count + 1
  Wend
  If okTAGC = False Or okSTAGO = False Then
    text = ActiveDocument.Range(start:=iRange, End:=fRange).text
    If okSTAGO = False And okTAGC = True Then
      text = Mid$(text, 1, InStr(text, Conf.TAGC) - 1)
      If InStr(text, Space(1)) <> 0 Then
        text = Mid$(text, 1, InStr(text, Space(1)) - 1)
      End If
      If listBar.FoundTag(text) = True Then
        VerifyInsertInto = False
      Else
        VerifyInsertInto = True
      End If
    End If
    If okTAGC = False And okSTAGO = True Then
      iSTAGO = 1
      Do
        iSTAGOBKP = iSTAGO
        iSTAGO = InStr(iSTAGO + 1, text, Conf.STAGO)
      Loop While iSTAGO <> 0
      text = Mid$(text, iSTAGOBKP + 1, Len(text) - InStr(text, Conf.STAGO))
      If Mid$(text, 1, 1) = Conf.slash Then
        text = Mid$(text, 2)
      End If
      If InStr(text, Space(1)) <> 0 Then
        text = Mid$(text, 1, InStr(text, Space(1)) - 1)
      End If
      If listBar.FoundTag(text) = True Then
        VerifyInsertInto = False
      Else
        VerifyInsertInto = True
      End If
    End If
    If okSTAGO = False And okTAGC = False Then
      iSTAGO = 1
      Do
        iSTAGOBKP = iSTAGO
        iSTAGO = InStr(iSTAGO + 1, text, Conf.STAGO)
      Loop While iSTAGO <> 0
      If iSTAGOBKP <> 1 Then
        text = Mid$(text, iSTAGOBKP + 1, Len(text) - InStr(text, Conf.STAGO))
      End If
      If Mid$(text, 1, 1) = Conf.slash Then
        text = Mid$(text, 2)
      End If
      If InStr(text, Space(1)) <> 0 Then
        text = Mid$(text, 1, InStr(text, Space(1)) - 1)
      End If
      If listBar.FoundTag(text) = True Then
        VerifyInsertInto = False
      Else
        VerifyInsertInto = True
      End If
    End If
  Else
    VerifyInsertInto = True
  End If
  If VerifyInsertInto = False Then
    With Selection
      .End = .start
    End With
  End If
  Exit Function
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Public Function VerifyHierarchy(Conf As clsConfig, listBar As clsListBar, currentBar As String, tag As String) As Boolean
  Dim iRange As Long, fRange As Long, start As Boolean
  Dim previousText As String, nextText As String
  Dim bar As New clsBar, button As New clsButton
  Dim ok1 As Boolean, ok2 As Boolean
  Const errIDMet As String = "09"
  '-----------------------------
  On Error GoTo errLOG
  
  ok1 = True: ok2 = True
  Set bar = listBar.ReturnBar(currentBar)
  '--------------------
  If currentBar = "start" Then 'Or currentBar = "ifloat" Then
    VerifyHierarchy = True: Exit Function
  End If
  DisableScreen
  With Selection
    iRange = .start: fRange = .End
  End With
  If TestExistTag(Conf, listBar) = True Then
    With Selection
      .start = iRange: .End = iRange
    End With
    If currentBar = "ifloat" Then
      If TestExistFloat(listBar, bar, Conf, currentBar, tag) = True Then
        ok1 = True: ok2 = True
      Else
        ok1 = False: ok2 = False
      End If
    Else
      With Selection
        .start = iRange: .End = iRange
      End With
      If FindTag(listBar, Conf, False, start, previousText) = True Then
        If start = True Then
          If TestFatherTag(listBar, previousText, tag, bar) = False Then
            ok1 = False
          End If
        Else
          If TestOwnSisterTag(listBar, Conf, previousText, tag, bar, False) = False Then
            ok1 = False
          End If
        End If
        With Selection
          .start = fRange: .End = fRange
        End With
        If FindTag(listBar, Conf, True, start, nextText) = True Then
          If start = True Then
            If TestOwnSisterTag(listBar, Conf, nextText, tag, bar, True) = False Then
              ok2 = False
            End If
          Else
            If TestFatherTag(listBar, nextText, tag, bar) = False Then
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
    With Selection
      .start = iRange: .End = iRange
    End With
    VerifyHierarchy = False
  Else
    With Selection
      .start = iRange: .End = fRange
    End With
    VerifyHierarchy = True
  End If
  EnableScreen
  '-----------------
  Set bar = Nothing: Set button = Nothing
  Exit Function
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  EnableScreen
  '-----------------
  Set bar = Nothing: Set button = Nothing
End Function

Public Sub BuildLog(Conf As clsConfig, attl As clsAttrList)
  Dim filename As String, metUnit As Double, F As Integer
  Const errIDMet As String = "10"
  '-----------------------------
  On Error GoTo errLOG
  
  'metUnit = 1048576 '1024 X 1024 -> MB
  
  F = FreeFile
  filename = ActiveDocument.FullName
  filename = BuildFilePathName(filename, "log")
  With Conf
    .SetLastHour
    Open filename For Append As #F
    Print #F, "Responsible: "; .GetResponsible
    Print #F, "System Date: "; Date
    With ActiveDocument
      Print #F,
      Print #F, "File Name: "; .FullName
      Print #F, "File Size Before (bytes): "; str$(Conf.fileSize)
      Print #F, "File Size After (bytes): "; str$(FileLen(.FullName))
      Print #F, "Pages Number: "; .ComputeStatistics(wdStatisticPages)
      Print #F,
      Print #F, "References Number: "; attl.ReturnAttr("count").lastInsertedValue
      With Conf
        Print #F, "Initial Time: "; .GetFirstHour
        Print #F, "Final Time: "; .GetLastHour
        Print #F, "Markup Time: "; .GetMarkupTime
        Print #F, String(80, "*")
      End With
    End With
    Close #F
  End With
  Exit Sub
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Close #F
End Sub

Public Sub UpLevel(bar As clsBar)
  Const errIDMet As String = "11"
  '-----------------------------
  On Error GoTo errLOG
  
  DisableScreen
  With bar
    DisplayBar .GetName, False
    ' DisplayBar .getUpLevel, True
    DisplayBar navegation.getUpLevel(), True

  End With
  EnableScreen
  Exit Sub
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  EnableScreen
  Set Conf = Nothing
End Sub

Public Sub downLevel(bar As clsBar, button As clsButton)
  Const errIDMet As String = "12"
  '-----------------------------
  On Error GoTo errLOG
  
  DisableScreen
  
  navegation.downLevel (bar.GetName)
  
  DisplayBar bar.GetName, False
  DisplayBar button.GetDownLevel, True
  EnableScreen
  Exit Sub
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
    EnableScreen
  Set Conf = Nothing
End Sub

Public Sub DisplayBar(barName As String, flag As Boolean)
  Dim percent As Long
  Const posw As Integer = 404
  Const poswL As Integer = 320
  '---alteração para proceedings: Renato 20020715
  Const poswH As Integer = 510
  '---
  Const errIDMet As String = "13"
  '-----------------------------
  On Error GoTo errLOG
  
  Select Case flag
    Case True
      With CommandBars(barName)
        .Visible = True
        posB = .Width
        Select Case barName
          Case "Markup"
            .Position = msoBarTop
            .Left = 0
          Case "ifloat", "aff", "table", "figgrp"
            .Position = msoBarTop
            .Left = 720
          Case "Hide"
            Select Case System.HorizontalResolution
              '---alteração para proceedings: Renato 20020715
              Case 1024
                .Top = -30: .Left = 986
              '---
              Case 800
                .Top = -30: .Left = 762
              Case 640
                .Top = -30: .Left = 601
            End Select
            .Visible = False
          Case Else
            If .Height < 60 Then
              .Position = msoBarBottom
              Select Case System.HorizontalResolution
                '---alteração para proceedings: Renato 20020715
                Case 1024
                  .Left = poswH - (posB / 2)
                '---
                Case 800
                  .Left = posw - (posB / 2)
                Case 640
                  .Left = poswL - (posB / 2)
              End Select
            Else
              'alteracao para nao mover o texto da janela
              'no caso das barras que precisam ficar flutuantes no ambiente
              With CommandBars("Fixed")
                .Visible = True
                .Position = msoBarBottom
                .Left = 0
              End With
              Select Case System.HorizontalResolution
                '---alteração para proceedings: Renato 20020715
                Case 1024
                  .Top = 600: .Left = poswH - (posB / 2)
                '---
                Case 800
                  .Top = 465: .Left = posw - (posB / 2)
                Case 640
                  .Top = 338: .Left = poswL - (posB / 2)
              End Select
            End If
        End Select
      End With
    Case False
      With CommandBars(barName)
        Select Case .Height
          Case Is > 60
            CommandBars("Fixed").Visible = False
        End Select
        .Visible = False
      End With
  End Select
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
Public Function readFormat(Conf As clsConfig) As Integer
  Dim F As Integer, aux1 As String, aux2 As String
  Dim token As New clsToken
  Const Path As String = "number.mds"
  
  F = FreeFile
  Open Conf.directory & Path For Input As #F
  Input #F, aux1
  Close #F
  With token
    .GetTokens aux1, aux2: .GetTokens aux1, aux2
  End With
  readFormat = val(Trim$(aux2))
End Function

Public Function getUsingSaveFormat(Conf As clsConfig) As Integer
  Dim Format As Integer
  Format = readFormat(Conf)
  If Format = wdFormatHTML Then
    If wdFormatFilteredHTML > 0 Then
        Format = wdFormatFilteredHTML
    End If
  End If
        
  getUsingSaveFormat = Format
End Function

Public Function checkReadFormat(ByVal activeDocumentFormat As Integer, ByVal readFormat As Integer) As Boolean
    Dim ret As Boolean
    
    ret = (activeDocumentFormat = readFormat)
    If Not ret Then
        If wdFormatFilteredHTML > 0 Then
            ret = (readFormat = wdFormatHTML Or readFormat = wdFormatFilteredHTML) And (activeDocumentFormat = wdFormatHTML Or activeDocumentFormat = wdFormatFilteredHTML)
        End If
    End If
  
  checkReadFormat = ret
End Function
Public Function VerifyDocumentHTMLFormat(Conf As clsConfig) As Boolean
  Dim F As Integer, fileFormatInNumber As Integer, fileFormatInTestHTML As Integer
  Dim token As New clsToken
  Const Path As String = "number.mds"
  Const test As String = "test.html"
  Const errIDMet As String = "14"
  '-----------------------------
  On Error GoTo errLOG
  
  VerifyDocumentHTMLFormat = False
  fileFormatInNumber = readFormat(Conf)
  'valor 22 representa o formato htm\html
  
  If Documents.Count = 1 Then
    If checkReadFormat(ActiveDocument.SaveFormat, fileFormatInNumber) Then
      VerifyDocumentHTMLFormat = True
    Else
      DisableScreen
      Documents.Open Conf.directory & test
      fileFormatInTestHTML = ActiveDocument.SaveFormat
      
      ActiveDocument.Close savechanges:=wdDoNotSaveChanges
      If fileFormatInNumber <> fileFormatInTestHTML Then
        F = FreeFile
        Open Conf.directory & Path For Output As #F
        Print #F, "saveformat"; ";"; fileFormatInTestHTML
        Close #F
        VerifyDocumentHTMLFormat = True
        EnableScreen
      End If
    End If
  End If
  Set token = Nothing
  Exit Function
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Close #F
  Set token = Nothing
End Function

Public Sub ChangeSTAGO_TAGC(Conf As clsConfig, listBar As clsListBar)
  Dim ok As Boolean, slash As Boolean, okFind As Boolean
  Dim iFind As Long, fFind As Long, text As String
  Const errIDMet As String = "15"
  '-----------------------------
  On Error GoTo errLOG
  
  ActiveWindow.DisplayVerticalScrollBar = False
  With Selection
    .start = 0: .End = 0
  End With
  ok = True
  While ok = True
    okFind = False
    Selection.find.ClearFormatting
    With Selection.find
      .text = Conf.STAGO: .Replacement.text = "": .forward = True
      .Wrap = wdFindStop: .Format = False: .MatchCase = False
      .MatchWholeWord = False: .MatchWildcards = False
      .MatchSoundsLike = False: .MatchAllWordForms = False
    End With
    Selection.find.Execute
    If Selection.find.found = True Then
      iFind = Selection.End
      text = ActiveDocument.Range(start:=iFind, End:=iFind + 1).text
      Select Case text
        Case Conf.slash
          slash = True: iFind = iFind + 1
        Case Else
          slash = False
      End Select
      With Selection
        .start = .End
      End With
      Selection.find.ClearFormatting
      With Selection.find
        .text = Conf.TAGC: .Replacement.text = "": .forward = True
        .Wrap = wdFindStop: .Format = False: .MatchCase = False
        .MatchWholeWord = False: .MatchWildcards = False
        .MatchSoundsLike = False: .MatchAllWordForms = False
      End With
      Selection.find.Execute
      If Selection.find.found = True Then
        fFind = Selection.start
        Select Case slash
          Case True
            text = ActiveDocument.Range(start:=iFind, End:=fFind).text
            If listBar.FoundTag(text) = False Then
              With ActiveDocument
                If InStr(.Range(start:=iFind, End:=fFind).text, Conf.STAGO) = 0 Then
                  .Range(start:=fFind, End:=fFind + 1).text = Conf.entityTAGC
                End If
                .Range(start:=iFind - 1, End:=iFind).text = Conf.entitySTAGO
                okFind = True
              End With
            End If
          Case False
            With ActiveDocument
              If InStr(.Range(start:=iFind, End:=fFind).text, Space(1)) <> 0 Then
                text = Mid$(.Range(start:=iFind, End:=fFind).text, 1, InStr(.Range(start:=iFind, End:=fFind).text, Space(1)) - 1)
                If listBar.FoundTag(text) = False Then
                  With ActiveDocument
                    If InStr(.Range(start:=iFind, End:=fFind).text, Conf.STAGO) = 0 Then
                      .Range(start:=fFind, End:=fFind + 1).text = Conf.entityTAGC
                    End If
                    .Range(start:=iFind - 1, End:=iFind).text = Conf.entitySTAGO
                    okFind = True
                  End With
                End If
              Else
                text = ActiveDocument.Range(start:=iFind, End:=fFind).text
                If listBar.FoundTag(text) = False Then
                  With ActiveDocument
                    If InStr(.Range(start:=iFind, End:=fFind).text, Conf.STAGO) = 0 Then
                      .Range(start:=fFind, End:=fFind + 1).text = Conf.entityTAGC
                    End If
                    .Range(start:=iFind - 1, End:=iFind).text = Conf.entitySTAGO
                    okFind = True
                  End With
                End If
              End If
            End With
        End Select
        With Selection
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
    Selection.find.ClearFormatting
    With Selection.find
      .text = Conf.TAGC: .Replacement.text = "": .forward = False
      .Wrap = wdFindStop: .Format = False: .MatchCase = False
      .MatchWholeWord = False: .MatchWildcards = False
      .MatchSoundsLike = False: .MatchAllWordForms = False
    End With
    Selection.find.Execute
    If Selection.find.found = True Then
      fFind = Selection.start
      With Selection
        .start = .End
      End With
      Selection.find.ClearFormatting
      With Selection.find
        .text = Conf.STAGO: .Replacement.text = "": .forward = False
        .Wrap = wdFindStop: .Format = False: .MatchCase = False
        .MatchWholeWord = False: .MatchWildcards = False
        .MatchSoundsLike = False: .MatchAllWordForms = False
      End With
      Selection.find.Execute
      If Selection.find.found = True Then
        iFind = Selection.End
        text = ActiveDocument.Range(start:=iFind, End:=iFind + 1).text
        Select Case text
          Case Conf.slash
            slash = True: iFind = iFind + 1
          Case Else
            slash = False
        End Select
        Select Case slash
          Case True
            text = ActiveDocument.Range(start:=iFind, End:=fFind).text
            If listBar.FoundTag(text) = False Then
              With ActiveDocument
                If InStr(.Range(start:=iFind, End:=fFind).text, Conf.TAGC) <> 0 Then
                  .Range(start:=fFind, End:=fFind + 1).text = Conf.entityTAGC
                End If
                okFind = True
              End With
            End If
          Case False
            With ActiveDocument
              With ActiveDocument
                If InStr(.Range(start:=iFind, End:=fFind).text, Conf.TAGC) <> 0 Then
                  .Range(start:=fFind, End:=fFind + 1).text = Conf.entityTAGC
                End If
                okFind = True
              End With
            End With
        End Select
        With Selection
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
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Sub

Public Sub ChangeFields(Conf As clsConfig)
  Const errIDMet As String = "16"
  '-----------------------------
  On Error GoTo errLOG
  
  If ActiveWindow.ActivePane.View.ShowAll = False Then
    ActiveWindow.ActivePane.View.ShowAll = True
  End If
  Selection.find.ClearFormatting
  Selection.find.Replacement.ClearFormatting
  With Selection.find
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
  Selection.find.Execute Replace:=wdReplaceAll
  ActiveWindow.ActivePane.View.ShowAll = False
  Exit Sub
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  ActiveWindow.ActivePane.View.ShowAll = False
End Sub

Public Sub ChangeHtmlMarkup(Conf As clsConfig)
  Const errIDMet As String = "17"
  '-----------------------------
  On Error GoTo errLOG
  
  If ActiveWindow.ActivePane.View.ShowAll = False Then
    ActiveWindow.ActivePane.View.ShowAll = True
  End If
  Selection.find.ClearFormatting
  Selection.find.Style = ActiveDocument.Styles("HTML Markup")
  Selection.find.Replacement.ClearFormatting
  With Selection.find
    .text = ""
    .Replacement.text = ""
    .forward = True
    .Wrap = wdFindContinue
    .Format = True
    .MatchCase = False
    .MatchWholeWord = False
    .MatchWildcards = False
    .MatchSoundsLike = False
    .MatchAllWordForms = False
  End With
  Selection.find.Execute Replace:=wdReplaceAll
  ActiveWindow.ActivePane.View.ShowAll = False
  Exit Sub
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  ActiveWindow.ActivePane.View.ShowAll = False
End Sub

Public Sub ChangeEntity(Conf As clsConfig)
'opcao = 0  -> troca colchetes por entidade
'opcao = 1  -> troca entidade por colchetes
  Dim Texto As Range
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
  Set Texto = ActiveDocument.Content
  For i = 0 To 1
    With Texto
      .find.Execute FindText:=dash(i), replacewith:="-", Replace:=wdReplaceAll
      'troca en dash e em dash por hifen
    End With
  Next i
  Exit Sub
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Sub

Public Function FindTag(listBar As clsListBar, Conf As clsConfig, forward As Boolean, start As Boolean, tag As String, Optional sX As Long, Optional fX As Long) As Boolean
  Dim iFind As Long, fFind As Long, pos As Integer, ok As Boolean
  Const errIDMet As String = "19"
  '-----------------------------
  On Error GoTo errLOG
  '-------------------
  FindTag = True: ok = False
  While ok = False
    Select Case forward
      Case True
        If FindText(Conf.STAGO, forward) = True Then
          With ActiveDocument
            iFind = Selection.End
            If .Range(start:=iFind, End:=iFind + 1).text = Conf.slash Then
              iFind = Selection.End + 1
              start = False
            Else
              start = True
            End If
            With Selection
              .start = .End
            End With
            If FindText(Conf.TAGC, forward) = True Then
              fFind = Selection.start
            Else
              FindTag = False: ok = True
            End If
          End With
          With Selection
            .start = .End
          End With
        Else
          FindTag = False: ok = True
        End If
      Case False
        If FindText(Conf.TAGC, forward) = True Then
          fFind = Selection.start
          With Selection
            .End = .start
          End With
          If FindText(Conf.STAGO, forward) = True Then
            With ActiveDocument
              iFind = Selection.End
              If .Range(start:=iFind, End:=iFind + 1).text = Conf.slash Then
                iFind = Selection.End + 1
                start = False
              Else
                start = True
              End If
              With Selection
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
        pos = InStr(.Range(start:=iFind, End:=fFind).text, Space(1))
        sX = iFind
        If pos <> 0 Then
          tag = .Range(start:=iFind, End:=iFind + pos - 1).text
          fX = iFind + pos - 1
        Else
          tag = .Range(start:=iFind, End:=fFind).text
          fX = fFind
        End If
        If listBar.FoundTag(tag) = True Then
          ok = True
        Else
          With Selection
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
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Public Function FindText(t As String, F As Boolean, Optional sPos As Long, Optional fPos As Long) As Boolean
  Const errIDMet As String = "20"
  '-----------------------------
  On Error GoTo errLOG
  
  FindText = False
  With Selection.find
    .text = t: .Replacement.text = "": .forward = F
    .Wrap = wdFindStop: .Format = False: .MatchCase = False
    .MatchWholeWord = False: .MatchWildcards = False
    .MatchSoundsLike = False: .MatchAllWordForms = False
  End With
  Selection.find.Execute
  If Selection.find.found = True Then
    With Selection
      sPos = .start + 1: fPos = .End - 1
    End With
    FindText = True
  End If
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

Public Function TestExistTag(Conf As clsConfig, listBar As clsListBar) As Boolean
  Dim finishPos As Long, tag As String, start As Boolean
  Dim button As New clsButton, pilha As New Collection
  Const errIDMet As String = "21"
  '-----------------------------
  On Error GoTo errLOG
  
  TestExistTag = True
  With Selection
    finishPos = .End
    .End = .start
  End With
  While Selection.End <= finishPos
    If FindTag(listBar, Conf, True, start, tag) = True Then
      If Selection.End <= finishPos Then
        If start = True Then
          If listBar.FoundTag(tag) = True Then
            Set button = listBar.ReturnBar("ifloat").ReturnButton(tag)
            If button.GetTag = Empty Then
              If pilha.Count = 0 Then
                TestExistTag = False: Exit Function
              End If
            Else
              pilha.Add button
            End If
          End If
        Else
          If listBar.FoundTag(tag) = True Then
            Set button = listBar.ReturnBar("ifloat").ReturnButton(tag)
            If button.GetTag = Empty Then
              If pilha.Count = 0 Then
                TestExistTag = False: Exit Function
              End If
            Else
              With pilha
                Set button = .Item(.Count)
                If button.GetTag = tag Then
                  .Remove .Count
                End If
              End With
            End If
          End If
        End If
      Else
        If pilha.Count > 0 Then
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
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set button = Nothing: Set pilha = Nothing
End Function

Public Function TestExistFloat(listBar As clsListBar, bar As clsBar, Conf As clsConfig, currentBar As String, tagInsert As String) As Boolean
  Dim button As New clsButton, tag As String, start As Boolean
  Dim barAux As New clsBar, pilha As New Collection
  Dim i As Integer
  Const errIDMet As String = "22"
  '-----------------------------
  On Error GoTo errLOG
  
  TestExistFloat = True
  Set barAux = bar: pilha.Add barAux
  If FindTag(listBar, Conf, False, start, tag) = True Then
    If start = True Then
      With pilha
        While .Count > 0
          Set barAux = .Item(.Count): .Remove (.Count)
          Set button = barAux.ReturnButton(tag)
          If button.GetTag = Empty Then
            For i = 1 To barAux.LenListOfButton
              Set button = barAux.ReturnButton(str$(i))
              If button.GetDownLevel <> Empty Then
                pilha.Add listBar.ReturnBar(button.GetDownLevel)
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
          While .Count > 0
            Set barAux = .Item(.Count): .Remove (.Count)
            Set button = barAux.ReturnButton(tag)
            If button.GetTag = Empty Then
              For i = 1 To barAux.LenListOfButton
                Set button = barAux.ReturnButton(str$(i))
                If button.GetDownLevel <> Empty Then
                  pilha.Add listBar.ReturnBar(button.GetDownLevel)
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
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set button = Nothing: Set barAux = Nothing: Set pilha = Nothing
End Function

Public Function TestFatherTag(listBar As clsListBar, tagFind As String, tagInsert As String, bar As clsBar) As Boolean
  Dim button As New clsButton
  Const errIDMet As String = "23"
  '-----------------------------
  On Error GoTo errLOG
  
  TestFatherTag = False
  Set button = listBar.ReturnBar(bar.getUpLevel).ReturnButton(tagFind)
  If button.GetTag <> Empty Then
    If button.GetDownLevel = bar.GetName Then
      TestFatherTag = True
    End If
  Else
    Select Case tagFind
      Case "head", "dperiod"
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
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing: Set button = Nothing
End Function

Public Function TestOwnSisterTag(listBar As clsListBar, Conf As clsConfig, tagFind As String, tagInsert As String, bar As clsBar, forward As Boolean) As Boolean
  Dim button As New clsButton, ok As Boolean, tag As String, start As Boolean
  Dim pilha As New Collection, aux As String
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
        pilha.Add tagFind
        While ok = False
          If FindTag(listBar, Conf, forward, start, tag) = True Then
            If start = False Then
              pilha.Add tag
            Else
              With pilha
                If .Count > 0 Then
                  .Remove .Count
                End If
              End With
            End If
            If tag = tagInsert Then
              With pilha
                If .Count > 0 Then
                  aux = .Item(.Count)
                Else
                  aux = tag
                End If
                If .Count <= 1 And tag = aux Then
                  TestOwnSisterTag = False
                End If
              End With
            Else
              If TestFatherTag(listBar, tag, tagInsert, bar) = True Then
                ok = True
              End If
            End If
          Else
            TestOwnSisterTag = False
          End If
        Wend
      End If
    Else
      Set button = listBar.ReturnBar("ifloat").ReturnButton(tagFind)
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
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set button = Nothing: Set pilha = Nothing
End Function

Public Function BuildFilePathName(filePath As String, ext As String) As String
  Dim pos As Integer, posBkp As Integer
  '--------------------
  pos = 1
  Do
    posBkp = pos
    pos = InStr(posBkp + 1, filePath, ".")
  Loop While pos <> 0
  BuildFilePathName = Mid$(filePath, 1, posBkp) & ext
End Function

Public Function RestoreScreen()
  DisableScreen
  With Selection
    .MoveDown unit:=wdLine, Count:=1
    .MoveUp unit:=wdLine, Count:=1
  End With
  EnableScreen
End Function

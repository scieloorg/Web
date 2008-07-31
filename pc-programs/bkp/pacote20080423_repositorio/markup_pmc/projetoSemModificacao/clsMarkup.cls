VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsMarkup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private mErr As New clsErrList
Const errIDObj As String = "217"

Private mvarListBar As New clsListBar

Property Get listbar() As clsListBar
    Set listbar = mvarListBar
End Property

Property Set listbar(v As clsListBar)
    Set mvarListBar = v
End Property

Public Function InsertTag(tag As String, colorI As Long, conf As clsConfig, Optional attl As clsAttrList, Optional linkl As clsLkList, Optional inter As clsInterface, Optional button As clsButton) As Boolean
  Dim start As Long, finish As Long
  Dim sTag As String, fTag As String, doc As range
  Dim body As clsBody
  
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  InsertTag = True: DisableScreen
  If tag = "article" Or tag = "text" Or tag = "translat" Then
    ActiveDocument.Select
    With selection
      Set doc = ActiveDocument.range(start:=.start, End:=.End - 1)
    End With
  ElseIf tag = "xmlbody" And Conf.bodyHasChildren = "yes" Then
      Set body = New clsBody
      Set body.MarkupRange = New clsMarkupRange
      
      Set body.MarkupRange.conf = conf
      Set body.MarkupRange.listbar = listbar
      Set doc = body.markupBody(doc)
  Else
    With selection
      If .start = .End And tag <> "head" And tag <> "dperiod" And tag <> "deposit" Then
        With conf
          MsgBox .msgSelection, vbCritical + vbOKOnly, .titleStart
          InsertTag = False: Exit Function
        End With
      Else
        Set doc = ActiveDocument.range(start:=.start, End:=.End)
      End If
    End With
  End If
    
  With doc
    sTag = BuildStartTag(tag, conf, attl, linkl, inter)
    fTag = BuildFinishTag(tag, conf)
    .InsertBefore sTag: .InsertAfter fTag
    start = .start: finish = .End
    With ActiveDocument
      FormatText .range(start:=start, End:=start + Len(sTag)), colorI
      FormatText .range(start:=finish - Len(fTag), End:=finish), colorI
    End With
  End With
  With selection
    If button.GetDownLevel = Empty Then
      .End = finish
      .start = finish
      .MoveLeft wdCharacter, 1
      .MoveRight wdCharacter, 1
      ' ActiveDocument.range.Move wdCharacter, finish
      'doc.start = finish
      'doc.End = finish
    Else
      .End = start
      .MoveRight unit:=wdCharacter, count:=Len(sTag)
    End If
  End With
  EnableScreen
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Public Function DeleteTag(conf As clsConfig, listbar As clsListBar, Optional tagDel As String) As Boolean
    
    'DeleteTag = DeleteTag_Original(Conf, listBar, tagDel)
    If selection.start = selection.End Then
        MsgBox Conf.msgDeleting, vbCritical + vbOKOnly, Conf.titleDelete
    Else
    DeleteTag = callDeleteTagSelected(conf, listbar)
    End If
    
End Function

Public Function callDeleteTagSelected(conf As clsConfig, listbar As clsListBar) As Boolean
  
  Dim r As Boolean
  Dim n As Long
  
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  DisableScreen
  
          r = DeleteTagSelected(conf, listbar, n)
  
  EnableScreen
  
  callDeleteTagSelected = r
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  EnableScreen
End Function
Public Function DeleteTagSelected(conf As clsConfig, listbar As clsListBar, deletedCharNumber As Long) As Boolean
  Dim OpenTagStart As Long, OpenTagEnd As Long, contentEnd As Long
  Dim selectedText As String, previousChar As String
  Dim deletedTag As String
  Dim r As Boolean
  Dim n As Long
  Dim p As Long
  Dim tagDel As String
  
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
    If selection.start = selection.End Then
        r = False
    Else
      selectedText = Trim$(selection.text)
      If selection.start <> 0 Then
        previousChar = ActiveDocument.range(start:=selection.start - 1, End:=selection.start).text
      End If
      If listBar.FoundTag(selectedText) = False Or previousChar = Conf.slash Then
        'MsgBox Conf.msgDeleting, vbCritical + vbOKOnly, Conf.titleDelete
        r = False
      Else
        tagDel = selectedText
        p = selection.start - 1
        
        If tagDel = currentStandard.ref_tagName Then
            r = DeleteTagRef(conf, listbar)
        Else
            r = DeleteTagDifferentFromRef(Conf, listBar, deletedCharNumber, False)
        End If
        selection.End = p
        selection.start = p
        
       selection.MoveLeft wdCharacter, 1
       selection.MoveRight wdCharacter, 1
      
    End If
    End If
  
  
  DeleteTagSelected = r
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  
End Function

Public Function DeleteTagRef(conf As clsConfig, listbar As clsListBar) As Boolean
  Dim s As Long
  Dim e As Long
  Dim n As Long
  Dim formerReference As String
  
  Dim tag As String
  
  Dim OpenTagStart As Long, closeTagEnd As Long, contentEnd As Long
  Dim selectedText As String, previousChar As String
  Dim deletedTag As String
  Dim r As Boolean
  Dim formerRefEnd As Long
  Dim formerRefStart As String
  Dim font As New font
  
    s = selection.start
    e = selection.End
    tag = selection.text
      
    OpenTagStart = selection.start - 1
    
    selection.End = selection.start
    If findText(conf.ETAGO & tag & conf.TAGC, True) Then
    
        closeTagEnd = selection.End
        
        selection.start = OpenTagStart
        selection.End = OpenTagStart
        If findText("[/text-ref]", True) Then
            If selection.End <= closeTagEnd Then
                formerRefEnd = selection.start
                selection.start = OpenTagStart
                selection.End = OpenTagStart
                
                If findText("[text-ref]", True) Then
                    If selection.End <= formerRefEnd Then
                        formerRefStart = selection.start + Len("[text-ref]")
                        formerReference = ActiveDocument.range(start:=formerRefStart, End:=formerRefEnd).text
                        font.ColorIndex = ActiveDocument.range(start:=formerRefStart, End:=formerRefEnd).font.ColorIndex
                        font.Name = ActiveDocument.range(start:=formerRefStart, End:=formerRefEnd).font.Name
                        font.Bold = ActiveDocument.range(start:=formerRefStart, End:=formerRefEnd).font.Bold
                        font.Size = ActiveDocument.range(start:=formerRefStart, End:=formerRefEnd).font.Size
                    End If
                End If
            End If
        End If
        If Len(formerReference) > 0 Then
            ActiveDocument.range(start:=OpenTagStart, End:=closeTagEnd).text = formerReference
            CloseTagEnd = OpenTagStart + Len(formerReference)
            ActiveDocument.range(start:=OpenTagStart, End:=closeTagEnd).font.ColorIndex = font.ColorIndex
            ActiveDocument.range(start:=OpenTagStart, End:=closeTagEnd).font.Name = font.Name
            ActiveDocument.range(start:=OpenTagStart, End:=closeTagEnd).font.Bold = font.Bold
            ActiveDocument.range(start:=OpenTagStart, End:=closeTagEnd).font.Size = font.Size
            r = True
        Else
            selection.start = s
            selection.End = e
            r = DeleteTagDifferentFromRef(conf, listbar, n)
        End If
    End If
    DeleteTagRef = r
End Function

Public Function DeleteTagDifferentFromRef(Conf As clsConfig, listBar As clsListBar, deletedCharNumber As Long, Optional deleteLine As Boolean) As Boolean
  Dim OpenTagStart As Long, OpenTagEnd As Long, contentEnd As Long
  Dim selectedText As String, previousChar As String
  Dim deletedTag As String
  Dim t As String
  Dim r As Boolean
  
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
    tagDel = Trim(selection.text)
    
    OpenTagStart = selection.start - 1
    selection.start = selection.End
    
    ' encontrar o final da tag de abre
    t = conf.TAGC
    If findText(t, True) Then
        
        OpenTagEnd = selection.End
        If deleteLine Then
                OpenTagEnd = OpenTagEnd + 1
        End If
        ' apaga tag de abre
        deletedTag = ActiveDocument.range(start:=OpenTagStart, End:=OpenTagEnd).text
        deletedCharNumber = deletedCharNumber + Len(deletedTag)
        ActiveDocument.range(start:=OpenTagStart, End:=OpenTagEnd).Delete
        
        ' encontrar a tag de fecha
        selection.start = OpenTagStart
        selection.End = OpenTagStart
        
        t = conf.ETAGO & tagDel & conf.TAGC
        If findText(t, True) Then
            contentEnd = selection.start
            
            If deleteLine Then
                selection.End = selection.End + 1
            End If
            
            deletedCharNumber = deletedCharNumber + Len(ActiveDocument.range(start:=selection.start, End:=selection.End).text)
            ActiveDocument.range(start:=selection.start, End:=selection.End).Delete
            
            ' treat content
            selection.start = OpenTagStart
            selection.End = contentEnd
            
            If Len(selection.text) > 0 Then
                r = DeleteTagsInContent(conf, listbar, deletedCharNumber)
            Else
                r = True
            End If
        Else
            Select Case tagDel
            Case "head", "dperiod", "deposit"
                r = True
            Case Else
                Call ActiveDocument.range(start:=OpenTagStart, End:=OpenTagStart).InsertAfter(deletedTag)
                r = False
            End Select
        End If
    End If

  
  DeleteTagDifferentFromRef = r
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  
End Function
Public Function DeleteTagsInContent(conf As clsConfig, listbar As clsListBar, deletedCharNumber As Long) As Boolean
  Dim contentEnd As Long
  Dim contentStart As Long
  Dim localDeletedCharNumber As Long
  Dim OpenTagStart As Long, OpenTagEnd As Long
  Dim r As Boolean
  Dim tryNextOpenTag As Boolean
  Dim d As Boolean
  
  
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  If d Then MsgBox "Delete tags in content: " & selection.text
  
  contentEnd = selection.End
  contentStart = selection.start
  
  Dim content As String
  
  content = selection.text
  
    If contentStart >= contentEnd Then
        r = False
    Else
        selection.End = contentStart
        ' find tag abre
        If findText(conf.STAGO, True) Then
            
            If d Then MsgBox "found " & selection.text
        
            If selection.start < contentEnd Then
                ' check it is open or close tag
                OpenTagStart = selection.start
                
                If ActiveDocument.range(start:=selection.start + 1, End:=selection.start + 1).text = "/" Then
                    tryNextOpenTag = True
                Else
                    ' it is open tag, find ]
                    selection.End = selection.start
                    
                    
                    If findText(conf.TAGC, True) Then
                    
                    If d Then MsgBox "found " & selection.text
        
                        If selection.start < contentEnd Then
                            
                            ' select tag name
                            OpenTagEnd = selection.start
                            
                            selection.start = OpenTagStart + 1
                            selection.End = OpenTagEnd
                            
                            If d Then MsgBox "tag " & selection.text
                            If InStr(selection.text, " ") > 0 Then
                                selection.End = selection.start + InStr(selection.text, " ") - 1
                            End If
                            
                            If d Then MsgBox "tag " & selection.text
                            
                            localDeletedCharNumber = 0
                            If DeleteTagSelected(conf, listbar, localDeletedCharNumber) Then
                                ' encontra a proxima tag para apagar
                                
                                If d Then MsgBox "apagou..." & ActiveDocument.range(start:=OpenTagStart, End:=OpenTagStart + 300).text
                                selection.start = OpenTagStart
                                selection.End = contentEnd - localDeletedCharNumber
                                
                                If d Then MsgBox "content " & content
                                If d Then MsgBox "resto do conteudo " & selection.text
                                
                                r = DeleteTagsInContent(conf, listbar, deletedCharNumber)
                                deletedCharNumber = deletedCharNumber + localDeletedCharNumber
                            Else
                                ' nao era uma tag (valida)
                                tryNextOpenTag = True
                            End If
                        Else
                            ' it is out of limit
                            ' nao encontrou ] dentro do limite, entao nao era tag
                            ' procurar proximo [
                            tryNextOpenTag = True
                        End If
                    Else
                        ' it was not a tag, there is no ]
                        ' procurar proximo [
                        tryNextOpenTag = True
                    End If
                End If
                If tryNextOpenTag Then
                    selection.start = OpenTagStart + 1
                    selection.End = contentEnd
                    r = DeleteTagsInContent(conf, listbar, deletedCharNumber)
                End If
            Else
                ' it is out of limit
                ' nao encontrou [, dentro do limite, entao nao tem tags, apenas conteudo
                r = True
            End If
        Else
            ' nao encontrou [, entao nao tem tags, apenas conteudo
            r = True
        End If
    End If
  
  DeleteTagsInContent = r
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Public Function DeleteTag_Original(conf As clsConfig, listbar As clsListBar, Optional tagDel As String) As Boolean
  Dim st As Long, iRange As Long, fRange As Long, tRange As Long
  Dim tag As String, text As String, iStart As Long, textFound As String
  Dim iDel As Long, fDel As Long, i As Long, slash As Boolean
  Dim ok As Boolean, pilha As New collection, coord As New collection
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  DeleteTag_Original = True: DisableScreen
  ok = False
  With selection
    If .start = .End Then
      MsgBox conf.msgDeleting, vbCritical + vbOKOnly, conf.titleDelete
      DeleteTag_Original = False
    Else
      tag = Trim$(selection.text)
      If .start <> 0 Then
        text = ActiveDocument.range(start:=.start - 1, End:=.start).text
      End If
      If listbar.FoundTag(tag) = False Or text = conf.slash Then
        MsgBox conf.msgDeleting, vbCritical + vbOKOnly, conf.titleDelete
        DeleteTag_Original = False
      Else
        tagDel = tag
        iRange = .start: st = iRange - 1: .start = .End: iStart = st
        selection.find.ClearFormatting
        With selection.find
          .text = conf.ETAGO & tag & conf.TAGC
          .Replacement.text = "": .forward = True: .Wrap = wdFindStop
          .Format = False: .MatchCase = False: .MatchWholeWord = False
          .MatchWildcards = False: .MatchSoundsLike = False
          .MatchAllWordForms = False
        End With
        selection.find.Execute
        If selection.find.found = False Then
          Select Case tag
            Case "head", "dperiod", "deposit"
              iDel = st
              With ActiveDocument
                Do
                  text = .range(start:=st, End:=st + 1)
                  st = st + 1
                Loop While text <> conf.TAGC
                fDel = st
                .range(start:=iDel, End:=fDel).Delete
              End With
            Case Else
              MsgBox conf.msgDeleting, vbCritical + vbOKOnly, conf.titleDelete
              DeleteTag_Original = False
          End Select
        Else
          tRange = .End
          With selection
            .start = iStart: .End = iStart
          End With
          While ok = False
            selection.find.ClearFormatting
            With selection.find
              .text = conf.STAGO
              .Replacement.text = "": .forward = True: .Wrap = wdFindStop
              .Format = False: .MatchCase = False: .MatchWholeWord = False
              .MatchWildcards = False: .MatchSoundsLike = False
              .MatchAllWordForms = False
            End With
            selection.find.Execute
            iDel = selection.start: iRange = iDel + 1
            If ActiveDocument.range(start:=iDel + 1, End:=iDel + 2).text = conf.slash Then
              slash = True: iRange = iDel + 2
            Else
              slash = False
            End If
            With selection
              .start = .End
            End With
            selection.find.ClearFormatting
            With selection.find
              .text = conf.TAGC
              .Replacement.text = "": .forward = True: .Wrap = wdFindStop
              .Format = False: .MatchCase = False: .MatchWholeWord = False
              .MatchWildcards = False: .MatchSoundsLike = False
              .MatchAllWordForms = False
            End With
            selection.find.Execute
            fDel = selection.End: fRange = fDel - 1
            text = ActiveDocument.range(start:=iRange, End:=fRange).text
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
            If listbar.FoundTag(textFound) = True Then
              coord.add iDel: coord.add fDel
              pilha.add coord
              Set coord = Nothing
            Else
              '.End = iRange + 1
              .End = iRange
            End If
            With selection
              .start = .End
            End With
          Wend
          With pilha
            For i = .count To 1 Step -1
              Set coord = .Item(i)
              With coord
                ActiveDocument.range(.Item(1), .Item(2)).Delete
              End With
            Next i
          End With
          With selection
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
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  EnableScreen
  Set pilha = Nothing: Set coord = Nothing
End Function
Public Sub FormatText(txt As range, color As Long)
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo errLOG
  
  With txt.font
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
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub

Public Function BuildStartTag(tag As String, conf As clsConfig, Optional attl As clsAttrList, Optional linkl As clsLkList, Optional inter As clsInterface) As String
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
    Case "translat"
        StartTag = Conf.STAGO & tag
    Case "article", "text"
      With inter
        '-----modificacao para suportar lpage, fpage------------
        pages = .pages
        posAux = 1
        Do
          posVirg = InStr(posAux, pages, ",")
          If posVirg > 0 Then
            listPeriod.add Mid$(pages, posAux, posVirg - posAux)
            posAux = posVirg + 1
          ElseIf posVirg = 0 And listPeriod.count = 0 Then
            listPeriod.add pages
            Exit Do
          Else
            If listPeriod.count > 0 Then
              listPeriod.add Mid$(pages, posAux, Len(pages) - posAux + 1)
            End If
            Exit Do
          End If
        Loop
        With listPeriod
          For i = 1 To .count
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
        If .RVPdate <> Empty Then
            StartTag = StartTag & Space(1) & "rvpdate=" & .RVPdate
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
  StartTag = StartTag & conf.TAGC: StartTag = Trim$(StartTag)
  BuildStartTag = StartTag
  
  Set l = Nothing: Set at = Nothing: Set listPeriod = Nothing
  Exit Function
errLOG:
MsgBox err.Description
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set l = Nothing: Set at = Nothing: Set listPeriod = Nothing
End Function

Public Function BuildFinishTag(tag As String, conf As clsConfig) As String
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

Public Sub DisableScreen()
  Const errIDMet As String = "06"
  '-----------------------------
  On Error GoTo errLOG
  
  System.Cursor = wdCursorWait
  Application.ScreenUpdating = False
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

Public Sub EnableScreen()
  Const errIDMet As String = "07"
  '-----------------------------
  On Error GoTo errLOG
  
  System.Cursor = wdCursorNormal
  Application.ScreenUpdating = True
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

Public Function ChangeAttribute(conf As clsConfig, listbar As clsListBar, linkl As clsLkList, listattr As clsAttrList, i As clsInterface, issuel As clsIssueList, Optional fPos As Long, Optional id As String) As Boolean
  Dim ch As String, text As String, iRange As Long, fRange As Long
  Dim st As Long, tagMarkup As String, b As New clsLink
  Static tg As String
  Const errIDMet As String = "08"
  '-----------------------------
  On Error GoTo errLOG
  
  ChangeAttribute = True
  With selection
    If .start = .End Then
      ChangeAttribute = False
    Else
      text = Trim$(.text)
      If listbar.FoundTag(text) = False Then
        ChangeAttribute = False
      Else
        iRange = .start - 1: st = iRange
        If ActiveDocument.range(start:=iRange, End:=iRange + 1).text = conf.slash Then
          ChangeAttribute = False
        Else
          Do
            With ActiveDocument
              ch = .range(start:=st, End:=st + 1)
              st = st + 1
            End With
          Loop While ch <> conf.TAGC
          fRange = st: fPos = st
          Select Case text
            Case "translat"
            Case "article", "text"
              frmArticle.flagChange = True
              With i
                .SetFrmArticle issuel, listattr, text
                .ShowFrmArticleEdit conf, ActiveDocument.range(start:=iRange, End:=fRange).text, listattr
                If frmArticle.flagOK = True Then
                  .ExitFrmArticle conf, listattr, issuel, id
                  tagMarkup = BuildStartTag(text, conf, , , i)
                  DisableScreen
                  ActiveDocument.range(start:=iRange, End:=fRange).text = tagMarkup
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
                    .ShowFrmAttribute conf
                  Else
                    frmAttribute.flagOK = True
                  End If
                  If frmAttribute.flagOK = True Then
                    .ExitFrmAttribute listattr
                    tagMarkup = BuildStartTag(text, conf, listattr, linkl, i)
                    DisableScreen
                    ActiveDocument.range(start:=iRange, End:=fRange).text = tagMarkup
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
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set b = Nothing
End Function

Public Function VerifyInsertInto(conf As clsConfig, listbar As clsListBar) As Boolean
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

Public Function VerifyHierarchy(conf As clsConfig, listbar As clsListBar, currentBar As String, tag As String) As Boolean
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
  DisableScreen
  With selection
    iRange = .start: fRange = .End
  End With
  If TestExistTag(conf, listbar) = True Then
    With selection
      .start = iRange: .End = iRange
    End With
    If currentBar = "ifloat" Then
      If TestExistFloat(listbar, bar, conf, currentBar, tag) = True Then
        ok1 = True: ok2 = True
      Else
        ok1 = False: ok2 = False
      End If
    Else
      With selection
        .start = iRange: .End = iRange
      End With
      If FindTag(listbar, conf, False, start, previousText) = True Then
        If start = True Then
          If TestFatherTag(listbar, previousText, tag, bar) = False Then
            ok1 = False
          End If
        Else
          If TestOwnSisterTag(listbar, conf, previousText, tag, bar, False) = False Then
            ok1 = False
          End If
        End If
        With selection
          .start = fRange: .End = fRange
        End With
        If FindTag(listbar, conf, True, start, nextText) = True Then
          If start = True Then
            If TestOwnSisterTag(listbar, conf, nextText, tag, bar, True) = False Then
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
  EnableScreen
  '-----------------
  Set bar = Nothing: Set button = Nothing
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  EnableScreen
  '-----------------
  Set bar = Nothing: Set button = Nothing
End Function



Public Sub BuildLog(conf As clsConfig, attl As clsAttrList)
  Dim Filename As String, metUnit As Double, f As Integer
  Const errIDMet As String = "10"
  '-----------------------------
  On Error GoTo errLOG
  
  'metUnit = 1048576 '1024 X 1024 -> MB
  
  f = FreeFile
  Filename = ActiveDocument.FullName
  Filename = BuildFilePathName(Filename, "log")
  With conf
    .SetLastHour
    Open Filename For Append As #f
    Print #f, "Responsible: "; .GetResponsible
    Print #f, "System Date: "; Date
    With ActiveDocument
      Print #f,
      Print #f, "File Name: "; .FullName
      Print #f, "File Size Before (bytes): "; str$(conf.fileSize)
      Print #f, "File Size After (bytes): "; str$(FileLen(.FullName))
      Print #f, "Pages Number: "; .ComputeStatistics(wdStatisticPages)
      Print #f,
      Print #f, "References Number: "; attl.ReturnAttr("count").lastInsertedValue
      With conf
        Print #f, "Initial Time: "; .GetFirstHour
        Print #f, "Final Time: "; .GetLastHour
        Print #f, "Markup Time: "; .GetMarkupTime
        Print #f, String(80, "*")
      End With
    End With
    Close #f
  End With
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Close #f
End Sub

Public Sub UpLevel(bar As clsBar)
  Const errIDMet As String = "11"
  '-----------------------------
  On Error GoTo errLOG
  
  DisableScreen
  With bar
    DisplayBar .GetName, False
    'DisplayBar .getUpLevel, True
    DisplayBar navegation.getUpLevel(), True

  End With
  EnableScreen
  Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  EnableScreen
  Set conf = Nothing
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
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
    EnableScreen
  Set conf = Nothing
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
          Case "ifloat", "aff", "tabwrap", "figgrp", "cltrial", "xref", "uri"
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
            CommandBars(barName).Visible = False
            
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
MsgBox err.Description

  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub
Public Function readFormat(conf As clsConfig) As Integer
  Dim f As Integer, aux1 As String, aux2 As String
  Dim token As New clsToken
  Const Path As String = "number.mds"
  
  f = FreeFile
  Open conf.directory & Path For Input As #f
  Input #f, aux1
  Close #f
  With token
    .GetTokens aux1, aux2: .GetTokens aux1, aux2
  End With
  readFormat = val(Trim$(aux2))
End Function

Public Function getUsingSaveFormat(conf As clsConfig) As Integer
  Dim Format As Integer
  Format = readFormat(conf)
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
Public Function VerifyDocumentHTMLFormat(conf As clsConfig) As Boolean
  Dim f As Integer, fileFormatInNumber As Integer, fileFormatInTestHTML As Integer
  Dim token As New clsToken
  Const Path As String = "number.mds"
  Const test As String = "test.html"
  Const errIDMet As String = "14"
  '-----------------------------
  On Error GoTo errLOG
  
  VerifyDocumentHTMLFormat = False
  fileFormatInNumber = readFormat(conf)
  'valor 22 representa o formato htm\html
  
  If Documents.count = 1 Then
    If checkReadFormat(ActiveDocument.SaveFormat, fileFormatInNumber) Then
      VerifyDocumentHTMLFormat = True
    Else
      DisableScreen
      Documents.Open conf.directory & test
      fileFormatInTestHTML = ActiveDocument.SaveFormat
      
      ActiveDocument.Close savechanges:=wdDoNotSaveChanges
      If fileFormatInNumber <> fileFormatInTestHTML Then
        f = FreeFile
        Open conf.directory & Path For Output As #f
        Print #f, "saveformat"; ";"; fileFormatInTestHTML
        Close #f
        VerifyDocumentHTMLFormat = True
        EnableScreen
      End If
    End If
  End If
  Set token = Nothing
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Close #f
  Set token = Nothing
End Function

Public Sub ChangeSTAGO_TAGC(conf As clsConfig, listbar As clsListBar)
  Dim ok As Boolean, slash As Boolean, okFind As Boolean
  Dim iFind As Long, fFind As Long, text As String
  Dim pSpace As Long, itIsNotTag As Boolean
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
              pSpace = InStr(myReplace(.range(start:=iFind, End:=fFind).text, Chr(160), Chr(32)), Space(1))
              If pSpace <> 0 Then
                text = Mid$(.range(start:=iFind, End:=fFind).text, 1, pSpace - 1)
                If text = "cited" Then
                    itIsNotTag = (InStr(.range(start:=iFind, End:=fFind).text, "dateiso=") = 0)
                End If
                
                If listbar.FoundTag(text) = False Or itIsNotTag Then
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
                itIsNotTag = (text = "abstract")
                If listbar.FoundTag(text) = False Or itIsNotTag Then
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

Public Sub ChangeFields(conf As clsConfig)
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

Public Sub ChangeHtmlMarkup(conf As clsConfig)
  Const errIDMet As String = "17"
  '-----------------------------
  On Error GoTo errLOG
  
  If ActiveWindow.ActivePane.View.ShowAll = False Then
    ActiveWindow.ActivePane.View.ShowAll = True
  End If
  selection.find.ClearFormatting
  selection.find.Style = ActiveDocument.Styles("HTML Markup")
  selection.find.Replacement.ClearFormatting
  With selection.find
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

Public Sub ChangeEntity(conf As clsConfig)
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

Public Function FindTag(listbar As clsListBar, conf As clsConfig, forward As Boolean, start As Boolean, tag As String, Optional sX As Long, Optional fX As Long) As Boolean
  Dim iFind As Long, fFind As Long, pos As Integer, ok As Boolean
  Const errIDMet As String = "19"
  '-----------------------------
  On Error GoTo errLOG
  '-------------------
  FindTag = True: ok = False
  While ok = False
    Select Case forward
      Case True
        If findText(conf.STAGO, forward) = True Then
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
            If findText(conf.TAGC, forward) = True Then
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
        If findText(conf.TAGC, forward) = True Then
          fFind = selection.start
          With selection
            .End = .start
          End With
          If findText(conf.STAGO, forward) = True Then
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

Public Function findText(ByVal t As String, f As Boolean, Optional sPos As Long, Optional fPos As Long) As Boolean
  Const errIDMet As String = "20"
  '-----------------------------
  On Error GoTo errLOG
  
  findText = False
  With selection.find
    .text = t: .Replacement.text = "":  .forward = f
    .Wrap = wdFindStop: .Format = False: .MatchCase = False
    .MatchWholeWord = False: .MatchWildcards = False
    .MatchSoundsLike = False: .MatchAllWordForms = False
  End With
  selection.find.Execute
  If selection.find.found = True Then
    With selection
      sPos = .start + 1: fPos = .End - 1
    End With
    findText = True
  End If
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

Public Function TestExistTag(conf As clsConfig, listbar As clsListBar) As Boolean
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
  
    If FindTag(listbar, conf, True, start, tag) = True Then
    
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

Public Function TestExistFloat(listbar As clsListBar, bar As clsBar, conf As clsConfig, currentBar As String, tagInsert As String) As Boolean
  Dim button As New clsButton, tag As String, start As Boolean
  Dim barAux As New clsBar, pilha As New collection
  Dim i As Integer
  Const errIDMet As String = "22"
  '-----------------------------
  On Error GoTo errLOG
  
  TestExistFloat = True
  Set barAux = bar: pilha.add barAux
  
  If FindTag(listbar, conf, False, start, tag) = True Then
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
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing: Set button = Nothing
End Function

Public Function TestOwnSisterTag(listbar As clsListBar, conf As clsConfig, tagFind As String, tagInsert As String, bar As clsBar, forward As Boolean) As Boolean
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
          If FindTag(listbar, conf, forward, start, tag) = True Then
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
  With selection
    .MoveDown unit:=wdLine, count:=1
    .MoveUp unit:=wdLine, count:=1
  End With
  EnableScreen
End Function

Function getContent(tag As String, conf As clsConfig) As String
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


Private Function myFindTag(myString As String, ByRef selectedRange As range) As Boolean
    
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



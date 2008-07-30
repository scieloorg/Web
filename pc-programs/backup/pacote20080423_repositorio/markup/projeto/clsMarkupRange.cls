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

Private mvarconf As clsConfig
Private mvarMyRange As range

Public Property Set MyRange(v As range)
    Set mvarMyRange = v
End Property
Public Property Get MyRange() As range
    Set MyRange = mvarMyRange
End Property

Public Property Set Conf(v As clsConfig)
    Set mvarconf = v
End Property
Public Property Get Conf() As clsConfig
    Set Conf = mvarconf
End Property

'inuse
Public Function InsertTag(doc As range, tag As String, colorI As Long, attributes As String, Optional attl As clsAttrList, Optional linkl As clsLkList, Optional inter As clsInterface, Optional button As clsButton) As Boolean
  Dim sTag As String, fTag As String
  Dim range As range
  Dim pend As Long
  
  
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo ERRLOG
  
  With doc
    sTag = BuildStartTag(tag, attributes, attl, linkl, inter)
    fTag = BuildFinishTag(tag)
   
    If tag = "p" Then
        doc.End = doc.End - 1
    End If
    If tag = "table" Then
        doc.start = doc.start - 1
    End If
    
    .InsertBefore sTag
    .InsertAfter fTag
    pend = .End
    
    Call .SetRange(.start, .start + Len(sTag))
    FormatText doc, colorI
    
    Call .SetRange(pend - Len(fTag), pend)
    FormatText doc, colorI
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Public Function DeleteTag(listBar As clsListBar, Optional tagDel As String) As Boolean
  Dim st As Long, iRange As Long, fRange As Long, tRange As Long
  Dim tag As String, text As String, iStart As Long, textFound As String
  Dim iDel As Long, fDel As Long, i As Long, slash As Boolean
  Dim ok As Boolean, pilha As New collection, coord As New collection
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo ERRLOG
  
  DeleteTag = True: DisableScreen
  ok = False
  With selection
    If .start = .End Then
      MsgBox Conf.msgDeleting, vbCritical + vbOKOnly, Conf.titleDelete
      DeleteTag = False
    Else
      tag = Trim$(selection.text)
      If .start <> 0 Then
        text = ActiveDocument.range(start:=.start - 1, End:=.start).text
      End If
      If listBar.FoundTag(tag) = False Or text = Conf.slash Then
        MsgBox Conf.msgDeleting, vbCritical + vbOKOnly, Conf.titleDelete
        DeleteTag = False
      Else
        tagDel = tag
        iRange = .start: st = iRange - 1: .start = .End: iStart = st
        selection.find.ClearFormatting
        With selection.find
          .text = Conf.ETAGO & tag & Conf.TAGC
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
                Loop While text <> Conf.TAGC
                fDel = st
                .range(start:=iDel, End:=fDel).Delete
              End With
            Case Else
              MsgBox Conf.msgDeleting, vbCritical + vbOKOnly, Conf.titleDelete
              DeleteTag = False
          End Select
        Else
          tRange = .End
          With selection
            .start = iStart: .End = iStart
          End With
          While ok = False
            selection.find.ClearFormatting
            With selection.find
              .text = Conf.STAGO
              .Replacement.text = "": .forward = True: .Wrap = wdFindStop
              .Format = False: .MatchCase = False: .MatchWholeWord = False
              .MatchWildcards = False: .MatchSoundsLike = False
              .MatchAllWordForms = False
            End With
            selection.find.Execute
            iDel = selection.start: iRange = iDel + 1
            If ActiveDocument.range(start:=iDel + 1, End:=iDel + 2).text = Conf.slash Then
              slash = True: iRange = iDel + 2
            Else
              slash = False
            End If
            With selection
              .start = .End
            End With
            selection.find.ClearFormatting
            With selection.find
              .text = Conf.TAGC
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
            If listBar.FoundTag(textFound) = True Then
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
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  EnableScreen
  Set pilha = Nothing: Set coord = Nothing
End Function
'inuse
Public Sub FormatText(txt As range, color As Long)
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo ERRLOG
  
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
ERRLOG:
  
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
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
  On Error GoTo ERRLOG
  
  StartTag = Conf.STAGO & tag & Space(1)
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
  StartTag = StartTag & Conf.TAGC: StartTag = Trim$(StartTag)

  BuildStartTag = StartTag
  
  Set l = Nothing: Set at = Nothing: Set listPeriod = Nothing
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set l = Nothing: Set at = Nothing: Set listPeriod = Nothing
End Function
'inuse
Public Function BuildFinishTag(tag As String) As String
  Dim finishTag As String
  Const errIDMet As String = "05"
  '-----------------------------
  On Error GoTo ERRLOG
  
  Select Case tag
    Case "head", "dperiod", "deposit"
      'empty tag
    Case Else
      With Conf
        finishTag = finishTag & .ETAGO & tag & .TAGC
      End With
  End Select
  BuildFinishTag = finishTag
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Public Sub DisableScreen()
  Const errIDMet As String = "06"
  '-----------------------------
  On Error GoTo ERRLOG
  
  System.Cursor = wdCursorWait
  Application.ScreenUpdating = False
  Exit Sub
ERRLOG:
  
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
  On Error GoTo ERRLOG
  
  System.Cursor = wdCursorNormal
  Application.ScreenUpdating = True
  Exit Sub
ERRLOG:
  
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub



Public Function CheckInsertTag(range As range, tag As String) As Boolean
    Dim p As Long
    Dim r As Boolean
    Dim originalStart As Long, originalEnd As Long
    
    p = range.start
    originalStart = range.start
    originalEnd = range.End
    
    Call range.SetRange(p - 1, 1)
    If range.text <> Conf.TAGC Then
        r = True
    Else
        p = p - 1
        Call range.SetRange(p, 1)
        While p > 0 And range.text <> Conf.STAGO
            p = p - 1
            Call range.SetRange(p, 1)
        Wend
        If p > 0 And range.text = Conf.STAGO Then
        
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

Public Function VerifyInsertInto(listBar As clsListBar) As Boolean
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
    count = count + 1
  Wend
  If okTAGC = False Or okSTAGO = False Then
    text = ActiveDocument.range(start:=iRange, End:=fRange).text
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
    With selection
      .End = .start
    End With
  End If
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Public Function VerifyHierarchy(listBar As clsListBar, currentBar As String, tag As String) As Boolean
  Dim iRange As Long, fRange As Long, start As Boolean
  Dim previousText As String, nextText As String
  Dim bar As New clsBar, button As New clsButton
  Dim ok1 As Boolean, ok2 As Boolean
  Const errIDMet As String = "09"
  '-----------------------------
  On Error GoTo ERRLOG
  
  ok1 = True: ok2 = True
  Set bar = listBar.ReturnBar(currentBar)
  '--------------------
  If currentBar = "start" Then 'Or currentBar = "ifloat" Then
    VerifyHierarchy = True: Exit Function
  End If
  DisableScreen
  With selection
    iRange = .start: fRange = .End
  End With
  If TestExistTag(listBar) = True Then
    With selection
      .start = iRange: .End = iRange
    End With
    If currentBar = "ifloat" Then
      If TestExistFloat(listBar, bar, currentBar, tag) = True Then
        ok1 = True: ok2 = True
      Else
        ok1 = False: ok2 = False
      End If
    Else
      With selection
        .start = iRange: .End = iRange
      End With
      If FindTag(listBar, False, start, previousText) = True Then
        If start = True Then
          If TestFatherTag(listBar, previousText, tag, bar) = False Then
            ok1 = False
          End If
        Else
          If TestOwnSisterTag(listBar, previousText, tag, bar, False) = False Then
            ok1 = False
          End If
        End If
        With selection
          .start = fRange: .End = fRange
        End With
        If FindTag(listBar, True, start, nextText) = True Then
          If start = True Then
            If TestOwnSisterTag(listBar, nextText, tag, bar, True) = False Then
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
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  EnableScreen
  '-----------------
  Set bar = Nothing: Set button = Nothing
End Function

Public Sub BuildLog(attl As clsAttrList)
  Dim filename As String, metUnit As Double, f As Integer
  Const errIDMet As String = "10"
  '-----------------------------
  On Error GoTo ERRLOG
  
  'metUnit = 1048576 '1024 X 1024 -> MB
  
  f = FreeFile
  filename = ActiveDocument.FullName
  filename = BuildFilePathName(filename, "log")
  With Conf
    .SetLastHour
    Open filename For Append As #f
    Print #f, "Responsible: "; .GetResponsible
    Print #f, "System Date: "; Date
    With ActiveDocument
      Print #f,
      Print #f, "File Name: "; .FullName
      Print #f, "File Size Before (bytes): "; str$(Conf.fileSize)
      Print #f, "File Size After (bytes): "; str$(FileLen(.FullName))
      Print #f, "Pages Number: "; .ComputeStatistics(wdStatisticPages)
      Print #f,
      Print #f, "References Number: "; attl.ReturnAttr("count").lastInsertedValue
      With Conf
        Print #f, "Initial Time: "; .GetFirstHour
        Print #f, "Final Time: "; .GetLastHour
        Print #f, "Markup Time: "; .GetMarkupTime
        Print #f, String(80, "*")
      End With
    End With
    Close #f
  End With
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Close #f
End Sub

Public Sub UpLevel(bar As clsBar)
  Const errIDMet As String = "11"
  '-----------------------------
  On Error GoTo ERRLOG
  
  DisableScreen
  With bar
    DisplayBar .GetName, False
    DisplayBar .getUpLevel, True
  End With
  EnableScreen
  Exit Sub
ERRLOG:
  
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
  On Error GoTo ERRLOG
  
  DisableScreen
  DisplayBar bar.GetName, False
  DisplayBar button.GetDownLevel, True
  EnableScreen
  Exit Sub
ERRLOG:
  
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
  On Error GoTo ERRLOG
  
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
ERRLOG:
  
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub

Public Function readFormat() As Integer
  Dim f As Integer, aux1 As String, aux2 As String
  Dim token As New clsToken
  Const path As String = "number.mds"
  
  f = FreeFile
  Open Conf.directory & path For Input As #f
  Input #f, aux1
  Close #f
  With token
    .GetTokens aux1, aux2: .GetTokens aux1, aux2
  End With
  readFormat = val(Trim$(aux2))
End Function

Public Function getUsingSaveFormat() As Integer
  Dim Format As Integer
  Format = readFormat()
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
Public Function VerifyDocumentHTMLFormat() As Boolean
  Dim f As Integer, fileFormatInNumber As Integer, fileFormatInTestHTML As Integer
  Dim token As New clsToken
  Const path As String = "number.mds"
  Const test As String = "test.html"
  Const errIDMet As String = "14"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifyDocumentHTMLFormat = False
  fileFormatInNumber = readFormat()
  'valor 22 representa o formato htm\html
  
  If Documents.count = 1 Then
    If checkReadFormat(ActiveDocument.SaveFormat, fileFormatInNumber) Then
      VerifyDocumentHTMLFormat = True
    Else
      DisableScreen
      Documents.Open Conf.directory & test
      fileFormatInTestHTML = ActiveDocument.SaveFormat
      
      ActiveDocument.Close savechanges:=wdDoNotSaveChanges
      If fileFormatInNumber <> fileFormatInTestHTML Then
        f = FreeFile
        Open Conf.directory & path For Output As #f
        Print #f, "saveformat"; ";"; fileFormatInTestHTML
        Close #f
        VerifyDocumentHTMLFormat = True
        EnableScreen
      End If
    End If
  End If
  Set token = Nothing
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Close #f
  Set token = Nothing
End Function


Public Sub ChangeSTAGO_TAGC(listBar As clsListBar)
  Dim ok As Boolean, slash As Boolean, okFind As Boolean
  Dim iFind As Long, fFind As Long, text As String
  Const errIDMet As String = "15"
  '-----------------------------
  On Error GoTo ERRLOG
  
  ActiveWindow.DisplayVerticalScrollBar = False
  With selection
    .start = 0: .End = 0
  End With
  ok = True
  While ok = True
    okFind = False
    selection.find.ClearFormatting
    With selection.find
      .text = Conf.STAGO: .Replacement.text = "": .forward = True
      .Wrap = wdFindStop: .Format = False: .MatchCase = False
      .MatchWholeWord = False: .MatchWildcards = False
      .MatchSoundsLike = False: .MatchAllWordForms = False
    End With
    selection.find.Execute
    If selection.find.found = True Then
      iFind = selection.End
      text = ActiveDocument.range(start:=iFind, End:=iFind + 1).text
      Select Case text
        Case Conf.slash
          slash = True: iFind = iFind + 1
        Case Else
          slash = False
      End Select
      With selection
        .start = .End
      End With
      selection.find.ClearFormatting
      With selection.find
        .text = Conf.TAGC: .Replacement.text = "": .forward = True
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
            If listBar.FoundTag(text) = False Then
              With ActiveDocument
                If InStr(.range(start:=iFind, End:=fFind).text, Conf.STAGO) = 0 Then
                  .range(start:=fFind, End:=fFind + 1).text = Conf.entityTAGC
                End If
                .range(start:=iFind - 1, End:=iFind).text = Conf.entitySTAGO
                okFind = True
              End With
            End If
          Case False
            With ActiveDocument
              If InStr(.range(start:=iFind, End:=fFind).text, Space(1)) <> 0 Then
                text = Mid$(.range(start:=iFind, End:=fFind).text, 1, InStr(.range(start:=iFind, End:=fFind).text, Space(1)) - 1)
                If listBar.FoundTag(text) = False Then
                  With ActiveDocument
                    If InStr(.range(start:=iFind, End:=fFind).text, Conf.STAGO) = 0 Then
                      .range(start:=fFind, End:=fFind + 1).text = Conf.entityTAGC
                    End If
                    .range(start:=iFind - 1, End:=iFind).text = Conf.entitySTAGO
                    okFind = True
                  End With
                End If
              Else
                text = ActiveDocument.range(start:=iFind, End:=fFind).text
                If listBar.FoundTag(text) = False Then
                  With ActiveDocument
                    If InStr(.range(start:=iFind, End:=fFind).text, Conf.STAGO) = 0 Then
                      .range(start:=fFind, End:=fFind + 1).text = Conf.entityTAGC
                    End If
                    .range(start:=iFind - 1, End:=iFind).text = Conf.entitySTAGO
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
      .text = Conf.TAGC: .Replacement.text = "": .forward = False
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
        .text = Conf.STAGO: .Replacement.text = "": .forward = False
        .Wrap = wdFindStop: .Format = False: .MatchCase = False
        .MatchWholeWord = False: .MatchWildcards = False
        .MatchSoundsLike = False: .MatchAllWordForms = False
      End With
      selection.find.Execute
      If selection.find.found = True Then
        iFind = selection.End
        text = ActiveDocument.range(start:=iFind, End:=iFind + 1).text
        Select Case text
          Case Conf.slash
            slash = True: iFind = iFind + 1
          Case Else
            slash = False
        End Select
        Select Case slash
          Case True
            text = ActiveDocument.range(start:=iFind, End:=fFind).text
            If listBar.FoundTag(text) = False Then
              With ActiveDocument
                If InStr(.range(start:=iFind, End:=fFind).text, Conf.TAGC) <> 0 Then
                  .range(start:=fFind, End:=fFind + 1).text = Conf.entityTAGC
                End If
                okFind = True
              End With
            End If
          Case False
            With ActiveDocument
              With ActiveDocument
                If InStr(.range(start:=iFind, End:=fFind).text, Conf.TAGC) <> 0 Then
                  .range(start:=fFind, End:=fFind + 1).text = Conf.entityTAGC
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
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Sub

Public Sub ChangeFields()
  Const errIDMet As String = "16"
  '-----------------------------
  On Error GoTo ERRLOG
  
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
  selection.find.Execute Replace:=wdReplaceAll
  ActiveWindow.ActivePane.View.ShowAll = False
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  ActiveWindow.ActivePane.View.ShowAll = False
End Sub

Public Sub ChangeHtmlMarkup()
  Const errIDMet As String = "17"
  '-----------------------------
  On Error GoTo ERRLOG
  
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
  selection.find.Execute Replace:=wdReplaceAll
  ActiveWindow.ActivePane.View.ShowAll = False
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  ActiveWindow.ActivePane.View.ShowAll = False
End Sub

Public Sub ChangeEntity()
'opcao = 0  -> troca colchetes por entidade
'opcao = 1  -> troca entidade por colchetes
  Dim Texto As range
  Dim dash(1) As String
  Dim i As Integer
  Const errIDMet As String = "18"
  '-----------------------------
  On Error GoTo ERRLOG
  
  dash(0) = "^+": dash(1) = "^="
  '0 - em dash | 1 - en dash
  '----------------------------------------------
  'esta macro tem por finalidade trocar os caracteres '[' ']'
  'por entidades, afim de evitar problemas com os delimitadore
  'da tag da marcacao.
  'nessa funcao, troca-se en dash e em dash por hifen, tb.
  Set Texto = ActiveDocument.content
  For i = 0 To 1
    With Texto
      .find.Execute findText:=dash(i), replacewith:="-", Replace:=wdReplaceAll
      'troca en dash e em dash por hifen
    End With
  Next i
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Sub

Public Function FindTag(listBar As clsListBar, forward As Boolean, start As Boolean, tag As String, Optional sX As Long, Optional fX As Long) As Boolean
  Dim iFind As Long, fFind As Long, pos As Integer, ok As Boolean
  Dim a As Long, b As Long
  
  Const errIDMet As String = "19"
  '-----------------------------
  On Error GoTo ERRLOG
  '-------------------
  FindTag = True: ok = False
  While ok = False
    Select Case forward
      Case True
        If findText(mvarconf.STAGO, forward, a, b) = True Then
          With ActiveDocument
            iFind = selection.End
            If .range(start:=iFind, End:=iFind + 1).text = Conf.slash Then
              iFind = selection.End + 1
              start = False
            Else
              start = True
            End If
            With selection
              .start = .End
            End With
            If findText(Conf.TAGC, forward, a, b) = True Then
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
        If findText(Conf.TAGC, forward, a, b) = True Then
          fFind = selection.start
          With selection
            .End = .start
          End With
          If findText(Conf.STAGO, forward, a, b) = True Then
            With ActiveDocument
              iFind = selection.End
              If .range(start:=iFind, End:=iFind + 1).text = Conf.slash Then
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
        If listBar.FoundTag(tag) = True Then
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
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Public Function findText(t As String, f As Boolean, ByRef sPos As Long, ByRef fPos As Long) As Boolean
  Const errIDMet As String = "20"
  '-----------------------------
  On Error GoTo ERRLOG
  
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
      sPos = .start: fPos = .start + Len(t)
    End With
    findText = True
  End If
  Exit Function
ERRLOG:
  
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Function

Public Function TestExistTag(listBar As clsListBar) As Boolean
  Dim finishPos As Long, tag As String, start As Boolean
  Dim button As New clsButton, pilha As New collection
  Const errIDMet As String = "21"
  '-----------------------------
  On Error GoTo ERRLOG
  
  TestExistTag = True
  With selection
    finishPos = .End
    .End = .start
  End With
  While selection.End <= finishPos
    If FindTag(listBar, True, start, tag) = True Then
      If selection.End <= finishPos Then
        If start = True Then
          If listBar.FoundTag(tag) = True Then
            Set button = listBar.ReturnBar("ifloat").ReturnButton(tag)
            If button.GetTag = Empty Then
              If pilha.count = 0 Then
                TestExistTag = False: Exit Function
              End If
            Else
              pilha.add button
            End If
          End If
        Else
          If listBar.FoundTag(tag) = True Then
            Set button = listBar.ReturnBar("ifloat").ReturnButton(tag)
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
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set button = Nothing: Set pilha = Nothing
End Function

Public Function TestExistFloat(listBar As clsListBar, bar As clsBar, currentBar As String, tagInsert As String) As Boolean
  Dim button As New clsButton, tag As String, start As Boolean
  Dim barAux As New clsBar, pilha As New collection
  Dim i As Integer
  Const errIDMet As String = "22"
  '-----------------------------
  On Error GoTo ERRLOG
  
  TestExistFloat = True
  Set barAux = bar: pilha.add barAux
  If FindTag(listBar, False, start, tag) = True Then
    If start = True Then
      With pilha
        While .count > 0
          Set barAux = .Item(.count): .remove (.count)
          Set button = barAux.ReturnButton(tag)
          If button.GetTag = Empty Then
            For i = 1 To barAux.LenListOfButton
              Set button = barAux.ReturnButton(str$(i))
              If button.GetDownLevel <> Empty Then
                pilha.add listBar.ReturnBar(button.GetDownLevel)
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
                  pilha.add listBar.ReturnBar(button.GetDownLevel)
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
ERRLOG:
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
  On Error GoTo ERRLOG
  
  TestFatherTag = False
  Set button = listBar.ReturnBar(bar.getUpLevel).ReturnButton(tagFind)
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
ERRLOG:
  
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing: Set button = Nothing
End Function

Public Function TestOwnSisterTag(listBar As clsListBar, tagFind As String, tagInsert As String, bar As clsBar, forward As Boolean) As Boolean
  Dim button As New clsButton, ok As Boolean, tag As String, start As Boolean
  Dim pilha As New collection, aux As String
  Const errIDMet As String = "24"
  '-----------------------------
  On Error GoTo ERRLOG
  
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
          If FindTag(listBar, forward, start, tag) = True Then
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
ERRLOG:
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
  With selection
    .MoveDown unit:=wdLine, count:=1
    .MoveUp unit:=wdLine, count:=1
  End With
  EnableScreen
End Function

Function getContent(tag As String) As String
    Dim tagstart As String
    Dim tagend As String
    Dim sPos As Long, ePos As Long
    
        
    tagstart = Conf.STAGO + tag
    tagend = Conf.ETAGO + tag + Conf.TAGC
    
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

Function getNodeAndConvert2XML(tag As String, doc As Document) As String
    Dim tagstart As String
    Dim tagend As String
    Dim sPos As Long, ePos As Long
    
    Dim range_start As Long, range_end As Long
        
    Dim selectedRange As range
    Dim content As String
       
    tagstart = Conf.STAGO + tag
    tagend = Conf.ETAGO + tag + Conf.TAGC
    
    range_start = doc.range.start
    range_end = doc.range.End
    Set selectedRange = doc.range
    
    If myFindTag(tagstart, selectedRange) Then
        sPos = selectedRange.start
        
        Set selectedRange = doc.range(range_start, range_end)
        If myFindTag(tagend, selectedRange) Then
            ePos = selectedRange.End
            
        End If
    End If
    'MsgBox sPos & " " & ePos
    If sPos > 0 And ePos > sPos Then
        
        
        content = doc.range(sPos, ePos).text
    
        content = myReplace(content, "<", "&lt;")
        content = myReplace(content, ">", "&gt;")
        content = myReplace(content, "&", "&amp;")
        
        content = myReplace(content, "[", "<")
        content = myReplace(content, "]", ">")
    End If
    
    
    getNodeAndConvert2XML = content
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

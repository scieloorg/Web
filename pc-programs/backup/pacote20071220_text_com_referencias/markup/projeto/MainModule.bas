Attribute VB_Name = "MainModule"
Private mErr As New clsErrList
Const errIDObj As String = "102"

Public MarkupPrg As String
Public isAhead As Boolean
Public navegation As New clsBarNavegation
Public SafeExit As Boolean

Sub Main()
  Dim j As Integer
  Dim button As CommandBarButton
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  Static Conf As New clsConfig: Static listBar As New clsListBar
  Static listattr As New clsAttrList: Static listIssue As New clsIssueList
  Static listLink As New clsLkList: Static m As New clsMarkup
  Static bar As New clsBar: Static autoMarkup As New clsAutoMarkupList
  Static inter As New clsInterface: Static previousBar As New clsBar
  '----alteracao
  Static id As String
  '-------------
  Set button = CommandBars.ActionControl
  Set bar = listBar.ReturnBar(button.DescriptionText)
  '++++++++++++++++++++
  Dim template As template
  
  For Each template In Templates
    If template.Name = "markup.prg" Then
        MarkupPrg = template.Path & "\"
        'MsgBox MarkupPrg
    End If
  Next
  
  'Set Paths = New ColFileInfo
   ' Set Paths = ReadPathsConfigurationFile("..\scielo_paths.ini")
    
  
  Select Case button.TooltipText
    Case "Start Markup"
      SubStartMarkup Conf, listBar, m, listattr, listIssue, listLink, bar, autoMarkup, inter, id
      Set previousBar = bar
      With Templates
        For j = 1 To .Count
          If .Item(j).Name = Conf.prg_name Then
            '.Item(j).Save
            .Item(j).Saved = True
          End If
        Next j
      End With
      
      '---changes on 20020911 for supporting Word2000 and XP
      NormalTemplate.Saved = True
      '---
      
    Case Conf.buttonStop
      If SubStop(listBar, m, Conf, listattr, inter) = True Then
         SafeExit = True
        With Templates
          For j = 1 To .Count
            If .Item(j).Name = Conf.prg_name Then
              '.Item(j).Save
              .Item(j).Saved = True
            End If
          Next j
        End With
        
        '---changes on 20020911 for supporting Word2000 and XP
        NormalTemplate.Saved = True
        '---
        
        Set Conf = Nothing: Set listBar = Nothing: Set m = Nothing
        Set listattr = Nothing: Set listIssue = Nothing
        Set listLink = Nothing: Set bar = Nothing: Set mErr = Nothing
        Set autoMarkup = Nothing: Set inter = Nothing: Set previousBar = Nothing
        End
      End If
      
    Case Conf.buttonChange
      SubChange m, Conf, listBar, listLink, listattr, inter, listIssue, id
      m.RestoreScreen
      
    Case Conf.buttonDelete
      SubDelete m, Conf, listBar, bar, previousBar
      m.RestoreScreen
      
    Case Conf.buttonAutomatic
      SubAutomatic Conf, autoMarkup, inter, listBar, m, listattr, listLink, listIssue
      m.RestoreScreen
      
    Case Conf.buttonHelp
      SubHelp
      
    Case Conf.tooltipsDown
      SubDown m, listBar, bar, button
      Select Case bar.GetName
        Case "ifloat", "aff", "table", "figgrp"
          '--
        Case Else
          Set previousBar = bar
      End Select
      
    Case Conf.tooltipsUp
      SubUp m, listBar, bar
      Select Case bar.GetName
        Case "ifloat", "aff", "table", "figgrp"
          '--
        Case Else
          Set previousBar = bar
      End Select
      
    Case Else
      SubElse m, listBar, listLink, listIssue, listattr, Conf, inter, bar, button, id
      Select Case bar.GetName
        Case "ifloat", "aff", "table", "figgrp"
          '--
        Case Else
          Set previousBar = bar
      End Select
      m.RestoreScreen
      
  End Select
  
  Set button = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set button = Nothing
End Sub

Sub SubStartMarkup(Conf As clsConfig, listBar As clsListBar, m As clsMarkup, listattr As clsAttrList, listIssue As clsIssueList, listLink As clsLkList, bar As clsBar, autoMarkup As clsAutoMarkupList, inter As clsInterface, id As String)
  Dim text As String, iTag As Long, fTag As Long
  Dim stitle As String, i As Long, j As Long, Count As Long
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  With Conf
    .LoadPublicValues
    .SetFirstHour
  End With
'  MsgBox "Configuração carregada."
  listattr.LoadAttributes Conf
'  MsgBox "Atributos carregados."
  listIssue.LoadIssue Conf
'  MsgBox "Número carregado."
  listLink.LoadLink Conf
'   MsgBox "Links carregado."
  If m.VerifyDocumentHTMLFormat(Conf) = True Then
    With ActiveDocument
      Conf.fileSize = FileLen(.FullName)
      .UpdateStylesOnOpen = False
      .AttachedTemplate = ""
    End With
    With m
      .DisableScreen
      .ChangeEntity Conf
      .ChangeFields Conf
      '.ChangeHtmlMarkup conf
    End With
    With inter
      .DisableWordBars
    End With
    autoMarkup.LoadAutomata Conf
    'MsgBox "Autômata carregado."
  
    With listBar
      .LoadBars Conf
      .CreateBars Conf
      With m
        .DisplayBar "StartUp", False
        .DisplayBar "Markup", True
        .DisplayBar "ifloat", True
        .DisplayBar "Hide", True
      End With
      'MsgBox "Carregando arquivo..."
  
      .LoadTempFile
      Do
        Count = Count + 1
        text = Trim$(ActiveDocument.Paragraphs(Count).Range.text)
        Select Case text
          Case Empty, Chr(10), Chr(13)
          
          Case Else
            Exit Do
        End Select
      Loop
      iTag = InStr(text, Conf.STAGO)
      fTag = InStr(text, Space(1))
      If iTag > 0 And fTag > 0 Then
        text = Trim$(Mid$(text, iTag + 1, fTag - 1))
      End If
      'MsgBox "Arquivo carregado"
      
      If listBar.FoundTag(text) = False Then
        .EnableBar "Start": m.DisplayBar "Start", True
        Set bar = .ReturnBar("Start")
      Else
        Select Case text
          Case "article"
            .EnableBar "article": m.DisplayBar "article", True
            Set bar = .ReturnBar("article")
          Case "text"
            .EnableBar "textM": m.DisplayBar "textM", True
            Set bar = .ReturnBar("textM")
        End Select
        text = Trim$(ActiveDocument.Paragraphs(Count).Range.text)
        i = InStr(text, "stitle=") + 7
        'j = InStr(text, "volid=")
        If i = 0 Then 'Or j = 0 Then
          GoTo errLOG
        Else
          j = InStr(i, text, Chr(34), vbBinaryCompare)
          If j = i Then
            i = i + 1
            j = InStr(i, text, Chr(34), vbBinaryCompare)
          Else
            j = InStr(i, text, " ", vbTextCompare)
          End If
          text = Mid$(text, i, j - i)
          inter.stitle = text
          '---alteracao
          id = BuildID(m, text)
          '------------
        End If
      End If
    End With
    m.EnableScreen
  Else
    MsgBox Conf.msgOpenFile, vbCritical, Conf.titleOpenFile
    Set Conf = Nothing: Set listBar = Nothing: Set m = Nothing
    Set listattr = Nothing: Set listIssue = Nothing
    Set listLink = Nothing: Set bar = Nothing: Set mErr = Nothing
    Set autoMarkup = Nothing: Set inter = Nothing
    End
  End If
  '------------------
  Exit Sub
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  m.EnableScreen
End Sub

Function SubStop(listBar As clsListBar, m As clsMarkup, Conf As clsConfig, attl As clsAttrList, inter As clsInterface) As Boolean
  Dim ret As Long, pathTXT As String, pathHTM As String, saveAsFormat As Integer
  
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo errLOG
  
  SubStop = True
  With frmParser
    .Show
    If .flagOK = True Then
      Conf.SetLastHour
      m.DisableScreen
      With listBar
        .KillBars
        '.BuildTempFile
      End With
      inter.EnableWordBars
      With m
        'ActiveDocument.Save
        .BuildLog Conf, attl
        .DisplayBar "Markup", False
        .DisplayBar "StartUp", True
        .DisplayBar "Hide", False
        .DisplayBar "Fixed", False
      End With
      If .OB_Exit1.value = True Or .OB_EXit2.value = True Then
        saveAsFormat = m.getUsingSaveFormat(Conf)
        pathHTM = ActiveDocument.FullName
        With m
          .ChangeSTAGO_TAGC Conf, listBar
          'ActiveDocument.Save
          ActiveDocument.SaveAs filename:=pathHTM, FileFormat:=saveAsFormat
          .EnableScreen
        End With
        With ActiveDocument
          pathTXT = m.BuildFilePathName(pathHTM, "txt")
          .SaveAs filename:=pathTXT, FileFormat:=wdFormatText
          .Close
        End With
        If .OB_Exit1.value = True Then
            Documents.Open filename:=pathHTM
            'MsgBox conf.parser
            ret = Shell(Conf.parser & Space(1) & pathTXT, vbMaximizedFocus)
        Else
            Documents.Open filename:=pathTXT
            ret = True
        End If
      End If
    Else
      'ActiveDocument.Save
      SubStop = False
    End If
    Unload frmParser
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Sub SubStopOld(listBar As clsListBar, m As clsMarkup, Conf As clsConfig, attl As clsAttrList, inter As clsInterface)
  Dim ret As Integer, Path As String, i As Integer
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo errLOG
  
  If MsgBox(Conf.msgSureExit, vbYesNo + vbQuestion, Conf.titleFinish) = vbYes Then
    Conf.SetLastHour
    m.DisableScreen
    With listBar
      .KillBars
      '.BuildTempFile
    End With
    inter.EnableWordBars
    With m
      ActiveDocument.Save
      .BuildLog Conf, attl
      .DisplayBar "Markup", False
      .DisplayBar "StartUp", True
      .DisplayBar "Hide", False
    End With
    ret = MsgBox(Conf.msgMoreLater, vbYesNo + vbQuestion, Conf.titleFinish)
    Select Case ret
      Case vbYes
        'ActiveDocument.Save
        With m
          .ChangeSTAGO_TAGC Conf, listBar
          .EnableScreen
        End With
        With ActiveDocument
          Path = .FullName
          Path = Mid$(Path, 1, InStr(Path, ".")) & "txt"
          .SaveAs filename:=Path, FileFormat:=wdFormatText
          .Close
        End With
        Documents.Open filename:=Path
    End Select
    Exit Sub
  End If
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Sub

Sub SubChange(m As clsMarkup, c As clsConfig, lBar As clsListBar, lLink As clsLkList, lAttr As clsAttrList, i As clsInterface, lIssue As clsIssueList, id As String)
  Const errIDMet As String = "04"
  '-----------------------------
  On Error GoTo errLOG
  
  If m.ChangeAttribute(c, lBar, lLink, lAttr, i, lIssue, , id) = False Then
    MsgBox c.msgInserting, vbCritical + vbOKOnly, c.titleTag
  End If
  Exit Sub
errLOG:
  With mErr
    .LoadErr c
    .BuildLog errIDObj & errIDMet, c
  End With
End Sub

Sub SubDelete(m As clsMarkup, Conf As clsConfig, listBar As clsListBar, bar As clsBar, pBar As clsBar)
  Dim tag As String, returnMSG As Integer
  Dim b As New clsButton, i As Long
  Const errIDMet As String = "05"
  '-----------------------------
  On Error GoTo errLOG
  
  returnMSG = MsgBox(Conf.msgSure, vbYesNo, Conf.titleDelete)
  If returnMSG = vbYes Then
    If m.DeleteTag(Conf, listBar, tag) = True Then
      Select Case tag
        Case "article", "text"
          With m
            .DisplayBar pBar.GetName, False
            .DisplayBar "start", True
          End With
      End Select
    End If
  End If
  Set b = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set b = Nothing
End Sub

Sub SubAutomatic(Conf As clsConfig, autoMarkup As clsAutoMarkupList, i As clsInterface, listBar As clsListBar, m As clsMarkup, listattr As clsAttrList, linkl As clsLkList, issuel As clsIssueList)
  Dim automata As New clsAutoMarkup, button As New clsButton
  Dim stitle As String, j As Long, scrollPercent As Long
  Dim startSel As Long, start As Boolean, tag As String
  Dim sX As Long, fX As Long, okChange As Boolean
  Const errIDMet As String = "06"
  '-----------------------------
  On Error GoTo errLOG
  
  scrollPercent = ActiveWindow.VerticalPercentScrolled
  With i
    If InStr(.stitle, Chr(34)) <> 0 Then
      stitle = Mid$(.stitle, 2, Len(.stitle) - 2)
    Else
      stitle = .stitle
    End If
  End With
  Set automata = autoMarkup.ReturnAutomata(stitle)
  If automata.stitle <> Empty Then
    With Selection
      If .start <> .End Then
        For j = 1 To listBar.LenListOfBar
          Set button = listBar.ReturnBar(str$(j)).ReturnButton(automata.initialTag)
          If button.GetTag <> Empty Then
            Exit For
          End If
        Next j
        If j <= listBar.LenListOfBar Then
          If m.VerifyInsertInto(Conf, listBar) = True Then
            If m.VerifyHierarchy(Conf, listBar, listBar.ReturnBar(str$(j)).GetName, automata.initialTag) = True Then
              startSel = Selection.start
              If Markup(Conf.directory & automata.automataFile, Conf.directory & Conf.fileTagsAutomata & automata.tagsFile, automata.initialTag) <> Empty Then
                With Selection
                  .start = startSel: .End = .start
                End With
                m.DisableScreen
                Do
                  m.FindTag listBar, Conf, True, start, tag, sX, fX
                  If start = False And tag = automata.initialTag Then
                    With Selection
                      .start = .End + 1
                    End With
                    Exit Do
                  Else
                    With Selection
                      .start = sX: .End = fX
                    End With
                    m.ChangeAttribute Conf, listBar, linkl, listattr, i, issuel
                    With Selection
                      .start = fX: .End = fX
                    End With
                  End If
                Loop
              Else
                With Selection
                  .End = .start
                End With
              End If
            Else
              MsgBox Conf.msgInserting, vbCritical, Conf.titleAttribute
            End If
          Else
            MsgBox Conf.msgInserting, vbCritical, Conf.titleAttribute
          End If
        Else
          MsgBox Conf.msgInserting, vbCritical, Conf.titleAttribute
        End If
      Else
        MsgBox Conf.msgSelection, vbCritical, Conf.titleAttribute
      End If
    End With
  Else
    MsgBox Conf.msgAutomaticErr, vbCritical, Conf.buttonAutomatic
  End If
  ActiveWindow.VerticalPercentScrolled = scrollPercent
  m.EnableScreen
  '---------------------
  Set automata = Nothing: Set button = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set automata = Nothing: Set button = Nothing
End Sub

Sub SubElse(m As clsMarkup, lBar As clsListBar, lLink As clsLkList, lIssue As clsIssueList, lAttr As clsAttrList, c As clsConfig, i As clsInterface, bar As clsBar, button As CommandBarButton, id As String)
  Dim b As New clsButton
  Dim ok As Boolean
  Const errIDMet As String = "07"
  '-----------------------------
  On Error GoTo errLOG
  
  Set b = bar.ReturnButton(button.Caption)
  With b
    Select Case .GetTag
      Case "article", "text"
        i.SetFrmArticle lIssue, lAttr, .GetTag
        i.ShowFrmArticle c
        If frmArticle.flagOK = True Then
          '---alteracao
          id = frmArticle.ComboBox_issueid.text
          '------------
          i.ExitFrmArticle c, lAttr, lIssue
          With m
            If .VerifyInsertInto(c, lBar) = True Then
              If .VerifyHierarchy(c, lBar, bar.GetName, b.GetTag) = True Then
                ok = .InsertTag(b.GetTag, b.GetColor, c, , , i, b)
                If ok = True Then
                  If b.GetDownLevel <> Empty Then
                    .downLevel bar, b
                    Set bar = lBar.ReturnBar(b.GetDownLevel)
                  End If
                End If
              End If
            End If
          End With
        End If
        i.EndFrmArticle
      Case Else
        With m
          If .VerifyInsertInto(c, lBar) = True Then
            If .VerifyHierarchy(c, lBar, bar.GetName, b.GetTag) = True Then
              With i
                If lBar.ReturnBar(bar.GetName).ReturnButton(b.GetTag).GetAttrib = True Then
                  .SetFrmAttribute lAttr, lLink, b.GetTag, lIssue, id
                  .ShowFrmAttribute c
                  If frmAttribute.flagOK = True Then
                    .ExitFrmAttribute lAttr
                    ok = m.InsertTag(b.GetTag, b.GetColor, c, lAttr, lLink, i, b)
                    If ok = False Then
                      '
                    Else
                      If b.GetDownLevel <> Empty Then
                        m.downLevel bar, b
                        Set bar = lBar.ReturnBar(b.GetDownLevel)
                      End If
                    End If
                  End If
                  .EndFrmAttribute
                Else
                  ok = m.InsertTag(b.GetTag, b.GetColor, c, lAttr, lLink, i, b)
                  If ok = False Then
                    '
                  Else
                    If b.GetDownLevel <> Empty Then
                      m.downLevel bar, b
                      Set bar = lBar.ReturnBar(b.GetDownLevel)
                    End If
                  End If
                End If
              End With
            Else
              MsgBox c.msgInserting, vbCritical + vbOKOnly, c.titleTag
            End If
          Else
            MsgBox c.msgInserting, vbCritical + vbOKOnly, c.titleTag
          End If
        End With
    End Select
  End With
  '--------------
  Set b = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr c
    .BuildLog errIDObj & errIDMet, c
  End With
  Set b = Nothing
End Sub

Sub SubHelp()
  Const errIDMet As String = "08"
  '-----------------------------
  On Error GoTo errLOG
  
  MsgBox "BIREME - OMS/OPAS"
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

Sub SubDown(m As clsMarkup, listBar As clsListBar, bar As clsBar, button As CommandBarButton)
  Dim b As New clsButton
  Const errIDMet As String = "09"
  '-----------------------------
  On Error GoTo errLOG
  
  Set b = bar.ReturnButton(str$(button.Index))
  m.downLevel bar, b
  Set bar = listBar.ReturnBar(b.GetDownLevel)
  '-----------------
  Set b = Nothing
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

Sub SubUp(m As clsMarkup, listBar As clsListBar, bar As clsBar)
  Const errIDMet As String = "10"
  '-----------------------------
  On Error GoTo errLOG
  
  m.UpLevel bar
  Set bar = listBar.ReturnBar(bar.getUpLevel)
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

Sub MainConfig()
  Dim Conf As New clsConfig, inter As New clsInterface
  Dim m As New clsMarkup
  Const errIDMet As String = "11"
  '-----------------------------
  On Error GoTo errLOG
  
  Conf.LoadPublicValues
  With inter
    .ShowFrmConfig Conf
    .EndFrmConfig
    m.DisableScreen
    .DestroyMarkupBar Conf
    .BuildMarkupBar Conf
    m.EnableScreen
  End With
  '--------------------------------------
  Set Conf = Nothing: Set inter = Nothing: Set m = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing: Set inter = Nothing: Set m = Nothing
End Sub

Sub Conv()
  Dim button As CommandBarButton
  Dim Conv As New clsConv
  '----------------------
  Set button = CommandBars.ActionControl
  Select Case button.Caption
    Case "1.0-2.0-3.0"
      With frmConv
        .Show
        Select Case .flagOK
          Case True
            If .OpBut10_20.value = True Then
              Unload frmConv
              Conv.Conversor10_20
            ElseIf .OpBut20_30.value = True Then
              MsgBox "2.0 - 3.0"
            End If
        End Select
      End With
  End Select
  
  Set Conv = Nothing
  End
End Sub

Function BuildID(mar As clsMarkup, stitle As String)
  Dim attribs(3) As String, i As Integer
  Dim posF As Long, posI As Long
  Dim id As String, text As String
  '-----
  attribs(0) = "volid=": attribs(1) = "issueno="
  attribs(2) = "supplvol=": attribs(3) = "supplno="
  '-----
  id = stitle
  For i = 0 To 3
    With Selection
      .start = 0: .End = .start
    End With
    posF = 0: posI = 0
    mar.FindText attribs(i), True, , posF
    With Selection
      .start = .End
    End With
    mar.FindText Space(1), True, posI
    text = Empty
    Select Case i
      Case 0  'volid
        If posF > 0 Then
          text = " v." & ActiveDocument.Range(posF + 1, posI).text
        End If
      Case 1  'issueno
        If posF > 0 Then
          text = " n." & ActiveDocument.Range(posF + 1, posI).text
        End If
      Case Else 'supplvol ou supplno
        If posF > 0 Then
          text = " s." & ActiveDocument.Range(posF + 1, posI).text
        End If
    End Select
    id = id & RTrim$(text)
  Next i
  BuildID = id
End Function

Function setAhead(issue As String)
    If issue = "ahead" Then
        isAhead = True
    Else
        isAhead = False
    End If
End Function
Function getPidCaption() As String
    If isAhead Then
        getPidCaption = "new pid"
    Else
        getPidCaption = "old pid"
    End If
End Function

Function getPidAttribute() As String
    If isAhead Then
        getPidAttribute = "new-pid="
    Else
        getPidAttribute = "old-pid="
    End If

End Function
Function myReplace(text As String, find As String, replaceby As String) As String
    Dim p As Long
    
    If Len(find) > 0 Then
        p = InStr(text, find)
        While p > 0
            text = Mid(text, 1, p - 1) & replaceby & Mid(text, p + Len(find))
            p = InStr(p + Len(replaceby), text, find)
        Wend
    End If
    myReplace = text
End Function

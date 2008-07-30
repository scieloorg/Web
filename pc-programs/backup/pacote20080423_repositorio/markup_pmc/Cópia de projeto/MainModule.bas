Attribute VB_Name = "MainModule"
Private mErr As New clsErrList
Const errIDObj As String = "102"

Public CurrentHTML As String
Public CurrentHTMLName As String
Public MarkupPrg As String
Public isAhead As Boolean
Public navegation As New clsBarNavegation
Public reflistmanager As New clsRefListManager
Private jsManager As New clsJournalStandardManager
Public currentJS As New ClsJournalStandard
Public sm As New ClsStandardManager
Public currentStandard As New ClsStandard
Public OpenMarkup As Boolean
  
  
Sub Main()
  Dim j As Integer
  Dim button As CommandBarButton
  Dim scrollPercent As Long
  
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  Static conf As New clsConfig: Static listbar As New clsListBar
  Static listattr As New clsAttrList: Static listIssue As New clsIssueList
  Static listLink As New clsLkList: Static m As New clsMarkup
  Static bar As New clsBar: Static autoMarkup As New clsAutoMarkupList
  Static inter As New clsInterface: Static previousBar As New clsBar
  '----alteracao
  Static id As String
  '-------------
  Set button = CommandBars.ActionControl
  Set bar = listbar.ReturnBar(button.DescriptionText)
  '++++++++++++++++++++
  Dim template As template
  
  For Each template In Templates
    If template.Name = "markup.prg" Then
        MarkupPrg = template.Path & "\"
        'MsgBox MarkupPrg
    End If
  Next
  
  If OpenMarkup Then
    Documents.Open CurrentHTML
    OpenMarkup = False
  End If
  'Set Paths = New ColFileInfo
   ' Set Paths = ReadPathsConfigurationFile("..\scielo_paths.ini")
 
  Select Case button.TooltipText
    Case "Start Markup"
      SubStartMarkup conf, listbar, m, listattr, listIssue, listLink, bar, autoMarkup, inter, id
      Set previousBar = bar
      With Templates
        For j = 1 To .count
          If .Item(j).Name = conf.prg_name Then
            '.Item(j).Save
            .Item(j).Saved = True
          End If
        Next j
      End With
      
      '---changes on 20020911 for supporting Word2000 and XP
      NormalTemplate.Saved = True
      '---
      
    Case conf.buttonStop
      If SubStop(listbar, m, conf, listattr, inter) = True Then
      SafeExit = True
        With Templates
          For j = 1 To .count
            If .Item(j).Name = conf.prg_name Then
              '.Item(j).Save
              .Item(j).Saved = True
            End If
          Next j
        End With
        
        '---changes on 20020911 for supporting Word2000 and XP
        NormalTemplate.Saved = True
        '---
        
        Set conf = Nothing: Set listbar = Nothing: Set m = Nothing
        Set listattr = Nothing: Set listIssue = Nothing
        Set listLink = Nothing: Set bar = Nothing: Set mErr = Nothing
        Set autoMarkup = Nothing: Set inter = Nothing: Set previousBar = Nothing
        End
      End If
      
    Case conf.buttonChange
      SubChange m, conf, listbar, listLink, listattr, inter, listIssue, id
      m.RestoreScreen
      
    Case conf.buttonDelete
      SubDelete m, conf, listbar, bar, previousBar
      m.RestoreScreen
      
    Case conf.buttonAutomatic
      SubAutomatic conf, autoMarkup, inter, listbar, m, listattr, listLink, listIssue
      m.RestoreScreen
    
    Case conf.buttonAutomaticWS
        SubAutoMarkupServices conf, autoMarkup, inter, listbar, m, listattr, listLink, listIssue
      m.RestoreScreen
    Case conf.buttonViewMarkup
        'Documents.Open CurrentHTML
    
    Case conf.buttonSave
        scrollPercent = ActiveWindow.VerticalPercentScrolled
        m.DisableScreen
        Call SaveDocumentAsHTML(m, conf, listbar)
        ActiveWindow.VerticalPercentScrolled = scrollPercent
        m.EnableScreen
        m.RestoreScreen
    Case conf.buttonParser
        
        scrollPercent = ActiveWindow.VerticalPercentScrolled
        m.DisableScreen
        Call SaveDocumentAsHTML(m, conf, listbar)
        Call SaveDocumentAsText(m, conf, listbar)
        Call ExecuteSGMLParser(conf.parser, m.BuildFilePathName(ActiveDocument.FullName, "txt"))
        ActiveWindow.VerticalPercentScrolled = scrollPercent
        m.EnableScreen
        m.RestoreScreen
    
    Case conf.buttonGenerateXML
        scrollPercent = ActiveWindow.VerticalPercentScrolled
        m.DisableScreen
        Call SaveDocumentAsHTML(m, conf, listbar)
        SaveDocumentAsXML m, conf, listbar
        ActiveWindow.VerticalPercentScrolled = scrollPercent
        m.EnableScreen
        m.RestoreScreen
        
    Case conf.buttonCheckXML
        scrollPercent = ActiveWindow.VerticalPercentScrolled
        m.DisableScreen
        CheckXML m, conf, listbar
        ActiveWindow.VerticalPercentScrolled = scrollPercent
        m.EnableScreen
        m.RestoreScreen
        OpenMarkup = True
        
    Case conf.buttonHelp
      SubHelp
      
    Case conf.tooltipsDown
      SubDown m, listbar, bar, button
      Select Case bar.GetName
        Case "ifloat", "aff", "tabwrap", "figgrp", "cltrial", "xref", "uri"
          '--
        Case Else
          Set previousBar = bar
      End Select
      
    Case conf.tooltipsUp
      SubUp m, listbar, bar
      Select Case bar.GetName
        Case "ifloat", "aff", "tabwrap", "figgrp", "cltrial", "xref", "uri"
          '--
        Case Else
          Set previousBar = bar
      End Select
      
    Case Else
      SubElse m, listbar, listLink, listIssue, listattr, conf, inter, bar, button, id
      Select Case bar.GetName
        Case "ifloat", "aff", "tabwrap", "figgrp", "cltrial", "xref", "uri"
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
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set button = Nothing
End Sub

Sub SubStartMarkup(conf As clsConfig, listbar As clsListBar, m As clsMarkup, listattr As clsAttrList, listIssue As clsIssueList, listLink As clsLkList, bar As clsBar, autoMarkup As clsAutoMarkupList, inter As clsInterface, id As String)
  Dim text As String, iTag As Long, fTag As Long
  Dim stitle As String, i As Long, j As Long, count As Long
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  With conf
    .LoadPublicValues
    .SetFirstHour
  End With
'  MsgBox "Configuração carregada."
  listattr.LoadAttributes conf
'  MsgBox "Atributos carregados."
  listIssue.LoadIssue conf
'  MsgBox "Número carregado."
  listLink.LoadLink conf
   
   
jsManager.load

  If m.VerifyDocumentHTMLFormat(conf) = True Then
    With ActiveDocument
      CurrentHTML = .FullName
      CurrentHTMLName = .Name
      conf.fileSize = FileLen(.FullName)
      .UpdateStylesOnOpen = False
      .AttachedTemplate = ""
    End With
    With m
      .DisableScreen
      .ChangeEntity conf
      .ChangeFields conf
      '.ChangeHtmlMarkup conf
    End With
    With inter
      .DisableWordBars
    End With
    autoMarkup.LoadAutomata conf
    'MsgBox "Autômata carregado."
  
    With listbar
      .LoadBars conf
      .CreateBars conf
      With m
        .DisplayBar "StartUp", False
        .DisplayBar "Markup", True
        .DisplayBar "ifloat", True
        .DisplayBar "Hide", True
      End With
      'MsgBox "Carregando arquivo..."
  
      .LoadTempFile
      Do
        count = count + 1
        text = Trim$(ActiveDocument.Paragraphs(count).range.text)
        Select Case text
          Case Empty, Chr(10), Chr(13)
          
          Case Else
            Exit Do
        End Select
      Loop
      iTag = InStr(text, conf.STAGO)
      fTag = InStr(text, Conf.TAGC)
      If iTag > 0 And fTag > 0 Then
        text = Trim$(Mid$(text, iTag + 1, fTag - 2))
      End If
      fTag = InStr(text, Space(1))
      If fTag > 0 Then
        text = Trim$(Mid$(text, 1, fTag - 1))
      End If
      'MsgBox "Arquivo carregado"
      If listbar.FoundTag(text) = False Then
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
          Case "translat"
            .EnableBar "translat": m.DisplayBar "translat", True
            Set bar = .ReturnBar("translat")
        End Select
        text = Trim$(ActiveDocument.Paragraphs(count).range.text)
          
          inter.stitle = getAttrValueFromTag(text, "stitle")
          inter.issn = getAttrValueFromTag(text, "issn")
          
          If jsManager.AutoMarkupIsAvailable Then
          Set currentJS = jsManager.getStandard(inter.issn)
          Set currentStandard = sm.getStandard(currentJS.standardName)
          Else
              CommandBars("Markup").Controls.Item(5).Enabled = False
          End If
          '---alteracao
          id = BuildID(m, text)
          '------------
        
      End If
      'Call reflistmanager.load(ActiveDocument.FullName)
      
    End With
    m.EnableScreen
  Else
    MsgBox conf.msgOpenFile, vbCritical, conf.titleOpenFile
    Set conf = Nothing: Set listbar = Nothing: Set m = Nothing
    Set listattr = Nothing: Set listIssue = Nothing
    Set listLink = Nothing: Set bar = Nothing: Set mErr = Nothing
    Set autoMarkup = Nothing: Set inter = Nothing
    End
  End If
  '------------------
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  m.EnableScreen
End Sub

Function getAttrValueFromTag(ByVal text As String, attr As String) As String
    Dim i As Long, j As Long
    
    text = myReplace(text, "]", " ]")
    i = InStr(text, attr & "=")
        
    If i > 0 Then 'Or j = 0 Then
        i = i + Len(attr) + 1
          j = InStr(i, text, Chr(34), vbBinaryCompare)
          If j = i Then
            i = i + 1
            j = InStr(i, text, Chr(34), vbBinaryCompare)
          Else
            j = InStr(i, text, " ", vbTextCompare)
          End If
          text = Mid$(text, i, j - i)
          getAttrValueFromTag = text
    End If
  
End Function
Function SubStop(listbar As clsListBar, m As clsMarkup, conf As clsConfig, attl As clsAttrList, inter As clsInterface) As Boolean
  Dim ret As Long, pathTXT As String, pathHTM As String, saveAsFormat As Integer
  
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo errLOG
  
  SubStop = True
  With frmParser
    .show
    If .flagOK = True Then
        conf.SetLastHour
      m.DisableScreen
        With listbar
          .KillBars
          '.BuildTempFile
        End With
        inter.EnableWordBars
        With m
          'ActiveDocument.Save
          .BuildLog conf, attl
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
        Documents.Open filename:=pathHTM
        If .OB_Exit1.value = True Then
            'Documents.Open filename:=pathHTM
            'MsgBox conf.parser
            ret = Shell(Conf.parser & Space(1) & pathTXT, vbMaximizedFocus)
        Else
            'Documents.Open filename:=pathTXT
            ret = True
        End If
      End If
      m.EnableScreen
      SubStop = ret
    Else
      'ActiveDocument.Save
      SubStop = False
    End If
    Unload frmParser
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function



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

Sub SubDelete(m As clsMarkup, conf As clsConfig, listbar As clsListBar, bar As clsBar, pBar As clsBar)
  Dim tag As String, returnMSG As Integer
  Dim b As New clsButton, i As Long
  Const errIDMet As String = "05"
  '-----------------------------
  On Error GoTo errLOG
  
  returnMSG = MsgBox(conf.msgSure, vbYesNo, conf.titleDelete)
  If returnMSG = vbYes Then
    If m.DeleteTag(conf, listbar, tag) = True Then
      Select Case tag
        Case "article", "text", "translat"
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
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set b = Nothing
End Sub

Sub SubAutomatic(conf As clsConfig, autoMarkup As clsAutoMarkupList, i As clsInterface, listbar As clsListBar, m As clsMarkup, listattr As clsAttrList, linkl As clsLkList, issuel As clsIssueList)
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
    With selection
      If .start <> .End Then
        For j = 1 To listbar.LenListOfBar
          Set button = listbar.ReturnBar(str$(j)).ReturnButton(automata.initialTag)
          If button.GetTag <> Empty Then
            Exit For
          End If
        Next j
        If j <= listbar.LenListOfBar Then
          If m.VerifyInsertInto(conf, listbar) = True Then
            If m.VerifyHierarchy(conf, listbar, listbar.ReturnBar(str$(j)).GetName, automata.initialTag) = True Then
              startSel = selection.start
              If Markup(conf.directory & automata.automataFile, conf.directory & conf.fileTagsAutomata & automata.tagsFile, automata.initialTag) <> Empty Then
                With selection
                  .start = startSel: .End = .start
                End With
                m.DisableScreen
                Do
                  m.FindTag listbar, conf, True, start, tag, sX, fX
                  If start = False And tag = automata.initialTag Then
                    With selection
                      .start = .End + 1
                    End With
                    Exit Do
                  Else
                    With selection
                      .start = sX: .End = fX
                    End With
                    m.ChangeAttribute conf, listbar, linkl, listattr, i, issuel
                    With selection
                      .start = fX: .End = fX
                    End With
                  End If
                Loop
              Else
                With selection
                  .End = .start
                End With
              End If
            Else
              MsgBox conf.msgInserting, vbCritical, conf.titleAttribute
            End If
          Else
            MsgBox conf.msgInserting, vbCritical, conf.titleAttribute
          End If
        Else
          MsgBox conf.msgInserting, vbCritical, conf.titleAttribute
        End If
      Else
        MsgBox conf.msgSelection, vbCritical, conf.titleAttribute
      End If
    End With
  Else
    MsgBox conf.msgAutomaticErr, vbCritical, conf.buttonAutomatic
  End If
  ActiveWindow.VerticalPercentScrolled = scrollPercent
  m.EnableScreen
  '---------------------
  Set automata = Nothing: Set button = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set automata = Nothing: Set button = Nothing
End Sub
Sub SubAutoMarkupServices(conf As clsConfig, autoMarkup As clsAutoMarkupList, i As clsInterface, listbar As clsListBar, m As clsMarkup, listattr As clsAttrList, linkl As clsLkList, issuel As clsIssueList)
  
  Dim insertRefListTag As Boolean
  Dim DoMarkup As Boolean
  Dim scrollPercent As Long
  Dim s As Long, e As Long
  Dim d As Boolean
  
  
 '-----------------------------
  
  ' verificar se o trecho selecionado eh valido
  ' verificar se o trecho a ser marcado seria de referencias (hierarquia)
  ' chamar passando o trecho
  ' substituir o trecho pelo resultado
  d = (conf.doDebug = "yes")
  
  scrollPercent = ActiveWindow.VerticalPercentScrolled
  m.DisableScreen
  
  If d Then MsgBox currentStandard.ref_barName
  If d Then MsgBox currentStandard.ref_tagName
  If d Then MsgBox currentStandard.standard_barName
  If d Then MsgBox currentStandard.standard_tagName
  
  If d Then MsgBox MarkupPrg & "auto\" & currentStandard.standard_tagName & ".xsl"
  If Len(currentStandard.ref_barName) > 0 And Len(currentStandard.ref_tagName) > 0 And (Dir(MarkupPrg & "auto\" & currentStandard.standard_tagName & ".xsl") = currentStandard.standard_tagName & ".xsl") Then
    With selection
      If .start <> .End Then
        
        If m.VerifyInsertInto(conf, listbar) = True Then
            s = .start
            e = .End
            
          If m.VerifyHierarchy(conf, listbar, currentStandard.standard_barName, currentStandard.standard_tagName) = True Then
            insertRefListTag = True
            DoMarkup = True
          ElseIf m.VerifyHierarchy(conf, listbar, currentStandard.ref_barName, currentStandard.ref_tagName) = True Then
            DoMarkup = True
          End If
          
          If DoMarkup Then
            selection.End = e
            selection.start = s
            
            Call ExecuteAutoMarkup(currentStandard.standard_tagName, "app", insertRefListTag, d)
          Else
            MsgBox conf.msgInserting, vbCritical, conf.titleAttribute
          End If
        Else
          MsgBox conf.msgInserting, vbCritical, conf.titleAttribute
        End If
      Else
        MsgBox conf.msgSelection, vbCritical, conf.titleAttribute
      End If
    End With
  Else
    MsgBox conf.msgAutomaticErr, vbCritical, conf.buttonAutomatic
  End If
ActiveWindow.VerticalPercentScrolled = scrollPercent
m.EnableScreen
End Sub

Sub ExecuteAutoMarkup(standard As String, serviceType As String, insertMainTag As Boolean, doDebug As Boolean)
  Dim Service As Object
  Dim referenceMarker As clsRefMarker
   
  On Error GoTo ERRLOG
  
    If doDebug Then MsgBox "Início da marcação automática"
    
    'Standard = "auto\" & Standard
    
    If Len(serviceType) = 0 Then serviceType = "app"
  
    Set referenceMarker = New clsRefMarker
    
    Select Case serviceType
    Case "app"
        Set referenceMarker.Service = New clsRefIdentifAppCaller
    Case "ws"
        Set referenceMarker.Service = New clsRefIdentifWSCaller
    End Select
      referenceMarker.Service.debugMode = doDebug
    
    selection.range.End = selection.End
    selection.range.start = selection.start
    
    'MsgBox MarkupPrg & "auto\" & standard & ".xsl"
    referenceMarker.doDebug = doDebug
    
    
      If doDebug Then MsgBox "referenceMarker.rulesToConvertXML2SGML = " & MarkupPrg & "auto\" & standard & ".xsl"
      referenceMarker.rulesToConvertXML2SGML = MarkupPrg & "auto\" & standard & ".xsl"
    referenceMarker.standard = standard
    
    
    Call referenceMarker.MarkReferences(selection.range, insertMainTag)
  
    If doDebug Then MsgBox "Fim da marcação automática"
   Exit Sub
ERRLOG:
  MsgBox err.Description
    
End Sub

Sub SubElse(m As clsMarkup, lBar As clsListBar, lLink As clsLkList, lIssue As clsIssueList, lAttr As clsAttrList, c As clsConfig, i As clsInterface, bar As clsBar, button As CommandBarButton, id As String)
  Dim b As New clsButton
  Dim ok As Boolean
  Dim mft As New clsMarkupFigTab
  Const errIDMet As String = "07"
  '-----------------------------
  On Error GoTo errLOG
  
  Set m.listbar = lBar
  
  Set b = bar.ReturnButton(button.Caption)
  With b
    Select Case .GetTag
      Case "translat"
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
                    
                    ' standard
                   
                    Set currentJS = jsManager.getStandard(i.issn)
                    Set currentStandard = sm.getStandard(currentJS.standardName)
                    
                  End If
                End If
              End If
            End If
          End With
        End If
        i.EndFrmArticle

      Case "figgrp", "tabwrap"
        With m
          Dim s As Long, e As Long
          
          s = selection.start
          e = selection.End
            Dim d As Document
            
            Set mft.MarkupRange.conf = c
            Set mft.MarkupRange.listbar = lBar
          If mft.VerifyInsertInto_FigTable(selection.start, selection.End) Then
            If mft.VerifyHierarchy_FigTable(bar.GetName, b.GetTag) = True Then
            
              With i
                If lBar.ReturnBar(bar.GetName).ReturnButton(b.GetTag).GetAttrib = True Then
                    
                  selection.End = e
                  selection.start = s

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
                Set d = Documents.add
                d.range.text = mft.temp
            End If
          Else
            MsgBox c.msgInserting, vbCritical + vbOKOnly, c.titleTag
            
            Set d = Documents.add
            d.range.text = mft.temp
          End If
        End With
      
      Case Else
        With m
          If .VerifyInsertInto(c, lBar) Then
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
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub

Sub SubDown(m As clsMarkup, listbar As clsListBar, bar As clsBar, button As CommandBarButton)
  Dim b As New clsButton
  Const errIDMet As String = "09"
  '-----------------------------
  On Error GoTo errLOG
  
  Set b = bar.ReturnButton(str$(button.index))
  m.downLevel bar, b
  Set bar = listbar.ReturnBar(b.GetDownLevel)
  '-----------------
  Set b = Nothing
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

Sub SubUp(m As clsMarkup, listbar As clsListBar, bar As clsBar)
  Const errIDMet As String = "10"
  '-----------------------------
  On Error GoTo errLOG
  
  m.UpLevel bar
  Set bar = listbar.ReturnBar(bar.getUpLevel)
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

Sub MainConfig()
  Dim conf As New clsConfig, inter As New clsInterface
  Dim m As New clsMarkup
  Const errIDMet As String = "11"
  '-----------------------------
  On Error GoTo errLOG
  
  conf.LoadPublicValues
  With inter
    .ShowFrmConfig conf
    .EndFrmConfig
    m.DisableScreen
    .DestroyMarkupBar conf
    .BuildMarkupBar conf
    m.EnableScreen
  End With
  '--------------------------------------
  Set conf = Nothing: Set inter = Nothing: Set m = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing: Set inter = Nothing: Set m = Nothing
End Sub

Sub Conv()
  Dim button As CommandBarButton
  Dim Conv As New clsConv
  '----------------------
  Set button = CommandBars.ActionControl
  Select Case button.Caption
    Case "1.0-2.0-3.0"
      With frmConv
        .show
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
    With selection
      .start = 0: .End = .start
    End With
    posF = 0: posI = 0
    mar.findText attribs(i), True, , posF
    With selection
      .start = .End
    End With
    mar.findText Space(1), True, posI
    text = Empty
    Select Case i
      Case 0  'volid
        If posF > 0 Then
          text = " v." & ActiveDocument.range(posF + 1, posI).text
        End If
      Case 1  'issueno
        If posF > 0 Then
          text = " n." & ActiveDocument.range(posF + 1, posI).text
        End If
      Case Else 'supplvol ou supplno
        If posF > 0 Then
          text = " s." & ActiveDocument.range(posF + 1, posI).text
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
Sub SaveDocumentAsHTML(m As clsMarkup, conf As clsConfig, listbar As clsListBar)
    Dim r As Boolean
                
    Documents.Open CurrentHTML
    r = True
    With ActiveDocument
        m.ChangeSTAGO_TAGC conf, listbar
        
        If .SaveFormat = wdFormatHTML Then
            .SaveAs Filename:=CurrentHTML, fileFormat:=wdFormatFilteredHTML
        Else
            .Save
        End If
    End With
End Sub
Sub SaveDocumentAsText(m As clsMarkup, conf As clsConfig, listbar As clsListBar)
    Documents.Open CurrentHTML
    ActiveDocument.SaveAs Filename:=m.BuildFilePathName(CurrentHTML, "txt"), fileFormat:=wdFormatText
    ActiveDocument.Close
    Documents.Open CurrentHTML
End Sub
Function SaveDocumentAsXML(m As clsMarkup, conf As clsConfig, listbar As clsListBar) As Boolean
    Dim pathXML As String, content As String
    Dim r As Boolean
                
    r = True
    
    Documents.Open CurrentHTML
    With ActiveDocument
        pathXML = m.BuildFilePathName(CurrentHTML, "xml")
        .SaveAs Filename:=pathXML, fileFormat:=wdFormatText, encoding:=msoEncodingUTF8
        content = removeBadCharacters(.range.text)
        
        Dim converter As New ClsConverterSGML2XML
        
        content = converter.convert(content)
        If Len(content) > 0 Then
            .range.text = content
            .SaveAs Filename:=pathXML, fileFormat:=wdFormatText, encoding:=msoEncodingUTF8
            MsgBox conf.msgXMLWasSuccessfullyGenerated
        Else
            .range.text = "<article/>"
        End If
        .Close
        Documents.Open CurrentHTML
        
    End With
    SaveDocumentAsXML = r
End Function
Function CheckXML(m As clsMarkup, conf As clsConfig, listbar As clsListBar) As Boolean
    Dim pathXML As String, content As String
    Dim r As Boolean
    Dim pathXMLHTML As String
                
    On Error GoTo x
    r = True
    
    pathXML = m.BuildFilePathName(CurrentHTML, "xml")
    
    If Dir(pathXML) = m.BuildFilePathName(CurrentHTMLName, "xml") Then
        ' fecha o arquivo html
        ActiveDocument.Close
        
        ' abre o arquivo xml
        Documents.Open Filename:=pathXML, Format:=wdOpenFormatText, encoding:=msoEncodingUTF8
        ' pega o conteudo do arquivo xml
        content = ActiveDocument.range.text
        ' fecha o arquivo xml
        ActiveDocument.Close
            
        'abre o arquivo html
        Documents.Open Filename:=CurrentHTML
        
        ' converte o xml
        content = removeBadCharacters(content)
        content = Mid(content, 1, InStr(content, "<article") - 1) & "<root><css-path>" & MarkupPrg & "</css-path>" & Mid(content, InStr(content, "<article")) & "</root>"
            
        Dim converter As New clsConverterXML
        ' xsl
        converter.xslToConvertXML = MarkupPrg & "pmc\viewText.xsl"
        ' converte xml
        content = converter.convertXML(content)
        If Len(content) > 0 Then
            pathXMLHTML = m.BuildFilePathName(CurrentHTML, "xml.html")
            ActiveDocument.range.text = content
            ActiveDocument.SaveAs Filename:=pathXMLHTML, fileFormat:=wdFormatText
            ActiveDocument.Close
            
            Documents.Open Filename:=pathXMLHTML
            
        Else
            
        End If
    Else
        MsgBox conf.msgNoXMLFile & " " & pathXML
    End If
    
x:
If err.Description <> "" Then
   MsgBox err.Description
End If
    CheckXML = r
End Function



Function xxSaveDocument(m As clsMarkup, conf As clsConfig, listbar As clsListBar) As Boolean
    Dim pathTXT As String, pathHTM As String, pathXML As String, content As String
    Dim r As Boolean
                
    r = True
    With ActiveDocument
        pathHTM = .FullName
        pathXML = m.BuildFilePathName(.FullName, "xml")
        pathTXT = m.BuildFilePathName(pathHTM, "txt")
        
        m.ChangeSTAGO_TAGC conf, listbar
        If .SaveFormat = wdFormatHTML Then
            .SaveAs Filename:=pathHTM, fileFormat:=wdFormatFilteredHTML
        Else
            .Save
        End If
        
        .SaveAs Filename:=pathTXT, fileFormat:=wdFormatText
        .Close
    End With
    xxSaveDocument = r
End Function
Function xSaveDocument(m As clsMarkup, conf As clsConfig, listbar As clsListBar, generateXML As Boolean) As Boolean
    Dim pathTXT As String, pathHTM As String, pathXML As String, content As String
    Dim r As Boolean
                
    r = True
    With ActiveDocument
        pathHTM = .FullName
        pathXML = m.BuildFilePathName(.FullName, "xml")
        pathTXT = m.BuildFilePathName(pathHTM, "txt")
        
        m.ChangeSTAGO_TAGC conf, listbar
        If .SaveFormat = wdFormatHTML Then
            .SaveAs Filename:=pathHTM, fileFormat:=wdFormatFilteredHTML
        Else
            .Save
        End If
        If generateXML Then
            .SaveAs Filename:=pathXML, fileFormat:=wdFormatText, encoding:=msoEncodingUTF8
            
            '
            'Dim converter As New ClsConverterSGML2XML
            'r = converter.convert(.range.text, content)
            
            'If r Then
            '    .range.text = content
            '    .SaveAs Filename:=pathXML, fileformat:=wdFormatText, encoding:=msoEncodingUTF8
            '    .Close
            'End If
        End If
        
        If r Then
            Documents.Open Filename:=pathHTM
            .SaveAs Filename:=pathTXT, fileFormat:=wdFormatText
            .Close
        
            Documents.Open Filename:=pathHTM
        End If
    End With
    xSaveDocument = r
End Function


Function ExecuteSGMLParser(program As String, Filename) As Boolean
    ExecuteSGMLParser = Shell(program & Space(1) & Filename, vbMaximizedFocus)
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

Public Function removeBadCharacters(text As String) As String
    Dim i As Long
    Dim c As String
    
    For i = 0 To 8
        c = Chr(i)
        text = myReplace(text, c, "")
    Next
    For i = 10 To 12
        c = Chr(i)
        text = myReplace(text, c, "")
    Next
    For i = 14 To 31
        c = Chr(i)
        text = myReplace(text, c, "")
    Next
    removeBadCharacters = text
End Function


Attribute VB_Name = "MainModule"
Private mErr As New clsErrList
Const errIDObj As String = "102"

Public MarkupPrg As String
Public isAhead As Boolean
Public navegation As New clsBarNavegation
Public reflistmanager As New clsRefListManager
Private jsManager As New clsJournalStandardManager
Public currentJS As New ClsJournalStandard
Public sm As New ClsStandardManager
Public currentStandard As New ClsStandard
  
  
Sub Main()
  Dim j As Integer
  Dim button As CommandBarButton
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo ERRLOG
  
  Static Conf As New clsConfig: Static listBar As New clsListBar
  Static listattr As New clsAttrList: Static listIssue As New clsIssueList
  Static listLink As New clsLkList: Static m As New clsMarkup
  Static bar As New clsBar: Static automarkup As New clsAutoMarkupList
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
        MarkupPrg = template.path & "\"
        'MsgBox MarkupPrg
    End If
  Next
  
  'Set Paths = New ColFileInfo
   ' Set Paths = ReadPathsConfigurationFile("..\scielo_paths.ini")
 
  Select Case button.TooltipText
    Case "Start Markup"
      SubStartMarkup Conf, listBar, m, listattr, listIssue, listLink, bar, automarkup, inter, id
      Set previousBar = bar
      With Templates
        For j = 1 To .count
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
          For j = 1 To .count
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
        Set automarkup = Nothing: Set inter = Nothing: Set previousBar = Nothing
        End
      End If
      
    Case Conf.buttonChange
      SubChange m, Conf, listBar, listLink, listattr, inter, listIssue, id
      m.RestoreScreen
      
    Case Conf.buttonDelete
      SubDelete m, Conf, listBar, bar, previousBar
      m.RestoreScreen
      
    Case Conf.buttonAutomatic
      SubAutomatic Conf, automarkup, inter, listBar, m, listattr, listLink, listIssue
      m.RestoreScreen
    
    Case Conf.buttonAutomaticWS
    
        SubAutoMarkupServices Conf, automarkup, inter, listBar, m, listattr, listLink, listIssue
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
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set button = Nothing
End Sub

Sub SubStartMarkup(Conf As clsConfig, listBar As clsListBar, m As clsMarkup, listattr As clsAttrList, listIssue As clsIssueList, listLink As clsLkList, bar As clsBar, automarkup As clsAutoMarkupList, inter As clsInterface, id As String)
  Dim text As String, iTag As Long, fTag As Long
  Dim stitle As String, i As Long, j As Long, count As Long
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo ERRLOG
  
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
   
   
jsManager.load

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
    automarkup.LoadAutomata Conf
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
        count = count + 1
        text = Trim$(ActiveDocument.Paragraphs(count).range.text)
        Select Case text
          Case Empty, Chr(10), Chr(13)
          
          Case Else
            Exit Do
        End Select
      Loop
      iTag = InStr(text, Conf.STAGO)
      fTag = InStr(text, Conf.TAGC)
      If iTag > 0 And fTag > 0 Then
        text = Trim$(Mid$(text, iTag + 1, fTag - 2))
      End If
      fTag = InStr(text, Space(1))
      If fTag > 0 Then
        text = Trim$(Mid$(text, 1, fTag - 1))
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
    MsgBox Conf.msgOpenFile, vbCritical, Conf.titleOpenFile
    Set Conf = Nothing: Set listBar = Nothing: Set m = Nothing
    Set listattr = Nothing: Set listIssue = Nothing
    Set listLink = Nothing: Set bar = Nothing: Set mErr = Nothing
    Set automarkup = Nothing: Set inter = Nothing
    End
  End If
  '------------------
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
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
Function SubStop(listBar As clsListBar, m As clsMarkup, Conf As clsConfig, attl As clsAttrList, inter As clsInterface) As Boolean
  Dim ret As Long, pathTXT As String, pathHTM As String, saveAsFormat As Integer
  
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo ERRLOG
  
  SubStop = True
  With frmParser
    .show
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
    Else
      'ActiveDocument.Save
      SubStop = False
    End If
    Unload frmParser
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function



Sub SubChange(m As clsMarkup, c As clsConfig, lBar As clsListBar, lLink As clsLkList, lAttr As clsAttrList, i As clsInterface, lIssue As clsIssueList, id As String)
  Const errIDMet As String = "04"
  '-----------------------------
  On Error GoTo ERRLOG
  
  If m.ChangeAttribute(c, lBar, lLink, lAttr, i, lIssue, , id) = False Then
    MsgBox c.msgInserting, vbCritical + vbOKOnly, c.titleTag
  End If
  Exit Sub
ERRLOG:
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
  On Error GoTo ERRLOG
  
  returnMSG = MsgBox(Conf.msgSure, vbYesNo, Conf.titleDelete)
  If returnMSG = vbYes Then
    If m.DeleteTag(Conf, listBar, tag) = True Then
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
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set b = Nothing
End Sub

Sub SubAutomatic(Conf As clsConfig, automarkup As clsAutoMarkupList, i As clsInterface, listBar As clsListBar, m As clsMarkup, listattr As clsAttrList, linkl As clsLkList, issuel As clsIssueList)
  Dim automata As New clsAutoMarkup, button As New clsButton
  Dim stitle As String, j As Long, scrollPercent As Long
  Dim startSel As Long, start As Boolean, tag As String
  Dim sX As Long, fX As Long, okChange As Boolean
  Const errIDMet As String = "06"
  '-----------------------------
  On Error GoTo ERRLOG
  
  scrollPercent = ActiveWindow.VerticalPercentScrolled
  With i
    If InStr(.stitle, Chr(34)) <> 0 Then
      stitle = Mid$(.stitle, 2, Len(.stitle) - 2)
    Else
      stitle = .stitle
    End If
  End With
  Set automata = automarkup.ReturnAutomata(stitle)
  If automata.stitle <> Empty Then
    With selection
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
              startSel = selection.start
              If Markup(Conf.directory & automata.automataFile, Conf.directory & Conf.fileTagsAutomata & automata.tagsFile, automata.initialTag) <> Empty Then
                With selection
                  .start = startSel: .End = .start
                End With
                m.DisableScreen
                Do
                  m.FindTag listBar, Conf, True, start, tag, sX, fX
                  If start = False And tag = automata.initialTag Then
                    With selection
                      .start = .End + 1
                    End With
                    Exit Do
                  Else
                    With selection
                      .start = sX: .End = fX
                    End With
                    m.ChangeAttribute Conf, listBar, linkl, listattr, i, issuel
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
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set automata = Nothing: Set button = Nothing
End Sub
Sub SubAutoMarkupServices(Conf As clsConfig, automarkup As clsAutoMarkupList, i As clsInterface, listBar As clsListBar, m As clsMarkup, listattr As clsAttrList, linkl As clsLkList, issuel As clsIssueList)
  
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
  d = (Conf.doDebug = "yes")
  
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
        
        If m.VerifyInsertInto(Conf, listBar) = True Then
            s = .start
            e = .End
            
          If m.VerifyHierarchy(Conf, listBar, currentStandard.standard_barName, currentStandard.standard_tagName) = True Then
            insertRefListTag = True
            DoMarkup = True
          ElseIf m.VerifyHierarchy(Conf, listBar, currentStandard.ref_barName, currentStandard.ref_tagName) = True Then
            DoMarkup = True
          End If
          
          If DoMarkup Then
            selection.End = e
            selection.start = s
            
            Call ExecuteAutoMarkup(currentStandard.standard_tagName, "app", insertRefListTag, d)
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
  Const errIDMet As String = "07"
  '-----------------------------
  On Error GoTo ERRLOG
  
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
ERRLOG:

  With mErr
    .LoadErr c
    .BuildLog errIDObj & errIDMet, c
  End With
  Set b = Nothing
End Sub

Sub SubHelp()
  Const errIDMet As String = "08"
  '-----------------------------
  On Error GoTo ERRLOG
  
  MsgBox "BIREME - OMS/OPAS"
  Exit Sub
ERRLOG:
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
  On Error GoTo ERRLOG
  
  Set b = bar.ReturnButton(str$(button.index))
  m.downLevel bar, b
  Set bar = listBar.ReturnBar(b.GetDownLevel)
  '-----------------
  Set b = Nothing
  Exit Sub
ERRLOG:
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
  On Error GoTo ERRLOG
  
  m.UpLevel bar
  Set bar = listBar.ReturnBar(bar.getUpLevel)
  Exit Sub
ERRLOG:
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
  On Error GoTo ERRLOG
  
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
ERRLOG:
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
Function CreateXML(content As String, filename As String) As Boolean
    Set newDocument = Documents.add()
    newDocument.Activate
    ActiveDocument.range.InsertAfter (content)
    ActiveDocument.SaveAs filename:=filename, FileFormat:=wdFormatText
    ActiveDocument.Close
End Function
Function SaveDocument(m As clsMarkup, Conf As clsConfig, listBar As clsListBar, generateXML As Boolean) As Boolean
    Dim pathTXT As String, pathHTM As String, pathDOC As String, content As String
  
                
    With ActiveDocument
        pathHTM = .FullName
        pathDOC = m.BuildFilePathName(.FullName, "doc")
        m.ChangeSTAGO_TAGC Conf, listBar
        If .SaveFormat = wdFormatHTML Then
            .SaveAs filename:=pathHTM, FileFormat:=wdFormatFilteredHTML
        Else
            .Save
        End If
        If generateXML Then
            .SaveAs filename:=pathDOC, FileFormat:=wdFormatDocument
            content = m.getNodeAndConvert2XML("article", Conf, ActiveDocument)
            If content <> "" Then
                Call CreateXML(content, m.BuildFilePathName(.FullName, "xml"))
            End If
        End If
        
        Documents.Open filename:=pathHTM
        pathTXT = m.BuildFilePathName(pathHTM, "txt")
        .SaveAs filename:=pathTXT, FileFormat:=wdFormatText
        .Close
        Documents.Open filename:=pathHTM
        m.EnableScreen
    End With
        
End Function
Function ExecuteSGMLParser(program As String, filename) As Boolean
    ExecuteSGMLParser = Shell(program & Space(1) & filename, vbMaximizedFocus)
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

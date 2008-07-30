Attribute VB_Name = "AutoMacros"
Private mErr As New clsErrList
Const errIDObj As String = "101"

Sub AutoExec()
  Dim conf As New clsConfig, inter As New clsInterface, m As New clsMarkup
  Dim j As Integer
  '----------------------------------------------------
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  conf.LoadPublicValues
  
  m.DisableScreen
  inter.DestroyMarkupBar conf
  inter.BuildMarkupBar conf
  
        m.DisplayBar "Markup", False
        m.DisplayBar "Hide", False
  m.DisplayBar "StartUp", True
  m.EnableScreen
  ActiveDocument.Close
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
  
  Set conf = Nothing: Set inter = Nothing: Set m = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing: Set inter = Nothing: Set m = Nothing
  End
End Sub

Sub AutoOpen()
  Dim conf As New clsConfig, inter As New clsInterface, m As New clsMarkup
  '----------------------------------------------------
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  conf.LoadPublicValues
  
  m.DisableScreen
  inter.DestroyMarkupBar conf
  inter.BuildMarkupBar conf
  m.DisplayBar "StartUp", True
  m.EnableScreen
  
  '---changes on 20020911 for supporting Word2000 and XP
  NormalTemplate.Saved = True
  '---
  
  Set conf = Nothing: Set inter = Nothing: Set m = Nothing
  End
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing: Set inter = Nothing: Set m = Nothing
  End
End Sub

Sub AutoExit()
  Dim i As New clsInterface, listbar As New clsListBar
  Dim conf As New clsConfig, m As New clsMarkup
  Dim attl As New clsAttrList, j As Integer
  Dim pathDefault As String, pathFile As String
  '--------------------------
  
  conf.LoadPublicValues
  On Error Resume Next
  If CommandBars("start").Name = "start" Then
    If err.Number = 0 Then
      attl.LoadAttributes conf
      listbar.LoadBars conf
      listbar.KillBars
      With CommandBars("Markup")
        .Visible = False
      End With
      i.EnableWordBars
    End If
  End If
    
  Delete_AddIn conf
  
  '---changes on 20020911 for supporting Word2000 and XP
  NormalTemplate.Saved = True
  '---
  
  Set i = Nothing: Set listbar = Nothing: Set conf = Nothing:
  Set attl = Nothing: Set m = Nothing
  '----------------------------------
  End
End Sub

Sub Delete_AddIn(conf As clsConfig)
  Dim i As Integer
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo errLOG
  
  AddIns(conf.directory & conf.prg_name).Delete
  If Documents.count > 0 Then
    ActiveDocument.UpdateStylesOnOpen = False
  End If
  
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Sub

Sub AutoClose()
  Dim i As Integer
  Dim conf As New clsConfig
  '---------------
  Const errIDMet As String = "04"
  '-----------------------------
  On Error GoTo errLOG
  
  conf.LoadPublicValues
  With Templates
    For i = 1 To .count
      If .Item(i).Name = conf.prg_name Then
        '.Item(i).Save
        .Item(i).Saved = True
      End If
    Next i
  End With
 
  
  '---changes on 20020911 for supporting Word2000 and XP
  NormalTemplate.Saved = True
  '---
  
  Set conf = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub

Attribute VB_Name = "AutoMacros"
Private mErr As New clsErrList
Const errIDObj As String = "101"

Sub AutoExec()
  Dim Conf As New clsConfig, inter As New clsInterface, m As New clsMarkup
  Dim j As Integer
  '----------------------------------------------------
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo ERRLOG
  
  Conf.LoadPublicValues
  
  m.DisableScreen
  inter.DestroyMarkupBar Conf
  inter.BuildMarkupBar Conf
  
        m.DisplayBar "Markup", False
        m.DisplayBar "Hide", False
        m.DisplayBar "StartUp", True
  m.EnableScreen
  ActiveDocument.Close
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
  
  Set Conf = Nothing: Set inter = Nothing: Set m = Nothing
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing: Set inter = Nothing: Set m = Nothing
  End
End Sub

Sub AutoOpen()
  Dim Conf As New clsConfig, inter As New clsInterface, m As New clsMarkup
  '----------------------------------------------------
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo ERRLOG
  
  Conf.LoadPublicValues
  
  m.DisableScreen
  inter.DestroyMarkupBar Conf
  inter.BuildMarkupBar Conf
  m.DisplayBar "StartUp", True
  m.EnableScreen
  
  '---changes on 20020911 for supporting Word2000 and XP
  NormalTemplate.Saved = True
  '---
  
  Set Conf = Nothing: Set inter = Nothing: Set m = Nothing
  End
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing: Set inter = Nothing: Set m = Nothing
  End
End Sub

Sub AutoExit()
  Dim i As New clsInterface, listBar As New clsListBar
  Dim Conf As New clsConfig, m As New clsMarkup
  Dim attl As New clsAttrList, j As Integer
  Dim pathDefault As String, pathFile As String
  '--------------------------
  
  Conf.LoadPublicValues
  On Error Resume Next
  If CommandBars("start").Name = "start" Then
    If err.Number = 0 Then
      attl.LoadAttributes Conf
      listBar.LoadBars Conf
      listBar.KillBars
      With CommandBars("Markup")
        .Visible = False
      End With
      i.EnableWordBars
    End If
  End If
    
  Delete_AddIn Conf
  
  '---changes on 20020911 for supporting Word2000 and XP
  NormalTemplate.Saved = True
  '---
  
  Set i = Nothing: Set listBar = Nothing: Set Conf = Nothing:
  Set attl = Nothing: Set m = Nothing
  '----------------------------------
  End
End Sub

Sub Delete_AddIn(Conf As clsConfig)
  Dim i As Integer
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo ERRLOG
  
  AddIns(Conf.directory & Conf.prg_name).Delete
  If Documents.count > 0 Then
    ActiveDocument.UpdateStylesOnOpen = False
  End If
  
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Sub

Sub AutoClose()
  Dim i As Integer
  Dim Conf As New clsConfig
  '---------------
  Const errIDMet As String = "04"
  '-----------------------------
  On Error GoTo ERRLOG
  
  Conf.LoadPublicValues
  With Templates
    For i = 1 To .count
      If .Item(i).Name = Conf.prg_name Then
        '.Item(i).Save
        .Item(i).Saved = True
      End If
    Next i
  End With
 
  
  '---changes on 20020911 for supporting Word2000 and XP
  NormalTemplate.Saved = True
  '---
  
  Set Conf = Nothing
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub

VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmReferenceMarkup 
   Caption         =   "Automatic Reference Markup"
   ClientHeight    =   5070
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7770
   OleObjectBlob   =   "frmReferenceMarkup.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "frmReferenceMarkup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

'frmReferenceMarkup Code
'Alberto Pedroso, Feb/98
'-----------------------
Private mErr As New clsErrList
Const errIDObj As String = "004"
'---------------------------
Public ElementType As String
Public AllResultsTables As New AllResultsTables
Public TagsTable As New TagsTable
Public Cancel As Boolean
Public BotMarkup As Boolean

Private Sub Form_Load()
 Const errIDMet As String = "01"
 '-----------------------------
 On Error GoTo errLOG
  
 Top = (Screen.Height - Height) / 2
 Left = (Screen.Width - Width) / 2
 BotMarkup = False
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
Private Sub FirstChoice_Click()
 Const errIDMet As String = "02"
 '-----------------------------
 On Error GoTo errLOG
 
 ShowResults AllResultsTables.GetFirst()
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
Private Sub LastChoice_Click()
 Const errIDMet As String = "03"
 '-----------------------------
 On Error GoTo errLOG
 
 ShowResults AllResultsTables.GetLast()
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

Private Sub Markup_Click()
    Dim StartPos As Long, i As Long, j As Long, TagsTotalLength As Long
    Dim ResultsTableEntry As ResultsTableEntry
    Dim ResultsTable As ResultsTable
    Dim StartTag As String, EndTag As String
    Const errIDMet As String = "04"
    '-----------------------------
    '----alteracao para chamar os metodos enable and disable screen
    Dim m As New clsMarkup
    '--------------------------------------------------------------
    On Error GoTo errLOG
    
    frmReferenceMarkup.Hide
    StartPos = Selection.start
    'Markup Main Element
    StartTag = STAGO + ElementType + TAGC
    EndTag = STAGO + "/" + ElementType + TAGC
    '---
    m.DisableScreen
    '---
    Selection.InsertBefore StartTag
    Selection.InsertAfter EndTag
    With ActiveDocument
      .Range(start:=StartPos, End:=StartPos + Len(ElementType) + 2).Font.ColorIndex = TagColor(0)
      With .Range(start:=StartPos, End:=StartPos + Len(ElementType) + 2).Font
        .AllCaps = False: .Italic = False: .Bold = False
        .Subscript = False: .Superscript = False
        .Underline = wdUnderlineNone: .Name = "Arial"
        .Spacing = 0: .Size = 11
        .Animation = wdAnimationNone: .DoubleStrikeThrough = False
        .Emboss = False: .Engrave = False
        .Hidden = False: .Shadow = False
        .StrikeThrough = False: .SmallCaps = False
      End With
      .Range(start:=Selection.End - Len(ElementType) - 3, End:=Selection.End).Font.ColorIndex = TagColor(0)
      With .Range(start:=Selection.End - Len(ElementType) - 3, End:=Selection.End).Font
        .AllCaps = False: .Italic = False: .Bold = False
        .Subscript = False: .Superscript = False
        .Underline = wdUnderlineNone: .Name = "Arial"
        .Spacing = 0: .Size = 11
        .Animation = wdAnimationNone: .DoubleStrikeThrough = False
        .Emboss = False: .Engrave = False
        .Hidden = False: .Shadow = False
        .StrikeThrough = False: .SmallCaps = False
      End With
    End With
    StartPos = StartPos + Len(StartTag)
    'Markup SubElements
    Set ResultsTable = AllResultsTables.GetCurrent()
    For i = 1 To ResultsTable.Count
      Set ResultsTableEntry = ResultsTable.GetItem(i)
      If UCase(ResultsTableEntry.SubElement) <> "IGN" Then
       StartTag = STAGO + ResultsTableEntry.SubElement
       StartTag = StartTag + TagsTable.GetTagAttributes(ResultsTableEntry.SubElement)
       StartTag = StartTag + TAGC
       ResultsTableEntry.AbsSTAGStartPos = StartPos + ResultsTableEntry.StartPos - 1
       ResultsTableEntry.AbsSTAGEndPos = ResultsTableEntry.AbsSTAGStartPos + Len(StartTag)
       ActiveDocument.Range(start:=ResultsTableEntry.AbsSTAGStartPos).InsertBefore StartTag
       With ActiveDocument.Range(start:=ResultsTableEntry.AbsSTAGStartPos, End:=ResultsTableEntry.AbsSTAGEndPos).Font
        .AllCaps = False: .Italic = False: .Bold = False
        .Subscript = False: .Superscript = False
        .Underline = wdUnderlineNone: .Name = "Arial"
        .Spacing = 0: .Size = 11
        .Animation = wdAnimationNone: .DoubleStrikeThrough = False
        .Emboss = False: .Engrave = False
        .Hidden = False: .Shadow = False
        .StrikeThrough = False: .SmallCaps = False
       End With
       ActiveDocument.Range(start:=ResultsTableEntry.AbsSTAGStartPos, End:=ResultsTableEntry.AbsSTAGEndPos).Font.ColorIndex = TagColor(ResultsTableEntry.Level - 1)
       StartPos = StartPos + Len(StartTag)
      End If
      If ResultsTableEntry.Terminal Then
       'Close All The Preceeding Tags
       EndPos = ResultsTableEntry.EndPos
       For j = i To 1 Step -1
        Set ResultsTableEntry = ResultsTable.GetItem(j)
        If UCase(ResultsTableEntry.SubElement) <> "IGN" Then
         If ResultsTableEntry.EndPos = EndPos Then
          EndTag = STAGO + "/" + ResultsTableEntry.SubElement + TAGC
          ResultsTableEntry.AbsETAGStartPos = StartPos + EndPos
          ResultsTableEntry.AbsETAGEndPos = ResultsTableEntry.AbsETAGStartPos + Len(EndTag)
          ActiveDocument.Range(start:=ResultsTableEntry.AbsETAGStartPos).InsertBefore EndTag
          With ActiveDocument.Range(start:=ResultsTableEntry.AbsETAGStartPos, End:=ResultsTableEntry.AbsETAGEndPos).Font
           .AllCaps = False: .Italic = False: .Bold = False
           .Subscript = False: .Superscript = False
           .Underline = wdUnderlineNone: .Name = "Arial"
           .Spacing = 0: .Size = 11
           .Animation = wdAnimationNone: .DoubleStrikeThrough = False
           .Emboss = False: .Engrave = False
           .Hidden = False: .Shadow = False
           .StrikeThrough = False: .SmallCaps = False
          End With
          ActiveDocument.Range(start:=ResultsTableEntry.AbsETAGStartPos, End:=ResultsTableEntry.AbsETAGEndPos).Font.ColorIndex = TagColor(ResultsTableEntry.Level - 1)
          StartPos = StartPos + Len(EndTag)
         End If
        End If
       Next j
      End If
    Next i
    Cancel = False
    BotMarkup = True
    '--------------
    m.EnableScreen
    With Selection
      .start = .End
    End With
    '--------------
    Set m = Nothing
    Exit Sub
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing: Set m = Nothing
End Sub

Private Sub NextChoice_Click()
 Const errIDMet As String = "05"
 '-----------------------------
 On Error GoTo errLOG
  
 ShowResults AllResultsTables.GetNext()
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
Private Sub PreviousChoice_Click()
 Const errIDMet As String = "06"
 '-----------------------------
 On Error GoTo errLOG
  
 ShowResults AllResultsTables.GetPrev()
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
Private Sub Undo_Click()
 Const errIDMet As String = "07"
 '-----------------------------
 On Error GoTo errLOG
 
 Selection.Collapse Direction:=wdCollapseStart
 Unload Me
 Cancel = True
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

Private Sub UserForm_Terminate()
  Const errIDMet As String = "08"
  '-----------------------------
  On Error GoTo errLOG
  
  If BotMarkup = False Then
    Selection.Collapse Direction:=wdCollapseStart
    Unload Me
    Cancel = True
  Else
    Cancel = False
  End If
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

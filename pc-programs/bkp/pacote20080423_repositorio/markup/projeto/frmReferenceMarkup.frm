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
 On Error GoTo ERRLOG
  
 Top = (Screen.Height - Height) / 2
 Left = (Screen.Width - Width) / 2
 BotMarkup = False
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
Private Sub FirstChoice_Click()
 Const errIDMet As String = "02"
 '-----------------------------
 On Error GoTo ERRLOG
 
 ShowResults AllResultsTables.GetFirst()
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
Private Sub LastChoice_Click()
 Const errIDMet As String = "03"
 '-----------------------------
 On Error GoTo ERRLOG
 
 ShowResults AllResultsTables.GetLast()
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
    On Error GoTo ERRLOG
    
    frmReferenceMarkup.Hide
    StartPos = selection.start
    'Markup Main Element
    StartTag = STAGO + ElementType + TAGC
    EndTag = STAGO + "/" + ElementType + TAGC
    '---
    m.DisableScreen
    '---
    selection.InsertBefore StartTag
    selection.InsertAfter EndTag
    With ActiveDocument
      .range(start:=StartPos, End:=StartPos + Len(ElementType) + 2).font.ColorIndex = TagColor(0)
      With .range(start:=StartPos, End:=StartPos + Len(ElementType) + 2).font
        .AllCaps = False: .Italic = False: .Bold = False
        .Subscript = False: .Superscript = False
        .Underline = wdUnderlineNone: .Name = "Arial"
        .Spacing = 0: .Size = 11
        .Animation = wdAnimationNone: .DoubleStrikeThrough = False
        .Emboss = False: .Engrave = False
        .Hidden = False: .Shadow = False
        .StrikeThrough = False: .SmallCaps = False
      End With
      .range(start:=selection.End - Len(ElementType) - 3, End:=selection.End).font.ColorIndex = TagColor(0)
      With .range(start:=selection.End - Len(ElementType) - 3, End:=selection.End).font
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
    For i = 1 To ResultsTable.count
      Set ResultsTableEntry = ResultsTable.GetItem(i)
      If UCase(ResultsTableEntry.SubElement) <> "IGN" Then
       StartTag = STAGO + ResultsTableEntry.SubElement
       StartTag = StartTag + TagsTable.GetTagAttributes(ResultsTableEntry.SubElement)
       StartTag = StartTag + TAGC
       ResultsTableEntry.AbsSTAGStartPos = StartPos + ResultsTableEntry.StartPos - 1
       ResultsTableEntry.AbsSTAGEndPos = ResultsTableEntry.AbsSTAGStartPos + Len(StartTag)
       ActiveDocument.range(start:=ResultsTableEntry.AbsSTAGStartPos).InsertBefore StartTag
       With ActiveDocument.range(start:=ResultsTableEntry.AbsSTAGStartPos, End:=ResultsTableEntry.AbsSTAGEndPos).font
        .AllCaps = False: .Italic = False: .Bold = False
        .Subscript = False: .Superscript = False
        .Underline = wdUnderlineNone: .Name = "Arial"
        .Spacing = 0: .Size = 11
        .Animation = wdAnimationNone: .DoubleStrikeThrough = False
        .Emboss = False: .Engrave = False
        .Hidden = False: .Shadow = False
        .StrikeThrough = False: .SmallCaps = False
       End With
       ActiveDocument.range(start:=ResultsTableEntry.AbsSTAGStartPos, End:=ResultsTableEntry.AbsSTAGEndPos).font.ColorIndex = TagColor(ResultsTableEntry.Level - 1)
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
          ActiveDocument.range(start:=ResultsTableEntry.AbsETAGStartPos).InsertBefore EndTag
          With ActiveDocument.range(start:=ResultsTableEntry.AbsETAGStartPos, End:=ResultsTableEntry.AbsETAGEndPos).font
           .AllCaps = False: .Italic = False: .Bold = False
           .Subscript = False: .Superscript = False
           .Underline = wdUnderlineNone: .Name = "Arial"
           .Spacing = 0: .Size = 11
           .Animation = wdAnimationNone: .DoubleStrikeThrough = False
           .Emboss = False: .Engrave = False
           .Hidden = False: .Shadow = False
           .StrikeThrough = False: .SmallCaps = False
          End With
          ActiveDocument.range(start:=ResultsTableEntry.AbsETAGStartPos, End:=ResultsTableEntry.AbsETAGEndPos).font.ColorIndex = TagColor(ResultsTableEntry.Level - 1)
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
    With selection
      .start = .End
    End With
    '--------------
    Set m = Nothing
    Exit Sub
ERRLOG:
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
 On Error GoTo ERRLOG
  
 ShowResults AllResultsTables.GetNext()
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
Private Sub PreviousChoice_Click()
 Const errIDMet As String = "06"
 '-----------------------------
 On Error GoTo ERRLOG
  
 ShowResults AllResultsTables.GetPrev()
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
Private Sub Undo_Click()
 Const errIDMet As String = "07"
 '-----------------------------
 On Error GoTo ERRLOG
 
 selection.Collapse Direction:=wdCollapseStart
 Unload Me
 Cancel = True
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

Private Sub UserForm_Terminate()
  Const errIDMet As String = "08"
  '-----------------------------
  On Error GoTo ERRLOG
  
  If BotMarkup = False Then
    selection.Collapse Direction:=wdCollapseStart
    Unload Me
    Cancel = True
  Else
    Cancel = False
  End If
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

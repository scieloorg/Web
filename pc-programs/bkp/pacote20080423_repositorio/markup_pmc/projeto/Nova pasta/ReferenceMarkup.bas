Attribute VB_Name = "ReferenceMarkup"
'Automatic Element Markup
'Alberto Pedroso, Feb/98
'--------------
Private mErr As New clsErrList
Const errIDObj As String = "103"
'--------------
'Declare Sub AutomataParserGetErrorMsg Lib "c:\scielo\bin\markup\automata.dll" (ByVal ErrorCode As Long, ByVal ErrorMsg As String, ByVal MsgLen As Long)
'Declare Function AutomataParser Lib "c:\scielo\bin\markup\automata.dll" (ByVal FileName As String, ByVal TTName As String, ByVal InputString As String, ByVal OutputString As String) As Long
Declare Sub AutomataParserGetErrorMsg Lib "automata.dll" (ByVal ErrorCode As Long, ByVal ErrorMsg As String, ByVal MsgLen As Long)
Declare Function AutomataParser Lib "automata.dll" (ByVal Filename As String, ByVal TTName As String, ByVal InputString As String, ByVal OutputString As String) As Long

Dim InputString As String
Public Const STAGO = "["
Public Const TAGC = "]"
Public TagColor(4) As Integer

Function Markup(automata As String, tags As String, elem As String) As String
 'automata -> pathname do arquivo com o automata da norma
 'tags     -> pathname do arquivo com as idetificacoes das tags
 'elem     -> identificador do tipo de elemento de cada norma
 
 Dim OutputString As String * 50000
 Dim ResultsTable As ResultsTable
 Dim ResultsTableEntry As ResultsTableEntry
 Dim i As Long
 Dim tempFile As String
 
 Dim conf As New clsConfig
 conf.LoadPublicValues
 Const errIDMet As String = "01"
 '-----------------------------
 On Error GoTo errLOG
 
 ' Assign colors to levels
 ' local sujeito a modificacoes manuais conforme exigencia do programa
 ' de marcacao
 TagColor(0) = 9
 TagColor(1) = 10
 TagColor(2) = 6
 TagColor(3) = 2
 TagColor(4) = 12
 '
 InputString = Trim(selection.text)
 tempFile = MarkupPrg & "delete.tmp"
 With frmReferenceMarkup
  'modified by Alberto on 27/05/2001
  '------------new version-----------------------
  If Not AutomataParser(automata, elem, InputString, tempFile) Then
    For i = 1 To 9999
    Next
    If Not .AllResultsTables.load(tempFile) Then
        MsgBox conf.msgAutomataFileError, vbCritical, conf.buttonAutomatic
        Exit Function
    End If
  End If
  If Not .TagsTable.load(tags) Then
    Exit Function
  End If
  '-----------------------------------------------
  
  '------------old version-----------------------
  'If Not AutomataParser(automata, elem, InputString, OutputString) Then
  ' .AllResultsTables.Load OutputString
  'End If
  'If Not .TagsTable.Load(tags) Then
  ' Exit Function
  'End If
  '-----------------------------------------------
  .ElementType = elem
  ShowResults .AllResultsTables.GetFirst()
 
  .show
  If .Cancel Then
   Markup = ""
   Exit Function
  End If
  
  Markup = elem + "," + str(selection.start) + "," + str(selection.start + Len(elem) + 2) + "," + str(selection.End - Len(elem) - 3) + "," + str(selection.End) + Chr(10)
  
  Set ResultsTable = .AllResultsTables.GetCurrent()
 End With
 
 For i = 1 To ResultsTable.count
  Set ResultsTableEntry = ResultsTable.GetItem(i)
  '
  With ResultsTableEntry
   If UCase(.SubElement) <> "IGN" Then
    Markup = Markup + .SubElement + "," + str(.AbsSTAGStartPos) + "," + str(.AbsSTAGEndPos) + "," + str(.AbsETAGStartPos) + "," + str(.AbsETAGEndPos) + Chr(10)
   End If
  End With
 Next i
 
 Unload frmReferenceMarkup
 'End
 Exit Function
errLOG:
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Function

Public Sub ShowResults(ResultsTable As ResultsTable)
 Dim line As String, i As Long, j As Long, ResultsTableEntry As ResultsTableEntry
 Dim CurrentFont As New StdFont
 Dim MarkedText As String
 Const errIDMet As String = "02"
 '-----------------------------
 On Error GoTo errLOG
 
 With frmReferenceMarkup
  .Results.Clear
  ' Show List Box
  .ResultsFrame.Caption = .ElementType + ":" + str(.AllResultsTables.index) + "/" + str(.AllResultsTables.count)
  For i = 1 To ResultsTable.count
   Set ResultsTableEntry = ResultsTable.GetItem(i)
   line = Space(ResultsTableEntry.Level * 2) + UCase(ResultsTableEntry.SubElement) + " [" + .TagsTable.GetTagName(ResultsTableEntry.SubElement) + "]"
   .Results.AddItem line
   If ResultsTableEntry.Terminal Then
    line = Space((ResultsTableEntry.Level + 1) * 2) + Mid(InputString, ResultsTableEntry.StartPos, ResultsTableEntry.EndPos - ResultsTableEntry.StartPos + 1)
    .Results.AddItem line
   End If
  Next i
 
  .MarkedText.text = ""
  MarkedText = STAGO + .ElementType + TAGC
  'Show Marked Up Text
  For i = 1 To ResultsTable.count
   Set ResultsTableEntry = ResultsTable.GetItem(i)
   MarkedText = MarkedText + STAGO + ResultsTableEntry.SubElement + TAGC
   If ResultsTableEntry.Terminal Then
    MarkedText = MarkedText + Mid(InputString, ResultsTableEntry.StartPos, ResultsTableEntry.EndPos - ResultsTableEntry.StartPos + 1)
    EndPos = ResultsTableEntry.EndPos
    For j = i To 1 Step -1
     Set ResultsTableEntry = ResultsTable.GetItem(j)
     If ResultsTableEntry.EndPos = EndPos Then
      MarkedText = MarkedText + STAGO + "/" + ResultsTableEntry.SubElement + TAGC
     End If
    Next j
   End If
  Next i
  MarkedText = MarkedText + STAGO + "/" + .ElementType + TAGC
  .MarkedText.text = MarkedText
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

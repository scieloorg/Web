VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ResultsTable"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

'Alberto Pedroso, Feb/98
'Result Table

Private table As New Collection
Const Delimiter = ","
'--------------------
Private mErr As New clsErrList
Const errIDObj As String = "220"

Public Function Count()
 Const errIDMet As String = "01"
 '-----------------------------
 On Error GoTo errLOG
 
 Count = table.Count
 Exit Function
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Function
Public Sub AddNew(Line As String)
 Dim tableEntry As New ResultsTableEntry
 Dim pos As Long, DelimiterPos As Long
 Const errIDMet As String = "02"
 '-----------------------------
 On Error GoTo errLOG
  
 pos = 1
 DelimiterPos = InStr(Line, Delimiter)
 tableEntry.Element = Mid(Line, pos, DelimiterPos - 1)
 '
 pos = DelimiterPos + 1
 DelimiterPos = InStr(pos, Line, Delimiter)
 tableEntry.SubElement = Mid(Line, pos, DelimiterPos - pos)
 '
 pos = DelimiterPos + 1
 DelimiterPos = InStr(pos, Line, Delimiter)
 tableEntry.StartPos = val(Mid(Line, pos, DelimiterPos - pos)) + 1
 '
 pos = DelimiterPos + 1
 DelimiterPos = InStr(pos, Line, Delimiter)
 tableEntry.EndPos = val(Mid(Line, pos, DelimiterPos - pos)) + 1
 '
 pos = DelimiterPos + 1
 DelimiterPos = InStr(pos, Line, Delimiter)
 tableEntry.Level = val(Mid(Line, pos, DelimiterPos - pos))
 '
 pos = DelimiterPos + 1
 If val(Mid(Line, pos)) = 0 Then
  tableEntry.Terminal = False
 Else
  tableEntry.Terminal = True
 End If
 '
 table.Add tableEntry
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
Public Function GetItem(i As Long) As ResultsTableEntry
 Const errIDMet As String = "03"
 '-----------------------------
 On Error GoTo errLOG
 
 Set GetItem = table.Item(i)
 Exit Function
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Function
Public Sub Clean()
 Dim i As Long
 Const errIDMet As String = "04"
 '-----------------------------
 On Error GoTo errLOG
 
 For i = 1 To table.Count
  table.Remove 1
 Next i
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
Private Sub Class_Terminate()
 Const errIDMet As String = "05"
 '-----------------------------
 On Error GoTo errLOG
 
 Clean
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

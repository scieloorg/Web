VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "TagsTable"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

'Alberto Pedroso, Feb/98
'Tags Table

Private table As New collection
Const Delimiter = ";"
Const SecondDelimiter = ","
'-----------------------------
Private mErr As New clsErrList
Const errIDObj As String = "223"

Public Function count()
 Const errIDMet As String = "01"
 '-----------------------------
 On Error GoTo ERRLOG
 
 count = table.count
 Exit Function
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Function
Public Sub AddNew(Line As String)
 Dim tag As New tag
 Dim pos As Long, DelimiterPos As Long
 Const errIDMet As String = "02"
 '-----------------------------
 On Error GoTo ERRLOG
 
 pos = 1
 DelimiterPos = InStr(Line, Delimiter)
 tag.Symbol = Mid(Line, pos, DelimiterPos - 1)
 '
 pos = DelimiterPos + 1
 DelimiterPos = InStr(pos, Line, Delimiter)
 If DelimiterPos <> 0 Then
  tag.Name = Mid(Line, pos, DelimiterPos - pos)
  '
  pos = DelimiterPos + 1
  tag.attributes = Mid(Line, pos)
 Else
  tag.Name = Mid(Line, pos)
  tag.attributes = ""
 End If
 '
 table.add tag, tag.Symbol
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
Public Function GetItem(i As Long) As tag
 Const errIDMet As String = "03"
 '-----------------------------
 On Error GoTo ERRLOG
 
 Set GetItem = table.Item(i)
 Exit Function
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Function
Public Function GetTagName(Key As String) As String
On Error GoTo ExitGetItemKey
 GetTagName = table.Item(Key).Name
 Exit Function
ExitGetItemKey:
 GetTagName = ""
End Function
Public Function GetTagAttributes(Key As String) As String
Dim AuxString As String
Dim pos As Long, SecondDelimiterPos As Long
'
On Error GoTo ExitGetTagAttributes
 AuxString = table.Item(Key).attributes
 If AuxString = "" Then
  GoTo ExitGetTagAttributes
 End If
 pos = 1
 
 SecondDelimiterPos = InStr(AuxString, SecondDelimiter)
 While (SecondDelimiterPos <> 0)
  GetTagAttributes = GetTagAttributes + " " + Mid(AuxString, pos, SecondDelimiterPos - 1) + "="
  '
  pos = SecondDelimiterPos + 1
  SecondDelimiterPos = InStr(pos, AuxString, SecondDelimiter)
 Wend
 GetTagAttributes = GetTagAttributes + " " + Mid(AuxString, pos) + "="
 Exit Function
ExitGetTagAttributes:
 GetTagAttributes = ""
End Function
Public Function load(filename As String) As Boolean
 Dim f As Integer, Line As String
 '
 On Error GoTo OpenError
 '
 f = FreeFile
 Open filename For Input As f
 '
 Do While Not EOF(f)
  Line Input #f, Line
  AddNew (Line)
 Loop
 '
 Close f
 load = True
 Exit Function
 '
OpenError:
 MsgBox "Error encountered while trying to open file " + filename, vbExclamation, AppTitle
 Close f
 load = False
End Function
Public Sub Clean()
 Dim i As Long
 Const errIDMet As String = "04"
 '-----------------------------
 On Error GoTo ERRLOG
 
 For i = 1 To table.count
  table.remove 1
 Next i
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
Private Sub Class_Terminate()
 Const errIDMet As String = "05"
 '-----------------------------
 On Error GoTo ERRLOG
 
 Clean
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

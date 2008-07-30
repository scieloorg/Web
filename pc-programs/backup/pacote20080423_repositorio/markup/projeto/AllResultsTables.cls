VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "AllResultsTables"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

'Alberto Pedroso, Feb/98
'Modified: 25/4/2001
'Set Of Result Tables

Private tables As New collection
Private CurrentTable As Long
Property Get index() As Long
 index = CurrentTable
End Property
Property Get count() As Long
 count = tables.count
End Property
Private Sub Class_Initialize()
 CurrentTable = 1
End Sub
Private Sub AddNew(f As Integer)
 Dim table As New ResultsTable
 Dim TableEntryString As String
 '
 Do
  Line Input #f, TableEntryString
  If TableEntryString <> "" Then
   table.AddNew TableEntryString
  End If
 Loop While TableEntryString <> "" And Not EOF(f)
 
 tables.add table
End Sub
Public Function load(filename As String) As Long
Dim f As Integer, Line As String
 '
 On Error GoTo OpenError
 '
 f = FreeFile
 Open filename For Input As f
 '
 Do While Not EOF(f)
  AddNew (f)
 Loop
 '
 Close f
 Kill (filename)
 load = True
 Exit Function
 '
OpenError:
 Close f
 load = False
End Function
Public Function GetNext() As ResultsTable
 If CurrentTable < tables.count Then
  CurrentTable = CurrentTable + 1
 End If
 Set GetNext = tables.Item(CurrentTable)
End Function
Public Function GetCurrent() As ResultsTable
 Set GetCurrent = tables.Item(CurrentTable)
End Function
Public Function GetPrev() As ResultsTable
 If CurrentTable > 1 Then
  CurrentTable = CurrentTable - 1
 End If
 Set GetPrev = tables.Item(CurrentTable)
End Function
Public Function GetFirst() As ResultsTable
 If CurrentTable > 1 Then
  CurrentTable = 1
 End If
 Set GetFirst = tables.Item(CurrentTable)
End Function
Public Function GetLast() As ResultsTable
 If CurrentTable < tables.count Then
  CurrentTable = tables.count
 End If
 Set GetLast = tables.Item(CurrentTable)
End Function
Public Function GetItem(i As Long) As ResultsTable
 Set GetItem = tables.Item(i)
End Function
Public Sub Clean()
Dim i As Long
 For i = 1 To tables.count
  tables.remove 1
 Next i
End Sub
Private Sub Class_Terminate()
 Clean
End Sub


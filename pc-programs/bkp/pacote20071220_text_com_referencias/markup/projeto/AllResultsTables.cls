VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "AllResultsTables"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

'Alberto Pedroso, Feb/98
'Modified: 25/4/2001
'Set Of Result Tables

Private tables As New Collection
Private CurrentTable As Long
Property Get Index() As Long
 Index = CurrentTable
End Property
Property Get Count() As Long
 Count = tables.Count
End Property
Private Sub Class_Initialize()
 CurrentTable = 1
End Sub
Private Sub AddNew(F As Integer)
 Dim table As New ResultsTable
 Dim TableEntryString As String
 '
 Do
  Line Input #F, TableEntryString
  If TableEntryString <> "" Then
   table.AddNew TableEntryString
  End If
 Loop While TableEntryString <> "" And Not EOF(F)
 
 tables.Add table
End Sub
Public Function Load(filename As String) As Long
Dim F As Integer, Line As String
 '
 On Error GoTo OpenError
 '
 F = FreeFile
 Open filename For Input As F
 '
 Do While Not EOF(F)
  AddNew (F)
 Loop
 '
 Close F
 Kill (filename)
 Load = True
 Exit Function
 '
OpenError:
 Close F
 Load = False
End Function
Public Function GetNext() As ResultsTable
 If CurrentTable < tables.Count Then
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
 If CurrentTable < tables.Count Then
  CurrentTable = tables.Count
 End If
 Set GetLast = tables.Item(CurrentTable)
End Function
Public Function GetItem(i As Long) As ResultsTable
 Set GetItem = tables.Item(i)
End Function
Public Sub Clean()
Dim i As Long
 For i = 1 To tables.Count
  tables.Remove 1
 Next i
End Sub
Private Sub Class_Terminate()
 Clean
End Sub


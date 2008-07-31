VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsRefListManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private unmarkedRefList As New clsRefList
Private markedRefList As New clsRefList
    
Private mkFile As String

Private Function getUnmarkedFileName() As String
    getUnmarkedFileName = mkFile + ".uref.txt"
End Function
Private Function getMarkedFileName() As String
    getMarkedFileName = mkFile + ".mref.txt"
End Function

Public Sub store()
    Call unmarkedRefList.storeReferences(getUnmarkedFileName())
    Call markedRefList.storeReferences(getMarkedFileName())
End Sub

Public Sub load(MarkupFilename As String)
    mkFile = MarkupFilename
    
    Call unmarkedRefList.loadRefList(getUnmarkedFileName())
    
    Call markedRefList.loadRefList(getMarkedFileName())
    
    
End Sub

Public Function recoverUnmarkedReference(markedReference As String) As String
    Dim i As Long
    
    i = markedRefList.search(markedReference)
    If i > 0 Then
        recoverUnmarkedReference = unmarkedRefList.Item(i).Reference
        unmarkedRefList.remove (i)
        markedRefList.remove (i)
        store
    Else
        recoverUnmarkedReference = ""
    End If
End Function

Sub insertMostRecentReferences(unmarked As String, marked As String)
    Dim u As New clsRefList
    Dim m As New clsRefList
    
    u.loadRefListFromString (unmarked)
    m.loadRefListFromString (marked)
    
    Call unmarkedRefList.insertNewItems(u)
    Call markedRefList.insertNewItems(m)
    
End Sub


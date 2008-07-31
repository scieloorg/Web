VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClLista"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

Private mCol As MyCollection

Function ElemStr(i As Long) As String
    ElemStr = mCol.Item(i)
End Function

Function ElemLng(i As Long) As Long
    ElemLng = mCol.Item(i)
End Function

Public Function existe(Elem As Variant) As Boolean
    Dim ha As Boolean
    IsObject (mCol.Item(Elem, ha))
        
    existe = ha
End Function

Public Function Remove(Elem As Variant) As Boolean
    Remove = mCol.Remove(Elem)
End Function

Public Function Insere(Elem As Variant) As Boolean
    On Error GoTo InsereErr
    Call mCol.Add(Elem, CStr(Elem))
    Insere = True

    Exit Function
InsereErr:
    Insere = False
End Function

Public Property Get Count() As Long
    Count = mCol.Count
End Property

Private Sub Class_Initialize()
    Set mCol = New MyCollection
End Sub

Private Sub Class_Terminate()
    Set mCol = Nothing
End Sub

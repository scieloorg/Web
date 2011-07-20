VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClsLabels"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private col As Collection




Public Sub add(id As String, label As String)
    Dim o As New ClsLabel
    
    o.id = id
    o.label = label

    Call col.add(o, id)
    

End Sub


Public Function itemById(id As String) As ClsLabel
    Set itemById = col.item(id)
End Function

Private Sub Class_Initialize()
    Set col = New Collection
    
    
End Sub

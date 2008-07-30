VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ColToC"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"


Option Explicit

Private ToCs As New Collection

Public Function Add(key As String) As ClToC
    Dim novo As New ClToC
    
    With novo
        .Id = key
        ToCs.Add novo, key
    End With
    Set Add = novo
End Function

Public Sub Delete(ByVal idx As Variant)
    ToCs.Remove idx
End Sub

Public Function Count() As Long
    Count = ToCs.Count
End Function

Public Function Item(ByVal idx As Variant) As ClToC
    Set Item = ToCs.Item(idx)
End Function

Function MontarRegistro() As String
    Dim Aux As String
    Dim i As Long
    
    For i = 1 To Count
        Aux = Aux + Item(i).MontarRegistro
    Next
    MontarRegistro = Aux
End Function




VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ColLegenda"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"


Option Explicit

Private Legendas As New Collection

Public Function Add(Id As String, Idioma As String) As ClLegenda
    Dim novo As New ClLegenda
    
    With novo
        .Id = Id
        .Idioma = Idioma
        Legendas.Add novo, Id
    End With
    Set Add = novo
End Function

Public Sub Delete(ByVal idx As Variant)
    Legendas.Remove idx
End Sub

Public Function Count() As Long
    Count = Legendas.Count
End Function

Public Function Item(ByVal idx As Variant) As ClLegenda
    Set Item = Legendas.Item(idx)
End Function

Function MontarRegistro() As String
    Dim Aux As String
    Dim i As Long
    
    For i = 1 To Count
        Aux = Aux + Item(i).MontarRegistro
    Next
    MontarRegistro = Aux
End Function




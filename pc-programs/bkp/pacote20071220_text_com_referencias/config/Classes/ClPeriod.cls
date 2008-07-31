VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClPeriodico"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

Private vTitulo As String
Private vSigla As String
Private vTitAbr As String
Private vISSN As String
Private vCidade As String
Private vPublicador As String
Private vTitAlt() As String
Private qtdTitAlt As Long
Private vIssue As ClIssue
Private mvarIssIdioma As ColIdiomIss  'local copy


Public Property Set IssIdioma(ByVal vData As Object)
'used when assigning an Object to the property, on the left side of a Set statement.
'Syntax: Set x.IssIdioma = Form1
    Set mvarIssIdioma = vData
End Property

Public Property Get IssIdioma() As ColIdiomIss
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.IssIdioma
    Set IssIdioma = mvarIssIdioma
End Property

Property Get Issue() As ClIssue
    Set Issue = vIssue
End Property
Property Set Issue(v As ClIssue)
    Set vIssue = v
End Property
Property Get Sigla() As String
    Sigla = vSigla
End Property
Property Let Sigla(v As String)
    vSigla = v
End Property
Property Get TitAbr() As String
    TitAbr = vTitAbr
End Property
Property Let TitAbr(v As String)
    vTitAbr = v
End Property
Property Get Titulo() As String
    Titulo = vTitulo
End Property
Property Let Titulo(v As String)
    vTitulo = v
End Property
Property Get Publicador() As String
    Publicador = vPublicador
End Property
Property Let Publicador(v As String)
    vPublicador = v
End Property
Property Get Cidade() As String
    Cidade = vCidade
End Property
Property Let Cidade(v As String)
    vCidade = v
End Property
Property Get issn() As String
    issn = vISSN
End Property
Property Let issn(v As String)
    vISSN = v
End Property

Property Get TitAlt(vet() As String) As Long
    Dim j As Long
    
    ReDim vet(qtdTitAlt)
    For j = 1 To qtdTitAlt
        vet(j) = vTitAlt(j)
    Next
    TitAlt = qtdTitAlt
End Property
Property Let TitAlt(vet() As String, n As Long)
    Dim j As Long
    
    If n > 0 Then
        qtdTitAlt = n
        ReDim vTitAlt(qtdTitAlt)
        For j = 1 To qtdTitAlt
            vTitAlt(j) = vet(j)
        Next
    End If
End Property

Sub Limpa()
    Dim i As Long
    
    vTitulo = ""
    vTitAbr = ""
    Erase vTitAlt
    qtdTitAlt = 0
    vSigla = ""
    vISSN = ""
    vCidade = ""
    vPublicador = ""
    vIssue.Limpa
    For i = 1 To mvarIssIdioma.Count
        mvarIssIdioma.Item(i).Limpa
    Next
End Sub

Function MontarRegistro() As String
    Dim aux As String
    Dim i As Long
    
    aux = aux + TagContent(vTitulo, ConfigVars("TagPerTit").value)
    aux = aux + TagContent(vTitAbr, ConfigVars("TagPerTitAbr").value)
    aux = aux + TagContent(vISSN, DBIssueTags("issn").value)
    aux = aux + TagContent(vPublicador, ConfigVars("TagPubId").value)
    For i = 1 To qtdTitAlt
        aux = aux + TagContent(vTitAlt(i), ConfigVars("TagPerTitAlt").value)
    Next
    aux = aux + Issue.MontarRegistro
    aux = aux + IssIdioma.MontarRegistro
    MontarRegistro = aux
End Function

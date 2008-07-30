VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClLegenda"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

Private vTitAbr As String
Private vVol As String
Private vNro As String
Private vLoc As String
Private vMes As String
Private vAno As String
Private vIdiomaCod As String
'local variable(s) to hold property value(s)
Private mvarPreenchido As Boolean 'local copy
Public Property Let Preenchido(ByVal vData As Boolean)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Preenchido = 5
    mvarPreenchido = vData
End Property


Public Property Get Preenchido() As Boolean
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Preenchido
    Preenchido = mvarPreenchido
End Property

Property Let TitAbr(v As String)
    vTitAbr = v
End Property
Property Get TitAbr() As String
    TitAbr = vTitAbr
End Property
Property Let Vol(v As String)
    vVol = v
End Property
Property Get Vol() As String
    Vol = vVol
End Property
Property Let Nro(v As String)
    vNro = v
End Property
Property Get Nro() As String
    Nro = vNro
End Property
Property Let Loc(v As String)
    vLoc = v
End Property
Property Get Loc() As String
    Loc = vLoc
End Property
Property Let mes(v As String)
    vMes = v
End Property
Property Get mes() As String
    mes = vMes
End Property
Property Let ano(v As String)
    vAno = v
End Property
Property Get ano() As String
    ano = vAno
End Property
Property Let IdiomaCod(v As String)
    vIdiomaCod = v
End Property
Property Get IdiomaCod() As String
    IdiomaCod = vIdiomaCod
End Property
Function MontarRegistro() As String
    Dim aux As String
    
    If Preenchido Then
        aux = aux + TagContent("^l" + vIdiomaCod + "^t" + TitAbr + "^v" + vVol + "^n" + vNro + "^c" + vLoc + "^m" + vMes + "^a" + vAno, ConfigVars("TagLegenda").value)
        aux = aux + TagContent("^l" + vIdiomaCod + "^m" + vMes + "^a" + vAno, ConfigVars("TagFascDate").value)
    End If
    MontarRegistro = aux
End Function

Sub Limpa()
    vTitAbr = ""
    vVol = ""
    vNro = ""
    vLoc = ""
    vMes = ""
    vAno = ""
    mvarPreenchido = False
End Sub

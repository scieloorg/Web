VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClToC"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

Private vIdiomaCod As String
Private vHeader As String
Private vSecTitle() As String
Private vSecCode() As String
Private vQtdSec As Long
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
Property Let header(v As String)
    vHeader = v
End Property
Property Get header() As String
    header = vHeader
End Property
Property Let IdiomaCod(v As String)
    vIdiomaCod = v
End Property
Property Get IdiomaCod() As String
    IdiomaCod = vIdiomaCod
End Property
Property Let sectitle(i As Long, v As String)
    If i > QtdSec Then
        ReDim Preserve vSecCode(i)
        ReDim Preserve vSecTitle(i)
        QtdSec = i
    End If
    vSecTitle(i) = v
End Property
Property Get sectitle(i As Long) As String
    If (i > 0) And (i <= QtdSec) Then
        sectitle = vSecTitle(i)
    Else
        sectitle = ""
    End If
End Property
Property Let seccode(i As Long, v As String)
    If i > QtdSec Then
        ReDim Preserve vSecCode(i)
        ReDim Preserve vSecTitle(i)
        QtdSec = i
    End If
    vSecCode(i) = v
End Property
Property Get seccode(i As Long) As String
    If (i > 0) And (i <= QtdSec) Then
        seccode = vSecCode(i)
    Else
        seccode = ""
    End If
End Property
Property Let QtdSec(v As Long)
    vQtdSec = v
    ReDim Preserve vSecTitle(v)
    ReDim Preserve vSecCode(v)
End Property
Property Get QtdSec() As Long
    QtdSec = vQtdSec
End Property
Function MontarRegistro() As String
    Dim aux As String
    Dim aux2 As String
    Dim i As Long
    
    If Preenchido Then
        aux2 = "^l" + IdiomaCod
        aux = TagContent(aux2 + "^h" + vHeader, GlVar("TagSecHeader").Value)
        For i = 1 To QtdSec
            aux = aux + TagContent(aux2 + "^c" + vSecCode(i) + "^t" + vSecTitle(i), GlVar("TagSeccode").Value)
        Next
    End If
    MontarRegistro = aux
End Function
Sub Limpa()
  vHeader = ""
  Erase vSecTitle
  Erase vSecCode
  vQtdSec = 0
  mvarPreenchido = False
End Sub

Sub RmSection(i As Long)
    Dim j As Long
    
    j = i
    While j < QtdSec
        j = j + 1
        sectitle(j - 1) = sectitle(j)
        seccode(j - 1) = seccode(j)
    Wend
    QtdSec = QtdSec - 1
    
End Sub

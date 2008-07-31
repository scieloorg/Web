VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsBarNavegation"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private navegation As String

Sub downLevel(barName As String)
    navegation = barName & ";" & navegation
End Sub

Function getUpLevel() As String
    Dim r As String
    Dim p As Long
    
    p = InStr(navegation, ";")
    If p > 0 Then
        r = Mid(navegation, 1, p - 1)
        navegation = Mid(navegation, p + 1)
    Else
        r = navegation
    End If
    getUpLevel = r
End Function

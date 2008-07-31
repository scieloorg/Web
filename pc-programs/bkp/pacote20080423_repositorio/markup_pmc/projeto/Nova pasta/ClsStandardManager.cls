VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClsStandardManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Function getStandard(standard As String) As ClsStandard
    Dim s As New ClsStandard
    
    s.standard = standard
    s.ref_barName = getRefBarName(standard)
    s.ref_tagName = getRefTagName(standard)
    s.standard_barName = getStandardBarName(standard)
    s.standard_tagName = getStandardTagName(standard)
    
    Set getStandard = s
End Function

Private Function getRefTagName(standard As String) As String
    Dim c As String
    
    Select Case standard
    Case "vancouv"
        c = "vcitat"
    Case "other"
        c = "ocitat"
    Case "iso"
        c = "icitat"
    Case "nbr6030"
        c = "acitat"
    Case Else
        
    End Select
    getRefTagName = c
End Function

Private Function getStandardTagName(standard As String) As String
    Dim c As String
    
    Select Case standard
    Case "vancouv"
        c = "vancouv"
    Case "other"
        c = "other"
    Case "iso690"
        c = "iso690"
    Case "nbr6030"
        c = "abnt6023"
    Case Else
        
    End Select
    getStandardTagName = c
End Function

Private Function getRefBarName(standard As String) As String
    getRefBarName = getStandardTagName(standard)
End Function

Private Function getStandardBarName(standard As String) As String
    getStandardBarName = "back"
End Function


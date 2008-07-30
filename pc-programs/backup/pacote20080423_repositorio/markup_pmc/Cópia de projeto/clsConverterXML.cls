VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsConverterXML"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private mErr As New clsErrList
Const errIDObj As String = "700"
Private mvarXSLToConvertXML As String
Public doDebug As Boolean

Private xslt As New MSXML2.XSLTemplate30
Private xslDoc As New MSXML2.FreeThreadedDOMDocument30
Private xmlDoc As New MSXML2.DOMDocument30
Private xslProc As IXSLProcessor
    
Public Property Get xslToConvertXML() As String
    xslToConvertXML = mvarXSLToConvertXML
End Property

Public Property Let xslToConvertXML(ByVal vNewValue As String)
    mvarXSLToConvertXML = vNewValue
End Property

Public Function convertXML(textInXML As String) As String
    If loadXML(textInXML, "UTF-8", True) And loadXSL() Then
MsgBox "convertXML 1"
    
        Set xslt.StyleSheet = xslDoc
MsgBox "convertXML 2"
        Set xslProc = xslt.createProcessor()
MsgBox "convertXML 3"
        xslProc.input = xmlDoc
MsgBox "convertXML 4"
        
        xslProc.transform
MsgBox "convertXML 5"
        convertXML = xslProc.output
    End If
End Function


Public Function loadXML(xml As String, encoding As String, Optional showMessage As Boolean) As Boolean
MsgBox "loadXML"

    If InStr(xml, "<?xml") = 0 Then
        xml = "<?xml version=" & Chr(34) & "1.0" & Chr(34) & " encoding=" & Chr(34) & encoding & Chr(34) & "?>" & xml
    End If
    If InStr(xml, "<?xml") > 1 Then
        xml = Mid(xml, InStr(xml, "<?xml"))
    End If
    
        
    xmlDoc.async = False
    xmlDoc.loadXML xml

    If (xmlDoc.parseError.ErrorCode <> 0) Then
        If showMessage Then
            Dim myErr
            Dim lines() As String
            Dim x As String
            Dim c As String
            Dim y As Long
            
            
            Set myErr = xmlDoc.parseError
            
            x = Mid(xml, xmlDoc.parseError.filepos, 200)
            c = Mid(x, 1, 1)
            MsgBox "XML document error: " + myErr.reason + _
            vbCrLf + " error code: " + CStr(myErr.ErrorCode) + "character: " + CStr(Asc(c)) + vbCrLf + x + vbCrLf
        End If
    End If
MsgBox "loadXML"
    loadXML = (xmlDoc.parseError.ErrorCode = 0)
End Function
Private Function loadXSL() As Boolean
MsgBox "loadXSL"
    xslDoc.async = False
    xslDoc.load xslToConvertXML

    If (xslDoc.parseError.ErrorCode <> 0) Then
       Dim myErr
       Set myErr = xslDoc.parseError
       MsgBox "Stylesheet error: " + myErr.reason
    End If
MsgBox "loadXSL"
    
    loadXSL = (xslDoc.parseError.ErrorCode = 0)
End Function




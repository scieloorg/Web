VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsConverterXML2SGML"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private mErr As New clsErrList
Const errIDObj As String = "700"
Private mvarXSLToConvertXML2SGML As String
Public doDebug As Boolean

Public Property Get xslToConvertXML2SGML() As String
    xslToConvertXML2SGML = mvarXSLToConvertXML2SGML
End Property

Public Property Let xslToConvertXML2SGML(ByVal vNewValue As String)
    mvarXSLToConvertXML2SGML = vNewValue
End Property

Public Function convertXML2SGML(referencesInXML As String, insertMainTag As Boolean) As String
    
    Dim xslt As New MSXML2.XSLTemplate30
    Dim xslDoc As New MSXML2.FreeThreadedDOMDocument30
    Dim xmlDoc As New MSXML2.DOMDocument30
    Dim xslProc As IXSLProcessor
    Dim r As String
    
    referencesInXML = myReplace(referencesInXML, "[", "MARKUP_91")
    referencesInXML = myReplace(referencesInXML, "]", "MARKUP_93")
      
    If doDebug Then MsgBox "convertXML2SGML 1"

    If insertMainTag Then
        referencesInXML = myReplace(referencesInXML, "<ref-list>", "<ref-list><insert-main-tag/>")
    End If
    referencesInXML = "<?xml version=" & Chr(34) & "1.0" & Chr(34) & " encoding=" & Chr(34) & "UTF-8" & Chr(34) & "?>" & referencesInXML
    xslDoc.async = False
    xslDoc.load xslToConvertXML2SGML
    
    If doDebug Then MsgBox "convertXML2SGML 2 " & xslToConvertXML2SGML

    If (xslDoc.parseError.ErrorCode <> 0) Then
       Dim myErr
       Set myErr = xslDoc.parseError
       MsgBox "Stylesheet error: " + myErr.reason
    Else
        If doDebug Then MsgBox "convertXML2SGML 3a"

       Set xslt.StyleSheet = xslDoc
       xmlDoc.async = False
       
       If doDebug Then MsgBox "convertXML2SGML 3b"

       xmlDoc.LoadXml referencesInXML
       
       If doDebug Then MsgBox "convertXML2SGML 3b"

       If (xmlDoc.parseError.ErrorCode <> 0) Then
          Set myErr = xmlDoc.parseError
          MsgBox "XML document error: " + myErr.reason
       Else
          Set xslProc = xslt.createProcessor()
          
          If doDebug Then MsgBox "convertXML2SGML 4"

          xslProc.input = xmlDoc
          
          If doDebug Then MsgBox "convertXML2SGML 5"

          xslProc.transform
          If doDebug Then MsgBox "convertXML2SGML 6"

          r = xslProc.output
          If doDebug Then MsgBox "convertXML2SGML 7"

       End If
    End If
    
    r = myReplace(r, "MARKUP_91", "&#091;")
    r = myReplace(r, "MARKUP_93", "&#093;")

    
    convertXML2SGML = r
End Function

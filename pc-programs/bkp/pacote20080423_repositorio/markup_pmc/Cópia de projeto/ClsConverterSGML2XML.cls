VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClsConverterSGML2XML"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private sgmlChars As New collection


Function convert(SGML_text As String) As String
    Dim xmlConverter As New clsConverterXML
    Dim XML_text As String
    Dim r As String
    
    loadTable
    xmlConverter.xslToConvertXML = MarkupPrg & "pmc\sgml2pmc.xsl"
    
    
    XML_text = convertSGML2XML(SGML_text)
    
    r = xmlConverter.convertXML(XML_text)
    If Len(r) > 0 Then
        If xmlConverter.loadXML(r, "utf-8", True) Then
            convert = r
        End If
    End If
End Function

Function convertSGML2XML(SGML_text As String) As String
    
    Dim openTag As String
    Dim p As Long
    Dim l As Long
    Dim XML_text As String
    
    XML_text = SGML_text
    
    XML_text = replaceSGMLChars(XML_text)
    XML_text = myReplace(XML_text, Chr(160), " ")
    XML_text = myReplace(XML_text, "&amp;", "&")
    XML_text = myReplace(XML_text, "& ", "&amp; ")
    XML_text = myReplace(XML_text, "<", "&lt;")
    XML_text = myReplace(XML_text, "[/", "</")
    
    p = 1
    
    openTag = findNextOpenTag(XML_text, p)
    While Len(openTag) > 0
        l = Len(openTag)
        If InStr(openTag, " ") > 0 Then
            
            openTag = putAttributesBetweenQuotes(openTag)
            
            XML_text = Mid(XML_text, 1, p - 1) + openTag + Mid(XML_text, p + l)
        End If
        p = p + 1
        openTag = findNextOpenTag(XML_text, p)
    Wend
    XML_text = myReplace(XML_text, "&quot;", Chr(34))
    XML_text = myReplace(XML_text, ">", "&gt;")
    XML_text = myReplace(XML_text, "[", "<")
    XML_text = myReplace(XML_text, "]", ">")
    XML_text = myReplace(XML_text, "&#091;", "[")
    XML_text = myReplace(XML_text, "&#093;", "]")
    
    
    convertSGML2XML = XML_text
End Function
Function findNextOpenTag(text As String, p As Long) As String
    Dim r As String
    Dim p2 As Long
    
    
    p = InStr(p, text, "[")
    If p > 0 Then
        p2 = InStr(p, text, "]")
        If p2 > 0 Then
            r = Mid(text, p, p2 - p + 1)
        End If
    End If
    
    findNextOpenTag = r
End Function

Function putAttributesBetweenQuotes(ByVal text As String) As String
    Dim p As Long
    Dim slice As String
    Dim i As Long
    Dim ntext As String, nslice As String
    Dim pEq As Long
    Dim pQ As Long
    
    text = Mid(text, 2, Len(text) - 2)
    text = Trim(myReplace(text, "  ", " ")) & " "
    p = InStr(text, " ")
    While p > 0
        slice = Mid(text, 1, p - 1)
        pEq = InStr(slice, "=")
        If pEq > 0 Then
            pQ = InStr(slice, Chr(34))
            If pQ > 0 Then
                ntext = ntext & " " & slice
            Else
                ntext = ntext & " " & Mid(slice, 1, pEq) & Chr(34) & Mid(slice, pEq + 1) & Chr(34)
            End If
        Else
            ntext = ntext & " " & slice
        End If
        text = Mid(text, p + 1)
        p = InStr(text, " ")
    Wend
    putAttributesBetweenQuotes = "[" & Trim(ntext) & "]"
    
End Function

Sub loadTable()
  
  Dim f As Integer
  '--------------------------------
  Dim aux As String, ok As Boolean
  Dim sgml As String, win As String
  Dim r As ClsSGMLEnt
  
  Const errIDMet As String = "10"
  '-----------------------------
  On Error GoTo errLOG
  
  f = FreeFile
  Open MarkupPrg & "pmc\sgm2win2.txt" For Input As #f
  While Not EOF(f)
    Input #f, sgml, win
    
    Set r = New ClsSGMLEnt
    r.sgml = sgml
    r.win = win
    
    Call sgmlChars.add(r)
  Wend
  Close f
  
  Exit Sub
errLOG:
  MsgBox "error in clsConverterSGML2XML.loadTable"
End
End Sub

Function replaceSGMLChars(s As String) As String
    Dim i As Long
    Dim s1 As String
    Dim s2 As String
    
    
    s1 = s
    For i = 1 To sgmlChars.count
        s2 = myReplace(s1, sgmlChars.Item(i).sgml, sgmlChars.Item(i).win)
        If s1 <> s2 Then
            'MsgBox sgmlChars.Item(i).sgml & " " & sgmlChars.Item(i).win
            s1 = s2
        End If
    Next
    replaceSGMLChars = s2
End Function

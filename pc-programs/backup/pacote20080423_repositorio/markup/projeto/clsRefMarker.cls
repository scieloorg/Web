VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsRefMarker"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private mErr As New clsErrList
Const errIDObj As String = "500"

Private refIdentifier As clsRefIdentifier
Private mvarService As Object
Private mvarRulesToConvertXML2SGML As String
Private mvarStandard As String
Public doDebug As Boolean

Public Property Get standard() As String
    standard = mvarStandard
End Property

Public Property Let standard(ByVal vNewValue As String)
    mvarStandard = vNewValue
End Property
Public Property Get rulesToConvertXML2SGML() As String
    rulesToConvertXML2SGML = mvarRulesToConvertXML2SGML
End Property

Public Property Let rulesToConvertXML2SGML(ByVal vNewValue As String)
    mvarRulesToConvertXML2SGML = vNewValue
End Property
Public Property Get Service() As Object
    Set Service = mvarService
End Property

Public Property Set Service(vNewValue As Object)
    Set mvarService = vNewValue
End Property

Sub MarkReferences(ByRef referencesrange As range, insertMainTag As Boolean)
    Dim start As Long
    Dim strReferencesMarked As String
    Dim unmarked As String
    
    If doDebug Then MsgBox "MarkReferences inicio"
    
    start = referencesrange.start
    
    unmarked = referencesrange.text
    If doDebug Then MsgBox "MarkReferences 1"
    
    strReferencesMarked = mark(refIdentifier.getReferencesIdentified(Service, standard, referencesrange.text), insertMainTag)
    If doDebug Then MsgBox "MarkReferences 2"
    
    If Len(Trim(strReferencesMarked)) > 0 Then
        Call insert2(start, referencesrange, strReferencesMarked, doDebug)
    Else
        If doDebug Then MsgBox "MarkReferences não foi possível converter para sgml"
    End If
    
        
    If doDebug Then MsgBox "MarkReferences fim"
End Sub

Private Sub insert1(start As Long, referencesrange As range, strReferencesMarked As String, Optional doDebug As Boolean)
    If doDebug Then MsgBox "MarkReferences marcadas"
        
    referencesrange.Delete
    Call referencesrange.SetRange(start, start)
        
    If doDebug Then MsgBox "MarkReferences insere refencias marcadas"
         
    referencesrange.InsertAfter (strReferencesMarked)
        
    'Call referencesrange.SetRange(start, Len(strReferencesMarked))
        
    If Not doDebug Then Call formatMarks(referencesrange)
End Sub
Private Sub insert2(start As Long, referencesrange As range, strReferencesMarked As String, Optional doDebug As Boolean)
    referencesrange.text = strReferencesMarked
    If doDebug Then MsgBox "texto para substituir : " & CStr(Len(strReferencesMarked))
    Call formatMarks2(referencesrange)
End Sub
Private Function mark(xmlReferences As MSXML2.IXMLDOMNode, insertMainTag As Boolean) As String
    'MsgBox "Converte xml para sgml"
    Dim x As String
    
    If rulesToConvertXML2SGML <> "" Then
        Dim converter As New clsConverterXML2SGML
        converter.xslToConvertXML2SGML = rulesToConvertXML2SGML
        converter.doDebug = doDebug
        x = converter.convertXML2SGML(xmlReferences.XML, insertMainTag)
    Else
        x = myReplace(xmlReferences.XML, "<", "[")
        x = myReplace(x, ">", "]")
    End If
    mark = x
End Function

Private Sub formatMarks(ByRef references As range)
    ' colore as marcações
    'references.Font.color = wdColorTurquoise
    
    Dim mr As clsMarkupRange
    Dim sPos1 As Long, fPos1 As Long
    Dim sPos2 As Long, fPos2 As Long
    Dim color As Long
    Dim tagInicial As Long, tagFinal As Boolean
    
    Dim originalEnd As Long
    
    originalEnd = references.End
    
    color = 10
    
    Set mr = New clsMarkupRange
    Set mr.MyRange = references
    
    'Call mr.FormatText(mr.MyRange, 1, "Ti")
    
    While mr.findText("[", True, sPos1, fPos1)
        
        Call mr.MyRange.SetRange(sPos1 + 1, sPos1 + 2)
        tagFinal = (mr.MyRange.text = "/")
        
        If Not tagFinal Then
            color = color + 1
        End If
        
        Call mr.MyRange.SetRange(sPos1, originalEnd)
        If mr.findText("]", True, sPos2, fPos2) Then
            Call mr.MyRange.SetRange(sPos1, fPos2)
            
            Call mr.FormatText(mr.MyRange, color)
            Call mr.MyRange.SetRange(sPos2 + 1, originalEnd)
        End If
        
        If tagFinal Then
            color = color - 1
        End If
    Wend
    
End Sub
Private Sub formatMarks2(ByRef references As range)
    Dim mr As clsMarkupRange
    
    Set mr = New clsMarkupRange
    Call mr.formatMarks(references)
        
End Sub
Private Sub Class_Initialize()
    Set refIdentifier = New clsRefIdentifier
End Sub



VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsRefIdentifier"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private mErr As New clsErrList
Private Service As Object

Const errIDObj As String = "505"


Function getReferencesIdentified(Service As Object, standard As String, references As String) As MSXML2.IXMLDOMNode

    Dim str As String
    Dim x As New MSXML2.DOMDocument30
    Dim resultNode As MSXML2.IXMLDOMNode
    
    Dim error As Long
    
    On Error GoTo ERRLOG
    str = "<ref-list>" & references & "</ref-list>"
    If x.LoadXml(str) Then
        Set resultNode = x.CloneNode(True)
    End If
    Set getReferencesIdentified = resultNode

    str = Service.request(standard, references, error)
    If error = 0 Then
        If x.LoadXml(str) Then
            Set resultNode = x.CloneNode(True)
        End If
    End If
    Set getReferencesIdentified = resultNode
    
    Exit Function
    
ERRLOG:
    MsgBox "getReferencesIdentified " & err.Description
End Function


VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsRefList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private mErr As New clsErrList
Const errIDObj As String = "502"

Private mvarReferences As New collection

Sub add(ref As clsRef)
    Call mvarReferences.add(ref)
End Sub
Function Item(i As Long) As clsRef
    Set Item = mvarReferences.Item(i)
End Function
Function count() As Long
    count = mvarReferences.count
End Function

Sub remove(index As Long)
    Call mvarReferences.remove(index)
End Sub


Public Sub storeReferences(Filename As String)
    Dim file As New clsFile
    Call file.writeFile(Filename, getReferencesText)
End Sub

Function getReferencesText() As String
    Dim i As Long
    Dim r As String
    
    For i = 1 To count
        r = r & vbCrLf & Item(i).Reference
    Next
    getReferencesText = r
End Function
 Function search(Reference As String) As Long
    Dim found As Long
    Dim i As Long
    
    i = 1
    While found = 0 And i <= count
        If StrComp(Trim(Item(i).Reference), Trim(Reference), vbTextCompare) = 0 Then
            found = i
        Else
            MsgBox Reference & vbCrLf & Item(i).Reference
        End If
        i = i + 1
    Wend
    search = found
End Function
Sub loadRefList(Filename As String)
        
    On Error Resume Next
    
    Dim f As Long
    Dim line As String
    Dim ref As clsRef
    Dim lineIndex As Long
    If Dir(Filename) <> "" Then
        f = FreeFile
        Open Filename For Input As #f
        While Not (EOF(f))
            Line Input #f, line
            If Len(line) > 0 Then
                lineIndex = lineIndex + 1
                Set ref = New clsRef
                ref.Reference = line
                
                Call add(ref)
            End If
        Wend
        Close #f
    End If
End Sub


Sub loadRefListFromString(referencesText As String)
        
    Dim i As Long
    Dim line As String
    Dim ref As clsRef
    Dim lineIndex As Long
    Dim references() As String
    Dim br As String
    
    Dim test As String
    Dim c As String
    Dim j As Long
    Dim f As New clsFile
    
    If InStr(referencesText, "[") > 0 Then
    For j = 1 To Len(referencesText)
        test = test & "|" & Mid(referencesText, j, 1) & "|" & "=" & Asc(Mid(referencesText, j, 1)) & vbCrLf
    Next
    Call f.writeFile("d:\teste.roberta.txt", referencesText & vbCrLf & test)
    End If
    
    If InStr(referencesText, vbCrLf) > 0 Then
        br = vbCrLf
    ElseIf InStr(referencesText, vbCr) > 0 Then
        br = vbCr
    ElseIf InStr(referencesText, vbLf) > 0 Then
        br = vbLf
    Else
        br = vbCrLf
    End If
    
    references = Split(referencesText, br)
    
    For i = 0 To UBound(references) - 1
        
        If Len(references(i)) > 0 Then
            lineIndex = lineIndex + 1
            Set ref = New clsRef
                    
            ref.Reference = references(i)
                    
            Call add(ref)
        End If
    Next
    
End Sub
Sub insertNewItems(n As clsRefList)
    Dim i As Long
    Dim ref As clsRef
    
    
    For i = 1 To n.count
        Set ref = New clsRef
        
        ref.Reference = n.Item(i).Reference
        Call add(ref)
    Next
End Sub

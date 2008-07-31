VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsMarkupFigTab"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private mErr As New clsErrList
Const errIDObj As String = "9217"

Public temp As String

Private mvarMarkupRange As New clsMarkupRange

Property Get MarkupRange() As clsMarkupRange
    Set MarkupRange = mvarMarkupRange
End Property

Property Set MarkupRange(v As clsMarkupRange)
    Set mvarMarkupRange = v
End Property
Public Function VerifyInsertInto_FigTable(s As Long, e As Long) As Boolean
  Dim tag As String
  Dim OpenTagStart As Long
  Dim contentStart As Long
  Dim contentEnd As Long
  Dim pTagClose As Long
  
  Dim pStart As Long, pEnd As Long
  Dim tagOK As Boolean
  Dim error As Boolean
  
  Dim t As String
  Dim r As Boolean
  
  Dim SelStart As Long, SelEnd As Long
  Dim texto As String
  
  Const errIDMet As String = "99"
  '-----------------------------
  On Error GoTo errLOG
    
    
    SelStart = selection.start
    SelEnd = selection.End
    
    Call MarkupRange.MyRange.SetRange(s, e)
    
    texto = MarkupRange.MyRange.text
    temp = temp & vbCrLf & vbCrLf & "------------------"
    temp = temp & vbCrLf & texto
    
    If s = e Or s + 1 = e Then
        r = True
    Else
        contentStart = 0
        contentEnd = 0
        pStart = 0
            
        If MarkupRange.existTAGCBeforeSTAGO(s, e, pStart) Then
    
        Else
            If pStart > 0 Then
                Do
                    temp = temp & vbCrLf & " pStart " & CStr(pStart)
                    tag = MarkupRange.findOpenTag(pStart, e, contentStart)
                    If Len(tag) > 0 Then
                        If MarkupRange.listbar.FoundTag(tag) Then
                            tagOK = True
                        End If
                    End If
                    If Not tagOK Then
                        pStart = MarkupRange.findSTAGO(pStart + 1, e)
                    End If
                Loop Until tagOK Or (pStart > e)
                
                If tagOK Then
                    temp = temp & vbCrLf & tag
    
                    If MarkupRange.findCloseTag(pStart, e, tag, contentEnd, pTagClose) Then
                        temp = temp & vbCrLf & "______" & vbCrLf & "Content ..." & texto
                        temp = temp & vbCrLf & "Content ..." & " " & CStr(s) & "-" & CStr(e)
                        temp = temp & vbCrLf & "Content ..." & CStr(contentStart) & "," & CStr(contentEnd) & ";" & CStr(selection.start) & "," & CStr(selection.End)
                        If VerifyInsertInto_FigTable(contentStart, contentEnd) Then
                            temp = temp & vbCrLf & "______" & vbCrLf & "Resto ..." & texto
                            temp = temp & vbCrLf & vbCrLf & "Resto ..." & CStr(pTagClose) & "," & CStr(e) & ";" & CStr(selection.start) & "," & CStr(selection.End)
                        
                            r = VerifyInsertInto_FigTable(pTagClose, e)
                        End If
                    End If
                End If
            ElseIf pStart = 0 Then
                If Not (MarkupRange.existSTAGOAfterTAGC(s, e)) Then
                    r = True
                End If
            End If
        End If
    End If
    
selection.start = SelStart
  selection.End = SelEnd
    VerifyInsertInto_FigTable = r
  Exit Function
errLOG:
MsgBox err.Description
  
End Function

Public Function VerifyHierarchy_FigTable(currentBar As String, tag As String) As Boolean
  Dim iRange As Long, fRange As Long, start As Boolean
  Dim previousText As String, nextText As String
  Dim bar As New clsBar, button As New clsButton
  Dim ok1 As Boolean, ok2 As Boolean
  Const errIDMet As String = "09"
  '-----------------------------
  On Error GoTo errLOG
  
  
  If currentBar = "ifloat" Then
    VerifyHierarchy_FigTable = True
  End If
  
  Set bar = Nothing
  Exit Function
errLOG:
  With mErr
    .LoadErr MarkupRange.conf
    .BuildLog errIDObj & errIDMet, MarkupRange.conf
  End With
  
  '-----------------
  Set bar = Nothing: Set button = Nothing
End Function

Public Function fixFigTable(doc As range) As range
MsgBox "7.1"
    Set doc = fixTag(doc, "tabwrap")
MsgBox "7.2"
    Set doc = fixTag(doc, "figgrp")
MsgBox "7.3"
    Set fixFigTable = doc
End Function
Private Function fixTag(doc As range, ByVal tag As String) As range
    Dim s As Long
    Dim e As Long
    
    Dim SelStart As Long
    Dim SelEnd As Long
    
    Dim openStart As Long
    Dim openEnd As Long
    Dim closeStart As Long
    Dim closeEnd As Long
    
    Dim contentStart As Long
    Dim contentEnd As Long
    
    Dim tagOpen As String
    Dim tagClose As String
    
    Dim find As Boolean
    
    On Error GoTo x
    
    Set MarkupRange.MyRange = doc

    SelStart = doc.start
    SelEnd = doc.End
    

MsgBox "MarkupRange.findText " & CStr(doc.start) & "," & CStr(SelEnd)
    
    MarkupRange.MyRange.End = 1
    MarkupRange.MyRange.start = 1
    
    find = MarkupRange.findText(MarkupRange.conf.STAGO & tag, True, openStart, e)
    While find And (openStart > 0)
MsgBox "openStart " & CStr(openStart)
    
        If MarkupRange.findOpenTag(openStart + 1, SelEnd, contentStart) = tag Then
            openEnd = contentStart - 1
MsgBox "findOpenTag " & ActiveDocument.range(openStart, openEnd).text
            
            If MarkupRange.findCloseTag(contentStart, SelEnd, tag, contentEnd, closeEnd) Then
                closeStart = contentEnd + 1
MsgBox "findCloseTag " & ActiveDocument.range(contentStart, contentEnd).text & " " & ActiveDocument.range(closeStart, closeEnd).text

                If VerifyInsertInto_FigTable(openStart, closeEnd) Then
MsgBox "VerifyInsertInto_FigTable"
                Else
MsgBox "not VerifyInsertInto_FigTable"
                    MarkupRange.MyRange.start = openStart
                    MarkupRange.MyRange.End = openEnd
                    tagOpen = MarkupRange.MyRange.text
                    MarkupRange.MyRange.Delete
                    
                    MarkupRange.MyRange.start = closeStart
                    MarkupRange.MyRange.End = closeEnd
                    tagClose = MarkupRange.MyRange.text
                    MarkupRange.MyRange.Delete
MsgBox tagOpen
MsgBox tagClose

                    openStart = openEnd + 1
                    closeEnd = closeStart - 1
                    While Not VerifyInsertInto_FigTable(openStart, closeEnd) And closeEnd > 0 And openStart > 0
MsgBox "not VerifyInsertInto_FigTable " & ActiveDocument.range(openStart, closeEnd).text
                        closeEnd = MarkupRange.findNextMark(SelEnd, closeEnd + 1)
                        openStart = MarkupRange.findPreviousMark(doc.start, openStart - 1)
                    Wend
                    
                    If closeEnd > 0 And openStart > 0 Then
                        MarkupRange.MyRange.start = openStart
                        MarkupRange.MyRange.InsertBefore (tagOpen)
                        MarkupRange.MyRange.End = closeEnd
                        MarkupRange.MyRange.InsertAfter (tagClose)
                        
MsgBox "r=" & MarkupRange.MyRange.text
                        
                    End If
                    
                End If
            End If
        End If
        MarkupRange.MyRange.start = openStart + 1
        MarkupRange.MyRange.End = openStart + 1
        
MsgBox "FIND " & MarkupRange.conf.STAGO & tag
        find = MarkupRange.findText(MarkupRange.conf.STAGO & tag, True, openStart, e)
    Wend
    Set fixTag = doc
    Exit Function
x:
    MsgBox err.Description
    
End Function





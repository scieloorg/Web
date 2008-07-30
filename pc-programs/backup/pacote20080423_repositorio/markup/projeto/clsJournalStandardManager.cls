VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsJournalStandardManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private col As New collection

Function AutoMarkupIsAvailable() As Boolean
 AutoMarkupIsAvailable = (Dir(MarkupPrg & "journal-standard.txt") = "journal-standard.txt")
End Function

Sub load()
    
    Dim f As Long
    Dim Line As String
    Dim p As Long
    Dim js As ClsJournalStandard
    
    Dim s As String
    
    If AutoMarkupIsAvailable Then
    
    f = FreeFile
    Open MarkupPrg & "journal-standard.txt" For Input As #f
    While Not (EOF(f))
        Line Input #f, Line

        p = InStr(Line, ";")
        If p > 0 Then
            Set js = New ClsJournalStandard
            js.id = Mid(Line, 1, p - 1)
            s = Mid(Line, p + 1)
        
            p = InStr(s, ";")
            js.journalTitle = Mid(s, 1, p - 1)
            
            js.standardName = Mid(s, p + 1)
            
            
        Call col.add(js, js.id)
        End If
    Wend
    
    Close #f
    End If
End Sub

Function getStandard(id As String) As ClsJournalStandard
    On Error GoTo Handle

    Set getStandard = col.Item(id)
    Exit Function
    
Handle:

    Dim p As New ClsJournalStandard
    
    p.standardName = ""
    p.id = id
    p.journalTitle = ""
    Set getStandard = p
End Function


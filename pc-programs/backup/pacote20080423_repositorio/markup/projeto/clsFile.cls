VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsFile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private logFile As String

Function DeleteFile(file As String) As Boolean
    On Error GoTo Handle
    writelogFile ("Apagar " & file)
    Kill file
    writelogFile ("Apagou " & file)
    DeleteFile = True
Exit Function
Handle:
'Resume Next
DeleteFile = False
End Function

Sub writelogFile(msg As String)
    Dim f As Long
    
    f = FreeFile
    Open logFile For Append As #f
    Print #f, Date$ & " " & msg
    Close #f
    
End Sub
Sub createlogFile(filename As String)
    Dim f As Long
    
    logFile = filename
    f = FreeFile
    Open logFile For Output As #f
    Close #f
    
End Sub
Sub writeFile(filename As String, msg As String)
    Dim f As Long
    
    f = FreeFile
    Open filename For Output As #f
    Print #f, msg
    Close #f
    
End Sub
Function readfile(filename As String) As String
    Dim f As Long
    Dim s As String
    Dim Line As String
    
    f = FreeFile
    Open filename For Input As #f
    While Not (EOF(f))
    Line Input #f, Line
    s = s + vbCrLf + Line
    Wend
    Close #f
    readfile = s
End Function
Sub makedir(path As String)
On Error Resume Next
    Call MkDir(path)
End Sub

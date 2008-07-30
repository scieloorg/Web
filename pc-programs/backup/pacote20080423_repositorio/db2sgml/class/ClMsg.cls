VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClMsg"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

Public MsgFile As String
Public MsgDir As String

Private ContentLogFile() As String
Private LogLineCount As Long

Private PathLog As String
Private DBLog As String


Function InitLogDatabase(Path As String, DatabaseName As String) As Boolean
    
    PathLog = Path
    DBLog = DatabaseName
    LogLineCount = 0
    Erase ContentLogFile
    
End Function

Function ViewLogDatabase(DocId As String) As String
    Dim mfn As Long
    Dim ret As String
    Dim database As ClIsisDll
    Dim content() As String
    Dim q As Long
    Dim i As Long
    
    Set database = New ClIsisDll
    If database.Initiate(PathLog, DBLog, "Log Database") Then
        If database.IfCreate(DBLog) Then
            'If database.MfnQuantity > 0 Then Call database.IfUpdate(1, database.MfnQuantity)
            mfn = database.MfnFindOne(DocId)
            If mfn > 0 Then
                q = database.FieldContentGet(mfn, 2, content)
                For i = 1 To q
                    ret = ret + content(i) + Chr(13) + Chr(10)
                Next
            End If
        End If
    End If
    Set database = Nothing
    ViewLogDatabase = ret
End Function

'-----------------------------------------------------------------------
'WriteLogFileLine - escreve os passos do processamento em arquivo
'msg    - a mensagem a ser gravada no arquivo
'-----------------------------------------------------------------------
Private Sub WriteLogFileLine(File As String, ByVal msg As String)
    Dim fnLog As Long
        
    fnLog = FreeFile(1)
    On Error GoTo x:
    Open File For Append As fnLog
    Print #fnLog, msg
    
    LogLineCount = LogLineCount + 1
    ReDim Preserve ContentLogFile(LogLineCount)
    ContentLogFile(LogLineCount) = msg
    Close fnLog
x:
End Sub

'-----------------------------------------------------------------------
'MsgInvalidPath - mensagem de caminho inválido
'Label  - identificação do caminho
'Path    - caminho
'-----------------------------------------------------------------------
Sub MsgInvalidPath(Label As String, Path As String)
    If Len(Label) > 0 Then
        MsgBox (Label + " - Invalid path " + Path)
    Else
        MsgBox ("Invalid path " + Path)
    End If
End Sub

'-----------------------------------------------------------------------
'GiveRunInformation - escreve os passos do processamento em arquivo, em msgbox e no rodapé do form
'Msg - a mensagem a ser gravada no arquivo
'ShowMsgbox - se a mensagem deve ser também mostrada ou não em msgbox
'ShowLabel  - se a mensagem deve ser também mostrada ou não em label
'-----------------------------------------------------------------------
Sub GiveRunInformation(msg As String, Optional ShowMsgbox As Boolean, Optional ShowLabel As Boolean)
    Dim File As String
    
    If Len(MsgFile) > 0 Then
        If Len(MsgDir) > 0 Then
            File = MsgDir + PathSep + MsgFile
        Else
            File = MsgFile
        End If
    Else
        File = "warnings.txt"
    End If
    
    If Len(msg) > 0 Then
        Call WriteLogFileLine(File, CStr(Date) + " " + CStr(Time) + " " + msg)
        If ShowMsgbox Then MsgBox msg
    Else
        Call WriteLogFileLine(File, Chr(32))
    End If
    'If ShowLabel Then ShowMsgInForm (Msg)
End Sub

'-----------------------------------------------------------------------
'ExitProgram  - sai do programa
'-----------------------------------------------------------------------
Function ExitProgram() As Boolean
    ExitProgram = (MsgBox("Exit?", vbOK) = vbOK)
End Function



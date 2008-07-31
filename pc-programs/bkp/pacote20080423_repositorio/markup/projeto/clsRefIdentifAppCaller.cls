VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsRefIdentifAppCaller"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private mErr As New clsErrList
Const errIDObj As String = "520"
Const TIME_LIMIT As Long = 9999
Public debugMode As Boolean

Const REFERENCE_IDENTIFICATION_NO_RESULT_FILE = 1
Const REFERENCE_IDENTIFICATION_ERROR_UNABLE_TO_DELETE_TEMP_FILES = 2
Const REFERENCE_IDENTIFICATION_ERROR_NO_RESULT = 3
Const REFERENCE_IDENTIFICATION_ERROR_TIME_OUT = 5
Const REFERENCE_IDENTIFICATION_ERROR_NO_INPUT_FILE = 6

Public Function request(standard As String, references As String, Optional ByRef error As Long) As String
    Dim id As Double
    Dim FinishFile As String
    Dim ResultFile As String
    Dim ResultFileName As String
    Dim InputFile As String
    Dim FinishFileName As String
    
    Dim command As String
    Dim times As Long
    Dim TMP As String
    
    Dim spy As Long
    Dim r As String
   
    Dim file As New clsFile
    
    Dim Mode As VbAppWinStyle
    
      On Error GoTo ERRLOG

    If debugMode Then
        Mode = vbNormal
    Else
        Mode = vbHide
    End If
    r = references
        
    TMP = Date$
        
    file.createlogFile (MarkupPrg & "temp\log.txt")
   
    file.writelogFile ("Instancia os arquivos")

    InputFile = MarkupPrg & "temp\" & TMP & "references.txt"
    InputFileName = TMP & "references.txt"
    ResultFile = MarkupPrg & "temp\" & TMP & "marcado.xml"
    ResultFileName = TMP & "marcado.xml"
    
    FinishFileName = TMP & "finish.txt"
    FinishFile = MarkupPrg & "temp\" & TMP & "finish.txt"
    'FinishFile = ResultFile
    'FinishFileName = ResultFileName
    
    file.writelogFile ("Cria o arquivo de entrada " & InputFile)
    Call file.writeFile(InputFile, references)
    
    
    If Dir(InputFile) = InputFileName Then
file.writelogFile ("O arquivo de entrada " & InputFile & " foi criado")
        'conseguiu gravar as referencias em arquivo
        If (Dir(FinishFile) = FinishFileName) Then
             'o arquivo que identifica o fim da execucao existe
            ' entao deve-se apaga-lo
            file.DeleteFile FinishFile
        End If
        If (Dir(ResultFile) = ResultFileName) Then
            'o arquivo que identifica o fim da execucao existe
            ' entao deve-se apaga-lo
            file.DeleteFile ResultFile
        End If
        
        If (Dir(FinishFile) = FinishFileName) Or (Dir(ResultFile) = ResultFileName) Then
            'o arquivo que identifica o fim da execucao nao foi apagado
            ' entao erro
file.writelogFile ("Erro: REFERENCE_IDENTIFICATION_ERROR_UNABLE_TO_DELETE_TEMP_FILES")
            error = REFERENCE_IDENTIFICATION_ERROR_UNABLE_TO_DELETE_TEMP_FILES
file.writelogFile ("Erro: " & error)
        Else
            'executar o identificador de referencias
            'teste command = "auto\MarcaAutomaticamente.bat " & InputFile & " " & ResultFile & " " & FinishFile & " temp\teste"
            
            command = MarkupPrg & "refIdentifier\PubMed.bat " & InputFile & " " & ResultFile & " " & FinishFile & " " & MarkupPrg & "refIdentifier " & standard
            
file.writelogFile ("Executará " & command)
            
            id = Shell(command, Mode)
file.writelogFile ("Executou " & command)
            
            'verifica o termino da execucao
            times = 0
            While (Dir(FinishFile) <> FinishFileName) And (times < TIME_LIMIT)
                times = times + 1
file.writelogFile ("time=" & times)
            Wend
file.writelogFile ("Terminou?")
            
            If (Dir(FinishFile) = FinishFileName) Then
                ' terminou a execucao
file.writelogFile ("Terminou.")
                
                If (Dir(MarkupPrg & "temp\teste") = "teste") Then
file.writelogFile ("Apagar teste")
                'MsgBox times
                    ' se eh teste usar como resultado o auto\marcado.xml
                    Call FileCopy(MarkupPrg & "auto\marcado.xml", ResultFile)
                    file.DeleteFile MarkupPrg & "temp\teste"
                End If
                If (Dir(ResultFile) = ResultFileName) Then
                    ' resultado
file.writelogFile ("Ler resultado " & ResultFile)
                    r = file.readfile(ResultFile)
                    
                    If Len(r) = 0 Then
                        error = REFERENCE_IDENTIFICATION_ERROR_NO_RESULT
                        r = references
                    End If
                    'file.DeleteFile ResultFile
                Else
                    ' nao gerou o arquivo com resultado
file.writelogFile ("Erro: REFERENCE_IDENTIFICATION_NO_RESULT_FILE")
                    error = REFERENCE_IDENTIFICATION_NO_RESULT_FILE
file.writelogFile ("Erro: " & error)
                End If
                If ResultFile <> FinishFile Then
                    file.DeleteFile FinishFile
                End If
            Else
                ' time out, nao conseguiu terminar
file.writelogFile ("Erro: REFERENCE_IDENTIFICATION_ERROR_TIME_OUT")
                error = REFERENCE_IDENTIFICATION_ERROR_TIME_OUT
file.writelogFile ("Erro: " & error)
            End If
        End If
        If error = 0 Then
        file.DeleteFile InputFile
        End If
    Else
file.writelogFile ("Erro: REFERENCE_IDENTIFICATION_ERROR_NO_INPUT_FILE")
        error = REFERENCE_IDENTIFICATION_ERROR_NO_INPUT_FILE
file.writelogFile ("Erro: " & error)
    End If
  
    request = r
Exit Function
ERRLOG:
  MsgBox err.Description
  
End Function

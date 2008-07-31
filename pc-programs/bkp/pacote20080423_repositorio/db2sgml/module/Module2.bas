Attribute VB_Name = "General"
Option Explicit

Public Const PathSep = "\"

'----------------------------------------------------------------------
'DelFile    - apaga arquivo(s)
'Path       - caminho do arquivo
'File       - nome do arquivo
'Retorno    - sucesso ou fracasso
'----------------------------------------------------------------------
Function DelFile(Path As String, file As String) As Boolean
    Dim ret As Boolean
    
    If FileExist(Path, file) Then
        'If Path = "" Then
        '    Kill file
        'Else
            Kill Path + PathSep + file
        'End If
        ret = True
    End If
    DelFile = ret

End Function

'----------------------------------------------------------------------
'DirExist  - verifica se um diretório existe
'Path       - nome do diretório
'Label      - identificação do diretório
'Retorno    - verdade ou falso
'----------------------------------------------------------------------
Public Function DirExist(ByVal Path As String, Optional label As String) As Boolean
    Dim x As String
    
    On Error GoTo ERRINHO
    If Len(Path) > 0 Then x = Dir(Path, vbDirectory)
    DirExist = (Len(x) > 0)
    If Not DirExist Then GoTo ERRINHO
Exit Function

ERRINHO:
    If Len(label) > 0 Then
        MsgBox label + " - Invalid path: " + Path
    End If
    DirExist = False
End Function

'----------------------------------------------------------------------
'FileExist  - verifica se um diretório existe
'Path       - nome do diretório
'file       - nome do arquivo
'Label      - identificação do arquivo
'Retorno    - verdadeiro ou falso
'----------------------------------------------------------------------
Function FileExist(Path As String, file As String, Optional label As String) As Boolean
    Dim x As String
    
    On Error GoTo ERRINHO
    If Len(file) > 0 Then
        x = Dir(Path + PathSep + file)
        FileExist = (Len(x) > 0)
    Else
        FileExist = False
    End If
    If Not FileExist Then GoTo ERRINHO
Exit Function
ERRINHO:
    If Len(label) > 0 Then
        MsgBox label + " - Invalid file: " + Path + PathSep + file
    End If
    FileExist = False
End Function

'----------------------------------------------------------------------
'ExisteVisibleChars - verifica se existem caracteres visíveis em uma
'                   string
's                  - string
'Retorno            - verdadeiro ou falso
'----------------------------------------------------------------------
Function ExisteVisibleChars(ByVal s As String) As Boolean
    Dim ret As Boolean
    Dim aux As String
    Dim p As Long
    
    If Len(s) = 0 Then
        ret = False
    ElseIf s Like "*[a-zA-Z0-9]*" Then
        ret = True
    Else
        aux = Trim(s)
        If Len(aux) > 0 Then
            p = InStr(aux, Chr(13))
            While p > 0
                aux = Mid(aux, 1, p - 1) + Mid(aux, p + 1)
                p = InStr(aux, Chr(13))
            Wend
        End If
        aux = Trim(aux)
        If Len(aux) > 0 Then
            p = InStr(aux, Chr(10))
            While p > 0
                aux = Mid(aux, 1, p - 1) + Mid(aux, p + 1)
                p = InStr(aux, Chr(10))
            Wend
        End If
        aux = Trim(aux)
        ret = (Len(aux) > 0)
    End If
    ExisteVisibleChars = ret
End Function

'----------------------------------------------------------------------
'FormatDigits   - completa com zeros à esquerda de um número para que
'               este fique com uma determinada quantidade de dígitos
'Number         - número
'DigitsNumber   - número de dígitos
'Retorno        - número formatado
'----------------------------------------------------------------------
Function FormatDigits(ByVal number As String, DigitsNumber As Long) As String
    
    If IsNumber(number) Then number = String(DigitsNumber - Len(number), "0")
    FormatDigits = number
End Function

'----------------------------------------------------------------------
'RmNewLineInStr - remove <new line> de uma string
's              - string
'Retorno        - string sem <new line>
'----------------------------------------------------------------------
Function RmNewLineInStr(ByVal s As String) As String
    Dim p As Long
    
    p = InStr(s, Chr(13) + Chr(10))
    While p > 0
        s = Mid(s, 1, p - 1) + " " + Mid(s, p + 2)
        p = InStr(s, Chr(13) + Chr(10))
    Wend
    
    p = InStr(s, Chr(13))
    While p > 0
        s = Mid(s, 1, p - 1) + " " + Mid(s, p + 1)
        p = InStr(s, Chr(13))
    Wend
    
    p = InStr(s, Chr(10))
    While p > 0
        s = Mid(s, 1, p - 1) + " " + Mid(s, p + 1)
        p = InStr(s, Chr(10))
    Wend

    p = InStr(s, Chr(9))
    While p > 0
        s = Mid(s, 1, p - 1) + " " + Mid(s, p + 1)
        p = InStr(s, Chr(9))
    Wend

    RmNewLineInStr = s
End Function

'----------------------------------------------------------------------
'ReplaceString   - substitui uma substring por espaço em uma string
's          - string
'ToBeRemoved    - substring
'Retorno    - string sem a substring
'----------------------------------------------------------------------
Function ReplaceString(s As String, ToBeRemoved As String, Optional Replace As String) As String
    Dim p As Long
    
    p = InStr(s, ToBeRemoved)
    While p > 0
        s = Mid(s, 1, p - 1) + Replace + Mid(s, p + Len(ToBeRemoved))
        p = InStr(s, ToBeRemoved)
    Wend
    
    ReplaceString = s
End Function

'----------------------------------------------------------------------
'GetElemStr - obtém elementos de uma string sendo que eles estão
'           separados por algum separador e agrupados por aspas duplas
's          - string
'sep        - separador de um caracter apenas
'Elem       - os elementos obtidos
'Retorno    - a quantidade de elementos obtidos
'----------------------------------------------------------------------
Function GetElemStr(s As String, sep As String, Elem() As String) As Long
    Dim pos_aspas As Long
    Dim q_aspas As Long
    Dim linhaaux As String
    Dim pos_virg As Long
    Dim virgs() As Long
    Dim qvirg As Long
    Dim fecha As Boolean
    Dim i As Long
    
    fecha = True
    Erase Elem
    pos_aspas = InStr(s, Chr(34))
    While pos_aspas > 0
        q_aspas = q_aspas + 1
        If (q_aspas Mod 2) = 0 Then
            If pos_aspas = Len(s) Then
                fecha = True
                pos_virg = pos_aspas
            ElseIf StrComp(Mid(s, pos_aspas + 1, 1), ",") = 0 Then
                fecha = True
                pos_virg = pos_aspas
            End If
        Else
            If (pos_aspas = 1) Then
                fecha = False
                linhaaux = Mid(s, 1, pos_aspas)
                pos_virg = InStr(pos_virg + 1, linhaaux, sep, vbBinaryCompare)
                While (pos_virg > 0)
                    qvirg = qvirg + 1
                    ReDim Preserve virgs(qvirg)
                    virgs(qvirg) = pos_virg
                    pos_virg = InStr(pos_virg + 1, linhaaux, sep, vbBinaryCompare)
                Wend
            ElseIf (StrComp(Mid(s, pos_aspas - 1, 1), ",") = 0) Then
                fecha = False
                linhaaux = Mid(s, 1, pos_aspas)
                pos_virg = InStr(pos_virg + 1, linhaaux, sep, vbBinaryCompare)
                While (pos_virg > 0)
                    qvirg = qvirg + 1
                    ReDim Preserve virgs(qvirg)
                    virgs(qvirg) = pos_virg
                    pos_virg = InStr(pos_virg + 1, linhaaux, sep, vbBinaryCompare)
                Wend
            End If
        End If
        pos_aspas = InStr(pos_aspas + 1, s, Chr(34), vbBinaryCompare)
    Wend
    If fecha Then
        pos_virg = InStr(pos_virg + 1, s, sep, vbBinaryCompare)
        While (pos_virg > 0)
            qvirg = qvirg + 1
            ReDim Preserve virgs(qvirg)
            virgs(qvirg) = pos_virg
            pos_virg = InStr(pos_virg + 1, s, sep, vbBinaryCompare)
        Wend
    Else
        qvirg = -1
    End If
    pos_virg = 0
    For i = 1 To qvirg
        ReDim Preserve Elem(i)
        Elem(i) = Mid(s, pos_virg + 1, virgs(i) - pos_virg - 1)
        If InStr(Elem(i), Chr(34)) = 1 Then
            Elem(i) = Mid(Elem(i), 2, Len(Elem(i)) - 2)
        End If
        pos_virg = virgs(i)
    Next
    If qvirg >= 0 Then
        i = qvirg + 1
        ReDim Preserve Elem(i)
        Elem(i) = Mid(s, pos_virg + 1)
        If InStr(Elem(i), Chr(34)) = 1 Then
            Elem(i) = Mid(Elem(i), 2, Len(Elem(i)) - 2)
        End If
    End If
    GetElemStr = qvirg + 1
End Function


Function SetElemStr(ByVal s As String, sep As String, Elem As String) As String
    If Len(s) > 0 Then
        s = s + sep + PutAspas(Elem, sep)
    Else
        s = PutAspas(Elem, sep)
    End If
    SetElemStr = s
End Function

Function SetElemArray(ByVal s As String, sep As String, Elem() As String, Count As Long) As String
    Dim i As Long
    
    For i = 2 To Count
        s = s + sep + PutAspas(Elem(i), sep)
    Next
    If Count > 0 Then s = PutAspas(Elem(1), sep) + s
    SetElemArray = s
End Function

'----------------------------------------------------------------------
'PutAspas   - delimita com aspas duplas uma string que contenha vírgula
's          - string
'Retorno    - a nova string
'----------------------------------------------------------------------
Function PutAspas(s As String, sep As String) As String
    If InStr(s, sep) > 0 Then s = Chr(34) + s + Chr(34)
    PutAspas = s
End Function

'----------------------------------------------------------------------
'GetDateISO - transforma uma data para data ISO
'Data       - y data
'Retorno    - y nova data
'----------------------------------------------------------------------
Function GetDateISO(data As Date) As String

    Dim Y As String
    Dim m As String
    Dim d As String
    
    Y = Year(data)
    m = Month(data)
    d = Day(data)
    If Len(m) = 1 Then m = "0" + m
    If Len(d) = 1 Then d = "0" + d
    
    GetDateISO = Y + m + d
End Function

'----------------------------------------------------------------------
'IsNumber   - verifica se uma string corresponde a um número
'Number     - string
'Retorno    - verdadeiro ou falso
'----------------------------------------------------------------------
Function IsNumber(number As String) As Boolean
    Dim pattern As String
    
    If Len(number) > 0 Then
        pattern = String(Len(number), "#")
        If number Like pattern Then IsNumber = True
    End If
End Function

Sub SeparateFileandPath(FullFilePath As String, Path As String, file As String)
    Dim FullPath As String
    Dim p As Long
    
    p = InStr(FullFilePath, "\")
    FullPath = FullFilePath
    Path = ""
    file = ""
    While p > 0
        Path = Path + Mid(FullPath, 1, p)
        FullPath = Mid(FullPath, p + 1)
        p = InStr(FullPath, "\")
    Wend
    
    Path = Mid(Path, 1, Len(Path) - 1)
    file = FullPath
    
End Sub


Attribute VB_Name = "ModGlobal"
Option Explicit

Type TpPosicao
    i As Long
    j As Long
End Type

Public Const TpLiterat = "S"
Public Const NORMA_OTH = 2
Public Const NORMA_VAN = 4
Public Const NORMA_ISO = 8
Public Const NORMA_ABNT = 16

'Identificadores dos arquivos
Public Const fnTabTags = 256
Public Const fnTabDTD = 257
Public Const fnArtigo = 258
Public Const fnArtigoSemTags = 259
Public Const fnLog = 260
Public Const fnHTML2ASC = 261
Public Const fnDebug = 262
Public Const fnFST = 263
Public Const fnListaTags = 264

Public Norma As Integer
Public debugando As Boolean
'Uso de isisdll
Public A   As Long
Public H   As Long
Public Const delim1 = "<"
Public Const delim2 = ">"

'Sempre Globais
Public SepLinha As String

Public Titulos As New ClTitle
Public TabTag  As New ClTabTags
Public msg As New ClMsg

Public parser   As New ClParser
Public art      As New ClArtigo
Public Registros() As String
Public TextoArtigo    As New ClTxt
'Public TxtSemTags     As New ClTxt

'Variaveis de configuracao
Public SiglaVol As String
Public SiglaNro As String

'Paths
Public PathTitles As String
Public PathTabelas As String
Public PathBody As String
Public PathMarkup As String
Public PathBase As String

'Nome de arquivos de Entrada
Public ArqHTML2ASC As String
Public ArqDTD As String
Public ArqDTD2ISIS As String
Public ArqTitles As String
Public ArqFBPE As String
Public ArqArtigo As String

'Nome de arquivos de Saida
Public ArqLog As String
Public ArqBase As String

'Nome de arquivos auxiliares
Public TabAuxDTD2ISIS As String
Public ArqTMP As String
Public ArqSemTags As String

'drive de trabalho
Public DrvTrab As String

'Diretorios
Public DirPeriodicos As String
Public DirTrab As String

Public DirBase As String
Public DirBody As String
Public DirMarkup As String

Public DirTitles As String
Public DirTabelas As String

Private ChrHtml() As String
Private ChrAsc() As Long
Private QtdChr As Long
Function AcentHtml(s As String) As String
    Dim aux As String
    Dim p1 As Long
    Dim p2 As Long
    Dim codigo As String
    Dim aux2 As String
    Dim i As Long
'    msg.RelataLog ("acenthtml")
    aux2 = s
    While aux2 <> ""
        p1 = InStr(aux2, "&")
        p2 = InStr(aux2, ";")
        If (p1 = 0) Or (p2 = 0) Then
            aux = aux + aux2
            aux2 = ""
        ElseIf p1 < p2 Then
            codigo = Mid(aux2, p1 + 1, p2 - p1 - 1)
            i = 1
            While (StrComp(codigo, ChrHtml(i)) <> 0) And (i < QtdChr)
                i = i + 1
            Wend
            If StrComp(codigo, ChrHtml(i)) = 0 Then
                aux = aux + Mid(aux2, 1, p1 - 1) + Chr(ChrAsc(i))
                aux2 = Mid(aux2, p2 + 1)
            Else
                aux = aux + Mid(aux2, 1, p1)
                aux2 = Mid(aux2, p1 + 1)
            End If
        ElseIf p1 > p2 Then
            aux = aux + Mid(aux2, 1, p2)
            aux2 = Mid(aux2, p2 + 1)
        End If
    Wend
    AcentHtml = aux
End Function

Public Function ExisteDir(ByVal path As String) As Boolean
    Dim FoundPath As String
    Dim p As Long
    Dim retorno As Boolean
    Dim DirForFinding As String
    Dim aux As String
    
    retorno = True
    If path Like "[a-z]:*" Then
        p = InStr(path, "\")
        If p = 0 Then
            'existe apenas o driver especificado
            retorno = (dir(path) <> "")
        Else
            FoundPath = Mid(path, 1, p)
            path = Mid(path, p + 1)
            Do
                p = InStr(path, "\")
                If p = 0 Then
                    'existe apenas o driver especificado ou apenas um diretorio
                    DirForFinding = Mid(path, 1)
                    path = ""
                Else
                    DirForFinding = Mid(path, 1, p)
                    path = Mid(path, p + 1)
                End If
                aux = dir(FoundPath + DirForFinding, vbDirectory)
                If aux <> "" Then
                    FoundPath = FoundPath + DirForFinding
                Else
                    retorno = False
                End If
            Loop Until (path = "") Or (Not retorno)
        End If
    Else
        retorno = False
    End If
    ExisteDir = retorno
End Function
Public Function ExisteDir2(ByVal path As String) As Boolean
    Dim p As Long
    Dim retorno As Boolean
    Dim DirForFinding As String
    Dim FoundPath As String
    Dim aux As String
    
    retorno = True
    If ExisteString(path) Then
        p = InStr(path, "\")
        If p = 0 Then
            'existe apenas o driver especificado
        Else
            FoundPath = Mid(path, 1, p)
            path = Mid(path, p + 1)
            Do
                p = InStr(path, "\")
                If p = 0 Then
                    'existe apenas o driver especificado ou apenas um diretorio
                    DirForFinding = Mid(path, 1)
                    path = ""
                Else
                    DirForFinding = Mid(path, 1, p - 1)
                    path = Mid(path, p + 1)
                End If
                
                aux = dir(FoundPath, vbDirectory)
                If debugando Then MsgBox (FoundPath + "," + aux + "=" + DirForFinding)
                While (aux <> "") And (StrComp(aux, DirForFinding, 1) <> 0)
                    aux = dir
                If debugando Then MsgBox (FoundPath + "," + aux + "=" + DirForFinding + Chr(13) + Chr(10) + FoundPath + DirForFinding + "\")
                Wend
                If StrComp(aux, DirForFinding, 1) = 0 Then
                    FoundPath = FoundPath + DirForFinding + "\"
                Else
                    retorno = False
                End If
            Loop Until (path = "") Or (Not retorno)
        End If
    Else
        retorno = False
    End If
    ExisteDir2 = retorno
End Function

Function ExisteFile(path As String, file As String) As Boolean
    Dim aux As String
    
    If ExisteDir(path) Then
        aux = dir(path + "\" + file)
        If StrComp(file, aux, 1) = 0 Then
            ExisteFile = True
        Else
            ExisteFile = False
        End If
    Else
        msg.NaoExisteCaminho (path)
        ExisteFile = False
    End If
End Function

Function ExisteString(ByVal s As String) As Boolean
    Dim ret As Boolean
    Dim aux As String
    Dim p As Long
    
    If s = "" Then
        ret = False
    ElseIf s Like "*[a-zA-Z0-9]*" Then
        ret = True
    Else
        aux = Trim(s)
        If aux <> "" Then
            p = InStr(aux, Chr(13))
            While p > 0
                aux = Mid(aux, 1, p - 1) + Mid(aux, p + 1)
                p = InStr(aux, Chr(13))
            Wend
        End If
        aux = Trim(aux)
        If aux <> "" Then
            p = InStr(aux, Chr(10))
            While p > 0
                aux = Mid(aux, 1, p - 1) + Mid(aux, p + 1)
                p = InStr(aux, Chr(10))
            Wend
        End If
        aux = Trim(aux)
        ret = (aux <> "")
    End If
    ExisteString = ret
End Function

Function gFullpathArq() As String
    gFullpathArq = PathMarkup + "\" + ArqArtigo
End Function

Function gFullpathBD() As String
    gFullpathBD = PathBase + "\" + ArqBase
End Function

Public Function Executar() As Boolean
    Set art = Nothing
    Set parser = Nothing
    Set TextoArtigo = Nothing
    
    msg.RelataLog ("Inicio")
    parser.Leitora
    msg.RelataLog ("Fim")
End Function

Function ConteudoComTag(ByVal conteudo As String, ByVal tag As Long) As String
    Dim ComTag As String
    Dim aux As String
    If tag = 0 Then
        Debug.Print conteudo
    ElseIf conteudo = "" Then
        Debug.Print "conteudo vazio"
    Else
        ComTag = delim1 + CStr(tag) + delim2 + conteudo + delim1 + "/" + CStr(tag) + delim2 + SepLinha
    End If
    ConteudoComTag = ComTag
End Function

Sub GeraDTD2ISIS()
    Dim tabela As New ClTabDTD
    
    If tabela.LerTabDTD Then
        tabela.GeraTabTags
    Else
        msg.FaltaArqDTD
    End If
End Sub

Sub InformaPassos(mens As String)
    FormAbrir.LabMsg.Caption = mens
    FormAbrir.LabMsg.Refresh
End Sub

Public Sub InicializaPrograma()
    
    SepLinha = Chr(13) + Chr(10)
    
    'Le o arquivo .INI
    SiglaVol = "v"
    SiglaNro = "n"
    DrvTrab = "c:"
    DirTrab = "fbpe\period~1"
    DirPeriodicos = DrvTrab + "\" + DirTrab
    
    DirTitles = "title"
    PathTitles = DirPeriodicos + "\" + DirTitles
    
    DirTabelas = "Tabelas"
    PathTabelas = DirPeriodicos + "\" + DirTabelas
    
    ArqHTML2ASC = "Acenthtml"
    
    DirBody = "Body"
    DirMarkup = "markup"
    DirBase = "base"
    
    ArqTitles = "title"
    ArqFBPE = "fbpe"
    ArqDTD = "dtd"
    ArqDTD2ISIS = "dtd_isis"
    
    'arquivos ocultos
    TabAuxDTD2ISIS = "tabtags"
    ArqTMP = "arqtmp"
    ArqSemTags = "arqsemtags"
    If VerPaths Then
        If LeChrHtml Then
            If TabTag.Inicializa Then
                Titulos.ObterPeriodicos
                Titulos.ObterSiglas
            End If
        End If
    Else
        msg.Fim
        Unload FormMenuPrin
    End If
End Sub

Function LeChrHtml()
    Dim aux As String
    
    If ExisteFile(PathTabelas, ArqHTML2ASC) Then
        Open PathTabelas + "\" + ArqHTML2ASC For Input As fnHTML2ASC
        Do While Not EOF(fnHTML2ASC) ' Loop until end of file.
            QtdChr = QtdChr + 1
            ReDim Preserve ChrHtml(QtdChr)
            ReDim Preserve ChrAsc(QtdChr)
            Input #fnHTML2ASC, ChrHtml(QtdChr), ChrAsc(QtdChr)
        Loop
        Close fnHTML2ASC
        LeChrHtml = True
    Else
        LeChrHtml = False
    End If
End Function

Sub MostraProcessamento(p As Long)
'    Dim aux As Long
    
'    FormAbrir.PanProcess.Visible = True
'    aux = CInt(P * 100)
'    FormAbrir.PanProcess.Caption = CStr(aux)
'    FormAbrir.PanProcess.FloodPercent = aux
'    FormAbrir.PanProcess.Refresh
End Sub

Function RmHtml(s As String) As String
    Dim aux As String
    Dim p1 As Long
    Dim p2 As Long
    Dim Fim As Boolean
'    msg.RelataLog ("rmhtml")
    aux = s
    While Not Fim
        Fim = True
        p1 = InStr(aux, "<")
        If p1 > 0 Then
            p2 = InStr(aux, ">")
            If p2 > 0 Then
                If p1 < p2 Then
                    aux = Mid(aux, 1, p1 - 1) + Mid(aux, p2 + 1)
                    Fim = False
                End If
            End If
        End If
    Wend
    RmHtml = AcentHtml(Trim(aux))
    'RmHtml = Trim(aux)
End Function
Public Function VerPaths() As Boolean
    Dim aux As Boolean
    aux = True
    If DrvTrab Like "[cz]:" Then
        If Not ExisteDir(DirPeriodicos) Then
            msg.NaoExisteCaminho (DirPeriodicos)
            aux = False
        Else
            If Not ExisteDir(PathTitles) Then
                msg.NaoExisteCaminho (PathTitles)
                aux = False
            Else
                If Not ExisteFile(PathTitles, ArqTitles + ".mst") Then
                    msg.FaltaArqTitles
                    aux = False
                End If
                If Not ExisteFile(PathTitles, ArqFBPE + ".ifp") Then
                    msg.FaltaArqFBPE
                    aux = False
                End If
            End If
            If Not ExisteDir(PathTabelas) Then
                msg.NaoExisteCaminho (PathTabelas)
                aux = False
            End If
        End If
    Else
        MsgBox ("Drive inválido")
        aux = False
    End If
    VerPaths = aux
End Function


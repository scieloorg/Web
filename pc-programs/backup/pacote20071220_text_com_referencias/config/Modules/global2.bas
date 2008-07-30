Attribute VB_Name = "ModGlobal2"
Option Explicit

Public SepLinha As String

Public Const delim1 = "<"
Public Const delim2 = ">"

Public msg As New ClMsg

Public fnLog As Long
Public FNDEBUG As Long
Public fnStatus As Long
Public fnIdiomas As Long
Public fnArqMeses As Long
Public fnFST As Long

Public mfn As Long

Public StatusCod() As String
Public StatusTxt() As String
Public QtdStatus As Long

Public IdiomasCod() As String
Public IdiomasTxt() As String
Public IdiomasHeader() As String
Public QtdIdiomas As Long

Public Periodico As New ClPeriodico
Public Titulos As New ClTitle
Public BD As ClIsisDll
Public BDIssues As ClIsisDll
Public BDSecoes As ClIsisDll
Public A As Long

Public SiglaVol As String
Public SiglaNro As String
Public SiglaPeriodico As String

Public PathTitles As String
Public PathTabelas As String
Public PathBody As String
Public PathSecoes As String
Public PathBase As String
Public PathIssue As String

'Nome de arquivos de Entrada
Public ArqSecoes As String
Public ArqTitles As String
Public ArqInvTitles As String
Public ArqIdiomas As String
Public ArqStatus As String
Public ArqMeses As String
Public ArqIssue As String

'Nome de arquivos de Saida
Public ArqLog As String
Public PodeExecutar As Boolean
Public ArqBase As String

'drive de trabalho
Public DrvTrab As String

'Diretorios
Public DirPeriodicos As String
Public DirTrab As String

Public DirBase As String
Public DirBody As String
Public DirSecoes As String

Public DirTitles As String
Public DirTabelas As String


Public configvars As Collection

Public Function ExisteDir(ByVal Path As String) As Boolean
    Dim x As String
    
    On Error GoTo ERRINHO
    x = Dir(Path, vbDirectory)
    ExisteDir = (StrComp(x, "") <> 0)
Exit Function
ERRINHO:
    ExisteDir = False
End Function
Function ExisteFile(Path As String, file As String) As Boolean
    Dim x As String
    
    On Error GoTo ERRINHO
    If file = "" Then
        ExisteFile = False
    Else
        x = Dir(Path + "\" + file)
        ExisteFile = (StrComp(x, "") <> 0)
    End If
Exit Function
ERRINHO:
    ExisteFile = False
End Function

Function ExisteString(ByVal s As String) As Boolean
    Dim ret As Boolean
    Dim aux As String
    Dim P As Long
    
    If s = "" Then
        ret = False
    ElseIf s Like "*[a-zA-Z0-9]*" Then
        ret = True
    Else
        aux = Trim(s)
        If aux <> "" Then
            P = InStr(aux, Chr(13))
            While P > 0
                aux = Mid(aux, 1, P - 1) + Mid(aux, P + 1)
                P = InStr(aux, Chr(13))
            Wend
        End If
        aux = Trim(aux)
        If aux <> "" Then
            P = InStr(aux, Chr(10))
            While P > 0
                aux = Mid(aux, 1, P - 1) + Mid(aux, P + 1)
                P = InStr(aux, Chr(10))
            Wend
        End If
        aux = Trim(aux)
        ret = (aux <> "")
    End If
    ExisteString = ret
End Function

Public Function VerPaths() As Boolean
    'Verifica a existência dos caminhos
    'drive e diretório de trabalho (diretório de periódicos)
    'diretório e arquivos de Title
    'diretório e arquivos de de Tabelas
    
    Dim aux As Boolean
    
    aux = True

    If Not ExisteDir(DirPeriodicos) Then
        msg.NaoExisteCaminho (DirPeriodicos)
        aux = False
    Else
        If Not ExisteDir(PathTitles) Then
            msg.NaoExisteCaminho (PathTitles)
            aux = False
        Else
            If Not ExisteFile(PathTitles, ArqTitles + ".mst") Then
                msg.NaoExisteCaminho (PathTitles + "\" + ArqTitles + ".mst")
                aux = False
            End If
            If Not ExisteFile(PathTitles, ArqInvTitles + ".ifp") Then
                msg.NaoExisteCaminho (PathTitles + "\" + ArqInvTitles + ".ifp")
                aux = False
            End If
        End If
        If Not ExisteDir(PathTabelas) Then
            msg.NaoExisteCaminho (PathTabelas)
            aux = False
        Else
            If Not ExisteFile(PathTabelas, ArqIdiomas) Then
                msg.NaoExisteCaminho (PathTabelas + "\" + ArqIdiomas)
                aux = False
            End If
            If Not ExisteFile(PathTabelas, ArqStatus) Then
                msg.NaoExisteCaminho (PathTabelas + "\" + ArqStatus)
                aux = False
            End If
            If Not ExisteFile(PathTabelas, ArqMeses) Then
                msg.NaoExisteCaminho (PathTabelas + "\" + ArqMeses)
                aux = False
            End If
        End If
    End If
    If aux Then aux = CarregaArqs
    VerPaths = aux
End Function
Function CarregaArqs() As Boolean
    Dim ret As Boolean
    
    Set Titulos = New ClTitle
    If Titulos.Inicializa(PathTitles, ArqTitles, ArqInvTitles) Then
        Set BDSecoes = New ClIsisDll
        If BDSecoes.Inicializa(PathSecoes, ArqSecoes) Then
            If BDSecoes.CriaIf(ArqSecoes) Then
                If LeTabMeses(PathTabelas, ArqMeses) Then
                    If LeStatus(PathTabelas, ArqStatus) Then
                        If LeIdiomas(PathTabelas, ArqIdiomas) Then
                            ret = True
                        End If
                    End If
                End If
            End If
        End If
    End If
    PodeExecutar = ret
    CarregaArqs = ret
End Function
Function ConteudoComTag(ByVal conteudo As String, ByVal Tag As Long) As String
    Dim ComTag As String
    Dim aux As String
    Dim P As Long
    
    If Tag = 0 Then
        MsgBox "ConteudoComTag: tag=0. Conteudo=" + conteudo
    ElseIf conteudo = "" Then
        'MsgBox "ConteudoComTag: Conteudo=" + conteudo
    Else
        P = InStr(conteudo, Chr(13) + Chr(10))
        While P > 0
            conteudo = Mid(conteudo, 1, P - 1) + " " + Mid(conteudo, P + 2)
            P = InStr(conteudo, Chr(13) + Chr(10))
        Wend
        ComTag = delim1 + CStr(Tag) + delim2 + conteudo + delim1 + "/" + CStr(Tag) + delim2 + SepLinha
    End If
    ConteudoComTag = ComTag
End Function

Public Sub EscrDebug(ByVal msg As String)
'    msg = ArqArtigo + " " + msg
    Open DirPeriodicos + "\DEBUG" For Append As FNDEBUG
    Print #FNDEBUG, msg
    Debug.Print msg
    Close FNDEBUG
End Sub

Function LeStatus(Path As String, arq As String) As Boolean
    Dim opcao, codigo
    Dim ret As Boolean
    
    QtdStatus = 0
    If ExisteFile(Path, arq) Then
        Open Path + "\" + arq For Input As fnStatus
        While Not EOF(fnStatus)
            Input #fnStatus, codigo, opcao
            QtdStatus = QtdStatus + 1
            ReDim Preserve StatusCod(QtdStatus)
            ReDim Preserve StatusTxt(QtdStatus)
            StatusCod(QtdStatus) = codigo
            StatusTxt(QtdStatus) = opcao
        Wend
        Close
        ret = True
    Else
        msg.NaoExisteCaminho (Path + "\" + arq)
    End If
    LeStatus = ret
End Function
    

Function LeIdiomas(Path As String, arq As String) As Boolean
    Dim opcao
    Dim codigo
    Dim header
    Dim aux As New ClIdiomIss
    Dim ret As Boolean
    
    QtdIdiomas = 0
    
    If ExisteFile(Path, arq) Then
        Open Path + "\" + arq For Input As fnIdiomas
        While Not EOF(fnIdiomas)
            Input #fnIdiomas, codigo, opcao, header
    
            QtdIdiomas = QtdIdiomas + 1
            ReDim Preserve IdiomasTxt(QtdIdiomas)
            ReDim Preserve IdiomasCod(QtdIdiomas)
            ReDim Preserve IdiomasHeader(QtdIdiomas)
            IdiomasTxt(QtdIdiomas) = opcao
            IdiomasCod(QtdIdiomas) = codigo
            IdiomasHeader(QtdIdiomas) = header
            Set aux = Periodico.IssIdioma.Add(CStr(codigo))
            aux.Chave = codigo
            aux.Idioma = opcao
            aux.Legenda.IdiomaCod = codigo
            aux.Sumario.IdiomaCod = codigo

            aux.Indice = Periodico.IssIdioma.Count
        Wend
        
        Close
        ret = True
    Else
        msg.NaoExisteCaminho (Path + "\" + arq)
    End If
    
    LeIdiomas = ret
End Function

Function VerifDataIso(dateiso As String, dia1 As String, mes1 As String, ano1 As String) As Boolean
    Dim ret As Boolean
    Dim data As Date
    Dim dia2 As String
    Dim mes2 As String
    Dim ano2 As String
    
    If Len(dateiso) <> 8 Then
        MsgBox ("Data fora do formato ISO.")
        dia1 = "0"
        mes1 = "0"
        ano1 = "0"
    Else
        dia1 = Mid(dateiso, 7, 2)
        mes1 = Mid(dateiso, 5, 2)
        ano1 = Mid(dateiso, 1, 4)
        data = CDate(DateSerial(CInt(ano1), CInt(mes1), CInt(dia1)))
        dia2 = CStr(Day(data))
        If Len(dia2) = 1 Then dia2 = "0" + dia2
        mes2 = CStr(Month(data))
        If Len(mes2) = 1 Then mes2 = "0" + mes2
        ano2 = CStr(Year(data))
        If dia1 = "00" Or mes1 = "00" Then
            ret = True
        ElseIf (dia1 <> dia2) Or (mes1 <> mes2) Or (ano1 <> ano2) Then
            MsgBox ("A data (dia/mes/ano): " + dia1 + "/" + mes1 + "/" + ano1 + " não existe.")
        ElseIf CLng(Date) < CLng(data) Then
            MsgBox ("A data pode estar errada.")
            ret = True
        Else
            ret = True
        End If
    End If
    VerifDataIso = ret
End Function
Function FormataDigitos(Nro As String, QtdDigitos As Long) As String
    Dim aux As String
    Dim i As Long
    
    aux = Nro
    For i = 1 To (QtdDigitos - Len(Nro))
        aux = "0" + aux
    Next
    FormataDigitos = aux
End Function



Function InicializaPrograma() As Boolean
    'Le o arquivo .INI
    SepLinha = Chr(13) + Chr(10)
    
    RecuperaConfiguracao
    
    Open DirPeriodicos + "\DEBUG" For Output As FNDEBUG
    Close FNDEBUG
    
    InicializaPrograma = VerPaths
    
End Function
Sub SalvaConfiguracao()
    Dim Var As ClVarConfig
    Dim fn As Long
    Dim i As Long
    
    fn = 100
    
    SepLinha = Chr(13) + Chr(10)
    
    Open "issue.ini" For Output As fn
    For i = 1 To configvars.Count
        Set Var = New ClVarConfig
        Set Var = configvars.item(i)
        Select Case Var.Nome
            Case "SiglaVol="
                Var.Valor = SiglaVol
            Case "SiglaNro="
                Var.Valor = SiglaNro
            Case "DrvTrab="
                Var.Valor = DrvTrab
            Case "DirTrab="
                Var.Valor = DirTrab
            Case "DirTitles="
                Var.Valor = DirTitles
                
            Case "DirTabelas="
                Var.Valor = DirTabelas
            Case "DirSecoes="
                Var.Valor = DirSecoes
            Case "DirBase="
                Var.Valor = DirBase
            Case "ArqIdiomas="
                Var.Valor = ArqIdiomas
            Case "ArqMeses="
                Var.Valor = ArqMeses
            Case "ArqStatus="
                Var.Valor = ArqStatus
            Case "ArqSecoes="
                Var.Valor = ArqSecoes
    
            Case "ArqTitles="
                Var.Valor = ArqTitles
            Case "ArqInvTitles="
                Var.Valor = ArqInvTitles
            Case "ArqIssues="
                Var.Valor = ArqIssue
            Case Else
                MsgBox Var.Nome + " - variável desconhecida."
        End Select
        Print #fn, Var.Nome + Var.Valor
    Next
    Close
End Sub
Sub RecuperaConfiguracao()
    Dim Var As ClVarConfig
    Dim fn As Long
    Dim Linha As String
    Dim P As Long
    Dim i As Long
    Dim Valor
    
    fn = 100
    
    SepLinha = Chr(13) + Chr(10)
    
    Set configvars = New Collection
    
    Open "issue.ini" For Input As fn
    While Not EOF(fn)
        Line Input #fn, Linha
        
        P = InStr(Linha, "=")
        Set Var = New ClVarConfig
        Var.Nome = Mid(Linha, 1, P)
        Var.Valor = Mid(Linha, P + 1)
        Call configvars.Add(Var, Var.Nome)
        
        Select Case Var.Nome
            Case "SiglaVol="
                SiglaVol = Var.Valor
            Case "SiglaNro="
                SiglaNro = Var.Valor
            Case "DrvTrab="
                DrvTrab = Var.Valor
            Case "DirTrab="
                DirTrab = Var.Valor
            Case "DirPeriodicos="
                DirPeriodicos = Var.Valor
            Case "DirTitles="
                DirTitles = Var.Valor
                
            Case "DirTabelas="
                DirTabelas = Var.Valor
            Case "DirSecoes="
                DirSecoes = Var.Valor
            Case "DirBase="
                DirBase = Var.Valor
            Case "ArqIdiomas="
                ArqIdiomas = Var.Valor
            Case "ArqMeses="
                ArqMeses = Var.Valor
            Case "ArqStatus="
                ArqStatus = Var.Valor
            Case "ArqSecoes="
                ArqSecoes = Var.Valor
    
            Case "ArqTitles="
                ArqTitles = Var.Valor
            Case "ArqInvTitles="
                ArqInvTitles = Var.Valor
            Case "ArqIssues="
                ArqIssue = Var.Valor
            Case Else
                MsgBox Var.Nome + " - variável desconhecida."
   
        End Select
   Wend
        DirPeriodicos = DrvTrab + "\" + DirTrab
        PathTitles = DirPeriodicos + "\" + DirTitles
        PathTabelas = DirPeriodicos + "\" + DirTabelas
        PathSecoes = DirPeriodicos + "\" + DirSecoes
   Close
End Sub

Function InicializaBase() As Boolean
    Dim ret As Boolean
    
    Set BD = New ClIsisDll
    If BD.Inicializa(PathBase, ArqBase) Then
        Open PathBase + "\" + ArqBase + ".fst" For Output As fnFST
        Print #fnFST, "1 0 mpl, if v706='h'then v121/,v2/,v121,'-',v2/, fi,"
        Print #fnFST, "1 0 mpl, if v706='i' then v35,'v',v31,'n',v32/,'i'/, fi,"
        Close
        ret = BD.CriaIf(ArqBase)
    End If
    
    If ret Then
        Set BDIssues = New ClIsisDll
        If BDIssues.Inicializa(PathIssue, ArqIssue) Then
            Open PathIssue + "\" + ArqIssue + ".fst" For Output As fnFST
            Print #fnFST, "1 0 mpl, v35,'v',v31,'n',v32/,v36/"
            Close
            ret = BDIssues.CriaIf(ArqIssue)
        Else
            ret = False
        End If
    End If
    InicializaBase = ret
End Function
Function Gravar(registro As String) As Boolean
    Dim ret As Boolean
    
    If mfn > 0 Then
        If MsgBox("Já existe o registro ISSUE. Atualizar?", vbYesNo) = vbYes Then
            ret = BD.EscrRegistro(mfn, registro)
        End If
    Else
        mfn = BD.GravarRegistro(registro)
        If mfn > 0 Then ret = BD.AtualizaIf(mfn, mfn)
    End If
    If ret Then
        MsgBox "Registro Issue foi gravado."
    Else
        MsgBox "Falha: Registro Issue não foi gravado.", vbCritical
    End If
    Gravar = ret
End Function


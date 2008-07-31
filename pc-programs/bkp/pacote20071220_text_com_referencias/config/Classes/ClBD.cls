VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClBD"
Attribute VB_Creatable = False
Attribute VB_Exposed = False
Option Explicit

Const MaxTamArea = 16000

Const SEM_ERR = 0
Const ERR_PATH = 1
Const ERR_FALTANOMEMST = 2

Private H As Long

Private ErroInicializacao As Integer

Private Path As String
Private Nome As String
Private ArqInv As String

Property Let PathBD(v As String)
    Path = v
End Property
Property Get PathBD() As String
    PathBD = Path
End Property
Property Get FullPathBD() As String
    FullPathBD = Path + "\" + Nome
End Property
Property Get FullPathInv() As String
    FullPathInv = Path + "\" + NomeInv
End Property
Property Let NomeBD(v As String)
    Nome = v
End Property
Property Get NomeBD() As String
    NomeBD = Nome
End Property
Property Let NomeInv(v As String)
    ArqInv = v
End Property
Property Get NomeInv() As String
    NomeInv = ArqInv
End Property

Function Inicializa(pPath As String, pMst As String) As Boolean
       
    ErroInicializacao = SEM_ERR
    
    If pPath = "" Then
        ErroInicializacao = ERR_PATH
    ElseIf pMst = "" Then
        ErroInicializacao = ERR_FALTANOMEMST
    Else
        Path = pPath
        Nome = pMst
    
        If IsisSpaMf(H, FullPathBD) = ERR_FILEMASTER Then ErroInicializacao = IsisSpaMfCreate(H)
        
    End If
    
    If ErroInicializacao <> SEM_ERR Then
        MsgBox ("Houve erro na inicializacao da Base.(" + CStr(ErroInicializacao) + ")")
        Inicializa = False
    Else
        Inicializa = True
    End If
End Function

Public Function GravarNovoRegistro(ByVal valor As String) As Boolean
    Dim ret As Boolean
    Dim Mfn As Long
    Dim R As Long
    
    If ErroInicializacao = SEM_ERR Then
        ret = False
        Mfn = IsisRecNew(H, 0)
        If Mfn > ZERO Then
            If IsisRecUpdate(H, 0, valor) = ZERO Then
                If IsisRecWrite(H, 0) = ZERO Then
                    R = IsisRecIfUpdate(H, Mfn)
                    ret = True
                End If
            End If
        End If
    End If
    GravarNovoRegistro = ret
End Function
Public Function AtualizarRegistro(ByVal Mfn As Long, ByVal valor As String) As Boolean
    Dim ret As Boolean
    Dim R As Long
    Dim QtdMfn As Long
    
    If ErroInicializacao = SEM_ERR Then
        ret = False
        If Mfn > ZERO Then
            If IsisRecRead(H, 0, Mfn) = ZERO Then
                If IsisRecFieldUpdate(H, 0, "d*") = ZERO Then
                    If IsisRecWrite(H, 0) = ZERO Then
                        If IsisRecRead(H, 0, Mfn) = ZERO Then
                            If IsisRecUpdate(H, 0, valor) = ZERO Then
                                If IsisRecWrite(H, 0) = ZERO Then
                                    R = IsisRecIfUpdate(H, Mfn)
                                    ret = True
                                End If
                            End If
                        End If
                    End If
                End If
            End If
        End If
    End If
    AtualizarRegistro = ret
End Function
Function VisualizarRegistro(Mfn As Long) As String
    Dim area As String * MaxTamArea
    Dim tam As Long
    
    If IsisRecRead(H, 0, Mfn) = 0 Then
        tam = IsisRecDump(H, 0, area)
        If tam > ZERO Then VisualizarRegistro = Left(area, tam)
    End If
End Function
Public Function ExisteRegistro(ByVal chave As String) As Long
    Dim Mfns() As Long
    Dim Mfn  As Long
    Dim QtdMfn As Long
    
    If ErroInicializacao = SEM_ERR Then
        QtdMfn = ObterMfnsdaChave(chave, Mfns)
        If QtdMfn > 0 Then Mfn = Mfns(QtdMfn)
    End If
    ExisteRegistro = Mfn
End Function

Public Function ObterValoresdoCampo(ByVal chave As String, campo As Long, valor() As String) As Long
    'Escolhe um periódico e mostra sua sigla
    Dim area As String * 100
    Dim retorno As Long
    Dim i As Long
    Dim j As Long
    Dim k As Long
    Dim R As Long
    Dim pIsisTrmMfn() As IsisTrmMfn
    Dim key As String * KEY_LENGTH
    Dim QtdKey As Long
    Dim QtdTrm As Long
    Dim QtdOcc As Long
    
    key = chave
    'Procura pela chave
    QtdTrm = IsisTrmRead(H, 0, key)
    If QtdTrm > ZERO Then
        ReDim pIsisTrmMfn(QtdTrm)
        QtdKey = IsisTrmMfnMap(H, 0, 1, QtdTrm, pIsisTrmMfn(0)) - 1
        For j = 0 To QtdKey
            R = IsisRecRead(H, 0, pIsisTrmMfn(j).Mfn)
            If R = ZERO Then
                QtdOcc = IsisRecFieldOcc(H, 0, campo)
                If QtdOcc > 0 Then
                    k = retorno
                    retorno = retorno + QtdOcc
                    ReDim Preserve valor(retorno)
                    For i = 1 To QtdOcc
                        R = IsisRecField(H, 0, campo, i, area)
                        If R > ZERO Then valor(k + i) = Left(area, R)
                    Next
                End If
            End If
        Next
    End If
    ObterValoresdoCampo = retorno
End Function

Function CriaIf(ByVal Nome As String) As Boolean
    Dim ret As Boolean
    
    NomeInv = Nome
    Nome = FullPathInv
    ret = True
    If IsisSpaIf(H, Nome) = ERR_FILEINVERT Then
        If IsisSpaFst(H, Nome) = ERR_FILEFST Then
            MsgBox ("Não existe o arquivo " + FullPathInv + ".fst")
            ret = False
        Else
            IsisSpaIfCreate (H)
        End If
    End If
    CriaIf = ret
End Function
Public Function CopiaBase(Destino As String, origem As String) As Boolean
'destino e origem sao nome das bases
    Dim HDestino As Long
    Dim HOrigem  As Long
    Dim ctrl As IsisRecControl
    Dim erro As Boolean
    Dim Mfn As Long
    Dim R As Long
            
    HDestino = IsisSpaNew(A)
    HOrigem = IsisSpaNew(A)
    R = IsisSpaMf(HDestino, Destino)
    If IsisSpaMfCreate(HDestino) = ZERO Then
        If IsisSpaMf(HOrigem, origem) = ZERO Then
            If IsisRecControlMap(HOrigem, ctrl) > ZERO Then
                For Mfn = 1 To (ctrl.nxtmfn - 1)
                    If IsisRecRead(HOrigem, 0, Mfn) = ZERO Then
                        If IsisRecCopy(HOrigem, 0, HDestino, 0) = ZERO Then
                            If IsisRecWrite(HDestino, 0) <> ZERO Then erro = True
                        End If
                    End If
                Next
            End If
        End If
    End If
    IsisSpaDelete (HDestino)
    IsisSpaDelete (HOrigem)
    CopiaBase = Not erro
End Function
Public Function Reorganiza() As Boolean
    Dim Hnovo   As Long
    Dim Hantigo As Long
    Dim ctrl    As IsisRecControl
    Dim erro    As Boolean
    Dim Mfn     As Long
    Dim mens As String
    Dim R As Long
    Dim area As String * 100
    
    Hnovo = IsisSpaNew(A)
    Hantigo = IsisSpaNew(A)
    
    If CopiaBase(Path + "\copia", FullPathBD) Then
        R = IsisSpaMf(Hnovo, FullPathBD)
        If IsisSpaMfCreate(Hnovo) = ZERO Then
            If IsisSpaMf(Hantigo, Path + "\copia") = ZERO Then
                If IsisRecControlMap(Hantigo, ctrl) > ZERO Then
                    'Elimina os espacos
                    Mfn = 1
                    While (Mfn < ctrl.nxtmfn) And (Not erro)
                        If IsisRecRead(Hantigo, 0, Mfn) = ZERO Then
                            If IsisRecNvf(Hantigo, 0) > 0 Then
                                If IsisRecNew(Hnovo, 0) > 0 Then
                                    If IsisRecDump(Hantigo, 0, area) > 0 Then
                                        If IsisRecUpdate(Hnovo, 0, area) = ZERO Then
                                            If IsisRecWrite(Hnovo, 0) <> ZERO Then erro = True
                                        End If
                                    End If
                                End If
                            End If
                        End If
                        Mfn = Mfn + 1
                    Wend
                    
                End If
            End If
        End If
    Else
        erro = True
    End If
    If erro Then
        mens = "Falha na reorganização da base de dados."
        If CopiaBase(FullPathBD, Path + "\copia") Then
            mens = mens + " Base original mantida."
        Else
            mens = mens + " Cópia da base original em copia.mst."
        End If
    Else
        If IsisRecControlMap(Hnovo, ctrl) > ZERO Then
            For Mfn = 1 To ctrl.nxtmfn - 1
                R = IsisRecIfUpdate(Hnovo, Mfn)
            Next
        End If
        IsisSpaDelete (H)
        H = Hnovo
    End If
    IsisSpaDelete (Hantigo)
    Reorganiza = Not erro
End Function
Private Sub Class_Initialize()
    H = IsisSpaNew(A)
End Sub
Public Function ObterMfnsdaChave(ByVal chave As String, retorno() As Long) As Long
    'Escolhe um periódico e mostra sua sigla
    Dim i As Long
    Dim QtdKey As Long
    Dim QtdTrm As Long
    Dim pIsisTrmMfn() As IsisTrmMfn
    Dim pIsisTrmMfn1 As IsisTrmMfn
    Dim key As String * KEY_LENGTH
    Dim R As Long

    key = chave
    'Procura pela chave
    QtdTrm = IsisTrmRead(H, 0, key)
    If QtdTrm > ZERO Then
            ReDim pIsisTrmMfn(QtdTrm)
            QtdKey = IsisTrmMfnMap(H, 0, 1, QtdTrm, pIsisTrmMfn(0))
            If QtdKey > 0 Then ReDim retorno(QtdKey)
            For i = 1 To QtdKey
                retorno(i) = pIsisTrmMfn(i - 1).Mfn
            Next
    End If
    ObterMfnsdaChave = QtdKey
End Function

Private Sub Class_Terminate()
    IsisSpaDelete (H)
End Sub

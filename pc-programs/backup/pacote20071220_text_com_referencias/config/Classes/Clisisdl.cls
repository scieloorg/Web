VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClIsisdll"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Const MaxTamArea = 30000
Const Delim = "{"
Const SEM_ERR = 0

Private ErroIniciacao As Integer

Public H As Long
Public MSTPATH As String
Public MSTFILE As String
Public IFPATH As String
Public IFFILE As String


Property Get MSTFULLPATH() As String
    MSTFULLPATH = MSTPATH + pathsep + MSTFILE
End Property
Property Get IFFULLPATH() As String
    IFFULLPATH = IFPATH + pathsep + IFFILE
End Property

'-----------------------------------------------------------------------
'MfnQuantity  - retorna o total de Records na base
'Retorno    - total de Records na base
'-----------------------------------------------------------------------
Property Get MfnQuantity() As Long
    Dim ctrl As IsisRecControl
    
    If IsisRecControlMap(H, ctrl) > ZERO Then MfnQuantity = ctrl.nxtmfn - 1
End Property

'-----------------------------------------------------------------------
'Inicia - Inicia a base de dados isis
'pPath  - caminho da base
'pMst   - MSTFILE do arquivo da base
'Restart    - reinicia a base de dados
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Function Inicia(pPath As String, pMst As String, label As String, Optional Restart As Boolean) As Boolean
    Dim Ret As Boolean
    
    If DirExist(pPath, label) Then
        If Len(pMst) > 0 Then
            MSTPATH = pPath
            MSTFILE = pMst
            If IsisSpaMf(H, MSTFULLPATH) = ERR_FILEMASTER Then
                ErroIniciacao = IsisSpaMfCreate(H)
            Else
                ErroIniciacao = SEM_ERR
                If Restart Then ErroIniciacao = IsisSpaMfCreate(H)
            End If
        End If
    End If
    If ErroIniciacao = SEM_ERR Then
        'Call IsisRecShelfSize(H, 0, 2 * MAXMFRL)
    Debug.Print vbCrLf & "inicializa "
    Debug.Print "H=" & H
    Debug.Print "master=" & MSTFULLPATH
        
        Ret = True
    End If
    Inicia = Ret
End Function

'-----------------------------------------------------------------------
'IfCreate    - Criar o arquivo invertido
'FileName   - MSTFILE do arquivo
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Function IfCreate(ByVal filename As String, Optional Clear As Boolean, Optional path As String) As Boolean
    Dim Ret As Boolean
    Dim r As Long
    
    If Len(path) > 0 Then
        IFPATH = path
    Else
        IFPATH = MSTPATH
    End If
    
    IFFILE = filename
    r = IsisSpaFst(H, IFFULLPATH)
    If r = ERR_FILEFST Then
        Ret = FileExist(IFPATH, IFFILE + ".fst", "Inverted File")
    ElseIf r = ZERO Then
        r = IsisSpaIf(H, IFFULLPATH)
        If (r = ERR_FILEINVERT) Then
            Ret = (IsisSpaIfCreate(H) = ZERO)
            
        ElseIf r = ZERO Then
            If Clear Then Call IfUpdate(1, MfnQuantity)
            Ret = True
        End If
    End If
    'If Not Ret Then MsgBox "Failure creating inverted file " + IFFULLPATH
    IfCreate = Ret
End Function

'-----------------------------------------------------------------------
'RecordSave - Grava em registro
'Value  - conteúdo a ser gravado
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Public Function RecordSave(ByVal Value As String) As Long
    'Cria e grava um  registro, cujo conteúdo <Value> esteja no formato:
    '   <tag1>campo1</tag1>
    '   <tag2>campo2</tag2>
    '   <tag3>campo3</tag3>
    '   ...
    '   <tagn>campon</tagn>
    'Retorna o Mfn do registro
    Dim ctrl As IsisRecControl
    Dim Ret As Long
    Dim mfn As Long
    
    If ErroIniciacao = SEM_ERR Then
        mfn = IsisRecNew(H, 0)
        If mfn > ZERO Then
            If RecordUpdate(mfn, Value) Then
                Ret = mfn
            Else
                Msg.GiveRunInformation ("Failure writing Mfn=" + CStr(mfn))
            End If
        End If
    End If
    RecordSave = Ret
End Function

'-----------------------------------------------------------------------
'FieldContentUpdate - atualizar conteúdo do campo
'Mfn    - registro
'Campo  - campo
'Value  - conteúdo a ser atualizado
'Occ    - ocorrência do campo (opcional, default=1)
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Public Function FieldContentUpdate(mfn As Long, Campo As Long, Value As String, Optional Occ) As Boolean
    Dim ocorrencia As String
    Dim Ret As Boolean
    
    If IsMissing(Occ) Then
        ocorrencia = "1"
    Else
        ocorrencia = CStr(Occ)
    End If
    If IsisRecRead(H, 0, mfn) = ZERO Then
        If IsisRecFieldUpdate(H, 0, "d" + CStr(Campo) + "/" + ocorrencia) = ZERO Then
            If IsisRecFieldUpdate(H, 0, "a" + CStr(Campo) + Delim + Value + Delim) = ZERO Then
            'Msg.GiveRunInformation ("Mfn=" + CStr(Mfn))
                If IsisRecWrite(H, 0) = ZERO Then Ret = True
            End If
        End If
    End If
    If Not Ret Then Msg.GiveRunInformation ("Failure updating Mfn=" + CStr(mfn))
    FieldContentUpdate = Ret
End Function

'-----------------------------------------------------------------------
'FieldContentDel - apaga conteúdo do campo
'Mfn    - registro
'Campo  - campo
'Occ    - ocorrência do campo (opcional, default=1)
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Public Function FieldContentDel(mfn As Long, Campo As Long, Optional Occ) As Boolean
    Dim ocorrencia As String
    Dim Ret As Boolean
    
    If IsMissing(Occ) Then
        ocorrencia = ""
    Else
        ocorrencia = "/" + CStr(Occ)
    End If
    If IsisRecRead(H, 0, mfn) = ZERO Then
        If IsisRecFieldUpdate(H, 0, "d" + CStr(Campo) + ocorrencia) = ZERO Then
            'Msg.GiveRunInformation ("Mfn=" + CStr(Mfn))
            If IsisRecWrite(H, 0) = ZERO Then Ret = True
        End If
    End If
    If Not Ret Then Msg.GiveRunInformation ("Failure deleting field " + CStr(Campo) + " in Mfn=" + CStr(mfn))
    FieldContentDel = Ret
End Function

'-----------------------------------------------------------------------
'IfUpdate - atualizar o arquivo invertido
'Inicio - registro inicial
'Fim    - registro final
'FlagMantido    -
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Function IfUpdate(Inicio As Long, fim As Long, Optional FlagMantido As Boolean) As Boolean
    Dim op As Long
    Dim r As Long
    
    If FlagMantido Then op = 1
    r = IsisRecIfUpdateEx(H, Inicio, fim, op)
    'Call IsisSpaIf(H, IFFULLPATH)
    If r <> ZERO Then Msg.GiveRunInformation ("Failure updating inverted file " + IFFILE)
    IfUpdate = (r = ZERO)
End Function

'-----------------------------------------------------------------------
'RecordUpdate - atualiza o conteúdo do registro
'Mfn    - registro
'Value  - conteúdo
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Function RecordUpdate(mfn As Long, Value As String) As Boolean
    'Escreve em um registro cujo Mfn= <mfn>, o Value <Value>
    '   <tag1>campo1</tag1>
    '   <tag2>campo2</tag2>
    '   <tag3>campo3</tag3>
    '   ...
    '   <tagn>campon</tagn>
    'Retorna sucesso ou fracasso
    Dim Ret As Boolean
    
    If IsisRecRead(H, 0, mfn) = ZERO Then
        If IsisRecUpdate(H, 0, Value) = ZERO Then
        'Msg.GiveRunInformation ("Mfn=" + CStr(Mfn))
            Ret = (IsisRecWrite(H, 0) = ZERO)
        End If
    End If
    If Not Ret Then Msg.GiveRunInformation ("Failure updating Mfn=" + CStr(mfn))
    RecordUpdate = Ret
End Function

'-----------------------------------------------------------------------
'FieldContentAdd   - adiciona um novo campo a um registro
'Mfn    - registro
'Campo  - campo
'Value  - conteúdo
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Function FieldContentAdd(mfn As Long, Campo As Long, Value As String) As Boolean
    'Escreve em um registro cujo Mfn= <mfn>, o Value <Value>
    Dim Ret As Boolean
    Dim tam As Long
    Dim area As String * MaxTamArea
    Dim v As String
    
    If IsisRecRead(H, 0, mfn) = ZERO Then
        v = "a" + CStr(Campo) + Delim + Value + Delim
        If IsisRecFieldUpdate(H, 0, v) = ZERO Then
        'Msg.GiveRunInformation ("Mfn=" + CStr(Mfn))
            Ret = (IsisRecWrite(H, 0) = ZERO)
        End If
    End If
    If Not Ret Then Msg.GiveRunInformation ("Failure adding field " + CStr(Campo) + " in Mfn=" + CStr(mfn))
    FieldContentAdd = Ret
End Function

'-----------------------------------------------------------------------
'RecordDel    - apaga o conteúdo de um registro
'Mfn    - registro
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Function RecordDel(mfn As Long) As Boolean
    Dim Ret As Boolean
       
    If IsisRecRead(H, 0, mfn) = ZERO Then
        If IsisRecFieldUpdate(H, 0, "d.") = ZERO Then
        'Msg.GiveRunInformation ("Mfn=" + CStr(Mfn))
            If IsisRecWrite(H, 0) = ZERO Then
                Ret = True
            End If
        End If
    End If
    If Not Ret Then Msg.GiveRunInformation ("Failure deleting record Mfn=" + CStr(mfn))

    RecordDel = Ret
End Function

'-----------------------------------------------------------------------
'RecordGet  - retorna o conteúdo do registro
'Mfn    - registro
'-----------------------------------------------------------------------
Function RecordGet(mfn As Long) As String
    Dim area As String * MaxTamArea
    Dim tam As Long
    Dim Ret As String
    
    If IsisRecRead(H, 0, mfn) = ZERO Then
        tam = IsisRecDump(H, 0, area, MaxTamArea)
        If tam > ZERO Then Ret = Left(area, tam)
    End If
    RecordGet = Ret
End Function

'-----------------------------------------------------------------------
'FieldContentOccGet - retorna o conteúdo do campo
'Mfn    - registro
'Campo  - campo
'Occ    - ocorrência do campo no registro
'Retorno    - o conteúdo do campo
'-----------------------------------------------------------------------
Public Function FieldContentOccGet(mfn As Long, Campo As Long, Occ As Long) As String
    Dim area As String * MaxTamArea
    Dim retorno As String
    Dim r As Long
    Dim QtdOcc As Long
    
    r = IsisRecRead(H, 0, mfn)
    If r = ZERO Then
        QtdOcc = IsisRecFieldOcc(H, 0, Campo)
        If (QtdOcc > 0) And (Occ <= QtdOcc) Then
            r = IsisRecField(H, 0, Campo, Occ, area, MaxTamArea)
            If r > ZERO Then
                retorno = Left(area, r)
                r = InStr(retorno, "^")
                If r > 0 Then retorno = Mid(retorno, 1, r - 1)
            End If
        End If
    End If
    FieldContentOccGet = retorno
End Function


'-----------------------------------------------------------------------
'FieldContentGetall - retorna o conteúdo do Field
'Mfn    - registro
'Field  - Field
'Occ    - ocorrência do Field no registro
'Return - o conteúdo do Field
'-----------------------------------------------------------------------
Public Function FieldContentGet(mfn As Long, Field As Long, Contents() As String) As Long
    Dim area As String * MaxTamArea
    Dim aux As String
    Dim r As Long
    Dim QtdOcc As Long
    Dim Occ As Long
    
    r = IsisRecRead(H, 0, mfn)
    If r = ZERO Then
        QtdOcc = IsisRecFieldOcc(H, 0, Field)
        ReDim Contents(QtdOcc)
        For Occ = 1 To QtdOcc
            r = IsisRecField(H, 0, Field, Occ, area, MaxTamArea)
            If r > ZERO Then
                aux = Left(area, r)
                r = InStr(aux, "^")
                If r > 0 Then aux = Mid(aux, 1, r - 1)
                Contents(Occ) = aux
            End If
        Next
    End If
    FieldContentGet = QtdOcc
End Function

'-----------------------------------------------------------------------
'FieldContentGetall - retorna o conteúdo do Field
'Mfn    - registro
'Field  - Field
'Occ    - ocorrência do Field no registro
'Return - o conteúdo do Field
'-----------------------------------------------------------------------
Public Function FieldContentGetAll(mfn As Long, Field As Long, Contents() As String) As Long
    Dim area As String * MaxTamArea
    Dim aux As String
    Dim r As Long
    Dim QtdOcc As Long
    Dim Occ As Long
    
    r = IsisRecRead(H, 0, mfn)
    If r = ZERO Then
        QtdOcc = IsisRecFieldOcc(H, 0, Field)
        ReDim Contents(QtdOcc)
        For Occ = 1 To QtdOcc
            r = IsisRecField(H, 0, Field, Occ, area, MaxTamArea)
            If r > ZERO Then Contents(Occ) = Left(area, r)
        Next
    End If
    FieldContentGetAll = QtdOcc
End Function

'-----------------------------------------------------------------------
'SubfieldContentGet - retorna o conteúdo do Subfield
'Mfn    - registro
'Field  - Field
'Subfield   - Subfield (uma letra)
'Contents   - conteúdo
'Retorno    - a quantidade de conteúdo
'-----------------------------------------------------------------------
Public Function SubfieldContentGet(mfn As Long, Field As Long, SubField As String, Contents() As String) As Long
    Dim area As String * MaxTamArea
    Dim retorno As String
    Dim r As Long
    Dim QtdOcc As Long
    Dim Occ As Long
    
    r = IsisRecRead(H, 0, mfn)
    If r = ZERO Then
        QtdOcc = IsisRecFieldOcc(H, 0, Field)
        ReDim Contents(QtdOcc)
        For Occ = 1 To QtdOcc
            r = IsisRecSubField(H, 0, Field, Occ, SubField, area, MaxTamArea)
            If r > ZERO Then retorno = Left(area, r)
            Contents(Occ) = retorno
        Next
    End If
            
    SubfieldContentGet = QtdOcc
End Function

'-----------------------------------------------------------------------
'SubFieldContentOccGet - retorna o conteúdo do campo com os subcampos
'Mfn    - registro
'Campo  - campo
'Occ    - ocorrência do campo no registro
'Retorno    - o conteúdo do campo
'-----------------------------------------------------------------------
Public Function FieldContentOccWithSubfieldGet(mfn As Long, Campo As Long, Occ As Long) As String
    Dim area As String * MaxTamArea
    Dim retorno As String
    Dim r As Long
    Dim QtdOcc As Long
    
    r = IsisRecRead(H, 0, mfn)
    If r = ZERO Then
        QtdOcc = IsisRecFieldOcc(H, 0, Campo)
        If (QtdOcc > 0) And (Occ <= QtdOcc) Then
            r = IsisRecField(H, 0, Campo, Occ, area, MaxTamArea)
            If r > ZERO Then retorno = Left(area, r)
        End If
    End If
    FieldContentOccWithSubfieldGet = retorno
End Function

'-----------------------------------------------------------------------
'SubFieldContentOccGet - retorna o conteúdo do subcampo
'Mfn    - registro
'Campo  - campo
'Occ    - ocorrência do campo no registro
'Subcampo   - subcampo (uma letra)
'Retorno    - o conteúdo do subcampo
'-----------------------------------------------------------------------
Public Function SubFieldContentOccGet(mfn As Long, Campo As Long, Occ As Long, Subcampo As String) As String
    Dim area As String * MaxTamArea
    Dim retorno As String
    Dim r As Long
    Dim QtdOcc As Long
    
    r = IsisRecRead(H, 0, mfn)
    If r = ZERO Then
        QtdOcc = IsisRecFieldOcc(H, 0, Campo)
        If (QtdOcc > 0) And (Occ <= QtdOcc) Then
            r = IsisRecSubField(H, 0, Campo, Occ, Subcampo, area, MaxTamArea)
            If r > ZERO Then retorno = Left(area, r)
        End If
    End If
            
    SubFieldContentOccGet = retorno
End Function

'-----------------------------------------------------------------------
'FieldCount   - Retorna a quantidade de campos de um registro
'Mfn    - registro
'Retorno    - a quantidade de campos
'-----------------------------------------------------------------------
Public Function FieldCount(mfn As Long) As Long
    Dim Qtd As Long
                
    If IsisRecRead(H, 0, mfn) = ZERO Then Qtd = IsisRecNvf(H, 0)

    FieldCount = Qtd
End Function

'-----------------------------------------------------------------------
'FieldTagGet - obtém os campos existentes em um registro
'Mfn    - registro
'Campos - retorno
'Retorno    - a quantidade de campos
'-----------------------------------------------------------------------
Public Function FieldTagGet(mfn As Long, Campos() As Long) As Long
    Dim Qtd As Long
    Dim i As Long
    Dim pIsisRecDir() As IsisRecDir
    
    Erase Campos
    If IsisRecRead(H, 0, mfn) = ZERO Then
        Qtd = IsisRecNvf(H, 0)
        ReDim pIsisRecDir(Qtd)
        ReDim Campos(Qtd)
        Call IsisRecDirMap(H, 0, 1, Qtd, pIsisRecDir(0))
        For i = 1 To Qtd
            Campos(i) = pIsisRecDir(i - 1).tag
        Next
        Erase pIsisRecDir
    End If
    FieldTagGet = Qtd
End Function

'-----------------------------------------------------------------------
'ContentAllGet - obtém os Conteudo existentes em um registro
'Mfn    - registro
'Conteudo   - retorno
'Retorno    - a quantidade de Conteudo
'-----------------------------------------------------------------------
Public Function ContentAllGet(mfn As Long, conteudo() As String, ComSubc As Boolean) As Long
    Dim Qtd As Long
    Dim i As Long
    Dim j As Long
    Dim p As Long
    Dim aux As String
    Dim pIsisRecDir() As IsisRecDir
    Dim Occ() As Long
    Dim QtdOcc As Long
    Dim Campo As Long
    
    If IsisRecRead(H, 0, mfn) = ZERO Then
        Qtd = IsisRecNvf(H, 0)
        ReDim pIsisRecDir(Qtd)
        ReDim conteudo(Qtd)
        If IsisRecDirMap(H, 0, 1, Qtd, pIsisRecDir(0)) > ZERO Then
            If ComSubc Then
                For i = 1 To Qtd
                    Campo = pIsisRecDir(i - 1).tag
                    If QtdOcc < Campo Then
                        QtdOcc = Campo
                        ReDim Preserve Occ(QtdOcc)
                    End If
                    Occ(Campo) = Occ(Campo) + 1
                    aux = FieldContentOccGet(mfn, Campo, Occ(Campo))
                    p = InStr(aux, "^")
                    While p > 0
                        j = j + 1
                        ReDim Preserve conteudo(j)
                        conteudo(j) = Mid(aux, 1, p - 1)
                        aux = Mid(aux, p + 2)
                        p = InStr(aux, "^")
                    Wend
                    j = j + 1
                    ReDim Preserve conteudo(j)
                    conteudo(j) = Mid(aux, 1)
                    Qtd = j
                Next
            Else
                For i = 1 To Qtd
                    Campo = pIsisRecDir(i - 1).tag
                    If QtdOcc < Campo Then
                        QtdOcc = Campo
                        ReDim Preserve Occ(QtdOcc)
                    End If
                    Occ(Campo) = Occ(Campo) + 1
                    conteudo(i) = FieldContentOccGet(mfn, Campo, Occ(Campo))
                Next
            End If
        End If
    End If
    ContentAllGet = Qtd
End Function

'-----------------------------------------------------------------------
'FieldCount   - Retorna a quantidade (ocorrência) de um determinado campo de um registro
'Mfn    - registro
'Campo  - campo
'Retorno    - ocorrência
'-----------------------------------------------------------------------
Public Function FieldOccCount(mfn As Long, Campo As Long) As Long
    Dim QtdOcc As Long
    
    If IsisRecRead(H, 0, mfn) = ZERO Then QtdOcc = IsisRecFieldOcc(H, 0, Campo)
    FieldOccCount = QtdOcc
End Function

Private Function getMfnsBySearch(ByVal query As String, ByRef Mfns() As Long) As Long
    Dim r, i As Long

    Dim SearchStru As IsisSrcHeader
    Dim SrcMfn() As IsisSrcMfn

    r = IsisSrcSearch(H, 0, query, SearchStru)
    If r > 0 Then
        ReDim SrcMfn(r)
        ReDim Mfns(r)
        r = IsisSrcMfnMap(AppHandle, 0, 0, 1, SearchStru.recs, SrcMfn(0))
        If r > 0 Then
            For i = 1 To SearchStru.recs
                Mfns(i) = SrcMfn(i - 1).mfn
            Next i
        End If
    End If
    
    getMfnsBySearch = SearchStru.recs
End Function
Private Function getMfns(ByVal query As String, ByRef Mfns() As Long) As Long
    Dim i As Long
    Dim QtdTrm As Long
    Dim r As Long
    
    Dim pIsisTrmMfn() As IsisTrmMfn
    Dim trmread As IsisTrmRead
    Dim from_Posting As Long
    Dim to_Posting As Long
    
    trmread.Key = query 'term is water
    r = IsisTrmReadMap(H, 0, trmread) 'read term s into shelf 0
    If r > 0 Then
        'found term? if yes, r= number of postings
        from_Posting = 1 'from mfn posting 1
        to_Posting = r 'to mfn posting r
        ReDim pIsisTrmMfn(r) 'redim array of mfns
        ReDim Mfns(r) 'redim array of mfns
        
        r = IsisTrmMfnMap(H, 0, from_Posting, to_Posting, pIsisTrmMfn(0))
        For i = 0 To r - 1 'loop all mfns
            Mfns(i + 1) = pIsisTrmMfn(i).mfn
        Next i
    Else
        
    End If
    getMfns = r
End Function

Private Function getMfnsByInv(ByVal Termo As String, ByRef Mfns() As Long) As Long
    Dim i As Long
    Dim QtdTrm As Long
    Dim q As Long
    
    Dim pIsisTrmMfn() As IsisTrmMfn
    Dim pIsisTrmRead As IsisTrmRead

    pIsisTrmRead.Key = Termo
    
    QtdTrm = IsisTrmReadMap(H, 0, pIsisTrmRead)
    If QtdTrm > ZERO Then
        ReDim pIsisTrmMfn(QtdTrm)
        q = IsisTrmMfnMap(H, 0, 1, QtdTrm, pIsisTrmMfn(0))
        If q > 0 Then ReDim Mfns(q)
        For i = 1 To q
            Mfns(i) = pIsisTrmMfn(i - 1).mfn
        Next
        
    Else
         QtdTrm = 0
    End If
    getMfnsByInv = QtdTrm
End Function

'-----------------------------------------------------------------------
'MfnFind   - retorna os Mfns dos Records correspondentes às chaves
'Termo  - chave
'Mfns   - os Mfns encontrados
'Retorno    - a quantidade de Mfns
'-----------------------------------------------------------------------
Public Function MfnFind(ByVal Termo As String, ByRef Mfns() As Long) As Long
    
    MfnFind = getMfnsByInv(Termo, Mfns)
End Function


'-----------------------------------------------------------------------
'AmpliarIntervaloLivre  - dado um intervalo, amplia este se houver Records vazios nas proximidades
'ini    - limite inferior
'fim    - limite superior
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Function AmpliarIntervaloLivre(ini As Long, fim As Long) As Boolean
    Dim Preenchido As Long
    Dim InicioInterv As Long
    Dim FimInterv As Long
    Dim Ret As Boolean
    
    InicioInterv = ini
    Preenchido = 0
    While (Preenchido = 0) And (InicioInterv - 1 > 1)
        If IsisRecRead(H, 0, InicioInterv - 1) = ZERO Then
            Preenchido = IsisRecNvf(H, 0)
            If Preenchido = 0 Then InicioInterv = InicioInterv - 1
        End If
    Wend
    If ini > InicioInterv Then
        ini = InicioInterv
        Ret = True
    End If
        
    FimInterv = fim
    Preenchido = 0
    While (Preenchido = 0) And (FimInterv + 1 <= MfnQuantity)
        If IsisRecRead(H, 0, FimInterv + 1) = ZERO Then
            Preenchido = IsisRecNvf(H, 0)
            If Preenchido = 0 Then FimInterv = FimInterv + 1
        End If
    Wend
    If fim < FimInterv Then
        fim = FimInterv
        Ret = Ret Or True
    End If
        
    AmpliarIntervaloLivre = Ret
End Function

Private Sub Class_Initialize()
    H = IsisSpaNew(AppHandle)
    ErroIniciacao = -1
End Sub

Private Sub Class_Terminate()
    Debug.Print "Terminate "
    Debug.Print "H=" & H
    Debug.Print "master=" & MSTFULLPATH
            IsisSpaDelete (H)
End Sub

'-----------------------------------------------------------------------
'IfIdentify  - identifica o arquivo invertido
'MSTFILE   - MSTFILE do arquivo invertido
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Function IfIdentify(ByVal File As String) As Boolean
    Dim Ret As Boolean
    Dim r As Long
    
    IFFILE = File
    r = IsisSpaIf(H, IFFULLPATH)
    If r = ZERO Then
        Ret = True
    Else
        Ret = False
    End If
    'If Not Ret Then MsgBox "Erro em IfIdentify."
    IfIdentify = Ret
End Function


Public Function totalOfRecords() As Long
    Dim mfn As Long
    Dim r As Long
            
    For mfn = 1 To MfnQuantity
        If IsisRecRead(H, 0, mfn) = ZERO Then
            r = r + 1
        End If
    Next
    
    totalOfRecords = r
End Function


'-----------------------------------------------------------------------
'BDDel  - apaga a base de dados
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Function BDDel() As Boolean
    Dim Ret As Boolean
    
    If IsisSpaMf(H, MSTFULLPATH) = ZERO Then
        Ret = (IsisSpaMfCreate(H) = ZERO)
    End If
    BDDel = Ret
End Function

Function RecordCopy(SourceMfn As Long, DestinyBD As ClIsisdll, DestinyMfn As Long) As Boolean
    Dim Ret As Boolean
    Dim registro As String
    
    'Obtenção do registro
    If (SourceMfn > 0) And (SourceMfn <= MfnQuantity) Then
        registro = RecordGet(SourceMfn)
    
        If DestinyMfn > 0 Then
            Ret = DestinyBD.RecordUpdate(DestinyMfn, registro)
        Else
            DestinyMfn = DestinyBD.RecordSave(registro)
            Ret = (DestinyMfn > 0)
        End If
    
        If Ret Then
            If Not DestinyBD.IfUpdate(DestinyMfn, DestinyMfn) Then
                Call Msg.GiveRunInformation("Failure updating " + DestinyBD.MSTFILE, True)
                Ret = False
            End If
        Else
            Call Msg.GiveRunInformation("Failure copying record.", True)
        End If
    End If
    RecordCopy = Ret
End Function

Function MfnFindOne(Chave As String) As Long
    Dim xMfn() As Long
    Dim mfn As Long
    Dim i As Long
    
    
    i = MfnFind(Chave, xMfn)
    If i > 0 Then mfn = xMfn(i)
        
    MfnFindOne = mfn
End Function

Function Save(Contents As String, mfn As Long) As Boolean
    Dim Ret As Boolean
    
    If mfn > 0 Then
        If RecordUpdate(mfn, Contents) Then
            Ret = IfUpdate(mfn, mfn)
        End If
    Else
        mfn = RecordSave(Contents)
        If mfn > 0 Then
            Ret = IfUpdate(mfn, mfn)
        End If
    End If
    Save = Ret
End Function

Public Function UsePft(mfn As Long, format As String, Optional proc As String) As String
    Dim area As String * MaxTamArea
    Dim ResultLen As Long
    Dim result As String
    Dim p As IsisSpaHeader
    
    
    If proc <> "" Then

        Call IsisSpaPftCisis(H, proc)
    End If
    
        If IsisSpaPftCisis(H, format) = ZERO Then
            If IsisRecRead(H, 0, mfn) = ZERO Then
                ResultLen = IsisRecFormatCisis(H, 0, area, MaxTamArea)
                If ResultLen > 0 Then result = Left(area, ResultLen)
            End If
        End If
    
    UsePft = result
End Function

Public Function UseProc(mfn As Long, format As String) As Boolean
    Dim Ret As Boolean
    
    'If IsisSpaMf(H, MSTFULLPATH) = ZERO Then
        If IsisRecRead(H, 0, mfn) = ZERO Then
            If IsisRecFieldUpdate(H, 0, format) = ZERO Then
                If IsisRecWrite(H, 0) = ZERO Then Ret = True
            End If
        End If
    'End If
    UseProc = Ret
End Function
'-----------------------------------------------------------------------
'TagOccContentGet - obtém os Tags existentes em um registro
'Mfn    - registro
'Tags   - retorno
'Retorno    - a quantidade de Tags
'-----------------------------------------------------------------------
Public Function TagOccContentGet(mfn As Long, Tags() As Long, Occs() As Long, Contents() As String) As Long
    Dim Qtd As Long
    Dim i As Long
    Dim j As Long
    Dim pIsisRecDir() As IsisRecDir
    Dim done() As Boolean
    Dim QtdOcc As Long
    Dim Occ As Long
    Dim Campo As Long
    Dim Max As Long
    Dim tam As Long
    Dim area As String * MaxTamArea
    
    If IsisRecRead(H, 0, mfn) = ZERO Then
        Qtd = IsisRecNvf(H, 0)
        If Qtd > 0 Then
            ReDim pIsisRecDir(Qtd)
            ReDim Tags(Qtd)
            ReDim Occs(Qtd)
            ReDim Contents(Qtd)
            If IsisRecDirMap(H, 0, 1, Qtd, pIsisRecDir(0)) > ZERO Then
                For i = 1 To Qtd
                    Campo = pIsisRecDir(i - 1).tag
                    If Max < Campo Then
                        Max = Campo
                        ReDim Preserve done(Max)
                    End If
                    If Not done(Campo) Then
                        done(Campo) = True
                        QtdOcc = IsisRecFieldOcc(H, 0, Campo)
                        For Occ = 1 To QtdOcc
                            j = j + 1
                            tam = IsisRecField(H, 0, Campo, Occ, area, MaxTamArea)
                            Contents(j) = Left(area, tam)
                            Tags(j) = Campo
                            Occs(j) = Occ
                        Next
                    End If
                Next
            End If
        End If
    End If
    TagOccContentGet = Qtd
End Function



VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClIsis_Dll"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

Const MaxTamArea = 30000
Const Delim = "{"
Const SEM_ERR = 0

Private ErroIniciacao As Integer

Private H As Long
Private Path As String
Private Nome As String
Private ArqInv() As String

Private mvarIfCount As Long 'local copy
Public Property Let IfCount(ByVal vData As Long)
    ReDim Preserve ArqInv(vData)
    mvarIfCount = vData
End Property
Public Property Get IfCount() As Long
    IfCount = mvarIfCount
End Property
Property Let BDPath(v As String)
    Path = v
End Property
Property Get BDPath() As String
    BDPath = Path
End Property
Property Get FullPathBD() As String
    FullPathBD = Path + pathsep + Nome
End Property
Property Get FullPathInv(i As Long) As String
    If (i > 0) And (i <= IfCount) Then FullPathInv = Path + pathsep + IfName(i)
End Property
Property Let BDNome(v As String)
    Nome = v
End Property
Property Get BDNome() As String
    BDNome = Nome
End Property
Property Let IfName(i As Long, v As String)
    IfCount = i
    ArqInv(i) = v
End Property
Property Get IfName(i As Long) As String
    If (i > 0) And (i <= IfCount) Then IfName = ArqInv(i)
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
'pMst   - nome do arquivo da base
'Restart    - reinicia a base de dados
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Function Inicia(pPath As String, pMst As String, label As String, Optional Restart As Boolean) As Boolean
    Dim ret As Boolean
    
    If DirExist(pPath, label) Then
        If Len(pMst) > 0 Then
            BDPath = pPath
            BDNome = pMst
            If IsisSpaMf(H, FullPathBD) = ERR_FILEMASTER Then
                ErroIniciacao = IsisSpaMfCreate(H)
            Else
                ErroIniciacao = SEM_ERR
                If Restart Then ErroIniciacao = IsisSpaMfCreate(H)
            End If
        End If
    End If
    If ErroIniciacao = SEM_ERR Then
        'Call IsisRecShelfSize(H, 0, 2 * MAXMFRL)
        ret = True
    End If
    Inicia = ret
End Function

'-----------------------------------------------------------------------
'IfCreate    - Criar o arquivo invertido
'FileName   - Nome do arquivo
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Function IfCreate(ByVal FileName As String) As Boolean
    Dim ret As Boolean
    Dim R As Long
    
    IfCount = IfCount + 1
    IfName(IfCount) = FileName
    Call IsisSpaMf(H, FullPathBD)
    R = IsisSpaFst(H, FullPathInv(IfCount))
    If R = ERR_FILEFST Then
        ret = FileExist(BDPath, IfName(IfCount) + ".fst", "Inverted File")
    ElseIf R = ZERO Then
        R = IsisSpaIf(H, FullPathInv(IfCount))
        If R = ERR_FILEINVERT Then
            ret = (IsisSpaIfCreate(H) = ZERO)
        ElseIf R = ZERO Then
            ret = True
        End If

    End If
    If Not ret Then MsgBox "Failure creating inverted file " + FullPathInv(IfCount)
    IfCreate = ret
End Function

'-----------------------------------------------------------------------
'RecordSave - Grava em registro
'Value  - conteúdo a ser gravado
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Public Function RecordSave(ByVal Value As String) As Long
    Dim ctrl As IsisRecControl
    Dim ret As Long
    Dim mfn As Long
    
    If ErroIniciacao = SEM_ERR Then
        mfn = IsisRecNew(H, 0)
        If mfn > ZERO Then
            If RecordUpdate(mfn, Value) Then ret = mfn
        End If
    End If
    If ret = 0 Then Msg.GiveRunInformation ("Failure writing Mfn=" + CStr(mfn))

    RecordSave = ret
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
    Dim ret As Boolean
    
    If IsMissing(Occ) Then
        ocorrencia = "1"
    Else
        ocorrencia = CStr(Occ)
    End If
    If IsisRecRead(H, 0, mfn) = ZERO Then
        If IsisRecFieldUpdate(H, 0, "d" + CStr(Campo) + "/" + ocorrencia) = ZERO Then
            If IsisRecFieldUpdate(H, 0, "a" + CStr(Campo) + Delim + Value + Delim) = ZERO Then
            'Msg.GiveRunInformation ("Mfn=" + CStr(Mfn))
                If IsisRecWrite(H, 0) = ZERO Then ret = True
            End If
        End If
    End If
    If Not ret Then Msg.GiveRunInformation ("Failure updating Mfn=" + CStr(mfn))
    FieldContentUpdate = ret
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
    Dim ret As Boolean
    
    If IsMissing(Occ) Then
        ocorrencia = "1"
    Else
        ocorrencia = CStr(Occ)
    End If
    If IsisRecRead(H, 0, mfn) = ZERO Then
        If IsisRecFieldUpdate(H, 0, "d" + CStr(Campo) + "/" + ocorrencia) = ZERO Then
            'Msg.GiveRunInformation ("Mfn=" + CStr(Mfn))
            If IsisRecWrite(H, 0) = ZERO Then ret = True
        End If
    End If
    If Not ret Then Msg.GiveRunInformation ("Failure deleting field " + CStr(Campo) + " in Mfn=" + CStr(mfn))
    FieldContentDel = ret
End Function

'-----------------------------------------------------------------------
'IfUpdate - atualizar o arquivo invertido
'Inicio - registro inicial
'Fim    - registro final
'FlagMantido    -
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Function IfUpdate(Inicio As Long, Fim As Long) As Boolean
    Dim R As Long
    Dim i As Long
    
    Call IsisSpaMf(H, FullPathBD)
    For i = 1 To IfCount - 1
        Call IsisSpaFst(H, FullPathInv(i))
        Call IsisSpaIf(H, FullPathInv(i))
        R = R + IsisRecIfUpdateEx(H, Inicio, Fim, 0)
    Next
    If IfCount > 0 Then
        Call IsisSpaFst(H, FullPathInv(i))
        Call IsisSpaIf(H, FullPathInv(i))
        R = R + IsisRecIfUpdateEx(H, Inicio, Fim, 1)
    End If
    If R <> ZERO Then Msg.GiveRunInformation ("Failure updating inverted file " + IfName(IfCount))
    IfUpdate = (R = ZERO)
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
    Dim ret As Boolean
    
    If IsisRecRead(H, 0, mfn) = ZERO Then
        If IsisRecUpdate(H, 0, Value) = ZERO Then
        'Msg.GiveRunInformation ("Mfn=" + CStr(Mfn))
            ret = (IsisRecWrite(H, 0) = ZERO)
        End If
    End If
    If Not ret Then Msg.GiveRunInformation ("Failure updating Mfn=" + CStr(mfn))
    RecordUpdate = ret
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
    '   <tag1>campo1</tag1>
    '   <tag2>campo2</tag2>
    '   <tag3>campo3</tag3>
    '   ...
    '   <tagn>campon</tagn>
    Dim ret As Boolean
    Dim tam As Long
    Dim area As String * MaxTamArea
    Dim v As String
    
    If IsisRecRead(H, 0, mfn) = ZERO Then
        v = "a" + CStr(Campo) + Delim + Value + Delim
        If IsisRecFieldUpdate(H, 0, v) = ZERO Then
        'Msg.GiveRunInformation ("Mfn=" + CStr(Mfn))
            ret = (IsisRecWrite(H, 0) = ZERO)
        End If
    End If
    If Not ret Then Msg.GiveRunInformation ("Failure adding field " + CStr(Campo) + " in Mfn=" + CStr(mfn))
    FieldContentAdd = ret
End Function

'-----------------------------------------------------------------------
'RecordDel    - apaga o conteúdo de um registro
'Mfn    - registro
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Function Recorddel(mfn As Long) As Boolean
    Dim ret As Boolean
       
    If IsisRecRead(H, 0, mfn) = ZERO Then
        If IsisRecFieldUpdate(H, 0, "d*") = ZERO Then
        'Msg.GiveRunInformation ("Mfn=" + CStr(Mfn))
            If IsisRecWrite(H, 0) = ZERO Then
                ret = True
            End If
        End If
    End If
    If Not ret Then Msg.GiveRunInformation ("Failure deleting record Mfn=" + CStr(mfn))

    Recorddel = ret
End Function

'-----------------------------------------------------------------------
'RecordGet  - retorna o conteúdo do registro
'Mfn    - registro
'-----------------------------------------------------------------------
Function RecordGet(mfn As Long) As String
    Dim area As String * MaxTamArea
    Dim tam As Long
    Dim ret As String
    
    If IsisRecRead(H, 0, mfn) = ZERO Then
        tam = IsisRecDump(H, 0, area, MaxTamArea)
        If tam > ZERO Then ret = Left(area, tam)
    End If
    RecordGet = ret
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
    Dim R As Long
    Dim QtdOcc As Long
    
    R = IsisRecRead(H, 0, mfn)
    If R = ZERO Then
        QtdOcc = IsisRecFieldOcc(H, 0, Campo)
        If (QtdOcc > 0) And (Occ <= QtdOcc) Then
            R = IsisRecField(H, 0, Campo, Occ, area, MaxTamArea)
            If R > ZERO Then
                retorno = Left(area, R)
                R = InStr(retorno, "^")
                If R > 0 Then retorno = Mid(retorno, 1, R - 1)
            End If
        End If
    End If
    FieldContentOccGet = retorno
End Function


'-----------------------------------------------------------------------
'FieldContentGet - retorna o conteúdo do Field
'Mfn    - registro
'Field  - Field
'Occ    - ocorrência do Field no registro
'Return - o conteúdo do Field
'-----------------------------------------------------------------------
Public Function FieldContentGet(mfn As Long, Field As Long, Contents() As String) As Long
    Dim area As String * MaxTamArea
    Dim aux As String
    Dim R As Long
    Dim QtdOcc As Long
    Dim Occ As Long
    
    R = IsisRecRead(H, 0, mfn)
    If R = ZERO Then
        QtdOcc = IsisRecFieldOcc(H, 0, Field)
        ReDim Contents(QtdOcc)
        For Occ = 1 To QtdOcc
            R = IsisRecField(H, 0, Field, Occ, area, MaxTamArea)
            If R > ZERO Then
                aux = Left(area, R)
                R = InStr(aux, "^")
                If R > 0 Then aux = Mid(aux, 1, R - 1)
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
    Dim R As Long
    Dim QtdOcc As Long
    Dim Occ As Long
    
    R = IsisRecRead(H, 0, mfn)
    If R = ZERO Then
        QtdOcc = IsisRecFieldOcc(H, 0, Field)
        ReDim Contents(QtdOcc)
        For Occ = 1 To QtdOcc
            R = IsisRecField(H, 0, Field, Occ, area, MaxTamArea)
            If R > ZERO Then Contents(Occ) = Left(area, R)
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
    Dim R As Long
    Dim QtdOcc As Long
    Dim Occ As Long
    
    R = IsisRecRead(H, 0, mfn)
    If R = ZERO Then
        QtdOcc = IsisRecFieldOcc(H, 0, Field)
        ReDim Contents(QtdOcc)
        For Occ = 1 To QtdOcc
            R = IsisRecSubField(H, 0, Field, Occ, SubField, area, MaxTamArea)
            If R > ZERO Then retorno = Left(area, R)
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
    Dim R As Long
    Dim QtdOcc As Long
    
    R = IsisRecRead(H, 0, mfn)
    If R = ZERO Then
        QtdOcc = IsisRecFieldOcc(H, 0, Campo)
        If (QtdOcc > 0) And (Occ <= QtdOcc) Then
            R = IsisRecField(H, 0, Campo, Occ, area, MaxTamArea)
            If R > ZERO Then retorno = Left(area, R)
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
    Dim R As Long
    Dim QtdOcc As Long
    
    R = IsisRecRead(H, 0, mfn)
    If R = ZERO Then
        QtdOcc = IsisRecFieldOcc(H, 0, Campo)
        If (QtdOcc > 0) And (Occ <= QtdOcc) Then
            R = IsisRecSubField(H, 0, Campo, Occ, Subcampo, area, MaxTamArea)
            If R > ZERO Then retorno = Left(area, R)
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
    
    If IsisRecRead(H, 0, mfn) = ZERO Then
        Qtd = IsisRecNvf(H, 0)
        ReDim pIsisRecDir(Qtd)
        ReDim Campos(Qtd)
        Call IsisRecDirMap(H, 0, 1, Qtd, pIsisRecDir(0))
        For i = 1 To Qtd
            Campos(i) = pIsisRecDir(i - 1).tag
        Next
    End If
    FieldTagGet = Qtd
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

'-----------------------------------------------------------------------
'MfnFind   - retorna os Mfns dos Records correspondentes às chaves
'Termo  - chave
'Mfns   - os Mfns encontrados
'Retorno    - a quantidade de Mfns
'-----------------------------------------------------------------------
Public Function MfnFind(File As String, ByVal Termo As String, Mfns() As Long) As Long
    Dim i As Long
    Dim QtdTrm As Long
    Dim pIsisTrmMfn() As IsisTrmMfn
    Dim pIsisTrmRead As IsisTrmRead

    pIsisTrmRead.Key = Termo
    Call IsisSpaMf(H, FullPathBD)
    Call IsisSpaIf(H, Path + pathsep + File)
    QtdTrm = IsisTrmReadMap(H, 0, pIsisTrmRead)
    If QtdTrm > ZERO Then
        ReDim pIsisTrmMfn(QtdTrm)
        QtdTrm = IsisTrmMfnMap(H, 0, 1, QtdTrm, pIsisTrmMfn(0))
        If QtdTrm > 0 Then ReDim Mfns(QtdTrm)
        For i = 1 To QtdTrm
            Mfns(i) = pIsisTrmMfn(i - 1).mfn
        Next
    Else
        QtdTrm = 0
    End If
    MfnFind = QtdTrm
End Function

Public Function GetTerms(File As String, Terms() As String, format As String) As Long
    Dim pIsisTrmMfn As IsisTrmMfn
    Dim pIsisTrmRead As IsisTrmRead
    Dim area As String * MaxTamArea
    Dim R As Long
    Dim R1 As Long
    Dim QtdTrm As Long
    
    QtdTrm = 0
    Erase Terms
    If IsisSpaMf(H, FullPathBD) = ZERO Then
        If IsisSpaIf(H, Path + pathsep + File) = ZERO Then
            R1 = IsisSpaPftCisis(H, format)
            pIsisTrmRead.Key = ""
            R1 = IsisTrmReadMap(H, 0, pIsisTrmRead)
            While R <> ERR_TRMEOF
                R1 = IsisTrmMfnMap(H, 0, 1, 1, pIsisTrmMfn)
                R1 = IsisRecRead(H, 0, pIsisTrmMfn.mfn)
                R1 = IsisRecFormatCisis(H, 0, area, MaxTamArea)
                If R1 > ZERO Then
                    QtdTrm = QtdTrm + 1
                    ReDim Preserve Terms(QtdTrm)
                    Terms(QtdTrm) = Left(area, R1)
                End If
                R = IsisTrmReadNext(H, 0, pIsisTrmRead)
            Wend
        End If
    End If

    GetTerms = QtdTrm
End Function

Public Function UsePft(mfn As Long, format As String) As String
    Dim area As String * MaxTamArea
    Dim ResultLen As Long
    Dim result As String
    
    If IsisSpaMf(H, FullPathBD) = ZERO Then
        If IsisSpaPftCisis(H, format) = ZERO Then
            If IsisRecRead(H, 0, mfn) = ZERO Then
                ResultLen = IsisRecFormatCisis(H, 0, area, MaxTamArea)
                If ResultLen > 0 Then result = Left(area, ResultLen)
            End If
        End If
    End If
    UsePft = result
End Function

Public Function UseProc(mfn As Long, format As String) As Boolean
    Dim ResultLen As Long
    
    If IsisSpaMf(H, FullPathBD) = ZERO Then
        If IsisRecRead(H, 0, mfn) = ZERO Then
            ResultLen = IsisRecFieldUpdate(H, 0, format)
        End If
    End If
    UseProc = (ResultLen > 0)
End Function

Private Sub Class_Initialize()
    H = IsisSpaNew(A)
    ErroIniciacao = -1
End Sub

Private Sub Class_Terminate()
    IsisSpaDelete (H)
End Sub

'-----------------------------------------------------------------------
'BDDel  - apaga a base de dados
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Function BDDel() As Boolean
    Dim ret As Boolean
    
    If IsisSpaMf(H, FullPathBD) = ZERO Then
        ret = (IsisSpaMfCreate(H) = ZERO)
    End If
    BDDel = ret
End Function

Function RecordCopy(SourceMfn As Long, DestinyBD As ClIsis_Dll, DestinyMfn As Long) As Boolean
    Dim ret As Boolean
    Dim registro As String
    
    'Obtenção do registro
    If (SourceMfn > 0) And (SourceMfn <= MfnQuantity) Then
        registro = RecordGet(SourceMfn)
    
        If DestinyMfn > 0 Then
            ret = DestinyBD.RecordUpdate(DestinyMfn, registro)
        Else
            DestinyMfn = DestinyBD.RecordSave(registro)
            ret = (DestinyMfn > 0)
        End If
    
        If ret Then
            If Not DestinyBD.IfUpdate(DestinyMfn, DestinyMfn) Then
                Call Msg.GiveRunInformation("Failure updating " + DestinyBD.BDNome, True)
                ret = False
            End If
        Else
            Call Msg.GiveRunInformation("Failure copying record.", True)
        End If
    End If
    RecordCopy = ret
End Function

Function MfnFindOne(File As String, Chave As String) As Long
    Dim xMfn() As Long
    Dim mfn As Long
    Dim i As Long
    
    
    i = MfnFind(File, Chave, xMfn)
    If i > 0 Then mfn = xMfn(i)
        
    MfnFindOne = mfn
End Function

Function Save(Contents As String, mfn As Long) As Boolean
    Dim ret As Boolean
    
    If mfn > 0 Then
        If RecordUpdate(mfn, Contents) Then
            ret = IfUpdate(mfn, mfn)
        End If
    Else
        mfn = RecordSave(Contents)
        If mfn > 0 Then
            ret = IfUpdate(mfn, mfn)
        End If
    End If
    Save = ret
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

'-----------------------------------------------------------------------
'BDColetaLixo   - remove os Records vazios
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Public Function BDColetaLixo() As Boolean
    Dim Records() As String
    Dim ret As Boolean
    Dim mfn As Long
    Dim reg As String
    Dim q As Long
       
    For mfn = 1 To MfnQuantity
        reg = RecordGet(mfn)
        If Len(reg) > 0 Then
            q = q + 1
            ReDim Preserve Records(q)
            Records(q) = reg
        End If
    Next
    
    If q < MfnQuantity Then
        IsisSpaMfCreate (H)
        IsisSpaIfCreate (H)
        For mfn = 1 To q
            RecordSave (Records(mfn))
        Next
        If q > 0 Then Call IfUpdate(1, q)
        ret = (MfnQuantity = q)
    ElseIf q = MfnQuantity Then
        ret = True
    End If
    Erase Records

    BDColetaLixo = ret
End Function

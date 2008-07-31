VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClTitle"
Attribute VB_Creatable = False
Attribute VB_Exposed = False


Option Explicit

Private H As Long

Private vPathTitle As String
Private vArqTitle As String
Private vArqFBPE As String

Private Key As String * KEY_LENGTH
Private pIsisTrmMfn As IsisTrmMfn
Private pIsisSrcMfn As IsisSrcMfn
Private pIsisSrcHeader As IsisSrcHeader
Private R As Long

Private Type TpTitAlt
    QtdTitAlt As Long
    Nome() As String
End Type

Private Serial() As String
Private sigla() As String
Private vTitAbr() As String
Private vTitAlt() As TpTitAlt
Private vISSN() As String
Private vCidade() As String

Private k As Long

Property Get PathTitles() As String
    PathTitles = vPathTitle
End Property
Property Get ArqTitles() As String
    ArqTitles = vArqTitle
End Property
Property Get ArqInvert() As String
    ArqInvert = vArqFBPE
End Property

Property Let PathTitles(v As String)
    vPathTitle = v
End Property
Property Let ArqTitles(v As String)
    vArqTitle = v
End Property
Property Let ArqInvert(v As String)
    vArqFBPE = v
End Property

Property Get Periodico(i As Long) As String
    If (i > 0) And (i <= k) Then
        Periodico = Serial(i)
    Else
        Periodico = ""
    End If
End Property
Property Get gSigla(i As Long) As String
    If (i > 0) And (i <= k) Then
        gSigla = sigla(i)
    Else
        gSigla = ""
    End If
End Property
Property Get gQtdPeriodicos() As Long
    gQtdPeriodicos = k
End Property

Private Function ObterCampo(ByVal chave As String, campo As Long, valor() As String) As Long
    'Escolhe um periódico e mostra sua sigla
    Dim area As String * 100
    Dim retorno As Long
    Dim i As Long
    
    Key = chave
    'Procura pela chave
    R = IsisTrmRead(H, 0, Key)
    If R > ZERO Then
        R = IsisTrmMfnMap(H, 0, 1, 1, pIsisTrmMfn)
        If R > ZERO Then
            R = IsisRecRead(H, 0, pIsisTrmMfn.Mfn)
            If R = ZERO Then
                retorno = IsisRecFieldOcc(H, 0, campo)
                For i = 1 To retorno
                    R = IsisRecField(H, 0, campo, i, area)
                    If R > ZERO Then
                        ReDim Preserve valor(i)
                        valor(i) = Left(area, R)
                    End If
                Next
            End If
        End If
    End If
    ObterCampo = retorno
End Function

Private Sub ObterCampos(vet() As String, campo As Long)
    Dim i As Long
    Dim aux() As String
    Dim auxi As Long
    
    If k > 0 Then ReDim vet(k)
    For i = 1 To k
        auxi = ObterCampo(Serial(i), campo, aux)
        If auxi = 1 Then vet(i) = aux(1)
    Next
End Sub
Private Sub ObterTitAlt(campo As Long)
    Dim i As Long
    Dim j As Long
    Dim aux() As String
    Dim auxi As Long
    
    If k > 0 Then ReDim vTitAlt(k)
    For i = 1 To k
        auxi = ObterCampo(Serial(i), campo, aux)
        vTitAlt(i).QtdTitAlt = auxi
        ReDim vTitAlt(i).Nome(auxi)
        For j = 1 To auxi
            vTitAlt(i).Nome(j) = aux(j)
        Next
    Next
End Sub

Public Sub ObterPeriodicos()
    Dim x As String
    Dim NomeMf As String
    Dim NomeIf As String
    Dim area As String * 1000
    Dim R1 As Long
    
    NomeMf = PathTitles + "\" + ArqTitles
    NomeIf = PathTitles + "\" + ArqInvert
    R = IsisSpaMf(H, NomeMf)
    If R <> ZERO Then
        MsgBox "Master not found r=" & Str$(R)
    Else
        R = IsisSpaIf(H, NomeIf)
        If R <> ZERO Then
            MsgBox "If not found r=" & Str$(R)
        Else
            x = "v130*0.1|:|,v100"
            R = IsisSpaPftCisis(H, x)
            Key = ""
            R = IsisTrmRead(H, 0, Key)
            While R <> ERR_TRMEOF
                R1 = IsisTrmMfnMap(H, 0, 1, 1, pIsisTrmMfn)
                R1 = IsisRecRead(H, 0, pIsisTrmMfn.Mfn)
                R1 = IsisRecFormatCisis(H, 0, area, 900)
                
                k = k + 1
                ReDim Preserve Serial(k)
                Serial(k) = Left(area, R1)
                'combo1.AddItem Left$(area, R1)
                'Print Str$(r) + " " + Left$(area, r1) + " " + Str$(pIsisTrmMfn.Mfn)
                R = IsisTrmReadNext(H, 0, Key)
            Wend
        End If
    End If
End Sub

Sub Inicializa(Path As String, Base As String, Invert As String)
    PathTitles = Path
    ArqTitles = Base
    ArqInvert = Invert
    ObterPeriodicos
    Call ObterCampos(sigla, 930)
    Call ObterCampos(vTitAbr, 150)
    Call ObterCampos(vISSN, 400)
    Call ObterCampos(vCidade, 490)
    Call ObterTitAlt(230)
End Sub
Property Get TitAbr(i As Long) As String
    If (i > 0) And (i <= k) Then
        TitAbr = vTitAbr(i)
    Else
        TitAbr = ""
    End If
End Property
Property Get Cidade(i As Long) As String
    If (i > 0) And (i <= k) Then
        Cidade = vCidade(i)
    Else
        Cidade = ""
    End If
End Property
Property Get ISSN(i As Long) As String
    If (i > 0) And (i <= k) Then
        ISSN = vISSN(i)
    Else
        ISSN = ""
    End If
End Property
Property Get TitAlt(i As Long, vet() As String) As Long
    Dim j As Long
    Dim j1 As Long
    
    If (i > 0) And (i <= k) Then
        j1 = vTitAlt(i).QtdTitAlt
        ReDim vet(j1)
        For j = 1 To j1
            vet(j) = vTitAlt(i).Nome(j)
        Next
        TitAlt = j1
    Else
        TitAlt = 0
    End If
End Property

Private Sub Class_Initialize()
    H = IsisSpaNew(A)
End Sub

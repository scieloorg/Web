Attribute VB_Name = "Module1"
Sub xmain()
Dim i As Long
    Dim QtdTrm As Long
    Dim q As Long
    AppHandle = IsisAppNew()
    Call IsisAppDebug(AppHandle, DEBUG_LIGHT)
    H = IsisSpaNew(AppHandle)
            If IsisSpaMf(H, MSTFULLPATH) = ERR_FILEMASTER Then
                ErroIniciacao = IsisSpaMfCreate(H)
            Else
                ErroIniciacao = SEM_ERR
                If Restart Then ErroIniciacao = IsisSpaMfCreate(H)
            End If
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
    Dim pIsisTrmMfn() As IsisTrmMfn
    Dim pIsisTrmRead As IsisTrmRead

    pIsisTrmRead.Key = Termo
    Erase Mfns
    
'    Call IsisSpaFst(H, IFFULLPATH) sem eles resolve Cisis\low level track... dbopen...
'    Call IsisSpaIf(H, IFFULLPATH)
    
    QtdTrm = IsisTrmReadMap(H, 0, pIsisTrmRead)
    
    If QtdTrm > ZERO Then
    'MsgBox "if " + IFFULLPATH + " Termo=[" + Termo + "] " + CStr(QtdTrm)
        ReDim pIsisTrmMfn(QtdTrm)
        q = IsisTrmMfnMap(H, 0, 1, QtdTrm, pIsisTrmMfn(0))
        If q > 0 Then ReDim Mfns(q)
        For i = 1 To q
            Mfns(i) = pIsisTrmMfn(i - 1).mfn
        Next
        Erase pIsisTrmMfn
    Else
        'MsgBox "if " + IFFULLPATH + " Termo=[" + Termo + "] " + CStr(QtdTrm)
         QtdTrm = 0
    End If
    MfnFind = QtdTrm

End Sub

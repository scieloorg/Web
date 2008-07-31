Attribute VB_Name = "ModGlobal"
Option Explicit

'Uso de isisdll
Public AppHandle    As Long
Public Const delim1 = "<"
Public Const delim2 = ">"
Public Const pathsep = "\"

Public ConfigLabels As ClLabels
Public Fields As ClFields
Public Months As ColIdiomMeses
Public IdiomsInfo As ColIdiom

'Variaveis de configuracao
Public SciELOPath As String
Public VolSiglum As String
Public NoSiglum As String
Public SupplVolSiglum  As String
Public SupplNoSiglum  As String
Public BrowserPath  As String
Public CurrIdiomHelp As String
Public IssueCloseDenied As Integer
Public TitleCloseDenied As Integer
Public PathsConfigurationFile As String

Public Paths As ColFileInfo


'Public IdiomHelp   As ColIdiom
Public Msg As New ClMsg
Public SepLinha As String

'Bases
Public BDIssues As ClIsisdll
Public DBSection As ClIsisdll

Public NodeFatherKey() As String
Public NodeChild() As String
Public NodeInfo() As String
Public FileNotRequired() As Boolean
Public Counter As Long

Public CodeStudyArea As ColCode
Public CodeAlphabet As ColCode
Public CodeLiteratureType As ColCode
Public CodeTreatLevel As ColCode
Public CodePubLevel As ColCode
Public CodeFrequency As ColCode
Public codeStatus As ColCode
Public CodeTxtLanguage As ColCode
Public CodeAbstLanguage As ColCode
Public CodeCountry As ColCode
Public CodeState As ColCode
Public CodeUsersubscription As ColCode
Public CodeFTP As ColCode
Public CodeCCode As ColCode
Public CodeIdxRange As ColCode
Public CodeStandard As ColCode
Public CodeScheme As ColCode
Public CodeIssStatus As ColCode
Public CodeIdiom As ColCode
Public CodeTOC As ColCode
Public CodeScieloNet As ColCode
Public CodeISSNType As ColCode

Public journal As ClsJournal

Public ErrorMessages As ClsErrorMessages


Property Get NotRequiredFile(i As Long) As Boolean
    NotRequiredFile = FileNotRequired(i)
End Property

Function TagContent(ByVal conteudo As String, ByVal tag As Long) As String
    Dim ComTag As String
    
    If tag = 0 Then
        MsgBox "TagContent: tag=0. Conteudo=" + conteudo
    ElseIf conteudo = "" Then
        'MsgBox "TagContent: Conteudo=" + conteudo
    Else
        conteudo = RmNewLineInStr(conteudo)
        ComTag = delim1 + CStr(tag) + delim2 + conteudo + delim1 + "/" + CStr(tag) + delim2 + SepLinha
    End If
    TagContent = ComTag
End Function

Function LoadFiles() As Boolean
    Dim Ret As Boolean
    
        If InicializaBaseIssue() Then
            If InicializaBaseSecoes() Then
                Ret = True
            End If
        End If
    
    LoadFiles = Ret
End Function

Sub UnloadFilesIssue()
    Set BDIssues = Nothing
    Set DBSection = Nothing
End Sub

Private Sub Main()
    Dim CodeDB As ClFileInfo
    
   
        
    AppHandle = IsisAppNew()
    Call IsisAppDebug(AppHandle, DEBUG_LIGHT)
    
    SepLinha = Chr(13) + Chr(10)
        
    If ConfigGet Then
                
        ChangeInterfaceIdiom = CurrIdiomHelp
        
        
        Set ErrorMessages = New ClsErrorMessages
        ErrorMessages.load (CurrIdiomHelp + "_err.txt")
        
        Set Months = New ColIdiomMeses
        Months.ReadMonthTable
    
        Set CodeDB = Paths("NewCode Database")
        Call LoadCodes(CodeDB, "", "ccode", CodeCCode)
        
        Set CodeDB = Paths("Code Database")
        Call LoadCodes(CodeDB, "", "standard", CodeStandard)
        Call LoadCodes(CodeDB, "", "scielonet", CodeScieloNet)
        
        
        FormMenuPrin.OpenMenu
        
        Set journalDAO = New ClsJournalDAO
        
        'FormConfig.Show vbModal
    End If
    
    
End Sub

Function ConfigGet() As Boolean
    Dim fn As Long
    Dim key As String
    
    
    fn = 1
    Open App.path + "\scipath.ini" For Input As fn
    Input #fn, SciELOPath
    Close fn
    
    fn = FreeFile(1)
    Open App.path + "\value.ini" For Input As fn
    'Input #fn, Key, SciELOPath
    Input #fn, key, VolSiglum
    Input #fn, key, NoSiglum
    Input #fn, key, SupplVolSiglum
    Input #fn, key, SupplNoSiglum
    Input #fn, key, BrowserPath
    Input #fn, key, CurrIdiomHelp
    Input #fn, key, IssueCloseDenied
    Input #fn, key, TitleCloseDenied
    Input #fn, key, PathsConfigurationFile
    Close fn


    ConfigGet = True
End Function


Sub ConfigSet()
    Dim fn As Long
    
    fn = FreeFile(1)
    Open "value.ini" For Output As fn
'    Write #fn, "SciELOPath", SciELOPath
    Write #fn, "SglVol", VolSiglum
    Write #fn, "SglNo", NoSiglum
    Write #fn, "SglVolSuppl", SupplVolSiglum
    Write #fn, "SglNoSuppl", SupplNoSiglum
    Write #fn, "BrowserPath", BrowserPath
    Write #fn, "CurrIdiomHelp", CurrIdiomHelp
    Write #fn, "IssueCloseDenied", IssueCloseDenied
    Write #fn, "TitleCloseDenied", TitleCloseDenied
    Write #fn, "PathsConfigurationFile", PathsConfigurationFile
    Close fn
End Sub

Function CheckDateISO(Issue_DateISO As String) As Boolean
    Dim Ret As Boolean
    Dim Data As Date
    Dim dia1 As String
    Dim mes1 As String
    Dim ano1 As String
    Dim dia2 As String
    Dim mes2 As String
    Dim ano2 As String
    
    If Len(Issue_DateISO) <> 8 Then
        
    Else
        dia1 = Mid(Issue_DateISO, 7, 2)
        mes1 = Mid(Issue_DateISO, 5, 2)
        ano1 = Mid(Issue_DateISO, 1, 4)
        
        If (CLng(dia1) > 31) And (CLng(dia1) < 0) Then
            'MsgBox ("Invalid day")
        ElseIf (CLng(mes1) > 12) And (CLng(mes1) < 0) Then
            'MsgBox ("Invalid month.")
        Else
            Ret = True
        End If
    End If
    If Not Ret Then MsgBox ConfigLabels.MsgInvalidDATEISO, vbCritical
    CheckDateISO = Ret
End Function

Function InicializaBaseIssue() As Boolean
    Dim Ret As Boolean
    Dim UPDATEDCOUNT As Long
    Dim TmpDB As ClIsisdll
    Dim Mfn As Long
    Dim newmfn As Long
    Dim Mfns() As Long
    Dim i As Long
    Dim Content As String
    Dim recordTotal As Long
    
    Set BDIssues = New ClIsisdll
    
    If BDIssues.Inicia(Paths("Issue Database").path, Paths("Issue Database").FileName, Paths("Issue Database").key) Then
        Call FileCopy(Paths("Issue FST").path + "\" + Paths("Issue FST").FileName, Paths("Issue Database").path + "\" + Paths("Issue Database").FileName + ".fst")
        If BDIssues.IfCreate(Paths("Issue Database").FileName) Then
            UPDATEDCOUNT = BDIssues.MfnFind("FSTUPD=1", Mfns)
            recordTotal = BDIssues.totalOfRecords
            If UPDATEDCOUNT = recordTotal Then
                Ret = True
            ElseIf UPDATEDCOUNT < recordTotal Then
'                BDIssues.BDCopy (.Nodes("Issue Database").Parent.FullPath + "\isstemp")
'
'                Set TmpDB = New ClIsisDll
'                If TmpDB.Inicia(.Nodes("Issue Database").Parent.FullPath, "isstemp", "Issue Temp") Then
'                    Set BDIssues = Nothing
'
'                    Kill .Nodes("Issue Database").FullPath + ".*"
'                    Call FileCopy(.Nodes("Issue FST").FullPath, .Nodes("Issue Database").FullPath + ".fst")
'
'                    Set BDIssues = New ClIsisDll
'                    If BDIssues.Inicia(.Nodes("Issue Database").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Issue Database").Text, FormMenuPrin.DirStruct.Nodes("Issue Database").Key, True) Then
'                        If BDIssues.IfCreate(.Nodes("Issue Database").Text) Then
'                            i = 1
'                            For mfn = 1 To TmpDB.MfnQuantity
'
'                                Content = TmpDB.RecordGet(mfn)
'
'                                If Len(Content) > 0 Then
'
'                                    If (i <= UPDATEDCOUNT) Then
'                                        If mfn < Mfns(i) Then
'                                            Content = Content + TagContent("1", 991)
'                                        ElseIf mfn = Mfns(i) Then
'                                            i = i + 1
'                                        End If
'                                    Else
'                                        Content = Content + TagContent("1", 991)
'                                    End If
'
'                                    newmfn = BDIssues.RecordSave(Content)
'                                    If newmfn > 0 Then
'                                        Call BDIssues.IfUpdate(newmfn, newmfn)
'                                    Else
'                                        Debug.Print
'                                    End If
'                                End If
'                            Next
'                        End If
'                    End If
'
'                End If
'                Ret = (BDIssues.MfnQuantity = BDIssues.MfnFind("FSTUPD=1", Mfns))
                Ret = True
                
            End If
        End If
    End If

    InicializaBaseIssue = Ret
End Function

Function InicializaBaseSecoes() As Boolean
    Dim Ret As Boolean
    
    Set DBSection = New ClIsisdll
    If DBSection.Inicia(Paths("Section Database").path, Paths("Section Database").FileName, Paths("Section Database").key) Then
        Ret = DBSection.IfCreate(Paths("Section Database").FileName)
    End If
    InicializaBaseSecoes = Ret
End Function


Function IssueId(Vol As String, supplvol As String, Num As String, SupplNum As String) As String
    Dim Ret As String
    
    If Len(Vol) > 0 Then Ret = Ret + VolSiglum + Vol
    If Len(supplvol) > 0 Then Ret = Ret + SupplVolSiglum + supplvol
    If Len(Num) > 0 Then Ret = Ret + NoSiglum + Num
    If Len(SupplNum) > 0 Then Ret = Ret + SupplNoSiglum + SupplNum
    
    IssueId = Ret
End Function
Function IssueKey(Vol As String, supplvol As String, Num As String, SupplNum As String) As String
    Dim Ret As String
    
    Ret = Ret + VolSiglum + Vol
    Ret = Ret + SupplVolSiglum + supplvol
    Ret = Ret + NoSiglum + Num
    Ret = Ret + SupplNoSiglum + SupplNum
    
    IssueKey = Ret
End Function

Function MsgIssueId(Vol As String, supplvol As String, Num As String, SupplNum As String, iseqno As String) As String
    Dim Ret As String
    
    If Len(Vol) > 0 Then Ret = Ret + "Volume = " + Vol + SepLinha
    If Len(supplvol) > 0 Then Ret = Ret + "Volume Suppl = " + supplvol + SepLinha
    If Len(Num) > 0 Then Ret = Ret + "Number = " + Num + SepLinha
    If Len(SupplNum) > 0 Then Ret = Ret + "Number Suppl = " + SupplNum + SepLinha
    If Len(iseqno) > 0 Then Ret = Ret + "Seq. Number = " + iseqno + SepLinha
    MsgIssueId = Ret
End Function




Sub LoadCodes(CodeDB As ClFileInfo, Idiom As String, key As String, Code As ColCode)
    Dim isisCode As ClIsisdll
    Dim Mfn As Long
    Dim Mfns() As Long
    Dim q As Long
    Dim i As Long
    Dim aux As String
    Dim p As Long
    Dim p2 As Long
    Dim itemCode As ClCode
    Dim val As String
    Dim cod As String
    Dim exist As Boolean
    
    
    With CodeDB
    Set Code = New ColCode
    Set isisCode = New ClIsisdll
    If isisCode.Inicia(.path, .FileName, .key) Then
        If isisCode.IfCreate(.FileName) Then
            q = isisCode.MfnFind(Idiom + "-" + key, Mfns)
            While (i < q) And (Mfn = 0)
                i = i + 1
                aux = isisCode.UsePft(Mfns(i), "if v1^*='" + key + "' and v1^l='" + Idiom + "' then (v2^v|;|,v2^c|;;|) fi")
                If Len(aux) > 0 Then Mfn = Mfns(i)
            Wend
            
            If Mfn > 0 Then
                
                Set itemCode = New ClCode
                
                p2 = InStr(aux, ";;")
                p = InStr(aux, ";")
                
                While p2 > 0
                    val = Mid(aux, 1, p - 1)
                    cod = Mid(aux, p + 1, p2 - p - 1)
                
'                    Set itemCode = Code.Item(val, exist)
'                    If Not exist Then
'                        Set itemCode = Code.Add(val)
'                        itemCode.Value = val
'                        itemCode.Code = cod
'                    End If
                    
                    Set itemCode = Code.item(cod, exist)
                    If Not exist Then
                        Set itemCode = Code.add(cod)
                        itemCode.value = val
                        itemCode.Code = cod
                    End If
                
                    aux = Mid(aux, p2 + 2)
                    p2 = InStr(aux, ";;")
                    p = InStr(aux, ";")
                Wend
            End If
        End If
    End If
    End With
End Sub


Property Let ChangeInterfaceIdiom(Idiom As String)
    Dim i As Long
    Dim x As ClIdiom
    Dim CodeDB As ClFileInfo
    
    CurrIdiomHelp = Idiom
    
    Set Paths = New ColFileInfo
    Set Paths = ReadPathsConfigurationFile(PathsConfigurationFile)
    
    'ReadDirTree (CurrIdiomHelp + "_files.ini")
    'MakeTree

    Set ConfigLabels = New ClLabels
    ConfigLabels.SetLabels (Idiom)
    Set Fields = New ClFields
    Fields.SetLabels (Idiom)
    FrmInfo.SetHelps (Idiom)
    
Set CodeDB = New ClFileInfo

    Set CodeDB = Paths("Code Database")
    
    Call LoadCodes(CodeDB, Idiom, "idiom interface", CodeIdiom)
    Call LoadCodes(CodeDB, Idiom, "alphabet of title", CodeAlphabet)
    Call LoadCodes(CodeDB, Idiom, "literature type", CodeLiteratureType)
    Call LoadCodes(CodeDB, Idiom, "treatment level", CodeTreatLevel)
    Call LoadCodes(CodeDB, Idiom, "publication level", CodePubLevel)
    Call LoadCodes(CodeDB, Idiom, "frequency", CodeFrequency)
    Call LoadCodes(CodeDB, Idiom, "status", codeStatus)
    Call LoadCodes(CodeDB, Idiom, "country", CodeCountry)
    Call LoadCodes(CodeDB, Idiom, "state", CodeState)
    
    Call LoadCodes(CodeDB, Idiom, "usersubscription", CodeUsersubscription)
    Call LoadCodes(CodeDB, Idiom, "issn type", CodeISSNType)
    Call LoadCodes(CodeDB, Idiom, "ftp", CodeFTP)
        
    Call LoadCodes(CodeDB, Idiom, "language", CodeAbstLanguage)
    Call LoadCodes(CodeDB, Idiom, "language", CodeTxtLanguage)
    Call LoadCodes(CodeDB, Idiom, "issue status", CodeIssStatus)
    Call LoadCodes(CodeDB, Idiom, "scheme", CodeScheme)
    
    Call LoadCodes(CodeDB, "", "table of contents", CodeTOC)
    
    
    Set CodeDB = Paths("NewCode Database")
    Call LoadCodes(CodeDB, Idiom, "study area", CodeStudyArea)
    'Call LoadCodes(CodeDB, Idiom, "scheme", CodeScheme)
            
    
    Set IdiomsInfo = New ColIdiom
    Set x = New ClIdiom
    For i = 1 To CodeIdiom.count
        Set x = IdiomsInfo.add(CodeIdiom(i).Code, CodeIdiom(i).value, CodeTOC(CodeIdiom(i).Code).value, CodeIdiom(i).Code)
    Next
    
End Property


Function ReadPathsConfigurationFile(File As String) As ColFileInfo
    Dim fn As Long
    Dim lineread As String
    Dim item As ClFileInfo
    Dim key As String
    Dim path As String
    Dim CollectionPaths As ColFileInfo
    Dim req As Long
    
    fn = FreeFile
    Open File For Input As fn
        
    Set CollectionPaths = New ColFileInfo
    
    While Not EOF(fn)
        Line Input #fn, lineread
        If InStr(lineread, "=") > 0 Then
            key = Mid(lineread, 1, InStr(lineread, "=") - 1)
            path = Mid(lineread, InStr(lineread, "=") + 1)
            req = InStr(path, ",required")
            If req > 0 Then
                path = Mid(path, 1, req - 1)
                
            End If
            Set item = CollectionPaths.add(key)
            item.key = key
            If InStr(path, "\") > 0 Then
                item.path = Mid(path, 1, InStrRev(path, "\") - 1)
                item.FileName = Mid(path, InStrRev(path, "\") + 1)
            Else
                item.path = ""
                item.FileName = path
            End If
            item.required = (req > 0)
        End If
    Wend
    Close fn
    Set ReadPathsConfigurationFile = CollectionPaths
End Function

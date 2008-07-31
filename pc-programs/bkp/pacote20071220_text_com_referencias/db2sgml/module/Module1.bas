Attribute VB_Name = "ModMain"
Public AppHandle As Long


Sub ConvertDBtoDoc(DBPath As String, DBFile As String, DocPath As String, DoGizmo As Boolean, PFTFile As String, ReportFile As String, DoCipFile As Boolean, RecordIdField As Long, ValidRecords As String, FileNameField As Long)
    Dim FileCount As Long
    Dim i As Long
    Dim FileNames() As String
    Dim DBFiles() As String
    
    FileCount = GetValidRecords(DBPath, DBFile, DocPath, DBFiles, RecordIdField, ValidRecords, FileNameField)
    For i = 1 To FileCount
        If DoGizmo Then Call ReplaceSymbol(DocPath, DBFile)
        If DoCipFile Then Call CreateCipFile(PFTFile, DocPath + "\" + DBFiles(i))
        Call CreateDoc(DocPath, DBFiles(i), DocPath, DBFiles(i), PFTFile, ReportFile)
    Next
    
End Sub

Sub CreateCipFile(CIPFullPath As String, DBFullPath As String)
    Dim fn As Long
    Dim p As Long
    Dim CIPPath As String
    Dim CIPFile As String
    Dim lines() As String
    Dim LineCount As Long
    Dim Line As String
    
    Call SeparateFileandPath(CIPFullPath, CIPPath, CIPFile)
        
    p = InStr(CIPFile, ".")
    If p > 0 Then CIPFile = Mid(CIPFile, 1, p) + "cip"
    
    fn = 1
    Open CIPPath + "\article.cip" For Input As fn
    While Not EOF(fn)
        Line Input #fn, Line
        If Len(Line) > 0 Then
            LineCount = LineCount + 1
            ReDim Preserve lines(LineCount)
            lines(LineCount) = Line
        End If
    Wend
    Close fn
    
    If LineCount > 0 Then
        Open CIPPath + "\" + CIPFile For Output As fn
        Print #fn, "article.*=" + DBFullPath + ".*"
        For p = 1 To LineCount
            Print #fn, lines(p) + "=" + CIPPath + "\" + lines(p)
        Next
        Close fn
    End If
End Sub

Sub ReplaceSymbol(Path As String, database As String)
    Dim Mfn As Long
    Dim NewContents As String
    Dim DBase As ClIsisDll
    
    Set DBase = New ClIsisDll
    If DBase.Inicia(Path, database, "") Then
    
        'ProcMsg.GiveRunInformation ("Converting SGML 2 ASCII.")
        Call DBase.Gizmo(FrmBase2Doc.DirTree.Nodes("sgm2ascii").FullPath)
            
        'ProcMsg.GiveRunInformation ("Replace Font Face Symbol.")
        For Mfn = 1 To DBase.MfnQuantity
            NewContents = DBase.RecordGet(Mfn)
            NewContents = ReplaceFontFaceSymbol(NewContents)
            If Not DBase.RecordUpdate(Mfn, NewContents) Then
                Debug.Print
            End If
        Next
        'ProcMsg.GiveRunInformation ("Converting Grk2SGML")
        Call DBase.Gizmo(FrmBase2Doc.DirTree.Nodes("grk2sgm").FullPath)
        'ProcMsg.GiveRunInformation ("Converting ASCII2SGML")
        Call DBase.Gizmo(FrmBase2Doc.DirTree.Nodes("ascii2sgm").FullPath)
    End If
    Set DBase = Nothing
End Sub

Private Function ReplaceFontFaceSymbol(OldLine As String) As String
    Dim p As Long
    Dim p2 As Long
    Dim pCloseFont As Long
    Dim symbol As String
    Dim Line As String
    
    Const OpenFont = "<FONT "
    Const CloseFont = "</FONT>"
    Const GizmoMarkupStart = "<REPLACESYMBOL>"
    Const GizmoMarkupEnd = "</REPLACESYMBOL> "
        
    Line = OldLine
    p = InStr(Line, OpenFont)
        
    While p > 0
        p2 = InStr(p, Line, ">")
        If p2 > 0 Then
            pCloseFont = InStr(p2, Line, CloseFont, vbTextCompare)
            symbol = Trim(Mid(Line, p2 + 1, pCloseFont - p2 - 1))
            
            Line = Mid(Line, 1, p - 1) + GizmoMarkupStart + symbol + GizmoMarkupEnd + Mid(Line, pCloseFont + Len(CloseFont))
        End If
        p = InStr(Line, OpenFont)
    Wend
    ReplaceFontFaceSymbol = Line
End Function

Sub CreatePubMedDoc(Path As String, database As String, DocPath As String, DocFile As String, PFTFile As String)
    Dim PathToParser As String
    Dim PathToSend As String
    Dim Mfn As Long
    Dim fn As Long
    Dim FN1 As Long
    Dim Result As String
    Dim DBase As ClIsisDll
    Dim CIPFile As String
    Dim CIPPath As String
    Dim p As Long
    
    'Const FileToParser = "toparser.txt"
    
    Const DOCTYPEName = "ArticleSet"
    
    
    Set DBase = New ClIsisDll
    If DBase.Inicia(Path, database, "") Then
            
        PathToParser = DocPath + "\" + DocFile + ".par"
        
        PathToSend = DocPath + "\" + DocFile + ".txt"
    
        fn = 1
        FN1 = fn + 1
    
        Open PathToSend For Output As fn
        Open PathToParser For Output As FN1
    
        With FrmBase2Doc.DirTree
    
        Print #fn, "<" + DOCTYPEName + ">"
        
        Print #FN1, "<!DOCTYPE " + DOCTYPEName + " SYSTEM " + Chr(34) + .Nodes("PubMed DTD").FullPath + Chr(34) + ">"
        Print #FN1, "<" + DOCTYPEName + ">"
    
        Call SeparateFileandPath(PFTFile, CIPPath, CIPFile)
        p = InStr(CIPFile, ".")
        If p > 0 Then CIPFile = Mid(CIPFile, 1, p) + "cip"
        
        If FileExist(CIPPath, CIPFile) Then
            DBase.AppParSet (CIPPath + "\" + CIPFile)
        End If

    
        For Mfn = 1 To DBase.MfnQuantity
            Result = DBase.UsePft(Mfn, "@" + PFTFile)
            If Len(Result) > 0 Then
                Print #fn, Result
                Print #FN1, Result
            End If
        Next
        
        End With
        
        Print #fn, "</" + DOCTYPEName + ">"
        Print #FN1, "</" + DOCTYPEName + ">"
    
        Close fn, FN1
    
    End If
    Set DBase = Nothing
    
End Sub

Function GetHeaderRecords(SourcePath As String, SourceFile As String, DestPath As String, DestFile As String) As Boolean
    Dim Mfn As Long
    Dim NextMfn As Long
    Dim content() As String
    Dim i As Long
    Dim DB As ClIsisDll
    Dim Header As ClIsisDll
    
    Set DB = New ClIsisDll
    Set Header = New ClIsisDll
    
    If DB.Inicia(SourcePath, SourceFile, "Article DestFile") Then
        Set Header = New ClIsisDll
        If Header.Inicia(DestPath, DestFile, "Header DestFile", True) Then
            For Mfn = 1 To DB.MfnQuantity
                If DB.UsePft(Mfn, "v706") = "h" Then
                    i = Header.RecordSave(DB.RecordGet(Mfn))
                End If
            Next
        End If
    End If
    GetHeaderRecords = (i > 0)
End Function

Sub GetAllRecords(SourcePath As String, SourceFile As String, DestPath As String, DestFile As String)
    Call FileCopy(SourcePath + "\" + SourceFile + ".mst", DestPath + "\" + DestFile + ".mst")
    Call FileCopy(SourcePath + "\" + SourceFile + ".xrf", DestPath + "\" + DestFile + ".xrf")
End Sub

Public Function ParserDLL(DocMarkupPath As String, DocMarkupFile As String) As Boolean
    Const MaxMsgLen = 100
    Const MaxStrLen = 35000
    
    Dim DocMarkupFullPath As String
    Dim NoMarkupErrorsFound As Boolean
    Dim MarkupErrorsQtd As Long
    Dim ErrorCode As Long
    Dim MsgLen As Long
    Dim ErrorMsg As String * MaxMsgLen
    Dim MaxMarkupErrors As Long
    Dim MarkupErrorsMsgsLen As Long
    Dim MarkupErrorsMsgs As String * MaxStrLen
    Dim MarkupErrors As String
    
    MaxMarkupErrors = 50
    MsgLen = MaxMsgLen
    MarkupErrorsMsgsLen = MaxStrLen
    MarkupErrorsMsgs = ""
    
    DocMarkupFullPath = DocMarkupPath + "\" + DocMarkupFile
    
    If SGMLDocParse(DocMarkupFullPath, MaxMarkupErrors, MsgLen, MarkupErrorsMsgsLen, MarkupErrorsMsgs) = 0 Then
        NoMarkupErrorsFound = True
    End If
    
    ParserDLL = NoMarkupErrorsFound
End Function

Sub CreateDoc(Path As String, database As String, DocPath As String, DocFile As String, PFTFile As String, ReportFile As String)
    Dim Mfn As Long
    Dim fn As Long
    Dim fn2 As Long
    Dim Result As String
    Dim Report As String
    Dim DBase As ClIsisDll
    Dim CIPFile As String
    Dim CIPPath As String
    Dim p As Long
    Dim i As Long
    Dim pft(3) As String
    Dim pftpath As String
    
    Set DBase = New ClIsisDll
    If DBase.Inicia(Path, database, "") Then
                        
        Call SeparateFileandPath(PFTFile, CIPPath, CIPFile)
        
        p = InStr(CIPFile, ".")
        If p > 0 Then CIPFile = Mid(CIPFile, 1, p) + "cip"
        If FileExist(CIPPath, CIPFile) Then
            DBase.AppParSet (CIPPath + "\" + CIPFile)
        End If
        
        
        fn = 1
        fn2 = 2
        Open DocPath + "\" + DocFile + ".txt" For Output As fn
        Open DocPath + "\" + DocFile + ".rep" For Output As fn2
        
        'For i = 1 To 3
        '    Call SeparateFileandPath(PFTFile, pftpath, pft(i))
        '    pft(i) = pftpath + "\" + CStr(i) + pft(i)
        'Next
            
        For Mfn = 1 To DBase.MfnQuantity
            Result = ""
            'For i = 1 To 3
            '    Result = Result + DBase.UsePft(Mfn, "@" + pft(i))
            'Next
            Result = DBase.UsePft(Mfn, "@" + PFTFile)
            If Len(Result) > 0 Then
                Print #fn, Result
                Report = "Success|"
            Else
                Report = "Failure|"
            End If
            Report = Report + DBase.UsePft(Mfn, "@" + ReportFile)
            Print #fn2, Report
        Next
        Close fn, fn2
    
    End If
    Set DBase = Nothing
End Sub

Function GetHeaderReferencesRecords(SourcePath As String, SourceFile As String, DestPath As String, DestFile() As String, FileNames() As String, FileNamePFT As String) As Long
    Dim Mfn As Long
    Dim i As Long
    Dim DB As ClIsisDll
    Dim NewDB As ClIsisDll
    Dim tpreg As String
    Dim FileCount As Long
    Dim p As Long
    
    Set DB = New ClIsisDll
    Set NewDB = New ClIsisDll
    
    If DB.Inicia(SourcePath, SourceFile, "Article DestFile") Then
        Erase FileNames
        Erase DestFile
        
        For Mfn = 1 To DB.MfnQuantity
            tpreg = DB.UsePft(Mfn, "v706")
            Select Case tpreg
            Case "h"
                FileCount = FileCount + 1
                ReDim Preserve FileNames(FileCount)
                ReDim Preserve DestFile(FileCount)
                FileNames(FileCount) = DB.UsePft(Mfn, FileNamePFT)
                
                p = InStr(FileNames(FileCount), ".")
                If p > 0 Then
                    DestFile(FileCount) = Mid(FileNames(FileCount), 1, p - 1)
                Else
                    DestFile(FileCount) = FileNames(FileCount)
                End If
                
                Set NewDB = New ClIsisDll
                If NewDB.Inicia(DestPath, DestFile(FileCount), "NewDB DestFile", True) Then
                    Call FileCopy(SourcePath + "\" + SourceFile + ".fst", DestPath + "\" + DestFile(FileCount) + ".fst")
                    Call NewDB.IfCreate(DestFile(FileCount))
                    i = NewDB.RecordSave(DB.RecordGet(Mfn))
                    Call NewDB.IfUpdate(i, i)
                End If
            Case "r"
                i = NewDB.RecordSave(DB.RecordGet(Mfn))
                Call NewDB.IfUpdate(i, i)
            End Select
        Next
    End If
    Set NewDB = Nothing
    Set DB = Nothing
    
    GetHeaderReferencesRecords = FileCount
End Function


Function GetValidRecords(SourcePath As String, SourceDB As String, DestPath As String, DestDB() As String, RecordIdField As Long, ValidRecords As String, FileNameField As Long) As Long
    Dim Mfn As Long
    Dim i As Long
    Dim j As Long
    Dim DB As ClIsisDll
    Dim NewDB As ClIsisDll
    Dim tpreg As String
    Dim FileCount As Long
    Dim p As Long
    Dim IsValidRecord As Boolean
    Dim Records() As String
    Dim RecCount As Long
    Dim IsValidRecordCount As Long
    
    If (RecordIdField > 0) And (Len(ValidRecords) > 0) Then
        ValidRecords = ValidRecords + ","
        p = InStr(ValidRecords, ",")
        While p > 0
            RecCount = RecCount + 1
            ReDim Preserve Records(RecCount)
            Records(RecCount) = Mid(ValidRecords, 1, p - 1)
            ValidRecords = Mid(ValidRecords, p + 1)
            p = InStr(ValidRecords, ",")
        Wend
    End If
    
    Set DB = New ClIsisDll
    If DB.Inicia(SourcePath, SourceDB, "Source Database") Then
        For Mfn = 1 To DB.MfnQuantity
            If RecCount > 0 Then
                j = 0
                IsValidRecord = False
                tpreg = DB.UsePft(Mfn, "v" + CStr(RecordIdField))
                While (j < RecCount) And (Not IsValidRecord)
                    j = j + 1
                    If StrComp(tpreg, Records(j)) = 0 Then
                        IsValidRecord = True
                    End If
                Wend
            ElseIf RecCount = 0 Then
                IsValidRecord = True
            End If
            
            If IsValidRecord Then
                IsValidRecordCount = IsValidRecordCount + 1
                If (j = 0) Or (j = 1) Then
                    'obter o(s) nome(s) do arquivo resultado
                    If (FileNameField = 0) Then
                        'apenas um nome
                        If (IsValidRecordCount = 1) Then
                            FileCount = FileCount + 1
                            ReDim Preserve DestDB(FileCount)
                            DestDB(FileCount) = SourceDB
                            Set NewDB = New ClIsisDll
                            If NewDB.Inicia(DestPath, DestDB(FileCount), "NewDB DestDB", True) Then
                                If FileExist(SourcePath, SourceDB + ".fst") Then
                                    Call FileCopy(SourcePath + "\" + SourceDB + ".fst", DestPath + "\" + DestDB(FileCount) + ".fst")
                                    Call NewDB.IfCreate(DestDB(FileCount))
                                End If
                            End If
                        End If
                    Else
                        FileCount = FileCount + 1
                        ReDim Preserve DestDB(FileCount)
                        DestDB(FileCount) = DB.UsePft(Mfn, "v" + CStr(FileNameField))
                
                        p = InStr(DestDB(FileCount), ".")
                        If p > 0 Then DestDB(FileCount) = Mid(DestDB(FileCount), 1, p - 1)
                        
                        Set NewDB = New ClIsisDll
                        If NewDB.Inicia(DestPath, DestDB(FileCount), "NewDB DestDB", True) Then
                            Call FileCopy(SourcePath + "\" + SourceDB + ".fst", DestPath + "\" + DestDB(FileCount) + ".fst")
                            Call NewDB.IfCreate(DestDB(FileCount))
                        End If
                        
                    End If
                End If
                i = NewDB.RecordSave(DB.RecordGet(Mfn))
                Call NewDB.IfUpdate(i, i)
            End If
        Next
    End If
    Set NewDB = Nothing
    Set DB = Nothing
    
    GetValidRecords = FileCount
End Function



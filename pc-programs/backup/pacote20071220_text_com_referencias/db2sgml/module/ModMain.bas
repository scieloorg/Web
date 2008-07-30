Attribute VB_Name = "ModMain"
Public BrowserPath As String

'-app-Public AppHandle As Long
Public CurrDTD As String
Public DTDs As ColDTD


Const DTDInfoFile = "dtdinfo.txt"

Const OpenFont = "<FONT "
Const CloseFont = "</FONT>"

Const GizmoMarkupStart = "<REPLACESYMBOL>"
Const GizmoMarkupEnd = "</REPLACESYMBOL>"

Const ImgSuf = "img"
Const TagImg = "<img "

Private Const TAGC = ">"
Private Const ETAGO = "</"
Private Const STAGO = "<"

Public Const PathSep = "\"
Public Const PathSepUnix = "/"

Private Const MstExt = ".mst"
Private Const XrfExt = ".xrf"
Private Const SGMLExt = ".sgml"
Private Const ParserExt = ".txt"
Public Const ReportExt = ".rep"
Private Const ALLFiles = ".*"

'Const SerialDirectory = "c:\scielo\serial"
Public SerialDirectory As String
Public Const BaseDIR = "base"

Public Const TitleDB_File = "title"
Public Const TitleDB_InvFile = "tit_issn"
Public Const TitleDB_Field = "v100"
Public Const TitleDB_Label = "Title Database"


Private Const GzmField1 = "v1"
Private Const GzmField2 = "v2"

Private Const Parser_EXE = "parser.exe"

Sub Main()
    '-app-AppHandle = IsisAppNew
    ReadIni
    
    FrmBase2Doc.OpenForm
End Sub

Private Sub ReadIni()
    Dim fn As Long
    Dim DTDName As String
    Dim DocTypeName As String
    Dim DTDFile As String
    Dim PFTFILE As String
    Dim CIPFILE As String
    Dim PFTCount As Long
    Dim ReportPFTFile As String
    Dim SGM2ASC As String
    Dim SubSup2ASC As String
    Dim IMG2ASC As String
    Dim RECOVER_REPLACESYMBOL As String
    Dim CORRECTIONS As String
    Dim ASC2SGM As String
    Dim DTD As ClDTD
    Dim exist As Boolean
    Dim i As Long
    Dim P As Long
    Dim ValidRecords As String
    Dim WhiteLine As String
    Dim TAGSFILE As String
    Dim PROCFILE As String
    Dim PFT_Title As String
    Dim hasEmail As String
    Dim hasUCaseLastName As String
    Dim hasAffiliation As String
    Dim line As String
    
    
    
    fn = 1
    Open "brwrpath.txt" For Input As fn
    Line Input #fn, BrowserPath
    Close fn
    
    Open DTDInfoFile For Input As fn
    
    Set DTDs = New ColDTD
    While Not EOF(fn)
        'name,dtdfile,pftfile,pft relatorio,extensao relatorio,gizmo,validrecords,recidfield,FileNamePft,docipfile
        Line Input #fn, DTDName
        Line Input #fn, DocTypeName
        Line Input #fn, DTDFile
        Line Input #fn, PROCFILE
        Line Input #fn, PFTFILE
        Line Input #fn, CIPFILE
        Line Input #fn, TAGSFILE
        Line Input #fn, ReportPFTFile
        Line Input #fn, SGM2ASC
        Line Input #fn, SubSup2ASC
        Line Input #fn, IMG2ASC
        Line Input #fn, RECOVER_REPLACESYMBOL
        Line Input #fn, CORRECTIONS
        Line Input #fn, ASC2SGM
        Line Input #fn, FSTFile
        Line Input #fn, PFT_Title
        Line Input #fn, hasEmail
        Line Input #fn, hasUCaseLastName
        Line Input #fn, hasAffiliation
        Line Input #fn, WhiteLine
        
        Set DTD = New ClDTD
        Set DTD = DTDs(DTDName, exist)
        If Not exist Then
            Set DTD = DTDs.Add(DTDName)
            DTD.name = DTDName
            DTD.DocTypeName = DocTypeName
            DTD.DTDFile = DTDFile
            DTD.PFTFILE = PFTFILE
            DTD.PROCFILE = PROCFILE
            DTD.CIPFILE = CIPFILE
            DTD.TAGSFILE = TAGSFILE
            DTD.PFTCount = PFTCount
            DTD.ReportPFTFile = ReportPFTFile
            DTD.SGM2ASC = SGM2ASC
            DTD.SubSup2ASC = SubSup2ASC
            DTD.IMG2ASC = IMG2ASC
            DTD.RECOVER_REPLACESYMBOL = RECOVER_REPLACESYMBOL
            DTD.CORRECTIONS = CORRECTIONS
            DTD.ASC2SGM = ASC2SGM
            DTD.PFT_Title = PFT_Title
            DTD.FSTFile = FSTFile
            DTD.hasEmail = (hasEmail = "YES")
            DTD.hasUCaseLastName = (hasUCaseLastName = "YES")
            DTD.hasAffiliation = (hasAffiliation = "YES")
        End If
    Wend
    Close fn
    
    CurrDTD = DTDName
    
    Dim paths As ColFileInfo
    
    Set paths = ReadPathsConfigurationFile("..\scielo_paths.ini")
    
    SerialDirectory = paths("Serial Directory").path
        DTDFile = paths("DBtoSGML Program").path + "\" + DTDFile
        PROCFILE = paths("DBtoSGML Program").path + "\" + PROCFILE
        PFTFILE = paths("DBtoSGML Program").path + "\" + PFTFILE
        CIPFILE = paths("DBtoSGML Program").path + "\" + CIPFILE
        TAGSFILE = paths("DBtoSGML Program").path + "\" + TAGSFILE
        ReportPFTFile = paths("DBtoSGML Program").path + "\" + ReportPFTFile
        SGM2ASC = paths("DBtoSGML Program").path + "\" + SGM2ASC
        
        RECOVER_REPLACESYMBOL = paths("DBtoSGML Program").path + "\" + RECOVER_REPLACESYMBOL
        CORRECTIONS = paths("DBtoSGML Program").path + "\" + CORRECTIONS
        ASC2SGM = paths("DBtoSGML Program").path + "\" + ASC2SGM
        FSTFile = paths("DBtoSGML Program").path + "\" + FSTFile
        
        
    'por causa do pubmed
    'ReadDirTree ("treetest.txt")
    'MakeTree

End Sub



Private Function FindImg(DBPath As String, DBFile As String, ImageAddress() As String, ImageShortAddress() As String, ImageReplace() As String) As Long
    Dim p1 As Long
    Dim p2 As Long
    Dim result As String
    Dim Img As String
    Dim img2 As String
    Dim DBase As ClIsisDll
    Dim mfn As Long
    Dim P As Long
    Dim IMGFile As String
    Dim ImgCounter As Long
    Dim Count As Long
            
    Set DBase = New ClIsisDll
    If DBase.Initiate(DBPath, DBFile, DBFile) Then
        
        IMGFile = DBFile + ImgSuf
        
        For mfn = 1 To DBase.MfnQuantity
            result = DBase.RecordGet(mfn)
            p1 = 0
            p1 = InStr(p1 + 1, result, TagImg, vbTextCompare)
            
            If p1 = 0 Then
                If InStr(p1 + 1, result, "img ", vbTextCompare) > 0 Then
                    Debug.Print
                End If
            End If
            
            While p1 > 0
                p2 = InStr(p1, result, TAGC, vbBinaryCompare)
                Img = Mid(result, p1, p2 - p1 + 1)
                P = InStr(Img, PathSepUnix)
                If P > 0 Then
                    While P > 0
                        img2 = Mid(Img, P + 1)
                        P = InStr(P + 1, Img, PathSepUnix, vbBinaryCompare)
                    Wend
                    img2 = DBPath + PathSep + ImgSuf + PathSep + Mid(img2, 1, InStr(2, img2, Chr(34)) - 1)
                Else
                    P = InStr(Img, Chr(34))
                    img2 = Mid(Img, P + 1)
                    img2 = DBPath + PathSep + ImgSuf + PathSep + Mid(img2, 1, InStr(2, img2, Chr(34)) - 1)
                End If
                
                Count = ImgCounter
                Call InsElem(ImageAddress, ImgCounter, Img)
                If Count < ImgCounter Then
                    ReDim Preserve ImageShortAddress(ImgCounter)
                    ReDim Preserve ImageReplace(ImgCounter)
                    'ImageAddress(ImgCounter) = Img
                    ImageShortAddress(ImgCounter) = img2
                End If
                p1 = InStr(p1 + 1, result, TagImg, vbTextCompare)
            Wend
        Next
        'Close fn1
        'Close fn2
    End If
    Set DBase = Nothing
    FindImg = ImgCounter
End Function

Private Function FindSUBSUP(DBPath As String, DBFile As String, SUBSUPTAGs() As String, SUBSUPReplace() As String, SUBSUPContext() As String) As Long
    Dim p1 As Long
    Dim p2 As Long
    Dim P3 As Long
    Dim P4 As Long
    Dim result As String
    Dim SUBSUP As String
    Dim SUBSUP2 As String
    Dim DBase As ClIsisDll
    Dim mfn As Long
    Dim P As Long
    Dim SUBSUPCounter As Long
    
            
    Set DBase = New ClIsisDll
    If DBase.Initiate(DBPath, DBFile, DBFile) Then
        
        For mfn = 1 To DBase.MfnQuantity
            result = DBase.RecordGet(mfn)
            result = ReplaceString(result, "<sub> ", " <SUB>", vbTextCompare)
            result = ReplaceString(result, " </sub>", "</SUB> ", vbTextCompare)
            result = ReplaceString(result, "<sub>", "<SUB>", vbTextCompare)
            result = ReplaceString(result, "</sub>", "</SUB>", vbTextCompare)
            result = ReplaceString(result, "<sup> ", " <SUP>", vbTextCompare)
            result = ReplaceString(result, " </sup>", "</SUP> ", vbTextCompare)
            result = ReplaceString(result, "<sup>", "<SUP>", vbTextCompare)
            result = ReplaceString(result, "</sup>", "</SUP>", vbTextCompare)
            result = ReplaceString(result, "<big>", "", vbTextCompare)
            result = ReplaceString(result, "</big>", "", vbTextCompare)
            result = ReplaceString(result, "<b>", "", vbTextCompare)
            result = ReplaceString(result, "</b>", "", vbTextCompare)
            result = ReplaceString(result, "<strong>", "", vbTextCompare)
            result = ReplaceString(result, "</strong>", "", vbTextCompare)
            result = ReplaceString(result, "<i>", "", vbTextCompare)
            result = ReplaceString(result, "</i>", "", vbTextCompare)
            result = ReplaceString(result, "<em>", "", vbTextCompare)
            result = ReplaceString(result, "</em>", "", vbTextCompare)
            result = ReplaceString(result, "<small>", "", vbTextCompare)
            result = ReplaceString(result, "</small>", "", vbTextCompare)
            result = ReplaceString(result, "<u>", "", vbTextCompare)
            result = ReplaceString(result, "</u>", "", vbTextCompare)
            result = ReplaceString(result, "<br>", "", vbTextCompare)
            result = ReplaceString(result, "</br>", "", vbTextCompare)
            Call DBase.RecordUpdate(mfn, result)
            
            Call InsSubSup(SUBSUPTAGs, SUBSUPReplace, SUBSUPContext, SUBSUPCounter, result, "<SUB>", "</SUB>")
            Call InsSubSup(SUBSUPTAGs, SUBSUPReplace, SUBSUPContext, SUBSUPCounter, result, "<SUP>", "</SUP>")
            
        Next
        'Close fn1
        'Close fn2
        
    End If
    Set DBase = Nothing
    FindSUBSUP = SUBSUPCounter
End Function

Private Sub InsSubSup(SUBSUPTAGs() As String, SUBSUPReplace() As String, SUBSUPContext() As String, SUBSUPCounter As Long, content As String, TAG1 As String, TAG2 As String)
    Dim p1 As Long
    Dim p2 As Long
    Dim pTAG1 As Long
    Dim pTAG2 As Long
    Dim SUBSUP As String
    Dim P As Long
    Dim Pos As Long
    Dim q As Long
    Dim PrevChar As String
    Dim NextChar As String
    Dim s1 As String
    Dim s2 As String
    Dim s3 As String
    Dim br1 As String
    Dim br2 As String
    Dim br3 As String
    Dim counter As Long
    Dim Context As String
    
            
        p1 = InStr(1, content, TAG1, vbBinaryCompare)
        While p1 > 0
            p2 = InStr(p1, content, TAG2, vbBinaryCompare)
            
            If p1 > 10 Then
                Context = Mid(content, p1 - 10, p2 + Len(TAG2) - p1 + 12)
            Else
                Context = Mid(content, 1, p2 + Len(TAG2) - p1 + 2)
            End If
            
            PrevChar = Mid(content, p1 - 1, 1)
            NextChar = Mid(content, p2 + Len(TAG2), 1)
            SUBSUP = Mid(content, p1 - 1, p2 + Len(TAG2) - p1 + 2)
            
            If PrevChar = ">" Then SUBSUP = Mid(SUBSUP, 2)
            If NextChar = "<" Then SUBSUP = Mid(SUBSUP, 1, Len(SUBSUP) - 1)
                        
            pTAG1 = InStr(SUBSUP, TAG1)
            pTAG2 = InStr(pTAG1, SUBSUP, TAG2, vbBinaryCompare)
                            
            counter = SUBSUPCounter
            Call InsElem(SUBSUPTAGs, SUBSUPCounter, SUBSUP)
                
            If counter < SUBSUPCounter Then
                ReDim Preserve SUBSUPReplace(SUBSUPCounter)
                ReDim Preserve SUBSUPContext(SUBSUPCounter)
                
                s1 = Mid(SUBSUP, pTAG1 + Len(TAG1), pTAG2 - pTAG1 - Len(TAG1))
                If Len(s1) > 0 Then s2 = Mid(s1, Len(s1))
                s3 = Mid(s1, 1, 2)
                s1 = Mid(s1, 1, 1)
                
                If (PrevChar Like "[A-Z]") And (s1 Like "[A-Z]") Then
                    br1 = " "
                ElseIf (PrevChar Like "[a-z]") And (s1 Like "[a-z]") Then
                    br1 = " "
                ElseIf (PrevChar Like "[0-9]") And (s1 Like "[0-9]") Then
                    br1 = "("
                ElseIf (PrevChar Like "[0-9]") And (s3 Like "[-+][0-9]") Then
                    br1 = "("
                Else
                    br1 = ""
                End If
                
                If (s2 Like "[A-Z]") And (NextChar Like "[A-Z]") Then
                    br2 = " "
                ElseIf (s2 Like "[a-z]") And (NextChar Like "[a-z]") Then
                    br2 = " "
                ElseIf (s2 Like "[0-9]") And (NextChar Like "[0-9]") Then
                    br2 = ")"
                'ElseIf (s2 Like "[0-9]") And (NextChar Like "[-+]") Then
                  '   br2 = ")"
                Else
                    br2 = ""
                End If
                
                If br1 = "(" Then br2 = ")"
                If br2 = ")" Then br1 = "("
                
                SUBSUPReplace(SUBSUPCounter) = Mid(SUBSUP, 1, pTAG1 - 1) + br1 + Mid(SUBSUP, pTAG1 + 5, pTAG2 - pTAG1 - 5) + br2 + Mid(SUBSUP, pTAG2 + 6)
                SUBSUPContext(SUBSUPCounter) = Context
            End If
            
            p1 = InStr(p1 + 1, content, TAG1, vbTextCompare)
        Wend
            
End Sub


Private Sub InsElem(Elements() As String, counter As Long, NewElem As String)
    Dim i As Long
    Dim found As Boolean
    
    i = 0
    While (i < counter) And (Not found)
        i = i + 1
        If StrComp(Elements(i), NewElem, vbBinaryCompare) = 0 Then
            found = True
        End If
    Wend
    If Not found Then
        counter = counter + 1
        ReDim Preserve Elements(counter)
        Elements(counter) = NewElem
    End If
End Sub
Function GzmImages(ImgGzmPath As String, ImgGzmFile As String, ImageAddress() As String, ImageShortAddress() As String, ImageReplace() As String) As Long
    Dim mfn As Long
    Dim DBase As ClIsisDll
    Dim P As Long
    Dim Img As String
    
    Set DBase = New ClIsisDll
    If DBase.Initiate(ImgGzmPath, ImgGzmFile, ImgGzmFile) Then
        ReDim Preserve ImageAddress(DBase.MfnQuantity)
        ReDim Preserve ImageShortAddress(DBase.MfnQuantity)
        ReDim Preserve ImageReplace(DBase.MfnQuantity)
        
        For mfn = 1 To DBase.MfnQuantity
            ImageAddress(mfn) = DBase.UsePft(mfn, GzmField1)
            ImageReplace(mfn) = DBase.UsePft(mfn, GzmField2)
            
            Img = ImageAddress(mfn)
            P = InStr(Img, PathSepUnix)
            If P > 0 Then
                While P > 0
                    ImageShortAddress(mfn) = Mid(Img, P + 1)
                    P = InStr(P + 1, Img, PathSepUnix, vbBinaryCompare)
                Wend
                ImageShortAddress(mfn) = ImgGzmPath + PathSep + ImgSuf + PathSep + Mid(ImageShortAddress(mfn), 1, InStr(2, ImageShortAddress(mfn), Chr(34)) - 1)
            Else
                P = InStr(Img, Chr(34))
                ImageShortAddress(mfn) = Mid(Img, P + 1)
                ImageShortAddress(mfn) = ImgGzmPath + PathSep + ImgSuf + PathSep + Mid(ImageShortAddress(mfn), 1, InStr(2, ImageShortAddress(mfn), Chr(34)) - 1)
            End If
        Next
    End If
    GzmImages = DBase.MfnQuantity
    Set DBase = Nothing
    
End Function

Private Function GzmSUBSUP(SUBSUPGzmPath As String, SUBSUPGzmFile As String, SUBSUPTAGs() As String, SUBSUPReplace() As String) As Long
    Dim mfn As Long
    Dim DBase As ClIsisDll
    Dim P As Long
    Dim Img As String
    Dim img2 As String
    Dim counter As Long
    Dim i As Long
    
    Set DBase = New ClIsisDll
    If DBase.Initiate(SUBSUPGzmPath, SUBSUPGzmFile, SUBSUPGzmFile) Then
        For mfn = 1 To DBase.MfnQuantity
            i = counter
            Call InsElem(SUBSUPTAGs, counter, DBase.UsePft(mfn, GzmField1))
            If i < counter Then
                ReDim Preserve SUBSUPReplace(counter)
                SUBSUPReplace(counter) = DBase.UsePft(mfn, GzmField2)
            End If
        Next
    End If
    Set DBase = Nothing
    GzmSUBSUP = counter
End Function

Private Sub CreateGzm(GzmPath As String, GzmFile As String, Address() As String, Replace() As String, counter As Long)
    Dim mfn As Long
    Dim DBase As ClIsisDll
    
    Set DBase = New ClIsisDll
    If DBase.Initiate(GzmPath, GzmFile, Chr(32), True) Then
        For mfn = 1 To counter
            If Len(Replace(mfn)) = 0 Then Replace(mfn) = Address(mfn)
            Call DBase.RecordSave("<1>" + Address(mfn) + "</1><2>" + Replace(mfn) + "</2>")
        Next
    End If
    Set DBase = Nothing
End Sub

Private Sub CompareGzm(GzmAddress() As String, GzmReplace() As String, GzmCounter As Long, Address() As String, Replace() As String, counter As Long)
    
    Dim i As Long
    Dim j As Long
    Dim found As Boolean
    
    For i = 1 To counter
        j = 0
        found = False
        While (j < GzmCounter) And (Not found)
            j = j + 1
            If StrComp(Address(i), GzmAddress(j), vbBinaryCompare) = 0 Then
                Replace(i) = GzmReplace(j)
                
                found = True
            End If
        Wend
    Next
    
End Sub

Sub ConvertDBtoDoc(SourceDBPath As String, SourceDBFile As String, DestinyDBPath As String, DestinyDBFile As String)
    Dim SUBSUPCount As Long
    Dim SUBSUP_tag() As String
    Dim SUBSUPReplace() As String
    Dim SUBSUPContext() As String
    Dim GzmSUBSUPCount As Long
    Dim GzmSUBSUPAddr() As String
    Dim GzmSUBSUPReplace() As String
    Dim GzmSUBSUPFile As String
    Dim GzmSUBSUPPath As String
    Dim P As Long
    
    Dim DBImgCount As Long
    Dim DBImgAddr() As String
    Dim DBImgShortAddr() As String
    Dim DBImgReplace() As String
    Dim GzmImgCount As Long
    Dim GzmImgAddr() As String
    Dim GzmImgShortAddr() As String
    Dim GzmImgReplace() As String
    'Dim GzmImgFile As String
    Dim FSTPath As String
    Dim FSTFile As String
    Dim fn As Long
    
    With DTDs(CurrDTD)
    
    .ReadTagsFile
    
    'If FileExist(DestinyDBPath, .IMG2ASC + MstExt) Then Kill DestinyDBPath + PathSep + .IMG2ASC + ALLFiles
    
    Call SeparateFileandPath(.FSTFile, FSTPath, FSTFile)
    Call GetValidRecords(SourceDBPath, SourceDBFile, FSTPath, FSTFile, DestinyDBPath, DestinyDBFile)
    
    If .hasAffiliation Or .hasEmail Or .hasUCaseLastName Then
        Call ApplyProcedures(DestinyDBPath, DestinyDBFile)
    End If
'    If .hasAffiliation Then Call ProcLinkAuthortoAff(DestinyDBPath, DestinyDBFile)
'    If .hasUCaseLastName Then Call ProcUCaseLastName(DestinyDBPath, DestinyDBFile)
'    If .hasEmail Then Call ProcAffiliation(DestinyDBPath, DestinyDBFile)
'
    SUBSUPCount = FindSUBSUP(DestinyDBPath, DestinyDBFile, SUBSUP_tag, SUBSUPReplace, SUBSUPContext)
    If SUBSUPCount > 0 Then
        GzmSUBSUPCount = GzmSUBSUP(DestinyDBPath, .SubSup2ASC, GzmSUBSUPAddr, GzmSUBSUPReplace)
        If GzmSUBSUPCount > 0 Then
            Call CompareGzm(GzmSUBSUPAddr, GzmSUBSUPReplace, GzmSUBSUPCount, SUBSUP_tag, SUBSUPReplace, SUBSUPCount)
        End If
        Call FrmSubp.setTAGSUBSUPs(SUBSUP_tag, SUBSUPReplace, SUBSUPContext, SUBSUPCount)
        Call CreateGzm(DestinyDBPath, .SubSup2ASC, SUBSUP_tag, SUBSUPReplace, SUBSUPCount)
    End If
    Erase SUBSUP_tag
    Erase SUBSUPReplace
    Erase SUBSUPContext
    
    DBImgCount = FindImg(DestinyDBPath, DestinyDBFile, DBImgAddr, DBImgShortAddr, DBImgReplace)
    If DBImgCount > 0 Then
        
        
        If FileExist(DestinyDBPath, .IMG2ASC + MstExt) Then
            GzmImgCount = GzmImages(DestinyDBPath, .IMG2ASC, GzmImgAddr, GzmImgShortAddr, GzmImgReplace)
        End If
        If GzmImgCount > 0 Then
            Call CompareGzm(GzmImgAddr, GzmImgReplace, GzmImgCount, DBImgAddr, DBImgReplace, DBImgCount)
        End If
        Call FrmImage.setImages(DBImgAddr, DBImgShortAddr, DBImgReplace, DBImgCount)
        'Call CreateGzm(DestinyDBPath, GzmImgFile, DBImgAddr, DBImgReplace, DBImgCount)
        Call CreateGzm(DestinyDBPath, .IMG2ASC, DBImgAddr, DBImgReplace, DBImgCount)
        
    End If
    Erase GzmImgAddr
    Erase GzmImgReplace
    Erase DBImgAddr
    Erase DBImgReplace
    
    Call ReplaceSpecialCharacters(DestinyDBPath, DestinyDBFile)
    
    
    Call CreateDoc(DestinyDBPath, DestinyDBFile, DestinyDBPath, DestinyDBFile)
    'Call CreateHTML(DestinyDBPath, DestinyDBFile)
    If Not DirExist(SerialDirectory + PathSep + DTDs(CurrDTD).name) Then MkDir SerialDirectory + PathSep + DTDs(CurrDTD).name
    Call FileCopy(DestinyDBPath + PathSep + DestinyDBFile + ".sgml", SerialDirectory + PathSep + DTDs(CurrDTD).name + PathSep + DestinyDBFile + ".sgml")
    End With
    
    fn = 1
    Open App.path + PathSep + "settings.cfg" For Output As fn
    Print #fn, DTDs(CurrDTD).DTDFile
    Print #fn, DTDs(CurrDTD).DTDFile
    Print #fn, DTDs(CurrDTD).DocTypeName
    Print #fn, "0"
    Print #fn, "0"
    Close fn
    
    Shell App.path + PathSep + Parser_EXE + Chr(32) + DestinyDBPath + PathSep + DestinyDBFile + ParserExt, vbMaximizedFocus
    
End Sub

Private Sub ReplaceSpecialCharacters(path As String, database As String)
    Dim mfn As Long
    Dim NewContents As String
    Dim DBase As ClIsisDll
    
    Set DBase = New ClIsisDll
    If DBase.Initiate(path, database, database) Then
    
        
        Call DBase.Gizmo(path + PathSep + DTDs(CurrDTD).SubSup2ASC)
        Call DBase.Gizmo(path + PathSep + DTDs(CurrDTD).SubSup2ASC)
        If FileExist(path, DTDs(CurrDTD).IMG2ASC + ".mst") Then Call DBase.Gizmo(path + PathSep + DTDs(CurrDTD).IMG2ASC)
                      
        'ProcMsg.GiveRunInformation ("Converting SGML 2 ASCII.")
        Call DBase.Gizmo(DTDs(CurrDTD).SGM2ASC)
            
        'ProcMsg.GiveRunInformation ("Replace Font Face Symbol.")
        For mfn = 1 To DBase.MfnQuantity
            NewContents = DBase.RecordGet(mfn)
            NewContents = ReplaceFontFaceSymbol(NewContents)
            If DBase.RecordUpdate(mfn, NewContents) Then
            End If
        Next
        
        'ProcMsg.GiveRunInformation ("Converting ASCII2SGML")
        Call DBase.Gizmo(DTDs(CurrDTD).ASC2SGM)
        
        'ProcMsg.GiveRunInformation ("Converting Grk2SGML")
        Call DBase.Gizmo(DTDs(CurrDTD).RECOVER_REPLACESYMBOL)
        
        Call DBase.Gizmo(DTDs(CurrDTD).CORRECTIONS)
        
    End If
    Set DBase = Nothing
End Sub

Private Sub ProcAuthor(DBase As ClIsisDll, mfn As Long, procaff As String)
    Dim Occ As Long
    Dim occcount As Long
    Dim author() As String
    Dim aff As String
    Dim affidx As Long
    Dim surname As String
    Dim oldsurname As String
    Dim P As Long
    Dim affid As String
    Dim oldaffid As String
    
    occcount = DBase.FieldOccCount(mfn, 10)
    
    ReDim author(occcount)
    For Occ = 1 To occcount
        author(Occ) = DBase.FieldContentAllOccGet(mfn, 10, Occ)
        'Debug.Print "antes=" + author(Occ)
        If DTDs(CurrDTD).hasUCaseLastName Then
            
            oldsurname = DBase.extractSubfieldContent(author(Occ), "^s")
            surname = UCase(oldsurname)
            author(Occ) = Replace(author(Occ), oldsurname, surname)
        End If
        If DTDs(CurrDTD).hasAffiliation Then
            oldaffid = DBase.extractSubfieldContent(author(Occ), "^1")
            If Len(oldaffid) > 0 Then
                P = InStr(oldaffid, " ")
                affid = oldaffid
                If P > 0 Then affid = Mid(affid, 1, P - 1)
                aff = DBase.UsePft(mfn, "(if v70^i='" + affid + "' then " + procaff + " fi)")
                If Len(aff) > 0 Then
                    author(Occ) = Replace(author(Occ), "^1" + oldaffid, aff)
                End If
            End If
        'Debug.Print "depois=" + author(Occ)
        End If
    Next
    For Occ = 1 To occcount
        'Debug.Print "depois=" + author(Occ)
        Call DBase.FieldContentUpdate(mfn, 10, author(Occ), 1)
    Next
End Sub


Private Sub ApplyProcedures(path As String, database As String)
    Dim Mfns() As Long
    Dim PROCres As String
    Dim fn As Long
    Dim DBase As ClIsisDll
    Dim mfn As Long
    
    Dim PROCs() As String
    Dim qPROCs As Long
    Dim ProcPath As String
    Dim PROCFILE As String

        
    fn = 1
    Open DTDs(CurrDTD).PROCFILE For Input As fn
    While Not EOF(fn)
        qPROCs = qPROCs + 1
        ReDim Preserve PROCs(qPROCs)
        Line Input #fn, PROCs(qPROCs)
    Wend
    Close fn
    Call SeparateFileandPath(DTDs(CurrDTD).PROCFILE, ProcPath, PROCFILE)
    
    Set DBase = New ClIsisDll
    If DBase.Initiate(path, database, database) Then
        For mfn = 1 To DBase.MfnQuantity
            For j = 1 To qPROCs
                PROCres = DBase.UsePft(mfn, "@" + ProcPath + PathSep + PROCs(j))
                If Len(PROCres) > 0 Then
                    If DBase.UseProc(mfn, PROCres) Then
                                        
                    End If
                End If
            Next
            If DTDs(CurrDTD).hasEmail Or DTDs(CurrDTD).hasAffiliation Then Call ProcAffiliation(DBase, mfn)
            If DTDs(CurrDTD).hasUCaseLastName Or DTDs(CurrDTD).hasAffiliation Then Call ProcAuthor(DBase, mfn, "@" + ProcPath + PathSep + "addaff.pft")
        Next
    End If
    Set DBase = Nothing
End Sub

Private Sub ProcAffiliation(DBase As ClIsisDll, mfn As Long)
    Dim Occ As Long
    Dim occcount As Long
    Dim aff() As String
    Dim email As String
    Dim oldemail As String
    Dim orgnames As ColAff
    Dim orgname As String
    Dim city As String
    Dim state As String
    Dim country As String
    Dim zipcode As String
    Dim place As String
    
    Dim orgn As ClAff
    Dim exist As Boolean
    
    Set orgnames = New ColAff
    
    If DTDs(CurrDTD).hasAffiliation Then
        occcount = DBase.FieldOccCount(mfn, 970)
        ReDim aff(occcount)
        
        For Occ = 1 To occcount
            aff(Occ) = DBase.FieldContentAllOccGet(mfn, 970, Occ)
            
            orgname = DBase.extractSubfieldContent(aff(Occ), "")
            city = DBase.extractSubfieldContent(aff(Occ), "^c")
            state = DBase.extractSubfieldContent(aff(Occ), "^s")
            zipcode = DBase.extractSubfieldContent(aff(Occ), "^z")
            country = DBase.extractSubfieldContent(aff(Occ), "^p")
            place = city + state + zipcode + country
            
            If Len(place) > 0 Then
                Set orgn = New ClAff
                Set orgn = orgnames.Item(orgname, exist)
                If Not exist Then
                    Set orgn = orgnames.Add(orgname, city, state, country, zipcode, orgname)
                End If
                Set orgn = Nothing
            End If
        Next
    End If
    
    occcount = DBase.FieldOccCount(mfn, 70)
    ReDim aff(occcount)
    For Occ = 1 To occcount
        aff(Occ) = DBase.FieldContentAllOccGet(mfn, 70, Occ)
        'Debug.Print "antes=" + aff(Occ)
        
        If DTDs(CurrDTD).hasEmail Then
            oldemail = DBase.extractSubfieldContent(aff(Occ), "^e")
            email = cleanedemail(oldemail)
            aff(Occ) = Replace(aff(Occ), oldemail, email)
        End If
        If DTDs(CurrDTD).hasAffiliation Then
            city = DBase.extractSubfieldContent(aff(Occ), "^c")
            state = DBase.extractSubfieldContent(aff(Occ), "^s")
            zipcode = DBase.extractSubfieldContent(aff(Occ), "^z")
            country = DBase.extractSubfieldContent(aff(Occ), "^p")
            place = city + state + zipcode + country
            
            orgname = DBase.extractSubfieldContent(aff(Occ), "")
            Set orgn = New ClAff
            Set orgn = orgnames.Item(orgname, exist)
            If exist Then
                If (Len(city) = 0) And (Len(orgn.city) > 0) Then aff(Occ) = aff(Occ) + "^c" + orgn.city
                If Len(state) = 0 And (Len(orgn.state) > 0) Then aff(Occ) = aff(Occ) + "^s" + orgn.state
                If Len(zipcode) = 0 And (Len(orgn.zipcode) > 0) Then aff(Occ) = aff(Occ) + "^z" + orgn.zipcode
                If Len(country) = 0 And (Len(orgn.country) > 0) Then aff(Occ) = aff(Occ) + "^p" + orgn.country
            End If
            Set orgn = Nothing
        End If
    Next
    Set orgnames = Nothing
    
    For Occ = 1 To occcount
        'Debug.Print "depois=" + aff(Occ)
        Call DBase.FieldContentUpdate(mfn, 70, aff(Occ), 1)
    Next
    
End Sub

Private Function cleanedemail(email As String) As String
    Dim r As String
    Dim P As Long
    Dim rOK As Boolean
    Dim pa As Long
    
    
    r = email
    pa = InStr(1, r, "<a ", vbTextCompare)
    
    While pa > 0
        r = Mid(r, pa + 1)
        P = InStr(1, r, ">", vbTextCompare)
        If P > 0 Then
            r = Mid(r, P + 1)
            P = InStr(1, r, "</a>", vbTextCompare)
            If P > 0 Then
                r = Mid(r, 1, P - 1)
            End If
        End If
        pa = InStr(1, r, "<a ", vbTextCompare)
    Wend
    Debug.Print email
        Debug.Print r
    cleanedemail = r
End Function

Private Function ReplaceFontFaceSymbol(OldLine As String) As String
    Dim pOpenFont1 As Long
    Dim pOpenFont2 As Long
    Dim pCloseFont1 As Long
    Dim symbol As String
    Dim line As String
    Dim TagFONT As String
    
        
    line = OldLine
    pOpenFont1 = InStr(1, line, OpenFont, vbTextCompare)
        
    While pOpenFont1 > 0
        pOpenFont2 = InStr(pOpenFont1, line, TAGC)
        If pOpenFont2 > 0 Then
            TagFONT = Mid(line, pOpenFont1, pOpenFont2 - pOpenFont1)
            pCloseFont1 = InStr(pOpenFont2, line, CloseFont, vbTextCompare)
            symbol = Trim(Mid(line, pOpenFont2 + 1, pCloseFont1 - pOpenFont2 - 1))
            
            If InStr(1, TagFONT, "symbol", vbTextCompare) > 0 Then
                line = Mid(line, 1, pOpenFont1 - 1) + GizmoMarkupStart + symbol + GizmoMarkupEnd + Mid(line, pCloseFont1 + Len(CloseFont))
            Else
                line = Mid(line, 1, pOpenFont1 - 1) + symbol + Mid(line, pCloseFont1 + Len(CloseFont))
            End If
        End If
        pOpenFont1 = InStr(1, line, OpenFont, vbTextCompare)
    Wend
    ReplaceFontFaceSymbol = line
End Function

Private Sub CreateDoc(path As String, database As String, DocPath As String, DocFile As String)
    Dim mfn As Long
    Dim fn As Long
    Dim fn1 As Long
    Dim fn2 As Long
    Dim fn3 As Long
    Dim result As String
    Dim report As String
    Dim DBase As ClIsisDll
    Dim CIPFILE As String
    Dim CIPPath As String
    Dim P As Long
    Dim i As Long
    Dim ResultLen As Long
    Dim q As Long
    
    Dim pfts() As String
    Dim qpfts As Long
    Dim pftpath As String
    Dim PFTFILE As String
    
    Set DBase = New ClIsisDll
    If DBase.Initiate(path, database, database) Then
        q = DBase.MfnQuantity
    End If
    Set DBase = Nothing
    
    If q > 0 Then
        'PFT FILE
        fn = 1
        Open DTDs(CurrDTD).PFTFILE For Input As fn
        While Not EOF(fn)
            qpfts = qpfts + 1
            ReDim Preserve pfts(qpfts)
            Line Input #fn, pfts(qpfts)
        Wend
        Close fn
        Call SeparateFileandPath(DTDs(CurrDTD).PFTFILE, pftpath, PFTFILE)
        
        fn1 = 2
        fn2 = 3
        fn3 = 4
        
        Open DocPath + PathSep + DocFile + SGMLExt For Output As fn
        Open DocPath + PathSep + DocFile + ParserExt For Output As fn1
        Open DocPath + PathSep + DocFile + ReportExt For Output As fn2
        Open DocPath + PathSep + DocFile + ".htm" For Output As fn3
        
            
        Print #fn1, "<!DOCTYPE " + DTDs(CurrDTD).DocTypeName + " SYSTEM " + Chr(34) + DTDs(CurrDTD).DTDFile + Chr(34) + TAGC
        Print #fn3, "<html><body>"
        Print #fn, STAGO + DTDs(CurrDTD).DocTypeName + TAGC
        Print #fn1, STAGO + DTDs(CurrDTD).DocTypeName + TAGC
        Print #fn3, ConvertSGML2HTML(STAGO + DTDs(CurrDTD).DocTypeName + TAGC)
        

        ResultLen = 0
        For mfn = 1 To q
            
            Debug.Print mfn
            
            Call Isis2SGML(path, database, mfn, report, result, pftpath, pfts, qpfts)
            
            If Len(result) > 0 Then
                Print #fn, result
                Print #fn1, result
                Print #fn3, ConvertSGML2HTML(result)
            End If
            
            If Len(report) > 0 Then
                If Len(result) > 0 Then
                    report = "Sucess|" + report
                Else
                    report = "Failure|" + report
                End If
                Print #fn2, report
            End If
        Next
        
        Print #fn, ETAGO + DTDs(CurrDTD).DocTypeName + TAGC
        Print #fn1, ETAGO + DTDs(CurrDTD).DocTypeName + TAGC
        Print #fn3, ConvertSGML2HTML(ETAGO + DTDs(CurrDTD).DocTypeName + TAGC) + "</body></html>"
        
        Close fn, fn1, fn2, fn3
    
    End If
    Set DBase = Nothing
    Kill path + PathSep + database + MstExt
    Kill path + PathSep + database + XrfExt
    
End Sub

Private Sub Isis2SGML(path As String, database As String, mfn As Long, report As String, result As String, pftpath As String, pfts() As String, qpfts As Long)
    Dim DBase As ClIsisDll
    
    Set DBase = New ClIsisDll
    If DBase.Initiate(path, database, database) Then
        report = ""
        result = ""
        For i = 1 To qpfts
            result = result + DBase.UsePft(mfn, "@" + pftpath + "\" + pfts(i))
        Next
        report = DBase.UsePft(mfn, "@" + DTDs(CurrDTD).ReportPFTFile)
    End If
    Set DBase = Nothing
End Sub

Private Sub OldCreateDoc(path As String, database As String, DocPath As String, DocFile As String)
    Dim mfn As Long
    Dim fn As Long
    Dim fn1 As Long
    Dim fn2 As Long
    Dim fn3 As Long
    Dim result As String
    Dim report As String
    Dim DBase As ClIsisDll
    Dim CIPFILE As String
    Dim CIPPath As String
    Dim P As Long
    Dim i As Long
    Dim ResultLen As Long
    
    Dim pfts() As String
    Dim qpfts As Long
    Dim pftpath As String
    Dim PFTFILE As String
    
    Set DBase = New ClIsisDll
    If DBase.Initiate(path, database, database) Then

      
        'PFT FILE
        fn = 1
        Open DTDs(CurrDTD).PFTFILE For Input As fn
        While Not EOF(fn)
            qpfts = qpfts + 1
            ReDim Preserve pfts(qpfts)
            Line Input #fn, pfts(qpfts)
        Wend
        Close fn
        Call SeparateFileandPath(DTDs(CurrDTD).PFTFILE, pftpath, PFTFILE)
        
        fn1 = 2
        fn2 = 3
        fn3 = 4
        
        Open DocPath + PathSep + DocFile + SGMLExt For Output As fn
        Open DocPath + PathSep + DocFile + ParserExt For Output As fn1
        Open DocPath + PathSep + DocFile + ReportExt For Output As fn2
        Open DocPath + PathSep + DocFile + ".htm" For Output As fn3
        
            
        Print #fn1, "<!DOCTYPE " + DTDs(CurrDTD).DocTypeName + " SYSTEM " + Chr(34) + DTDs(CurrDTD).DTDFile + Chr(34) + TAGC
        Print #fn3, "<html><body>"
        Print #fn, STAGO + DTDs(CurrDTD).DocTypeName + TAGC
        Print #fn1, STAGO + DTDs(CurrDTD).DocTypeName + TAGC
        Print #fn3, ConvertSGML2HTML(STAGO + DTDs(CurrDTD).DocTypeName + TAGC)
        

        ResultLen = 0
        For mfn = 1 To DBase.MfnQuantity
            report = ""
            result = ""
            
            For i = 1 To qpfts
            Debug.Print mfn, pfts(i)
                result = DBase.UsePft(mfn, "@" + pftpath + "\" + pfts(i))
                ResultLen = ResultLen + Len(result)
                If Len(result) > 0 Then
                    Print #fn, result
                    Print #fn1, result
                    Print #fn3, ConvertSGML2HTML(result)
                End If
            Next
            report = DBase.UsePft(mfn, "@" + DTDs(CurrDTD).ReportPFTFile)
            If Len(report) > 0 Then
                If ResultLen > 0 Then
                    report = "Success|" + report
                Else
                    report = "Failure|" + report
                End If
                Print #fn2, report
                ResultLen = 0
            End If
            
        Next
        Print #fn, ETAGO + DTDs(CurrDTD).DocTypeName + TAGC
        Print #fn1, ETAGO + DTDs(CurrDTD).DocTypeName + TAGC
        Print #fn3, ConvertSGML2HTML(ETAGO + DTDs(CurrDTD).DocTypeName + TAGC) + "</body></html>"
        
        Close fn, fn1, fn2, fn3
    
    End If
    Set DBase = Nothing
'    Kill Path + PathSep + database + MstExt
'    Kill Path + PathSep + database + XrfExt
'
End Sub

Private Sub CreateHTML(DocPath As String, DocFile As String)
    Dim fn As Long
    Dim fn3 As Long
    Dim SGMLContent As String
    
    
    fn = 1
    fn3 = 2
    Open DocPath + PathSep + DocFile + ".htm" For Output As fn3
    Print #fn3, "<html><body>"
    
    Open DocPath + PathSep + DocFile + ".sgml" For Input As fn
    While Not EOF(fn)
        Line Input #fn, SGMLContent
        
        Print #fn3, ConvertSGML2HTML(SGMLContent)
    Wend
    Print #fn3, "</body></html>"
    Close fn, fn3
    
End Sub

Private Function ConvertSGML2HTML(content As String) As String
    Dim P As Long
    Dim p2 As Long
    Dim aux As String
    Dim r As String
    
    aux = content
    aux = ReplaceString(aux, "&deg;", "<DEGREES>", vbBinaryCompare)
    P = InStr(aux, "<")
    While P > 0
        p2 = InStr(aux, ">")
        r = r + Mid(aux, 1, P - 1) + DTDs(CurrDTD).COLOREDTAG(Mid(aux, P, p2 - P + 1))
        aux = Mid(aux, p2 + 1)
        P = InStr(aux, "<")
    Wend
    
    Debug.Print r
    
    ConvertSGML2HTML = ReplaceString(r, Chr(13) + Chr(10), "<br>", vbTextCompare) + "<br>"
End Function

Function New_GetValidRecords(SourcePath As String, SourceDB As String, FSTPath As String, FSTFile As String, DestPath As String, DestDB As String) As Boolean
    Dim mfn As Long
    Dim Mfns() As Long
    Dim q As Long
    Dim i As Long
    Dim DB As ClIsisDll
    Dim NewDB As ClIsisDll
    Dim ret As Boolean
    Dim pii As String
    Dim aux As String
    Dim NewMfn As Long
    Dim found As Boolean
    
    Set DB = New ClIsisDll
    Call FileCopy(SourcePath + PathSep + SourceDB + ".mst", SourcePath + PathSep + FSTFile + ".mst")
    Call FileCopy(SourcePath + PathSep + SourceDB + ".xrf", SourcePath + PathSep + FSTFile + ".xrf")
    If FileExist(FSTPath, FSTFile + ".fst") Then Call FileCopy(FSTPath + PathSep + FSTFile + ".fst", SourcePath + PathSep + FSTFile + ".fst")
        
    If DB.Initiate(SourcePath, FSTFile, "Source Database") Then
        
        If DB.IfCreate(FSTFile) Then
            If DB.IfUpdate2 Then
                q = DB.DoSearch("RECORDS", Mfns)
            End If
        End If
            
        If q > 0 Then
            Set NewDB = New ClIsisDll
            If NewDB.Initiate(DestPath, DestDB, "NewDB DestDB", True) Then
                ret = True
                For i = 1 To q
                    mfn = Mfns(i)
                    NewMfn = NewDB.RecordSave(DB.RecordGet(mfn))
                    If NewMfn > 0 Then
                        aux = DB.UsePft(mfn, "@pii.pft")
                        If Len(aux) > 0 Then pii = aux
                        ret = ret And NewDB.FieldContentAdd(NewMfn, 902, pii)
                    End If
                Next
            End If
        End If
        Set NewDB = Nothing
    End If
    Set DB = Nothing
    
    New_GetValidRecords = ret
End Function

Function GetValidRecords(SourcePath As String, SourceDB As String, FSTPath As String, FSTFile As String, DestPath As String, DestDB As String) As Boolean
    Dim mfn As Long
    Dim Mfns() As Long
    Dim i As Long
    Dim DB As ClIsisDll
    Dim NewDB As ClIsisDll
    Dim ret As Boolean
    Dim pii As String
    Dim aux As String
    Dim NewMfn As Long
    Dim found As Boolean
    Dim xMfn As String
    Dim DocCount As Long
    Dim FirstMfn() As Long
    Dim LastMfn() As Long
    Dim order As String
    Dim j As Long
    
    Set DB = New ClIsisDll
    If FileExist(FSTPath, FSTFile + ".fst") Then Call FileCopy(FSTPath + PathSep + FSTFile + ".fst", SourcePath + PathSep + FSTFile + ".fst")
    If FileExist(FSTPath, FSTFile + ".pft") Then Call FileCopy(FSTPath + PathSep + FSTFile + ".pft", SourcePath + PathSep + FSTFile + ".pft")
        
    If DB.Initiate(SourcePath, SourceDB, "Source Database") Then
        
        If DB.IfCreate(SourceDB) Then
            DocCount = DB.UsePft(1, "v122")
            
            ReDim Preserve FirstMfn(DocCount)
            ReDim Preserve LastMfn(DocCount)
            
            LastMfn(DocCount) = DB.MfnQuantity
            
            For i = 1 To DocCount
                order = CStr(i)
                If Len(order) < 2 Then order = "0" + order
                
                xMfn = DB.MfnFindOne(order)
                If Len(xMfn) > 0 Then
                    FirstMfn(i) = CLng(xMfn) - 1
                    
                    
                    aux = DB.UsePft(FirstMfn(i), "v703")
                    If Len(aux) > 0 Then LastMfn(i) = FirstMfn(i) + CLng(aux) - 1
                End If
            Next
            
            Set NewDB = New ClIsisDll
            If NewDB.Initiate(DestPath, DestDB, "NewDB DestDB", True) Then
                NewMfn = NewDB.RecordSave(DB.RecordGet(1))
                ret = True
                For i = 1 To DocCount
                    For j = FirstMfn(i) To LastMfn(i)
                        xMfn = DB.UsePft(j, "@" + SourcePath + PathSep + FSTFile + ".pft")
                        If IsNumber(xMfn) Then
                            'is a valid record
                            mfn = CLng(xMfn)
                            NewMfn = NewDB.RecordSave(DB.RecordGet(mfn))
                            If NewMfn > 0 Then
                                'pii
                                aux = DB.UsePft(mfn, "@pii.pft")
                                If Len(aux) > 0 Then pii = aux
                                ret = ret And NewDB.FieldContentAdd(NewMfn, 902, pii)
                            End If
                        End If
                    Next
                Next
            End If
        End If
        Set NewDB = Nothing
    End If
    Set DB = Nothing
    
    GetValidRecords = ret
End Function
Function IssueFullPath(Siglum As String, vol As String, supplvol As String, nro As String, supplnro As String) As String
    Dim path As String
    Dim id As String
    
    id = IssueId(vol, supplvol, nro, supplnro)
    If Len(id) > 0 Then
        path = SerialDirectory + PathSep + Siglum + PathSep + id
        If Not DirExist(path, "Issue Path") Then
            path = ""
        End If
    End If
    
    IssueFullPath = path
End Function

Function IssueId(vol As String, supplvol As String, nro As String, supplnro As String) As String
    Dim id As String
    
    If Len(vol) > 0 Then id = "v" + vol
    If Len(supplvol) > 0 Then id = id + "s" + supplvol
    If Len(nro) > 0 Then id = id + "n" + nro
    If Len(supplnro) > 0 Then id = id + "s" + supplnro

    IssueId = id
End Function

Private Sub CopyFilestoBackupDirectory(path As String, database As String)
    Call FileCopy(path + PathSep + database + ".sgml", SerialDirectory + PathSep + DTDs(CurrDTD).name + PathSep + database + ".sgml")
End Sub

Function ReadPathsConfigurationFile(File As String) As ColFileInfo
    Dim fn As Long
    Dim lineread As String
    Dim Item As ClFileInfo
    Dim Key As String
    Dim path As String
    Dim CollectionPaths As ColFileInfo
    Dim req As Long
    
    fn = FreeFile
    Open File For Input As fn
        
    Set CollectionPaths = New ColFileInfo
    
    While Not EOF(fn)
        Line Input #fn, lineread
        If InStr(lineread, "=") > 0 Then
            Key = Mid(lineread, 1, InStr(lineread, "=") - 1)
            path = Mid(lineread, InStr(lineread, "=") + 1)
            req = InStr(path, ",required")
            If req > 0 Then
                path = Mid(path, 1, req - 1)
                
            End If
            Set Item = CollectionPaths.Add(Key)
            Item.Key = Key
            If InStr(path, "\") > 0 Then
                Item.path = Mid(path, 1, InStrRev(path, "\") - 1)
                Item.filename = Mid(path, InStrRev(path, "\") + 1)
            Else
                Item.path = ""
                Item.filename = path
            End If
            Item.required = (req > 0)
        End If
    Wend
    Close fn
    Set ReadPathsConfigurationFile = CollectionPaths
End Function


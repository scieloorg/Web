VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClsJournalDAO"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private isis As ClIsisdll
Const changelinetextbox = vbCrLf

Function getJournalStandardList() As MyCollection
    Dim journals As New MyCollection
    Dim journal As ClsJournal
    
    Dim i As Long
    
    For i = 1 To isis.MfnQuantity
        Set journal = New ClsJournal
        journal.ISSN = isis.FieldContentOccGet(i, 400, 1)
        journal.ShortTitle = isis.FieldContentOccGet(i, 150, 1)
        journal.JournalStandard = isis.FieldContentOccGet(i, 117, 1)
        Call journals.add(journal, journal.ISSN)
    Next
    Set getJournalStandardList = journals
End Function

Function getHistory(Mfn As Long) As ClsHistory
    Dim q As Long
    Dim occs() As String
    Dim i As Long
    Dim journalStatus As ClsJournalStatus
    Dim history As New ClsHistory
    
    
    
    q = isis.FieldContentGetAll(Mfn, 51, occs)
    For i = q To 1 Step -1
        Set journalStatus = New ClsJournalStatus
        
        journalStatus.statusDate = isis.getSubfieldContent("a", occs(i))
        journalStatus.status = isis.getSubfieldContent("b", occs(i))
        
        Call history.add(journalStatus, journalStatus.statusDate)
        
        If InStr(occs(i), "^c") > 0 Then
            Set journalStatus = New ClsJournalStatus
            journalStatus.statusDate = isis.getSubfieldContent("c", occs(i))
            journalStatus.status = isis.getSubfieldContent("d", occs(i))
            
            Call history.add(journalStatus, journalStatus.statusDate)
        End If
        
    Next
    Set getHistory = history
End Function
Function tagHistory(history As ClsHistory) As String
    Dim i As Long
    
    Dim journalStatus As ClsJournalStatus
    
    Const tag = "51"
    Dim tagged As String
    Dim Occ As String
    
    
    For i = 1 To history.count
        Set journalStatus = history.item(i)
        If Len(Occ) = 0 Then
            Occ = "<" + tag + ">^a" + journalStatus.statusDate + "^b" + journalStatus.status
        Else
            Occ = Occ + "^c" + journalStatus.statusDate + "^d" + journalStatus.status + "</" + tag + ">"
            tagged = Occ + tagged
            Occ = ""
        End If
    Next
    If Len(Occ) > 0 Then
        Occ = Occ + "</" + tag + ">"
        tagged = Occ + tagged
    End If
    
    tagHistory = tagged
End Function

Function getJournalCreativeCommons(Mfn As Long) As clsCreativeCommons
    Dim languages() As String
    Dim texts() As String
    Dim creativeCommons As New clsCreativeCommons
    
    q = isis.SubfieldContentGet(Mfn, 540, "l", languages)
    q = isis.SubfieldContentGet(Mfn, 540, "t", texts)
    
    For i = 1 To q
        Call creativeCommons.add(texts(i), languages(i))
    Next
    If q = 0 Then
        For i = 1 To IdiomsInfo.count
            Call creativeCommons.add("", IdiomsInfo(i).Code)
        Next
    End If
    Set getJournalCreativeCommons = creativeCommons
End Function
Function tagCreativeCommons(cc As clsCreativeCommons) As String
    Dim i As Long
    Const tag = "540"
    Dim tagged As String
    
    For i = 1 To cc.count
        If Len(cc.getLicenseByIndex(i).text) > 0 Then
            tagged = tagged + "<" + tag + ">^t" + cc.getLicenseByIndex(i).text + "^l" + cc.getLicenseByIndex(i).lang + "</" + tag + ">"
        End If
    Next
    
    tagCreativeCommons = tagged
End Function

Private Sub Class_Initialize()
    Set isis = New ClIsisdll
    
    With Paths("Title Database")
    If isis.Inicia(.path, .FileName, .key) Then
        If isis.IfCreate(Paths("Title X ISSN Database").FileName) Then
            
        End If
    End If
    End With
End Sub

Function Save(ByRef MfnTitle As Long, Data As String) As Boolean
    Dim OK As Boolean
    If MfnTitle = 0 Then
         MfnTitle = isis.RecordSave(Data)
         OK = (MfnTitle > 0)
    Else
        OK = isis.RecordUpdate(MfnTitle, Data)
    End If

    If OK Then
        Call isis.IfUpdate(MfnTitle, MfnTitle)
    End If
    Save = OK
End Function

Function getJournalList() As ClsJournalList
    Dim i As Long
    Dim tmp As String
    Dim j As ClsJournal
    Dim jlist As New ClsJournalList
    
    For i = 1 To isis.MfnQuantity
        tmp = isis.UsePft(i, "v100")
        If Len(tmp) > 0 Then
            Set j = New ClsJournal
            j.key = tmp
            j.Title = tmp
            Call jlist.add(j)
        End If
    Next
    Set getJournalList = jlist
End Function


Function existJournal(SerialTitle_to_find As String) As Long
    
    Dim Mfn As Long
    Dim SERIALTITLE As String
    Dim found As Boolean
    Dim i As Long
    Dim MfnCounter As Long
    Dim SerialMfns() As Long
    
    MfnCounter = isis.MfnFind(SerialTitle_to_find, SerialMfns)
    i = 0
    While (i < MfnCounter) And (Not found)
        i = i + 1
        SERIALTITLE = isis.UsePft(SerialMfns(i), "v100")
        If StrComp(SERIALTITLE, SerialTitle_to_find) = 0 Then
            Mfn = SerialMfns(i)
            found = True
        End If
    Wend
        
    If Not found Then
        Mfn = 0
        While (Mfn < isis.MfnQuantity) And (Not found)
            Mfn = Mfn + 1
            SERIALTITLE = isis.UsePft(Mfn, "v100")
            If StrComp(SERIALTITLE, SerialTitle_to_find) = 0 Then
                found = True
            End If
        Wend
    End If
    If found Then
        existJournal = Mfn
    End If
End Function

Function getFieldContentByLanguage(Mfn As Long, tag As Long, Optional language As String) As String
    getFieldContentByLanguage = isis.getFieldContentByLanguage(Mfn, tag, language)
End Function

Function getDecodedValue(Code As ColCode, Mfn As Long, tag As Long, Optional DefaultOption As String) As String
    Dim content As String
    Dim exist As Boolean
    Dim itemCode As ClCode
    
        content = isis.UsePft(Mfn, "v" + CStr(tag))
        If (Len(content) = 0) And (Len(DefaultOption) > 0) Then content = DefaultOption
        
        If Len(content) > 0 Then
            Set itemCode = New ClCode
            Set itemCode = Code(content, exist)
            If exist Then
                content = itemCode.value
            Else
                Debug.Print
            End If
        End If
    getDecodedValue = content
End Function


Function getRepetitiveFieldValue(Mfn As Long, tag As Long, sep As String) As String
     getRepetitiveFieldValue = isis.UsePft(Mfn, "(v" + CStr(tag) + "|" + sep + "|)")
End Function

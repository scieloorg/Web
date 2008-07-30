Attribute VB_Name = "ModDB"
Option Explicit



Const changelinetextbox = vbCrLf



Sub Serial_GetExistingCombo(Combo As ComboBox)
    Dim isistitle As ClIsisdll
    Dim i As Long
    Dim tmp As String
    
    Set isistitle = New ClIsisdll
    With Paths("Title Database")
    If isistitle.Inicia(.Path, .filename, .Key) Then
        Combo.Clear
        For i = 1 To isistitle.MfnQuantity
            tmp = isistitle.UsePft(i, "v100")
            If Len(tmp) > 0 Then
                Combo.AddItem tmp
            End If
        Next
    End If
    End With
End Sub

Sub Serial_GetExisting(List As ListBox)
    Dim isistitle As ClIsisdll
    Dim i As Long
    Dim tmp As String
    
    Set isistitle = New ClIsisdll
    With Paths("Title Database")
    If isistitle.Inicia(.Path, .filename, .Key) Then
        List.Clear
        For i = 1 To isistitle.MfnQuantity
            tmp = isistitle.UsePft(i, "v100")
            If Len(tmp) > 0 Then
                List.AddItem tmp
            End If
        Next
    End If
    End With
End Sub

Function Serial_CheckExisting(SerialTitle_to_find As String) As Long
    Dim isistitle As ClIsisdll
    Dim mfn As Long
    Dim SERIALTITLE As String
    Dim found As Boolean
    Dim i As Long
    Dim MfnCounter As Long
    Dim SerialMfns() As Long
    
    Set isistitle = New ClIsisdll
    With Paths("Title Database")
    If isistitle.Inicia(.Path, .filename, .Key) Then
        If isistitle.IfCreate(Paths("Title X ISSN Database").filename) Then
            MfnCounter = isistitle.MfnFind(SerialTitle_to_find, SerialMfns)
            i = 0
            While (i < MfnCounter) And (Not found)
                i = i + 1
                SERIALTITLE = isistitle.UsePft(SerialMfns(i), "v100")
                If StrComp(SERIALTITLE, SerialTitle_to_find) = 0 Then
                    mfn = SerialMfns(i)
                    found = True
                End If
            Wend
        End If
        If Not found Then
            mfn = 0
            While (mfn < isistitle.MfnQuantity) And (Not found)
                mfn = mfn + 1
                SERIALTITLE = isistitle.UsePft(mfn, "v100")
                If StrComp(SERIALTITLE, SerialTitle_to_find) = 0 Then
                    found = True
                End If
            Wend
        End If
    End If
    End With
    If found Then
        Serial_CheckExisting = mfn
    End If
End Function

Function Serial_TxtContent(mfn As Long, tag As Long, Optional language As String) As String
    Dim isistitle As ClIsisdll
    Dim Content As String
    Dim sep As String
    
    sep = "%"
    
    Set isistitle = New ClIsisdll
    With Paths("Title Database")
    If isistitle.Inicia(.Path, .filename, .Key) Then
        If Len(language) = 0 Then
            Content = isistitle.UsePft(mfn, "(v" + CStr(tag) + "+|" + sep + "|)")
        Else
            Content = isistitle.UsePft(mfn, "(if v" + CStr(tag) + "^l='" + language + "' then v" + CStr(tag) + "^* fi)")
        End If
        Content = ReplaceString(Content, sep, changelinetextbox)
    End If
    Set isistitle = Nothing
    End With
    Serial_TxtContent = Content
End Function

Function Serial_ComboDefaultValue(Code As ColCode, DefaultOption As String) As String
    Dim exist As Boolean
    Dim itemCode As ClCode
    Dim Content As String
    
    
        If Len(DefaultOption) > 0 Then
            Set itemCode = New ClCode
            Set itemCode = Code(DefaultOption, exist)
            If exist Then
                Content = itemCode.Value
            Else
            Debug.Print
            End If
        End If
    
    Serial_ComboDefaultValue = Content
End Function
Function Serial_ComboContent(Code As ColCode, mfn As Long, tag As Long, Optional DefaultOption As String) As String
    Dim isistitle As ClIsisdll
    Dim Content As String
    Dim exist As Boolean
    Dim itemCode As ClCode
    
    Set isistitle = New ClIsisdll
    With Paths("Title Database")
    If isistitle.Inicia(.Path, .filename, .Key) Then
        Content = isistitle.UsePft(mfn, "v" + CStr(tag))
        If (Len(Content) = 0) And (Len(DefaultOption) > 0) Then Content = DefaultOption
        
        If Len(Content) > 0 Then
            Set itemCode = New ClCode
            Set itemCode = Code(Content, exist)
            If exist Then
                Content = itemCode.Value
            Else
            Debug.Print
            End If
        End If
    End If
    End With
    Serial_ComboContent = Content
End Function

Function TagTxtContent(Content As String, tag As Long) As String
    Dim p2 As Long
    Dim NewContent As String
    Dim p1 As Long
    
        Content = Content + changelinetextbox
        p1 = InStr(Content, changelinetextbox)
        p2 = 1
        While p1 > 0
            NewContent = NewContent + TagContent(Mid(Content, p2, p1 - p2), tag)
            p2 = p1 + Len(changelinetextbox)
            p1 = InStr(p2 + Len(changelinetextbox), Content, changelinetextbox)
        Wend
    TagTxtContent = NewContent
End Function

Sub Serial_ListContent(List As ListBox, Code As ColCode, mfn As Long, tag As Long)
    Dim isistitle As ClIsisdll
    Dim Content As String
    Dim exist As Boolean
    Dim itemCode As ClCode
    Dim sep As String
    Dim p As Long
    Dim Item As String
    Dim i As Long
    Dim found As Boolean
    
    sep = "%"
    
    Set isistitle = New ClIsisdll
    With Paths("Title Database")
    If isistitle.Inicia(.Path, .filename, .Key) Then
        Content = isistitle.UsePft(mfn, "(v" + CStr(tag) + "|" + sep + "|)")
        'Content = ReplaceString(Content, sep, changelinetextbox)
        
        For i = 0 To List.ListCount - 1
            List.Selected(i) = False
        Next
                
        Set itemCode = New ClCode
        
        p = InStr(Content, sep)
        While p > 0
            Item = Mid(Content, 1, p - 1)
            Set itemCode = Code(Item, exist)
            If exist Then
                Item = itemCode.Value
                i = 0
                found = False
                While (i < List.ListCount) And (Not found)
                    If StrComp(Item, List.List(i), vbTextCompare) = 0 Then
                        found = True
                        List.Selected(i) = True
                    End If
                    i = i + 1
                Wend
            Else
                
            End If
            Content = Mid(Content, p + 1)
            p = InStr(Content, sep)
        Wend
    End If
    End With
End Sub

Sub Issue_ListContent(List As ListBox, Code As ColCode, mfn As Long, tag As Long)
    Dim isistitle As ClIsisdll
    Dim Content As String
    Dim exist As Boolean
    Dim itemCode As ClCode
    Dim sep As String
    Dim p As Long
    Dim Item As String
    Dim i As Long
    Dim found As Boolean
    
    sep = "%"
    
    Set isistitle = New ClIsisdll
    With Paths("Issue Database")
    If isistitle.Inicia(.Path, .filename, .Key) Then
        Content = isistitle.UsePft(mfn, "(v" + CStr(tag) + "|" + sep + "|)")
        'Content = ReplaceString(Content, sep, changelinetextbox)
        
        For i = 0 To List.ListCount - 1
            List.Selected(i) = False
        Next
                
        Set itemCode = New ClCode
        
        p = InStr(Content, sep)
        While p > 0
            Item = Mid(Content, 1, p - 1)
            Set itemCode = Code(Item, exist)
            If exist Then
                Item = itemCode.Value
                i = 0
                found = False
                While (i < List.ListCount) And (Not found)
                    If StrComp(Item, List.List(i), vbTextCompare) = 0 Then
                        found = True
                        List.Selected(i) = True
                    End If
                    i = i + 1
                Wend
            Else
                
            End If
            Content = Mid(Content, p + 1)
            p = InStr(Content, sep)
        Wend
    End If
    End With
End Sub


Function Serial_Save(MfnTitle As Long) As Long
    Dim reccontent As String
    Dim i As Long
    Dim msgwarning As String
    Dim isistitle As ClIsisdll
    Dim OK As Boolean
        
    'MousePointer = vbHourglass
    
    'Serial1.WarnMandatoryFields
    'Serial2.WarnMandatoryFields
    'Serial3.WarnMandatoryFields
    'Serial4.WarnMandatoryFields
    'Serial5.WarnMandatoryFields
    
    If Serial_ChangedContents(MfnTitle) Then
    
    reccontent = reccontent + TagTxtContent(Serial1.TxtISSN.Text, 400)
    reccontent = reccontent + TagTxtContent(Serial1.TxtSerTitle.Text, 100)
    reccontent = reccontent + TagTxtContent(Serial1.TxtSubtitle.Text, 110)
    reccontent = reccontent + TagTxtContent(Serial1.TxtShortTitle.Text, 150)
    reccontent = reccontent + TagTxtContent(Serial1.TxtISOStitle.Text, 151)
    reccontent = reccontent + TagTxtContent(Serial1.TxtSectionTitle.Text, 130)
    reccontent = reccontent + TagTxtContent(Serial1.TxtParallel.Text, 230)
    reccontent = reccontent + TagTxtContent(Serial1.TxtOthTitle.Text, 240)
    reccontent = reccontent + TagTxtContent(Serial1.TxtOldTitle.Text, 610)
    reccontent = reccontent + TagTxtContent(Serial1.TxtNewTitle.Text, 710)
    reccontent = reccontent + TagTxtContent(Serial1.TxtIsSuppl.Text, 560)
    reccontent = reccontent + TagTxtContent(Serial1.TxtHasSuppl.Text, 550)
    
    
    For i = 1 To IdiomsInfo.Count
        If Len(Serial2.TxtMission(i).Text) > 0 Then reccontent = reccontent + TagTxtContent(Serial2.TxtMission(i).Text + "^l" + IdiomsInfo(i).Code, 901)
    Next
    
    reccontent = reccontent + TagTxtContent(UCase(Serial2.TxtDescriptors.Text), 440)
    reccontent = reccontent + TagListContent(CodeStudyArea, Serial2.ListStudyArea, 441)
    
    reccontent = reccontent + TagComboContent(CodeLiteratureType, Serial2.ComboTpLit.Text, 5)
    reccontent = reccontent + TagComboContent(CodeTreatLevel, Serial2.ComboTreatLev.Text, 6)
    reccontent = reccontent + TagComboContent(CodePubLevel, Serial2.ComboPubLev.Text, 330)
        
    reccontent = reccontent + TagTxtContent(Serial3.TxtInitDate.Text, 301)
    reccontent = reccontent + TagTxtContent(Serial3.TxtInitVol.Text, 302)
    reccontent = reccontent + TagTxtContent(Serial3.TxtInitNo.Text, 303)
    reccontent = reccontent + TagTxtContent(Serial3.TxtTermDate.Text, 304)
    reccontent = reccontent + TagTxtContent(Serial3.TxtFinVol.Text, 305)
    reccontent = reccontent + TagTxtContent(Serial3.TxtFinNo.Text, 306)
        
    reccontent = reccontent + TagComboContent(CodeFrequency, Serial3.ComboFreq.Text, 380)
    reccontent = reccontent + TagComboContent(CodeStatus, Serial3.ComboPubStatus.Text, 50)
    reccontent = reccontent + TagComboContent(CodeAlphabet, Serial3.ComboAlphabet.Text, 340)
    reccontent = reccontent + TagListContent(CodeTxtLanguage, Serial3.ListTextIdiom, 350)
    reccontent = reccontent + TagListContent(CodeAbstLanguage, Serial3.ListAbstIdiom, 360)
        
    reccontent = reccontent + TagTxtContent(Serial3.TxtNationalcode.Text, 20)
    reccontent = reccontent + TagTxtContent(Serial3.TxtClassif.Text, 430)
    reccontent = reccontent + TagComboContent(CodeStandard, Serial3.ComboStandard.Text, 117)
    reccontent = reccontent + TagListContent(CodeScheme, Serial3.ListScheme, 85)
    
    reccontent = reccontent + TagTxtContent(Serial3.TxtPublisher.Text, 480)
    
    reccontent = reccontent + TagComboContent(CodeCountry, Serial3.ComboCountry.Text, 310)
    reccontent = reccontent + TagComboContent(CodeState, Serial3.ComboState.Text, 320)
    'reccontent = reccontent + TagTxtContent(Serial3.TxtPubState.Text, 320)
    
    reccontent = reccontent + TagTxtContent(Serial3.TxtPubCity.Text, 490)
        
    reccontent = reccontent + TagTxtContent(Serial4.TxtAddress.Text, 63)
    reccontent = reccontent + TagTxtContent(Serial4.TxtPhone.Text, 631)
    reccontent = reccontent + TagTxtContent(Serial4.TxtFaxNumber.Text, 632)
    reccontent = reccontent + TagTxtContent(Serial4.TxtEmail.Text, 64)
    reccontent = reccontent + TagTxtContent(Serial4.TxtCprightDate.Text, 621)
    reccontent = reccontent + TagTxtContent(Serial4.TxtCprighter.Text, 62)
    reccontent = reccontent + TagTxtContent(Serial4.TxtSponsor.Text, 140)
        
        
    reccontent = reccontent + TagTxtContent(Serial4.TxtSECS.Text, 37)
    reccontent = reccontent + TagTxtContent(Serial4.TxtMEDLINE.Text, 420)
    reccontent = reccontent + TagTxtContent(Serial4.TxtMEDLINEStitle.Text, 421)
    reccontent = reccontent + TagTxtContent(Serial4.TxtIdxRange.Text, 450)
    reccontent = reccontent + TagTxtContent(Serial4.TxtNotes.Text, 900)
    
    
    
    reccontent = reccontent + TagTxtContent(Serial5.TxtSiglum.Text, 930)
    reccontent = reccontent + TagTxtContent(Serial5.TxtPubId.Text, 68)
    reccontent = reccontent + TagTxtContent(Serial5.TxtSep.Text, 65)
    reccontent = reccontent + TagTxtContent(Serial5.TxtSiteLocation.Text, 69)
    reccontent = reccontent + TagComboContent(CodeFTP, Serial5.ComboFTP.Text, 66)
    reccontent = reccontent + TagComboContent(CodeISSNType, Serial5.ComboISSNType.Text, 35)
    reccontent = reccontent + TagComboContent(CodeUsersubscription, Serial5.ComboUserSubscription.Text, 67)
    reccontent = reccontent + TagTxtContent(Serial5.ScieloNetWrite, 691)
    reccontent = reccontent + TagTxtContent(Serial5.Text_SubmissionOnline.Text, 692)
    
    
    reccontent = reccontent + TagComboContent(CodeCCode, Serial5.ComboCCode.Text, 10)
    reccontent = reccontent + TagTxtContent(Serial5.TxtIdNumber.Text, 30)
    reccontent = reccontent + TagTxtContent(Serial5.TxtDocCreation.Text, 950)
    reccontent = reccontent + TagTxtContent(Serial5.TxtCreatDate.Text, 940)
    reccontent = reccontent + TagTxtContent(Serial5.TxtDocUpdate.Text, 951)
    
    Serial5.TxtUpdateDate.Text = GetDateISO(Date)
    reccontent = reccontent + TagTxtContent(Serial5.TxtUpdateDate.Text, 941)
    
    
    Set isistitle = New ClIsisdll
    With Paths("Title Database")
    If isistitle.Inicia(.Path, .filename, .Key) Then
        If isistitle.IfCreate(Paths("Tit_ISSN Inverted File").filename) Then
            If MfnTitle = 0 Then
                 MfnTitle = isistitle.RecordSave(reccontent)
                 OK = (MfnTitle > 0)
            Else
                OK = isistitle.RecordUpdate(MfnTitle, reccontent)
            End If
        
            If OK Then
                Call isistitle.IfUpdate(MfnTitle, MfnTitle)
            End If
        End If
    End If
    End With
    End If
    Serial_Save = MfnTitle
End Function

Function TagComboContent(Code As ColCode, Content As String, tag As Long) As String
    Dim exist As Boolean
    Dim itemCode As ClCode
        
    If Len(Content) > 0 Then
        Set itemCode = New ClCode
        Set itemCode = Code(Content, exist)
        If exist Then
            Content = itemCode.Code
        Else
        
        End If
    End If
    
    TagComboContent = TagContent(Content, tag)
End Function

Function TagListContent(Code As ColCode, List As ListBox, tag As Long) As String
    Dim exist As Boolean
    Dim itemCode As ClCode
    Dim i As Long
    Dim Content As String
    
        Set itemCode = New ClCode
        For i = 0 To List.ListCount - 1
            If List.Selected(i) Then
                Set itemCode = Code(List.List(i), exist)
                If exist Then
                    Content = Content + TagContent(itemCode.Code, tag)
                Else
                    Debug.Print
                End If
            End If
        Next
            
    TagListContent = Content
End Function

Sub FillListStudyArea(List As ListBox, Code As ColCode)
    Dim i As Long
    
    List.Clear
    For i = 1 To Code.Count
        If StrComp(Code(i).Value, Code(i).Code) = 0 Then
            List.AddItem Code(i).Value
        Else
            If (i Mod 2) <> 0 Then
                List.AddItem Code(i).Value
            End If
        End If
    Next
End Sub
Sub FillList(List As ListBox, Code As ColCode)
    Dim i As Long
    
    List.Clear
    
    For i = 1 To Code.Count
        List.AddItem Code(i).Value
    Next
End Sub

Sub FillCombo(Combo As ComboBox, Code As ColCode)
    Dim i As Long
    
    Combo.Clear
    For i = 1 To Code.Count
        Combo.AddItem Code(i).Value
    Next
End Sub

Sub UnselectList(List As ListBox)
    Dim i As Long
    
    For i = 0 To List.ListCount - 1
        List.Selected(i) = False
    Next
End Sub

Sub UnloadSerialForms()
    Dim IsNewSerial As Boolean
    IsNewSerial = Serial1.FillingNewSerial
    
    Unload Serial5
    Unload Serial4
    Unload Serial3
    Unload Serial2
    Unload Serial1
    Unload FrmInfo
    
    If IsNewSerial Then
        Call Serial_GetExisting(FrmNewSerial.ListExistingSerial)
        FrmNewSerial.Show
    Else
        FrmExistingSerial.Show
        Call Serial_GetExisting(FrmExistingSerial.ListExistingSerial)
    End If
End Sub
 
Function Serial_Close(MyMfnTitle As Long) As Integer
    Dim resp As VbMsgBoxResult
    Dim QClose As Integer
    Dim QExit As Boolean
    
    QExit = Not Serial5.WarnMandatoryFields
    
    If Not QExit Then
        If TitleCloseDenied Then
            MsgBox ConfigLabels.MsgUnabledtoClose
        Else
            resp = MsgBox(ConfigLabels.MsgExit, vbYesNo + vbDefaultButton2)
            If resp = vbYes Then
                QExit = True
            ElseIf resp = vbNo Then
                QExit = False
            End If
        End If
    End If
    
    If QExit Then
        If Serial_ChangedContents(MyMfnTitle) Then
            resp = MsgBox(ConfigLabels.MsgSaveChanges, vbYesNoCancel)
            If resp = vbCancel Then
            
            ElseIf resp = vbYes Then
                QClose = 2
            ElseIf resp = vbNo Then
                QClose = 1
            End If
        Else
            QClose = 1
        End If
    End If
    Serial_Close = QClose
End Function

Function Serial_ChangedContents(MfnTitle As Long) As Boolean
    Dim change As Boolean
    Dim i As Long
    
    change = (StrComp(Serial1.TxtISSN.Text, Serial_TxtContent(MfnTitle, 400)) <> 0)
    change = change Or (StrComp(Serial1.TxtSerTitle.Text, Serial_TxtContent(MfnTitle, 100)) <> 0)
    change = change Or (StrComp(Serial1.TxtSubtitle.Text, Serial_TxtContent(MfnTitle, 110)) <> 0)
    change = change Or (StrComp(Serial1.TxtShortTitle.Text, Serial_TxtContent(MfnTitle, 150)) <> 0)
    change = change Or (StrComp(Serial1.TxtISOStitle.Text, Serial_TxtContent(MfnTitle, 151)) <> 0)
    change = change Or (StrComp(Serial1.TxtSectionTitle.Text, Serial_TxtContent(MfnTitle, 130)) <> 0)
    change = change Or (StrComp(Serial1.TxtParallel.Text, Serial_TxtContent(MfnTitle, 230)) <> 0)
    change = change Or (StrComp(Serial1.TxtOthTitle.Text, Serial_TxtContent(MfnTitle, 240)) <> 0)
    change = change Or (StrComp(Serial1.TxtOldTitle.Text, Serial_TxtContent(MfnTitle, 610)) <> 0)
    change = change Or (StrComp(Serial1.TxtNewTitle.Text, Serial_TxtContent(MfnTitle, 710)) <> 0)
    change = change Or (StrComp(Serial1.TxtIsSuppl.Text, Serial_TxtContent(MfnTitle, 560)) <> 0)
    change = change Or (StrComp(Serial1.TxtHasSuppl.Text, Serial_TxtContent(MfnTitle, 550)) <> 0)
    
    For i = 1 To IdiomsInfo.Count
        change = change Or (StrComp(Serial2.TxtMission(i).Text, Serial_TxtContent(MfnTitle, 901, IdiomsInfo(i).Code)) <> 0)
    Next

    change = change Or (StrComp(Serial2.TxtDescriptors.Text, Serial_TxtContent(MfnTitle, 440), vbTextCompare) <> 0)
    'change = change Or (StrComp(Serial2.ListStudyArea.Text, Serial_TxtContent(MfnTitle, 441)) <> 0)
    
    change = change Or Serial_ChangedListContent(Serial2.ListStudyArea, CodeStudyArea, MfnTitle, 441)

    change = change Or (StrComp(Serial2.ComboTpLit.Text, Serial_ComboContent(CodeLiteratureType, MfnTitle, 5)) <> 0)
    change = change Or (StrComp(Serial2.ComboTreatLev.Text, Serial_ComboContent(CodeTreatLevel, MfnTitle, 6)) <> 0)
    change = change Or (StrComp(Serial2.ComboPubLev.Text, Serial_ComboContent(CodePubLevel, MfnTitle, 330)) <> 0)
    
    change = change Or (StrComp(Serial3.TxtInitVol.Text, Serial_TxtContent(MfnTitle, 302)) <> 0)
    change = change Or (StrComp(Serial3.TxtInitNo.Text, Serial_TxtContent(MfnTitle, 303)) <> 0)
    change = change Or (StrComp(Serial3.TxtTermDate.Text, Serial_TxtContent(MfnTitle, 304)) <> 0)
    change = change Or (StrComp(Serial3.TxtFinVol.Text, Serial_TxtContent(MfnTitle, 305)) <> 0)
    change = change Or (StrComp(Serial3.TxtFinNo.Text, Serial_TxtContent(MfnTitle, 306)) <> 0)
    
    change = change Or (StrComp(Serial3.ComboFreq.Text, Serial_ComboContent(CodeFrequency, MfnTitle, 380)) <> 0)
    change = change Or (StrComp(Serial3.ComboPubStatus.Text, Serial_ComboContent(CodeStatus, MfnTitle, 50)) <> 0)
    change = change Or (StrComp(Serial3.ComboAlphabet.Text, Serial_ComboContent(CodeAlphabet, MfnTitle, 340)) <> 0)
    change = change Or (StrComp(Serial3.ComboStandard.Text, Serial_ComboContent(CodeStandard, MfnTitle, 117)) <> 0)
        
    change = change Or (StrComp(Serial3.TxtNationalcode.Text, Serial_TxtContent(MfnTitle, 20)) <> 0)
    change = change Or (StrComp(Serial3.TxtClassif.Text, Serial_TxtContent(MfnTitle, 430)) <> 0)
    change = change Or (StrComp(Serial3.TxtPublisher.Text, Serial_TxtContent(MfnTitle, 480)) <> 0)
    change = change Or (StrComp(Serial3.ComboCountry.Text, Serial_ComboContent(CodeCountry, MfnTitle, 310)) <> 0)
    change = change Or (StrComp(Serial3.ComboState.Text, Serial_ComboContent(CodeState, MfnTitle, 320)) <> 0)
    'change = change Or (StrComp(Serial3.TxtPubState.Text, Serial_TxtContent(MfnTitle, 320)) <> 0)
    change = change Or (StrComp(Serial3.TxtPubCity.Text, Serial_TxtContent(MfnTitle, 490)) <> 0)

    change = change Or (StrComp(Serial4.TxtAddress.Text, Serial_TxtContent(MfnTitle, 63)) <> 0)
    change = change Or (StrComp(Serial4.TxtPhone.Text, Serial_TxtContent(MfnTitle, 631)) <> 0)
    change = change Or (StrComp(Serial4.TxtFaxNumber.Text, Serial_TxtContent(MfnTitle, 632)) <> 0)
    change = change Or (StrComp(Serial4.TxtEmail.Text, Serial_TxtContent(MfnTitle, 64)) <> 0)
    change = change Or (StrComp(Serial4.TxtCprightDate.Text, Serial_TxtContent(MfnTitle, 621)) <> 0)
    change = change Or (StrComp(Serial4.TxtCprighter.Text, Serial_TxtContent(MfnTitle, 62)) <> 0)
    change = change Or (StrComp(Serial4.TxtSponsor.Text, Serial_TxtContent(MfnTitle, 140)) <> 0)
    change = change Or (StrComp(Serial4.TxtSECS.Text, Serial_TxtContent(MfnTitle, 37)) <> 0)
    change = change Or (StrComp(Serial4.TxtMEDLINE.Text, Serial_TxtContent(MfnTitle, 420)) <> 0)
    change = change Or (StrComp(Serial4.TxtMEDLINEStitle.Text, Serial_TxtContent(MfnTitle, 421)) <> 0)
    change = change Or (StrComp(Serial4.TxtIdxRange.Text, Serial_TxtContent(MfnTitle, 450)) <> 0)
    change = change Or (StrComp(Serial4.TxtNotes.Text, Serial_TxtContent(MfnTitle, 900)) <> 0)
    
    change = change Or (StrComp(Serial5.TxtSiglum.Text, Serial_TxtContent(MfnTitle, 930)) <> 0)
    change = change Or (StrComp(Serial5.TxtPubId.Text, Serial_TxtContent(MfnTitle, 68)) <> 0)
    change = change Or (StrComp(Serial5.TxtSep.Text, Serial_TxtContent(MfnTitle, 65)) <> 0)
    change = change Or (StrComp(Serial5.TxtSiteLocation.Text, Serial_TxtContent(MfnTitle, 69)) <> 0)
    change = change Or (StrComp(Serial5.ComboFTP.Text, Serial_ComboContent(CodeFTP, MfnTitle, 66)) <> 0)
    change = change Or (StrComp(Serial5.ComboISSNType.Text, Serial_ComboContent(CodeISSNType, MfnTitle, 35)) <> 0)
    change = change Or (StrComp(Serial5.ComboUserSubscription.Text, Serial_ComboContent(CodeUsersubscription, MfnTitle, 67)) <> 0)
    change = change Or (StrComp(Serial5.Text_SubmissionOnline.Text, Serial_TxtContent(MfnTitle, 692)) <> 0)
    
    change = change Or (StrComp(Serial5.ScieloNetWrite, Serial_TxtContent(MfnTitle, 691)) <> 0)
    change = change Or (StrComp(Serial5.ComboCCode.Text, Serial_ComboContent(CodeCCode, MfnTitle, 10)) <> 0)
    change = change Or (StrComp(Serial5.TxtIdNumber.Text, Serial_TxtContent(MfnTitle, 30)) <> 0)
    'change = change Or (StrComp(Serial5.TxtDocCreation.Text, Serial_TxtContent(MfnTitle, 950)) <> 0)
    'change = change Or (StrComp(Serial5.TxtCreatDate.Text, Serial_TxtContent(MfnTitle, 940)) <> 0)
    change = change Or (StrComp(Serial5.TxtDocUpdate.Text, Serial_TxtContent(MfnTitle, 951)) <> 0)
    'change = change Or (StrComp(Serial5.TxtUpdateDate.Text, Serial_TxtContent(MfnTitle, 941)) <> 0)

    change = change Or Serial_ChangedListContent(Serial3.ListScheme, CodeScheme, MfnTitle, 85)
    change = change Or Serial_ChangedListContent(Serial3.ListTextIdiom, CodeTxtLanguage, MfnTitle, 350)
    change = change Or Serial_ChangedListContent(Serial3.ListAbstIdiom, CodeAbstLanguage, MfnTitle, 360)
    Serial_ChangedContents = change
End Function

Function Serial_ChangedListContent(List As ListBox, Code As ColCode, MfnTitle As Long, tag As Long) As Boolean
    Dim isistitle As ClIsisdll
    Dim Content As String
    Dim exist As Boolean
    Dim changed As Long
    Dim itemCode As ClCode
    Dim sep As String
    Dim p As Long
    Dim Item As String
    Dim i As Long
    Dim values As String
    
    sep = "%"
    
    Set isistitle = New ClIsisdll
    With Paths("Title Database")
    If isistitle.Inicia(.Path, .filename, .Key) Then
        Content = isistitle.UsePft(MfnTitle, "(v" + CStr(tag) + "|" + sep + "|)")
        
        Set itemCode = New ClCode
        p = InStr(Content, sep)
        While p > 0
            Item = Mid(Content, 1, p - 1)
            Set itemCode = Code(Item, exist)
            If exist Then values = values + itemCode.Value + sep
            Content = Mid(Content, p + 1)
            p = InStr(Content, sep)
        Wend
        values = sep + values
        
        For i = 0 To List.ListCount - 1
            If List.Selected(i) Then
                'esta selecionado mas nao esta na base
                If InStr(values, sep + List.List(i) + sep) = 0 Then
                    changed = changed + 1
                End If
            Else
                'nao esta selecionado mas esta na base
                If InStr(values, sep + List.List(i) + sep) > 0 Then
                    changed = changed + 1
                End If
            End If
        Next
        
    End If
    Serial_ChangedListContent = (changed > 0)
    End With
End Function

Sub CancelFilling()
    Dim resp As VbMsgBoxResult
    
    resp = MsgBox(ConfigLabels.MsgExit, vbYesNo)
    If resp = vbYes Then
        UnloadSerialForms
    ElseIf resp = vbNo Then
    
    End If
End Sub

Sub FormQueryUnload(Cancel As Integer, UnloadMode As Integer)

    If UnloadMode = vbFormControlMenu Then
        Cancel = 1
        MsgBox ConfigLabels.MsgClosebyCancelorClose
    End If
End Sub

Function Serial_Remove(Mfns() As Long, q As Long) As Boolean
    Dim isistitle As ClIsisdll
    Dim isistitle2 As ClIsisdll
    Dim i As Long
    Dim t As Boolean
    
    If q > 0 Then
        With Paths("Title Database")
        Call FileCopy(.Path + "\" + .filename + ".mst", .Path + "\tmp" + .filename + ".mst")
        Call FileCopy(.Path + "\" + .filename + ".xrf", .Path + "\tmp" + .filename + ".xrf")
        Call FileCopy(.Path + "\" + Paths("Tit_ISSN Inverted File").filename + ".fst", .Path + "\tmp" + .filename + ".fst")
        
        Kill .Path + "\" + .filename + ".*"
        Kill .Path + "\" + Paths("Tit_ISSN Inverted File").filename + ".*"
        
        Call FileCopy(.Path + "\tmp" + .filename + ".fst", .Path + "\" + Paths("Tit_ISSN Inverted File").filename + ".fst")
        
        
        Set isistitle = New ClIsisdll
        Set isistitle2 = New ClIsisdll
        If isistitle2.Inicia(.Path, "tmp" + .filename, .Key) Then
            If isistitle.Inicia(.Path, .filename, .Key) Then
                If isistitle.IfCreate(Paths("Tit_ISSN Inverted File").filename) Then
                    For i = 1 To q
                        If isistitle.RecordSave(isistitle2.RecordGet(Mfns(i))) Then
                            t = isistitle.IfUpdate(i, i)
                        End If
                    Next
                End If
            End If
        End If
        End With
    End If
    Serial_Remove = t
    Set isistitle = Nothing
    Set isistitle2 = Nothing
End Function

Function Section_CheckExisting(SerialTitle_to_find As String, ISSN As String, PUBID As String) As Long
    Dim isisSection As ClIsisdll
    Dim mfn As Long
    Dim SERIALTITLE As String
    Dim SerialISSN As String
    Dim found As Boolean
    Dim i As Long
    Dim MfnCounter As Long
    Dim SerialMfns() As Long
    
    
    Set isisSection = New ClIsisdll
    With Paths("Section Database")
    If isisSection.Inicia(.Path, .filename, .Key) Then
        If isisSection.IfCreate(.filename) Then
            'procura pela chave=titulo e pelo campo=título
            MfnCounter = isisSection.MfnFind(SerialTitle_to_find, SerialMfns)
            i = 0
            While (i < MfnCounter) And (Not found)
                i = i + 1
                SERIALTITLE = isisSection.UsePft(SerialMfns(i), "v100")
                If StrComp(SERIALTITLE, SerialTitle_to_find) = 0 Then
                    mfn = SerialMfns(i)
                    found = True
                End If
            Wend
            
            'procura pela chave=ISSN
            If Not found Then
                MfnCounter = isisSection.MfnFind(ISSN, SerialMfns)
                i = 0
                While (i < MfnCounter) And (Not found)
                    i = i + 1
                    'procura campo=title
                    SERIALTITLE = isisSection.UsePft(SerialMfns(i), "v100")
                    If StrComp(SERIALTITLE, SerialTitle_to_find) = 0 Then
                        found = True
                        mfn = SerialMfns(i)
                    Else
                        'procura campo=issn
                        SerialISSN = isisSection.UsePft(SerialMfns(i), "v35")
                        If StrComp(SerialISSN, ISSN) = 0 Then
                            found = True
                            mfn = SerialMfns(i)
                        End If
                    End If
                Wend
            End If
            
        End If
        If Not found Then
            mfn = 0
            While (mfn < isisSection.MfnQuantity) And (Not found)
                mfn = mfn + 1
                SERIALTITLE = isisSection.UsePft(mfn, "v930")
                If StrComp(SERIALTITLE, PUBID) = 0 Then
                    found = True
                End If
            Wend
        End If
    End If
    End With
    If found Then
        Section_CheckExisting = mfn
    End If
End Function

Function Issue_ComboContent(Code As ColCode, mfn As Long, tag As Long) As String
    Dim isistitle As ClIsisdll
    Dim Content As String
    Dim exist As Boolean
    Dim itemCode As ClCode
    
    Set isistitle = New ClIsisdll
    With Paths("Issue Database")
    If isistitle.Inicia(.Path, .filename, .Key) Then
        Content = isistitle.UsePft(mfn, "v" + CStr(tag))
        If Len(Content) > 0 Then
            Set itemCode = New ClCode
            Set itemCode = Code(Content, exist)
            If exist Then
                Content = itemCode.Value
            Else
            Debug.Print
            End If
        End If
    End If
    End With
    Issue_ComboContent = Content
End Function

Function Issue_TxtContent(mfn As Long, tag As Long, Optional subf As String, Optional language As String) As String
    Dim isisIssue As ClIsisdll
    Dim Content As String
    Dim sep As String
    
    sep = "%"
    
    Set isisIssue = New ClIsisdll
    With Paths("Issue Database")
    If isisIssue.Inicia(.Path, .filename, .Key) Then
        If Len(language) = 0 Then
            Content = isisIssue.UsePft(mfn, "(v" + CStr(tag) + subf + "+|" + sep + "|)")
        Else
            Content = isisIssue.UsePft(mfn, "(if v" + CStr(tag) + "^l='" + language + "' then v" + CStr(tag) + subf + " fi)")
        End If
        Content = ReplaceString(Content, sep, changelinetextbox)
    End If
    Set isisIssue = Nothing
    End With
    Issue_TxtContent = Content
End Function

Function Section_Header(mfn As Long, language As String) As String
    Dim isisSection As ClIsisdll
    Dim Content As String
    
    Set isisSection = New ClIsisdll
    With Paths("Section Database")
    If isisSection.Inicia(.Path, .filename, .Key) Then
        Content = isisSection.UsePft(mfn, "(if v48^l='" + language + "' then v48^h fi)")
    End If
    End With
    Set isisSection = Nothing
    Section_Header = Content
End Function

Function Issue_Header(mfn As Long, language As String) As String
    Dim isisIssue As ClIsisdll
    Dim Content As String
    
    Set isisIssue = New ClIsisdll
    With Paths("Issue Database")
    If isisIssue.Inicia(.Path, .filename, .Key) Then
        Content = isisIssue.UsePft(mfn, "(if v48^l='" + language + "' then v48^h fi)")
    End If
    End With
    Set isisIssue = Nothing
    Issue_Header = Content
End Function

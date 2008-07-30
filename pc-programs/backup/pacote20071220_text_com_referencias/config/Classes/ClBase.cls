VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClBase"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Option Explicit

Const changelinetextbox = vbCrLf

Public

Sub GetExistingSerials2(Combo As ComboBox)
    Dim isistitle As ClIsisDll
    Dim i As Long
    Dim tmp As String
    
    Set isistitle = New ClIsisDll
    With FormMenuPrin.DirStruct.Nodes("Title Database")
    If isistitle.Inicia(.Parent.FullPath, .Text, .Key) Then
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

Sub GetExistingSerials(List As ListBox)
    Dim isistitle As ClIsisDll
    Dim i As Long
    Dim tmp As String
    
    Set isistitle = New ClIsisDll
    With FormMenuPrin.DirStruct.Nodes("Title Database")
    If isistitle.Inicia(.Parent.FullPath, .Text, .Key) Then
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



Function CheckExistingSerial(SerialTitle_to_find As String) As Long
    Dim isistitle As ClIsisDll
    Dim Mfn As Long
    Dim SerialTitle As String
    Dim found As Boolean
    
    Set isistitle = New ClIsisDll
    With FormMenuPrin.DirStruct.Nodes("Title Database")
    If isistitle.Inicia(.Parent.FullPath, .Text, .Key) Then
        While (Mfn < isistitle.MfnQuantity) And (Not found)
            Mfn = Mfn + 1
            SerialTitle = isistitle.UsePft(Mfn, "v100")
            If StrComp(SerialTitle, SerialTitle_to_find) = 0 Then
                found = True
            End If
        Wend
        If found Then
            CheckExistingSerial = Mfn
        End If
    End If
    End With
End Function
Function GetTxtContent(DATABASE As String, Mfn As Long, tag As Long, Optional language As String) As String
    Dim isistitle As ClIsisDll
    Dim Content As String
    Dim sep As String
    
    sep = "%"
    
    Set isistitle = New ClIsisDll
    With FormMenuPrin.DirStruct.Nodes(DATABASE)
    If isistitle.Inicia(.Parent.FullPath, .Text, .Key) Then
        If Len(language) = 0 Then
            Content = isistitle.UsePft(Mfn, "(v" + CStr(tag) + "+|" + sep + "|)")
        Else
            Content = isistitle.UsePft(Mfn, "(if v" + CStr(tag) + "^l='" + language + "' then v" + CStr(tag) + "^* fi)")
        End If
        Content = ReplaceString(Content, sep, changelinetextbox)
    End If
    Set isistitle = Nothing
    End With
    GetTxtContent = Content
End Function

Function GetComboContent(Code As ColCode, Mfn As Long, tag As Long) As String
    Dim isistitle As ClIsisDll
    Dim Content As String
    Dim exist As Boolean
    Dim itemCode As ClCode
    
    Set isistitle = New ClIsisDll
    With FormMenuPrin.DirStruct.Nodes("Title Database")
    If isistitle.Inicia(.Parent.FullPath, .Text, .Key) Then
        Content = isistitle.UsePft(Mfn, "v" + CStr(tag))
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
    GetComboContent = Content
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

Sub GetListContent(List As ListBox, Code As ColCode, Mfn As Long, tag As Long)
    Dim isistitle As ClIsisDll
    Dim Content As String
    Dim exist As Boolean
    Dim itemCode As ClCode
    Dim sep As String
    Dim p As Long
    Dim Item As String
    Dim i As Long
    Dim found As Boolean
    
    sep = "%"
    
    Set isistitle = New ClIsisDll
    With FormMenuPrin.DirStruct.Nodes("Title Database")
    If isistitle.Inicia(.Parent.FullPath, .Text, .Key) Then
        Content = isistitle.UsePft(Mfn, "(v" + CStr(tag) + "|" + sep + "|)")
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
            Debug.Print
            End If
            Content = Mid(Content, p + 1)
            p = InStr(Content, sep)
        Wend
    End If
    End With
End Sub


Sub SaveTitle(MfnTitle As Long)
    Dim reccontent As String
    Dim i As Long
    Dim msgwarning As String
    Dim isistitle As ClIsisDll
    Dim ok As Boolean
    
    'MousePointer = vbHourglass
    
    Serial1.WarnMandatoryFields
    Serial2.WarnMandatoryFields
    Serial3.WarnMandatoryFields
    Serial4.WarnMandatoryFields
    Serial5.WarnMandatoryFields
    
    
    reccontent = reccontent + TagTxtContent(Serial1.TxtIssn.Text, 400)
    reccontent = reccontent + TagTxtContent(Serial1.TxtSerTitle.Text, 100)
    reccontent = reccontent + TagTxtContent(Serial1.TxtSubtitle.Text, 110)
    reccontent = reccontent + TagTxtContent(Serial1.TxtShortTitle.Text, 150)
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
    
    reccontent = reccontent + TagTxtContent(Serial2.TxtDescriptors.Text, 440)
    reccontent = reccontent + TagTxtContent(Serial2.TxtStudyArea.Text, 441)
    
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
    reccontent = reccontent + TagTxtContent(Serial3.TxtPublisher.Text, 480)
    
    reccontent = reccontent + TagComboContent(CodeCountry, Serial3.ComboCountry.Text, 310)
    
    reccontent = reccontent + TagTxtContent(Serial3.TxtPubState.Text, 320)
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
        
    reccontent = reccontent + TagTxtContent(Serial5.TxtNotes.Text, 900)
    reccontent = reccontent + TagTxtContent(Serial5.TxtSiglum.Text, 930)
    reccontent = reccontent + TagTxtContent(Serial5.TxtPubId.Text, 68)
    reccontent = reccontent + TagTxtContent(Serial5.TxtSep.Text, 65)
    reccontent = reccontent + TagTxtContent(Serial5.TxtSiteLocation.Text, 69)
    reccontent = reccontent + TagComboContent(CodeFTP, Serial5.ComboFTP.Text, 66)
    reccontent = reccontent + TagComboContent(CodeUsersubscription, Serial5.ComboUserSubscription.Text, 67)
    reccontent = reccontent + TagComboContent(CodeCCode, Serial5.ComboCCode.Text, 10)
    reccontent = reccontent + TagTxtContent(Serial5.TxtIdNumber.Text, 30)
    reccontent = reccontent + TagTxtContent(Serial5.TxtDocCreation.Text, 950)
    reccontent = reccontent + TagTxtContent(Serial5.TxtCreatDate.Text, 940)
    reccontent = reccontent + TagTxtContent(Serial5.TxtDocUpdate.Text, 951)
    reccontent = reccontent + TagTxtContent(Serial5.TxtUpdateDate.Text, 941)
    
    
    Set isistitle = New ClIsisDll
    With FormMenuPrin.DirStruct.Nodes("Title Database")
    If isistitle.Inicia(.Parent.FullPath, .Text, .Key) Then
        If MfnTitle = 0 Then
             MfnTitle = isistitle.RecordSave(reccontent)
             ok = (MfnTitle > 0)
        Else
            ok = isistitle.RecordUpdate(MfnTitle, reccontent)
        End If
        
        If ok Then
            Call isistitle.IfUpdate(MfnTitle, MfnTitle)
        End If
    End If
    End With
'    SetContent = ok
    
    'MousePointer = vbArrow
End Sub

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

Sub FillList(List As ListBox, Code As ColCode)
    Dim i As Long
    List.Clear
    
    For i = 1 To Code.Count Step 2
        List.AddItem Code(i).Value
    Next
End Sub

Sub FillCombo(Combo As ComboBox, Code As ColCode)
    Dim i As Long
    
    Combo.Clear
    For i = 1 To Code.Count Step 2
        Combo.AddItem Code(i).Value
    Next
End Sub

Sub UnselectList(List As ListBox, Code As ColCode)
    Dim i As Long
    
    For i = 0 To List.ListCount - 1
        List.AddItem List.Selected(i)
    Next
End Sub

Sub UnloadSerialForms()
    Unload Serial5
    Unload Serial4
    Unload Serial3
    Unload Serial2
    Unload Serial1
    Unload FrmInfo
End Sub

Function MandatoryFields(Content As String, label As String) As String
    If Len(Content) = 0 Then
        MandatoryFields = label + " - " + ConfigLabels.MsgMandatoryContent + vbCrLf
    End If
End Function

Function ChangedContents(MfnTitle As Long) As Boolean
    Dim change As Boolean
    Dim i As Long
    
    change = (StrComp(Serial1.TxtIssn.Text, GetTxtContent(MfnTitle, 400)) <> 0)
    change = change Or (StrComp(Serial1.TxtSubtitle.Text, GetTxtContent(MfnTitle, 110)) <> 0)
    change = change Or (StrComp(Serial1.TxtShortTitle.Text, GetTxtContent(MfnTitle, 150)) <> 0)
    change = change Or (StrComp(Serial1.TxtSectionTitle.Text, GetTxtContent(MfnTitle, 130)) <> 0)
    change = change Or (StrComp(Serial1.TxtParallel.Text, GetTxtContent(MfnTitle, 230)) <> 0)
    change = change Or (StrComp(Serial1.TxtOthTitle.Text, GetTxtContent(MfnTitle, 240)) <> 0)
    change = change Or (StrComp(Serial1.TxtOldTitle.Text, GetTxtContent(MfnTitle, 610)) <> 0)
    change = change Or (StrComp(Serial1.TxtNewTitle.Text, GetTxtContent(MfnTitle, 710)) <> 0)
    change = change Or (StrComp(Serial1.TxtIsSuppl.Text, GetTxtContent(MfnTitle, 560)) <> 0)
    change = change Or (StrComp(Serial1.TxtHasSuppl.Text, GetTxtContent(MfnTitle, 550)) <> 0)
    
    For i = 1 To IdiomsInfo.Count
        change = change Or (StrComp(Serial2.TxtMission(i).Text, GetTxtContent(MfnTitle, 901, IdiomsInfo(i).Code)) <> 0)
    Next

    change = change Or (StrComp(Serial2.TxtDescriptors.Text, GetTxtContent(MfnTitle, 440)) <> 0)
    change = change Or (StrComp(Serial2.TxtStudyArea.Text, GetTxtContent(MfnTitle, 441)) <> 0)
    change = change Or (StrComp(Serial2.ComboTpLit.Text, GetComboContent(CodeLiteratureType, MfnTitle, 5)) <> 0)
    change = change Or (StrComp(Serial2.ComboTreatLev.Text, GetComboContent(CodeTreatLevel, MfnTitle, 6)) <> 0)
    change = change Or (StrComp(Serial2.ComboPubLev.Text, GetComboContent(CodePubLevel, MfnTitle, 330)) <> 0)
    
    change = change Or (StrComp(Serial3.TxtInitVol.Text, GetTxtContent(MfnTitle, 302)) <> 0)
    change = change Or (StrComp(Serial3.TxtInitNo.Text, GetTxtContent(MfnTitle, 303)) <> 0)
    change = change Or (StrComp(Serial3.TxtTermDate.Text, GetTxtContent(MfnTitle, 304)) <> 0)
    change = change Or (StrComp(Serial3.TxtFinVol.Text, GetTxtContent(MfnTitle, 305)) <> 0)
    change = change Or (StrComp(Serial3.TxtFinNo.Text, GetTxtContent(MfnTitle, 306)) <> 0)
    
    change = change Or (StrComp(Serial3.ComboFreq.Text, GetComboContent(CodeFrequency, MfnTitle, 380)) <> 0)
    change = change Or (StrComp(Serial3.ComboPubStatus.Text, GetComboContent(CodeStatus, MfnTitle, 50)) <> 0)
    change = change Or (StrComp(Serial3.ComboAlphabet.Text, GetComboContent(CodeAlphabet, MfnTitle, 340)) <> 0)
        
    change = change Or (StrComp(Serial3.TxtNationalcode.Text, GetTxtContent(MfnTitle, 20)) <> 0)
    change = change Or (StrComp(Serial3.TxtClassif.Text, GetTxtContent(MfnTitle, 430)) <> 0)
    change = change Or (StrComp(Serial3.TxtPublisher.Text, GetTxtContent(MfnTitle, 480)) <> 0)
    change = change Or (StrComp(Serial3.ComboCountry.Text, GetComboContent(CodeCountry, MfnTitle, 310)) <> 0)
    change = change Or (StrComp(Serial3.TxtPubState.Text, GetTxtContent(MfnTitle, 320)) <> 0)
    change = change Or (StrComp(Serial3.TxtPubCity.Text, GetTxtContent(MfnTitle, 490)) <> 0)

    change = change Or (StrComp(Serial4.TxtAddress.Text, GetTxtContent(MfnTitle, 63)) <> 0)
    change = change Or (StrComp(Serial4.TxtPhone.Text, GetTxtContent(MfnTitle, 631)) <> 0)
    change = change Or (StrComp(Serial4.TxtFaxNumber.Text, GetTxtContent(MfnTitle, 632)) <> 0)
    change = change Or (StrComp(Serial4.TxtEmail.Text, GetTxtContent(MfnTitle, 64)) <> 0)
    change = change Or (StrComp(Serial4.TxtCprightDate.Text, GetTxtContent(MfnTitle, 621)) <> 0)
    change = change Or (StrComp(Serial4.TxtCprighter.Text, GetTxtContent(MfnTitle, 62)) <> 0)
    change = change Or (StrComp(Serial4.TxtSponsor.Text, GetTxtContent(MfnTitle, 140)) <> 0)
    change = change Or (StrComp(Serial4.TxtSECS.Text, GetTxtContent(MfnTitle, 37)) <> 0)
    change = change Or (StrComp(Serial4.TxtMEDLINE.Text, GetTxtContent(MfnTitle, 420)) <> 0)
    change = change Or (StrComp(Serial4.TxtMEDLINEStitle.Text, GetTxtContent(MfnTitle, 421)) <> 0)
    change = change Or (StrComp(Serial4.TxtIdxRange.Text, GetTxtContent(MfnTitle, 450)) <> 0)

    change = change Or (StrComp(Serial5.TxtNotes.Text, GetTxtContent(MfnTitle, 900)) <> 0)
    change = change Or (StrComp(Serial5.TxtSiglum.Text, GetTxtContent(MfnTitle, 930)) <> 0)
    change = change Or (StrComp(Serial5.TxtPubId.Text, GetTxtContent(MfnTitle, 68)) <> 0)
    change = change Or (StrComp(Serial5.TxtSep.Text, GetTxtContent(MfnTitle, 65)) <> 0)
    change = change Or (StrComp(Serial5.TxtSiteLocation.Text, GetTxtContent(MfnTitle, 69)) <> 0)
    change = change Or (StrComp(Serial5.ComboFTP.Text, GetComboContent(CodeFTP, MfnTitle, 66)) <> 0)
    change = change Or (StrComp(Serial5.ComboUserSubscription.Text, GetComboContent(CodeUsersubscription, MfnTitle, 67)) <> 0)
    change = change Or (StrComp(Serial5.ComboCCode.Text, GetComboContent(CodeCCode, MfnTitle, 10)) <> 0)
    change = change Or (StrComp(Serial5.TxtIdNumber.Text, GetTxtContent(MfnTitle, 30)) <> 0)
    change = change Or (StrComp(Serial5.TxtDocCreation.Text, GetTxtContent(MfnTitle, 950)) <> 0)
    change = change Or (StrComp(Serial5.TxtCreatDate.Text, GetTxtContent(MfnTitle, 940)) <> 0)
    change = change Or (StrComp(Serial5.TxtDocUpdate.Text, GetTxtContent(MfnTitle, 951)) <> 0)
    change = change Or (StrComp(Serial5.TxtUpdateDate.Text, GetTxtContent(MfnTitle, 941)) <> 0)

    
    change = change Or ChangedListContent(Serial3.ListTextIdiom, CodeTxtLanguage, MfnTitle, 350)
    change = change Or ChangedListContent(Serial3.ListAbstIdiom, CodeAbstLanguage, MfnTitle, 360)
    ChangedContents = change
End Function

Function ChangedListContent(List As ListBox, Code As ColCode, MfnTitle As Long, tag As Long) As Boolean
    Dim isistitle As ClIsisDll
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
    
    Set isistitle = New ClIsisDll
    With FormMenuPrin.DirStruct.Nodes("Title Database")
    If isistitle.Inicia(.Parent.FullPath, .Text, .Key) Then
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
    ChangedListContent = (changed > 0)
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

Function RemoveSerial(Mfns() As Long, q As Long) As Boolean
    Dim isistitle As ClIsisDll
    Dim isistitle2 As ClIsisDll
    Dim i As Long
    Dim t As Boolean
    
    If q > 0 Then
        With FormMenuPrin.DirStruct.Nodes("Title Database")
        Call FileCopy(.Parent.FullPath + "\" + .Text + ".mst", .Parent.FullPath + "\tmp" + .Text + ".mst")
        Call FileCopy(.Parent.FullPath + "\" + .Text + ".xrf", .Parent.FullPath + "\tmp" + .Text + ".xrf")
                
        Set isistitle = New ClIsisDll
        Set isistitle2 = New ClIsisDll
        If isistitle2.Inicia(.Parent.FullPath, "tmp" + .Text, .Key) Then
            If isistitle.Inicia(.Parent.FullPath, .Text, .Key, True) Then
                If isistitle.IfCreate(FormMenuPrin.DirStruct.Nodes("Tit_ISSN Inverted File").Text) Then
                    For i = 1 To q
                        If isistitle.RecordSave(isistitle2.RecordGet(Mfns(i))) Then
                           
                        End If
                    Next
                    t = isistitle.IfUpdate(i, q)
                End If
            End If
        End If
        End With
    End If
    RemoveSerial = t
End Function

Function CheckExistingSection(Siglum As String) As Long
    Dim isisSection As ClIsisDll
    Dim Mfn As Long
    Dim SerialTitle As String
    Dim found As Boolean
    
    Set isisSection = New ClIsisDll
    With FormMenuPrin.DirStruct.Nodes("Section Database")
    If isisSection.Inicia(.Parent.FullPath, .Text, .Key) Then
        While (Mfn < isisSection.MfnQuantity) And (Not found)
            Mfn = Mfn + 1
            SerialTitle = isisSection.UsePft(Mfn, "v930")
            If StrComp(SerialTitle, Siglum) = 0 Then
                found = True
            End If
        Wend
        If found Then
            CheckExistingSection = Mfn
        End If
    End If
    End With
End Function



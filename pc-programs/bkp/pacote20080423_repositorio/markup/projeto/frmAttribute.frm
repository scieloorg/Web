VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmAttribute 
   Caption         =   "Insert Attribute"
   ClientHeight    =   4125
   ClientLeft      =   45
   ClientTop       =   345
   ClientWidth     =   5445
   OleObjectBlob   =   "frmAttribute.frx":0000
End
Attribute VB_Name = "frmAttribute"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Public flagOK As Boolean
Public flagChange As Boolean
Public flagConv As Boolean

Private mErr As New clsErrList

Const errIDObj As String = "002"
Const FormHeightlabel3 = 186
Const FormHeightlabel4 = 205
Const FormHeightlabel5 = 225

Sub SetFormHeight(i As Integer)
    If i < 4 Then
        frmAttribute.Height = FormHeightlabel3
    ElseIf i = 4 Then
        frmAttribute.Height = FormHeightlabel4
    ElseIf i = 5 Then
        frmAttribute.Height = FormHeightlabel5
    End If
End Sub

Property Get ObjLabel(i As Integer) As label
    Dim l As label
    
    Select Case i
    Case 1
        Set l = frmAttribute.lb_Attrib1
    Case 2
        Set l = frmAttribute.lb_Attrib2
    Case 3
        Set l = frmAttribute.lb_Attrib3
    Case 4
        Set l = frmAttribute.lb_Attrib4
    Case 5
        Set l = frmAttribute.lb_Attrib5
    End Select
    Set ObjLabel = l
End Property

Property Get ObjText(i As Integer) As TextBox
    Dim t As TextBox
    
    Select Case i
    Case 1
        Set t = frmAttribute.TextBox_attrib1
    Case 2
        Set t = frmAttribute.TextBox_attrib2
    Case 3
        Set t = frmAttribute.TextBox_attrib3
    Case 4
        Set t = frmAttribute.TextBox_attrib4
    Case 5
        Set t = frmAttribute.TextBox_attrib5
    End Select
    Set ObjText = t
End Property

Property Get ObjCombo(i As Integer) As ComboBox
    Dim l As ComboBox
    
    Select Case i
    Case 1
        Set l = frmAttribute.ComboBox_attrib1
    Case 2
        Set l = frmAttribute.ComboBox_attrib2
    Case 3
        Set l = frmAttribute.ComboBox_attrib3
    Case 4
        Set l = frmAttribute.ComboBox_attrib4
    Case 5
        Set l = frmAttribute.ComboBox_attrib5
    End Select
    Set ObjCombo = l
End Property



Private Sub CommandButton_cancel_Click()
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo ERRLOG
  
  frmAttribute.flagOK = False
  frmAttribute.Hide
  Unload Me
  Exit Sub
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub

Private Sub CommandButton_OK_Click()
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo ERRLOG
  
  If VerifyFrmAttribute = True Then
    frmAttribute.flagOK = True
    frmAttribute.Hide
    'Unload Me

  End If
  Exit Sub
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub


Private Sub UserForm_Terminate()
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo ERRLOG
  
  
  CommandButton_cancel_Click
  Exit Sub
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub

Public Function VerifyFrmAttribute() As Boolean
  Dim Conf As New clsConfig
  Dim i As Integer
  Const errIDMet As String = "04"
  '-----------------------------
  On Error GoTo ERRLOG
  
  Conf.LoadPublicValues
  VerifyFrmAttribute = True
  With frmAttribute
    For i = 1 To 5
        If VerifyTB_A(i, Conf) = False Then
          VerifyFrmAttribute = False: Exit Function
        End If
        If VerifyCB_A(i, Conf) = False Then
          VerifyFrmAttribute = False: Exit Function
        End If
    Next
  End With
  Set Conf = Nothing
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function


Function VerifyTB_A(i As Integer, Conf As clsConfig) As Boolean
  Const errIDMet As String = "05"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifyTB_A = True
  With frmAttribute
    If .ObjText(i).Visible = True Then
        VerifyTB_A = TestAttribute(.ObjLabel(i).Caption, Conf, .ObjText(i))
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function


Function VerifyCB_A(i As Integer, Conf As clsConfig) As Boolean
  Const errIDMet As String = "08"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifyCB_A = True
  With frmAttribute
    If .ObjCombo(i).Visible = True Then
      'If Len(Trim$(.text)) = 0 Then
       ' MsgBox conf.msgInvalid & " : " & frmAttribute.Objlabel(i) , vbCritical, conf.titleAttribute
        '.SetFocus: VerifyCB_A = False
      'Else
        'With frmAttribute
          VerifyCB_A = TestAttribute(.ObjLabel(i).Caption, Conf, , .ObjCombo(i))
        'End With
      'End If
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function



Public Function TestAttribute(v As String, Conf As clsConfig, Optional text As TextBox, Optional Combo As ComboBox) As Boolean
  Const errIDMet As String = "11"
  '-----------------------------
  On Error GoTo ERRLOG
  
  With frmAttribute
    Select Case v
      Case "dateiso"
        TestAttribute = VerifyDATEISO(text, Conf): Exit Function
      Case "role"
        TestAttribute = VerifyROLE(Combo, Conf): Exit Function
      Case "rid"
        TestAttribute = VerifyRID(text, Conf): Exit Function
      Case "type"
        TestAttribute = VerifyTYPE(Combo, Conf): Exit Function
      Case "language"
        TestAttribute = VerifyLANGUAGE(Combo, Conf): Exit Function
      Case "id"
        TestAttribute = VerifyID(text, Conf): Exit Function
      Case "scheme"
        TestAttribute = VerifySCHEME(Combo, Conf): Exit Function
      Case "from"
        TestAttribute = VerifyFROM(text, Conf): Exit Function
      Case "to"
        TestAttribute = VerifyTO(text, Conf): Exit Function
      Case "standard"
        TestAttribute = VerifySTANDARD(Combo, Conf): Exit Function
      Case "count"
        TestAttribute = VerifyCOUNT(text, Conf): Exit Function
      Case "no"
        TestAttribute = VerifyNO(text, Conf): Exit Function
      Case "orgname"
        TestAttribute = VerifyORGNAME(text, Conf): Exit Function
      Case "orgdiv1"
        TestAttribute = VerifyORGDIV(3, text, Conf): Exit Function
      Case "orgdiv2"
        TestAttribute = VerifyORGDIV(4, text, Conf): Exit Function
      Case "orgdiv3"
        TestAttribute = VerifyORGDIV(5, text, Conf): Exit Function
      Case Else
        TestAttribute = True
    End Select
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Public Function VerifyDateValue(d As String) As Boolean
  Dim day As Integer, mes As Integer, ano As Integer
  Dim anoS As Integer
  Const errIDMet As String = "12"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifyDateValue = True
  ano = val(Mid$(d, 1, 4))
  mes = val(Mid$(d, 5, 2))
  dia = val(Mid$(d, 7, 2))
  '-
  anoS = val(Mid$(Format(Date, "yyyymmdd"), 1, 4))
  '-
  If (ano < 1000 Or ano > anoS) And ano <> 0 Then
    VerifyDateValue = False
  ElseIf mes > 12 Then
    VerifyDateValue = False
  ElseIf dia > 31 Then
    VerifyDateValue = False
  Else
    Select Case dia
        Case 29
            If mes = 2 Then
                If (ano Mod 100) = 0 Then
                    If (ano Mod 400) <> 0 Then
                        VerifyDateValue = False
                    End If
                ElseIf (ano Mod 4) <> 0 Then
                    VerifyDateValue = False
                End If
            End If
        Case 30
            If mes = 2 Then
                VerifyDateValue = False
            End If
        Case 31
            Select Case mes
                Case 2, 4, 6, 9, 11
                    VerifyDateValue = False
            End Select
    End Select
  End If
  Exit Function
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Function

Public Function VerifyDateValueOld(d As String) As Boolean
  Dim day As Integer, mes As Integer, ano As Integer
  Const errIDMet As String = "12"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifyDateValueOld = True
  ano = val(Mid$(d, 1, 4))
  mes = val(Mid$(d, 5, 2))
  dia = val(Mid$(d, 7, 2))
  
  If ano < 1000 And ano <> 0 Then
    VerifyDateValueOld = False
  ElseIf mes > 12 Then
    VerifyDateValueOld = False
  ElseIf dia > 31 Then
    VerifyDateValueOld = False
  End If
  Exit Function
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Function

Function VerifyDATEISO(t As TextBox, Conf As clsConfig) As Boolean
  Const errIDMet As String = "13"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifyDATEISO = True
  With t
    .text = Trim$(.text)
    If Len(.text) <> 8 Then
      MsgBox Conf.msgInvalid & " : dateiso", vbCritical, Conf.titleAttribute
      .SetFocus:
      VerifyDATEISO = False:  Exit Function
    Else
      For i = 0 To Len(.text) - 1
        If Asc(Mid$(.text, i + 1, 1)) < 48 Or Asc(Mid$(.text, i + 1, 1)) > 57 Then
          MsgBox Conf.msgType & " : dateiso", vbCritical, Conf.titleAttribute
          .SetFocus:
          VerifyDATEISO = False:  Exit Function
        End If
      Next i
      If VerifyDateValue(.text) = False Then
        MsgBox Conf.msgType & " : dateiso", vbCritical, Conf.titleAttribute
        .SetFocus:
        VerifyDATEISO = False:  Exit Function
      End If
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyROLE(c As ComboBox, Conf As clsConfig) As Boolean
  Const errIDMet As String = "14"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifyROLE = True
  With c
    If Trim$(.text) = "" Then
      MsgBox Conf.msgInvalid & " : role", vbCritical, Conf.titleAttribute
      .SetFocus:
      VerifyROLE = False:  Exit Function
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyRID(t As TextBox, Conf As clsConfig) As Boolean
  Dim ch As String, i As Integer, max As Integer, value As String
  Dim state As Integer, error As Boolean
  Const errIDMet As String = "15"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifyRID = True
  With t
    If Len(Trim$(.text)) = 0 Then
      With frmAttribute
        Select Case .Frame1.Caption
          Case "author", "oauthor"
            Exit Function
          Case Else
            MsgBox Conf.msgInvalid & " : rid", vbCritical, Conf.titleAttribute
            t.SetFocus
            VerifyRID = False:  Exit Function
        End Select
      End With
    End If
    .text = Trim$(.text)
    max = Len(.text): value = .text: state = 1: error = True: i = 1
    While (i <= max And error = True)
      ch = Mid$(value, i, 1)
      Select Case state
        Case 1
          If (Asc(ch) >= 97 And Asc(ch) <= 122) Then
            i = i + 1: state = 2
          Else
            error = False
          End If
        Case 2
          If (Asc(ch) >= 48 And Asc(ch) <= 57) Then
            i = i + 1: state = 3
          Else
            error = False
          End If
        Case 3
          If (Asc(ch) >= 48 And Asc(ch) <= 57) Then
            i = i + 1: state = 4
          Else
            error = False
          End If
        Case 4
          If Asc(ch) = 32 Then
            i = i + 1: state = 1
          Else
            error = False
          End If
      End Select
      If error = False Then
        MsgBox Conf.msgInvalid & " : rid", vbCritical, Conf.titleAttribute
        .SetFocus:
        VerifyRID = False:  Exit Function
      End If
    Wend
    If state <> 4 Then
      MsgBox Conf.msgInvalid & " : rid", vbCritical, Conf.titleAttribute
      .SetFocus
      VerifyRID = False:  Exit Function
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyTYPE(c As ComboBox, Conf As clsConfig) As Boolean
  Const errIDMet As String = "16"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifyTYPE = True
  With c
    If Trim$(.text) = "" Then
      MsgBox Conf.msgInvalid & " : type", vbCritical, Conf.titleAttribute
      .SetFocus:
      VerifyTYPE = False:  Exit Function
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyLANGUAGE(c As ComboBox, Conf As clsConfig) As Boolean
  Const errIDMet As String = "17"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifyLANGUAGE = True
  With c
    If Trim$(.text) = "" Then
      MsgBox Conf.msgInvalid & " : language", vbCritical, Conf.titleAttribute
      .SetFocus: VerifyLANGUAGE = False:  Exit Function
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyID(t As TextBox, Conf As clsConfig) As Boolean
  Dim ch As String, i As Integer, max As Integer, value As String
  Dim state As Integer, error As Boolean
  Const errIDMet As String = "18"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifyID = True
  With t
    If Len(Trim$(.text)) = 0 Then
      With frmAttribute
        Select Case .Frame1.Caption
          Case "keyword"
            Exit Function
          Case Else
            MsgBox Conf.msgInvalid & " : id", vbCritical, Conf.titleAttribute
            t.SetFocus: VerifyID = False:  Exit Function
        End Select
      End With
    End If
    .text = Trim$(.text)
    max = Len(.text): value = .text: state = 1: error = True: i = 1
    While (i <= max And error = True)
      ch = Mid$(value, i, 1)
      Select Case state
        Case 1
          If (Asc(ch) >= 97 And Asc(ch) <= 122) Then
            i = i + 1: state = 2
          Else
            error = False
          End If
        Case 2
          If (Asc(ch) >= 48 And Asc(ch) <= 57) Then
            i = i + 1: state = 3
          Else
            error = False
          End If
        Case 3
          If (Asc(ch) >= 48 And Asc(ch) <= 57) Then
            i = i + 1: state = 4
          Else
            error = False
          End If
        Case 4
          If Asc(ch) = 32 Then
            i = i + 1: state = 1
          Else
            error = False
          End If
      End Select
      If error = False Then
        MsgBox Conf.msgInvalid & " : id", vbCritical, Conf.titleAttribute
        .SetFocus:
        VerifyID = False:  Exit Function
      End If
    Wend
    If state <> 4 Then
      MsgBox Conf.msgInvalid & " : id", vbCritical, Conf.titleAttribute
      .SetFocus:
      VerifyID = False:  Exit Function
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifySCHEME(c As ComboBox, Conf As clsConfig) As Boolean
  Const errIDMet As String = "19"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifySCHEME = True
  With c
    If Trim$(.text) = "" Then
      MsgBox Conf.msgInvalid & " : scheme", vbCritical, Conf.titleAttribute
      .SetFocus:
      VerifySCHEME = False:  Exit Function
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyFROM(t As TextBox, Conf As clsConfig) As Boolean
  Const errIDMet As String = "20"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifyFROM = True
  With t
    If Len(Trim$(.text)) <> 8 Then
      MsgBox Conf.msgInvalid & " : from", vbCritical, Conf.titleAttribute
      .SetFocus:
      VerifyFROM = False:  Exit Function
    Else
      For i = 0 To Len(Trim$(.text)) - 1
        If Asc(Mid$(.text, i + 1, 1)) < 48 Or Asc(Mid$(.text, i + 1, 1)) > 57 Then
          MsgBox Conf.msgType & " : from", vbCritical, Conf.titleAttribute
          .SetFocus:
          VerifyFROM = False:  Exit Function
        End If
      Next i
      If VerifyDateValue(.text) = False Then
        MsgBox Conf.msgType & " : from", vbCritical, Conf.titleAttribute
        .SetFocus:
        VerifyFROM = False:  Exit Function
      End If
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyTO(t As TextBox, Conf As clsConfig) As Boolean
  Dim fromDate As Double, toDate As Double
  Const errIDMet As String = "21"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifyTO = True
  With t
    If Len(Trim$(.text)) <> 8 Then
      MsgBox Conf.msgInvalid & " : to", vbCritical, Conf.titleAttribute
      .SetFocus:
      VerifyTO = False:  Exit Function
    Else
      For i = 0 To Len(Trim$(.text)) - 1
        If Asc(Mid$(.text, i + 1, 1)) < 48 Or Asc(Mid$(.text, i + 1, 1)) > 57 Then
          MsgBox Conf.msgType & " : to", vbCritical, Conf.titleAttribute
          .SetFocus:
          VerifyTO = False:  Exit Function
        End If
      Next i
      If VerifyDateValue(.text) = False Then
        MsgBox Conf.msgType & " : to", vbCritical, Conf.titleAttribute
        .SetFocus:
        VerifyTO = False:  Exit Function
      Else
        fromDate = val(frmAttribute.TextBox_attrib1.text)
        toDate = val(t.text)
        If fromDate >= toDate Then
          MsgBox Conf.msgType & " : from / to", vbCritical, Conf.titleAttribute
          .SetFocus:
          VerifyTO = False:  Exit Function
        End If
      End If
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifySTANDARD(c As ComboBox, Conf As clsConfig) As Boolean
  Const errIDMet As String = "22"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifySTANDARD = True
  With c
    If Trim$(.text) = "" Then
      MsgBox Conf.msgInvalid & " : standard", vbCritical, Conf.titleAttribute
      .SetFocus:
      VerifySTANDARD = False:  Exit Function
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyCOUNT(t As TextBox, Conf As clsConfig) As Boolean
  Const errIDMet As String = "23"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifyCOUNT = True
  With t
    If Len(Trim$(.text)) = 0 Then
      MsgBox Conf.msgInvalid & " : count", vbCritical, Conf.titleAttribute
      .SetFocus:
      VerifyCOUNT = False:  Exit Function
    Else
      For i = 0 To Len(Trim$(.text)) - 1
        If Asc(Mid$(.text, i + 1, 1)) < 48 Or Asc(Mid$(.text, i + 1, 1)) > 57 Then
          MsgBox Conf.msgType & " : count", vbCritical, Conf.titleAttribute
          .SetFocus:
          VerifyCOUNT = False:  Exit Function
        End If
      Next i
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyNO(t As TextBox, Conf As clsConfig) As Boolean
  Dim ch As String, i As Integer, max As Integer, value As String
  Dim state As Integer, error As Boolean
  Const errIDMet As String = "24"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifyNO = True
  With t
    If Len(Trim$(.text)) = 0 Then
      MsgBox Conf.msgInvalid & " : no", vbCritical, Conf.titleAttribute
      .SetFocus: VerifyNO = False:  Exit Function
    End If
    .text = Trim$(.text)
    max = Len(.text): value = .text: state = 1: error = True: i = 1
    While (i <= max And error = True)
      ch = Mid$(value, i, 1)
      Select Case state
        Case 1
          If (Asc(ch) >= 97 And Asc(ch) <= 122) Then
            i = i + 1: state = 2
          Else
            error = False
          End If
        Case 2
          If (Asc(ch) >= 48 And Asc(ch) <= 57) Then
            i = i + 1: state = 3
          Else
            error = False
          End If
        Case 3
          If (Asc(ch) >= 48 And Asc(ch) <= 57) Then
            i = i + 1: state = 4
          Else
            error = False
          End If
        Case 4
          If Asc(ch) = 32 Then
            i = i + 1: state = 1
          Else
            error = False
          End If
      End Select
      If error = False Then
        MsgBox Conf.msgInvalid & " : no", vbCritical, Conf.titleAttribute
        .SetFocus:
        VerifyNO = False:  Exit Function
      End If
    Wend
    If state <> 4 Then
      MsgBox Conf.msgInvalid & " : no", vbCritical, Conf.titleAttribute
      .SetFocus:
      VerifyNO = False:  Exit Function
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyORGNAME(t As TextBox, Conf As clsConfig) As Boolean
  Const errIDMet As String = "25"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifyORGNAME = True
  With t
    If Trim$(.text) = "" Then
      MsgBox Conf.msgInvalid & " : orgname", vbCritical, Conf.titleAttribute
      .SetFocus:
      VerifyORGNAME = False:  Exit Function
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyORGDIV(i As Integer, t As TextBox, Conf As clsConfig) As Boolean
  Const errIDMet As String = "25"
  '-----------------------------
  On Error GoTo ERRLOG
  
  VerifyORGDIV = True
  With t
    If Trim$(.text) <> "" Then
        If Trim$(ObjText(i - 1).text) = "" Then
          MsgBox Conf.msgInvalid & " : " & ObjLabel(i).Caption, vbCritical, Conf.titleAttribute
          .SetFocus:
          VerifyORGDIV = False:  Exit Function
        End If
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function



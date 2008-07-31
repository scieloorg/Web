VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmArticle 
   Caption         =   "Markup DTD-Scielo 2.0"
   ClientHeight    =   5385
   ClientLeft      =   450
   ClientTop       =   1305
   ClientWidth     =   8565
   OleObjectBlob   =   "frmArticle.frx":0000
End
Attribute VB_Name = "frmArticle"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Public flagOK As Boolean
Public flagChange As Boolean
Public flagConv As Boolean
Private mErr As New clsErrList

' 20071214
Private ahpDateIsMandatory As Boolean
Private rvpDateIsMandatory As Boolean
Public currentAHPDate As String
Public currentRVPDate As String
Public currentTitle As String

Const errIDObj As String = "001"
'roberta - substituido por SelectIssueId - 990827
' 20071214
Private Sub ComboBox_issueid_Change()
  Const errIDMet As String = "01"
  '------------------------------
  On Error GoTo errLOG
  
  frmArticle.ClearForm
  If Len(frmArticle.ComboBox_issueid.text) > 0 Then
    Call SelectIssueId(frmArticle.ComboBox_issueid.text)
    End If
  Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub

Private Sub ComboBox_version_Change()
  Const errIDMet As String = "02"
  '------------------------------
  On Error GoTo errLOG
  
  With frmArticle
    Select Case .ComboBox_version.text
      Case "3.0", "3.1"
        'continua habilitando o campo de sponsor
        .Frame_sponsor.Enabled = True
        With .ComboBox_sponsor
        .Enabled = True
        End With
      Case Else
        .Frame_sponsor.Enabled = False
        With .ComboBox_sponsor
          .Enabled = False
        End With
    End Select
  End With
  Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub

Private Sub CommandButton_cancel_Click()
  Const errIDMet As String = "03"
  '------------------------------
  On Error GoTo errLOG
  
  frmArticle.flagOK = False
  frmArticle.Hide
  Unload Me
  Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub

Private Sub CommandButton_OK_Click()
  Const errIDMet As String = "04"
  '------------------------------
  On Error GoTo errLOG
  
  If VerifyFrmArticle = True Then
    frmArticle.flagOK = True
    frmArticle.Hide
    'Unload Me
  End If
  Exit Sub
  y = 1
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub

Private Sub UserForm_Terminate()
  Const errIDMet As String = "05"
  '------------------------------
  On Error GoTo errLOG
  
  CommandButton_cancel_Click
  Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub

Public Function VerifyFrmArticle() As Boolean
  Dim conf As New clsConfig
  Const errIDMet As String = "06"
  '------------------------------
  On Error GoTo errLOG
  
  conf.LoadPublicValues
  VerifyFrmArticle = True
  With frmArticle
    If VerifyPII(.TextBox_pii.text, conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    'If VerifySUPPLVOL(.TextBox_supplvol.text, conf) = False Then
    '   VerifyFrmArticle = False: Exit Function
    'End If
    'If VerifySUPPLNO(.TextBox_supplno.text, conf) = False Then
    '  VerifyFrmArticle = False: Exit Function
    'End If
    If VerifyTOCCODE(conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    If VerifyORDER(.TextBox_order.text, conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    'If VerifyVOLID(.TextBox_volid.text, conf) = False Then
    '  VerifyFrmArticle = False: Exit Function
    'End If
    'If VerifyISSUENO(.TextBox_issueno.text, conf) = False Then
    '  VerifyFrmArticle = False: Exit Function
    'End If
    'If VerifyDATEISO(.TextBox_dateiso.text, conf) = False Then
    '  VerifyFrmArticle = False: Exit Function
    'End If
    If VerifyLANGUAGE(conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    If VerifyTYPE(conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    'If VerifySTATUS(conf) = False Then
    '  VerifyFrmArticle = False: Exit Function
    'End If
    If VerifyVERSION(conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    If VerifyDOCTOPIC(conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    If VerifyCCODE(conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    'If VerifySTITLE(conf) = False Then
    '  VerifyFrmArticle = False: Exit Function
    'End If
    If VerifySECCODE(conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    If VerifyPAGES(conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    'If VerifyISSN(conf) = False Then
    '  VerifyFrmArticle = False: Exit Function
    'End If
    If VerifySPONSOR(conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    If VerifyRVPdate(.TextBox_rvpdate.text, conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    If VerifyAHPDate(.TextBox_ahpdate.text, conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
  End With
  Set conf = Nothing
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Function

Public Function VerifyDateValue(d As String) As Boolean
  Dim day As Integer, mes As Integer, ano As Integer
  Const errIDMet As String = "07"
  '------------------------------
  On Error GoTo errLOG
  If Len(d) <> 8 Then

  Else
    VerifyDateValue = True
    ano = val(Mid$(d, 1, 4))
    mes = val(Mid$(d, 5, 2))
    dia = val(Mid$(d, 7, 2))
    
    If ano < 1800 And ano <> 0 Then
      VerifyDateValue = False
    ElseIf mes > 12 Then
      VerifyDateValue = False
    ElseIf dia > 31 Then
      VerifyDateValue = False
    End If
  End If
  Exit Function
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Function

Function VerifyPII(t As String, conf As clsConfig) As Boolean
  Const errIDMet As String = "08"
  '------------------------------
  On Error GoTo errLOG
  
  VerifyPII = True
  With frmArticle.TextBox_pii
    Select Case LCase(Trim$(t))
      Case ""
        .text = "nd"
      Case "nd"

      Case Else
        If Len(Trim$(t)) <> 2 Then
          MsgBox conf.msgInvalid & " : pii", vbCritical, conf.titleAttribute
          .SetFocus: VerifyPII = False:  Exit Function
        Else
          For i = 0 To Len(Trim$(t)) - 1
            If Asc(Mid$(t, i + 1, 1)) < 48 Or Asc(Mid$(t, i + 1, 1)) > 57 Then
              MsgBox conf.msgType & " : pii", vbCritical, conf.titleAttribute
              .SetFocus: VerifyPII = False:  Exit Function
            End If
          Next i
        End If
    End Select
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Function VerifyORDER(t As String, conf As clsConfig) As Boolean
  Const errIDMet As String = "09"
  '------------------------------
  On Error GoTo errLOG
  
  VerifyORDER = True
  With frmArticle.TextBox_order
    'If Len(Trim$(t)) <> 3 Then
    If Len(Trim$(t)) <> 2 And Len(Trim$(t)) <> 5 Then
      MsgBox conf.msgInvalid & " : order", vbCritical, conf.titleAttribute
      .SetFocus: VerifyORDER = False:  Exit Function
    Else
      For i = 0 To Len(Trim$(t)) - 1
        If Asc(Mid$(t, i + 1, 1)) < 48 Or Asc(Mid$(t, i + 1, 1)) > 57 Then
          MsgBox conf.msgType & " : order", vbCritical, conf.titleAttribute
          .SetFocus: VerifyORDER = False:  Exit Function
        End If
      Next i
    End If
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Function VerifyVOLID(t As String, conf As clsConfig) As Boolean
  Const errIDMet As String = "10"
 '-------------------------------
  On Error GoTo errLOG
  
  VerifyVOLID = True
  With frmArticle.TextBox_volid
    If Len(Trim$(t)) > 3 Then
      MsgBox conf.msgInvalid & " : volid", vbCritical, conf.titleAttribute
      VerifyVOLID = False:  Exit Function
    Else
      For i = 0 To Len(Trim$(t)) - 1
        If Asc(Mid$(t, i + 1, 1)) < 48 Or Asc(Mid$(t, i + 1, 1)) > 57 Then
          MsgBox conf.msgType & " : volid", vbCritical, conf.titleAttribute
          VerifyVOLID = False:  Exit Function
        End If
      Next i
    End If
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Function VerifyISSUENO(t As String, conf As clsConfig) As Boolean
  Const errIDMet As String = "11"
  '------------------------------
  On Error GoTo errLOG
  
  VerifyISSUENO = True
  With frmArticle.TextBox_issueno
    If Len(Trim$(t)) > 3 Then
      MsgBox conf.msgInvalid & " : issueno", vbCritical, conf.titleAttribute
      VerifyISSUENO = False:  Exit Function
    Else
      For i = 0 To Len(Trim$(t)) - 1
        If Asc(Mid$(t, i + 1, 1)) < 48 Or Asc(Mid$(t, i + 1, 1)) > 57 Then
          MsgBox conf.msgType & " : issueno", vbCritical, conf.titleAttribute
          VerifyISSUENO = False:  Exit Function
        End If
      Next i
    End If
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Function VerifyDATEISO(t As String, conf As clsConfig) As Boolean
  Const errIDMet As String = "12"
  '------------------------------
  On Error GoTo errLOG
  
  VerifyDATEISO = True
  With frmArticle.TextBox_dateiso
    If Len(Trim$(t)) <> 8 Then
      MsgBox conf.msgInvalid & " : dateiso", vbCritical, conf.titleAttribute
      VerifyDATEISO = False:  Exit Function
    Else
      For i = 0 To Len(Trim$(t)) - 1
        If Asc(Mid$(t, i + 1, 1)) < 48 Or Asc(Mid$(t, i + 1, 1)) > 57 Then
          MsgBox conf.msgType & " : dateiso", vbCritical, conf.titleAttribute
          VerifyDATEISO = False:  Exit Function
        End If
      Next i
      If VerifyDateValue(t) = False Then
        MsgBox conf.msgType & " : dateiso", vbCritical, conf.titleAttribute
        VerifyDATEISO = False:  Exit Function
      End If
    End If
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Function VerifySUPPLVOL(t As String, conf As clsConfig) As Boolean
  Const errIDMet As String = "13"
  '------------------------------
  On Error GoTo errLOG
  
  VerifySUPPLVOL = True
  With frmArticle.TextBox_supplvol
    Select Case LCase(Trim$(t))
      Case ""
        
      Case Else
        If Len(Trim$(t)) > 3 Then
          MsgBox conf.msgInvalid & " : supplvol", vbCritical, conf.titleAttribute
          VerifySUPPLVOL = False:  Exit Function
        Else
          For i = 0 To Len(Trim$(t)) - 1
            If Asc(Mid$(t, i + 1, 1)) < 48 Or Asc(Mid$(t, i + 1, 1)) > 57 Then
              MsgBox conf.msgType & " : supplvol", vbCritical, conf.titleAttribute
              VerifySUPPLVOL = False:  Exit Function
            End If
          Next i
        End If
    End Select
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Function VerifySUPPLNO(t As String, conf As clsConfig) As Boolean
  Const errIDMet As String = "14"
  '------------------------------
  On Error GoTo errLOG
  
  VerifySUPPLNO = True
  With frmArticle.TextBox_supplno
    Select Case LCase(Trim$(t))
      Case ""
        
      Case Else
        If Len(Trim$(t)) > 3 Then
          MsgBox conf.msgInvalid & " : supplno", vbCritical, conf.titleAttribute
          VerifySUPPLNO = False:  Exit Function
        Else
          For i = 0 To Len(Trim$(t)) - 1
            If Asc(Mid$(t, i + 1, 1)) < 48 Or Asc(Mid$(t, i + 1, 1)) > 57 Then
              MsgBox conf.msgType & " : supplno", vbCritical, conf.titleAttribute
              VerifySUPPLNO = False:  Exit Function
            End If
          Next i
        End If
    End Select
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Function VerifyTOCCODE(conf As clsConfig) As Boolean
  Const errIDMet As String = "15"
  '------------------------------
  On Error GoTo errLOG
  
  VerifyTOCCODE = True
  With frmArticle.ComboBox_toccode
    If .Enabled = True Then
      If Trim$(.text) = "" Then
        MsgBox conf.msgType & " : toccode", vbCritical, conf.titleAttribute
        VerifyTOCCODE = False: Exit Function
      End If
    End If
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Function VerifyLANGUAGE(conf As clsConfig) As Boolean
  Const errIDMet As String = "16"
  '------------------------------
  On Error GoTo errLOG
  
  VerifyLANGUAGE = True
  With frmArticle.ComboBox_language
    If Trim$(.text) = "" Then
      MsgBox conf.msgInvalid & " : language", vbCritical, conf.titleAttribute
      .SetFocus: VerifyLANGUAGE = False:  Exit Function
    End If
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Function VerifyTYPE(conf As clsConfig) As Boolean
  Dim i As Integer
  Dim Failure As Boolean
  Const errIDMet As String = "17"
  '------------------------------
  On Error GoTo errLOG
  
  VerifyTYPE = False
  'Roberta
  With frmArticle.ListBox_type
    Failure = False
    If .Selected(0) Then
      i = 1
      While (i < .ListCount) And (Not Failure)
        Failure = .Selected(i)
        i = i + 1
      Wend
    Else
      i = 1
      Failure = True
      While (i < .ListCount) And (Failure)
        Failure = (Not .Selected(i))
        i = i + 1
      Wend
    End If
    If Not Failure Then
      VerifyTYPE = True: Exit Function
    End If
    
    MsgBox conf.msgInvalid & " : type", vbCritical, conf.titleAttribute
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Function VerifySTATUS(conf As clsConfig) As Boolean
  Const errIDMet As String = "18"
  '------------------------------
  On Error GoTo errLOG
  
  VerifySTATUS = True
  With frmArticle.TextBox_status
    If Trim$(.text) = "" Then
      MsgBox conf.msgInvalid & " : status", vbCritical, conf.titleAttribute
      VerifySTATUS = False:  Exit Function
    End If
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Function VerifyVERSION(conf As clsConfig) As Boolean
  Const errIDMet As String = "19"
  '------------------------------
  On Error GoTo errLOG
  
  VerifyVERSION = True
  With frmArticle.ComboBox_version
    If Trim$(.text) = "" Then
      MsgBox conf.msgInvalid & " : version", vbCritical, conf.titleAttribute
      .SetFocus: VerifyVERSION = False:  Exit Function
    End If
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Function VerifyDOCTOPIC(conf As clsConfig) As Boolean
  Const errIDMet As String = "20"
  '------------------------------
  On Error GoTo errLOG
  
  VerifyDOCTOPIC = True
  With frmArticle.ComboBox_doctopic
    If Trim$(.text) = "" Then
      MsgBox conf.msgInvalid & " : doctopic", vbCritical, conf.titleAttribute
      .SetFocus: VerifyDOCTOPIC = False:  Exit Function
    End If
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Function VerifyCCODE(conf As clsConfig) As Boolean
  Const errIDMet As String = "21"
  '------------------------------
  On Error GoTo errLOG
  
  VerifyCCODE = True
  With frmArticle.ComboBox_ccode
    If Trim$(.text) = "" Then
      MsgBox conf.msgInvalid & " : ccode", vbCritical, conf.titleAttribute
      .SetFocus: VerifyCCODE = False:  Exit Function
    End If
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Function VerifySTITLE(conf As clsConfig) As Boolean
  Const errIDMet As String = "22"
  '------------------------------
  On Error GoTo errLOG
  
  VerifySTITLE = True
  With frmArticle.TextBox_stitle
    If Trim$(.text) = "" Then
      MsgBox conf.msgInvalid & " : stitle", vbCritical, conf.titleAttribute
      VerifySTITLE = False:  Exit Function
    End If
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Function VerifySECCODE(conf As clsConfig) As Boolean
  Const errIDMet As String = "23"
  '------------------------------
  On Error GoTo errLOG
  
  VerifySECCODE = True
  With frmArticle.ComboBox_seccode
    If Trim$(.text) = "" Then
      MsgBox conf.msgInvalid & " : seccode", vbCritical, conf.titleAttribute
      .SetFocus: VerifySECCODE = False:  Exit Function
    End If
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Function VerifyISSN(conf As clsConfig) As Boolean
  Const errIDMet As String = "24"
  '------------------------------
  On Error GoTo errLOG
  
  VerifyISSN = True
  With frmArticle.TextBox_issn
    If Trim$(.text) = "" Then
      MsgBox conf.msgInvalid & " : issn", vbCritical, conf.titleAttribute
      VerifyISSN = False:  Exit Function
    End If
  End With
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Function

Function VerifyPAGES(conf As clsConfig) As Boolean
  Dim pos As Integer, i As Integer, fim As Integer
  Dim pages As New collection, periodos As New collection
  Dim p As New collection, t As String
  Const errIDMet As String = "25"
  '------------------------------
  On Error GoTo errLOG
  
  VerifyPAGES = True
  With frmArticle.TextBox_pages
    t = Trim$(.text)
    If InStr(t, " ") <> 0 Then
      MsgBox conf.msgInvalid & " : pages", vbCritical, conf.titleAttribute
      .SetFocus: VerifyPAGES = False: Exit Function
    End If
    pos = InStr(t, ",")
    If pos <> 0 Then
      While pos <> 0
        periodos.add pos
        pos = InStr(pos + 1, t, ",")
      Wend
      With periodos
        pos = 1
        For i = 1 To .count
          fim = .Item(i)
          pages.add Mid$(t, pos, fim - 1)
          pos = fim + 1
        Next i
        pages.add Mid$(t, pos, Len(t) - pos + 1)
      End With
    Else
      pos = InStr(t, "-")
      If pos <> 0 Then
        If InStr(pos + 1, t, "-") <> 0 Then
          MsgBox conf.msgInvalid & " : pages", vbCritical, conf.titleAttribute
          .SetFocus: VerifyPAGES = False: Exit Function
        Else
          pages.add t
        End If
      Else
        MsgBox conf.msgInvalid & " : pages", vbCritical, conf.titleAttribute
        .SetFocus: VerifyPAGES = False: Exit Function
      End If
    End If
    With pages
      For i = 1 To .count
        If InStr(1, .Item(i), "-") <> 0 Then
          p.add Mid$(.Item(i), 1, InStr(1, .Item(i), "-") - 1)
          p.add Mid$(.Item(i), InStr(1, .Item(i), "-") + 1, Len(.Item(i)) - InStr(1, .Item(i), "-"))
        Else
          MsgBox conf.msgInvalid & " : pages", vbCritical, conf.titleAttribute
          frmArticle.TextBox_pages.SetFocus: VerifyPAGES = False: Exit Function
        End If
      Next i
      With p
        For i = 1 To .count
          If val(.Item(i)) > val(.Item(i + 1)) Then
            MsgBox conf.msgInvalid & " : pages", vbCritical, conf.titleAttribute
            frmArticle.TextBox_pages.SetFocus: VerifyPAGES = False: Exit Function
          Else
            i = i + 1
          End If
        Next i
      End With
    End With
  End With
  Set pages = Nothing: Set periodos = Nothing: Set p = Nothing
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set pages = Nothing: Set periodos = Nothing: Set p = Nothing
End Function

Public Function VerifySPONSOR(conf) As Boolean
  VerifySPONSOR = True
  With frmArticle.ComboBox_sponsor
    If Trim$(.text) = "" Then
      MsgBox conf.msgInvalid & " : sponsor", vbCritical, conf.titleAttribute
      VerifySPONSOR = False:  Exit Function
    End If
  End With
  Exit Function
End Function

Function VerifyRVPdate(t As String, conf As clsConfig) As Boolean
  Dim r As Boolean
  
    ' 20071214
    If rvpDateIsMandatory Then
        If (Trim$(t) <> "") Then
            r = VerifyDateValue(t)
    End If
  Else
        r = True
  End If
  If Not r Then
        MsgBox conf.msgType & " : rvpdate", vbCritical, conf.titleAttribute
        frmArticle.TextBox_rvpdate.SetFocus
  End If
    
  VerifyRVPdate = r
End Function


Function VerifyAHPDate(t As String, conf As clsConfig) As Boolean
    Dim r As Boolean
    
    ' 20071214
    If ahpDateIsMandatory Then
        If (Trim$(t) <> "") Then
            r = VerifyDateValue(t)
    End If
    Else
        r = True
    End If
    If Not r Then
        MsgBox conf.msgType & " : ahp date", vbCritical, conf.titleAttribute
        frmArticle.TextBox_ahpdate.SetFocus
    End If
    
    VerifyAHPDate = r
End Function

Public Sub OrdIssueList(ByRef list As collection)
  'bubble sort
  Dim NoExchange As Boolean
  Dim first As Integer, pass As Integer
  Dim temp As String
  
  '-----------------
  ' 20071214 fixme
    
  pass = 1
  Do
    NoExchange = True
    For first = 1 To list.count - pass
      If list.Item(first) > list.Item(first + 1) Then
        list.add list.Item(first + 1), Before:=first
        list.remove first + 2
        NoExchange = False
      End If
    Next first
    pass = pass + 1
  Loop While NoExchange = False
  
End Sub
' 20071214
Sub loadIssueList(issuel As clsIssueList)
    Dim list As New collection
    Dim i As Long
    Dim issue As clsIssue


    For i = 1 To issuel.ReturnCount
          Set issue = issuel.ReturnIssue(str$(i))
          list.add issue.primaryKey
    Next i
    Call OrdIssueList(list)
  With frmArticle.ComboBox_issueid
    .Clear
      For i = 1 To list.count
        .AddItem list.Item(i)
      Next
  End With
  '-----------------
  Set list = Nothing
End Sub

'roberta - 9990827
Function SelectIssueId(SelectedIssue As String) As clsIssue
  Dim issuel As New clsIssueList, issue As New clsIssue, v As New clsValue
  Dim i As Integer, conf As New clsConfig
  Static ok As Boolean, issueid As String
  Const errIDMet As String = "26"
  '-----------------------------
  On Error GoTo errLOG
  
  conf.LoadPublicValues
  issuel.LoadIssue conf
    
  
  If Len(SelectedIssue) > 0 Then
    Set issue = issuel.ExistIssue(SelectedIssue)
    issueid = issue.primaryKey
  End If
    If (Len(issueid) > 0) Then
    With frmArticle
    .ComboBox_issueid.text = issueid
    .TextBox_stitle.text = issue.stitle
    .TextBox_volid.text = issue.volid
    .TextBox_issueno.text = issue.issueno
    .TextBox_supplvol.text = issue.supplvol
    .TextBox_supplno.text = issue.supplno
    .TextBox_dateiso.text = issue.dateiso
    .TextBox_issn.text = issue.issn
    .TextBox_status.text = issue.status
    .ComboBox_seccode.Clear
    For i = 1 To issue.ReturnCount
      Set v = issue.ReturnSec(str$(i))
      .ComboBox_seccode.AddItem v.extValue
    Next i
        setDates
    .TextBox_order.SetFocus
    End With
  Else
    ClearForm
    End If
  Set SelectIssueId = issue
  Set issuel = Nothing: Set issue = Nothing
  Set v = Nothing:  Set conf = Nothing
  Exit Function
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set issuel = Nothing: Set issue = Nothing
  Set v = Nothing:  Set conf = Nothing
End Function

Sub SelectComboItem(cmbbox As ComboBox, op As String)
    Dim i As Long
    Dim found As Boolean
    
    While (i < cmbbox.ListCount) And (Not found)
        If StrComp(cmbbox.list(i), op) = 0 Then
            found = True
            cmbbox.ListIndex = i
        End If
        i = i + 1
    Wend
End Sub

' 20071214
Private Sub setDates()
    Select Case Trim(frmArticle.TextBox_issueno.text)
    Case "ahead"
        frmArticle.Frame_ahpdate.Enabled = True
        frmArticle.Frame_rvpdate.Enabled = False
        ahpDateIsMandatory = True
    Case "review"
        frmArticle.Frame_rvpdate.Enabled = True
        frmArticle.Frame_ahpdate.Enabled = False
        rvpDateIsMandatory = True
    Case Else
        frmArticle.Frame_ahpdate.Enabled = False
        frmArticle.Frame_rvpdate.Enabled = False
    End Select
        If currentTitle = frmArticle.TextBox_stitle.text Then
            frmArticle.TextBox_ahpdate.text = currentAHPDate
            frmArticle.TextBox_rvpdate.text = currentRVPDate
        End If
End Sub

Public Sub ClearForm()
  With frmArticle
    .TextBox_pii.text = ""
    .TextBox_supplvol.text = ""
    .TextBox_supplno.text = ""
    .TextBox_dateiso.text = ""
    .TextBox_issn.text = ""
    .TextBox_issueno.text = ""
    .TextBox_order.text = ""
    .TextBox_pages.text = ""
    .TextBox_status.text = ""
    .TextBox_stitle.text = ""
    .TextBox_volid.text = ""
    
    .TextBox_ahpdate.text = ""
    .TextBox_rvpdate.text = ""

  End With

End Sub

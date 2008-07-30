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
  On Error GoTo ERRLOG
  
  frmArticle.ClearForm
  If Len(frmArticle.ComboBox_issueid.text) > 0 Then
    Call SelectIssueId(frmArticle.ComboBox_issueid.text)
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

Private Sub ComboBox_version_Change()
  Const errIDMet As String = "02"
  '------------------------------
  On Error GoTo ERRLOG
  
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
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub

Private Sub CommandButton_cancel_Click()
  Const errIDMet As String = "03"
  '------------------------------
  On Error GoTo ERRLOG
  
  frmArticle.flagOK = False
  frmArticle.Hide
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
  Const errIDMet As String = "04"
  '------------------------------
  On Error GoTo ERRLOG
  
  If VerifyFrmArticle = True Then
    frmArticle.flagOK = True
    frmArticle.Hide
    'Unload Me
  End If
  Exit Sub
  y = 1
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
  Const errIDMet As String = "05"
  '------------------------------
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

Public Function VerifyFrmArticle() As Boolean
  Dim Conf As New clsConfig
  Const errIDMet As String = "06"
  '------------------------------
  On Error GoTo ERRLOG
  
  Conf.LoadPublicValues
  VerifyFrmArticle = True
  With frmArticle
    If VerifyPII(.TextBox_pii.text, Conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    'If VerifySUPPLVOL(.TextBox_supplvol.text, conf) = False Then
    '   VerifyFrmArticle = False: Exit Function
    'End If
    'If VerifySUPPLNO(.TextBox_supplno.text, conf) = False Then
    '  VerifyFrmArticle = False: Exit Function
    'End If
    If VerifyTOCCODE(Conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    If VerifyORDER(.TextBox_order.text, Conf) = False Then
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
    If VerifyLANGUAGE(Conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    If VerifyTYPE(Conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    'If VerifySTATUS(conf) = False Then
    '  VerifyFrmArticle = False: Exit Function
    'End If
    If VerifyVERSION(Conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    If VerifyDOCTOPIC(Conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    If VerifyCCODE(Conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    'If VerifySTITLE(conf) = False Then
    '  VerifyFrmArticle = False: Exit Function
    'End If
    If VerifySECCODE(Conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    If VerifyPAGES(Conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    'If VerifyISSN(conf) = False Then
    '  VerifyFrmArticle = False: Exit Function
    'End If
    If VerifySPONSOR(Conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    If VerifyRVPdate(.TextBox_rvpdate.text, Conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
    If VerifyAHPDate(.TextBox_ahpdate.text, Conf) = False Then
      VerifyFrmArticle = False: Exit Function
    End If
  End With
  Set Conf = Nothing
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Function

Public Function VerifyDateValue(d As String) As Boolean
  Dim day As Integer, mes As Integer, ano As Integer
  Const errIDMet As String = "07"
  '------------------------------
  On Error GoTo ERRLOG
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
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Function

Function VerifyPII(t As String, Conf As clsConfig) As Boolean
  Const errIDMet As String = "08"
  '------------------------------
  On Error GoTo ERRLOG
  
  VerifyPII = True
  With frmArticle.TextBox_pii
    Select Case LCase(Trim$(t))
      Case ""
        .text = "nd"
      Case "nd"

      Case Else
        If Len(Trim$(t)) <> 2 Then
          MsgBox Conf.msgInvalid & " : pii", vbCritical, Conf.titleAttribute
          .SetFocus: VerifyPII = False:  Exit Function
        Else
          For i = 0 To Len(Trim$(t)) - 1
            If Asc(Mid$(t, i + 1, 1)) < 48 Or Asc(Mid$(t, i + 1, 1)) > 57 Then
              MsgBox Conf.msgType & " : pii", vbCritical, Conf.titleAttribute
              .SetFocus: VerifyPII = False:  Exit Function
            End If
          Next i
        End If
    End Select
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyORDER(t As String, Conf As clsConfig) As Boolean
  Const errIDMet As String = "09"
  '------------------------------
  On Error GoTo ERRLOG
  
  VerifyORDER = True
  With frmArticle.TextBox_order
    'If Len(Trim$(t)) <> 3 Then
    If Len(Trim$(t)) <> 2 And Len(Trim$(t)) <> 5 Then
      MsgBox Conf.msgInvalid & " : order", vbCritical, Conf.titleAttribute
      .SetFocus: VerifyORDER = False:  Exit Function
    Else
      For i = 0 To Len(Trim$(t)) - 1
        If Asc(Mid$(t, i + 1, 1)) < 48 Or Asc(Mid$(t, i + 1, 1)) > 57 Then
          MsgBox Conf.msgType & " : order", vbCritical, Conf.titleAttribute
          .SetFocus: VerifyORDER = False:  Exit Function
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

Function VerifyVOLID(t As String, Conf As clsConfig) As Boolean
  Const errIDMet As String = "10"
 '-------------------------------
  On Error GoTo ERRLOG
  
  VerifyVOLID = True
  With frmArticle.TextBox_volid
    If Len(Trim$(t)) > 3 Then
      MsgBox Conf.msgInvalid & " : volid", vbCritical, Conf.titleAttribute
      VerifyVOLID = False:  Exit Function
    Else
      For i = 0 To Len(Trim$(t)) - 1
        If Asc(Mid$(t, i + 1, 1)) < 48 Or Asc(Mid$(t, i + 1, 1)) > 57 Then
          MsgBox Conf.msgType & " : volid", vbCritical, Conf.titleAttribute
          VerifyVOLID = False:  Exit Function
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

Function VerifyISSUENO(t As String, Conf As clsConfig) As Boolean
  Const errIDMet As String = "11"
  '------------------------------
  On Error GoTo ERRLOG
  
  VerifyISSUENO = True
  With frmArticle.TextBox_issueno
    If Len(Trim$(t)) > 3 Then
      MsgBox Conf.msgInvalid & " : issueno", vbCritical, Conf.titleAttribute
      VerifyISSUENO = False:  Exit Function
    Else
      For i = 0 To Len(Trim$(t)) - 1
        If Asc(Mid$(t, i + 1, 1)) < 48 Or Asc(Mid$(t, i + 1, 1)) > 57 Then
          MsgBox Conf.msgType & " : issueno", vbCritical, Conf.titleAttribute
          VerifyISSUENO = False:  Exit Function
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

Function VerifyDATEISO(t As String, Conf As clsConfig) As Boolean
  Const errIDMet As String = "12"
  '------------------------------
  On Error GoTo ERRLOG
  
  VerifyDATEISO = True
  With frmArticle.TextBox_dateiso
    If Len(Trim$(t)) <> 8 Then
      MsgBox Conf.msgInvalid & " : dateiso", vbCritical, Conf.titleAttribute
      VerifyDATEISO = False:  Exit Function
    Else
      For i = 0 To Len(Trim$(t)) - 1
        If Asc(Mid$(t, i + 1, 1)) < 48 Or Asc(Mid$(t, i + 1, 1)) > 57 Then
          MsgBox Conf.msgType & " : dateiso", vbCritical, Conf.titleAttribute
          VerifyDATEISO = False:  Exit Function
        End If
      Next i
      If VerifyDateValue(t) = False Then
        MsgBox Conf.msgType & " : dateiso", vbCritical, Conf.titleAttribute
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

Function VerifySUPPLVOL(t As String, Conf As clsConfig) As Boolean
  Const errIDMet As String = "13"
  '------------------------------
  On Error GoTo ERRLOG
  
  VerifySUPPLVOL = True
  With frmArticle.TextBox_supplvol
    Select Case LCase(Trim$(t))
      Case ""
        
      Case Else
        If Len(Trim$(t)) > 3 Then
          MsgBox Conf.msgInvalid & " : supplvol", vbCritical, Conf.titleAttribute
          VerifySUPPLVOL = False:  Exit Function
        Else
          For i = 0 To Len(Trim$(t)) - 1
            If Asc(Mid$(t, i + 1, 1)) < 48 Or Asc(Mid$(t, i + 1, 1)) > 57 Then
              MsgBox Conf.msgType & " : supplvol", vbCritical, Conf.titleAttribute
              VerifySUPPLVOL = False:  Exit Function
            End If
          Next i
        End If
    End Select
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifySUPPLNO(t As String, Conf As clsConfig) As Boolean
  Const errIDMet As String = "14"
  '------------------------------
  On Error GoTo ERRLOG
  
  VerifySUPPLNO = True
  With frmArticle.TextBox_supplno
    Select Case LCase(Trim$(t))
      Case ""
        
      Case Else
        If Len(Trim$(t)) > 3 Then
          MsgBox Conf.msgInvalid & " : supplno", vbCritical, Conf.titleAttribute
          VerifySUPPLNO = False:  Exit Function
        Else
          For i = 0 To Len(Trim$(t)) - 1
            If Asc(Mid$(t, i + 1, 1)) < 48 Or Asc(Mid$(t, i + 1, 1)) > 57 Then
              MsgBox Conf.msgType & " : supplno", vbCritical, Conf.titleAttribute
              VerifySUPPLNO = False:  Exit Function
            End If
          Next i
        End If
    End Select
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyTOCCODE(Conf As clsConfig) As Boolean
  Const errIDMet As String = "15"
  '------------------------------
  On Error GoTo ERRLOG
  
  VerifyTOCCODE = True
  With frmArticle.ComboBox_toccode
    If .Enabled = True Then
      If Trim$(.text) = "" Then
        MsgBox Conf.msgType & " : toccode", vbCritical, Conf.titleAttribute
        VerifyTOCCODE = False: Exit Function
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

Function VerifyLANGUAGE(Conf As clsConfig) As Boolean
  Const errIDMet As String = "16"
  '------------------------------
  On Error GoTo ERRLOG
  
  VerifyLANGUAGE = True
  With frmArticle.ComboBox_language
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

Function VerifyTYPE(Conf As clsConfig) As Boolean
  Dim i As Integer
  Dim Failure As Boolean
  Const errIDMet As String = "17"
  '------------------------------
  On Error GoTo ERRLOG
  
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
    
    MsgBox Conf.msgInvalid & " : type", vbCritical, Conf.titleAttribute
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifySTATUS(Conf As clsConfig) As Boolean
  Const errIDMet As String = "18"
  '------------------------------
  On Error GoTo ERRLOG
  
  VerifySTATUS = True
  With frmArticle.TextBox_status
    If Trim$(.text) = "" Then
      MsgBox Conf.msgInvalid & " : status", vbCritical, Conf.titleAttribute
      VerifySTATUS = False:  Exit Function
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyVERSION(Conf As clsConfig) As Boolean
  Const errIDMet As String = "19"
  '------------------------------
  On Error GoTo ERRLOG
  
  VerifyVERSION = True
  With frmArticle.ComboBox_version
    If Trim$(.text) = "" Then
      MsgBox Conf.msgInvalid & " : version", vbCritical, Conf.titleAttribute
      .SetFocus: VerifyVERSION = False:  Exit Function
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyDOCTOPIC(Conf As clsConfig) As Boolean
  Const errIDMet As String = "20"
  '------------------------------
  On Error GoTo ERRLOG
  
  VerifyDOCTOPIC = True
  With frmArticle.ComboBox_doctopic
    If Trim$(.text) = "" Then
      MsgBox Conf.msgInvalid & " : doctopic", vbCritical, Conf.titleAttribute
      .SetFocus: VerifyDOCTOPIC = False:  Exit Function
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyCCODE(Conf As clsConfig) As Boolean
  Const errIDMet As String = "21"
  '------------------------------
  On Error GoTo ERRLOG
  
  VerifyCCODE = True
  With frmArticle.ComboBox_ccode
    If Trim$(.text) = "" Then
      MsgBox Conf.msgInvalid & " : ccode", vbCritical, Conf.titleAttribute
      .SetFocus: VerifyCCODE = False:  Exit Function
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifySTITLE(Conf As clsConfig) As Boolean
  Const errIDMet As String = "22"
  '------------------------------
  On Error GoTo ERRLOG
  
  VerifySTITLE = True
  With frmArticle.TextBox_stitle
    If Trim$(.text) = "" Then
      MsgBox Conf.msgInvalid & " : stitle", vbCritical, Conf.titleAttribute
      VerifySTITLE = False:  Exit Function
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifySECCODE(Conf As clsConfig) As Boolean
  Const errIDMet As String = "23"
  '------------------------------
  On Error GoTo ERRLOG
  
  VerifySECCODE = True
  With frmArticle.ComboBox_seccode
    If Trim$(.text) = "" Then
      MsgBox Conf.msgInvalid & " : seccode", vbCritical, Conf.titleAttribute
      .SetFocus: VerifySECCODE = False:  Exit Function
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyISSN(Conf As clsConfig) As Boolean
  Const errIDMet As String = "24"
  '------------------------------
  On Error GoTo ERRLOG
  
  VerifyISSN = True
  With frmArticle.TextBox_issn
    If Trim$(.text) = "" Then
      MsgBox Conf.msgInvalid & " : issn", vbCritical, Conf.titleAttribute
      VerifyISSN = False:  Exit Function
    End If
  End With
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Function

Function VerifyPAGES(Conf As clsConfig) As Boolean
  Dim pos As Integer, i As Integer, fim As Integer
  Dim pages As New collection, periodos As New collection
  Dim p As New collection, t As String
  Const errIDMet As String = "25"
  '------------------------------
  On Error GoTo ERRLOG
  
  VerifyPAGES = True
  With frmArticle.TextBox_pages
    t = Trim$(.text)
    If InStr(t, " ") <> 0 Then
      MsgBox Conf.msgInvalid & " : pages", vbCritical, Conf.titleAttribute
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
          MsgBox Conf.msgInvalid & " : pages", vbCritical, Conf.titleAttribute
          .SetFocus: VerifyPAGES = False: Exit Function
        Else
          pages.add t
        End If
      Else
        MsgBox Conf.msgInvalid & " : pages", vbCritical, Conf.titleAttribute
        .SetFocus: VerifyPAGES = False: Exit Function
      End If
    End If
    With pages
      For i = 1 To .count
        If InStr(1, .Item(i), "-") <> 0 Then
          p.add Mid$(.Item(i), 1, InStr(1, .Item(i), "-") - 1)
          p.add Mid$(.Item(i), InStr(1, .Item(i), "-") + 1, Len(.Item(i)) - InStr(1, .Item(i), "-"))
        Else
          MsgBox Conf.msgInvalid & " : pages", vbCritical, Conf.titleAttribute
          frmArticle.TextBox_pages.SetFocus: VerifyPAGES = False: Exit Function
        End If
      Next i
      With p
        For i = 1 To .count
          If val(.Item(i)) > val(.Item(i + 1)) Then
            MsgBox Conf.msgInvalid & " : pages", vbCritical, Conf.titleAttribute
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
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set pages = Nothing: Set periodos = Nothing: Set p = Nothing
End Function

Public Function VerifySPONSOR(Conf) As Boolean
  VerifySPONSOR = True
  With frmArticle.ComboBox_sponsor
    If Trim$(.text) = "" Then
      MsgBox Conf.msgInvalid & " : sponsor", vbCritical, Conf.titleAttribute
      VerifySPONSOR = False:  Exit Function
    End If
  End With
  Exit Function
End Function

Function VerifyRVPdate(t As String, Conf As clsConfig) As Boolean
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
        MsgBox Conf.msgType & " : rvpdate", vbCritical, Conf.titleAttribute
        frmArticle.TextBox_rvpdate.SetFocus
  End If
    
  VerifyRVPdate = r
End Function


Function VerifyAHPDate(t As String, Conf As clsConfig) As Boolean
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
        MsgBox Conf.msgType & " : ahp date", vbCritical, Conf.titleAttribute
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
  Dim i As Integer, Conf As New clsConfig
  Static ok As Boolean, issueid As String
  Const errIDMet As String = "26"
  '-----------------------------
  On Error GoTo ERRLOG
  
  Conf.LoadPublicValues
  issuel.LoadIssue Conf
    
  
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
  Set v = Nothing:  Set Conf = Nothing
  Exit Function
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set issuel = Nothing: Set issue = Nothing
  Set v = Nothing:  Set Conf = Nothing
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

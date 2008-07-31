VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Public directory As String
Public prg_name As String
Public parser As String
'-------------------------
Private language As String
Private firstHour
Private lastHour
Private markupResponsible As String
'----------------------------------
Public fileAttrib As String
Public fileBar As String
Public fileIssue As String
Public fileTemp As String
Public fileLink As String
Public fileErr As String
Public fileAutomata As String
Public fileTagsAutomata As String
'-------------------------
Public msgInvalid As String
Public msgType     As String
Public msgSelection As String
Public msgInserting As String
Public msgDeleting As String
Public msgOpenFile As String
Public msgSure As String
Public msgSureExit As String
Public msgMoreLater As String
Public msgAutomatic As String
Public msgAutomaticErr As String
Public msgDefaultDirectories As String
Public msgExit1 As String
Public msgExit2 As String
Public msgExit3 As String
Public msgAutomataFileError As String
'----------------------------
Public titleAttribute As String
Public titleTag As String
Public titleDelete As String
Public titleOpenFile As String
Public titleFinish As String
Public titleStart As String
Public titleConfig As String
Public titleErr As String
'--------------------------
Public tooltipsDown As String
Public tooltipsUp As String
'----------------------------
Public MainModule As String
'--------------------------
Public BarMarkup As String
'-------------------------
Public STAGO As String
Public ETAGO As String
Public TAGC As String
Public slash As String
Public entitySTAGO As String
Public entityTAGC As String
'---------------------
Public logExtent As String
Public txtExtent As String
'-------------------------
Public TagSize As Integer
'------------------------
Public tagConf0 As String
Public tagConf1 As String
'------------------------
Public textOK As String
Public textCANCEL As String
Public textClear As String
Public textWrite As String
Public titlefrmArticle As String
Public titleFields As String
Public titlefrmAttribute As String
Public titlefrmConfig As String
Public titleLanguage As String
Public titleResponsible As String
Public optionEnglish As String
Public optionSpanish As String
Public optionPortuguese As String
'----------------------------
Public buttonStop As String
Public buttonChange As String
Public buttonDelete As String
Public buttonAutomatic As String
Public buttonHelp As String
'--------------------------
Public fileSize As Long
'-----------------------------
Private mErr As New clsErrList
Const errIDObj As String = "208"

Public Function GetResponsible() As String
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  GetResponsible = markupResponsible
  Exit Function
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Function

Public Sub SetResponsible(mr As String)
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  markupResponsible = mr
  Exit Sub
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub

Public Function GetLanguage() As String
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo errLOG
  
  GetLanguage = language
  Exit Function
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Function

Public Sub SetLanguage(l As String)
  Const errIDMet As String = "04"
  '-----------------------------
  On Error GoTo errLOG
  
  language = l
  Exit Sub
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub

Public Sub SetFirstHour()
  Const errIDMet As String = "05"
  '-----------------------------
  On Error GoTo errLOG
  
  firstHour = Time
  Exit Sub
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub

Public Function GetFirstHour() As Variant
  Const errIDMet As String = "06"
  '-----------------------------
  On Error GoTo errLOG
  
  GetFirstHour = firstHour
  Exit Function
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Function

Public Sub SetLastHour()
  Const errIDMet As String = "07"
  '-----------------------------
  On Error GoTo errLOG
  
  lastHour = Time
  Exit Sub
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub

Public Function GetLastHour() As Variant
  Const errIDMet As String = "08"
  '-----------------------------
  On Error GoTo errLOG
  
  GetLastHour = lastHour
  Exit Function
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Function

Public Function GetMarkupTime() As String
  Dim fH, fM, fS, lH, lM, lS
  Dim TL As Long, TF As Long, t As Long
  Dim h As Integer, m As Integer, s As Integer
  Const errIDMet As String = "09"
  '-----------------------------
  On Error GoTo errLOG
  
  lH = Hour(lastHour):  lM = Minute(lastHour):  lS = Second(lastHour)
  fH = Hour(firstHour): fM = Minute(firstHour): fS = Second(firstHour)
  
  lM = lM * 60: lH = lH * 3600: TL = lH + lM + lS
  fM = fM * 60: fH = fH * 3600: TF = fH + fM + fS
  
  t = TL - TF
  
  h = t \ 3600: m = (t Mod 3600) \ 60: s = (t Mod 3600) Mod 60
  
  GetMarkupTime = str(h) & "h " & str(m) & "min " & str(s) & "s"
  Exit Function
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Function

Public Sub LoadPublicValues()
  'Const projDir = "C:\Scielo\Bin\Markup\"
  Dim projdir As String
  Const enFile = "en_conf.mds"
  Const spFile = "es_conf.mds"
  Const ptFile = "pt_conf.mds"
  Const defaultFile = "default.mds"
  Dim F As Integer
  '--------------------------------
  Dim aux As String, ok As Boolean
  Const errIDMet As String = "10"
  '-----------------------------
  On Error GoTo errLOG
  
  Dim template As template
    For Each template In Templates
    If template.Name = "markup.prg" Then
        projdir = template.Path & "\"
        'MsgBox projdir
    End If
  Next
  
  
  F = FreeFile
  Open projdir & defaultFile For Input As #F
  Input #F, aux, language
  Input #F, aux, markupResponsible
  Close #F
  '-------
  Select Case language
    Case "en"
      Open projdir & enFile For Input As #F:      ok = True
    Case "pt"
      Open projdir & ptFile For Input As #F:      ok = True
    Case "sp"
      Open projdir & spFile For Input As #F:      ok = True
  End Select
  If ok = True Then
    Input #F, aux, directory: Input #F, aux, prg_name
    Input #F, aux, parser
    Input #F, aux, fileAttrib: Input #F, aux, fileBar
    Input #F, aux, fileIssue:  Input #F, aux, fileTemp
    Input #F, aux, fileLink: Input #F, aux, fileErr
    Input #F, aux, fileAutomata: Input #F, aux, fileTagsAutomata
    Input #F, aux, msgInvalid:  Input #F, aux, msgType
    Input #F, aux, msgSelection:  Input #F, aux, msgInserting
    Input #F, aux, msgDeleting:  Input #F, aux, msgOpenFile
    Input #F, aux, msgSure: Input #F, aux, msgSureExit
    Input #F, aux, msgMoreLater: Input #F, aux, msgAutomatic
    Input #F, aux, msgAutomaticErr: Input #F, aux, msgDefaultDirectories
    Input #F, aux, msgExit1: Input #F, aux, msgExit2
    Input #F, aux, msgExit3: Input #F, aux, msgAutomataFileError
    Input #F, aux, titleAttribute: Input #F, aux, titleTag
    Input #F, aux, titleDelete: Input #F, aux, titleOpenFile
    Input #F, aux, titleFinish: Input #F, aux, titleStart
    Input #F, aux, titleConfig: Input #F, aux, titleErr
    Input #F, aux, tooltipsDown: Input #F, aux, tooltipsUp
    Input #F, aux, MainModule
    Input #F, aux, BarMarkup: Input #F, aux, STAGO
    Input #F, aux, ETAGO: Input #F, aux, TAGC
    Input #F, aux, slash
    Input #F, aux, entitySTAGO: Input #F, aux, entityTAGC
    Input #F, aux, logExtent
    Input #F, aux, txtExtent: Input #F, aux, TagSize
    Input #F, aux, tagConf0: Input #F, aux, tagConf1
    Input #F, aux, textOK: Input #F, aux, textCANCEL
    Input #F, aux, textClear: Input #F, aux, textWrite
    Input #F, aux, titlefrmArticle: Input #F, aux, titleFields
    Input #F, aux, titlefrmAttribute: Input #F, aux, titlefrmConfig
    Input #F, aux, titleLanguage: Input #F, aux, titleResponsible
    Input #F, aux, optionEnglish: Input #F, aux, optionSpanish
    Input #F, aux, optionPortuguese
    Input #F, aux, buttonStop: Input #F, aux, buttonChange
    Input #F, aux, buttonDelete: Input #F, aux, buttonAutomatic
    Input #F, aux, buttonHelp
    Close #F
  End If
  directory = projdir
  parser = Mid(LCase(directory), 1, InStr(LCase(directory), "\markup\")) & "SGMLPars\parser.exe"
  'MsgBox parser
  
  Exit Sub
errLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
  Close #F
End Sub

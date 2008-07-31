VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
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
Public msgGenerateXML As String
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
Public buttonAutomaticWS As String
Public buttonHelp As String
'--------------------------
Public fileSize As Long
'-----------------------------
Public doDebug As String


Public generateXML As Boolean
Public bodyHasChildren As String

Private mErr As New clsErrList
Const errIDObj As String = "208"

Public Function GetResponsible() As String
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo ERRLOG
  
  GetResponsible = markupResponsible
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

Public Sub SetResponsible(mr As String)
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo ERRLOG
  
  markupResponsible = mr
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

Public Function GetLanguage() As String
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo ERRLOG
  
  GetLanguage = language
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

Public Sub SetLanguage(l As String)
  Const errIDMet As String = "04"
  '-----------------------------
  On Error GoTo ERRLOG
  
  language = l
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

Public Sub SetFirstHour()
  Const errIDMet As String = "05"
  '-----------------------------
  On Error GoTo ERRLOG
  
  firstHour = Time
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

Public Function GetFirstHour() As Variant
  Const errIDMet As String = "06"
  '-----------------------------
  On Error GoTo ERRLOG
  
  GetFirstHour = firstHour
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

Public Sub SetLastHour()
  Const errIDMet As String = "07"
  '-----------------------------
  On Error GoTo ERRLOG
  
  lastHour = Time
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

Public Function GetLastHour() As Variant
  Const errIDMet As String = "08"
  '-----------------------------
  On Error GoTo ERRLOG
  
  GetLastHour = lastHour
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

Public Function GetMarkupTime() As String
  Dim fH, fM, fS, lH, lM, lS
  Dim TL As Long, TF As Long, t As Long
  Dim h As Integer, m As Integer, s As Integer
  Const errIDMet As String = "09"
  '-----------------------------
  On Error GoTo ERRLOG
  
  lH = Hour(lastHour):  lM = Minute(lastHour):  lS = Second(lastHour)
  fH = Hour(firstHour): fM = Minute(firstHour): fS = Second(firstHour)
  
  lM = lM * 60: lH = lH * 3600: TL = lH + lM + lS
  fM = fM * 60: fH = fH * 3600: TF = fH + fM + fS
  
  t = TL - TF
  
  h = t \ 3600: m = (t Mod 3600) \ 60: s = (t Mod 3600) Mod 60
  
  GetMarkupTime = str(h) & "h " & str(m) & "min " & str(s) & "s"
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

Public Sub LoadPublicValues()
  'Const projDir = "C:\Scielo\Bin\Markup\"
  Dim projdir As String
  Const enFile = "en_conf.mds"
  Const spFile = "es_conf.mds"
  Const ptFile = "pt_conf.mds"
  Const defaultFile = "default.mds"
  Dim f As Integer
  '--------------------------------
  Dim aux As String, ok As Boolean
  Const errIDMet As String = "10"
  '-----------------------------
  On Error GoTo ERRLOG

  Dim template As template
    For Each template In Templates
    If template.Name = "markup.prg" Then
        projdir = template.path & "\"
    End If
  Next

  
  f = FreeFile
  If Dir(projdir & "generateXML.ini") = "generateXML.ini" Then
    Open projdir & "generateXML.ini" For Input As #f
    Input #f, aux, aux
    Close #f
  End If
  
  generateXML = (aux = "generateXML")
   
  f = FreeFile
  Open projdir & defaultFile For Input As #f
  Input #f, aux, language
  Input #f, aux, markupResponsible
  Close #f
  '-------
  Select Case language
    Case "en"
      Open projdir & enFile For Input As #f:      ok = True
    Case "pt"
      Open projdir & ptFile For Input As #f:      ok = True
    Case "sp"
      Open projdir & spFile For Input As #f:      ok = True
  End Select
  If ok = True Then
    Input #f, aux, directory: Input #f, aux, prg_name
    Input #f, aux, parser
    Input #f, aux, fileAttrib: Input #f, aux, fileBar
    Input #f, aux, fileIssue:  Input #f, aux, fileTemp
    Input #f, aux, fileLink: Input #f, aux, fileErr
    Input #f, aux, fileAutomata: Input #f, aux, fileTagsAutomata
    Input #f, aux, msgInvalid:  Input #f, aux, msgType
    Input #f, aux, msgSelection:  Input #f, aux, msgInserting
    Input #f, aux, msgDeleting:  Input #f, aux, msgOpenFile
    Input #f, aux, msgSure: Input #f, aux, msgSureExit
    Input #f, aux, msgMoreLater: Input #f, aux, msgAutomatic
    Input #f, aux, msgAutomaticErr: Input #f, aux, msgDefaultDirectories
    Input #f, aux, msgExit1: Input #f, aux, msgExit2
    Input #f, aux, msgExit3: Input #f, aux, msgGenerateXML: Input #f, aux, msgAutomataFileError
    Input #f, aux, titleAttribute: Input #f, aux, titleTag
    Input #f, aux, titleDelete: Input #f, aux, titleOpenFile
    Input #f, aux, titleFinish: Input #f, aux, titleStart
    Input #f, aux, titleConfig: Input #f, aux, titleErr
    Input #f, aux, tooltipsDown: Input #f, aux, tooltipsUp
    Input #f, aux, MainModule
    Input #f, aux, BarMarkup: Input #f, aux, STAGO
    Input #f, aux, ETAGO: Input #f, aux, TAGC
    Input #f, aux, slash
    Input #f, aux, entitySTAGO: Input #f, aux, entityTAGC
    Input #f, aux, logExtent
    Input #f, aux, txtExtent: Input #f, aux, TagSize
    Input #f, aux, tagConf0: Input #f, aux, tagConf1
    Input #f, aux, textOK: Input #f, aux, textCANCEL
    Input #f, aux, textClear: Input #f, aux, textWrite
    Input #f, aux, titlefrmArticle: Input #f, aux, titleFields
    Input #f, aux, titlefrmAttribute: Input #f, aux, titlefrmConfig
    Input #f, aux, titleLanguage: Input #f, aux, titleResponsible
    Input #f, aux, optionEnglish: Input #f, aux, optionSpanish
    Input #f, aux, optionPortuguese
    Input #f, aux, buttonStop: Input #f, aux, buttonChange
    Input #f, aux, buttonDelete: Input #f, aux, buttonAutomatic
    Input #f, aux, buttonAutomaticWS
    Input #f, aux, buttonHelp
    Input #f, aux, bodyHasChildren
    Input #f, aux, doDebug
    Close #f
  End If
  
  directory = projdir
  
  parser = Mid(LCase(directory), 1, InStr(LCase(directory), "\bin\") - 1) & "\bin\SGMLPars\parser.exe"
  
  If doDebug = "yes" Then MsgBox parser
  
  Exit Sub
ERRLOG:
  MsgBox "error in clsConfig.LoadPublicValues" & err.Description
End
End Sub

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsErr"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Public errID As String
Public errMSG As String
Public errObjName As String
Public errMethodName As String
'--------------------------
Private mErr As New clsErrList
Const errIDObj As String = "209"

Public Sub DisplayErr(conf As clsConfig)
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  MsgBox errID & " --> " & errMSG, vbCritical, conf.titleErr
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
End Sub

Public Sub BuildErrLog(conf As clsConfig)
  Dim Filename As String, aux As String, f As Integer
  Dim m As New clsMarkup
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  f = FreeFile
  Filename = ActiveDocument.FullName
  Filename = m.BuildFilePathName(Filename, "err")
  Open Filename For Append As #f
  aux = conf.GetResponsible
  Print #f, aux
  aux = ActiveDocument.FullName
  Print #f, aux
  aux = Date
  Print #f, aux
  Print #f, Time
  Print #f,
  Print #f, errID
  Print #f, errMSG
  Print #f, errObjName
  Print #f, errMethodName
  Print #f, String(80, "*")
  Close #f
  Set m = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Close #f
  Set m = Nothing
End Sub

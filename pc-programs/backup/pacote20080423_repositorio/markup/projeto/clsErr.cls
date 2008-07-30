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

Public Sub DisplayErr(Conf As clsConfig)
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo ERRLOG
  
  MsgBox errID & " --> " & errMSG, vbCritical, Conf.titleErr
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Sub

Public Sub BuildErrLog(Conf As clsConfig)
  Dim filename As String, aux As String, f As Integer
  Dim m As New clsMarkup
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo ERRLOG
  
  f = FreeFile
  filename = ActiveDocument.FullName
  filename = m.BuildFilePathName(filename, "err")
  Open filename For Append As #f
  aux = Conf.GetResponsible
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
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Close #f
  Set m = Nothing
End Sub

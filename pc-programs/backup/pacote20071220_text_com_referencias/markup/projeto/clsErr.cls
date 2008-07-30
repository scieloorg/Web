VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsErr"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
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
  On Error GoTo errLOG
  
  MsgBox errID & " --> " & errMSG, vbCritical, Conf.titleErr
  Exit Sub
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Sub

Public Sub BuildErrLog(Conf As clsConfig)
  Dim filename As String, aux As String, F As Integer
  Dim m As New clsMarkup
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  F = FreeFile
  filename = ActiveDocument.FullName
  filename = m.BuildFilePathName(filename, "err")
  Open filename For Append As #F
  aux = Conf.GetResponsible
  Print #F, aux
  aux = ActiveDocument.FullName
  Print #F, aux
  aux = Date
  Print #F, aux
  Print #F, Time
  Print #F,
  Print #F, errID
  Print #F, errMSG
  Print #F, errObjName
  Print #F, errMethodName
  Print #F, String(80, "*")
  Close #F
  Set m = Nothing
  Exit Sub
errLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Close #F
  Set m = Nothing
End Sub

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsButton"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private tag As String
Private shortTag As String
Private color As Integer
Private repetitive As Boolean
Private attrib As Boolean
Private downLevel As String
'--------------------------
Public Count As Long
'-------------------------------------
Private mErr As New clsErrList
Const errIDObj As String = "207"

Public Sub SetTag(t As String)
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  tag = t
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

Public Sub SetShortTag(s As String)
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  shortTag = s
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

Public Sub SetColor(c As Integer)
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo errLOG
  
  color = c
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

Public Sub SetRepetitive(r As Boolean)
  Const errIDMet As String = "04"
  '-----------------------------
  On Error GoTo errLOG
  
  repetitive = r
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

Public Sub SetAttrib(a As Boolean)
  Const errIDMet As String = "05"
  '-----------------------------
  On Error GoTo errLOG
  
  attrib = a
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

Public Sub SetDownLevel(l As String)
  Const errIDMet As String = "06"
  '-----------------------------
  On Error GoTo errLOG
  
  downLevel = l
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

Public Function GetTag() As String
  Const errIDMet As String = "07"
  '-----------------------------
  On Error GoTo errLOG
  
  GetTag = tag
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

Public Function GetShortTag() As String
  Const errIDMet As String = "08"
  '-----------------------------
  On Error GoTo errLOG
  
  GetShortTag = shortTag
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

Public Function GetColor() As String
  Const errIDMet As String = "09"
  '-----------------------------
  On Error GoTo errLOG
  
  GetColor = color
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

Public Function GetRepetitive() As Boolean
  Const errIDMet As String = "10"
  '-----------------------------
  On Error GoTo errLOG
  
  GetRepetitive = repetitive
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

Public Function GetAttrib() As Boolean
  Const errIDMet As String = "11"
  '-----------------------------
  On Error GoTo errLOG
  
  GetAttrib = attrib
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

Public Function GetDownLevel() As String
  Const errIDMet As String = "12"
  '-----------------------------
  On Error GoTo errLOG
  
  GetDownLevel = downLevel
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

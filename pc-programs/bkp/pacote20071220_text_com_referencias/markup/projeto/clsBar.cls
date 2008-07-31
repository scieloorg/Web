VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsBar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private Name As String
Private UpLevel As String
Private listOfButton As New Collection
'-------------------------------------
Private mErr As New clsErrList
Const errIDObj As String = "206"

Public Sub SetName(n As String)
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  Name = n
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

Public Sub SetUpLevel(ul As String)
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  UpLevel = ul
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

Public Function GetName() As String
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo errLOG
  
  GetName = Name
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

Public Function getUpLevel() As String
  Const errIDMet As String = "04"
  '-----------------------------
  On Error GoTo errLOG
  
  getUpLevel = UpLevel
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

Public Sub InsertButton(b As clsButton, c As clsConfig)
  Const errIDMet As String = "05"
  '-----------------------------
  On Error GoTo errLOG
  
  If b.GetShortTag = c.tooltipsDown Then
    listOfButton.Add b, b.GetShortTag & b.GetDownLevel
  Else
    listOfButton.Add b, b.GetTag
  End If
  Exit Sub
errLOG:
  With mErr
    .LoadErr c
    .BuildLog errIDObj & errIDMet, c
  End With
End Sub

Public Function ReturnButton(k As String) As clsButton
  On Error Resume Next
  k = Trim$(k)
  If val(k) = 0 Then
    Set ReturnButton = listOfButton.Item(k)
    If err.Number <> 0 Then
      ReturnButton = Nothing
    End If
  Else
    Set ReturnButton = listOfButton.Item(val(k))
  End If
End Function

Public Function LenListOfButton() As Integer
  Const errIDMet As String = "06"
  '-----------------------------
  On Error GoTo errLOG
  
  LenListOfButton = listOfButton.Count
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

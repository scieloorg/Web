VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsBar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private Name As String
Private UpLevel As String
Private listOfButton As New collection
'-------------------------------------
Private mErr As New clsErrList
Const errIDObj As String = "206"

Public Sub SetName(n As String)
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo ERRLOG
  
  Name = n
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

Public Sub SetUpLevel(ul As String)
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo ERRLOG
  
  UpLevel = ul
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

Public Function GetName() As String
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo ERRLOG
  
  GetName = Name
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

Public Function getUpLevel() As String
  Const errIDMet As String = "04"
  '-----------------------------
  On Error GoTo ERRLOG
  
  getUpLevel = UpLevel
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

Public Sub InsertButton(b As clsButton, c As clsConfig)
  Const errIDMet As String = "05"
  '-----------------------------
  On Error GoTo ERRLOG
  
  If b.GetShortTag = c.tooltipsDown Then
    listOfButton.add b, b.GetShortTag & b.GetDownLevel
  Else
    listOfButton.add b, b.GetTag
  End If
  Exit Sub
ERRLOG:
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
      Set ReturnButton = Nothing
    End If
  Else
    Set ReturnButton = listOfButton.Item(val(k))
  End If
End Function

Public Function LenListOfButton() As Integer
  Const errIDMet As String = "06"
  '-----------------------------
  On Error GoTo ERRLOG
  
  LenListOfButton = listOfButton.count
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

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsLink"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Public tagName As String
Private attrList As New Collection
'---------------------------------
Private mErr As New clsErrList
Const errIDObj As String = "214"

Public Sub InsertAttr(s As String)
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  attrList.Add s, s
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

Public Function ReturnAttr(k As String) As String
  On Error Resume Next
  If val(Trim$(k)) = 0 Then
    ReturnAttr = attrList.Item(k)
    If err.Number <> 0 Then
      ReturnAttr = Empty
    End If
  Else
    ReturnAttr = attrList.Item(val(Trim$(k)))
  End If
End Function

Public Function ReturnCount() As Integer
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  ReturnCount = attrList.Count
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

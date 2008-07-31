VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsLink"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Public tagName As String
Private attrList As New collection
'---------------------------------
Private mErr As New clsErrList
Const errIDObj As String = "214"

Public Sub InsertAttr(s As String)
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  attrList.add s, s
  Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
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
  
  ReturnCount = attrList.count
  Exit Function
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Function

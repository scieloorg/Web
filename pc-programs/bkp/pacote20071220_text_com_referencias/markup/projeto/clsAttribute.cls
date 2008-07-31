VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsAttribute"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Public attrName As String
Private valueList As New Collection
'----------------------------------
Public lastInsertedValue As String
'----------------------------
Private mErr As New clsErrList
Const errIDObj As String = "202"

Public Sub InsertValue(v As clsValue)
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
 
  valueList.Add v, v.extValue
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

Public Function ReturnValue(k As String) As clsValue
  On Error Resume Next
  If val(Trim(k)) = 0 Then
    
    Set ReturnValue = valueList.Item(k)
    
    If err.Number <> 0 Then
    
      ReturnValue = Nothing
    End If
  Else
  
    Set ReturnValue = valueList.Item(val(Trim$(k)))
  End If
End Function

Public Function ReturnCount() As Integer
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
 
  ReturnCount = valueList.Count
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

Public Function GetExtVal(AbbrVal As String) As String
    Dim ExtVal As String
    Dim found As Boolean
    Dim i As Long
    
    found = False
    i = 0
    While (i < ReturnCount) And (Not found)
        i = i + 1
        If (StrComp(valueList(i).abbrValue, AbbrVal) = 0) Then
            found = True
            ExtVal = valueList(i).extValue
        End If
    Wend
    GetExtVal = ExtVal
End Function


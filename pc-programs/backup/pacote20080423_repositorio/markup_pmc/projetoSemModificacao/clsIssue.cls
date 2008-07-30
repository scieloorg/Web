VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsIssue"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public primaryKey As String
Public stitle As String
Public volid As String
Public supplvol As String
Public issueno As String
Public supplno As String
Public dateiso As String
Public issn As String
Public status As String
Private secList As New collection
'---alteracao
'---alteracao para a RSP
Public scheme As New collection
Public standard As New collection
'------------
'--------------------------------
Private mErr As New clsErrList
Const errIDObj As String = "212"

Public Sub InsertSec(s As clsValue)
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo errLOG
  
  'ha' casos que existe mais de uma seccode com o mesmo nome e valor
  'decisao tomada: chave composta => valor por extenso da sec + posicao na lista
  'secList.Add s, s.extValue
  secList.add s
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

Public Function ReturnSec(k As String) As clsValue
  On Error Resume Next
  If val(Trim$(k)) = 0 Then
    Set ReturnSec = secList.Item(k)
    If err.Number <> 0 Then
      ReturnSec = Nothing
    End If
  Else
    Set ReturnSec = secList.Item(val(Trim$(k)))
  End If
End Function

Public Function ReturnCount() As Integer
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo errLOG
  
  ReturnCount = secList.count
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

Public Function GetExtSec(AbbrVal As String) As String
    Dim ExtVal As String
    Dim found As Boolean
    Dim i As Long
    
    found = False
    i = 0
    While (i < ReturnCount) And (Not found)
        i = i + 1
        If (StrComp(secList(i).abbrValue, AbbrVal) = 0) Then
            found = True
            ExtVal = secList(i).extValue
        End If
    Wend
    GetExtSec = ExtVal
End Function



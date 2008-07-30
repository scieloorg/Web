VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsAttrList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private listattr As New collection
'---------------------------------
Private mErr As New clsErrList
Const errIDObj As String = "203"

Public Sub InsertAttr(a As clsAttribute, Optional k As String)
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo ERRLOG
  
  If k = Empty Then
    listattr.add a, a.attrName
  Else
    listattr.add a, a.attrName & k
  End If
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

Public Function ReturnAttr(k As String) As clsAttribute
  On Error Resume Next
  If val(Trim$(k)) = 0 Then
    Set ReturnAttr = listattr.Item(k)
    If err.Number <> 0 Then
      ReturnAttr = Nothing
    End If
  Else
    Set ReturnAttr = listattr.Item(val(Trim$(k)))
  End If
End Function

Public Function ReturnCount() As Integer
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo ERRLOG
  
  ReturnCount = listattr.count
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

Public Sub LoadAttributes(Conf As clsConfig)
  Dim attr As New clsAttribute, f As Integer
  Dim v As New clsValue, line2 As String, line1 As String, k As String
  Dim stg1 As New clsToken, stg2 As New clsToken, i As Integer
  Dim ok As Boolean, extV As String, abrV As String
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo ERRLOG
  
  f = FreeFile
  Open Conf.directory & Conf.fileAttrib For Input As #f
  While Not EOF(f)
    Line Input #f, line1
    If Len(Trim$(line1)) <> 0 Then
      ok = True
      attr.attrName = Trim$(line1)
      Line Input #f, line1: Line Input #f, line2
      While ok = True
        ok = stg1.GetTokens(line1, extV)
        ok = stg2.GetTokens(line2, abrV)
        v.extValue = extV: v.abbrValue = abrV
        If ok = True Or abrV <> Empty Then
          attr.InsertValue v
        End If
        Set v = Nothing
      Wend
      'With attr
      '  If .attrName = "type" Then
      '    For i = 1 To .ReturnCount
      '      If .ReturnValue(str$(i)).abbrValue = "m" Then
      '        k = "keyword": Exit For
      '      ElseIf .ReturnValue(str$(i)).abbrValue = "fig" Then
      '        k = "article": Exit For
      '      End If
      '    Next i
      '    InsertAttr attr, k
      '  Else
      InsertAttr attr
      '  End If
      'End With
      Set attr = Nothing
    End If
  Wend
  Close #f
  Set attr = Nothing: Set v = Nothing
  Set stg1 = Nothing: Set stg2 = Nothing
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Close #f
  Set attr = Nothing: Set v = Nothing
  Set stg1 = Nothing: Set stg2 = Nothing
End Sub

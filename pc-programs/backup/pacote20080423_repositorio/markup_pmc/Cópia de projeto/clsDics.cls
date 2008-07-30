VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsDics"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private directDic As New collection
Private indirectDic As New collection
Private tagsAttr1_2 As New collection
Const oldVerPath As String = "Conv\ver1_0.mds"
'Const dic10D20Path As String = "C:\Scielo\Bin\Markup\Conv\dic10d20.mds"
'Const dic10I20Path As String = "C:\Scielo\Bin\Markup\Conv\dic10i20.mds"
'Const at10_20Path As String = "C:\Scielo\Bin\Markup\Conv\10_20_at.mds"
Const dic10D20Path As String = "Conv\dic10d20.mds"
Const dic10I20Path As String = "onv\dic10i20.mds"
Const at10_20Path As String = "10_20_at.mds"

Public Sub LoadDics(conf As clsConfig)
  Dim dField As New clsDConvField, iField As New clsIConvField
  Dim f As Integer, line As String, token As New clsToken, aux As String
  '-----------------------------------------------------------
  f = FreeFile
  Open dic10D20Path For Input As #f
  While Not EOF(f)
    Line Input #f, line
    token.GetTokens line, aux
    With dField
      .oldField = aux
      token.GetTokens line, aux
      .oldRep = aux
      token.GetTokens line, aux
      .newField = aux
      token.GetTokens line, aux
      .newRep = aux
    End With
    directDic.add dField
    Set dField = Nothing
  Wend
  Close #f
  f = FreeFile
  Open dic10I20Path For Input As #f
  While Not EOF(f)
    Line Input #f, line
    token.GetTokens line, aux
    With iField
      .oldField = aux
      token.GetTokens line, aux
      .oldFather = aux
      token.GetTokens line, aux
      .oldRep = aux
      token.GetTokens line, aux
      .newField = aux
      token.GetTokens line, aux
      .newFather = aux
      token.GetTokens line, aux
      .newRep = aux
    End With
    indirectDic.add iField
    Set iField = Nothing
  Wend
  Close #f
  f = FreeFile
  Open at10_20Path For Input As #f
  While Not EOF(f)
    Input #f, aux
    tagsAttr1_2.add aux
  Wend
  Close #f
  conf.fileBar = oldVerPath
  
  Set dField = Nothing: Set iField = Nothing: Set token = Nothing
End Sub

Public Function ReturnFieldDDic(Key As Integer) As clsDConvField
  Set ReturnFieldDDic = directDic.Item(Key)
End Function

Public Function ReturnFieldIDic(Key As Integer) As clsIConvField
  Set ReturnFieldIDic = indirectDic.Item(Key)
End Function

Public Function ReturnTagAttr1_2(Key As Integer) As String
  ReturnTagAttr1_2 = tagsAttr1_2.Item(Key)
End Function

Public Function ReturnCountDDic() As Integer
  ReturnCountDDic = directDic.count
End Function

Public Function ReturnCountIDic() As Integer
  ReturnCountIDic = indirectDic.count
End Function

Public Function ReturnCountTagsAttr1_2() As Integer
  ReturnCountTagsAttr1_2 = tagsAttr1_2.count
End Function

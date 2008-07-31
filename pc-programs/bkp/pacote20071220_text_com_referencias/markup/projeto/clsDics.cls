VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsDics"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private directDic As New Collection
Private indirectDic As New Collection
Private tagsAttr1_2 As New Collection
Const oldVerPath As String = "Conv\ver1_0.mds"
'Const dic10D20Path As String = "C:\Scielo\Bin\Markup\Conv\dic10d20.mds"
'Const dic10I20Path As String = "C:\Scielo\Bin\Markup\Conv\dic10i20.mds"
'Const at10_20Path As String = "C:\Scielo\Bin\Markup\Conv\10_20_at.mds"
Const dic10D20Path As String = "Conv\dic10d20.mds"
Const dic10I20Path As String = "onv\dic10i20.mds"
Const at10_20Path As String = "10_20_at.mds"

Public Sub LoadDics(Conf As clsConfig)
  Dim dField As New clsDConvField, iField As New clsIConvField
  Dim F As Integer, Line As String, token As New clsToken, aux As String
  '-----------------------------------------------------------
  F = FreeFile
  Open dic10D20Path For Input As #F
  While Not EOF(F)
    Line Input #F, Line
    token.GetTokens Line, aux
    With dField
      .oldField = aux
      token.GetTokens Line, aux
      .oldRep = aux
      token.GetTokens Line, aux
      .newField = aux
      token.GetTokens Line, aux
      .newRep = aux
    End With
    directDic.Add dField
    Set dField = Nothing
  Wend
  Close #F
  F = FreeFile
  Open dic10I20Path For Input As #F
  While Not EOF(F)
    Line Input #F, Line
    token.GetTokens Line, aux
    With iField
      .oldField = aux
      token.GetTokens Line, aux
      .oldFather = aux
      token.GetTokens Line, aux
      .oldRep = aux
      token.GetTokens Line, aux
      .newField = aux
      token.GetTokens Line, aux
      .newFather = aux
      token.GetTokens Line, aux
      .newRep = aux
    End With
    indirectDic.Add iField
    Set iField = Nothing
  Wend
  Close #F
  F = FreeFile
  Open at10_20Path For Input As #F
  While Not EOF(F)
    Input #F, aux
    tagsAttr1_2.Add aux
  Wend
  Close #F
  Conf.fileBar = oldVerPath
  
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
  ReturnCountDDic = directDic.Count
End Function

Public Function ReturnCountIDic() As Integer
  ReturnCountIDic = indirectDic.Count
End Function

Public Function ReturnCountTagsAttr1_2() As Integer
  ReturnCountTagsAttr1_2 = tagsAttr1_2.Count
End Function

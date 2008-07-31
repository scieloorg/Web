VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsConv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private dics As New clsDics

Public Sub Conversor10_20()
  Dim Conf As New clsConfig, listBar As New clsListBar
  Dim linkl As New clsLkList, listattr As New clsAttrList
  Dim inter As New clsInterface, issuel As New clsIssueList
  Dim m As New clsMarkup, i As Integer, ok As Boolean
  Dim dField As New clsDConvField, iField As New clsIConvField
  Dim sTag As String, fTag As String, sFather As String, fFather As String
  Dim sPos As Long, fPos As Long, aux As Long
  Dim bkpSPos As Long, bkpFPos As Long
  '-----------------------------------------------
  Conf.LoadPublicValues
  linkl.LoadLink Conf: listattr.LoadAttributes Conf
  issuel.LoadIssue Conf
  dics.LoadDics Conf
  listBar.LoadBars Conf
  ok = True
  m.DisableScreen
  For i = 1 To dics.ReturnCountDDic
    Set dField = dics.ReturnFieldDDic(i)
    With Conf
      sTag = .STAGO & dField.oldField
      If dField.oldRep = False Then
        sTag = sTag & .TAGC
      End If
      fTag = .ETAGO & dField.oldField & .TAGC
    End With
    With Selection
      .start = 0: .End = 0
    End With
    Do
      With dField
        ok = m.FindText(sTag, True, sPos, fPos)
        If ok = True Then
          If .newField = Empty Then
            With Selection
              .start = sPos: .End = fPos
            End With
            With m
              .DeleteTag Conf, listBar
              .DisableScreen
            End With
          Else
            ActiveDocument.Range(start:=sPos, End:=fPos).text = .newField
            With Selection
              .start = sPos + 1: .End = .start
            End With
            ok = m.FindText(fTag, True, sPos, fPos)
            If ok = True Then
              ActiveDocument.Range(start:=sPos + 1, End:=fPos).text = .newField
            End If
            With Selection
              .start = sPos + 1: .End = .start
            End With
          End If
        End If
      End With
    Loop While ok = True
  Next i
  '-----
  m.DisableScreen
  For i = 1 To dics.ReturnCountIDic
    Set iField = dics.ReturnFieldIDic(i)
    With Conf
      sTag = .STAGO & iField.oldField
      If iField.oldRep = False Then
        sTag = sTag & .TAGC
      End If
      fTag = .ETAGO & iField.oldField & .TAGC
    End With
    With Selection
      .start = 0: .End = 0
    End With
    ok = True
    Do
      With iField
        If .oldFather = Empty Then
          ok = m.FindText(sTag, True, sPos, fPos)
          If ok = True Then
            If .oldRep = False Then
              Selection.Delete
            Else
              With Selection
                .start = .End
              End With
              ok = m.FindText(Conf.TAGC, True, , fPos)
              ActiveDocument.Range(start:=sPos - 1, End:=fPos + 1).Delete
            End If
            ok = m.FindText(fTag, True, sPos, fPos)
            If ok = True Then
              Selection.Delete
            End If
          End If
        ElseIf .newField = Empty Then
          ok = m.FindText(fTag, True, sPos, fPos)
          If ok = True Then
            sFather = Conf.STAGO & .newFather & Conf.TAGC
            With Selection
              .start = fPos: .End = .start
            End With
            ok = m.FindText(sFather, True, bkpSPos, bkpFPos)
            If ok = True Then
              ActiveDocument.Range(start:=bkpSPos - 1, End:=bkpFPos + 1).Delete
              With Selection
                m.FindText sTag, False, bkpSPos, bkpFPos
                .start = bkpSPos - 1: .End = .start
                .InsertBefore sFather
                .start = fPos + 1: .End = .start
              End With
            Else
              ok = m.FindText(sFather, False, bkpSPos, bkpFPos)
              If ok = False Then
                m.FindText sTag, False, bkpSPos, bkpFPos
                fFather = Conf.ETAGO & .newFather & Conf.TAGC
                With Selection
                  .start = fPos + 1: .End = .start
                  .InsertAfter fFather
                  .start = bkpSPos - 1: .End = .start
                  .InsertBefore sFather
                End With
              Else
                fFather = Conf.ETAGO & .newFather & Conf.TAGC
                With Selection
                  .start = fPos + 1: .End = .start
                End With
                ok = m.FindText(fFather, True, bkpSPos, bkpFPos)
                If ok = False Then
                  ok = m.FindText(fFather, False, bkpSPos, bkpFPos)
                  If ok = True Then
                    ActiveDocument.Range(start:=bkpSPos - 2, End:=bkpFPos + 1).Delete
                    m.FindText fTag, True, sPos, fPos
                    With Selection
                      .start = fPos + 1: .End = .start
                      .InsertAfter fFather
                    End With
                  Else
                    m.FindText sTag, True, sPos, fPos
                    With Selection
                      .start = fPos + 1: .End = .start
                    End With
                    m.FindText fTag, True, bkpSPos, bkpFPos
                    With Selection
                      .start = bkpFPos + 1: .End = .start
                      .InsertAfter fFather
                      .start = sPos - 1: .End = .start
                      .InsertBefore sFather
                    End With
                  End If
                Else
                  With Selection
                    .start = bkpSPos - 1: .End = .start
                  End With
                End If
              End If
            End If
          End If
        Else
          ok = m.FindText(fTag, True, sPos, fPos)
          If ok = True Then
            ActiveDocument.Range(start:=sPos + 1, End:=fPos).text = .newField
            With Selection
              sPos = .start: fPos = .End
            End With
            sFather = Conf.STAGO & .newFather & Conf.TAGC
            With Selection
              .start = fPos: .End = .start
            End With
            ok = m.FindText(sFather, True, bkpSPos, bkpFPos)
            If ok = True Then
              ActiveDocument.Range(start:=bkpSPos - 1, End:=bkpFPos + 1).Delete
              With Selection
                m.FindText sTag, False, bkpSPos, bkpFPos
                ActiveDocument.Range(start:=bkpSPos, End:=bkpFPos).text = iField.newField
                .start = bkpSPos - 1: .End = .start
                .InsertBefore sFather
                .start = fPos: .End = .start
              End With
            Else
              m.FindText sTag, False, bkpSPos, bkpFPos
              ActiveDocument.Range(start:=bkpSPos, End:=bkpFPos).text = iField.newField
              With Selection
                .start = bkpFPos + 1: .End = .start
              End With
              ok = m.FindText(sFather, False, bkpSPos, bkpFPos)
              If ok = False Then
                With Selection
                  fFather = Conf.ETAGO & iField.newFather & Conf.TAGC
                  .start = fPos: .End = .start
                  .InsertAfter fFather
                  .start = bkpSPos - 1: .End = .start
                  .InsertBefore sFather
                End With
              Else
                fFather = Conf.ETAGO & .newFather & Conf.TAGC
                With Selection
                  .start = fPos + 1: .End = .start
                End With
                ok = m.FindText(fFather, True, bkpSPos, bkpFPos)
                If ok = False Then
                  ok = m.FindText(fFather, False, bkpSPos, bkpFPos)
                  If ok = True Then
                    ActiveDocument.Range(start:=bkpSPos - 1, End:=bkpFPos + 1).Delete
                    fTag = Conf.ETAGO & .newField & Conf.TAGC
                    m.FindText fTag, True, sPos, fPos
                    With Selection
                      .start = fPos + 1: .End = .start
                      .InsertAfter fFather
                    End With
                  Else
                    m.FindText sTag, True, sPos, fPos
                    With Selection
                      .start = fPos + 1: .End = .start
                    End With
                    m.FindText fTag, True, bkpSPos, bkpFPos
                    With Selection
                      .start = bkpFPos + 1: .End = .start
                      .InsertAfter fFather
                      .start = sPos - 1: .End = .start
                      .InsertBefore sFather
                    End With
                  End If
                End If
              End If
            End If
          End If
        End If
      End With
    Loop While ok = True
  Next i
  m.EnableScreen
  '-----
  Set Conf = Nothing: Set listBar = Nothing
  Conf.LoadPublicValues: listBar.LoadBars Conf
  '-----
  For i = 1 To dics.ReturnCountTagsAttr1_2
    m.DisableScreen
    sTag = dics.ReturnTagAttr1_2(i): ok = True
    With Selection
      .start = 0: .End = 0
    End With
    Do
      frmArticle.flagConv = True
      frmAttribute.flagConv = True
      ok = m.FindText(sTag, True, sPos)
      If ok = True Then
        With Selection
          .start = sPos
        End With
        With m
          .EnableScreen
          .ChangeAttribute Conf, listBar, linkl, listattr, inter, issuel, fPos
          .DisableScreen
        End With
        With Selection
          .start = fPos: .End = fPos
        End With
      End If
    Loop While ok = True
  Next i
  
  Set Conf = Nothing: Set listBar = Nothing: Set m = Nothing
  Set dField = Nothing: Set iField = Nothing: Set linkl = Nothing
  Set listattr = Nothing: Set inter = Nothing: Set issuel = Nothing
End Sub

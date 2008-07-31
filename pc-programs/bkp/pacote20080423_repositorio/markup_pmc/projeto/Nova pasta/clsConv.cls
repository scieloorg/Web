VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsConv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private dics As New clsDics

Public Sub Conversor10_20()
  Dim conf As New clsConfig, listbar As New clsListBar
  Dim linkl As New clsLkList, listattr As New clsAttrList
  Dim inter As New clsInterface, issuel As New clsIssueList
  Dim m As New clsMarkup, i As Integer, ok As Boolean
  Dim dField As New clsDConvField, iField As New clsIConvField
  Dim sTag As String, fTag As String, sFather As String, fFather As String
  Dim sPos As Long, fPos As Long, aux As Long
  Dim bkpSPos As Long, bkpFPos As Long
  '-----------------------------------------------
  conf.LoadPublicValues
  linkl.LoadLink conf: listattr.LoadAttributes conf
  issuel.LoadIssue conf
  dics.LoadDics conf
  listbar.LoadBars conf
  ok = True
  m.DisableScreen
  For i = 1 To dics.ReturnCountDDic
    Set dField = dics.ReturnFieldDDic(i)
    With conf
      sTag = .STAGO & dField.oldField
      If dField.oldRep = False Then
        sTag = sTag & .TAGC
      End If
      fTag = .ETAGO & dField.oldField & .TAGC
    End With
    With selection
      .start = 0: .End = 0
    End With
    Do
      With dField
        ok = m.findText(sTag, True, sPos, fPos)
        If ok = True Then
          If .newField = Empty Then
            With selection
              .start = sPos: .End = fPos
            End With
            With m
              .DeleteTag conf, listbar
              .DisableScreen
            End With
          Else
            ActiveDocument.range(start:=sPos, End:=fPos).text = .newField
            With selection
              .start = sPos + 1: .End = .start
            End With
            ok = m.findText(fTag, True, sPos, fPos)
            If ok = True Then
              ActiveDocument.range(start:=sPos + 1, End:=fPos).text = .newField
            End If
            With selection
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
    With conf
      sTag = .STAGO & iField.oldField
      If iField.oldRep = False Then
        sTag = sTag & .TAGC
      End If
      fTag = .ETAGO & iField.oldField & .TAGC
    End With
    With selection
      .start = 0: .End = 0
    End With
    ok = True
    Do
      With iField
        If .oldFather = Empty Then
          ok = m.findText(sTag, True, sPos, fPos)
          If ok = True Then
            If .oldRep = False Then
              selection.Delete
            Else
              With selection
                .start = .End
              End With
              ok = m.findText(conf.TAGC, True, , fPos)
              ActiveDocument.range(start:=sPos - 1, End:=fPos + 1).Delete
            End If
            ok = m.findText(fTag, True, sPos, fPos)
            If ok = True Then
              selection.Delete
            End If
          End If
        ElseIf .newField = Empty Then
          ok = m.findText(fTag, True, sPos, fPos)
          If ok = True Then
            sFather = conf.STAGO & .newFather & conf.TAGC
            With selection
              .start = fPos: .End = .start
            End With
            ok = m.findText(sFather, True, bkpSPos, bkpFPos)
            If ok = True Then
              ActiveDocument.range(start:=bkpSPos - 1, End:=bkpFPos + 1).Delete
              With selection
                m.findText sTag, False, bkpSPos, bkpFPos
                .start = bkpSPos - 1: .End = .start
                .InsertBefore sFather
                .start = fPos + 1: .End = .start
              End With
            Else
              ok = m.findText(sFather, False, bkpSPos, bkpFPos)
              If ok = False Then
                m.findText sTag, False, bkpSPos, bkpFPos
                fFather = conf.ETAGO & .newFather & conf.TAGC
                With selection
                  .start = fPos + 1: .End = .start
                  .InsertAfter fFather
                  .start = bkpSPos - 1: .End = .start
                  .InsertBefore sFather
                End With
              Else
                fFather = conf.ETAGO & .newFather & conf.TAGC
                With selection
                  .start = fPos + 1: .End = .start
                End With
                ok = m.findText(fFather, True, bkpSPos, bkpFPos)
                If ok = False Then
                  ok = m.findText(fFather, False, bkpSPos, bkpFPos)
                  If ok = True Then
                    ActiveDocument.range(start:=bkpSPos - 2, End:=bkpFPos + 1).Delete
                    m.findText fTag, True, sPos, fPos
                    With selection
                      .start = fPos + 1: .End = .start
                      .InsertAfter fFather
                    End With
                  Else
                    m.findText sTag, True, sPos, fPos
                    With selection
                      .start = fPos + 1: .End = .start
                    End With
                    m.findText fTag, True, bkpSPos, bkpFPos
                    With selection
                      .start = bkpFPos + 1: .End = .start
                      .InsertAfter fFather
                      .start = sPos - 1: .End = .start
                      .InsertBefore sFather
                    End With
                  End If
                Else
                  With selection
                    .start = bkpSPos - 1: .End = .start
                  End With
                End If
              End If
            End If
          End If
        Else
          ok = m.findText(fTag, True, sPos, fPos)
          If ok = True Then
            ActiveDocument.range(start:=sPos + 1, End:=fPos).text = .newField
            With selection
              sPos = .start: fPos = .End
            End With
            sFather = conf.STAGO & .newFather & conf.TAGC
            With selection
              .start = fPos: .End = .start
            End With
            ok = m.findText(sFather, True, bkpSPos, bkpFPos)
            If ok = True Then
              ActiveDocument.range(start:=bkpSPos - 1, End:=bkpFPos + 1).Delete
              With selection
                m.findText sTag, False, bkpSPos, bkpFPos
                ActiveDocument.range(start:=bkpSPos, End:=bkpFPos).text = iField.newField
                .start = bkpSPos - 1: .End = .start
                .InsertBefore sFather
                .start = fPos: .End = .start
              End With
            Else
              m.findText sTag, False, bkpSPos, bkpFPos
              ActiveDocument.range(start:=bkpSPos, End:=bkpFPos).text = iField.newField
              With selection
                .start = bkpFPos + 1: .End = .start
              End With
              ok = m.findText(sFather, False, bkpSPos, bkpFPos)
              If ok = False Then
                With selection
                  fFather = conf.ETAGO & iField.newFather & conf.TAGC
                  .start = fPos: .End = .start
                  .InsertAfter fFather
                  .start = bkpSPos - 1: .End = .start
                  .InsertBefore sFather
                End With
              Else
                fFather = conf.ETAGO & .newFather & conf.TAGC
                With selection
                  .start = fPos + 1: .End = .start
                End With
                ok = m.findText(fFather, True, bkpSPos, bkpFPos)
                If ok = False Then
                  ok = m.findText(fFather, False, bkpSPos, bkpFPos)
                  If ok = True Then
                    ActiveDocument.range(start:=bkpSPos - 1, End:=bkpFPos + 1).Delete
                    fTag = conf.ETAGO & .newField & conf.TAGC
                    m.findText fTag, True, sPos, fPos
                    With selection
                      .start = fPos + 1: .End = .start
                      .InsertAfter fFather
                    End With
                  Else
                    m.findText sTag, True, sPos, fPos
                    With selection
                      .start = fPos + 1: .End = .start
                    End With
                    m.findText fTag, True, bkpSPos, bkpFPos
                    With selection
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
  Set conf = Nothing: Set listbar = Nothing
  conf.LoadPublicValues: listbar.LoadBars conf
  '-----
  For i = 1 To dics.ReturnCountTagsAttr1_2
    m.DisableScreen
    sTag = dics.ReturnTagAttr1_2(i): ok = True
    With selection
      .start = 0: .End = 0
    End With
    Do
      frmArticle.flagConv = True
      frmAttribute.flagConv = True
      ok = m.findText(sTag, True, sPos)
      If ok = True Then
        With selection
          .start = sPos
        End With
        With m
          .EnableScreen
          .ChangeAttribute conf, listbar, linkl, listattr, inter, issuel, fPos
          .DisableScreen
        End With
        With selection
          .start = fPos: .End = fPos
        End With
      End If
    Loop While ok = True
  Next i
  
  Set conf = Nothing: Set listbar = Nothing: Set m = Nothing
  Set dField = Nothing: Set iField = Nothing: Set linkl = Nothing
  Set listattr = Nothing: Set inter = Nothing: Set issuel = Nothing
End Sub

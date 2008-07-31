VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsMarkupBody"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private mvarMarkupRange As clsMarkupRange

Property Get MarkupRange() As clsMarkupRange
    Set MarkupRange = mvarMarkupRange
End Property

Property Set MarkupRange(v As clsMarkupRange)
    Set mvarMarkupRange = v
End Property




Function markupBody(range As range) As range
'MsgBox "Paragraphs"
    Dim s As Long
    Dim e As Long
    Dim mft As New clsMarkupFigTab
    
    Set mft.MarkupRange = MarkupRange

    s = range.start
    
    Set range = markupParagraphs(range)
    Set range = markupHyperLinks(range)
    Set range = markupGraphics(range)
    Set range = markupTables(range)
    Set range = mft.fixFigTable(range)
    
    Call range.SetRange(s, range.End)
    Set markupBody = range
End Function

Function markupHyperLinks(range As range) As range
    Dim i As Long
    For i = 1 To range.Hyperlinks.count
        content = Trim(LCase(range.Hyperlinks(i).range.text))
        
        If range.Hyperlinks(i).Address = "" Then
            ' link no proprio documento
            Call markupAsInternalLink(range.Hyperlinks(i))
        Else
            ' link externo
            Call markupAsExternalLink(range.Hyperlinks(i))
        End If
    Next
    Set markupHyperLinks = range
End Function

Sub markupAsInternalLink(hpl As Hyperlink)
    Dim content As String, reftype As String, tag As String, attributes As String
    Dim rid As String

    tag = "xref"
    content = Trim(LCase(hpl.range.text))
    If InStr(content, "fig") > 0 Then
        reftype = "fig"
    ElseIf InStr(content, "tab") > 0 Then
        reftype = "tab"
    Else
        If content Like myReplace(Space(Len(content)), " ", "#") Then
            reftype = "bibr"
        Else
        End If
    End If
    
    
    If InStr(content, " ") > 0 Then
        rid = Mid(content, InStr(content, " ") + 1)
    Else
        rid = content
    End If
    attributes = "ref-type=" & Chr(34) & reftype & Chr(34) & " " & "rid=" & Chr(34) & UCase(Mid(reftype, 1, 1)) & rid & Chr(34)
    If MarkupRange.CheckInsertTag(hpl.range, tag) Then
        Call MarkupRange.InsertTag(hpl.range, tag, 14, attributes)
    End If
End Sub
Sub markupAsExternalLink(hpl As Hyperlink)
    Dim tag As String, attributes As String
    
    tag = "uri"
    attributes = "href=" & Chr(34) & hpl.Address & Chr(34)
    If MarkupRange.CheckInsertTag(hpl.range, tag) Then
        Call MarkupRange.InsertTag(hpl.range, tag, 14, attributes)
    End If
End Sub
Function markupGraphics(range As range) As range
    Dim i As Long, content As String, reftype As String, tag As String, attributes As String
    
    Dim rid As String
    Dim v As String
    
    tag = "graphic"
    For i = 1 To range.InlineShapes.count
        'attributes = " xlink:href=" & Chr(34) & range.InlineShapes(i).Hyperlink & Chr(34)
        Select Case range.InlineShapes(i).Type
        Case wdInlineShapeLinkedPicture
            v = range.InlineShapes(i).LinkFormat.SourceFullName
        Case wdInlineShapePicture
            v = range.InlineShapes(i).LinkFormat.SourceFullName
            
        End Select
        
        attributes = " href=" & Chr(34) & v & Chr(34)
        Call MarkupRange.InsertTag(range.InlineShapes(i).range, tag, 14, attributes)
    Next
    Set markupGraphics = range
End Function
Function markupTables(range As range) As range
    Dim i As Long, content As String, reftype As String, tag As String, attributes As String
    
    Dim rid As String
    Dim RowIdx As Long
    Dim CelIdx As Long
    
    tag = "table"
    For i = 1 To range.tables.count
        For RowIdx = 1 To range.tables(i).Rows.count
            For CelIdx = 1 To range.tables(i).Rows(RowIdx).Cells.count
                Call MarkupRange.InsertTag(range.tables(i).Rows(RowIdx).Cells(CelIdx).range, "td", 14, "")
            Next
            Call MarkupRange.InsertTag(range.tables(i).Rows(RowIdx).range, "tr", 14, "")
        Next
        Call MarkupRange.InsertTag(range.tables(i).range, tag, 14, attributes)
        'Call MarkupRange.InsertTag(range.tables(i).range, "p", 14, attributes)
    Next
    Set markupTables = range
End Function

Function markupParagraphs(selectedRange As range) As range
    Dim i As Long
    
    Dim line As String
    Dim attributes As String
    
    Dim openSection As Boolean
    Dim openSubSection As Boolean
    Dim secId As String
    
    Dim insertedText As String
    
    Dim BeforeTextLen As Long
    Dim AfterTextLen As Long
        
    Dim paragraphRange As range
    
    Dim start As Long
    Dim sectag As String
    
    start = selectedRange.start - 1
    
    For i = 1 To selectedRange.Paragraphs.count
'MsgBox i
        insertedText = ""
        With selectedRange.Paragraphs(i)
'MsgBox .range.text
            
        line = .range.text

        Set paragraphRange = .range
        
'MsgBox Len(.range.text) & "  [" & .range.text & "]"
        
        If isSectionTitle(paragraphRange) Then
            ' paragrafo curto, possivelmente eh uma secao ou subsecao iniciando
            secId = getSectionId(line)
            If openSubSection Then
                ' Insere o fim de uma subsection
                insertedText = insertedText & MarkupRange.BuildFinishTag("subsec")
                openSubSection = False
            End If
            
            If openSection And secId <> "" Then
                ' Insere o fim de uma section
                insertedText = insertedText & MarkupRange.BuildFinishTag("sec")
                openSection = False
            End If
            
            ' Obtem os atributos da nova secao
            If openSection Then
                attributes = ""
                openSubSection = True
                sectag = "subsec"
            Else
                openSection = True
                sectag = "sec"
                If secId <> "" Then
                    attributes = "sec-type=" & Chr(34) & secId & Chr(34)
                End If
            End If
            
            pStart = .range.start
            
            
            ' Insere o início da tag sec, com ou sem atributos
            insertedText = insertedText & MarkupRange.BuildStartTag(sectag, attributes)
                
            ' Insere o início da tag title
            insertedText = insertedText & MarkupRange.BuildStartTag("sectitle", "")
            BeforeTextLen = Len(insertedText)
            .range.InsertBefore (insertedText)
            
            ' Insere o fim da tag title
            insertedText = MarkupRange.BuildFinishTag("sectitle")
            AfterTextLen = Len(insertedText)
            
            Call paragraphRange.SetRange(.range.start, .range.End - 1)
            paragraphRange.InsertAfter (insertedText)
            
        
        Else
            Call MarkupRange.InsertTag(.range, "p", 10, "")
        End If
    End With
    Next
    insertedText = ""
    If openSubSection Then
        insertedText = insertedText & MarkupRange.BuildFinishTag("subsec")
    End If
    If openSection Then
        insertedText = insertedText & MarkupRange.BuildFinishTag("sec")
    End If
    If Len(insertedText) > 0 Then
        Call paragraphRange.SetRange(paragraphRange.End, paragraphRange.End)
        paragraphRange.InsertAfter (insertedText)
        MarkupRange.FormatText paragraphRange, 10
    End If
    
    Call selectedRange.SetRange(start, paragraphRange.End)
    Set markupParagraphs = selectedRange
End Function
Private Function isSectionTitle(paragraphRange As range) As Boolean
    Dim r As Boolean
    
    If (Len(paragraphRange.text) < 30 And Len(paragraphRange.text) > 2) Then
        If paragraphRange.tables.count = 0 Then
            r = True
        End If
    End If
    isSectionTitle = r
End Function
Private Sub show(range As range, ByVal start As Long, ByVal endx As Long, label As String)
    Dim s As Long, e As Long
    
    s = range.start
    e = range.End
    
    range.start = start
    range.End = endx
    
    MsgBox label & vbCrLf & range.text
    
    range.start = s
    range.End = e
End Sub




Private Function getSectionId(section As String) As String
    Dim r As String
    section = myReplace(Trim(section), Chr(160), "")
    
    If InStr(1, section, "introdu", vbTextCompare) = 1 Then
        r = "intro"
    Else
        If InStr(1, section, "conclus", vbTextCompare) = 1 Then
            r = "conclusions"
        Else
            If InStr(1, section, "discus", vbTextCompare) = 1 Then
                r = "discussion"
            Else
                If InStr(1, section, "materia", vbTextCompare) = 1 Then
                    r = "materials"
                Else
                    If InStr(1, section, "method", vbTextCompare) = 1 Or InStr(1, section, "métodos", vbTextCompare) = 1 Then
                        r = "methods"
                    Else
                        If InStr(1, section, "result", vbTextCompare) = 1 Then
                            r = "results"
                        Else
                            If InStr(1, section, "subjects", vbTextCompare) = 1 Then
                                r = "subjects"
                            Else
                                If InStr(1, section, "supplementary-material", vbTextCompare) = 1 Then
                                    r = "supplementary-material"
                                Else
                                                                
                                
                                End If
                            End If
                        End If
                    End If
                End If
            End If
        End If
    End If
    'MsgBox "[" & section & "]" & r
    getSectionId = r
End Function



Private Function formattag(ByVal tag As String, Document As range) As String
   Document.text = tag
  Call MarkupRange.FormatText(Document, 3)
formattag = Document.text

End Function


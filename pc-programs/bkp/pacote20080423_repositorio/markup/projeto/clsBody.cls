VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsBody"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private mvarMarkupRange As clsMarkupRange
Private mvarListBar As clsListBar

Property Get MarkupRange() As clsMarkupRange
    Set MarkupRange = mvarMarkupRange
End Property

Property Set MarkupRange(v As clsMarkupRange)
    Set mvarMarkupRange = v
End Property

Property Get listBar() As clsListBar
    Set listBar = mvarListBar
End Property

Property Set listBar(v As clsListBar)
    Set mvarListBar = v
End Property

Function markupBody(range As range) As range
    
    Set range = markupParagraphs(range)
    Set range = markupHyperLinks(range)
    Set range = markupFigures(range)
    Set range = markupTables(range)
    Set markupBody = range
End Function

Function markupHyperLinks(range As range) As range
    Dim i As Long, content As String, reftype As String, tag As String, attributes As String
    
    Dim rid As String

    tag = "xref"
    For i = 1 To range.Hyperlinks.count
        content = Trim(LCase(range.Hyperlinks(i).range.text))
        
        If InStr(content, "fig") > 0 Then
            reftype = "fig"
        ElseIf InStr(content, "tab") > 0 Then
            reftype = "tab"
        Else
            reftype = ""
        End If
        
        
        If InStr(content, " ") > 0 Then
            rid = Mid(content, InStr(content, " ") + 1)
        Else
            rid = content
        End If
        attributes = "ref-type=" & Chr(34) & reftype & Chr(34) & " " & "rid=" & Chr(34) & UCase(Mid(reftype, 1, 1)) & rid & Chr(34)
        If MarkupRange.CheckInsertTag(range.Hyperlinks(i).range, tag) Then
        Call MarkupRange.InsertTag(range.Hyperlinks(i).range, tag, 14, attributes)
        End If
    Next
    Set markupHyperLinks = range
End Function

Function markupFigures(range As range) As range
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
        
        attributes = " xlink:href=" & Chr(34) & v & Chr(34)
        Call MarkupRange.InsertTag(range.InlineShapes(i).range, tag, 14, attributes)
    Next
    Set markupFigures = range
End Function
Function markupTables(range As range) As range
    Dim i As Long, content As String, reftype As String, tag As String, attributes As String
    
    Dim rid As String
    
    tag = "table"
    For i = 1 To range.tables.count
        Call MarkupRange.InsertTag(range.tables(i).range, tag, 14, attributes)
    Next
    Set markupTables = range
End Function

Function markupParagraphs(range As range) As range
    Dim i As Long
    
    Dim Line As String
    Dim attributes As String
    
    Dim openSection As Boolean
    Dim openSubSection As Boolean
    Dim secId As String
    
    Dim insertedText As String
    
    Dim BeforeTextLen As Long
    Dim AfterTextLen As Long
        
    Dim rangeParagraph As range
    
    Dim start As Long
    start = range.start
    
    For i = 1 To range.Paragraphs.count
        insertedText = ""
        With range.Paragraphs(i)
        Line = .range.text
        Set rangeParagraph = .range
        
        ' MsgBox Len(.range.text) & "  [" & .range.text & "]"
        
        If Len(Line) < 30 And Len(Line) > 2 Then
            ' paragrafo curto, possivelmente eh uma secao ou subsecao iniciando
            secId = getSectionId(Line)
            If openSubSection Then
                ' Insere o fim de uma subsection
                insertedText = insertedText & MarkupRange.BuildFinishTag("sec")
                openSubSection = False
            End If
            
            If openSection And secId <> "" Then
                ' Insere o fim de uma section
                insertedText = insertedText & MarkupRange.BuildFinishTag("sec")
                openSection = False
            End If
            
            ' Obtem os atributos da nova secao
            If secId <> "" Then
                openSection = True
                attributes = " sec-type=" & Chr(34) & secId & Chr(34)
            Else
                attributes = ""
                openSubSection = True
            End If
            
            pStart = .range.start
            
            
            ' Insere o início da tag sec, com ou sem atributos
            insertedText = insertedText & MarkupRange.BuildStartTag("sec", attributes)
                
            ' Insere o início da tag title
            insertedText = insertedText & MarkupRange.BuildStartTag("title", "")
            BeforeTextLen = Len(insertedText)
            .range.InsertBefore (insertedText)
            
            ' Insere o fim da tag title
            insertedText = MarkupRange.BuildFinishTag("title")
            AfterTextLen = Len(insertedText)
            
            Call rangeParagraph.SetRange(.range.start, .range.End - 1)
            rangeParagraph.InsertAfter (insertedText)
            
        
        Else
            Call MarkupRange.InsertTag(.range, "p", 10, "")
        End If
    End With
    Next
    insertedText = ""
    If openSubSection Then
        insertedText = insertedText & MarkupRange.BuildFinishTag("sec")
    End If
    If openSection Then
        insertedText = insertedText & MarkupRange.BuildFinishTag("sec")
    End If
    Call rangeParagraph.SetRange(range.Paragraphs(range.Paragraphs.count).range.start, range.Paragraphs(range.Paragraphs.count).range.End - 1)
    rangeParagraph.InsertAfter (insertedText)
    Call range.SetRange(start, rangeParagraph.End)
    Set markupParagraphs = range
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




Private Function getSectionId(section) As String
    Dim r As String
    
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
    getSectionId = r
End Function



Private Function formattag(ByVal tag As String, Document As range) As String
   Document.text = tag
  Call MarkupRange.FormatText(Document, 3)
formattag = Document.text

End Function


VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClsArticleAction"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private ArticleDAO As New ClsArticleDAO
Private ArchiveDAO As New ClsArticleDAO
Private dirStructure As New ClsRelatedIssues



Function init(relatedissues As ClsRelatedIssues) As Boolean
    Set dirStructure = relatedissues
    With relatedissues
    If Not (.archive Is Nothing) Then
        If Not DirExist(.archive.getBasePath) Then
            MakeDir (.archive.getBasePath)
        End If
        If Not FileExist("", .archive.getBaseFile & ".fst") Then
            Call FileCopy(.Issue.getBaseFile & ".fst", .archive.getBaseFile & ".fst")
        End If
        Call ArchiveDAO.setData(.archive.getBasePath, .archive.getBaseFileName, "")
    End If
    Call ArticleDAO.setData(.Issue.getBasePath, .Issue.getBaseFileName, "")
    End With
End Function
'--------------------------------------------------------------------------------
'OrderCheck - Check if the order of document is valid
'MarkupDocId  - document identification
'MarkupDocOrder   - order of the document
'Return     - <True> to success, <False> to failure
'--------------------------------------------------------------------------------
' FIXED_20070115 ahead of print - atributo order deve ter até 5 digitos
'--------------------------------------------------------------------------------
Function OrderCheck(MarkupDocId As String, markupDocOrder As String) As Boolean
    Dim RangeOK As Boolean
    Dim DocumentAndOrderMatch As Boolean
    Dim freeOrder As Boolean
    Dim i_order As Long
    Dim totalOfDocuments As Long
    Dim formatOk As Boolean
    Dim formated As String
    
    Dim i As Long
    Dim article As ClsArticle
    
    Dim docOrder As New ClDocOrder
    
    Set article = New ClsArticle
    article.filename = MarkupDocId
    
    Set article = findArticle(article)
    
    If IsNumber(markupDocOrder) Then i_order = CLng(markupDocOrder)
    totalOfDocuments = ArticleDAO.getDocCounter()
        
    'Check the range
    If (i_order > 0) And (i_order <= totalOfDocuments) Then
        RangeOK = True
        
        'Verifica se existe o documento na base
        If article Is Nothing Then
            'Não existe o documento
        Else
            'Existe, verificar se o order se mantém
            If i_order = CLng(article.order) Then
                DocumentAndOrderMatch = True
            End If
        End If
        
        If Not DocumentAndOrderMatch Then
            'Verifica se o order pertence a outro documento
            Dim otherArticle As ClsArticle
            freeOrder = isFreeOrder(markupDocOrder, otherArticle)
            If freeOrder Then
                            
            Else
                ' order pertence a outro documento
                If otherArticle.order <> "" Then
                    ' apresentar mensagem que o documento possui um order na base diferente do que está no markup
                    Call Msg.GiveRunInformation(otherArticle.order + " " + InterfaceLabels("MsgInvalidDocOrder").elem2 + MarkupDocId)
                End If
                ' apresentar mensagem que o order pertence a outro documento
                Call Msg.GiveRunInformation(otherArticle.filename + " " + InterfaceLabels("MsgDBDocOrder").elem2 + markupDocOrder)
            End If
        End If
                
        If DocumentAndOrderMatch Or freeOrder Then
            'Check format/number of digits expected for the order of the document
            formated = docOrder.formatOrder(markupDocOrder)
            If Len(formated) > 0 Then markupDocOrder = formated
        End If
    Else
        Call Msg.GiveRunInformation(InterfaceLabels("MsgDocOrderRange").elem2 + " [1-" + CStr(totalOfDocuments) + "].")
        RangeOK = False
    End If
        

    OrderCheck = (RangeOK And (DocumentAndOrderMatch Or freeOrder))
End Function
'--------------------------------------------------------------------------------
'OrderCheck - Check if the order of document is valid
'MarkupDocId  - document identification
'MarkupDocOrder   - order of the document
'Return     - <True> to success, <False> to failure
'--------------------------------------------------------------------------------
' FIXED_20070115 ahead of print - atributo order deve ter até 5 digitos
'--------------------------------------------------------------------------------

Private Function isFreeOrder(markupDocOrder As String, otherArticle As ClsArticle) As Boolean
    
    Dim freeOrder As Boolean
    
    Set otherArticle = ArticleDAO.getDocumentByOrder(markupDocOrder)
    If Len(otherArticle.order) = 0 Then
        If ArchiveDAO Is Nothing Then
            freeOrder = True
        Else
            Set otherArticle = ArchiveDAO.getDocumentByOrder(markupDocOrder)
            If Len(otherArticle.order) = 0 Then
                freeOrder = True
            End If
        End If
    End If
    
    isFreeOrder = freeOrder
End Function


Function findArticle(article As ClsArticle) As ClsArticle
    Dim a As ClsArticle
    
    
    Set a = ArticleDAO.getDocument(article.filename)
    If a Is Nothing Then
        ArchiveDAO.myIssueOrder = ArticleDAO.getIssueOrder
        Set a = ArchiveDAO.getDocument(article.filename)
        If Not (a Is Nothing) Then
            a.IsArchived = True
        End If
    End If
    Set findArticle = a
End Function

Function archive(article As ClsArticle) As Boolean
    Dim r As Boolean
    Dim previousContent As String
    
    r = dirStructure.archiveFile(article.filename, article.filename)
    previousContent = ArticleDAO.getRecordContent(article.filename)
    If ArchiveDAO.ImportRecord(previousContent, article.filename, article.order) Then
        r = ArticleDAO.Delete(article.filename)
    Else
        r = True
    End If
    archive = r
End Function


Function checkPreviousArticle(PreviousIssue As ClsRelatedIssues, article As ClsArticle) As ClsArticle
    Dim PreviousArticleAction As New ClsArticleAction
    
    If FileExist(PreviousIssue.Issue.getBasePath, PreviousIssue.Issue.getBaseFileName + ".mst") Then
        PreviousIssue.setArchive
            
        Call PreviousArticleAction.init(PreviousIssue)
        Set checkPreviousArticle = PreviousArticleAction.findArticle(article)
            
    End If
End Function


Function FindPreviousArticle(article As ClsArticle, PreviousIssue As ClsRelatedIssues) As ClsArticle
    Dim outIssue As String
    Dim outYear As String
    Dim rules As ClsIssueDirNameRules
    Dim foundDocument As ClsArticle
    
    
    Set rules = New ClsIssueDirNameRules
    If rules.identifyPreviousIssueData(article.IssueNo, article.VersionHistory.RVPDate, article.VersionHistory.AHPDate, outIssue, outYear) Then
        
        Set PreviousIssue = New ClsRelatedIssues
        Set PreviousIssue.Issue = New ClIssueDirStructure
        
        PreviousIssue.Issue.journalPath = dirStructure.Issue.journalPath
        PreviousIssue.Issue.issueDir = rules.createIssueDir(outIssue, outYear, False)
        
        Set foundDocument = checkPreviousArticle(PreviousIssue, article)
        If foundDocument Is Nothing And outYear = "2008" Then
            outYear = ""
            PreviousIssue.Issue.issueDir = rules.createIssueDir(outIssue, outYear, False)  'test outYear = 2007 or nothing
            Set foundDocument = checkPreviousArticle(PreviousIssue, article)
        End If
        
    End If
    Set FindPreviousArticle = foundDocument
    
    
'If Not (foundDocument Is Nothing) Then
 '           hasOldPid = foundDocument.pid
  '          Call PreviousArticleAction.importPreviousPIDs(SciELODoc.article, foundDocument)
   '     End If
End Function

Sub importPreviousPIDs(currentArticle As ClsArticle, previousArticle As ClsArticle)
    If previousArticle.IssueNo = "ahead" Then
        currentArticle.VersionHistory.AHP_PID = previousArticle.pid
        currentArticle.VersionHistory.RVP_PID = previousArticle.VersionHistory.RVP_PID
        If Len(currentArticle.VersionHistory.RVPDate) = 0 Then
            currentArticle.VersionHistory.RVPDate = previousArticle.VersionHistory.RVPDate
        End If
        If Len(currentArticle.VersionHistory.AHPDate) = 0 Then
            currentArticle.VersionHistory.AHPDate = previousArticle.VersionHistory.AHPDate
        End If
    ElseIf previousArticle.IssueNo = "review" Then
        currentArticle.VersionHistory.RVP_PID = previousArticle.pid
        If Len(currentArticle.VersionHistory.RVPDate) = 0 Then
        currentArticle.VersionHistory.RVPDate = previousArticle.VersionHistory.RVPDate
        End If
    End If
End Sub


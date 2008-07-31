VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClsArticle"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private mvarOrder As String
Private mvarFilename As String
Private mvarMfn As String
Private mvarVersionHistory As ClsArticleVersionHistory
Private mvartitle As String
Private mvarsurname As String
Private mvarIssueNo As String
Private mvarDateISO As String

Private mvarIsArchived As Boolean


Private mvarPID As String

Public Property Get pid() As String
    pid = mvarPID
End Property

Public Property Let pid(ByVal vNewValue As String)
    mvarPID = vNewValue
End Property

Public Property Get IsArchived() As Boolean
    IsArchived = mvarIsArchived
End Property

Public Property Let IsArchived(ByVal vNewValue As Boolean)
    mvarIsArchived = vNewValue
End Property

Public Property Get Mfn() As String
    Mfn = mvarMfn
End Property

Public Property Let Mfn(ByVal vNewValue As String)
    mvarMfn = vNewValue
End Property

Public Property Get order() As String
    order = mvarOrder
End Property

Public Property Let order(ByVal vNewValue As String)
    mvarOrder = vNewValue
End Property

Public Property Get filename() As String
filename = mvarFilename
End Property

Public Property Let filename(ByVal vNewValue As String)
mvarFilename = vNewValue
End Property

Public Property Get VersionHistory() As ClsArticleVersionHistory
Set VersionHistory = mvarVersionHistory
End Property

Public Property Set VersionHistory(ByVal vNewValue As ClsArticleVersionHistory)
Set mvarVersionHistory = vNewValue
End Property

Public Property Get surname() As String
    surname = mvarsurname
End Property

Public Property Let surname(ByVal vNewValue As String)
    mvarsurname = vNewValue
End Property
Public Property Get title() As String
    title = mvartitle
End Property

Public Property Let title(ByVal vNewValue As String)
    mvartitle = vNewValue
End Property

    
Public Property Get IssueNo() As String
    IssueNo = mvarIssueNo
End Property

Public Property Let IssueNo(ByVal vNewValue As String)
    mvarIssueNo = vNewValue
End Property

    Public Property Get dateiso() As String
    dateiso = mvarDateISO
End Property

Public Property Let dateiso(ByVal vNewValue As String)
    mvarDateISO = vNewValue
End Property

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClsJournal"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private mvarJournalStatusHistory As ClsHistory
Private mvarJournalStandard As String
Private mvarISSN As String
Private mvarCreativeCommons As clsCreativeCommons
Private mvarTitle As String
Private mvarKey As String
Private mvarShortTitle As String

Public Property Get ShortTitle() As Variant
    ShortTitle = mvarShortTitle
End Property

Public Property Let ShortTitle(ByVal vNewValue As Variant)
    mvarShortTitle = vNewValue
End Property
Public Property Get Key() As Variant
    Key = mvarKey
End Property

Public Property Let Key(ByVal vNewValue As Variant)
    mvarKey = vNewValue
End Property
Public Property Get Title() As Variant
    Title = mvarTitle
End Property

Public Property Let Title(ByVal vNewValue As Variant)
    mvarTitle = vNewValue
End Property

Public Property Get creativeCommons() As clsCreativeCommons
    Set creativeCommons = mvarCreativeCommons
End Property

Public Property Set creativeCommons(ByVal vNewValue As clsCreativeCommons)
    Set mvarCreativeCommons = vNewValue
End Property



Public Property Get ISSN() As Variant
    ISSN = mvarISSN
End Property

Public Property Let ISSN(ByVal vNewValue As Variant)
    mvarISSN = vNewValue
End Property


Public Property Get JournalStandard() As Variant
    JournalStandard = mvarJournalStandard
End Property

Public Property Let JournalStandard(ByVal vNewValue As Variant)
    mvarJournalStandard = vNewValue
End Property

Public Property Get journalStatusHistory() As Variant
    Set journalStatusHistory = mvarJournalStatusHistory
End Property

Public Property Set journalStatusHistory(ByVal vNewValue As Variant)
    Set mvarJournalStatusHistory = vNewValue
End Property

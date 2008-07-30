VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClLabels"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

'field mandatory
Public MandatoryFieldIndication As String

'Buttons
Public ButtonOpen As String
Public ButtonReplace As String
Public ButtonDelete As String
Public ButtonClose As String
Public ButtonOK As String
Public ButtonCancel As String
Public ButtonBack As String
Public ButtonNext As String
Public ButtonSave As String
Public ButtonRemove As String

'MENU
Public mnFile As String
Public mnSerialTitles As String
Public mnSerialSections As String
Public mnSerialIssues As String
Public mnCreateSerial As String
Public mnOpenExistingSerial As String
Public mnRemoveSerial As String
Public mnEdit As String
Public mnOptions As String
Public mnConfiguration As String
Public mnHelp As String
Public mnContents As String
Public mnAbout As String
Public mnExit As String

Public NewSerial As String
Public ExistingSerial As String
Public Select_to_Open As String
Public Select_to_Remove As String

'ISSUE1
Public Volume As String
Public VolSuppl As String
Public Issueno As String
Public IssueSuppl As String
Public SequentialNumber As String

'ISSUE2
Public Issue_Replace As String
Public Issue_Current As String
Public Issue_Changeto As String
Public Issue_General As String
Public Issue_BibliographicStrip As String
Public Issue_Tableofcontents As String
Public Issue_TabConfigurations As String

Public Issue_status As String
Public Issue_IssTitle As String
Public Issue_IssPublisher As String
Public Issue_Cover As String
Public Issue_DateISO As String
Public Issue_Sponsor As String
Public Issue_Part As String
Public Issue_NumberofDocuments As String
Public Issue_InvalidNumDoc As String
Public Issue_Standard As String
Public Issue_Scheme As String
Public Issue_MkpDone As String
Public Issue_Place As String
Public Issue_month As String
Public Issue_InvalidDateBibStrip As String
Public Issue_year As String
Public Issue_Header As String
Public Issue_SelectSections As String
Public Issue_Sectionsof As String
Public Issue_CreateSection As String

Public IseqNo_MsgIseqNo As String
Public ISEQNO_OPENEXISTINGISSUE As String
Public ISEQNO_CHANGEISEQNO As String
Public ISEQNO_CHANGEISSUEID As String

'SECTION
Public Sec_FrameSectionEdition As String
Public Sec_FrameFilledSections As String
Public Sec_FrameRemSection As String
Public Sec_SectionCode As String
Public Sec_SectionTitle As String
Public Sec_Idiom As String
Public Sec_CmdADD As String
Public Sec_CmdRem As String
Public Sec_InvalidSecCode As String
Public Sec_UnabledtoChange As String
Public Sec_InvalidSecTit As String
Public Sec_QMsgReplaceSection  As String

'SERIAL
Public ser1_FrameTitle As String
Public ser1_issn As String
Public ser1_Title As String
Public ser1_Subtitle As String
Public ser1_SectionTitle As String
Public ser1_ISOStitle As String
Public ser1_ShortTitle As String
Public ser1_OtherTitles As String
Public ser1_ParallelTitles As String
Public ser1_OldTitle As String
Public ser1_NewTitle As String
Public ser1_IsSuppl As String
Public ser1_HasSuppl As String

'Serial2
Public ser2_SubjectInfo As String
Public ser2_Mission As String
Public ser2_Subject As String
Public ser2_StudyArea As String
Public ser2_LiterType As String
Public ser2_LiterTypeDefVal As String
Public ser2_TreatLevel As String
Public ser2_TreatLevelDefVal As String
Public ser2_PubLevel As String

'Serial3
Public ser3_FormalInfo As String
Public ser3_InitDate As String
Public ser3_InitVol As String
Public ser3_InitNo As String
Public ser3_TermDate As String
Public ser3_FinVol As String
Public ser3_FinNo As String
Public ser3_Freq As String
Public ser3_PubStatus As String
Public ser3_Alphabet As String
Public ser3_TxtIdiom As String
Public ser3_AbstIdiom As String
Public ser3_NationalCode As String
Public ser3_Classif As String
Public ser3_FrameInfoPubJournal As String
Public ser3_Publisher As String
Public ser3_PubCountry As String
Public ser3_PubState As String
Public ser3_PubCity As String

'Serial4
Public ser4_FrameInfoPubJournal_2 As String
Public ser4_Address As String
Public ser4_Phone As String
Public ser4_Fax As String
Public ser4_email As String
Public ser4_cprightDate As String
Public ser4_cprighter As String
Public ser4_sponsor As String
Public ser4_FrameInfoHealth As String
Public ser4_secs As String
Public ser4_medline As String
Public ser4_MedlineStitle As String
Public ser4_idxRange As String

'Serial5
Public ser5_notes As String
Public ser5_SciELONet As String
Public ser5_FrameSciELOControl As String
Public ser5_siglum As String
Public ser5_PubId As String
Public ser5_Sep As String
Public ser5_SiteLocation As String
Public ser5_FTP As String
Public ser5_UserSubscription As String
Public ser5_FrameCenterControl As String
Public ser5_CCode As String
Public ser5_IdNumber As String
Public ser5_DocCreation As String
Public ser5_CreatDate As String
Public ser5_DocUpdate As String
Public ser5_UpdateDate As String
Public ser5_SubmissionOnline As String
Public ser5_issntype As String

Public Config_WebBrowserPath As String
Public Config_FindPath As String
Public Config_InterfaceIdiom As String

Public MsgMissingIssueId As String
Public MsgMandatoryContent As String
Public MsgSaveChanges As String
Public MsgExit As String
Public MsgClosebyCancelorClose As String
Public MsgRemoveSerial As String
Public MsgExistingSection As String
Public MsgInvalidSecCode As String
Public MsgInvalidFormatSeqNumber As String
Public MsgInvalidSeqNumber As String
Public MsgInvalidDATEISO As String
Public MsgUnchangeableCode As String
Public MsgReplaceIssue As String
Public MSGISSUENOEXIST As String
Public MsgReplaceIssueAlreadyExists  As String
Public MsgDeleteIssue As String
Public MsgInvalidYear As String

Public MsgUnabledtoClose  As String

Public ser6_journalExitStatus As String
    Public ser6_journalExitDate As String
    Public ser6_Add As String
    Public ser6_Replace As String
    Public ser6_Edit As String
    Public ser6_Remove As String
    Public ser6_journalStatusHistory As String
    Public ser6_journalEntryDate As String



Sub SetLabels(CurrCodeIdiom As String)
    
    Dim fn As Long
    
    fn = 1
    Open App.path + "\" + CurrCodeIdiom + "_labels.ini" For Input As fn
    Line Input #fn, MandatoryFieldIndication
    Line Input #fn, ButtonOpen
    Line Input #fn, ButtonReplace
    Line Input #fn, ButtonDelete
    Line Input #fn, ButtonClose
    Line Input #fn, ButtonOK
    Line Input #fn, ButtonCancel
    Line Input #fn, ButtonBack
    Line Input #fn, ButtonNext
    Line Input #fn, ButtonSave
    Line Input #fn, ButtonRemove
    
    Line Input #fn, mnFile
    Line Input #fn, mnEdit
    Line Input #fn, mnOptions
    Line Input #fn, mnHelp
    Line Input #fn, mnSerialTitles
    Line Input #fn, mnSerialSections
    Line Input #fn, mnSerialIssues
    Line Input #fn, mnCreateSerial
    Line Input #fn, mnOpenExistingSerial
    Line Input #fn, mnRemoveSerial
    Line Input #fn, mnConfiguration
    Line Input #fn, mnContents
    Line Input #fn, mnAbout
    Line Input #fn, mnExit
    
    Line Input #fn, NewSerial
    Line Input #fn, ExistingSerial
    
    Line Input #fn, Select_to_Open
    Line Input #fn, Select_to_Remove
        
    Line Input #fn, Volume
    Line Input #fn, VolSuppl
    Line Input #fn, Issueno
    Line Input #fn, IssueSuppl
    Line Input #fn, SequentialNumber
    Line Input #fn, Issue_Replace
    Line Input #fn, Issue_Current
    Line Input #fn, Issue_Changeto
    Line Input #fn, Issue_General
    Line Input #fn, Issue_BibliographicStrip
    Line Input #fn, Issue_Tableofcontents
    
    Line Input #fn, Issue_status
    Line Input #fn, Issue_IssTitle
    Line Input #fn, Issue_IssPublisher
    Line Input #fn, Issue_Cover
    Line Input #fn, Issue_DateISO
    Line Input #fn, Issue_Sponsor
    Line Input #fn, Issue_Part
    Line Input #fn, Issue_NumberofDocuments
    Line Input #fn, Issue_InvalidNumDoc
    Line Input #fn, Issue_Standard
    Line Input #fn, Issue_Scheme
    Line Input #fn, Issue_MkpDone
    
    Line Input #fn, Issue_Place
    Line Input #fn, Issue_month
    Line Input #fn, Issue_InvalidDateBibStrip
    Line Input #fn, Issue_year
    Line Input #fn, Issue_Header
    Line Input #fn, Issue_SelectSections
    Line Input #fn, Issue_Sectionsof
    Line Input #fn, Issue_CreateSection
    
    

    Line Input #fn, IseqNo_MsgIseqNo
    Line Input #fn, ISEQNO_OPENEXISTINGISSUE
    Line Input #fn, ISEQNO_CHANGEISEQNO
    Line Input #fn, ISEQNO_CHANGEISSUEID
    
    Line Input #fn, Sec_FrameSectionEdition
    Line Input #fn, Sec_FrameFilledSections
    Line Input #fn, Sec_FrameRemSection
    Line Input #fn, Sec_SectionCode
    Line Input #fn, Sec_SectionTitle
    Line Input #fn, Sec_Idiom
    Line Input #fn, Sec_CmdADD
    Line Input #fn, Sec_CmdRem
    Line Input #fn, Sec_InvalidSecCode
    Line Input #fn, Sec_InvalidSecTit
    Line Input #fn, Sec_QMsgReplaceSection
    Line Input #fn, ser1_FrameTitle
    Line Input #fn, ser1_issn
    Line Input #fn, ser1_Title
    Line Input #fn, ser1_ShortTitle
    Line Input #fn, ser1_ISOStitle
    Line Input #fn, ser1_ParallelTitles
    Line Input #fn, ser1_Subtitle
    Line Input #fn, ser1_SectionTitle
    Line Input #fn, ser1_OtherTitles
    Line Input #fn, ser1_OldTitle
    Line Input #fn, ser1_NewTitle
    Line Input #fn, ser1_IsSuppl
    Line Input #fn, ser1_HasSuppl
    
    Line Input #fn, ser2_SubjectInfo
    Line Input #fn, ser2_Mission
    Line Input #fn, ser2_Subject
    Line Input #fn, ser2_StudyArea
    Line Input #fn, ser2_LiterType
    Line Input #fn, ser2_LiterTypeDefVal
    Line Input #fn, ser2_TreatLevel
    Line Input #fn, ser2_TreatLevelDefVal
    Line Input #fn, ser2_PubLevel

'Serial3
    Line Input #fn, ser3_FormalInfo
    Line Input #fn, ser3_InitDate
    Line Input #fn, ser3_InitVol
    Line Input #fn, ser3_InitNo
    Line Input #fn, ser3_TermDate
    Line Input #fn, ser3_FinVol
    Line Input #fn, ser3_FinNo
    Line Input #fn, ser3_Freq
    Line Input #fn, ser3_PubStatus
    Line Input #fn, ser3_Alphabet
    Line Input #fn, ser3_TxtIdiom
    Line Input #fn, ser3_AbstIdiom
    Line Input #fn, ser3_NationalCode
    Line Input #fn, ser3_Classif
    Line Input #fn, ser3_FrameInfoPubJournal
    Line Input #fn, ser3_Publisher
    Line Input #fn, ser3_PubCountry
    Line Input #fn, ser3_PubState
    Line Input #fn, ser3_PubCity

'Serial4
    Line Input #fn, ser4_FrameInfoPubJournal_2
    Line Input #fn, ser4_Address
    Line Input #fn, ser4_Phone
    Line Input #fn, ser4_Fax
    Line Input #fn, ser4_email
    Line Input #fn, ser4_cprightDate
    Line Input #fn, ser4_cprighter
    Line Input #fn, ser4_sponsor
    Line Input #fn, ser4_FrameInfoHealth
    Line Input #fn, ser4_secs
    Line Input #fn, ser4_medline
    Line Input #fn, ser4_MedlineStitle
    Line Input #fn, ser4_idxRange

'Serial5
    Line Input #fn, ser5_notes
    
    Line Input #fn, ser5_FrameSciELOControl
    Line Input #fn, ser5_siglum
    Line Input #fn, ser5_PubId
    Line Input #fn, ser5_Sep
    Line Input #fn, ser5_SiteLocation
    Line Input #fn, ser5_FTP
    Line Input #fn, ser5_UserSubscription
    Line Input #fn, ser5_SciELONet
    Line Input #fn, ser5_SubmissionOnline
    
    Line Input #fn, ser5_FrameCenterControl
    Line Input #fn, ser5_CCode
    Line Input #fn, ser5_IdNumber
    Line Input #fn, ser5_DocCreation
    Line Input #fn, ser5_CreatDate
    Line Input #fn, ser5_DocUpdate
    Line Input #fn, ser5_UpdateDate
    
    Line Input #fn, Config_WebBrowserPath
    Line Input #fn, Config_FindPath
    Line Input #fn, Config_InterfaceIdiom
    
    Line Input #fn, MsgMandatoryContent
    Line Input #fn, MsgMissingIssueId
    Line Input #fn, MsgSaveChanges
    Line Input #fn, MsgExit
    Line Input #fn, MsgClosebyCancelorClose
    Line Input #fn, MsgRemoveSerial
    Line Input #fn, MsgUnchangeableCode
    Line Input #fn, MsgInvalidFormatSeqNumber
    Line Input #fn, MsgInvalidSeqNumber
    Line Input #fn, MsgInvalidDATEISO
    Line Input #fn, MsgReplaceIssue
    Line Input #fn, MSGISSUENOEXIST
    Line Input #fn, MsgReplaceIssueAlreadyExists
    Line Input #fn, MsgDeleteIssue
    Line Input #fn, MsgInvalidYear
    Line Input #fn, MsgUnabledtoClose
'Serial 6
    Line Input #fn, ser6_journalExitStatus
    Line Input #fn, ser6_journalExitDate
    Line Input #fn, ser6_Add
    Line Input #fn, ser6_Replace
    Line Input #fn, ser6_Edit
    Line Input #fn, ser6_Remove
    Line Input #fn, ser6_journalStatusHistory
    Line Input #fn, ser6_journalEntryDate

    Line Input #fn, Issue_TabConfigurations
    
    
    
    Close fn
    

    FormMenuPrin.SetLabels
End Sub



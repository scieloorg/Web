VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClLabels"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

'Buttons
Public ButtonOpen As String
Public ButtonClose As String
Public ButtonOK As String
Public ButtonCancel As String
Public ButtonBack As String
Public ButtonNext As String
Public ButtonSave As String
Public ButtonNew As String
Public ButtonRemove As String

'MENU
Public Code As String
Public Center As String
Public Ccode_Filled As String
Public Ccode_Edit As String
Public Sponsor_filled As String
Public Sponsor_Edit As String
Public StudyArea_Filled As String
Public StudyArea_Edit As String
Public mnEdit As String
Public mnOptions As String
Public mnConfiguration As String
Public ButtonHelp As String
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
Public Issue_General As String
Public Issue_BibliographicStrip As String
Public Issue_Tableofcontents As String
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
Public Issue_Place As String
Public Issue_month As String
Public Issue_InvalidDateBibStrip As String
Public Issue_year As String
Public Issue_Header As String
Public Issue_SelectSections As String
Public Issue_Sectionsof As String
Public Issue_CreateSection As String

Public IseqNo_MsgIseqNo As String
Public IseqNo_ExistingIssue As String
Public IseqNo_NewIssue As String

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

'SERIAL
Public ser1_FrameTitle As String
Public ser1_issn As String
Public ser1_Title As String
Public ser1_Subtitle As String
Public ser1_SectionTitle As String
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

Public Config_WebBrowserPath As String
Public Config_FindPath As String
Public Config_InterfaceIdiom As String


Public MsgMandatoryContent As String
Public MsgSaveChanges As String
Public MsgExit As String
Public MsgClosebyCancelorClose As String
Public MsgRemoveSerial As String
Public MsgExistingSection As String
Public MsgInvalidSecCode As String
Public MsgUnchangeableCode As String



Sub SetLabels(CurrCodeIdiom As String)
    
    Dim fn As Long
    
    fn = 1
    Open CurrCodeIdiom + "_labels.ini" For Input As fn
    Line Input #fn, ButtonOpen
    Line Input #fn, ButtonClose
    Line Input #fn, ButtonOK
    Line Input #fn, ButtonCancel
    Line Input #fn, ButtonBack
    Line Input #fn, ButtonNext
    Line Input #fn, ButtonSave
    Line Input #fn, ButtonNew
    Line Input #fn, ButtonRemove
    
    Line Input #fn, ButtonHelp
    
    Line Input #fn, Code
    Line Input #fn, Center
    
    Line Input #fn, Ccode_Filled
    Line Input #fn, Ccode_Edit
    Line Input #fn, Sponsor_filled
    Line Input #fn, Sponsor_Edit
    Line Input #fn, StudyArea_Filled
    Line Input #fn, StudyArea_Edit
    
    Line Input #fn, MsgMandatoryContent
    Line Input #fn, MsgSaveChanges
    Line Input #fn, MsgExit
    Line Input #fn, MsgClosebyCancelorClose
    Line Input #fn, MsgRemoveSerial
    Line Input #fn, MsgUnchangeableCode
    
    
    Close fn
    
    
End Sub


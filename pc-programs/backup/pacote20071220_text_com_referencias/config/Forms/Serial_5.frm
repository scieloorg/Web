VERSION 5.00
Begin VB.Form Serial5 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Config - Serial's database"
   ClientHeight    =   5460
   ClientLeft      =   45
   ClientTop       =   1335
   ClientWidth     =   7710
   Icon            =   "Serial_5.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   NegotiateMenus  =   0   'False
   ScaleHeight     =   5460
   ScaleWidth      =   7710
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton CmdBack 
      Caption         =   "Back"
      Height          =   375
      Left            =   2760
      TabIndex        =   14
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   6600
      TabIndex        =   16
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdSave 
      Caption         =   "Save"
      Height          =   375
      Left            =   5520
      TabIndex        =   15
      Top             =   5040
      Width           =   975
   End
   Begin VB.Frame FrameCenter 
      Caption         =   "Center's control information "
      Height          =   1695
      Left            =   120
      TabIndex        =   18
      Top             =   3240
      Width           =   7455
      Begin VB.TextBox TxtCreatDate 
         BackColor       =   &H00C0C0C0&
         Height          =   285
         Left            =   2640
         Locked          =   -1  'True
         TabIndex        =   12
         Text            =   "19990000"
         Top             =   1320
         Width           =   855
      End
      Begin VB.TextBox TxtDocCreation 
         Height          =   285
         Left            =   2640
         TabIndex        =   10
         Text            =   "FAPSB"
         Top             =   960
         Width           =   855
      End
      Begin VB.TextBox TxtDocUpdate 
         Height          =   285
         Left            =   6480
         TabIndex        =   11
         Text            =   "FAPSB"
         Top             =   960
         Width           =   855
      End
      Begin VB.TextBox TxtUpdateDate 
         BackColor       =   &H00C0C0C0&
         Height          =   285
         Left            =   6480
         Locked          =   -1  'True
         TabIndex        =   13
         Text            =   "19990000"
         Top             =   1320
         Width           =   855
      End
      Begin VB.TextBox TxtIdNumber 
         Height          =   285
         Left            =   5280
         TabIndex        =   9
         Text            =   "Text5"
         Top             =   480
         Width           =   2055
      End
      Begin VB.ComboBox ComboCCode 
         Height          =   315
         ItemData        =   "Serial_5.frx":030A
         Left            =   120
         List            =   "Serial_5.frx":030C
         Sorted          =   -1  'True
         TabIndex        =   8
         Text            =   "pode digitar também?"
         Top             =   480
         Width           =   5055
      End
      Begin VB.Label LabDocUpdate 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Documentalist (update)"
         Height          =   195
         Left            =   4800
         TabIndex        =   30
         Top             =   960
         Width           =   1635
      End
      Begin VB.Label LabDocCreation 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Documentalist (creation)"
         Height          =   195
         Left            =   840
         TabIndex        =   29
         Top             =   960
         Width           =   1710
      End
      Begin VB.Label LabUpdateDate 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Update date"
         Height          =   195
         Left            =   5520
         TabIndex        =   28
         Top             =   1320
         Width           =   885
      End
      Begin VB.Label LabCreatDate 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Creation date"
         Height          =   195
         Left            =   1560
         TabIndex        =   27
         Top             =   1320
         Width           =   945
      End
      Begin VB.Label LabIdNumber 
         AutoSize        =   -1  'True
         Caption         =   "Identification number"
         Height          =   195
         Left            =   5280
         TabIndex        =   26
         Top             =   240
         Width           =   1470
      End
      Begin VB.Label LabCCode 
         AutoSize        =   -1  'True
         Caption         =   "Center code"
         Height          =   195
         Left            =   120
         TabIndex        =   25
         Top             =   240
         Width           =   870
      End
   End
   Begin VB.Frame FrameSciELO 
      Caption         =   "SciELO's control information "
      Height          =   3135
      Left            =   120
      TabIndex        =   17
      Top             =   0
      Width           =   7455
      Begin VB.TextBox Text_SubmissionOnline 
         Height          =   285
         Left            =   3000
         TabIndex        =   35
         Text            =   "Text1"
         Top             =   2760
         Width           =   4335
      End
      Begin VB.ComboBox ComboISSNType 
         Height          =   315
         Left            =   4080
         TabIndex        =   7
         Text            =   "ComboISSNType"
         Top             =   2280
         Width           =   3255
      End
      Begin VB.ListBox ListSciELONet 
         Height          =   735
         Left            =   4080
         Sorted          =   -1  'True
         Style           =   1  'Checkbox
         TabIndex        =   6
         Top             =   1080
         Width           =   3255
      End
      Begin VB.TextBox TxtPubId 
         BackColor       =   &H00C0C0C0&
         Height          =   285
         Left            =   1320
         Locked          =   -1  'True
         TabIndex        =   1
         Text            =   "mmmmmmmm"
         Top             =   480
         Width           =   1455
      End
      Begin VB.ComboBox ComboUserSubscription 
         Height          =   315
         Left            =   120
         Sorted          =   -1  'True
         TabIndex        =   5
         Text            =   "Combo1"
         Top             =   2280
         Width           =   3855
      End
      Begin VB.TextBox TxtSiteLocation 
         Height          =   285
         Left            =   120
         TabIndex        =   3
         Text            =   "Text4"
         Top             =   1080
         Width           =   3855
      End
      Begin VB.TextBox TxtSep 
         Height          =   285
         Left            =   3240
         TabIndex        =   2
         Text            =   "Text3"
         Top             =   480
         Width           =   4095
      End
      Begin VB.ComboBox ComboFTP 
         Height          =   315
         Left            =   120
         Sorted          =   -1  'True
         TabIndex        =   4
         Text            =   "Combo1"
         Top             =   1680
         Width           =   3855
      End
      Begin VB.TextBox TxtSiglum 
         Height          =   285
         Left            =   120
         TabIndex        =   0
         Text            =   "mmmmmmmm"
         Top             =   480
         Width           =   1095
      End
      Begin VB.Label Lab_SubmissionOnline 
         Caption         =   "URL de SciELO Submission Online"
         Height          =   255
         Left            =   120
         TabIndex        =   34
         Top             =   2760
         Width           =   2895
      End
      Begin VB.Label LabISSNType 
         Caption         =   "Label1"
         Height          =   255
         Left            =   4080
         TabIndex        =   33
         Top             =   2040
         Width           =   1455
      End
      Begin VB.Label LabScieloNET 
         AutoSize        =   -1  'True
         Caption         =   "Scielo net"
         Height          =   195
         Left            =   4080
         TabIndex        =   31
         Top             =   840
         Width           =   705
      End
      Begin VB.Label LabSep 
         AutoSize        =   -1  'True
         Caption         =   "Separator"
         Height          =   195
         Left            =   3240
         TabIndex        =   24
         Top             =   240
         Width           =   690
      End
      Begin VB.Label LabSiteLocation 
         AutoSize        =   -1  'True
         Caption         =   "Site location"
         Height          =   195
         Left            =   120
         TabIndex        =   23
         Top             =   840
         Width           =   870
      End
      Begin VB.Label LabUserSubscription 
         AutoSize        =   -1  'True
         Caption         =   "User's subscription"
         Height          =   195
         Left            =   120
         TabIndex        =   22
         Top             =   2040
         Width           =   1320
      End
      Begin VB.Label LabFTP 
         AutoSize        =   -1  'True
         Caption         =   "FTP"
         Height          =   195
         Left            =   120
         TabIndex        =   21
         Top             =   1440
         Width           =   300
      End
      Begin VB.Label LabPubId 
         AutoSize        =   -1  'True
         Caption         =   "Publisher's identifier"
         Height          =   195
         Left            =   1320
         TabIndex        =   20
         Top             =   240
         Width           =   1380
      End
      Begin VB.Label LabSiglum 
         AutoSize        =   -1  'True
         Caption         =   "Siglum"
         Height          =   195
         Left            =   120
         TabIndex        =   19
         Top             =   240
         Width           =   465
      End
   End
   Begin VB.Label LabIndicationMandatoryField 
      Caption         =   "Label1"
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   120
      TabIndex        =   32
      Top             =   5040
      Width           =   2415
   End
End
Attribute VB_Name = "Serial5"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public IsBack As Boolean
Private MyMfnTitle As Long

Private Sub Check1_Click()

End Sub

Private Sub CmdBack_Click()
    Hide
    IsBack = True
    Serial4.MyOpen (MyMfnTitle)
End Sub

Sub MySetLabels()
    With Fields
    LabScieloNET.Caption = .Fields("ser5_SciELONet").GetLabel
    LabSiglum.Caption = .Fields("ser5_siglum").GetLabel
    LabPubId.Caption = .Fields("ser5_PubId").GetLabel
    LabSep.Caption = .Fields("ser5_Sep").GetLabel
    LabSiteLocation.Caption = .Fields("ser5_SiteLocation").GetLabel
    LabFTP.Caption = .Fields("ser5_FTP").GetLabel
    LabISSNType.Caption = .Fields("ser5_issntype").GetLabel
    LabUserSubscription.Caption = .Fields("ser5_UserSubscription").GetLabel
    LabCCode.Caption = .Fields("ser5_CCode").GetLabel
    LabIdNumber.Caption = .Fields("ser5_IdNumber").GetLabel
    LabDocCreation.Caption = .Fields("ser5_DocCreation").GetLabel
    LabCreatDate.Caption = .Fields("ser5_CreatDate").GetLabel
    LabDocUpdate.Caption = .Fields("ser5_DocUpdate").GetLabel
    LabUpdateDate.Caption = .Fields("ser5_UpdateDate").GetLabel
    Lab_SubmissionOnline.Caption = .Fields("ser5_SubmissionOnline").GetLabel
    End With
    
    With ConfigLabels
    LabIndicationMandatoryField.Caption = .MandatoryFieldIndication
    FrameSciELO.Caption = .ser5_FrameSciELOControl
    FrameCenter.Caption = .ser5_FrameCenterControl
    CmdBack.Caption = .ButtonBack
    CmdClose.Caption = .ButtonClose
    'CmdCancel.Caption = .ButtonCancel
    CmdSave.Caption = .ButtonSave
    End With
    
    Call FillCombo(ComboFTP, CodeFTP)
    Call FillCombo(ComboUserSubscription, CodeUsersubscription)
    Call FillCombo(ComboCCode, CodeCCode)
    Call FillCombo(ComboISSNType, CodeISSNType)
    Call FillList(ListSciELONet, CodeScieloNet)
    
    
End Sub

Sub MyGetContentFromBase(MfnTitle As Long)
        
        TxtSiglum.Text = Serial_TxtContent(MfnTitle, 930)
        TxtPubId.Text = Serial_TxtContent(MfnTitle, 68)
        TxtSep.Text = Serial_TxtContent(MfnTitle, 65)
        TxtSiteLocation.Text = Serial_TxtContent(MfnTitle, 69)
        ComboFTP.Text = Serial_ComboContent(CodeFTP, MfnTitle, 66)
        ComboISSNType.Text = Serial_ComboContent(CodeISSNType, MfnTitle, 35)
        ComboUserSubscription.Text = Serial_ComboContent(CodeUsersubscription, MfnTitle, 67)
        Call ScieloNetRead(MfnTitle)
        Text_SubmissionOnline.Text = Serial_TxtContent(MfnTitle, 692)
        
        ComboCCode.Text = Serial_ComboContent(CodeCCode, MfnTitle, 10)
        TxtIdNumber.Text = Serial_TxtContent(MfnTitle, 30)
        TxtDocCreation.Text = Serial_TxtContent(MfnTitle, 950)
                
        TxtCreatDate.Text = Serial_TxtContent(MfnTitle, 940)
        If Len(TxtCreatDate.Text) = 0 Then TxtCreatDate.Text = GetDateISO(Date)
        
        TxtDocUpdate.Text = Serial_TxtContent(MfnTitle, 951)
        TxtUpdateDate.Text = Serial_TxtContent(MfnTitle, 941)
End Sub
Sub MyClearContent()
        Call UnselectList(ListSciELONet)
        TxtSiglum.Text = ""
        TxtPubId.Text = ""
        TxtSep.Text = ""
        TxtSiteLocation.Text = ""
        ComboFTP.Text = ""
        ComboISSNType.Text = ""
        Text_SubmissionOnline.Text = ""
        ComboUserSubscription.Text = ""
        ComboCCode.Text = ""
        TxtIdNumber.Text = ""
        TxtDocCreation.Text = ""
        TxtCreatDate.Text = GetDateISO(Date)
        TxtDocUpdate.Text = ""
        TxtUpdateDate.Text = ""
End Sub

Sub MyOpen(MfnTitle As Long)
    MyMfnTitle = MfnTitle
    
    Left = FormMenuPrin.SysInfo1.WorkAreaWidth / 2 - (Width + FrmInfo.Width) / 2
    Top = FormMenuPrin.SysInfo1.WorkAreaHeight / 2 - Height / 2
    FrmInfo.Top = Top
    FrmInfo.Left = Left + Width
    
    Show
End Sub

Sub Old_MyOpen(MfnTitle As Long)
    If Not IsBack Then
        MyMfnTitle = MfnTitle
        MySetLabels
        
        If MfnTitle > 0 Then
            MyGetContentFromBase (MyMfnTitle)
        Else
            MyClearContent
        End If
    End If
    Show
End Sub

Private Sub CmdCancel_Click()
    CancelFilling
End Sub


Private Sub CmdClose_Click()
    Dim respClose As Integer
    
    respClose = Serial_Close(MyMfnTitle)
    Select Case respClose
    Case 1
        UnloadSerialForms
    Case 2
        CmdSave_Click
        UnloadSerialForms
    End Select

End Sub

Private Sub CmdSave_Click()
    MousePointer = vbHourglass
    MyMfnTitle = Serial_Save(MyMfnTitle)
    MousePointer = vbArrow
End Sub


Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    Call FormQueryUnload(Cancel, UnloadMode)
End Sub

Function WarnMandatoryFields() As Boolean
    Dim warning As String
    Dim i As Long
    
    
    With Fields
    
    warning = warning + .MandatoryFields(Serial1.TxtISSN.Text, "ser1_issn")
    warning = warning + .MandatoryFields(Serial1.TxtSerTitle.Text, "ser1_Title")
    warning = warning + .MandatoryFields(Serial1.TxtShortTitle.Text, "ser1_ShortTitle")
    warning = warning + .MandatoryFields(Serial1.TxtISOStitle.Text, "ser1_ISOStitle")
    
    
    For i = 1 To IdiomsInfo.Count
        warning = warning + .MandatoryFields(Serial2.TxtMission(i).Text, "ser2_Mission")
    Next

    warning = warning + .MandatoryFields(Serial2.TxtDescriptors.Text, "ser2_Subject")
    
    If Serial2.ListStudyArea.SelCount = 0 Then
        warning = warning + .MandatoryFields("", "ser2_StudyArea")
    End If
    
    warning = warning + .MandatoryFields(Serial2.ComboTpLit.Text, "ser2_LiterType")
    warning = warning + .MandatoryFields(Serial2.ComboTreatLev.Text, "ser2_TreatLevel")
    warning = warning + .MandatoryFields(Serial2.ComboPubLev.Text, "ser2_PubLevel")
    
    warning = warning + .MandatoryFields(Serial3.TxtInitDate.Text, "ser3_InitDate")
    warning = warning + .MandatoryFields(Serial3.ComboFreq.Text, "ser3_Freq")
    warning = warning + .MandatoryFields(Serial3.ComboPubStatus.Text, "ser3_PubStatus")
    warning = warning + .MandatoryFields(Serial3.ComboAlphabet.Text, "ser3_Alphabet")
    If Serial3.ListTextIdiom.SelCount = 0 Then
        warning = warning + .MandatoryFields("", "ser3_TxtIdiom")
    End If
    If Serial3.ListAbstIdiom.SelCount = 0 Then
        warning = warning + .MandatoryFields("", "ser3_AbstIdiom")
    End If
    warning = warning + .MandatoryFields(Serial3.ComboStandard.Text, "Issue_Standard")
    If Serial3.ListScheme.SelCount = 0 Then
        warning = warning + .MandatoryFields("", "Issue_Scheme")
    End If
    warning = warning + .MandatoryFields(Serial3.TxtPublisher.Text, "ser3_Publisher")
    warning = warning + .MandatoryFields(Serial3.ComboCountry.Text, "ser3_PubCountry")
    warning = warning + .MandatoryFields(Serial3.TxtPubCity.Text, "ser3_PubCity")

    
    warning = warning + .MandatoryFields(Serial4.TxtAddress.Text, "ser4_Address")
    warning = warning + .MandatoryFields(Serial4.TxtEmail.Text, "ser4_email")
    warning = warning + .MandatoryFields(Serial4.TxtCprighter.Text, "ser4_cprighter")
    
    
    warning = warning + .MandatoryFields(TxtSiglum.Text, "ser5_siglum")
    warning = warning + .MandatoryFields(TxtPubId.Text, "ser5_PubId")
    warning = warning + .MandatoryFields(TxtSiteLocation.Text, "ser5_SiteLocation")
    warning = warning + .MandatoryFields(ComboFTP.Text, "ser5_FTP")
    warning = warning + .MandatoryFields(ComboISSNType.Text, "ser5_issntype")
    warning = warning + .MandatoryFields(ComboUserSubscription.Text, "ser5_UserSubscription")
    If ListSciELONet.SelCount = 0 Then warning = warning + .MandatoryFields("", "ser5_SciELONet")
    warning = warning + .MandatoryFields(ComboCCode.Text, "ser5_CCode")
    warning = warning + .MandatoryFields(TxtDocCreation.Text, "ser5_DocCreation")
    warning = warning + .MandatoryFields(TxtCreatDate.Text, "ser5_CreatDate")
    warning = warning + .MandatoryFields(TxtDocUpdate.Text, "ser5_DocUpdate")
    warning = warning + .MandatoryFields(TxtUpdateDate.Text, "ser5_UpdateDate")
    
    End With
    If Len(warning) > 0 Then
        MsgBox ConfigLabels.MsgMandatoryContent + vbCrLf + warning, vbCritical
    End If
    WarnMandatoryFields = (Len(warning) > 0)
End Function

Private Sub listscielonet_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help5_SciELONet, 2
End Sub

Private Sub Text1_Change()

End Sub

Private Sub TxtCreatDate_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help5_CreatDate, 2
End Sub

Private Sub TxtDocCreation_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help5_DocCreation, 2
End Sub

Private Sub TxtDocUpdate_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help5_DocUpdate, 2
End Sub

Private Sub TxtIdNumber_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help5_IdNumber, 2
End Sub

Private Sub TxtPubId_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help5_PubId, 1
End Sub

Private Sub TxtSep_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help5_Sep, 1
End Sub

Private Sub TxtSiglum_Change()
    TxtPubId.Text = LCase(TxtSiglum.Text)
End Sub

Private Sub TxtSiglum_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help5_siglum, 1
End Sub

Private Sub TxtSiteLocation_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help5_SiteLocation, 2
End Sub

Private Sub TxtUpdateDate_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help5_UpdateDate, 2
End Sub

Private Sub ComboCCode_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help5_CCode, 2
End Sub

Private Sub ComboFTP_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help5_FTP, 2
End Sub

Private Sub Comboissntype_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help5_issntype, 2
End Sub

Private Sub ComboUserSubscription_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help5_UserSubscription, 2
End Sub

Function ScieloNetRead(MfnTitle As Long) As String
    Dim i As Long
    Dim Item As ClCode
    Dim exist As Boolean
    Dim idx As Long
    Dim Content As String
    
    Content = Serial_TxtContent(MfnTitle, 691)
    If Len(Content) > 0 Then
        Set Item = New ClCode
        For i = 0 To ListSciELONet.ListCount - 1
            Set Item = CodeScieloNet(ListSciELONet.List(i), exist)
            If exist Then
                idx = CLng(Item.Code)
                If idx <= Len(Content) Then
                    ListSciELONet.Selected(i) = (Mid(Content, idx, 1) = 1)
                Else
                    ListSciELONet.Selected(i) = False
                End If
            Else
                ListSciELONet.Selected(i) = False
            End If
        Next
    Else
        For i = 0 To ListSciELONet.ListCount - 1
            ListSciELONet.Selected(i) = False
        Next
    End If
        
    For i = Len(Content) + 1 To ListSciELONet.ListCount
        Content = Content + "0"
    Next
    
    ScieloNetRead = Content
End Function



Function ScieloNetWrite() As String
    Dim i As Long
    Dim Item As ClCode
    Dim exist As Boolean
    Dim s() As String
    Dim q As Long
    Dim Content As String
    
    
    With Serial5
    q = .ListSciELONet.ListCount
    ReDim s(q)
    
    Set Item = New ClCode
    For i = 0 To .ListSciELONet.ListCount - 1
        Set Item = CodeScieloNet(.ListSciELONet.List(i), exist)
        If exist Then
            If .ListSciELONet.Selected(i) Then
                s(CLng(Item.Code)) = "1"
            Else
                s(CLng(Item.Code)) = "0"
            End If
        End If
    Next
    End With
    For i = 1 To q
        Content = Content + s(i)
    Next
    ScieloNetWrite = Content
End Function

    

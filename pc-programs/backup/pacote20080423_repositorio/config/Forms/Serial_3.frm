VERSION 5.00
Begin VB.Form Serial3 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Config - Serial's database"
   ClientHeight    =   5460
   ClientLeft      =   120
   ClientTop       =   1410
   ClientWidth     =   7710
   Icon            =   "Serial_3.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   NegotiateMenus  =   0   'False
   ScaleHeight     =   5460
   ScaleWidth      =   7710
   ShowInTaskbar   =   0   'False
   Begin VB.Frame FrameInfoPub 
      Caption         =   "Information about the publisher and the journal "
      Height          =   1695
      Left            =   120
      TabIndex        =   38
      Top             =   3240
      Width           =   7455
      Begin VB.TextBox TxtPublisher 
         Height          =   555
         Left            =   120
         MultiLine       =   -1  'True
         TabIndex        =   15
         Text            =   "Serial_3.frx":030A
         Top             =   480
         Width           =   7215
      End
      Begin VB.TextBox TxtPubCity 
         Height          =   285
         Left            =   5160
         TabIndex        =   18
         Text            =   "Text4"
         Top             =   1320
         Width           =   2175
      End
      Begin VB.ComboBox ComboCountry 
         Height          =   315
         Left            =   120
         Sorted          =   -1  'True
         TabIndex        =   16
         Text            =   "Combo2"
         Top             =   1320
         Width           =   2175
      End
      Begin VB.ComboBox ComboState 
         Height          =   315
         Left            =   2640
         TabIndex        =   17
         Text            =   "Combo1"
         Top             =   1320
         Width           =   2175
      End
      Begin VB.Label LabPublisher 
         AutoSize        =   -1  'True
         Caption         =   "Publisher"
         Height          =   195
         Left            =   120
         TabIndex        =   42
         Top             =   240
         Width           =   645
      End
      Begin VB.Label LabPubCountry 
         AutoSize        =   -1  'True
         Caption         =   "Publisher's country "
         Height          =   195
         Left            =   120
         TabIndex        =   41
         Top             =   1080
         Width           =   1365
      End
      Begin VB.Label LabPubState 
         AutoSize        =   -1  'True
         Caption         =   "Publisher's state"
         Height          =   195
         Left            =   2640
         TabIndex        =   40
         Top             =   1080
         Width           =   1140
      End
      Begin VB.Label LabPubCity 
         AutoSize        =   -1  'True
         Caption         =   "Publisher's city"
         Height          =   195
         Left            =   5160
         TabIndex        =   39
         Top             =   1080
         Width           =   1035
      End
   End
   Begin VB.CommandButton CmdBack 
      Caption         =   "Back"
      Height          =   375
      Left            =   2760
      TabIndex        =   19
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   6600
      TabIndex        =   22
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdNext 
      Caption         =   "Next"
      Height          =   375
      Left            =   3840
      TabIndex        =   20
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdSave 
      Caption         =   "Save"
      Height          =   375
      Left            =   5520
      TabIndex        =   21
      Top             =   5040
      Width           =   975
   End
   Begin VB.Frame FrameFormalInfo 
      Caption         =   "Formal information"
      Height          =   3135
      Left            =   120
      TabIndex        =   24
      Top             =   0
      Width           =   7455
      Begin VB.ListBox ListScheme 
         Height          =   510
         Left            =   4920
         Style           =   1  'Checkbox
         TabIndex        =   14
         Top             =   2520
         Width           =   2295
      End
      Begin VB.ListBox ListTextIdiom 
         Height          =   510
         Left            =   2520
         Sorted          =   -1  'True
         Style           =   1  'Checkbox
         TabIndex        =   11
         Top             =   1680
         Width           =   2295
      End
      Begin VB.ComboBox ComboStandard 
         Height          =   315
         Left            =   2520
         TabIndex        =   13
         Text            =   "ComboStandard"
         Top             =   2640
         Width           =   2295
      End
      Begin VB.ComboBox ComboPubStatus 
         Height          =   315
         Left            =   2520
         Sorted          =   -1  'True
         TabIndex        =   7
         Text            =   "Combo1"
         Top             =   1080
         Width           =   2295
      End
      Begin VB.ComboBox ComboFreq 
         Height          =   315
         Left            =   120
         Sorted          =   -1  'True
         TabIndex        =   6
         Text            =   "Combo1"
         Top             =   1080
         Width           =   2295
      End
      Begin VB.TextBox TxtClassif 
         Height          =   285
         Left            =   120
         TabIndex        =   9
         Text            =   "Text5"
         Top             =   1800
         Width           =   2175
      End
      Begin VB.ListBox ListAbstIdiom 
         Height          =   510
         Left            =   4920
         Sorted          =   -1  'True
         Style           =   1  'Checkbox
         TabIndex        =   12
         Top             =   1680
         Width           =   2415
      End
      Begin VB.TextBox TxtTermDate 
         Height          =   285
         Left            =   3720
         TabIndex        =   3
         Text            =   "19990000"
         Top             =   480
         Width           =   975
      End
      Begin VB.TextBox TxtInitVol 
         Height          =   285
         Left            =   1320
         TabIndex        =   1
         Text            =   "0000"
         Top             =   480
         Width           =   615
      End
      Begin VB.TextBox TxtInitNo 
         Height          =   285
         Left            =   2520
         TabIndex        =   2
         Text            =   "0000"
         Top             =   480
         Width           =   615
      End
      Begin VB.TextBox TxtFinNo 
         Height          =   285
         Left            =   6360
         TabIndex        =   5
         Text            =   "0000"
         Top             =   480
         Width           =   615
      End
      Begin VB.TextBox TxtNationalcode 
         Height          =   285
         Left            =   120
         TabIndex        =   10
         Text            =   "Text5"
         Top             =   2520
         Width           =   2175
      End
      Begin VB.ComboBox ComboAlphabet 
         Height          =   315
         Left            =   4920
         Sorted          =   -1  'True
         TabIndex        =   8
         Text            =   "Combo2"
         Top             =   1080
         Width           =   2295
      End
      Begin VB.TextBox TxtFinVol 
         Height          =   285
         Left            =   5160
         TabIndex        =   4
         Text            =   "0000"
         Top             =   480
         Width           =   615
      End
      Begin VB.TextBox TxtInitDate 
         Height          =   285
         Left            =   120
         TabIndex        =   0
         Text            =   "19990000"
         Top             =   480
         Width           =   975
      End
      Begin VB.Label LabScheme 
         AutoSize        =   -1  'True
         Caption         =   "Scheme"
         Height          =   195
         Left            =   4920
         TabIndex        =   44
         Top             =   2280
         Width           =   1665
      End
      Begin VB.Label LabStandard 
         AutoSize        =   -1  'True
         Caption         =   "Standard"
         Height          =   195
         Left            =   2520
         TabIndex        =   37
         Top             =   2400
         Width           =   645
      End
      Begin VB.Label LabClassif 
         AutoSize        =   -1  'True
         Caption         =   "Classification"
         Height          =   195
         Left            =   120
         TabIndex        =   36
         Top             =   1560
         Width           =   915
      End
      Begin VB.Label LabNationalCode 
         AutoSize        =   -1  'True
         Caption         =   "National code"
         Height          =   195
         Left            =   120
         TabIndex        =   35
         Top             =   2280
         Width           =   990
      End
      Begin VB.Label LabAbstIdiom 
         AutoSize        =   -1  'True
         Caption         =   "Abstract idiom"
         Height          =   195
         Left            =   4920
         TabIndex        =   34
         Top             =   1440
         Width           =   990
      End
      Begin VB.Label LabTextIdiom 
         AutoSize        =   -1  'True
         Caption         =   "Text idiom"
         Height          =   195
         Left            =   2520
         TabIndex        =   33
         Top             =   1440
         Width           =   720
      End
      Begin VB.Label LabAlphabet 
         AutoSize        =   -1  'True
         Caption         =   "Alphabet"
         Height          =   195
         Left            =   4920
         TabIndex        =   32
         Top             =   840
         Width           =   630
      End
      Begin VB.Label LabFrequency 
         AutoSize        =   -1  'True
         Caption         =   "Frequency"
         Height          =   195
         Left            =   120
         TabIndex        =   31
         Top             =   840
         Width           =   750
      End
      Begin VB.Label LabPubStatus 
         AutoSize        =   -1  'True
         Caption         =   "Publication status"
         Height          =   195
         Left            =   2520
         TabIndex        =   30
         Top             =   840
         Width           =   1245
      End
      Begin VB.Label LabFinNo 
         AutoSize        =   -1  'True
         Caption         =   "Final number"
         Height          =   195
         Left            =   6360
         TabIndex        =   29
         Top             =   240
         Width           =   900
      End
      Begin VB.Label LabFinVol 
         AutoSize        =   -1  'True
         Caption         =   "Final volume"
         Height          =   195
         Left            =   5160
         TabIndex        =   28
         Top             =   240
         Width           =   885
      End
      Begin VB.Label LabTermDate 
         AutoSize        =   -1  'True
         Caption         =   "Termination date"
         Height          =   195
         Left            =   3720
         TabIndex        =   27
         Top             =   240
         Width           =   1185
      End
      Begin VB.Label LabInitNo 
         AutoSize        =   -1  'True
         Caption         =   "Initial number"
         Height          =   195
         Left            =   2520
         TabIndex        =   26
         Top             =   240
         Width           =   930
      End
      Begin VB.Label LabInitVol 
         AutoSize        =   -1  'True
         Caption         =   "Initial volume"
         Height          =   195
         Left            =   1320
         TabIndex        =   25
         Top             =   240
         Width           =   915
      End
      Begin VB.Label LabInitDate 
         AutoSize        =   -1  'True
         Caption         =   "Initial date"
         Height          =   195
         Left            =   120
         TabIndex        =   23
         Top             =   240
         Width           =   720
      End
   End
   Begin VB.Label LabIndicationMandatoryField 
      Caption         =   "Label1"
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   120
      TabIndex        =   43
      Top             =   5040
      Width           =   2415
   End
End
Attribute VB_Name = "Serial3"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private MyMfnTitle As Long
Public IsBack As Boolean

Private Sub CmdBack_Click()
    Hide
    IsBack = True
    Serial2.MyOpen (MyMfnTitle)
    
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

Private Sub CmdNext_Click()
    'WarnMandatoryFields
    Serial4.MyOpen (MyMfnTitle)
End Sub

Sub MySetLabels()
    
    With Fields
    LabInitDate.Caption = .Fields("ser3_InitDate").GetLabel
    LabInitVol.Caption = .Fields("ser3_InitVol").GetLabel
    LabInitNo.Caption = .Fields("ser3_InitNo").GetLabel
    LabTermDate.Caption = .Fields("ser3_TermDate").GetLabel
    LabFinVol.Caption = .Fields("ser3_FinVol").GetLabel
    LabFinNo.Caption = .Fields("ser3_FinNo").GetLabel
    LabFrequency.Caption = .Fields("ser3_Freq").GetLabel
    LabPubStatus.Caption = .Fields("ser3_PubStatus").GetLabel
    LabAlphabet.Caption = .Fields("ser3_Alphabet").GetLabel
    LabTextIdiom.Caption = .Fields("ser3_TxtIdiom").GetLabel
    LabAbstIdiom.Caption = .Fields("ser3_AbstIdiom").GetLabel
    LabNationalCode.Caption = .Fields("ser3_NationalCode").GetLabel
    LabClassif.Caption = .Fields("ser3_Classif").GetLabel
    LabStandard.Caption = .Fields("Issue_Standard").GetLabel
    LabScheme.Caption = .Fields("Issue_Scheme").GetLabel
    LabPublisher.Caption = .Fields("ser3_Publisher").GetLabel
    LabPubCountry.Caption = .Fields("ser3_PubCountry").GetLabel
    LabPubState.Caption = .Fields("ser3_PubState").GetLabel
    LabPubCity.Caption = .Fields("ser3_PubCity").GetLabel
    End With
    
    With ConfigLabels
    LabIndicationMandatoryField.Caption = .MandatoryFieldIndication
    FrameFormalInfo.Caption = .ser3_FormalInfo
    FrameInfoPub.Caption = .ser3_FrameInfoPubJournal
    CmdBack.Caption = .ButtonBack
    CmdNext.Caption = .ButtonNext
    CmdClose.Caption = .ButtonClose
    CmdSave.Caption = .ButtonSave
    End With
    
    Call FillCombo(ComboAlphabet, CodeAlphabet)
    Call FillCombo(ComboFreq, CodeFrequency)
    Call FillCombo(ComboPubStatus, CodeStatus)
    Call FillCombo(ComboCountry, CodeCountry)
    Call FillCombo(ComboState, CodeState)
    Call FillList(ListTextIdiom, CodeTxtLanguage)
    Call FillList(ListAbstIdiom, CodeAbstLanguage)
    Call FillCombo(ComboStandard, CodeStandard)
    Call FillList(ListScheme, CodeScheme)
    
End Sub

Sub MyClearContent()
        TxtInitDate.Text = ""
        TxtInitVol.Text = ""
        TxtInitNo.Text = ""
        TxtTermDate.Text = ""
        TxtFinVol.Text = ""
        TxtFinNo.Text = ""
        
        ComboFreq.Text = ""
        ComboPubStatus.Text = ""
        ComboAlphabet.Text = ""
        Call UnselectList(ListAbstIdiom)
        Call UnselectList(ListTextIdiom)
        Call UnselectList(ListScheme)
        ComboStandard.Text = ""
        TxtNationalcode.Text = ""
        TxtClassif.Text = ""
        
        TxtPublisher.Text = ""
        ComboCountry.Text = ""
        ComboState.Text = ""
        'TxtPubState.Text = ""
        TxtPubCity.Text = ""

End Sub

Sub MyGetContentFromBase(MfnTitle As Long)
        TxtInitDate.Text = Serial_TxtContent(MfnTitle, 301)
        TxtInitVol.Text = Serial_TxtContent(MfnTitle, 302)
        TxtInitNo.Text = Serial_TxtContent(MfnTitle, 303)
        TxtTermDate.Text = Serial_TxtContent(MfnTitle, 304)
        TxtFinVol.Text = Serial_TxtContent(MfnTitle, 305)
        TxtFinNo.Text = Serial_TxtContent(MfnTitle, 306)
        
        ComboFreq.Text = Serial_ComboContent(CodeFrequency, MfnTitle, 380)
        ComboPubStatus.Text = Serial_ComboContent(CodeStatus, MfnTitle, 50)
        ComboAlphabet.Text = Serial_ComboContent(CodeAlphabet, MfnTitle, 340)
        Call Serial_ListContent(ListTextIdiom, CodeTxtLanguage, MfnTitle, 350)
        Call Serial_ListContent(ListAbstIdiom, CodeAbstLanguage, MfnTitle, 360)
        
        TxtNationalcode.Text = Serial_TxtContent(MfnTitle, 20)
        TxtClassif.Text = Serial_TxtContent(MfnTitle, 430)
        ComboStandard.Text = Serial_ComboContent(CodeStandard, MfnTitle, 117)
        
        Call Serial_ListContent(ListScheme, CodeScheme, MfnTitle, 85)
        
        TxtPublisher.Text = Serial_TxtContent(MfnTitle, 480)
        ComboCountry.Text = Serial_ComboContent(CodeCountry, MfnTitle, 310)
        ComboState.Text = Serial_ComboContent(CodeState, MfnTitle, 320)
        TxtPubCity.Text = Serial_TxtContent(MfnTitle, 490)
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
        Serial4.MySetLabels
        Serial5.MySetLabels
        
        If MfnTitle > 0 Then
            MyGetContentFromBase (MyMfnTitle)
            Serial4.MyGetContentFromBase (MyMfnTitle)
            Serial5.MyGetContentFromBase (MyMfnTitle)
        Else
            MyClearContent
            Serial4.MyClearContent
            Serial5.MyClearContent
        End If
    End If
    Show
End Sub
Private Sub CmdSave_Click()
    MousePointer = vbHourglass
    MyMfnTitle = Serial_Save(MyMfnTitle)
    MousePointer = vbArrow
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    Call FormQueryUnload(Cancel, UnloadMode)
End Sub


Private Sub ListAbstIdiom_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_AbstIdiom, 1
End Sub

Private Sub ListTextIdiom_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_TxtIdiom, 1
End Sub

Private Sub TxtClassif_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_Classif, 2
End Sub

Private Sub TxtFinNo_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_FinNo, 1
End Sub

Private Sub TxtFinVol_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_FinVol, 1
End Sub
    
Private Sub TxtInitDate_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_InitDate, 1
End Sub

Private Sub TxtInitNo_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_InitNo, 1
End Sub

Private Sub TxtInitVol_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_InitVol, 1
End Sub

Private Sub TxtNationalcode_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_NationalCode, 2
End Sub

Private Sub TxtPubCity_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_PubCity, 2
End Sub

Private Sub TxtPublisher_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_Publisher, 2
End Sub

'Private Sub TxtPubState_gotfocus()
 '    FrmInfo.ShowHelpMessage FrmInfo.Help3_PubState, 2
 'End Sub

Private Sub ComboPubState_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_PubState, 2
End Sub

Private Sub TxtTermDate_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_TermDate, 1
End Sub
Private Sub ComboAlphabet_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_Alphabet, 1
End Sub

Private Sub ComboCountry_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_PubCountry, 2
End Sub

Private Sub ComboFreq_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_Freq, 1
End Sub

Private Sub ComboPubStatus_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_PubStatus, 1
End Sub

Private Sub ComboStandard_GotFocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help3_Standard, 2
End Sub

Private Sub ListScheme_GotFocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help2_Scheme, 2
End Sub


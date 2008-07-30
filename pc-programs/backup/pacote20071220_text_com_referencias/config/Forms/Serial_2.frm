VERSION 5.00
Begin VB.Form Serial2 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Config - Serial's database"
   ClientHeight    =   5460
   ClientLeft      =   180
   ClientTop       =   1275
   ClientWidth     =   7710
   Icon            =   "Serial_2.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   NegotiateMenus  =   0   'False
   ScaleHeight     =   5460
   ScaleWidth      =   7710
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton CmdSave 
      Caption         =   "Save"
      Height          =   375
      Left            =   5520
      TabIndex        =   10
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdNext 
      Caption         =   "Next"
      Height          =   375
      Left            =   3840
      TabIndex        =   9
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   6600
      TabIndex        =   11
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdBack 
      Caption         =   "Back"
      Height          =   375
      Left            =   2760
      TabIndex        =   8
      Top             =   5040
      Width           =   975
   End
   Begin VB.Frame FrameSubject 
      Caption         =   "Subject information"
      Height          =   4815
      Left            =   120
      TabIndex        =   12
      Top             =   120
      Width           =   7455
      Begin VB.ListBox ListStudyArea 
         Height          =   735
         Left            =   120
         Style           =   1  'Checkbox
         TabIndex        =   4
         Top             =   3960
         Width           =   2415
      End
      Begin VB.Frame FrameMission 
         Caption         =   "Mission"
         Height          =   2415
         Left            =   120
         TabIndex        =   18
         Top             =   240
         Width           =   7215
         Begin VB.TextBox TxtMission 
            Height          =   615
            Index           =   1
            Left            =   1080
            ScrollBars      =   2  'Vertical
            TabIndex        =   0
            Text            =   "texto não repetitivo com várias linhas"
            Top             =   240
            Width           =   6015
         End
         Begin VB.TextBox TxtMission 
            Height          =   615
            Index           =   3
            Left            =   1080
            ScrollBars      =   2  'Vertical
            TabIndex        =   2
            Text            =   "texto não repetitivo com várias linhas"
            Top             =   1680
            Width           =   6015
         End
         Begin VB.TextBox TxtMission 
            Height          =   615
            Index           =   2
            Left            =   1080
            ScrollBars      =   2  'Vertical
            TabIndex        =   1
            Text            =   "texto não repetitivo com várias linhas"
            Top             =   960
            Width           =   6015
         End
         Begin VB.Label LabIdiom 
            AutoSize        =   -1  'True
            Caption         =   "English"
            Height          =   195
            Index           =   3
            Left            =   120
            TabIndex        =   21
            Top             =   1560
            Width           =   510
         End
         Begin VB.Label LabIdiom 
            AutoSize        =   -1  'True
            Caption         =   "Spanish"
            Height          =   195
            Index           =   2
            Left            =   120
            TabIndex        =   20
            Top             =   840
            Width           =   570
         End
         Begin VB.Label LabIdiom 
            AutoSize        =   -1  'True
            Caption         =   "Portuguese"
            Height          =   195
            Index           =   1
            Left            =   120
            TabIndex        =   19
            Top             =   240
            Width           =   810
         End
      End
      Begin VB.ComboBox ComboPubLev 
         Height          =   315
         Left            =   2640
         Sorted          =   -1  'True
         TabIndex        =   7
         Text            =   "Combo1"
         Top             =   4320
         Width           =   4695
      End
      Begin VB.ComboBox ComboTreatLev 
         Height          =   315
         Left            =   2640
         Sorted          =   -1  'True
         TabIndex        =   6
         Text            =   "Combo1"
         Top             =   3720
         Width           =   4695
      End
      Begin VB.ComboBox ComboTpLit 
         Height          =   315
         Left            =   2640
         Sorted          =   -1  'True
         TabIndex        =   5
         Text            =   "Combo1"
         Top             =   3000
         Width           =   4695
      End
      Begin VB.TextBox TxtDescriptors 
         Height          =   615
         Left            =   120
         MultiLine       =   -1  'True
         TabIndex        =   3
         Text            =   "Serial_2.frx":030A
         Top             =   3000
         Width           =   2415
      End
      Begin VB.Label LabSubject 
         AutoSize        =   -1  'True
         Caption         =   "Subject"
         Height          =   195
         Left            =   120
         TabIndex        =   17
         Top             =   2760
         Width           =   540
      End
      Begin VB.Label LabStudyArea 
         AutoSize        =   -1  'True
         Caption         =   "Study area"
         Height          =   195
         Left            =   120
         TabIndex        =   16
         Top             =   3720
         Width           =   765
      End
      Begin VB.Label LabTreatLevel 
         AutoSize        =   -1  'True
         Caption         =   "Treatment level"
         Height          =   195
         Left            =   2640
         TabIndex        =   15
         Top             =   3480
         Width           =   1095
      End
      Begin VB.Label LabTpLiterature 
         AutoSize        =   -1  'True
         Caption         =   "Type of literature"
         Height          =   195
         Left            =   2640
         TabIndex        =   14
         Top             =   2760
         Width           =   1185
      End
      Begin VB.Label LabPubLevel 
         AutoSize        =   -1  'True
         Caption         =   "Level of publication"
         Height          =   195
         Left            =   2640
         TabIndex        =   13
         Top             =   4080
         Width           =   1380
      End
   End
   Begin VB.Label LabIndicationMandatoryField 
      Caption         =   "Label1"
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   120
      TabIndex        =   22
      Top             =   5040
      Width           =   2415
   End
End
Attribute VB_Name = "Serial2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private MyMfnTitle As Long
Public IsBack As Boolean

Private Sub CmdBack_Click()
    Hide
    IsBack = True
    Serial1.OpenAgain (MyMfnTitle)
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
    Serial3.MyOpen (MyMfnTitle)
End Sub

Private Sub Old_CmdNext_Click()
    Static gotonext As Boolean
    
    If gotonext Then
        gotonext = False
        Serial3.MyOpen (MyMfnTitle)
    Else
        gotonext = True
        If Not Serial5.WarnMandatoryFields Then
            Serial3.MyOpen (MyMfnTitle)
        End If
    End If
End Sub

Sub MySetLabels()
    Dim i As Long
    
    For i = 1 To IdiomsInfo.Count
        LabIdiom(i).Caption = IdiomsInfo(i).label
    Next
    
    With Fields
    
    FrameMission.Caption = .Fields("ser2_Mission").GetLabel
    LabSubject.Caption = .Fields("ser2_Subject").GetLabel
    LabStudyArea.Caption = .Fields("ser2_StudyArea").GetLabel
    LabTpLiterature.Caption = .Fields("ser2_LiterType").GetLabel
    LabTreatLevel.Caption = .Fields("ser2_TreatLevel").GetLabel
    LabPubLevel.Caption = .Fields("ser2_PubLevel").GetLabel
    
    End With
    
    With ConfigLabels
    LabIndicationMandatoryField.Caption = .MandatoryFieldIndication
    FrameSubject.Caption = .ser2_SubjectInfo
    CmdBack.Caption = .ButtonBack
    CmdNext.Caption = .ButtonNext
    CmdClose.Caption = .ButtonClose
    CmdSave.Caption = .ButtonSave
    End With
    
    Call FillCombo(ComboTpLit, CodeLiteratureType)
    Call FillCombo(ComboTreatLev, CodeTreatLevel)
    Call FillCombo(ComboPubLev, CodePubLevel)
    'Call FillListStudyArea(ListStudyArea, CodeStudyArea)
    Call FillList(ListStudyArea, CodeStudyArea)


End Sub

Sub MyClearContent()
    Dim i As Long
    
    For i = 1 To IdiomsInfo.Count
        TxtMission(i).Text = ""
    Next
    
    TxtDescriptors.Text = ""
    
    Call UnselectList(ListStudyArea)
    
    ComboTpLit.Text = Serial_ComboDefaultValue(CodeLiteratureType, ConfigLabels.ser2_LiterTypeDefVal)
    ComboTreatLev.Text = Serial_ComboDefaultValue(CodeTreatLevel, ConfigLabels.ser2_TreatLevelDefVal)
    ComboPubLev.Text = ""
    
End Sub

Sub MyGetContentFromBase(MfnTitle As Long)
    Dim aux As String
    Dim i As Long
    
    For i = 1 To IdiomsInfo.Count
        TxtMission(i).Text = Serial_TxtContent(MfnTitle, 901, IdiomsInfo(i).Code)
    Next

    TxtDescriptors.Text = UCase(Serial_TxtContent(MfnTitle, 440))
    Call Serial_ListContent(ListStudyArea, CodeStudyArea, MfnTitle, 441)
        
    ComboTpLit.Text = Serial_ComboContent(CodeLiteratureType, MfnTitle, 5, ConfigLabels.ser2_LiterTypeDefVal)
    ComboTreatLev.Text = Serial_ComboContent(CodeTreatLevel, MfnTitle, 6, ConfigLabels.ser2_TreatLevelDefVal)
    ComboPubLev.Text = Serial_ComboContent(CodePubLevel, MfnTitle, 330)

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
        Serial3.MySetLabels
        Serial4.MySetLabels
        Serial5.MySetLabels
        
        If MfnTitle > 0 Then
            MyGetContentFromBase (MyMfnTitle)
            Serial3.MyGetContentFromBase (MyMfnTitle)
            Serial4.MyGetContentFromBase (MyMfnTitle)
            Serial5.MyGetContentFromBase (MyMfnTitle)
        Else
            MyClearContent
            Serial3.MyClearContent
            Serial4.MyClearContent
            Serial5.MyClearContent
        End If
    End If
    Show vbModal
    
End Sub

Private Sub CmdSave_Click()
    MousePointer = vbHourglass
    MyMfnTitle = Serial_Save(MyMfnTitle)
    MousePointer = vbArrow
End Sub



Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    Call FormQueryUnload(Cancel, UnloadMode)
End Sub

Private Sub combotpLit_GotFocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help2_LiterType, 2
End Sub

Private Sub comboTreatLev_GotFocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help2_TreatLevel, 2
End Sub

Private Sub TxtDescriptors_Gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help2_Subject, 2
End Sub

Private Sub TxtMission_GotFocus(index As Integer)
    FrmInfo.ShowHelpMessage FrmInfo.Help2_Mission, 1
End Sub

Private Sub ListStudyArea_GotFocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help2_StudyArea, 2
End Sub

Private Sub ComboPubLev_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help2_PubLevel, 2
End Sub


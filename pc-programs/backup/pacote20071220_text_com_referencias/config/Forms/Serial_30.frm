VERSION 5.00
Begin VB.Form Serial3 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Config - Serial's database"
   ClientHeight    =   5460
   ClientLeft      =   120
   ClientTop       =   1410
   ClientWidth     =   7710
   Icon            =   "Serial_30.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   NegotiateMenus  =   0   'False
   ScaleHeight     =   5460
   ScaleWidth      =   7710
   ShowInTaskbar   =   0   'False
   Begin VB.Frame FrameIdxRange 
      Caption         =   "Indexation range"
      Height          =   975
      Left            =   120
      TabIndex        =   31
      Top             =   3480
      Width           =   3495
      Begin VB.TextBox TxtIdxRange 
         Height          =   615
         Left            =   120
         MultiLine       =   -1  'True
         TabIndex        =   32
         Text            =   "Serial_30.frx":030A
         Top             =   240
         Width           =   3255
      End
   End
   Begin VB.CommandButton CmdBack 
      Caption         =   "Back"
      Height          =   375
      Left            =   2760
      TabIndex        =   13
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
   Begin VB.CommandButton CmdNext 
      Caption         =   "Next"
      Height          =   375
      Left            =   3840
      TabIndex        =   14
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
   Begin VB.Frame FrameFormalInfo 
      Caption         =   "Formal information"
      Height          =   3375
      Left            =   120
      TabIndex        =   18
      Top             =   0
      Width           =   7455
      Begin VB.ComboBox ComboStandard 
         Height          =   315
         Left            =   3480
         TabIndex        =   34
         Text            =   "ComboStandard"
         Top             =   2880
         Width           =   3855
      End
      Begin VB.ComboBox ComboScheme 
         Height          =   315
         Left            =   120
         TabIndex        =   33
         Text            =   "ComboScheme"
         Top             =   2880
         Width           =   3255
      End
      Begin VB.ComboBox ComboPubStatus 
         Height          =   315
         Left            =   2880
         Sorted          =   -1  'True
         TabIndex        =   7
         Text            =   "Combo1"
         Top             =   1080
         Width           =   2175
      End
      Begin VB.ComboBox ComboFreq 
         Height          =   315
         Left            =   120
         Sorted          =   -1  'True
         TabIndex        =   6
         Text            =   "Combo1"
         Top             =   1080
         Width           =   2655
      End
      Begin VB.TextBox TxtClassif 
         Height          =   285
         Left            =   120
         TabIndex        =   12
         Text            =   "Text5"
         Top             =   1680
         Width           =   2175
      End
      Begin VB.ListBox ListAbstIdiom 
         Height          =   960
         Left            =   4920
         Sorted          =   -1  'True
         Style           =   1  'Checkbox
         TabIndex        =   10
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
      Begin VB.ListBox ListTextIdiom 
         Height          =   960
         Left            =   2400
         Sorted          =   -1  'True
         Style           =   1  'Checkbox
         TabIndex        =   9
         Top             =   1680
         Width           =   2415
      End
      Begin VB.TextBox TxtNationalcode 
         Height          =   285
         Left            =   120
         TabIndex        =   11
         Text            =   "Text5"
         Top             =   2280
         Width           =   2175
      End
      Begin VB.ComboBox ComboAlphabet 
         Height          =   315
         Left            =   5160
         Sorted          =   -1  'True
         TabIndex        =   8
         Text            =   "Combo2"
         Top             =   1080
         Width           =   2175
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
      Begin VB.Label LabStandard 
         AutoSize        =   -1  'True
         Caption         =   "Standard"
         Height          =   195
         Left            =   3480
         TabIndex        =   36
         Top             =   2640
         Width           =   645
      End
      Begin VB.Label LabScheme 
         AutoSize        =   -1  'True
         Caption         =   "Scheme"
         Height          =   195
         Left            =   120
         TabIndex        =   35
         Top             =   2640
         Width           =   1665
      End
      Begin VB.Label LabClassif 
         AutoSize        =   -1  'True
         Caption         =   "Classification"
         Height          =   195
         Left            =   120
         TabIndex        =   30
         Top             =   1440
         Width           =   915
      End
      Begin VB.Label LabNationalCode 
         AutoSize        =   -1  'True
         Caption         =   "National code"
         Height          =   195
         Left            =   120
         TabIndex        =   29
         Top             =   2040
         Width           =   990
      End
      Begin VB.Label LabAbstIdiom 
         AutoSize        =   -1  'True
         Caption         =   "Abstract idiom"
         Height          =   195
         Left            =   4920
         TabIndex        =   28
         Top             =   1440
         Width           =   990
      End
      Begin VB.Label LabTextIdiom 
         AutoSize        =   -1  'True
         Caption         =   "Text idiom"
         Height          =   195
         Left            =   2400
         TabIndex        =   27
         Top             =   1440
         Width           =   720
      End
      Begin VB.Label LabAlphabet 
         AutoSize        =   -1  'True
         Caption         =   "Alphabet"
         Height          =   195
         Left            =   5160
         TabIndex        =   26
         Top             =   840
         Width           =   630
      End
      Begin VB.Label LabFrequency 
         AutoSize        =   -1  'True
         Caption         =   "Frequency"
         Height          =   195
         Left            =   120
         TabIndex        =   25
         Top             =   840
         Width           =   750
      End
      Begin VB.Label LabPubStatus 
         AutoSize        =   -1  'True
         Caption         =   "Publication status"
         Height          =   195
         Left            =   2880
         TabIndex        =   24
         Top             =   840
         Width           =   1245
      End
      Begin VB.Label LabFinNo 
         AutoSize        =   -1  'True
         Caption         =   "Final number"
         Height          =   195
         Left            =   6360
         TabIndex        =   23
         Top             =   240
         Width           =   900
      End
      Begin VB.Label LabFinVol 
         AutoSize        =   -1  'True
         Caption         =   "Final volume"
         Height          =   195
         Left            =   5160
         TabIndex        =   22
         Top             =   240
         Width           =   885
      End
      Begin VB.Label LabTermDate 
         AutoSize        =   -1  'True
         Caption         =   "Termination date"
         Height          =   195
         Left            =   3720
         TabIndex        =   21
         Top             =   240
         Width           =   1185
      End
      Begin VB.Label LabInitNo 
         AutoSize        =   -1  'True
         Caption         =   "Initial number"
         Height          =   195
         Left            =   2520
         TabIndex        =   20
         Top             =   240
         Width           =   930
      End
      Begin VB.Label LabInitVol 
         AutoSize        =   -1  'True
         Caption         =   "Initial volume"
         Height          =   195
         Left            =   1320
         TabIndex        =   19
         Top             =   240
         Width           =   915
      End
      Begin VB.Label LabInitDate 
         AutoSize        =   -1  'True
         Caption         =   "Initial date"
         Height          =   195
         Left            =   120
         TabIndex        =   17
         Top             =   240
         Width           =   720
      End
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
End Sub

Private Sub CmdClose_Click()
        Dim resp As VbMsgBoxResult
    Static gotonext As Boolean
    
    If gotonext Then
        gotonext = False
            If Serial_ChangedContents(MyMfnTitle) Then
                resp = MsgBox(ConfigLabels.MsgSaveChanges, vbYesNoCancel)
                If resp = vbCancel Then
            
                ElseIf resp = vbYes Then
                    CmdSave_Click
                    UnloadSerialForms
                ElseIf resp = vbNo Then
                    UnloadSerialForms
                End If
            Else
                UnloadSerialForms
            End If
    Else
        gotonext = True
        If (Not WarnMandatoryFields) Or (Not Serial1.WarnMandatoryFields) Or (Not Serial2.WarnMandatoryFields) Or (Not Serial3.WarnMandatoryFields) Or (Not Serial4.WarnMandatoryFields) Then
            If Serial_ChangedContents(MyMfnTitle) Then
                resp = MsgBox(ConfigLabels.MsgSaveChanges, vbYesNoCancel)
                If resp = vbCancel Then
            
                ElseIf resp = vbYes Then
                    CmdSave_Click
                    UnloadSerialForms
                ElseIf resp = vbNo Then
                    UnloadSerialForms
                End If
            Else
                UnloadSerialForms
            End If
        End If
    End If
    

End Sub

Private Sub CmdNext_Click()
    WarnMandatoryFields
    Serial4.MyOpen (MyMfnTitle)
End Sub

Private Sub Old_CmdNext_Click()
    Static gotonext As Boolean
    
    If gotonext Then
        gotonext = False
        Serial4.MyOpen (MyMfnTitle)
    Else
        gotonext = True
        If Not WarnMandatoryFields Then
            Serial4.MyOpen (MyMfnTitle)
        End If
    End If
End Sub

Sub MySetLabels()
    With ConfigLabels
    
    FrameFormalInfo.Caption = .ser3_FormalInfo
    LabInitDate.Caption = .ser3_InitDate
    LabInitVol.Caption = .ser3_InitVol
    LabInitNo.Caption = .ser3_InitNo
    LabTermDate.Caption = .ser3_TermDate
    LabFinVol.Caption = .ser3_FinVol
    LabFinNo.Caption = .ser3_FinNo
    LabFrequency.Caption = .ser3_Freq
    LabPubStatus.Caption = .ser3_PubStatus
    LabAlphabet.Caption = .ser3_Alphabet
    LabTextIdiom.Caption = .ser3_TxtIdiom
    LabAbstIdiom.Caption = .ser3_AbstIdiom
    LabNationalCode.Caption = .ser3_NationalCode
    LabClassif.Caption = .ser3_Classif
    FrameInfoPub.Caption = .ser3_FrameInfoPubJournal
    LabPublisher.Caption = .ser3_Publisher
    LabPubCountry.Caption = .ser3_PubCountry
    LabPubState.Caption = .ser3_PubState
    LabPubCity.Caption = .ser3_PubCity
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
        
        TxtPublisher.Text = Serial_TxtContent(MfnTitle, 480)
        ComboCountry.Text = Serial_ComboContent(CodeCountry, MfnTitle, 310)
        
        ComboState.Text = Serial_ComboContent(CodeState, MfnTitle, 320)
        'TxtPubState.Text = Serial_TxtContent(MfnTitle, 320)
        
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

Function WarnMandatoryFields() As Boolean
    Dim warning As String
    Dim i As Long
    
    With ConfigLabels
    
    warning = warning + MandatoryFields(TxtInitDate.Text, .ser3_InitDate)
    warning = warning + MandatoryFields(ComboFreq.Text, .ser3_Freq)
    warning = warning + MandatoryFields(ComboPubStatus.Text, .ser3_PubStatus)
    warning = warning + MandatoryFields(ComboAlphabet.Text, .ser3_Alphabet)
    If ListTextIdiom.SelCount = 0 Then
        warning = warning + MandatoryFields("", .ser3_TxtIdiom)
    End If
    If ListAbstIdiom.SelCount = 0 Then
        warning = warning + MandatoryFields("", .ser3_AbstIdiom)
    End If
    warning = warning + MandatoryFields(TxtPublisher.Text, .ser3_Publisher)
    warning = warning + MandatoryFields(ComboCountry.Text, .ser3_PubCountry)
    warning = warning + MandatoryFields(TxtPubCity.Text, .ser3_PubCity)
    
    End With
    
    If Len(warning) > 0 Then
        MsgBox warning
    End If
    WarnMandatoryFields = (Len(warning) > 0)
End Function

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


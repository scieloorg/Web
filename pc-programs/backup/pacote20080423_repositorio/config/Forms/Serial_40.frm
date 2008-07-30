VERSION 5.00
Begin VB.Form Serial4 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Config - Serial's database"
   ClientHeight    =   5460
   ClientLeft      =   120
   ClientTop       =   1335
   ClientWidth     =   7710
   Icon            =   "Serial_40.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   NegotiateMenus  =   0   'False
   ScaleHeight     =   5460
   ScaleWidth      =   7710
   ShowInTaskbar   =   0   'False
   Begin VB.Frame FrameInfoPub 
      Caption         =   "Information about the publisher and the journal (Part 2) "
      Height          =   3975
      Left            =   120
      TabIndex        =   10
      Top             =   0
      Width           =   7455
      Begin VB.TextBox TxtPublisher 
         Height          =   555
         Left            =   120
         MultiLine       =   -1  'True
         TabIndex        =   29
         Text            =   "Serial_40.frx":030A
         Top             =   480
         Width           =   5055
      End
      Begin VB.TextBox TxtPubCity 
         Height          =   285
         Left            =   5280
         TabIndex        =   28
         Text            =   "Text4"
         Top             =   1680
         Width           =   2055
      End
      Begin VB.ComboBox ComboCountry 
         Height          =   315
         Left            =   5280
         Sorted          =   -1  'True
         TabIndex        =   27
         Text            =   "Combo2"
         Top             =   480
         Width           =   2055
      End
      Begin VB.ComboBox ComboState 
         Height          =   315
         Left            =   5280
         TabIndex        =   26
         Text            =   "Combo1"
         Top             =   1080
         Width           =   2055
      End
      Begin VB.TextBox TxtCprighter 
         Height          =   285
         Left            =   120
         TabIndex        =   17
         Text            =   "Text4"
         Top             =   3600
         Width           =   5055
      End
      Begin VB.TextBox TxtFaxNumber 
         Height          =   285
         Left            =   5280
         TabIndex        =   16
         Top             =   2880
         Visible         =   0   'False
         Width           =   1935
      End
      Begin VB.TextBox TxtPhone 
         Height          =   285
         Left            =   5280
         TabIndex        =   15
         Top             =   2280
         Visible         =   0   'False
         Width           =   1935
      End
      Begin VB.TextBox TxtEmail 
         Height          =   285
         Left            =   120
         TabIndex        =   14
         Text            =   "Text4"
         Top             =   3000
         Width           =   5055
      End
      Begin VB.TextBox TxtCprightDate 
         Height          =   285
         Left            =   5280
         TabIndex        =   13
         Text            =   "Text4"
         Top             =   3600
         Visible         =   0   'False
         Width           =   1215
      End
      Begin VB.TextBox TxtSponsor 
         Height          =   525
         Left            =   120
         MultiLine       =   -1  'True
         TabIndex        =   12
         Text            =   "Serial_40.frx":0310
         Top             =   1320
         Width           =   5055
      End
      Begin VB.TextBox TxtAddress 
         Height          =   555
         Left            =   120
         MultiLine       =   -1  'True
         TabIndex        =   11
         Text            =   "Serial_40.frx":0335
         Top             =   2160
         Width           =   5055
      End
      Begin VB.Label LabPublisher 
         AutoSize        =   -1  'True
         Caption         =   "Publisher"
         Height          =   195
         Left            =   120
         TabIndex        =   33
         Top             =   240
         Width           =   645
      End
      Begin VB.Label LabPubCountry 
         AutoSize        =   -1  'True
         Caption         =   "Publisher's country "
         Height          =   195
         Left            =   5280
         TabIndex        =   32
         Top             =   240
         Width           =   1365
      End
      Begin VB.Label LabPubState 
         AutoSize        =   -1  'True
         Caption         =   "Publisher's state"
         Height          =   195
         Left            =   5280
         TabIndex        =   31
         Top             =   840
         Width           =   1140
      End
      Begin VB.Label LabPubCity 
         AutoSize        =   -1  'True
         Caption         =   "Publisher's city"
         Height          =   195
         Left            =   5280
         TabIndex        =   30
         Top             =   1440
         Width           =   1035
      End
      Begin VB.Label LabCprighter 
         AutoSize        =   -1  'True
         Caption         =   "Copyrighter"
         Height          =   195
         Left            =   120
         TabIndex        =   24
         Top             =   3360
         Width           =   795
      End
      Begin VB.Label LabFax 
         AutoSize        =   -1  'True
         Caption         =   "Fax Number"
         Height          =   195
         Left            =   5280
         TabIndex        =   23
         Top             =   2640
         Visible         =   0   'False
         Width           =   855
      End
      Begin VB.Label LabPhone 
         AutoSize        =   -1  'True
         Caption         =   "Phone Number"
         Height          =   195
         Left            =   5280
         TabIndex        =   22
         Top             =   2040
         Visible         =   0   'False
         Width           =   1065
      End
      Begin VB.Label LabCprightDate 
         AutoSize        =   -1  'True
         Caption         =   "Copyright (Date)"
         Height          =   195
         Left            =   5280
         TabIndex        =   21
         Top             =   3360
         Visible         =   0   'False
         Width           =   1140
      End
      Begin VB.Label LabSponsor 
         AutoSize        =   -1  'True
         Caption         =   "Sponsor"
         Height          =   195
         Left            =   120
         TabIndex        =   20
         Top             =   1080
         Width           =   585
      End
      Begin VB.Label LabEmail 
         AutoSize        =   -1  'True
         Caption         =   "Electronic address"
         Height          =   195
         Left            =   120
         TabIndex        =   19
         Top             =   2760
         Width           =   1305
      End
      Begin VB.Label LabAddress 
         AutoSize        =   -1  'True
         Caption         =   "Address"
         Height          =   195
         Left            =   120
         TabIndex        =   18
         Top             =   1920
         Width           =   570
      End
   End
   Begin VB.CommandButton CmdBack 
      Caption         =   "Back"
      Height          =   375
      Left            =   2760
      TabIndex        =   5
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   6600
      TabIndex        =   4
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdNext 
      Caption         =   "Next"
      Height          =   375
      Left            =   3840
      TabIndex        =   2
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdSave 
      Caption         =   "Save"
      Height          =   375
      Left            =   5520
      TabIndex        =   3
      Top             =   5040
      Width           =   975
   End
   Begin VB.Frame FrameInfoHealth 
      Caption         =   "Information for the health area "
      Height          =   855
      Left            =   120
      TabIndex        =   6
      Top             =   4080
      Width           =   7455
      Begin VB.TextBox TxtMEDLINE 
         Height          =   285
         Left            =   1680
         TabIndex        =   25
         Text            =   "Text2"
         Top             =   480
         Width           =   1335
      End
      Begin VB.TextBox TxtMEDLINEStitle 
         Height          =   285
         Left            =   3840
         TabIndex        =   1
         Text            =   "Text3"
         Top             =   480
         Width           =   3255
      End
      Begin VB.TextBox TxtSECS 
         Height          =   285
         Left            =   120
         TabIndex        =   0
         Text            =   "Text2"
         Top             =   480
         Width           =   1215
      End
      Begin VB.Label LabMEDLINEStitle 
         AutoSize        =   -1  'True
         Caption         =   "Short title for MEDLINE"
         Height          =   195
         Left            =   3840
         TabIndex        =   9
         Top             =   240
         Width           =   1650
      End
      Begin VB.Label LabMEDLINE 
         AutoSize        =   -1  'True
         Caption         =   "MEDLINE code"
         Height          =   195
         Left            =   1680
         TabIndex        =   8
         Top             =   240
         Width           =   1125
      End
      Begin VB.Label LabSECS 
         AutoSize        =   -1  'True
         Caption         =   "SECS identifier"
         Height          =   195
         Left            =   120
         TabIndex        =   7
         Top             =   240
         Width           =   1050
      End
   End
End
Attribute VB_Name = "Serial4"
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
    Serial5.MyOpen (MyMfnTitle)
End Sub

Private Sub Old_CmdNext_Click()
    Static gotonext As Boolean
    
    If gotonext Then
        gotonext = False
        Serial5.MyOpen (MyMfnTitle)
    Else
        gotonext = True
        If Not WarnMandatoryFields Then
            Serial5.MyOpen (MyMfnTitle)
        End If
    End If
End Sub

Sub MySetLabels()
    With ConfigLabels
    
    FrameInfoPub.Caption = .ser4_FrameInfoPubJournal_2
    LabAddress.Caption = .ser4_Address
    LabPhone.Caption = .ser4_Phone
    LabFax.Caption = .ser4_Fax
    LabEmail.Caption = .ser4_email
    LabCprightDate.Caption = .ser4_cprightDate
    LabCprighter.Caption = .ser4_cprighter
    LabSponsor.Caption = .ser4_sponsor
    FrameInfoHealth.Caption = .ser4_FrameInfoHealth
    LabSECS.Caption = .ser4_secs
    LabMEDLINE.Caption = .ser4_medline
    LabMEDLINEStitle.Caption = .ser4_MedlineStitle
    FrameIdxRange.Caption = .ser4_idxRange
    CmdBack.Caption = .ButtonBack
    CmdNext.Caption = .ButtonNext
    CmdClose.Caption = .ButtonClose
    CmdSave.Caption = .ButtonSave
    End With
    
    
End Sub

Sub MyClearContent()
        TxtAddress.Text = ""
        TxtPhone.Text = ""
        TxtFaxNumber.Text = ""
        TxtEmail.Text = ""
        TxtCprightDate.Text = ""
        TxtCprighter.Text = ""
        TxtSponsor.Text = ""
        TxtSECS.Text = ""
        TxtMEDLINE.Text = ""
        TxtMEDLINEStitle.Text = ""
        TxtIdxRange.Text = ""

End Sub

Sub MyGetContentFromBase(MfnTitle As Long)
        TxtAddress.Text = Serial_TxtContent(MfnTitle, 63)
        TxtPhone.Text = Serial_TxtContent(MfnTitle, 631)
        TxtFaxNumber.Text = Serial_TxtContent(MfnTitle, 632)
        TxtEmail.Text = Serial_TxtContent(MfnTitle, 64)
        TxtCprightDate.Text = Serial_TxtContent(MfnTitle, 621)
        TxtCprighter.Text = Serial_TxtContent(MfnTitle, 62)
        TxtSponsor.Text = Serial_TxtContent(MfnTitle, 140)
        TxtSECS.Text = Serial_TxtContent(MfnTitle, 37)
        TxtMEDLINE.Text = Serial_TxtContent(MfnTitle, 420)
        TxtMEDLINEStitle.Text = Serial_TxtContent(MfnTitle, 421)
        TxtIdxRange.Text = Serial_TxtContent(MfnTitle, 450)
        
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
        Serial5.MySetLabels
        
        If MfnTitle > 0 Then
            MyGetContentFromBase (MyMfnTitle)
            Serial5.MyGetContentFromBase (MyMfnTitle)
        Else
            MyClearContent
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
    
    warning = warning + MandatoryFields(TxtAddress.Text, .ser4_Address)
    warning = warning + MandatoryFields(TxtEmail.Text, .ser4_email)
    warning = warning + MandatoryFields(TxtCprighter.Text, .ser4_cprighter)
    
    End With
    
    If Len(warning) > 0 Then
        MsgBox warning
    End If
    WarnMandatoryFields = (Len(warning) > 0)
End Function

Private Sub TxtAddress_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help4_Address, 1
End Sub

Private Sub TxtCprightDate_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help4_cprightDate, 1
End Sub

Private Sub TxtCprighter_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help4_cprighter, 2
End Sub

Private Sub TxtEmail_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help4_email, 1
End Sub

Private Sub TxtFaxNumber_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help4_Fax, 1
End Sub

Private Sub TxtIdxRange_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help4_idxRange, 2
End Sub

Private Sub TxtMEDLINE_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help4_medline, 2
End Sub

Private Sub TxtMEDLINEStitle_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help4_MedlineStitle, 2
End Sub

Private Sub TxtNotes_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help5_notes
End Sub

Private Sub TxtPhone_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help4_Phone, 1
End Sub

Private Sub TxtSECS_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help4_secs, 2
End Sub

Private Sub TxtSponsor_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help4_sponsor, 1
End Sub

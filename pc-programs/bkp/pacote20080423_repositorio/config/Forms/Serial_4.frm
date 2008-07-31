VERSION 5.00
Begin VB.Form Serial4 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Config - Serial's database"
   ClientHeight    =   5460
   ClientLeft      =   120
   ClientTop       =   1335
   ClientWidth     =   7710
   Icon            =   "Serial_4.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   NegotiateMenus  =   0   'False
   ScaleHeight     =   5460
   ScaleWidth      =   7710
   ShowInTaskbar   =   0   'False
   Begin VB.Frame FrameInfoHealth 
      Caption         =   "Information for the health area "
      Height          =   855
      Left            =   120
      TabIndex        =   26
      Top             =   2880
      Width           =   7455
      Begin VB.TextBox TxtMEDLINE 
         Height          =   285
         Left            =   1680
         TabIndex        =   8
         Text            =   "Text2"
         Top             =   480
         Width           =   1335
      End
      Begin VB.TextBox TxtSECS 
         Height          =   285
         Left            =   120
         TabIndex        =   7
         Text            =   "Text2"
         Top             =   480
         Width           =   1215
      End
      Begin VB.TextBox TxtMEDLINEStitle 
         Height          =   285
         Left            =   3360
         TabIndex        =   9
         Text            =   "Text3"
         Top             =   480
         Width           =   3975
      End
      Begin VB.Label LabSECS 
         AutoSize        =   -1  'True
         Caption         =   "SECS identifier"
         Height          =   195
         Left            =   120
         TabIndex        =   29
         Top             =   240
         Width           =   1050
      End
      Begin VB.Label LabMEDLINE 
         AutoSize        =   -1  'True
         Caption         =   "MEDLINE code"
         Height          =   195
         Left            =   1680
         TabIndex        =   28
         Top             =   240
         Width           =   1125
      End
      Begin VB.Label LabMEDLINEStitle 
         AutoSize        =   -1  'True
         Caption         =   "Short title for MEDLINE"
         Height          =   195
         Left            =   3360
         TabIndex        =   27
         Top             =   240
         Width           =   1650
      End
   End
   Begin VB.Frame FrameNotes 
      Caption         =   "Notes"
      Height          =   1095
      Left            =   4080
      TabIndex        =   25
      Top             =   3840
      Width           =   3495
      Begin VB.TextBox TxtNotes 
         Height          =   735
         Left            =   120
         MultiLine       =   -1  'True
         TabIndex        =   11
         Top             =   240
         Width           =   3255
      End
   End
   Begin VB.Frame FrameIdxRange 
      Caption         =   "Indexation range"
      Height          =   1095
      Left            =   120
      TabIndex        =   24
      Top             =   3840
      Width           =   3855
      Begin VB.TextBox TxtIdxRange 
         Height          =   735
         Left            =   120
         MultiLine       =   -1  'True
         TabIndex        =   10
         Text            =   "Serial_4.frx":030A
         Top             =   240
         Width           =   3615
      End
   End
   Begin VB.Frame FrameInfoPub 
      Caption         =   "Information about the publisher and the journal (Part 2) "
      Height          =   2895
      Left            =   120
      TabIndex        =   16
      Top             =   0
      Width           =   7455
      Begin VB.TextBox TxtCprightDate 
         Height          =   285
         Left            =   5280
         TabIndex        =   5
         Text            =   "Text4"
         Top             =   1680
         Visible         =   0   'False
         Width           =   1215
      End
      Begin VB.TextBox TxtPhone 
         Height          =   285
         Left            =   4200
         TabIndex        =   2
         Top             =   1080
         Visible         =   0   'False
         Width           =   1455
      End
      Begin VB.TextBox TxtFaxNumber 
         Height          =   285
         Left            =   5760
         TabIndex        =   3
         Top             =   1080
         Visible         =   0   'False
         Width           =   1575
      End
      Begin VB.TextBox TxtCprighter 
         Height          =   285
         Left            =   120
         TabIndex        =   4
         Text            =   "Text4"
         Top             =   1680
         Width           =   5055
      End
      Begin VB.TextBox TxtEmail 
         Height          =   285
         Left            =   4200
         TabIndex        =   1
         Text            =   "Text4"
         Top             =   480
         Width           =   3135
      End
      Begin VB.TextBox TxtSponsor 
         Height          =   525
         Left            =   120
         MultiLine       =   -1  'True
         TabIndex        =   6
         Text            =   "Serial_4.frx":0315
         Top             =   2280
         Width           =   5055
      End
      Begin VB.TextBox TxtAddress 
         Height          =   855
         Left            =   120
         MultiLine       =   -1  'True
         TabIndex        =   0
         Top             =   480
         Width           =   3975
      End
      Begin VB.Label LabCprightDate 
         AutoSize        =   -1  'True
         Caption         =   "Copyright (Date)"
         Height          =   195
         Left            =   5280
         TabIndex        =   23
         Top             =   1440
         Visible         =   0   'False
         Width           =   1140
      End
      Begin VB.Label LabPhone 
         AutoSize        =   -1  'True
         Caption         =   "Phone Number"
         Height          =   195
         Left            =   4200
         TabIndex        =   22
         Top             =   840
         Visible         =   0   'False
         Width           =   1065
      End
      Begin VB.Label LabFax 
         AutoSize        =   -1  'True
         Caption         =   "Fax Number"
         Height          =   195
         Left            =   5760
         TabIndex        =   21
         Top             =   840
         Visible         =   0   'False
         Width           =   855
      End
      Begin VB.Label LabCprighter 
         AutoSize        =   -1  'True
         Caption         =   "Copyrighter"
         Height          =   195
         Left            =   120
         TabIndex        =   20
         Top             =   1440
         Width           =   795
      End
      Begin VB.Label LabSponsor 
         AutoSize        =   -1  'True
         Caption         =   "Sponsor"
         Height          =   195
         Left            =   120
         TabIndex        =   19
         Top             =   2040
         Width           =   585
      End
      Begin VB.Label LabEmail 
         AutoSize        =   -1  'True
         Caption         =   "Electronic address"
         Height          =   195
         Left            =   4200
         TabIndex        =   18
         Top             =   240
         Width           =   1305
      End
      Begin VB.Label LabAddress 
         AutoSize        =   -1  'True
         Caption         =   "Address"
         Height          =   195
         Left            =   120
         TabIndex        =   17
         Top             =   240
         Width           =   570
      End
   End
   Begin VB.CommandButton CmdBack 
      Caption         =   "Back"
      Height          =   375
      Left            =   2760
      TabIndex        =   12
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   6600
      TabIndex        =   15
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdNext 
      Caption         =   "Next"
      Height          =   375
      Left            =   3840
      TabIndex        =   13
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdSave 
      Caption         =   "Save"
      Height          =   375
      Left            =   5520
      TabIndex        =   14
      Top             =   5040
      Width           =   975
   End
   Begin VB.Label LabIndicationMandatoryField 
      Caption         =   "Label1"
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   120
      TabIndex        =   30
      Top             =   5040
      Width           =   2415
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
    Serial3.MyOpen (MyMfnTitle)
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
    Serial5.MyOpen (MyMfnTitle)
End Sub



Sub MySetLabels()
    With Fields
    LabAddress.Caption = .Fields("ser4_Address").GetLabel
    LabPhone.Caption = .Fields("ser4_Phone").GetLabel
    LabFax.Caption = .Fields("ser4_Fax").GetLabel
    LabEmail.Caption = .Fields("ser4_email").GetLabel
    LabCprightDate.Caption = .Fields("ser4_cprightDate").GetLabel
    LabCprighter.Caption = .Fields("ser4_cprighter").GetLabel
    LabSponsor.Caption = .Fields("ser4_sponsor").GetLabel
    LabSECS.Caption = .Fields("ser4_secs").GetLabel
    LabMEDLINE.Caption = .Fields("ser4_medline").GetLabel
    LabMEDLINEStitle.Caption = .Fields("ser4_MedlineStitle").GetLabel
    End With
    
    With ConfigLabels
    LabIndicationMandatoryField.Caption = .MandatoryFieldIndication
    FrameInfoPub.Caption = .ser4_FrameInfoPubJournal_2
    FrameInfoHealth.Caption = .ser4_FrameInfoHealth
    FrameIdxRange.Caption = .ser4_idxRange
    CmdBack.Caption = .ButtonBack
    CmdNext.Caption = .ButtonNext
    CmdClose.Caption = .ButtonClose
    CmdSave.Caption = .ButtonSave
    End With
    
    
End Sub

Sub MyClearContent()
        TxtAddress.text = ""
        TxtPhone.text = ""
        TxtFaxNumber.text = ""
        TxtEmail.text = ""
        TxtCprightDate.text = ""
        TxtCprighter.text = ""
        TxtSponsor.text = ""
        TxtSECS.text = ""
        TxtMEDLINE.text = ""
        TxtMEDLINEStitle.text = ""
        TxtIdxRange.text = ""

End Sub

Sub MyGetContentFromBase(MfnTitle As Long)
        TxtAddress.text = Serial_TxtContent(MfnTitle, 63)
        TxtPhone.text = Serial_TxtContent(MfnTitle, 631)
        TxtFaxNumber.text = Serial_TxtContent(MfnTitle, 632)
        TxtEmail.text = Serial_TxtContent(MfnTitle, 64)
        TxtCprightDate.text = Serial_TxtContent(MfnTitle, 621)
        TxtCprighter.text = Serial_TxtContent(MfnTitle, 62)
        TxtSponsor.text = Serial_TxtContent(MfnTitle, 140)
        TxtSECS.text = Serial_TxtContent(MfnTitle, 37)
        TxtMEDLINE.text = Serial_TxtContent(MfnTitle, 420)
        TxtMEDLINEStitle.text = Serial_TxtContent(MfnTitle, 421)
        TxtIdxRange.text = Serial_TxtContent(MfnTitle, 450)
        
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

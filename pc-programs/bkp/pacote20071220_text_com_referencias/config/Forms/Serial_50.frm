VERSION 5.00
Begin VB.Form Serial5 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Config - Serial's database"
   ClientHeight    =   5460
   ClientLeft      =   45
   ClientTop       =   1335
   ClientWidth     =   7710
   Icon            =   "Serial_50.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   NegotiateMenus  =   0   'False
   ScaleHeight     =   5460
   ScaleWidth      =   7710
   ShowInTaskbar   =   0   'False
   Begin VB.Frame FrameNotes 
      Caption         =   "Notes"
      Height          =   1095
      Left            =   120
      TabIndex        =   31
      Top             =   3840
      Width           =   7455
      Begin VB.TextBox TxtNotes 
         Height          =   735
         Left            =   120
         MultiLine       =   -1  'True
         TabIndex        =   32
         Top             =   240
         Width           =   7215
      End
   End
   Begin VB.CommandButton CmdBack 
      Caption         =   "Back"
      Height          =   375
      Left            =   2760
      TabIndex        =   10
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   6600
      TabIndex        =   12
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdSave 
      Caption         =   "Save"
      Height          =   375
      Left            =   5520
      TabIndex        =   11
      Top             =   5040
      Width           =   975
   End
   Begin VB.Frame FrameCenter 
      Caption         =   "Center's control information "
      Height          =   1575
      Left            =   120
      TabIndex        =   16
      Top             =   2280
      Width           =   7455
      Begin VB.TextBox TxtCreatDate 
         BackColor       =   &H00C0C0C0&
         Height          =   285
         Left            =   2760
         Locked          =   -1  'True
         TabIndex        =   13
         Text            =   "19990000"
         Top             =   1200
         Width           =   855
      End
      Begin VB.TextBox TxtDocCreation 
         Height          =   285
         Left            =   2760
         TabIndex        =   8
         Text            =   "FAPSB"
         Top             =   840
         Width           =   855
      End
      Begin VB.TextBox TxtDocUpdate 
         Height          =   285
         Left            =   6480
         TabIndex        =   9
         Text            =   "FAPSB"
         Top             =   840
         Width           =   855
      End
      Begin VB.TextBox TxtUpdateDate 
         BackColor       =   &H00C0C0C0&
         Height          =   285
         Left            =   6480
         Locked          =   -1  'True
         TabIndex        =   15
         Text            =   "19990000"
         Top             =   1200
         Width           =   855
      End
      Begin VB.TextBox TxtIdNumber 
         Height          =   285
         Left            =   5280
         TabIndex        =   7
         Text            =   "Text5"
         Top             =   360
         Width           =   2055
      End
      Begin VB.ComboBox ComboCCode 
         Height          =   315
         ItemData        =   "Serial_50.frx":030A
         Left            =   120
         List            =   "Serial_50.frx":030C
         Sorted          =   -1  'True
         TabIndex        =   6
         Text            =   "pode digitar também?"
         Top             =   480
         Width           =   4095
      End
      Begin VB.Label LabDocUpdate 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Documentalist (update)"
         Height          =   195
         Left            =   4800
         TabIndex        =   28
         Top             =   840
         Width           =   1635
      End
      Begin VB.Label LabDocCreation 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Documentalist (creation)"
         Height          =   195
         Left            =   840
         TabIndex        =   27
         Top             =   840
         Width           =   1710
      End
      Begin VB.Label LabUpdateDate 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Update date"
         Height          =   195
         Left            =   5520
         TabIndex        =   26
         Top             =   1200
         Width           =   885
      End
      Begin VB.Label LabCreatDate 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Creation date"
         Height          =   195
         Left            =   1560
         TabIndex        =   25
         Top             =   1200
         Width           =   945
      End
      Begin VB.Label LabIdNumber 
         AutoSize        =   -1  'True
         Caption         =   "Identification number"
         Height          =   195
         Left            =   5280
         TabIndex        =   24
         Top             =   120
         Width           =   1470
      End
      Begin VB.Label LabCCode 
         AutoSize        =   -1  'True
         Caption         =   "Center code"
         Height          =   195
         Left            =   120
         TabIndex        =   23
         Top             =   240
         Width           =   870
      End
   End
   Begin VB.Frame FrameSciELO 
      Caption         =   "SciELO's control information "
      Height          =   2175
      Left            =   120
      TabIndex        =   14
      Top             =   0
      Width           =   7455
      Begin VB.ListBox ListSciELONet 
         Height          =   510
         Left            =   4080
         Sorted          =   -1  'True
         Style           =   1  'Checkbox
         TabIndex        =   29
         Top             =   1560
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
         Width           =   1095
      End
      Begin VB.ComboBox ComboUserSubscription 
         Height          =   315
         Left            =   120
         Sorted          =   -1  'True
         TabIndex        =   5
         Text            =   "Combo1"
         Top             =   1680
         Width           =   3855
      End
      Begin VB.TextBox TxtSiteLocation 
         Height          =   285
         Left            =   4080
         TabIndex        =   3
         Text            =   "Text4"
         Top             =   960
         Width           =   3255
      End
      Begin VB.TextBox TxtSep 
         Height          =   285
         Left            =   3000
         TabIndex        =   2
         Text            =   "Text3"
         Top             =   360
         Width           =   4215
      End
      Begin VB.ComboBox ComboFTP 
         Height          =   315
         Left            =   120
         Sorted          =   -1  'True
         TabIndex        =   4
         Text            =   "Combo1"
         Top             =   1080
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
      Begin VB.Label LabScieloNET 
         AutoSize        =   -1  'True
         Caption         =   "Scielo net"
         Height          =   195
         Left            =   4080
         TabIndex        =   30
         Top             =   1320
         Width           =   705
      End
      Begin VB.Label LabSep 
         AutoSize        =   -1  'True
         Caption         =   "Separator"
         Height          =   195
         Left            =   3000
         TabIndex        =   22
         Top             =   120
         Width           =   690
      End
      Begin VB.Label LabSiteLocation 
         AutoSize        =   -1  'True
         Caption         =   "Site location"
         Height          =   195
         Left            =   4080
         TabIndex        =   21
         Top             =   720
         Width           =   870
      End
      Begin VB.Label LabUserSubscription 
         AutoSize        =   -1  'True
         Caption         =   "User's subscription"
         Height          =   195
         Left            =   120
         TabIndex        =   20
         Top             =   1440
         Width           =   1320
      End
      Begin VB.Label LabFTP 
         AutoSize        =   -1  'True
         Caption         =   "FTP"
         Height          =   195
         Left            =   120
         TabIndex        =   19
         Top             =   840
         Width           =   300
      End
      Begin VB.Label LabPubId 
         AutoSize        =   -1  'True
         Caption         =   "Publisher's identifier"
         Height          =   195
         Left            =   1320
         TabIndex        =   18
         Top             =   240
         Width           =   1380
      End
      Begin VB.Label LabSiglum 
         AutoSize        =   -1  'True
         Caption         =   "Siglum"
         Height          =   195
         Left            =   120
         TabIndex        =   17
         Top             =   240
         Width           =   465
      End
   End
End
Attribute VB_Name = "Serial5"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public IsBack As Boolean
Private MyMfnTitle As Long

Private Sub CmdBack_Click()
    Hide
    IsBack = True
End Sub

Sub MySetLabels()
    With ConfigLabels
    
    LabScieloNET.Caption = .ser5_SciELONet
    FrameSciELO.Caption = .ser5_FrameSciELOControl
    LabSiglum.Caption = .ser5_siglum
    LabPubId.Caption = .ser5_PubId
    LabSep.Caption = .ser5_Sep
    LabSiteLocation.Caption = .ser5_SiteLocation
    LabFTP.Caption = .ser5_FTP
    LabUserSubscription.Caption = .ser5_UserSubscription
    FrameCenter.Caption = .ser5_FrameCenterControl
    LabCCode.Caption = .ser5_CCode
    LabIdNumber.Caption = .ser5_IdNumber
    LabDocCreation.Caption = .ser5_DocCreation
    LabCreatDate.Caption = .ser5_CreatDate
    LabDocUpdate.Caption = .ser5_DocUpdate
    LabUpdateDate.Caption = .ser5_UpdateDate
    CmdBack.Caption = .ButtonBack
    CmdClose.Caption = .ButtonClose
    'CmdCancel.Caption = .ButtonCancel
    CmdSave.Caption = .ButtonSave
    End With
    
    Call FillCombo(ComboFTP, CodeFTP)
    Call FillCombo(ComboUserSubscription, CodeUsersubscription)
    Call FillCombo(ComboCCode, CodeCCode)
    Call FillList(ListSciELONet, CodeScieloNet)
End Sub
Sub MyGetContentFromBase(MfnTitle As Long)
        
        
        TxtSiglum.Text = Serial_TxtContent(MfnTitle, 930)
        TxtPubId.Text = Serial_TxtContent(MfnTitle, 68)
        TxtSep.Text = Serial_TxtContent(MfnTitle, 65)
        TxtSiteLocation.Text = Serial_TxtContent(MfnTitle, 69)
        ComboFTP.Text = Serial_ComboContent(CodeFTP, MfnTitle, 66)
        ComboUserSubscription.Text = Serial_ComboContent(CodeUsersubscription, MfnTitle, 67)
        Call ScieloNetRead(MfnTitle)
        
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

Private Sub New_CmdClose_Click()
    Dim resp As VbMsgBoxResult
            
            
    Serial1.WarnMandatoryFields
    Serial2.WarnMandatoryFields
    Serial3.WarnMandatoryFields
    Serial4.WarnMandatoryFields
            
    WarnMandatoryFields
    
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
    
    With ConfigLabels
    
    warning = warning + MandatoryFields(TxtSiglum.Text, .ser5_siglum)
    warning = warning + MandatoryFields(TxtSiglum.Text, .ser5_siglum)
    warning = warning + MandatoryFields(TxtPubId.Text, .ser5_PubId)
    warning = warning + MandatoryFields(TxtSiteLocation.Text, .ser5_SiteLocation)
    warning = warning + MandatoryFields(ComboFTP.Text, .ser5_FTP)
    warning = warning + MandatoryFields(ComboUserSubscription.Text, .ser5_UserSubscription)
    If ListSciELONet.SelCount = 0 Then warning = warning + MandatoryFields("", .ser5_SciELONet)
    warning = warning + MandatoryFields(ComboCCode.Text, .ser5_CCode)
    warning = warning + MandatoryFields(TxtDocCreation.Text, .ser5_DocCreation)
    warning = warning + MandatoryFields(TxtCreatDate.Text, .ser5_CreatDate)
    warning = warning + MandatoryFields(TxtDocUpdate.Text, .ser5_DocUpdate)
    warning = warning + MandatoryFields(TxtUpdateDate.Text, .ser5_UpdateDate)
    
    End With
    If Len(warning) > 0 Then
        MsgBox warning
    End If
    WarnMandatoryFields = (Len(warning) > 0)
End Function

Private Sub listscielonet_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help5_SciELONet, 2
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

Private Sub ComboUserSubscription_gotfocus()
    FrmInfo.ShowHelpMessage FrmInfo.Help5_UserSubscription, 2
End Sub

Function ScieloNetRead(MfnTitle As Long) As String
    Dim i As Long
    Dim Item As ClCode
    Dim exist As Boolean
    Dim idx As Long
    Dim content As String
    
    content = Serial_TxtContent(MfnTitle, 691)
    If Len(content) > 0 Then
        Set Item = New ClCode
        For i = 0 To ListSciELONet.ListCount - 1
            Set Item = CodeScieloNet(ListSciELONet.List(i), exist)
            If exist Then
                idx = CLng(Item.Code)
                If idx <= Len(content) Then
                    ListSciELONet.Selected(i) = (Mid(content, idx, 1) = 1)
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
        
    For i = Len(content) + 1 To ListSciELONet.ListCount
        content = content + "0"
    Next
    
    ScieloNetRead = content
End Function



Function ScieloNetWrite() As String
    Dim i As Long
    Dim Item As ClCode
    Dim exist As Boolean
    Dim s() As String
    Dim q As Long
    Dim content As String
    
    
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
        content = content + s(i)
    Next
    ScieloNetWrite = content
End Function


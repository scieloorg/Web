VERSION 5.00
Begin VB.Form FrmReplaceIssue 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Form1"
   ClientHeight    =   3495
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5370
   Icon            =   "FrmReplaceIssue.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3495
   ScaleWidth      =   5370
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton CmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   4320
      TabIndex        =   5
      Top             =   2040
      Width           =   975
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "OK"
      Height          =   375
      Left            =   4320
      TabIndex        =   4
      Top             =   1560
      Width           =   975
   End
   Begin VB.Frame FramFascId 
      Height          =   855
      Index           =   1
      Left            =   120
      TabIndex        =   15
      Top             =   2520
      Width           =   4095
      Begin VB.TextBox TxtSupplNo 
         Height          =   285
         Index           =   1
         Left            =   3000
         TabIndex        =   3
         Top             =   480
         Width           =   975
      End
      Begin VB.TextBox TxtIssueno 
         Height          =   285
         Index           =   1
         Left            =   2040
         TabIndex        =   2
         Top             =   480
         Width           =   975
      End
      Begin VB.TextBox TxtVolid 
         Height          =   285
         Index           =   1
         Left            =   120
         TabIndex        =   0
         Top             =   480
         Width           =   975
      End
      Begin VB.TextBox TxtSupplVol 
         Height          =   285
         Index           =   1
         Left            =   1080
         TabIndex        =   1
         Top             =   480
         Width           =   975
      End
      Begin VB.Label LabSupplNro 
         Caption         =   "Suppl"
         Height          =   255
         Index           =   1
         Left            =   3000
         TabIndex        =   19
         Top             =   240
         Width           =   855
      End
      Begin VB.Label LabNro 
         Caption         =   "No"
         Height          =   255
         Index           =   1
         Left            =   2040
         TabIndex        =   18
         Top             =   240
         Width           =   855
      End
      Begin VB.Label LabVol 
         Caption         =   "Vol"
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   17
         Top             =   240
         Width           =   855
      End
      Begin VB.Label LabSupplVol 
         Caption         =   "Suppl"
         Height          =   255
         Index           =   1
         Left            =   1080
         TabIndex        =   16
         Top             =   240
         Width           =   855
      End
   End
   Begin VB.Frame FramFascId 
      Height          =   855
      Index           =   0
      Left            =   120
      TabIndex        =   10
      Top             =   1440
      Width           =   4095
      Begin VB.TextBox TxtSupplNo 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   3000
         Locked          =   -1  'True
         TabIndex        =   9
         Top             =   480
         Width           =   975
      End
      Begin VB.TextBox TxtIssueno 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   2040
         Locked          =   -1  'True
         TabIndex        =   8
         Top             =   480
         Width           =   975
      End
      Begin VB.TextBox TxtVolid 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   120
         Locked          =   -1  'True
         TabIndex        =   6
         Top             =   480
         Width           =   975
      End
      Begin VB.TextBox TxtSupplVol 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   1080
         Locked          =   -1  'True
         TabIndex        =   7
         Top             =   480
         Width           =   975
      End
      Begin VB.Label LabSupplNro 
         Caption         =   "Suppl"
         Height          =   255
         Index           =   0
         Left            =   3000
         TabIndex        =   14
         Top             =   240
         Width           =   855
      End
      Begin VB.Label LabNro 
         Caption         =   "No"
         Height          =   255
         Index           =   0
         Left            =   2040
         TabIndex        =   13
         Top             =   240
         Width           =   855
      End
      Begin VB.Label LabVol 
         Caption         =   "Vol"
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   12
         Top             =   240
         Width           =   855
      End
      Begin VB.Label LabSupplVol 
         Caption         =   "Suppl"
         Height          =   255
         Index           =   0
         Left            =   1080
         TabIndex        =   11
         Top             =   240
         Width           =   855
      End
   End
   Begin VB.Label LabMsg 
      Caption         =   "Label1"
      Height          =   855
      Left            =   240
      TabIndex        =   20
      Top             =   240
      Width           =   4935
   End
End
Attribute VB_Name = "FrmReplaceIssue"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private SERIALTITLE As String
Private MfnSource As Long

Private v As String
Private vs As String
Private n As String
Private ns As String

Private replaced As Boolean

Private Sub CmdCancel_Click()
    Unload Me
End Sub

Private Sub cmdOK_Click()
    Dim MfnIssueId As Long
    Dim resp As VbMsgBoxResult
    
    replaced = False
    If Len(IssueId(TxtVolid(1).Text, TxtSupplVol(1).Text, TxtIssueno(1).Text, TxtSupplNo(1).Text)) > 0 Then
        MfnIssueId = FindIssue(SERIALTITLE, TxtVolid(1).Text, TxtSupplVol(1).Text, TxtIssueno(1).Text, TxtSupplNo(1).Text)
        If MfnIssueId > 0 Then
            Call MsgBox(ConfigLabels.MsgReplaceIssueAlreadyExists, vbOKOnly)
        Else
            resp = MsgBox(ConfigLabels.MsgReplaceIssue, vbYesNoCancel + vbDefaultButton2)
            If resp = vbYes Then
                If BDIssues.FieldContentUpdate(MfnSource, 31, TxtVolid(1).Text) Then
                If BDIssues.FieldContentUpdate(MfnSource, 32, TxtIssueno(1).Text) Then
                If BDIssues.FieldContentUpdate(MfnSource, 131, TxtSupplVol(1).Text) Then
                If BDIssues.FieldContentUpdate(MfnSource, 132, TxtSupplNo(1).Text) Then
                    Call BDIssues.IfUpdate(MfnSource, MfnSource)
                    v = TxtVolid(1).Text
                    vs = TxtSupplVol(1).Text
                    n = TxtIssueno(1).Text
                    ns = TxtSupplNo(1).Text
                    replaced = True
                End If
                End If
                End If
                End If
                Unload Me
            ElseIf resp = vbNo Then
                Unload Me
            Else
        
            End If
        End If
    Else
        MsgBox ConfigLabels.MsgMissingIssueId
    End If
End Sub

Private Sub Form_Load()
    With ConfigLabels
    Caption = .Issue_Replace
    LabVol(0).Caption = .Volume
    LabSupplVol(0).Caption = .VolSuppl
    LabNro(0).Caption = .Issueno
    LabSupplNro(0).Caption = .IssueSuppl
    CmdCancel.Caption = .ButtonCancel
    CmdOK.Caption = .ButtonOK
    FramFascId(0) = .Issue_Current
    FramFascId(1) = .Issue_Changeto
    LabMsg.Caption = .MsgReplaceIssue
    End With
End Sub

Sub ReplaceIssue(Sertitle As String, Vol As TextBox, supplvol As TextBox, Issueno As TextBox, Supplno As TextBox)
    
    MfnSource = FindIssue(Sertitle, Vol.Text, supplvol.Text, Issueno.Text, Supplno.Text)
    If MfnSource > 0 Then
        SERIALTITLE = Sertitle
        TxtVolid(0).Text = Vol
        TxtSupplVol(0).Text = supplvol
        TxtIssueno(0).Text = Issueno
        TxtSupplNo(0).Text = Supplno
    
        Show vbModal
        
        If replaced Then
            Vol.Text = v
            supplvol.Text = vs
            Issueno.Text = n
            Supplno.Text = ns
        End If
    Else
        MsgBox ConfigLabels.MSGISSUENOEXIST
    End If
End Sub

Private Function FindIssue(Sertitle As String, Vol As String, SVol As String, No As String, SNo As String) As Long
    Dim resp As Boolean
    Dim mfn As Long
    Dim IseqNoFound() As Long
    Dim IseqNoFoundCount As Long
    Dim IssueIdFound() As Long
    Dim IssueIdFoundCount As Long
    Dim rIseqNo As String
    Dim rIssueId As String
    Dim MfnIseqNo As Long
    Dim MfnIssueId As Long
    Dim IseqNoPFT As String
    Dim IssueIdPFT As String
    Dim resp1 As Boolean
    Dim xSertitle As String
    Dim xVol As String
    Dim xNro As String
    Dim xSupplVol As String
    Dim xSupplNro As String
    Dim xNroSeq As String
    Dim i As Long
    Dim Mfns() As Long
    Dim q As Long
    Dim mfn1 As Long
    Dim mfn2 As Long
    
    q = BDIssues.MfnFind(IssueId(Vol, SVol, No, SNo) + Sertitle, Mfns)
    While (i < q) And (MfnIssueId = 0)
        i = i + 1
        xNro = BDIssues.UsePft(Mfns(i), "v32")
        xVol = BDIssues.UsePft(Mfns(i), "v31")
        xSupplNro = BDIssues.UsePft(Mfns(i), "v132")
        xSupplVol = BDIssues.UsePft(Mfns(i), "v131")
        xSertitle = BDIssues.UsePft(Mfns(i), "v130")
        If (Vol = xVol) And (SVol = xSupplVol) And (No = xNro) And (SNo = xSupplNro) And (Sertitle = xSertitle) Then
            MfnIssueId = Mfns(i)
        End If
    Wend
    
    If (MfnIssueId = 0) Then
    
    IssueIdPFT = "if "
    IssueIdPFT = IssueIdPFT + "v130='" + Sertitle + "' and "
    IssueIdPFT = IssueIdPFT + "v31='" + Vol + "' and "
    IssueIdPFT = IssueIdPFT + "v131='" + SVol + "' and "
    IssueIdPFT = IssueIdPFT + "v32='" + No + "' and "
    IssueIdPFT = IssueIdPFT + "v132='" + SNo + "' then mfn fi"
    
    mfn = 0
    While (mfn < BDIssues.MfnQuantity) And (MfnIssueId = 0)
        mfn = mfn + 1
        rIssueId = BDIssues.UsePft(mfn, IssueIdPFT)
        If Len(rIssueId) > 0 Then
            MfnIssueId = mfn
        End If
    Wend
    End If
    
    
    FindIssue = MfnIssueId
End Function



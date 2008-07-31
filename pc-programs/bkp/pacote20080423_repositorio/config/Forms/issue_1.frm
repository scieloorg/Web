VERSION 5.00
Begin VB.Form Issue1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Issue"
   ClientHeight    =   5520
   ClientLeft      =   1905
   ClientTop       =   1680
   ClientWidth     =   7875
   Icon            =   "issue_1.frx":0000
   LinkTopic       =   "Form4"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   5520
   ScaleWidth      =   7875
   StartUpPosition =   2  'CenterScreen
   Begin VB.ListBox ListScheme 
      Height          =   60
      Left            =   480
      Style           =   1  'Checkbox
      TabIndex        =   33
      Top             =   5280
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.CommandButton CmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   5880
      TabIndex        =   9
      Top             =   5040
      Width           =   855
   End
   Begin VB.CommandButton FormCmdAju 
      Caption         =   "Help"
      Height          =   375
      Left            =   6840
      TabIndex        =   10
      Top             =   5040
      Width           =   855
   End
   Begin VB.CommandButton CmdReplace 
      Caption         =   "Replace"
      Height          =   375
      Left            =   2760
      TabIndex        =   7
      Top             =   5040
      Width           =   1335
   End
   Begin VB.CommandButton CmdDelete 
      Caption         =   "Delete"
      Height          =   375
      Left            =   4200
      TabIndex        =   8
      Top             =   5040
      Width           =   1335
   End
   Begin VB.CommandButton CmdView 
      Caption         =   "Open"
      Height          =   375
      Left            =   1320
      TabIndex        =   6
      Top             =   5040
      Width           =   1335
   End
   Begin VB.Frame FramPer 
      Height          =   4935
      Left            =   120
      TabIndex        =   14
      Top             =   0
      Width           =   7695
      Begin VB.TextBox TxtParallel 
         BackColor       =   &H00C0C0C0&
         Height          =   735
         Left            =   2280
         Locked          =   -1  'True
         MultiLine       =   -1  'True
         TabIndex        =   28
         Top             =   1800
         Width           =   5295
      End
      Begin VB.Frame FramFascId 
         Height          =   855
         Index           =   0
         Left            =   1800
         TabIndex        =   20
         Top             =   3840
         Width           =   5775
         Begin VB.TextBox TxtIseqno 
            Height          =   285
            Left            =   4200
            TabIndex        =   4
            Top             =   480
            Width           =   975
         End
         Begin VB.CommandButton CmdViewIseqNo 
            Caption         =   "..."
            Height          =   375
            Left            =   5280
            TabIndex        =   5
            Top             =   360
            Width           =   375
         End
         Begin VB.TextBox TxtSupplVol 
            Height          =   285
            Left            =   1200
            TabIndex        =   1
            Top             =   480
            Width           =   855
         End
         Begin VB.TextBox TxtVolid 
            Height          =   285
            Left            =   120
            TabIndex        =   0
            Top             =   480
            Width           =   975
         End
         Begin VB.TextBox TxtIssueno 
            Height          =   285
            Left            =   2160
            TabIndex        =   2
            Top             =   480
            Width           =   855
         End
         Begin VB.TextBox TxtSupplNo 
            Height          =   285
            Left            =   3120
            TabIndex        =   3
            Top             =   480
            Width           =   855
         End
         Begin VB.Label LabSupplVol 
            Caption         =   "Suppl"
            Height          =   255
            Left            =   1200
            TabIndex        =   25
            Top             =   240
            Width           =   735
         End
         Begin VB.Label LabVol 
            Caption         =   "Vol"
            Height          =   255
            Left            =   120
            TabIndex        =   24
            Top             =   240
            Width           =   735
         End
         Begin VB.Label LabNro 
            Caption         =   "No"
            Height          =   255
            Left            =   2160
            TabIndex        =   23
            Top             =   240
            Width           =   615
         End
         Begin VB.Label LabNroSeq 
            Caption         =   "Seq No"
            Height          =   255
            Left            =   4200
            TabIndex        =   22
            Top             =   240
            Width           =   975
         End
         Begin VB.Label LabSupplNro 
            Caption         =   "Suppl"
            Height          =   255
            Left            =   3120
            TabIndex        =   21
            Top             =   240
            Width           =   735
         End
      End
      Begin VB.TextBox TxtPubl 
         BackColor       =   &H00C0C0C0&
         Height          =   645
         Left            =   2280
         Locked          =   -1  'True
         MultiLine       =   -1  'True
         TabIndex        =   13
         TabStop         =   0   'False
         Top             =   2640
         Width           =   5295
      End
      Begin VB.Label LabIndicationMandatoryField 
         Caption         =   "Label1"
         ForeColor       =   &H000000FF&
         Height          =   495
         Left            =   240
         TabIndex        =   32
         Top             =   4200
         Width           =   1455
      End
      Begin VB.Label TxtISOStitle 
         BackColor       =   &H00C0C0C0&
         BorderStyle     =   1  'Fixed Single
         Height          =   255
         Left            =   2280
         TabIndex        =   31
         Top             =   1320
         Width           =   5295
      End
      Begin VB.Label LabISOStitle 
         AutoSize        =   -1  'True
         Caption         =   "ISO Short Title"
         Height          =   195
         Left            =   240
         TabIndex        =   30
         Top             =   1320
         Width           =   1035
      End
      Begin VB.Label TxtSertitle 
         BackColor       =   &H00C0C0C0&
         BorderStyle     =   1  'Fixed Single
         Height          =   255
         Left            =   2280
         TabIndex        =   29
         Top             =   240
         Width           =   5295
      End
      Begin VB.Label LabMedlineStitle 
         AutoSize        =   -1  'True
         Caption         =   "Medline Short Title"
         Height          =   195
         Left            =   240
         TabIndex        =   27
         Top             =   960
         Width           =   1320
      End
      Begin VB.Label TxtMedlineStitle 
         BackColor       =   &H00C0C0C0&
         BorderStyle     =   1  'Fixed Single
         Height          =   255
         Left            =   2280
         TabIndex        =   26
         Top             =   960
         Width           =   5295
      End
      Begin VB.Label TxtStitle 
         BackColor       =   &H00C0C0C0&
         BorderStyle     =   1  'Fixed Single
         Height          =   255
         Left            =   2280
         TabIndex        =   11
         Top             =   600
         Width           =   5295
      End
      Begin VB.Label LabTitulo 
         AutoSize        =   -1  'True
         Caption         =   "Title"
         Height          =   195
         Left            =   240
         TabIndex        =   19
         Top             =   240
         Width           =   300
      End
      Begin VB.Label LabTitAbr 
         AutoSize        =   -1  'True
         Caption         =   "Short Title"
         Height          =   195
         Left            =   240
         TabIndex        =   18
         Top             =   600
         Width           =   720
      End
      Begin VB.Label LabTitAlt 
         AutoSize        =   -1  'True
         Caption         =   "Alternatives Titles"
         Height          =   195
         Left            =   240
         TabIndex        =   17
         Top             =   1800
         Width           =   1245
      End
      Begin VB.Label LabISSN 
         AutoSize        =   -1  'True
         Caption         =   "ISSN"
         Height          =   195
         Left            =   240
         TabIndex        =   16
         Top             =   3480
         Width           =   375
      End
      Begin VB.Label TxtISSN 
         BackColor       =   &H00C0C0C0&
         BorderStyle     =   1  'Fixed Single
         Height          =   255
         Left            =   2280
         TabIndex        =   12
         Top             =   3480
         Width           =   1335
      End
      Begin VB.Label LabPubl 
         AutoSize        =   -1  'True
         Caption         =   "Publisher"
         Height          =   195
         Left            =   240
         TabIndex        =   15
         Top             =   2640
         Width           =   645
      End
   End
End
Attribute VB_Name = "Issue1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private MyMfnTitle As Long

Private NormalHeight As Long
Private NormalWidth As Long
Private OldHeight As Long
Private OldWidth As Long

Public Cidade As String
Public SiglaPeriodico As String
Public Title_Standard As String
Public Title_Scheme As String
Public Title_Freq As String
Public Year As String


Private Sub CmdClose_Click()
    Unload Me
End Sub

Private Function FindIssueToDelete(Sertitle As String, Vol As String, SVol As String, No As String, SNo As String) As Long
    Dim resp As Boolean
    Dim Mfn As Long
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
    
    Mfn = 0
    While (Mfn < BDIssues.MfnQuantity) And (MfnIssueId = 0)
        Mfn = Mfn + 1
        rIssueId = BDIssues.UsePft(Mfn, IssueIdPFT)
        If Len(rIssueId) > 0 Then
            MfnIssueId = Mfn
        End If
    Wend
    End If
    
    FindIssueToDelete = MfnIssueId
End Function


Private Sub CmdDelete_Click()
    Dim resp As VbMsgBoxResult
    Dim Mfn As Long
    
    If CheckIssueId Then
        Mfn = FindIssueToDelete(TxtSerTitle.Caption, TxtVolid.text, TxtSupplVol.text, TxtIssueno.text, TxtSupplNo.text)
        If Mfn > 0 Then
            resp = MsgBox(ConfigLabels.MsgDeleteIssue, vbYesNo + vbDefaultButton2)
            If resp = vbYes Then
                If BDIssues.RecordDel(Mfn) Then
                    Call BDIssues.IfUpdate(Mfn, Mfn)
                    TxtVolid.text = ""
                    TxtSupplVol.text = ""
                    TxtIssueno.text = ""
                    TxtSupplNo.text = ""
                    TxtIseqno.text = ""
                End If
            End If
        Else
            MsgBox ConfigLabels.MSGISSUENOEXIST
        End If
    Else
    End If
    
End Sub

Private Sub CmdReplace_Click()
    
    If MousePointer = vbArrowQuestion Then
        MousePointer = vbArrow
    Else
        If CheckIssueId Then
            Call FrmReplaceIssue.ReplaceIssue(TxtSerTitle.Caption, TxtVolid, TxtSupplVol, TxtIssueno, TxtSupplNo)
        Else
        End If
    End If
    
End Sub

Private Sub CmdView_Click()
    Dim MfnIssue As Long
    
    If MousePointer = vbArrowQuestion Then
        MousePointer = vbArrow
    Else
        If CheckIssueId_Iseqno Then
            If FindIssueToOpen(MfnIssue, TxtSerTitle.Caption, TxtVolid.text, TxtSupplVol.text, TxtIssueno.text, TxtSupplNo.text, TxtIseqno.text) Then
                Issue2.LoadIssue (MfnIssue)
            End If
        End If
    End If
End Sub

Private Sub CmdAju_Click()
    Call frmFindBrowser.CallBrowser(FormMenuPrin.DirStruct.Nodes("Help of Issue").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Help of Issue").text)
End Sub

Private Sub CmdViewIseqNo_Click()
    Dim volid As String
    Dim Issueno As String
    Dim supplvol As String
    Dim Supplno As String
    Dim iseqno As String
    
    MousePointer = vbHourglass
    volid = TxtVolid.text
    supplvol = TxtSupplVol.text
    Issueno = TxtIssueno.text
    Supplno = TxtSupplNo.text
    iseqno = TxtIseqno.text
    Call FrmSeqNumber.ViewIseqNo(TxtSerTitle.Caption, volid, supplvol, Issueno, Supplno, iseqno)
    TxtVolid.text = volid
    TxtSupplVol.text = supplvol
    TxtIssueno.text = Issueno
    TxtSupplNo.text = Supplno
    TxtIseqno.text = iseqno
    MousePointer = vbArrow
End Sub

Private Sub Form_Load()
    OldHeight = Height
    OldWidth = Width
    NormalHeight = Height
    NormalWidth = Width
End Sub

Private Function CheckIssueId_Iseqno() As Boolean
    Dim retorno As Boolean

    If Len(Trim(TxtVolid.text)) > 0 Then
        retorno = True
    ElseIf Len(Trim(TxtIssueno.text)) > 0 Then
        retorno = True
    End If
    
    If Not retorno Then MsgBox ConfigLabels.MsgMissingIssueId
    
    If Len(Trim(TxtIseqno.text)) < 5 Then
        retorno = False
    ElseIf Not (TxtIseqno.text Like String(Len(TxtIseqno.text), "#")) Then
        retorno = False
    End If
    
    If Not retorno Then
        MsgBox (ConfigLabels.MsgInvalidFormatSeqNumber)
    Else
        Year = Mid(TxtIseqno.text, 1, 4)
    End If
    
    CheckIssueId_Iseqno = retorno
End Function

Private Function CheckIssueId() As Boolean
    Dim retorno As Boolean

    If Len(Trim(TxtVolid.text)) > 0 Then
        retorno = True
    ElseIf Len(Trim(TxtIssueno.text)) > 0 Then
        retorno = True
    ElseIf Len(Trim(TxtSupplNo.text)) > 0 Then
        retorno = True
    ElseIf Len(Trim(TxtSupplVol.text)) > 0 Then
        retorno = True
    End If
    
    If Not retorno Then MsgBox ConfigLabels.MsgMissingIssueId
    
    
    CheckIssueId = retorno
End Function

Private Sub Form_Resize()
    Resize
End Sub

Private Sub Resize()
    Dim x As Double
    Dim Y As Double
    
    If WindowState <> vbMinimized Then
        If Height < NormalHeight Then
            'OldHeight = Height
            Height = NormalHeight
        ElseIf Width < NormalWidth Then
            'OldWidth = Width
            Width = NormalWidth
        Else
            x = Width / OldWidth
            Y = Height / OldHeight
            Call Posicionar(x, Y)
            OldHeight = Height
            OldWidth = Width
        End If
    End If
End Sub

Private Sub Redimensionar(obj As Object, Left As Double, Top As Double, Width As Double, Height As Double)
    
End Sub

Private Sub Posicionar(x As Double, Y As Double)
    Call Redimensionar(FramPer, x, Y, x, Y)
    Call Redimensionar(LabTitulo, x, Y, 1, 1)
    Call Redimensionar(TxtSerTitle, x, Y, x, 1)
    Call Redimensionar(LabTitAbr, x, Y, 1, 1)
    Call Redimensionar(TxtStitle, x, Y, x, 1)
    Call Redimensionar(LabTitAlt, x, Y, 1, 1)
    Call Redimensionar(TxtParallel, x, Y, x, 1)
    Call Redimensionar(LabISSN, x, Y, 1, 1)
    Call Redimensionar(TxtISSN, x, Y, x, 1)
    Call Redimensionar(LabPubl, x, Y, 1, 1)
    Call Redimensionar(TxtPubl, x, Y, x, 1)
    
    Call Redimensionar(FramFascId, x, Y, x, Y)
    
    Call Redimensionar(LabVol, x, Y, 1, 1)
    Call Redimensionar(TxtVolid, x, Y, x, 1)
    Call Redimensionar(LabNro, x, Y, 1, 1)
    Call Redimensionar(TxtIssueno, x, Y, x, 1)
    Call Redimensionar(LabSupplVol, x, Y, 1, 1)
    Call Redimensionar(TxtSupplVol, x, Y, x, 1)
    Call Redimensionar(LabSupplNro, x, Y, 1, 1)
    Call Redimensionar(TxtSupplNo, x, Y, x, 1)
    Call Redimensionar(LabNroSeq, x, Y, 1, 1)
    Call Redimensionar(TxtIseqno, x, Y, x, 1)
    
    'Call Redimensionar(CmdGarbageCollection, x, Y, x, Y)
    Call Redimensionar(CmdView, x, Y, x, Y)
    'Call Redimensionar(CmdClose, x, Y, x, Y)
    'Call Redimensionar(CmdAju, x, Y, x, Y)
    
End Sub

Private Sub FormCmdAju_Click()
    Call frmFindBrowser.CallBrowser(FormMenuPrin.DirStruct.Nodes("Help of Issue").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Help of Issue").text)
End Sub


Private Sub txtparallel_Click()
    If MousePointer = vbArrowQuestion Then
        MousePointer = vbArrow
    End If
End Sub
Private Sub txtIssueno_Change()
    If MousePointer = vbArrowQuestion Then
        MousePointer = vbArrow
    End If
End Sub

Private Sub TxtVolid_Change()
    If MousePointer = vbArrowQuestion Then
        MousePointer = vbArrow
    End If
End Sub

Sub OpenIssue(Sertitle As String)
    TxtSerTitle.Caption = Sertitle
    
    MyMfnTitle = Serial_CheckExisting(TxtSerTitle.Caption)
    
    TxtPubl.text = Serial_TxtContent(MyMfnTitle, 480)
    Cidade = Serial_TxtContent(MyMfnTitle, 490)
    SiglaPeriodico = Serial_TxtContent(MyMfnTitle, 930)
    Title_Standard = Serial_ComboContent(CodeStandard, MyMfnTitle, 117)
    Call FillList(ListScheme, CodeScheme)
    Call Serial_ListContent(ListScheme, CodeScheme, MyMfnTitle, 85)
    Title_Freq = Serial_TxtContent(MyMfnTitle, 380)
    
    TxtISOStitle.Caption = Serial_TxtContent(MyMfnTitle, 151)
    TxtStitle.Caption = Serial_TxtContent(MyMfnTitle, 150)
    TxtMEDLINEStitle.Caption = Serial_TxtContent(MyMfnTitle, 421)
    TxtISSN.Caption = Serial_TxtContent(MyMfnTitle, 400)
    TxtParallel.text = Serial_TxtContent(MyMfnTitle, 230)
    
    With Fields
    LabISSN.Caption = .Fields("ser1_issn").GetLabel
    LabNro.Caption = .Fields("Issueno").GetLabel
    LabNroSeq.Caption = .Fields("SequentialNumber").GetLabel
    LabPubl.Caption = .Fields("ser3_Publisher").GetLabel
    LabSupplNro.Caption = .Fields("IssueSuppl").GetLabel
    LabSupplVol.Caption = .Fields("VolSuppl").GetLabel
    LabTitAbr.Caption = .Fields("ser1_ShortTitle").GetLabel
    LabISOStitle.Caption = .Fields("ser1_ISOStitle").GetLabel
    LabMEDLINEStitle.Caption = .Fields("ser4_MedlineStitle").GetLabel
    LabTitAlt.Caption = .Fields("ser1_ParallelTitles").GetLabel
    LabTitulo.Caption = .Fields("ser1_Title").GetLabel
    LabVol.Caption = .Fields("Volume").GetLabel
    
    End With
    
    With ConfigLabels
    Caption = App.Title + " - " + ISSUE_FORM_CAPTION + Sertitle
    LabIndicationMandatoryField.Caption = .MandatoryFieldIndication
    CmdClose.Caption = .ButtonClose
    FormCmdAju.Caption = .mnHelp
    CmdView.Caption = .ButtonOpen
    CmdReplace.Caption = .ButtonReplace
    CmdDelete.Caption = .ButtonDelete
    End With

    Show vbModal
End Sub


Private Function FindIssueToOpen(FoundMfn As Long, Sertitle As String, Vol As String, SVol As String, No As String, SNo As String, iseqno As String) As Boolean
    Dim resp As Boolean
    Dim Mfn As Long
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
    Dim xYear As String
    Dim Year As String
    Dim i As Long
    Dim Mfns() As Long
    Dim q As Long
    Dim mfn1 As Long
    Dim mfn2 As Long
    
    Year = Mid(iseqno, 1, 4)
    
    q = BDIssues.MfnFind(IssueId(Vol, SVol, No, SNo) + Sertitle, Mfns)
    While (i < q) And (MfnIssueId = 0)
        i = i + 1
        xNro = BDIssues.UsePft(Mfns(i), "v32")
        xVol = BDIssues.UsePft(Mfns(i), "v31")
        xSupplNro = BDIssues.UsePft(Mfns(i), "v132")
        xSupplVol = BDIssues.UsePft(Mfns(i), "v131")
        xSertitle = BDIssues.UsePft(Mfns(i), "v130")
        
        xYear = BDIssues.UsePft(Mfns(i), "v65*0.4")
        If (Vol = xVol) And (SVol = xSupplVol) And (No = xNro) And (SNo = xSupplNro) And (Sertitle = xSertitle) And (Year = xYear) Then
            MfnIssueId = Mfns(i)
        End If
    Wend
    
    q = BDIssues.MfnFind(iseqno + "|" + Sertitle, Mfns)
    i = 0
    While (i < q) And (MfnIseqNo = 0)
        i = i + 1
        xNroSeq = BDIssues.UsePft(Mfns(i), "v36")
        xSertitle = BDIssues.UsePft(Mfns(i), "v130")
        If (iseqno = xNroSeq) And (Sertitle = xSertitle) Then
            MfnIseqNo = Mfns(i)
        End If
    Wend
    
    If (MfnIseqNo = 0) Or (MfnIssueId = 0) Then
    
    IseqNoPFT = "if "
    IseqNoPFT = IseqNoPFT + "v130='" + Sertitle + "' and "
    IseqNoPFT = IseqNoPFT + "v36='" + iseqno + "' then mfn fi"
    
    IssueIdPFT = "if "
    IssueIdPFT = IssueIdPFT + "v130='" + Sertitle + "' and "
    IssueIdPFT = IssueIdPFT + "v31='" + Vol + "' and "
    IssueIdPFT = IssueIdPFT + "v131='" + SVol + "' and "
    IssueIdPFT = IssueIdPFT + "v32='" + No + "' and "
    IssueIdPFT = IssueIdPFT + "v65*0.4='" + Year + "' and "
    IssueIdPFT = IssueIdPFT + "v132='" + SNo + "' then mfn fi"
    
    Mfn = 0
    While (Mfn < BDIssues.MfnQuantity) And (MfnIseqNo = 0) And (MfnIssueId = 0)
        Mfn = Mfn + 1
        rIseqNo = BDIssues.UsePft(Mfn, IseqNoPFT)
        rIssueId = BDIssues.UsePft(Mfn, IssueIdPFT)
        If Len(rIseqNo) > 0 Then
            MfnIseqNo = Mfn
        End If
        If Len(rIssueId) > 0 Then
            MfnIssueId = Mfn
        End If
    Wend
    End If
    
    With BDIssues
    If MfnIssueId = MfnIseqNo Then
        FoundMfn = MfnIssueId
        resp = True
    ElseIf (MfnIssueId = 0) Or (MfnIseqNo = 0) Then
        If MfnIseqNo = 0 Then
            'Este issue existe na base, mas seu iseqno e' diferente
            '1. entrou iseqno errado agora
            '2. entrou iseqno errado antes
            
            xNroSeq = .UsePft(MfnIssueId, "v36")
            resp1 = FormSeqNo.CheckSeqNo(ConfigLabels.ISEQNO_CHANGEISEQNO, TxtVolid.text, TxtSupplVol.text, TxtIssueno.text, TxtSupplNo.text, xNroSeq)
            If resp1 Then
                If .FieldContentUpdate(MfnIssueId, 36, TxtIseqno.text) Then
                If .FieldContentUpdate(MfnIssueId, 31, TxtVolid.text) Then
                If .FieldContentUpdate(MfnIssueId, 32, TxtIssueno.text) Then
                If .FieldContentUpdate(MfnIssueId, 131, TxtSupplVol.text) Then
                If .FieldContentUpdate(MfnIssueId, 132, TxtSupplNo.text) Then
                    resp = .IfUpdate(MfnIssueId, MfnIssueId)
                    FoundMfn = MfnIssueId
                End If
                End If
                End If
                End If
                End If
            End If
            'Else
            '    MsgBox ConfigLabels.MsgInvalidSeqNumber
            'End If
            'MsgBox ConfigLabels.MsgInvalidSeqNumber
            'CmdViewIseqNo_Click
        ElseIf MfnIssueId = 0 Then
            'Este issue nao existe na base, mas o iseqno ja existe e e' de outro issue
            '1. entrou iseqno errado agora - seleciona new e corrige o iseqno
            '2. entrou iseqno errado antes - seleciona current para corrigir
            xNro = .UsePft(MfnIseqNo, "v32")
            xVol = .UsePft(MfnIseqNo, "v31")
            xSupplNro = .UsePft(MfnIseqNo, "v132")
            xSupplVol = .UsePft(MfnIseqNo, "v131")
          
            resp1 = FormSeqNo.CheckSeqNo(ConfigLabels.ISEQNO_CHANGEISSUEID, xVol, xSupplVol, xNro, xSupplNro, TxtIseqno.text)
            If resp1 Then
                If .FieldContentUpdate(MfnIseqNo, 36, TxtIseqno.text) Then
                If .FieldContentUpdate(MfnIseqNo, 31, TxtVolid.text) Then
                If .FieldContentUpdate(MfnIseqNo, 32, TxtIssueno.text) Then
                If .FieldContentUpdate(MfnIseqNo, 131, TxtSupplVol.text) Then
                If .FieldContentUpdate(MfnIseqNo, 132, TxtSupplNo.text) Then
                    resp = .IfUpdate(MfnIseqNo, MfnIseqNo)
                    FoundMfn = MfnIseqNo
                End If
                End If
                End If
                End If
                End If
            End If
        End If
        
    ElseIf (MfnIseqNo > 0) And (MfnIssueId > 0) Then
        MsgBox ConfigLabels.MsgInvalidSeqNumber
        CmdViewIseqNo_Click
        'resp1 = FormSeqNo.CheckSeqNo(.UsePft(MfnIseqNo, "v31"), .UsePft(MfnIseqNo, "v131"), .UsePft(MfnIseqNo, "v32"), .UsePft(MfnIseqNo, "v132"), .UsePft(MfnIseqNo, "v36"), .UsePft(MfnIssueId, "v31"), .UsePft(MfnIssueId, "v131"), .UsePft(MfnIssueId, "v32"), .UsePft(MfnIssueId, "v132"), .UsePft(MfnIssueId, "v36"))
    End If
    End With
    
    FindIssueToOpen = resp
End Function


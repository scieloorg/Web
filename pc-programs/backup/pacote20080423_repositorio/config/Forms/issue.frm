VERSION 5.00
Begin VB.Form FrmIssue 
   Caption         =   "Issue"
   ClientHeight    =   3930
   ClientLeft      =   2085
   ClientTop       =   7245
   ClientWidth     =   8055
   Icon            =   "issue.frx":0000
   LinkTopic       =   "Form4"
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   3930
   ScaleMode       =   0  'User
   ScaleWidth      =   8055
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton CmdAju 
      Caption         =   "Help"
      Height          =   375
      Left            =   7080
      TabIndex        =   11
      Top             =   600
      Width           =   855
   End
   Begin VB.CommandButton CmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   7080
      TabIndex        =   10
      Top             =   120
      Width           =   855
   End
   Begin VB.Frame FramPer 
      Height          =   3855
      Left            =   120
      TabIndex        =   12
      Top             =   0
      Width           =   6735
      Begin VB.TextBox TxtParallel 
         Height          =   495
         Left            =   1920
         MultiLine       =   -1  'True
         TabIndex        =   26
         Text            =   "issue.frx":030A
         Top             =   1320
         Width           =   4695
      End
      Begin VB.Frame FramFascId 
         Height          =   855
         Left            =   720
         TabIndex        =   18
         Top             =   2880
         Width           =   5895
         Begin VB.TextBox TxtSupplVol 
            Height          =   285
            Left            =   1080
            TabIndex        =   5
            Top             =   480
            Width           =   975
         End
         Begin VB.TextBox TxtVolid 
            Height          =   285
            Left            =   120
            TabIndex        =   4
            Top             =   480
            Width           =   975
         End
         Begin VB.TextBox TxtIssueno 
            Height          =   285
            Left            =   2040
            TabIndex        =   6
            Top             =   480
            Width           =   975
         End
         Begin VB.TextBox TxtIseqno 
            Height          =   285
            Left            =   4080
            TabIndex        =   8
            Top             =   480
            Width           =   975
         End
         Begin VB.CommandButton CmdView 
            Caption         =   "Open"
            Height          =   375
            Left            =   5160
            TabIndex        =   9
            Top             =   360
            Width           =   615
         End
         Begin VB.TextBox TxtSupplNo 
            Height          =   285
            Left            =   3000
            TabIndex        =   7
            Top             =   480
            Width           =   975
         End
         Begin VB.Label LabSupplVol 
            Caption         =   "Suppl"
            Height          =   255
            Left            =   1080
            TabIndex        =   23
            Top             =   240
            Width           =   855
         End
         Begin VB.Label LabVol 
            Caption         =   "Vol"
            Height          =   255
            Left            =   120
            TabIndex        =   22
            Top             =   240
            Width           =   855
         End
         Begin VB.Label LabNro 
            Caption         =   "No"
            Height          =   255
            Left            =   2040
            TabIndex        =   21
            Top             =   240
            Width           =   855
         End
         Begin VB.Label LabNroSeq 
            Caption         =   "Seq No"
            Height          =   255
            Left            =   4080
            TabIndex        =   20
            Top             =   240
            Width           =   975
         End
         Begin VB.Label LabSupplNro 
            Caption         =   "Suppl"
            Height          =   255
            Left            =   3000
            TabIndex        =   19
            Top             =   240
            Width           =   855
         End
      End
      Begin VB.ComboBox ComboPer 
         Height          =   315
         Left            =   1920
         Sorted          =   -1  'True
         Style           =   2  'Dropdown List
         TabIndex        =   0
         TabStop         =   0   'False
         Top             =   240
         Width           =   4695
      End
      Begin VB.TextBox TxtPubl 
         Height          =   525
         Left            =   1920
         Locked          =   -1  'True
         MultiLine       =   -1  'True
         TabIndex        =   3
         TabStop         =   0   'False
         Top             =   1920
         Width           =   4695
      End
      Begin VB.Label LabMedlineStitle 
         AutoSize        =   -1  'True
         Caption         =   "Short Title"
         Height          =   195
         Left            =   240
         TabIndex        =   25
         Top             =   960
         Width           =   720
      End
      Begin VB.Label TxtMedlineStitle 
         BackColor       =   &H00FFFFFF&
         BorderStyle     =   1  'Fixed Single
         Height          =   255
         Left            =   1920
         TabIndex        =   24
         Top             =   960
         Width           =   4695
      End
      Begin VB.Label TxtStitle 
         BackColor       =   &H00FFFFFF&
         BorderStyle     =   1  'Fixed Single
         Height          =   255
         Left            =   1920
         TabIndex        =   1
         Top             =   600
         Width           =   4695
      End
      Begin VB.Label LabTitulo 
         AutoSize        =   -1  'True
         Caption         =   "Title"
         Height          =   195
         Left            =   240
         TabIndex        =   17
         Top             =   240
         Width           =   300
      End
      Begin VB.Label LabTitAbr 
         AutoSize        =   -1  'True
         Caption         =   "Short Title"
         Height          =   195
         Left            =   240
         TabIndex        =   16
         Top             =   600
         Width           =   720
      End
      Begin VB.Label LabTitAlt 
         AutoSize        =   -1  'True
         Caption         =   "Alternatives Titles"
         Height          =   195
         Left            =   240
         TabIndex        =   15
         Top             =   1320
         Width           =   1245
      End
      Begin VB.Label LabISSN 
         AutoSize        =   -1  'True
         Caption         =   "ISSN"
         Height          =   195
         Left            =   240
         TabIndex        =   14
         Top             =   2520
         Width           =   375
      End
      Begin VB.Label TxtISSN 
         BackColor       =   &H00FFFFFF&
         BorderStyle     =   1  'Fixed Single
         Height          =   255
         Left            =   1920
         TabIndex        =   2
         Top             =   2520
         Width           =   1095
      End
      Begin VB.Label LabPubl 
         AutoSize        =   -1  'True
         Caption         =   "Publisher"
         Height          =   195
         Left            =   240
         TabIndex        =   13
         Top             =   1920
         Width           =   645
      End
   End
End
Attribute VB_Name = "FrmIssue"
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

Public Serial As ColField
'Public Issue As ColField
'Public LegToCLang As ColIssLang

Public SiglaPeriodico As String
Public IssueKeyCurr As String



Private Sub SerialSelect()
    MyMfnTitle = CheckExistingSerial(ComboPer.Text)
    
    TxtPubl.Text = GetTxtContent(MyMfnTitle, 480)
    Cidade = GetTxtContent(MyMfnTitle, 490)
    SiglaPeriodico = GetTxtContent(MyMfnTitle, 930)
    TxtStitle.Caption = GetTxtContent(MyMfnTitle, 150)
    TxtISSN.Caption = GetTxtContent(MyMfnTitle, 400)
    TxtParallel.Text = GetTxtContent(MyMfnTitle, 230)
End Sub

Private Sub CmdClose_Click()
    Unload Me
End Sub

Private Sub CmdView_Click()
    Dim MfnIssue As Long
    
    If MousePointer = vbArrowQuestion Then
        MousePointer = vbArrow
    Else
        If CheckDataOne Then
            If CheckIseqNo(MfnIssue) Then
                LockNewChoice = True
                FrmIssue2.LoadIssue (MfnIssue)
            End If
        End If
    End If
End Sub

Private Function CheckIseqNo(MfnIssue As Long) As Boolean
    Dim Ret As Boolean
    Dim MfnNroSeq As Long
    Dim MfnPer As Long
    Dim xVol As String
    Dim xNro As String
    Dim xSupplVol As String
    Dim xSupplNro As String
    Dim xNroSeq As String
    Dim resp1 As Boolean
    Dim resp2 As Boolean
    Dim Mfn As Long
    Dim i As Long
    
    With BDIssues
    MfnNroSeq = .MfnFindOne(TxtISSN.Caption + "|" + TxtIseqno.Text)
    MfnPer = .MfnFindOne(IssueKeyCurr)
        
    If MfnNroSeq = MfnPer Then
        Ret = True
        MfnIssue = MfnNroSeq
    ElseIf (MfnNroSeq = 0) Or (MfnPer = 0) Then
        If MfnNroSeq = 0 Then
            'O fascículo já existe, mas com nro seq diferente
            xNroSeq = .FieldContentOccGet(MfnPer, DBIssueTags("iseqno").Value, 1)
            resp1 = FormSeqNo.CheckSeqNo(TxtVolid.Text, TxtSupplVol.Text, TxtIssueno.Text, TxtSupplNo.Text, xNroSeq)
            Mfn = MfnPer
        ElseIf MfnPer = 0 Then
            'Nro seq já existe, mas para outro fascículo
            xNro = .FieldContentOccGet(MfnNroSeq, DBIssueTags("issueno").Value, 1)
            xVol = .FieldContentOccGet(MfnNroSeq, DBIssueTags("volid").Value, 1)
            xSupplNro = .SubFieldContentOccGet(MfnNroSeq, DBIssueTags("supplno").Value, 1, DBIssueTags("supplno").Subf)
            xSupplVol = .SubFieldContentOccGet(MfnNroSeq, DBIssueTags("supplvol").Value, 1, DBIssueTags("supplvol").Subf)
            resp1 = FormSeqNo.CheckSeqNo(xVol, xSupplVol, xNro, xSupplNro, TxtIseqno.Text)
            Mfn = MfnNroSeq
        End If
        
        If resp1 Then
            If .FieldContentUpdate(Mfn, DBIssueTags("iseqno").Value, TxtIseqno.Text) Then
                If .FieldContentUpdate(Mfn, DBIssueTags("volid").Value, TxtVolid.Text) Then
                    If .FieldContentUpdate(Mfn, DBIssueTags("issueno").Value, TxtIssueno.Text) Then
                        If .FieldContentUpdate(Mfn, DBIssueTags("supplvol").Value, TxtSupplVol.Text) Then
                            If .FieldContentUpdate(Mfn, DBIssueTags("supplno").Value, TxtSupplNo.Text) Then
                                For i = 1 To .FieldOccCount(Mfn, DBIssIdiomTags("seccode").Value)
                                    Call .FieldContentDel(Mfn, DBIssIdiomTags("seccode").Value, i)
                                Next
                                Ret = .IfUpdate(Mfn, Mfn)
                            End If
                        End If
                    End If
                End If
            End If
        Else
            MsgBox ("Invalid issue or sequential number.")
        End If
    ElseIf (MfnNroSeq > 0) Or (MfnPer > 0) Then
        'As duas possibilidades anteriores
        'Nro seq já existe, mas para outro fascículo
        xNro = .FieldContentOccGet(MfnNroSeq, DBIssueTags("issueno").Value, 1)
        xVol = .FieldContentOccGet(MfnNroSeq, DBIssueTags("volid").Value, 1)
        xSupplNro = .SubFieldContentOccGet(MfnNroSeq, DBIssueTags("supplno").Value, 1, DBIssueTags("supplno").Subf)
        xSupplVol = .SubFieldContentOccGet(MfnNroSeq, DBIssueTags("supplvol").Value, 1, DBIssueTags("supplvol").Subf)
        resp1 = (MsgBox(MsgIssueId(xVol, xSupplVol, xNro, xSupplNro, TxtIseqno.Text) + "Is that correct?", vbYesNo) = vbYes)
            
        'O fascículo já existe, mas com nro seq diferente
        xNroSeq = .FieldContentOccGet(MfnPer, DBIssueTags("iseqno").Value, 1)
        resp2 = (MsgBox(MsgIssueId(TxtVolid.Text, TxtSupplVol.Text, TxtIssueno.Text, TxtSupplNo.Text, xNroSeq) + "Is that correct?", vbYesNo) = vbYes)
            
        Ret = False
        If resp1 = resp2 Then
            If resp1 Then
                TxtIseqno.Text = xNroSeq
                Ret = True
            Else
                If MsgBox("Exchange the sequential numbers?", vbYesNo) = vbYes Then
                    If .FieldContentUpdate(MfnPer, DBIssueTags("iseqno").Value, TxtIseqno.Text) Then
                        If .FieldContentUpdate(MfnNroSeq, DBIssueTags("iseqno").Value, xNroSeq) Then
                            Ret = .IfUpdate(MfnPer, MfnPer) And .IfUpdate(MfnNroSeq, MfnNroSeq)
                        End If
                    End If
                End If
            End If
        Else
            If resp1 Then
                MsgBox ("Invalid Sequential number: " + TxtIseqno.Text)
            Else
                MsgBox ("Correct the information:" + SepLinha + MsgIssueId(xVol, xSupplVol, xNro, xSupplNro, TxtIseqno.Text))
            End If
        End If
    End If
    End With
    CheckIseqNo = Ret
End Function

Private Sub CmdAju_Click()
    Call frmFindBrowser.CallBrowser(FormMenuPrin.DirStruct.Nodes("Help of Issue").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Help of Issue").Text)
End Sub

Private Sub ComboPer_GotFocus()
'    MsgBox "You do not close the current issue."
End Sub

Private Sub ComboStatus_Change()
    If MousePointer = vbArrowQuestion Then
        MousePointer = vbArrow
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    If CmdClose.Enabled = True Then
        UpdateIssueTable
    Else
        Cancel = 1
        MsgBox "You have not finished."
    End If
End Sub

Private Function UpdateIssueTable() As Boolean
    Dim Mfn As Long
    Dim result As String
    Dim fn As Long
    
    fn = 2
    Open FormMenuPrin.DirStruct.Nodes("Markup Issue Table").FullPath For Output As fn
    Close fn
    For Mfn = 1 To BDIssues.MfnQuantity
        result = BDIssues.UsePft(Mfn, "@" + FormMenuPrin.DirStruct.Nodes("Markup Issue Table Format").FullPath)
        
        Open FormMenuPrin.DirStruct.Nodes("Markup Issue Table").FullPath For Append As fn
        Print #fn, result
        Close fn
    Next
End Function

Private Sub Form_Load()
    OldHeight = Height
    OldWidth = Width
    NormalHeight = Height
    NormalWidth = Width
End Sub

Private Sub ComboPer_Change()
    SerialSelect
End Sub

Private Sub ComboPer_Click()
    SerialSelect
    If MousePointer = vbArrowQuestion Then
        MousePointer = vbArrow
    End If
End Sub

Private Sub CmdNext_Click()
    If MousePointer = vbArrowQuestion Then
        MousePointer = vbArrow
    Else
        FrmIssue2.Show vbModal
    End If
End Sub


Private Sub TxtBoxClear0()
    TxtVolid.Text = ""
    TxtIssueno.Text = ""
    TxtSupplVol.Text = ""
    TxtSupplNo.Text = ""
    TxtIseqno.Text = ""
End Sub

Private Function CheckDataOne() As Boolean
    Dim VolNum As String
    Dim Vol As String
    Dim Nro As String
    Dim Path As String
    Dim retorno As Boolean

    If Len(Trim(TxtVolid.Text)) > 0 Then
        retorno = True
    ElseIf Len(Trim(TxtIssueno.Text)) > 0 Then
        retorno = True
    ElseIf Len(Trim(TxtSupplNo.Text)) > 0 Then
        retorno = True
    ElseIf Len(Trim(TxtSupplVol.Text)) > 0 Then
        retorno = True
    End If
    
    If Not retorno Then MsgBox "Identification of this issue is missing."
    
    If Len(Trim(TxtIseqno.Text)) = 0 Then
        MsgBox ("Sequential number is mandatory.")
        retorno = False
    End If
    
    If retorno Then
        Vol = TxtVolid.Text
        Nro = TxtIssueno.Text
        
        'Obter os nomes dos Artigos do diretório especificado
        VolNum = IssueId(Vol, TxtSupplVol.Text, Nro, TxtSupplNo.Text)
        IssueKeyCurr = TxtISSN.Caption + IssueId(Vol, TxtSupplVol.Text, Nro, TxtSupplNo.Text)
        
        'PathBase = DirPeriodicos + SiglaPeriodico + pathsep + VolNum
        'ArqBase = VolNum
        'If Not DirExist(PathBase, "Database of Documents.") Then
         '   MsgBox "Be sure there is this issue."
            'retorno = False
        'End If
    End If
    CheckDataOne = retorno
End Function

Private Sub Form_Resize()
    Resize
End Sub

Private Sub Resize()
    Dim X As Double
    Dim Y As Double
    
    If WindowState <> vbMinimized Then
        If Height < NormalHeight Then
            'OldHeight = Height
            Height = NormalHeight
        ElseIf Width < NormalWidth Then
            'OldWidth = Width
            Width = NormalWidth
        Else
            X = Width / OldWidth
            Y = Height / OldHeight
            Call Posicionar(X, Y)
            OldHeight = Height
            OldWidth = Width
        End If
    End If
End Sub

Private Sub Redimensionar(obj As Object, Left As Double, Top As Double, Width As Double, Height As Double)
    obj.Left = Left * obj.Left
    obj.Top = Top * obj.Top
    If Height <> 1 Then obj.Height = Height * obj.Height
    If Width <> 1 Then obj.Width = Width * obj.Width
End Sub

Private Sub Posicionar(X As Double, Y As Double)
    Call Redimensionar(FramPer, X, Y, X, Y)
    Call Redimensionar(LabTitulo, X, Y, 1, 1)
    Call Redimensionar(ComboPer, X, Y, X, 1)
    Call Redimensionar(LabTitAbr, X, Y, 1, 1)
    Call Redimensionar(TxtStitle, X, Y, X, 1)
    Call Redimensionar(LabTitAlt, X, Y, 1, 1)
    Call Redimensionar(TxtParallel, X, Y, X, 1)
    Call Redimensionar(LabISSN, X, Y, 1, 1)
    Call Redimensionar(TxtISSN, X, Y, X, 1)
    Call Redimensionar(LabPubl, X, Y, 1, 1)
    Call Redimensionar(TxtPubl, X, Y, X, 1)
    
    Call Redimensionar(FramFascId, X, Y, X, Y)
    
    Call Redimensionar(LabVol, X, Y, 1, 1)
    Call Redimensionar(TxtVolid, X, Y, X, 1)
    Call Redimensionar(LabNro, X, Y, 1, 1)
    Call Redimensionar(TxtIssueno, X, Y, X, 1)
    Call Redimensionar(LabSupplVol, X, Y, 1, 1)
    Call Redimensionar(TxtSupplVol, X, Y, X, 1)
    Call Redimensionar(LabSupplNro, X, Y, 1, 1)
    Call Redimensionar(TxtSupplNo, X, Y, X, 1)
    Call Redimensionar(LabNroSeq, X, Y, 1, 1)
    Call Redimensionar(TxtIseqno, X, Y, X, 1)
    
    'Call Redimensionar(CmdGarbageCollection, x, Y, x, Y)
    Call Redimensionar(CmdView, X, Y, X, Y)
    Call Redimensionar(CmdClose, X, Y, X, Y)
    Call Redimensionar(CmdAju, X, Y, X, Y)
    
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

Private Sub TxtDateIso_Change()
    If MousePointer = vbArrowQuestion Then
        MousePointer = vbArrow
    End If
End Sub

Private Sub TxtIssPublisher_Change()
    If MousePointer = vbArrowQuestion Then
        MousePointer = vbArrow
    End If

End Sub

Private Sub Txtcover_Change()
    If MousePointer = vbArrowQuestion Then
        MousePointer = vbArrow
    End If
End Sub

Private Sub TxtISSN_Click()
    If MousePointer = vbArrowQuestion Then
        MousePointer = vbArrow
    End If
End Sub

Private Sub TxtIssuept_Change()
    If MousePointer = vbArrowQuestion Then
        MousePointer = vbArrow
    End If
End Sub

Private Sub TxtPubl_Change()
    If MousePointer = vbArrowQuestion Then
        MousePointer = vbArrow
    End If
End Sub

Private Sub TxtSTitle_Click()
    If MousePointer = vbArrowQuestion Then
        MousePointer = vbArrow
    End If
End Sub

Private Sub TxtIssTitle_Change()
    If MousePointer = vbArrowQuestion Then
        MousePointer = vbArrow
    End If
End Sub

Property Let LockNewChoice(flag As Boolean)
    ComboPer.Locked = flag
    TxtVolid.Locked = flag
    TxtIssueno.Locked = flag
    TxtSupplVol.Locked = flag
    TxtSupplNo.Locked = flag
    TxtIseqno.Locked = flag
    CmdClose.Enabled = Not flag
End Property

Sub OpenIssue()
    With ConfigLabels
    LabISSN.Caption = .ser1_issn
    LabNro.Caption = .Issueno
    LabNroSeq.Caption = .SequentialNumber
    LabPubl.Caption = .ser3_Publisher
    LabSupplNro.Caption = .IssueSuppl
    LabSupplVol.Caption = .VolSuppl
    LabTitAbr.Caption = .ser1_ShortTitle
    LabMedlineStitle.Caption = .ser4_MedlineStitle
    LabTitAlt.Caption = .ser1_ParallelTitles
    LabTitulo.Caption = .ser1_Title
    LabVol.Caption = .Volume
    CmdClose.Caption = .ButtonClose
    CmdAju.Caption = .mnHelp
    CmdView.Caption = .ButtonOpen
    End With
    
    Call GetExistingSerials2(ComboPer)
    ComboPer.ListIndex = 0
    
    Show vbModal
End Sub

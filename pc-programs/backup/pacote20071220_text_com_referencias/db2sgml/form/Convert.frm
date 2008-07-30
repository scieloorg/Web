VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.1#0"; "COMCTL32.OCX"
Begin VB.Form FrmConvert 
   Caption         =   "Markup"
   ClientHeight    =   4755
   ClientLeft      =   1275
   ClientTop       =   1020
   ClientWidth     =   8250
   LinkTopic       =   "Form4"
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   4755
   ScaleWidth      =   8250
   StartUpPosition =   2  'CenterScreen
   Begin ComctlLib.ProgressBar ProgressBar1 
      Height          =   255
      Left            =   4920
      TabIndex        =   29
      Top             =   4440
      Visible         =   0   'False
      Width           =   3255
      _ExtentX        =   5741
      _ExtentY        =   450
      _Version        =   327680
      Appearance      =   1
      MouseIcon       =   "Convert.frx":0000
   End
   Begin VB.Frame FramPer 
      Caption         =   "Serial"
      Height          =   3855
      Left            =   120
      TabIndex        =   10
      Top             =   120
      Width           =   3255
      Begin VB.ComboBox ComboPer 
         Height          =   315
         Left            =   120
         Sorted          =   -1  'True
         Style           =   2  'Dropdown List
         TabIndex        =   19
         Top             =   240
         Width           =   3015
      End
      Begin VB.TextBox TxtSupplVol 
         Height          =   285
         Left            =   1320
         TabIndex        =   2
         Top             =   1920
         Width           =   1575
      End
      Begin VB.TextBox TxtVol 
         Height          =   285
         Left            =   1320
         TabIndex        =   1
         Top             =   1560
         Width           =   1575
      End
      Begin VB.TextBox TxtNro 
         Height          =   285
         Left            =   1320
         TabIndex        =   3
         Top             =   2400
         Width           =   1575
      End
      Begin VB.CommandButton CmdOK 
         Caption         =   "OK"
         Height          =   375
         Left            =   240
         TabIndex        =   5
         Top             =   3360
         Width           =   855
      End
      Begin VB.CommandButton PerCmdCan 
         Caption         =   "Close"
         Height          =   375
         Left            =   1200
         TabIndex        =   6
         Top             =   3360
         Width           =   855
      End
      Begin VB.CommandButton PerCmdAju 
         Caption         =   "Help"
         Height          =   375
         Left            =   2160
         TabIndex        =   7
         Top             =   3360
         Width           =   855
      End
      Begin VB.TextBox txtSupplNro 
         Height          =   285
         Left            =   1320
         TabIndex        =   4
         Top             =   2760
         Width           =   1575
      End
      Begin VB.Label LabISSN 
         AutoSize        =   -1  'True
         Caption         =   "ISSN"
         Height          =   195
         Left            =   840
         TabIndex        =   31
         Top             =   720
         Width           =   375
      End
      Begin VB.Label TxtISSN 
         BackColor       =   &H00C0C0C0&
         BorderStyle     =   1  'Fixed Single
         Height          =   255
         Left            =   1320
         TabIndex        =   30
         Top             =   720
         Width           =   1575
      End
      Begin VB.Label LabSupplNo 
         AutoSize        =   -1  'True
         Caption         =   "Supplement"
         Height          =   195
         Left            =   360
         TabIndex        =   17
         Top             =   2760
         Width           =   840
      End
      Begin VB.Label LabSupplVol 
         Caption         =   "Supplement"
         Height          =   255
         Left            =   360
         TabIndex        =   16
         Top             =   1920
         Width           =   855
      End
      Begin VB.Label TxtSglPer 
         BackColor       =   &H00C0C0C0&
         BorderStyle     =   1  'Fixed Single
         Height          =   255
         Left            =   1320
         TabIndex        =   0
         Top             =   1080
         Width           =   1575
      End
      Begin VB.Label LabSglPer 
         AutoSize        =   -1  'True
         Caption         =   "Siglum"
         Height          =   195
         Left            =   720
         TabIndex        =   13
         Top             =   1080
         Width           =   465
      End
      Begin VB.Label LabVol 
         AutoSize        =   -1  'True
         Caption         =   "Volume"
         Height          =   195
         Left            =   600
         TabIndex        =   12
         Top             =   1560
         Width           =   525
      End
      Begin VB.Label LabNro 
         AutoSize        =   -1  'True
         Caption         =   "Number"
         Height          =   195
         Left            =   600
         TabIndex        =   11
         Top             =   2400
         Width           =   555
      End
   End
   Begin VB.Frame FramArtigos 
      Caption         =   "Documents"
      Enabled         =   0   'False
      Height          =   3855
      Left            =   3480
      TabIndex        =   9
      Top             =   120
      Width           =   2295
      Begin VB.FileListBox ListArtigos 
         Height          =   2625
         Left            =   120
         MultiSelect     =   2  'Extended
         TabIndex        =   14
         Top             =   480
         Width           =   2055
      End
      Begin VB.CommandButton CmdLoad 
         Caption         =   "Load"
         Height          =   375
         Left            =   720
         TabIndex        =   8
         Top             =   3360
         Width           =   855
      End
      Begin VB.Label LabDocCounter 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Label4"
         Height          =   195
         Left            =   1695
         TabIndex        =   26
         Top             =   240
         Width           =   480
      End
   End
   Begin VB.Frame FramDB 
      Caption         =   "Results"
      Height          =   3855
      Left            =   5880
      TabIndex        =   20
      Top             =   120
      Width           =   2295
      Begin VB.ListBox ListOutDB 
         Height          =   1035
         Left            =   120
         MultiSelect     =   2  'Extended
         Sorted          =   -1  'True
         TabIndex        =   23
         Top             =   2040
         Width           =   2055
      End
      Begin VB.CommandButton CmdViewLog 
         Caption         =   "View"
         Height          =   375
         Left            =   720
         TabIndex        =   22
         Top             =   3360
         Width           =   855
      End
      Begin VB.ListBox ListInDB 
         Height          =   1035
         Left            =   120
         MultiSelect     =   2  'Extended
         Sorted          =   -1  'True
         TabIndex        =   21
         Top             =   480
         Width           =   2055
      End
      Begin VB.Label LabFailCount 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Label4"
         Height          =   195
         Left            =   1695
         TabIndex        =   28
         Top             =   1800
         Width           =   480
      End
      Begin VB.Label LabSuccessCount 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Label4"
         Height          =   195
         Left            =   1695
         TabIndex        =   27
         Top             =   240
         Width           =   480
      End
      Begin VB.Label Label3 
         Caption         =   "Not Loaded"
         Height          =   255
         Left            =   120
         TabIndex        =   25
         Top             =   1800
         Width           =   975
      End
      Begin VB.Label Label2 
         Caption         =   "Loaded"
         Height          =   255
         Left            =   120
         TabIndex        =   24
         Top             =   240
         Width           =   735
      End
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000002&
      Height          =   240
      Left            =   120
      TabIndex        =   18
      Top             =   4080
      Width           =   2055
   End
   Begin VB.Label LabMsg 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0C0C0&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000002&
      Height          =   240
      Left            =   3240
      TabIndex        =   15
      Top             =   4080
      Width           =   4965
   End
End
Attribute VB_Name = "FrmConvert"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private NormalHeight As Long
Private NormalWidth As Long

Private OldHeight As Long
Private OldWidth As Long

Private PathCurr As String

Sub Executa()
    Dim i As Long
    Dim FileIndex() As Long
    Dim SelCount As Long
    Dim BodyFile() As String
    Dim ExistBodyFile As Boolean
    Dim T0 As Date
    Dim Success As Long
    Dim FileCounter As Long
    Dim Result As String
    
    MousePointer = vbHourglass
    
    SelCount = GetSelectedFiles(FileIndex)
    If SelCount > 0 Then
        FileCounter = CheckDocCount()
        If FileCounter = ListArtigos.ListCount Then
            T0 = Time
            
            ReDim BodyFile(SelCount)
            i = 0
            ExistBodyFile = True
            While (i < SelCount) And ExistBodyFile
                i = i + 1
                BodyFile(i) = BodyFileName(ListArtigos.List(FileIndex(i)))
                If Len(BodyFile(i)) = 0 Then
                    Msg.GiveRunInformation ("File " + ListArtigos.List(FileIndex(i)) + " is missing in Body.")
                    ExistBodyFile = False
                End If
            Wend
            
            If ExistBodyFile Then
                For i = 1 To SelCount
                    Label1.Caption = CStr(i) + "/" + CStr(SelCount) + " in execution: " + ListArtigos.List(FileIndex(i))
                    
                    'If RunConversion(ListArtigos.List(FileIndex(i)), BodyFile(i)) Then
                    If MakeConversion(ARTICLE_DOCTYPE, ListArtigos.List(FileIndex(i)), BodyFile(i)) Then
                        Success = Success + 1
                        Result = Result + ListArtigos.List(FileIndex(i)) + vbTab + "[Success]" + vbCrLf
                    Else
                        Result = Result + ListArtigos.List(FileIndex(i)) + vbTab + "[Failure]" + vbCrLf
                    End If
            
                    ListArtigos.Selected(FileIndex(i)) = False
                    Label1.Caption = ""
                    ViewSuccessAndFailure
                Next
            
                CleanDocDB
            
                Call Msg.GiveRunInformation("Total Time in seconds: " + CStr(DateDiff("s", T0, Time)))
            
                Result = vbCrLf + Result + vbCrLf + "Sucess=" + CStr(Success) + "/" + CStr(SelCount)
                FrmResult.Text1.Text = Result
                FrmResult.Show vbModal
            End If
        Else
            Call Msg.GiveRunInformation("Invalid Number of Documents. In list: " + CStr(ListArtigos.ListCount) + ", in Config Record: " + CStr(FileCounter), True)
        End If
    Else
        Call Msg.GiveRunInformation("Configuration record is missing.", True)
    End If
    MousePointer = vbArrow
End Sub


Private Sub Habilita(Flag As Boolean)
    If Not Flag Then
        LabDocCounter.Caption = ""
        LabSuccessCount.Caption = ""
        LabFailCount.Caption = ""
    End If
    
    FramArtigos.Enabled = Flag
    ListArtigos.Enabled = Flag
    CmdLoad.Enabled = Flag
    CmdViewLog.Enabled = Flag
    FramDB.Enabled = Flag
    ListInDB.Enabled = Flag
    ListOutDB.Enabled = Flag
    Label2.Enabled = Flag
    Label3.Enabled = Flag
End Sub

Private Sub MostrarPeriodicos()
    Dim mfn As Long
    Dim sertitle As String
    
    For mfn = 1 To TITLE_DB.MfnQuantity
        sertitle = TITLE_DB.UsePft(mfn, "v100")
        If Len(sertitle) > 0 Then ComboPer.AddItem (sertitle)
    Next
    If ComboPer.ListCount > 0 Then
        ComboPer.ListIndex = 0
    Else
        MsgBox "There's no serial to convert. Insert serials using Config Program."
        CmdOK.Enabled = False
    End If
End Sub

Private Function GetSelectedFiles(FileIndex() As Long) As Long
    Dim i As Long
    Dim j As Long
    
    Erase FileIndex
    For i = 0 To ListArtigos.ListCount - 1
        If ListArtigos.Selected(i) Then
            j = j + 1
            ReDim Preserve FileIndex(j)
            FileIndex(j) = i
        End If
    Next
    GetSelectedFiles = j
End Function

Private Function GetSelectedItem(List As ListBox, ItemIndex() As Long) As Long
    Dim i As Long
    Dim j As Long
    
    Erase ItemIndex
    For i = 0 To List.ListCount - 1
        If List.Selected(i) Then
            j = j + 1
            ReDim Preserve ItemIndex(j)
            ItemIndex(j) = i
        End If
    Next
    GetSelectedItem = j
End Function

Sub SelecionaPeriodico()
    Dim Sigla() As String
    Dim mfn As Long
    
    LimpaCampos
    mfn = TITLE_DB.MfnFindOne(ComboPer.Text)
    If mfn > 0 Then
        TxtSglPer.Caption = TITLE_DB.UsePft(mfn, "v" + CStr(ISISTAGS("siglum").value))
        TxtISSN.Caption = TITLE_DB.UsePft(mfn, "v400")
    End If
End Sub

Private Sub CmdViewLog_Click()
    Dim i As Long
    Dim FileIndex() As Long
    Dim SelCount As Long
    Dim content As String
    Dim DocInDB As String
    
    SelCount = GetSelectedItem(ListInDB, FileIndex)
    
    For i = 1 To SelCount
        DocInDB = Mid(ListInDB.List(FileIndex(i)), 5)
        content = Msg.ViewLogDatabase(DocInDB)
        If Len(content) > 0 Then
            FormViewLog.TxtViewLog.Text = content
            FormViewLog.Show vbModal
        Else
            MsgBox DocInDB + " is not loaded."
        End If
        ListInDB.Selected(FileIndex(i)) = False
    Next

    SelCount = GetSelectedItem(ListOutDB, FileIndex)
    
    For i = 1 To SelCount
        content = Msg.ViewLogDatabase(ListOutDB.List(FileIndex(i)))
        If Len(content) > 0 Then
            FormViewLog.TxtViewLog.Text = content
            FormViewLog.Show vbModal
        Else
            MsgBox ListOutDB.List(FileIndex(i)) + " is not loaded."
        End If
        ListOutDB.Selected(FileIndex(i)) = False
    Next

End Sub

Private Sub ComboPer_Click()
    SelecionaPeriodico
End Sub

Private Sub ComboPer_Change()
    SelecionaPeriodico
End Sub

Private Sub cmdOK_Click()
    If SetCurrentIssuePath(TxtISSN.Caption, TxtSglPer.Caption, TxtVol.Text, TxtSupplVol.Text, TxtNro.Text, txtSupplNro.Text, PathCurr) Then
        ListArtigos.Path = PathCurr + FormMenu.DirStruct.Nodes("Markup Directory").Text
        LabDocCounter.Caption = CStr(ListArtigos.ListCount) + " File(s)"
        ViewSuccessAndFailure
        Habilita (True)
    End If
End Sub

Private Sub ViewSuccessAndFailure()
    Dim Success() As String
    Dim Failure() As String
    Dim ParserFail() As Boolean
    Dim QSuccess As Long
    Dim QFailure As Long
    Dim q As Long
    Dim i As Long
    Dim StatusParser As String
    Dim msgStatusParser As String
    
    q = Msg.GetDocLoadStatus(Success, QSuccess, Failure, QFailure, ParserFail)
    ListInDB.Clear
    For i = 1 To QSuccess
        If ParserFail(i) Then
            StatusParser = "[X] "
            msgStatusParser = "Markup errors in [X] Loaded Document(s)."
        Else
            StatusParser = "[ ] "
        End If
        ListInDB.AddItem (StatusParser + Success(i))
    Next
    LabSuccessCount.Caption = CStr(QSuccess) + " File(s)"
    ListOutDB.Clear
    For i = 1 To QFailure
        ListOutDB.AddItem (Failure(i))
    Next
    LabFailCount.Caption = CStr(QFailure) + " File(s)"
    If Len(msgStatusParser) > 0 Then
        Call Msg.GiveRunInformation(msgStatusParser, , True)
        
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
            Set TITLE_DB = Nothing
            Set ISIDB = Nothing
            Set ISSNDB = Nothing
            Set NoSertitleDB = Nothing
End Sub

Private Sub Label5_Click()

End Sub

Private Sub PerCmdAju_Click()
    Call frmFindBrowser.CallBrowser(FormMenu.DirStruct.Nodes("Help of Markup").Parent.FullPath, FormMenu.DirStruct.Nodes("Help of Markup").Text)
End Sub

Private Sub PerCmdCan_Click()
    Sair
End Sub

Private Sub cmdLoad_Click()
    Executa
End Sub

Private Sub IssueChanged()
    Habilita (False)
    ListInDB.Clear
    ListOutDB.Clear
End Sub

Private Sub txtSglPer_Change()
    IssueChanged
End Sub

Private Sub TxtVol_Change()
    IssueChanged
End Sub

Private Sub TxtNro_Change()
    IssueChanged
End Sub

Private Sub TxtsupplVol_Change()
    IssueChanged
End Sub

Private Sub TxtsupplNro_Change()
    IssueChanged
End Sub
Private Sub LimpaCampos()
    TxtNro.Text = ""
    TxtSglPer.Caption = ""
    TxtVol.Text = ""
    TxtSupplVol.Text = ""
    txtSupplNro.Text = ""
End Sub

Private Sub Form_Load()
    Habilita (False)
    ListArtigos.pattern = "*.htm;*.html"
    Label1.Caption = ""
    
    MostrarPeriodicos
    
    OldHeight = Height
    OldWidth = Width
    NormalHeight = Height
    NormalWidth = Width
End Sub

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

Private Sub Posicionar(x As Double, Y As Double)
    Dim i As Long
    Dim atual As Long
    
    Call Redimensionar(CmdOK, x, Y, 1, 1)
    Call Redimensionar(PerCmdCan, x, Y, 1, 1)
    Call Redimensionar(PerCmdAju, x, Y, 1, 1)
    Call Redimensionar(CmdLoad, x, Y, 1, 1)
    
    
        Call Redimensionar(LabMsg, x, Y, 1, 1)
    
        Call Redimensionar(FramPer, x, Y, x, Y)
        Call Redimensionar(FramDB, x, Y, x, Y)
        
        Call Redimensionar(LabSglPer, x, Y, 1, 1)
        Call Redimensionar(LabVol, x, Y, 1, 1)
        Call Redimensionar(LabNro, x, Y, 1, 1)
        Call Redimensionar(LabSupplVol, x, Y, 1, 1)
        Call Redimensionar(LabSupplNo, x, Y, 1, 1)
        Call Redimensionar(ComboPer, x, Y, x, 1)
        Call Redimensionar(TxtSglPer, x, Y, x, 1)
        Call Redimensionar(TxtVol, x, Y, x, 1)
        Call Redimensionar(TxtNro, x, Y, x, 1)
        Call Redimensionar(TxtSupplVol, x, Y, 1, 1)
        Call Redimensionar(txtSupplNro, x, Y, 1, 1)
        
        Call Redimensionar(FramArtigos, x, Y, x, Y)
        Call Redimensionar(ListArtigos, x, Y, x, Y)
        Call Redimensionar(ListInDB, x, Y, x, Y)
        Call Redimensionar(ListOutDB, x, Y, x, Y)
    
    Call Redimensionar(Label2, x, Y, 1, 1)
    Call Redimensionar(Label3, x, Y, 1, 1)
    
    Call Redimensionar(LabMsg, x, Y, 1, 1)
End Sub

Private Sub Redimensionar(obj As Object, Left As Double, Top As Double, Width As Double, Height As Double)
    obj.Left = Left * obj.Left
    obj.Top = Top * obj.Top
    If Height <> 1 Then obj.Height = CLng(Height * obj.Height)
    If Width <> 1 Then obj.Width = Width * obj.Width
End Sub

Private Sub Sair()
    Unload Me
End Sub


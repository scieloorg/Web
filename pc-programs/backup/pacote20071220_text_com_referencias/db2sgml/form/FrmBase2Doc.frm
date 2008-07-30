VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "Comctl32.ocx"
Begin VB.Form FrmBase2Doc 
   Caption         =   "Conversion of Database to Document"
   ClientHeight    =   3780
   ClientLeft      =   3435
   ClientTop       =   3255
   ClientWidth     =   5670
   Icon            =   "FrmBase2Doc.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   3780
   ScaleWidth      =   5670
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame FrameDTD 
      Caption         =   "DTD"
      Height          =   735
      Left            =   120
      TabIndex        =   18
      Top             =   120
      Width           =   5415
      Begin VB.ComboBox ComboDTD 
         Height          =   315
         Left            =   240
         Style           =   2  'Dropdown List
         TabIndex        =   0
         Top             =   240
         Width           =   5055
      End
   End
   Begin VB.CommandButton CmdView 
      Caption         =   "View"
      Height          =   375
      Left            =   2280
      TabIndex        =   9
      Top             =   3360
      Width           =   975
   End
   Begin VB.CommandButton CmdConvert 
      Caption         =   "Convert"
      Height          =   375
      Left            =   120
      TabIndex        =   7
      Top             =   3360
      Width           =   975
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "Close"
      Height          =   375
      Left            =   4560
      TabIndex        =   10
      Top             =   3360
      Width           =   975
   End
   Begin VB.Frame FramPer 
      Caption         =   "Serial"
      Height          =   2175
      Left            =   120
      TabIndex        =   11
      Top             =   960
      Width           =   5415
      Begin VB.TextBox txtSupplNro 
         Height          =   285
         Left            =   3960
         TabIndex        =   6
         Top             =   1680
         Width           =   1215
      End
      Begin VB.TextBox TxtNro 
         Height          =   285
         Left            =   2760
         TabIndex        =   5
         Top             =   1680
         Width           =   1215
      End
      Begin VB.TextBox TxtVol 
         Height          =   285
         Left            =   360
         TabIndex        =   3
         Top             =   1680
         Width           =   1215
      End
      Begin VB.TextBox TxtSupplVol 
         Height          =   285
         Left            =   1560
         TabIndex        =   4
         Top             =   1680
         Width           =   1215
      End
      Begin VB.ComboBox ComboPer 
         Height          =   315
         Left            =   360
         Sorted          =   -1  'True
         Style           =   2  'Dropdown List
         TabIndex        =   1
         Top             =   240
         Width           =   4815
      End
      Begin VB.Label LabSglPer 
         AutoSize        =   -1  'True
         Caption         =   "Siglum"
         Height          =   195
         Left            =   360
         TabIndex        =   16
         Top             =   720
         Width           =   465
      End
      Begin VB.Label TxtSiglum 
         BackColor       =   &H00C0C0C0&
         BorderStyle     =   1  'Fixed Single
         Height          =   255
         Left            =   360
         TabIndex        =   2
         Top             =   960
         Width           =   1575
      End
      Begin VB.Label LabNro 
         AutoSize        =   -1  'True
         Caption         =   "Number"
         Height          =   195
         Left            =   2760
         TabIndex        =   15
         Top             =   1440
         Width           =   555
      End
      Begin VB.Label LabVol 
         AutoSize        =   -1  'True
         Caption         =   "Volume"
         Height          =   195
         Left            =   360
         TabIndex        =   14
         Top             =   1440
         Width           =   525
      End
      Begin VB.Label LabSupplVol 
         Caption         =   "Supplement"
         Height          =   255
         Left            =   1560
         TabIndex        =   13
         Top             =   1440
         Width           =   855
      End
      Begin VB.Label LabSupplNo 
         AutoSize        =   -1  'True
         Caption         =   "Supplement"
         Height          =   195
         Left            =   3960
         TabIndex        =   12
         Top             =   1440
         Width           =   840
      End
   End
   Begin VB.CommandButton CmdOpenRepFile 
      Caption         =   "Report"
      Height          =   375
      Left            =   1200
      TabIndex        =   8
      Top             =   3360
      Width           =   975
   End
   Begin ComctlLib.TreeView DirTree 
      Height          =   255
      Left            =   3600
      TabIndex        =   17
      Top             =   3360
      Visible         =   0   'False
      Width           =   615
      _ExtentX        =   1085
      _ExtentY        =   450
      _Version        =   327682
      Style           =   7
      Appearance      =   1
   End
End
Attribute VB_Name = "FrmBase2Doc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub CmdCancel_Click()
    Unload Me
End Sub

Private Sub CmdCfg_Click()
    'FrmCfg.OpenConfiguration
End Sub

Private Sub CmdConvert_Click()
    Dim IssuePath As String
    Dim DBPath As String
    Dim BackupPath As String
    Dim DBFile As String
    Dim BackupFile As String
    
    MousePointer = vbHourglass
    
    IssuePath = IssueFullPath(TxtSiglum.Caption, TxtVol.Text, TxtSupplVol.Text, TxtNro.Text, txtSupplNro.Text)
    If Len(IssuePath) > 0 Then
        DBPath = IssuePath + PathSep + BaseDIR
        BackupPath = IssuePath + PathSep + DTDs(CurrDTD).name
        
        DBFile = IssueId(TxtVol.Text, TxtSupplVol.Text, TxtNro.Text, txtSupplNro.Text)
        BackupFile = TxtSiglum.Caption + DBFile
        If FileExist(DBPath, DBFile + ".mst", "Base to convert") Then
            If Not DirExist(BackupPath) Then MakeDir BackupPath
            If DirExist(BackupPath, "Backup Directory (Conversion Result)") Then
                Call ConvertDBtoDoc(DBPath, DBFile, BackupPath, BackupFile)
                Call frmFindBrowser.CallBrowser(BackupPath, BackupFile + ".htm")
                Call FrmReport.ShowReport(BackupPath, BackupFile + ReportExt)
            End If
        End If
    End If
    MousePointer = vbArrow
        
End Sub

Private Sub CmdOpenRepFile_Click()
    Dim IssuePath As String
    Dim DBPath As String
    Dim BackupPath As String
    Dim DBFile As String
    Dim BackupFile As String
    
    MousePointer = vbHourglass
    
    IssuePath = IssueFullPath(TxtSiglum.Caption, TxtVol.Text, TxtSupplVol.Text, TxtNro.Text, txtSupplNro.Text)
    If Len(IssuePath) > 0 Then
        BackupPath = IssuePath + PathSep + DTDs(CurrDTD).name
        BackupFile = TxtSiglum.Caption + IssueId(TxtVol.Text, TxtSupplVol.Text, TxtNro.Text, txtSupplNro.Text)
        If FileExist(BackupPath, BackupFile + ReportExt) Then
            Call FrmReport.ShowReport(BackupPath, BackupFile + ReportExt)
        End If
    End If
    MousePointer = vbArrow

End Sub

Private Sub CmdView_Click()
    Dim IssuePath As String
    Dim DBPath As String
    Dim BackupPath As String
    Dim DBFile As String
    Dim BackupFile As String
    
    MousePointer = vbHourglass
    
    IssuePath = IssueFullPath(TxtSiglum.Caption, TxtVol.Text, TxtSupplVol.Text, TxtNro.Text, txtSupplNro.Text)
    If Len(IssuePath) > 0 Then
        BackupPath = IssuePath + PathSep + DTDs(CurrDTD).name
        BackupFile = TxtSiglum.Caption + IssueId(TxtVol.Text, TxtSupplVol.Text, TxtNro.Text, txtSupplNro.Text)
        If FileExist(BackupPath, BackupFile + ".htm") Then
            Call frmFindBrowser.CallBrowser(BackupPath, BackupFile + ".htm")
        End If
        'Call Shell("c:\winnt\start.exe " & BackupPath & "\" & BackupFile + ".htm")
    End If
    MousePointer = vbArrow
    
End Sub

Private Sub ComboDTD_Change()
    Dim exist As Boolean
    Dim current As ClDTD
    
    CurrDTD = ComboDTD.Text
    Set current = New ClDTD
    Set current = DTDs(CurrDTD, exist)
    If exist Then Call Serial_GetExistingCombo(ComboPer, DTDs(CurrDTD).PFT_Title)
    Set current = Nothing
End Sub

Private Sub ComboDTD_Click()
    Dim exist As Boolean
    Dim current As ClDTD
    
    CurrDTD = ComboDTD.Text
    Set current = New ClDTD
    Set current = DTDs(CurrDTD, exist)
    If exist Then Call Serial_GetExistingCombo(ComboPer, DTDs(CurrDTD).PFT_Title)
    Set current = Nothing
End Sub

Private Sub ComboPer_Click()
    Dim mfn As Long
    
    mfn = Serial_CheckExisting(ComboPer.Text)
    TxtSiglum.Caption = Serial_TxtContent(mfn, 930)
    TxtVol.Text = ""
    TxtSupplVol.Text = ""
    TxtNro.Text = ""
    txtSupplNro.Text = ""
    
End Sub

Private Sub Command1_Click()
 Dim x As ClIsisDll
 Set x = New ClIsisDll
    x.Teste
 Set x = Nothing
End Sub

Private Sub Form_Unload(Cancel As Integer)
    '-app-IsisAppDelete (AppHandle)
    'Unload FrmCfg
End Sub

Sub OpenForm()
    Dim i As Long
    
    
    ComboDTD.Clear
    For i = 1 To DTDs.Count
        ComboDTD.AddItem DTDs(i).name
    Next
    
    With TitleDB
    .Field = TitleDB_Field
    .File = TitleDB_File
    .FullPath = SerialDirectory + "\title"
    .InvFile = TitleDB_InvFile
    .Label = TitleDB_Label
    End With
    
    'Call Serial_GetExistingCombo(ComboPer, MEDLINE_TITLE)
    
    Show 'vbModal
End Sub


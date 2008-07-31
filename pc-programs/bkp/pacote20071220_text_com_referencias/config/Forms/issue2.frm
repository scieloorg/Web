VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form FrmIssue2 
   Caption         =   "Issue"
   ClientHeight    =   5760
   ClientLeft      =   1575
   ClientTop       =   1695
   ClientWidth     =   8985
   Icon            =   "issue2.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5760
   ScaleWidth      =   8985
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton CmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   6600
      TabIndex        =   35
      Top             =   120
      Width           =   855
   End
   Begin VB.CommandButton FormCmdSave 
      Caption         =   "Save"
      Height          =   375
      Left            =   5640
      TabIndex        =   34
      Top             =   120
      Width           =   855
   End
   Begin VB.CommandButton FormCmdAju 
      Caption         =   "Help"
      Height          =   375
      Left            =   7920
      TabIndex        =   37
      Top             =   120
      Width           =   855
   End
   Begin TabDlg.SSTab SSTab1 
      Height          =   5055
      Left            =   120
      TabIndex        =   0
      Top             =   600
      Width           =   8775
      _ExtentX        =   15478
      _ExtentY        =   8916
      _Version        =   327680
      TabHeight       =   520
      TabCaption(0)   =   "General"
      TabPicture(0)   =   "issue2.frx":030A
      Tab(0).ControlCount=   1
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "FramFasc2"
      Tab(0).Control(0).Enabled=   0   'False
      TabCaption(1)   =   "Bibliographic Strip"
      TabPicture(1)   =   "issue2.frx":0326
      Tab(1).ControlCount=   1
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "FramLeg"
      Tab(1).Control(0).Enabled=   0   'False
      TabCaption(2)   =   "Table of Contents"
      TabPicture(2)   =   "issue2.frx":0342
      Tab(2).ControlCount=   1
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "Frame1"
      Tab(2).Control(0).Enabled=   0   'False
      Begin VB.Frame FramFasc2 
         Height          =   4575
         Left            =   120
         TabIndex        =   68
         Top             =   360
         Width           =   8535
         Begin VB.ComboBox ComboScheme 
            Height          =   315
            Left            =   240
            Style           =   2  'Dropdown List
            TabIndex        =   90
            Top             =   4080
            Width           =   5295
         End
         Begin VB.ComboBox ComboStandard 
            Height          =   315
            Left            =   240
            Style           =   2  'Dropdown List
            TabIndex        =   89
            Top             =   3360
            Width           =   5295
         End
         Begin VB.TextBox TxtIssSponsor 
            Height          =   285
            Left            =   240
            TabIndex        =   7
            Top             =   2640
            Width           =   5295
         End
         Begin VB.TextBox TxtIssTitle 
            Height          =   285
            Left            =   240
            TabIndex        =   4
            Top             =   1200
            Width           =   5295
         End
         Begin VB.TextBox TxtIssPublisher 
            Height          =   285
            Left            =   240
            TabIndex        =   6
            Top             =   1920
            Width           =   5295
         End
         Begin VB.TextBox TxtIssuept 
            Height          =   285
            Left            =   6120
            TabIndex        =   5
            Top             =   1200
            Width           =   1935
         End
         Begin VB.TextBox TxtCover 
            Height          =   285
            Left            =   6120
            TabIndex        =   8
            Top             =   1920
            Width           =   1935
         End
         Begin VB.TextBox TxtDateIso 
            Height          =   285
            Left            =   6120
            TabIndex        =   3
            Top             =   480
            Width           =   1935
         End
         Begin VB.TextBox TxtDoccount 
            Height          =   285
            Left            =   3840
            TabIndex        =   2
            Top             =   480
            Width           =   1695
         End
         Begin VB.ComboBox ComboStatus 
            Height          =   315
            Left            =   240
            Style           =   2  'Dropdown List
            TabIndex        =   1
            Top             =   480
            Width           =   3375
         End
         Begin VB.Label LabScheme 
            AutoSize        =   -1  'True
            Caption         =   "Scheme"
            Height          =   195
            Left            =   240
            TabIndex        =   88
            Top             =   3840
            Width           =   585
         End
         Begin VB.Label LabStandard 
            AutoSize        =   -1  'True
            Caption         =   "Standard"
            Height          =   195
            Left            =   240
            TabIndex        =   87
            Top             =   3120
            Width           =   645
         End
         Begin VB.Label LabIssSponsor 
            AutoSize        =   -1  'True
            Caption         =   "Sponsor"
            Height          =   195
            Left            =   240
            TabIndex        =   76
            Top             =   2400
            Width           =   585
         End
         Begin VB.Label LabFascTitulo 
            AutoSize        =   -1  'True
            Caption         =   "Title"
            Height          =   195
            Left            =   240
            TabIndex        =   75
            Top             =   960
            Width           =   300
         End
         Begin VB.Label LabEditorEspecial 
            AutoSize        =   -1  'True
            Caption         =   "Editor"
            Height          =   195
            Left            =   240
            TabIndex        =   74
            Top             =   1680
            Width           =   405
         End
         Begin VB.Label LabParte 
            AutoSize        =   -1  'True
            Caption         =   "Part"
            Height          =   195
            Left            =   6120
            TabIndex        =   73
            Top             =   960
            Width           =   285
         End
         Begin VB.Label LabFigCapa 
            AutoSize        =   -1  'True
            Caption         =   "Cover picture"
            Height          =   195
            Left            =   6120
            TabIndex        =   72
            Top             =   1680
            Width           =   945
         End
         Begin VB.Label LabDataIso 
            AutoSize        =   -1  'True
            Caption         =   "Date ISO"
            Height          =   195
            Left            =   6120
            TabIndex        =   71
            Top             =   240
            Width           =   660
         End
         Begin VB.Label LabQtdDoc 
            AutoSize        =   -1  'True
            Caption         =   "Number of Documents"
            Height          =   195
            Left            =   3840
            TabIndex        =   70
            Top             =   240
            Width           =   1590
         End
         Begin VB.Label LabStatus 
            AutoSize        =   -1  'True
            Caption         =   "Status"
            Height          =   195
            Left            =   240
            TabIndex        =   69
            Top             =   240
            Width           =   450
         End
      End
      Begin VB.Frame FramLeg 
         Height          =   3495
         Left            =   -74880
         TabIndex        =   40
         Top             =   480
         Width           =   8535
         Begin VB.Frame Legend 
            Caption         =   "Idioma 1:"
            Height          =   975
            Index           =   1
            Left            =   120
            TabIndex        =   59
            Top             =   240
            Width           =   8295
            Begin VB.TextBox TxtAno 
               Height          =   285
               Index           =   1
               Left            =   7560
               TabIndex        =   16
               Text            =   " "
               Top             =   600
               Width           =   615
            End
            Begin VB.TextBox TxtMes 
               Height          =   285
               Index           =   1
               Left            =   6600
               TabIndex        =   15
               Text            =   " "
               Top             =   600
               Width           =   975
            End
            Begin VB.TextBox TxtLoc 
               Height          =   285
               Index           =   1
               Left            =   5400
               TabIndex        =   14
               Text            =   " "
               Top             =   600
               Width           =   1215
            End
            Begin VB.TextBox TxtNro 
               Height          =   285
               Index           =   1
               Left            =   3960
               TabIndex        =   12
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtVol 
               Height          =   285
               Index           =   1
               Left            =   2520
               TabIndex        =   10
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtTitAbr 
               Height          =   285
               Index           =   1
               Left            =   120
               TabIndex        =   9
               Text            =   " "
               Top             =   600
               Width           =   2415
            End
            Begin VB.TextBox TxtSupplNro 
               Height          =   285
               Index           =   1
               Left            =   4680
               TabIndex        =   13
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtSupplVol 
               Height          =   285
               Index           =   1
               Left            =   3240
               TabIndex        =   11
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.Label Label1 
               Caption         =   "Short Title"
               Height          =   255
               Index           =   1
               Left            =   120
               TabIndex        =   67
               Top             =   360
               Width           =   1935
            End
            Begin VB.Label Label2 
               Caption         =   "Vol"
               Height          =   255
               Index           =   1
               Left            =   2520
               TabIndex        =   66
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label3 
               Caption         =   "Num"
               Height          =   255
               Index           =   1
               Left            =   3960
               TabIndex        =   65
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label4 
               Caption         =   "Vol Sup"
               Height          =   255
               Index           =   1
               Left            =   3240
               TabIndex        =   64
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label5 
               Caption         =   "NumSup"
               Height          =   255
               Index           =   1
               Left            =   4680
               TabIndex        =   63
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label6 
               Caption         =   "City"
               Height          =   255
               Index           =   1
               Left            =   5520
               TabIndex        =   62
               Top             =   360
               Width           =   975
            End
            Begin VB.Label Label7 
               Caption         =   "Month"
               Height          =   255
               Index           =   1
               Left            =   6600
               TabIndex        =   61
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label8 
               Caption         =   "Year"
               Height          =   255
               Index           =   1
               Left            =   7560
               TabIndex        =   60
               Top             =   360
               Width           =   615
            End
         End
         Begin VB.Frame Legend 
            Caption         =   "Idioma 1:"
            Height          =   975
            Index           =   2
            Left            =   120
            TabIndex        =   50
            Top             =   1320
            Width           =   8295
            Begin VB.TextBox TxtAno 
               Height          =   285
               Index           =   2
               Left            =   7560
               TabIndex        =   24
               Text            =   " "
               Top             =   600
               Width           =   615
            End
            Begin VB.TextBox TxtMes 
               Height          =   285
               Index           =   2
               Left            =   6600
               TabIndex        =   23
               Text            =   " "
               Top             =   600
               Width           =   975
            End
            Begin VB.TextBox TxtLoc 
               Height          =   285
               Index           =   2
               Left            =   5400
               TabIndex        =   22
               Text            =   " "
               Top             =   600
               Width           =   1215
            End
            Begin VB.TextBox TxtNro 
               Height          =   285
               Index           =   2
               Left            =   3960
               TabIndex        =   20
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtVol 
               Height          =   285
               Index           =   2
               Left            =   2520
               TabIndex        =   18
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtTitAbr 
               Height          =   285
               Index           =   2
               Left            =   120
               TabIndex        =   17
               Text            =   " "
               Top             =   600
               Width           =   2415
            End
            Begin VB.TextBox TxtSupplNro 
               Height          =   285
               Index           =   2
               Left            =   4680
               TabIndex        =   21
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtSupplVol 
               Height          =   285
               Index           =   2
               Left            =   3240
               TabIndex        =   19
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.Label Label1 
               Caption         =   "Short Title"
               Height          =   255
               Index           =   2
               Left            =   120
               TabIndex        =   58
               Top             =   360
               Width           =   1935
            End
            Begin VB.Label Label2 
               Caption         =   "Vol"
               Height          =   255
               Index           =   2
               Left            =   2520
               TabIndex        =   57
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label3 
               Caption         =   "Num"
               Height          =   255
               Index           =   2
               Left            =   3960
               TabIndex        =   56
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label4 
               Caption         =   "Vol Sup"
               Height          =   255
               Index           =   2
               Left            =   3240
               TabIndex        =   55
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label5 
               Caption         =   "NumSup"
               Height          =   255
               Index           =   2
               Left            =   4680
               TabIndex        =   54
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label6 
               Caption         =   "City"
               Height          =   255
               Index           =   2
               Left            =   5520
               TabIndex        =   53
               Top             =   360
               Width           =   735
            End
            Begin VB.Label Label7 
               Caption         =   "Month"
               Height          =   255
               Index           =   2
               Left            =   6600
               TabIndex        =   52
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label8 
               Caption         =   "Year"
               Height          =   255
               Index           =   2
               Left            =   7560
               TabIndex        =   51
               Top             =   360
               Width           =   615
            End
         End
         Begin VB.Frame Legend 
            Caption         =   "Idioma 1:"
            Height          =   975
            Index           =   3
            Left            =   120
            TabIndex        =   41
            Top             =   2400
            Width           =   8295
            Begin VB.TextBox TxtAno 
               Height          =   285
               Index           =   3
               Left            =   7560
               TabIndex        =   32
               Text            =   " "
               Top             =   600
               Width           =   615
            End
            Begin VB.TextBox TxtMes 
               Height          =   285
               Index           =   3
               Left            =   6600
               TabIndex        =   31
               Text            =   " "
               Top             =   600
               Width           =   975
            End
            Begin VB.TextBox TxtLoc 
               Height          =   285
               Index           =   3
               Left            =   5400
               TabIndex        =   30
               Text            =   " "
               Top             =   600
               Width           =   1215
            End
            Begin VB.TextBox TxtNro 
               Height          =   285
               Index           =   3
               Left            =   3960
               TabIndex        =   28
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtVol 
               Height          =   285
               Index           =   3
               Left            =   2520
               TabIndex        =   26
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtTitAbr 
               Height          =   285
               Index           =   3
               Left            =   120
               TabIndex        =   25
               Text            =   " "
               Top             =   600
               Width           =   2415
            End
            Begin VB.TextBox TxtSupplNro 
               Height          =   285
               Index           =   3
               Left            =   4680
               TabIndex        =   29
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtSupplVol 
               Height          =   285
               Index           =   3
               Left            =   3240
               TabIndex        =   27
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.Label Label1 
               Caption         =   "Short Title"
               Height          =   255
               Index           =   3
               Left            =   120
               TabIndex        =   49
               Top             =   360
               Width           =   1935
            End
            Begin VB.Label Label2 
               Caption         =   "Vol"
               Height          =   255
               Index           =   3
               Left            =   2520
               TabIndex        =   48
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label3 
               Caption         =   "Num"
               Height          =   255
               Index           =   3
               Left            =   3960
               TabIndex        =   47
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label4 
               Caption         =   "Vol Sup"
               Height          =   255
               Index           =   3
               Left            =   3240
               TabIndex        =   46
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label5 
               Caption         =   "NumSup"
               Height          =   255
               Index           =   3
               Left            =   4680
               TabIndex        =   45
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label6 
               Caption         =   "City"
               Height          =   255
               Index           =   3
               Left            =   5520
               TabIndex        =   44
               Top             =   360
               Width           =   735
            End
            Begin VB.Label Label7 
               Caption         =   "Month"
               Height          =   255
               Index           =   3
               Left            =   6600
               TabIndex        =   43
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label8 
               Caption         =   "Year"
               Height          =   255
               Index           =   3
               Left            =   7560
               TabIndex        =   42
               Top             =   360
               Width           =   615
            End
         End
      End
      Begin VB.Frame Frame1 
         Height          =   4575
         Left            =   -74880
         TabIndex        =   36
         Top             =   360
         Width           =   8535
         Begin VB.Frame Frame2 
            Caption         =   "Sections of "
            Height          =   4335
            Left            =   4560
            TabIndex        =   77
            Top             =   120
            Width           =   3855
            Begin VB.ListBox List1 
               Height          =   255
               Index           =   3
               Left            =   840
               Sorted          =   -1  'True
               TabIndex        =   86
               Top             =   3000
               Visible         =   0   'False
               Width           =   2895
            End
            Begin VB.ListBox List1 
               Height          =   255
               Index           =   2
               Left            =   1080
               Sorted          =   -1  'True
               TabIndex        =   85
               Top             =   1560
               Visible         =   0   'False
               Width           =   2655
            End
            Begin VB.ListBox List1 
               Height          =   255
               Index           =   1
               Left            =   960
               Sorted          =   -1  'True
               TabIndex        =   84
               Top             =   120
               Visible         =   0   'False
               Width           =   2775
            End
            Begin VB.TextBox IssueSection 
               Height          =   975
               Index           =   3
               Left            =   120
               Locked          =   -1  'True
               MultiLine       =   -1  'True
               ScrollBars      =   2  'Vertical
               TabIndex        =   83
               Top             =   3240
               Width           =   3615
            End
            Begin VB.TextBox IssueSection 
               Height          =   975
               Index           =   2
               Left            =   120
               Locked          =   -1  'True
               MultiLine       =   -1  'True
               ScrollBars      =   2  'Vertical
               TabIndex        =   82
               Top             =   1920
               Width           =   3615
            End
            Begin VB.TextBox IssueSection 
               Height          =   975
               Index           =   1
               Left            =   120
               Locked          =   -1  'True
               MultiLine       =   -1  'True
               ScrollBars      =   2  'Vertical
               TabIndex        =   81
               Top             =   480
               Width           =   3615
            End
            Begin VB.Label LabIdiom 
               AutoSize        =   -1  'True
               Caption         =   "English"
               Height          =   195
               Index           =   3
               Left            =   120
               TabIndex        =   80
               Top             =   3000
               Width           =   510
            End
            Begin VB.Label LabIdiom 
               AutoSize        =   -1  'True
               Caption         =   "Spanish"
               Height          =   195
               Index           =   1
               Left            =   120
               TabIndex        =   79
               Top             =   240
               Width           =   570
            End
            Begin VB.Label LabIdiom 
               AutoSize        =   -1  'True
               Caption         =   "Portuguese"
               Height          =   195
               Index           =   2
               Left            =   120
               TabIndex        =   78
               Top             =   1680
               Width           =   810
            End
         End
         Begin VB.ListBox DispoSecTitle 
            Height          =   2760
            Left            =   120
            Sorted          =   -1  'True
            Style           =   1  'Checkbox
            TabIndex        =   38
            Top             =   960
            Width           =   4215
         End
         Begin VB.CommandButton CmdNewSections 
            Caption         =   "Create section"
            Height          =   375
            Left            =   1200
            TabIndex        =   33
            Top             =   3960
            Width           =   1575
         End
         Begin VB.Label Label9 
            Caption         =   "Select the sections that are present in "
            Height          =   615
            Left            =   120
            TabIndex        =   39
            Top             =   240
            Width           =   4215
         End
      End
   End
End
Attribute VB_Name = "FrmIssue2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private NormalHeight As Long
Private NormalWidth As Long

Private OldHeight As Long
Private OldWidth As Long

Private xCurrDate As String

Private MfnSection As Long

Private Property Get CurrDate() As String
    CurrDate = xCurrDate
End Property

Private Property Let CurrDate(d As String)
    Dim IdiomIdx As Long
    Dim year As String
    Dim month As String
    
    If Len(xCurrDate) > 0 Then
        MsgBox "Check the date of bibliographic strip."
    End If
    
    xCurrDate = d
    year = Mid(d, 1, 4)
    month = Mid(d, 5, 2)
        
    For IdiomIdx = 1 To IdiomsInfo.Count
        If Len(month) > 0 Then
            If (CLng(month) > 0) Then TxtMes(IdiomIdx).Text = Months.GetMonth(IdiomsInfo(IdiomIdx).Code, CLng(month))
        End If
        TxtAno(IdiomIdx).Text = year
    Next
    
End Property

Public Sub LoadIssue(MfnIssue As Long)
    Dim i As Long
    
    With ConfigLabels
    For i = 1 To IdiomsInfo.Count
        Label1(i).Caption = .ser1_ShortTitle
        Label2(i).Caption = .Volume
        Label3(i).Caption = .Issueno
        Label4(i).Caption = .VolSuppl
        Label5(i).Caption = .IssueSuppl
        Label6(i).Caption = .Issue_Place
        Label7(i).Caption = .Issue_month
        Label8(i).Caption = .Issue_year
    Next
    
    SSTab1.TabCaption(0) = .Issue_General
    SSTab1.TabCaption(1) = .Issue_BibliographicStrip
    SSTab1.TabCaption(2) = .Issue_Tableofcontents
    LabStatus.Caption = .Issue_status
    LabFascTitulo.Caption = .Issue_IssTitle
    LabEditorEspecial.Caption = .Issue_IssPublisher
    LabFigCapa.Caption = .Issue_Cover
    LabDataIso.Caption = .Issue_DateISO
    LabIssSponsor.Caption = .Issue_Sponsor
    LabParte.Caption = .Issue_Part
    LabQtdDoc.Caption = .Issue_Numberofdocuments
    LabScheme.Caption = .Issue_Scheme
    LabStandard.Caption = .Issue_Standard
    Label9.Caption = .Issue_SelectSections
    Frame2.Caption = .Issue_Sectionsof
    CmdNewSections.Caption = .Issue_CreateSection
    CmdClose.Caption = .ButtonClose
    FormCmdAju.Caption = .mnHelp
    FormCmdSave.Caption = .ButtonSave
    End With
    
    IdiomLoad
    
    Call FillCombo(ComboStatus, CodeIssStatus)
    Call FillCombo(ComboStandard, CodeStandard)
    Call FillCombo(ComboScheme, CodeScheme)
    
    LoadGeneral (MfnIssue)
    LoadLegend (MfnIssue)
    
    LoadDispoSections (FrmIssue.SiglaPeriodico)
    Label9.Caption = Label9.Caption + " " + Caption
    Frame2.Caption = Frame2.Caption + " " + Caption
    LoadIssueSections (MfnIssue)

    OldHeight = Height
    OldWidth = Width
    NormalHeight = Height
    NormalWidth = Width
    
    Show vbModal
    
End Sub


Private Sub IdiomLoad()
    Dim i As Long
    
    For i = 1 To IdiomsInfo.Count
        LabIdiom(i).Caption = IdiomsInfo(i).label  '990316
        Legend(i).Caption = IdiomsInfo(i).label
    Next
End Sub


Private Sub LoadGeneral(MfnIssue As Long)
    Dim i As Long
    Dim naoachou As Boolean
    Dim Issue_status As String
    
    With BDIssues
    If MfnIssue > 0 Then
    
        TxtDoccount.Text = .UsePft(MfnIssue, "v122")
        TxtDateIso.Text = .UsePft(MfnIssue, "v65")
        TxtIssuept.Text = .UsePft(MfnIssue, "v34")
        TxtIssSponsor.Text = .UsePft(MfnIssue, "v140")
        TxtIssTitle.Text = .UsePft(MfnIssue, "v33")
        TxtIssPublisher.Text = .UsePft(MfnIssue, "v62")
        TxtCover.Text = .UsePft(MfnIssue, "v97")
        
        'ComboStatus.Text = GetComboContent(CodeIssStatus, MfnIssue, 42)
        'ComboStandard.Text = GetComboContent(CodeStandard, MfnIssue, 117)
        'ComboScheme.Text = GetComboContent(CodeScheme, MfnIssue, 85)
    
    Else
        TxtDoccount.Text = ""
        TxtDateIso.Text = ""
        TxtIssuept.Text = ""
        TxtIssSponsor.Text = ""
        TxtIssTitle.Text = ""
        TxtIssPublisher.Text = ""
        TxtCover.Text = ""
    End If
    
    End With
End Sub

Private Sub LoadLegend(MfnIssue As Long)
    Dim IdiomIdx As Long
    Dim year As String
    Dim month As String
    
    If CheckDateISO(TxtDateIso.Text) Then
        year = Mid(TxtDateIso.Text, 1, 4)
        month = Mid(TxtDateIso.Text, 5, 2)
    End If
    
    With BDIssues
        
    For IdiomIdx = 1 To IdiomsInfo.Count
        Legend(IdiomIdx).Caption = IdiomsInfo(IdiomIdx).label
        TxtTitAbr(IdiomIdx).Text = FrmIssue.TxtStitle.Caption
            
        If Len(FrmIssue.TxtVolid.Text) > 0 Then
            If IdiomsInfo(IdiomIdx).Code = "en" Then
                TxtVol(IdiomIdx).Text = "vol." + FrmIssue.TxtVolid.Text
            Else
                TxtVol(IdiomIdx).Text = "v." + FrmIssue.TxtVolid.Text
            End If
        Else
            TxtVol(IdiomIdx).Text = ""
        End If
            
        If Len(FrmIssue.TxtIssueno.Text) > 0 Then
            TxtNro(IdiomIdx).Text = "n." + FrmIssue.TxtIssueno.Text
        Else
            TxtNro(IdiomIdx).Text = ""
        End If
            
        If Len(FrmIssue.TxtSupplVol.Text) > 0 Then
            TxtSupplVol(IdiomIdx).Text = "s." + FrmIssue.TxtSupplVol.Text
        Else
            TxtSupplVol(IdiomIdx).Text = ""
        End If
            
        If Len(FrmIssue.TxtSupplNo.Text) > 0 Then
            TxtSupplNro(IdiomIdx).Text = "s." + FrmIssue.TxtSupplNo.Text
        Else
            TxtSupplNro(IdiomIdx).Text = ""
        End If
            
        TxtLoc(IdiomIdx).Text = FrmIssue.Cidade
        
        TxtMes(IdiomIdx).Text = ""
        If MfnIssue > 0 Then TxtMes(IdiomIdx).Text = .UsePft(MfnIssue, "(if v43^l='" + IdiomsInfo(IdiomIdx).Code + "' then v43^m fi)")
        If Len(month) > 0 Then
            If (CLng(month) > 0) And (Len(TxtMes(IdiomIdx).Text) = 0) Then TxtMes(IdiomIdx).Text = Months.GetMonth(IdiomsInfo(IdiomIdx).Code, CLng(month))
        End If
            
        TxtAno(IdiomIdx).Text = year
            
        Caption = TxtTitAbr(IdiomIdx).Text + " " + TxtVol(IdiomIdx).Text + " " + TxtSupplVol(IdiomIdx).Text + " " + TxtNro(IdiomIdx).Text + " " + TxtSupplNro(IdiomIdx).Text
    Next
    
    End With
End Sub

Private Sub LoadDispoSections(Siglum As String)
    Dim i As Long
    Dim s As String
    Dim p As Long
    Dim p0 As Long
    
    
    MfnSection = CheckExistingSection(Siglum)
    If MfnSection > 0 Then
        s = DBSection.UsePft(MfnSection, "(v49^c|-|,v49^t|;|)")
        p0 = 1
        p = InStr(s, ";")
        While p > 0
            DispoSecTitleAdditem Mid(s, p0, p - p0)
            p0 = p + 1
            p = InStr(p0, s, ";", vbBinaryCompare)
        Wend
    End If
End Sub

Private Sub LoadIssueSections(MfnIssue As Long)
    Dim i As Long
    Dim s As String
    Dim p As Long
    Dim p0 As Long
    Dim Section As String
    Dim k As Long
    
    If MfnIssue > 0 Then
        For i = 1 To IdiomsInfo.Count
            s = BDIssues.UsePft(MfnIssue, "(if v49^l='" + IdiomsInfo(i).Code + "' then v49^c|-|,v49^t|;| fi)")
        
            p0 = 1
            p = InStr(s, ";")
            While p > 0
                Section = Mid(s, p0, p - p0)
                Call DispoSecTitleChecked(Section, True)
                Call IssueSectionsAdditem(i, Section)
                p0 = p + 1
                p = InStr(p0, s, ";", vbBinaryCompare)
            Wend
            
            IssueSection(i).Text = ""
            For k = 1 To List1(i).ListCount
                IssueSection(i).Text = IssueSection(i).Text + List1(i).List(k - 1) + vbCrLf
            Next
            
        Next
    End If
End Sub

Private Function SaveIssue(IssueId As String) As Boolean
    Dim ToCRecord As String
    Dim LegendRecord As String
    Dim s As String
    
    Dim i As Long
    Dim j As Long
    Dim Mfn As Long
    
        
        With FrmIssue
        s = s + TagContent("0", 700)
        s = s + TagContent("i", 706)
        s = s + TagContent("1", 701)
        s = s + TagContent(GetDateISO(Date), 91)
        s = s + TagContent(.ComboPer.Text, 130)
        
        s = s + TagTxtContent(.TxtParallel.Text, 230)
        
        s = s + TagContent(.TxtIssn.Caption, 35)
        s = s + TagTxtContent(.TxtPubl.Text, 480)
        
        s = s + TagContent(.TxtStitle.Caption, 30)
        s = s + TagContent(.TxtVolid.Text, 31)
        s = s + TagContent(.TxtSupplVol.Text, 131)
        s = s + TagContent(.TxtIssueno.Text, 32)
        s = s + TagContent(.TxtSupplNo.Text, 132)
        s = s + TagContent(.TxtIseqno.Text, 36)
        s = s + TagContent(.SiglaPeriodico, 930)
        
        s = s + TagComboContent(CodeIssStatus, ComboStatus.Text, 42)
        s = s + TagComboContent(CodeStandard, ComboStandard.Text, 117)
        s = s + TagComboContent(CodeScheme, ComboScheme.Text, 85)
                        
        s = s + TagContent(TxtDateIso.Text, 65)
        s = s + TagContent(TxtDoccount.Text, 122)
        s = s + TagContent(TxtIssTitle.Text, 33)
        s = s + TagContent(TxtIssuept.Text, 34)
        s = s + TagContent(TxtIssSponsor.Text, 140)
        s = s + TagContent(TxtIssPublisher.Text, 62)
        s = s + TagContent(TxtCover.Text, 97)
        End With
        
        For i = 1 To IdiomsInfo.Count
            ToCRecord = ToCRecord + "<48>^l" + IdiomsInfo(i).Code + "^h" + IdiomsInfo(i).More + "</48>"
            For j = 1 To List1(i).ListCount
                ToCRecord = ToCRecord + "<49>^l" + IdiomsInfo(i).Code + "^c" + Mid(List1(i).List(j - 1), 1, InStr(List1(i).List(j - 1), "-") - 1) + "^t" + Mid(List1(i).List(j - 1), InStr(List1(i).List(j - 1), "-") + 1) + "</49>"
            Next
            
            
            LegendRecord = LegendRecord + "<43>^l" + IdiomsInfo(i).Code + "^t" + TxtTitAbr(i).Text
            If Len(TxtVol(i).Text) > 0 Then LegendRecord = LegendRecord + "^v" + TxtVol(i).Text
            If Len(TxtSupplVol(i).Text) > 0 Then LegendRecord = LegendRecord + "^w" + TxtSupplVol(i).Text
            If Len(TxtNro(i).Text) > 0 Then LegendRecord = LegendRecord + "^n" + TxtNro(i).Text
            If Len(TxtSupplNro(i).Text) > 0 Then LegendRecord = LegendRecord + "^s" + TxtSupplNro(i).Text
            If Len(TxtLoc(i).Text) > 0 Then LegendRecord = LegendRecord + "^c" + TxtLoc(i).Text
            If Len(TxtMes(i).Text) > 0 Then LegendRecord = LegendRecord + "^m" + TxtMes(i).Text
            If Len(TxtAno(i).Text) > 0 Then LegendRecord = LegendRecord + "^a" + TxtAno(i).Text
        Next
        
        s = s + ToCRecord + LegendRecord
    
    Mfn = BDIssues.MfnFindOne(IssueId)
    If Mfn > 0 Then
        If BDIssues.RecordUpdate(Mfn, s) Then
            Call BDIssues.IfUpdate(Mfn, Mfn)
        End If
    Else
        Mfn = BDIssues.RecordSave(s)
        If Mfn > 0 Then Call BDIssues.IfUpdate(Mfn, Mfn)
    End If
    
    SaveIssue = True
End Function

Private Sub IssueSectionsAdditem(IssueSectionIdx As Long, Value As String)
    Dim i As Long
    Dim found As Boolean
    Dim p As Long
    Dim Code As String
    
    If Len(Value) > 0 Then
        p = InStr(Value, "-")
        If p > 0 Then
            Code = Mid(Value, 1, p - 1)
            While (i < List1(IssueSectionIdx).ListCount) And (Not found)
                If InStr(1, List1(IssueSectionIdx).List(i), Code, vbBinaryCompare) > 0 Then
                    found = True
                    List1(IssueSectionIdx).RemoveItem (i)
                End If
                i = i + 1
            Wend
        End If
    
        List1(IssueSectionIdx).AddItem Value
    End If
End Sub

Private Sub DispoSecTitleAdditem(Value As String)
    Dim i As Long
    Dim found As Boolean
    Dim p As Long
    Dim Code As String
    
    p = InStr(Value, "-")
    If p > 0 Then Code = Mid(Value, 1, p - 1)
    
    While (i < DispoSecTitle.ListCount) And (Not found)
        If InStr(DispoSecTitle.List(i), Code) > 0 Then
            found = True
        End If
        i = i + 1
    Wend
    If Not found Then
        DispoSecTitle.AddItem Value
    End If
End Sub

Private Sub DispoSecTitleChecked(Section As String, flag As Boolean)
    Dim i As Long
    Dim found As Boolean
    Dim p As Long
    Dim Code As String
    
    p = InStr(Section, "-")
    If p > 0 Then Code = Mid(Section, 1, p - 1)
    
    While (i < DispoSecTitle.ListCount) And (Not found)
        If InStr(DispoSecTitle.List(i), Code) > 0 Then
            found = True
            DispoSecTitle.Selected(i) = flag
        End If
        i = i + 1
    Wend
    
End Sub


Private Sub CmdNewSections_Click()
    Call section3.LoadDispoSections(FrmIssue.TxtIssn.Caption)
    LoadDispoSections (FrmIssue.TxtIssn.Caption)
End Sub

Private Sub CmdClose_Click()
    Unload Me
End Sub

Private Sub DispoSecTitle_Click()
    Dim i As Long
    Dim j As Long
    Dim k As Long
    Dim found As Boolean
    Dim Code As String
    Dim p As Long
    
    j = DispoSecTitle.ListIndex
    p = InStr(DispoSecTitle.List(j), "-")
    Code = Mid(DispoSecTitle.List(j), 1, p - 1)
    
    For i = 1 To IdiomsInfo.Count
        If DispoSecTitle.Selected(j) Then
            'add
            Call IssueSectionsAdditem(i, DBSection.UsePft(MfnSection, "(if v49^l='" + IdiomsInfo(i).Code + "' and v49^c='" + Code + "' then v49^c,|-|v49^t fi)"))
        Else
            'delete
            found = False
            k = 0
            
            While ((k < List1(i).ListCount) And (Not found))
                If InStr(1, List1(i).List(k), Code, vbBinaryCompare) = 1 Then
                    List1(i).RemoveItem (k)
                    found = True
                End If
                k = k + 1
            Wend
            
            'Text1.Text = Mid(Text1.Text, 1, InStr(Text1.Text, DispoSecTitle.List(j))) + Mid(Text1.Text, InStr(Text1.Text, DispoSecTitle.List(j)) + Len(DispoSecTitle.List(j)) + 1)
            
        End If
        
        IssueSection(i).Text = ""
        For k = 1 To List1(i).ListCount
            IssueSection(i).Text = IssueSection(i).Text + List1(i).List(k - 1) + vbCrLf
        Next
    Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
    FrmIssue.LockNewChoice = False
    xCurrDate = ""
End Sub

Private Sub FormCmdAju_Click()
    Call frmFindBrowser.CallBrowser(FormMenuPrin.DirStruct.Nodes("Help of Section").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Help of Section").Text)
End Sub

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
    If Height <> 1 Then obj.Height = CLng(Height * obj.Height)
    If Width <> 1 Then obj.Width = Width * obj.Width
End Sub

Private Sub PosicionarLegenda(X As Double, Y As Double)
    Dim i As Integer
    
    If (X <> 1) And (Y <> 1) Then
    Call Redimensionar(FramLeg, X, Y, X, Y)
    Call Redimensionar(FormCmdAju, X, Y, X, 1)
    Call Redimensionar(FormCmdSave, X, Y, X, 1)
    
    For i = 1 To 3
        Call Redimensionar(Legend(i), X, Y, X, Y)
        Call Redimensionar(TxtTitAbr(i), X, Y, X, 1)
        Call Redimensionar(TxtVol(i), X, Y, X, 1)
        Call Redimensionar(TxtNro(i), X, Y, X, 1)
        Call Redimensionar(TxtSupplVol(i), X, Y, X, 1)
        Call Redimensionar(TxtSupplNro(i), X, Y, X, 1)
        Call Redimensionar(TxtLoc(i), X, Y, X, 1)
        Call Redimensionar(TxtMes(i), X, Y, X, 1)
        Call Redimensionar(TxtAno(i), X, Y, X, 1)
        Call Redimensionar(Label1(i), X, Y, X, 1)
        Call Redimensionar(Label2(i), X, Y, X, 1)
        Call Redimensionar(Label3(i), X, Y, X, 1)
        Call Redimensionar(Label4(i), X, Y, X, 1)
        Call Redimensionar(Label5(i), X, Y, X, 1)
        Call Redimensionar(Label6(i), X, Y, X, 1)
        Call Redimensionar(Label7(i), X, Y, X, 1)
        Call Redimensionar(Label8(i), X, Y, X, 1)
    Next
    End If
End Sub

Private Sub Posicionar(X As Double, Y As Double)
    
    If (X <> 1) And (Y <> 1) Then
    Call Redimensionar(SSTab1, X, Y, X, Y)
    
    If SSTab1.Tab = 0 Then
        Call PosicionarLegenda(X, Y)
        'If SSTab1.TabVisible(1) Then
            SSTab1.Tab = 1
            'Call PosicionarSumario(X, Y)
            SSTab1.Tab = 0
        'End If
    Else
        'Call PosicionarSumario(X, Y)
        SSTab1.Tab = 0
        Call PosicionarLegenda(X, Y)
        SSTab1.Tab = 1
    End If
    End If
End Sub

Private Sub formcmdsave_Click()
    If Len(CurrDate) > 0 Then
        If StrComp(TxtDateIso.Text, CurrDate, vbTextCompare) <> 0 Then
            MsgBox "You have changed the publication date. Be sure you have also changed the month and year of the bibliographic strip."
        End If
    End If
    SaveIssue (FrmIssue.IssueKeyCurr)
End Sub

Private Function CheckDataTwo() As Boolean
    Dim retorno As Boolean
        
    retorno = True
    If Not CheckDateISO(TxtDateIso.Text) Then
        MsgBox ("Issue_DateISO is mandatory.")
        retorno = False
    End If
    If IsNumber(TxtDoccount.Text) Then
        If CLng(TxtDoccount.Text) = 0 Then
            MsgBox "Invalid value of the number of documents in this issue."
            retorno = False
        End If
    Else
        retorno = False
        MsgBox "Invalid value of the number of documents in this issue."
    End If
    CheckDataTwo = retorno
End Function

Private Sub TxtDateIso_Change()
    If Len(TxtDateIso.Text) = 8 Then
        If CheckDateISO(TxtDateIso.Text) Then
            If Len(CurrDate) > 0 Then
                If StrComp(TxtDateIso.Text, CurrDate) <> 0 Then
                    CurrDate = TxtDateIso.Text
                End If
            Else
                CurrDate = TxtDateIso.Text
            End If
        End If
    End If
End Sub


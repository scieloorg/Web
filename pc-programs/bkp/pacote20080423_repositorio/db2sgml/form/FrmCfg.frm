VERSION 5.00
Begin VB.Form FrmCfg 
   Caption         =   "Configuration"
   ClientHeight    =   6075
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8955
   Icon            =   "FrmCfg.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   6075
   ScaleWidth      =   8955
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton CmdGRK2SGM 
      Caption         =   "..."
      Height          =   255
      Left            =   7080
      TabIndex        =   30
      Top             =   3480
      Width           =   495
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   7920
      TabIndex        =   26
      Top             =   1560
      Width           =   975
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "OK"
      Height          =   375
      Left            =   7920
      TabIndex        =   25
      Top             =   960
      Width           =   975
   End
   Begin VB.Frame Frame1 
      Height          =   5895
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   7575
      Begin VB.CommandButton CmdASC2SGM 
         Caption         =   "..."
         Height          =   255
         Left            =   6960
         TabIndex        =   31
         Top             =   3720
         Width           =   495
      End
      Begin VB.TextBox TxtGRK2SGM 
         Height          =   285
         Left            =   1920
         TabIndex        =   29
         Top             =   3360
         Width           =   4935
      End
      Begin VB.TextBox TxtASC2SGM 
         Height          =   285
         Left            =   1920
         TabIndex        =   28
         Top             =   3720
         Width           =   4935
      End
      Begin VB.TextBox TxtSGM2ASC 
         Height          =   285
         Left            =   1920
         TabIndex        =   27
         Top             =   3000
         Width           =   4935
      End
      Begin VB.TextBox TxtCiparFile 
         Height          =   285
         Left            =   1920
         TabIndex        =   24
         Top             =   5280
         Width           =   4935
      End
      Begin VB.TextBox TxtFilenamePFT 
         Height          =   285
         Left            =   1920
         TabIndex        =   22
         Top             =   4920
         Width           =   4935
      End
      Begin VB.CommandButton CmdSGM2ASC 
         Caption         =   "..."
         Height          =   255
         Left            =   6960
         TabIndex        =   20
         Top             =   3000
         Width           =   495
      End
      Begin VB.TextBox TxtReportFileExtension 
         Height          =   285
         Left            =   1920
         TabIndex        =   19
         Top             =   2400
         Width           =   4935
      End
      Begin VB.TextBox TXTDOCTYPE 
         Height          =   285
         Left            =   1920
         TabIndex        =   17
         Top             =   960
         Width           =   4935
      End
      Begin VB.TextBox TxtDTDFile 
         Height          =   285
         Left            =   1920
         Locked          =   -1  'True
         TabIndex        =   15
         Top             =   1320
         Width           =   4935
      End
      Begin VB.CommandButton CmdDTDFile 
         Caption         =   "..."
         Height          =   255
         Left            =   6960
         TabIndex        =   14
         Top             =   1320
         Width           =   495
      End
      Begin VB.TextBox TxtPFTFile 
         Height          =   285
         Left            =   1920
         Locked          =   -1  'True
         TabIndex        =   11
         Top             =   1680
         Width           =   4935
      End
      Begin VB.TextBox TxtReportPFTFile 
         Height          =   285
         Left            =   1920
         Locked          =   -1  'True
         TabIndex        =   10
         Top             =   2040
         Width           =   4935
      End
      Begin VB.CommandButton CmdRepPFTFile 
         Caption         =   "..."
         Height          =   255
         Left            =   6960
         TabIndex        =   9
         Top             =   2040
         Width           =   495
      End
      Begin VB.CommandButton CmdPFTFile 
         Caption         =   "..."
         Height          =   255
         Left            =   6960
         TabIndex        =   8
         Top             =   1680
         Width           =   495
      End
      Begin VB.TextBox TxtRecordIdField 
         Height          =   285
         Left            =   1920
         TabIndex        =   7
         Top             =   4560
         Width           =   4935
      End
      Begin VB.TextBox TxtValidRecords 
         Height          =   285
         Left            =   1920
         TabIndex        =   5
         Top             =   4200
         Width           =   4935
      End
      Begin VB.ComboBox ComboDTD 
         Height          =   315
         Left            =   1920
         Style           =   2  'Dropdown List
         TabIndex        =   1
         Top             =   360
         Width           =   4935
      End
      Begin VB.Label Label7 
         AutoSize        =   -1  'True
         Caption         =   "ASCII to SGML"
         Height          =   195
         Left            =   720
         TabIndex        =   34
         Top             =   3720
         Width           =   1080
      End
      Begin VB.Label Label4 
         AutoSize        =   -1  'True
         Caption         =   "Greek to SGML"
         Height          =   195
         Left            =   720
         TabIndex        =   33
         Top             =   3360
         Width           =   1110
      End
      Begin VB.Label Label3 
         AutoSize        =   -1  'True
         Caption         =   "SGML to ASCII"
         Height          =   195
         Left            =   720
         TabIndex        =   32
         Top             =   3000
         Width           =   1080
      End
      Begin VB.Label Label2 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Cipar File"
         Height          =   195
         Left            =   1035
         TabIndex        =   23
         Top             =   5280
         Width           =   645
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "File Name PFT"
         Height          =   195
         Left            =   630
         TabIndex        =   21
         Top             =   4920
         Width           =   1050
      End
      Begin VB.Label LabReportFileExtension 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Report File Extension"
         Height          =   195
         Left            =   180
         TabIndex        =   18
         Top             =   2400
         Width           =   1500
      End
      Begin VB.Label LabDTDFile 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "DTD File"
         Height          =   195
         Left            =   1035
         TabIndex        =   16
         Top             =   1320
         Width           =   630
      End
      Begin VB.Label LabPFTFile 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "PFT File"
         Height          =   195
         Left            =   1080
         TabIndex        =   13
         Top             =   1680
         Width           =   585
      End
      Begin VB.Label LabReportFilePFT 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Report PFT File"
         Height          =   195
         Left            =   615
         TabIndex        =   12
         Top             =   2040
         Width           =   1110
      End
      Begin VB.Label Label6 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Record Id Field"
         Height          =   195
         Left            =   600
         TabIndex        =   6
         Top             =   4560
         Width           =   1080
      End
      Begin VB.Label Label5 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Valid Records"
         Height          =   195
         Left            =   690
         TabIndex        =   4
         Top             =   4200
         Width           =   990
      End
      Begin VB.Label LabGizmoFiles 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Gizmo Files"
         Height          =   195
         Left            =   240
         TabIndex        =   3
         Top             =   2760
         Width           =   795
      End
      Begin VB.Label LabDocTpName 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "DocType Name"
         Height          =   195
         Left            =   555
         TabIndex        =   2
         Top             =   960
         Width           =   1125
      End
   End
End
Attribute VB_Name = "FrmCfg"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public Sub OpenConfiguration()
    Show vbModal
End Sub

Private Sub CmdCancel_Click()
    Unload Me
End Sub

Private Sub cmdOK_Click()
    CurrDTD = ComboDTD.Text
    Unload Me
End Sub

Private Sub DTDChanged()
    TXTDOCTYPE.Text = DTDs(CurrDTD).DocTypeName
    TxtDTDFile.Text = DTDs(CurrDTD).DTDFile
    TxtPFTFile.Text = DTDs(CurrDTD).PFTFile
    TxtReportPFTFile.Text = DTDs(CurrDTD).ReportPFTFile
    'TxtReportFileExtension.Text = DTDs(CurrDTD).ReportFileExtension
    TxtSGM2ASC.Text = DTDs(CurrDTD).SGM2ASC
    TxtGRK2SGM.Text = DTDs(CurrDTD).RECOVER_REPLACESYMBOL
    TxtASC2SGM.Text = DTDs(CurrDTD).ASC2SGM
    'TxtValidRecords.Text = DTDs(CurrDTD).ValidRecords
    'TxtRecordIdField.Text = DTDs(CurrDTD).RecIdField
    'TxtFilenamePFT.Text = DTDs(CurrDTD).FileNamePft
    'TxtCiparFile.Text = DTDs(CurrDTD).CreateCipFile
End Sub
Private Sub ComboDTD_Change()
    DTDChanged
End Sub
Private Sub ComboDTD_Click()
    DTDChanged
End Sub

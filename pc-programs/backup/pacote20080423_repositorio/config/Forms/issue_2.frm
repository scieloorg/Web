VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "Tabctl32.ocx"
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "Comctl32.ocx"
Begin VB.Form Issue2 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Issue"
   ClientHeight    =   5700
   ClientLeft      =   1560
   ClientTop       =   2100
   ClientWidth     =   9060
   Icon            =   "issue_2.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   5700
   ScaleWidth      =   9060
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton CmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   6960
      TabIndex        =   41
      Top             =   5280
      Width           =   855
   End
   Begin VB.CommandButton FormCmdSave 
      Caption         =   "Save"
      Height          =   375
      Left            =   5880
      TabIndex        =   40
      Top             =   5280
      Width           =   855
   End
   Begin VB.CommandButton FormCmdAju 
      Caption         =   "Help"
      Height          =   375
      Left            =   8040
      TabIndex        =   42
      Top             =   5280
      Width           =   855
   End
   Begin TabDlg.SSTab SSTab1 
      Height          =   5055
      Left            =   120
      TabIndex        =   43
      Top             =   120
      Width           =   8895
      _ExtentX        =   15690
      _ExtentY        =   8916
      _Version        =   393216
      Tabs            =   4
      Tab             =   3
      TabsPerRow      =   4
      TabHeight       =   520
      TabCaption(0)   =   "General"
      TabPicture(0)   =   "issue_2.frx":030A
      Tab(0).ControlEnabled=   0   'False
      Tab(0).Control(0)=   "FramFasc2(0)"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).ControlCount=   1
      TabCaption(1)   =   "Bibliographic Strip"
      TabPicture(1)   =   "issue_2.frx":0326
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "FramLeg"
      Tab(1).ControlCount=   1
      TabCaption(2)   =   "Table of Contents"
      TabPicture(2)   =   "issue_2.frx":0342
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "Frame1"
      Tab(2).ControlCount=   1
      TabCaption(3)   =   "Settings"
      TabPicture(3)   =   "issue_2.frx":035E
      Tab(3).ControlEnabled=   -1  'True
      Tab(3).Control(0)=   "FrameCreativeCommons"
      Tab(3).Control(0).Enabled=   0   'False
      Tab(3).ControlCount=   1
      Begin VB.Frame FrameCreativeCommons 
         Caption         =   "Creative Commons"
         Height          =   4455
         Left            =   120
         TabIndex        =   100
         Top             =   480
         Width           =   8535
         Begin VB.TextBox TextCreativeCommons 
            Height          =   975
            Index           =   2
            Left            =   1560
            MultiLine       =   -1  'True
            TabIndex        =   104
            Text            =   "issue_2.frx":037A
            Top             =   3120
            Width           =   6855
         End
         Begin VB.TextBox TextCreativeCommons 
            Height          =   975
            Index           =   1
            Left            =   1560
            MultiLine       =   -1  'True
            TabIndex        =   103
            Text            =   "issue_2.frx":047C
            Top             =   2040
            Width           =   6855
         End
         Begin VB.TextBox TextCreativeCommons 
            Height          =   975
            Index           =   0
            Left            =   1560
            MultiLine       =   -1  'True
            TabIndex        =   101
            Text            =   "issue_2.frx":057E
            Top             =   960
            Width           =   6855
         End
         Begin VB.Label Label10 
            Caption         =   "Espanhol"
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   107
            Top             =   3120
            Width           =   1335
         End
         Begin VB.Label Label10 
            Caption         =   "Português"
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   106
            Top             =   2040
            Width           =   1335
         End
         Begin VB.Label Label10 
            Caption         =   "Inglês"
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   105
            Top             =   960
            Width           =   1335
         End
         Begin VB.Label LabelCreativeCommonsInstructions 
            Caption         =   "LabelCreativeCommonsInstructions"
            Height          =   375
            Left            =   120
            TabIndex        =   102
            Top             =   360
            Width           =   8295
         End
      End
      Begin VB.Frame FramFasc2 
         Height          =   4575
         Index           =   0
         Left            =   -74880
         TabIndex        =   74
         Top             =   360
         Width           =   8535
         Begin VB.ListBox ListScheme 
            Height          =   960
            Left            =   6120
            Style           =   1  'Checkbox
            TabIndex        =   99
            Top             =   3360
            Width           =   2295
         End
         Begin VB.TextBox TxtIssTitle 
            Height          =   285
            Index           =   2
            Left            =   1440
            TabIndex        =   95
            Top             =   1560
            Width           =   4095
         End
         Begin VB.TextBox TxtIssTitle 
            Height          =   285
            Index           =   1
            Left            =   1440
            TabIndex        =   94
            Top             =   1200
            Width           =   4095
         End
         Begin VB.CheckBox MkpCheck 
            Caption         =   "Ready to the Local Site"
            Height          =   495
            Left            =   6120
            TabIndex        =   9
            Top             =   2520
            Width           =   2055
         End
         Begin VB.ComboBox ComboStandard 
            Height          =   315
            Left            =   240
            TabIndex        =   8
            Top             =   4080
            Width           =   5295
         End
         Begin VB.TextBox TxtIssSponsor 
            Height          =   285
            Left            =   240
            TabIndex        =   7
            Top             =   3360
            Width           =   5295
         End
         Begin VB.TextBox TxtIssTitle 
            Height          =   285
            Index           =   3
            Left            =   1440
            TabIndex        =   3
            Top             =   1920
            Width           =   4095
         End
         Begin VB.TextBox TxtIssPublisher 
            Height          =   285
            Left            =   240
            TabIndex        =   5
            Top             =   2640
            Width           =   5295
         End
         Begin VB.TextBox TxtIssuept 
            Height          =   285
            Left            =   6360
            TabIndex        =   4
            Top             =   1200
            Width           =   1935
         End
         Begin VB.TextBox TxtCover 
            Height          =   285
            Left            =   6360
            TabIndex        =   6
            Top             =   1920
            Width           =   1935
         End
         Begin VB.TextBox TxtDateIso 
            Height          =   285
            Left            =   6360
            TabIndex        =   2
            Text            =   "9999"
            Top             =   480
            Width           =   1935
         End
         Begin VB.TextBox TxtDoccount 
            Height          =   285
            Left            =   3840
            TabIndex        =   1
            Top             =   480
            Width           =   1695
         End
         Begin VB.ComboBox ComboStatus 
            Height          =   315
            Left            =   240
            TabIndex        =   0
            Text            =   "ComboStatus"
            Top             =   480
            Width           =   3375
         End
         Begin VB.Label LabIdiom2 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Portuguese"
            Height          =   195
            Index           =   1
            Left            =   600
            TabIndex        =   98
            Top             =   1200
            Width           =   810
         End
         Begin VB.Label LabIdiom2 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Spanish"
            Height          =   195
            Index           =   2
            Left            =   840
            TabIndex        =   97
            Top             =   1560
            Width           =   570
         End
         Begin VB.Label LabIdiom2 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "English"
            Height          =   195
            Index           =   3
            Left            =   840
            TabIndex        =   96
            Top             =   1920
            Width           =   510
         End
         Begin VB.Label LabScheme 
            AutoSize        =   -1  'True
            Caption         =   "Scheme"
            Height          =   195
            Left            =   6120
            TabIndex        =   88
            Top             =   3120
            Width           =   1665
         End
         Begin VB.Label LabStandard 
            AutoSize        =   -1  'True
            Caption         =   "Standard"
            Height          =   195
            Left            =   240
            TabIndex        =   87
            Top             =   3840
            Width           =   645
         End
         Begin VB.Label LabIssSponsor 
            AutoSize        =   -1  'True
            Caption         =   "Sponsor"
            Height          =   195
            Left            =   240
            TabIndex        =   82
            Top             =   3120
            Width           =   585
         End
         Begin VB.Label LabFascTitulo 
            AutoSize        =   -1  'True
            Caption         =   "Title"
            Height          =   195
            Left            =   240
            TabIndex        =   81
            Top             =   960
            Width           =   300
         End
         Begin VB.Label LabEditorEspecial 
            AutoSize        =   -1  'True
            Caption         =   "Editor"
            Height          =   195
            Left            =   240
            TabIndex        =   80
            Top             =   2400
            Width           =   405
         End
         Begin VB.Label LabParte 
            AutoSize        =   -1  'True
            Caption         =   "Part"
            Height          =   195
            Left            =   6360
            TabIndex        =   79
            Top             =   960
            Width           =   285
         End
         Begin VB.Label LabFigCapa 
            AutoSize        =   -1  'True
            Caption         =   "Cover picture"
            Height          =   195
            Left            =   6360
            TabIndex        =   78
            Top             =   1680
            Width           =   945
         End
         Begin VB.Label LabDataIso 
            AutoSize        =   -1  'True
            Caption         =   "Date ISO"
            Height          =   195
            Left            =   6360
            TabIndex        =   77
            Top             =   240
            Width           =   660
         End
         Begin VB.Label LabQtdDoc 
            AutoSize        =   -1  'True
            Caption         =   "Number of Documents"
            Height          =   195
            Left            =   3840
            TabIndex        =   76
            Top             =   240
            Width           =   1590
         End
         Begin VB.Label LabStatus 
            AutoSize        =   -1  'True
            Caption         =   "Status"
            Height          =   195
            Left            =   240
            TabIndex        =   75
            Top             =   240
            Width           =   450
         End
      End
      Begin VB.Frame FramLeg 
         Height          =   3495
         Left            =   -74880
         TabIndex        =   46
         Top             =   480
         Width           =   8535
         Begin VB.Frame Legend 
            Caption         =   "Idioma 1:"
            Height          =   975
            Index           =   1
            Left            =   120
            TabIndex        =   65
            Top             =   240
            Width           =   8295
            Begin VB.TextBox TxtAno 
               Height          =   285
               Index           =   1
               Left            =   7560
               Locked          =   -1  'True
               TabIndex        =   17
               Text            =   " "
               Top             =   600
               Width           =   615
            End
            Begin VB.TextBox TxtMes 
               Height          =   285
               Index           =   1
               Left            =   6600
               TabIndex        =   16
               Text            =   " "
               Top             =   600
               Width           =   975
            End
            Begin VB.TextBox TxtLoc 
               Height          =   285
               Index           =   1
               Left            =   5400
               TabIndex        =   15
               Text            =   " "
               Top             =   600
               Width           =   1215
            End
            Begin VB.TextBox TxtNro 
               Height          =   285
               Index           =   1
               Left            =   3960
               TabIndex        =   13
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtVol 
               Height          =   285
               Index           =   1
               Left            =   2520
               TabIndex        =   11
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtTitAbr 
               Height          =   285
               Index           =   1
               Left            =   120
               TabIndex        =   10
               Text            =   " "
               Top             =   600
               Width           =   2415
            End
            Begin VB.TextBox TxtSupplNro 
               Height          =   285
               Index           =   1
               Left            =   4680
               TabIndex        =   14
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtSupplVol 
               Height          =   285
               Index           =   1
               Left            =   3240
               TabIndex        =   12
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.Label Label1 
               AutoSize        =   -1  'True
               Caption         =   "Short Title"
               Height          =   195
               Index           =   1
               Left            =   120
               TabIndex        =   73
               Top             =   360
               Width           =   720
            End
            Begin VB.Label Label2 
               AutoSize        =   -1  'True
               Caption         =   "Vol"
               Height          =   195
               Index           =   1
               Left            =   2520
               TabIndex        =   72
               Top             =   360
               Width           =   225
            End
            Begin VB.Label Label3 
               AutoSize        =   -1  'True
               Caption         =   "Num"
               Height          =   195
               Index           =   1
               Left            =   3960
               TabIndex        =   71
               Top             =   360
               Width           =   330
            End
            Begin VB.Label Label4 
               AutoSize        =   -1  'True
               Caption         =   "Vol Sup"
               Height          =   195
               Index           =   1
               Left            =   3240
               TabIndex        =   70
               Top             =   360
               Width           =   555
            End
            Begin VB.Label Label5 
               AutoSize        =   -1  'True
               Caption         =   "NumSup"
               Height          =   195
               Index           =   1
               Left            =   4680
               TabIndex        =   69
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label6 
               AutoSize        =   -1  'True
               Caption         =   "City"
               Height          =   195
               Index           =   1
               Left            =   5520
               TabIndex        =   68
               Top             =   360
               Width           =   255
            End
            Begin VB.Label Label7 
               AutoSize        =   -1  'True
               Caption         =   "Month"
               Height          =   195
               Index           =   1
               Left            =   6600
               TabIndex        =   67
               Top             =   360
               Width           =   450
            End
            Begin VB.Label Label8 
               AutoSize        =   -1  'True
               Caption         =   "Year"
               Height          =   195
               Index           =   1
               Left            =   7560
               TabIndex        =   66
               Top             =   360
               Width           =   330
            End
         End
         Begin VB.Frame Legend 
            Caption         =   "Idioma 1:"
            Height          =   975
            Index           =   2
            Left            =   120
            TabIndex        =   56
            Top             =   1320
            Width           =   8295
            Begin VB.TextBox TxtAno 
               Height          =   285
               Index           =   2
               Left            =   7560
               Locked          =   -1  'True
               TabIndex        =   25
               Text            =   " "
               Top             =   600
               Width           =   615
            End
            Begin VB.TextBox TxtMes 
               Height          =   285
               Index           =   2
               Left            =   6600
               TabIndex        =   24
               Text            =   " "
               Top             =   600
               Width           =   975
            End
            Begin VB.TextBox TxtLoc 
               Height          =   285
               Index           =   2
               Left            =   5400
               TabIndex        =   23
               Text            =   " "
               Top             =   600
               Width           =   1215
            End
            Begin VB.TextBox TxtNro 
               Height          =   285
               Index           =   2
               Left            =   3960
               TabIndex        =   21
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtVol 
               Height          =   285
               Index           =   2
               Left            =   2520
               TabIndex        =   19
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtTitAbr 
               Height          =   285
               Index           =   2
               Left            =   120
               TabIndex        =   18
               Text            =   " "
               Top             =   600
               Width           =   2415
            End
            Begin VB.TextBox TxtSupplNro 
               Height          =   285
               Index           =   2
               Left            =   4680
               TabIndex        =   22
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtSupplVol 
               Height          =   285
               Index           =   2
               Left            =   3240
               TabIndex        =   20
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.Label Label1 
               AutoSize        =   -1  'True
               Caption         =   "Short Title"
               Height          =   195
               Index           =   2
               Left            =   120
               TabIndex        =   64
               Top             =   360
               Width           =   720
            End
            Begin VB.Label Label2 
               AutoSize        =   -1  'True
               Caption         =   "Vol"
               Height          =   195
               Index           =   2
               Left            =   2520
               TabIndex        =   63
               Top             =   360
               Width           =   225
            End
            Begin VB.Label Label3 
               AutoSize        =   -1  'True
               Caption         =   "Num"
               Height          =   195
               Index           =   2
               Left            =   3960
               TabIndex        =   62
               Top             =   360
               Width           =   330
            End
            Begin VB.Label Label4 
               AutoSize        =   -1  'True
               Caption         =   "Vol Sup"
               Height          =   195
               Index           =   2
               Left            =   3240
               TabIndex        =   61
               Top             =   360
               Width           =   555
            End
            Begin VB.Label Label5 
               AutoSize        =   -1  'True
               Caption         =   "NumSup"
               Height          =   195
               Index           =   2
               Left            =   4680
               TabIndex        =   60
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label6 
               AutoSize        =   -1  'True
               Caption         =   "City"
               Height          =   195
               Index           =   2
               Left            =   5520
               TabIndex        =   59
               Top             =   360
               Width           =   255
            End
            Begin VB.Label Label7 
               AutoSize        =   -1  'True
               Caption         =   "Month"
               Height          =   195
               Index           =   2
               Left            =   6600
               TabIndex        =   58
               Top             =   360
               Width           =   450
            End
            Begin VB.Label Label8 
               AutoSize        =   -1  'True
               Caption         =   "Year"
               Height          =   195
               Index           =   2
               Left            =   7560
               TabIndex        =   57
               Top             =   360
               Width           =   330
            End
         End
         Begin VB.Frame Legend 
            Caption         =   "Idioma 1:"
            Height          =   975
            Index           =   3
            Left            =   120
            TabIndex        =   47
            Top             =   2400
            Width           =   8295
            Begin VB.TextBox TxtAno 
               Height          =   285
               Index           =   3
               Left            =   7560
               Locked          =   -1  'True
               TabIndex        =   33
               Text            =   " "
               Top             =   600
               Width           =   615
            End
            Begin VB.TextBox TxtMes 
               Height          =   285
               Index           =   3
               Left            =   6600
               TabIndex        =   32
               Text            =   " "
               Top             =   600
               Width           =   975
            End
            Begin VB.TextBox TxtLoc 
               Height          =   285
               Index           =   3
               Left            =   5400
               TabIndex        =   31
               Text            =   " "
               Top             =   600
               Width           =   1215
            End
            Begin VB.TextBox TxtNro 
               Height          =   285
               Index           =   3
               Left            =   3960
               TabIndex        =   29
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtVol 
               Height          =   285
               Index           =   3
               Left            =   2520
               TabIndex        =   27
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtTitAbr 
               Height          =   285
               Index           =   3
               Left            =   120
               TabIndex        =   26
               Text            =   " "
               Top             =   600
               Width           =   2415
            End
            Begin VB.TextBox TxtSupplNro 
               Height          =   285
               Index           =   3
               Left            =   4680
               TabIndex        =   30
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.TextBox TxtSupplVol 
               Height          =   285
               Index           =   3
               Left            =   3240
               TabIndex        =   28
               Text            =   " "
               Top             =   600
               Width           =   735
            End
            Begin VB.Label Label1 
               AutoSize        =   -1  'True
               Caption         =   "Short Title"
               Height          =   195
               Index           =   3
               Left            =   120
               TabIndex        =   55
               Top             =   360
               Width           =   720
            End
            Begin VB.Label Label2 
               AutoSize        =   -1  'True
               Caption         =   "Vol"
               Height          =   195
               Index           =   3
               Left            =   2520
               TabIndex        =   54
               Top             =   360
               Width           =   225
            End
            Begin VB.Label Label3 
               AutoSize        =   -1  'True
               Caption         =   "Num"
               Height          =   195
               Index           =   3
               Left            =   3960
               TabIndex        =   53
               Top             =   360
               Width           =   330
            End
            Begin VB.Label Label4 
               AutoSize        =   -1  'True
               Caption         =   "Vol Sup"
               Height          =   195
               Index           =   3
               Left            =   3240
               TabIndex        =   52
               Top             =   360
               Width           =   555
            End
            Begin VB.Label Label5 
               AutoSize        =   -1  'True
               Caption         =   "NumSup"
               Height          =   195
               Index           =   3
               Left            =   4680
               TabIndex        =   51
               Top             =   360
               Width           =   615
            End
            Begin VB.Label Label6 
               AutoSize        =   -1  'True
               Caption         =   "City"
               Height          =   195
               Index           =   3
               Left            =   5520
               TabIndex        =   50
               Top             =   360
               Width           =   255
            End
            Begin VB.Label Label7 
               AutoSize        =   -1  'True
               Caption         =   "Month"
               Height          =   195
               Index           =   3
               Left            =   6600
               TabIndex        =   49
               Top             =   360
               Width           =   450
            End
            Begin VB.Label Label8 
               AutoSize        =   -1  'True
               Caption         =   "Year"
               Height          =   195
               Index           =   3
               Left            =   7560
               TabIndex        =   48
               Top             =   360
               Width           =   330
            End
         End
      End
      Begin VB.Frame Frame1 
         Height          =   4575
         Left            =   -74880
         TabIndex        =   44
         Top             =   360
         Width           =   8655
         Begin VB.ListBox DispoSecCode 
            Height          =   645
            Left            =   6600
            MultiSelect     =   2  'Extended
            Sorted          =   -1  'True
            TabIndex        =   93
            Top             =   960
            Visible         =   0   'False
            Width           =   1935
         End
         Begin VB.ListBox ListSortedSections 
            Height          =   255
            Left            =   7200
            Sorted          =   -1  'True
            TabIndex        =   91
            Top             =   1200
            Visible         =   0   'False
            Width           =   1095
         End
         Begin ComctlLib.ListView lvSortedSections 
            Height          =   255
            Left            =   6600
            TabIndex        =   90
            Top             =   1200
            Visible         =   0   'False
            Width           =   495
            _ExtentX        =   873
            _ExtentY        =   450
            View            =   3
            LabelWrap       =   -1  'True
            HideSelection   =   -1  'True
            _Version        =   327682
            ForeColor       =   -2147483640
            BackColor       =   -2147483643
            BorderStyle     =   1
            Appearance      =   1
            NumItems        =   4
            BeginProperty ColumnHeader(1) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
               Key             =   ""
               Object.Tag             =   ""
               Text            =   "Seccode"
               Object.Width           =   2540
            EndProperty
            BeginProperty ColumnHeader(2) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
               SubItemIndex    =   1
               Key             =   ""
               Object.Tag             =   ""
               Text            =   "idiom1"
               Object.Width           =   2540
            EndProperty
            BeginProperty ColumnHeader(3) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
               SubItemIndex    =   2
               Key             =   ""
               Object.Tag             =   ""
               Text            =   "idiom2"
               Object.Width           =   2540
            EndProperty
            BeginProperty ColumnHeader(4) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
               SubItemIndex    =   3
               Key             =   ""
               Object.Tag             =   ""
               Text            =   "idiom3"
               Object.Width           =   2540
            EndProperty
         End
         Begin ComctlLib.ListView DispoSections 
            Height          =   255
            Left            =   6600
            TabIndex        =   89
            Top             =   960
            Visible         =   0   'False
            Width           =   1575
            _ExtentX        =   2778
            _ExtentY        =   450
            View            =   3
            Sorted          =   -1  'True
            LabelWrap       =   -1  'True
            HideSelection   =   -1  'True
            _Version        =   327682
            ForeColor       =   -2147483640
            BackColor       =   -2147483643
            BorderStyle     =   1
            Appearance      =   1
            NumItems        =   4
            BeginProperty ColumnHeader(1) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
               Key             =   ""
               Object.Tag             =   ""
               Text            =   "code"
               Object.Width           =   2540
            EndProperty
            BeginProperty ColumnHeader(2) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
               SubItemIndex    =   1
               Key             =   ""
               Object.Tag             =   ""
               Text            =   "idiom1"
               Object.Width           =   2540
            EndProperty
            BeginProperty ColumnHeader(3) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
               SubItemIndex    =   2
               Key             =   ""
               Object.Tag             =   ""
               Text            =   "idiom2"
               Object.Width           =   2540
            EndProperty
            BeginProperty ColumnHeader(4) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
               SubItemIndex    =   3
               Key             =   ""
               Object.Tag             =   ""
               Text            =   "idiom3"
               Object.Width           =   2540
            EndProperty
         End
         Begin VB.Frame Frame2 
            Caption         =   "Sections of "
            Height          =   2655
            Left            =   120
            TabIndex        =   83
            Top             =   1800
            Width           =   8415
            Begin ComctlLib.ListView LVSections 
               Height          =   1695
               Left            =   120
               TabIndex        =   39
               Top             =   840
               Width           =   8175
               _ExtentX        =   14420
               _ExtentY        =   2990
               View            =   3
               LabelWrap       =   -1  'True
               HideSelection   =   -1  'True
               _Version        =   327682
               ForeColor       =   -2147483640
               BackColor       =   -2147483643
               BorderStyle     =   1
               Appearance      =   1
               NumItems        =   4
               BeginProperty ColumnHeader(1) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
                  Key             =   ""
                  Object.Tag             =   ""
                  Text            =   "Seccode"
                  Object.Width           =   2540
               EndProperty
               BeginProperty ColumnHeader(2) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
                  SubItemIndex    =   1
                  Key             =   ""
                  Object.Tag             =   ""
                  Text            =   "idiom1"
                  Object.Width           =   2540
               EndProperty
               BeginProperty ColumnHeader(3) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
                  SubItemIndex    =   2
                  Key             =   ""
                  Object.Tag             =   ""
                  Text            =   "idiom2"
                  Object.Width           =   2540
               EndProperty
               BeginProperty ColumnHeader(4) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
                  SubItemIndex    =   3
                  Key             =   ""
                  Object.Tag             =   ""
                  Text            =   "idiom3"
                  Object.Width           =   2540
               EndProperty
            End
            Begin VB.TextBox TxtHeader 
               BackColor       =   &H00FFFFFF&
               Height          =   285
               Index           =   3
               Left            =   5640
               TabIndex        =   38
               Top             =   480
               Width           =   2655
            End
            Begin VB.TextBox TxtHeader 
               BackColor       =   &H00FFFFFF&
               DataField       =   "TxtHeader"
               Height          =   285
               Index           =   2
               Left            =   2880
               TabIndex        =   37
               Top             =   480
               Width           =   2655
            End
            Begin VB.TextBox TxtHeader 
               BackColor       =   &H00FFFFFF&
               Height          =   285
               Index           =   1
               Left            =   120
               TabIndex        =   36
               Top             =   480
               Width           =   2655
            End
            Begin VB.Label LabIdiom 
               AutoSize        =   -1  'True
               Caption         =   "English"
               Height          =   195
               Index           =   3
               Left            =   5640
               TabIndex        =   86
               Top             =   240
               Width           =   510
            End
            Begin VB.Label LabIdiom 
               AutoSize        =   -1  'True
               Caption         =   "Spanish"
               Height          =   195
               Index           =   1
               Left            =   120
               TabIndex        =   85
               Top             =   240
               Width           =   570
            End
            Begin VB.Label LabIdiom 
               AutoSize        =   -1  'True
               Caption         =   "Portuguese"
               Height          =   195
               Index           =   2
               Left            =   2880
               TabIndex        =   84
               Top             =   240
               Width           =   810
            End
         End
         Begin VB.ListBox DispoSecTitle 
            Height          =   1185
            Left            =   120
            Sorted          =   -1  'True
            Style           =   1  'Checkbox
            TabIndex        =   34
            Top             =   480
            Width           =   6375
         End
         Begin VB.CommandButton CmdNewSections 
            Caption         =   "Create section"
            Height          =   375
            Left            =   6840
            TabIndex        =   35
            Top             =   480
            Width           =   1575
         End
         Begin VB.Label Label9 
            AutoSize        =   -1  'True
            Caption         =   "Select the sections that are present in "
            Height          =   195
            Left            =   120
            TabIndex        =   45
            Top             =   240
            Width           =   2715
         End
      End
   End
   Begin VB.Label LabIndicationMandatoryField 
      Caption         =   "Label1"
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   240
      TabIndex        =   92
      Top             =   5280
      Width           =   3735
   End
End
Attribute VB_Name = "Issue2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private NormalHeight As Long
Private NormalWidth As Long

Private OldHeight As Long
Private OldWidth As Long

Private currDate As String

Private MfnSection As Long
Private MfnIssue As Long
Private CurrMonth As String

Private Const MaxLenSectitle = 500

Public Sub LoadIssue(Mfn As Long)
    Dim i As Long
    
    MfnIssue = Mfn
    
    With Fields
    Caption = App.Title + " - " + ISSUE_FORM_CAPTION + Issue1.TxtSerTitle.Caption
    For i = 1 To IdiomsInfo.count
        Label1(i).Caption = .Fields("ser1_ShortTitle").GetLabel
        Label2(i).Caption = .Fields("Volume").GetLabel
        Label3(i).Caption = .Fields("Issueno").GetLabel
        Label4(i).Caption = .Fields("VolSuppl").GetLabel
        Label5(i).Caption = .Fields("IssueSuppl").GetLabel
        Label6(i).Caption = .Fields("Issue_Place").GetLabel
        Label7(i).Caption = .Fields("Issue_month").GetLabel
        Label8(i).Caption = .Fields("Issue_year").GetLabel
        
    Next
    LabStatus.Caption = .Fields("Issue_status").GetLabel
    LabFascTitulo.Caption = .Fields("Issue_IssTitle").GetLabel
    LabEditorEspecial.Caption = .Fields("Issue_IssPublisher").GetLabel
    LabFigCapa.Caption = .Fields("Issue_Cover").GetLabel
    LabDataIso.Caption = .Fields("Issue_DateISO").GetLabel
    LabIssSponsor.Caption = .Fields("Issue_Sponsor").GetLabel
    LabParte.Caption = .Fields("Issue_Part").GetLabel
    LabQtdDoc.Caption = .Fields("Issue_NumberofDocuments").GetLabel
    LabScheme.Caption = .Fields("Issue_Scheme").GetLabel
    LabStandard.Caption = .Fields("Issue_Standard").GetLabel
    MkpCheck.Caption = .Fields("Issue_MkpDone").GetLabel
    LabelCreativeCommonsInstructions.Caption = .Fields("issue_creativecommons").GetLabel
    End With
    
    With ConfigLabels
    LabIndicationMandatoryField.Caption = .MandatoryFieldIndication
    SSTab1.TabCaption(0) = .Issue_General
    SSTab1.TabCaption(1) = .Issue_BibliographicStrip
    SSTab1.TabCaption(2) = .Issue_Tableofcontents
    SSTab1.TabCaption(3) = .Issue_TabConfigurations
    
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
    Call FillList(ListScheme, CodeScheme)
    
    LoadGeneral (Mfn)
    LoadLegend (Mfn)
    
    LoadDispoSections
    Label9.Caption = Label9.Caption + " " + Caption
    Frame2.Caption = Frame2.Caption + " " + Caption
    LoadIssueSections (Mfn)

    OldHeight = Height
    OldWidth = Width
    NormalHeight = Height
    NormalWidth = Width
    
    Show vbModal
    
End Sub


Private Sub IdiomLoad()
    Dim i As Long
    
    For i = 1 To IdiomsInfo.count
        LabIdiom(i).Caption = IdiomsInfo(i).label  '990316
        Legend(i).Caption = IdiomsInfo(i).label
        LabIdiom2(i).Caption = IdiomsInfo(i).label
    Next
End Sub


Private Sub LoadGeneral(MfnIssue As Long)
    Dim i As Long
    Dim hasIssTitle As Long
    
    With BDIssues
    If MfnIssue > 0 Then
    
        TxtDoccount.text = Issue_TxtContent(MfnIssue, 122)
        currDate = Issue_TxtContent(MfnIssue, 65)
        TxtDateIso.text = currDate
        
        TxtIssuept.text = Issue_TxtContent(MfnIssue, 34)
        TxtIssSponsor.text = Issue_TxtContent(MfnIssue, 140)
        
        
        For i = 1 To IdiomsInfo.count
            TxtIssTitle(i).text = Issue_TxtContent(MfnIssue, 33, "^*", IdiomsInfo(i).Code)
            hasIssTitle = hasIssTitle + Len(TxtIssTitle(i).text)
        Next
        If hasIssTitle = 0 Then
            For i = 1 To IdiomsInfo.count
                TxtIssTitle(i).text = Issue_TxtContent(MfnIssue, 33)
            Next
        End If

        
        TxtIssPublisher.text = Issue_TxtContent(MfnIssue, 62)
        TxtCover.text = Issue_TxtContent(MfnIssue, 97)
        
        MkpCheck.value = Str2Int(Issue_TxtContent(MfnIssue, 200))
        
        ComboStatus.text = Issue_ComboContent(CodeIssStatus, MfnIssue, 42)
        
        ComboStandard.text = Issue_ComboContent(CodeStandard, MfnIssue, 117)
        If Len(ComboStandard.text) = 0 Then ComboStandard.text = Issue1.Title_Standard
        
        Call Issue_ListContent(ListScheme, CodeScheme, MfnIssue, 85)
                
                
        For i = 1 To IdiomsInfo.count
            Label10(i - 1).Caption = IdiomsInfo(i).label
            TextCreativeCommons(i - 1).text = Issue_TxtContent(MfnIssue, 540, "^t", IdiomsInfo(i).Code)
        Next

        
    Else
        TxtDoccount.text = ""
        TxtDateIso.text = Issue1.Year
        TxtIssuept.text = ""
        TxtIssSponsor.text = ""
        For i = 1 To IdiomsInfo.count
            TxtIssTitle(i).text = ""
        Next
        TxtIssPublisher.text = ""
        TxtCover.text = ""
        MkpCheck.value = 0
        ComboStandard.text = Issue1.Title_Standard
        'Call UnselectList(ListScheme)
        For i = 0 To Issue1.ListScheme.ListCount - 1
            ListScheme.Selected(i) = Issue1.ListScheme.Selected(i)
        Next
        TextCreativeCommons(0).text = ""
        TextCreativeCommons(1).text = ""
        TextCreativeCommons(2).text = ""

    End If
    End With
End Sub

Private Sub LoadLegend(MfnIssue As Long)
    Dim idiomidx As Long
    Dim Year As String
    Dim month As String
    
    'If CheckDateISO(TxtDateIso.Text) Then
    '    year = Mid(TxtDateIso.Text, 1, 4)
    '    MONTH = Mid(TxtDateIso.Text, 5, 2)
    'End If
    
    With BDIssues
        
    For idiomidx = 1 To IdiomsInfo.count
        Legend(idiomidx).Caption = IdiomsInfo(idiomidx).label
        
        TxtTitAbr(idiomidx).text = Issue_TxtContent(MfnIssue, 43, "^t", IdiomsInfo(idiomidx).Code)
        If Len(TxtTitAbr(idiomidx).text) = 0 Then
            TxtTitAbr(idiomidx).text = Issue1.TxtStitle.Caption
        End If

        TxtVol(idiomidx).text = Issue_TxtContent(MfnIssue, 43, "^v", IdiomsInfo(idiomidx).Code)
        If Len(TxtVol(idiomidx).text) = 0 Then
            If Len(Issue1.TxtVolid.text) > 0 Then
                If IdiomsInfo(idiomidx).Code = "en" Then
                    TxtVol(idiomidx).text = "vol." + Issue1.TxtVolid.text
                Else
                    TxtVol(idiomidx).text = "v." + Issue1.TxtVolid.text
                End If
            Else
                TxtVol(idiomidx).text = ""
            End If
        End If

        TxtNro(idiomidx).text = Issue_TxtContent(MfnIssue, 43, "^n", IdiomsInfo(idiomidx).Code)
        If Len(TxtNro(idiomidx).text) = 0 Then
            If Len(Issue1.TxtIssueno.text) > 0 Then
              If IdiomsInfo(idiomidx).Code = "en" Then
                  TxtNro(idiomidx).text = "no." + Issue1.TxtIssueno.text
              Else
                  TxtNro(idiomidx).text = "n." + Issue1.TxtIssueno.text
              End If
            Else
                TxtNro(idiomidx).text = ""
            End If
        End If
            
        TxtSupplVol(idiomidx).text = Issue_TxtContent(MfnIssue, 43, "^w", IdiomsInfo(idiomidx).Code)
        If Len(TxtSupplVol(idiomidx).text) = 0 Then
            If Len(Issue1.TxtSupplVol.text) > 0 Then
                If IdiomsInfo(idiomidx).Code = "en" Then
                    TxtSupplVol(idiomidx).text = "suppl." + Issue1.TxtSupplVol.text
                Else
                    TxtSupplVol(idiomidx).text = "supl." + Issue1.TxtSupplVol.text
                End If
            Else
                TxtSupplVol(idiomidx).text = ""
            End If
        End If
            
        TxtSupplNro(idiomidx).text = Issue_TxtContent(MfnIssue, 43, "^s", IdiomsInfo(idiomidx).Code)
        If Len(TxtSupplNro(idiomidx).text) = 0 Then
            If Len(Issue1.TxtSupplNo.text) > 0 Then
                If IdiomsInfo(idiomidx).Code = "en" Then
                    TxtSupplNro(idiomidx).text = "suppl." + Issue1.TxtSupplNo.text
                Else
                    TxtSupplNro(idiomidx).text = "supl." + Issue1.TxtSupplNo.text
                End If
            Else
                TxtSupplNro(idiomidx).text = ""
            End If
        End If
            
        TxtLoc(idiomidx).text = Issue1.Cidade
                
        
        Caption = TxtTitAbr(idiomidx).text + " " + TxtVol(idiomidx).text + " " + TxtSupplVol(idiomidx).text + " " + TxtNro(idiomidx).text + " " + TxtSupplNro(idiomidx).text
    Next
    
    End With
End Sub

Private Sub LoadDispoSections()
    Dim i As Long
    Dim s As String
    Dim p As Long
    Dim p0 As Long
    Dim j As Long
    Dim k As Long
    Dim found As Long
    Dim section As String
    
    MfnSection = Section_CheckExisting(Issue1.TxtSerTitle.Caption, Issue1.TxtISSN.Caption, Issue1.SiglaPeriodico)
    If MfnSection > 0 Then
        For i = 1 To IdiomsInfo.count
            
            If Len(TxtHeader(i).text) = 0 Then
                TxtHeader(i).text = DBSection.UsePft(MfnSection, "(if v48^l='" + IdiomsInfo(i).Code + "' then v48^h fi)")
            End If
            
            s = DBSection.UsePft(MfnSection, "(if v49^l='" + IdiomsInfo(i).Code + "' then v49^c|-|,v49^t|;| fi)")
            p0 = 1
            p = InStr(s, ";")
            While p > 0
                section = Mid(s, p0, p - p0)
                Call DispoSectionsAddItem(i, section)
                p0 = p + 1
                p = InStr(p0, s, ";", vbBinaryCompare)
            Wend
        Next
        
        'Call DispoSecTitleChecked(section, True)
        
        'DispoSecTitle.Clear
        'For i = 1 To DispoSections.ListItems.Count
        '    j = 0
                        
        '    While (j < IdiomsInfo.Count) And (DispoSecCode.ListCount < i)
        '        j = j + 1
        '        If Len(DispoSections.ListItems(i).SubItems(j)) > 0 Then
        '            k = 0
        '            found = -1
        '            While (k < DispoSecCode.ListCount) And (found < 0)
        '                found = StrComp(DispoSections.ListItems(i).SubItems(j) + "|" + DispoSections.ListItems(i).Text, DispoSecCode.List(k))
        '                k = k + 1
        '            Wend
        '            If found <> 0 Then
        '                DispoSecTitle.AddItem DispoSections.ListItems(i).SubItems(j)
        '                DispoSecCode.AddItem DispoSections.ListItems(i).SubItems(j) + "|" + DispoSections.ListItems(i).Text
        '            End If
        '        End If
        '    Wend
        'Next
    Else
        For i = 1 To IdiomsInfo.count
            TxtHeader(i).text = Section_Header(MfnSection, IdiomsInfo(i).Code)
            LVSections.ColumnHeaders(i + 1).text = IdiomsInfo(i).label
            LVSections.ColumnHeaders(i + 1).Width = LVSections.Width / 5
        Next
    End If
End Sub

Private Sub LoadIssueSections(MfnIssue As Long)
    Dim i As Long
    Dim s As String
    Dim p As Long
    Dim p0 As Long
    Dim section As String
    Dim k As Long
    
    LVSections.ColumnHeaders(1).Width = LVSections.Width / 5
    If MfnIssue > 0 Then
        
        For i = 1 To IdiomsInfo.count
            TxtHeader(i).text = Issue_Header(MfnIssue, IdiomsInfo(i).Code)
            If Len(TxtHeader(i).text) = 0 Then TxtHeader(i).text = Section_Header(MfnSection, IdiomsInfo(i).Code)
            
            LVSections.ColumnHeaders(i + 1).text = IdiomsInfo(i).label
            LVSections.ColumnHeaders(i + 1).Width = LVSections.Width / 5
            
            s = BDIssues.UsePft(MfnIssue, "(if v49^l='" + IdiomsInfo(i).Code + "' then v49^c|-|,v49^t|;| fi)")
            p0 = 1
            p = InStr(s, ";")
            While p > 0
                section = Mid(s, p0, p - p0)
                Call DispoSecTitleChecked(section, True)
                
                p0 = p + 1
                p = InStr(p0, s, ";", vbBinaryCompare)
            Wend
        Next
    Else
        For i = 1 To IdiomsInfo.count
            TxtHeader(i).text = Section_Header(MfnSection, IdiomsInfo(i).Code)
            LVSections.ColumnHeaders(i + 1).text = IdiomsInfo(i).label
            LVSections.ColumnHeaders(i + 1).Width = LVSections.Width / 5
        Next
    End If
End Sub


Private Function Issue_Save() As Boolean
    Dim ToCRecord As String
    Dim LegendRecord As String
    Dim s As String
    
    Dim i As Long
    Dim j As Long
        
        With Issue1
        s = s + TagContent("1", 991)
        s = s + TagContent("0", 700)
        s = s + TagContent("i", 706)
        s = s + TagContent("1", 701)
        s = s + TagContent(getDateIso(Date), 91)
        s = s + TagContent(.TxtSerTitle.Caption, 130)
        s = s + TagContent(.TxtMEDLINEStitle.Caption, 421)
        s = s + TagContent(.TxtISOStitle.Caption, 151)
        s = s + TagTxtContent(.TxtParallel.text, 230)
        
        s = s + TagContent(.TxtISSN.Caption, 35)
        s = s + TagTxtContent(.TxtPubl.text, 480)
        
        s = s + TagContent(.TxtStitle.Caption, 30)
        s = s + TagContent(.TxtVolid.text, 31)
        s = s + TagContent(.TxtSupplVol.text, 131)
        s = s + TagContent(.TxtIssueno.text, 32)
        s = s + TagContent(.TxtSupplNo.text, 132)
        s = s + TagContent(.TxtIseqno.text, 36)
        s = s + TagContent(.SiglaPeriodico, 930)
        
        s = s + TagComboContent(CodeIssStatus, ComboStatus.text, 42)
        s = s + TagComboContent(CodeStandard, ComboStandard.text, 117)
        s = s + TagListContent(CodeScheme, ListScheme, 85)
        s = s + TagContent(Int2Str(MkpCheck.value), 200)
        
        s = s + TagContent(TxtDateIso.text, 65)
        s = s + TagContent(TxtDoccount.text, 122)
        's = s + TagContent(TxtIssTitle.Text, 33)
        s = s + TagContent(TxtIssuept.text, 34)
        
        s = s + TagContent(TxtIssSponsor.text, 140)
        s = s + TagContent(TxtIssPublisher.text, 62)
        s = s + TagContent(TxtCover.text, 97)
        End With
                
        
        For i = 1 To IdiomsInfo.count
            If Len(TxtIssTitle(i).text) > 0 Then s = s + TagTxtContent(TxtIssTitle(i).text + "^l" + IdiomsInfo(i).Code, 33)
            
            ToCRecord = ToCRecord + "<48>^l" + IdiomsInfo(i).Code + "^h" + TxtHeader(i).text + "</48>"
            For j = 1 To LVSections.ListItems.count
                If Len(LVSections.ListItems(j).SubItems(i)) > 0 Then ToCRecord = ToCRecord + "<49>^l" + IdiomsInfo(i).Code + "^c" + LVSections.ListItems(j).text + "^t" + LVSections.ListItems(j).SubItems(i) + "</49>"
            Next
                        
            LegendRecord = LegendRecord + "<43>^l" + IdiomsInfo(i).Code + "^t" + TxtTitAbr(i).text
            If Len(TxtVol(i).text) > 0 Then LegendRecord = LegendRecord + "^v" + TxtVol(i).text
            If Len(TxtSupplVol(i).text) > 0 Then LegendRecord = LegendRecord + "^w" + TxtSupplVol(i).text
            If Len(TxtNro(i).text) > 0 Then LegendRecord = LegendRecord + "^n" + TxtNro(i).text
            If Len(TxtSupplNro(i).text) > 0 Then LegendRecord = LegendRecord + "^s" + TxtSupplNro(i).text
            If Len(TxtLoc(i).text) > 0 Then LegendRecord = LegendRecord + "^c" + TxtLoc(i).text
            If Len(TxtMes(i).text) > 0 Then LegendRecord = LegendRecord + "^m" + TxtMes(i).text
            If Len(TxtAno(i).text) > 0 Then LegendRecord = LegendRecord + "^a" + TxtAno(i).text + "</43>"
        Next
        
        s = s + ToCRecord + LegendRecord
        For i = 1 To IdiomsInfo.count
            s = s + "<540>" + "^t" + TextCreativeCommons(i - 1).text + "^l" + IdiomsInfo(i).Code + "</540>"
        Next
    
        
    If MfnIssue > 0 Then
        If BDIssues.RecordUpdate(MfnIssue, s) Then
            Call BDIssues.IfUpdate(MfnIssue, MfnIssue)
        End If
    Else
        MfnIssue = BDIssues.RecordSave(s)
        If MfnIssue > 0 Then Call BDIssues.IfUpdate(MfnIssue, MfnIssue)
    End If
    
    Issue_Save = True
End Function


Private Sub DispoSectionsAddItem(idiomidx As Long, section As String)
    Dim p As Long
    Dim seccode As String
    Dim sectitle As String
    Dim lvi As ListItem
    
    p = InStr(section, "-")
    If p > 0 Then
        seccode = Mid(section, 1, p - 1)
        sectitle = Mid(section, p + 1)

        Set lvi = DispoSections.FindItem(seccode, lvwText)
        If lvi Is Nothing Then
            Set lvi = DispoSections.ListItems.add(, seccode, seccode)
            DispoSecCode.AddItem (sectitle + Space(MaxLenSectitle - Len(sectitle)) + "|" + seccode)
            DispoSecTitle.AddItem (sectitle)
        End If
        lvi.SubItems(idiomidx) = sectitle
        
    End If
        
End Sub


Private Sub DispoSecTitleChecked(section As String, Flag As Boolean)
    Dim i As Long
    Dim found As Long
    Dim p As Long
    Dim Code As String
    
    p = InStr(section, "-")
    If p > 0 Then
        Code = Mid(section, 1, p - 1)
        section = Mid(section, p + 1)
        found = -1
        While (i < DispoSecCode.ListCount) And (found <> 0)
            found = StrComp(DispoSecCode.list(i), section + Space(MaxLenSectitle - Len(section)) + "|" + Code)
            i = i + 1
        Wend
        Debug.Print section, found
        If found = 0 Then
            DispoSecTitle.Selected(i - 1) = Flag
            DispoSecCode.Selected(i - 1) = Flag
        Else
            'problemas
        End If
    End If
    
End Sub


Private Sub CmdClose_Click()
    Unload Me
End Sub

Private Sub CmdNewSections_Click()
    Call New_Section2.OpenSection(Issue1.TxtSerTitle.Caption, False)
    LoadDispoSections
End Sub

Private Sub DispoSecTitle_Click()
    Dim i As Long
    Dim Code As String
    Dim lvSection As ListItem
    Dim LvDispo As ListItem
    Dim SelectedIdx As Long
    
    SelectedIdx = DispoSecTitle.ListIndex
    DispoSecCode.Selected(SelectedIdx) = DispoSecTitle.Selected(SelectedIdx)
    Code = Mid(DispoSecCode.list(SelectedIdx), InStr(DispoSecCode.list(SelectedIdx), "|") + 1)
        
    If DispoSecTitle.Selected(SelectedIdx) Then
        'add
        Set LvDispo = DispoSections.FindItem(Code, lvwText)
        Set lvSection = LVSections.FindItem(Code, lvwText)
        
        If lvSection Is Nothing Then
            Set lvSection = LVSections.ListItems.add(, Code, Code)
            For i = 1 To IdiomsInfo.count
                lvSection.SubItems(i) = LvDispo.SubItems(i)
            Next
        End If
    Else
        'delete
        Set lvSection = LVSections.FindItem(Code, lvwText)
        If Not (lvSection Is Nothing) Then
            LVSections.ListItems.Remove (lvSection.index)
        End If
    End If
    
End Sub

Private Sub OldDispoSecTitle_Click()
    Dim i As Long
    Dim j As Long
    Dim k As Long
    Dim found As Boolean
    Dim Code As String
    Dim p As Long
    Dim l As ListItem
    Dim SelectedIdx As Long
    
    SelectedIdx = DispoSecTitle.ListIndex
    While (Len(Code) = 0) And (i < IdiomsInfo.count)
        i = i + 1
        j = 0
        While (Len(Code) = 0) And (j < DispoSections.ListItems.count)
            j = j + 1
            If StrComp(DispoSections.ListItems(j).SubItems(i), DispoSecTitle.list(SelectedIdx)) = 0 Then
                Code = DispoSections.ListItems(j).text
                k = DispoSections.ListItems(j).index
            End If
        Wend
    Wend
        
    DispoSecCode.Selected(SelectedIdx) = DispoSecTitle.Selected(SelectedIdx)
    If DispoSecTitle.Selected(SelectedIdx) Then
        'add
        Set l = LVSections.ListItems.add(, Code, Code)
        For i = 1 To IdiomsInfo.count
            l.SubItems(i) = DispoSections.ListItems(k).SubItems(i)
        Next
    Else
        'delete
        Set l = LVSections.FindItem(Code, lvwText)
        If Not (l Is Nothing) Then
            LVSections.ListItems.Remove (l.index)
        End If
    End If
    
End Sub

Private Sub Form_Load()
    SSTab1.Tab = 0
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim res As VbMsgBoxResult
    
    Dim QExit As Boolean
    
    QExit = CheckYears And (Not WarnMandatoryFields)
    
    If Not QExit Then
        If IssueCloseDenied Then
            MsgBox ConfigLabels.MsgUnabledtoClose
        Else
            res = MsgBox(ConfigLabels.MsgExit, vbYesNo + vbDefaultButton2)
            If res = vbYes Then
                QExit = True
            ElseIf res = vbNo Then
                QExit = False
            End If
        End If
    End If
    
    
    If QExit Then
        If Issue_ChangedContents Then
            res = MsgBox(ConfigLabels.MsgSaveChanges, vbYesNoCancel)
            If res = vbYes Then
                Issue_Save
            ElseIf res = vbNo Then
            
            Else
                QExit = False
            End If
        End If
    End If
    
    If QExit Then
        Unload Me
    Else
        Cancel = 1
    End If
End Sub

Private Sub FormCmdAju_Click()
    Call frmFindBrowser.CallBrowser(FormMenuPrin.DirStruct.Nodes("Help of Issue").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Help of Issue").text)
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

Private Sub Redimensionar(obj As Object, Left As Double, Top As Double, Width As Double, Height As Double)
    obj.Left = Left * obj.Left
    obj.Top = Top * obj.Top
    If Height <> 1 Then obj.Height = CLng(Height * obj.Height)
    If Width <> 1 Then obj.Width = Width * obj.Width
End Sub

Private Sub PosicionarLegenda(x As Double, Y As Double)
    Dim i As Integer
    
    If (x <> 1) And (Y <> 1) Then
    Call Redimensionar(FramLeg, x, Y, x, Y)
    Call Redimensionar(FormCmdAju, x, Y, x, 1)
    Call Redimensionar(FormCmdSave, x, Y, x, 1)
    
    For i = 1 To 3
        Call Redimensionar(Legend(i), x, Y, x, Y)
        Call Redimensionar(TxtTitAbr(i), x, Y, x, 1)
        Call Redimensionar(TxtVol(i), x, Y, x, 1)
        Call Redimensionar(TxtNro(i), x, Y, x, 1)
        Call Redimensionar(TxtSupplVol(i), x, Y, x, 1)
        Call Redimensionar(TxtSupplNro(i), x, Y, x, 1)
        Call Redimensionar(TxtLoc(i), x, Y, x, 1)
        Call Redimensionar(TxtMes(i), x, Y, x, 1)
        Call Redimensionar(TxtAno(i), x, Y, x, 1)
        Call Redimensionar(Label1(i), x, Y, x, 1)
        Call Redimensionar(Label2(i), x, Y, x, 1)
        Call Redimensionar(Label3(i), x, Y, x, 1)
        Call Redimensionar(Label4(i), x, Y, x, 1)
        Call Redimensionar(Label5(i), x, Y, x, 1)
        Call Redimensionar(Label6(i), x, Y, x, 1)
        Call Redimensionar(Label7(i), x, Y, x, 1)
        Call Redimensionar(Label8(i), x, Y, x, 1)
    Next
    End If
End Sub

Private Sub Posicionar(x As Double, Y As Double)
    
    If (x <> 1) And (Y <> 1) Then
    Call Redimensionar(SSTab1, x, Y, x, Y)
    
    If SSTab1.Tab = 0 Then
        Call PosicionarLegenda(x, Y)
        'If SSTab1.TabVisible(1) Then
            SSTab1.Tab = 1
            'Call PosicionarSumario(X, Y)
            SSTab1.Tab = 0
        'End If
    Else
        'Call PosicionarSumario(X, Y)
        SSTab1.Tab = 0
        Call PosicionarLegenda(x, Y)
        SSTab1.Tab = 1
    End If
    End If
End Sub

Private Sub formcmdsave_Click()
    If Len(currDate) > 0 Then
        If StrComp(TxtDateIso.text, currDate, vbTextCompare) <> 0 Then
            MsgBox ConfigLabels.Issue_InvalidDateBibStrip
        End If
    End If
    Issue_Save
End Sub

Private Sub LVSections_BeforeLabelEdit(Cancel As Integer)
    Cancel = 1
End Sub

Private Sub LVSections_ColumnClick(ByVal ColumnHeader As ComctlLib.ColumnHeader)
    'LVSections.SortKey = ColumnHeader.index - 1
    'LVSections.Sorted = True
    'LVSections.SortOrder = lvwAscending
End Sub

Private Sub TxtDateIso_Change()

    Dim idiomidx As Long
    Dim month As String
    Dim change As Boolean
    
    
    If Len(TxtDateIso.text) >= 4 Then
        If Len(TxtDateIso.text) >= 6 Then
            month = Mid(TxtDateIso.text, 5, 2)
        Else
            month = "00"
        End If
        
        If Len(currDate) >= 6 Then
            CurrMonth = Mid(currDate, 5, 2)
        Else
            CurrMonth = ""
        End If
        
        For idiomidx = 1 To IdiomsInfo.count
            If month = CurrMonth Then
                If MfnIssue > 0 Then
                    TxtMes(idiomidx).text = BDIssues.UsePft(MfnIssue, "(if v43^l='" + IdiomsInfo(idiomidx).Code + "' then v43^m fi)")
                Else
                    TxtMes(idiomidx).text = Months.GetMonth(IdiomsInfo(idiomidx).Code, TxtDateIso.text, Issue1.Title_Freq)
                End If
            Else
                TxtMes(idiomidx).text = Months.GetMonth(IdiomsInfo(idiomidx).Code, TxtDateIso.text, Issue1.Title_Freq)
            End If
        Next
               
        If Mid(TxtDateIso.text, 1, 4) <> Issue1.Year Then
            If Len(TxtDateIso.text) = 8 Then MsgBox ConfigLabels.MsgInvalidYear, vbCritical
            TxtDateIso.text = Issue1.Year ' + Mid(TxtDateIso.Text, 5)
        Else
            For idiomidx = 1 To IdiomsInfo.count
                TxtAno(idiomidx).text = Mid(TxtDateIso.text, 1, 4)
            Next
        End If
    End If
End Sub

Private Function Issue_ChangedContents() As Boolean
    Dim change As Boolean
    Dim bibstrip As String
    Dim i As Long
    Dim Mkp_Status As String
    Dim sections As String
    Dim sections2 As String
    Dim s As String
    Dim j As Long
    Dim lvi As ListItem
    Dim p As Long
    
    change = change Or (StrComp(TxtDoccount.text, Issue_TxtContent(MfnIssue, 122)) <> 0)
    change = change Or (StrComp(TxtDateIso.text, Issue_TxtContent(MfnIssue, 65)) <> 0)
    change = change Or (StrComp(TxtIssuept.text, Issue_TxtContent(MfnIssue, 34)) <> 0)
    change = change Or (StrComp(TxtIssSponsor.text, Issue_TxtContent(MfnIssue, 140)) <> 0)
    'change = change Or (StrComp(TxtIssTitle.Text, Issue_TxtContent(MfnIssue, 33)) <> 0)
    For i = 1 To IdiomsInfo.count
        change = change Or (StrComp(TxtIssTitle(i).text, Issue_TxtContent(MfnIssue, 33, IdiomsInfo(i).Code)) <> 0)
    Next
    
    change = change Or (StrComp(TxtIssPublisher.text, Issue_TxtContent(MfnIssue, 62)) <> 0)
    change = change Or (StrComp(TxtCover.text, Issue_TxtContent(MfnIssue, 97)) <> 0)
        
    change = change Or (StrComp(ComboStatus.text, Issue_ComboContent(CodeIssStatus, MfnIssue, 42)) <> 0)
    change = change Or (StrComp(ComboStandard.text, Issue_ComboContent(CodeStandard, MfnIssue, 117)) <> 0)
    
    change = change Or Serial_ChangedListContent(ListScheme, CodeScheme, MfnIssue, 85)
    change = change Or (MkpCheck.value <> Str2Int(Issue_TxtContent(MfnIssue, 200)))
    
    
    With BDIssues
    
    lvSortedSections.ListItems.Clear
    For j = 1 To LVSections.ListItems.count
        Set lvi = lvSortedSections.ListItems.add(, , LVSections.ListItems(j).text)
        For i = 1 To IdiomsInfo.count
            lvi.SubItems(i) = LVSections.ListItems(j).SubItems(i)
        Next
    Next
    lvSortedSections.Sorted = True
    lvSortedSections.SortKey = 0
    lvSortedSections.SortOrder = lvwAscending
    
    
    i = 0
    While (i < IdiomsInfo.count) And (Not change)
        
        i = i + 1
        change = change Or (StrComp(TxtHeader(i).text, Issue_Header(MfnIssue, IdiomsInfo(i).Code)) <> 0)
        
        sections = ""
        For j = 1 To lvSortedSections.ListItems.count
            If Len(lvSortedSections.ListItems(j).SubItems(i)) > 0 Then sections = sections + lvSortedSections.ListItems(j).text + "-" + lvSortedSections.ListItems(j).SubItems(i) + vbCrLf
        Next
        
        s = .UsePft(MfnIssue, "(if v49^l='" + IdiomsInfo(i).Code + "' then v49^c,'-',v49^t/ fi)")
        ListSortedSections.Clear
        p = InStr(s, vbCrLf)
        While (p > 0)
            ListSortedSections.AddItem Mid(s, 1, p - 1)
            s = Mid(s, p + 2)
            p = InStr(s, vbCrLf)
        Wend
        sections2 = ""
        For j = 0 To ListSortedSections.ListCount - 1
            sections2 = sections2 + ListSortedSections.list(j) + vbCrLf
        Next
        change = change Or (StrComp(sections, sections2) <> 0)
        
        bibstrip = "^l" + IdiomsInfo(i).Code
        If Len(TxtTitAbr(i).text) > 0 Then bibstrip = bibstrip + "^t" + TxtTitAbr(i).text
        If Len(TxtVol(i).text) > 0 Then bibstrip = bibstrip + "^v" + TxtVol(i).text
        If Len(TxtSupplVol(i).text) > 0 Then bibstrip = bibstrip + "^w" + TxtSupplVol(i).text
        If Len(TxtNro(i).text) > 0 Then bibstrip = bibstrip + "^n" + TxtNro(i).text
        If Len(TxtSupplNro(i).text) > 0 Then bibstrip = bibstrip + "^s" + TxtSupplNro(i).text
        If Len(TxtLoc(i).text) > 0 Then bibstrip = bibstrip + "^c" + TxtLoc(i).text
        If Len(TxtMes(i).text) > 0 Then bibstrip = bibstrip + "^m" + TxtMes(i).text
        If Len(TxtAno(i).text) > 0 Then bibstrip = bibstrip + "^a" + TxtAno(i).text
        
        change = change Or (StrComp(bibstrip, .UsePft(MfnIssue, "(if v43^l='" + IdiomsInfo(i).Code + "' then v43 fi)")) <> 0)
            
    Wend
    
    For i = 1 To IdiomsInfo.count
        change = change Or (StrComp(TextCreativeCommons(i - 1).text, .UsePft(MfnIssue, "(if v540^l='" + IdiomsInfo(i).Code + "' then v540^t fi)")) <> 0)
    Next
        
    
    End With
    Issue_ChangedContents = change
End Function


Private Function WarnMandatoryFields() As Boolean
    Dim warning As String
    Dim i As Long
    
    With Fields
    
    If Not CheckDateISO(TxtDateIso.text) Then warning = warning + ConfigLabels.MsgInvalidDATEISO + vbCrLf
        
    
    warning = warning + .MandatoryFields(ComboStatus.text, "Issue_status")
    warning = warning + .MandatoryFields(ComboStandard.text, "Issue_Standard")
    
    If ListScheme.SelCount = 0 Then
        warning = warning + .MandatoryFields("", "Issue_Scheme")
    End If
    
   
    warning = warning + .MandatoryFields(TxtDateIso.text, "Issue_DateISO")
    warning = warning + .MandatoryFields(TxtDoccount.text, "Issue_NumberofDocuments")
    
    
    If Not IsNumber(TxtDoccount.text) Then MsgBox ConfigLabels.Issue_InvalidNumDoc
    
    For i = 1 To IdiomsInfo.count
        warning = warning + .MandatoryFields(TxtTitAbr(i).text, "ser1_ShortTitle")
        warning = warning + .MandatoryFields(TxtVol(i).text + TxtSupplVol(i).text + TxtNro(i).text + TxtSupplNro(i).text, "Issueno")
        warning = warning + .MandatoryFields(TxtLoc(i).text, "Issue_Place")
        warning = warning + .MandatoryFields(TxtAno(i).text, "Issue_year")
    Next
    For i = 1 To IdiomsInfo.count
        warning = warning + .MandatoryFields(TxtHeader(i).text, "Issue_Header")
    Next
    
    
    End With
    
    If Len(warning) > 0 Then
        MsgBox ConfigLabels.MsgMandatoryContent + vbCrLf + warning
    End If
    WarnMandatoryFields = (Len(warning) > 0)
End Function

Private Function CheckYears() As Boolean
    Dim i As Long
    Dim yearOK As Boolean
    Dim Year As String
    
    With ConfigLabels
    
    If Len(TxtDateIso.text) >= 4 Then
        Year = Mid(TxtDateIso.text, 1, 4)
        yearOK = True
    End If
    
    For i = 1 To IdiomsInfo.count
        yearOK = yearOK And (TxtAno(i).text = Year)
    Next
    
    yearOK = yearOK And (Mid(Issue1.TxtIseqno.text, 1, 4) = Year)
    
    End With
    
    
    If Not yearOK Then
        Call MsgBox(ConfigLabels.MsgInvalidYear, vbCritical)
    End If
    CheckYears = yearOK
End Function


Private Sub TxtDateIso_LostFocus()
        
        If CheckDateISO(TxtDateIso.text) Then
            If Len(currDate) > 0 Then
                If StrComp(TxtDateIso.text, currDate) <> 0 Then
                    currDate = TxtDateIso.text
                End If
            Else
                currDate = TxtDateIso.text
            End If
        End If
End Sub


VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form FrmSerial 
   Caption         =   "Serial"
   ClientHeight    =   5640
   ClientLeft      =   330
   ClientTop       =   750
   ClientWidth     =   9165
   Icon            =   "FrmSerial.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5640
   ScaleWidth      =   9165
   Begin TabDlg.SSTab SSTab1 
      Height          =   5415
      Left            =   3000
      TabIndex        =   63
      Top             =   120
      Width           =   6150
      _ExtentX        =   10848
      _ExtentY        =   9551
      _Version        =   327680
      Style           =   1
      Tabs            =   9
      Tab             =   2
      TabsPerRow      =   9
      TabHeight       =   520
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      TabCaption(0)   =   "1"
      TabPicture(0)   =   "FrmSerial.frx":030A
      Tab(0).ControlCount=   2
      Tab(0).ControlEnabled=   0   'False
      Tab(0).Control(0)=   "Frame4"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "Frame2"
      Tab(0).Control(1).Enabled=   0   'False
      TabCaption(1)   =   "2"
      TabPicture(1)   =   "FrmSerial.frx":0326
      Tab(1).ControlCount=   3
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "Frame3"
      Tab(1).Control(0).Enabled=   0   'False
      Tab(1).Control(1)=   "Frame8"
      Tab(1).Control(1).Enabled=   0   'False
      Tab(1).Control(2)=   "Frame7"
      Tab(1).Control(2).Enabled=   0   'False
      TabCaption(2)   =   "3"
      TabPicture(2)   =   "FrmSerial.frx":0342
      Tab(2).ControlCount=   2
      Tab(2).ControlEnabled=   -1  'True
      Tab(2).Control(0)=   "Frame6"
      Tab(2).Control(0).Enabled=   0   'False
      Tab(2).Control(1)=   "Frame5"
      Tab(2).Control(1).Enabled=   0   'False
      TabCaption(3)   =   "4"
      TabPicture(3)   =   "FrmSerial.frx":035E
      Tab(3).ControlCount=   2
      Tab(3).ControlEnabled=   0   'False
      Tab(3).Control(0)=   "Frame10"
      Tab(3).Control(0).Enabled=   0   'False
      Tab(3).Control(1)=   "Frame9"
      Tab(3).Control(1).Enabled=   0   'False
      TabCaption(4)   =   "5"
      TabPicture(4)   =   "FrmSerial.frx":037A
      Tab(4).ControlCount=   1
      Tab(4).ControlEnabled=   0   'False
      Tab(4).Control(0)=   "Frame11"
      Tab(4).Control(0).Enabled=   0   'False
      TabCaption(5)   =   "6"
      TabPicture(5)   =   "FrmSerial.frx":0396
      Tab(5).ControlCount=   2
      Tab(5).ControlEnabled=   0   'False
      Tab(5).Control(0)=   "Frame20"
      Tab(5).Control(0).Enabled=   0   'False
      Tab(5).Control(1)=   "Frame19"
      Tab(5).Control(1).Enabled=   0   'False
      TabCaption(6)   =   "7"
      TabPicture(6)   =   "FrmSerial.frx":03B2
      Tab(6).ControlCount=   2
      Tab(6).ControlEnabled=   0   'False
      Tab(6).Control(0)=   "Frame12"
      Tab(6).Control(0).Enabled=   0   'False
      Tab(6).Control(1)=   "Frame15"
      Tab(6).Control(1).Enabled=   0   'False
      TabCaption(7)   =   "8"
      TabPicture(7)   =   "FrmSerial.frx":03CE
      Tab(7).ControlCount=   1
      Tab(7).ControlEnabled=   0   'False
      Tab(7).Control(0)=   "FramSum"
      Tab(7).Control(0).Enabled=   0   'False
      TabCaption(8)   =   "9"
      TabPicture(8)   =   "FrmSerial.frx":03EA
      Tab(8).ControlCount=   3
      Tab(8).ControlEnabled=   0   'False
      Tab(8).Control(0)=   "Frame16"
      Tab(8).Control(0).Enabled=   0   'False
      Tab(8).Control(1)=   "Frame17"
      Tab(8).Control(1).Enabled=   0   'False
      Tab(8).Control(2)=   "Frame18"
      Tab(8).Control(2).Enabled=   0   'False
      Begin VB.Frame FramSum 
         Caption         =   "Sections of this serial"
         Height          =   4575
         Left            =   -74880
         TabIndex        =   135
         Top             =   360
         Width           =   5775
         Begin VB.ListBox DispoSecTitle 
            Height          =   1035
            Index           =   3
            ItemData        =   "FrmSerial.frx":0406
            Left            =   120
            List            =   "FrmSerial.frx":040D
            Sorted          =   -1  'True
            TabIndex        =   138
            Top             =   3360
            Width           =   2655
         End
         Begin VB.ComboBox DispoSecCode 
            Height          =   315
            Left            =   1320
            Sorted          =   -1  'True
            TabIndex        =   50
            Text            =   "DispoSecCode"
            Top             =   360
            Width           =   1815
         End
         Begin VB.TextBox NewSecTitle 
            Height          =   285
            Index           =   3
            Left            =   120
            TabIndex        =   53
            Top             =   3000
            Width           =   2655
         End
         Begin VB.ListBox DispoSecTitle 
            Height          =   1035
            Index           =   1
            ItemData        =   "FrmSerial.frx":0420
            Left            =   120
            List            =   "FrmSerial.frx":0427
            Sorted          =   -1  'True
            TabIndex        =   137
            Top             =   1440
            Width           =   2775
         End
         Begin VB.TextBox NewSecTitle 
            Height          =   285
            Index           =   1
            Left            =   120
            TabIndex        =   51
            Top             =   1080
            Width           =   2775
         End
         Begin VB.ListBox DispoSecTitle 
            Height          =   1035
            Index           =   2
            ItemData        =   "FrmSerial.frx":043A
            Left            =   3000
            List            =   "FrmSerial.frx":0441
            Sorted          =   -1  'True
            TabIndex        =   136
            Top             =   1440
            Width           =   2655
         End
         Begin VB.TextBox NewSecTitle 
            Height          =   285
            Index           =   2
            Left            =   3000
            TabIndex        =   52
            Top             =   1080
            Width           =   2655
         End
         Begin VB.CommandButton Add 
            Caption         =   "Add"
            Height          =   375
            Left            =   3360
            TabIndex        =   54
            Top             =   360
            Width           =   735
         End
         Begin VB.CommandButton Del 
            Caption         =   "Delete"
            Height          =   375
            Left            =   4200
            TabIndex        =   55
            Top             =   360
            Width           =   735
         End
         Begin VB.Label LabSectionCodes 
            Caption         =   "Section Codes"
            Height          =   255
            Left            =   120
            TabIndex        =   142
            Top             =   360
            Width           =   1095
         End
         Begin VB.Label LabIdiom 
            Caption         =   "English"
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   141
            Top             =   2760
            Width           =   1455
         End
         Begin VB.Label LabIdiom 
            Caption         =   "Spanish"
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   140
            Top             =   840
            Width           =   1455
         End
         Begin VB.Label LabIdiom 
            Caption         =   "Portuguese"
            Height          =   255
            Index           =   2
            Left            =   3000
            TabIndex        =   139
            Top             =   840
            Width           =   1455
         End
      End
      Begin VB.Frame Frame15 
         Height          =   2055
         Left            =   -74880
         TabIndex        =   130
         Top             =   420
         Width           =   5655
         Begin VB.TextBox TxtAddress 
            Height          =   645
            Left            =   1560
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   146
            Top             =   600
            Width           =   3975
         End
         Begin VB.TextBox Txtemail 
            Height          =   285
            Left            =   1560
            TabIndex        =   44
            Top             =   1320
            Width           =   3975
         End
         Begin VB.TextBox TxtCopyright 
            Height          =   285
            Left            =   1560
            TabIndex        =   43
            Top             =   240
            Width           =   3975
         End
         Begin VB.TextBox TxtSepLine 
            Height          =   285
            Left            =   1560
            TabIndex        =   45
            Top             =   1680
            Width           =   3975
         End
         Begin VB.Label Labemail 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "e-mail"
            Height          =   195
            Left            =   1080
            TabIndex        =   134
            Top             =   1320
            Width           =   405
         End
         Begin VB.Label LabAddress 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Address"
            Height          =   195
            Left            =   915
            TabIndex        =   133
            Top             =   600
            Width           =   570
         End
         Begin VB.Label LabCopyright 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Copyright Notation"
            Height          =   195
            Left            =   180
            TabIndex        =   132
            Top             =   240
            Width           =   1305
         End
         Begin VB.Label LabSepLine 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Separator Line"
            Height          =   195
            Left            =   450
            TabIndex        =   131
            Top             =   1680
            Width           =   1035
         End
      End
      Begin VB.Frame Frame12 
         Height          =   1815
         Left            =   -74880
         TabIndex        =   125
         Top             =   2580
         Width           =   5655
         Begin VB.ComboBox ComboStatus 
            Height          =   315
            Left            =   1590
            Style           =   2  'Dropdown List
            TabIndex        =   49
            Top             =   1320
            Width           =   3975
         End
         Begin VB.TextBox TxtSiteLocation 
            Height          =   285
            Left            =   1560
            TabIndex        =   46
            Top             =   240
            Width           =   3975
         End
         Begin VB.ComboBox ComboUserSubscription 
            Height          =   315
            Left            =   1560
            Style           =   2  'Dropdown List
            TabIndex        =   48
            Top             =   960
            Width           =   3975
         End
         Begin VB.ComboBox ComboFTP 
            Height          =   315
            Left            =   1560
            Style           =   2  'Dropdown List
            TabIndex        =   47
            Top             =   600
            Width           =   3975
         End
         Begin VB.Label LabStatus 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Status"
            Height          =   195
            Left            =   960
            TabIndex        =   129
            Top             =   1320
            Width           =   450
         End
         Begin VB.Label LabFTP 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "FTP"
            Height          =   195
            Left            =   1080
            TabIndex        =   128
            Top             =   600
            Width           =   300
         End
         Begin VB.Label LabSiteLocation 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Site Location"
            Height          =   195
            Left            =   480
            TabIndex        =   127
            Top             =   240
            Width           =   930
         End
         Begin VB.Label LabUserSubscription 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "User Subscription"
            Height          =   195
            Left            =   120
            TabIndex        =   126
            Top             =   960
            Width           =   1245
         End
      End
      Begin VB.Frame Frame20 
         Height          =   3255
         Left            =   -74880
         TabIndex        =   121
         Top             =   420
         Width           =   5655
         Begin VB.TextBox TxtMission 
            Height          =   885
            Index           =   1
            Left            =   1560
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   37
            Top             =   360
            Width           =   3975
         End
         Begin VB.TextBox TxtMission 
            Height          =   885
            Index           =   2
            Left            =   1560
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   38
            Top             =   1320
            Width           =   3975
         End
         Begin VB.TextBox TxtMission 
            Height          =   885
            Index           =   3
            Left            =   1560
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   39
            Top             =   2280
            Width           =   3975
         End
         Begin VB.Label LabMission 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Mission (English)"
            Height          =   195
            Index           =   1
            Left            =   195
            TabIndex        =   124
            Top             =   360
            Width           =   1170
         End
         Begin VB.Label LabMission 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Mission (Spanish)"
            Height          =   195
            Index           =   2
            Left            =   180
            TabIndex        =   123
            Top             =   1320
            Width           =   1230
         End
         Begin VB.Label LabMission 
            Alignment       =   1  'Right Justify
            Caption         =   "Mission (Portuguese)"
            Height          =   435
            Index           =   3
            Left            =   120
            TabIndex        =   122
            Top             =   2280
            Width           =   1335
         End
      End
      Begin VB.Frame Frame19 
         Height          =   975
         Left            =   -74880
         TabIndex        =   118
         Top             =   3780
         Width           =   5655
         Begin VB.TextBox TxtSiglum 
            Height          =   285
            Left            =   1560
            TabIndex        =   40
            Top             =   240
            Width           =   3975
         End
         Begin VB.TextBox TxtSerialId 
            Height          =   285
            Left            =   1560
            TabIndex        =   41
            Top             =   600
            Width           =   3975
         End
         Begin VB.Label LabSiglum 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Siglum"
            Height          =   195
            Left            =   900
            TabIndex        =   120
            Top             =   240
            Width           =   465
         End
         Begin VB.Label LabSerialId 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Serial Id"
            Height          =   195
            Left            =   735
            TabIndex        =   119
            Top             =   600
            Width           =   570
         End
      End
      Begin VB.Frame Frame11 
         Height          =   3375
         Left            =   -74880
         TabIndex        =   115
         Top             =   480
         Width           =   5895
         Begin VB.ListBox ListIdxCoverage 
            Height          =   960
            Left            =   1560
            Style           =   1  'Checkbox
            TabIndex        =   35
            Top             =   1080
            Width           =   3975
         End
         Begin VB.TextBox TxtIdxCoverage 
            Height          =   975
            Left            =   1560
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   36
            Text            =   "FrmSerial.frx":0454
            Top             =   2160
            Width           =   3975
         End
         Begin VB.TextBox TxtSeCSNumber 
            Height          =   285
            Index           =   0
            Left            =   1560
            TabIndex        =   33
            Top             =   240
            Width           =   3975
         End
         Begin VB.TextBox TxtMedLineCode 
            Height          =   285
            Index           =   6
            Left            =   1560
            TabIndex        =   34
            Top             =   600
            Width           =   3975
         End
         Begin VB.Label LabSeCSNumber 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "SeCS Number"
            Height          =   195
            Left            =   480
            TabIndex        =   144
            Top             =   240
            Width           =   1005
         End
         Begin VB.Label LabMedLineCode 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "MEDLINE Code"
            Height          =   195
            Left            =   360
            TabIndex        =   117
            Top             =   600
            Width           =   1140
         End
         Begin VB.Label LabIdxCoverage 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Index Coverage"
            Height          =   195
            Left            =   360
            TabIndex        =   116
            Top             =   960
            Width           =   1125
         End
      End
      Begin VB.Frame Frame9 
         Height          =   1455
         Left            =   -74880
         TabIndex        =   112
         Top             =   2880
         Width           =   5895
         Begin VB.TextBox TxtClassification 
            Height          =   765
            Left            =   1200
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   32
            Top             =   600
            Width           =   4575
         End
         Begin VB.TextBox TxtNationalCode 
            Height          =   285
            Left            =   1200
            TabIndex        =   31
            Top             =   240
            Width           =   4575
         End
         Begin VB.Label LabClassification 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Classification"
            Height          =   195
            Left            =   120
            TabIndex        =   114
            Top             =   600
            Width           =   915
         End
         Begin VB.Label LabNationalCode 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "National Code"
            Height          =   195
            Left            =   120
            TabIndex        =   113
            Top             =   240
            Width           =   1005
         End
      End
      Begin VB.Frame Frame10 
         Height          =   2415
         Left            =   -74880
         TabIndex        =   109
         Top             =   420
         Width           =   5895
         Begin VB.TextBox TxtStudyArea 
            Height          =   975
            Left            =   1200
            Locked          =   -1  'True
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   27
            Text            =   "FrmSerial.frx":045A
            Top             =   240
            Width           =   2295
         End
         Begin VB.ListBox ListStudyArea 
            Height          =   960
            Left            =   3600
            Style           =   1  'Checkbox
            TabIndex        =   28
            Top             =   240
            Width           =   2175
         End
         Begin VB.TextBox TxtDescriptors 
            Height          =   975
            Left            =   1200
            Locked          =   -1  'True
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   29
            Text            =   "FrmSerial.frx":0460
            Top             =   1320
            Width           =   2295
         End
         Begin VB.ListBox ListDescriptors 
            Height          =   960
            Left            =   3600
            Style           =   1  'Checkbox
            TabIndex        =   30
            Top             =   1320
            Width           =   2175
         End
         Begin VB.Label LabStudyArea 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Study Area"
            Height          =   195
            Left            =   240
            TabIndex        =   111
            Top             =   240
            Width           =   780
         End
         Begin VB.Label LabDescriptors 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   " Descriptors"
            Height          =   195
            Left            =   120
            TabIndex        =   110
            Top             =   1320
            Width           =   840
         End
      End
      Begin VB.Frame Frame7 
         Height          =   1695
         Left            =   -74880
         TabIndex        =   105
         Top             =   2340
         Width           =   5655
         Begin VB.ComboBox Combo1 
            Height          =   315
            Left            =   1560
            TabIndex        =   147
            Text            =   "Combo1"
            Top             =   1320
            Width           =   3975
         End
         Begin VB.TextBox TxtState 
            Height          =   285
            Left            =   1560
            TabIndex        =   145
            Top             =   960
            Width           =   3975
         End
         Begin VB.TextBox TxtCity 
            Height          =   285
            Left            =   1560
            TabIndex        =   17
            Top             =   600
            Width           =   3975
         End
         Begin VB.TextBox TxtPublisher 
            Height          =   285
            Left            =   1560
            TabIndex        =   16
            Top             =   240
            Width           =   3975
         End
         Begin VB.Label LabPublisher 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Publisher"
            Height          =   195
            Left            =   720
            TabIndex        =   143
            Top             =   240
            Width           =   645
         End
         Begin VB.Label LabCity 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "City/Place"
            Height          =   195
            Left            =   600
            TabIndex        =   108
            Top             =   600
            Width           =   735
         End
         Begin VB.Label LabState 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "State"
            Height          =   195
            Left            =   990
            TabIndex        =   107
            Top             =   960
            Width           =   375
         End
         Begin VB.Label LabCountry 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Country"
            Height          =   195
            Left            =   840
            TabIndex        =   106
            Top             =   1320
            Width           =   540
         End
      End
      Begin VB.Frame Frame8 
         Height          =   615
         Left            =   -74880
         TabIndex        =   103
         Top             =   4140
         Width           =   5655
         Begin VB.TextBox TxtSponsor 
            Height          =   285
            Left            =   1560
            TabIndex        =   18
            Top             =   240
            Width           =   3975
         End
         Begin VB.Label LabSponsor 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Sponsor"
            Height          =   195
            Left            =   825
            TabIndex        =   104
            Top             =   240
            Width           =   585
         End
      End
      Begin VB.Frame Frame5 
         Height          =   1335
         Left            =   120
         TabIndex        =   99
         Top             =   3540
         Width           =   5895
         Begin VB.ComboBox ComboPubLevel 
            Height          =   315
            Left            =   1560
            Style           =   2  'Dropdown List
            TabIndex        =   26
            Top             =   960
            Width           =   4200
         End
         Begin VB.ComboBox ComboTreatLevel 
            Height          =   315
            Left            =   1560
            Style           =   2  'Dropdown List
            TabIndex        =   25
            Top             =   600
            Width           =   4200
         End
         Begin VB.ComboBox ComboLiteratureType 
            Height          =   315
            Left            =   1560
            Style           =   2  'Dropdown List
            TabIndex        =   24
            Top             =   240
            Width           =   4200
         End
         Begin VB.Label LabPubLevel 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Publication Level"
            Height          =   195
            Left            =   210
            TabIndex        =   102
            Top             =   960
            Width           =   1215
         End
         Begin VB.Label LabLiterattp 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Literature Type"
            Height          =   195
            Left            =   360
            TabIndex        =   101
            Top             =   240
            Width           =   1065
         End
         Begin VB.Label LabTreatLevel 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Treatment Level"
            Height          =   195
            Left            =   240
            TabIndex        =   100
            Top             =   600
            Width           =   1155
         End
      End
      Begin VB.Frame Frame6 
         Height          =   3015
         Left            =   120
         TabIndex        =   95
         Top             =   420
         Width           =   5655
         Begin VB.ListBox ListAbstrIdiom 
            Height          =   960
            Left            =   3600
            Style           =   1  'Checkbox
            TabIndex        =   23
            Top             =   1920
            Width           =   1935
         End
         Begin VB.TextBox TxtAbstrIdiom 
            Height          =   975
            Left            =   1560
            Locked          =   -1  'True
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   22
            Text            =   "FrmSerial.frx":0466
            Top             =   2040
            Width           =   1935
         End
         Begin VB.ListBox ListTextIdiom 
            Height          =   960
            Left            =   3600
            Style           =   1  'Checkbox
            TabIndex        =   21
            Top             =   720
            Width           =   1935
         End
         Begin VB.TextBox TxtTextIdiom 
            Height          =   975
            Left            =   1560
            Locked          =   -1  'True
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   20
            Text            =   "FrmSerial.frx":046C
            Top             =   720
            Width           =   1935
         End
         Begin VB.ComboBox ComboAlphabet 
            Height          =   315
            Left            =   1560
            Style           =   2  'Dropdown List
            TabIndex        =   19
            Top             =   240
            Width           =   3975
         End
         Begin VB.Label LabTextIdiom 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Text idiom"
            Height          =   195
            Left            =   660
            TabIndex        =   98
            Top             =   720
            Width           =   720
         End
         Begin VB.Label LabAlphabet 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Alphabet"
            Height          =   195
            Left            =   780
            TabIndex        =   97
            Top             =   240
            Width           =   630
         End
         Begin VB.Label LabAbstrIdiom 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Abstract Idiom"
            Height          =   195
            Left            =   360
            TabIndex        =   96
            Top             =   1920
            Width           =   1005
         End
      End
      Begin VB.Frame Frame4 
         Height          =   975
         Left            =   -74880
         TabIndex        =   92
         Top             =   4320
         Width           =   5775
         Begin VB.TextBox TxtIsSuppl 
            Height          =   285
            Left            =   1560
            TabIndex        =   8
            Top             =   600
            Width           =   3975
         End
         Begin VB.TextBox TxtHasSuppl 
            Height          =   285
            Left            =   1560
            TabIndex        =   7
            Top             =   240
            Width           =   3975
         End
         Begin VB.Label LabIsSuppl 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Is Supplement"
            Height          =   195
            Left            =   300
            TabIndex        =   94
            Top             =   600
            Width           =   1005
         End
         Begin VB.Label LabHasSuppl 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Has Supplement"
            Height          =   195
            Left            =   195
            TabIndex        =   93
            Top             =   240
            Width           =   1170
         End
      End
      Begin VB.Frame Frame18 
         Height          =   1815
         Left            =   -74880
         TabIndex        =   87
         Top             =   3120
         Width           =   5655
         Begin VB.TextBox TxtNotes 
            Height          =   1485
            Left            =   1560
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   62
            Top             =   240
            Width           =   3975
         End
         Begin VB.Label LabNotes 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Notes"
            Height          =   195
            Left            =   945
            TabIndex        =   88
            Top             =   240
            Width           =   420
         End
      End
      Begin VB.Frame Frame17 
         Height          =   975
         Left            =   -74880
         TabIndex        =   84
         Top             =   360
         Width           =   5655
         Begin VB.TextBox TxtIdNumber 
            Height          =   285
            Left            =   1560
            TabIndex        =   57
            Top             =   600
            Width           =   3975
         End
         Begin VB.TextBox TxtCCode 
            Height          =   285
            Left            =   1560
            TabIndex        =   56
            Top             =   240
            Width           =   3975
         End
         Begin VB.Label LabIdNumber 
            Alignment       =   1  'Right Justify
            Caption         =   "Identification Number"
            Height          =   435
            Left            =   240
            TabIndex        =   86
            Top             =   480
            Width           =   1260
         End
         Begin VB.Label LabCCode 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Center Code"
            Height          =   195
            Left            =   480
            TabIndex        =   85
            Top             =   240
            Width           =   885
         End
      End
      Begin VB.Frame Frame16 
         Height          =   1815
         Left            =   -74880
         TabIndex        =   79
         Top             =   1320
         Width           =   5655
         Begin VB.TextBox TxtUpdateRespons 
            Height          =   285
            Left            =   1560
            TabIndex        =   61
            Top             =   1440
            Width           =   3975
         End
         Begin VB.TextBox TxtUpdateDate 
            Height          =   285
            Left            =   1560
            TabIndex        =   60
            Top             =   1080
            Width           =   3975
         End
         Begin VB.TextBox TxtCreationRespons 
            Height          =   285
            Left            =   1560
            TabIndex        =   59
            Top             =   600
            Width           =   3975
         End
         Begin VB.TextBox TxtCreationDate 
            Height          =   285
            Left            =   1560
            TabIndex        =   58
            Top             =   240
            Width           =   3975
         End
         Begin VB.Label LabCreationRespons 
            Alignment       =   1  'Right Justify
            Caption         =   "Responsible by Creation"
            Height          =   435
            Left            =   360
            TabIndex        =   83
            Top             =   480
            Width           =   1020
         End
         Begin VB.Label LabUpdateRespons 
            Alignment       =   1  'Right Justify
            Caption         =   "Responsible by update"
            Height          =   435
            Left            =   240
            TabIndex        =   82
            Top             =   1320
            Width           =   1260
         End
         Begin VB.Label LabUpdateDate 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Update Date"
            Height          =   195
            Left            =   480
            TabIndex        =   81
            Top             =   1080
            Width           =   915
         End
         Begin VB.Label LabCreationDate 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Creation Date"
            Height          =   195
            Left            =   390
            TabIndex        =   80
            Top             =   240
            Width           =   975
         End
      End
      Begin VB.Frame Frame2 
         Height          =   3615
         Left            =   -74880
         TabIndex        =   71
         Top             =   600
         Width           =   5775
         Begin VB.TextBox TxtSubtitle 
            Height          =   285
            Left            =   1440
            TabIndex        =   0
            Top             =   240
            Width           =   4095
         End
         Begin VB.TextBox TxtSectionTitle 
            Height          =   285
            Left            =   1440
            TabIndex        =   1
            Top             =   600
            Width           =   4095
         End
         Begin VB.TextBox TxtShortTitle 
            Height          =   525
            Left            =   1440
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   2
            Top             =   960
            Width           =   4095
         End
         Begin VB.TextBox TxtParallelTitle 
            Height          =   525
            Left            =   1440
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   3
            Top             =   1560
            Width           =   4095
         End
         Begin VB.TextBox TxtOtherTitle 
            Height          =   525
            Left            =   1440
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   4
            Top             =   2160
            Width           =   4095
         End
         Begin VB.TextBox TxtOldTitle 
            Height          =   285
            Left            =   1440
            TabIndex        =   5
            Top             =   2760
            Width           =   4095
         End
         Begin VB.TextBox TxtNewTitle 
            Height          =   285
            Left            =   1440
            TabIndex        =   6
            Top             =   3120
            Width           =   4095
         End
         Begin VB.Label LabSubtitle 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Subtitle"
            Height          =   195
            Left            =   840
            TabIndex        =   78
            Top             =   240
            Width           =   525
         End
         Begin VB.Label LabSectionTitle 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Section Title"
            Height          =   195
            Left            =   480
            TabIndex        =   77
            Top             =   600
            Width           =   885
         End
         Begin VB.Label LabParalTitle 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Parallel Titles"
            Height          =   195
            Left            =   435
            TabIndex        =   76
            Top             =   1560
            Width           =   930
         End
         Begin VB.Label LabShortTitle 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Short Title"
            Height          =   195
            Left            =   600
            TabIndex        =   75
            Top             =   960
            Width           =   720
         End
         Begin VB.Label LabOthTitle 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Other Titles"
            Height          =   195
            Left            =   480
            TabIndex        =   74
            Top             =   2160
            Width           =   810
         End
         Begin VB.Label LabOldTitle 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Old Title"
            Height          =   195
            Left            =   780
            TabIndex        =   73
            Top             =   2760
            Width           =   585
         End
         Begin VB.Label LabNewTitle 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "New Title"
            Height          =   195
            Left            =   645
            TabIndex        =   72
            Top             =   3120
            Width           =   675
         End
      End
      Begin VB.Frame Frame3 
         Height          =   1815
         Left            =   -74880
         TabIndex        =   42
         Top             =   420
         Width           =   5895
         Begin VB.TextBox TxtInitialDate 
            Height          =   285
            Left            =   1560
            TabIndex        =   10
            Top             =   720
            Width           =   1455
         End
         Begin VB.TextBox TxtInitialNumber 
            Height          =   285
            Left            =   1560
            TabIndex        =   12
            Top             =   1440
            Width           =   1455
         End
         Begin VB.TextBox TxtFinalDate 
            Height          =   285
            Left            =   4200
            TabIndex        =   13
            Top             =   720
            Width           =   1455
         End
         Begin VB.TextBox TxtFinalVol 
            Height          =   285
            Left            =   4200
            TabIndex        =   14
            Top             =   1080
            Width           =   1455
         End
         Begin VB.TextBox TxtFinalNumber 
            Height          =   285
            Left            =   4200
            TabIndex        =   15
            Top             =   1440
            Width           =   1455
         End
         Begin VB.TextBox TxtInitialVol 
            Height          =   285
            Left            =   1560
            TabIndex        =   11
            Top             =   1080
            Width           =   1455
         End
         Begin VB.ComboBox ComboFreq 
            Height          =   315
            Left            =   1560
            Style           =   2  'Dropdown List
            TabIndex        =   9
            Top             =   240
            Width           =   4095
         End
         Begin VB.Label LabInitialDate 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Initial Date"
            Height          =   195
            Left            =   600
            TabIndex        =   70
            Top             =   720
            Width           =   750
         End
         Begin VB.Label LabInitialVol 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Initial Volume"
            Height          =   195
            Left            =   480
            TabIndex        =   69
            Top             =   1080
            Width           =   930
         End
         Begin VB.Label LabInitialNumber 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Initial Number"
            Height          =   195
            Left            =   480
            TabIndex        =   68
            Top             =   1440
            Width           =   960
         End
         Begin VB.Label LabFinalDate 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Final Date"
            Height          =   195
            Left            =   3360
            TabIndex        =   67
            Top             =   720
            Width           =   720
         End
         Begin VB.Label LabFinalVol 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Final Volume"
            Height          =   195
            Left            =   3120
            TabIndex        =   66
            Top             =   1080
            Width           =   900
         End
         Begin VB.Label LabFinalNumber 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Final Number"
            Height          =   195
            Left            =   3120
            TabIndex        =   65
            Top             =   1440
            Width           =   930
         End
         Begin VB.Label LabFreq 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Frequency"
            Height          =   195
            Left            =   600
            TabIndex        =   64
            Top             =   240
            Width           =   750
         End
      End
   End
   Begin VB.Frame Frame1 
      Height          =   5535
      Left            =   0
      TabIndex        =   89
      Top             =   0
      Width           =   2895
      Begin VB.TextBox TxtHelp 
         Height          =   4935
         Left            =   120
         Locked          =   -1  'True
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   90
         Top             =   480
         Width           =   2655
      End
      Begin VB.Label Label11 
         Caption         =   "Help"
         Height          =   255
         Left            =   120
         TabIndex        =   91
         Top             =   240
         Width           =   2055
      End
   End
End
Attribute VB_Name = "FrmSerial"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
    FrmInfo.Show
End Sub

Private Sub Form_Unload(Cancel As Integer)
    FrmInfo.CloseForm = True
    Unload FrmInfo
End Sub

Private Sub TxtOther_Change(index As Integer)

End Sub

Private Sub TxtSubtitle_Click()
    FrmInfo.ShowHelpTExt (TxtSubtitle.tag)
End Sub

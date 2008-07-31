VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   6495
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7890
   LinkTopic       =   "Form1"
   ScaleHeight     =   6495
   ScaleWidth      =   7890
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame FrameInfoPub 
      Caption         =   "Information about the publisher and the journal (Part 2) "
      Height          =   2895
      Index           =   0
      Left            =   0
      TabIndex        =   15
      Top             =   0
      Width           =   7455
      Begin VB.TextBox TxtAddress 
         Height          =   525
         Left            =   1200
         MultiLine       =   -1  'True
         TabIndex        =   22
         Text            =   "Form1.frx":0000
         Top             =   240
         Width           =   6135
      End
      Begin VB.TextBox TxtSponsor 
         Height          =   525
         Left            =   1800
         MultiLine       =   -1  'True
         TabIndex        =   21
         Text            =   "Form1.frx":0006
         Top             =   2280
         Width           =   5535
      End
      Begin VB.TextBox TxtCprightDate 
         Height          =   285
         Left            =   2520
         TabIndex        =   20
         Text            =   "Text4"
         Top             =   1560
         Visible         =   0   'False
         Width           =   4815
      End
      Begin VB.TextBox TxtEmail 
         Height          =   285
         Left            =   1800
         TabIndex        =   19
         Text            =   "Text4"
         Top             =   1200
         Width           =   5535
      End
      Begin VB.TextBox TxtPhone 
         Height          =   285
         Left            =   1800
         TabIndex        =   18
         Top             =   840
         Visible         =   0   'False
         Width           =   1935
      End
      Begin VB.TextBox TxtFaxNumber 
         Height          =   285
         Left            =   5400
         TabIndex        =   17
         Top             =   840
         Visible         =   0   'False
         Width           =   1935
      End
      Begin VB.TextBox TxtCprighter 
         Height          =   285
         Left            =   1800
         TabIndex        =   16
         Text            =   "Text4"
         Top             =   1920
         Width           =   5535
      End
      Begin VB.Label LabAddress 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Address"
         Height          =   195
         Left            =   480
         TabIndex        =   29
         Top             =   240
         Width           =   570
      End
      Begin VB.Label LabEmail 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Electronic address"
         Height          =   195
         Left            =   360
         TabIndex        =   28
         Top             =   1200
         Width           =   1305
      End
      Begin VB.Label LabSponsor 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Sponsor"
         Height          =   195
         Left            =   1080
         TabIndex        =   27
         Top             =   2280
         Width           =   585
      End
      Begin VB.Label LabCprightDate 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Copyright (Date)"
         Height          =   195
         Left            =   720
         TabIndex        =   26
         Top             =   1560
         Visible         =   0   'False
         Width           =   1140
      End
      Begin VB.Label LabPhone 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Phone Number"
         Height          =   195
         Left            =   600
         TabIndex        =   25
         Top             =   840
         Visible         =   0   'False
         Width           =   1065
      End
      Begin VB.Label LabFax 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Fax Number"
         Height          =   195
         Left            =   4440
         TabIndex        =   24
         Top             =   840
         Visible         =   0   'False
         Width           =   855
      End
      Begin VB.Label LabCprighter 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Copyrighter"
         Height          =   195
         Left            =   840
         TabIndex        =   23
         Top             =   1920
         Width           =   795
      End
   End
   Begin VB.Frame FrameInfoPub 
      Caption         =   "Information about the publisher and the journal (Part 2) "
      Height          =   2895
      Index           =   1
      Left            =   120
      TabIndex        =   0
      Top             =   3240
      Width           =   7455
      Begin VB.TextBox Text7 
         Height          =   525
         Left            =   120
         MultiLine       =   -1  'True
         TabIndex        =   7
         Text            =   "Form1.frx":002B
         Top             =   480
         Width           =   4095
      End
      Begin VB.TextBox Text6 
         Height          =   1125
         Left            =   4320
         MultiLine       =   -1  'True
         TabIndex        =   6
         Text            =   "Form1.frx":0031
         Top             =   1080
         Width           =   3015
      End
      Begin VB.TextBox Text5 
         Height          =   285
         Left            =   120
         TabIndex        =   5
         Text            =   "Text4"
         Top             =   1920
         Visible         =   0   'False
         Width           =   1215
      End
      Begin VB.TextBox Text4 
         Height          =   285
         Left            =   120
         TabIndex        =   4
         Text            =   "Text4"
         Top             =   1320
         Width           =   4095
      End
      Begin VB.TextBox Text3 
         Height          =   285
         Left            =   4320
         TabIndex        =   3
         Top             =   480
         Visible         =   0   'False
         Width           =   1455
      End
      Begin VB.TextBox Text2 
         Height          =   285
         Left            =   5880
         TabIndex        =   2
         Top             =   480
         Visible         =   0   'False
         Width           =   1455
      End
      Begin VB.TextBox Text1 
         Height          =   285
         Left            =   1440
         TabIndex        =   1
         Text            =   "Text4"
         Top             =   1920
         Width           =   2775
      End
      Begin VB.Label Label7 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Address"
         Height          =   195
         Left            =   120
         TabIndex        =   14
         Top             =   240
         Width           =   570
      End
      Begin VB.Label Label6 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Electronic address"
         Height          =   195
         Left            =   120
         TabIndex        =   13
         Top             =   1080
         Width           =   1305
      End
      Begin VB.Label Label5 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Sponsor"
         Height          =   195
         Left            =   4320
         TabIndex        =   12
         Top             =   840
         Width           =   585
      End
      Begin VB.Label Label4 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Copyright (Date)"
         Height          =   195
         Left            =   120
         TabIndex        =   11
         Top             =   1680
         Visible         =   0   'False
         Width           =   1140
      End
      Begin VB.Label Label3 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Phone Number"
         Height          =   195
         Left            =   4320
         TabIndex        =   10
         Top             =   240
         Visible         =   0   'False
         Width           =   1065
      End
      Begin VB.Label Label2 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Fax Number"
         Height          =   195
         Left            =   5880
         TabIndex        =   9
         Top             =   240
         Visible         =   0   'False
         Width           =   855
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Copyrighter"
         Height          =   195
         Left            =   1440
         TabIndex        =   8
         Top             =   1680
         Width           =   795
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

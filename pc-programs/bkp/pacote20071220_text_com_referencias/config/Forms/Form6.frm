VERSION 5.00
Begin VB.Form Form6 
   Caption         =   "Config - Section's database"
   ClientHeight    =   5460
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7710
   LinkTopic       =   "Form1"
   ScaleHeight     =   5460
   ScaleWidth      =   7710
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame4 
      Caption         =   "To view section's list "
      Height          =   1335
      Index           =   1
      Left            =   240
      TabIndex        =   20
      Top             =   2520
      Width           =   7215
      Begin VB.ListBox List1 
         Height          =   645
         Left            =   2280
         TabIndex        =   23
         Top             =   480
         Width           =   4815
      End
      Begin VB.ComboBox Combo2 
         Height          =   315
         Index           =   1
         Left            =   120
         TabIndex        =   21
         Text            =   "Combo2"
         Top             =   480
         Width           =   1935
      End
      Begin VB.Label Label8 
         Caption         =   "Code and title of the section"
         Height          =   255
         Index           =   1
         Left            =   2280
         TabIndex        =   24
         Top             =   240
         Width           =   2055
      End
      Begin VB.Label Label7 
         Caption         =   "Idiom"
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   22
         Top             =   240
         Width           =   495
      End
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Help"
      Height          =   375
      Index           =   3
      Left            =   1560
      TabIndex        =   13
      Top             =   5040
      Width           =   615
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Close"
      Height          =   375
      Index           =   2
      Left            =   840
      TabIndex        =   12
      Top             =   5040
      Width           =   615
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Save"
      Height          =   375
      Index           =   1
      Left            =   120
      TabIndex        =   11
      Top             =   5040
      Width           =   615
   End
   Begin VB.TextBox Text3 
      Height          =   285
      Index           =   4
      Left            =   2160
      TabIndex        =   9
      Text            =   "Text3"
      Top             =   2040
      Width           =   4335
   End
   Begin VB.TextBox Text3 
      Height          =   285
      Index           =   2
      Left            =   2160
      TabIndex        =   8
      Text            =   "Text3"
      Top             =   1440
      Width           =   4335
   End
   Begin VB.TextBox Text3 
      Height          =   285
      Index           =   1
      Left            =   2160
      TabIndex        =   7
      Text            =   "Text3"
      Top             =   840
      Width           =   4335
   End
   Begin VB.Frame Frame2 
      Caption         =   "Section edition "
      Height          =   4815
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   7455
      Begin VB.Frame Frame4 
         Caption         =   "To remove a section from the database "
         Height          =   975
         Index           =   0
         Left            =   120
         TabIndex        =   14
         Top             =   3720
         Width           =   7215
         Begin VB.CommandButton Command1 
            Caption         =   "Remove"
            Height          =   375
            Index           =   4
            Left            =   6360
            TabIndex        =   19
            Top             =   360
            Width           =   735
         End
         Begin VB.ComboBox Combo3 
            Height          =   315
            Index           =   0
            Left            =   2160
            TabIndex        =   18
            Text            =   "Combo3"
            Top             =   480
            Width           =   3975
         End
         Begin VB.ComboBox Combo2 
            Height          =   315
            Index           =   0
            Left            =   120
            TabIndex        =   16
            Text            =   "Combo2"
            Top             =   480
            Width           =   1935
         End
         Begin VB.Label Label8 
            Caption         =   "Code and title of the section"
            Height          =   255
            Index           =   0
            Left            =   2160
            TabIndex        =   17
            Top             =   240
            Width           =   2055
         End
         Begin VB.Label Label7 
            Caption         =   "Idiom"
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   15
            Top             =   240
            Width           =   495
         End
      End
      Begin VB.Frame Frame3 
         Caption         =   "To add a section in the database "
         Height          =   2175
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Width           =   7215
         Begin VB.CommandButton Command1 
            Caption         =   "Add "
            Height          =   375
            Index           =   0
            Left            =   6480
            TabIndex        =   10
            Top             =   1080
            Width           =   615
         End
         Begin VB.TextBox Text2 
            Height          =   285
            Left            =   120
            TabIndex        =   6
            Text            =   "RIMTSP0000000"
            Top             =   480
            Width           =   1335
         End
         Begin VB.Label Label6 
            Caption         =   "Spanish title"
            Height          =   255
            Left            =   1920
            TabIndex        =   5
            Top             =   1440
            Width           =   1455
         End
         Begin VB.Label Label5 
            Caption         =   "Portuguese title"
            Height          =   255
            Left            =   1920
            TabIndex        =   4
            Top             =   840
            Width           =   1935
         End
         Begin VB.Label Label4 
            Caption         =   "English title"
            Height          =   255
            Left            =   1920
            TabIndex        =   3
            Top             =   240
            Width           =   1935
         End
         Begin VB.Label Label3 
            Caption         =   "Section code"
            Height          =   255
            Left            =   120
            TabIndex        =   2
            Top             =   240
            Width           =   1095
         End
      End
   End
End
Attribute VB_Name = "Form6"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Text6_Change()

End Sub

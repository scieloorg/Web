VERSION 5.00
Begin VB.Form FormChooseFile 
   ClientHeight    =   4560
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6570
   LinkTopic       =   "Form1"
   ScaleHeight     =   4560
   ScaleWidth      =   6570
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton Command2 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   5520
      TabIndex        =   5
      Top             =   4080
      Width           =   855
   End
   Begin VB.CommandButton Command1 
      Caption         =   "OK"
      Height          =   375
      Left            =   4440
      TabIndex        =   4
      Top             =   4080
      Width           =   855
   End
   Begin VB.Frame FramPer 
      Height          =   3735
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   6375
      Begin VB.TextBox FilePath 
         Height          =   375
         Left            =   120
         TabIndex        =   6
         Top             =   3240
         Width           =   6135
      End
      Begin VB.FileListBox File1 
         Height          =   2625
         Left            =   3240
         TabIndex        =   3
         Top             =   240
         Width           =   3015
      End
      Begin VB.DirListBox Dir1 
         Height          =   1890
         Left            =   120
         TabIndex        =   2
         Top             =   960
         Width           =   3015
      End
      Begin VB.DriveListBox Drive1 
         Height          =   315
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Width           =   3015
      End
   End
End
Attribute VB_Name = "FormChooseFile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private File As String

Private Sub Command1_Click()
    File = FilePath.Text
    Unload Me
End Sub

Private Sub Command2_Click()
    Unload Me
End Sub

Private Sub Dir1_Change()
    File1.Path = Dir1.Path
    FilePath.Text = Dir1.Path
End Sub

Private Sub Drive1_Change()
    Dir1.Path = Drive1.Drive
    FilePath.Text = Drive1.Drive
End Sub

Private Sub File1_Click()
    If Len(File1.FileName) > 0 Then
        FilePath.Text = File1.Path + PathSep + File1.FileName
    Else
        FilePath.Text = File1.Path
    End If
End Sub

Function Choose(CurrPath As String, pattern As String, isdir As Boolean) As String
    Dim p As Long
    If Len(CurrPath) > 0 Then
        Drive1.Drive = Mid(CurrPath, 1, 1)
        p = InStr(CurrPath, "\")
        While p > 0
            Dir1.Path = Mid(CurrPath, 1, p)
            p = InStr(p + 1, CurrPath, "\", vbBinaryCompare)
        Wend
        File1.FileName = CurrPath
    End If
    
    File = Chr(32)
    
    File1.pattern = pattern
    
    If isdir Then File1.Enabled = False
    
    Me.Show vbModal
    
    Choose = File
End Function


VERSION 5.00
Begin VB.Form Issue0 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Config - Open Existing Serial"
   ClientHeight    =   5460
   ClientLeft      =   2040
   ClientTop       =   1620
   ClientWidth     =   7710
   Icon            =   "Issue_0.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   5460
   ScaleWidth      =   7710
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton CmdNext 
      Caption         =   "Next"
      Height          =   375
      Left            =   5400
      TabIndex        =   1
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   6600
      TabIndex        =   2
      Top             =   5040
      Width           =   975
   End
   Begin VB.Frame FrameOpenSerial 
      Caption         =   "Select Serial to Open"
      Height          =   4815
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   7455
      Begin VB.ListBox ListExistingSerial 
         Height          =   4155
         Left            =   120
         Sorted          =   -1  'True
         TabIndex        =   0
         Top             =   360
         Width           =   7215
      End
   End
End
Attribute VB_Name = "Issue0"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CmdClose_Click()
    Unload Me
End Sub

Private Sub CmdNext_Click()
    If Len(ListExistingSerial.Text) > 0 Then
        Call Issue1.OpenIssue(ListExistingSerial.Text)
    Else
        MsgBox ConfigLabels.Select_to_Open
    End If
End Sub

Sub OpenExistingSerial()
    
    With ConfigLabels
    Caption = App.Title + " - " + .mnSerialIssues
    FrameOpenSerial.Caption = .Select_to_Open
    CmdNext.Caption = .ButtonOpen
    CmdClose.Caption = .ButtonClose
    End With
    
    Call Serial_GetExisting(ListExistingSerial)
    Show vbModal
End Sub

Private Sub Form_Load()
    MousePointer = vbHourglass
    'UpdateIssueTable
    MousePointer = vbArrow
End Sub

Private Sub Form_Unload(Cancel As Integer)
    UpdateIssueTable
End Sub

Private Function UpdateIssueTable() As Boolean
    Dim j As Long
    Dim result As String
    Dim fn As Long
    Dim fn2 As Long
    Dim i As Long
    Dim Mfns() As Long
    Dim q As Long
    Dim pft As String
    Dim originalPft As String
    Dim configuredPft As String
    
    MousePointer = vbHourglass
    
    fn = 2
    fn2 = 3
    With Paths("Markup Issue Table")
    q = BDIssues.MfnFind("MKPDONE=0", Mfns)
    
    If q > 0 Then
        
        For i = 1 To IdiomsInfo.Count
        
            originalPft = IdiomsInfo(i).Code + "_" + Paths("Markup Issue Table Format").filename
            configuredPft = "cfg_" + originalPft
   
            Call ConfigurePft(originalPft, configuredPft, "c:\scielo\code\code", Paths("Code Database").path + "\" + Paths("Code Database").filename)
            
    
            Open .path + "\" + IdiomsInfo(i).Code + "_" + .filename For Output As fn
            For j = 1 To q
                result = BDIssues.UsePft(Mfns(j), "@" + configuredPft)
                If Len(result) > 0 Then Print #fn, result
            Next
            Close fn
        Next
    End If
    End With
    MousePointer = vbArrow
End Function
Private Function ConfigurePft(originalPft As String, configuredPft As String, find As String, newPath As String) As Boolean

    Dim Content As String
    
    Dim i As Long
    Dim fn As Long
    Dim fn2 As Long
    

        fn = 2
    
            Open originalPft For Input As fn
            Content = Input(LOF(fn), fn)
            Close fn
            
            Content = Replace(Content, find, newPath)
            
            Open configuredPft For Output As fn
            Print #fn, Content
            Close fn
            
        
    ConfigurePft = True
End Function


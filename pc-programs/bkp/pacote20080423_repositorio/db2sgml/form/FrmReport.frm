VERSION 5.00
Begin VB.Form FrmReport 
   Caption         =   "Report"
   ClientHeight    =   6105
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9420
   Icon            =   "FrmReport.frx":0000
   LinkTopic       =   "Form2"
   ScaleHeight     =   6105
   ScaleWidth      =   9420
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame Frame1 
      Caption         =   "Report"
      Height          =   6015
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   9375
      Begin VB.CommandButton CmdClose 
         Caption         =   "Close"
         Height          =   375
         Left            =   8280
         TabIndex        =   4
         Top             =   5520
         Width           =   855
      End
      Begin VB.TextBox TxtReport 
         Height          =   4965
         Left            =   120
         Locked          =   -1  'True
         MultiLine       =   -1  'True
         ScrollBars      =   1  'Horizontal
         TabIndex        =   3
         Top             =   360
         Width           =   9135
      End
      Begin VB.CommandButton CmdPrint 
         Caption         =   "Print"
         Height          =   375
         Left            =   7200
         TabIndex        =   2
         Top             =   5520
         Width           =   855
      End
      Begin VB.ListBox List1 
         Height          =   255
         Left            =   120
         Sorted          =   -1  'True
         TabIndex        =   1
         Top             =   5520
         Visible         =   0   'False
         Width           =   735
      End
   End
End
Attribute VB_Name = "FrmReport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Sub ShowReport(ReportPath As String, ReportFile As String)
    Dim Label As String
    Dim DocCount As Long
    Dim report As String
    Dim fn As Long
    Dim i As Long
    
    
    fn = 1
    Open ReportPath + PathSep + ReportFile For Input As fn
    
    List1.Clear
    TxtReport.Text = ""
    
    While Not EOF(fn)
        i = i + 1
        Line Input #fn, report
        If i > 3 Then
            List1.AddItem report
        Else
            If Len(report) > 0 Then TxtReport.Text = TxtReport.Text + report + vbCrLf
        End If
    Wend
    Close fn
    report = TxtReport.Text
    
    
    For i = 0 To List1.ListCount - 1
        TxtReport.Text = TxtReport.Text + List1.List(i) + vbCrLf
    Next
    
    Open ReportPath + PathSep + ReportFile For Output As fn
    Print #fn, report
    For i = 0 To List1.ListCount - 1
        Print #fn, List1.List(i)
    Next
    Close fn
    Show vbModal
End Sub

Private Sub CmdClose_Click()
    Unload Me
End Sub

Private Sub CmdPrint_Click()
    Dim i As Long
    
    For i = 0 To List1.ListCount - 1
        Printer.Print List1.List(i)
    Next
    Printer.EndDoc
End Sub


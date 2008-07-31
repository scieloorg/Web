VERSION 5.00
Begin VB.Form FrmRmSerial 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Config - Remove Serial"
   ClientHeight    =   5460
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7710
   Icon            =   "RmSerial.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   5460
   ScaleWidth      =   7710
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton CmdRem 
      Caption         =   "Next"
      Height          =   375
      Left            =   5400
      TabIndex        =   3
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton CmdClose 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   6600
      TabIndex        =   2
      Top             =   5040
      Width           =   975
   End
   Begin VB.Frame FrameRmSerial 
      Caption         =   "Select the serials to remove"
      Height          =   4815
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   7455
      Begin VB.ListBox ListExistingSerial 
         Height          =   4110
         Left            =   120
         Sorted          =   -1  'True
         Style           =   1  'Checkbox
         TabIndex        =   1
         Top             =   360
         Width           =   7215
      End
   End
End
Attribute VB_Name = "FrmRmSerial"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CmdClose_Click()
    Unload Me
End Sub

Sub OpenExistingSerial()
    
    With ConfigLabels
    Caption = App.Title + " - " + .mnRemoveSerial
    FrameRmSerial.Caption = .Select_to_Remove
    CmdRem.Caption = ConfigLabels.ButtonRemove
    CmdClose.Caption = ConfigLabels.ButtonClose
    End With
    
    Call Serial_GetExisting(ListExistingSerial)
    Show vbModal
End Sub

Private Sub Cmdrem_Click()
    Dim i As Long
    Dim Mfns() As Long
    Dim q As Long
    
    If ListExistingSerial.SelCount = 0 Then
        MsgBox ConfigLabels.Select_to_Open
    Else
        For i = 0 To ListExistingSerial.ListCount - 1
            If ListExistingSerial.Selected(i) Then
                ListExistingSerial.Selected(i) = False
                If MsgBox(ConfigLabels.MsgRemoveSerial + " " + ListExistingSerial.List(i) + "?", vbYesNo + vbDefaultButton2) = vbNo Then
                    q = q + 1
                    ReDim Preserve Mfns(q)
                    Mfns(q) = Serial_CheckExisting(ListExistingSerial.List(i))
                End If
            Else
                q = q + 1
                ReDim Preserve Mfns(q)
                Mfns(q) = Serial_CheckExisting(ListExistingSerial.List(i))
            End If
        Next
        MousePointer = vbHourglass
        Call Serial_Remove(Mfns, q)
        Call Serial_GetExisting(ListExistingSerial)
        MousePointer = vbArrow
    End If
End Sub


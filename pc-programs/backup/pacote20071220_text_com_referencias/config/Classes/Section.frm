VERSION 5.00
Begin VB.Form FrmSection 
   Caption         =   "Section"
   ClientHeight    =   4770
   ClientLeft      =   1680
   ClientTop       =   945
   ClientWidth     =   6045
   Icon            =   "Section.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   4770
   ScaleWidth      =   6045
   Begin VB.Frame FramSum 
      Caption         =   "Sections of this serial"
      Height          =   4575
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   5775
      Begin VB.CommandButton CmdSave 
         Caption         =   "Save"
         Height          =   375
         Left            =   5040
         TabIndex        =   14
         Top             =   360
         Width           =   615
      End
      Begin VB.ListBox DispoSecTitle 
         Height          =   1035
         Index           =   3
         ItemData        =   "Section.frx":030A
         Left            =   120
         List            =   "Section.frx":0311
         Sorted          =   -1  'True
         TabIndex        =   9
         Top             =   3360
         Width           =   2655
      End
      Begin VB.ComboBox DispoSecCode 
         Height          =   315
         Left            =   1320
         Sorted          =   -1  'True
         TabIndex        =   8
         Text            =   "DispoSecCode"
         Top             =   360
         Width           =   1815
      End
      Begin VB.TextBox NewSecTitle 
         Height          =   285
         Index           =   3
         Left            =   120
         TabIndex        =   3
         Top             =   3000
         Width           =   2655
      End
      Begin VB.ListBox DispoSecTitle 
         Height          =   1035
         Index           =   1
         ItemData        =   "Section.frx":0324
         Left            =   120
         List            =   "Section.frx":032B
         Sorted          =   -1  'True
         TabIndex        =   7
         Top             =   1440
         Width           =   2775
      End
      Begin VB.TextBox NewSecTitle 
         Height          =   285
         Index           =   1
         Left            =   120
         TabIndex        =   1
         Top             =   1080
         Width           =   2775
      End
      Begin VB.ListBox DispoSecTitle 
         Height          =   1035
         Index           =   2
         ItemData        =   "Section.frx":033E
         Left            =   3000
         List            =   "Section.frx":0345
         Sorted          =   -1  'True
         TabIndex        =   6
         Top             =   1440
         Width           =   2655
      End
      Begin VB.TextBox NewSecTitle 
         Height          =   285
         Index           =   2
         Left            =   3000
         TabIndex        =   2
         Top             =   1080
         Width           =   2655
      End
      Begin VB.CommandButton Add 
         Caption         =   "Add"
         Height          =   375
         Left            =   3360
         TabIndex        =   5
         Top             =   360
         Width           =   615
      End
      Begin VB.CommandButton Del 
         Caption         =   "Delete"
         Height          =   375
         Left            =   4080
         TabIndex        =   4
         Top             =   360
         Width           =   615
      End
      Begin VB.Label Label10 
         Caption         =   "Section Codes"
         Height          =   255
         Left            =   120
         TabIndex        =   13
         Top             =   360
         Width           =   1095
      End
      Begin VB.Label LabIdiom 
         Caption         =   "English"
         Height          =   255
         Index           =   3
         Left            =   120
         TabIndex        =   12
         Top             =   2760
         Width           =   1455
      End
      Begin VB.Label LabIdiom 
         Caption         =   "Spanish"
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   11
         Top             =   840
         Width           =   1455
      End
      Begin VB.Label LabIdiom 
         Caption         =   "Portuguese"
         Height          =   255
         Index           =   2
         Left            =   3000
         TabIndex        =   10
         Top             =   840
         Width           =   1455
      End
   End
End
Attribute VB_Name = "FrmSection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private EnableToChange As Long

Public Sub LoadDispoSections(issn As String)
    Dim i As Long
    Dim s As String
    Dim p As Long
    Dim p0 As Long
    Dim section As String
    Dim mfn As Long
    
    mfn = DBSection.MfnFindOne(issn)
    
    Del.Enabled = False
    CmdSave.Enabled = False
    
    DispoSecCode.Clear
    
    For i = 1 To IdiomsInfo.Count
        DispoSecTitle(i).Clear
        LabIdiom(i).Caption = IdiomsInfo(i).Label
        
        s = DBSection.UsePft(mfn, "(if v49^l='" + IdiomsInfo(i).Code + "' then v49^c|-|,v49^t|;| fi)")
        
        p0 = 1
        p = InStr(s, ";")
        While p > 0
            section = Mid(s, p0, p - p0)
            DispoSecTitle(i).AddItem section
            DispoSecCodeAdditem (Mid(section, 1, InStr(section, "-") - 1))
            p0 = p + 1
            p = InStr(p0, s, ";", vbBinaryCompare)
        Wend
        
    Next
    EnableToChange = DispoSecCode.ListCount
    Show vbModal
    
End Sub

Private Function SaveSection(SerialId As String) As Boolean
    Dim ToCRecord As String
    Dim i As Long
    Dim j As Long
    Dim mfn As Long
    
    ToCRecord = ToCRecord + TagContent(FrmIssue.TxtISSN.Caption, 35)
    ToCRecord = ToCRecord + TagContent(FrmIssue.TxtStitle.Caption, 30)
    ToCRecord = ToCRecord + TagContent(FrmIssue.SiglaPeriodico, 930)
    
    For i = 1 To IdiomsInfo.Count
        ToCRecord = ToCRecord + "<48>^l" + IdiomsInfo(i).Code + "^h" + IdiomsInfo(i).More + "</48>"
        For j = 1 To DispoSecTitle(i).ListCount
            ToCRecord = ToCRecord + "<49>^l" + IdiomsInfo(i).Code + "^c" + Mid(DispoSecTitle(i).List(j - 1), 1, InStr(DispoSecTitle(i).List(j - 1), "-") - 1) + "^t" + Mid(DispoSecTitle(i).List(j - 1), InStr(DispoSecTitle(i).List(j - 1), "-") + 1) + "</49>"
        Next
    Next
    
    mfn = DBSection.MfnFindOne(SerialId)
    If mfn > 0 Then
        If DBSection.RecordUpdate(mfn, ToCRecord) Then
            Call DBSection.IfUpdate(mfn, mfn)
        End If
    Else
        mfn = DBSection.RecordSave(ToCRecord)
        If mfn > 0 Then Call DBSection.IfUpdate(mfn, mfn)
    End If
    
    SaveSection = True
End Function

Private Sub DispoSecCodeAdditem(Value As String)
    Dim i As Long
    Dim found As Boolean
    
    While (i < DispoSecCode.ListCount) And (Not found)
        If StrComp(DispoSecCode.List(i), Value, vbBinaryCompare) = 0 Then
            found = True
        End If
        i = i + 1
    Wend
    If Not found Then
        DispoSecCode.AddItem Value
    End If
    
End Sub

Private Sub DispoSeccodeDel(Value As String)
    Dim i As Long
    Dim found As Boolean
    
    While (i < DispoSecCode.ListCount) And (Not found)
        If StrComp(DispoSecCode.List(i), Value, vbBinaryCompare) = 0 Then
            DispoSecCode.RemoveItem i
            found = True
        End If
        i = i + 1
    Wend
End Sub

Private Sub Add_Click()
    Dim i As Long
    Dim j As Long
    Dim found As Boolean
    
    If Len(DispoSecCode.Text) > 0 Then
        j = 0
        found = False
        While (j < DispoSecCode.ListCount) And (Not found)
            If StrComp(DispoSecCode.List(j), DispoSecCode.Text, vbBinaryCompare) = 0 Then
                found = True
            Else
                j = j + 1
            End If
        Wend
        
        If found Then
            MsgBox "Read Only section code/title."
        Else
            DispoSecCodeAdditem (DispoSecCode.Text)
            For i = 1 To IdiomsInfo.Count
                If Len(NewSecTitle(i).Text) > 0 Then
                    DispoSecTitle(i).AddItem DispoSecCode.Text + "-" + NewSecTitle(i).Text
                    Del.Enabled = True
                    CmdSave.Enabled = True
                End If
                NewSecTitle(i).Text = ""
            Next
        End If
    Else
        MsgBox "Invalid section code."
    End If

End Sub

Private Sub CmdSave_Click()
    SaveSection (FrmIssue.TxtISSN.Caption)
End Sub

Private Sub Del_Click()
    Dim i As Long
    Dim j As Long
    Dim found As Boolean
    
    j = EnableToChange
    found = False
    While (j < DispoSecCode.ListCount) And (Not found)
        If InStr(DispoSecCode.List(j), DispoSecCode.Text) > 0 Then
            found = True
        Else
            j = j + 1
        End If
    Wend
    If found Then
        If MsgBox("Delete the section titles which code is " + DispoSecCode.Text + "?", vbYesNo) = vbYes Then
            For i = 1 To IdiomsInfo.Count
                j = 0
                found = False
                While (j < DispoSecTitle(i).ListCount) And (Not found)
                    If InStr(DispoSecTitle(i).List(j), DispoSecCode.Text) > 0 Then
                        NewSecTitle(i).Text = Mid(DispoSecTitle(i).List(j), Len(DispoSecCode.Text) + 2)
                        DispoSecTitle(i).RemoveItem j
                        found = True
                    End If
                    j = j + 1
                Wend
            Next
            DispoSeccodeDel (DispoSecCode.Text)
        End If
    Else
        MsgBox ("Read only section titles.")
    End If
End Sub


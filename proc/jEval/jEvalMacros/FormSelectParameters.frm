VERSION 5.00
Begin VB.Form FormSelectParameters 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Excel generator for Journal Evaluation"
   ClientHeight    =   8340
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   7560
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   8340
   ScaleWidth      =   7560
   StartUpPosition =   3  'Windows Default
   Visible         =   0   'False
   Begin VB.CommandButton CommandHelp 
      Caption         =   "?"
      Height          =   495
      Index           =   3
      Left            =   6360
      TabIndex        =   16
      Top             =   3000
      Width           =   375
   End
   Begin VB.CommandButton CommandHelp 
      Caption         =   "?"
      Height          =   495
      Index           =   2
      Left            =   6360
      TabIndex        =   15
      Top             =   3720
      Width           =   375
   End
   Begin VB.CommandButton CommandHelp 
      Caption         =   "?"
      Height          =   495
      Index           =   1
      Left            =   6960
      TabIndex        =   14
      Top             =   1440
      Width           =   375
   End
   Begin VB.CommandButton CommandHelp 
      Caption         =   "?"
      Height          =   495
      Index           =   0
      Left            =   6960
      TabIndex        =   13
      Top             =   600
      Width           =   375
   End
   Begin VB.TextBox text_formName 
      Height          =   285
      Left            =   240
      TabIndex        =   4
      Top             =   3840
      Width           =   6015
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Left            =   240
      TabIndex        =   5
      Top             =   3120
      Width           =   6015
   End
   Begin VB.TextBox Text1 
      Height          =   3015
      Left            =   240
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   8
      Top             =   5040
      Width           =   7095
   End
   Begin VB.CommandButton CommandCancel 
      Caption         =   "Close"
      Height          =   495
      Left            =   6120
      TabIndex        =   7
      Top             =   4320
      Width           =   1215
   End
   Begin VB.CommandButton CommandOK 
      Caption         =   "OK"
      Height          =   495
      Left            =   4800
      Style           =   1  'Graphical
      TabIndex        =   6
      Top             =   4320
      Width           =   1215
   End
   Begin VB.CommandButton CommandDest 
      Caption         =   "..."
      Height          =   495
      Left            =   6360
      TabIndex        =   3
      Top             =   1440
      Width           =   495
   End
   Begin VB.TextBox text_dest_path 
      Height          =   375
      Left            =   240
      TabIndex        =   2
      Top             =   1440
      Width           =   6015
   End
   Begin VB.CommandButton CommandSrc 
      Caption         =   "..."
      Height          =   495
      Left            =   6360
      TabIndex        =   1
      Top             =   600
      Width           =   495
   End
   Begin VB.TextBox text_source_path 
      Height          =   375
      Left            =   240
      TabIndex        =   0
      Top             =   600
      Width           =   6015
   End
   Begin VB.Label Label5 
      Caption         =   "File name of the form"
      Height          =   255
      Left            =   240
      TabIndex        =   12
      Top             =   3600
      Width           =   6135
   End
   Begin VB.Label Label3 
      Caption         =   "Pattern for Excel file name"
      Height          =   375
      Left            =   240
      TabIndex        =   11
      Top             =   2760
      Width           =   6015
   End
   Begin VB.Label Label2 
      Caption         =   "Path of Excel files generated"
      Height          =   375
      Left            =   240
      TabIndex        =   10
      Top             =   1200
      Width           =   6015
   End
   Begin VB.Label Label1 
      Caption         =   "Path of source data"
      Height          =   255
      Left            =   240
      TabIndex        =   9
      Top             =   360
      Width           =   6015
   End
End
Attribute VB_Name = "FormSelectParameters"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Sub showHelp(index As Long)
    'Combo1.AddItem ("<ACRON>\<ACRON>_<" & abels.itemById("FORM_NAME").label & ">.xls")
    'Combo1.AddItem ("<ACRON>\<" & abels.itemById("FORM_NAME").label & ">.xls")
    'Combo1.AddItem ("<ACRON>_<" & abels.itemById("FORM_NAME").label & ">.xls")
    Select Case index
    Case 0
        'Label4.Caption = "Create a folder named as the acron. Inside it, create an Excel file which name is formed by the acronym + _ + form name "
        MsgBox labels.itemById("PATTERN1").label
    Case 1
        MsgBox labels.itemById("PATTERN2").label '"Create a folder named as the acron. Inside it, create an Excel file which name is the form name "
    Case 2
        MsgBox labels.itemById("PATTERN3").label '"Create an Excel file which name is formed by the acronym + _ + form name "
    End Select
    
End Sub

Function displayHelp4() As String
    'Combo1.AddItem ("<ACRON>\<ACRON>_<" & abels.itemById("FORM_NAME").label & ">.xls")
    'Combo1.AddItem ("<ACRON>\<" & abels.itemById("FORM_NAME").label & ">.xls")
    'Combo1.AddItem ("<ACRON>_<" & abels.itemById("FORM_NAME").label & ">.xls")
    
    Dim t As String
    
    t = labels.itemById("HELP3").label & vbCrLf & vbCrLf
    
    t = t & "<ACRON>\<ACRON>_<" & labels.itemById("FORM_NAME").label & ">.xls" & vbCrLf
    t = t & " " & labels.itemById("PATTERN1").label & vbCrLf & vbCrLf
    t = t & "<ACRON>\<" & labels.itemById("FORM_NAME").label & ">.xls" & vbCrLf
    t = t & " " & labels.itemById("PATTERN2").label & vbCrLf & vbCrLf
    t = t & "<ACRON>_<" & labels.itemById("FORM_NAME").label & ">.xls" & vbCrLf
    t = t & " " & labels.itemById("PATTERN3").label & vbCrLf
    
    
    MsgBox t
End Function

Private Sub CommandCancel_Click()
    Unload Me
    Unload FormSelectDir
    
End Sub

Private Sub CommandDest_Click()
FormSelectDir.Dir1.Path = text_dest_path.Text
    FormSelectDir.Show vbModal
    text_dest_path.Text = FormSelectDir.selectedpath
End Sub

Private Sub CommandHelp_Click(index As Integer)
    If index > 2 Then
        'Call showHelp(Combo1.ListIndex)
        displayHelp4
    Else
        Call MsgBox(labels.itemById("HELP" & CStr(index)).label, vbInformation)
    End If
End Sub

Private Sub CommandOK_Click()
    If Len(text_dest_path.Text) > 0 Then
        If Len(text_source_path.Text) > 0 Then
            text_formName.Text = Trim(text_formName.Text)
            If text_formName.Text = "" Then
                text_formName.Text = "form_desempenho"
            End If
            If InStr(text_formName.Text, " ") > 0 Then
                text_formName.Text = Replace(text_formName.Text, " ", "-")
            End If
            If InStr(text_formName.Text, ".xls") = 0 Then
                text_formName.Text = text_formName.Text & ".xls"
            End If
        
            Call callMacro(text_source_path.Text, text_dest_path.Text, text_formName.Text, Combo1.ListIndex)
            
            'Unload FormSelectDir
        Else
            text_source_path.SetFocus
        End If
    Else
        text_dest_path.SetFocus
    End If
End Sub

Private Sub CommandSrc_Click()
    FormSelectDir.Dir1.Path = text_source_path.Text
    FormSelectDir.Show vbModal
    text_source_path.Text = FormSelectDir.selectedpath
    
End Sub

Sub callMacro(source_path As String, dest_path As String, formName As String, index As Long)
   ' Declare variables.
   
   ' Run the macro Receiver and pass the variables to the
   ' subroutine.
   ' On a Macintosh computer, you may need to omit the .xls file
   ' extension.
    Dim acron As String
    Dim fname As String
    Dim msgError As String
    Dim c As New Collection
    Dim item As Variant
    On Error Resume Next
    MkDir (dest_path)
    
    source_path = source_path & "\"
    dest_path = dest_path & "\"
    
    acron = Dir(source_path, vbDirectory)     ' Retrieve the first entry.
    Do While acron <> ""   ' Start the loop.
      ' Use bitwise comparison to make sure acron is a directory.
      If (GetAttr(source_path & acron) And vbDirectory) = vbDirectory Then
         ' Display entry only if it's a directory.
         If acron <> "." And acron <> ".." Then
            Call c.add(acron)
         End If
      End If
      acron = Dir()   ' Get next entry.
    Loop
    
    For Each item In c
        acron = item
        Select Case index
        Case 0
           fname = dest_path & acron & "\" & acron & "_" & formName
           MkDir (dest_path & acron)
        Case 1
           fname = dest_path & acron & "\" & formName
           MkDir (dest_path & acron)
        Case 2
           fname = dest_path & acron & "_" & formName
        End Select
        
        Text1.Text = Text1.Text & "Generating " & fname
        If executeMacro(source_path & acron, fname, msgError) Then
            Text1.Text = Text1.Text & ": " & labels.itemById("done").label
        Else
            Text1.Text = Text1.Text & ": " & labels.itemById("failure").label
        End If
        Text1.Text = Text1.Text & vbCrLf
    Next item
    
    
    Text1.Text = Text1.Text & "------------- END -----------------" & vbCrLf

   
   
End Sub

Private Sub Form_Load()
    
    Label1.Caption = labels.itemById("LABEL_SRC_PATH").label
    Label2.Caption = labels.itemById("LABEL_DEST_PATH").label
    Label3.Caption = labels.itemById("LABEL_DEST_PATTERN").label
    Label5.Caption = labels.itemById("LABEL_FORM_NAME_PATH").label
    
    
    
    Combo1.Clear
    
    Call Combo1.AddItem("<ACRON>\<ACRON>_<" & labels.itemById("FORM_NAME").label & ">.xls", 0)
    Call Combo1.AddItem("<ACRON>\<" & labels.itemById("FORM_NAME").label & ">.xls", 1)
    Call Combo1.AddItem("<ACRON>_<" & labels.itemById("FORM_NAME").label & ">.xls", 2)
    Combo1.ListIndex = 0
    
End Sub


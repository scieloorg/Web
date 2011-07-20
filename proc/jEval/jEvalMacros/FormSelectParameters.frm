VERSION 5.00
Begin VB.Form FormSelectParameters 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Excel generator for Journal Evaluation"
   ClientHeight    =   10890
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   7560
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   10890
   ScaleWidth      =   7560
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame FrameSrc 
      Caption         =   "Origem dos dados"
      Height          =   1935
      Left            =   120
      TabIndex        =   14
      Top             =   240
      Width           =   7335
      Begin VB.CommandButton CommandHelp 
         Caption         =   "?"
         Height          =   495
         Index           =   1
         Left            =   6840
         TabIndex        =   21
         Top             =   1200
         Width           =   375
      End
      Begin VB.CommandButton CommandSrcExcel 
         Caption         =   "..."
         Height          =   495
         Left            =   6240
         TabIndex        =   20
         Top             =   1200
         Width           =   495
      End
      Begin VB.TextBox text_src_excel 
         Height          =   375
         Left            =   120
         TabIndex        =   19
         Top             =   1320
         Width           =   6015
      End
      Begin VB.CommandButton CommandHelp 
         Caption         =   "?"
         Height          =   495
         Index           =   0
         Left            =   6840
         TabIndex        =   17
         Top             =   480
         Width           =   375
      End
      Begin VB.CommandButton CommandSrc 
         Caption         =   "..."
         Height          =   495
         Left            =   6240
         TabIndex        =   16
         Top             =   480
         Width           =   495
      End
      Begin VB.TextBox Text_source_path 
         Height          =   375
         Left            =   120
         TabIndex        =   15
         Top             =   600
         Width           =   6015
      End
      Begin VB.Label Label8 
         Caption         =   "Path of Excel files generated"
         Height          =   375
         Left            =   120
         TabIndex        =   22
         Top             =   1080
         Width           =   6015
      End
      Begin VB.Label Label1 
         Caption         =   "Path of Excel files generated"
         Height          =   375
         Left            =   120
         TabIndex        =   18
         Top             =   360
         Width           =   6015
      End
   End
   Begin VB.TextBox Text1 
      Height          =   4215
      Left            =   240
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   2
      Top             =   6360
      Width           =   7095
   End
   Begin VB.CommandButton CommandCancel 
      Caption         =   "Close"
      Height          =   495
      Left            =   6120
      TabIndex        =   1
      Top             =   5640
      Width           =   1215
   End
   Begin VB.CommandButton CommandOK 
      Caption         =   "OK"
      Height          =   495
      Left            =   4800
      Style           =   1  'Graphical
      TabIndex        =   0
      Top             =   5640
      Width           =   1215
   End
   Begin VB.Frame FrameDest 
      Caption         =   "Dados Gerados"
      Height          =   2775
      Left            =   120
      TabIndex        =   3
      Top             =   2640
      Width           =   7335
      Begin VB.TextBox text_dest_path 
         Height          =   375
         Left            =   120
         TabIndex        =   10
         Top             =   480
         Width           =   6015
      End
      Begin VB.CommandButton CommandDest 
         Caption         =   "..."
         Height          =   495
         Left            =   6240
         TabIndex        =   9
         Top             =   480
         Width           =   495
      End
      Begin VB.ComboBox Combo1 
         Height          =   315
         Left            =   120
         TabIndex        =   8
         Top             =   1440
         Width           =   6015
      End
      Begin VB.TextBox text_formName 
         Height          =   285
         Left            =   120
         TabIndex        =   7
         Top             =   2160
         Width           =   6015
      End
      Begin VB.CommandButton CommandHelp 
         Caption         =   "?"
         Height          =   495
         Index           =   3
         Left            =   6840
         TabIndex        =   6
         Top             =   480
         Width           =   375
      End
      Begin VB.CommandButton CommandHelp 
         Caption         =   "?"
         Height          =   495
         Index           =   2
         Left            =   6240
         TabIndex        =   5
         Top             =   2040
         Width           =   375
      End
      Begin VB.CommandButton CommandHelp 
         Caption         =   "?"
         Height          =   495
         Index           =   4
         Left            =   6240
         TabIndex        =   4
         Top             =   1320
         Width           =   375
      End
      Begin VB.Label Label2 
         Caption         =   "Path of Excel files generated"
         Height          =   375
         Left            =   120
         TabIndex        =   13
         Top             =   240
         Width           =   6015
      End
      Begin VB.Label Label3 
         Caption         =   "Pattern for Excel file name"
         Height          =   375
         Left            =   120
         TabIndex        =   12
         Top             =   1080
         Width           =   6015
      End
      Begin VB.Label Label5 
         Caption         =   "File name of the form"
         Height          =   255
         Left            =   120
         TabIndex        =   11
         Top             =   1920
         Width           =   6135
      End
   End
End
Attribute VB_Name = "FormSelectParameters"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Sub showHelp(Index As Long)
    'Combo1.AddItem ("<ACRON>\<ACRON>_<" & abels.itemById("FORM_NAME").label & ">.xls")
    'Combo1.AddItem ("<ACRON>\<" & abels.itemById("FORM_NAME").label & ">.xls")
    'Combo1.AddItem ("<ACRON>_<" & abels.itemById("FORM_NAME").label & ">.xls")
    Select Case Index
    Case 0
        'Label4.Caption = "Create a folder named as the acron. Inside it, create an Excel file which name is formed by the acronym + _ + form name "
        MsgBox labels.itemById("PATTERN1").label
    Case 1
        MsgBox labels.itemById("PATTERN2").label '"Create a folder named as the acron. Inside it, create an Excel file which name is the form name "
    Case 2
        MsgBox labels.itemById("PATTERN3").label '"Create an Excel file which name is formed by the acronym + _ + form name "
    End Select
    
End Sub

Function displayHelpPattern() As String
    'Combo1.AddItem ("<ACRON>\<ACRON>_<" & abels.itemById("FORM_NAME").label & ">.xls")
    'Combo1.AddItem ("<ACRON>\<" & abels.itemById("FORM_NAME").label & ">.xls")
    'Combo1.AddItem ("<ACRON>_<" & abels.itemById("FORM_NAME").label & ">.xls")
    
    Dim t As String
    
    t = labels.itemById("HELP_PATTERN").label & vbCrLf & vbCrLf
    
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



Private Sub CommandHelp_Click(Index As Integer)
    If Index > 3 Then
        'Call showHelp(Combo1.ListIndex)
        displayHelpPattern
    Else
        Call MsgBox(labels.itemById("HELP" & CStr(Index)).label, vbInformation)
    End If
End Sub

Private Sub CommandOK_Click()
    If Len(text_dest_path.Text) > 0 Then
        If Len(Text_source_path.Text) > 0 Then
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
        
            Call callMacro(Trim(Text_source_path.Text), Trim(text_dest_path.Text), Trim(text_formName.Text), Combo1.ListIndex, Trim(text_src_excel.Text))
            
            'Unload FormSelectDir
        Else
            Text_source_path.SetFocus
        End If
    Else
        text_dest_path.SetFocus
    End If
End Sub

Private Sub CommandSrc_Click()
    FormSelectDir.Dir1.Path = Text_source_path.Text
    FormSelectDir.Show vbModal
    Text_source_path.Text = FormSelectDir.selectedpath
    
End Sub
Private Sub CommandSrcExcel_Click()
    FormSelectDir.Dir1.Path = Text_source_path.Text
    FormSelectDir.Show vbModal
    text_src_excel.Text = FormSelectDir.selectedpath
    
End Sub

Sub callMacro(ByVal source_path As String, ByVal dest_path As String, ByVal formName As String, Index As Long, ByVal src_excel_path As String)
   ' Declare variables.
   
   ' Run the macro Receiver and pass the variables to the
   ' subroutine.
   ' On a Macintosh computer, you may need to omit the .xls file
   ' extension.
    Dim acron As String
    Dim dest_fname As String
    Dim msgError As String
    Dim c As New Collection
    Dim item As Variant
    Dim excel_src_file As String
    Dim x_excel_src_file As String
    
    On Error Resume Next
    MkDir (dest_path)
    
    source_path = source_path & "\"
    dest_path = dest_path & "\"
    If src_excel_path <> "" Then src_excel_path = src_excel_path & "\"
    
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
        Select Case Index
        Case 0
           dest_fname = dest_path & acron & "\" & acron & "_" & formName
           If src_excel_path <> "" Then excel_src_file = src_excel_path & acron & "\" & acron & "_" & formName
           MkDir (dest_path & acron)
        Case 1
           dest_fname = dest_path & acron & "\" & formName
           If src_excel_path <> "" Then excel_src_file = src_excel_path & acron & "\" & formName
           MkDir (dest_path & acron)
        Case 2
           If src_excel_path <> "" Then excel_src_file = src_excel_path & acron & "_" & formName
           dest_fname = dest_path & acron & "_" & formName
        End Select
        
        
        
        If excel_src_file <> "" Then
            x_excel_src_file = Replace(excel_src_file, ".xls", "_src.xls")
            Call FileCopy(excel_src_file, x_excel_src_file)
        End If
        Text1.Text = Text1.Text & "Generating " & dest_fname
        
        If executeMacro(source_path & acron, dest_fname, msgError, x_excel_src_file) Then
            Text1.Text = Text1.Text & ": " & labels.itemById("done").label
        Else
            Text1.Text = Text1.Text & ": " & labels.itemById("failure").label
        End If
        Text1.Text = Text1.Text & vbCrLf
        
        If excel_src_file <> "" Then Kill x_excel_src_file
    Next item
    
    
    Text1.Text = Text1.Text & "------------- END -----------------" & vbCrLf

   
   
End Sub

Private Sub CommandSrcPath_Click()

End Sub

Private Sub Form_Load()
    Call readConfig
    

    Label1.Caption = labels.itemById("LABEL_SRC_PATH").label
    Label2.Caption = labels.itemById("LABEL_DEST_PATH").label
    Label3.Caption = labels.itemById("LABEL_DEST_PATTERN").label
    Label5.Caption = labels.itemById("LABEL_FORM_NAME_PATH").label
    Label8.Caption = labels.itemById("LABEL_SRC_EXCEL").label
    
    
    Combo1.Clear
    
    Call Combo1.AddItem("<ACRON>\<ACRON>_<" & labels.itemById("FORM_NAME").label & ">.xls", 0)
    Call Combo1.AddItem("<ACRON>\<" & labels.itemById("FORM_NAME").label & ">.xls", 1)
    Call Combo1.AddItem("<ACRON>_<" & labels.itemById("FORM_NAME").label & ">.xls", 2)
    Combo1.ListIndex = 0
    Show vbModal
End Sub


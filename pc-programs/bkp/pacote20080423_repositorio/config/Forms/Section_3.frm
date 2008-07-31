VERSION 5.00
Begin VB.Form Section3 
   Caption         =   "Config - Section's database"
   ClientHeight    =   5460
   ClientLeft      =   1410
   ClientTop       =   1950
   ClientWidth     =   7710
   Icon            =   "Section_3.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5460
   ScaleWidth      =   7710
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame FrameViewSections 
      Caption         =   "To view section's list "
      Height          =   1215
      Left            =   240
      TabIndex        =   15
      Top             =   2520
      Width           =   7215
      Begin VB.ListBox ListSection 
         Height          =   645
         Left            =   2160
         Sorted          =   -1  'True
         TabIndex        =   18
         Top             =   480
         Width           =   4935
      End
      Begin VB.ComboBox ComboIdiom 
         Height          =   315
         Index           =   1
         Left            =   120
         Style           =   2  'Dropdown List
         TabIndex        =   16
         Top             =   480
         Width           =   1935
      End
      Begin VB.Label labListSection 
         AutoSize        =   -1  'True
         Caption         =   "Code and title of the section"
         Height          =   195
         Index           =   1
         Left            =   2160
         TabIndex        =   19
         Top             =   240
         Width           =   1980
      End
      Begin VB.Label LabIdioms 
         AutoSize        =   -1  'True
         Caption         =   "Idiom"
         Height          =   195
         Index           =   1
         Left            =   120
         TabIndex        =   17
         Top             =   240
         Width           =   375
      End
   End
   Begin VB.CommandButton CmdHelp 
      Caption         =   "Help"
      Height          =   375
      Left            =   2520
      TabIndex        =   9
      Top             =   5040
      Width           =   855
   End
   Begin VB.CommandButton CmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   1320
      TabIndex        =   8
      Top             =   5040
      Width           =   855
   End
   Begin VB.CommandButton CmdSave 
      Caption         =   "Save"
      Height          =   375
      Left            =   120
      TabIndex        =   7
      Top             =   5040
      Width           =   855
   End
   Begin VB.Frame FrameSection 
      Caption         =   "Section edition "
      Height          =   4815
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   7455
      Begin VB.Frame FrameRemoveSection 
         Caption         =   "To remove a section from the database "
         Height          =   975
         Left            =   120
         TabIndex        =   10
         Top             =   3720
         Width           =   7215
         Begin VB.CommandButton CmdRem 
            Caption         =   "Remove"
            Height          =   375
            Left            =   6360
            TabIndex        =   14
            Top             =   360
            Width           =   735
         End
         Begin VB.ComboBox ComboSection 
            Height          =   315
            Left            =   2160
            Sorted          =   -1  'True
            Style           =   2  'Dropdown List
            TabIndex        =   13
            Top             =   480
            Width           =   4095
         End
         Begin VB.ComboBox ComboIdiom 
            Height          =   315
            Index           =   2
            Left            =   120
            Style           =   2  'Dropdown List
            TabIndex        =   12
            Top             =   480
            Width           =   1935
         End
         Begin VB.Label labListSection 
            AutoSize        =   -1  'True
            Caption         =   "Code and title of the section"
            Height          =   195
            Index           =   2
            Left            =   2160
            TabIndex        =   23
            Top             =   240
            Width           =   1980
         End
         Begin VB.Label LabIdioms 
            AutoSize        =   -1  'True
            Caption         =   "Idiom"
            Height          =   195
            Index           =   2
            Left            =   120
            TabIndex        =   11
            Top             =   240
            Width           =   375
         End
      End
      Begin VB.Frame FrameAddSection 
         Caption         =   "To add a section in the database "
         Height          =   2055
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Width           =   7215
         Begin VB.ListBox ListLockedCodes 
            Height          =   255
            Left            =   240
            TabIndex        =   31
            Top             =   840
            Visible         =   0   'False
            Width           =   735
         End
         Begin VB.TextBox TxtSiglum 
            Height          =   285
            Left            =   1200
            TabIndex        =   30
            Text            =   "Text3"
            Top             =   1560
            Visible         =   0   'False
            Width           =   495
         End
         Begin VB.TextBox TxtStitle 
            Height          =   285
            Left            =   1200
            TabIndex        =   29
            Text            =   "Text2"
            Top             =   1320
            Visible         =   0   'False
            Width           =   495
         End
         Begin VB.TextBox TxtIssn 
            Height          =   285
            Left            =   1200
            TabIndex        =   28
            Text            =   "Text1"
            Top             =   1080
            Visible         =   0   'False
            Width           =   495
         End
         Begin VB.ListBox ListSec 
            Height          =   255
            Index           =   2
            Left            =   240
            TabIndex        =   26
            Top             =   1320
            Visible         =   0   'False
            Width           =   735
         End
         Begin VB.ListBox ListSec 
            Height          =   255
            Index           =   3
            Left            =   240
            TabIndex        =   25
            Top             =   1560
            Visible         =   0   'False
            Width           =   735
         End
         Begin VB.ListBox ListSec 
            Height          =   255
            Index           =   1
            Left            =   240
            TabIndex        =   24
            Top             =   1080
            Visible         =   0   'False
            Width           =   735
         End
         Begin VB.TextBox TxtSecTitle 
            Height          =   285
            Index           =   1
            Left            =   1920
            TabIndex        =   22
            Text            =   "Text3"
            Top             =   480
            Width           =   4215
         End
         Begin VB.TextBox TxtSecTitle 
            Height          =   285
            Index           =   2
            Left            =   1920
            TabIndex        =   21
            Text            =   "Text3"
            Top             =   1080
            Width           =   4215
         End
         Begin VB.TextBox TxtSecTitle 
            Height          =   285
            Index           =   3
            Left            =   1920
            TabIndex        =   20
            Text            =   "Text3"
            Top             =   1680
            Width           =   4215
         End
         Begin VB.CommandButton CmdAdd 
            Caption         =   "Adiciona"
            Height          =   375
            Left            =   6240
            TabIndex        =   6
            Top             =   1080
            Width           =   855
         End
         Begin VB.ComboBox ComboCode 
            Height          =   315
            Left            =   120
            Sorted          =   -1  'True
            TabIndex        =   27
            Top             =   480
            Width           =   1695
         End
         Begin VB.Label LabIdiom 
            AutoSize        =   -1  'True
            Caption         =   "Spanish title"
            Height          =   195
            Index           =   3
            Left            =   1920
            TabIndex        =   5
            Top             =   1440
            Width           =   855
         End
         Begin VB.Label LabIdiom 
            AutoSize        =   -1  'True
            Caption         =   "Portuguese title"
            Height          =   195
            Index           =   2
            Left            =   1920
            TabIndex        =   4
            Top             =   840
            Width           =   1095
         End
         Begin VB.Label LabIdiom 
            AutoSize        =   -1  'True
            Caption         =   "English title"
            Height          =   195
            Index           =   1
            Left            =   1920
            TabIndex        =   3
            Top             =   240
            Width           =   795
         End
         Begin VB.Label LabSecCode 
            AutoSize        =   -1  'True
            Caption         =   "Section code"
            Height          =   195
            Left            =   120
            TabIndex        =   2
            Top             =   240
            Width           =   945
         End
      End
   End
End
Attribute VB_Name = "Section3"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private MyMfnSection As Long

Sub MySetLabels()
        
    Call FillCombo(ComboIdiom(1), CodeIdiom)
    Call FillCombo(ComboIdiom(2), CodeIdiom)
    
    ComboIdiom(1).ListIndex = 0
    ComboIdiom(2).ListIndex = 0
    
    With ConfigLabels
    FrameAddSection.Caption = .Sec_FrameAddSection
    FrameViewSections.Caption = .Sec_FrameViewSections
    FrameRemoveSection.Caption = .Sec_FrameRemSection
    LabSecCode.Caption = .Sec_SectionCode
    LabIdioms(1).Caption = .Sec_Idiom
    LabIdioms(2).Caption = .Sec_Idiom
    labListSection(1).Caption = .Sec_SectionTitle
    labListSection(2).Caption = .Sec_SectionTitle
    CmdAdd.Caption = .Sec_CmdADD
    CmdRem.Caption = .Sec_CmdRem
    CmdSave.Caption = .ButtonSave
    CmdClose.Caption = .ButtonClose
    CmdHelp.Caption = .mnHelp
    End With
End Sub

Sub MyClearContent()
    Dim i As Long
    
    For i = 1 To IdiomsInfo.Count
        TxtSecTitle(i).Text = ""
        ListSec(i).Clear
        LabIdiom(i).Caption = IdiomsInfo(i).label
    Next

    ComboCode.Clear
    ListSection.Clear
    ComboSection.Clear
    
End Sub

Sub MyGetContentFromBase(MfnSection As Long)

    FillListSec (MfnSection)
    
    FillComboCode (MfnSection)
    FillLockedCodes (MfnSection)
    
    ComboCode.ListIndex = ComboCode.ListCount - 1
    SelectCode
    
    SelectIdiom (1)
    SelectIdiom (2)
    
End Sub

Sub OpenSection(SerialTitle As String)
    Dim MfnTitle As Long
    
    Caption = Caption + " " + SerialTitle
    
    MySetLabels
    MfnTitle = Serial_CheckExisting(SerialTitle)
    If MfnTitle > 0 Then
        TxtIssn.Text = Serial_TxtContent(MfnTitle, 400)
        TxtStitle.Text = Serial_TxtContent(MfnTitle, 150)
        TxtSiglum.Text = Serial_TxtContent(MfnTitle, 930)
        
        MyMfnSection = Section_CheckExisting(TxtSiglum.Text)
        
        MyClearContent
        If MyMfnSection > 0 Then
            MyGetContentFromBase (MyMfnSection)
        End If
    End If
    Show vbModal
End Sub

Private Sub CmdCancel_Click()
    CancelFilling
End Sub

Private Sub CmdAdd_Click()
    Dim i As Long
    
    If Not IsLockedCode(ComboCode.Text) Then
        If Len(ComboCode.Text) > 0 Then
            For i = 1 To IdiomsInfo.Count
                If Len(TxtSecTitle(i).Text) > 0 Then
                    Call ListSec_Add(i, ComboCode.Text, TxtSecTitle(i).Text)
                End If
            Next
        Else
            MsgBox ConfigLabels.MsgInvalidSecCode
        End If
    Else
        MsgBox "Unchangeable Code" + ConfigLabels.MsgUnchangeableCode
    End If
    
End Sub

Private Sub CmdClose_Click()
    Unload Me
End Sub

Private Sub Cmdrem_Click()
    Dim code_to_remove As String
    
    If Len(ComboSection.Text) > 0 Then
        code_to_remove = Mid(ComboSection.Text, 1, InStr(ComboSection.Text, "-") - 1)
        If Not IsLockedCode(code_to_remove) Then
            ListSec_Remove
            Call Code_Rem(code_to_remove)
        Else
            MsgBox "Unchangeable Code " + ConfigLabels.MsgUnchangeableCode
        End If
    End If
End Sub

Private Sub CmdSave_Click()
    MousePointer = vbHourglass
    SaveSection (MyMfnSection)
    MousePointer = vbArrow
End Sub

Sub SelectCode()
    Dim i As Long
    Dim found As Boolean
    
    If Len(ComboCode.Text) > 0 Then
        While (i < ComboCode.ListCount) And (Not found)
            If StrComp(ComboCode.List(i), ComboCode.Text) = 0 Then
                found = True
            End If
            i = i + 1
            Debug.Print ComboCode.List(i)
        Wend
        If found Then
            'Edit section
            'MsgBox ConfigLabels.MsgExistingSection
            For i = 1 To IdiomsInfo.Count
                found = False
                j = 0
                TxtSecTitle(i).Text = ""
                While (j < ListSec(i).ListCount) And (Not found)
                    p = InStr(ListSec(i).List(j), ComboCode.Text)
                    If p > 0 Then
                        found = True
                    Else
                        j = j + 1
                    End If
                Wend
                If found Then TxtSecTitle(i).Text = Mid(ListSec(i).List(j), InStr(ListSec(i).List(j), "-") + 1)
            Next
        End If
    End If
End Sub
Private Sub ComboCode_Change()
    SelectCode
End Sub

Private Sub ComboCode_Click()
    SelectCode
End Sub

Sub SelectIdiom(index As Integer)
    Dim IdxIdiom As Long
    Dim j As Long
    Dim found As Boolean
    
    While (IdxIdiom < ComboIdiom(index).ListCount) And (Not found)
        If StrComp(ComboIdiom(index).List(IdxIdiom), ComboIdiom(index).Text) = 0 Then
            found = True
        End If
        IdxIdiom = IdxIdiom + 1
    Wend
       
    If index = 1 Then
        'view
        ListSection.Clear
        For j = 1 To ListSec(IdxIdiom).ListCount
            ListSection.AddItem ListSec(IdxIdiom).List(j - 1)
        Next
        
    ElseIf index = 2 Then
        ComboSection.Clear
        For j = 1 To ListSec(IdxIdiom).ListCount
            ComboSection.AddItem ListSec(IdxIdiom).List(j - 1)
        Next
        If ListSec(IdxIdiom).ListCount > 0 Then ComboSection.ListIndex = 0
    End If
End Sub

Private Sub ComboIdiom_Click(index As Integer)
    SelectIdiom (index)
End Sub

Private Sub ComboIdiom_Change(index As Integer)
    SelectIdiom (index)
End Sub

Sub FillComboCode(Mfn As Long)
    Dim isisSection As ClIsisDll
    Dim sep As String
    Dim Content As String
    Dim p As Long
        
    Set isisSection = New ClIsisDll
    With FormMenuPrin.DirStruct.Nodes("Section Database")
    If isisSection.Inicia(.Parent.FullPath, .Text, .Key) Then
        sep = "%"
        ComboCode.Clear
        
        Content = isisSection.UsePft(Mfn, "(v49^c,'" + sep + "')")
        If Len(Content) > 0 Then
            p = InStr(Content, sep)
            While p > 0
                Item = Mid(Content, 1, p - 1)
                Code_Add (Item)
                Content = Mid(Content, p + 1)
                p = InStr(Content, sep)
            Wend
        End If
    End If
    End With
End Sub

Sub FillLockedCodes(Mfn As Long)
    Dim isisSection As ClIsisDll
    Dim sep As String
    Dim Content As String
    Dim p As Long
    Dim i As Long
    Dim found As Boolean
    
        
    Set isisSection = New ClIsisDll
    With FormMenuPrin.DirStruct.Nodes("Section Database")
    If isisSection.Inicia(.Parent.FullPath, .Text, .Key) Then
        sep = "%"
        ListLockedCodes.Clear
        
        Content = isisSection.UsePft(Mfn, "(v49^c,'" + sep + "')")
        If Len(Content) > 0 Then
            p = InStr(Content, sep)
            While p > 0
                Item = Mid(Content, 1, p - 1)
                i = 0
                found = False
                While (i < ListLockedCodes.ListCount) And (Not found)
                    If StrComp(ListLockedCodes.List(i), Item) = 0 Then
                        found = True
                    End If
                    i = i + 1
                Wend
                If Not found Then
                    ListLockedCodes.AddItem Item
                End If
                
                Content = Mid(Content, p + 1)
                p = InStr(Content, sep)
            Wend
        End If
    End If
    End With
End Sub

Sub FillListSec(Mfn As Long)
    Dim isisSection As ClIsisDll
    Dim sep As String
    Dim Content As String
    Dim p As Long
    Dim p2 As Long
    Dim Item As String
    Dim i As Long
    
    
    Set isisSection = New ClIsisDll
    With FormMenuPrin.DirStruct.Nodes("Section Database")
    If isisSection.Inicia(.Parent.FullPath, .Text, .Key) Then
        sep = "%"
        
        For i = 1 To IdiomsInfo.Count
            ListSec(i).Clear
        
            Content = isisSection.UsePft(Mfn, "(if v49^l='" + IdiomsInfo(i).Code + "' then v49^c,'-',v49^t,'" + sep + "' fi)")
            If Len(Content) > 0 Then
                p = InStr(Content, sep)
                While p > 0
                    Item = Mid(Content, 1, p - 1)
                    p2 = InStr(Item, "-")
                    Call ListSec_Add(i, Mid(Item, 1, p2 - 1), Mid(Item, p2 + 1))
                
                    Content = Mid(Content, p + 1)
                    p = InStr(Content, sep)
                Wend
            End If
        Next
    End If
    End With
End Sub

Sub ListSec_Add(idx As Long, Code As String, Title As String)
    Dim i As Long
    Dim found As Boolean
    
    If Len(Code) > 0 Then
        If Len(Title) > 0 Then
            i = 0
            found = False
            While (i < ListSec(idx).ListCount) And (Not found)
                If InStr(ListSec(idx).List(i), Code) > 0 Then
                    found = True
                Else
                    i = i + 1
                End If
            Wend
    
            If found Then
                ListSec(idx).RemoveItem (i)
                ListSec(idx).AddItem Code + "-" + Title
            Else
                Code_Add Code
                ListSec(idx).AddItem Code + "-" + Title
            End If
            SelectIdiom (1)
            SelectIdiom (2)
        End If
    Else
        MsgBox ConfigLabels.MsgInvalidSecCode
    End If

End Sub

Sub Code_Add(Code As String)
    Dim i As Long
    Dim found As Boolean
    
    i = 0
    found = False
    While (i < ComboCode.ListCount) And (Not found)
        If StrComp(ComboCode.List(i), Code) = 0 Then
            found = True
        End If
        i = i + 1
    Wend
    If Not found Then
        ComboCode.AddItem Code
    End If
End Sub
Sub Code_Rem(Code As String)
    Dim i As Long
    Dim found As Boolean
    
    i = 0
    found = False
    While (i < ComboCode.ListCount) And (Not found)
        If StrComp(ComboCode.List(i), Code) = 0 Then
            found = True
        Else
            i = i + 1
        End If
    Wend
    If Not found Then
        ComboCode.RemoveItem i
    End If
End Sub

Sub ListSec_Remove()
    Dim i As Long
    Dim found As Boolean
    Dim IdxIdiom As Long
        
    While (IdxIdiom < ComboIdiom(2).ListCount) And (Not found)
        If StrComp(ComboIdiom(2).List(IdxIdiom), ComboIdiom(2).Text) = 0 Then
            found = True
        End If
        IdxIdiom = IdxIdiom + 1
    Wend

            i = 0
            found = False
            While (i < ListSec(IdxIdiom).ListCount) And (Not found)
                If StrComp(ListSec(IdxIdiom).List(i), ComboSection.Text) = 0 Then
                    found = True
                Else
                    i = i + 1
                End If
            Wend
    
            If found Then
                ListSec(IdxIdiom).RemoveItem (i)
                If ComboIdiom(1).Text = ComboIdiom(2).Text Then ListSection.RemoveItem i
                ComboSection.RemoveItem i
            End If
    

End Sub

Private Sub SaveSection(MfnSection As Long)
    Dim isisSection As ClIsisDll
    Dim i As Long
    Dim j As Long
    Dim p As Long
    Dim tmp As String
    Dim reccontent As String
    Dim msgwarning As String
    
    MousePointer = vbHourglass
    
    reccontent = reccontent + TagTxtContent(TxtIssn.Text, 35)
    reccontent = reccontent + TagTxtContent(TxtStitle.Text, 30)
    reccontent = reccontent + TagTxtContent(TxtSiglum.Text, 930)
        
    For i = 1 To IdiomsInfo.Count
        reccontent = reccontent + TagContent("^l" + IdiomsInfo(i).Code + "^h" + IdiomsInfo(i).More, 48)
        For j = 0 To ListSec(i).ListCount - 1
            p = InStr(ListSec(i).List(j), "-")
            reccontent = reccontent + TagContent("^l" + IdiomsInfo(i).Code + "^c" + Mid(ListSec(i).List(j), 1, p - 1) + "^t" + Mid(ListSec(i).List(j), p + 1), 49)
        Next
    Next
            
    Set isisSection = New ClIsisDll
    With FormMenuPrin.DirStruct.Nodes("Section Database")
    If isisSection.Inicia(.Parent.FullPath, .Text, .Key) Then
        Call isisSection.Save(reccontent, MfnSection)
    End If
    End With
    MousePointer = vbArrow
End Sub



Private Function IsLockedCode(Code As String) As Boolean
    Dim i As Long
    Dim found As Boolean
    
    While (i < ListLockedCodes.ListCount) And (Not found)
        If StrComp(ListLockedCodes.List(i), Code) = 0 Then
            found = True
        End If
        i = i + 1
    Wend
    IsLockedCode = found
End Function


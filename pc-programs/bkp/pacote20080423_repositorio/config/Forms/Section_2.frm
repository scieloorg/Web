VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Begin VB.Form New_Section2 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Section"
   ClientHeight    =   5625
   ClientLeft      =   1395
   ClientTop       =   2010
   ClientWidth     =   9045
   Icon            =   "Section_2.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   5625
   ScaleWidth      =   9045
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton CmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   6960
      TabIndex        =   7
      Top             =   5160
      Width           =   855
   End
   Begin VB.CommandButton CmdSave 
      Caption         =   "Save"
      Height          =   375
      Left            =   5880
      TabIndex        =   6
      Top             =   5160
      Width           =   855
   End
   Begin VB.CommandButton CmdAju 
      Caption         =   "Help"
      Height          =   375
      Left            =   8040
      TabIndex        =   8
      Top             =   5160
      Width           =   855
   End
   Begin VB.Frame FramSum 
      Height          =   5055
      Left            =   0
      TabIndex        =   9
      Top             =   0
      Width           =   9015
      Begin VB.Frame FrameSections 
         Caption         =   "Filled Sections"
         Height          =   2775
         Left            =   120
         TabIndex        =   10
         Top             =   240
         Width           =   8775
         Begin ComctlLib.ListView ListView1 
            Height          =   2295
            Left            =   120
            TabIndex        =   21
            Top             =   360
            Width           =   8535
            _ExtentX        =   15055
            _ExtentY        =   4048
            View            =   3
            Sorted          =   -1  'True
            LabelWrap       =   0   'False
            HideSelection   =   -1  'True
            _Version        =   327682
            ForeColor       =   -2147483640
            BackColor       =   -2147483643
            BorderStyle     =   1
            Appearance      =   1
            NumItems        =   4
            BeginProperty ColumnHeader(1) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
               Key             =   ""
               Object.Tag             =   ""
               Text            =   "seccode"
               Object.Width           =   2540
            EndProperty
            BeginProperty ColumnHeader(2) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
               SubItemIndex    =   1
               Key             =   ""
               Object.Tag             =   ""
               Text            =   "idiom 1"
               Object.Width           =   2540
            EndProperty
            BeginProperty ColumnHeader(3) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
               SubItemIndex    =   2
               Key             =   ""
               Object.Tag             =   ""
               Text            =   "idiom 2"
               Object.Width           =   2540
            EndProperty
            BeginProperty ColumnHeader(4) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
               SubItemIndex    =   3
               Key             =   ""
               Object.Tag             =   ""
               Text            =   "idiom 3"
               Object.Width           =   2540
            EndProperty
         End
      End
      Begin VB.TextBox TxtSections 
         BackColor       =   &H00C0C0C0&
         Height          =   2175
         Index           =   3
         Left            =   5880
         Locked          =   -1  'True
         MultiLine       =   -1  'True
         TabIndex        =   16
         Top             =   240
         Visible         =   0   'False
         Width           =   2775
      End
      Begin VB.TextBox TxtSections 
         BackColor       =   &H00C0C0C0&
         Height          =   2175
         Index           =   1
         Left            =   120
         Locked          =   -1  'True
         MultiLine       =   -1  'True
         TabIndex        =   15
         Top             =   240
         Visible         =   0   'False
         Width           =   2775
      End
      Begin VB.TextBox TxtSections 
         BackColor       =   &H00C0C0C0&
         Height          =   2175
         Index           =   2
         Left            =   3000
         Locked          =   -1  'True
         MultiLine       =   -1  'True
         TabIndex        =   14
         Top             =   240
         Visible         =   0   'False
         Width           =   2775
      End
      Begin VB.Frame FrameSectionEdition 
         Caption         =   "Section Edition"
         Height          =   1815
         Left            =   120
         TabIndex        =   11
         Top             =   3120
         Width           =   8775
         Begin VB.TextBox TxtHeader 
            BackColor       =   &H00FFFFFF&
            Height          =   285
            Index           =   3
            Left            =   5880
            TabIndex        =   24
            Top             =   1080
            Width           =   2775
         End
         Begin VB.TextBox TxtHeader 
            BackColor       =   &H00FFFFFF&
            DataField       =   "TxtHeader"
            Height          =   285
            Index           =   2
            Left            =   3000
            TabIndex        =   23
            Top             =   1080
            Width           =   2775
         End
         Begin VB.TextBox TxtHeader 
            BackColor       =   &H00FFFFFF&
            Height          =   285
            Index           =   1
            Left            =   120
            TabIndex        =   22
            Top             =   1080
            Width           =   2775
         End
         Begin VB.ListBox ListLockedCodes 
            Height          =   255
            Left            =   6120
            TabIndex        =   17
            Top             =   240
            Visible         =   0   'False
            Width           =   2415
         End
         Begin VB.TextBox TxtSecCode 
            Height          =   315
            Left            =   1920
            TabIndex        =   0
            Top             =   240
            Width           =   1935
         End
         Begin VB.CommandButton CmdNew 
            Caption         =   "New"
            Height          =   375
            Left            =   3960
            TabIndex        =   4
            Top             =   240
            Width           =   855
         End
         Begin VB.CommandButton CmdDel 
            Caption         =   "Delete"
            Height          =   375
            Left            =   4920
            TabIndex        =   5
            Top             =   240
            Width           =   855
         End
         Begin VB.TextBox TxtSecTit 
            Height          =   285
            Index           =   2
            Left            =   3000
            TabIndex        =   2
            Top             =   1440
            Width           =   2775
         End
         Begin VB.TextBox TxtSecTit 
            Height          =   285
            Index           =   3
            Left            =   5880
            TabIndex        =   3
            Top             =   1440
            Width           =   2775
         End
         Begin VB.TextBox TxtSecTit 
            Height          =   285
            Index           =   1
            Left            =   120
            TabIndex        =   1
            Top             =   1440
            Width           =   2775
         End
         Begin VB.Label LabSecTit 
            Height          =   255
            Index           =   3
            Left            =   5880
            TabIndex        =   20
            Top             =   840
            Width           =   2175
         End
         Begin VB.Label LabSecTit 
            Height          =   255
            Index           =   2
            Left            =   3000
            TabIndex        =   19
            Top             =   840
            Width           =   2175
         End
         Begin VB.Label LabSecTit 
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   18
            Top             =   840
            Width           =   2175
         End
         Begin VB.Label LabTitulo 
            AutoSize        =   -1  'True
            Caption         =   "Titles"
            Height          =   195
            Left            =   120
            TabIndex        =   13
            Top             =   600
            Width           =   375
         End
         Begin VB.Label LabCodigo 
            AutoSize        =   -1  'True
            Caption         =   "Code"
            Height          =   195
            Left            =   120
            TabIndex        =   12
            Top             =   240
            Width           =   375
         End
      End
   End
End
Attribute VB_Name = "New_Section2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private MfnSection As Long
Private ISSN As String
Private PUBID As String
Private SERIALTITLE As String
Private STITLE As String

Private Unlocked As Boolean

Sub OpenSection(Sertitle As String, IsFromSection As Boolean)
    Dim i As Long
    Dim mfn As Long
    
    With ConfigLabels
    Caption = App.Title + " - " + SECTION_FORM_CAPTION + Sertitle
    CmdAju.Caption = .mnHelp
    CmdClose.Caption = .ButtonClose
    CmdSave.Caption = .ButtonSave
    CmdDel.Caption = .Sec_CmdRem
    CmdNew.Caption = .Sec_CmdADD
    FrameSections.Caption = .Sec_FrameFilledSections
    FrameSectionEdition.Caption = .Sec_FrameSectionEdition
    LabCodigo.Caption = .Sec_SectionCode
    LabTitulo.Caption = .Sec_SectionTitle
    End With
    
    Unlocked = IsFromSection
    CmdDel.Enabled = Unlocked
    
    'Idiomas
    For i = 1 To IdiomsInfo.Count
        LabSecTit(i).Caption = IdiomsInfo(i).label + ": "
        ListView1.ColumnHeaders(i + 1).Text = IdiomsInfo(i).label
        ListView1.ColumnHeaders(i + 1).Width = ListView1.Width / 5
    Next
    
    
    mfn = Serial_CheckExisting(Sertitle)
    
    SERIALTITLE = Sertitle
    ISSN = Serial_TxtContent(mfn, 400)
    PUBID = Serial_TxtContent(mfn, 930)
    STITLE = Serial_TxtContent(mfn, 150)
    
    MfnSection = Section_CheckExisting(Sertitle, ISSN, PUBID)
    If MfnSection > 0 Then
        LoadSections
    Else
        For i = 1 To IdiomsInfo.Count
            TxtHeader(i).Text = IdiomsInfo(i).More
        Next
    End If
    Show vbModal
End Sub

Private Sub CmdClose_Click()
    Unload Me
End Sub

Private Sub CmdNew_Click()
    Dim i As Long
    Dim p As Long
    Dim ValidCode As Boolean
    
    If Unlocked Or (Not IslockedCode(TxtSecCode.Text)) Then
        SectionsAdditem
        CmdDel.Enabled = True
    Else
        MsgBox ConfigLabels.MsgUnchangeableCode
    End If
    UpdateTempSections

End Sub

Private Sub CmdAju_Click()
    Call frmFindBrowser.CallBrowser(FormMenuPrin.DirStruct.Nodes("Help of Section").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Help of Section").Text)
End Sub

Private Sub CmdDel_Click()
    Dim i As Long
    Dim k As Long
    Dim message As String
    Dim lvi As ListItem
    
    If Unlocked Or (Not IslockedCode(TxtSecCode.Text)) Then
        If Len(TxtSecCode.Text) > 0 Then
            message = "Do you want to delete this (these) section(s)?" + vbCrLf
            
            For i = 1 To IdiomsInfo.Count
                If Len(TxtSecTit(i).Text) > 0 Then message = message + TxtSecCode.Text + "-" + TxtSecTit(i).Text + vbCrLf
            Next
        
            If MsgBox(message, vbYesNo + vbDefaultButton2) = vbYes Then
                i = GetSeccodeIdx(TxtSecCode.Text)
                If i > 0 Then
                    ListView1.ListItems.Remove (i)
                End If
                For i = 1 To IdiomsInfo.Count
                    TxtSecTit(i).Text = ""
                Next
                TxtSecCode.Text = ""
                UpdateTempSections
            End If
        Else
            MsgBox ConfigLabels.MsgInvalidSecCode
        End If
    Else
        MsgBox ConfigLabels.MsgUnchangeableCode
    End If
End Sub

Private Sub TXTsecCode_Change()
    ShowSelectedSectitle
End Sub

Private Sub TXTsecCode_Click()
    ShowSelectedSectitle
End Sub

Private Sub ShowSelectedSectitle()
    Dim i As Long
    Dim k As Long
    
    k = GetSeccodeIdx(TxtSecCode.Text)
    If k > 0 Then
        For i = 1 To IdiomsInfo.Count
            TxtSecTit(i).Text = ListView1.ListItems(k).SubItems(i)
        Next
    End If
End Sub

Private Function GetSeccodeIdx(Code As String) As Long
    Dim lv As ListItem
    Dim result As Long
    
    Set lv = ListView1.FindItem(Code, lvwText)
    If lv Is Nothing Then
        result = 0
    Else
        result = lv.index
    End If
    GetSeccodeIdx = result
End Function


Private Sub CmdSave_Click()
    Section_Save
End Sub

Private Function Section_Save() As Boolean
    Dim ToCRecord As String
    Dim s As String
    Dim i As Long
    Dim j As Long
    
    MousePointer = vbHourglass
        With Section1
        s = s + TagContent(GetDateISO(Date), 91)
        s = s + TagContent(SERIALTITLE, 100)
        s = s + TagContent(STITLE, 150)
        s = s + TagContent(ISSN, 35)
        s = s + TagContent(PUBID, 930)
        End With
        
        'For i = 1 To IdiomsInfo.Count
        '    ToCRecord = ToCRecord + "<48>^l" + IdiomsInfo(i).Code + "^h" + IdiomsInfo(i).More + "</48>"
        '    For j = 1 To ListSec(i).ListCount
        '        ToCRecord = ToCRecord + "<49>^l" + IdiomsInfo(i).Code + "^c" + Mid(ListSec(i).List(j - 1), 1, InStr(ListSec(i).List(j - 1), "-") - 1) + "^t" + Mid(ListSec(i).List(j - 1), InStr(ListSec(i).List(j - 1), "-") + 1) + "</49>"
        '    Next
        'Next
        
    ListView1.SortKey = 0
    ListView1.Sorted = True
    ListView1.SortOrder = lvwAscending
        
        
        For j = 1 To IdiomsInfo.Count
            ToCRecord = ToCRecord + TagContent("^l" + IdiomsInfo(j).Code + "^h" + IdiomsInfo(j).More, 48)
            For i = 1 To ListView1.ListItems.Count
                If Len(ListView1.ListItems(i).SubItems(j)) > 0 Then
                    ToCRecord = ToCRecord + TagContent("^l" + IdiomsInfo(j).Code + "^c" + ListView1.ListItems(i).Text + "^t" + ListView1.ListItems(i).SubItems(j), 49)
                End If
            Next
        Next
        s = s + ToCRecord
        
    If MfnSection > 0 Then
        If DBSection.RecordUpdate(MfnSection, s) Then
            Call DBSection.IfUpdate(MfnSection, MfnSection)
        End If
    Else
        MfnSection = DBSection.RecordSave(s)
        If MfnSection > 0 Then Call DBSection.IfUpdate(MfnSection, MfnSection)
    End If
    MousePointer = vbArrow
    Section_Save = True
End Function

Private Sub LoadSections()
    Dim i As Long
    Dim s As String
    Dim p As Long
    Dim p0 As Long
    Dim section As String
    Dim k As Long
    Dim Code As String
    Dim sectit As String
    
    If MfnSection > 0 Then
        For i = 1 To IdiomsInfo.Count
            
            TxtHeader(i).Text = Section_Header(MfnSection, IdiomsInfo(i).Code)
            If Len(TxtHeader(i).Text) = 0 Then TxtHeader(i).Text = IdiomsInfo(i).More
            
            s = DBSection.UsePft(MfnSection, "(if v49^l='" + IdiomsInfo(i).Code + "' then v49^c|-|,v49^t|;| fi)")
        
            p0 = 1
            p = InStr(s, ";")
            While p > 0
                section = Mid(s, p0, p - p0)
                Code = Mid(section, 1, InStr(section, "-") - 1)
                sectit = Mid(section, InStr(section, "-") + 1)
                TxtSecCode.Text = Code
                TxtSecTit(i).Text = sectit
                SectionsAdditem
                p0 = p + 1
                p = InStr(p0, s, ";", vbBinaryCompare)
            Wend
        Next
        ListLockedCodes.Clear
        For i = 1 To ListView1.ListItems.Count
            ListLockedCodes.AddItem ListView1.ListItems(i).Text
        Next
        
        'UpdateTempSections
    End If
End Sub


Private Sub UpdateTempSections()
    Dim i As Long
    Dim k As Long
    
    For i = 1 To IdiomsInfo.Count
        TxtSections(i).Text = ""
        For k = 1 To ListView1.ListItems.Count
            If Len(ListView1.ListItems(k).SubItems(i)) > 0 Then TxtSections(i).Text = TxtSections(i).Text + ListView1.ListItems(k).Text + "-" + ListView1.ListItems(k).SubItems(i) + vbCrLf
        Next
    Next
End Sub

Function Section_ChangedContents() As Boolean
    Dim change As Boolean
    Dim i As Long
    Dim j As Long
    Dim CurrSections As String
    
'    If MfnSection > 0 Then
    ListView1.SortKey = 0
    ListView1.Sorted = True
    ListView1.SortOrder = lvwAscending

    i = 0
    While (i < IdiomsInfo.Count) And (Not change)
        i = i + 1
        CurrSections = ""
        For j = 1 To ListView1.ListItems.Count
            If Len(ListView1.ListItems(j).SubItems(i)) > 0 Then CurrSections = CurrSections + ListView1.ListItems(j).Text + "-" + ListView1.ListItems(j).SubItems(i) + vbCrLf
        Next
        change = change Or (StrComp(TxtHeader(i).Text, Section_Header(MfnSection, IdiomsInfo(i).Code)) <> 0)
        change = change Or (StrComp(CurrSections, DBSection.UsePft(MfnSection, "(if v49^l='" + IdiomsInfo(i).Code + "' then v49^c,'-',v49^t/ fi)")) <> 0)
    Wend
'    End If
    Section_ChangedContents = change
End Function

Private Sub Form_Unload(Cancel As Integer)
    Dim res As VbMsgBoxResult
    
    If Section_ChangedContents Then
        res = MsgBox(ConfigLabels.MsgSaveChanges, vbYesNoCancel)
        If res = vbYes Then
            Section_Save
            Unload Me
        ElseIf res = vbNo Then
            Unload Me
        Else
            Cancel = 1
        End If
    Else
        Unload Me
    End If
End Sub

Private Sub ListView1_BeforeLabelEdit(Cancel As Integer)
    Cancel = 1
End Sub

Private Sub ListView1_ColumnClick(ByVal ColumnHeader As ComctlLib.ColumnHeader)
    ListView1.SortKey = ColumnHeader.index - 1
    ListView1.Sorted = True
    ListView1.SortOrder = lvwAscending
End Sub

Private Sub ListView1_ItemClick(ByVal Item As ComctlLib.ListItem)
    Dim i As Long
    Dim k As Long
    
    k = Item.index
    TxtSecCode.Text = Item.Text
    For i = 1 To IdiomsInfo.Count
        TxtSecTit(i).Text = Item.SubItems(i)
    Next
End Sub

Private Function IslockedCode(Code As String) As Boolean
    Dim found As Boolean
    Dim i As Long
    
    
    While (Not found) And (i < ListLockedCodes.ListCount)
        If StrComp(ListLockedCodes.List(i), Code, vbTextCompare) = 0 Then
            found = True
        End If
        i = i + 1
    Wend
    IslockedCode = found
End Function

'-----------------------------------------------------------------------
'-----------------------------------------------------------------------
'--- REVISADOS
'-----------------------------------------------------------------------
'-----------------------------------------------------------------------

Private Sub SectionsAdditem()
    Dim i As Long
    Dim p As Long
    Dim lvitem As ListItem
    Dim validsectit As Boolean
    Dim validseccode As Boolean
    Dim Replace As Boolean
    Dim answer As VbMsgBoxResult
    
    i = 0
    While (i < IdiomsInfo.Count) And (Not validsectit)
        i = i + 1
        validsectit = (Len(TxtSecTit(i).Text) > 0)
    Wend
    If Len(TxtSecCode.Text) > 0 Then
        p = InStr(TxtSecCode.Text, PUBID)
        If p = 1 Then
            If Len(TxtSecCode.Text) = (Len(PUBID) + 3) Then
                validseccode = True
            End If
        End If
    End If
    If validsectit Then
        If validseccode Then
            Set lvitem = ListView1.FindItem(TxtSecCode.Text)
            If lvitem Is Nothing Then
                Set lvitem = ListView1.ListItems.Add(, TxtSecCode.Text, TxtSecCode.Text)
            End If
            
            TxtSecCode.Text = ""
            For i = 1 To IdiomsInfo.Count
                If Len(lvitem.SubItems(i)) > 0 Then
                    If StrComp(lvitem.SubItems(i), TxtSecTit(i).Text, vbTextCompare) <> 0 Then
                        answer = MsgBox(ConfigLabels.Sec_QMsgReplaceSection, vbYesNo + vbDefaultButton2)
                        If answer = vbYes Then
                            Replace = True
                        End If
                    Else
                        Replace = True
                    End If
                Else
                    Replace = True
                End If
                If Replace Then lvitem.SubItems(i) = TxtSecTit(i).Text
                TxtSecTit(i).Text = ""
            Next
            
        Else
            MsgBox ConfigLabels.Sec_InvalidSecCode
        End If
    Else
        MsgBox ConfigLabels.Sec_InvalidSecTit
    End If
    
End Sub


VERSION 5.00
Begin VB.Form FrmSection 
   Caption         =   "Section"
   ClientHeight    =   5670
   ClientLeft      =   195
   ClientTop       =   885
   ClientWidth     =   9045
   Icon            =   "section.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5670
   ScaleWidth      =   9045
   Begin VB.CommandButton CmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   8040
      TabIndex        =   21
      Top             =   5280
      Width           =   855
   End
   Begin VB.CommandButton CmdSave 
      Caption         =   "Save"
      Height          =   375
      Left            =   7080
      TabIndex        =   20
      Top             =   5280
      Width           =   855
   End
   Begin VB.CommandButton CmdAju 
      Caption         =   "Help"
      Height          =   375
      Left            =   6120
      TabIndex        =   19
      Top             =   5280
      Width           =   855
   End
   Begin VB.Frame FramSum 
      Height          =   5175
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   9015
      Begin VB.Frame FramIdiomSec 
         Caption         =   "Filled Sections"
         Height          =   2895
         Left            =   120
         TabIndex        =   10
         Top             =   2160
         Width           =   8775
         Begin VB.TextBox TxtSections 
            BackColor       =   &H00C0C0C0&
            Height          =   2175
            Index           =   2
            Left            =   3000
            Locked          =   -1  'True
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   27
            Top             =   600
            Width           =   2775
         End
         Begin VB.TextBox TxtSections 
            BackColor       =   &H00C0C0C0&
            Height          =   2175
            Index           =   1
            Left            =   120
            Locked          =   -1  'True
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   26
            Top             =   600
            Width           =   2775
         End
         Begin VB.TextBox TxtSections 
            BackColor       =   &H00C0C0C0&
            Height          =   2175
            Index           =   3
            Left            =   5880
            Locked          =   -1  'True
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   25
            Top             =   600
            Width           =   2775
         End
         Begin VB.TextBox TxtHeader 
            BackColor       =   &H80000000&
            Height          =   285
            Index           =   3
            Left            =   5880
            TabIndex        =   9
            Top             =   240
            Width           =   2775
         End
         Begin VB.TextBox TxtHeader 
            BackColor       =   &H80000000&
            DataField       =   "TxtHeader"
            Height          =   285
            Index           =   2
            Left            =   3000
            TabIndex        =   8
            Top             =   240
            Width           =   2775
         End
         Begin VB.TextBox TxtHeader 
            BackColor       =   &H80000000&
            Height          =   285
            Index           =   1
            Left            =   120
            TabIndex        =   7
            Top             =   240
            Width           =   2775
         End
      End
      Begin VB.CommandButton CmdADD 
         Caption         =   "Add"
         Height          =   375
         Left            =   3480
         TabIndex        =   5
         Top             =   480
         Width           =   615
      End
      Begin VB.Frame FramSecao 
         Caption         =   "Section Edition"
         Height          =   1695
         Left            =   120
         TabIndex        =   11
         Top             =   240
         Width           =   8775
         Begin VB.ListBox ListSec 
            Height          =   300
            Index           =   1
            IntegralHeight  =   0   'False
            ItemData        =   "section.frx":030A
            Left            =   5640
            List            =   "section.frx":030C
            Sorted          =   -1  'True
            TabIndex        =   24
            Top             =   120
            Visible         =   0   'False
            Width           =   975
         End
         Begin VB.ListBox ListSec 
            Height          =   300
            Index           =   2
            IntegralHeight  =   0   'False
            ItemData        =   "section.frx":030E
            Left            =   6600
            List            =   "section.frx":0310
            Sorted          =   -1  'True
            TabIndex        =   23
            Top             =   120
            Visible         =   0   'False
            Width           =   1095
         End
         Begin VB.ListBox ListSec 
            Height          =   300
            Index           =   3
            IntegralHeight  =   0   'False
            ItemData        =   "section.frx":0312
            Left            =   7680
            List            =   "section.frx":0314
            Sorted          =   -1  'True
            TabIndex        =   22
            Top             =   120
            Visible         =   0   'False
            Width           =   975
         End
         Begin VB.ListBox ListTit 
            Height          =   255
            Left            =   6960
            TabIndex        =   18
            Top             =   480
            Visible         =   0   'False
            Width           =   495
         End
         Begin VB.ListBox ListCod 
            Height          =   255
            Left            =   7440
            TabIndex        =   17
            Top             =   480
            Visible         =   0   'False
            Width           =   495
         End
         Begin VB.CommandButton CmdDel 
            Caption         =   "Del"
            Height          =   375
            Left            =   4080
            TabIndex        =   6
            Top             =   240
            Width           =   615
         End
         Begin VB.TextBox TxtSecTit 
            Height          =   285
            Index           =   2
            Left            =   3000
            TabIndex        =   3
            Top             =   1320
            Width           =   2775
         End
         Begin VB.TextBox TxtSecTit 
            Height          =   285
            Index           =   3
            Left            =   5880
            TabIndex        =   4
            Top             =   1320
            Width           =   2775
         End
         Begin VB.TextBox TxtSecTit 
            Height          =   285
            Index           =   1
            Left            =   120
            TabIndex        =   2
            Top             =   1320
            Width           =   2775
         End
         Begin VB.ComboBox ComboCode 
            Height          =   315
            Left            =   600
            Sorted          =   -1  'True
            TabIndex        =   1
            Top             =   240
            Width           =   2535
         End
         Begin VB.Label LabSec 
            Height          =   255
            Index           =   3
            Left            =   5880
            TabIndex        =   16
            Top             =   1080
            Width           =   1695
         End
         Begin VB.Label LabSec 
            Height          =   255
            Index           =   2
            Left            =   3000
            TabIndex        =   15
            Top             =   1080
            Width           =   2175
         End
         Begin VB.Label LabSec 
            Height          =   255
            Index           =   1
            Left            =   240
            TabIndex        =   14
            Top             =   1080
            Width           =   2175
         End
         Begin VB.Label LabTitulo 
            Caption         =   "Titles"
            Height          =   255
            Left            =   120
            TabIndex        =   13
            Top             =   720
            Width           =   615
         End
         Begin VB.Label LabCodigo 
            Caption         =   "Code"
            Height          =   255
            Left            =   120
            TabIndex        =   12
            Top             =   240
            Width           =   735
         End
      End
   End
End
Attribute VB_Name = "FrmSection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private NormalHeight As Long
Private NormalWidth As Long

Private OldHeight As Long
Private OldWidth As Long

Private xToC As ColIssLang
Private Serial As ColField

Private MadeChanges As Boolean

Private Sub CmdMkTable_Click()
    MousePointer = vbHourglass
    Call GenerateSeccodeTable(FormMenuPrin.DirStruct.Nodes("Seccode Table").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Seccode Table").Text, DBSection)
    MousePointer = vbArrow
End Sub

Private Sub Form_Load()
    Dim i As Long
    
    MadeChanges = False
    'Idiomas
    For i = 1 To IdiomsInfo.Count
        LabSec(i).Caption = IdiomsInfo(i).label + ": "
        TxtHeader(i).Text = IdiomsInfo(i).More
    Next
        
    'Serial Titles
    ComboPer.Clear
    For i = 1 To Titulos.SerialCount
        ComboPer.AddItem (Titulos.SerialTitle(i))
    Next
    If Titulos.SerialCount > 0 Then
        ComboPer.ListIndex = 0
    Else
        MsgBox "You must fill the Title Database before filling Section Database."
    End If
    
    OldHeight = Height
    OldWidth = Width
    NormalHeight = Height
    NormalWidth = Width
End Sub

Private Sub CmdAju_Click()
    Call frmFindBrowser.CallBrowser(FormMenuPrin.DirStruct.Nodes("Help of Section").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Help of Section").Text)
End Sub

Private Sub CmdDel_Click()
    Dim i As Long
    Dim k As Long
    
    MadeChanges = True
    For i = 1 To IdiomsInfo.Count
        
        k = FindCode(i, ComboCode.Text)
        If k >= 0 Then
            ListSec(i).RemoveItem (k)
        End If
    Next
    k = ExistCode(ComboCode.Text)
    If k >= 0 Then ComboCode.RemoveItem (k)

End Sub

Private Sub ComboCode_Change()
    'SecTitlesEdit
End Sub

Private Sub ComboCode_Click()
    SecTitlesEdit
End Sub

Private Sub SecTitlesEdit()
    Dim i As Long
    Dim k As Long
    Dim p As Long
    
        For i = 1 To IdiomsInfo.Count
            k = FindCode(i, ComboCode.Text)
            If k >= 0 Then
                p = InStr(ListSec(i).List(k), "-")
                TxtSecTit(i).Text = Mid(ListSec(i).List(k), p + 1)
            Else
                TxtSecTit(i).Text = ""
            End If
        Next
End Sub

Private Function FindCode(j As Long, Code As String) As Long
    Dim k As Long
    Dim half As Long
    Dim found As Boolean
    Dim result As Long
    Dim min As Long
    Dim Max As Long
    'pesquisa binaria
    
    k = -1
    With ListSec(j)
    
    min = 1
    Max = .ListCount
    
    While (Not found) And (min <= Max)
        half = (Max + min) \ 2
        result = StrComp(ComboCode.Text, Mid(.List(half - 1), 1, InStr(.List(half - 1), "-") - 1))
        
        If result = 0 Then
            found = True
            k = half - 1
        ElseIf result > 0 Then
            min = half + 1
        Else
            Max = half - 1
        End If
    Wend
    End With
    FindCode = k
End Function

Private Function FindCode2(j As Long, Code As String) As Long
    Dim k As Long
    Dim i As Long
    
    i = -1
    With ListSec(j)
    While (k < .ListCount) And (i < 0)
        If InStr(.List(k), Code) > 0 Then
            i = k
        End If
        k = k + 1
    Wend
    End With
    FindCode2 = i
End Function

Private Function ExistCodeOld(Code As String) As Long
    Dim k As Long
    Dim half As Long
    Dim found As Boolean
    Dim result As Long
    Dim min As Long
    Dim Max As Long
    'pesquisa binaria
    
    k = -1
    With ComboCode
    
    min = 1
    Max = .ListCount
    
    While (Not found) And (min <= Max)
        half = (Max + min) \ 2
        result = StrComp(ComboCode.Text, .List(half - 1))
        
        If result = 0 Then
            found = True
            k = half - 1
        ElseIf result > 0 Then
            min = half + 1
        Else
            Max = half - 1
        End If
    Wend
    End With
    ExistCodeOld = k
    
End Function

Private Function ExistCode(Code As String) As Long
    Dim k As Long
    Dim i As Long
    Dim result As Long
    
    i = -1
    While (k < ComboCode.ListCount) And (i < 0)
        result = StrComp(Code, ComboCode.List(k))
        If result = 0 Then
            i = k
        ElseIf result > 0 Then
            k = k + 1
        Else
            k = ComboCode.ListCount
        End If
    Wend
    ExistCode = i
End Function

Sub SerialSelection()
    If MadeChanges Then
        If MsgBox("You made changes. But you didn't save. Do you want to save now?", vbYesNo) = vbYes Then
            CmdSave_Click
        Else
            MadeChanges = False
        End If
    End If
    Call GetRecordData(ComboPer.Text, Titulos.BDTitle, Serial, DBTitleTags)
    Call InitIssIdiom(xToC)
    Call GetRecordDataIdiom(Serial.Content(DBTitleTags, "issn", 1), DBSection, xToC, DBSectionTags)
    Call ToCLoad '(IdiomsInfo(ComboIdioma.ListIndex + 1).Code)
    IsSaved
End Sub

Private Sub ComboPer_Change()
    SerialSelection
End Sub

Private Sub ComboPer_Click()
    SerialSelection
End Sub

Sub ToCGetFormData()
    Dim i As Long
    Dim j As Long
    Dim p As Long
    
    For j = 1 To IdiomsInfo.Count
        With xToC(j).Fields
        .Content(DBIssIdiomTags, "header", 1) = TxtHeader(j).Text
            
            For i = 1 To ListSec(j).ListCount
                p = InStr(ListSec(j).List(i - 1), "-")
                .Content(DBIssIdiomTags, "seccode", i) = Mid(ListSec(j).List(i - 1), 1, p - 1)
                .Content(DBIssIdiomTags, "sectitle", i) = Mid(ListSec(j).List(i - 1), p + 1)
            Next
            While Len(.Content(DBIssIdiomTags, "sectitle", i)) > 0
                .Content(DBIssIdiomTags, "sectitle", i) = ""
                .Content(DBIssIdiomTags, "seccode", i) = ""
                i = i + 1
            Wend
        
        End With
    Next
End Sub

Sub ToCLoad()
    Dim i As Long
    Dim idx As Long
    Dim sectitle As String
    Dim seccode As String
    
    ComboCode.Clear
    For i = 1 To IdiomsInfo.Count
        TxtSecTit(i).Text = ""
        ListSec(i).Clear
        With xToC(i).Fields
        idx = 1
        sectitle = .Content(DBIssIdiomTags, "sectitle", idx)
        seccode = .Content(DBIssIdiomTags, "seccode", idx)
        While Len(sectitle) > 0
            ListSec(i).AddItem seccode + "-" + sectitle
            idx = idx + 1
            If ExistCode(seccode) = -1 Then ComboCode.AddItem seccode
            sectitle = .Content(DBIssIdiomTags, "sectitle", idx)
            seccode = .Content(DBIssIdiomTags, "seccode", idx)
        Wend
        End With
    Next
End Sub

Private Sub CmdAdd_Click()
    Dim i As Long
    Dim k As Long
    Dim p As Long
    Dim siglum As String
    
    If ExistCode(ComboCode.Text) < 0 Then
        siglum = Serial.Content(DBTitleTags, "siglum", 1)
        
        p = InStr(ComboCode.Text, siglum)
        If p = 1 Then
            If Len(ComboCode.Text) = (Len(siglum) + 3) Then
                k = 1
                ComboCode.AddItem ComboCode.Text
            End If
        End If
    Else
        k = 1
    End If
    
    If k = 1 Then
        MadeChanges = True
        For i = 1 To IdiomsInfo.Count
            k = FindCode(i, ComboCode.Text)
            If k >= 0 Then
                If Len(TxtSecTit(i).Text) > 0 Then
                    ListSec(i).List(k) = ComboCode.Text + "-" + TxtSecTit(i).Text
                Else
                    ListSec(i).RemoveItem (k)
                End If
            ElseIf k < 0 Then
                If Len(TxtSecTit(i).Text) > 0 Then
                    ListSec(i).AddItem ComboCode.Text + "-" + TxtSecTit(i).Text
                End If
            End If
        Next
    Else
        MsgBox "Invalid format of section code."
    End If
    
End Sub


Private Sub CmdSave_Click()
    If IsSaved Then
        MsgBox "Success."
    Else
        MsgBox "Failure."
    End If
End Sub

Private Function IsSaved() As Boolean
    Dim Content As String
    Dim i As Long
    Dim mfn As Long
    Dim issn As String
    Dim ret As Boolean
    
    MousePointer = vbHourglass
    MadeChanges = False
    
    ToCGetFormData
    
    issn = Serial.Content(DBTitleTags, "issn", 1)
    
    mfn = DBSection.MfnFindOne(issn)
        
    Content = TagContent(issn, DBIssueTags("issn").Value) + TagContent(Serial.Content(DBTitleTags, "siglum", 1), DBIssueTags("siglum").Value) + TagContent(Serial.Content(DBTitleTags, "stitle", 1), DBIssueTags("stitle").Value)
    For i = 1 To xToC.Count
        Content = Content + xToC(i).Fields.Record("^l" + xToC(i).IdiomCod)
    Next
    
    If DBSection.Save(Content, mfn) Then
        ret = True
    End If
    IsSaved = ret
    MousePointer = vbArrow
End Function

Private Function GenerateSeccodeTable(Path As String, TableName As String, DBSection As ClIsisDll) As Boolean
    Dim ret As Boolean
    Dim fn As Long
    Dim mfn As Long
    Dim i As Long
    Dim j As Long
    Dim ListSection As ColCode
    Dim stitle As String
    Dim section As ClCode
    Dim exist As Boolean
    Dim Code As String
    Dim Codes As String
    Dim titles As String
    Dim Title As String
    Dim p As Long
    
    If DirExist(Path, "Seccode Table") Then
        If Len(TableName) > 0 Then
            fn = FreeFile(1)
            Open Path + pathsep + TableName For Output As fn
            
            For mfn = 1 To DBSection.MfnQuantity
                Set ListSection = New ColCode
                Set section = New ClCode
                
                stitle = DBSection.FieldContentOccGet(mfn, DBIssueTags("stitle").Value, 1)
                Codes = ""
                titles = ""
                
                j = DBSection.FieldOccCount(mfn, DBSectionTags("seccode").Value)
                For i = 1 To j
                    Code = DBSection.SubFieldContentOccGet(mfn, DBSectionTags("seccode").Value, i, DBSectionTags("seccode").Subf)
                    If Len(Code) > 0 Then
                        Set section = ListSection(Code, exist)
                        If Not exist Then
                            Set section = ListSection.Add(Code)
                            Codes = Codes + "," + Chr(34) + Code + Chr(34)
                            Title = DBSection.SubFieldContentOccGet(mfn, DBSectionTags("sectitle").Value, i, DBSectionTags("sectitle").Subf)
                            p = InStr(Title, ",")
                            If p > 0 Then
                                Title = Mid(Title, 1, p - 1) + ";" + Mid(Title, p + 1)
                            End If
                            
                            titles = titles + "," + Chr(34) + Title + Chr(34)
                        End If
                    End If
                Next

                If Len(titles) > 0 Then titles = Mid(titles, 2)
                If Len(Codes) > 0 Then Codes = Mid(Codes, 2)
                If (Len(stitle) > 0) And (Len(titles) > 0) And (Len(Codes) > 0) Then
                    Print #fn, Chr(34) + stitle + Chr(34)
                    Print #fn, titles
                    Print #fn, Codes
                End If
            Next
            Close fn
        Else
            MsgBox "Invalid file name of seccode table."
        End If
    End If
    GenerateSeccodeTable = ret
End Function


Private Sub Form_Resize()
    Resize
End Sub
Private Sub Resize()
    Dim x As Double
    Dim Y As Double
    
    If WindowState <> vbMinimized Then
        If Height < NormalHeight Then
            'OldHeight = Height
            Height = NormalHeight
        ElseIf Width < NormalWidth Then
            'OldWidth = Width
            Width = NormalWidth
        Else
            x = Width / OldWidth
            Y = Height / OldHeight
            Call Posicionar(x, Y)
            OldHeight = Height
            OldWidth = Width
        End If
    End If
End Sub

Private Sub Redimensionar(obj As Object, Left As Double, Top As Double, Width As Double, Height As Double)
    Dim g As Long
    
    obj.Left = Left * obj.Left
    obj.Top = Top * obj.Top
    If Height <> 1 Then obj.Height = CLng(Height * obj.Height)
    If Width <> 1 Then obj.Width = Width * obj.Width
End Sub

Private Sub PosicionarSumario(x As Double, Y As Double)
    Dim i As Integer
    
    Call Redimensionar(CmdAju, x, Y, 1, 1)
    Call Redimensionar(CmdAdd, x, Y, 1, 1)
    Call Redimensionar(CmdSave, x, Y, 1, 1)
    
    Call Redimensionar(FramPer, x, Y, x, 1)
    Call Redimensionar(ComboPer, x, Y, x, 1)
    Call Redimensionar(FramSum, x, Y, x, Y)
    
    Call Redimensionar(FramSecao, x, Y, x, Y)
    Call Redimensionar(LabTitulo, x, Y, 1, 1)
    Call Redimensionar(LabCodigo, x, Y, 1, 1)
    
    Call Redimensionar(FramIdiomSec, x, Y, x, Y)
    For i = 1 To 3
        Call Redimensionar(TxtHeader(i), x, Y, x, 1)
        Call Redimensionar(TxtSecTit(i), x, Y, x, 1)
        Call Redimensionar(LabSec(i), x, Y, x, 1)
        Call Redimensionar(ListSec(i), x, Y, x, Y)
    Next
End Sub
Private Sub Posicionar(x As Double, Y As Double)
    
    Call Redimensionar(ComboPer, x, Y, 1, 1)
    Call Redimensionar(FramPer, x, Y, 1, 1)
    Call PosicionarSumario(x, Y)
End Sub

Private Sub Form_Unload(Cancel As Integer)
    If MadeChanges Then
        If MsgBox("You made changes. But you didn't save. Do you want to save now?", vbYesNo) = vbYes Then
            CmdSave_Click
        Else
            MadeChanges = False
        End If
    End If
    Call GenerateSeccodeTable(FormMenuPrin.DirStruct.Nodes("Seccode Table").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Seccode Table").Text, DBSection)
    Unload Me
End Sub


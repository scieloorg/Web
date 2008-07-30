VERSION 5.00
Begin VB.Form FrmCode 
   Caption         =   "Codes"
   ClientHeight    =   5550
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8220
   Icon            =   "FrmCode.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   5550
   ScaleWidth      =   8220
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton CmdDel 
      Caption         =   "Del"
      Height          =   375
      Left            =   7200
      TabIndex        =   7
      Top             =   1920
      Width           =   615
   End
   Begin VB.Frame Frame2 
      Caption         =   "Edit"
      Height          =   4455
      Left            =   120
      TabIndex        =   0
      Top             =   1080
      Width           =   7935
      Begin VB.ComboBox Combo1 
         Height          =   315
         Left            =   7200
         Sorted          =   -1  'True
         TabIndex        =   14
         Text            =   "Combo1"
         Top             =   1440
         Visible         =   0   'False
         Width           =   495
      End
      Begin VB.TextBox InDB 
         Height          =   2415
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   13
         Top             =   1920
         Width           =   7695
      End
      Begin VB.CommandButton CmdAdd 
         Caption         =   "Add"
         Height          =   375
         Left            =   7080
         TabIndex        =   6
         Top             =   360
         Width           =   615
      End
      Begin VB.ComboBox ComboCode 
         Height          =   315
         Left            =   1080
         TabIndex        =   4
         Text            =   "ComboCode"
         Top             =   840
         Width           =   5775
      End
      Begin VB.ComboBox ComboIdiom 
         Height          =   315
         Left            =   1080
         Style           =   2  'Dropdown List
         TabIndex        =   3
         Top             =   360
         Width           =   5775
      End
      Begin VB.TextBox TxtValue 
         Height          =   315
         Left            =   1080
         TabIndex        =   5
         Top             =   1320
         Width           =   5775
      End
      Begin VB.Label LabValue 
         AutoSize        =   -1  'True
         Caption         =   "Value"
         Height          =   195
         Left            =   480
         TabIndex        =   12
         Top             =   1320
         Width           =   405
      End
      Begin VB.Label LabCode 
         AutoSize        =   -1  'True
         Caption         =   "Code"
         Height          =   195
         Left            =   480
         TabIndex        =   10
         Top             =   840
         Width           =   375
      End
      Begin VB.Label LabIdiom 
         AutoSize        =   -1  'True
         Caption         =   "Language"
         Height          =   195
         Left            =   120
         TabIndex        =   9
         Top             =   360
         Width           =   720
      End
   End
   Begin VB.Frame Frame3 
      Caption         =   "Code Name"
      Height          =   855
      Left            =   120
      TabIndex        =   11
      Top             =   120
      Width           =   7935
      Begin VB.ComboBox ComboCodeName 
         Height          =   315
         Left            =   120
         Sorted          =   -1  'True
         TabIndex        =   1
         Top             =   360
         Width           =   6015
      End
      Begin VB.CommandButton CmdOpen 
         Caption         =   "Open"
         Height          =   375
         Left            =   6480
         TabIndex        =   2
         Top             =   360
         Width           =   615
      End
      Begin VB.CommandButton cmdHelp 
         Caption         =   "Help"
         Height          =   375
         Left            =   7200
         TabIndex        =   8
         Top             =   360
         Width           =   615
      End
   End
End
Attribute VB_Name = "FrmCode"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Function ShowCodeNames() As Long
    Dim CodeDB As ClIsisDll
    Dim i As Long
    Dim CodeName As String
    Dim found As Boolean
    Dim j As Long
    
    Set CodeDB = New ClIsisDll
    If CodeDB.Inicia(FormMenuPrin.DirStruct.Nodes("Code Database").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Code Database").Text, FormMenuPrin.DirStruct.Nodes("Code Database").Key) Then
        If CodeDB.IfCreate(FormMenuPrin.DirStruct.Nodes("Code Database").Text) Then
            ComboCodeName.Clear
            For i = 1 To CodeDB.MfnQuantity
                CodeName = CodeDB.UsePft(i, "v1^*")
                If Len(CodeName) > 0 Then
                    j = 0
                    found = False
                    While (j < ComboCodeName.ListCount) And (Not found)
                        found = (StrComp(CodeName, ComboCodeName.List(j)) = 0)
                        j = j + 1
                    Wend
                    If Not found Then ComboCodeName.AddItem CodeName
                End If
            Next
            If ComboCodeName.ListCount > 0 Then ComboCodeName.ListIndex = 0
        End If
    End If
    Set CodeDB = Nothing
    
    ShowCodeNames = ComboCodeName.ListCount
End Function

Private Sub CreateCodeName()
    Dim CodeDB As ClIsisDll
    Dim mfn As Long

    
    Set CodeDB = New ClIsisDll
    If CodeDB.Inicia(FormMenuPrin.DirStruct.Nodes("Code Database").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Code Database").Text, FormMenuPrin.DirStruct.Nodes("Code Database").Key) Then
        If CodeDB.IfCreate(FormMenuPrin.DirStruct.Nodes("Code Database").Text) Then
            mfn = CodeDB.RecordSave("<1>" + ComboCodeName.Text + "</1>")
            If mfn > 0 Then Call CodeDB.IfUpdate(mfn, mfn)
        End If
    End If
End Sub


Private Sub ShowIdioms()
    Dim i As Long
    
    ComboIdiom.AddItem "Independs on idiom"
    For i = 1 To IdiomsInfo.Count
        ComboIdiom.AddItem IdiomsInfo(i).label
    Next
    
    ComboIdiom.ListIndex = 0
End Sub

Private Sub CmdAdd_Click()
    Dim i As Long
    Dim ResStrComp As Long
    Dim CodeDB As ClIsisDll
    Dim Content As String
    Dim mfn As Long
    Dim IdiomCode As String
        
    If Len(TxtValue.Text) > 0 Then
        If Len(ComboCode.Text) > 0 Then
            i = 0
            ResStrComp = -1
            While (i < ComboCode.ListCount) And (ResStrComp < 0)
                ResStrComp = StrComp(ComboCode.Text, ComboCode.List(i))
                i = i + 1
            Wend
            If (ResStrComp > 0) Or ((ResStrComp < 0) And (i = ComboCode.ListCount)) Then ComboCode.AddItem ComboCode.Text
            
            
            Set CodeDB = New ClIsisDll
            If CodeDB.Inicia(FormMenuPrin.DirStruct.Nodes("Code Database").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Code Database").Text, FormMenuPrin.DirStruct.Nodes("Code Database").Key) Then
                If CodeDB.IfCreate(FormMenuPrin.DirStruct.Nodes("Code Database").Text) Then
                    If ComboIdiom.ListIndex > 0 Then IdiomCode = IdiomsInfo(ComboIdiom.ListIndex).Code
            
                    mfn = CodeDB.MfnFindOne(IdiomCode + "-" + ComboCodeName.Text)
                    If mfn = 0 Then
                        If Len(IdiomCode) > 0 Then Content = "^l" + IdiomCode
                        mfn = CodeDB.RecordSave("<1>" + ComboCodeName.Text + Content + "</1>")
                        If mfn > 0 Then Call CodeDB.IfUpdate(mfn, mfn)
                    End If
                    If mfn > 0 Then
                        If CodeDB.FieldContentAdd(mfn, 2, "^c" + ComboCode.Text + "^v" + TxtValue.Text) Then
                            ShowCodes
                        End If
                    End If
                End If
            End If
            Set CodeDB = Nothing
        Else
            MsgBox "Invalid code."
        End If
    Else
        MsgBox "Invalid value."
    End If
    
End Sub


Public Sub MakeAttributeTable()
    Dim CodeNames As String
    Dim fn As Long
    Dim File As String
    Dim AttrFormat As String
    Dim CodeFormat As String
    Dim ValueFormat As String
    Dim Separator As String
    Dim i As Long
    
    fn = FreeFile
    
    File = FormMenuPrin.DirStruct.Nodes("Attribute Article Table Format").FullPath
    Open File For Input As fn
    Line Input #fn, CodeNames
    Line Input #fn, AttrFormat
    Line Input #fn, CodeFormat
    Line Input #fn, ValueFormat
    Line Input #fn, Separator
    Close fn
    Call MakeTable(FormMenuPrin.DirStruct.Nodes("Attribute Article Table").FullPath, CodeNames, AttrFormat, CodeFormat, ValueFormat, Separator)
    
    
    File = FormMenuPrin.DirStruct.Nodes("Attribute Table Format").FullPath
    Open File For Input As fn
    Line Input #fn, CodeNames
    Line Input #fn, AttrFormat
    Line Input #fn, CodeFormat
    Line Input #fn, ValueFormat
    Line Input #fn, Separator
    Close fn
    Call MakeTable(FormMenuPrin.DirStruct.Nodes("Attribute Table").FullPath, CodeNames, AttrFormat, CodeFormat, ValueFormat, Separator)
    
    For i = 1 To IdiomsInfo.Count
        File = FormMenuPrin.DirStruct.Nodes("Attribute List").Parent.FullPath + "\" + IdiomsInfo(i).Code + FormMenuPrin.DirStruct.Nodes("Attribute List").Text
        Open File For Input As fn
        Line Input #fn, CodeNames
        Line Input #fn, AttrFormat
        Line Input #fn, CodeFormat
        Line Input #fn, ValueFormat
        Line Input #fn, Separator

        Close fn
        
        Call MakeNEWTable(FormMenuPrin.DirStruct.Nodes("Markup Attribute Table").Parent.FullPath + "\" + IdiomsInfo(i).Code + "_" + FormMenuPrin.DirStruct.Nodes("Markup Attribute Table").Text, CodeNames, AttrFormat, CodeFormat, ValueFormat, Separator)
    Next
        
End Sub

Private Function MakeNEWTable(File As String, CodeNames As String, AttrFormat As String, CodeFormat As String, ValueFormat As String, Separator As String) As Boolean
    Dim CodeDB As ClIsisDll
    Dim Attributes As ColCode
    Dim Attrib As ClCode
    Dim CurrAttr As String
    Dim exist As Boolean
    Dim mfn As Long
    Dim fn As Long
    Dim p As Long
    Dim start As Long
    Dim CodeName As String
    Dim AttrNames() As String
    Dim OrdValue As String
    Dim OrdCode As String
    
    If Len(CodeNames) > 0 Then
        
        Set CodeDB = New ClIsisDll
        If CodeDB.Inicia(FormMenuPrin.DirStruct.Nodes("Code Database").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Code Database").Text, FormMenuPrin.DirStruct.Nodes("Code Database").Key) Then
            If CodeDB.IfCreate(FormMenuPrin.DirStruct.Nodes("Code Database").Text) Then
                    
                Set Attributes = New ColCode
                CodeNames = CodeNames + ","
                p = InStr(CodeNames, ",")
                start = 1
                
                While (p > 0) And (start < p)
                    CodeName = Mid(CodeNames, start, p - start)
                    start = p + 1
                    p = InStr(start, CodeNames, ",", vbTextCompare)
                    
                    mfn = CodeDB.MfnFindOne(CodeName)
                    If mfn > 0 Then
                        CurrAttr = CodeDB.UsePft(mfn, AttrFormat)
                    
                        Set Attrib = New ClCode
                        Set Attrib = Attributes(CurrAttr, exist)
                        If exist Then
                            OrdCode = CodeDB.UsePft(mfn, CodeFormat)
                            OrdValue = CodeDB.UsePft(mfn, ValueFormat)
                            
                            'Call OrderCodeValues(OrdValue, OrdCode, Separator)
                            
                            Attrib.Code = Attrib.Code + Separator + OrdCode
                            Attrib.Value = Attrib.Value + Separator + OrdValue
                        Else
                            Set Attrib = Attributes.Add(CurrAttr)
                            ReDim Preserve AttrNames(Attributes.Count)
                            AttrNames(Attributes.Count) = CurrAttr
                            
                            OrdCode = CodeDB.UsePft(mfn, CodeFormat)
                            OrdValue = CodeDB.UsePft(mfn, ValueFormat)
                            'Call OrderCodeValues(OrdValue, OrdCode, Separator)
                            
                            Attrib.Code = OrdCode
                            Attrib.Value = OrdValue
                        End If
                    End If
                Wend
                
                
                fn = FreeFile
                Open File For Output As #fn
                For p = 1 To Attributes.Count
                    Print #fn, AttrNames(p)
                    Print #fn, Attributes(p).Value
                    Print #fn, Attributes(p).Code
                    Print #fn,
                Next
                Close fn
            End If
        
        End If
        Set CodeDB = Nothing
    End If
    
    MakeNEWTable = True


End Function

Private Function MakeTable(File As String, CodeNames As String, AttrFormat As String, CodeFormat As String, ValueFormat As String, Separator As String) As Boolean
    Dim CodeDB As ClIsisDll
    Dim Attributes As ColCode
    Dim Attrib As ClCode
    Dim CurrAttr As String
    Dim exist As Boolean
    Dim Mfns() As Long
    Dim mfnIdx As Long
    Dim MfnCount As Long
    Dim fn As Long
    Dim p As Long
    Dim start As Long
    Dim CodeName As String
    Dim CodesCount() As Long
    Dim i As Long
    Dim OrdCode As String
    Dim OrdValue As String
    
    If Len(CodeNames) > 0 Then
        
        Set CodeDB = New ClIsisDll
        If CodeDB.Inicia(FormMenuPrin.DirStruct.Nodes("Code Database").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Code Database").Text, FormMenuPrin.DirStruct.Nodes("Code Database").Key) Then
            If CodeDB.IfCreate(FormMenuPrin.DirStruct.Nodes("Code Database").Text) Then
                    
                Set Attributes = New ColCode
                CodeNames = CodeNames + ","
                p = InStr(CodeNames, ",")
                start = 1
                
                While (p > 0) And (start < p)
                    CodeName = Mid(CodeNames, start, p - start)
                    start = p + 1
                    p = InStr(start, CodeNames, ",", vbTextCompare)
                    
                    MfnCount = CodeDB.MfnFind(CodeName, Mfns)
                    For mfnIdx = 1 To MfnCount
                        CurrAttr = CodeDB.UsePft(Mfns(mfnIdx), AttrFormat)
                    
                        Set Attrib = New ClCode
                        Set Attrib = Attributes(CurrAttr, exist)
                        If exist Then
                            OrdCode = CodeDB.UsePft(Mfns(mfnIdx), CodeFormat)
                            OrdValue = CodeDB.UsePft(Mfns(mfnIdx), ValueFormat)
                            
                            'CodesCount(Attributes.Count) = CodesCount(Attributes.Count) + OrderCodeValues(OrdValue, OrdCode, Separator)
                            
                            Attrib.Code = Attrib.Code + Separator + OrdCode
                            Attrib.Value = Attrib.Value + Separator + OrdValue
                            
                            CodesCount(Attributes.Count) = CodesCount(Attributes.Count) + OrderCodeValues(OrdValue, OrdCode, Separator)
                            
                        Else
                            Set Attrib = Attributes.Add(CurrAttr)
                            OrdCode = CodeDB.UsePft(Mfns(mfnIdx), CodeFormat)
                            OrdValue = CodeDB.UsePft(Mfns(mfnIdx), ValueFormat)
                            
                            ReDim Preserve CodesCount(Attributes.Count)
                            'CodesCount(Attributes.Count) = OrderCodeValues(OrdValue, OrdCode, Separator)
                            Attrib.Code = OrdCode
                            Attrib.Value = OrdValue
                            CodesCount(Attributes.Count) = OrderCodeValues(OrdValue, OrdCode, Separator)
                        End If
                    Next
                
                Wend
                
                
                fn = FreeFile
                Open File For Output As #fn
                For i = 1 To Attributes.Count
                    Print #fn, CStr(CodesCount(i))
                    Print #fn, Chr(34) + Attributes(i).Value + Chr(34)
                    Print #fn, Chr(34) + Attributes(i).Code + Chr(34)
                Next
                Close fn
            End If
        
        End If
        Set CodeDB = Nothing
    End If
    MakeTable = True
End Function

Private Function MakeTableOld(File As String, CodeNames As String, AttrFormat As String, CodeFormat As String, ValueFormat As String, Separator As String) As Boolean
    Dim CodeDB As ClIsisDll
    Dim Attributes As ColCode
    Dim Attrib As ClCode
    Dim CurrAttr As String
    Dim exist As Boolean
    Dim mfn As Long
    Dim fn As Long
    Dim p As Long
    Dim start As Long
    Dim CodeName As String
    Dim CodesCount() As Long
    Dim i As Long
    Dim OrdCode As String
    Dim OrdValue As String
    
    If Len(CodeNames) > 0 Then
        
        Set CodeDB = New ClIsisDll
        If CodeDB.Inicia(FormMenuPrin.DirStruct.Nodes("Code Database").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Code Database").Text, FormMenuPrin.DirStruct.Nodes("Code Database").Key) Then
            If CodeDB.IfCreate(FormMenuPrin.DirStruct.Nodes("Code Database").Text) Then
                    
                Set Attributes = New ColCode
                CodeNames = CodeNames + ","
                p = InStr(CodeNames, ",")
                start = 1
                
                While (p > 0) And (start < p)
                    CodeName = Mid(CodeNames, start, p - start)
                    start = p + 1
                    p = InStr(start, CodeNames, ",", vbTextCompare)
                    
                    mfn = CodeDB.MfnFindOne(CodeName)
                    If mfn > 0 Then
                        CurrAttr = CodeDB.UsePft(mfn, AttrFormat)
                    
                        Set Attrib = New ClCode
                        Set Attrib = Attributes(CurrAttr, exist)
                        If exist Then
                            OrdCode = CodeDB.UsePft(mfn, CodeFormat)
                            OrdValue = CodeDB.UsePft(mfn, ValueFormat)
                            
                            'CodesCount(Attributes.Count) = CodesCount(Attributes.Count) + OrderCodeValues(OrdValue, OrdCode, Separator)
                            
                            Attrib.Code = Attrib.Code + Separator + OrdCode
                            Attrib.Value = Attrib.Value + Separator + OrdValue
                            
                            CodesCount(Attributes.Count) = CodesCount(Attributes.Count) + OrderCodeValues(OrdValue, OrdCode, Separator)
                            
                        Else
                            Set Attrib = Attributes.Add(CurrAttr)
                            OrdCode = CodeDB.UsePft(mfn, CodeFormat)
                            OrdValue = CodeDB.UsePft(mfn, ValueFormat)
                            
                            ReDim Preserve CodesCount(Attributes.Count)
                            'CodesCount(Attributes.Count) = OrderCodeValues(OrdValue, OrdCode, Separator)
                            Attrib.Code = OrdCode
                            Attrib.Value = OrdValue
                            CodesCount(Attributes.Count) = OrderCodeValues(OrdValue, OrdCode, Separator)
                        End If
                    End If
                
                Wend
                
                
                fn = FreeFile
                Open File For Output As #fn
                For i = 1 To Attributes.Count
                    Print #fn, CStr(CodesCount(i))
                    Print #fn, Chr(34) + Attributes(i).Value + Chr(34)
                    Print #fn, Chr(34) + Attributes(i).Code + Chr(34)
                Next
                Close fn
            End If
        
        End If
        Set CodeDB = Nothing
    End If
    MakeTableOld = True
End Function


Private Function OrderCodeValues(values As String, Codes As String, Separator As String) As Long
    Dim pval As Long
    Dim pcode As Long
    Dim startval As Long
    Dim startcode As Long
    Dim i As Long
    
    Combo1.Clear
    
    values = values + Separator
    Codes = Codes + Separator
    
    startval = 1
    startcode = 1
    pval = InStr(startval, values, Separator, vbTextCompare)
    pcode = InStr(startcode, Codes, Separator, vbTextCompare)
    While (pval > 0) And (pcode > 0) And (startval < pval) And (startcode < pcode)
        
        Combo1.AddItem Mid(values, startval, pval - startval) + "^c" + Mid(Codes, startcode, pcode - startcode)
        
        startval = pval + 1
        startcode = pcode + 1
        pval = InStr(startval, values, Separator, vbTextCompare)
        pcode = InStr(startcode, Codes, Separator, vbTextCompare)
    Wend
    
    If Combo1.ListCount > 0 Then
        pcode = InStr(Combo1.List(0), "^c")
        values = Mid(Combo1.List(0), 1, pcode - 1)
        Codes = Mid(Combo1.List(0), pcode + 2)
    
        For i = 1 To Combo1.ListCount - 1
            pcode = InStr(Combo1.List(i), "^c")
            values = values + Separator + Mid(Combo1.List(i), 1, pcode - 1)
            Codes = Codes + Separator + Mid(Combo1.List(i), pcode + 2)
        Next
    End If
    OrderCodeValues = Combo1.ListCount
End Function
Private Sub CmdDel_Click()
    Dim i As Long
    Dim CodeDB As ClIsisDll
    Dim mfn As Long
    Dim IdiomCode As String
    Dim k As Long
    Dim index() As Long
        
    If Len(ComboIdiom.Text) > 0 Then
        If Len(ComboCode.Text) > 0 Then
            
            Set CodeDB = New ClIsisDll
            If CodeDB.Inicia(FormMenuPrin.DirStruct.Nodes("Code Database").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Code Database").Text, FormMenuPrin.DirStruct.Nodes("Code Database").Key) Then
                If CodeDB.IfCreate(FormMenuPrin.DirStruct.Nodes("Code Database").Text) Then
                    
                    If ComboIdiom.ListIndex > 0 Then IdiomCode = IdiomsInfo(ComboIdiom.ListIndex).Code
                    
                    mfn = CodeDB.MfnFindOne(IdiomCode + "-" + ComboCodeName.Text)
                    If mfn > 0 Then
                        FormDel.ListDel.Clear
                        For i = 1 To CodeDB.FieldOccCount(mfn, 2)
                            FormDel.ListDel.AddItem CodeDB.SubFieldContentOccGet(mfn, 2, i, "c") + "-" + CodeDB.SubFieldContentOccGet(mfn, 2, i, "v")
                        Next
                        k = FormDel.DeleteItens(index)
                        For i = k To 1 Step -1
                            Call CodeDB.FieldContentDel(mfn, 2, index(i))
                        Next
                    Else
                        MsgBox "There's no field to delete."
                    End If
                End If
            End If
        End If
    End If
    ShowCodes
    MousePointer = vbArrow
End Sub

Private Sub CmdHelp_Click()
    Call frmFindBrowser.CallBrowser(FormMenuPrin.DirStruct.Nodes("Help of Codes").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Help of Codes").Text)
End Sub

Private Sub CmdOpen_Click()
    Dim i As Long
    Dim ResStrComp As Long
    
    
    If Len(ComboCodeName.Text) > 0 Then
        i = 0
        ResStrComp = -1
        While (i < ComboCodeName.ListCount) And (ResStrComp < 0)
            ResStrComp = StrComp(ComboCodeName.Text, ComboCodeName.List(i))
            i = i + 1
        Wend
        If (ResStrComp < 0) Or ((ResStrComp < 0) And (i = ComboCodeName.ListCount)) Then
            ComboCodeName.AddItem ComboCodeName.Text
        End If
        
        Enable = True
        
        ShowCodes

    Else
        MsgBox "Invalid code name."
    End If

End Sub

Private Sub ComboCodeName_Change()
    ComboCode.Clear
    InDB.Text = ""
    TxtValue.Text = ""
End Sub

Private Sub ComboCodeName_Click()
    ComboCode.Clear
    InDB.Text = ""
    TxtValue.Text = ""
End Sub

Private Sub Form_Load()
    Enable = False
    ShowCodeNames
    
    ShowIdioms
End Sub

Private Sub ShowCodes()
    Dim CodeDB As ClIsisDll
    Dim i As Long
    Dim mfn As Long
    Dim p As Long
    Dim j As Long
    Dim Codes As String
    Dim Code As String
    Dim found As Boolean
    Dim IdiomCode As String
    
    Set CodeDB = New ClIsisDll
    If CodeDB.Inicia(FormMenuPrin.DirStruct.Nodes("Code Database").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Code Database").Text, FormMenuPrin.DirStruct.Nodes("Code Database").Key) Then
        If CodeDB.IfCreate(FormMenuPrin.DirStruct.Nodes("Code Database").Text) Then
            ComboCode.Clear
            InDB.Text = ""
            
            For i = 1 To ComboIdiom.ListCount
                If i > 1 Then IdiomCode = IdiomsInfo(i - 1).Code
                mfn = CodeDB.MfnFindOne(IdiomCode + "-" + ComboCodeName.Text)
                If mfn > 0 Then InDB.Text = InDB.Text + Chr(13) + Chr(10) + ComboIdiom.List(i - 1) + Chr(13) + Chr(10) + CodeDB.UsePft(mfn, "(|  |v2^c,| - |v2^v/)")
                Codes = Codes + CodeDB.UsePft(mfn, "(v2^c|#|)")
            Next
            
            p = InStr(Codes, "#")
            While p > 0
                Code = Mid(Codes, 1, p - 1)
                If Len(Code) > 0 Then
                    j = 0
                    found = False
                    While (j < ComboCode.ListCount) And (Not found)
                        found = (StrComp(Code, ComboCode.List(j)) = 0)
                        j = j + 1
                    Wend
                    If Not found Then ComboCode.AddItem Code
                End If
                
                Codes = Mid(Codes, p + 1)
                p = InStr(Codes, "#")
            Wend
            If ComboCode.ListCount > 0 Then ComboCode.ListIndex = 0
        End If
    End If
    Set CodeDB = Nothing
    
End Sub

Private Sub Form_Unload(Cancel As Integer)
    MakeAttributeTable
    
End Sub


Private Property Let Enable(v As Boolean)
    
    ComboCode.Enabled = v
    ComboIdiom.Enabled = v
    
    CmdAdd.Enabled = v
    CmdDel.Enabled = v
    
    LabCode.Enabled = v
    LabIdiom.Enabled = v
    LabValue.Enabled = v
End Property


VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClTitle"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

Private BD As ClIsisDll
Private SerialTitles() As String
Private k As Long
Private mvarTitleFile As String 'local copy
Private format As String

Public Property Let TitleFile(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.TitleFile = 5
    mvarTitleFile = vData
End Property

Public Property Get TitleFile() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.TitleFile
    TitleFile = mvarTitleFile
End Property

Property Get PathTitles() As String
    PathTitles = BD.BDPath
End Property
Property Let PathTitles(v As String)
    BD.BDPath = v
End Property
Property Get ArqTitles() As String
    ArqTitles = BD.BDNome
End Property
Property Let ArqTitles(v As String)
    BD.BDNome = v
End Property
Property Get BDTitle() As ClIsisDll
    Set BDTitle = BD
End Property
Property Set BDTitle(v As ClIsisDll)
    Set BD = v
End Property

Function Inicia(Path As String, base As String, Invert As String, TitleFormat As String) As Boolean
    Dim Ret As Boolean
    
    Set BD = New ClIsisDll
    If BD.Inicia(Path, base, "Database Title") Then
        If BD.IfCreate(Invert) Then
            If BD.MfnQuantity > 0 Then Call BD.IfUpdate(1, BD.MfnQuantity)
            format = TitleFormat
            Ret = GetSerialTitles
        End If
    End If
    
    Inicia = Ret
End Function

Property Get SerialTitle(i As Long) As String
    If (i > 0) And (i <= k) Then
        SerialTitle = SerialTitles(i)
    Else
        SerialTitle = ""
    End If
End Property

Property Get SerialCount() As Long
    SerialCount = k
End Property

Private Sub Class_Terminate()
    Set BD = Nothing
End Sub

Function SaveNew(Record As String, Optional Mfn As Long) As Boolean
    If BD.Save(Record, Mfn) Then
        SaveNew = GetSerialTitles
    End If
End Function

Function GetSerialTitles() As Boolean
    Dim i As Long
    Dim tmp As String
    Dim j As Long
    Dim Ret As Boolean
            
            ReDim SerialTitles(BD.MfnQuantity)
            For i = 1 To BD.MfnQuantity
                tmp = BD.UsePft(i, format)
                If Len(tmp) > 0 Then
                    j = j + 1
                    SerialTitles(j) = tmp
                End If
            Next
            k = j
            Ret = (k <= BD.MfnQuantity)
    GetSerialTitles = Ret
End Function


Sub Serial_GetExistingList(List As ListBox)
    Dim isistitle As ClIsisDll
    Dim i As Long
    Dim tmp As String
    
    Set isistitle = New ClIsisDll
    If isistitle.Inicia(FormMenuPrin.DirStruct.Nodes("Title Database").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Title Database").Text, FormMenuPrin.DirStruct.Nodes("Title Database").Text) Then
        List.Clear
        For i = 1 To isistitle.MfnQuantity
            tmp = isistitle.UsePft(i, "v100")
            If Len(tmp) > 0 Then
                List.AddItem tmp
            End If
        Next
    End If
End Sub

Function Serial_CheckExisting(SerialTitle_to_find As String) As Long
    Dim isistitle As ClIsisDll
    Dim Mfn As Long
    Dim SerialTitle As String
    Dim found As Boolean
    
    Set isistitle = New ClIsisDll
    If isistitle.Inicia(FormMenuPrin.DirStruct.Nodes("Title Database").Parent.FullPath, FormMenuPrin.DirStruct.Nodes("Title Database").Text, FormMenuPrin.DirStruct.Nodes("Title Database").Text) Then
        While (Mfn < isistitle.MfnQuantity) And (Not found)
            Mfn = Mfn + 1
            SerialTitle = isistitle.UsePft(Mfn, "v100")
            If StrComp(SerialTitle, SerialTitle_to_find) = 0 Then
                found = True
            End If
        Wend
        If found Then
            Serial_CheckExisting = Mfn
        End If
    End If
End Function


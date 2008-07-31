VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClDTD"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"

Option Explicit

Public CreateCipFile As Boolean
Public name As String
Public DocTypeName As String
Public SGM2ASC As String
Public IMG2ASC As String
Public ASC2SGM As String
Public SubSup2ASC As String
Public RECOVER_REPLACESYMBOL As String
Public CORRECTIONS As String
Private mvarGizmoFiles() As String 'local copy
Public PFTFILE As String
Public PROCFILE As String
Public CIPFILE As String
Public TAGSFILE As String
Public PFTCount As Long
Public ReportPFTFile As String
Public DTDFile As String
Public GizmoFileCounter As Long
Public PFT_Title As String
Private PUBMEDTAGS() As ColPMTag
Private qPUBMEDTAGS As Long
Public FSTFile As String
Public hasEmail As Boolean
Public hasUCaseLastName As Boolean
Public hasAffiliation As Boolean


Public Property Let GizmoFiles(ByVal Index As Long, ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.GizmoFiles = 5
    If Index > GizmoFileCounter Then
        GizmoFileCounter = Index
        ReDim Preserve mvarGizmoFiles(GizmoFileCounter)
    End If
    mvarGizmoFiles(GizmoFileCounter) = vData
End Property


Public Property Get GizmoFiles(ByVal Index As Long) As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.GizmoFiles
    If (Index > 0) And (Index <= GizmoFileCounter) Then
        GizmoFiles = mvarGizmoFiles(Index)
    End If
End Property



Sub ReadTagsFile()
    Dim fn As Long
    Dim i As Long
    Dim j As Long
    Dim Tag As String
    Dim COLOR As Long
    Dim CHAR As String
    Dim T As ClPMTag
    Dim C As String
    Dim k As Long
    
    fn = 1
    Set T = New ClPMTag
    
    ReDim PUBMEDTAGS(90 - 65 + 1)
    For i = 65 To 90
        j = i - 64
        Set PUBMEDTAGS(j) = New ColPMTag
    Next
    
    
    Open TAGSFILE For Input As fn
    While Not EOF(fn)
        
        Input #fn, Tag, COLOR
        j = Asc(Mid(Tag, 1, 1)) - 64
        
        Set T = PUBMEDTAGS(j).Add(Tag)
        
        'COLOR = COLOR * 59595
        COLOR = COLOR * 491593
        'COLOR = COLOR * 505292
        'COLOR = 16 + (8 * k)
        
        C = CStr(Hex(COLOR))
        
        If Len(C) > 6 Then
            T.COLOR = Mid(C, 1, 6)
        Else
            T.COLOR = String(6 - Len(C), "0") + C
        End If
        k = COLOR
        T.Tag = Tag
        Debug.Print C, T.COLOR, Tag
    Wend
    Close fn
    
End Sub

Function COLOREDTAG(Tag As String) As String
    Dim COLOR As String
    Dim T As String
    Dim bar As String
    Dim exist As Boolean
    Dim k As ClPMTag
    
    If Mid(Tag, 2, 1) = "/" Then
        bar = "/"
        T = Mid(Tag, 3, Len(Tag) - 3)
    Else
        T = Mid(Tag, 2, Len(Tag) - 2)
    End If
    
    Set k = PUBMEDTAGS(Asc(UCase(Mid(T, 1, 1))) - 64).Item(T, exist)
    If exist Then
        COLOR = k.COLOR
        COLOREDTAG = "<FONT COLOR=" + Chr(34) + "#" + COLOR + Chr(34) + ">&lt;" + bar + T + "&gt;</FONT>"
    Else
    Debug.Print "invalid tag"
    End If
End Function


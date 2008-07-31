Attribute VB_Name = "ModCodes"
Option Explicit

Public MARKUPPATH As String
Public ATTB_FILE As String
Public ATTB_LABEL As String



Public DBCODESPATH As String
Public DBNEWCODEFILE As String
Public DBCODEFILE As String
Public DBCODESLABEL As String
Public AppHandle As Long

Public IdiomsInfo As ColIdiom
Public ConfigLabels As ClLabels

Sub Main()
    Dim fn As Long
    Dim Code As String
    Dim value As String
    Dim idiominfo As ClIdiom
    Dim i As Long
    Dim PATHS_CONFIGURATION_FILE As String
    Dim paths As ColFileInfo
    
    
    AppHandle = IsisAppNew
    
    Set ConfigLabels = New ClLabels
    ConfigLabels.SetLabels ("es")
    
    fn = 1
    Open App.path + "\codes.ini" For Input As fn
    Input #fn, Code, PATHS_CONFIGURATION_FILE
    'Input #fn, DBCODESPATH, DBNEWCODEFILE, DBCODESLABEL
    'Input #fn, DBCODESPATH, DBCODEFILE, DBCODESLABEL
    'Input #fn, MARKUPPATH, ATTB_FILE, ATTB_LABEL
    
    Set IdiomsInfo = New ColIdiom
    Set idiominfo = New ClIdiom
    For i = 1 To 3
        Input #fn, Code, value
        Set idiominfo = IdiomsInfo.Add(Code, value, " ")
    Next
    
    Close fn
    Set paths = ReadPathsConfigurationFile(PATHS_CONFIGURATION_FILE)
    
    DBCODESPATH = paths("Code Database").path
    DBNEWCODEFILE = paths("NewCode Database").filename
    DBCODEFILE = paths("Code Database").filename
    DBCODESLABEL = paths("Code Database").key
    MARKUPPATH = paths("Markup Attributes Table").path
    ATTB_FILE = paths("Markup Attributes Table").filename
    ATTB_LABEL = paths("Markup Attributes Table").key
    
    
    FrmCodes.OpenCodes
End Sub

Function ReadPathsConfigurationFile(File As String) As ColFileInfo
    Dim fn As Long
    Dim lineread As String
    Dim Item As ClFileInfo
    Dim key As String
    Dim path As String
    Dim CollectionPaths As ColFileInfo
    Dim req As Long
    
    fn = FreeFile
    Open File For Input As fn
        
    Set CollectionPaths = New ColFileInfo
    
    While Not EOF(fn)
        Line Input #fn, lineread
        If InStr(lineread, "=") > 0 Then
            key = Mid(lineread, 1, InStr(lineread, "=") - 1)
            path = Mid(lineread, InStr(lineread, "=") + 1)
            req = InStr(path, ",required")
            If req > 0 Then
                path = Mid(path, 1, req - 1)
                
            End If
            Set Item = CollectionPaths.Add(key)
            Item.key = key
            If InStr(path, "\") > 0 Then
                Item.path = Mid(path, 1, InStrRev(path, "\") - 1)
                Item.filename = Mid(path, InStrRev(path, "\") + 1)
            Else
                Item.path = ""
                Item.filename = path
            End If
            Item.required = (req > 0)
        End If
    Wend
    Close fn
    Set ReadPathsConfigurationFile = CollectionPaths
End Function


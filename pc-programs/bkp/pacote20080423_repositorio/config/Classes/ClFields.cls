VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClFields"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

'Buttons
Public Fields As ColField


Sub SetLabels(CurrCodeIdiom As String)
    Dim fn As Long
    Dim label  As String
    Dim key As String
    Dim is_mandatory As String
    
    fn = 1
    Open App.Path + "\" + CurrCodeIdiom + "_field.ini" For Input As fn
    
    Set Fields = New ColField
    While Not EOF(fn)
        Input #fn, key, label, is_mandatory
        Call Fields.Add(key, label, is_mandatory, key)
    Wend
    Close fn
    
End Sub
    

Function MandatoryFields(Content As String, key As String) As String
    If (Len(Fields(key).is_mandatory) > 0) And (Len(Content) = 0) Then
        MandatoryFields = Fields(key).label + vbCrLf
    End If
End Function




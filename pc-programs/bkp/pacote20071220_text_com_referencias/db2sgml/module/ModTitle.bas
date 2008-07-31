Attribute VB_Name = "ModTitle"
Option Explicit

Public Type TpDatabase
    FullPath As String
    File As String
    InvFile As String
    Label As String
    Field As String
End Type

Public TitleDB As TpDatabase

Const changelinetextbox = vbCrLf

Sub Serial_GetExistingCombo(Combo As ComboBox, pft As String)
    Dim isistitle As ClIsisDll
    Dim i As Long
    Dim tmp As String
    
    Set isistitle = New ClIsisDll
    With TitleDB
    If isistitle.Initiate(.FullPath, .File, .Label) Then
        Combo.Clear
        For i = 1 To isistitle.MfnQuantity
            tmp = isistitle.UsePft(i, pft)
            If Len(tmp) > 0 Then
                Combo.AddItem tmp
            End If
        Next
    End If
    End With
    Set isistitle = Nothing
End Sub

Sub Serial_GetExisting(List As ListBox)
    Dim isistitle As ClIsisDll
    Dim i As Long
    Dim tmp As String
    
    Set isistitle = New ClIsisDll
    With TitleDB
    If isistitle.Initiate(.FullPath, .File, .Label) Then
        List.Clear
        For i = 1 To isistitle.MfnQuantity
            tmp = isistitle.UsePft(i, .Field)
            If Len(tmp) > 0 Then
                List.AddItem tmp
            End If
        Next
    End If
    End With
    Set isistitle = Nothing
End Sub

Function Serial_CheckExisting(SerialTitle_to_find As String) As Long
    Dim isistitle As ClIsisDll
    Dim mfn As Long
    Dim SerialTitle As String
    Dim found As Boolean
    
    Set isistitle = New ClIsisDll
    With TitleDB
    If isistitle.Initiate(.FullPath, .File, .Label) Then
        If isistitle.IfCreate(.InvFile) Then
            mfn = isistitle.MfnFindOne(SerialTitle_to_find)
            If mfn > 0 Then
                SerialTitle = isistitle.UsePft(mfn, .Field)
                If StrComp(SerialTitle, SerialTitle_to_find) = 0 Then
                    found = True
                End If
            End If
        End If
        If Not found Then
            mfn = 0
            While (mfn < isistitle.MfnQuantity) And (Not found)
                mfn = mfn + 1
                SerialTitle = isistitle.UsePft(mfn, .Field)
                If StrComp(SerialTitle, SerialTitle_to_find) = 0 Then
                    found = True
                End If
            Wend
        End If
    End If
    End With
    If found Then
        Serial_CheckExisting = mfn
    End If
    Set isistitle = Nothing
End Function

Function Serial_TxtContent(mfn As Long, tag As Long, Optional language As String) As String
    Dim isistitle As ClIsisDll
    Dim content As String
    Dim sep As String
    
    sep = "%"
    
    Set isistitle = New ClIsisDll
    With TitleDB
    If isistitle.Initiate(.FullPath, .File, .Label) Then
        If Len(language) = 0 Then
            content = isistitle.UsePft(mfn, "(v" + CStr(tag) + "+|" + sep + "|)")
        Else
            content = isistitle.UsePft(mfn, "(if v" + CStr(tag) + "^l='" + language + "' then v" + CStr(tag) + "^* fi)")
        End If
        content = ReplaceString(content, sep, changelinetextbox, vbTextCompare)
    End If
    Set isistitle = Nothing
    End With
    Serial_TxtContent = content
End Function

Sub UnselectList(List As ListBox)
    Dim i As Long
    
    For i = 0 To List.ListCount - 1
        List.Selected(i) = False
    Next
End Sub


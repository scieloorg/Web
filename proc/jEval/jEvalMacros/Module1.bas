Attribute VB_Name = "Module1"
Option Explicit

Public MacroFilename As String
Public visible_processing As String
Public lang As String
Public labels As New ClsLabels

Sub Main()

    Call readConfig
    FormSelectParameters.Show vbModal
    
    Unload FormSelectDir
    Unload FormSelectParameters
    End
End Sub

Function executeMacro(source_path As String, excel_filename As String, ByRef msgError As String) As Boolean
   ' Declare variables.
   
   ' Run the macro Receiver and pass the variables to the
   ' subroutine.
   ' On a Macintosh computer, you may need to omit the .xls file
   ' extension.
   Dim oExcelApp As excel.Application

    msgError = ""
   ' Create a reference to the currently running excel application
   
   ' Make the Excel Application Visible.
   Set oExcelApp = New excel.Application
   
   If visible_processing = "1" Then
    oExcelApp.visible = True
   End If
   
   Call FileCopy(App.Path & "\" & MacroFilename, excel_filename & ".bkp")
   
   'MsgBox Dir(excel_filename, vbNormal) & vbCrLf & Mid(excel_filename, InStrRev(excel_filename, "\") + 1)
   
   If Dir(excel_filename, vbNormal) = Mid(excel_filename, InStrRev(excel_filename, "\") + 1) Then
    Kill excel_filename
   End If
   Call oExcelApp.Workbooks.Open(excel_filename & ".bkp")
   Call oExcelApp.Run("Export", source_path, excel_filename)
      
   Call oExcelApp.Workbooks.Close
   Call oExcelApp.Quit
   Call Kill(excel_filename & ".bkp")
   If Dir(excel_filename, vbNormal) = Mid(excel_filename, InStrRev(excel_filename, "\") + 1) Then
       executeMacro = True
   Else
       executeMacro = False
   End If
   'ActiveWorkbook.Close    ' Closes the workbook Book1.xls.
   
   
   Exit Function
   
display_error:
    msgError = Err.Description
   executeMacro = False
End Function



Sub readConfig()
    Dim f As Long
    Dim label As String
    Dim content As String
    Dim visible As String
    f = FreeFile
    Open "config.ini" For Input As #f
    Input #f, label, content
    MacroFilename = content
    Input #f, label, content
    visible_processing = content
    Input #f, label, content
    lang = content
    Close #f
    
    Open lang & "_labels.ini" For Input As #f
    While Not EOF(f)
        Input #f, label, content
        Call labels.add(label, content)
    Wend
    
    Close #f
    
End Sub

Attribute VB_Name = "Module1"
Option Explicit

Public MACRO_FUNCTION As String
Public visible_processing As String
Public lang As String
Public labels As New ClsLabels

'Sub Main()

'    Call readConfig
'    FormSelectParameters.Show vbModal
    
'    Unload FormSelectDir
'    Unload FormSelectParameters
'    End
'End Sub

Function executeMacro(source_path As String, excel_filename As String, ByRef msgError As String, src_excel_filename As String) As Boolean
   ' Declare variables.
   
   ' Run the macro Receiver and pass the variables to the
   ' subroutine.
   ' On a Macintosh computer, you may need to omit the .xls file
   ' extension.
   Dim oExcelApp As excel.Application
   Dim backup As String
   Dim SOURCE_EXCEL As String
    msgError = ""
   ' Create a reference to the currently running excel application
   
   ' Make the Excel Application Visible.
   Set oExcelApp = New excel.Application
   
   backup = excel_filename & ".bkp.xls"
   If visible_processing = "1" Then
    oExcelApp.visible = True
   End If
   
   Call FileCopy(App.Path & "\" & MACRO_FUNCTION & ".xls", backup)
   
   
   'MsgBox Dir(excel_filename, vbNormal) & vbCrLf & Mid(excel_filename, InStrRev(excel_filename, "\") + 1)
   Call oExcelApp.Workbooks.Open(backup)
   Call oExcelApp.Run("Export", source_path, excel_filename, src_excel_filename)
   ' Case "history"
     '   Call oExcelApp.Run("Export", source_path, excel_filename)
        
        'SOURCE_EXCEL = excel_filename & ".old.xls"
        'Call FileCopy(excel_filename, SOURCE_EXCEL)
        'Kill excel_filename
        'Call oExcelApp.Run("UpdateHistory", source_path, excel_filename, SOURCE_EXCEL)
        'Kill SOURCE_EXCEL
    'End Select
   Call oExcelApp.Workbooks.Close
   Call oExcelApp.Quit
   
   'Call FileCopy(backup, excel_filename)
   If Dir(excel_filename, vbNormal) = Mid(excel_filename, InStrRev(excel_filename, "\") + 1) Then
       executeMacro = True
   Else
       executeMacro = False
   End If
   Call Kill(backup)
   
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
    MACRO_FUNCTION = content
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

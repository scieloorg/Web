Attribute VB_Name = "ModLabel"
Option Explicit

Public CurrCodeIdiom As String

Public File As String
Public lOpen As String
Public SerialTitles As String
Public SerialIssues As String
Public Edit As String
Public Options As String
Public Configuration As String
Public Help As String
Public Contents As String
Public About As String
Public lExit As String
Public Title As String
Public ShortTitle As String
Public AlternativeTitles As String
Public Publisher As String
Public issn As String
Public lClose As String
Public Volume As String
Public VolSuppl As String
Public Issueno As String
Public IssueSuppl As String
Public SequentialNumber As String



Sub ReadLabelFile()
    Dim fn As Long
    Dim Info As String
    
    Open CurrCodeIdiom + "_labels.ini" For Input As fn
    Input #fn, File
    Input #fn, lOpen
    Input #fn, SerialTitles
    Input #fn, SerialIssues
    Input #fn, Edit
    Input #fn, Options
    Input #fn, Configuration
    Input #fn, Help
    Input #fn, Contents
    Input #fn, About
    Input #fn, lExit
    Input #fn, Title
    Input #fn, ShortTitle
    Input #fn, AlternativeTitles
    Input #fn, Publisher
    Input #fn, issn
    Input #fn, lClose
    Input #fn, Volume
    Input #fn, VolSuppl
    Input #fn, Issueno
    Input #fn, IssueSuppl
    Input #fn, SequentialNumber
    
    Close fn
End Sub

Sub ChangeLabels()
    
    With FormMenuPrin
    .mnArquivo.Caption = File
    .mnEdit.Caption = Edit
    .mnOpcoes.Caption = Options
    .mnAbout.Caption = About
    .mnAbrir.Caption = lOpen
    .mnSair.Caption = lExit
    .mnAjuda.Caption = Help
    .mnConfig.Caption = Configuration
    .mnContent.Caption = Contents
    .mnIssues.Caption = SerialIssues
    .mnSerial.Caption = SerialTitles
    End With
    

End Sub

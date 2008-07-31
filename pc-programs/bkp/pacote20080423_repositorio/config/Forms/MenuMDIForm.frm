VERSION 5.00
Begin VB.MDIForm MenuMDIForm 
   BackColor       =   &H8000000C&
   Caption         =   "Title Manager"
   ClientHeight    =   5985
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6630
   Icon            =   "MenuMDIForm.frx":0000
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   3  'Windows Default
End
Attribute VB_Name = "MenuMDIForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Sub OpenMenu()
    With MenuMDIForm
    .SetLabels
    .Show  'vbModal
    End With
End Sub


Sub SetLabels()
    With ConfigLabels
    Caption = Mid(App.Title + " - ", 1, Len(App.Title + " - ") - 2)
    mnArquivo.Caption = .mnFile
    mnOpcoes.Caption = .mnOptions
    mnAbout.Caption = .mnAbout
    mnAbrir.Caption = .ButtonOpen
    mnSair.Caption = .mnExit
    mnAjuda.Caption = .mnHelp
    mnConfig.Caption = .mnConfiguration
    mnContent.Caption = .mnContents
    mnIssues.Caption = .mnSerialIssues
    mnSection.Caption = .mnSerialSections
    mnSerial.Caption = .mnSerialTitles
    mnNewSerial.Caption = .mnCreateSerial
    mnExistingSerial.Caption = .mnOpenExistingSerial
    mnRmSerial.Caption = .mnRemoveSerial
    End With
End Sub


VERSION 5.00
Begin VB.Form FrmInfo 
   AutoRedraw      =   -1  'True
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Info"
   ClientHeight    =   5505
   ClientLeft      =   7950
   ClientTop       =   1275
   ClientWidth     =   1920
   Icon            =   "FrmInfo.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5505
   ScaleWidth      =   1920
   Begin VB.TextBox TxtHelp 
      Height          =   5295
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   120
      Width           =   1695
   End
End
Attribute VB_Name = "FrmInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'SERIAL
Public Help1_issn As String
Public Help1_Title As String
Public Help1_Subtitle As String
Public Help1_SectionTitle As String
Public Help1_ShortTitle As String
Public Help1_ISOStitle As String
Public Help1_OtherTitles As String
Public Help1_ParallelTitles As String
Public Help1_OldTitle As String
Public Help1_NewTitle As String
Public Help1_IsSuppl As String
Public Help1_HasSuppl As String

'Serial2
Public Help2_Mission As String
Public Help2_Subject As String
Public Help2_StudyArea As String
Public Help2_LiterType As String
Public Help2_TreatLevel As String
Public Help2_PubLevel As String
Public Help2_Scheme As String

'Serial3
Public Help3_InitDate As String
Public Help3_InitVol As String
Public Help3_InitNo As String
Public Help3_TermDate As String
Public Help3_FinVol As String
Public Help3_FinNo As String
Public Help3_Freq As String
Public Help3_PubStatus As String
Public Help3_Alphabet As String
Public Help3_TxtIdiom As String
Public Help3_AbstIdiom As String
Public Help3_NationalCode As String
Public Help3_Classif As String
Public Help3_Standard As String
Public Help3_Publisher As String
Public Help3_PubCountry As String
Public Help3_PubState As String
Public Help3_PubCity As String

'Serial4
Public Help4_Address As String
Public Help4_Phone As String
Public Help4_Fax As String
Public Help4_email As String
Public Help4_cprightDate As String
Public Help4_cprighter As String
Public Help4_sponsor As String
Public Help4_FrameInfoHealth As String
Public Help4_secs As String
Public Help4_medline As String
Public Help4_MedlineStitle As String
Public Help4_idxRange As String

'Serial5
Public Help5_notes As String
Public Help5_SciELONet As String
Public Help5_siglum As String
Public Help5_PubId As String
Public Help5_Sep As String
Public Help5_SiteLocation As String
Public Help5_FTP As String
Public Help5_issntype As String
Public Help5_UserSubscription As String
Public Help5_CCode As String
Public Help5_IdNumber As String
Public Help5_DocCreation As String
Public Help5_CreatDate As String
Public Help5_DocUpdate As String
Public Help5_UpdateDate As String

'Serial 6
Public Help6_JournalStatus As String


Sub SetHelps(CurrCodeIdiom As String)
    
    Dim fn As Long
    
    fn = 1
    Open App.path + "\" + CurrCodeIdiom + "_help.ini" For Input As fn
        
    Line Input #fn, Help1_issn
    Line Input #fn, Help1_Title
    Line Input #fn, Help1_Subtitle
    Line Input #fn, Help1_ShortTitle
    Line Input #fn, Help1_ISOStitle
    Line Input #fn, Help1_SectionTitle
    Line Input #fn, Help1_ParallelTitles
    Line Input #fn, Help1_OtherTitles
    Line Input #fn, Help1_OldTitle
    Line Input #fn, Help1_NewTitle
    Line Input #fn, Help1_IsSuppl
    Line Input #fn, Help1_HasSuppl
    
    Line Input #fn, Help2_Mission
    Line Input #fn, Help2_Subject
    Line Input #fn, Help2_StudyArea
    Line Input #fn, Help2_LiterType
    Line Input #fn, Help2_TreatLevel
    Line Input #fn, Help2_PubLevel
    Line Input #fn, Help2_Scheme
'Serial3
    Line Input #fn, Help3_InitDate
    Line Input #fn, Help3_InitVol
    Line Input #fn, Help3_InitNo
    Line Input #fn, Help3_TermDate
    Line Input #fn, Help3_FinVol
    Line Input #fn, Help3_FinNo
    Line Input #fn, Help3_Freq
    Line Input #fn, Help3_PubStatus
    Line Input #fn, Help3_Alphabet
    Line Input #fn, Help3_TxtIdiom
    Line Input #fn, Help3_AbstIdiom
    Line Input #fn, Help3_NationalCode
    Line Input #fn, Help3_Classif
    Line Input #fn, Help3_Standard
    Line Input #fn, Help3_Publisher
    Line Input #fn, Help3_PubCountry
    Line Input #fn, Help3_PubState
    Line Input #fn, Help3_PubCity
    
'Serial4
    Line Input #fn, Help4_Address
    Line Input #fn, Help4_Phone
    Line Input #fn, Help4_Fax
    Line Input #fn, Help4_email
    Line Input #fn, Help4_cprightDate
    Line Input #fn, Help4_cprighter
    Line Input #fn, Help4_sponsor
    Line Input #fn, Help4_secs
    Line Input #fn, Help4_medline
    Line Input #fn, Help4_MedlineStitle
    Line Input #fn, Help4_idxRange

'Serial5
    Line Input #fn, Help5_notes
    
    Line Input #fn, Help5_siglum
    Line Input #fn, Help5_PubId
    Line Input #fn, Help5_Sep
    Line Input #fn, Help5_SiteLocation
    Line Input #fn, Help5_FTP
    Line Input #fn, Help5_UserSubscription
    Line Input #fn, Help5_SciELONet
    Line Input #fn, Help5_issntype
    Line Input #fn, Help5_CCode
    Line Input #fn, Help5_IdNumber
    Line Input #fn, Help5_DocCreation
    Line Input #fn, Help5_CreatDate
    Line Input #fn, Help5_DocUpdate
    Line Input #fn, Help5_UpdateDate
    Line Input #fn, Help6_JournalStatus
        
    Close fn
    
    
End Sub

Sub ShowHelpMessage(HelpText As String, Optional Position As Integer)
    'Static EnableEdition As Boolean
    
    'If EnableEdition Then
    '    EnableEdition = False
    'Else
        'EnableEdition = True
        TxtHelp.text = ReplaceString(HelpText, "vbCrlf", vbCrLf)
        'Me.Show
        'Me.SetFocus
        Select Case Position
        Case 1
            'Call FrmInfo.Move(Serial1.Left + Serial1.Width / 3, Serial1.Top + Serial1.Height / 1.5)
        Case 2
            'Call FrmInfo.Move(Serial1.Left + Serial1.Width / 3, (Serial1.Top) / 1.5)
        End Select
    'End If
End Sub


Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    If UnloadMode = vbFormControlMenu Then
        Cancel = 1
        'MsgBox ConfigLabels.MsgClosebyCancelorClose
    End If
End Sub

Private Sub Form_Resize()
    TxtHelp.Width = Width * 0.85
End Sub


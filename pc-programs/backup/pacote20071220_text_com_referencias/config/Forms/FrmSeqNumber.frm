VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Begin VB.Form FrmSeqNumber 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "List of Sequential numbers"
   ClientHeight    =   5655
   ClientLeft      =   2040
   ClientTop       =   1755
   ClientWidth     =   7950
   Icon            =   "FrmSeqNumber.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5655
   ScaleWidth      =   7950
   StartUpPosition =   2  'CenterScreen
   Begin ComctlLib.ListView ListView1 
      Height          =   4815
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   7695
      _ExtentX        =   13573
      _ExtentY        =   8493
      View            =   3
      Arrange         =   1
      LabelEdit       =   1
      Sorted          =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   327682
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      Appearance      =   1
      NumItems        =   6
      BeginProperty ColumnHeader(1) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
         Key             =   ""
         Object.Tag             =   ""
         Text            =   "sequential number"
         Object.Width           =   0
      EndProperty
      BeginProperty ColumnHeader(2) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
         SubItemIndex    =   1
         Key             =   ""
         Object.Tag             =   ""
         Text            =   "sertitle"
         Object.Width           =   2540
      EndProperty
      BeginProperty ColumnHeader(3) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
         Alignment       =   1
         SubItemIndex    =   2
         Key             =   ""
         Object.Tag             =   ""
         Text            =   "volume"
         Object.Width           =   0
      EndProperty
      BeginProperty ColumnHeader(4) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
         Alignment       =   1
         SubItemIndex    =   3
         Key             =   ""
         Object.Tag             =   ""
         Text            =   "volume suppl"
         Object.Width           =   0
      EndProperty
      BeginProperty ColumnHeader(5) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
         Alignment       =   1
         SubItemIndex    =   4
         Key             =   ""
         Object.Tag             =   ""
         Text            =   "number"
         Object.Width           =   0
      EndProperty
      BeginProperty ColumnHeader(6) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
         Alignment       =   1
         SubItemIndex    =   5
         Key             =   ""
         Object.Tag             =   ""
         Text            =   "number suppl"
         Object.Width           =   0
      EndProperty
   End
   Begin VB.CommandButton CmdNext 
      Caption         =   "Next"
      Height          =   375
      Left            =   5640
      TabIndex        =   2
      Top             =   5160
      Width           =   975
   End
   Begin VB.CommandButton CmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   6840
      TabIndex        =   1
      Top             =   5160
      Width           =   975
   End
End
Attribute VB_Name = "FrmSeqNumber"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private SelectedVolid As String
Private SelectedSupplVol As String
Private SelectedIssueno As String
Private SelectedSupplno As String
Private SelectedIseqno As String
Private OK As Boolean

Public Sub ViewIseqNo(Sertitle As String, volid As String, supplvol As String, Issueno As String, Supplno As String, iseqno As String)
    Dim Item As ListItem
    Dim i As Long
    Dim q As Long
    Dim Mfns() As Long
    Dim term As String
    Dim mfn As Long
    
    
    SelectedVolid = ""
    SelectedSupplVol = ""
    SelectedIssueno = ""
    SelectedSupplno = ""
    SelectedIseqno = ""
    
    If Len(volid) > 0 Then
        term = "V=" + volid + "," + Sertitle
    Else
        term = "SERTIT=" + Sertitle
    End If
    q = BDIssues.MfnFind(term, Mfns)
    For i = 1 To q
        mfn = 0
        If (StrComp(BDIssues.UsePft(Mfns(i), "v130"), Sertitle) = 0) Then
            If (Len(volid) > 0) Then
                If (StrComp(BDIssues.UsePft(Mfns(i), "v31"), volid) = 0) Then
                    mfn = Mfns(i)
                End If
            Else
                mfn = Mfns(i)
            End If
        End If
        If mfn > 0 Then
            Set Item = ListView1.ListItems.Add(, , BDIssues.UsePft(mfn, "v36"))
            Item.SubItems(1) = BDIssues.UsePft(mfn, "v30")
            Item.SubItems(2) = BDIssues.UsePft(mfn, "v31")
            Item.SubItems(3) = BDIssues.UsePft(mfn, "v131")
            Item.SubItems(4) = BDIssues.UsePft(mfn, "v32")
            Item.SubItems(5) = BDIssues.UsePft(mfn, "v132")
        End If
    Next
    For i = 1 To ListView1.ColumnHeaders.Count
        ListView1.ColumnHeaders(i).Width = ListView1.Width / (ListView1.ColumnHeaders.Count * 2)
    Next
    
    ListView1.SortKey = 0
    ListView1.SortOrder = lvwDescending
    ListView1.Sorted = True
    
    Show vbModal
    If OK Then
        volid = SelectedVolid
        supplvol = SelectedSupplVol
        Issueno = SelectedIssueno
        Supplno = SelectedSupplno
        iseqno = SelectedIseqno
    End If
End Sub

Private Sub CmdClose_Click()
    OK = False
    Unload Me
End Sub

Private Sub CmdNext_Click()
    OK = True
    Unload Me
End Sub

Private Sub Form_Load()
    With ConfigLabels
    CmdNext.Caption = .ButtonOK
    CmdClose.Caption = .ButtonClose
    End With
End Sub

Private Sub ListView1_ColumnClick(ByVal ColumnHeader As ComctlLib.ColumnHeader)
    ListView1.SortKey = ColumnHeader.index - 1
    ListView1.SortOrder = lvwDescending
    ListView1.Sorted = True
End Sub

Private Sub ListView1_ItemClick(ByVal Item As ComctlLib.ListItem)
    
        SelectedVolid = ListView1.ListItems(Item.index).SubItems(2)
        SelectedSupplVol = ListView1.ListItems(Item.index).SubItems(3)
        SelectedIssueno = ListView1.ListItems(Item.index).SubItems(4)
        SelectedSupplno = ListView1.ListItems(Item.index).SubItems(5)
        SelectedIseqno = ListView1.ListItems(Item.index).Text
End Sub

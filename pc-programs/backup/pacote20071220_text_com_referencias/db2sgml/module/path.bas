Attribute VB_Name = "Path"
Public NodeFatherKey() As String
Public NodeChild() As String
Public NodeInfo() As String
Public FileNotRequired() As Boolean
Public Counter As Long

Property Get NotRequiredFile(i As Long) As Boolean
    NotRequiredFile = FileNotRequired(i)
End Property

Public Sub ReadDirTree(file As String)
    Dim fn As Long
    Dim Father As String
    Dim Child As String
    Dim Info As String
    Dim NotRequired As Integer
    
    Counter = 0
    fn = FreeFile
    Open file For Input As fn
    While Not EOF(fn)
        Input #fn, Father, Child, Info, NotRequired
        
        Counter = Counter + 1
        ReDim Preserve NodeFatherKey(Counter)
        ReDim Preserve NodeChild(Counter)
        ReDim Preserve NodeInfo(Counter)
        ReDim Preserve FileNotRequired(Counter)
        
        NodeFatherKey(Counter) = Father
        NodeChild(Counter) = Child
        NodeInfo(Counter) = Info
        FileNotRequired(Counter) = (NotRequired = 1)
    Wend
    Close fn
End Sub
Public Sub MakeTree()
    Dim i As Long
  
    
    For i = 1 To Counter
        Call CreateNode(NodeInfo(i), NodeChild(i), NodeFatherKey(i))
    Next
End Sub
Private Sub CreateNode(Info As String, Child As String, Father As String)
    
    If Len(Father) > 0 Then
        Call FrmBase2Doc.DirTree.Nodes.Add(Father, tvwChild, Info, Child)
    Else
        Call FrmBase2Doc.DirTree.Nodes.Add(, , Info, Child)
    End If
    FrmBase2Doc.DirTree.Nodes(Info).Expanded = True
End Sub



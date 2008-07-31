VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ColPath"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"ClPath"
Attribute VB_Ext_KEY = "Member0" ,"ClPath"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

'local variable to hold collection
Private mCol As Collection

Public Function Add(Optional DirName As String, Optional FileName As String, Optional label As String, Optional PType As String, Optional NotChecked As Boolean, Optional sKey As String) As ClPath
    'create a new object
    Dim objNewMember As ClPath
    Set objNewMember = New ClPath


    'set the properties passed into the method
    objNewMember.Parent.FullPath = DirName
    objNewMember.FileName = FileName
    objNewMember.label = label
    objNewMember.NotChecked = NotChecked
    objNewMember.PType = PType
    objNewMember.Key = sKey

    If Len(sKey) = 0 Then
        mCol.Add objNewMember
    Else
        mCol.Add objNewMember, sKey
    End If


    'return the object created
    Set Add = objNewMember
    Set objNewMember = Nothing


End Function

Public Property Get Item(vntIndexKey As Variant, Optional exist As Boolean) As ClPath
Attribute Item.VB_UserMemId = 0
    'used when referencing an element in the collection
    'vntIndexKey contains either the Index or Key to the collection,
    'this is why it is declared as a Variant
    'Syntax: Set foo = x.Item(xyz) or Set foo = x.Item(5)
    On Error GoTo NoExist
  Set Item = mCol(vntIndexKey)
  exist = True
  Exit Property
NoExist:
  exist = False
End Property



Public Property Get Count() As Long
    'used when retrieving the number of elements in the
    'collection. Syntax: Debug.Print x.Count
    Count = mCol.Count
End Property


Public Sub Remove(vntIndexKey As Variant)
    'used when removing an element from the collection
    'vntIndexKey contains either the Index or Key, which is why
    'it is declared as a Variant
    'Syntax: x.Remove(xyz)


    mCol.Remove vntIndexKey
End Sub


Public Property Get NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    'this property allows you to enumerate
    'this collection with the For...Each syntax
    Set NewEnum = mCol.[_NewEnum]
End Property


Private Sub Class_Initialize()
    'creates the collection when this class is created
    Set mCol = New Collection
End Sub


Private Sub Class_Terminate()
    'destroys collection when this class is terminated
    Set mCol = Nothing
End Sub

Function Checkdirstruct.nodes(Drv As String, Root As String) As Boolean
    Dim i As Long
    Dim ret As Boolean
    
    Root = Drv + pathsep + Item("work").Parent.FullPath
    ret = True
    If DirExist(Root, Item("work").Key) Then
        For i = 1 To Count
            ret = ret And Item(i).Check(Root)
        Next
    End If
    CheckPaths = ret
End Function



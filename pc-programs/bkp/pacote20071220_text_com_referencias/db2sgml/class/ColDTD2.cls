VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ColDTD"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"ClDTD"
Attribute VB_Ext_KEY = "Member0" ,"ClDTD"
Attribute VB_Ext_KEY = "Member1" ,"ClDTD"
'local variable to hold collection
Private mCol As Collection
Public Function Add(Name As String, DoGizmo As Boolean, CreateCipFile As Boolean, RecIdField As Long, ValidRecords As String, FileNameField As Long) As ClDTD

    'create a new object
    Dim objNewMember As ClDTD
    Set objNewMember = New ClDTD


    'set the properties passed into the method
    objNewMember.CreateCipFile = CreateCipFile
    objNewMember.Name = Name
    objNewMember.DoGizmo = DoGizmo
    objNewMember.RecIdField = RecIdField
    objNewMember.ValidRecords = ValidRecords
    objNewMember.FileNameField = FileNameField




    If Len(Name) = 0 Then
        mCol.Add objNewMember
    Else
        mCol.Add objNewMember, Name
    End If


    'return the object created
    Set Add = objNewMember
    Set objNewMember = Nothing


End Function

Public Property Get Item(vntIndexKey As Variant, Optional exist As Boolean) As ClDTD
Attribute Item.VB_UserMemId = 0
    'used when referencing an element in the collection
    'vntIndexKey contains either the Index or Key to the collection,
    'this is why it is declared as a Variant
    'Syntax: Set foo = x.Item(xyz) or Set foo = x.Item(5)
    On Error GoTo NOExist
    Set Item = mCol(vntIndexKey)
    exist = True
    Exit Property
NOExist:
    Set Item = Nothing
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


Private Sub Class_Initialize()
    'creates the collection when this class is created
    Set mCol = New Collection
End Sub


Private Sub Class_Terminate()
    'destroys collection when this class is terminated
    Set mCol = Nothing
End Sub


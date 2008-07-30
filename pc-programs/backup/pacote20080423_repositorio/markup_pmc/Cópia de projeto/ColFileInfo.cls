VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ColFileInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'local variable to hold collection
Private mCol As collection
Public Key As String
Private keylist As New ColFileInfo

Public Function add(SKEY As String) As ClFileInfo
    'create a new object
    Dim objNewMember As ClFileInfo
    
    Set objNewMember = New ClFileInfo
    
    'set the properties passed into the method
    If Len(SKEY) = 0 Then
        mCol.add objNewMember
    Else
        mCol.add objNewMember, SKEY
    End If
    
    'return the object created
    Set add = objNewMember
    Set objNewMember = Nothing


End Function



Public Property Get Item(vntIndexKey As Variant, Optional exist As Boolean) As ClFileInfo
    'used when referencing an element in the collection
    'vntIndexKey contains either the Index or Key to the collection,
    'this is why it is declared as a Variant
    'Syntax: Set foo = x.Item(xyz) or Set foo = x.Item(5)
  On Error GoTo notexist
  Set Item = mCol(vntIndexKey)
  exist = True
  Exit Property
notexist:
    Set Item = Nothing
    exist = False
End Property



Public Property Get count() As Long
    'used when retrieving the number of elements in the
    'collection. Syntax: Debug.Print x.Count
    count = mCol.count
End Property


Public Sub remove(vntIndexKey As Variant)
    'used when removing an element from the collection
    'vntIndexKey contains either the Index or Key, which is why
    'it is declared as a Variant
    'Syntax: x.Remove(xyz)


    mCol.remove vntIndexKey
End Sub


Private Sub Class_Initialize()
    'creates the collection when this class is created
    Set mCol = New collection
    'Set keylist = new colFileInfo
End Sub


Private Sub Class_Terminate()
    'destroys collection when this class is terminated
    Set mCol = Nothing
    Set keylist = Nothing
End Sub



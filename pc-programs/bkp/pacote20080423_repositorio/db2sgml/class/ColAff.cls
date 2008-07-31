VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ColAff"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"ClAff"
Attribute VB_Ext_KEY = "Member0" ,"ClAff"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

'local variable to hold collection
Private mCol As Collection
Public Function Add(orgname As String, city As String, state As String, country As String, zipcode As String, Optional sKey As String, Optional orgdiv As String, Optional orgdiv2 As String, Optional orgdiv3 As String, Optional id As String) As ClAff
    'create a new object
    Dim objNewMember As ClAff
    Set objNewMember = New ClAff


    'set the properties passed into the method
    objNewMember.orgname = orgname
    objNewMember.orgdiv = orgdiv
    objNewMember.orgdiv2 = orgdiv2
    objNewMember.orgdiv3 = orgdiv3
    objNewMember.city = city
    objNewMember.state = state
    objNewMember.country = country
    objNewMember.zipcode = zipcode
    objNewMember.id = id




    If Len(sKey) = 0 Then
        mCol.Add objNewMember
    Else
        mCol.Add objNewMember, sKey
    End If


    'return the object created
    Set Add = objNewMember
    Set objNewMember = Nothing


End Function

Public Property Get Item(vntIndexKey As Variant, exist As Boolean) As ClAff
Attribute Item.VB_UserMemId = 0
    'used when referencing an element in the collection
    'vntIndexKey contains either the Index or Key to the collection,
    'this is why it is declared as a Variant
    'Syntax: Set foo = x.Item(xyz) or Set foo = x.Item(5)
      On Error GoTo notexist
    
  Set Item = mCol(vntIndexKey)
  exist = True
  
  Exit Property
  
notexist:
    exist = False
    Set Item = Nothing

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


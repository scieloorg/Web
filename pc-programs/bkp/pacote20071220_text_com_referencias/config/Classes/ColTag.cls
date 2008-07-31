VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ColTag"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"ClTag"
Attribute VB_Ext_KEY = "Member0" ,"ClTag"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

'local variable to hold collection
Private mCol As Collection
Private Keys As ColKey

Public Function Add(label As String, Key As String, Value As Long, Subf As String, sKey As String) As ClTag
    'create a new object
    Dim objNewMember As ClTag
    Set objNewMember = New ClTag


    'set the properties passed into the method
    objNewMember.label = label
    objNewMember.Key = Key
    objNewMember.Value = Value
    objNewMember.Subf = Subf

    If Len(sKey) = 0 Then
        mCol.Add objNewMember
    Else
        mCol.Add objNewMember, sKey
        
    End If
    If Len(label) > 0 Then Call Keys.Add(mCol.Count, CStr(Value) + Subf)
    
    'return the object created
    Set Add = objNewMember
    Set objNewMember = Nothing


End Function

Public Property Get Item(vntIndexKey As Variant, Optional exist As Boolean) As ClTag
Attribute Item.VB_UserMemId = 0
    'used when referencing an element in the collection
    'vntIndexKey contains either the Index or Key to the collection,
    'this is why it is declared as a Variant
    'Syntax: Set foo = x.Item(xyz) or Set foo = x.Item(5)
    Dim x As ClKey
    
    Set x = Keys(vntIndexKey, exist)
    
    On Error GoTo NoExist
    If exist Then
        Set Item = mCol(x.index)
    Else
        Set Item = mCol(vntIndexKey)
        exist = True
    End If
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
    Dim x As ClTag
    Dim exist As Boolean
    
    Set x = Item(vntIndexKey, exist)

    If exist Then
        Keys.Remove CStr(x.Value)
        mCol.Remove vntIndexKey
    End If
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
    Set Keys = New ColKey
End Sub


Private Sub Class_Terminate()
    'destroys collection when this class is terminated
    Set mCol = Nothing
    Set Keys = Nothing
End Sub

Function CheckTags(Key) As Boolean
    Dim Ret As Boolean
    
    With Item(Key)
        If .Value > 0 Then
            Ret = True
        Else
            MsgBox ("Invalid value of tag " + .label + ": " + CStr(.Value) + "^" + .Subf)
        End If
    End With
    CheckTags = Ret
End Function




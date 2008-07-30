VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClVarConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

'local variable(s) to hold property value(s)
Private mvarNome As String 'local copy
Private mvarValue As Variant 'local copy
Private mvarObjLabel As Object 'local copy
Private mvarObjText As Object 'local copy
Private mvarKey As String 'local copy
Private mvarTipo As String 'local copy

Public Property Let Tipo(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Tipo = 5
    mvarTipo = vData
End Property

Public Property Get Tipo() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Tipo
    Tipo = mvarTipo
End Property

Public Property Let Key(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Key = 5
    mvarKey = vData
End Property

Public Property Get Key() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Key
    Key = mvarKey
End Property

Public Property Set ObjText(ByVal vData As Object)
'used when assigning an Object to the property, on the left side of a Set statement.
'Syntax: Set x.ObjText = Form1
    Set mvarObjText = vData
End Property

Public Property Get ObjText() As Object
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.ObjText
    Set ObjText = mvarObjText
End Property

Public Property Set ObjLabel(ByVal vData As Object)
'used when assigning an Object to the property, on the left side of a Set statement.
'Syntax: Set x.ObjLabel = Form1
    Set mvarObjLabel = vData
End Property

Public Property Get ObjLabel() As Object
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.ObjLabel
    Set ObjLabel = mvarObjLabel
End Property

Public Property Let Value(ByVal vData As Variant)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Value = 5
    mvarValue = vData
End Property

Public Property Set Value(ByVal vData As Object)
'used when assigning an Object to the property, on the left side of a Set statement.
'Syntax: Set x.Value = Form1
    Set mvarValue = vData
End Property

Public Property Get Value() As Variant
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Value
    If IsObject(mvarValue) Then
        Set Value = mvarValue
    Else
        Value = mvarValue
    End If
End Property

Public Property Let Nome(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Nome = 5
    mvarNome = vData
End Property

Public Property Get Nome() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Nome
    Nome = mvarNome
End Property


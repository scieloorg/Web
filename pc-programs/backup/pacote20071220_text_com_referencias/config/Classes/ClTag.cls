VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClTag"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

'local variable(s) to hold property value(s)
Private mvarLabel As String 'local copy
Private mvarKey As String 'local copy
Private mvarValue As Long 'local copy
Private mvarSubf As String 'local copy
Private mvarMandatory As Long  'local copy
Private mvarOptionsId As String 'local copy
Private mvarDispoValDBKey As String

Public Property Let DispoValDBKey(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.DispoValDBKey = 5
    mvarDispoValDBKey = vData
End Property


Public Property Get DispoValDBKey() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.DispoValDBKey
    DispoValDBKey = mvarDispoValDBKey
End Property


Public Property Let OptionsId(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.OptionsId = 5
    mvarOptionsId = vData
End Property


Public Property Get OptionsId() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.OptionsId
    OptionsId = mvarOptionsId
End Property


Public Property Let Mandatory(ByVal vData As Long)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Mandatory = 5
    mvarMandatory = vData
End Property


Public Property Get Mandatory() As Long
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Mandatory
    Mandatory = mvarMandatory

End Property


Public Property Let Subf(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Subf = 5
    mvarSubf = vData
End Property


Public Property Get Subf() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Subf
    Subf = mvarSubf
End Property



Public Property Let Value(ByVal vData As Long)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Value = 5
    mvarValue = vData
End Property


Public Property Get Value() As Long
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Value
    Value = mvarValue
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



Public Property Let label(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Label = 5
    mvarLabel = vData
End Property


Public Property Get label() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Label
    label = mvarLabel
End Property




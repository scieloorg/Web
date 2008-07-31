VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClPMTag"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'local variable(s) to hold property value(s)
Private mvartag As String 'local copy
Private mvarcolor As String 'local copy
Public Property Let COLOR(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.color = 5
    mvarcolor = vData
End Property


Public Property Get COLOR() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.color
    COLOR = mvarcolor
End Property



Public Property Let Tag(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.tag = 5
    mvartag = vData
End Property


Public Property Get Tag() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.tag
    Tag = mvartag
End Property




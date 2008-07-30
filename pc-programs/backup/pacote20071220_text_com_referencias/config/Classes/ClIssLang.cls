VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClIssLang"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

'local variable(s) to hold property value(s)
Private mvarFields As ColField 'local copy
Private mvarIdiom As String 'local copy
'local variable(s) to hold property value(s)
Private mvarindex As Long 'local copy
'local variable(s) to hold property value(s)
Private mvarIdiomCod As String 'local copy
Public Property Let IdiomCod(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.IdiomCod = 5
    mvarIdiomCod = vData
End Property


Public Property Get IdiomCod() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.IdiomCod
    IdiomCod = mvarIdiomCod
End Property



Public Property Let index(ByVal vData As Long)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Index = 5
    mvarindex = vData
End Property


Public Property Get index() As Long
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Index
    index = mvarindex
End Property



Public Property Let Idiom(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Idiom = 5
    mvarIdiom = vData
End Property


Public Property Get Idiom() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Idiom
    Idiom = mvarIdiom
End Property




Public Property Set Fields(ByVal vData As Object)
'used when assigning an Object to the property, on the left side of a Set statement.
'Syntax: Set x.Fields = Form1
    Set mvarFields = vData
End Property


Public Property Get Fields() As ColField
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Fields
    Set Fields = mvarFields
End Property




VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClAff"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

'local variable(s) to hold property value(s)
Private mvarorgname As String 'local copy
Private mvarorgdiv As String 'local copy
Private mvarorgdiv2 As String 'local copy
'local variable(s) to hold property value(s)
Private mvarorgdiv3 As String 'local copy
Private mvarcity As String 'local copy
Private mvarstate As String 'local copy
Private mvarcountry As String 'local copy
Private mvarzipcode As String 'local copy
Private mvarid As String 'local copy
Public Property Let id(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.id = 5
    mvarid = vData
End Property


Public Property Get id() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.id
    id = mvarid
End Property



Public Property Let zipcode(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.zipcode = 5
    mvarzipcode = vData
End Property


Public Property Get zipcode() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.zipcode
    zipcode = mvarzipcode
End Property



Public Property Let country(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.country = 5
    mvarcountry = vData
End Property


Public Property Get country() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.country
    country = mvarcountry
End Property



Public Property Let state(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.state = 5
    mvarstate = vData
End Property


Public Property Get state() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.state
    state = mvarstate
End Property



Public Property Let city(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.city = 5
    mvarcity = vData
End Property


Public Property Get city() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.city
    city = mvarcity
End Property



Public Property Let orgdiv3(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.orgdiv3 = 5
    mvarorgdiv3 = vData
End Property


Public Property Get orgdiv3() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.orgdiv3
    orgdiv3 = mvarorgdiv3
End Property



Public Property Let orgdiv2(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.orgdiv2 = 5
    mvarorgdiv2 = vData
End Property


Public Property Get orgdiv2() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.orgdiv2
    orgdiv2 = mvarorgdiv2
End Property



Public Property Let orgdiv(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.orgdiv = 5
    mvarorgdiv = vData
End Property


Public Property Get orgdiv() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.orgdiv
    orgdiv = mvarorgdiv
End Property



Public Property Let orgname(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.orgname = 5
    mvarorgname = vData
End Property


Public Property Get orgname() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.orgname
    orgname = mvarorgname
End Property




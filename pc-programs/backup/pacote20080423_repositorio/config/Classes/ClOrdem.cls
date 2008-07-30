VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClOrdem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

'set this to 0 to disable debug code in this class
#Const DebugMode = 1


#If DebugMode Then
    'local variable to hold the serialized class ID that was created in Class_Initialize
    Private mlClassDebugID As Long
#End If
'local variable(s) to hold property value(s)
Private mvarPosicao As Long 'local copy
'local variable(s) to hold property value(s)
Private mvarCod As Variant 'local copy
Private mvarTit As String 'local copy
Private mvarIndice As Long 'local copy
Public Property Let Indice(ByVal vData As Long)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Indice = 5
    mvarIndice = vData
End Property


Public Property Get Indice() As Long
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Indice
    Indice = mvarIndice
End Property



Public Property Let Tit(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Tit = 5
    mvarTit = vData
End Property


Public Property Get Tit() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Tit
    Tit = mvarTit
End Property



Public Property Let Cod(ByVal vData As Variant)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Cod = 5
    mvarCod = vData
End Property


Public Property Set Cod(ByVal vData As Object)
'used when assigning an Object to the property, on the left side of a Set statement.
'Syntax: Set x.Cod = Form1
    Set mvarCod = vData
End Property


Public Property Get Cod() As Variant
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Cod
    If IsObject(mvarCod) Then
        Set Cod = mvarCod
    Else
        Cod = mvarCod
    End If
End Property



Public Property Let Posicao(ByVal vData As Long)
    On Error GoTo PosicaoLetErr


'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Posicao = 5
    mvarPosicao = vData
    Exit Property


PosicaoLetErr:


    Call RaiseError(MyUnhandledError, "ClOrdem:Posicao Property Let")
End Property


Public Property Get Posicao() As Long
    On Error GoTo PosicaoGetErr


'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Posicao
    Posicao = mvarPosicao
    Exit Property


PosicaoGetErr:


    Call RaiseError(MyUnhandledError, "ClOrdem:Posicao Property Get")
End Property





Private Sub Class_Initialize()
    #If DebugMode Then
        'get the next available class ID, and print out
        'that the class was created successfully
        mlClassDebugID = GetNextClassDebugID()
        Debug.Print "'" & TypeName(Me) & "' instance " & mlClassDebugID & " created"
    #End If
End Sub


Private Sub Class_Terminate()
    'the class is being destroyed
    #If DebugMode Then
        Debug.Print "'" & TypeName(Me) & "' instance " & CStr(mlClassDebugID) & " is terminating"
    #End If
End Sub


#If DebugMode Then
    Public Property Get ClassDebugID()
        'if we are in debug mode, surface this property that consumers can query
        ClassDebugID = mlClassDebugID
    End Property
#End If


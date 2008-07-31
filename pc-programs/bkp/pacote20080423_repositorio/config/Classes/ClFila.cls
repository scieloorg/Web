VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClFila"
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
'local variable(s) to hold property value(s)
Private Fila As New Collection

Public Property Get Primeiro(Elem) As Boolean
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Primeiro
    Dim ret As Boolean
    
    On Error GoTo Err


    If Count > 0 Then
        If IsObject(Fila.Item(1)) Then
            Set Elem = Fila.Item(1)
        Else
            Elem = Fila.Item(1)
        End If
        ret = True
    End If


    Primeiro = ret
    Exit Property

Err:


    Call RaiseError(MyUnhandledError, "ClFila:Remove Method")
End Property






Public Property Get Count() As Long
    On Error GoTo CountGetErr


'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Count
    Count = Fila.Count
    Exit Property


CountGetErr:


    Call RaiseError(MyUnhandledError, "ClFila:Count Property Get")
End Property



Public Function Remove(Elem As Variant) As Boolean
    Dim ret As Boolean
    
    On Error GoTo RemoveErr


    If Count > 0 Then
        If IsObject(Fila.Item(1)) Then
            Set Elem = Fila.Item(1)
        Else
            Elem = Fila.Item(1)
            Fila.Remove (1)
        End If
        ret = True
    End If

    Remove = ret
    
    Exit Function

RemoveErr:


    Call RaiseError(MyUnhandledError, "ClFila:Remove Method")
End Function

#End If
Public Function Insere(Elem As Variant) As Boolean
    Dim ret As Boolean
    On Error GoTo InsereErr


    Fila.Add (Elem)
    ret = True


    Insere = ret
    Exit Function

InsereErr:


    Call RaiseError(MyUnhandledError, "ClFila:Insere Method")
End Function



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


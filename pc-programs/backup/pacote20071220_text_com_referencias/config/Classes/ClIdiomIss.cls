VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClIdiomIss"
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
Private mvarmes As String 'local copy
Private mvarSumario As ClToC 'local copy
Private mvarIdioma As String 'local copy
Private mvarChave As String 'local copy
Private mvarLegenda As ClLegenda  'local copy
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
Sub Limpa()
    mvarLegenda.Limpa
    mvarSumario.Limpa
    mvarmes = ""
End Sub
Function MontarRegistro() As String
    Dim ret As String
    
    ret = ret + Legenda.MontarRegistro
    ret = ret + Sumario.MontarRegistro
    
    MontarRegistro = ret
End Function

Public Property Set Legenda(ByVal vData As Object)
'used when assigning an Object to the property, on the left side of a Set statement.
'Syntax: Set x.Legenda = Form1
    Set mvarLegenda = vData
End Property

Public Property Get Legenda() As ClLegenda
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Legenda
    Set Legenda = mvarLegenda
End Property

Public Property Let Chave(ByVal vData As String)
    On Error GoTo ChaveLetErr


'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Chave = 5
    mvarChave = vData
    Exit Property


ChaveLetErr:


    Call RaiseError(MyUnhandledError, "ClIdiomIss:Chave Property Let")
End Property


Public Property Get Chave() As String
    On Error GoTo ChaveGetErr


'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Chave
    Chave = mvarChave
    Exit Property


ChaveGetErr:


    Call RaiseError(MyUnhandledError, "ClIdiomIss:Chave Property Get")
End Property



Public Property Let Idioma(ByVal vData As String)
    On Error GoTo IdiomaLetErr


'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Idioma = 5
    mvarIdioma = vData
    Exit Property


IdiomaLetErr:


    Call RaiseError(MyUnhandledError, "ClIdiomIss:Idioma Property Let")
End Property


Public Property Get Idioma() As String
    On Error GoTo IdiomaGetErr


'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Idioma
    Idioma = mvarIdioma
    Exit Property


IdiomaGetErr:


    Call RaiseError(MyUnhandledError, "ClIdiomIss:Idioma Property Get")
End Property



Public Property Set Sumario(ByVal vData As Object)
    On Error GoTo SumarioSetErr


'used when assigning an Object to the property, on the left side of a Set statement.
'Syntax: Set x.Sumario = Form1
    Set mvarSumario = vData
    Exit Property


SumarioSetErr:


    Call RaiseError(MyUnhandledError, "ClIdiomIss:Sumario Property Set")
End Property


Public Property Get Sumario() As ClToC
    On Error GoTo SumarioGetErr


'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Sumario
    Set Sumario = mvarSumario
    Exit Property


SumarioGetErr:


    Call RaiseError(MyUnhandledError, "ClIdiomIss:Sumario Property Get")
End Property
Public Property Let mes(ByVal vData As String)
    On Error GoTo MesLetErr


'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Mes = 5
    mvarmes = vData
    Exit Property


MesLetErr:


    Call RaiseError(MyUnhandledError, "ClIdiomIss:Mes Property Let")
End Property


Public Property Get mes() As String
    On Error GoTo MesGetErr


'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Mes
    mes = mvarmes
    Exit Property


MesGetErr:


    Call RaiseError(MyUnhandledError, "ClIdiomIss:Mes Property Get")
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


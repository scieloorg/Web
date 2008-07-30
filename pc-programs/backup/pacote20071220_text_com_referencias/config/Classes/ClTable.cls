VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClTable"
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

Private mvarColunas As Collection 'local copy


Public Property Get RowCounter() As Long
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.RowCounter
    RowCounter = Colunas(1).Counter
End Property

Public Property Let Elem(row As Long, col, ByVal vData As Variant)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Elem = 5

    Colunas(col).Linha(row) = vData

    
End Property


Public Property Get Elem(row As Long, col) As Variant
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Elem
    Elem = Colunas(col).Linha(row)
End Property

Public Property Set Colunas(ByVal vData As Object)
    On Error GoTo ColunasSetErr


'used when assigning an Object to the property, on the left side of a Set statement.
'Syntax: Set x.Colunas = Form1
    Set mvarColunas = vData
    Exit Property


ColunasSetErr:


    Call RaiseError(MyUnhandledError, "ClTable:Colunas Property Set")
End Property


Public Property Get Colunas() As Collection
    On Error GoTo ColunasGetErr


'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Colunas
    Set Colunas = mvarColunas
    Exit Property


ColunasGetErr:


    Call RaiseError(MyUnhandledError, "ClTable:Colunas Property Get")
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
'-----------------------------------------------------------------------
'Ler    - lê uma tabela/arquivo
'Path   - caminho do arquivo
'File   - nome do arquivo
'Name   - nome da tabela
'ColNames   - Nome das colunas, separados por vírgulas
'Separador  - cada elemento da linha deve ser separada por um caracter
'Retorno    - sucesso ou fracasso
'-----------------------------------------------------------------------
Public Function Ler(ByVal Path As String, ByVal file As String, ByVal Name As String, sep As String, ColNames As String) As Boolean
    Dim col() As String
    Dim QtdColNames As Long
    Dim ColName() As String
    Dim Linha As String
    Dim QtdLinhas As Long
    Dim i As Long
    Dim OK As Boolean
    Dim q As Long
    Dim fn As Long
    Dim Coluna As ClTabCol
    
   
    If FileExist(Path, file, Name) Then
        If Len(sep) = 1 Then
            QtdColNames = GetElemStr(ColNames, ",", ColName)
            If QtdColNames > 0 Then
                OK = True
                
                Set Colunas = New Collection
                For i = 1 To QtdColNames
                    Set Coluna = New ClTabCol
                    Coluna.Name = ColName(i)
                    Coluna.idx = i
                    Call Colunas.Add(Coluna, Coluna.Name)
                Next

                fn = FreeFile(1)
                Open Path + PathSep + file For Input As fn
                
                While Not EOF(fn) And OK
                    QtdLinhas = QtdLinhas + 1
                    Line Input #fn, Linha
                    q = GetElemStr(Linha, sep, col)

                    If QtdColNames = q Then
                        For i = 1 To q
                            'Set Coluna = New ClTabCol
                            Elem(QtdLinhas, i) = col(i)
                        Next
                    Else
                        OK = False
                    End If
                Wend
                Close fn
                If Not OK Then MsgBox Name + " erro de formato: Linha: " + QtdLinhas
            Else
                MsgBox Name + " erro nos nomes das colunas."
            End If
        Else
            MsgBox Name + "Invalid separator " + sep
        End If
    End If
    
    Ler = OK
End Function

'-----------------------------------------------------------------------
'Find    - Find um termo em uma determinada coluna
'Coluna     - nome ou índice da coluna
'Linhas     - índices das linhas em que foram encontrados os termos
'CmdType    - tipo de comparação
'Retorno    - quantidade de termos encontrados
'-----------------------------------------------------------------------
Function Find(Termo As String, Coluna, linhas() As Long, CmpType As VbCompareMethod) As Long
    On Error GoTo x
    Find = Colunas(Coluna).Find(Termo, linhas, CmpType)
x:
End Function

'-----------------------------------------------------------------------
'Criar  - cria uma tabela
'Name   - nome da tabela
'ColNames   - Nome das colunas, separados por vírgulas
'Separador  - cada elemento da linha deve ser separada por um caracter
'-----------------------------------------------------------------------
Public Function Criar(Name As String, ColNames As String) As Boolean
    Dim QtdColNames As Long
    Dim ColName() As String
    Dim i As Long
    Dim OK As Boolean
    Dim Coluna As ClTabCol
   
            QtdColNames = GetElemStr(ColNames, ",", ColName)
            If QtdColNames > 0 Then
                OK = True
                
                Set Colunas = New Collection
                For i = 1 To QtdColNames
                    Set Coluna = New ClTabCol
                    Coluna.Name = ColName(i)
                    Coluna.idx = i
                    Call Colunas.Add(Coluna, Coluna.Name)
                Next
            Else
                MsgBox Name + " erro nos nomes das colunas."
            End If
    
    Criar = OK
End Function
'-----------------------------------------------------------------------
'AddCol  - adiciona colunas a uma tabela
'Name   - nome da tabela
'ColNames   - Nome das colunas, separados por vírgulas
'Separador  - cada elemento da linha deve ser separada por um caracter
'-----------------------------------------------------------------------
Public Function AddCol(Name As String, ColNames As String) As Boolean
    Dim QtdColNames As Long
    Dim ColName() As String
    Dim i As Long
    Dim OK As Boolean
    Dim Coluna As ClTabCol
   
            QtdColNames = GetElemStr(ColNames, ",", ColName)
            If QtdColNames > 0 Then
                OK = True
                
                For i = 1 To QtdColNames
                    Set Coluna = New ClTabCol
                    Coluna.Name = ColName(i)
                    Coluna.idx = i
                    Call Colunas.Add(Coluna, Coluna.Name)
                Next
            Else
                MsgBox Name + " erro nos nomes das colunas."
            End If
    
    AddCol = OK
End Function



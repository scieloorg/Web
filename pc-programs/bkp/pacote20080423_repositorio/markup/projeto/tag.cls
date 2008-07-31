VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "tag"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

'Alberto Pedroso, Feb/98
'Tag

Private tSymbol As String
Private tName As String
Private tAttributes As String
'-----------------------------
Private mErr As New clsErrList
Const errIDObj As String = "222"

Property Let Symbol(NewSymbol As String)
 Const errIDMet As String = "01"
 '-----------------------------
 On Error GoTo ERRLOG
 
 tSymbol = NewSymbol
 Exit Property
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Property
Property Get Symbol() As String
 Const errIDMet As String = "02"
 '-----------------------------
 On Error GoTo ERRLOG
 
 Symbol = tSymbol
 Exit Property
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Property
Property Let Name(NewName As String)
 Const errIDMet As String = "03"
 '-----------------------------
 On Error GoTo ERRLOG
 
 tName = NewName
 Exit Property
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Property
Property Get Name() As String
 Const errIDMet As String = "04"
 '-----------------------------
 On Error GoTo ERRLOG
 
 Name = tName
 Exit Property
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Property
Property Let attributes(NewAttributes As String)
 Const errIDMet As String = "05"
 '-----------------------------
 On Error GoTo ERRLOG
 
 tAttributes = NewAttributes
 Exit Property
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Property
Property Get attributes() As String
 Const errIDMet As String = "06"
 '-----------------------------
 On Error GoTo ERRLOG
 
 attributes = tAttributes
 Exit Property
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Property

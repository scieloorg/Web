VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ResultsTableEntry"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

'Alberto Pedroso, Feb/98
'Results Table Entry

Private tElement As String
Private tSubElement As String
Private tStartPos As Long
Private tEndPos As Long
Private tLevel As Long
Private tTerminal As Boolean
Private tAbsSTAGStartPos As Long
Private tAbsSTAGEndPos As Long
Private tAbsETAGStartPos As Long
Private tAbsETAGEndPos As Long
'-----------------------------
Private mErr As New clsErrList
Const errIDObj As String = "221"

Property Let Element(NewElement As String)
 Const errIDMet As String = "01"
 '-----------------------------
 On Error GoTo ERRLOG
 
 tElement = NewElement
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
Property Get Element() As String
 Const errIDMet As String = "02"
 '-----------------------------
 On Error GoTo ERRLOG
 
 Element = tElement
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
Property Let SubElement(NewSubElement As String)
 Const errIDMet As String = "03"
 '-----------------------------
 On Error GoTo ERRLOG
 
 tSubElement = NewSubElement
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
Property Get SubElement() As String
 Const errIDMet As String = "04"
 '-----------------------------
 On Error GoTo ERRLOG
 
 SubElement = tSubElement
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
Property Let StartPos(NewStartPos As Long)
 Const errIDMet As String = "05"
 '-----------------------------
 On Error GoTo ERRLOG
 
 tStartPos = NewStartPos
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
Property Get StartPos() As Long
 Const errIDMet As String = "06"
 '-----------------------------
 On Error GoTo ERRLOG
 
 StartPos = tStartPos
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
Property Let EndPos(NewEndPos As Long)
 Const errIDMet As String = "07"
 '-----------------------------
 On Error GoTo ERRLOG
 
 tEndPos = NewEndPos
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
Property Get EndPos() As Long
 Const errIDMet As String = "08"
 '-----------------------------
 On Error GoTo ERRLOG
 
 EndPos = tEndPos
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
Property Let Level(NewLevel As Long)
 Const errIDMet As String = "09"
 '-----------------------------
 On Error GoTo ERRLOG
 
 tLevel = NewLevel
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
Property Get Level() As Long
 Const errIDMet As String = "10"
 '-----------------------------
 On Error GoTo ERRLOG
 
 Level = tLevel
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
Property Let Terminal(NewTerminal As Boolean)
 Const errIDMet As String = "11"
 '-----------------------------
 On Error GoTo ERRLOG
 
 tTerminal = NewTerminal
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
Property Get Terminal() As Boolean
 Const errIDMet As String = "12"
 '-----------------------------
 On Error GoTo ERRLOG
 
 Terminal = tTerminal
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
Property Let AbsSTAGStartPos(NewAbsSTAGStartPos As Long)
 Const errIDMet As String = "13"
 '-----------------------------
 On Error GoTo ERRLOG
 
 tAbsSTAGStartPos = NewAbsSTAGStartPos
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
Property Get AbsSTAGStartPos() As Long
 Const errIDMet As String = "14"
 '-----------------------------
 On Error GoTo ERRLOG
 
 AbsSTAGStartPos = tAbsSTAGStartPos
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
Property Let AbsSTAGEndPos(NewAbsSTAGEndPos As Long)
 Const errIDMet As String = "15"
 '-----------------------------
 On Error GoTo ERRLOG
 
 tAbsSTAGEndPos = NewAbsSTAGEndPos
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
Property Get AbsSTAGEndPos() As Long
 Const errIDMet As String = "16"
 '-----------------------------
 On Error GoTo ERRLOG
 
 AbsSTAGEndPos = tAbsSTAGEndPos
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
Property Let AbsETAGStartPos(NewAbsETAGStartPos As Long)
 Const errIDMet As String = "17"
 '-----------------------------
 On Error GoTo ERRLOG
 
 tAbsETAGStartPos = NewAbsETAGStartPos
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
Property Get AbsETAGStartPos() As Long
 Const errIDMet As String = "18"
 '-----------------------------
 On Error GoTo ERRLOG
 
 AbsETAGStartPos = tAbsETAGStartPos
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
Property Let AbsETAGEndPos(NewAbsETAGEndPos As Long)
 Const errIDMet As String = "19"
 '-----------------------------
 On Error GoTo ERRLOG
 
 tAbsETAGEndPos = NewAbsETAGEndPos
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
Property Get AbsETAGEndPos() As Long
 Const errIDMet As String = "20"
 '-----------------------------
 On Error GoTo ERRLOG
 
 AbsETAGEndPos = tAbsETAGEndPos
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

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
 On Error GoTo errLOG
 
 tElement = NewElement
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Get Element() As String
 Const errIDMet As String = "02"
 '-----------------------------
 On Error GoTo errLOG
 
 Element = tElement
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Let SubElement(NewSubElement As String)
 Const errIDMet As String = "03"
 '-----------------------------
 On Error GoTo errLOG
 
 tSubElement = NewSubElement
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Get SubElement() As String
 Const errIDMet As String = "04"
 '-----------------------------
 On Error GoTo errLOG
 
 SubElement = tSubElement
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Let StartPos(NewStartPos As Long)
 Const errIDMet As String = "05"
 '-----------------------------
 On Error GoTo errLOG
 
 tStartPos = NewStartPos
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Get StartPos() As Long
 Const errIDMet As String = "06"
 '-----------------------------
 On Error GoTo errLOG
 
 StartPos = tStartPos
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Let EndPos(NewEndPos As Long)
 Const errIDMet As String = "07"
 '-----------------------------
 On Error GoTo errLOG
 
 tEndPos = NewEndPos
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Get EndPos() As Long
 Const errIDMet As String = "08"
 '-----------------------------
 On Error GoTo errLOG
 
 EndPos = tEndPos
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Let Level(NewLevel As Long)
 Const errIDMet As String = "09"
 '-----------------------------
 On Error GoTo errLOG
 
 tLevel = NewLevel
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Get Level() As Long
 Const errIDMet As String = "10"
 '-----------------------------
 On Error GoTo errLOG
 
 Level = tLevel
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Let Terminal(NewTerminal As Boolean)
 Const errIDMet As String = "11"
 '-----------------------------
 On Error GoTo errLOG
 
 tTerminal = NewTerminal
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Get Terminal() As Boolean
 Const errIDMet As String = "12"
 '-----------------------------
 On Error GoTo errLOG
 
 Terminal = tTerminal
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Let AbsSTAGStartPos(NewAbsSTAGStartPos As Long)
 Const errIDMet As String = "13"
 '-----------------------------
 On Error GoTo errLOG
 
 tAbsSTAGStartPos = NewAbsSTAGStartPos
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Get AbsSTAGStartPos() As Long
 Const errIDMet As String = "14"
 '-----------------------------
 On Error GoTo errLOG
 
 AbsSTAGStartPos = tAbsSTAGStartPos
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Let AbsSTAGEndPos(NewAbsSTAGEndPos As Long)
 Const errIDMet As String = "15"
 '-----------------------------
 On Error GoTo errLOG
 
 tAbsSTAGEndPos = NewAbsSTAGEndPos
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Get AbsSTAGEndPos() As Long
 Const errIDMet As String = "16"
 '-----------------------------
 On Error GoTo errLOG
 
 AbsSTAGEndPos = tAbsSTAGEndPos
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Let AbsETAGStartPos(NewAbsETAGStartPos As Long)
 Const errIDMet As String = "17"
 '-----------------------------
 On Error GoTo errLOG
 
 tAbsETAGStartPos = NewAbsETAGStartPos
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Get AbsETAGStartPos() As Long
 Const errIDMet As String = "18"
 '-----------------------------
 On Error GoTo errLOG
 
 AbsETAGStartPos = tAbsETAGStartPos
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Let AbsETAGEndPos(NewAbsETAGEndPos As Long)
 Const errIDMet As String = "19"
 '-----------------------------
 On Error GoTo errLOG
 
 tAbsETAGEndPos = NewAbsETAGEndPos
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property
Property Get AbsETAGEndPos() As Long
 Const errIDMet As String = "20"
 '-----------------------------
 On Error GoTo errLOG
 
 AbsETAGEndPos = tAbsETAGEndPos
 Exit Property
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Property

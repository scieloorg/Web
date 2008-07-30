VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsRefIdentifWSCaller"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private mErr As New clsErrList
Const errIDObj As String = "510"

Public Function request(standard As String, references As String, Optional error As String) As String
    'Dim ws As clsws_IdentifyBiblRefElemsWS
    'Dim XML As String
    
    
    'Set ws = New clsws_IdentifyBiblRefElemsWS
    'XML = ws.wsm_getReferencesIdentified(references)
    
    'request = XML
    request = references
End Function




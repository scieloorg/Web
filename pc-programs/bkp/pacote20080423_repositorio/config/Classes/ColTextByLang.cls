VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ColTextByLang"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private colKey As New Collection
Private colIndex As New Collection
Sub add(textByLang As ClsTextByLang)
    Call colKey.add(textByLang, textByLang.lang)
    Call colIndex.add(textByLang, CStr(colIndex.count + 1))
End Sub

Function count() As Long
    count = colKey.count
End Function

Function getItemByLang(lang As String) As ClsTextByLang
    Set getItemByLang = colKey.item(lang)
End Function
Function getItemByIndex(i As Long) As ClsTextByLang
    Set getItemByIndex = colIndex.item(i)
End Function


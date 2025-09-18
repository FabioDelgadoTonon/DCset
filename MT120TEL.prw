#INCLUDE "PROTHEUS.CH"
#include "ap5mail.ch"
#include "rwmake.ch"
*-------------------------------------------*
User Function MT120TEL()
*-------------------------------------------*
	Local oNwDlg := ParamIxb[1]
	Local _aPosTela := ParamIxb[2]
	Public _cAprvLote := "2-Nao"//CriaVar("C7_XAPRVLT")  
    aSimNao := {"1-Sim","2-Nao"}

    IF SC7->(FIELDPOS("C7_XAPRVLT")) > 0
        IF !(INCLUI) 
            IF !Empty(SC7->C7_XAPRVLT)
                _cAprvLote:= aSimNao[Val(SC7->C7_XAPRVLT)] 
            Else
                _cAprvLote:= aSimNao[2] 
            EndIf   
        EndIf

        @ 062,_aPosTela[2,5]-15 SAY "Aprov.Lote/RH"   OF  oNwDlg PIXEL SIZE 035,009 
        @ 062, _aPosTela[2,6]-25 MSCOMBOBOX oCampos  VAR _cAprvLote  ITEMS aSimNao   SIZE 50,09 PIXEL OF oNwDlg // VALID AtuExpCmp(cCampos, oOperS, oExpCmp, aStruct)
    ENDIF
Return 

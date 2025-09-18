#Include "Protheus.ch"
#include "rwmake.ch"
#include "TOPCONN.CH"

User Function MT103FIM()

	Local _cHist := ALLTRIM(SF1->F1_ESPECIE)+' '+ALLTRIM (SF1->F1_DOC)+' '+SubStr(POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_NREDUZ"),1,15) +' PC:'+ALLTRIM(SD1->D1_PEDIDO)


	If Empty(_cHist)
		ALERT("Histórico não preenchido ! Por Favor preencher !")
	Else
		_CFLAG:= .T.
	EndIf

	If _CFLAG
		DbselectArea("SE2")
		DbSetOrder(6)
		Dbseek(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
		While !SE2->(EOF()) .AND.;
				SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM==SF1->F1_FILIAL+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC
			If RecLock("SE2",.F.)
				SE2->E2_HIST    := _cHist //Grava historico do contas a pagar
			    SE2->E2_BCOPAG  := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"SA2->A2_BANCO")
				SE2->E2_PEDIDO  := ALLTRIM(SD1->D1_PEDIDO)
      		MSUnlock()
			EndIf
			SE2->(DBSKIP())
		EndDo
	EndIf

Return()

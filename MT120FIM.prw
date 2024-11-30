#include "Protheus.ch"
#include "parmtype.ch"
//#include "CRDEF001.ch"

/*/{Protheus.doc} User Function MT120FIM
    PE após gravação do Pedido de Compra, envia e-mail para o primeiro aprovador.
    @type  Function
    @author Luis Gustavo 
    @since 15/08/2023

/*/

User Function MT120FIM()
	Local lRet 		:= .T.
	Local nOpcao 	:= PARAMIXB[1]
	Local cNumPC 	:= PARAMIXB[2]
	Local nOpcA     := PARAMIXB[3]
	Local cAssunto 	:= ""
	Local cMsgMail 	:= ""
	Local cTo		:= ""
	Local aArea     := GetArea()

	If nOpcA == 1 // INCLUSÃO
		SCR->(DbSelectArea("SCR"))
		SCR->(DbSetOrder(1)) // CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL
		If SCR->(DbSeek(xfilial("SCR")+'IP'+ca120Num)) 
			While SCR->CR_FILIAL == xFilial("SCR") .and. SCR->CR_TIPO == "IP"  .and. ALLTRIM(SCR->CR_NUM) == ca120num .and. SCR->CR_NIVEL == "1 "
				cAssunto := "Aprovação Pedido de Compra "+ALLTRIM(SCR->CR_FILIAL) + " - " + ALLTRIM(SCR->CR_NUM) + " pendente." 
				cMsgMail := U_MailAprPc( cFilial , cNumPc, .T. )
				cTo		 := UsrRetMail(SCR->CR_USER)
		//		U_SENDMAILX(cTo, cAssunto, cMsgMail)// Envia e-mail aprovador primeiro nivel
				SCR->(DbSkip())
			End
		Endif
	Endif

	RestArea(aArea)

Return lRet

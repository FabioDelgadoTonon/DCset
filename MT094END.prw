#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} User Function MT097END
    @Projeto: PE na aprovação do pedido de compra. Envia e-mail para aprovador ou fornecedor
    @type  Function
    @author Luis Gustavo 
    @since 15/08/2023
/*/

User Function MT094END()

	Local cNumPc	:= PARAMIXB[1] 
	Local cTipo 	:= PARAMIXB[2]
	Local nOpc		:= PARAMIXB[3]
	Local cFilial 	:= PARAMIXB[4]
	Local cNivelApr := ""
	Local cAssunto 	:= ""
	Local cMsgMail 	:= ""
	Local cTo		:= ""
	Local aAnexo	:= {}

	SCR->(DbSelectArea("SCR"))
	SCR->(DbSetOrder(2)) // CR_FILIAL+CR_TIPO+CR_NUM+CR_USER
	If SCR->(DbSeek(cFilial+cTipo+cNumPC+RetCodUsr())) 
		If SCR->CR_STATUS = '03' // LIBERADO
			SCR->(DbSetOrder(1)) // CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL
			cNivelApr := ALLTRIM(STR(VAL(SCR->CR_NIVEL)+1)) // PROXÍMO NIVEL 
			If SCR->(DbSeek(xfilial("SCR")+cTipo+cNumPC+ cNivelApr ))
				While SCR->CR_FILIAL == xFilial("SCR") 	 ;
						.and. SCR->CR_TIPO == cTipo 	 ;
						.and. SCR->CR_NUM == cNumPc 	 ;
						.and. ALLTRIM(SCR->CR_NIVEL) == cNivelApr	
					
					cAssunto := "Aprovação Pedido de Compra "+ALLTRIM(SCR->CR_FILIAL) + " - " + ALLTRIM(SCR->CR_NUM) + " pendente." 
					cMsgMail := U_MailAprPc( SCR->CR_FILIAL, SCR->CR_NUM , .T. )
					cTo		 := Alltrim(UsrRetMail(SCR->CR_USER))
					U_SENDMAILX(cTo, cAssunto, cMsgMail)
					SCR->(DbSkip())
				End
			Else
				cAssunto := "Pedido de Compras Aprovado Tomorrowland Brasil - PO: " + cNumPC 
				cMsgMail := U_MailAprPc( cFilial , cNumPc, .F. )
				If SC7->(DbSeek(cFilial+ALLTRIM(cNumPc)))
					cTo := ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_EMAIL"))
				Endif""
				cArquivo := U_GeraAnxPo( cFilial , cNumPc )
				aADD(aAnexo,cArquivo)
				U_SENDMAILX(cTo, cAssunto, cMsgMail , aAnexo, .F., .T.)
			Endif
		Endif
	Endif
Return




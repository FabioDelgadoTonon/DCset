#Include "Totvs.ch"

/*/{Protheus.doc} MATA180
Ponto de entrada no complemento de produtos
@since   01/01/2021
@author  Marcio Lopes dos Santos
@version 12.1.27
@type 	 Function
/*/
User Function MATA180

	Local aParam := PARAMIXB
	Local xRet   := .T.

	If aParam[2] == "MODELCOMMITNTTS"
		DbSelectArea("SB1")
		SB1->( DbSetOrder( 1 ) )
		If SB1->( DbSeek( xFilial( "SB1" ) + SB5->B5_COD) )
			RecLock( "SB1", .F. )
			if FieldPos("B1_XEXPPI") > 0
				SB1->B1_XEXPPI := ""
			endif
			if FieldPos("B1_MSEXP") > 0
				SB1->B1_MSEXP := ""
			endif
			SB1->( MsUnlock() )
		EndIf
	EndIf

Return xRet

#Include "Totvs.ch"

/*/{Protheus.doc} MT180GRV
Ponto de entrada no final da gravacao complemento de produtos
Seta tabela SB1 para ser exportada (B1_XEXPPI/B1_MSEXP)
@since   01/01/2021
@author  Marcio Lopes dos Santos
@version 12.1.27
@type 	 Function
/*/
User Function MT180GRV()
	Local aAreaAT	:= GetArea()
	Local aAreaB1	:= SB1->( GetArea() )
	Local cProduto	:= SB5->B5_COD
	// Local ExpN1		:= PARAMIXB[1]

	If SB1->( DbSeek( xFilial("SB1") + cProduto ) )
		RecLock( "SB1", .F. )
		if FieldPos("B1_XEXPPI") > 0
			SB1->B1_XEXPPI := ""
		endif
		if FieldPos("B1_MSEXP") > 0
			SB1->B1_MSEXP := ""
		endif
		MsUnlock()
	EndIf

	RestArea( aAreaB1 )
	RestArea( aAreaAT )

Return Nil

#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} FI040ROT
Ponto de Entrada do Contas a Receber - Inserção de Botões no Menu
@type user function
@author Andre Froes - Fabritech
@since 23/02/2024
/*/
User Function FI040ROT()
	Local aRotRet := AClone(PARAMIXB)

	aAdd( aRotRet,{"Imp. Nota de Débito", "u_FBNTDB01()", 0, 7})
	aAdd( aRotRet,{"Imp. Nota de Crédito", "u_FBNTCR01()", 0, 7})

Return aRotRet

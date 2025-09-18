#INCLUDE 'TBICONN.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} MT120FIX
	Descrição: Ponto de entrada para fixar colunas no Browse da SC7
@param 
@author: Flavio (BRB)
@since: 27/07/2023 
@version: P12
@return: 
@type: User function
/*/
User Function MT120FIX()
    Local aRet := PARAMIXB

    If cEmpAnt <> '02'

    AADD(aRet, {"Nome Fornec.","C7_XNMFORN"})

    Endif
Return(aRet)

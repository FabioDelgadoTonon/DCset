/*/{Protheus.doc} F040BLQ 
Ponto de Entrada é utilizado para, em determinadas situações, bloquear a utilização das rotinas de inclusão, 
exclusão, alteração e substituição de titulos a receber. 
Programa Fonte
@type user function
@author Afonso/Fabritech
@since 05/2024
/*/
User Function F040BLQ()
		
	Local lxRet := .T.

	If IsInCallStack("HTTPCALLWSRESTFUL") .OR. IsInCallStack("U_TSTRETAPI")
		 lxRet := .F.
	Endif  

Return( lxRet )

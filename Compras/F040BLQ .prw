/*/{Protheus.doc} F040BLQ 
Ponto de Entrada � utilizado para, em determinadas situa��es, bloquear a utiliza��o das rotinas de inclus�o, 
exclus�o, altera��o e substitui��o de titulos a receber. 
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

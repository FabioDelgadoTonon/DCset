#include "rwmake.ch" 
#Include "TopConn.Ch"

User Function MT120FIL()

Local cQuery  := ""
Local cFiltro := "" //"C7_USER == __cUserID "
Local cString := "" 

	If Select("FILTRO") > 0
		FILTRO->(DbCloseArea())
	EndIf	
	   
	cQuery := " SELECT Z99_CC FROM " + Retsqlname("Z98") + " Z98 "
    cQuery += " INNER JOIN " + Retsqlname("Z99") + " Z99 "
    cQuery += " ON Z99_ID = Z98_ID "
    cQuery += " AND Z99.D_E_L_E_T_ <> '*' "
	cQuery += " AND Z99_FILIAL = '" + xFilial("Z99")+ "'"
    cQuery += " WHERE Z98.D_E_L_E_T_ <> '*' "
    cQuery += " AND Z98_USER = '" + Alltrim(__cUserID) + "'"
	cQuery += " AND Z98_FILIAL = '" + xFilial("Z98")+ "'"

		
	TCQUERY cQuery NEW ALIAS "FILTRO"

	FILTRO->(Dbgotop())
	
	While FILTRO->(!Eof())
	    cString += (FILTRO->Z99_CC) + "|"		
		FILTRO->(Dbskip())
	End                
			
	If !Empty(cString)
		//cFiltro += " .Or. " + "C7_CC $ '" + cString + "'"
		cFiltro += "C7_CC $ '" + cString + "'"
	EndIf
	
Return cFiltro         

#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SIV009  ºFD						     º Data ³  11/11/25   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION SIV009()

DBSELECTAREA("SA1")
DBSETORDER(1)
DO WHILE !SA1->(EOF())
	DbSelectarea("CTD")
	CTD->(DbSetOrder(1)) // CTD_FILIAL + CTD_ITEM
	If CTD->(!DbSeek(xFilial("CTD") + ALLTRIM(SA1->A1_COD)  ))
		RecLock("CTD",.T.)
			CTD->CTD_FILIAL := xFilial("CTD")                                                                            
			CTD->CTD_ITEM := ALLTRIM(SA1->A1_COD) 
			CTD->CTD_CLASSE := "2"
			CTD->CTD_DESC01 := ALLTRIM(SA1->A1_NREDUZ)
			CTD->CTD_DTEXIS := CTOD("01/01/1980")
			CTD->CTD_BLOQ 	:= "2"
		CTD->(MsUnlock())
	EndIf         
	
	SA1->(DBSKIP())
ENDDO

DBSELECTAREA("SA2")
DBSETORDER(1)
DO WHILE !SA2->(EOF())
	DbSelectarea("CTD")
	CTD->(DbSetOrder(1)) // CTD_FILIAL + CTD_ITEM
	If CTD->(!DbSeek(xFilial("CTD") + ALLTRIM(SA2->A2_COD) ))
		RecLock("CTD",.T.)
			CTD->CTD_FILIAL := xFilial("CTD")
			CTD->CTD_ITEM 	:= ALLTRIM(SA2->A2_COD)  
			CTD->CTD_CLASSE := "2"                                                    
			CTD->CTD_DESC01 := ALLTRIM(SA2->A2_NREDUZ)		
			CTD->CTD_DTEXIS := CTOD("01/01/1980")
			CTD->CTD_BLOQ 	:= "2" 
		CTD->(MsUnlock())
	EndIf
	
	SA2->(DBSKIP())
ENDDO                  

MSGALERT("FIM DE PROCESSAMENTO")

RETURN

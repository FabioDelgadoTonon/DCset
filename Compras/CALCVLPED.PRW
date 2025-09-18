#include "rwmake.ch" 
#Include "TopConn.Ch"

User Function CALCVLPED(cNota,cSerie,cFonece,cLoja)

Local nValor := 0
Local cQuery := ""

    If Select("CALCPED") > 0
		CALCPED->(DbCloseArea())
	EndIf	

    cQuery := " SELECT DISTINCT D1_PEDIDO FROM " + Retsqlname("SD1")
    cQuery += " WHERE D_E_L_E_T_ <> '*' "
    cQuery += " AND D1_DOC = '" + cNota + "'"
    cQuery += " AND D1_SERIE = '" + cSerie + "'"
    cQuery += " AND D1_FORNECE = '" + cFonece + "'"
    cQuery += " AND D1_LOJA = '" + cLoja + "'"
    cQuery += " AND D1_FILIAL = '" + XFILIAL("SD1") + "'"

    TCQUERY cQuery NEW ALIAS "CALCPED"

    CALCPED->(Dbgotop())

    Dbselectarea("SC7")
    SC7->(Dbsetorder(1))

    While CALCPED->(!Eof())

        If SC7->(Dbseek(xFilial("SC7")+CALCPED->D1_PEDIDO))
            While SC7->(!EOf()) .And. SC7->C7_NUM == CALCPED->D1_PEDIDO

                nValor += SC7->C7_TOTAL 

                SC7->(Dbskip())
            End
        EndIf

        CALCPED->(Dbskip())
    End

Return nValor

#Include "Protheus.ch"

*------------------------------------*
User Function MT103FIM()
*------------------------------------*
Local nOpcNF   		:= PARAMIXB[1]    
//Local cChvPesq 		:= SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
Local aAreaD1  		:= SD1->(GetArea())
Local nConfirma 	:= PARAMIXB[2]

If SF1->F1_TIPO == 'N' .And. nOpcNF == 3 .And. nConfirma == 1 
    
    // Ponto de chamada Para gerar as alçadas
    U_xGerAprovSCR()
ENDIF

// IF nOpcNF == 5 .And. nConfirma == 1 
   
//     SE2->(dbSetOrder(6))
//     IF SE2->(dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC))
//         _cDelete := "UPDATE FROM "+RetSqlName("SCR")+" SET D_E_L_E_T_='*',R_E_C_D_E_L_=R_E_C_N_O_  WHERE CR_FILIAL='"+xFilial('SCR')+"' AND CR_NUM='"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA+"'"
//         TcSqlExec(_cDelete)
//         EECVIEW(_cDelete)
//     ENDIF
// ENDIF

RestArea(aAreaD1)

Return Nil

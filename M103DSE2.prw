#INCLUDE "RWMAKE.CH"
*-------------------------------------------------*
User Function M103DSE2()
*-------------------------------------------------*
Local lOk := .T.

_cDelete := "UPDATE  "+RetSqlName("SCR")+" SET D_E_L_E_T_='*',R_E_C_D_E_L_=R_E_C_N_O_  WHERE CR_FILIAL='"+xFilial('SCR')+"' AND CR_NUM='"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA+"'"
TcSqlExec(_cDelete)


Return(lOk)

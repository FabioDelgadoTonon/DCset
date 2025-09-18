
#include "rwmake.ch"        

User Function M020ALT()    

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � M020ALT  � Autor � Fabio Delgado � Data � 02.07.2024       ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada para altera��o de Fornecedores e atualizar���
���          � dados banc�rios                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico DC Set                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Local aArea         := GetArea()
Local aAreaA2       := SA2->(GetArea())

			//Query para busca dos dados
		If Altera .and. !Empty(SA2->A2_BANCO)

			cQuery := " UPDATE "+RetSQLName("SE2")+" "
			cQuery += " SET E2_FORBCO = '"+SA2->A2_BANCO+"', E2_FORAGE = '"+SA2->A2_AGENCIA+"', E2_FORCTA = '"+SA2->A2_NUMCON+"'   "
			cQuery += " WHERE E2_FORNECE = '"+SA2->A2_COD+"' "
			cQuery += " AND D_E_L_E_T_ = ' ' AND E2_SALDO >0 and E2_LOJA = '"+SA2->A2_LOJA+"'  "
			TcSqlExec(cQuery)
	
      EndIf


	RestArea(aAreaA2)
Return( aArea )



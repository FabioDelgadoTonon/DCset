#INCLUDE "TOTVS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} BLQDC1
Rotina para efetuar as analises de Bloqueio das contas orçamentarias
@author  Leandro Duarte
@since   05/06/2023
@version 1.0
/*/
//-------------------------------------------------------------------
User Function BLQDC1()
	Local lRet          := .T.
	Local aTotal        := {}
	Local aTotCC       := {}
	Local cTRBs         := "TRBWS"
	Local cConfig		:= AKJ->AKJ_CONFIG
	Local cMesAno1 		:= SUBSTR(DTOS(AKD->AKD_DATA),1,4)+'0101'
	Local cMesAno2 		:= SUBSTR(DTOS(AKD->AKD_DATA),1,4)+'1231'
	Local nPorc 		:= AKJ->AKJ_PRCMRG
	Local nFor 			:= 0
	Local nPosCC		:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C7_CC"})
	Local nPosCO		:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C7_XCO"})
	Local nPosTT		:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C7_TOTAL"})
	Local cMsg			:= ""

	For nFor := 1 to len(aCols)
		IF !ACOLS[nFor][len(aHeader)+1]
			nPos := ascan(aTotal,{|x| x[1] == aCols[nFor][nPosCC] .AND. x[2] == aCols[nFor][nPosCO] })
			if nPos == 0
				aadd(aTotal,{aCols[nFor][nPosCC], aCols[nFor][nPosCO], aCols[nFor][nPosTT] })
			else
				aTotal[nPos][3] += aCols[nFor][nPosTT]
			endif
			nPos := ascan(aTotCC,{|x| x[1] == aCols[nFor][nPosCC] })
			if nPos == 0
				aadd(aTotCC,{aCols[nFor][nPosCC], aCols[nFor][nPosTT] })
			else
				aTotCC[nPos][2] += aCols[nFor][nPosTT]
			endif
		ENDIF
	Next nFor

	dbselectarea("AKD")// ITENS/MOVIMENTO
	dbselectarea("AKT")//CABEÇALHO
	For nFor := 1 to len(aTotal)
		BEGINSQL ALIAS cTRBs
			select
				((CRD * %EXP:nPorc%) / 100) + CRD AS CRED1,
				CRD AS CRED2,
				((DEB * %EXP:nPorc%) / 100) + DEB AS DEB1
			FROM
				(
					SELECT
						sum(AKT_MVDEB1) as DEB,
						sum(AKT_MVCRD1) AS CRD
					FROM
						%TABLE:AKT% A
					WHERE
						A.AKT_FILIAL = %EXP:FWXFILIAL("AKT")%
						AND A.%NOTDEL%
						AND A.AKT_CONFIG = %EXP:cConfig%
						AND A.AKT_NIV01 = %EXP:aTotal[nFor][1]%
						AND A.AKT_NIV02 = %EXP:aTotal[nFor][2]%
						AND A.AKT_DATA between %EXP:cMesAno1% AND %EXP:cMesAno2%
						AND A.AKT_TPSALD = 'FC' 
				) TT
		ENDSQL
		while (cTRBs)->(!eof())
			
			//(cTRBs)->CRED1-(cTRBs)->DEB1 < +aTotal[nFor][3] - produção
			if  (cTRBs)->CRED1-(cTRBs)->DEB1 == 900000000
				lRet := .F.
				cMsg += "O valor Informado para o Centro de Custo: "+alltrim(aTotal[nFor][1])+" na conta Orçamentaria: "+alltrim(aTotal[nFor][2])+" Ultrapassou os "+cvaltochar(nPorc)+"% BUDGET: "+ALLTRIM(transform((cTRBs)->CRED2,"@E 999,999,999,999,999.99"))+" BUDGET "+cvaltochar(nPorc)+"%: "+ALLTRIM(transform((cTRBs)->CRED1,"@E 999,999,999,999,999.99"))+" REALIZADO: "+transform((cTRBs)->DEB1,"@E 999,999,999,999,999.99")+CRLF
			endif
			(cTRBs)->(dbskip())
		end
		(cTRBs)->(dbclosearea())
	Next nFor
	For nFor := 1 to len(aTotCC)
		BEGINSQL ALIAS cTRBs
			SELECT
				(
					SELECT
						//sum(AKD_VALOR1)
						SUM(AKD_VALOR1* 5)/100 + SUM(AKD_VALOR1) AS BUDGET
						 
					FROM
						%TABLE:AKD% A
					WHERE
						A.AKD_FILIAL = %EXP:FWXFILIAL("AKD")%
						AND A.%NOTDEL%
						AND A.AKD_TPSALD = 'FC'
						AND A.AKD_CC = %EXP:aCols[nFor][nPosCC]%
						AND A.AKD_CO = %EXP:aCols[nFor][nPosCO]%
						AND A.AKD_DATA between %EXP:cMesAno1% AND %EXP:cMesAno2%
				) as T1,
				(
					SELECT
						sum(AKD_VALOR1)
					FROM
						%TABLE:AKD% A
					WHERE
						A.AKD_FILIAL = %EXP:FWXFILIAL("AKD")%
						AND A.%NOTDEL%
						//AND A.AKD_TPSALD = 'RE'
						AND A.AKD_TPSALD = 'PR' AND A.AKD_TIPO <> '2'
						AND A.AKD_CC = %EXP:aCols[nFor][nPosCC]%
						AND A.AKD_CO = %EXP:aCols[nFor][nPosCO]%
						AND A.AKD_DATA between %EXP:cMesAno1% AND %EXP:cMesAno2% 
				) as t2,
				(
					SELECT
						//sum(AKD_VALOR1)
						sum(AKD_VALOR1*%EXP:nPorc%)/100 + SUM(AKD_VALOR1)
					FROM
						%TABLE:AKD% A
					WHERE
						A.AKD_FILIAL = %EXP:FWXFILIAL("AKD")%
						AND A.%NOTDEL%
						AND A.AKD_TPSALD = 'FC'
						AND A.AKD_CC = %EXP:aCols[nFor][nPosCC]%
						AND A.AKD_CO = %EXP:aCols[nFor][nPosCO]%
						AND A.AKD_DATA between %EXP:cMesAno1% AND %EXP:cMesAno2%
				) - (
					SELECT
						sum(AKD_VALOR1)
					FROM
						%TABLE:AKD% A
					WHERE
						A.AKD_FILIAL = %EXP:FWXFILIAL("AKD")%
						AND A.%NOTDEL%
						//AND A.AKD_TPSALD = 'RE'
						AND A.AKD_TPSALD = 'PR' AND A.AKD_TIPO <> '2'
						AND A.AKD_CC = %EXP:aCols[nFor][nPosCC]%
						AND A.AKD_CO = %EXP:aCols[nFor][nPosCO]%
						AND A.AKD_DATA between %EXP:cMesAno1% AND %EXP:cMesAno2%
				) AS FALTA
				from %TABLE:SA2% B
			 WHERE B.A2_FILIAL = %EXP:FWXFILIAL("SA2")%
			   AND B.%NOTDEL%
			   AND B.A2_COD = %EXP:CFORANTAUT%
		ENDSQL
		while (cTRBs)->(!eof())
			 //(cTRBs)->T1 < (cTRBs)->T2 Produção
			if	 (cTRBs)->T1 == 9000000000
				lRet := .F.
				cMsg += "O valor Informado para o Centro de Custo: "+alltrim(aTotCC[nFor][1])+" Ultrapassou Limite do BUDGET: "+ALLTRIM(transform((cTRBs)->T1,"@E 999,999,999,999,999.99"))+" Saldo Realizado: "+transform((cTRBs)->T2,"@E 999,999,999,999,999.99")+" Falta: "+transform((cTRBs)->FALTA,"@E 999,999,999,999,999.99")+CRLF
			endif
			(cTRBs)->(dbskip())
		end
		(cTRBs)->(dbclosearea())
	Next nFor
	IF !lRet
		AVISO("Limite atingido",cMsg,{"Ok"},3)
	ENDIF
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} BLQDC2
Rotina para efetuar as analises de Bloqueio das contas orçamentarias
@author  Leandro Duarte
@since   05/06/2023
@version 1.0
/*/
//-------------------------------------------------------------------
User Function BLQDC2()
	alert('3')
	alert('4')
Return .t.

#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RELSB9   � Autor � Fabio Delgado	     � Data �  21/05/25   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio CT2							     	          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RELCT2()
	Local oReport 	:= ReportDef()

	oReport:PrintDialog()

Return

//������������������������������������������������������������������Ŀ
//� Function ReportDef                                               �
//��������������������������������������������������������������������
Static Function ReportDef()
	Local oTitulos	:= Nil
	Local cDescr	:= "Este programa ir� imprimir o Relatorio da CT2"
	Local cTitulo	:= "Relatorio CT2"
	Local cPerg		:= "RELCT21"
	Local cAliasRep	:= GetNextAlias()

	//Ajusta as Perguntas
	CriaPerg(@cPerg)
	Pergunte(cPerg,.F.)

	oReport := TReport():New(cPerg,cTitulo,cPerg,{|oReport| ReportPrint(oReport,@cAliasRep)},cDescr)
	oReport:SetLandscape()

	oReport:HideParamPage()

	//��������������������������������������������������������������Ŀ
	//�Criacao da celulas da secao do relatorio                      �
	//�                                                              �
	//�TRCell():New                                                  �
	//�ExpO1 : Objeto TSection que a secao pertence                  �
	//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado    �
	//�ExpC3 : Nome da tabela de referencia da celula                �
	//�ExpC4 : Titulo da celula                                      �
	//�        Default : X3Titulo()                                  �
	//�ExpC5 : Picture                                               �
	//�        Default : X3_PICTURE                                  �
	//�ExpC6 : Tamanho                                               �
	//�        Default : X3_TAMANHO                                  �
	//�ExpL7 : Informe se o tamanho esta em pixel                    �
	//�        Default : False                                       �
	//�ExpB8 : Bloco de c�digo para impressao.                       �
	//�        Default : ExpC2                                       �
	//�                                                              �
	//����������������������������������������������������������������

	//��������������������������������������������������������������Ŀ
	//� Sessao 1 (oTitulos)                                          �
	//����������������������������������������������������������������
	oTitulos := TRSection():New(oReport,"Relatorio CT2",{(cAliasRep)},,/*Campos do SX3*/,/*Campos do SIX*/)
	oTitulos:SetTotalInLine(.F.)


	TRCell():New(oTitulos,"Usuario_ALTERACAO"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"CT2_DEBITO"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"CT1DEB.CT1_DESC01"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"NIVEL_2"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"NIVEL_3"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"NIVEL_4"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"GR1"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"GR2"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"GR3"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"TIPO_LANCAMENT"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"CT2_DATA"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"LOTE_SUB_DOC_LINHA"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"CT2_HIST"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"CT2_CREDIT"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"CT2_FILIAL"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"CT2_CCC"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"CT2_CCD"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"CT2_ITEMC"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"CT2_ITEMD"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"A2_NOME"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"CTT_DESC01"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"CT2_CLVLCR"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"CT2_CLVLDB"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"CT2_VALOR"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"CT2_ORIGEM"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oTitulos,"CT2_MANUAL"	,cAliasRep	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)




	oTitulos:SetHeaderPage()

Return oReport

//������������������������������������������������������������������Ŀ
//� Function ReportPrint                                             �
//��������������������������������������������������������������������
Static Function ReportPrint(oReport, cAliasRep)
	Local oSection1		:= oReport:Section(1)
	Local cTipos		:= ""
	Local cOrder		:= "CT2_DATA"
	Local lSelTipo		:= .F.
	Local aTipos		:= {}
	Local nX			:= 0
	Local oBreak		:= Nil

	%noparser%
	BeginSQL Alias cAliasRep
		Column CT2_DATA 	As Date



		SELECT 
		USR_CODIGO AS Usuario_ALTERACAO, CT2_DEBITO, CT1DEB.CT1_DESC01, SUBSTRING(CT2_DEBITO,1,2) NIVEL_2, SUBSTRING(CT2_DEBITO,1,4) NIVEL_3, 
		SUBSTRING(CT2_DEBITO,1,5) NIVEL_4,
		CT1.CT1_DESC01 GR1,CT12.CT1_DESC01 GR2,CT13.CT1_DESC01 GR3, 
		CASE WHEN CT1DEB.CT1_NATCTA = '01' THEN 'CONTA DE ATIVO' 
		WHEN CT1DEB.CT1_NATCTA = '02' THEN 'CONTA DE PASSIVO' 
		WHEN CT1DEB.CT1_NATCTA = '03' THEN 'PATRIMONIO LIQUIDO' 
		WHEN CT1DEB.CT1_NATCTA = '04' THEN 'CONTA DE RESULTADO' 
		WHEN CT1DEB.CT1_NATCTA = '05' THEN 'CONTA DE COMPENSA��O' 
		WHEN CT1DEB.CT1_NATCTA = '09' THEN 'OUTRAS' 
		ELSE '' END TIPO_LANCAMENT, SUBSTRING(CT2_DATA, 7, 3) + '/' + SUBSTRING(CT2_DATA, 5, 2) + '/' + LEFT(CT2_DATA, 4) AS CT2_DATA, CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA LOTE_SUB_DOC_LINHA, 
		CT2_HIST, CT2_CREDIT, CT2_FILIAL,
		CT2_CCC, CT2_CCD,  CT2_ITEMC, CT2_ITEMD,   (SELECT ISNULL(MAX(A2_NOME), '')  FROM  %Table:SA2%  (NOLOCK)    A2
		WHERE CT2_ITEMC = A2_COD AND A2.%NotDel% ) AS A2_NOME, CTT_DESC01, CT2_CLVLCR, CT2_CLVLDB,
		CT2_VALOR, CT2_ORIGEM, CT2_MANUAL

		FROM   %Table:CT2%  (NOLOCK) 				
				
		LEFT JOIN %Table:CT1%  (NOLOCK) CT1DEB ON CT1_CONTA = CT2_DEBITO AND CT1DEB.%NotDel%
		LEFT JOIN %Table:CT1%  (NOLOCK) CT1 ON SUBSTRING(CT2_DEBITO,1,2) = CT1.CT1_CONTA AND CT1.CT1_FILIAL = CT2_FILIAL
		LEFT JOIN %Table:CT1%  (NOLOCK) CT12 ON SUBSTRING(CT2_DEBITO,1,4) = CT12.CT1_CONTA AND CT12.CT1_FILIAL = CT2_FILIAL
		LEFT JOIN %Table:CT1%  (NOLOCK) CT13 ON SUBSTRING(CT2_DEBITO,1,5) = CT13.CT1_CONTA AND CT13.CT1_FILIAL = CT2_FILIAL
		LEFT JOIN %Table:CTT%  (NOLOCK) CTT ON CTT_CUSTO = CT2_CCC AND CTT.%NotDel% AND CTT_FILIAL = CT2_FILIAL
		LEFT JOIN SYS_USR ON USR_ID =  SUBSTRING(
		SUBSTRING(CT2_USERGA, 3, 1)+SUBSTRING(CT2_USERGA, 7, 1)+
		SUBSTRING(CT2_USERGA, 11,1)+SUBSTRING(CT2_USERGA, 15,1)+
		SUBSTRING(CT2_USERGA, 2, 1)+SUBSTRING(CT2_USERGA, 6, 1)+
		SUBSTRING(CT2_USERGA, 10,1)+SUBSTRING(CT2_USERGA, 14,1)+
		SUBSTRING(CT2_USERGA, 1, 1)+SUBSTRING(CT2_USERGA, 5, 1)+
		SUBSTRING(CT2_USERGA, 9, 1)+SUBSTRING(CT2_USERGA, 13,1)+
		SUBSTRING(CT2_USERGA, 17,1)+SUBSTRING(CT2_USERGA, 4, 1)+
		SUBSTRING(CT2_USERGA, 8, 1),3,8)
					
		WHERE  CT2_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND CT2_DATA BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%  
		AND CT2DC0.%NotDel%
		ORDER BY 1 DESC

		EndSQL







	oReport:Section(1):EndQuery()


	//�����������������������Ŀ
	//�Impressao do Relatorio �
	//�������������������������
	oSection1:Print()





Return Nil


//������������������������������������������������������������������Ŀ
//� Function CriaPerg (Cria Perguntas no SX1)                        �
//��������������������������������������������������������������������
Static Function CriaPerg(cPerg)

	Local nX	:= 0
	Local aPerg	:= {}
	Local lLock	:= .F.
	Local cPerg	:= PadR(cPerg,10)

	DbSelectArea("SX1")
	DbSetOrder(1)

	Aadd( aPerg, {"Filial De: "			, "C", 04, 00, "G", ""				, ""				, "", "", "", "SM0"	} )
	Aadd( aPerg, {"Filial Ate: "		, "C", 04, 00, "G", ""				, ""				, "", "", "", "SM0"	} )
	Aadd( aPerg, {"Data De: "			, "D", 08, 00, "G", ""				, ""				, ""			, ""		, "", ""	} )
	Aadd( aPerg, {"Data Ate: "			, "D", 08, 00, "G", ""				, ""				, ""			, ""		, "", ""	} )


	For nX := 1 To Len(aPerg)

		lLock := !SX1->(Dbseek(cPerg + StrZero(nX, 2)))

		Reclock("SX1", lLock)
		SX1->X1_GRUPO 		:= cPerg
		SX1->X1_ORDEM		:= StrZero(nX, 2)
		SX1->X1_VARIAVL		:= "mv_ch" + Chr( nX + 96 )
		SX1->X1_VAR01		:= "mv_par" + StrZero(nX,2)
		SX1->X1_PRESEL		:= 1
		SX1->X1_PERGUNT		:= aPerg[ nX , 01 ]
		SX1->X1_TIPO 		:= aPerg[ nX , 02 ]
		SX1->X1_TAMANHO		:= aPerg[ nX , 03 ]
		SX1->X1_DECIMAL		:= aPerg[ nX , 04 ]
		SX1->X1_GSC  		:= aPerg[ nX , 05 ]
		SX1->X1_DEF01		:= aPerg[ nX , 06 ]
		SX1->X1_DEF02		:= aPerg[ nX , 07 ]
		SX1->X1_DEF03		:= aPerg[ nX , 08 ]
		SX1->X1_DEF04		:= aPerg[ nX , 09 ]
		SX1->X1_DEF05		:= aPerg[ nX , 10 ]
		SX1->X1_F3   		:= aPerg[ nX , 11 ]
		MsUnlock()
	Next nX

Return Nil

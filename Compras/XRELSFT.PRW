#include "protheus.ch"

/*/{Protheus.doc} RRELSFT
Relatorio de Movimentos Fiscais - SFT
@type       Function
@author     Fabio Delgado
@since      03/2024
@version    1.0
/*/
User Function XRELSFT()
	Local oReport

	CriaPerg("RRELSFT")

	IF Pergunte( "RRELSFT", .T. )

		oReport := ReportDef()
		oReport:SetParam("RRELSFT")
		oReport:PrintDialog()

	EndIf

Return Nil

/*/{Protheus.doc} ReportDef
Definicoes do relatorio
@type       Function
@author     Fabio Delgado
@since      03/2024
@version    1.0
/*/
Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak

	oReport := TReport():New("RRELSFT","Movimentos Fiscal","RRELSFT",{|oReport| PrintReport(oReport)},"Movimentos Fiscal")
	oSection := TRSection():New(oReport,"Movimentos Fiscal",{"SFT","SB1","SA1"})

	TRCell():New(oSection,"FT_FILIAL"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"M0_FILIAL"		,"SM0"	,"Desr. Filial"			,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"M0_NOMECOM"		,"SM0"	,"Empresa"				,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_TIPO"			,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_ENTRADA"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_EMISSAO"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_ESPECIE"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_NFISCAL"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_SERIE"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_CLIEFOR"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_LOJA"			,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )

	If MV_PAR03 == 1
		TRCell():New(oSection,"A2_NOME"			,"SA2"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
		TRCell():New(oSection,"A2_CGC"			,"SA2"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
	Else
		TRCell():New(oSection,"A1_NOME"			,"SA1"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
		TRCell():New(oSection,"A1_CGC"			,"SA1"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
	ENDIF

	TRCell():New(oSection,"FT_ESTADO"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )

	If MV_PAR04 == 1
		TRCell():New(oSection,"FT_TES"			,"SFT"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
	EndIf

	TRCell():New(oSection,"FT_CFOP"			,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )

	If MV_PAR04 == 1
		TRCell():New(oSection,"FT_ESTOQUE"		,"SFT"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
		TRCell():New(oSection,"FT_PRODUTO"		,"SFT"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
		TRCell():New(oSection,"B1_DESC"			,"SB1"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
		TRCell():New(oSection,"FT_QUANT"		,"SFT"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
		TRCell():New(oSection,"FT_PRCUNIT"		,"SFT"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
		TRCell():New(oSection,"FT_DESCONT"		,"SFT"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
	EndIf

	TRCell():New(oSection,"FT_TOTAL"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )

	If MV_PAR04 == 1
		TRCell():New(oSection,"FT_FRETE"		,"SFT"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
		TRCell():New(oSection,"FT_SEGURO"		,"SFT"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
		TRCell():New(oSection,"FT_DESPESA"		,"SFT"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
	EndIf

	TRCell():New(oSection,"FT_VALCONT"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_BASEPIS"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )

	If MV_PAR04 == 1
		TRCell():New(oSection,"FT_ALIQPIS"		,"SFT"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
	EndIf

	TRCell():New(oSection,"FT_VALPIS"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_BASECOF"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )

	If MV_PAR04 == 1
		TRCell():New(oSection,"FT_ALIQCOF"		,"SFT"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
	EndIf

	TRCell():New(oSection,"FT_VALCOF"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_BASEICM"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )

	//If MV_PAR04 == 1
		TRCell():New(oSection,"FT_ALIQICM"		,"SFT"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
	//EndIf

	TRCell():New(oSection,"FT_VALICM"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_ISENICM"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_OUTRICM"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_ICMSCOM"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_ICMSDIF"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_BASEIPI"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_VALIPI"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_ISENIPI"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_OUTRIPI"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_IPIOBS"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_BASERET"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_ICMSRET"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_DESCZFR"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_ICMSCOM"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_ICMSDIF"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )

	TRCell():New(oSection,"FT_BRETPIS"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_BRETCOF"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_BRETCSL"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_VRETPIS"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_VRETCOF"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_VRETCSL"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_ARETPIS"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_ARETCOF"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_ARETCSL"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_ALQFECP"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_VALFECP"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_ALIQIRR"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_BASEIRR"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_VALIRR"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_BASEINS"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_ALIQINS"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_VALINS"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_OBSERV"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_DTCANC"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )
	TRCell():New(oSection,"FT_FORMUL"		,"SFT"	,						,/*Mascara*/	,30	,/*lPixel*/	,	 )

	If MV_PAR04 == 1
		TRCell():New(oSection,"FT_NFORI"		,"SFT"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
		TRCell():New(oSection,"FT_SERORI"		,"SFT"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
		TRCell():New(oSection,"FT_ITEMORI"		,"SFT"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
		TRCell():New(oSection,"FT_POSIPI"		,"SFT"	,					,/*Mascara*/	,30	,/*lPixel*/	,	 )
	EndIf

	If MV_PAR03 <> 1
		
		TRCell():New(oSection,"D2_PEDIDO"		,"SD2"	,				,/*Mascara*/	,30	,/*lPixel*/	,	 )

		If MV_PAR04 == 1
			TRCell():New(oSection,"C5_NUM"		,"SC5"	,				,/*Mascara*/	,30	,/*lPixel*/	,	 )
			TRCell():New(oSection,"X5_DESCRI"		,"SX5"	,				,/*Mascara*/	,30	,/*lPixel*/	,	 )
		EndIf

	EndIf

	TRFunction():New( oSection:Cell("FT_TOTAL"), Nil, "SUM", oBreak )

Return oReport

/*/{Protheus.doc} PrintReport
Impressao do relatorio
@type       Function
@author     Fabio Delgado
@since      03/2024
@version    1.0
/*/
Static Function PrintReport( oReport )
	Local cDataDe	:= ""
	Local cDataAt	:= ""
	Local nTipo		:= 0
	Local nTpRel	:= 0

	Local oSection	:= oReport:Section( 1 )

	//Transforma parametros do tipo Range em expressao SQL para ser utilizada na query
	MakeSqlExpr("RRELSFT")
	oSection:BeginQuery()

	cDataDe 	:= DTOS( MV_PAR01 )
	cDataAt 	:= DTOS( MV_PAR02 )
	nTipo       := MV_PAR03
	nTpRel		:= MV_PAR04

	If nTipo == 1

		If nTpRel == 1

			BeginSql alias "QRYEMP"
				SELECT	FT_FILIAL, M0_FILIAL, M0_NOMECOM, FT_TIPO, FT_ENTRADA, FT_EMISSAO, FT_ESPECIE, FT_NFISCAL, FT_SERIE, FT_CLIEFOR, FT_LOJA, A2_NOME
				,		A2_CGC, FT_ESTADO, FT_TES, FT_CFOP, FT_ESTOQUE, FT_PRODUTO, B1_DESC, FT_QUANT, FT_PRCUNIT, FT_DESCONT, FT_TOTAL
				,		FT_FRETE,FT_SEGURO, FT_DESPESA, FT_VALCONT, FT_BASEPIS, FT_ALIQPIS, FT_VALPIS, FT_BASECOF, FT_ALIQCOF, FT_VALCOF
				,		FT_BASEICM, FT_ALIQICM, FT_VALICM, FT_ISENICM, FT_OUTRICM, FT_ICMSCOM, FT_ICMSDIF, FT_BASEIPI, FT_VALIPI, FT_ISENIPI
				,		FT_OUTRIPI, FT_IPIOBS, FT_BASERET, FT_ICMSRET, FT_OBSERV, FT_DTCANC, FT_FORMUL, FT_NFORI, FT_SERORI, FT_ITEMORI, FT_POSIPI
				,		FT_DESCZFR,FT_ICMSCOM,FT_ICMSDIF,FT_ALQFECP,FT_VALFECP, FT_BRETPIS, FT_BRETCOF, FT_BRETCSL, FT_VRETPIS, FT_VRETCOF, FT_VRETCSL, FT_ARETPIS, FT_ARETCOF, FT_ARETCSL, FT_ALIQIRR,	FT_BASEIRR,	FT_VALIRR,	FT_BASEINS,	FT_ALIQINS,	FT_VALINS

				FROM 	%table:SFT% FT 
				INNER 	JOIN %table:SB1% B1 (nolock) ON B1_COD = FT_PRODUTO AND B1.%NotDel%
				INNER 	JOIN %table:SA2% A2 (nolock) ON FT_CLIEFOR = A2_COD AND FT_LOJA = A2_LOJA AND A2.%NotDel%
				INNER 	JOIN SYS_COMPANY CMP (nolock) ON M0_CODIGO = %exp:cEmpAnt% AND M0_CODFIL = FT_FILIAL AND CMP.%NotDel%
				WHERE 	FT.%NotDel% AND FT_ENTRADA BETWEEN %exp:cDatade% AND %exp:cDataAt%
				AND 	FT_CFOP < '5000'
				AND     FT_TIPO NOT IN ('B','D')

				UNION ALL

				SELECT	FT_FILIAL, M0_FILIAL, M0_NOMECOM, FT_TIPO, FT_ENTRADA, FT_EMISSAO, FT_ESPECIE, FT_NFISCAL, FT_SERIE, FT_CLIEFOR, FT_LOJA, A1_NOME
				,		A1_CGC, FT_ESTADO, FT_TES, FT_CFOP, FT_ESTOQUE, FT_PRODUTO, B1_DESC, FT_QUANT, FT_PRCUNIT, FT_DESCONT, FT_TOTAL
				,		FT_FRETE,FT_SEGURO, FT_DESPESA, FT_VALCONT, FT_BASEPIS, FT_ALIQPIS, FT_VALPIS, FT_BASECOF, FT_ALIQCOF, FT_VALCOF
				,		FT_BASEICM, FT_ALIQICM, FT_VALICM, FT_ISENICM, FT_OUTRICM, FT_ICMSCOM, FT_ICMSDIF, FT_BASEIPI, FT_VALIPI, FT_ISENIPI
				,		FT_OUTRIPI, FT_IPIOBS, FT_BASERET, FT_ICMSRET, FT_OBSERV, FT_DTCANC, FT_FORMUL, FT_NFORI, FT_SERORI, FT_ITEMORI, FT_POSIPI
				,		FT_DESCZFR,FT_ICMSCOM,FT_ICMSDIF,FT_ALQFECP,FT_VALFECP, FT_BRETPIS, FT_BRETCOF, FT_BRETCSL, FT_VRETPIS, FT_VRETCOF, FT_VRETCSL, FT_ARETPIS, FT_ARETCOF, FT_ARETCSL, FT_ALIQIRR,	FT_BASEIRR,	FT_VALIRR,	FT_BASEINS,	FT_ALIQINS,	FT_VALINS

				FROM 	%table:SFT% FT 
				INNER 	JOIN %table:SB1% B1 (nolock) ON B1_COD = FT_PRODUTO AND B1.%NotDel%
				INNER 	JOIN %table:SA1% A1 (nolock) ON FT_CLIEFOR = A1_COD AND FT_LOJA = A1_LOJA AND A1.%NotDel%
				INNER 	JOIN SYS_COMPANY CMP (nolock) ON M0_CODIGO = %exp:cEmpAnt% AND M0_CODFIL = FT_FILIAL AND CMP.%NotDel%
				WHERE 	FT.%NotDel% AND FT_ENTRADA BETWEEN %exp:cDatade% AND %exp:cDataAt%
				AND 	FT_CFOP < '5000'
				AND     FT_TIPO IN ('B','D')

			EndSql

		Else

			BeginSql alias "QRYEMP"
				SELECT	FT_FILIAL, M0_FILIAL, M0_NOMECOM, FT_TIPO, FT_ENTRADA, FT_EMISSAO, FT_ESPECIE, FT_NFISCAL, FT_SERIE, FT_CLIEFOR, FT_LOJA, A2_NOME, A2_CGC, FT_ESTADO, FT_CFOP, FT_DTCANC, FT_FORMUL, FT_ALIQICM, FT_OBSERV
				,		SUM(FT_TOTAL) AS FT_TOTAL, SUM(FT_VALCONT) AS FT_VALCONT, SUM(FT_BASEPIS) AS FT_BASEPIS, SUM(FT_VALPIS) AS FT_VALPIS, SUM(FT_BASECOF) AS FT_BASECOF, SUM(FT_VALCOF) AS FT_VALCOF
				,		SUM(FT_BASEICM) AS FT_BASEICM, SUM(FT_VALICM) AS FT_VALICM, SUM(FT_ISENICM) AS FT_ISENICM, SUM(FT_OUTRICM) AS FT_OUTRICM, SUM(FT_ICMSCOM) AS FT_ICMSCOM, SUM(FT_ICMSDIF) AS FT_ICMSDIF
				,		SUM(FT_BASEIPI) AS FT_BASEIPI, SUM(FT_VALIPI) AS FT_VALIPI, SUM(FT_ISENIPI) AS FT_ISENIPI, SUM(FT_OUTRIPI) AS FT_OUTRIPI, SUM(FT_IPIOBS) AS FT_IPIOBS, SUM(FT_BASERET) AS FT_BASERET
				,		SUM(FT_ICMSRET) AS FT_ICMSRET, SUM(FT_ICMSCOM) AS FT_ICMSCOM, SUM(FT_ICMSDIF) AS FT_ICMSDIF, SUM(FT_VALFECP) AS FT_VALFECP,
				sum(FT_BRETPIS) AS FT_BRETPIS, sum(FT_BRETCOF) AS FT_BRETCOF, SUM(FT_BRETCSL) AS FT_BRETCSL, SUM(FT_VRETPIS) AS FT_VRETPIS, SUM(FT_VRETCOF) AS FT_VRETCOF, SUM(FT_VRETCSL) AS FT_VRETCSL, SUM(FT_ARETPIS) AS FT_ARETPIS, SUM(FT_ARETCOF) AS FT_ARETCOF, SUM(FT_ARETCSL) AS FT_ARETCSL, SUM(FT_ALIQIRR) AS FT_ALIQIRR,	SUM(FT_BASEIRR) AS FT_BASEIRR,	SUM(FT_VALIRR) AS FT_VALIRR,	SUM(FT_BASEINS) AS FT_BASEINS,	SUM(FT_ALIQINS) AS FT_ALIQINS,	SUM(FT_VALINS) AS FT_VALINS				
				FROM	%table:SFT% FT
				INNER 	JOIN %table:SA2% A2 (nolock) ON FT_CLIEFOR = A2_COD AND FT_LOJA = A2_LOJA AND A2.%NotDel%
				INNER 	JOIN SYS_COMPANY CMP (nolock) ON M0_CODIGO = %exp:cEmpAnt% AND M0_CODFIL = FT_FILIAL AND CMP.%NotDel%
				WHERE 	FT.%NotDel% AND FT_ENTRADA BETWEEN %exp:cDatade% AND %exp:cDataAt%
				AND 	FT_CFOP < '5000'
				AND     FT_TIPO NOT IN ('B','D')
				GROUP	BY FT_FILIAL, M0_FILIAL, M0_NOMECOM, FT_TIPO, FT_ENTRADA, FT_EMISSAO, FT_ESPECIE, FT_NFISCAL, FT_SERIE, FT_CLIEFOR, FT_LOJA, A2_NOME, A2_CGC, FT_ESTADO, FT_CFOP, FT_DTCANC, FT_FORMUL, FT_ALIQICM, FT_OBSERV

				UNION ALL

				SELECT	FT_FILIAL, M0_FILIAL, M0_NOMECOM, FT_TIPO, FT_ENTRADA, FT_EMISSAO, FT_ESPECIE, FT_NFISCAL, FT_SERIE, FT_CLIEFOR, FT_LOJA, A1_NOME, A1_CGC, FT_ESTADO, FT_CFOP, FT_DTCANC, FT_FORMUL, FT_ALIQICM, FT_OBSERV
				,		SUM(FT_TOTAL) AS FT_TOTAL, SUM(FT_VALCONT) AS FT_VALCONT, SUM(FT_BASEPIS) AS FT_BASEPIS, SUM(FT_VALPIS) AS FT_VALPIS, SUM(FT_BASECOF) AS FT_BASECOF, SUM(FT_VALCOF) AS FT_VALCOF
				,		SUM(FT_BASEICM) AS FT_BASEICM, SUM(FT_VALICM) AS FT_VALICM, SUM(FT_ISENICM) AS FT_ISENICM, SUM(FT_OUTRICM) AS FT_OUTRICM, SUM(FT_ICMSCOM) AS FT_ICMSCOM, SUM(FT_ICMSDIF) AS FT_ICMSDIF
				,		SUM(FT_BASEIPI) AS FT_BASEIPI, SUM(FT_VALIPI) AS FT_VALIPI, SUM(FT_ISENIPI) AS FT_ISENIPI, SUM(FT_OUTRIPI) AS FT_OUTRIPI, SUM(FT_IPIOBS) AS FT_IPIOBS, SUM(FT_BASERET) AS FT_BASERET
				,		SUM(FT_ICMSRET) AS FT_ICMSRET, SUM(FT_ICMSCOM) AS FT_ICMSCOM, SUM(FT_ICMSDIF) AS FT_ICMSDIF, SUM(FT_VALFECP) AS FT_VALFECP,
				sum(FT_BRETPIS) AS FT_BRETPIS, sum(FT_BRETCOF) AS FT_BRETCOF, SUM(FT_BRETCSL) AS FT_BRETCSL, SUM(FT_VRETPIS) AS FT_VRETPIS, SUM(FT_VRETCOF) AS FT_VRETCOF, SUM(FT_VRETCSL) AS FT_VRETCSL, SUM(FT_ARETPIS) AS FT_ARETPIS, SUM(FT_ARETCOF) AS FT_ARETCOF, SUM(FT_ARETCSL) AS FT_ARETCSL, SUM(FT_ALIQIRR) AS FT_ALIQIRR,	SUM(FT_BASEIRR) AS FT_BASEIRR,	SUM(FT_VALIRR) AS FT_VALIRR,	SUM(FT_BASEINS) AS FT_BASEINS,	SUM(FT_ALIQINS) AS FT_ALIQINS,	SUM(FT_VALINS) AS FT_VALINS
				FROM	%table:SFT% FT
				INNER 	JOIN %table:SA1% A1 (nolock) ON FT_CLIEFOR = A1_COD AND FT_LOJA = A1_LOJA AND A1.%NotDel%
				INNER 	JOIN SYS_COMPANY CMP (nolock) ON M0_CODIGO = %exp:cEmpAnt% AND M0_CODFIL = FT_FILIAL AND CMP.%NotDel%
				WHERE 	FT.%NotDel% AND FT_ENTRADA BETWEEN %exp:cDatade% AND %exp:cDataAt%
				AND 	FT_CFOP < '5000'
				AND     FT_TIPO IN ('B','D')
				GROUP	BY FT_FILIAL, M0_FILIAL, M0_NOMECOM, FT_TIPO, FT_ENTRADA, FT_EMISSAO, FT_ESPECIE, FT_NFISCAL, FT_SERIE, FT_CLIEFOR, FT_LOJA, A1_NOME, A1_CGC, FT_ESTADO, FT_CFOP, FT_DTCANC, FT_FORMUL, FT_ALIQICM, FT_OBSERV
			EndSql

		EndIf

	Else

		If nTpRel == 1

			BeginSql alias "QRYEMP"
				SELECT TAB.*, X5_DESCRI
				FROM	(
						SELECT	FT_FILIAL, M0_FILIAL, M0_NOMECOM, FT_TIPO, FT_ENTRADA, FT_EMISSAO, FT_ESPECIE, FT_NFISCAL, FT_SERIE,	FT_CLIEFOR,	FT_LOJA, A1_NOME
						,		A1_CGC, FT_ESTADO, FT_TES, FT_CFOP, FT_ESTOQUE, FT_PRODUTO, B1_DESC, FT_QUANT, FT_PRCUNIT, FT_DESCONT, FT_TOTAL
						,		FT_FRETE,FT_SEGURO, FT_DESPESA, FT_VALCONT, FT_BASEPIS, FT_ALIQPIS, FT_VALPIS, FT_BASECOF, FT_ALIQCOF, FT_VALCOF
						,		FT_BASEICM, FT_ALIQICM, FT_VALICM, FT_ISENICM, FT_OUTRICM, FT_ICMSCOM, FT_ICMSDIF, FT_BASEIPI, FT_VALIPI, FT_ISENIPI
						,		FT_OUTRIPI, FT_IPIOBS, FT_BASERET, FT_ICMSRET, FT_OBSERV, FT_DTCANC, FT_FORMUL, FT_NFORI, FT_SERORI, FT_ITEMORI, FT_CODNFE, FT_POSIPI,
						(
								SELECT TOP 1 D2_PEDIDO FROM %table:SD2% WHERE %NotDel% AND FT_FILIAL = D2_FILIAL AND FT_NFISCAL = D2_DOC AND FT_SERIE = D2_SERIE AND FT_CLIEFOR = D2_CLIENTE AND FT_LOJA = D2_LOJA
						) 		AS D2_PEDIDO
						,		FT_DESCZFR, FT_ALQFECP, FT_VALFECP
						FROM	%table:SFT% FT
						INNER 	JOIN %table:SB1% B1 (nolock) ON B1_COD = FT_PRODUTO AND B1.%NotDel%
						INNER 	JOIN %table:SA1% A1 (nolock) ON FT_CLIEFOR = A1_COD AND FT_LOJA = A1_LOJA AND A1.%NotDel%
						INNER 	JOIN SYS_COMPANY CMP (nolock) ON M0_CODIGO = %exp:cEmpAnt% AND M0_CODFIL = FT_FILIAL AND CMP.%NotDel%
						WHERE 	FT.%NotDel% AND FT_ENTRADA BETWEEN %exp:cDatade% AND %exp:cDataAt%
						AND 	FT_CFOP >= '5000'
						AND     FT_TIPO NOT IN ('B','D')
						) 		AS TAB
				LEFT 	JOIN %table:SC5% C5 (nolock) ON C5_NUM = D2_PEDIDO AND C5_CLIENTE = FT_CLIEFOR AND C5_FILIAL = FT_FILIAL AND C5.%NotDel%
				LEFT 	JOIN %table:SX5% X5 (nolock) ON X5_TABELA = 'ZV' AND X5_CHAVE = C5_NUM AND X5.%NotDel%

				UNION ALL

				SELECT TAB.*, X5_DESCRI
				FROM	(
						SELECT	FT_FILIAL, M0_FILIAL, M0_NOMECOM, FT_TIPO, FT_ENTRADA, FT_EMISSAO, FT_ESPECIE, FT_NFISCAL, FT_SERIE,	FT_CLIEFOR,	FT_LOJA, A2_NOME
						,		A2_CGC, FT_ESTADO, FT_TES, FT_CFOP, FT_ESTOQUE, FT_PRODUTO, B1_DESC, FT_QUANT, FT_PRCUNIT, FT_DESCONT, FT_TOTAL
						,		FT_FRETE,FT_SEGURO, FT_DESPESA, FT_VALCONT, FT_BASEPIS, FT_ALIQPIS, FT_VALPIS, FT_BASECOF, FT_ALIQCOF, FT_VALCOF
						,		FT_BASEICM, FT_ALIQICM, FT_VALICM, FT_ISENICM, FT_OUTRICM, FT_ICMSCOM, FT_ICMSDIF, FT_BASEIPI, FT_VALIPI, FT_ISENIPI
						,		FT_OUTRIPI, FT_IPIOBS, FT_BASERET, FT_ICMSRET, FT_OBSERV, FT_DTCANC, FT_FORMUL, FT_NFORI, FT_SERORI, FT_ITEMORI, FT_CODNFE, FT_POSIPI,
						(
								SELECT TOP 1 D2_PEDIDO FROM %table:SD2% WHERE %NotDel% AND FT_FILIAL = D2_FILIAL AND FT_NFISCAL = D2_DOC AND FT_SERIE = D2_SERIE AND FT_CLIEFOR = D2_CLIENTE AND FT_LOJA = D2_LOJA
						) 		AS D2_PEDIDO
						,		FT_DESCZFR, FT_ALQFECP, FT_VALFECP
						FROM	%table:SFT% FT
						INNER 	JOIN %table:SB1% B1 (nolock) ON B1_COD = FT_PRODUTO AND B1.%NotDel%
						INNER 	JOIN %table:SA2% A2 (nolock) ON FT_CLIEFOR = A2_COD AND FT_LOJA = A2_LOJA AND A2.%NotDel%
						INNER 	JOIN SYS_COMPANY CMP (nolock) ON M0_CODIGO = %exp:cEmpAnt% AND M0_CODFIL = FT_FILIAL AND CMP.%NotDel%
						WHERE 	FT.%NotDel% AND FT_ENTRADA BETWEEN %exp:cDatade% AND %exp:cDataAt%
						AND 	FT_CFOP >= '5000'
						AND     FT_TIPO IN ('B','D')
						) 		AS TAB
				LEFT 	JOIN %table:SC5% C5 (nolock) ON C5_NUM = D2_PEDIDO AND C5_CLIENTE = FT_CLIEFOR AND C5_FILIAL = FT_FILIAL AND C5.%NotDel%
				LEFT 	JOIN %table:SX5% X5 (nolock) ON X5_TABELA = 'ZV' AND X5_CHAVE = C5_NUM AND X5.%NotDel%


			EndSql

		Else

			BeginSql alias "QRYEMP"
				SELECT	FT_FILIAL, M0_FILIAL, M0_NOMECOM, FT_TIPO, FT_ENTRADA, FT_EMISSAO, FT_ESPECIE, FT_NFISCAL, FT_SERIE, FT_CLIEFOR, FT_LOJA, A1_NOME ,A1_CGC ,FT_ESTADO ,FT_CFOP, FT_DTCANC, FT_FORMUL, FT_ESTOQUE, FT_ALIQICM, FT_OBSERV
				,		( SELECT TOP 1 D2_PEDIDO FROM %table:SD2% WHERE  %NotDel% AND FT_FILIAL = D2_FILIAL AND FT_NFISCAL = D2_DOC AND FT_SERIE = D2_SERIE AND FT_CLIEFOR = D2_CLIENTE AND FT_LOJA = D2_LOJA )  AS D2_PEDIDO
				,		SUM(FT_TOTAL) AS FT_TOTAL, SUM(FT_VALCONT) AS FT_VALCONT, SUM(FT_BASEPIS) AS FT_BASEPIS, SUM(FT_VALPIS) AS FT_VALPIS, SUM(FT_BASECOF) AS FT_BASECOF, SUM(FT_VALCOF) AS FT_VALCOF
				, 		SUM(FT_BASEICM) AS FT_BASEICM, SUM(FT_VALICM) AS FT_VALICM, SUM(FT_ISENICM) AS FT_ISENICM, SUM(FT_OUTRICM) AS FT_OUTRICM, SUM(FT_ICMSCOM) AS FT_ICMSCOM, SUM(FT_ICMSDIF) AS FT_ICMSDIF
				, 		SUM(FT_BASEIPI) AS FT_BASEIPI, SUM(FT_VALIPI) AS FT_VALIPI, SUM(FT_ISENIPI) AS FT_ISENIPI, SUM(FT_OUTRIPI) AS FT_OUTRIPI, SUM(FT_IPIOBS) AS FT_IPIOBS, SUM(FT_BASERET) AS FT_BASERET
				, 		SUM(FT_ICMSRET) AS FT_ICMSRET, SUM(FT_DESCZFR) AS FT_DESCZFR, SUM(FT_VALFECP) AS FT_VALFECP,
				sum(FT_BRETPIS) AS FT_BRETPIS, sum(FT_BRETCOF) AS FT_BRETCOF, SUM(FT_BRETCSL) AS FT_BRETCSL, SUM(FT_VRETPIS) AS FT_VRETPIS, SUM(FT_VRETCOF) AS FT_VRETCOF, SUM(FT_VRETCSL) AS FT_VRETCSL, SUM(FT_ARETPIS) AS FT_ARETPIS, SUM(FT_ARETCOF) AS FT_ARETCOF, SUM(FT_ARETCSL) AS FT_ARETCSL, SUM(FT_ALIQIRR) AS FT_ALIQIRR,	SUM(FT_BASEIRR) AS FT_BASEIRR,	SUM(FT_VALIRR) AS FT_VALIRR,	SUM(FT_BASEINS) AS FT_BASEINS,	SUM(FT_ALIQINS) AS FT_ALIQINS,	SUM(FT_VALINS) AS FT_VALINS				
				FROM	%table:SFT% FT
				INNER	JOIN %table:SA1% A1 (nolock) ON FT_CLIEFOR = A1_COD AND FT_LOJA = A1_LOJA AND A1.%NotDel%
				INNER 	JOIN SYS_COMPANY CMP (nolock) ON M0_CODIGO = %exp:cEmpAnt% AND M0_CODFIL = FT_FILIAL AND CMP.%NotDel%
				WHERE 	FT.%NotDel% AND FT_ENTRADA BETWEEN %exp:cDatade% AND %exp:cDataAt%
				AND 	FT_CFOP >= '5000'
				AND     FT_TIPO NOT IN ('B','D')
				GROUP	BY FT_FILIAL, M0_FILIAL, M0_NOMECOM, FT_TIPO, FT_ENTRADA, FT_EMISSAO, FT_ESPECIE, FT_NFISCAL, FT_SERIE, FT_CLIEFOR, FT_LOJA, A1_NOME ,A1_CGC ,FT_ESTADO ,FT_CFOP, FT_DTCANC, FT_FORMUL, FT_ESTOQUE, FT_ALIQICM, FT_OBSERV

				UNION ALL

				SELECT	FT_FILIAL, M0_FILIAL, M0_NOMECOM, FT_TIPO, FT_ENTRADA, FT_EMISSAO, FT_ESPECIE, FT_NFISCAL, FT_SERIE, FT_CLIEFOR, FT_LOJA, A2_NOME ,A2_CGC ,FT_ESTADO ,FT_CFOP, FT_DTCANC, FT_FORMUL, FT_ESTOQUE, FT_ALIQICM, FT_OBSERV
				,		( SELECT TOP 1 D2_PEDIDO FROM %table:SD2% WHERE  %NotDel% AND FT_FILIAL = D2_FILIAL AND FT_NFISCAL = D2_DOC AND FT_SERIE = D2_SERIE AND FT_CLIEFOR = D2_CLIENTE AND FT_LOJA = D2_LOJA )  AS D2_PEDIDO
				,		SUM(FT_TOTAL) AS FT_TOTAL, SUM(FT_VALCONT) AS FT_VALCONT, SUM(FT_BASEPIS) AS FT_BASEPIS, SUM(FT_VALPIS) AS FT_VALPIS, SUM(FT_BASECOF) AS FT_BASECOF, SUM(FT_VALCOF) AS FT_VALCOF
				, 		SUM(FT_BASEICM) AS FT_BASEICM, SUM(FT_VALICM) AS FT_VALICM, SUM(FT_ISENICM) AS FT_ISENICM, SUM(FT_OUTRICM) AS FT_OUTRICM, SUM(FT_ICMSCOM) AS FT_ICMSCOM, SUM(FT_ICMSDIF) AS FT_ICMSDIF
				, 		SUM(FT_BASEIPI) AS FT_BASEIPI, SUM(FT_VALIPI) AS FT_VALIPI, SUM(FT_ISENIPI) AS FT_ISENIPI, SUM(FT_OUTRIPI) AS FT_OUTRIPI, SUM(FT_IPIOBS) AS FT_IPIOBS, SUM(FT_BASERET) AS FT_BASERET
				, 		SUM(FT_ICMSRET) AS FT_ICMSRET, SUM(FT_DESCZFR) AS FT_DESCZFR, SUM(FT_VALFECP) AS FT_VALFECP,
				sum(FT_BRETPIS) AS FT_BRETPIS, sum(FT_BRETCOF) AS FT_BRETCOF, SUM(FT_BRETCSL) AS FT_BRETCSL, SUM(FT_VRETPIS) AS FT_VRETPIS, SUM(FT_VRETCOF) AS FT_VRETCOF, SUM(FT_VRETCSL) AS FT_VRETCSL, SUM(FT_ARETPIS) AS FT_ARETPIS, SUM(FT_ARETCOF) AS FT_ARETCOF, SUM(FT_ARETCSL) AS FT_ARETCSL, SUM(FT_ALIQIRR) AS FT_ALIQIRR,	SUM(FT_BASEIRR) AS FT_BASEIRR,	SUM(FT_VALIRR) AS FT_VALIRR,	SUM(FT_BASEINS) AS FT_BASEINS,	SUM(FT_ALIQINS) AS FT_ALIQINS,	SUM(FT_VALINS) AS FT_VALINS				
				FROM	%table:SFT% FT
				INNER	JOIN %table:SA2% A2 (nolock) ON FT_CLIEFOR = A2_COD AND FT_LOJA = A2_LOJA AND A2.%NotDel%
				INNER 	JOIN SYS_COMPANY CMP (nolock) ON M0_CODIGO = %exp:cEmpAnt% AND M0_CODFIL = FT_FILIAL AND CMP.%NotDel%
				WHERE 	FT.%NotDel% AND FT_ENTRADA BETWEEN %exp:cDatade% AND %exp:cDataAt%
				AND 	FT_CFOP >= '5000'
				AND     FT_TIPO IN ('B','D')
				GROUP	BY FT_FILIAL, M0_FILIAL, M0_NOMECOM, FT_TIPO, FT_ENTRADA, FT_EMISSAO, FT_ESPECIE, FT_NFISCAL, FT_SERIE, FT_CLIEFOR, FT_LOJA, A2_NOME ,A2_CGC ,FT_ESTADO ,FT_CFOP, FT_DTCANC, FT_FORMUL, FT_ESTOQUE, FT_ALIQICM, FT_OBSERV
				ORDER	BY FT_NFISCAL, FT_SERIE

			EndSql

		EndIf

	EndIf

	oSection:EndQuery()
	oSection:Print()

Return Nil

/*/{Protheus.doc} CriaPerg
Cria perguntas do relatorio
@author     Fabio Delgado
@since      03/2024
@type 		Function
/*/
Static Function CriaPerg( cPerg )

	Local aPerg		:= {}
	Local lLock		:= .F.
	Local nX		:= 0

	cPerg	:= PadR( cPerg, 10 )

	DbSelectArea("SX1")
	DbSetOrder(1)

	Aadd( aPerg, { "Data De"			, "D", 08, 00, "G", ""			, ""			, "", "", "", ""	} )
	Aadd( aPerg, { "Data Ate"			, "D", 08, 00, "G", ""			, ""			, "", "", "", ""	} )
	Aadd( aPerg, { "Tipo"				, "C", 1 , 00, "C", "Entrada"	, "Saida"		, "", "", "", ""	} )
	Aadd( aPerg, { "Tipo de Relatório"	, "C", 1 , 00, "C", "Analitico"	, "Sintetico"	, "", "", "", ""	} )

	For nX := 1 To Len( aPerg )

		lLock := !SX1->( Dbseek( cPerg + StrZero( nX, 2 ) ) )

		Reclock("SX1", lLock)
		SX1->X1_GRUPO 		:= cPerg
		SX1->X1_ORDEM		:= StrZero( nX, 2 )
		SX1->X1_VARIAVL		:= "mv_ch" + Chr( nX + 96 )
		SX1->X1_VAR01		:= "mv_par" + StrZero( nX, 2 )
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

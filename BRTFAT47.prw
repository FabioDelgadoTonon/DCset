#Include "Totvs.ch"
#Include "FWPrintSetup.ch"
#Include "RptDef.ch"                                      
#Include "ParmType.ch"
#Include "BRTFAT47.ch"

#Define COLUINI		0005
#Define MAXCOLU		0870

/*==========================================================================
 Funcao...........:	BRTFAT47
 Descricao........:	Relatorio Grafico de Orcamento / Pedido de Vendas
 Autor............:	Fabrica de Software (Fabritech)
 Parametros.......:	Nil
 Retorno..........:	Nil
==========================================================================*/
User Function BRTFAT47()
	Local cRotina	:= IIF( Alltrim( FunName() ) == "MATA415", "MATA415"			, "MATA410"			)
	Local cNumero	:= IIF( Alltrim( FunName() ) == "MATA415", "O" + SCJ->CJ_NUM	, "P" + SC5->C5_NUM	)
	Local cRelName  := cFilAnt + cNumero
	Local aDevice 	:= {}
	Local aOrdem 	:= {}
	Local nOrdem 	:= 1
	Local cSession  := GetPrinterSession()
	Local lAdjust   := .F.
	Local nFlags    := PD_ISTOTVSPRINTER+PD_DISABLEPAPERSIZE
	Local nPrintTy	:= 6
	Local oPrinter 	:= Nil
	Local oSetup    := Nil
	
	Private oFont06	:= TFont():New("Arial",,006,,.T.,,,,,.F.,.F.)
	Private oFont08	:= TFont():New("Arial",,008,,.T.,,,,,.F.,.F.)
	Private oFont10 := TFont():New("Arial",,010,,.T.,,,,,.F.,.F.)
	Private oFont12 := TFont():New("Arial",,012,,.T.,,,,,.F.,.F.)
	Private oFont14 := TFont():New("Arial",,014,,.T.,,,,,.F.,.F.)
	
	Private nMaxLin	:= 510
	Private nLinha	:= 900
	Private nPagina	:= 000
	Private lImpImp	:= .F.
	
	AADD(aDevice,"DISCO") // 1
	AADD(aDevice,"SPOOL") // 2
	AADD(aDevice,"EMAIL") // 3
	AADD(aDevice,"EXCEL") // 4
	AADD(aDevice,"HTML" ) // 5
	AADD(aDevice,"PDF"  ) // 6
	
	cSession	:= GetPrinterSession()
	cDevice		:= If( Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.) )
	nOrient		:= If( fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2 )
	nLocal		:= If( fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
	nPrintTy	:= aScan(aDevice,{|x| x == cDevice } )
	
	oPrinter 	:= FWMSPrinter():New(cRelName, nPrintTy, lAdjust, ,.T.)
	
	oSetup		:= FWPrintSetup():New(nFlags,cRelName)
	
	oSetup:SetPropert( PD_PRINTTYPE   , nPrintTy	)
	oSetup:SetPropert( PD_ORIENTATION , nOrient		)
	oSetup:SetPropert( PD_DESTINATION , nLocal		)
	oSetup:SetPropert( PD_MARGIN      , {0,0,0,0}	)
	
	oSetup:SetOrderParms(aOrdem,@nOrdem)
	
	If oSetup:Activate() == PD_OK 
	
		fwWriteProfString( cSession, "LOCAL"      , If(oSetup:GetProperty(PD_DESTINATION) == 1	,"SERVER"    ,"CLIENT"    ), .T. )
		fwWriteProfString( cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE) == 2  	,"SPOOL"     ,"PDF"       ), .T. )
		fwWriteProfString( cSession, "ORIENTATION", If(oSetup:GetProperty(PD_ORIENTATION) == 1	,"PORTRAIT"  ,"LANDSCAPE" ), .T. )
	
		oPrinter:lServer := oSetup:GetProperty(PD_DESTINATION) == AMB_SERVER
		oPrinter:SetDevice(oSetup:GetProperty(PD_PRINTTYPE))
	
		If oSetup:GetProperty(PD_ORIENTATION) == 1
			oPrinter:SetPortrait()
		Else 
			oPrinter:SetLandscape()
		EndIf
	
		oPrinter:SetPaperSize(oSetup:GetProperty(PD_PAPERSIZE))
		oPrinter:setCopies(Val(oSetup:cQtdCopia))
	
		oPrinter:SetResolution(78)
		oPrinter:SetLandscape()
		oPrinter:SetPaperSize(DMPAPER_A4)
		oPrinter:SetMargin(60,60,60,60)

		If oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
			oPrinter:nDevice 	:= IMP_SPOOL
			fwWriteProfString(GetPrinterSession(),"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)
			oPrinter:cPrinter	:= oSetup:aOptions[PD_VALUETYPE]
		Else 
			oPrinter:nDevice 	:= IMP_PDF
			oPrinter:cPathPDF 	:= oSetup:aOptions[PD_VALUETYPE]
			oPrinter:SetViewPDF(.T.)
		Endif
		
		RptStatus({|lEnd| IMPRELA( cNumero, cRotina, @lEnd, nOrdem, @oPrinter ) },STR001) //"Imprimindo Relatorio..."
		
	Else 
		MsgInfo( STR002 ) //"Relatório cancelado pelo usuário."
		oPrinter:Cancel()
	EndIf
	
	oSetup		:= Nil
	oPrinter	:= Nil

Return Nil

/*==========================================================================
 Funcao...........:	IMPRELA
 Descricao........:	Impressao do Relatorio
 Parametros.......:	Nil
 Retorno..........:	Nil
==========================================================================*/
Static Function IMPRELA( cNumero, cRotina, lEnd, nOrdem, oPrinter )
	If cRotina == "MATA415"
		ImpOrca( cNumero, lEnd, nOrdem, oPrinter )
	Else
		ImpPedi( cNumero, lEnd, nOrdem, oPrinter )
	EndIf
Return Nil

/*==========================================================================
 Funcao...........:	ImpOrca
 Descricao........:	Impressao do Relatorio (Orcamento)
 Parametros.......:	Nil
 Retorno..........:	Nil
==========================================================================*/
Static Function ImpOrca( cNumero, lEnd, nOrdem, oPrinter )
    Local aAreaATU		:= GetArea() 
    Local aAreaSCJ		:= SCJ->( GetArea() )
    Local aAreaSCK		:= SCK->( GetArea() )
    Local aAreaSB1		:= SB1->( GetArea() )
	Local aImprime		:= {}
	Local aImpostos		:= {}
	Local aSolid		:= {}
	Local nAliICM       := 0
	Local nValICM		:= 0
	Local nValRet		:= 0
	Local nValIpi		:= 0
	Local nPags			:= 1
	Local nConPag		:= 0
	Local nQtdItem		:= 0
	Local nDesItem		:= 0
	Local nX			:= 0
	Local nP			:= 0
	
 	Private cNumAten	:= SCJ->CJ_NUM
    Private dEmissao	:= SCJ->CJ_EMISSAO
    Private cVendedor	:= SCJ->CJ_XVEND
    Private cDescOrc	:= STR003 //"Orçamento de Vendas"
    Private cObserva	:= ""
    Private cTpFrete	:= STR004 //"Orçamento"
    Private nDespesa	:= SCJ->CJ_DESPESA
    Private nFrete		:= 0
    
	Private nBaseCal	:= 0
	Private nBasRet		:= 0
	Private nTotST		:= 0
	Private nBasIpi		:= 0
	Private nTotIPI		:= 0
	Private nTotSIm		:= 0
	Private nBasICM		:= 0
	Private nTotICMS	:= 0
	Private nTotal		:= 0

	Private nItPed		:= 0
	Private nTotBasIcm	:= 0	
    
	Private nPrcLista := 0
	Private nValMerc  := 0
	Private nDesconto := 0
	Private nAcresFin := 0
	Private nQtdPeso  := 0
	Private nItem     := 0

	//Posiciona Cond. Pagto.
	DbSelectArea("SE4")
	SE4->( DbSetOrder(1) )
	SE4->( DbSeek( xFilial("SE4") + SCJ->CJ_CONDPAG ) )
		
	//Posiciona Cliente
	DbSelectarea("SA1")
	SA1->( DbSetorder(1) )
	SA1->( DbSeek(xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA) )
	
	//Salva Funcao Fiscal atual
	nSavNF	:= MaFisSave()

	//Pega a quantidade de itens
	DbSelectarea("SCK")
	SCK->( DbSetorder(1) )
	SCK->( DbSeek(xFilial("SCK") + cNumAten) )
	While !SCK->( Eof() ) .And. 	SCK->CK_FILIAL == xFilial("SCK") .And.;
									SCK->CK_NUM == cNumAten

		nQtdItem ++
		
		SCK->( DbSkip() )
	End
	
	If nDespesa > 0
		nDesItem := nDespesa / nQtdItem
	EndIf
	
	//Posiciona Itens
	DbSelectarea("SCK")
	SCK->( DbSetorder(1) )
	SCK->( DbSeek(xFilial("SCK") + cNumAten) )
	While !SCK->( Eof() ) .And. 	SCK->CK_FILIAL == xFilial("SCK") .And.;
									SCK->CK_NUM == cNumAten

		nValRet	:= 0
		nValIpi	:= 0
		nAliICM := 0
		nValICM	:= 0
		nItPed 	++
		
		DbSelectarea("SB1")
		SB1->( DbSetorder(1) )
		SB1->( DbSeek(xFilial("SB1") + SCK->CK_PRODUTO) )

		dbSelectArea("SE4")
		dbSetOrder(1)
		MsSeek(xFilial("SE4")+SCJ->CJ_CONDPAG)

		//Finaliza Funcao fiscal
		MaFisEnd()

		//Inicia Funcao Fiscal
		MaFisIni(	SA1->A1_COD			,;	// 01 - Codigo Cliente
					SA1->A1_LOJA		,;	// 02 - Loja do Cliente
					"C"					,;	// 03 - C:Cliente , F:Fornecedor
					"N"					,;	// 04 - Tipo da NF
					SA1->A1_TIPO		,;	// 05 - Tipo do Cliente
					Nil					,;	// 06 - Relacao de Impostos que suportados no arquivo
					Nil					,;	// 07 - Tipo de complemento
					Nil					,;	// 08 - Permite Incluir Impostos no Rodape .T./.F.
					"SB1"				,;	// 09 - Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
					"MATA410"			,;	// 10 - Nome da rotina que esta utilizando a funcao
					Nil					,;	// 11 - Tipo de documento
					Nil					,;	// 12 - Especie do documento
					Nil					,;	// 13 - Codigo e Loja do Prospect
					Nil					,;	// 14 - Grupo Cliente
					Nil					,;	// 15 - Recolhe ISS
					Nil					,;	// 16 - Codigo do cliente de entrega na nota fiscal de saida
					Nil					,;	// 17 - Loja do cliente de entrega na nota fiscal de saida
					Nil					)	// 18 - Informacoes do transportador [01]-UF,[02]-TPTRANS

       	//Adiciona o Produto para Calculo dos Impostos
		MaFisAdd(	SB1->B1_COD			,;  // 01 - Codigo do Produto ( Obrigatorio )
					SCK->CK_TES			,;	// 02 - Codigo do TES ( Opcional )
					SCK->CK_QTDVEN		,;	// 03 - Quantidade ( Obrigatorio )
					SCK->CK_PRCVEN		,; 	// 04 - Preco Unitario ( Obrigatorio )
					0					,;  // 05 - Valor do Desconto ( Opcional )
					""					,;	// 06 - Numero da NF Original ( Devolucao/Benef )
					""					,;	// 07 - Serie da NF Original ( Devolucao/Benef )
					0					,;	// 08 - RecNo da NF Original no arq SD1/SD2
					0					,;	// 09 - Valor do Frete do Item ( Opcional )
					nDesItem			,;	// 10 - Valor da Despesa do item ( Opcional )
					0					,;	// 11 - Valor do Seguro do item ( Opcional )
					0					,;	// 12 - Valor do Frete Autonomo ( Opcional )
					SCK->CK_VALOR		,;	// 13 - Valor da Mercadoria ( Obrigatorio )
					0					,;	// 14 - Valor da Embalagem ( Opiconal )
					NIL					,;	// 15 - RecNo do SB1
					NIL					,;	// 16 - RecNo do SF4
					NIL					)
		aImpostos 	:= MafisRet(NIL, "NF_IMPOSTOS")

		ICMSITEM    := MaFisRet(1,"IT_VALICM")		// variavel para ponto de entrada M410SOLI
		QUANTITEM	:= MaFisRet(1,"IT_QUANT")		// variavel para ponto de entrada M410SOLI

		If Len(aImpostos) > 0

			nPosRet		:= Ascan( aImpostos, { |x| AllTrim(x[01]) == "ICR" } )
			nPosIPI		:= Ascan( aImpostos, { |x| AllTrim(x[01]) == "IPI" } )
			nPosICM		:= Ascan( aImpostos, { |x| AllTrim(x[01]) == "ICM" } )

			If nPosRet > 0
				If !Empty(aSolid)
					nBasRet += NoRound(aSolid[1],2)
					nValRet	:= NoRound(aSolid[2],2)
				Else
					nBasRet += aImpostos[nPosRet][03]
					nValRet	:= aImpostos[nPosRet][05]
				EndIf
			EndIf

			If nPosIPI > 0
				nBasIpi	:= aImpostos[nPosIPI][03]
				nValIpi	:= aImpostos[nPosIPI][05]
			EndIf

			If nPosICM > 0
				nBasICM := aImpostos[nPosICM][03]
				nValICM	:= aImpostos[nPosICM][05]
				nAliICM := aImpostos[nPosICM][04]
			EndIf

		EndIf
		
		//Armazena Totais
		nBaseCal	+= SCK->CK_VALOR + nValRet + nValIpi
		nTotST		+= nValRet
		nTotIPI		+= nValIpi
		nTotSIm		+= SCK->CK_VALOR
		nTotICMS	+= nValICM
		nTotBasIcm	+= nBasICM		
		nTotal		:= nBaseCal
		
		//Armazena dados para impressao
		Aadd( aImprime,	{;
						SCK->CK_ITEM,;
						Transform( SCK->CK_QTDVEN, PesqPictQT("CK_QTDVEN") ),;
						SB1->B1_UM,;
						Transform( SB1->B1_POSIPI, "@R 9999.99.99" ) ,;
						SB1->B1_COD,;
						SubStr(SB1->B1_DESC,1,45),;
						Transform( SCK->CK_PRCVEN, "@E 99,999,999.99" ),;
						Transform( SCK->CK_VALOR, "@E 99,999,999.99" ),;
						Transform( nAliICM, "@E 999.99" ),;
						Transform( nValICM, "@E 999,999.99" ),;
						Transform( nValRet, "@E 999,999.99" ),;
						Transform( nValIpi, "@E 999,999.99" ),;
						Transform( SCK->CK_VALOR + nValRet + nValIpi, "@E 999,999.99" );
						})
						
		SCK->( DbSkip() )
	End

	//Finaliza Funcao fiscal
	MaFisEnd()

	//Restaura Funcao Fiscal
	MaFisRestore( nSavNF )

	//Verifica numero de paginas
	For nP := 1 To Len( aImprime )
		
		nConPag ++
		
		If nPags == 1
			If nConPag >= 29
				nConPag	:= 0
				nPags 	++
			EndIf
		Else
			If nConPag >= 45
				nConPag	:= 0
				nPags 	++
			EndIf
		EndIf
	
	Next nP
	
	//Caso seja uma pagina e mais de 20 itens, aumenta uma pagina para o resumo.
	If nPags == 1 .And. Len( aImprime ) > 20
		nPags ++
	//Caso seja mais de uma pagina e os itens forem maior de 36, aumenta uma para o resumo
	ElseIf nPags > 1 .And. nConPag > 36
		nPags ++
	EndIf
	
	For nX := 1 To Len( aImprime )
	
		If nLinha > nMaxLin
			ImpCabec( oPrinter, nPags, aImprime )
		EndIf
		
		oPrinter:Say( nLinha,COLUINI+0010,aImprime[ nX ][ 01 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0030,aImprime[ nX ][ 02 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0070,aImprime[ nX ][ 03 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0100,aImprime[ nX ][ 04 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0145,aImprime[ nX ][ 05 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0205,aImprime[ nX ][ 06 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0470,aImprime[ nX ][ 07 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0550,aImprime[ nX ][ 08 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0594,aImprime[ nX ][ 09 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0635,aImprime[ nX ][ 10 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0700,aImprime[ nX ][ 11 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0750,aImprime[ nX ][ 12 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0795,aImprime[ nX ][ 13 ]	,oFont06 )

		//Linha divisoria
		If nX <> Len( aImprime )
			nLinha := nLinha + 05
			oPrinter:Line(nLinha,COLUINI,nLinha,MAXCOLU)
			nLinha := nLinha + 06
		EndIf

	Next nX
	
	If !lImpImp
		ImpCabec( oPrinter, nPags, aImprime )
	EndIf
	
	oPrinter:Print()

    RestArea( aAreaATU )
    RestArea( aAreaSCJ )
    RestArea( aAreaSCK )
    RestArea( aAreaSB1 )

Return Nil

/*==========================================================================
 Funcao...........:	ImpPedi
 Descricao........:	Impressao do Relatorio (Pedido)
 Parametros.......:	Nil
 Retorno..........:	Nil
==========================================================================*/
Static Function ImpPedi( cNumero, lEnd, nOrdem, oPrinter )
    Local aAreaATU		:= GetArea() 
    Local aAreaSC5		:= SC5->( GetArea() )
    Local aAreaSC6		:= SC6->( GetArea() )
    Local aAreaSB1		:= SB1->( GetArea() )
	Local aImprime		:= {}
	Local aImpostos		:= {}
	Local aSolid		:= {}
	Local nAliICM       := 0
	Local nValICM		:= 0
	Local nValRet		:= 0
	Local nValIpi		:= 0
	Local nPags			:= 1
	Local nConPag		:= 0
	Local nQtdItem		:= 0
	Local nDesItem		:= 0
	Local nX			:= 0
	Local nP			:= 0
	
 	Private cNumAten	:= SC5->C5_NUM
    Private dEmissao	:= SC5->C5_EMISSAO
    Private cVendedor	:= SC5->C5_VEND1
    Private cDescOrc	:= STR005 //"Pedido de Vendas"
    Private cObserva	:= ""
    Private cTpFrete	:= X3Combo( "C5_TPFRETE", SC5->C5_TPFRETE )
    Private nDespesa	:= SC5->C5_DESPESA
    Private nFrete		:= 0
    
	Private nBaseCal	:= 0
	Private nBasRet		:= 0
	Private nTotST		:= 0
	Private nBasIpi		:= 0
	Private nTotIPI		:= 0
	Private nTotSIm		:= 0
	Private nBasICM		:= 0
	Private nTotICMS	:= 0
	Private nTotal		:= 0

	Private nItPed		:= 0
	Private nTotBasIcm	:= 0	

	//Posiciona Cond. Pagto.
	DbSelectArea("SE4")
	SE4->( DbSetOrder(1) )
	SE4->( DbSeek( xFilial("SE4") + SC5->C5_CONDPAG ) )
		
	//Posiciona Cliente
	DbSelectarea("SA1")
	SA1->( DbSetorder(1) )
	SA1->( DbSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI) )
	
	//Salva Funcao Fiscal atual
	nSavNF	:= MaFisSave()

	//Posiciona Itens
	DbSelectarea("SC6")
	SC6->( DbSetorder(1) )
	SC6->( DbSeek(xFilial("SC6") + cNumAten) )
	While !SC6->( Eof() ) .And. 	SC6->C6_FILIAL == xFilial("SC6") .And.;
									SC6->C6_NUM == cNumAten
		nQtdItem ++
		
		SC6->( DbSkip() )
	End
	
	If nDespesa > 0
		nDesItem := nDespesa / nQtdItem
	EndIf

	//Posiciona Itens
	DbSelectarea("SC6")
	SC6->( DbSetorder(1) )
	SC6->( DbSeek(xFilial("SC6") + cNumAten) )
	While !SC6->( Eof() ) .And. 	SC6->C6_FILIAL == xFilial("SC6") .And.;
									SC6->C6_NUM == cNumAten

		nValRet	:= 0
		nValIpi	:= 0
		nAliICM := 0
		nValICM	:= 0
		nItPed 	++
		
		DbSelectarea("SB1")
		SB1->( DbSetorder(1) )
		SB1->( DbSeek(xFilial("SB1") + SC6->C6_PRODUTO) )

		DbSelectarea("SB5")
		SB5->( DbSetorder(1) )
		SB5->( DbSeek(xFilial("SB5") + SC6->C6_PRODUTO) )

		//Finaliza Funcao fiscal
		MaFisEnd()

		//Inicia Funcao Fiscal
		MaFisIni(	SA1->A1_COD			,;	// 01 - Codigo Cliente
					SA1->A1_LOJA		,;	// 02 - Loja do Cliente
					"C"					,;	// 03 - C:Cliente , F:Fornecedor
					"N"					,;	// 04 - Tipo da NF
					SA1->A1_TIPO		,;	// 05 - Tipo do Cliente
					Nil					,;	// 06 - Relacao de Impostos que suportados no arquivo
					Nil					,;	// 07 - Tipo de complemento
					Nil					,;	// 08 - Permite Incluir Impostos no Rodape .T./.F.
					"SB1"				,;	// 09 - Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
					"MATA410"			,;	// 10 - Nome da rotina que esta utilizando a funcao
					Nil					,;	// 11 - Tipo de documento
					Nil					,;	// 12 - Especie do documento
					Nil					,;	// 13 - Codigo e Loja do Prospect
					Nil					,;	// 14 - Grupo Cliente
					Nil					,;	// 15 - Recolhe ISS
					Nil					,;	// 16 - Codigo do cliente de entrega na nota fiscal de saida
					Nil					,;	// 17 - Loja do cliente de entrega na nota fiscal de saida
					Nil					)	// 18 - Informacoes do transportador [01]-UF,[02]-TPTRANS

		//Adiciona o Produto para Calculo dos Impostos
		MaFisAdd(	SB1->B1_COD			,;  // 01 - Codigo do Produto ( Obrigatorio )
					SC6->C6_TES			,;	// 02 - Codigo do TES ( Opcional )
					SC6->C6_QTDVEN		,;	// 03 - Quantidade ( Obrigatorio )
					SC6->C6_PRCVEN		,; 	// 04 - Preco Unitario ( Obrigatorio )
					0					,;  // 05 - Valor do Desconto ( Opcional )
					""					,;	// 06 - Numero da NF Original ( Devolucao/Benef )
					""					,;	// 07 - Serie da NF Original ( Devolucao/Benef )
					0					,;	// 08 - RecNo da NF Original no arq SD1/SD2
					0					,;	// 09 - Valor do Frete do Item ( Opcional )
					nDesItem			,;	// 10 - Valor da Despesa do item ( Opcional )
					0					,;	// 11 - Valor do Seguro do item ( Opcional )
					0					,;	// 12 - Valor do Frete Autonomo ( Opcional )
					SC6->C6_VALOR		,;	// 13 - Valor da Mercadoria ( Obrigatorio )
					0					,;	// 14 - Valor da Embalagem ( Opiconal )
					NIL					,;	// 15 - RecNo do SB1
					NIL					,;	// 16 - RecNo do SF4
					NIL					)

		aImpostos := MafisRet(NIL, "NF_IMPOSTOS")

		If Len(aImpostos) > 0

			nPosRet		:= Ascan( aImpostos, { |x| AllTrim(x[01]) == "ICR" } )
			nPosIPI		:= Ascan( aImpostos, { |x| AllTrim(x[01]) == "IPI" } )
			nPosICM		:= Ascan( aImpostos, { |x| AllTrim(x[01]) == "ICM" } )

			If nPosRet > 0
				If !Empty(aSolid)
					nBasRet += NoRound(aSolid[1],2)
					nValRet	:= NoRound(aSolid[2],2)
				Else
					nBasRet += aImpostos[nPosRet][03]
					nValRet	:= aImpostos[nPosRet][05]
				EndIf
			EndIf

			If nPosIPI > 0
				nBasIpi	:= aImpostos[nPosIPI][03]
				nValIpi	:= aImpostos[nPosIPI][05]
			EndIf

			If nPosICM > 0
				nBasICM := aImpostos[nPosICM][03]
				nValICM	:= aImpostos[nPosICM][05]
				nAliICM := aImpostos[nPosICM][04]
			EndIf

		EndIf
		
		//Armazena Totais
		nBaseCal	+= SC6->C6_VALOR + nValRet + nValIpi
		nTotST		+= nValRet
		nTotIPI		+= nValIpi
		nTotSIm		+= SC6->C6_VALOR
		nTotICMS	+= nValICM
		nTotBasIcm	+= nBasICM
		nTotal		:= nBaseCal
		
		//Armazena dados para impressao
		Aadd( aImprime,	{;
						SC6->C6_ITEM,;
						Transform( SC6->C6_QTDVEN, PesqPictQT("C6_QTDVEN") ),;
						SB1->B1_UM,;
						Transform( SB1->B1_POSIPI, "@R 9999.99.99" ) ,;
						SB1->B1_COD,;
						SubStr(SB1->B1_DESC,1,45),;
						Transform( SC6->C6_PRCVEN, "@E 99,999,999.99" ),;
						Transform( SC6->C6_VALOR, "@E 99,999,999.99" ),;
						Transform( nAliICM, "@E 999.99" ),;
						Transform( nValICM, "@E 999,999.99" ),;
						Transform( nValRet, "@E 999,999.99" ),;
						Transform( nValIpi, "@E 999,999.99" ),;
						Transform( SC6->C6_VALOR + nValRet + nValIpi, "@E 999,999.99" ),;
						Transform(SB5->B5_CONVDIP, "@E 999.99" ),;
						SB5->B5_UMDIPI,;
						SB1->B1_ORIGEM;
						})
						
		SC6->( DbSkip() )
	End

	//Finaliza Funcao fiscal
	MaFisEnd()

	//Restaura Funcao Fiscal
	MaFisRestore( nSavNF )

	//Verifica numero de paginas
	For nP := 1 To Len( aImprime )
		
		nConPag ++
		
		If nPags == 1
			If nConPag >= 29
				nConPag	:= 0
				nPags 	++
			EndIf
		Else
			If nConPag >= 45
				nConPag	:= 0
				nPags 	++
			EndIf
		EndIf
	
	Next nP
	
	//Caso seja uma pagina e mais de 20 itens, aumenta uma pagina para o resumo.
	If nPags == 1 .And. Len( aImprime ) > 20
		nPags ++
	//Caso seja mais de uma pagina e os itens forem maior de 36, aumenta uma para o resumo
	ElseIf nPags > 1 .And. nConPag > 36
		nPags ++
	EndIf

	For nX := 1 To Len( aImprime )
	
		If nLinha > nMaxLin
			ImpCabec( oPrinter, nPags, aImprime )
		EndIf
		
		oPrinter:Say( nLinha,COLUINI+0010,aImprime[ nX ][ 01 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0025,aImprime[ nX ][ 02 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0070,aImprime[ nX ][ 03 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0097,aImprime[ nX ][ 04 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0132,aImprime[ nX ][ 05 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0205,aImprime[ nX ][ 06 ]	,oFont06 )

		a := 0457
		b := 0490
		c := 0530

		oPrinter:Say( nLinha,COLUINI+a,aImprime[ nX ][ 16 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+b,aImprime[ nX ][ 14 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+c,aImprime[ nX ][ 15 ]	,oFont06 )

		oPrinter:Say( nLinha,COLUINI+0560,aImprime[ nX ][ 07 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0610,aImprime[ nX ][ 08 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0660,aImprime[ nX ][ 09 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0700,aImprime[ nX ][ 10 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0740,aImprime[ nX ][ 11 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0780,aImprime[ nX ][ 12 ]	,oFont06 )
		oPrinter:Say( nLinha,COLUINI+0830,aImprime[ nX ][ 13 ]	,oFont06 )

		//Linha divisoria
		If nX <> Len( aImprime )
			nLinha := nLinha + 05
			oPrinter:Line(nLinha,COLUINI,nLinha,MAXCOLU)
			nLinha := nLinha + 06
		EndIf

	Next nX
	
	If !lImpImp
		ImpCabec( oPrinter, nPags, aImprime )
	EndIf
	
	oPrinter:Print()

    RestArea( aAreaATU )
    RestArea( aAreaSC5 )
    RestArea( aAreaSC6 )
    RestArea( aAreaSB1 )

Return Nil

/*==========================================================================
 Funcao...........:	ImpCabec
 Descricao........:	Impressao do Cabecalho
==========================================================================*/
Static Function ImpCabec( oPrinter, nPags, aImprime )
	Local cMensa01	:= SuperGetMV("BR_ORCMEN1", Nil, "")
	Local cMensa02	:= SuperGetMV("BR_ORCMEN2", Nil, "")
	Local cMensa03	:= SuperGetMV("BR_ORCMEN3", Nil, "")
	Local cMensa04	:= SuperGetMV("BR_ORCMEN4", Nil, "")
	Local oBrushA  	:= TBrush():New( , CLR_BLUE )	
	Local cObserva	:= ""
	Local aObserva	:= {}
	Local nLinObs	:= 0	
	Local nX
	
	nPagina ++
	
	If nPagina == 1
		oPrinter:Startpage()
	Else
		oPrinter:Endpage()
		oPrinter:Startpage()
	EndIf
	
	//Box Superior
	oPrinter:Box(0005,COLUINI,0085,MAXCOLU)
	
	//Dados da Empresa
	oPrinter:Say(0020,COLUINI+0180,SM0->M0_NOMECOM																			         																					,oFont14)
	oPrinter:Say(0035,COLUINI+0180,Alltrim(SM0->M0_ENDCOB) + " - " + Alltrim( SM0->M0_BAIRENT ) + " - " + Alltrim( SM0->M0_CIDCOB ) + " / " + SM0->M0_ESTCOB + STR006 + Transform(SM0->M0_CEPCOB , " @R 99999-999" )	,oFont10) //" - CEP: "
	oPrinter:Say(0050,COLUINI+0180,"CNPJ: " + Transform(SM0->M0_CGC , "@R 99.999.999/9999-99") + " INSCR. ESTADUAL: " + SM0->M0_INSC 																					,oFont10)
	oPrinter:Say(0065,COLUINI+0180,STR007 + Alltrim(SM0->M0_TEL) + STR008 + SM0->M0_FAX                                        																							,oFont10) //"FONE: "#" - FAX: "
	oPrinter:Say(0078,COLUINI+0180,STR009                                                                               																								,oFont08) //"www..com.br"

	//Data de emissao
	oPrinter:Say(0065,COLUINI+0765,STR010 + Dtoc(dEmissao)							,oFont10) //"Emissão: "

	//Orcamento
	oPrinter:Say(0080,COLUINI+0660,cDescOrc 										,oFont14)
	oPrinter:Say(0080,COLUINI+0810,cNumAten											,oFont14)
		
	If nPagina == 1

		nLinha	:= 195
		
		//Box Dados do Cliente
		oPrinter:Box(0090,COLUINI,0180,MAXCOLU)

		//Dados do cliente
		oPrinter:Say(0105,COLUINI+0010,STR011 + SA1->A1_NOME						,oFont08) //"CLIENTE: "
		oPrinter:Say(0115,COLUINI+0010,STR012 + SA1->A1_END							,oFont08) //"ENDEREÇO: "
		oPrinter:Say(0125,COLUINI+0010,STR013 + SA1->A1_MUN 						,oFont08) //"CIDADE: "
		oPrinter:Say(0135,COLUINI+0010,STR014 + SA1->A1_CGC							,oFont08) //"CNPJ / CPF: "
		oPrinter:Say(0145,COLUINI+0010,STR015 + SA1->A1_INSCR						,oFont08) //"I.E.: "
		oPrinter:Say(0105,COLUINI+0300,STR016 + SA1->A1_COD + " - " + SA1->A1_LOJA	,oFont08) //"CÓDIGO: "
		oPrinter:Say(0115,COLUINI+0300,STR017 + SA1->A1_BAIRRO						,oFont08) //"BAIRRO: "
		oPrinter:Say(0125,COLUINI+0300,STR018 + SA1->A1_EST		 					,oFont08) //"UF: "
		oPrinter:Say(0135,COLUINI+0300,STR019 + SA1->A1_DDD + ")" + SA1->A1_TEL		,oFont08) //"FONE: ("
		oPrinter:Say(0145,COLUINI+0300,STR020 										,oFont08) //"CONTATO: "
		oPrinter:Say(0115,COLUINI+0600,STR021 + SA1->A1_CEP							,oFont08) //"CEP: "
		oPrinter:Say(0135,COLUINI+0600,STR022 + SA1->A1_EMAIL						,oFont08) //"E-MAIL: "

		oPrinter:Line(0153,COLUINI,0153,MAXCOLU)

		If !Empty( cVendedor )
			
			DbSelectarea("SA3")
			SA3->( DbSetorder(1) )
			SA3->( DbSeek(xFilial("SA3") + cVendedor) )

			oPrinter:Say(0165,COLUINI+0010,STR023	+ SA3->A3_NREDUZ	,oFont08) //"VENDEDOR: "
			oPrinter:Say(0165,COLUINI+0300,STR007 + SA3->A3_TEL			,oFont08) //"FONE: "
			oPrinter:Say(0165,COLUINI+0500,STR024 + SA3->A3_CEL			,oFont08) //"CEL.: "
			oPrinter:Say(0165,COLUINI+0660,STR022 + SA3->A3_EMAIL		,oFont08) //"E-MAIL: "

		EndIf
 
		//Box dos produtos
		oPrinter:Box(0175,COLUINI,0508,MAXCOLU)

		//Box Observação
		nLinObs		:= 532
		 
		oPrinter:Box(0510,COLUINI,0550,MAXCOLU)
		oPrinter:Say(0520,COLUINI+0010, STR025 					,oFont10) //"OBSERVAÇÃO: "

		If Len( Alltrim(cObserva) ) < 130
			oPrinter:Say(nLinObs,COLUINI+0010, cObserva			,oFont10)
		Else
			aObserva := GeraDes(cObserva, 130)
			For nX := 1 To Len(aObserva)
				If nX >= 3
					Exit
				EndIf
				oPrinter:Say(nLinObs,COLUINI+0010, aObserva[nX]	,oFont10)
				nLinObs	:= nLinObs + 10
			Next nX
		EndIf
		
		//Box das Observacoes
		oPrinter:Box(0555,COLUINI,0605,MAXCOLU)
		oPrinter:Say(0565,COLUINI+0350,STR026																																							,oFont10) //"INFORMAÇÕES IMPORTANTES"
		oPrinter:Say(0575,COLUINI+0010,cMensa01	,oFont06)
		oPrinter:Say(0583,COLUINI+0010,cMensa02	,oFont06)
		oPrinter:Say(0591,COLUINI+0010,cMensa03	,oFont06)
        oPrinter:Say(0599,COLUINI+0010,cMensa04	,oFont06)
	Else

		nLinha	:= 115
		nMaxLin	:= 600
		
		//Box dos produtos
		oPrinter:Box(0090,COLUINI,0605,MAXCOLU)

	EndIf
	
	nLinImpo := 605
	
	//Impostos na Ultima pagina
	If nPags == nPagina .Or. (nPags == 1 .And. Len(aImprime) <= 20 ) 
		
		lImpImp	:= .T.
		
		If nPags == 1
			nLinImpo	:= 408
		Else
			nLinImpo	:= 508
		EndIf
		 
		oPrinter:Box(nLinImpo+0002,COLUINI,IIF( nPags == 1, nLinImpo+0100, nLinImpo+0097 ),MAXCOLU)
		oPrinter:FillRect( {nLinImpo+0002,COLUINI,nLinImpo+0012,MAXCOLU}	, oBrushA )
		oPrinter:Say( nLinImpo+0010,COLUINI+0350,STR027		,oFont10, ,CLR_WHITE ) //"CONDIÇÕES / IMPOSTOS / TOTAL"
		
		oPrinter:Say(nLinImpo+0025,COLUINI+0040,STR028 + Alltrim(Transform( nTotBasIcm , "@E 999,999,999.99" ))			,oFont10) //"BASE DE CALCULO ICMS: R$ "
		oPrinter:Say(nLinImpo+0025,COLUINI+0345,STR029 + Alltrim(Transform( nTotICMS , "@E 999,999,999.99" ))			,oFont10) //"VALOR DO ICMS: R$ "
		oPrinter:Say(nLinImpo+0025,COLUINI+0630,STR030									  								,oFont12) //"SUB-TOTAL PRODUTOS: "
		oPrinter:Say(nLinImpo+0025,COLUINI+0760,STR031 + Alltrim(Transform( nTotSIm , "@E 999,999,999.99" ))			,oFont12) //"R$ "

		oPrinter:Say(nLinImpo+0040,COLUINI+0040,STR032 + Alltrim(Transform( nBasRet , "@E 999,999,999.99" ))			,oFont10) //"BASE ICMS SUB. TRIB: R$ "
		oPrinter:Say(nLinImpo+0040,COLUINI+0345,STR033 + Alltrim(Transform( nTotST, "@E 999,999,999.99" ))				,oFont10) //"VALOR DO ICMS ST: R$ "
		oPrinter:Say(nLinImpo+0040,COLUINI+0630,STR034																	,oFont12) //"DESPESAS: "
		oPrinter:Say(nLinImpo+0040,COLUINI+0760,STR031 + Alltrim(Transform( nDespesa, "@E 999,999,999.99" ))			,oFont12) //"R$ "

		oPrinter:Say(nLinImpo+0055,COLUINI+0040,STR035 + Alltrim(Transform( nBasIpi, "@E 999,999,999.99" ))				,oFont10) //"BASE IPI: R$ "
		oPrinter:Say(nLinImpo+0055,COLUINI+0345,STR036 + Alltrim(Transform( nTotIPI, "@E 999,999,999.99" ))				,oFont10) //"VALOR IPI: R$ "
		oPrinter:Say(nLinImpo+0055,COLUINI+0630,STR037																	,oFont12) //"FRETE: "
		oPrinter:Say(nLinImpo+0055,COLUINI+0760,STR031 + Alltrim(Transform( nFrete, "@E 999,999,999.99" ))				,oFont12) //"R$ "

		oPrinter:Say(nLinImpo+0070,COLUINI+0040,STR038 + cTpFrete														,oFont10) //"TIPO DE FRETE: "
		oPrinter:Say(nLinImpo+0070,COLUINI+0345,STR039 + Alltrim(Transform( nFrete, "@E 999,999,999.99" ))				,oFont10) //"VALOR DE FRETE: R$ "
		oPrinter:Say(nLinImpo+0070,COLUINI+0630,STR040 																	,oFont12) //"IMPOSTOS: "
		oPrinter:Say(nLinImpo+0070,COLUINI+0760,STR031 + Alltrim(Transform(nTotST + nTotIPI, "@E 999,999,999.99"))		,oFont12) //"R$ "

		oPrinter:Say(nLinImpo+0085,COLUINI+0040,STR041 + SE4->E4_FORMA													,oFont10) //"FORMA DE PAGTO: "
		oPrinter:Say(nLinImpo+0085,COLUINI+0345,STR042 + SE4->E4_DESCRI													,oFont10) //"CONDIÇÃO. DE PAGTO: "
		
	EndIf
	
	nTotal += nFrete + nDespesa
	oPrinter:Say(nLinImpo+0085,COLUINI+0630,STR043																		,oFont12 ) //"VALOR TOTAL: "
	oPrinter:Say(nLinImpo+0085,COLUINI+0760,STR031 + Alltrim(Transform( nTotal , "@E 999,999,999.99" ))					,oFont12 ) //"R$ "

	//Data e hora da impressao
	oPrinter:Say(0612,COLUINI+0002,STR044	+ DtoC( Date() )+ " / " + SubStr( Time(),1,5 )								,oFont06 ) //"Data / Hora de Impressão: "
	
	//Nro da Pagina
	oPrinter:Say(0612,MAXCOLU-0043,STR045 + Alltrim( Str(nPagina) ) + " de " + Alltrim( Str(nPags) )					,oFont06 ) //"Pagina: "


	oPrinter:FillRect( {IIF(nPagina == 1, 0175, 0095),COLUINI+0000,IIF(nPagina == 1, 0185, 0105),MAXCOLU}				, oBrushA )

	//Cabecalho dos Itens
	oPrinter:Say( IIF(nPagina == 1, 0183, 0103),COLUINI+0003,STR046					,oFont10, ,CLR_WHITE )		 //"ITEM"
	oPrinter:Say( IIF(nPagina == 1, 0183, 0103),COLUINI+0030,STR047					,oFont10, ,CLR_WHITE )		 //"QUANT."
	oPrinter:Say( IIF(nPagina == 1, 0183, 0103),COLUINI+0070,STR048					,oFont10, ,CLR_WHITE )		 //"UN."
	oPrinter:Say( IIF(nPagina == 1, 0183, 0103),COLUINI+0100,"NCM"					,oFont10, ,CLR_WHITE )
	
	oPrinter:FillRect( {IIF(nPagina == 1, 0175, 0095),COLUINI+0140,IIF(nPagina == 1, 0185, 0105),COLUINI+0200}	, oBrushA )
	oPrinter:Say( IIF(nPagina == 1, 0183, 0103),COLUINI+0145,STR049					,oFont10, ,CLR_WHITE ) //"CODIGO"

	oPrinter:Say( IIF(nPagina == 1, 0183, 0103),COLUINI+0205,STR050	,oFont10, ,CLR_WHITE )		 //"DESCRIÇÃO DO PRODUTO"
	
	a := 0450
	b := 0480
	c := 0520

	oPrinter:Say( IIF(nPagina == 1, 0183, 0103),COLUINI+a,STR051				,oFont10, ,CLR_WHITE )		 //"ORIG"
	oPrinter:Say( IIF(nPagina == 1, 0183, 0103),COLUINI+b,STR052				,oFont10, ,CLR_WHITE )		 //"FTCONV"
	oPrinter:Say( IIF(nPagina == 1, 0183, 0103),COLUINI+c,STR053				,oFont10, ,CLR_WHITE )		 //"UTRIB"
	oPrinter:Say( IIF(nPagina == 1, 0183, 0103),COLUINI+0560,STR054				,oFont10, ,CLR_WHITE )		 //"PREÇO"
	oPrinter:Say( IIF(nPagina == 1, 0183, 0103),COLUINI+0610,STR055				,oFont10, ,CLR_WHITE )		 //"TOTAL"
	oPrinter:Say( IIF(nPagina == 1, 0183, 0103),COLUINI+0660,STR056				,oFont10, ,CLR_WHITE ) //"ICMS"
	oPrinter:Say( IIF(nPagina == 1, 0183, 0103),COLUINI+0695,STR057				,oFont10, ,CLR_WHITE ) //"V.ICMS"
	oPrinter:Say( IIF(nPagina == 1, 0183, 0103),COLUINI+0740,STR058				,oFont10, ,CLR_WHITE )		 //"V.ST"
	oPrinter:Say( IIF(nPagina == 1, 0183, 0103),COLUINI+0780,STR059				,oFont10, ,CLR_WHITE )		 //"V.IPI"
	oPrinter:Say( IIF(nPagina == 1, 0183, 0103),COLUINI+0820,STR060				,oFont10, ,CLR_WHITE )		 //"V.GERAL"

	//Grade dos produtos
	oPrinter:Line( IIF(nPagina == 1, 0175, 0105), COLUINI+0025, IIF(nPagina == 1 .And. Len(aImprime) > 20, 0508, nLinImpo), COLUINI+0025 )
	oPrinter:Line( IIF(nPagina == 1, 0175, 0105), COLUINI+0065, IIF(nPagina == 1 .And. Len(aImprime) > 20, 0508, nLinImpo), COLUINI+0065 )
	oPrinter:Line( IIF(nPagina == 1, 0175, 0105), COLUINI+0090, IIF(nPagina == 1 .And. Len(aImprime) > 20, 0508, nLinImpo), COLUINI+0090 )
	oPrinter:Line( IIF(nPagina == 1, 0175, 0105), COLUINI+0130, IIF(nPagina == 1 .And. Len(aImprime) > 20, 0508, nLinImpo), COLUINI+0130 )
	oPrinter:Line( IIF(nPagina == 1, 0175, 0105), COLUINI+0200, IIF(nPagina == 1 .And. Len(aImprime) > 20, 0508, nLinImpo), COLUINI+0200 )

	a:= 0445
	b:= 0477
	c:= 0517

	oPrinter:Line( IIF(nPagina == 1, 0175, 0105), COLUINI+a, IIF(nPagina == 1 .And. Len(aImprime) > 20, 0508, nLinImpo), COLUINI+a )
	oPrinter:Line( IIF(nPagina == 1, 0175, 0105), COLUINI+b, IIF(nPagina == 1 .And. Len(aImprime) > 20, 0508, nLinImpo), COLUINI+b )
	oPrinter:Line( IIF(nPagina == 1, 0175, 0105), COLUINI+c, IIF(nPagina == 1 .And. Len(aImprime) > 20, 0508, nLinImpo), COLUINI+c )

	oPrinter:Line( IIF(nPagina == 1, 0175, 0105), COLUINI+0550, IIF(nPagina == 1 .And. Len(aImprime) > 20, 0508, nLinImpo), COLUINI+0550 )
	oPrinter:Line( IIF(nPagina == 1, 0175, 0105), COLUINI+0600, IIF(nPagina == 1 .And. Len(aImprime) > 20, 0508, nLinImpo), COLUINI+0600 )
	oPrinter:Line( IIF(nPagina == 1, 0175, 0105), COLUINI+0650, IIF(nPagina == 1 .And. Len(aImprime) > 20, 0508, nLinImpo), COLUINI+0650 )
	oPrinter:Line( IIF(nPagina == 1, 0175, 0105), COLUINI+0690, IIF(nPagina == 1 .And. Len(aImprime) > 20, 0508, nLinImpo), COLUINI+0690 )
	oPrinter:Line( IIF(nPagina == 1, 0175, 0105), COLUINI+0730, IIF(nPagina == 1 .And. Len(aImprime) > 20, 0508, nLinImpo), COLUINI+0730 )
	oPrinter:Line( IIF(nPagina == 1, 0175, 0105), COLUINI+0770, IIF(nPagina == 1 .And. Len(aImprime) > 20, 0508, nLinImpo), COLUINI+0770 )
	oPrinter:Line( IIF(nPagina == 1, 0175, 0105), COLUINI+0810, IIF(nPagina == 1 .And. Len(aImprime) > 20, 0508, nLinImpo), COLUINI+0810 )

Return Nil

/*==========================================================================
 Funcao...........:	GeraDes
 Descricao........:	Gera Descricao de Observacao
==========================================================================*/
Static Function GeraDes(cString, nTam)
	Local cAux			:= Alltrim(cString)
	Local aRetorno	:= {}
	Local cTexto		:= ""
	Local nQuebra		:= 0
  	Local nEnter		:= 0
		
	While !Empty(cAux)
		
		nEnter  := AT( CHR(13)+CHR(10) , cAux)
		nQuebra := nTam
		cTexto	 := ""
		
		If nEnter > 0
			If nEnter > nTam
				cTexto := SubStr(cAux,1,nTam)
			Else
				nQuebra := nEnter
				cTexto	 := SubStr(cAux,1,nEnter)
			EndIf 
		Else
			cTexto := SubStr(cAux,1,nTam)
		EndIf
		
		//Adiciona no Retorno
		cTexto := StrTran(cTexto, CHR(13), "")
		cTexto := StrTran(cTexto, CHR(10), "")		

		Aadd(aRetorno, cTexto)
		
		cAux := SubStr(cAux, nQuebra + 1)
	
	End
	
Return aRetorno

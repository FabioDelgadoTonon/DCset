#INCLUDE 'TBICONN.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} MTA094RO
	Descrição: Ponto de entrada para incluir menu customizado na MATA094
@param 
@author: Flavio (BRB)
@since: 26/07/2023 
@version: P12
@return: 
@type: User function
/*/
User Function MTA094RO()
    Local aRet := PARAMIXB[1]

    AADD(aRet, {"Aprovar em Lote"     , "U_ZMT094ALt"  	         , 0 , 4, 0,NIL})		
    AADD(aRet, {"Documentos Pedido"     , "U_ZMT094Doc"  	         , 0 , 4, 0,NIL})		

Return(aRet)

/*/{Protheus.doc} ZMT094Doc
	Descrição: Visualizar documento anexas no Banco de Conhecimento da SC7
@param 
@author: Flavio (BRB)
@since: 26/07/2023 
@version: P12
@return: 
@type: User function
/*/
User Function ZMT094Doc()
    Local aArea := GetArea()
    Local aAreaSC7 := SC7->(GetArea())

    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))
    SC7->(DbSeek(xFilial("SC7")+Padr(AllTrim(SCR->CR_NUM),TamSx3("C7_NUM")[1])))

    MsDocument("SC7",SC7->(RecNo()),2)
    //cAlias,nReg,nOpcX
    RestArea(aAreaSC7)
    RestArea(aArea)
Return


User Function ZMT094ALt()

    If .T. //MsgYesNo("Confirma a Aprovação de documentos em Lote?")
        zMT094Tel()
    EndIf

Return

/*/{Protheus.doc} zMT094Tel
	Descrição: Tela principal da liberação em lote
@param 
@author: Flavio (BRB)
@since: 26/07/2023 
@version: P12
@return: 
@type: Static function
/*/
Static Function zMT094Tel()
    Local aArea    := GetArea()
    Local aAreaSCR := SCR->(GetArea())
    Local aHeader  := zGetCab()
    Local aCols    := {}
    Local oDlgALt  := Nil 
    Local aIt      := {}
    Local nX       := 0
    Local nY       := 0
    Local aAlterCpo  := {}
    Local aFieldFill := {} 
    Local oFont1     := Nil
    Local lProc      := .F.

    Local cNomeApr   := ""
    Local nLimite    := 0
    Local cTpAp      := ""
    
    Local aSaldo     := {}
    
    Local nSldAte    := 0
    Local cStatus    := ""
    Local nTotLib    := 0
    Local cCodAprov  := ""

    Local cQuery := ""
 	Local cTrb1  := GetNextAlias() 
    
    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))
    SC7->(DbSeek(xFilial("SC7")+Padr(AllTrim(SCR->CR_NUM),TamSx3("C7_NUM")[1])))

    DbSelectArea("SA2")
    SA2->(DbSetOrder(1))
    SA2->(DbSeek(xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA)))
    
    SAK->(dbSetOrder(1))
    SAK->(MsSeek(xFilial("SAK")+SCR->CR_APROV))

    SAL->(dbSetOrder(3))
    SAL->(MsSeek(xFilial("SAL")+SCR->(CR_GRUPO+CR_APROV)))

    cNomeApr := SAK->AK_NOME
    nLimite  := SAK->AK_LIMITE
    cTpAp    := SAK->AK_TIPO
    
    aSaldo:= MaSalAlc(SCR->CR_APROV,MaAlcDtRef(SCR->CR_APROV,IIF(Empty(SCR->CR_DATALIB),dDataBase,SCR->CR_DATALIB))) //Calcula saldo na data
    
    nSldAte  := aSaldo[1] //Calcula saldo na data com os dados do aprovador
    cStatus := SCR->CR_STATUS
    nTotLib := 0
    cCodAprov := SCR->CR_APROV

    cQuery := "SELECT *, R_E_C_N_O_ RECSCR FROM "+RetSqlName("SCR")+" SCR "
    cQuery += " WHERE CR_FILIAL = '"+xFilial("SCR")+"' AND CR_APROV = '"+cCodAprov+"' "
    cQuery += " AND CR_STATUS = '02' "
    //cQuery += " AND CR_NUM = '000022' "
    cQuery += " AND D_E_L_E_T_ <> '*' "
    cQuery += " ORDER BY CR_NUM"

    cQuery := ChangeQuery(cQuery)               
    
    //Memowrite("C:\Temp\aprov.txt", cQuery)

  	If Select(cTrb1) > 0
		(cTrb1)->(dbCloseArea()) 
		Ferase(cTrb1+GetDBExtension())
		Ferase(cTrb1+OrdBagExt())
	EndIf            

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTrb1,.T.,.T.)

	TcSetField( cTrb1 ,"CR_EMISSAO"	,"D",08,00)

	DbSelectArea(cTrb1)  

    While !(cTrb1)->(Eof())
        If .T. //SCR->CR_STATUS == "02" .And. SCR->CR_APROV == cCodAprov .And. AllTrim(SCR->CR_NUM) == "000001"
            DbSelectArea("DBM")
            DBM->(DbSetOrder(3)) //DBM_FILIAL+DBM_TIPO+DBM_NUM+DBM_GRUPO+DBM_ITGRP+DBM_USAPRO+DBM_USAPOR
            DBM->(DbSeek(xFilial("DBM")+(cTrb1)->(CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV)))

            While !DBM->(Eof()) .And. DBM->(DBM_FILIAL+DBM_TIPO+DBM_NUM+DBM_GRUPO+DBM_ITGRP+DBM_USAPRO) == xFilial("DBM")+(cTrb1)->(CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV)

                DbSelectArea("SC7")
                SC7->(DbSetOrder(1))
                SC7->(DbSeek(xFilial("SC7")+Padr(AllTrim(DBM->DBM_NUM),TamSx3("C7_NUM")[1])+DBM->DBM_ITEM))

                DbSelectArea("SA2")
                SA2->(DbSetOrder(1))
                SA2->(DbSeek(xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA)))

                DbSelectArea("AK5")
                AK5->(DbSetOrder(1))
                AK5->(DbSeek(xFilial("AK5")+Padr(AllTrim(SC7->C7_XCO),TamSx3("AK5_CODIGO")[1])))

                DbSelectArea("CTT")
                CTT->(DbSetOrder(1))
                CTT->(DbSeek(xFilial("CTT")+SC7->C7_CC))
        
                //{"C7_NUM", "CR_EMISSAO","A2_NOME", "C7_QUANT", "CR_TOTAL", "C7_PRODUTO","C7_DESCRI", "C7_CC","CTT_DESC01", "AK5_CODIGO","AK5_DESCRI", "CR_MOEDA","CR_GRUPO","CR_ITGRP"}
                AADD(aIt,{"LBTIK",(cTrb1)->CR_NUM, ;
                    (cTrb1)->CR_EMISSAO, ;
                    SA2->A2_NREDUZ     , ;
                    SC7->C7_QUANT      , ;
                    DBM->DBM_VALOR     , ;
                    SC7->C7_PRODUTO    , ;
                    SC7->C7_DESCRI     , ;
                    SC7->C7_CC         , ;
                    CTT->CTT_DESC01    , ;
                    AK5->AK5_CODIGO    , ;
                    AK5->AK5_DESCRI    , ;
                    (cTrb1)->CR_MOEDA  , ;
                    (cTrb1)->CR_GRUPO  , ;
                    (cTrb1)->CR_ITGRP  , ;
                    SubStr(SC7->C7_OBSM,1,100), ;
                    (cTrb1)->RECSCR})

                nTotLib += DBM->DBM_VALOR

                DBM->(DbSkip())
            EndDo
        EndIf
        (cTrb1)->(DbSkip())
    EndDo
    
    If Select(cTrb1) > 0
		(cTrb1)->(dbCloseArea()) 
		Ferase(cTrb1+GetDBExtension())
		Ferase(cTrb1+OrdBagExt())
	EndIf 

    For nX := 1 To Len(aIt)
	   	aFieldFill := {}           
	 	For nY := 1 To Len(aIt[nX])
			Aadd(aFieldFill, aIt[nX,nY])
		Next nY

		Aadd(aFieldFill, .F.)
			
		Aadd(aCols, aFieldFill)		   
	Next nX

    Define Dialog oDlgALt Title "Aprovação de Documentos em Lote" From 50,10 TO 550,1060 Of oMainWnd Pixel
		
		nW := (oDlgALt:nClientWidth/2)-4
		nH := (oDlgALt:nClientHeight/2)-60
        DEFINE FONT oFont1  NAME "Arial" SIZE 08,14 BOLD 
        @ 05, 05 Say "Aprovador: "+cNomeApr COLOR CLR_BLUE FONT oFont1 of oDlgALt Pixel
        @ 15, 05 Say "Limite: "+TRANSFORM( nLimite, "@E 9,999,999,999,999.99" ) COLOR CLR_BLUE FONT oFont1 of oDlgALt Pixel
        @ 25, 05 Say "Tipo: "+IIf(cTpAp == "D","Diario","Mensal") COLOR CLR_BLUE FONT oFont1 of oDlgALt Pixel
        @ 35, 05 Say "Saldo: "+TRANSFORM( nSldAte, "@E 9,999,999,999,999.99" ) COLOR CLR_BLUE FONT oFont1 of oDlgALt Pixel
        
   
	    oGetBol := MsNewGetDados():New( 055, 005, nH, nW, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+", aAlterCpo,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgALt, aHeader, aCols)
        oGetBol:oBrowse:bLDblClick := {|| IIf(oGetBol:oBrowse:ColPos == 1,zSelLine(@oGetBol),)}
        @ (oDlgALt:nClientHeight/2)-35, 05 Say oSay PROMPT "Total a Liberar: " /*COLOR CLR_BLUE*/ FONT oFont1 of oDlgALt Pixel
        @ (oDlgALt:nClientHeight/2)-35, 85 Say oSay PROMPT TRANSFORM( nTotLib, "@E 9,999,999,999,999.99" ) COLOR CLR_BLUE FONT oFont1 of oDlgALt Pixel
        //+TRANSFORM( nTotLib, "@E 9,999,999,999,999.99" )
        @ (oDlgALt:nClientHeight/2)-25, 05 Say oSay PROMPT "Saldo após Liberar: " /*COLOR CLR_BLUE*/ FONT oFont1 of oDlgALt Pixel
        @ (oDlgALt:nClientHeight/2)-25, 85 Say oSay PROMPT TRANSFORM( nSldAte-nTotLib, "@E 9,999,999,999,999.99" ) COLOR CLR_BLUE FONT oFont1 of oDlgALt Pixel
        
        @ (oDlgALt:nClientHeight/2)-35, nW-50 BUTTON oBtSai PROMPT "Aprovar" ;
            Action(Iif(MsgYesNo("Confirma a Aprovação dos Itens Selecionados?"),lProc := .T.,lProc := .F.),oDlgALt:End(),Nil) SIZE 040, 017 OF oDlgALt PIXEL

        @ (oDlgALt:nClientHeight/2)-35, nW-100 BUTTON oBtSai PROMPT "Documentos" ;
            Action(zViewDoc(@oGetBol)) SIZE 040, 017 OF oDlgALt PIXEL

        @ (oDlgALt:nClientHeight/2)-35, nW-150 BUTTON oBtSai PROMPT "Inv.Seleção" ;
            Action(zSelAll(@oGetBol)) SIZE 040, 017 OF oDlgALt PIXEL

        @ (oDlgALt:nClientHeight/2)-35, nW-200 BUTTON oBtSai PROMPT "Observações" ;
            Action(zViewObs(@oGetBol)) SIZE 040, 017 OF oDlgALt PIXEL
    	
    Activate MsDialog oDlgALt
    If lProc
        Processa({|| zAprovPeds(@oGetBol, cCodAprov)}, 'Aprovando pedidos...', "Aguarde...")
    EndIf

    RestArea(aAreaSCR)
    RestArea(aArea)
Return

Static Function zViewDoc(oGetBol)
    Local aArea := GetArea()
    Local aAreaSC7 := SC7->(GetArea())
    Local nLi      := oGetBol:oBrowse:nAt
    Local nPSCRNum := ASCAN(oGetBol:aHeader,{|x| Upper(AllTrim(x[2])) == "C7_NUM"})
    Local cNumSC7  := PADR(AllTrim(oGetBol:aCols[nLi,nPSCRNum]), TamSX3("C7_NUM")[1])
    
    //MsgAlert(Str(nLi)+"-"+Str(nPSCRNum))

    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))
    If SC7->(DbSeek(xFilial("SC7")+cNumSC7))
        MsDocument("SC7",SC7->(RecNo()),2)
    EndIf
    //cAlias,nReg,nOpcX
    RestArea(aAreaSC7)
    RestArea(aArea)
Return

/*/{Protheus.doc} zAprovPeds
	Descrição: Processamento dos itens selecionados na Tela
@param 
@author: Flavio (BRB)
@since: 26/07/2023 
@version: P12
@return: 
@type: Static function
/*/
Static Function zAprovPeds(oGetBol, cCodAprov)
    Local nX := 0
    Local nPSCRNum := ASCAN(oGetBol:aHeader,{|x| Upper(AllTrim(x[2])) == "C7_NUM"})
    Local nPGrupo  := ASCAN(oGetBol:aHeader,{|x| Upper(AllTrim(x[2])) == "CR_GRUPO"})
    Local nPGrpIt  := ASCAN(oGetBol:aHeader,{|x| Upper(AllTrim(x[2])) == "CR_ITGRP"})
    Local nPGap    := ASCAN(oGetBol:aHeader,{|x| Upper(AllTrim(x[2])) == "GAP"})
    Local aPeds    := {}
    Local nPos     := 0
    Local lOk      := .T.
    Local lRet     := .T.
    
    For nX := 1 To Len(oGetBol:aCols)
        If AllTrim(oGetBol:aCols[nX,1]) == "LBTIK"
            nPos := ASCAN(aPeds,{|x|  x[1]+x[2]+x[3] == oGetBol:aCols[nX, nPSCRNum]+oGetBol:aCols[nX, nPGrupo]+oGetBol:aCols[nX, nPGrpIt]})
            If nPos <= 0
                AADD(aPeds, {oGetBol:aCols[nX, nPSCRNum], oGetBol:aCols[nX, nPGrupo],oGetBol:aCols[nX, nPGrpIt],oGetBol:aCols[nX, nPGap]})
            EndIf
        EndIf
    Next nX
    ProcRegua(Len(aPeds))
    For nX := 1 To Len(aPeds)
        IncProc("Aprovando pedido "+aPeds[nX,1]+"...")
        lOk := zProcAprov(aPeds[nX,1], aPeds[nX,2], aPeds[nX,3], aPeds[nX,4],cCodAprov)
        If !lOk
            lRet := .F.
        EndIf
    Next nX
    If lRet
        MsgInfo("Aprovação concluída com sucesso!")
    Else
        MsgAlert("Ocorreram erros na aprovação!")
    EndIf
Return

Static Function zViewObs(oGetBol)
    Local oDlgPron := Nil
    Local oObsAtu  := Nil
    Local nW       := 0
	Local nH       := 0
	
    Local nBList := 0
	Local nBMemo := 0

    Local cObsAtu := "TESTE"

    Local aArea := GetArea()
    Local aAreaSC7 := SC7->(GetArea())
    Local nLi      := oGetBol:oBrowse:nAt
    Local nPSCRNum := ASCAN(oGetBol:aHeader,{|x| Upper(AllTrim(x[2])) == "C7_NUM"})
    Local cNumSC7  := PADR(AllTrim(oGetBol:aCols[nLi,nPSCRNum]), TamSX3("C7_NUM")[1])
    
    //MsgAlert(Str(nLi)+"-"+Str(nPSCRNum))

    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))
    If SC7->(DbSeek(xFilial("SC7")+cNumSC7))
        
        DEFINE MSDIALOG oDlgPron TITLE "Observações do Pedido : "+SC7->C7_NUM FROM 10,10 TO 400, 610 PIXEL
        
        nW := (oDlgPron:nClientWidth/2)-4
        nH := (oDlgPron:nClientHeight/2)-30

        cObsAtu := SC7->C7_OBSM

        @ 005,005 SAY "Pedido :"+SC7->C7_NUM OF oDlgPron PIXEL SIZE 050,010 
                        
        nBList := nH //(nH/4)*2                  
        nBMemo := nH //(nH/4)-30
        oPanel2 := Nil
        @ 020, 002 MSPANEL oPanel2 SIZE 296, 158 OF oDlgPron COLORS 0, 16777215 RAISED
        @ 000, 000 SAY oSay7 PROMPT "  

        oObsAtu:=tMultiget():New(002,002,{|u|if(Pcount()>0,cObsAtu:=u,cObsAtu)},oPanel2,290,142,,,,,,.T.,,,,,,.F.)
        oObsAtu:lWordWrap:= .T.
        oObsAtu:EnableHScroll( .F. )
        oObsAtu:EnableVScroll( .T. )
        oObsAtu:lReadOnly := .T.
        
        oBtnClo   := TButton():New(nBList+50+nBMemo, nW-50 , "Fechar"  ,oDlgPron,{||oDlgPron:End()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
        
        ACTIVATE MSDIALOG oDlgPron CENTER 
    EndIf
    
    RestArea(aAreaSC7)
    RestArea(aArea)
	
Return

/*/{Protheus.doc} zSelLine
	Descrição: Função responsável pela seleção dos registros na tela de aprovação
@param 
@author: Flavio
@since: 04/01/21 
@version: P12
@return: 
@type: Static function
/*/
Static Function zSelLine(oGetBol)
	Local nPosFlag := ASCAN(oGetBol:aHeader,{|x| Upper(AllTrim(x[2])) == "FLAGMARK"})
	//Local nPosCarg := ASCAN(oGetBol:aHeader,{|x| Upper(AllTrim(x[2])) == "NUMCARGA"})
	Local nLi      := oGetBol:oBrowse:nAt


	If .T.
		If AllTrim(oGetBol:aCols[nLi,nPosFlag]) == "LBTIK"
			oGetBol:aCols[nLi,nPosFlag] := "LBNO"
		Else
			oGetBol:aCols[nLi,nPosFlag] := "LBTIK"
			
		EndIf	                                  
    EndIf                              
	oGetBol:oBrowse:Refresh()
	
Return

Static Function zSelAll(oGetBol) //SelectAll(oGrid,nCol)
	Local nPosFlag := ASCAN(oGetBol:aHeader,{|x| Upper(AllTrim(x[2])) == "FLAGMARK"})
	Local nLi      := 0
	
	For nLi := 1 To Len(oGetBol:aCols)
		If AllTrim(oGetBol:aCols[nLi,nPosFlag]) == "LBTIK"
			oGetBol:aCols[nLi,nPosFlag] := "LBNO"
		Else
			oGetBol:aCols[nLi,nPosFlag] := "LBTIK"
		EndIf	                           
	Next nLi       
    
	oGetBol:oBrowse:Refresh()
Return     

/*/{Protheus.doc} zProcAprov
	Descrição: ExecAuto de aprovação da MATA094
@param 
@author: Flavio (BRB)
@since: 26/07/2023 
@version: P12
@return: 
@type: Static function
/*/
Static Function zProcAprov(cNum, cGrp, cItGrp, nRecSCR,cCodAprov)
    Local oModel094 := Nil      //-- Objeto que receberá o modelo da MATA094
    Local lOk       := .T.      //-- Controle de validação e commit
    Local aErro     := {}  

    Local lRet    := .T.
    Local cNumSCR := PADR(cNum, TamSX3("CR_NUM")[1])
    Local cTp     := "IP"

    DbSelectArea("SCR")
    SCR->(DbSetOrder(3)) //-- CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV
    SCR->(DBGoTo(nRecSCR))
    If SCR->(CR_FILIAL+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV) == xFilial("SCR")+cNumSCR+cGrp+cItGrp+cCodAprov //SCR->(DbSeek(xFilial("SCR")+cTp+cNumSCR+cCodAprov))
        //
        //-- Códigos de operações possíveis:
        //--    "001" // Liberado
        //--    "002" // Estornar
        //--    "003" // Superior
        //--    "004" // Transferir Superior
        //--    "005" // Rejeitado
        //--    "006" // Bloqueio
        //--    "007" // Visualizacao
 
        //-- Seleciona a operação de aprovação de documentos
        A094SetOp('001')
 
        //-- Carrega o modelo de dados e seleciona a operação de aprovação (UPDATE)
        oModel094 := FWLoadModel('MATA094')
        oModel094:SetOperation( MODEL_OPERATION_UPDATE )
        oModel094:Activate()
 
        //-- Valida o formulário
        lOk := oModel094:VldData()
 
        If lOk
            //-- Se validou, grava o formulário
            lOk := oModel094:CommitData()
        EndIf
 
        //-- Avalia erros
        If !lOk
            //-- Busca o Erro do Modelo de Dados
            aErro := oModel094:GetErrorMessage()
                  
            //-- Monta o Texto que será mostrado na tela
            AutoGrLog("Id do formulário de origem:" + ' [' + AllToChar(aErro[01]) + ']')
            AutoGrLog("Id do campo de origem: "     + ' [' + AllToChar(aErro[02]) + ']')
            AutoGrLog("Id do formulário de erro: "  + ' [' + AllToChar(aErro[03]) + ']')
            AutoGrLog("Id do campo de erro: "       + ' [' + AllToChar(aErro[04]) + ']')
            AutoGrLog("Id do erro: "                + ' [' + AllToChar(aErro[05]) + ']')
            AutoGrLog("Mensagem do erro: "          + ' [' + AllToChar(aErro[06]) + ']')
            AutoGrLog("Mensagem da solução:"        + ' [' + AllToChar(aErro[07]) + ']')
            AutoGrLog("Valor atribuído: "           + ' [' + AllToChar(aErro[08]) + ']')
            AutoGrLog("Valor anterior: "            + ' [' + AllToChar(aErro[09]) + ']')
 
            //-- Mostra a mensagem de Erro
            MostraErro()
        EndIf
 
        //-- Desativa o modelo de dados
        oModel094:DeActivate()
 
        //
    Else
        lRet := .F.
    EndIf
Return(lRet)

Static Function zGetCab()
    Local aHeader := {}
    Local aCmpSX3 := {"C7_NUM", "CR_EMISSAO","A2_NOME", "C7_QUANT", "CR_TOTAL", "C7_PRODUTO","C7_DESCRI", "C7_CC","CTT_DESC01", "AK5_CODIGO","AK5_DESCRI", "CR_MOEDA","CR_GRUPO","CR_ITGRP"}
    Local nX      := 0

    Aadd(aHeader, { " " , ;
			  "FLAGMARK"          , ;
			  "@BMP"              , ; 
			  5                   , ;
			  00                  , ;
			  ""			      , ;
    	      "€€€€€€€€€€€€€€ "   , ;
        	  "C"                 , ;
	          "   "               , ;
    	      "R"                 , ;
        	  " "                 , ;
	          " " })
    For nX := 1 To Len(aCmpSX3)
        AADD(aHeader,{ zGetTit(aCmpSX3[nX]) ,;
            GetSx3Cache(aCmpSX3[nX],"X3_CAMPO")    ,;
            GetSx3Cache(aCmpSX3[nX],"X3_PICTURE")  ,;
            GetSx3Cache(aCmpSX3[nX],"X3_TAMANHO")  ,;
            GetSx3Cache(aCmpSX3[nX],"X3_DECIMAL")  ,;
            GetSx3Cache(aCmpSX3[nX],"X3_VALID")    ,;
            GetSx3Cache(aCmpSX3[nX],"X3_USADO")    ,;
            GetSx3Cache(aCmpSX3[nX],"X3_TIPO")     ,;
            GetSx3Cache(aCmpSX3[nX],"X3_ARQUIVO")  ,;
            GetSx3Cache(aCmpSX3[nX],"X3_CONTEXT")  })
    Next nX

    Aadd(aHeader, { "Observação" , ;
			  "C7_OBSM"            	  , ;
			  "@!"                , ; 
			  100                  , ;
			  00                  , ;
			  ""                  , ;
    	      "€€€€€€€€€€€€€€ "   , ;
        	  "C"                 , ;
	          "   "               , ;
    	      "R"                 , ;
        	  " "                 , ;
	          " " })


    Aadd(aHeader, { " " , ;
			  "GAP"            	  , ;
			  "@!"                , ; 
			  10                  , ;
			  00                  , ;
			  ""                  , ;
    	      "€€€€€€€€€€€€€€ "   , ;
        	  "N"                 , ;
	          "   "               , ;
    	      "R"                 , ;
        	  " "                 , ;
	          " " })

Return(aHeader)

Static Function zGetTit(cFieldNm)
    Local cRet := ""

    If AllTrim(cFieldNm) == "A2_NOME"
        cRet := "Fornecedor" 
    ElseIf AllTrim(cFieldNm) == "C7_DESCRI"
        cRet := "Descrição do Produto/Serviço"
    ElseIf AllTrim(cFieldNm) == "CTT_DESC01"
        cRet := "Descrição C.Custo"
    ElseIf AllTrim(cFieldNm) == "AK5_DESCRI"
        cRet := "Descricão Conta Orc."
    ElseIf AllTrim(cFieldNm) == "AK5_CODIGO"
        cRet := "Conta Orç."
    Else
        cRet := AllTrim(GetSx3Cache(cFieldNm,"X3_TITULO"))
    EndIf
Return(cRet)

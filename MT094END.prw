/*======================================================================
 | <xTitulo()> – <CRIAÇÃO DE TÍTULOS PARA PEDIDOS DE DEVOLUÇÃO >
 +----------------------------------------------------------------------
 | Consultoria : FABRITECH
 | Cliente     : DC SET
 | Chamado Nº  : 25682
 | Autor       : FRANCISCO ARAUJO   
 | Data Criação: 08-05-2025         | Versão   : <v1.0.0>
 +----------------------------------------------------------------------
 | OBJETIVO
 |   < Automatizar a geração do título SE2 no MT094END, logo após a 
 |     liberação do Pedido de Compras, para registrar despesas 
 |     com condição RT/DV sem ação manual.>
 +----------------------------------------------------------------------
 | ALTERAÇÕES / HISTÓRICO
 |   Data       | Autor           | Versão | Descrição
 |   ---------- | --------------- | ------ | -------------------------------
 |   <08-05-2025> | <FV>          | 1.0.0  | Criação
 ======================================================================*/
#Include "protheus.ch"
#Include "topconn.ch"

User Function MT094END()
    // PARAMIXB: { cNum , cTipoDoc , nOper , cFilial }
    Local cNum   := PARAMIXB[1]

    If AllTrim(SC7->C7_COND) $ "RT|DV" .AND. SC7->C7_CONAPRO=='L'       // “RT” ou “DV”
        xTitulo()   
    EndIf
Return


Static Function xTitulo()
    //Local cPrefixo   := "XPT"      // default PERGUNTAR PARA CLIENTE                 
    Local cParcela   := "01"
    Local cTpTit     := AllTrim(SC7->C7_COND)      // “RT” ou “DV”
    Local cFor       := SC7->C7_FORNECE
    Local cLoja      := SC7->C7_LOJA
    LOCAL cNum       := SC7->C7_NUM
    LOCAL nQuant     := ''
    Local cNumero    := alltrim(cNum)+cTpTit
    Local dEmissao   := dDataBase  
    Local dVenc      := SC7->C7_DATPRF                
    Local nValor     := 0
    Local cNatfin    := ""                  
    Local aTitulo    := {}
    LOCAL nRec       := SC7->(recno())
    LOCAL cFil       := SC7->C7_FILIAL


    SC7->( DbSetOrder(1) )// FILIAL+NUM

    If SC7->( DbSeek(cFil+cNum) )
        While !SC7->(EoF()) .And. SC7->C7_FILIAL == cFil .And. SC7->C7_NUM == cNum
            nValor += SC7->C7_TOTAL
            nQuant :=SC7->C7_QUANT
            if  Reclock("SC7",.F.)
					SC7->C7_QUJE := nQuant
					//SC7->C7_RESIDUO := 'S'
				SC7->(MsUnlock())
            endif

            SC7->( DbSkip() )
        EndDo
    EndIf

    DbSelectArea("SA2")
    SA2->( DbSetOrder(1) )// FILIAL+COD+LOJA

    If SA2->( DbSeek( xFilial("SA2")+cFor+cLoja ) )
        cNFor   := ALLTRIM(SA2->A2_NREDUZ)
    EndIf



    If cTpTit=='RT'
        cNatfin := SuperGetMv("FS_00001")                  
    else
        cNatfin := SuperGetMv("FS_00002")                   
    EndIf



    aAdd(aTitulo, { "E2_FILIAL" ,  xFilial("SE2") , Nil })
    aAdd(aTitulo, { "E2_PREFIXO",  cTpTit       , Nil })
    aAdd(aTitulo, { "E2_NUM"    ,  cNumero        , Nil })
    aAdd(aTitulo, { "E2_PARCELA",  cParcela       , Nil })
    aAdd(aTitulo, { "E2_TIPO"   ,  cTpTit       , Nil })
    aAdd(aTitulo, { "E2_NATUREZ",  cNatfin        , Nil })
    aAdd(aTitulo, { "E2_FORNECE",  cFor           , Nil })
    aAdd(aTitulo, { "E2_LOJA"   ,  cLoja          , Nil })
    aAdd(aTitulo, { "E2_EMISSAO",  dEmissao       , Nil })
    aAdd(aTitulo, { "E2_DATALIB",  dEmissao       , Nil })
    aAdd(aTitulo, { "E2_VENCTO" ,  dVenc          , Nil })
    aAdd(aTitulo, { "E2_VENCREA",  dVenc          , Nil })
    aAdd(aTitulo, { "E2_VALOR"  ,  nValor         , Nil })
    aAdd(aTitulo, { "E2_HIST"   ,  cTpTit+" -"+cNum+" - "+cNFor, Nil })  
    aAdd(aTitulo, { "E2_MOEDA"  ,  1              , Nil })  

        lMsErroAuto := .F.
        MsExecAuto( {|x,y,z| FINA050(x,y,z)}, aTitulo,, 3 )

        If lMsErroAuto
            MostraErro()
        EndIf
    SC7->(dbGoTo(nRec)) // VOLTA PARA A ORDENAÇÃO ANTERIOR
Return

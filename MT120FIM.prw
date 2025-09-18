#include "Protheus.ch"
#Include "topconn.ch"
#include "parmtype.ch"

//#include "CRDEF001.ch"

/*/{Protheus.doc} User Function MT120FIM
    PE após gravação do Pedido de Compra, envia e-mail para o primeiro aprovador.
    @type  Function
    @author Luis Gustavo 
    @since 15/08/2023

/*/

/*User Function MT120FIM()
	Local lRet 		:= .T.
	Local nOpcao 	:= PARAMIXB[1]
	Local cNumPC 	:= PARAMIXB[2]
	Local nOpcA     := PARAMIXB[3]
	Local cAssunto 	:= ""
	Local cMsgMail 	:= ""
	Local cTo		:= ""
	Local aArea     := GetArea()

	If nOpcA == 1 // INCLUSÃO
		
		/*SCR->(DbSelectArea("SCR"))
		SCR->(DbSetOrder(1)) // CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL
		If SCR->(DbSeek(xfilial("SCR")+'IP'+ca120Num)) 
			While SCR->CR_FILIAL == xFilial("SCR") .and. SCR->CR_TIPO == "IP"  .and. ALLTRIM(SCR->CR_NUM) == ca120num .and. SCR->CR_NIVEL == "1 "
				cAssunto := "Aprovação Pedido de Compra "+ALLTRIM(SCR->CR_FILIAL) + " - " + ALLTRIM(SCR->CR_NUM) + " pendente." 
				cMsgMail := U_MailAprPc( cFilial , cNumPc, .T. )
				cTo		 := UsrRetMail(SCR->CR_USER)
		//		U_SENDMAILX(cTo, cAssunto, cMsgMail)// Envia e-mail aprovador primeiro nivel
				SCR->(DbSkip())
			End
		Endif*/


/*






		
	Endif */

/*	RestArea(aArea)

Return lRet
*/


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


User Function MT120FIM()
    // PARAMIXB: { cNum , cTipoDoc , nOper , cFilial }
    Local cNum 		:= PARAMIXB[2]
	Local nOpcA     := PARAMIXB[3]

    If AllTrim(SC7->C7_COND) $ "RT|DV|CJ"  .AND. nOpcA == 1       // “RT” ou “DV”
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
    LOCAL cIDPF      := SC7->C7_XIDPP
    LOCAL cObs       := SC7->C7_OBS
    LOCAL cCO        := SC7->C7_XCO
    


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
    elseif cTpTit=='DV'
        cNatfin := SuperGetMv("FS_00002")  
    else
        cNatfin := "403004"                        
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
    aAdd(aTitulo, { "E2_XIDPP",  cIDPF         , Nil })
    aAdd(aTitulo, { "E2_XOBS",   cObs          , Nil })
    aAdd(aTitulo, { "E2_XCO",    cCO           , Nil })
    aAdd(aTitulo, { "E2_PEDIDO",    cNum           , Nil })
 



        lMsErroAuto := .F.
        MsExecAuto( {|x,y,z| FINA050(x,y,z)}, aTitulo,, 3 )

        If lMsErroAuto
            MostraErro()
        EndIf
    SC7->(dbGoTo(nRec)) // VOLTA PARA A ORDENAÇÃO ANTERIOR
Return

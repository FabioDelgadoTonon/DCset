#Include "Protheus.ch"
#Include "TOTVS.CH"
#Include "TopConn.ch"
#include 'parmtype.ch'
#Include 'rwmake.ch'
#Include "tbiconn.ch"

#DEFINE ENTER CHR(13)+CHR(10)

/*/{Protheus.doc} User Function MailAprPc
    @Projeto: Monta HTML do Body do e-mail de acordo com perfil ( Aprovador / Fornecedor )
    @type  Function
    @author Luis Gustavo 
    @since 15/08/2023
/*/

User Function MailAprPc( cFil , cNum , lAprov )

    Local cMsgMail  := ""
    Local nTotalPc	:= 0

    DbSelectArea("SC7")
    SC7->(DbSetOrder(1)) // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN 

    If SC7->(DbSeek(xFilial("SC7")+ALLTRIM(cNum)))
        cMsgMail +="<!DOCTYPE html>" + ENTER
        cMsgMail +="<html lang='en'>" + ENTER
        cMsgMail +="<body>" + ENTER
        cMsgMail +="  <div class='email-container'>" + ENTER
        cMsgMail +="    <div class='invoice'>" + ENTER

        If lAprov
            cMsgMail += "   <p>O Pedido de Compras acaba de ser incluído no sistema pelo usuário: " + UsrRetName(SC7->C7_USER) +"</p>" + ENTER  
            cMsgMail += "   <p>Numero: " + SC7->C7_NUM +"</p>" + ENTER  
        Else
            cMsgMail += "   <p>Pedido de Compras Aprovado PO:" + SC7->C7_NUM +"</p>" + ENTER
        Endif
        
        cMsgMail += "   <p>Razão Social: " + Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME") +"</p>" + ENTER 
        cMsgMail += "   <p>Fornecedor: "+ SC7->C7_FORNECE + "  Loja:" + SC7->C7_LOJA +"</p>" + ENTER

        cMsgMail += "<table border='1'>" + ENTER
        cMsgMail += "    <tr>" + ENTER
        cMsgMail += "        <th>Produto</th>" + ENTER
        cMsgMail += "        <th>Total Item</th>" + ENTER
        cMsgMail += "        <th>Centro de Custo</th>" + ENTER
        cMsgMail += "        <th>Conta Orçamento</th>" + ENTER
        cMsgMail += "    </tr>" + ENTER

        WHILE SC7->C7_FILIAL == cFil .and. SC7->C7_NUM == Alltrim(cNum)
            
            cMsgMail += "    <tr>" + ENTER
            cMsgMail += "        <td>" + Alltrim(Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_DESC")) + "</td>" + ENTER
            cMsgMail += "        <td> R$: " + Alltrim(Transform(SC7->C7_TOTAL,'@E 999,999,999,999,999.99')) + "</td>" + ENTER
            cMsgMail += "		 <td>" + Alltrim(SC7->C7_CC) + " - " + Alltrim(Posicione("CTT",1,xFilial("CTT")+SC7->C7_CC,"CTT_DESC01")) + "</td>" + ENTER
            cMsgMail += "		 <td>" + Alltrim(SC7->C7_XCO) + " - " + Alltrim(Posicione("AK5",1,xFilial("AK5")+SC7->C7_XCO,"AK5_DESCRI")) + "</td>" + ENTER
            cMsgMail += "    </tr>" + ENTER

            nTotalPc += SC7->C7_TOTAL
            SC7->(DbSkip())
        End

        cMsgMail += "</table>" + ENTER

        cMsgMail += "   <p>Valor Total: R$ " + ALLTRIM(Transform(nTotalPc,'@E 999,999,999,999,999.99')) +"</p>" + ENTER
        
        If lAprov
            cMsgMail += "   <p>E-Mail automatico enviado pelo modulo SIGACOM. Sr(a) aprovador, entrar na liberação do pedido e validar seus valores. "+"</p>" + ENTER
        else
            cMsgMail += "   <p>E-Mail automatico enviado pelo sistema, verifique anexo para detalhes."+"</p>" + ENTER
            cMsgMail += "   <p>Obs.: Emissão da NF somento conforme instrução do contratante.</p>" + ENTER
        Endif
        
        cMsgMail += "       </div>" + ENTER
        cMsgMail += "   </body>" + ENTER
        cMsgMail += "</html>" + ENTER
    Endif

Return cMsgMail

/*/{Protheus.doc} User Function GeraAnxPo
    @Projeto: Gera anexo enviado para Fornecedor.
    @type  Function
    @author Luis Gustavo 
    @since 15/08/2023
/*/

User Function GeraAnxPo( cFil , cNumPc )

	//Local cPathser  := SuperGetMv("MV_DOTPO",.F.,"\SYSTEM\DOTS\PURCHASEANEXO.DOT")
	Local cPathcli  := "c:\temp\"
	Local cArqdot	:= "purchaseanexo.dot"
	Local cArquivo	:= ""
	Local cCodBanco := ""
	Local cRet		:= ""
	Local hWord		:= 0
	Local nHandWord := 0
    Local nCount    := 0
    Local cService  := ""

	DbSelectArea("SC7")
	SC7->(dBSetOrder(1)) // Filial + Pedido
	If SC7->(DbSeek(cFil+ALLTRIM(cNumPc)))

        If !MsFile(cPathcli+cArqdot)
            __CopyFile("\system\dots\"+cArqdot,cPathcli+cArqdot,,,.F.)
        Endif

		cArquivo := "c:\temp\po"+SC7->C7_FILIAL+SC7->C7_NUM+".doc"

		//Conecta ao word
		hWord	:= OLE_CreateLink()

		OLE_SetPropertie( hWord, "oleWdVisible", .F.) //indica que o word deve estar visive
		OLE_NewFile(hWord, cPathcli+cArqdot )
		OLE_SaveAsFile(hWord,cArquivo) //	-Função que salva o Documento com o nome especificado, com senha e no formato Word.
		
		OLE_SetDocumentVar(hWord,'PURCHASE'		 	,SC7->C7_NUM)
		OLE_SetDocumentVar(hWord,'DATAPURCHASE' 	,SC7->C7_EMISSAO)
		OLE_SetDocumentVar(hWord,'RAZAOSOCIAL'	 	,POSICIONE("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME") )
		OLE_SetDocumentVar(hWord,'CONTATO'		 	,SC7->C7_CONTATO)
		OLE_SetDocumentVar(hWord,'FONE'			 	,Transform(POSICIONE("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_TEL"),'@R 9999-9999'))
		OLE_SetDocumentVar(hWord,'EMAIL'		 	,POSICIONE("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_EMAIL"))
		OLE_SetDocumentVar(hWord,'AREA' 	 		,Alltrim(POSICIONE("CTT",1,xFilial("SC7")+SC7->C7_CC,"CTT_DESC01")))

/*		
        OLE_SetDocumentVar(hWord,'SERVICO'		 	,Alltrim(POSICIONE("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_DESC")))
		OLE_SetDocumentVar(hWord,'VALOR'		 	,Alltrim(Transform(SC7->C7_TOTAL,'@E 999,999,999,999,999.99')))
		OLE_SetDocumentVar(hWord,'FORMAPGTO'	 	,Alltrim(POSICIONE("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_DESCRI")))
*/

        While !SC7->(EOF()) .and. SC7->C7_FILIAL == cFil .and. SC7->C7_NUM == alltrim(cNumPc)
        
            cService += "Serviço: "  +  Alltrim(POSICIONE("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_DESC")) + ENTER
            cService += "Valor: R$ "   +  Alltrim(Transform(SC7->C7_TOTAL,'@E 999,999,999,999,999.99')) + ENTER + ENTER
              
            SC7->(DbSkip())
        End

        SC7->(DbSeek(cFil+ALLTRIM(cNumPc)))

        cService += "Obs: " + SC7->C7_OBSM + ENTER + ENTER

        cService += "Forma de Pagamento: " + Alltrim(POSICIONE("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_DESCRI"))

        OLE_SetDocumentVar(hWord,'SERVICO', cService )
       
//        OLE_SetDocumentVar(hWord,'FORMAPGTO'	 	,Alltrim(POSICIONE("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_DESCRI")))

		cCodBanco := POSICIONE("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_BANCO")

		OLE_SetDocumentVar(hWord,'NOMEBANCO'		,POSICIONE("SA6",1,xfilial("SA6")+cCodBanco,"A6_NOME"))
		OLE_SetDocumentVar(hWord,'NUMEROBANCO'	 	,POSICIONE("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_BANCO"))
		OLE_SetDocumentVar(hWord,'AGENCIABANCO'	 	,POSICIONE("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_AGENCIA"))  
		OLE_SetDocumentVar(hWord,'CONTACC'		 	,POSICIONE("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NUMCON")) 

		OLE_SetDocumentVar(hWord,'NOMEFORNECEDOR'	,POSICIONE("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME"))
		OLE_SetDocumentVar(hWord,'MAILFORNECEDOR' 	,POSICIONE("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_EMAIL"))



       

		//--Atualiza Variaveis
		OLE_UpDateFields(hWord)
		Sleep(2000)
		OLE_SaveFile ( hWord )
		
		OLE_CloseFile( hWord )
		Sleep(1000)
		OLE_CloseLink( hWord )

		// GERA PDF
		nHandWord := OLE_CreateLink()
    	If nHandWord != "-1"
			//Abre o arquivo de Origem
			OLE_SetPropertie(nHandWord, .F.)
			OLE_SetProperty(nHandWord, "oleWdVisible", .F.)
			OLE_OpenFile(nHandWord, cArquivo)
	
			//Gera o PDF do documento
			OLE_SetProperty(nHandWord,'208',.F.)
			OLE_SaveAsFile( nHandWord, "c:\temp\po"+SC7->C7_FILIAL+SC7->C7_NUM+".pdf", , , .F., 17 )
	
			
			OLE_CloseFile(nHandWord)
			Sleep(1000)
			OLE_CloseLink(nHandWord)
		Endif

        If __CopyFile("c:\temp\po"+SC7->C7_FILIAL+SC7->C7_NUM+".pdf", "\system\dots\po"+SC7->C7_FILIAL+SC7->C7_NUM+".pdf",,,.F.)
            cRet:="\system\dots\po"+SC7->C7_FILIAL+SC7->C7_NUM+".pdf"
        Endif

/*
		CpyT2S("C:\TEMP\PO"+SC7->C7_FILIAL+SC7->C7_NUM+".PDF", '\system\dots\' ) 

		If File("\system\dots\PO"+SC7->C7_FILIAL+SC7->C7_NUM+".PDF")
			cRet:="\system\dots\PO"+SC7->C7_FILIAL+SC7->C7_NUM+".PDF"
		Endif
*/
	Endif

Return cRet

/*/{Protheus.doc} User Function SENDMAILX
    @Projeto: Função de envio de e-mail.
    @type  Function
    @author Luis Gustavo 
    @since 15/08/2023
/*/

User Function SENDMAILX(cPara, cAssunto, cCorpo , aAnexos, lMostraLog, lUsaTL)
    Local aArea        := GetArea()
    Local nAtual       := 0
    Local lRet         := .T.
    Local oMsg         := Nil
    Local oSrv         := Nil
    Local nRet         := 0   
    Local cFrom        := Alltrim(GetMV("MV_RELACNT"))
    Local cPass        := Alltrim(GetMV("MV_RELPSW"))
    Local cSrvFull     := Alltrim(GetMV("MV_RELSERV"))
    Local cServer      := Iif(':' $ cSrvFull, SubStr(cSrvFull, 1, At(':', cSrvFull)-1), cSrvFull)
    Local nPort        := Iif(':' $ cSrvFull, Val(SubStr(cSrvFull, At(':', cSrvFull)+1, Len(cSrvFull))), 587)
    Local nTimeOut     := 120 //GetMV("MV_RELTIME")
    Local cLog         := ""
    local lSsl		   := GetNewPar("MV_RELSSL",.T.)

    Default cPara      := ""
    Default cAssunto   := ""
    Default aAnexos    := {}
    Default cCorpo     := ""
	Default lMostraLog := .F.
    Default lUsaTLS    := .F.

    //Se tiver em branco o destinatário, o assunto ou o corpo do email
    If Empty(cPara) .Or. Empty(cAssunto) .Or. Empty(cCorpo)
        cLog += "001 - Destinatario, Assunto ou Corpo do e-Mail vazio(s)!" + CRLF
        lRet := .F.
    EndIf
  
    If lRet
        //Cria a nova mensagem
        oMsg := TMailMessage():New()
        oMsg:Clear()
  
        //Define os atributos da mensagem
        oMsg:cFrom    := cFrom
        oMsg:cTo      := cPara
        oMsg:cSubject := cAssunto
        
        oMsg:cBody    := cCorpo
  
        //Percorre os anexos
        For nAtual := 1 To Len(aAnexos)
            //Se o arquivo existir
            If File(aAnexos[nAtual],,.F.)
  
                //Anexa o arquivo na mensagem de e-Mail
                nRet := oMsg:AttachFile(aAnexos[nAtual])
                If nRet < 0
                    cLog += "002 - Nao foi possivel anexar o arquivo '"+aAnexos[nAtual]+"'!" + CRLF
                EndIf
  
            //Senao, acrescenta no log
            Else
                cLog += "003 - Arquivo '"+aAnexos[nAtual]+"' nao encontrado!" + CRLF
            EndIf
        Next
  
        //Cria servidor para disparo do e-Mail
        oSrv := tMailManager():New()
  
        //Define se irá utilizar o TLS
        If lUsaTLS
            oSrv:SetUseTLS(.T.)
        EndIf

        oSrv:SetUseSSL( lSsl )
  
        //Inicializa conexão
        nRet := oSrv:Init("", cServer, cFrom, cPass, 0, nPort)
        If nRet != 0
            cLog += "004 - Nao foi possivel inicializar o servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
            lRet := .F.
        EndIf
  
        If lRet
            //Define o time out
            nRet := oSrv:SetSMTPTimeout(nTimeOut)
            If nRet != 0
                cLog += "005 - Nao foi possivel definir o TimeOut '"+cValToChar(nTimeOut)+"'" + CRLF
            EndIf
  
            //Conecta no servidor
            nRet := oSrv:SMTPConnect()
            If nRet <> 0
                cLog += "006 - Nao foi possivel conectar no servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
                lRet := .F.
            EndIf
  
            If lRet
                //Realiza a autenticação do usuário e senha
                nRet := oSrv:SmtpAuth(cFrom, cPass)
                If nRet <> 0
                    cLog += "007 - Nao foi possivel autenticar no servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
                    lRet := .F.
                EndIf
  
                If lRet
                    //Envia a mensagem
                    nRet := oMsg:Send(oSrv)
                    If nRet <> 0
                        cLog += "008 - Nao foi possivel enviar a mensagem: " + oSrv:GetErrorString(nRet) + CRLF
                        lRet := .F.
                    EndIf
                EndIf
  
                //Disconecta do servidor
                nRet := oSrv:SMTPDisconnect()
                If nRet <> 0
                    cLog += "009 - Nao foi possivel disconectar do servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
                EndIf
            EndIf
        EndIf
    EndIf
  
    //Se tiver log de avisos/erros
    If !Empty(cLog)
        cLog := "zEnvMail - "+dToC(Date())+ " " + Time() + CRLF + ;
            "Funcao - " + FunName() + CRLF + CRLF +;
            "Existem mensagens de aviso: "+ CRLF +;
            cLog
        ConOut(cLog)
  
        //Se for para mostrar o log visualmente e for processo com interface com o usuário, mostra uma mensagem na tela
        If lMostraLog .And. ! IsBlind()
            Aviso("Log", cLog, {"Ok"}, 2)
        EndIf
    EndIf
	
	For nAtual := 1 To Len(aAnexos)
		cArqPDF := aAnexos[nAtual]

		If File(cArqPDF)
			fErase(cArqPDF)
		EndIf

	Next nAtual
	
    RestArea(aArea)
Return lRet

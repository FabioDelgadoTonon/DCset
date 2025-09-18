#include "TOTVS.CH"

/*/{Protheus.doc} FBNTCR01
Gerador dos Modelos Timbrados de Nota Cr�dito.
Arquivos .docx devem estar na System
@type user function
@author Andre Froes - Fabritech
@since 02/2024
@version 1.0
/*/
User Function FBNTCR01()
	Local aFilial
	Local cArquivo    := ""
    Private cPasta      := ""
	Private aDados      := {}
    Private cDeploy

    if !FWAlertYesNo("Deseja imprimir Nota de Cr�dito do T�tulo selecionado?","Impress�o de Nota de Cr�dito")
        Return
    endif

	aFilial  := FWSM0Util():GetSM0Data()
	cArquivo := SuperGetMV("RE_CRBPTH",.F.,"")

	// Selecionar arquivo a ser impresso
	While Empty(cArquivo) .or. !(FILE(AllTrim(cArquivo)))
		cArquivo := FwInputBox("Layout n�o parametrizado nesta filial. Informe o caminho do arquivo modelo.", cArquivo )

		if Empty(cArquivo)
			if FWAlertYesNo("Deseja sair da rotina?","Impress�o de Nota de Cr�dito")
				Return
			endif
		endif

        if !(FILE(AllTrim(cArquivo)))
            FWAlertError("Arquivo n�o encontrado! Verifique se o caminho informado direciona h� um arquivo v�lido e existente.","Aten��o")
            cArquivo:= ""
        endif
	Enddo

    // Selecionar Pasta Destino
    While Empty(cPasta)
		SelectFolder()

		if Empty(cPasta)
			if FWAlertYesNo("Deseja sair da rotina?","Impress�o de Nota de Cr�dito")
				Return
			endif
		endif

	Enddo
    
    //Executa Processo
	dbselectarea("SE1")
	dbselectarea("SA1")
	dbsetorder(1)
	dbseek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA))

	aadd(aDados,{;
        /* cNomeFil */   AllTrim(aFilial[5][2])      ,;
        /* cCnpjFil */   AllTrim(Transform(aFilial[11][2], PesqPict("SA1","A1_CGC")))         ,;
        /* cEndFil */    AllTrim(aFilial[15][2]) + " - " +  AllTrim(aFilial[17][2]) + " - " + AllTrim(aFilial[18][2]) + " / " + AllTrim(aFilial[19][2]) ,;
        /* cCEPFIL */    AllTrim(Transform(aFilial[20][2], PesqPict("SA1","A1_CEP")))         ,;
        /* cTel */       AllTrim(Transform(aFilial[15][2], PesqPict("SA1","A1_TEL")))         ;
		})

    //Copia Modelo para Maquina Local
    CpyS2T(cArquivo,GetTempPath(),.F.)

    //Armazena Path na estacao
    cDeploy := GetTempPath()+subs(cArquivo,RAt("\",cArquivo)+1)

    //Impressao do documento
    FWMsgRun(, {|oSay| ImprimeDoc(oSay) }, "Processando", "Gerando Nota de Cr�dito")

	//Apaga Modelo da Maquina Local
    FERASE(cDeploy)

    
Return FWAlertSuccess("Nota Gerada com sucesso!","Impress�o de Nota de Cr�dito")

/*/{Protheus.doc} ImprimeDoc
    Bloco de Gera��o de pdf
    @type  Static Function
/*/
Static Function ImprimeDoc(oSay)
	Local nx
    Local lRet := .T.
	Private hWord

	for nx := 1 to len(aDados)
		//Cria um ponteiro e j� chama o arquivo
		hWord := OLE_CreateLink()
        
        //N�o mostrar tela word
        OLE_SetProperty(hWord, '206', .F. )
        OLE_SetProperty(hWord, '208',.F. )

        //Inicia Cria��o
		OLE_NewFile(hWord, cDeploy)



		//Setando o conte�do das DocVariables

		//Emitente
		OLE_SetDocumentVar(hWord, "cNomeFil",  aDados[nx][1]  )
		OLE_SetDocumentVar(hWord, "cCnpjFil",  aDados[nx][2]  )
		OLE_SetDocumentVar(hWord, "cEndFil",   aDados[nx][3]  )
		OLE_SetDocumentVar(hWord, "cCEPFil",   aDados[nx][4]  )
		OLE_SetDocumentVar(hWord, "cTelFil",   aDados[nx][5]  )

		//Fornecedor
		OLE_SetDocumentVar(hWord, "cNomeEmp",  AllTrim(SA1->A1_NOME)  )
		OLE_SetDocumentVar(hWord, "cCnpjEmp",  AllTrim(Transform(SA1->A1_CGC, PesqPict("SA1","A1_CGC")))  )
		OLE_SetDocumentVar(hWord, "cEndEmp",   AllTrim(SA1->A1_END) )
		OLE_SetDocumentVar(hWord, "cBairEmp",  AllTrim(SA1->A1_BAIRRO) )
		OLE_SetDocumentVar(hWord, "cEstEmp",   AllTrim(SA1->A1_EST) )
		OLE_SetDocumentVar(hWord, "cCidEmp",   AllTrim(SA1->A1_MUN) )
		OLE_SetDocumentVar(hWord, "cCEPEmp",   AllTrim(Transform(SA1->A1_CEP, PesqPict("SA1","A1_CEP"))) )
		OLE_SetDocumentVar(hWord, "cTelEmp",   AllTrim(Transform(SA1->A1_TEL, PesqPict("SA1","A1_TEL")))  )
		OLE_SetDocumentVar(hWord, "cInsEmp",   AllTrim(SA1->A1_INSCR) )

		//Historico
		OLE_SetDocumentVar(hWord, "cHist",     AllTrim(SE1->E1_HIST) )
		OLE_SetDocumentVar(hWord, "nValTit",   "R$ "+AllTrim(Transform(SE1->E1_VALOR, PesqPict("SE1","E1_VALOR"))) )

		//Dados Nota Cr�dito
		OLE_SetDocumentVar(hWord, "nTitulo",   AllTrim(SE1->E1_NUM)  )
		OLE_SetDocumentVar(hWord, "dEmissao",  DtoC(SE1->E1_EMISSAO)  )
		OLE_SetDocumentVar(hWord, "dVenc",     DtoC(SE1->E1_VENCTO)  )


		//Atualizando campos e gerando arquivo
		OLE_UpdateFields(hWord)
		OLE_SaveAsFile(hWord, cPasta + "\" + alltrim(SE1->E1_NUM) + "-nota-de-credito.pdf", , , .F., 17 )

		//Fechando o arquivo e o link
		OLE_CloseFile(hWord)
        sleep(1000)
		OLE_CloseLink(hWord)

        //Abrir pdf
        ShellExecute( "open", cPasta + "\" + alltrim(SE1->E1_NUM) + "-nota-de-credito.pdf" , "", "", 1 )
	next

Return lRet


Static Function SelectFolder()
    Local aArea   := GetArea()
    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Sele��o de Pasta para Salvar arquivo(s)"
    Local lSalvar := .F.
 
    //Se n�o estiver sendo executado via job
    If ! IsBlind()
 
        //Chama a fun��o para buscar arquivos
        cPasta := tFileDialog(;
            cTipArq,;                  // Filtragem de tipos de arquivos que ser�o selecionados
            cTitulo,;                  // T�tulo da Janela para sele��o dos arquivos
            ,;                         // Compatibilidade
            cDirIni,;                  // Diret�rio inicial da busca de arquivos
            lSalvar,;                  // Se for .T., ser� uma Save Dialog, sen�o ser� Open Dialog
            GETF_RETDIRECTORY;         // Se n�o passar par�metro, ir� pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT ser� poss�vel pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY ser� poss�vel selecionar o diret�rio
        )
 
    EndIf
 
    RestArea(aArea)
Return 

#include "TOTVS.CH"

/*/{Protheus.doc} FBNTDB01
Gerador dos Modelos Timbrados de Nota debito.
Arquivos .docx devem estar na System
@type user function
@author Andre Froes - Fabritech
@since 02/2024
@version 1.0
/*/
User Function FBNTDB01()
	Local aFilial
	Local cArquivo    := ""
    Private cPasta      := ""
	Private aDados      := {}
    Private cDeploy

    if !FWAlertYesNo("Deseja imprimir Nota de D�bito do T�tulo selecionado?","Impress�o de Nota de D�bito")
        Return
    endif

	aFilial  := FWSM0Util():GetSM0Data()
	cArquivo := SuperGetMV("RE_DEBPTH",.F.,"")

	// Selecionar arquivo a ser impresso
	While Empty(cArquivo) .or. !(FILE(AllTrim(cArquivo)))
		cArquivo := FwInputBox("Layout n�o parametrizado nesta filial. Informe o caminho do arquivo modelo.", cArquivo )

		if Empty(cArquivo)
			if FWAlertYesNo("Deseja sair da rotina?")
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
			if FWAlertYesNo("Deseja sair da rotina?","Impress�o de Nota de D�dito")
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
        /* nTitulo  */   AllTrim(SE1->E1_NUM) ,;
        /* dEmissao */   SE1->E1_EMISSAO      ,;
        /* dVenc */      SE1->E1_VENCTO        ,;
        /* cNomeFil */   AllTrim(aFilial[5][2])      ,;
        /* cCnpjFil */   AllTrim(Transform(aFilial[11][2], PesqPict("SA1","A1_CGC")))         ,;
        /* cEndFil */    AllTrim(aFilial[15][2]) + " - " +  AllTrim(aFilial[17][2]) + " - " + AllTrim(aFilial[18][2]) + " / " + AllTrim(aFilial[19][2]) ,;
        /* cCEPFIL */    AllTrim(aFilial[20][2])        ,;
        /* cNomeEmp */   AllTrim(SA1->A1_NOME) ,;
        /* cCnpjEmp */   AllTrim(Transform(SA1->A1_CGC, PesqPict("SA1","A1_CGC")))            ,;
        /* cEndEmp */    AllTrim(SA1->A1_END) + " - " + AllTrim(SA1->A1_BAIRRO) + " - " + AllTrim(SA1->A1_MUN) + " / " + AllTrim(SA1->A1_EST) ,;
        /* cCEPEmp */    SA1->A1_CEP           ,;
        /* cHist */      AllTrim(SE1->E1_HIST) ,;
        /* nValTit */    AllTrim(Transform(SE1->E1_VALOR, PesqPict("SE1","E1_VALOR")))         ;
		})

    //Copia Modelo para Maquina Local
    CpyS2T(cArquivo,GetTempPath(),.F.)

    //Armazena Path na estacao
    cDeploy := GetTempPath()+subs(cArquivo,RAt("\",cArquivo)+1)

    //Impressao do documento
    FWMsgRun(, {|oSay| ImprimeDoc(oSay) }, "Processando", "Gerando Nota de D�bito")

	//Apaga Modelo da Maquina Local
    FERASE(cDeploy)

    
Return FWAlertSuccess("Nota Gerada com sucesso!","Impress�o de Nota de D�bito")

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
		//Dados Nota Debito
		OLE_SetDocumentVar(hWord, "nTitulo",   aDados[nx][1]  )
		OLE_SetDocumentVar(hWord, "dEmissao",  DtoC(aDados[nx][2])  )
		OLE_SetDocumentVar(hWord, "dVenc",     DtoC(aDados[nx][3])  )

		//Emitente
		OLE_SetDocumentVar(hWord, "cNomeFil",  aDados[nx][4]  )
		OLE_SetDocumentVar(hWord, "cCnpjFil",  aDados[nx][5]  )
		OLE_SetDocumentVar(hWord, "cEndFil",   aDados[nx][6]  )
		OLE_SetDocumentVar(hWord, "cCEPFIL",   aDados[nx][7]  )

		//Cliente
		OLE_SetDocumentVar(hWord, "cNomeEmp",  aDados[nx][8]  )
		OLE_SetDocumentVar(hWord, "cCnpjEmp",  aDados[nx][9]  )
		OLE_SetDocumentVar(hWord, "cEndEmp",   aDados[nx][10] )
		OLE_SetDocumentVar(hWord, "cCEPEmp",   aDados[nx][11] )

		//Historico
		OLE_SetDocumentVar(hWord, "cHist",     aDados[nx][12] )
		OLE_SetDocumentVar(hWord, "nValTit",     aDados[nx][13] )



		//Atualizando campos e gerando arquivo
		OLE_UpdateFields(hWord)
		OLE_SaveAsFile(hWord, cPasta + "\" + aDados[nx][1] + "-nota-de-debito.pdf", , , .F., 17 )

		//Fechando o arquivo e o link
		OLE_CloseFile(hWord)
        sleep(1000)
		OLE_CloseLink(hWord)

        //Abrir pdf
        ShellExecute( "open", cPasta + "\" + aDados[nx][1] + "-nota-de-debito.pdf" , "", "", 1 )
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

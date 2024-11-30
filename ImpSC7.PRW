#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "TopConn.ch"
#INCLUDE "RwMake.ch"
#INCLUDE "TBICONN.CH"
/*/{Protheus.doc} ImpCsv
Rotina de importação do arquivo .csv para tabela SZW, fornecido geralmente pelo Paulo Silva, contendo os principais dados para a tabela SZW
@type function
@version 12.1.025
@author Edmar R Alvarenga
@since 23/11/2021
/*/
User Function IMPSC7()
Local oWizard                        
Local nMetGlob                                      
Local nRadioArq:= 1
Local cText
Local cFile		:= replicate( " ", 80 )
Local cHeader 	:= "Importação de dados"
Local cTpArq	:= "Delimitado (*.csv)|*.CSV|"
Local cDelim	:= AllTrim(SuperGetMV("MV_TPDELI",.F.,';'))
Local cNmAlias	:= ""
Local cTipo		:= "2"
Local i        := 0
Private INCLUI	:= .T.
Private ALTERA	:= .F.
Static aPSemGTrib := {}
cText 	:= 	 "Esta rotina tem por objetivo importar registros, através " + ; 
			 "de um arquivo padrão CSV (delimitado) , e armazena-los na tabela "+ ; 
			 "correspondente do sistema."+ CRLF + ; 
			 "Os nomes das colunas devem ser os mesmos nomes de campos a serem atualizados."+ CRLF + CRLF + ; 
			 "Ao final da importação será gerado um arquivo de log contendo as "+ ; 
			 "inconsistências."  
	
	nRadioArq 	:= 2
	cNmAlias 	:= "CONFIG. TABELA DE PEDIDO DE COMPRA (SC7)"			 
		DEFINE WIZARD oWizard 	TITLE "Importção de dados" ;
							HEADER cHeader ; 
							MESSAGE "Apresentação." ;
							TEXT cText ;
							NEXT { || .T. } ;
							FINISH {|| .T.} PANEL
	
	
	CREATE PANEL oWizard 	HEADER cHeader ;
							MESSAGE "Selecione o arquivo para importação." ;
							BACK {|| .T. } ;
							NEXT {|| ! empty( cDelim ) .and. ! empty( cFile ) } ;
							FINISH {|| .F. } ;
							PANEL         
	
	oPanel := oWizard:GetPanel( 2 )
	
	@ 10, 08 GROUP oGrpCon 	TO 40, 280 LABEL "Selecione um arquivo." ; 
							OF oPanel ;
							PIXEL ;
	     					DESIGN

	@ 20, 15 MSGET oArq 	VAR cFile WHEN .F. OF oPanel SIZE 140, 10 PIXEL ;
							MESSAGE "Utilize o botão ao lado para selecionar" ; 

	DEFINE SBUTTON oButArq 	FROM 21, 160 ;
					 		TYPE 14 ;
					 		ACTION cFile := cGetFile(cTpArq, , 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE) ; 
					 		OF oPanel ;
					 		ENABLE
	
	@ 50, 08 GROUP oGrpCon 	TO 130, 280 LABEL "Informe as configurações do arquivo." ; 
							OF oPanel ;
							PIXEL ;
	     					DESIGN
	     
  	@ 60,20 SAY "Delimitador" OF oPanel SIZE 35,8 PIXEL   
	@ 60,60 MSGET oDelim	VAR cDelim  ;
							PICTURE "@!" ;
							VALID !empty(cDelim) ;
							MESSAGE "Informe um delimitador de campo." ; 
							OF oPanel SIZE 10,8 PIXEL 
                         	
  	@ 80,20 SAY "Tipo" OF oPanel SIZE 35,8 PIXEL   
	//@ 80,60 COMBOBOX oTipo  Var cTipo ITEMS {"1=Somente Log","2=Log + Importação"} 	SIZE 200,010 OF oPanel PIXEL  

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// Terceiro Painel - Confirmacao  / Processamento  
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
   CREATE PANEL oWizard 	HEADER cHeader ;
							MESSAGE "Confirmação dos dados e início de processamento." ; 
							BACK {|| .T. } ;
							NEXT {|| .T. } ;
							FINISH {|| .F. } ;
							PANEL         
							
	
   oPanel := oWizard:GetPanel( 3 )

	@ 010, 010 SAY "Arquivo" OF oPanel SIZE 140, 8 PIXEL   
	@ 010, 050 SAY cFile  OF oPanel SIZE 140, 8 COLOR CLR_HBLUE PIXEL  
	
	@ 030, 010 SAY "Delimitador" OF oPanel SIZE 140, 8 PIXEL   
	@ 030, 050 SAY cDelim  OF oPanel SIZE 140, 8 COLOR CLR_HBLUE PIXEL	

	@ 050, 010 SAY  "Alias" OF oPanel SIZE 140, 8 PIXEL   
	@ 050, 050 SAY  cNmAlias OF oPanel SIZE 140, 8 COLOR CLR_HBLUE PIXEL	

	//@ 070, 010 SAY  "Tipo Proc.:" OF oPanel SIZE 140, 8 PIXEL   
	//@ 070, 050 SAY  IIf(cTipo=="1","Somente Log","Log+Importação")  OF oPanel SIZE 140, 8 COLOR CLR_HBLUE PIXEL	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// Quarto Painel - Processamento                   
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CREATE PANEL oWizard 	HEADER cHeader ;
							MESSAGE "Processamento da Importação." ; 
							BACK {|| .F. } ;
							NEXT {|| .T. } ;
							FINISH {|| .T. } ;
							EXEC {|| CursorWait(), ImpCdSzw( oMetGlob, nRadioArq, cFile, cDelim, cTipo ), CursorArrow() } ;
							PANEL 
							        
	oPanel := oWizard:GetPanel( 4 )

	@ 25, 30 SAY "Importação" OF oPanel SIZE 140, 8 PIXEL   
	@ 40, 30 METER oMetGlob 	VAR nMetGlob ;
								TOTAL 100 ;
								SIZE 224,10 OF oPanel PIXEL UPDATE DESIGN ;
								BARCOLOR CLR_BLACK,CLR_WHITE ;
								COLOR CLR_WHITE,CLR_BLACK ;
							 	NOPERCENTAGE 
							 	
ACTIVATE WIZARD oWizard CENTER

//Apresentar o log com as inconsistências
If Len(aPSemGTrib) > 0          
	cTitulo := "Produtos Sem Grupo Tributação Cadastrado."
	Private oButton1
	Private oFont1 := TFont():New("MS Sans Serif",,026,,.T.,,,,,.F.,.F.)
	Private oSay1
	Private oWBrowse1
	Private oDlg    

	aWBrowse1 := {}

	DEFINE MSDIALOG oDlg TITLE "Produtos Sem Grupo de Tributação Cadastrado." FROM 000, 000  TO 500, 700 COLORS 0, 16777215 PIXEL

    @ 006, 064 SAY oSay1 PROMPT cTitulo SIZE 233, 020 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
    
    
	For i:=1 To lEN(aPSemGTrib) 
	    Aadd(aWBrowse1,{aPSemGTrib[i][1],aPSemGTrib[i][2],aPSemGTrib[i][3]})
    Next i
    
    @ 027, 001 LISTBOX oWBrowse1 Fields HEADER "Produto","Descrição","NCM" SIZE 345, 194 OF oDlg PIXEL ColSizes 50,50
    oWBrowse1:SetArray(aWBrowse1)
   	oWBrowse1:bLine := {|| {aWBrowse1[oWBrowse1:nAt,1],aWBrowse1[oWBrowse1:nAt,2],aWBrowse1[oWBrowse1:nAt,3],}}
 
    @ 227, 303 BUTTON oButton1 PROMPT "&Sair" SIZE 037, 012 OF oDlg ACTION odlg:end() PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

EndIf
Return NIL

/*
 Programa   ImpCdSzw  Autor   Fabritech     Data    30/08/13    
 Desc.      Importacao do arquivo selecionado                            
*/
Static Function ImpCdSzw( oMetGlob, nRadioArq, cFile, cDelim,cTipo )
	Local aArea		:= GetArea()
	Local cLinha 	:= ""
	Local cCdAlias	:= "SC7"
	Local nQtReg	:= 0
	Local lGrava	:= (cTipo == "2")   
	Local nCont2 	:= 0
   Local aHeader  := {"C7_FILIAL","C7_NUM","C7_EMISSAO","C7_ITEM","C7_FORNECE","C7_LOJA","C7_COND","C7_PRODUTO","C7_LOCAL","C7_QUANT","C7_PRECO","C7_TOTAL","C7_OBSM","C7_CC","C7_XCO","C7_TES","C7_FILENT","C7_DATPRF","C7_CONAPRO"}
   Local aCols := {}
	
	If !File(cFile) .OR. Empty(cFile)
		ApMsgStop("Problemas com arquivo informado!")
		
		RestArea(aArea)
		Return
	EndIf

FT_FUSE(cFile)
nTot := FT_FLASTREC()
nAtu := 0

oMetGlob:SetTotal(nTot)
CursorWait()

FT_FGOTOP()
While !FT_FEOF()
	nAtu++
	oMetGlob:Set(nAtu)

	cLinha := LeLinha() //FT_FREADLN()
	clinha := Strtran(cLinha,chr(9),'')  // tira TAB 

	If Empty(cLinha)
		FT_FSKIP()
		nCont2++
		If nCont2 > 20
			Alert('Loop Infinito')
			Return
		EndIf
		Loop
	EndIf

	aCols := {} 
	aCols := Separa(cLinha,cDelim,.T.)
	nQtReg++
    
	If lGrava       
		ImpGrava(cCdAlias,aCols,aHeader)
	EndIf
	
	FT_FSKIP()
End
FT_FUSE()

RestArea(aArea)
Return

/*
 Programa   LeLinha    Autor   Fabritech     Data    30/08/13    
 Desc.      Tratamento de leitura de linha TXT, principalmente para      
            casos de ultrapassar 1Kb por linha                           
*/
Static Function LeLinha()
Local cLinhaTmp := ""
Local cLinhaM100 := ""

cLinhaTmp := FT_FReadLN()

If !Empty(cLinhaTmp)
	cIdent:= Substr(cLinhaTmp,1,1)
	If Len(cLinhaTmp) < 1023
		cLinhaM100 := cLinhaTmp
	Else
		cLinAnt := cLinhaTmp 	
		cLinhaM100 += cLinAnt
		Ft_FSkip()
		cLinProx:= Ft_FReadLN()
		If Len(cLinProx) >= 1023 .and. Substr(cLinProx,1,1) <> cIdent
			While Len(cLinProx) >= 1023 .and. Substr(cLinProx,1,1) <> cIdent .and. !Ft_fEof()
				cLinhaM100 += cLinProx
				Ft_FSkip()
				cLinProx := Ft_fReadLn()
				If Len(cLinProx) < 1023 .and. Substr(cLinProx,1,1) <> cIdent
					cLinhaM100 += cLinProx
				Endif
			Enddo
		Else
			cLinhaM100 += cLinProx
		Endif
	Endif
Endif

Return(cLinhaM100)

/*
 Programa   RetCol     Autor   Fabritech     Data    07/20/09    
 Desc.      Retorna conteudo de coluna especifica                        
*/
Static Function RetCol(cCpo,aCols,aHeader)
Local cRet 	:= ""
Local nPos	:= 0
Local aSX3Area	:= SX3->(GetArea())

nPos := AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim(cCpo)) })

If !Empty(nPos)
	If Upper(AllTrim(aCols[nPos])) <> "NULL"

		DbSelectArea("SX3")
		DbSetOrder(2)
		If MsSeek(cCpo)
			If SX3->X3_TIPO == "D"
				cRet := StoD(AllTrim(aCols[nPos]))
			ElseIf SX3->X3_TIPO == "N"
				cRet := Val(AllTrim(aCols[nPos]))
			Else
				cRet := PadR(Upper(AllTrim(aCols[nPos])),TamSX3(cCpo)[1])
			EndIf
			
			aCols[nPos] := cRet

		Else
			cRet := Upper(AllTrim(aCols[nPos]))
		EndIf
	EndIf
EndIf

SX3->(RestArea(aSX3Area))
Return cRet

Static Function ImpGrava(cCdAlias,aCols,aHeader)
Local nY := 0
   //(cCdAlias)->(dbSetOrder(2)) //ZW_FILIAL+ZW_TRANSP+ZW_ESTADO+ZW_CAPINT+ZW_CEPDE+ZW_CEPATE]
      
	RecLock(cCdAlias,.T.)
	for ny := 1 to len(aHeader)
      (cCdAlias)->&(aHeader[ny]) := RetCol(aHeader[ny],aCols,aHeader)
   next ny
	(cCdAlias)->(MsUnlock())
		
Return nil

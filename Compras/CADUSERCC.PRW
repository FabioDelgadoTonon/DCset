//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

//Variveis Estaticas
Static cTitulo   := "Amarração Usuário X Centro de Custo"
Static cTabPai   := "Z98"
Static cTabFilho := "Z99"

/*/{Protheus.doc} User Function CADUSERCC
Amarração Usuário X Centro de Custo
@author ALEX MIRANDA
@since 23/08/2023
@version 1.0
@type function
/*/

User Function CADUSERCC()

	Local aArea     := FWGetArea()
	Local oBrowse
	Private aRotina := {}

	//Definicao do menu
	aRotina := MenuDef()

	//Instanciando o browse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(cTabPai)
	oBrowse:SetDescription(cTitulo)
	oBrowse:DisableDetails()

	//Ativa a Browse
	oBrowse:Activate()

	FWRestArea(aArea)

Return Nil

/*/{Protheus.doc} MenuDef
Menu de opcoes na funcao CADUSER
@author ALEX MIRANDA
@since 23/08/2023
@version 1.0
@type function
/*/

Static Function MenuDef()

	Local aRotina := {}

	//Adicionando opcoes do menu
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.CADUSERCC" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.CADUSERCC" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.CADUSERCC" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.CADUSERCC" OPERATION 5 ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
Modelo de dados na funcao CADUSER
@author ALEX MIRANDA
@since 23/08/2023
@version 1.0
@type function
/*/

Static Function ModelDef()

	Local oStruPai   := FWFormStruct(1, cTabPai)
	Local oStruFilho := FWFormStruct(1, cTabFilho)
	Local aRelation  := {}
	Local oModel
	Local bPre       := Nil
	Local bPos       := Nil
	Local bCancel    := Nil


	//Cria o modelo de dados para cadastro
	oModel := MPFormModel():New("CADUSERM", bPre, bPos, /*bCommit*/, bCancel)
	oModel:AddFields("Z98MASTER", /*cOwner*/, oStruPai)
	oModel:AddGrid("Z99DETAIL","Z98MASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:SetDescription(cTitulo)
	oModel:GetModel("Z98MASTER"):SetDescription( "Dados de - " + cTitulo)
	oModel:GetModel("Z99DETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:SetPrimaryKey({})

	//Fazendo o relacionamento
	aAdd(aRelation, {"Z99_FILIAL", "FWxFilial('Z99')"} )
	aAdd(aRelation, {"Z99_ID", "Z98_ID"})
	oModel:SetRelation("Z99DETAIL", aRelation, Z99->(IndexKey(1)))
	
	//Definindo campos unicos da linha
	oModel:GetModel("Z99DETAIL"):SetUniqueLine({'Z99_ITEM', 'Z99_CC', 'Z99_NOMECC'})

Return oModel

/*/{Protheus.doc} ViewDef
Visualizacao de dados na funcao CADUSER
@author ALEX MIRANDA
@since 23/08/2023
@version 1.0
@type function
/*/

Static Function ViewDef()
	Local oModel     := FWLoadModel("CADUSERCC")
	Local oStruPai   := FWFormStruct(2, cTabPai)
	Local oStruFilho := FWFormStruct(2, cTabFilho)
	Local oView

	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_Z98", oStruPai, "Z98MASTER")
	oView:AddGrid("VIEW_Z99",  oStruFilho,  "Z99DETAIL")

	//Partes da tela
	oView:CreateHorizontalBox("CABEC", 30)
	oView:CreateHorizontalBox("GRID", 70)
	oView:SetOwnerView("VIEW_Z98", "CABEC")
	oView:SetOwnerView("VIEW_Z99", "GRID")

	//Titulos
	oView:EnableTitleView("VIEW_Z98", "Cabecalho")
	oView:EnableTitleView("VIEW_Z99", "Grid - Itens")

	//Adicionando campo incremental na grid
	oView:AddIncrementField("VIEW_Z99", "Z99_ITEM")

Return oView

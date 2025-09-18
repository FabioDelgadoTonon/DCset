// BIBLIOTECAS NECESSÁRIAS
#Include "TOTVS.ch"

// FUNÇÃO PRINCIPAL
User Function MT103FRE()
    Local aParam   := PARAMIXB  // RATEIO DE FRETE
    Local aAreaTOT := GetArea() // TABELA POSICIONADA NO MOMENTO
    Local aAreaSB1 := {}        // POSICIONAMENTO DA TABELA A SER MANIPULADA
    Local nPosDesc := 0         // ARMAZENA A POSIÇÃO DO CAMPO CUSTOMIZADO D1_XDESC (DESTINO)
    Local nPosProd := 0         // ARMAZENA A POSIÇÃO DO CAMPO PADRÃO D1_COD (ORIGEM)
    Local nX       := 0         // CONTROLADOR DO LAÇO DE REPETIÇÃO

    // ARMAZENA O ESTADO DA ÁREA CORRENTE DA TABELA SB1
    DbSelectArea("SB1")
    aAreaSB1 := SB1->(GetArea())

    // ARMAZENA AS POSIÇÕES DOS CAMPOS D1_COD E D1_XDESC COM BASE NA AHEADER
    nPosDesc := AScan(aHeader, {|x| AllTrim(x[2]) == "D1_XDESC"})
    nPosProd := AScan(aHeader, {|x| AllTrim(x[2]) == "D1_COD"})

    // LAÇO DE REPETIÇÃO PREENCHENDO O CAMPO CUSTOMIZADO COM O CONTEÚDO DO POSICIONE EM B1_DESC
    For nX :=1 To Len(aCols)
        aCols[nX][nPosDesc] := Posicione("SB1", 1, FwXFilial("SB1") + aCols[nX][nPosProd], "B1_DESC")
    Next nX

    // RESTAURAÇÃO DA ÁREA DE SB1 E DA ÁREA ANTERIOR
    RestArea(aAreaSB1)
    RestArea(aAreaTOT)
Return (aParam)

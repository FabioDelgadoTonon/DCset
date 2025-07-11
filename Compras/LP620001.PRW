#Include 'Protheus.ch'
 
User function LP620001()

nVlrTX := 0
SE1->(dbSetOrder(1))
    if SE1->(dbSeek(SF2->(F2_FILIAL+F2_SERIE+F2_DOC),.T.))
           
        while SF2->(F2_FILIAL+F2_SERIE+F2_DOC) == SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM)
    
        IF SE1->E1_VLRREAL > 0
	  	  nVlrTX += (SE1->E1_VLRREAL-SE1->E1_VALOR)
        ENDIF

        SE1->(dbSkip())
        enddo

     Endif
RETURN (nVlrTX)



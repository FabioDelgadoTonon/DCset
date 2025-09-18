#Include "Protheus.ch"
/*/{Protheus.doc} MT120TXMD
PE para validar se a taxa da moeda
deve ou não ser alterada no PC.
@type     function
@author     
@since       18/11/2024
/*/
User Function MT120TXMD()
Local lRet := .T.
 
 
lRet := FWAlertYesNo("Deseja alterar a taxa da moeda? Sim / Não", "ATENÇÃO MT120TXMD!")


DbSelectArea("SC7")
DbSetOrder(1)


If SC7->C7_MOEDA == 2 .AND. SC7->C7_TXMOEDA == 0 .AND. DDATABASE == SM2->M2_DATA
   SC7->C7_TXMOEDA:=  Posicione("SM2", 1, DToS(dDataBase-1), "M2_MOEDA2")
Endif

If SC7->C7_MOEDA == 2 .AND. SC7->C7_TXMOEDA == 0 .AND. DDATABASE == SM2->M2_DATA
   SC7->C7_TXMOEDA:=  Posicione("SM2", 1, DToS(dDataBase-2), "M2_MOEDA2")
Endif

If SC7->C7_MOEDA == 2 .AND. SC7->C7_TXMOEDA == 0 .AND. DDATABASE == SM2->M2_DATA
   SC7->C7_TXMOEDA:=  Posicione("SM2", 1, DToS(dDataBase-3), "M2_MOEDA2")
Endif

If SC7->C7_MOEDA == 3 .AND. SC7->C7_TXMOEDA == 0 .AND. DDATABASE == SM2->M2_DATA
   SC7->C7_TXMOEDA:=  Posicione("SM2", 1, DToS(dDataBase-1), "M2_MOEDA3")
Endif

If SC7->C7_MOEDA == 3 .AND. SC7->C7_TXMOEDA == 0 .AND. DDATABASE == SM2->M2_DATA
   SC7->C7_TXMOEDA:=  Posicione("SM2", 1, DToS(dDataBase-2), "M2_MOEDA3")
Endif

If SC7->C7_MOEDA == 3 .AND. SC7->C7_TXMOEDA == 0 .AND. DDATABASE == SM2->M2_DATA
   SC7->C7_TXMOEDA:=  Posicione("SM2", 1, DToS(dDataBase-3), "M2_MOEDA3")
Endif


Return lRet

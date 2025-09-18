
#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
 
User Function F050ROT()
     
    Local aArea   := GetArea()
    Local aRotina := Paramixb // Array contendo os botoes padr�es da rotina.
 
    
    Aadd(aRotina, { "@ Re-Envia Aprov.", "U_ResetAprov", 0, 8, 0,.F.})
     
    RestArea(aArea)
 
Return aRotina
*----------------------------------*
 User Function ResetAprov()
*----------------------------------*

IF !Empty(SE2->E2_IDCNAB) .OR.  !Empty(SE2->E2_NUMBOR) 
    IF MsgyesNo("Tem Certeza que deseja reiniciar as aprova��es ?")

        U_xGerAprovSCR()
        Msginfo("Reenvio de aprova��o realizado com sucesso !")

    EndIf
Else
   Alert("O Titulo ja foi enviado para o banco e/ou esta vinculado h� um bordero e n�o pode ser reenviado a aprova��o !")
EndIf

Return .T.

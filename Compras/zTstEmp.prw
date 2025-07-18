//Bibliotecas
#Include "Protheus.ch"
 
/*/{Protheus.doc} zTstEmp
Fun��o que percorre as empresas / filiais e cria as tabelas no banco
@author Daniel Atilio
@since 16/12/2017
@version 1.0
    @example
    u_zTstEmp()
/*/
 
User Function zTstEmp()
   
   
   
lAllFil := .T. //Se for .T. ir� pegar todas as filiais, se for .F. ser� s� da empresa atual
  Local aAreaM0  := SM0->(GetArea())
    Local cFilBk   := cFilAnt
    Local cEmpBk   := cEmpAnt
    Local cUnidNeg
    Local aUnitNeg := Iif(lAllFil, FWAllGrpCompany(), {SM0->M0_CODIGO})
    Local aEmpAux  := Iif(lAllFil, FWAllCompany(), {cEmpAnt})
    Local nGrp
    Local nEmp
    Local nAtu
  
    //Percorrendo os grupos de empresa
    For nGrp := 1 To Len(aUnitNeg)
        cUnidNeg := aUnitNeg[nGrp]
          
        //Percorrendo as empresas
        For nEmp := 1 To Len(aEmpAux)
            cEmpAnt := aEmpAux[nEmp]
            aFilAux := FWAllFilial(cEmpAnt)
             
            //Percorrendo as filiais listadas
            For nAtu := 1 To Len(aFilAux)
                //Se o tamanho da filial for maior, atualiza
                If Len(cFilAnt) > Len(aFilAux[nAtu])
                    cFilAnt := cEmpAnt + aFilAux[nAtu]
                Else
                    cFilAnt := aFilAux[nAtu]
                EndIf
                  
                //Posiciono na empresa
                SM0->(DbGoTop())
                SM0->(DbSeek(cUnidNeg+cFilAnt))
              
                //Aqui voc� pode usar ChkFile(), DbSelectArea() ou X31UpdTable() para criar / atualizar tabelas, e o TAB1, voc� pode colocar os alias que voc� deseja, como por exemplo, "SB1", "SA1", "SA2", etc

ChkFile("SGO") 


            
            Next
        Next
    Next
     
    cFilAnt := cFilBk
    cEmpAnt := cEmpBk
    RestArea(aAreaM0)
Return

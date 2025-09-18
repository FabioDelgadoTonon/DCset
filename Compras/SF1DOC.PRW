<<<<<<< HEAD:MT103IPC.PRW
#include "rwmake.ch" 
#Include "TopConn.Ch"

/*


?
Programa  MT103IPC  Autor  Fabio Delgado Tonon  Data   24/07/24   
?
Desc.      Ponto de entrada para atualizar campos custimizados no Doc.
          de entrada trazendo as informaes do pedido de compras     
?
Uso         Compras                                                   
?


*/

User Function MT103IPC()

Local ExpN1 := PARAMIXB[1]

If cEmpAnt <> '02'

  aCols[ExpN1][aScan(aHeader,{|x| AllTrim(x[2]) == "D1_XCO"})] := SC7->C7_XCO

Endif

Return Nil
=======
#include "PROTHEUS.CH"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³SF1DOC ºAutor ³Valter Mariano   º Data ³ 29/12/13            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para colocar zeros a esquerna no numero da NF       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Pergunta se deseja abrir a rotina de Controle de Reservas  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION SF1DOC()
If !Empty(M->F1_DOC) .Or. !Empty(cNFISCAL)
   M->F1_DOC := StrZero(Val(M->F1_DOC),9)
   CNFISCAL := M->F1_DOC
Endif   
Return(.T.)

>>>>>>> ddfca486fa0b30f0f6d3f2a9d7430dfe53ebebae:Compras/SF1DOC.PRW

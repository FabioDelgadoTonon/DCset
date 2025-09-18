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

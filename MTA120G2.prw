
#INCLUDE "Protheus.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "TopConn.ch"

*--------------------------------------*
User Function MTA120G2()
*--------------------------------------*
//Public _lSmCpy120 := iIF(Type('_lSmCpy120')=='U',.F.,_lSmCpy120)

IF SC7->(FIELDPOS("C7_XAPRVLT")) > 0
    SC7->C7_XAPRVLT := _cAprvLote
ENDIF



Return 

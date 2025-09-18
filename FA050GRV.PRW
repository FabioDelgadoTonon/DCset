#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE  ENTER CHR(13)+CHR(10)


*---------------------*
User Function FA050GRV()
*---------------------*
Local _AreaE2 := SE2->(Getarea())

U_xGerAprovSCR()

Restarea(_AreaE2)
Return .T.
*----------------------------------*
User Function xGerAprovSCR()
*----------------------------------*
_lPedLote := .F.
_cPedido := SE2->E2_PEDIDO

IF Empty(_cPedido)
    _cCC := SE2->E2_CCUSTO
    IF Empty(_cCC)
        SD1->(dbSetOrder(1))
        IF SD1->(dbSeek(SE2->E2_FILIAL+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA))
            _cCC := SD1->D1_CC
            _cPedido := SD1->D1_PEDIDO
        EndIf
    EndIf
EndIf

IF !Empty(_cPedido)
    SC7->(dbSetOrder(1))
    IF SC7->(dbSeek(xFilial("SC7")+_cPedido))
        IF SC7->(FIELDPOS("C7_XAPRVLT")) > 0
            IF SC7->C7_XAPRVLT == "1"
                _lPedLote:= .T.
            ENDIF
        ENDIF
    ENDIF
    IF Empty(SE2->E2_PEDIDO)
        IF SE2->(RECLOCK("SE2",.F.))
            SE2->E2_PEDIDO := _cPedido
            SE2->(MSUNLOCK())
        ENDIF
    EndIf

EndIf
/*Foi pedido uma Regra para quando o PC tiver com o campo preenchido permitir cair para um grupo especifico e o mesmo permitir a aprovação por lote */
/*Na reuniao foi comentado que existe a sazonalidade nos fornecedor onde aumentam muito a demanda de aprovação  */
if !_lPedLote
    _cQrySAL := " Select AK_USER, AL_NIVEL, AL_APROV, AL_ITEM, AL_DESC, AL_COD, AL_ITEM " +(chr(13))+(chr(10))
    _cQrySAL += " From "+RetSqlName('SAL')+" SAL " +(chr(13))+(chr(10))
    _cQrySAL += " 	INNER Join "+RetSqlName('SAK')+" SAK On AK_COD = AL_APROV AND SAK.D_E_L_E_T_ = ''   " +(chr(13))+(chr(10))
    _cQrySAL += " 	INNER Join "+RetSqlName('DBL')+" DBL On DBL_GRUPO = AL_COD  AND DBL.D_E_L_E_T_ = '' AND DBL_CC='"+Alltrim(_cCC)+"' " +(chr(13))+(chr(10))
    _cQrySAL += " 	LEFT JOIN "+RetSqlName('DHL')+" DHL ON DHL_COD=AL_PERFIL ANd DHL.D_E_L_E_T_ = ''  " +(chr(13))+(chr(10))
    _cQrySAL += "    Where SAL.D_E_L_E_T_ = '' AND AL_MSBLQL<>'1'  " +(chr(13))+(chr(10))
    _cQrySAL += "    AND SUBSTRING(AL_COD,1,1)='P'  " 
    _cQrySAL += "    AND DHL_LIMMIN <="+Alltrim(Str(SE2->E2_VALOR))+" AND  DHL_LIMMAX >= "+Alltrim(Str(SE2->E2_VALOR))
    _cQrySAL += "    Order By AL_COD, AL_NIVEL  " 
    CONOUT(_cQrySAL)
ELSE
    _cQrySAL := " Select AK_USER, AL_NIVEL, AL_APROV, AL_ITEM, AL_DESC, AL_COD, AL_ITEM " +(chr(13))+(chr(10))
    _cQrySAL += " From "+RetSqlName('SAL')+" SAL " +(chr(13))+(chr(10))
    _cQrySAL += " 	INNER Join "+RetSqlName('SAK')+" SAK On AK_COD = AL_APROV AND SAK.D_E_L_E_T_ = ''   " +(chr(13))+(chr(10))
    _cQrySAL += " 	LEFT JOIN "+RetSqlName('DHL')+" DHL ON DHL_COD=AL_PERFIL ANd DHL.D_E_L_E_T_ = ''  " +(chr(13))+(chr(10))
    _cQrySAL += "    Where SAL.D_E_L_E_T_ = '' AND AL_MSBLQL<>'1'  " +(chr(13))+(chr(10))
    _cQrySAL += "    AND AL_COD='P00024' " 
    _cQrySAL += "    Order By AL_COD, AL_NIVEL  " 

ENDIF
//EECVIEW(_cQrySAL)
 DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQrySAL),"_SAL",.F.,.T.)

_cDelete := "DELETE FROM "+RetSqlName("SCR")+" WHERE CR_FILIAL='"+xFilial('SCR')+"' AND CR_NUM='"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA+"' AND D_E_L_E_T_='' "
TcSqlExec(_cDelete)


_cAtual := '02'
Do While _SAL->(!Eof())
    
    SCR->(Reclock("SCR",.T.))
    SCR->CR_FILIAL	 := xFilial('SCR')
    SCR->CR_NUM		 := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
    SCR->CR_TIPO	 := 'FI'
    SCR->CR_NIVEL	 := _SAL->AL_NIVEL
    SCR->CR_USER	 := _SAL->AK_USER
    SCR->CR_APROV	 := _SAL->AL_APROV
    SCR->CR_STATUS	 := _cAtual
    SCR->CR_TOTAL	 := SE2->E2_SALDO
    SCR->CR_EMISSAO  := dDataBase
    SCR->CR_MOEDA	 := 1
    SCR->CR_TXMOEDA  := 1
    SCR->CR_PRAZO	 := dDataBase+2
    SCR->CR_AVISO	 := dDataBase+3
    SCR->CR_GRUPO    := _SAL->AL_COD
    SCR->CR_ITGRP    := _SAL->AL_ITEM
    SCR->(MsUnlock())
    _cNivAnt := _SAL->AL_NIVEL

    _SAL->(dbSkip())
    
    If _SAL->AL_NIVEL <> _cNivANt
        _cAtual := '01'
    EndIf

    
EndDo
_SAL->(dbCloseArea())

Return .T.

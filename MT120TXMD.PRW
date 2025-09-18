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

// _cQrySAL := "Select AK_USER, AL_NIVEL, AL_APROV, AL_ITEM, AL_DESC, AL_COD, AL_ITEM "
// _cQrySAL += "From "+RetSqlName('SAL')+" SAL"
// _cQrySAL += "	Full Outer Join "+RetSqlName('SAK')+" SAK On AK_COD = AL_APROV ANd SAK.D_E_L_E_T_ = '' "
// //_cQrySAL += "	Full Outer Join "+RetSqlName('DBL')+" DBL On DBL_GRUPO = AL_COD  ANd DBL.D_E_L_E_T_ = '' "
// _cQrySAL += "   Where SAL.D_E_L_E_T_ = '' AND AL_MSBLQL<>'1' "
// _cQrySAL += "   AND AL_COD='"+GetMV("APP_GRPFIN",.F.,"000001")+"' "
// _cQrySAL += "   Order By AL_COD, AL_NIVEL "
// DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQrySAL),"_SAL",.F.,.T.)

_cCC := SE2->E2_CCUSTO
IF Empty(_cCC)
    SD1->(dbSetOrder(1))
    IF SD1->(dbSeek(SE2->E2_FILIAL+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA))
        _cCC := SD1->D1_CC
    EndIf
EndIf


_cQrySAL := " Select AK_USER, AL_NIVEL, AL_APROV, AL_ITEM, AL_DESC, AL_COD, AL_ITEM " +(chr(13))+(chr(10))
_cQrySAL += " From "+RetSqlName('SAL')+" SAL " +(chr(13))+(chr(10))
_cQrySAL += " 	INNER Join "+RetSqlName('SAK')+" SAK On AK_COD = AL_APROV ANd SAK.D_E_L_E_T_ = ''   " +(chr(13))+(chr(10))
_cQrySAL += " 	INNER Join "+RetSqlName('DBL')+" DBL On DBL_GRUPO = AL_COD  ANd DBL.D_E_L_E_T_ = '' AND DBL_CC='"+Alltrim(_cCC)+"' " +(chr(13))+(chr(10))
_cQrySAL += " 	LEFT JOIN "+RetSqlName('DHL')+" DHL ON DHL_COD=AL_PERFIL ANd DHL.D_E_L_E_T_ = ''  " +(chr(13))+(chr(10))
_cQrySAL += "    Where SAL.D_E_L_E_T_ = '' AND AL_MSBLQL<>'1'  " +(chr(13))+(chr(10))
_cQrySAL += "    AND SUBSTRING(AL_COD,1,1)='P'  " 
_cQrySAL += "    Order By AL_COD, AL_NIVEL  " 
CONOUT(_cQrySAL)
 DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQrySAL),"_SAL",.F.,.T.)

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


Restarea(_AreaE2)
Return .T.

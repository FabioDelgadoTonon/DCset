#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADZ99    � Autor � AP6 IDE            � Data �  17/11/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro amarra��o de usuario x CC                         ���
���          �                                                            ���
/*/

User Function CADUSERCC


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "Z99"

dbSelectArea("Z99")
dbSetOrder(1)

AxCadastro(cString,"Cadastro amarra��o de usuario x CC",cVldExc,cVldAlt)

Return

#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADZ98    � Autor � AP6 IDE            � Data �  17/11/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro amarra��o de usuario                              ���
���          �                                                            ���
/*/

User Function CADZ98


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "Z98"

dbSelectArea("Z98")
dbSetOrder(1)

AxCadastro(cString,"Cadastro amarra��o de usuario",cVldExc,cVldAlt)

Return

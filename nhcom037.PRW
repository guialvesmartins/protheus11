/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHCOM037  �Autor  �Marcos R Roquitski  � Data �  28/03/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna codigo do usuario no cadastro de usuarios.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function Nhcom037()

SetPrvt("_aGrupo,_cCodUsr,_lRet,_cNome")
_aGrupo  := pswret() 
_cCodUsr := _agrupo[1,1]
_cNome   := _agrupo[1,2]
_lRet    := .F.

SAJ->(DbSetOrder(2))
SAJ->(DbSeek(xFilial("SAJ")+_cCodUsr))
If SAJ->(Found())
	IF Alltrim(_cNome)$"RODERJAN/BERNY"
		_lRet := .T.
		M->A2_USER := _cCodUsr
	Else
		MsgBox("Somente usuario RODERJAN podera alterar status do fornecedor !","Bloqueio de Fornecedor")
	Endif
Else
	MsgBox("Usuario n�o pertence ao grupo de Compradores. Verifique !","Bloqueio de Fornecedor")
Endif

Return(_lRet)      

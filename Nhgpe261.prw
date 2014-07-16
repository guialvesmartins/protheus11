/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE261  �Autor  �Marcos R. Roquitski � Data �  03/07/2013.���
�������������������������������������������������������������������������͹��
���Desc.     �  Desconto vale transporte em rescisao.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

User Function Nhgpe261()
Local _VlrUni := 0
Local _nValor := 0

If SRN->(DbSeek(xFilial("SRN")+"01"))
	_VlrUni := SRN->RN_VUNIATU
Else
	_VlrUni := 	Val(Alltrim(GETMV("MV_GPE261")))
Endif

_nValor := M->RG_VTQTD * _VlrUni

If _nValor > 0
	fGeraVerba("479",_nValor,,,,,,,,,.T.) 
Endif	

Return(.T.)    

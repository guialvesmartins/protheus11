/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHGPE253  �Autor  �Marcos R Roquitski � Data �  22/05/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Bloqueio calculo folha de pagamento                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"
#include "Font.ch"
#include "Colors.ch"


User Function Nhgpe253()

	SetPrvt("_cMvGpem020,_aGrupo,_cLogin")

	_aGrupo := pswret()
	_cLogin := _agrupo[1,2]
		
	_cMvGpem020 := Alltrim(GETMV("MV_GPEM020")) 
	
	If Alltrim(_cMvGpem020) == 'N'
		GPEM020()
 
	Else
		MsgBox("Rotina Bloqueada, Verifique com Administrador da Folha de Pagameto.","Bloqueio Folha de Pagamento","STOP")
	
	Endif	
		 				
Return(.T.)

// Rua alvaro maravalhas, 594 - CIC - PARQUE DO SOFTWARE
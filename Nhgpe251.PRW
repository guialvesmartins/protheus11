/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHGPE251  �Autor  �Marcos R Roquitski � Data �  22/05/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Bloqueio ferias coletivas/programadas                      ���
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


User Function Nhgpe251()

	SetPrvt("_cMvGpem060,_aGrupo,_cLogin")

	_aGrupo := pswret()
	_cLogin := _agrupo[1,2]
		
	_cMvGpem060 := Alltrim(GETMV("MV_GPEM060")) 
	
	If Alltrim(_cMvGpem060) == 'N'
		GPEM060()
 
	Else
		MsgBox("Rotina Bloqueada, Verifique com Administrador da Folha de Pagameto.","Bloqueio Ferias programada/coletivas","STOP")
	
	Endif	
		 				
Return(.T.)

// Rua alvaro maravalhas, 594 - CIC - PARQUE DO SOFTWARE
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHGPE246 �Autor  �Marcos R Roquitski  � Data �  22/05/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Trava calculo de ferias.                                   ���
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


User Function Nhgpe246()

	If MsgBox("Bloquea Rotina de Calculo de ** FERIAS ?.","Bloqueio de Lancamentos","YESNO")

		SX6->(DbSeek(xFilial("SRA")+"MV_GPEM030"))
		If SX6->(Found())
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := "S"
			MsUnlock("SX6")

			Alert("Rotina BLOQUEADA para manutencao.")	
		Else
			Alert("Parametro MV_GPEM030 Nao cadastrado. Verifique no cadastro de parametros!")	

		Endif	
	
	Else
	
		SX6->(DbSeek(xFilial("SRA")+"MV_GPEM030"))
		If SX6->(Found())
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := "N"
			MsUnlock("SX6")

			Alert("Rotina LIBERADA para manutencao.")	

		Else
			Alert("Parametro MV_GPEM030 Nao cadastrado. Verifique no cadastro de parametros!")	

		Endif	
		
	Endif
	
Return

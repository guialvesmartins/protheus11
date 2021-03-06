
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHMNT029     �Autor  �Jo�o Felipe da Rosa � Data �  19/08/08���
�������������������������������������������������������������������������͹��
���Desc.     � GATILHO PARA BLOQUEIO DE MATRICULAS INVALIDAS              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include 'rwmake.ch'

User Function NHMNT029()
Local _lRet := .F.

	DbSelectArea('QAA')
	DbSetOrder(1) //FILIAL + MAT
	If DbSeek(xFilial('QAA')+M->TJ_CODFUN)
		If Empty(QAA->QAA_FIM)
			_lRet = .T.
		EndIf
	EndIf
	
	If !_lRet
		MsgBox("Matricula Inv�lida","Atencao","ALERT")
	EndIf

Return(_lRet)

//���������������������������������������������������������������������Ŀ
//�GATILHO PARA USO NA ROTINA DE CADASTRO DE FUNCIONARIOS DE MANUTENCAO �
//�����������������������������������������������������������������������
User Function MNT29RETMAT()
Local _cRet := ""

	DbSelectArea('SRA')
	DbSetOrder(1) //FILIAL + MAT
	If DbSeek(xFilial('SRA')+M->T1_CODFUNC)
		If SRA->RA_SITFOLH <> 'D' .AND. SRA->RA_SITFOLH <> 'T'
			_cRet = SRA->RA_NOME     
		Else
			MsgBox("Funcion�rio bloqueado!","SRA - Aten��o ","ALERT")
		EndIf
	Else
		MsgBox("Funcion�rio n�o cadastrado!","SRA - Aten��o ","ALERT")
	EndIf	

Return _cRet


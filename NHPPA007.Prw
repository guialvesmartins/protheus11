/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHPPA007 �Autor  �Alexandre R. Bento  � Data �  17/08/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa que traz o nome do cliente na matriz de correlacao ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


#include "rwmake.ch"
USER FUNCTION NHPPA007()


SA1->(DbsetOrder(1))
SA1->(DbSeek(xFilial("SA1")+QK1->QK1_CODCLI+QK1->QK1_LOJCLI))                                                      

If UPPER(FUNNAME())$"TPPAC004" //Matriz de correlacao
   M->ZC5_NOMCLI := SA1->A1_NOME
   
Elseif UPPER(FUNNAME())$"TPPAC014" //Historico de Processo   
   M->ZC9_NOMCLI := SA1->A1_NOME
Elseif UPPER(FUNNAME())$"TPPAC009" //Conformacao da Validacao do Processo
   M->ZC8_NOMCLI := SA1->A1_NOME   
Endif

Return(.T.)

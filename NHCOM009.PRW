/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � NHCOM009        � Alexandre R. Bento    � Data � 11/06/06 ���
������������������������������������������������������������������������Ĵ��
���Descri��o � Gatilho que pega o lead time do produto e soma na data de ���
���          � Entrega prevista e o usuario n�o pode alterar p/ baixo    ���
������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                  ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/


#include "rwmake.ch"   

User Function NHCOM009()

Local _nCod   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_PRODUTO"})  
Local _nData  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_DATPRF"})  
Local _lOK    := .T.

If !Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada
   If SB1->(Dbseek(xFilial("SB1")+Acols[n][_nCod] ))
       If SB1->B1_LT > 0
          Acols[n][_nData] := Ddatabase  //pega a data do dia
          Acols[n][_nData] := Acols[n][_nData] +SB1->B1_LT
       Endif   
   Endif                                                     
Endif	
		
Return(Acols[n][_nData])
          

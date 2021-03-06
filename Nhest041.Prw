/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � NHEST041        � Alexandre R. Bento    � Data �03.01.2003���
������������������������������������������������������������������������Ĵ��
���Descricao � Utilizado para contabilizar a conta debito na rotina de   ���
���            acerto de inventario                                      ���
������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                  ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

#include "rwmake.ch"     

User Function nhest041()        

SetPrvt("cCONTA")

cCONTA := Space(12)

IF SM0->M0_CODIGO == "NH"  //empresa new hubner
	If SD3->D3_TIPO == "MP"
		cCONTA := "401020010001"
	Elseif SD3->D3_TIPO == "CP"
		cCONTA := "401020010002"
	Elseif SD3->D3_TIPO == "EB"
		cCONTA := "401020010003"
	Elseif SD3->D3_TIPO == "FE"
		cCONTA := "401020020001"
	Elseif SD3->D3_TIPO == "MM"
		cCONTA := "401020020003"
	Elseif SD3->D3_TIPO == "ML"
		cCONTA := "401020020006"
	Elseif SD3->D3_TIPO == "MQ"
		cCONTA := "401020020004"
	Elseif SD3->D3_TIPO == "MS"
		cCONTA := "401020020007"
	Elseif SD3->D3_TIPO == "MX"
		cCONTA := "401020020005"
	Elseif SD3->D3_TIPO == "OL"
		cCONTA := "401020020002"
	Elseif SD3->D3_TIPO == "MA"
		cCONTA := "401020010004"
	Endif

Elseif SM0->M0_CODIGO == "FN"  //empresa fundicao
	If SD3->D3_TIPO == "MP"
	   cCONTA := "401020010001"
	Elseif SD3->D3_TIPO == "MA"
	   cCONTA := "401020010002"
	Elseif SD3->D3_TIPO == "EB"
	   cCONTA := "401020010003"
	Elseif SD3->D3_TIPO == "FR"
	   cCONTA := "401020020001"
	Elseif SD3->D3_TIPO == "MM"
	   cCONTA := "401020020003"
	Elseif SD3->D3_TIPO == "MQ"
	   cCONTA := "401020020004"
	Elseif SD3->D3_TIPO == "MS"
	   cCONTA := "401020020007"
	Elseif SD3->D3_TIPO == "MX"
	   cCONTA := "401020020005"
	Elseif SD3->D3_TIPO == "PQ"
	   cCONTA := "401020020010"
	Elseif SD3->D3_TIPO == "FD"
	   cCONTA := "101040030014"
	Elseif SD3->D3_TIPO == "GG"
	   cCONTA := "101040010001"
	Elseif SD3->D3_TIPO == "MF"
	   cCONTA := "101040040001"	 
	Elseif SD3->D3_TIPO == "MG"
	   cCONTA := "101040030003"	 
	Elseif SD3->D3_TIPO == "FJ"
	   cCONTA := "401020020001"
	   
	Endif
	

Endif

Return(cCONTA) 

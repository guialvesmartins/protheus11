/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHINT003  �Autor  �Marcos R Roquitski  � Data �  02/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Contabilizacao lancamento 666/668.                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"      

User Function Nhint003()    

SetPrvt("_CCTA,")

_cCta := ''

//Conta a debito do fornecedor
If SD3->D3_TIPO == "MP"  .and. SD3->D3_LOCAL  == "10"
      _cCta := "401020010001"

Elseif SD3->D3_TIPO == "CP"  .and. SD3->D3_LOCAL  == "10"

      _cCta := "401020010002"

Elseif SD3->D3_TIPO == "EB" 

      _cCta := "401020010003"


Elseif SD3->D3_TIPO == "MA" 

      _cCta := "401020010004"


Elseif SD3->D3_TIPO == "BN" 

      _cCta := "401030010001"

Elseif SD3->D3_TIPO == "FE" 

      _cCta := "401020020001"

Elseif SD3->D3_TIPO == "OL" 

      _cCta := "401020020002"

Elseif SD3->D3_TIPO == "MM" 

      _cCta := "401020020003"


Elseif SD3->D3_TIPO == "MQ" 

      _cCta := "401020020004"

Endif

Return(_cCta)               

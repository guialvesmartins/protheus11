
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A710FILALM  �Autor  �Alexandre R. Bento� Data �  30/06/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtrar Almoxarifado de materia prima p/ gerar MRP         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A710FILALM()
Local cProduto := paramixb[1]
Local cAlmoxd  := paramixb[2]
Local cAlmoxa  := paramixb[3]
Local aRet :={}     

// ZDK -> Tabela de programa��o de produ��o que gera o PMP 
ZDK->(dbSetOrder(1)) // FILIAL + NUM + REV
IF ZDK->(dbSeek(xFilial("ZDK")+mv_par23))

   If SM0->M0_CODIGO=="IT" //Itesapar       
	   aRet := {'31','32','32'} // 1=Itesapar				
   Else
       If ZDK->ZDK_PLANTA$"1" // WHB
  	      aRet := {'31','32','33'} // 1=Usinagem
       Elseif ZDK->ZDK_PLANTA$"2"		
  	      aRet := {'20','22','2E'} // 2=Fundi��o
       Elseif ZDK->ZDK_PLANTA$"4"		
  	      aRet := {'41','42','43'} // 4=Forjaria
       Elseif ZDK->ZDK_PLANTA$"5"		
  	      aRet := {'51','52','53'} // 5=Virabrequim
       Elseif ZDK->ZDK_PLANTA$"6"		
  	      aRet := {'61','62','63'} // 6=Aluminio
  	   Endif
  	      
   Endif

Endif

Return IIf(Empty(aRet),Nil,aRet)


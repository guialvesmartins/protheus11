
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST153  �Autor  �Jo�o Felipe da Rosa � Data �  28/10/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     � VALIDA O CAMPO CP_ORDEM                                    ���
���          � REQUISICAO ELETRONICA DE MATERIAIS                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHEST153()
Local nCCSCP   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_CC"})  

	//Traz o C.Custo da OS de Manutencao para a Requisi��o
	If !Empty(M->CP_ORDEM)        
	   	STJ->(DbSetOrder(1)) //filial + cod
   		STJ->(DbSeek(xFilial("STJ")+M->CP_ORDEM))
	   	If STJ->(Found())
   			If STJ->TJ_TERMINO=="N"  
   				If upper(FUNNAME())$"MATA105"
   					Acols[n][nCCSCP] := STJ->TJ_CCUSTO //puxa o centro de custo da OS.
				ElseIf upper(FUNNAME())$"NHEST105"
					M->CP_CC := STJ->TJ_CCUSTO //puxa o centro de custo da OS.
				EndIf   		
			Else
				alert("Ordem de Servi�o j� Finalizada!")
				Return .F.
			EndIf
		Else
   			alert("Ordem de Servi�o n�o encontrada!")
   			Return .F.
	   	Endif
	Endif

Return .T.
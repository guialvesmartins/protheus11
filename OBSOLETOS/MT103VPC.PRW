/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � MT103VPC        � Alexandre R. Bento    � Data �03.08.2007���
������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada p/validar Se ja foi aprovada a A.Entrega ���
���          � na busca do pedido via F5/F6 na entrada da N.F.           ���
������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                  ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

#Include "rwmake.ch"    

User Function  MT103VPC()
Local _lRet := .T.				

/*
SZU->(DbSetOrder(4))//Filial + num autorizacao entrega + item da auto de entrega + nivel
SZU->(DbSeek(xFilial("SZU")+SC7->C7_NUM + SC7->C7_ITEM )) // Verifica se j� existe aprovacao para autorizacao de entrega
If SZU->(Found())   
   While SZU->(!Eof()) .And. SZU->ZU_NUMPED+SZU->ZU_ITEMPED == SC7->C7_NUM+SC7->C7_ITEM
      If !SZU->ZU_STATUS$"A" //autorizacao de entrega sem aprova��o
         _lRet := .F.
         Exit //Forca a saida pois nao foi totalmente aprovada a autorizacao de entrega
      Else
         _lRet := .T.         
      Endif
      SZU->(DbSkip())
   Enddo   
Endif
//ALERT("MT103VPC4 " ) 
  */
Return(_lRet)


 /*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � MTA120E  �Autor  � Alexandre R. Bento    � Data � 05/01/2003���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada antes da exclus�o do pedido de compra      ���
���          � Grava um historico do mesmo SZ2                             ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe   � MTA120E                                                     ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Depto de Compras                                            ���
��������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ���
��������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                    ���
��������������������������������������������������������������������������Ĵ��
���              �        �      �                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/


#include "rwmake.ch"

User Function MTA120E()

SetPrvt("nRegSC7,cPed,x")

nRegSC7 := SC7->(Recno())      
cPed    := SC7->C7_NUM 
x       := 1

//cJust := Acols[i,nPosicao]
SC7->(DbSeek(xFilial("SC7")+CA120NUM,.t.))
While SC7->C7_NUM == CA120NUM
/*
   // Inclus�o do pedido no SZ2 historico de altera��es de pedidos de compra
	RecLock("SZ2",.T.)  //Atualizacao qdo foi alterado
       SZ2->Z2_FILIAL  := xFilial("SZ2")
       SZ2->Z2_PEDIDO  := CA120NUM
	   SZ2->Z2_STATUS  := "EXCLUIDO"
	   SZ2->Z2_EMISSAO := Ddatabase          
       SZ2->Z2_DPRECO   := SC7->C7_PRECO // Preco Unitario de
       SZ2->Z2_PPRECO   := Acols[x][7]   // Preco Unitario para	      
       SZ2->Z2_DQUANT   := SC7->C7_QUANT // Qtde de
       SZ2->Z2_PQUANT   := Acols[x][6]   // Qtde	para      
       SZ2->Z2_DDATA    := SC7->C7_DATPRF// Data de Entrega de
       SZ2->Z2_PDATA    := Acols[x][12]  // Data de Entrega para	      
  	   SZ2->Z2_PRODUTO := SC7->C7_PRODUTO// Produto
	   SZ2->Z2_ITEM    := SC7->C7_ITEM// Item	     
 	   SZ2->Z2_TIPO    := SC7->C7_TIPOPED // Tipo do pedido N=Normal e C=Complementar
	   
   MsUnLock("SZ2") 
*/   
   /////////////  Tira as pendencias para a autorizacao de entrega
   If nTipoped == 2 //1= pedido de compras 2 = autoriza�ao de entrega
	   SZU->(DbSetOrder(4)) //filial + numero da aut. de entrega + item A.E. + Nivel
	   SZU->(DbSeek(xFilial("SZU")+CA120NUM,.t.))
	   If SZU->(Found())
	      While SZU->(!EOF()) .And. SZU->ZU_NUMPED == CA120NUM
	         If SZU->ZU_ORIGEM$"SC7"
	   		    RecLock("SZU",.F.)
	 		       SZU->(DbDelete())
		        MsUnlock("SZU")   
			 Endif
			 SZU->(Dbskip())
		  Enddo 	 
	   Endif
   Endif 
   
   // Abre a pendencia do comprador na solicita��o de compra, apos ter exclu�do o pedido fechado
   SZU->(DbSetOrder(2))
   SZU->(DbSeek(xFilial("SZU")+SC7->C7_NUMSC+SC7->C7_ITEMSC+'9'))
   While !SZU->(Eof()) .AND. SZU->ZU_NUM+SZU->ZU_ITEM == SC7->C7_NUMSC+SC7->C7_ITEMSC
      If Alltrim(SZU->ZU_LOGIN) == Alltrim(cUserName)
		 If SZU->ZU_ORIGEM$"SC1"
			RecLock("SZU",.F.)
			   SZU->ZU_DATAPR := ctod("  /  /  ")
			   SZU->ZU_HORAPR := " "
			   SZU->ZU_STATUS := " "
			MsUnlock("SZU")
		 Endif	
	  Endif
	  SZU->(DbSkip())
   Enddo
	
   x:=x+1
   SC7->(Dbskip())
Enddo

Dbgoto(nRegSC7)       

Return(.T.)


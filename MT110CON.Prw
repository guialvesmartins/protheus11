/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � MT110CON        � Alexandre R. Bento    � Data � 20/09/06 ���
������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada p/ Validar a altera��o e exclusao da SC  ���
���          � Somente pelo usuario que inclui a mesma                   ���
������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                  ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/


#include "rwmake.ch"   

User Function MT110CON()

Local lRet    := .T.
Local _lValSC := GETMV("MV_VALSC") //Valida esta SC .T. = Valida ou .F. = Falso


If _lValSC //valida solicita��o 
	If !Inclui
         SC1->(dbSetOrder(1))		
         SC1->(DbSeek(xFilial("SC1")+CA110NUM))
         If SC1->(Found()) 
   	        If altera
	           If Upper(Alltrim(cUsername)) <> Upper(Alltrim(SC1->C1_SOLICIT)) .and. Upper(Alltrim(cUsername)) <> 'ADMIN'
	              MsgBox( "Altera��o somente � permitida pelo usuario "+ alltrim(SC1->C1_SOLICIT) + " que fez a mesma", "Aten��o", "STOP" )      
	              lRet := .F.
	           Endif
	        ElseIf Upper(Alltrim(cUsername)) <> Upper(Alltrim(SC1->C1_SOLICIT)) .and. Upper(Alltrim(cUsername)) <> 'ADMIN'
	           MsgBox( "Exclus�o somente � permitida pelo usuario "+ alltrim(SC1->C1_SOLICIT) + " que fez a mesma", "Aten��o", "STOP" )      
	           lRet := .F.
	        Endif   
	     Endif    
	Endif                       
Endif

/*
If !Inclui 
	SZU->(DbSetOrder(2))
	SZU->(DbSeek(xFilial("SZU") + SC1->C1_NUM))
	While !SZU->(Eof())	.AND. SZU->ZU_NUM == SC1->C1_NUM
		If SZU->ZU_STATUS=="A" .OR. SZU->ZU_STATUS=="C"
			lRet := .F.
	        If altera
	            MsgBox( "Existe Aprovacao eletronica em adamento, Alterac�o nao autorizada", "Aten��o", "STOP")
			Else
	            MsgBox( "Existe Aprovacao eletronica em adamento, Exclus�o nao autorizada", "Aten��o", "STOP")
			Endif	            
			Exit
		Endif	
		SZU->(DbSkip())	
	Enddo	
Endif	
*/

RETURN(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST066  �Autor  �Marcos R Roquitski  � Data �  18/01/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Relatorio de SC x PEDIDO em Aberto.                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
���Editado   � Felipe Ciconini: Inclu�dos parametros login e endere�o     ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhest066()
Local aPergs := {}

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "SC7"
    oRelato:cPerg    := "EST066"
	oRelato:cNomePrg := "NHEST066"
	oRelato:wnrel    := oRelato:cNomePrg

	//descricao
	oRelato:cDesc1   := "Este relat�rio apresenta a posi��o das solicita��es "
	oRelato:cDesc2   := "de compra, pedidos de compra, pedidos em aberto e "
	oRelato:cDesc3   := "autoriza��o de entrega." 
	
	//tamanho        
	oRelato:cTamanho := "G"  //default "M"

	//titulo
	oRelato:cTitulo  := "SITUA��O DE SOLICITA��O DE COMPRA X PEDIDO DE COMPRA"
      
	//mv_par01
	aAdd(aPergs,{"Do  Produto ?"      ,"C",15,0,"G","","","","","","SB1",""})
	//mv_par02
	aAdd(aPergs,{"Ate Produto ?"      ,"C",15,0,"G","","","","","","SB1",""})
	//mv_par03
	aAdd(aPergs,{"Do  C.Custo ?"      ,"C", 9,0,"G","","","","","","CTT",""})
	//mv_par04
	aAdd(aPergs,{"Ate C.Custo ?"      ,"C", 9,0,"G","","","","","","CTT",""})
	//mv_par05
	aAdd(aPergs,{"Da  Emissao SC ?"   ,"D", 8,0,"G","","","","","","","99/99/9999"})
	//mv_par06
	aAdd(aPergs,{"Ate Emissao SC ?"   ,"D", 8,0,"G","","","","","","","99/99/9999"})
	//mv_par07
	aAdd(aPergs,{"Da  Emissao PC ?"   ,"D", 8,0,"G","","","","","","","99/99/9999"})
	//mv_par08
	aAdd(aPergs,{"Ate Emissao PC ?"   ,"D", 8,0,"G","","","","","","","99/99/9999"})
	//mv_par09
	aAdd(aPergs,{"Da  Data Entrega ?" ,"D", 8,0,"G","","","","","","","99/99/9999"})
	//mv_par10
	aAdd(aPergs,{"Ate Data Entrega ?" ,"D", 8,0,"G","","","","","","","99/99/9999"})
	//mv_par11
	aAdd(aPergs,{"Ponto de Pedido ?"  ,"N", 1,0,"C","Saldo maior","Saldo menor","Ambos","","","",""})	
	//mv_par12
	aAdd(aPergs,{"Lista ?"            ,"N", 1,0,"C","SC / PC","AE / PCA","","","","",""})
	//mv_par13
	aAdd(aPergs,{"De Login ?"		  ,"C",14,0,"G","","","","","","QAA",""})
	//mv_par14
	aAdd(aPergs,{"At� Login ?"        ,"C",14,0,"G","","","","","","QAA",""})
	//mv_par15
	aAdd(aPergs,{"Do Armaz�m ?"		  ,"C", 2,0,"G","","","","","","",""})
	//mv_par16
	aAdd(aPergs,{"At� Armaz�m ?"	  ,"C", 2,0,"G","","","","","","",""})


	oRelato:AjustaSx1(aPergs)
	
	//cabecalho      
	oRelato:cCabec1  := ""
    oRelato:cCabec2  := ""
		    
	oRelato:Run({||Imprime()})

Return

//���������������������Ŀ
//� FUNCAO DE IMPRESSAO �
//�����������������������
Static Function Imprime()
Local _lOk := .F.               
Local cDesc := ''

	If mv_par12==1
		oRelato:cCabec1 := " Cod.             Descricao                       Pedido  Qt.Pedido  Data Prev     Codigo Fornecedor                      SC      Emissao     Qtde SC    Estoque   P.Pedido   Vlr Unit. Solicitante     Tel Fornec"
		Processa( {|| Gera1()   },"Gerando Dados para a Impressao")
	ElseIf mv_par12==2
		oRelato:cCabec1 := " Cod.             Descricao                         A.E.  Saldo A.E  Data Prev     Codigo Fornecedor                      PCA     Emissao   Saldo PCA    Estoque   P.Pedido   Vlr Unit. Tel Fornec."
		Processa( {|| Gera2()   },"Gerando Dados para a Impressao")
	EndIf

	ProcRegua(0)

	// imprime cabe�alho
	oRelato:Cabec()

	SB1->(dbSetOrder(1)) // FILIAL + COD
	SZU->(DbSetOrder(2))
	SA2->(DbSetOrder(1))
	DbSelectArea("TMP1")
	dbgotop()
   
	While TMP1->(!eof())
    	If Prow() > 60
    		oRelato:Cabec()
    	EndIf

		//FILTRA POR PONTO DE PEDIDO    	
   		If mv_par11<>3 //diferente de ambos
			If SB2->(dbSeek(xFilial("SB2")+TMP1->B1_COD+TMP1->B1_LOCPAD))
			    If mv_par11==1 //saldo maior ou igual ao ponto de pedido
					If (SB2->B2_QATU-SB2->B2_QEMPSA) < TMP1->B1_EMIN
						TMP1->(dbSkip())
						Loop
					EndIf
			    ElseIf mv_par11==2 //saldo menor que o ponto de pedido
				    If (SB2->B2_QATU - SB2->B2_QEMPSA) >= TMP1->B1_EMIN
				    	TMP1->(dbSkip())
				    	Loop
				    EndIf
			    EndIF
			EndIf
		EndIf
    	
    	If mv_par12==1 //SC / PC
			If TMP1->C1_PEDIDO <> ' ' .And. TMP1->C1_PEDIDO <> TMP1->C7_NUM  // SC Atendida
				TMP1->(DbSkip())
				Loop
			Endif
		EndIf
	
		_lOk := .F. //aprovacao
		SZU->(DbSetOrder(2))
		SZU->(DbSeek(xFilial("SZU")+TMP1->C1_NUM+TMP1->C1_ITEM))
		While !SZU->(Eof()) .And. SZU->ZU_NUM+SZU->ZU_ITEM == TMP1->C1_NUM+TMP1->C1_ITEM .AND. EMPTY(TMP1->C7_FORNECE)
			If SZU->ZU_STATUS == "C"
				_lOk := .T.
				Exit
			Endif
			SZU->(DbSkip())
		Enddo
	
		If _lOk
			DbSelectArea("TMP1")
			TMP1->(DbSkip())
			Loop
		Endif

		@ Prow() +1, 001 Psay TMP1->B1_COD
		cDesc := OemToAnsi(ALLTRIM(TMP1->C1_DESCRI))
  		cDesc := SUBSTR(cDesc,1,30)
    	cDesc := StrTran(cDesc,chr(9),'')
		@ Prow()   , 018 Psay Iif(!Empty(TMP1->C1_DESCRI),cDesc, " ")//Substr(ALLTRIM(TMP1->C1_DESCRI),1,30)
		//@ Prow()   , 018 Psay OemToAnsi(TMP1->C1_DESCRI,1,30)
		If !Empty(TMP1->C7_NUM)
		
			@ Prow()   , 050 Psay OemtoAnsi(TMP1->C7_NUM)
			@ Prow()   , 058 Psay (TMP1->C7_QUANT - TMP1->C7_QUJE)   Picture "@E 99,999.99" //saldo pedido, ou saldo ae
			@ Prow()   , 069 Psay TMP1->C7_DATPRF //data prevista
			@ Prow()   , 080 Psay TMP1->C7_FORNECE+"/"+TMP1->C7_LOJA
	
			If SA2->(DbSeek(xFilial("SA2")+TMP1->C7_FORNECE+TMP1->C7_LOJA),Found()) 
				@ Prow()   , 090 Psay OemToAnsi(Substr(SA2->A2_NOME,1,30)) //desc fornecedor
			Endif
		Else
			@ Prow()   , 050 Psay "  --"
			@ Prow()   , 058 Psay "     --" //saldo pedido, ou saldo ae
			@ Prow()   , 069 Psay "   --" //data prevista
			@ Prow()   , 080 Psay "   --"                                              
			@ Prow()   , 090 Psay "              --" //desc fornecedor
		Endif
		@ Prow()   , 122 Psay TMP1->C1_NUM //numero da sc
		@ Prow()   , 130 Psay TMP1->C1_EMISSAO //emissao da sc
	    
    	If mv_par12==1
	    	@ Prow()   , 140 Psay TMP1->C1_QUANT Picture "@E 999999.99" //quant sc
	    ElseIf mv_par12==2
	    	@ Prow()   , 140 Psay TMP1->C1_QUANT - TMP1->C1_QUJE Picture "@E 9999999.99" //saldo pca
	    EndIf
	
		SB2->(dbSeek(xFilial("SB2")+TMP1->B1_COD+TMP1->B1_LOCPAD))
		@ Prow()   , 151 Psay (SB2->B2_QATU - SB2->B2_QEMPSA) Picture "@E 999999.99" //estoque
	
		@ Prow()   , 162 Psay TMP1->B1_EMIN		Picture "@E 999999.99"
		@ Prow()   , 173 Psay TMP1->C1_VUNIT	Picture "@E 999,999.99" 
		If mv_par12==1
	    	@ Prow()   , 184 Psay TMP1->C1_SOLICIT
	    	@ Prow()   , 200 Psay Substr(TMP1->A2_TEL,1,17)
	    ElseIf mv_par12==2
	    	@ Prow()   , 184 Psay Substr(TMP1->A2_TEL,1,17)
	    EndIf
	    //@ Prow()   , 203 Psay TMP1->A2_TEL
		TMP1->(dbSkip())
		
 	EndDo

	TMP1->(DbCloseArea())

Return

//������������������������������Ŀ
//� GERA OS DADOS PARA IMPRESSAO �
//��������������������������������
Static Function Gera1()                       

	ProcRegua(0)
	IncProc()
	
	cQuery := "SELECT B1.B1_COD, C7.C7_NUM, C7.C7_QUANT, C7.C7_QUJE, C7.C7_DATPRF, C7.C7_FORNECE, C7.C7_LOJA, "
	cQuery += " B1.B1_DESC,B1.B1_EMIN, B1.B1_LOCPAD, B1.B1_ESTSEG, 
	cQuery += " C1.C1_NUM, C1.C1_ITEM, C1.C1_EMISSAO, C1.C1_QUANT, C1.C1_DESCRI, C1.C1_PEDIDO, C1.C1_SOLICIT, C1.C1_LOCAL, C1.C1_VUNIT, "
	
	cQuery += " A2_TEL = ( SELECT TOP 1 A2_TEL FROM "+RetSqlName("SA2")+" A2 (NOLOCK) WHERE  A2.A2_FILIAL  = '"+xFilial("SA2")+"' AND A2.D_E_L_E_T_ = ''"
	cQuery += " AND C7_FORNECE = A2_COD "
	cQuery += " AND C7.C7_LOJA = A2.A2_LOJA ) "
                
	cQuery += " FROM "+RetSqlName("SC1")+" C1 (NOLOCK) "
	
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 (NOLOCK) ON " 
	cQuery += "     C1.C1_PRODUTO = B1.B1_COD "
    cQuery += " AND B1.B1_FILIAL  = '"+xFilial("SB1")+"' AND B1.D_E_L_E_T_ = ''"

	cQuery += " LEFT JOIN " + RetSqlName("SC7")+" C7 (NOLOCK) ON "
    cQuery += "     C1.C1_FILIAL = C7.C7_FILIAL "
	cQuery += " AND C1.C1_NUM    = C7.C7_NUMSC"
	cQuery += " AND C1.C1_ITEM   = C7.C7_ITEMSC"
	cQuery += " AND C1.C1_PEDIDO = C7.C7_NUM"
	cQuery += " AND C7.C7_RESIDUO = ' '" //nao pega eleminado residuo = 'S'
	cQuery += " AND C7.C7_QUANT  <> C7.C7_QUJE"
	cQuery += " AND C7.C7_FILIAL  = '"+xFilial("SC7")+"' AND C7.D_E_L_E_T_ = ''"
	cQuery += " AND C7.C7_EMISSAO BETWEEN '"+DtoS(mv_par07)+"' AND '"+DtoS(mv_par08)+"'"	
	cQuery += " AND C7.C7_DATPRF  BETWEEN '"+DtoS(mv_par09)+"' AND '"+DtoS(mv_par10)+"'"
   /*		
	cQuery += " LEFT JOIN "+RetSqlName("QAA")+" QAA (NOLOCK) ON "
	cQuery += "     QAA_FILIAL = '"+XFILIAL('QAA')+"'"
	cQuery += " AND C1.C1_SOLICIT = QAA.QAA_LOGIN"  
	//cQuery += " AND QAA.QAA_MAT BETWEEN '"+mv_par13+"' AND '"+mv_par14+"'"
	cQuery += " AND QAA.QAA_LOGIN BETWEEN '"+Alltrim(mv_par13)+"' AND '"+Alltrim(mv_par14)+"'"
	*/
	cQuery += " WHERE C1.C1_RESIDUO = ' '" //nao pega eleminado residuo = 'S'
	cQuery += " AND C1.C1_APROV  <> 'R'" //nao pega quando estiver rejeitado
	cQuery += " AND C1.C1_FILIAL  = '"+xFilial("SC1")+"' AND C1.D_E_L_E_T_ = ''"	
	cQuery += " AND C1.C1_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND C1.C1_CC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND C1.C1_EMISSAO BETWEEN '"+DtoS(mv_par05)+"' AND '"+DtoS(mv_par06)+"'"
	cQuery += " AND C1.C1_LOCAL   BETWEEN '"+mv_par15+"' AND '"+mv_par16+"'"
	
	// Adicionado em 26/05/14
	cQuery += " AND C1.C1_SOLICIT BETWEEN '"+Alltrim(mv_par13)+"' AND '"+Alltrim(mv_par14)+"'"
	
	MemoWrit('C:\TEMP\EST066.SQL',cQuery)
    TCQUERY cQuery NEW ALIAS "TMP1" 

	TcSetField("TMP1","C7_DATPRF" ,"D")  // Muda a data de digita�ao de string para date    
	TcSetField("TMP1","C1_EMISSAO","D")  // Muda a data de digita�ao de string para date    
	TcSetField("TMP1","C7_EMISSAO","D")  // Muda a data de digita�ao de string para date    

    DbSelectArea("TMP1")

Return

//������������������������������Ŀ
//� GERA OS DADOS PARA IMPRESSAO �
//��������������������������������
Static Function Gera2()

	ProcRegua(0)
	IncProc()
	
	cQuery := "SELECT B1.B1_COD, C7.C7_NUM, C7.C7_QUANT, C7.C7_QUJE, C7.C7_DATPRF, C7.C7_FORNECE, C7.C7_LOJA, "
	cQuery += " B1.B1_DESC,B1.B1_EMIN, B1.B1_LOCPAD, B1.B1_ESTSEG, " 
	cQuery += " C3.C3_NUM AS C1_NUM, C3.C3_ITEM AS C1_ITEM, C3.C3_EMISSAO AS C1_EMISSAO, "
	cQuery += " C3.C3_QUANT AS C1_QUANT, C3.C3_QUJE AS C1_QUJE, C3.C3_DESCRI AS C1_DESCRI, C3.C3_PRECO AS C1_VUNIT, "
	
	cQuery += " A2_TEL = ( SELECT TOP 1 A2_TEL FROM "+RetSqlName("SA2")+" A2 (NOLOCK) WHERE  A2.A2_FILIAL  = '"+xFilial("SA2")+"' AND A2.D_E_L_E_T_ = ''"
	cQuery += " AND C7_FORNECE = A2_COD "
	cQuery += " AND C7.C7_LOJA = A2.A2_LOJA ) "
	
	cQuery += " FROM "+RetSqlName("SC3")+" C3 (NOLOCK) " 

	cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 (NOLOCK) ON "
	cQuery += " 	B1.B1_FILIAL  = '"+xFilial("SB1")+"' "
	cQuery += " AND B1.D_E_L_E_T_ = '' "
	cQuery += " AND C3.C3_PRODUTO = B1.B1_COD "
	
	cQuery += " LEFT JOIN " + RetSqlName("SC7") + " C7 (NOLOCK) ON "
	cQuery += " 	C3.C3_NUM     = C7.C7_NUMSC"
	cQuery += " AND C3.C3_ITEM    = C7.C7_ITEMSC"
	cQuery += " AND C7.C7_FILIAL  = '"+xFilial("SC7")+"' AND C7.D_E_L_E_T_ = ''"
	cQuery += " AND C7.C7_RESIDUO = ' '" //nao pega eleminado residuo = 'S'
	cQuery += " AND C7.C7_QUANT  <> C7.C7_QUJE"
	cQuery += " AND C7.C7_TIPO = '2'"
	cQuery += " AND C7.C7_CC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND C7.C7_EMISSAO BETWEEN '"+DtoS(mv_par07)+"' AND '"+DtoS(mv_par08)+"'"	
	cQuery += " AND C7.C7_DATPRF  BETWEEN '"+DtoS(mv_par09)+"' AND '"+DtoS(mv_par10)+"'"

	cQuery += " WHERE AND C3.C3_FILIAL  = '"+xFilial("SC3")+"' AND C3.D_E_L_E_T_ = ''"
	cQuery += " AND C3.C3_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND C3.C3_RESIDUO = ' '" //nao pega eleminado residuo = 'S'
	
    TCQUERY cQuery NEW ALIAS "TMP1" 

	MemoWrit('C:\TEMP\EST066.SQL',cQuery)

	TcSetField("TMP1","C7_DATPRF" ,"D")  // Muda a data de digita�ao de string para date    
	TcSetField("TMP1","C7_EMISSAO","D")  // Muda a data de digita�ao de string para date    

    DbSelectArea("TMP1")

Return
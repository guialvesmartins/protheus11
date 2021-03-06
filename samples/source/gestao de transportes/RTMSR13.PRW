#include "fivewin.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RTMSR13  � Autor �Gilson da Silva        � Data � 29/09/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Seleciona cheques vinculados a viagem para impressao       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGATMS                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RTMSR13()

Local aArea 		:= GetArea()  
Local cPerg 		:= "RTMR13" 
Local cViagem     := ""
Local cNumCtc     := ""  
Local cOrigem     := "" //Programa que chamou essa rotina  
Local cPrefixo    := TMA250GerPrf(cFilAnt)
Local aRotAux     := AClone(aRotina)

Private cCadastro := "Impressao de Cheques"
Private cFiltro   := ""  
Private cMarca		:= ""     
Private lAllMark  := .F.  
Private aIndex 	:= {}
Private aRotina	:= { { "Imprimir","U_RTM13Imp",0,1}} //"Imprime"
Private aCampos	:= {}
Private bFiltraBrw:= {|| FilBrowse("SEF",@aIndex,@cFiltro) } 

If Substr(FunName(),1,7) == "TMSA144"
	cViagem	:= DTQ_VIAGEM   
	cOrigem  := "1" //Chamada da Rotina de Viagem
ElseIf FunName() == "TMSA250"  
	cViagem	:= DTY->DTY_VIAGEM 
	cNumCtc	:= DTY->DTY_NUMCTC
	cOrigem  := "2" //Chamada da Rotina de Contrato de Carreteiro
EndIf	 
 
//�������������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                          �
//� mv_par01      // Mostra Cheques ?  1=Ja Impressos   2=Nao Impressos    3=Ambos�
//���������������������������������������������������������������������������������  
RTM13ChSx1(cPerg)
If Pergunte("RTMR13",.T.) 
	DbSelectArea("SEF")
	//Monta o Filtro para exibir somente os cheques da Viagem selecionada respeitando o parametro.
	cFiltro := "EF_FILIAL == '"  + xFilial("SEF") + "' .And. "
	cFiltro += "EF_NUM <> ' ' .And. "
		
	If cOrigem == "1"  //Chamada da Rotina de Viagem
		cFiltro += "EF_TITULO == '"  + cViagem + "' .And. "   //Imprime os cheques informados no Adiantamento
	Else	//Chamada da Rotina de Contrato de Carreteiro
		cFiltro += "( EF_TITULO == '"  + cNumCtc + "' .Or. "  //Imprime os cheques informados no pagamento do saldo
		cFiltro += "  EF_TITULO == '"  + cViagem + "' ) .And. "   //Imprime os cheques informados no Adiantamento
	EndIf
	
	If mv_par01 == 1 //Mostra somente os cheques que ja foram impressos
		cFiltro += "EF_IMPRESS == 'S' .And. "  
	ElseIf mv_par01 == 2	//Mostra somente os cheques que nao foram impressos
	   cFiltro += "Empty(EF_IMPRESS) .And. "
	EndIf   
	cFiltro += "EF_PREFIXO == '" + cPrefixo + "'"
	
	// Estabelece os campos a serem exibidos na MSSELECT
	Aadd( aCampos, { "EF_OK", "", "", "" } )	
	Aadd( aCampos, { "EF_BANCO", "", "Banco", "" } )	 
	Aadd( aCampos, { "EF_AGENCIA", "", "Agencia", "" } )
	Aadd( aCampos, { "EF_CONTA", "", "Conta", "" } )		
	Aadd( aCampos, { "EF_NUM", "", "Num Chq.", "" } )	
	Aadd( aCampos, { "EF_VALOR", "", "Valor", "@E 999,999,999.99" } )	          
	Aadd( aCampos, { "EF_DATA", "", "Data Emis.", "" } )	
		
	cMarca := GetMark()
	Eval(bFiltraBrw)
	MarkBrow("SEF","EF_OK","",aCampos,,cMarca,"U_RTM13MAll(@lAllMark)")
	EndFilBrw("SEF",aIndex)  
	DbClearFilter()
EndIf  

//��������������������������������������������������������������Ŀ
//� Restaura condicao anterior do arquivo                        �
//����������������������������������������������������������������
RestArea(aArea)

aRotina := AClone(aRotAux)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RTM13MAll � Autor � Gilson da Silva       � Data �29.09.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Marca / Desmarca todos os registros.                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RTM13MAll(ExpL1)                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpL1 - Controla se Marca/Desmarca todos os registros      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nil                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������*/
User Function RTm13MAll(lAllMark)

If lAllMark
	ResetInvert()
Else
	SetInvert()
EndIf
lAllMark := !lAllMark
MarkBRefresh()  
Return nil                          


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RTM13IMP  � Autor � Gilson da Silva       � Data �29.09.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime os cheques selecionados para impressao.            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RTM13IMP()                                                 ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nil                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������*/
User Function RTm13Imp()

Local cFil     := cFiltro + " .And. EF_OK == cMarca" 
Local cDesc1	:= "Este programa imprime os cheques com o valor liquido a pagar"
Local cDesc2	:= "das despesas vinculadas a Viagem."
Local cString	:= "SEF"				//alias do arquivo principal (Base)
Local aOrd		:= {}               //Ordem do Relatorio               

Private lLayOut:= .F. 	//--Variavel usada ImpCheq            
PRIVATE lComp  := .T.	//--Variavel usada ImpCheq  
Private lTeste := .F.	//--Variavel usada ImpCheq   
Private cBenef          //--Variavel usada ImpCheq    
PRIVATE nLinVlr := 0    //--Variavel usada ImpCheq  

/*
�������������������������������������������������������������Ŀ
� Define Variaveis Private(Basicas)						       	  �
���������������������������������������������������������������*/
Private aReturn	:= {"Zebrado", 1,"Administra��o", 2, 2, 1, "",1 }	
Private nomeprog	:= "RTMSR13"
Private nLastKey	:= 0

/* 
����������������������������������������������������������Ŀ 
� Variaveis Utilizadas na funcao IMPR 					        � 
������������������������������������������������������������*/ 
Private TITULO		:= "Impressao de Cheques" 
Private nTamanho	:= "M"   

dbSelectArea( "SEF" )
Set Filter To &(cFil)                     
DbGotop() 
ProcRegua( RecCount() )

//-- Preparar a Impressora  chamar set printer e setdefault
/*
��������������������������������������������������������������Ŀ
� Envia controle para a funcao SETPRINT			    			   �
����������������������������������������������������������������*/
wnrel:="RTMSR13"	//Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,/*cPerg*/,@TITULO,cDesc1,cDesc2,,.F.,aOrd,,nTamanho,,.F.)

IF nLastKey = 27                                           
	Return
EndIF

SetDefault(aReturn,cString)

IF nLastKey = 27                                                 '
	Return
EndIF

RptStatus( {|lEnd| RTM13PRCH(@lEnd,wnRel,cString)}, TITULO ) 
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RTM13PRCH � Autor � Gilson da Silva       � Data �29.09.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime os cheques selecionados para impressao.            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RTM13PRCH(lExp1, wExp2, cExp3)                             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nil                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������*/
Static Function RTM13PRCH(lEnd,WnRel,cString)  

Local aArea      := GetArea()
Local lFa480Bene := ExistBlock("FA480BENE")

While !Eof()
   IncProc()
	
	//-- Cancelado pelo operador.
	If lEnd
		Exit
	EndIf
             
	If SEF->EF_OK != cMarca
		dbSelectArea("SEF")
		dbSkip()
		Loop
	EndIf

	If lFa480Bene
		cBenef := ExecBlock("FA480BENE",.F.,.F.)
	Else
		cBenef := SEF->EF_BENEF
	Endif 
	
	SA6->(dbSetOrder(1))
	SA6->(dbSeek(xFilial("SA6") + SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA)))

	ImpCheq(SEF->EF_BANCO,SEF->EF_AGENCIA,SEF->EF_CONTA,.F.,xFilial("SEF"),1) 
	dbSelectArea("SEF")
	dbSkip()
EndDo	    
//��������������������������������������������������������������Ŀ
//� Termino do relatorio                                         �
//����������������������������������������������������������������
dbSelectArea( "SEF" )
dbSetOrder(1)
Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif
MS_FLUSH()
RestArea(aArea)  
DbClearFilter()
Eval(bFiltraBrw)  
Return
 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RTm13ChSx1� Autor � Gilson da Silva       � Data �29.09.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ajusta o Grupo de Perguntas no dicionario SX1.             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RTm13ChSx1(cExp1)                                          ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nil                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������*/
Static Function RTm13ChSx1 (cGrupSX1)
PutSx1(cGrupSX1, "01","Mostra Cheques ?","Mostra Cheques ?","Mostra Cheques ?","mv_ch1","N" ,1,0,2,"C","","","","","mv_par01","J� Impressos","J� Impressos","J� Impressos","","N�o Impressos","N�o Impressos","N�o Impressos","Ambos","Ambos","Ambos") //"Mostra Cheques j� Impressos ?"
Return	
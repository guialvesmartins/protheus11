#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHPCP015   �Autor �Jo�o Felipe         � Data �  16/06/2008���
�������������������������������������������������������������������������͹��
���Desc.     � RELATORIO DE PERFORMANCE DE FORNECEDORES		              ���
�������������������������������������������������������������������������͹��
���Uso       � PCP                                                        ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA � MOTIVO                                          ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHPCP015()   
Local aPergs := {}

	oRelato          := Relatorio():New()

	oRelato:cString  := "ZA9"
    oRelato:cPerg    := "PCP015"
	oRelato:cNomePrg := "NHPCP015"
	oRelato:wnrel    := oRelato:cNomePrg

	//descricao
	oRelato:cDesc1   := "Este   relatorio   tem   como   objetivo  Imprimir "
	oRelato:cDesc2   := "a performance geral dos fornecedores dentro do ano."
	oRelato:cDesc3   := ""
	
	//tamanho
//	oRelato:cTamanho := "G"  //default "M"

	//titulo
	oRelato:cTitulo  := "RELAT�RIO DE PERFORMENCE DOS FORNECEDORES"

	//cabecalho
	oRelato:cCabec1  := " Fornecedor - Descri��o"
    oRelato:cCabec2  := "     Item                                                               Previsao       Entregue      Diferen�a  Performance"

	aAdd(aPergs,{"De Fornecedor ?"  ,"C", 6,0,"G",""      ,""       ,"","","","SA2",""    }) //mv_par01
	aAdd(aPergs,{"Ate Fornecedor ?" ,"C", 6,0,"G",""      ,""       ,"","","","SA2",""    }) //mv_par02
	aAdd(aPergs,{"De Loja ?"        ,"C", 2,0,"G",""      ,""       ,"","","",""   ,""    }) //mv_par03
	aAdd(aPergs,{"Ate Loja ?"       ,"C", 2,0,"G",""      ,""       ,"","","",""   ,""    }) //mv_par04
	aAdd(aPergs,{"Periodo ?"        ,"N", 1,0,"C","Mensal","Semanal","","","",""   ,""    }) //mv_par05
	aAdd(aPergs,{"De Semana ?"      ,"N", 2,0,"G",""      ,""       ,"","","",""   ,"99"  }) //mv_par06
	aAdd(aPergs,{"Ate Semana ?"     ,"N", 2,0,"G",""      ,""       ,"","","",""   ,"99"  }) //mv_par07
	aAdd(aPergs,{"De Mes ?"         ,"N", 2,0,"G",""      ,""       ,"","","",""   ,"99"  }) //mv_par08
	aAdd(aPergs,{"Ate Mes ?"        ,"N", 2,0,"G",""      ,""       ,"","","",""   ,"99"  }) //mv_par09
	aAdd(aPergs,{"Ano ?"            ,"C", 4,0,"G",""      ,""       ,"","","",""   ,"9999"}) //mv_par10
	
	oRelato:AjustaSx1(aPergs)		    

	oRelato:Run({||Imprime()})
	
Return

//���������������������Ŀ
//� FUNCAO DE IMPRESSAO �
//�����������������������
Static Function Imprime()
Local aMat := {}
_cNum   := "" 
dDtIni  := CTOD("  /  /  ")
dDtFim  := CTOD("  /  /  ")
_nTEntr := 0 //total entregue
_nTPrev := 0 //total previsto  
_nEntr  := 0
_nPrev  := 0
_nTEntGeral := 0
_nTPrvGeral := 0 
_cdescprod := ""

	
	If mv_par05==2 //semanal
		If mv_par07 < mv_par06 
			Alert("Semana final n�o pode ser menor que semana inicial!")
			Return
		EndIf
	EndIf
	
	If mv_par05==1 //mensal
		If mv_par09 < mv_par08
			Alert("M�s final n�o pode ser menor que m�s inicial!")
			Return
		EndIF
	
		If mv_par09 < 1 .or. mv_par09 > 12 .or. ;
		   mv_par08 < 1 .or. mv_par08 > 12
			Alert("O m�s informado � inv�lido!")
			Return
		EndIf
	EndIf
	
	If len(mv_par10) < 4
		Alert("Informe o ano com 4 d�gitos!")
		Return
	EndIF

	If mv_par05==1 //Mensal
		oRelato:cTitulo += " DO MES "+Upper(MesExtenso(StrZero(mv_par08,2)))+" AT� "+Upper(MesExtenso(StrZero(mv_par09,2)))+ " DE "+mv_par10
		dDtIni := CtoD("01/"+StrZero(mv_par08,2)+"/"+mv_par10)
		dDtFim := UltimoDia(CtoD("01/"+StrZero(mv_par09,2)+"/"+mv_par10))
	ElseIf mv_par05==2 //Semanal
		oRelato:cTitulo += " DA SEMANA "+StrZero(mv_par06,2)+" AT� "+StrZero(mv_par07,2)+ " DE "+mv_par10
		dDtIni := fDatSem(mv_par06,mv_par10) //retorna o primeiro dia da semana //CtoD("01/"+StrZero(ZA9->ZA9_MES,2)+"/"+StrZero(ZA9->ZA9_ANO,4))
		dDtFim := fDatSem(mv_par07,mv_par10) + 6 //retorna o primeiro dia da semana + 6 para pegar o ultimo dia da semana //UltimoDia(dDtIni)
	EndIF

	oRelato:Cabec()

	DbSelectArea('SA2')
	DbSetOrder(1) //filial + forn + loja
	DbGoTop()
	
	DbSelectArea('ZA9')
	DbSetOrder(1) //filial + num
	ZA9->(DbSeek(xFilial('ZA9'))) // filial
	DbGoTop()
	
	DbSelectArea('ZA0')
	DbSetOrder(1) //filial + num + item
	ZA0->(DbSeek(xFilial('ZA0'))) // filial
	DbGoTop()
	
	SB1->(DBSETORDER(1))
  
	SETREGUA(ZA9->(RECCOUNT()))

	While ZA9->(!Eof()) .AND. (ZA9->ZA9_FILIAL = SM0->M0_CODFIL)
	
		INCREGUA()
	
		//�����������������������Ŀ
		//� FILTRA POR FORNECEDOR �
		//�������������������������
		If ZA9->ZA9_FORNEC < mv_par01 .Or. ZA9->ZA9_FORNEC > mv_par02
			ZA9->(DBSKIP())
			Loop
		EndIf
		
		//�����������������Ŀ
		//� FILTRA POR LOJA �
		//�������������������
		If ZA9->ZA9_LOJA < mv_par03 .Or. ZA9->ZA9_LOJA > mv_par04
			ZA9->(DBSKIP())
			Loop
		EndIf
	
		//������������������
		//� FILTRA POR ANO �
		//������������������
		If Val(mv_par10)!=ZA9->ZA9_ANO
			ZA9->(dbSkip())
			Loop
		EndIf
		
		//�����������������Ŀ
		//� FILTRA POR DATA �
		//�������������������
		If ZA9->ZA9_MES < Month(dDtIni) .Or. ZA9->ZA9_MES > Month(dDtFim) //+"/"+STRZERO(ZA9->ZA9_ANO,4) != mv_par06
			ZA9->(DBSKIP())
			Loop
		EndIf
		
		ZA0->(DbSeek(xFilial('ZA0')+ZA9->ZA9_NUM))
		     
		If mv_par05==2 //Semanal
			nIni := 1
			nFim := 31
			If Month(dDtIni)==ZA9->ZA9_MES
				nIni := Day(dDtIni)
			EndIf
			If Month(dDtFim)==ZA9->ZA9_MES
				nFim := Day(dDtFim)
			EndIf
		EndIf
					
		//�����������������������
		//� QUANTIDADE PREVISTA �
		//�����������������������
		While ZA0->ZA0_NUM == ZA9->ZA9_NUM
			
			_nPrev := 0
			For x:=1 to 31
				If (mv_par05==2 .and. x>=nIni .and. x<=nFim) .or. ; //semanal
					mv_par05==1 //mensal
					
					cField := "ZA0->ZA0_PREV"+StrZero(x,2)
					_nPrev += &(cField)
				EndIf
			Next
			
			_n := aScan(aMat,{|x| x[1]==ZA9->ZA9_FORNEC .AND. x[2]==ZA9->ZA9_LOJA .AND. x[3]==ZA0->ZA0_PROD})
			
			If _n!=0
				aMat[_n][4] += _nPrev
			Else
				aAdd(aMat,{ZA9->ZA9_FORNEC,ZA9->ZA9_LOJA,ZA0->ZA0_PROD,_nPrev,0})
			EndIf
		     
			ZA0->(dbSkip())
		EndDo
		
		ZA9->(dbskip())

	EndDo		

	//�����������������������
	//� QUANTIDADE ENTREGUE �
	//�����������������������
    For x:=1 to Len(aMat)
    
    	_nEntr := 0
    	
    	aQtd := fQtdEntr(aMat[x][3],aMat[x][1],aMat[x][2],dDtIni,dDtFim)

    	For y:=1 to Len(aQtd)
    		_nEntr += aQtd[y][2]
    	Next
    	
    	aMat[x][5] := _nEntr

    Next
	
	cForLoj := ""
	
	For x:=1 to Len(aMat)
		If Prow() > 70
			oRelato:Cabec()
		Endif
	
		@Prow()+1, 001 psay aMat[x][1]+" - "+aMat[x][2]
		If SA2->(DbSeek(xFilial('SA2')+aMat[x][1]+aMat[x][2]))
			@Prow()  , 014 psay SA2->A2_NOME
		EndIf
		cForLoj := aMat[x][1]+aMat[x][2]
		
		While x<=Len(aMat) .and. cForLoj==aMat[x][1]+aMat[x][2]
		
			IF SB1->(DBSEEK(XFILIAL("SB1")+aMat[x][3]))
				_cdescprod := SB1->B1_DESC
			ENDIF
	
			@Prow()+1, 005 psay aMat[x][3]+" "+_cdescprod
			@Prow()  , 070 psay aMat[x][4] Picture("@e 9999999") //prevista
			@Prow()  , 085 psay aMat[x][5] Picture("@e 9999999") //entregue
			@Prow()  , 100 psay aMat[x][5]-aMat[x][4] Picture("@e 9999999")
			@Prow()  , 115 psay Transform((aMat[x][5] * 100) / aMat[x][4],"@e 999") + "%"

			_nTPrev += aMat[x][4]
			_nTEntr += aMat[x][5]
			
			x++
		EndDo  
		x--
	
		@Prow()+1, 001 psay "Total:--> " 
		@Prow()  , 115 psay Transform((_nTEntr * 100)/_nTPrev,"@e 999") + "%"
		@Prow()+1,   0 psay ""
		
		_nTEntGeral += _nTEntr
		_nTPrvGeral += _nTPrev
		
		_nTEntr := 0
		_nTPrev := 0

	Next

	@Prow()+1,000 PSAY __PrtThinLine()
	@Prow()+1, 001 psay "Total:--> "
	@Prow()  , 070 psay _nTPrvGeral Picture("@e 9999999")
	@Prow()  , 085 psay _nTEntGeral Picture("@e 9999999")
	@Prow()  , 113 psay Transform((_nTEntGeral * 100)/_nTPrvGeral,"@e 99999") +"%"

Return(nil)

//�������������������������������������������
//� TRAZ A QUANTIDADE DE ENTRADA DO PRODUTO �
//�������������������������������������������
Static Function fQtdEntr(cProd,cForn,cLoja,dDtIni,dDtFim)
Local aQtd   := {} 
Local dDtRef := dDtIni

	If dDtFim < dDtIni
		alert("dDtFim < dDtIni! Funcao fQtdEntr - NHPCP011")
		return
	EndIf

	While(dDtRef <= dDtFim)
		aAdd(aQtd,{DtoC(dDtRef),0})
		dDtRef++
	EndDo
		
	If Select('TMV') > 0
		TMV->(DbCloseArea())
	EndIF			
	
	IF SM0->M0_CODIGO == "FN" .AND. ;
	   cForn == '999999' .AND. cLoja == '01' //Se for para fundi��o, pega da ZBB

		cQuery := " SELECT ZBA.ZBA_DATA AS DTDIGIT, SUM(ZBB.ZBB_QUANT) AS QUANT "
		cQuery += " FROM ZBAFN0 ZBA, ZBBFN0 ZBB" //TEM QUE SER DA FUNDICAO
		cQuery += " WHERE ZBA.ZBA_NUM = ZBB.ZBB_NUM"
		cQuery += " AND ZBA.ZBA_DATA BETWEEN '"+DtoS(dDtIni)+"' AND '"+DtoS(dDtFim)+"'"
		cQuery += " AND ZBB.ZBB_COD = '"+cProd+"'"
		cQuery += " AND ZBA.ZBA_STATUS = 'E'"
		cQuery += " AND ZBB.ZBB_FILIAL = '"+XFILIAL("ZBB")+"' AND ZBB.D_E_L_E_T_ = ''"
		cQuery += " AND ZBA.ZBA_FILIAL = '"+XFILIAL("ZBA")+"' AND ZBA.D_E_L_E_T_ = ''"
		cQuery += " GROUP BY ZBA.ZBA_DATA"
		cQuery += " ORDER BY ZBA.ZBA_DATA" 
	Else
		cQuery := "SELECT D1_DTDIGIT AS DTDIGIT, SUM(D1.D1_QUANT) AS QUANT "
		cQuery += " FROM "+RetSqlName("SD1") + " D1, " + RetSqlName( 'SF4' ) +" F4 "
		cQuery += " WHERE D1.D1_COD = '"+cProd+"'"
		cQuery += " AND D1.D1_FORNECE = '"+cForn+"' AND D1.D1_LOJA = '"+cLoja+"'"
		cQuery += " AND D1.D1_DTDIGIT BETWEEN '"+DtoS(dDtIni)+"' AND '"+DtoS(dDtFim)+"'"
	    cQuery += " AND D1.D1_TES = F4.F4_CODIGO"	
	    cQuery += " AND F4.F4_ESTOQUE = 'S'" //somente pega as notas que atualizam estoque
		cQuery += " AND D1.D_E_L_E_T_ = ' '"
	    cQuery += " AND F4.D_E_L_E_T_ = ' '"
	    cQuery += " AND D1.D1_FILIAL = '"+xFilial("SD1")+"'"
	    cQuery += " AND F4.F4_FILIAL = '"+xFilial("SF4")+"'"
	    cQuery += " GROUP BY D1_DTDIGIT"
	    cQuery += " ORDER BY D1_DTDIGIT"
	EndIf
				
	TCQUERY cQuery NEW ALIAS 'TMV'
   	MemoWrit('C:/TEMP/NHPCP015.SQL',cQuery)
	         
	TcSetField("TMV","DTDIGIT","D")  // Muda a data de string para date    
	                   
	While !TMV->(EOF())
		_n := aScan(aQtd,{|x| x[1] == DtoC(TMV->DTDIGIT)})
		If _n!=0
			aQtd[_n][2] := TMV->QUANT
			TMV->(dbSkip())
		EndIf
	EndDo

Return(aQtd)

//�����������������������������������������Ŀ
//� VERIFICA QUAL A PRIMEIRA DATA DA SEMANA �
//�������������������������������������������
Static Function fDatSem(nSem,cAno)
Local nSemana := 1
Local dData := CtoD("01/01/"+cAno)
                        
	While nSemana < nSem
		If DoW(dData)==1 .And. dData!=CtoD("01/01/"+cAno)
			nSemana ++
			dData += Iif(nSemana<nSem,7,0)
		Else
			dData++
		EndIf
	EndDo

Return(dData)
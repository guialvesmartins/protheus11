/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ�� 
���Programa  �NHEST186  �Autor  �Jo�o Felipe da Rosa � Data �  20/04/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � CONTROLE TRANSFERENCIA DE PRODUTOS                         ���
���          � DO ALMOX DE COMPONENTES P/ PROCESSO                        ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE/CUSTOS / PCP / EXPEDI��O                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#include "protheus.ch" 
#include "colors.ch"
#include "AP5MAIL.CH" 
#include "topconn.ch"

User Function NHEST186()

Private cAlias    := "ZEA"
Private aRotina   := {}
Private cCadastro := "Transferencia de Produtos Componentes / Processo"

//AXCADASTRO("ZEA")
//AXCADASTRO("ZEB")

If SM0->M0_CODIGO=='NH' //Usinagem
	Alert('Favor utilizar ambiente Fundi��o!')
	return
Endif

aAdd( aRotina, {"Pesquisar"  ,"AxPesqui"     ,0,1} )
aAdd( aRotina, {"Visualizar" ,"U_fEST186(1)" ,0,2} )
aAdd( aRotina, {"Incluir"    ,"U_fEST186(2)" ,0,3} )
aAdd( aRotina, {"Alterar"    ,"U_fEST186(3)" ,0,4} )
aAdd( aRotina, {"Excluir"    ,"U_fEST186(4)" ,0,5} )
aAdd( aRotina, {"Imprimir"   ,"U_fEST186I()" ,0,5} )
aAdd( aRotina, {"Transferir" ,"U_fEST186T()" ,0,5} )
aAdd( aRotina, {"Legenda"    ,"U_EST186LEG()",0,2} )

dbSelectArea(cAlias)
dbSetOrder(1)

mBrowse(,,,,cAlias,,,,,,fCriaCor())

Return

//������������������Ŀ
//� FUNCAO PRINCIPAL �
//��������������������
User Function fEST186(nParam)
Local bOk         := {||fOk()}
Local bCanc       := {||fEnd()}
Local bEnchoice   := {||}
Private aSize     := MsAdvSize()
Private aObjects  := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo     := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj   := MsObjSize( aInfo, aObjects, .T.)
Private nPar      := nParam
Private aHeader   := {}
Private aCols     := {}
Private cMotivo   := Space(100)
Private aLote     := {}

SetPrvt("_dData,_cNum,_cHora, _cExpedi,_cNomeExp,_cDocTransf,cMotivo,_cLocOri")

If nPar == 2//incluir
	_cNum       := GetSxENum("ZEA","ZEA_NUM")//Traz o novo numero da transferencia fun/usi
	_dData      := Date()
	_cHora      := Time()
	_cObs       := ""
    _cExpedi    := ""
    _cNomeExp   := ""
	_cDocTransf := ""	
	_cLocOri    := space(2)
	
	IF !fExp()//traz o expedidor
		Alert("Usu�rio sem permiss�o")
		Return .F.
	EndIf
    
Else //visualizar, alterar, excluir
	_cNum       := ZEA->ZEA_NUM
	_dData      := ZEA->ZEA_DATA
	_cHora      := ZEA->ZEA_HORA
	_cObs       := ZEA->ZEA_OBS
	_cExpedi    := ZEA->ZEA_EXPEDI 
	_cDocTransf := ZEA->ZEA_DOC
	_cLocOri    := ZEA->ZEA_LOCALO
	
    DbSelectArea("QAA")
    DbSetOrder(1)
    If DbSeek(xFilial("QAA")+_cExpedi)
	    _cNomeExp := QAA->QAA_NOME
	EndIf
	
	//TRAZ OS ITENS DA TRANSFERENCIA
	DbSelectArea("ZEB")
	DbGoTop()
	DbSetOrder(1)//filial + num + item
	
	If DbSeek(xFilial("ZEB")+_cNum)
		While ZEB->(!EOF()) .AND. ZEB->ZEB_NUM == _cNum
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+ZEB->ZEB_COD))
			aAdd(aCols,{ZEB->ZEB_ITEM,;
						ZEB->ZEB_COD,;
						SB1->B1_DESC,;
						ZEB->ZEB_VOLUME,;
						ZEB->ZEB_QUANT,;
						ZEB->ZEB_LOTE,;
						ZEB->ZEB_LOCALI,.F.})
			
			ZEB->(DbSkip())
		EndDo
	EndIf

EndIf

Aadd(aHeader,{"�tem" 	    , "ZEB_ITEM"    ,"@E 9999"           ,04,0,".F.","","C","ZEB"})
Aadd(aHeader,{"Produto"     , "ZEB_COD"     ,"@!"	             ,15,0,"U_EST186PRD()","","C","ZEB"})
Aadd(aHeader,{"Desc"        , "B1_DESC"     ,"@!"	             ,30,0,".F.","","C","SB1"})
Aadd(aHeader,{"Volume"      , "ZEB_VOLUME"  ,"@E 99999999999"    ,14,0,".T.","","N","ZEB"})
Aadd(aHeader,{"Quant"       , "ZEB_QUANT"   ,"@E 99999999999"    ,14,0,"U_EST186SLD()","","N","ZEB"})
Aadd(aHeader,{"Lote"        , "ZEB_LOTE"    ,"@!"                ,10,0,".T.","","C","ZEB"})
Aadd(aHeader,{"Localiza��o" , "ZEB_LOCALI"  ,"@!"                ,15,0,".T.","","C","ZEB"})

If nPar == 5 //Divergencia
	aHeader[2][6] := ".F."
EndIf

DEFINE FONT oFont12 NAME "Arial" SIZE 12, -12 BOLD

bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc,,)}
			
oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Transfer�ncia de Produtos Componentes / Processo",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

@ 020,010 Say "N�mero: "      SIZE 040,008 Object olNum
@ 020,045 Say _cNum           SIZE 040,008 Object oNum
oNum:SetFont(oFont12)

@ 020,100 Say "Data: "        SIZE 040,008 Object olData
@ 018,135 Get _dData          SIZE 040,008 When .F. Object oData

@ 020,190 Say "Hora: "        SIZE 030,008 Object olHora
@ 018,210 Get _cHora          SIZE 040,008 When .F. Object oHora

@ 032,010 Say "Local Origem:" SIZE 040,008 Object olDocTransf
@ 030,045 Get _cLocOri        SIZE 020,008  Object oLocOri
                              
@ 032,190 Say "Doc: "         SIZE 030,008 Object olDocTransf
@ 030,210 Get _cDocTransf     SIZE 040,008 When .F. Object oDocTransf

@ 056,010 Say "Expedidor: "   SIZE 040,008 Object olExpedi
@ 054,045 Get _cExpedi        SIZE 035,008 When .F. Object oExpedi 
@ 054,083 Get _cNomeExp       SIZE 142,008 When .F. Object oNomeExp

@ 068,010 Say "Observa��o: " SIZE 030,008 Object olObs
@ 066,045 Get oObs VAR _cObs MEMO When(nPar == 2 .or. nPar == 3) SIZE 180,030 PIXEL OF oDlg

dbSelectArea("ZEB")
@ 100,aPosObj[2,2] TO aPosObj[2,3],aPosObj[2,4] MULTILINE MODIFY DELETE OBJECT oMultiline VALID fMulti()

//diferente de incluir
If nPar != 2
	oMultiline:nMax := Len(aCols) //n�o deixa o usuario adicionar mais uma linha no multiline
EndIf

oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)
//Activate MsDialog oDlg Center

Return 

//����������Ŀ
//� CONFIRMA �
//������������
Static Function fOk()
	
	/*********
	* INCLUI *
    *********/
    If nPar == 2
    
	    If !fValida()
    	    Return
	    EndIf
    
	    RecLock("ZEA",.T.)
    		ZEA->ZEA_FILIAL := xFilial("ZEA")
    		ZEA->ZEA_NUM    := _cNum
	    	ZEA->ZEA_DATA   := _dData
    		ZEA->ZEA_HORA   := _cHora
    		ZEA->ZEA_OBS    := _cObs
	    	ZEA->ZEA_EXPEDI := _cExpedi
	    	ZEA->ZEA_STATUS := "P"
	    	ZEA->ZEA_DOC    := ""
	    	ZEA->ZEA_LOCALO := _cLocOri
    	MsUnlock("ZEA")
    
	    SB1->(DBSETORDER(1))//FILIAL + COD
    	For _x := 1 to Len(aCols)//percorre o acols
			If !Acols[_x][len(aHeader)+1] //nao pega quando a linha esta deletada
				RecLock("ZEB",.T.)
					ZEB->ZEB_FILIAL := xFilial("ZEB")
					ZEB->ZEB_NUM    := _cNum
					ZEB->ZEB_ITEM   := Acols[_x][1]
					ZEB->ZEB_COD    := Acols[_x][2]
					ZEB->ZEB_VOLUME := Acols[_x][4]
					ZEB->ZEB_QUANT  := Acols[_x][5]
					ZEB->ZEB_LOTE   := Acols[_x][6]
					ZEB->ZEB_LOCALI := Acols[_x][7]
					SB1->(DbSeek(xFilial("SB1")+Acols[_x][2]))
					ZEB->ZEB_UPRC   := SB1->B1_PRV1
				MsUnlock("ZEB")
			EndIf
    	Next
    	
       	//envia email de aviso de embarque
	   	If MsgYesNo("Enviar aviso de embarque?") 
   			fEST186MAIL()
	   	EndIf
    
    	ConfirmSx8()
    	
    EndIf
    
    /**********
    * EXCLUIR *
    **********/
    If nPar == 4
    
   		If ZEA->ZEA_STATUS$"E"
   			Alert("Transfer�ncia j� encerrada!")
   			Return
   		EndIf
   		
   		_cUsr := ALLTRIM(UPPER(CUSERNAME))

  		If !_cUsr$"JOAOFR/ADMINISTRADOR/LEANDROJS"
			QAA->(DbSetOrder(6)) //LOGIN
			If QAA->(DbSeek(_cUsr))
		   	
		   		If QAA->QAA_MAT != ZEA->ZEA_EXPEDI
					Alert("Usu�rio sem permiss�o para excluir!")
					Return .F.   		
		   		EndIf
			Else 
				Alert("Usu�rio sem permiss�o para excluir!")
				Return .F.   		
			EndIf
		EndIf
			
		DbSelectArea("ZEB")
		DbSetOrder(1)
		For _x := 1 to Len(aCols)
			If DbSeek(xFilial("ZEB")+ZEA->ZEA_NUM+aCols[_x][1])
				RECLOCK("ZEB",.F.)
					ZEB->(DbDelete())
				MSUNLOCK("ZEB")
			ENDIf
		Next
		
		RecLock("ZEA",.F.)
			ZEA->(DbDelete())
		MsUnlock("ZEA")
		
    EndIf

	/**********
	* ALTERAR *
	**********/    
    If nPar == 3

   		If ZEA->ZEA_STATUS$"E"
   			Alert("Transfer�ncia j� encerrada!")
   			Return
   		EndIf

  		_cUsr := ALLTRIM(UPPER(CUSERNAME))
  		
  		If !_cUsr$"JOAOFR/ADMINISTRADOR/LEANDROJS"
  		
			QAA->(DbSetOrder(6)) //LOGIN
			If QAA->(DbSeek(_cUsr))
	   	
		   		If QAA->QAA_MAT != ZEA->ZEA_EXPEDI
					Alert("Usu�rio sem permiss�o para alterar!")
					Return .F.   		
		   		EndIf
			Else 
				Alert("Usu�rio sem permiss�o para alterar!")
				Return .F.   		
			EndIf
   		    
		EndIf

	    If !fValida()
   		    Return
    	EndIf
	       
   	    RecLock("ZEA",.F.)
    		ZEA->ZEA_OBS    := _cObs
    		ZEA->ZEA_LOCALO := _cLocOri
    	MsUnlock("ZEA")
    	
    	DbSelectArea("ZEB")
    	DbSetOrder(1)//filial + num + item
    	SB1->(DbSetOrder(1))// FILIAL + COD
    	For _x := 1 to Len(aCols)//percorre o acols
			
			If !Acols[_x][len(aHeader)+1] //nao pega quando a linha esta deletada
				If DbSeek(xFilial("ZEB")+ZEA->ZEA_NUM+aCols[_x][1])
					RecLock("ZEB",.F.)
						ZEB->ZEB_COD    := Acols[_x][2]
						ZEB->ZEB_VOLUME := Acols[_x][4]
						ZEB->ZEB_QUANT  := Acols[_x][5]
						ZEB->ZEB_LOTE   := Acols[_x][6]
						ZEB->ZEB_LOCALI := Acols[_x][7]
						SB1->(DBSEEK(XFILIAL("SB1")+ACOLS[_X][2]))
						ZEB->ZEB_UPRC   := SB1->B1_PRV1
					MsUnlock("ZEB")
				Else
					RecLock("ZEB",.T.)
						ZEB->ZEB_FILIAL := xFilial("ZEB")
						ZEB->ZEB_NUM    := _cNum
						ZEB->ZEB_ITEM   := Acols[_x][1]
						ZEB->ZEB_COD    := Acols[_x][2]
						ZEB->ZEB_VOLUME := Acols[_x][4]
						ZEB->ZEB_QUANT  := Acols[_x][5]
						ZEB->ZEB_LOTE   := Acols[_x][6]
						ZEB->ZEB_LOCALI := Acols[_x][7]
						SB1->(DBSEEK(XFILIAL("SB1")+ACOLS[_X][2]))
						ZEB->ZEB_UPRC   := SB1->B1_PRV1
					MsUnlock("ZEB")
				Endif 
			Else
				If DbSeek(xFilial("ZEB")+ZEA->ZEA_NUM+aCols[_x][1])
					RecLock("ZEB",.F.)
						ZEB->(DbDelete())
					MsUnlock("ZEB")
				EndIf
			EndIf
   		Next
    
    EndIf             

	Close(oDlg)
Return

//��������Ŀ
//�CANCELA �
//����������
Static Function fEnd()
	RollBackSx8()
	Close(oDlg)
Return

//��������������������������Ŀ
//� TRAZ O NOME DO EXPEDIDOR �
//����������������������������
Static Function fExp()

	_cUsr := ALLTRIM(UPPER(CUSERNAME))

	QAA->(DbSetOrder(6)) //LOGIN
	If QAA->(DbSeek(_cUsr))
	   	_cExpedi  := QAA->QAA_MAT
	   	_cNomeExp := QAA->QAA_NOME
	Else
	 	Msgbox(OemToAnsi("Usu�rio n�o cadastrado na lista de usu�rios!"),"Atencao","ALERT" )  
	 	Return .F.
	EndIf
Return .T.

//����������������������������Ŀ
//�TRAZ A DESCRICAO DO PRODUTO �
//������������������������������
User Function EST186PRD()
Local _cCod  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZEB_COD"})
Local _cDesc := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "B1_DESC"})
//Local _cLote := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZEB_LOTE"})
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+M->ZEB_COD)

		Acols[n][_cDesc] := SB1->B1_DESC
		oMultiline:Refresh()

	Else
		Alert("Produto n�o encontrado!")
		Return .F.
	EndIf	

Return .T. 
                                                             
//�����������Ŀ
//� VALIDACAO �
//�������������
Static Function fValida()
Local nPosProd := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZEB_COD"})
          
	If empty(_clocori)
		alert('Informe o Local de Origem!')
		return .f.
	endif
	
	If Len(aCols) <= 1 .AND. Empty(aCols[1][nPosProd])
		Alert("Ao menos um produto deve ser informado!")
		Return .F.
	EndIf
	
	aLote2 := aClone(aLote)
	
	SB1->(DbSetOrder(1)) // FILIAL + COD
	For x:=1 to Len(aCols)
	
		If !acols[x][len(aHeader)+1] //nao pega quando estiver deletado
	
			SB1->(DbSeek(xFilial("SB1")+aCols[x][2]))

			If SB1->B1_RASTRO$"L" .and. EMPTY(aCols[x][6]) //lote
				Alert("Informe o lote para produtos controlados por lote!")
				Return .F.
/*			Else
				//Compara o que foi digitado com o array aLote para ver se existir� saldo para a transfer�ncia
				_n := aScan(aLote2,{|y| y[1]==aCols[x][2] .AND. y[3]==aCols[x][6] .AND. y[5]==aCols[x][7]})
			
				If _n<>0
					If aCols[x][5] > aLote2[_n][4]
						//Caso haja divergencia ele apaga as pe�as e apaga o array aLote
						Alert("Inconsist�ncia na escolha dos lotes, por favor redigite as pe�as!")
						aCols := {{"0001",SPACE(15),"",0,0,SPACE(10),SPACE(15),.F.}} //limpa o acols
						aLote := {}
						oMultiline:Refresh()
						Return .F.
					Else
						aLote2[_n][4] -= aCols[x][5]
					EndIf
				EndIf
*/			EndIf	
		EndIf
	Next 

Return .T.

//����������������������������������������������Ŀ
//� IMPRIME RELATORIO DE TRANSFERENCIA FUN / USI �
//������������������������������������������������
User Function fEST186I()

Agrupo 	  := {}
cString   := ""
cDesc1    := OemToAnsi("Imprime os detalhes da transfer�ncia")
cDesc2    := OemToAnsi("de produtos do Componentes p/ Processo")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST186I" //nome do arquivo
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("ORDEM DE LIBERA��O DE MATERIAIS COMPONENTES / PROCESSO") //t�tulo
cabec1    := "Num. Controle : "+ZEA->ZEA_NUM +Space(20)+"Cliente : WHB USINAGEM" +Space(40)+ZEA->ZEA_HORA+Space(07)+Dtoc(ZEA->ZEA_DATA)
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1 
M_PAG     := 1 //Variavel que acumula numero da pagina 
wnrel     := nomeprog //"NH"
_cPerg    := "" 

Pergunte(_cPerg,.F.)

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

//������������������������Ŀ
//�CHAMADAS PARA AS FUN��ES�
//��������������������������

RptStatus( {|| Imprime()   },"Imprimindo...")

set filter to //remove o filtro da tabela

If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          

MS_FLUSH() //Libera fila de relatorios em spool

Return
//����������������������������������Ŀ
//�FUNCAO PARA IMPRESSAO DO RELAT�RIO�
//������������������������������������

Static Function Imprime()

Local _nTVol //total de volumes

	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

	If Prow() > 65 
		_nPag  := _nPag + 1   
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
  	Endif

	@ prow()+1,000 PSAY __PrtThinLine()        
   
	@Prow()+1, 001 psay "ITEM     PRODUTO           DESCRICAO                                  LOTE      ENDERE�O     VOLUME    QUANTIDADE   QUANT.RECEBIDA"
	
	@Prow()+1, 001 psay ""
	
	DbSelectArea("ZEB") //ITENS DA TRANSFERENCIA
	DbSetOrder(1) //filial + num + item
	If DbSeek(xFilial("ZEB")+ZEA->ZEA_NUM)

		_nTVol := 0
		
		While ZEB->(!EOF()) .AND. ZEB->ZEB_NUM == ZEA->ZEA_NUM
		
			@Prow()+1, 001 psay ZEB->ZEB_ITEM
			@Prow()  , 010 psay ZEB->ZEB_COD
		
			DbSelectArea("SB1")
			DbSetOrder(1) // filial + codigo
			If DbSeek(xFilial("SB1")+ZEB->ZEB_COD)
				@Prow()  , 028 psay Substr(SB1->B1_DESC,1,40)
			EndIf
			
			@Prow()  , 069 psay ZEB->ZEB_LOTE
			@Prow()  , 085 psay Substr(ZEB->ZEB_LOCALI,1,6)
			@Prow()  , 094 psay ZEB->ZEB_VOLUME picture "@e 99999"
			@Prow()  , 107 psay ZEB->ZEB_QUANT picture "@e 99999"
			@Prow()  , 120 psay "___________"
			
			_nTVol += ZEB->ZEB_VOLUME
			
			ZEB->(DbSkip())
			
		EndDo
	EndIf
	
	@Prow()+2, 060 psay "Total de volumes: "
	@Prow()  , 088 psay _nTVol picture "@e 99999"
		 
	@ prow()+1,000 PSAY __PrtThinLine()  
	                            
	QAA->(DbSetOrder(1)) //MAT
	If QAA->(DbSeek(xFilial("QAA")+ZEA->ZEA_EXPEDI))
		@Prow()+1 , 001 psay "Expedidor: "+QAA->QAA_NOME
	EndIf

	@Prow()+7 , 001 psay "Ass. Expedidor:   _______________________________________"
	@Prow()+7 , 001 psay "Ass. Motorista:   _______________________________________"
	@Prow()+7 , 001 psay "Ass. Recebimento: _______________________________________"			
	
	
		
Return 

//�������������������������������������������������Ŀ
//� VERIFICA SE TEM SALDO PARA ENVIAR PARA USINAGEM �
//���������������������������������������������������
User Function EST186SLD()
Local lLote    := .F.
Local lLocaliz := .F.
Local nSaldo   := 0
Local nBfSaldo := 0
//Local cLocOri  
Local aSaldos  := {}

	cProd := Acols[n][2]

	aLote := {}

	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+cProd))
	
	If empty(_clocori)
		Alert("Informe o Local de Origem!")
		return .f.
	Endif
	
	nSaldo := fSaldo(cProd,_cLocOri)
	
	If nSaldo < M->ZEB_QUANT
		Alert("Saldo insuficiente!" +CHR(13)+CHR(10)+"Saldo Atual: "+Transform(nSaldo,"@e 999999"))
		Return .F.
	EndIf
	
	If !Empty(aCols[n][6])
		Alert("Imposs�vel alterar a quantidade, lote j� digitado!")
		Return .F.
	EndIf
	
	//-- gera um array com os saldos por endere�o

	If SB1->B1_LOCALIZ$"S" //TEM CONTROLE POR LOCALIZACAO
	
		lLocaliz := .T.
	
	   	SBF->(DbSetOrder(2)) //BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+BF_NUMLOTE+BF_PRIOR+BF_LOCALIZ+BF_NUMSERI
	    If SBF->(DbSeek(xFilial("SBF")+cProd+_cLocOri))
	    	While SBF->(!Eof()) .And. SBF->BF_PRODUTO==cProd .AND. SBF->BF_LOCAL==_cLocOri

				If SBF->BF_QUANT > 0
					_n := aScan(aLote,{|x| x[1]==SBF->BF_PRODUTO .and. x[5]==SBF->BF_LOCALIZ .AND. x[3]==SB8->B8_LOTECTL })
	
					If _n==0
						aAdd(aLote,{SBF->BF_PRODUTO,'',SBF->BF_LOTECTL,SBF->BF_QUANT,SBF->BF_LOCALIZ})
					Else
					    aLote[_n][4] += SBF->BF_QUANT
					EndIf
				EndIf

				SBF->(Dbskip())
			Enddo	    	
		Else
			Alert('Produto n�o tem saldo por endere�o! Verifique se existem saldos a Distribuir/Endere�ar!')
			Return .F.
		Endif
	Endif	    

	
	If SB1->B1_RASTRO$"L" //TEM CONTROLE POR LOTE

		lLote := .T.
		
		SB8->(DbSetOrder(1)) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+DTOS(B8_DTVALID)+B8_LOTECTL+B8_NUMLOTE
		If SB8->(DbSeek(xFilial("SB8")+cProd+_cLocOri))

			While SB8->(!EOF()) .AND. SB8->B8_PRODUTO==cProd .AND. SB8->B8_LOCAL==_cLocOri
				If SB8->B8_SALDO > 0
				
					If lLocaliz
				
						nSaldoB8 := SB8->B8_SALDO
						
						While nSaldoB8 > 0
		
							_n := aScan(aLote,{|x| x[1]==SB8->B8_PRODUTO .and. x[3]==SB8->B8_LOTECTL .AND. x[2]=='' })
							                       
							If _n==0
								
								
								cAl := getNextAlias()
								
								beginSQl Alias cAl
									SELECT COALESCE(SUM(DA_SALDO),0) AS QUANT 
									FROM %Table:SDA%
									WHERE %NotDel%
									AND DA_FILIAL = %xFilial:SDA%
									AND DA_PRODUTO = %Exp:SB8->B8_PRODUTO%
									AND DA_LOCAL = %Exp:SB8->B8_LOCAL%
									AND DA_SALDO > 0
								endSql
								
								If (cAl)->(!eof()) .AND. (cAl)->QUANT > 0
									Alert('Existe um saldo de '+alltrim(str((cAl)->QUANT))+' a endere�ar! Favor executar endere�amento do produto:'+SB8->B8_PRODUTO+'!')
								Else
									Alert('D I V E R G � N C I A !'+CHR(13)+CHR(10)+;
									      'Produto possui saldo por lote (SB8) que n�o corresponde ao saldos por endere�o (SBF).'+CHR(13)+CHR(10)+;
										  'Produto: ' + SB8->B8_PRODUTO + CHR(13)+CHR(10)+;
										  'Local: ' + SB8->B8_LOCAL + CHR(13)+CHR(10)+;
										  'Lote: ' + SB8->B8_LOTECTL)
								Endif							

								(cAl)->(dbclosearea())								    								
								Return .F.								
							Else
								If nSaldoB8 < aLote[_n][4]
									Alert('D I V E R G � N C I A !'+CHR(13)+CHR(10)+;
								          'Produto possui saldo no lote '+SB8->B8_LOTECTL+' (SB8) menor que as quantidades encontradas nos saldos por endere�o (SBF)!'+CHR(13)+CHR(10)+;
									  	  'Produto: ' + SB8->B8_PRODUTO + CHR(13)+CHR(10)+;
									  	  'Local: ' + SB8->B8_LOCAL)
									Return .F.
								Else
							    	nSaldoB8 -= aLote[_n][4]
						    	    aLote[_n][2] := SB8->B8_DATA
								EndIf
							EndIf
							
						Enddo
					Else
						_n := aScan(aLote,{|x| x[1]==SB8->B8_PRODUTO .and. x[3]==SB8->B8_LOTECTL })
							                       
						If _n==0
							aAdd(aLote,{SB8->B8_PRODUTO,SB8->B8_DATA,SB8->B8_LOTECTL,SB8->B8_SALDO,""})
						Else
							aLote[_n][4] += SB8->B8_SALDO
						Endif
					
					Endif
				Endif
				SB8->(DBskip())
			EndDo
		Else
			Alert("Produto n�o possui saldo em nenhum lote!")
			Return .F.
		EndIf

	EndIf
	
	//-- chamado 035028
	//-- verifica nas transferencias abertas quais lotes / endereco j� est�o utilizandos para n�o duplicar
	
	aArea := getArea() // GUARDA A AREA SELECIONADA
	
	cAl := getnextalias()
	
	beginSql Alias cAl
		SELECT ZEB_COD, ZEB_QUANT, ZEB_LOTE, ZEB_LOCALI 
		FROM %Table:ZEB% ZEB, %Table:ZEA% ZEA
		WHERE ZEA_NUM = ZEB_NUM
		AND ZEA_STATUS <> 'E'
		AND ZEB_COD = %Exp:cProd%
		AND ZEA.%NotDel%
		AND ZEB.%NotDel%
	endSql
	
	While (cAl)->(!eof())
		_n := aScan(aLote,{|x| x[3]==(cAl)->ZEB_LOTE .AND. x[5]==(cAl)->ZEB_LOCALI })
			                       
		If _n!=0
			If (cAl)->ZEB_QUANT >= aLote[_n][4]
				aLote[_n][5] := 'INVALIDO'
			Else
				aLote[_n][4] -= (cAl)->ZEB_QUANT
			Endif
		Endif
	
		(cAl)->(dbskip())
	Enddo
	
	(cAl)->(dbclosearea())

	RestArea(aArea) //-- RETORNA A AREA SELECIONADA
	
	//-- FIM CHAMADO 035028
		
	nSldAdd := 0 //saldo adicionado ao acols
	x       := 1
	lPrim   := .T.
	nQtdDig := M->ZEB_QUANT

	aSort(aLote,,,{|x,y| x[2] < y[2]}) //ordena por data decrescente
	
	If lLote .or. lLocaliz
	
		WHILE nQtdDig > nSldAdd .AND. x <= Len(aLote)
				
			If aLote[x][5]!="INVALIDO"
				If lPrim //se for a primeira  vez nao inclui linha, apenas atualiza a quantidade, lote e localizacao
					aCols[n][6] := aLote[x][3] //lote
					aCols[n][7] := aLote[x][5] //localizacao
		
					If nQtdDig >= aLote[x][4] //quantidade digitada maior ou igual ao saldo do lote
						aCols[n][5] := aLote[x][4] //muda a quantidade digitada para o saldo do primeiro lote mais antigo
						nSldAdd += aLote[x][4] //incrementa a quantidade que ja foi incluida no acols
					Else
					    nSldAdd += nQtdDig
					EndIf
					
					lPrim := .F.
				Else
					If nQtdDig >= (aLote[x][4]+nSldAdd) //se a quantidade digitada for maior ou igual ao qtd do lote + o q ja foi adicionado no acols
						aAdd(aCols,{STRZERO(Len(aCols)+1,4),cProd,SB1->B1_DESC,0,aLote[x][4],aLote[x][3],aLote[x][5],.F.}) //adiciona a qtd total do lote
						nSldAdd += aLote[x][4] //incrementa a quantidade que ja foi adicionada no acols
					Else //senao
						aAdd(aCols,{STRZERO(Len(aCols)+1,4),cProd,SB1->B1_DESC,0,(nQtdDig-nSldAdd),aLote[x][3],aLote[x][5],.F.}) //adiciona somente o que faltar para atingir a quantidade digitada
						nSldAdd += (nQtdDig-nSldAdd)  //incrementa a quantidade que falta para atingir a quantidade digitada no que ja foi adicionado no acols
					EndIf
				EndIf
			EndIf
					
		    x++
		ENDDO 
	
		If nQtdDig > nSldAdd
			Alert("N�o existe saldo suficiente por lote!")
			Alert("Realizar Transferencia (Mod. 2)!")
			Return .F.
		EndIf
	EndIf

Return .T.

//�������������������������������������������������Ŀ
//� TRAZ O SALDO DO PRODUTO CONSIDERANDO EMPENHADOS �
//���������������������������������������������������
Static Function fSaldo(cProd,cLocOri)
Local nSaldo := 0
	
	SB2->(DbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL
	If SB2->(Dbseek(xFilial("SB2")+cProd+cLocOri))
			
		nSaldo := SB2->B2_QATU - SB2->B2_QEMP
			
		If Select("TRA1") > 0
			TRA1->(dbCloseArea())
		EndIf
		
		//TRAZ O SALDO EMPENHADO DE PE�AS A TRANSFERIR
		cQuery := " SELECT SUM(ZEB.ZEB_QUANT) AS QUANT "
		cQuery += " FROM "+RetSqlName("ZEA")+" ZEA, "+RetSqlName("ZEB")+" ZEB "
		cQuery += " WHERE ZEA.ZEA_NUM=ZEB.ZEB_NUM "
		cQuery += " AND ZEA.ZEA_STATUS = 'P'"
		cQuery += " AND ZEB.ZEB_COD = '"+cProd+"'"
		cQuery += " AND ZEA.ZEA_FILIAL = '"+xFilial("ZEA")+"' AND ZEA.D_E_L_E_T_ = ''"
		cQuery += " AND ZEB.ZEB_FILIAL = '"+xFilial("ZEB")+"' AND ZEB.D_E_L_E_T_ = ''"
			
		TcQuery cQuery NEW ALIAS "TRA1"
			
		TRA1->(dbGoTop())
			
		nSaldo -= Iif(!Empty(TRA1->QUANT),TRA1->QUANT,0)
	
	Else
		Alert("Produto n�o encontrado no almoxarifado "+clocori+"!")
		Return 0
	EndIf

Return nSaldo

//����������������������������������Ŀ
//� ENVIA EMAIL DE AVISO DE EMBARQUE �
//������������������������������������
Static Function fEST186MAIL()
Local cMsg := ""
Local cAssunto := ""

	//cabecalho da mensagem
	cMsg += '<html><body>'
	cMsg += '<table style="font-family:arial" width="100%" border="1">'
	cMsg += '<tr>'
	cMsg += '<td colspan="6" align="center" style="background:#ccc">Aviso de Embarque Componentes / Processo</td>'
	
	cMsg += '</tr>'
	cMsg += '<tr style="background:#aabbcc">'
	cMsg += '<td colspan="3" align="center">N� Controle: '+_cNum+'</td>'
	cMsg += '<td align="center">Data: '+DtoC(_dData)+'</td>'
	cMsg += '<td colspan="2" align="center">Hora de Sa�da: '+Substr(_cHora,1,5)+'</td>'
	cMsg += '<tr style="background:#aabbcc">' 
	cMsg += '<td align="center">Item</td>'
	cMsg += '<td align="center">Produto</td>'
	cMsg += '<td colspan="2" align="center">Descricao</td>'	
	cMsg += '<td align="center">Volume</td>'
	cMsg += '<td align="center">Quantidade</td>'
	cMsg += '</tr>'			
	
	For _x := 1 to len(aCols)
		If !Acols[_x][len(aHeader)+1] //nao pega quando a linha esta deletada	
		
			If _x%2 == 0
				cMsg += '<tr style="font-size:12px">'
			Else
				cMsg += '<tr style="background:#eeeeee;font-size:12px">'	
			EndIf
			
			cMsg += '<td align="center">'+aCols[_x][1]+'</td>'//item
			cMsg += '<td align="center">'+aCols[_x][2]+'</td>'//produto
			cMsg += '<td colspan="2" align="center">'+aCols[_x][3]+'</td>'//descricao
			cMsg += '<td align="center">'+Str(aCols[_x][4])+'</td>'//volume
			cMsg += '<td align="center">'+Str(aCols[_x][5])+'</td>'//quantidade
			cMsg += '</tr>'			
		EndIf
	Next
	
	cMsg += '<tr style="font-size:12px">'
	cMsg += '<td style="background:#aabbcc">OBS:</td>'
	cMsg += '<td colspan="5">'+_cObs+'</td>'
	cMsg += '</tr>'
	
	cMsg += '</table><br />' 
	cMsg += '<table style="font-family:arial; font-size:12px" width="100%">
	cMsg += '<tr><td>
	cMsg += 'Mensagem Processada automaticamente. Favor nao responder este email.<br />'	 
	cMsg += 'Para informa��es adicionais entrar em contato com:<br />'
	cMsg += 'Leandro Jos� dos Santos - (41) 3341-1993 - leandrojs@whbbrasil.com.br<br />'
	cMsg += '</td></tr>'
	cMsg += '</table>
	
	cTo := "leandrojs@whbusinagem.com.br"
    cAssunto := "*** AVISO DE TRANSFER�NCIA COMPONENTES / PROCESSO ***"
 	
	oMail          := Email():New()
	oMail:cMsg     := cMsg
	oMail:cAssunto := cAssunto
	oMail:cTo      := cTo 
	oMail:Envia()

Return

//�������������������������������������������Ŀ\\
//� FAZ TRANSFERENCIA AUTOMATICA DOS PRODUTOS �\\
//���������������������������������������������\\
User Function fEST186T()

Local aArray 		:= {} //Transf. 
Local aVettmp       := {} //Quality
Local _cDoc  		:= ""
Local _lCanc        := .F.
Local _cNum         := ZEA->ZEA_NUM
Local cCCMov        := ''
Private _cLocOri    := ZEA->ZEA_LOCALO
Private _cLocDes    := "34"
Private lMsErroAuto := .F. 

If ZEA_STATUS == "E"
	Alert("J� Transferido!")
	Return
EndIf

//�������������������
//� CONSTROI A TELA �
//�������������������
DEFINE MSDIALOG oDlg FROM 0,0 TO 152,205 PIXEL TITLE "Transfer�ncia"

   	@ 005,005 TO 050,100 OF oDlg PIXEL
   	@ 015,010 Say "Do Armaz�m: " Size 050,8 Object olLocOr
   	@ 013,055 Get _cLocOri Picture "@e 99" When .F. Size 20,8 object oLocOr
   	@ 030,010 Say "Para Armaz�m: " Size 050,8 object olLocDe
   	@ 028,055 Get _cLocDes Picture "@e 99" When .F. Size 20,8 object oLocDe

   	@ 055,035 BUTTON "&Ok"       Size 030,015 ACTION fValTransf() object btn1
   	@ 055,070 BUTTON "&Cancelar" Size 030,015 ACTION {_lCanc := .T. ,oDlg:End()} object btn2
   
ACTIVATE MSDIALOG oDlg CENTER

If _lCanc
	Return
EndIf

_cDoc  := NextNumero("SD3",2,"D3_DOC",.T.)//pega o proximo numero do documento do d3_doc

DbSelectArea("ZEB")
DbSetOrder(1)//filial + num + item
DbGoTop()

//-- CABECALHO
aArray := {{_cDoc,;		    // 01.Numero do Documento
			ZEA->ZEA_DATA}}	// 02.Data da Transferencia	

If DbSeek(xFilial("ZEB")+ZEA->ZEA_NUM)

	DbSelectArea("SB1")
	DbSetOrder(1)

	_cUsr := UPPER(CUSERNAME)
	QAA->(DbSetOrder(6)) //LOGIN
	
	cAl := getnextalias()
	While ZEB->(!EOF()) .AND. ZEB->ZEB_NUM == _cNum
		If SB1->(DbSeek(xFilial("SB1")+ZEB->ZEB_COD))

			//-- tenta descobrir o centro de custo usando o componente a transferir
			//-- pegando o centro de custo do PA encontrado na tabela de estrutura do produto
			beginSql Alias cAl
				SELECT SUBSTRING(B1_CC,1,1) + '4' + SUBSTRING(B1_CC,3,6) AS CC
				FROM %Table:SB1% B1,
				SG1FN0 G1
				WHERE B1_COD = G1_COD
				AND G1_COMP = %Exp:SB1->B1_COD%
				AND G1.%NotDel%
				AND B1.%NotDel%
				GROUP BY SUBSTRING(B1_CC,1,1) + '4' + SUBSTRING(B1_CC,3,6)
			endSql
			
			//-- se nao encontrar
			If (cAl)->(eof())

				(cAl)->(dbclosearea())

				//-- identifica o cento de custo da movimentacao atrav�s da troca do d�gito do meio para 4 
				beginSql Alias cAl
					select SUBSTRING(B1_CC,1,1) + '4' + SUBSTRING(B1_CC,3,6) AS CC 
					from %Table:SB1% B1 (NOLOCK)
					WHERE B1_COD = %Exp:Substr(SB1->B1_COD,1,6) + '4' + Substr(SB1->B1_COD,8,8)%
					AND B1.%NotDel%
					AND B1.B1_MSBLQL <> '1'
					GROUP BY SUBSTRING(B1_CC,1,1) + '4' + SUBSTRING(B1_CC,3,6)
				endSql
	
				//-- se nao encontrar retorna erro
				If (cAl)->(eof())					
					Alert('N�o foi identificado centro de custo do PA para este produto de origem!'+chr(10)+chr(13)+;
						  'A transfer�ncia n�o ser� conclu�da!')
					(cAl)->(dbclosearea())
					return
				EndIf

			Endif
							    
			//-- array com os centros de custo encontrados
			aCC := {}
			While (cAl)->(!eof())
				aAdd(aCC,(cAl)->CC)
				(cAl)->(dbskip())
			Enddo
			
			(cAl)->(dbCloseArea())
				
			//-- verifica se nao foi encontrado mais de um centro de custo
			If Len(aCC) > 1
				
			  	nRadio := 0
			  	aRadio := aCC
			  	nposbut := (20 + (Len(aCC) * 10))
			  	
			   	DEFINE MSDIALOG oDlg TITLE "Centro de Custo" FROM 0,0 TO (70 + (Len(aCC) * 20)), 245 Pixel
				@ 05,005 TO (15 + (Len(aCC) * 10)), 120 TITLE "Escolha um Centro de Custo"
	
				oRadio := tRadMenu():New(15,10,aRadio,;
				{|u| iF(PCount()>0,nRadio:=u,nRadio)},oDlg,,{||},,,,,,100,30,,,,.T.)

			   	DEFINE SBUTTON oBtnOk  FROM nposbut ,05 TYPE 1 ACTION close(oDlg) ENABLE OF oDlg
			   	ACTIVATE MSDIALOG oDlg CENTERED VALID fValRadio()
			   	
				aCCMov := aCC[nRadio]
			Else
				cCCMov := aCC[1]
			EndIf
			
			//--DETALHE					
			aAdd(aArray,{   SB1->B1_COD,;					// 01.Produto Origem
						    SB1->B1_DESC,;  				// 02.Descricao
							SB1->B1_UM,; 	                // 03.Unidade de Medida
							_cLocOri,; 						// 27.Local Origem
							ZEB->ZEB_LOCALI,;				// 05.Endereco Origem
							SB1->B1_COD,;					// 06.Produto Destino
							SB1->B1_DESC,;					// 07.Descricao
							SB1->B1_UM,;					// 08.Unidade de Medida
							_cLocDes,;						// 09.Armazem Destino
							/*ZEB->ZEB_LOCALI*/'01',;		// 10.Endereco Destino
							CriaVar("D3_NUMSERI",.F.),;		// 11.Numero de Serie
							ZEB->ZEB_LOTE,; 				// 12.Lote Origem
							CriaVar("D3_NUMLOTE",.F.),;		// 13.Sublote
							CriaVar("D3_DTVALID",.F.),;		// 14.Data de Validade
							CriaVar("D3_POTENCI",.F.),;		// 15.Potencia do Lote
							ZEB->ZEB_QUANT,;				// 16.Quantidade
							CriaVar("D3_QTSEGUM",.F.),;		// 17.Quantidade na 2 UM             	
							CriaVar("D3_ESTORNO",.F.),;		// 18.Estorno
							CriaVar("D3_NUMSEQ",.F.),;		// 19.NumSeq
							ZEB->ZEB_LOTE,;	   				// 20.Lote Destino
							CRIAVAR("D3_DTVALID",.F.),;     // 21.Data Validade
							CRIAVAR("D3_ITEMGRD",.F.),;     // 22.Item da grade
							CRIAVAR("D3_CARDEF",.F.),;
							CRIAVAR("D3_DEFEITO",.F.),;
							CRIAVAR("D3_OPERACA",.F.),;
							CRIAVAR("D3_FORNECE",.F.),;
							CRIAVAR("D3_LOJA",.F.),;
							CRIAVAR("D3_LOCORIG",.F.),;
							cCCMov /*SB1->B1_CC*/,;
							CRIAVAR("D3_TURNO",.F.),;
							CRIAVAR("D3_MAQUINA",.F.),;
							CRIAVAR("D3_LINHA",.F.),;
							CRIAVAR("D3_CODPA",.F.),;
							CRIAVAR("D3_DTREF",.F.),;
							CRIAVAR("D3_CORRID",.F.),;
							CRIAVAR("D3_CORRIDA",.F.),;
							CRIAVAR("D3_OP",.F.)})	

			If QAA->(DbSeek(_cUsr))
				_cSolic := QAA->QAA_MAT
			Else
				Alert("Transfer�ncia n�o pode ser realizada. Usu�rio n�o cadastrado!")
				Return .F.
			EndIf
				
	    EndIf
		ZEB->(DbSkip())
    EndDo
Else
	Alert("Transfer�ncia n�o pode ser conclu�da")
	Return
EndIf 

dbSelectArea("SD3")
aArray[1][1] := _cDoc := NextNumero("SD3",2,"D3_DOC",.T.)//pega o proximo numero do documento do d3_doc

Processa({|| MSExecAuto({|x| MATA261(x)},aArray)},"Aguarde. Transferindo...") //inclus�o
//MSExecAuto({|x,y| MATA261(x,y)},aArray,6) //estorno

//-- verifica se houve transferencia

lTransf := .T.

For xP:=2 TO LEN(aArray)

	cAl := getnextalias()
	
	beginSql alias cAl
		SELECT D3_DOC FROM %Table:SD3%
		WHERE D3_COD = %Exp:aArray[xP][1]%
		AND D3_EMISSAO = %Exp:DtoS(aArray[1][2])%
		AND D3_QUANT = %Exp:aArray[xP][16]%
		AND ((D3_LOCAL = %Exp:aArray[xP][4]% AND D3_TM > '500') OR (D3_LOCAL = %Exp:aArray[xP][9]% AND D3_TM < '500' ))
		AND D3_FILIAL = %xFilial:SD3%
		AND %NotDel%
		AND D3_ESTORNO <> 'S'
	endsql

	If (cAl)->(eof())
		lTransf := .F.	
	Else
		_cDoc := (cAl)->D3_DOC
	Endif

	(cAl)->(dbclosearea())	
	
Next

//-- fim verificacao de gravacao na sd3

If lMsErroAuto
	mostraerro()
	DisarmTransaction()
	Return
ElseIf !lTransf
	alert("Erro na Transfer�ncia, n�o foi gerada transfer�ncia para todos os �tens!")
	DisarmTransaction()
	Return
Else
       
	RecLock("ZEA",.F.)
		ZEA->ZEA_STATUS := "E"
		ZEA->ZEA_DOC    := _cDoc
	MsUnlock("ZEA")
	
	MsgBox("Transferencia efetuada com sucesso!","Transferido","INFO")
           
 	(cAl)->(dbclosearea())
 	
Endif

Return

Static Function fValRadio()
          
	If nRadio == 0
		Alert('Escolha uma op��o!')
		return .f.
	EndIf
	
Return .t.

//������������������������������Ŀ
//� VALIDA TELA DE TRANSFERENCIA �
//��������������������������������
Static Function fValTransf()
	
	If Empty(_cLocDes)
		Alert("Preencha o Local de Destino")
		Return .F.
	EndIf
	
	If Empty(_cLocOri)
		Alert("Preencha o Local de Origem")
		Return .F.
	EndIf
	
	oDlg:End()
	
Return .T.

//���������Ŀ
//� LEGENDA �
//�����������
User Function EST186LEG()       

Local aLegenda :=	{ {"BR_VERDE"   , OemToAnsi("Pendente")    },;                                                                  
  					  {"BR_VERMELHO", OemToAnsi("Transferido") }}
  					  
BrwLegenda(OemToAnsi("Transfer�ncia Componentes / Processo"), "Legenda", aLegenda)

Return  

Static Function fCriaCor()
	Local aLegenda :=	{ {"BR_VERDE"   , OemToAnsi("Pendente") },;                                                                  
  						  {"BR_VERMELHO", OemToAnsi("Transferido")   }}  					  

	Local uRetorno := {}
	Aadd(uRetorno, { 'ZEA_STATUS == "P" ' , aLegenda[1][1] } )
	Aadd(uRetorno, { 'ZEA_STATUS == "E" ' , aLegenda[2][1] } )
Return(uRetorno)

//��������������������Ŀ
//� VALIDA A MULTILINE 	�
//����������������������
Static Function fMulti()
Local _cProd := aCols[n][2]

	If !Acols[n][len(aHeader)+1] //nao pega quando a linha esta deletada

		If Empty(aCols[n][5]) //volume
			Alert("Preencha a quantidade")
			Return .F.
		EndIf   
		
		SB1->(DbSetOrder(1)) //filial + cod
		SB1->(DbSeek(xFilial("SB1")+_cProd))
		
		If SB1->B1_RASTRO$"L" .and. EMPTY(aCols[n][6]) //lote
			Alert("Informe o lote para produtos controlados por lote!")
			Return .F.
		EndIf
		
	EndIf
Return .T.
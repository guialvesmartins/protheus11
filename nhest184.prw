/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ�� 
���Programa  �NHEST184  �Autor  �Alexandre R. Bento  � Data �  22/01/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � CONTROLE Desmonte de Produtos de Refugo                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE/CUSTOS / Qualidade                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#include "protheus.ch" 
#include "colors.ch"
#include "AP5MAIL.CH" 
#include "topconn.ch"

User Function NHEST184()

//AXCADASTRO("ZBI")
//AXCADASTRO("ZBB")

Private cAlias    := "SD3"                                
Private aRotina   := {}
Private cCadastro := "Desmonte de Produtos Usinagem"
Private cEmpresa  := "FUN"

aAdd( aRotina, {"Pesquisar"  ,"AxPesqui"     ,0,1} )
aAdd( aRotina, {"Visualizar" ,"U_fEST184(1)" ,0,2} )
aAdd( aRotina, {"Incluir"    ,"U_fEST184(2)" ,0,3} )
                                                    
//aAdd( aRotina, {"Visualizar" ,"U_fEST184(1)" ,0,2} )
dbSelectArea(cAlias)
dbSetOrder(1)

mBrowse(,,,,cAlias,,,,,,fCriaCor())

Return

//������������������Ŀ
//� FUNCAO PRINCIPAL �
//��������������������
User Function fEST184(nParam)
Local bOk         := {||fOk()}
Local bCanc       := {||fEnd()}
Local bEnchoice   := {||}
Private aSize     := MsAdvSize()
Private aObjects  := {{ 060, 060, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo     := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj   := MsObjSize( aInfo, aObjects, .T.)
Private nPar      := nParam
Private aHeader   := {}
Private aCols     := {}
Private _cProd    := Space(15)
Private _cDescP   := Space(30)
Private _cNomeUsu := Space(30)
Private _cUser    := Space(30)            
Private _nQuant   := 0
Private _cOper    := Space(03)
Private _cCCusto  := Space(09)
Private _cDescc   := Space(30)
Private _cDefdes  := Space(30)
Private _cDef     := Space(03)
Private _cCardef  := Space(30)
Private _cCarD    := Space(03)
Private _cFor     := Space(06)
Private _cLoja    := Space(02)
Private _cDescF   := Space(30)
Private _cAlmxo   := Space(02)
Private _cDAlmxo  := Space(30)
Private _cAlmxd   := Space(02)
Private _cDAlmxd  := Space(30)
Private _cdoc     :=  Space(09)

SetPrvt("_dData,_cHora,_cDocTransf,cMotivo")

If nPar == 2//incluir
	dbSelectArea("SD3")
	_cDoc       := GetSxENum("SD3","D3_DOC")//Traz o novo numero da transferencia fun/usi
	_dData      := Date()
	_cHora      := Time()
   _cUser := UsrFullname(__cUserId )	
    
Elseif nPar == 1
       Return(.f.)
EndIf

Aadd(aHeader,{"Item" 	    , "D3_ITEM"    ,"@E 9999"            ,04,0,".F.","","C","SD3"})
Aadd(aHeader,{"Produto"     , "D3_COD"     ,"@!"	             ,15,0,"","","C","SD3"})
Aadd(aHeader,{"Descricao"   , "B1_DESC"    ,"@!"	             ,30,0,".F.","","C","SB1"})
Aadd(aHeader,{"Quant"       , "D3_QUANT"   ,"@E 999999999.99"    ,14,2,"","","N","SD3"})   
Aadd(aHeader,{"Lote"       , "D3_LOTECTL"   ,"@!"                ,10,0,"","","N","SD3"})   
Aadd(aHeader,{"Endereco"   , "D3_LOCALIZ"   ,"@!"                ,15,0,"","","N","SD3"})   

/*Aadd(aHeader,{"Endere�o"    , "D3_LOCALIZ" ,"@!"                 ,15,0,"U_f84LCZ()","","C","SD3"})   
Aadd(aHeader,{"Defeito"     , "D3_DEFEITO" ,"@!"                 ,03,0,"","","C","SD3"})   
Aadd(aHeader,{"Car.Defeito" , "D3_CARDEF"  ,"@!"                 ,03,0,"","","C","SD3"})   
  */

If nPar == 5 //Divergencia                                                             
	aHeader[2][6] := ".F."
EndIf


DEFINE FONT oFont12 NAME "Arial" SIZE 12, -12 BOLD

//Define MsDialog oDlg Title OemToAnsi("Transfer�ncia de Produtos Fundi��o / Usinagem") From 000,000 To 400,790 Pixel

bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc,,)}
			
oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Desmonte de Produtos Usinagem",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

//@ 020,005 To 180,390 Title OemToAnsi(" Informa��es ")  

@ 020,010 Say "Documento: "     SIZE 040,008 Object olNum
@ 018,045 Get _cDoc          SIZE 040,008 valid fValDoc() Object oNum
//oNum:SetFont(oFont12)

@ 020,110 Say "Produto: " SIZE 040,008 COLOR CLR_BLUE Object olPlCam
@ 018,140 Get _cProd      SIZE 055,008 Picture "@!" When(nPar == 2 .or. nPar == 3) F3 "SB1" Object oProd VALID fProd()
@ 018,200 Get _cDescP  Picture "@!" When .F. Size 100,8 Object oDescP             

//@ 020,330 Say "Usuario: "  SIZE 040,008 COLOR CLR_BLUE Object olUser
//@ 018,360 Get _cUser       SIZE 080,008 When .F. Object oUser VALID (!VAZIO())

@ 020,330 Say "Data: "       SIZE 040,008 Object olData
@ 018,350 Get _dData         SIZE 040,008 Object oData Valid fData()

@ 020,400 Say "Hora: "       SIZE 030,008 Object olHora
@ 018,420 Get _cHora         SIZE 030,008 When .F. Object oHora

@ 033,010 Say "Car. Defeito: "   SIZE 050,008 Object olCar
@ 032,045 Get _cCardef           SIZE 025,008 F3 "SZ8" Object oCar VALID fCar()
@ 032,075 Get _cCarD             Picture "@!" When .F. Size 080,8 Object oCarD             

@ 033,190 Say "Defeito: "     SIZE 035,008 Object olDef
@ 032,220 Get _cDef           SIZE 010,008 F3 "SZ6" Object oDef VALID fDef()
@ 032,250 Get _cDefdes        Picture "@!" When .F. Size 090,8 Object oDefdes             

@ 033,360 Say "Opera��o: "   SIZE 040,008 Object olOper
@ 032,395 Get _cOper         SIZE 015,008 Object oOper Valid fOper()

@ 033,430 Say "Quantidade: " SIZE 035,008 Object olQuant
@ 032,460 Get _nQuant        SIZE 030,008 Picture "999,999.99" When(nPar == 2 .or. nPar == 3) Object onQuant Valid (_nQuant>0)

//@ 032,190 Say "Doc: "        SIZE 030,008 Object olDocTransf
//@ 030,210 Get _cDocTransf    SIZE 040,008 When .F. Object oDocTransf

@ 046,010 Say "Almox. Origem: " SIZE 040,008 COLOR CLR_BLUE Object olAlmxo
@ 045,050 Get _cAlmxo      SIZE 020,008 Picture "@!" When(nPar == 2 .or. nPar == 3) F3 "ALM" Object oAlmxo VALID fAlmxo()
@ 045,073 Get _cDAlmxo   Picture "@!" When .F. Size 120,8 Object oDAlmxo

@ 046,230 Say "Almox. Destino: " SIZE 040,008 COLOR CLR_BLUE Object olAlmxd
@ 045,270 Get _cAlmxd      SIZE 020,008 Picture "@!" When(nPar == 2 .or. nPar == 3) F3 "ALM" Object oAlmxd VALID fAlmxd()
@ 045,293 Get _cDAlmxd     Picture "@!" When .F. Size 120,8 Object oDAlmxd

@ 059,010 Say "Fornecedor: " SIZE 040,008 COLOR CLR_BLUE Object olFor
@ 058,045 Get _cFor      SIZE 035,008 Picture "@!" When(nPar == 2 .or. nPar == 3) F3 "SA2" Object oFor VALID fFor() 
@ 058,080 Get _cLoja     SIZE 015,008 Picture "@!" When(nPar == 2 .Or. _cPar == 3) valid fLoja() Object oLoja            
@ 058,097 Get _cDescF    Picture "@!" When .F. Size 100,8 Object oDescF

@ 059,220 Say "Usuario: "  SIZE 040,008 COLOR CLR_BLUE Object olUser
@ 058,250 Get _cUser       SIZE 100,008 When .F. Object oUser VALID (!VAZIO())

@ 057,450 BUTTON "&Estrutura"  Size 040,012 ACTION fGerar() object btn1
//@ 068,010 Say "Observa��o: " SIZE 030,008 Object olObs
//@ 066,045 Get oObs VAR _cObs MEMO When(nPar == 2 .or. nPar == 3) SIZE 180,030 PIXEL OF oDlg
	
@ 072,aPosObj[2,2] TO aPosObj[2,3],aPosObj[2,4] MULTILINE MODIFY DELETE OBJECT oMultiline VALID fMulti()

//diferente de incluir
If nPar != 2
	oMultiline:nMax := Len(aCols) //n�o deixa o usuario adicionar mais uma linha no multiline
EndIf

oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)
//Activate MsDialog oDlg Center

Return 

Static Function fValDoc()

	//verifica se o documento j� foi digitado
	SD3->(DbSetOrder(2)) // D3_FILIAL+D3_DOC+D3_COD
	If SD3->(DbSeek(xFilial("SD3")+_cDoc)) // Procura no SD3
		Msgbox(OemToAnsi("Documento j� Cadastrado, Verifique!"),"Atencao","ALERT" )
		Return .f.
	Endif

Return .T.


//����������Ŀ
//� CONFIRMA �
//������������
Static Function fOk()
Local aArray 	  := {} //Transf.
Local cAl
Private lMsErroAuto := .F.
//Local _cDoc    

	/*********
	* INCLUI *
    *********/
    If nPar == 2
    
	    If !fValida()
    	    Return
	    EndIf
             
		dbSelectArea("SD3")
		//-- CABECALHO
		aArray := {{_cDoc,;		// 01.Numero do Documento
					_dData}}	// 02.Data da Transferencia	
		
	    SB1->(DBSETORDER(1))//FILIAL + COD
		
		For xC:=1 to Len(aCols)
			If !aCols[xC][len(aheader)+1]
    
		  		SB1->(DbSeek(xFilial("SB1")+Acols[xC][2]))			
				//--DETALHE					
				aAdd(aArray,{   SB1->B1_COD,;					// 01.Produto Origem
								SB1->B1_DESC,;  				// 02.Descricao
								SB1->B1_UM,; 	                // 03.Unidade de Medida
								_cAlmxo,; 						// 27.Local Origem
								aCols[xC][6],;					// 05.Endereco Origem
								SB1->B1_COD,;					// 06.Produto Destino
								SB1->B1_DESC,;					// 07.Descricao
								SB1->B1_UM,;					// 08.Unidade de Medida
								_cAlmxd,;						// 09.Armazem Destino
								aCols[xC][6],;					// 10.Endereco Destino
								CriaVar("D3_NUMSERI",.F.),;		// 11.Numero de Serie
								aCols[xC][5],;					// 10.Lote Origem
								CriaVar("D3_NUMLOTE",.F.),;		// 13.Sublote
								CriaVar("D3_DTVALID",.F.),;		// 14.Data de Validade
								CriaVar("D3_POTENCI",.F.),;		// 15.Potencia do Lote
								aCols[xC][4],;					// 16.Quantidade
								CriaVar("D3_QTSEGUM",.F.),;		// 17.Quantidade na 2 UM
								CriaVar("D3_ESTORNO",.F.),;		// 18.Estorno
								CriaVar("D3_NUMSEQ",.F.),;		// 19.NumSeq  
								aCols[xC][5],;					// 10.Lote Destino								
								CRIAVAR("D3_DTVALID",.F.),;     // 21.Data Validade
								CRIAVAR("D3_ITEMGRD",.F.),;     // 22.Item da grade
								_cCarDef,;						// caracteristica do defeito
								_cDef,;							// Defeito 		  
								_cOper,;						// Opera��o
								_cFor,;                         // 
								_cLoja,;						//
								CRIAVAR("D3_LOCORIG",.F.),;
								SB1->B1_CC,;
								CRIAVAR("D3_TURNO",.F.),;
								CRIAVAR("D3_MAQUINA",.F.),;
								CRIAVAR("D3_LINHA",.F.),;
								CRIAVAR("D3_DTREF",.F.),;
								CRIAVAR("D3_CORRID",.F.),;
								CRIAVAR("D3_CORRIDA",.F.),;
								CRIAVAR("D3_OP",.F.)})	
			EndIf
		Next
	
		Processa({|| MSExecAuto({|x| MATA261(x)},aArray)},"Aguarde. Transferindo...") //inclus�o
		//MSExecAuto({|x,y| MATA261(x,y)},aArray,6) //estorno
		
		If lMsErroAuto
			mostraerro()
			DisarmTransaction()
			Return
		Else
		
			//-- VERIFICA SE EXISTE A MOVIMENTACAO NO D3 POR PRECAUCAO
			cAl := getnextalias()
			beginSql Alias cAl
				SELECT * FROM %Table:SD3% 
				WHERE D3_DOC = %Exp:_cDoc%
			endSql
			
			//-- SE EXISTIR, ENCERRA A TRANSFERENCIA
			If (cAl)->(!Eof())
			
				MsgBox("Transferencia efetuada com sucesso!","Transferido","INFO")
			Else
				MsgBox("N�o foi poss�vel executar a transfer�ncia!","Problema","INFO")
			EndIf
		           
		 	(cAl)->(dbclosearea())
				

		Endif
			
	EndIf
	
	Close(oDlg)
Return

//��������Ŀ
//�CANCELA �
//����������
Static Function fEnd()
//	RollBackSx8()
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
User Function EST184PRD()
Local _cCod  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZBB_COD"})
Local _cDesc := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "B1_DESC"})
//Local _cLote := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZBB_LOTE"})
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+M->ZBB_COD)

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
Local nPosProd := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_COD"})
Local _lRet    := .F.
Local nx               


	If Len(aCols) < 1
		Alert("Ao menos um produto deve ser informado!")
		Return .F.
	EndIf
	
	For nx:= 1 to Len(aCols)
		If !aCols[nx][len(aheader)+1]
		    _lRet := .T.
		    Exit //forca a saida
		Endif
    Next nx

	If Empty(aCols[1][nPosProd])
		Alert("Ao menos um produto deve ser informado!")
		Return .F.
	EndIf
    
	

Return (_lRet)

//����������������������������������������������Ŀ
//� IMPRIME RELATORIO DE TRANSFERENCIA FUN / USI �
//������������������������������������������������
User Function fEST184I()

Agrupo 	  := {}
cString   := ""
cDesc1    := OemToAnsi("Imprime os detalhes da transfer�ncia")
cDesc2    := OemToAnsi("de produtos da Fundi��o para a Usinagem")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST184I" //nome do arquivo
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("ORDEM DE LIBERA��O DE MATERIAIS FUNDI��O / USINAGEM") //t�tulo
cabec1    := "Num. Controle : "+ZBA->ZBA_NUM +Space(20)+"Cliente : WHB USINAGEM" +Space(40)+ZBA->ZBA_HORA+Space(07)+Dtoc(ZBA->ZBA_DATA)
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

		
	@Prow()+1, 001 psay "Motorista: "+ZBA->ZBA_MOTORI
	@Prow()+2, 001 psay "Placa Caminh�o: "+ZBA->ZBA_PLACAM
	@Prow()  , 050 psay "Placa Carreta: "+ZBA->ZBA_PLACAR

	@ prow()+1,000 PSAY __PrtThinLine()        
   
	@Prow()+1, 001 psay "ITEM     PRODUTO           DESCRICAO                                  LOTE      ENDERE�O     VOLUME    QUANTIDADE   QUANT.RECEBIDA"
	
	@Prow()+1, 001 psay ""
	
	DbSelectArea("ZBB") //ITENS DA TRANSFERENCIA
	DbSetOrder(1) //filial + num + item
	If DbSeek(xFilial("ZBB")+ZBA->ZBA_NUM)

		_nTVol := 0
		
		While ZBB->(!EOF()) .AND. ZBB->ZBB_NUM == ZBA->ZBA_NUM
		
			@Prow()+1, 001 psay ZBB->ZBB_ITEM
			@Prow()  , 010 psay ZBB->ZBB_COD
		
			DbSelectArea("SB1")
			DbSetOrder(1) // filial + codigo
			If DbSeek(xFilial("SB1")+ZBB->ZBB_COD)
				@Prow()  , 028 psay Substr(SB1->B1_DESC,1,40)
			EndIf
			
			@Prow()  , 069 psay ZBB->ZBB_LOTE
			@Prow()  , 085 psay Substr(ZBB->ZBB_LOCALI,1,6)
			@Prow()  , 094 psay ZBB->ZBB_VOLUME picture "@e 99999"
			@Prow()  , 107 psay ZBB->ZBB_QUANT picture "@e 99999"
			@Prow()  , 120 psay "___________"
			
			_nTVol += ZBB->ZBB_VOLUME
			
			ZBB->(DbSkip())
			
		EndDo
	EndIf
	
	@Prow()+2, 060 psay "Total de volumes: "
	@Prow()  , 088 psay _nTVol picture "@e 99999"
		 
	@ prow()+1,000 PSAY __PrtThinLine()  
	                            
	QAA->(DbSetOrder(1)) //MAT
	If QAA->(DbSeek(xFilial("QAA")+ZBA->ZBA_EXPEDI))
		@Prow()+1 , 001 psay "Expedidor: "+QAA->QAA_NOME
	EndIf

	@Prow()+7 , 001 psay "Ass. Expedidor:   _______________________________________"
	@Prow()+7 , 001 psay "Ass. Motorista:   _______________________________________"
	@Prow()+7 , 001 psay "Ass. Recebimento: _______________________________________"			
	
	
		
Return 

//�������������������������������������������������Ŀ
//� VERIFICA SE TEM SALDO PARA ENVIAR PARA USINAGEM �
//���������������������������������������������������
User Function F184LCZ()
Local _lRet    := .T.
Local _cProd  

cProd := Acols[n][2]

SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1")+cProd))
	
If SB1->B1_RASTRO$"L" //TEM CONTROLE POR LOTE
   Alert("Produto Com Controle de Lote Ativo no Cadastro!")
   _lRet := .F.
Endif
	
If SB1->B1_LOCALIZ$"S" //TEM CONTROLE POR LOCALIZACAO
	
   lLocaliz := .T.
	
  	SBF->(DbSetOrder(2)) //BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+BF_NUMLOTE+BF_PRIOR+BF_LOCALIZ+BF_NUMSERI

		If lLote
			For x:=1 to Len(aLote)
	        	SBF->(DbSeek(xFilial("SBF")+cProd+cLocOri+aLote[x][3]))
				If SBF->(Found())
				   nBfSaldo := 0
				   While SBF->(!Eof()) .And. SBF->BF_LOTECTL == aLote[x][3]
				      nBfSaldo+= SBF->BF_QUANT
				      SBF->(Dbskip())
				   Enddo
				   
					If nBfSaldo != aLote[x][4] //divergencia entre SBF e SB8
						Alert("Valores divergentes entre tabelas SBF e SB8 no lote "+aLote[x][3])
						aLote[x][5] := "INVALIDO"
						Loop
					Else
						aLote[x][5] := "01" //localizacao
					EndIf
				Else
					Alert("Lote "+aLote[x][3]+" da tabela SB8 n�o encontrado na tabela SBF. Favor realizar a Distribui��o Automatica")
					aLote[x][5] := "INVALIDO"
					Loop
				EndIf
			Next
		Else 
			SBF->(DbSeek(xFilial("SBF")+cProd+cLocOri))
			aCols[n][7] := "01" //localizacao	
		EndIf  
	ENDIF

	If lLote .and. lLocaliz //se controla lote ou localiza��o
	
		nSldAdd := 0 //saldo adicionado ao acols
		x       := 1
		lPrim   := .T.
		nQtdDig := M->ZBB_QUANT

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
		cQuery := " SELECT SUM(ZBB.ZBB_QUANT) AS QUANT "
		cQuery += " FROM "+RetSqlName("ZBA")+" ZBA, "+RetSqlName("ZBB")+" ZBB "
		cQuery += " WHERE ZBA.ZBA_NUM=ZBB.ZBB_NUM "
		cQuery += " AND ZBA.ZBA_STATUS = 'P'"
		cQuery += " AND ZBB.ZBB_COD = '"+cProd+"'"
		cQuery += " AND ZBA.ZBA_FILIAL = '"+xFilial("ZBA")+"' AND ZBA.D_E_L_E_T_ = ''"
		cQuery += " AND ZBB.ZBB_FILIAL = '"+xFilial("ZBB")+"' AND ZBB.D_E_L_E_T_ = ''"
			
		TcQuery cQuery NEW ALIAS "TRA1"
			
		TRA1->(dbGoTop())
			
		nSaldo -= Iif(!Empty(TRA1->QUANT),TRA1->QUANT,0)
	
	Else
		Alert("Produto n�o encontrado no almoxarifado 27!")
		Return 0
	EndIf

Return nSaldo

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
User Function EST184LEG()       

Local aLegenda :=	{ {"BR_VERDE"   , OemToAnsi("Pendente")    },;                                                                  
  					  {"BR_VERMELHO", OemToAnsi("Transferido") }}
  					  
BrwLegenda(OemToAnsi("Transfer�ncia Fun/Usi"), "Legenda", aLegenda)

Return  

Static Function fCriaCor()
	Local aLegenda :=	{ {"BR_VERDE"   , OemToAnsi("Pendente") },;                                                                  
  						  {"BR_VERMELHO", OemToAnsi("Transferido")   }}  					  

	Local uRetorno := {}
	Aadd(uRetorno, { 'D3_ESTORNO == "P" ' , aLegenda[1][1] } )
	Aadd(uRetorno, { 'D3_ESTORNO == "E" ' , aLegenda[2][1] } )
Return(uRetorno)

//��������������������Ŀ
//� VALIDA A MULTILINE 	�
//����������������������
Static Function fMulti()
Local _cProd := aCols[n][2]

	If !Acols[n][len(aHeader)+1] //nao pega quando a linha esta deletada
/*
		If Empty(aCols[n][4]) //volume
			Alert("Preencha o volume")
			Return .F.
		EndIf

		If Empty(aCols[n][5]) //volume
			Alert("Preencha a quantidade")
			Return .F.
		EndIf   
		//verifica produtos duplicados	
		For _x := 1 to len(acols)
			If _x != n
				If _cProd == aCols[_x][2]
					Alert("Produto j� existe!") 
					Return .F.
				EndIf
			EndIf
		Next
*/
		
		SB1->(DbSetOrder(1)) //filial + cod
		SB1->(DbSeek(xFilial("SB1")+acols[n][2]))
		
		If SB1->B1_RASTRO$"L" .and. EMPTY(aCols[n][5]) //lote
			Alert("Informe o lote para produtos controlados por lote!")
			Return .F.
		EndIf
		
	EndIf
Return .T.

//��������������������������Ŀ
//� VALIDA PLACA DO CAMINHAO �
//����������������������������
Static Function  fPlCam()

	If Empty(_cPlCam)
		Alert("Digite a Placa do Caminh�o")
		Return .F.
	EndIf
	
	If Len(ALLTRIM(_cPlCam)) != 8
		Alert("Digite a placa corretamente!")
		Return .F.
	EndIf

Return 

//�������������������������������������������������������������������Ŀ
//� ENVIA EMAIL PARA DIZER QUE NAO TEM AMARRACAO PRODUTO X FORNECEDOR �
//���������������������������������������������������������������������
Static Function fMAILQUALITY()
Local cServer	:= Alltrim(GETMV("MV_RELSERV")) //"192.168.1.4"
Local cAccount  := Alltrim(GETMV("MV_RELACNT")) //'protheus'
Local cPassword := Alltrim(GETMV("MV_RELPSW"))  //'siga'
Local lConectou
Local lEnviado
Local cMsg      := ""
Local _aEmail   := "leandrol@whbusinagem.com.br;suzanasd@whbusinagem.com.br"

//cabecalho da mensagem

cMsg += '<table border="1" width="100%" style="font-family:arial">'
cMsg += '<tr style="background:#aabbcc">'
cMsg += '<td>Produto</td><td>Descri��o<td>Fornecedor</td><td>Loja</td><td>Desc. Fornecedor</td>'
cMsg += '</tr>'
cMsg += '<tr>'
cMsg += '<td>'+SB1->B1_COD+'</td><td>'+SB1->B1_DESC+'<td>999999</td><td>01</td><td>WHB FUNDICAO S/A</td>'
cMsg += '</tr>'
cMsg += '</table>'
cMsg += '<font size="2" style="font-family:arial"> Mensagem Processada automaticamente. Favor nao responder este email.</font>'

_cAssunto := "*** N�O EXISTE AMARRA��O ENTRE PRODUTO X FORNECEDOR ***"

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

If lConectou

    Send Mail from 'protheus@whbbrasil.com.br' To _aEmail;
	SUBJECT _cAssunto;
    BODY cMsg;
    RESULT lEnviado
    If !lEnviado
   	   Get mail error cMensagem
	   Alert(cMensagem)
    EndIf                             
else
   Alert("Erro ao se conectar no servidor: " + cServer)		
Endif

Return

//������������������������������������������������Ŀ
//� RELEASE DAS TRANSFERENCIAS FUNDICAO / USINAGEM �
//��������������������������������������������������
User Function fEst184R()
Private aRotina   := {}
Private cCadastro := "Transferencia de Produtos Fundicao / Usinagem"
private nGdTit := 2
	
aAdd( aRotina, {"Pesquisar"  ,"AxPesqui"       ,0,1} )
aAdd( aRotina, {"Visualizar" ,"U_EST184REL(1)" ,0,2} )
aAdd( aRotina, {"Incluir"    ,"U_EST184REL(2)" ,0,3} )
aAdd( aRotina, {"Alterar"    ,"U_EST184REL(3)" ,0,4} )
aAdd( aRotina, {"Excluir"    ,"U_EST184REL(4)" ,0,5} )
aAdd( aRotina, {"Imprimir"   ,"U_EST184IMP()"  ,0,2} )
aAdd( aRotina, {"Documento"  ,"U_f184Doc()"   ,0,4} )
aAdd( aRotina, {"Legenda"    ,"U_EST184LG2()"  ,0,2} )

dbSelectArea("ZBI")
dbSetOrder(1)

mBrowse(,,,,"ZBI",,,,,,fCriaCor2())

Return

//Abre a funcao base de conhecimento
User Function f184Doc()
   MsDocument("ZBI",ZBI->(RECNO()), 4)
return

//����������������������������������������������Ŀ
//� FUNCAO PRINCIPAL DO RELEASE DE TRANSFERENCIA �
//������������������������������������������������
User Function EST184REL(_nParam)
// variaveis para uso de posicionamento

Local nOpcA      := 0
Local _nItemPos  := 0
Private _nPar    := _nParam
Private _cNumRel := ""
Private _aItems  := {}
Private _cMes    := ""
Private aCols    := {}
Private aHeader  := {}
Private _cAno    := Space(4)

//Cria um array com os meses do ano
For _x := 1 to 12
	aAdd(_aItems,STRZERO(_x,2)+"-"+MesExtenso(_x))
Next

If _nPar == 2 //incluir
	_cNumRel := GetSxeNum("ZBI","ZBI_NUM")
EndIf

//���������������������Ŀ
//� Montagem do aHeader �
//�����������������������
aAdd(aHeader,{"Item"       , "ZBI_ITEM"     , "@!"    ,04,00,".F."           ,"","C","ZBI"})
aAdd(aHeader,{"Produto"    , "ZBI_PRODUT"   , "@!"    ,15,00,"U_fEST39PRD()" ,"","C","ZBI"}) 
aAdd(aHeader,{"Descricao"  , "B1_DESC"      , "@!"    ,40,00,".F."           ,"","C","SB1"})

For _x := 1 to 31                             

	aAdd(aHeader,{"Prev. "+AllTrim(Str(_x)),;
	              "ZBI_PREV"+AllTrim(StrZero(_x,2)),;
	              "@e 99,999", 06,00,;
	              "U_EST184T("+AllTrim(Str(_x))+")",;
	              "","N","ZBI"})
Next

aAdd(aHeader,{"Total"       , "ZBI_PREV01"   , "@E 9,999,999", 09,00, ".F."  ,"","N","ZBI"})  
aAdd(aHeader,{"Prev. Mes 1" , "ZBI_PREVM1"   , "@E 9,999,999", 09,00, ".T."  ,"","N","ZBI"})  
aAdd(aHeader,{"Prev. Mes 2" , "ZBI_PREVM2"   , "@E 9,999,999", 09,00, ".T."  ,"","N","ZBI"})  
aAdd(aHeader,{"Prev. Mes 3" , "ZBI_PREVM3"   , "@E 9,999,999", 09,00, ".T."  ,"","N","ZBI"})  

/*
DbSelectArea("SX3")
DbSetOrder(1)
dBSeek("ZBI")
While( !Eof() .And. SX3->X3_ARQUIVO == "ZBI")

	IF (X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL)
		If !UPPER(ALLTRIM(SX3->X3_CAMPO))$"ZBI_NUM/ZBI_DATA"
		
			//INSERE A DESCRICAO DO PRODUTO NO AHEADER
			If ALLTRIM(SX3->X3_CAMPO)$"ZBI_PRODUT" 
				aAdd(aHeader,{Alltrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,;
							  SX3->X3_DECIMAL,"U_fEST39PRD()","",SX3->X3_TIPO,SX3->X3_F3,;
							  SX3->X3_CONTEXT,X3CBOX(),SX3->X3_RELACAO,".T."})
				aAdd(aHeader,{"Descricao","B1_DESC","@!",40,0,".F.","","C","","","","",".T."})
			ELSE
				aAdd(aHeader,{Alltrim(X3Titulo()),;
				               SX3->X3_CAMPO,;
				               SX3->X3_PICTURE,;
				               SX3->X3_TAMANHO,;
				               SX3->X3_DECIMAL,;
				               IIF(SX3->X3_CAMPO=="ZBI_ITEM",".F.",SX3->X3_VALID),;
				               "",; //Reservado
				               SX3->X3_TIPO,;
				               SX3->X3_F3,;
				               SX3->X3_CONTEXT,;
				               X3CBOX(),;
				               SX3->X3_RELACAO,;
				               ".T."})
			ENDIF
		EndIf
	EndIf
	dBSelectArea("SX3")
	dBSkip()
EndDo
*/

	SB1->(DBSETORDER(1))
	
	If AllTrim(Str(_nPar))$"1/3/4" //Visualizar, alterar ou excluir
		//---------------------------------------------------------
		// Traz os valores para visualiza��o, altera��o ou exclus�o
		//---------------------------------------------------------
		_cNumRel := ZBI->ZBI_NUM
		_nMes    := Month(ZBI->ZBI_DATA)
		_cAno    := ALLTRIM(Str(Year(ZBI->ZBI_DATA)))
		                               
		ZBI->(DBGOTOP())
		
		IF ZBI->(DBSEEK(XFILIAL("ZBI")+_cNumRel))
			WHILE ZBI->(!EOF()) .AND. ZBI->ZBI_NUM == _cNumRel
			    
			    SB1->(DBSEEK(XFILIAL("SB1")+ZBI->ZBI_PRODUT))

			    aAdd(aCols,{ZBI->ZBI_ITEM,ZBI->ZBI_PRODUT,SB1->B1_DESC})
			    
			    For _x := 1 to 31
			    	_cCampo := "ZBI->ZBI_PREV"+StrZero(_x,2)
			    	aAdd(aCols[Len(aCols)],&(_cCampo))
			    Next
				  
				_nTotal := 0 
				
				For _x:= 4 to 34
					_nTotal += aCols[Len(aCols)][_x]
				Next
				 
				aAdd(aCols[Len(aCols)],_nTotal)
				aAdd(aCols[Len(aCols)],ZBI->ZBI_PREVM1)
				aAdd(aCols[Len(aCols)],ZBI->ZBI_PREVM2)
				aAdd(aCols[Len(aCols)],ZBI->ZBI_PREVM3)
			    aAdd(aCols[Len(aCols)],.F.)
			    	
				ZBI->(DBSKIP())
			ENDDO
		ENDIF
		
		If _nPar != 3
			//Desabilita a edi��o do GetDados
			For _x := 1 to Len(aHeader)
				aHeader[_x][6] := ".F."
			Next

		EndIf
			
	EndIf

	oFont16N := tFont():New("Arial",,16,,.T.)
	             
  	//define a tela
	oDlg := MSDialog():New(0,0,480,800,;
		"RELEASE - TRANSFER�NCIA FUN / USI",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
    
	//contorno
	oGroup := tGroup():New(005,005,25,397,,oDlg,,,.T.)

	oSay1 := TSay():New(12,10,{||"N�mero"},oDlg,,,,,,.T.,,)
	oSay2 := TSay():New(12,31,{||_cNumRel},oDlg,,oFont16N,,,,.T.,,)
	
	oSay3 := TSay():New(12,70,{||"M�s"},oDlg,,,,,,.T.,,)
	
	//combobox
	oCombo:= TComboBox():New(10,85,{|u| if(Pcount() > 0,_cMes := u,_cMes)},;
		_aItems,50,20,oDlg,,{||},,,,.T.,,,,{||_nPar==2 .Or. _nPar==3},,,,,"_cMes")

    IF AllTrim(Str(_nPar))$"1/3/4" //visual, alterar ou excluir
		If _nMes > 0
			oCombo:nAt := _nMes
			_cMes := oCombo:aItems[oCombo:nAt]
		EndIf
    EndIf
		
	oSay4 := TSay():New(12,152,{||"Ano"},oDlg,,,,,,.T.,,)
	
	oGet1 := tGet():New(10,165,{|u| if(Pcount() > 0, _cAno:= u,_cAno)},oDlg,20,8,"@e 9999",/*valid*/,;
		,,,,,.T.,,,{||_nPar==2 .Or. _nPar==3},,,,,,,"_cAno")
  
    // cria o getDados
	oGeTD := MsGetDados():New( 30               ,; //superior 
	                           5                ,; //esquerda
	                           220              ,; //inferior
	                           397              ,; //direita 	   
	                           4                ,; // nOpc
	                           "AllwaysTrue"    ,; // CLINHAOK
	                           "AllwaysTrue"    ,; // CTUDOOK
	                           ""               ,; // CINICPOS
	                           .T.              ,; // LDELETA
	                           nil              ,; // aAlter
	                           nil              ,; // uPar1
	                           .F.              ,; // LEMPTY
	                           200              ,; // nMax
	                           nil              ,; // cCampoOk
	                           "AllwaysTrue()"  ,; // CSUPERDEL
	                           nil              ,; // uPar2
	                           "AllwaysTrue()"  ,; // CDELOK
	                           oDlg              ; // oWnd 
	                          )
	                          

	If _nPar == 1 .Or. _nPar == 4//Visualizar ou excluir
		oGetD:nMax := Len(aCols)
	EndIF

    
	//botoes
    oBt1 := tButton():New(225,332,"Ok",oDlg,{||fGrvZBI()},30,10,,,,.T.)      
    oBt2 := tButton():New(225,367,"Cancelar",oDlg,{||fCancRel()},30,10,,,,.T.)

	oDlg:Activate(,,,.T.,{||,.T.},,{||})

Return

//���������������������������������������������8�
//� CALCULA O TOTAL DAS PREVISOES NO MULTILINE �
//���������������������������������������������8�
User Function EST184T(nPos)
Local _nTotal := 0
Local _cField  

	For _x:= 4 to 34
		IF(_x != nPos+3)
			_nTotal += aCols[n][_x]
		EndIf
	Next
	
	_cField := "M->ZBI_PREV"+ALLTRIM(STRZERO(nPos,2))

	_nTotal += &(_cField)
	
	aCols[n][35] := _nTotal
	oGeTD:Refresh()

Return .T.

//���������������������������������������������������Ŀ
//� CRIA A COR DA LEGENDA DO RELEASE DE TRANSFERENCIA �
//�����������������������������������������������������
Static Function fCriaCor2()
Local aLegenda := {{"BR_VERDE"   , OemToAnsi("Pendente") },; 
  				   {"BR_VERMELHO", OemToAnsi("Realizado")}}

Local uRetorno := {}

	Aadd(uRetorno, { 'AllTrim(STR(Year(ZBI_DATA)))+AllTrim(STR(Month(ZBI_DATA))) >= AllTrim(STR(Year(Date())))+AllTrim(Str(Month(DATE())))' , aLegenda[1][1] } )
	Aadd(uRetorno, { 'AllTrim(STR(Year(ZBI_DATA)))+AllTrim(Str(Month(ZBI_DATA))) <  AllTrim(Str(Year(Date())))+AllTrim(Str(Month(DATE())))' , aLegenda[2][1] } )

Return(uRetorno)

//�������������������������������������Ŀ
//� LEGENDA DO RELEASE DE TRANSFERENCIA �
//���������������������������������������
User Function EST184LG2()

Local aLegenda :=	{{"BR_VERDE"   , OemToAnsi("Pendente") },;
  					 {"BR_VERMELHO", OemToAnsi("Realizado")}}
  					  
BrwLegenda(OemToAnsi("Transfer�ncia Fun/Usi"), "Legenda", aLegenda)

Return

//�����������������Ŀ
//� CANCELA RELEASE �
//�������������������
Static Function fCancRel()

	If _nPar == 2	
		RollBackSx8()//retorna numera��o
	EndIf
	
	oDlg:End()
	
Return


//�����������������������������Ŀ
//� TRAZ A DESCRICAO DO PRODUTO �
//�������������������������������
User Function fEST139PRD()
nDesc := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="B1_DESC"})

	SB1->(DBSETORDER(1))
	If SB1->(DBSEEK(XFILIAL("SB1")+M->ZBI_PRODUT))
		aCols[n][nDesc] := SB1->B1_DESC
		oGetD:Refresh()
	Else
		Alert("Produto n�o encontrado!")
		Return .F.
	Endif

Return .T.


Static Function fCcusto()

Local _lRet := .T.

CTT->(DbSetOrder(1))
If CTT->(DbSeek(xFilial("SB1")+_cCCusto))
   _cDescc := CTT->CTT_DESC01
   If Len(Alltrim(_cCCusto)) < 8
      Msgbox("Centro de Custo Deve Ter 8 Digitos Verifique !!!" ,"Atencao","ALERT" )     
      _lRet := .F.
   Endif
Else
   Msgbox("Centro de Custo Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
   _lRet := .F.
Endif                 
oDescc:Refresh()  
Return(_lRet)



Static Function fProd()

Local _lRet := .T.

SB1->(DbSetOrder(1))
If SB1->(DbSeek(xFilial("SB1")+_cProd))
   _cDescP := SB1->B1_DESC
Else
   Msgbox("Produto Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
   _lRet := .F.
Endif                 
oDescP:Refresh()  
Return(_lRet)

Static Function fFor()

Local _lRet := .T.

SA2->(DbSetOrder(1))
If SA2->(DbSeek(xFilial("SA2")+_cFor))
   _cDescF := SA2->A2_NOME
Else
   Msgbox("Fornecedor Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
   _lRet := .F.
Endif                 
oDescF:Refresh()  
Return(_lRet)

Static Function fLoja()

Local _lRet  := .T.


SA2->(DbSetOrder(1))
SA5->(DbSetOrder(1))  //filial+Fornece+loja+produto 
   
If SA2->(DbSeek(xFilial("SA2")+_cFor+_cLoja))
   _cDescF := SA2->A2_NOME
Else
   Msgbox("Fornecedor Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
   _lRet := .F.
   oFor:SetFocus(oFor)
   oFor:Refresh()
   _lRet := .F.
Endif                 
oDescF:Refresh()  
Return(_lRet)


Static Function fGerar()
Local _cLote := Space(10)
Local _nx := 0
aCols     := {}
   cQuery := "SELECT SB1.B1_TIPO,SB1.B1_RASTRO,SB1.B1_LOCALIZ,SB1.B1_DESC,SG1.G1_COD,SG1.G1_COMP,"+STRZERO(_nQuant,10) +"*SG1.G1_QUANT AS G1_QUANT"
   cQuery += " FROM " + RetSqlName( 'SG1' ) +" SG1 (NOLOCK),"+ RetSqlName( 'SB1' ) +" SB1 (NOLOCK)"
   cQuery += " WHERE G1_FILIAL = '" + xFilial("SG1")+ "'"   
   cQuery += " AND B1_FILIAL = '" + xFilial("SB1")+ "'"         
   cQuery += " AND SG1.G1_OPERACA <= '" + _cOper + "'"     
   cQuery += " AND SG1.G1_INI <='" + Dtos(Ddatabase) + "' AND SG1.G1_FIM >= '"+Dtos(Ddatabase)+ "'"
   cQuery += " AND SG1.G1_COD = '" + _cProd + "'"       
   cQuery += " AND SG1.G1_COMP = SB1.B1_COD"                		
   cQuery += " AND SUBSTRING(SG1.G1_COMP,7,1) <> '6'"
   cQuery += " AND SUBSTRING(SG1.G1_COMP,1,3) <> 'MOD'"        
   cQuery += " AND SG1.D_E_L_E_T_ = ' ' "   
   cQuery += " AND SB1.D_E_L_E_T_ = ' ' "      
   cQuery += " ORDER BY SG1.G1_COMP ASC" 
   MemoWrit('C:\TEMP\NHEST184.SQL',cQuery)
   TCQUERY cQuery NEW ALIAS "TMPA"   
   
   TMPA->(Dbgotop())
   SB8->(DbSetOrder(1)) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+DTOS(B8_DTVALID)+B8_LOTECTL+B8_NUMLOTE
   While TMPA->(!Eof())   
      _nx += 1   


      _cLote := Space(10)
  	  If TMPA->B1_RASTRO$"L" //TEM CONTROLE POR LOTE

		 lLote := .T.
		
		 SB8->(DbSeek(xFilial("SB8")+TMPA->G1_COMP+_cAlmxo))//Filial + produto + almox origem
		 If SB8->(Found())

			While SB8->(!EOF()) .AND. SB8->B8_PRODUTO==TMPA->G1_COMP .AND. SB8->B8_LOCAL == _cAlmxo
			
			   If (SB8->B8_SALDO - SB8->B8_EMPENHO) >= TMPA->G1_QUANT // verifica se o SB8 (lote) tem qtde maior ou igual a qtde p/ transferir do refugo
                  _cLote := SB8->B8_LOTECTL // Armazena o lote p/ transf para o refugo
                  Exit //forca a saida do while
			   EndIf
				         
			   SB8->(DBskip())
			EndDo
		 Else
			Alert("Produto n�o possui saldo em nenhum lote, Verifique!")
			Return .F.
		 EndIf

	  EndIf
      
      Aadd(Acols,{StrZero(_nx,4),TMPA->G1_COMP,TMPA->B1_DESC,TMPA->G1_QUANT,_cLote,Iif(TMPA->B1_LOCALIZ$"S","01",Space(15)),.F.})  
      
      TMPA->(Dbskip())
   Enddo
   
   oMultiline:Refresh()	
   TMPA->(DbCloseArea())	

Return                                   


Static Function fAlmxo()
Local _lRet := .F.

SX5->(Dbgotop())       
SX5->(DbSetOrder(1)) //filial+cod
SX5->(DbSeek(xFilial("SX5")+"ZA")) //tabelas de almoxarifados
   While SX5->(!Eof()) .And. SX5->X5_TABELA  == "ZA"
   	  If _cAlmxo == AllTrim(SX5->X5_CHAVE)  //Verifica se o almox existe 
   	     _cDAlmxo := AllTrim(SX5->X5_DESCRI)
   	     _lRet := .T.
         Exit //
      Endif                       
      SX5->(Dbskip())
   Enddo
oDAlmxo:Refresh()     
Return(_lRet)

Static Function fAlmxd()
Local _lRet := .F.

SX5->(Dbgotop())       
SX5->(DbSetOrder(1)) //filial+cod
SX5->(DbSeek(xFilial("SX5")+"ZA")) //tabelas de almoxarifados
   While SX5->(!Eof()) .And. SX5->X5_TABELA  == "ZA"
   	  If _cAlmxd == AllTrim(SX5->X5_CHAVE)  //Verifica se o almox existe 
   	     _cDAlmxd := AllTrim(SX5->X5_DESCRI)
   	     _lRet := .T.
         Exit //
      Endif                       
      SX5->(Dbskip())
   Enddo
oDAlmxd:Refresh()     
Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function fDef()
Local _lRet := .F.
_cDefdes := Space(30)

SZ6->(DbSetOrder(1)) //filial+cod
If SZ6->(Dbseek(xfilial("SZ6")+_cDef))
    _cDefdes := SZ6->Z6_DESC 
    _lRet := .T.
Else
   MsgBox( "Codigo do Defeito nao Existe!", "Transferencia", "ALERT" )      
   oDef:SetFocus(oDef)
   oDef:Refresh()
Endif

oDefDes:Refresh()     
Return(_lRet)


Static Function fCar()
Local _lRet := .F.

_cCarD := Space(30)

SZ8->(DbSetOrder(1)) //filial+cod
If SZ8->(Dbseek(xfilial("SZ8")+_cCarDef))
    _cCarD := SZ8->Z8_DESC 
    _lRet := .T.
Else
   MsgBox( "Codigo do Defeito nao Existe!", "Transferencia", "ALERT" )      
   oCar:SetFocus(oCar)
   oCar:Refresh()
Endif

oCarD:Refresh()     
Return(_lRet)


//@ 018,350 Get _dData         SIZE 040,008 Object oData Valid fData()
Static Function fData()
Local _lRet := .T.
Local _nDias    := GETMV("MV_DIASMO")

If _dData < (Date()- _nDias) .OR. _dData < (dDatabase - _nDias)  //Controle de data para n�o permitir mov. com data retroativa controle paramatro mv_diasmo = numero de dias
   MsgBox( "Impossivel Fazer a Transferencia Data Menor que a Permitida Depto Custo! ", "Transferencia", "ALERT" )
   _lRet := .F.
Endif                 

Return(_lRet)

Static Function fOper()
Local _lRet := .T.
Local _nx

For _nx:= 1 to 3
   If Subs(_cOper,_nx,1) == " "
      _lRet := .F.      
      MsgBox( "Nao Pode Conter Espa�o no Campo Opera��o! ", "Transferencia", "ALERT" )    
      oOper:SetFocus(oOper)
      oOper:Refresh()
   Endif
Next
Return(_lRet)



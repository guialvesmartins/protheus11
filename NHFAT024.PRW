/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHFAT024  � Autor � Jo�o Felipe da Rosa    Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Solicitacao de Cancelamento de Notas Fiscais de Saida      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Rdmake                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Expedi��o/ PCP / Manuten�ao / Informatica / Eng            ���
��������������������������������������������������������������������������ٱ�
�� Altera��es:                                                             ��
�� 16/07/2012 - Adicionado a fun��o de encerramento manual conforme pedido ��
�� do usuario Samuel Cracco - Fiscal  -  Alterado por Douglas Dourado      �� 
�����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"
#include "protheus.ch"

User Function nhfat024()

//ALERT("Clique em sair na pr�xima tela para ir ao programa verdadeiro")
//axcadastro("ZAF","ZAF")

SetPrvt("CCADASTRO,AROTINA,dDtEmi")
fAtual()                                
cCadastro := OemToAnsi("Cancelamento de N.F. de Sa�da")
aRotina := {{ "Pesquisa"    ,"AxPesqui"  , 0 , 1},;
            { "Encerrar"    ,'U_fCanc(6)', 0 , 3},;
            { "Inclui"      ,'U_fCanc(3)', 0 , 3},;
            { "Visualizacao",'U_fCanc(2)', 0 , 2},;
            { "Altera"      ,'U_fCanc(5)', 0 , 5},;            
            { "Exclui"      ,'U_fCanc(4)', 0 , 4},;                   
            { "Legenda"     ,'U_FLegCanc', 0 , 2}}     
            
mBrowse( 6, 1,22,75,"ZAF",,,,,,fCriaCor())
Return

Static Function fAtual() //funcao verifica se a nota esta deletada, se estiver, grava o status na ZAF como "S"

Local cQuery

	If Select("TRA1")>0
		TRA1->(dbCloseArea())
	EndIf

	cQuery := "SELECT * FROM "+ RetSqlName('ZAF')
	cQuery += " WHERE ZAF_STATUS = ' '"
	cQuery += " AND D_E_L_E_T_ = ' ' AND ZAF_FILIAL = '"+xFilial('ZAF')+"'"

	TCQUERY cQuery NEW ALIAS 'TRA1'

	If	! USED()
		MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
	EndIf
    
    ZAF->(DbgoTop())
	
	While TRA1->(!EoF())
		   
		If Select("TRB")>0
			TRB->(dbCloseArea())
		EndIf
		
		cQuery2 := "SELECT * FROM "+ RetSqlName('SF2')+" F2"
		cQuery2 += " WHERE F2.F2_DOC = '"+TRA1->ZAF_DOC+"'"
		cQuery2 += " AND F2.F2_SERIE = '"+TRA1->ZAF_SERIE+"'"			
		cQuery2 += " AND F2.D_E_L_E_T_ = '*' AND F2.F2_FILIAL = '"+xFilial('SF2')+"'" //deve trazer somente registros deletados

		TCQUERY cQuery2 NEW ALIAS 'TRB'

		If	! USED()
			MsgBox(cQuery2+'. Query errada','Erro!!!','STOP')
		EndIf

		
		If !Empty(TRB->F2_DOC)
			ZAF->(DbSetOrder(2)) //FILIAL+DOC+SERIE 
			ZAF->(DbSeek(xFilial('ZAF')+TRB->(F2_DOC+F2_SERIE)))
			If ZAF->(Found())
				RecLock('ZAF',.F.)
					ZAF->ZAF_STATUS := 'S'
				MsUnLock('ZAF')
			EndIf
		EndIf
		TRB->(DbCloseArea())
		TRA1->(DbSkip())
	EndDo
	TRA1->(DbCloseArea())
Return

User Function fCanc(cPar01)
													
SetPrvt("_cCodUsr,_cMat,_cSolic,_cSetor,_cData,_cNF,_cMotivo,_cSerie ")  

DEFINE FONT oFont NAME "Arial" SIZE 10, -12                                                                  
DEFINE FONT oFont10 NAME "Arial" SIZE 10, -10

_cPar   := cPar01 // receber visualiza�ao ou impressao ou alteracao     
lDialog := .F.               
_cSerie := Space(03)
_cMotivo:= Space(120)
_cDoc   := Space(06)
_cNF 	:= Space(09)
_cUser  := Space(06)
_cRamal := Space(04)
aHeader := {}        
aCols   := {}
 nMax    := 0      
 
If _cPar == 6
  fEncerra()
  Return                    

ElseIf _cPar == 3 //Inclui

	//-- OS: 065177
	If Upper(alltrim(cUsername))$"FABIOBS/ANDRELR/SILVANOAR/MARCIOLT/JOAOSN"
		Alert("Usu�rio sem permiss�o, Bloqueio solicitado por Bruno R. Ferreira Andrade!")
		REturn
	Endif
	//FIM OS 065177

   dbSelectArea("SX3")
   SX3->(dbSetOrder(1))
   SX3->(MsSeek("ZAF"))
   While (!SX3->(Eof()) .And. (SX3->X3_ARQUIVO == "ZAF") )
      If ( X3USO(SX3->X3_USADO) .And.;
			Trim(SX3->X3_CAMPO) <> "ZAF_NUM" )
			Aadd(aHeader,{ TRIM(X3Titulo()),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;      
					SX3->X3_VALID,;  
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_ARQUIVO,;
					SX3->X3_CONTEXT})
      Endif
      SX3->(dbSkip())
   	EndDo
   	DbSelectArea("ZAF")
   	_cDoc  := GetSXENum("ZAF","ZAF_COD")   // Traz o novo numero do cancelamento de NF
   	_cRamal   := Iif( Empty(Subs(U_Nhcfg001("06"),6,4)),Space(04),Subs(U_Nhcfg001("06"),6,4))

	// Verifica se tem cadastrado o login na QAA, se n�o tiver gera uma mensagem, por�m n�o impede o cancelamento da NF.
	QAA->(DbSetOrder(6)) //LOGIN
	If QAA->(DbSeek(Upper(Alltrim(cUserName)))) //LOGIN
	   	_cMat  := QAA->QAA_MAT
	Else
	 	_cMat  := "      "
	 	Msgbox(OemToAnsi("Usu�rio n�o cadastrado na lista de usu�rios!"),"Atencao - QAA","ALERT" )  
	EndIf
   	_cSolic := UsrFullname(__cUserId )
   	_cSetor := U_Nhcfg001("03")
   	_cData  := DtoC(Date())

Else
   If _cPar == 2 .Or. _cPar == 4 .Or. _cPar == 5 //Visualizacao/exclusao/alteracao
	   	_cDoc  	:= ZAF->ZAF_COD
	   	_cMat  	:= ZAF->ZAF_MAT
	   	_cSolic	:= ZAF->ZAF_SOLICI
		_cNF	:= ZAF->ZAF_DOC    
      	_cSerie := ZAF->ZAF_SERIE
        _cSetor := ZAF->ZAF_SETOR
      	_cData 	:= DtoC(ZAF->ZAF_DATA)
      	_cRamal := ZAF->ZAF_RAMAL 
		_cMotivo:= ZAF->ZAF_JUST	
   Endif
   If _cPar == 5 .And. ZAF->ZAF_STATUS <> ' '
		MsgBox(OemtoAnsi("Solicita��o j� Conclu�da!"),"Atencao","INFO")
   		Return
   EndIf
Endif         

	If Empty(_cRamal)
		_cRamal := Space(4)
	Endif	


Define MsDialog oDialog Title OemToAnsi("Cancelamento de Nota Fiscal de Saida") From 010,030 To 190,860 Pixel 
@ 013,007 To 072,410 Title OemToAnsi("Digite os Dados ") //Color CLR_HBLUE
@ 027,010 Say OemToAnsi("N�mero:") Size 030,8 Object oNum
@ 027,032 Say _cDoc Size 035,10 Object oDoc
oDoc:Setfont(oFont)
@ 027,073 Say OemToansi("Solicitante:") Size 30,8 Object oSoli
@ 027,103 Say _cSolic Size 200,10 Object oSolic     
@ 027,238 Say OemToansi("Matr�cula:") Size 30,8 Object oMtr
@ 027,263 Get _cMat Size 035,10 When(_cPar == 3 .Or. _cPar == 5) Valid fMat() Object oMat     
@ 027,300 Say OemToansi("Setor:") Size 30,8 Object oSet
@ 027,320 Say _cSetor Size 050,10 Object oSetor     
@ 040,010 Say OemToansi("Nota Fiscal:")  Size 30,8 Object oNota
@ 040,044 Get _cNF Size 010,10 F3 "SF2" When(_cPar == 3 .Or. _cPar == 5) Valid fNF() Object oNF
@ 040,100 Say OemToansi("Serie:")  Size 30,8 Object oSeri
@ 040,115 Get _cSerie Size 005,05 When(_cPar == 3 .Or. _cPar == 5) Valid fSerie() Object oSerie
@ 040,150 Say OemToansi("Data:") Size 30,8 Object oSeri
@ 040,165 Say _cData Size 050,10 Object oData
@ 040,210 Say OemToansi("Ramal:") Size 30,8 Object oRam
@ 040,230 Get _cRamal Size 050,10 When(_cPar == 3 .Or. _cPar == 5) PICTURE "@!" Valid fRamal() Object oRamal
@ 053,010 Say OemToansi("Justificativa:") Size 30,8 Object oJust
@ 053,044 Get _cMotivo When(_cPar == 3 .Or. _cPar == 5) Size 350,10 Object oMotivo

@ 076,340 BMPBUTTON TYPE 01 ACTION fGrvOrd()
@ 076,380 BMPBUTTON TYPE 02 ACTION fEnd() 

Activate MsDialog oDialog Center 
Set Key VK_F4 To //Desabilita a tecla F4

Return           

//����������������������Ŀ
//� VALIDA A NOTA FISCAL �
//������������������������
Static Function fNF()
	SF2->(DbSetOrder(1))//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
	SF2->(DbSeek(xFilial('SF2')+_cNF)) 
	If SF2->(!Found()).Or. Len(_cNF) <> 9
       	Msgbox("Nota Fiscal n�o encontrada!" ,"Atencao","ALERT" )
		Return(.F.)
	Else
		_cSerie := "1  " //Recebe a Serie Padrao
		oNF:Refresh()
	EndIf
Return(.T.)

//���������������������Ŀ
//� VALIDA A NF + SERIE �
//�����������������������
Static Function fSerie()
	SF2->(DbSetOrder(1))//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
	SF2->(DbSeek(xFilial('SF2')+_cNF+_cSerie))
	If SF2->(!Found())
       	Msgbox("Serie da Nota Fiscal n�o encontrada!" ,"Atencao","ALERT" )
		Return(.F.)
	Else
		dDtEmi := SF2->F2_EMISSAO
	EndIf

Return(.T.)

//���������������Ŀ
//�VALIDA O RAMAL �
//�����������������
Static Function fRamal()

If Empty(_cRamal) .Or. Len(Alltrim(_cRamal)) <> 4
   Msgbox("Favor Preencher o Ramal do Solicitante Corretamente, Verifique !!!" ,"Atencao","ALERT" )     
   _cRamal := Space(04)
   Return(.F.)
Endif

Return(.T.)

//���������������������Ŀ
//� VALIDA O FORMULARIO �
//�����������������������
Static Function fDialog()

   If Empty(_cNF) .Or. Empty(_cMotivo) 
      lDialog := .F.  
   Else
      lDialog := .T.                        
   Endif        
   
Return(lDialog)

//�������������������
//� ENCERRA A JANELA �
//�������������������
Static Function fEnd() 

   If _cPar == 3 //Opcao incluir
      RollBackSx8() //Volta a numera��o da Ordem de Libera��o
   Endif   
   Close(oDialog) 
Return

//���������������������������������������Ŀ
//� GRAVA A SOLICITACAO DE EXCLUSAO DE NF �
//�����������������������������������������
Static Function fGrvOrd()
Local _lGravou := .F.
   
   If _cPar == 3  //incluir
      
/*
      If Empty(_cNF) .Or. Len(Alltrim(_cNF)) <> 9
         Msgbox("Favor Preencher o N�mero da Nota Fiscal Corretamente, Verifique !!!" ,"Atencao","ALERT" )     
         Return(.F.)
      Endif       
*/
	

      
      If !fDialog()  //Verifica as valida��es
         Msgbox("Falta Preencher algum Campo Obrigatorio, Verifique !!!" ,"Atencao","ALERT" )     
         Return(.F.)
      Endif
      
		  //Begin Transaction                   
             If !_lGravou
	  	        ZAF->(DbSetOrder(1))
	  	        ZAF->(DbSeek(xFilial("ZAF")+_cDoc))
	  	        If ZAF->(Found())
  	               Msgbox("Solicita��o j� foi Gravada com Este Numero, Verifique !!!" ,"Atencao","ALERT" )
		        Else
		           Reclock("ZAF",.T.)
		              ZAF->ZAF_FILIAL := xFilial("ZAF")
			          ZAF->ZAF_COD    := _cDoc
				      ZAF->ZAF_DOC    := _cNF
				      ZAF->ZAF_SERIE  := _cSerie
				      ZAF->ZAF_MAT    := _cMat
				      ZAF->ZAF_SOLICI := _cSolic
				      ZAF->ZAF_SETOR  := _cSetor
				      ZAF->ZAF_DATA   := CtoD(_cData)
				      ZAF->ZAF_JUST	  := _cMotivo
				      ZAF->ZAF_RAMAL  := _cRamal
				      ZAF->ZAF_STATUS := " "
			       MsUnlock("ZAF")     
                   _lGravou := .T.
          	     // End Transaction   	  
	            Endif
	         Endif
        
	  If _lGravou  //Faz a verifica��o se gravou os itens da solicita��o da nota
	     ConfirmSX8()
   	     fMail()
   	     fLimpa()
   	  Else                                               
   	     RollBackSx8() //Volta a numera��o da Solicita��o do Cancelamento
	  Endif
   Else
     	If _cPar == 5 //alterar
      		If Empty(_cNF) .Or. Len(Alltrim(_cNF)) <> 6
         		Msgbox("Favor Preencher o N�mero da Nota Fiscal Corretamente, Verifique !!!" ,"Atencao","ALERT" )     
	     	    Return(.F.)
    	  	Endif
    	  	
      		If !fDialog()  //Verifica as valida��es
	 	        Msgbox("Falta Preencher algum Campo Obrigatorio, Verifique !!!" ,"Atencao","ALERT" )     
	     	    Return(.F.)
	      	Endif
      
	        //Begin Transaction                   
         	If !_lGravou
	  	    	ZAF->(DbSetOrder(1))
	  	    	ZAF->(DbSeek(xFilial("ZAF")+_cDoc))

 			  	If ZAF->ZAF_MAT == _cMat .And. ZAF->ZAF_SOLICI == _cSolic //Verifica se � o mesmo usu�rio que solicitou

	     	        Reclock("ZAF",.F.)
				      	ZAF->ZAF_DOC    := _cNF
				      	ZAF->ZAF_SERIE  := _cSerie
				      	ZAF->ZAF_JUST	:= _cMotivo
  				     	ZAF->ZAF_RAMAL  := _cRamal
			       MsUnlock("ZAF")     
                   _lGravou := .T.
          	     // End Transaction   	  
	            Else 
       	         	Msgbox("Permitido apenas para o usu�rio solicitante!" ,"Atencao","ALERT" )     
			        Close(oDialog)	                           					
	            Endif
	        Endif
	  		If _lGravou  //Faz a verifica��o se gravou os itens da solicita��o da nota sen�o exclui o cabe�alho
	     		ConfirmSX8()   
   	  		Else                                               
   	     		RollBackSx8() //Volta a numera��o da Solicita��o do Cancelamento
	  		Endif

	        Close(oDialog)	                           
   		EndIf

   		If _cPar == 2 //visualizacao
			Close(oDialog)
		EndIf

		If _cPar == 4   //exclus�o
		   	If ZAF->ZAF_STATUS <> ' '
				MsgBox(OemtoAnsi("Solicita��o j� Conclu�da!"),"Atencao","INFO")
   				Return
   			EndIf
			If MsgBox("Tem certeza de que deseja excluir a Solicita��o de Cancelamento?","Atencao","YESNO")
 			  	If ZAF->ZAF_MAT == _cMat .And. ZAF->ZAF_SOLICI == _cSolic //Verifica se � o mesmo usu�rio que solicitou
					RecLock("ZAF",.F.)
						ZAF->(DbDelete())
					MsUnLock("ZAF",.F.)
					Close(oDialog)
				Else
      	         	Msgbox("Permitido apenas para o usu�rio solicitante!" ,"Atencao","ALERT" )     
			        Close(oDialog)
				EndIf
			EndIf
		EndIf
    EndIf
Return


User Function FLegCanc()       

	Local aLegenda :=	{ {"BR_VERDE"    , "Aberta"  },;
  					  {"BR_VERMELHO" , "Fechada"   }}

	BrwLegenda(OemToAnsi("Solicita��o de Nota Fiscal"), "Legenda", aLegenda)

Return  


Static Function fCriaCor()       

	Local aLegenda :=	{ {"BR_VERDE"   , "Aberta"  },;
	  					  {"BR_VERMELHO" , "Fechada"   }}

	Local uRetorno := {}
	Aadd(uRetorno, { 'ZAF_STATUS = " "' , aLegenda[1][1] } )
	Aadd(uRetorno, { 'ZAF_STATUS <> " "', aLegenda[2][1] } )
Return(uRetorno)

Static Function fMat()
/*	SRA->(DbSetOrder(1)) //filial + mat
	SRA->(DbSeek(xFilial('SRA')+_cMat))
	If SRA->(!Found()) .Or. Empty(_cMat) 
		MsgAlert("Matr�cula inv�lida. Verfique!")	
		Return(.F.)
	EndIf*/
Return(.T.) 

/************************************* CODIGO ENCERRAMENTO DE NF PENDENTE *******************************************/    

Static Function fEncerra() // Encerrar a NF e atribui uma nota de ajuste   
Private oDlg1, cGetNF := space(09), cGetSerie := space(3), cGetForn := space(06), cGetLoja := space(2), cF3 := Space(03)
Private _aCliFor := {"","Cliente","Fornecedor"}, _cCliFor 

IF (ZAF->ZAF_STATUS == 'S')
	Alert('Esta nota j� est� encerrada!')
	Return 
Else	

_cDoc  	 := ZAF->ZAF_COD
_cMat  	 := ZAF->ZAF_MAT
_cSolic	 := ZAF->ZAF_SOLICI
_cNF	 := ZAF->ZAF_DOC    
_cSerie  := ZAF->ZAF_SERIE
_cSetor  := ZAF->ZAF_SETOR
_cData 	 := DtoC(ZAF->ZAF_DATA)
_cMotivo := ZAF->ZAF_JUST
_cRamal  := ZAF->ZAF_RAMAL	

Define MsDialog oDlg1 Title "Encerramento de Nota Fiscal de Saida" From 010,030 To 165,860 Pixel 

@ 007,005 Say "N�mero:" Size 030,8 PIXEL OF oDlg1        // nota f.  - 1
@ 007,027 Say _cDoc Size 035,10 PIXEL OF oDlg1 

@ 007,068 Say "Solicitante:" Size 30,8 PIXEL OF oDlg1    // Solicitante  - 1
@ 007,098 Say _cSolic Size 200,10 PIXEL OF oDlg1     

@ 007,205 Say "Matr�cula:" Size 30,8 PIXEL OF oDlg1      // Matricula  - 1
@ 005,230 Get _cMat Size 035,10 WHEN(.F.) PIXEL OF oDlg1  // Campo Somente para Visualiza��o
   
@ 007,280 Say "Setor:" Size 30,8 PIXEL OF oDlg1          // Setor   -  1
@ 007,300 Say _cSetor Size 050,10  PIXEL OF oDlg1 

@ 025,270 Say "Tipo da Nota:" Size 50,8 PIXEL OF oDlg1   // Tipo Nota   -  1
@ 023,305 COMBOBOX _cCliFor ITEMS _aCliFor SIZE 45,10 OBJECT oCliFor    
  
@ 025,005 Say "Nota Fiscal:"  Size 30,8 PIXEL OF oDlg1   // Nota Fiscal  - 2
@ 023,035 Get _cNF Size 010,10 WHEN(.F.) PIXEL OF oDlg1  

@ 025,095 Say "Serie:" Size 30,8 PIXEL OF oDlg1          // Serie  - 2
@ 024,110 Get _cSerie Size 005,05 WHEN(.F.) PIXEL OF oDlg1    

@ 025,145 Say "Data:" Size 30,8 PIXEL OF oDlg1           // Data   -  2
@ 025,160 Say _cData Size 050,10 PIXEL OF oDlg1                  

@ 025,205 Say "Ramal:" Size 30,8 PIXEL OF oDlg1          // Ramal   -  2
@ 023,225 Get _cRamal Size 020,10 WHEN(.F.) PIXEL OF oDlg1  

@ 043,005 Say "Justificativa:" Size 30,8 PIXEL OF oDlg1  // Justificativa - 3
@ 041,039 Get _cMotivo Size 250,10 WHEN(.F.) PIXEL OF oDlg1 

@ 061,005 Say "Numero Entrada NF : " PIXEL OF oDlg1      // Numero NF de Ajuste  - 4
@ 059,055 Get cGetNF SIZE 35,10 F3 "SD1"  

@ 061,105 Say "Serie: " PIXEL OF oDlg1                   // Serie    -  4
@ 059,120 Get cGetSerie SIZE 10,10 PIXEL OF oDlg1 

@ 061,146 Say "Fornecedor: " /*PIXEL OF oDlg1*/ OBJECT oCliSay              // Fornecedor  - 5
@ 060,178 GET cGetForn SIZE 25,10 F3 "SA2" OBJECT oCli 

@ 061,216 Say "Loja: " PIXEL OF oDlg1                    // Loja - 6
@ 059,230 GET cGetLoja SIZE 15,10 PIXEL OF oDlg1 

@ 053,347 BUTTON "Confirmar" Size 30,20 PIXEL OF oDlg1 action ConfirmaEnc()  // Confirma
@ 053,382 BUTTON "Cancelar"  Size 30,20 PIXEL OF oDlg1 action close(oDlg1)  // Cancela

oCliFor:bChange:={|| fCli() } 

Activate MsDialog oDlg1 Centered 

EndIf

Return 

Static Function fCli()

If(_cCliFor$"Cliente")  //Cliente
   _cCliFor:= "Cliente:"   
   oCli:cF3:= "SA1"     

else //Fornecedor 
   _cCliFor:= "Fornecedor:"   
   oCli:cF3:= "SA2"
endif

oCli:Refresh() 
ObjectMethod(oCliFor,"SetText(_cCliFor)") //Muda conteudo para cliente ou fornecedor
ObjectMethod(oCliSay,"SetText(_cCliFor)") //Muda conteudo para cliente ou fornecedor
          
Return()


Static Function ConfirmaEnc()  // Confirma o Encerramento de uma Solicita��o de Cancelamento
      
	   IF !ValidaEnc()
	    	Return
   	   EndIf   
   	   
   	   SD1->(DBSETORDER(1))     
   	   
   	   If SD1-> ( DBSEEK( xFilial("SD1") + cGetNf + cGetSerie + cGetForn + cGetLoja ) )
   	      				
	      RecLock("ZAF",.F.)  
	            ZAF->ZAF_STATUS  := "S"
   		        ZAF->ZAF_NFENT   := cGetNF
		  		ZAF->ZAF_SERENT  := cGetSerie 
				ZAF->ZAF_FORENT  := cGetForn
				ZAF->ZAF_LOJENT  :=	cGetLoja
		  MsUnlock("ZAF") 
          
          MsgBox('Nota Encerrada com Sucesso', 'OK', 'INFO')          
          oDlg1:End() 
   		
   	   Else
   		
   		  Alert("Nota Fiscal de Entrada n�o Encontrada !")
   		  Return
   		
   	  EndIf
   		  
Return                


Static Function ValidaEnc()  // Valida os Campos referentes ao encerramento de solicita��o de cancelamento 

	If Empty(cGetNF) 
	  Alert('Favor informar o numero da nota') // Valida o campo Nome do Produto
    Return .F. 
    EndIf 
    
    If Empty(cGetForn) 
	  Alert('Favor informar o fornecedor') // Valida o campo Nome do Produto
    Return .F.        
    EndIf  
    
    If Empty(cGetLoja) 
	  Alert('Favor informar a loja') // Valida o campo Nome do Produto
    Return .F.        
    EndIf 

Return .T. 

/*****************************************************************************************************************/

Static Function fLimpa()

_cNF	:= Space(06)
_cMotivo:= Space(120)
_cSerie := Space(03)

   	DbSelectArea("ZAF")
   	_cDoc  := GetSXENum("ZAF","ZAF_COD")   // Traz o novo numero do cancelamento de NF
   	_cRamal   := Iif( Empty(Subs(U_Nhcfg001("06"),6,4)),Space(04),Subs(U_Nhcfg001("06"),6,4))

	If Empty(_cRamal)
		_cRamal := space(4)
	endif
	
// Verifica se tem cadastrado o login na QAA, se n�o tiver gera uma mensagem, por�m n�o impede o cancelamento da NF.
	QAA->(DbSetOrder(6)) //LOGIN    
	
	If QAA->(DbSeek(Upper(Alltrim(cUserName)))) //LOGIN
	   	_cMat  := QAA->QAA_MAT
	Else
	 	_cMat  := "-"
	EndIf
   	_cSolic := UsrFullname(__cUserId )
   	_cSetor := U_Nhcfg001("03")
   	_cData  := DtoC(Date())
	Close(oDialog)
Return

//���������������������������������������������������������������������������Ŀ
//� ENVIA EMAIL PARA LISTA FISCAL INFORMANDO DA SOLICITACAO DA EXCLUSAO DE NF �
//�����������������������������������������������������������������������������
Static Function fMail()
Local cMsg

	cMsg := '<html>'
	cMsg += '<body style="font-family:arial">'
	cMsg += '<p></p>'
	cMsg += '<table width="100%" border="1">'

	cMsg += '  <tr style="background:#ccc">'
	cMsg += '    <td colspan="4">'
	cMsg += '      Solicita��o de Exclus�o de NF'
	cMsg += '    </td>'
	cMsg += '  </tr>'
	
	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">N�mero Solicit.</td>'
	cMsg += '    <td>'+_cDoc+'</td>'
	cMsg += '    <td style="background:#abc">Nota Fiscal</td>'
	cMsg += '    <td>'+_cNF+'-'+_cSerie+' (Emiss�o: '+dtoc(dDtEmi)+')</td>'
	cMsg += '  </tr>'
	
	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Solicitante</td>'
	cMsg += '    <td>'+_cSolic+'</td>'
	cMsg += '    <td style="background:#abc">Setor</td>'
	cMsg += '    <td>'+_cSetor+'</td>'
	cMsg += '  </tr>'

	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Data</td>'
	cMsg += '    <td>'+_cData+'</td>'
	cMsg += '    <td style="background:#abc">Ramal</td>'
	cMsg += '    <td>'+_cRamal+'</td>'
	cMsg += '  </tr>'

	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Motivo</td>'
	cMsg += '    <td colspan="3">'+_cMotivo+'</td>'
	cMsg += '  </tr>'

	cMsg += '</table><br />'
	cMsg += '</body>'
	cMsg += '</html>
		
	cTo := Iif (SM0->M0_CODIGO$"NH/FN","luizwj@whbbrasil.com.br;lista-fiscal@whbbrasil.com.br","fiscal@itesa.com.br")     
	
	oMail          := Email():New()
	oMail:cMsg     := cMsg
	oMail:cAssunto := "*** SOLIC. DE EXCLUS�O DE NOTA FISCAL - "+alltrim(_cNF)+" - "+alltrim(_cSerie)+" ***"
	oMail:cTo      := cTo
	
	oMail:Envia()

Return

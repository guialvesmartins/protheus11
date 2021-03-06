#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHEST118   �Autor �Jo�o Felipe         � Data �  05/05/2008���
�������������������������������������������������������������������������͹��
���Desc.     � RELAT�RIO DE D�BITOS DO CLIENTE				              ���
�������������������������������������������������������������������������͹��
���Uso       � MANUTENCAO                                                 ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA � MOTIVO                                          ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHEST118()   

cString   := "QM2"
cDesc1    := OemToAnsi("Este   relatorio   tem   como   objetivo  Imprimir ")
cDesc2    := OemToAnsi("a rela��o de D�bitos dos Clientes da WHB.")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST118"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("D�BITOS DOS CLIENTES")
cabec1    := "Cliente  Loja                            N.F.      Emissao      Valor                Motivo                                             Resultado"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHEST118"
_cPerg    := "EST118" 
 
// mv_par01 de instrumento
// mv_par02 at� instrumento
// mv_par03 de respons�vel
// mv_par04 at� repons�vel
// mv_par05 de data
// mv_par06 at� data
// mv_par07 de familia
// mv_par08 ate familia  
// mv_par09 de status
// mv_par10 ate status 

Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]      

Processa( {|| RptDetail()   },"Imprimindo...") 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function RptDetail()
Local _nLinMemo := 0
Local _nLin := 0
Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

SET FILTER TO ZA8->ZA8_PROCED = ' '
ZA8->(DbGoTop())
While ZA8->(!Eof()) 

	If Prow() > 70
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	Endif
	
	If ZA8->ZA8_EMISSAO < mv_par01 .Or. ZA8->ZA8_EMISSAO > mv_par02
		ZA8->(DbSkip())
		Loop	
	EndIf

	If ZA8->ZA8_CLIENT < mv_par03 .Or. ZA8->ZA8_CLIENT > mv_par04
		ZA8->(DbSkip())
		Loop	
	EndIf

	If ZA8->ZA8_LOJA < mv_par05 .Or. ZA8->ZA8_LOJA > mv_par06
		ZA8->(DbSkip())
		Loop	
	EndIf

	@Prow()+1, 001 psay ZA8->ZA8_CLIENT +" - "+ZA8->ZA8_LOJA
	SA1->(DbSetOrder(1)) //filial + cliente + loja
 	If SA1->(DbSeek(xFilial("SA1")+ZA8->ZA8_CLIENT+ZA8->ZA8_LOJA))
		@Prow()  , 015 psay Substr(SA1->A1_NOME,1,20)
	EndIf
	@Prow()  , 040 psay ZA8->ZA8_DOC
	@Prow()  , 050 psay ZA8->ZA8_EMISSAO
	@Prow()  , 060 psay ZA8->ZA8_VALOR Picture("@e 999999.99")

	_nLinMemo := MLCOUNT(ZA8->ZA8_RESULT,40)

	For LinhaCorrente := 1 To Iif(_nLinMemo > 3,_nLinMemo,3)
		If LinhaCorrente == 1
			@Prow()  , 072 psay ZA8->ZA8_MOT1
		ElseIf LinhaCorrente == 2
			@Prow()+1, 072 psay ZA8->ZA8_MOT2
		ElseIf LinhaCorrente == 3
			@Prow()+1, 072 psay ZA8->ZA8_MOT3
		EndIf
		If !Empty((MemoLine(ZA8->ZA8_RESULT,40,LinhaCorrente)))		
			If LinhaCorrente <= 3
				@Prow()  , 125 Psay (MemoLine(ZA8->ZA8_RESULT,40,LinhaCorrente))	
			Else
				@Prow()+1, 125 Psay (MemoLine(ZA8->ZA8_RESULT,40,LinhaCorrente))	
			EndIF
        EndIf
	Next
	@ Prow()+1,000 PSAY __PrtThinLine()			 
	ZA8->(DbSkip())
EndDo

@ Prow()+1,000 PSAY __PrtThinLine()

ZA8->(DbCloseArea())          

Return(nil)
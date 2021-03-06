#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHEST126  �Autor �Jo�o Felipe da Rosa � Data �  14/08/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � RELATORIO DE MATERIAIS OBSOLETOS                           ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / CUSTOS                                           ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA � MOTIVO                                          ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHEST204()   

Agrupo 	  := {}
cString   := ""
cDesc1    := OemToAnsi("Este relat�rio tem o objetivo de  apresentar")
cDesc2    := OemToAnsi("a rela��o de materiais obsoletos no estoque.")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST204" //nome do arquivo
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELAT�RIO DE MATERIAIS OBSOLETOS") //t�tulo     
//           |01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
cabec1    := " Produto            Descri��o                                  Saldo       V.Unit�rio    V.Total      Localiza��o       Ult. Mov."
cabec2    := ""
cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG	  := 1
wnrel     := nomeprog //"NH"
_cPerg    := "EST204" 

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

Processa(  {|| Gerando()   },"Gerando Dados para a Impress�o") 
RptStatus( {|| Imprime()   },"Imprimindo...")

set filter to //remove o filtro da tabela

If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          

MS_FLUSH() //Libera fila de relatorios em spool

Return

//���������������������������������������Ŀ
//�FUNCAO QUE GERA OS DADOS PARA IMPRESSAO�
//�����������������������������������������

Static Function Gerando()
Local cQuery

//�������������Ŀ
//�MONTA A QUERY�
//���������������

cQuery := "SELECT B1.B1_COD, B1.B1_DESC, B2.B2_QATU, B2.B2_CM1, B2.B2_VATU1, B1.B1_LOCAFIS, B1.B1_UPRC, "
cQuery += "(SELECT MAX(D3.D3_EMISSAO) FROM "+RetSqlName("SD3")+" D3 WHERE D3_COD = B1_COD AND D3_LOCAL = B2_LOCAL) AS D3_EMISSAO"
cQuery += " FROM "+RetSqlName('SB1')+" B1, "+RetSqlName('SB2')+" B2"
cQuery += " WHERE B1.B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQuery += " AND B2.B2_LOCAL BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
cQuery += " AND B1.B1_COD = B2.B2_COD"

//BLOQUEADOS ? 
If mv_par05 == 1 //sim
	cQuery += " AND B1.B1_MSBLQL = '1'"
	cQuery += " AND B1.B1_LOCAFIS <> ' '"
ElseIf mv_par05 == 2 //nao
	cQuery += " AND B1.B1_MSBLQL != '1'"
EndIf  

//SALDO ZERADO ?
If mv_par06 == 2
	cQuery += " AND B2.B2_QATU > 0"
EndIf

//FILTRO POR LOCALIZACAO
cQuery += " AND B1.B1_LOCAFIS BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"

//FILTRO POR SALDO
cQuery += " AND B2.B2_QATU BETWEEN '"+STRZERO(mv_par09)+"' AND '"+STRZERO(mv_par10)+"'"

cQuery += " AND B1.D_E_L_E_T_ = ' ' AND B1.B1_FILIAL = '"+xFilial('SB1')+"'"
cQuery += " AND B2.D_E_L_E_T_ = ' ' AND B2.B2_FILIAL = '"+xFilial('SB2')+"'"

//MemoWrit('C:\TEMP\'+nomeprog+'.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "TRA1" 

TRA1->(DbGotop())     

Return

//����������������������������������Ŀ
//�FUNCAO PARA IMPRESSAO DO RELAT�RIO�
//������������������������������������

Static Function Imprime()

Local nTotal := 0

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

SetRegua(TRA1->(RECCOUNT()))

While TRA1->(!Eof())  

	If Prow() > 65 
		_nPag  := _nPag + 1   
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
  	Endif

	IncRegua()
		                  
	cDesc := OemToAnsi(TRA1->B1_DESC)
	cDesc := SUBSTR(cDesc,1,30)        
	cDesc := StrTran(cDesc,chr(9),'')
	
	cLocaFis := OEMTOANSI(ALLTRIM(TRA1->B1_LOCAFIS))
	cLocaFis := StrTran(cLocaFis,chr(9),'')
	
	@Prow()+1, 001 psay ALLTRIM(TRA1->B1_COD)
  	@Prow()  , 020 psay ALLTRIM(cDesc)
	@Prow()  , 056 psay Transform(  TRA1->B2_QATU , "9,999,999.99" )
	@Prow()  , 070 psay Transform(  TRA1->B1_UPRC , "9,999,999.99" )
	@Prow()  , 084 psay Transform(  TRA1->B2_QATU * TRA1->B1_UPRC , "9,999,999.99")
	
	If !empty(ALLTRIM(cLocaFis))
		@Prow()  , 104 psay ALLTRIM(cLocaFis)
	Endif
	
	@Prow()  , 120 psay StoD(TRA1->D3_EMISSAO)

	nTotal += TRA1->B2_QATU * TRA1->B1_UPRC
	TRA1->(DbSkip())

EndDo

@ prow()+1,000 PSAY __PrtThinLine()   
@ prow()+1,001 PSAY "Total:"
@ prow()  ,070 PSAY nTotal picture "9,999,999.99"

TRA1->(DbCloseArea())

Return(nil)
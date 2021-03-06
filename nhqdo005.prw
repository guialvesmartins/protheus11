/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHQDO005  �Autor  �Marcos R. Roquitski � Data �  23/04/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Controle de Documentos, relatorio de desenhos.             ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NhQdo005()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,cFilterUser")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,aMatriz,nPos,nSaldoB2,x,nFaltas,nConsumo")

cString   := "QDH"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Lista de Desenhos")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHQDO005"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "CONTROLE DE DOCUMENTOS - DESENHOS"
Cabec1    := " Nr.Doc           Rev Titulo do Documento                                                                                  Cod.WHB          Cod.Cliente       Rev.Cliente"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHQDO005"
_cPerg    := ""

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho)

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif
             
nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver     := ReadDriver()
cCompac     := aDriver[1]
cNormal     := aDriver[2]
cFilterUser := aReturn[7]

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

DbSelectArea("TMP")
DbCloseArea()


Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Gerando()
	cQuery :="SELECT D1.QDH_DOCTO,D1.QDH_TITULO,D1.QDH_PRODUT,D1.QDH_DTREDE,D1.QDH_RV
	cQuery := cQuery + " FROM " + RetSqlName( 'QDH' ) +" D1 "
	cQuery := cQuery + " WHERE D1.QDH_DOCTO LIKE 'DC%' " 
	cQuery := cQuery + " ORDER BY D1.QDH_DOCTO,D1.QDH_RV ASC" 
	TCQUERY cQuery NEW ALIAS "TMP"  
	TcSetField("TMP","QDH_DTREDE","D")  // Muda a data de string para date
Return


Static Function RptDetail()
Local _Docto, _Rv, _Titulo,	_Produt, _Dtrede

TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While TMP->(!Eof())
	cCodAP5 := Space(15)
	If !Empty(TMP->QDH_PRODUT)
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+TMP->QDH_PRODUT))
		If SB1->(Found())
			cCodAp5 := SB1->B1_CODAP5
		Endif
	Endif
	If Prow() > 60
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif
	
	If !Empty(cFilterUser).and.!(&cFilterUser)
		dbSkip()
		Loop
	Endif

	_Docto  := TMP->QDH_DOCTO
	_Rv     := TMP->QDH_RV
	_Titulo := TMP->QDH_TITULO
	_Produt := TMP->QDH_PRODUT
	_Dtrede := TMP->QDH_DTREDE

	TMP->(DbSkip())
	If TMP->QDH_DOCTO <> _Docto
		@ Prow() + 1, 001 Psay _Docto Picture "@R XXXX.999999"
		@ Prow()    , 018 Psay _Rv
		@ Prow()    , 022 Psay _Titulo
		@ Prow()    , 123 Psay _Produt
		@ Prow()    , 140 Psay cCodAp5
		@ Prow()    , 158 Psay _DtRede
	Endif

Enddo
@ Prow()+02,001 Psay __PrtThinLine()

Return(nil)

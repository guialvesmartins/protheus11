/*
+----------------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                                !
+----------------------------------------------------------------------------------+
!                             DADOS DO PROGRAMA                                    !
+------------------+---------------------------------------------------------------+
!Modulo            ! FIN - Financeiro                                              !
+------------------+---------------------------------------------------------------+
!Nome              ! NHFIN107.PRW                                                  !
+------------------+---------------------------------------------------------------+
!Descricao         ! Relat�rio Analitico de Baixas T�tulos a Pagar                 +
+------------------+---------------------------------------------------------------+
!Autor             ! Edenilson Santos                                              !
+------------------+---------------------------------------------------------------+
!Data de Criacao   ! 14/01/2014                                                    !
+------------------+---------------------------------------------------------------+
!ATUALIZACOES                                                                      !
+-------------------------------------------+---------------+-----------+----------+
!Descricao detalhada da atualizacao         !Nome do        ! Analista  !Data da   !
!                                           !Solicitante    ! Respons.  !Atualiz.  !
+-------------------------------------------+---------------+-----------+----------+
!...                                        !Gustavocr      !Edenilson  !          !
+-------------------------------------------+---------------+-----------+----------+
*/
#include "rwmake.ch"      
#include "protheus.ch"

User Function NHFIN107()
	Local oReport
	
	AjustaSx1("FIN107")

	/*
	+----------------------------------------------------------+
	! Variaveis utilizadas para parametros                     !
	! mv_par01            // da data da baixa                  !
	! mv_par02            // ate a data da baixa               !
	! mv_par03            // do fornecedor                     !
	! mv_par04            // ate o fornecedor                  !
	! mv_par05            // da loja                           !
	! mv_par06            // ate a loja                        !
	! mv_par07            // considera filiais abaixo          !
	! mv_par08            // da filial                         !
	! mv_par09            // ate a filial                      !
	+----------------------------------------------------------+
	*/

	If !Pergunte('FIN107',.T.)
	   Return(nil)
	Endif   

	//Processa( {||  AbreBaixas() },"Aguarde, processando informa��es...")

	oReport := ReportDef()
	
	oReport:PrintDialog()	

// If FindFunction("TRepInUse") .And. TRepInUse()
//	/*
//	+------------------------+
//	! Interface de impressao !
//	+------------------------+
//	*/
//	Processa( {||  AbreBaixas() },"Aguarde, processando informa��es...")
//	oReport := ReportDef()
//	oReport:PrintDialog()	
//
// Else
//    /* Executa vers�o anterior do fonte */ 
// Endif
Return( Nil )

Static Function ReportDef()
Local oReport
Local oSection1
Local oSection2
										
oReport := TReport():New(;          																					// M�todo construtor da classe TReport.
"NHFIN107",;                     																					   // Nome do Relat�rio 
"Relat�rio Anal�tico de Baixas",;   																					// Titulo do Formul�rio de Par�metros de Impress�o
"FIN107",;                          																					// Par�metros de impress�o das pertungas em SX1
{|oReport| PrintReport(oReport)},;  
"Este relat�rio ira imprimir a relacao anal�tica das baixas conforme os par�metros solicitados.")	// Hint exibido no formul�rio de par�metros de impress�o

/* Metodos do TReport */
oReport:SetLandscape()      //Imprime Modo Paisagem 
oReport:SetTotalInLine(.F.) //Verdadeiro se totalizadores ser�o impressos em linha (Valor padr�o: Verdadeiro)

oSection1 := TRSection():New(oReport,OemToAnsi("Relat�rio Anal�tico de Baixas"),{"SE2TMP","SE5TMP"})
oSection1 :SetTotalInLine(.F.) //Verdadeiro se totalizadores ser�o impressos em linha (Valor padr�o: Verdadeiro)

TRCell():New(oSection1,"E2_FILIAL"  ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"FI"         ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/03,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
TRCell():New(oSection1,"E2_FORNECE" ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"Fornec"     ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/07,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
TRCell():New(oSection1,"A2_NOME"    ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/             ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/25,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
TRCell():New(oSection1,"E2_PREFIXO" ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"Prf"        ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/08,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
TRCell():New(oSection1,"E2_NUM"     ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"N�mmero"    ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/10,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
TRCell():New(oSection1,"E2_PARCELA" ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"Prc"        ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/03,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
TRCell():New(oSection1,"E2_TIPO"    ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"TP"         ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/04,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
TRCell():New(oSection1,"E2_EMISSAO" ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/             ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/12,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
TRCell():New(oSection1,"E2_VENCTO"  ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/             ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/12,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
TRCell():New(oSection1,"E2_VENCREA" ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/             ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/12,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
TRCell():New(oSection1,"E2_VALOR"   ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"Vlr.Titulo" ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/17,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)

TRCell():New(oSection1,"E5_DATA"    ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"Dt.Baixa"   ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/15,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
TRCell():New(oSection1,"E5_VALOR"   ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"Vl.Baixa"   ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/15,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
TRCell():New(oSection1,"E5_NATUREZA","SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"Natureza"   ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/10,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
TRCell():New(oSection1,"E5_BANCO"   ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"Bco"        ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/04,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
TRCell():New(oSection1,"E5_HISTOR"  ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/             ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/30,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
TRCell():New(oSection1,"E5_MOTBX"   ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"Mot"        ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/04,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
TRCell():New(oSection1,"E5_SITUACA" ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"ST"         ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/03,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)

TRCell():New(oSection1,"E2_SALDO"  ,"SE2TMP",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/              ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/17,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)

//TRCell():New(oSection1,"VALTOTAL"    ,"      ",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/              ,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| vSaldoAtual })

oBreak := TRBreak():New(oSection1,oSection1:Cell("E2_NUM"),"Baixas",.F.)	
oBreak := TRBreak():New(oSection1,oSection1:Cell("E2_PARCELA"),"Baixas",.F.)	

TRFunction():New(oSection1:Cell("E2_SALDO"),NIL,"SUM",oBreak)
//TRFunction():New(oSection1:Cell("VALTOTAL"),NIL,"SUM",oBreak)
TRFunction():New(oSection1:Cell("E2_NUM"),NIL,"COUNT",oBreak)

//oSection2 := TRSectio0n():New(oSection1,"Baixas","SE5")

//TRCell():New(oSection1,"E5_FILIAL"  ,"SE5",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"FI"          ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/03,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
//TRCell():New(oSection1,"E5_PREFIXO" ,"SE5",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"Prf"         ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/04,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
//TRCell():New(oSection1,"E5_NUMERO"  ,"SE5",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"N�mmero"     ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/10,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
//TRCell():New(oSection1,"E5_PARCELA" ,"SE5",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"Prc"         ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/03,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
//TRCell():New(oSection1,"E5_TIPO"    ,"SE5")/*Trocar Cabe�alho sen�o pega do SX3 por Default*/"TP"          ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/04,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
//TRCell():New(oSection1,"E5_DATA"    ,"SE5",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/              ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/12,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
//TRCell():New(oSection1,"E5_VALOR"   ,"SE5",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/              ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/12,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
//TRCell():New(oSection1,"E5_NATUREZA","SE5",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/              ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/12,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
//TRCell():New(oSection1,"E5_BANCO"   ,"SE5",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/              ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/15,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
//TRCell():New(oSection1,"E5_RECPAG"  ,"SE5",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/              ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/15,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
//TRCell():New(oSection1,"E5_BENEF"   ,"SE5",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/              ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/12,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
//TRCell():New(oSection1,"E5_HISTOR"  ,"SE5",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/              ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/12,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
//TRCell():New(oSection1,"E5_MOTBX"   ,"SE5",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/              ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/15,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
//TRCell():New(oSection1,"E5_SITUACA" ,"SE5",/*Trocar Cabe�alho sen�o pega do SX3 por Default*/              ,/*PesqPict('TMP',"EA_MODELO")*/,/*Largura Coluna*/15,/*lPixel*/, /*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)

//oSection2:SetLinesBefore(0)

//TRFunction():New(oSection2:Cell("E5_VALOR"),NIL,"SUM",,,,,,.F.)
//oSection2:SetTotalInLine(.F.)
//oSection2:SetTotalText(" ")

Return oReport

Static Function PrintReport(oReport)
Local oSection1:= oReport:Section(1)
//Local oSection2:= oReport:Section(1):Section(1)

Processa( {|| fnAbreTitulos() },"Aguarde, processando informa��es...")
/*
If nRegSE2 == 0
	Aviso("Rela��o de Baixas","A Query foi executada com sucesso. "+cValToChar(nRegSE2) , {"OK"},2)
	Return
Endif
*/

DbSelectArea("SE2TMP")
SE2TMP->(DbGoTop())

oReport:SetMeter(RecCount())

While !SE2TMP->(EOF())

	If oReport:Cancel()
		Exit
	EndIf
	
	/*
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+SBG->BG_PRODUTO)
   */
	oSection1:Init()

	oSection1:Cell("E2_FILIAL")  :Show() //SetValue(SE2->E2_FILIAL)
	oSection1:Cell("E2_FORNECE") :Show() //SetValue(SE2->E2_FORNECE)
	oSection1:Cell("A2_NOME")    :Show() //SetValue(SE2->A2_NOME)
	oSection1:Cell("E2_PREFIXO") :Show() //SetValue(SE2->E2_PREFIXO)
	oSection1:Cell("E2_NUM")     :Show() //SetValue(SE2->E2_NUM)
	oSection1:Cell("E2_PARCELA") :Show() //SetValue(SE2->E2_PARCELA)
	oSection1:Cell("E2_TIPO")    :Show() //SetValue(SE2->E2_TIPO)
	oSection1:Cell("E2_EMISSAO") :SetValue(Stod(SE2TMP->E2_EMISSAO))	
	oSection1:Cell("E2_VENCTO")  :SetValue(Stod(SE2TMP->E2_VENCTO))
	oSection1:Cell("E2_VENCREA") :SetValue(Stod(SE2TMP->E2_VENCREA))
	oSection1:Cell("E2_VALOR")   :Show() //SetValue(SE2->E2_VALOR)

	oSection1:Cell("E5_DATA")    :SetValue(Stod(SE2TMP->E5_DATA))	
	oSection1:Cell("E5_VALOR")   :Show() //SetValue(SE2->E2_VALOR)	

   oSection1:Cell("E5_NATUREZA"):Show()
	oSection1:Cell("E5_BANCO")   :Show()
	oSection1:Cell("E5_HISTOR")  :Show()
	oSection1:Cell("E5_MOTBX")   :Show()
	oSection1:Cell("E5_SITUACA") :Show()

	oSection1:Cell("E2_SALDO")   :SetValue(SE2TMP->E2_VALOR)	//Show() 
	//oSection1:Cell("VALTOTAL")   :Show() //GetFieldInfo("SE2TMP->E5_VALOR")	
	/*
	oSection:Cell("B1_DESC"):Show()
	oSection:Cell("BG_GERAPV"):Show()
	oSection:Cell("BG_GERAOP"):Show()
	oSection:Cell("BG_GERAOPI"):Show()
	oSection:Cell("BG_GERAEMP"):Show()

	dbSelectArea("SBH")
	dbSetOrder(1)
	dbSeek(xFilial("SBH")+SBG->BG_PRODUTO,.T.)
	
	While ( !Eof() .And. SBH->BH_FILIAL == xFilial("SBH") .And.;
		SBH->BH_PRODUTO == SBG->BG_PRODUTO )
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SBH->BH_CODCOMP)

		oSection:PrintLine()

		oSection:Cell("BG_PRODUTO"):Hide()
		oSection:Cell("B1_DESC"):Hide()
		oSection:Cell("BG_GERAPV"):Hide()
		oSection:Cell("BG_GERAOP"):Hide()
		oSection:Cell("BG_GERAOPI"):Hide()
		oSection:Cell("BG_GERAEMP"):Hide()
		
		dbSelectArea("SBH")
		dbSkip()
	End
	*/                                                    
	
//	DbSelectArea("SBG")
	oSection1:PrintLine()
	DbSkip()
	
	
//	oReport:SkipLine()
End
oSection1:Finish()
oReport:IncMeter()	
Return

Static Function fnAbreTitulos()
Local cSql1
Static nRegSE2

//--Fecha Alias Temporario se estiver aberto
If Select("SE2TMP") > 0
	dbSelectArea("SE2TMP")
	dbCloseArea()
Endif

cSql1:= ''

If !Empty(mv_par01) .And. !Empty(mv_par02)
	cSql1 += "SE5.E5_DATA BETWEEN " + Dtos(mv_par01) + " AND " + Dtos(mv_par02) + " AND "
Endif

If !Empty(mv_par03) .And. !Empty(mv_par04)
	cSql1+= "SE5.E5_CLIFOR BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "
Endif

If !Empty(mv_par05) .And. !Empty(mv_par06)
	cSql1 += "SE5.E5_LOJA BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' AND "
Endif

cSql1 := "%"+cSql1+"%"  	

BeginSql Alias "SE2TMP"
	SELECT
	SA2.A2_NOME,
	SE2.E2_FILIAL,
	SE2.E2_PREFIXO,
	SE2.E2_NUM,
	SE2.E2_PARCELA,
	SE2.E2_TIPO,
	SE2.E2_VALOR,
	SE2.E2_FORNECE,
	SE2.E2_EMISSAO,
	SE2.E2_VENCTO,
	SE2.E2_VENCREA,
	SE2.E2_BAIXA,
	SE2.E2_SDDECRE,
	SE2.E2_SDACRES,
	SE2.E2_SALDO,
	SE5.E5_FILIAL,	
	SE5.E5_PREFIXO,
	SE5.E5_NUMERO,
	SE5.E5_PARCELA,
	SE5.E5_TIPO ,
	SE5.E5_DATA,
	SE5.E5_VALOR,
	SE5.E5_NATUREZ,
	SE5.E5_BANCO,
	SE5.E5_RECPAG,
	SE5.E5_BENEF,
	SE5.E5_HISTOR,
	SE5.E5_MOTBX,
	SE5.E5_SITUACA
	FROM
	%table:SA2% SA2 (NOLOCK), %table:SE5% SE5 (NOLOCK)
	INNER JOIN
	%table:SE2% SE2 (NOLOCK)
	ON
	SE2.E2_FILIAL  = %xFilial:SE5% AND
	SE2.E2_PREFIXO = SE5.E5_PREFIXO AND 
	SE2.E2_NUM     = SE5.E5_NUMERO AND 
	SE2.E2_PARCELA = SE5.E5_PARCELA AND 
	SE2.E2_FORNECE = SE5.E5_CLIFOR AND
	SE2.E2_LOJA    = SE5.E5_LOJA 
	WHERE
	SE2.E2_FORNECE = SA2.A2_COD AND 
	SE2.E2_LOJA = SA2.A2_LOJA	AND
	%exp:cSql1%
	SE5.E5_MOTBX  <> ' ' AND
	SE2.%NotDel% AND
	SE5.%NotDel% AND
	SA2.%NotDel%
	order by
	SE5.R_E_C_N_O_
EndSql

//	%exp:cSql2%
//SE5.E5_DATA BETWEEN %Exp:Dtos(mv_par01)% AND %Exp:Dtos(mv_par02)% AND    			
//SE5.E5_CLIFOR BETWEEN %Exp:mv_par03% AND %Exp:mv_par04% AND    
//SE5.E5_LOJA BETWEEN %Exp:mv_par05% AND %Exp:mv_par06% AND    

Count To nRegSE2
//ProcRegua( nRecCount )
//Aviso("Rela��o de Baixas","A Query foi executada com sucesso. "+cValToChar(nRecCount) , {"OK"},2)

Return
Static Function AbreBaixas()

//--Fecha Alias Temporario se estiver aberto
If Select("SE5TMP") > 0
	dbSelectArea("SE5TMP")
	dbCloseArea()
Endif

BeginSql Alias "SE5TMP"
	SELECT
	SA2.A2_NOME,
	SE2.E2_FILIAL,
	SE2.E2_PREFIXO,
	SE2.E2_NUM,
	SE2.E2_PARCELA,
	SE2.E2_TIPO,
	SE2.E2_VALOR,
	SE2.E2_FORNECE,
	SE2.E2_EMISSAO,
	SE2.E2_VENCTO,
	SE2.E2_VENCREA,
	SE2.E2_BAIXA,
	SE2.E2_SDDECRE,
	SE2.E2_SDACRES,
	SE2.E2_SALDO,
	SE5.E5_FILIAL,	
	SE5.E5_PREFIXO,
	SE5.E5_NUMERO,
	SE5.E5_PARCELA,
	SE5.E5_TIPO ,
	SE5.E5_DATA BAIXA,
	SE5.E5_VALOR,
	SE5.E5_NATUREZ,
	SE5.E5_BANCO,
	SE5.E5_RECPAG,
	SE5.E5_BENEF,
	SE5.E5_HISTOR,
	SE5.E5_MOTBX,
	SE5.E5_SITUACA
	FROM
	%table:SA2% SA2, %table:SE5% SE5
	INNER JOIN
	%table:SE2% SE2
	ON
	SE2.E2_FILIAL  = %xFilial:SE5% AND
	SE2.E2_PREFIXO = SE5.E5_PREFIXO AND 
	SE2.E2_NUM     = SE5.E5_NUMERO AND 
	SE2.E2_PARCELA = SE5.E5_PARCELA AND 
	SE2.E2_FORNECE = SE5.E5_CLIFOR AND
	SE2.E2_LOJA    = SE5.E5_LOJA 
	WHERE
	SE2.E2_FORNECE = SA2.A2_COD AND 
	SE2.E2_LOJA = SA2.A2_LOJA	AND
	SE5.E5_DATA BETWEEN %Exp:Dtos(mv_par01)% AND %Exp:Dtos(mv_par02)% AND    			
	SE5.E5_MOTBX  <> ' ' AND
	SE2.%NotDel% AND
	SE5.%NotDel% AND
	SA2.%NotDel%
	order by
	SE5.R_E_C_N_O_
EndSql
/*
Count To nRecCount
ProcRegua( nRecCount )
Aviso("Rela��o de Baixas","A Query foi executada com sucesso. "+cValToChar(nRecCount) , {"OK"},2)
*/
Return

Static Function AjustaSX1(cPerg)

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

cPerg   :=PadR(cPerg,10) 

aRegs   := {}

//              G   O          P                     P                     P                      V   T   T D P  G   V         V   D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  F  G
//              R   R          E                     E                     E                      A   I   A E R  S   A         A   E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  3  R
//              U   D          R                     R                     R                      R   P   M C E  C   L         R   F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  |  P
//              P   E          G                     S                     E                      I   O   A I S  |   I         0   0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  |  S
//              O   M          U                     P                     N                      A   |   N M E  |   D         1   1  P  N  1  2  2  P  N  2  3  3  P  N  3  4  4  P  N  4  5  5  P  N  5  |  X
//              |   |          N                     A                     G                      V   |   H A L  |   |         |   |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  G
//              |   |          T                     |                     |                      E   |   O L |  |   |         |   |  1  1  |  |  |  2  2  |  |  |  3  3  |  |  |  4  4  |  |  |  5  5  |  |  |
//              |   |          |                     |                     |                      |   |   | | |  |   |         |   |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
aadd(aRegs,{cPerg,"01","Da data de baixa ?  ","Da data de baixa ?  ","Da data de baixa ?"  ,"mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Ate data de baixa ? ","Ate data de baixa?  ","Ate data de baixa?"  ,"mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

aadd(aRegs,{cPerg,"03","Do Fornecedor ?     ","Do Fornecedor ?     ","Do Fornecedor ?   "  ,"mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
aadd(aRegs,{cPerg,"04","A� o Fornecedor ?   ","At� o Fornecedor ?  ","At� o Fornecedor ?"  ,"mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})

aadd(aRegs,{cPerg,"05","Da Loja ?           ","Da Loja ?           ","Da Loja ?         "  ,"mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","Ate Loja ?          ","Ate Loja ?          ","Ate Loja ?        "  ,"mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})

aadd(aRegs,{cPerg,"07","Cons.Filiais Abaixo?","Cons.Filiais Abaixo?","Cons.Filiais Abaixo?","mv_ch7","C",01,0,0,"C","","mv_par07","Sim","Nao","Ambos","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"08","Da Filial ?         ","Da Filial ?         ","Da Filial ?        ?","mv_ch8","C",02,0,0,"G","","mv_par08","","","","01","","","","","",""})
aadd(aRegs,{cPerg,"09","Ate a Filial ?      ","At� a Filial ?      ","At� a Filial       ?","mv_ch9","C",02,0,0,"G","","mv_par09","","","","ZZ","","","","","",""})

cUltPerg := aRegs[Len(aRegs)][2]

dbSelectArea("SX1")
dbSetOrder(1)
If !SX1->(DbSeek(cPerg + cUltPerg))

   SX1->(DbSeek(cPerg))
   While SX1->X1_Grupo == cPerg
      RecLock('SX1')
			SX1->(DbDelete())
			SX1->(DbSkip())
      MsUnLock('SX1')
   End

   For i := 1 To Len(aRegs)
       RecLock("SX1", .T.)

	 For j := 1 to Len(aRegs[i])
	     FieldPut(j, aRegs[i, j])
	 Next
       MsUnlock()

       DbCommit()
   Next
EndIf

dbSelectArea(_sAlias)

Return
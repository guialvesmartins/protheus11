#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Rhgp04()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 27/10/01 ==> 	#DEFINE PSAY SAY
#ENDIF

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
굇쿛rograma  � RHGP04          � M.GracaNCarvalho      � Data � 01.10.99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑굇
굇쿏escri뇙o � Relacao de Estabilidade de Acidente de Trabalho           낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇쿞intaxe   � Chamada padr꼘 para programas em RDMake.                  낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽*/

cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""

cabec1:="";cabec2:="";cabec3:="";wnrel:=""

nOrdem:=0
tamanho:="P"
limite :=132
aReturn := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey:= 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Relatorio de Funcionarios em Estabilidade por Acidente de Trabalho"
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
m_pag    := 1
nomeprog := "RHGP04"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas selecionadas                           �
//�                                                              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Envia controle para a funcao SETPRINT                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
wnrel := "RHGP04"
wnRel := SetPrint("SRA",NomeProg,,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

If LastKey() == 27 .or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return
Endif

cabec1 := "MATRICULA NOME                               ADMISSAO  DT_SAIDA  RETORNO   FIM ESTABL"
cabec2 := "_________ _________________________________  ________  ________  _________ __________"
cabec3 := "." 

#IFDEF WINDOWS
    RptStatus({|| RHG004()})  //-- Chamada do Relatorio.// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>     RptStatus({|| Execute(RHG004)})  //-- Chamada do Relatorio.
	Return Nil
#ENDIF

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function RHG004
Static Function RHG004()

DbSelectArea("SRA")
DbSetOrder(01)

DbSelectArea("SR8")
DbSetOrder(01)
Copy to TEMP1.DBF for SR8->R8_TIPO=="O"

Use TEMP1.DBF alias TMP new
Index on R8_TIPO+DTOS(R8_DATAFIM) to TEMP1

DbSelectArea("TMP")
DbCloseArea()

Use TEMP1.DBF index TEMP1 alias TMP new

m_pag    := 1

DbSelectArea("TMP")
TMP->(DbgoTop())
TMP->(SetRegua(RecCount()))
Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
TMP->(dbGoTop())
While TMP->(!Eof())
   IncRegua()
   If pRow() > 66
      Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
   Endif
   If TMP->R8_DATAFIM<=dDataBase+366
      SRA->(DbSeek(TMP->R8_FILIAL+TMP->R8_MAT,.T.))
      If SRA->RA_FILIAL==TMP->R8_FILIAL .AND. SRA->RA_MAT==TMP->R8_MAT
         @ pRow()+2,01 pSay SRA->RA_MAT
         @ pRow()  ,10 pSay SRA->RA_NOME
         @ pRow()  ,45 pSay SRA->RA_ADMISSA
         @ pRow()  ,55 pSay TMP->R8_DATAINI
         @ pRow()  ,65 pSay TMP->R8_DATAFIM 
         If ! Empty(TMP->R8_DATAFIM)
            @ pRow()  ,75 pSay TMP->R8_DATAFIM+366
         EndIf   
      Endif
   EndIf  
   TMP->(DbSkip())
Enddo


RestScreen(3,0,24,79,cSavScr1)
DbSelectArea("TMP")
DbCloseArea()

Delete File TMP.DBF
Delete File TMP.NTX
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return

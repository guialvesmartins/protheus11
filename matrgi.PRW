#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 22/01/01

User Function matrgi()        // incluido pelo assistente de conversao do AP5 IDE em 22/01/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("AREGISTROS,ACAMPOS,CARQTEMP,CMES,CANO,AGI")
SetPrvt("ACONTEUDO,AAREA,CARQGI,_NI,DDTINI,DDTFIM")
SetPrvt("LRET,I,J,AESTADO,ACODIGO,_CARQUIVO")
SetPrvt("_NOUTFILE,_NTIPO2,_NL,_NC,CCONTEUDO,NCPO_COD")
SetPrvt("_CREG,CLINHA,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿘ATRGI    � Autor � Eliana C. da Silva    � Data � 12.01.01 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿐miss꼘 da GI  para o Estado do Parana.                     낢�
굇�          �                                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   쿘ATRGI (void)                                               낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aRegistros:= {}
aCampos	:= {}
cArqTemp	:= ""
cMes		:= ""
cAno		:= ""
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas na leitura do arquivo ini               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aGI    := {}
aConteudo:= {}
aArea   := GetArea()
cArqGI := ""
_nI     := 0 
dDtIni	:= ""
dDtFim	:= ""
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis que armazenam os campos do resumo da apuracao      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
acampos	:= {}
lRet    := .t.              
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Cria as perguntas se nao existirem                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//aadd(aRegistros,{"MTRGI ","01","Ano de apuracao   ?","mv_ch1","C",04,0,0,"G","","mv_par01","","2000","","","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRGI ","02","Tipo Documento    ?","mv_ch2","N",01,0,0,"C","","mv_par02","31-GI Normal","","","32-GI Retificacao","","","33-GI BAIXA","","","","","","","",""})
//aadd(aRegistros,{"MTRGI ","03","CRC Contador      ?","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRGI ","04","Caminho do Arquivo?","mv_ch4","C",30,0,0,"G","","mv_par04","","C:\SIGAADV\GI\","","","","","","","","","","","","","",""})
//AP508          01       02   03                    04                    05                    06       07  070910 11  12 13         14 15     16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39
aadd(aRegistros,{"MTRGI ","01","Ano de apuracao   ?","Ano de apuracao   ?","Ano de apuracao   ?","mv_ch1","C",04,0,0,"G","","mv_par01","","2000","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRGI ","02","Tipo Documento    ?","Tipo Documento    ?","Tipo Documento    ?","mv_ch2","N",01,0,0,"C","","mv_par02","31-GI Normal","","","","","32-GI Retificacao","","","","","33-GI BAIXA","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRGI ","03","CRC Contador      ?","CRC Contador      ?","CRC Contador      ?","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRGI ","04","Caminho do Arquivo?","Caminho do Arquivo?","Caminho do Arquivo?","mv_ch4","C",30,0,0,"G","","mv_par04","","C:\SIGAADV\GI\","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

dbSelectArea("SX1")
For i:=1 to Len(aRegistros)
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next
		MsUnlock()
    EndIf
Next

@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Rotina de Processamento GI-PR"
@ 8,10 TO 84,222
@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("MTRGI ")
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 22/01/01 ==> @ 91,168 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 23,14 SAY "Este programa Gera Arquivo Texto para GI-PR"
ACTIVATE DIALOG oDlg5
Return nil


// Substituido pelo assistente de conversao do AP5 IDE em 22/01/01 ==> Function OkProc
Static Function OkProc()
Close(oDlg5)
Processa( {|| ProcGI() } )// Substituido pelo assistente de conversao do AP5 IDE em 22/01/01 ==> Processa( {|| Execute(ProcGI) } )
Return

// Substituido pelo assistente de conversao do AP5 IDE em 22/01/01 ==> Function ProcGI
Static Function ProcGI()
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Tabela Codigo dos Estados         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
aEstado:={"AC","AL","AP","AM","BA","CE","DF","ES","GO","MA","MT","MG",;
    "PA","PB","PE","PI","RN","RS","RJ","RO","RR","SC","SP","SE","MS","TO"}
aCodigo:={}
aadd(aCodigo,{"301","501"})
aadd(aCodigo,{"302","502"})
aadd(aCodigo,{"303","503"})
aadd(aCodigo,{"304","504"})
aadd(aCodigo,{"305","505"})
aadd(aCodigo,{"306","506"})
aadd(aCodigo,{"307","507"})
aadd(aCodigo,{"308","508"})
aadd(aCodigo,{"310","510"})
aadd(aCodigo,{"312","512"})
aadd(aCodigo,{"313","513"})
aadd(aCodigo,{"314","514"})
aadd(aCodigo,{"315","515"})
aadd(aCodigo,{"316","516"})
aadd(aCodigo,{"318","518"})
aadd(aCodigo,{"319","519"})
aadd(aCodigo,{"320","520"})
aadd(aCodigo,{"321","521"})
aadd(aCodigo,{"322","522"})
aadd(aCodigo,{"323","523"})
aadd(aCodigo,{"324","524"})
aadd(aCodigo,{"325","525"})
aadd(aCodigo,{"326","526"})
aadd(aCodigo,{"327","527"})
aadd(aCodigo,{"328","528"})
aadd(aCodigo,{"329","529"})

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Leitura Arquivo GI.INI            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
cArqGI := "GI.ini"
ReadGI()
if !lRet
   RETURN
EndIf    
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Inicio do Processamento           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Cria arquivo para armazenar apuracoes   �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
AADD(aCampos,{"CPO_ANO"         ,"C"    ,04     ,0      })
AADD(aCampos,{"CPO_COD"         ,"C"    ,04     ,0      })
AADD(aCampos,{"CPO_VALOR"       ,"N"    ,15     ,0      })

cArqTemp:=CriaTrab(aCampos)
dbUseArea(.T.,,cArqTemp,cArqTemp,.T.,.F.)
IndRegua(cArqTemp,cArqTemp,"CPO_ANO+CPO_COD",,,"Indexando Dados")

_cArquivo:=ALLTRIM(MV_PAR04)+"GI"+SM0->M0_CODIGO+SM0->M0_CODFIL+".TXT"

_nOutFile:= Fcreate(_cArquivo,0) 

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿎alculando as movimentacoes do SF3                                      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cMes		:=	""
cAno		:=	""   
dDtini  :=      CTOD("01/01/"+MV_PAR01)
dDtFim  :=      CTOD("31/12/"+MV_PAR01)

dbSelectArea("SF3")
dbSetOrder(1)
dbSeek(xFilial("SF3")+Dtos(dDtini),.T.)
//MSGiNFO(xFilial("SF3")+Dtos(dDtini))
ProcRegua(LastRec())
_nTipo2:= 0
While ( !Eof() .And. xFilial("SF3") == F3_FILIAL .And.;
                            dDtIni  <= F3_ENTRADA.And.;
                            dDtFim  >= F3_ENTRADA )
   incproc()                                              
   // Pula NF do PR e Nota Cancelada
   IF SF3->F3_ESTADO == "PR" .Or. !Empty(SF3->F3_DTCANC)  
      SF3->(DbSkip())
      loop
   EndIf
   _nL:=ASCAN(aEstado,SF3->F3_ESTADO,1,26)
   IF (alltrim(SF3->F3_CFO) >="200" .AND. alltrim(SF3->F3_CFO) <= "299")
      _nC:=1
   ElseIf  (alltrim(SF3->F3_CFO) >="600" .AND. alltrim(SF3->F3_CFO) <= "699")
      _nC:=2
   Else
      SF3->(DbSkip())
      loop
   EndIf
   For _nI := 1 to len(aGI)
      cConteudo:=     aGI[_nI,5]
      If aGI[_nI,2]=="N" .and. substr(aGI[_nI,1],1,3) =="CPO" ;
          .AND. &cConteudo !=0
          dbSelectArea(cArqTemp)
          If !dbSeek(mv_par01+substr(aCodigo[_nL,_nC],1,3)+substr(aGI[_nI,1],6,1))
             RECLOCK(cArqTemp,.T.)
             Replace CPO_ANO With mv_par01
             Replace CPO_COD with (substr(aCodigo[_nL,_nC],1,3)+substr(aGI[_nI,1],6,1))
             Replace CPO_VALOR With  0
             _nTipo2:= _nTipo2 + 1
          Else
             RECLOCK(cArqTemp,.F.)
          EndIf                                        
          cConteudo:=     aGI[_nI,5]                             
          Replace CPO_VALOR With  CPO_VALOR + &cConteudo
          MsUnlock()
          NCPO_COD:="    "
          IF substr(aGI[_nI,1],6,1) == "1" .and. substr(aGI[_nI,1],5,1) == "3" 
             nCPO_COD:="3991"
          EndIf
          IF substr(aGI[_nI,1],6,1) == "2" .and. substr(aGI[_nI,1],5,1) == "3" 
             nCPO_COD:="3992"
          EndIf
          IF substr(aGI[_nI,1],6,1) == "3" .and. substr(aGI[_nI,1],5,1) == "3" 
             nCPO_COD:="3993"
          EndIf
          IF substr(aGI[_nI,1],6,1) == "4" .and. substr(aGI[_nI,1],5,1) == "3" 
             nCPO_COD:="3994"
          EndIf
          IF substr(aGI[_nI,1],6,1) == "5" .and. substr(aGI[_nI,1],5,1) == "3" 
             nCPO_COD:="3995"
          EndIf
          IF substr(aGI[_nI,1],6,1) == "1" .and. substr(aGI[_nI,1],5,1) == "5" 
             nCPO_COD:="5991"
          EndIf
          IF substr(aGI[_nI,1],6,1) == "2" .and. substr(aGI[_nI,1],5,1) == "5" 
             nCPO_COD:="5992"
          EndIf
          IF substr(aGI[_nI,1],6,1) == "3" .and. substr(aGI[_nI,1],5,1) == "5" 
             nCPO_COD:="5993"
          EndIf
          IF substr(aGI[_nI,1],6,1) == "4" .and. substr(aGI[_nI,1],5,1) == "5" 
             nCPO_COD:="5994"
          EndIf
          IF substr(aGI[_nI,1],6,1) == "5" .and. substr(aGI[_nI,1],5,1) == "5" 
             nCPO_COD:="5995"
          EndIf
          if !dbSeek(mv_par01+nCPO_COD)
             RECLOCK(cArqTemp,.T.)
             Replace CPO_ANO With mv_par01
             Replace CPO_COD With nCPO_COD
             Replace CPO_VALOR With  0
             _ntipo2 := _ntipo2 + 1
          Else
             RECLOCK(cArqTemp,.F.)
          EndIf
          Replace CPO_VALOR With  CPO_VALOR + &cConteudo
          MsUnlock()
       EndIf
   Next
   dbSelectArea("SF3")
   dbSkip()
EndDo

DbSelectArea(cArqTemp)
dbGoTop()
ProcRegua(LastRec())

//Gera arquivo magnetico para o Fisco (GI.TXT)
_cReg:= "1"+IIF(MV_PAR02==1,"31",IIF(MV_PAR02==2,"32","33"))+;
        Substr(SM0->M0_INSC,1,10)+Substr(SM0->M0_CGC,1,14)+;
        Substr(MV_PAR01,1,4)+"00"+"C"+MV_PAR03+;
        SPACE(60)+STR(_NTIPO2,3,0)
Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1)
while !Eof()
   _cReg:= "2"+substr(CPO_COD,1,4)+Right("000000000000000"+LTrim(Str((CPO_VALOR),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   dbSkip()
   IncProc()
EndDo
   
Fclose(_nOutFile)


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Apaga arquivos temporarios                                   �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If File(cArqTemp+".DBF")
   dbSelectArea(cArqTemp)
   dbCloseArea()
   Ferase(cArqTemp+".DBF")
   Ferase(cArqTemp+OrdBagExt())
EndIf

MSGINFO("Termino de Processamento")
Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑uncao    쿝eadGI    � Autor 쿐liana C. da Silva     � Data �05.10.2000낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿑uncao de Leitura dos arquivos de GI                        낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿝etorno   쿌rray com o Lay-Out da GI                                   낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros쿐xpC1: Arquivo                                              낢�
굇�          �                                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 22/01/01 ==> Function ReadGI
Static Function ReadGI()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿐strutura do Arquivo a Ser Lido                                         �
//�                                                                        �
//쿦XX_XXXX   X YYY Z CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC �
//�|          | |   | |                                                    �
//�|          | |   | �> Conteudo                                          �
//�|          | |   �--> Numero de Decimais                                �
//�|          | �------> Tamanho da Coluna                                 �
//�|          �--------> Formato de Gravacao ( Numerico Caracter Data)     �
//냅-------------------> Nome do campo                                     �
//�                                                                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿐fetua a Abertura do Arquivo cArqGIA.Ini                               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
If ( File(cArqGI) )
        FT_FUse(cArqGI)
	FT_FGotop()
	
	While ( !FT_FEof() )
		cLinha := FT_FREADLN()
		
		Do Case
                   Case SubStr(cLinha,1,4)=="CPO_"
                      aadd(aGI, {    SubStr(cLinha,01,08),;     //1.Campo
                                     SubStr(cLinha,12,01),;     //2.Tipo
                                     Val(SubStr(cLinha,14,03)),;//3.Tamanho
                                     Val(SubStr(cLinha,18,01)),;//4.Decimal
                                     SubStr(cLinha,20)       })                              //5.Conteudo
                
		EndCase
		
		FT_FSkip()
	EndDo
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
        //쿑echa o Arquivo cArqGI.INI                                             �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	FT_FUse()    
Else
   lRet    := .F.
EndIf

RestArea(aArea)

Return


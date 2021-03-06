/* 
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHTER007  �Autor  �Fabio Nico          � Data �  29/06/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Impressao de etiqueta codigo Barras (Maq.Operador e produto)���
���          �Impressora TERMICA ZEBRA                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Para Produ��o                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#Include "rwmake.ch"       
#INCLUDE "TOPCONN.CH"

User Function Nhter007()
SetPrvt("_cCod,_cDesc,_nQuant,_aOp�oes,_cOpe,_nPos,cNovaLinha,cInicializa,cFinaliza,")
SetPrvt("cConfEtB1,cConfEtB2,cConfEtN1,cConfEtN2,_cCodigo,_cMaq,_cOperaca")
SetPrvt("_cCodBar,_cLabEtq,_cSerial,_cSerFim,cPorta,_Serial1,_Serial2")            

_cLabEtq    := Space(15)
_cCod       := Space(15)
_cDesc      := Space(30)
_cOpe       := Space(06)
_cMaq       := Space(03)
_cOperaca   := Space(03)
_cCodBar    := Space(06)                    
_cSerFim    := Space(09)
_cSerial    := Space(09)
_nQuant     := 0
//_aOpcoes    := {OemToAnsi("Maquina/Opera��o"),"Operador ","Produto "}
_aOpcoes    := {"Operador ","Produto "}
_nPos       := 1        
cPorta      := "LPT1"


//Verifica porta de impressao
If !IsPrinter(cPorta)
	alert("erro na porta")
    Return
Endif

@ 100,050 To 300,370 Dialog oDlgItem Title OemToAnsi("Imprime C�digo de Barra")
@ 005,008 To 075,150                                     
@ 020,050 Say OemToAnsi("Escolha uma Op��o")   Size 150,8
@ 040,050 RADIO _aOpcoes VAR _nPos   
@ 080,080 BMPBUTTON TYPE 01 ACTION fOK()
@ 080,120 BMPBUTTON TYPE 02 ACTION Close(oDlgItem)
Activate Dialog oDlgItem Centered
_cCod    := Space(15)
Return

Static Function fOK()
   _cDesc      := Space(30)
   If _nPos == 1
      fOperador()
   ElseIf _nPos == 2
      fProduto()   
   Endif

Return


//******************************************************************************
//                              CONSULTA O OPERADOR
//******************************************************************************
Static Function fOperador()

@ 200,050 To 420,585 Dialog oDlgOpe Title OemToAnsi("Impress�o de C�digo de Barras do Operador")
@ 005,008 To 100,260

@ 042,020 Say OemToAnsi("Operador    ") Size 35,8
@ 040,070 Get _cOpe      Picture "@!" F3 "QAA" Valid fOpe() Size 55,8 Object oOpe 
@ 040,124 Get _cDesc     Picture "@!" When .F. Size 120,8 Object oDesc 

@ 080,185 BMPBUTTON TYPE 01 ACTION fImp002()
@ 080,225 BMPBUTTON TYPE 02 ACTION Close(oDlgOpe)
Activate Dialog oDlgOpe CENTERED

Return

Static Function fOpe()
Local lReturn := .T.
                                              
QAA->(dbSetOrder(1)) //Filial+ matricula
If !QAA->(dbSeek(xFilial("QAA")+_cOpe ))
	MsgBox(OemToAnsi("Operador N�o Encontrado"),OemToAnsi("Aten��o"),"INFO")
    cOpe := Space(06)              
    ObjectMethod(oOpe ,"Refresh()")
    lReturn := .F.
Else
   _cDesc    := QAA->QAA_NOME
   _cLabEtq  := _cOpe + " "+Subs(QAA->QAA_NOME,1,9)

   ObjectMethod(oDesc ,"Refresh()")
EndIf   

Return (lReturn)

//******************************************************************************
//                    CONSULTA O PRODUTO 
//******************************************************************************
Static Function fProduto()

@ 200,050 To 420,585 Dialog oDlgProd Title OemToAnsi("Impress�o de C�digo de Barras do Produto")
@ 005,008 To 100,260

@ 042,020 Say OemToAnsi("Produto    ") Size 35,8
@ 057,020 Say OemToAnsi("Quantidade ") Size 35,8
@ 072,020 Say OemToAnsi("Etiq. Inicial") Size 35,8
@ 072,140 Say OemToAnsi("Etiq. Final  ") Size 35,8
@ 040,070 Get _cCod      Picture "@!" F3 "SZA" Valid fCod() Size 50,8 Object oCod 
@ 040,124 Get _cDesc     Picture "@!" When .F. Size 120,8 Object oDesc 
@ 055,070 Get _nQuant    Picture "@E 999,999,999.99"  Valid fQtde() Size 50,8 Object oQuant 

@ 070,070 Get _cSerial   Picture "@!" When .F. Size 40,8 Object oSerial 
@ 070,170 Get _cSerFim   Picture "@!" When .F. Size 40,8 Object oSerFim 

@ 085,185 BMPBUTTON TYPE 01 ACTION fImp003()
@ 085,225 BMPBUTTON TYPE 02 ACTION Close(oDlgProd)

Activate Dialog oDlgProd CENTERED

Return

Static Function fQtde()
Local lReturn := .T.

If _nQuant <= 0
   MsgBox(OemToAnsi("Quantidade do Produto errada Redigite"),OemToAnsi("Aten��o"),"INFO")
   Return(.F.)
Endif            

If Mod(_nQuant,2) <> 0
   MsgBox(OemToAnsi("Quantidade n�o pode ser IMPAR, pois a etiq � dupla"),OemToAnsi("Aten��o"),"INFO")
   Return(.F.)
Endif

DbSelectArea("SZI")
//ALERT(xFilial("SZ1"))
SZI->(DbsetOrder(1)) //filial+codigo produto
If SZI->(DbSeek("01"+_cCod,.T.))	
  // ALERT("SERIAL NUMERO " + SZI->ZI_SERIAL)
   While !SZI->(EOF()) .And. SZI->ZI_COD == _cCod
      _cSerial := Strzero(val(SZI->ZI_SERFIM)+1,9) 
      SZI->(Dbskip())
   Enddo 
Else   
 //  ALERT("SERIAL NUMERO 000000001")
   _cSerial := "000000001"
Endif
_cSerFim := Strzero(Val(_cSerial) +( _nQuant-1),9) // Gera numero de serie final
ObjectMethod(oSerial ,"Refresh()")
ObjectMethod(oSerFim ,"Refresh()")

Return(lReturn)

Static Function fCod()
Local lReturn := .T.
   //Faz verificacao se foi digitado o codigo NEW HUBNER ou o Codigo do CLIENTE
   
If SubStr(_cCod,1,2) == "VW" //IF Incluido p/ imprimir qualquer produto volks como generico se quiser voltar a condi��o normal � s� tirar
	  _cDesc   := "Produto VW Generico"
//      _cCodigo := "000000" // codigo de Barras do produto VW eh ZERO ou seja generico                    
  	  _cCodBar :=  "8V-RSH" // codigo de Barras do produto VW eh ZERO ou seja generico                    
      _cCod    := "000000000000000" // codigo de Barras do produto VW eh ZERO ou seja generico           
      ObjectMethod(oDesc ,"Refresh()")
      ObjectMethod(oCod  ,"Refresh()")            
Else
  //Faz verificacao se foi digitado o codigo NEW HUBNER ou o Codigo do CLIENTE
   IF Subs(_cCod,5,1) == "."             
      SB1->(DbsetOrder(1)) //filial+codigo produto
	  If SB1->(DbSeek(xFilial("SB1")+_cCod),Found())	
 	     If Subs(SB1->B1_COD,6,1) <> "4"
  		    MsgBox("Somente Produto que seja Materia Prima Pode ser Impresso",OemToAnsi("Aten��o"),"INFO")
		    Return(.F.)
	     Endif  	           
	 	 _cDesc  := SB1->B1_DESC
	 	 _cCodBar := Subs(SB1->B1_CODBAR,1,6)  	           
         ObjectMethod(oDesc ,"Refresh()")
	  Else
	  	 MsgBox("Produto nao Encontrado",OemToAnsi("Aten��o"),"INFO")
		 lReturn := .F.
	  Endif
   Else
	  SB1->(DbsetOrder(9)) //filial+codap5
	  If SB1->(DbSeek(xFilial("SB1")+_cCod),Found())	
	     If Subs(SB1->B1_COD,6,1) <> "4"
  		    MsgBox("Somente Produto que seja Materia Prima Pode ser Impresso",OemToAnsi("Aten��o"),"INFO")
		    Return(.F.)
	     Endif  	           
	     _cDesc  := SB1->B1_DESC := SB1->B1_COD     
	 	 _cCodBar := Subs(SB1->B1_CODBAR,1,6)  	           
         ObjectMethod(oDesc ,"Refresh()")
         ObjectMethod(oCod  ,"Refresh()")            
	  Else
		 MsgBox("Produto nao Encontrado",OemToAnsi("Aten��o"),"INFO")
		 lReturn := .F.
	  Endif
		
   Endif                                                                    
endif
_nQuant := 0   
_cSerial  := Space(15) //Serial inicial 
_cSerFim  := Space(15) //Serial Final   
ObjectMethod(oSerial ,"Refresh()")
ObjectMethod(oSerFim ,"Refresh()")
ObjectMethod(oQuant  ,"Refresh()")

Return(lReturn)

Static function Fimp003() 
//************************************************************************************************
// EFETUA A IMPRESSAO DO CODIGO DE BARRAS DOS PRODUTOS
// Grava informa�oes no arquivo quando o usuario imprime a etiq. (SZI)
//************************************************************************************************ 

if  _cCod = " "
    msgbox("QUANTIDADE INVALIDA")
    RETURN
ENDIF



Reclock("SZI",.T.)
      SZI->ZI_FILIAL := xFilial("SZI")               
      SZI->ZI_COD    := _cCod
      SZI->ZI_SERIAL := _cSerial //Serial inicial 
      SZI->ZI_SERFIM := _cSerFim  //serial final
      SZI->ZI_USUARIO:= upper(alltrim(cUserName))
      SZI->ZI_DATA   := dDatabase
      //SZI->ZI_OBS    := 
MsUnlock("SZI")

For X:=Val(_cSerFim) to Val(_cSerial) Step -2
   _Serial1 := _cCodbar + Strzero(X,9)
   _Serial2 := _cCodbar + Strzero(X-1,9)

   MSCBPRINTER("S600","LPT1",,20,.f.,,,)   // 20= ALTURA DA ETIQUETA
   MSCBCHKSTATUS(.f.)
   MSCBBEGIN(1,4,50)
   MSCBSAYBAR(2,6,_Serial1,"N","3",35,,.F.,.F.,,1,,,,,)
   MSCBSAYBAR(38,6,_Serial2,"N","3",35,,.F.,.F.,,1,,,,,)
   MSCBSAY(5,3,_Serial1,"N","C","6")
   MSCBSAY(40,3,_Serial2,"N","C","6")
   MSCBEND()
   MSCBClosePrinter()      
next

_cCod       := Space(15)
_cDesc      := Space(30)
_cSerFim    := Space(09)
_cSerial    := Space(09)
_nQuant     := 0

Return


//************************************************************************************************
// EFETUA A IMPRESSAO DO CODIGO DE BARRAS DO OPERADOR COM 6 CARACTERES
//************************************************************************************************
static function Fimp002()

MSCBPRINTER("S600","LPT1",,30,.f.,,,) 
MSCBCHKSTATUS(.f.)
MSCBBEGIN(1,4,50)

MSCBSAYBAR(3,7,_cOpe,"N","3",30,,.t.,.t.,,2,,,,,)
MSCBSAYBAR(39,7,_cOpe,"N","3",30,,.t.,.t.,,2,,,,,)

MSCBEND()
MSCBClosePrinter()      

Return


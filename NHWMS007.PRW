/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WMS007  �Autor: Jos� Henrique M Felipetto  Data �  08/17/12 ���
�������������������������������������������������������������������������͹��
���Desc.     � Etiqueta de Produto - Modelo Grande                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WMS                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"

User Function NHWMS007()
Private _cProd := Space(Len(SB1->B1_COD)) , oDlgProd , oSay1 , oGet1 , oBtnPec , _nQtdPadr,_dData

oDlgProd  := MsDialog():New(0,0,50,400,"Digite o Produto:",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(08,10,{||"Peca:"},oDlgProd,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(06,30,{|u| if(Pcount() > 0, _cProd := u,_cProd)},oDlgProd,60,8,"@!",{||PartValid(_cProd)},;
					,,,,,.T.,,,{|| .T. },,,,,,"SB1","_cProd")

	oBtnPec := tButton():New(06,110,"Avan�ar",oDlgProd,{|| getPar(_cProd) } ,60,10,,,,.T.)
oDlgProd:Activate(,,,.t.,{||.T.},,)

Return

Static Function PartValid(Produto)
SB1->( DbSetOrder(1) )

If !SB1->( DbSeek(xFilial("SB1") + Produto ))
	alert("Produto n�o encontrado! Favor tente novamente")
	Return .F.
EndIf

_cLote := U_NHEST002()
Return

Static Function getPar(cProd) 
_nQuant := 0
_dData := Date()

If SB5->(DbSeek(xFilial("SB5") + Alltrim(cProd) ))
	_nQtdPadr := SB5->B5_QPA
EndIf

oDlgParam  := MsDialog():New(0,0,250,280,"Assistente de etiqueta.",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(08,10,{||"Peca:"},oDlgParam,,,,,,.T.,,)
	oGet1 := tGet():New(06,50,{|u| if(Pcount() > 0, cProd := u,cProd)},oDlgParam,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .F. },,,,,,,"cProd")

	oSay2 := TSay():New(28,10,{||"Quantidade:"},oDlgParam,,,,,,.T.,,)
	oGet2 := tGet():New(26,50,{|u| if(Pcount() > 0, _nQuant := u,_nQuant)},oDlgParam,60,8,"99999",{||fValQtde(_nQuant)},;
					,,,,,.T.,,,{|| .T. },,,,,,,"_nQuant")

	oSay3 := TSay():New(48,10,{||"Qtd. por Emb:"},oDlgParam,,,,,,.T.,CLR_HBLUE,)
	oGet3 := tGet():New(46,50,{|u| if(Pcount() > 0, _nQtdPadr := u,_nQtdPadr)},oDlgParam,60,8,"999999",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,,"_nQtdPadr")

	oSay6 := TSay():New(68,10,{||"Data:"},oDlgParam,,,,,,.T.,,)
	oGet6 := tGet():New(66,50,{|u| if(Pcount() > 0, _dData := u,_dData)},oDlgParam,60,8,"@!",{||atuLote(_dData)},;
					,,,,,.T.,,,{|| .T. },,,,,,,"_dData")
					
	oSay4 := TSay():New(88,10,{||"Lote:"},oDlgParam,,,,,,.T.,,)
	oGet4 := tGet():New(86,50,{|u| if(Pcount() > 0, _cLote := u,_cLote)},oDlgParam,60,8,"@!",{|| .T.},;
					,,,,,.T.,,,{|| .T. },,,,,,,"_cLote")	

	oBtnParam := tButton():New(108,50,"Avan�ar",oDlgParam,{||fImpLocal()} ,60,10,,,,.T.)
oDlgParam:Activate(,,,.t.,{||.T.},,)
Return

Static Function fImpLocal()
//_cLocal := Space(Len(CB5->CB5_CODIGO))
_cLocal   := CB5->CB5_CODIGO

oDlgLocal  := MsDialog():New(0,0,50,400,"Assistente de etiqueta.",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(08,10,{||"Local:"},oDlgLocal,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(06,30,{|u| if(Pcount() > 0, _cLocal := u,_cLocal)},oDlgLocal,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,"CB5","_cLocal")

	oBtnLocal := tButton():New(06,110,"Avan�ar",oDlgLocal,{|| Processa({|| doBarCod() },"Gerando Etiqueta...")} ,60,10,,,,.T.)
oDlgLocal:Activate(,,,.t.,{||.T.},,)
Return

Static Function doBarCod()
_cPorta := ""

If CB5->(DbSeek(xFilial("CB5") + Alltrim(_cLocal) ))
	If CB5->CB5_PORTA == '0'
		_cPorta := "LPT"+CB5->CB5_LPT
	Endif
Else
	alert(" Impressora n�o configurada ou n�o cadastrada no sistema. Verifique! ")
	Return .F.
EndIf

MSCBPRINTER("S4M",_cPorta,,,.F.,NIL,NIL,NIL,NIL,NIL,.T.)
MSCBCHKStatus(.T.)

For i := 1 to _nQuant

	MSCBBEGIN(1,4)
	MSCBSAY(10,05,"WHB","N","0","100,105")
	// Bloco: Fornecedor - C�digo Peca - Descri��o - Quantidade - C�digo de barra - DtDigit - NF
	MSCBSAY(10,39,"Codigo Peca: " ,"N","0","035,035")
	MSCBSAY(10,51,_cProd ,"N","0","095,095")
	SB1->(DbSeek(xFilial("SB1") + Alltrim(_cProd) ))
	MSCBSAY(10,65,"Descricao: " + Alltrim(SB1->B1_DESC) ,"N","0","035,035")
	MSCBSAY(10,71,"Quantidade: ","N","0","035,035")
	MSCBSAY(50,76,Alltrim(Str(_nQtdPadr)),"N","0","085,085")
	MSCBSAY(76,34,DTOC( _dData ),"N","0","075,075")

	MSCBSAYBAR(10,91,_cProd,"N","MB07",13,.F.,.T.,.F.,,3.4,1,.F.,.F.,"1",.T.)
	MSCBSAYBAR(10,115,_cLote,"N","MB07",13,.F.,.T.,.F.,,3.4,1,.F.,.F.,"1",.T.)

	MSCBInfoEti("Produto","30X100")
	MSCBEND()

Next i

MSCBCLOSEPRINTER()
MS_FLUSH()

MsgInfo("Impress�o Finalizada com Sucesso!")
oDlgProd:End()
Return

Static Function fValQtde(Quantidade)

If Quantidade <= 0
	alert(" A Quantidade deve ser maior que 0!")
	Return .F.
EndIf
Return

Static Function atuLote(Datta)
	_cLote := U_NHEST002(Datta)
	oDlgParam:Refresh()
Return
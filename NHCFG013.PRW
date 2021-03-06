
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFG013  �Autor:Jos� Henrique M Felipetto Data �  02/24/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de Controle Rotina X Usuarios                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "colors.ch"
#include "font.ch" 
#INCLUDE "PROTHEUS.CH"

User Function NHCFG013()

Private aRotina   := {}
Private cCadastro := "Consulta Rotina X Usuario"

aAdd( aRotina, {"Pesquisar"     ,"AxPesqui"      ,0,1 } )
aAdd( aRotina, {"Visualizar"    ,"U_CFG013(2)"   ,0,2 } )
aAdd( aRotina, {"Incluir"       ,"U_CFG013(1)"   ,0,3 } )
aAdd( aRotina, {"Excluir"       ,"U_CFG013(3)"   ,0,4 } )


dbSelectArea("ZRX")
ZRX->(DbSetOrder(1) )

mBrowse(,,,,"ZRX",,,,,,)

Return

User Function CFG013(nParam)
SetPrvt("nPar,_cUser,_cRotina")

bOk := {||.T.}
bCanc := {||oDlg:End() }
bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}

_cUser := Space(Len(ZRX->ZRX_USER))
_cRotina := Space(Len(ZRX->ZRX_ROTINA))

nPar := nParam

If nPar == 1 // Incluir
	bOk := {|| fInclui(_cUser,_cRotina) }
ElseIf nPar == 2 // Visualizar
	fCarrega()
	bOk := {|| oDlg:End() }
ElseIf nPar == 3 // Excluir
	fCarrega()
	bOk := {|| fExclui() }
EndIf

Private oDlg  	  := MsDialog():New(0,0,200,450,"USUARIO X ROTINA",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(28,10,{||"Usu�rio"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(26,45,{|u| if(Pcount() > 0, _cUser := u,_cUser)},oDlg,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,"QAA","_cUser")
	
	oSay2 := TSay():New(48,10,{||"Rotina"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet2 := tGet():New(46,45,{|u| if(Pcount() > 0, _cRotina := u,_cRotina)},oDlg,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,,"_cRotina")
	
oDlg:Activate(,,,.T.,{||.T.},,bEnchoice)

Return

Static Function fInclui(Usuario,Rotina)
	If !fValida(Usuario,Rotina)
		Return .F.
	EndIf
	RecLock("ZRX",.T.)
	    ZRX->ZRX_FILIAL := xFilial("ZRX")
		ZRX->ZRX_USER := Usuario
		ZRX->ZRX_ROTINA := Rotina
	MsUnLock("ZRX")	
	MsgInfo("Usu�rio " + Usuario + " autorizado a utilizar a rotina " + Rotina + "!")
	oDlg:End()
Return   

Static Function fValida(Usuario,Rotina)
	If Empty(Usuario) .or. Empty(Rotina)
		alert("Campo Usu�rio e Rotina obrigat�rio!")
		Return .F.
	EndIf
Return .T.

Static Function fCarrega()
_cUser := ZRX->ZRX_USER
_cRotina := ZRX->ZRX_ROTINA
Return 

Static Function fExclui()
	RecLock("ZRX",.F.)
		ZRX->(DbDelete() )
	MsUnLock("ZRX")
	MsgInfo("Dados exclu�dos com sucesso! ")
	oDlg:End()
Return
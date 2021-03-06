/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHEST035 � Autor � Alexandre R. Bento    � Data � 04/12/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Liberacao de EPI Quando o mesmo esta Bloqueado             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Execblock usado do programa NHEST023                       ���
�������������������������������������������������������������������������Ĵ��
��� Arquivos � SX6                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


#include "rwmake.ch"      

User Function nhest035()   

SetPrvt("_CPARAMETRO,")

@ 96,42 TO 250,505 DIALOG oDlg6 TITLE "Liberacao do EPI"
@ 23,14 Say "Desbloqueia a Movimentacao do EPI, quando o mesmo esta Fora"
@ 33,14 Say "da data de Durabilidade."
@ 50,139 BUTTON "Liberacao" Size 70,15  ACTION RefrDlg()

ACTIVATE DIALOG oDlg6 CENTERED
Return


Static Function RefrDlg()

SX6->(DbSetOrder(1)) // Filial + Variavel

SX6->(DbSeek(xFilial("SX6")+"MV_EPI"))

If MsgBox("Tem Certeza que Deseja Desbloquear o EPI","Confirmacao","YESNO")
   RecLock("SX6",.f.)
     SX6->X6_CONTEUD := "SIM"
    MsUnLock("SX6")
    Close(oDlg6)
Endif
Return 


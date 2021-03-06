/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHMDT005  �Autor  �Marcos R Roquitski  � Data �  13/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de prestadores de servicos.                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

User Function Nhmdt005()
Local aCores
SetPrvt("aRotina,cCadastro,")

aCores := {{'ZBW_DTASO+365<dDataBase.and.ZBW_VLINTE+365<dDatabase','BR_PRETO'},;
	       {'ZBW_DTASO+365>dDataBase.and.ZBW_VLINTE+365>dDatabase','BR_VERDE'},;
           {'ZBW_DTASO+365<dDataBase','BR_LARANJA' },;
           {'ZBW_VLINTE+365<dDataBase' , 'BR_AMARELO'}}

aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0, 3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Exclui","AxDeleta",0,5} ,;
             {"Legenda","U_fLegMdt()",0,6} }
             
cCadastro := "Cadastro de Prestadores de Servicos"

ZBW->(DbGotop())

mBrowse(,,,,"ZBW",,,,,,aCores)
Return
          

User Function fLegMdt()

Private aCores := {{ "BR_PRETO" , "ASO e Integracao Vencido" },;
                   { "BR_VERDE" , "Liberado" },;
				   { "BR_LARANJA" , "ASO Vencido" },;
				   { "BR_AMARELO" , "Integracao Vencida" }	}			   
				   
BrwLegenda(cCadastro,"Legenda",aCores)

Return

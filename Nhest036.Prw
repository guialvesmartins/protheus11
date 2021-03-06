/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � NHEST036        � Alexandre R. Bento    � Data �09.12.2004���
������������������������������������������������������������������������Ĵ��
���Descricao � Permite alterar campos do cadastro de produto em uma deter.��
���          � pasta def. no SX5 tabela ZF ->login(16)pastas "1/2"(10)   ���
������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                  ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

#INCLUDE "rwmake.ch"

User Function Nhest036()
public aCampoSB1 := {}

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Private cAlias := "SB1"

//��������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �
//� 4. Tipo de Transa��o a ser efetuada                          �
//�    1 - Pesquisa e Posiciona em um Banco de Dados             �
//�    2 - Simplesmente Mostra os Campos                         �
//�    3 - Inclui registros no Bancos de Dados                   �
//�    4 - Altera o registro corrente                            �
//�    5 - Remove o registro corrente do Banco de Dados          �
//����������������������������������������������������������������
PRIVATE aRotina := { {OemToAnsi("Pesquisa")  , "AxPesqui"     , 0 , 1},;  // "Pesquisar"
					 {OemToAnsi("Visualiza") , "AxVisual"     , 0 , 2},;  // "Visualizar"
					 {OemToAnsi("Altera")    , "U_fAltProd()" , 0 , 4}}   // "Alterar"  
							                                  
//��������������������������������������������������������������Ŀ
//� Define o cabe�alho da tela de atualiza��es                   �
//����������������������������������������������������������������
PRIVATE cCadastro := OemToAnsi("Altera��o de Produtos") 

//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �                        
//����������������������������������������������������������������
mBrowse( 6, 1,22,75,"SB1")

Return

User Function fAltProd()
local nReg      := SB1->(RECNO())
local nOpca     := 0
//local aCampoSB1 := {}
local lOK       := .F.
local cFolder   := " "                
local oDlg
Local nOpc      := 3   //1-2-VISUALIZA  4-ERRO  3-ALTERA

SX5->(DbGotop())
SX5->(DbSetOrder(1))
SX5->(DbSeek(xFilial("SX5")+"ZF")) // Tabela de valida��o de Usuarios, para alterar o produto por FOLDER                  
While !SX5->(Eof()) .And. SX5->X5_TABELA == "ZF"
   If Alltrim(Substr(SX5->X5_DESCRI,1,25))$Upper(Alltrim(cUserName)) //Verifica se o Usuario � o mesmo da tabela ZU no SX5
      cFolder := AllTrim(Subs(SX5->X5_DESCRI,26,10)) //Traz o Folder que o usuario pode alterar 
      lOK := .T. //Flag de Controle          
      Exit //achou for�a a saida
    
   Endif
   SX5->(DbSkip())                      
   
Enddo

/*
If !lOK  // Usuario sem permiss�o para cadastrar o Grupo
   MsgBox("Usuario sem Permiss�o para Alterar Dados deste Produto","Atencao","STOP")
   Return(.F.)  // retorna
Endif                        
*/

      
//��������������������������������������������������������������Ŀ
//� Carrega matriz com campos que serao alterados neste cadastro �
//����������������������������������������������������������������
AADD(aCampoSB1,"B1_COD")
AADD(aCampoSB1,"B1_DESC")
AADD(aCampoSB1,"B1_TE") //tes de entrada
AADD(aCampoSB1,"B1_TS") // tes de saida
//AADD(aCampoSB1,"B1_MSBLQL") //Campo que bloqueia produto sim ou n�o  
AADD(aCampoSB1,"B1_RPRODEP") //Campo que bloqueia produto sim ou n�o  


dbSelectArea("SX3")
dbSeek("SB1")
While !EOF() .And. (X3_ARQUIVO == cAlias)
	//IF X3USO(X3_USADO) .and. cNivel >= X3_NIVEL 
	   If Alltrim(X3_FOLDER)$cFolder
		  AADD(aCampoSB1,X3_CAMPO)
	   Endif	  
//	EndIF 
	DbSkip()
EndDO
dbSelectArea(cAlias)
If !SoftLock(cAlias)
	Return
EndIF
//��������������������������������������������������������������Ŀ
//� Monta a entrada de dados do arquivo                          �
//����������������������������������������������������������������
Private aTELA[0][0],aGETS[0]
                                                          
nOpca := AxAltera(cAlias,nReg,nOpc,aCampoSB1,,,,)
dbSelectArea(cAlias)
MsUnlock()
Return

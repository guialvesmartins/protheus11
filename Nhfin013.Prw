#include "rwmake.ch"     

User Function Nhfin013() 


SetPrvt("_LFLAG,")

Processa( {|| libera() } )// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Processa( {|| Execute(libera) } )
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHFIN013 � Autor � Jose Roberto Gorski   � Data � 10/05/00 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Exclusao dos Adiantamentos de Viagem                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para New Hubner                                 ���
�������������������������������������������������������������������������Ĵ��
��� Arquivos � SZ4,SE2                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function Libera
Static Function Libera()

If !MsgBox ("Tem Certeza em Excluir os Adiantamentos de Viagem Selecionados","Escolha","YESNO")
   Return
Endif

ProcRegua(SZ4->(RecCount()))

SZ4->(DbGoTop())
_lFlag := .f.
While SZ4->(!Eof())
                // Condicao para tratamento dos registros marcados
                If Marked("Z4_OK")
                    // Marca os Registros apontados
                   _lFlag := .t.
                Else
                   _lFlag := .f.
                Endif

                // Se Passou pelo Marked processa
                If _lFlag
                    
                    // Gerar Contas a Pagar
                    Exclui()  // Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>                     Execute(Exclui)  
                
                EndIf

                DbSelectArea("SZ4")
                IncProc()
                SZ4->(DbSkip())
EndDo

SZ4->(DbGoTop())
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � Exclui   � Autor �Jose Roberto Gorski    � Data � 10/05/00 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Exclusao do Adiantamento de viagem                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico New Hubner                                      ���
�������������������������������������������������������������������������Ĵ��
��� Arquivos � SZ4,SE1,SE2                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function Exclui
Static Function Exclui()

   RecLock("SZ4",.f.)
     SZ4->(DbDelete())
   MsUnLock("SZ4")

   // Libera para a Geracao de Novo Acerto de Viagem
   If SZ3->(DbSeek(xFilial("SZ3")+SZ4->Z4_NUM))
      RecLock("SZ3",.f.)
        SZ3->Z3_GEROUAC := " "
      MsUnLock("SZ3")
   Endif
Return

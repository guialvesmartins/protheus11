/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F290OWN   �Autor  �Marcos R. Roquitski � Data �  30/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para filtrar pelo vencto real.            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#INCLUDE "rwmake.ch"

User Function F290OWN()
SetPrvt("_dDataDe, _dDataAte, _cVar")

_dDatade    := SE2->E2_VENCREA
_dDataAte   := SE2->E2_VENCREA
_cVar       := ''        

@ 200,050 To 350,400 Dialog DlgFiltro Title OemToAnsi("Filtro do Vencimento")

@ 010,010 Say OemToAnsi("Data de  ") Size 45,8
@ 025,010 Say OemToAnsi("Data Ate ") Size 45,8

@ 009,070 Get _dDatade   PICTURE "99/99/99" Size 45,8
@ 024,070 Get _dDataAte  PICTURE "99/99/99" Size 45,8
      
@ 055,050 BMPBUTTON TYPE 01 ACTION fAfiltro(@_cVar)
@ 055,090 BMPBUTTON TYPE 02 ACTION Close(DlgFiltro)
Activate Dialog DlgFiltro CENTERED


Return(_cVar)

Static Function fAfiltro(pVar)
pVar    := '.AND.DTOS(E2_VENCREA)>="' + DTOS( _dDataDe ) + '"'
pVar    += '.AND.DTOS(E2_VENCREA)<="' + DTOS( _dDataAte) + '"'
Close(DlgFiltro)
Return(pVar)

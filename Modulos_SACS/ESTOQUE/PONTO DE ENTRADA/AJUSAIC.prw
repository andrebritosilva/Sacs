#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO11    � Autor � AP6 IDE            � Data �  08/04/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AJUSAIC()
LOCAL A := 1


SBM->(DBGOTOP())

DO WHILE ! SBM->(EOF())
   RECLOCK("AIC",.T.)
   AIC->AIC_GRUPO := SBM->BM_GRUPO
   AIC->AIC_PPRECO := 3
   AIC->AIC_CODIGO := STRZERO(A,6)
   AIC->(MSUNLOCK())
   
   
   A++
   sbm->(dbskip())
ENDDO


Return

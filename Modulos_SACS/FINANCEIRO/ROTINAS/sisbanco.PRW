
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SISBANCO  �Autor  �Microsiga           � Data �  03/31/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER function SISBANCO()
Local cBanco:=IIF(EMPTY(SE2->E2_CODBAR),LEFT(SE2->E2_LINDIG,3),LEFT(SE2->E2_CODBAR,3))
RETURN(cBanco)

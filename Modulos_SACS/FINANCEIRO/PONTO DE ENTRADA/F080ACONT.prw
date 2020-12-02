#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F080ACONT �Autor  � Cesar Padovani     � Data �  02/02/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada antes da contabilizacao da baixa manual   ���
���          � do Contas a Pagar                                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � MOTIVO DA ALTERACAO                           ���
�������������������������������������������������������������������������Ĵ��
��� Cesar        �02/02/12� Solicitante: Genildo Silva - Domus Aurea      ���
��� Padovani     �        � Motivo: Preencher o campo E5_CCD de acordo com���
���              �        �         o campo E2_CCD                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F080ACONT()

_aArea := GetArea()

//If lBaixou
	// Grava o Centro de Custo Debito e Credito no SE5 conforme o SE2 apos a baixa manual do titulo
	RecLock("SE5",.F.)
	SE5->E5_CCD := SE2->E2_CCD
	SE5->E5_CCC := SE2->E2_CCC
	MsUnLock()
//EndIf

RestArea(_aArea)

Return

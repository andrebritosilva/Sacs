#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F430BXA  �Autor  � Cesar Padovani     � Data �  02/02/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para gravacoes complementares apos a      ���
���          � baixa do titulo via Retorno Cobranca CNAB                  ���
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
User Function F430BXA()

_aArea := GetArea()

//If lBaixou .and. lMovAdto
	// Grava o Centro de Custo Debito e Credito no SE5 conforme o SE2 apos a baixa do titulo via Retorno Cobranca CNAB
	RecLock("SE5",.F.)
	SE5->E5_CCD := SE2->E2_CCD
	SE5->E5_CCC := SE2->E2_CCC
	MsUnLock()
//EndIf

RestArea(_aArea)

Return

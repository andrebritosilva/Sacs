#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MSD2460  �Autor  � Cesar Padovani     � Data �  04/10/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para gravacoes complementares apos a      ���
���          � gravacao dos itens do documento de saida                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � MOTIVO DA ALTERACAO                           ���
�������������������������������������������������������������������������Ĵ��
��� Cesar        �04/10/12� Solicitante: Genildo Silva - Domus Aurea      ���
��� Padovani     �        � Motivo: Gravar no campo D2_CONTA o conteudo do���
���              �        �         campo C6_CONTA                        ���
�������������������������������������������������������������������������Ĵ��
��� Cesar        �23/07/13� Solicitante: Genildo Silva - Domus Aurea      ���
��� Padovani     �        � Motivo: Gravar no campo D2_CCUSTO o conteudo  ���
���              �        �         do campo  C6_CC                       ���
�������������������������������������������������������������������������ͼ��
��� Genildo      �07/06/13� Solicitante: Genildo Silva - Domus Aurea      ���
���              �        � Motivo: Gravar no campo D2_CCUSTO o conteudo  ���
���              �        �         do campo  C6_CC                       ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MSD2460()

_aArea := GetArea()

// Posiciona no item do pedido de venda

DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)

DbSelectArea("SD2")
RecLock("SD2",.F.)
// Atualiza o campo D2_CCUSTO se houver preenchimento no campo C6_CC
If !Empty(SC6->C6_CC)
	SD2->D2_CCUSTO := SC6->C6_CC
EndIf
SD2->D2_DESCRI  := SC6->C6_DESCRI
MsUnlock()

cPoder3 := Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_PODER3")
                    
If cPoder3 $ "R/D"

   DbSelectArea("SB6")
   DbSetOrder(3)
   If DbSeek(xFilial("SB6")+SD2->D2_IDENTB6 )
   
      RecLock("SB6",.F.)
      SB6->B6_CC := SD2->D2_CCUSTO 

      MsUnLock()

   EndIf 
   
EndIf 

RestArea(_aArea)
Return
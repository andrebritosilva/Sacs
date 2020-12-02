#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MSD2460  ºAutor  ³ Cesar Padovani     º Data ³  04/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para gravacoes complementares apos a      º±±
±±º          ³ gravacao dos itens do documento de saida                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ MOTIVO DA ALTERACAO                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Cesar        ³04/10/12³ Solicitante: Genildo Silva - Domus Aurea      ³±±
±±³ Padovani     ³        ³ Motivo: Gravar no campo D2_CONTA o conteudo do³±±
±±³              ³        ³         campo C6_CONTA                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Cesar        ³23/07/13³ Solicitante: Genildo Silva - Domus Aurea      ³±±
±±³ Padovani     ³        ³ Motivo: Gravar no campo D2_CCUSTO o conteudo  ³±±
±±³              ³        ³         do campo  C6_CC                       ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±³ Genildo      ³07/06/13³ Solicitante: Genildo Silva - Domus Aurea      ³±±
±±³              ³        ³ Motivo: Gravar no campo D2_CCUSTO o conteudo  ³±±
±±³              ³        ³         do campo  C6_CC                       ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
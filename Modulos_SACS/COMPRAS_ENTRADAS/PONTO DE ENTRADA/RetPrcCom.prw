#include "rwmake.ch"
#include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA120BUT  º Autor ³Carlos R. Moreira   º Data ³  29/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para mostrar  o historico de compras      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RetPrcCom() 
Local aArea := GetArea()
Local nPosQtd    := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_QUANT"})
Local nPosUnOuM  := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_UNOUTMO"}) 
Local nPosVOuM   := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_VLOUTMO"})
Local nPosPreco  := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRECO"})
Local nPosTotal  := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_TOTAL"})
Local nPosOutM   := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_OUTMOE"})

Local nTaxa := 0 

DbSelectArea("SM2")
DbSetOrder(1)
If DbSeek(Dtos(dDataBase))

   cCampo := "M2_MOEDA"+Str(aCols[n,nPosOutM],1)
   nTaxa := SM2->(FieldGet(FieldPos(cCampo))) 

EndIf 

aCols[n,nPosVOuM] := aCols[n,nPosQtd] * aCols[n,nPosUnOuM] 

aCols[n,nPosPreco] := aCols[n,nPosUnOuM] * nTaxa 

aCols[n,nPosTotal] := aCols[n,nPosPreco] * aCols[n,nPosQtd] 

RestArea(aArea)

Return aCols[n,nPosVOuM]

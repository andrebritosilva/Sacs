#include "rwmake.ch"
#include "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA120BUT  � Autor �Carlos R. Moreira   � Data �  29/09/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para mostrar  o historico de compras      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

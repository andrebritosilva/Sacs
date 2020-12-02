#include 'protheus.ch'
#include 'parmtype.ch'

User Function MT100GE2()

Local aTitAtual  := PARAMIXB[1]
Local nOpc       := PARAMIXB[2]
Local aHeadSE2   := PARAMIXB[3]
Local aParcelas  := ParamIXB[5]
Local nX         := ParamIXB[4]
Local _aArea     := GetArea() 
Local cCusto     := SD1->D1_CC
Local cItem      := SD1->D1_ITEMCTA 

 SE2->E2_CCD     := cCusto
 SE2->E2_ITEMD   := cItem

RestArea(_aArea)

Return
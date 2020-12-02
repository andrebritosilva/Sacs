#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function GatCC()

Local aArea      := GetArea()
Local cCusto     := ""

cCusto := GatItVenda(M->C7_ITEMCTA)

RestArea( aArea )

Return cCusto

//----------------------------------------------------------------------


Static Function GatItVenda(cItem)

Local aArea     := GetArea()
Local nColItem  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEMCTA"})
Local cCusto    := ""
	
DbSelectArea("CTD")
DbSetOrder(1)

If DbSeek(xFilial("CTD") + aCols[n,nColItem])
	cCusto      :=  CTD->CTD_CUSTO
EndIf

RestArea( aArea )

Return cCusto
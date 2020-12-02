#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

//Gatilho para entidades contabeis a crédito nos movimentos bancários

User Function GatRec()

Local aArea    := GetArea()
Local cCusto   := ""

cCusto := GatItem(M->E5_ITEMC)

RestArea( aArea )

Return cCusto


Static Function GatItem(cItem)

Local aArea     := GetArea()
Local cCusto    := ""
Local cTipoCc   := ""
	
DbSelectArea("CTD")
DbSetOrder(1)

If DbSeek(xFilial("CTD") + cItem)
	cCusto :=  CTD->CTD_CUSTO
EndIf

RestArea( aArea )

Return cCusto
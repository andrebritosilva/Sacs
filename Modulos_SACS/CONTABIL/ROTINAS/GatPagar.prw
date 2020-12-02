#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

//Gatilho para entidades contabeis a d�bito nos movimentos banc�rios

User Function GatPagar()

Local aArea    := GetArea()
Local cCusto   := ""

cCusto := GatItem(M->E5_ITEMD)

RestArea( aArea )

Return cCusto


Static Function GatItem(cItem)

Local aArea     := GetArea()
Local cCusto    := ""
Local cTipoCc   := ""
	
DbSelectArea("CTD")
DbSetOrder(1)

If DbSeek(xFilial("CTD") + cItem) 
	cCusto := CTD->CTD_CUSTO
EndIf

RestArea( aArea )

Return cCusto
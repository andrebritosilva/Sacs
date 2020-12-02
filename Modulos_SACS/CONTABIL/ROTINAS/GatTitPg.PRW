#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

//Gatilho para entidades contabeis a crédito nos movimentos bancários

User Function GatTitPg ()

Local aArea    := GetArea()
Local cCusto   := ""

cCusto := GatItem(M->E2_ITEMD)

RestArea( aArea )

Return cCusto

User Function GatTitCPg ()

Local aArea    := GetArea()
Local cCusto   := ""

cCusto := GatItem(M->E2_ITEMC)

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

User Function GatTitRec ()

Local aArea    := GetArea()
Local cCusto   := ""

cCusto := GatItem(M->E1_ITEMD)

RestArea( aArea )

Return cCusto

User Function GatTitCRec ()

Local aArea    := GetArea()
Local cCusto   := ""

cCusto := GatItem(M->E1_ITEMC)

RestArea( aArea )

Return cCusto

User Function GatPreNota ()

Local aArea    := GetArea()
Local cCusto   := ""

cCusto := GatItem(M->D1_ITEMCTA)

RestArea( aArea )

Return cCusto
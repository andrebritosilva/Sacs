#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function GatEst(cItem)

oGet:Refresh()
cCC := SD3Item(cItem)
M->D3_CC := cCC

oGet:oBrowse:Refresh()
//oGet:oBrowse:refresh()
//oGet:oBrowse:setfocus()

Return .T.

Static Function SD3Item(cItem)

Local aArea     := GetArea()
Local cCusto    := ""

DbSelectArea("CTD")
DbSetOrder(1)

If DbSeek(xFilial("CTD") + cItem)
	cCusto      :=  CTD->CTD_CUSTO
EndIf

RestArea( aArea )

Return cCusto
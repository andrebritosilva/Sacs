#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function GatConta()

Local aArea      := GetArea()
Local cConta     := ""

cConta := GatCtaAux(M->C7_PRODUTO)

RestArea( aArea )

Return cConta

//----------------------------------------------------------------------


Static Function GatCtaAux(cProduto)

Local nColProd   := aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRODUTO"})
Local nColConta  := aScan(aHeader,{|x| AllTrim(x[2])=="C7_CONTA"})
Local cConta     := ""
	
DbSelectArea("SB1")
DbSetOrder(1)

If DbSeek(xFilial("SB1") + aCols[n,nColProd])
	If Empty (SB1->B1_CONTAUX)
		M->C7_CONTA := SB1->B1_CONTA
		cConta      := SB1->B1_CONTA
	Else
		M->C7_CONTA := SB1->B1_CONTAUX
		cConta      := SB1->B1_CONTAUX
	EndIf
EndIf

Return cConta
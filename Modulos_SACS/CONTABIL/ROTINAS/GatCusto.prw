#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function GatCusto()

Local aArea      := GetArea()
Local cCusto     := ""

cCusto := GatItem(M->C7_ITEMCTA)


RestArea( aArea )

Return cCusto

//----------------------------------------------------------------------


Static Function GatItem(cItem)

Local aArea     := GetArea()
Local nColItem  := aScan(aHeader,{|x| AllTrim(x[2])=="C7_ITEMCTA"})
Local nColApro  := aScan(aHeader,{|x| AllTrim(x[2])=="C7_APROV"})
Local nColCC    := aScan(aHeader,{|x| AllTrim(x[2])=="C7_CC"})
Local nColProd  := aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRODUTO"})
Local nColConta := aScan(aHeader,{|x| AllTrim(x[2])=="C7_CONTA"})
Local nColLocal := aScan(aHeader,{|x| AllTrim(x[2])=="C7_LOCAL"})
Local cCusto    := ""
Local cTipoCc   := ""
	
DbSelectArea("CTD")
DbSetOrder(1)

If DbSeek(xFilial("CTD") + aCols[n,nColItem])
	M->C7_APROV :=  CTD->CTD_APROV
	aCols[n,nColApro] := CTD->CTD_APROV
	M->C7_LOCAL :=  CTD->CTD_LOCAL
	aCols[n,nColLocal] := CTD->CTD_LOCAL 
	cCusto      :=  CTD->CTD_CUSTO
EndIf

DbSelectArea("CTT")
DbSetOrder(1)

If DbSeek(xFilial("CTT") + cCusto)
	cTipoCc:=  CTT->CTT_CLASSI
EndIf

DbSelectArea("SB1")
DbSetOrder(1)

If DbSeek(xFilial("SB1") + aCols[n,nColProd])
	If cTipoCc == '1'
		aCols[n,nColConta] := SB1->B1_CONTA //Conta Padrão
	ElseIf cTipoCc == '2'
		aCols[n,nColConta] := SB1->B1_CONTAUX //Conta Auxiliar
	ElseIf cTipoCc == '3'
		aCols[n,nColConta] := SB1->B1_CONTAUX //Conta Auxiliar
	Else
		aCols[n,nColConta] := SB1->B1_CONTA 
	EndIf
EndIf

If Empty (aCols[n,nColConta])
	aCols[n,nColConta] := SB1->B1_CONTA 
EndIf

aCols[n,nColApro] := M->C7_APROV

RestArea( aArea )

Return cCusto
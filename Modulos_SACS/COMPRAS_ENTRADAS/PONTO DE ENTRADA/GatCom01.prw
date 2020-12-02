#include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GATCOM01  ºAutor  ³Microsiga           º Data ³  02/21/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ GATILHO PARA PREENCHER O APROVADOR INFORMADO NA CONTA      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP11 - GTEX                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GatCom01()
Local nColPro := aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRODUTO"})
Local nColcc := aScan(aHeader,{|x| AllTrim(x[2])=="C7_CC"})
local cAprov := Space(6)

/*
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+aCols[n,nColPro])
IF ! EMPTY(SB1->B1_CONTA)
	dbselectarea("CT1")
	dbSetOrder(1)
	dbSeek(xFilial("CT1")+SB1->B1_CONTA)
	
	If Empty(CT1->CT1_APROV )
		dbSelectArea("CTT")
		dbSetOrder(1)
		dbSeek(xFilial("CTT")+aCols[n,nColcc])
		Return(CTT->CTT_APROV)
	else
		
		Return(CT1->CT1_APROV)
	
	endif
	
ELSE

*/	
	//alert("Não Existe Conta Cadastrada no Produto, Favor Veirificar.")
	
	if ! Empty(aCols[n,nColcc])
		dbSelectArea("CTT")
		dbSetOrder(1)
		dbSeek(xFilial("CTT")+aCols[n,nColcc])
   
   cAprov := CTT->CTT_APROV 

	endif
	
	Return(cAprov)
	
	
//endif

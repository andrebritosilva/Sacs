#INCLUDE "Protheus.ch"
#include "rwmake.ch"

User Function F050ROT()

Local aRotina := ParamIxb

aAdd( aRotina, { "Altera Ent. Contabeis", "U_F050CC()", 0, 8,, .F. } )

Return aRotina

User Function F050CC()

Local aPWiz       := {}
Local aRetWiz     := {}
Local cCCD        := ""
Local cCCC        := "" 
Local cItemD      := "" 
Local cItemC      := ""
Local lRet        := .F.
Local lContinua   := .T.

If __cUserId $ GetMV("MV_XUSER") //"000521" .Or. __cUserId != "000272" .Or. __cUserId != "000407" .Or. __cUserId != "000180"
	//MSGINFO( "Usuário não habilitado para utilização da ferramenta", "Autorização" )
	//Return
Else
	MSGINFO( "Usuário não habilitado para utilização da ferramenta", "Autorização" )
	Return
EndIf

aAdd(aPWiz,{ 1,"Item Debito: "       ,Space(TamSX3("E2_ITEMD")[1]) ,"","","CTD","",    ,.F.})
aAdd(aPWiz,{ 1,"Item Credito: "      ,Space(TamSX3("E2_ITEMC")[1]) ,"","","CTD","",    ,.F.})
aAdd(aPWiz,{ 1,"CC Debito: "         ,Space(TamSX3("E2_CCD")[1])   ,"","","CTT","",    ,.F.})
aAdd(aPWiz,{ 1,"CC Credito: "        ,Space(TamSX3("E2_CCC")[1])   ,"","","CTT","",    ,.F.})

aAdd(aRetWiz,Space(TamSX3("E2_ITEMD")[1]))
aAdd(aRetWiz,Space(TamSX3("E2_ITEMC")[1]))
aAdd(aRetWiz,Space(TamSX3("E2_CCD")[1]))
aAdd(aRetWiz,Space(TamSX3("E2_CCC")[1]))

lRet := ParamBox(aPWiz,"SACS",aRetWiz,,,,,,,,.T.,.T.) 

If !lRet
	Return
EndIf
 
cItemD   := Alltrim(aRetWiz[1]) 
cItemC   := Alltrim(aRetWiz[2])
cCCD     := Alltrim(aRetWiz[3])
cCCC     := Alltrim(aRetWiz[4])

If !Empty(cCCD)
	If Alltrim(cCCD) == "0"
		cCCD := ""
	EndIf
	RecLock("SE2",.F.)
	SE2->E2_CCD := cCCD
	SE2->(MsUnLock())
EndIf

If !Empty(cCCC)
	If Alltrim(cCCC) == "0"
		cCCC := ""
	EndIf
	RecLock("SE2",.F.)
	SE2->E2_CCC := cCCC
	SE2->(MsUnLock())
EndIf

If !Empty(cItemD)
	If Alltrim(cItemD) == "0"
		cItemD := ""
	EndIf
	RecLock("SE2",.F.)
	SE2->E2_ITEMD := cItemD
	SE2->(MsUnLock())
EndIf

If !Empty(cItemC)
	If Alltrim(cItemC) == "0"
		cItemC := ""
	EndIf
	RecLock("SE2",.F.)
	SE2->E2_ITEMC := cItemC
	SE2->(MsUnLock())
EndIf

Return
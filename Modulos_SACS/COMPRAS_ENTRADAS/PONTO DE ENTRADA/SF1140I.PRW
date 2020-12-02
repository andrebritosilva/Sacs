#INCLUDE "RWMAKE.CH"
#include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1140I   ºAutor  ³Carlos R. Moreira   º Data ³  24/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para verificar se trata-se de um reposicao º±±
±±º          ³de Caixa                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SF1140I()
	Local aArea := GetArea()
local lInc := PARAMIXB[1]
local lAlt := PARAMIXB[2]
	Local dVenc := ctod("  /  /  "), odVenc

	nOpca := 0

	DEFINE MSDIALOG oDlgProc TITLE "Data de Vencimento " From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,145 of oDlgProc PIXEL

	@ 15,5 Say "Vencimento: " Size 50,10  of oDlgProc Pixel
	@ 13,55 MSGet odVenc Var dVenc  Picture "@D" Size 80 ,10 of oDlgProc Pixel

	@ 50, 90 BUTTON "OK"     Size 20,10  Action {||nOpca := 1,oDlgProc:End()} of oDlgProc Pixel
	@ 50,120 BUTTON "Cancel" Size 20,10  Action {||nOpca := 2,oDlgProc:End()} of oDlgProc Pixel

	ACTIVATE MSDIALOG oDlgProc Centered
	
	If nOpca == 1
	
	  
	  Reclock("SF1",.F.)
	  SF1->F1_VENC := dVenc
	  sf1->(msunlock())
	
	endif	

	
	DbSelectArea("SD1")
	DbSetOrder(1)
	DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA )

	If !Empty(SD1->D1_PEDIDO)

		DbSelectArea("SC7")
		DbSetOrder(1)
		DbSeek(xFilial("SC7")+SD1->D1_PEDIDO )

		If SC7->C7_COND == "CXA"

			If MsgYesNo("Documento se refere a reposicao de Caixa")
      
				cRespCxa := GetRespCxa()
				
				DbSelectArea("SF1")
				RecLock("SF1",.F.)
				SF1->F1_REPOCXA := "S"
				SF1->F1_RESPCXA := cRespCxa
				MsUnlock()

			EndIf
   
		EndIf

	EndIf

	RestArea(aArea)
Return

Static Function GetRespCxa()
	Local cResp := Space(30)

	Local oDlgProc

	While .T.

		DEFINE MSDIALOG oDlgProc TITLE "Responsavel pelo Caixa" From 9,0 To 18,100 OF oMainWnd

		@ 5,3 to 41,395 of oDlgProc PIXEL

		@ 15,5 Say "Responsavel: " Size 50,10  of oDlgProc Pixel
		@ 13,45 MSGet cResp  Valid !Empty(cResp)  Size 320 ,10 of oDlgProc Pixel

//	@ 50, 90 BMPBUTTON TYPE 1 Action GrvObs(@cObs,oDlgProc,nModo)
		@ 50,120 BMPBUTTON TYPE 1 Action Close(oDlgProc)

		ACTIVATE MSDIALOG oDlgProc Centered

		If MsgYesNo("Confirma o responsavel")
			Exit
		EndIf
  
	End
  
Return cResp
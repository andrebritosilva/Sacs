#INCLUDE "RWMAKE.CH"
#include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1100I   ºAutor  ³Carlos R. Moreira   º Data ³  24/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para tratamento da ST MT qdo for Devolucao º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Gtex                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SF1100I()
	Local aArea := GetArea()

//Quando For Nota Fiscal de Devolucao
	If SF1->F1_TIPO == "D"
	
		cNfOri := ""
		lPri   := .T.
		nTotCxs := 0
		DbSelectArea("SD1")
		DbSetOrder(1)
		DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA )
		While SD1->(!Eof()) .And. SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == ;
				SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
		
			If Empty(SD1->D1_NFORI)
				DbSkip()
				Loop
			EndIf
		
			If !SD1->D1_NFORI+SD1->D1_SERIORI $ cNFOri
				If lPri
					cNFOri := SD1->D1_NFORI+SD1->D1_SERIORI
					lPri := .F.
				Else
					cNFOri += "/"+SD1->D1_NFORI+SD1->D1_SERIORI
				EndIf
			EndIf
		
			DbSelectArea("SD1")
			DbSkip()
		
		End
	
		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+SF1->F1_SERIE+SF1->F1_DOC )
	
		While SE1->(!Eof()) .And. SF1->F1_SERIE+SF1->F1_DOC == SE1->E1_PREFIXO+SE1->E1_NUM
		
			If SE1->E1_CLIENTE+SE1->E1_LOJA # SF1->F1_FORNECE+SF1->F1_LOJA
				DbSkip()
				Loop
			EndIf
		
			DbSelectArea("SE1")
			RecLock("SE1",.F.)
			SE1->E1_HIST := "NCC Ref. NF "+cNFOri
			MsUnlock()
			DbSkip()
		
		End
	
	
	ElseIf SF1->F1_EST == "EX" //Trata-se de Importacao

		GetDadosCompl()
    
	EndIf
                                                
//Posiciono no primeiro item para gravar o cc no titulo a pagar, quando houver
	DbSelectArea("SD1")
	DbSetOrder(1)
	DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA )

	DbSelectArea("SE2")
	DbSetOrder(1)
	If DbSeek(xFilial("SE2")+SF1->F1_SERIE+SF1->F1_DOC )

		While SE2->(!Eof()) .And. SF1->F1_SERIE+SF1->F1_DOC = SE2->E2_PREFIXO+SE2->E2_NUM

			If SF1->F1_FORNECE+SF1->F1_LOJA # SE2->E2_FORNECE+SE2->E2_LOJA
				DbSkip()
				Loop
			EndIf
   
			DbSelectArea("SE2")
			Reclock("SE2",.F.)
			SE2->E2_CCD   := SD1->D1_CC
			MsUnlock()
   
			DbSkip()
   
		End
 
	EndIf

	If MsgYesNo("Os Documentos originais foram apresentados")
      
		DbSelectArea("SF1")
		RecLock("SF1",.F.)
		SF1->F1_TPDOC := "S"
		MsUnlock()

	EndIf

If l103Class

		DbSelectArea("SF1")
		RecLock("SF1",.F.)
		SF1->F1_DTCLASS := Date() 
		MsUnlock()

EndIf 

 DbSelectArea("SF1")
 RecLock("SF1",.F.)
 SF1->F1_HORA   := Time()
 MsUnlock()

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetDadosCompl ºAutor  ³Carlos R Moreiraº Data ³  21/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pega os dados complementares da Importacao                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GetDadosCompl()
	Local oDlgProc
	Local oCbx
	Local cObs := Space(40)

	cDI      := Space(10)
	dDtReg   := dDataBase
	clocalN  := Space(30)
	cUFDes   := Space(2)
	cMensPad := Space(3)
	cDadoTra := Space(120)
	nPesLiq  := 0
	nPesBru  := 0
	cEspecie := Space(10)
	nVolume  := 0

	While .T.
	
		DEFINE MSDIALOG oDlgProc TITLE "Dados Complementares da NF Importacao" From 9,0 To 29,80 OF oMainWnd
	
		@ 5,3 to 132,315 of oDlgProc PIXEL
	
		@ 13, 10 Say "Num. DI: " Size 50,10  of oDlgProc Pixel
	
		@ 13, 60 MSGET cDI SIZE 70, 10 OF oDlgProc PIXEL
	
		@ 13, 210 Say "Data Reg: " Size 50,10  of oDlgProc Pixel
		
		@ 13, 240 MSGET dDtReg When .T. SIZE 60, 10 OF oDlgProc PIXEL
	
		@ 33, 10 Say "Loc Desembarque: " Size 60,10  of oDlgProc Pixel
	
		@ 33, 60 MsGet cLocalN  When .T.  Picture "@S" SIZE 130, 10 OF oDlgProc PIXEL
	
		@ 33, 210 Say "UF Des: " Size 50,10  of oDlgProc Pixel
		@ 33, 240 MsGet cUfDes When .T. Picture "@!" F3 "12" Valid ExistCpo("SX5","12"+cUFDES) SIZE 30, 10 OF oDlgProc PIXEL
	
		@ 53, 10 Say "Transportadora: " Size 60,10  of oDlgProc Pixel
	
		@ 53, 60 MsGet cDadoTra  When .T.  Picture "@S" SIZE 230, 10 OF oDlgProc PIXEL
	
		@ 73, 10  Say "Men. Pad:" Size 50,10  of oDlgProc Pixel
		@ 73, 60 MsGet cMensPad  F3 "SM4" When .T.  SIZE 30, 10 OF oDlgProc PIXEL

		@ 93, 10 Say "Peso Liq: " Size 50,10  of oDlgProc Pixel
	
		@ 93, 60 MSGET nPesLiq Picture "@E 999,999,999" SIZE 70, 10 OF oDlgProc PIXEL
	
		@ 93, 210 Say "Peso Bru: "  Size 50,10  of oDlgProc Pixel
		
		@ 93, 240 MSGET nPesBru  When .T. Picture "@E 999,999,999" SIZE 60, 10 OF oDlgProc PIXEL

		@ 113, 10 Say "Especie: " Size 50,10  of oDlgProc Pixel
	
		@ 113, 60 MSGET cEspecie Picture "@!" SIZE 70, 10 OF oDlgProc PIXEL
	
		@ 113, 210 Say "Volume: "  Size 50,10  of oDlgProc Pixel
		
		@ 113, 240 MSGET nVolume  When .T. Picture "@E 999,999,999" SIZE 60, 10 OF oDlgProc PIXEL

		@ 134, 250 BMPBUTTON TYPE 1 Action Close(oDlgProc)
	//@ 70,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)
	
		ACTIVATE MSDIALOG oDlgProc Centered
	
		If !Empty(cDI)
			If MsgYesNo("Confirma a gravacao dos dados")
	       
				GravDadosCompl()
	       
				Exit
			Else
				Aviso("Atencao","Como se trata da Nota Fiscal de importacao os dados complementares sao obrigatorio.",{"Voltar"} )
			EndIf
		EndIf
	
	End

Return
                           


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO4     ºAutor  ³Microsiga           º Data ³  06/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravDadosCompl()
	Local aArea := GetArea()

	DbSelectArea("SF1")
	RecLock("SF1",.F.)
	SF1->F1_DI_NUM  := cDI
	SF1->F1_DTREG   := dDtReg
	SF1->F1_LOCALN  := cLocalN
	SF1->F1_UFDES   := cUFDes
	SF1->F1_TRA_IMP := cDadoTra
	SF1->F1_PLIQUI  := nPesLiq
	SF1->F1_PBRUTO  := nPesBru
	SF1->F1_ESPECI1 := cEspecie
	SF1->F1_VOLUME1 := nVolume
	MsUnlock()

	DbSelectArea("SD1")
	DbSetOrder(1)
	DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA )

	While SD1->(!Eof()) .And. SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

		RecLock("SD1",.F.)
		SD1->D1_ADICA   := "1"
		SD1->D1_SEQ_ADI := "555"
		MsUnlock()
		DbSkip()
	End

	RestArea(aArea)
Return

#INCLUDE "PROTHEUS.CH"

User Function MT100AGR()

Local aArea	:= GetArea()
Local lRet		:= .T.
Local cFilPesq 	:= SF1->F1_FILIAL
Local cNota		:= SF1->F1_DOC
Local cSerie	:= SF1->F1_SERIE
Local cCliente	:= SF1->F1_FORNECE
Local cLojaCli	:= SF1->F1_LOJA
Local cNumPed	:= ""
Local cArqLog	:= ""
Local cBufImp	:= ""
Local cXmlRet	:= ""
Local cCond		:= ""
Local aCabec 	:= {}
Local aItens 	:= {}
Local nItem 	:= 0
Local nHndImp	:= 0
Local nOpc		:= 0
Local nX	    := 0
Local lExclui := !(INCLUI .Or. ALTERA)

Private cConsumo  := Space(07)

IF lExclui
	Return()
EndiF

//Ponto de Entrada para gravar o Mes/Ano de Consumo no SF1 (NF Entrada)
//	GrvConsumo()

RestArea(aArea)
Return()

/*****************************/
Static Function GrvConsumo()
/*****************************/

Local oDlg
Local oConsumo
Local aArea	   := GetArea()
Local cFilial  := SD1->D1_FILIAL
Local cSerie   := SD1->D1_SERIE
Local cDoc     := SD1->D1_DOC
Local cTipo    := SD1->D1_TIPO
Local cFornec  := SD1->D1_FORNECE
Local cLoja    := SD1->D1_LOJA
Local cCusto   := SD1->D1_CC
Local cProduto := SD1->D1_COD
Local cPedido  := SD1->D1_PEDIDO
Local cItePed  := SD1->D1_ITEMPC
Local lOk      := .T.

DEFINE MSDIALOG oDlg TITLE "Informe Mes/Ano Consumo"  FROM 10,10 TO 16,40 of oMainWnd

@ 10,03 say  "Mes/Ano : " SIZE 040,013 of oDlg PIXEL
@ 10,30 MsGet cConsumo SIZE 50,08 Of oDlg  PIXEL PICTURE "XX/XXXX" SIZE 50,013

DEFINE SBUTTON FROM 27,30 TYPE 01 Enable of oDlg ACTION If (Empty(cConsumo),lOk := .F.,oDlg:End()) //( lOk := .T. , Close( oDlg ) )
//DEFINE SBUTTON FROM 27,68 TYPE 02 Enable of oDlg ACTION (oDlg:End()) //( lOk := .F. , Close( oDlg ) )

Activate MSDialog oDlg center

If !Empty(cConsumo)
	cDoc      := SF1->F1_DOC
	cSerie    := SF1->F1_SERIE
	cFornec   := SF1->F1_FORNECE
	cLoja     := SF1->F1_LOJA
	
	dbSelectArea("SF1")
	RecLock("SF1",.F.)
	SF1->F1_Consumo	:= Alltrim(cConsumo)
	MsUnlock()
	
	dbSelectArea("SD1")
	Dbsetorder(1)
	If DbSeek(xFilial("SF1")+cDoc+cSerie+cFornec+cLoja )
		cCusto   := SD1->D1_CC
		cProduto := SD1->D1_COD
		nPrimeiro := 0
		WHILE SF1->F1_DOC == SD1->D1_DOC
			cProduto := SD1->D1_COD
			nPrimeiro := nPrimeiro + 1
			If nPrimeiro == 1
				DbSkip()
			Else
				If cCusto == SD1->D1_CC
					DbSkip()
				Else
					DbSelectArea("SC7")
					SC7->(DbSetOrder(1))
					If SC7->(DbSeek(xFilial("SD1")+cPedido+cItePed ))
						If SUBSTR(SC7->C7_CC,1,2)=="10" .or. SUBSTR(SC7->C7_CC,1,2)=="11" .or. SUBSTR(SC7->C7_CC,1,2)=="12"
							cCusto   := "10"
							//Else
							//	cCusto   := SC7->C7_CC
						EndIf
						dbselectArea("SD1")
					Else
						dbselectArea("SD1")
						If SUBSTR(SD1->D1_CC,1,2)=="10" .or. SUBSTR(SD1->D1_CC,1,2)=="11" .or. SUBSTR(SD1->D1_CC,1,2)=="12"
							cCusto   := "10"
						EndIf
					EndIf
				EndIf
				DbSkip()
			EndIf
		End
	EndIf
	dbSelectArea("SE2")
	DbSetOrder(6)
	If DbSeek(xFilial("SF1")+cFornec+cLoja+cSerie+cDoc )
		WHILE cFornec+cLoja+cSerie+cDoc == SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM
			RecLock("SE2",.F.)
			SE2->E2_CCD	    := cCusto
			SE2->E2_CONSUMO := cConsumo
			MsUnLock()
			DbSkip()
		End
	EndIf
EndIf

RestArea(aArea)
Return(.T.)

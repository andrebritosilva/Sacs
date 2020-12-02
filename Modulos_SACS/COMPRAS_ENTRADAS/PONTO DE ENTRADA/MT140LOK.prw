#include "rwmake.ch"
#include "protheus.ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT140TOK  ºAutor  ³Carlos R Moreira    º Data ³  03/21/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para corrigir a quantidade de digitos da   º±±
±±º          ³Nota Fiscal de Entrada a                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT140LOK()
Local lRet := .T.
Local nPosTes     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
Local nPosCod     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})

cNFiscal := StrZero(Val(cNFiscal),9)

If !aCols[n,Len(aHeader)+1]
	
	cTipoProd := Posicione("SB1",1,xFilial("SB1")+aCols[n,nPosCod],"B1_PRD_LOC")
	
	//Produto de locacao ira solicitar o nuemro de serie do equipamente
	If cTipoProd == "L"
		
		If !GetSerieEq()
			Return .F.
		EndIf
		
	EndIf
	
EndIf

Return  lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Microsiga           º Data ³  08/14/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetSerieEq()
Local lRet := .T.
Local nPosEqSerie := aScan(aHeader,{|x| AllTrim(x[2])=="D1_EQSERIE"})
Local cEqSerie    := Space(20)
Local nPosQtd     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_QUANT"})
Local nPosDes     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_DESCR"})
Local nPosCod     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
Local oDlg
Local cEquip      := Alltrim(aCols[n,nPosCod])+"-"+Alltrim(aCols[n,nPosDes])

Private oFont1  := TFont():New( "TIMES NEW ROMAN",12.5,18,,.T.,,,,,.F.)
Private oFont2  := TFont():New( "TIMES NEW ROMAN",12.5,12,,.T.,,,,,.F.)
Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)
Private oFont3  := TFont():New( "ARIAL",10.5,10,,.T.,,,,,.F.)

Private oEquip, oSerie

While .T.
	
	nOpca  := 0
	
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Serie do Equipamento") From 9,0 To 28,80 OF oMainWnd
	
	@   5,05 to 40,315 title "Equipamento "
	
	@   45,05 to 090,315 title "Serie"
	
	@ 17, 10 MSGET oEquip VAR cEquip When .F. SIZE 300,14  PIXEL;
	OF oDlg  COLOR CLR_HBLUE FONT oFont1 RIGHT  //VALID ChkRG(@cRG,oSay)
	
	@ 60, 10 MSGET oSerie VAR cEqSerie SIZE   300,14 PIXEL;
	OF oDlg  COLOR CLR_HBLUE FONT oFont1 RIGHT
	
	@ 120, 80 Button "&Confirma"     Size 50,15 Action {||nOpca:=1,oDlg:End()} of oDlg Pixel //Localiza o Dia
	@ 120,140 Button "&Cancelar"     Size 50,15 Action {||nOpca:=2,oDlg:End()} of oDlg Pixel //Localiza o Dia
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpca == 1
		
		If !Empty(cEqSerie)
			
			If aCols[n,nPosQtd] > 1
				MsgStop("Quando o equipamento possuir serie nao pode ter mais de uma unidade.")
				Return .F.
			EndIf
			
		Else
		   Exit
		EndIf
		
		aCols[n,nPosEqSerie] := cEqSerie
		Exit

	Else   

	      Exit               

	EndIf
	
End
Return lRet 

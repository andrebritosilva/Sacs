#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function AtuAtf()

	Local aArea         := GetArea()
	Local aRet			:= {}
	Local aAreaCT1		:= CT1->(GetArea())
	Local aAreaCVD		:= CVD->(GetArea())
	Local aCfg			:= {}
	Local cCampos		:= ""
	Local lContinua		:= .T.
	Local oModCT1Imp	:= Nil

	Private oProcess   

	SaveInter()

	oModCT1Imp	:= FWLoadModel("CTBA020")

	aCfg := { { "SB1", cCampos, {|| FWMVCRotAuto(oModCT1Imp, "SB1", 3, { {"SB1MASTER",xAutoCab} }, , .T.) } }, {"SB5",,} }

	If ParamBox({	{6,"Selecione Arquivo",PadR("",150),"",,"", 90 ,.T.,"Alteração de Produtos","",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE}},;
					"Importar Estrutura de Produtos",@aRet) 

		oProcess:= MsNewProcess():New( {|lEnd| AvaImpCSV( lEnd, oProcess, aRet[1], aCfg )} )
		oProcess:Activate()

	EndIf

	oModCT1Imp:Destroy()
	oModCT1Imp := Nil

	RestInter()

	RestArea(aAreaCVD)
	RestArea(aAreaCT1)

Return Nil

RestInter()

Return .T.


//--------------------------------------------------
/*/{Protheus.doc} AvaImpCSV
Importa registros da planilha para a tabela SB1

@author André Brito
@since 02/12/2019
@version P12.1.17
 
@return 
/*/
//--------------------------------------------------

Static Function AvaImpCSV(lEnd, oProcess, cArq, aCfg , lProc)

Local cLinha      := ""
Local lPrim       := .T.
Local aCampos     := {}
Local aDados      := {}
Local aProds      := {}
Local i           := 0
Local x           := 0
Local lMsErroAuto := .F.
Local nAtual      := 0
Local nTotal      := 0
Local nTot2       := 0
Local nNumProd    := 0
Local aCab        := {}
Local oModel      := Nil
Local aArea       := GetArea()
Local aAreaSb1    := GetArea()
Local lRet        := .T.
Local cCofins     := ""
Local cPis        := ""
Local aProdutos   := {}
Local nInclu      := 0
Local cCod        := ""

Private aErro := {}
 
DbSelectArea("SN3")
SN3->(DbGoTop())

While !SN3->(EOF())

If Alltrim(SN3->N3_CCUSTO) == '2130'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '100.20.02'
		SN3->N3_SUBCCON := '2130.10'
		SN3->N3_SUBCTA  := '2130.10'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '2131'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '100.20.02'
		SN3->N3_SUBCCON := '2131.10'
		SN3->N3_SUBCTA  := '2131.10'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '2140'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '100.10.01'
		SN3->N3_SUBCCON := '2140.10'
		SN3->N3_SUBCTA  := '2140.10'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '2141'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '100.10.02'
		SN3->N3_SUBCCON := '2141.10'
		SN3->N3_SUBCTA  := '2141.10'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '2142'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '100.10.02'
		SN3->N3_SUBCCON := '2142.10'
		SN3->N3_SUBCTA  := '2142.10'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '2144'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '100.20.02'
		SN3->N3_SUBCCON := '2144.10'
		SN3->N3_SUBCTA  := '2144.10'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '2146'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '100.10.04'
		SN3->N3_SUBCCON := '2146.10'
		SN3->N3_SUBCTA  := '2146.10'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '2147'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '100.20.02'
		SN3->N3_SUBCCON := '2147.10'
		SN3->N3_SUBCTA  := '2147.10'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '2149'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '100.10.04'
		SN3->N3_SUBCCON := '2149.10'
		SN3->N3_SUBCTA  := '2149.10'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '2150'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '100.10.02'
		SN3->N3_SUBCCON := '2150.10'
		SN3->N3_SUBCTA  := '2150.10'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1208'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '200.10.10'
		SN3->N3_SUBCCON := '2000.10'
		SN3->N3_SUBCTA  := '2000.10'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1401'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '200.10.11'
		SN3->N3_SUBCCON := '2000.11'
		SN3->N3_SUBCTA  := '2000.11'
	MsUnLock
EndIf
If Empty(SN3->N3_CCUSTO)
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '200.10.12'
		SN3->N3_SUBCCON := '2000.12'
		SN3->N3_SUBCTA  := '2000.12'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1400'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '200.10.14'
		SN3->N3_SUBCCON := '2000.14'
		SN3->N3_SUBCTA  := '2000.14'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1401'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '200.10.11'
		SN3->N3_SUBCCON := '2000.11'
		SN3->N3_SUBCTA  := '2000.11'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1402'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '200.10.15'
		SN3->N3_SUBCCON := '2000.15'
		SN3->N3_SUBCTA  := '2000.15'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1202'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '200.10.16'
		SN3->N3_SUBCCON := '2000.16'
		SN3->N3_SUBCTA  := '2000.16'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1203'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '200.10.17'
		SN3->N3_SUBCCON := '2000.17'
		SN3->N3_SUBCTA  := '2000.17'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1201'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '200.10.18'
		SN3->N3_SUBCCON := '2000.18'
		SN3->N3_SUBCTA  := '2000.18'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1204'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '200.10.19'
		SN3->N3_SUBCCON := '2000.19'
		SN3->N3_SUBCTA  := '2000.19'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1205'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '200.10.20'
		SN3->N3_SUBCCON := '2000.20'
		SN3->N3_SUBCTA  := '2000.20'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1207'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '200.10.21'
		SN3->N3_SUBCCON := '2000.21'
		SN3->N3_SUBCTA  := '2000.21'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '120801'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '200.10.22'
		SN3->N3_SUBCCON := '2000.22'
		SN3->N3_SUBCTA  := '2000.22'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '120802'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '200.10.23'
		SN3->N3_SUBCCON := '2000.23'
		SN3->N3_SUBCTA  := '2000.23'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1000'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '300.10.10'
		SN3->N3_SUBCCON := '3000.10'
		SN3->N3_SUBCTA  := '3000.10'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1001'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '300.10.10'
		SN3->N3_SUBCCON := '3000.10'
		SN3->N3_SUBCTA  := '3000.10'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1002'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '300.10.10'
		SN3->N3_SUBCCON := '3000.10'
		SN3->N3_SUBCTA  := '3000.10'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1003'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '300.10.10'
		SN3->N3_SUBCCON := '3000.10'
		SN3->N3_SUBCTA  := '3000.10'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1101'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '300.10.11'
		SN3->N3_SUBCCON := '3000.11'
		SN3->N3_SUBCTA  := '3000.11'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1102'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '300.10.12'
		SN3->N3_SUBCCON := '3000.12'
		SN3->N3_SUBCTA  := '3000.12'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1300'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '300.10.14'
		SN3->N3_SUBCCON := '3000.14'
		SN3->N3_SUBCTA  := '3000.14'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1103'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '300.10.15'
		SN3->N3_SUBCCON := '3000.15'
		SN3->N3_SUBCTA  := '3000.15'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1104'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '300.10.16'
		SN3->N3_SUBCCON := '3000.16'
		SN3->N3_SUBCTA  := '3000.16'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1301'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '300.10.17'
		SN3->N3_SUBCCON := '3000.17'
		SN3->N3_SUBCTA  := '3000.17'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1105'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '300.10.18'
		SN3->N3_SUBCCON := '3000.18'
		SN3->N3_SUBCTA  := '3000.18'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1106'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '300.10.18'
		SN3->N3_SUBCCON := '3000.18'
		SN3->N3_SUBCTA  := '3000.18'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1107'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '300.10.19'
		SN3->N3_SUBCCON := '3000.19'
		SN3->N3_SUBCTA  := '3000.19'
	MsUnLock
EndIf
If Alltrim(SN3->N3_CCUSTO) == '1206'
	RecLock("SN3",.F.)
		SN3->N3_CCUSTO  := '300.10.20'
		SN3->N3_SUBCCON := '3000.20'
		SN3->N3_SUBCTA  := '3000.20'
	MsUnLock
EndIf
SN3->(DbSkip())

EndDo

If lRet
	ApMsgInfo("Alteração de registros concluida com sucesso!","SUCESSO")
Else
	ApMsgInfo("Aconteceram erros na sua alteração, verifique!","Conferência")
EndIf

RestArea(aArea)

Return
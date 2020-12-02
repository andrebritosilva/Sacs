#include "rwmake.ch"
#include "COLORS.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ PFATR01  ณ Autor ณ Carlos R. Moreira     ณ Data ณ 16.01.18 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Relatorio de movimenta็ใo por centro de custo              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ PFATR01                                                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Especifico                                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PFATR01()
	Local aSays     := {}
	Local aButtons  := {}
	Local nOpca     := 0
	Local cCadastro := OemToAnsi("Relatorio de Movimento C.Custo")

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	Titulo := OemToAnsi("Relatorio de Movimento C.Custo")
	aRegs := {}

	cPerg := "PFATR01"

	aAdd(aRegs,{cPerg,"01","Emissao  de        ?","","","mv_ch1","D"   ,08    ,00      ,0   ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Emissao  Ate       ?","","","mv_ch2","D"   ,08    ,00      ,0   ,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","CC Inicial de      ?","","","mv_ch3","C"   ,09    ,00      ,0   ,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
	aAdd(aRegs,{cPerg,"04","CC Final Ate       ?","","","mv_ch4","C"   ,09    ,00      ,0   ,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})

	U_ValidPerg(cPerg,aRegs)

	pergunte(cPerg,.F.)
	Aadd(aSays, OemToAnsi(" Este programa ira gerar um consulta com os itens   "))
	Aadd(aSays, OemToAnsi(" da nota fiscal de acordo com parametros selecionados."))

	Aadd(aButtons, { 1, .T., { || nOpca := 1, FechaBatch()  }})
	Aadd(aButtons, { 2, .T., { || FechaBatch() }})
	Aadd(aButtons, { 5, .T., { || Pergunte(cPerg,.T.) }})

	FormBatch(cCadastro, aSays, aButtons)

	If nOpca == 1

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica as perguntas selecionadas                           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		aEmp := {}
		Aadd( aEmp, SM0->M0_CODIGO )

		If Len(aEmp) > 0

			CriaArqTmp()

			For nX := 1 to Len(aEmp)

				Processa( { || Proc_Arq(aEmp[nX]) }, "Processando o arquivo de trabalho .")  //

				Processa( { || Proc_Int(aEmp[nX]) }, "Processando o arquivo de trabalho .")  //

			Next

			Processa({||MostraCons()},"Mostra a Consulta..")

			TRB->(DbCloseArea())

		EndIf

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONS_NF   บAutor  ณMicrosiga           บ Data ณ  05/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MostraCons()
	Local aSize     := MsAdvSize(.T.)
	Local aObjects:={},aInfo:={},aPosObj:={}
	Local aCampos := {}

	aInfo   :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	aBrowse := {}

	AaDD(aBrowse,{"PROD","","Produto",""})
	AaDD(aBrowse,{"DESCPRD","","Descricao",""})

	AaDD(aBrowse,{"CC","","C.Custo"})
	AaDD(aBrowse,{"NOME","","Descricao",""})

	AaDD(aBrowse,{"DOC","","N.Fiscal",""})

	AaDD(aBrowse,{"EMISSAO","","Dt Emissao",""})

	AaDD(aBrowse,{"QUANT"   ,"","Quantidade","@e 999,999.99"})
	AaDD(aBrowse,{"PRCVEN"   ,"","Vlr.Unit","@e 999,999.99"})
	AaDD(aBrowse,{"VALOR"   ,"","Vlr. Total","@e 99,999,999.99"})

	AaDD(aBrowse,{"ARMAZEM"   ,"","Armazem",""})
	AaDD(aBrowse,{"ARMDEST"   ,"","Arm. Dest",""})

	DbSelectArea("TRB")
	DbGoTop()

	cMarca   := GetMark()
	nOpca    :=0
	lInverte := .F.
	oFonte  := TFont():New( "TIMES NEW ROMAN",14.5,22,,.T.,,,,,.F.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMonta a  tela com o tree da origem e com o tree do destino    ณ
	//ณresultado da comparacao.                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//aAdd( aObjects, { 100, 100, .T., .T., .F. } )
	//aAdd( aObjects, { 100, 100, .T., .T., .F. } )
	//aInfo  := { aSize[1],aSize[2],aSize[3],aSize[4],3,3 }
	//aPosObj:= MsObjSize( aInfo, aObjects, .T.,.T. )

	AADD(aObjects,{100,015,.T.,.T.})
	//AADD(aObjects,{100,100,.T.,.T.})
	AAdd( aObjects, { 0, 40, .T., .F. } )

	aPosObj:=MsObjSize(aInfo,aObjects)

	DEFINE MSDIALOG oDlg1 TITLE "Mostra a movimentacao de produtos " From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
	//ณ arquivo de trabalho "TRB".                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark := MsSelect():New("TRB","","",aBrowse,@lInverte,@cMarca,{aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]})  //35,3,213,385

	oMark:bMark := {| | fa060disp(cMarca,lInverte)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

	//@ aPosObj[1,1]+10,aPosObj[1,2]+30 Button "&Excel"    Size 60,15 Action ExpCons() of oDlg1 Pixel //Localiza o Dia

	@ aPosObj[2,1]+10,aPosObj[2,2]+520 Button "&Exp Excel"    Size 60,15 Action Exp_Excel() of oDlg1 Pixel //Localiza o Dia

	@ aPosObj[2,1]+10,aPosObj[2,2]+585 Button "&Imprimir"    Size 60,15 Action Impr_RelMov() of oDlg1 Pixel //Localiza o Dia

	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||oDlg1:End()},.T.) CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpr_RelCli Autor  ณCarlos R. Moreira   บ Data ณ  09/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o relatorio de Conferencia de Inventario           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Impr_RelMov()
	Local oPrn
	Private oFont, cCode

	oFont  :=  TFont():New( "Arial",,15,,.T.,,,,,.F. )
	oFont3 :=  TFont():New( "Arial",,12,,.t.,,,,,.f. )
	oFont12:=  TFont():New( "Arial",,10,,.t.,,,,,.f. )
	oFont5 :=  TFont():New( "Arial",,10,,.f.,,,,,.f. )
	oFont9 :=  TFont():New( "Arial",, 8,,.T.,,,,,.f. )
	oArialNeg06 :=  TFont():New( "Arial",, 6,,.T.,,,,,.f. )

	oFont1:= TFont():New( "Times New Roman",,28,,.t.,,,,,.t. )
	oFont2:= TFont():New( "Times New Roman",,14,,.t.,,,,,.f. )
	oFont4:= TFont():New( "Times New Roman",,20,,.t.,,,,,.f. )
	oFont7:= TFont():New( "Times New Roman",,18,,.t.,,,,,.f. )
	oFont11:=TFont():New( "Times New Roman",,10,,.t.,,,,,.t. )

	oFont6:= TFont():New( "HAETTENSCHWEILLER",,10,,.t.,,,,,.f. )

	oFont8:=  TFont():New( "Free 3 of 9",,44,,.t.,,,,,.f. )
	oFont10:= TFont():New( "Free 3 of 9",,38,,.t.,,,,,.f. )
	oFont13:= TFont():New( "Courier New",,10,,.t.,,,,,.f. )

	oBrush  := TBrush():New(,CLR_HGRAY,,)
	oBrush1 := TBrush():New(,CLR_BLUE,,)
	oBrush2 := TBrush():New(,CLR_WHITE,,)

	oPrn := TMSPrinter():New()
	//oPrn:SetPortrait()

	oPrn:Setup()

	oPrn:SetLandscape()
	oPrn:SetPaperSize(9)

	lPri := .T.
	nPag := 0
	nLin := 490

	nTotVlr := 0

	DbSelectArea("TRB")
	DbGoTop()

	ProcRegua(RecCount())        // Total de Elementos da regua

	While TRB->(!EOF())

		IncProc("Imprimindo o relatorio...")

		If lPri
			oPrn:StartPage()
			cTitulo := Titulo
			cRod    := "Periodo de "+Dtoc(MV_PAR01)+" ATE "+Dtoc(MV_PAR02)
			aTit    := {cTitulo,SM0->M0_NOME,cRod}
			nPag++
			U_CabRel(aTit,1,oPrn,nPag,"")
			CabCons(oPrn)
			nLin := 410
			lPri := .F.
		EndIf


		oPrn:Box(nLin,100,nLin+60,3300)

		oPrn:line(nLin, 250,nLin+60, 250)
		oPrn:line(nLin, 600,nLin+60, 600)
		oPrn:line(nLin, 800,nLin+60, 800)
		oPrn:line(nLin,1650,nLin+60,1650)
		oPrn:line(nLin,1800,nLin+60,1800)
		oPrn:line(nLin,2050,nLin+60,2050)	
		oPrn:line(nLin,2200,nLin+60,2200)
		oPrn:line(nLin,2400,nLin+60,2400)
		oPrn:line(nLin,2650,nLin+60,2650)
		oPrn:line(nLin,2800,nLin+60,2800)
		oPrn:line(nLin,2950,nLin+60,2950)
		oPrn:line(nLin,3150,nLin+60,3150)

		oPrn:Say(nLin+10,  110,TRB->CC      ,oFont9 ,100)
		oPrn:Say(nLin+10,  260,TRB->NOME    ,oFont9 ,100)
		oPrn:Say(nLin+10,  630,TRB->PROD    ,oFont9 ,100)
		oPrn:Say(nLin+10,  810,TRB->DESCPRD ,oFont9 ,100)

		oPrn:Say(nLin+10, 1660,TRB->DOC     ,oFont9 ,100)
		oPrn:Say(nLin+10, 1810,Dtoc(EMISSAO)  ,oFont9 ,100)

		oPrn:Say(nLin+10, 2060,Transform(TRB->QUANT,"@E 999,999.999") ,oFont9 ,100)
		oPrn:Say(nLin+10, 2210,Transform(TRB->PRCVEN,"@E 999,999.999")  ,oFont9 ,100)
		oPrn:Say(nLin+10, 2410,Transform(TRB->VALOR,"@E 999,999.999")      ,oFont9 ,100)
		oPrn:Say(nLin+10, 2660,TRB->ARMAZEM    ,oFont9 ,100)
		oPrn:Say(nLin+10, 2810,TRB->ARMDEST   ,oFont9 ,100)
		oPrn:Say(nLin+10, 2960,Dtoc(TRB->DTDEV)  ,oFont9 ,100)
		oPrn:Say(nLin+10, 3160,Transform(TRB->QTDDEV,"@E 999,999.999") ,oFont9 ,100)

        nTotVlr += TRB->VALOR
          
		nLin += 60

		If nLin > 2200
			oPrn:EndPage()
			oPrn:StartPage()
			cTitulo := Titulo
			cRod    := "Periodo de "+Dtoc(MV_PAR01)+" ATE "+Dtoc(MV_PAR02)
			aTit    := {cTitulo,SM0->M0_NOME,cRod}
			nPag++
			U_CabRel(aTit,1,oPrn,nPag,"")
			CabCons(oPrn)
			nLin := 410
			lPri := .F.

		EndIf

		DbSelectArea("TRB")
		DbSkip()

	End

    If nTotVlr > 0

       nLin += 80

		oPrn:Box(nLin,100,nLin+60,3300)

		oPrn:line(nLin,2650,nLin+60,2650)
		oPrn:line(nLin,2400,nLin+60,2400)

		oPrn:Say(nLin+10, 110,"Total Geral : "       ,oFont9 ,100)
		oPrn:Say(nLin+10, 2410,Transform(nTotVlr,"@E 999,999.999")      ,oFont9 ,100)
		             
    EndIf 
    
	oPrn:EndPage()

	If !lPri

		oPrn:Preview()
		oPrn:End()
	EndIf

    TRB->(DbGoTop())
    
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabCons   บAutor  ณCarlos R. Moreira   บ Data ณ  19/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณmonta o cabecalho da consulta                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CabCons(oPrn)

	nLin := 320

	oPrn:FillRect({nLin,100,nLin+60,3300},oBrush)

	oPrn:Box(nLin,100,nLin+60,3300)

	oPrn:line(nLin, 250,nLin+60, 250)
	oPrn:line(nLin, 600,nLin+60, 600)
	oPrn:line(nLin, 800,nLin+60, 800)
	oPrn:line(nLin,1650,nLin+60,1650)
	oPrn:line(nLin,1800,nLin+60,1800)
	oPrn:line(nLin,2050,nLin+60,2050)	
	oPrn:line(nLin,2200,nLin+60,2200)
	oPrn:line(nLin,2400,nLin+60,2400)
	oPrn:line(nLin,2650,nLin+60,2650)
	oPrn:line(nLin,2800,nLin+60,2800)
	oPrn:line(nLin,2950,nLin+60,2950)
	oPrn:line(nLin,3150,nLin+60,3150)

	oPrn:Say(nLin+10,  110,"C.Custo"    ,oFont9 ,100)
	oPrn:Say(nLin+10,  260,"Nome"       ,oFont9 ,100)
	oPrn:Say(nLin+10,  630,"Produto"    ,oFont9 ,100)
	oPrn:Say(nLin+10,  810,"Descricao"  ,oFont9 ,100)

	oPrn:Say(nLin+10, 1660,"Documento"  ,oFont9 ,100)
	oPrn:Say(nLin+10, 1810,"Emissao"    ,oFont9 ,100)

	oPrn:Say(nLin+10, 2060,"Quantidade" ,oFont9 ,100)
	oPrn:Say(nLin+10, 2210,"Vlr Unit."  ,oFont9 ,100)
	oPrn:Say(nLin+10, 2410,"Total"      ,oFont9 ,100)
	oPrn:Say(nLin+10, 2660,"Loc Orig"   ,oFont9 ,100)
	oPrn:Say(nLin+10, 2810,"Loc Dest"   ,oFont9 ,100)
	oPrn:Say(nLin+10, 2960,"Dt.Dev"     ,oFont9 ,100)
	oPrn:Say(nLin+10, 3160,	"Qtde Dev"  ,oFont9 ,100)

	nLin += 60

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFATR48   บAutor  ณMicrosiga           บ Data ณ  08/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Exp_Excel()
	Private aDadosExcel := {}

	AaDd(aDadosExcel,{ 	"C.Custo"       ,;
	"Descricao",;
	"Produto"      ,;
	"Desc Prod" ,;
	"Doc",;
	"Emissao"      ,;
	"Qtde"         ,;
	"Unit."         ,;
	"Total."         ,;
	"Arm. Orig."         ,;
	"Arm. Dest "         ,;						
	"Dt. Devol." ,;
	"Qtde Devol."  } )

	nCol := Len(aDadosExcel[1])

	DbSelectArea("TRB")
	DbGoTop()

	ProcRegua(RecCount())        // Total de Elementos da regua

	While TRB->(!EOF())

		AaDD( aDadosExcel, { TRB->CC ,;
		TRB->NOME,;
		TRB->PROD,;
		TRB->DESCPRD,;
		TRB->DOC ,;
		Dtoc(TRB->EMISSAO),;
		Transform(TRB->QUANT,"@E 999,999.999" )   ,;
		Transform(TRB->PRCVEN,"@E 999,999.99" )   ,;
		Transform(TRB->VALOR,"@E 999,999.99" )    ,;
		TRB->ARMAZEM ,;
		TRB->ARMDEST ,;
		Dtoc(TRB->DTDEV),;
		Transform(TRB->QTDDEV,"@E 999,999.99" )} )

		DbSelectArea("TRB")
		DbSkip()

	End

	Processa({||U_Run_Excel(aDadosExcel,nCol)},"Gerando a Integra็ใo com o Excel...")

	MsgInfo("Exportacao efetuada com sucesso..")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGR01   บAutor  ณMicrosiga           บ Data ณ  04/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function 	CriaArqTmp()
	Local aCampos := {}

	//Array com os campos do Arquivo temporario


	AADD(aCampos,{ "CC"      ,"C",09,0 } )
	AADD(aCampos,{ "NOME"    ,"C",30,0 } )

	AADD(aCampos,{ "PROD"    ,"C",15,0 } )
	AADD(aCampos,{ "DESCPRD"    ,"C",30,0 } )

	AADD(aCampos,{ "QUANT"   ,"N",11,2 } )
	AADD(aCampos,{ "PRCVEN"  ,"N",11,2 } )
	AADD(aCampos,{ "VALOR"   ,"N",11,2 } )

	AADD(aCampos,{ "DOC"      ,"C",09,0 } )

	AADD(aCampos,{ "ARMAZEM"   ,"C",02,0 } )
	AADD(aCampos,{ "ARMDEST"   ,"C",02,0 } )		

	AADD(aCampos,{ "EMISSAO"   ,"D", 8,0 } )

	AADD(aCampos,{ "DTDEV"   ,"D",08,0 } )
	AADD(aCampos,{ "QTDDEV"  ,"N",11,0 } )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria arquivo de trabalho                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"TRB", if(.T. .OR. .F., !.F., NIL), .F. )

	IndRegua("TRB",cNomArq,"CC+DOC",,,OemToAnsi("Selecionando Registros..."))	//

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProc_Arq  บAutor  ณCarlos R Moreira    บ Data ณ  04/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o arquivo para gerar o arquivo de trabalho        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Proc_Arq(cEmp)
	Local aNomArq := {}
	Local aArq := {{"SD2"," "},{"SA1"," "},{"CTT"," "},{"SB1"," "}} //

	cArq   := "sx2"+cEmp+"0"
	cAliasTrb := "sx2trb"

	cPath := GetSrvProfString("Startpath","")
	cArq := cPath+cArq

	//Faco a abertura do SX2 da empresa que ira gerar o arquivo de trabalho
	Use  &(cArq ) alias &(cAliasTrb) New

	If Select( cAliasTRB ) == 0
		MsgAlert("Arquivo nao foi aberto..."+cArq)
		Return
	Else
		DbSetIndex( cArq )
	EndIf

	For nArq := 1 to Len(aArq)

		DbSelectArea( cAliasTrb )
		DbSeek( aArq[nArq,1] )

		aArq[nArq,2] := (cAliasTrb)->x2_arquivo

	Next

	cQuery := "	SELECT  SD2.D2_COD, SD2.D2_DESCRI, SD2.D2_QUANT, SD2.D2_PRCVEN, "
	cQuery += "         SD2.D2_TOTAL, SD2.D2_CCUSTO, CTT.CTT_DESC01, SD2.D2_EMISSAO, SD2.D2_DOC,  "
	cQuery += "         SD2.D2_LOCAL, SD2.D2_LOCDEST   "	

	cQuery += " FROM "+ aArq[Ascan(aArq,{|x|x[1] = "SD2" }),2]+" SD2 "

	cQuery += " LEFT OUTER JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "CTT" }),2]+" CTT ON "
	cQuery += "              SD2.D2_CCUSTO  = CTT.CTT_CUSTO AND CTT.D_E_L_E_T_ <> '*' "

	cQuery += " WHERE SD2.D2_CCUSTO BETWEEN '" + MV_PAR03 + "' AND  '" + MV_PAR04 + "' AND "
	cQuery +=       " SD2.D2_EMISSAO  BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' AND "
	cQuery +=       " SD2.D_E_L_E_T_<>'*'"
	//	cQuery +=       " ORDER BY SC6.C6_FILIAL,SC6.C6_ENTREG,SC6.C6_NUM,SC6.C6_ITEM"

	cQuery := ChangeQuery(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")
	TCSetField("QRY","D2_EMISSAO","D")

	DbSelectArea("QRY")
	DbGoTop()

	ProcRegua(RecCount())

	While QRY->(!Eof())

		IncProc("Processando o Arquivo de trabalho....")

		DbSelectArea("TRB")
		RecLock("TRB",.T.)

		TRB->PROD     := QRY->D2_COD 
		TRB->DESCPRD  := QRY->D2_DESCRI

		TRB->QUANT    := QRY->D2_QUANT 

		TRB->EMISSAO  := QRY->D2_EMISSAO 

		TRB->DOC      := QRY->D2_DOC 

		TRB->CC       := QRY->D2_CCUSTO 
		TRB->NOME     := QRY->CTT_DESC01 
		TRB->PRCVEN   := QRY->D2_PRCVEN 
		TRB->VALOR    := QRY->D2_TOTAL 
		TRB->ARMAZEM  := QRY->D2_LOCAL 
		TRB->ARMDEST  := QRY->D2_LOCDEST 

		MsUnlock()

		DbSelectArea("QRY")
		DbSkip()

	End

	QRY->(DbCloseArea())

	(cAliasTrb)->(DbCloseArea())

Return

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณLchoiceBarณ Autor ณ Pilar S Albaladejo    ณ Data ณ          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Mostra a EnchoiceBar na tela                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LchoiceBar(oDlg,bOk,bCancel,lPesq)
	Local oBar, bSet15, bSet24, lOk
	Local lVolta :=.f.

	DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
	DEFINE BUTTON RESOURCE "S4WB008N" OF oBar GROUP ACTION Calculadora() TOOLTIP OemtoAnsi("Calculadora...")
	DEFINE BUTTON RESOURCE "SIMULACAO" OF oBar GROUP ACTION Exp_Excel() TOOLTIP OemToAnsi("Exporta para Planilha Excel...")    //


	DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
	SetKEY(15,oBtOk:bAction)
	DEFINE BUTTON oBtCan RESOURCE "CANCEL" OF oBar ACTION ( lLoop:=.F.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP OemToAnsi("Cancelar - <Ctrl-X>")  //
	SetKEY(24,oBtCan:bAction)
	oDlg:bSet15 := oBtOk:bAction
	oDlg:bSet24 := oBtCan:bAction
	oBar:bRClicked := {|| AllwaysTrue()}
Return

Static Function ButtonOff(bSet15,bSet24,lOk)
	DEFAULT lOk := .t.
	IF lOk
		SetKey(15,bSet15)
		SetKey(24,bSet24)
	Endif
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProc_Arq  บAutor  ณCarlos R Moreira    บ Data ณ  04/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o arquivo para gerar o arquivo de trabalho        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Proc_Int(cEmp)
	Local aNomArq := {}
	Local aArq := {{"SD3"," "},{"SA1"," "},{"CTT"," "},{"SB1"," "}} //

	cArq   := "sx2"+cEmp+"0"
	cAliasTrb := "sx2trb"

	cPath := GetSrvProfString("Startpath","")
	cArq := cPath+cArq

	//Faco a abertura do SX2 da empresa que ira gerar o arquivo de trabalho
	Use  &(cArq ) alias &(cAliasTrb) New

	If Select( cAliasTRB ) == 0
		MsgAlert("Arquivo nao foi aberto..."+cArq)
		Return
	Else
		DbSetIndex( cArq )
	EndIf

	For nArq := 1 to Len(aArq)

		DbSelectArea( cAliasTrb )
		DbSeek( aArq[nArq,1] )

		aArq[nArq,2] := (cAliasTrb)->x2_arquivo

	Next

	cQuery := "	SELECT  SD3.D3_COD, SB1.B1_DESC, SD3.D3_QUANT, SD3.D3_CUSTO1, "
	cQuery += "         SD3.D3_CC, CTT.CTT_DESC01, SD3.D3_EMISSAO, SD3.D3_DOC,  "
	cQuery += "         SD3.D3_LOCAL, CTT.CTT_LOCAL   "	

	cQuery += " FROM "+ aArq[Ascan(aArq,{|x|x[1] = "SD3" }),2]+" SD3 "

	cQuery += " LEFT OUTER JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "CTT" }),2]+" CTT ON "
	cQuery += "              SD3.D3_CC  = CTT.CTT_CUSTO AND CTT.D_E_L_E_T_ <> '*' "

	cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SB1" }),2]+" SB1 ON "
	cQuery += "              SD3.D3_COD     = SB1.B1_COD    AND SB1.D_E_L_E_T_ <> '*' "

	cQuery += " WHERE SD3.D3_CC BETWEEN '" + MV_PAR03 + "' AND  '" + MV_PAR04 + "' AND "
	cQuery +=       " SD3.D3_EMISSAO  BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' AND "
	cQuery +=       " SD3.D_E_L_E_T_<>'*'"

	cQuery := ChangeQuery(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")
	TCSetField("QRY","D3_EMISSAO","D")

	DbSelectArea("QRY")
	DbGoTop()

	ProcRegua(RecCount())

	While QRY->(!Eof())

		IncProc("Processando o Movimentos de Balcใo ....")

		DbSelectArea("TRB")
		RecLock("TRB",.T.)

		TRB->PROD     := QRY->D3_COD 
		TRB->DESCPRD  := QRY->B1_DESC 

		TRB->QUANT    := QRY->D3_QUANT 

		TRB->EMISSAO  := QRY->D3_EMISSAO 

		TRB->DOC      := QRY->D3_DOC 

		TRB->CC       := QRY->D3_CC 
		TRB->NOME     := QRY->CTT_DESC01 
		TRB->PRCVEN   := QRY->D3_CUSTO1 / QRY->D3_QUANT 
		TRB->VALOR    := QRY->D3_CUSTO1 
		TRB->ARMAZEM  := QRY->D3_LOCAL 
		TRB->ARMDEST  := QRY->CTT_LOCAL  

		MsUnlock()

		DbSelectArea("QRY")
		DbSkip()

	End

	QRY->(DbCloseArea())

	(cAliasTrb)->(DbCloseArea())

Return

#INCLUDE "RWMAKE.CH"
#Include "Protheus.ch"
#INCLUDE "colors.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFINR01   บAutor  ณCarlos R. Moreira   บ Data ณ  14/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o Arquivo para Exportar para Planilha de Excel        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PFINR01()
	Local aSays     := {}
	Local aButtons  := {}
	Local nOpca     := 0
	Local cCadastro := OemToAnsi("Gera o consulta por Movimentacao Bancaria")

	Private  cArqTxt
	Private cPerg := "PFINR01"

	PutSx1(cPerg,"01","Data Inicial               ?","","","mv_ch1","D",  8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{{"Data Inicial de processamento "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"02","Data Final                 ?","","","mv_ch2","D",  8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{{"Data Final de processamento   "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"03","Fornec/Cliente de          ?","","","mv_ch3","C",  6,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",{{"Cliente Inicial "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"04","Fornec/Clietne Ate         ?","","","mv_ch4","C",  6,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",{{"Cliente Final  "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"05","Loja  De                   ?","","","mv_ch5","C",  2,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",{{"Loja    Inicial "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"06","Loja  Ate                  ?","","","mv_ch6","C",  2,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",{{"Loja    Final  "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"07","CC Inicial                 ?","","","mv_ch7","C",  9,0,0,"G","","","CTT","","mv_par07","","","","","","","","","","","","","","","","",{{"Produto Inicial "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"08","CC Final                   ?","","","mv_ch8","C",  9,0,0,"G","","","CTT","","mv_par08","","","","","","","","","","","","","","","","",{{"Produto Final  "}},{{" "}},{{" "}},"")

	aHelpPor :=	{"Define se a exportacao de dados sera consolidada entre empresas"}
	aHelpEsp :=	{}
	aHelpEng :=	{}

	PutSx1( cPerg, 	"09","Consolidas as Empresas  ?","Consolidas as Empresas ?","Consolidas as Empresas ?","mv_chf","N",1,0,1,"C","","","","",;
	"mv_par11","Nao","","","","Sim","","",;
	"","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

	PutSx1(cPerg,"10","Natureza de                ?","","","mv_chc","C",  10,0,0,"G","","","SED","","mv_par13","","","","","","","","","","","","","","","","",{{"Natureza Financeira Inicial "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"11","Natureza Final             ?","","","mv_chd","C",  10,0,0,"G","","","SED","","mv_par14","","","","","","","","","","","","","","","","",{{"Natureza Financeira Final    "}},{{" "}},{{" "}},"")

	Pergunte(cPerg,.F.)

	Aadd(aSays, OemToAnsi(" Este programa ira gerar um consulta com os itens   "))
	Aadd(aSays, OemToAnsi(" da nota fiscal de acordo com parametros selecionados."))

	Aadd(aButtons, { 1, .T., { || nOpca := 1, FechaBatch()  }})
	Aadd(aButtons, { 2, .T., { || FechaBatch() }})
	Aadd(aButtons, { 5, .T., { || Pergunte(cPerg,.T.) }})

	FormBatch(cCadastro, aSays, aButtons)

	If nOpca == 1

		If MV_PAR09 == 2

			DbSelectArea("SM0")
			aAreaSM0 := GetArea()

			aEmp := U_SelEmp("V")

			RestArea( aAreaSM0 )

			If Len(aEmp) == 0
				MsgStop("Nao houve selecao de nenhuma empresa")
			EndIf
		Else
			aEmp := {}
			Aadd( aEmp, SM0->M0_CODIGO )
		Endif

		If Len(aEmp) > 0

			CriaArqTmp()

			For nX := 1 to Len(aEmp)
				Processa( { || Proc_Arq(aEmp[nX]) }, "Processando o arquivo de trabalho .")  //
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
ฑฑบPrograma  ณProc_Arq  บAutor  ณCarlos R Moreira    บ Data ณ  15/05/17   บฑฑ
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
	Local aNomArq  := {}
	Local cItemDe  := MV_PAR12
	Local cItemAte := MV_PAR13
	Local cCCDe    := GatIt(MV_PAR12)
	Local cCCAte   := GatIt(MV_PAR13)
	Local aArq     := {{"SD1"," "},{"SA2"," "},{"SE2"," "},{"SF4"," "},{"CTT"," "},{"SE5"," "}}

	cArq   := "sx2"+cEmp+"0"
	cAliasTrb := "sx2trb"
	
	If Empty(cCCAte)
		cCCDe  := MV_PAR07
		cCCAte := MV_PAR08
	EndIf

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

	cQuery := " SELECT  SE5.E5_DATA, SE5.E5_RECPAG, SE5.E5_MOEDA, SE5.E5_TIPODOC, SE5.E5_BENEF,SE5.E5_SEQ,SE5.E5_DOCUMEN, "
	cQuery += "          SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA,SE5.E5_TIPO,SE5.E5_CLIFOR,SE5.E5_LOJA, "
	cQuery += "         SE5.E5_NATUREZ, SE5.E5_VALOR,SE5.E5_ITEMD,SE5.E5_ITEMC,SE5.E5_CCD,SE5.E5_CCC, SE5.E5_HISTOR, SE5.E5_VLDESCO,SE5.E5_MOTBX, "
	cQuery += "         SE5.E5_BANCO, SE5.E5_AGENCIA,SE5.E5_CONTA  "

	cQuery += " FROM "+ aArq[Ascan(aArq,{|x|x[1] = "SE5" }),2]+" SE5 "

	cQuery += " WHERE SE5.D_E_L_E_T_ <> '*' "
	cQuery += "	And SE5.E5_DATA BETWEEN '"+Dtos(MV_PAR01)+"' And '"+Dtos(mv_par02)+"'"
	cQuery += " And SE5.E5_FILIAL = '"+xFilial("SE5")+"' And SE5.E5_SITUACA <> 'C'"
	cQuery += " And SE5.E5_TIPODOC != 'ES' And SE5.E5_TIPODOC != 'E2' And SE5.E5_TIPODOC != 'DC'" 
	cQuery += " And SE5.E5_MOTBX != 'CMP' And SE5.E5_MOTBX != 'CEC'" 
	cQuery += " And SE5.E5_NATUREZ != '91110101' And SE5.E5_NATUREZ != '91110103' And SE5.E5_NATUREZ != '91110104' "
	cQuery += " And SE5.E5_NATUREZ != '91110105' And SE5.E5_NATUREZ != '91130101' And SE5.E5_NATUREZ != '91130102' And SE5.E5_NATUREZ != '21610101'"
	cQuery += "	And SE5.E5_ITEMD BETWEEN '" + cItemDe + "' And '" + cItemAte + "'"
	cQuery += "	And SE5.E5_ITEMC BETWEEN '" + cItemDe + "' And '" + cItemAte + "'"
	cQuery += "	And SE5.E5_CCD BETWEEN '" + cCCDe + "' And '" + cCCAte + "'"
	cQuery += "	And SE5.E5_CCC BETWEEN '" + cCCDe + "' And '" + cCCAte + "'"
	cQuery += "	And SE5.E5_NATUREZ BETWEEN '" + MV_PAR10 + "' And '" + MV_PAR11 + "'"
	cQuery += "	And SE5.E5_CLIFOR BETWEEN '" + MV_PAR03 + "' And '" + MV_PAR04 + "'"
	cQuery += "	And SE5.E5_LOJA BETWEEN '" + MV_PAR05 + "' And '" + MV_PAR06 + "'"

	cQuery := ChangeQuery(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Gerando o arquivo empresa : "+cEmp )
	TCSetField("QRY","E5_DATA","D")

	nTotReg := 0
	QRY->(dbEval({||nTotREG++}))
	QRY->(dbGoTop())

	DbSelectArea("QRY")
	DbGotop()

	ProcRegua(nTotReg)

	While QRY->(!Eof())

		IncProc("Processando o Arquivo de trabalho..Emp: "+cEmp)

		lTemEstorno := .F.

		DbSelectArea("SE5")
		DbSetOrder(7)
		If DbSeek(xFilial("SE5")+QRY->E5_PREFIXO+QRY->E5_NUMERO+QRY->E5_PARCELA+QRY->E5_TIPO+QRY->E5_CLIFOR+QRY->E5_LOJA+QRY->E5_SEQ )

			While SE5->(!Eof()) .And. QRY->E5_PREFIXO+QRY->E5_NUMERO+QRY->E5_PARCELA+QRY->E5_TIPO+QRY->E5_CLIFOR+QRY->E5_LOJA+QRY->E5_SEQ == ;
			SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_SEQ

				If SE5->E5_TIPODOC $ "ES/E2"
					lTemEstorno := .T.
					Exit
				EndIf

				SE5->(DbSkip())

			End

		EndIf

		DbSelectArea("QRY")

		IF lTemEstorno
			DbSelectArea("QRY")
			DbSkip()
			Loop
		EndIf

		/*If QRY->E5_MOTBX $ "CMP/CEC"
			//			IF !"PA" $ QRY->E5_DOCUMEN  //.And. QRY->E5_PREFIXO == "GPE"
			QRY->(DbSkip())
			Loop
			//			EndIf
		EndIf*/

		/*If QRY->E5_TIPODOC $ "ES/E2/DC"
			DbSelectArea("QRY")
			DbSkip()
			Loop
		EndIf*/

		//Ira desprezar as movimentacoes destas naturezas    
		/*If Alltrim(QRY->E5_NATUREZ) $ "91110101,91130101,91110103"
			DbSelectArea("QRY")
			DbSkip()
			loop
		EndIf*/

		//Verifica as naturezas 
		/*If QRY->E5_NATUREZ < MV_PAR10 .Or. QRY->E5_NATUREZ > MV_PAR11
			DbSelectArea("QRY")
			DbSkip()
			loop
		EndIf*/

		//Verifica os Codigos de clientes e fornecedores
		/*If QRY->E5_CLIFOR < MV_PAR03 .Or. QRY->E5_CLIFOR > MV_PAR04
			DbSelectArea("QRY")
			DbSkip()
			loop
		EndIf*/

		//Verifica os Codigos de clientes e fornecedores
		/*If QRY->E5_LOJA < MV_PAR05 .Or. QRY->E5_LOJA > MV_PAR04
			DbSelectArea("QRY")
			DbSkip()
			loop
		EndIf*/

		If QRY->E5_MOEDA == "01"

			If QRY->E5_RECPAG == "R"

				SA1->(DbSetOrder(1))
				SA1->(DbSeek(xFilial("SA1")+QRY->E5_CLIFOR+QRY->E5_LOJA ))

				cNome := SA1->A1_NOME

				DbSelectArea("SD2")
				DbSetOrder(3)

				If ! DbSeek(xFilial("SD2")+QRY->E5_NUMERO+QRY->E5_PREFIXO )

					DbSelectArea("TRB")
					RecLock("TRB",.T.)
					TRB->DOC      := QRY->E5_NUMERO 
					TRB->CC       := QRY->E5_CCD
					TRB->ITEM     := QRY->E5_ITEMD
					TRB->DESC     := Posicione("CTT",1,xFilial("CTT")+QRY->E5_CCD,"CTT_DESC01")
					TRB->DTDIGIT  := QRY->E5_DATA
					TRB->TOTAL    := QRY->E5_VALOR
					TRB->NOME     := cNome
					TRB->FORNECE  := QRY->E5_CLIFOR
					TRB->LOJA     := QRY->E5_LOJA
					TRB->DTVENCTO := QRY->E5_DATA
					TRB->EMPRESA  := SM0->M0_CODIGO
					TRB->NATUREZ  := QRY->E5_NATUREZ
					TRB->RECPAG   := QRY->E5_RECPAG
					TRB->HISTOR   := QRY->E5_HISTOR
					TRB->BANCO    := QRY->E5_BANCO
					TRB->AGENCIA  := QRY->E5_AGENCIA
					TRB->CONTA    := QRY->E5_CONTA
					TRB->TIPO     := QRY->E5_TIPO 	
					TRB->DOCUMEN  := QRY->E5_DOCUMEN 
					TRB->PREFIXO  := QRY->E5_PREFIXO
					TRB->PARCELA  := QRY->E5_PARCELA

					MsUnlock()

				Else

					SC6->(DbSetOrder(1))
					SC6->(DbSeek(xFilial("SC6")+SD2->D2_PEDIDO ))

					DbSelectArea("TRB")
					RecLock("TRB",.T.)
					TRB->DOC      := SD2->D2_DOC
					TRB->CC       := SC6->C6_CC
					TRB->ITEM     := QRY->E5_ITEMD
					TRB->DESC     := Posicione("CTT",1,xFilial("CTT")+SC6->C6_CC,"CTT_DESC01")
					TRB->DTDIGIT  := SD2->D2_EMISSAO
					TRB->VALIPI   := SD2->D2_VALIPI
					TRB->TOTAL    := QRY->E5_VALOR
					TRB->NOME     := cNome
					TRB->FORNECE  := SD2->D2_CLIENTE
					TRB->LOJA     := SD2->D2_LOJA
					TRB->DTVENCTO := QRY->E5_DATA
					TRB->EMPRESA  := SM0->M0_CODIGO
					TRB->NATUREZ  := QRY->E5_NATUREZ
					TRB->RECPAG   := QRY->E5_RECPAG
					TRB->HISTOR   := QRY->E5_HISTOR
					TRB->BANCO    := QRY->E5_BANCO
					TRB->AGENCIA  := QRY->E5_AGENCIA
					TRB->CONTA    := QRY->E5_CONTA
					TRB->TIPO     := QRY->E5_TIPO 	
					TRB->DOCUMEN  := QRY->E5_DOCUMEN 
					TRB->PREFIXO  := QRY->E5_PREFIXO
					TRB->PARCELA  := QRY->E5_PARCELA

					MsUnlock()

				EndIf

			Else

				SA2->(DbSetOrder(1))
				SA2->(DbSeek(xFilial("SA2")+QRY->E5_CLIFOR+QRY->E5_LOJA ))

				cNome := SA2->A2_NOME

				//Verifico se a Movimentacao foi estornada


				DbSelectArea("SD1")
				DbSetOrder(1)

				If ! DbSeek(xFilial("SD1")+QRY->E5_NUMERO+QRY->E5_PREFIXO+QRY->E5_CLIFOR+QRY->E5_LOJA )


					If Empty( QRY->E5_CCD )


						DbSelectArea("SE2")
						DbSetOrder(1)
						DbSeek(xFilial("SE2")+QRY->E5_PREFIXO+QRY->E5_NUMERO+QRY->E5_PARCELA+QRY->E5_TIPO+QRY->E5_CLIFOR+QRY->E5_LOJA )

						cTitPai := SE2->E2_TITPAI

						cCCD    := SE2->E2_CCD 

						If  Empty(cCCD) .And. !Empty(cTitPai) 

							DbSeek(xFilial("SE2")+cTitPai  )

						ElseIf Empty(cCCD)


							//Qdo nao tem o titulo pai, busco a primeira parcela 
							DbSeek(xFilial("SE2")+QRY->E5_PREFIXO+QRY->E5_NUMERO+"001"+QRY->E5_TIPO+QRY->E5_CLIFOR+QRY->E5_LOJA )

						EndIf 

						DbSelectArea("TRB")
						RecLock("TRB",.T.)
						TRB->DOC      := QRY->E5_NUMERO
						TRB->CC       := cCCD
						TRB->ITEM     := QRY->E5_ITEMD
						TRB->DESC     := Posicione("CTT",1,xFilial("CTT")+SE2->E2_CCD,"CTT_DESC01")
						TRB->DTDIGIT  := QRY->E5_DATA
						TRB->TOTAL    := QRY->E5_VALOR
						TRB->NOME     := cNome
						TRB->FORNECE  := QRY->E5_CLIFOR
						TRB->LOJA     := QRY->E5_LOJA
						TRB->DTVENCTO := QRY->E5_DATA
						TRB->EMPRESA  := SM0->M0_CODIGO
						TRB->NATUREZ  := QRY->E5_NATUREZ
						TRB->RECPAG   := QRY->E5_RECPAG
						TRB->HISTOR   := QRY->E5_HISTOR
						TRB->BANCO    := QRY->E5_BANCO
						TRB->AGENCIA  := QRY->E5_AGENCIA
						TRB->CONTA    := QRY->E5_CONTA
						TRB->TIPO     := QRY->E5_TIPO 	
						TRB->DOCUMEN  := QRY->E5_DOCUMEN 
						TRB->PREFIXO  := QRY->E5_PREFIXO
						TRB->PARCELA  := QRY->E5_PARCELA

						MsUnlock()

					Else
						DbSelectArea("TRB")
						RecLock("TRB",.T.)
						TRB->DOC      := QRY->E5_NUMERO
						TRB->CC       := QRY->E5_CCD
						TRB->ITEM     := QRY->E5_ITEMD
						TRB->DESC     := Posicione("CTT",1,xFilial("CTT")+QRY->E5_CCD,"CTT_DESC01")
						TRB->DTDIGIT  := QRY->E5_DATA
						TRB->TOTAL    := QRY->E5_VALOR
						TRB->NOME     := cNome
						TRB->FORNECE  := QRY->E5_CLIFOR
						TRB->LOJA     := QRY->E5_LOJA
						TRB->DTVENCTO := QRY->E5_DATA
						TRB->EMPRESA  := SM0->M0_CODIGO
						TRB->NATUREZ  := QRY->E5_NATUREZ
						TRB->RECPAG   := QRY->E5_RECPAG
						TRB->HISTOR   := QRY->E5_HISTOR
						TRB->BANCO    := QRY->E5_BANCO
						TRB->AGENCIA  := QRY->E5_AGENCIA
						TRB->CONTA    := QRY->E5_CONTA
						TRB->TIPO     := QRY->E5_TIPO 	
						TRB->DOCUMEN  := QRY->E5_DOCUMEN 
						TRB->PREFIXO  := QRY->E5_PREFIXO
						TRB->PARCELA  := QRY->E5_PARCELA
						MsUnlock()

					EndIf

				Else

					While SD1->(!Eof()) .And. xFilial("SD1")+QRY->E5_NUMERO+QRY->E5_PREFIXO+QRY->E5_CLIFOR+QRY->E5_LOJA == ;
					SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA

						/*If SD1->D1_ITEMCTA  < cItemDe .Or. SD1->D1_ITEMCTA > cItemAte
							DbSkip()
							loop
						EndIf*/

						/*If SD1->D1_CC  < cCCDe .Or. SD1->D1_CC > cCCAte
							DbSkip()
							loop
						EndIf*/

						SB1->(DbSetOrder(1))
						SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD ))

						DbSelectArea("TRB")
						RecLock("TRB",.T.)
						TRB->DOC      := SD1->D1_DOC
						TRB->CC       := SD1->D1_CC
						TRB->ITEM     := SD1->D1_ITEMCTA
						TRB->DESC     := Posicione("CTT",1,xFilial("CTT")+SD1->D1_CC,"CTT_DESC01")
						TRB->DTDIGIT  := SD1->D1_DTDIGIT
						TRB->VALIPI   := SD1->D1_VALIPI
						nVlrNF        := Posicione("SF1",1,xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA,"F1_VALMERC")
						If QRY->E5_TIPODOC $ "MT,HR"
							TRB->TOTAL    := QRY->E5_VALOR * ( SD1->D1_TOTAL / nVlrNF )
						Else
							TRB->TOTAL    := QRY->E5_VALOR * ( SD1->D1_TOTAL / nVlrNF ) //SD1->D1_TOTAL - QRY->E5_VLDESCO
						EndIf

						TRB->NOME     := cNome
						TRB->FORNECE  := SD1->D1_FORNECE
						TRB->LOJA     := SD1->D1_LOJA
						TRB->DTVENCTO := QRY->E5_DATA
						TRB->EMPRESA  := SM0->M0_CODIGO
						TRB->NATUREZ  := If(!Empty(SB1->B1_NATUREZ),SB1->B1_NATUREZ,QRY->E5_NATUREZ)
						TRB->RECPAG   := QRY->E5_RECPAG
						TRB->HISTOR   := QRY->E5_HISTOR
						TRB->BANCO    := QRY->E5_BANCO
						TRB->AGENCIA  := QRY->E5_AGENCIA
						TRB->CONTA    := QRY->E5_CONTA
						TRB->TIPO     := QRY->E5_TIPO 	
						TRB->DOCUMEN  := QRY->E5_DOCUMEN 
						TRB->PREFIXO  := QRY->E5_PREFIXO
						TRB->PARCELA  := QRY->E5_PARCELA

						MsUnlock()


						DbSelectArea("SD1")
						DbSkip()

					End

				EndIf


			EndIf

		Else

			cNome := QRY->E5_BENEF

			If QRY->E5_RECPAG == "R"

				//Verifica os Centro de Custo    
				/*If QRY->E5_ITEMC  < cItemDe .Or. QRY->E5_ITEMC > cItemAte
					DbSkip()
					loop
				EndIf*/
				                      
				/*If QRY->E5_CCC  < cCCDe .Or. QRY->E5_CCC > cCCAte
					DbSkip()
					loop
				EndIf*/

				DbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->DOC      := QRY->E5_NUMERO
				TRB->CC       := QRY->E5_CCD
				TRB->ITEM     := QRY->E5_ITEMD
				TRB->DESC     := Posicione("CTT",1,xFilial("CTT")+QRY->E5_CCD,"CTT_DESC01")
				TRB->DTDIGIT  := QRY->E5_DATA
				TRB->TOTAL    := QRY->E5_VALOR
				TRB->NOME     := cNome
				TRB->DTVENCTO := QRY->E5_DATA
				TRB->EMPRESA  := SM0->M0_CODIGO
				TRB->NATUREZ  := QRY->E5_NATUREZ
				TRB->RECPAG   := QRY->E5_RECPAG
				TRB->HISTOR   := QRY->E5_HISTOR
				TRB->BANCO    := QRY->E5_BANCO
				TRB->AGENCIA  := QRY->E5_AGENCIA
				TRB->CONTA    := QRY->E5_CONTA
				TRB->TIPO     := QRY->E5_TIPO 	
				TRB->DOCUMEN  := QRY->E5_DOCUMEN 
				TRB->PREFIXO  := QRY->E5_PREFIXO
				TRB->PARCELA  := QRY->E5_PARCELA

				MsUnlock()

			Else
			
				/*If QRY->E5_ITEMD  < cItemDe .Or. QRY->E5_ITEMD > cItemAte
					DbSkip()
					loop
				EndIf*/
				
				//Verifica os Centro de Custo                          
				/*If QRY->E5_CCD  < cCCDe .Or. QRY->E5_CCD > cCCAte
					DbSkip()
					loop
				EndIf*/

				DbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->DOC      := QRY->E5_NUMERO
				TRB->CC       := QRY->E5_CCD
				TRB->ITEM     := QRY->E5_ITEMD
				TRB->DESC     := Posicione("CTT",1,xFilial("CTT")+QRY->E5_CCD,"CTT_DESC01")
				TRB->DTDIGIT  := QRY->E5_DATA
				TRB->TOTAL    := QRY->E5_VALOR
				TRB->NOME     := cNome
				TRB->DTVENCTO := QRY->E5_DATA
				TRB->EMPRESA  := SM0->M0_CODIGO
				TRB->NATUREZ  := QRY->E5_NATUREZ
				TRB->RECPAG   := QRY->E5_RECPAG
				TRB->HISTOR   := QRY->E5_HISTOR
				TRB->BANCO    := QRY->E5_BANCO
				TRB->AGENCIA  := QRY->E5_AGENCIA
				TRB->CONTA    := QRY->E5_CONTA
				TRB->TIPO     := QRY->E5_TIPO 	
				TRB->DOCUMEN  := QRY->E5_DOCUMEN 
				TRB->PREFIXO  := QRY->E5_PREFIXO
				TRB->PARCELA  := QRY->E5_PARCELA

				MsUnlock()

			EndIf

		EndIf


		DbSelectArea("QRY")
		DbSkip()

	End

	QRY->(DbCloseArea())

	(cAliasTrb)->(DbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaArqTmpบAutor  ณCarlos R Moreira    บ Data ณ  15/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria o Arquivo temporari                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriaArqTmp()
	Local aCampos := {}

	AaDd(aCampos,{"OK"       ,"C",  2,0})
	AaDd(aCampos,{"DOC"      ,"C",  9,0})
	AaDd(aCampos,{"CC"       ,"C",  9,0})
	AaDd(aCampos,{"ITEM"     ,"C",  9,0})
	AaDd(aCampos,{"DESC"     ,"C", 20,0})
	AaDd(aCampos,{"DTDIGIT"  ,"D",  8,0})
	AaDd(aCampos,{"VALIPI"   ,"N", 11,2})
	AaDd(aCampos,{"JUROS"    ,"N", 11,2})
	AaDd(aCampos,{"DESCONT"  ,"N", 11,2})
	AaDd(aCampos,{"TOTAL"    ,"N", 17,2})
	AaDd(aCampos,{"NOME"     ,"C", 30,0})
	AaDd(aCampos,{"FORNECE"  ,"C",  6,0})
	AaDd(aCampos,{"LOJA"     ,"C",  2,0})
	AaDd(aCampos,{"DTVENCTO" ,"D",  8,0})
	AaDd(aCampos,{"EMPRESA"  ,"C",  2,0})
	AaDd(aCampos,{"NATUREZ"  ,"C", 10,0})
	AaDd(aCampos,{"RECPAG"   ,"C",  1,0})
	AaDd(aCampos,{"HISTOR"   ,"C", 40,0})
	AaDd(aCampos,{"BANCO"    ,"C",  3,0})
	AaDd(aCampos,{"AGENCIA"  ,"C",  5,0})
	AaDd(aCampos,{"CONTA"    ,"C", 10,0})
	AaDd(aCampos,{"TIPO"     ,"C",  3,0})	
	AaDd(aCampos,{"DOCUMEN"  ,"C", 20,0})
	AaDd(aCampos,{"PREFIXO"  ,"C",  3,0})
	AaDd(aCampos,{"PARCELA"  ,"C",  3,0})

	cArqTmp := CriaTrab(aCampos,.T.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria o arquivo de Trabalhoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	DbUseArea(.T.,,cArqTmp,"TRB",.F.,.F.)
	IndRegua("TRB",cArqTmp,"EMPRESA+DTOS(DTVENCTO)+CC+DOC+FORNECE+LOJA",,,"Selecionando Registros..." )

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

	Local aInfo   :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	aBrowse := {}

	AaDD(aBrowse,{"EMPRESA","","Empresa"})
	AaDD(aBrowse,{"PREFIXO","","Prefixo"})	
	AaDD(aBrowse,{"DOC","","Titulo"})
	AaDD(aBrowse,{"PARCELA","","Parcela"})	
	AaDD(aBrowse,{"TIPO","","Tipo"})	
	AaDD(aBrowse,{"CC","","C.Custo"})
	AaDD(aBrowse,{"ITEM","","Item Cta."})
	AaDD(aBrowse,{"DESC","","Descricao",""})
	AaDD(aBrowse,{"NATUREZ","","Natureza",""})
	AaDD(aBrowse,{"DTDIGIT","","Dt. Entrada",""})
	AaDD(aBrowse,{"DTVENCTO","","Vencimento",""})
	AaDD(aBrowse,{"DESCONT"  ,"","Descontos","@e 999,999.99"})
	AaDD(aBrowse,{"JUROS"   ,"","Juros","@e 999,999.99"})
	AaDD(aBrowse,{"TOTAL"   ,"","Vlr. Total","@e 99,999,999.99"})
	AaDD(aBrowse,{"FORNECE","","Fornecedor",""})
	AaDD(aBrowse,{"LOJA","","Loja",""})
	AaDD(aBrowse,{"NOME","","Razao Social",""})
	AaDD(aBrowse,{"HISTOR","","Historico",""})
	AaDD(aBrowse,{"BANCO","","Banco",""})
	AaDD(aBrowse,{"AGENCIA","","Agencia",""})
	AaDD(aBrowse,{"CONTA","","Conta",""})
	AaDD(aBrowse,{"DOCUMEN","","Documento"})	

	DbSelectArea("TRB")
	DbGoTop()

	cMarca   := GetMark()
	nOpca    :=0
	lInverte := .F.
	oFonte  := TFont():New( "TIMES NEW ROMAN",14.5,22,,.T.,,,,,.F.)

	aCores := {}

	Aadd(aCores, { 'RECPAG = "P"', "BR_PRETO" } )
	Aadd(aCores, { 'RECPAG = "R" ', "BR_AZUL" } )

	//	Aadd(aCores, { 'LIBPED = "P" .And. OPER <> "08"', "BR_LARANJA" } )
	//	Aadd(aCores, { 'LIBPED = "E" .And. OPER <> "08"', "BR_AZUL" } )

	AADD(aObjects,{100,025,.T.,.F.})
	AADD(aObjects,{100,100,.T.,.T.})
	AAdd( aObjects, { 0, 40, .T., .F. } )

	aPosObj:=MsObjSize(aInfo,aObjects)

	DEFINE MSDIALOG oDlg1 TITLE "Consulta Movimentacao Financeira - Periodo" From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
	//ณ arquivo de trabalho "TRB".                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark := MsSelect():New("TRB","","",aBrowse,@lInverte,@cMarca,{aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]},,,,,aCores)  //35,3,213,385

	oMark:bMark := {| | fa060disp(cMarca,lInverte)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

	//@ aPosObj[1,1]+10,aPosObj[1,2]+30 Button "&Excel"    Size 60,15 Action ExpCons() of oDlg1 Pixel //Localiza o Dia

	@ aPosObj[3,1]+10,aPosObj[3,2]+520 Button "&Exp Excel"    Size 60,15 Action ExpCons() of oDlg1 Pixel //Localiza o Dia

	@ aPosObj[3,1]+10,aPosObj[3,2]+585 Button "&Imprimir"    Size 60,15 Action ImpCons() of oDlg1 Pixel //Localiza o Dia

	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||oDlg1:End()},.T.) CENTERED

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
	DEFINE BUTTON RESOURCE "SIMULACAO" OF oBar GROUP ACTION ExpCons() TOOLTIP OemToAnsi("Exporta para Planilha Excel...")    //


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

Static Function ExpCons()
	Private aDadosExcel := {}

	AaDd(aDadosExcel,{ "Empresa",;
	"Tipo",;
	"Vazio",;
	"Valor Total",;
	"Natureza",;
	"Prefixo",;
	"Titulo",;
	"Parcela",;
	"Documento",;
	"Banco",;
	"Agencia",;
	"Conta",;
	"Dt.Entrada",;
	"Vencimento",;
	"Fornecedor",;
	"Loja",;
	"Razao Social",;
	"Historico",;
	"Vlr. Desconto",;
	"Vlr. Juros",;
	"Vazio",;
	"C.Custo",;
	"Item Cta.",;
	"Descricao"  })

	nCol := Len(aDadosExcel[1])

	DbSelectArea("TRB")
	DbGoTop()

	ProcRegua(RecCount())        // Total de Elementos da regua

	While TRB->(!EOF())

		AaDD( aDadosExcel, { TRB->EMPRESA,;
		TRB->TIPO,;
		" " ,;
		Transform(TRB->TOTAL,"@e 99,999,999.99"),;
		TRB->NATUREZ,;
		TRB->PREFIXO,;
		TRB->DOC ,;
		TRB->PARCELA,;
		TRB->DOCUMEN,;
		TRB->BANCO,;
		TRB->AGENCIA,;
		TRB->CONTA,;
		Dtoc(TRB->DTDIGIT) ,;
		Dtoc(TRB->DTVENCTO) ,;
		TRB->FORNECE,;
		TRB->LOJA,;
		TRB->NOME,;
		TRB->HISTOR,;
		Transform(TRB->DESCONT,"@e 999,999.99"),;
		Transform(TRB->JUROS,"@e 999,999.99"),;
		" ",;
		TRB->CC ,;
		TRB->ITEM ,;
		TRB->DESC }  )

		DbSelectArea("TRB")
		DbSkip()

	End

	Processa({||Run_Excel(aDadosExcel,nCol)},"Gerando a Integra็ใo com o Excel...")

	MsgInfo("Exportacao efetuada com sucesso..")

	TRB->(DbGotop())

Return

Static Function Run_Excel(aDadosExcel,nCol)
	LOCAL cDirDocs   := MsDocPath()
	Local aStru		:= {}
	Local cArquivo := CriaTrab(,.F.)
	Local cPath		:= AllTrim(GetTempPath())
	Local oExcelApp
	Local nHandle
	Local cCrLf 	:= Chr(13) + Chr(10)
	Local nX

	ProcRegua(Len(aDaDosExcel))

	nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

	If nHandle > 0


		For nX := 1 to Len(aDadosExcel)

			IncProc("Aguarde! Gerando arquivo de integra็ใo com Excel...") //
			cBuffer := ""
			For nY := 1 to nCol  //Numero de Colunas do Vetor

				cBuffer += aDadosExcel[nX,nY] + ";"

			Next
			fWrite(nHandle, cBuffer+cCrLf ) // Pula linha

		Next

		IncProc("Aguarde! Abrindo o arquivo...") //

		fClose(nHandle)

		CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )

		If ! ApOleClient( 'MsExcel' )
			MsgAlert( 'MsExcel nao instalado' ) //
			Return
		EndIf

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	Else
		MsgAlert( "Falha na cria็ใo do arquivo" ) //
	Endif

Return

Static Function GatIt(cItem)

Local aArea     := GetArea()
Local cCusto    := ""
	
DbSelectArea("CTD")
DbSetOrder(1)

If DbSeek(xFilial("CTD") + cItem)
	cCusto      :=  CTD->CTD_CUSTO
EndIf

RestArea( aArea )

Return cCusto

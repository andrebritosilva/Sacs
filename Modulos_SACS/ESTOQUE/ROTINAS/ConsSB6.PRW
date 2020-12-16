#INCLUDE "RWMAKE.CH"
#Include "Protheus.ch"
#INCLUDE "colors.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConsSB6   บAutor  ณCarlos R. Moreira   บ Data ณ  14/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o Arquivo para Exportar para Planilha de Excel        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ConsSB6()
	Local aSays     := {}
	Local aButtons  := {}
	Local nOpca     := 0
	Local cCadastro := OemToAnsi("Gera o consulta de controle de Terceiros")

	Private  cArqTxt
	Private cPerg := "CONSSB6"

	PutSx1(cPerg,"01","Data Inicial               ?","","","mv_ch1","D",  8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{{"Data Inicial de processamento "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"02","Data Final                 ?","","","mv_ch2","D",  8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{{"Data Final de processamento   "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"03","Cliente ou Fornecedor de   ?","","","mv_ch3","C",  6,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",{{"Cliente Inicial "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"04","Cliente ou Fornecedor Ate  ?","","","mv_ch4","C",  6,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",{{"Cliente Final  "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"05","Loja  De                   ?","","","mv_ch5","C",  2,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",{{"Loja    Inicial "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"06","Loja  Ate                  ?","","","mv_ch6","C",  2,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",{{"Loja    Final  "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"07","Item Inicial               ?","","","mv_ch7","C",  9,0,0,"G","","CTT","","","mv_par07","","","","","","","","","","","","","","","","",{{"Produto Inicial "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"08","Item Final                 ?","","","mv_ch8","C",  9,0,0,"G","","CTT","","","mv_par08","","","","","","","","","","","","","","","","",{{"Produto Final  "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"09","Produto Inicial            ?","","","mv_ch9","C", 15,0,0,"G","","SB1","","","mv_par09","","","","","","","","","","","","","","","","",{{"Data Inicial de processamento "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"10","Produto Final              ?","","","mv_cha","C", 15,0,0,"G","","SB1","","","mv_par10","","","","","","","","","","","","","","","","",{{"Data Final de processamento   "}},{{" "}},{{" "}},"")

	aHelpPor :=	{"Define qual o tipo de movimentacao deseja que seja selecionado"}
	aHelpEsp :=	{}
	aHelpEng :=	{}

	PutSx1( cPerg, 	"11","Tipo de Relatorio      ?"," ?"," ?","mv_chf","N",1,0,1,"C","","","","",;
		"mv_par11","Todos","","","","Em Terceiros","","",;
		"De Terceiros","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

	aHelpPor :=	{"Define se deseja verifcar a movimentacao ja concluida ou a que esteja com saldo"}
	aHelpEsp :=	{}
	aHelpEng :=	{}

	PutSx1( cPerg, 	"12","Tipo de Movimentacao  ?","  ?"," ?","mv_chf","N",1,0,1,"C","","","","",;
		"mv_par12","Todas","","","","Abertas","","",;
		"Encerradas","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

	aHelpPor :=	{"Define se a exportacao de dados sera consolidada entre empresas"}
	aHelpEsp :=	{}
	aHelpEng :=	{}

	PutSx1( cPerg, 	"13","Consolidas as Empresas  ?","Consolidas as Empresas ?","Consolidas as Empresas ?","mv_chf","N",1,0,1,"C","","","","",;
		"mv_par13","Nao","","","","Sim","","",;
		"","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

	Pergunte(cPerg,.F.)

	Aadd(aSays, OemToAnsi(" Este programa ira gerar um consulta com os itens   "))
	Aadd(aSays, OemToAnsi(" da nota fiscal de acordo com parametros selecionados."))

	Aadd(aButtons, { 1, .T., { || nOpca := 1, FechaBatch()  }})
	Aadd(aButtons, { 2, .T., { || FechaBatch() }})
	Aadd(aButtons, { 5, .T., { || Pergunte(cPerg,.T.) }})

	FormBatch(cCadastro, aSays, aButtons)

	If nOpca == 1
	
		If MV_PAR13 == 2
		
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

	Local aNomArq   := {}
	Local aArq      := {{"SB6"," "},{"SB1"," "}}
	Local cCustoIni := GatItem(MV_PAR07)
	Local cCustoFim := GatItem(MV_PAR08)

	cArq   := "sx2"+cEmp+"0"
	cAliasTrb := "sx2trb"

	If Empty(cCustoFim)
		cCustoFim := "ZZZZZ"
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

	cQuery := " SELECT  SB6.B6_CLIFOR, SB6.B6_LOJA, SB6.B6_PRODUTO, SB1.B1_DESC, SB6.B6_LOCAL, SB6.B6_DOC, SB6.B6_SERIE, SB6.B6_EQSERIE, "
	cQuery += "         SB6.B6_TIPO, SB6.B6_IDENT, SB6.B6_PODER3, SB6.B6_DTDIGIT, SB6.B6_TPCF, SB6.B6_QUANT, SB6.B6_SALDO,SB6.B6_CC "
	cQuery += " FROM "+ aArq[Ascan(aArq,{|x|x[1] = "SB6" }),2]+" SB6 "
	cQuery += "    JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SB1" }),2]+" SB1 ON  "
	cQuery += " SB6.B6_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ <> '*' "

	cQuery += " WHERE SB6.D_E_L_E_T_ <> '*'

	cQuery += "	And SB6.B6_DTDIGIT BETWEEN '"+Dtos(MV_PAR01)+"' And '"+Dtos(mv_par02)+"'"

	cQuery += "	And SB6.B6_CLIFOR BETWEEN '"+MV_PAR03+"' And '"+mv_par04+"'"

	cQuery += "	And SB6.B6_PRODUTO BETWEEN '"+MV_PAR09+"' And '"+mv_par10+"'"

	cQuery += "	And SB6.B6_CC BETWEEN '" + cCustoIni + "' And '" + cCustoFim + "'"

	cQuery += " And SB6.B6_PODER3 = 'R' "

	If MV_PAR11 # 1
	
		If MV_PAR11 == 2
			cQuery += " And SB6.B6_TIPO = 'E' "
		Else
			cQuery += " And SB6.B6_TIPO = 'D' "
		EndIf
	
	EndIf

	If MV_PAR12 # 1
	
		If MV_PAR12 == 2
			cQuery += " And SB6.B6_SALDO > 0 "
		Else
			cQuery += " And SB6.B6_SALDO = 0 "
		EndIf
	
	EndIf

	cQuery += " ORDER BY SB6.B6_IDENT

	cQuery := ChangeQuery(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Gerando o arquivo empresa : "+cEmp )
	TCSetField("QRY","B6_DTDIGIT","D")

	nTotReg := 0
	QRY->(dbEval({||nTotREG++}))
	QRY->(dbGoTop())

	DbSelectArea("QRY")
	DbGotop()

	ProcRegua(nTotReg)

	While QRY->(!Eof())
	
		IncProc("Processando o Arquivo de trabalho..Emp: "+cEmp)
	
		If !Empty(QRY->B6_CC)
			cCC := QRY->B6_CC
		Else
			If QRY->B6_TIPO == "E'
				cCC := Posicione("SD2",3,xFilial("SD2")+QRY->B6_DOC+QRY->B6_SERIE,"D2_CCUSTO")
			Else
				cCC := Posicione("SD1",1,xFilial("SD1")+QRY->B6_DOC+QRY->B6_SERIE+QRY->B6_CLIFOR+QRY->B6_LOJA,"D1_CC")
			EndIf
		EndIf

		If QRY->B6_TIPO == "E'
			cItem := Posicione("SD2",3,xFilial("SD2")+QRY->B6_DOC+QRY->B6_SERIE,"D2_ITEMCC")
		Else
			cItem := Posicione("SD1",1,xFilial("SD1")+QRY->B6_DOC+QRY->B6_SERIE+QRY->B6_CLIFOR+QRY->B6_LOJA,"D1_ITEMCTA")
		EndIf
	
		If cItem < MV_PAR07 .Or. cItem > MV_PAR08
			DbSelectArea("QRY")
			DbSkip()
			Loop
		EndIf
	
		DbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->PRODUTO  := QRY->B6_PRODUTO
		If QRY->B6_PODER3 == "D"
			TRB->DESCPRD  := Posicione("SD1",1,xFilial("SD1")+QRY->B6_DOC+QRY->B6_SERIE+QRY->B6_CLIFOR+QRY->B6_LOJA,"D1_DESCR")
		Else
			DbSelectArea("SD2")
			DbSetOrder(3)
			DbSeek(xFilial("SD2")+QRY->B6_DOC+QRY->B6_SERIE )
		
			While SD2->(!Eof()) .And. QRY->B6_DOC+QRY->B6_SERIE == SD2->D2_DOC+SD2->D2_SERIE
		  
				If SD2->D2_IDENTB6 # QRY->B6_IDENT
					DbSkip()
					Loop
				EndIf
		         
				TRB->DESCPRD  := SD2->D2_DESCRI
				Exit
			End
	
		EndIf
	
		If Empty(TRB->DESCPRD)
			TRB->DESCPRD  := Posicione("SB1",1,xFilial("SB1")+QRY->B6_PRODUTO,"B1_DESC")
		EndIf
		TRB->DTDIGIT  := QRY->B6_DTDIGIT
		TRB->TIPO     := QRY->B6_TIPO
		TRB->IDENT    := QRY->B6_IDENT
		TRB->PODER3   := If(QRY->B6_PODER3 == "R","1","2")
		If QRY->B6_TPCF == "C"
			TRB->NOME     := Posicione("SA1",1,xFilial("SA1")+QRY->B6_CLIFOR+QRY->B6_LOJA,"A1_NOME")
		Else
			TRB->NOME     := Posicione("SA2",1,xFilial("SA2")+QRY->B6_CLIFOR+QRY->B6_LOJA,"A2_NOME")
		EndIf
	
		TRB->CLIFOR   := QRY->B6_CLIFOR
		TRB->LOJA     := QRY->B6_LOJA
	
		TRB->DOC      := QRY->B6_DOC
	
		TRB->QUANT    := QRY->B6_QUANT
		TRB->SALDO    := QRY->B6_SALDO
		TRB->EMPRESA  := cEmp
	
		TRB->ITEM     := cItem
		TRB->DESCITEM := Posicione("CTD",1,xFilial("CTD")+TRB->ITEM,"CTD_DESC01")
		TRB->CC       := cCC
		TRB->DESC     := Posicione("CTT",1,xFilial("CTT")+TRB->CC,"CTT_DESC01")
		TRB->EQSERIE  := QRY->B6_EQSERIE
	
		MsUnlock()
	
	//Ira verificar as Devolucoes
		DbSelectArea("SB6")
		DbSetOrder(3)
		DbSeek( xFilial("SB6")+QRY->B6_IDENT )
	
		While SB6->(!Eof()) .And. SB6->B6_IDENT == QRY->B6_IDENT
		
			If SB6->B6_PODER3 == "R"
				DbSkip()
				Loop
			EndIf
		
			If SB6->B6_TIPO == "E'
				cCC := SB6->B6_CC  //Posicione("SD2",3,xFilial("SD2")+QRY->B6_DOC+QRY->B6_SERIE,"D2_CCUSTO")
			Else
				cCC := SB6->B6_CC //Posicione("SD1",1,xFilial("SD1")+QRY->B6_DOC+QRY->B6_SERIE+QRY->B6_CLIFOR+QRY->B6_LOJA,"D1_CC")
			EndIf

			If SB6->B6_TIPO == "E'
				cItem := Posicione("SD2",3,xFilial("SD2")+QRY->B6_DOC+QRY->B6_SERIE,"D2_ITEMCC")
			Else
				cItem := Posicione("SD1",1,xFilial("SD1")+QRY->B6_DOC+QRY->B6_SERIE+QRY->B6_CLIFOR+QRY->B6_LOJA,"D1_ITEMCTA")
			EndIf
		
			If cItem < MV_PAR07 .Or. cItem > MV_PAR08
				DbSelectArea("SB6")
				DbSkip()
				Loop
			EndIf
		
		
			DbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->PRODUTO  := SB6->B6_PRODUTO
			If SB6->B6_PODER3 == "D"
				TRB->DESCPRD  := Posicione("SD1",1,xFilial("SD1")+SB6->B6_DOC+SB6->B6_SERIE+SB6->B6_CLIFOR+SB6->B6_LOJA,"D1_DESCR")
			Else
				TRB->DESCPRD  := Posicione("SD2",3,xFilial("SD2")+SB6->B6_DOC+SB6->B6_SERIE,"D2_DESCRI")
			EndIf
		
			TRB->DESCPRD  := Posicione("SD1",1,xFilial("SD1")+SB6->B6_DOC+SB6->B6_SERIE+QRY->B6_CLIFOR+QRY->B6_LOJA,"D1_DESCR")
			If Empty(TRB->DESCPRD)
				TRB->DESCPRD  := Posicione("SB1",1,xFilial("SB1")+QRY->B6_PRODUTO,"B1_DESC")
			EndIf
			TRB->DTDIGIT  := SB6->B6_DTDIGIT
			TRB->TIPO     := SB6->B6_TIPO
			TRB->IDENT    := SB6->B6_IDENT
			TRB->PODER3   := If(SB6->B6_PODER3 == "R","1","2")
			If QRY->B6_TPCF == "C"
				TRB->NOME     := Posicione("SA1",1,xFilial("SA1")+SB6->B6_CLIFOR+SB6->B6_LOJA,"A1_NOME")
			Else
				TRB->NOME     := Posicione("SA2",1,xFilial("SA2")+SB6->B6_CLIFOR+SB6->B6_LOJA,"A2_NOME")
			EndIf
		
			TRB->CLIFOR   := SB6->B6_CLIFOR
			TRB->LOJA     := SB6->B6_LOJA
		
			TRB->DOC      := SB6->B6_DOC
		
			TRB->QUANT    := SB6->B6_QUANT
			TRB->SALDO    := SB6->B6_SALDO
			TRB->EMPRESA  := cEmp
			TRB->ITEM     := cItem
			TRB->DESCITEM := Posicione("CTD",1,xFilial("CTD")+TRB->ITEM,"CTD_DESC01")
			TRB->CC       := cCC
			TRB->DESC     := Posicione("CTT",1,xFilial("CTT")+TRB->CC,"CTT_DESC01")
			
		
			MsUnlock()
		
			DbSelectArea("SB6")
			DbSkip()
		End
	
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
	AaDD(aBrowse,{"ITEM","","Item Ctb."})
	AaDD(aBrowse,{"DESCITEM","","Descricao",""})
	AaDD(aBrowse,{"CC","","C.Custo"})
	AaDD(aBrowse,{"DESC","","Descricao",""})
	AaDD(aBrowse,{"DTDIGIT","","Dt. Entrada",""})

	AaDD(aBrowse,{"TIPO","","Tipo",""})
	AaDD(aBrowse,{"PRODUTO","","Produto",""})
	AaDD(aBrowse,{"DESCPRD","","Descricao",""})

	AaDD(aBrowse,{"PODER3","","Tp Mov",""})

	AaDD(aBrowse,{"CLIFOR","","Cliente / Fornecedor",""})
	AaDD(aBrowse,{"LOJA","","Loja",""})
	AaDD(aBrowse,{"NOME","","Razao Social",""})
	AaDD(aBrowse,{"DOC","","Documento",""})
	AaDD(aBrowse,{"QUANT"   ,"","Quantidade","@e 999,999.99"})
	AaDD(aBrowse,{"SALDO"   ,"","Saldo","@e 99,999,999.99"})

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

	AADD(aObjects,{100,025,.T.,.F.})
	AADD(aObjects,{100,100,.T.,.T.})
	AAdd( aObjects, { 0, 40, .T., .F. } )

	aPosObj:=MsObjSize(aInfo,aObjects)

	DEFINE MSDIALOG oDlg1 TITLE "Controle Poder Terceiros" From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
//ณ arquivo de trabalho "TRB".                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark := MsSelect():New("TRB","","",aBrowse,@lInverte,@cMarca,{aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]})  //35,3,213,385

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
	    "Item Ctb.",;
		"Descricao",;
        "C.Custo",;
		"Descricao",;
		"Dt.Movimentacao",;
		"Tipo",;
		"Produto",;
		"Descricao",;
		"Serie Eq",;
		"Clien/Forn",;
		"Loja",;
		"Razao Social",;
		"Documento",;
		"Mov",;
		"Quantidade",;
		"Saldo" })


	nCol := Len(aDadosExcel[1])

	DbSelectArea("TRB")
	DbGoTop()

	ProcRegua(RecCount())        // Total de Elementos da regua

	While TRB->(!EOF())
	
		AaDD( aDadosExcel, { TRB->EMPRESA,;
			TRB->ITEM,;
			TRB->DESCITEM,;
			TRB->CC,;
			TRB->DESC,;
			Dtoc(TRB->DTDIGIT) ,;
			TRB->TIPO,;
			TRB->PRODUTO,;
			TRB->DESCPRD,;
			TRB->EQSERIE,;
			TRB->CLIFOR,;
			TRB->LOJA,;
			TRB->NOME,;
			TRB->DOC,;
			IF(TRB->PODER3=="1","Remessa","Devolucao"),;
			Transform(TRB->QUANT,"@e 999,999.99"),;
			Transform(TRB->SALDO,"@e 99,999,999.99") }  )
	
		DbSelectArea("TRB")
		DbSkip()  
	
	End

	Processa({||Run_Excel(aDadosExcel,nCol)},"Gerando a Integra็ใo com o Excel...")

	MsgInfo("Exportacao efetuada com sucesso.")

	TRB->(DbGotop())

Return

Static Function Run_Excel(aDadosExcel,nCol)
	LOCAL cDirDocs  := MsDocPath()
	Local aStru		:= {}
	Local cArquivo  := CriaTrab(,.F.)
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONSSD1   บAutor  ณMicrosiga           บ Data ณ  05/13/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
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
	AaDd(aCampos,{"ITEM"     ,"C",  9,0})
	AaDd(aCampos,{"DESCITEM" ,"C", 20,0})
	AaDd(aCampos,{"CC"       ,"C",  9,0})
	AaDd(aCampos,{"DESC"     ,"C", 20,0})
	AaDd(aCampos,{"DTDIGIT"  ,"D",  8,0})

	AaDd(aCampos,{"TIPO"     ,"C", 1,0})
	AaDd(aCampos,{"IDENT"    ,"C", 6,0})
	AaDd(aCampos,{"PODER3"   ,"C", 1,0})

	AaDd(aCampos,{"DOC"      ,"C", 9,0})

	AaDd(aCampos,{"PRODUTO"  ,"C", 15,0})
	AaDd(aCampos,{"DESCPRD"  ,"C", 50,0})
                                     
	AaDd(aCampos,{"EQSERIE"  ,"C", 20,0})

	AaDd(aCampos,{"QUANT"    ,"N", 17,2})
	AaDd(aCampos,{"SALDO"    ,"N", 17,2})

	AaDd(aCampos,{"CLIFOR"   ,"C",  6,0})
	AaDd(aCampos,{"LOJA"     ,"C",  3,0})
	AaDd(aCampos,{"NOME"     ,"C", 30,0})

	AaDd(aCampos,{"EMPRESA"  ,"C",  2,0})

	cArqTmp := CriaTrab(aCampos,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria o arquivo de Trabalhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	DbUseArea(.T.,,cArqTmp,"TRB",.F.,.F.)
	IndRegua("TRB",cArqTmp,"EMPRESA+CC+CLIFOR+LOJA+IDENT+PODER3",,,"Selecionando Registros..." )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpCons   บAutor  ณCarlos R Moreira    บ Data ณ  05/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณimprime o relatorio referente a consulta                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpCons()
	Local oPrn
	Private oFont, cCode

	oFont  :=  TFont():New( "Arial",,15,,.T.,,,,,.F. )
	oFont3 :=  TFont():New( "Arial",,12,,.t.,,,,,.f. )
	oFont12:=  TFont():New( "Arial",,10,,.t.,,,,,.f. )
	oFont5 :=  TFont():New( "Arial",,10,,.f.,,,,,.f. )
	oFont9 :=  TFont():New( "Arial",, 8,,.T.,,,,,.f. )
	oArialNeg04 :=  TFont():New( "Arial",, 4,,.T.,,,,,.f. )
	oArialNeg05 :=  TFont():New( "Arial",, 5,,.T.,,,,,.f. )
	oArialNeg06 :=  TFont():New( "Arial",, 6,,.T.,,,,,.f. )
	oArialNeg07 :=  TFont():New( "Arial",, 7,,.T.,,,,,.f. )

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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria Indice para Gerar o Romaneio                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//cNomArq  := CriaTrab(nil,.f.)
//IndRegua("TRB",cNomArq,"ROMANEI+PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//

	nTipoRel := Escolha()

	oPrn := TMSPrinter():New()

	oPrn:Setup()

//oPrn:SetPortrait()
	oPrn:SetPaperSize(9)
	oPrn:SetLandscape()

	lFirst := .t.
	lPri := .T.
	nPag := 0
	nLin := 490

	If nTipoRel == 1
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice para Gerar o relatorio                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cNomArq  := CriaTrab(nil,.f.)
		IndRegua("TRB",cNomArq,"CLIFOR+LOJA+IDENT+PODER3",,,OemToAnsi("Selecionando Registros..."))	//
	
	
		DbSelectArea("TRB")
		DbGotop()
	
		ProcRegua(RecCount())        // Total de Elementos da regua
	
		While TRB->(!EOF())
		
		
			If lFirst
				oPrn:StartPage()
				cTitulo := "Relatorio de Poder de Terceiros - Cliente / Fornecedor"
				cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
				cNomEmp := SM0->M0_NOMECOM
				aTit    := {cTitulo,cNomEmp,cRod}
				nPag++
				U_CabRel(aTit,1,oPrn,nPag,"")
			
				CabCons(oPrn,nTipoRel)
			
				lFirst = .F.
			
			EndIf
		
			lPri := .T.
			cCLIFOR := TRB->CLIFOR
			cIdent  := TRB->IDENT
		
			While TRB->(!Eof()) .And. cCliFor == TRB->CLIFOR //.And. cIdent = TRB->IDENT
			
				oPrn:Box(nLin,100,nLin+60,3300)
			
				oPrn:line(nLin, 250,nLin+60, 250)
				oPrn:line(nLin, 350,nLin+60, 350)
				oPrn:line(nLin, 900,nLin+60, 900)
				oPrn:line(nLin,1050,nLin+60,1050)
				oPrn:line(nLin,2000,nLin+60,2000)
				oPrn:line(nLin,2200,nLin+60,2200)
				oPrn:line(nLin,2300,nLin+60,2300)
//	oPrn:line(nLin,2400,nLin+60,2400)	
				oPrn:line(nLin,2550,nLin+60,2550)
				oPrn:line(nLin,2600,nLin+60,2600)
				oPrn:line(nLin,2750,nLin+60,2750)
				oPrn:line(nLin,2900,nLin+60,2900)
				oPrn:line(nLin,3100,nLin+60,3100)
			
				If lPri
					oPrn:Say(nLin+10,  110,TRB->CLIFOR     ,oFont9 ,100)
					oPrn:Say(nLin+10,  260,TRB->LOJA       ,oFont9 ,100)
					oPrn:Say(nLin+10,  360,TRB->NOME        ,oArialNeg06 ,100)
					lPri := .F.
				EndIf
			
				oPrn:Say(nLin+10,  910,TRB->PRODUTO  ,oArialNeg06 ,100)
				oPrn:Say(nLin+10, 1060,TRB->DESCPRD  ,oArialNeg06 ,100)
				oPrn:Say(nLin+10, 2010,Substr(TRB->EQSERIE,1,10)  ,oArialNeg04 ,100)
						oPrn:Say(nLin+10, 2210,TRB->ITEM    ,oFont9 ,100)
				oPrn:Say(nLin+10, 2305,Substr(TRB->DESCITEM,1,10) ,oArialNeg06 ,100)
				oPrn:Say(nLin+10, 2210,TRB->CC     ,oFont9 ,100)
				oPrn:Say(nLin+10, 2305,Substr(TRB->DESC,1,10) ,oArialNeg06 ,100)
		
				oPrn:Say(nLin+10, 2560,IF(TRB->PODER3=="1","R","D") ,oFont9 ,100)
				oPrn:Say(nLin+10, 2610,TRB->DOC  ,oArialNeg06 ,100)
				oPrn:Say(nLin+10, 2760,Dtoc(TRB->DTDIGIT)   ,oArialNeg06 ,100)
				oPrn:Say(nLin+10, 2910,Transform(TRB->QUANT,"@e 999,999,999.99" ) ,oFont9 ,100)
				oPrn:Say(nLin+10, 3110,Transform(TRB->SALDO,"@e 999,999,999.99" ) ,oFont9 ,100)
			
				nLin += 60
			
				If nLin > 2200
					oPrn:EndPage()
				
					oPrn:StartPage()
					cTitulo := "Relatorio de Poder de Terceiros - Clientes / Fornecedores "
					cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
					cNomEmp := SM0->M0_NOMECOM
					aTit    := {cTitulo,cNomEmp,cRod}
					nPag++
					U_CabRel(aTit,1,oPrn,nPag,"")
				
					CabCons(oPrn,nTipoRel)
				
				EndIf
			
				DbSelectArea("TRB")
				DbSkip()
			
			End
		
			nLin += 20
		
		End
	
	ElseIf nTipoRel == 2
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice para Gerar o relatorio                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cNomArq  := CriaTrab(nil,.f.)
		IndRegua("TRB",cNomArq,"PRODUTO+IDENT+PODER3",,,OemToAnsi("Selecionando Registros..."))	//
	
		DbSelectArea("TRB")
		DbGotop()
	
		ProcRegua(RecCount())        // Total de Elementos da regua
	
		While TRB->(!EOF())
		
		
			If lFirst
				oPrn:StartPage()
				cTitulo := "Relatorio de Poder de Terceiros - Produtos"
				cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
				cNomEmp := SM0->M0_NOMECOM
				aTit    := {cTitulo,cNomEmp,cRod}
				nPag++
				U_CabRel(aTit,1,oPrn,nPag,"")
			
				CabCons(oPrn,nTipoRel)
			
				lFirst = .F.
			
			EndIf
		
			lPri := .T.
			cProduto := TRB->PRODUTO
			cIdent   := TRB->IDENT
		
			While TRB->(!Eof()) .And. cProduto == TRB->PRODUTO .And. cIdent == TRB->IDENT
			
				oPrn:Box(nLin,100,nLin+60,3300)
			
				oPrn:line(nLin, 250,nLin+60, 250)
//				oPrn:line(nLin, 700,nLin+60, 700)
				oPrn:line(nLin, 900,nLin+60, 900)
				oPrn:line(nLin,1100,nLin+60,1100)
				oPrn:line(nLin,1200,nLin+60,1200)
				oPrn:line(nLin,1700,nLin+60,1700)
				oPrn:line(nLin,1900,nLin+60,1900)
				oPrn:line(nLin,2400,nLin+60,2400)
				oPrn:line(nLin,2550,nLin+60,2550)
				oPrn:line(nLin,2600,nLin+60,2600)
				oPrn:line(nLin,2750,nLin+60,2750)
				oPrn:line(nLin,2900,nLin+60,2900)
				oPrn:line(nLin,3100,nLin+60,3100)
			
				If lPri
					oPrn:Say(nLin+10,  110,TRB->PRODUTO  ,oArialNeg07 ,100)
					oPrn:Say(nLin+10,  260,TRB->DESCPRD  ,oArialNeg07 ,100)
					lPri := .F.
				EndIf
			
//				oPrn:Say(nLin+10,  710,TRB->EQSERIE  ,oArialNeg07 ,100)
				oPrn:Say(nLin+10,  920,TRB->CLIFOR   ,oArialNeg07 ,100)
				oPrn:Say(nLin+10, 1120,TRB->LOJA     ,oArialNeg07 ,100)
				oPrn:Say(nLin+10, 1220,TRB->NOME     ,oArialNeg07 ,100)
			
				oPrn:Say(nLin+10, 1710,TRB->ITEM    ,oFont9 ,100)
				oPrn:Say(nLin+10, 1910,TRB->DESCITEM   ,oFont9 ,100)
				oPrn:Say(nLin+10, 1710,TRB->CC     ,oFont9 ,100)
				oPrn:Say(nLin+10, 1910,TRB->DESC   ,oFont9 ,100)
				oPrn:Say(nLin+10, 2410,TRB->EQSERIE  ,oArialNeg07 ,100)				
				oPrn:Say(nLin+10, 2560,IF(TRB->PODER3=="1","R","D") ,oFont9 ,100)
				oPrn:Say(nLin+10, 2610,TRB->DOC  ,oArialNeg06 ,100)
				oPrn:Say(nLin+10, 2760,Dtoc(TRB->DTDIGIT)   ,oArialNeg06 ,100)
				oPrn:Say(nLin+10, 2910,Transform(TRB->QUANT,"@e 999,999,999.99" ) ,oFont9 ,100)
				oPrn:Say(nLin+10, 3110,Transform(TRB->SALDO,"@e 999,999,999.99" ) ,oFont9 ,100)
			
				nLin += 60
			
				If nLin > 2200
					oPrn:EndPage()
				
					oPrn:StartPage()
					cTitulo := "Relatorio de Poder de Terceiros - Produtos "
					cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
					cNomEmp := SM0->M0_NOMECOM
					aTit    := {cTitulo,cNomEmp,cRod}
					nPag++
					U_CabRel(aTit,1,oPrn,nPag,"")
				
					CabCons(oPrn,nTipoRel)
				
				EndIf
			
				DbSelectArea("TRB")
				DbSkip()
			
			End
		
			nLin += 20
		
		End
	
	
	Else
	
		DbSelectArea("TRB")
		DbGotop()
	
		ProcRegua(RecCount())        // Total de Elementos da regua
	
		While TRB->(!EOF())
		
		
			If lFirst
				oPrn:StartPage()
				cTitulo := "Relatorio de Poder de Terceiros - C.Custo "
				cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
				cNomEmp := SM0->M0_NOMECOM
				aTit    := {cTitulo,cNomEmp,cRod}
				nPag++
				U_CabRel(aTit,1,oPrn,nPag,"")
			
				CabCons(oPrn,3)
			
				lFirst = .F.
			
			EndIf
		
			lPri := .T.
			cCC    := TRB->CC
			cIdent := TRB->IDENT
		
			While TRB->(!Eof()) .And. cCC == TRB->CC  //.And. cIdent == TRB->IDENT
			
				oPrn:Box(nLin,100,nLin+60,3300)
			
				oPrn:line(nLin, 250,nLin+60, 250)
				oPrn:line(nLin, 600,nLin+60, 600)
				oPrn:line(nLin, 800,nLin+60, 800)
				oPrn:line(nLin, 900,nLin+60, 900)
				oPrn:line(nLin,1500,nLin+60,1500)
				oPrn:line(nLin,1700,nLin+60,1700)
				oPrn:line(nLin,2400,nLin+60,2400)
				oPrn:line(nLin,2550,nLin+60,2550)
				oPrn:line(nLin,2600,nLin+60,2600)
				oPrn:line(nLin,2750,nLin+60,2750)
				oPrn:line(nLin,2900,nLin+60,2900)
				oPrn:line(nLin,3100,nLin+60,3100)
			
				If lPri
					oPrn:Say(nLin+10,  110,TRB->ITEM      ,oFont9 ,100)
					oPrn:Say(nLin+10,  260,TRB->DESCITEM     ,oFont9 ,100)
					oPrn:Say(nLin+10,  110,TRB->CC       ,oFont9 ,100)
					oPrn:Say(nLin+10,  260,TRB->DESC     ,oFont9 ,100)
					lPri := .F.
				EndIf
			
				oPrn:Say(nLin+10,  620,TRB->CLIFOR   ,oFont9 ,100)
				oPrn:Say(nLin+10,  820,TRB->LOJA     ,oFont9 ,100)
				oPrn:Say(nLin+10,  920,TRB->NOME     ,oFont9 ,100)
			
				oPrn:Say(nLin+10, 1510,TRB->PRODUTO  ,oFont9 ,100)
				oPrn:Say(nLin+10, 1710,Substr(TRB->DESCPRD,1,25)   ,oArialNeg06 ,100)
				oPrn:Say(nLin+10, 2410,Substr(TRB->EQSERIE,1,10)   ,oArialNeg04 ,100)
				oPrn:Say(nLin+10, 2560,IF(TRB->PODER3=="1","R","D") ,oFont9 ,100)
				oPrn:Say(nLin+10, 2610,TRB->DOC  ,oArialNeg06 ,100)
				oPrn:Say(nLin+10, 2760,Dtoc(TRB->DTDIGIT)   ,oArialNeg06 ,100)
				oPrn:Say(nLin+10, 2910,Transform(TRB->QUANT,"@e 999,999,999.99" ) ,oFont9 ,100)
				oPrn:Say(nLin+10, 3110,Transform(TRB->SALDO,"@e 999,999,999.99" ) ,oFont9 ,100)
			
				nLin += 60
			
				If nLin > 2200
					oPrn:EndPage()
				
					oPrn:StartPage()
					cTitulo := "Relatorio de Poder de Terceiros - C.Custo"
					cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
					cNomEmp := SM0->M0_NOMECOM
					aTit    := {cTitulo,cNomEmp,cRod}
					nPag++
					U_CabRel(aTit,1,oPrn,nPag,"")
				
					CabCons(oPrn,3)
				
				EndIf
			
				DbSelectArea("TRB")
				DbSkip()
			
			End
		
			nLin += 20
		
		End
	
	EndIf

	If !lFirst
		oPrn:EndPage()
	EndIf

	oPrn:Preview()
	oPrn:End()

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

Static Function CabCons(oPrn,nModo)

	nLin := 320

	oPrn:FillRect({nLin,100,nLin+60,3300},oBrush)

	oPrn:Box(nLin,100,nLin+60,3300)

	If nModo == 1
	
		oPrn:line(nLin, 250,nLin+60, 250)
		oPrn:line(nLin, 350,nLin+60, 350)
		oPrn:line(nLin, 900,nLin+60, 900)
		oPrn:line(nLin,1050,nLin+60,1050)
		oPrn:line(nLin,2000,nLin+60,2000)
		oPrn:line(nLin,2200,nLin+60,2200)
		oPrn:line(nLin,2300,nLin+60,2300)
		oPrn:line(nLin,2550,nLin+60,2550)
		oPrn:line(nLin,2600,nLin+60,2600)
		oPrn:line(nLin,2750,nLin+60,2750)
		oPrn:line(nLin,2900,nLin+60,2900)
		oPrn:line(nLin,3100,nLin+60,3100)
	
		oPrn:Say(nLin+10,  110,"Cli / Forn"   ,oFont5 ,100)
		oPrn:Say(nLin+10,  260,"Loja"         ,oFont5 ,100)
		oPrn:Say(nLin+10,  360,"Nome"         ,oFont5 ,100)
		oPrn:Say(nLin+10,  920,"Produto"      ,oFont5 ,100)
		oPrn:Say(nLin+10, 1120,"Descricao"    ,oFont5 ,100)
		oPrn:Say(nLin+10, 2010,"Serie Equip"  ,oFont5 ,100)
		oPrn:Say(nLin+10, 2210,"C.Custo"      ,oArialNeg05 ,100)
		oPrn:Say(nLin+10, 2310,"Descricao"    ,oFont5 ,100)
		oPrn:Say(nLin+10, 2560,"Mov"         ,oArialNeg06 ,100)
		oPrn:Say(nLin+10, 2610,"Docum"    ,oFont5 ,100)
		oPrn:Say(nLin+10, 2760,"Dt Movim"    ,oFont5 ,100)
		oPrn:Say(nLin+10, 2910,"Quantidade"   ,oFont5 ,100)
		oPrn:Say(nLin+10, 3110,"Saldo"        ,oFont5 ,100)
	
	ElseIf nModo == 2
	
		oPrn:line(nLin, 250,nLin+60, 250)
		oPrn:line(nLin, 900,nLin+60, 900)
		oPrn:line(nLin,1100,nLin+60,1100)
		oPrn:line(nLin,1200,nLin+60,1200)
		oPrn:line(nLin,1700,nLin+60,1700)
		oPrn:line(nLin,1900,nLin+60,1900)
		oPrn:line(nLin,2400,nLin+60,2400)
		oPrn:line(nLin,2550,nLin+60,2550)
		oPrn:line(nLin,2600,nLin+60,2600)
		oPrn:line(nLin,2750,nLin+60,2750)
		oPrn:line(nLin,2900,nLin+60,2900)
		oPrn:line(nLin,3100,nLin+60,3100)
	
		oPrn:Say(nLin+10,  110,"Produto"      ,oFont5 ,100)
		oPrn:Say(nLin+10,  260,"Descricao"    ,oFont5 ,100)
		oPrn:Say(nLin+10,  930,"Cli / Forn"   ,oFont5 ,100)
		oPrn:Say(nLin+10, 1120,"Loja"         ,oFont5 ,100)
		oPrn:Say(nLin+10, 1220,"Nome"         ,oFont5 ,100)
		oPrn:Say(nLin+10, 1730,"C.Custo"      ,oFont5 ,100)
		oPrn:Say(nLin+10, 1910,"Descricao"    ,oFont5 ,100)
		oPrn:Say(nLin+10, 2410,"Serie Equip"  ,oArialNeg06,100)
		oPrn:Say(nLin+10, 2560,"Mov"         ,oArialNeg06 ,100)
		oPrn:Say(nLin+10, 2610,"Docum"       ,oFont5 ,100)
		oPrn:Say(nLin+10, 2760,"Dt Movim"    ,oFont5 ,100)
		oPrn:Say(nLin+10, 2910,"Quantidade"   ,oFont5 ,100)
		oPrn:Say(nLin+10, 3110,"Saldo"        ,oFont5 ,100)
	
	Else
	
		oPrn:line(nLin, 250,nLin+60, 250)
		oPrn:line(nLin, 600,nLin+60, 600)
		oPrn:line(nLin, 800,nLin+60, 800)
		oPrn:line(nLin, 900,nLin+60, 900)
		oPrn:line(nLin,1500,nLin+60,1500)
		oPrn:line(nLin,1700,nLin+60,1700)
		oPrn:line(nLin,2400,nLin+60,2400)
		oPrn:line(nLin,2550,nLin+60,2550)
		oPrn:line(nLin,2600,nLin+60,2600)
		oPrn:line(nLin,2750,nLin+60,2750)
		oPrn:line(nLin,2900,nLin+60,2900)
		oPrn:line(nLin,3100,nLin+60,3100)
	
		oPrn:Say(nLin+10,  110,"C.Custo"     ,oFont5 ,100)
		oPrn:Say(nLin+10,  360,"Descricao"   ,oFont5 ,100)
		oPrn:Say(nLin+10,  630,"Cli / Forn"  ,oFont5 ,100)
		oPrn:Say(nLin+10,  820,"Loja"        ,oFont5 ,100)
		oPrn:Say(nLin+10,  920,"Nome"        ,oFont5 ,100)
		oPrn:Say(nLin+10, 1530,"Produto"     ,oFont5 ,100)
		oPrn:Say(nLin+10, 1710,"Descricao"   ,oFont5 ,100)
		oPrn:Say(nLin+10, 2410,"Serie Equip" ,oArialNeg06 ,100)
		oPrn:Say(nLin+10, 2560,"Mov"         ,oArialNeg06 ,100)
		oPrn:Say(nLin+10, 2610,"Docum"    ,oFont5 ,100)
		oPrn:Say(nLin+10, 2760,"Dt Movim"    ,oFont5 ,100)
		oPrn:Say(nLin+10, 2910,"Quantidade"   ,oFont5 ,100)
		oPrn:Say(nLin+10, 3110,"Saldo"        ,oFont5 ,100)
	
	EndIf
	nLin += 60

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEscolha   บAutor  ณCarlos R. Moreira   บ Data ณ  09/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSeleciona a Opcao desejada                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Escolha()
	Local oDlg2
	Private nRadio := 1
	Private oRadio

	@ 0,0 TO 200,250 DIALOG oDlg2 TITLE "Modelo de Relatorio"

	@ 05,05 TO 67,120 TITLE "Selecione o Tipo"
	@ 23,30 RADIO oRadio Var nRadio Items "Clien/Fornecedor","Produto","C.Custo" 3D SIZE 60,10 of oDlg2 Pixel

	@ 080,075 BMPBUTTON TYPE 1 ACTION Close(oDlg2)
	ACTIVATE DIALOG oDlg2 CENTER

Return nRadio

Static Function GatItem(cItem)

Local aArea     := GetArea()
Local cCusto    := ""
	
DbSelectArea("CTD")
DbSetOrder(1)

If DbSeek(xFilial("CTD") + cItem)
	cCusto      :=  CTD->CTD_CUSTO
EndIf

RestArea( aArea )

Return cCusto

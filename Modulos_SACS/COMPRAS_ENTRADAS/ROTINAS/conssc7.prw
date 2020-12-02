#INCLUDE "RWMAKE.CH"
#Include "Protheus.ch"
#INCLUDE "colors.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConsSD1   บAutor  ณCarlos R. Moreira   บ Data ณ  26/05/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o Arquivo para Exportar para Planilha de Excel        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ConsSC7()
	Local aSays     := {}
	Local aButtons  := {}
	Local nOpca     := 0
	Local cCadastro := OemToAnsi("Gera o consulta por Item Cont. x C.Custo dos Pedidos Compras")

	Private  cArqTxt
	Private cPerg := "CONSSC7"

	PutSx1(cPerg,"01","Data Inicial               ?","","","mv_ch1","D",  8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{{"Data Inicial de processamento "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"02","Data Final                 ?","","","mv_ch2","D",  8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{{"Data Final de processamento   "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"03","Fornecedor de              ?","","","mv_ch3","C",  6,0,0,"G","SA2","","","","mv_par03","","","","","","","","","","","","","","","","",{{"Cliente Inicial "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"04","Fornecedor Ate             ?","","","mv_ch4","C",  6,0,0,"G","SA2","","","","mv_par04","","","","","","","","","","","","","","","","",{{"Cliente Final  "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"05","Loja  De                   ?","","","mv_ch5","C",  2,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",{{"Loja    Inicial "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"06","Loja  Ate                  ?","","","mv_ch6","C",  2,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",{{"Loja    Final  "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"07","CC Inicial                 ?","","","mv_ch7","C",  9,0,0,"G","CTT","","","","mv_par07","","","","","","","","","","","","","","","","",{{"Produto Inicial "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"08","CC Final                   ?","","","mv_ch8","C",  9,0,0,"G","CTT","","","","mv_par08","","","","","","","","","","","","","","","","",{{"Produto Final  "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"09","Produto    Inicial         ?","","","mv_ch9","D",  8,0,0,"G","SB1","",   "","","mv_par09","","","","","","","","","","","","","","","","",{{"Data Inicial de processamento "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"10","Produto    Final           ?","","","mv_cha","D",  8,0,0,"G","SB1","",   "","","mv_par10","","","","","","","","","","","","","","","","",{{"Data Final de processamento   "}},{{" "}},{{" "}},"")

	aHelpPor :=	{"Define se a exportacao de dados sera consolidada entre empresas"}
	aHelpEsp :=	{}
	aHelpEng :=	{}

	PutSx1( cPerg, 	"11","Consolidas as Empresas  ?","Consolidas as Empresas ?","Consolidas as Empresas ?","mv_chf","N",1,0,1,"C","","","","",;
		"mv_par11","Nao","","","","Sim","","",;
		"","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

	aHelpPor :=	{"Define se o relatorio tem que filtrar os titulos ja baixados"}
	aHelpEsp :=	{}
	aHelpEng :=	{}

	PutSx1( cPerg, 	"12","Posicao dos Pedidos ?"," "," ","mv_chf","N",1,0,1,"C","","","","",;
		"mv_par12","Todos","","","","Abertos","","",;
		"Atendidos","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

	PutSx1(cPerg,"13","Pedido  Inicial         ?","","","mv_ch9","C",  6,0,0,"G","SC7","",   "","","mv_par13","","","","","","","","","","","","","","","","",{{"Data Inicial de processamento "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"14","Pedido  Final           ?","","","mv_cha","C",  6,0,0,"G","SC7","",   "","","mv_par14","","","","","","","","","","","","","","","","",{{"Data Final de processamento   "}},{{" "}},{{" "}},"")

	aHelpPor :=	{"Define se o usuario quer ver somente os pedidos de caixa"}
	aHelpEsp :=	{}
	aHelpEng :=	{}

	PutSx1( cPerg, 	"15","Quais tipo de Pedidos   ?","Consolidas as Empresas ?","Consolidas as Empresas ?","mv_chf","N",1,0,1,"C","","","","",;
		"mv_par15","Todos","","","","Caixas","","",;
		"Outros","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)


	Pergunte(cPerg,.F.)

	Aadd(aSays, OemToAnsi(" Este programa ira gerar uma consulta com os pedidos  "))
	Aadd(aSays, OemToAnsi(" de compra de acordo com parametros selecionados."))

	Aadd(aButtons, { 1, .T., { || nOpca := 1, FechaBatch()  }})
	Aadd(aButtons, { 2, .T., { || FechaBatch() }})
	Aadd(aButtons, { 5, .T., { || Pergunte(cPerg,.T.) }})

	FormBatch(cCadastro, aSays, aButtons)

	If nOpca == 1
	
		If MV_PAR11 == 2
		
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
	Local aNomArq := {}
	Local aArq := {{"SD1"," "},{"SA2"," "},{"CTT"," "},{"SC7"," "},{"CTD"," "}}
	Local cCustoIni := ""
	Local cCustoFim := ""

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

	cQuery := " SELECT  SC7.C7_NUM, SC7.C7_EMISSAO, SC7.C7_CC, SC7.C7_ITEMCTA, SC7.C7_TOTAL, SC7.C7_FORNECE, SC7.C7_LOJA,SC7.C7_OBS, SC7.C7_QTDACLA,  "
	cQuery += "         SC7.C7_VLDESC, SC7.C7_VALIPI,SC7.C7_QUANT, SC7.C7_PRODUTO, SC7.C7_DESCRI,SC7.C7_QUANT, SC7.C7_ENCER, "
	cQuery += "         SC7.C7_USER, SC7.C7_DATPRF, SC7.C7_PRECO, SC7.C7_QUJE,SC7.C7_USER, SC7.C7_RESIDUO, SC7.C7_LOC_ENT, SC7.C7_LOCAL,   "
	
	// renatera
	cQuery += "         SC7.C7_SOLSACS,SC7.C7_DTSOLIC,SC7.C7_DTAPROV, SC7.C7_PLCATV, SC7.C7_MOTIVO,   "   
	
	cQuery += "         ISNULL(SD1.D1_DOC,' ') AS D1_DOC, ISNULL(SD1.D1_VALIPI,0) AS D1_VALIPI, ISNULL(SD1.D1_DTDIGIT,'') AS D1_DTDIGIT, "
	cQuery += "         ISNULL(SD1.D1_IPI,0) AS D1_IPI, ISNULL(SD1.D1_PICM,0) AS D1_PICM,ISNULL(SD1.D1_ALQPIS,0) AS D1_ALQPIS, "
	cQuery += "         ISNULL(SD1.D1_ALQCOF,0) AS D1_ALQCOF,ISNULL(SD1.D1_ALQCSL,0) AS D1_ALQCSL,ISNULL(SD1.D1_ALIQIRR,0) AS D1_ALIQIRR, "
	cQuery += "         ISNULL(SD1.D1_ALIQINS,0) AS D1_ALIQINS,ISNULL(SD1.D1_ALIQISS,0) AS D1_ALIQISS, ISNULL(SD1.D1_ICMSRET,0) AS D1_ICMSRET,"
	cQuery += "         ISNULL(SD1.D1_SERIE,' ') AS D1_SERIE,ISNULL(SD1.D1_QUANT,0) AS D1_QUANT,ISNULL(SD1.D1_TOTAL,0) AS D1_TOTAL,SA2.A2_NOME, CTT.CTT_DESC01, CTD.CTD_DESC01  "

	cQuery += " FROM "+ aArq[Ascan(aArq,{|x|x[1] = "SC7" }),2]+" SC7 "

	cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SA2" }),2]+" SA2 ON "
	cQuery += "     SC7.C7_FORNECE = SA2.A2_COD AND SC7.C7_LOJA = SA2.A2_LOJA AND "
	cQuery += "     SA2.D_E_L_E_T_ <> '*' AND SA2.A2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
	cQuery += "     SA2.A2_LOJA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "

	cQuery += " LEFT OUTER JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SD1" }),2]+" SD1 ON "
	cQuery += "     SC7.C7_NUM = SD1.D1_PEDIDO AND SC7.C7_ITEM = SD1.D1_ITEMPC AND "
	cQuery += "     SD1.D_E_L_E_T_ <> '*' "

	cQuery += " LEFT OUTER JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "CTT" }),2]+" CTT ON "
	cQuery += "     SC7.C7_CC = CTT.CTT_CUSTO  AND "
	cQuery += "     CTT.D_E_L_E_T_ <> '*' "

	cQuery += " LEFT OUTER JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "CTD" }),2]+" CTD ON "
	cQuery += "     SC7.C7_ITEMCTA = CTD.CTD_ITEM  AND "
	cQuery += "     CTD.D_E_L_E_T_ <> '*' "
	
	cQuery += " WHERE SC7.D_E_L_E_T_ <> '*' "
	cQuery += "	And SC7.C7_ITEMCTA  BETWEEN '"+MV_PAR16+"' And '"+mv_par17+"'"
	
	cCustoIni := GatItem(MV_PAR16)
	cCustoFim := GatItem(mv_par17)
	
	If Empty(cCustoIni)
		cCustoIni := MV_PAR07
	EndIf
	
	If Empty(cCustoFim)
		cCustoFim := MV_PAR08
	EndIf
	
	cQuery += "	And SC7.C7_CC  BETWEEN '" + cCustoIni + "' And '" + cCustoFim + "'"
	cQuery += "	And SC7.C7_EMISSAO BETWEEN '" + Dtos(MV_PAR01) + "' And '" + Dtos(mv_par02) + "'"
	cQuery += "	And SC7.C7_PRODUTO BETWEEN '" + MV_PAR09 + "' And '" + mv_par10 + "'"
	cQuery += "	And SC7.C7_NUM  BETWEEN '" + MV_PAR13 + "' And '" + mv_par14 + "'"
	
	If MV_PAR15 # 1
		If MV_PAR15 == 2
			cQuery += " AND SC7.C7_COND = 'CXA' "
		Else
			cQuery += " AND SC7.C7_COND <> 'CXA' "
		EndIf
	EndIf

	cQuery := ChangeQuery(cQuery)

	
	
	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Gerando o arquivo empresa : "+cEmp )
	TCSetField("QRY","C7_EMISSAO","D")
	TCSetField("QRY","C7_DATPRF","D")
	TCSetField("QRY","D1_DTDIGIT","D")
	TCSetField("QRY","C7_DTSOLIC","D")
	TCSetField("QRY","C7_DTAPROV","D")		

	nTotReg := 0
	QRY->(dbEval({||nTotREG++}))
	QRY->(dbGoTop())

	DbSelectArea("QRY")
	DbGotop()

	ProcRegua(nTotReg)
	

	While QRY->(!Eof())
	
		IncProc("Processando o Arquivo de trabalho..Emp: "+cEmp)
	
		If MV_PAR12 # 1
			If MV_PAR12 == 2
				If !Empty(QRY->D1_DOC) .Or.  QRY->C7_RESIDUO  == "S" .Or. QRY->C7_ENCER == "E"
					QRY->(DbSkip())
					Loop
				EndIf
			Else
				If Empty(QRY->D1_DOC)
					QRY->(DbSkip())
					Loop
				EndIf

			EndIf
		EndIf
  
		DbSelectArea("TRB")
		
		RecLock("TRB",.T.)
		TRB->ITEMCTA   := QRY->C7_ITEMCTA
		TRB->DESC_ITEM := QRY->CTD_DESC01
		TRB->CC        := QRY->C7_CC
		TRB->DESC_CC   := QRY->CTT_DESC01
		TRB->DTDIGIT   := QRY->D1_DTDIGIT
		TRB->TOTAL     := QRY->C7_TOTAL  // * nPercDup
		TRB->VALIPI    := QRY->D1_VALIPI
		TRB->NOME      := QRY->A2_NOME
		TRB->FORNECE   := QRY->C7_FORNECE
		TRB->LOJA      := QRY->C7_LOJA
		TRB->DOC       := QRY->D1_DOC
		TRB->EMPRESA   := cEmp
		TRB->PEDIDO    := QRY->C7_NUM
		TRB->EMISSAO   := QRY->C7_EMISSAO
		TRB->STATUS    := If(Empty(QRY->D1_DOC) ,If(QRY->C7_ENCER=="E","E",IF(QRY->C7_RESIDUO=="S","R","A")),"E")
		TRB->VALIPI    := QRY->C7_VALIPI
		TRB->ICMSRET   := QRY->D1_ICMSRET
		TRB->VLDESC    := QRY->C7_VLDESC
		TRB->VALLIQ    := QRY->D1_TOTAL + QRY->D1_VALIPI + QRY->D1_ICMSRET - QRY->C7_VLDESC
		TRB->QUANT     := QRY->C7_QUANT
		TRB->QUJE      := QRY->D1_QUANT 
		TRB->USER      := UsrFullName(QRY->C7_USER)
		TRB->OBS       := QRY->C7_OBS
		TRB->PROD      := QRY->C7_PRODUTO
		TRB->DESC      := QRY->C7_DESCRI
		TRB->RESIDUO   := QRY->C7_RESIDUO
		TRB->ALMOX     := QRY->C7_LOCAL
		TRB->LOC_ENT   := QRY->C7_LOC_ENT
		TRB->PRECO     := ( QRY->C7_TOTAL + QRY->C7_VALIPI + QRY->D1_ICMSRET - QRY->C7_VLDESC ) / QRY->C7_QUANT
		TRB->NCM       := Posicione("SB1",1,xFilial("SB1")+QRY->C7_PRODUTO,"B1_POSIPI")
		TRB->RESPCXA   := Posicione("SF1",1,xFilial("SF1")+QRY->D1_DOC+QRY->D1_SERIE+QRY->C7_FORNECE+QRY->C7_LOJA ,"F1_RESPCXA")
			
		TRB->DTENT    := QRY->C7_DATPRF

		TRB->PERIPI   := QRY->D1_IPI
		TRB->PERICM   := QRY->D1_PICM
		TRB->PERPIS   := QRY->D1_ALQPIS
		TRB->PERCOF   := QRY->D1_ALQCOF
		TRB->PERCSL   := QRY->D1_ALQCSL
	
		TRB->PERINS   := QRY->D1_ALIQINS
		TRB->PERIRF   := QRY->D1_ALIQIRR
		TRB->PERISS   := QRY->D1_ALIQISS

   TRB->SOLSACS  := QRY->C7_SOLSACS
   TRB->DTSOLIC  := QRY->C7_DTSOLIC
   TRB->DTAPROV  := QRY->C7_DTAPROV 
   TRB->PLCATV:= QRY-> C7_PLCATV
   TRB->MOTIVO:= QRY-> C7_MOTIVO
		MsUnlock()
		
//		EndIf
		DbSelectArea("QRY")
		DbSkip()
	
	End

	QRY->(DbCloseArea())

	(cAliasTrb)->(DbCloseArea())

  DbSelectArea("TRB")
		cIndice  := CriaTrab(Nil,.F.)
		IndRegua("TRB",cIndice,"Empresa+Pedido+CC+PROD",,,OemToAnsi("Selecionando Registros..."))	//

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

	If MV_PAR15 # 2
	
		//AaDD(aBrowse,{"TESSSTE","","TESTADO"})
		
		AaDD(aBrowse,{"EMPRESA","","Empresa"})
		
		AaDD(aBrowse,{"ITEMCTA","","Item Cont."})
		AaDD(aBrowse,{"DESC_ITEM","","Descricao",""})
		
		AaDD(aBrowse,{"CC","","C.Custo"})
		AaDD(aBrowse,{"DESC_CC","","Descricao",""})
		
		AaDD(aBrowse,{"SOLSACS","","Solicitacao",""})
		AaDD(aBrowse,{"DTSOLIC","","Dt. Solicitacao",""})
						
		AaDD(aBrowse,{"PEDIDO","","Pedido",""})
		AaDD(aBrowse,{"EMISSAO","","Emissao",""})
		
		AaDD(aBrowse,{"DTAPROV","","Dt Aprovacao",""})
				
		AaDD(aBrowse,{"DTENT","","Dt Entrega",""})
		AaDD(aBrowse,{"USER","","Usuario",""})
		AaDD(aBrowse,{"STATUS","","Status",""})
		AaDD(aBrowse,{"FORNECE","","Fornecedor",""})
		AaDD(aBrowse,{"LOJA","","Loja",""})
		AaDD(aBrowse,{"NOME","","Razao Social",""})
		AaDD(aBrowse,{"PLCATV","","PLCATV",""})
		AaDD(aBrowse,{"MOTIVO","","Motivo",""})

		AaDD(aBrowse,{"PROD","","Produto",""})
		AaDD(aBrowse,{"DESC","","Descricao",""})
		AaDD(aBrowse,{"DOC","","Documento",""})
		AaDD(aBrowse,{"DTDIGIT","","Dt. Entrada",""})

		AaDD(aBrowse,{"QUANT"    ,"","Quantidade","@e 99,999,999.9999"})
		AaDD(aBrowse,{"QUJE"    ,"","Qtde Entregue","@e 99,999,999.9999"})
		AaDD(aBrowse,{"PRECO"    ,"","Preco Unit","@e 99,999,999.99"})
		AaDD(aBrowse,{"TOTAL"    ,"","Vlr. Total","@e 99,999,999.99"})
		AaDD(aBrowse,{"VALIPI"   ,"","Vlr. IPI","@e 999,999.99"})
		AaDD(aBrowse,{"ICMSRET"   ,"","Icms ST","@e 999,999.99"})
		AaDD(aBrowse,{"VLDESC"   ,"","Vl Desconto","@e 999,999.99"})
		AaDD(aBrowse,{"VALLIQ"   ,"","Tota Nota","@e 999,999.99"})

		AaDD(aBrowse,{"RESIDUO","","Residuo",""})
		AaDD(aBrowse,{"OBS","","Observacao",""})

		AaDD(aBrowse,{"ALMOX","","Armazem",""})
		AaDD(aBrowse,{"LOC_ENT","","Local de Entrega",""})
	
	Else
		AaDD(aBrowse,{"ITEMCTA","","Item Cont."})
		AaDD(aBrowse,{"DESC_ITEM","","Descricao Item",""})
		AaDD(aBrowse,{"CC","","C.Custo"})
		AaDD(aBrowse,{"DESC_CC","","Descricao",""})
		AaDD(aBrowse,{"SOLSACS","","Solicitacao",""})
		AaDD(aBrowse,{"DTSOLIC","","Dt. Solicitacao",""})
		AaDD(aBrowse,{"PEDIDO","","Pedido",""})
		AaDD(aBrowse,{"EMISSAO","","Emissao",""})
		AaDD(aBrowse,{"DTAPROV","","Dt Aprovacao",""})
		AaDD(aBrowse,{"DTENT","","Dt Entrega",""})
		AaDD(aBrowse,{"USER","","Usuario",""})
		AaDD(aBrowse,{"STATUS","","Status",""})
		AaDD(aBrowse,{"FORNECE","","Fornecedor",""})
		AaDD(aBrowse,{"LOJA","","Loja",""})
		AaDD(aBrowse,{"NOME","","Razao Social",""})
		AaDD(aBrowse,{"PLCATV","","PLCATV",""})
		AaDD(aBrowse,{"MOTIVO","","Motivo",""})

		AaDD(aBrowse,{"PROD","","Produto",""})
		AaDD(aBrowse,{"DESC","","Descricao",""})
		AaDD(aBrowse,{"DOC","","Documento",""})
		AaDD(aBrowse,{"DTDIGIT","","Dt. Entrada",""})

		AaDD(aBrowse,{"QUANT"    ,"","Quantidade","@e 99,999,999.9999"})
		AaDD(aBrowse,{"QUJE"    ,"","Qtde Entregue","@e 99,999,999.9999"})
		AaDD(aBrowse,{"PRECO"    ,"","Preco Unit","@e 99,999,999.99"})
		AaDD(aBrowse,{"TOTAL"    ,"","Vlr. Total","@e 99,999,999.99"})

		AaDD(aBrowse,{"OBS","","Observacao",""})

		AaDD(aBrowse,{"ALMOX","","Armazem",""})
		AaDD(aBrowse,{"RESPCXA","","Resp. Caixa",""})		
	
	EndIf
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

	DEFINE MSDIALOG oDlg1 TITLE "Consulta Item Cont. x CC - Periodo" From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

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

 If MV_PAR15 # 2
	AaDd(aDadosExcel,{ "Empresa","Item Cont.",;
		"Descricao",;
		"C.Custo",;
		"Descricao",;
		"Num Solic",;
		"Dt. Solic",;
		"Pedido",;
		"Emissao",;
		"Aprovacao",;
		"Dt Entrega",;
		"Dt Entrada",;
		"Usuario",;
		"Status",;
		"Produto",;
		"Descricao",;
		"Armazem",;
		"Qtde Ped",;
		"Qtde Entr",;
		"Documento",;
		"Fornecedor",;
		"Loja",;
		"Razao Social",;
		"Placa Ativo",;
		"Motivo",;
		"Preco",;
		"Vlr. Total" ,;
		"Vlr. IPI",;
		"Icms ST",;
		"Desconto",;
		"Total Nota" ,;
		"Residuo",;
		"Loc. Entrega",;
		"Observacao",;
		"NCM",;
		"IPI %",;
		"ICMS %",;
		"PIS %",;
		"COFINS %",;
		"CSLL %",;
		"INSS %",;
		"IR %",;
		"ISS %" })

  Else

	AaDd(aDadosExcel,{ "Empresa","Item Cont.",;
		"Descricao",;
		"C.Custo",;
		"Descricao",;
		"Num Solic",;
		"Dt. Solic",;
		"Resp.Caixa",;
		"Pedido",;
		"Emissao",;
   "Dt Aprov",;
		"Dt Entrega",;
		"Dt Entrada",;
		"Usuario",;
		"Status",;
		"Produto",;
		"Descricao",;
		"Armazem",;
		"Qtde Ped",;
		"Qtde Entr",;
		"Documento",;
		"Fornecedor",;
		"Loja",;
		"Razao Social",;
		"Placa Ativa",;
		"Motivo",;
		"Preco",;
		"Vlr. Total" ,;
		"Observacao" })
  
  EndIf 
  
	nCol := Len(aDadosExcel[1])

	DbSelectArea("TRB")
	DbGoTop()

	ProcRegua(RecCount())        // Total de Elementos da regua

	While TRB->(!EOF())
	
   If MV_PAR15 # 2 
		AaDD( aDadosExcel, { TRB->EMPRESA,TRB->ITEMCTA,;
			TRB->DESC_ITEM,;
			TRB->CC,;
			TRB->DESC_CC,;
			TRB->SOLSACS,;
			DTOC(TRB->DTSOLIC),;
			TRB->PEDIDO,;
			Dtoc(TRB->EMISSAO) ,;
			Dtoc(TRB->DTAPROV),;
			Dtoc(TRB->DTENT) ,;
			Dtoc(TRB->DTDIGIT) ,;
			TRB->USER,;
			TRB->STATUS,;
			TRB->PROD,;
			TRB->DESC,;
			TRB->ALMOX,;
			Transform(TRB->QUANT ,"@e 999,999.99") ,;
			Transform(TRB->QUJE,"@e 999,999.99") ,;
			TRB->DOC ,;
			TRB->FORNECE,;
			TRB->LOJA,;
			TRB->NOME,;
			TRB->PLCATV,;
            TRB->MOTIVO,;
			Transform(TRB->PRECO,"@e 999,999.99"),;
			Transform(TRB->	TOTAL,"@e 999,999.99"),;
			Transform(TRB->VALIPI,"@e 999,999.99"),;
			Transform(TRB->ICMSRET,"@e 999,999.99"),;
			Transform(TRB->VLDESC,"@e 999,999.99"),;
			Transform(TRB->VALLIQ,"@e 99,999,999.99"),;
			TRB->RESIDUO ,;
			TRB->LOC_ENT,;
			TRB->OBS ,;
			TRB->NCM ,;
			Transform(TRB->PERIPI,"@e 999,999.99"),;
			Transform(TRB->PERICM,"@e 999,999.99"),;
			Transform(TRB->PERPIS,"@e 999,999.99"),;
			Transform(TRB->PERCOF,"@e 999,999.99"),;
			Transform(TRB->PERCSL,"@e 999,999.99"),;
			Transform(TRB->PERINS,"@e 999,999.99"),;
			Transform(TRB->PERIRF,"@e 999,999.99"),;
			Transform(TRB->PERISS,"@e 999,999.99") } )

   Else

		AaDD( aDadosExcel, { TRB->EMPRESA,TRB->ITEMCTA,;
			TRB->DESC_ITEM,;
			TRB->CC,;
			TRB->DESC_CC,;
			TRB->SOLSACS,;
			DTOC(TRB->DTSOLIC),;
			TRB->RESPCXA,;
			TRB->PEDIDO,;
			Dtoc(TRB->EMISSAO) ,;
			Dtoc(TRB->DTAPROV),;			
			Dtoc(TRB->DTENT) ,;
			Dtoc(TRB->DTDIGIT) ,;
			TRB->USER,;
			TRB->STATUS,;
			TRB->PROD,;
			TRB->DESC,;
			TRB->ALMOX,;
			Transform(TRB->QUANT ,"@e 999,999.99") ,;
			Transform(TRB->QUJE,"@e 999,999.99") ,;
			TRB->DOC ,;
			TRB->FORNECE,;
			TRB->LOJA,;
			TRB->NOME,;
			TRB->PLCATV,;
            TRB->MOTIVO,;
			Transform(TRB->PRECO,"@e 999,999.99"),;
			Transform(TRB->	TOTAL,"@e 999,999.99"),;
			TRB->OBS  } )
   
   EndIf 
   
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
	AaDd(aCampos,{"DOC"      ,"C", 13,0})
	AaDd(aCampos,{"ITEMCTA"  ,"C",  9,0})
	AaDd(aCampos,{"DESC_ITEM"  ,"C", 20,0})
	AaDd(aCampos,{"CC"       ,"C",  9,0})
	AaDd(aCampos,{"DESC_CC"  ,"C", 20,0})
	AaDd(aCampos,{"DTDIGIT"  ,"D",  8,0})
	AaDd(aCampos,{"QUANT"    ,"N", 11,2})
	AaDd(aCampos,{"QUJE"     ,"N", 11,2})
	AaDd(aCampos,{"PRECO"    ,"N", 17,2})
	AaDd(aCampos,{"VLDESC"   ,"N", 17,2})
	AaDd(aCampos,{"VALIPI"   ,"N", 17,2})
	AaDd(aCampos,{"TOTAL"    ,"N", 17,2})
	AaDd(aCampos,{"ICMSRET"  ,"N", 17,2})
	AaDd(aCampos,{"VALLIQ"   ,"N", 17,2})
	AaDd(aCampos,{"NOME"     ,"C", 30,0})
	AaDd(aCampos,{"FORNECE"  ,"C",  6,0})
	AaDd(aCampos,{"LOJA"     ,"C",  2,0})
	AaDd(aCampos,{"DTENT"    ,"D",  8,0})
	AaDd(aCampos,{"EMPRESA"  ,"C",  2,0})
	AaDd(aCampos,{"NATUREZ"  ,"C", 10,0})
	AaDd(aCampos,{"PEDIDO"   ,"C",  6,0})
	AaDd(aCampos,{"EMISSAO"  ,"D",  8,0})
	AaDd(aCampos,{"FORMPGT"  ,"C",  1,0})
	AaDd(aCampos,{"DESCFPG"  ,"C", 20,0})
	
	AaDd(aCampos,{"PROD"     ,"C", 15,0})
	AaDd(aCampos,{"DESC"     ,"C", 40,0})
	AaDd(aCampos,{"NCM"      ,"C", 10,0})
	AaDd(aCampos,{"OBS"      ,"C", 90,0})
	AaDd(aCampos,{"USER"     ,"C", 20,0})
	AaDd(aCampos,{"STATUS"   ,"C",  1,0})
	AaDd(aCampos,{"RESIDUO"  ,"C",  1,0})
	AaDd(aCampos,{"ALMOX"    ,"C",  2,0})
	AaDd(aCampos,{"LOC_ENT"  ,"C",  1,0})
	AaDd(aCampos,{"RESPCXA"  ,"C", 30,0})	
	
	AaDd(aCampos,{"PERIPI"    ,"N",  5,2})
	AaDd(aCampos,{"PERICM"    ,"N",  5,2})
	AaDd(aCampos,{"PERPIS"    ,"N",  5,2})
	AaDd(aCampos,{"PERCOF"    ,"N",  5,2})
	AaDd(aCampos,{"PERCSL"    ,"N",  5,2})
	
	AaDd(aCampos,{"PERINS"    ,"N",  5,2})
	AaDd(aCampos,{"PERIRF"    ,"N",  5,2})
	AaDd(aCampos,{"PERISS"    ,"N",  5,2})
								
	AaDd(aCampos,{"SOLSACS"  ,"C",  6,0})
	AaDd(aCampos,{"DTSOLIC"  ,"D",  8,0})
	AaDd(aCampos,{"DTAPROV"  ,"D",  8,0})
	//fernando
	AaDd(aCampos,{"PLCATV"  ,"C",  15,0})
	AaDd(aCampos,{"MOTIVO"  ,"C",  15,0})
//PLCATV
//MOTIVO
	//fim fernando	
	cArqTmp := CriaTrab(aCampos,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria o arquivo de Trabalhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	DbUseArea(.T.,,cArqTmp,"TRB",.F.,.F.)
	IndRegua("TRB",cArqTmp,"EMPRESA+CC+PROD+PEDIDO+FORNECE+LOJA",,,"Selecionando Registros..." )

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
	oArialNeg06 :=  TFont():New( "Arial",, 6,,.T.,,,,,.f. )
	oArialNeg05 :=  TFont():New( "Arial",, 5,,.T.,,,,,.f. )

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

	nTipoRel := Escolha()

	oPrn := TMSPrinter():New()
//oPrn:SetPortrait()
	oPrn:SetPaperSize(9)
	oPrn:SetLandscape()

	oPrn:Setup()

	lFirst := .t.
	lPri := .T.
	nPag := 0
	nLin := 490

	If nTipoRel == 1
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice para Gerar o relatorio                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cNomArq  := CriaTrab(nil,.f.)
		IndRegua("TRB",cNomArq,"EMPRESA+PEDIDO+DTOS(DTENT)+FORNECE+LOJA",,,"Selecionando Registros..." )
	
		nVlrTotCC := 0
		nVlrTotTot := 0
	
		DbSelectArea("TRB")
		DbGotop()
	
		ProcRegua(RecCount())        // Total de Elementos da regua
	
		While TRB->(!EOF())
		
		
			If lFirst
				oPrn:StartPage()
				cTitulo := "Relatorio de posicionamento de Pedidos de Compras "
				cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
				cNomEmp := SM0->M0_NOMECOM
				aTit    := {cTitulo,cNomEmp,cRod}
				nPag++
				U_CabRel(aTit,1,oPrn,nPag,"")
			
				CabCons(oPrn,1)
			
				lFirst = .F.
			
			EndIf
		
			nVlrCC := 0
			lPri := .T.
			cPedido := TRB->PEDIDO
		
			While TRB->(!Eof()) .And. cPedido == TRB->PEDIDO
						
				oPrn:Box(nLin,100,nLin+60,3300)

				oPrn:line(nLin, 250,nLin+60, 250)
				oPrn:line(nLin, 400,nLin+60, 400)
				oPrn:line(nLin, 800,nLin+60, 800)
				oPrn:line(nLin, 950,nLin+60, 950)
				oPrn:line(nLin,1200,nLin+60,1200)
				oPrn:line(nLin,1300,nLin+60,1300)
				oPrn:line(nLin,1500,nLin+60,1500)
				oPrn:line(nLin,1600,nLin+60,1600)
				oPrn:line(nLin,1900,nLin+60,1900)
				oPrn:line(nLin,2100,nLin+60,2100)

				oPrn:line(nLin,2350,nLin+60,2350)
				oPrn:line(nLin,2550,nLin+60,2550)
	
				oPrn:line(nLin,2750,nLin+60,2750)
				oPrn:line(nLin,2950,nLin+60,2950)
				oPrn:line(nLin,3150,nLin+60,3150)
			
			
				If lPri
					oPrn:Say(nLin+10,  110,TRB->PEDIDO ,oFont9 ,100)
					lPri := .F.
				EndIf

				SB1->(DbSetOrder(1))
				SB1->(DbSeek(xFilial("SB1")+TRB->PROD ))
      
				oPrn:Say(nLin+10,  260,TRB->FORNECE+"-"+TRB->LOJA ,oFont9 ,100)
				oPrn:Say(nLin+10,  410,Substr(TRB->NOME,1,20)  ,oArialNeg06 ,100)
				
				oPrn:Say(nLin+10,  350,TRB->PLCATV ,oFont9 ,100)
				oPrn:Say(nLin+10,  460,TRB->MOTIVO  ,oArialNeg06 ,100)
				
				AaDD(aBrowse,{"PLCATV","","PLCATV",""})
				AaDD(aBrowse,{"MOTIVO","","Motivo",""})

				oPrn:Say(nLin+10,  810,TRB->PROD    ,oArialNeg06 ,100)
				oPrn:Say(nLin+10,  960,Substr(TRB->DESC,1,20)  ,oArialNeg05 ,100)

				oPrn:Say(nLin+10,  1210,Dtoc(TRB->EMISSAO)        ,oArialNeg05 ,100)
							
				oPrn:Say(nLin+10,  1310,Substr(TRB->DOC,4,9)        ,oArialNeg06 ,100)

				oPrn:Say(nLin+10,  1540, TRB->STATUS        ,oFont9 ,100)

				oPrn:Say(nLin+10, 1610,Dtoc(TRB->DTENT) ,oFont9 ,100)
				
				oPrn:Say(nLin+10, 1910,Dtoc(TRB->DTDIGIT) ,oFont9 ,100)

				oPrn:Say(nLin+10, 2160,Transform(TRB->QUANT,"@e 999,999" )  ,oArialNeg06 ,100)

				oPrn:Say(nLin+10, 2360,Transform(TRB->QUJE,"@e 999,999" )  ,oArialNeg06 ,100)
								
				oPrn:Say(nLin+10, 2560,Transform(TRB->PRECO ,"@e 99,999,999.99" )  ,oArialNeg06 ,100)

				oPrn:Say(nLin+10, 2760,Transform(TRB->TOTAL+TRB->VALIPI,"@e 999,999,999.99" ) ,oFont9 ,100)
				
				oPrn:Say(nLin+10, 2960,TRB->ITEMCTA         ,oFont9 ,100)

				oPrn:Say(nLin+10, 3160,If(TRB->LOC_ENT="M","Matriz","Obra")    ,oFont9 ,100)
			
				nLin += 60
	
				nVlrTotCC += TRB->TOTAL
				nVlrTotTot += TRB->TOTAL


				If nLin > 2200
					oPrn:EndPage()
				
					oPrn:StartPage()
					cTitulo := "Relatorio de posicionamento de Pedidos de Compras "
					cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
					cNomEmp := SM0->M0_NOMECOM
					aTit    := {cTitulo,cNomEmp,cRod}
					nPag++
					U_CabRel(aTit,1,oPrn,nPag,"")
				
					CabCons(oPrn,1)
				
				EndIf
			
				DbSelectArea("TRB")
				DbSkip()
			
			End
		
			If nVlrTotCC > 0
			
				nLin += 20
			
				oPrn:Box(nLin,100,nLin+60,3300)
			
				oPrn:line(nLin,2750,nLin+60,2750)
				oPrn:line(nLin,2950,nLin+60,2950)

				oPrn:Say(nLin+10, 120,"Total Pedido " ,oFont9 ,100)

				oPrn:Say(nLin+10, 2780,Transform(nVlrTotCC  ,"@e 999,999,999.99" ) ,oFont9 ,100)
			
				nLin += 80
			
			EndIf
		
		End
	
		If nVlrTotTot > 0
		
			nLin += 20
		
			oPrn:Box(nLin,100,nLin+60,3300)
		
/*			oPrn:line(nLin,2300,nLin+60,2300)
			oPrn:line(nLin,2550,nLin+60,2550)
			oPrn:line(nLin,2800,nLin+60,2800)
			oPrn:line(nLin,3050,nLin+60,3050) */
			
			oPrn:line(nLin,2750,nLin+60,2750)
			oPrn:line(nLin,2950,nLin+60,2950)
			
			
			oPrn:Say(nLin+10, 120,"Total Geral " ,oFont9 ,100)

/*			oPrn:Say(nLin+10, 2320,Transform(nVlrTotTot ,"@e 999,999,999.99" ) ,oFont9 ,100)
			oPrn:Say(nLin+10, 2580,Transform(nVlrDesTot ,"@e 999,999,999.99" ) ,oFont9 ,100)
			oPrn:Say(nLin+10, 2880,Transform(nVlrIPITot ,"@e 999,999,999.99" )  ,oFont9 ,100) */ 


			oPrn:Say(nLin+10, 2780,Transform(nVlrTotTot ,"@e 999,999,999.99" ) ,oFont9 ,100)
		
			nLin += 80
		
		EndIf
	
	ElseIf nTipoRel == 2
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice para Gerar o relatorio                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cNomArq  := CriaTrab(nil,.f.)
		IndRegua("TRB",cNomArq,"EMPRESA+FORNECE+LOJA+PEDIDO",,,"Selecionando Registros..." )
	
		nVlrNat := 0
		nVlrTot := 0
	
		DbSelectArea("TRB")
		DbGotop()
	
		ProcRegua(RecCount())        // Total de Elementos da regua
	
		While TRB->(!EOF())
		
		
			If lFirst
				oPrn:StartPage()
				cTitulo := "Relatorio de posicionamento de Pedidos de Compras "
				cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
				cNomEmp := SM0->M0_NOMECOM
				aTit    := {cTitulo,cNomEmp,cRod}
				nPag++
				U_CabRel(aTit,1,oPrn,nPag,"")
			
				CabCons(oPrn,1)
			
				lFirst = .F.
			
			EndIf
		
			nVlrFor  := 0
			lPri := .T.
			cFornece := TRB->FORNECE
		
			While TRB->(!Eof()) .And. cFornece == TRB->FORNECE
			
				oPrn:Box(nLin,100,nLin+60,3300)
			
				oPrn:line(nLin, 250,nLin+60, 250)
				oPrn:line(nLin, 600,nLin+60, 600)
				oPrn:line(nLin, 800,nLin+60, 800)

				oPrn:line(nLin,1100,nLin+60,1100)
				oPrn:line(nLin,1200,nLin+60,1200)
				oPrn:line(nLin,1300,nLin+60,1300)
				oPrn:line(nLin,1500,nLin+60,1500)
				oPrn:line(nLin,1600,nLin+60,1600)
				oPrn:line(nLin,1900,nLin+60,1900)
				oPrn:line(nLin,2100,nLin+60,2100)

				oPrn:line(nLin,2350,nLin+60,2350)
				oPrn:line(nLin,2550,nLin+60,2550)
	
				oPrn:line(nLin,2750,nLin+60,2750)
				oPrn:line(nLin,2950,nLin+60,2950)
				oPrn:line(nLin,3150,nLin+60,3150)

				If lPri
					oPrn:Say(nLin+10,  110,TRB->FORNECE+"-"+TRB->LOJA ,oFont9 ,100)
					oPrn:Say(nLin+10,  260,Substr(TRB->NOME,1,20)  ,oArialNeg06 ,100)

					lPri := .F.
				EndIf

				SB1->(DbSetOrder(1))
				SB1->(DbSeek(xFilial("SB1")+TRB->PROD ))
      
				oPrn:Say(nLin+10,  610,TRB->FORNECE+"-"+TRB->LOJA ,oFont9 ,100)
				oPrn:Say(nLin+10,  810,Substr(TRB->NOME,1,20)  ,oArialNeg06 ,100)

				oPrn:Say(nLin+10,  1110,TRB->PEDIDO         ,oArialNeg06 ,100)

				oPrn:Say(nLin+10,  1210,Dtoc(TRB->EMISSAO)        ,oArialNeg05 ,100)
							
				oPrn:Say(nLin+10,  1310,Substr(TRB->DOC,4,9)        ,oArialNeg06 ,100)

				oPrn:Say(nLin+10,  1540, TRB->STATUS        ,oFont9 ,100)

				oPrn:Say(nLin+10, 1610,Dtoc(TRB->DTENT) ,oFont9 ,100)
				
				oPrn:Say(nLin+10, 1910,Dtoc(TRB->DTDIGIT) ,oFont9 ,100)

				oPrn:Say(nLin+10, 2160,Transform(TRB->QUANT,"@e 999,999" )  ,oArialNeg06 ,100)

				oPrn:Say(nLin+10, 2360,Transform(TRB->QUJE,"@e 999,999" )  ,oArialNeg06 ,100)
								
				oPrn:Say(nLin+10, 2560,Transform(TRB->PRECO ,"@e 99,999,999.99" )  ,oArialNeg06 ,100)

				oPrn:Say(nLin+10, 2760,Transform(TRB->TOTAL+TRB->VALIPI,"@e 999,999,999.99" ) ,oFont9 ,100)
				
				oPrn:Say(nLin+10, 2960,TRB->ITEMCTA         ,oFont9 ,100)

				oPrn:Say(nLin+10, 3160,If(TRB->LOC_ENT="M","Matriz","Obra")    ,oFont9 ,100)
			
				nLin += 60
			
				nVlrFor += TRB->TOTAL+TRB->VALIPI
				nVlrTot += TRB->TOTAL+TRB->VALIPI
			
				If nLin > 2200
					oPrn:EndPage()
				
					oPrn:StartPage()
					cTitulo := "Relatorio de posicionamento de Pedidos de Compras "
					cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
					cNomEmp := SM0->M0_NOMECOM
					aTit    := {cTitulo,cNomEmp,cRod}
					nPag++
					U_CabRel(aTit,1,oPrn,nPag,"")
				
					CabCons(oPrn,1)
				
				EndIf
			
				DbSelectArea("TRB")
				DbSkip()
			
			End
		
			If nVlrFor > 0
			
				nLin += 20
			
				oPrn:Box(nLin,100,nLin+60,3300)
			
				oPrn:line(nLin,2750,nLin+60,2750)
				oPrn:line(nLin,2950,nLin+60,2950)

				oPrn:Say(nLin+10, 120,"Total Fornecedor " ,oFont9 ,100)
				oPrn:Say(nLin+10, 2780,Transform(nVlrFor ,"@e 999,999,999.99" ) ,oFont9 ,100)
			
				nLin += 80
			
			EndIf
		
		End
	
		If nVlrTot > 0
		
			nLin += 20
		
			oPrn:Box(nLin,100,nLin+60,3300)
		
			oPrn:line(nLin,2750,nLin+60,2750)
			oPrn:line(nLin,2950,nLin+60,2950)

			oPrn:Say(nLin+10, 120,"Total Geral " ,oFont9 ,100)
			oPrn:Say(nLin+10, 2780,Transform(nVlrTot ,"@e 999,999,999.99" ) ,oFont9 ,100)
		
			nLin += 80
		
		EndIf
	
	Else

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice para Gerar o relatorio                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cNomArq  := CriaTrab(nil,.f.)
		IndRegua("TRB",cNomArq,"EMPRESA+PROD+NOME+DOC+FORNECE+LOJA",,,"Selecionando Registros..." )
	
		nVlrProd := 0
		nVlrTot := 0
	
		DbSelectArea("TRB")
		DbGotop()
	
		ProcRegua(RecCount())        // Total de Elementos da regua
	
		While TRB->(!EOF())
		
		
			If lFirst
				oPrn:StartPage()
				cTitulo := "Relatorio de posicionamento de Pedidos de Compras "
				cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
				cNomEmp := SM0->M0_NOMECOM
				aTit    := {cTitulo,cNomEmp,cRod}
				nPag++
				U_CabRel(aTit,1,oPrn,nPag,"")
			
				CabCons(oPrn,1)
			
				lFirst = .F.
			
			EndIf
		
			nVlrProd := 0
			lPri := .T.
			cProd := TRB->PROD
		
			While TRB->(!Eof()) .And. cProd == TRB->PROD
			
				oPrn:Box(nLin,100,nLin+60,3300)
			
				oPrn:line(nLin, 250,nLin+60, 250)
				oPrn:line(nLin, 600,nLin+60, 600)
				oPrn:line(nLin, 800,nLin+60, 800)
				oPrn:line(nLin,1100,nLin+60,1100)
				oPrn:line(nLin,1200,nLin+60,1200)
				oPrn:line(nLin,1300,nLin+60,1300)
				oPrn:line(nLin,1500,nLin+60,1500)
				oPrn:line(nLin,1600,nLin+60,1600)
				oPrn:line(nLin,1900,nLin+60,1900)
				oPrn:line(nLin,2100,nLin+60,2100)

				oPrn:line(nLin,2350,nLin+60,2350)
				oPrn:line(nLin,2550,nLin+60,2550)
	
				oPrn:line(nLin,2750,nLin+60,2750)
				oPrn:line(nLin,2950,nLin+60,2950)
				oPrn:line(nLin,3150,nLin+60,3150)
			
				If lPri
					oPrn:Say(nLin+10,  110,TRB->PROD    ,oArialNeg06 ,100)
					oPrn:Say(nLin+10,  260,Substr(TRB->DESC,1,24)  ,oArialNeg06 ,100)
					lPri := .F.
				EndIf

				SB1->(DbSetOrder(1))
				SB1->(DbSeek(xFilial("SB1")+TRB->PROD ))
      
				oPrn:Say(nLin+10,  610,TRB->FORNECE+"-"+TRB->LOJA ,oFont9 ,100)
				oPrn:Say(nLin+10,  810,Substr(TRB->NOME,1,20)  ,oArialNeg06 ,100)

				oPrn:Say(nLin+10,  1110,TRB->PEDIDO         ,oArialNeg06 ,100)

				oPrn:Say(nLin+10,  1210,Dtoc(TRB->EMISSAO)        ,oArialNeg05 ,100)
							
				oPrn:Say(nLin+10,  1310,Substr(TRB->DOC,4,9)        ,oArialNeg06 ,100)

				oPrn:Say(nLin+10,  1540, TRB->STATUS        ,oFont9 ,100)

				oPrn:Say(nLin+10, 1610,Dtoc(TRB->DTENT) ,oFont9 ,100)
				
				oPrn:Say(nLin+10, 1910,Dtoc(TRB->DTDIGIT) ,oFont9 ,100)

				oPrn:Say(nLin+10, 2160,Transform(TRB->QUANT,"@e 999,999" )  ,oArialNeg06 ,100)

				oPrn:Say(nLin+10, 2360,Transform(TRB->QUJE,"@e 999,999" )  ,oArialNeg06 ,100)
								
				oPrn:Say(nLin+10, 2560,Transform(TRB->PRECO ,"@e 99,999,999.99" )  ,oArialNeg06 ,100)

				oPrn:Say(nLin+10, 2760,Transform(TRB->TOTAL+TRB->VALIPI,"@e 999,999,999.99" ) ,oFont9 ,100)
				
				oPrn:Say(nLin+10, 2960,TRB->ITEMCTA         ,oFont9 ,100)

				oPrn:Say(nLin+10, 3160,If(TRB->LOC_ENT="M","Matriz","Obra")    ,oFont9 ,100)
											
				nLin += 60
			
				nVlrProd += TRB->TOTAL+TRB->VALIPI
				nVlrTot  += TRB->TOTAL+TRB->VALIPI
			
				If nLin > 2200
					oPrn:EndPage()
				
					oPrn:StartPage()
					cTitulo := "Relatorio de posicionamento de Pedidos de Compras "
					cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
					cNomEmp := SM0->M0_NOMECOM
					aTit    := {cTitulo,cNomEmp,cRod}
					nPag++
					U_CabRel(aTit,1,oPrn,nPag,"")
				
					CabCons(oPrn,1)
				
				EndIf
			
				DbSelectArea("TRB")
				DbSkip()
			
			End
		
			If nVlrProd > 0
			
				nLin += 20
			
				oPrn:Box(nLin,100,nLin+60,3300)
			
				oPrn:line(nLin,2750,nLin+60,2750)
				oPrn:line(nLin,2950,nLin+60,2950)

				oPrn:Say(nLin+10, 120,"Total Produto" ,oFont9 ,100)
				oPrn:Say(nLin+10, 2760,Transform(nVlrProd ,"@e 999,999,999.99" ) ,oFont9 ,100)
			
				nLin += 80
			
			EndIf
		
		End
	
		If nVlrTot > 0
		
			nLin += 20
		
			oPrn:Box(nLin,100,nLin+60,3300)
		
			oPrn:line(nLin,2950,nLin+60,2950)
			oPrn:line(nLin,2750,nLin+60,2750)

			oPrn:Say(nLin+10, 120,"Total Geral " ,oFont9 ,100)
			oPrn:Say(nLin+10, 2760,Transform(nVlrTot ,"@e 999,999,999.99" ) ,oFont9 ,100)
		
			nLin += 80

		EndIf

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

	If nTipoRel == 1
		
		oPrn:line(nLin, 250,nLin+60, 250)
		oPrn:line(nLin, 400,nLin+60, 400)
		oPrn:line(nLin, 800,nLin+60, 800)
		oPrn:line(nLin, 950,nLin+60, 950)
		oPrn:line(nLin,1200,nLin+60,1200)
		oPrn:line(nLin,1300,nLin+60,1300)
		oPrn:line(nLin,1500,nLin+60,1500)
		oPrn:line(nLin,1600,nLin+60,1600)
		oPrn:line(nLin,1900,nLin+60,1900)
		oPrn:line(nLin,2100,nLin+60,2100)

		oPrn:line(nLin,2350,nLin+60,2350)
		oPrn:line(nLin,2550,nLin+60,2550)
	
		oPrn:line(nLin,2750,nLin+60,2750)
		oPrn:line(nLin,2950,nLin+60,2950)
		oPrn:line(nLin,3150,nLin+60,3150)

		oPrn:Say(nLin+10,  110,"Pedido"      ,oFont9 ,100)
		oPrn:Say(nLin+10,  260,"Fornecedor"  ,oFont9 ,100)
		oPrn:Say(nLin+10,  410,"Nome"        ,oFont9 ,100)
		oPrn:Say(nLin+10,  810,"Produto"     ,oFont9 ,100)
		oPrn:Say(nLin+10,  960,"Descricao"   ,oFont9 ,100)
		oPrn:Say(nLin+10, 1210,"Emissao"     ,oArialNeg06 ,100)
		oPrn:Say(nLin+10, 1310,"Documento"   ,oFont9 ,100)
		oPrn:Say(nLin+10, 1510,"Status"   ,oFont9 ,100)
		oPrn:Say(nLin+10, 1610,"Dt Entr"     ,oFont9 ,100)
		oPrn:Say(nLin+10, 1910,"Dt Entrada"     ,oFont9 ,100)
		oPrn:Say(nLin+10, 2160,"Qtde"   ,oFont9 ,100)

		oPrn:Say(nLin+10, 2360,"Qt Entregue"   ,oFont9 ,100)
		oPrn:Say(nLin+10, 2560,"Pr.Unit"   ,oFont9 ,100)
		oPrn:Say(nLin+10, 2760,"Vlr Total"   ,oFont9 ,100)
		//oPrn:Say(nLin+10, 2960,"C.Custo"     ,oFont9 ,100)
		oPrn:Say(nLin+10, 2960,"Item Cont."     ,oFont9 ,100)
		oPrn:Say(nLin+10, 3160,"Loc. Entr."     ,oFont9 ,100)
	
	ElseIf 	nTipoRel == 2
	
		oPrn:line(nLin, 250,nLin+60, 250)
		oPrn:line(nLin, 600,nLin+60, 600)
		oPrn:line(nLin, 800,nLin+60, 800)
		oPrn:line(nLin,1100,nLin+60,1100)
		oPrn:line(nLin,1200,nLin+60,1200)
		oPrn:line(nLin,1300,nLin+60,1300)
		oPrn:line(nLin,1500,nLin+60,1500)
		oPrn:line(nLin,1600,nLin+60,1600)
		oPrn:line(nLin,1900,nLin+60,1900)
		oPrn:line(nLin,2100,nLin+60,2100)

		oPrn:line(nLin,2350,nLin+60,2350)
		oPrn:line(nLin,2550,nLin+60,2550)
	
		oPrn:line(nLin,2750,nLin+60,2750)
		oPrn:line(nLin,2950,nLin+60,2950)
		oPrn:line(nLin,3150,nLin+60,3150)

		oPrn:Say(nLin+10,  110,"Fornecedor"  ,oFont9 ,100)
		oPrn:Say(nLin+10,  260,"Nome"        ,oFont9 ,100)
		oPrn:Say(nLin+10,  610,"Produto"     ,oFont9 ,100)
		oPrn:Say(nLin+10,  810,"Descricao"   ,oFont9 ,100)
		oPrn:Say(nLin+10, 1105,"Pedido"      ,oFont9 ,100)
		oPrn:Say(nLin+10, 1210,"Emissao"     ,oArialNeg06 ,100)
		oPrn:Say(nLin+10, 1310,"Documento"   ,oFont9 ,100)
		oPrn:Say(nLin+10, 1510,"Status"   ,oFont9 ,100)
		oPrn:Say(nLin+10, 1610,"Dt Entr"     ,oFont9 ,100)
		oPrn:Say(nLin+10, 1910,"Dt Entrada"     ,oFont9 ,100)
		oPrn:Say(nLin+10, 2160,"Qtde"   ,oFont9 ,100)

		oPrn:Say(nLin+10, 2360,"Qt Entregue"   ,oFont9 ,100)
		oPrn:Say(nLin+10, 2560,"Pr.Unit"   ,oFont9 ,100)
		oPrn:Say(nLin+10, 2760,"Vlr Total"   ,oFont9 ,100)
		oPrn:Say(nLin+10, 2960,"C.Custo"     ,oFont9 ,100)
		oPrn:Say(nLin+10, 3160,"Loc. Entr."     ,oFont9 ,100)


	Else
	
		oPrn:line(nLin, 250,nLin+60, 250)
		oPrn:line(nLin, 600,nLin+60, 600)
		oPrn:line(nLin, 800,nLin+60, 800)
		oPrn:line(nLin,1100,nLin+60,1100)
		oPrn:line(nLin,1200,nLin+60,1200)
		oPrn:line(nLin,1300,nLin+60,1300)
		oPrn:line(nLin,1500,nLin+60,1500)
		oPrn:line(nLin,1600,nLin+60,1600)
		oPrn:line(nLin,1900,nLin+60,1900)
		oPrn:line(nLin,2100,nLin+60,2100)

		oPrn:line(nLin,2350,nLin+60,2350)
		oPrn:line(nLin,2550,nLin+60,2550)
	
		oPrn:line(nLin,2750,nLin+60,2750)
		oPrn:line(nLin,2950,nLin+60,2950)
		oPrn:line(nLin,3150,nLin+60,3150)

		oPrn:Say(nLin+10,  110,"Produto"     ,oFont9 ,100)
		oPrn:Say(nLin+10,  260,"Descricao"   ,oFont9 ,100)
		oPrn:Say(nLin+10,  610,"Fornecedor"  ,oFont9 ,100)
		oPrn:Say(nLin+10,  810,"Nome"        ,oFont9 ,100)
		oPrn:Say(nLin+10, 1105,"Pedido"      ,oFont9 ,100)
		oPrn:Say(nLin+10, 1210,"Emissao"     ,oArialNeg06 ,100)
		oPrn:Say(nLin+10, 1310,"Documento"   ,oFont9 ,100)
		oPrn:Say(nLin+10, 1510,"Status"   ,oFont9 ,100)
		oPrn:Say(nLin+10, 1610,"Dt Entr"     ,oFont9 ,100)
		oPrn:Say(nLin+10, 1910,"Dt Entrada"     ,oFont9 ,100)
		oPrn:Say(nLin+10, 2160,"Qtde"   ,oFont9 ,100)

		oPrn:Say(nLin+10, 2360,"Qt Entregue"   ,oFont9 ,100)
		oPrn:Say(nLin+10, 2560,"Pr.Unit"   ,oFont9 ,100)
		oPrn:Say(nLin+10, 2760,"Vlr Total"   ,oFont9 ,100)
		oPrn:Say(nLin+10, 2960,"C.Custo"     ,oFont9 ,100)
		oPrn:Say(nLin+10, 3160,"Loc. Entr."     ,oFont9 ,100)

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
	@ 23,30 RADIO oRadio Var nRadio Items "Pedido","Fornecedor","Produto" 3D SIZE 60,10 of oDlg2 Pixel

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
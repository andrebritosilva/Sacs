#INCLUDE "Protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

User Function MT120FIM()

	Local nTotal     := 0
	Local nDespesas  := 0
	Local nDesconto  := 0
	Local cEmpresa   := SM0->M0_CODIGO
	Local cFil       := SM0->M0_CODFIL
	Local cNomeEmp   := SM0->M0_NOMECOM
	Local lPedidos   := .F.
	Local cStatus    := ""
	Local aArray := {}

	Private lMsErroAuto := .F.

	Private oHtml
	Private cNomeAp  := ""
	Private cAprovador  := ""
	Private cNum     := ""
	Private cUser    := ""
	Private cPedido  := PARAMIXB[2]
	Private nTipo    := PARAMIXB[1]
	Private aProdutos:= {}
	Private a := 1

	Private cLinkDoc := "http://va8pf4.prd.protheus.totvscloud.com.br:31148/dirdoc"  //diretorio onde se encontram os documentos que irao acompanhar o pedido

	nOpc := PARAMIXB[3]

	//Quando nao confirmar o pedido retorna
	If nOpc == 0
		Return
	EndIf

conout("antes tipo 5")

	If nTipo == 5

		DbSelectArea("SC7")
		DbSetOrder(1)
		DbSeek(xFilial()+ca120num)

		DbSelectArea("SCR")
		DbSetorder(1)
		DbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM )
		if ! scr->(eof())
		While SCR->(!Eof()) .And. Alltrim(SCR->CR_NUM) == SC7->C7_NUM

			Reclock("SCR",.F.)
			SCR->(DbDelete())
			MsUnlock()

			DbSkip()

		End
		endif

	EndIf

	//Estava enviando workflow mesmo na visualizacao do pedido
	If nTipo # 3 .And. nTipo # 4
		Return
	EndIf

	nTotPed := 0
	nVlrPed := 0
	lAntCxa := .F.

	cPA := Posicione("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_PA")

	nVlr_PA  := 0

	// Para Atualizar o nome do fornecedor no cadastro
	If nTipo == 3 .Or. nTipo == 4 // Inclui .or. altera

		lDsRH   := .F.
		lEpis   := .F.

		lProRevenda := .F.

		DbSelectArea("SC7")
		DbSetOrder(1)
		DbSeek(xFilial()+ca120num)

		While SC7->(!Eof()) .And. SC7->C7_FILIAL + SC7->C7_NUM == XFILIAL("SC7")+ca120num

			If Alltrim(SC7->C7_PRODUTO) == "DESP0089"
				lAntCxa := .T.
			EndIf

			nTotPed += ( SC7->C7_TOTAL + SC7->C7_VALFRE + SC7->C7_DESPESA + SC7->C7_VALIPI  )

			SB1->(DbSetorder(1))
			SB1->(DbSeek(xFilial("SB1")+SC7->C7_PRODUTO ))

			If SB1->B1_GRUPO == "DSRH"
				lDsRH := .T.
			ElseIf SB1->B1_GRUPO == "EPIS"
				lEpis := .T.
			EndIf

			SC7->(DbSkip())

		End

		DbSelectArea("SC7")
		DbSetOrder(1)
		DbSeek(xFilial()+ca120num)

		If cPA = "S"

			nVlr_PA := If(SC7->C7_COND=="CXA",nTotPed,GetVlrPA())

		EndIf

		aAprov := {}
		cCC    := Space(9)

		DbSelectArea("SC7")
		DbSetOrder(1)
		DbSeek(xFilial()+ca120num)

		While SC7->(!Eof()) .And. SC7->C7_FILIAL + SC7->C7_NUM == XFILIAL("SC7")+ca120num

			cCC   := SC7->C7_CC
			nPesq := Ascan(aAprov,SC7->C7_APROV)
			If nPesq == 0
				AaDd(aAProv,SC7->C7_APROV)
			EndIf
			DbSkip()

		End

		//Define o Local de Entrega do Pedido de compra

		cLocEntEsp := SC7->C7_ENDENT

		nLocEnt := Escolha()

		If nLocEnt == 2

			If Empty(cLocEntEsp)

				DbSelectArea("CTT")
				DbSetOrder(1)
				DbSeek(xFilial("CTT")+cCC )

				cLocEntEsp := Alltrim(CTT->CTT_ENDER)+" - "+Alltrim(CTT->CTT_BAIRRO)+" - "+Alltrim(CTT->CTT_MUNIC)+" - "+CTT->CTT_ESTADO+" - "+Transform(CTT->CTT_CEP,"@R 99999-999")

			EndIf

			GetLocEsp()

		EndIf

		DbSelectArea("SC7")
		DbSetOrder(1)
		DbSeek(xFilial()+ca120num)

		cSolic := SC7->C7_SOLSACS
		dDtSol := SC7->C7_DTSOLIC

		GetNumSol()

		nVlrPed := 0

		DbSelectArea("SC7")
		DbSetOrder(1)
		DbSeek(xFilial()+ca120num)

		While SC7->(!Eof()) .And. SC7->C7_FILIAL + SC7->C7_NUM == XFILIAL("SC7")+ca120num

			Reclock("SC7",.F.)
			SC7->C7_LOC_ENT  := If(nLocEnt==1,"M","O")
			SC7->C7_ENDENT   := cLocEntEsp
			SC7->C7_NOMFOR := Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME") //Alimenta o Nome do Fornecedor
			SC7->C7_VLR_PA := nVlr_PA
			SC7->C7_PA     := If(nVlr_Pa > 0,"S","N")
			If Altera
				SC7->C7_ALTPED := "S"
				SC7->C7_VERSAO := StrZero(Val(SC7->C7_VERSAO)+1,3)
			EndIf
			SC7->C7_FILENT    := "01"
			SC7->C7_SOLSACS   := cSolic
			SC7->C7_DTSOLIC   := dDtSol
			MsUnlock()

			nVlrPed += SC7->C7_TOTAL

			SC7->(DbSkip())

		End

	Endif

	cEmailCo := ""

	SC7->(DbSeek(xFilial()+ca120num))  // Reposiciona o Pedido

	If SC7->C7_TIPPED == "2"
		Return
	EndIf
	
	conout("passei depois return")

	//Verifico se o pedido esta aguardando duas liberacao
	lPri := .T.
	DbSelectArea("SCR")
	DbSetOrder(1)
	DbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM )
	
	if ! SCR->(EOF())

		While SCR->(!Eof()) .And. Alltrim(SCR->CR_NUM) == SC7->C7_NUM
	
			If SCR->CR_STATUS # "02"
				DbSkip()
				Loop
			EndIf
	
			If lPri
				lPri := .F.
			Else
				Reclock("SCR",.F.)
				SCR->CR_STATUS := "01"
				MsUnlock()
			EndIf
	
			DbSkip()
	
		End
	ENDIF
	
	IF SM0->M0_CODIGO == "01"
		//Verifico se existe tem a Marina como aprovadora no pedido
		If lDsRh

			lTemAprov := .F.

			DbSelectArea("SCR")
			DbSetorder(1)
			DbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM )
			
			if ! SCR->(EOF())

			While SCR->(!Eof()) .And. Alltrim(SCR->CR_NUM) == SC7->C7_NUM

				If SCR->CR_APROV # "000053"
					DbSkip()
					Loop
				EndIf

				lTemAprov := .T.

				DbSkip()

			End
			ENDIF
			
			If !lTemAprov

				SAK->(DbSetOrder(1))
				SAK->(DbSeek(xFilial("SAK")+"000053" ))

				DbSelectArea("SCR")
				RecLock("SCR",.T.)
				SCR->CR_FILIAL := xFilial("SCR")
				SCR->CR_TIPO   := "PC"
				SCR->CR_NUM    := SC7->C7_NUM
				SCR->CR_USER   := SAK->AK_USER
				SCR->CR_APROV  := "000053"
				SCR->CR_NIVEL  := "35"  //Para ficar depois do preposto da obra
				SCR->CR_STATUS := "01"
				SCR->CR_TOTAL  := nVlrPed
				MsUnlock()
			EndIf

		EndIf

		//Verifico se existe tem a Marina como aprovadora no pedido
		If lEpis

			lTemAprov := .F.

			DbSelectArea("SCR")
			DbSetorder(1)
			DbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM )
			if ! SCR->(EOF())
			While SCR->(!Eof()) .And. Alltrim(SCR->CR_NUM) == SC7->C7_NUM

				If SCR->CR_APROV # "000033"
					DbSkip()
					Loop
				EndIf

				lTemAprov := .T.

				DbSkip()

			End
			ENDIF
			If !lTemAprov

				SAK->(DbSetOrder(1))
				SAK->(DbSeek(xFilial("SAK")+"000033" ))

				DbSelectArea("SCR")
				DbSetorder(1)
				DbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM )

				DbSelectArea("SCR")
				RecLock("SCR",.T.)
				SCR->CR_FILIAL := xFilial("SCR")
				SCR->CR_TIPO   := "PC"
				SCR->CR_NUM    := SC7->C7_NUM
				SCR->CR_USER   := SAK->AK_USER
				SCR->CR_APROV  := "000033"
				SCR->CR_NIVEL  := "35"  //Para ficar depois do preposto da obra
				SCR->CR_STATUS := "01"
				SCR->CR_TOTAL  := nVlrPed
				MsUnlock()
			EndIf

		EndIf

	ENDIF
	
	CONOUT("PASSEI SCR")

	//Verifico se os aprovadores esta todos aptos a receber o workflow

	DbSelectArea("SCR")
	DbSetorder(1)
	DbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM )
	if ! SCR->(EOF())
	While SCR->(!Eof()) .And. Alltrim(SCR->CR_NUM) == SC7->C7_NUM

		SAK->(DbSetOrder(1))
		SAK->(DbSeek(xFilial("SAK")+SCR->CR_APROV ))

		If SAK->AK_SUSAPRO == "S"

			Reclock("SCR",.F.)
			SCR->(DbDelete())
			MsUnlock()

		EndIf

		DbSkip()

	End
	ENDIF
	//Verifico se o pedido esta aguardando duas liberacao
	/*	lStaAprov := .F.
	DbSelectArea("SCR")
	DbSetOrder(1)
	DbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM )

	While SCR->(!Eof()) .And. Alltrim(SCR->CR_NUM) == SC7->C7_NUM

	If SCR->CR_STATUS == "02"
	lStaAprov := .T.
	Exit
	EndIf

	DbSkip()

	End

	If !lStaAprov

	DbSelectArea("SCR")
	DbSetOrder(1)
	If DbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM )
	Reclock("SCR",.F.)
	SCR->CR_STATUS := "02"
	MsUnlock()

	EndIf
	EndIf
	*/
	If MsgYesno("Ser„o anexados documentos no pedido" )

		MsgInfo("VocÍ dever· anexar os documentos e reenviar o workflow.")
		Return

		//U_AnexaDoc()

	EndIf

	// Return

	DbSelectArea("SC7")
	DbSetOrder(1)
	DbSeek(xFilial()+ca120num)

	//Envia o Workflow de aprovacao de pedido
	U_EnvWFPed()

	CONOUT("PASSEI SCR")

	Return

	cEmailCo := ""

	cQuery1 := " UPDATE "+retsqlname("SCR")
	cQuery1 += " SET CR_WF = '1' "
	cQuery1 += " WHERE CR_NUM = '"+cPedido+"' AND CR_STATUS = '02' AND CR_FILIAL = '"+cFil+"' AND "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' "

	TcSqlExec(cQuery1)

	cAliasTop2 := GetNextAlias()

	cQuery2 := " SELECT DISTINCT  C7_FILIAL, C7_ITEM, C7_NUM, A2_COD + ' - ' +A2_NOME AS A2_NOME, C7_EMISSAO, C7_USER, C7_PRODUTO,C7_NUMSC, C7_TXMOEDA, C7_MOEDA, C7_DTPGTO , "
	cQuery2 += " C7_DESCRI + ' - '+C7_OBS AS C7_DESCRI, C7_UM, C7_QUANT, C7_PRECO, C7_TOTAL, E4_DESCRI, C7_IPI, C7_DATPRF, C7_OBS, C7_OBSPED, C7_VERSAO, "
	cQuery2 += " C7_CC, C7_FRETE, C7_DESPESA, C7_VALFRE, C7_DESC, CR_USER, CR_NIVEL, CR_APROV, CR_USERLIB, CR_LIBAPRO, CR_USERORI, CR_APRORI, CR_TOTAL "
	cQuery2 += " FROM "+retsqlname("SC7")+" INNER JOIN "+retsqlname("SA2")+" ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA "
	cQuery2 += " INNER JOIN "+retsqlname("SE4")+" ON E4_CODIGO = C7_COND "
	cQuery2 += " INNER JOIN "+retsqlname("SCR")+" ON CR_NUM = C7_NUM AND CR_FILIAL = C7_FILIAL "
	cQuery2 += " WHERE "+retsqlname("SC7")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SA2")+".D_E_L_E_T_ <> '*' "
	cQuery2 += " AND "+retsqlname("SE4")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' AND C7_NUM = '"+cPedido+"' "
	cQuery2 += " AND CR_STATUS = '02' "

	dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuery2),cAliasTop2,.F.,.T.)

	dbSelectArea(cAliasTop2)
	DBGOTOP()
	if ! empty((cALIASTOP2)->C7_NUMSC)
		SC1->(DBSEEK(XFILIAl("SC1")+(cALIASTOP2)->C7_NUMSC ))

		cSolic := sc1->c1_solicit
	else
		cSolic := ""
	endif

	cNomeAp := UsrFullName((cALIASTOP2)->CR_USER)
	cAprovador := (cALIASTOP2)->CR_USER
	cNomeCo := UsrFullName((cALIASTOP2)->C7_USER)
	cVersao := (cALIASTOP2)->C7_VERSAO

	//para enviar copia de email
	SB1->(DBSEEK(XFILIAL("SB1")+(cALIASTOP2)->C7_PRODUTO ))
	cGrupo := sb1->b1_grupo
	do case
		case cGrupo == "LOCA"
		cEmailCo := "michelle.miranda@sacseng.com.br"
	EndCase

	If  nVlr_PA > 0 //lAntCxa .Or.
		cEmailCo := "" //"andre.souza@sacseng.com.br"
	EndIf

	aAttach := {}
	cAttach := ""
	lPri    := .T.
	cPath   := "\co01\shared\"

	DbSelectArea("AC9")
	DbSetOrder(2)
	If DbSeek(xFilial("AC9")+"SC7"+SC7->C7_FILIAL+SC7->C7_FILIAL+SC7->C7_NUM )

		While AC9->(!Eof()) .And. Substr(AC9->AC9_CODENT,1,8) ==  SC7->C7_FILIAL+SC7->C7_NUM

			DbSelectArea("ACB")
			DbSetOrder(1)
			DbSeek(xFilial("ACB")+AC9->AC9_CODOBJ )

			AaDd(aAttach,{Alltrim(ACB->ACB_DESCRI)+".PDF" } )

			DbSelectArea("AC9")
			AC9->(DbSkip())

		End
	EndIf

	CONOUT ("*****|| "+DTOC(DATE())+" - " + TIME())
	CONOUT ("*****|| Iniciando processo WorkFlow/Aprovacao Pedido de Compras")
	CONOUT ("*****|| Pedido : "+cPedido+" *****||")

	oWF := TWFProcess():New('PEDCOM01','Envio Aprovacao PC:' + cPedido + "/" +(cALIASTOP2)->CR_NIVEL)
	oWF:cPriority := "3"
	IF ALTERA
		IF sc7->c7_tipped == "3"
			oWF:NewTask("Envio PC:" + cPedido ,"\WORKFLOW\HTML\wfpcFIN.HTM" )
		ELSE
			//oWF:NewTask("Envio PC:" + cPedido ,"\WORKFLOW\HTML\wfpcalt.HTM" )
			oWF:NewTask("Envio PC:" + cPedido ,"\WORKFLOW\HTML\wfpc.HTM" )
		ENDIF
	ELSE
		IF sc7->c7_tipped == "3"
			oWF:NewTask("Envio PC:" + cPedido ,"\WORKFLOW\HTML\wfpcFIN.HTM" )
		ELSE
			oWF:NewTask("Envio PC:" + cPedido ,"\WORKFLOW\HTML\wfpc.HTM" )
		ENDIF

	ENDIF
	oWF:bReturn := "U_WfPcRet"
	oWF:cTo := "\workflow\"
	if ALTERA
		oWF:cSubject := "AprovaÁ„o de AlteraÁ„o de Pedido de Compras "+cPedido+" / "+cVersao
	else
		oWF:cSubject := "AprovaÁ„o de Inclus„o de Pedido de Compras "+cPedido
	endif

	CONOUT ("*****GERANDO CABECALHO DO PEDIDO******")

	oWF:oHtml:ValByName( "cEmpresa"	    , cEmpresa )
	oWF:oHtml:ValByName( "cNomeEmp"	    , cNomeEmp )
	oWF:oHtml:ValByName( "cFil"	        , cFil)
	oWF:oHtml:ValByName( "cPedido"	    , cPedido )
	oWF:oHtml:ValByName( "dEmissao"     , STOD((cALIASTOP2)->C7_EMISSAO) )
	oWF:oHtml:ValByName( "cFornece"	    , (cALIASTOP2)->A2_NOME)
	oWF:oHtml:ValByName( "dTPagto"	    , STOD((cALIASTOP2)->C7_DTPGTO)  )

	oWF:oHtml:ValByName( "cComprador"   ,  cNomeCo    )
	oWF:oHtml:ValByName( "cAprovador"   ,  cNomeAp    )
	oWF:oHtml:ValByName( "cPag"         , (cALIASTOP2)->E4_DESCRI)
	oWF:oHtml:ValByName( "cSolic"       , cSolic )
	oWF:oHtml:ValByName( "obsped"       , (cALIASTOP2)->C7_OBS )
	oWF:oHtml:ValByName( "CONGERPED"    , (cALIASTOP2)->C7_OBSPED )

	if (cALIASTOP2)->C7_MOEDA == 1
		oWF:oHtml:ValByName( "nTotalr"	    , TRANSFORM((cALIASTOP2)->CR_TOTAL,'@E 999,999,999.99'))
		oWF:oHtml:ValByName( "nTaxa"	    , TRANSFORM((cALIASTOP2)->C7_TXMOEDA,'@E 999,999,999.99'))
		oWF:oHtml:ValByName( "nTotald"	    , TRANSFORM(0,'@E 999,999,999.99'))
	else
		oWF:oHtml:ValByName( "nTotalr"	    , TRANSFORM((cALIASTOP2)->CR_TOTAL*(cALIASTOP2)->C7_TXMOEDA,'@E 999,999,999.99'))
		oWF:oHtml:ValByName( "nTaxa"	    , TRANSFORM((cALIASTOP2)->C7_TXMOEDA,'@E 999,999,999.99'))
		oWF:oHtml:ValByName( "nTotald"	    , TRANSFORM((cALIASTOP2)->CR_TOTAL,'@E 999,999,999.99'))
	endif
	oWF:oHtml:ValByName( "CR_USER"      ,  AllTrim((cALIASTOP2)->CR_USER))
	oWF:oHtml:ValByName( "CR_APROV"     ,  AllTrim((cALIASTOP2)->CR_APROV))

	CONOUT ("*****GERANDO ITENS DO PEDIDO******")
	cProd := ""
	While !(cAliasTop2)->(EOF())
		aadd(oWF:oHtml:ValByName("t1.cCod"    ), (cALIASTOP2)->C7_PRODUTO)
		aadd(oWF:oHtml:ValByName("t1.cDescri" ), (cALIASTOP2)->C7_DESCRI)
		aadd(oWF:oHtml:ValByName("t1.cUm"     ), (cALIASTOP2)->C7_UM)
		aadd(oWF:oHtml:ValByName("t1.nQuant"  ), TRANSFORM((cALIASTOP2)->C7_QUANT,'@E 999,999.9999'))
		aadd(oWF:oHtml:ValByName("t1.nIPI"    ), TRANSFORM((cALIASTOP2)->C7_IPI,'@E 99.99'))
		aadd(oWF:oHtml:ValByName("t1.nTotal"  ), TRANSFORM((cALIASTOP2)->C7_TOTAL,'@E 999,999,999.99'))

		if (cALIASTOP2)->C7_moeda == 1
			aadd(oWF:oHtml:ValByName("t1.nUnitr"   ), TRANSFORM((cALIASTOP2)->C7_PRECO,'@E 999,999.9999'))
			aadd(oWF:oHtml:ValByName("t1.nUnitd"   ), TRANSFORM(0,'@E 999,999.9999'))
		else
			aadd(oWF:oHtml:ValByName("t1.nUnitd"   ), TRANSFORM((cALIASTOP2)->C7_PRECO,'@E 999,999.9999'))
			aadd(oWF:oHtml:ValByName("t1.nUnitr"   ), TRANSFORM((cALIASTOP2)->C7_PRECO*(cALIASTOP2)->C7_TXMOEDA,'@E 999,999.9999'))

		endif

		aadd(oWF:oHtml:ValByName("t1.dEnt"    ), STOD((cALIASTOP2)->C7_DATPRF))
		aadd(oWF:oHtml:ValByName("t1.cCusto"  ), (cALIASTOP2)->C7_CC)

		nTotal := nTotal + (cALIASTOP2)->C7_TOTAL
		nDespesas := nDespesas +(cALIASTOP2)->C7_FRETE + (cALIASTOP2)->C7_DESPESA + (cALIASTOP2)->C7_VALFRE
		nDesconto := nDesconto + (cALIASTOP2)->C7_DESC

		nPesq := Ascan(aProdutos,{|x|x[1] = (cALIASTOP2)->C7_PRODUTO } )
		If nPesq == 0
			Aadd(aProdutos,{ (cALIASTOP2)->C7_PRODUTO} )
		endif
		(cAliasTop2)->(DBSkip())
	EndDo

	oWF:oHtml:ValByName("nValMerc"  , TRANSFORM(nTotal,'@E 999,999,999.99'))
	oWF:oHtml:ValByName("nFrete"    , TRANSFORM(nDespesas,'@E 999,999.99'))
	oWF:oHtml:ValByName("nDesc"     , TRANSFORM(nDesconto,'@E 999,999.99'))

	cAliasTop3 := GetNextAlias()

	aSC7 := {}
	For j = 1 to len(aProdutos)

		cQuery3 := " SELECT TOP 3 C7_FILIAL, C7_ITEM, C7_PRODUTO, C7_NUM, C7_FORNECE, C7_LOJA, A2_NOME, C7_QUANT, C7_CC , "
		cQuery3 += " C7_PRECO, C7_IPI , C7_EMISSAO, C7_DATPRF, C7_COND, E4_DESCRI, C7_QUJE "
		cQuery3 += " FROM "+retsqlname("SC7")+" C7 "
		cQuery3 += " INNER JOIN "+retsqlname("SA2")+" A2 ON "
		cQuery3 += " 	C7_FORNECE = A2_COD AND "
		cQuery3 += " 	C7_LOJA = A2_LOJA AND  "
		cQuery3 += " 	A2.D_E_L_E_T_='' "
		cQuery3 += " INNER JOIN "+retsqlname("SE4")+" E4 ON "
		cQuery3 += " 	C7_COND = E4_CODIGO AND "
		cQuery3 += " 	E4.D_E_L_E_T_='' "
		cQuery3 += " INNER JOIN "+retsqlname("SB1")+" B1 ON "
		cQuery3 += " 	B1.D_E_L_E_T_='' AND "
		cQuery3 += " 	B1_COD=C7_PRODUTO AND "
		//cQuery3 += " 	B1_TIPO not in ('GG') AND "
		cQuery3 += " 	B1_FILIAL='" + xFilial("SB1") + "' "
		cQuery3 += " WHERE C7_FILIAL =  '"+cFil+"' AND  C7_PRODUTO='"+aProdutos[j,1]+"' AND C7_QUJE <> 0 " //AND C7_ENCER <> ' ' "
		cQuery3 += " AND C7.D_E_L_E_T_ <> '*' "
		cQuery3 += " ORDER BY C7_EMISSAO DESC "

		dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuery3),cAliasTop3,.T.,.T.)

		DbSelectArea(cAliasTop3)
		dbGoTop()

		While !Eof()
			Aadd( aSC7, {(cAliasTop3)->C7_PRODUTO , ;
			(cAliasTop3)->C7_NUM , ;
			(cAliasTop3)->A2_NOME, ;
			TRANSFORM((cAliasTop3)->C7_QUANT,'@E 999,999.999'), ;
			TRANSFORM((cAliasTop3)->C7_PRECO,'@E 999,999.99') , ;
			TRANSFORM((cAliasTop3)->C7_IPI ,'@E 999,999.99')  , ;
			DtoC(StoD((cAliasTop3)->C7_EMISSAO)) , ;
			(cAliasTop3)->C7_CC  , ;
			(cAliasTop3)->E4_DESCRI} )
			lPedidos := .T.
			(cAliasTop3)->(DBSkip())
		EndDo

		DbSelectArea(cALIASTOP3)
		DbCloseArea(cAliasTop3)

	Next
	If !lPedidos
		cExibe  := "<p><font color='#FF0000'>*** N„o h· historico de pedidos ***</font></p>"
		aadd(oWF:oHtml:ValByName("t2.cCod"      ),"--")
		aadd(oWF:oHtml:ValByName("t2.cPedido"   ),"--")
		aadd(oWF:oHtml:ValByName("t2.Fornece"   ),"--")
		aadd(oWF:oHtml:ValByName("t2.nQuant"    ),"--")
		aadd(oWF:oHtml:ValByName("t2.nUnit"     ),"--")
		aadd(oWF:oHtml:ValByName("t2.nIPI"      ),"--")
		aadd(oWF:oHtml:ValByName("t2.dEmissao"  ),"--")
		aadd(oWF:oHtml:ValByName("t2.cCusto"  ),"--")
		aadd(oWF:oHtml:ValByName("t2.cPgto"     ),"--")

	Else
		cItem := ""
		For j := 1 To Len(aSC7)
			aadd(oWF:oHtml:ValByName("t2.cCod"      ),aSC7[j][1])
			aadd(oWF:oHtml:ValByName("t2.cPedido"   ),aSC7[j][2])
			aadd(oWF:oHtml:ValByName("t2.Fornece"   ),aSC7[j][3])
			aadd(oWF:oHtml:ValByName("t2.nQuant"    ),aSC7[j][4])
			aadd(oWF:oHtml:ValByName("t2.nUnit"     ),aSC7[j][5])
			aadd(oWF:oHtml:ValByName("t2.nIPI"      ),aSC7[j][6])
			aadd(oWF:oHtml:ValByName("t2.dEmissao"  ),aSC7[j][7])
			aadd(oWF:oHtml:ValByName("t2.cCusto"  ),aSC7[j][8])
			aadd(oWF:oHtml:ValByName("t2.cPgto"     ),aSC7[j][9])
			cItem := aSC7[j][1]
		Next
	EndIf

	IF sc7->c7_tipped == "3"
		aadd(oWF:oHtml:ValByName("t4.prefixo"     ), "--")
		aadd(oWF:oHtml:ValByName("t4.titulo"      ), "--")
		aadd(oWF:oHtml:ValByName("t4.valor"       ), "--")
		aadd(oWF:oHtml:ValByName("t4.emissao"     ), "--")

		aadd(oWF:oHtml:ValByName("t4.vencimento"  ), "--" )
		aadd(oWF:oHtml:ValByName("t4.dtprevpagto" ), "--" )
	endif

	For nX := 1 to Len(aAttach)
		cArquivo := aAttach[nX]
		If !Empty(cArquivo)
			aadd(oWF:oHtml:ValByName("t5.arquivos" ),cPath)
			aadd(oWF:oHtml:ValByName("t5.anexos" ),cArquivo )
		EndIf
	Next

	cAliasTop5 := GetNextAlias()

	cQuerySCR := " SELECT CR_NUM, CR_USER, AK_NOME, CR_NIVEL, CR_STATUS, CR_DATALIB, CR_OBS "
	cQuerySCR += " FROM "+retsqlname("SCR")+" INNER JOIN "+RETSQLNAME("SAK")+" ON CR_USER = AK_USER "
	cQuerySCR += " WHERE "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SAK")+".D_E_L_E_T_ <> '*' "
	cQuerySCR += " AND CR_NUM = '"+cPedido+"' AND CR_FILIAL = '"+cFil+"' "

	dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuerySCR),cAliasTop5,.T.,.T.)

	While !(cAliasTop5)->(EOF())

		Do Case
			Case (cALIASTOP5)->CR_STATUS = "01"
			cStatus:= "Nivel Bloqueado"
			Case (cALIASTOP5)->CR_STATUS = "02"
			cStatus:= "Aguardando Liberacao"
			Case (cALIASTOP5)->CR_STATUS = "03"
			cStatus:= "Pedido Aprovado"
			Case (cALIASTOP5)->CR_STATUS = "04"
			cStatus:= "Pedido Bloqueado"
		EndCase

		aadd(oWF:oHtml:ValByName("t3.cNivel"     ), (cALIASTOP5)->CR_NIVEL)
		aadd(oWF:oHtml:ValByName("t3.cAprovador" ), (cALIASTOP5)->AK_NOME)
		aadd(oWF:oHtml:ValByName("t3.cStatus"    ),  cStatus)
		aadd(oWF:oHtml:ValByName("t3.dDataLib"   ),  STOD((cALIASTOP5)->CR_DATALIB))
		aadd(oWF:oHtml:ValByName("t3.Obs"        ), (cALIASTOP5)->CR_OBS)

		(cAliasTop5)->(DBSkip())
	EndDo

	cHtml := oWF:Start("\workflow\emp"+SM0->M0_CODIGO+"\tp\")

	cLinkext := GetMV("MV_WFHTTPE")+"/emp"+SM0->M0_CODIGO+"/tp/"+cHtml+".htm"
	cLinkint := GetMV("MV_WFHTTPI")+"/emp"+SM0->M0_CODIGO+"/tp/"+cHtml+".htm"

	CONOUT ("*****Modelo Configurado******")
	oWF:NewTask("Criando Link","\workflow\html\link_.htm")
	oWF:cTo  := UsrRetMail(cAprovador)
	oWF:cBCC := cEmailCo
	oWF:oHtml:ValByName("cLinkext" , cLinkext)
	oWF:oHtml:ValByName("cLinkint" , cLinkint)

	oWF:Start()
	CONOUT ("*****criando link******")

	//	EndIf

	cEmailCo := ""

	If nTipo == 5

		cAliasTop9 := GetNextAlias()

		cQuery2 := " SELECT CR_FILIAL, CR_NUM, CR_TIPO, CR_USER, CR_APROV, CR_NIVEL, CR_STATUS, CR_DATALIB, CR_WF
		cQuery2 += " FROM "+retsqlname("SCR")
		cQuery2 += " WHERE CR_NUM = '"+cPedido+"' AND "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' "

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAliasTop9,.T.,.T.)

		conout("query select top na exclusao : "+cquery2 )

		CONOUT ("Enviando retorno de exclusao de pedido de compra : "+cPedido+ " Filial: "+cFil)
		Conout("-->pedido de compra "+cPedido+" excluida.<--")
		Conout("***Retorno de Status para Vendedor***")

		CONOUT ("*****|| "+DTOC(DATE())+" - " + TIME())
		CONOUT ("*****|| Iniciando processo WorkFlow/Eclusao de pedido de compra ")
		CONOUT ("*****|| Pedido n. : "+cPedido+" *****||")

		cMailAprov := ""

		If !EMPTY((cALIASTOP9)->CR_NUM)

			Conout("***Iniciando processo de envio de novo email para EXCLUSAO DE PEDIDO***")

			dbSelectArea(cAliasTop9)
			DBGOTOP()

			cNomeAp := UsrFullName((cALIASTOP9)->CR_USER)
			cAprovador := (cALIASTOP9)->CR_USER
			cMailAprov := ""
			nQ         := 1
			do while ! (cALIASTOP9)->(eof())
				if nq == 1
					cMailAprov += alltrim(UsrRetMail((cALIASTOP9)->CR_USER))
					nq++
				else
					cMailAprov += ";"+alltrim(UsrRetMail((cALIASTOP9)->CR_USER))
					nq++

				endif
				(cALIASTOP9)->(dbskip())

			enddo

			dbSelectArea(cAliasTop9)
			(cAliasTop9)->(DBGOTOP())

		ENDIF

		cAliasTop2 := GetNextAlias()

		cQuery2 := " SELECT DISTINCT  C7_FILIAL, C7_ITEM, C7_NUM, A2_COD + ' - ' +A2_NOME AS A2_NOME, C7_EMISSAO, C7_USER, C7_PRODUTO,C7_NUMSC, C7_TXMOEDA, C7_MOEDA,  C7_DTPGTO , "
		cQuery2 += " C7_DESCRI + ' - '+C7_OBS AS C7_DESCRI, C7_UM, C7_QUANT, C7_PRECO, C7_TOTAL, E4_DESCRI, C7_IPI, C7_DATPRF, C7_OBS, C7_TIPPED, C7_CONAPRO, C7_OBSPED,  "
		cQuery2 += " C7_CC, C7_FRETE, C7_DESPESA, C7_VALFRE, C7_DESC, CR_USER, CR_NIVEL, CR_APROV, CR_USERLIB, CR_LIBAPRO, CR_USERORI, CR_APRORI, CR_TOTAL "
		cQuery2 += " FROM "+retsqlname("SC7")+" INNER JOIN "+retsqlname("SA2")+" ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA "
		cQuery2 += " INNER JOIN "+retsqlname("SE4")+" ON E4_CODIGO = C7_COND "
		cQuery2 += " INNER JOIN "+retsqlname("SCR")+" ON CR_NUM = C7_NUM AND CR_FILIAL = C7_FILIAL "
		cQuery2 += " WHERE "+retsqlname("SC7")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SA2")+".D_E_L_E_T_ <> '*' "
		cQuery2 += " AND "+retsqlname("SE4")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' AND C7_NUM = '"+cPedido+"' "

		dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuery2),cAliasTop2,.F.,.T.)

		dbSelectArea(cAliasTop2)
		DBGOTOP()

		if sc7->c7_tipped == "3" .and. SC7->C7_CONAPRO == "L"
			aAdd(aArray,{ "E2_PREFIXO" , "PED" , NIL })
			aAdd(aArray,{ "E2_NUM" , SC7->C7_NUM , NIL })
			aAdd(aArray,{ "E2_TIPO" , "PA" , NIL })
			aAdd(aArray,{ "E2_NATUREZ" , "21210917" , NIL })
			aAdd(aArray,{ "E2_FORNECE" , SC7->C7_FORNECE , NIL })
			aAdd(aArray,{ "E2_EMISSAO" , ddatabase , NIL })
			aAdd(aArray,{ "E2_VENCTO" , ddatabase+5, NIL })
			aAdd(aArray,{ "E2_VENCREA" , ddatabase+5, NIL })
			aAdd(aArray,{ "E2_VALOR" , sc7->c7_total , NIL })
			aAdd(aArray,{ "AUTBANCO" , "237" , NIL })
			aAdd(aArray,{ "AUTAGENCIA" , "3374" , NIL })
			aAdd(aArray,{ "AUTCONTA" , "1161407" , NIL })

			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 5) // 3 - Inclusao, 4 - AlteraÁ„o, 5 - Exclus„o

			If lMsErroAuto
				MostraErro()
			Else
				CONOUT("TÌtulo de adiantamento EXCLUIDO com sucesso!")
			Endif

		ENDIF

		if ! empty((cALIASTOP2)->C7_NUMSC)
			SC1->(DBSEEK(XFILIAl("SC1")+(cALIASTOP2)->C7_NUMSC ))

			cSolic := sc1->c1_solicit
		else
			cSolic := ""
		endif
		cEmailCo := ""

		//para enviar copia de email
		SB1->(DBSEEK(XFILIAL("SB1")+(cALIASTOP2)->C7_PRODUTO ))
		cGrupo := sb1->b1_grupo
		do case
			case cGrupo == "LOCA"
			cEmailCo := "michelle.miranda@sacseng.com.br"
		endcase

		cNomeAp := UsrFullName((cALIASTOP2)->CR_USER)
		cAprovador := (cALIASTOP2)->CR_USER
		cNomeCo := UsrFullName((cALIASTOP2)->C7_USER)

		CONOUT ("*****|| "+DTOC(DATE())+" - " + TIME())
		CONOUT ("*****|| Iniciando processo WorkFlow/Aprovacao Pedido de Compras")
		CONOUT ("*****|| Pedido : "+cPedido+" *****||")

		oWF := TWFProcess():New('PEDCOM01','Envio Aprovacao PC:' + cPedido + "/" +(cALIASTOP2)->CR_NIVEL)
		oWF:cPriority := "3"
		IF (cALIASTOP2)->C7_TIPPED == "3"
			oWF:NewTask("Envio PC:" + cPedido ,"\WORKFLOW\HTML\wfpcFIN.HTM" )
		ELSE
			oWF:NewTask("Envio PC:" + cPedido ,"\WORKFLOW\HTML\wfpc.HTM" )
		ENDIF
		oWF:bReturn  := "U_WfPcRet"
		oWF:cTo      := "\workflow\"
		oWF:cBCC     := cEmailCo
		oWF:cSubject := "Exclusao de Pedido de Compras "+cPedido

		CONOUT ("*****GERANDO CABECALHO DO PEDIDO******")

		oWF:oHtml:ValByName( "cEmpresa"	    , cEmpresa )
		oWF:oHtml:ValByName( "cNomeEmp"	    , cNomeEmp )
		oWF:oHtml:ValByName( "cFil"	        , cFil)
		oWF:oHtml:ValByName( "cPedido"	    , cPedido )
		oWF:oHtml:ValByName( "dEmissao"     , STOD((cALIASTOP2)->C7_EMISSAO) )
		oWF:oHtml:ValByName( "cFornece"	    , (cALIASTOP2)->A2_NOME)
		oWF:oHtml:ValByName( "cComprador"   ,  cNomeCo    )
		oWF:oHtml:ValByName( "cAprovador"   ,  cNomeAp    )
		oWF:oHtml:ValByName( "dTPagto"	    , STOD((cALIASTOP2)->C7_DTPGTO) )
		oWF:oHtml:ValByName( "cPag"         , (cALIASTOP2)->E4_DESCRI)
		oWF:oHtml:ValByName( "cSolic"       , cSolic )
		oWF:oHtml:ValByName( "obsped"       , (cALIASTOP2)->C7_OBS )
		oWF:oHtml:ValByName( "CONGERPED"    , (cALIASTOP2)->C7_OBSPED )

		if (cALIASTOP2)->C7_MOEDA == 1
			oWF:oHtml:ValByName( "nTotalr"	    , TRANSFORM((cALIASTOP2)->CR_TOTAL,'@E 999,999,999.99'))
			oWF:oHtml:ValByName( "nTaxa"	    , TRANSFORM((cALIASTOP2)->C7_TXMOEDA,'@E 999,999,999.99'))
			oWF:oHtml:ValByName( "nTotald"	    , TRANSFORM(0,'@E 999,999,999.99'))
		else
			oWF:oHtml:ValByName( "nTotalr"	    , TRANSFORM((cALIASTOP2)->CR_TOTAL*(cALIASTOP2)->C7_TXMOEDA,'@E 999,999,999.99'))
			oWF:oHtml:ValByName( "nTaxa"	    , TRANSFORM((cALIASTOP2)->C7_TXMOEDA,'@E 999,999,999.99'))
			oWF:oHtml:ValByName( "nTotald"	    , TRANSFORM((cALIASTOP2)->CR_TOTAL,'@E 999,999,999.99'))
		endif

		oWF:oHtml:ValByName( "CR_USER"      ,  AllTrim((cALIASTOP2)->CR_USER))
		oWF:oHtml:ValByName( "CR_APROV"     ,  AllTrim((cALIASTOP2)->CR_APROV))

		CONOUT ("*****GERANDO ITENS DO PEDIDO******")

		(cALIASTOP2)->(dbgotop())

		While !(cAliasTop2)->(EOF()) //While !EOF()
			aadd(oWF:oHtml:ValByName("t1.cCod"    ), (cALIASTOP2)->C7_PRODUTO)
			aadd(oWF:oHtml:ValByName("t1.cDescri" ), (cALIASTOP2)->C7_DESCRI)
			aadd(oWF:oHtml:ValByName("t1.cUm"     ), (cALIASTOP2)->C7_UM)
			aadd(oWF:oHtml:ValByName("t1.nQuant"  ), TRANSFORM((cALIASTOP2)->C7_QUANT,'@E 999,999.9999'))
			aadd(oWF:oHtml:ValByName("t1.nTotal"   ), TRANSFORM((cALIASTOP2)->C7_TOTAL,'@E 999,999,999.99'))
			if (cALIASTOP2)->C7_moeda == 1
				aadd(oWF:oHtml:ValByName("t1.nUnitr"   ), TRANSFORM((cALIASTOP2)->C7_PRECO,'@E 999,999.9999'))
				aadd(oWF:oHtml:ValByName("t1.nUnitd"   ), TRANSFORM(0,'@E 999,999.9999'))
			else
				aadd(oWF:oHtml:ValByName("t1.nUnitr"   ), TRANSFORM((cALIASTOP2)->C7_PRECO*(cALIASTOP2)->C7_TXMOEDA,'@E 999,999.9999'))
				aadd(oWF:oHtml:ValByName("t1.nUnitd"   ), TRANSFORM((cALIASTOP2)->C7_PRECO,'@E 999,999.9999'))

			endif
			aadd(oWF:oHtml:ValByName("t1.nIPI"    ), TRANSFORM((cALIASTOP2)->C7_IPI,'@E 99.99'))
			aadd(oWF:oHtml:ValByName("t1.nTotal"  ), TRANSFORM((cALIASTOP2)->C7_TOTAL,'@E 999,999,999.99'))
			aadd(oWF:oHtml:ValByName("t1.dEnt"    ), STOD((cALIASTOP2)->C7_DATPRF))
			aadd(oWF:oHtml:ValByName("t1.cCusto"  ), (cALIASTOP2)->C7_CC)

			nTotal := nTotal + (cALIASTOP2)->C7_TOTAL
			nDespesas := nDespesas +(cALIASTOP2)->C7_FRETE + (cALIASTOP2)->C7_DESPESA + (cALIASTOP2)->C7_VALFRE
			nDesconto := nDesconto + (cALIASTOP2)->C7_DESC

			nPesq := Ascan(aProdutos,{|x|x[1] = (cALIASTOP2)->C7_PRODUTO } )
			If nPesq == 0
				Aadd(aProdutos,{ (cALIASTOP2)->C7_PRODUTO} )
			endif

			//			Aadd(aProdutos,{ (cALIASTOP2)->C7_PRODUTO} )

			(cAliasTop2)->(DBSkip())

		EndDo

		oWF:oHtml:ValByName("nValMerc"  , TRANSFORM(nTotal,'@E 999,999,999.99'))
		oWF:oHtml:ValByName("nFrete"    , TRANSFORM(nDespesas,'@E 999,999.99'))
		oWF:oHtml:ValByName("nDesc"     , TRANSFORM(nDesconto,'@E 999,999.99'))

		cAliasfin := GetNextAlias()

		cQuery2 := " SELECT *  "
		cQuery2 += " FROM "+retsqlname("SE2")+" "
		cQuery2 += " WHERE E2_NUM = '"+cPedido+"' AND E2_PREFIXO = 'PED' AND E2_TIPO = 'PA' AND D_E_L_E_T_ <> '*' "

		dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuery2),cAliasFIN,.F.,.T.)

		CONOUT ("*****GERANDO TITULO FINANCEIRO******")
		cProd := ""
		While !(cAliasFIN)->(EOF())
			aadd(oWF:oHtml:ValByName("t4.prefixo"     ), (cALIASfin)->E2_PREFIXO)
			aadd(oWF:oHtml:ValByName("t4.titulo"      ), (cALIASfin)->E2_NUM)
			aadd(oWF:oHtml:ValByName("t4.valor"       ), TRANSFORM((cALIASfin)->E2_VALOR,'@E 999,999.9999'))
			aadd(oWF:oHtml:ValByName("t4.emissao"     ), STOD((cALIASFIN)->E2_EMISSAO))

			aadd(oWF:oHtml:ValByName("t4.vencimento"  ), STOD((cALIASFIN)->E2_VENCTO) )
			aadd(oWF:oHtml:ValByName("t4.dtprevpagto" ), STOD((cALIASFIN)->E2_VENCTO) )

			(cAliasFIN)->(DBSkip())
		EndDo

		cAliasTop3 := GetNextAlias()

		aSC7 := {}
		For j := 1 to len(aProdutos)

			cQuery3 := " SELECT TOP 3 C7_FILIAL, C7_ITEM, C7_PRODUTO, C7_NUM, C7_FORNECE, C7_LOJA, A2_NOME, C7_QUANT, C7_CC, "
			cQuery3 += " C7_PRECO, C7_IPI , C7_EMISSAO, C7_DATPRF, C7_COND, E4_DESCRI, C7_QUJE "
			cQuery3 += " FROM "+retsqlname("SC7")+" C7 "
			cQuery3 += " INNER JOIN "+retsqlname("SA2")+" A2 ON "
			cQuery3 += " 	C7_FORNECE = A2_COD AND "
			cQuery3 += " 	C7_LOJA = A2_LOJA AND  "
			cQuery3 += " 	A2.D_E_L_E_T_='' "
			cQuery3 += " INNER JOIN "+retsqlname("SE4")+" E4 ON "
			cQuery3 += " 	C7_COND = E4_CODIGO AND "
			cQuery3 += " 	E4.D_E_L_E_T_='' "
			cQuery3 += " INNER JOIN "+retsqlname("SB1")+" B1 ON "
			cQuery3 += " 	B1.D_E_L_E_T_='' AND "
			cQuery3 += " 	B1_COD=C7_PRODUTO AND "
			//cQuery3 += " 	B1_TIPO not in ('GG') AND "
			cQuery3 += " 	B1_FILIAL='" + xFilial("SB1") + "' "
			cQuery3 += " WHERE C7_FILIAL =  '"+cFil+"' AND  C7_PRODUTO='"+aProdutos[j,1]+"' AND C7_QUJE <> 0 " //AND C7_ENCER <> ' ' "
			cQuery3 += " AND C7.D_E_L_E_T_ <> '*' "
			cQuery3 += " ORDER BY C7_EMISSAO DESC "

			dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuery3),cAliasTop3,.T.,.T.)

			DbSelectArea(cAliasTop3)
			dbGoTop()

			While !Eof()
				Aadd( aSC7, {(cAliasTop3)->C7_PRODUTO , ;
				(cAliasTop3)->C7_NUM , ;
				(cAliasTop3)->A2_NOME, ;
				TRANSFORM((cAliasTop3)->C7_QUANT,'@E 999,999.999'), ;
				TRANSFORM((cAliasTop3)->C7_PRECO,'@E 999,999.99') , ;
				TRANSFORM((cAliasTop3)->C7_IPI ,'@E 999,999.99')  , ;
				DtoC(StoD((cAliasTop3)->C7_EMISSAO)) , ;
				(cAliasTop3)->C7_CC  , ;
				(cAliasTop3)->E4_DESCRI} )

				lPedidos := .T.
				(cAliasTop3)->(DBSkip())
			EndDo
			DbSelectArea(cALIASTOP3)
			DbCloseArea(cAliasTop3)
		Next
		If !lPedidos
			cExibe  := "<p><font color='#FF0000'>*** N„o h· historico de pedidos ***</font></p>"
			aadd(oWF:oHtml:ValByName("t2.cCod"      ),"--")
			aadd(oWF:oHtml:ValByName("t2.cPedido"   ),"--")
			aadd(oWF:oHtml:ValByName("t2.Fornece"   ),"--")
			aadd(oWF:oHtml:ValByName("t2.nQuant"    ),"--")
			aadd(oWF:oHtml:ValByName("t2.nUnit"     ),"--")
			aadd(oWF:oHtml:ValByName("t2.nIPI"      ),"--")
			aadd(oWF:oHtml:ValByName("t2.dEmissao"  ),"--")
			aadd(oWF:oHtml:ValByName("t2.cCusto"  ),"--")
			aadd(oWF:oHtml:ValByName("t2.cPgto"     ),"--")

		Else
			cItem := ""
			For j := 1 To Len(aSC7)
				aadd(oWF:oHtml:ValByName("t2.cCod"      ),aSC7[j][1])
				aadd(oWF:oHtml:ValByName("t2.cPedido"   ),aSC7[j][2])
				aadd(oWF:oHtml:ValByName("t2.Fornece"   ),aSC7[j][3])
				aadd(oWF:oHtml:ValByName("t2.nQuant"    ),aSC7[j][4])
				aadd(oWF:oHtml:ValByName("t2.nUnit"     ),aSC7[j][5])
				aadd(oWF:oHtml:ValByName("t2.nIPI"      ),aSC7[j][6])
				aadd(oWF:oHtml:ValByName("t2.dEmissao"  ),aSC7[j][7])
				aadd(oWF:oHtml:ValByName("t2.cCusto"  ),aSC7[j][8])
				aadd(oWF:oHtml:ValByName("t2.cPgto"     ),aSC7[j][9])
				cItem := aSC7[j][1]
			Next
		EndIf

		cAliasTop5 := GetNextAlias()

		cQuerySCR := " SELECT CR_NUM, CR_USER, AK_NOME, CR_NIVEL, CR_STATUS, CR_DATALIB, CR_OBS "
		cQuerySCR += " FROM "+retsqlname("SCR")+" INNER JOIN "+RETSQLNAME("SAK")+" ON CR_USER = AK_USER "
		cQuerySCR += " WHERE "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SAK")+".D_E_L_E_T_ <> '*' "
		cQuerySCR += " AND CR_NUM = '"+cPedido+"' AND CR_FILIAL = '"+cFil+"' "

		dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuerySCR),cAliasTop5,.T.,.T.)

		While !(cAliasTop5)->(EOF())

			Do Case
				Case (cALIASTOP5)->CR_STATUS = "01"
				cStatus:= "Nivel Bloqueado"
				Case (cALIASTOP5)->CR_STATUS = "02"
				cStatus:= "Aguardando Liberacao"
				Case (cALIASTOP5)->CR_STATUS = "03"
				cStatus:= "Pedido Aprovado"
				Case (cALIASTOP5)->CR_STATUS = "04"
				cStatus:= "Pedido Bloqueado"
			EndCase

			aadd(oWF:oHtml:ValByName("t3.cNivel"     ), (cALIASTOP5)->CR_NIVEL)
			aadd(oWF:oHtml:ValByName("t3.cAprovador" ), (cALIASTOP5)->AK_NOME)
			aadd(oWF:oHtml:ValByName("t3.cStatus"    ),  cStatus)
			aadd(oWF:oHtml:ValByName("t3.dDataLib"   ),  STOD((cALIASTOP5)->CR_DATALIB))
			aadd(oWF:oHtml:ValByName("t3.Obs"        ), (cALIASTOP5)->CR_OBS)

			(cAliasTop5)->(DBSkip())
		EndDo

		cHtml := oWF:Start("\workflow\emp"+SM0->M0_CODIGO+"\tp\")

		cLinkext := GetMV("MV_WFHTTPE")+"/emp"+SM0->M0_CODIGO+"/tp/"+cHtml+".htm"
		cLinkint := GetMV("MV_WFHTTPI")+"/emp"+SM0->M0_CODIGO+"/tp/"+cHtml+".htm"

		CONOUT ("*****Modelo Configurado******")
		oWF:NewTask("Criando Link","\workflow\html\link_.htm")
		oWF:cTo  := cMailAprov //UsrRetMail(cAprovador)
		oWF:cBCC := cEmailCo
		oWF:oHtml:ValByName("cLinkext" , cLinkext)
		oWF:oHtml:ValByName("cLinkint" , cLinkint)
		oWF:Start()
		CONOUT ("*****criando link******")

	EndIf

	//endif

Return()

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥WFPC0101  ∫Autor  ≥Eduardo Matias      ∫ Data ≥  01/29/12   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Funcao que trata o retorno do pedido de compras            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP11                                                       ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function WfPcRet(oRet)

	Local cPedido    := ""
	Local cFil       := ""
	Local nTotal     := 0
	Local nDespesas  := 0
	Local nDesconto  := 0
	Local cEmpresa   := SM0->M0_CODIGO
	Local cFil       := SM0->M0_CODFIL
	Local cNomeEmp   := SM0->M0_NOME
	Local lPedidos   := .F.
	Local cStatus    := ""
	Local aArray := {}
	Private aProdutos:= {}
	Private lMsErroAuto := .F.

	Private cLinkArq := "http://va8pf4.prd.protheus.totvscloud.com.br:31148/dirdoc"
	cPath   := "/co01/shared/"

	Conout("cEmpresa ="+oRet:oHtml:RetByName("cEmpresa") +"cFil = "+oRet:oHtml:RetByName("cFil"))

	Prepare Environment Empresa AllTrim(oRet:oHtml:RetByName("cEmpresa")) Filial AllTrim(oRet:oHtml:RetByName("cFil"))

	Conout("-->Iniciando Processo de Retorno Pedido de Compras<--")

	cPedido   := AllTrim(oRet:oHtml:RetByName("cPedido"))
	cAprova   := AllTrim(oRet:oHtml:RetByName("APROVA")) //Obtem resposta
	cFil      := AllTrim(oRet:oHtml:RetByName("cFil")) //Obtem resposta
	cObs      := AllTrim(oRet:oHtml:RetByName("OBS")) //Obtem resposta
	cUser     := AllTrim(oRet:oHtml:RetByName("CR_USER")) //Usuario do aprovador
	cAprov    := AllTrim(oRet:oHtml:RetByName("CR_APROV")) //Aprovador

	Conout("cUser= "+cUser+"cAprov= "+cAprov)
	cEmailco := ""

	If cAprova = "1"

		Conout("-->Pedido "+cPedido+" aprovado.<--")

		Conout("-->Usuario Aprovador = "+cUser+" Cod aprovador: "+cAprov+" Pedido : "+cPedido+" Filial : "+cFil )

		cQuery := " UPDATE "+retsqlname("SCR")
		cQuery += " SET CR_STATUS = '03', CR_USERLIB = '"+cUser+"',CR_LIBAPRO = '"+cAprov+"', "
		cQuery += " CR_USERORI = '"+cUser+"',CR_APRORI = '"+cAprov+"', CR_DATALIB = '"+DTOS(DATE())+"', CR_OBS = '"+subs(cObs,1,70)+"', CR_VALLIB = CR_TOTAL "
		cQuery += " WHERE CR_NUM = '"+cPedido+"' AND CR_STATUS = '02' AND CR_FILIAL = '"+cFil+"' AND "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' "
		cQuery += " AND CR_USER = '"+cUser+"' AND CR_APROV = '"+cAprov+"'"

		TcSqlExec(cQuery)
		conout("query update : "+cquery )

		cQuery1 := " UPDATE "+retsqlname("SCR")
		cQuery1 += " SET CR_STATUS = '02' "
		cQuery1 += " WHERE CR_NIVEL = (SELECT TOP(1)CR_NIVEL FROM "+retsqlname("SCR")
		cQuery1 += " WHERE CR_FILIAL = '"+cFil+"' AND CR_NUM = '"+cPedido+"' AND "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' AND CR_STATUS = '01' ORDER BY CR_NIVEL ) "
		cquery1 += " AND "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' AND CR_FILIAL = '"+cFil+"' AND CR_NUM = '"+cPedido+"' "

		TcSqlExec(cQuery1)

		conout("query1 update : "+cquery1 )

		Conout("-->Liberando nivel da alcada<--")

		cAliasTop1 := GetNextAlias()

		cQuery2 := " SELECT TOP(1) CR_FILIAL, CR_NUM, CR_TIPO, CR_USER, CR_APROV, CR_NIVEL, CR_STATUS, CR_DATALIB, CR_WF
		cQuery2 += " FROM "+retsqlname("SCR")
		cQuery2 += " WHERE CR_NUM = '"+cPedido+"' AND CR_FILIAL = '"+cFil+"' AND "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' AND CR_STATUS = '02' "
		cQuery2 += " ORDER BY CR_NIVEL "

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAliasTop1,.T.,.T.)

		Conout("***Verificando se ja e o fim da aperacao.***")
		Conout("***Pedido <><>"+(cALIASTOP1)->CR_NUM)

		If !EMPTY((cALIASTOP1)->CR_NUM)

			Conout("***Iniciando processo de envio de novo email para aprovador***")

			cQuery3 := " UPDATE "+retsqlname("SCR")
			cQuery3 += " SET CR_WF = '1' "
			cQuery3 += " WHERE CR_NUM = '"+cPedido+"' AND CR_STATUS = '02' AND CR_FILIAL = '"+cFil+"' AND "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' "

			TcSqlExec(cQuery3)

			cAliasTop2 := GetNextAlias()

			cQuery4 := " SELECT DISTINCT  C7_FILIAL, C7_ITEM, C7_NUM, A2_COD + ' - ' +A2_NOME AS A2_NOME, C7_EMISSAO, C7_USER, C7_PRODUTO,C7_NUMSC, C7_TXMOEDA, C7_MOEDA,  C7_DTPGTO , "
			cQuery4 += " C7_DESCRI +' - '+C7_OBS AS C7_DESCRI, C7_UM, C7_QUANT, C7_PRECO, C7_TOTAL, E4_DESCRI, C7_IPI, C7_DATPRF,  C7_OBS, C7_TIPPED, C7_OBSPED, C7_ALTPED, C7_VERSAO, "
			cQuery4 += " C7_CC, C7_FRETE, C7_DESPESA, C7_VALFRE, C7_DESC, CR_USER, CR_APROV,CR_USERLIB, CR_LIBAPRO, CR_USERORI, CR_APRORI,CR_TOTAL "
			cQuery4 += " FROM "+retsqlname("SC7")+" INNER JOIN "+RETSQLNAME("SA2")+" ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA "
			cQuery4 += " INNER JOIN "+retsqlname("SE4")+" ON E4_CODIGO = C7_COND "
			cQuery4 += " INNER JOIN "+retsqlname("SCR")+" ON CR_NUM = C7_NUM AND CR_FILIAL = C7_FILIAL "
			cQuery4 += " WHERE "+retsqlname("SC7")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SA2")+".D_E_L_E_T_ <> '*' "
			cQuery4 += " AND "+retsqlname("SE4")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' AND C7_NUM = '"+cPedido+"' "
			cQuery4 += " AND CR_STATUS = '02'

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery4),cAliasTop2,.T.,.T.)

			cAliasfin := GetNextAlias()

			cQuery2 := " SELECT *  "
			cQuery2 += " FROM "+retsqlname("SE2")+" "
			cQuery2 += " WHERE E2_NUM = '"+cPedido+"' AND E2_PREFIXO = 'PED' AND E2_TIPO = 'PA' AND D_E_L_E_T_ <> '*' "

			dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuery2),cAliasFIN,.F.,.T.)

			dbSelectArea(cALIASTOP2)
			dbGoTop()

			if ! empty((cALIASTOP2)->C7_NUMSC)
				SC1->(DBSEEK(XFILIAl("SC1")+(cALIASTOP2)->C7_NUMSC ))

				cSolic := sc1->c1_solicit
			else
				cSolic := ""
			endif

			//para enviar copia de email

			SB1->(DBSEEK(XFILIAL("SB1")+(cALIASTOP2)->C7_PRODUTO ))
			cGrupo := sb1->b1_grupo
			do case
				case cGrupo == "LOCA"
				cEmailCo := "michelle.miranda@sacseng.com.br"
				case cGrupo == "PROD" .or. cGrupo == "SERV" .OR. cGrupo == "FERR"
				cEmailCo := ""

			endcase

			cNomeAp := UsrFullName((cALIASTOP2)->CR_USER)
			cNomeCo := UsrFullName((cALIASTOP2)->C7_USER)

			CONOUT ("*****|| "+DTOC(DATE())+" - " + TIME())
			CONOUT ("*****|| Iniciando processo WorkFlow/Aprovacao Pedido de Compras")
			CONOUT ("*****|| Pedido : "+cPedido+" *****||")

			oWF := TWFProcess():New("PEDCOM","Aprovacao do Pedido de Compras")
			oWF:cPriority := "3"

			If (cAliasTop2)->C7_ALTPED == "S"
				oWF:NewTask("Envio PC:" + cPedido ,"\WORKFLOW\HTML\wfpc.HTM" )
			Else
				oWF:NewTask("Envio PC:" + cPedido ,"\WORKFLOW\HTML\wfpc.HTM" )
			EndIf

			oWF:bReturn := "U_WfPcRet"
			oWF:cTo := "\workflow\"
			If (cAliasTop2)->C7_ALTPED == "S"
				oWF:cSubject := "Aprovacao de Pedido de Compras (Alteracao )"+cPedido+"/"+(cAliasTop2)->C7_VERSAO
			Else
				oWF:cSubject := "Aprovacao de Pedido de Compras "+cPedido
			EndIf

			CONOUT ("*****|| INICIANDO TAREFA ||******")
			CONOUT ("*****GERANDO CABECALHO DO PEDIDO******")

			oWF:oHtml:ValByName( "cEmpresa"	    , cEmpresa )
			oWF:oHtml:ValByName( "cNomeEmp"	    , cNomeEmp )
			oWF:oHtml:ValByName( "cFil"	        , cFil)
			oWF:oHtml:ValByName( "cPedido"	    , (cALIASTOP2)->C7_NUM )
			oWF:oHtml:ValByName( "dEmissao"     , STOD((cALIASTOP2)->C7_EMISSAO) )
			oWF:oHtml:ValByName( "cFornece"	    , (cALIASTOP2)->A2_NOME)
			oWF:oHtml:ValByName( "cComprador"   ,  cNomeCo    )
			oWF:oHtml:ValByName( "cAprovador"   ,  cNomeAp    )
			oWF:oHtml:ValByName( "cPag"         , (cALIASTOP2)->E4_DESCRI)
			oWF:oHtml:ValByName( "dTPagto"	    , STOD((cALIASTOP2)->C7_DTPGTO) )
			oWF:oHtml:ValByName( "cSolic"         , cSolic )
			oWF:oHtml:ValByName( "obsped"         , (cALIASTOP2)->C7_OBS )
			oWF:oHtml:ValByName( "CONGERPED"    , (cALIASTOP2)->C7_OBSPED )

			if (cALIASTOP2)->C7_MOEDA == 1
				oWF:oHtml:ValByName( "nTotalr"	    , TRANSFORM((cALIASTOP2)->CR_TOTAL,'@E 999,999,999.99'))
				oWF:oHtml:ValByName( "nTaxa"	    , TRANSFORM((cALIASTOP2)->C7_TXMOEDA,'@E 999,999,999.99'))
				oWF:oHtml:ValByName( "nTotald"	    , TRANSFORM(0,'@E 999,999,999.99'))

			else
				oWF:oHtml:ValByName( "nTotalr"	    , TRANSFORM((cALIASTOP2)->CR_TOTAL*(cALIASTOP2)->C7_TXMOEDA,'@E 999,999,999.99'))
				oWF:oHtml:ValByName( "nTaxa"	    , TRANSFORM((cALIASTOP2)->C7_TXMOEDA,'@E 999,999,999.99'))
				oWF:oHtml:ValByName( "nTotald"	    , TRANSFORM((cALIASTOP2)->CR_TOTAL,'@E 999,999,999.99'))
			endif

			oWF:oHtml:ValByName( "CR_USER"      ,  AllTrim((cALIASTOP2)->CR_USER))
			oWF:oHtml:ValByName( "CR_APROV"     ,  AllTrim((cALIASTOP2)->CR_APROV))

			CONOUT ("*****GERANDO ITENS DO PEDIDO******")

			While !(cAliasTop2)->(EOF())
				aadd(oWF:oHtml:ValByName("t1.cCod"    ), (cALIASTOP2)->C7_PRODUTO)
				aadd(oWF:oHtml:ValByName("t1.cDescri" ), (cALIASTOP2)->C7_DESCRI)
				aadd(oWF:oHtml:ValByName("t1.cUm"     ), (cALIASTOP2)->C7_UM)
				aadd(oWF:oHtml:ValByName("t1.nQuant"  ), TRANSFORM((cALIASTOP2)->C7_QUANT,'@E 999,999.9999'))
				aadd(oWF:oHtml:ValByName("t1.nIPI"    ), TRANSFORM((cALIASTOP2)->C7_IPI,'@E 99.99'))
				aadd(oWF:oHtml:ValByName("t1.nTotal"   ), TRANSFORM((cALIASTOP2)->C7_TOTAL,'@E 999,999,999.99'))
				if (cALIASTOP2)->C7_moeda == 1
					aadd(oWF:oHtml:ValByName("t1.nUnitr"   ), TRANSFORM((cALIASTOP2)->C7_PRECO,'@E 999,999.9999'))
					aadd(oWF:oHtml:ValByName("t1.nUnitd"   ), TRANSFORM(0,'@E 999,999.9999'))
				else
					aadd(oWF:oHtml:ValByName("t1.nUnitr"   ), TRANSFORM((cALIASTOP2)->C7_PRECO*(cALIASTOP2)->C7_TXMOEDA,'@E 999,999.9999'))
					aadd(oWF:oHtml:ValByName("t1.nUnitd"   ), TRANSFORM((cALIASTOP2)->C7_PRECO,'@E 999,999.9999'))

				endif

				aadd(oWF:oHtml:ValByName("t1.dEnt"    ), STOD((cALIASTOP2)->C7_DATPRF) )
				aadd(oWF:oHtml:ValByName("t1.cCusto"  ), (cALIASTOP2)->C7_CC )

				nTotal := nTotal + (cALIASTOP2)->C7_TOTAL
				nDespesas := nDespesas +(cALIASTOP2)->C7_FRETE + (cALIASTOP2)->C7_DESPESA + (cALIASTOP2)->C7_VALFRE
				nDesconto := nDesconto + (cALIASTOP2)->C7_DESC

				nPesq := Ascan(aProdutos,{|x|x[1] = (cALIASTOP2)->C7_PRODUTO } )
				If nPesq == 0
					Aadd(aProdutos,{ (cALIASTOP2)->C7_PRODUTO} )
				endif

				//Aadd(aProdutos,{ (cALIASTOP2)->C7_PRODUTO} )

				(cAliasTop2)->(DBSkip())
			EndDo

			oWF:oHtml:ValByName("nValMerc"  , TRANSFORM(nTotal,'@E 999,999,999.99'))
			oWF:oHtml:ValByName("nFrete"    , TRANSFORM(nDespesas,'@E 999,999.99'))
			oWF:oHtml:ValByName("nDesc"     , TRANSFORM(nDesconto,'@E 999,999.99'))

			CONOUT ("*****GERANDO TITULO FINANCEIRO******")

			While !(cAliasFIN)->(EOF())
				aadd(oWF:oHtml:ValByName("t4.prefixo"     ), (cALIASfin)->E2_PREFIXO)
				aadd(oWF:oHtml:ValByName("t4.titulo"      ), (cALIASfin)->E2_NUM)
				aadd(oWF:oHtml:ValByName("t4.valor"       ), TRANSFORM((cALIASfin)->E2_VALOR,'@E 999,999.9999'))
				aadd(oWF:oHtml:ValByName("t4.emissao"     ), STOD((cALIASFIN)->E2_EMISSAO))

				aadd(oWF:oHtml:ValByName("t4.vencimento"  ), STOD((cALIASFIN)->E2_VENCTO) )
				aadd(oWF:oHtml:ValByName("t4.dtprevpagto" ), STOD((cALIASFIN)->E2_VENCTO) )

				(cAliasFIN)->(DBSkip())
			EndDo

			cAliasTop3 := GetNextAlias()

			aSC7 := {}
			For j = 1 to len(aProdutos)

				cQuery6 := " SELECT TOP 3 C7_FILIAL, C7_ITEM, C7_PRODUTO, C7_NUM, C7_FORNECE, C7_LOJA, A2_NOME, C7_QUANT, C7_CC ,"
				cQuery6 += " C7_PRECO, C7_IPI , C7_EMISSAO, C7_DATPRF, C7_COND, E4_DESCRI, C7_QUJE "
				cQuery6 += " FROM "+retsqlname("SC7")+" C7 "
				cQuery6 += " INNER JOIN "+retsqlname("SA2")+" A2 ON "
				cQuery6 += " 	C7_FORNECE = A2_COD AND "
				cQuery6 += " 	C7_LOJA = A2_LOJA AND  "
				cQuery6 += " 	A2.D_E_L_E_T_='' "
				cQuery6 += " INNER JOIN "+retsqlname("SE4")+" E4 ON "
				cQuery6 += " 	C7_COND = E4_CODIGO AND "
				cQuery6 += " 	E4.D_E_L_E_T_='' "
				cQuery6 += " INNER JOIN "+retsqlname("SB1")+" B1 ON "
				cQuery6 += " 	B1.D_E_L_E_T_='' AND "
				cQuery6 += " 	B1_COD=C7_PRODUTO AND "
				//cQuery6 += " 	B1_TIPO not in ('GG') AND "
				cQuery6 += " 	B1_FILIAL='" + xFilial("SB1") + "' "
				cQuery6 += " WHERE C7_FILIAL =  '"+cFil+"' AND  C7_PRODUTO='"+aProdutos[j,1]+"' AND C7_QUJE <> 0 " //AND C7_ENCER <> ' ' "
				cQuery6 += " AND C7.D_E_L_E_T_ <> '*' "
				cQuery6 += " ORDER BY C7_EMISSAO DESC "

				dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuery6),cAliasTop3,.T.,.T.)

				CONOUT("Query Historico Pedidos")

				DbSelectArea(cAliasTop3)
				dbGoTop()

				While !Eof()
					Aadd( aSC7, {(cAliasTop3)->C7_PRODUTO , ;
					(cAliasTop3)->C7_NUM , ;
					(cAliasTop3)->A2_NOME, ;
					TRANSFORM((cAliasTop3)->C7_QUANT,'@E 999,999.999'), ;
					TRANSFORM((cAliasTop3)->C7_PRECO,'@E 999,999.99') , ;
					TRANSFORM((cAliasTop3)->C7_IPI ,'@E 999,999.99')  , ;
					DtoC(StoD((cAliasTop3)->C7_EMISSAO)) , ;
					(cAliasTop3)->C7_CC  , ;
					(cAliasTop3)->E4_DESCRI} )
					lPedidos := .T.
					(cAliasTop3)->(DBSkip())
				EndDo
				DbSelectArea(cALIASTOP3)
				DbCloseArea(cAliasTop3)

			Next

			If !lPedidos
				cExibe  := "<p><font color='#FF0000'>*** N„o h· historico de pedidos ***</font></p>"
				aadd(oWF:oHtml:ValByName("t2.cCod"      ),"--")
				aadd(oWF:oHtml:ValByName("t2.cPedido"   ),"--")
				aadd(oWF:oHtml:ValByName("t2.Fornece"   ),"--")
				aadd(oWF:oHtml:ValByName("t2.nQuant"    ),"--")
				aadd(oWF:oHtml:ValByName("t2.nUnit"     ),"--")
				aadd(oWF:oHtml:ValByName("t2.nIPI"      ),"--")
				aadd(oWF:oHtml:ValByName("t2.dEmissao"  ),"--")
				aadd(oWF:oHtml:ValByName("t2.cCusto"  ),"--")
				aadd(oWF:oHtml:ValByName("t2.cPgto"     ),"--")

			Else
				cItem := ""
				For j := 1 To Len(aSC7)
					aadd(oWF:oHtml:ValByName("t2.cCod"      ),aSC7[j][1])
					aadd(oWF:oHtml:ValByName("t2.cPedido"   ),aSC7[j][2])
					aadd(oWF:oHtml:ValByName("t2.Fornece"   ),aSC7[j][3])
					aadd(oWF:oHtml:ValByName("t2.nQuant"    ),aSC7[j][4])
					aadd(oWF:oHtml:ValByName("t2.nUnit"     ),aSC7[j][5])
					aadd(oWF:oHtml:ValByName("t2.nIPI"      ),aSC7[j][6])
					aadd(oWF:oHtml:ValByName("t2.dEmissao"  ),aSC7[j][7])
					aadd(oWF:oHtml:ValByName("t2.cCusto"    ),aSC7[j][8])
					aadd(oWF:oHtml:ValByName("t2.cPgto"     ),aSC7[j][9])
					cItem := aSC7[j][1]
				Next
			EndIf

			cAliasTop5 := GetNextAlias()

			cQuerySCR := " SELECT CR_NUM, CR_USER, AK_NOME, CR_NIVEL, CR_STATUS, CR_DATALIB, CR_OBS "
			cQuerySCR += " FROM "+retsqlname("SCR")+" INNER JOIN "+retsqlname("SAK")+" ON CR_USER = AK_USER "
			cQuerySCR += " WHERE "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SAK")+".D_E_L_E_T_ <> '*' "
			cQuerySCR += " AND CR_NUM = '"+cPedido+"' AND CR_FILIAL = '"+cFil+"' "

			dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuerySCR),cAliasTop5,.T.,.T.)

			While !(cAliasTop5)->(EOF())

				Do Case
					Case (cALIASTOP5)->CR_STATUS = "01"
					cStatus:= "Nivel Bloqueado"
					Case (cALIASTOP5)->CR_STATUS = "02"
					cStatus:= "Aguardando Liberacao"
					Case (cALIASTOP5)->CR_STATUS = "03"
					cStatus:= "Pedido Aprovado"
					Case (cALIASTOP5)->CR_STATUS = "04"
					cStatus:= "Pedido Bloqueado"
				EndCase

				aadd(oWF:oHtml:ValByName("t3.cNivel"     ), (cALIASTOP5)->CR_NIVEL)
				aadd(oWF:oHtml:ValByName("t3.cAprovador" ), (cALIASTOP5)->AK_NOME)
				aadd(oWF:oHtml:ValByName("t3.cStatus"    ),  cStatus)
				aadd(oWF:oHtml:ValByName("t3.dDataLib"   ),  STOD((cALIASTOP5)->CR_DATALIB))
				aadd(oWF:oHtml:ValByName("t3.Obs"        ), (cALIASTOP5)->CR_OBS)

				(cAliasTop5)->(DBSkip())
			EndDo

			aAttach := {}

			DbSelectArea("AC9")
			DbSetOrder(2)
			If DbSeek(xFilial("AC9")+"SC7"+SC7->C7_FILIAL+SC7->C7_FILIAL+cPedido )

				While AC9->(!Eof()) .And. Substr(AC9->AC9_CODENT,1,8) ==  SC7->C7_FILIAL+cPedido

					DbSelectArea("ACB")
					DbSetOrder(1)
					DbSeek(xFilial("ACB")+AC9->AC9_CODOBJ )
					//AaDd(aAttach,{Alltrim(ACB->ACB_DESCRI)+".PDF" } )

					AaDd(aAttach,Alltrim(ACB->ACB_DESCRI)+".PDF")

					DbSelectArea("AC9")
					AC9->(DbSkip())

				End

			Else

				ConOut( "Pedido nao possui documentos anexados.." )

			EndIf

			oWF:oHtml:ValByName("t5.arquivos" ,{})
			oWF:oHtml:ValByName("t5.anexos" ,{})

			If Len(aAttach) > 0

				For nX := 1 to Len(aAttach)

					cArquivo := cLinkArq+cPath+aAttach[nX]

					aadd(oWF:oHtml:ValByName("t5.arquivos" ),cArquivo )
					aadd(oWF:oHtml:ValByName("t5.Anexos" ),"Anexo "+StrZero(nX,2) )

				Next

			Else

				aadd(oWF:oHtml:ValByName("t5.arquivos" )," ")
				aadd(oWF:oHtml:ValByName("t5.Anexos" ),"sem Anexo " )

			EndIf

			cHtml := oWF:Start("\workflow\emp"+SM0->M0_CODIGO+"\tp\")

			cLinkext := GetMV("MV_WFHTTPE")+"/emp"+SM0->M0_CODIGO+"/tp/"+cHtml+".htm"
			cLinkint := GetMV("MV_WFHTTPI")+"/emp"+SM0->M0_CODIGO+"/tp/"+cHtml+".htm"

			CONOUT ("*****Modelo Configurado******")

			oWF:NewTask("Criando Link","\workflow\html\link_.htm")
			oWF:cTo  := UsrRetMail((cALIASTOP1)->CR_USER)
			oWF:cBCC := cEmailCo
			oWF:oHtml:ValByName("cLinkext" , cLinkext)
			oWF:oHtml:ValByName("cLinkint" , cLinkint)

			oWF:Start("\workflow\emp"+SM0->M0_CODIGO+"\tp\")
			CONOUT ("*****criando link******")
			CONOUT ("*****Email enviado para :"+UsrRetMail((cALIASTOP2)->CR_USER))

		Else

			DbSelectArea("SC7")
			DbSetOrder(1)
			DbSeek(xFilial()+cpedido)

			CONOUT ("Liberando pedido de compra: "+cPedido+ " Filial: "+cFil)

			cQuery9 := " UPDATE "+retsqlname("SC7")
			cQuery9 += " SET C7_CONAPRO = 'L', C7_DTAPROV = '"+Dtos(Date())+"' "
			cQuery9 += " WHERE C7_NUM = '"+cPedido+"' AND C7_FILIAL = '"+cFil+"' AND "+retsqlname("SC7")+".D_E_L_E_T_ <> '*' "
			TcSqlExec(cQuery9)

			CONOUT ("Enviando retorno pedido de compra: "+cPedido+ " Filial: "+cFil)
			Conout("-->Pedido "+cPedido+" aprovado.<--")
			Conout("***Retorno de Status para comprador***")

			cAliasTop12 := GetNextAlias()

			cQuery44 := " SELECT DISTINCT  C7_FILIAL, C7_ITEM, C7_NUM, A2_COD + ' - ' +A2_NOME AS A2_NOME, C7_EMISSAO, C7_USER, C7_PRODUTO, C7_NUMSC, C7_TXMOEDA, C7_MOEDA,  C7_DTPGTO , "
			cQuery44 += " C7_DESCRI +' - ' +C7_OBS AS C7_DESCRI, C7_UM, C7_QUANT, C7_PRECO, C7_TOTAL, E4_DESCRI, C7_IPI, C7_DATPRF,  C7_OBS, C7_TIPPED,  "
			cQuery44 += " C7_CC, C7_FRETE, C7_DESPESA, C7_VALFRE, C7_DESC, CR_USER, CR_APROV, CR_USERLIB, CR_LIBAPRO, CR_USERORI, CR_APRORI, CR_TOTAL "
			cQuery44 += " FROM "+retsqlname("SC7")+" INNER JOIN "+RETSQLNAME("SA2")+" ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA "
			cQuery44 += " INNER JOIN "+retsqlname("SE4")+" ON E4_CODIGO = C7_COND "
			cQuery44 += " INNER JOIN "+retsqlname("SCR")+" ON CR_NUM = C7_NUM AND CR_FILIAL = C7_FILIAL "
			cQuery44 += " WHERE "+retsqlname("SC7")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SA2")+".D_E_L_E_T_ <> '*' "
			cQuery44 += " AND "+retsqlname("SE4")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' AND C7_NUM = '"+cPedido+"' "
			cQuery44 += " AND CR_STATUS = '03' AND C7_FILIAL = '"+cFil+"' AND "
			cQuery44 += " CR_NIVEL =  (SELECT MAX(CR_NIVEL) FROM "+retsqlname("SCR")+" WHERE CR_NUM = '"+cPedido+"' AND "+retsqlname("SCR")+".D_E_L_E_T_ <> '*')

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery44),cAliasTop12,.T.,.T.)

			cAliasfin := GetNextAlias()

			cQuery2 := " SELECT * "
			cQuery2 += " FROM "+retsqlname("SE2")+" "
			cQuery2 += " WHERE E2_NUM = '"+cPedido+"' AND E2_PREFIXO = 'PED' AND E2_TIPO = 'PA' AND D_E_L_E_T_ <> '*' "

			dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuery2),cAliasFIN,.F.,.T.)

			dbSelectArea(cALIASTOP12)
			dbGoTop()

			if ! empty((cALIASTOP12)->C7_NUMSC)
				SC1->(DBSEEK(XFILIAl("SC1")+(cALIASTOP12)->C7_NUMSC ))

				cSolic := sc1->c1_solicit
			else
				cSolic := ""
			endif

			Conout("cEmpresa= " +cEmpresa+ " cNomeEmp= "+cNomeEmp+" cFil= "+cFil+ " cCodAprov = "+cUser+" cPedido ="+(cALIASTOP12)->C7_NUM)

			cNomeAp := UsrFullName((cALIASTOP12)->CR_USER)
			cNomeCo := UsrFullName((cALIASTOP12)->C7_USER)
			cCodCo  := (cALIASTOP12)->C7_USER

			oWF := TWFProcess():New("PEDCOMRET","Retorno de Pedido Aprovado")
			oWF:cPriority := "3"

			oWF:NewTask("Retorno para aprovador", "\WORKFLOW\HTML\wfpc_apr.HTM" )

			oWF:cTo := UsrRetMail(cCodCo)
			//oWF:cBCC := cEmailCo

			oWF:cSubject := "Pedido de Compras "+cPedido+" Aprovado"

			oWF:oHtml:ValByName( "cEmpresa"	    , cEmpresa )
			oWF:oHtml:ValByName( "cNomeEmp"	    , cNomeEmp )
			oWF:oHtml:ValByName( "cFil"	        , cFil)
			oWF:oHtml:ValByName( "cCodAprov"	, (cALIASTOP12)->CR_APROV)
			oWF:oHtml:ValByName( "cPedido"	    , (cALIASTOP12)->C7_NUM )
			oWF:oHtml:ValByName( "dEmissao"     , STOD((cALIASTOP12)->C7_EMISSAO) )
			oWF:oHtml:ValByName( "dTPagto"	    , STOD((cALIASTOP12)->C7_DTPGTO) )
			oWF:oHtml:ValByName( "cFornece"	    , (cALIASTOP12)->A2_NOME)
			oWF:oHtml:ValByName( "cComprador"   ,  cNomeCo )
			oWF:oHtml:ValByName( "cPag"         , (cALIASTOP12)->E4_DESCRI)
			oWF:oHtml:ValByName( "cSolic"         , cSolic )

			if (cALIASTOP12)->C7_MOEDA == 1
				oWF:oHtml:ValByName( "nTotalr"	    , TRANSFORM((cALIASTOP12)->CR_TOTAL,'@E 999,999,999.99'))
				oWF:oHtml:ValByName( "nTaxa"	    , TRANSFORM((cALIASTOP12)->C7_TXMOEDA,'@E 999,999,999.99'))
				oWF:oHtml:ValByName( "nTotalr"	    , TRANSFORM(0,'@E 999,999,999.99'))
			else
				oWF:oHtml:ValByName( "nTotalr"	    , TRANSFORM((cALIASTOP12)->CR_TOTAL*(cALIASTOP12)->C7_TXMOEDA,'@E 999,999,999.99'))
				oWF:oHtml:ValByName( "nTaxa"	    , TRANSFORM((cALIASTOP12)->C7_TXMOEDA,'@E 999,999,999.99'))
				oWF:oHtml:ValByName( "nTotalr"	    , TRANSFORM((cALIASTOP12)->CR_TOTAL,'@E 999,999,999.99'))
			endif

			oWF:oHtml:ValByName( "CR_USER"      ,  AllTrim((cALIASTOP12)->CR_USER))
			oWF:oHtml:ValByName( "CR_APROV"     ,  AllTrim((cALIASTOP12)->CR_APROV))

			CONOUT ("*****GERANDO ITENS DO PEDIDO******")

			While !(cAliasTop12)->(EOF())

				aadd(oWF:oHtml:ValByName("t1.cCod"    ), (cALIASTOP12)->C7_PRODUTO)
				aadd(oWF:oHtml:ValByName("t1.cDescri" ), (cALIASTOP12)->C7_DESCRI)
				aadd(oWF:oHtml:ValByName("t1.cUm"     ), (cALIASTOP12)->C7_UM)
				aadd(oWF:oHtml:ValByName("t1.nQuant"  ), TRANSFORM((cALIASTOP12)->C7_QUANT,'@E 999,999.9999'))
				aadd(oWF:oHtml:ValByName("t1.nIPI"    ), TRANSFORM((cALIASTOP12)->C7_IPI,'@E 99.99'))
				aadd(oWF:oHtml:ValByName("t1.nTotal"   ), TRANSFORM((cALIASTOP12)->C7_TOTAL,'@E 999,999,999.99'))
				if (cALIASTOP12)->C7_moeda == 1
					aadd(oWF:oHtml:ValByName("t1.nUnitr"  ), TRANSFORM((cALIASTOP12)->C7_PRECO,'@E 999,999.9999'))
					aadd(oWF:oHtml:ValByName("t1.nUnitd"  ), TRANSFORM(0,'@E 999,999.9999'))
				else
					aadd(oWF:oHtml:ValByName("t1.nUnitr"   ), TRANSFORM((cALIASTOP12)->C7_PRECO*(cALIASTOP12)->C7_TXMOEDA,'@E 999,999.9999'))
					aadd(oWF:oHtml:ValByName("t1.nUnitd"   ), TRANSFORM((cALIASTOP12)->C7_PRECO,'@E 999,999.9999'))

				endif

				aadd(oWF:oHtml:ValByName("t1.dEnt"    ), STOD((cALIASTOP12)->C7_DATPRF))
				aadd(oWF:oHtml:ValByName("t1.cCusto"  ), (cALIASTOP12)->C7_CC)

				nTotal    := nTotal    + (cALIASTOP12)->C7_TOTAL
				nDespesas := nDespesas + (cALIASTOP12)->C7_FRETE + (cALIASTOP12)->C7_DESPESA + (cALIASTOP12)->C7_VALFRE
				nDesconto := nDesconto + (cALIASTOP12)->C7_DESC

				nPesq := Ascan(aProdutos,{|x|x[1] = (cALIASTOP12)->C7_PRODUTO } )
				If nPesq == 0
					Aadd(aProdutos,{ (cALIASTOP12)->C7_PRODUTO} )
				endif

				//Aadd(aProdutos,{ (cALIASTOP12)->C7_PRODUTO} )

				(cAliasTop12)->(DBSkip())

			EndDo

			oWF:oHtml:ValByName("nValMerc"  , TRANSFORM(nTotal,'@E 999,999,999.99'))
			oWF:oHtml:ValByName("nFrete"    , TRANSFORM(nDespesas,'@E 999,999.99'))
			oWF:oHtml:ValByName("nDesc"     , TRANSFORM(nDesconto,'@E 999,999.99'))

			dbSelectArea(cALIASTOP12)
			dbGoTop()

			If (cALIASTOP12)->C7_TIPPED == "3"
				CONOUT ("*****GERANDO TITULO FINANCEIRO******")

				(cAliasFIN)->(DBGOTOP())

				While !(cAliasFIN)->(EOF())
					aadd(oWF:oHtml:ValByName("t4.prefixo"     ), (cALIASfin)->E2_PREFIXO)
					aadd(oWF:oHtml:ValByName("t4.titulo"      ), (cALIASfin)->E2_NUM)
					aadd(oWF:oHtml:ValByName("t4.valor"       ), TRANSFORM((cALIASfin)->E2_VALOR,'@E 999,999.9999'))
					aadd(oWF:oHtml:ValByName("t4.emissao"     ), STOD((cALIASFIN)->E2_EMISSAO))

					aadd(oWF:oHtml:ValByName("t4.vencimento"  ), STOD((cALIASFIN)->E2_VENCTO) )
					aadd(oWF:oHtml:ValByName("t4.dtprevpagto" ), STOD((cALIASFIN)->E2_VENCTO) )

					(cAliasFIN)->(DBSkip())
				EndDo

			EndIf

			cAliasTop5 := GetNextAlias()

			cQuerySCR := " SELECT CR_NUM, CR_USER, AK_NOME, CR_NIVEL, CR_STATUS, CR_DATALIB, CR_OBS "
			cQuerySCR += " FROM "+retsqlname("SCR")+" INNER JOIN "+RETSQLNAME("SAK")+" ON CR_USER = AK_USER "
			cQuerySCR += " WHERE "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SAK")+".D_E_L_E_T_ <> '*' "
			cQuerySCR += " AND CR_NUM = '"+cPedido+"' AND CR_FILIAL = '"+cFil+"' "

			dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuerySCR),cAliasTop5,.T.,.T.)

			While !(cAliasTop5)->(EOF())

				Do Case
					Case (cALIASTOP5)->CR_STATUS = "01"
					cStatus:= "Nivel Bloqueado"
					Case (cALIASTOP5)->CR_STATUS = "02"
					cStatus:= "Aguardando Liberacao"
					Case (cALIASTOP5)->CR_STATUS = "03"
					cStatus:= "Pedido Aprovado"
					Case (cALIASTOP5)->CR_STATUS = "04"
					cStatus:= "Pedido Bloqueado"
				EndCase

				aadd(oWF:oHtml:ValByName("t3.cNivel"     ), (cALIASTOP5)->CR_NIVEL)
				aadd(oWF:oHtml:ValByName("t3.cAprovador" ), (cALIASTOP5)->AK_NOME)
				aadd(oWF:oHtml:ValByName("t3.cStatus"    ),  cStatus)
				aadd(oWF:oHtml:ValByName("t3.dDataLib"   ),  STOD((cALIASTOP5)->CR_DATALIB))
				aadd(oWF:oHtml:ValByName("t3.Obs"        ), (cALIASTOP5)->CR_OBS)

				(cAliasTop5)->(DBSkip())

			End

			(CaLIASFIN)->(DBGOTOP())

			CONOUT ("*****GERANDO TITULO FINANCEIRO******")
			//		cProd := ""
			While !(cAliasFIN)->(EOF())
				aadd(oWF:oHtml:ValByName("t4.prefixo"     ), (cALIASfin)->E2_PREFIXO)
				aadd(oWF:oHtml:ValByName("t4.titulo"      ), (cALIASfin)->E2_NUM)
				aadd(oWF:oHtml:ValByName("t4.valor"       ), TRANSFORM((cALIASfin)->E2_VALOR,'@E 999,999.9999'))
				aadd(oWF:oHtml:ValByName("t4.emissao"     ), STOD((cALIASFIN)->E2_EMISSAO))

				aadd(oWF:oHtml:ValByName("t4.vencimento"  ), STOD((cALIASFIN)->E2_VENCTO) )
				aadd(oWF:oHtml:ValByName("t4.dtprevpagto" ), STOD((cALIASFIN)->E2_VENCTO) )

				(cAliasFIN)->(DBSkip())
			EndDo

			cHtml := oWF:Start()

		EndIf

	ElseIf cAprova = "2"

		cEmailCo := ""

		Conout("-->Pedido "+cPedido+" reprovado.<--")

		cQuery := " UPDATE "+retsqlname("SCR")
		cQuery += " SET CR_STATUS = '04', CR_USERLIB = '"+cUser+"',CR_LIBAPRO = '"+cAprov+"', CR_USERORI = '"+cUser+"',CR_APRORI = '"+cAprov+"', CR_DATALIB = '"+DTOS(DATE())+"', CR_OBS = '"+subs(cObs,1,70)+"' "
		cQuery += " WHERE CR_NUM = '"+cPedido+"' AND CR_STATUS = '02' AND CR_FILIAL = '"+cFil+"' AND "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' "

		TcSqlExec(cQuery)

		conout("query reprovacao update : "+cquery )

		Conout("***Retorno de Status para comprador***")

		cAliasTop2 := GetNextAlias()

		cQuery4 := " SELECT DISTINCT  C7_FILIAL, C7_ITEM, C7_NUM, A2_COD + ' - ' +A2_NOME AS A2_NOME, C7_EMISSAO, C7_USER, C7_PRODUTO,C7_NUMSC, C7_TXMOEDA, C7_MOEDA,  C7_DTPGTO , "
		cQuery4 += " C7_DESCRI +' - '+ C7_OBS AS C7_DESCRI, C7_UM, C7_QUANT, C7_PRECO, C7_TOTAL, E4_DESCRI, C7_IPI, C7_DATPRF,  C7_OBS, C7_TIPPED , "
		cQuery4 += " C7_CC, C7_FRETE, C7_DESPESA, C7_VALFRE, C7_DESC, CR_USER, CR_APROV, CR_USERLIB, CR_LIBAPRO, CR_USERORI, CR_APRORI, CR_TOTAL "
		cQuery4 += " FROM "+retsqlname("SC7")+" INNER JOIN "+RETSQLNAME("SA2")+" ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA "
		cQuery4 += " INNER JOIN "+retsqlname("SE4")+" ON E4_CODIGO = C7_COND "
		cQuery4 += " INNER JOIN "+retsqlname("SCR")+" ON CR_NUM = C7_NUM AND CR_FILIAL = C7_FILIAL "
		cQuery4 += " WHERE "+retsqlname("SC7")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SA2")+".D_E_L_E_T_ <> '*' "
		cQuery4 += " AND "+retsqlname("SE4")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' AND C7_NUM = '"+cPedido+"' "
		cQuery4 += " AND C7_FILIAL = '"+cFil+"' AND "
		cQuery4 += " CR_NIVEL =  (SELECT MAX(CR_NIVEL) FROM "+retsqlname("SCR")+" WHERE CR_NUM = '"+cPedido+"' AND "+retsqlname("SCR")+".D_E_L_E_T_ <> '*')

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery4),cAliasTop2,.T.,.T.)

		cAliasfin := GetNextAlias()

		cQuery2 := " SELECT *  "
		cQuery2 += " FROM "+retsqlname("SE2")+" "
		cQuery2 += " WHERE E2_NUM = '"+cPedido+"' AND E2_PREFIXO = 'PED' AND E2_TIPO = 'PA' AND D_E_L_E_T_ <> '*' "

		dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuery2),cAliasFIN,.F.,.T.)

		dbSelectArea(cALIASTOP2)
		dbGoTop()

		Conout("cEmpresa= " +cEmpresa+ " cNomeEmp= "+cNomeEmp+" cFil= "+cFil+ " cCodAprov = "+cUser+" cPedido = "+cPedido)

		cNomeAp := UsrFullName((cALIASTOP2)->CR_USER)
		cNomeCo := UsrFullName((cALIASTOP2)->C7_USER)
		cCodCo  := (cALIASTOP2)->C7_USER

		if ! empty((cALIASTOP2)->C7_NUMSC)
			SC1->(DBSEEK(XFILIAl("SC1")+(cALIASTOP2)->C7_NUMSC ))

			cSolic := sc1->c1_solicit
		else
			cSolic := ""
		endif

		//para enviar copia de email
		SB1->(DBSEEK(XFILIAL("SB1")+(cALIASTOP2)->C7_PRODUTO ))
		cGrupo := sb1->b1_grupo
		do case
			case cGrupo == "LOCA"
			cEmailCo := "michelle.miranda@sacseng.com.br"
		endcase

		oWF := TWFProcess():New("PEDCOMRET","Retorno de Pedido Reprovado")
		oWF:cPriority := "3"

		oWF:NewTask("Retorno para comprador", "\WORKFLOW\HTML\wfpc_rep.HTM" )
		oWF:cTo := UsrRetMail(cCodCo)
		oWF:cSubject := "Pedido de Compras "+cPedido+" Reprovado"

		oWF:oHtml:ValByName( "cEmpresa"	    , cEmpresa )
		oWF:oHtml:ValByName( "cNomeEmp"	    , cNomeEmp )
		oWF:oHtml:ValByName( "cFil"	        , cFil)
		oWF:oHtml:ValByName( "cCodAprov"	, (cALIASTOP2)->CR_APROV)
		oWF:oHtml:ValByName( "cPedido"	    , (cALIASTOP2)->C7_NUM )
		oWF:oHtml:ValByName( "dEmissao"     , STOD((cALIASTOP2)->C7_EMISSAO) )
		oWF:oHtml:ValByName( "cFornece"	    , (cALIASTOP2)->A2_NOME)
		oWF:oHtml:ValByName( "cComprador"   ,  cNomeCo )
		oWF:oHtml:ValByName( "cPag"         , (cALIASTOP2)->E4_DESCRI)
		oWF:oHtml:ValByName( "dTPagto"	    , STOD((cALIASTOP2)->C7_DTPGTO) )
		oWF:oHtml:ValByName( "cSolic"         , cSolic )

		if (cALIASTOP2)->C7_MOEDA == 1
			oWF:oHtml:ValByName( "nTotalr"	    , TRANSFORM((cALIASTOP2)->CR_TOTAL,'@E 999,999,999.99'))
			oWF:oHtml:ValByName( "nTaxa"	    , TRANSFORM((cALIASTOP2)->C7_TXMOEDA,'@E 999,999,999.99'))
			oWF:oHtml:ValByName( "nTotalD"	    , TRANSFORM(0,'@E 999,999,999.99'))
		else
			oWF:oHtml:ValByName( "nTotalr"	    , TRANSFORM((cALIASTOP2)->CR_TOTAL*(cALIASTOP2)->C7_TXMOEDA,'@E 999,999,999.99'))
			oWF:oHtml:ValByName( "nTaxa"	    , TRANSFORM((cALIASTOP2)->C7_TXMOEDA,'@E 999,999,999.99'))
			oWF:oHtml:ValByName( "nTotalD"	    , TRANSFORM((cALIASTOP2)->CR_TOTAL,'@E 999,999,999.99'))
		endif

		oWF:oHtml:ValByName( "CR_USER"      ,  AllTrim((cALIASTOP2)->CR_USER))
		oWF:oHtml:ValByName( "CR_APROV"     ,  AllTrim((cALIASTOP2)->CR_APROV))

		CONOUT ("*****GERANDO ITENS DO PEDIDO******")

		While !(cAliasTop2)->(EOF())
			aadd(oWF:oHtml:ValByName("t1.cCod"    ), (cALIASTOP2)->C7_PRODUTO)
			aadd(oWF:oHtml:ValByName("t1.cDescri" ), (cALIASTOP2)->C7_DESCRI)
			aadd(oWF:oHtml:ValByName("t1.cUm"     ), (cALIASTOP2)->C7_UM)
			aadd(oWF:oHtml:ValByName("t1.nQuant"  ), TRANSFORM((cALIASTOP2)->C7_QUANT,'@E 999,999.9999'))
			aadd(oWF:oHtml:ValByName("t1.nIPI"    ), TRANSFORM((cALIASTOP2)->C7_IPI,'@E 99.99'))
			aadd(oWF:oHtml:ValByName("t1.nTotal"   ), TRANSFORM((cALIASTOP2)->C7_TOTAL,'@E 999,999,999.99'))
			if (cALIASTOP2)->C7_moeda == 1
				aadd(oWF:oHtml:ValByName("t1.nUnitr"   ), TRANSFORM((cALIASTOP2)->C7_PRECO,'@E 999,999.9999'))
				aadd(oWF:oHtml:ValByName("t1.nUnitd"   ), TRANSFORM(0,'@E 999,999.9999'))
			else
				aadd(oWF:oHtml:ValByName("t1.nUnitr"   ), TRANSFORM((cALIASTOP2)->C7_PRECO*(cALIASTOP2)->C7_TXMOEDA,'@E 999,999.9999'))
				aadd(oWF:oHtml:ValByName("t1.nUnitd"   ), TRANSFORM((cALIASTOP2)->C7_PRECO,'@E 999,999.9999'))

			endif

			aadd(oWF:oHtml:ValByName("t1.dEnt"    ), STOD((cALIASTOP2)->C7_DATPRF))
			aadd(oWF:oHtml:ValByName("t1.cCusto"  ), (cALIASTOP2)->C7_CC)

			nTotal := nTotal + (cALIASTOP2)->C7_TOTAL
			nDespesas := nDespesas +(cALIASTOP2)->C7_FRETE+ (cALIASTOP2)->C7_DESPESA + (cALIASTOP2)->C7_VALFRE
			nDesconto := nDesconto + (cALIASTOP2)->C7_DESC

			nPesq := Ascan(aProdutos,{|x|x[1] = (cALIASTOP2)->C7_PRODUTO } )
			If nPesq == 0
				Aadd(aProdutos,{ (cALIASTOP2)->C7_PRODUTO} )
			endif

			//		Aadd(aProdutos,{ (cALIASTOP2)->C7_PRODUTO} )

			(cAliasTop2)->(DBSkip())
		EndDo

		oWF:oHtml:ValByName("nValMerc"  , TRANSFORM(nTotal,'@E 999,999,999.99'))
		oWF:oHtml:ValByName("nFrete"    , TRANSFORM(nDespesas,'@E 999,999.99'))
		oWF:oHtml:ValByName("nDesc"     , TRANSFORM(nDesconto,'@E 999,999.99'))

		dbSelectArea(cALIASTOP2)
		dbGoTop()
		if (cAliasTop2)->C7_TIPPED == "3"

			(CaLIASFIN)->(DBGOTOP())

			CONOUT ("*****GERANDO TITULO FINANCEIRO******")
			//		cProd := ""
			While !(cAliasFIN)->(EOF())
				aadd(oWF:oHtml:ValByName("t4.prefixo"     ), (cALIASfin)->E2_PREFIXO)
				aadd(oWF:oHtml:ValByName("t4.titulo"      ), (cALIASfin)->E2_NUM)
				aadd(oWF:oHtml:ValByName("t4.valor"       ), TRANSFORM((cALIASfin)->E2_VALOR,'@E 999,999.9999'))
				aadd(oWF:oHtml:ValByName("t4.emissao"     ), STOD((cALIASFIN)->E2_EMISSAO))

				aadd(oWF:oHtml:ValByName("t4.vencimento"  ), STOD((cALIASFIN)->E2_VENCTO) )
				aadd(oWF:oHtml:ValByName("t4.dtprevpagto" ), STOD((cALIASFIN)->E2_VENCTO) )

				(cAliasFIN)->(DBSkip())
			EndDo
		ENDIF
		cAliasTop5 := GetNextAlias()

		cQuerySCR := " SELECT CR_NUM, CR_USER, AK_NOME, CR_NIVEL, CR_STATUS, CR_DATALIB, CR_OBS "
		cQuerySCR += " FROM "+retsqlname("SCR")+" INNER JOIN "+RETSQLNAME("SAK")+" ON CR_USER = AK_USER "
		cQuerySCR += " WHERE "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SAK")+".D_E_L_E_T_ <> '*' "
		cQuerySCR += " AND CR_NUM = '"+cPedido+"' AND CR_FILIAL = '"+cFil+"' "

		dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuerySCR),cAliasTop5,.T.,.T.)

		While !(cAliasTop5)->(EOF())

			Do Case
				Case (cALIASTOP5)->CR_STATUS = "01"
				cStatus:= "Nivel Bloqueado"
				Case (cALIASTOP5)->CR_STATUS = "02"
				cStatus:= "Aguardando Liberacao"
				Case (cALIASTOP5)->CR_STATUS = "03"
				cStatus:= "Pedido Aprovado"
				Case (cALIASTOP5)->CR_STATUS = "04"
				cStatus:= "Pedido Bloqueado"
			EndCase

			aadd(oWF:oHtml:ValByName("t3.cNivel"     ), (cALIASTOP5)->CR_NIVEL)
			aadd(oWF:oHtml:ValByName("t3.cAprovador" ), (cALIASTOP5)->AK_NOME)
			aadd(oWF:oHtml:ValByName("t3.cStatus"    ),  cStatus)
			aadd(oWF:oHtml:ValByName("t3.dDataLib"   ),  STOD((cALIASTOP5)->CR_DATALIB))
			aadd(oWF:oHtml:ValByName("t3.Obs"        ), (cALIASTOP5)->CR_OBS)

			(cAliasTop5)->(DBSkip())
		EndDo

		cHtml := oWF:Start()

	EndIf
	Conout("-->Fim do procedimento de retorno.<--")

Return()

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥Escolha   ∫Autor  ≥Carlos R. Moreira   ∫ Data ≥  09/18/09   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Seleciona a Opcao desejada                                  ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Especifico                                                ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function Escolha()
	Local oDlg2
	Private nRadio := 1
	Private oRadio

	@ 0,0 TO 200,250 DIALOG oDlg2 TITLE "Local de Entrega"
	@ 05,05 TO 67,120 TITLE "Selecione"
	@ 23,30 RADIO oRadio Var nRadio Items "Matriz","Obra" 3D SIZE 60,10 of oDlg2 Pixel
	@ 080,075 BMPBUTTON TYPE 1 ACTION Close(oDlg2)
	ACTIVATE DIALOG oDlg2 CENTER

Return nRadio

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MT120FIM  ∫Autor  ≥Microsiga           ∫ Data ≥  07/22/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function GetLocEsp()
	Local oDlgProc
	Local aCampos  := {}

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Define array para arquivo de trabalho                        ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	AADD(aCampos,{ "OK"       ,"C",  2,0 } )
	AADD(aCampos,{ "SEQ"     ,"C",  2,0 } )
	AADD(aCampos,{ "ENDER"   ,"C", 30,0 } )
	AADD(aCampos,{ "EST"     ,"C", 2,0 } )

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Monta arquivo de trabalho ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	cTrab:= CriaTrab(aCampos)
	DbUseArea(.T.,,cTrab,"ENDER",,.F. )

	IndRegua("ENDER",cTrab,"SEQ",,,"Selecionando Registros...")

	DbSelectArea("SZ4")
	DbSetOrder(1)
	DbSeek(xFilial("SZ4")+cCC )

	While SZ4->(!Eof()) .And. SZ4->Z4_CC == cCC

		DbSelectArea("ENDER")
		RecLock("ENDER",.T.)
		ENDER->SEQ   := SZ4->Z4_SEQ
		ENDER->ENDER := SZ4->Z4_END
		ENDER->EST   := SZ4->Z4_EST
		MsUnlock()

		DbSelectArea("SZ4")
		DbSkip()

	End

	aBrowse := {}
	AaDD(aBrowse,{"OK","",""})
	AaDD(aBrowse,{"SEQ","","Sequencia"})
	AaDD(aBrowse,{"ENDER","","Endereco"})
	AaDD(aBrowse,{"EST","","Estado"})

	ENDER->(DbGoTop())

	If ENDER->(Eof())
		ENDER->(DbCloseArea())
		Return .F.
	EndIf

	cSeq     := Space(2)
	nOpca    :=0
	lInverte := .F.
	cMarca   := GetMark()
	cTit     := "Selecao de Endereco"
	DEFINE MSDIALOG oDlg1 TITLE cTit From 9,0 To 25,100 OF oMainWnd

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Passagem do parametro aCampos para emular tambÇm a markbrowse para o ≥
	//≥ arquivo de trabalho "TRB".                                           ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	oMark := MsSelect():New("ENDER","OK","",aBrowse,@lInverte,@cMarca,{15,3,118,395})

	oMark:bMark := {| | fa060disp(cMarca,lInverte)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca,1) }

	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||oDlg1:End()},1) centered

	If nOpca == 1

		DbSelectArea("ENDER")
		DbGoTop()

		nVez := 0
		While ENDER->(!Eof())
			If !Empty(ENDER->OK)
				cSeq    := ENDER->SEQ
				nVez++
			EndIf

			DbSkip()

		End
		If nVez > 1 .Or. nVez == 0
			cSEQ  := Space(2)
		Else
			DbSelectArea("ENDER")
			DbGoTop()

			nVez := 0
			While ENDER->(!Eof())
				If !Empty(ENDER->OK)
					cSeq := ENDER->SEQ
					Exit
				EndIf

				DbSkip()

			End

			DbSelectArea("SZ4")
			DbSetOrder(1)
			DbSeek(xFilial("SZ4")+cCC+cSeq )

			cLocEntEsp := Alltrim(SZ4->Z4_END)+" - "+Alltrim(SZ4->Z4_BAIRRO)+" - "+Alltrim(SZ4->Z4_MUN)+" - "+SZ4->Z4_EST

		EndIf

	EndIf

	ENDER->(DbCloseArea())

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥FA060Disp ≥ Autor ≥ Carlos R. Moreira     ≥ Data ≥ 09/05/03 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Exibe Valores na tela									  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso		 ≥ Especifico                                                 ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function Fa060Disp(cMarca,lInverte)
	Local aTempos, cClearing, oCBXCLEAR, oDlgClear,lCOnf
	If IsMark("OK",cMarca,lInverte)
	Endif
Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥Fa060Inve ∫Autor  ≥Carlos R. Moreira   ∫ Data ≥  19/07/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥inverte a Selecao dos Itens                                 ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Especifico                                                 ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function Fa060Inverte(cMarca)
	Local nReg := ENDER->(Recno())
	Local cAlias := Alias()

	dbSelectArea("ENDER")
	dbGoTop()
	While !Eof()
		RecLock("ENDER")
		ENDER->OK := IIF(ENDER->OK == "  ",cMarca,"  ")
		MsUnlock()
		dbSkip()
	Enddo
	ENDER->(dbGoto(nReg))
	oMark:oBrowse:Refresh(.t.)
Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥LchoiceBar≥ Autor ≥ Pilar S Albaladejo    ≥ Data ≥          ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Mostra a EnchoiceBar na tela                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Generico                                                   ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function LchoiceBar(oDlg,bOk,bCancel,nOpcao)
	Local oBar, bSet15, bSet24, lOk
	Local lVolta :=.f.

	DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
	//	DEFINE BUTTON RESOURCE "S4WB011N" OF oBar GROUP ACTION ProcPne() TOOLTIP OemToAnsi("Procura PNE..")
	//	DEFINE BUTTON RESOURCE "EDIT" OF oBar GROUP ACTION U_ConsPne1(PNE->CODIGO) TOOLTIP OemToAnsi("Visualiza a PNE..")
	DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
	SetKEY(15,oBtOk:bAction)
	DEFINE BUTTON oBtCan RESOURCE "FINAL" OF oBar ACTION ( lLoop:=.F.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP OemToAnsi("Cancelar - <Ctrl-X>")  //
	SetKEY(24,oBtCan:bAction)
	oDlg:bSet15 := oBtOk:bAction
	oDlg:bSet24 := oBtCan:bAction
	oBar:bRClicked := {|| AllwaysTrue()}

	//DEFINE BUTTON oBtOk RESOURCE "FINAL" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
	//SetKEY(15,oBtOk:bAction)
Return

Static Function ButtonOff(bSet15,bSet24,lOk)
	DEFAULT lOk := .t.
	IF lOk
		SetKey(15,bSet15)
		SetKey(24,bSet24)
	Endif
Return .T.

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MT120FIM  ∫Autor  ≥Microsiga           ∫ Data ≥  08/06/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Ira gerar a Verba de Desconto de Multa para o Funcionario  ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Especifico                                                ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function GeraDesFol()
	Local nValor := SC7->C7_TOTAL

	cSemana     := Space(2)
	c__Roteiro	:= "FOL"

	If !ExisteSX6("MV_VERBAMU")
		CriarSX6("MV_VERBAMU","C","Define a verba a ser utilizada para o desconto de multa","473")
	EndIf

	cVerba := GetMV("MV_VERBAMU")

	DbSelectArea("SRA")
	DbSetOrder(1)
	DbSeek(xFilial("SRA")+SC7->C7_MATFUNC )

	Conout("Gerando a Verba na folha..")

	fGeraVerba(cVerba,nValor,,,,,,,,,.T.)

	ConOut("Mandando aviso de multas..")

	AvisoRH()

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MT120FIM  ∫Autor  ≥Microsiga           ∫ Data ≥  08/06/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Ira mandar um aviso ao responsavel do RH para avisar que   ∫±±
±±∫          ≥ sera descontado a multa do funcionario                     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function AvisoRH()
	Local cRepoImagem := "http://painel.www1.sacseng.com.br:81/imagem/logo.jpg"

	If !ExisteSX6("MV_EMAILRH")
		CriarSX6("MV_EMAILRH","C","Guarda os usuarios do RH que recebem o aviso do desconto de multa","000179#000202")
	EndIf

	cEmail := Alltrim(GetMV("MV_EMAILRH"))

	aEmail := {}

	nInicio := 1

	While nInicio < Len(cEmail)

		cUser := Substr(cEmail,nInicio,6)

		Aadd(aEmail,Alltrim(UsrRetMail(cUser)))

		nInicio += 7

	End

	For nX := 1 to Len(aEmail)

		oAviso:NewTask('Desconto de Multa','\workflow\html\AvisoMulta.htm')
		oAviso:cTo := aEmail[nX]
		oAviso:cSubject := "Desconto de Multa de Funcionario "+SRA->RA_NOME

		oAviso:oHtml:ValByName("cRepoImagem"	, cRepoImagem)

		oAviso:oHtml:ValByName("cMatFunc"  , SRA->RA_MAT)
		oAviso:oHtml:ValByName("cNomeFunc" , SRA->RA_NOME)
		oAviso:oHtml:ValByName("cCPF" , SRA->RA_CIC)

		oAviso:oHtml:ValByName("cNum" , cPedido)
		oAviso:oHtml:ValByName("cEmissao" , Dtoc(SC7->C7_EMISSAO))

		oAviso:oHtml:ValByName("cValorMulta" ,TRANSFORM( SC7->C7_TOTAL,'@E 999,999,999.99' )) //Data da Necessidade

		oAviso:oHtml:ValByName("cObs" , Alltrim(SC7->C7_OBS))

		oAviso:Start()
		oAviso:Finish()

	Next

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MT120FIM  ∫Autor  ≥Microsiga           ∫ Data ≥  10/08/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Pega o valor do adiantamento que sera feito ao fornecedor  ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Especifico                                                ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function GetVlrPA()
	Local nValor := 0, oValor, oTotPed

	nOpca := 0

	DEFINE MSDIALOG oDlgProc TITLE "Valor do Adiantamento " From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,145 of oDlgProc PIXEL

	@  07,5 Say "Tot. Ped.: " Size 50,10  of oDlgProc Pixel
	@ 06,55 MSGet oTotPed Var nTotPed   Picture "@E 999,999,999.99" When .F.   Size 80 ,10 of oDlgProc Pixel

	@ 21,5 Say "Valor: " Size 50,10  of oDlgProc Pixel
	@ 20,55 MSGet oValor Var nValor  Picture "@E 999,999,999.99" Valid ChkVlrAdi(@nValor)  Size 80 ,10 of oDlgProc Pixel

	@ 50, 90 BUTTON "OK"     Size 20,10  Action {||nOpca := 1,oDlgProc:End()} of oDlgProc Pixel
	@ 50,120 BUTTON "Cancel" Size 20,10  Action {||nOpca := 2,oDlgProc:End()} of oDlgProc Pixel

	ACTIVATE MSDIALOG oDlgProc Centered

Return nValor

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MT120FIM  ∫Autor  ≥Microsiga           ∫ Data ≥  10/08/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function ChkVlrAdi(nValor)
	Local lRet := .T.

	If nValor > 0

		If nValor > nTotPed

			MsgStop("Valor do adiantamento maior que o valor do Pedido" )

			lRet := .F.

		EndIf

	EndIf

Return lRet

/*/

Envia o Workflow do pedido sem necessitar altera-lo

/*/

User Function EnvWFPed()

	Private cLinkArq := "http://va8pf4.prd.protheus.totvscloud.com.br:31148/dirdoc"
	cPath   := "/co01/shared/"

	nTipo := 3

	cPedido := SC7->C7_NUM
	lAtendido := .F.

	DbSelectArea("SC7")
	DbSetOrder(1)
	DbSeek(xFilial()+cPedido)

	While SC7->(!Eof()) .And. SC7->C7_FILIAL + SC7->C7_NUM == XFILIAL("SC7")+cPedido

		If SC7->C7_QUJE >0 .Or. SC7->C7_RESIDUO == "S"
			lAtendido := .T.
			Exit
		EndIf

		SC7->(DbSkip())

	End

	If lAtendido

		MsgStop("Pedido nao se encontra mais em aberto. nao sera enviado Workflow")
		Return

	EndIf

	DbSelectArea("SC7")
	DbSetOrder(1)
	DbSeek(xFilial()+cPedido)

	cEmailCo := ""

	cFil := xFilial("SCR")

	cQuery1 := " UPDATE "+retsqlname("SCR")
	cQuery1 += " SET CR_WF = '1' "
	cQuery1 += " WHERE CR_NUM = '"+cPedido+"' AND CR_STATUS = '02' AND CR_FILIAL = '"+cFil+"' AND "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' "

	TcSqlExec(cQuery1)

	cAliasTop2 := GetNextAlias()

	cQuery2 := " SELECT DISTINCT  C7_FILIAL, C7_ITEM, C7_NUM, A2_COD + ' - ' +A2_NOME AS A2_NOME, C7_EMISSAO, C7_USER, C7_PRODUTO,C7_NUMSC, C7_TXMOEDA, C7_MOEDA, C7_DTPGTO , "
	cQuery2 += " C7_DESCRI + ' - '+C7_OBS AS C7_DESCRI, C7_UM, C7_QUANT, C7_PRECO, C7_TOTAL, E4_DESCRI, C7_IPI, C7_DATPRF, C7_OBS, C7_OBSPED, C7_VERSAO, "
	cQuery2 += " C7_CC, C7_FRETE, C7_DESPESA, C7_VALFRE, C7_DESC, CR_USER, CR_NIVEL, CR_APROV, CR_USERLIB, CR_LIBAPRO, CR_USERORI, CR_APRORI, CR_TOTAL "
	cQuery2 += " FROM "+retsqlname("SC7")+" INNER JOIN "+retsqlname("SA2")+" ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA "
	cQuery2 += " INNER JOIN "+retsqlname("SE4")+" ON E4_CODIGO = C7_COND "
	cQuery2 += " INNER JOIN "+retsqlname("SCR")+" ON CR_NUM = C7_NUM AND CR_FILIAL = C7_FILIAL "
	cQuery2 += " WHERE "+retsqlname("SC7")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SA2")+".D_E_L_E_T_ <> '*' "
	cQuery2 += " AND "+retsqlname("SE4")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' AND C7_NUM = '"+cPedido+"' "
	cQuery2 += " AND CR_STATUS = '02' "

	dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuery2),cAliasTop2,.F.,.T.)

	dbSelectArea(cAliasTop2)
	DBGOTOP()
	if ! empty((cALIASTOP2)->C7_NUMSC)
		SC1->(DBSEEK(XFILIAl("SC1")+(cALIASTOP2)->C7_NUMSC ))

		cSolic := sc1->c1_solicit
	else
		cSolic := ""
	endif

	cNomeAp    := UsrFullName((cALIASTOP2)->CR_USER)
	cAprovador := (cALIASTOP2)->CR_USER
	cNomeCo    := UsrFullName((cALIASTOP2)->C7_USER)
	cVersao    := (cALIASTOP2)->C7_VERSAO

	//para enviar copia de email
	SB1->(DBSEEK(XFILIAL("SB1")+(cALIASTOP2)->C7_PRODUTO ))
	cGrupo := sb1->b1_grupo
	do case
		case cGrupo == "LOCA"
		cEmailCo := "michelle.miranda@sacseng.com.br"
	EndCase

	If  SC7->C7_VLR_PA > 0 //lAntCxa .Or.
		///		cEmailCo := "andre.souza@sacseng.com.br"
	EndIf

	aAttach := {}
	lPri    := .T.

	DbSelectArea("AC9")
	DbSetOrder(2)
	If DbSeek(xFilial("AC9")+"SC7"+SC7->C7_FILIAL+SC7->C7_FILIAL+cPedido )

		While AC9->(!Eof()) .And. Substr(AC9->AC9_CODENT,1,8) ==  SC7->C7_FILIAL+cPedido

			DbSelectArea("ACB")
			DbSetOrder(1)
			DbSeek(xFilial("ACB")+AC9->AC9_CODOBJ )
			//AaDd(aAttach,{Alltrim(ACB->ACB_DESCRI)+".PDF" } )

			AaDd(aAttach,Alltrim(ACB->ACB_DESCRI)+".PDF")

			DbSelectArea("AC9")
			AC9->(DbSkip())

		End

	Else

		MsgInfo( "Pedido nao possui documentos anexados.." )

	EndIf

	CONOUT ("*****|| "+DTOC(DATE())+" - " + TIME())
	CONOUT ("*****|| Iniciando processo WorkFlow/Aprovacao Pedido de Compras")
	CONOUT ("*****|| Pedido : "+cPedido+" *****||")

	oWF := TWFProcess():New('PEDCOM01','Envio Aprovacao PC:' + cPedido + "/" +(cALIASTOP2)->CR_NIVEL)
	oWF:cPriority := "3"
	/*
	IF ALTERA
	IF sc7->c7_tipped == "3"
	oWF:NewTask("Envio PC:" + cPedido ,"\WORKFLOW\HTML\wfpcFIN.HTM" )
	ELSE
	//oWF:NewTask("Envio PC:" + cPedido ,"\WORKFLOW\HTML\wfpcalt.HTM" )
	oWF:NewTask("Envio PC:" + cPedido ,"\WORKFLOW\HTML\wfpc.HTM" )
	ENDIF
	ELSE */
	oWF:NewTask("Envio PC:" + cPedido ,"\WORKFLOW\HTML\wfpc.HTM" )

	//	ENDIF
	oWF:bReturn := "U_WfPcRet"
	oWF:cTo := "\workflow\"
	if ALTERA
		oWF:cSubject := "AprovaÁ„o de AlteraÁ„o de Pedido de Compras "+cPedido+" / "+cVersao
	else
		oWF:cSubject := "AprovaÁ„o de Inclus„o de Pedido de Compras "+cPedido
	endif

	CONOUT ("*****GERANDO CABECALHO DO PEDIDO******")

	oWF:oHtml:ValByName( "cEmpresa"	    , SM0->M0_CODIGO  )
	oWF:oHtml:ValByName( "cNomeEmp"	    , SM0->M0_NOMECOM  )
	oWF:oHtml:ValByName( "cFil"	        , SM0->M0_CODFIL )
	oWF:oHtml:ValByName( "cPedido"	    , cPedido )
	oWF:oHtml:ValByName( "dEmissao"     , STOD((cALIASTOP2)->C7_EMISSAO) )
	oWF:oHtml:ValByName( "cFornece"	    , (cALIASTOP2)->A2_NOME)
	oWF:oHtml:ValByName( "dTPagto"	    , STOD((cALIASTOP2)->C7_DTPGTO)  )

	oWF:oHtml:ValByName( "cComprador"   ,  cNomeCo    )
	oWF:oHtml:ValByName( "cAprovador"   ,  cNomeAp    )
	oWF:oHtml:ValByName( "cPag"         , (cALIASTOP2)->E4_DESCRI)
	oWF:oHtml:ValByName( "cSolic"       , cSolic )
	oWF:oHtml:ValByName( "obsped"       , (cALIASTOP2)->C7_OBS )
	oWF:oHtml:ValByName( "CONGERPED"    , (cALIASTOP2)->C7_OBSPED )

	if (cALIASTOP2)->C7_MOEDA == 1
		oWF:oHtml:ValByName( "nTotalr"	    , TRANSFORM((cALIASTOP2)->CR_TOTAL,'@E 999,999,999.99'))
		oWF:oHtml:ValByName( "nTaxa"	    , TRANSFORM((cALIASTOP2)->C7_TXMOEDA,'@E 999,999,999.99'))
		oWF:oHtml:ValByName( "nTotald"	    , TRANSFORM(0,'@E 999,999,999.99'))
	else
		oWF:oHtml:ValByName( "nTotalr"	    , TRANSFORM((cALIASTOP2)->CR_TOTAL*(cALIASTOP2)->C7_TXMOEDA,'@E 999,999,999.99'))
		oWF:oHtml:ValByName( "nTaxa"	    , TRANSFORM((cALIASTOP2)->C7_TXMOEDA,'@E 999,999,999.99'))
		oWF:oHtml:ValByName( "nTotald"	    , TRANSFORM((cALIASTOP2)->CR_TOTAL,'@E 999,999,999.99'))
	endif
	oWF:oHtml:ValByName( "CR_USER"      ,  AllTrim((cALIASTOP2)->CR_USER))
	oWF:oHtml:ValByName( "CR_APROV"     ,  AllTrim((cALIASTOP2)->CR_APROV))

	CONOUT ("*****GERANDO ITENS DO PEDIDO******")
	nTotal := nDespesas := nDesconto := 0
	aProdutos := {}

	cProd := ""
	While !(cAliasTop2)->(EOF())
		aadd(oWF:oHtml:ValByName("t1.cCod"    ), (cALIASTOP2)->C7_PRODUTO)
		aadd(oWF:oHtml:ValByName("t1.cDescri" ), (cALIASTOP2)->C7_DESCRI)
		aadd(oWF:oHtml:ValByName("t1.cUm"     ), (cALIASTOP2)->C7_UM)
		aadd(oWF:oHtml:ValByName("t1.nQuant"  ), TRANSFORM((cALIASTOP2)->C7_QUANT,'@E 999,999.9999'))
		aadd(oWF:oHtml:ValByName("t1.nIPI"    ), TRANSFORM((cALIASTOP2)->C7_IPI,'@E 99.99'))
		aadd(oWF:oHtml:ValByName("t1.nTotal"  ), TRANSFORM((cALIASTOP2)->C7_TOTAL,'@E 999,999,999.99'))

		if (cALIASTOP2)->C7_moeda == 1
			aadd(oWF:oHtml:ValByName("t1.nUnitr"   ), TRANSFORM((cALIASTOP2)->C7_PRECO,'@E 999,999.9999'))
			aadd(oWF:oHtml:ValByName("t1.nUnitd"   ), TRANSFORM(0,'@E 999,999.9999'))
		else
			aadd(oWF:oHtml:ValByName("t1.nUnitd"   ), TRANSFORM((cALIASTOP2)->C7_PRECO,'@E 999,999.9999'))
			aadd(oWF:oHtml:ValByName("t1.nUnitr"   ), TRANSFORM((cALIASTOP2)->C7_PRECO*(cALIASTOP2)->C7_TXMOEDA,'@E 999,999.9999'))

		endif

		aadd(oWF:oHtml:ValByName("t1.dEnt"    ), STOD((cALIASTOP2)->C7_DATPRF))
		aadd(oWF:oHtml:ValByName("t1.cCusto"  ), (cALIASTOP2)->C7_CC)

		nTotal := nTotal + (cALIASTOP2)->C7_TOTAL
		nDespesas := nDespesas +(cALIASTOP2)->C7_FRETE + (cALIASTOP2)->C7_DESPESA + (cALIASTOP2)->C7_VALFRE
		nDesconto := nDesconto + (cALIASTOP2)->C7_DESC

		nPesq := Ascan(aProdutos,{|x|x[1] = (cALIASTOP2)->C7_PRODUTO } )
		If nPesq == 0
			Aadd(aProdutos,{ (cALIASTOP2)->C7_PRODUTO} )
		endif
		(cAliasTop2)->(DBSkip())
	EndDo

	oWF:oHtml:ValByName("nValMerc"  , TRANSFORM(nTotal,'@E 999,999,999.99'))
	oWF:oHtml:ValByName("nFrete"    , TRANSFORM(nDespesas,'@E 999,999.99'))
	oWF:oHtml:ValByName("nDesc"     , TRANSFORM(nDesconto,'@E 999,999.99'))

	cAliasTop3 := GetNextAlias()
	lPedidos := .F.
	aSC7 := {}
	For j = 1 to len(aProdutos)

		cQuery3 := " SELECT TOP 3 C7_FILIAL, C7_ITEM, C7_PRODUTO, C7_NUM, C7_FORNECE, C7_LOJA, A2_NOME, C7_QUANT, C7_CC , "
		cQuery3 += " C7_PRECO, C7_IPI , C7_EMISSAO, C7_DATPRF, C7_COND, E4_DESCRI, C7_QUJE "
		cQuery3 += " FROM "+retsqlname("SC7")+" C7 "
		cQuery3 += " INNER JOIN "+retsqlname("SA2")+" A2 ON "
		cQuery3 += " 	C7_FORNECE = A2_COD AND "
		cQuery3 += " 	C7_LOJA = A2_LOJA AND  "
		cQuery3 += " 	A2.D_E_L_E_T_='' "
		cQuery3 += " INNER JOIN "+retsqlname("SE4")+" E4 ON "
		cQuery3 += " 	C7_COND = E4_CODIGO AND "
		cQuery3 += " 	E4.D_E_L_E_T_='' "
		cQuery3 += " INNER JOIN "+retsqlname("SB1")+" B1 ON "
		cQuery3 += " 	B1.D_E_L_E_T_='' AND "
		cQuery3 += " 	B1_COD=C7_PRODUTO AND "
		//cQuery3 += " 	B1_TIPO not in ('GG') AND "
		cQuery3 += " 	B1_FILIAL='" + xFilial("SB1") + "' "
		cQuery3 += " WHERE C7_FILIAL =  '"+cFil+"' AND  C7_PRODUTO='"+aProdutos[j,1]+"' AND C7_QUJE <> 0 " //AND C7_ENCER <> ' ' "
		cQuery3 += " AND C7.D_E_L_E_T_ <> '*' "
		cQuery3 += " ORDER BY C7_EMISSAO DESC "

		dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuery3),cAliasTop3,.T.,.T.)

		DbSelectArea(cAliasTop3)
		dbGoTop()

		While !Eof()
			Aadd( aSC7, {(cAliasTop3)->C7_PRODUTO , ;
			(cAliasTop3)->C7_NUM , ;
			(cAliasTop3)->A2_NOME, ;
			TRANSFORM((cAliasTop3)->C7_QUANT,'@E 999,999.999'), ;
			TRANSFORM((cAliasTop3)->C7_PRECO,'@E 999,999.99') , ;
			TRANSFORM((cAliasTop3)->C7_IPI ,'@E 999,999.99')  , ;
			DtoC(StoD((cAliasTop3)->C7_EMISSAO)) , ;
			(cAliasTop3)->C7_CC  , ;
			(cAliasTop3)->E4_DESCRI} )
			lPedidos := .T.
			(cAliasTop3)->(DBSkip())
		EndDo

		DbSelectArea(cALIASTOP3)
		DbCloseArea(cAliasTop3)

	Next

	If !lPedidos
		cExibe  := "<p><font color='#FF0000'>*** N„o h· historico de pedidos ***</font></p>"
		aadd(oWF:oHtml:ValByName("t2.cCod"      ),"--")
		aadd(oWF:oHtml:ValByName("t2.cPedido"   ),"--")
		aadd(oWF:oHtml:ValByName("t2.Fornece"   ),"--")
		aadd(oWF:oHtml:ValByName("t2.nQuant"    ),"--")
		aadd(oWF:oHtml:ValByName("t2.nUnit"     ),"--")
		aadd(oWF:oHtml:ValByName("t2.nIPI"      ),"--")
		aadd(oWF:oHtml:ValByName("t2.dEmissao"  ),"--")
		aadd(oWF:oHtml:ValByName("t2.cCusto"  ),"--")
		aadd(oWF:oHtml:ValByName("t2.cPgto"     ),"--")

	Else
		cItem := ""
		For j := 1 To Len(aSC7)
			aadd(oWF:oHtml:ValByName("t2.cCod"      ),aSC7[j][1])
			aadd(oWF:oHtml:ValByName("t2.cPedido"   ),aSC7[j][2])
			aadd(oWF:oHtml:ValByName("t2.Fornece"   ),aSC7[j][3])
			aadd(oWF:oHtml:ValByName("t2.nQuant"    ),aSC7[j][4])
			aadd(oWF:oHtml:ValByName("t2.nUnit"     ),aSC7[j][5])
			aadd(oWF:oHtml:ValByName("t2.nIPI"      ),aSC7[j][6])
			aadd(oWF:oHtml:ValByName("t2.dEmissao"  ),aSC7[j][7])
			aadd(oWF:oHtml:ValByName("t2.cCusto"  ),aSC7[j][8])
			aadd(oWF:oHtml:ValByName("t2.cPgto"     ),aSC7[j][9])
			cItem := aSC7[j][1]
		Next
	EndIf
	IF sc7->c7_tipped == "3"
		aadd(oWF:oHtml:ValByName("t4.prefixo"     ), "--")
		aadd(oWF:oHtml:ValByName("t4.titulo"      ), "--")
		aadd(oWF:oHtml:ValByName("t4.valor"       ), "--")
		aadd(oWF:oHtml:ValByName("t4.emissao"     ), "--")

		aadd(oWF:oHtml:ValByName("t4.vencimento"  ), "--" )
		aadd(oWF:oHtml:ValByName("t4.dtprevpagto" ), "--" )
	endif

	cAliasTop5 := GetNextAlias()

	cQuerySCR := " SELECT CR_NUM, CR_USER, AK_NOME, CR_NIVEL, CR_STATUS, CR_DATALIB, CR_OBS "
	cQuerySCR += " FROM "+retsqlname("SCR")+" INNER JOIN "+RETSQLNAME("SAK")+" ON CR_USER = AK_USER "
	cQuerySCR += " WHERE "+retsqlname("SCR")+".D_E_L_E_T_ <> '*' AND "+retsqlname("SAK")+".D_E_L_E_T_ <> '*' "
	cQuerySCR += " AND CR_NUM = '"+cPedido+"' AND CR_FILIAL = '"+cFil+"' "

	dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuerySCR),cAliasTop5,.T.,.T.)

	While !(cAliasTop5)->(EOF())

		Do Case
			Case (cALIASTOP5)->CR_STATUS = "01"
			cStatus:= "Nivel Bloqueado"
			Case (cALIASTOP5)->CR_STATUS = "02"
			cStatus:= "Aguardando Liberacao"
			Case (cALIASTOP5)->CR_STATUS = "03"
			cStatus:= "Pedido Aprovado"
			Case (cALIASTOP5)->CR_STATUS = "04"
			cStatus:= "Pedido Bloqueado"
		EndCase

		aadd(oWF:oHtml:ValByName("t3.cNivel"     ), (cALIASTOP5)->CR_NIVEL)
		aadd(oWF:oHtml:ValByName("t3.cAprovador" ), (cALIASTOP5)->AK_NOME)
		aadd(oWF:oHtml:ValByName("t3.cStatus"    ),  cStatus)
		aadd(oWF:oHtml:ValByName("t3.dDataLib"   ),  STOD((cALIASTOP5)->CR_DATALIB))
		aadd(oWF:oHtml:ValByName("t3.Obs"        ), (cALIASTOP5)->CR_OBS)

		(cAliasTop5)->(DBSkip())

	EndDo

	oWF:oHtml:ValByName("t5.arquivos" ,{})
	oWF:oHtml:ValByName("t5.anexos" ,{})

	If Len(aAttach) > 0

		For nX := 1 to Len(aAttach)

			cArquivo := cLinkArq+cPath+aAttach[nX]

			aadd(oWF:oHtml:ValByName("t5.arquivos" ),cArquivo )
			aadd(oWF:oHtml:ValByName("t5.Anexos" ),"Anexo "+StrZero(nX,2) )

		Next
	Else

		aadd(oWF:oHtml:ValByName("t5.arquivos" )," ")
		aadd(oWF:oHtml:ValByName("t5.anexos" ),"sem Anexo " )

	EndIf

	cHtml := oWF:Start("\workflow\emp"+SM0->M0_CODIGO+"\tp\")

	cLinkext := GetMV("MV_WFHTTPE")+"/emp"+SM0->M0_CODIGO+"/tp/"+cHtml+".htm"
	cLinkint := GetMV("MV_WFHTTPI")+"/emp"+SM0->M0_CODIGO+"/tp/"+cHtml+".htm"

	CONOUT ("*****Modelo Configurado******")
	oWF:NewTask("Criando Link","\workflow\html\link_.htm")

	oWF:cTo  := UsrRetMail(cAprovador) ///"carlos@vbservices.com.br" //
	oWF:cBCC := cEmailCo
	oWF:oHtml:ValByName("cLinkext" , cLinkext)
	oWF:oHtml:ValByName("cLinkint" , cLinkint)

	oWF:Start()
	CONOUT ("*****criando link******")

	cEmailCo := ""

	MsgInfo("Workflow reenviado com sucesso...")

Return()

/*/

Anexa documentos ao pedido de compra

/*/
User Function AnexaDoc()

	DbSelectArea("SC7")
	DbSetOrder(1)
	DbSeek(xFilial()+ca120num)

	//	If INCLUI
	//	   MsDocument( "SC7", SC7->(RecNo()),3,,,,.T.)
	//	Else
	MsDocument( "SC7", SC7->(RecNo()),1)
	//	EndIf

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MT120FIM  ∫Autor  ≥Microsiga           ∫ Data ≥  10/08/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Pega o valor do adiantamento que sera feito ao fornecedor  ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Especifico                                                ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function GetNumSol()
	Local oSolic, oDtSol

	nOpca := 0

	DEFINE MSDIALOG oDlgProc TITLE "Dados da Solicitacao" From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,145 of oDlgProc PIXEL

	@  07,5 Say "Solicitacao" Size 50,10  of oDlgProc Pixel
	@ 06,55 MSGet oSolic  Var cSolic When .T.   Size 80 ,10 of oDlgProc Pixel

	@ 21,5 Say "Dt Solic: " Size 50,10  of oDlgProc Pixel
	@ 20,55 MSGet oDtSol Var dDtSol   Size 80 ,10 of oDlgProc Pixel

	@ 50, 90 BUTTON "OK"     Size 20,10  Action {||nOpca := 1,oDlgProc:End()} of oDlgProc Pixel
	@ 50,120 BUTTON "Cancel" Size 20,10  Action {||nOpca := 2,oDlgProc:End()} of oDlgProc Pixel

	ACTIVATE MSDIALOG oDlgProc Centered

Return

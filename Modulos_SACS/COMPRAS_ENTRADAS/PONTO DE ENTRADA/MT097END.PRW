#include "rwmake.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT097END  ºAutor  ³Carlos R Moreira    º Data ³  04/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para enviar a resposta de aprovacao do     º±±
±±º          ³pedido de compra para o usuario que colocou o pedido        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT097END()
	Local aArea := GetArea()

	nOpcao := ParamIxb[3]
	cDocto := ParamIxb[1]

Return 
	DbSelectArea("SC7")
	DbSetOrder(1)
	DbSeek(xFilial("SC7")+cDocto )

	If SC7->C7_CONAPRO = "L"

		EnvAprCom(cDocto)

//	Else

//		U_EnvWFPed()

	EndIf

	RestArea( aArea )

Return


Static Function EnvAprCom(cPedido)

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
	cQuery2 += " FROM "+retsqlname("https://tdn.totvs.com/pages/releaseview.action?pageId=6085781")+" "
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
		oWF:oHtml:ValByName( "nTotal"	    , TRANSFORM(0,'@E 999,999,999.99'))
	else
		oWF:oHtml:ValByName( "nTotalr"	    , TRANSFORM((cALIASTOP12)->CR_TOTAL*(cALIASTOP12)->C7_TXMOEDA,'@E 999,999,999.99'))
		oWF:oHtml:ValByName( "nTaxa"	    , TRANSFORM((cALIASTOP12)->C7_TXMOEDA,'@E 999,999,999.99'))
		oWF:oHtml:ValByName( "nTotal"	    , TRANSFORM((cALIASTOP12)->CR_TOTAL,'@E 999,999,999.99'))
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
			aadd(oWF:oHtml:ValByName("t1.nUnitr"   ), TRANSFORM((cALIASTOP12)->C7_PRECO,'@E 999,999.9999'))
			aadd(oWF:oHtml:ValByName("t1.nUnitd"   ), TRANSFORM(0,'@E 999,999.9999'))
		else
			aadd(oWF:oHtml:ValByName("t1.nUnitr"   ), TRANSFORM((cALIASTOP12)->C7_PRECO*(cALIASTOP12)->C7_TXMOEDA,'@E 999,999.9999'))
			aadd(oWF:oHtml:ValByName("t1.nUnitd"   ), TRANSFORM((cALIASTOP12)->C7_PRECO,'@E 999,999.9999'))
		endif

		aadd(oWF:oHtml:ValByName("t1.dEnt"    ), STOD((cALIASTOP12)->C7_DATPRF))
		aadd(oWF:oHtml:ValByName("t1.cCusto"  ), (cALIASTOP12)->C7_CC)

		nTotal    := nTotal    + (cALIASTOP12)->C7_TOTAL
		nDespesas := nDespesas +(cALIASTOP12)->C7_FRETE + (cALIASTOP12)->C7_DESPESA + (cALIASTOP12)->C7_VALFRE
		nDesconto := nDesconto + (cALIASTOP12)->C7_DESC

		nPesq := Ascan(aProdutos,{|x|x[1] = (cALIASTOP2)->C7_PRODUTO } )
		If nPesq == 0
			Aadd(aProdutos,{ (cALIASTOP2)->C7_PRODUTO} )
		endif

		(cAliasTop12)->(DBSkip())

	EndDo

	oWF:oHtml:ValByName("nValMerc"  , TRANSFORM(nTotal,'@E 999,999,999.99'))
	oWF:oHtml:ValByName("nFrete"    , TRANSFORM(nDespesas,'@E 999,999.99'))
	oWF:oHtml:ValByName("nDesc"     , TRANSFORM(nDesconto,'@E 999,999.99'))

	dbSelectArea(cALIASTOP12)
	dbGoTop()

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

	cHtml := oWF:Start()

Return
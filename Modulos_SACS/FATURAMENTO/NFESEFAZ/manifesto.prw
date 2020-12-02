#Include "Protheus.ch"
#INCLUDE "APWIZARD.CH"
#INCLUDE "SPEDNFE.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"


#DEFINE nPercAlt 2.4
#DEFINE TAMMAXXML 400000 //- Tamanho maximo do XML em bytes

#DEFINE TRANSMITIDO 		'1'
#DEFINE NAO_TRANSMITIDO 	'2'
#DEFINE AUTORIZADO			'3'
#DEFINE NAO_AUTORIZADO		'4'
#DEFINE CANCELADO			'5'
#DEFINE ENCERRADO			'6'
#DEFINE EVENAOREALIZADO	'1'
#DEFINE EVEREALIZADO		'2'
#DEFINE EVEVINCULADO		'3'
#DEFINE EVENAOVINCULADO	'4'

//-----------------------------------------------------------------------
/*/ SPEDMDFE
Função principal

@author Natalia Sartori
@since 10/02/2014
@version P11
/*/

//-----------------------------------------------------------------------
User Function MANIFESTO()
	Local aArea     := GetArea()
	Local lRetorno  := .T.
	Local nVezes    := 0
	Private aRotina	:= MenuDef()
	Private cMark	:= GetMark()
	Private lBtnFiltro:= .F.
	
	Private oMsSel 		:= Nil
	Private oListDocs	:= Nil
	Private oGerMDFe 	:= Nil
	Private oOkx		:= LoadBitmap( GetResources(), "LBOK" )
	Private oNo			:= LoadBitmap( GetResources(), "LBNO" )
	Private aListDocs	:= {{oNo,"","",STOD("20010101"),"1",.F.}}
	Private aHeadMun	:= GetHeaderMun()
	Private aColsMun	:= GetNewLine(aHeadMun,.T.)
	Private aHeadPerc	:= GetHeaderPerc()
	Private aColsPerc	:= GetNewLine(aHeadPerc)
	Private aHeadAuto	:= GetHeaderAuto()
	Private aColsAuto	:= GetNewLine(aHeadAuto)
	Private aHeadLacre	:= GetHeaderLacre()
	Private aColsLacre	:= GetNewLine(aHeadLacre)
	Private cNumMDF		:= Space(TamSx3('CC0_NUMMDF')[1])			//Variavel que contem o numero do MDFE
	Private cSerMDF		:= Space(TamSx3('CC0_SERMDF')[1])			//Variavel que contem a Serie do MDFE
	Private cUFCarr		:= Space(TamSx3('CC0_UFINI')[1])			//Variavel que contem a UF de Carregamento
	Private cUFDesc		:= Space(TamSx3('CC0_UFFIM')[1])			//Variavel que contem a UF de Descarregamento
	Private cUFCarrAux	:= Space(TamSx3('CC0_UFINI')[1])			//Variavel Auxiliar (para controle alteracoes) que contem a UF de Carregamento
	Private cUFDescAux	:= Space(TamSx3('CC0_UFFIM')[1])			//Variavel Auxiliar (para controle alteracoes) que contem a UF de Descarregamento
	Private cVTotal		:= Space(TamSx3('CC0_VTOTAL')[1])			//Variavel que contem o valor total da carga/mercadoria
	Private cVeiculo	:= Space(TamSx3('DA3_COD')[1])				//Variavel que contem
	Private cMotorista	:= Space(TamSx3('DA4_COD')[1])				//Variavel que contem
	Private cVeiculoAux	:= Space(TamSx3('DA3_COD')[1])				//Variavel Auxiliar (para controle alteracoes) que contem o codigo do veiculo
	Private nQtNFe		:= 0										//Variavel que contem a Quantidade total de NFe
	Private nVTotal		:= 0										//Variavel que contem a Valor total de notas
	Private nPBruto		:= 0										//Variavel que contem a Peso total do MDF-e
	Private cInfCpl		:= Space(5000)								//Variavel que contem as informacoes complementares do Manifesto
	Private cInfFsc		:= Space(2000)								//Variavel que contem as informacoes fiscais do Manifesto
	Private aCmpBrow 	:= {}
	Private aMun		:= {}
	Private cIndTRB1 	:= ""
	Private cIndTRB2 	:= ""
	Private cArqTRB	 	:= ""
	Private cEntSai		:= ""
	Private cStatFil 	:= ""
	Private cSerFil		:= ""
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ajuste no pergunte DAMDFE                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AjustaSX1()
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ajuste de dicionario - TEMPORARIO     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AjustaSX3()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ajuste de consulta padrao - TEMPORARIO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AjustaSXB()

	//Cria o arquivo de apoio TRB
	CreateTRB()
	
	While lRetorno
		lBtnFiltro:= .F.
		lRetorno := MDFInit(nVezes==0)
		nVezes++
		If !lBtnFiltro
			Exit
		EndIf
	EndDo
	
	RestArea(aArea)

Return Nil

//-----------------------------------------------------------------------
/*/ MDFInit
Função de montagem das perguntas e condição para efeturar o filtro

@author Natalia Sartori
@since 10/02/2014
@version P11
/*/
//-----------------------------------------------------------------------
Static Function MDFInit(lInit,cAlias)

	Local aPerg	 	:={}
	Local aStatus		:={}
	Local aCores 		:= GetLegColors()
	Local aIndArq		:={}
	Local aParam		:={"","",""}
	Local cMes			:= ""
	Local cFilMdf		:= SM0->M0_CODIGO+SM0->M0_CODFIL+"FILTROMDFE"
	Local lEvento		:= .F.
	Local lEntAtiva		:= .T.
//Local nCombo1		:= 0
	Private aFilBrw		:= {}
	Private nResHor 	:= GetScreenRes()[1] 				//Tamanho resolucao de video horizontal
	Private nResVer 	:= GetScreenRes()[2]               //Tamanho resolucao de video vertical
	Private lUsaColab	:= UsaColaboracao("5")
	Private cIdEnt	:= RetIdEnti(lUsaColab)
	Private cCadastro	:= iif(lUsaColab,"MDF-e - TOTVS Colaboração 2.0","MDF-e" + " - Entidade : " + cIdEnt)
	Private oWS

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se possui o update 157 executado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SX2->(dbSetOrder(1))
	If SX2->(dbSeek("CC0"))
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o serviço do TSS foi configurado no ambiente³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lInit .And. !lUsaColab
			If (!CTIsReady() .Or. !CTIsReady(,2))
				If PswAdmin(,,RetCodUsr()) == 0
					SpedNFeCFG()
				Else
					HelProg(,"FISTRFNFe")
				EndIf
			EndIf
			lEntAtiva := EntAtivTss()
		EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta as opçoes de filtro da ParamBox³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aadd(aStatus,"0-Sem filtro")//
		aadd(aStatus,"1-Transmitidos")//
		aadd(aStatus,"2-Não Transmitidos")//
		aadd(aStatus,"3-Autorizados")//
		aadd(aStatus,"4-Não Autorizados")//
		aadd(aStatus,"5-Cancelados")//
		aadd(aStatus,"6-Encerrados")//
    
		MV_PAR01	:= aParam[01] := PadR(ParamLoad(cFilMdf,aPerg,1,aParam[01]),9)
		MV_PAR02	:= aParam[02] := PadR(ParamLoad(cFilMdf,aPerg,2,aParam[01]),36)
		MV_PAR03	:= aParam[03] := PadR(ParamLoad(cFilMdf,aPerg,3,aParam[02]),3)
	//nCombo1	:= Iif(aScan(aStatus,{|x| x == Alltrim(aParam[01]) }) > 0,aScan(aStatus,{|x| x == AllTrim(aParam[01]) }),1)
		
		aadd(aPerg,{2,"Tipo de NFe",PadR("",Len("2-Entrada")),{"1-Saída","2-Entrada"},120,".T.",.T.,".T."}) //######
		aadd(aPerg,{2,"Filtra",aParam[02],aStatus,105,".T.",.F.,".T."})//Filtra
		aadd(aPerg,{1,"Série do MDFe",aParam[03],,,,,30,.F.})//
		
		If lUsaColab .Or. ( lEntAtiva .And. (!lInit .Or. CTIsReady()) )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Exibe a ParamBox ao Usuario³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ParamBox(aPerg,"Filtro",aParam,,,.T.,,,,cFilMdf,.T.,.T.)
		    
		    //Aplica o filtro definido a partir do pergunte da parambox ao usuario		
				MDFSetFilter(MV_PAR01,MV_PAR02,MV_PAR03,aStatus,@aIndArq)
			
			//Define as variaveis de filtro privadas
				cEntSai		:= SubStr(MV_PAR01,1,1)
				cStatFil	:= MV_PAR02
				cSerFil		:= MV_PAR03
	
			
   			//Exibe a mBrowse ao usuario
				mBrowse( 6, 1,22,75,"CC0",,,,,,aCores)

			//Desmonta os filtros criados pela MDFSetFilter apos usar a rotina
				RetIndex("CC0")
				dbClearFilter()
				aEval(aIndArq,{|x| Ferase(x[1]+OrdBagExt())})
			EndIf
		Else
			HelProg(,"FISTRFNFe")
		EndIf
	Else
		Aviso("MDF-e","Execute o compatibilizador NFEP11R1 (Id. NFE11R157) para o MDFe",{"Ok"},3) //"Execute o compatibilizador NFEP11R1 (Id. NFE11R157) para o MDFe"
	EndIf

Return

//-----------------------------------------------------------------------
/*/ GetLegColors
Retorna um array com as opçoes de cores para a legenda da mBrowse

@author Natalia Sartori
@since 10/02/2014
@version P11
/*/
//-----------------------------------------------------------------------
Static Function GetLegColors()
	Local 	aCores    := {{"CC0_STATUS=='1'",'BR_AZUL'},; 		//1-Transmitidos
	{"CC0_STATUS=='2'",'DISABLE'},; 	//2-Não Transmitidos
	{"CC0_STATUS=='3'",'ENABLE'},; 		//3-Autorizados
	{"CC0_STATUS=='4'",'BR_PRETO'},;	//4-Não Autorizados
	{"CC0_STATUS=='5'",'BR_LARANJA'},;	//5-Cancelados
	{"CC0_STATUS=='6'",'BR_AMARELO'}}	//6-Encerrados
	
Return aCores

//-----------------------------------------------------------------------
/*/ MDFSetFilter
Realiza a Filtragem de acordo com os parametros escolhidos na ParamBox

@author Natalia Sartori
@since 10/02/2014
@version P11
/*/
//-----------------------------------------------------------------------
Static Function MDFSetFilter(cTipo,cStatus,cSerie,aStatus,aIndArq)
	Local cCondicao 	:= ""
	Local bFiltraBrw	:= {}
	
	/*Realiza a Filtragem de acordo com os parametros escolhidos na ParamBox*/
	cCondicao := "CC0_FILIAL=='" + xFilial("CC0") + "'"

	If ValType(MV_PAR02) == "N"
		MV_PAR02 := aStatus[MV_PAR02]
	EndIf

	If !Empty(MV_PAR01) .and. SubStr(MV_PAR01,1,1) <> '1'  //"Tipo NF"
		cCondicao += " .and. CC0_TPNF == '" + SubStr(MV_PAR01,1,1) + "' "
	Else
		cCondicao += " .and. CC0_TPNF <> '2' "
	EndIf
	
	If !Empty(MV_PAR02) .and. SubStr(MV_PAR02,1,1) <> '0'  //"Status"
		cCondicao += " .and. CC0_STATUS == '" + SubStr(MV_PAR02,1,1) + "' "
	EndIf
	
	If !Empty(MV_PAR03)
		cCondicao+=" .and. CC0_SERMDF == '" + MV_PAR03 + "' "
	EndIF
	aFilBrw		:=	{'CC0',cCondicao}
	bFiltraBrw := {|| FilBrowse("CC0",@aIndArq,@cCondicao) }
	Eval(bFiltraBrw)

Return

//-----------------------------------------------------------------------
/*/ Utilização de menu Funcional

@author Natalia Sartori
@since 10/02/2014
@version P11
@param	aRotina		1. Nome a aparecer no cabecalho   
					2. Nome da Rotina associada                              
					3. Reservado                                              
					4. Tipo de Transação a ser efetuada:                       
          	  			1 - Pesquisa e Posiciona em um Banco de Dados         
						2 - Simplesmente Mostra os Campos                      
						3 - Inclui registros no Bancos de Dados                 
						4 - Altera o registro corrente                         
						5 - Remove o registro corrente do Banco de Dados       
					5. Nivel de acesso                                         
					6. Habilita Menu Funcional
@return	aRotina Array com opcoes da rotina	
/*/
//-----------------------------------------------------------------------
Static Function MenuDef()
	
	local lUsaColab	:= UsaColaboracao("5")
	
	if lUsaColab
		aRotina := {{ "Pesquisar" ,			"PesqBrw"		,0,1,0,.F.},; //
		{ "Visualizar",			"U_ManiVisual"	,0,2,0,.F.},; //
		{ "Incluir",			"U_ManiInclui"	,0,3,0,.F.},; //
		{ "Alterar" ,			"U_ManiAltera"	,0,4,0,.F.},; //Alterar
		{ "Excluir" ,			"U_ManiExclui"	,0,5,0,.F.},; //Excluir
		{ "Parametros",			"U_ManiParam"	,0,3,0,.F.},; //Parâmetros
		{ "Gerenciar MDFe",	"U_ManiManage"	,0,6,0,.F.},; //Gereciar MDFe
		{ "Damdfe",			"U_ManiDamDfe"	,0,2,0,.F.},; //Damdfe
		{ "Legenda",			"U_ManiLegend"	,0,3,0,.F.}}  //Legenda
	else

		aRotina := {{ "Pesquisar" ,			"PesqBrw"		,0,1,0,.F.},; //
		{ "Visualizar",			"U_ManiVisual"	,0,2,0,.F.},; //
		{ "Incluir",			"U_ManiInclui"	,0,3,0,.F.},; //
		{ "Alterar" ,			"U_ManiAltera"	,0,4,0,.F.},; //Alterar
		{ "Excluir" ,			"U_ManiExclui"	,0,5,0,.F.},; //Excluir
		{ "Wiz.Config.",			"SpedNFeCfg"	,0,3,0,.F.},; //
		{ "Parametros",			"U_ManiParam"	,0,3,0,.F.},; //Parâmetros
		{ "Gerenciar MDFe",	"U_ManiManage"	,0,6,0,.F.},; //Gereciar MDFe
		{ "Damdfe",			"U_ManiDamDfe"	,0,2,0,.F.},; //Damdfe
		{ "Legenda",			"U_ManiLegend"	,0,3,0,.F.}}  //Legenda

	endif
	           
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³     Ponto de entrada para o cliente customizar os botoes apresentados     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("MDFeMenu")
		aRotina := ExecBlock("MDFeMenu", .F., .F.,{aRotina})
	EndIf
          
Return aRotina

//----------------------------------------------------------------------
/*/ MDFeParam
Função de configuração dos parâmetros do MDF-e

@author Natalia Sartori
@since 10/02/2014
@version P11 

@param	
@Return 
/*/
//-----------------------------------------------------------------------
User Function ManiParam()

	Local aPerg1  	:= {}
	Local aParam 	:= {"","","","",""}

	Local aCombo1	:= {}	//Ambiente
	Local aCombo2	:= {}	//Modalidade
	Local aCombo3	:= {}	//Versao do leiaute do evento
	Local aCombo4	:= {}   //Versao do leiaute
	Local aCombo5	:= {}   //Versao do MDFe

	Local cCombo1	:= ""
	Local cCombo2	:= ""
	Local cCombo3	:= "1.00"
	Local cCombo4	:= "1.00"
	Local cCombo5	:= "1.00"

//Local cIdEnt	:= ""
	Local cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cParMANPar	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDMDFPAR"
//Local cModel	:= "58"

	Local lUsaColab	:= UsaColaboracao("5")
// Ambiente
	aadd(aCombo1,"1-Producao")	//
	aadd(aCombo1,"2-Homologacao")	//

// Modalidade do MDF-e
	aadd(aCombo2,"1-Normal") //
	aadd(aCombo2,"2-Contingência") //"2-Contingência"

// Versao do leiaute específico do evento
	aadd(aCombo3,"1.00")

// Versao do leiaute geral do evento
	aadd(aCombo4,"1.00")

// Versao do MDF-e
	aadd(aCombo5,"1.00")

	If CTIsReady(,,,lUsaColab)


		If lUsaColab
	
			ColParametros("MDF")
			lOk	:= .T.
	
		else

		// Obtem o codigo da entidade
		//cIdEnt := RetIdEnti()
		
		// Obtem o ambiente de configuracao
			oWS :=  WsSpedCfgNFe():New()
			oWS:cUSERTOKEN 		:= "TOTVS"
			oWS:cID_ENT    		:= cIdEnt
			oWS:nAmbienteMDFE  	:= 0
			oWS:cVersaoMDFE		:= "1.00"
			oWS:nModalidadeMDFE	:= 0
			oWS:cVERMDFELAYOUT	:= "1.00"
			oWS:cVERMDFELAYEVEN	:= "1.00"
			oWS:nSEQLOTEMDFE		:= 0
			oWS:_URL       		:= AllTrim(cURL)+"/SPEDCFGNFe.apw"
		//oWS:cModelo   		:= cModel
			lOk:= oWS:CFGMDFE()
	
			If lOk
				If Valtype(oWS:OWSCFGMDFERESULT:CAMBIENTEMDFE) <> "U"
					cCombo1 := oWS:OWSCFGMDFERESULT:CAMBIENTEMDFE
				Else
					cCombo1 := "2-Homologacao"	//
				EndIf
			// Modalidade
				If ValType(oWS:OWSCFGMDFERESULT:CMODALIDADEMDFE) <> "U"
					cCombo2	:= oWS:OWSCFGMDFERESULT:CMODALIDADEMDFE
				Else
					cCombo2	:= "1"
				EndIF
			// Versao do leiaute específico do evento
				If ValType(oWS:OWSCFGMDFERESULT:CVERMDFELAYOUT) <> "U"
					cCombo3	:= oWS:OWSCFGMDFERESULT:CVERMDFELAYOUT
				Else
					cCombo3	:= "1.00"
				EndIF
			// Versao do leiaute geral do evento
				If ValType(oWS:OWSCFGMDFERESULT:CVERMDFELAYEVEN) <> "U"
					cCombo4	:= oWS:OWSCFGMDFERESULT:CVERMDFELAYEVEN
				Else
					cCombo4	:= "1.00"
				EndIF
			// Versao do MDFe
				If ValType(oWS:OWSCFGMDFERESULT:CVERSAOMDFE) <> "U"
					cCombo5	:= oWS:OWSCFGMDFERESULT:CVERSAOMDFE
				Else
					cCombo5	:= "1.00"
				EndIF
			EndIf
	 
	
			AADD(aPerg1,{2,"Ambiente",cCombo1,aCombo1,120,".T.",.T.,".T."}) 			//
			AADD(aPerg1,{2,"Modalidade",cCombo2,aCombo2,120,".T.",.T.,".T."}) 			//
			AADD(aPerg1,{2,"Versao do leiaute do evento",cCombo3,aCombo3,120,".T.",.T.,".T."})	 		//
			AADD(aPerg1,{2,"Versao do leiaute",cCombo4,aCombo4,120,".T.",.T.,".T."}) 			//
			AADD(aPerg1,{2,"Versão MDFe",cCombo5,aCombo5,120,".T.",.T.,".T."})	//"Versao do MDFe"
		
			aParam := {cCombo1,cCombo2,cCombo3,cCombo4,cCombo5}
	
			If ParamBox(aPerg1,"MDF-e",aParam,,,,,,,cParMANPar,.T.,.F.)
		
				oWS :=  WsSpedCfgNFe():New()
				oWS:cUSERTOKEN 		:= "TOTVS"
				oWS:cID_ENT    		:= cIdEnt
				oWS:nAmbienteMDFE  	:= Val(Substr(aParam[1],1,1))
				oWS:cVersaoMDFE		:= aParam[5]
				oWS:nModalidadeMDFE	:= Val(aParam[2])
				oWS:cVERMDFELAYOUT	:= aParam[3]
				oWS:cVERMDFELAYEVEN	:= aParam[4]
				oWS:nSEQLOTEMDFE  	:= 0
				oWS:_URL       		:= AllTrim(cURL)+"/SPEDCFGNFe.apw"
				//oWS:cModelo   		:= cModel
				lOk:= oWS:CFGMDFE()
			  
				If lOk
					Aviso("MDF-e","Configuração efetuada com sucesso",{"Ok"},3)	//"Configuração efetuada com sucesso"
				Else
					Aviso("MDF-e","Houve um erro durante a configuracão",{"Ok"},3)	//
				EndIf
			EndIf
		EndIf
	Else
		Aviso("MDF-e","Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!",{"Ok"},3) //
	EndIF

Return

//-----------------------------------------------------------------------
/*/MDFeLegend()
Legenda da MarkBrow

@author Natalia Sartori
@since 10/02/2014
@version P11
/*/
//-----------------------------------------------------------------------   
User Function ManiLegend()

	Local aLegenda:= {}

	AADD(aLegenda, {"BR_AZUL"		,"1-Transmitidos"})//
	AADD(aLegenda, {"DISABLE"		,"2-Não Transmitidos"})//
	AADD(aLegenda, {"ENABLE"		,"3-Autorizados"})//
	AADD(aLegenda, {"BR_PRETO"		,"4-Não Autorizados"})//
	AADD(aLegenda, {"BR_LARANJA"	,"5-Cancelados"})//
	AADD(aLegenda, {"BR_AMARELO"	,"6-Encerrados"})//

	BrwLegenda(cCadastro,"Situacao MDF",aLegenda)

Return

//----------------------------------------------------------------------
/*/ MDFeVisual
Montagem da Dialog de visualização de um MDFe ja criado

@author Natalia Sartori
@since 10/02/2014
@version P11
@Return 
/*/
//-----------------------------------------------------------------------
User Function ManiVisual(cAlias, nReg, nOpc)
	
	//Antes de chamar a rotina de pintura de tela, define o conteudo das variaveis private
	LoadVarsByCC0(nOpc)

	//Chama a funcao que faz a pintura de tela, a partir das variaveis vazias
	ManiShowDlg(nOpc)
				
Return

//----------------------------------------------------------------------
/*/ MDFeInclui
Montagem da Dialog de inclusão do MDFe

@author Natalia Sartori
@since 10/02/2014
@version P11 

@param	
@Return 
/*/
//-----------------------------------------------------------------------
User Function ManiInclui(cAlias, nReg, nOpc)

  	//Antes de chamar a rotina de pintura de tela, define o conteudo das variaveis private
	ResetVars()
    
	//Chama a funcao que faz a pintura de tela, a partir das variaveis vazias
	ManiShowDlg(nOpc)
	
Return
      
//----------------------------------------------------------------------
/*/ MDFeAltera
Montagem da Dialog de alteração do MDFe

@author Natalia Sartori
@since 10/02/2014
@version P11 

@param	
@Return 
/*/
//-----------------------------------------------------------------------
User Function ManiAltera(cAlias, nReg, nOpc)

	If CC0->CC0_STATUS == NAO_TRANSMITIDO .or. CC0->CC0_STATUS == NAO_AUTORIZADO
		//Antes de chamar a rotina de pintura de tela, define o conteudo das variaveis private
		LoadVarsByCC0(nOpc)
	
		//Chama a funcao que faz a pintura de tela, a partir das variaveis vazias
		ManiShowDlg(nOpc)
		
	Else
		MsgInfo('Opcao nao disponivel de acordo com o status do documento.')
	EndIf
Return

//----------------------------------------------------------------------
/*/ MDFeExclui
Montagem da Dialog de exclusão do MDFe

@author Natalia Sartori
@since 10/02/2014
@version P11 

@param	
@Return 
/*/
//-----------------------------------------------------------------------
User Function ManiExclui(cAlias, nReg, nOpc)

	If CC0->CC0_STATUS == NAO_TRANSMITIDO .or. CC0->CC0_STATUS == NAO_AUTORIZADO
		//Antes de chamar a rotina de pintura de tela, define o conteudo das variaveis private
		LoadVarsByCC0(nOpc)
	
		//Chama a funcao que faz a pintura de tela, a partir das variaveis vazias
		ManiShowDlg(nOpc)
		
	  	//Antes de chamar a rotina de pintura de tela, define o conteudo das variaveis private
		ResetVars()
	Else
		MsgInfo('Opcao nao disponivel de acordo com o status do documento.')
	Endif
Return

//----------------------------------------------------------------------
/*/ MDFeDamDfe
Realiza a chamada da função responsavel pela Pintura do DamDfe

@author Natalia Sartori
@since 10/02/2014
@version P11 

@param	
@Return 
/*/
//-----------------------------------------------------------------------
User Function ManiDamDfe(cAlias, nReg, nOpc)

	SpedDAMDFE()
	//Recarrega a lista
	if oListDocs <> Nil
		ReloadListDocs()
	endif
Return

//----------------------------------------------------------------------
/*/ MDFeShowDlg
Montagem da Dialog de inclusão do MDFe

@author Natalia Sartori
@since 10/02/2014
@version P11 

@param	
@Return 
/*/
//-----------------------------------------------------------------------
Static Function ManiShowDlg(nOpc)
	Local nTopGD  	 := 0
	Local nLeftGD 	 := 0
	Local nDownGD 	 := 0
	Local nRightGD	 := 0
	Local lIncAltDel := (nOpc == 3 .or. nOpc == 4)
	Local nIncAltDel := GD_INSERT+GD_UPDATE+GD_DELETE
	Local cOperation := ""

	Local aObjects	:= {}
	Local aInfo		:= {}
	Local aSizeAut
	Local aPosObj 	:= {}
	Local lMV_VEICDCL:= GetNewPar("MV_VEICDCL",.T.)				//Parametro que verifica se utiliza a tabela LBW do template de combustiveis

	Private oTela 												//Objeto tipo "Dialog" - Tela Principal
	Private cCodMun := Space(TamSx3("CC2_CODMUN")[1])
	Private cNomMun := Space(TamSx3("CC2_MUN")[1])
	Private cEstMun := Space(TamSx3("CC2_EST")[1])
	Private dDtEmis := CtoD("  /  /  ")
	Private oGetQtNFe
	Private oGetPBruto
	Private oGetVTot
	Private oGetDMun
	Private oGetDPerc
	Private oGetDLacre
	Private oGetDAut
	Default nOpc 	:= 3

	Do Case
	Case nOpc == 2
		cOperation := "Visualizar"
	Case nOpc == 3
		cOperation := "Incluir"
	Case nOpc == 4
		cOperation := "Alterar"
	Case nOpc == 5
		cOperation := "Excluir"
	EndCase

	aSizeAut := MsAdvSize()

	aObjects := {}
	AAdd( aObjects, { 50, 40, .T., .T., .T. } )
	AAdd( aObjects, { 60, 70, .T., .T. ,.T.} )

	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
	aPosObj := MsObjSize( aInfo, aObjects, , .T. )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³       Monta a dialog Principal       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oTela:= MSDIALOG():Create()
	oTela:cName     		:= "oTela"
	oTela:cCaption  		:= "Manifesto eletronico de Documentos Fiscais - " + cOperation
	oTela:nLeft     		:= aSizeAut[7]	//MDFeResol(aSizeAut[7]		,.T.) //80
	oTela:nTop      		:= aSizeAut[1]	//MDFeResol(aSizeAut[1]		,.F.) //60
	oTela:nWidth    		:= aSizeAut[5]	//MDFeResol(aSizeAut[4]/2.94	,.T.) //95
	oTela:nHeight   		:= aSizeAut[6]+25	//MDFeResol(aSizeAut[4]/3.68	,.F.) //80
	oTela:lShowHint 		:= .F.
	oTela:lCentered 		:= .T.
	oTela:bInit 			:= {|| EnchoiceBar(oTela, {||( Iif(MDFeSetRec(nOpc),oTela:End(),.F.) )} , {||( oTela:End() )} ,, MDFeBut() ) }

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³         Monta os Paineis (TPanel)         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPanel1:= tPanel():Create(oTela,MDFeResol(0.1,.T.),MDFeResol(0.1,.F.),,,,,CLR_YELLOW,,MDFeResol(49.3,.T.),MDFeResol(8.8,.F.))
	oPanel2:= tPanel():Create(oTela,MDFeResol(6.8,.T.),MDFeResol(0.1,.F.),,,,,CLR_YELLOW,,MDFeResol(49.3,.T.),MDFeResol(26.8,.F.))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³         Monta as guias (Folders) da rotina         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTFolder := { 'Documentos', 'Carregamento/Percurso', 'Outros' }
	oTFolder := TFolder():New( MDFeResol(0.2,.T.),MDFeResol(0.5,.F.),aTFolder,,oPanel2,,,,.T.,,MDFeResol(46.5,.T.),MDFeResol(22.0,.F.) )
//	oTFolder := TFolder():New( MDFeResol(0.2,.T.),MDFeResol(0.5,.F.),aTFolder,,oPanel2,,,,.T.,,MDFeResol(46.5,.T.),MDFeResol(23.9,.F.) )
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³            Monta o Box1 - Cabeçalho          		³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBox1:= TGROUP():Create(oPanel1)
	oBox1:cName 	   := "oBox1"
	oBox1:cCaption     := "Informações do Manifesto"
	oBox1:nLeft 	   := MDFeResol(0.5,.T.)
	oBox1:nTop  	   := MDFeResol(4,.F.)
	oBox1:nWidth 	   := MDFeResol(93.5,.T.)
	oBox1:nHeight 	   := MDFeResol(12.7,.F.)
	oBox1:lShowHint    := .F.
	oBox1:lReadOnly    := .F.
	oBox1:Align        := 0
	oBox1:lVisibleControl := .T.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a legenda 'Numero'         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSayNum:= TSAY():Create(oPanel1)
	oSayNum:cName			:= "oSayNum"
	oSayNum:cCaption 		:= "Número:"
	oSayNum:nLeft 			:= MDFeResol(4,.T.)
	oSayNum:nTop 			:= MDFeResol( 8.3,.F.)
	oSayNum:nWidth 	   		:= MDFeResol(10,.T.)
	oSayNum:nHeight 		:= MDFeResol(2.5,.F.)
	oSayNum:lShowHint 		:= .F.
	oSayNum:lReadOnly 		:= .F.
	oSayNum:Align 			:= 0
	oSayNum:lVisibleControl	:= .T.
	oSayNum:lWordWrap 	  	:= .F.
	oSayNum:lTransparent 	:= .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a Get - Numero             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetNum:= TGET():Create(oPanel1)
	oGetNum:cName 	 		:= "oGetNum"
	oGetNum:nLeft 	 		:= MDFeResol(8,.T.)
	oGetNum:nTop 	 		:= MDFeResol( 8,.F.)
	oGetNum:nWidth 	 		:= MDFeResol(9,.T.)
	oGetNum:nHeight 	 	:= MDFeResol(nPercAlt,.F.)
	oGetNum:lShowHint 		:= .F.
	oGetNum:lReadOnly 		:= .F.
	oGetNum:Align 	 		:= 0
	oGetNum:lVisibleControl := .T.
	oGetNum:lPassword 		:= .F.
	oGetNum:lHasButton		:= .F.
	oGetNum:cVariable 		:= "cNumMDF"
	oGetNum:bSetGet 	 	:= {|u| If(PCount()>0,cNumMDF:=u,cNumMDF)}
	oGetNum:Picture   		:= PesqPict("CC0","CC0_NUMMDF")
	oGetNum:bWhen     		:= {|| .F.}
	oGetNum:bChange			:= {|| .T.}
	oGetNum:bValid			:= {|| .T.}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a legenda 'Serie'          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSaySerie:= TSAY():Create(oPanel1)
	oSaySerie:cName				:= "oSaySerie"
	oSaySerie:cCaption 			:= "Série"
	oSaySerie:nLeft 			:= MDFeResol(20,.T.)
	oSaySerie:nTop 		   		:= MDFeResol( 8.3,.F.)
	oSaySerie:nWidth 	   		:= MDFeResol(11,.T.)
	oSaySerie:nHeight 			:= MDFeResol(2.5,.F.)
	oSaySerie:lShowHint 		:= .F.
	oSaySerie:lReadOnly 		:= .F.
	oSaySerie:Align 			:= 0
	oSaySerie:lVisibleControl	:= .T.
	oSaySerie:lWordWrap 	  	:= .F.
	oSaySerie:lTransparent 		:= .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a Get - 'Serie'            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetSerie:= TGET():Create(oPanel1)
	oGetSerie:cName 	 		:= "oGetSerie"
	oGetSerie:nLeft 	 		:= MDFeResol(23,.T.)
	oGetSerie:nTop 	 	 		:= MDFeResol( 8,.F.)
	oGetSerie:nWidth 	 		:= MDFeResol(4,.T.)
	oGetSerie:nHeight 	 		:= MDFeResol(nPercAlt,.F.)
	oGetSerie:lShowHint 		:= .F.
	oGetSerie:lReadOnly 		:= .F.
	oGetSerie:Align 	 		:= 0
	oGetSerie:lVisibleControl 	:= .T.
	oGetSerie:lPassword 		:= .F.
	oGetSerie:lHasButton		:= .F.
	oGetSerie:cVariable 		:= "cSerMDF"
	oGetSerie:bSetGet 	 		:= {|u| If(PCount()>0,cSerMDF:=u,cSerMDF)}
	oGetSerie:Picture   		:= PesqPict("CC0","CC0_SERMDF")
	oGetSerie:bWhen     		:= {|| .F.}
	oGetSerie:bChange			:= {|| .T. }
	oGetSerie:bValid			:= {|| .T.}
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a legenda 'Uf.Carreg.'     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSayUFCarr:= TSAY():Create(oPanel1)
	oSayUFCarr:cName			:= "oSayUFCarr"
	oSayUFCarr:cCaption 		:= "UF Carregamento:"
	oSayUFCarr:nLeft 			:= MDFeResol(30,.T.)
	oSayUFCarr:nTop 			:= MDFeResol( 8.3,.F.)
	oSayUFCarr:nWidth 	   		:= MDFeResol(10,.T.)
	oSayUFCarr:nHeight 			:= MDFeResol(2.5,.F.)
	oSayUFCarr:lShowHint 		:= .F.
	oSayUFCarr:lReadOnly 		:= .F.
	oSayUFCarr:Align 			:= 0
	oSayUFCarr:lVisibleControl	:= .T.
	oSayUFCarr:lWordWrap 	  	:= .F.
	oSayUFCarr:lTransparent 	:= .F.
	oSayUFCarr:nClrText 		:= CLR_HBLUE
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a Get - 'Uf.Carreg.'       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetUfCarr:= TGET():Create(oPanel1)
	oGetUfCarr:cName 	 		:= "oGetUfCarr"
	oGetUfCarr:nLeft 	 		:= MDFeResol(38.5,.T.)
	oGetUfCarr:nTop 	 		:= MDFeResol( 8,.F.)
	oGetUfCarr:nWidth 	 		:= MDFeResol(5,.T.)
	oGetUfCarr:nHeight 	 		:= MDFeResol(nPercAlt,.F.)
	oGetUfCarr:lShowHint 		:= .F.
	oGetUfCarr:lReadOnly 		:= .F.
	oGetUfCarr:Align 	 		:= 0
	oGetUfCarr:lVisibleControl 	:= .T.
	oGetUfCarr:lPassword 		:= .F.
	oGetUfCarr:lHasButton		:= .F.
	oGetUfCarr:cF3				:= "12"
	oGetUfCarr:cVariable 		:= "cUFCarr"
	oGetUfCarr:bSetGet 	 		:= {|u| If(PCount()>0,cUFCarr:=u,cUFCarr)}
	oGetUfCarr:Picture   		:= PesqPict("CC0","CC0_UFINI")
	oGetUfCarr:bWhen     		:= {|| (nOpc == 3 .or. nOpc == 4)}
	oGetUfCarr:bChange			:= {|| .T.}
	oGetUfCarr:bValid			:= {|| !Empty(cUFCarr) .and. ExistCpo("SX5",'12'+cUFCarr,1) .and. ValListCar(nOpc) }
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a legenda 'Uf.Descarreg.'    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSayUFDesc:= TSAY():Create(oPanel1)
	oSayUFDesc:cName			:= "oSayUFDesc"
	oSayUFDesc:cCaption 		:= "UF Descarregamento:"
	oSayUFDesc:nLeft 			:= MDFeResol(47,.T.)
	oSayUFDesc:nTop 			:= MDFeResol( 8.3,.F.)
	oSayUFDesc:nWidth 	   		:= MDFeResol(10,.T.)
	oSayUFDesc:nHeight 			:= MDFeResol(2.7,.F.)
	oSayUFDesc:lShowHint 		:= .F.
	oSayUFDesc:lReadOnly 		:= .F.
	oSayUFDesc:Align 			:= 0
	oSayUFDesc:lVisibleControl	:= .T.
	oSayUFDesc:lWordWrap 	  	:= .F.
	oSayUFDesc:lTransparent 	:= .F.
	oSayUFDesc:nClrText 		:= CLR_HBLUE
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a Get - 'Uf.Descarreg.'    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetUfDesc:= TGET():Create(oPanel1)
	oGetUfDesc:cName 	 		:= "oGetUfDesc"
	oGetUfDesc:nLeft 	 		:= MDFeResol(57,.T.)
	oGetUfDesc:nTop 	 		:= MDFeResol( 8,.F.)
	oGetUfDesc:nWidth 	 		:= MDFeResol(5,.T.)
	oGetUfDesc:nHeight 	 		:= MDFeResol(nPercAlt,.F.)
	oGetUfDesc:cF3				:= "12"
	oGetUfDesc:lShowHint 		:= .F.
	oGetUfDesc:lReadOnly 		:= .F.
	oGetUfDesc:Align 	 		:= 0
	oGetUfDesc:lVisibleControl 	:= .T.
	oGetUfDesc:lPassword 		:= .F.
	oGetUfDesc:lHasButton		:= .F.
	oGetUfDesc:cVariable 		:= "cUFDesc"
	oGetUfDesc:bSetGet 	 		:= {|u| If(PCount()>0,cUFDesc:=u,cUFDesc)}
	oGetUfDesc:Picture   		:= PesqPict("CC0","CC0_UFFIM")
	oGetUfDesc:bWhen     		:= {|| (nOpc == 3 .or. nOpc == 4)}
	oGetUfDesc:bChange			:= {|| .t. }
	oGetUfDesc:bValid			:= {|| !Empty(cUFDesc) .and. ExistCpo("SX5",'12'+cUFDesc,1) .and. ValListDesc(nOpc) }
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a legenda 'Veiculo'        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSayVeic:= TSAY():Create(oPanel1)
	oSayVeic:cName				:= "oSayVeic"
	oSayVeic:cCaption 			:= "Veículo:"
	oSayVeic:nLeft 				:= MDFeResol(65,.T.)
	oSayVeic:nTop 				:= MDFeResol( 8.3,.F.)
	oSayVeic:nWidth 	   		:= MDFeResol(10,.T.)
	oSayVeic:nHeight 			:= MDFeResol(2.5,.F.)
	oSayVeic:lShowHint 			:= .F.
	oSayVeic:lReadOnly 			:= .F.
	oSayVeic:Align 				:= 0
	oSayVeic:lVisibleControl	:= .T.
	oSayVeic:lWordWrap 	  		:= .F.
	oSayVeic:lTransparent 		:= .F.
	oSayVeic:nClrText 			:= CLR_HBLUE
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a Get - 'Veiculo'          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetVeiculo:= TGET():Create(oPanel1)
	oGetVeiculo:cName 	 		:= "oGetVeiculo"
	oGetVeiculo:nLeft 	 		:= MDFeResol(69,.T.)
	oGetVeiculo:nTop 	 		:= MDFeResol( 8,.F.)
	oGetVeiculo:nWidth 	 		:= MDFeResol(10,.T.)
	oGetVeiculo:nHeight 	 	:= MDFeResol(nPercAlt,.F.)
	oGetVeiculo:lShowHint 		:= .F.
	oGetVeiculo:lReadOnly 		:= .F.
	oGetVeiculo:Align 	 		:= 0
	oGetVeiculo:lVisibleControl := .T.
	oGetVeiculo:lPassword 		:= .F.
	oGetVeiculo:lHasButton		:= .F.
	If HasTemplate("DCLEST") .And. lMV_VEICDCL
		oGetVeiculo:cF3 		:= "LBW"
	Else
		oGetVeiculo:cF3 		:= "DA3"
	EndIf
	oGetVeiculo:cVariable 		:= "cVeiculo"
	oGetVeiculo:bSetGet 	 	:= {|u| If(PCount()>0,cVeiculo:=u,cVeiculo)}
	oGetVeiculo:Picture   		:= PesqPict("DA3","DA3_COD")
	oGetVeiculo:bWhen     		:= {|| (nOpc == 3 )} //So altera o Veiculo se For inclusao!!!! Alteracao eh proibido
	oGetVeiculo:bChange			:= {|| ShowNFs() }
	If HasTemplate("DCLEST") .And. lMV_VEICDCL
		oGetVeiculo:bValid		:= {|| !Empty(cVeiculo) .and. ShowNFs(nOpc)}
	Else
		oGetVeiculo:bValid		:= {|| !Empty(cVeiculo) .and. ExistCpo("DA3",cVeiculo,1) .and. ShowNFs(nOpc)}
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a legenda 'Valor Total'    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSayVTot:= TSAY():Create(oPanel1)
	oSayVTot:cName			:= "oSayVTot"
	oSayVTot:cCaption 		:= "Valor Total: "
	oSayVTot:nLeft 			:= MDFeResol(4,.T.)
	oSayVTot:nTop 			:= MDFeResol(13.8,.F.)//12
	oSayVTot:nWidth 	   	:= MDFeResol(10,.T.)//10
	oSayVTot:nHeight 		:= MDFeResol(2.5,.F.)
	oSayVTot:lShowHint 		:= .F.
	oSayVTot:lReadOnly 		:= .F.
	oSayVTot:Align 			:= 0
	oSayVTot:lVisibleControl:= .T.
	oSayVTot:lWordWrap 	  	:= .F.
	oSayVTot:lTransparent 	:= .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a Get - Valor Total        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetVTot:= TGET():Create(oPanel1)
	oGetVTot:cName 	 		:= "oGetVTot"
	oGetVTot:nLeft 	 		:= MDFeResol(9,.T.)
	oGetVTot:nTop 	 		:= MDFeResol(13.5,.F.)
	oGetVTot:nWidth 	 	:= MDFeResol(8,.T.)
	oGetVTot:nHeight 	 	:= MDFeResol(nPercAlt,.F.)
	oGetVTot:lShowHint 		:= .F.
	oGetVTot:lReadOnly 		:= .F.
	oGetVTot:Align 	 		:= 0
	oGetVTot:lVisibleControl:= .T.
	oGetVTot:lPassword 		:= .F.
	oGetVTot:lHasButton		:= .F.
	oGetVTot:cVariable 		:= "nVTotal"
	oGetVTot:bSetGet 	 	:= {|u| If(PCount()>0,nVTotal:=u,nVTotal)}
	oGetVTot:Picture   		:= PesqPict("SF2","F2_VALBRUT")
	oGetVTot:bWhen     		:= {|| .F.}
	oGetVTot:bChange		:= {|| .T. }
	oGetVTot:bValid			:= {|| .T.}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a legenda 'Peso Bruto'     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSayPBruto:= TSAY():Create(oPanel1)
	oSayPBruto:cName			:= "oSayPBruto"
	oSayPBruto:cCaption 		:= "Peso Bruto:"
	oSayPBruto:nLeft 			:= MDFeResol(20,.T.)
	oSayPBruto:nTop 			:= MDFeResol(13.8,.F.)
	oSayPBruto:nWidth 	   		:= MDFeResol(10,.T.)
	oSayPBruto:nHeight 			:= MDFeResol(2.5,.F.)
	oSayPBruto:lShowHint 		:= .F.
	oSayPBruto:lReadOnly 		:= .F.
	oSayPBruto:Align 			:= 0
	oSayPBruto:lVisibleControl	:= .T.
	oSayPBruto:lWordWrap 	  	:= .F.
	oSayPBruto:lTransparent 	:= .F.
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a Get - Peso Bruto         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetPBruto:= TGET():Create(oPanel1)
	oGetPBruto:cName 	 		:= "oGetPBruto"
	oGetPBruto:nLeft 	 		:= MDFeResol(26,.T.)
	oGetPBruto:nTop 	 		:= MDFeResol(13.5,.F.)
	oGetPBruto:nWidth 	 		:= MDFeResol(7,.T.)
	oGetPBruto:nHeight 	 		:= MDFeResol(nPercAlt,.F.)
	oGetPBruto:lShowHint 		:= .F.
	oGetPBruto:lReadOnly 		:= .F.
	oGetPBruto:Align 	 		:= 0
	oGetPBruto:lVisibleControl 	:= .T.
	oGetPBruto:lPassword 		:= .F.
	oGetPBruto:lHasButton		:= .F.
	oGetPBruto:cVariable 		:= "nPBruto"
	oGetPBruto:bSetGet 	 		:= {|u| If(PCount()>0,nPBruto:=u,nPBruto)}
	oGetPBruto:Picture   		:= PesqPict("SF2","F2_PBRUTO")
	oGetPBruto:bWhen     		:= {|| .F.}
	oGetPBruto:bChange			:= {|| .T. }
	oGetPBruto:bValid			:= {|| .T.}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a legenda 'Quant. NFe'     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSayQtNFe:= TSAY():Create(oPanel1)
	oSayQtNFe:cName			:= "oSayQtNFe"
	oSayQtNFe:cCaption 		:= "Quant. NFe"
	oSayQtNFe:nLeft 		:= MDFeResol(35,.T.)
	oSayQtNFe:nTop 			:= MDFeResol(13.8,.F.)
	oSayQtNFe:nWidth 	   	:= MDFeResol(10,.T.)
	oSayQtNFe:nHeight 		:= MDFeResol(2.5,.F.)
	oSayQtNFe:lShowHint 	:= .F.
	oSayQtNFe:lReadOnly 	:= .F.
	oSayQtNFe:Align 		:= 0
	oSayQtNFe:lVisibleControl:= .T.
	oSayQtNFe:lWordWrap 	:= .F.
	oSayQtNFe:lTransparent 	:= .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a Get - Quant. NFe         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetQtNFe:= TGET():Create(oPanel1)
	oGetQtNFe:cName 	 		:= "oGetQtNFe"
	oGetQtNFe:nLeft 	 		:= MDFeResol(41,.T.)
	oGetQtNFe:nTop 	 			:= MDFeResol(13.5,.F.)
	oGetQtNFe:nWidth 	 		:= MDFeResol(6,.T.)
	oGetQtNFe:nHeight 	 		:= MDFeResol(nPercAlt,.F.)
	oGetQtNFe:lShowHint 		:= .F.
	oGetQtNFe:lReadOnly 		:= .F.
	oGetQtNFe:Align 	 		:= 0
	oGetQtNFe:lVisibleControl 	:= .T.
	oGetQtNFe:lPassword 		:= .F.
	oGetQtNFe:lHasButton  		:= .F.
	oGetQtNFe:cVariable 		:= "nQtNFe"
	oGetQtNFe:bSetGet 	  		:= {|u| If(PCount()>0,nQtNFe:=u,nQtNFe)}
	oGetQtNFe:Picture    		:= "@E 999,999"
	oGetQtNFe:bWhen      		:= {|| .F.}
	oGetQtNFe:bChange	 		:= {|| .T. }
	oGetQtNFe:bValid			:= {|| .T.}
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a legenda 'Motorista'      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSayMoto:= TSAY():Create(oPanel1)
	oSayMoto:cName				:= "oSayMoto"
	oSayMoto:cCaption 			:= "Motorista:"
	oSayMoto:nLeft 				:= MDFeResol(65,.T.)
	oSayMoto:nTop 				:= MDFeResol(13.8,.F.)
	oSayMoto:nWidth 	   		:= MDFeResol(10,.T.)
	oSayMoto:nHeight 			:= MDFeResol(2.5,.F.)
	oSayMoto:lShowHint 			:= .F.
	oSayMoto:lReadOnly 			:= .F.
	oSayMoto:Align 				:= 0
	oSayMoto:lVisibleControl	:= .T.
	oSayMoto:lWordWrap 	  		:= .F.
	oSayMoto:lTransparent 		:= .F.
	oSayMoto:nClrText 			:= CLR_HBLUE
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³        Monta a Get - 'Veiculo'          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetMoto:= TGET():Create(oPanel1)
	oGetMoto:cName 	 		:= "oGetMoto"
	oGetMoto:nLeft 	 		:= MDFeResol(69,.T.)
	oGetMoto:nTop 	 		:= MDFeResol(13.5,.F.)
	oGetMoto:nWidth 	 		:= MDFeResol(10,.T.)
	oGetMoto:nHeight 	 	:= MDFeResol(nPercAlt,.F.)
	oGetMoto:lShowHint 		:= .F.
	oGetMoto:lReadOnly 		:= .F.
	oGetMoto:Align 	 		:= 0
	oGetMoto:lVisibleControl := .T.
	oGetMoto:lPassword 		:= .F.
	oGetMoto:lHasButton		:= .F.
	oGetMoto:cF3 		:= "DA4"
	oGetMoto:cVariable 		:= "cMotorista"
	oGetMoto:bSetGet 	 	:= {|u| If(PCount()>0,cMotorista:=u,cMotorista)}
	oGetMoto:Picture   		:= PesqPict("DA4","DA4_COD")
	oGetMoto:bWhen     		:= {|| (nOpc == 3 )} //So altera o Veiculo se For inclusao!!!! Alteracao eh proibido
//	oGetMoto:bChange			:= {|| ShowNFs() }
	oGetMoto:bValid		:= {|| !Empty(cMotorista) .and. ExistCpo("DA4",cMotorista,1) }



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³            Monta o Box 4 - Informações Adicionais   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBox4:= TGROUP():Create(oTFolder:aDialogs[3])
	oBox4:cName		:= "oBox4"
	oBox4:cCaption	:= "Informações Adicionais"
	oBox4:nLeft		:= MDFeResol(0.5,.T.)
	oBox4:nTop		:= MDFeResol(0.3,.F.)
	oBox4:nWidth	:= MDFeResol(91.7,.T.)//93.5
	oBox4:nHeight	:= MDFeResol(14.5,.F.)
	oBox4:lShowHint	:= .F.
	oBox4:lReadOnly	:= .F.
	oBox4:Align		:= 0
	oBox4:lVisibleControl := .T.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³            Monta o Box5 - Autorizados               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBox5:= TGROUP():Create(oTFolder:aDialogs[3])
	oBox5:cName 	   := "oBox5"
	oBox5:cCaption   := "Autorizados"
	oBox5:nLeft 	   := MDFeResol(0.5,.T.)
	oBox5:nTop  	   := MDFeResol(15,.F.)
	oBox5:nWidth 	   := MDFeResol(45.5,.T.)
	oBox5:nHeight 	   := MDFeResol(28.5,.F.)//28.5
	oBox5:lShowHint    := .F.
	oBox5:lReadOnly    := .F.
	oBox5:Align        := 0
	oBox5:lVisibleControl := .T.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³            Monta o Box6 - Lacres            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBox6:= TGROUP():Create(oTFolder:aDialogs[3])
	oBox6:cName 	   := "oBox6"
	oBox6:cCaption   := "Lacres"
	oBox6:nLeft 	   := MDFeResol(46.7,.T.)//47.2
	oBox6:nTop  	   := MDFeResol(15,.F.)
	oBox6:nWidth 	   := MDFeResol(45.5,.T.)
	oBox6:nHeight 	   := MDFeResol(28.5,.F.)
	oBox6:lShowHint    := .F.
	oBox6:lReadOnly    := .F.
	oBox6:Align        := 0
	oBox6:lVisibleControl := .T.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³     Monta a legenda 'Info.Compl.'    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSayInfCpl:= TSAY():Create(oTFolder:aDialogs[3])
	oSayInfCpl:cName			:= "oSayInfCpl"
	oSayInfCpl:cCaption 		:= "Inf.Complementares"
	oSayInfCpl:nLeft 			:= Iif(aSizeAut[2]==0,11.5,aSizeAut[2])+1.5	//MDFeResol(2,.T.)
	oSayInfCpl:nTop 			:= Iif(aSizeAut[2]==0,11.5,aSizeAut[2])*2	//MDFeResol(6,.F.)
	oSayInfCpl:nWidth 	   		:= MDFeResol(20,.T.)
	oSayInfCpl:nHeight 			:= MDFeResol(2.5,.F.)
	oSayInfCpl:lShowHint 		:= .F.
	oSayInfCpl:lReadOnly 		:= .F.
	oSayInfCpl:Align 			:= 0
	oSayInfCpl:lVisibleControl	:= .T.
	oSayInfCpl:lWordWrap 	  	:= .F.
	oSayInfCpl:lTransparent 	:= .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³       Monta o memo "Informações Complementares"       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oMemo := TMultiGet():New( MDFeResol(1,.T.),(Iif(aSizeAut[2]==0,11.5,aSizeAut[2])*3)-4/*MDFeResol(8,.F.)*/, { | u | If( PCount() == 0, cInfCpl, cInfCpl := u ) },oTFolder:aDialogs[3], MDFeResol(16,.T.),MDFeResol(5.5,.F.),,.T.,,,,.T.,,.F.,,.F.,.F.,.F.,,,.F.,,)
	oMemo:EnableVScroll(.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³     Monta a legenda 'Inf.Fisco'    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSayInfFis:= TSAY():Create(oTFolder:aDialogs[3])
	oSayInfFis:cName			:= "oSayInfFis"
	oSayInfFis:cCaption 		:= "Inf.Fisco"
	oSayInfFis:nLeft 			:= aSizeAut[3]		//MDFeResol(51.7,.T.)
	oSayInfFis:nTop 			:= Iif(aSizeAut[2]==0,11.5,aSizeAut[2])*2	//MDFeResol(6,.F.)
	oSayInfFis:nWidth 	   		:= MDFeResol(20,.T.)
	oSayInfFis:nHeight 	 		:= MDFeResol(2.5,.F.)
	oSayInfFis:lShowHint 		:= .F.
	oSayInfFis:lReadOnly 		:= .F.
	oSayInfFis:Align 			:= 0
	oSayInfFis:lVisibleControl	:= .T.
	oSayInfFis:lWordWrap 	  	:= .F.
	oSayInfFis:lTransparent 	:= .F.
	                  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³      Monta o memo "Informações Fisco"      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oMemo2 := TMultiGet():New( MDFeResol(1,.T.),(aSizeAut[3]/2)+29/*MDFeResol(36,.F.)*/, { | u | If( PCount() == 0, cInfFsc, cInfFsc := u ) },oTFolder:aDialogs[3], MDFeResol(16,.T.),MDFeResol(5.5,.F.),,.T.,,,,.T.,,.F.,,.F.,.F.,.F.,,,.F.,,)
	oMemo2:EnableVScroll(.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³            Monta o Box7 - Municipios de Carregamento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBox7:= TGROUP():Create(oTFolder:aDialogs[2])
	oBox7:cName 	   := "oBox7"
	oBox7:cCaption   := "Municípios de Carregamento"
	oBox7:nLeft 	   := MDFeResol(0.5,.T.)
	oBox7:nTop  	   := MDFeResol(0.3,.F.)
	oBox7:nWidth 	   := MDFeResol(45,.T.)
	oBox7:nHeight 	   := MDFeResol(43,.F.)
	oBox7:lShowHint    := .F.
	oBox7:lReadOnly    := .F.
	oBox7:Align        := 0
	oBox7:lVisibleControl := .T.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³            Monta o Box8 - Percurso do veiculo       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBox8:= TGROUP():Create(oTFolder:aDialogs[2])
	oBox8:cName			:= "oBox8"
	oBox8:cCaption   	:= "Percurso do veículo"
	oBox8:nLeft			:= MDFeResol(46.6,.T.)//46.8
	oBox8:nTop			:= MDFeResol(0.3,.F.)
	oBox8:nWidth		:= MDFeResol(45.5,.T.)
	oBox8:nHeight		:= MDFeResol(43,.F.)
	oBox8:lShowHint		:= .F.
	oBox8:lReadOnly		:= .F.
	oBox8:Align			:= 0
	oBox8:lVisibleControl := .T.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³            Monta o Box 9 - Documentos vinculados    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBox9:= TGROUP():Create(oTFolder:aDialogs[1])
	oBox9:cName		:= "oBox9"
	oBox9:cCaption	:= "Documentos vinculados"
	oBox9:nLeft		:= MDFeResol(0.5,.T.)//0.5
	oBox9:nTop		:= MDFeResol(0.3,.F.)//0.3
	oBox9:nWidth	:= MDFeResol(91.7,.T.)//91.7
	oBox9:nHeight	:= MDFeResol(43.2,.F.)//43.2
	oBox9:lShowHint	:= .F.
	oBox9:lReadOnly	:= .F.
	oBox9:Align		:= 0
	oBox9:lVisibleControl := .T.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³          Monta a MarkBrowse de Notas a Manifestar³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpc == 3
		LoadTRB(nOpc)	//Carrega o arquivo de apoio TRB
	EndIf
	nTopGD  	:= MDFeResol(1,.F.)
	nLeftGD 	:= MDFeResol(0.5,.T.)
	nDownGD 	:= MDFeResol(20,.F.)
	nRightGD	:= MDFeResol(46,.T.)
	oMsSel := MsSelect():New("TRB","TRB_MARCA",,aCmpBrow,,cMark,{nTopGD,nLeftGD,nDownGD,nRightGD},,,oTFolder:aDialogs[1])
	oMsSel:bAval := { || MarcaNF(nOpc)}

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³         Monta a GetDados "Municipio de Carregamento"         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTopGD  	:= MDFeResol(2,.F.)
	nLeftGD 	:= MDFeResol(0.8,.T.)
	nDownGD 	:= MDFeResol(20.8,.F.)
	nRightGD	:= MDFeResol(22.3,.T.)
	oGetDMun	:= MsNewGetDados():New(nTopGD,nLeftGD,nDownGD,nRightGD,iif(lIncAltDel,nIncAltDel,0) ,,,,{"CC2_CODMUN"},,50,,,,oTFolder:aDialogs[2],aHeadMun,aColsMun)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³         Monta a GetDados "Percurso do veiculo"         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTopGD  	:= MDFeResol(2,.F.)
	nLeftGD 	:= MDFeResol(23.7,.T.)
	nDownGD 	:= MDFeResol(20.8,.F.)
	nRightGD	:= MDFeResol(45.7,.T.)
	oGetDPerc	:= MsNewGetDados():New(nTopGD,nLeftGD,nDownGD,nRightGD,iif(lIncAltDel,nIncAltDel,0),,,,,,25,,,,oTFolder:aDialogs[2],aHeadPerc,aColsPerc)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³               Monta a GetDados "Autorizados               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTopGD  	:= MDFeResol(8.4,.F.)
	nLeftGD 	:= MDFeResol(0.6,.T.)
	nDownGD 	:= MDFeResol(21.5,.F.)
	nRightGD	:= MDFeResol(22.6,.T.)
	oGetDAut	:= MsNewGetDados():New(nTopGD,nLeftGD,nDownGD,nRightGD,iif(lIncAltDel,nIncAltDel,0),,,,,,10,,,,oTFolder:aDialogs[3],aHeadAuto,aColsAuto)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³         Monta a GetDados "Lacres"         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTopGD  	:= MDFeResol(8.4,.F.)
	nLeftGD 	:= MDFeResol(23.7,.T.)
	nDownGD 	:= MDFeResol(21.5,.F.)
	nRightGD	:= MDFeResol(45.7,.T.)
	oGetDLacre  := MsNewGetDados():New(nTopGD,nLeftGD,nDownGD,nRightGD,iif(lIncAltDel,nIncAltDel,0),,,,,,60,,,,oTFolder:aDialogs[3],aHeadLacre,aColsLacre)
	  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³          Exibe a Dialog ao usuario          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oTela:Activate()
	oMsSel := Nil
Return
//----------------------------------------------------------------------
/*/ MDFeManage
Montagem da Dialog do Gerenciador do MDFe

@author Natalia Sartori
@since 10/02/2014
@version P11 

@param	
@Return 
/*/
//-----------------------------------------------------------------------
User Function ManiManage(cAlias, nReg, nOpc,cMark, lInverte)

	Local cAliasCC0	:= GetNextAlias()
	Local cQuery	:= ""
	Local aAreaCC0	:= CC0->(GetArea())
	Local lMarkAll	:= .T.

	Local aObjects	:= {}
	Local aInfo		:= {}
	Local aSizeAut
	Local aPosObj 	:= {}
	Local aButtons := {}

	aSizeAut := MsAdvSize()

	aObjects := {}
	AAdd( aObjects, { 50, 40, .T., .T., .T. } )
	AAdd( aObjects, { 60, 70, .T., .T. ,.T.} )

	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
	aPosObj := MsObjSize( aInfo, aObjects, , .T. )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se possui o campo CC0_TPEVEN³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea('CC0')
	If CC0->(FieldPos('CC0_TPEVEN')) <= 0
		Aviso('Update Necessario','O campo de tipos de evento CC0_TPEVEN não foi localizado neste ambiente. Por favor, execute o update "NFEP11R1", opção "157" para correta criação.',{"Finalizar"})
		Return
	EndIf
	
	aButtons := { 	{ , {|| (iif(!lUsaColab,SpedNFeStatus(),Aviso("SPED","Status SEFAZ indisponível para TOTVS Colaboração - 2.0",{"Ok"},3)) ) } , 'Status SEFAZ' }	,;
		{ , {|| ( MDFeTrans() ) } , 'Transmitir' } 		,;
		{ , {|| ( MDFeEvento(aListDocs,"110111") )} , 'Cancelar' } ,;
		{ , {|| ( MDFeEvento(aListDocs,"110112") )} , 'Encerrar' } ,;
		{ , {|| ( MDFeMonit() )} , 'Monitorar' },;
		{ , {|| ( MDFeDamDfe( , , nOpc ) ) } , "Imprimir DAMDFE" } }
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³       Monta o dialog Principal       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGerMDFe:= MSDIALOG():Create()
	oGerMDFe:cName     		:= "oGerMDFe"
	oGerMDFe:cCaption  		:= "Gerenciar MDFe"
	oGerMDFe:nLeft     		:= aSizeAut[7]	//MDFeResol(80,.T.) //80
	oGerMDFe:nTop      		:= aSizeAut[1]	//MDFeResol(60,.F.) //60
	oGerMDFe:nWidth    		:= aSizeAut[5]	//MDFeResol(95,.T.) //95
	oGerMDFe:nHeight   		:= aSizeAut[6]+25	//MDFeResol(87,.F.) //80
	oGerMDFe:lShowHint 		:= .F.
	oGerMDFe:lCentered 		:= .T.
	oGerMDFe:bInit 			:= {|| EnchoiceBar(oGerMDFe, {||( oGerMDFe:End() )} , {||  oGerMDFe:End()} , , aButtons )  }
	
	If CTIsReady(,,,lUsaColab)
      	
		oListDocs := Nil
		aListDocs	:=	GetListBox()
			
		//@ Iif(aSizeAut[2]==0,11.5,aSizeAut[2])+1.5,(Iif(aSizeAut[2]==0,11.5,aSizeAut[2])*7)-5.5 LISTBOX oListDocs 	FIELDS HEADER "","Serie","NÚmero","Data Emissão","Status Documento","Status Evento" SIZE aSizeAut[3]-85,aSizeAut[4]-21.5 PIXEL OF oGerMDFe
		@ aSizeAut[2]+5,aSizeAut[1]+65 LISTBOX oListDocs 	FIELDS HEADER "","Serie","NÚmero","Data Emissão","Status Documento","Status Evento" SIZE aSizeAut[3]-70,aSizeAut[4]-11.5 PIXEL OF oGerMDFe
		
		oListDocs:SetArray( aListDocs )
		oListDocs:bLine := {||     {If(aListDocs[oListDocs:nAt,7],oOkx,oNo),;
			aListDocs[oListDocs:nAt,2],;
			aListDocs[oListDocs:nAt,3],;
			aListDocs[oListDocs:nAt,4],;
			aListDocs[oListDocs:nAt,5],;
			aListDocs[oListDocs:nAt,6]}}
		oListDocs:BLDBLCLICK := {|| MDFLinGer(@oListDocs,@aListDocs,oOkx,oNo)}
		oListDocs:bHeaderClick := {|| aEval(aListDocs, {|e| e[7] := lMarkAll}),lMarkAll:=!lMarkAll, oListDocs:Refresh()}
      		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³       Exibe a dialog ao usuario       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		@ 05,05 BUTTON 'Status SEFAZ'  SIZE 046, 013 OF oGerMDFe PIXEL ACTION SpedNFeStatus()
		@ 20,05 BUTTON 'Transmissao'  SIZE 046, 013 OF oGerMDFe PIXEL ACTION MDFeTrans()
		@ 35,05 BUTTON 'Cancelar'  SIZE 046, 013 OF oGerMDFe PIXEL ACTION MDFeEvento(aListDocs,"110111")
		@ 50,05 BUTTON 'Encerrar'  SIZE 046, 013 OF oGerMDFe PIXEL ACTION MDFeEvento(aListDocs,"110112")
		@ 65,05 BUTTON 'Monitor'  SIZE 046, 013 OF oGerMDFe PIXEL ACTION MDFeMonit()
		@ 80,05 BUTTON 'Imprimir'  SIZE 046, 013 OF oGerMDFe PIXEL ACTION MDFeDamDfe( , , nOpc )

	
		oGerMDFe:Activate()
		RestArea(aAreaCC0)
	Else
		Aviso("MDF-e","Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!",{"Ok"},3) //
	EndIf
	
Return

//----------------------------------------------------------------------
/*/ GetDescStatus
Retorna a descricao do status de acordo com o parametro de codigo recebido

@author Natalia Sartori
@since 10/02/2014
@version P11 
@Return	
/*/
//-----------------------------------------------------------------------
Static Function GetDescStatus(cStatus)
	Local cDesc := ""

	Do Case
	Case cStatus == TRANSMITIDO
		cDesc := "Transmitido"
	Case cStatus == NAO_TRANSMITIDO
		cDesc := "Nao Transmitido"
	Case cStatus == AUTORIZADO
		cDesc := "Autorizado"
	Case cStatus == NAO_AUTORIZADO
		cDesc := "Nao Autorizado"
	Case cStatus == CANCELADO
		cDesc := "Cancelado"
	Case cStatus == ENCERRADO
		cDesc := "Encerrado"
	EndCase
Return cDesc
            

//----------------------------------------------------------------------
/*/ GetDescEven
Retorna a descricao do status do evento acordo com o parametro de codigo recebido

@author Cesar Bianchi
@since 07/07/2014
@version P11 
@Return	cDescription
/*/
//-----------------------------------------------------------------------
Static Function GetDescEven(cStatus,cTpEven)
	Local cDesc := ""
	Default cTpEven := ""
	Default cStatus := ""
	

	If !Empty(cStatus)
		//Monta o tipo de evento
		Do case
		Case cTpEven == "110111"
			cDesc := "Cancelamento "
		Case "112" $ cTpEven
			cDesc := "Encerramento "
		Otherwise
			cDesc := "Evento (Cancelamento/Encerramento) "
		EndCase

        //Monta o status
		Do Case
		Case cStatus == EVENAOREALIZADO
			cDesc += "transmitido"
		Case cStatus == EVEREALIZADO
			cDesc += "nao transmitido"
		Case cStatus == EVEVINCULADO
			cDesc += "autorizado"
		Case cStatus == EVENAOVINCULADO
			cDesc += "não autorizado"
		EndCase
	EndIf
Return cDesc

//----------------------------------------------------------------------
/*/ MDFExpXMl
Exibe uma interface do tipo Wizard para exportação dos XML's do MDFe

@author Natalia Sartori
@since 10/02/2014
@version P11 
@Return	
/*/
//-----------------------------------------------------------------------
Static Function MDFExpXMl()
	Local aArea		:= GetArea()
	Local aPerg		:= {}
	Local aParam	:= {Space(Len(CC0->CC0_SERMDF)),Space(Len(CC0->CC0_NUMMDF)),Space(Len(CC0->CC0_NUMMDF))}
	Local aTexto	:= {}
	Local oWizard 	:= Nil
	Local cTitulo	:= "Manifesto Eletrônico de Documentos Fiscais"
	Local cParMFFeRe:= SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDMDFEREM"
	Local cHeader	:= "Assistente de Exportação para arquivos XML"

	aadd(aPerg,{1,"Serie do MDFe",aParam[01],"",".T.","",".T.",30,.F.})	//
	aadd(aPerg,{1,"MDFe inicial",aParam[02],"",".T.","",".T.",30,.T.})	//
	aadd(aPerg,{1,"MDFe final",aParam[03],"",".T.","",".T.",30,.T.})	//


	aadd(aTexto,{})
	aTexto[1] := 'Esta rotina tem como objetivo auxilia-lo na exportação do Manifesto Eletrônico de Documentos Fiscais para aqruivos no formato XML'
	aTexto[1] += CRLF + CRLF
	aTexto[1] += 'Pressione "Avançar" para dar continuidade no processo de exportação para arquivos'
	
	aadd(aTexto,{})

	DEFINE WIZARD oWizard	 ;
		TITLE cTitulo;
		HEADER cHeader;
		MESSAGE cTitulo;//"Siga atentamente os passos para a configuração do Manifesto Eletrônico de Documentos Fiscais"
	TEXT aTexto[1];
		NEXT {|| .T.};
		FINISH {||.T.}

	CREATE PANEL oWizard	;
		HEADER cHeader	 ;//"Assistente de transmissão do Manifesto Eletrônico de Documentos Fiscais"
	MESSAGE "" ;
		BACK {|| .T.} ;
		FINISH {|| Processa({|| CreateXMLFile(aParam[1],aParam[2],aParam[3])}) };
		PANEL
	ParamBox(aPerg,"MDF-e",@aParam,,,,,,oWizard:oMPanel[2],cParMFFeRe,.T.,.T.)

	ACTIVATE WIZARD oWizard CENTERED

Return

//----------------------------------------------------------------------
/*/ CreateXMLFile
Realiza a criacao de arquivos XML em disco do MDFe

@author Natalia Sartori
@since 10/02/2014
@version P11 
@param
@Return	
/*/
//-----------------------------------------------------------------------
Static Function CreateXMLFile(cSerie,cNumIni,cNumFim)
	Local aArea 	:= CC0->(GetArea())
	//Local cDirDest	:= cGetFile("eXtensible Markup Language (*.xml)|*.xml","Diretorio de destino dos arquivos exportados",0,NIL,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_RETDIRECTORY)	
	//Local cQuery	:= ""
	
	#IFDEF TOP
		 		 
	#ELSE
	
	#ENDIF
	                                 
	RestArea(aArea)
Return .T.
//----------------------------------------------------------------------
/*/ MDFLinGer
Marca/Desmarca uma MDFe dentro do grid de "Gerenciar MDFe"

@author Natalia Sartori
@since 10/02/2014
@version P11 

@param	 	nPerc  - Valor em percentual de video desejado
@Return	lWidht - Flag para controlar se a medida e vertical ou horz 
/*/
//-----------------------------------------------------------------------
Static Function MDFLinGer(oList,aArray,oOkx,oNo)
	aArray[oList:nAt,7] := iif(aArray[oList:nAt,7],.F.,.T.)
	oList:Reset()
	oList:SetArray(aArray)
	oList:bLine := {||     {If(aArray[oList:nAt,7],oOkx,oNo),;
		aArray[oList:nAt,2],;
		aArray[oList:nAt,3],;
		aArray[oList:nAt,4],;
		aArray[oList:nAt,5],;
		aArray[oList:nAt,6]}}
	oList:Refresh()
Return

//----------------------------------------------------------------------
/*/ MDFeResol
Montagem da Dialog do Gerenciador do MDFe

@author Natalia Sartori
@since 10/02/2014
@version P11 

@param	 	nPerc  - Valor em percentual de video desejado
@Return	lWidht - Flag para controlar se a medida e vertical ou horz 
/*/
//-----------------------------------------------------------------------
Static Function MDFeResol(nPerc,lWidth)
	Local nRet
	Private nResHor := GetScreenRes()[1] 				//Tamanho resolucao de video horizontal
	Private nResVer := GetScreenRes()[2]               //Tamanho resolucao de video vertical
	
	if lWidth
		nRet := nPerc * nResHor / 100
	else
		nRet := nPerc * nResVer / 100
	endif
	
Return nRet
	
//----------------------------------------------------------------------
/*/ MDFeBut
Cria os botoes da EnchoiceButtons da opcaç inclur novo MDFe

@author Natalia Sartori
@since 10/02/2014
@version P11 

@param	 	nPerc  - Valor em percentual de video desejado
@Return	lWidht - Flag para controlar se a medida e vertical ou horz 
/*/
//-----------------------------------------------------------------------	
Static Function MDFeBut()
	Local aRet		 := {}
	Local aButtons := {}
		
		//³Adiciona Botoes de Usuario³
		//aAdd(aRet,{'SALARIOS', {|| MsgStop('Teste botao de usuario')} , "Botao Usuario" , "Botao Usuario" })
	    
		//Ponto de entrada para o cliente inserir novos botoes caso desejar
	If ExistBlock("MDFeBut")
		aButtons := ExecBlock("MDFeBut", .F., .F., {aRet} )
	EndIf
	
Return aButtons


//----------------------------------------------------------------------
/*/ CreateTRB
Cria um arquivo de trabalho temporario, e define o array "Header" da 
MarkBrowse de documentos

@author Natalia Sartori
@since 10/02/2014
@version P11 
@Return	aBrow
/*/
//-----------------------------------------------------------------------
Static Function CreateTRB()
	Private aCmpTRB   := {}                      //Array com a estrutura do arquivo de trabalho TRB

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Trava o cursor enquanto carrega o arquivo de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CursorWait()
       
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a aCmpBrow do arquivo de Trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd(aCmpBrow,{"TRB_MARCA"			,,"Sel" 	       			,"  " 						})
	aAdd(aCmpBrow,{"TRB_SERIE"		,, GetTitulo("F2_SERIE")	,PesqPict("SF2","F2_SERIE") 	})
	aAdd(aCmpBrow,{"TRB_DOC"		,, GetTitulo("F2_DOC")		,PesqPict("SF2","F2_DOC")		})
	aAdd(aCmpBrow,{"TRB_EMISS"		,, GetTitulo("F2_EMISSAO")	,PesqPict("SF2","F2_EMISSAO")	})
	aAdd(aCmpBrow,{"TRB_CHVNFE"		,, GetTitulo("F2_CHVNFE")	,PesqPict("SF2","F2_CHVNFE") 	})
	aAdd(aCmpBrow,{"TRB_CODMUN"		,, "Cod Municipio Desc."	,PesqPict("CC2","CC2_CODMUN") 	})
	aAdd(aCmpBrow,{"TRB_NOMMUN"		,, "Nome"					,PesqPict("CC2","CC2_MUN") 		})
	aAdd(aCmpBrow,{"TRB_CODCLI" 	,, GetTitulo("A1_COD")		,PesqPict("SA1","A1_COD") 		})
	aAdd(aCmpBrow,{"TRB_NOMCLI"    	,, GetTitulo("A1_NOME")		,PesqPict("SA1","A1_NOME") 		})
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a estrutura do arquivo de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd( aCmpTRB, {"TRB_MARCA"			,"C"    ,2            			 	,0    })
	Aadd( aCmpTRB, {"TRB_SERIE"			,"C"    ,TamSx3("F2_SERIE")[1] 		,0    })
	Aadd( aCmpTRB, {"TRB_DOC"			,"C"    ,TamSx3("F2_DOC")[1] 		,0    })
	Aadd( aCmpTRB, {"TRB_EMISS"			,"D"    ,TamSx3("F2_EMISSAO")[1]	,0    })
	Aadd( aCmpTRB, {"TRB_CHVNFE"  		,"C"    ,TamSx3("F2_CHVNFE")[1]   	,0    })
	Aadd( aCmpTRB, {"TRB_EST"			,"C"    ,TamSx3("CC2_EST")[1]		,0    })
	Aadd( aCmpTRB, {"TRB_CODMUN"		,"C"    ,TamSx3("CC2_CODMUN")[1]	,0    })
	Aadd( aCmpTRB, {"TRB_NOMMUN"		,"C"    ,TamSx3("CC2_MUN")[1]    	,0    })
	Aadd( aCmpTRB, {"TRB_CODCLI"		,"C"    ,TamSx3("A1_COD")[1]    	,0    })
	Aadd( aCmpTRB, {"TRB_LOJCLI"		,"C"    ,TamSx3("A1_LOJA")[1]    	,0    })
	Aadd( aCmpTRB, {"TRB_NOMCLI"		,"C"    ,TamSx3("A1_NOME")[1]   	,0    })
	Aadd( aCmpTRB, {"TRB_VALTOT"		,"N"    ,TamSx3("F2_VALBRUT")[1]   	,TamSx3("F2_VALBRUT")[2]   })
	Aadd( aCmpTRB, {"TRB_PESBRU"		,"N"    ,TamSx3("F2_PBRUTO")[1]   	,TamSx3("F2_PBRUTO")[2]    })
	Aadd( aCmpTRB, {"TRB_VEICU1"		,"C"    ,TamSx3("F2_VEICUL1")[1]   	,0    })
	Aadd( aCmpTRB, {"TRB_VEICU2"		,"C"    ,TamSx3("F2_VEICUL2")[1]   	,0    })
	Aadd( aCmpTRB, {"TRB_VEICU3"		,"C"    ,TamSx3("F2_VEICUL3")[1]   	,0    })
	Aadd( aCmpTRB, {"TRB_MOTORI"		,"C"    ,TamSx3("CC0_MOTORI")[1]   	,0    })
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria o arquivo de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	iif(Select('TRB')>0,TRB->(dbCloseArea()),Nil)
	Iif(File(cArqTRB + GetDBExtension()),FErase(cArqTRB  + GetDBExtension()) ,Nil)
	cArqTRB := CriaTrab(aCmpTRB, .T.)
	dbUseArea(.T.,,cArqTRB,"TRB",.F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria o indice 1 do arquivo de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Iif(File(cIndTRB1 + OrdBagExt())    ,FErase(cIndTRB1 + OrdBagExt()     ) ,Nil)
	cIndTRB1 := CriaTrab(Nil, .F.)
	IndRegua("TRB",cIndTRB1,"TRB_SERIE + TRB_DOC",,,"Indexando ... ")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria o indice 2 do arquivo de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Iif(File(cIndTRB2 + OrdBagExt())    ,FErase(cIndTRB2 + OrdBagExt()     ) ,Nil)
	cIndTRB2 := CriaTrab(Nil, .F.)
	IndRegua("TRB",cIndTRB2,"TRB_CODMUN + TRB_SERIE + TRB_DOC",,,"Indexando ... ")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define o indice 1 como ativo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbClearIndex()
	dbSetIndex(cIndTRB1 + OrdBagExt())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Libera o cursor do mouse³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CursorArrow()
	
Return

Static Function TRBSetIndex(nIdx)
	If nIdx == 1
		IndRegua("TRB",cIndTRB1,"TRB_SERIE + TRB_DOC",,,"Indexando ... ")
	Else
		IndRegua("TRB",cIndTRB2,"TRB_CODMUN + TRB_SERIE + TRB_DOC",,,"Indexando ... ")
	EndIf
Return

//----------------------------------------------------------------------
/*/ ShowNFs()
Carrega todas as notas de um determinado veiculo, exibindo uma dialog 
do tipo "Processa" ao usuario

@author Natalia Sartori
@since 10/02/2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function ShowNFs(nOpc,lReset)
	Default lReset := .F.
    
	If (nOpc == 3 .and. cVeiculoAux <> cVeiculo) .or. lReset
		MsgRun("Buscando documentos do Veiculo","Aguarde",{|| LoadTRB(nOpc) })
		TRB->(dbGoTop())
		oMsSel:oBrowse:Refresh()

		//Controle de variaveis
		nQtNFe := 0
		nVTotal := 0
		nPBruto := 0
		cVeiculoAux := cVeiculo
	EndIf
			
Return .T.

//----------------------------------------------------------------------
/*/ LoadTRB
Carrega os dados do SF2/SA1 no arquivo de apoio TRB

@author Natalia Sartori
@since 10/02/2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function LoadTRB(nOpc)
	Local cQuery		:= ""
	Local cNomeCliFor	:= ""
	Local cAlias 		:= GetNextAlias()
	Local lMarca 		:= .F.
	Local lCliFor		:= .F.
		
	//Antes de gravar, esvazio a TRB
	CleanTRB(nOpc)
		
	If !Empty(cVeiculo)
		If cEntSai == "1"
			SA1->(dbSetOrder(1))
			
			#IFDEF TOP
				cQuery := "SELECT SF2.F2_SERIE, SF2.F2_DOC, SF2.F2_EMISSAO, SF2.F2_CHVNFE, SF2.F2_ESPECIE, "
				cQuery += " SF2.F2_VALBRUT, SF2.F2_PBRUTO, SF2.F2_CLIENTE, SF2.F2_LOJA, SF2.F2_TIPO, "
				cQuery += " SF2.F2_SERMDF, SF2.F2_NUMMDF, SF2.F2_VEICUL1, SF2.F2_VEICUL2, SF2.F2_VEICUL3 FROM "
				cQuery += RetSqlName('SF2') + " SF2"
				cQuery += " WHERE SF2.F2_FILIAL = '" + xFilial('SF2') + "' "
//				cQuery += " 	AND SA1.A1_FILIAL = '" + xFilial('SA1') + "' "
				cQuery += " 	AND (SF2.F2_VEICUL1 = '" + cVeiculo + "' "
				cQuery += " 		OR SF2.F2_VEICUL2 = '" + cVeiculo + "' "
				cQuery += " 		OR SF2.F2_VEICUL3 = '" + cVeiculo + "') "
				cQuery += " 	AND SF2.F2_CHVNFE <> ' ' "
				cQuery += " 	AND SF2.F2_ESPECIE = 'SPED' "
				cQuery += " 	AND SF2.F2_EMISSAO >= '" + DTOS((Date()-365)) + "'  "		//Para otimizar, sao exibidas apenas notas D-365 (1 ano)
				cQuery += " 	AND SF2.F2_FIMP <> 'D' "
				If nOpc == 3
					cQuery += " 	AND SF2.F2_SERMDF = ' ' "
					cQuery += " 	AND SF2.F2_NUMMDF = ' ' "
				Else
					cQuery += " 	AND (SF2.F2_SERMDF = ' ' OR SF2.F2_SERMDF = '" + CC0->CC0_SERMDF + "') "
					cQuery += " 	AND (SF2.F2_NUMMDF = ' ' OR SF2.F2_NUMMDF = '" + CC0->CC0_NUMMDF + "') "
				EndIf
				cQuery += " 	AND SF2.D_E_L_E_T_ = ' ' "

				cQuery := ChangeQuery(cQuery)
				iif(Select(cAlias)>0,(cAlias)->(dbCloseArea()),Nil)
				dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias, .F., .T.)
				While (cAlias)->(!Eof())
					lMarca := !Empty((cAlias)->F2_SERMDF)
					If (cAlias)->F2_TIPO $ "B|D"
						lCliFor := .F.
						If SA2->(dbSeek(xFilial('SA2') + (cAlias)->F2_CLIENTE + (cAlias)->F2_LOJA))
							cNomeCliFor	:= SA2->A2_NOME
							lCliFor		:= .T.
						EndIf
					Else
						lCliFor := .F.
						If SA1->(dbSeek(xFilial('SA1') + (cAlias)->F2_CLIENTE + (cAlias)->F2_LOJA))
							cNomeCliFor	:= SA1->A1_NOME
							lCliFor		:= .T.
						EndIf
					EndIf
					If (nOpc <> 2  .Or. (nOpc == 2 .And. lMarca)) .And. lCliFor
						RecTRB(.T.,(cAlias)->F2_SERIE,(cAlias)->F2_DOC,(cAlias)->F2_EMISSAO,(cAlias)->F2_CHVNFE,(cAlias)->F2_CLIENTE,(cAlias)->F2_LOJA,cNomeCliFor,,,,(cAlias)->F2_VALBRUT,(cAlias)->F2_PBRUTO,lMarca,(cAlias)->F2_VEICUL1,(cAlias)->F2_VEICUL2,(cAlias)->F2_VEICUL3)
					EndIf
					(cAlias)->(dbSkip())
				EndDo
				
				
			#ELSE
				dbSelectArea('SF2')
				SF2->(dbSetOrder(1))
				SF2->(dbGoTop())
				dbSelectArea('SA1')
				SA1->(dbSetOrder(1))
		                            
				While SF2->(!Eof())
					If (alltrim(upper(SF2->F2_VEICUL1)) == alltrim(upper(cVeiculo)) .OR. ;
							alltrim(upper(SF2->F2_VEICUL2)) == alltrim(upper(cVeiculo)) .OR. ;
							alltrim(upper(SF2->F2_VEICUL3)) == alltrim(upper(cVeiculo))) .AND. ;
							!Empty(SF2->F2_CHVNFE) .and. ;
							Empty(SF2->F2_SERMDF) .and. ;
							Empty(SF2->F2_NUMMDF)
		    			
						If (cAlias)->F2_TIPO $ "B|D"
							lCliFor := .F.
							If SA2->(dbSeek(xFilial('SA2') + (cAlias)->F2_CLIENTE + (cAlias)->F2_LOJA))
								cCliFor		:= SA2->A2_COD
								cLjCliFor	:= SA2->A2_LOJA
								lCliFor := .T.
							EndIf
						Else
							lCliFor := .F.
							If SA1->(dbSeek(xFilial('SA1') + (cAlias)->F2_CLIENTE + (cAlias)->F2_LOJA))
								cCliFor		:= SA1->A1_COD
								cLjCliFor	:= SA1->A1_LOJA
								lCliFor := .T.
							EndIf
						EndIf

						If lCliFor
							RecTRB(.T.,SF2->F2_SERIE,SF2->F2_DOC,DTOS(SF2->F2_EMISSAO),SF2->F2_CHVNFE,cCliFor,cLjCliFor,SA1->A1_NOME,,,,SF2->F2_VALBRUT,SF2->F2_PBRUTO,lMarca,SF2->F2_VEICUL1,SF2->F2_VEICUL2,SF2->F2_VEICUL3)
						EndIf
					EndIf
					SF2->(dbSkip())
				EndDo
			#ENDIF
		Else
			#IFDEF TOP
				cQuery := "SELECT SF1.F1_SERIE, SF1.F1_DOC, SF1.F1_EMISSAO, SF1.F1_CHVNFE, SF1.F1_ESPECIE, "
				cQuery += " SF1.F1_VALBRUT, SF1.F1_PBRUTO, SF1.F1_FORNECE, SF1.F1_LOJA,SF1.F1_TIPO,  "
				cQuery += " SF1.F1_SERMDF, SF1.F1_NUMMDF, SF1.F1_VEICUL1, SF1.F1_VEICUL2, SF1.F1_VEICUL3 FROM "
				cQuery += RetSqlName('SF1') + " SF1, "	// + RetSqlName('SA2') + " SA2 "
				cQuery += " WHERE SF1.F1_FILIAL = '" + xFilial('SF1') + "' "
				//cQuery += " 	AND SA2.A2_FILIAL = '" + xFilial('SA2') + "' "
				cQuery += " 	AND (SF1.F1_VEICUL1 = '" + cVeiculo + "' "
				cQuery += " 		OR SF1.F1_VEICUL2 = '" + cVeiculo + "' "
				cQuery += " 		OR SF1.F1_VEICUL3 = '" + cVeiculo + "') "
				//cQuery += " 	AND SF1.F1_FORNECE = SA2.A2_COD "			
				//cQuery += " 	AND SF1.F1_LOJA = SA2.A2_LOJA "
				cQuery += " 	AND SF1.F1_CHVNFE <> ' ' "
				cQuery += " 	AND SF1.F1_ESPECIE = 'SPED' "
				cQuery += " 	AND SF1.F1_EMISSAO >= '" + DTOS((Date()-365)) + "'  "		//Para otimizar, sao exibidas apenas notas D-365 (1 ano)
				If nOpc == 3
					cQuery += " 	AND SF1.F1_SERMDF = ' ' "
					cQuery += " 	AND SF1.F1_NUMMDF = ' ' "
				Else
					cQuery += " 	AND (SF1.F1_SERMDF = ' ' OR SF1.F1_SERMDF = '" + CC0->CC0_SERMDF + "') "
					cQuery += " 	AND (SF1.F1_NUMMDF = ' ' OR SF1.F1_NUMMDF = '" + CC0->CC0_NUMMDF + "') "
				EndIf
				cQuery += " 	AND SF1.D_E_L_E_T_ = ' ' "
				//cQuery += " 	AND SA2.D_E_L_E_T_ = ' ' "
				cQuery := ChangeQuery(cQuery)
				iif(Select(cAlias)>0,(cAlias)->(dbCloseArea()),Nil)
				dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias, .F., .T.)
				While (cAlias)->(!Eof())
					lMarca := !Empty((cAlias)->F1_SERMDF)
					If (cAlias)->F1_TIPO $ "B|D"
						lCliFor := .F.
						If SA1->(dbSeek(xFilial('SA1') + (cAlias)->F1_FORNECE + (cAlias)->F1_LOJA))
							cNomeCliFor	:= SA1->A1_NOME
							lCliFor		:= .T.
						EndIf
					Else
						lCliFor := .F.
						If SA2->(dbSeek(xFilial('SA2') + (cAlias)->F1_FORNECE + (cAlias)->F1_LOJA))
							cNomeCliFor	:= SA2->A2_NOME
							lCliFor		:= .T.
						EndIf
					EndIf
					If nOpc <> 2  .Or. (nOpc == 2 .And. lMarca)
						RecTRB(.T.,(cAlias)->F1_SERIE,(cAlias)->F1_DOC,(cAlias)->F1_EMISSAO,(cAlias)->F1_CHVNFE,(cAlias)->F1_FORNECE,(cAlias)->F1_LOJA,cNomeCliFor,,,,(cAlias)->F1_VALBRUT,(cAlias)->F1_PBRUTO,lMarca,(cAlias)->F1_VEICUL1,(cAlias)->F1_VEICUL2,(cAlias)->F1_VEICUL3)
					EndIf
					(cAlias)->(dbSkip())
				EndDo
				
				
			#ELSE
				dbSelectArea('SF1')
				SF1->(dbSetOrder(1))
				SF1->(dbGoTop())
				dbSelectArea('SA2')
				SA2->(dbSetOrder(1))
		                            
				While SF1->(!Eof())
					If (alltrim(upper(SF1->F1_VEICUL1)) == alltrim(upper(cVeiculo)) .OR. ;
							alltrim(upper(SF1->F1_VEICUL2)) == alltrim(upper(cVeiculo)) .OR. ;
							alltrim(upper(SF1->F1_VEICUL3)) == alltrim(upper(cVeiculo))) .AND. ;
							!Empty(SF1->F1_CHVNFE) .and. ;
							Empty(SF1->F1_SERMDF) .and. ;
							Empty(SF1->F1_NUMMDF)
		    			
						If SA2->(dbSeek(xFilial('SA2') + SF1->F1_CLIENTE + SF1->F1_LOJA))
							RecTRB(.T.,SF2->F2_SERIE,SF2->F2_DOC,DTOS(SF2->F2_EMISSAO),SF2->F2_CHVNFE,cCliFor,cLjCliFor,SA1->A1_NOME,,,,SF2->F2_VALBRUT,SF2->F2_PBRUTO,lMarca,SF2->F2_VEICUL1,SF2->F2_VEICUL2,SF2->F2_VEICUL3)
						EndIf
					EndIf
					SF2->(dbSkip())
				EndDo
			#ENDIF
		EndIf
	EndIf
Return

//----------------------------------------------------------------------
/*/ RecTRB
Grava ou altera um registro na TRB a partir dos parametros recebidos

@author Natalia Sartori
@since 10/02/2014
@version P11
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function RecTRB(lInclui,cSerie,cDoc,cEmissao,cChaveNFe,cCodCli,cLoja,cNomCli,cCodMun,cNomMun,cEstMun,nValBru,nPeso,lMarca,cVeic1,cVeic2,cVeic3)
	Local lRet := .T.
	Default cCodMun := ""
	Default cNomMun := ""
	Default lMarca := .F.
	

	dbSelectArea('TRB')
	TRB->(dbSetOrder(1))

	If !lInclui
		If !TRB->(dbSeek(cSerie+cDoc))
			lRet := .F.
		EndIf
	EndIf
	
	If lRet
		RecLock('TRB',lInclui)
		TRB->TRB_MARCA := iif(lMarca,cMark,"")
		TRB->TRB_SERIE := cSerie
		TRB->TRB_DOC := cDoc
		TRB->TRB_EMISS := STOD(cEmissao)
		TRB->TRB_CHVNFE := cChaveNFe
		TRB->TRB_CODMUN := cCodMun
		TRB->TRB_NOMMUN := cNomMun
		TRB->TRB_EST	:= 	cEstMun
		TRB->TRB_CODCLI := cCodCli
		TRB->TRB_LOJCLI := cLoja
		TRB->TRB_NOMCLI := cNomCli
		TRB->TRB_VALTOT := nValBru
		TRB->TRB_PESBRU := nPeso
		TRB->TRB_VEICU1 := cVeic1
		TRB->TRB_VEICU2 := cVeic2
		TRB->TRB_VEICU3 := cVeic3
		TRB->(msUnlock())
	EndIf
		
Return lRet

//----------------------------------------------------------------------
/*/ CleanTRB
Esvazia a tabela TRB, para uma nova recarga

@author Natalia Sartori
@since 10/02/2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function CleanTRB(nOpc)
	
	If Select('TRB') > 0
		TRB->(dbGoTo(1))
		TRB->(dbGoTop())
		While TRB->(!Eof())
			RecLock('TRB',.F.)
			TRB->TRB_MARCA := " "
			TRB->(dbDelete())
			TRB->(msUnlock())
			TRB->(dbSkip())
		EndDo
	EndIf
	           
	//Reinicia variaveis de controle
	If nOpc == 3
		cCodMun := Space(TamSx3("CC2_CODMUN")[1])
		cNomMun := Space(TamSx3("CC2_MUN")[1])
		nQtNFe	:= 0
		nVTotal	:= 0
		nPBruto	:= 0
	EndIf
	
	//Atualiza os objetos graficos da tela
	RefreshMainObjects()
Return
      

//----------------------------------------------------------------------
/*/ GetTitulo
Retorna o titulo de um campo do SX3 passado como parametro

@author Natalia Sartori
@since 10/02/2014
@version P11 

@param	cField  - Nome do campo pesquisado
@Return	cTitulo - Titulo do campo pesquisado no SX3
/*/
//-----------------------------------------------------------------------
Static Function GetTitulo(cField)
	Local cTitulo := ""
	Local aArea := GetArea()
	Default cField := ""

	dbSelectArea('SX3')
	SX3->(dbSetOrder(2))
	If !Empty(cField) .and. SX3->(dbSeek(cField))
		cTitulo := X3Titulo()
	EndIf
	          
	RestArea(aArea)
Return cTitulo

//----------------------------------------------------------------------
/*/ MarcaNF
Marca uma NF na MSSelect de Notas

@author Natalia Sartori
@since 10/02/2014
@version P11 

@param	cField  - Nome do campo pesquisado
@Return	cTitulo - Titulo do campo pesquisado no SX3
/*/
//-----------------------------------------------------------------------
Static Function MarcaNF(nOpc)
	Local lMarca := Empty(TRB->TRB_MARCA)
    
	If (nOpc == 3 .or. nOpc == 4)

	    //Define qual sera o municipio de carregamento desta NFe
		if lMarca
			If len(aMun) <= 99
				If !SetMunForNF()
					Return .F.
				EndIf
			Else
				MsgStop('O limite de 100 municipios foi atingido.')
				Return .F.
			EndIf
		EndIf
	    
	    //Grava a marca e o municipio
		RecLock("TRB",.F.)
		if lMarca
			TRB->TRB_MARCA := cMark
			TRB->TRB_CODMUN := cCodMun
			TRB->TRB_NOMMUN := cNomMun
			TRB->TRB_EST	:= cEstMun
			
		    //Soma totais de notas
			nQtNFe++
			nVTotal := nVTotal + TRB->TRB_VALTOT
			nPBruto := nPBruto + TRB->TRB_PESBRU
		Else
			TRB->TRB_MARCA := " "
			TRB->TRB_CODMUN := " "
			TRB->TRB_NOMMUN := " "
			TRB->TRB_EST	:= " "
			
			//Subtrai totais de notas
			nQtNFe--
			nVTotal := nVTotal - TRB->TRB_VALTOT
			nPBruto := nPBruto - TRB->TRB_PESBRU
	
		EndIf
		TRB->(msUnlock())
	                         
	    
	    //Atualiza objetos graficos
		RefreshMainObjects()
	EndIf
			
Return .T.

//----------------------------------------------------------------------
/*/ SetMunForNF
Exibe a dialog com o municipio de carregamento da NF

@author Natalia Sartori
@since 10/02/2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function SetMunForNF()
	Local oDlgMun := NIl
	Local oBoxMun := Nil
	Local lRet		:= .F.
	Local cUF		:= cUFDesc
	Local aIndArq	:={}
	Local cCondicao	:= ""
	Private oGetCodMun := ""
	Private oGetDesMun := ""
	
	//Monta o Filtro na CC2 com a UF de descarregamento
	//Este ponto eh importante para que so sejam apresentados os municipios da UF marcada
	cCondicao := "CC2_FILIAL == '" + xFilial("CCC2") + "'
	cCondicao += " .AND. CC2_EST == '" + cUF + "' "
	FilBrowse("CC2",@aIndArq,@cCondicao)
	
	//Monta a Dialog
	oDlgMun:= MSDIALOG():Create()
	oDlgMun:cName     		:= "oDlgMun"
	oDlgMun:cCaption  		:= "Municipio Descarregamento"
	oDlgMun:nLeft     		:= MDFeResol(80,.T.) //80
	oDlgMun:nTop      		:= MDFeResol(60,.F.) //60
	oDlgMun:nWidth    		:= MDFeResol(30,.T.) //95
	oDlgMun:nHeight   		:= MDFeResol(25,.F.) //80
	oDlgMun:lShowHint 		:= .F.
	oDlgMun:lCentered 		:= .T.
	oDlgMun:bInit 			:= {|| EnchoiceBar(oDlgMun, {||( lRet := .T., oDlgMun:End() )} , {||( lRet := .F., oDlgMun:End() )} ,, {} ) }
	
	//Box Municipio Carregamento
	oBoxMun:= TGROUP():Create(oDlgMun)
	oBoxMun:cName 	   := "oBoxMun"
	oBoxMun:cCaption   := "Descarga de Mercadorias"
	oBoxMun:nLeft 	   := MDFeResol(2,.T.)
	oBoxMun:nTop  	   := MDFeResol(3,.F.)
	oBoxMun:nWidth 	   := MDFeResol(26,.T.)
	oBoxMun:nHeight    := MDFeResol(15,.F.)
	oBoxMun:lShowHint  := .F.
	oBoxMun:lReadOnly  := .F.
	oBoxMun:Align      := 0
	oBoxMun:lVisibleControl := .T.
		
	//Say UF de descarregamento
	oSayUFDes:= TSAY():Create(oDlgMun)
	oSayUFDes:cName				:= "oSayUFDes"
	oSayUFDes:cCaption 			:= "UF de Descarregamento: "
	oSayUFDes:nLeft 			:= MDFeResol(4,.T.)
	oSayUFDes:nTop 				:= MDFeResol(6,.F.)
	oSayUFDes:nWidth 	   		:= MDFeResol(15,.T.)
	oSayUFDes:nHeight 			:= MDFeResol(2.5,.F.)
	oSayUFDes:lShowHint 		:= .F.
	oSayUFDes:lReadOnly 		:= .F.
	oSayUFDes:Align 			:= 0
	oSayUFDes:lVisibleControl	:= .T.
	oSayUFDes:lWordWrap 	  	:= .F.
	oSayUFDes:lTransparent	 	:= .F.
	oSayUFDes:nClrText	 		:= CLR_HBLUE

	//Get UF Carregamento
	oGetUFDes:= TGET():Create(oDlgMun)
	oGetUFDes:cName 	 		:= "oGetCodMun"
	oGetUFDes:nLeft 	 		:= MDFeResol(18,.T.)
	oGetUFDes:nTop 	 			:= MDFeResol(5.7,.F.)
	oGetUFDes:nWidth 	  		:= MDFeResol(6,.T.)
	oGetUFDes:nHeight 	  		:= MDFeResol(nPercAlt,.F.)
	oGetUFDes:lShowHint 		:= .F.
	oGetUFDes:lReadOnly 		:= .F.
	oGetUFDes:Align 	 		:= 0
	oGetUFDes:cF3				:= ""
	oGetUFDes:lVisibleControl 	:= .T.
	oGetUFDes:lPassword 		:= .F.
	oGetUFDes:lHasButton		:= .F.
	oGetUFDes:cVariable 		:= "cUF"
	oGetUFDes:bSetGet 	 		:= {|u| If(PCount()>0,cUF:=u,cUF)}
	oGetUFDes:Picture   		:= PesqPict("CC2","CC2_EST")
	oGetUFDes:bWhen     		:= {|| .F.}
	oGetUFDes:bChange			:= {|| .F. }
 	
 	//Say Codigo Municipio de descarregamento
	oSayCodMun:= TSAY():Create(oDlgMun)
	oSayCodMun:cName			:= "oSayCodMun"
	oSayCodMun:cCaption 		:= "Municipio de Descarregamento: "
	oSayCodMun:nLeft 			:= MDFeResol(4,.T.)
	oSayCodMun:nTop 			:= MDFeResol(10,.F.)
	oSayCodMun:nWidth 	   		:= MDFeResol(15,.T.)
	oSayCodMun:nHeight 			:= MDFeResol(2.5,.F.)
	oSayCodMun:lShowHint 		:= .F.
	oSayCodMun:lReadOnly 		:= .F.
	oSayCodMun:Align 			:= 0
	oSayCodMun:lVisibleControl	:= .T.
	oSayCodMun:lWordWrap 	  	:= .F.
	oSayCodMun:lTransparent 	:= .F.
	oSayCodMun:nClrText 		:= CLR_HBLUE

	//Get Codigo Municipio de Carregamento
	oGetCodMun:= TGET():Create(oDlgMun)
	oGetCodMun:cName 	 		:= "oGetCodMun"
	oGetCodMun:nLeft 	 		:= MDFeResol(18,.T.)
	oGetCodMun:nTop 	 		:= MDFeResol(9.7,.F.)
	oGetCodMun:nWidth 	  		:= MDFeResol(6,.T.)
	oGetCodMun:nHeight 	  		:= MDFeResol(nPercAlt,.F.)
	oGetCodMun:lShowHint 		:= .F.
	oGetCodMun:lReadOnly 		:= .F.
	oGetCodMun:Align 	 		:= 0
	oGetCodMun:cF3				:= "CC2"
	oGetCodMun:lVisibleControl 	:= .T.
	oGetCodMun:lPassword 		:= .F.
	oGetCodMun:lHasButton		:= .F.
	oGetCodMun:cVariable 		:= "cCodMun"
	oGetCodMun:bSetGet 	 		:= {|u| If(PCount()>0,cCodMun:=u,cCodMun)}
	oGetCodMun:Picture   		:= PesqPict("CC2","CC2_CODMUN")
	oGetCodMun:bWhen     		:= {|| .T.}
	oGetCodMun:bChange			:= {|| LoadNomeMun(cCodMun,@cNomMun,@cEstMun) }
	oGetCodMun:bValid			:= {|| !Empty(cCodMun) .and. LoadNomeMun(cCodMun,@cNomMun,@cEstMun) }
    
	//Say Nome Municipio
	oSayDesMun:= TSAY():Create(oDlgMun)
	oSayDesMun:cName			:= "oSayDesMun"
	oSayDesMun:cCaption 		:= "Nome: "
	oSayDesMun:nLeft 			:= MDFeResol(4,.T.)
	oSayDesMun:nTop 			:= MDFeResol(14,.F.)
	oSayDesMun:nWidth 	   		:= MDFeResol(15,.T.)
	oSayDesMun:nHeight 			:= MDFeResol(2.5,.F.)
	oSayDesMun:lShowHint 		:= .F.
	oSayDesMun:lReadOnly 		:= .F.
	oSayDesMun:Align 			:= 0
	oSayDesMun:lVisibleControl	:= .T.
	oSayDesMun:lWordWrap 	  	:= .F.
	oSayDesMun:lTransparent 	:= .F.
	oSayDesMun:nClrText 		:= CLR_HBLUE

	//Get Codigo Municipio de Descarregamento
	oGetDesMun:= TGET():Create(oDlgMun)
	oGetDesMun:cName 	 		:= "oGetDesMun"
	oGetDesMun:nLeft 	 		:= MDFeResol(8,.T.)
	oGetDesMun:nTop 	 		:= MDFeResol(13.7,.F.)
	oGetDesMun:nWidth 	  		:= MDFeResol(16,.T.)
	oGetDesMun:nHeight 	  		:= MDFeResol(nPercAlt,.F.)
	oGetDesMun:lShowHint 		:= .F.
	oGetDesMun:lReadOnly 		:= .F.
	oGetDesMun:Align 	 		:= 0
	oGetDesMun:lVisibleControl 	:= .T.
	oGetDesMun:lPassword 		:= .F.
	oGetDesMun:lHasButton		:= .F.
	oGetDesMun:cVariable 		:= "cNomMun"
	oGetDesMun:bSetGet 	 		:= {|u| If(PCount()>0,cNomMun:=u,cNomMun)}
	oGetDesMun:Picture   		:= PesqPict("CC2","CC2_MUN")
	oGetDesMun:bWhen     		:= {|| .F.}
	oGetDesMun:bChange			:= {|| .T. }
	oGetDesMun:bValid			:= {|| !Empty(cNomMun)}
	
	//Exibe a Dialog
	oDlgMun:Activate()
	
	//Verifica se a UF do municipio é a mesma da UF Descarga
	If lRet
		If cEstMun != cUFDesc
			MsgStop('Este municipio não esta localizado dentro a UF: ' + cUFDesc + ' definido como UF de Descarga do MDFe')
			lRet := .F.
		Else
			//Verifica se ja contou o municipio
			If aScan(aMun,cCodMun) <= 0
				aAdd(aMun,cCodMun)
			EndIf
		EndIf
	EndIf
	
	/*Elimina os filtros da CC2*/
	RetIndex("CC2")
	dbClearFilter()
	aEval(aIndArq,{|x| Ferase(x[1]+OrdBagExt())})
	
Return lRet

//----------------------------------------------------------------------
/*/ LoadVarsByCC0 
Carrega as variais private a partir do registro selecionado na CC0 e
do XML

@author Natalia Sartori
@since 10/02/2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function LoadVarsByCC0(nOpc)
	Local oXML		:= Nil
	Local cError	:= ""
	Local cWarning	:= ""
	Local aLacres	:= {}
	Local aMunCar	:= {}
	Local aPerc	:= {}
	Local nI		:= 1
	Local nJ		:= 1
	Local oInfCpl	:= Nil
	Local oInfFsc	:= NIl
	Local aMunNfe	:= {}
	Local aChvsNFe	:= {}
	Local cEstCod	:= ""
	Local cMunCod	:= ""
	Local cMunDesc	:= ""
	
	Private aCNPJ	:= {}

	
	cSerMDF		:= CC0->CC0_SERMDF
	cNumMDF		:= CC0->CC0_NUMMDF
	cUFCarr		:= CC0->CC0_UFINI
	cUFDesc		:= CC0->CC0_UFFIM
	cUFCarrAux	:= cUFCarr
	cUFDescAux	:= cUFDesc
	cVTotal		:= CC0->CC0_VTOTAL
	cVeiculo	  := CC0->CC0_VEICUL
	cMotorista := CC0->CC0_MOTORI
	cVeiculoAux	:= cVeiculo
	nQtNFe		:= CC0->CC0_QTDNFE
	nVTotal		:= CC0->CC0_VTOTAL
	nPBruto		:= CC0->CC0_PESOB
	oXML		:= XmlParser(CC0->CC0_XMLMDF,"",@cError,@cWarning)
   
	If ValType(oXML) == "O"
		aMunNfe		:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA")
		oInfCpl		:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_INFADIC:_INFCPL")
		oInfFsc		:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_INFADIC:_INFADFISCO")
		aLacres		:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_LACRES")
		aCNPJ		:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_AUTXML")
		aMunCar		:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_IDE:_INFMUNCARREGA")
		aPerc		:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_IDE:_INFPERCURSO")
	    
	    //Monta o texto de informacoes complementares
		If ValType(oInfCpl) == "O"
			cInfCpl := Padr(oInfCpl:TEXT,5000)
		EndIf
		
		//Monta o texto de informacoes complementares
		If ValType(oInfFsc) == "O"
			cInfFsc := Padr(oInfFsc:TEXT,2000)
		EndIf
	    
	   	//Monta o array (aCols) de lacres
		aColsLacre := {}
		If ValType(aLacres) <> "U"
			If ValType(aLacres) == "A"
				For nI := 1 to len(aLacres)
					aAdd(aColsLacre,{aLacres[nI]:_nLACRE:TEXT,.F.})
				Next nI
			ElseIf !Empty(aLacres:_nlacre:TEXT)
				aAdd(aColsLacre,{aLacres:_nLACRE:TEXT,.F.})
			Else
				aColsLacre := GetNewLine(aHeadLacre)
			EndIf
		EndIf
		   	
	   	//Monta o array de CNPJs/CPF Autorizados
		aColsAuto := {}
		If ValType(aCNPJ) <> "U"
			If ValType(aCNPJ) == "A"
				For nI := 1 to len(aCNPJ)
					If Type("aCNPJ["+Alltrim(Str(nI))+"]:_CPF") <> "U"
						aAdd(aColsAuto,{aCNPJ[nI]:_CPF:TEXT,.F.})
					EndIf
				
					If Type("aCNPJ["+Alltrim(Str(nI))+"]:_CNPJ") <> "U"
						aAdd(aColsAuto,{aCNPJ[nI]:_CNPJ:TEXT,.F.})
					EndIf
					//aAdd(aColsAuto,{aCNPJ[nI]:TEXT,.F.})   	
				Next nI
			ElseIf Type("aCNPJ:_CPF") <> "U" .and. !Empty(aCNPJ:_CPF:TEXT)
				aAdd(aColsAuto,{aCNPJ:_CPF:TEXT,.F.})
			ElseIf Type("aCNPJ:_CNPJ") <> "U" .and. !Empty(aCNPJ:_CNPJ:TEXT)
				aAdd(aColsAuto,{aCNPJ:_CNPJ:TEXT,.F.})
			Else
				aColsAuto := GetNewLine(aHeadAuto)
			EndIf
		EndIf
		
		//Monta o array de Municipios de Carregamento
		aColsMun := {}
		If ValType(aMunCar) <> "U"
			If ValType(aMunCar) == "A"
				For nI := 1 to len(aMunCar)
					aAdd(aColsMun,{Iif(Empty(substr(aMunCar[ nI ]:_CMUNCARREGA:TEXT,3,len(aMunCar[ nI ]:_CMUNCARREGA:TEXT))),Space(TamSx3('CC2_CODMUN')[1]),substr(aMunCar[ nI ]:_CMUNCARREGA:TEXT,3,len(aMunCar[ nI ]:_CMUNCARREGA:TEXT))),GetUfSig(substr(aMunCar[ nI ]:_CMUNCARREGA:TEXT,1,2)),aMunCar[ nI ]:_XMUNCARREGA:TEXT,.F.})
				Next nI
			ElseIf !Empty(aMunCar:_CMUNCARREGA:TEXT)
				aAdd(aColsMun,{Iif(Empty(substr(aMunCar:_CMUNCARREGA:TEXT,3,len(aMunCar:_CMUNCARREGA:TEXT))),Space(TamSx3('CC2_CODMUN')[1]),substr(aMunCar:_CMUNCARREGA:TEXT,3,len(aMunCar:_CMUNCARREGA:TEXT))),GetUfSig(substr(aMunCar:_CMUNCARREGA:TEXT,1,2)),aMunCar:_XMUNCARREGA:TEXT,.F.})
			Else
				aColsMun := GetNewLine(aHeadMun)
			EndIf
		EndIf
	   
	
		//Monta o array de percurso		
		aColsPerc := {}
		If ValType(aPerc) <> "U"
			If ValType(aPerc) == "A"
				For nI := 1 to len(aPerc)
					aAdd(aColsPerc,{aPerc[nI]:_UFPER:TEXT,.F.})
				Next nI
			ElseIf !Empty(aPerc:_UFPER:TEXT)
				aAdd(aColsPerc,{aPerc:_UFPER:TEXT,.F.})
			Else
				aColsPerc := GetNewLine(aHeadPerc)
			EndIf
		EndIf
		
		//Por fim pega todas as Chaves de NFe e atualiza os municipios dentro do TRB
		If ValType(aMunNfe) <> "U"
			If ValType(aMunNfe) == "A"
				For nI := 1 to len(aMunNfe)
			    	//Pego o nome e o codigo do municipio'
					cEstCod := substr(aMunNFe[nI]:_CMUNDESCARGA:TEXT,1,2)
					cMunCod := substr(aMunNFe[nI]:_CMUNDESCARGA:TEXT,3,len(aMunNFe[nI]:_CMUNDESCARGA:TEXT))
					cMunDesc := aMunNFe[nI]:_XMUNDESCARGA:TEXT
					If ValType(aMunNFe[nI]:_INFNFE) == "A"
			    		
			    		//Pego  todas as notas deste municipio
						For nJ := 1 to len(aMunNFe[nI]:_INFNFE)
							aAdd(aChvsNFe,{cEstCod,cMunCod,cMunDesc,aMunNFe[nI]:_INFNFE[nJ]:_CHNFE:TEXT})
						Next nJ
					Else
						aAdd(aChvsNFe,{cEstCod,cMunCod,cMunDesc,aMunNFe[nI]:_INFNFE:_CHNFE:TEXT})
					EndIf
				Next nI
			Else
		    	//Pego o nome e o codigo do municipio'
				cEstCod := substr(aMunNFe:_CMUNDESCARGA:TEXT,1,2)
				cMunCod := substr(aMunNFe:_CMUNDESCARGA:TEXT,3,len(aMunNFe:_CMUNDESCARGA:TEXT))
				cMunDesc := aMunNFe:_XMUNDESCARGA:TEXT
				If ValType(aMunNFe:_INFNFE) == "A"
		    		
		    		//Pego  todas as notas deste municipio
					For nJ := 1 to len(aMunNFe:_INFNFE)
						aAdd(aChvsNFe,{cEstCod,cMunCod,cMunDesc,aMunNFe:_INFNFE[nJ]:_CHNFE:TEXT})
					Next nJ
				Else
					aAdd(aChvsNFe,{cEstCod,cMunCod,cMunDesc,aMunNFe:_INFNFE:_CHNFE:TEXT})
				EndIf
			EndIf
		EndIf
		
		//A partir das chaves e dos seus municipios identificados, atualiza o TRB
		If Len(aChvsNFe) > 0
			LoadTRB(nOpc)
			AtuTRBMun(aChvsNFe)
		EndIf
	EndIf

Return

//----------------------------------------------------------------------
/*/ ResetVars 
Inicializa as variaveis com valores nulos

@author Natalia Sartori
@since 10/02/2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function ResetVars()
   
	aHeadMun	:= GetHeaderMun()
	aHeadPerc	:= GetHeaderPerc()
	aHeadAuto	:= GetHeaderAuto()
	aHeadLacre	:= GetHeaderLacre()
	cNumMDF		:= Space(TamSx3('CC0_NUMMDF')[1])			//Variavel que contem o numero do MDFE
	cSerMDF		:= Space(TamSx3('CC0_SERMDF')[1])			//Variavel que contem a Serie do MDFE
	cUFCarr		:= Space(TamSx3('CC0_UFINI')[1])			//Variavel que contem a UF de Carregamento
	cUFDesc		:= Space(TamSx3('CC0_UFFIM')[1])			//Variavel que contem a UF de Descarregamento
	cUFCarrAux	:= Space(TamSx3('CC0_UFINI')[1])			//Variavel Auxiliar (para controle alteracoes) que contem a UF de Carregamento
	cUFDescAux	:= Space(TamSx3('CC0_UFFIM')[1])			//Variavel Auxiliar (para controle alteracoes) que contem a UF de Descarregamento
	cVTotal		:= Space(TamSx3('CC0_VTOTAL')[1])			//Variavel que contem o valor total da carga/mercadoria
	cVeiculo	:= Space(TamSx3('DA3_COD')[1])				//Variavel que contem o valor total da carga/mercadoria
	cMotorista	:= Space(TamSx3('CC0_MOTORI')[1])				//Variavel que contem o Codigo do motorista
	cVeiculoAux	:= Space(TamSx3('DA3_COD')[1])				//Variavel que contem o valor total da carga/mercadoria
	nQtNFe		:= 0										//Variavel que contem a Quantidade total de NFe
	nVTotal		:= 0										//Variavel que contem a Valor total de notas
	nPBruto		:= 0										//Variavel que contem a Peso total do MDF-e
	cInfCpl		:= Space(5000)
	cInfFsc		:= Space(2000)

	aColsMun	:= GetNewLine(aHeadMun,.T.)
	aColsPerc	:= GetNewLine(aHeadPerc)
	aColsAuto	:= GetNewLine(aHeadAuto)
	aColsLacre	:= GetNewLine(aHeadLacre)
Return

Static Function GetMDeInfo(oXMLStru,cNode)
	Local xRet := oXMLStru
	Local aBusca := StrTokArr(cNode,":")
	Local nI := 1
    
	For nI := 1 to len(aBusca)
		xRet := XmlChildEx(xRet,aBusca[nI])
		                 
		If ValType(xRet) == "U"
			exit
		EndIf
	Next nI

Return xRet

//----------------------------------------------------------------------
/*/ AtuTRBMun 
Atualiza no TRB os nomes dos municipios de acordo com o XML

@author Natalia Sartori
@since 10/02/2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function AtuTRBMun(aChvsNFe)
	Local aAreaTRB := TRB->(GetArea())
	Local nPos := 0
	
	TRB->(dbGoTop())
	While TRB->(!Eof())
		nPos := aScan(aChvsNFe,{|x| alltrim(x[4]) == Alltrim(TRB->TRB_CHVNFE) })
		If nPos > 0
			RecLock('TRB',.F.)
			TRB->TRB_EST	:= GetUfSig(aChvsNFe[nPos,1])
			TRB->TRB_CODMUN := aChvsNFe[nPos,2]
			TRB->TRB_NOMMUN := aChvsNFe[nPos,3]
			TRB->(msUnlock())
		EndIf
		TRB->(dbSkip())
	EndDo
		
	RestArea(aAreaTRB)
	TRB->(dbGoTop())
Return

//----------------------------------------------------------------------
/*/ LoadNomeMun 
Carrega o nome do municipio a partir do codigo recebido Exibe a dialog com
o municipio de carregamento da NF

@author Natalia Sartori
@since 10/02/2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function LoadNomeMun(cCodMun,cNomMun,cEstMun)
	Local aArea := CC2->(GetArea())
	Local lRet := .F.
	
	dbSelectArea('CC2')
	CC2->(dbSetOrder(1))
	If CC2->(dbSeek(xFilial('CC2')+cUFDesc+cCodMun))
		cNomMun := CC2->CC2_MUN
		cEstMun := cUFDesc
		lRet := .T.
	Else
		cCodMun := Space(TamSx3("CC2_CODMUN")[1])
		cNomMun := Space(TamSx3("CC2_MUN")[1])
		MsgInfo('Codigo de Municipio não localizado para a UF: ' + cUFDesc)
		lRet := .F.
	EndIf
	oGetDesMun:Refresh()
	RestArea(aArea)
Return lRet

//----------------------------------------------------------------------
/*/ RefreshMainObjects 
Atualiza os principais componentes graficos da tela principal (Main)

@author Natalia Sartori
@since 24.02.2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function RefreshMainObjects()

	If ValType(oMsSel) == "O"
		oMsSel:oBrowse:Refresh()
		oGetQtNFe:Refresh()
		oGetPBruto:Refresh()
		oGetVTot:Refresh()
	EndIf
	
Return

//----------------------------------------------------------------------
/*/ GetHeaderMun 
Retorna um array com as colunas a serem exibidas na GetDados de Municipio
Carregamento

@author Natalia Sartori
@since 24.02.2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function GetHeaderMun()
	Local aArea	     := GetArea()
	Local aRet       := {}
	Local aCampos    := {"CC2_CODMUN","CC2_EST","CC2_MUN"}
	Local nI		 := 1
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona no SX3³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SX3->(dbSetOrder(2))
	For nI := 1 to len(aCampos)
		If SX3->(dbSeek(aCampos[nI]))
			aAdd( aRet,{ TRIM(X3Titulo()),;
				SX3->X3_CAMPO	,;
				SX3->X3_PICTURE	,;
				SX3->X3_TAMANHO	,;
				SX3->X3_DECIMAL	,;
				iif(alltrim(SX3->X3_CAMPO)=="CC2_CODMUN","MunTrigger()",".T."),;
				SX3->X3_USADO	,;
				SX3->X3_TIPO	,;
				iif(alltrim(SX3->X3_CAMPO)=="CC2_CODMUN","CC2",SX3->X3_F3)	,;
				SX3->X3_CONTEXT	,;
				SX3->X3_CBOX	,;
				SX3->X3_RELACAO	,;
				iif(alltrim(SX3->X3_CAMPO)=="CC2_CODMUN","MunTrigger()",".T.")	,;
				SX3->X3_VISUAL	,;
				SX3->X3_VLDUSER	,;
				SX3->X3_PICTVAR	})
		EndIf
	Next nI
	
	RestArea(aArea)
Return aRet

//----------------------------------------------------------------------
/*/ GetNewLine
Realiza o carregamento da 1 linha da aLinhas em branco na aCols

@author Natalia Sartori
@since 24.02.2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function GetNewLine(aHeader,lCarreg)
	Local aRet   := {}
	Local aArea  := getArea()
	Local nI	 := 0
	            
If TYPE("LCARREG") == "U"
   lCarreg := .F. 
EndIf 
	            
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria um linha do aLinhas em branco³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd(aRet, Array( Len(aHeader)+1 ) )
	
	For nI := 1 To Len(aHeader)
		aRet[Len(aRet),nI] := CriaVar( Alltrim(aHeader[nI,2]))
	Next nI
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atribui .F. para a coluna que determina se alinha do aLinhas esta deletada ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRet[Len(aRet)][Len(aHeader)+1] := .F.

  If lCarreg
  
		dbSelectArea('CC2')
		CC2->(dbSetOrder(1))
		CC2->(dbSeek(xFilial('CC2')+SM0->M0_ESTCOB+Substr(SM0->M0_CODMUN,3,5)))

		aRet[1,1] := CC2->CC2_CODMUN
		aRet[1,2] := CC2->CC2_EST
		aRet[1,3] := CC2->CC2_MUN
   
  EndIf 
  	
	RestArea(aArea)
Return aRet

//----------------------------------------------------------------------
/*/ MunTrigger 
Gatilha o nome do municipio de acordo com o o codigo digitado na GetDados
Carregamento

@author Natalia Sartori
@since 24.02.2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function MunTrigger()
	Local aArea := GetArea()
	Local lRet := .F.
	
	If !Empty(M->CC2_CODMUN)
		dbSelectArea('CC2')
		CC2->(dbSetOrder(1))
		If CC2->(dbSeek(xFilial('CC2')+cUFCarr+M->CC2_CODMUN))
			oGetDMun:aCols[oGetDMun:nAt,2] := CC2->CC2_EST
			oGetDMun:aCols[oGetDMun:nAt,3] := CC2->CC2_MUN
			oGetDMun:oBrowse:Refresh()
			oGetDMun:Refresh()
			lRet := .T.
		Else
			MsgStop('Este municipio não esta localizado dentro a UF: ' + cUFCarr + ' definido como UF de Carregamento do MDFe')
			lRet := .F.
		EndIf
	Else
		oGetDMun:aCols[oGetDMun:nAt,2] := Space(TamSx3('CC2_EST')[1])
		oGetDMun:aCols[oGetDMun:nAt,3] := Space(TamSx3('CC2_MUN')[1])
		oGetDMun:oBrowse:Refresh()
		oGetDMun:Refresh()
		lRet := .T.
	EndIf
	
	RestArea(aArea)
Return lRet

//----------------------------------------------------------------------
/*/ GetHeaderAuto
Retorna um array com as colunas a serem exibidas na GetDados de Autorizados

@author Natalia Sartori
@since 24.02.2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function GetHeaderAuto()
	Local aArea	     := GetArea()
	Local aRet       := {}
	Local aCampos    := {"A1_CGC"}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona no SX3³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SX3->(dbSetOrder(1))
	SX3->(MsSeek("SA1"))
	
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == 'SA1'
		If aScan(aCampos,alltrim(SX3->X3_CAMPO)) > 0
			aAdd( aRet,{ TRIM(X3Titulo()),;
				SX3->X3_CAMPO	,;
				SX3->X3_PICTURE	,;
				SX3->X3_TAMANHO	,;
				SX3->X3_DECIMAL	,;
				".T.",;
				SX3->X3_USADO	,;
				SX3->X3_TIPO	,;
				SX3->X3_F3,;
				SX3->X3_CONTEXT	,;
				SX3->X3_CBOX	,;
				SX3->X3_RELACAO	,;
				".T."			,;
				SX3->X3_VISUAL	,;
				SX3->X3_VLDUSER	,;
				SX3->X3_PICTVAR	})
		EndIf
		SX3->(dbSkip())
	EndDo
	
	RestArea(aArea)
Return aRet
           	
//----------------------------------------------------------------------
/*/ GetHeaderPerc
Retorna um array com as colunas a serem exibidas na GetDados de Percurso

@author Natalia Sartori
@since 24.02.2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function GetHeaderPerc()
	Local aArea	     := GetArea()
	Local aRet       := {}
	Local aCampos    := {"CC2_EST"}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona no SX3³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SX3->(dbSetOrder(1))
	SX3->(MsSeek("CC2"))
	
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == 'CC2'
		If aScan(aCampos,alltrim(SX3->X3_CAMPO)) > 0
			aAdd( aRet,{ TRIM(X3Titulo()),;
				SX3->X3_CAMPO	,;
				SX3->X3_PICTURE	,;
				SX3->X3_TAMANHO	,;
				SX3->X3_DECIMAL	,;
				iif(alltrim(SX3->X3_CAMPO)=="CC2_EST","ValidUfMDF(M->CC2_EST)",SX3->X3_VALID),;
				SX3->X3_USADO	,;
				SX3->X3_TIPO	,;
				iif(alltrim(SX3->X3_CAMPO)=="CC2_EST","12",SX3->X3_F3),;
				SX3->X3_CONTEXT	,;
				SX3->X3_CBOX	,;
				SX3->X3_RELACAO	,;
				".T.",;
				SX3->X3_VISUAL	,;
				SX3->X3_VLDUSER	,;
				SX3->X3_PICTVAR	})
		EndIf
		SX3->(dbSkip())
	EndDo
	
	RestArea(aArea)
Return aRet

//----------------------------------------------------------------------
/*/ GetHeaderLacre
Retorna um array com as colunas a serem exibidas na GetDados de Percurso

@author Natalia Sartori
@since 24.02.2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function GetHeaderLacre()
	Local aArea	     := GetArea()
	Local aRet       := {}
	Local aCampos    := {"DVB_LACRE"}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona no SX3³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SX3->(dbSetOrder(1))
	SX3->(MsSeek("DVB"))
	
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == 'DVB'
		If aScan(aCampos,alltrim(SX3->X3_CAMPO)) > 0
			aAdd( aRet,{ TRIM(X3Titulo()),;
				SX3->X3_CAMPO	,;
				SX3->X3_PICTURE	,;
				SX3->X3_TAMANHO	,;
				SX3->X3_DECIMAL	,;
				".T.",;
				SX3->X3_USADO	,;
				SX3->X3_TIPO	,;
				SX3->X3_F3,;
				SX3->X3_CONTEXT	,;
				SX3->X3_CBOX	,;
				SX3->X3_RELACAO	,;
				".T."			,;
				SX3->X3_VISUAL	,;
				SX3->X3_VLDUSER	,;
				SX3->X3_PICTVAR	})
		EndIf
		SX3->(dbSkip())
	EndDo
	
	RestArea(aArea)
Return aRet

//----------------------------------------------------------------------
/*/ MDFeSetRec 
Realiza a inclusao do novo MDFe no banco de dados

@author Natalia Sartori
@since 24.02.2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function MDFeSetRec(nOpc)
	Local lRet := .F.
	If (nOpc == 3 .or. nOpc == 4 .or. nOpc == 5)
		MsgRun("Gravando dados de Manifestação","Aguarde",{|| lRet := MDFeNewRec(.F.,nOpc) })
	Else
		lRet := .T.
	EndIf
Return lRet

//----------------------------------------------------------------------
/*/ MDFeNewRec 
Montagem do wizard de transmissão do MDFe

@author Natalia Sartori
@since 24.02.2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function MDFeNewRec(lAuto,nOpc)
	Local cTpNrNfs		:= SuperGetMV("MV_TPNRNFS",,"1")
	Local lRet 			:= .F.
	Local cMsg			:= ""
	Local cXML			:= ""
	Local lErpHverao	:= GetNewPar("MV_HVERAO",.F.)   		  // Verifica se o local fisico do servidor está em Horário de Verão  .F. Não / .T. Sim
	Local aDados		:= {}
	Private cNumero		:= ""
	Private cSerie 		:= ""
	Private dDataEmi	:= Date()
	Private cTime		:= FwTimeUF(Upper(Left(LTrim(SM0->M0_ESTENT),2)),,lErpHVerao)[2]
	Default lAuto		:= .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define a mensagem de alerta ao usuario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if nOpc == 3
		cMsg := 'Confirma a inclusão de novo MDF-e'
	ElseIf nOpc == 4
		cMsg := 'Confirma a alteracao do MDF-e'
	ElseIf nOpc == 5
		cMsg := 'Confirma a exclusão do MDF-e'
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa a operação³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If FindFunction("U_XmlMDFeSef")
		If !lAuto
			If !Empty(cUFCarr) .and. !Empty(cUFDesc) .and. !Empty(cVeiculo) .And. !Empty(cMotorista)
				If nQtNFe > 0
					If MsgYesNo(cMsg)
						
						//Inclusao
						If nOpc == 3
							If Sx5NumNota(@cSerie,cTpNrNfs)
	
								cXML := U_XmlMDFeSef(xFilial('CC0'))[2]
	
								aAdd(aDados,{"CC0_FILIAL"	,	cFilAnt			})
								aAdd(aDados,{"CC0_SERMDF"	,	cSerie			})
								aAdd(aDados,{"CC0_NUMMDF"	,	cNumero			})
								aAdd(aDados,{"CC0_TPNF"		,	cEntSai			})
								aAdd(aDados,{"CC0_DTEMIS"	,	dDataEmi		})
								aAdd(aDados,{"CC0_HREMIS"	,	cTime			})
								aAdd(aDados,{"CC0_UFINI"	,	cUFCarr			})
								aAdd(aDados,{"CC0_UFFIM"	,	cUFDesc			})
								aAdd(aDados,{"CC0_QTDNFE"	,	nQtNFe			})
								aAdd(aDados,{"CC0_VTOTAL"	,	nVTotal			})
								aAdd(aDados,{"CC0_STATUS"	, 	NAO_TRANSMITIDO })
								aAdd(aDados,{"CC0_PESOB"	,	nPBruto			})
								aAdd(aDados,{"CC0_VEICUL"	,	cVeiculo		})
								aAdd(aDados,{"CC0_MOTORI"	,	cMotorista		})
								aAdd(aDados,{"CC0_XMLMDF"	,	cXML	})
								
								//Grava Item na CC0					
								If RecInCC0(.T.,aDados)
								
									// Controle de numeracao por SD9
									If cTpNrNfs == "3"

										//Confirma o uso da numeracao do SX5 e SD9
										MA461NumNf(.T.,cSerie,cNumero)
									
									Else
									
										//Confirma o uso da numeracao do SX5
										NxtSX5Nota(cSerie,.T.,cTpNrNfs)
									
									Endif
								
									//Atualiza notas na SF2, com o codigo do Manifesto
									lRet := AtuSF2(cSerie,cNumero)
								EndIf
								If ( __lSX8 )
									ConfirmSX8()
								EndIf
							EndIf
	
					    //Alteracao
						ElseIf nOpc == 4
							cSerie := CC0->CC0_SERMDF
							cNumero := CC0->CC0_NUMMDF
							cXML := U_XmlMDFeSef(xFilial('CC0'))[2]
							aAdd(aDados,{"CC0_FILIAL"	,	cFilAnt			})
							aAdd(aDados,{"CC0_SERMDF"	,	cSerie			})
							aAdd(aDados,{"CC0_NUMMDF"	,	cNumero			})
							aAdd(aDados,{"CC0_TPNF"		,	cEntSai			})
							aAdd(aDados,{"CC0_DTEMIS"	,	Date()			})
							aAdd(aDados,{"CC0_HREMIS"	,	Time()			})
							aAdd(aDados,{"CC0_UFINI"	,	cUFCarr			})
							aAdd(aDados,{"CC0_UFFIM"	,	cUFDesc			})
							aAdd(aDados,{"CC0_XMLMDF"	,	"Problema()"	})
							aAdd(aDados,{"CC0_QTDNFE"	,	nQtNFe			})
							aAdd(aDados,{"CC0_VTOTAL"	,	nVTotal			})
							aAdd(aDados,{"CC0_STATUS"	, 	NAO_TRANSMITIDO })
							aAdd(aDados,{"CC0_PESOB"	,	nPBruto			})
							aAdd(aDados,{"CC0_VEICUL"	,	cVeiculo		})
							aAdd(aDados,{"CC0_MOTORI"	,	cMotorista		})
							aAdd(aDados,{"CC0_XMLMDF"	,	cXML	})
	                        
							If RecInCC0(.F.,aDados)
								//Remove TODAS as marcacoes anteriores deste manifesto na SF2
								DelMDFSf2(cSerie,cNumero)
	
								//Atualiza notas na SF2, com o codigo do Manifesto
								lRet := AtuSF2(cSerie,cNumero)
							EndIf
						
						//Exclusao
						ElseIf nOpc == 5
						
							//Remove TODAS as marcacoes anteriores deste manifesto na SF2
							cSerie := CC0->CC0_SERMDF
							cNumero := CC0->CC0_NUMMDF
							lRet := DelMDFSF2(cSerie,cNumero)
							
							//Apaga da CC0
							RecLock('CC0',.F.)
							CC0->(dbDelete())
							CC0->(msUnlock())
						EndIf
					Else
						lRet := .F.
					EndIf
				Else
					MsgStop('Ao menos 1 documento do tipo NF-e deve ser marcado para elaboração do manifesto')
					lRet := .F.
				EndIf
			Else
				MsgStop('Um ou mais campos obrigatorios nao foram preenchidos')
				lRet := .F.
			EndIf
		Else
			//Tratamento automatico nao implementado - SIGA3286
		EndIF
	Else
		MsgInfo("RDMAKE MDFESefaz.prw não encontrado. MDF-e não sera criado.")
		lRet := .F.
	EndIf
Return lRet

//----------------------------------------------------------------------
/*/ RecInCC0 
Inclui um novo registro de manifesto na CC0

@author Natalia Sartori
@since 24.02.2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function RecInCC0(lInclui,aDados)
	Local nI		:= 1
	Local lRet		:= .F.
	Default aDados	:= {}
	
	If len(aDados) > 0
		
		//Grava na Tabela
		BeginTran()
			RecLock("CC0",lInclui)
			For nI := 1 to len(aDados)
				CC0->(FieldPut(FieldPos(aDados[nI][1]),aDados[nI][2]))
			Next nI
			CC0->(msUnlock())
			lRet := .T.
		EndTran()
	Else
		lRet := .F.
	EndIf
	
Return lRet

//----------------------------------------------------------------------
/*/ AtuSF2 
Atualiza as notas da SF2 que foram contempladas no manifesto recem criado

@author Natalia Sartori
@since 24.02.2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function AtuSF2(cSerMDF,cNumMDF)
	Local lRet := .F.
	Default cSerMDF := ""
	Default cNumMDF := ""
		                 
	if !Empty(cSerMDF) .and. !Empty(cNumMDF)
		dbSelectArea('TRB')
		TRB->(dbGoTop())
		While TRB->(!Eof())
			//Verifica se a nota esta marcada
			If !Empty(TRB->TRB_MARCA)
				
				If cEntSai == "1"
					//Localiza a nota marcada na SF2
					dbSelectArea('SF2')
					SF2->(dbSetOrder(2))
					If SF2->(dbSeek(xFilial('SF2') + TRB->TRB_CODCLI + TRB->TRB_LOJCLI + TRB->TRB_DOC + TRB->TRB_SERIE ))
						RecLock('SF2',.F.)
						SF2->F2_SERMDF := cSerMDF
						SF2->F2_NUMMDF := cNumMDF
						SF2->(msUnlock())
						
						lRet := .T.
					EndIf
				Else
					//Localiza a nota marcada na SF1
					dbSelectArea('SF1')
					SF1->(dbSetOrder(1))	//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
					If SF1->(dbSeek(xFilial('SF1') + TRB->TRB_DOC + TRB->TRB_SERIE + TRB->TRB_CODCLI + TRB->TRB_LOJCLI ))
						RecLock('SF1',.F.)
						SF1->F1_SERMDF := cSerMDF
						SF1->F1_NUMMDF := cNumMDF
						SF1->(msUnlock())
						
						lRet := .T.
					EndIf
				EndIf
			EndIf
			TRB->(dbSkip())
		EndDo
	EndIf

	TRB->(dbGoTop())
Return lRet

//----------------------------------------------------------------------
/*/ DelMDFSf2 
Remove todos os registros do MDF passado como parametro da SF2

@author Natalia Sartori
@since 24.02.2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function DelMDFSf2(cSerie,cNumero)
	Local cQuery := ""
	Local cAlias := GetNextAlias()
	Local aArea	 := GetArea()
	Local lRet	 := .F.
	
	dbSelectArea('SF2')
	SF2->(dbSetOrder(1))
	SF2->(dbGoTop())
	
	#IFDEF TOP
		cQuery := "SELECT SF2.R_E_C_N_O_ RECN FROM " + RetSqlName('SF2') + " SF2 "
		cQuery += " WHERE SF2.F2_FILIAL = '" + xFilial('SF2') + "' "
		cQuery += " 	AND SF2.F2_SERMDF = '" + cSerie + "' "
		cQuery += " 	AND SF2.F2_NUMMDF = '" + cNumero + "' "
		cQuery += " 	AND SF2.D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery(cQuery)
		iif(Select(cAlias)>0,(cAlias)->(dbCloseArea()),Nil)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias, .F., .T.)
		While (cAlias)->(!Eof())
			SF2->(dbGoTo((cAlias)->RECN))
			RecLock('SF2',.F.)
			SF2->F2_SERMDF = ""
			SF2->F2_NUMMDF = ""
			SF2->(msUnlock())
			
			(cAlias)->(dbSkip())
			
			lRet := .T.
		EndDo
	#ELSE
		While SF2->(!Eof())
			If SF2->F2_FILIAL = xFilial('SF2') .and. ;
					SF2->F2_SERMDF = cSerie .and. ;
					SF2->F2_NUMMDF = cNumero

				RecLock('SF2',.F.)
				SF2->F2_SERMDF = ""
				SF2->F2_NUMMDF = ""
				SF2->(msUnlock())
				lRet := .T.
			EndIf
			SF2->(dbSkip())
		EndDo
	#ENDIF
	
	RestArea(aArea)
Return lRet

//----------------------------------------------------------------------
/*/ GetUfSig 

Montagem do wizard de transmissão do MDFe

@author Natalia Sartori
@since 24.02.2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function GetUfSig(cCod,lForceUF)
	Local aUf := {}
	Local nPos := 0
	Local cSigla := ""
	DEFAULT lForceUF := .F.
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Preenchimento do Array de UF                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aUF,{"RO","11"})
	aadd(aUF,{"AC","12"})
	aadd(aUF,{"AM","13"})
	aadd(aUF,{"RR","14"})
	aadd(aUF,{"PA","15"})
	aadd(aUF,{"AP","16"})
	aadd(aUF,{"TO","17"})
	aadd(aUF,{"MA","21"})
	aadd(aUF,{"PI","22"})
	aadd(aUF,{"CE","23"})
	aadd(aUF,{"RN","24"})
	aadd(aUF,{"PB","25"})
	aadd(aUF,{"PE","26"})
	aadd(aUF,{"AL","27"})
	aadd(aUF,{"MG","31"})
	aadd(aUF,{"ES","32"})
	aadd(aUF,{"RJ","33"})
	aadd(aUF,{"SP","35"})
	aadd(aUF,{"PR","41"})
	aadd(aUF,{"SC","42"})
	aadd(aUF,{"RS","43"})
	aadd(aUF,{"MS","50"})
	aadd(aUF,{"MT","51"})
	aadd(aUF,{"GO","52"})
	aadd(aUF,{"DF","53"})
	aadd(aUF,{"SE","28"})
	aadd(aUF,{"BA","29"})
	aadd(aUF,{"EX","99"})
	
	nPos := aScan(aUF,{|x| x[1] == cCod})
	If nPos == 0
		nPos := aScan(aUF,{|x| x[2] == cCod})
		If nPos <> 0
			cSigla := aUF[nPos][1]
		EndIf
	Else
		cSigla := aUF[nPos][IIF(!lForceUF,2,1)]
	EndIf
	
Return cSigla
	
//----------------------------------------------------------------------
/*/ MDFeTrans 

Montagem do wizard de transmissão do MDFe

@author Natalia Sartori
@since 24.02.2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function MDFeTrans ()

	Local aArea		:= GetArea()
	Local aPerg		:= {}
	Local aParam		:= {Space(Len(CC0->CC0_SERMDF)),Space(Len(CC0->CC0_NUMMDF)),Space(Len(CC0->CC0_NUMMDF))}
	Local aTexto		:= {}
	Local aXML			:= {}


	Local cRetorno		:= ""
	Local cAmbiente	:= ""
	Local cModalidade	:= ""
	Local cVerLeiEve	:= ""
	Local cVerLeiaut	:= ""
	Local cVersaoMdf	:= ""
	Local cParMFFeRe	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDMDFEREM"
	Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cMonitorSEF	:= ""
	Local cSugestao	:= ""

	Local oWizard
	Local nX          := 0

	Local lOk			:= .T.

	Local lRetorno		:= .F.
	Local lUsaColab	:= UsaColaboracao("5")


	MV_PAR01 := aParam[01] := PadR(ParamLoad(cParMFFeRe,aPerg,1,aParam[01]),Len(CC0->CC0_SERMDF))
	MV_PAR02 := aParam[02] := PadR(ParamLoad(cParMFFeRe,aPerg,2,aParam[02]),Len(CC0->CC0_NUMMDF))
	MV_PAR03 := aParam[03] := PadR(ParamLoad(cParMFFeRe,aPerg,3,aParam[03]),Len(CC0->CC0_NUMMDF))

	aadd(aPerg,{1,"Serie do MDFe",aParam[01],"",".T.","",".T.",30,.F.})	//
	aadd(aPerg,{1,"MDFe inicial",aParam[02],"",".T.","",".T.",30,.T.})	//
	aadd(aPerg,{1,"MDFe final",aParam[03],"",".T.","",".T.",30,.T.})	//

	If CTIsReady(,,,lUsaColab)
		If !Empty(cIdEnt)
	
			If lUsaColab
		
				lOk := ColParValid(("MDF"),@cRetorno)
			
				If lOk
					cAmbiente		:= ColGetPar("MV_AMBMDF","")+" - " +ColDescOpcao("MV_AMBMDF", ColGetPar("MV_AMBMDF","") )
					cModalidade	:= ColGetPar("MV_MODMDF","")+" - " +ColDescOpcao("MV_MODMDF", ColGetPar("MV_MODMDF","") )
					cVerLeiEve		:= ColGetPar("MV_EVENMDF","")
					cVerLeiaut		:= ColGetPar("MV_VLAYMDF","")
					cVersaoMdf		:= ColGetPar("MV_VERMDF","")
				
					cMonitorSEF += "- MDFe"+CRLF
					cMonitorSEF += "Versao do layout: "+cVersaoMdf+CRLF	//
								
				Else
					Aviso("MDF-e","Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!",{"Ok"},3) //
				EndIf
			
			Else
			
				oWS :=  WsSpedCfgNFe():New()
				oWS:cUSERTOKEN 		:= "TOTVS"
				oWS:cID_ENT    		:= cIdEnt
				oWS:nAmbienteMDFE  	:= 0
				oWS:cVersaoMDFE 	:= "0.00"
				oWS:nModalidadeMDFE := 0
				oWS:cVERMDFELAYOUT	:= "0.00"
				oWS:cVERMDFELAYEVEN	:= "0.00"
				oWS:nSEQLOTEMDFE  	:= 0
				oWS:_URL       		:= AllTrim(cURL)+"/SPEDCFGNFe.apw"
				lOk:= oWS:CFGMDFE()
		  
				cAmbiente		:= oWS:OWSCFGMDFERESULT:CAMBIENTEMDFE
				cModalidade	:= oWS:OWSCFGMDFERESULT:CMODALIDADEMDFE
				cVerLeiEve		:= oWS:OWSCFGMDFERESULT:CVERMDFELAYEVEN
				cVerLeiaut		:= oWS:OWSCFGMDFERESULT:CVERMDFELAYOUT
				cVersaoMdf		:= oWS:OWSCFGMDFERESULT:CVERSAOMDFE
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica o status na SEFAZ                                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lOk
					oWS:= WSNFeSBRA():New()
					oWS:cUSERTOKEN := "TOTVS"
					oWS:cID_ENT    := cIdEnt
					oWS:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"
					lOk := oWS:MONITORSEFAZMODELO()
					If lOk
						aXML := oWS:oWsMonitorSefazModeloResult:OWSMONITORSTATUSSEFAZMODELO
					
						For nX := 1 To Len(aXML)
							Do Case
							Case aXML[nX]:cModelo == "58"
								cMonitorSEF += "- MDFe"+CRLF
								cMonitorSEF += "Versao do layout: "+cVersaoMdf+CRLF	//
								If !Empty(aXML[nX]:cSugestao)
									cSugestao += "Sugestão"+"(MDFe)"+": "+aXML[nX]:cSugestao+CRLF //
								EndIf
							
								cMonitorSEF += Space(6)+"Versão da mensagem"+": "+aXML[nX]:cVersaoMensagem+CRLF //
								cMonitorSEF += Space(6)+"Código do Status"+": "+aXML[nX]:cStatusCodigo+"-"+aXML[nX]:cStatusMensagem+CRLF //
								cMonitorSEF += Space(6)+"UF Origem"+": "+aXML[nX]:cUFOrigem //
								If !Empty(aXML[nX]:cUFResposta)
									cMonitorSEF += "("+aXML[nX]:cUFResposta+")"+CRLF //"UF Resposta"
								Else
									cMonitorSEF += CRLF
								EndIf
								If aXML[nX]:nTempoMedioSEF <> Nil
									cMonitorSEF += Space(6)+"Tempo de espera"+": "+Str(aXML[nX]:nTempoMedioSEF,6)+CRLF //
								EndIf
								If !Empty(aXML[nX]:cMotivo)
									cMonitorSEF += Space(6)+"Motivo"+": "+aXML[nX]:cMotivo+CRLF //
								EndIf
								If !Empty(aXML[nX]:cObservacao)
									cMonitorSEF += Space(6)+"Observação"+": "+aXML[nX]:cObservacao+CRLF //
								EndIf
							EndCase
						Next nX
					
					EndIf
				EndIf
			EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem da Interface                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (lOk == .T. .or. lOk == Nil)
				aadd(aTexto,{})
				If lUsaColab
					aTexto[1] := "Esta rotina tem como objetivo auxilia-lo na geração do arquivo do Manifesto Eletrônico de Documentos Fiscais para transmissão via TOTVS Colaboração." 		//
					aTexto[1] += "Neste momento o sistema, está operando com a seguinte configuração: "+CRLF+CRLF //
				Else
					aTexto[1] := "Esta rotina tem como objetivo auxilia-lo na transmissão do Manifesto Eletrônico de Documentos Fiscais para o serviço TSS " 		//
					aTexto[1] += "Neste momento o Totvs Services SPED, está operando com a seguinte configuração: "+CRLF+CRLF //
				EndIf
			
				aTexto[1] += "Ambiente: "+cAmbiente+CRLF //
				aTexto[1] += "Modalidade de emissão: "+cModalidade+CRLF	//
				If !Empty(cSugestao)
					aTexto[1] += CRLF
					aTexto[1] += cSugestao
					aTexto[1] += CRLF
				EndIf
				aTexto[1] += cMonitorSEF
			
				aadd(aTexto,{})
		
				DEFINE WIZARD oWizard	 ;
					TITLE "Assistente de transmissão do Manifesto Eletrônico de Documentos Fiscais"; //
				HEADER "Atenção";//
				MESSAGE "Siga atentamente os passos para a configuração do Manifesto Eletrônico de Documentos Fiscais";//
				TEXT aTexto[1];
					NEXT {|| .T.};
					FINISH {||.T.}
		
				CREATE PANEL oWizard	;
					HEADER "Assistente de transmissão do Manifesto Eletrônico de Documentos Fiscais"	 ;//
				MESSAGE "" ;
					BACK {|| .T.} ;
					NEXT {|| ParamSave(cParMFFeRe,aPerg,"1"),Processa({|lEnd| cRetorno := ManiRemes(aArea[1],aParam[1],aParam[2],aParam[3],cIdEnt,SubStr(cAmbiente,1,1),SubStr(cModalidade,1,1),cVersaoMdf,cURL,@lEnd)}),aTexto[02]:= cRetorno,.T.};
					PANEL
				ParamBox(aPerg,"MDF-e",@aParam,,,,,,oWizard:oMPanel[2],cParMFFeRe,.T.,.T.)
		
				CREATE PANEL oWizard  ;
					HEADER "Assistente de transmissão do Manifesto Eletrônico de Documentos Fiscais";//
				MESSAGE "";
					BACK {|| .T.};
					FINISH {|| .T.};
					PANEL
				@ 010,010 GET aTexto[2] MEMO SIZE 270, 115 READONLY PIXEL OF oWizard:oMPanel[3]
				ACTIVATE WIZARD oWizard CENTERED
			EndIf
			lRetorno := lOk
		                
		//Recarrega a list
			ReloadListDocs()
		Else
			lRetorno := .F.
		EndIf
	Else
		Aviso("MDF-e","Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!",{"Ok"},3) //
	EndIf

	RestArea(aArea)
Return

//----------------------------------------------------------------------
/*/ MDFeRemes 

Regras para chamada do método remessa

@author Natalia Sartori
@since 24.02.2014
@version P11 
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function ManiRemes(cAlias,cSerie,cNotaIni,cNotaFim,cIDEnt,cAmbiente,cModalidade,cVersao,cURL,lEnd)

	Local aArea				:= GetArea()
	Local aNotas			:= {}
	Local aXML				:= {}
	Local aRetNotas			:= {}
	Local aNFeCol				:= {}

	Local cAliasCC0			:= "CC0"
	Local cQuery			:= ""
	Local cHoraIni			:= Time()
//Local cTipo			:= "" //Tipo do XML a ser montado (1-MDFe/2-Cancelamento/3-Encerramento
	Local cXml				:= ""
	Local cErro				:= ""
	local cAviso			:= ""
	Local cDV				:= ""
	Local cMDF				:= ""
	Local cTpEmis			:= ""
	Local cChave			:= ""
	Local cCodMod			:= ""
	Local cSerieMDF		:= ""
	Local cNumero			:= ""

	Local nX				:= 0
	Local nY				:= 0
	Local nNFes				:= 0
	Local nXmlSize			:= 0
	Local nXmlSize2			:= 0

	Local lErpHverao		:= GetNewPar("MV_HVERAO",.F.)   		  // Verifica se o local fisico do servidor está em Horário de Verão  .F. Não / .T. Sim
	Local cTimeRem			:= FwTimeUF(Upper(Left(LTrim(SM0->M0_ESTENT),2)),,lErpHVerao)[2]

	Local dDataIni			:= Date()

	Local lRetorno			:= .T.
	Local lUsaColab	 := UsaColaboracao("5")

	Private oXmlRem

	If cModalidade == '1'
		cTpEmis := '1'
	ElseIf cModalidade == '2'
		cTpEmis := '2'
	EndIf

	dbSelectArea("CC0")
	CC0->(dbSetOrder(1))

	#IFDEF TOP
		lQuery    	:= .T.
		cAliasCC0	:= GetNextAlias()
	
		cQuery := " SELECT CC0_FILIAL, CC0_SERMDF, CC0_NUMMDF, CC0_STATUS, CC0_DTEMIS "
		cQuery += " FROM " + RetSqlName('CC0') + " CC0 "
		cQuery += " WHERE CC0_FILIAL = '" + xFilial('CC0') + "' AND "
		cQuery += " CC0_SERMDF = '" + Alltrim(cSerie) + "' AND "
		cQuery += " CC0_NUMMDF >= '" + cNotaIni + "' AND "
		cQuery += " CC0_NUMMDF <= '" + cNotaFim + "' AND "
		cQuery += " CC0_STATUS <> '3' AND"
		cQuery += " CC0_STATUS <> '5' AND"
		cQuery += " CC0_STATUS <> '6' AND"
		cQuery += " D_E_L_E_T_ = ''"
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAliasCC0, .F., .T.)
	
		While !Eof() .And. xFilial("CC0") == (cAliasCC0)->CC0_FILIAL .And.;
				alltrim((cAliasCC0)->CC0_SERMDF) == Alltrim(cSerie) .And.;
				(cAliasCC0)->CC0_NUMMDF >= cNotaIni .And.;
				(cAliasCC0)->CC0_NUMMDF <= cNotaFim
		
			IncProc("(1/2) "+"Preparando MDFe: "+(cAliasCC0)->CC0_NUMMDF) //
		    
			aadd(aNotas,{})
			nX := Len(aNotas)
			aadd(aNotas[nX],(cAliasCC0)->CC0_FILIAL)
			aadd(aNotas[nX],(cAliasCC0)->CC0_SERMDF)
			aadd(aNotas[nX],(cAliasCC0)->CC0_NUMMDF)
			aadd(aNotas[nX],(cAliasCC0)->CC0_DTEMIS)
		
			If CC0->(dbSeek( xFilial("CC0") + (cAliasCC0)->CC0_SERMDF + (cAliasCC0)->CC0_NUMMDF))
				aadd(aNotas[nX],(CC0->CC0_XMLMDF))
			EndIf
		
			(cAliasCC0)->(DbSkip())
		EndDo
		(cAliasCC0)->(DbCloseArea())
	
	#ELSE
		CC0->(dbGoTop())
	
		MsSeek(xFilial("CC0")+cSerie+cNotaIni,.T.)
	
		While !Eof() .And. xFilial("CC0") == CC0->CC0_FILIAL .And.;
				alltrim(CC0->CC0_SERMDF) == Alltrim(cSerie) .And.;
				CC0->CC0_NUMMDF >= cNotaIni .And.;
				CC0->CC0_NUMMDF <= cNotaFim .And.;
				CC0->CC0_STATUS <> '3' .And. ;
				CC0->CC0_STATUS <> '5' .And. ;
				CC0->CC0_STATUS <> '6'
		
			IncProc("(1/2) "+"Preparando MDFe: "+ CC0->CC0_NUMMDF) //
		    
			aadd(aNotas,{})
			nX := Len(aNotas)
			aadd(aNotas[nX],CC0->CC0_FILIAL)
			aadd(aNotas[nX],CC0->CC0_SERMDF)
			aadd(aNotas[nX],CC0->CC0_NUMMDF)
			aadd(aNotas[nX],CC0->CC0_DTEMIS)
			aadd(aNotas[nX],CC0->CC0_XMLMDF)
		
			CC0->(DbSkip())
		EndDo
	
	#ENDIF

	ProcRegua(Len(aNotas))

	If lUsaColab
		oDoc := ColaboracaoDocumentos():new()
		oDoc:cModelo 	:= "MDF"
		oDoc:cTipoMov	:= "1"
	Else
		oWs:= WsNFeSBra():New()
		oWs:cUserToken	:= "TOTVS"
		oWs:cID_ENT		:= cIdEnt
		oWS:_URL			:= AllTrim(cURL)+"/NFeSBRA.apw"
		oWs:oWsNFe:oWSNOTAS	:=  NFeSBRA_ARRAYOFNFeS():New()
	EndIf
	
	For nX := 1 To Len(aNotas)

		cXml := aNotas[nX][5] //Pega xml da tabela para realizar alterações antes do envio
		oXmlRem := XmlParser(cXml,"_",@cErro,@cAviso)
	
		If Type("oXmlRem:_MDFE:_INFMDFE")<>"U"
			
			cDV := cTpEmis + Inverte(StrZero( val(aNotas[nX][03]),8))
			cMDF := Inverte(StrZero( val(aNotas[nX][03]),8))
	
			cChave := MDFeChave( oXmlRem:_MDFE:_INFMDFE:_IDE:_CUF:TEXT,;
				FsDateConv(StoD(aNotas[nX][04]),"YYMM"),AllTrim(SM0->M0_CGC),'58',;
				StrZero(Val(aNotas[nX][02]),3),;
				StrZero(Val(aNotas[nX][03]),9),;
				cDV)

			oXmlRem:_MDFE:_INFMDFE:_ID:TEXT := "MDFe"+cChave
			oXmlRem:_MDFE:_INFMDFE:_VERSAO:TEXT := + cVersao
			oXmlRem:_MDFE:_INFMDFE:_IDE:_TPAMB:TEXT := cAmbiente
			oXmlRem:_MDFE:_INFMDFE:_IDE:_CDV:TEXT := SubStr( AllTrim(cChave), Len( AllTrim(cChave) ), 1)
			oXmlRem:_MDFE:_INFMDFE:_IDE:_TPEMIS:TEXT := cTpEmis
			oXmlRem:_MDFE:_INFMDFE:_IDE:_DHEMI:TEXT := SubStr(oXmlRem:_MDFE:_INFMDFE:_IDE:_DHEMI:TEXT,1,11)+cTimeRem
			oXmlRem:_MDFE:_INFMDFE:_INFMODAL:_VERSAOMODAL:TEXT := + cVersao
	
			cCodMod := (oXmlRem:_MDFE:_INFMDFE:_IDE:_MOD:TEXT)
		
			If CC0->(dbSeek( xFilial("CC0") + aNotas[nX][02] + aNotas[nX][03]))
				RecLock("CC0")
				CC0->CC0_XMLMDF:= XMLSaveStr(oXmlRem)
				CC0->(MsUnlock())
			EndIf
							
			aXML:= XMLSaveStr(oXmlRem)
		
		EndIf
	
		nXmlSize2 := Len(aXML)
	   	
		If !Empty(aXML) .And. nXmlSize2 <= TAMMAXXML
			If nXmlSize + Len(aXML) <= TAMMAXXML
				nY++
				nNFes++
				nXmlSize += Len(aXML)
			
				If lUsaColab
			
					cSerieMDF		:= aNotas[nX][2]
					cNumero 	:= aNotas[nX][3]
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Adicionando no aNFe para manter o padrao das funcoes SpedCCeXml e ColEnvEvento³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aNFeCol := {}
					aAdd(aNFeCol,"" ) 			//01 - em branco
					aAdd(aNFeCol,cSerieMDF) 		//02 - Serie
					aAdd(aNFeCol,cNumero) 		//03 - Numero
					aAdd(aNFeCol,"")			 	//04 - em branco
					aAdd(aNFeCol,"")			 	//05 - em branco
					
					lRetorno := XmlMDFTrans( aNFeCol, aXML, cCodMod, @cErro, "110110" )
				
				Else
					aadd(oWs:oWsNFe:oWSNOTAS:oWSNFeS,NFeSBRA_NFeS():New())
			
					aadd(aRetNotas,aNotas[nX])
			
					oWs:oWsNFe:oWSNOTAS:oWsNFes[nY]:cID := aNotas[nX][2]+aNotas[nX][3]    //Serie + Numero
					oWs:oWsNFe:oWSNOTAS:oWsNFes[nY]:cXML:= aXML
				EndIf
			Else
				If lUsaColab
					lRetorno := XmlRemMDF( aNotas, aXML, oXmlRem, @cErro )
				Else
					lRetorno := RemessaMDF(@oWs,@cErro,@aRetNotas,@nY,@nXmlSize,cIdEnt,cURL)
					If !lRetorno
						Exit
					EndIf
					nX -- //- Diminui o contador para que seja pego a nota corrente
					Loop
				EndIf
			EndIF
		ElseIf !Empty(aXML) .And. nXmlSize2 > TAMMAXXML
			Aviso("MDF-e","Foram transmitidas"+CRLF+CRLF+" "+aNotas[nX][2]+" / "+aNotas[nX][3],{"OK"},3)
			nXmlSize2 := 0
		EndIf
		If ((nY >=50 .Or. nX == Len(aNotas) .Or. nXmlSize>=TAMMAXXML) .And. nNFes > 0) .And. !lUsaColab
			lRetorno:= RemessaMDF(@oWs,@cErro,@aRetNotas,@nY,@nXmlSize,cIdEnt,cURL)
		EndIf
	Next nX

	If lRetorno
		If lUsaColab
			cRetorno := "Você concluíu com sucesso a geração do arquivo para transmissão via TOTVS Colaboração."+CRLF 		//
			cRetorno += "Verifique se os arquivos foram processados e autorizados na SEFAZ via TOTVS Colaboração, utilizando a rotina 'Monitor'. Antes de imprimir o DAMDFE."+CRLF+CRLF 	//
		Else
			cRetorno := "Você concluíu com sucesso a transmissão do Protheus para o Totvs Services SPED."+CRLF //
			cRetorno += "Verifique se os Manifestos foram autorizadas na SEFAZ, utilizando a rotina 'Monitorar'. Antes de imprimir o DAMDFE."+CRLF+CRLF //
		EndIf
		cRetorno += "Foram transmitidos "+AllTrim(Str(nNFes,18))+" manifestos em"+IntToHora(SubtHoras(dDataIni,cHoraIni,Date(),Time()))+CRLF+CRLF //###
		cRetorno += cErro
	Else
		If lUsaColab
			cRetorno := "Houve um erro durante a geração do arquivo para transmissão via TOTVS Colaboração."+CRLF+CRLF //
		Else
			cRetorno := "Houve erro durante a transmissão para o Totvs Services SPED."+CRLF+CRLF //
		EndIf
		cRetorno += cErro
	EndIf
		
	RestArea(aArea)

Return (cRetorno)

//----------------------------------------------------------------------
/*/ RemessaMDF 

Envio da remessa ao TSS

@author Natalia Sartori
@since 24.02.2014
@version P11 
@Return	lRet
/*/
//-----------------------------------------------------------------------
Static Function RemessaMDF(oWs,cErro,aRetNotas,nTotNf,nXmlSize,cIdEnt,cURL)

	Local nY
	Local lRetorno := .T.

	If nXmlSize>0 .And. oWs:Remessa()
		If Len(oWs:oWsRemessaResult:oWSID:cString) <> nTotNF
			cErro := "Os Manifestos abaixo foram recusados, verifique a rotina 'Monitor' para saber os motivos."+CRLF+CRLF //
		EndIf
		For nY := 1 To Len(aRetNotas)
			If Len(oWs:oWsRemessaResult:oWSID:cString) <> nY
				If aScan(oWs:oWsRemessaResult:oWSID:cString,aRetNotas[nY][2]+aRetNotas[nY][3])==0
					cErro += "MDFe: "+aRetNotas[nY][2]+aRetNotas[nY][3]+CRLF
				EndIf
			EndIf
			dbSelectArea("CC0")
			dbSetOrder(1)
			If MsSeek(xFilial("CC0")+aRetNotas[nY][2]+aRetNotas[nY][3]) .And. CC0->CC0_STATUS $ "2,4" //2- Não Transmitidos - 4-Não Autorizados
				RecLock("CC0")
				CC0->CC0_STATUS := IIF(aScan(oWs:oWsRemessaResult:oWSID:cString,aRetNotas[nY][2]+AllTrim(aRetNotas[nY][3]))==0,"4","1") //4-Não Autorizados - 1-Transmitidos
				MsUnlock()
			EndIf
		Next nY
	
	
		oWs:= WsNFeSBra():New()
		oWs:cUserToken := "TOTVS"
		oWs:cID_ENT    := cIdEnt
		oWS:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"
		oWs:oWsNFe:oWSNOTAS :=  NFeSBRA_ARRAYOFNFeS():New()
		nTotNF := 0
		nXmlSize := 0
		aRetNotas := {}
	Else
		cErro := GetWscError(3)
		DEFAULT cErro := "Erro indeterminado" //
		lRetorno := .F.
	EndIf

Return lRetorno


//----------------------------------------------------------------------
/*/ GetlabelTSS 
Obtem a versão do TSS

@author Natalia Sartori
@since 25.02.2014
@version P11 
@Return	cVersaoTSS - Versão do TSS
/*/
//-----------------------------------------------------------------------
Static Function GetlabelTSS ()

	Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cVersaoTSS	:= ""

	Local lOK	:= .F.
	Local lUsaColab := UsaColaboracao("5")

	if !lUsaColab

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Obtem a versao do TSS - Totvs Services SPED                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oWS := WsSpedCfgNFe():New()
		oWS:cUSERTOKEN := "TOTVS"
		oWS:cID_ENT    := cIdEnt
		oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
		lOk := oWs:CfgTSSVersao()
		If lOk
			cVersaoTSS:=oWs:cCfgTSSVersaoResult
		EndIf
	endif

Return cVersaoTSS


//----------------------------------------------------------------------
/*/ MDFeChave 

Função responsável em montar a Chave de Acesso e calcular 
o seu digito verIficador

@Natalia Sartori
@since 25.02.2014
@version 1.00

@param      	cUF...: Codigo da UF
				cAAMM.: Ano (2 Digitos) + Mes da Emissao do MDFe
				cCNPJ.: CNPJ do Emitente do MDFe
				cMod..: Modelo (58 = MDFe)
				cSerie: Serie do MDFe
				nCT...: Numero do MDFe
				cDV...: Numero do Lote de Envio a SEFAZ
@Return	cString
/*/
//-----------------------------------------------------------------------
Static Function MDFeChave(cUF, cAAMM, cCNPJ, cMod, cSerie, nMDF, cDV)

	Local nCount      := 0
	Local nSequenc    := 2
	Local nPonderacao := 0
	Local cResult     := ''
	Local cChvAcesso  := cUF +  cAAMM + cCNPJ + cMod + cSerie + nMDF + cDV

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³SEQUENCIA DE MULTIPLICADORES (nSequenc), SEGUE A SEGUINTE        ³
//³ORDENACAO NA SEQUENCIA: 2,3,4,5,6,7,8,9,2,3,4... E PRECISA SER   ³
//³GERADO DA DIREITA PARA ESQUERDA, SEGUINDO OS CARACTERES          ³
//³EXISTENTES NA CHAVE DE ACESSO INFORMADA (cChvAcesso)             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nCount := Len( AllTrim(cChvAcesso) ) To 1 Step -1
		nPonderacao += ( Val( SubStr( AllTrim(cChvAcesso), nCount, 1) ) * nSequenc )
		nSequenc += 1
		If (nSequenc == 10)
			nSequenc := 2
		EndIf
	Next nCount

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quando o resto da divisão for 0 (zero) ou 1 (um), o DV devera   ³
//³ ser igual a 0 (zero).                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( mod(nPonderacao,11) > 1)
		cResult := (cChvAcesso + cValToChar( (11 - mod(nPonderacao,11) ) ) )
	Else
		cResult := (cChvAcesso + '0')
	EndIf

Return(cResult)


Static Function Inverte(uCpo, nDig)

	Local cRet		:= ""

	Default nDig	:= 8

	cRet	:=	GCifra(Val(uCpo),nDig)

Return(cRet)

//-----------------------------------------------------------------------
/*/ MDFeMonit
Monitoramento do MDFe

@author Natalia Sartori
@since 10/02/2014
@version P11
/*/
//-----------------------------------------------------------------------
Static Function MDFeMonit(cSerie,cNotaIni,cNotaFim,lMDFe,cModel)

	Local cIdEnt   := ""
	local cUrl		:= Padr( GetNewPar("MV_SPEDURL",""), 250 )
	Local cMonMdfe	:= ""
	Local aPerg    := {}
	Local aParam   := {Space(Len(CC0->CC0_SERMDF)),Space(Len(CC0->CC0_NUMMDF)),Space(Len(CC0->CC0_NUMMDF))}
	Local aSize    := {}
	Local aObjects := {}
	Local aList := {}
	Local aInfo    := {}
	Local aPosObj  := {}
	Local oWS
	Local oDlg
	Local oListBox
	Local oBtn1
	Local oBtn2
	Local oBtn3
	Local oBtn4
	Local cParNfeRem := SM0->M0_CODIGO+SM0->M0_CODFIL+"MONMDFE"
	Local lOK        := .F.
	Local lUsaColab  := UsaColaboracao("5")
	Local bBloco

	Default cSerie   := ''
	Default cNotaIni := ''
	Default cNotaFim := ''
	Default lMDFe    := .T.
	Default cModel	 := ""

	aadd(aPerg,{1,"Serie do MDFe",aParam[01],"",".T.","",".T.",30,.F.})	//
	aadd(aPerg,{1,"MDFe inicial",aParam[02],"",".T.","",".T.",30,.T.})	//
	aadd(aPerg,{1,"MDFe final",aParam[03],"",".T.","",".T.",30,.T.})	//

	aParam[01] := ParamLoad(cParNfeRem,aPerg,1,aParam[01])
	aParam[02] := ParamLoad(cParNfeRem,aPerg,2,aParam[02])
	aParam[03] := ParamLoad(cParNfeRem,aPerg,3,aParam[03])

	If CTIsReady(,,,lUsaColab)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Obtem o codigo da entidade                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		cIdEnt := RetIdEnti(lUsaColab)
		If !Empty(cIdEnt)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Instancia a classe                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(cIdEnt)
				If (lMDFe) .And. !Empty(cSerie) .And. !Empty(cNotaIni) .And. !Empty(cNotaFim)
					aParam[01] := cSerie
					aParam[02] := cNotaIni
					aParam[03] := cNotaFim
					lOK        := .T.
				Else
					lOK      := ParamBox(aPerg,"MDF-e",@aParam,,,,,,,cParNfeRem,.T.,.T.)
					cSerie   := aParam[01]
					cNotaIni := aParam[02]
					cNotaFim :=	aParam[03]
				EndIf
			
				If (lOK)
				
					if lUsaColab
						cMonMdfe := "ColMdfMon"
						bBloco := "{|| " + cMonMdfe + "(cSerie,cNotaIni,cNotaFim,.T.) }"
					else
						cMonMdfe := "MDFeWSMnt"
						bBloco := "{|| " + cMonMdfe + "(cIdEnt,cSerie,cNotaIni,cNotaFim,.T.) }"
					endif

					aList:= Eval(&bBloco)
				
					If !Empty(aList)
					//Atualiza os dados da CC0 com o monitor
						UpdCC0(aList)
					
						aSize := MsAdvSize()
						aObjects := {}
						AAdd( aObjects, { 100, 100, .t., .t. } )
						AAdd( aObjects, { 100, 015, .t., .f. } )
				
						aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
						aPosObj := MsObjSize( aInfo, aObjects )
											
						DEFINE MSDIALOG oDlg TITLE "MDF-e" From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL
					
						@ aPosObj[1,1],aPosObj[1,2] LISTBOX oListBox Fields HEADER "","NF","Ambiente","Modalidade","Protocolo","Recomendação","Tempo decorrido","Tempo SEF"; //##################
						SIZE aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1] PIXEL
						oListBox:SetArray( aList )
						oListBox:bLine := { || { aList[ oListBox:nAT,1 ],aList[ oListBox:nAT,2 ],aList[ oListBox:nAT,3 ],aList[ oListBox:nAT,4 ],aList[ oListBox:nAT,5 ],aList[ oListBox:nAT,6 ],aList[ oListBox:nAT,7 ],aList[ oListBox:nAT,8 ]} }
					
					
						@ aPosObj[2,1],aPosObj[2,4]-040 BUTTON oBtn1 PROMPT "OK"   		ACTION oDlg:End() OF oDlg PIXEL SIZE 035,011 //
						@ aPosObj[2,1],aPosObj[2,4]-080 BUTTON oBtn2 PROMPT "Mensagens"   		ACTION (Bt2NFeMnt(aList[oListBox:nAT][09])) OF oDlg PIXEL SIZE 035,011 //
						@ aPosObj[2,1],aPosObj[2,4]-120 BUTTON oBtn3 PROMPT "Rec.XML"   		ACTION (Bt3NFeMnt(cIdEnt,aList[ oListBox:nAT,2 ],,lUsaColab)) OF oDlg PIXEL SIZE 035,011 //
						@ aPosObj[2,1],aPosObj[2,4]-160 BUTTON oBtn4 PROMPT "Refresh" 		ACTION (aList:= Eval(&bBloco),oListBox:nAt := 1,IIF(Empty(aList),oDlg:End(),oListBox:Refresh())) OF oDlg PIXEL SIZE 035,011 //
						@ aPosObj[2,1],aPosObj[2,4]-200 BUTTON oBtn4 PROMPT "Schema" 		ACTION (Bt3NFeMnt(cIdEnt,aList[ oListBox:nAT,2 ],2,lUsaColab)) OF oDlg PIXEL SIZE 035,011 //
						ACTIVATE MSDIALOG oDlg
					
					//Apos sair, atualiza novamente os dados na CC0, pois pode ter clicado em REFRESH
						aList:= Eval(&bBloco)
						UpdCC0(aList)
					
					//Atualiza o grid da tela "Gerenciar MDFe"
						ReloadListDocs()
					Else
						MsgStop('Nenhum documento localizado no intervalo informado')
					EndIf
				EndIf
			EndIf
		Else
			Aviso("MDF-e","Execute o módulo de configuração do serviço, antes de utilizar esta opção",{"OK"},3)
		EndIf
	Else
		Aviso("MDF-e","Execute o módulo de configuração do serviço, antes de utilizar esta opção",{"OK"},3)
	EndIf

Return

//-----------------------------------------------------------------------
/*/ Bt3NFeMnt
Função que faz validação de schema do XML da NFe.

@author Henrique Brugugnoli
@since 26/01/2011
@version 1.0 

@param	cIdEnt	Codigo da entidade
		cIdNFe	Id da NFe que será feito a validação de schema
 
@return	.T.
/*/
//-----------------------------------------------------------------------
Static Function Bt3NFeMnt(cIdEnt,cIdNFe,nTipo,lUsaColab)

	Local cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cMsg     := ""

	Local oWS
	Local oDoc := Nil

	DEFAULT nTipo  := 1
	DEFAULT lUsaColab := .F.

	if !lUsaColab
		oWS:= WSNFeSBRA():New()
		oWS:cUSERTOKEN        := "TOTVS"
		oWS:cID_ENT           := cIdEnt
		oWS:oWSNFEID          := NFESBRA_NFES2():New()
		oWS:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
		aadd(oWS:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
		Atail(oWS:oWSNFEID:oWSNotas:oWSNFESID2):cID := cIdNfe
		oWS:nDIASPARAEXCLUSAO := 0
		oWS:_URL          := AllTrim(cURL)+"/NFeSBRA.apw"
	
	
		If oWS:RETORNANOTAS()
			If Len(oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3) > 0
				If nTipo == 1
					Do Case
					Case oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA <> Nil
						Aviso("MDF-e",oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA:cXML,{"ok"},3)
					OtherWise
						Aviso("MDF-e",oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXML,{"OK"},3)
					EndCase
				Else
					cMsg := AllTrim(oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXML)
				
					If !Empty(cMsg)
						Aviso("MDF-e",@cMsg,{"OK"},3,/*cCaption2*/,/*nRotAutDefault*/,/*cBitmap*/,.T.)
						oWS:= WSNFeSBRA():New()
						oWS:cUSERTOKEN     := "TOTVS"
						oWS:cID_ENT        := cIdEnt
						oWs:oWsNFe:oWSNOTAS:=  NFeSBRA_ARRAYOFNFeS():New()
						aadd(oWs:oWsNFe:oWSNOTAS:oWSNFeS,NFeSBRA_NFeS():New())
						oWs:oWsNFe:oWSNOTAS:oWsNFes[1]:cID := cIdNfe
						oWs:oWsNFe:oWSNOTAS:oWsNFes[1]:cXML:= EncodeUtf8(cMsg)
						oWS:_URL          := AllTrim(cURL)+"/NFeSBRA.apw"
					
						If oWS:Schema()
							If Empty(oWS:oWSSCHEMARESULT:oWSNFES4[1]:cMENSAGEM)
								Aviso("MDF-e"," " ,{"OK"})
							Else
								If ( MsgYesNo("Schema com erro. Deseja visualizar as possibilidades que podem ter causado o erro?") ) //
									ViewSchemaMsg( oWS:oWSSCHEMARESULT:oWSNFES4[1]:oWsSchemaMsg:oWsSchemaError )
								Else
									Aviso("MDF-e",IIF(Empty(oWS:oWSSCHEMARESULT:oWSNFES4[1]:cMENSAGEM)," " ,oWS:oWSSCHEMARESULT:oWSNFES4[1]:cMENSAGEM),{"OK"},3)
								EndIf
							EndIf
						Else
							Aviso("MDF-e",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
						EndIf
					EndIf
				EndIf
			EndIf
		Else
			Aviso("MDF-e",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
		EndIf
	else
		oDoc 			:= ColaboracaoDocumentos():new()
		oDoc:cModelo	:= "MDF"
		oDoc:cTipoMov	:= "1"
		oDoc:cIDERP	:= "MDF"+cIdNFe + FwGrpCompany()+FwCodFil()
	
		if odoc:consultar()
			If nTipo == 1
				if !Empty(oDoc:cXmlRet)
					Aviso("SPED",DecodeUtf8(oDoc:cXmlRet),{"OK"},3)
				else
					Aviso("SPED",oDoc:cXml,{"OK"},3)
				endif
		
			else
				Aviso("SPED","Validação de Schema indisponível para TOTVS Colaboração - 2.0",{"OK"},3)
			endif
		else
			Aviso("SPED",oDoc:cCodErr+" - "+oDoc:cMsgErr,{"OK"},3)
		endif
		oDoc := Nil
		DelClassIntF()
	
	endif
Return .T.

Static Function Bt2NFeMnt(aMsg)

	Local aSize    := MsAdvSize()
	Local aObjects := {}
	Local aInfo    := {}
	Local aPosObj  := {}
	Local oDlg
	Local oListBox
	Local oBtn1

	If !Empty(aMsg)
		AAdd( aObjects, { 100, 100, .t., .t. } )
		AAdd( aObjects, { 100, 015, .t., .f. } )
		aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
		aPosObj := MsObjSize( aInfo, aObjects )
	
		DEFINE MSDIALOG oDlg TITLE "MDF-e" From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL
		@ aPosObj[1,1],aPosObj[1,2] LISTBOX oListBox Fields HEADER "Lote","Dt.Lote","Hr.Lote","Recibo SEF","Cod.Env.Lote","Msg.Env.Lote","Cod.Ret.Lote","Msg.Ret.Lote","Cod.Ret.NFe","Msg.Ret.NFe"; //
		SIZE aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1] PIXEL
		oListBox:SetArray( aMsg )
		oListBox:bLine := { || { aMsg[ oListBox:nAT,1 ],aMsg[ oListBox:nAT,2 ],aMsg[ oListBox:nAT,3 ],aMsg[ oListBox:nAT,4 ],aMsg[ oListBox:nAT,5 ],aMsg[ oListBox:nAT,6 ],aMsg[ oListBox:nAT,7 ],aMsg[ oListBox:nAT,8 ],aMsg[ oListBox:nAT,9 ],aMsg[ oListBox:nAT,10 ]} }
		@ aPosObj[2,1],aPosObj[2,4]-030 BUTTON oBtn1 PROMPT "OK"         ACTION oDlg:End() OF oDlg PIXEL SIZE 028,011
		ACTIVATE MSDIALOG oDlg
	EndIf
Return(.T.)


//-----------------------------------------------------------------------
/*/ ViewSchemaMsg
Função que monta tela com tratamento de erro de schema.

@author Henrique Brugugnoli
@since 25/07/2011
@version 1.0 

@param	aMessages	Array com as mensagens					
/*/
//-----------------------------------------------------------------------
Static Function ViewSchemaMsg( aMessages )

	Local cTag			:= ""
	Local cDesc			:= ""
	Local cHierarquia   := ""
	Local cDica			:= ""
	Local cErro			:= ""

	Local oTree

	Local lIsSame	:= .F.

	Local nX

	DEFINE MSDIALOG oDlg TITLE "Mensagens de Schema X Possibilidades" FROM 0,0 TO 300,500 PIXEL  //

	@ 000, 000 MSPANEL oPanelLeft OF oDlg SIZE 085, 000
	oPanelLeft:Align := CONTROL_ALIGN_LEFT

	@ 000, 000 MSPANEL oPanelRight OF oDlg SIZE 000, 000
	oPanelRight:Align := CONTROL_ALIGN_ALLCLIENT

	oTree := xTree():New(000,000,000,000,oPanelLeft,,,)
	oTree:Align := CONTROL_ALIGN_ALLCLIENT

	oTree:AddTree("Mensagens",,,"PARENT",,,) //

	For nX := 1 to len(aMessages)

		cCargo := aMessages[nX]:cTag
	
		oMessage := aMessages[nX]

		If ( oTree:TreeSeek(cCargo) )
			oTree:addTreeItem("Possibilidade","BPMSEDT3.png",cCargo+"|"+AllTrim(Str(nX)),{ || SchemaRefreshTree( @cTag, @cDesc, @cHierarquia, @cDica, @cErro, aMessages, oTree ), oTag:Refresh(), oDesc:Refresh(), oHierarquia:Refresh(), oDica:Refresh(), oErro:Refresh() }) //
		Else
			If ( nX > 1 )
				oTree:EndTree()
			EndIf
		
			oTree:AddTree(cCargo,"f10_verm.png","f10_verm.png",cCargo,,,,,)
			oTree:addTreeItem("Possibilidade","BPMSEDT3.png",cCargo+"|"+AllTrim(Str(nX)),{ || SchemaRefreshTree( @cTag, @cDesc, @cHierarquia, @cDica, @cErro, aMessages, oTree ), oTag:Refresh(), oDesc:Refresh(), oHierarquia:Refresh(), oDica:Refresh(), oErro:Refresh() }) 	//
		EndIf

	Next nX

	oTree:EndTree()

	DEFINE FONT oFont BOLD

	@ 005, 010 SAY oSay PROMPT "Tag:" OF oPanelRight PIXEL FONT oFont SIZE 040, 015 //
	@ 005, 024 SAY oTag PROMPT cTag OF oPanelRight PIXEL SIZE 040, 015

	@ 020, 010 SAY oSay PROMPT "Descrição:" OF oPanelRight PIXEL FONT oFont SIZE 040, 015 //
	@ 020, 042 SAY oDesc PROMPT cDesc OF oPanelRight PIXEL SIZE 110, 015

	@ 035, 010 SAY oSay PROMPT "Hierarquia:" OF oPanelRight PIXEL FONT oFont SIZE 040, 015   //
	@ 035, 043 SAY oHierarquia PROMPT cHierarquia OF oPanelRight PIXEL SIZE 150, 015

	@ 050, 010 SAY oSay PROMPT "Dica:" OF oPanelRight PIXEL FONT oFont SIZE 040, 015 //
	@ 050, 026 SAY oDica PROMPT cDica OF oPanelRight PIXEL SIZE 150, 015

	@ 065, 010 SAY oSay PROMPT "Erro Técnico:" OF oPanelRight PIXEL FONT oFont SIZE 040, 015 //
	@ 065, 050 SAY oErro PROMPT cErro OF oPanelRight PIXEL SIZE 100, 055

	@ 133, 097 BUTTON oBtn PROMPT "Gerar Log" SIZE 030, 010 ACTION CreateLog( aMessages ) OF oPanelRight PIXEL //
	@ 133, 130 BUTTON oBtn PROMPT "Sair" SIZE 028, 010 ACTION oDlg:end() OF oPanelRight PIXEL //
	
	ACTIVATE MSDIALOG oDlg CENTERED

Return

//-----------------------------------------------------------------------
/*/ SchemaRefreshTree
Função que atualiza as informações da tela de schema.

@author Henrique Brugugnoli
@since 25/07/2011
@version 1.0 

@param	@cTag		 Nome da tag
		@cDesc		 Descrição da tag
		@cHierarquia Pai da tag
		@cDica		 Dica do erro ocorrido
		@cErro		 Erro técnico
		aMessage	 Array com todas as tags e suas mensagens
		oTree		 Objeto com a árvore (XTree) de possibilidades
					
@return .T.					
/*/
//-----------------------------------------------------------------------
Static Function SchemaRefreshTree( cTag, cDesc, cHierarquia, cDica, cErro, aMessage, oTree )

	Local nPos	:= 0

	nPos := Val(Substr(oTree:GetCargo(),At("|",oTree:GetCargo())+1))

	cTag		:= aMessage[nPos]:cTag
	cDesc		:= aMessage[nPos]:cDesc
	cHierarquia	:= aMessage[nPos]:cParent
	cDica		:= aMessage[nPos]:cLog
	cErro		:= aMessage[nPos]:cErro

Return .T.

//-----------------------------------------------------------------------
/*/ CreateLog
Função criará em disco um arquivo xml Log dos erros de schema.

@author Henrique Brugugnoli
@since 26/01/2011
@version 1.0 

@param	aMessage	Array com todas as tags e suas mensagens   

/*/
//-----------------------------------------------------------------------
Static Function CreateLog( aMessage )

	Local cDir		:= cGetFile( "*.xml", " "+" XML", 1, "C:\", .T., nOR( GETF_LOCALHARD, GETF_RETDIRECTORY ),, .T. )
	Local cFile		:= "schemalog_"+DtoS(Date())+StrTran(Time(),":","")+".xml"

	Local nHandle
	Local nX

	If ( !Empty(cDir) )

		nHandle := FCreate(cDir+cFile)
	
		If ( nHandle > 0 )
	
			FWrite(nHandle,"<schemalog>")
	
			For nX := 1 to len(aMessage)
		
				FWrite(nHandle,"<possibilidade item='"+AllTrim(Str(nX))+"'>")
				FWrite(nHandle,"<tag>")
				FWrite(nHandle,aMessage[nX]:cTag)
				FWrite(nHandle,"</tag>")
				FWrite(nHandle,"<descricao>")
				FWrite(nHandle,EncodeUTF8(aMessage[nX]:cDesc))
				FWrite(nHandle,"</descricao>")
				FWrite(nHandle,"<hierarquia>")
				FWrite(nHandle,aMessage[nX]:cParent)
				FWrite(nHandle,"</hierarquia>")
				FWrite(nHandle,"<dica>")
				FWrite(nHandle,EncodeUTF8(aMessage[nX]:cLog))
				FWrite(nHandle,"</dica>")
				FWrite(nHandle,"<erro>")
				FWrite(nHandle,aMessage[nX]:cErro)
				FWrite(nHandle,"</erro>")
				FWrite(nHandle,"</possibilidade>")
			
			Next nX
		
			FWrite(nHandle,"</schemalog>")
			FClose(nHandle)
		
			If ( MsgYesNo( "Arquivo de LOG gerado com sucesso em: " + cDir + cFile + CRLF + "Deseja abrir a pasta onde o arquivo foi gerado?" ) ) // #
				ShellExecute ( "OPEN", cDir, "", cDir, 1 )
			EndIf
	
		Else
			MsgInfo("Não foi possível criar o arquivo.") //
		EndIf

	Else
		MsgInfo("Deve ser informado um diretório para ser salvo o arquivo de LOG.") //
	EndIf

Return

//-----------------------------------------------------------------------
/*/ UpdCC0 
Atualiza as informacoes de Status na CC0 a partir da execucao do metodo 
monitor do TSS

@author Natalia Sartori
@since 27.02.2014
@version P11 
@Return	NIL
/*/
//-----------------------------------------------------------------------
Static Function UpdCC0(aDados)
	Local aArea := CC0->(GetArea())
	//Local cQuery := ""
	Local nI := 1
	Local cSer 	:= ""
	Local cNum	:= ""
	Local aInfo	:= {}
	Local lUsaColab	:= UsaColaboracao("5")
	
	dbSelectArea('CC0')
	CC0->(dbSetOrder(1))
	
	For nI := 1 to len(aDados)
		cSer   := substr(aDados[nI,2],1,3)
		cNum   := substr(aDados[nI,2],4,10)
		aInfo  := aClone(aDados[nI,9])
		If CC0->(dbSeek(xFilial('CC0')+cSer+cNum)) .and. len(aInfo) > 0
			                 
			//Tratar direito!
			RecLock('CC0',.F.)
			If aInfo[len(aInfo),9] == "100" // Autorizado
				CC0->CC0_STATUS :=	AUTORIZADO
				CC0->CC0_PROTOC := IIf( lUsaColab,  alltrim(aDados[nI][5]), alltrim(str(aInfo[len(aInfo),4])) )
				CC0->CC0_MSGRET := aInfo[len(aInfo),10]
				CC0->CC0_CHVMDF := Replace(SpedNFeID(CC0->CC0_XMLMDF,"Id"),"MDFe","")
			
			ElseIf aInfo[len(aInfo),9] == "132"  .Or.  ( aInfo[len(aInfo),9] == "135" .AND. Substr(aDados[nI][6],1,3) == "013" )
				CC0->CC0_STATUS :=	ENCERRADO
				CC0->CC0_STATEV :=	EVEVINCULADO
				CC0->CC0_MSGRET := aInfo[len(aInfo),10]
			
			ElseIf aInfo[len(aInfo),9] == "101" .Or.  ( aInfo[len(aInfo),9] == "135" .AND. Substr(aDados[nI][6],1,3) == "004" )
				CC0->CC0_STATUS :=	CANCELADO
				CC0->CC0_STATEV :=	EVEVINCULADO
				CC0->CC0_MSGRET := aInfo[len(aInfo),10]
				
				//Reset NFe
				DelMDFSF2(CC0->CC0_SERMDF,CC0->CC0_NUMMDF)
			
			ElseIf CC0->CC0_STATEVE == EVEREALIZADO //Evento não vinculado
				CC0->CC0_STATEV := EVENAOVINCULADO
				CC0->CC0_MSGRET := aInfo[len(aInfo),10]
				
			ElseIf CC0->CC0_STATEVE == EVEREALIZADO //Evento não vinculado
				CC0->CC0_STATEV := EVENAOVINCULADO
				CC0->CC0_MSGRET := aInfo[len(aInfo),10]

			ElseIf Empty(CC0->CC0_STATEVE) .Or. CC0->CC0_STATEVE <> EVENAOVINCULADO
				CC0->CC0_STATUS := NAO_AUTORIZADO
				CC0->CC0_MSGRET := aInfo[len(aInfo),10]
				
			//realizado essa alteracao pois estava ficando como Status Doc 'Autorizado' e Status Evento(mensagem) como 'Encerramento nao autorizado' 	
			ElseIf lUsaColab .And.( Empty(CC0->CC0_STATEVE) .Or. CC0->CC0_STATEVE == EVENAOVINCULADO )
				CC0->CC0_STATUS := NAO_AUTORIZADO
				CC0->CC0_MSGRET := aInfo[len(aInfo),10]
					
			EndIf
			CC0->(msUnlock())
		EndIf
	Next nI

	RestArea(aArea)
Return


//-----------------------------------------------------------------------
/*/ SpedDAMDFE 
Rotina de chamada de impressão da DAMDFE.

@author Rafael Iaquinto
@since 27.02.2014
@version P11 
@Return	cVersaoTSS - Versão do TSS
/*/
//-----------------------------------------------------------------------
Static Function SpedDAMDFE()

	Local aIndArq   := {}
	Local oDamdfe
	Local nHRes  := 0
	Local nVRes  := 0
	Local nDevice
	Local cFilePrint := "DAMDFE_"+cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")
	Local oSetup
	Local aDevice  := {}
	Local cSession     := GetPrinterSession()
	Local nRet := 0


	AADD(aDevice,"DISCO") // 1
	AADD(aDevice,"SPOOL") // 2
	AADD(aDevice,"EMAIL") // 3
	AADD(aDevice,"EXCEL") // 4
	AADD(aDevice,"HTML" ) // 5
	AADD(aDevice,"PDF"  ) // 6

                                                                        
	nLocal       	:= If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
//nOrientation 	:= If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
	nOrientation 	:= 2
	cDevice     	:= If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
	nPrintType      := aScan(aDevice,{|x| x == cDevice })

	If CTIsReady(,,,lUsaColab)
		dbSelectArea("SF2")
		RetIndex("SF2")
		dbClearFilter()
	
	
		lAdjustToLegacy := .F. // Inibe legado de resolução com a TMSPrinter
		oDamdfe := FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy, /*cPathInServer*/, .T.)
	
	// ----------------------------------------------
	// Cria e exibe tela de Setup Customizavel
	// OBS: Utilizar include "FWPrintSetup.ch"
	// ----------------------------------------------
	//nFlags := PD_ISTOTVSPRINTER+ PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
		nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN + PD_DISABLEORIENTATION
	
		If FindFunction("u_DAMDFE")
			If ( !oDamdfe:lInJob )
				oSetup := FWPrintSetup():New(nFlags, "DAMDFE")
			// ----------------------------------------------
			// Define saida
			// ----------------------------------------------
				oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
				oSetup:SetPropert(PD_ORIENTATION , nOrientation)
				oSetup:SetPropert(PD_DESTINATION , nLocal)
				oSetup:SetPropert(PD_MARGIN      , {60,60,60,60})
				oSetup:SetPropert(PD_PAPERSIZE   , 2)
	
			EndIf
		
		// ----------------------------------------------
		// Pressionado botão OK na tela de Setup
		// ----------------------------------------------
			If oSetup:Activate() == PD_OK // PD_OK =1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Salva os Parametros no Profile             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
				fwWriteProfString( cSession, "LOCAL"      , If(oSetup:GetProperty(PD_DESTINATION)==1 ,"SERVER"    ,"CLIENT"    ), .T. )
				fwWriteProfString( cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE)==2   ,"SPOOL"     ,"PDF"       ), .T. )
				fwWriteProfString( cSession, "ORIENTATION", If(oSetup:GetProperty(PD_ORIENTATION)==1 ,"PORTRAIT"  ,"LANDSCAPE" ), .T. )
	        //fwWriteProfString( cSession, "ORIENTATION", "LANDSCAPE" , .T. )
			
			// Configura o objeto de impressão com o que foi configurado na interface.
				oDamdfe:setCopies( val( oSetup:cQtdCopia ) )
			
				If oSetup:GetProperty(PD_ORIENTATION) == 1
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Danfe Retrato DANFEII.PRW                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
					u_DAMDFE(cIdEnt,oDamdfe, oSetup, cFilePrint)
				Else // Tratamento futuro com a implementação do DAMDFE paisagem
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Danfe Paisagem DANFEIII.PRW                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					u_DAMDFE(cIdEnt,oDamdfe, oSetup, cFilePrint)
				EndIf
			
			Else
				MsgInfo("Relatório cancelado pelo usuário.")
				Pergunte("DAMDFE",.F.)
				bFiltraBrw := {|| FilBrowse(aFilBrw[1],@aIndArq,@aFilBrw[2])}
				Eval(bFiltraBrw)
				Return
			Endif
			
			Pergunte("DAMDFE",.F.)
			bFiltraBrw := {|| FilBrowse(aFilBrw[1],@aIndArq,@aFilBrw[2])}
			Eval(bFiltraBrw)
		Else
			MsgInfo("RDMAKE DAMDFE não encontrado, relatório não será impresso!")
		EndIf
	EndIf
	oDamdfe := Nil
	oSetup := Nil

Return()

//-----------------------------------------------------------------------
/*/ AjustaSX1 
Ajusta o SX1

@author Rafael Iaquinto
@since 27.02.2014
@version P11 
@Return	NIL
/*/
//-----------------------------------------------------------------------

Static Function AjustaSX1()

	Local aArea     := GetArea()
	Local cNumMDF   := TamSX3("CC0_NUMMDF")[1]
	Local cSerMDF   := TamSX3("CC0_SERMDF")[1]

	Local nCont 	  := 0
	Local aHelpPor1 := {'Serie do Manifesto.'}
	Local aHelpEng1 := {'Serie Manifest. '}
	Local aHelpSpa1 := {'Serie Manifiesto. '}

	Local aHelpPor2 := {'Informe o No. Inicial do Manifesto.'}
	Local aHelpEng2 := {'Enter the Manifest Initial No.'}
	Local aHelpSpa2 := {'Informe el Nº Inicial del Manifiesto. '}

	Local aHelpPor3 := {'Informe o No. Final do Manifesto.'}
	Local aHelpEng3 := {'Enter the Manifest Final No. '}
	Local aHelpSpa3 := {'Informe el Nº Final del Manifiesto. '}


	PutSx1( 	"DAMDFE","01","Serie do Manifesto ?","Serie Manifest ?","Serie Manifiesto ?",;
		"mv_ch1","C",cSerMDF,0,0,"G","","","","S",;
		"mv_par01","","","","","","","",;
		,,,,,,,,,aHelpPor1,aHelpEng1,aHelpSpa1)

	PutSx1( 	"DAMDFE","02","Manifesto De ?","From Manisfest ?","De Manifiesto ?",;
		"mv_ch2","C",cNumMDF,0,0,"G","","","","S",;
		"mv_par02","","","","","","","",;
		,,,,,,,,,aHelpPor2,aHelpEng2,aHelpSpa2)

	PutSx1( 	"DAMDFE","03","Manifesto Ate ?","To Manisfest ?","A Manifiesto ?",;
		"mv_ch3","C",cNumMDF,0,0,"G","","","","S",;
		"mv_par03","","","","","","","",;
		,,,,,,,,,aHelpPor3,aHelpEng3,aHelpSpa3)

	dbSelectArea('SX1')
	SX1->(dbSetOrder(1))
	If SX1->(dbSeek(PADR("DAMDFE",len(SX1->X1_GRUPO))+"01"))
		While !Eof() .And. (SX1->X1_GRUPO == PADR("DAMDFE",len(SX1->X1_GRUPO)))
			nCont ++
			If (dbSeek(PADR("DAMDFE",len(SX1->X1_GRUPO))+"0"+cValtoChar(nCont))) .And. SX1->X1_PYME=="N"
				RecLock('SX1',.F.)
				SX1->X1_PYME := "S"
				SX1->(msUnlock())
			EndIf
			dbSkip()
		EndDo
	EndIf

	RestArea(aArea)
Return Nil


//-----------------------------------------------------------------------
/*/ AjustaSX3  
Ajusta o SX3

@author Microsiga Protheus
@since 22.04.2014
@version P11 
@Return	NIL
/*/
//-----------------------------------------------------------------------
Static Function AjustaSX3()
	dbSelectArea('SX3')
	SX3->(dbSetOrder(2))
	If SX3->(dbSeek("CC0_FILIAL")) .and. SX3->X3_TAMANHO > 2 .and. SX3->X3_TAMANHO <> FWSizeFilial()
		RecLock('SX3',.F.)
		SX3->X3_TAMANHO := FWSizeFilial()
		SX3->(msUnlock())
	EndIf
		
Return

//-----------------------------------------------------------------------
/*/ AjustaSXB
Ajusta o SXB

@author Microsiga Protheus
@since 11.09.2014
@version P11 
@Return	NIL
/*/
//-----------------------------------------------------------------------
Static Function AjustaSXB()
	dbSelectArea('SXB')
	SXB->(dbSetOrder(1))	//XB_ALIAS XB_TIPO XB_SEQ XB_COLUNA XB_DESCRI XB_DESCSPA XB_DESCENG XB_CONTEM
	SXB->(dbSeek("CC2   2"))
	While !SXB->(Eof()) .And. SXB->XB_ALIAS == "CC2   " .And. SXB->XB_TIPO == "2"
		If AllTrim(SXB->XB_DESCRI) == "Estado + Codigo Ibge"
			RecLock('SXB',.F.)
			SXB->XB_DESCRI := "Estado + Municipio"
			SXB->(msUnlock())
		EndIf
		SXB->(DbSkip())
	EndDo
		
Return

//-----------------------------------------------------------------------
/*/ MDFeWSMnt 
Função de chamada do método MonitorFaixa

@author Natalia Sartori
@since 28.02.2014
@version P11 
@Return	NIL
/*/
//-----------------------------------------------------------------------
Static Function MDFeWSMnt(cIdent, cSerie, cMdfMin, cMdfMax, lMonitor)

	Local cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cModelo	:= '58'
	Local lOk		:= .T.
	Local oWS
	Local oRetorno
                           

	Local aListBox	:= {}
	Local aMsg		:= {}
	Local aXML		:= {}

	Local nX		:= 0
	Local nY		:= 0
	Local nLastXml	:= 0

	Local oGreen	:= LoadBitMap(GetResources(), "ENABLE")
	Local oRed		:= LoadBitMap(GetResources(), "DISABLE")

	Default lMonitor := .T.

	Private oXmlMonit

	If CTIsReady()

		oWS:= WSNFeSBRA():New()
		oWS:cUSERTOKEN    := "TOTVS"
		oWS:cID_ENT       := cIdEnt
		oWS:_URL          := AllTrim(cURL)+"/NFeSBRA.apw"
		oWS:cIdInicial    := cSerie + cMdfMin
		oWS:cIdFinal      := cSerie + cMdfMax
		oWS:cModelo       := cModelo
		lOk := oWS:MONITORFAIXA()
		oRetorno := oWS:oWsMonitorFaixaResult
	
		For nX := 1 To Len(oRetorno:oWSMONITORNFE)
	                                                    
			If lMonitor
				aMsg := {}
				oXmlMonit := oRetorno:oWSMONITORNFE[nX]
				If Type("oXmlMonit:OWSERRO:OWSLOTENFE")<>"U"
					nLastRet := Len(oXmlMonit:OWSERRO:OWSLOTENFE)
					For nY := 1 To Len(	oXmlMonit:OWSERRO:OWSLOTENFE)
						If oXmlMonit:OWSERRO:OWSLOTENFE[nY]:NLOTE<>0
							aadd(aMsg,{oXmlMonit:OWSERRO:OWSLOTENFE[nY]:NLOTE,oXmlMonit:OWSERRO:OWSLOTENFE[nY]:DDATALOTE,oXmlMonit:OWSERRO:OWSLOTENFE[nY]:CHORALOTE,;
								oXmlMonit:OWSERRO:OWSLOTENFE[nY]:NRECIBOSEFAZ,;
								oXmlMonit:OWSERRO:OWSLOTENFE[nY]:CCODENVLOTE,PadR(oXmlMonit:OWSERRO:OWSLOTENFE[nY]:CMSGENVLOTE,50),;
								oXmlMonit:OWSERRO:OWSLOTENFE[nY]:CCODRETRECIBO,PadR(oXmlMonit:OWSERRO:OWSLOTENFE[nY]:CMSGRETRECIBO,50),;
								oXmlMonit:OWSERRO:OWSLOTENFE[nY]:CCODRETNFE,PadR(oXmlMonit:OWSERRO:OWSLOTENFE[nY]:CMSGRETNFE,5000)})
						EndIf
					Next nY
				EndIf
			
		
				nY       := Len(oRetorno:OWSMONITORNFE[nX]:OWSERRO:OWSLOTENFE)
		
				aadd(aListBox,{ IIf(Empty(oXmlMonit:cPROTOCOLO),oRed,oGreen),;
					oXmlMonit:cID,;
					IIf(oXmlMonit:nAMBIENTE==1,"ProduþÒo","HomologaþÒo"),; //###
				IIf(oXmlMonit:nMODALIDADE==1,"Normal","ContingÛncia"),; //###
				oXmlMonit:cPROTOCOLO,;
					PadR(oXmlMonit:cRECOMENDACAO,300),;
					oXmlMonit:cTEMPODEESPERA,;
					oXmlMonit:nTEMPOMEDIOSEF,;
					aMsg})
			
				aXml 		:= {}
				nLastXml	:= 0
		
			EndIf

		Next nX
	Else
		Aviso("MDF-e","Execute o módulo de configuração do serviço, antes de utilizar esta opção",{"OK"},3)
	EndIf
     
Return(Iif(lMonitor,aListBox,Nil))

//------------------------------------------------------------------------
/*/ MDFeEvento 
Encerramento de MDF-e.

@author Rafael Iaquinto
@since 27.02.2014
@version P11 
@Return	NIL
/*/
//-----------------------------------------------------------------------
Static Function MDFeEvento(aList,cEvento)

	Local aRegMark		:= {}

	Local nX			:= 0
	Local nPos			:= 0
	Local nEnvio		:= 0
	Local nY			:= 0

	Local aAreaCC0		:= CC0->(GetArea())
	Local aTrans		:= {}
	Local aDados		:= {}
	Local aDaDosXml	:= {}
	Local aNotas		:= {}
	Local aXML		:= {}
	Local aNFeCol		:= {}

	Local cXMl			:= ""
	Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cMsg			:= ""
	Local cMsgOk		:= ""
	Local cMsgNOK		:= ""
	Local cMsgErro		:= ""
	Local cJust		:= ""
	Local cErro		:= ""
	Local cAviso		:= ""
	Local cXmlRet		:= ""
	Local cSerie		:= ""
	Local cNumero		:= ""
	Local cXmlCC0		:= ""
	Local cMunicipio	:= ""
	Local cCondicao 	:= ""

	Local lEnvEvento	:= .F.
	Local lSameJus		:= .F.
	Local lCleanNF		:= .F.
	Private oWs

	aRegMark	:= GetRegMark(aList,7)
	nRegMark 	:= Len(aRegMark)

	If nRegMark > 0 .And. nRegMark <= 20
	
	
	//Monta o XML do Evento
		cXml := '<envEvento>'
		cXml += '<eventos>'
		For nX := 	1 to nRegMark
		
			CC0->(DbGoto(aRegMark[nX,8]))
		
			If lUsaColab
			// Autorizado ou Nao autorizado (caso o documento for rejeitado podera gerar outro documento)
				cCondicao := ( CC0->CC0_STATUS == AUTORIZADO .Or. CC0->CC0_STATUS == NAO_AUTORIZADO )
			Else
				cCondicao := CC0->CC0_STATUS == AUTORIZADO
			EndIf
		
			If cCondicao
			
				If cEvento == "110111"
					If !lSameJus .And. MsgYesNo("Informar a justificativa para os cancelamentos ?")
						if Aviso("Motivo de cancelamento MDF-e "+CC0->CC0_SERMDF+CC0->CC0_NUMMDF, @cJust, {"Confirmar", "Cancelar"}, 3,"Cancelamento de MDF-e como Evento",,, .T.) == 1
							lSameJus := MsgYesNo("Utilizar a mesma justificativa para todos?")
						EndIf
					EndIf
				EndIf
				cXml += XmlDetEvento(cEvento,CC0->CC0_CHVMDF,cJust)
										
				aadd(aTrans,{1,CC0->(RECNO()), CC0->CC0_CHVMDF,CC0->CC0_SERMDF+CC0->CC0_NUMMDF } )
			
				lEnvEvento := .T.
			
			Else
				aadd(aTrans,{3,CC0->(RECNO()), CC0->CC0_CHVMDF,CC0->CC0_SERMDF+CC0->CC0_NUMMDF } )
			EndIf
		
			aadd(aNotas,{})
			nX := Len(aNotas)
			aadd(aNotas[nX],CC0->CC0_FILIAL)
			aadd(aNotas[nX],CC0->CC0_SERMDF)
			aadd(aNotas[nX],CC0->CC0_NUMMDF)
			aadd(aNotas[nX],CC0->CC0_DTEMIS)
			aadd(aNotas[nX],CC0->CC0_XMLMDF)
			
		Next nx
		cXml += '</eventos>'
		cXml += '</envEvento>'
	
		
		If lEnvEvento
	
			If lUsaColab
		
				For nX := 1 to Len(aNotas)
					
					cSerie		:= aNotas[nX][2]
					cNumero 	:= aNotas[nX][3]
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Adicionando no aNFe para manter o padrao das funcoes SpedCCeXml e ColEnvEvento³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aNFeCol := {}
					aAdd(aNFeCol,"" ) 			//01 - em branco
					aAdd(aNFeCol,cSerie) 		//02 - Serie
					aAdd(aNFeCol,cNumero) 		//03 - Numero
					aAdd(aNFeCol,"")			 	//04 - em branco
					aAdd(aNFeCol,"")			 	//05 - em branco

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Buscando valor da tag cMunDescarga para obter o codigo do municipio        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
					cXmlCC0	:= CC0->CC0_XMLMDF
					aDados 		:= ColDadosNf(3,"58")
					aDadosXml	:= ColDadosXMl( cXmlCC0, aDados, @cErro, @cAviso)
				
					If Len(aDadosXml) > 0
						cMunicipio	:= Alltrim(aDadosXml[9])  //Codigo Municipio Descarga
					EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Chamando funcao da geracao Evento										         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
					cXmlRet := SpedCCeXml( nil ,cJust,cEvento,CC0->CC0_PROTOC,"MDF",CC0->CC0_CHVMDF, cMunicipio )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Adicionando no array para manter o padrao da funcao XmlMDFTrans            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aXML := cXmlRet
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Chamando funcao da geracao XML 												  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					lRetorno := XmlMDFTrans( aNFeCol, aXML, "58" , @cErro, cEvento )
				
				
					If lRetorno
						aDados := ColDadosNf(2,"58")
						aDadosXml := ColDadosXMl(cXml, aDados, @cErro, @cAviso)
					
						For nY:=1  To Len(aTrans)
							nPos:=aScan(aDadosXml,{|X| X == aTrans[nY][3]})
							If nPos > 0
								aTrans[nY][1] := 2
								nEnvio++
							EndIf
						Next
						lEnvEvento:= .T.
					EndIf
				Next nX
		
			Else
	
			// Chamado do metodo e envio
				oWs:= WsNFeSBra():New()
				oWs:cUserToken	:= "TOTVS"
				oWs:cID_ENT		:= cIdEnt
				oWs:cXML_LOTE	:= cXml
				oWS:_URL		:= AllTrim(cURL)+"/NFeSBRA.apw"
			
				If oWs:RemessaEvento()
					If Type("oWS:oWsRemessaEventoResult:cString") <> "U"
						If Type("oWS:oWsRemessaEventoResult:cString") <> "A"
							aRetorno:={oWS:oWsRemessaEventoResult:cString}
						Else
							aRetorno:=oWS:oWsRemessaEventoResult:cString
						EndIf
					
						For nX:=1  To Len(aTrans)
							nPos:=aScan(aRetorno,{|X|  Substr(X,9,44) == aTrans[nX][3]})
							If nPos > 0
								aTrans[nPos][1] := 2
								nEnvio++
							EndIf
						Next
						lEnvEvento:= .T.
					Endif
				Else
					lEnvEvento:= .F.
					Aviso("MDF-e",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
				Endif
			EndIf
		EndIf
	
		If lEnvEvento
			For nX := 1 to len(aTrans)
				If aTrans[nX][1] == 1
					cMsgNOk	+= "MDF: "+aTrans[nX][4] + CRLF
					cMsgNOk	+= cErro
					MdfAtuEvento(aTrans[nX][2],EVENAOREALIZADO,cEvento)
				ElseIf aTrans[nX][1] == 2
					cMsgOk	+= "MDF: "+aTrans[nX][4] + CRLF
					MdfAtuEvento(aTrans[nX][2],EVEREALIZADO,cEvento)
				ElseIf aTrans[nX][1] == 3
					cMsgErro += "MDF: "+aTrans[nX][4] + CRLF
					cMsgErro += cErro
				EndIf
			Next nX
		
			cMsg := "Resultado da transmissão dos Eventos do MDFe: "+CRLF+CRLF
			If Len(cMsgOk) > 0
				If cEvento == "110112"
					lCleanNF := .T.
				EndIf
				cMsg += "MDF-e com evento transmitido com sucesso: " + CRLF+CRLF
				cMsg += cMsgOk+CRLF
			EndIf
			
			If Len(cMsgNOk) > 0
				cMsg += "MDF-e com problemas na transmissao do evento: " + CRLF+CRLF
				cMsg += cMsgNOk+CRLF
				cMsg += IIf( Empty(cErro), cErro , "" )
			EndIf
		
			If Len(cMsgErro) > 0
				cMsg += "MDF-e não autorizados, evento não transmitido: " + CRLF+CRLF
				cMsg += cMsgErro+CRLF
				cMsg += IIf( Empty(cErro), cErro , "" )
			EndIf
		
			EnvExibLog(cMsg,"Resultado da transmissão")

			If lCleanNF
				IF Aviso("Atenção","Houve qualquer alteração nas informações do MDF-e (veículos, carga, documentação, motorista, etc.), que precise ser emitido uma nova MDF-e?",{"Sim","Não"}) == 1
					If MsgYesNo("A confirmação dessa opção será liberado a(s) Nota(s) Fiscal(is) vinculada a(s) MDF-e(s). Deseja mesmo seguir com esse procedimento?")
						For nX := 1 To Len(aTrans)
							CC0->(DbGoto(aTrans[nX][2]))
							DelMDFSf2(CC0->CC0_SERMDF,CC0->CC0_NUMMDF)
						Next
					EndIf
				EndIf
			EndIf
		
		//Recarrega a lista
			ReloadListDocs()
		
		ElseIf len(aTrans) > 0
			MsgInfo("Somente documentos autorizados podem gerar evento.")
		EndIf
	ElseIf nRegMark > 20
		MsgInfo("Não é possível transmitir mais de 20 registros em uma mesma requisição!")
	Else
		MsgInfo("Deve ser marcado pelo menos um registro!")
	EndIF

	RestArea(aAreaCC0)

Return

//-----------------------------------------------------------------------
/*/ GetRegMark 
Pega registros marcados o aListBox

@author Rafael Iaquinto
@since 27.02.2014
@version P11 

@param	aList		aListBox
		nPosMark	Posição do mark no ListBox

@Return	NIL
/*/
//------------------------------------------------------------------------
Static Function GetRegMark(aList,nPosMark)
	Local nX			:= 0
	Local aPosMark		:= {}
	
	For nX := 1 to len(aList)
		If aList[nX,nPosMark]
			aadd(aPosMark,aList[nX])
		EndIF
	Next nX
	
Return(aPosMark)


//------------------------------------------------------------------------
/*/ XmlDetEvento 
Monta o DetEvento do XML de evento do MDF-e.

@author Rafael Iaquinto
@since 27.02.2014
@version P11 

@param	aList		aListBox
		nPosMark	Posição do mark no ListBox

@Return	NIL
/*/
//------------------------------------------------------------------------
Static Function XmlDetEvento(cEvento,cChvMdf,cJust)
	Local cXml		:= ""

	cXml := '<detEvento>'
	cXml += '<tpEvento>'+cEvento+'</tpEvento>'
	cXml += '<chnfe>'+cChvMdf+'</chnfe>'
	if cEvento == "110112" //Encerramento
		cXml += '<dtEnc>'+FsDateConv(Date(),"YYYY")+"-"+FsDateConv(Date(),"MM")+"-"+FsDateConv(Date(),"DD")+'</dtEnc>'
		cXml += '<cUF>'+SM0->M0_ESTCOB+'</cUF>'
		cXml += '<cMun>'+SM0->M0_CODMUN+'</cMun>'
	ElseIF cEvento == "110111"
		cXml += '<xJust>'+cJust+'</xJust>'
	EndIf
	cXml += '</detEvento>'

Return(cXml)

//------------------------------------------------------------------------
/*/ MdfAtuEvento 
Atualiza os dados do evento do MDF-e.

@author Rafael Iaquinto
@since 27.02.2014
@version P11 

@param	aList		aListBox
		nPosMark	Posição do mark no ListBox

@Return	NIL
/*/
//------------------------------------------------------------------------
Static Function MdfAtuEvento(nRecno,cStatus,cTpEven)
	Local aAreaCC0		:= CC0->(GetArea())
	
	CC0->(dbGoTo(nRecno))
	RecLock('CC0',.F.)
	CC0->CC0_STATEV := cStatus
	CC0->CC0_TPEVEN := cTpEven
	CC0->(msUnlock())
	
	RestArea(aAreaCC0)
Return

//-----------------------------------------------------------------------
/*/ EnvExibLog
Função que exibe o log de envio do Evento do MDFe.

@author Rafael Iaquinto
@since 23/01/2013
@version 1.0

@param	cMsg			Mensagem a ser exibida para o usuário
				
@return	Nil
/*/
//-----------------------------------------------------------------------

Static Function EnvExibLog(cMsg,cTitulo)
	
	Local oDlg
	Local oBtn1
	
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 00,00 TO 600,800 PIXEL
	DEFINE FONT oFont BOLD
	
	oMemo := TMultiGet():New( 010,010, { | u | If( PCount() == 0, cMsg, cMsg := u ) },oDlg, 380,270,,.F.,,,,.T.,,.F.,,.F.,.F.,.F.,,,.F.,, )
	oMemo:EnableVScroll(.T.)
	oMemo:oFont:=oFont
	
	//@ 010,010 GET cMsg MEMO SIZE 380,270 READONLY PIXEL OF oDlg
	@ 285,355 BUTTON oBtn1 PROMPT "OK" ACTION oDlg:End() OF oDlg PIXEL SIZE 035,011 //"OK"
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
Return

//-----------------------------------------------------------------------
/*/ GetListBox
Função que retorna o array de MDFes para o recurso "Gerenciar MDFe"

@author Rafael Iaquinto
@since 23/01/2013
@version 1.0			
@return	Nil
/*/
//-----------------------------------------------------------------------
Static Function GetListBox()
	Local aListReturn
	Local cAlias := GetNextAlias()
	//Local oNo := LoadBitmap( GetResources(), "LBNO" )
	
	
	#IFDEF TOP
		cQuery := "	SELECT CC0.CC0_SERMDF, CC0.CC0_NUMMDF, CC0.CC0_DTEMIS, CC0.CC0_STATUS, CC0.CC0_STATEV, CC0.CC0_TPEVEN, CC0.R_E_C_N_O_ "
		cQuery += " FROM " + RetSqlName('CC0') + " CC0 "
		cQuery += " WHERE CC0.CC0_FILIAL = '" + xFilial("CC0") + "' "
		If !Empty(cSerFil)
			cQuery += " 	AND CC0.CC0_SERMDF = '" + cSerFil + "'"
		EndIf
		If SubStr(cStatFil,1,1) <> '0'
			cQuery += " 	AND CC0.CC0_STATUS = '" + SubStr(cStatFil,1,1) + "' "
		EndIf
		cQuery += " 	AND CC0.D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY CC0.CC0_SERMDF, CC0.CC0_NUMMDF "
		cQuery := ChangeQuery(cQuery)
		iif(Select(cAlias)>0,(cAlias)->(dbCloseArea()),Nil)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias, .F., .T.)
		If (cAlias)->(!Eof())
			aListReturn := {}
		EndIf
		While (cAlias)->(!Eof())
			aadd(aListReturn,{oNo,(cAlias)->CC0_SERMDF,(cAlias)->CC0_NUMMDF,STOD((cAlias)->CC0_DTEMIS),GetDescStatus((cAlias)->CC0_STATUS),GetDescEven((cAlias)->CC0_STATEV,(cAlias)->CC0_TPEVEN),.F.,(cAlias)->R_E_C_N_O_})
			(cAlias)->(dbSkip())
		EndDo
	#ELSE
		dbSelectArea('CC0')
		CC0->(dbSetOrder(1))
		While CC0->(!Eof())
			If CC0->CC0_FILIAL == xFilial("CC0") .and. alltrim(CC0->CC0_STATUS) == SubStr(cStatFil,1,1)
				If ((!Empty(cSerFil) .and. 	alltrim(CC0->CC0_SERMDF) == alltirm(cSerFil)) .or. Empty(cSerFil))
					If (SubStr(cStatFil,1,1) <> '0' .and. (CC0->CC0_STATUS == SubStr(cStatFil,1,1))) .or. SubStr(cStatFil,1,1) == '0'
						aadd(aListReturn,{oNo,CC0->CC0_SERMDF,CC0->CC0_NUMMDF,CC0->CC0_DTEMIS,GetDescStatus(CC0->CC0_STATUS),GetDescEven(CC0->CC0_STATEV,CC0->CC0_TPEVEN),.F.,CC0->(RECNO())})
					EndIf
				EndIf
			EndIf
			CC0->(dbSkip())
		EndDo
		RestArea(aAreaCC0)
	#ENDIF

Return aListReturn

//-----------------------------------------------------------------------
/*/ ValidUf
Valida se o codigo de UG recem digitado eh valido (existe na tabela CC2)

@author Cesar Bianchi
@since 05/07/2014
@version 1.0
@param	cUF Codigo da Unidade Federativa				
@return	lRet
/*/
//-----------------------------------------------------------------------
Static Function ValidUfMDF(cUF)
	Local lRet := .F.
	Local aArea := GetArea()
	Default cUF := ""
	
	If !Empty(cUF)
		dbSelectArea('SX5')
		SX5->(dbSetOrder(1))
		lRet := SX5->(dbSeek(xFilial('SX5')+"12"+cUF))
		
		If lRet .and. (cUF == cUFCarr .or. cUF == cUFDesc)
			MsgAlert('UF presente em "Carregamento" ou "Descarregamento". Não é necessaria sua inclusão em "Percuso do veiculo"')
			lRet := .F.
		EndIf
	EndIF
	
	RestArea(aArea)
Return lRet


//-----------------------------------------------------------------------
/*/ ValListDesc
Valida se o usuario trocou o codigo da UF de descarregamento, eliminando a lista
de municipios e de NFs Marcadas.

@author Cesar Bianchi
@since 05/07/2014
@version 1.0
@return	lRet
/*/
//-----------------------------------------------------------------------
Static Function ValListDesc(nOpc)
	Local lRet := .T.

	If nQtNFe > 0 .and. cUFDescAux <> cUFDesc
		If Aviso("Atenção",'O Codigo da UF de Descarregamento foi substituido. Esta alteração requer que todas as NFs sejam re-vinculadas ao manifesto (Aba "Documentos"). Deseja prosseguir com a alteração ?',{"Sim","Não"}) == 1
 			 			
			//Varre TRB limpando marcas
			dbSelectArea('TRB')
			TRB->(dbGoTop())
			While TRB->(!Eof())
				If !Empty(TRB->TRB_MARCA)
					RecLock('TRB',.F.)
					TRB->TRB_MARCA := ""
					TRB->TRB_CODMUN := ""
					TRB->TRB_NOMMUN := ""
					TRB->TRB_EST	:= ""
					TRB->(msUnLock())
				EndIf
				TRB->(dbSkip())
			EndDo
			
			//Controle UF alterada
			cUFDescAux := cUFDesc
			
			//Controle de variaveis
			nQtNFe := 0
			nVTotal := 0
			nPBruto := 0
			cVeiculoAux := cVeiculo
			cCodMun := Space(TamSx3("CC2_CODMUN")[1])
			TRB->(dbGoTop())

			//Atualiza objetos graficos			
			RefreshMainObjects()
		Else
 			//Usuario nao aceitou a alteracao (clicou em nao)
			lRet := .F.
		EndIf
	Else
		//Primeira vez
		cUFDescAux := cUFDesc
	EndIf
 	
Return lRet

//-----------------------------------------------------------------------
/*/ ValListCar
Valida se o usuario trocou o codigo da UF de carregamento, eliminando a lista
de municipios de descarregamento

@author Cesar Bianchi
@since 05/07/2014
@version 1.0
@return	lRet
/*/
//-----------------------------------------------------------------------
Static Function ValListCar(nOpc)
	Local lRet := .T.
	Local nI := 1
	Local aMunCarr := {}
    
	If Valtype(oGetDMun) == "O" .and. ValType(oGetDMun:aCols) == "A"
	 	       
	 	//Adiciona no array auxiliar apenas os municipios nao deletados.
		For nI := 1 to len(oGetDMun:aCols)
			If !oGetDMun:aCols[nI,len(oGetDMun:aCols[nI])]	//Linha nao deletada
				aAdd(aMunCarr,oGetDMun:aCols[nI])
			EndIf
		Next nI
	 	       
	 	//Valido se sobrou algum municipio. Se sim, entao nao pode proseguir sem o pergunte	 	
		If len(aMunCarr) > 0 .and. !Empty(aMunCarr[1,1]) .and. cUFCarrAux <> cUFCarr
			If Aviso("Atenção",'O Codigo da UF de Carregamento foi substituido. Esta alteração requer que todos os municipios de carregamento listados na aba "Carregamento/Percurso" sejam re-definidos. Deseja prosseguir com a alteração ?',{"Sim","Não"}) == 1
				aColsMun := GetNewLine(aHeadMun)
				oGetDMun:aCols := aClone(aColsMun)
				oGetDMun:oBrowse:Refresh()
				cUFCarrAux := cUFCarr
				lRet := .T.
			Else
	 			//Usuario nao aceitou a alteracao (clicou em nao)
				lRet := .F.
			EndIf
		Else
			//Alterou UF mas nao tinha municipios na lista de Carregamentos.
			cUFCarrAux := cUFCarr
		EndIf
	Else
		//Primeira vez
		cUFCarrAux := cUFCarr
	EndIf
 	
Return lRet


//-----------------------------------------------------------------------
/*/ ReloadListDocs
Recarrega a lista presente na getdados da rotina "gerenciar mdf-e"

@author Cesar Bianchi
@since 05/07/2014
@version 1.0
@return	lRet
/*/
//-----------------------------------------------------------------------
Static Function ReloadListDocs()
	
	if Type( "oListDocs" ) <> "U"
	
		aListDocs	:=	GetListBox()
		
		oListDocs:SetArray( aListDocs )
		
		oListDocs:bLine := {||     {If(aListDocs[oListDocs:nAt,7],oOkx,oNo),;
			aListDocs[oListDocs:nAt,2],;
			aListDocs[oListDocs:nAt,3],;
			aListDocs[oListDocs:nAt,4],;
			aListDocs[oListDocs:nAt,5],;
			aListDocs[oListDocs:nAt,6]}}
		oListDocs:BLDBLCLICK := {|| MDFLinGer(@oListDocs,@aListDocs,oOkx,oNo)}
		oListDocs:bHeaderClick := {|| aEval(aListDocs, {|e| e[7] := lMarkAll}),lMarkAll:=!lMarkAll, oListDocs:Refresh()}
		oListDocs:Refresh()
		
	endif
Return
static function UsaColaboracao(cModelo)
	Local lUsa := .F.

	If FindFunction("ColUsaColab")
		lUsa := ColUsaColab(cModelo)
	endif
return (lUsa)
//-----------------------------------------------------------------------
/*/ MDFeLookUp
Funcao utilizada para retornar o filtro da consulta padrao. A consulta deve ser
indicada atraves do parametro cLookUp.

@param cLookUp -> Informe a consulta padrao que deseja utilizar o filtro

@author Luccas Curcio

@since 11/09/2014

@version 1.0

@return	cFilter -> Expressao do filtro
/*/
//-----------------------------------------------------------------------
Static function MDFeLookUp( cLookUp )

	local cField	:=	ReadVar()
	local cFilter	:=	""

	if cLookUp == "CC2"
	
	//Consulta originada do campo "Codigo IBGE"  no formulario de Municipios de Carregamento
		if cField == "M->CC2_CODMUN"
		
			cFilter := "CC2->CC2_EST=='" + cUFCarr + "'"
	
	//Consulta originada do campo "Municipio de Descarregamento"  no formulario de Municipios de Descarregamento
		elseif cField == "CCODMUN"
	
			cFilter := "CC2->CC2_EST=='" + cUFDesc + "'"
	
		endif

	endif

return cFilter

//-----------------------------------------------------------------------
/*/ RetXmlNFe
Retorna o xml das notas vinculadas que foram emitidas.

@author Natalia Sartori
@since 08/04/2015
@version 1.0 

@param  cID ID da nota que sera retornado

@return aRetorno   Array com os dados da nota
/*/
//-----------------------------------------------------------------------
Static Function RetXmlNFe( cSerieNFe,cNumNFe )

	Local aRetorno		:= {}
	Local cRetorno		:= ""
	Local cURL			:= PadR(GetNewPar("MV_SPEDURL",""),250)

	Local lUsaColab	:= UsaColaboracao("5")

	Local oWS

	If CTIsReady(,,,lUsaColab)
		If !lUsacolab
	
			oWS:= WSNFeSBRA():New()
			oWS:cUSERTOKEN        := "TOTVS"
			oWS:cID_ENT           := cIdEnt
			oWS:nDIASPARAEXCLUSAO := 0
			oWS:_URL 			  := AllTrim(cURL)+"/NFeSBRA.apw"
			oWS:oWSNFEID          := NFESBRA_NFES2():New()
			oWS:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
		
			aadd(oWS:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
			Atail(oWS:oWSNFEID:oWSNotas:oWSNFESID2):cID := cSerieNFe+cNumNFe
		
			If oWS:RETORNANOTASNX()
				If Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5) > 0
					cRetorno        := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[1]:oWSNFE:CXML
					aadd(aRetorno,{cRetorno})
				EndIf
			Else
				Aviso("MDF-e",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
			EndIf
		Endif
	Else
		If !lUsacolab
			Aviso("MDF-e","Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!",{"OK"},3) //
		EndIf
	EndIf
	oWS       := Nil

Return aRetorno
//-----------------------------------------------------------------------
/*/ RetCodBarra
Retorna o segundo codigo de barra da NFe emitida em contingencia

@author Natalia Sartori
@since 08/04/2015
@version 1.0 

@param  cXml		Xml da NFe

@return cChvCTG	Chave de acesso da NF-e em contingencia que compoe a tag
					SegCodBarra
/*/
//-----------------------------------------------------------------------
Static Function RetCodBarra (cXml)

	Local cAviso	:= ""
	Local cErro	:= ""
	Local cUF		:= ""
	Local cTpEmis	:= ""
	Local cCnpjCpf	:= ""
	Local cDiaEmis	:= ""
	Local cChvCTG	:= ""

	Private oNFeRet
	
	If !Empty(cXml)
		oNFeRet := XmlParser(cXml,"_",@cAviso,@cErro)
		If Type("oNFeRet:_NFE:_INFNFE:_IDE:_MOD:TEXT") <> "U" .and. oNFeRet:_NFE:_INFNFE:_IDE:_MOD:TEXT $ "55"
			cUF := GetUfSig(oNFeRet:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT)
			cTpEmis	:= oNFeRet:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT
		
			If Type("oNFeRet:_NFE:_INFNFE:_DEST:_CNPJ:TEXT") <> "U"
				cCnpjCpf := oNFeRet:_NFE:_INFNFE:_DEST:_CNPJ:TEXT
			ElseIf Type("oNFeRet:_NFE:_INFNFE:_DEST:_CPF:TEXT") <> "U"
				cCnpjCpf := StrZero(Val(oNFeRet:_NFE:_INFNFE:_DEST:_CPF:TEXT),14)
			EndIf
			If Empty(cCnpjCpf) //operação com exterior informar o conteudo zerado
				cCnpjCpf := "00000000000000"
			EndIf
		
			cVNF := Strzero(Val(strtran(oNFeRet:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT,".","")),14)
		
			cICMSp := IIf(oNFeRet:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_Vicms:TEXT $ "0",2,1) //1=Ha destaque do ICMS 2= Não ha
			cICMSs := IIf(oNFeRet:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_Vst:TEXT $ "0",2,1) //1=Ha destaque do ICMS ST 2= Não ha
		
			If Type("oNFeRet:_NFE:_INFNFE:_IDE:_DHEMI:TEXT") <> "U"
				cDiaEmis := Substr(oNFeRet:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,9,2)
			ElseIf Type("oNFeRet:_NFE:_INFNFE:_IDE:_DEMI:TEXT") <> "U"
				cDiaEmis := Substr(oNFeRet:_NFE:_INFNFE:_IDE:_DEMI:TEXT,9,2)
			EndIf
		
			cChvCTG := NFeChCtg (cUF,cTpEmis,cCnpjCpf,cVNF,Alltrim(str(cICMSp)),Alltrim(str(cICMSs)),cDiaEmis)
		EndIf
	EndIf


Return (cChvCTG)

//----------------------------------------------------------------------
/*/ NFeChCtg 

Função responsável em montar o Segundo Codigo de Barra (nfe em contingencia)
e calcular o seu digito verificador

@Natalia Sartori
@since 08.04.2015
@version 1.00

@param      	cUF...: Codigo da UF
				cTpEmis.: Tipo de Emissão da NFe
				cCNPJ.: CNPJ do Destinatário da NFe
				cvNF..: Valor total da NFe
				cIcmsOp: Destaque do ICMS proprio
				cIcmsS...: Destaque do ICMS ST
				cDia...: Dia de Emissão da NF-e
				
@Return	cResult
/*/
//-----------------------------------------------------------------------
Static Function NFeChCtg(cUF,ctpEmis,cCNPJ, cvNF, cIcmsOp, cICMSs, cDia)

	Local nCount      := 0
	Local nSequenc    := 2
	Local nPonderacao := 0
	Local cResult     := ''
	Local cChvCTG  := cUF +  ctpEmis + cCNPJ + cvNF + cIcmsOp + cICMSs + cDia

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³SEQUENCIA DE MULTIPLICADORES (nSequenc), SEGUE A SEGUINTE        ³
//³ORDENACAO NA SEQUENCIA: 2,3,4,5,6,7,8,9,2,3,4... E PRECISA SER   ³
//³GERADO DA DIREITA PARA ESQUERDA, SEGUINDO OS CARACTERES          ³
//³EXISTENTES NA CHAVE DE ACESSO INFORMADA (cChvAcesso)             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nCount := Len( AllTrim(cChvCTG) ) To 1 Step -1
		nPonderacao += ( Val( SubStr( AllTrim(cChvCTG), nCount, 1) ) * nSequenc )
		nSequenc += 1
		If (nSequenc == 10)
			nSequenc := 2
		EndIf

	Next nCount

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quando o resto da divisão for 0 (zero) ou 1 (um), o DV devera   ³
//³ ser igual a 0 (zero).                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( mod(nPonderacao,11) > 1)
		cResult := (cChvCTG + cValToChar( (11 - mod(nPonderacao,11) ) ) )
	Else
		cResult := (cChvCTG + '0')
	EndIf

Return(cResult)

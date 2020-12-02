#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ GPEM610	³ Autor ³ Mauro	                  ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera arquivo com os dados do FGTS e INSS - SEFIP			    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.			    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data	³ BOPS   ³  Motivo da Alteracao 				    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Andreia     ³03/01/07³115646  ³Ajuste para verificar se o afastamento co-³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GERASEFIP()

Local oDlg
Local nOpca 	:= 	0
Local aSays 	:=	{ }
Local aButtons	:= 	{ } //<== arrays locais de preferencia
Local aRegs		:=	{}
Local aHelp		:= 	{}                        
Local aFilterExp:=  {} //Expressao de filtro

Local lPlsAtiv	:= GetNewPar("MV_PLSATIV",.F.)
Local oAltera
Local cAltera       
Local nOpcao	:= 0
Local bSet15
Local bSet24

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaração de arrays para dimensionar tela		         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjSize		:= {}
Local aObjCoords	:= {}

Private nTamFil := FWSizeFilial()

Private mv_par31 := ""
Private mv_par32 := ""
Private mv_par33 := ""
Private mv_par34 := ""
Private mv_par35 := ""
Private mv_par36 := ""
Private mv_par37 := ""
Private mv_par38 := ""
Private mv_par39 := ""
Private mv_par40 := ""
Private mv_par41 := ""
Private mv_par42 := ""             
Private mv_par43 := ""             
Private mv_par44 := ""             
Private mv_par45 := ""             
Private mv_par46 := ""             
Private mv_par47 := ""             
Private mv_par48 := ""             
Private mv_par49 := ""             

Private aRetFiltro
Private cSraFilter
Private cSrcFilter
Private cSI3Filter

Private lUsaPls		:= .F.
Private lAbortPrint := .F.  
                                   
If lPlsAtiv

	Private aItem := {"Nao","Sim"}

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Monta as Dimensoes dos Objetos         					   ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	aAdvSize		:= MsAdvSize()
	aAdvSize[5]	:=	(aAdvSize[5]/100) * 60	//horizontal
	aAdvSize[6]	:=  (aAdvSize[6]/100) * 40	//Vertical
	aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }					 
	aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
	aObjSize	:= MsObjSize( aInfoAdvSize , aObjCoords )
	aGdCoord	:= { (aObjSize[1,1]+3), (aObjSize[1,2]+5), (((aObjSize[1,3])/100)*27), (((aObjSize[1,4])/100)*58) }	//1,3 Vertical /1,4 Horizontal
	
	DEFINE MSDIALOG oDlg FROM  aAdvSize[7], 0 TO aAdvSize[6], aAdvSize[5] TITLE OemToAnsi("Plano de Saude") PIXEL  //"Plano de Saude"
	nOpca := 2
	@ aGdCoord[1], aGdCoord[2] TO aGdCoord[3], aGdCoord[4] LABEL "" OF oDlg PIXEL
	@ aGdCoord[1]+21, aGdCoord[2]+5 SAY "Gerar SEFIP para PLS"  SIZE 055,07 OF oDlg PIXEL // 
	@ aGdCoord[1]+19, aGdCoord[2]+70 COMBOBOX oAltera VAR cAltera ITEMS aItem  SIZE 040,10 OF oDlg PIXEL //"Altera CPF/CNPJ?"
	DEFINE SBUTTON FROM aGdCoord[3]+5, aGdCoord[4]-25 TYPE 1 ENABLE OF oDlg ACTION( nOpcao :=1 ,oDlg:End() )
	ACTIVATE MSDIALOG oDlg CENTERED
	
	lUsaPls := If(cAltera=="Nao",.F.,.T.)

EndIf

Private cCadastro := OemtoAnsi("Gera‡„o do arquivo de FGTS e INSS")		//
Pergunte("GPM610",.F.)

/* Retorne os Filtros que contenham os Alias Abaixo */
aAdd( aFilterExp , { "FILTRO_ALS" , "SRA"     	, .T. , ".or." } )
aAdd( aFilterExp , { "FILTRO_ALS" , "SI3"     	, .T. , ".or." } )
aAdd( aFilterExp , { "FILTRO_ALS" , "SRC"     	, NIL , NIL    } )
/* Que Estejam Definidos para a Função */
aAdd( aFilterExp , { "FILTRO_PRG" , FunName() 	, NIL , NIL    } )

AADD(aSays,OemToAnsi("Este programa gera arquivo de FGTS e INSS") ) //
                                            
AADD(aButtons, { 17,.T.,{|| aRetFiltro := FilterBuildExpr( aFilterExp ) } } )
AADD(aButtons, { 5,.T.,{|| Pergunte("GPM610",.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,IF(gpm610OK(),FechaBatch(),nOpca:=0) }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1                      
	ProcGpe({|lEnd| GPM610Processa()},,,.T.)	// Chamada do Processamento
EndIf

Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPM610Processa³ Autor ³ Cristina Ogura   ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPM610Processa()                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GPM610Processa() 

Local cInicio	, cFim		

Local cMesAnoRef 	:= ""
Local aOrdBagRC    	:= {}
Local aOrdBagRI   	:= {}
Local cArqMovRC    	:= ""
Local cArqMovRI    	:= ""
Local cCompetencia	:= GetMv( "MV_FOLMES",,Space(06) ) 
Local nVezes		:= 0
Local aArea			:= getArea()
Local nCont         := 0 
Local cNomeSRI		:= ""

Private lRat		:= .F.

Private aTabelas	:= {}
Private cAliasRC    := ""
Private cAliasRI	:= ""

Private cTerceiros	:= Space(04)  //--Carregada na funcao fInssEmp()
Private cFile
Private nHandle
Private cRecol	:= ""
Private nDeduc	:=	0
Private DiasDsr :=	0
Private nTotDias:=	0
Private dAuxPar01

Private cDiasMes:= Getmv("MV_DIASMES")
Private nDiasAc := 0
Private nDiasAd	:= 0
Private nDiasMat:= 0

Private cArqNome
Private cCGC	:= Space(15)

Private lPessoalAdm := .F.
                              
Private cSalFamDed  := ""
Private cSalMatDed  := ""       
Private cPDDedSFam  := GetNewPar("MV_SALFDED","") //-->Verbas a deduzir para o Salario Familia
Private cPDDedSMat  := GetNewPar("MV_SALMDED","") //-->Verbas a deduzir para o Salario Maternidade

Private cIndCNAE	:= "P"

//--Paramentros Selecionados para geracao da SEFIP Versao 4.0
dAuxPar01	:= mv_par01				// Data de Referencia2
cDataRef	:= Dtoc(mv_par01)		//	Data de Referencia
dDtFgts	  	:= mv_par02				//	Data recolhimento FGTS
dDtInss		:= mv_par03				//	Data Recolhimento INSS
cFile 		:= mv_par04 			//  Arquivo Destino
cFilDe		:= mv_par05				//	Filial De
cFilAte		:= mv_par06				// 	Filial Ate
cCcDe		:= mv_par07				//	Centro de Custo De
cCcAte		:= mv_par08				//	Centro de Custo Ate
cMatDe		:= mv_par09				//	Matricula De
cMatAte		:= mv_par10				//  Matricula Ate
nFilCc		:= mv_par11				//	Gerar por 1=filial 2=Centro de Custo
nComTomador	:= mv_par12				//	Gerar C.C. 1=c/Tomador 2=s/Tomador 3=Ambos
nRateio		:= mv_par13				//	Gera r C.C.Rateado 1=Sim 2=Nao
nTipo		:= mv_par14				// 	Sefip 1=Folha/Ferias 2=13o.Salario
nTpTomador	:= mv_par15				// 	1=CEI; 2=CNPJ; 3= Ambos
nBase		:= mv_par16				//	Base 1-Fgts 2= Inss
nAgrupa		:= mv_par17				//	Agrupar Empresas 1=Sim 2=Nao
nCentra		:= mv_par18				//	Centralizar filials 1=sim 2=nao
cFilResp	:= mv_par19				//	Empresa/Filial Responsavel e Centralizadora
nCodRemag	:= mv_par20				//	Codigo Remag
cRecol		:= mv_par21            //	Codigo Recolhimento Sefip
cCodGPS		:= mv_par22				//	Codigo de recolhimento GPS Filial=CGC
cTpContr	:= ""
//	Tipo de Contrato 1=indeterminado ; 2=Determinado ou 3 = Ambos
If mv_par23 == 1
	cTpC	 := " *1"
	cTpContr := "1"
ElseIf mv_par23 == 2
	cTpC	 := "2"
	cTpContr := "2"
ElseIf mv_par23 == 3
	cTpC	 := " *12"
	cTpContr := "3"
EndIF	 

nRecInss	:= mv_par24				//	Recolh. Inss  1=No Prazo 2=Em Atraso  3=Nao Gera GPS

If mv_par25 == 4
	nRecFgts	:= 5				//	Recolh. Fgts  1=No Prazo 2=Em Atraso 3 -Em Atraso(Acao Fiscal)
ElseIf mv_par25 == 5				//				  4=Individualizacao 5-Individualizacao(Acao Fiscal)	
	nRecFgts	:= 6
Else
	nRecFgts	:= mv_par25
EndIf	

nIndInss	:= mv_par26				//  Indice Correcao INSS
cSimples	:= mv_par27				//	Optante pelo Simples 1=Nao optante  2=Optante
nOrigRec	:= mv_par28				//	Origem Receita 1=Arrec.Evento 2=Arrec.Patrocionio 3=Arrec.Evento/Patrocinio	
nValRec		:= 0    				//	Valor da Receita Arrec. Evento ou Patrocinio
nValProPf	:= 0     				//	Valor Producao Rural P.Fisica
nValProPj	:= 0 					//	Valor producao Rural P.Juridica
nPercFilan	:= mv_par29				//	% de Isencao Filantropia
cNomeCont	:= mv_par30				//	Nome do Contato na Empresa
nFoneCont	:= mv_par31				//	Telefone do Contato na Empresa
cInternet	:= mv_par32				//	Endereco Internet para contato
nTpForFol	:= mv_par33				//	Tipo Inscricao Fornecedor folha de Pagamento
nInscFol	:= mv_par34				//	No. Inscricao Fornecedor folha de Pagamento
cCodGps20	:= mv_par35				//	Codigo de recolimento por C.Custo=Cei
nRescMes	:= mv_par36				//  Gerar Demitidos do mes
									//	1 - A Pedido; 2-Por Dispensa; 3-Ambos; 4-Nao gerar
nRescComp	:= mv_par37				//  Gerar Demitidos das Rescisoes complementares  
									//	1 - A Pedido; 2-Por Dispensa; 3-Ambos; 4-Nao gerar
lOnlyComp	:= if(mv_par38==1,.T.,.F.)	//  Gerar Somente Demitidos das Rescisoes complementares
dDtInfINI   := mv_par39				//	Outras Informacoes - Periodo Inicio
dDtInfFIM	:= mv_par40				//	Outras Informacoes - Periodo Fim
nVersao     := mv_par41 			//  Versao 4.0/5.0/6.0
nDemitido   := mv_par42 			//  Somente demitidos(Sim/Nao)
nDissidio   := mv_par43 			//  Somente dissidio(Sim/Nao)
cModFgts	:= mv_par44				//  modalidade da declaracao
nProcesso	:= mv_par45				//  No. do processo em caso de reclamatoria trabalhista/dissidio
nProcAno	:= mv_par46				//  Ano do process em caso de reclamatoria trabalhista/dissidio	
nVara		:= mv_par47				//  No. da vara/JCJ no caso de reclamatoria trabalhista/dissidio
cEmprAgrup	:= mv_par48             // Codigo da empresa responsavel pelo agrupamento

If mv_par49 == 1
	cIndCNAE	:=  "S"				// Indicativo de alteracao do CNAE
ElseIf mv_par49 == 2
	cIndCNAE	:=  "N"
ElseIf mv_par49 == 3
	cIndCNAE	:=  "A"
ElseIf mv_par49 == 4
	cIndCNAE	:=  "P"
EndIf			

nVlCooper   := 0                   // valor pago a cooperativas de trabalho
cAnoMesGps  := MesAno(dAuxPar01)  // Ano/Mes para busca do parametro 15-GPS 
                     
//-- Verbas a Deduzir para o Salario Familia
If !Empty( cPDDedSFam )           
	If Len( AllTrim( cPDDedSFam ) ) > 3
		For nCont := 1 To Len( AllTrim( cPDDedSFam ) ) Step 3
			cSalFamDed += Subs( cPDDedSFam, nCont, 3 ) + "*"
		Next nCont 
	Else
		cSalFamDed := AllTrim( cPDDedSFam )
	EndIf
Endif  

//-- Verbas a Deduzir para o Salario Maternidade
If !Empty( cPDDedSMat )           
	If Len( AllTrim( cPDDedSMat ) ) > 3
		For nCont := 1 To Len( AllTrim( cPDDedSMat ) ) Step 3
			cSalMatDed += Subs( cPDDedSMat, nCont, 3 ) + "*"
		Next nCont 
	Else
		cSalMatDed := AllTrim( cPDDedSMat )
	EndIf
Endif

// Se Movto de 13o. Mes ref. = 13
If nTipo == 2  
	cDataRef   := Substr(DtoC(mv_par01),1,2)+"/13/"+Right(DtoC(mv_par01),2)
	cAnoMesGps := Left(cAnoMesGps,4) + "13"
Endif

//-- O nome do arquivo deve ser SEFIP.RE
If !"SEFIP.RE" $ UPPER(cFile)
	Help(" ",1,"GPMSFGTSRE")
	Return Nil
EndIf                                 

// Verifica se a filial responsavel existe - cFilResp
If !FVerSM0()
	Aviso("Atenção","Informe uma empresa/filial existente.",{"OK"}, ,"Empresa/Filial não cadastrada") //####
	Return Nil
EndIf     

//--Quando For Por Centro de custo verificar Cod.Recol.
If nFilCc = 2 
	If ((nComTomador = 1 .Or. nComTomador = 3) .And. cRecol$ '115/145/307/327/345/418/604/640/650/660') .Or. ;    //Tem que ser 155
		(nComTomador = 2 .And. ! cRecol$ '115')
 
		Aviso("Codigo de Recolhimento Invalido","Codigo de Recolhimento invalido para o tipo de Centro de Custo",{"OK"})// ##
		Return Nil		
	Endif
Endif	

// Tipo 13o. Salario
If nTipo == 2   // Tipo 1-Folha/Ferias	   2-13o.Salario
	If nRecInss == 3
		Help("",1,"GPMIND")		// Indicativo de Recolh de INSS deve ser 1 ou 2 para opcao de 13o. salario
		Return Nil
	EndIf
	
	If cRecol$ "130"
		Aviso("Codigo de Recolhimento Invalido","O codigo de recolhimento 130 não permite SEFIP de competencia 13",{"OK"})// ##
		Return Nil			
	EndIf
EndIf

// Agrupa por empresa : 1-Sim 	2-Nao
If nAgrupa == 2
	cArqNome := "SFP"+FwCodEmp("SM0")+GetDBExtension()
	cArqNome := RetArq(__LocalDriver,cArqNome,.T.)
Else      
	If empty(cEmprAgrup)
		Aviso( "Atencao","Informe qual a empresa que agrupara as informacoes.", { "Ok" },,"" ) // ##
		Return
	Endif
	cArqNome := "SFP"+cEmprAgrup+ GetDBExtension()
	cArqNome := RetArq(__LocalDriver,cArqNome,.T.)
EndIf	
If !Gp610Cria(cArqNome)
	Aviso( "Nao foi possivel abrir o arquivo temporario SFP. Verifique se este processo já está sendo executado em outra estação.","Erro ao abrir o arquivo", { "Ok" },," " ) //###
	Return
Endif

// Agrupa por empresa : 1-Sim 	2-Nao
If nAgrupa == 2
	dbSelectArea("SFP")
	dbCloseArea()
	While MSFile(cArqNome,,__LocalDriver)     
		nVezes ++
		If nVezes >= 10
			Aviso( "Nao foi possivel excluir o arquivo ","Erro ao Excluir arquivo"+'"'+cArqNome +'"', { "Ok" },," " ) //###
			Return
		EndIf	
		FErase(cArqNome)
		FErase(FileNoExt(cArqNome)+"1"+OrdBagExt()) 
	EndDo	          
	If !Gp610Cria(cArqNome)
		Aviso( "Nao foi possivel abrir o arquivo temporario SFP. Verifique se este processo já está sendo executado em outra estação.","Erro ao abrir o arquivo", { "Ok" },," " ) //###
		Return
	Endif
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica se existe o arquivo de fechamento do mes informado  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMesAnoRef 	:= StrZero(Month(dAuxPar01),2) + StrZero(Year(dAuxPar01),4)

If lUsaPLS                           
	If ! OpenTabelas(@aTabelas)           
		f610ApIndice(cArqnome)
		RestArea( aArea )
		If lUsaPls
			FechaTabelas()                    
		EndIf
		Return
	EndIf
Else
	If  MesAno(dAuxPar01) < cCompetencia 
		//-- Abre o SRC
		If !OpenSrc( cMesAnoRef, @cAliasRC, @aOrdBagRC, @cArqMovRC, dAuxPar01, .F. )
			f610ApIndice(cArqnome)
			RestArea( aArea )
			Return
		Endif	
		//-- Abre o SRI                                                                                       
		cNomeSRI := If( cRecol$ "130","RI"+FwCodEmp("SM0")+Substr(cMesAnoRef,5,2)+SubStr( cMesAnoRef,1,2),"")
           
		OpenSrc( "13"+Substr(cMesAnoRef,3,4), @cAliasRI, @aOrdBagRI, @cArqMovRI, dAuxPar01,.F., .T.,cNomeSRI )
		//-- Sempre que for pelo acumulado sera rateado.
	EndIf
EndIf

If  MesAno(dAuxPar01) > cCompetencia
	cCompetencia 	:= substr(cCompetencia,5,2)+"/"+substr(cCompetencia,1,4) 
	cMesAnoRef		:= substr(cMesAnoRef,1,2)+"/"+substr(cMesAnoRef,3,4) 
    Aviso( "Atencao","Data de referencia "+"( "+cMesAnoRef+" )"+" maior que data de competencia em aberto "+" ( "+ cCompetencia+" ).", { "Ok" },,"Data de Referencia Invalida" )  //#########
	f610ApIndice(cArqnome)
	RestArea( aArea )
	If lUsaPls
		FechaTabelas()                    
	EndIf
	Return
EndIF

// Gerar por CC / Gerar Rateado a ordem deve ser o SRC e nao SRA
If (nFilCc == 2 .And. nRateio == 1) //.or. ( MesAno(dAuxPar01) < GetMv( "MV_FOLMES",,Space(06) ) .and. nFilCc == 2)

	dbSelectArea("SRC")
	dbSetOrder(2)
	dbGotop()

	dbSeek(cFilDe+cCcDe,.T.)				// Filial de + Centro de Custo de
	cInicio	:= "SRC->RC_FILIAL+SRC->RC_CC"
	cFim	:= cFilAte +cCcAte

	If SRC->RC_FILIAL+SRC->RC_CC > cFim
		Help(" ",1,"GPM600SRAT")
		f610ApIndice(cArqnome)
		If lUsaPls
			FechaTabelas()                    
		EndIf
		Return Nil
	EndIf
	lRat := .T.
Else
 	// Geracao por 1-Filial ou Por Centro de custo sem rateio
	dbSelectArea( "SRA" )
	If nFilCc == 1				// Ordem de Filial + Matricula
		dbSetOrder(1)
	Else
		dbSetOrder(2)			// Ordem de Filial + Centro Custo + Matricula
	EndIf
	dbGotop()

	dbSeek( cFilDe , .T. )
	cInicio := "SRA->RA_FILIAL"
	cFim	:= cFilAte

	If SRA->RA_FILIAL > cFim
		Help(" ",1,"GPM600SFIL")
		f610ApIndice(cArqnome)
		If lUsaPls
			FechaTabelas()                    
		EndIf
		RestArea( aArea )
		Return Nil
	EndIf
EndIf

//--Funcao de Processamento Selecionado pelos Parametros
FMatricula(cInicio,cFim,lRat)

//-- Apaga o indice do SFP
f610ApIndice(cArqnome)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty( cAliasRC )
	fFimArqMov( cAliasRC , aOrdBagRC , cArqMovRC )
EndIf

If !Empty( cAliasRI )
	fFimArqMov( cAliasRI , aOrdBagRI , cArqMovRI)
EndIf

If lUsaPls
	FechaTabelas()                    
EndIf

Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FMatricula    ³ Autor ³ Cristina Ogura   ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento por filial                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

Static Function FMatricula(cInicio,cFim,lRat)

Local cFilAnterior	:= 	""
Local cAuxCGC		:=	""
Local aInfo   		:= 	{}
Local cInfo       	:=	"" 
Local cTipo			:=	""
Local nFgts			:=	0
Local nB13Fgts		:=	0
Local nSalFam		:=	0
Local n20SalFam		:=	0
Local n20SalFamAnt	:=	0
Local nB13Inss		:=	0
Local nBinss		:=	0
Local nValor247		:=  0
Local nFgtsRes		:=	0
Local nB13InRc		:=	0
Local nSc13Sal		:=	0 	// Acumulador de Base 13o. para valor devido a previdencia 
Local nSalMat		:=	0
Local nSalMat1		:=	0	// Salario Maternidade Antes de 01/12/1999
Local nSalMat2		:=	0 	// Salario Maternidade Apos 01/12/1999
Local l1Vez			:= 	.T.
Local lJaGerou		:= 	.F.
Local cAuxFil		:=	""
Local aAuxInfo		:=	{}
Local cAuxInfo		:=	""
Local nAuxSal		:=	0
Local nAuxFgts		:=	0
Local cInsc			:=	""
Local cAuxAlias		:= 	IIF(lRat,"SRC","SRA")
Local cCusto		:=	""
Local cCustoAux		:= 	"!!"
Local nInss			:=	0
Local cAuxCompet	:=	""
Local n13Inss		:=	0
Local lGera32		:= 	.F.
Local lGera30		:= 	.F.
Local aAfast 		:= 	{}
Local cCompet		:=	""
Local nTotAci		:= 	0
Local nT13Inss    	:= 	0
Local nTB13Inss   	:= 	0
Local nPercAcTrab 	:=	0
Local aLog			:= {}
Local aTitle		:= {}
Local aTotRegs		:= array(12)
Local nInssOutr		:= 0
Local nX
Local n
Local cCateg		:= space(02)
Local lSI3 			:= .T.
Local aRegsTip14	:= {}

//variaveis para dissidio
Local cArqDbf		:= 'DISS'+FwCodEmp("SM0")+cFilAnt + GetDBExtension()
Local cIndCond		:= 'TRB_FILIAL + TRB_MAT + Substr( TRB_DATA, 3, 4 ) + Substr( TRB_DATA, 1, 2 )+TRB_VB '
Local cIndCon1		:= 'TRB_FILIAL + TRB_CC  + TRB_MAT + Substr( TRB_DATA, 3, 4 ) + Substr( TRB_DATA, 1, 2 )+TRB_VB '
Local aFunc			:= {}
Local nLinha		:= 0
Local nI			:= 0
Local lConsidera	:= .T.

Local cFilUsada 	:= ""
Local aInfoNova 	:= {}
Local nPos 			:= 0
Private cSitFunc	:= ""
Private lSaque		:= .F.
Private nBFgts		:= 	0
Private nFgtsR13	:=	0
Private aInssEmp 	:= 	Array(25,2)
Private aGpsVal 	:= 	{}
Private aCodFol 	:= 	{}
Private nDiasAfas	:=	0	
Private DiasTrab	:=	30
Private cDiasAfas	:=	""
Private aMovimento  :=	{}
Private cFPAS		:=	""
Private aTotal		:= array(6)
//--Dados Filial Responsalvel Centralizadora CGC e Tipo
Private aInforesp 	:= {}
Private nInssPF		:= 0
Private nInssPJ		:= 0
Private nValComps	:= 0
Private cPerIniCmp	:= ""
Private cPerFimCmp	:= ""
Private lGps		:= .T.
Private aTipo32		:= {}
Private nBInssPro	:=	0
              

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis utilizadas no ponto de entrada GPM610TP20³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cFPAS_Tom	:= ""
Private	cTerc_Tom	:= ""
Private	cSimp_Tom	:= ""
Private	nRAT_TOM	:= 0
Private	cCnae_Tom	:= ""
Private lGRRF 		
Private	cNome_Tom	:= ""
Private	cEnder_Tom	:= ""
Private	cBairro_Tom	:= ""
Private	cCep_Tom	:= ""
Private	cMunic_Tom	:= ""
Private	cEstado_Tom	:= ""
Private cTipo_Tom   := ""
Private cInsc_Tom   := space(14)


Private aGerou30	:= {}

afill(aTotal,0)

If !fInfo(@aInfoResp,substr(cFilResp,3,FWGETTAMFILIAL),Substr(cFilResp,1,2))
	Return .T.
EndIf
// Tipo de inscricao da Empresa Responsalvel / CGC
If aInfoResp[15] == 1			// CEI
	cInfoResp	:= "2"
	cInscResp	:= aInfoResp[08]
ElseIf aInfoResp[15] == 3		// CPF
	cInfoResp	:= "3"
	cInscResp	:= aInfoResp[08]
Else
	cInforesp	:= "1"		// CGC/INCRA
	cInscResp	:= aInfoResp[08]
EndIf

aFill(aTotRegs,0)     

//-- Traz a tabela de Codigo de Movimentacao
fMoviment(@aMovimento)

If cRecol == "650" .and. nDissidio == 1 .and. MesAno(dAuxPar01) >= "200508" .and. MesAno(dAuxPar01)<= "200703"
	cArqDbf	:= 'DISS'+FwCodEmp("SM0")+cFilAnt + GetDBExtension()
	If !File( cArqDbf )
		Aviso("Atencao","Dissidio não foi calculado",{"OK"})
   		Return    
	Else
		DbUseArea( .T.,__LocalDriver , cArqDbf, 'TRB', .T. )
		If lRat
			IndRegua( 'TRB', FileNoExt(cArqDBF)+"1", cIndCon1,,, "Selecionando Registro" ) 
		Else
			IndRegua( 'TRB', FileNoExt(cArqDBF)+"1", cIndCond,,, "Selecionando Registro" ) 
		EndIf
	EndIf
EndIf		
If lRat
	GPProcRegua(SRC->(RecCount()))
	cAlias:= "SRC"
Else
	GPProcRegua(SRA->(RecCount()))
	cAlias:= "SRA"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega os Filtros                                 	 	     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSraFilter	:= GpFltAlsGet( aRetFiltro , "SRA" )
cSrcFilter	:= GpFltAlsGet( aRetFiltro , "SRC" )
cSI3Filter	:= GpFltAlsGet( aRetFiltro , "SI3" )

While (cAlias)->( !Eof() ) .And. &cInicio <= cFim
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Aborta o Processamento                             	 	     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAbortPrint
		Exit
	Endif

	// Ratear por CC
	If lRat
		cCusto := SRC->RC_CC
		dbSelectArea("SRA")
		dbSetOrder(1)
		If !dbSeek(SRC->RC_FILIAL+SRC->RC_MAT)
			If aTotRegs[1]== 0
				cLog := "Consta na movimentacao mensal mas nao consta no cadastro de Funcionarios" //
				Aadd(aTitle,cLog)  
				Aadd(aLog,{})
				aTotRegs[1] := len(aLog)
		    EndIf
			Aadd(aLog[aTotRegs[1]],"Nao enviado(s) - Matricula: "+SRC->RC_FILIAL+"-"+SRC->RC_MAT)  //
			SRC->(dbskip())
			Loop
		EndIf				
	Else
		cCusto := SRA->RA_CC
	EndIf

	//--Verifica a situacao no mes de processamento                             
	cSitFunc := SRA->RA_SITFOLH
	If SRA->RA_SITFOLH == "D" .And. MesAno(SRA->RA_DEMISSA) > MesAno(dAuxPar01)
		cSitFunc := " "
	Endif	
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se a geracao for de meses ja fechados, e o funcionario estiver demitido ou  ³
	//³transferido de filial, usar o centro de custo do cadastro de funcionario.   ³
	//³( No caso do funcionario estar transferido,ele nao tera lancamentos no SRC )³
	//³----------------------------------------------------------------------------³
	//³Se nao estiver demitido, usar o centro de custo do primeiro lancamento do   ³
	//³mes, pois como nao foi escolhida a opcao "rateado" entende-se que todos os  ³
	//³lancamentos foram feitos no mesmo centro de custo.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lRat .and. MesAno(dAuxPar01) < GetMv( "MV_FOLMES",,Space(06) ) .and. cSitFunc # "D" 
	   cCusto	:= FDesc("SRC",SRA->RA_MAT,"SRC->RC_CC",20,SRA->RA_FILIAL)
	EndIf

	GPIncProc(SRA->RA_FILIAL+" - "+SRA->RA_MAT+" - "+SRA->RA_NOME)

	If nDemitido == 1 .and. cSitFunc #"D"
		FTesta(cAuxAlias,lRat,SRC->RC_FILIAL,cCusto,SRA->RA_MAT)
		Loop
	EndIf                 
		
	// Recolhimento de dissidio coletivo ou de reclamatoria trabalhista
	If cRecol == "650" .and. (nDissidio == 2)
		If cSitFunc # "D"
			If aTotRegs[2]== 0
				cLog := "Demitidos nao constam na SEFIP para o Codigo de Recolhimento 650" //
				Aadd(aTitle,cLog)  
				Aadd(aLog,{})
				aTotRegs[2] := len(aLog)
		    EndIf
			Aadd(aLog[aTotRegs[2]],SRA->RA_FILIAL+"-"+SRA->RA_MAT+" - "+SRA->RA_NOME) 
			FTesta(cAuxAlias,lRat,SRC->RC_FILIAL,cCusto,SRA->RA_MAT)
			Loop
		EndIf
	EndIf
    //--Verifica se tem codigo de Saque de FGTS
	lSaque	:= VerCodSaq(SRA->RA_FILIAL,SRA->RA_MAT,SRA->RA_DEMISSA,@lGRRF)
	
	//Somente Rescisao Complementar
	If lOnlyComp  
	    If (cSitFunc <> "D") .or. (MesAno(SRA->RA_DEMISSA) >= MesAno(dAuxPar01) ) 	
			If (cSitFunc == "D")
				If aTotRegs[3]== 0
					cLog := "Somente com Rescisao Complementar - Mes/Ano de demissao maior/igual a data de referencia" //"Somente com Rescisao Complementar - Mes/Ano de demissao maior/igual a data de referencia"
					Aadd(aTitle,cLog)  
					Aadd(aLog,{})
					aTotRegs[3] := len(aLog)
			    EndIf
				Aadd(aLog[aTotRegs[3]],"Nao Enviado(s) - "+ SRA->RA_FILIAL+"-"+SRA->RA_MAT+" - "+SRA->RA_NOME)  //
			EndIf
			FTesta(cAuxAlias,lRat,SRC->RC_FILIAL,cCusto,SRA->RA_MAT)
			Loop
		EndIf                 
	Else
		If (cSitFunc = "D" .And. MesAno(SRA->RA_DEMISSA) < MesAno(dAuxPar01) .And. nRescComp = 4) .or. ;
		   (cSitFunc = "D" .And. MesAno(SRA->RA_DEMISSA) = MesAno(dAuxPar01) .And. nRescMes = 4 ) .or. ; 
		   (cSitFunc = "D" .And. MesAno(SRA->RA_DEMISSA) = MesAno(dAuxPar01) .And. (nRescMes = 1 .and. lSaque )) .or. ;//	a Pedido com codigo de Saque de FGTS
		   (cSitFunc = "D" .And. MesAno(SRA->RA_DEMISSA) = MesAno(dAuxPar01) .And. (nRescMes = 2 .and. !lSaque ))      // Por Dispensa e sem codigo de Saque de FGTS
		
			FTesta(cAuxAlias,lRat,SRC->RC_FILIAL,cCusto,SRA->RA_MAT)
			Loop
		Endif
	EndIf       
	
	If (cSitFunc = "D") .And. (MesAno(SRA->RA_DEMISSA) < MesAno(dAuxPar01)) .And. (nRescComp # 4)   
		If (nRescComp = 1 .and. lSaque ) .or. ;	// a Pedido com codigo de Saque de FGTS
		   (nRescComp = 2 .and. !lSaque )       	// Por Dispensa e sem codigo de Saque de FGTS
			FTesta(cAuxAlias,lRat,SRC->RC_FILIAL,cCusto,SRA->RA_MAT)
			Loop
		Endif	
	EndIf
	// Nao Gerar para Funcionarios com situacao T=Transferido
	If cSitFunc $ "E,T"
		If aTotRegs[4]== 0
			cLog := "Nao Enviado(s) - Transferido(s): " //
			Aadd(aTitle,cLog)  
			Aadd(aLog,{})
			aTotRegs[4] := len(aLog)
	    EndIf
		Aadd(aLog[aTotRegs[4]],SRA->RA_FILIAL+"-"+SRA->RA_MAT+" - "+SRA->RA_NOME) 
		FTesta(cAuxAlias,lRat,SRC->RC_FILIAL,cCusto,SRA->RA_MAT)
		Loop
	EndIf

	// Nao gerar conforme o parametro Funcionario De/Ate
	If SRA->RA_MAT < cMatDe .Or. SRA->RA_MAT > cMatAte
		FTesta(cAuxAlias,lRat,SRC->RC_FILIAL,cCusto,SRA->RA_MAT)
		Loop
	EndIf

 	If !Empty( cSraFilter )
 		If !( &( cSraFilter ) )
 			FTesta(cAuxAlias,lRat,SRC->RC_FILIAL,cCusto,SRA->RA_MAT)
			Loop
 		EndIf
 	EndIf	
	//-- Nao Gerar Para as Categoria Estagiario
	If SRA->RA_CATFUNC $ "E*G"
		If aTotRegs[5]== 0
			cLog := "Nao Enviado(s) - Estagiario: " //
			Aadd(aTitle,cLog)  
			Aadd(aLog,{})
			aTotRegs[5] := len(aLog)
	    EndIf
		Aadd(aLog[aTotRegs[5]],SRA->RA_FILIAL+"-"+SRA->RA_MAT+" - "+SRA->RA_NOME) 
		FTesta(cAuxAlias,lRat,SRC->RC_FILIAL,cCusto,SRA->RA_MAT)
		Loop
	EndIf

	//-- Pis em branco
	If Empty(SRA->RA_PIS)
		If aTotRegs[6]== 0
			cLog := "Nao Enviado(s) - "+"PIS INVALIDO"        //###  
			Aadd(aTitle,cLog)  
			Aadd(aLog,{})
			aTotRegs[6] := len(aLog)
	    EndIf
		Aadd(aLog[aTotRegs[6]],SRA->RA_FILIAL+"-"+SRA->RA_MAT+" - "+SRA->RA_NOME) 
		FTesta(cAuxAlias,lRat,SRC->RC_FILIAL,cCusto,SRA->RA_MAT)
		Loop
	EndIf

	//-- Admitido apos a data de referencia
	If SRA->RA_ADMISSA > dAuxpar01 .OR. SRA->RA_OPCAO > dAuxpar01
		If aTotRegs[7]== 0
			cLog := "Nao Enviado(s) - Admitido apos a data de referencia" //
			Aadd(aTitle,cLog)  
			Aadd(aLog,{})
			aTotRegs[7] := len(aLog)
	    EndIf
		Aadd(aLog[aTotRegs[7]],SRA->RA_FILIAL+"-"+SRA->RA_MAT+" - "+SRA->RA_NOME)   
		FTesta(cAuxAlias,lRat,SRC->RC_FILIAL,cCusto,SRA->RA_MAT)
		Loop
	EndIf

	If cCusto < cCcDe .Or. cCusto > cCcAte
		dbSelectArea(cAuxAlias)
		dbSkip()
		Loop
	EndIf

	//-- Tipo de Contrato
	If !(SRA->RA_TPCONTR$ cTpC)
		dbSelectArea(cAuxAlias)
		dbSkip()
		Loop
	EndIf

	//--Centro de custo  
	If (nFilCc == 2) .And. !FTomador(SRA->RA_FILIAL,cCusto,nComTomador,nTpTomador) 
		dbSelectArea(cAuxAlias)
		dbSkip()
		Loop
	EndIf

	//--Busca a categoria do Funcionario	
	cCateg	:=	FCateg(nFgts)

	If cRecol $ "130" .and. cCateg # "02"
		dbSelectArea(cAuxAlias)
		dbSkip()
		Loop
	EndIf


	nDiasAc 	:= 0
	nDiasAd 	:= 0
	nDiasMat	:= 0
	DiasTrab	:= 30
	aAfast  	:= {}

	If l1Vez
		l1Vez:= .F.
		cFilAnterior := SRA->RA_FILIAL
		cCustoAux	 := cCusto  

		//-- Carrega o aInfo com os dados do SIGAMAT.EMP
		If !fInfo(@aInfo,SRA->RA_FILIAL)
			Exit
		EndIf

		// Carrega Percentuais de INSS Empresa
		If !fInssEmp(SRA->RA_FILIAL,@aInssEmp,.T.,AnoMes(dAuxPar01))
			Help(' ',1,"GR240SEMP")
			Return .F.
		EndIf
        
		If aInfo[15] == 1			// CEI
			cInfo := "2"
		Else
			cInfo := "1"			// CGC/CNPJ
		EndIf

		cAuxCGC := aInfo[08]
	
		// Carrega o aCodFol
		If !FP_CODFOL(@aCodFol,SRA->RA_FILIAL)
			Exit
		EndIf        

	EndIf

	//-- Funcao que retorna Dias trabalhados e Afastados no Mes
	FDiasAfast(@nDiasAfas,@DiasTrab,dAuxPar01,.F.)

	If cFilAnterior # SRA->RA_FILIAL
		// Guarda informacoes da filial anterior
		cAuxFil		:= cFilAnterior

		//--Quando filial for Cei e Centraliza filiais deve gerar filial responsalvel 		
		If nCentra = 1 .And. cInfo = "2"
			aAuxInfo 	:= aClone(aInfoResp)
			cAuxInfo	:= cInfoResp
		Else	
			aAuxInfo	:= aClone(aInfo)
			cAuxInfo	:= cInfo
		Endif	
		nAuxSal		:= nSalFam
		nAuxFgts	:= nFgts
		
		//Quando for competencia 12 calcular o Valor Devido a Previdencia do 13o.
		nValDPrev 	:= 0
		If Month(dAuxPar01) = 12
			fCValDev(nTB13Inss,aInssEmp,nTotAci,nT13Inss,0.00,@nValDPrev)
		Endif	

		// Carrega o aInfo com os dados do SIGAMAT.EMP
		If !fInfo(@aInfo,SRA->RA_FILIAL)
			Exit
		EndIf

		// Carrega Percentuais de INSS Empresa
		If !fInssEmp(SRA->RA_FILIAL,@aInssEmp,.F.,AnoMes(dAuxPar01))
			Help(' ',1,"GR240SEMP")
			Return .F.
		EndIf

		If aInfo[15] == 1
			cInfo := "2"
		Else
			cInfo := "1"
		EndIf

		If cAuxCgc # aInfo[08]  //Quebra Filial
			//-- Verificando o Tamanho do FPAS
			If Substr(aInfo[17],1,1) == "0"
				cFPAS	:= Substr(aInfo[17],2,3)
			Else
				cFPAS	:= Substr(aInfo[17],1,3)
			EndIf
           
			//--Geracao do registro de tomador de servico a cada mudanca de cgc
			fGera20(cCusto,@cCustoAux,aAuxInfo,@cInsc,@cTipo,@n20SalFamAnt,@nT13Inss,@nTB13Inss,@nTotAci,@cAuxFil,SRA->RA_FILIAL,aCodFol,lRat,@n20SalFam)
		
			If lGera30  
				
				If Ascan(aGerou30,{|x|x[1]==cFilAnterior})== 0
				
					cFilUsada := cFilAnterior
					aInfoNova := {}
					nPos := Ascan(aGerou30,{|x|x[2]== aAuxInfo[08]})
				
				    If nPos > 0
						If cFilAnterior # aGerou30[nPos,1]
							cFilUsada := aGerou30[nPos,1]
							If !fInfo(@aInfoNova,cFilUsada)
					   			Exit
						   	EndIf	
						Else
						   	aInfoNova := aclone(aAuxInfo)
						EndIf
				    Else
					    aInfoNova := aclone(aAuxInfo)
			    	EndIf
					DBF_TIPO10(cFilUsada,aInfoNova,cInfo,nSalFam,nT13Inss,nSalMat1,nValDPrev)			    	
				Else
					DBF_TIPO10(cFilAnterior,aAuxInfo,cAuxInfo,nSalFam,nT13Inss,nSalMat1,nValDPrev)
				EndIf
					
				nSalMat1 := 0
				lJaGerou := .T.
				aGerou30 := {}
				//Carrega valores da GPS
				fGPSVal(cFilAnterior,cAnoMesGps,@aGPSVal,cTpc)
				
				nVlCooper := nValRec := nValProPf := nValProPj := nValComps := 0
				cPerIniCmp:= cPerFimCmp := ""

				For nx := 1 to len(aGpsVal)
					lGPS := If(!empty(aGpsVal[nX,1]),(alltrim(aGpsVal[nX,1])>= alltrim(cCcDe) .Or. alltrim(aGpsVal[nX,1]) <= alltrim(cCcAte)),.T.)
				 	If lGPS
				 		lSI3 := .T.
				 		If !Empty( cSi3Filter )
				 			SI3->(dbSeek(cFilAnterior+alltrim(aGpsVal[nX,1]))) 
							lSI3 := &( cSi3Filter )
						EndIf
				 		
				 		If lSI3
							If aGpsVal[nX,02] == aCodFol[313,1]		
								nVlCooper += aGpsVal[nx,03] // Base da Cooperativa
							ElseIf aGpsVal[nX,02] == aCodFol[198,1]
						 		nValRec	  += aGpsVal[nX,03] // Base da Receita	
							ElseIf aGpsVal[nX,02] == aCodFol[315,1]       
								nValProPf += aGpsVal[nX,03] // Valor Producao Rural P.Fisica
							ElseIf aGpsVal[nX,02] == aCodFol[316,1]       
								nValProPj += aGpsVal[nX,03] // Valor Producao Rural P.Juridica
							ElseIf aGpsVal[nX,02] == aCodFol[584,1]       
								nValComps += aGpsVal[nX,05] // Valor da Compensacao da GPS
								cPerIniCmp:= aGpsVal[nX,08]	// Ano/mes do periodo inicial de Compensacao
								cPerFimCmp:= aGpsVal[nX,09]	// Ano/mes do periodo final de Compensacao
					 		EndIF	
					 	EndIf	
				 	EndIF	
				Next nX
				If (nDeduc # 0) .Or. (nValRec # 0) .Or. (nValProPf # 0) .Or. (nValproPj # 0) .or. (nVlCooper#0);
				 	.Or. (nValComps#0) .or. cRecol$ '650#660'
					DBF_TIPO12 (aAuxInfo,cAuxInfo,nAuxFgts)
				EndIf 
				lGera30 := .F.     
			Endif	
			// Zerar Variaveis para o Proximo Tipo 10
			nSalFam		:=0
			nDeduc 		:=0
			nFgts		:=0        
			nT13Inss	:=0
			nTB13Inss	:=0
			nTotAci		:=0
			cAuxCgc 	:=aInfo[08]
			
		EndIf

		// Carrega o aCodFol
		If !FP_CODFOL(@aCodFol,SRA->RA_FILIAL)
			Exit
		EndIf

		cFilAnterior:= SRA->RA_FILIAL
		
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa Acumuladores de 13§ e Juros						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nFgts		:=0
	nB13Fgts 	:=0
	nJam 		:=0
	nB13Inss	:=0
	nSc13Sal	:=0
	nB13InRc	:=0
	nBInss		:=0
	nBInssPro	:=0
	nValor247	:=0
	nBFgts		:=0
	nFgtsRes 	:=0
	nSalMat  	:=0
	nFgtsR13	:=0
	nInss		:=0
	n13Inss		:=0
	nInssOutr	:=0	
	nBinssPF	:=0
	nBinssPJ	:=0
	nInssPF		:=0
	nInssPJ		:=0	 
	lGera32  	:=.F.
	nComissao	:= 0

	// aCodFol[13]	= Base INSS Folha ate o limite s/13
	// aCodFol[14]	= Base INSS Folha acima do limite s/13
	// aCodFol[17]	= Base FGTS
	// aCodFol[18] 	= FGTS Deposito
	// aCodFol[19]	= Base INSS 13o ate o limite	
	// aCodFol[20]	= Base INSS 13o acima do limite	
	// aCodFol[34]	= Salario Familia
	// aCodFol[40]	= Salario Maternidade
	// aCodFol[64]	= INSS Folha
	// aCodFol[65]	= INSS Ferias
	// aCodFol[70]	= INSS 13o
	// aCodFol[108] = Base FGTS 13o Salario
	// aCodFol[119]	= FGTS Pago na Rescisao
	// aCodFol[120] = FGTS artigo 22 pagamento rescisao
	// aCodFol[214]	= FGTS 13o. na Rescisao
	// aCodFol[221] = Sal.Contr.Aut./Pro-Lab. 15%
	// aCodFol[225] = Sal.Contr.Aut./Pro-Lab. 20%
	// aCodFol[288] = Salario de Contribuicao Inss Outras Empresas
	// aCodFol[289] = Desconto do Inss Outras Empresas
	// aCodFol[350]	= Base INSS autonomo P.Fisica
	// aCodFol[351] = Valor INSS autonomo P.Fisica
	// aCodFol[353] = Base INSS autonomo P.Juridica
	// aCodFol[354] = Valor INSS autonomo P.Juridica

	If nTipo == 1			// Tipo : 1-Folha		2-13o salario
		
		If cRecol == "650" .and. nDissidio == 1 .and. MesAno(dAuxPar01) >= "200508" .and. MesAno(dAuxPar01)<= "200703"
			dbSelectArea( 'TRB' )
         	afunc := {}
			TRB->( dbSeek(SRA->RA_FILIAL+SRA->RA_MAT))
			While TRB->( !Eof() ) .And. (!lRat .And. TRB->TRB_FILIAL+TRB->TRB_MAT == SRA->RA_FILIAL+SRA->RA_MAT) .Or.;
								(lRat .And. TRB->TRB_FILIAL+TRB->TRB_CC+TRB->TRB_MAT == SRA->RA_FILIAL+cCusto+SRA->RA_MAT)

				If TRB->TRB_COMPL_ == "S" .and. TRB->TRB_VB # "000" .and. ;
					Substr( TRB_DATA, 3, 4 ) + Substr( TRB_DATA, 1, 2 ) == MesAno(dAuxpar01) .and.;
					(	TRB->TRB_VERBA == aCodFol[337,1] .OR. ;                
						TRB->TRB_VERBA == aCodFol[338,1] .OR. ;                
						TRB->TRB_VERBA == aCodFol[339,1] .OR. ;                  
						TRB->TRB_VERBA == aCodFol[340,1] .OR. ;                
						TRB->TRB_VERBA == aCodFol[398,1] .OR. ;                
						TRB->TRB_VERBA == aCodFol[399,1] )
				   
				   	lConsidera := If( TRB->(FieldPos("TRB_INTEGR")) # 0,TRB->TRB_INTEGR == "S",.T. )
				   	If lConsidera
						nLinha := Ascan( aFunc, { | X | X[1]+X[2]+X[3]+X[4] = SRA->RA_FILIAL+SRA->RA_MAT+TRB_VERBA+TRB_CC } )
					 
					 	If nLinha  > 0
					 		aFunc[nLinha,5] += TRB_VALOR
					 	Else      
			 				Aadd( aFunc, { SRA->RA_FILIAL,SRA->RA_MAT,TRB->TRB_VERBA,TRB->TRB_CC, TRB->TRB_VALOR } )
						EndIf         
					EndIf	
				EndIf
				TRB->( dbSkip() )
			EndDo			
		 	
           	For nI := 1 to len(aFunc)
            
				If aFunc[nI,3] == aCodFol[337,1]     //Bs FGTS Dissidio
					nBFgts += Round(aFunc[nI,5],2)
				EndIf                 
				
				If aFunc[nI,3] == aCodFol[338,1]     //aCodFol[341,1]   //Bs INSS Dissidio
					nBInss += Round(aFunc[nI,5],2)
				EndIf
				
				If aFunc[nI,3] == aCodFol[339,1]     //Vl FGTS
					nFgts += Round(aFunc[nI,5],2)
				EndIf
				
				If aFunc[nI,3] == aCodFol[340,1]      //Vl INSS
					nInss  += Round(aFunc[nI,5],2)   
				EndIf 
				
				If aFunc[nI,3] == aCodFol[399,1]       //aCodFol[402,1]  // Bs Inss Dif. Dissidio 13o.(Provento)
					nB13Inss += Round(aFunc[nI,5],2)
					nB13InRc += Round(aFunc[nI,5],2)
				EndIf
				
				If aFunc[nI,3] == aCodFol[398,1]       //Bs FGTS 13o. dif. Dissidio
					nB13Fgts += Round(aFunc[nI,5],2)
				EndIf
				
				If aFunc[nI,3] == aCodFol[401,1]       //Vl Inss 13o. dif. Dissidio
					n13Inss += Round(aFunc[nI,5],2)
				EndIf

            Next
		Else
			dbSelectArea("SRC")
			If lRat
				dbSetOrder(2)
			Else
				dbSetOrder(1)
				dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
			EndIf

			While !Eof() .And. (!lRat .And. SRC->RC_FILIAL+SRC->RC_MAT == SRA->RA_FILIAL+SRA->RA_MAT) .Or.;
								(lRat .And. SRC->RC_FILIAL+SRC->RC_CC+SRC->RC_MAT == SRA->RA_FILIAL+cCusto+SRA->RA_MAT)
	
	 			If !Empty( cSrcFilter )
	 				If !( &( cSrcFilter ) )
						dbSelectArea("SRC")
						dbSkip()
						Loop
	 				EndIf
			 	EndIf	
	
				//-- Nao Considerar C.Custo com CEI Para Rateado sem Cei
				If nFilCc == 2 .And. nComTomador == 2 .And. nRateio == 1
					If !FTomador(SRA->RA_FILIAL,SRC->RC_CC,nComTomador,nTpTomador)
						dbSelectArea("SRC")
						dbSkip()
						Loop
					Endif
				Endif  
				
				
				If nDissidio == 1     // Dissidio Retroativo
					If SRC->RC_PD == aCodFol[337,1]        //Bs FGTS Dissidio
						nBFgts += Round(SRC->RC_VALOR,2)
					EndIf
					
					If SRC->RC_PD == aCodFol[338,1]       //aCodFol[341,1]   //Bs INSS Dissidio
						nBInss += Round(SRC->RC_VALOR,2)
					EndIf
					
					If SRC->RC_PD == aCodFol[339,1]        //Vl FGTS
						nFgts += Round(SRC->RC_VALOR,2)
					EndIf
					
					If SRC->RC_PD == aCodFol[340,1]         //Vl INSS
						nInss  += Round(SRC->RC_VALOR,2)   
					EndIf 
					
					If SRC->RC_PD == aCodFol[399,1]        //aCodFol[402,1]  // Bs Inss 13o. Dif. Dissidio (Provento)
						nB13Inss += Round(SRC->RC_VALOR,2)
						nB13InRc += Round(SRC->RC_VALOR,2)
					EndIf

					If SRC->RC_PD == aCodFol[398,1]         //Bs FGTS 13o. dif. Dissidio
						nB13Fgts += Round(SRC->RC_VALOR,2)
					EndIf  

					If SRC->RC_PD == aCodFol[401,1]         // Vl Inss 13o. Dif. Dissidio
						n13Inss += Round(SRC->RC_VALOR,2)
					EndIf	

	            Else
					If SRC->RC_PD == aCodFol[13,1] .Or.	SRC->RC_PD == aCodFol[14,1]  
						nBInss += Round(SRC->RC_VALOR,2)										
					EndIf	
	  
					If ( SRC->RC_PD == aCodFol[221,1] .Or. SRC->RC_PD == aCodFol[225,1] ) // ProLabore
						nBInssPro += Round(SRC->RC_VALOR,2)										
					EndIf
	
					If SRC->RC_PD == aCodFol[17,1]
						nBFgts += Round(SRC->RC_VALOR,2)
					EndIf
					
					If SRC->RC_PD == aCodFol[18,1]
						nFgts += Round(SRC->RC_VALOR,2)
					EndIf    
					
					If SRC->RC_PD == aCodFol[64,1]  .Or. ;
						SRC->RC_PD == aCodFol[65,1] .Or. ;
						SRC->RC_PD == aCodFol[70,1]
						nInss  += Round(SRC->RC_VALOR,2)   
					EndIf

					If SRC->RC_PD == aCodFol[19,1] .Or.;  	//Base Inss Ate Lim p/ 13o. Sal.
						SRC->RC_PD == aCodFol[20,1]			//Base Inss Aci Lim p/ 13o. Sal.
						nB13Inss += Round(SRC->RC_VALOR,2)
						nB13InRc += Round(SRC->RC_VALOR,2)
					EndIf
				
					If SRC->RC_PD == aCodFol[214,1]    //valor do FGTS na rescisao
						nFgtsR13 += Round(SRC->RC_VALOR,2)	
					EndIf
		
					If SRC->RC_PD $ aCodFol[34,1]+"*"+cSalFamDed
						nSalFam 	+= Round(SRC->RC_VALOR,2)
						n20SalFam 	+= Round(SRC->RC_VALOR,2)
					EndIf
		
					 If SRC->RC_PD == aCodFol[108,1] .or.  SRC->RC_PD == aCodFol[294,1]
						nB13Fgts += Round(SRC->RC_VALOR,2)
					EndIf
		
					If SRC->RC_PD == aCodFol[119,1] .Or. ;
						SRC->RC_PD == aCodFol[120,1] .or. ;
						SRC->RC_PD == aCodFol[214,1]					
						nFgtsRes += Round(SRC->RC_VALOR,2)
					EndIf
	
					If SRC->RC_PD $ aCodFol[040,1]+"*"+aCodFol[407,1]+"*"+cSalMatDed // 040 - Aux. Maternidade ##407 - Pagto Medias Auxilio Maternidade
						nSalMat += Round(SRC->RC_VALOR,2)
					EndIf
	
					If SRC->RC_PD == aCodFol[289,1] .or. ;  //Desconto do Inss Outras Empresas
						SRC->RC_PD == aCodFol[288,1]   		 //Salario de Contribuicao Inss Outras Empresas
						nInssOutr  += Round(SRC->RC_VALOR,2)   
					EndIf
					
					If SRC->RC_PD == aCodFol[350,1]  //Bs Inss Autonomo P.Fisica
						nBinssPF  += Round(SRC->RC_VALOR,2)   
					EndIf
					
					If SRC->RC_PD == aCodFol[351,1]  //Vl Inss Autonomo P.Fisica
						nInssPF  += Round(SRC->RC_VALOR,2)   
					EndIf
		
					If SRC->RC_PD == aCodFol[353,1]  //Bs. Inss Autonomo P. Juridica
						nBinssPJ  += Round(SRC->RC_VALOR,2)   
					EndIf
		
					If SRC->RC_PD == aCodFol[354,1]  //Vl Inss Autonomo P.Juridica
						nInssPJ  += Round(SRC->RC_VALOR,2)   
					EndIf

					If SRC->RC_PD == aCodFol[247,1]  // Desconto 2.Parcela 13.Salario
						nValor247  += Round(SRC->RC_VALOR,2)   
					EndIf
	            	
	            	If cSitFunc == "D" .AND. MesAno(SRA->RA_DEMISSA) < MesAno(dAuxPar01) .And. ;
	            		( SRC->RC_PD == aCodFol[121,1] .or. SRC->RC_PD ==aCodFol[122,1] .or.; //Comissoes
	            	 		SRC->RC_PD == aCodFol[165,1] .or. SRC->RC_PD == aCodFol[166,1] )
	            	 	nComissao	+= Round(SRC->RC_VALOR,2)   
					EndIf	            	 	
	            EndIf
	
				dbSelectArea("SRC")
				dbSkip()
			EndDo
		EndIf
			
		// Quando base de inss estiver zerada, nBInss, (id calculo 013 e 014), utilizar valor 
		// da base do pro-labore, nBInssProm (id calculo 221 ou 225).  
		// So terao valor nesta base os pro-labores e autonomos
		If  nBInss == 0
			nBInss += nBInssPro		
		EndIf	
	
		If nDissidio # 1
			FVerSRI(aCodFol,@nB13Inss,@nB13Fgts,@nSalMat,@n13Inss,@nSc13Sal,lRat,cCusto,lGRRF)		
		EndIf	
	Else							// 13o Salario
		If cRecol == "650" .and. nDissidio == 1  .and. MesAno(dAuxPar01) >= "200508" .and. MesAno(dAuxPar01)<= "200703"
			dbSelectArea( 'TRB' )
         	afunc := {}
			TRB->( dbSeek(SRA->RA_FILIAL+SRA->RA_MAT))
			While TRB->( !Eof() ) .And. (!lRat .And. TRB->TRB_FILIAL+TRB->TRB_MAT == SRA->RA_FILIAL+SRA->RA_MAT) .Or.;
								(lRat .And. TRB->TRB_FILIAL+TRB->TRB_CC+TRB->TRB_MAT == SRA->RA_FILIAL+cCusto+SRA->RA_MAT)

				If TRB->TRB_COMPL_ == "S" .and. TRB->TRB_VB # "000" .and. ;
					Substr( TRB_DATA, 3, 4 ) + Substr( TRB_DATA, 1, 2 ) == MesAno(dAuxpar01) .and.;
					(	TRB->TRB_VERBA == aCodFol[398,1] .OR. ;                
						TRB->TRB_VERBA == aCodFol[399,1] .OR. ;                
						TRB->TRB_VERBA == aCodFol[401,1] )
				   
				   	lConsidera := If( TRB->(FieldPos("TRB_INTEGR")) # 0,TRB->TRB_INTEGR == "S",.T. )
				   	If lConsidera                                         
						nLinha := Ascan( aFunc, { | X | X[1]+X[2]+X[3]+X[4] = SRA->RA_FILIAL+SRA->RA_MAT+TRB_VERBA+TRB_CC } )
					 
					 	If nLinha  > 0
					 		aFunc[nLinha,5] += TRB_VALOR
					 	Else      
			 				Aadd( aFunc, { SRA->RA_FILIAL,SRA->RA_MAT,TRB->TRB_VERBA,TRB->TRB_CC, TRB->TRB_VALOR } )
						EndIf         
					EndIf	
				EndIf
				TRB->( dbSkip() )
			EndDo			
		 	
           	For nI := 1 to len(aFunc)
            
				If aFunc[nI,3] == aCodFol[398,1] //Bs FGTS Dissidio 13o
					nB13Fgts += Round(aFunc[nI,5],2)
				EndIf
				If aFunc[nI,3] == aCodFol[399,1] //aCodFol[341,1]   //Bs INSS Dissidio 13o
					nB13Inss += Round(aFunc[nI,5],2)
				EndIf
				If aFunc[nI,3] == aCodFol[401,1]   //Vl INSS 13
					n13Inss  += Round(aFunc[nI,5],2)   
				EndIf 
            Next
        Else
			FVerSRI(aCodFol,@nB13Inss,@nB13Fgts,@nSalMat,@n13Inss,@nSc13Sal,lRat,cCusto,lGRRF)		
		EndIf	
	EndIf
	
	//--Verifica  se Demitidos em meses anteriores tem valor
	//--se nao tiver despreza o fucnionario
	If (nFgtsRes+nFgtsR13+nBFgts+nB13Fgts=0) .And. cSitFunc == "D" .AND. ;
	   MesAno(SRA->RA_DEMISSA) < MesAno(dAuxpar01) 
		n20SalFam 	:=	0
		FTesta(cAuxAlias,lRat,SRC->RC_FILIAL,cCusto,SRA->RA_MAT)
		Loop
	EndIf
        
	//Verificacao de Afastamento ou Demissao
	If Substr(cDataRef,4,2) # "13"

		//-- Se Gerou Tipo 30 Gera Tipo 32 e nao for 13o.
		If nTipo == 1   // Tipo 1-Folha/Ferias	   2-13o.Salario
			//--Monta Array com os Afastam. e Demitidos para Gerar Tipo-32
			cAuxCompet	:= Right(Str(Year(dAuxpar01)),4) + Substr(cDataRef,4,2)
			aAfast 		:= {}
			FMontaSR8(cAuxCompet,@aAfast,@cSitFunc,dAuxPar01)

			// Inclui codigo de afastamento "V3" para remuneração de comissao apos extincao de contrato de trabalho
    	   	If nComissao > 0
       			Aadd(aAfast,{SRA->RA_DEMISSA,"V3","A",0,.F.})
	       	EndIf
		
			//Somar Valor Salario Maternidade Iniciado Antes de 01/12/99 para
			//ser informado no registro 10
			cCateg	:=	FCateg(nFgts)
			For n:=1 to Len(aAfast)
			    If Substr(aAfast[n,2],1,1) == "Q"
			    	If !(Substr(aAfast[n,2],1,2) $ "Q1#Q3" .and. cCateg $ "03#05#11")
						nSalMat1 += nSalMat 
						Exit
					EndIf	
				Endif	
			Next n
			
		EndIf
	EndIf
                   
     lGera30Zerado := .F.   
	//--Verifica se funcionario tem Valores para a Sefip se nao tiver
	//--Despreza funcionario
	If nBInss+nBFgts+nB13Inss+nB13Fgts+nBinssPF+nBinssPJ = 0 .And. cSitFunc # 'D' .and. SRA->RA_CATFUNC # "A"
	
		lGera30Zerado :=  Ascan(aAfast, {|x|MesAno( x[1] ) == MesAno(dAuxPar01) })#0 .OR.;
							Ascan(aAfast, {|x|Substr( x[2],1,1) =="Z" })	# 0
	
		If !lGera30Zerado
			If aTotRegs[8]== 0
				cLog := "Nao Enviado(s) - Funcionario(s) sem valores para SEFIP" //"Nao Enviado(s) - Funcionario(s) sem valores para SEFIP"
				Aadd(aTitle,cLog)  
				Aadd(aLog,{})
				aTotRegs[8] := len(aLog)
		    EndIf
			Aadd(aLog[aTotRegs[8]],SRA->RA_FILIAL+"-"+SRA->RA_MAT+" - "+SRA->RA_NOME)   
			n20SalFam 	:=	0
			FTesta(cAuxAlias,lRat,SRC->RC_FILIAL,cCusto,SRA->RA_MAT)
			Loop
		EndIf
	Endif

	// Acumuladores para registro tipo 10 e 20
	nT13Inss  += n13inss
	nTB13inss += (nB13Inss - nB13InRc)
		
	// Calcular Valor Ac.trabalho Empresa B.Inss 13o.
	// somente na comperencia 12
	If StrZero(Year(dAuxPar01),4)+"12" == Mesano(dAuxPar01)
		nPercAcTrab := If (SRA->RA_TPCONTR$ " *1", aInssEmp[3,1] , aInssEmp[3,2])	
		fBuscaAci(@nPercAcTrab)
		nTotAci += nSc13Sal * nPercAcTrab
	Endif	
		
	//-- Quando teve afastamento por Licenca Maternidade
	If SRA->RA_SEXO == "F" .and. ( Substr(cDataRef,4,2) == "13" .or. cSitFunc $ "D")
		// Calculo de deducao 13 salario
		F13Sal(@nDeduc,nSalMat,aCodFol)
	EndIf
    
	//-- Alteracao nos dados cadastrais Nao Gerar para 13o.
	If nTipo == 1    // Tipo 1-Folha/Ferias	   2-13o.Salario
		If SRA->RA_ALTCP == "S" //Carteira de trabalho
			DBF_TIPO13(aInfo,cInfo,nFgts,"RA_NUMCP  ")
		ElseIf SRA->RA_ALTNOME == "S"	//Nome
			If SRA->(FieldPos("RA_NOMECMP")) # 0  
				DBF_TIPO13(aInfo,cInfo,nFgts,If(!empty(SRA->RA_NOMECMP),"RA_NOMECMP","RA_NOME   "))
			Else
				DBF_TIPO13(aInfo,cInfo,nFgts,"RA_NOME   ")
			EndIf	
		ElseIf SRA->RA_ALTPIS == "S" //PIS
			DBF_TIPO13(aInfo,cInfo,nFgts,"RA_PIS    ")
		ElseIf SRA->RA_ALTADM == "S"  //Data de Admissao
			DBF_TIPO13(aInfo,cInfo,nFgts,"RA_ADMISSA")
		EndIf
		If SRA->(FieldPos("RA_ALTCBO")) # 0  
			If SRA->RA_ALTCBO =="S"
				DBF_TIPO13(aInfo,cInfo,nFgts,"RA_CBO    ")
			EndIf	
		EndIf
		If SRA->(FieldPos("RA_ALTNASC")) # 0  
			If SRA->RA_ALTNASC =="S"
				DBF_TIPO13(aInfo,cInfo,nFgts,"RA_NASC")
			EndIf	
		EndIf
		// Inclusao/Alteracao Endereco do trabalhador (so pode haver uma por trabalhador)
		// Qdo for funcion rio novo deve gerar automaticamente o TIPO14
		cCompet:= Right(Str(Year(dAuxpar01)),4) + Substr(cDataRef,4,2)
		If SRA->RA_ALTEND == "S" .Or. MesAno(SRA->RA_ADMISSA) == cCompet .and. Substr(cDataRef,4,2)# "13"
			//-- Quando estiver gerando a sefip verificamos se o registro do tipo 14 ja foi gerado
			//-- alguma vez para nao haver mais que um registro do tipo 14 por funcionario.
		
			If Ascan(aRegsTip14,{|X| X[1] == SRA->RA_PIS}) == 0
				DBF_TIPO14(aInfo,cInfo,nFgts)
				Aadd(aRegsTip14,{SRA->RA_PIS})
			Endif
		
		EndIf
	Endif
    
    //--Verifica se deve Gerar Registro 20 - Tomador de Servico na quebra de C.Custo
	fGera20(cCusto,@cCustoAux,aInfo,@cInsc,@cTipo,@n20SalFamAnt,@nT13Inss,@nTB13Inss,@nTotAci,@cAuxFil,cFilAnterior,aCodFol,lRat,@n20SalFam)
    
	// Registro do Trabalhador
	If nTipo == 1  // Tipo 1-Folha/Ferias	   2-13o.Salario
		lGera32 := DBF_TIPO30(aInfo,cInfo,nFgts,cTipo,cInsc,nB13Inss,nBInss,nB13Fgts,nInss,nB13InRc,aAfast,@aLog,@aTitle,@aTotRegs,nInssOutr,cCusto,nBinssPF,nBinssPJ,n13Inss,nValor247)
	Else
		If nB13Inss # 0
			lGera32 := DBF_TIPO30(aInfo,cInfo,nFgts,cTipo,cInsc,nB13Inss,nBinss,nB13Fgts,nInss,nB13InRc,aAfast,@aLog,@aTitle,@aTotRegs,nInssOutr,cCusto,nBinssPF,nBinssPJ,n13Inss,nValor247)
		EndIf
	EndIf
	//--Se Gerou 1 registro 30 muda variavel para poder gerar o resgistro 10
	If ! lGera30 .And. lGera32 
		lGera30 := .T.
	Endif	
		
	//-- Se nao for 13o.
	//-- Passa a Gerar Registro 32 sem ter o reg. 30  em 26/09/00
	If  nTipo == 1   // Tipo 1-Folha/Ferias	   2-13o.Salario
		DBF_TIPO32(aInfo,cInfo,nFgts,cTipo,cInsc,nFgtsRes,aAfast,@aLog,@aTitle,@aTotRegs,lGera32)
	EndIf

	If !lRat
		dbSelectArea(cAuxAlias)
		dbSkip()
	EndIf
EndDo

//-- Limpa o array de ocorrencias do tipo 14.
aRegsTip14	:= {}

If !l1Vez
	If lRat
		cCusto := SRC->RC_CC
 	Else
		cCusto := SRA->RA_CC
	EndIf

	If Len(aInfo) > 0 .And. aInfo[15] # Nil
		 //--Verifica se deve Gerar Registro 20 - Tomador de Servico                  
		fGera20(cCusto,@cCustoAux,aInfo,@cInsc,@cTipo,@n20SalFamAnt,@nT13Inss,@nTB13Inss,@nTotAci,@cAuxFil,SRA->RA_FILIAL,aCodFol,lRat,@n20SalFam)
		// Gerar o tipo 10 para a ultima empresa
		If aInfo[15] == 1		// CEI
			cInfo := "2"
		Else
			cInfo := "1"		// CGC
		EndIf
		
		//-- Verificando o Tamanho do FPAS
		If empty( cFPAS_Tom )
			If Substr(aInfo[17],1,1) == "0"
				cFPAS	:= Substr(aInfo[17],2,3)
			Else
				cFPAS	:= Substr(aInfo[17],1,3)
			EndIf	
		EndIf
		     
		//Quando for competencia 12 calcular o Valor Devido a Previdencia do 13o.
		nValDPrev 	:= 0
		If Month(dAuxPar01) = 12
			fCValDev(nTB13Inss,aInssEmp,nTotAci,nT13Inss,0.00,@nValDPrev)
		Endif	
                
		//-- So gera o 10 se gerou o 30 para algum funcionario
		If lGera30	  
			//--Quando Filial For Cei e Centraliza deve gerar Filial Responsavel
			If nCentra == 1 .And. cInfo == "2"
				aInfo := aInforesp               
				cInfo := cInforesp
			Endif	
            
			If Ascan(aGerou30,{|x|x[1]==cFilAnterior})== 0
				
				cFilUsada := cFilAnterior
				aInfoNova := {}
				nPos := Ascan(aGerou30,{|x|x[2]== aInfo[08]})
				
			    If nPos > 0
					If cFilAnterior # aGerou30[nPos,1]
						cFilUsada := aGerou30[nPos,1]
						If !fInfo(@aInfoNova,cFilUsada)
					   		//	Exit
					   	EndIf	
					Else
					    aInfoNova := aclone(aInfo)
					EndIf
			    Else
				    aInfoNova := aclone(aInfo)
			    EndIf       
			    
				DBF_TIPO10(cFilUsada,aInfoNova,cInfo,nSalFam,nT13Inss,nSalMat1,nValDPrev)			    	
			Else
				DBF_TIPO10(cFilAnterior,aInfo,cInfo,nSalFam,nT13Inss,nSalMat1,nValDPrev)
			EndIf	
			nSalMat1 := 0
		Endif	
	Else    
		If aTotRegs[9]== 0
			cLog :="Filial Invalida" //
			Aadd(aTitle,cLog)  
			Aadd(aLog,{})
			aTotRegs[9] := len(aLog)
	    EndIf
		Aadd(aLog[aTotRegs[9]],"Filial nao existe no Arquivo de Empresas :"+cFilAnterior)// 
	Endif				
	
	// Zerar Acumuladores
	nSalMat1 	:= 0
	nSalFam     := 0
	nT13Inss    := 0
	nTB13Inss   := 0
	nTotAci		:= 0

	//Carrega valores da GPS
	fGPSVal(cFilAnterior,cAnoMesGps,@aGPSVal,cTpc) 
	nVlCooper := nValRec := nValProPf := nValProPj := nValComps := 0
	cPerIniCmp:= cPerFimCmp := ""

	For nx := 1 to len(aGpsVal)
		lGps := If(!empty(aGpsVal[nX,1]),(alltrim(aGpsVal[nX,1])>= alltrim(cCcDe) .and. alltrim(aGpsVal[nX,1]) <= alltrim(cCcAte)),.T.) 
	 	If lGPS
	 		lSI3 := .T.
	 		If !Empty( cSi3Filter )
	 			SI3->(dbSeek(cFilAnterior+alltrim(aGpsVal[nX,1]))) 
				lSI3 := 	( cSi3Filter )
			EndIf
	 		
	 		If lSI3
				If aGpsVal[nX,02] == aCodFol[313,1]		
					nVlCooper += aGpsVal[nx,03] // Base da Cooperativa
				ElseIf aGpsVal[nX,02] == aCodFol[198,1]
					nValRec	  += aGpsVal[nX,03] // Base da Receita	
				ElseIf aGpsVal[nX,02] == aCodFol[315,1]       
					nValProPf += aGpsVal[nX,03] // Valor Producao Rural P.Fisica
				ElseIf aGpsVal[nX,02] == aCodFol[316,1]       
					nValProPj += aGpsVal[nX,03] // Valor Producao Rural P.Juridica
				ElseIf aGpsVal[nX,02] == aCodFol[584,1]       
					nValComps += aGpsVal[nX,05] // Valor da Compensacao da GPS
					cPerIniCmp:= aGpsVal[nX,08]	// Ano/mes do periodo inicial de Compensacao
					cPerFimCmp:= aGpsVal[nX,09]	// Ano/mes do periodo final de Compensacao
				EndIf	
			EndIf
		EndIf
	Next nX
	If (nDeduc # 0) .Or. (nValRec # 0) .Or. (nValProPf # 0) .Or. (nValproPj # 0) .or. (nVlCooper#0);
		.Or. (nValComps#0) .or. cRecol$ '650#660'
		//-- SO GERA O 10 SE GEROU 0 30 PARA ALGUM FUNCIONARIO
		If lGera30
			DBF_TIPO12(aInfo,cInfo,nFgts)
		Endif	
	EndIf
Else
	Help("",1,"NOFUNC")
EndIf

If ! lAbortPrint
	FGeraArq()            
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chama rotina de Log de Ocorrencias. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aTotRegs[10]<> 0
	Aadd(aLog[aTotRegs[10]],"")
	Aadd(aLog[aTotRegs[10]],space(28)+"T O T A L  =>" +SPACE(28)+Transform(aTotal[01],"@E 999,999,999.99")+;
	space(06)+Transform(aTotal[02],"@E 999,999,999.99")+space(06)+Transform(aTotal[03],"@E 999,999,999.99"))
EndIF
If aTotRegs[11]<> 0
	Aadd(aLog[aTotRegs[11]],"")
	Aadd(aLog[aTotRegs[11]],space(28)+"T O T A L  =>" +SPACE(28)+Transform(aTotal[04],"@E 999,999,999.99")+;
	space(06)+Transform(aTotal[05],"@E 999,999,999.99")+space(06)+Transform(aTotal[06],"@E 999,999,999.99"))
EndIF

fMakeLog(aLog,aTitle,,,"SE"+FwCodEmp("SM0")+substr(dTos(MV_PAR01),1,6),"Log de ocorrencias - SEFIP","M","P",,.F.) //

If cRecol == "650" .and. nDissidio == 1 .and. MesAno(dAuxPar01) >= "200508" .and. MesAno(dAuxPar01)<= "200703"
	dbSelectArea( 'TRB' )
	dbCloseArea()
EndIf
Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FGeraArq     ³ Autor ³ Cristina Ogura   ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao que gera arquivo                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FGeraArq()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEM610                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FGeraArq()

Local aGetArea	:= GetArea()

// Gera arquivo
cFile	:=	Alltrim(cFile)
nHandle := 	MSFCREATE(cFile)
If FERROR() # 0 .Or. nHandle < 0
	Help("",1,"GPM600HAND")
	FClose(nHandle)
	Return Nil
EndIf

// Grava no arquivo SFP     o Header
BIN_TIPO00()

// Arquivo com todos os tipo da SEFIP
dbSelectArea("SFP")
dbGoTop()

While !Eof()

	// Gravar o Header do arquivo
	If SFP->SFP_TIPO == "00"     
		FWrite(nHandle,SFP->SFP_TEXTO)
	EndIf	

	// Verifico a empresa que estou
	If SFP->SFP_TIPO == "10"
		FWrite(nHandle,SFP->SFP_TEXTO)
		FVerTipo(SFP->SFP_TINSC,SFP->SFP_INSC,SFP->SFP_TTOMA,SFP->SFP_TOMAD)
	EndIf	
	
	dbSelectArea("SFP")
	dbSkip()
EndDo

// Registro Trailler
BIN_TIPO90()

FClose(nHandle)


RestArea(aGetArea)

dbSelectArea("SRA")
dbSetOrder(1)

dbSelectArea("SRC")
dbSetOrder(1)
              
Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Transforma³ Autor ³ Cristina Ogura       ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Transforma as datas no formato DDMMAAAA                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Transforma(ExpD1)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data a ser convertido                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Transforma(dData)
Return(StrZero(Day(dData),2) + StrZero(Month(dData),2) + Right(Str(Year(dData)),4))

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GravaSFP ³ Autor ³ Cristina Ogura        ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava os dados no arquivo temporario                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GravaSFP(ExpC1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Dados da string                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPEM610()                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GravaSFP(cCampo,cTipo,lAutonomo)

Local cSeek		:=	""
Local lFound
Local n20Valor	:=	0
Local n20VlFat	:=	0
Local n20VlRet	:=	0
Local c00Campo	:=	""
Local c10Campo	:=	""
Local cCampo1 	:=	""

Local n30VlS13 	:= 0
Local n30VlC13 	:= 0
Local n30VlDesc	:= 0
Local n30VlCont	:= 0
Local n30Bs13Mov:= 0
Local n30Bs13Gps:= 0
Local aOldAlias := GetArea()                
// cTipo: 		00-Informacoes do responsavel
//        		10-Informacoes da Empresa
//				12-Informacoes adicional da Empresa
//              13-Alteracao cadastral do trabalhador
//				14-Alteracao do endereco do trabalhador
//				20-Informacoes do Tomador de servico
//				21-Informacoes adicional do Tomador de servico
//				30-Registro do Trabalhador
//				32-Registro de movimentacao do trabalhador

Default lAutonomo := .F.
dbSelectArea("SFP")             

If cTipo $ "00"				// Tipo Insc+Insc+Tipo
	cSeek := space(01)+space(14)+cTipo
ElseIf cTipo $ "10*12"		// SFP_TINSC+SFP_INSC+SFP_TIPO			
	cSeek := Substr(cCampo,3,15)+cTipo
ElseIf cTipo $ "20*21"		// SFP_TINSC+SFP_INSC+SFP_TIPO+SFP_TTOMA+SFP_TOMAD	
	cSeek := Substr(cCampo,3,15)+cTipo+Substr(cCampo,18,15)
ElseIf cTipo $ "30"		   // (SFP_TINSC+SFP_INSC)+SFP_TIPO+(SFP_TTOMA+SFP_TOMAD)+SFP_PIS+SFP_DT+SFP_CAT
	If !lAutonomo //Se for autonomo, sempre gerar registro, nao aglutinar, nao verificar chave
		cSeek := Substr(cCampo,3,15)+cTipo+Substr(cCampo,18,15)+Substr(cCampo,33,11)+Substr(cCampo,48,4)+Substr(cCampo,46,2)+Substr(cCampo,44,2)+Substr(cCampo,52,2)
	EndIf	
EndIf

If Empty(cSeek)
	lFound := .T.
Else
	If dbSeek(cSeek)
		lFound 	:= .F.
		// Sempre grava os dados da 1a empresa gerada
		If cTipo == "00" 
			c00Campo:= SFP->SFP_TEXTO
		ElseIf cTipo $ "10*12"
			c10Campo:= SFP->SFP_TEXTO
		EndIf	
	Else
		lFound := .T.	
	EndIf
EndIf

RecLock("SFP",lFound)
If lFound
	If cTipo == "00"
	 	SFP->SFP_TINSC 	:= Space(01)
		SFP->SFP_INSC	:= Space(14)
	Else	
  		SFP->SFP_TINSC 	:= Substr(cCampo,3,1)
		SFP->SFP_INSC	:= Substr(cCampo,4,14)
	EndIf						
	SFP->SFP_TIPO	:= cTipo
EndIf	

If cTipo $ "13*14"
	SFP->SFP_PIS	:= Substr(cCampo,52,11)
	SFP->SFP_DT		:= Substr(cCampo,69,4)+Substr(cCampo,67,2)+Substr(cCampo,65,2)
	SFP->SFP_CAT	:= Substr(cCampo,73,2)
ElseIf cTipo $ "20*21"	
	SFP->SFP_TTOMA 	:= Substr(cCampo,18,1)
	SFP->SFP_TOMAD 	:= Substr(cCampo,19,14)
	// Devo somar o salario familia,Valor Retido e Valor Faturado de todos os C.C. no Tipo 20
	If !lFound
		cCampo1  := cCampo
		n20Valor := Val(Substr(SFP->SFP_TEXTO,198,15))+Val(Substr(cCampo,198,15)) 
		n20VlRet := Val(Substr(SFP->SFP_TEXTO,243,15))+Val(Substr(cCampo,243,15))  
		n20VlFat := Val(Substr(SFP->SFP_TEXTO,258,15))+Val(Substr(cCampo,258,15)) 
		n20VlEmp := Val(Substr(SFP->SFP_TEXTO,213,15))+Val(Substr(cCampo,213,15)) 
		n20VlDev := Val(Substr(SFP->SFP_TEXTO,229,14))+Val(Substr(cCampo,229,14)) 
		cCampo   := SubStr(cCampo1,1,197)
		cCampo   += StrZero(n20Valor,15)+ StrZero(n20VlEmp,15)
		cCampo   += SubStr(cCampo1,228,1)
		cCampo	 += StrZero(n20VlDev,14)+StrZero(n20VlRet,15)+StrZero(n20VlFat,15)
		cCampo   += Substr(cCampo1,273,88)+CHR(13)+CHR(10)
		
		SFP->SFP_TEXTO	:= cCampo
	EndIf
ElseIf cTipo $ "30*32"
	SFP->SFP_TTOMA	:= Substr(cCampo,18,1)
	SFP->SFP_TOMAD	:= Substr(cCampo,19,14)
	SFP->SFP_PIS	:= Substr(cCampo,33,11)
	SFP->SFP_DT		:= Substr(cCampo,48,4)+Substr(cCampo,46,2)+Substr(cCampo,44,2)
	SFP->SFP_CAT	:= Substr(cCampo,52,2)
	SFP->SFP_EMFIMA	:= FwCodEmp("SRA")+SRA->RA_FILIAL+SRA->RA_MAT

	If !lFound .and. cTipo =="30"
		cCampo1  := cCampo

		n30VlS13 	:= Val(Substr(SFP->SFP_TEXTO,168,15))+Val(Substr(cCampo,168,15)) 
		n30VlC13 	:= Val(Substr(SFP->SFP_TEXTO,183,15))+Val(Substr(cCampo,183,15)) 
		n30VlDesc	:= Val(Substr(SFP->SFP_TEXTO,202,15))+Val(Substr(cCampo,202,15)) 
		n30VlCont	:= Val(Substr(SFP->SFP_TEXTO,217,15))+Val(Substr(cCampo,217,15)) 
		n30Bs13Mov 	:= Val(Substr(SFP->SFP_TEXTO,232,15))+Val(Substr(cCampo,232,15)) 
		n30Bs13Gps 	:= Val(Substr(SFP->SFP_TEXTO,247,15))+Val(Substr(cCampo,247,15)) 

		cCampo   	:= SubStr(cCampo1,1,167)
		cCampo   	+= StrZero(n30VlS13,15)+ StrZero(n30VlC13,15)
		cCampo		+= SubStr(cCampo1,198,4)
		cCampo   	+= StrZero(n30VlDesc,15)+ StrZero(n30VlCont,15)
		cCampo   	+= StrZero(n30Bs13Mov,15)+ StrZero(n30Bs13Gps,15)
		cCampo   	+= Substr(cCampo1,262,99)+CHR(13)+CHR(10)
		
		SFP->SFP_TEXTO	:= cCampo
	Endif	
EndIf	           
	                             
If !lFound             
	If cTipo == "00"
		SFP->SFP_TEXTO		:= c00Campo
	ElseIf cTipo $ "10*12"
		SFP->SFP_TEXTO		:= c10Campo				
	EndIf	
Else	
	SFP->SFP_TEXTO	  		:= cCampo
EndIf	
MsUnlock()
	                                         
RestArea(aOldAlias)	

Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BIN_TIPO00³ Autor ³ Cristina Ogura       ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Registro das informacoes do responsavel                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ BIN_TIPO00()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function BIN_TIPO00()

Local c00Grava
Local aInfo		:=	{}
Local cInfo		:=	""
Local cIndFGTS	:=	Space(01)
Local cIndINSS	:=	Space(01)
Local cINSS		:=	""
Local cFGTS		:=	""
Local cCompet	:=	""
Local cIndice	:=	""
Local cComp

If nIndInss == 0.00
	cIndice := Space(7)
Else	
	cIndice := Str(nIndInss * 100,7)
Endif	

// Tipo de Inscricao
If !fInfo(@aInfo,substr(cFilResp,3,FWGETTAMFILIAL),Substr(cFilResp,1,2))
	Return .T.
EndIf

// Tipo de inscricao da Empresa
If aInfo[15] == 1			// CEI
	cInfo:= "2"
ElseIf aInfo[15] == 3		// CPF
	cInfo:= "3"
Else
	cInfo:= "1"				// CGC/INCRA
EndIf

// Indicador Recolhimento INSS
cCompet:= Right(Str(Year(dAuxpar01)),4)+Substr(DtoC(dAuxpar01),3,3)
If cCompet < "1998/10"
	cIndINSS := "3"
ElseIf cCompet > "1998/10" .And. cRecol $ "145/307/317/327/337/345/640/660"   
	cIndINSS := "3"
Else
	cIndINSS := Str(nRecInss,1)
EndIf

// Data de Recolhimento do INSS
If cIndINSS # "2"
	cINSS	:=	Space(08)
Else          	
	cINSS	:=	Transforma(dDtInss)
EndIf

// Indicador Recolhimento FGTS
If Substr(cDataRef,4,2) # "13"
	If (cRecol$ "145/345/640") .or. (cRecol$ "145/307/317/327/337/345/640"  .and. (nVersao == 3))
		cIndFGTS	:= "2"
	ElseIf cRecol $ "211"
		cIndFGTS	:= " "
	Else
		cIndFGTS	:= Str(nRecFgts,1)
	EndIf
EndIf
                    
If cCompet < "1998/10"
	cIndFGTS	:= "2"
EndIf	
// Data Recolhimento do FGTS
If Empty(cIndFGTS) .or. cIndFGTS =="1" .or. Substr(cDataRef,4,2) =="13"
	cFGTS := Space(08)
Else
	cFGTS := Transforma(dDtFgts)
EndIf

If cIndINSS # "2"
	cIndice:=Space(07)
EndIf

//-- Montar Ano/Mes de Competencia se 13o. SAL.
If nTipo = 2   // Tipo 1-Folha/Ferias	   2-13o.Salario
	cComp := Right(Str(Year(dAuxpar01)),4)+"13"
Else
	cComp := Right(Str(Year(dAuxpar01)),4)+Substr(DtoC(dAuxpar01),4,2)
Endif

//--Modalidade do arquivo
If cModFgts == 1  
	cModFgts := " "
ElseIf cModFgts == 2
	cModFgts := "1"
ElseIf cModFgts == 3
	cModFgts := "9"
EndIf

//																			De 	Ate Tam	Descricao
c00Grava	:= "00"														// 001	002	002		Sempre "00"
c00Grava	+= Space(51)												// 003	053	049		Preencher com espacos
c00Grava    += "1"														// 054  054 001       "1"-GFIP
c00Grava	+= FSubst(Left(cInfo+Space(01),01))						// 055	055	001		1- CGC/CNPJ 2-CEI 3-CPF
c00Grava	+= space(14-len(alltrim(aInfo[08])))+alltrim(aInfo[08]	)	// 056	069	014		Inscricao
c00Grava	+= FSubst(Left(aInfo[03]+Space(30),30))					// 070	099	030		Nome empresa
c00Grava	+= FSubst(Left(cNomeCont+Space(20),20))					// 100	119	020		Nome pessoa contato
c00Grava	+= FSubst(Left(aInfo[04]+Space(50),50))					// 120	169	050		Logradouro, rua, apartamento
c00Grava	+= FSubst(Left(aInfo[13]+Space(20),20))					// 170	189	020		Bairro
c00Grava	+= FSubst(Left(aInfo[07]+Space(08),08))					// 190	197	008		CEP
c00Grava	+= FSubst(Left(aInfo[05]+Space(20),20))					// 198	217	020		Cidade
c00Grava	+= FSubst(Left(aInfo[06]+Space(02),02))					// 218	219	002		UF
c00Grava	+= FSubst(StrZero(nFoneCont,12))							// 220	231	012		Telefone
c00Grava	+= Left(cInternet+Space(60),60)							// 232	291	060		Endereco na Internet
c00Grava	+= cComp													// 292	297	006		Mes/Ano competencia AAAAMM
c00Grava	+= Left(cRecol+Space(03),03)								// 298	300	003		Codigo recolhimento
c00Grava	+= Left(cIndFGTS+Space(01),01)								// 301	301	001		Indica Recolh FGTS 1-no Prazo  2-atraso ou brancos
c00Grava    += cModFgts													// 302	302 001		"1"-Recolhimento FGTS
c00Grava	+= Left(cFGTS+Space(08),08)								// 303	310	008		Data do recolhimento do FGTS
c00Grava	+= Left(cIndINSS+Space(01),01)								// 311	311	001		Indica Recolh INSS 1-no prazo 2-atraso 3-nao gera
c00Grava	+= Left(cINSS+Space(08),08)								// 312	319	008		Data Recolhimento do INSS em Atraso
c00Grava	+= cIndice													// 320	326	007		Indice do Recolh. em atraso
c00Grava 	+= Left(Str(nTpForFol,1),1)								// 327	327	001		1- CGC/CNPJ 2-CEI 3-CPF Fornecedor Folha
c00Grava	+= StrZero(nInscFol,14)										// 328	341	014		Inscricao Fornecedor Folha
c00Grava	+= Space(18)												// 342	359	018		Brancos
c00Grava	+= "*"														// 360	360	001		"*"	Fim de linha
c00Grava 	+= CHR(13) + CHR(10)										//					Fim de linha
                         
GravaSFP(c00Grava,"00")

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DBF_TIPO10³ Autor ³ Cristina Ogura       ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Registro das informacoes da empresa                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DBF_TIPO10()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function DBF_TIPO10(cAuxFil,aInfo,cInfo,nSalFam,n13Inss,nSalMat1,nValDPrev)

Local c10Grava		:= ""
Local nAliqSat		:=	0
Local cCentra		:=	""
Local cAliqSat		:=	"00"
Local cAltCNAE		:= 	cIndCNAE
Local cImpSimples	:=	Space(01)
Local cCompet		:=	Right(Str(Year(dAuxpar01)),4) + Substr(cDataRef,3,3)
Local cCodRemag 	:=	Space(13)
Local cMudou		:=	aInfo[23]

Local aFoneSM0		:=  FisGetTel( aInfo[10] )		//-- Obtem o telefone do SIGAMAT (DDI, DDD e Telefone)
Local cTel			:=	FSubst(Alltrim(Str(aFoneSM0[02])) + Alltrim(STR(aFoneSM0[03])) )		// DDD + Telefone

Local cPercfilan    := ""
Local cCodGps10     := ""

//variaveis utilizadas nos pontos de entrada
Private nSal_Fam	:= 0
Private nSal_Mat	:= 0


// Codigo da Remag
If nCodRemag = 0
	cCodRemag := Space(14)
	If Fphist82(SRZ->RZ_FILIAL,"14",cAuxFil+MesAno(dAuxPar01)+"1"+"3" ) .or. ;
		Fphist82(SRZ->RZ_FILIAL,"14",space(FWGETTAMFILIAL)+MesAno(dAuxPar01)+"1"+"3") .or. ;
		Fphist82(SRZ->RZ_FILIAL,"14",cAuxFil+ "      "+"1"+"3" ) .or. ;
		Fphist82(SRZ->RZ_FILIAL,"14",space(FWGETTAMFILIAL)+"      " +"1"+"3") 
		cCodRemag := StrZero( Val( Left(SRX->RX_TXT,13) ) ,14)

	Endif
Else
	cCodRemag := StrZero(nCodRemag,14)
EndIf
             
// Codigo da empresa dever ser espacos 
If Empty(cCodRemag) .Or. Val(cCodRemag) = 0
	cCodRemag := Space(14)
EndIf	

// Carrega Percentuais de INSS Empresa
If !fInssEmp(cAuxFil,@aInssEmp,.F.,AnoMes(dAuxPar01))
	Help(' ',1,"GR240SEMP")
	Return .F.
EndIf

If 	cTpContr == "1" .or. cTpContr == "3"
	cTerceiros := aInssEmp[25,1]
ElseIf cTpContr $ "2"
	cTerceiros := aInssEmp[25,2]
EndIf	

// Centraliza ou nao as filiais
If nCentra == 1					// Centralizar Filial 1-Sim  2-Nao
	If FwCodEmp("SM0")+cAuxFil == AllTrim(cFilResp)
		cCentra:= "1"
	Else
		cCentra:= "2"
	EndIf
Else
	cCentra := "0"
EndIf

If cRecol $ "130/135/150/155/211/317/337/608"
	cCentra := "0"
EndIf
                                                      
//ponto de entrada para alterar o valor do Salario Familia
If ExistBlock("GPM610SalFam")
	Execblock("GPM610SalFam",.F.,.F.,{cAuxFil})
	nSalFam 		:= 	If( nSal_Fam > 0, nSal_Fam, nSalFam)
Endif

//-- Modificar o CNAE
If Substr(cDataRef,4,2) == "13"
	cMudou	 := "N"
	cAltCNAE := "N"
	nSalFam  := 0
EndIf

If cFPAS $ "868" .and. nVersao #1
	cCodGps10 := "1600"
ElseIf nVersao # 1 .and.!(cRecol $ "115/150/211/650") .or. cRecol $ "145/307/327/345/640/660"
	cCodGps10 := space(04)
Else
	cCodGps10 := cCodGps	
Endif	

cCodGps10 := If( cCompet < "1998/10",space(04),cCodGps10)

// Aliquota de SAT
// aINSSEmp depende do RA_TPCONTR
If SRA->RA_TPCONTR == "2"
	nAliqSat	:= aInssEmp[3][2] * 100
Else
	nAliqSat	:= aInssEmp[3][1] * 100
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Utiliza as variáveis alteradas no ponto de entrada GPM610TP20 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !empty( cCnae_Tom )
	cCNAE	:=	cCnae_Tom
Else
	cCNAE	:=	aInfo[16]
EndIf
nAliqSat	:= 	If(!empty( nRAT_TOM ),nRAT_TOM,nAliqSat)
cTerceiros 	:=	If(!empty(cTerc_Tom),cTerc_Tom,cTerceiros)


If Int(nAliqSat) == 1
	cAliqSat := "10"
ElseIf Int(nAliqSat) == 2
	cAliqSat := "20"
ElseIf Int(nAliqSat) == 3
	cAliqSat := "30"
ElseIf Int(nAliqSat) == 0
	cAliqSat := "00"
Else
	cAliqSat := cAliqSat
EndIf

If nVersao # 1
	If ((cFPAS $ "604/647/868" .and. nVersao == 2)  .or. ;//Optante simples
		(cFPAS $ "604/647/825/833/868"  .and. nVersao == 3)) ;
		.Or. cSimples == "2"
		nAliqSat	:=0
	EndIf	
	
	If cCompet < "1998/10" .or. (cRecol$ "145/307/317/327/337/345/640/660")
		cAliqSat	:="  "
	EndIf
Else
	If cFPAS $ "604/647" .Or. cSimples == "2"   //Optante simples
		nAliqSat	:=	0
	ElseIf cCompet < "1998/10" .or. (cRecol $ 150 .and. cFPAS $"604" .AND. cCompet > "2001/10")
		cAliqSat	:=	"  "
	EndIf
EndIf
	

// Optante do SIMPLES ou Nao     
If nVersao == 1 .and. cRecol $ "130/608/903/909/910" .And. cFPAS $ "523/582/639/655"
	cImpSimples := "1"
ElseIf cRecol $ If(nVersao #1,"640","145/345/640/660") .or. (cCompet < "1996/12")
	cImpSimples := " "
Else
	cImpSimples := StrZero(val(cSimples),1)
EndIf                                        

// valor retido de Inss 13o. e Valor Devido a Previdencia e indice
cIndInss := "0"
If (nTipo # 2) .and. (Month(dAuxPar01) == 12) .And. If(nVersao#3,! cRecol$ "145/345/640/660",! cRecol$"145/150/155/307/327/345/608/640/650/660/" )
	n13Inss		:= n13Inss	* 100
	If nValDPrev < 0.00
		cIndInss 	:= "1"
		nValDPrev 	:= nValDPrec * (-1)
	Endif	
	nValDPrev := nValDPrev * 100
Else
	n13Inss		:= 0
	nValDPrev	:= 0
Endif		

// Salario Familia
If (cRecol $ "130/145/150/155/211/307/327/345/608/640/650/660")  .or. cFPAS $ "868"	 .or. (cCompet < "1998/10")	 
	nSalFam	:= 0
Else	
	nSalFam := nSalFam * 100
Endif	

//ponto de entrada para alterar o valor do Salario MATERNIDADE
If ExistBlock("GP610SalMat")
	Execblock("GP610SalMat",.F.,.F.,{cAuxFil})                  
	nSalMat1 := 	If( nSal_Mat > 0, nSal_Mat, nSalMat1)
Endif

If cRecol$ '130/135/145/211/307/317/327/337/345/640/650/660' .Or. nTipo == 2
	nSalMat1 := 0
Else	
	nSalMat1 := nSalMat1 * 100
Endif	
                                                                
If nVersao == 3 .and. cRecol $ '130/135/145/211/307/317/327/337/345/640/650/660/'
	nSalMat1 := 0
EndIf                    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se nao tiver recolhimento de pessoal administrativo e o codigo³
//³de recolhimento for 150, nao informar o valor de deducao do   ³
//³salario maternidade.                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lPessoalAdm .and. cRecol == '150'
	nSalMat1 := 0
EndIf	
           
If (cCompet < "1998/10") .OR. (cCompet >= "2000/06" .and. cCompet <= "2003/08")
	nSalMat1 := 0
EndIf
    
If cCompet < "1994/04"
	cPercFilan := Space(5)
Endif		

If nPercfilan > 0.00 .and. cFPAS $ "639" 
	cPercFilan := StrZero(nPercFilan * 100,5)
Else
	cPercFilan := Space(5)
Endif		

// Optou pelo SIMPLES
If cImpSimples $ If(nVersao#1,"236","2") .Or. cRecol$ '145/307/317/327/337/345/640/660'.or. cCompet < "1998/10";
	.or. (cCompet < "1999/04" .and. cFPAS $"639")
	cTerceiros := Space(04)
EndIf                               

If nVersao # 1
	If (cFPAS $ "582" .and. cCompet >= "1998/10") .or.(cFPAS$'868')
		cTerceiros := replicate("0",04)
	EndIf
Endif

If Empty(cMudou)
	cMudou := "N"
EndIf

n13Inss		:= 0
cIndInss	:= "0"
nValDPrev	:= 0
//														De		Ate	Tam			Descricao
c10Grava := "10"										//  001	002	002			Sempre 10
c10Grava += Left(cInfo+Space(01),01)					//  003	003	001			1-CGC/CNPJ	2-CEI
c10Grava += space(14-len(alltrim(aInfo[08])))+alltrim(aInfo[08])//	004	017	014			Inscricao        
c10Grava += Replicate("0",36)							//	018	053	036			Zeros
c10Grava +=	FSubst(Left(aInfo[03]+Space(40),40))		//	054	093	040			Nome empresa
c10Grava += FSubst(Left(aInfo[04]+Space(50),50))		//	094	143	050			Endereco
c10Grava += FSubst(Left(aInfo[13]+Space(20),20))		//	144	163	020			Bairro
c10Grava += Left(aInfo[07]+Space(08),08)				//	164	171	008			CEP
c10Grava += FSubst(Left(aInfo[05]+Space(20),20))		//	172	191	020			Cidade
c10Grava += Left(aInfo[06]+Space(02),02)				//	192	193	002			UF
c10Grava += Right(Space(12)+cTel,12)					//	194	205	012			Telefone
c10Grava += Left(cMudou+Space(01),01)					//	206	206	001			"S" se mudou de endereco
c10Grava +=	Left(cCNAE+Repl("0",7),7)					//	207	213	005			Nr CNAE
c10Grava +=	Left(cAltCNAE+Space(01),01)					//	214	214	001			"S" se alterou o CNAE
c10Grava +=	Left(cAliqSat+Space(02),02)					//	215	216	002			Aliquota de RAT (Acidente Trabalho)
c10Grava +=	Left(cCentra+Space(01),01)					//	217	217	001			0-nao centraliza 1-centralizadora 2-centralizada
c10Grava +=	Left(cImpSimples+Space(01),01)				//	218	218	001			Simples 1-optante 2-optante
c10Grava +=	Left(cFPAS+Space(03),03)					//	219	221	003			FPAS
c10Grava += Left(cTerceiros+Space(04),4)				//	222	225	004			Cod Terceiros( Outras Entidades )
c10Grava += Left(cCodGps10+space(4),4)			   		//	226 229 004         Codigo de pagamento GPS
c10Grava += cPercFilan									//	230 234	005			Percentual isencao Filantropia
c10Grava +=	StrZero(nSalFam,15)							//	235	249	015			Valor Pago de Salario Familia
c10Grava +=	StrZero(nSalMat1,15)						//	250	264	015			Ded.Sal.Maternidade na GPS
c10Grava +=	StrZero(n13Inss,15)							//	265	279	015			Contrib. Desc. Empregado Comp.13
c10Grava += cIndInss									//	280	280	001			Indica se Valor devido a Prev. é 0=Positivo e 1=Negativo
c10Grava +=	StrZero(nValDPrev,14)						//	281	294	014			Valor Devido a Previdencia
c10Grava += Space(3)									//	295	297	003			Banco para debito em conta corrente
c10grava += Space(4)									//	298	301	004			Agencia para debito em conta corrente
c10grava += Space(9)									//	302	310	009			Conta corrente para debito
c10Grava += Replicate("0",45)							//	311 355 045			Zeros
c10Grava += Space(4)									//	356	359 004			Brancos
c10Grava +=	"*"											//	360	360	001			"*"
c10Grava += CHR(13)+CHR(10)								//	Fim de linha

GravaSFP(c10Grava,"10")

nSal_Fam := 0

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DBF_TIPO12³ Autor ³ Cristina Ogura       ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Registro das informacoes adicionais do recolhimento empresa³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DBF_TIPO12(ExpA1,ExpC1)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function DBF_TIPO12(aInfo,cInfo)

Local c12Grava
Local cOrigem	:=	" "
Local nEvento	:=	0
Local cDtInI	:= 	substr(dtos(dDtInfINI),1,6)
Local cDtFim	:= 	substr(dtos(dDtInfFIM),1,6)
Local cCompet	:= 	Right(Str(Year(dAuxpar01)),4)+Substr(DtoC(dAuxpar01),3,3)
                                                
If cRecol $"650/660/" .and. nVersao # 1
	cDtInI	:= substr(dtos(dDtInfINI),1,6)    
	cDtFim	:= substr(dtos(dDtInfFIM),1,6)
Else
	cDtInI	:= ""
	cDtFim	:= ""
EndIf	
// Deducao 13o. Salario Maternidade
If (nVersao == 3 .and. cRecol$ "130/135/145/211/307/317/327/337/345/640/650/660") .or. cFPAS$ "868" 
	nDeduc	:=	0
EndIf

If nVersao == 3   
	If cCompet< "1998/10" .or. (cCompet >= "2001/01" .and. cCompet<="2003/08")
		nDeduc	:=	0
	EndIf
EndIf

nDeduc := nDeduc * 100

// Verificar Receita de  Desportivo/ Patrocinio
If Substr(cDataRef,4,2) # "13"
	If cRecol $ "130/135/145/211/307/317/327/337/345/608/640/650/660" 
		nValRec := 0
	EndIf
Else
	nValRec :=0
EndIf                                       

nEvento	:= If( (cCompet< "1998/10").or. (cRecol $"130/135/145/211/307/317/327/337/345/608/640/650/660"),0,nEvento)
nEvento	:= nValRec * 100


// Achar a origem da receita Bruta
If Substr(cDataRef,4,2) # "13" .And. nEvento # 0
	If nOrigRec == 1
		cOrigem := "E"
	ElseIf nOrigRec == 2
		cOrigem := "P"
	ElseIf nOrigRec == 3
		cOrigem := "A"
	EndIf
EndIf
cOrigem := If( (cCompet< "1998/10") .or.(cRecol $"145/307/317/327/337/345/640/660"),space(01),cOrigem)

If (Substr(cDataRef,4,2) == "13") .or. (nVersao ==3 .and. cFPAS $ "604" .and. cRecol $"150" .and. cCompet >"2001/10");
   .or. (nVersao == 3 .and. cRecol $"130/135/145/211/307/317/327/337/345/608/640/650/660")
	nVlCooper := 0
Else	
	nVlCooper := nVlCooper*100
endIF                        

If (nVersao == 3 .and. cCompet > "2001/10" .and. cFPAS $"604" .and. cRecol $ "150") .or. ;
   (cRecol $ "130/135/145/211/307/317/327/337/345/608/640/650/660") .or. Substr(cDataRef,4,2) == "13";
   .or. (cCompet < "1998/10")
	nValProPf 	:= 0 
	nValProPj	:= 0	
EndIF                        

If (nVersao == 3) .and. (cCompet < "1998/10" .or. cRecol $ "130/135/145/150/155/211/307/327/345/608/640/660" .or. Substr(cDataRef,4,2) == "13" ) 
	nValComps := 0 			// Valor da Compensacao da GPS
	cPerIniCmp:= space(06)	// Ano/mes do periodo inicial de Compensacao
	cPerFimCmp:= space(06)	// Ano/mes do periodo final de Compensacao
EndIf     

If !lPessoalAdm .and. cRecol $ '150#155#608'
	nDeduc := 0
EndIf	

//														De	Ate	Tam	Descricao
c12Grava := "12"									//	001	002	002	Sempre 12
c12Grava +=	Left(cInfo+Space(01),01)				//	003	003	001	1-CGC/CNPJ	2-CEI
c12Grava +=	space(14-len(alltrim(aInfo[08])))+alltrim(aInfo[08])//	004	017	014	Inscricao da empresa
c12Grava +=	Replicate("0",36)						//	018	053	036	zeros
c12Grava +=	StrZero(nDeduc,15)						//	054	068	015	Deducao 13o Sal Licenca Maternidade
c12Grava +=	StrZero(nEvento,15)						//	069	083	015	Receita Evento Desportivo/Patrocinio
c12Grava +=	Left(cOrigem+Space(01),1)				//	084	084	001	Indicativo Origem Receita (E-P-A) 
c12Grava +=	StrZero(nValProPf*100,15)				//	085	099	015	Comercial Producao Rural - Pessoa Fisica
c12Grava +=	StrZero(nValProPj*100,15)				//	100	114	015	Comercial Producao Rural - Pessao Juridica
c12Grava += If(nProcesso==0,space(11),Str(nProcesso,11)) //	115	125	011	Outras Informacoes Processo
c12Grava += If(nProcAno==0,space(04),Str(nProcAno,4))	//	126	129	004	Ano do Processo
c12Grava +=	If(nVara==0,space(05),Str(nVara,5))	//	130	134	005	Outras Informacoes - Vara
c12Grava +=	If(!empty(cDtINI),cDtINI,space(06))	//	135	140	006	Outras Informacoes - Periodo inicio
c12Grava +=	If(!empty(cDtFIM),cDtFIM,space(06))	//	141	146	006	Outras Informacoes - Periodo Fim
c12Grava +=	strzero(nValComps*100,15)				//	147	161	015	Compensacao - Valor
c12Grava +=	Left(cPerIniCmp+space(06),06)			//	162	167	006	Compensacao - Periodo Inicio
c12Grava +=	Left(cPerFimCmp+space(06),06)			//	168	173	006	Compensacao	- Periodo Fim
c12Grava +=	Replicate("0",15)						//	174	188	015	Recol. Competencia Anterior - Inss Sobre Folha
c12Grava +=	Replicate("0",15)						//	189	203	015	Recol. Competencia Anterior - Outras Entidades Sobre Folha
c12Grava +=	Replicate("0",15)						//	204	218	015	Recol. Competencia Anterior - Producao Rural Valor do Inss
c12Grava +=	Replicate("0",15)						//	219	233	015	Recol. Competencia Anterior - Producao Rural Outras Entidades
c12Grava +=	Replicate("0",15)						//	234	248	015	Recol. Competencia Anterior - Receita de Eventos
c12Grava +=	Replicate("0",15)						//	249	263	015	Parcela do FGTS Somatorio das Remuneracoes
c12Grava +=	Replicate("0",15)						//	264	278	030	Parcelamento do FGTS categoria 04 e 07
c12Grava +=	Replicate("0",15)						//	279	293	030	Parcelamento do FGTS valor recolhido
c12Grava +=	StrZero(nVlCooper,15)					//	294	308	015	Valores Pagos a Cooperativas de Trabalho
c12Grava +=	Replicate("0",45)						//	309	353	045	Implementacao Futura
c12Grava +=	Space(6)								//	354	359	006	Brancos
c12Grava +=	"*"										//	360	360	001		"*"
c12Grava += CHR(13)+CHR(10)							//	Fim de linha

GravaSFP(c12Grava,"12")

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DBF_TIPO13³ Autor ³ Cristina Ogura       ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Registro das alteracoes cadastral trabalhador              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DBF_TIPO13(ExpA1,ExpC1,ExpN1)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function DBF_TIPO13(aInfo,cInfo,nFgts,cCampo)

Local c13Grava
Local cCodigo
Local cNovo
Local cCateg	:=	Space(02)
Local cMatr		:=	""
Local cCodRemag	:= Space(13)
Local aSR9		:=	{}
Local aAux		:=	{}
Local cNumCP	:=	""
Local cSerCP	:=	""
Local cNome		:=	""
Local cPis		:=	""
Local cAdmissa	:=	""

//--Busca a categoria do Funcionario
cCateg	:=	FCateg(nFgts)

//--Nao gerar as categorias Abaixo
If cCateg$ (If(nVersao==1,"11/12/13/14/15/16/17",If(nVersao==2,"11/12/13/14/15/16/17/18/19/20/21","11/12/13/14/15/16/17/18/19/20/21/22/23/24/25/26")))
	Return
Endif	
//--Nao pode ser informado na competencia 13
If Substr(cDataRef,4,2)== "13"
	Return
EndIf
// Codigo da Remag
If nCodRemag == 0
	cCodRemag := Space(14)
	If Fphist82(SRZ->RZ_FILIAL,"14",SRA->RA_FILIAL+AnoMes(dAuxPar01)+"1"+"3" ) .or. ;
		Fphist82(SRZ->RZ_FILIAL,"14",space(FWGETTAMFILIAL)+AnoMes(dAuxPar01)+"1"+"3") .or. ;
		Fphist82(SRZ->RZ_FILIAL,"14",SRA->RA_FILIAL+ "      "+"1"+"3" ) .or. ;
		Fphist82(SRZ->RZ_FILIAL,"14",space(FWGETTAMFILIAL)+"      " +"1"+"3") 
		cCodRemag := StrZero( Val( Left(SRX->RX_TXT,13) ) ,14)
	Endif
Else
	cCodRemag := StrZero(nCodRemag,14)
EndIf

If Empty(cCodRemag) .Or. Val(cCodRemag) = 0
	cCodRemag := Space (14)
EndIf	

// Carteira Profissional - 403
If alltrim(cCampo) == "RA_NUMCP" .and. SRA->RA_ALTCP == "S"
	cCodigo:= "403"
	cNovo  := SRA->RA_NUMCP + SRA->RA_SERCP
// Nome empregado - 404
ElseIf (alltrim(cCampo) == "RA_NOMECMP" .or. alltrim(cCampo) =="RA_NOME") .and. SRA->RA_ALTNOME == "S"
	cCodigo := "404"     
	If SRA->(FieldPos("RA_NOMECMP")) # 0  
		cNovo := If(!empty(SRA->RA_NOMECMP),SRA->RA_NOMECMP,SRA->RA_NOME)
	Else	
		cNovo	:= SRA->RA_NOME
	EndIf	
// PIS/PASEP - 405
ElseIf alltrim(cCampo) == "RA_PIS" .and. SRA->RA_ALTPIS == "S"
	cCodigo := "405"
	cNovo	  := SRA->RA_PIS
// Data Admissao - 408
ElseIf alltrim(cCampo)=="RA_ADMISSA" .and. SRA->RA_ALTADM == "S"
	cCodigo := "408"
	cNovo	:= Transforma(SRA->RA_ADMISSA)
//CBO
ElseIf alltrim(cCampo) =="RA_CBO" .AND. SRA->(FieldPos("RA_ALTCBO "))# 0 .and. SRA->RA_ALTCBO == "S"
	cCodigo := "427"
	cNovo	:= fCodCBO(SRA->RA_FILIAL,SRA->RA_CODFUNC,dAuxPar01,If(nVersao#3,.F.,.T.)) 
	cNovo	:= "0"+Substr(cNovo,1,4)
//Data de Nascimento
ElseIf alltrim(cCampo) == "RA_NASC" .AND. SRA->(FieldPos("RA_ALTNASC"))# 0 .and. SRA->RA_ALTNASC == "S"
	cCodigo := "428"
	cNovo	:= Transforma(SRA->RA_NASC)
EndIf

// Matricula do trabalhador
If cCateg $ "06" .and. nVersao == 3
	cMatr	:= Space(11)
Else
	cMatr	:= StrZero(Val(SRA->RA_MAT),11)
EndIf

// Numero do CTPS
If !cCateg $ "01/03/04/06/07"
	cNumCP:= Space(07)
	cSerCP:= Space(05)
Else
	cNumCP:= SRA->RA_NUMCP
	cSerCP:= SRA->RA_SERCP
EndIf

// Definir o campo que foi alterado
dbSelectArea("SR9")
dbSetOrder(1)
If dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+cCampo)
	While !Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT+cCampo ==;
							 SR9->R9_FILIAL+SR9->R9_MAT+SR9->R9_CAMPO

		Aadd(aSR9,SR9->R9_DESC)
		dbSkip()
	EndDo
EndIf

If Alltrim(cCampo) == "RA_NUMCP"
	dbSelectArea("SR9")
	dbSetOrder(1)
	If dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"RA_SERCP  ")
		While !Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT+"RA_SERCP  " ==;
								 SR9->R9_FILIAL+SR9->R9_MAT+SR9->R9_CAMPO
			Aadd(aAux,SR9->R9_DESC)
			dbSkip()
		EndDo
	EndIf

	If Len(aSR9) == 0 .Or. Len(aAux) == 0
		If Len(aSR9) == 0
			If Len(aAux) > 1
				cNumCP := SRA->RA_NUMCP
				cSerCP := AllTrim(aAux[Len(aAux)-1])
				cNovo  := Left(StrZero(Val(AllTrim(SRA->RA_NUMCP)),07),07) + Left(StrZero(Val(AllTrim(aAux[Len(aAux)])),05),05)
			EndIf
		ElseIf Len(aAux) == 0
			If Len(aSR9) > 1
				cNumCP:= aSR9[Len(aSR9)-1]
				cSerCP:= SRA->RA_SERCP
				cNovo := AllTrim(aSR9[Len(aSR9)])+AllTrim( SRA->RA_SERCP)
			EndIf
		EndIf
	Else
		If Len(aSR9) > 1
			cNumCP:= AllTrim(aSR9[Len(aSR9)-1])
			cSerCP:= AllTrim(aAux[Len(aAux)-1])
			cNovo := AllTrim(aSR9[Len(aSR9)])+AllTrim(aAux[Len(aAux)])
		EndIf
	EndIf
Else
	cNumCP:= SRA->RA_NUMCP
	cSerCP:= SRA->RA_SERCP
EndIf

If (Alltrim(cCampo) =="RA_NOME" .OR. Alltrim(cCampo) =="RA_NOMECMP") 
	If (Len(aSR9) > 1)
		cNome := aSR9[Len(aSR9)-1]
		cNovo := aSR9[Len(aSR9)]
	Else
		cNome := SRA->RA_NOME	
	EndIf	
Else
	If SRA->(FieldPos("RA_NOMECMP")) # 0  
		cNome := If(!empty(SRA->RA_NOMECMP),SRA->RA_NOMECMP,SRA->RA_NOME)
	Else	
		cNome := SRA->RA_NOME
	EndIf	
EndIf

If Alltrim(cCampo) == "RA_PIS"
	If Len(aSR9) > 1
		cPis := aSR9[Len(aSR9)-1]
		cNovo:= aSR9[Len(aSR9)]
	EndIf
Else
	cPis := SRA->RA_PIS
EndIf

If Alltrim(cCampo) == "RA_ADMISSA"
	If Len(aSR9) > 1
		cAdmissa:= CtoD(aSR9[Len(aSR9)-1],"DDMMYY")
		cNovo	:= Transforma(CtoD(aSR9[Len(aSR9)],"DDMMYY"))
	EndIf
	If Empty(cAdmissa)
		cAdmissa:= SRA->RA_ADMISSA
	EndIf
Else
	cAdmissa:= SRA->RA_ADMISSA
EndIf

cNumCP := Val(cNumCP)
cSerCP := Val(f610TrocaLetra(cSerCP))

If cNumCP == 0
	cNumCP := Space(07)
	cSerCP := Space(05)
Else
	cNumCP := Left(StrZero(cNumCP,07),07)
	cSerCP := Left(StrZero(cSerCP,05),05)
EndIf
     
// Nao tira as "/" quando for data
If Alltrim(cCampo) # "RA_ADMISSA"  .and.  Alltrim(cCampo) # "RA_NASC"
	cNovo := FSubst(cNovo)
EndIf

//															De		Ate	Tam	Descricao
c13Grava := "13"		 								//	001		002	002		Sempre "13"
//--Quando Filial For Cei e Centraliza Filail gera Filial Responsavel
If nCentra = 1 .And. cInfo = '2'
	c13Grava += Left(cInfoResp+Space(01),01)			//	003	    003	001		1-CGC/CNPJ	2-CEI
	c13Grava += space(14-len(alltrim(cInscResp)))+alltrim(cInscResp)//	004	    017	014		Inscricao da empresa
Else
	c13Grava += Left(cInfo+Space(01),01)				//	003		003	001		1-CGC/CNPJ	2-CEI
	c13Grava += space(14-len(alltrim(aInfo[08])))+alltrim(aInfo[08])//	004		017	014		Inscricao da empresa
Endif	
c13Grava += Replicate("0",36)							//	018		053	036		Zeros
c13Grava += Left(cPis+Space(11),11)					//	054		064	011		PIS/PASEP/CI
c13Grava += Transforma(cAdmissa)						//	065		072	008		Data da admissao
c13Grava += Left(cCateg+Space(02),02)					//	073		074	002		Categoria do trabalhador
c13Grava += FSubst(Left(cMatr,11))						//	075		085	011		Matricula do trabalhador
c13Grava += cNumCP                      				//	086		092	007		Numero do CTPS
c13Grava += cSerCP                      				//	093		097	005		Serie do CTPS
c13Grava += FSubst(Left(cNome+Space(70),70))			//	098		167	070		Nome
c13Grava += Left(cCodRemag+Space(14),14)				//	168		181	014		Cod. Empresa na CAIXA
c13Grava += StrZero(Val(SRA->RA_CTDPFGT),11)			//	182		192	011		Cod. Empregado CAIXA
c13Grava += Left(cCodigo+Space(03),03)					//	193		195	003		Cod. Alteracao Cadastral
c13Grava += Left(cNovo+Space(70),70)					//	196		265	070		Novo conteudo do campo
c13Grava += Space(94)									//	266		359	094		Brancos
c13Grava += "*"											//	360		360	001		"*"
c13Grava += CHR(13)+CHR(10)								//	Fim de linha

GravaSFP(c13Grava,"13")

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DBF_TIPO14³ Autor ³ Cristina Ogura       ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Registro das inclusao/alteracao endereco do trabalhador    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DBF_TIPO14(ExpA1,ExpC1,ExpN1)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function DBF_TIPO14(aInfo,cInfo,nFgts)

Local c14Grava	:= ""
Local cNumCP	:= ""
Local cSerCP	:= ""
Local cAdmissa 	:= ""
Local cCateg	:=	Space(02)
Local cEnderec	:= ""

cCateg	:=	FCateg(nFgts)
          
//--So de ve gerar para essas categorias conforme manual lay-out folha
If (nVersao == 1 .and. ! cCateg $ "01/02/03/04/05/06/07/11/12") .or.;
   (nVersao == 2 .and. ! cCateg $ "01/02/03/04/05/06/07/11/12/19/20/21") .or.;
   (nVersao == 3 .and. ! cCateg $ "01/02/03/04/05/06/07")
	Return
Endif
//-- Codigos que nao podem gerar registro 14 se houver somente informacoes de endereco no arquivo
//If cRecol$ "130/135/150/155/317/337/608/"
//	Return
//Endif	

If cCateg $ "01/03/04/06/07"
	cNumCP := SRA->RA_NUMCP
	cSerCP := SRA->RA_SERCP
Else
	cNumCP := Space(07)
	cSerCP := Space(05)
EndIf

cNumCP := Val(cNumCP)
cSerCP := Val(f610TrocaLetra(cSerCP))

If cNumCP == 0
	cNumCP := Space(07)
	cSerCP := Space(05)
Else
	cNumCP := Left(StrZero(cNumCP,07),07)
	cSerCP := Left(StrZero(cSerCP,05),05)
EndIf

//-- Data de admissao  
If (nVersao == 1 .and. cCateg $ "01/03/04/05/06/07/11/12") .or. ;
   (nVersao == 2 .and. cCateg $ "01/03/04/05/06/07/11/12/19/20/21").or. ;
   (nVersao == 3 .and. cCateg $ "01/03/04/05/06/07")
	cAdmissa := Transforma(SRA->RA_ADMISSA)
Else
	cAdmissa := Space(08)
EndIf

//																	De		Ate	Tam		Descricao
c14Grava := "14"												//	001		002	002		Sempre "14"
//--Quando Filial For Cei e Centraliza Filail gera Filial Responsavel
If nCentra = 1 .And. cInfo = '2'
	c14Grava += Left(cInfoResp+Space(01),01)					//	003	   	003	001		1-CGC/CNPJ	2-CEI
	c14Grava += space(14-len(alltrim(cInscResp)))+alltrim(cInscResp)//	004		017	014		Inscricao da empresa
Else
	c14Grava += Left(cInfo+Space(01),01)						//	003		003	001		1-CGC/CNPJ	2-CEI
	c14Grava += space(14-len(alltrim(aInfo[08])))+alltrim(aInfo[08])//	004		017	014		Inscricao da empresa
Endif	
c14Grava += Replicate("0",36)									//	018		053	036		Zeros
c14Grava += AllTrim(SRA->RA_PIS)								//	054		064	011		PIS/PASEP/CI
c14Grava += cAdmissa											//	065		072	008		Data da admissao
c14Grava += Left(cCateg+Space(02),02)							//	073		074	002		Categoria do trabalhador

If SRA->(FieldPos("RA_NOMECMP")) # 0  
	c14Grava += FSubst(Left(If(!empty(SRA->RA_NOMECMP),SRA->RA_NOMECMP,SRA->RA_NOME)+Space(70),70))	
Else	
	c14Grava += FSubst(Left(SRA->RA_NOME+Space(70),70))			//	075		144	070		Nome do trabalhador
EndIf
c14Grava += cNumCP                     							//	145		151	007		Numero CTPS
c14Grava += cSerCP                     							//	152		156	005		Serie CTPS
cEnderec := alltrim(SRA->RA_ENDEREC)+" "+Alltrim(SRA->RA_COMPLEM)
c14Grava += FSubst(Left(cEnderec+Space(50),50))				//	157		206	050		Endereco
c14Grava += FSubst(Left(SRA->RA_BAIRRO+Space(20),20))			//	207		226	020		Bairro
c14Grava += FSubst(Left(SRA->RA_CEP+Space(08),08))				//	227		234	008		CEP
c14Grava += FSubst(Left(SRA->RA_MUNICIP+Space(20),20))			//	235		254	020		Cidade
c14Grava += Left(SRA->RA_ESTADO+Space(02),02)					//	255		256	002		UF
c14Grava += Space(103)											//	257		359	103		Brancos
c14Grava += "*"													//	360		360	001		"*"
c14Grava += CHR(13)+CHR(10)										//  Fim de linha

GravaSFP(c14Grava,"14")

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DBF_TIPO20³ Autor ³ Cristina Ogura       ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Registro de tomador de servico                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DBF_TIPO20(ExpA1,ExpC1,ExpC2,ExpC3)                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function DBF_TIPO20(aInfo,cInfo,cTipo,cInsc,lFlag,n20SalFam,nT13Inss,nValDPrev,cCustoAux,cAuxFil)

Local c20Grava
Local cNome		:=	""
Local cEnder	:=	""
Local cBairro	:=	""
Local cCep		:=	""
Local cMunic	:=	""
Local cEstado	:=	""
Local cGpsCd  	:= cCodGps20
Local nValFat1	:= 0 
Local nValRet1 	:= 0
Local cCompet	:= 	Right(Str(Year(dAuxpar01)),4)+Substr(DtoC(dAuxpar01),3,3)

Private cCusto	:= cCustoAux
Private cFil	:= cAuxFil

Private nSal_Fam := 0

If lFlag .And. aInfo[15] # 1			// SI3
	//--So buscar no SI3 quando houver CEI cadastrado
	If TYPE("SI3->I3_CEI") # "U" .AND. !EMPTY(SI3->I3_CEI)
	
		cNome 	:= 	If(TYPE("SI3->I3_NOME") 	# "U"	,SI3->I3_NOME	,CriaVar("RA_NOME"))
		cEnder	:= 	If(TYPE("SI3->I3_ENDEREC") 	# "U"	,SI3->I3_ENDEREC,If(TYPE("SI3->I3_ENDER") # "U",SI3->I3_ENDER,CriaVar("RA_ENDEREC"))) 
		cBairro	:=	If(TYPE("SI3->I3_BAIRRO") 	# "U"	,SI3->I3_BAIRRO	,CriaVar("RA_BAIRRO"))
		cCep	:=	If(TYPE("SI3->I3_CEP") 		# "U"	,SI3->I3_CEP	,CriaVar("RA_CEP"))
		cMunic	:=	If(TYPE("SI3->I3_MUNICIP") 	# "U"	,SI3->I3_MUNICIP,CriaVar("RA_MUNICIP"))
		cEstado	:=	If(TYPE("SI3->I3_ESTADO") 	# "U"	,SI3->I3_ESTADO	,CriaVar("RA_ESTADO"))
		cGpsCd	:=	If(TYPE("SI3->I3_CODGPS") 	# "U" .and. !empty(SI3->I3_CODGPS) ,SI3->I3_CODGPS, cGpsCd )
        
        If nValRet == 0
			nValRet	:= If(TYPE("SI3->I3_RETIDO") # "U",SI3->I3_RETIDO,0)
       	EndIF
       	If nValFat == 0
			nValFat := If(TYPE("SI3->I3_VALFAT") # "U",SI3->I3_VALFAT,0)
		EndIf	
	Else	
		cNome	:= aInfo[03]
		cEnder	:= aInfo[04]
		cBairro	:= aInfo[13]
		cCep	:= aInfo[07]
		cMunic	:= aInfo[05]
		cEstado	:= aInfo[06]
		cGpsCd  := cCodGps
	Endif	
Else
	cNome	:= aInfo[03]
	cEnder	:= aInfo[04]
	cBairro	:= aInfo[13]
	cCep	:= aInfo[07]
	cMunic	:= aInfo[05]
	cEstado	:= aInfo[06]
EndIf              

If ExistBlock("GPM610TP20")
	Execblock("GPM610TP20",.F.,.F.)                  
	cFPAS 		:= 	If(!empty(cFPAS_Tom),cFPAS_TOM,cFPAS)
	cSimples	:= 	If(!empty(cSimp_Tom),cSimp_Tom,cSimples)
	cNome 		:= 	If(!empty(cNome_Tom),cNome_Tom,cNome)
	cEnder		:= 	If(!empty(cEnder_Tom),cEnder_Tom,cEnder)
	cBairro		:=	If(!empty(cBairro_Tom),cBairro_Tom,cBairro)
	cCep		:=	If(!empty(cCep_Tom),cCep_Tom,cCep)
	cMunic		:=	If(!empty(cMunic_Tom),cMunic_Tom,cMunic)
	cEstado		:=	If(!empty(cEstado_Tom),cEstado_Tom,cEstado)
EndIf

//--Quando for outros codigos deve ser preenchido com Brancos
If !(cRecol$ "130/135/155/608") .or. (cRecol$ "211/317/337") .or. (cCompet < "1998/10")
	cGpsCd  := Space(4)
Endif

If ExistBlock("GPM610SalFam")
	Execblock("GPM610SalFam",.F.,.F.,{cAuxFil})                  
	n20SalFam := 	If( nSal_Fam > 0, nSal_Fam, n20SalFam)
Endif

// Salario Familia nao deve sair para competencia 13
// So deve sair para 150, 155, 317,337,608, 907, 908 e 910
If (Substr(cDataRef,4,2) == "13") .Or. ;
	(!cRecol $ "150/155/608") .or. cFPAS  $"868";
	.or. (cCompet < "1998/10")
	n20SalFam  := 0
EndIf
n20SalFam := n20SalFam * 100

//--Valor do Inss 13o. e Valor devido a Previdencia    
cIndInss := "0"
If (nTipo # 2) .and. Month(dAuxPar01) = 12 .And. cRecol$ (If(nVersao # 3,"150/155/608/907/908","150/155/608"))

	nT13Inss	:= nT13Inss * 100
	If nValDPrev < 0.00
		nValDPrev := nValDPrev * (-1)
		cIndInss  := "1"	
	Endif				
	nValdPrev	:= nValDPrev * 100
Else
	nT13Inss	:= 0	
	nValDPrev	:= 0
Endif
If ! cRecol$ "211" .or. (cCompet < "2000/03")  //--Valor da fatura só pode ser para codigo 211
	nValfat := 0.00
Endif	
nValFat1 := nValFat*100 

If ! cRecol$ "150/155" .or. (cCompet < "1999/02") .OR.;
	(nVersao == 3 .and. cFPAS$"604" .and.cRecol $ "150" .and. cCompet >"2001/10")   
	nValRet := 0.00
Endif	
nValRet1 := nValRet*100

//														De	Ate	Tam		Descricao
c20Grava := "20"									//	001	002	002		Sempre "20"
//--Quando Filial For Cei e Centraliza Gerar Filial Responsalvel
If nCentra = 1 .And. cInfo = "2"
	c20Grava += Left(cInfoResp+Space(01),01)		//	003	003	001		1-CGC/CNPJ	2-CEI
	c20Grava += space(14-len(alltrim(cInscResp)))+alltrim(cInscResp) //	004	017	014		Inscricao da empresa
Else
	c20Grava += Left(cInfo+Space(01),01)			//	003	003	001		1-CGC/CNPJ	2-CEI
	c20Grava += space(14-len(alltrim(aInfo[08])))+alltrim(aInfo[08])//	004	017	014		Inscricao da empresa
Endif	
c20Grava += Left(cTipo+Space(01),01)				//	018	018	001		Tipo de inscricao tomador
c20Grava += space(14-len(alltrim(cInsc)))+alltrim(cInsc)	//	019	032	014		Inscricao do tomador
c20Grava += Replicate("0",21)						//	033	053	021		Zeros
c20Grava += FSubst(Left(cNome+Space(40),40))		//	054	093	040		Nome
c20Grava += FSubst(Left(cEnder+Space(50),50))		//	094	143	050		Endereco
c20Grava += FSubst(Left(cBairro+Space(20),20))		//	144	163	020		Bairro
c20Grava += FSubst(Left(cCEP+Space(08),08))		//	164	171	008		CEP
c20Grava += FSubst(Left(cMunic+Space(20),20))		//	172	191	020		Cidade
c20Grava += Left(cEstado+Space(02),02)				//	192	193	002		UF
c20Grava += space(4-len(alltrim(cGpsCd)))+alltrim(cGpsCd)//	194	197	004		Codigo de Pagamento Gps
c20Grava += StrZero(n20SalFam,15)					//	198	212	015		Salario Familia
c20Grava += StrZero(0,15)							//	213 227	015		Contr.Desc.Empregado Comp. 13
c20Grava += "0" 									//	228	228	001		Indicador de valor negativo ou positivo Vl.Dev.Prev.
c20Grava += StrZero(0,14)							//  229	242	014		Valor Devido a Previdencia Social Comp. 13
c20grava += StrZero(nValRet1,15)					//  243	257	015		Valor retencao lei 9711/98
c20grava += Strzero(nValFat1,15)					//	258	272	015		Valor das faturas Emitidas Tomador								
c20grava += Repl("0",45)							//  273	317	045		implementacoes Futuras
c20Grava += Space(42)								//	318	359	042	 	Brancos
c20Grava += "*"										//	360	360	001		"*"
c20Grava += CHR(13)+CHR(10)							//	Fim de linha

GravaSFP(c20Grava,"20")

nSal_Fam := 0

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DBF_TIPO21³ Autor ³ Cristina Ogura       ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Registro informacoes adicionais do tomador de servico      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DBF_TIPO21(ExpA1,ExpC1,ExpC2,ExpC3)                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function DBF_TIPO21(aInfo,cInfo,cTipo,cInsc)
Local c21Grava            
Local cCompet	:= Right(Str(Year(dAuxpar01)),4) +"/"+ Substr(cDataRef,4,2)

If Substr(cDataRef,4,2) == "13" .or. cRecol $ "317/337" .or. cCompet< "1998/10" ;
	.or. cRecol $ "145/307/317/327/337/345/640/660"
	nValComps 	:= 0              
	cPerIniCmp	:= ""
	cPerFimCmp	:= ""
EndIf                  

//															De		Ate	Tam		Descricao
c21Grava :=	"21"										//	001		002	002		Sempre "21"
c21Grava +=	Left(cInfo+Space(01),01)					//	003		003	001		1-CGC/CNPJ	2-CEI
c21Grava +=	space(14-len(alltrim(aInfo[08])))+alltrim(aInfo[08])//	004		017	014		Inscricao da empresa
c21Grava +=	Left(cTipo+Space(01),01)					//	018		018	001		Tipo de inscricao tomador
c21Grava +=space(14-len(alltrim(cInsc)))+alltrim(cInsc)//	019		032	014		Inscricao do tomador
c21Grava +=	Replicate("0",21)							//	033		053	021		Zeros
c21Grava +=	strzero(nValComps*100,15)					//	054		068	015		Compensacao - Valor
c21Grava +=	Left(cPerIniCmp+space(06),06)				//	069		074	006		Compensacao - Periodo Inicio
c21Grava +=	Left(cPerFimCmp+space(06),06)				//	075		080	006		Compensacao - Periodo Fim
c21Grava +=	Replicate("0",15)							//	081		095	015		Recol. Competencia Anterior - Segurados
c21Grava +=	Replicate("0",15)							//	096		110	015		Recol. Competencia Anterior - Empresa
c21Grava +=	Replicate("0",15)							//	111		125	015		Parcelamento do FGTS                   
c21Grava +=	Replicate("0",15)							//	126		140	015		Parcelamento do FGTS somatorio              
c21Grava +=	Replicate("0",15)							//	141		155	015		Parcelamento do FGTS Valor Recolhido        
c21Grava +=	Space(204)									//	156		359	204		Brancos
c21Grava +=	"*"											//	360		360	001		"*"
c21Grava +=	CHR(13)+CHR(10)							//						Fim de linha

GravaSFP(c21Grava,"21")

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DBF_TIPO30³ Autor ³ Cristina Ogura       ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Registro do trabalhador                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DBF_TIPO30(ExpA1,ExpC1,ExpN1)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function DBF_TIPO30(aInfo,cInfo,nFgts,cTipo,cInsc,nB13Inss,nBinss,nB13Fgts,nInss,nB13InRc,aAfast,aLog,aTitle,aTotRegs,nInssOutr,cCusto,nBinssPF,nBinssPJ,n13Inss,nValor247)

Local c30Grava
Local cCateg	:= 	Space(02)
Local cMatr		:=	""
Local cNumCP	:=	""
Local cSerCP	:=	""
Local cOcorr	:=	""
Local nBase13	:=	0
Local nSalario	:=	0
Local nSalHora	:=	0
Local nSalDia	:=	0
Local nSalMes	:=	0
Local nVinculos	:=	0
Local cAdmissa	:=	""
Local cOpcao  	:=	""
Local cNasc   	:=	""
Local lGera32 	:= 	.F.
Local cClasse 	:= 	Space(02)
Local cCbo	  	:= 	fCodCBO(SRA->RA_FILIAL,SRA->RA_CODFUNC,dAuxPar01,If(nVersao#3,.F.,.T.))
Local nBaseAfas	:= 	0
Local nB13Iaux	:= 	0
Local nBInssAux	:= 	nBInss
Local cAuxFil	:= 	SRA->RA_FILIAL
Local aArea	    
Local lAutonomo := .F.
Local nPosA
Local n 		:= 0
Local nI        := 0
Local nX        := 0
Local cCompet	:= 	Right(Str(Year(dAuxpar01)),4)+Substr(DtoC(dAuxpar01),3,3)

cCateg	:= FCateg(nFgts)
                                       
If cRecol $ "130" .and. cCateg # "02"
	Return
EndIf
	
//-- Matricula
If cCateg $ If(nVersao==1,"13/14/15/16/17",If(nVersao==2,"06/13/14/15/16/17/18","06/13/14/15/16/17/18/22/23/24/25"))
	cMatr:= Space(11)
Else
	cMatr:= StrZero(Val(SRA->RA_MAT),11)
EndIf

//-- Numero e Serie da Carteira
cNumCP := SRA->RA_NUMCP
cSerCP := SRA->RA_SERCP        

If cCateg $ "01/03/04/06/07/26"
	cNumCP := StrZero(Val(cNumCP),07)
	cSerCp := StrZero(Val(f610TrocaLetra(cSerCP)),05)
Else
	cNumCP := Space(07)
	cSerCP := Space(05)
EndIf

//-- Data de admissao
If cCateg $ If(nVersao#1,"01/03/04/05/06/07/11/12/19/20/21/26","01/03/04/05/06/07/11/12")
	cAdmissa := Transforma(SRA->RA_ADMISSA)
Else
	cAdmissa := Space(08)
EndIf

//-- Data de opcao
If cCateg $ "01/03/04/05/06/07"
	cOpcao := Transforma(SRA->RA_OPCAO)
Else
	cOpcao := Space(8)
EndIf

//-- Data de Nascimento
If cCateg $ if(nVersao#1,"01/02/03/04/05/06/07/12/19/20/21/26","01/02/03/04/05/06/07/12")
	cNasc := Transforma(SRA->RA_NASC)
Else
	cNasc := Space(8)
EndIf

//-- Quando afastado considera como remuneracao a base FGTS e Nao Base Inss
If cSitFunc == "A" .And. !cCateg$ '11'
	nBFgts := If(nBFgts==0, 0.01, nBFgts) 	//Se base do FGTS estiver zerada, e funcionario for afastado, envir 0.01   
	nBInss := nBFgts
EndIf

// Seleciona base FGTS quando nao for Autonomo ou Pro-Labore sem FGTS	
If nBase == 1 .And. ! cCateg$ '11/13/14/15/16/17/18/22/23/24/25' 
	nBInss := If( cSitFunc == "D" .and. lSaque .and. lGRRF, nBInss, nBFgts )
EndIf

//-- Diretor nao Empregado sem FGTS deve ser levado o salario
If cCateg == "11" .And. nBInss == 0 .and. (cSitFunc # "D") 
	FSalario(@nSalario,@nSalHora,@nSalDia,@nSalMes,"A")
	nBInss := nSalario
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Diretora nao Empregada com ou sem FGTS, de licenca maternidade,se não houver qualquer ³
//³remuneração por parte da empresa durante o período de afastamento nao deve ser levada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cCateg $ "05#11"   
	If Ascan(aAfast, {|x|x[2]=="Z1"})	== 0
		For n:=1 to Len(aAfast)
			If Substr(aAfast[n,2],1,1) == "Q" .and. MesAno(aAfast[n,1]) < MesAno(dAuxPar01)
				nBInss := nBFgts              
			EndIf	
		Next n
	Else
		nBInss := nBInssPro              		
	EndIf	
Endif

//--Verifica Ocorrencia do Funcionario
//-- Ocorrencia                                 
cOcorr := Space(02)

If TYPE("SRA->RA_OCORREN") # "U"
	cOcorr := SRA->RA_OCORREN
	    
	If SR9->(dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"RA_OCORREN"))    
    	
    	While SR9->R9_FILIAL+SR9->R9_MAT+SR9->R9_CAMPO == SRA->RA_FILIAL+SRA->RA_MAT+"RA_OCORREN"

				If SR9->R9_DATA <= dAuxpar01
					cOcorr := Alltrim(SR9->R9_DESC)
				Else
					Exit
				EndIf
    
    		SR9->(dbSkip())
    	EndDo
    EndIf
EndIf

If empty(cOcorr) .and. Type("SI3->I3_OCORREN") # "U"
	aArea := GetArea()
	dbSelectArea("SI3")
	SI3->(dbSetOrder(1))

	If cFilial == space(FWGETTAMFILIAL) .Or. (cAuxFil == space(FWGETTAMFILIAL)  .And. cFilial # space(FWGETTAMFILIAL)) .or. empty(cAuxFil)
		cAuxFil := cFilial
	Endif

	If dbSeek( cAuxFil + cCusto ) 
		cOcorr := SI3->I3_OCORREN
	Endif             
	RestArea(aArea)
EndIf	
//--Quando houver multiplos vinculos passa a verificar a ocorrencia 
//--e altera para ocorrencia de multiplos vinculos se estiver com ocorrencia normal.
If nInssOutr > 0 
	If Empty(cOcorr)  .Or. cOcorr == "01"
		cOcorr := "05"
	Elseif cOcorr == "02"
		cOcorr := "06"
	Elseif cOcorr == "03"
		cOcorr := "07"
	Elseif cOcorr == "04"
		cOcorr := "08"
	Endif	
Endif			

//-- Indica outros vinculos para o funcionario ou o valor descontado no caso de dissidio/recolhimento de trabalhador avulso
If  nInssOutr > 0 .or. (cOcorr $"05#06#07#08") .or. cRecol $ "650/130"  
	nVinculos:= If(nTipo == 1, ((nInss+If(cRecol $ "130*650", n13Inss, 0)) * 100),(n13Inss * 100))
//-- Quando Nao tem outros vinculos mas esta se afastando ou retornando de 
//-- Maternidade a partir de 01/12/1999 deve ser informado neste o Inss no campo	
ElseIf Len(aAfast) > 0
	For n:=1 to Len(aAfast)
		If MesAno(aAfast[n,1]) == MesAno(dAuxPar01) .And. aAfast[n,2]$ "Q1#Z1"
			If aAfast[n,1] >= CTOD("01/12/99","DDMMYY") .and. If( aAfast[n,2]$"Q1",aAfast[n,1] <= CTOD("31/08/03","DDMMYY"),.T.)
   				If aAfast[n,2] == "Z1" 
   					For nX := n to 1 step -1
   						If aAfast[nX,2]$"Q1"
							If aAfast[nX,1] > CTOD("31/08/03","DDMMYY")   					
		   						nVinculos := 0
	   					  	Else	
								nVinculos:= If(nTipo == 1 ,(nInss * 100),(n13Inss * 100))
	   						EndIf	
   						  	Exit
   						EndIf	
   					Next   
   				Else	
					nVinculos	:= If(nTipo == 1 ,(nInss * 100),(n13Inss * 100))
				EndIf	
				Exit
			Endif	
		Endif	
	Next n
Endif		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcionario transferido ou Demitido se valor Zero gerar com 0.01³
//³para poder gerar o registro da movimentação( tipo 32).          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cSitFunc == "D" .and. !(cCateg $ "11#13#14")
	If MesAno(SRA->RA_DEMISSA) == MesAno(dAuxpar01) .And. nBInss == 0.00
		If cCusto # SRA->RA_CC .and. lRat 
			nBInss := 0.00
		Else		
			nBInss := 0.01
		EndIf	
	Endif		
Endif	

//-- BaseInssAux dos Funcionarios Afastados O1,O2,R,Z2,Z3,Z4
//--Verifica no Array aAfast se Funcionario esteve esses tipos no mes
If Len(aAfast) > 0                        
	nPosA := Ascan(aAfast,{ |x|x[2] $ "O1/O2/Z2/Z3/Z4" .Or. x[2] =="R" })	
	If nPosA > 0 .And. cCateg$ If(nVersao#1,"01/04/06/07/12/19/20/21","01/04/06/07")
		nBaseAfas := nBInssAux
	Else
		nBaseAfaS := 0.00	
	Endif                
	If nPosA > 0 .And. ( nVersao == 3 .and. cRecol $ "145/307/317/327/337/345/640/660") .or. (cCompet < "1998/10")
		nBaseAfaS := 0.00	
	Endif                
Endif		           

//--Quando Competencia 12 a Base Inss 13o deve sair na posicao 247 a 261 
//--quando houver diferencao de 13o no mes 12, caso contrario saira zerado
//--e na  232 a 246 deve sair a Diferenca de 13o. quando houver.
//-- na variavel nB13Inss esta a Base Inss 13o Total e na nB13InRc esta 
//--a Diferenca paga no mes 12
If cRecol == "904" .and. nVersao==2
	nB13IAux	:= 0.00       
	nB13Inss	:= 0.00
ElseIf nTipo == 1 .And. Month(dAuxPar01) == 12 
	//--Se TIVER Diferenca DE 13o. Mes 12 
	If nB13InRc > 0
		nB13IAux := nB13Inss - nB13Inrc
		nB13Inss := nB13InRc                   
		If cSitFunc # "D" .and. nB13IAux == 0
			nB13IAux := 0.01
		EndIf
	//--Se Nao For Demitido na Comp.12 nao aceita Base Inss 13o.
	Elseif cSitFunc # "D" .and. ! cCateg $ "02"
		nB13Inss	:= 0.00
	Endif	
Else
	nB13IAux	:= 0
Endif	
            
//RESCISAO SOMENTE NO MES DE COMPETENCIA            
If cSitFunc == "D" .And. (nB13Inss == 0 )
	If (! SRA->RA_AFASFGT$"H/N/5") .and. (SRA->RA_AFASFGT$ 'I*J*K*2*3*4*L*S' .And. MesAno(SRA->RA_DEMISSA) == MesAno(dAuxPar01))
		nB13Inss := 0.01
	EndIf	
	
	If (year(SRA->RA_ADMISSA) == YEAR(SRA->RA_DEMISSA) .and. ( SRA->RA_DEMISSA-SRA->RA_ADMISSA )+1< 15 )  .or. ;
		(SRA->RA_DEMISSA - ctod("01/01/"+substr(mesano(dAuxPar01),1,4))< 15)
		nB13Inss := 0.00
	EndIf
//Quando rescisao complementar, nao enviar valor de base 13o INSS	
ElseIf cSitFunc == "D" .And. (nB13Inss > 0 ) .And. MesAno(SRA->RA_DEMISSA) < MesAno(dAuxPar01) .and. !(cRecol$"650")
	nB13Inss := 0.00                                                                            
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Rescisão em dezembro, após recolhimeno da GPS da competência 13                             ³
//³não havendo 13o salario a informar no campo Base de calculo 13o salario Prev. Social,       ³
//³por ja ter sido considerada a base de calculo na competência 13, deve-se informar R$ 0,01 no³
//³referido campo da competência 12.( Somente coloca 0,01 se não houver complemento de 13o     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf cSitFunc == "D" .and. (nB13Inss > 0 ) .And. MesAno(SRA->RA_DEMISSA) == MesAno(dAuxPar01) .and. ;
		nValor247 > 0 .and. nTipo == 1 .and. nB13InRc == 0
	
	nB13Inss := 0.01
EndIf                                 
//Nao enviar base INSS 13o quando a rescisao for por justa causa
If cSitFunc == "D" .And. SRA->RA_AFASFGT$ 'H' 
	nB13Inss := 0.00
EndIf                                 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quando funcionario trabalhar menos que 15 dias no ano, nao³
//³enviar Base de calculo 13o. Salario Previdencia Social.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !empty(SRA->RA_DEMISSA)
	If ( YEAR(SRA->RA_ADMISSA) == YEAR(dAuxPar01) .and.((SRA->RA_DEMISSA-SRA->RA_ADMISSA)+1)<15 ) .or. ;
		(YEAR(SRA->RA_ADMISSA) < YEAR(dAuxPar01) .and. year(SRA->RA_DEMISSA)==year(dAuxPar01)) .and.;
		((SRA->RA_DEMISSA-ctod("01/01/"+strzero(year(SRA->RA_DEMISSA)))+1)<15)
		nB13Inss := 0.00
	EndIf
EndIf

If nVersao == 3 .and. ! cCateg $"01/02/04/06/07/12/19/20/21/26" .or. (cCompet < "1998/10" ) ;
	.or. cRecol $ "145/211/307/317/327/337/345/640/660"
	nB13Inss := 0
Endif	

If nVersao == 3 .and. cCateg $"05/11/13/14/15/16/17/18/22/23/24/25"
	nB13FGTS := 0
Endif	       

If cRecol $ "130"
	nB13Inss := If(empty(nB13Inss),nB13FGTS,nB13Inss)
EndIf
               
nB13IAux := If(cCompet < "1998/10" ,0,nB13IAux)

//-- Multiplica por 100 para trasformar em string
nBinss		:= nBInss * 100
nB13Inss	:= nB13Inss * 100
nB13FGTS	:= nB13FGTS * 100
nBaseAfas	:= nBaseAfas * 100
nB13IAux	:= nB13IAux	 * 100

If nTipo == 1    // Tipo 1-Folha/Ferias	   2-13o.Salario
	nBase13	:= nB13Inss
Else
	nBase13 := nB13Fgts
	nBInss  := 0
	nB13Fgts:= 0
	If !cCateg$ "01*04*12"
		cCateg := "01"
	Endif
Endif

If (Substr(cDataRef,4,2) # "13" .And. cSitFunc # "D") .Or. ;
	(cSitFunc == "D" .And. MesAno(SRA->RA_DEMISSA) > MesAno(dAuxPar01))
	nBase13 := 0
EndIf

// Classe de contribuicao para autonomo
If cCateg $ "14/16" .and. (cCompet >= "1998/10")
	cClasse := SRA->RA_CLASSEC
EndIf	

//Verifica se e autonomo
lAutonomo := If( (nBinssPF >0 .or. nBinssPJ >0),.T., .F.)
  
For nI := 1 to 2
    If lAutonomo
 		//Utiliza base de Inss especifica quando for Autonomo 
 		// (nI = 1) presta servico para pessoa Fisica/ (nI = 2) Presta servico para Pessoa Juridica
   		If nBinssPF == 0 .and. nI == 1 
   			Loop
   		ElseIf nBinssPJ == 0 .and. nI == 2 
   			Loop
		ElseIf nBinssPF >0 .and. nI == 1 
			nBInss := nBinssPF *100
			cCateg := "24"
		Elseif nBinssPJ > 0 .and. nI == 2	
			nBInss := nBinssPJ *100
			cCateg := "17"
		EndIf	
		// Quando autonomo lancar Vl Desc. Segurado quando possuir multiplos vinculos     
		If (nInssOutr > 0) .or. (cOcorr $"05#06#07#08")
			nVinculos := If( nI == 1, nInssPF, nInssPJ)*100
		EndIf	
	Else
	    //Se nao for autonomo nao precisa passar 2 vezes no For/Next                              
		If nI == 1
			Loop
		EndIf	
	EndIf	
	nVinculos := If((cCompet < "1998/10" ).or. (cRecol $ "145/307/317/327/337/345/640/660"),0,nVinculos)
    
	If (nBInss+nB13Fgts # 0.and. !lGera30Zerado) .Or. ;
		(nBInss+nB13Fgts <= 1 .and. lGera30Zerado) .or. ;
		(nTipo = 2 .And. nB13Inss > 0)   // nTipo 1-Folha/Ferias	 2-13o.Salario
		//															De  Ate	Tam		Descricao
		c30Grava := "30"	 									//	001	002	002		Sempre "30"
		//--Quando Filial For Cei e Centraliza Filial gera Filial Responsavel
		If nCentra = 1 .And. cInfo = '2'
			c30Grava += Left(cInfoResp+Space(01),01)			//	003	003	001		1-CGC/CNPJ	2-CEI
			c30Grava += space(14-len(alltrim(cInscResp)))+alltrim(cInscResp)//	004	017	014		Inscricao da empresa
		Else	
			c30Grava += Left(cInfo+Space(01),01)				//	003	003	001		1-CGC/CNPJ	2-CEI
			c30Grava += space(14-len(alltrim(aInfo[08])))+alltrim(aInfo[08])//	004	017	014		Inscricao da empresa
		Endif	
		IF cRecol # '115'
			c30Grava += Left(cTipo+Space(01),01)				//	018	018	001		Tipo de inscricao tomador
			c30Grava += space(14-len(alltrim(cInsc)))+alltrim(cInsc)	//	019	032	014		Inscricao do tomador
		Else
			c30Grava += Space(1)								//	018	018	001		Tipo de inscricao tomador
			c30Grava += Space(14)								//	019	032	014		Inscricao do tomador
		Endif
		c30Grava += AllTrim(SRA->RA_PIS)						//	033	043	011		PIS/PASEP/CI
		c30Grava +=	cAdmissa                    				//	044	051	008		Data Admissao
		c30Grava +=	Left(cCateg+Space(02),02)					//	052	053	002		Categoria trabalhador
		If SRA->(FieldPos("RA_NOMECMP")) # 0  
			c30Grava += FSubst(Left(If(!empty(SRA->RA_NOMECMP),SRA->RA_NOMECMP,SRA->RA_NOME)+Space(70),70))	
		Else	
			c30Grava += FSubst(Left(SRA->RA_NOME+Space(70),70))	//	054	123	070		Nome do trabalhador
        EndIf
		c30Grava += FSubst(Left(cMatr,11))						//	124	134	011		Matricula do empregado
		c30Grava +=	Left(cNumCP,07)								//	135	141	007		Numero do CTPS
		c30Grava +=	Left(cSerCP,05)								//	142	146	005		Serie CTPS
		c30Grava += cOpcao										//	147	154	008		Data da opcao de FGTS
		c30Grava +=	cNasc										//	155	162	008		Data Nascimento
		If nVersao # 3
			c30Grava += Left(SRA->RA_CBO+Space(5),05)			//	163	167	005		CBO do Cargo
	    Else
			c30Grava += "0"+Substr(cCbo,1,4)					//	163	167	005		CBO do Cargo
	    EndIF
		c30Grava += StrZero(nBInss,15)							//	168	182	015		Remuneracao sem 13o.
		c30Grava += StrZero(nB13Fgts,15)						//	183	197	015		Remuneracao sobre 13o.
		c30Grava +=	Left(cClasse+Space(02),02)  				//	198	199	002		Classe de contribuicao
		c30Grava += Left(cOcorr+Space(02),02)					//	200	201	002		Ocorrencia
		c30Grava += StrZero(nVinculos,15)						//	202	216	015		Valor Descontado do Segurado 
		c30Grava += StrZero(nBaseAfas,15)						//	217	231	015		Remuneracao Base Calculo Contr.Prev.	
		c30Grava += StrZero(nB13Inss,15)						//	232	246	015		Base calculo 13o. Salario Previdencia Social (Comp.13 ou rescisao)
		c30Grava += StrZero(nB13IAux,15)						//	247	261	015		Sal.Contr. Prev. Compl. 13o. (Total)
		c30Grava += Space(98)									//	262	359	098		Brancos
		c30Grava += "*"											//	360	360	001		"*"
		c30Grava += CHR(13)+CHR(10)								//	Fim de linha
	
		GravaSFP(c30Grava,"30",lAutonomo)
	
		lGera32 := .T.
	
		If cSitFunc # "D"  .OR. ;
			(SRA->RA_AFASFGT $ "H#J#K#M#N1#N2#S2#S3#U1" .and. MesAno(dAuxpar01) < MesAno(SRA->RA_DEMISSA) )
			If aTotRegs[10]== 0
				cLog := "Funcionario(s) Enviado(s): Filial       Matric.  Nome                            Remun. sem 13o    Remun. sobre 13o       Base INSS 13o "  //
				Aadd(aTitle,cLog)
				Aadd(aLog,{})
				aTotRegs[10] := len(aLog)
		    EndIf
			Aadd(aLog[aTotRegs[10]],space(25)+SRA->RA_FILIAL+"-"+SRA->RA_MAT+Space(13-nTamFil)+substr(SRA->RA_NOME,1,28)+"  "+Transform(nBInss/100,"@E 999,999,999.99")+;
			space(06)+Transform(nB13FGTS/100,"@E 999,999,999.99")+space(06)+Transform(nB13Inss/100,"@E 999,999,999.99"))
		
		    aTotal[1]	+= (nBInss/100)
		    aTotal[2]	+= (nB13FGTS/100)
		    aTotal[3]	+= (nB13Inss/100)
		Else
			If aTotRegs[11]== 0
				cLog := "Enviado(s) Demitido(s):  Filial       Matric.  Nome                            Remun. sem 13o    Remun. sobre 13o       Base INSS 13o "  // 
				Aadd(aTitle,cLog)
				Aadd(aLog,{})
				aTotRegs[11] := len(aLog)
		    EndIf
			Aadd(aLog[aTotRegs[11]],space(25)+SRA->RA_FILIAL+Space(13-nTamFil)+SRA->RA_MAT+" - "+substr(SRA->RA_NOME,1,28)+"  "+Transform(nBInss/100,"@E 999,999,999.99")+;
			space(06)+Transform(nB13FGTS/100,"@E 999,999,999.99")+space(06)+Transform(nB13Inss/100,"@E 999,999,999.99"))
		
		    aTotal[4]	+= (nBInss/100)
		    aTotal[5]	+= (nB13FGTS/100)
		    aTotal[6]	+= (nB13Inss/100)
	    EndIf            
	    
	    If Ascan( aGerou30,{|x|x[1]+x[2]==SRA->RA_FILIAL+aInfo[08]}) == 0 
		    Aadd(aGerou30,{SRA->RA_FILIAL,aInfo[08]})
		EndIf		    
	EndIf
Next nI

Return lGera32

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DBF_TIPO32³ Autor ³ Cristina Ogura       ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Registro movimentacao trabalhador                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DBF_TIPO32(ExpA1,ExpC1,ExpN1)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function DBF_TIPO32(aInfo,cInfo,nFgts,cTipo,cInsc,nFgtsRes,aAfast,aLog,aTitle,aTotRegs,lGera32)
Local c32Grava
Local cCodAfast		:=""
Local cIndica		:= ""
Local cAux			:= ""
Local cCompet		:= Right(Str(Year(dAuxpar01)),4) + Substr(cDataRef,4,2)
Local cDiasAfas		:= ""
Local nVezes 		:= Len(aAfast)
Local nDescInss		:= 0
Local nDiasMes		:= nDiasAfas - nDiasMat - nDiasAc - nDiasAd
Local cAdmissa		:= ""      
Local cCateg		:= Space(02)
Local cDescMov		:= ""
Local nPosMov		:= 0
Local nMesAux
Local nAnoAux 
Local n
Local nPosV3		:= 0

//Encontra a categoria
cCateg := FCateg(nFgts)
// Nao pode ser informado para os codigos de recolhimento abaixo.
If cRecol $ "145/307/317/327/337/345"
	Return
Endif	

//--So deve gerar para essas categorias conforme manual lay-out folha
If ! cCateg$ If(nVersao#1,"01/02/03/04/05/06/07/11/12/19/20/21/26","01/02/03/04/05/06/07/11/12") 
	Return
Endif	

nPosV3 := Ascan( aAfast,{|x|x[2]=="V3"})

For n:= 1 To nVezes
	
	If nPosV3 >0 .and. !Alltrim(aAfast[n,2])$ "V3"
		Loop
	EndIf	 
 	cIndica	:= ""
    //Quando for rescisao
    //-- Gerar registro 32 apenas quando data de movimentacao definitiva estiver no mes da competencia,
	//-- no mes anterior ou no mes posterior.   
	If month(aAfast[n,1])+1 ==13
		nMesAux := 1
		nAnoAux := year(aAfast[n,1])+1
	Else	
	 	nMesAux := month(aAfast[n,1])+1
	 	nAnoAux := year(aAfast[n,1])
	EndIf
	
	If !Alltrim(aAfast[n,2]) $ "O1#O2#03#P1#P2#Q1#Q2#Q3#Q4#Q5#Q6#R#U3#V3#W#X#Y" 
		If MesAno(dAuxpar01) > MesAno(ctod("01/"+strzero(nMesAux,2)+"/"+strzero(nAnoAux,4)))
		   Loop
		Endif
	EndIf
	//Para os tipos de movimentacoes abaixo, o movimeno deve estar compreendida no mes 
	//imediatamente anterior ou no mês da competencia
	If Alltrim(aAfast[n,2]) $ "H#J#K#M#N1#N2#S2#S3#U1" 
		If MesAno(dAuxpar01) < MesAno(ctod("01/"+strzero(nMesAux-1,2)+"/"+strzero(nAnoAux,4)))
		   Loop
		Endif
	EndIf
	// Indica para Afast O ou P, que func se afastou por menos de 15 dias.
	If !aAfast[n,5]
		nDescInss	:= 0
	Else
		//-- Calcula os dias de afastamento qdo tenho 2 afast no mesmo mes
		If aAfast[n,4] # 0
			nDescInss 	:= aAfast[n,4]
			nDiasMes	-= aAfast[n,4]
		Else
			nDescInss	:= nDiasMes
		EndIf
	EndIf

	//-- Indicativo Recolhimento FGTS
	If SubStr(aAfast[n,2],1,1) $ "I/L"   
		cIndica := "N"
		If nFgtsRes ==0 .and. !(aAfast[n,6])
			cIndica := "N"
		ElseIf (nFgtsRes # 0 .and. cCateg $ "01/03/04/05/06/07") .or. (nFgtsRes ==0 .and. (aAfast[n,6]))
			cIndica := "S"
		EndIf
	EndIf

	If SubStr(cDataRef,4,2) == "13"
		cIndica		:= Space(01)
		nDescInss 	:= 0
	EndIf

	If nDescInss >=30
		nDescInss := f_ultDia(dAuxPar01)
	EndIf

	// Retorno de Afastamento dias a desconsiderar igual a zero
	If aAfast[n,3]$ "R*D" .Or. Subs(aAfast[n,2],1,1)$ "I*Q*Z" .Or.;
		Substr(cDataRef,4,2) == "13"
		nDescInss := 0
	EndIf

	If nDescInss == 0
		If Substr(aAfast[n,2],1,1) $ "P*O"
			cDiasAfas:= "00"
		Else
			cDiasAfas:= Space(02)
		EndIf
	Else
		cDiasAfas:= StrZero(nDescInss,2)
	EndIf

	//-- Data de admissao
	If cCateg $ If(nVersao#1,"01/03/04/05/06/07/11/12/19/20/21/26","01/03/04/05/06/07/11/12")
		cAdmissa := Transforma(SRA->RA_ADMISSA)
	Else
		cAdmissa := Space(08)
	EndIf

	// Para qualquer tipo de afastamento deve ser considerado a data de
	// afastamento o dia imediatamente anterior ao efetivo afastamento.
	// Manual pag. 43 versao 3.0
	If (Substr(aAfast[n,2],1,1) # "Z" .And.(cSitFunc # "D" .or. (cSitFunc == "D" .and. Substr(aAfast[n,3],1,1) == "A") ) .and.;
	 	 Substr(aAfast[n,2],1,2) # "N3") 
    	aAfast[n,1] := aAfast[n,1] - 1
    	aAfast[n,1] := If(cIndica=="C","",aAfast[n,1])
	EndIf
                         
	cIndica	:= If(cCompet<"1998/02",space(01),cIndica)	
	
	//											   				De		Ate	Tam	Descricao
	c32Grava := "32"										//	001		002		002		Sempre "32"
	//--Quando Filial For Cei e Centraliza Filail gera Filial Responsavel
	If nCentra = 1 .And. cInfo = "2"
		c32Grava += Left(cInfoResp+Space(01),01)			//	003		003		001		1-CGC/CNPJ	2-CEI
		c32Grava += space(14-len(alltrim(cInscResp)))+alltrim(cInscResp)//	004		017		014		Inscricao da empresa
	Else
		c32Grava += Left(cInfo+Space(01),01)				//	003		003		001		1-CGC/CNPJ	2-CEI
		c32Grava += space(14-len(alltrim(aInfo[08])))+alltrim(aInfo[08])//	004		017		014		Inscricao da empresa
	Endif	
	IF cRecol # '115'
		c32Grava += Left(cTipo+Space(01),01)				//	018		018		001		Tipo de inscricao tomador
		c32Grava += space(14-len(alltrim(cInsc)))+alltrim(cInsc)//	019		032		014		Inscricao do tomador
	Else
		c32Grava += Space(1)								//	018		018		001		Tipo de inscricao tomador
		c32Grava += Space(14)								//	019		032		014		Inscricao do tomador
	Endif
	c32Grava += AllTrim(SRA->RA_PIS)			   			//	033		043		011		PIS/PASEP/CI
	c32Grava +=	cAdmissa									//	044		051		008		Data Admissao
	c32Grava += cCateg										//	052		053		002		Categoria do Trabalhador	
	If SRA->(FieldPos("RA_NOMECMP")) # 0  
		c32Grava += FSubst(Left(If(!empty(SRA->RA_NOMECMP),SRA->RA_NOMECMP,SRA->RA_NOME)+Space(70),70))	
	Else	
		c32Grava += FSubst(Left(SRA->RA_NOME+Space(70),70))	//	054		123		070		Nome do trabalhador
	EndIf
	c32Grava +=	Left(aAfast[n,2]+Space(02),02)				//	124		125		002		Codigo Movimentacao
	c32Grava += Transforma(aAfast[n,1])						//  126		133		008		Data Movimentacao
	c32Grava += Left(cIndica+Space(01),01)					//	134		134		001		Indicativo Recolhimento FGTS
	c32Grava += Space(225)									//	135		359		225		Brancos
	c32Grava += "*"											//	360		360		001		"*"
	c32Grava += CHR(13)+CHR(10)								//  Fim de linha

	If lGera32
		If aTotRegs[12]== 0
			cLog := "Funcionario(s) Enviado(s) Afastado(s):  Matric.  Nome                           Dt.Movimentacao   Cod.   Obs."  //
			Aadd(aTitle,cLog)
			Aadd(aLog,{})
			aTotRegs[12] := len(aLog)
	    EndIf
		
		nPosMov 	:= ascan(aMovimento,{|x|x[1]== aAfast[n,2]}) 
		cDescMov 	:= If(nPosMov <> 0,aMovimento[nPosMov,2],"")
		
		Aadd(aLog[aTotRegs[12]],space(39)+SRA->RA_FILIAL+"-"+SRA->RA_MAT+" - "+substr(SRA->RA_NOME,1,30)+space(2)+DtoC(aAfast[n,1])+space(04)+;
		aAfast[n,2]+space(02)+"- "+cDescMov)
	EndIf
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o registro já existe no arquivo temporário, para não gerar duplicidade.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If Ascan(aTipo32,substr(c32Grava,1,53)+substr(c32Grava,124,2)+substr(c32Grava,126,8)) == 0
       	Aadd( aTipo32,substr(c32Grava,1,53)+substr(c32Grava,124,2)+substr(c32Grava,126,8))
		GravaSFP(c32Grava,"32")
	EndIf	


Next n

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DBF_TIPO90³ Autor ³ Cristina Ogura       ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Registro Trailler						                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DBF_TIPO90(ExpA1,ExpC1,ExpN1)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function BIN_TIPO90
Local c90Grava

//															De		Ate	Tam	Descricao
c90Grava := "90"										//	1		2		2		Sempre "90"
c90Grava += Replicate("9",51)							//	3		53		51		Preenchido "9"
c90Grava += Space(306)		  							//	54		359		306		Brancos
c90Grava += "*"											//	360		360		1		"*"
c90Grava += CHR(13) + CHR(10)							// 	Fim de linha

FWrite(nHandle,c90Grava)

Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FCateg   ³ Autor ³ Cristina Ogura        ³ Data ³ 13/10/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao que define a categoria do empregados                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FCateg(ExpN1)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Valor do Fgts                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEM610  e  GPER540                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FCateg(nFgts)
Local cCateg := Space(02)

If TYPE("SRA->RA_CATEG") # "U" .AND. !Empty(SRA->RA_CATEG)
 	cCateg := SRA->RA_CATEG
Else
	// Contrato de trabalho
	If SRA->RA_TPCONTR == "2"
		cCateg:= "04"
	EndIf

	// Diretor nao empregado
	If SRA->RA_VIEMRAI == "80"
		If nFgts == 0			// sem FGTS
			cCateg:= "11"
		Else
			cCateg:= "05"		// com FGTS
		EndIf
	EndIf

	//-- Quando For Autonomo
	If SRA->RA_CATFUNC == "A"
		cCateg := "13"
	Endif
	
	If Empty(cCateg)
		cCateg:="01"
	EndIf
Endif

Return cCateg
                        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunction  ³GPM610Ok  ºAutor  ³Microsiga           º Data ³  01/30/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GPM610Ok()
Return (MsgYesNo(OemToAnsi("Confirma configura‡„o dos parƒmetros?"),OemToAnsi("Aten‡„o")))

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FGETSEFIP³ Autor ³ J. Ricardo 			³ Data ³ 08/02/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Permite que o usuario decida onde sera criado o arquivo    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEM610													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function FGETSEFIP()
Local mvRet := Alltrim(ReadVar())
Local l1Vez := .T.

oWnd := GetWndDefault()

While .T.
           
	If l1Vez
	 	cFile := mv_par04
	 	l1Vez := .F.
	Else
		cFile := "" 		
	EndIf
		 	
	If Empty(cFile)
		cFile := cGetFile("FGTS | SEFIP.RE", OemToAnsi("Selecione Diretorio"))
	EndIf
		 				 
	If Empty(cFile)
		Return .F.
	EndIf

	If "."$cFile
		cFile := Substr(cFile,1,rat(".", cfile)-1)
	EndIf

	cFile += ".RE"
	If ! "SEFIP.RE" $ UPPER(cFile)
		Help(" ",1,"GPMSFGTSRE")
		Loop
	EndIf
	&mvRet := cFile
	Exit
EndDo

If oWnd != Nil
	GetdRefresh()
EndIf

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Ver21         ³ Autor ³ Cristina Ogura   ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica o tipo 21                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ver21                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Ver21(cTINSC,cINSC,cTTOMA,cTOMAD)
Local nSavReg	:= 0
  
dbSelectArea("SFP")
nSavReg	:= RecNo()

If dbSeek(cTINSC+cINSC+"21"+cTTOMA+cTOMAD)
	FWrite(nHandle,SFP->SFP_TEXTO)
EndIf

dbSelectArea("SFP")
dbGoto(nSavReg)

Return .T.


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Ver32         ³ Autor ³ Cristina Ogura   ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica o tipo 32                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ver32                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Ver32(cTINSC,cINSC,cTTOMA,cTOMAD,cPIS,cEmpFiMat)
Local nSavReg := 0

dbSelectArea("SFP")
nSavReg	:= RecNo()

If dbSeek(cTINSC+cINSC+"32"+cTTOMA+cTOMAD+cPIS)
	While !Eof() .And. cTINSC+cINSC+"32"+cTTOMA+cTOMAD+cPIS ==;
			SFP_TINSC+SFP_INSC+SFP_TIPO+SFP_TTOMA+SFP_TOMAD+SFP_PIS
			
		If cEmpFiMat == SFP->SFP_EMFIMA
			FWrite(nHandle,SFP->SFP_TEXTO)
		Endif	
		dbSkip()
	EndDo 	
EndIf

dbSelectArea("SFP")
dbGoto(nSavReg)

Return .T.


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ F13Sal        ³ Autor ³ Cristina Ogura   ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica a deducao e o salario maternidade                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F13Sal                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function F13Sal(nDeduc,nSalMat,aCodFol)

Local nVl13Sal	:=	0
Local nDiasSM	:=	0
Local nAvos		:=	0
Local nValDed13 := 0
Local aGetArea	:= GetArea()
Local lAchou	:= .F.
Local lAchouDed	:= .F.
Local bCondDed	:= { || (.T.) }

// Calcular o valor de deducao 13o licenca maternidade
If GetMv("MV_SALMGRP") = "N"   // Deducao de Sal.Matern. no 13o.Salario
	// Demitidos ou 13o. salario
	If cSitFunc == "D" .Or. nTipo == 2  // Tipo 1-Folha/Ferias	   2-13o.Salario
		nDiasSM	:=fDiasSm13(Left(Dtos(dAuxpar01),4))
		If nDiasSM > 0
			dbSelectArea("SRC")
			dbSetOrder(1)
			//-- Verifica a existencia da verba de deducao de sal.maternidade para 13o salario
			If aCodFol[670,1] <> "   "
				lAchouDed	:= dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[670,1])
				If lAchouDed
					//-- Condicao para testar a verba de deducao sal.matern.13o sal.caso exista
					bCondDed	:= { || (SRC->RC_PD == aCodFol[670,1]) }
				Endif
			Endif
			//-- Se nao encontrou a verba de deducao de sal.maternidade para 13o salario
			//-- pesquisa o movimento inteiro para apurar a deducao
			If !lAchouDed
				lAchou		:= dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
			Endif
			If lAchou .Or. lAchouDed
				While !Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT == SRC->RC_FILIAL+SRC->RC_MAT .And.;
					Eval(bCondDed)
					If !lAchouDed
						//-- Verif. 13.Salario Indenizado e 13. Sal. Av. Previo             
						//-- Media 13o. Salario Rescisao e Media 13o. Salario Sobre Aviso Indenizado Rescisao
						If SRC->RC_PD == aCodFol[114,1] .Or. SRC->RC_PD == aCodFol[115,1] .or.; 
						   SRC->RC_PD == aCodFol[251,1] .or. SRC->RC_PD == aCodFol[253,1]
							If SRC->RC_PD == aCodFol[114,1] .or. SRC->RC_PD == aCodFol[115,1]
								nAvos += Int(SRC->RC_HORAS)
							EndIf
							nVl13Sal += SRC->RC_Valor
						EndIf
					Else
						//-- Acumulo os valores ja calculados de deducao de sal maternidade para 13o salario
						nValDed13 += SRC->RC_VALOR
					Endif
					dbSkip()
				EndDo
			EndIf
			If nTipo == 2 //-- 13.Salario
				dbSelectArea('SRC')
				dbSetOrder(1)
				//-- Verifica se existem verbas de 13o salario indenizado no movimento mensal antes
				//-- de buscar a deducao do 13o salario, pois a deducao ja foi feita pelo movimento
				//-- mensal.
				If !dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[114,1])
					If !dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[115,1]) .And. ;
						!dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[251,1]) .And. ;
						!dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[253,1])
						dbSelectArea("SRI")
						dbSetOrder(1)
						//-- Verifica a existencia da verba de deducao de sal.maternidade para 13o salario
						If aCodFol[670,1] <> "   "
							lAchouDed	:= dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[670,1])
							If lAchouDed
								//-- Condicao para testar a verba de deducao sal.matern.13o sal.caso exista
								bCondDed	:= { || (SRI->RI_PD == aCodFol[670,1]) }
							Endif
						Endif
						//-- Se nao encontrou a verba de deducao de sal.maternidade para 13o salario
						//-- pesquisa o movimento inteiro para apurar a deducao
						If !lAchouDed
							lAchou		:= dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
						Endif
						If lAchou .Or. lAchouDed
							While !Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT == SRI->RI_FILIAL+SRI->RI_MAT .And.;
								Eval(bCondDed)
								If !lAchouDed
									If PosSrv(SRI->RI_PD,SRI->RI_FILIAL,"RV_TIPOCOD") == "1" .And.;
				                       PosSrv(SRI->RI_PD,SRI->RI_FILIAL,"RV_INSS") == "S"              
				                    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Considera Id 123 e 124 - Total medias em hrs e vlrs          ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										If SRI->RI_PD == aCodFol[024,1]  .or. SRI->RI_PD == aCodFol[123,1] .or. SRI->RI_PD == aCodFol[124,1]
											nAvos := Int(If(nAvos==0 ,SRI->RI_HORAS, nAvos))
										EndIf
										nVl13Sal += SRI->RI_Valor
									EndIf
								Else
									//-- Acumulo os valores ja calculados de deducao de sal maternidade para 13o salario
									nValDed13 += SRI->RI_VALOR
								Endif
								dbSkip()
							EndDo
						EndIf
					Endif
				Endif
			EndIf
		Endif
		//-- Acumulo a deducao do salario maternidade quando houver valor de deducao calculado ou
		//-- quando houver o valor bruto com a quantidade de avos de direito e dias de sal.maternidade.
		If (nVl13Sal > 0 .Or. nValDed13 > 0).And. nDiasSM > 0
			If nDiasSM > 0 .And. (nAvos > 0 .Or. nValDed13 > 0)
				nDeduc+= If(nValDed13==0,ROUND(((nVl13Sal/nAvos)/30)*nDiasSM,2),nValDed13)
			EndIf
		EndIf
	EndIf
Else          
	// Nao Gerar deducao Sal.Maternidade quando opcao mensal 
	// de 1/12 de 13o. Salario
	nDeduc := 0.00
EndIf

RestArea(aGetArea)

Return Nil
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FSubst        ³ Autor ³ Cristina Ogura   ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao que substitui os caracteres especiais por espacos   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FSubst()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FSubst(cTexto)

Local aAcentos:={}
Local aAcSubst:={}
Local cImpCar := Space(01)
Local cImpLin :=""
Local cAux 	  :=""
Local cAux1	  :=""   
Local nTamTxt := Len(cTexto)	
Local j
Local nPos
  
// Para alteracao/inclusao de caracteres, utilizar a fonte TERMINAL no IDE com o tamanho
// maximo possivel para visualizacao dos mesmos.
// Utilizar como referencia a tabela ASCII anexa a evidencia de teste (FNC 807/2009).

aAcentos :=	{;
			Chr(199),Chr(231),Chr(196),Chr(197),Chr(224),Chr(229),Chr(225),Chr(228),Chr(170),;
			Chr(201),Chr(234),Chr(233),Chr(237),Chr(244),Chr(246),Chr(242),Chr(243),Chr(186),;
			Chr(250),Chr(097),Chr(098),Chr(099),Chr(100),Chr(101),Chr(102),Chr(103),Chr(104),;
			Chr(105),Chr(106),Chr(107),Chr(108),Chr(109),Chr(110),Chr(111),Chr(112),Chr(113),;
			Chr(114),Chr(115),Chr(116),Chr(117),Chr(118),Chr(120),Chr(122),Chr(119),Chr(121),;
			Chr(065),Chr(066),Chr(067),Chr(068),Chr(069),Chr(070),Chr(071),Chr(072),Chr(073),;
			Chr(074),Chr(075),Chr(076),Chr(077),Chr(078),Chr(079),Chr(080),Chr(081),Chr(082),;
			Chr(083),Chr(084),Chr(085),Chr(086),Chr(088),Chr(090),Chr(087),Chr(089),Chr(048),;
			Chr(049),Chr(050),Chr(051),Chr(052),Chr(053),Chr(054),Chr(055),Chr(056),Chr(057),;
			Chr(038),Chr(195),Chr(212),Chr(211),Chr(205),Chr(193),Chr(192),Chr(218),Chr(220),;
			Chr(213),Chr(245),Chr(227),Chr(252);
			}
			
aAcSubst :=	{;
			"C","c","A","A","a","a","a","a","a",;
			"E","e","e","i","o","o","o","o","o",;
			"u","a","b","c","d","e","f","g","h",;
			"i","j","k","l","m","n","o","p","q",;
			"r","s","t","u","v","x","z","w","y",;
			"A","B","C","D","E","F","G","H","I",;
			"J","K","L","M","N","O","P","Q","R",;
			"S","T","U","V","X","Z","W","Y","0",;
			"1","2","3","4","5","6","7","8","9",;
			"E","A","O","O","I","A","A","U","U",;
			"O","o","a","u";
			}

For j:=1 TO Len(AllTrim(cTexto))
	cImpCar	:=SubStr(cTexto,j,1)
	//-- Nao pode sair com 2 espacos em branco.
	cAux	:=Space(01)  
    nPos 	:= 0
	nPos 	:= Ascan(aAcentos,cImpCar)
	If nPos > 0
		cAux := aAcSubst[nPos]
	Elseif (cAux1 == Space(1) .And. cAux == space(1)) .Or. Len(cAux1) == 0
		cAux :=	""
	EndIf		
    cAux1 	:= 	cAux
	cImpCar	:=	cAux
	cImpLin	:=	cImpLin+cImpCar

Next j

//--Volta o texto no tamanho original
cImpLin := Left(cImpLin+Space(nTamTxt),nTamTxt)

Return cImpLin       

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FTomador      ³ Autor ³ Cristina Ogura   ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao que verifica o tomador                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FTomador                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FTomador(cAuxFil,cCentro,nComTomador,nTpTomador)

Local aArea	:= 	GetArea()
Local lRet	:= 	.F.

dbSelectArea( "SI3" )
SI3->(dbSetOrder(1))

If cFilial == space(FWGETTAMFILIAL) .Or.  (cAuxFil == space(FWGETTAMFILIAL)  .And. cFilial # space(FWGETTAMFILIAL)) .or. empty(cAuxFil)
	cAuxFil := cFilial
Endif

cAuxFil := xFilial( "SI3", cAuxFil )
If SI3->( dbSeek(cAuxFil+cCentro) )
	If TYPE("SI3->I3_CEI") # "U" .and. TYPE("SI3->I3_TIPO") # "U"
		//-- Com Tomador
		If nComTomador == 1 
			//--  Com CNPJ         /  Ambos
			If (nTpTomador == 1 .or. nTpTomador == 3)
				lRet :=	(!empty(SI3->I3_CEI) .and. ( If(nTpTomador == 1,SI3->I3_TIPO $"1",SI3->I3_TIPO $"12")))
			//--     Com CEI	      /   Ambos
			ElseIf (nTpTomador == 2 .or. nTpTomador == 3)
				lRet :=	(!empty(SI3->I3_CEI) .and.( If(nTpTomador == 2,SI3->I3_TIPO $"2",SI3->I3_TIPO $"12") ))
			EndIf		
		//-- Sem Tomador   
		ElseIf nComTomador == 2
 			lRet :=	(empty(SI3->I3_CEI) .or. empty(SI3->I3_TIPO))
		//-- Ambos
		ElseIf nComTomador == 3
				//-- Com CNPJ 
			If nTpTomador == 1
   				lRet :=	( empty(SI3->I3_TIPO) ) .Or.	(SI3->I3_TIPO $"1" )
				//-- Com CEI 
			ElseIf nTpTomador == 2
				lRet :=	( empty(SI3->I3_TIPO) ) .Or.	(SI3->I3_TIPO $"2" )
			Else	        
				//--Ambos
				lRet := .T.
			Endif	
		EndIf
	EndIf

	If lRet	
 		If !Empty( cSi3Filter )
			lRet := &( cSi3Filter )
		EndIf
	EndIf			
EndIf

RestArea(aArea)

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao	 ³fCentro   ºAutor  ³Microsiga           º Data ³  03/17/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se tem tomador para gerar tipo 20                 º±±
±±º          ³ Obtem os dados do Tomador                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FCentro(cInsc,cTipo,aInfo,cCusto,cAuxFil)

Local lTomador	:= .F.

cAuxFil 		:= If(cAuxFil==Nil .or. cAuxFil == space(FWGETTAMFILIAL), SRA->RA_FILIAL, cAuxFil )

cTipo_Tom	:=""            //Variavel Utilizada Ponto de Entrada 
cInsc_Tom	:= Space(14)    //Variavel Utilizada Ponto de Entrada 
    
If nFilCc # 1  		//-Por Centro de Custo 
	//--Procura Centro de custo e verifica se tem Cei ou Nao
	lTomador := FTomador(cAuxFil,cCusto,nComTomador,nTpTomador)
	//--Verifica se Tem Cei no Centro de Custo se nao houver vai com a inscricao da empresa
	If lTomador	
		If TYPE("SI3->I3_TIPO") # "U" .And. TYPE("SI3->I3_CEI") # "U"
			If ! (Empty(SI3->I3_TIPO) .And. Empty(SI3->I3_CEI))
				cTipo 	:= SI3->I3_TIPO
				cInsc 	:= SI3->I3_CEI
	        Else
        		cTipo := If (aInfo[15]== 1,"2","1")    
				cInsc := aInfo[08]	
            Endif
		EndIf
	Else	//--inscricao da Empresa
		cTipo := If (aInfo[15]== 1,"2","1")    
		cInsc := aInfo[08]	
	Endif	                                                                     
//-- Quando for por Filial e a inscricao da Empresa for CEI
ElseIf aInfo[15] == 1
	cTipo := "2"
	cInsc := aInfo[08]
Else
	cTipo := "1"
	cInsc := aInfo[08]	
EndIf
     
    /*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
	³ Ponto de Entrada GPM610TOM, criado para buscar o 			   ³
	³ Tipo e Inscricao do Tomador. Este ponto de entrada ira       ³
	³ substituir a funcao fCentro, que busca estas informacoes na  ³
	³ tabela SI3. 												   ³
	³ 			 												   ³
	³ Sera enviado um array com 03 elementos via variavel ParamIXB.³
	³  Elemento 1: aInfo, contem os dados do SIGAMAT.EMP           ³
	³  Elemento 2: cCustoAux, centro custo funcionario             ³
	³  Elemento 3: cAuxFil, filial anterior                        ³
	³ 			 												   ³
	³ Retorno:						   	  						   ³
	³  cTipo_Tom = Tipo Inscricao do Tomador (1-CNPJ, 2-CEI)  	   ³
	³  cInsc_Tom  = Numero da Inscricao do Tomador				   ³
	³ 			 												   ³
	³ Obs.: Se estas variaveis vierem em branco, a funcao fCentro  ³
	³ 		sera executada.										   ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   */
   		
   		If ExistBlock("GPM610TOM")                                                
			Execblock("GPM610TOM" ,.F.,.F.,{aInfo,cCusto,cAuxFil})                  
			cTipo 	:= 	cTipo_Tom
			cInsc	:= 	cInsc_Tom 
		Endif


Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³FTesta    ³ Autor ³ Cristina Ogura   	    ³ Data ³ 02/03/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Posiciona no proximo funcionario		        			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³FRecol()    											 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function FTesta(cAuxAlias,lRat,cFil,cCC,cMat)

dbSelectArea(cAuxAlias)
If lRat
	While !Eof() .And. SRC->RC_FILIAL+SRC->RC_CC+SRC->RC_MAT ==;
							 cFil+cCC+cMat
		dbSkip()
	EndDo
Else
	dbSkip()
EndIf

Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FMontaSR8     ³ Autor ³ Mauro            ³ Data ³ 25/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica no SR8 existe o funcionario                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FMontaSr8(AnoMes,aAfast)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fMontaSr8(cCompet,aAfast,cSitFunc,dAuxPar01)
Local lRet		:= .F.
Local dDtUltAc 	:= CTOD("")
Local dDtUltAd 	:= CTOD("")
Local nDiasSR8 	:= 0                        
Local lAtu		:= .T.
Local aGetArea	:= GetArea()
Local cAMesProx := 	MesAno(dAuxPar01+((f_UltDia(dAuxPar01)-Day(dAuxPar01))+1))
Local cCodR		:= ""
Local aAfas_OP	:= {}
Local lContAfas := .F.           
Local cContAfa	:= ""
Local nPosAfas	:= 0                        
Local cTipo1	:= ""
Local lExistPE	:= ExistBlock("GP610AFAS")	//-- Ponto de Entrada para validar o tipo de afastamento.
Local lGp610Afas:= .T.
Local cFgtsMAnt := aCodFol[117,1] // Codigo de fgts Mes anterior
Local aTransf	:= {}
Local nX		:= 0

cSitFunc := If (cSitFunc == Nil , SRA->RA_SITFOLH,cSitFunc)

// Array aAfast
// 1 - Data da movimentacao
// 2 - Tipo de Ocorrencia para a SEFIP
// 3 - "A"=Afastamento "R"=Retorno
// 4 - Dias do afastamento
// 5 - Flag se F=colocar zeros nos dias do Tipo 32

dbSelectArea("SR8")
dbSetOrder(1)
If dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
	While !Eof() .And. SR8->R8_FILIAL+SR8->R8_MAT==SRA->RA_FILIAL+SRA->RA_MAT

		//-- Executa o ponto de entrada
		If lExistPE
			lGp610Afas:= ExecBlock('GP610AFAS',.F.,.F.)
		Endif
		IF !(SR8->R8_TIPO $ "F*8") .And. lGp610Afas // Ferias e Licenca Remunerada

			cTipo1 	:= SR8->R8_TIPO
			lAtu	:= .T.

			If (SR8->(FieldPos("R8_SEQ")) # 0).and. (SR8->(FieldPos("R8_CONTAFA")) # 0) .and. (SR8->R8_TIPO $"OP")
				Aadd(aAfas_OP,{SR8->R8_SEQ,SR8->R8_TIPO,SR8->R8_DATAINI,SR8->R8_DATAFIM,SR8->R8_CONTAFA })
			EndIf	

			If cCompet == MesAno(SR8->R8_DATAINI) .Or.;
				(MesAno(SR8->R8_DATAINI) <= cCompet .And.  Empty(SR8->R8_DATAFIM)) .Or.;
	         	(MesAno(SR8->R8_DATAINI) <= cCompet .And.  MesAno(SR8->R8_DATAFIM) >= cCompet)

				// Desconsiderar para Tipo O e P quando os dias forem <= 15
				
				If (SR8->(FieldPos("R8_SEQ")) == 0).and. (SR8->(FieldPos("R8_CONTAFA"))== 0)
					If SR8->R8_TIPO $ "P*O" .And.;
						!Empty(SR8->R8_DATAFIM) .And.;
						(Day(SR8->R8_DATAFIM) - Day(SR8->R8_DATAINI) <= 15)
						lAtu := .F.
					EndIf	
				EndIf 
				

				//--Grava Saida
				lContAfas := .F.
				If (SR8->(FieldPos("R8_SEQ")) # 0).and. (SR8->(FieldPos("R8_CONTAFA")) # 0) .and. (SR8->R8_TIPO $"OP")
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o afastamento e continuacao de outro afastamento.        ³
					//³Se for, verifica se o inicio deste e inferior a 60 dias do termino do ³
					//³anterior.                                                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty(SR8->R8_CONTAFA)
						cContAfa	:= SR8->R8_CONTAFA
				
						nPosAfas 	:= Ascan( aAfas_OP,{|x|x[1] == cContAfa})
						If nPosAfas > 0
							If aAfas_OP[nPosAfas,1] # SR8->R8_SEQ 
								If aAfas_OP[nPosAfas,2] == SR8->R8_TIPO 
									If ( SR8->R8_DATAINI- aAfas_OP[nPosAfas,4] ) <= 60
            	           				lContAfas := .T.
									EndIf	
								EndIf	
							EndIf
						Endif
					EndIf	
                Else
					If SR8->R8_TIPO = "P" .And. (SR8->R8_DATAINI - dDtUltAd)+1 <= 60
						lContAfas := .T.
					ElseIf SR8->R8_TIPO = "O" .And. (SR8->R8_DATAINI - dDtUltAc)+1 <= 60
						lContAfas := .T.
					EndIf
                EndIf
                
				If SR8->R8_TIPO == "O" .And. lContAfas 
					cTipo1 := "O2"
				ElseIf SR8->R8_TIPO == "O" .And.(!empty(SR8->R8_DATAFIM) .and.(SR8->R8_DATAFIM - SR8->R8_DATAINI)+1 <= 15 )
					cTipo1 := "O3"  
				Elseif SR8->R8_TIPO == "O"
				   	cTipo1 := "O1"
				Endif
				
				If SR8->R8_TIPO == "P" .And. lContAfas 
					cTipo1 := "P2"
				ElseIf SR8->R8_TIPO == "P" .And.(!empty(SR8->R8_DATAFIM) .and.(SR8->R8_DATAFIM - SR8->R8_DATAINI)+1 <= 15 )
					cTipo1 := "P3"  
				Elseif SR8->R8_TIPO == "P"
				   	cTipo1 := "P1"
				Endif
				// Maternidade
				If SR8->R8_TIPO == "Q"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Execblock para ajustar o codigo de afastamento   ³
					//³para auxilio maternidade.                        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cTipo1 := "Q1"
					If ExistBlock("GPM610Q")
						cTipo1 := Execblock("GPM610Q",.F.,.F.)
						cTipo1 := If( empty(cTipo1), "Q1",cTipo1 )
					Endif
				Endif            
				// Maternidade por adocao
   				If SR8->R8_TIPO == "B"
				   	cTipo1 := "Q4"
   				ElseIf SR8->R8_TIPO == "6"
				   	cTipo1 := "Q5"
   				ElseIf SR8->R8_TIPO == "7"
				   	cTipo1 := "Q6"
				Endif
				
				// Aposentadoria
				If SR8->R8_TIPO == "U"
					If SRA->RA_RESCRAI == "71"
						cTipo1 := "Y"		// Com vinculo empregaticio
					Else
						cTipo1 := "U1"
					EndIf
				EndIf
				
				If SR8->R8_TIPO == "V"
					cTipo1 := "Y"		// Com vinculo empregaticio
				EndIf                 
				If SR8->R8_TIPO == "1"
					cTipo1 := "U3"		// Aposentadoria por Invalidez
				EndIf                 
				// Calcula os dias quando existir retorno de afastamento
				nDiasSR8 :=0
				If MesAno(SR8->R8_DATAFIM) == cCompet
					If Month(SR8->R8_DATAINI) == Month(SR8->R8_DATAFIM)
						// Desconsidera os 15 dias
						If SR8->R8_TIPO $ "P*O"
							nDiasSR8 := SR8->R8_DATAFIM - (SR8->R8_DATAINI + 14)
						Else
							nDiasSR8 := SR8->R8_DATAFIM - SR8->R8_DATAINI
						EndIf
					Else
						nDiasSR8 := Day(SR8->R8_DATAFIM)
					EndIf
					If nDiasSR8 < 0
						nDiasSR8 := 0
					EndIf
				EndIf

                // Se for Continuacao do Afastamento Maternidade deve utilizar Codigo
                // Y (Outro Tipo de Afastamento) Por considerar Empresa Cidadah
				If (SR8->R8_TIPO == "Q") .and. (SR8->(FieldPos("R8_SEQ")) # 0) .and. ;
				   (SR8->(FieldPos("R8_CONTAFA")) # 0) .and. (SR8->R8_CONTINU=="1") .and. !Empty(SR8->R8_CONTAFA)
					cTipo1 := "Y"
				EndIF

				Aadd(aAfast,{SR8->R8_DATAINI,cTipo1,"A",nDiasSR8,lAtu,.F.})

				// Gerar registro qdo for prorrogacao da maternidade.
				// Alterado para tratar Data Final do Afastamento ACIMA da data de competencia
				If SR8->R8_TIPO == "Q" .And. MesAno(SR8->R8_DATAFIM) >= cCompet
					If SR8->R8_DATAFIM - SR8->R8_DATAINI > 120
						Aadd(aAfast,{SR8->R8_DATAINI+121,"Q2","A",0,lAtu,.F.})
					EndIf
				EndIf

				If MesAno(SR8->R8_DATAFIM) == cCompet
					If SR8->R8_TIPO == "R"
						cTipo1 := "Z4"
					ElseIf SR8->R8_TIPO == "O"
						cTipo1 	:= If (cTipo1 = "O2","Z3",If(cTipo1=="O3","Z6","Z2"))
						dDtultAc := SR8->R8_DATAFIM
					ElseIf SR8->R8_TIPO$ "1*P*Z*U*V*W*X*Y"
						cTipo1 := "Z5"
						If SR8->R8_TIPO == "P"
							dDtUltAd := SR8->R8_DATAFIM
						EndIf
					ElseIf SR8->R8_TIPO $"Q*B*6*7"
                		// Se for Continuacao do Afastamento Maternidade deve utilizar
                		// Encerramanto do Codigo Y (Outro Tipo de Afastamento)
						IF (SR8->R8_TIPO == "Q") .and. (SR8->(FieldPos("R8_SEQ")) # 0) .and. ;
						   (SR8->(FieldPos("R8_CONTAFA")) # 0) .and. (SR8->R8_CONTINU=="1") .and. ;
						   ! Empty(SR8->R8_CONTAFA)
							cTipo1 := "Z5"
						Else
							cTipo1 := "Z1"
						EndIf
					Endif
					Aadd(aAfast,{SR8->R8_DATAFIM,cTipo1,"R",0,lAtu,.F.})
				Endif
			Elseif SR8->R8_TIPO == "O"
				dDtultAc := SR8->R8_DATAFIM
			ElseIf SR8->R8_TIPO == "P"
				dDtUltAd := SR8->R8_DATAFIM
			Endif
		Endif

		dbSelectArea("SR8")
		dbSkip()
	EndDo
Endif

If cSitFunc == 'D' 
	cTipo1 := fCodMov( SRA->RA_AFASFGT,SRA->RA_DEMISSA,cCompet )

	Aadd(aAfast,{SRA->RA_DEMISSA,cTipo1,"D",0,lAtu,.F.})
Else	

	If SRG->(dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+cAMesProx))
		If SRR->(dbseek(SRA->RA_FILIAL+SRA->RA_MAT+"R"+DTOS(SRG->RG_DTGERAR)+cFgtsMAnt))
	
			fPHist82(SRA->RA_FILIAL ,"32",SRG->RG_TIPORES+"  ",48,1,@cCodR)				
			
			cTipo1 := fCodMov( cCodR,SRG->RG_DATADEM,cCompet )
					
			Aadd(aAfast,{SRG->RG_DATADEM,cTipo1,"D",0,lAtu,.T.})
			cSitFunc :=	"D"		
		Endif
	Endif	
Endif

fTransf( aTransf , cCompet)

If len(aTRansf) > 0
	For nX := 1 to len(aTransf)
		If (aTransf[nx,04]+aTransf[nx,10] == cEmpAnt+SRA->RA_FILIAL) .and. (aTransf[nx,01]+aTransf[nx,08]#aTransf[nx,04]+aTransf[nx,10])
			Aadd(aAfast,{aTransf[nx,7],"N3","A",0,lAtu,.T.})	
		EndIf	
	Next	
EndIf
RestArea(aGetArea)

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³fCodMov   ºAutor  ³Andreia dos Santos  º Data ³  26096/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o codigo de afastamento.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCodMov( cCodMov,dDemissa,cCompet )

Local cTipo1 := If( !empty(SRA->RA_AFASFGT),SRA->RA_AFASFGT,cCodMov)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³A versao 3 esta sendo atribuida nessa variavel para uso externo a SEFIP. ³
//³Se for adicionado novo item ao parametro 41 desta rotina, esta variavel  ³
//³deve ser atualizada.														³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nVer1	 := If(Type("nVersao") = "U",3,nVersao) 

// Aposentadoria           
IF Mesano(dDemissa) <= cCompet
	If cCodMov == "U" 
		If SRA->RA_RESCRAI == "71"
			cTipo1 := "Y"		// Com vinculo empregaticio
		Else
			cTipo1 := "U1"
		EndIf
	EndIf             
	//aposentadoria com continuidade de vinculo empregaticio
	If cCodMov =="V"
   		cTipo1	:= "Y"
    EndIf	
	//Aposentadoria por invalidez
	If cCodMov =="1"
		cTipo1	:= "U3"
	EndIf	
EndIf	

If nVer1 # 1
	If cCodMov == "I"
		cTipo1 := "I1"
	Elseif cCodMov == "2"
		cTipo1 := "I2"
	Elseif cCodMov == "3"
		cTipo1 := "I3"
	Elseif cCodMov == "4"
		cTipo1 := "I4"
	ElseIf cCodMov =="N"
		cTipo1	:= "N2"
	ElseIf cCodMov =="5"
		cTipo1	:= "N1"
	EndIf		

	If nVer1 == 3
		If cCodMov =="S"
			cTipo1	:= "S2"
		ElseIf cCodMov =="9"
			cTipo1	:= "S3"
		EndIf
	EndIf		   	
EndIf	   		

Return( cTipo1 ) 
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FVerSRI       ³ Autor ³ Cristina Ogura   ³ Data ³ 25/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica no SRI os valores do funcionario                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FVerSRI(aCodFol,nB13Inss,nB13Fgts,nSalMat,n13Inss)         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FVerSRI(aCodFol,nB13Inss,nB13Fgts,nSalMat,n13Inss,nSc13Sal,lRat,cCusto,lGRRF)		

Local cCompInss :=StrZero(Year(dAuxPar01),4)+"12"
Local cSeek		:= ""
Local cChave	:= ""
Local aGetArea	:= GetArea()

dbSelectArea("SRI")

If lRat
	dbSetOrder(2)         
	cSeek 	:= SRA->RA_FILIAL+cCusto+SRA->RA_MAT
	cChave 	:= "SRI->RI_FILIAL+SRI->RI_CC+SRI->RI_MAT"         
Else            
	dbSetOrder(1)
	cSeek 	:= SRA->RA_FILIAL+SRA->RA_MAT
	cChave 	:= "SRI->RI_FILIAL+SRI->RI_MAT"         
Endif
If dbSeek( cSeek )
	While SRI->(!Eof()) .And. cSeek == &cChave
							 
		//--Somar Base de Inss e Inss quando for competencia 12 ou opcao de 13o.Salario		
		If nTipo = 2 .Or. ( month(dAuxPar01) ==12 .and. Year(SRI->RI_DATA) == Year(dAuxPar01)) .or. cRecol $ "130"

			If SRI->RI_PD == aCodFol[19,1] .Or. SRI->RI_PD == aCodFol[20,1]
				 nB13Inss += Round(SRI->RI_VALOR,2)
				 nSc13sal += Round(SRI->RI_VALOR,2)
			EndIf

			If SRI->RI_PD == aCodFol[70,1]    // Tipo 1-Folha/Ferias	   2-13o.Salario
				n13Inss += Round(SRI->RI_VALOR,2)
			EndIf
			
		Endif			

		If nTipo==1 .And.( MesAno(SRI->RI_DATA) = MesAno(dAuxPar01) .or. cRecol $ "130")  // Tipo 1-Folha/Ferias	   2-13o.Salario
		                                           
			//--Somar Base de Fgts 13o. se for pago na Data de referencia ou
			//--Se funcionario for demitido e nao recolher GRRF
			If ((!lGRRF .and. cSitFunc == 'D') .or. cSitFunc # 'D') .AND. SRI->RI_PD == aCodFol[108,1] 
				nB13Fgts += Round(SRI->RI_VALOR,2)
			Endif	
		EndIf
		dbSelectArea("SRI")
		dbSkip()
	EndDo

EndIf

RestArea( aGetArea )

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Gp610Cria ³ Autor ³ Cristina Ogura   	  ³ Data ³ 02/03/98   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³// Verifica o arquivo e cria se necessario				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³FRecol()    												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function Gp610Cria(cArqNome)

Local aStru :={}
Local cInd
Local lCria := .F.
Local nTamMat	:= TamSX3("RA_MAT")[1]
Local nTamGrupo	:= Len(FwCodEmp("SM0"))

cInd	:= "SFP_TINSC + SFP_INSC + SFP_TIPO + SFP_TTOMA + SFP_TOMAD + SFP_PIS + SFP_DT + SFP_CAT"

If MSFile(cArqNome,,__LocalDriver)     
	If !MsOpenDbf( .T. , __LocalDriver , cArqNome , "SFP" , .F. , .F. )
		Return(.F.)
	Endif
	IndRegua("SFP",FileNoExt(cArqNome)+"1",cInd,,,"Selecionando Registros...")		//
	//--VERIFICA SE EXISTE O CAMPO EMPRESA FILIAL MATRICULA SE NAO EXISTI VAI CRIAR O ARQUIVO NOVAMENTE	
	If Type("SFP_EMFIMA") == "U"
		dbSelectArea("SFP")
		dbCloseArea()
		lCria := .T.
	Endif
Else
	lCria := .T.	
Endif		
                  
If lCria     
	aStru 	:= {{"SFP_TIPO" , "C" , 002 , 0 },;
				 {"SFP_TINSC", "C" , 001 , 0 },;
				 {"SFP_INSC",  "C" , 014 , 0 },;
				 {"SFP_TTOMA", "C" , 001 , 0 },;
				 {"SFP_TOMAD", "C" , 014 , 0 },;
				 {"SFP_PIS",   "C" , 011 , 0 },;
				 {"SFP_DT",    "C" , 008 , 0 },;
				 {"SFP_CAT",   "C" , 002 , 0 },;
				 {"SFP_TEXTO", "C" , 362 , 0 },;
				 {"SFP_EMFIMA", "C", nTamGrupo+FwGetTamFilial+nTamMat  , 0 } }

	dbCreate(cArqNome,aStru,__LocalDriver)
	dbUseArea( .T.,__LocalDriver, cArqNome, "SFP", If(.F. .OR. .T., !.T., NIL), .F. )
	IndRegua("SFP",FileNoExt(cArqNome)+"1",cInd,,,"Selecionando Registros...")		//
EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPEM610   ºAutor  ³Microsiga           º Data ³  03/16/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica a filial responsavel se existe                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FVerSM0()

Local cAlias	:= 	Alias()
Local nOrdem	:=	IndexOrd()
Local nReg		:=	RecNo()
Local nRegSM0	:= 	0
Local lRet	 	:= .F.

dbSelectArea("SM0")
nRegSM0 := RecNo()

If dbSeek(cFilResp)
	lRet := .T.
	cCGC := SM0->M0_CGC
EndIf	
           
dbGoto(nRegSM0)

dbSelectArea(cAlias)
dbSetOrder(nOrdem)
dbGoto(nReg)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPEM610   ºAutor  ³Microsiga           º Data ³  03/18/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³// Gravo o tipo no arquivo conforme a empresa               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FVerTipo(cTINSC,cINSC,cTTOMA,cTOMAD)

Local nRegAnterior 	:= 	RecNo()
Local aTipo			:= 	{"12","13","14"}
Local cTipoTom		:=	""
Local cTomador		:=	""
Local lTomador 		:= .T.
Local lGerou   		:= .F.
Local lGera20 		:= .F.
Local nX
Local nOldReg		:= Recno()

dbSelectArea("SFP")

// Verifica os tipos 12,13 e 14 da SEFIP
For nx:=1 To Len(aTipo)
	If dbSeek(cTINSC+cINSC+aTipo[nx])
    	While !Eof() .And. cTINSC+cINSC+aTipo[nx]==SFP->SFP_TINSC+SFP->SFP_INSC+SFP->SFP_TIPO
			FWrite(nHandle,SFP->SFP_TEXTO)
       		dbSkip()
   	    EndDo
	EndIf
Next nx	

// Verifica os tipos 20, 21, 30 e 32 da SEFIP    
// Tipo 20
If dbSeek(cTINSC+cINSC+"20")
	While !Eof() .And.  cTINSC+cINSC+"20" ==;
					 	SFP->SFP_TINSC+SFP->SFP_INSC+SFP->SFP_TIPO

		cTipoTom:= SFP->SFP_TTOMA
		cTomador:= SFP->SFP_TOMAD       
		lTomador:= .T.
		lGerou  := .T.				
		While !Eof() .And. cTINSC+cINSC+"20"+cTipoTom+cTomador ==;
			 SFP->SFP_TINSC+SFP->SFP_INSC+SFP->SFP_TIPO+SFP->SFP_TTOMA+SFP->SFP_TOMAD
                       
			nOldReg	:= SFP->( Recno() )
			//So grava registro 20 se encontrar um reg. 21 ou 30 correspondente.
			lGera20 := (dbSeek(cTINSC+cINSC+"30"+cTipoTom+cTomador) .OR. ; 
						dbSeek(cTINSC+cINSC+"21"+cTipoTom+cTomador) )
				
			dbGoto(nOldReg)					
			
			If lGera20	
				FWrite(nHandle,SFP->SFP_TEXTO)
			
				If lTomador					
					Ver21(cTINSC,cINSC,cTipoTom,cTomador)                                
					lTomador := .F.
				EndIf
			
				Ver30(cTINSC,cINSC,cTipoTom,cTomador)
		
			EndIf	
			dbSelectArea("SFP")
			dbSkip()
		EndDo
	EndDo	
EndIf

// Tipo 30
If !lGerou 
 	Ver30(cTINSC,cINSC,Space(01),Space(14))
EndIf
	
dbGoto(nRegAnterior)
	
Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Ver30         ³ Autor ³ Cristina Ogura   ³ Data ³ 17/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o tipo 30 e 32                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ver30()                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEM610                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Ver30(cTINSC,cINSC,cTipoTom,cTomador)

Local nAuxReg
Local aGetArea	:= GetArea()

dbSelectArea("SFP")
nAuxReg:= RecNo()

If dbSeek(cTINSC+cINSC+"30"+cTipoTom+cTomador)

	While !Eof() .And. cTINSC+cINSC+"30"+cTipoTom+cTomador ==;
		 SFP->SFP_TINSC+SFP->SFP_INSC+SFP->SFP_TIPO+SFP->SFP_TTOMA+SFP->SFP_TOMAD

		FWrite(nHandle,SFP->SFP_TEXTO)
		
		Ver32(SFP->SFP_TINSC,SFP->SFP_INSC,SFP->SFP_TTOMA,SFP->SFP_TOMAD,SFP->SFP_PIS,SFP->SFP_EMFIMA)

		dbSkip()
	EndDo
ElseIf Eof() 
	//--Quando nao encontrar registro 30 verifica se existe 32 e gera.
	Ver32(SFP->SFP_TINSC,SFP->SFP_INSC,SFP->SFP_TTOMA,SFP->SFP_TOMAD,SFP->SFP_PIS,SFP->SFP_EMFIMA)
EndIf

dbSelectArea("SFP")
dbGoto(nAuxReg)

RestArea(aGetArea)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCValDev  ºAutor  ³Microsiga           º Data ³  03/18/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo do Inss da Empresa para achar valor devipo a       º±±
±±º          ³ a Previdencia                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ nBaseCal=Base de Calculo do Inss Empresa e Terceiros       º±±
±±º          ³ aInssEmp=Array contendo os Percentuais Inss Empresa        º±±
±±º          ³ nTotAci =Valor Calc. Ac.de Trabalho dos Funcionarios       º±±
±±º          ³ nInssRet=Valor de Inss Descontado dos Funcionarios         º±±
±±º          ³ nValDPrev=retorna o valor Inss Devido a Previdencia        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fCValDev(nBaseCal,aInssEmp,nTotAci,nInssRet,nDeducao,nValDPrev,nPercFpas)

nValDPrev 	:= 0.00
nPercFPas	:= If (nPercFpas == Nil, 0, nPercFPas)

nTotAci := If (nTotAci = NIL,0.00,nTotAci)
If nBaseCal > 0 
	nValDPrev += ROUND(nBaseCal * aInssemp[1,1],2) // Inss Emp.
	nValDPrev += ROUND(nBaseCal * If (nPercFPAS > 0, nPercFPAS , aInssemp[2,1]),2)   // Terceiros
	nValDPrev += nTotAci   // Somar Valor de Ac.Trabalho do Funcionario
EndIf
nValDPrev += nInssRet  // Retencao do Funcionario
nValDPrev -= nDeducao

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPEM610   ºAutor  ³Microsiga           º Data ³  08/05/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se deve gerar reg. de Tomador Tipo 20             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGera20(cCusto,cCustoAux,aInfo,cInsc,cTipo,n20SalFamAnt,nT13Inss,nTB13Inss,nTotAci,cAuxFil,cFilAtual,aCodFol,lRat,n20SalFam)

Local cInfo
Local nX

Private nValFat := 0
Private nValRet := 0

If aInfo[15] == 1			// CEI
	cInfo := "2"
Else
	cInfo := "1"			// CGC/CNPJ
EndIf
        
//-- Verificando o Tamanho do FPAS 
If empty( cFPAS_Tom )
	If Substr(aInfo[17],1,1) == "0"
		cFPAS	:= Substr(aInfo[17],2,3)
	Else
		cFPAS	:= Substr(aInfo[17],1,3)
	EndIf
EndIf
// -- Nao deve gerar tomador para os codigos de recolhimento abaixo
If cRecol $ "115#145#307#327#345#640#650#660"
	Return
EndIf

// Gerar por C.C   Registro 20 Tomador de Servico
If nFilCc # 1 .Or. (nFilCc == 1 .And. cInfo ="2" .And. cRecol # '115')

	//--Verifica Quebra de C.Custo
	If nComTomador # 2 .And. ( ( cAuxFil # cFilAtual .Or. cCusto # cCustoAux) .or. ExistBlock("GPM610TP20"))
       
		//--Carga do cTipo e cInsc para o Reg. 20
		cTipo		:=""
		cInsc		:= Space(14)

		FCentro(@cInsc,@cTipo,aInfo,cCustoAux,cAuxFil)
		//Quando for competencia 12 calcular o Valor Devido a Previdencia do 13o.
		nValDPrev 	:= 0

		If Month(dAuxPar01) = 12                                         
			fCValDev(nTB13Inss,aInssEmp,nTotAci,nT13Inss,0.00,@nValDPrev,SI3->I3_PERFPAS)
		Endif	

		//Carrega valores da GPS
		fGPSVal(cAuxFil,cAnoMesGps,@aGPSVal,cTpC)

		nValFat := nValRet := nValComps := 0
        
		For nx := 1 to len(aGpsVal)                   
			If alltrim(aGpsVal[nX,1]) == alltrim(cCustoAux)
				If aGpsVal[nX,02] == aCodFol[314,1] 
			 		nValFat	  += aGpsVal[nX,03] // Valor da Fatura
			 		nValRet	  += aGpsVal[nX,05] // Valor Retido
		 		EndIF	
				If aGpsVal[nX,02] == aCodFol[584,1]       
					nValComps += aGpsVal[nX,05] // Valor da Compensacao da GPS
					cPerIniCmp:= aGpsVal[nX,08]	// Ano/mes do periodo inicial de Compensacao
					cPerFimCmp:= aGpsVal[nX,09]	// Ano/mes do periodo final de Compensacao
            	EndIf
            EndIf
		Next nX

		//--Gera registro Tipo 20 todo C.Custo para Somar Valor Retido,Valor Faturado e sal.Familia
		DBF_TIPO20(aInfo,cInfo,cTipo,cInsc,.T.,n20SalFamAnt,nT13Inss,nValDPrev,cCustoAux,cAuxFil)

		If (nValComps#0) .and. cRecol$ '130/135/150/155/211/608' 
			DBF_TIPO21(aInfo,cInfo,cTipo,cInsc)
		EndIf	

		
		cCustoAux 	:= cCusto  
		cAuxFil		:= cFilAtual
		n20SalFamAnt:= n20SalFam
		nT13Inss	:= 0
		nTB13Inss	:= 0			
		nTotAci		:= 0
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o CNPJ do tomador e igual ao CNPJ da empresa        ³
		//³Se for, significa que tem movimentacao de pessoal adminstrativo.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lPessoalAdm := If( cInscResp == cInsc, .T.,lPessoalAdm )
	Else
		n20SalFamAnt+= n20SalFam
	EndIf
	n20SalFam 	:= 0                                                       
	
	//--Carga do cTipo e cInsc para o Funcionario
	cTipo		:=""
	cInsc		:= Space(14)      

	FCentro(@cInsc,@cTipo,aInfo,cCusto,SRA->RA_FILIAL)

EndIf

Return   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³fMoviment ºAutor  ³Andreia dos Santos  º Data ³  21/06/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta array com todos os codigos de movimentacao para      º±±
±±º          ³ descricao no relatorio de Log de ocorrencias               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fMoviment(aMovimento)

aMovimento := {}

aadd(aMovimento,{"H" ,"Rescisao","com justa causa, por iniciativa do empregador"})
aadd(aMovimento,{"I1","Rescisao","sem justa causa, por iniciativa do empregador"})
aadd(aMovimento,{"I2","Rescisao","por culpa reciproca ou forca maior"})
aadd(aMovimento,{"I3","Rescisao","por finalizacao do contrato a termo"})
aadd(aMovimento,{"I4","Rescisao","sem justa causa do contrato de trabalho do empreg. domestico, iniciativa do empregador"})
aadd(aMovimento,{"J" ,"Rescisao","por iniciativa do empregado"})
aadd(aMovimento,{"K" ,"Rescisao","a pedido do empregado ou empregador, com justa causa, empreg. nao optante com menos de um ano de servico"})
aadd(aMovimento,{"L" ,"outros motivos de rescisao do contrato de trabaho"})
aadd(aMovimento,{"M" ,"Mudanca de Regime Estatutario",""})      	//
aadd(aMovimento,{"N1","Transferencia","para outro estabelecimento da mesma empresa"})
aadd(aMovimento,{"N2","Transferencia","para outra empresa sem rescisao de contrato"})
aadd(aMovimento,{"N3","Transferencia","de outra empresa sem rescisao de contrato"})
aadd(aMovimento,{"O1","Afastamento","temporario por motivo de acidente do trabalho, periodo superior a 15 dias"})
aadd(aMovimento,{"O2","Novo Afastamento","temporario em decorrencia do mesmo acidente do trabalho"})
aadd(aMovimento,{"O3","Afastamento","temporario por motivo de acidente do trabalho, por periodo igual ou inferior a 15 dias"})
aadd(aMovimento,{"I3","Rescisao","por finalizacao do contrato a termo"})
aadd(aMovimento,{"P1","Afastamento","temporario por motivo de doenca, superior a 15 dias"})
aadd(aMovimento,{"P2","Novo Afastamento","temporario, mesma doenca, 60 dias contados da cessacao afastamento anterior"})
aadd(aMovimento,{"P3","Afastamento","temporario por motivo de doenca, ate a 15 dias"})
aadd(aMovimento,{"Q1","Licenca Maternidade",""}) 			//
aadd(aMovimento,{"Q2","Prorrogacao Licenca Maternidade",""}) 	   		//
aadd(aMovimento,{"Q3","Aborto"," "}) 	//
aadd(aMovimento,{"Q4","Licenca Maternidade","Adocao de crianca de ate 1 ano de idade."})
aadd(aMovimento,{"Q5","Licenca Maternidade","Adocao de crianca de 1 a 4 anos de idade."})
aadd(aMovimento,{"Q6","Licenca Maternidade","Adocao de crianca de 4 a 8 anos de idade."})
aadd(aMovimento,{"R" ,"Servico Militar",""}) 			//
aadd(aMovimento,{"S2","Falecimento",""})		 	//
aadd(aMovimento,{"S3","Falecimento motivado por acidente do trabalho",""})		 	//
aadd(aMovimento,{"U1","Aposentadoria",,"por tempo de servico/idade sem continuidade de vinculo empregaticio"})
aadd(aMovimento,{"U2","Aposentadoria","por tempo de servico/idade com continuidade de vinculo empregaticio"})
aadd(aMovimento,{"U3","Aposentadoria","por invalidez"})
aadd(aMovimento,{"V3","Comissão",""}) 	   		//
aadd(aMovimento,{"W" ,"Mandato Sindical",""}) 	   		//
aadd(aMovimento,{"X" ,"Licenca sem vencimento",""}) 	  		//
aadd(aMovimento,{"Y" ,"Afastamento","outros motivos de afastamento temporario"})
aadd(aMovimento,{"Z1","Retorno","Licenca Maternidade" })
aadd(aMovimento,{"Z2","Retorno","Acidente Trabalho"})
aadd(aMovimento,{"Z3","Retorno","novo afastamento temporario em decorrencia do mesmo acidente trabalho"})
aadd(aMovimento,{"Z4","Retorno","servico militar"})
aadd(aMovimento,{"Z5","Retorno","outros retornos de afastamento temporario e/ou licenca"})
aadd(aMovimento,{"Z6","Retorno","retornos de afastamento temporario"})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPEM610   ºAutor  ³Microsiga           º Data ³  02/07/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VerCodSaq(cFilAux, cMatAux,dDemissao,lGRRF)
          
Local cCodSaqIOB:= " "              
Local cCodSaq 	:= " "
Local cGRRF 	:= " "
Local lRet 		:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Codigos de Saque Validos Segundo o Calendario de    Obrigacoes³
//³e Tabelas Praticas do IOB de Out/99 Paginas 62 a 68.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCodSaqIOB := "01_02_03_04_05_06_07_10_23_26_27_80_81_86_87_88_91_92_93_94_95_96" 
              
SRG->(dbSeek(cFilAux+cMatAux+MesAno(dDemissao)))

fPHist82(SRA->RA_FILIAL ,"32",SRG->RG_TIPORES+"  ",49,2,@cCodSaq)

fPHist82(SRA->RA_FILIAL ,"32",SRG->RG_TIPORES+"  ",36,1,@cGRRF)

// Retorno Codigo Saque
IF (StrZero(Val(cCodSaq),2) $ cCodSaqIOB)  
	lRet	:= .T.
EndIF

// Retorno calculo GRRF
IF cGRRF == 'S'
	lGRRF	:= .T.
Else
	lGRRF	:= .F.
EndIf      
      
      
Return( lRet )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³fSimples  ºAutor  ³Microsiga           º Data ³  04/23/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                 	      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fSimples()

Local cTitulo	:=	""
Local MvParDef	:=	""
Local l1Elem 	:= .T. 
Local MvPar		:= ""
Local oWnd
Local cTipoAu

Private aResul	:={}

cTipoAu :=	MV_PAR27

oWnd := GetWndDefault()
MvPar	:=	&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
mvRet	:=	Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno

cTitulo := "Imposto Simples" //
aResul  := {"Nao Optante","Optante","Optante-Faturam. >1.200","Nao Optante-PR","Nao Optante-Emp.Liminar","Optante-Emp.Liminar"} //###############
 
MvParDef	:=	"123456"

f_Opcoes(@MvPar,cTitulo,aResul,MvParDef,12,49,l1Elem,,1)		// Chama funcao f_Opcoes
&MvRet := If("*" $ mvpar,space(1),mvpar) 					   	// Devolve Resultado


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncai    ³f610ApIndiceºAutor  ³Microsiga         º Data ³  06/23/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apaga o indice do arquivo SFP quando sair da rotina        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function f610ApIndice(cArqNome)
Local nVezes := 0                          
Local cArquivo := FileNoExt(cArqNome)+"1"+OrdBagExt()

dbSelectArea("SFP")
dbCloseArea()
While File(cArquivo)
	nVezes ++
   	If nVezes >= 10
		Aviso( "Nao foi possivel excluir o arquivo ","Erro ao Excluir arquivo"+'"'+cArquivo +'"', { "Ok" },," " ) //###
		Return
	EndIf
	FErase(FileNoExt(cArqNome)+"1"+OrdBagExt())           

EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GPEM610   ºAutor  ³Microsiga           º Data ³  07/18/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/            
Static Function f610TrocaLetra(cCampo)
Local nI 		:= 0
Local cRetorno 	:= ""

For nI := 1 to Len( cCampo )
  If !(substr( cCampo,nI,1) $ "0#1#2#3#4#5#6#7#8#9# ") 
	cRetorno += "0"
  Else
	cRetorno += substr( cCampo,nI,1)
  EndIf
Next nI

Return( cRetorno )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao   ³OpentabelasºAutor  ³Microsiga           º Data ³  07/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³Abre as tabelas passadas no parametro                        º±±
±±º         ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OpenTabelas(aTabelas)
Local nX		:= 0                          
Local cArqMov	:= ""       
Local cArqNome	:= ""
Local cAlias	:= ""
Local cPath		:= ""
Local lRet		:= .T.
Local aOrdBag	:= {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Serao criados 3 parametros com os nomes das tabelas a serem abertas.³
//³Sera utilizado o numero do modulo para saber se esta em uso o PLS.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nX := 1 to 3
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Retorna o Path do Arquivo      ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	dbSelectArea("SX6")
	aOrdBag	:= {}
	If nX == 1
		cAlias	:= "SRA"
		cArqMov	:= GetNewPar("MV_SRAPLS","SRAX")
	ElseIf nX == 2
		cAlias	:= "SRC"
		cArqMov	:= GetNewPar("MV_SRCPLS","SRCX")     
	ElseIf nX == 3
		cAlias	:= "SI3"
		cArqMov	:= GetNewPar("MV_SI3PLS","SI3X")     
	EndIf	
	
	IF Empty( cPath := AllTrim( GetMv( "MV_DGPESRC" ) ) )
		SX2->( MsSeek( cAlias ) )
		cPath := AllTrim( SX2->X2_PATH )
	Else
		IF SubStr( cPath , -1 ) != "\"
			cPath += "\"
		EndIF
	EndIF
	#IFNDEF TOP
		cArqMov := RetArq( __cRdd , cPath + cArqMov , .T. )
	#ELSE
		cArqMov := RetArq( __cRdd , cPath + cArqMov , .F. )
	#ENDIF

	IF MsFile( cArqMov )
		lRet := fAbreArqMov( cAlias,cAlias , @aOrdBag , cArqMov , .F., .T.  ) 
		If !lRet
			Exit
		Else    
			Aadd(aTabelas,{cAlias,aOrdBag,cArqNome})
		EndIf
    Else 
    	lRet := .F. 
    	exit
    EndIf
Next nX

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPEM610   ºAutor  ³Microsiga           º Data ³  12/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fAbreArqMov( cAlias, cAliasMov , aOrdBag , cArqMov , lDisplay )

Local aDbStruct := {}
Local cPath		:= ""
Local cSvAlias	:= Alias()
Local lRet		:= .F.
Local nBag		:= 0
Local nLenBag	:= 0

DEFAULT lDisplay := .F.

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Verifica se o Arquivo foi Aberto.                             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
IF ( Select( cAlias ) == 0 )
	ChkFile( cAlias )	
EndIF

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Salva a Estrutura e Fecha o Arquivo                           ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
( dbSelectArea( cAlias ) , aDbStruct := ( cAlias )->( dbStruct() ) , ( cAlias )->( dbCloseArea() ) )

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Retorna o Path do Arquivo                                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
dbSelectArea("SX6")
IF Empty( cPath := AllTrim( GetMv( "MV_DGPESRC" ) ) )
	SX2->( MsSeek( cAlias ) )
	cPath := AllTrim( SX2->X2_PATH )
Else
	IF SubStr( cPath , -1 ) != "\"
		cPath += "\"
	EndIF
EndIF

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega a Bolsa de Ordens                                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
IF SIX->( MsSeek( cAlias ) ) 
	While SIX->( !Eof() .and. cAlias == INDICE )
		 SIX->( aAdd( aOrdBag , {				 ;
		 						 CHAVE 			,; // 01 - Chave do Indice 
		 						 Space(01)		,; // 02 - Nome Fisico do Arquivo de Indice
		 						 ORDEM			,; // 03 - Ordem do Indice
		 						 NICKNAME		,; // 04 - Apelido do Indice
		 					   }				 ;
		 			 )							 ;
		 	   )
		 SIX->( dbSkip() )
	End While
	nLenBag := Len( aOrdBag )
EndIF


MsOpenDbf( .T. , __cRDD , cArqMov , cAlias , .T. , .F. )

IF ( lRet := ( Select( cAlias ) > 0 ) )

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Retorna Nomes Validos Para os Arquivos de Indices             ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	For nBag := 1 To nLenBag
	   	#IFNDEF TOP
	   		aOrdBag[ nBag , 2 ] := ( RetArq( "TOPCONN" , cArqMov , .F. ) + AllTrim( aOrdBag[ nBag , 3 ] ) )
	   	#ELSE
			aOrdBag[ nBag , 2 ] := Upper( AllTrim( ( cArqMov + AllTrim( aOrdBag[nBag,3] ) ) ) )
    	#ENDIF
    Next nBag


	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Cria Indices                                                  ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	fArqMovCreateIndex( cAlias , cArqMov , aOrdBag )
    
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Verifica se Todas as Ordens foram Carregadas	               ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	For nBag := 1 To nLenBag
		IF !( lRet := fContemStr( ( cAlias )->( IndexKey( nBag ) ) , aOrdBag[  nBag , 01 ] , .T. ) )
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Exclui os Indices para que possam ser Recriados              ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			IF ( lRet := fFimArqMov( cAlias , aOrdBag , cArqMov , .T. , lDisplay ) )
				/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³Recria os Indices se Houver Diferencas nas Chaves			   ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				fArqMovCreateIndex( cAlias , cArqMov , aOrdBag )
				/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Verifica Novamente se Todas as Ordens foram Carregadas	   ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				For nBag := 1 To nLenBag
					IF !( lRet := fContemStr( ( cAlias )->( IndexKey( nBag ) ) , aOrdBag[  nBag , 01 ] , .T. ) )
						Exit
					EndIF
				Next nBag
			EndIF	
			Exit
		EndIF
	Next nBag

	IF ( lRet )

		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Mapeia 1 Campo no TOP										   ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		#IFDEF TOP
			IF RddName() == "TOPCONN" .and. TCSrvType() != "AS/400" .and. HasMapper()
				TcSrvMap( cAlias , AllTrim( FieldName(1) ) )
			EndIF
		#ENDIF


		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Seta Ordem 1 para o novo arquivo aberto                      ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		( cAlias )->( dbSetOrder( 01 ) )
	
	EndIF
EndIF

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Restaura Arquivo Atual  caso nao tenha conseguido abrir³
³Arquivos de Meses Anteriores ( RC ou RI )		        ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
IF !( lRet )
	IF ( Select( cAlias ) > 0 )
		( cAlias )->( dbCloseArea( ) )
	EndIF
	ChkFile( cAlias , .F. )
EndIF

dbSelectArea( cSvAlias )

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPEM610   ºAutor  ³Microsiga           º Data ³  01/02/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FechaTabelas()
Local nX := 1

For nX := 1 to len( aTabelas)
	fFimArqMov( aTabelas[nX,1] , aTabelas[nX,2], aTabelas[nX,3])
Next	

Return

/*
***************************************************
SEFIP DE PORTUARIOS
****************************************************

A SEFIP do trabalhador avulso portuario possui necessidades diferenciadas dos demais trabalhadores.   
Nao deve ser elaborada GFIP/SEFIP referente a competência 13 para o trabalhador avulso. Os valores de 13o e 
ferias sao pagos mensalmente de forma proporcional.
    
    1) Devera ser gerada por tomador de servico
 	2) O codigo de recolhimento e o '130'.
 	3) O FPAS e o '680'.
 	4) A categoria do trabalhador e a '02'
 	5) Os campos 'Outras Entidades', 'SIMPLES', 'Aliquota RAT', 'CNAE', 'CNAE Preponderante' e 'FAP' sao os 
 		dados do tomador de servico	(operador portuario ou titular de instalacao de uso privativo);
	6) Campo Valor Descontado do Segurado - valor da contribuição descontada do trabalhador avulso - incidente 
		sobre a remuneracao, ferias e 1/3 constitucional e 13o salário;  
	7) Campo 'Remuneracao sem 13o Salario' - valor total da remuneracao do mes e a parcela correspondente 
		as ferias proporcionais, inclusive o adicional constitucional;
	8) Campo 'Remuneracao 13o Salario' - valor da parcela correspondente ao 13o salario proporcional;
	9) Campo 'Base de Calculo 13o Salario Previdencia Social' - Ref. Compet. do Movimento - valor da parcela 
		correspondente ao 13o salario proporcional;
	
Para obter os dados para preencher os campos do item "4", sera necessario utilizar o ponto de entrada "GPM610TP20". 
Este ponto de entrada retornara os seguintes campos: 
ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³cTerc_Tom	³	Código "Outras entidades" do tomador de serviços		³
ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³cSimp_Tom	³	Devera ser preenchido com:								³
³			³ 	"	1 - nao optante pelo Simples;						³
³			³	"	2 - optante pelo Simples;							³
ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³nRAT_TOM	³	Informar a aliquota RAT (1,0%, 2,0% ou 3,0%) do tomador ³
ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³cCnae_Tom	³	CNAE do Tomador											³	
ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

Para obter as informacoes referentes ao 13o, adotamos o seguinte procedimento com a OGMO de Fortaleza:
O.G.M.O( Orgao de Gestao de Mao de Obra do Trabalho Portuario e Avulso do Porto Organizado)
	
Os valores do 13o sao gerados mensalmente na tabela SRI. As verbas utilizadas na geracao da SEFIP sao as de 
identificadores de calculo 19, 20 ou 108.

Para o calculo de SEFIP retroativa foi utilizado o ponto de entrada do fechamento mensal para gerar a tabela RI, 
com os dados do 13o. Esta tabela tem a nomenclatura "RIEEAAMM", onde "RI" sempre fixo, "EE" e o codigo da empresa,
"AA" e o ano e "MM" e o mes.
*/


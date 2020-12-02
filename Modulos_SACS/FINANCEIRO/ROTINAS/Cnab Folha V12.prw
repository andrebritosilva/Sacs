#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
//#INCLUDE "GPEM080.CH"
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funca‡…o    ³ GPEM080  ³ Autor ³ R.H. - Tatiane          ³ Data ³   13.05.05  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…cao ³ Geracao de Liquidos em disquete                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€CAO INICIAL.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³CHAMADO/REQ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Mohanad Odeh³01/04/2013³M12RH01    ³Unificacao dos Fontes V12                 ³±±
±±³            ³          ³RQ0310     ³                                          ³±±
±±|Will C.     ³30/09/2014³TQRTUJ     |Ajuste para respeitar controle de filiais ³±±
±±³            ³          ³           |e o controle de acesso do usuario.        ³±±
±±|L.Trombini  ³31/03/2015³TRYTRY     |Ajuste para acerto do arredondamento com  ³±±
±±³            ³          ³           |grandes valores que diminuia 0,01 centavo ³±±
±±³M. Silveira ³11/11/2015³TTSGNL     ³Ajuste para validar o tipo de conta para a³±±
±±³            ³          ³           |geracao do arquivo.                       ³±±
±±³Matheus M.  ³10/12/2015³TTUTLJ     ³Ajuste para alimentar o vetor aInfo com   ³±±
±±³            ³          ³           |o nome da empresa cNomeEmpr antes de usar ³±±
±±³            ³          ³           |a gravação do Header e Lote.              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CFOLPAG()
	Local cRProc	:= ""
	Private cCadastro 	:= OemToAnsi("Gera‡„o de liquido em disquete (CNAB/SISPAG)" ) // STR0001) 
	Private nSavRec  	:= RECNO()
	Private cProcessos	:= "" 

	//FUNCAO VERIFICA SE EXISTE ALGUMA RESTRICAO DE ACESSO PARA O USUARIO QUE IMPECA A EXECUCA DA ROTINA
	If !(fValidFun({"SRQ","SRC"}))
		Return( nil ) 
	Endif

	Pergunte('GPEM080',.F.)

	cDescricao := OemToAnsi(" ESTE PROGRAMA TEM O OBJETIVO DE GERAR O ARQUIVO DE LIQUIDO EM DISCO.") + CRLF + ;
	OemToAnsi(" ANTES DE RODAR ESTE PROGRAMA  ‚  NECESS RIO CADASTRAR O LAY-OUT DO  ") + CRLF + ;
	OemToAnsi(" ARQUIVO. MODULO SIGACFG OP‡„O CNAB A RECEBER OU SISPAG. ") 
	bProcesso :=	{|oSelf| GPM080Processa(oSelf)}
	tNewProcess():New( "GPEM080", cCadastro, bProcesso, cDescricao, "GPEM080",,.T.,20,cDescricao,.T.,.T.)

Return

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Funca‡…o    ³Gpm080processa³ Autor ³ Equipe de RH      ³ Data ³13/05/2005³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Processamento da geracao do arquivo                         ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³Gpm080processa()                                            ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³                                                            ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ Gpem080                                                    ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function Gpm080processa(oSelf)
	Local aCodFol		:={}
	Local lHeader		:= .F.
	Local lFirst		:= .F.
	Local lGrava		:= .F.
	Local lGp410Des 	:= ExistBlock("GP410DES")
	Local lGp450Des 	:= ExistBlock("GP450DES")
	Local lGp450Val 	:= ExistBlock("GP450VAL")
	Local aBenefCop		:= {}
	Local aVerba		:= {}
	Local nCntP
	Local aStruSRA
	Local cAliasSRA		:= "SRA" 	//ALIAS DA QUERY
	Local cLocaBco 		:= cLocaPro := ""
	Local X				:= 0 
	Local lAllProc		:= .F.
	Local nTamCod		:= 0
	Local cAuxPrc		:= ""
	Local nTpRemote		:= 0
	Local cAux			:= ""
	Local cNewArq		:= ""
	Local lCpyS2T		:= .F.
	Local lValidFil		:= .T.
	Local nAt			:= 0
	Local nCont			:= 1
	Local cStartPath	:= GetSrvProfString("StartPath","")
	//VARIAVEIS PARA CRIACAO DE LOG
	Local cLog			:= 	""
	Local aLog			:= {}
	Local aTitle		:= {}   
	Local nTotRegs		:= 0
	Local nRegsGrav		:= 0
	LOcal nTotVal		:= 0
	Local nVerba		:= 0
	Local cData			:= ""
	Local cHora			:= ""
	//ARQUIVO MESES ANTERIORES
	Local nS
	Local nX

	Local aTabS052      := {}
	Local cTemp
	Local nPos

	Private cNome,cBanco,cConta,cCPF
	Private aValBenef 	:= {}
	Private aRoteiros	:= {}          
	// VARIAVEIS DE ACESSO DO USUARIO
	Private cAcessaSR1	:= &( " { || " + ChkRH( "GPER080" , "SR1" , "2" ) + " } " )
	Private cAcessaSRA	:= &( " { || " + ChkRH( "GPER080" , "SRA" , "2" ) + " } " )
	Private cAcessaSRC	:= &( " { || " + ChkRH( "GPER080" , "SRC" , "2" ) + " } " )
	Private cAcessaSRD	:= &( " { || " + ChkRH( "GPER080" , "SRD" , "2" ) + " } " )
	Private cAcessaSRG	:= &( " { || " + ChkRH( "GPER080" , "SRG" , "2" ) + " } " )
	Private cAcessaSRH	:= &( " { || " + ChkRH( "GPER080" , "SRH" , "2" ) + " } " )
	Private cAcessaSRR	:= &( " { || " + ChkRH( "GPER080" , "SRR" , "2" ) + " } " )
	// DEFINE VARIAVEIS PRIVADAS BASICAS
	Private aABD := { "Drive A","Drive B","Abandona" } //######
	Private aTA  := { "Tenta Novamente","Abandona" } //###"Abandona"
	// DEFINE VARIAVEIS PRIVADAS DO PROGRAMA
	Private nEspaco := nDisco := nGravados := 0
	Private cDrive := " "
	Private nArq, cTipInsc
	// VARIAVEIS USADAS NO ARQUIVO DE CADASTRAMENTO
	Private nSeq		:= 0
	Private nValor		:= 0
	Private nTotal		:= 0
	Private nTotFunc	:= 0
	// VARIAVEIS DISPONIBILIZADAS PARA GERACAO DO ARQUIVO - MOD.2
	Private CIC_ARQ		:= "" //CPF
	Private NOME_ARQ		:= "" //Nome Completo
	Private PRINOME_ARQ	:= "" //Primeiro Nome
	Private SECNOME_ARQ	:= "" //Segundo Nome
	Private PRISOBR_ARQ	:= "" //Primeiro Sobrenome
	Private SECSOBR_ARQ	:= "" //Segundo Sobrenome
	Private BANCO_ARQ	:= "" //Banco
	Private CONTA_ARQ	:= "" //Conta
	Private lRegFun		:= .F.
	Private nHdlBco		:=0,nHdlSaida:=0
	Private xConteudo

	// BLOCO DE VARIAVEIS PARA CONTROLE DOS DADOS BANCARIOS DA EMPRESA
	Private lUsaBanco  := .F.
	Private lGeraDOC   := .F.
	Private lDocCC	   := .F.
	Private lDocPoup   := .F.
	Private cCodBanco  := ""
	Private cCodAgenc  := ""
	Private cDigAgenc  := ""	
	Private cCodConta  := ""
	Private cDigConta  := ""
	Private cCodConve  := ""
	Private cCodFilial := ""
	Private cCodCnpj   := ""
	Private cNomeEmpr  := ""
	Private lCCorrent  := .T.
	Private aInfo      := {}
	Private nTipoConta := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VARIAVEIS UTILIZADAS PARA PARAMETROS                                ³
	//³ mv_par01        //  Roteiros                                        ³
	//³ mv_par02        //  Roteiros                                        ³
	//³ mv_par03        //  Roteiros                                        ³
	//³ mv_par04        //  Filial  De                                      ³
	//³ mv_par05        //  Filial  Ate                                     ³
	//³ mv_par06        //  Centro de Custo De                              ³
	//³ mv_par07        //  Centro de Custo Ate                             ³
	//³ mv_par08        //  Banco /Agencia De                               ³
	//³ mv_par09        //  Banco /Agencia Ate                              ³
	//³ mv_par10        //  Matricula De                                    ³
	//³ mv_par11        //  Matricula Ate                                   ³
	//³ mv_par12        //  Nome De                                         ³
	//³ mv_par13        //  Nome Ate                                        ³
	//³ mv_par14        //  Conta Corrente De                               ³
	//³ mv_par15        //  Conta Corrente Ate                              ³
	//³ mv_par16        //  Situacao                                        ³
	//³ mv_par17        //  Layout                                          ³
	//³ mv_par18        //  Arquivo de configuracao                         ³
	//³ mv_par19        //  nome do arquivo de saida                        ³
	//³ mv_par20        //  data de credito                                 ³
	//³ mv_par21        //  Data de Pagamento De                            ³
	//³ mv_par22        //  Data de Pagamento Ate                           ³
	//³ mv_par23        //  Categorias                                      ³
	//³ mv_par24        //  Imprimir 1-Funcionarios 2-Beneficiarias 3-Ambos ³
	//³ mv_par25        //  Data de Referencia                              ³
	//³ mv_par26        //  Selecao de Processos                            ³
	//³ mv_par27        //  Selecao de Processos                            ³
	//³ mv_par28        //  Selecao de Processos                            ³
	//³ mv_par29        //  Linha Vazia no Fim do Arquivo                   ³
	//³ mv_par30        //  Processar Banco                                 ³
	//³ mv_par31        //  Gerar Conta Tipo                                ³
	//³ mv_par32        //  DOC Outros Bancos                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cFilDe		:= mv_par04
	cFilAte		:= mv_par05
	cCcDe     	:= mv_par06
	cCcate    	:= mv_par07
	cBcoDe		:= mv_par08
	cBcoAte		:= mv_par09
	cMatDe    	:= mv_par10
	cMatAte		:= mv_par11
	cNomDe		:= mv_par12
	cNomAte		:= mv_par13
	cCtaDe		:= mv_par14
	cCtaAte		:= mv_par15
	cSituacao	:= mv_par16               
	nModelo		:= mv_par17
	cArqent		:= mv_par18
	cArqSaida	:= mv_par19
	dDataPgto	:= mv_par20
	dDataDe		:= mv_par21
	dDataAte	:= mv_par22
	cCategoria	:= mv_par23
	nFunBenAmb	:= mv_par24  // 1-FUNCIONARIOS  2-BENEFICIARIAS  3-AMBOS
	dDataRef	:= If (Empty(mv_par25), dDataBase,mv_par25) 
	lLnVazia	:= If (mv_par29 == 1,.T.,.F.)
	cCodBanco 	:= mv_par30
	nTipoConta	:= 1 //mv_par31
	lUsaBanco 	:= !Empty(cCodBanco)
	lCCorrent 	:= 1 //nTipoConta == 1
	lGeraDOC  	:= mv_par32 == 1

	lSelFunc := .F.

	If MsgYesNo("Deseja selecionar funcionarios..")

		U_SelFunc(1,.f.)

		lSelFunc := .T.

	EndIf

	nSelBanco := Escolha()

	// Cria Parametros utilizados na customizacao
	//--------------------------------------------
	If !ExisteSX6("MV_SEQBRAD")
		CriarSX6("MV_SEQBRAD","C","Sequencial do  Banco do Bradesco ","000001")
	EndIf

	// Cria Parametros utilizados na customizacao
	//--------------------------------------------
	If !ExisteSX6("MV_SEQCAIX")
		CriarSX6("MV_SEQCAIX","C","Sequencial da Caixa Economica ","000001")
	EndIf

	// AGRUPA OS PROCESSOS SELECIONADOS
	If !Empty(mv_par26) .Or. !Empty(mv_par27) .Or. !Empty(mv_par28) //Processos para Impressao
		cProcessos:= If( Empty(mv_par26+mv_par27+mv_par28),"", AllTrim(mv_par26+mv_par27+mv_par28) )
	Else
		Help(" ",1,"GPEM80PROC") //P: Nenhum processo foi selecionado. ### S: Selecione ao menos um processo.
		Return()
	EndIf

	// CARREGANDO ARRAY AROTEIROS COM OS ROTEIROS SELECIONADOS
	If Len(mv_par01) > 0 .OR. Len(mv_par02) > 0 .OR. Len(mv_par03) > 0
		SelecRoteiros()	
	EndIf

	// MODIFICA VARIAVEIS PARA A QUERY
	cSitQuery := ""
	For nS:=1 to Len(cSituacao)
		cSitQuery += "'"+Subs(cSituacao,nS,1)+"'"
		If ( nS+1) <= Len(cSituacao)
			cSitQuery += "," 
		Endif
	Next nS
	cCatQuery := ""
	For nS:=1 to Len(cCategoria)
		cCatQuery += "'"+Subs(cCategoria,nS,1)+"'"
		If ( nS+1) <= Len(cCategoria)
			cCatQuery += "," 
		Endif
	Next nS

	// MONTA A STRING DE PROCESSOS PARA IMPRESSAO
	lAllProc 	:= AllTrim( cProcessos ) == "*"
	If !lAllProc
		cRProc	 	:= ""
		nTamCod := GetSx3Cache("RCJ_CODIGO", "X3_TAMANHO")
		For X := 1 to Len(Alltrim(cProcessos)) Step 5
			If Len(Subs(cProcessos,X,5)) < nTamCod
				cAuxPrc := Subs(cProcessos,X,5) + Space(nTamCod - Len(Subs(cProcessos,X,5)))
			Else
				cAuxPrc := Subs(cProcessos,X,5)
			EndIf
			cRProc += "'" + cAuxPrc + "',"
		Next X
		cRProc := Substr( cRProc, 1, Len(cRProc)-1)
	Else
		cRProc := cProcessos
	EndIf

	dbSelectArea("SRA")

	cQuery := "SELECT COUNT(*) TOTAL "
	cQuery += "FROM "+RetSqlName("SRA")
	cQuery += " WHERE RA_FILIAL  between '" + cFilDe + "' AND '" + cFilAte + "'"
	cQuery += "AND RA_MAT between '" + cMatDe + "' AND '" + cMatAte + "'"
	cQuery += "AND RA_NOME between '" + cNomDe + "' AND '" + cNomAte + "'"
	cQuery += "AND RA_CC between '" + cCcDe  + "' AND '" + cCcate  + "'"
	cQuery += "AND RA_CATFUNC IN (" + Upper(cCatQuery) + ")" 
	cQuery += "AND RA_SITFOLH IN (" + Upper(cSitQuery) + ")" 
	If !lAllProc
		cQuery += " AND RA_PROCES  IN (" + Upper(cRProc)    + ")"
	EndIf
	cQuery += "   AND D_E_L_E_T_ <> '*'"		

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)
	dbSelectArea("QUERY")
	nTotalQ := QUERY->TOTAL

	oSelf:SetRegua1(nTotalQ) // Total de Elementos da regua

	Query->( dbCloseArea() )

	//DEFINE SE DEVERA SER IMPRESSO FUNCIONARIOS OU BENEFICIARIOS
	DbSelectArea("SRQ")
	lImprFunci  := ( nFunBenAmb # 2 )
	lImprBenef  := ( nFunBenAmb # 1 )

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	|VERIFICA SE O USUARIO DEFINIU UM DIRETORIO LOCAL PARA GRAVACAO DO ARQ. |
	|DE SAIDA, POIS NESSE CASO EFETUA A GERACAO DO ARQUIVO NO SERVIDOR E AO |
	|FIM DA GERACAO COPIA PARA O DIRETORIO LOCAL E APAGA DO SERVIDOR.       |
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	|Verifica se o usuario definiu um diretorio local para gravacao do arq. |
	|de saida, pois nesse caso efetua a geracao do arquivo no servidor e ao |
	|fim da geracao copia para o diretorio local e apaga do servidor.       |
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

	nHdlSaida:=MSFCREATE(cArqSaida,0)

	//lResp := AbrePar()    //Abertura Arquivo ASC II

	If nHdlSaida < 0
		Return
	EndIf

	//Posiciono o Arquivo de parametros para buscar informacoes variaveis 
	DbSelectArea("SEE")
	DbSetOrder(3)
	If ! DbSeek(xFilial("SEE")+MV_PAR30+"F") //+Substr(MV_PAR18,1,10) )
		MsgStop("Parametro de banco nao cadastrado.. ")
		Return
	EndIf

	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+SEE->EE_CODIGO+SEE->EE_AGENCIA+SEE->EE_CONTA )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desenha cursor para movimentacao                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcRegua(SRA->(RecCount()))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava os Headers de Arquivo de de Lote                    ³
	//³ Observacao: sera' um arquivo para cada bordero.           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SX6")
	DbSetorder(1)

	If MV_PAR30 == "237"
		DbSeek("  "+"MV_SEQBRAD" )
	Else
		DbSeek("  "+"MV_SEQCAIX" )
	EndIf 
	cSeqArqBS := Alltrim(SX6->X6_CONTEUD) //GetMv("MV_SEQBS")

	cSeqArqBS := StrZero(Val(cSeqArqBS)+1,6)

	//Inicia o Header do Arquivo
	cBuffer  := SEE->EE_CODIGO    // 001-003
	cBuffer  += "0000"            // 004-007
	cBuffer  += "0"               // 008-008
	cBuffer  += Space(9)          // 009-017
	cBuffer  += "2"               // 018-019   
	cBuffer  += SM0->M0_CGC       // 020-

	If SEE->EE_CODIGO == "104"
		cBuffer += Substr(SEE->EE_CONVFOL,1,6)
		cBuffer += "01"
		cBuffer += "P"
		cBuffer += " "
		cBuffer += "   "
		cBuffer += "0000"
		cBuffer += "   "	   	   	   
	Else
		cBuffer  += SEE->EE_CONVFOL  //"0000000000008       "
	EndIf 
	cBuffer  += StrZero(Val(SEE->EE_AGENCIA),5) //"02589"
	cBuffer  += SEE->EE_DVAGE //"5"

	If SEE->EE_CODIGO =="104"
		cBuffer  += "0"+Substr(SEE->EE_CONTA,1,3)+StrZero(Val(SUBSTR(SEE->EE_CONTA,4,4)),8)+SEE->EE_DVCTA //"0000000107042 "
	Else 
		cBuffer  += StrZero(Val(SUBSTR(SEE->EE_CONTA,1,6)),12)+SEE->EE_DVCTA //"0000000107042 "
	Endif 
	cBuffer  += " "
	cBuffer  += Substr(SM0->M0_NOMECOM,1,30) 

	cBuffer  += Substr(SA6->A6_NOME,1,30) 
	cBuffer  += Space(10)
	cBuffer  += "1"
	cBuffer  += Substr(Dtos(dDatabase),7,2)+Substr(Dtos(dDatabase),5,2)+Substr(Dtos(dDatabase),1,4)
	cBuffer  += Substr(Time(),1,2)+Substr(Time(),4,2)+Substr(Time(),7,2)
	cBuffer  += cSeqArqBS
	cBuffer  += If(SEE->EE_CODIGO=="104","080","060")
	cBuffer  +=If(SEE->EE_CODIGO=="104","01600","00000")

	If SEE->EE_CODIGO == "104"
		cBuffer  += Space(54)
		cBuffer  += "000"	   
		cBuffer  += Space(12)+CHR(13)+CHR(10)
	Else
		cBuffer  += Space(69)+CHR(13)+CHR(10)
	EndIf 

	FWRITE(nHdlSaida,cBuffer)

	//Define o Header do Lote
	cBuffer  := SEE->EE_CODIGO
	cBuffer  += "0001"
	cBuffer  += "1"
	cBuffer  += "C"
	cBuffer  += "30" //Pagamentos de salarios
	cBuffer  += "01"
	cBuffer  += If(SEE->EE_CODIGO=="104","041","040")
	cBuffer  += " "
	cBuffer  += "2"
	cBuffer  += SM0->M0_CGC

	If SEE->EE_CODIGO == "104"
		cBuffer += Substr(SEE->EE_CONVFOL,1,6)
		cBuffer += "06"
		cBuffer += "0001"
		cBuffer += "01"
		cBuffer += Space(6)
	Else
		cBuffer  += SEE->EE_CONVFOL  //"0000000000008       "
	EndIf 

	cBuffer  += StrZero(Val(SEE->EE_AGENCIA),5) //"02589"
	cBuffer  += SEE->EE_DVAGE //"5"

	If SEE->EE_CODIGO =="104"
		cBuffer  += "0"+Substr(SEE->EE_CONTA,1,3)+StrZero(Val(SUBSTR(SEE->EE_CONTA,4,4)),8)+SEE->EE_DVCTA //"0000000107042 "
	Else 
		cBuffer  += StrZero(Val(SUBSTR(SEE->EE_CONTA,1,6)),12)+SEE->EE_DVCTA //"0000000107042 "
	Endif 


	cBuffer  += " "
	cBuffer  += Substr(SM0->M0_NOMECOM,1,30) //"ISA INDUSTRIA DE EMBALAGENS LT"
	cBuffer  += Space(40)

	cEnd := Substr(SM0->M0_ENDCOB,1,30)
	If "," $ cEnd
		cEndRua := Substr(cEnd,1,At(",",cEnd)-1)
		cEndRua := Alltrim(cEndRua)+Space(30-Len(AllTrim(cEndRua)))
		cEndNum := Substr(cEnd,At(",",cEnd)+1)
		cEndNum := StrZero(Val(AllTrim(cEndNum)),5)
	Else
		cEndRua := cEnd
		cEnd    := Alltrim(SM0->M0_ENDCOB) 
		cEndNum := Substr(cEnd,At(",",cEnd)+1)
		cEndNum := StrZero(Val(AllTrim(cEndNum)),5)
	EndIf

	cBuffer += cEndRua
	cBuffer += cEndNum
	cBuffer += Space(15)
	cBuffer += Substr(SM0->M0_CIDCOB,1,20)
	cBuffer += SM0->M0_CEPCOB
	cBuffer += SM0->M0_ESTCOB
	cBuffer  += Space(18)+CHR(13)+CHR(10)

	FWRITE(nHdlSaida,cBuffer)

	nSeq := 1

	/*
	If Substr(cArqSaida, 2, 1) == ":"

	//?-CHECA O SO DO REMOTE (1=WINDOWS, 2=LINUX)
	nTpRemote := (GetRemoteType())

	If nTpRemote = 2
	nAt := RAt("/", cArqSaida)
	Else	
	nAt := RAt("\", cArqSaida)
	EndIf                           

	If nAt = 0
	//
	//#
	Alert("O ENDERECO ESPECIFICADO NO PARAMETRO 'ARQUIVO DE SAIDA' NAO E VALIDO. DIGITE UM ENDERECO VALIDO CONFORME O EXEMPLO:" + CRLF + CRLF + If(nTpRemote = 1, "UNIDADE:\NOME_DO_ARQUIVO", "/NOME_DO_ARQUIVO"))
	Return
	EndIf	

	cNewArq := cArqSaida

	If (cAux := Substr(cArqSaida, Len(cArqSaida), 1)) == " "
	While cAux == " "
	cNewArq	:= Substr(cArqSaida, 1, Len(cArqSaida) - nCont)
	cAux	:= Substr(cNewArq, Len(cNewArq), 1)
	nCont++
	EndDo
	EndIf

	cNomArq		:= Right(cNewArq, Len(cNewArq) - nAt)
	cNomDir		:= Left(cNewArq, nAt)

	cArqSaida	:= cStartPath + cNomArq
	lCpyS2T		:= .T.
	Endif

	If !AbrePar()    //ABERTURA ARQUIVO ASC II
	Return
	Endif

	If nModelo == 3 //SISPAG
	// ANALISA O TIPO DE BORDERO E DEFINE QUAIS HEADERS,TRAILLERS
	// E DETALHES DE LOTE QUE SER„O UTILIZADOS.                   
	//IDENTIFICADORES                                            
	// A - HEADER ARQUIVO                                          
	// B - HEADER  LOTE 1   HEADER LOTE CHEQUE/OP/DOC/CRED.CC     
	// D - TRAILER LOTE 1   TRAILLER LOTE CHEQUE/OP/DOC/CRED.CC   
	// F - TRAILER ARQUIVO                                        
	// G - SEGMENTO A       CHEQUE/OP/DOC/CRED.CC                 
	// H - SEGMENTO B       INFORMACOES COMPLEMNTARES
	cHeadArq  := "A"
	cTraiArq  := "F"
	cHeadLote := "B"
	cTraiLote := "D"
	cDetaG    := "G"
	cDetaH    := "H"
	// GRAVA OS HEADERS DE ARQUIVO DE LOTE
	// OBSERVACAO: SERA' UM ARQUIVO PARA CADA BORDERO.
	GPM080Empresa( xFilial("SRA"), @cCodCnpj, @cNomeEmpr )
	fm080Linha(cHeadArq)
	fm080Linha(cHeadLote)
	EndIf


	BcoAnt := Space(08)
	CcAnt  := Space(09)
	CtaAnt := Space(12)
	NomAnt := Space(30)

	*/
	
	FilAnt := Replicate("!",FWSIZEFILIAL())
	
	dbSelectArea("SRA")		

	cQuery := "SELECT * "		
	cQuery += "FROM "+	RetSqlName("SRA")
	cQuery += " WHERE RA_FILIAL between '" + cFilDe + "' AND '" + cFilAte + "'"
	cQuery += "AND RA_MAT between '" + cMatDe + "' AND '" + cMatAte + "'"
	cQuery += "AND RA_NOME between '" + cNomDe + "' AND '" + cNomAte + "'"
	cQuery += "AND RA_CC between '" + cCcDe  + "' AND '" + cCcate  + "'"
	cQuery += "AND RA_CATFUNC IN (" + Upper(cCatQuery) + ")" 
	cQuery += "AND RA_SITFOLH IN (" + Upper(cSitQuery) + ")" 
	If !lAllProc
		cQuery += "AND RA_PROCES IN("+ Upper(cRProc)+ ")"
	EndIf
	cQuery += "   AND D_E_L_E_T_ <> '*'"		
	cQuery   += " ORDER BY RA_FILIAL, RA_MAT"

	aStruSRA := SRA->(dbStruct())
	SRA->( dbCloseArea() )
	dbSelectArea("SRC")
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SRA', .F., .T.)

	For nX := 1 To Len(aStruSRA)
		If ( aStruSRA[nX][2] <> "C" )
			TcSetField(cAliasSRA,aStruSRA[nX][1],aStruSRA[nX][2],aStruSRA[nX][3],aStruSRA[nX][4])
		EndIf
	Next nX

	While (cAliasSRA)->(!Eof())
		// MOVIMENTA CURSOR
		oSelf:IncRegua1("Líquido em Arquivo")

		nValor     := 0
		aValBenef := {}

		If SRA->RA_FILIAL # FilAnt

			If !Fp_CodFol(@aCodFol,SRA->RA_FILIAL)
				Exit
			Endif
			// Verifica Existencia da Tabela S052 - Bancos para CNAB
/*
			If lUsaBanco
				fCarrTab( @aTabS052, "S052", Nil)
				If Len( aTabS052 ) == 0 .Or. ( nPos := aScan(aTabS052,{|x| x[6] == cCodBanco .and. (Empty(x[2]) .or. x[2] == xFilial("SRA"))}) ) == 0
					Aviso("ATENCAO","Banco e Filial para processamento do CNAB não cadastrados na tabela S052! Favor verificar!",{"Sair"}) //"ATENCAO","Banco e Filial para processamento do CNAB não cadastrados na tabela S052! Favor verificar!" ### Sair
					Return .F.
				EndIf
				GPM080Empresa( xFilial("SRA"), @cCodCnpj, @cNomeEmpr )
				cCodFilial := aTabS052[nPos,2]
				cCodConve  := aTabS052[nPos,5]
				cCodAgenc  := aTabS052[nPos,7]
				cDigAgenc  := aTabS052[nPos,8]
				cCodConta  := aTabS052[nPos,9]
				cDigConta  := aTabS052[nPos,10]

				SA6->(dbSetOrder( 1 ))
				SA6->(dbSeek( xFilial("SA6") + cCodBanco + cCodAgenc + cCodConta ))
			EndIf */
			FilAnt := SRA->RA_FILIAL
			lValidFil := .T.

			// CONSISTE FILIAIS E ACESSOS 
			If !( SRA->RA_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRA )
				SRA->(dbSkip())
				lValidFil := .F.
				Loop
			EndIf		
		EndIf
		// CONSISTE FILIAIS E ACESSOS 
		If !lValidFil
			SRA->(dbSkip())
			Loop
		EndIf	

		If lSelFunc

			If SELFUNC->(DbSeek(Substr(SRA->RA_NOME,1,40)))

				If Empty(SELFUNC->OK)
					SRA->(dbSkip(1))
					Loop
				EndIf

			EndIf
		EndIf

		If nSelBanco # 3

			If nSelBanco == 1 

				If Substr(SRA->RA_BCDEPSA,1,3) # MV_PAR30 
					SRA->(dbSkip(1))
					Loop

				EndIf 
			Else
				If Substr(SRA->RA_BCDEPSA,1,3) == MV_PAR30
					SRA->(dbSkip(1))
					Loop

				EndIf 

			EndIf 

		EndIf 

		//CONSISTE PROCESSOS PARA IMPRESSAO
		If !(SRA->( RA_PROCES ) $ cRProc ) .And. Substr(cRProc,1,1) <> "*" 
			SRA->( dbSkip() )
			Loop
		EndIf                                    

		// BUSCA OS VALORES DE LIQUIDO E BENEFICIOS
		Gp020BuscaLiq(@nValor,@aValBenef)

		// CONSISTE PARAMETROS DE BANCO E CONTA DO FUNCIONARIO
		If (SRA->RA_BCDEPSA < cBcoDe) .Or. (SRA->RA_BCDEPSA > cBcoAte) .Or.;
		(SRA->RA_CTDEPSA < cCtaDe) .Or. (SRA->RA_CTDEPSA > cCtaAte)
			nValor := 0
		EndIf

		// FILTRA GERACAO DE DOC'S
		If lUsaBanco
			lDocCc   := Left( SRA->RA_BCDEPSA,3 ) <> cCodBanco .And. lCCorrent
			lDocPoup := Left( SRA->RA_BCDEPSA,3 ) <> cCodBanco .And. !lCCorrent    
			If !lGeraDoc .And. ( lDocCc .Or. lDocPoup )
				nValor := 0
			EndIf
		EndIf

		// ADICIONA O FUNCIONARIO NO ARRAY PARA INCLUSAO NO ARQUIVO
		If lImprFunci
			If !(Empty(SRA->RA_NOMECMP))
				AAdd(aValBenef, {SRA->RA_NOMECMP, SRA->RA_BCDEPSA, SRA->RA_CTDEPSA, "", nValor, SRA->RA_CIC, 0, "SRA", SRA->RA_TPCTSAL,SRA->RA_DGAGEN,SRA->RA_DGCONTA})
			Else
				AAdd(aValBenef, {SRA->RA_NOME, SRA->RA_BCDEPSA, SRA->RA_CTDEPSA, "", nValor, SRA->RA_CIC, 0, "SRA", SRA->RA_TPCTSAL,SRA->RA_DGAGEN,SRA->RA_DGCONTA})
			EndIf
		EndIf	

		// CONSISTE PARAMETROS DE BANCO E CONTA DO BENEFICIARIO
		// AVALBENEF: 1-NOME  2-BANCO  3-CONTA  4-VERBA  5-VALOR  6-CPF
		If Len(aValBenef) > 0
			aBenefCop  := ACLONE(aValBenef)
			aValBenef  := {}
			cTemp := If(nTipoConta == 1," *1","2")
			Aeval(aBenefCop, { |X| If( (X[2] >= cBcoDe .And. X[2] <= cBcoAte) .And. ; 
			(X[3] >= cCtaDe .And. X[3] <= cCtaAte) .And. ;
			(X[9] $ cTemp), ;
			AADD(aValBenef, X), "" ) })
		EndIf
		// TESTA SITUACAO DO FUNCIONARIO NA FOLHA
		// TESTA CATEGORIA DO FUNCIONARIO NA FOLHA
		// TESTA SE VALOR == 0
		If !(SRA->RA_SITFOLH $ cSituacao) .Or. !(SRA->RA_CATFUNC $ cCategoria) .Or. (nValor == 0 .And. Len(aValBenef) == 0)
			dbSelectArea("SRA")
			dbSkip()
			Loop
		EndIf

		// Ponto de Entrada para desprezar somente o funcionario,somente o beneficiario ou ambos, utilizando o array aValBenef.
		// CNAB Modelos 1 e 2
		If lGp410Des
			If !(ExecBlock("GP410DES",.F.,.F.))
				dbSelectArea( "SRA" )
				SRA->(dbSkip(1))
				Loop
			EndIf
		EndIf
		// SISPAG	
		If lGp450Des
			If !(ExecBlock("GP450DES",.F.,.F.))
				dbSelectArea( "SRA" )
				SRA->(dbSkip(1))
				Loop
			EndIf
		EndIf

		For nCntP := 1 To Len(aValBenef)
			//Indica se o registro atual e o funcionario ou o beneficiario		
			lRegFun := If( Len(aValBenef[nCntP]) == 7, .F., .T. )
			//Posiciona no beneficiario que esta sendo processado
			If !lRegFun
				SRQ->(dbGoTo(aValBenef[nCntP,7]))
				Loop
			EndIf
			cNome   := aValBenef[nCntP,1]
			cBanco  := aValBenef[nCntP,2]
			cConta  := aValBenef[nCntP,3]
			cCPF	:= aValBenef[nCntP,6]
	
			cDgConta := aValBenef[nCntP,11]
			cDgAgen := aValBenef[nCntP,10]

			// VERIFICA VALOR E BANCO/AGENCIA DOS BENEFICIARIOS
			If aValBenef[nCntP,5] == 0 .Or. Empty(cBanco) .Or. cBanco < cBcoDe .Or. cBanco > cBcoAte
				Loop
			EndIf
			// PONTO DE ENTRADA PARA ALTERAR DADOS CASO NECESSARIO
			If lGp450Val
				If !(ExecBlock("GP450VAL",.F.,.F.))
					Loop		
				EndIf
			EndIf
			// IGUALA NAS VARIAVEIS USADAS DO ARQUIVO DE CADASTRAMENTO
			nValor := aValBenef[nCntP,5] * 100
			nTotal += nValor
			nTotFunc ++
			

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava as linhas de detalhe de acordo com o tipo do bordero ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			cBuffer := SEE->EE_CODIGO
			cBuffer += "0001"
			cBuffer += "3"
			cBuffer += StrZero(nSeq,5)
			cBuffer += "A"
			cBuffer += "000"
			cBuffer += If(SEE->EE_CODIGO=="104","700","000") //If(Substr(SRA->RA_BCDEPSA,1,3)=="237","000","018")
			cBuffer += Substr(SRA->RA_BCDEPSA,1,3) //SUBS(cBanco,1,3)
			cBuffer += "0"
			cBuffer += StrZero(Val(SUBS(cBanco,4,4)),4)
			cBuffer += If(IsAlpha(cDgAgen),"0",cDgAgen)
			If ! "X" $ cConta
				cBuffer += StrZero(Val(cConta),12)
			Else
				cBuffer += StrZero(Val(Substr(cConta,1,At("X",cConta)-1)),12)
				cBuffer += "X"
			EndIf
			cBuffer += cDgConta
			cBuffer += " "
			cBuffer += Substr(cNome,1,30)
			If SEE->EE_CODIGO == "104"
				cBuffer += SRA->RA_MAT
				cBuffer +=Space(13) 
				cBuffer += "1"
			Else
				cBuffer += SRA->RA_FILIAL+SRA->RA_MAT+" "+Space(19-Len(Alltrim(SRA->RA_FILIAL+SRA->RA_MAT)))
			EndIf 
			cBuffer += Substr(DTOS(DDATAPGTO),7,2)+Substr(DTOS(DDATAPGTO),5,2)+Substr(DTOS(DDATAPGTO),1,4)
			cBuffer += "BRL"
			cBuffer += Replicate("0",15)
			cBuffer += StrZero(NVALOR,15)
			If SEE->EE_CODIGO == "104"
				cBuffer += Replicate("0",9)			
				cBuffer += Space(3)
				cBuffer += "01"
				cBuffer += " "
				cBuffer += "  "
				cBuffer += "00"
				cBuffer += '  '
				cBuffer += Replicate("0",8)
				cBuffer += Replicate("0",15)			
				cBuffer += Space(40)
				cBuffer += "00"
				cBuffer += Space(10)
				cBuffer += "0"

			Else
				cBuffer += Space(20)
				cBuffer += Replicate("0",8)
				cBuffer += Replicate("0",15)
				cBuffer += Space(40)
				cBuffer += Space(12)
				cBuffer += "0"
			EndIf 
			cBuffer += Space(10)+CHR(13)+CHR(10)

			FWRITE(nHdlSaida,cBuffer)

			//		Fa450Linha( cDetaG ,@cLocaBco,@cLocaPro)  // Credito

			nSeq++

			cBuffer := SEE->EE_CODIGO
			cBuffer += "0001"
			cBuffer += "3"
			cBuffer += StrZero(nSeq,5)
			cBuffer += "B"
			cBuffer += Space(3)
			cBuffer += "1"
			cBuffer += StrZero(Val(SRA->RA_CIC),14)
			cBuffer += SRA->RA_ENDEREC
			cBuffer += StrZero(Val(SRA->RA_NUMENDE),5)
			cBuffer += Space(15)
			cBuffer += Substr(SRA->RA_BAIRRO,1,15)
			cBuffer += Substr(SRA->RA_MUNICIP,1,20)
			cBuffer += SRA->RA_CEP
			cBuffer += SRA->RA_ESTADO
			cBuffer += Substr(DTOS(DDATAPGTO),7,2)+Substr(DTOS(DDATAPGTO),5,2)+Substr(DTOS(DDATAPGTO),1,4)
			cBuffer += StrZero(NVALOR,15)
			cBuffer += Replicate("0",15)
			cBuffer += Replicate("0",15)
			cBuffer += Replicate("0",15)
			cBuffer += Replicate("0",15)
			cBuffer += Space(15)
			cBuffer += "0"
			cBuffer += Space(14)+Chr(13)+Chr(10)

			FWRITE(nHdlSaida,cBuffer)

			nSeq++

			/*
			If ( nModelo == 1 )
			// LE ARQUIVO DE PARAMETRIZACAO
			nLidos:=0
			fSeek(nHdlBco,0,0)
			nTamArq:=FSEEK(nHdlBco,0,2)
			fSeek(nHdlBco,0,0)

			While nLidos <= nTamArq
			// VERIFICA O TIPO QUAL REGISTRO FOI LIDO
			xBuffer:=Space(85)
			FREAD(nHdlBco,@xBuffer,85)

			Do case
			Case SubStr(xBuffer,1,1) == CHR(1)
			If lHeader
			nLidos+=85
			Loop
			EndIf
			Case SubStr(xBuffer,1,1) == CHR(2)
			If !lFirst
			lFirst := .T.
			FWRITE(nHdlSaida,CHR(13)+CHR(10))
			EndIf
			Case SubStr(xBuffer,1,1) == CHR(3)
			nLidos+=85
			Loop
			Otherwise
			nLidos+=85
			Loop
			EndCase
			nTam := 1+(Val(SubStr(xBuffer,20,3))-Val(SubStr(xBuffer,17,3)))
			nDec := Val(SubStr(xBuffer,23,1))
			cConteudo:= SubStr(xBuffer,24,60)
			If ( aValBenef[ nCntP, 7 ] != 0 .and. ( SubStr(AllTrim(cConteudo),3,1) == "SRQ" ) )
			SRQ->(dbGoTo(aValBenef[nCntP,7]))
			EndIf
			lGrava := fM080Grava(nTam,nDec,cConteudo)
			If !lGrava
			Exit
			EndIf
			nLidos+=85
			EndDo
			If !lGrava
			Exit
			EndIf
			ElseIf ( nModelo == 2 )
			lGrava := fM080Grava(,,,)
			ElseIf ( nModelo == 3 )
			// GRAVA AS LINHAS DE DETALHE DE ACORDO COM O TIPO DO BORDERO
			fm080Linha( cDetaG ,@cLocaBco,@cLocaPro)
			fm080Linha( cDetaH ,@cLocaBco,@cLocaPro)
			EndIf
			If lGrava
			If ( nModelo == 1 )
			fWrite(nHdlSaida,CHR(13)+CHR(10))
			If !lHeader
			lHeader := .T.
			EndIf
			EndIf
			EndIf  */  
			//Grava arquivo de log.
			If nTotRegs == 0
				// 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
				cLog := "Processo          Filial          Matricula          Funcionario                             Líquido em Arquivo"
				// 12345             XX              123456             123456789012345678901234567890              999,999,999.99 
				//cLog := (Alltrim(STR0018)+ Space(04) + Alltrim(STR0019) + Space( 12 - FWSIZEFILIAL() ) + Alltrim(STR0023) + Space(05) + ;
				//Alltrim(STR0017) + Space(Len(cNome)) + STR0012 )
				Aadd(aTitle,cLog)  
				Aadd(aLog,{})
				nTotRegs := len(aLog)
			EndIf
			Aadd(aLog[nTotRegs],(SRA->RA_PROCES + space(7) + SRA->RA_FILIAL + Space( 12 - FWSIZEFILIAL() ) + SRA->RA_MAT + space(8) + cNome + space( 72 - Len(cNome) ) + ;
			Transform( (nValor / 100), "@E 999,999,999.99") ) ) 
			//"Processo " ### - "Filial " ### - "Matricula " ### - Funcionario " ### " - " + "Valor " ###.## 
			nRegsGrav++
			nTotVal += nValor
			gpm280Reset()
		Next nCntP
		dbSelectArea( "SRA" )
		SRA->( dbSkip( ) )

	Enddo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava os traillers de lote e de arquivo                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cBuffer := SEE->EE_CODIGO
	cBuffer += "0001"
	cBuffer += "5"
	cBuffer += Space(9)
	cBuffer += StrZero(nSeq+1,6)
	cBuffer += StrZero(nTotal,18)
	cBuffer += Replicate("0",18)
	cBuffer += Space(181)+CHR(13)+CHR(10)

	FWRITE(nHdlSaida,cBuffer)

	cBuffer := SEE->EE_CODIGO
	cBuffer += "9999"
	cBuffer += "9"
	cBuffer += Space(9)
	cBuffer += "000001"
	cBuffer += StrZero(nSeq+3,6)
	cBuffer += Space(211)+CHR(13)+CHR(10)

	FWRITE(nHdlSaida,cBuffer)

	/*
	If (nModelo == 1)
	// MONTA REGISTRO TRAILLER
	nSeq++
	nLidos:=0
	FSEEK(nHdlBco,0,0)
	nTamArq:=FSEEK(nHdlBco,0,2)
	FSEEK(nHdlBco,0,0)

	While nLidos <= nTamArq
	If !lGrava
	Exit
	EndIf
	// TIPO QUAL REGISTRO FOI LIDO
	xBuffer:=Space(85)
	fRead(nHdlBco,@xBuffer,85)
	If SubStr(xBuffer,1,1) == CHR(3)
	nTam := 1+(Val(SubStr(xBuffer,20,3))-Val(SubStr(xBuffer,17,3)))
	nDec := Val(SubStr(xBuffer,23,1))
	cConteudo:= SubStr(xBuffer,24,60)
	lGrava:=fM080Grava( nTam,nDec,cConteudo )
	If !lGrava
	Exit
	EndIf
	EndIf
	nLidos+=85
	EndDo
	If lGrava .And. lLnVazia
	fWrite(nHdlSaida,CHR(13)+CHR(10))
	EndIf
	ElseIf ( nModelo == 2 )
	RodaCnab2(nHdlSaida,cArqent,lLnVazia)
	ElseIf ( nModelo == 3 )
	// GRAVA OS TRAILLERS DE LOTE E DE ARQUIVO
	fm080Linha(cTraiLote)
	fm080Linha(cTraiArq)
	EndIf
	*/
	// SE UTILIZAR TOTALIZADOR NO CABECALHO, TROCAR STRING POR VALOR
	If ExistBlock("GPM080HDR")
		ExecBlock("GPM080HDR",.F.,.F.)
	EndIf

	//Gera arquivo de log
	If nTotRegs > 0
		Aadd(aLog[nTotRegs], Replicate("-",132))
		Aadd(aLog[nTotRegs], ( "Total de Registros Gerados: " + lTrim(Str(nRegsGrav,6))+ space(23) + "Valor Total: " + Transform((nTotVal/100),"@E 999,999,999.99")) ) 	
		// ### 
	Else
		aAdd( aLog, { OemToAnsi("Nenhum Registro Processado com os Parametros Informados!") } ) //
	EndIf

	If MsgYesNo(OemToAnsi( "Deseja visualizar movimentos gerados?"), OemToAnsi("Aten‡„o!"))	//  ###      
		cData	:=	DtoS(DDATABASE)      
		cHora	:=	Time()
		cArq := "GPM080" + cData
		fMakeLog (aLog,aTitle,,.T.,cArq,"Log de Geracao de Liquidos em Arquivo.","M","P",,.F.)	//	
	EndIf

	//PONTOS DE ENTRADAS UTILIZADOS PARA CRIPTOGRAFIA DE ARQUIVO DE ENVIO
	// CNAB Modelos 1 e 2
	If ExistBlock("GP410CRP")
		ExecBlock("GP410CRP",.F.,.F.)
	EndIf
	// SISPAG
	If ExistBlock("GP450CRP")
		ExecBlock("GP450CRP",.F.,.F.)
	EndIf

	// TERMINO DO RELATORIO
	dbSelectArea("SRA")
	dbCloseArea()
	ChkFile("SRA")

	fClose(nHdlSaida)
	fClose(nHdlBco)
	dbSelectArea("SRA")

	If lCpyS2T
		If CpyS2T( cStartPath + cNomArq, cNomDir)
			fErase( cStartPath + cNomArq )
		EndIf
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AbrePar   ³ Autor ³ Wagner Xavier         ³ Data ³ 26/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Abre arquivo de Parametros                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³AbrePar()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³GPEM080                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AbrePar()
	If !FILE(cArqEnt)
		Help(" ",1,"NOARQPAR")
		Return .F.
	Else
		If ( nModelo == 1 .or. nModelo == 3 ) 
			nHdlBco:=FOPEN(cArqEnt,0+64)
		EndIf
	EndIF

	// PONTOS DE ENTRADAS PARA ALTERAR O NOME DA VARIAVEL CARQSAIDA
	// CNAB MODELOS 1 E 2
	If ExistBlock("GP410ARQ")
		cArqSaida := ExecBlock( "GP410ARQ", .F., .F., {cArqSaida} )		
	EndIf
	// SISPAG
	If ExistBlock("GP450ARQ")
		cArqSaida := ExecBlock( "GP450ARQ", .F., .F., {cArqSaida} )		
	EndIf

	// CRIA ARQUIVO SAIDA
	If ( nModelo == 1 .or. nModelo == 3 )
		nHdlSaida:=MSFCREATE(cArqSaida,0)
	Else
		nHdlSaida:=HeadCnab2(cArqSaida,cArqent)
	EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fM080Grava³ Autor ³ Wagner Xavier         ³ Data ³ 26/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Geracao do Arquivo de Remessa de Comunicacao      ³±±
±±³          ³Bancaria                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpL1:=fM080Grava(ExpN1,ExpN2,ExpC1)                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPEM080                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC Function fM080Grava( nTam,nDec,cConteudo )
	Local lConteudo := .T., cCampo

	If ( nModelo == 1 .or. nModelo == 3 )
		// ANALISA CONTEUDO
		If Empty(cConteudo)
			cCampo:=Space(nTam)
		Else
			If "_ARQ" $ cConteudo
				gpm280Var(cConteudo)
			EndIf			
			lConteudo := fM080Orig( cConteudo )
			If !lConteudo
				Return .F.
			Else
				If ValType(xConteudo)="D"
					cCampo := GravaData(xConteudo,.F.)
				ElseIf ValType(xConteudo)="N"
					cCampo:=Substr(Strzero(xConteudo,nTam,nDec),1,nTam)
				Else
					cCampo:=Substr(xConteudo,1,nTam)
				EndIf
			EndIf
		EndIf
		If Len(cCampo) < nTam  //Preenche campo a ser gravado, caso menor
			cCampo:=cCampo+Space(nTam-Len(cCampo))
		EndIf
		Fwrite( nHdlSaida,cCampo,nTam )
	Else
		DetCnab2(nHdlSaida,cArqent)
	EndIf

Return lConteudo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fM080Orig ³ Autor ³ Wagner Xavier         ³ Data ³ 10/11/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se expressao e' valida para Remessa CNAB.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³GPEM080                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fM080Orig( cForm )
	Local bBlock:=ErrorBlock(),bErro := ErrorBlock( { |e| ChecErr260(e,cForm) } )
	Private lRet := .T.

	BEGIN SEQUENCE
		xConteudo := &cForm
	END SEQUENCE

	ErrorBlock(bBlock)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fm080Linha³ Autor ³ Vinicius S.Barreira   ³ Data ³ 11.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava linha do Arquivo Remessa SisPag                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fm080Linha( Parametro )                                    ³±±
±±³          ³ Parametro: letra correspondente  „ linha do arquivo de     ³±±
±±³          ³ configura‡„o SisPag.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPEM080()                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fm080Linha( cParametro ,cLocaBco , cLocaPro)
	Local nLidos    := 0
	Local nTamArq   := 0
	Local nTam      := 0
	Local nDec      := 0
	local cConteudo := ""
	Local lGerouReg := .F.

	cLocaBco := If(Empty(cLocaBco),"",cLocaBco)
	cLocaPro := If(Empty(cLocaPro),"",cLocaPro)

	If ValType( cParametro ) # "C" .or. Empty( cParametro )
		Return .T.
	EndIf

	// LE ARQUIVO DE PARAMETRIZACAO
	nLidos := 0
	fSeek(nHdlBco,0,0)
	nTamArq := fSeek(nHdlBco,0,2)
	fSeek(nHdlBco,0,0)

	While nLidos <= nTamArq
		// VERIFICA O TIPO QUAL REGISTRO FOI LIDO
		xBuffer := Space(85)
		fRead(nHdlBco,@xBuffer,85)

		If SubStr( xBuffer,1,1) == cParametro
			nTam := 1+(Val(SubStr(xBuffer,20,3))-Val(SubStr(xBuffer,17,3)))
			nDec := Val(SubStr(xBuffer,23,1))
			cConteudo := SubStr(xBuffer,24,60)
			If ( "Codigo Banco   "== SubStr(xBuffer,2,15) .Or.; //
			"Num. Agencia   "==SubStr(xBuffer,2,15) .Or.;  //
			"Num. C/C.      "==SubStr(xBuffer,2,15) )      //
				If (!SubStr(xBuffer,2,15)$cLOCAPRO )
					cLOCABCO += &(ALLTRIM(cConteudo))
					cLOCAPRO += SubStr(xBuffer,2,15)
				EndIf	
			EndIf
			If (("CGC"$Upper(SubStr(xBuffer,2,15)) .And.	AllTrim(cConteudo)=='"16670085000155"' ) .Or. cLOCABCO=="34101403000000034594")
				Alert("CONFIGURACAO INVALIDA")
				lGrava := .F.
			Else		
				lGrava := fM080Grava(nTam,nDec,cConteudo)
			EndIf
			If !lGrava
				Exit
			EndIf
			lGerouReg := .T.
		EndIf

		nLidos += 85

	EndDo

	If lGerouReg
		FWRITE(nHdlSaida,CHR(13)+CHR(10))
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FDLiqu    ³ Autor ³ R.H. -                ³ Data ³ 26/01/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ SELECIONAR DIRETORIO PARA GRAVA ARQUIVO CNAB/SISPAG        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FDLiqu()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPEM080                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FDLiqu(cLayout)
	Local mvRet		:= Alltrim(ReadVar())
	Local cType 	:= ""
	Local cArq		:= ""
	Local aDir		:= {}
	Local nDir		:= 0

	cType := If(cLayout == 1, " REM |REM ", If(cLayout == 2, "" , " PAG |PAG ")) // ### " 2RE |2RE "### 

	// COMANDO PARA SELECIONAR UM ARQUIVO.
	// PARAMETRO: GETF_LOCALFLOPPY - INCLUI O FLOPPY DRIVE LOCAL.
	//            GETF_LOCALHARD - INCLUI O HARDDISK LOCAL.
	cArq 	:= cGetFile(cType, OemToAnsi("Selecione arquivo "), 0,, .T.,GETF_LOCALHARD+GETF_LOCALFLOPPY,,)  // 
	aDir	:= { { cArq } }

	For nDir := 1 To Len(aDir)
		cArq := aDir[nDir][1]

		If !Empty(cArq)
			If !File(cArq)
				MsgAlert(OemToAnsi("Arquivo nao encontrado ")+ cArq)  // 
				Return .F.
			EndIf
		EndIf
	Next nDir

	&mvRet := cArq

Return (.T.)

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³DetCnab2      ³ Autor ³ Marcelo Silveira  ³ Data ³23/11/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Geracao do arquivo na rotina local devido o tratamento das  ³
³          ³variaveis disponibilizadas para geracao do arquivo liquidos ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ Gpem080                                                    ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function DetCnab2(nHandle,cLayOut,lIdCnab,cAlias)
	Local nHdlLay	:= 0
	Local lContinua := .T.
	Local cBuffer	:= ""
	Local aLayOut	:= {}
	Local aDetalhe  := {}
	Local nCntFor	:= 0
	Local nCntFor2  := 0
	Local lFormula  := ""
	Local nPosIni	:= 0
	Local nPosFim	:= 0
	Local nTamanho  := 0
	Local nDecimal  := 0
	Local bBlock	:= ErrorBlock()
	Local bErro 	:= ErrorBlock( { |e| ChecErr260(e,xConteudo) } )
	Local aGetArea  := GetArea()
	Local cIdCnab
	Local aArea
	Local nOrdem

	DEFAULT cAlias 	:= ""
	DEFAULT lIdCnab 	:= .F.
	Private xConteudo := ""

	nQtdLinLote := If(Type("nQtdLinLote") != "N",0,nQtdLinLote)

	If ( File(cLayOut) )
		nHdlLay := FOpen(cLayOut,64)
		While ( lContinua )
			cBuffer := FreadStr(nHdlLay,502)
			If ( !Empty(cBuffer) )
				If ( SubStr(cBuffer,1,1)=="1" )
					If ( SubStr(cBuffer,3,1) == "D" )
						aadd(aLayOut,{ SubStr(cBuffer,02,03),;
						SubStr(cBuffer,05,30),;
						SubStr(cBuffer,35,255)})
					EndIf
				Else
					If ( SubStr(cBuffer,3,1) == "D" )
						aadd(aDetalhe,{SubStr(cBuffer,02,03),;
						SubStr(cBuffer,05,15),;
						SubStr(cBuffer,20,03),;
						SubStr(cBuffer,23,03),;
						SubStr(cBuffer,26,01),;
						SubStr(cBuffer,27,255)})
					EndIf
				EndIf
			Else
				lContinua := .F.
			EndIf
		End
		FClose(nHdlLay)
	EndIf
	If nHandle > 0
		For nCntFor := 1 To Len(aLayOut)
			Begin Sequence
				lFormula := &(AllTrim(aLayOut[nCntFor,3]))
				If ( lFormula .And. SubStr(aLayOut[nCntFor,1],2,1)=="D" )
					cBuffer := ""
					// So gera outro identificador, caso o titulo ainda nao o tenha, pois pode ser um re-envio do arquivo
					If !Empty(cAlias) .And. lIdCnab .And. Empty((cAlias)->&(Right(cAlias,2)+"_IDCNAB")) 
						// Gera identificador do registro CNAB no titulo enviado
						nOrdem := If(Alltrim(Upper(cAlias))=="SE1",16,11)
						cIdCnab := GetSxENum(cAlias, Right(cAlias,2)+"_IDCNAB",Right(cAlias,2)+"_IDCNAB"+cEmpAnt,nOrdem)
						// Garante que o identificador gerado nao existe na base
						dbSelectArea(cAlias)
						aArea := (cAlias)->(GetArea())
						dbSetOrder(nOrdem)
						While (cAlias)->(MsSeek(xFilial(cAlias)+cIdCnab))
							ConOut("Id CNAB " + cIdCnab + " já existe para o arquivo " + cAlias + ". Gerando novo número ")
							If ( __lSx8 )
								ConfirmSX8()
							EndIf
							cIdCnab := GetSxENum(cAlias, Right(cAlias,2)+"_IDCNAB",Right(cAlias,2)+"_IDCNAB"+cEmpAnt,nOrdem)
						EndDo
						(cAlias)->(RestArea(aArea))
						Reclock(cAlias)
						(cAlias)->&(Right(cAlias,2)+"_IDCNAB") := cIdCnab
						MsUnlock()
						ConfirmSx8()
						lIdCnab := .F. // Gera o identificacao do registro CNAB apenas uma vez no
						// titulo enviado
					EndIf
					For nCntFor2 := 1 To Len(aDetalhe)
						If ( aDetalhe[nCntFor2,1] == aLayOut[nCntFor,1] )
							xConteudo := aDetalhe[nCntFor2,6]
							If ( Empty(xConteudo) )
								xConteudo := ""
							Else
								If "_ARQ" $ xConteudo
									gpm280Var(xConteudo)
								EndIf
								xConteudo := &(AllTrim(xConteudo))
							EndIf
							nPosIni   := Val(aDetalhe[nCntFor2,3])
							nPosFim   := Val(aDetalhe[nCntFor2,4])
							nDecimal  := Val(aDetalhe[nCntFor2,5])
							nTamanho  := nPosFim-nPosIni+1
							Do Case
								Case ValType(xConteudo) == "D"
								xConteudo := GravaData(xConteudo,.F.)
								Case ValType(xConteudo) == "N"
								xConteudo := StrZero(xConteudo,nTamanho,nDecimal)
							EndCase
							xConteudo := SubStr(xConteudo,1,nTamanho)
							xConteudo := PadR(xConteudo,nTamanho)
							cBuffer += xConteudo
						EndIf
					Next nCntFor2
					cBuffer += Chr(13)+Chr(10)
					Fwrite(nHandle,cBuffer,Len(cBuffer))
					nQtdLinLote++
				EndIf
			End Sequence
		Next nCntFor
		ErrorBlock(bBlock)
	EndIf
	RestArea(aGetArea)
Return(.T.)

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³gpm280Var     ³ Autor ³ Marcelo Silveira  ³ Data ³26/11/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Atualiza as variaveis disponibilizadas para o arquivo de    ³
³          ³configuracao                                                ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ Gpem080                                                    ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function gpm280Var(xConteudo)

	If cPaisLoc == "MEX"
		If( "CIC_ARQ"     $ xConteudo, CIC_ARQ     := If( lRegFun, SRA->RA_CIC, SRQ->RQ_CIC ),     "" )
		If( "NOME_ARQ"    $ xConteudo, NOME_ARQ    := If( lRegFun, SRA->RA_NOME, SRQ->RQ_NOME ),    "" )
		If( "PRINOME_ARQ" $ xConteudo, PRINOME_ARQ := If( lRegFun, SRA->RA_PRINOME, SRQ->RQ_PRINOME ), "" )
		If( "SECNOME_ARQ" $ xConteudo, SECNOME_ARQ := If( lRegFun, SRA->RA_SECNOME, SRQ->RQ_SECNOME ), "" )
		If( "PRISOBR_ARQ" $ xConteudo, PRISOBR_ARQ := If( lRegFun, SRA->RA_PRISOBR, SRQ->RQ_PRISOBR ), "" )
		If( "SECSOBR_ARQ" $ xConteudo, SECSOBR_ARQ := If( lRegFun, SRA->RA_SECSOBR, SRQ->RQ_SECSOBR ), "" )
		If( "BANCO_ARQ"   $ xConteudo, BANCO_ARQ   := If( lRegFun, AllTrim(SRA->RA_BCDEPSA), AllTrim(SRQ->RQ_BCDEPBE)), "" )
		If( "CONTA_ARQ"   $ xConteudo, CONTA_ARQ   := If( lRegFun, AllTrim(SRA->RA_CTDEPSA), AllTrim(SRQ->RQ_CTDEPBE)), "" )
	EndIf

Return()

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³gpm280Reset   ³ Autor ³ Marcelo Silveira  ³ Data ³26/11/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Limpa o conteudo da variaveis usadas no arquivo de config.  ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ Gpem080                                                    ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
STATIC FUNCTION gpm280Reset()
	CIC_ARQ		:= ""
	NOME_ARQ	:= ""
	PRINOME_ARQ	:= ""
	SECNOME_ARQ	:= ""
	PRISOBR_ARQ	:= ""
	SECSOBR_ARQ	:= ""
	BANCO_ARQ	:= ""
	CONTA_ARQ	:= ""
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ³±±
±±³Funcao    ³GPM080Empresa³ Autor ³ Adilson Silva      ³ Data ³ 05/04/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ³±±
±±³Descricao ³Busca o CNPJ da Empresa com Convenio no Banco para o CNAB.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³±±
±±³ Uso      ³ GPEM080()                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GPM080Empresa(cFil, cCodCnpj, cNomeEmpr)
	Local aOldAtu := GetArea()
	Local aOldSm0 := SM0->(GetArea())

	DbSelectArea("SM0")
	DbSetOrder(1)
	If dbSeek(cEmpAnt + cFil)
		cCodCnpj  := SM0->M0_CGC
		cNomeEmpr := Upper(Alltrim(SM0->M0_NOMECOM))
		fInfo(@aInfo,cFil)
	EndIf

	RestArea(aOldSm0)
	RestArea(aOldAtu)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CNABSequencia³ Autor ³ Adilson Silva      ³ Data ³ 05/04/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Busca o CNPJ da Empresa com Convenio no Banco para o CNAB.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPEM450()                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function CNABSequencia()

	Local aOldAtu := GetArea()
	Local cChave  := xFilial("RCC") + "S052" + cCodFilial
	Local cRet    := "000000"
	Local cTexto  := ""

	If lUsaBanco
		dbSelectArea( "RCC" )
		dbSetOrder( 1 )		// RCC_FILIAL+RCC_CODIGO+RCC_FIL+RCC_CHAVE+RCC_SEQUEN
		dbSeek( cChave )
		Do While !Eof() .And. RCC->(RCC_FILIAL+RCC_CODIGO+RCC_FIL) == cChave
			If SubStr(RCC->RCC_CONTEU,21,3) == cCodBanco .And. SubStr(RCC->RCC_CONTEU,24,5) == cCodAgenc .And. SubStr(RCC->RCC_CONTEU,30,12) == cCodConta
				cRet   := StrZero(Val(SubStr(RCC->RCC_CONTEU,43,6))+1,6)
				cTexto := Stuff(RCC->RCC_CONTEU,43,6,cRet)			// Left(RCC->RCC_CONTEU,40) + cRet
				RecLock("RCC",.F.)
				RCC->RCC_CONTEU := cTexto
				MsUnlock()
				Exit
			EndIf

			dbSkip()
		EndDo
	EndIf

	RestArea( aOldAtu )

Return( cRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Escolha   ºAutor  ³Carlos R. Moreira   º Data ³  09/18/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Seleciona a Opcao desejada                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Escolha()
	Local oDlg2
	Private nRadio := 1
	Private oRadio

	@ 0,0 TO 200,250 DIALOG oDlg2 TITLE "Selecione o Banco"

	@ 05,05 TO 67,120 TITLE "Somente Banco"
	@ 23,30 RADIO oRadio Var nRadio Items "Bradesco","Outros","Todos" 3D SIZE 60,10 of oDlg2 Pixel

	@ 080,075 BMPBUTTON TYPE 1 ACTION Close(oDlg2)
	ACTIVATE DIALOG oDlg2 CENTER

Return nRadio

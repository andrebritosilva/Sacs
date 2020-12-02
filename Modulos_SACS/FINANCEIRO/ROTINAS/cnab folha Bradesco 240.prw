#INCLUDE "PROTHEUS.CH"

/*
������������������������������������������������������������������������������������
������������������������������������������������������������������������������������
��������������������������������������������������������������������������������Ŀ��
���Fun��o    � GPEX450  � Autor � R.H. - Mauro                 � Data � 10.04.96 ���
��������������������������������������������������������������������������������Ĵ��
���Descri��o � Geracao de Liquidos em disquete                                   ���
��������������������������������������������������������������������������������Ĵ��
���Parametros�                                                                   ���
��������������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                        ���
��������������������������������������������������������������������������������Ĵ��
���������������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������������
����������������������������������������������������������������������������������*/
User Function CNABFOL()
	Local nOpca

	Local aSays		  :={ }, aButtons:= { } //<== arrays locais de preferencia
	Local aRegs       := {}

	Private cCadastro := OemToAnsi("Gera��o de liquido em disquete ") //"Gera��o de liquido em disquete ( SISPAG ) "
	Private nSavRec   := RECNO()

	Public dDataIni    :=STOD("")
	public dDataFim    :=STOD("")

	nOpca := 0
/*
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//���������������������������������������������������������������� */

	Pergunte("GPM450",.F.)

	AADD(aSays,OemToAnsi("Este programa tem o objetivo de gerar o arquivo de liquido em disco no") )  //
	AADD(aSays,OemToAnsi("padr�o cnab de folha do Banco Bradesco . ") )  //"padr�o SISPAG. Antes de rodar este programa  �  necess�rio cadastrar o"
//AADD(aSays,OemToAnsi(STR0004) )  //"lay-out do arquivo no Modulo SIGACFG op��o SISPAG.                    "

	AADD(aButtons, { 5,.T.,{|| Pergunte("GPM450",.T. ) } } )
	AADD(aButtons, { 1,.T.,{|o| nOpca := 1,IF(gpconfOK(),FechaBatch(),nOpca:=0) }} )
	AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

	FormBatch( cCadastro, aSays, aButtons )

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//����������������������������������������������������������������
	If nOpca == 1
		Processa({|lEnd| GPM450Processa(),"Gera��o de liquido em disquete "})  //
	Endif

Return

*-------------------------------*
Static Function Gpm450processa()
*-------------------------------*
//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Programa)                           �
//����������������������������������������������������������������
	Local nExtra
	Local aCodFol:={}
	Local aValBenef := {}
	Local aBenefCop := {}
	Local nCntP
	Local lHeader:=.F.,lFirst:=.F.,lGrava:=.F.
	Local cLocaBco := cLocaPro := ""
	Local lPontoVal:=ExistBlock("GP450VAL")
	Local cAux			:= ""
	Local cStartPath	:= GetSrvProfString("StartPath","")
	Local cNomArq		:= ""
	Local cNomDir		:= ""
	Local cPath 		:= GETTEMPPATH()
	Local cNewArq		:= ""
	Local nCont			:= 1
	Local nAt			:= 0
	Local nX			:= 0
	Local lCpyS2T		:= .F.

	#IFDEF TOP
		Local nS		:= 0
		Local aStruSRA	:= {}
		Local cAliasSRA := "SRA" 	//Alias da Query
		Local cSitQuery := ""
		Local cCatQuery := ""
		Local cSRCExist := ""
		Local cSRIExist := ""
		Local cSRHExist := ""
		Local cSR1Exist := ""
		Local cSRGExist := ""
		Local lDtItens	:= .F.
	#ENDIF

//Variaveis para identificacao do arquivo de movimento (apenas para TOP)
	Local cRCName
	Local cRIName

//--Arquivo meses Anteriores
	Local cMesArqRef 	:= ""
	Local cAliasMov	 	:= ""
	Local cArqMov	 	:= ""
	Local aOrdBag	 	:= {}
	Local cAliasRI	 	:= ""
	Local cArqMovRI	 	:= ""
	Local aOrdBagRI	 	:= {}
	Local cCompetencia 	:= SuperGetMv( "MV_FOLMES",,Space(06) )

	Private cNome,cBanco,cConta,cCPF

//��������������������������������������������������������������Ŀ
//� Variaveis de Acesso do Usuario                               �
//����������������������������������������������������������������
	Private cAcessaSR1	:= &( " { || " + ChkRH( "GPER280" , "SR1" , "2" ) + " } " )
	Private cAcessaSRA	:= &( " { || " + ChkRH( "GPER280" , "SRA" , "2" ) + " } " )
	Private cAcessaSRC	:= &( " { || " + ChkRH( "GPER280" , "SRC" , "2" ) + " } " )
	Private cAcessaSRG	:= &( " { || " + ChkRH( "GPER280" , "SRG" , "2" ) + " } " )
	Private cAcessaSRH	:= &( " { || " + ChkRH( "GPER280" , "SRH" , "2" ) + " } " )
	Private cAcessaSRI	:= &( " { || " + ChkRH( "GPER280" , "SRI" , "2" ) + " } " )
	Private cAcessaSRR	:= &( " { || " + ChkRH( "GPER280" , "SRR" , "2" ) + " } " )

//��������������������������������������������������������������Ŀ
//� Variaveis Usadas no Arquivo de Cadastramento                 �
//����������������������������������������������������������������
	Private nSeq      := 0
	Private nValor    := 0
	Private nTotal    := 0
	Private nTotFunc  := 0

	Private nHdlBco :=0,nHdlSaida:=0
	Private xConteudo

	private aVerbas 	:= {}
	private nSalContrib	:= 0
	private nValFgts    := 0
	private nTotCre    	:= 0
	private nTotDeb    	:= 0
	private nLiqMes    	:= 0
	private vSalBase    := 0
	private vBaseIR   	:= 0
	private vBaseFgts   := 0
	private nContVerba  := 0

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        //  Adiantamento                             �
//� mv_par02        //  Folha                                    �
//� mv_par03        //  1�Parc. 13� Sal�rio                      �
//� mv_par04        //  2�Parc. 13� Sal�rio                      �
//� mv_par05        //  F�rias                                   �
//� mv_par06        //  Extras                                   �
//� mv_par07        //  Numero da Semana                         �
//� mv_par08        //  Filial  De                               �
//� mv_par09        //  Filial  Ate                              �
//� mv_par10        //  Centro de Custo De                       �
//� mv_par11        //  Centro de Custo Ate                      �
//� mv_par12        //  Banco /Agencia De                        �
//� mv_par13        //  Banco /Agencia Ate                       �
//� mv_par14        //  Matricula De                             �
//� mv_par15        //  Matricula Ate                            �
//� mv_par16        //  Nome De                                  �
//� mv_par17        //  Nome Ate                                 �
//� mv_par18        //  Conta Corrente De                        �
//� mv_par19        //  Conta Corrente Ate                       �
//� mv_par20        //  Situacao                                 �
//� mv_par21        //  Arquivo de configuracao                  �
//� mv_par22        //  nome do arquivo de saida                 �
//� mv_par23        //  data de credito                          �
//� mv_par24        //  Data Pagamento De                        �
//� mv_par25        //  Data Pagamento Ate                       �
//� mv_par26        //  Categorias                               �
//� mv_par27        //  Rescisao			                     �
//� mv_par28        //  Imprimir			                     �
//� mv_par29        //  Data de Referencia                       �
//����������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//����������������������������������������������������������������
	lAdianta  := If(mv_par01 == 1,.T.,.F.)
	lFolha    := If(mv_par02 == 1,.T.,.F.)
	lPrimeira := If(mv_par03 == 1,.T.,.F.)
	lSegunda  := If(mv_par04 == 1,.T.,.F.)
	lFerias   := If(mv_par05 == 1,.T.,.F.)
	lExtras   := If(mv_par06 == 1,.T.,.F.)
	Semana    := mv_par07
	cFilDe    := mv_par08
	cFilAte   := mv_par09
	cCcDe     := mv_par10
	cCcate    := mv_par11
	cBcoDe    := mv_par12
	cBcoAte   := mv_par13
	cMatDe    := mv_par14
	cMatAte   := mv_par15
	cNomDe    := mv_par16
	cNomAte   := mv_par17
	cCtaDe    := mv_par18
	cCtaAte   := mv_par19
	cSituacao := mv_par20
	cArqent   := mv_par21
	cArqSaida := mv_par22
	dDataPgto := mv_par23
	dDataDe   := mv_par24
	dDataAte  := mv_par25
	cCategoria:= mv_par26
	lRescisao := If(mv_par27 == 1,.T.,.F.)
	nFunBenAmb:= mv_par28  // 1-Funcionarios  2-Beneficiarias  3-Ambos
	dDataRef  := If (Empty(mv_par29), dDataBase,mv_par29)

	lSelFunc := .F.

	If MsgYesNo("Deseja selecionar funcionarios..")

		U_SelFunc()

		lSelFunc := .T.
   
	EndIf


// Cria Parametros utilizados na customizacao
//--------------------------------------------
//If !ExisteSX6("MV_SEQBS")
//	CriarSX6("MV_SEQBS","C","Sequencial do  Banco do Santander ","000010")
//EndIf

// Abertura de Arquivo de outros meses                          �

//���������������������������������������������������������������������Ŀ
//� Abre o SRC                                                          �
//�����������������������������������������������������������������������
	If !Empty( cCompetencia )
		If !Empty( cCompetencia ) .And. MesAno( dDataRef ) > cCompetencia
			Aviso( "Atencao", "Nao existe arquivo de fechamento referente a data base solicitada" + ": "+Subs(MesAno(dDataRef),5,2)+"/"+Subs(MesAno(ddataref),1,4), { "OK" } ) //######"Ok"
			Return .F.
		Endif
	Endif

	cMesArqRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)

//If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, dDataRef )
//	Return .F.
//Endif

//���������������������������������������������������������������������Ŀ
//� Abre o SRI                                                          �
//�����������������������������������������������������������������������
	If lSegunda
		If !OpenSrc( "13" + Substr(cMesArqRef,3,4), @cAliasRI, @aOrdBagRI, @cArqMovRI, dDataRef )
			Return .F.
		EndIf
	EndIf

	If lFerias .and. ("F" $ cSituacao .and. !("A"$cSituacao) )
		cSituacao += "A"
	EndIf

	#IFDEF TOP
	//-- Modifica variaveis para a Query
		For nS:=1 to Len(cSituacao)
			cSitQuery += "'"+Subs(cSituacao,nS,1)+"'"
			If ( nS+1) <= Len(cSituacao)
				cSitQuery += ","
			Endif
		Next nS
	
		For nS:=1 to Len(cCategoria)
			cCatQuery += "'"+Subs(cCategoria,nS,1)+"'"
			If ( nS+1) <= Len(cCategoria)
				cCatQuery += ","
			Endif
		Next nS
	
		If lFerias
		//��������������������������������������������������������������Ŀ
		//� Verifica existencia do campo RH_DTITENS                      �
		//����������������������������������������������������������������
			dbSelectArea( "SRH" )
			lDtItens := SRH->(FieldPos( "RH_DTITENS" )) # 0
		EndIf
	
		cRCName := If( Empty(cAliasMov), RetSqlName("SRC"), cArqMov )
		cRIName := If( Empty(cAliasRI), RetSqlName("SRI"), cArqMovRI )
	#ENDIF

//��������������������������������������������������������������Ŀ
//� Define se devera ser impresso Funcionarios ou Beneficiarios  �
//����������������������������������������������������������������
	dbSelectArea( "SRQ" )
	lImprFunci  := ( nFunBenAmb # 2 )
	lImprBenef  := ( nFunBenAmb # 1 .And. FieldPos( "RQ_BCDEPBE" ) # 0 .And. FieldPos( "RQ_CTDEPBE" ) # 0 )

//��������������������������������������������������������������Ŀ
//� Informa a nao existencia dos campos de bco/age/conta corrente�
//����������������������������������������������������������������
	If nFunBenAmb # 1 .And. !lImprBenef
		fAvisoBC()
		Return .F.
	Endif

/*
�����������������������������������������������������������������������Ŀ
|Verifica se o usuario definiu um diretorio local para gravacao do arq. |
|de saida, pois nesse caso efetua a geracao do arquivo no servidor e ao |
|fim da geracao copia para o diretorio local e apaga do servidor.       |
�������������������������������������������������������������������������*/
                
	nHdlSaida:=MSFCREATE(cArqSaida,0)

//lResp := AbrePar()    //Abertura Arquivo ASC II

	If nHdlSaida < 0
		Return
	EndIf

//Posiciono o Arquivo de parametros para buscar informacoes variaveis 
	DbSelectArea("SEE")
	DbSetOrder(1)
	If ! DbSeek(xFilial("SEE")+MV_PAR30) //+Substr(MV_PAR18,1,10) )
		MsgStop("Parametro de banco nao cadastrado.. ")
		Return
	EndIf

	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+SEE->EE_CODIGO+SEE->EE_AGENCIA+SEE->EE_CONTA )

//�����������������������������������������������������������Ŀ
//� Desenha cursor para movimentacao                          �
//�������������������������������������������������������������
	ProcRegua(SRA->(RecCount()))

//�����������������������������������������������������������Ŀ
//� Grava os Headers de Arquivo de de Lote                    �
//� Observacao: sera' um arquivo para cada bordero.           �
//�������������������������������������������������������������
	DbSelectArea("SX6")
	DbSetorder(1)

	DbSeek("  "+"MV_SEQBS" )

	cSeqArqBS := Alltrim(SX6->X6_CONTEUD) //GetMv("MV_SEQBS")

	cSeqArqBS := StrZero(Val(cSeqArqBS)+1,6)

//Inicia o Header do Arquivo
	cBuffer  := SEE->EE_CODIGO
	cBuffer  += "0000"
	cBuffer  += "0"
	cBuffer  += Space(9)
	cBuffer  += "2"
	cBuffer  += SM0->M0_CGC
//If SM0->M0_CODIGO == "01"
	cBuffer  += SEE->EE_CONVFOL  //"0000000000008       "
//Else 
//   cBuffer  += "0000000000013       "
//EndIf 
	cBuffer  += StrZero(Val(SEE->EE_AGENCIA),5) //"02589"
	cBuffer  += SEE->EE_DVAGE //"5"
//If SM0->M0_CODIGO == "01"
	cBuffer  += StrZero(Val(SEE->EE_CONTA),12)+SEE->EE_DVCTA //"0000000107042 "
	cBuffer  += " "
	cBuffer  += Substr(SM0->M0_NOMECOM,1,30) //"ISA INDUSTRIA DE EMBALAGENS LT"
//ElseIf SM0->M0_CODIGO == "02"
//   cBuffer  += "0000000154873 "
//   cBuffer  += "RECISA RECICLAGEM E LOGISTICA "
//EndIf 

	cBuffer  += Substr(SA6->A6_NOME,1,30) //"BANCO DO BRASIL SA            "
	cBuffer  += Space(10)
	cBuffer  += "1"
	cBuffer  += Substr(Dtos(dDatabase),7,2)+Substr(Dtos(dDatabase),5,2)+Substr(Dtos(dDatabase),1,4)
	cBuffer  += Substr(Time(),1,2)+Substr(Time(),4,2)+Substr(Time(),7,2)
	cBuffer  += cSeqArqBS
	cBuffer  += "060"
	cBuffer  += "00000"
	cBuffer  += Space(69)+CHR(13)+CHR(10)

	FWRITE(nHdlSaida,cBuffer)

//Define o Header do Lote
	cBuffer  := SEE->EE_CODIGO
	cBuffer  += "0001"
	cBuffer  += "1"
	cBuffer  += "C"
	cBuffer  += "30" //Pagamentos de salarios
	cBuffer  += "01"
	cBuffer  += "043"
	cBuffer  += " "
	cBuffer  += "2"
	cBuffer  += SM0->M0_CGC
//If SM0->M0_CODIGO == "01"
	cBuffer  += SEE->EE_CONVFOL //"0000000000008       "
//   cBuffer  += "0000000000008       "
//Else 
//   cBuffer  += "0000000000013       "
//EndIf 
	cBuffer  += StrZero(Val(SEE->EE_AGENCIA),5) //"02589"
	cBuffer  += SEE->EE_DVAGE //"5"
//cBuffer  += "02589"
//cBuffer  += "5" 
//If SM0->M0_CODIGO == "01"
	cBuffer  += StrZero(Val(SEE->EE_CONTA),12)+SEE->EE_DVCTA //"0000000107042 "
	cBuffer  += " "
	cBuffer  += Substr(SM0->M0_NOMECOM,1,30) //"ISA INDUSTRIA DE EMBALAGENS LT"
	cBuffer  += Space(40)
//   cBuffer  += "0000000107042 "
//   cBuffer  += "ISA INDUSTRIA DE EMBALAGENS LT"   
//ElseIf SM0->M0_CODIGO == "02"
//   cBuffer  += "0000000154873 "
//   cBuffer  += "RECISA RECICLAGEM E LOGISTICA "
//EndIf 

	cEnd := Substr(SM0->M0_ENDCOB,1,30)
	If "," $ cEnd
		cEndRua := Substr(cEnd,1,At(",",cEnd)-1)
		cEndRua := Alltrim(cEndRua)+Space(30-Len(AllTrim(cEndRua)))
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

	cFilialAnt := Replicate("!", FWGETTAMFILIAL)

// Posiciona no Primeiro Selecionado no De/Ate
	dbSelectArea( "SRA" )

	#IFDEF TOP
		If TcSrvType() != "AS/400"
			cQuery := "SELECT COUNT(*) TOTAL "
			cQuery += "FROM " + RetSqlName("SRA")	+ " QSRA "
			cQuery += "WHERE RA_FILIAL	BETWEEN '" + cFilDe + "' AND '" + cFilAte + "' "
			cQuery += "AND RA_MAT     	BETWEEN '" + cMatDe + "' AND '" + cMatAte + "' "
			cQuery += "AND RA_NOME    	BETWEEN '" + cNomDe + "' AND '" + cNomAte + "' "
			cQuery += "AND RA_CC      	BETWEEN '" + cCcDe  + "' AND '" + cCcate  + "' "
		
			If nFunBenAmb == 1
				cQuery += "AND RA_BCDEPSA	BETWEEN '" + cBcoDe	+ "' AND '" + cBcoAte	+ "' "
				cQuery += "AND RA_CTDEPSA	BETWEEN '" + cCtaDe	+ "' AND '" + cCtaAte	+ "' "
			EndIf
		
			cQuery += "AND RA_CATFUNC 	IN (" + Upper(cCatQuery) + ") "
			cQuery += "AND RA_SITFOLH 	IN (" + Upper(cSitQuery) + ") "
			cQuery += "AND QSRA.D_E_L_E_T_ = ' ' "
		
			If lAdianta .Or. lFolha .Or. ( lPrimeira .And. !(cPaisLoc $ "URU|ARG") )
				cSRCExist += "( EXISTS ( SELECT RC_FILIAL, RC_MAT, RC_PD, RC_VALOR, RC_DATA "
				cSRCExist += "FROM " + cRCName + " QSRC "
				cSRCExist += "WHERE RC_FILIAL = RA_FILIAL "
				cSRCExist += "AND RC_MAT = RA_MAT "
				cSRCExist += "AND RC_DATA BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
			
				If lAdianta .Or. lPrimeira
					cSRCExist += "AND RC_SEMANA	= '" + Semana + "' "
				EndIf
			
				cSRCExist += "AND QSRC.D_E_L_E_T_= ' ' ) ) "
			EndIf
		
			If lSegunda .or. If(cPaisLoc $ "URU|ARG",lPrimeira,.F.)
				If !Empty(cSRCExist)
					cSRIExist += "OR "
				EndIf
			
				cSRIExist += "( EXISTS ( SELECT RI_FILIAL, RI_MAT, RI_PD, RI_VALOR, RI_DATA "
				cSRIExist += "FROM " + cRIName + " QSRI "
				cSRIExist += "WHERE RI_FILIAL = RA_FILIAL "
				cSRIExist += "AND RI_MAT = RA_MAT "
				cSRIExist += "AND RI_DATA BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
				cSRIExist += "AND QSRI.D_E_L_E_T_= ' ' ) ) "
			EndIf
		
			If lFerias
			
				fDtItens(.F.) //Retirar em futuras versoes
			
				If !Empty(cSRCExist) .Or. !Empty(cSRIExist)
					cSRHExist += "OR "
				EndIf
			
				cSRHExist += "( EXISTS ( SELECT SRR1.RR_FILIAL, SRR1.RR_MAT, SRR1.RR_PD, SRR1.RR_VALOR, SRR1.RR_DATA, QSRH.RH_DTRECIB "
				cSRHExist += "FROM "+ RetSqlName("SRR") + " SRR1 "
				cSRHExist += "INNER JOIN "+ RetSqlName("SRH") + " QSRH "
				cSRHExist += "ON ( SRR1.RR_FILIAL = RH_FILIAL "
				cSRHExist += "AND SRR1.RR_MAT = RH_MAT "
			
				If lDtItens
					cSRHExist 		+= "AND SRR1.RR_DATA = RH_DTITENS "
				Else
					cSRHExist 		+= "AND SRR1.RR_DATA = RH_DTRECIB "
				EndIf
			
				cSRHExist += "AND SRR1.D_E_L_E_T_ = QSRH.D_E_L_E_T_) "
				cSRHExist += "WHERE RH_FILIAL = RA_FILIAL "
				cSRHExist += "AND RH_MAT = RA_MAT "
				cSRHExist += "AND RH_DTRECIB BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
				cSRHExist += "AND QSRH.D_E_L_E_T_= ' ' ) ) "
			EndIf
		
			If lExtras
				If !Empty(cSRCExist) .Or. !Empty(cSRIExist) .Or. !Empty(cSRHExist)
					cSR1Exist += "OR "
				EndIf
			
				cSR1Exist += "( EXISTS ( SELECT R1_FILIAL, R1_MAT, R1_PD, R1_VALOR, R1_DATA "
				cSR1Exist += "FROM " + RetSqlName("SR1") + " QSR1 "
				cSR1Exist += "WHERE R1_FILIAL = RA_FILIAL "
				cSR1Exist += "AND R1_MAT = RA_MAT "
				cSR1Exist += "AND R1_DATA BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
				cSR1Exist += "AND R1_SEMANA	= '" + Semana + "' "
				cSR1Exist += "AND QSR1.D_E_L_E_T_= ' ' ) ) "
			EndIf
		
			If lRescisao
				If !Empty(cSRCExist) .Or. !Empty(cSRIExist) .Or. !Empty(cSRHExist) .Or. !Empty(cSR1Exist)
					cSRGExist += "OR "
				EndIf
			
				cSRGExist += "( EXISTS ( SELECT SRR2.RR_FILIAL, SRR2.RR_MAT, SRR2.RR_PD, SRR2.RR_VALOR, SRR2.RR_DATA, RG_DATAHOM "
				cSRGExist += "FROM "+ RetSqlName("SRR") + " SRR2 "
				cSRGExist += "INNER JOIN "+ RetSqlName("SRG") + " QSRG "
				cSRGExist += "ON ( SRR2.RR_FILIAL = RG_FILIAL "
				cSRGExist += "AND SRR2.RR_MAT = RG_MAT "
				cSRGExist += "AND SRR2.RR_DATAPAG = RG_DATAHOM "
				cSRGExist += "AND SRR2.D_E_L_E_T_ = QSRG.D_E_L_E_T_) "
				cSRGExist += "WHERE RG_FILIAL = RA_FILIAL "
				cSRGExist += "AND RG_MAT = RA_MAT "
				cSRGExist += "AND RG_DATAHOM BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
				cSRGExist += "AND QSRG.D_E_L_E_T_= ' ' ) ) "
			EndIf
		
			If !Empty(cSRCExist) .Or. !Empty(cSRIExist) .Or. !Empty(cSRHExist) .Or. !Empty(cSR1Exist) .Or. !Empty(cSRGExist)
				cQuery += "AND (" + cSRCExist + cSRIExist + cSRHExist + cSR1Exist + cSRGExist +")"
			EndIf
		Else
			cQuery := "SELECT COUNT(*) TOTAL "
			cQuery += "FROM "+	RetSqlName("SRA") + " "
			cQuery += "WHERE RA_FILIAL	>= '" + cFilDe + "' AND RA_FILIAL  <= '" + cFilAte + "' "
			cQuery += "AND RA_MAT     	>= '" + cMatDe + "' AND RA_MAT     <= '" + cMatAte + "' "
			cQuery += "AND RA_NOME    	>= '" + cNomDe + "' AND RA_NOME    <= '" + cNomAte + "' "
			cQuery += "AND RA_CC      	>= '" + cCcDe  + "' AND RA_CC      <= '" + cCcate  + "' "
		
			If nFunBenAmb == 1
				cQuery += "AND RA_BCDEPSA	>= '" + cBcoDe + "' AND RA_BCDEPSA <= '" + cBcoAte + "' "
				cQuery += "AND RA_CTDEPSA	>= '" + cCtaDe + "' AND RA_CTDEPSA <= '" + cCtaAte + "' "
			EndIf
		
			cQuery += "AND @DELETED@ = ' ' "
		Endif
	
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)
		dbSelectArea("QUERY")
		nTotalQ := QUERY->TOTAL
		ProcRegua(nTotalQ)		// Total de Elementos da regua
		Query->( dbCloseArea() )
		dbSelectArea("SRA")
	
		cSRCExist := cSRIExist := cSRHExist := cSR1Exist := cSRGExist := ""
	
		If TcSrvType() != "AS/400"
			cQuery := "SELECT * "
			cQuery += "FROM " + RetSqlName("SRA") + " QSRA "
			cQuery += "WHERE RA_FILIAL	BETWEEN '" + cFilDe + "' AND '" + cFilAte + "' "
			cQuery += "AND RA_MAT     	BETWEEN '" + cMatDe + "' AND '" + cMatAte + "' "
			cQuery += "AND RA_NOME    	BETWEEN '" + cNomDe + "' AND '" + cNomAte + "' "
			cQuery += "AND RA_CC      	BETWEEN '" + cCcDe  + "' AND '" + cCcate  + "' "
		
			If nFunBenAmb == 1
				cQuery += "AND RA_BCDEPSA	BETWEEN '" + cBcoDe	+ "' AND '" + cBcoAte	+ "' "
				cQuery += "AND RA_CTDEPSA	BETWEEN '" + cCtaDe	+ "' AND '" + cCtaAte	+ "' "
			EndIf
		
			cQuery += "AND RA_CATFUNC 	IN (" + Upper(cCatQuery) + ") "
			cQuery += "AND RA_SITFOLH 	IN (" + Upper(cSitQuery) + ") "
			cQuery += "AND QSRA.D_E_L_E_T_ = ' ' "
		
			If lAdianta .Or. lFolha .Or. ( lPrimeira .And. !(cPaisLoc $ "URU|ARG") )
				cSRCExist += "( EXISTS ( SELECT RC_FILIAL, RC_MAT, RC_PD, RC_VALOR, RC_DATA "
				cSRCExist += "FROM " + cRCName + " QSRC "
				cSRCExist += "WHERE RC_FILIAL = RA_FILIAL "
				cSRCExist += "AND RC_MAT = RA_MAT  "
				cSRCExist += "AND RC_DATA BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
			
				If lAdianta .Or. lPrimeira
					cSRCExist += "AND RC_SEMANA	= '" + Semana + "' "
				EndIf
			
				cSRCExist += "AND QSRC.D_E_L_E_T_= ' ' ) ) "
			EndIf
		
			If lSegunda .or. If(cPaisLoc $ "URU|ARG",lPrimeira,.F.)
				If !Empty(cSRCExist)
					cSRIExist += "OR "
				EndIf
			
				cSRIExist += "( EXISTS ( SELECT RI_FILIAL, RI_MAT, RI_PD, RI_VALOR, RI_DATA "
				cSRIExist += "FROM " + cRIName + " QSRI "
				cSRIExist += "WHERE RI_FILIAL = RA_FILIAL "
				cSRIExist += "AND RI_MAT = RA_MAT "
				cSRIExist += "AND RI_DATA BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
				cSRIExist += "AND QSRI.D_E_L_E_T_= ' ' ) ) "
			EndIf
		
			If lFerias
			
				fDtItens(.F.) //Retirar em futuras versoes
			
				If !Empty(cSRCExist) .Or. !Empty(cSRIExist)
					cSRHExist += "OR "
				EndIf
			
				cSRHExist += "( EXISTS ( SELECT SRR1.RR_FILIAL, SRR1.RR_MAT, SRR1.RR_PD, SRR1.RR_VALOR, SRR1.RR_DATA, QSRH.RH_DTRECIB "
				cSRHExist += "FROM "+ RetSqlName("SRR") + " SRR1 "
				cSRHExist += "INNER JOIN "+ RetSqlName("SRH") + " QSRH "
				cSRHExist += "ON ( SRR1.RR_FILIAL = RH_FILIAL "
				cSRHExist += "AND SRR1.RR_MAT = RH_MAT "
			
				If lDtItens
					cSRHExist 		+= "AND SRR1.RR_DATA = RH_DTITENS "
				Else
					cSRHExist 		+= "AND SRR1.RR_DATA = RH_DTRECIB "
				EndIf
			
				cSRHExist += "AND SRR1.D_E_L_E_T_ = QSRH.D_E_L_E_T_) "
				cSRHExist += "WHERE RH_FILIAL = RA_FILIAL "
				cSRHExist += "AND RH_MAT = RA_MAT "
				cSRHExist += "AND RH_DTRECIB BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
				cSRHExist += "AND QSRH.D_E_L_E_T_= ' ' ) ) "
			EndIf
		
			If lExtras
				If !Empty(cSRCExist) .Or. !Empty(cSRIExist) .Or. !Empty(cSRHExist)
					cSR1Exist += "OR "
				EndIf
			
				cSR1Exist += "( EXISTS ( SELECT R1_FILIAL, R1_MAT, R1_PD, R1_VALOR, R1_DATA "
				cSR1Exist += "FROM " + RetSqlName("SR1") + " QSR1 "
				cSR1Exist += "WHERE R1_FILIAL = RA_FILIAL "
				cSR1Exist += "AND R1_MAT = RA_MAT "
				cSR1Exist += "AND R1_DATA BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
				cSR1Exist += "AND R1_SEMANA	= '" + Semana + "' "
				cSR1Exist += "AND QSR1.D_E_L_E_T_= ' ' ) ) "
			EndIf
		
			If lRescisao
				If !Empty(cSRCExist) .Or. !Empty(cSRIExist) .Or. !Empty(cSRHExist) .Or. !Empty(cSR1Exist)
					cSRGExist += "OR "
				EndIf
			
				cSRGExist += "( EXISTS ( SELECT SRR2.RR_FILIAL, SRR2.RR_MAT, SRR2.RR_PD, SRR2.RR_VALOR, SRR2.RR_DATA, RG_DATAHOM "
				cSRGExist += "FROM "+ RetSqlName("SRR") + " SRR2 "
				cSRGExist += "INNER JOIN "+ RetSqlName("SRG") + " QSRG "
				cSRGExist += "ON ( SRR2.RR_FILIAL = RG_FILIAL "
				cSRGExist += "AND SRR2.RR_MAT = RG_MAT "
				cSRGExist += "AND SRR2.RR_DATAPAG = RG_DATAHOM "
				cSRGExist += "AND SRR2.D_E_L_E_T_ = QSRG.D_E_L_E_T_) "
				cSRGExist += "WHERE RG_FILIAL = RA_FILIAL "
				cSRGExist += "AND RG_MAT = RA_MAT "
				cSRGExist += "AND RG_DATAHOM BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
				cSRGExist += "AND QSRG.D_E_L_E_T_= ' ' ) ) "
			EndIf
		
			If !Empty(cSRCExist) .Or. !Empty(cSRIExist) .Or. !Empty(cSRHExist) .Or. !Empty(cSR1Exist) .Or. !Empty(cSRGExist)
				cQuery += "AND (" + cSRCExist + cSRIExist + cSRHExist + cSR1Exist + cSRGExist +")"
			EndIf
		Else
			cQuery := "SELECT * "
			cQuery += "FROM "+	RetSqlName("SRA") + " "
			cQuery += "WHERE RA_FILIAL	>= '" + cFilDe + "' AND RA_FILIAL  <= '" + cFilAte + "' "
			cQuery += "AND RA_MAT     	>= '" + cMatDe + "' AND RA_MAT     <= '" + cMatAte + "' "
			cQuery += "AND RA_NOME    	>= '" + cNomDe + "' AND RA_NOME    <= '" + cNomAte + "' "
			cQuery += "AND RA_CC      	>= '" + cCcDe  + "' AND RA_CC      <= '" + cCcate  + "' "
		
			If nFunBenAmb == 1
				cQuery += "AND RA_BCDEPSA	>= '" + cBcoDe + "' AND RA_BCDEPSA <= '" + cBcoAte + "' "
				cQuery += "AND RA_CTDEPSA	>= '" + cCtaDe + "' AND RA_CTDEPSA <= '" + cCtaAte + "' "
			EndIf
		
			cQuery += "AND @DELETED@ = ' ' "
		Endif
	
		cQuery   += " ORDER BY RA_FILIAL, RA_MAT"
	
		aStruSRA := SRA->(dbStruct())
		SRA->( dbCloseArea() )
	
		cQuery	:= ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSRA, .F., .T.)
	
		For nX := 1 To Len(aStruSRA)
			If ( aStruSRA[nX][2] <> "C" )
				TcSetField(cAliasSRA,aStruSRA[nX][1],aStruSRA[nX][2],aStruSRA[nX][3],aStruSRA[nX][4])
			EndIf
		Next nX
	#ELSE
		dbSetOrder(1)
		dbSeek( cFilDe + cMatDe , .T. )
	#ENDIF

	While !SRA->( Eof() ) .And. SRA->RA_FILIAL + SRA->RA_MAT <= cFilAte + cMatAte
	//�����������������������������������������������������������Ŀ
	//� Movimenta Cursor                                          �
	//�������������������������������������������������������������
		IncProc("Liquido em Disquete ") //
	
		nValor    := 0
		aValBenef := {}
	
		If SRA->RA_FILIAL # cFilialAnt
			If !Fp_CodFol(@aCodFol,SRA->RA_FILIAL)
				Exit
			Endif
			cFilialAnt := SRA->RA_FILIAL
		Endif
	
		If lSelFunc
	
			If SELFUNC->(DbSeek(Substr(SRA->RA_NOME,1,40)))
	   
				If Empty(SELFUNC->OK)
					SRA->(dbSkip(1))
					Loop
				EndIf
	      
			EndIf
		EndIf
	
		#IFNDEF TOP
		//��������������������������������������������������������������Ŀ
		//� Consiste Parametrizacao do Intervalo de Impressao            �
		//����������������������������������������������������������������
			If  (SRA->RA_NOME    < cNomDe) .Or. (SRA->RA_NOME    > cNomAte) .Or. ;
					(SRA->RA_MAT     < cMatDe) .Or. (SRA->RA_MAT     > cMatAte) .Or. ;
					(SRA->RA_CC      < cCcDe)  .Or. (SRA->RA_CC      > cCcate)
				SRA->(dbSkip(1))
				Loop
			EndIf
		#ENDIF
	
	//��������������������������������������������������������������Ŀ
	//� Busca os valores de Liquido e Pensao                         �
	//����������������������������������������������������������������
		fBuscaLiq(@nValor,@aValBenef,aCodFol,,,dDataRef, cRCName, cRIName)
	
	//��������������������������������������������������������������Ŀ
	//� Ponto de Entrada para despresar funcionario caso retorne .F. �
	//����������������������������������������������������������������
		If ExistBlock("GP450DES")
			If !(ExecBlock("GP450DES",.F.,.F.))
				dbSelectArea( "SRA" )
				SRA->(dbSkip(1))
				Loop
			EndIf
		EndIf
	
		#IFDEF TOP
			If nFunBenAmb # 1
			//��������������������������������������������������������������Ŀ
			//� Consiste parametros de banco e conta do funcionario			 �
			//����������������������������������������������������������������
				If (SRA->RA_BCDEPSA < cBcoDe) .Or. (SRA->RA_BCDEPSA > cBcoAte) .Or.;
						(SRA->RA_CTDEPSA < cCtaDe) .Or. (SRA->RA_CTDEPSA > cCtaAte)
					nValor := 0
				EndIf
			EndIf
		#ELSE
		//��������������������������������������������������������������Ŀ
		//� Consiste parametros de banco e conta do funcionario			 �
		//����������������������������������������������������������������
			If (SRA->RA_BCDEPSA < cBcoDe) .Or. (SRA->RA_BCDEPSA > cBcoAte) .Or.;
					(SRA->RA_CTDEPSA < cCtaDe) .Or. (SRA->RA_CTDEPSA > cCtaAte)
				nValor := 0
			EndIf
		#ENDIF
	
	//��������������������������������������������������������������Ŀ
	//� Consiste parametros de banco e conta do beneficiario 		 �
	//� aValBenef: 1-Nome  2-Banco  3-Conta  4-Verba  5-Valor  6-CPF �
	//����������������������������������������������������������������
		If Len(aValBenef) > 0
			aBenefCop  := ACLONE(aValBenef)
			aValBenef  := {}
			Aeval(aBenefCop, { |X| If( ( X[2] >= cBcoDe .And. X[2] <= cBcoAte) .And.;
				( X[3] >= cCtaDe .And. X[3] <= cCtaAte),;
				AADD(aValBenef, X), "" ) })
		EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Testa Situacao do Funcionario na Folha                       �
	//� Testa Categoria do Funcionario na Folha                      �
	//� Testa se Valor == 0                                          �
	//����������������������������������������������������������������
		If !( SRA->RA_SITFOLH $ cSituacao ) .Or. !(SRA->RA_CATFUNC $ cCategoria) .Or.;
				( nValor == 0 .And. Len(aValBenef) == 0 )
			dbSelectArea( "SRA" )
			dbSkip()
			Loop
		Endif
	
	//��������������������������������������������������������������Ŀ
	//� Inclui o funcionario no array para inclusao no arquivo		 �
	//����������������������������������������������������������������
		If lImprFunci
			Aadd(aValBenef, {  SRA->RA_NOME, SRA->RA_BCDEPSA, StrTran(SRA->RA_CTDEPSA,"-"," "), "", nValor,SRA->RA_CIC,SRA->RA_DGCONTA } )
		EndIf
	
		For nCntP := 1 To Len(aValBenef)
		
			cNome  := aValBenef[nCntP,1]
			cBanco := aValBenef[nCntP,2]
			cConta := aValBenef[nCntP,3]
			cCPF   := aValBenef[nCntP,6]
			cDgConta := aValBenef[nCntP,7]
		//��������������������������������������������������������������Ŀ
		//� Verifica valor e banco/agencia dos beneficiarios			 �
		//����������������������������������������������������������������
			If aValBenef[nCntP,5] == 0 .Or. Empty(cBanco) .Or. cBanco < cBcoDe .Or. cBanco > cBcoAte
				Loop
			EndIf
		
		//��������������������������������������������������������������Ŀ
		//� Iguala nas Variaveis Usadas do arquivo de cadastramento      �
		//����������������������������������������������������������������
			nValor := NoRound(aValBenef[nCntP,5] * 100,0)
		
			nTotal += nValor
			nTotFunc ++
		
		//������������������������������������������������������������Ŀ
		//� Grava as linhas de detalhe de acordo com o tipo do bordero �
		//��������������������������������������������������������������
		
			cBuffer := SEE->EE_CODIGO
			cBuffer += "0001"
			cBuffer += "3"
			cBuffer += StrZero(nSeq,5)
			cBuffer += "A"
			cBuffer += "000"
			cBuffer += "000"
			cBuffer += SUBS(cBanco,1,3)
			cBuffer += "0"
			cBuffer += StrZero(Val(SUBS(cBanco,4,4)),4)
			cBuffer += " " //cDigAg
			If ! "X" $ cConta
				cBuffer += StrZero(Val(cConta),12)
			Else
				cBuffer += StrZero(Val(Substr(cConta,1,At("X",cConta)-1)),12)
				cBuffer += "X"
			EndIf
			cBuffer += cDgConta
			cBuffer += " "
			cBuffer += cNome
			cBuffer += SRA->RA_FILIAL+SRA->RA_MAT+" "+Space(19-Len(Alltrim(SRA->RA_FILIAL+SRA->RA_MAT)))
			cBuffer += Substr(DTOS(DDATAPGTO),7,2)+Substr(DTOS(DDATAPGTO),5,2)+Substr(DTOS(DDATAPGTO),1,4)
			cBuffer += "BRL"
			cBuffer += Replicate("0",15)
			cBuffer += StrZero(NVALOR,15)
			cBuffer += Space(20)
			cBuffer += Replicate("0",8)
			cBuffer += Replicate("0",15)
			cBuffer += Space(40)
			cBuffer += Space(12)
			cBuffer += "0"
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
		xFerias() //@dDataIni, @dDataFim)
		
		findlanc(@aVerbas, @nSalContrib, @nValFgts, @nTotCre, @nTotDeb, @nLiqMes, @vSalBase, @vBaseIR, @vBaseFgts)
		
		
		if ( lFolha .Or. lSegunda )  .and. len(aVerbas)>0 // So gera as linhas do comprovante de pagamento se  "Folha de Pagamento" = SIM
			Fa450Linha( cDetaH ,@cLocaBco,@cLocaPro)  // Base
			
			For nContVerba:=1 to len(aVerbas)
				nSeq++
				Fa450Linha( cDetaJ ,@cLocaBco,@cLocaPro)  // Verbas
			Next nContVerba
			
			nSeq++
		Endif */
		
		Next nCntP
	
		dbSelectArea( "SRA" )
		dbSkip()
	
	Enddo

//��������������������������������������������������������������Ŀ
//� Grava os traillers de lote e de arquivo                      �
//����������������������������������������������������������������

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


//fa450linha(cTraiLote)
//fa450linha(cTraiArq)

//��������������������������������������������������������������Ŀ
//� Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      �
//����������������������������������������������������������������
	If !Empty( cAliasMov )
		fFimArqMov( cAliasMov , aOrdBag , cArqMov )
	EndIf

	If !Empty( cAliasRI )
		fFimArqMov( cAliasRI , aOrdBagRI , cArqMovRI )
	EndIf

	dbSelectArea("SRA")
	dbCloseArea()
	ChkFile("SRA")

//��������������������������������������������������������������Ŀ
//� Termino do Programa                                          �
//����������������������������������������������������������������
	fClose( nHdlSaida )
	fClose( nHdlBco )

	PutMV( "MV_SEQBS", cSeqArqBS )

/*
DbSelectArea("SX6")
DbSeek("  MV_SEQBS")
RecLock("SX6",.F.)
SX6->X6_CONTEUD := cSeqArqBS 
MsUnlock() */                    

	If lSelFunc

		SelFunc->(DbCloseArea())
   
	EndIf

	dbSelectArea("SRC")
	dbSetOrder(1)
	dbSelectArea("SRI")
	dbSetOrder(1)
	dbSelectArea("SRA")
	dbSetOrder(1)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �AbrePar   � Autor � Wagner Xavier         � Data � 11/11/96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Abre arquivo de Parametros                                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �AbrePar()                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �GPEM450()                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
Static Function AbrePar()

//����������������������������������������������������������Ŀ
//� Cria Arquivo Saida                                       �
//������������������������������������������������������������
	nHdlSaida:=MSFCREATE(cArqSaida,0)

Return .T.


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fA450Grava� Autor �                       � Data � 11.11.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de Gera��o do Arquivo de Remessa de Comunica��o      ���
���          �Banc�ria p/ Contas a Receber                                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �ExpL1 := fa450Grava(ExpN1,ExpN2,ExpC1)                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GPEM450()                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
Static Function fA450Grava( nTam,nDec,cConteudo )
	Local lConteudo := .T., cCampo

	While .T.
	//����������������������������������������������������������Ŀ
	//� Analisa conte�do                                         �
	//������������������������������������������������������������
		If Empty(cConteudo)
			cCampo := Space(nTam)
		Else
			lConteudo := fa150Orig( cConteudo )
			If !lConteudo
				Exit
			Else
				If ValType(xConteudo)="D"
					cCampo := GravaData(xConteudo,.F.)
				Elseif ValType(xConteudo)="N"
					cCampo := Substr(Strzero(xConteudo,nTam,nDec),1,nTam)
				Else
					cCampo := Substr(xConteudo,1,nTam)
				Endif
			Endif
		Endif
		If Len(cCampo) < nTam  //Preenche campo a ser gravado, caso menor
			cCampo := cCampo+Space(nTam-Len(cCampo))
		Endif
		Fwrite( nHdlSaida,cCampo,nTam )
		Exit
	End
Return lConteudo

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fa150Orig � Autor � Wagner Xavier         � Data � 11/11/96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica se expressao e' valida para Remessa CNAB.          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GPEM450()                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
Static Function fa150Orig( cForm )
	Local bBlock:=ErrorBlock(),bErro := ErrorBlock( { |e| ChecErr260(e,cForm) } )
	Private lRet := .T.

	BEGIN SEQUENCE
		xConteudo := &cForm
	END SEQUENCE
	ErrorBlock(bBlock)
Return lRet






/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPEX450   �Autor  �Microsiga           � Data �  11/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static function findlanc(aVerbas, nSalContrib, nValFgts, nTotCre, nTotDeb, nLiqMes, vSalBase, vBaseIR, vBaseFgts)
	Private cMat   := SRA->RA_MAT
	Private cFil   := SRA->RA_FILIAL
	Private nTotReg:= 0
	Private nTotCre:= 0
	Private nTotDeb:= 0
	Private acodVer:= STRTOKARR(getmv("MV_VERBFOL"),",")

	aVerbas := {}


	If lSegunda
	
		BeginSQL Alias "zQRY"
		
			Column RI_VALOR as numeric(12,2)
			Column RI_HORAS as numeric(4,1)
			Column RI_DATA as date
		
			%NoParser%
		
			select
			substring(RI_DATA,5,2)+substring(RI_DATA,1,4) MESANO,
			RI_MAT, RI_CC, RV_TIPOCOD, RI_TIPO2, RV_COD, RV_DESC, RI_HORAS, RI_TIPO1, RI_VALOR, RI_DATA
			from %table:SRI% SRI
			join %table:SRV% SRV on
			SRV.%notDel% and
			RV_FILIAL=%xfilial:SRV% and
			RV_COD=RI_PD
			where SRI.%notDel% and RI_MAT=%exp:cMat% and RI_FILIAL=%exp:cFil%
			order by substring(RI_DATA,5,2)+substring(RI_DATA,1,4), RI_MAT, RI_CC, RV_TIPOCOD
		
		EndSQL
	
		zQRY->(dbEval({||nTotREG++}))
		zQRY->(dbGoTop())
	
	
		While !zQRY->(Eof())
		
			If ( zQRY->RV_TIPOCOD $ "1,2" )    // Proventos e Descontos
			
				zQRY->( Aadd( aVerbas, { MESANO, RI_MAT, RI_CC, RV_TIPOCOD, RI_TIPO2, RV_COD, RV_DESC, RI_HORAS, RI_TIPO1, RI_VALOR, RI_DATA  } ) )
			
				If zQRY->RV_TIPOCOD == "1"
					nTotCre:=nTotCre+zQRY->RI_VALOR
				Else
					nTotDeb:=nTotDeb+zQRY->RI_VALOR
				Endif
			
			Elseif ( zQRY->RV_TIPOCOD == "3" ) // Base
			
				If alltrim(zQRY->RV_COD)==acodVer[1] 	//INSS
					nSalContrib:= zQRY->RI_VALOR
				ElseIf alltrim(zQRY->RV_COD)==acodVer[2] //FGTS a Recolher
					nValFgts   := zQRY->RI_VALOR
				ElseIf alltrim(zQRY->RV_COD)==acodVer[3] //Liquido a Receber
					nLiqMes    := zQRY->RI_VALOR
				ElseIf alltrim(zQRY->RV_COD)==acodVer[4] //Salario Mes
					vSalBase   := zQRY->RI_VALOR
				ElseIf alltrim(zQRY->RV_COD)==acodVer[5]  // Base IR
					vBaseIR	   := zQRY->RI_VALOR
				ElseIf alltrim(zQRY->RV_COD)==acodVer[6]  //Base FGTS a Recolher
					vBaseFgts  := zQRY->RI_VALOR
				Endif
			
			EndIf
		
			zQRY->(dbSkip())
		EndDo
	
	
		zQRY->(DbCloseArea())
	
	
	Else
	
		BeginSQL Alias "zQRY"
		
			Column RC_VALOR as numeric(12,2)
			Column RC_HORAS as numeric(4,1)
			Column EC_DATA as date
		
			%NoParser%
		
			select
			substring(RC_DATA,5,2)+substring(RC_DATA,1,4) MESANO,
			RC_MAT, RC_CC, RV_TIPOCOD, RC_TIPO2, RV_COD, RV_DESC, RC_HORAS, RC_TIPO1, RC_VALOR, RC_DATA
			from %table:SRC% SRC
			join %table:SRV% SRV on
			SRV.%notDel% and
			RV_FILIAL=%xfilial:SRV% and
			RV_COD=RC_PD
			where SRC.%notDel% and RC_MAT=%exp:cMat% and RC_FILIAL=%exp:cFil%
			order by substring(RC_DATA,5,2)+substring(RC_DATA,1,4), RC_MAT, RC_CC, RV_TIPOCOD
		
		EndSQL
	
		zQRY->(dbEval({||nTotREG++}))
		zQRY->(dbGoTop())
	
	
		While !zQRY->(Eof())
		
			If ( zQRY->RV_TIPOCOD $ "1,2" )    // Proventos e Descontos
			
				zQRY->( Aadd( aVerbas, { MESANO, RC_MAT, RC_CC, RV_TIPOCOD, RC_TIPO2, RV_COD, RV_DESC, RC_HORAS, RC_TIPO1, RC_VALOR, RC_DATA  } ) )
			
				If zQRY->RV_TIPOCOD == "1"
					nTotCre:=nTotCre+zQRY->RC_VALOR
				Else
					nTotDeb:=nTotDeb+zQRY->RC_VALOR
				Endif
			
			Elseif ( zQRY->RV_TIPOCOD == "3" ) // Base
			
				If alltrim(zQRY->RV_COD)==acodVer[1] 	//INSS
					nSalContrib:= zQRY->RC_VALOR
				ElseIf alltrim(zQRY->RV_COD)==acodVer[2] //FGTS a Recolher
					nValFgts   := zQRY->RC_VALOR
				ElseIf alltrim(zQRY->RV_COD)==acodVer[3] //Liquido a Receber
					nLiqMes    := zQRY->RC_VALOR
				ElseIf alltrim(zQRY->RV_COD)==acodVer[4] //Salario Mes
					vSalBase   := zQRY->RC_VALOR
				ElseIf alltrim(zQRY->RV_COD)==acodVer[5]  // Base IR
					vBaseIR	   := zQRY->RC_VALOR
				ElseIf alltrim(zQRY->RV_COD)==acodVer[6]  //Base FGTS a Recolher
					vBaseFgts  := zQRY->RC_VALOR
				Endif
			
			EndIf
		
			zQRY->(dbSkip())
		EndDo
	
	
		zQRY->(DbCloseArea())
	
	EndIf

Return

Static Function XFERIAS() //dDataIni, dDataFim)
	Private cMat   := SRA->RA_MAT
	dDataIni :=STOD("")
	dDataFim :=STOD("")


	BeginSQL Alias "vQRY"
	
		Column RF_DATABAS as date
		Column RF_DATAFIM as date
	
		select top (1) RF_MAT, RF_DATABAS, convert(varchar,(dateadd(day,-1,dateadd(year,1,convert(date,RF_DATABAS)))),112)  RF_DATAFIM
		from  %table:SRF% SRF
		where SRF.%notdel%  and RF_MAT=%exp:cMat% and RF_FILIAL=%xfilial:SRF%
		order by RF_DATABAS desc
	
	EndSQL


	if !vQRY->(Eof())
		dDataIni:=vQRY->RF_DATABAS
		dDataFim:=vQRY->RF_DATAFIM
	endif

	vQRY->(DbCloseArea())

Return


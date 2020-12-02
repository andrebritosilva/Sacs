#Include "PROTHEUS.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ Ctbr280  ³ Autor ³ Claudio Donizete      ³ Data ³ 20.12.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rela‡ao de Movimentos Acumulados p/ CC Extra               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctbr280()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PCTBR280()
	Local Wnrel
	LOCAL cString:="CTT"
	LOCAL cDesc1:= OemToAnsi("Este programa ir  imprimir a rela‡„o de Movimentos ")                                             //
	LOCAL cDesc2:= OemToAnsi("Acumulados por ")+RetTitle("CQ3_CUSTO",15)+OemToAnsi(" Extra Cont bil das con-")  //###
	LOCAL cDesc3:= OemToAnsi("tas determinadas pelo usu rio.")  //
	LOCAL tamanho:="G"
	Local titulo :=OemToAnsi("Relacao de Movimentos Acumulados para CC Extra - Exercicio ")  //
	Local aSetOfBook

	PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }  //###
	PRIVATE nomeprog:="PCTBR280"
	PRIVATE aLinha  := { },nLastKey := 0
	PRIVATE cPerg   :="PCTR280"
	PRIVATE aOrd    := {}

	aTamFil := TamSX3("CT1_FILIAL")

	Private  aRegs := {}

	aAdd(aRegs,{cPerg,"01","Data   de          ?","","","mv_ch1","D"   ,08 ,00      ,0   ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Data  Ate          ?","","","mv_ch2","D"   ,08 ,00      ,0   ,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","CC Inicial de      ?","","","mv_ch3","C"   ,09 ,00      ,0   ,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
	aAdd(aRegs,{cPerg,"04","CC Final Ate       ?","","","mv_ch4","C"   ,09 ,00      ,0   ,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
	aAdd(aRegs,{cPerg,"05","Conta Inicial de   ?","","","mv_ch5","C"   ,20 ,00      ,0   ,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CT1",""})
	aAdd(aRegs,{cPerg,"06","Conta Final Ate    ?","","","mv_ch6","C"   ,20 ,00      ,0   ,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CT1",""})

	aAdd(aRegs,{cPerg,"07","Saldos Zerados     ?","","","mv_ch7","N"  , 01   ,0     ,1   ,"C","" ,"mv_par07","Sim"  ,"","","","","Nao","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPerg,"08","Filial de         ?","","","mv_ch8","C"   , aTamFil[2] ,00      ,0   ,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"09","Filial Ate        ?","","","mv_ch9","C"   , aTamFil[2] ,00      ,0   ,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	U_ValidPerg(cPerg,aRegs)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	pergunte("PCTR280",.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel:="PCTBR280"            //Nome Default do relatorio em Disco
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)
	//wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

	If nLastKey == 27
		Set Filter To
		Return
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
	//³ Gerencial -> montagem especifica para impressao)				  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//If !ct040Valid(mv_par10)
	//	Set Filter To
	//	Return
	//EndIf
	aSetOfBook := CTBSetOf(mv_par10)

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Set Filter To
		Return
	Endif

	RptStatus({|lEnd| Ct280Imp(@lEnd,wnRel,cString,Tamanho,Titulo,aSetOfBook)})

Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡ao    ³ Ct280Imp ³ Autor ³ Claudio Donizete      ³ Data ³ 20/12/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Impressao Relacao Movimento Mensal                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ Ct280Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ lEnd    - Acao do Codeblock                                ³±±
±±³           ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³           ³ cString - Mensagem                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ct280Imp(lEnd,WnRel,cString,Tamanho,Titulo, aSetOfBook)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LOCAL CbTxt
	LOCAL Cbcont
	LOCAL limite := 220
	Local lImpCC := .T., lImpConta := .T.
	Local nDecimais := 2
	Local cabec1 := OemToAnsi("Codigo Cod Custo     Descricao             ")
	Local cabec2 := OemToAnsi("Codigo da Conta      Descricao            ")

	Local cCtt_Custo
	Local aCtbMoeda := {}
	Local aPeriodos
	Local aSaldos
	Local cMascConta
	Local cMascCus
	Local cSepConta := ""
	Local cSepCus   := ""
	Local cPicture
	Local nX
	Local aTotalCC
	Local aTotalGeral
	Local nCol
	Local nTotais
	Local cCodRes
	Local cCodResCC
	Local cChave
	Local nRecCC := 0
	Local cAliasAnt := ""
	Local lFirst	:= .T.
	Local cMensagem	:= ""
	Local aMeses	:= {}
	Local nCont		:= 1
	Local nMeses	:= 0
	Local nPos		:= 0
	Local nDigitos	:= 0
	Local lComSaldo	:= .F.

	#IFDEF TOP
	Local lAs400	:= Upper(TcGetDb()) == "AS/400"
	#ENDIF

	nDecimais 	:= DecimalCTB(aSetOfBook,"01")

	If Empty(aSetOfBook[2])
		cMascConta := GetMv("MV_MASCARA")
		cMascCus	  := GetMv("MV_MASCCUS")
	Else
		cMascConta := RetMasCtb(aSetOfBook[2],@cSepConta)
		cMascCus   := RetMasCtb(aSetofBook[6],@cSepCus)
	EndIf
	cPicture 	:= aSetOfBook[4]

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cbtxt    := SPACE(10)
	cbcont   := 0
	li       := 80
	m_pag    := 1

	cMoeda := "01"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza centro de custo inicial                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CTT")
	dbSetOrder(1)
	dbSeek( xFilial("CTT")+mv_par03,.T. )

	SetRegua(Reccount())

	// Localiza o periodo contabil para os calendarios da moeda 
	aPeriodos := ctbPeriodos("01", mv_par01, mv_par02, .T., .F.)
	If Empty(aPeriodos[1][1])

		cMensagem	:= "Por favor, verifique se o calend.contabil e a amarracao moeda/calendario "
		cMensagem	+= "foram cadastrados corretamente..."
		MsgInfo(cMensagem)
		Return

	EndIf

	For nCont := 1 to len(aPeriodos)       
		//Se a Data do periodo eh maior ou igual a data inicial solicitada no relatorio.
		If aPeriodos[nCont][1] >= mv_par01 .And. aPeriodos[nCont][2] <= mv_par02 
			AADD(aMeses,{StrZero(nMeses,2),aPeriodos[nCont][1],aPeriodos[nCont][2]})	
			nMeses += 1           					
		Else
			AADD(aMeses,{"  ",ctod("  /  /  "),ctod("  /  /  ")})
		EndIf
	Next     

	aTotalCC  := Array(Len(aPeriodos))
	aTotalGeral := Array(Len(aPeriodos)) 
	aFill(aTotalGeral,0) 			// Zera o totalizador geral
	Titulo += " " + aPeriodos[1][3] // Adiciona o exercicio ao titulo

	Titulo += " ("+ DTOC(mv_par01)+" - "+DTOC(mv_par02) +") "

	For nX := 1 To Len(aPeriodos)           
		Cabec1 += Padl("Ate ",13) + "  "
		Cabec2 += Padl(Dtoc(aPeriodos[nX][2]),13) + "  "
		/*	If nX >= 13
		Cabec2 += Padl("Ate " + Dtoc(aPeriodos[nX][2]),15) + "  "
		Else	
		Cabec1 += Padl("Ate " + Dtoc(aPeriodos[nX][2]),15) + "  "
		Endif	
		*/
	Next

	cAliasCT1 := "CT1"
	cAliasCTT := "CTT"

	#IFDEF TOP
	If !lAs400

		MsAguarde({|| U_CTR280Qry(aMeses,    "01","1",mv_par05,mv_par06,mv_par03,mv_par04,aSetOfBook,mv_par07 == 1,cString,aReturn[7],.F./*lImpAntLP*/,/*dDataLP*/) }, "Relacao de Movimentos Acumulados para CC Extra, Exercicio - " )
		cAliasCT1 := "TRBTMP"
		cAliasCTT := "TRBTMP"
	Else
		// Processa o arquivo de centro de custos, dentro dos parametros do usuario
		dbSelectArea(cAliasCTT)
		dbSetOrder(1)
	Endif
	#ELSE
	// Processa o arquivo de centro de custos, dentro dos parametros do usuario
	dbSelectArea(cAliasCTT)
	dbSetOrder(1)
	#ENDIF                    
	//DbSelectArea(cAliasCTT)
	While (cAliasCTT)->(!Eof()) .And. (cAliasCTT)->CTT_FILIAL==xFilial("CTT") .And. (cAliasCTT)->CTT_CUSTO <= mv_par04

		If !Empty(aReturn[7])
			If !&(aReturn[7])
				dbSkip()
				Loop
			EndIf
		EndIf	
		IncRegua()	
		// Guarda o centro de custo para ser utilizado na quebra	
		cCtt_Custo 	:= (cAliasCTT)->CTT_CUSTO
		cCodResCC	:= (cAliasCTT)->CTT_RES
		lImpCC     	:= .T.
		aFill(aTotalCC,0) 			// Zera o totalizador por periodo


		************************* ROTINA DE IMPRESSAO *************************

		If lAs400
			If (cAliasCTT)->CTT_CLASSE == "1"		// Sintetica
				(cAliasCTT)->(DbSkip())
				Loop
			Endif

			// Localiza os saldos do centro de custo
			dbSelectArea(cAliasCT1)
			dbSetOrder(1)			 	// Filial+Custo+Conta+Moeda
			dbSeek(xFilial("CT1")+mv_par05, .T.)
		Endif

		// Obtem os saldos do centro de custo
		While !Eof() .And. (cAliasCT1)->CT1_FILIAL == xFilial("CT1") .And. (cAliasCTT)->CTT_CUSTO == cCtt_Custo .And. (cAliasCT1)->CT1_CONTA <= mv_par06

			If !Empty(aReturn[7])
				If !&(aReturn[7])
					dbSkip()
					Loop
				EndIf
			EndIf

			lImpConta 	:= .T.
			cCQ3_Conta  := (cAliasCT1)->CT1_CONTA //CT3->CQ3_CONTA
			nCol 	  	:= 1 
			aSaldos 	:= {}
			nTotais 	:= 0
			nVal		:= 0

			#IFDEF TOP    
			If !lAs400
				For nX := 1 To Len(aPeriodos)
					If aPeriodos[nX][1] >= mv_par01 .And. aPeriodos[nX][2] <= mv_par02                   
						//						If mv_par17 == 2 
						//							aAdd(aSaldos,{ &("(cAliasCT1)->COLUNA"+alltrim(str(nX)))+nTotais,0,0,0,0,0} )/// ACUMULA MOVIMENTO
						//						Else 
						aAdd(aSaldos,{ &("(cAliasCT1)->COLUNA"+alltrim(str(nX)))        ,0,0,0,0,0} )/// POR PERIODO (SEM ACUMULAR)
						//						EndIf
						nTotais += aSaldos[nX][1]
						nval 	+=  IIF(nval+aSaldos[nX][1]=0,0,aSaldos[nX][1])
					Else
						Aadd(	aSaldos, {0,0,0,0,0,0})
					Endif
				Next
			Else
				#ENDIF

				If (cAliasCT1)->CT1_CLASSE = "1"		// Sintetica
					(cAliasCT1)->(DbSkip())
					Loop
				Endif

				#IFDEF TOP    
			Endif
			#ENDIF

			//Caso faca filtragem por segmento de item,verifico se esta dentro 
			//da solicitacao feita pelo usuario. 
			lComSaldo	:= .F.  		
			For nX := 1 To Len(aPeriodos)
				If aSaldos[nX][1]  <> 0 
					lComSaldo	:= .T.
					Exit  		    	
				EndIf  		
			Next

			// Se imprime saldos zerados ou 
			// se nao imprime saldos zerados e houver valor,
			// imprime os saldos
			If mv_par07 == 1 .OR. (mv_par07 == 2 .AND. nVal!=0)//(mv_par11 == 2 .AND. nTotais != 0)
				For nX := 1 To Len(aSaldos)
					IF lEnd
						@Prow()+1,0 PSAY OemToAnsi("***** CANCELADO PELO OPERADOR *****")  //"***** CANCELADO PELO OPERADOR *****"
						Exit
					EndIf

					// Inicio da impressao
					If li+If(lImpcc .and. lImpConta,3,If(lImpCC,2,If(lImpConta,1,0))) > 57
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
						li--
						If lImpcc
							Li--
						Endif	

						lFirst	:= .F.
					EndIf

					// Imprime o Centro de Custo
					If lImpCC
						li += 2                                                    
						//					If mv_par16 ==1 //Imprime Cod. CC Normal
						EntidadeCtb(cCtt_Custo,li,00,15,.f.,cMascCus,cSepCus)
						//					Else							
						//						// Imprime codigo reduzido
						//						EntidadeCtb(cCodResCC,li,00,15,.f.,cMascCus,cSepCus)
						//					Endif
						@ li, PCOL() + 1 PSAY CtbDescMoeda("(cAliasCTT)->CTT_DESC01")
						lImpCC := .F.
						li++
					Endif
					// Imprime a Conta
					If lImpConta
						cCodRes := (cAliasCT1)->CT1_RES
						//					If mv_par15 ==1 //Imprime Cod. Conta Normal
						EntidadeCTB(&("(cAliasCT1)->CT1_CONTA"),++li,00,15,.F.,cMascConta,cSepConta)
						//					Else 
						//						EntidadeCTB(cCodRes,++li,00,15,.F.,cMascConta,cSepConta)
						//					Endif
						@ li, PCOL() + 1 PSAY Subs(CtbDescMoeda("(cAliasCT1)->CT1_DESC01"),1,20)
						lImpConta := .F.
					EndIf
					// Imprime o valor
					U_ValorCTB(aSaldos[nX][1],li,26+(nCol++*15),13,nDecimais,.T.,cPicture)
					aTotalCC[nX] += aSaldos[nX][1]
				Next
			Endif	

			// Vai para a proxima conta
			dbSelectArea(cAliasCT1)
			(cAliasCT1)->(DbSkip())		
		EndDo

		If !lFirst		
			// Quebrou o Centro de Custo
			If !lImpCC
				li+=2
				@ li,00 PSAY Replicate("-",Limite)			
				li++
				@ li,000 PSay OemToAnsi("Total do ")+RetTitle("CTT_CUSTO",7)+": "
				//			If mv_par16 == 1 //Imprime Cod. CC Normal 	
				EntidadeCtb(cCtt_Custo,li,PCOL(),13,.F.,cMascCus,cSepCus)
				//			Else 
				//				EntidadeCtb(cCodResCC,li,PCOL(),13,.F.,cMascCus,cSepCus)
				//			Endif

				// Imprime o totalizador por periodo
				nCol := 1
				Aeval( aTotalCC, { |e,nX| If(nX%13==0,(nCol := 1, Li++),NIL),;
				U_ValorCTB(e,li,26+(nCol++*15),13,nDecimais,.T.,cPicture) } )
				li++
				@ li,00 PSAY Replicate("-",Limite)
				For _ncc:= 1 To Len(aTotalCC)
					aTotalGeral[_ncc]+= aTotalCC[_ncc]
				Next _ncc			    						
			EndIf
		EndIf
		dbSelectArea(cAliasCTT)
		#IFNDEF TOP
		dbSetOrder(1)
		(cAliasCTT)->(dbSkip())
		#ELSE
		If lAs400
			dbSetOrder(1)
			(cAliasCTT)->(dbSkip())
		Endif
		#ENDIF       
	Enddo
	//Imprime Total Geral
	li:= li+2
	@ li,00 PSAY OemtoAnsi("Total Geral: ")
	nCol := 1

	Aeval( aTotalGeral, { |e,nX| If(nX%13==0,(nCol := 1, Li++),NIL),;
	U_ValorCTB(e,li,26+(nCol++*15),13,nDecimais,.T.,cPicture) } )
	#IFNDEF TOP
	dbsetOrder(1)
	Set Filter To
	#ELSE
	If lAs400
		dbsetOrder(1)
		Set Filter To
	Endif
	#ENDIF

	If aReturn[5] = 1
		Set Printer To
		Commit
		ourspool(wnrel)
	Endif

	MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBR280   ºAutor  ³Marcos S. Lobo      º Data ³  02/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta a query para o relatorio Mov.Acum. CCxContaxMeses     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                 
User Function CTR280Qry(aPeriodos,cMoeda,cTpSaldo,cContaIni,cContaFim,cCustoIni,cCustoFim,aSetOfBook,lVlrZerado,cString,cFILUSU,lImpAntLP,dDataLP)

	Local aSaveArea	:= GetArea()
	Local cQuery	:= ""
	Local nColunas	:= 0
	Local aTamVlr	:= TAMSX3("CQ3_DEBITO")
	Local nStr		:= 1
	Local l1St 		:= .T.
	Local lAbriu	:= .F.

	DEFAULT lVlrZerado	:= .F.
	DEFAULT lImpAntLP   := .F.
	DEFAULT cFilUSU		:= ""
	DEFAULT cString		:= "CTT"
	DEFAULT aSetOfBook  := {""}

	cFilIni := MV_PAR08
	cFilFim := MV_PAR09

	MsProcTxt("Montando consulta...")

	cQuery := " SELECT CT1_FILIAL CT1_FILIAL, CT1_CONTA CT1_CONTA,CT1_NORMAL CT1_NORMAL, CT1_RES CT1_RES, CT1_DESC"+cMoeda+" CT1_DESC"+cMoeda+", "
	cQuery += " 	CT1_CLASSE CT1_CLASSE, CT1_GRUPO CT1_GRUPO, CT1_CTASUP CT1_CTASUP, "
	cQuery += " 	CTT_FILIAL CTT_FILIAL, CTT_CUSTO CTT_CUSTO, CTT_DESC"+cMoeda+" CTT_DESC"+cMoeda+", CTT_CLASSE CTT_CLASSE, CTT_RES CTT_RES, CTT_CCSUP CTT_CCSUP, "

	For nColunas := 1 to Len(aPeriodos)
		If !Empty(aPeriodos[nColunas][1])

			cQuery += " 	(SELECT SUM(CQ3_CREDIT) - SUM(CQ3_DEBITO) "
			cQuery += "			 	FROM "+RetSqlName("CQ3")+" CQ3 "
			//		cQuery += " 			WHERE CT3.CQ3_FILIAL = '"+xFilial("CT3")+"' " 
			cQuery += "             WHERE CQ3.CQ3_FILIAL BETWEEN '"+cFilIni+"' AND '"+cFilFim+"' "
			cQuery += " 			AND CQ3_MOEDA = '"+cMoeda+"' "
			cQuery += " 			AND CQ3_LP    <> 'Z' "
			cQuery += " 			AND CQ3_TPSALD = '"+cTpSaldo+"' "
			cQuery += " 			AND CQ3_CONTA	= ARQ.CT1_CONTA "
			cQuery += " 			AND CQ3_CCUSTO	= ARQ2.CTT_CUSTO "
			cQuery += " 			AND CQ3_DATA BETWEEN '"+DTOS(aPeriodos[nColunas][2])+"' AND '"+DTOS(aPeriodos[nColunas][3])+"' "

			cQuery += " 			AND CQ3.D_E_L_E_T_ <> '*') COLUNA"+Str(nColunas,Iif(nColunas>9,2,1))+" "
		Else
			cQuery += " 0 COLUNA"+Str(nColunas,Iif(nColunas>9,2,1))+" "
		Endif

		If nColunas <> Len(aPeriodos)
			cQuery += ", "
		EndIf		
	Next	

	cQuery += " 	FROM "+RetSqlName("CT1")+" ARQ, "+RetSqlName("CTT")+" ARQ2 "
	//cQuery += " 	WHERE ARQ.CT1_FILIAL = '"+xFilial("CT1")+"' "      
	cQuery += "     WHERE ARQ.CT1_FILIAL BETWEEN '"+cFilIni+"' And '"+cFilfim+"'" 
	cQuery += " 	AND ARQ.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
	cQuery += " 	AND ARQ.CT1_CLASSE = '2' "

	//If !Empty(aSetOfBook[1])										//// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS     
	//	cQuery += " 	AND ARQ.CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "    //// FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
	//Endif	

	cQuery += " 	AND ARQ.D_E_L_E_T_ <> '*' "

	cQuery += " 	AND ARQ2.CTT_FILIAL BETWEEN '"+cFilIni+"' And '"+cFilfim+"'"
	cQuery += " 	AND ARQ2.CTT_CUSTO BETWEEN '"+cCustoIni+"' AND '"+cCustoFim+"' "
	cQuery += " 	AND ARQ2.CTT_CLASSE = '2' "

	If !(Year(mv_par01) = 2007 .Or. Year(mv_par02) = 2007)
		cQuery += " 	AND ARQ2.D_E_L_E_T_ <> '*' "
	Endif

	l1St := .T.

	If !lVlrZerado
		For nColunas := 1 to Len(aPeriodos)
			If !Empty(aPeriodos[nColunas][1])
				If ! lAbriu
					cQuery += " 	AND ( "
					lAbriu := .T.
				EndIf
				If !l1St
					cQuery += " 	OR "
				EndIf          
				cQuery += " 	(SELECT SUM(CQ3_CREDIT) - SUM(CQ3_DEBITO) "
				cQuery += " FROM "+RetSqlName("CQ3")+" CQ3 "
				cQuery += " WHERE  " //  CT3.CQ3_FILIAL	= '"+xFilial("CT3")+"' AND "
				cQuery += " CQ3_MOEDA = '"+cMoeda+"' "

				cQuery += " AND CQ3_TPSALD = '"+cTpSaldo+"' "
				cQuery += " AND CQ3_CONTA	= ARQ.CT1_CONTA "
				cQuery += " AND CQ3_CCUSTO	= ARQ2.CTT_CUSTO "
				If l1St //.And. mv_par17 = 2
					cQuery += " AND CQ3_DATA <= '"+DTOS(aPeriodos[nColunas][3])+"' "
					l1St := .F.
				Else
					cQuery += " AND CQ3_DATA BETWEEN '"+DTOS(aPeriodos[nColunas][2])+"' AND '"+DTOS(aPeriodos[nColunas][3])+"' "
					l1St := .F.
				Endif
				cQuery += " 	AND CQ3.D_E_L_E_T_ <> '*') <> 0 "
			Endif        
			If lAbriu .And. nColunas == Len(aPeriodos)
				cQuery += " ) "
			EndIf	
		Next
	Endif

	cQuery += " ORDER BY CTT_CUSTO,CT1_CONTA "

	cQuery := ChangeQuery(cQuery)		   

	If Select("TRBTMP") > 0
		dbSelectArea("TRBTMP")
		dbCloseArea()                                 
	Endif	

	MsProcTxt("Executando consulta...")
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)
	For nColunas := 1 to Len(aPeriodos)
		TcSetField("TRBTMP","COLUNA"+Str(nColunas,Iif(nColunas>9,2,1)),"N",aTamVlr[1],aTamVlr[2])
	Next

	RestArea(aSaveArea)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ValorCTB   ³ Autor ³ Pilar S Albaladejo    ³ Data ³ 15.12.99 		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprime O Valor                                             			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ValorCtb(nSaldo,nLin,nCol,nTamanho,nDecimais,lSinal,cPicture,;         ³±±
±±³          ³						cTipo,cConta,lGraf,oPrint)					  	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.   .                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Valor                            	                 		 ³±±
±±³          ³ ExpN2 = Numero da Linha                                   		     ³±±
±±³          ³ ExpN3 = Numero da Coluna                                  		     ³±±
±±³          ³ ExpN4 = Tamanho                                           		     ³±±
±±³          ³ ExpN5 = Numero de Decimais											 ³±±
±±³          ³ ExpL1 = Se devera ser impresso com sinal ou nao.          		     ³±±
±±³          ³ ExpC1 = Picture                                           		     ³±±
±±³          ³ ExpC2 = Tipo                                              		     ³±±
±±³          ³ ExpC3 = Conta                                             		     ³±±
±±³          ³ ExpC4 = Se eh grafico ou nao                              		     ³±±
±±³          ³ ExpO1 = Objeto oPrint                                     		     ³±±
±±³          ³ ExpC4 = Tipo do sinal utilizado                           		     ³±±
±±³          ³ ExpC5 = Identificar [USADO em modo gerencial]             		     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ValorCtb(	nSaldo,nLin,nCol,nTamanho,nDecimais,lSinal,cPicture,;
	cTipo,cConta,lGraf,oPrint,cTipoSinal, cIdentifi,lPrintZero)

	Local aSaveArea	:= GetArea()
	Local cImpSaldo := ""
	Local lDifZero	:= .T.
	Local lInformada:= .T.                      
	Local cCharSinal:= ""

	lPrintZero := Iif(lPrintZero==Nil,.T.,lPrintZero)

	// Nao imprime o valor 0,00
	If !lPrintZero 
		If (Int(nSaldo*100)/100) == 0
			lDifZero := .F.			// O saldo nao eh diferente de zero
		EndIf
	EndIf		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tipo D -> Default (D/C)												  ³
	//³ Tipo S -> Imprime saldo com sinal									  ³
	//³ Tipo P -> Imprime saldo entre parenteses (qdo. negativo)	  ³
	//³ Tipo C -> So imprime "C" (o "D" nao e impresso)              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFAULT cTipoSinal := GetMV("MV_TPVALOR")       // Assume valor default

	cTipo 		:= Iif(cTipo == Nil, Space(1), cTipo)
	nDecimais	:= Iif(nDecimais==Nil,GetMv("MV_CENT"),nDecimais)

	dbSelectArea("CT1")
	dbSetOrder(1)

	If !Empty(cConta) .And. Empty(cTipo)
		If MsSeek(cFilial+cConta)
			cTipo := CT1->CT1_NORMAL
		Endif
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retorna a picture. Caso nao exista espaco, retira os pontos  ³
	//³ separadores de dezenas, centenas e milhares 					  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cPicture)        
		If cTipoSinal $ "D/C"
			cPicture := TmContab(Abs(nSaldo),nTamanho,nDecimais)
		Else
			cPicture := TmContab(nSaldo,nTamanho,nDecimais)
		EndIf	
		lInformada  := .F.
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³* Alguns valores, apesar de  terem sinal devem ser impressos  ³
	//³ sem sinal (lSinal). Ex: valores de colunas Debito e Credito  ³
	//³* Se estiver com a opcao de lingua estrangeira (lEstrang) a   ³
	//³ picture sera invertida para exibir valores: 999,999,999.99   ³
	//³* O tipo de sinal "D" - default nao leva em consideracao a    ³
	//³ a natureza da conta. Dessa forma valores negativos serao	  ³
	//³ impressos sem sinal, e ao seu lado "D" (Devedor) e valores   ³
	//³ positivos terao um "C" (Credito) impresso ao seu lado.       ³
	//³* O tipo de Sinal "P" - Parenteses, imprimira valores de saldo³
	//³  invertidos da condicao normal da conta entre parenteses.	  ³
	//³* O tipo de Sinal "S" - Sinal, imprimira valores de saldo in- ³
	//³  vertidos da condicao normal da conta com sinal - 			  ³
	//³EXEMPLOS  -  EXEMPLOS  -  EXEMPLOS	-	EXEMPLOS  - EXEMPLOS   ³
	//³Cond Normal 	Saldo 	Default      Sinal   Parenteses		  ³
	//³	D			   -1000	   1000 D 		 1000		 1000			  	  ³
	//³	D				 1000 	1000 C		-1000 	(1000)			  ³
	//³	C				-1000 	1000 D		-1000 	(1000)			  ³
	//³	C				 1000 	1000 C		 1000 	 1000 			  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	// So imprime valor se for diferente de zero!
	If lDifZero
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Neste caso (Default), nao importa a natureza da conta! Saldos³
		//³ devedores serao impressos com "D" e credores com "C".        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// Neste caso, nao importa a natureza da conta!!
		If cTipoSinal == "D" .Or. cTipoSinal == "C"         // D(Default) ou C(so Credito)
			If !lInformada
				cPicture := "@E " + cPicture
			Endif	         
			If lSinal
				If nSaldo < 0
					If lGraf                                     
						If cTipoSinal == "D"				
							If cIdentifi # Nil .And. cIdentifi $ "34"
								cCharSinal := Iif(cPaisLoc<>"MEX","D","C")
							Else
								cCharSinal := Iif(cPaisLoc<>"MEX","D","C")
							Endif
						EndIf
					Else	 
						// No Tipo C -> so sao impressos os "C´s"
						If cTipoSinal == "D"
							cCharSinal := Iif(cPaisLoc<>"MEX","D","C")
						EndIf	
					Endif
				ElseIf nSaldo > 0
					If lGraf                                                                
						If cIdentifi # Nil .And. cIdentifi $ "34"                                                           
							If cTipoSinal == "D"
								cCharSinal := Iif(cPaisLoc<>"MEX","D","C")
							EndIf
						Else
							cCharSinal := Iif(cPaisLoc<>"MEX","C","A")
						Endif
					Else
						cCharSinal := Iif(cPaisLoc<>"MEX","C","A")
					Endif
				EndIf
				cCharSinal := " "+cCharSinal			
			EndIf
			cImpSaldo := Transform(Abs(nSaldo),cPicture)+cCharSinal
			If lGraf                                                
				If cIdentifi # Nil .And. cIdentifi $ "34"
					oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
				Else
					oPrint:Say(nLin,nCol,cImpSaldo,oFont08)				
				Endif
			Else  
				@ nLin, nCol pSay cImpSaldo 
			Endif

		Else
			//Utiliza conceito de conta estourada e a conta eh redutora.
			If CT1->(FieldPos("CT1_ESTOUR")) <> 0  .And. Select("cArqTmp") > 0 .And. cArqTmp->(FieldPos("ESTOUR")) <> 0 .And.  cArqTmp->ESTOUR == "1"
				If cTipo == "1" 								// Conta Devedora
					If cTipoSinal == "S"              			// Sinal
						If !lSinal
							nSaldo := Abs(nSaldo)
						EndIf
						If !lInformada
							cPicture := "@E " + cPicture
						EndIf 
						If lGraf
							cImpSaldo := Transform(nSaldo,cPicture)			
							If cIdentifi # Nil .And. cIdentifi $ "34"
								oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
							Else
								oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
							Endif
						Else
							@ nLin, nCol PSAY nSaldo Picture cPicture
						Endif
					ElseIf (cTipoSinal) == "P"              	// Parenteses
						If !lSinal 
							nSaldo := Abs(nSaldo)
						EndIf

						If !lInformada         				
							cPicture := "@E( " + cPicture
						EndIf
						If lGraf
							cImpSaldo := Transform(nSaldo,cPicture)			
							If cIdentifi # Nil .And. cIdentifi $ "34"
								oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
							Else
								oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
							Endif
						Else
							@ nLin, nCol pSay nSaldo Picture cPicture
						Endif
					EndIf
				Else
					If (cTipoSinal) == "S"                  	// Sinal
						If lSinal 
							nSaldo := nSaldo * (-1)
							//					If !lSinal .And. cTipo == "2" 			// Conta Credora
						Else
							nSaldo := Abs(nSaldo)
						EndIf
						If !lInformada
							cPicture := "@E " + cPicture
						EndIf 
						If lGraf
							cImpSaldo := Transform(nSaldo,cPicture)			
							If cIdentifi # Nil .And. cIdentifi $ "34"
								oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
							Else
								oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
							Endif
						Else
							@ nLin, nCol PSAY nSaldo Picture cPicture
						Endif
					ElseIf (cTipoSinal) == "P"              // Parenteses
						If lSinal                  
							nSaldo := nSaldo * (-1)					
							//					If !lSinal .And. cTipo == "2" 			// Conta Credora
						Else
							nSaldo := Abs(nSaldo)
						EndIf
						If !lInformada
							cPicture := "@E( " + cPicture
						EndIf    
						If lGraf
							cImpSaldo := Transform(nSaldo,cPicture)			// Debito
							If cIdentifi # Nil .And. cIdentifi $ "34"
								oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
							Else
								oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
							Endif					
						Else
							@ nLin, nCol pSay nSaldo Picture cPicture
						Endif
					EndIf		
				EndIf		
			Else	//Se nao utiliza conceito de conta estourada
				If cTipo == "1" 								// Conta Devedora
					If cTipoSinal == "S"              			// Sinal
						If lSinal
							nSaldo := nSaldo * (-1)
						Else
							nSaldo := Abs(nSaldo)
						EndIf
						If !lInformada
							cPicture := "@E " + cPicture
						EndIf 
						If lGraf
							cImpSaldo := Transform(nSaldo,cPicture)			
							If cIdentifi # Nil .And. cIdentifi $ "34"
								oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
							Else
								oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
							Endif
						Else
							@ nLin, nCol PSAY nSaldo Picture cPicture
						Endif
					ElseIf (cTipoSinal) == "P"              	// Parenteses
						If lSinal 
							nSaldo := nSaldo * (-1) 		  		// a Picture so exibe parenteses para numeros negativos
						Else
							nSaldo := Abs(nSaldo)
						EndIf

						If !lInformada         				
							cPicture := "@E( " + cPicture
						EndIf
						If lGraf
							cImpSaldo := Transform(nSaldo,cPicture)			
							If cIdentifi # Nil .And. cIdentifi $ "34"
								oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
							Else
								oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
							Endif
						Else
							@ nLin, nCol pSay nSaldo Picture cPicture
						Endif
					EndIf
				Else
					If (cTipoSinal) == "S"                  	// Sinal
						If !lSinal .And. cTipo == "2" 			// Conta Credora
							nSaldo := Abs(nSaldo)
						EndIf
						If !lInformada
							cPicture := "@E " + cPicture
						EndIf 
						If lGraf
							cImpSaldo := Transform(nSaldo,cPicture)			
							If cIdentifi # Nil .And. cIdentifi $ "34"
								oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
							Else
								oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
							Endif
						Else
							@ nLin, nCol PSAY nSaldo Picture cPicture
						Endif
					ElseIf (cTipoSinal) == "P"              // Parenteses
						If !lSinal .And. cTipo == "2" 			// Conta Credora
							nSaldo := Abs(nSaldo)
						EndIf
						If !lInformada
							cPicture := "@E( " + cPicture
						EndIf    
						If lGraf
							cImpSaldo := Transform(nSaldo,cPicture)			// Debito
							If cIdentifi # Nil .And. cIdentifi $ "34"
								oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
							Else
								oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
							Endif					
						Else
							@ nLin, nCol pSay nSaldo Picture cPicture
						Endif
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	RestArea(aSaveArea)

Return

#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO9     บ Autor ณ AP6 IDE            บ Data ณ  12/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function IMPCOPAR()
	Local aSays     := {}
	Local aButtons  := {}
	Local nOpca     := 0
	Local cCadastro := OemToAnsi("Importa a Cooparticipa็ใo Ass. Medica ")
	Private  cArqTxt
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	Private oLeTxt
	Private cCaminho    := ""
	Private cString := ""
	Private Lcont := .T.

	Aadd(aSays, OemToAnsi(" Este programa ira ler o conteudo de um arquivo texto, e       "))
	Aadd(aSays, OemToAnsi(" atualizar a tabela de cooparticipacao de Ass. Medica"))

	Aadd(aButtons, { 1, .T., { || nOpca := 1, FechaBatch()  }})
	Aadd(aButtons, { 2, .T., { || FechaBatch() }})


	FormBatch(cCadastro, aSays, aButtons)

	If nOpca == 1

		If SeleArq()
	
			Processa( { || OkLeTxt() }, "Lendo Arquivo Texto . . .")  //
	   
		EndIf
	
	EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*
@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say "                                                            "

@ 70,098 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,128 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 70,158 BMPBUTTON TYPE 05 ACTION SELEARQ()
Activate Dialog oLeTxt Centered
*/
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKLETXT  บ Autor ณ AP6 IDE            บ Data ณ  12/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a leitura do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


Static Function OkLeTxt

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Abertura do arquivo texto                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//Private cArqTxt := "D:\gtex\importacao\FOROLE.TXT"
//Private nHdl    := fOpen(cArqTxt,330)

	Private cEOL    := "CHR(13)+CHR(10)"

	ValidPerg("RHCOPAR")
	If !pergunte("RHCOPAR",.T.)
		Return()
	Endif



	If Empty( cCaminho )
	
		msginfo("Selecione o arquivo txt.")
		Return lCont
	
	Endif


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	Processa({|| RunCont() },"Processando...")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  12/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunCont

	Local nTamFile, nTamLin, cBuffer, nBtLidos
	Local cNomeArq := ""



	cTam := (len(alltrim(cCaminho))+1)
	for a:= 1 to len(alltrim(cCaminho))
		if subs(cCaminho,ctam,1) == "\"
			exit
		endif
		cNomearq += subs(cCaminho,ctam,1)
		ctam--
	next
	cNomarq := ""
	nTantot := len(cNomearq)
	for a:= 1 to len(cNomearq)
		if subs(cNomearq,nTantot,1) == "."
			exit
		endif
		cNomarq += subs(cNomearq,nTantot,1)
		nTantot--
	next

//ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
//บ Lay-Out do arquivo Texto gerado:                                บ
//ฬออออออออออออออออัออออออออัอออออออออออออออออออออออออออออออออออออออน
//บCampo           ณ Inicio ณ Tamanho                               บ
//วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
//บ ??_FILIAL     ณ 01     ณ 02                                    บ
//ศออออออออออออออออฯออออออออฯอออออออออออออออออออออออออออออออออออออออผ
	Ft_fuse( cCaminho ) 		// Abre o arquivo
	Ft_FGoTop()

	ProcRegua(Ft_fLastRec()) 	// Numero de registros a processar

	nlin := 1

	do While !ft_feof() 			// Enquanto nใo for final do arquivo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Incrementa a regua                                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
		IncProc()
	
		IF NLIN > 1
		
			cBuffer  :=	ALLTRIM(ft_freadln())
		
		
			DBSELECTAREA("RHO")
			aCampos1 := dbStruct()
			nPosini := 0
			nCont := 0
			a:= 0
		
		
		
		
			for b:= 1 to len(alltrim(cBuffer))
			
				if subs(alltrim(cBuffer),b,1) == ";"
					nCont++
					if nCont == 3
						cRHO_FILIAL  := XFILIAL("RHO")
						cRHO_MAT     := SUBS(alltrim(Substr(cBuffer,nposini, (B-NPOSINI) )),9,6)
					Endif
					if nCont == 14
						cRHO_DTOCOR  := CTOD(SUBS(alltrim(Substr(cBuffer,nposini, (B-NPOSINI) )),7,2)+"/"+SUBS(alltrim(Substr(cBuffer,nposini, (B-NPOSINI) )),5,2)+"/"+SUBS(alltrim(Substr(cBuffer,nposini, (B-NPOSINI) )),1,4))
					endif
					if nCont == 5
						cRHO_ORIGEM := IIF(alltrim(Substr(cBuffer,nposini, (B-NPOSINI) ))=="TI","1","2")
						cRHO_pd  := IIF(alltrim(Substr(cBuffer,nposini, (B-NPOSINI) ))=="TI","420","419")
						crho_tpforn := "1"
						crho_codfor := "002"
						crho_tplan  := "1"
					Endif
					if nCont == 12
						crho_vlrfun := val( alltrim(Substr(cBuffer,nposini, (B-NPOSINI) )) )/100
					Endif
					IF nCont == 6
						cRHO_depend     := alltrim(Substr(cBuffer,nposini, (B-NPOSINI) ))
					endif
				
					if nCont == 8
						cRHO_observ     := cRHO_depend+"-"+alltrim(Substr(cBuffer,nposini, (B-NPOSINI) ))
					Endif
				
					nposini := b + 1
				
				
				endif
			next
		
			SRA->(DbSetOrder(1))
			If SRA->(DbSeek(xFilial("SRA")+cRHO_MAT ))
			
			//       RHO_FILIAL+RHO_MAT+DTOS(RHO_DTOCOR)+RHO_TPFORN+RHO_CODFOR +RHO_ORIGEM+RHO_CODIGO+RHO_PD+RHO_COMPPG
				If SRA->RA_COOPART == "S"
					IF RHO->( DBSEEK( XFILIAL("RHO")+CRHO_MAT+DTOS(CRHO_DTOCOR)+Crho_tpforn+Crho_codfor+CRHO_ORIGEM+If(cRHO_ORIGEM == "1"," ","01")+cRHO_PD  ))
						if alltrim(rho->rho_fatura) == ALLTRIM(MV_PAR01)
							RECLOCK("RHO",.F.)
							rho->rho_vlrfun  += Crho_vlrfun
							RHO->RHO_DTOCOR  := CRHO_DTOCOR
							RHO->RHO_FILIAL  := CRHO_FILIAL
							RHO->RHO_MAT     := CRHO_MAT
							IF cRHO_ORIGEM == "1"
								RHO->RHO_CODIGO  :=	""
							ELSE
								RHO->RHO_CODIGO  :=	"01"
							ENDIF
					
							RHO->RHO_ORIGEM  := CRHO_ORIGEM
							RHO->RHO_pd      := CRHO_pd
							rho->rho_tpforn  := Crho_tpforn
							rho->rho_codfor  := Crho_codfor
							rho->rho_tplan   := Crho_tplan
					//		rho->rho_vlrfun  += Crho_vlrfun
							RHO->RHO_observ  := cRHO_depend+"-"+CRHO_observ
							rho->rho_comppg   := subs(dtoc(ddatabase),7,4)+subs(dtoc(ddatabase),4,2)
							RHO->(MSUNLOCK())
						ELSE
					/*
					RECLOCK("RHO",.T.)
					RHO->RHO_FILIAL  := CRHO_FILIAL
					RHO->RHO_MAT     := CRHO_MAT
					IF cRHO_ORIGEM == "1"
						RHO->RHO_CODIGO  :=	""
					ELSE
						RHO->RHO_CODIGO  :=	"01"
					ENDIF
					RHO->RHO_DTOCOR  := CRHO_DTOCOR
					RHO->RHO_ORIGEM  := CRHO_ORIGEM
					RHO->RHO_pd      := CRHO_pd
					rho->rho_tpforn  := Crho_tpforn
					rho->rho_codfor  := Crho_codfor
					rho->rho_tplan   := Crho_tplan
					rho->rho_vlrfun  := Crho_vlrfun
					RHO->RHO_observ  := cRHO_depend+"-"+CRHO_observ
					rho->rho_comppg   := subs(dtoc(ddatabase),7,4)+subs(dtoc(ddatabase),4,2)
					RHO->RHO_FATURA   := MV_PAR01
					RHO->(MSUNLOCK())
					  */
						ENDIF
					ELSE
						RECLOCK("RHO",.T.)
						RHO->RHO_FILIAL  := CRHO_FILIAL
						RHO->RHO_MAT     := CRHO_MAT
						IF cRHO_ORIGEM == "1"
							RHO->RHO_CODIGO  :=	""
						ELSE
							RHO->RHO_CODIGO  :=	"01"
						ENDIF
						RHO->RHO_DTOCOR  := CRHO_DTOCOR
						RHO->RHO_ORIGEM  := CRHO_ORIGEM
						RHO->RHO_pd      := CRHO_pd
						rho->rho_tpforn  := Crho_tpforn
						rho->rho_codfor  := Crho_codfor
						rho->rho_tplan   := Crho_tplan
						rho->rho_vlrfun  := Crho_vlrfun
						RHO->RHO_observ  := cRHO_depend+"-"+CRHO_observ
						rho->rho_comppg   := subs(dtoc(ddatabase),7,4)+subs(dtoc(ddatabase),4,2)
						RHO->RHO_FATURA   := MV_PAR01
						RHO->(MSUNLOCK())
					ENDIF
			
			
				EndIf
			EndIf
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Leitura da proxima linha do arquivo texto.                          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		//nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
		Endif
	
		nlin++
	
		ft_fskip()
	
	EndDo

	ft_fuse()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ณ
//ณ cao anterior.                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู



Return



//-----------------------------------
// Funcao para selecionar o arquivo
//-----------------------------------
Static Function SELEARQ()

	Local cRetAux  :=""
	Local cTipoArq :=""
	Local cFile    :=""

	cRetAux  := ""
	cCaminho := ""
	cFile    := ""
	mv_par10 := ""
	aEstrutura := {}

	cTipoArq := "Todos os Arquivos (*.TXT)     | *.TXT | "
	cRetAux  := cGetFile(cTipoArq,"Selecione o arquivo de importa็ใo",0,"SERVIDOR\",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
	mv_par10 := cRetAux
	cCaminho := cRetAux //Guarda caminho do arquivo de seriais para endere็amento em MT100AGR
//cFile:= SubStr(cRetAux,RAT("\",cRetAux) + 1,Len(cRetAux))

	if !empty( cCaminho )
	
		@ 145,65 Say "Arquivo Selecionado: "+ cCaminho pixel
	
		if substr( cCaminho,len( cCaminho )-2,3) <> "txt" //.and. substr( cCaminho,len( cCaminho )-2,3) <> "csv"
		
			Msgstop("O arquivo deve ser do tipo *.txt")
			nopca := .F.
			lCont := .F.
		//oLeTxt:End()
			Return lCont
		
		endif
	
	Endif

Return lCont


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณMicrosiga           บ Data ณ  04/19/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg(cPerg)

	PutSx1(cPerg, '01','Numero Fatura?' ,'Numero Fatura ?','Numero Fatura ?','mv_ch1','C',20,0,1,'G','','','','','mv_par01',''				 ,'','','',''			 ,'','',''			,'','',''			,'','',''	  ,'','',{},{},{})

Return

#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPGPER05   บAutor  ณCarlos R. Moreira   บ Data ณ  26/05/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ira gerar a relacao de Contribuicao Sindical               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AviPrevio()

	Local aSays     := {}
	Local aButtons  := {}
	Local nOpca     := 0
	Local cCadastro := OemToAnsi("Gera o aviso do funcionario")
	Private  cArqTxt
	Private cPerg := "AVIPREVIO"
	Private nX := 0

	PutSx1(cPerg,"01","Data do Aviso              ?","","","mv_ch1","D",  8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{{"Data do Aviso "}},{{" "}},{{" "}},"")

	If !Pergunte(cPerg,.T.)
		Return
	EndIf

	Aadd(aSays, OemToAnsi(" Este programa ira processar o arquivo e emitir o aviso previo para os Funcionarios "))
	Aadd(aSays, OemToAnsi(" selecionados.        "))

	Aadd(aButtons, { 1, .T., { || nOpca := 1, FechaBatch()  }})
	Aadd(aButtons, { 2, .T., { || FechaBatch() }})
	Aadd(aButtons, { 5, .T., { || Pergunte(cPerg,.T.) }})

	FormBatch(cCadastro, aSays, aButtons)

	If nOpca == 1

		U_SelFunc(1,.F.) //Seleciona os funcionarios

		Processa({||ImprAviso()},"Imprimindo o Aviso Previo..")

		SELFUNC->(DbCloseArea())

	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProc_Arq  บAutor  ณCarlos R. Moreira   บ Data ณ  30/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ira imprimir o aviso previo                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImprAviso()

	oFont  := TFont():New( "Arial",,15,,.t.,,,,,.F. )
	oFont3 := TFont():New( "Arial",,12,,.t.,,,,,.f. )
	oFont12:= TFont():New( "Arial",,10,,.t.,,,,,.f. )
	oFont5 := TFont():New( "Arial",,10,,.f.,,,,,.f. )
	oFont9 := TFont():New( "Arial",,8,,.f.,,,,,.f. )
	oFont14:= TFont():New( "Arial",,8,,.T.,,,,,.f. )
	oArial16N:= TFont():New( "Arial",,16,,.t.,,,,,.f. )
	oArialNeg06 :=  TFont():New( "Arial",, 6,,.T.,,,,,.f. )

	oFont1:= TFont():New( "Times New Roman",,28,,.t.,,,,,.t. )
	oFont2:= TFont():New( "Times New Roman",,14,,.t.,,,,,.f. )
	oFont4:= TFont():New( "Times New Roman",,20,,.t.,,,,,.f. )
	oFont7:= TFont():New( "Times New Roman",,18,,.t.,,,,,.f. )
	oFont11:=TFont():New( "Times New Roman",,10,,.t.,,,,,.t. )

	oFont6:= TFont():New( "HAETTENSCHWEILLER",,10,,.t.,,,,,.f. )

	oFont8:=  TFont():New( "Free 3 of 9",,44,,.t.,,,,,.f. )
	oFont10:= TFont():New( "Free 3 of 9",,38,,.t.,,,,,.f. )
	oFont13:= TFont():New( "Courier New",,16,,.t.,,,,,.f. )
	oCourier10N := TFont():New( "Courier New",,10,,.t.,,,,,.f. )
	oCourier12N := TFont():New( "Courier New",,12,,.t.,,,,,.f. )
	oCourier14N := TFont():New( "Courier New",,14,,.t.,,,,,.f. )

	oBrush := TBrush():New(,CLR_HGRAY,,)
	oBrush1 := TBrush():New(,CLR_BLUE,,)
	oBrush2 := TBrush():New(,CLR_WHITE,,)

	nEscolha := Escolha()

	If  nEscolha == 6
		Return 
	EndIf 

	oPrn := TMSPrinter():New()

	oPrn:SetPaperSize(9)
	oPrn:SetPortrait()

	oPrn:Setup()

	lPri := .T.
	nPag := 0
	nLin := 490


	If nEscolha == 1 //Aviso Indenizado

		DbSelectArea("SRA")
		DbSetOrder(1)
		DbGoTop()

		ProcRegua(RecCount())

		While SRA->(!Eof())


			IncProc("Processando o arquivo..." )

			If SRA->RA_SITFOLH == "D"
				DbSkip()
				Loop
			EndIf

			If ! SELFUNC->(DbSeek(SRA->RA_MAT))
				DbSkip()
				Loop
			Else
				If Empty(SELFUNC->OK)
					DbSkip()
					Loop
				EndIf
			EndIf

			oPrn:StartPage()

			CabAviPre(oPrn)

			nLin := 400

			oPrn:Say(  nLin+20,   300, "AVISO PRษVIO DO EMPREGADOR PARA DISPENSA DO EMPREGADO" ,oCourier12N,100 )
			oPrn:Say(  nLin+80,   650, "Aviso Pr้vio Indenizado" ,oCourier12N,100 )

			nLin += 200

			oPrn:Say(  nLin,   120, "Sr(a) "+Alltrim(SRA->RA_NOME),oCourier12N,100 )		
			oPrn:Say(  nLin+40,120, "Admissใo: "+Dtoc(SRA->RA_ADMISSA),oCourier12N,100 )
			cFuncao := Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")		
			oPrn:Say(  nLin+ 80, 120, "Fun็ใo : "+cFuncao,oCourier12N,100 )
			oPrn:Say(  nLin+120,120, "Obra : "+SRA->RA_CC ,oCourier12N,100 )		

			nLin += 250

			nDiasAv := ( Int((( MV_PAR01 - SRA->RA_ADMISSA ) / 365 ) ) * 3 ) + 30

			oPrn:Say(  nLin,     120, "Comunicamos que a partir desta data, nใo mais necessitamos dos seus  servi็os pela   ",oCourier12N,100 )
			oPrn:Say(  nLin+ 60, 120, "nossa firma, conforme o  disposto IV capitulo VI, artigo 487  da  consolida็ใo das ",oCourier12N,100 )
			oPrn:Say(  nLin+120, 120, "Leis do Trabalho, sendo que o seu aviso de "+Str(nDiasAV,3)+" dias serแ indenizado.",oCourier12N,100 )
			oPrn:Say(  nLin+180, 120, "Pedimos  o  seu comparecimento no Departamento de Pessoal na data e horแrio abaixo  ",oCourier12N,100 )
			oPrn:Say(  nLin+240, 120, "citado, quando  V.Sa.  deverแ  apresentar  a  sua  carteira  profissional para que ",oCourier12N,100 )
			oPrn:Say(  nLin+300, 120, "possamos efeturar o  seu desligamento. ",oCourier12N,100 )

			oPrn:Say(  nLin+420,   120, 'Pedimos a devolu็ใo do presente com seu "CIENTE".',oCourier12N,100 )

			nLin += 570
			//		oPrn:Box(nLin,110,nLin+300,2290)

			cData := StrZero(Day(dDataBase),2)+" de "+MesExtenso(Month(dDataBase))+" de "+StrZero(Year(dDataBase),4)

			oPrn:Say( nLin+ 80,  140, Alltrim(SM0->M0_CIDCOB)+", "+cData  ,oCourier12N,100 )

			nLin += 200

			oPrn:Line( nLin+120, 100, nLin+120,1100 )
			oPrn:Say( nLin+ 140, 120, Alltrim(SM0->M0_NOMECOM)  ,oCourier12N,100 )

			nLin += 400

			//	 		oPrn:Say( nLin,  100, "Declaro-me ciente em ____/____/_____"  ,oCourier12N,100 )

			oPrn:Line( nLin+200, 100, nLin+200,1100 )
			oPrn:Say( nLin+ 220, 220, "Responsแvel Legal(Quando menor)"  ,oCourier12N,100 )

			oPrn:Line( nLin+200, 1200, nLin+200,2000 )
			oPrn:Say( nLin+ 220, 1220, "Empregado(a)"  ,oCourier12N,100 )

			nLin += 400
			oPrn:Say( nLin+ 100, 220, "Testemunhas"  ,oCourier12N,100 )

			oPrn:Line( nLin+300, 100, nLin+300,1100 )
			oPrn:Line( nLin+300, 1200, nLin+300,2300 )		

			oPrn:EndPage()

 //I=Indenizado;T=Trabalhado;J=Justa Causa;R=Resc Ant Con Trab;E=Term Experiencia;                                                 
			DbSelectArea("SRA")
			RecLock("SRA",.F.)
			SRA->RA_TPAVISO := "I"
			SRA->RA_DTAVPRE := dDataBase
			SRA->RA_DTAVPRF := dDataBase 
			MsUnlock()
			DbSkip()

		End

	ElseIf nEscolha == 2 //Aviso trabalho

		DbSelectArea("SRA")
		DbSetOrder(1)
		DbGoTop()

		ProcRegua(RecCount())

		While SRA->(!Eof())


			IncProc("Processando o arquivo..." )

			If SRA->RA_SITFOLH == "D"
				DbSkip()
				Loop
			EndIf

			If ! SELFUNC->(DbSeek(SRA->RA_MAT))
				DbSkip()
				Loop
			Else
				If Empty(SELFUNC->OK)
					DbSkip()
					Loop
				EndIf
			EndIf

			oPrn:StartPage()

			CabAviPre(oPrn)

			nLin := 400

			oPrn:Say(  nLin+20,   300, "AVISO PRษVIO DO EMPREGADOR PARA DISPENSA DO EMPREGADO" ,oCourier12N,100 )
			oPrn:Say(  nLin+80,   650, "Aviso Pr้vio Trabalhado" ,oCourier12N,100 )

			nLin += 200

			oPrn:Say(  nLin,   120, "Sr(a) "+Alltrim(SRA->RA_NOME),oCourier12N,100 )		
			oPrn:Say(  nLin+40,120, "Admissใo: "+Dtoc(SRA->RA_ADMISSA),oCourier12N,100 )
			cFuncao := Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")		
			oPrn:Say(  nLin+ 80, 120, "Fun็ใo : "+cFuncao,oCourier12N,100 )
			oPrn:Say(  nLin+120,120, "Obra : "+SRA->RA_CC ,oCourier12N,100 )		

			nLin += 250

			nDiasAv := 30 //( Int((( MV_PAR01 - SRA->RA_ADMISSA ) / 365 ) ) * 3 ) + 30

			oPrn:Say(  nLin,     120, "Pela presente o notificamos que a "+Str(nDiasAV,3)+" "+Lower(Extenso(nDiasAv,.T.))+" dias "  ,oCourier12N,100 )
			oPrn:Say(  nLin+ 60, 120, "da entrega deste, nใo mais serใo utilizados os seus servi็os p๔r este empregador e",oCourier12N,100 )
			oPrn:Say(  nLin+120, 120, "por isso vimos avisแ-lo(a), nos termos e para os efeitos do disposto no Art   487,",oCourier12N,100 )
			oPrn:Say(  nLin+180, 120, "item II - cap. VI - Tํtulo IV,  do  decreto  Lei  n.  5.452, de 1 de maio de 1943,       ",oCourier12N,100 )
			oPrn:Say(  nLin+240, 120, "(Consolida็ใo das Leis do Trabalho).                                              " , oCourier12N,100 )

			oPrn:Say(  nLin+420,   120, 'Pedimos a devolu็ใo do presente com seu "CIENTE" e "OPวรO" abaixo.',oCourier12N,100 )

			nLin += 570
			//		oPrn:Box(nLin,110,nLin+300,2290)

			cData := StrZero(Day(dDataBase),2)+" de "+MesExtenso(Month(dDataBase))+" de "+StrZero(Year(dDataBase),4)

			oPrn:Say( nLin+ 80,  140, Alltrim(SM0->M0_CIDCOB)+", "+cData  ,oCourier12N,100 )

			nLin += 200

			oPrn:Line( nLin+120, 100, nLin+120,1100 )
			oPrn:Say( nLin+ 140, 120, Alltrim(SM0->M0_NOMECOM)  ,oCourier12N,100 )

			nLin += 400

			// 		oPrn:Say( nLin,  100, "Declaro-me ciente em ____/____/_____  "  ,oCourier12N,100 )

			oPrn:Say( nLin+60, 100, "Op็ใo (Lei N. 7093/3 "  ,oCourier12N,100 )

 //           If SRA->RA_MAT == "003335"	
//			oPrn:Say( nLin+120, 120, "(  ) Redu็ใo de 02 horas (duas horas diแrias ), seu ultimo dia de trabalho serแ 07/12/2017"  ,oCourier12N,100 )

//			oPrn:Say( nLin+180, 120, "(  ) Redu็ใo de 07 (sete) dias corridos, seu ultimo dia de trabalho serแ "+Dtoc(MV_PAR01+nDiasAv-7 )  ,oCourier12N,100 )

//            Else

			oPrn:Say( nLin+120, 120, "(  ) Redu็ใo de 02 horas (duas horas diแrias ), seu ultimo dia de trabalho serแ "+Dtoc(MV_PAR01+nDiasAv)  ,oCourier12N,100 )

			oPrn:Say( nLin+180, 120, "(  ) Redu็ใo de 07 (sete) dias corridos, seu ultimo dia de trabalho serแ "+Dtoc(MV_PAR01+nDiasAv-7 )  ,oCourier12N,100 )
            
 //           EndIf 
			nLin += 200

			oPrn:Line( nLin+200, 100, nLin+200,1100 )
			oPrn:Say( nLin+ 220, 220, "Responsแvel Legal(Quando menor)"  ,oCourier12N,100 )

			oPrn:Line( nLin+200, 1200, nLin+200,2000 )
			oPrn:Say( nLin+ 220, 1220, "Empregado(a)"  ,oCourier12N,100 )

			nLin += 400
			oPrn:Say( nLin+ 100, 220, "Testemunhas"  ,oCourier12N,100 )

			oPrn:Line( nLin+300, 100, nLin+300,1100 )
			oPrn:Line( nLin+300, 1200, nLin+300,2300 )		

			oPrn:EndPage()

//T=Trabalhado;J=Justa Causa;R=Resc Ant Con Trab;E=Term Experiencia;                                                 
			DbSelectArea("SRA")
			RecLock("SRA",.F.)
			SRA->RA_TPAVISO := "T"
			SRA->RA_DTAVPRE := dDataBase
			SRA->RA_DTAVPRF := dDataBase + nDiasAv 
			MsUnlock()

			DbSkip()

		End


	ElseIf nEscolha == 3 //Justa Causa

		DbSelectArea("SRA")
		DbSetOrder(1)
		DbGoTop()

		ProcRegua(RecCount())

		While SRA->(!Eof())


			IncProc("Processando o arquivo..." )

			If SRA->RA_SITFOLH == "D"
				DbSkip()
				Loop
			EndIf

			If ! SELFUNC->(DbSeek(SRA->RA_MAT))
				DbSkip()
				Loop
			Else
				If Empty(SELFUNC->OK)
					DbSkip()
					Loop
				EndIf
			EndIf

			cMotivo := GetMotDis()

			oPrn:StartPage()

			CabAviPre(oPrn)

			nLin := 400

			oPrn:Say(  nLin+20,   300, "AVISO COM JUSTA CAUSA" ,oCourier12N,100 )

			nLin += 200

			oPrn:Say(  nLin,   120, "Sr(a) "+Alltrim(SRA->RA_NOME),oCourier12N,100 )		
			oPrn:Say(  nLin+40,120, "Admissใo: "+Dtoc(SRA->RA_ADMISSA),oCourier12N,100 )
			cFuncao := Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")		
			oPrn:Say(  nLin+ 80, 120, "Fun็ใo : "+cFuncao,oCourier12N,100 )
			oPrn:Say(  nLin+120,120, "Obra : "+SRA->RA_CC ,oCourier12N,100 )		

			nLin += 250


			oPrn:Say(  nLin,     120, "Comunicamos que a partir desta data o seu contrato de trabalho estแ rescindido  por   ",oCourier12N,100 )
			oPrn:Say(  nLin+ 60, 120, 'justa causa, conforme o artigo 482 alinea "A" da consolida็ใo das Leis do Trabalho,  ',oCourier12N,100 )
			oPrn:Say(  nLin+120, 120, "por V.Sas ter "+Substr(Alltrim(cMotivo),1,70) ,oCourier12N,100 )
			oPrn:Say(  nLin+180, 120, "Pedimos  o  seu comparecimento no Departamento de Pessoal na data e horแrio abaixo  ",oCourier12N,100 )
			oPrn:Say(  nLin+240, 120, "citado, quando  V.Sa.  deverแ  apresentar  a  sua  carteira  profissional para que ",oCourier12N,100 )
			oPrn:Say(  nLin+300, 120, "possamos efeturar o  seu desligamento. ",oCourier12N,100 )

			oPrn:Say(  nLin+420,   120, 'Pedimos a devolu็ใo do presente com seu "CIENTE".',oCourier12N,100 )

			nLin += 570
			//		oPrn:Box(nLin,110,nLin+300,2290)

			cData := StrZero(Day(dDataBase),2)+" de "+MesExtenso(Month(dDataBase))+" de "+StrZero(Year(dDataBase),4)

			oPrn:Say( nLin+ 80,  140, Alltrim(SM0->M0_CIDCOB)+", "+cData  ,oCourier12N,100 )

			nLin += 200

			oPrn:Line( nLin+120, 100, nLin+120,1100 )
			oPrn:Say( nLin+ 140, 120, Alltrim(SM0->M0_NOMECOM)  ,oCourier12N,100 )

			nLin += 400

			//		oPrn:Say( nLin,  100, "Declaro-me ciente em ____/____/_____"  ,oCourier12N,100 )

			oPrn:Line( nLin+200, 100, nLin+200,1100 )
			oPrn:Say( nLin+ 220, 220, "Responsแvel Legal(Quando menor)"  ,oCourier12N,100 )

			oPrn:Line( nLin+200, 1200, nLin+200,2000 )
			oPrn:Say( nLin+ 220, 1220, "Empregado(a)"  ,oCourier12N,100 )

			nLin += 400
			oPrn:Say( nLin+ 100, 220, "Testemunhas"  ,oCourier12N,100 )

			oPrn:Line( nLin+300, 100, nLin+300,1100 )
			oPrn:Line( nLin+300, 1200, nLin+300,2300 )		

			oPrn:EndPage()


			DbSelectArea("SRA")
			RecLock("SRA",.F.)
			SRA->RA_TPAVISO := "J"
			SRA->RA_DTAVPRE := dDataBase
			SRA->RA_DTAVPRF := dDataBase 
			MsUnlock()

			DbSkip()

		End

	ElseIf nEscolha == 4 //Rescisao antecipada de contrato de experiencia

		DbSelectArea("SRA")
		DbSetOrder(1)
		DbGoTop()

		ProcRegua(RecCount())

		While SRA->(!Eof())


			IncProc("Processando o arquivo..." )

			If SRA->RA_SITFOLH == "D"
				DbSkip()
				Loop
			EndIf

			If ! SELFUNC->(DbSeek(SRA->RA_MAT))
				DbSkip()
				Loop
			Else
				If Empty(SELFUNC->OK)
					DbSkip()
					Loop
				EndIf
			EndIf

			oPrn:StartPage()

			CabAviPre(oPrn)

			nLin := 400

			oPrn:Say(  nLin+20,   300, "ANTECIPADAวรO DO TERMINO DO CONTRATO DE EXPERIสNCIA" ,oCourier12N,100 )

			nLin += 200

			oPrn:Say(  nLin,   120, "Sr(a) "+Alltrim(SRA->RA_NOME),oCourier12N,100 )		
			oPrn:Say(  nLin+40,120, "Admissใo: "+Dtoc(SRA->RA_ADMISSA),oCourier12N,100 )
			cFuncao := Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")		
			oPrn:Say(  nLin+ 80, 120, "Fun็ใo : "+cFuncao,oCourier12N,100 )
			oPrn:Say(  nLin+120,120, "Obra : "+SRA->RA_CC ,oCourier12N,100 )		

			nLin += 250

			dDtVcExp := If(!Empty(SRA->RA_VCTEXP2),SRA->RA_VCTEXP2,SRA->RA_VCTOEXP)

			oPrn:Say(  nLin,     120, "com a presente levamos ao seu conhecimento que a partir desta data, teremos de  ",oCourier12N,100 )
			oPrn:Say(  nLin+ 60, 120, "os seus servi็os como empregado(a) desta empresa.                               ",oCourier12N,100 )
			oPrn:Say(  nLin+120, 120, "das Leis do Trabalho). Estando V.Sa. dispensado  do  trabalho  a  partir   do   dia ",oCourier12N,100 )
			//		oPrn:Say(  nLin+180, 120, Dtoc(dDtVcExp)+", sendo seu ultimo dia trabalhado "+Dtoc(dDtVcExp)+"."                ,oCourier12N,100 )
			oPrn:Say(  nLin+240, 120, "Assim sendo, solicitamos o comparecimento de V.Sa.  munido  de  sua  carteira    de ",oCourier12N,100 )
			oPrn:Say(  nLin+300, 120, "e previd๊ncia social na "+Alltrim(SM0->M0_NOMECOM)+"," ,oCourier12N,100 )
			oPrn:Say(  nLin+360, 120, "para acerto e recebimento de todos os seus direitos. "         ,oCourier12N,100 )   

			oPrn:Say(  nLin+460,   120, "Obs: no dia de recebimento da rescisใo deverแ entregar os equipamentos EPIดs    e ",oCourier12N,100 )
			oPrn:Say(  nLin+500,   120, "     crachแ, cartใo de  convenio."                                                 ,oCourier12N,100 )		

			nLin += 620
			//		oPrn:Box(nLin,110,nLin+300,2290)

			cData := StrZero(Day(dDataBase),2)+" de "+MesExtenso(Month(dDataBase))+" de "+StrZero(Year(dDataBase),4)

			oPrn:Say( nLin+ 80,  140, Alltrim(SM0->M0_CIDCOB)+", "+cData  ,oCourier12N,100 )

			nLin += 200

			oPrn:Line( nLin+120, 100, nLin+120,1100 )
			oPrn:Say( nLin+ 140, 120, Alltrim(SM0->M0_NOMECOM)  ,oCourier12N,100 )

			nLin += 400

			oPrn:Say( nLin,  100, "Declaro-me ciente em ____/____/_____"  ,oCourier12N,100 )

			oPrn:Line( nLin+200, 100, nLin+200,1100 )
			oPrn:Say( nLin+ 220, 220, "Responsแvel Legal(Quando menor)"  ,oCourier12N,100 )

			oPrn:Line( nLin+200, 1200, nLin+200,2000 )
			oPrn:Say( nLin+ 220, 1220, "Empregado(a)"  ,oCourier12N,100 )

			nLin += 400
			oPrn:Say( nLin+ 100, 220, "Testemunhas"  ,oCourier12N,100 )

			oPrn:Line( nLin+300, 100, nLin+300,1100 )
			oPrn:Line( nLin+300, 1200, nLin+300,2300 )		

			oPrn:EndPage()


			DbSelectArea("SRA")
			RecLock("SRA",.F.)
			SRA->RA_TPAVISO := "R"
			SRA->RA_DTAVPRE := dDataBase
			SRA->RA_DTAVPRF := dDataBase 
			MsUnlock()

			DbSkip()

		End

	ElseIf nEscolha == 5 //Termino de Experiencia 

		DbSelectArea("SRA")
		DbSetOrder(1)
		DbGoTop()

		ProcRegua(RecCount())

		While SRA->(!Eof())


			IncProc("Processando o arquivo..." )

			If SRA->RA_SITFOLH == "D"
				DbSkip()
				Loop
			EndIf

			If ! SELFUNC->(DbSeek(SRA->RA_MAT))
				DbSkip()
				Loop
			Else
				If Empty(SELFUNC->OK)
					DbSkip()
					Loop
				EndIf
			EndIf

			oPrn:StartPage()

			CabAviPre(oPrn)

			nLin := 400

			oPrn:Say(  nLin+20,   300, "TERMINO DO CONTRATO DE EXPERIสNCIA" ,oCourier12N,100 )

			nLin += 200

			oPrn:Say(  nLin,   120, "Sr(a) "+Alltrim(SRA->RA_NOME),oCourier12N,100 )		
			oPrn:Say(  nLin+40,120, "Admissใo: "+Dtoc(SRA->RA_ADMISSA),oCourier12N,100 )
			cFuncao := Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")		
			oPrn:Say(  nLin+ 80, 120, "Fun็ใo : "+cFuncao,oCourier12N,100 )
			oPrn:Say(  nLin+120,120, "Obra : "+SRA->RA_CC ,oCourier12N,100 )		

			nLin += 250

			dDtVcExp := If(!Empty(SRA->RA_VCTEXP2),SRA->RA_VCTEXP2,SRA->RA_VCTOEXP)

			oPrn:Say(  nLin,     120, "Pelo presente comunicamos que o contrato de experi๊ncia previsto para vencer no dia ",oCourier12N,100 )
			oPrn:Say(  nLin+ 60, 120, Dtoc(dDtVcExp)+" nใo serแ efetivado conforme previsto no Art.479 da CLT(Consolida็ใo ",oCourier12N,100 )
			oPrn:Say(  nLin+120, 120, "das Leis do Trabalho). Estando V.Sa. dispensado  do  trabalho  a  partir   do   dia ",oCourier12N,100 )
			oPrn:Say(  nLin+180, 120, Dtoc(dDtVcExp)+", sendo seu ultimo dia trabalhado "+Dtoc(dDtVcExp)+"."                ,oCourier12N,100 )
			oPrn:Say(  nLin+240, 120, "Assim sendo, solicitamos o comparecimento de V.Sa.  munido  de  sua  carteira    de ",oCourier12N,100 )
			oPrn:Say(  nLin+300, 120, "e previd๊ncia social na "+Alltrim(SM0->M0_NOMECOM)+"," ,oCourier12N,100 )
			oPrn:Say(  nLin+360, 120, "a partir desta data para assinatura e apresenta็ใo da carteira para baixa. "         ,oCourier12N,100 )   

			oPrn:Say(  nLin+460,   120, "Obs: no dia de recebimento da rescisใo deverแ entregar os equipamentos EPIดs    e ",oCourier12N,100 )
			oPrn:Say(  nLin+500,   120, "     crachแ, cartใo de  convenio."                                                 ,oCourier12N,100 )		

			nLin += 620
			//		oPrn:Box(nLin,110,nLin+300,2290)

			cData := StrZero(Day(dDataBase),2)+" de "+MesExtenso(Month(dDataBase))+" de "+StrZero(Year(dDataBase),4)

			oPrn:Say( nLin+ 80,  140, Alltrim(SM0->M0_CIDCOB)+", "+cData  ,oCourier12N,100 )

			nLin += 200

			oPrn:Line( nLin+120, 100, nLin+120,1100 )
			oPrn:Say( nLin+ 140, 120, Alltrim(SM0->M0_NOMECOM)  ,oCourier12N,100 )

			nLin += 400

			oPrn:Say( nLin,  100, "Declaro-me ciente em ____/____/_____"  ,oCourier12N,100 )

			oPrn:Line( nLin+200, 100, nLin+200,1100 )
			oPrn:Say( nLin+ 220, 220, "Responsแvel Legal(Quando menor)"  ,oCourier12N,100 )

			oPrn:Line( nLin+200, 1200, nLin+200,2000 )
			oPrn:Say( nLin+ 220, 1220, "Empregado(a)"  ,oCourier12N,100 )

			nLin += 400
			oPrn:Say( nLin+ 100, 220, "Testemunhas"  ,oCourier12N,100 )

			oPrn:Line( nLin+300, 100, nLin+300,1100 )
			oPrn:Line( nLin+300, 1200, nLin+300,2300 )		

			oPrn:EndPage()


			DbSelectArea("SRA")
			RecLock("SRA",.F.)
			SRA->RA_TPAVISO := "E"
			SRA->RA_DTAVPRE := dDataBase
			SRA->RA_DTAVPRF := dDataBase 
			MsUnlock()

			DbSkip()

		End

	EndIf
	oPrn:Preview()
	oPrn:End()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCABREL    บAutor  ณCarlos R.Moreira    บ Data ณ  11/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEmite o cabecalho da Pre-Fatura de conhecimento de transportบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Scarlat                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CabAviPre(oPrn,nPag,cProg)
	Local cBitMap:= FisxLogo("1")

	oArial06Neg  :=  TFont():New( "Arial",,06,,.T.,,,,,.F. )

	oPrn:Box( 050, 100, 300,2300 )
	oPrn:SayBitmap( 100,180,cBitMap,220,180 )
	//oPrn:Line( 050, 550, 300, 550 )
	//oPrn:Line( 050, 1800, 300, 1800 )

	cNomEmp  := SM0->M0_NOMECOM
	cEndEmp  := Alltrim(SM0->M0_ENDCOB)+"-"+Alltrim(SM0->M0_CIDCOB)+"-"+SM0->M0_ESTCOB+"-"+Transform(SM0->M0_CEPCOB,"@R 99999-999")
	cTelFax  := " " //Telefone: (011)4544-9090"
	cHome    := cTelFax + " " //www.alclean.com.br"

	cCNPJ      :=  "C.N.P.J.: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+ "   -    Insc. Estadual : "+SM0->M0_INSC

	//Dados da Empresa
	oPrn:Say(  60,  570, cNomEmp ,oFont3,100 )
	oPrn:Say( 120,  570, cEndEmp ,oFont5,100 )
	oPrn:Say( 180,  570, cCNPJ   ,oFont5,100 )
	oPrn:Say( 240,  570, cHome   ,oFont5,100 )


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
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

	@ 0,0 TO 200,250 DIALOG oDlg2 TITLE "Tipo de Aviso"
	@ 05,05 TO 67,120 TITLE "Selecione"
	@ 10,30 RADIO oRadio Var nRadio Items "Indenizado","Trabalhado","Justa Causa","Resc Ant Con Trab","Term Experiencia","Cancelar" 3D SIZE 60,10 of oDlg2 Pixel
	@ 080,075 BMPBUTTON TYPE 1 ACTION Close(oDlg2)
	ACTIVATE DIALOG oDlg2 CENTER

Return nRadio


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEscolha   บAutor  ณCarlos R. Moreira   บ Data ณ  09/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPega o motivo da demissao por justa causa                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GetMotDis()
	Local cObs := Space(70)
	Local oDlgProc

	DEFINE MSDIALOG oDlgProc TITLE "Descreva o motivo" From 9,0 To 18,100 OF oMainWnd

	@ 5,3 to 41,395 of oDlgProc PIXEL

	@ 15,5 Say "Motivo: " Size 50,10  of oDlgProc Pixel
	@ 13,45 MSGet cObs  Picture "@S50"  Size 320 ,10 of oDlgProc Pixel

	//	@ 50, 90 BMPBUTTON TYPE 1 Action GrvObs(@cObs,oDlgProc,nModo)
	@ 50,120 BMPBUTTON TYPE 1 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

	Return cObs

Return 
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPGPER07   บAutor  ณCarlos R. Moreira   บ Data ณ  14/07/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ira gerar a movimentacao de funcionario para a Petrobras   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PGPER07()

	Local aSays     := {}
	Local aButtons  := {}
	Local nOpca     := 0
	Local cCadastro := OemToAnsi("Relacao de Marcacao de Funcionarios")
	Private  cArqTxt
	Private cPerg := "PGPER07"

	PutSx1(cPerg,"01","Data Inicial               ?","","","mv_ch1","D",  8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{{"Data Inicial do processamento "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"02","Data Final                 ?","","","mv_ch2","D",  8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{{"Data Final de processamento   "}},{{" "}},{{" "}},"")

	aHelpPor :=	{"Define se a exportacao de dados sera consolidada entre empresas"}
	aHelpEsp :=	{}
	aHelpEng :=	{}

	PutSx1( cPerg, 	"03","Consolidas as Empresas  ?","Consolidas as Empresas ?","Consolidas as Empresas ?","mv_ch2","N",1,0,1,"C","","","","",;
	"mv_par03","Nao","","","","Sim","","",;
	"","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

	PutSx1(cPerg,"04","C.Custo de               ?","","","mv_ch4","C",  9,0,0,"G","","CTT","","","mv_par04","","","","","","","","","","","","","","","","",{{"C.Custo Inicial "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"05","C.Custo de               ?","","","mv_ch5","C",  9,0,0,"G","","CTT","","","mv_par05","","","","","","","","","","","","","","","","",{{"C.Custo Final "}},{{" "}},{{" "}},"")

	Pergunte(cPerg,.F.)

	Aadd(aSays, OemToAnsi(" Este programa ira processar o arquivo de tranferencias de Funcionarios "))
	Aadd(aSays, OemToAnsi(" consolidando ou  nao por empresa.        "))

	Aadd(aButtons, { 1, .T., { || nOpca := 1, FechaBatch()  }})
	Aadd(aButtons, { 2, .T., { || FechaBatch() }})
	Aadd(aButtons, { 5, .T., { || Pergunte(cPerg,.T.) }})

	FormBatch(cCadastro, aSays, aButtons)

	If nOpca == 1

		MV_PAR03 := 1

		If MV_PAR03 == 2

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
ฑฑบPrograma  ณProc_Arq  บAutor  ณCarlos R. Moreira   บ Data ณ  30/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ira gerar a Query de cada empresa e consolidar             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Gtex                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Proc_Arq(cEmp)
	Local aNomArq := {}
	Local aArq := {{"SRA"," "},{"SRE"," "},{"CTT"," "} }

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

	cArquivos := ""

	For nArq := 1 to Len(aArq)
		cArquivos += aArq[nArq,2]+" "+aArq[nArq,1]
		If nArq # Len(aArq)
			cArquivos += ","
		EndIf
	Next

	cQuery := "Select SRA.RA_MAT, SRA.RA_NOME,  "
	cQuery += "       SRA.RA_CC,SRA.RA_ADMISSA,SRA.RA_CODFUNC,  "

	cQuery += "CTT.CTT_DESC01 From "+ aArq[Ascan(aArq,{|x|x[1] = "SRA" }),2]+" SRA "

	cQuery += "JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "CTT" }),2]+" CTT  ON "
	cQuery += "     CTT.D_E_L_E_T_ <> '*' AND SRA.RA_CC  = CTT.CTT_CUSTO AND "
	cQuery += "     CTT.CTT_CUSTO BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "

	cQuery += "Where SRA.D_E_L_E_T_ <> '*' " //"AND SRA.RA_SITFOLH <> 'D'  "

	cQuery += " Order by SRA.RA_NOME  "

	cQuery := ChangeQuery(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")
	TCSetField("QRY","RA_ADMISSA","D")

	nTotReg := 0
	QRY->(dbEval({||nTotREG++}))
	QRY->(dbGoTop())

	DbSelectArea("QRY")
	DbGotop()

	ProcRegua(nTotReg)

	While QRY->(!Eof())

		IncProc("Processando o Arquivo de trabalho..Emp: "+cEmp)

		DbSelectArea("SPC")
		DbSetOrder(2)
		DbSeek(xFilial("SPC")+QRY->RA_MAT+Dtos(MV_PAR01),.T. )

		While SPC->(!Eof()) .And. SPC->PC_DATA <= MV_PAR02 .And. SPC->PC_MAT == QRY->RA_MAT     

			cSPC_PD := SPC->PC_PD
			lAtest  := .F. 

			If !Empty(SPC->PC_ABONO) 

				DbSelectArea("SP6")
				DbSetOrder(1) 
				DbSeek(xFilial("SP6")+SPC->PC_ABONO )

				cSPC_PD := SP6->P6_EVENTO
				lAtest  := .T. 

			EndIf 

			DbSelectArea("SP9")
			DbSetOrder(1) 
			DbSeek(xFilial("SP9")+cSPC_PD )

/*			If Empty(SP9->P9_TPEVEN)
				DbSelectArea("SPC")
				DbSkip()
				Loop 			    
			 EndIf */  
			*/
			DbSelectArea("TRB")
			If ! TRB->(DbSeek(QRY->RA_MAT+DTOS(SPC->PC_DATA ) ))
				RecLock("TRB",.T.)
				TRB->EMPRESA := cEmp
				TRB->MAT     := QRY->RA_MAT
				TRB->NOME    := QRY->RA_NOME
				TRB->DTMOV   := SPC->PC_DATA
				TRB->CC      := QRY->RA_CC 
				TRB->DESC_CC := QRY->CTT_DESC01
				TRB->CARGO   := POSICIONE("SRJ",1,xFilial("SRJ")+QRY->RA_CODFUNC,"RJ_DESC")
				TRB->ADMISSA := QRY->RA_ADMISSA 
				MsUnlock()

			EndIf
			RecLock("TRB",.F.) 
			Do Case
				Case SP9->P9_TPEVEN == "N"
				TRB->HRNOR += SPC->PC_QUANTC 
				Case SP9->P9_TPEVEN == "H"
				TRB->HRSEM += SPC->PC_QUANTC				   
				Case SP9->P9_TPEVEN == "S"
				TRB->HREXTS += SPC->PC_QUANTC				   
				Case SP9->P9_TPEVEN == "D"
				TRB->HREXTF  += SPC->PC_QUANTC				   
				Case SP9->P9_TPEVEN == "A" .Or. lAtest 
				TRB->HRATES  += SPC->PC_QUANTC
				TRB->HRAUSEN += SPC->PC_QUANTC				   
				Case SP9->P9_TPEVEN == "F"
				TRB->HRAUSEN += SPC->PC_QUANTC				   
			EndCase 
			If lAtest
				TRB->JUSTIF  := SP6->P6_DESC 
			EndIf    
			MsUnlock()

			DbSelectArea("SPC")
			DbSkip()

		End 

		DbSelectArea("QRY")
		DbSkip()

	End

	QRY->(DbCloseArea())

	(cAliasTrb)->(DbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRIARQTMP บAutor  ณCarlos R. Moreira   บ Data ณ  19/07/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria o arquivo de trabalho                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriaArqTmp()
	Local aCampos := {}

	AaDd(aCampos,{"OK"       ,"C",  2,0})
	AaDd(aCampos,{"EMPRESA"  ,"C",  2,0})
	AaDd(aCampos,{"MAT"      ,"C",  6,0})
	AaDd(aCampos,{"NOME"     ,"C", 40,0})
	AaDd(aCampos,{"DTMOV"    ,"D",  8,0})
	AaDd(aCampos,{"CC"       ,"C",  9,0})
	AaDd(aCampos,{"DESC_CC"  ,"C", 20,0})

	AaDd(aCampos,{"CARGO"    ,"C", 30,0})
	AaDd(aCampos,{"ADMISSA" ,"D",  8,0})

	AaDd(aCampos,{"HRNOR"   ,"N",  6,2})
	AaDd(aCampos,{"HRSEM"   ,"N",  6,2})

	AaDd(aCampos,{"HREXTS"   ,"N",  6,2})
	AaDd(aCampos,{"HREXTF"   ,"N",  6,2})

	AaDd(aCampos,{"HRATES"   ,"N",  6,2})
	AaDd(aCampos,{"HRAUSEN"  ,"N",  6,2})

	AaDd(aCampos,{"JUSTIF"   ,"C", 30,0})

	cArqTmp := CriaTrab(aCampos,.T.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria o arquivo de Trabalhoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	DbUseArea(.T.,,cArqTmp,"TRB",.F.,.F.)
	IndRegua("TRB",cArqTmp,"MAT+DTOS(DTMOV)",,,"Selecionando Registros..." )

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
ฑฑบUso       ณ AP                                                         บฑฑ
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

	AaDD(aBrowse,{"EMPRESA","","Empresa"})
	AaDD(aBrowse,{"MAT","","Matricula"})
	AaDD(aBrowse,{"NOME","","Nome"})
	AaDD(aBrowse,{"DTMOV","","Dt Movimento"})
	AaDD(aBrowse,{"CC","","Centro Custo"})
	AaDD(aBrowse,{"DESC_CC","","Descr. Centro Custo"})


	AaDD(aBrowse,{"CARGO"   ,"","Cargo"})
	AaDD(aBrowse,{"ADMISSA" ,"","Dt Admissao"})

	AaDD(aBrowse,{"HRNOR"   ,"","Horas Normais" ,"@E 999,999.99"})
	AaDD(aBrowse,{"HRSEM"   ,"","Horas Ext Semana"})

	AaDD(aBrowse,{"HREXTS"   ,"","Hrs Ext Sabado" ,"@E 999,999.99"})
	AaDD(aBrowse,{"HREXTF"   ,"","Hrs Ext Dom/Fer" ,"@E 999,999.99"})

	AaDD(aBrowse,{"HRATES"   ,"","Hrs Atestados" ,"@E 999,999.99"})
	AaDD(aBrowse,{"HRAUSEN"  ,"","Hrs Ausentes" ,"@E 999,999.99"})

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

	DEFINE MSDIALOG oDlg1 TITLE "Demostra as marcacoes dos funcionarios " From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
	//ณ arquivo de trabalho "TRB".                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark := MsSelect():New("TRB","","",aBrowse,@lInverte,@cMarca,{aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]})  //35,3,213,385

	oMark:bMark := {| | fa060disp(cMarca,lInverte)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

	@ aPosObj[1,1]+10,aPosObj[1,4]-210 Button "&Imprimir"    Size 60,15 Action ImprTransf() of oDlg1 Pixel //Localiza o Dia

	@ aPosObj[1,1]+10,aPosObj[1,4]-140 Button "&Excel"    Size 60,15 Action ExpCons() of oDlg1 Pixel //Localiza o Dia

	@ aPosObj[1,1]+10,aPosObj[1,4]-70 Button "&Fechar"    Size 60,15 Action {||oDlg1:End()} of oDlg1 Pixel //Localiza o Dia

	ACTIVATE MSDIALOG oDlg1 CENTERED //ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||oDlg1:End()},.T.) CENTERED

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

Static Function ExpCons()
	Private aDadosExcel := {}

	AaDd(aDadosExcel,{ 	"Matricula",;
	"Nome",;
	"Dt. Movimento",;
	"C.Custo",;
	"Descr. Centro Custo",;
	"Cargo",; 
	"Dt Admissao",;
	"Horas Normais" ,;
	"Horas Ext Semana",;
	"Hrs Ext Sabado" ,;
	"Hrs Ext Dom/Fer" ,;
	"Hrs Atestados" ,;
	"Hrs Ausentes" })

	nCol := Len(aDadosExcel[1])

	DbSelectArea("TRB")
	DbGoTop()

	ProcRegua(RecCount())        // Total de Elementos da regua

	While TRB->(!EOF())

		AaDD( aDadosExcel, { TRB->MAT,;
		TRB->NOME,;
		Dtoc(TRB->DTMOV),;
		TRB->CC,;
		TRB->DESC_CC,; 
		TRB->CARGO,;
		DTOC(TRB->ADMISSA),;
		Transform(TRB->HRNOR,"@E 999,999.99"),;
		Transform(TRB->HRSEM,"@E 999,999.99"),;
		Transform(TRB->HREXTS,"@E 999,999.99"),;
		Transform(TRB->HREXTF,"@E 999,999.99"),;
		Transform(TRB->HRATES,"@E 999,999.99"),;
		Transform(TRB->HRAUSEN,"@E 999,999.99") } )

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
ฑฑบPrograma  ณFGPER03   บAutor  ณMicrosiga           บ Data ณ  12/22/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImprTransf()
	Local oPrn
	Private oFont, cCode

	oFont  :=  TFont():New( "Arial",,15,,.T.,,,,,.F. )
	oFont3 :=  TFont():New( "Arial",,12,,.t.,,,,,.f. )
	oFont12:=  TFont():New( "Arial",,10,,.t.,,,,,.f. )
	oFont5 :=  TFont():New( "Arial",,10,,.f.,,,,,.f. )
	oFont9 :=  TFont():New( "Arial",, 8,,.T.,,,,,.f. )
	oArialNeg06 :=  TFont():New( "Arial",, 6,,.T.,,,,,.f. )
	oArialNeg07 :=  TFont():New( "Arial",, 7,,.T.,,,,,.f. )

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

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice para Gerar o Romaneio                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//cNomArq  := CriaTrab(nil,.f.)
	//IndRegua("TRB",cNomArq,"ROMANEI+PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//

	oPrn := TMSPrinter():New()
	//oPrn:SetPortrait()
	oPrn:SetPaperSize(9)
	oPrn:SetLandscape()

	oPrn:Setup()

	lFirst := .t.
	lPri := .T.
	nPag := 0
	nLin := 490


	nTotHRNOR   := 0 
	nTotHRSEM   := 0	
	nTotHREXTS  := 0
	nTotHREXTF  := 0
	nTotHRATES  := 0
	nTotHRAUSEN := 0

	DbSelectArea("TRB")

	cIndice  := CriaTrab(Nil,.F.)
	IndRegua("TRB",cIndice,"Dtos(DTMOV)+MAT",,,OemToAnsi("Selecionando Registros..."))	//

	DbGotop()

	ProcRegua(RecCount())        // Total de Elementos da regua

	While TRB->(!EOF())


		dDtMov  := TRB->DTMOV
		lImpr   := .F.

		nFunHRNOR   := 0 
		nFunHRSEM   := 0 	
		nFunHREXTS  := 0 
		nFunHREXTF  := 0 
		nFunHRATES  := 0 
		nFunHRAUSEN := 0

		While TRB->(!EOF()) .And. dDtMov  == TRB->DTMOV  

			If lFirst
				oPrn:StartPage()
				cTitulo := "Relatorio de Horas Homens Trabalhadas"
				cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
				cNomEmp := SM0->M0_NOMECOM
				aTit    := {cTitulo,cNomEmp,cRod}
				nPag++
				U_CabRel(aTit,1,oPrn,nPag,"")

				CabCons(oPrn)

				lFirst = .F.

			EndIf

			oPrn:Box(nLin,100,nLin+60,3300)

			oPrn:line(nLin, 250,nLin+60, 250)
			oPrn:line(nLin, 400,nLin+60, 400)
			oPrn:line(nLin,1000,nLin+60,1000)
			oPrn:line(nLin,1400,nLin+60,1400)

			oPrn:line(nLin,1550,nLin+60,1550)
			oPrn:line(nLin,1700,nLin+60,1700)
			oPrn:line(nLin,1850,nLin+60,1850)
			oPrn:line(nLin,2000,nLin+60,2000)
			oPrn:line(nLin,2150,nLin+60,2150)
			oPrn:line(nLin,2300,nLin+60,2300)
			oPrn:line(nLin,2450,nLin+60,2450)


			oPrn:Say(nLin+10,  105,Dtoc(TRB->DTMOV)   ,oArialNeg07 ,100)
			oPrn:Say(nLin+10,  260,TRB->MAT         ,oFont9 ,100)
			oPrn:Say(nLin+10,  410,TRB->NOME  ,oFont9 ,100)
			oPrn:Say(nLin+10, 1010,TRB->CARGO    ,oFont9 ,100)
			oPrn:Say(nLin+10, 1405,Dtoc(TRB->ADMISSA)  ,oArialNeg07 ,100)

			oPrn:Say(nLin+10, 1560,Transform(TRB->HRNOR,"@E 999,999.99")  ,oFont9 ,100)
			oPrn:Say(nLin+10, 1710,Transform(TRB->HRSEM,"@E 999,999.99") ,oFont9 ,100)	
			oPrn:Say(nLin+10, 1860,Transform(TRB->HREXTS,"@E 999,999.99") ,oFont9 ,100)
			oPrn:Say(nLin+10, 2010,Transform(TRB->HREXTF,"@E 999,999.99") ,oFont9 ,100)
			oPrn:Say(nLin+10, 2160,Transform(TRB->HRATES,"@E 999,999.99") ,oFont9 ,100)
			oPrn:Say(nLin+10, 2310,Transform(TRB->HRAUSEN,"@E 999,999.99") ,oFont9 ,100)

			oPrn:Say(nLin+10, 2460,TRB->JUSTIF  ,oFont9 ,100)

			nLin += 60

			nTotHRNOR   += TRB->HRNOR 
			nTotHRSEM   += TRB->HRSEM 	
			nTotHREXTS  += TRB->HREXTS 
			nTotHREXTF  += TRB->HREXTF 
			nTotHRATES  += TRB->HRATES 
			nTotHRAUSEN += TRB->HRAUSEN

			nFunHRNOR   += TRB->HRNOR 
			nFunHRSEM   += TRB->HRSEM 	
			nFunHREXTS  += TRB->HREXTS 
			nFunHREXTF  += TRB->HREXTF 
			nFunHRATES  += TRB->HRATES 
			nFunHRAUSEN += TRB->HRAUSEN
			lImpr := .T.

			If nLin > 2200
				oPrn:EndPage()

				oPrn:StartPage()
				cTitulo := "Relatorio de Horas Homens Trabalhadas"
				cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
				cNomEmp := SM0->M0_NOMECOM
				aTit    := {cTitulo,cNomEmp,cRod}
				nPag++
				U_CabRel(aTit,1,oPrn,nPag,"")

				CabCons(oPrn)

			EndIf

			DbSelectArea("TRB")
			DbSkip()

		End 

		If lImpr 

			nLin += 20 

			oPrn:Box(nLin,100,nLin+60,3300)

			oPrn:line(nLin,1550,nLin+60,1550)
			oPrn:line(nLin,1700,nLin+60,1700)
			oPrn:line(nLin,1850,nLin+60,1850)
			oPrn:line(nLin,2000,nLin+60,2000)
			oPrn:line(nLin,2150,nLin+60,2150)
			oPrn:line(nLin,2300,nLin+60,2300)
			oPrn:line(nLin,2450,nLin+60,2450)


			oPrn:Say(nLin+10,  110,"Total do dia : "  ,oFont9 ,100)

			oPrn:Say(nLin+10, 1560,Transform(nFunHRNOR,"@E 999,999.99")  ,oFont9 ,100)
			oPrn:Say(nLin+10, 1710,Transform(nFunHRSEM,"@E 999,999.99") ,oFont9 ,100)	
			oPrn:Say(nLin+10, 1860,Transform(nFunHREXTS,"@E 999,999.99") ,oFont9 ,100)
			oPrn:Say(nLin+10, 2010,Transform(nFunHREXTF,"@E 999,999.99") ,oFont9 ,100)
			oPrn:Say(nLin+10, 2160,Transform(nFunHRATES,"@E 999,999.99") ,oFont9 ,100)
			oPrn:Say(nLin+10, 2310,Transform(nFunHRAUSEN,"@E 999,999.99") ,oFont9 ,100)

			nLin += 80

		EndIf 

	End

	If nTotHRNor > 0

		nLin += 20 

		oPrn:Box(nLin,100,nLin+60,3300)

		oPrn:line(nLin,1550,nLin+60,1550)
		oPrn:line(nLin,1700,nLin+60,1700)
		oPrn:line(nLin,1850,nLin+60,1850)
		oPrn:line(nLin,2000,nLin+60,2000)
		oPrn:line(nLin,2150,nLin+60,2150)
		oPrn:line(nLin,2300,nLin+60,2300)
		oPrn:line(nLin,2450,nLin+60,2450)


		oPrn:Say(nLin+10,  110,"Total Geral :"  ,oFont9 ,100)

		oPrn:Say(nLin+10, 1560,Transform(nTotHRNOR,"@E 999,999.99")  ,oFont9 ,100)
		oPrn:Say(nLin+10, 1710,Transform(nTotHRSEM,"@E 999,999.99") ,oFont9 ,100)	
		oPrn:Say(nLin+10, 1860,Transform(nTotHREXTS,"@E 999,999.99") ,oFont9 ,100)
		oPrn:Say(nLin+10, 2010,Transform(nTotHREXTF,"@E 999,999.99") ,oFont9 ,100)
		oPrn:Say(nLin+10, 2160,Transform(nTotHRATES,"@E 999,999.99") ,oFont9 ,100)
		oPrn:Say(nLin+10, 2310,Transform(nTotHRAUSEN,"@E 999,999.99") ,oFont9 ,100)

	EndIf 

	If !lFirst
		oPrn:EndPage()
	EndIf

	oPrn:Preview()
	oPrn:End()

	cIndice  := CriaTrab(Nil,.F.)
	IndRegua("TRB",cIndice,"MAT+Dtos(DTMOV)",,,OemToAnsi("Selecionando Registros..."))	//

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

	oPrn:line(nLin, 250,nLin+60, 250)
	oPrn:line(nLin, 400,nLin+60, 400)
	oPrn:line(nLin,1000,nLin+60,1000)
	oPrn:line(nLin,1400,nLin+60,1400)

	oPrn:line(nLin,1550,nLin+60,1550)
	oPrn:line(nLin,1700,nLin+60,1700)
	oPrn:line(nLin,1850,nLin+60,1850)
	oPrn:line(nLin,2000,nLin+60,2000)
	oPrn:line(nLin,2150,nLin+60,2150)
	oPrn:line(nLin,2300,nLin+60,2300)
	oPrn:line(nLin,2450,nLin+60,2450)

	oPrn:Say(nLin+10,  110,"Data"       ,oFont5 ,100)
	oPrn:Say(nLin+10,  260,"Matricula"     ,oFont9 ,100)
	oPrn:Say(nLin+10,  410,"Nome "        ,oFont5 ,100)
	oPrn:Say(nLin+10, 1010,"Cargo"        ,oFont5 ,100)
	oPrn:Say(nLin+10, 1410,"Admissao"    ,oFont9 ,100)
	oPrn:Say(nLin+10, 1560,"Hr Norm " ,oFont9 ,100)
	oPrn:Say(nLin+10, 1710,"HE S/S" ,oFont9 ,100)	
	oPrn:Say(nLin+10, 1860,"H E Sab" ,oFont9 ,100)
	oPrn:Say(nLin+10, 2010,"H E D/F" ,oFont9 ,100)
	oPrn:Say(nLin+10, 2160,"Atestados" ,oFont9 ,100)
	oPrn:Say(nLin+10, 2310,"Ausencias" ,oFont9 ,100)
	oPrn:Say(nLin+10, 2460,"Justificativas" ,oFont9 ,100)	
	nLin += 60

Return

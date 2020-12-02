#INCLUDE "RWMAKE.CH"
#Include "Protheus.ch"
#INCLUDE "colors.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPAtfR01   บAutor  ณCarlos R. Moreira   บ Data ณ  27/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o relatorio de movimentacao de ativos                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PATFR02()
	Local aSays     := {}
	Local aButtons  := {}
	Local nOpca     := 0
	Local cCadastro := OemToAnsi("Relatorio de Movimentacao de Ativos")

	Private  cArqTxt
	Private cPerg := "PATFR02"

	PutSx1(cPerg,"01","Funcionario de             ?","","","mv_ch1","C",  6,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{{"Funcionario Inicial "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"02","Funcionario Ate            ?","","","mv_ch2","C",  6,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{{"Funcionario Final  "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"03","Plaqueta De                ?","","","mv_ch3","C",  6,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",{{"CC   Inicial "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"04","Plaqueta Ate               ?","","","mv_ch4","C",  6,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",{{"CC  Final  "}},{{" "}},{{" "}},"")

	PutSx1(cPerg,"05","Emissao De                 ?","","","mv_ch5","D",  8,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",{{"Emissao Inicial "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"06","Emissao Ate                ?","","","mv_ch6","D",  8,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",{{"Emissao Final  "}},{{" "}},{{" "}},"")

	aHelpPor :=	{"Define se o relatorio tem que filtrar as condicoes que encontra-se os ativos"}
	aHelpEsp :=	{}
	aHelpEng :=	{}

	PutSx1( cPerg, 	"07","Condicao do ativo   ?"," "," ","mv_ch7","N",1,0,1,"C","","","","",;
		"mv_par07","Todas","","","","Sem Avarias","","",;
		"Desgastes","","","Mau uso","","","Perda","","",aHelpPor,aHelpEng,aHelpEsp)

	aHelpPor :=	{"Define se o relatorio tem que filtrar as condicoes que encontra-se os ativos"}
	aHelpEsp :=	{}
	aHelpEng :=	{}

	PutSx1( cPerg, 	"08","Condicao devolucao   ?"," "," ","mv_ch8","N",1,0,1,"C","","","","",;
		"mv_par08","Todas","","","","Sem Avarias","","",;
		"Desgastes","","","Mau uso","","","Perda","","",aHelpPor,aHelpEng,aHelpEsp)

	aHelpPor :=	{"Define se o relatorio tem que filtrar as status que encontra-se os ativos"}
	aHelpEsp :=	{}
	aHelpEng :=	{}

	PutSx1( cPerg, 	"09","Somente requisicao   ?"," "," ","mv_ch9","N",1,0,1,"C","","","","",;
		"mv_par09","Todas","","","","Encerradas","","",;
		"Em Aberto","","","Transferidas","","","","","",aHelpPor,aHelpEng,aHelpEsp)

	Pergunte(cPerg,.F.)

	Aadd(aSays, OemToAnsi(" Este programa ira gerar um consulta com os fornecedores  "))
	Aadd(aSays, OemToAnsi(" qualificados de acordo com parametros selecionados."))

	Aadd(aButtons, { 1, .T., { || nOpca := 1, FechaBatch()  }})
	Aadd(aButtons, { 2, .T., { || FechaBatch() }})
	Aadd(aButtons, { 5, .T., { || Pergunte(cPerg,.T.) }})

	FormBatch(cCadastro, aSays, aButtons)

	If nOpca == 1
	
		aEmp := {}
		Aadd( aEmp, SM0->M0_CODIGO )
	
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
ฑฑบPrograma  ณProc_Arq  บAutor  ณCarlos R Moreira    บ Data ณ  04/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o arquivo para gerar o arquivo de trabalho        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Proc_Arq(cEmp)
	Local aNomArq := {}
	Local aArq := {{"SZ6"," "}}

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

	cQuery := " SELECT   SZ6.Z6_MAT, SZ6.Z6_NOMFUNC, SZ6.Z6_CC, SZ6.Z6_DESC_CC, SZ6.Z6_PLACA, SZ6.Z6_CONDICA, SZ6.Z6_DESCBEM, SZ6.Z6_DESCAVA, "
	cQuery += "          SZ6.Z6_EMISSAO, SZ6.Z6_DTDEV, SZ6.Z6_STATUS, SZ6.Z6_CONDEV, "
	cQuery += "          SZ6.Z6_DESCFUN, SZ6.Z6_JUSDESC, SZ6.Z6_VLRDESC, SZ6.Z6_HRKMINI, SZ6.Z6_HRKMFIM, SZ6.Z6_DTRET, SZ6.Z6_COD "
	cQuery += "FROM "+aArq[Ascan(aArq,{|x|x[1] = "SZ6" }),2]+" SZ6 "

	cQuery += " WHERE SZ6.D_E_L_E_T_ <> '*' "
	cQuery += "	And SZ6.Z6_MAT BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
	cQuery += "     SZ6.Z6_PLACA BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
	cQuery += "     SZ6.Z6_EMISSAO BETWEEN '"+Dtos(MV_PAR05)+"' AND '"+Dtos(MV_PAR06)+"' "
   
	cQuery := ChangeQuery(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Gerando o arquivo empresa : "+cEmp )
	TCSetField("QRY","Z6_DTRET","D")
	TCSetField("QRY","Z6_DTDEV","D")
	TCSetField("QRY","Z6_EMISSAO","D")

	nTotReg := 0
	QRY->(dbEval({||nTotREG++}))
	QRY->(dbGoTop())

	DbSelectArea("QRY")
	DbGotop()

	ProcRegua(nTotReg)

	While QRY->(!Eof())
	
		IncProc("Processando o Arquivo de trabalho..Emp: "+cEmp)
  
		If MV_PAR09 # 1
   
			If MV_PAR09 == 2
				If QRY->Z6_STATUS  # "E"
					DbSelectArea("QRY")
					DbSkip()
					Loop
				EndIf
			ElseIf MV_PAR09 == 3
				If QRY->Z6_STATUS  # " "
					DbSelectArea("QRY")
					DbSkip()
					Loop
				EndIf
			ElseIf MV_PAR07 == 4
				If QRY->Z6_STATUS  # "T"
					DbSelectArea("QRY")
					DbSkip()
					Loop
				EndIf

			EndIf
      
		EndIf

		If MV_PAR07 # 1
   
			If MV_PAR07 == 2
				If QRY->Z6_CONDICA # "S"
					DbSelectArea("QRY")
					DbSkip()
					Loop
				EndIf
			ElseIf MV_PAR07 == 3
				If QRY->Z6_CONDICA # "D"
					DbSelectArea("QRY")
					DbSkip()
					Loop
				EndIf
			ElseIf MV_PAR07 == 4
				If QRY->Z6_CONDICA # "M"
					DbSelectArea("QRY")
					DbSkip()
					Loop
				EndIf
			ElseIf MV_PAR07 == 5
				If QRY->Z6_CONDICA # "P"
					DbSelectArea("QRY")
					DbSkip()
					Loop
				EndIf

			EndIf
      
		EndIf
   

		If MV_PAR08 # 1
   
			If MV_PAR08 == 2
				If QRY->Z6_CONDEV # "S"
					DbSelectArea("QRY")
					DbSkip()
					Loop
				EndIf
			ElseIf MV_PAR08 == 3
				If QRY->Z6_CONDEV # "D"
					DbSelectArea("QRY")
					DbSkip()
					Loop
				EndIf
			ElseIf MV_PAR08 == 4
				If QRY->Z6_CONDEV # "M"
					DbSelectArea("QRY")
					DbSkip()
					Loop
				EndIf
			ElseIf MV_PAR08 == 5
				If QRY->Z6_CONDEV # "P"
					DbSelectArea("QRY")
					DbSkip()
					Loop
				EndIf

			EndIf
      
		EndIf

		DbSelectArea("TRB")
		
		RecLock("TRB",.T.)
		TRB->MAT     := QRY->Z6_MAT
		TRB->NOMFUNC := QRY->Z6_NOMFUNC
		TRB->CC      := QRY->Z6_CC
		TRB->DESC_CC := QRY->Z6_DESC_CC
		TRB->PLACA   := QRY->Z6_PLACA
		TRB->CONDICA := QRY->Z6_CONDICA
		TRB->DESCBEM := QRY->Z6_DESCBEM
		TRB->DESCAVA := QRY->Z6_DESCAVA
		TRB->EMISSAO := QRY->Z6_EMISSAO
		TRB->DTDEV   := QRY->Z6_DTDEV
		TRB->STATUS  := QRY->Z6_STATUS
		TRB->CONDEV  := QRY->Z6_CONDEV
		TRB->DESCFUN := QRY->Z6_DESCFUN
		TRB->JUSDESC := QRY->Z6_JUSDESC
		TRB->VLRDESC := QRY->Z6_VLRDESC
		TRB->HRKMINI := QRY->Z6_HRKMINI
		TRB->HRKMFIM := QRY->Z6_HRKMFIM
		TRB->DTRET   := QRY->Z6_DTRET
		TRB->COD     := QRY->Z6_COD
		MsUnlock()
      
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

Static Function MostraCons()
	Local aSize     := MsAdvSize(.T.)
	Local aObjects:={},aInfo:={},aPosObj:={}
	Local aCampos := {}

	Local aInfo   :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	aBrowse := {}

	AaDD(aBrowse,{"MAT","","Matricula",""})
	AaDD(aBrowse,{"NOMFUNC","","Funcionario",""})
	AaDD(aBrowse,{"CC","","C.Custo",""})
	AaDD(aBrowse,{"DESC_CC","","Descricao",""})
	AaDD(aBrowse,{"PLACA","","Placa Ativo",""})
	AaDD(aBrowse,{"DESCBEM","","Descr Ativo",""})
	AaDD(aBrowse,{"CONDICA","","Cond Ativo",""})
	AaDD(aBrowse,{"DESCAVA","","Desc condicao Ativo",""})
	AaDD(aBrowse,{"EMISSAO","","Emissao",""})
	AaDD(aBrowse,{"DTDEV","","Dt Devolucao",""})
	AaDD(aBrowse,{"STATUS","","Status",""})
	AaDD(aBrowse,{"CONDEV","","Cond Dev Ativo",""})
	AaDD(aBrowse,{"DESCFUN","","Descontar",""})
	AaDD(aBrowse,{"JUSDESC","","Justificativa",""})
	AaDD(aBrowse,{"VLRDESC","","Vlr Desconto","@E 99,999,999.99"})
	AaDD(aBrowse,{"HRKMINI","","Hr / Km Inicial",""})
	AaDD(aBrowse,{"HRKMFIM","","Hr / Km Final",""})
	AaDD(aBrowse,{"DTRET","","Data Retirada",""})
	AaDD(aBrowse,{"COD","","Num Requisicao",""})
	
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

	DEFINE MSDIALOG oDlg1 TITLE "Consulta Movimentacao de Ativos " From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
//ณ arquivo de trabalho "TRB".                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark := MsSelect():New("TRB","","",aBrowse,@lInverte,@cMarca,{aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]})  //35,3,213,385

	oMark:bMark := {| | fa060disp(cMarca,lInverte)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

//@ aPosObj[1,1]+10,aPosObj[1,2]+30 Button "&Excel"    Size 60,15 Action ExpCons() of oDlg1 Pixel //Localiza o Dia

	@ aPosObj[3,1]+10,aPosObj[3,2]+520 Button "&Exp Excel"    Size 60,15 Action ExpCons() of oDlg1 Pixel //Localiza o Dia

//	@ aPosObj[3,1]+10,aPosObj[3,2]+585 Button "&Imprimir"    Size 60,15 Action ImpCons() of oDlg1 Pixel //Localiza o Dia

	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||oDlg1:End()},.T.) CENTERED

Return

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณLchoiceBarณ Autor ณ Pilar S Albaladejo    ณ Data ณ          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Mostra a EnchoiceBar na tela                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LchoiceBar(oDlg,bOk,bCancel,lPesq)
	Local oBar, bSet15, bSet24, lOk
	Local lVolta :=.f.

	DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
	DEFINE BUTTON RESOURCE "S4WB008N" OF oBar GROUP ACTION Calculadora() TOOLTIP OemtoAnsi("Calculadora...")
	DEFINE BUTTON RESOURCE "SIMULACAO" OF oBar GROUP ACTION ExpCons() TOOLTIP OemToAnsi("Exporta para Planilha Excel...")    //


	DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
	SetKEY(15,oBtOk:bAction)
	DEFINE BUTTON oBtCan RESOURCE "CANCEL" OF oBar ACTION ( lLoop:=.F.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP OemToAnsi("Cancelar - <Ctrl-X>")  //
	SetKEY(24,oBtCan:bAction)
	oDlg:bSet15 := oBtOk:bAction
	oDlg:bSet24 := oBtCan:bAction
	oBar:bRClicked := {|| AllwaysTrue()}
Return

Static Function ButtonOff(bSet15,bSet24,lOk)
	DEFAULT lOk := .t.
	IF lOk
		SetKey(15,bSet15)
		SetKey(24,bSet24)
	Endif
Return .T.


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
		"Funcionario",;
		"C.Custo",;
		"Descricao",;
		"Placa Ativo",;
		"Descr Ativo",;
		"Cond Ativo",;
		"Desc condicao Ativo",;
		"Emissao",;
		"Dt Devolucao",;
		"Status",;
		"Cond Dev Ativo",;
		"Descontar",;
		"Justificativa",;
		"Vlr Desconto",;
		"Hr / Km Inicial",;
		"Hr / Km Final",;
		"Data Retirada",;
		"Num Requisicao" })


	nCol := Len(aDadosExcel[1])

	DbSelectArea("TRB")
	DbGoTop()

	ProcRegua(RecCount())        // Total de Elementos da regua

	While TRB->(!EOF())
	
     cCondRet := ""
     
     If TRB->CONDICA == "S"
        cCondRet := "Sem Avaria"
     ElseIf TRB->CONDICA == "D"
        cCondRet := "Desgaste Natural"
     ElseIf TRB->CONDICA == "M"
        cCondRet := "Mau Uso" 
     Else
        cCondREt := "Perda"
     EndIf 
     
     cCondDev := ""
     
     If TRB->CONDEV == "S"
        cCondDev := "Sem Avaria"
     ElseIf TRB->CONDEV  == "D"
        cCondDev := "Desgaste Natural"
     ElseIf TRB->CONDEV == "M"
        cCondDev := "Mau Uso" 
     Else
        cCondDev := "Perda"
     EndIf 

		AaDD( aDadosExcel, {	TRB->MAT,;
			TRB->NOMFUNC,;
			TRB->CC,;
			TRB->DESC_CC,;
			TRB->PLACA,;
			TRB->DESCBEM,;
			cCondRet ,;
			TRB->DESCAVA,;
			Dtoc(TRB->EMISSAO),;
			Dtoc(TRB->DTDEV),;
			TRB->STATUS,;
			cCondDev ,;
			TRB->DESCFUN,;
			TRB->JUSDESC,;
			Transform(TRB->VLRDESC,"@E 99,999,999.99"),;
			TRB->HRKMINI,;
			TRB->HRKMFIM,;
			Dtoc(TRB->DTRET),;
			TRB->COD }  )
	
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
ฑฑบPrograma  ณCONSSD1   บAutor  ณMicrosiga           บ Data ณ  05/13/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriaArqTmp()
	Local aCampos := {}

	AaDd(aCampos,{"OK"       ,"C",  2,0})

	AaDd(aCampos,{"MAT"      ,"C",  6,0})
	AaDd(aCampos,{"NOMFUNC"  ,"C", 40,0})
	AaDd(aCampos,{"CC"       ,"C",  9,0})
	AaDd(aCampos,{"DESC_CC"  ,"C", 30,0})
	AaDd(aCampos,{"PLACA"    ,"C",  6,0})
	AaDd(aCampos,{"CONDICA"  ,"C",  1,0})
	AaDd(aCampos,{"DESCBEM"  ,"C", 60,0})
	AaDd(aCampos,{"DESCAVA"  ,"C",100,0})
	AaDd(aCampos,{"EMISSAO"  ,"D",  8,0})
	AaDd(aCampos,{"DTDEV"    ,"D",  8,0})
	AaDd(aCampos,{"STATUS"   ,"C",  1,0})
	AaDd(aCampos,{"CONDEV"   ,"C",  1,0})
	AaDd(aCampos,{"DESCFUN"  ,"C",  1,0})
	AaDd(aCampos,{"JUSDESC"  ,"C",100,0})
	AaDd(aCampos,{"VLRDESC"  ,"N", 17,2})
	AaDd(aCampos,{"HRKMINI"  ,"C",  6,0})
	AaDd(aCampos,{"HRKMFIM"  ,"C",  6,0})
	AaDd(aCampos,{"DTRET"    ,"D",  8,0})
	AaDd(aCampos,{"COD"      ,"C",  6,0})
  		
	cArqTmp := CriaTrab(aCampos,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria o arquivo de Trabalhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	DbUseArea(.T.,,cArqTmp,"TRB",.F.,.F.)
	IndRegua("TRB",cArqTmp,"MAT+PLACA",,,"Selecionando Registros..." )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpCons   บAutor  ณCarlos R Moreira    บ Data ณ  05/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณimprime o relatorio referente a consulta                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpCons()
	Local oPrn
	Private oFont, cCode

	oFont  :=  TFont():New( "Arial",,15,,.T.,,,,,.F. )
	oFont3 :=  TFont():New( "Arial",,12,,.t.,,,,,.f. )
	oFont12:=  TFont():New( "Arial",,10,,.t.,,,,,.f. )
	oFont5 :=  TFont():New( "Arial",,10,,.f.,,,,,.f. )
	oFont9 :=  TFont():New( "Arial",, 8,,.T.,,,,,.f. )
	oArialNeg06 :=  TFont():New( "Arial",, 6,,.T.,,,,,.f. )

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
	oPrn:SetLandscape()
	//oPrn:SetPortrait()
	oPrn:SetPaperSize(9)

	oPrn:Setup()

	lFirst := .t.
	lPri := .T.
	nPag := 0
	nLin := 490
	
	DbSelectArea("TRB")
	DbGotop()
	
	ProcRegua(RecCount())        // Total de Elementos da regua
	
	While TRB->(!EOF())
		
		
		If lFirst
			oPrn:StartPage()
			cTitulo := "Relatorio de Qualificacao de  Fornecedores "
			cRod    := " "
			cNomEmp := SM0->M0_NOMECOM
			aTit    := {cTitulo,cNomEmp,cRod}
			nPag++
			U_CabRel(aTit,1,oPrn,nPag,"")
			
			CabCons(oPrn,1)
			
			lFirst = .F.
			
		EndIf
			
		oPrn:Box(nLin,100,nLin+60,3300)
			
		oPrn:line(nLin, 250,nLin+60, 250)
		oPrn:line(nLin, 550,nLin+60, 550)
		oPrn:line(nLin,1400,nLin+60,1400)
		oPrn:line(nLin,1900,nLin+60,1900)
		oPrn:line(nLin,2100,nLin+60,2100)
		oPrn:line(nLin,2300,nLin+60,2300)
		oPrn:line(nLin,2500,nLin+60,2500)
		oPrn:line(nLin,2700,nLin+60,2700)
		oPrn:line(nLin,2900,nLin+60,2900)
		oPrn:line(nLin,3200,nLin+60,3200)

		oPrn:Say(nLin+10,  110,TRB->FORNECE+"-"+TRB->LOJA    ,oFont9 ,100)
		oPrn:Say(nLin+10,  260,Transform(TRB->CGC,"@R 99.999.999/9999-99")  ,oFont9 ,100)
		oPrn:Say(nLin+10,  560,TRB->NOME          ,oFont5 ,100)
		oPrn:Say(nLin+10, 1410,TRB->NREDUZ         ,oFont9 ,100)

		oPrn:Say(nLin+10, 1910,Dtoc(TRB->PRICOM)   ,oFont5 ,100)
		oPrn:Say(nLin+10, 2110,Dtoc(TRB->ULTCOM)   ,oFont5 ,100)
		oPrn:Say(nLin+10, 2310,Transform(TRB->FATAVA,"999.99")   ,oFont5 ,100)
		oPrn:Say(nLin+10, 2510,Dtoc(TRB->DTAVA)   ,oFont5 ,100)
		oPrn:Say(nLin+10, 2710,Dtoc(TRB->DTVAL)   ,oFont5 ,100)
		oPrn:Say(nLin+10, 2910,TRB->METAV         ,oFont9 ,100)
		oPrn:Say(nLin+10, 3210,Transform(TRB->INDMELH,"@E 999.99")   ,oFont9 ,100)
		nLin += 60

		If nLin > 2200
			oPrn:EndPage()
	   
			lFirst := .T.
	      			
		EndIf
			
		DbSelectArea("TRB")
		DbSkip()
			
	End

	If !lFirst
		oPrn:EndPage()
	EndIf

	oPrn:Preview()
	oPrn:End()

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
	oPrn:line(nLin, 550,nLin+60, 550)
	oPrn:line(nLin,1400,nLin+60,1400)
	oPrn:line(nLin,1900,nLin+60,1900)
	oPrn:line(nLin,2100,nLin+60,2100)
	oPrn:line(nLin,2300,nLin+60,2300)
	oPrn:line(nLin,2500,nLin+60,2500)
	oPrn:line(nLin,2700,nLin+60,2700)
	oPrn:line(nLin,2900,nLin+60,2900)
	oPrn:line(nLin,3200,nLin+60,3200)

	oPrn:Say(nLin+10,  110,"Codigo"   ,oFont9 ,100)
	oPrn:Say(nLin+10,  260,"CNPJ/CPF"     ,oFont5 ,100)
	oPrn:Say(nLin+10,  560,"Nome"         ,oFont5 ,100)
	oPrn:Say(nLin+10, 1410,"N.Fantasia"   ,oFont5 ,100)
	oPrn:Say(nLin+10, 1910,"1a Compra"    ,oFont5 ,100)
	oPrn:Say(nLin+10, 2110,"Ult.Compra"   ,oFont5 ,100)
	oPrn:Say(nLin+10, 2310,"Fator Aval"   ,oFont5 ,100)
	oPrn:Say(nLin+10, 2510,"Dt.Avaliacao" ,oFont5 ,100)
	oPrn:Say(nLin+10, 2710,"Dt Validade"  ,oFont5 ,100)
	oPrn:Say(nLin+10, 2900,"Metodo Aval"  ,oFont5 ,100)
	oPrn:Say(nLin+10, 3220,"IQ%"          ,oFont5 ,100)

	nLin += 60

Return


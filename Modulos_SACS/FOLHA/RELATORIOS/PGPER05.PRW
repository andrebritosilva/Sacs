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

User Function PGPER05()

	Local aSays     := {}
	Local aButtons  := {}
	Local nOpca     := 0
	Local cCadastro := OemToAnsi("Relacao de Contribuicao Sindical")
	Private  cArqTxt
	Private cPerg := "PGPER05"

	PutSx1(cPerg,"01","Mes processameto           ?","","","mv_ch1","C",  6,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{{"Mes do processamento "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"02","Verba especifica           ?","","","mv_ch2","C",  3,0,0,"G","","","SRV","","mv_par02","","","","","","","","","","","","","","","","",{{"Qual a verba que corresponde a contribuicao Sindical"}},{{" "}},{{" "}},"")

	aHelpPor :=	{"Define se a exportacao de dados sera consolidada entre empresas"}
	aHelpEsp :=	{}
	aHelpEng :=	{}

	PutSx1( cPerg, 	"03","Consolidas as Empresas  ?","Consolidas as Empresas ?","Consolidas as Empresas ?","mv_ch2","N",1,0,1,"C","","","","",;
		"mv_par03","Nao","","","","Sim","","",;
		"","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

	If !Pergunte(cPerg,.T.)
		Return
	EndIf

	Aadd(aSays, OemToAnsi(" Este programa ira processar o arquivo de contribuicao sindical dos Funcionarios "))
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
		
			If Empty(MV_PAR02)
   
				cVerbas := U_SelVerba()
        
				If Empty(cVerbas)
					MsgStop("Nao houve selecao de verba..")
					Return
				EndIf
			Else
				cVerbas := MV_PAR02
			EndIf
     
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
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Proc_Arq(cEmp)
	Local aNomArq := {}
	Local aArq := {{"SRA"," "},{"SRD"," "},{"CTT"," "},{"SRV"," "} }

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

	cQuery := " SELECT  SRD.RD_MAT, SRA.RA_NOME, SRD.RD_PD, SRD.RD_VALOR,SRV.RV_DESC,SRD.RD_CC "
	cQuery += " FROM "+ aArq[Ascan(aArq,{|x|x[1] = "SRD" }),2]+" SRD  JOIN "
	cQuery +=  aArq[Ascan(aArq,{|x|x[1] = "SRA" }),2]+" SRA  ON "
	cQuery += " SRD.RD_MAT = SRA.RA_MAT AND SRA.D_E_L_E_T_ <> '*'
	cQuery += " JOIN "+aArq[Ascan(aArq,{|x|x[1] = "SRV" }),2]+" SRV  ON "
	cQuery += " SRD.RD_PD = SRV.RV_COD AND SRV.D_E_L_E_T_ <> '*'

	If !Empty(MV_PAR02)
		cQuery += " WHERE SRD.D_E_L_E_T_ <> '*' AND SRD.RD_PD = '"+MV_PAR02+"' AND SRD.RD_DATARQ = '"
	Else
		cQuery += " WHERE SRD.D_E_L_E_T_ <> '*' AND SRD.RD_DATARQ = '"
	EndIf

	cQuery += Substr(MV_PAR01,3,4)+Substr(MV_PAR01,1,2)+"' "
	cQuery += " ORDER BY SRA.RA_NOME,SRD.RD_PD   "

	cQuery := ChangeQuery(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")

	nTotReg := 0
	QRY->(dbEval({||nTotREG++}))
	QRY->(dbGoTop())

	DbSelectArea("QRY")
	DbGotop()

	ProcRegua(nTotReg)

	While QRY->(!Eof())
	
		IncProc("Processando o Arquivo de trabalho..Emp: "+cEmp)
   
		If !QRY->RD_PD $ cVerbas
			QRY->(DbSkip())
			Loop
		EndIf
     
	//Necessito gravar somente um registro por empresa
		DbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->EMPRESA := cEmp
		TRB->MAT     := QRY->RD_MAT
		TRB->NOME    := QRY->RA_NOME
		TRB->PD      := QRY->RD_PD
		TRB->DESC    := QRY->RV_DESC
		TRB->VALOR   := QRY->RD_VALOR
		TRB->CC      := QRY->RD_CC
	
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
ฑฑบPrograma  ณCRIARQTMP บAutor  ณCarlos R. Moreira   บ Data ณ  05/30/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria o arquivo de trabalho                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Gtex                                            บฑฑ
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
	AaDd(aCampos,{"PD"       ,"C",  3,0})
	AaDd(aCampos,{"DESC"     ,"C", 20,0})
	AaDd(aCampos,{"VALOR"    ,"N", 17,2})
	AaDd(aCampos,{"CC"       ,"C",  9,0})
	
	cArqTmp := CriaTrab(aCampos,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria o arquivo de Trabalhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	DbUseArea(.T.,,cArqTmp,"TRB",.F.,.F.)
	IndRegua("TRB",cArqTmp,"EMPRESA+NOME+MAT",,,"Selecionando Registros..." )

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
	AaDD(aBrowse,{"CC","","Verba"})
	AaDD(aBrowse,{"PD","","Verba"})
	AaDD(aBrowse,{"DESC","","Descricao"})
	AaDD(aBrowse,{"VALOR","","Valor Contr."})

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

	DEFINE MSDIALOG oDlg1 TITLE "Demostra as Verbas selecionadas " From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

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

	ACTIVATE MSDIALOG oDlg1 CENTERED

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

	AaDd(aDadosExcel,{ "Empresa",;
		"Matricula",;
		"Nome",;
		"C.Custo",;
		"Verba",;
		"Descricao",;
		"Valor" } )

	nCol := Len(aDadosExcel[1])

	DbSelectArea("TRB")
	DbGoTop()

	ProcRegua(RecCount())        // Total de Elementos da regua

	While TRB->(!EOF())
	
		AaDD( aDadosExcel, { TRB->EMPRESA,;
			TRB->MAT,;
			TRB->NOME,;
			TRB->CC,;
			TRB->PD,;
			TRB->DESC,;
			Transform(TRB->VALOR,"@E 999,999,999.99") })
	
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

	oPrn := TMSPrinter():New()
	oPrn:SetPaperSize(9)
	oPrn:SetPortrait()

	oPrn:Setup()

	lFirst := .t.
	lPri := .T.
	nPag := 0
	nLin := 490

	nTotal := 0

	nTipoRel := Escolha()

	If nTipoRel = 1

		DbSelectArea("TRB")
		DbGotop()

		ProcRegua(RecCount())        // Total de Elementos da regua

		While TRB->(!EOF())
	
			cMat     := TRB->MAT
			nTotFunc := 0
  
			While TRB->(!Eof()) .And. cMat == TRB->MAT

				If lFirst
					oPrn:StartPage()
					cTitulo := "Relatorio de Verbas "
					cRod    := "Do Mes de "+Substr(MV_PAR01,1,2)+"/"+Substr(MV_PAR01,3,4)
					cNomEmp := SM0->M0_NOMECOM
					aTit    := {cTitulo,cNomEmp,cRod}
					nPag++
					U_CabRel(aTit,2,oPrn,nPag,"PGPER05")
		
					CabCons(oPrn)
		
					lFirst = .F.
		
				EndIf
	
				oPrn:Box(nLin,100,nLin+60,2300)
	
				oPrn:line(nLin, 350,nLin+60, 350)
				oPrn:line(nLin,1100,nLin+60,1100)
				oPrn:line(nLin,1300,nLin+60,1300)
				oPrn:line(nLin,1900,nLin+60,1900)
	
				oPrn:Say(nLin+10,  110,TRB->MAT     ,oFont5 ,100)
				oPrn:Say(nLin+10,  360,TRB->NOME    ,oFont5 ,100)
				oPrn:Say(nLin+10, 1110,TRB->PD     ,oFont5 ,100)
				oPrn:Say(nLin+10, 1310,TRB->DESC    ,oFont5 ,100)
				oPrn:Say(nLin+10, 1910,Transform(TRB->VALOR,"@E 999,999,999.99" )   ,oFont5 ,100)
	
				nLin += 60
	
				If nLin > 3200
		
					oPrn:EndPage()
		
					oPrn:StartPage()
					cTitulo := "Relatorio de Verbas "
					cRod    := "Do Mes de "+Substr(MV_PAR01,1,2)+"/"+Substr(MV_PAR01,3,4)
					cNomEmp := SM0->M0_NOMECOM
					aTit    := {cTitulo,cNomEmp,cRod}
					nPag++
					U_CabRel(aTit,2,oPrn,nPag,"")
		
					CabCons(oPrn)
		
				EndIf
	
				nTotFunc += TRB->VALOR
				nTotal   += TRB->VALOR
	
				DbSelectArea("TRB")
				DbSkip()
	
			End
	
			If nTotFunc > 0

				oPrn:Box(nLin,100,nLin+60,2300)
	
				oPrn:line(nLin,1900,nLin+60,1900)

				oPrn:Say(nLin+10, 110, "Total Funcionario : "  ,oFont5 ,100)
				oPrn:Say(nLin+10, 1910,Transform(nTotFunc,"@E 999,999,999.99" )   ,oFont5 ,100)
	
				nLin += 80
	   
			EndIf

		End

	ElseIf nTipoRel == 2

		DbSelectArea("TRB")

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice para Gerar o relatorio                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cNomArq  := CriaTrab(nil,.f.)
		IndRegua("TRB",cNomArq,"CC+NOME+MAT",,,OemToAnsi("Selecionando Registros..."))	//

		DbGotop()

		ProcRegua(RecCount())        // Total de Elementos da regua

		While TRB->(!EOF())
	
			cCC     := TRB->CC
			nTotCC := 0
  
			While TRB->(!Eof()) .And. cCC == TRB->CC
	
				If lFirst
					oPrn:StartPage()
					cTitulo := "Relatorio de Verbas "
					cRod    := "Do Mes de "+Substr(MV_PAR01,1,2)+"/"+Substr(MV_PAR01,3,4)
					cNomEmp := SM0->M0_NOMECOM
					aTit    := {cTitulo,cNomEmp,cRod}
					nPag++
					U_CabRel(aTit,2,oPrn,nPag,"PGPER05")
		
					CabCons(oPrn)
		
					lFirst = .F.
		
				EndIf
	
				oPrn:Box(nLin,100,nLin+60,2300)
	
				oPrn:line(nLin, 350,nLin+60, 350)
				oPrn:line(nLin, 550,nLin+60, 550)
				oPrn:line(nLin,1100,nLin+60,1100)
				oPrn:line(nLin,1300,nLin+60,1300)
				oPrn:line(nLin,1900,nLin+60,1900)
	
				oPrn:Say(nLin+10,  110,TRB->CC      ,oFont5 ,100)
				oPrn:Say(nLin+10,  360,TRB->MAT     ,oFont5 ,100)
				oPrn:Say(nLin+10,  560,TRB->NOME    ,oFont5 ,100)
				oPrn:Say(nLin+10, 1110,TRB->PD     ,oFont5 ,100)
				oPrn:Say(nLin+10, 1310,TRB->DESC    ,oFont5 ,100)
				oPrn:Say(nLin+10, 1910,Transform(TRB->VALOR,"@E 999,999,999.99" )   ,oFont5 ,100)
	
				nLin += 60
	
				If nLin > 3200
		
					oPrn:EndPage()
		
					oPrn:StartPage()
					cTitulo := "Relatorio de Verbas "
					cRod    := "Do Mes de "+Substr(MV_PAR01,1,2)+"/"+Substr(MV_PAR01,3,4)
					cNomEmp := SM0->M0_NOMECOM
					aTit    := {cTitulo,cNomEmp,cRod}
					nPag++
					U_CabRel(aTit,2,oPrn,nPag,"")
		
					CabCons(oPrn)
		
				EndIf
	
				nTotCC   += TRB->VALOR
				nTotal   += TRB->VALOR
	
				DbSelectArea("TRB")
				DbSkip()
	
			End
	
			If nTotCC > 0

				oPrn:Box(nLin,100,nLin+60,2300)
	
				oPrn:line(nLin,1900,nLin+60,1900)

				oPrn:Say(nLin+10, 110, "Total C.Custo : "  ,oFont5 ,100)
				oPrn:Say(nLin+10, 1910,Transform(nTotCC,"@E 999,999,999.99" )   ,oFont5 ,100)
	
				nLin += 80
	   
			EndIf

		End

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice para Gerar o relatorio                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cNomArq  := CriaTrab(nil,.f.)
		IndRegua("TRB",cNomArq,"EMPRESA+NOME+MAT",,,OemToAnsi("Selecionando Registros..."))	//

	Else

		DbSelectArea("TRB")

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice para Gerar o relatorio                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cNomArq  := CriaTrab(nil,.f.)
		IndRegua("TRB",cNomArq,"PD+CC",,,OemToAnsi("Selecionando Registros..."))	//

		DbGotop()

		ProcRegua(RecCount())        // Total de Elementos da regua

		While TRB->(!EOF())
	
			cPD     := TRB->PD
			nTotPD  := 0
    lPriPD   := .T.  
		
			While TRB->(!Eof()) .And. cPD == TRB->PD
		
				cCC     := TRB->CC
				nTotCC := 0
  
				While TRB->(!Eof()) .And. cCC == TRB->CC .And. cPD == TRB->PD
	
					nTotCC += TRB->VALOR
					nTotPD += TRB->VALOR
					nTotal += TRB->VALOR
		   
					DbSelectArea("TRB")
					DbSkip()
		   
				End
			
				If lFirst
					oPrn:StartPage()
					cTitulo := "Relatorio de Verbas "
					cRod    := "Do Mes de "+Substr(MV_PAR01,1,2)+"/"+Substr(MV_PAR01,3,4)
					cNomEmp := SM0->M0_NOMECOM
					aTit    := {cTitulo,cNomEmp,cRod}
					nPag++
					U_CabRel(aTit,2,oPrn,nPag,"PGPER05")
		
					CabCons(oPrn)
		
					lFirst = .F.
		
				EndIf
	
				oPrn:Box(nLin,100,nLin+60,2300)
	
				oPrn:line(nLin, 350,nLin+60, 350)
				oPrn:line(nLin,1100,nLin+60,1100)
				oPrn:line(nLin,1900,nLin+60,1900)
	
	    If lPriPd 
				   oPrn:Say(nLin+10, 110,TRB->PD     ,oFont5 ,100)
				   oPrn:Say(nLin+10, 360,TRB->DESC    ,oFont5 ,100)
	       lPriPd := .F.
	    EndIf 
				oPrn:Say(nLin+10,  1110,TRB->CC      ,oFont5 ,100)
				oPrn:Say(nLin+10, 1910,Transform(TRB->VALOR,"@E 999,999,999.99" )   ,oFont5 ,100)
	
				nLin += 60
	
				If nLin > 3200
		
					oPrn:EndPage()
		
					oPrn:StartPage()
					cTitulo := "Relatorio de Verbas "
					cRod    := "Do Mes de "+Substr(MV_PAR01,1,2)+"/"+Substr(MV_PAR01,3,4)
					cNomEmp := SM0->M0_NOMECOM
					aTit    := {cTitulo,cNomEmp,cRod}
					nPag++
					U_CabRel(aTit,2,oPrn,nPag,"")
		
					CabCons(oPrn)
		
				EndIf
	

		End
	
		If nTotPD > 0

			oPrn:Box(nLin,100,nLin+60,2300)
	
			oPrn:line(nLin,1900,nLin+60,1900)

			oPrn:Say(nLin+10, 110, "Total Verba : "  ,oFont5 ,100)
			oPrn:Say(nLin+10, 1910,Transform(nTotPD,"@E 999,999,999.99" )   ,oFont5 ,100)
	
			nLin += 80
	   
		EndIf

	End

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice para Gerar o relatorio                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cNomArq  := CriaTrab(nil,.f.)
	IndRegua("TRB",cNomArq,"EMPRESA+NOME+MAT",,,OemToAnsi("Selecionando Registros..."))	//

EndIf

If nTotal > 0

	nLin  += 20
  
	oPrn:Box(nLin,100,nLin+60,2300)
	
	oPrn:line(nLin,1900,nLin+60,1900)

	oPrn:Say(nLin+10, 110, "Total  : "  ,oFont5 ,100)
	oPrn:Say(nLin+10, 1910,Transform(nTotal,"@E 999,999,999.99" )   ,oFont5 ,100)
	
EndIf

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

	oPrn:FillRect({nLin,100,nLin+60,2300},oBrush)

	oPrn:Box(nLin,100,nLin+60,2300)

	If nTipoRel == 1

		oPrn:line(nLin, 350,nLin+60, 350)
		oPrn:line(nLin,1100,nLin+60,1100)
		oPrn:line(nLin,1300,nLin+60,1300)
		oPrn:line(nLin,1900,nLin+60,1900)

		oPrn:Say(nLin+10,  110,"Matricula" ,oFont5 ,100)
		oPrn:Say(nLin+10,  360,"Nome"      ,oFont5 ,100)
		oPrn:Say(nLin+10, 1140,"Verba "    ,oFont5 ,100)
		oPrn:Say(nLin+10, 1310,"Descricao" ,oFont5 ,100)
		oPrn:Say(nLin+10, 1910,"Valor"     ,oFont5 ,100)

	ElseIf nTipoRel == 2

		oPrn:line(nLin, 350,nLin+60, 350)
		oPrn:line(nLin, 550,nLin+60, 550)
		oPrn:line(nLin,1100,nLin+60,1100)
		oPrn:line(nLin,1300,nLin+60,1300)
		oPrn:line(nLin,1900,nLin+60,1900)

		oPrn:Say(nLin+10,  110,"C.Custo" ,oFont5 ,100)
		oPrn:Say(nLin+10,  360,"Matricula" ,oFont5 ,100)
		oPrn:Say(nLin+10,  560,"Nome"      ,oFont5 ,100)
		oPrn:Say(nLin+10, 1140,"Verba "    ,oFont5 ,100)
		oPrn:Say(nLin+10, 1310,"Descricao" ,oFont5 ,100)
		oPrn:Say(nLin+10, 1910,"Valor"     ,oFont5 ,100)

	ElseIf nTipoRel == 3

		oPrn:line(nLin, 350,nLin+60, 350)
		oPrn:line(nLin,1100,nLin+60,1100)
		oPrn:line(nLin,1900,nLin+60,1900)

		oPrn:Say(nLin+10,  110,"Verba" ,oFont5 ,100)
		oPrn:Say(nLin+10,  360,"Descricao" ,oFont5 ,100)
		oPrn:Say(nLin+10, 1140,"C.Custo"    ,oFont5 ,100)
		oPrn:Say(nLin+10, 1910,"Valor"     ,oFont5 ,100)
	
	EndIf

	nLin += 60

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSELVERBA  บAutor  ณCarlos R. Moreira   บ Data ณ  02/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona a Verbas                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SelVerba()
	Local aCampos:= {}
	Local cMat   := Space(6)

	AaDd(aCampos,{"OK"        ,"C", 2,0})
	AaDd(aCampos,{"PD"        ,"C", 3,0})
	AaDd(aCampos,{"DESC"      ,"C",30,0})

	cArqTmp := CriaTrab(aCampos,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria o arquivo de Trabalhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	DbUseArea(.T.,,cArqTmp,"SELVERB",.F.,.F.)
	IndRegua("SELVERB",cArqTmp,"PD",,,"Selecionando Registros..." )

	DbSelectArea("SRV")
	DbGotop()
	ProcRegua( RecCount())

	While SRV->(!Eof()) .And. SRV->RV_FILIAL == xFilial("SRV")
	
		IncProc("Processando as Verbas ")
	
		DbSelectArea("SELVERB")
		RecLock("SELVERB",.T.)
		SELVERB->PD        := SRV->RV_COD
		SELVERB->DESC      := SRV->RV_DESC
		MsUnlock()
	
		DbSelectArea("SRV")
		SRV->(DbSkip())
	
	End

	SELVERB->(DbGoTop())

	aBrowse := {}
	AaDD(aBrowse,{"OK","",""})
	AaDD(aBrowse,{"PD","","Verba"})
	AaDD(aBrowse,{"DESC","","Descricao"})

	nOpca    :=0
	lInverte := .F.
	cMarca   := GetMark()

	DEFINE MSDIALOG oDlg1 TITLE "Seleciona Verba" From 9,0 To 26,55 OF oMainWnd

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
//ณ arquivo de trabalho "FUNC".                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark := MsSelect():New("SELVERB","OK","",aBrowse,@lInverte,@cMarca,{15,3,123,205})

	oMark:bMark := {| | fa060disp(cMarca,lInverte)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=0,oDlg1:End()},{||nOpca:=0,oDlg1:End()}) centered

	cVerbas := " "
	lPri    := .T.

	dbSelectArea("SELVERB")
	dbGoTop()
	While !Eof()
	
		If !Empty(SELVERB->OK)
			If lPri
				cVerbas := SELVERB->PD
				lPri := .F.
			Else
				cVerbas += ","+SELVERB->PD
			EndIf
		EndIf

		dbSkip()
	
	Enddo

	SELVERB->(DbCloseArea())

	Alert("Verbas "+cVerbas )

Return cVerbas

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณFA060Disp ณ Autor ณ Carlos R. Moreira     ณ Data ณ 09/05/03 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Exibe Valores na tela									  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso		 ณ Especifico Rhoss Print                                     ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Fa060Disp(cMarca,lInverte)
	Local aTempos, cClearing, oCBXCLEAR, oDlgClear,lCOnf
	If IsMark("OK",cMarca,lInverte)
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFa060Inve บAutor  ณCarlos R. Moreira   บ Data ณ  19/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณinverte a Selecao dos Itens                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Fa060Inverte(cMarca)
	Local nReg := SELVERB->(Recno())
	Local cAlias := Alias()
	dbSelectArea("SELVERB")
	dbGoTop()
	While !Eof()
		RecLock("SELVERB")
		SELVERB->OK := IIF(SELVERB->OK == "  ",cMarca,"  ")
		MsUnlock()
		dbSkip()
	Enddo
	SELVERB->(dbGoto(nReg))
	oMark:oBrowse:Refresh(.t.)
Return Nil

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
Static Function LchoiceBar(oDlg,bOk,bCancel)
	Local oBar, bSet15, bSet24, lOk
	Local lVolta :=.f.

	DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
	DEFINE BUTTON RESOURCE "S4WB011N" OF oBar GROUP ACTION ProcNome() TOOLTIP OemToAnsi("Procura por Verba..")
	DEFINE BUTTON oBtOk RESOURCE "FINAL" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
	SetKEY(15,oBtOk:bAction)
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
ฑฑบPrograma  ณProcNome  บAutor  ณCarlos R. Moreira   บ Data ณ  19/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLocaliza o Nome do Professor                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Escola Graduada                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcNome()
	Local cNome := Space(3)
	Local oDlgProc

	DEFINE MSDIALOG oDlgProc TITLE "Procura Nome" From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,155 of oDlgProc PIXEL

	@ 15,5 Say "Digite a Verba: " Size 50,10 of oDlgProc Pixel
	@ 13,45 Get cNome Picture "@!" Size 60,10 of oDlgProc Pixel

	@ 50, 90 BMPBUTTON TYPE 1 Action PosNom(@cNome,oDlgProc)
	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

Return


Static Function PosNom(cNome,oDlgProc)

	SELVERB->(DbSeek(cNome,.T.))

	Close(oDlgProc)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
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

	@ 0,0 TO 200,250 DIALOG oDlg2 TITLE "Modelo de Relatorio"

	@ 05,05 TO 67,120 TITLE "Selecione o Tipo"
	@ 23,30 RADIO oRadio Var nRadio Items "Funcionario","C.Custo","Verba" 3D SIZE 60,10 of oDlg2 Pixel

	@ 080,075 BMPBUTTON TYPE 1 ACTION Close(oDlg2)
	ACTIVATE DIALOG oDlg2 CENTER

Return nRadio

#INCLUDE "RWMAKE.CH"
#Include "Protheus.ch"
#INCLUDE "colors.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConsSD1   บAutor  ณCarlos R. Moreira   บ Data ณ  26/05/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o Arquivo para Exportar para Planilha de Excel        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ConsSD1()
Local aSays     := {}
Local aButtons  := {}
Local nOpca     := 0
Local cCadastro := OemToAnsi("Gera o consulta por C.Custo das Notas Entradas")

Private  cArqTxt
Private cPerg := "CONSSD1"

PutSx1(cPerg,"01","Data Inicial               ?","","","mv_ch1","D",  8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{{"Data Inicial de processamento "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"02","Data Final                 ?","","","mv_ch2","D",  8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{{"Data Final de processamento   "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"03","Fornecedor de              ?","","","mv_ch3","C",  6,0,0,"G","","","SA2","","mv_par03","","","","","","","","","","","","","","","","",{{"Cliente Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"04","Fornecedor Ate             ?","","","mv_ch4","C",  6,0,0,"G","","","SA2","","mv_par04","","","","","","","","","","","","","","","","",{{"Cliente Final  "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"05","Loja  De                   ?","","","mv_ch5","C",  2,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",{{"Loja    Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"06","Loja  Ate                  ?","","","mv_ch6","C",  2,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",{{"Loja    Final  "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"07","CC Inicial                 ?","","","mv_ch7","C",  9,0,0,"G","","","CTT","","mv_par07","","","","","","","","","","","","","","","","",{{"Produto Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"08","CC Final                   ?","","","mv_ch8","C",  9,0,0,"G","","","CTT","","mv_par08","","","","","","","","","","","","","","","","",{{"Produto Final  "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"09","Vencimento Inicial         ?","","","mv_ch9","D",  8,0,0,"G","","",   "","","mv_par09","","","","","","","","","","","","","","","","",{{"Data Inicial de processamento "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"10","Vencimento Final           ?","","","mv_cha","D",  8,0,0,"G","","",   "","","mv_par10","","","","","","","","","","","","","","","","",{{"Data Final de processamento   "}},{{" "}},{{" "}},"")

aHelpPor :=	{"Define se a exportacao de dados sera consolidada entre empresas"}
aHelpEsp :=	{}
aHelpEng :=	{}

PutSx1( cPerg, 	"11","Consolidas as Empresas  ?","Consolidas as Empresas ?","Consolidas as Empresas ?","mv_chf","N",1,0,1,"C","","","","",;
"mv_par11","Nao","","","","Sim","","",;
"","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{"Define se o relatorio tem que filtrar os titulos ja baixados"}
aHelpEsp :=	{}
aHelpEng :=	{}

PutSx1( cPerg, 	"12","Posicao dos titulos ?"," "," ","mv_chf","N",1,0,1,"C","","","","",;
"mv_par12","Todos","","","","Abertos","","",;
"","","Baixados","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

PutSx1(cPerg,"13","Natureza de                ?","","","mv_chc","C",  10,0,0,"G","","",   "","","mv_par13","","","","","","","","","","","","","","","","",{{"Natureza Financeira Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"14","Natureza Final             ?","","","mv_chd","C",  10,0,0,"G","","",   "","","mv_par14","","","","","","","","","","","","","","","","",{{"Natureza Financeira Final    "}},{{" "}},{{" "}},"")

Pergunte(cPerg,.F.)

Aadd(aSays, OemToAnsi(" Este programa ira gerar um consulta com os itens   "))
Aadd(aSays, OemToAnsi(" da nota fiscal de acordo com parametros selecionados."))

Aadd(aButtons, { 1, .T., { || nOpca := 1, FechaBatch()  }})
Aadd(aButtons, { 2, .T., { || FechaBatch() }})
Aadd(aButtons, { 5, .T., { || Pergunte(cPerg,.T.) }})

FormBatch(cCadastro, aSays, aButtons)

If nOpca == 1
	
	If MV_PAR11 == 2
		
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
Local aArq := {{"SD1"," "},{"SA2"," "},{"SE2"," "},{"SF4"," "},{"CTT"," "},{"RC1"," "}}
Local IniItem := SelCusto(MV_PAR15)
Local IniFim  := SelCusto(MV_PAR16)

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

cQuery := " SELECT  SD1.D1_DTDIGIT, SD1.D1_CC, SD1.D1_TOTAL, SD1.D1_VALIPI, SD1.D1_FORNECE, SD1.D1_LOJA, "
cQuery += "         SA2.A2_NOME, SE2.E2_VENCREA, CTT.CTT_DESC01, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_NATUREZ, SE2.E2_VALOR  "

cQuery += " FROM "+ aArq[Ascan(aArq,{|x|x[1] = "SD1" }),2]+" SD1 "

cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SA2" }),2]+" SA2 ON "
cQuery += "     SD1.D1_FORNECE = SA2.A2_COD AND SD1.D1_LOJA = SA2.A2_LOJA AND "
cQuery += "     SA2.D_E_L_E_T_ <> '*' AND SA2.A2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
cQuery += "     SA2.A2_LOJA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "

cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SF4" }),2]+" SF4 ON "
cQuery += "     SD1.D1_TES = SF4.F4_CODIGO  AND SF4.F4_DUPLIC = 'S' AND "
cQuery += "     SF4.D_E_L_E_T_ <> '*' AND SF4.F4_FILIAL = SD1.D1_FILIAL"

cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SE2" }),2]+" SE2 ON "
cQuery += "     SD1.D1_SERIE = SE2.E2_PREFIXO  AND SD1.D1_DOC = SE2.E2_NUM AND "
cQuery += "     SD1.D1_FORNECE = SE2.E2_FORNECE AND SD1.D1_LOJA = SE2.E2_LOJA AND "
cQuery += "     SE2.E2_NATUREZ BETWEEN '"+MV_PAR13+"' AND '"+MV_PAR14+"' AND "
If MV_PAR12 # 1
	If MV_PAR12 == 2
		cQuery += " SE2.E2_SALDO > 0 AND "
	Else
		cQuery += " SE2.E2_SALDO <= 0 AND "
	EndIf
EndIf

cQuery += "     SE2.D_E_L_E_T_ <> '*' "

cQuery += " LEFT OUTER JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "CTT" }),2]+" CTT ON "
cQuery += "     SD1.D1_CC = CTT.CTT_CUSTO  AND "
cQuery += "     CTT.D_E_L_E_T_ <> '*' "

cQuery += " WHERE SD1.D_E_L_E_T_ <> '*' "
cQuery += "	And SD1.D1_CC  BETWEEN '"+IniItem+"' And '"+IniFim+"'"
cQuery += "	And SD1.D1_DTDIGIT BETWEEN '"+Dtos(MV_PAR01)+"' And '"+Dtos(mv_par02)+"'"

cQuery := ChangeQuery(cQuery)

MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Gerando o arquivo empresa : "+cEmp )
TCSetField("QRY","D1_DTDIGIT","D")
TCSetField("QRY","E2_VENCREA","D")

nTotReg := 0
QRY->(dbEval({||nTotREG++}))
QRY->(dbGoTop())

DbSelectArea("QRY")
DbGotop()

ProcRegua(nTotReg)

While QRY->(!Eof())
	
	IncProc("Processando o Arquivo de trabalho..Emp: "+cEmp)
	
	If QRY->E2_VENCREA < MV_PAR09 .Or. QRY->E2_VENCREA > MV_PAR10
		QRY->(DbSkip())
		Loop
	EndIf                 
	
	nValMerc := Posicione("SF1",1,xFilial("SF1")+QRY->E2_NUM+QRY->E2_PREFIXO+QRY->D1_FORNECE+QRY->D1_LOJA,"F1_VALMERC")
	
	nPercDup  := Round(QRY->E2_VALOR / nValMerc , 6 )
	nPerc     := Round(QRY->D1_TOTAL / nValMerc , 6 )
			
	DbSelectArea("TRB")
	
	If DbSeek( cEmp+QRY->D1_CC+DTOS(QRY->E2_VENCREA)+QRY->E2_PREFIXO+QRY->E2_NUM+QRY->E2_PARCELA+QRY->D1_FORNECE+QRY->D1_LOJA )
		RecLock("TRB",.F.)            
		TRB->TOTAL    += QRY->D1_TOTAL * nPercDup 
		TRB->VALIPI   += QRY->D1_VALIPI
		MsUnlock()
	Else
		
		RecLock("TRB",.T.)
		TRB->CC       := QRY->D1_CC
		TRB->DESC     := QRY->CTT_DESC01
		TRB->DTDIGIT  := QRY->D1_DTDIGIT
		TRB->TOTAL    := QRY->D1_TOTAL * nPercDup 
		TRB->VALIPI   := QRY->D1_VALIPI
		TRB->NOME     := QRY->A2_NOME
		TRB->FORNECE  := QRY->D1_FORNECE
		TRB->LOJA     := QRY->D1_LOJA
		TRB->DTVENCTO := QRY->E2_VENCREA
		TRB->DOC      := QRY->E2_PREFIXO+QRY->E2_NUM+QRY->E2_PARCELA
		TRB->NATUREZ  := QRY->E2_NATUREZ
		TRB->EMPRESA  := cEmp
		
		MsUnlock()
		
	EndIf
	DbSelectArea("QRY")
	DbSkip()
	
End

QRY->(DbCloseArea())

//Ira gerar os titulos oriundos da Folha de pagamento

cQuery := " SELECT  SE2.E2_EMIS1 , RC1.RC1_CC, SE2.E2_VALOR , SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_NATUREZ, "
cQuery += "         SA2.A2_NOME, SE2.E2_VENCREA, CTT.CTT_DESC01, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA  "

cQuery += " FROM "+ aArq[Ascan(aArq,{|x|x[1] = "SE2" }),2]+" SE2 "

cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SA2" }),2]+" SA2 ON "
cQuery += "     SE2.E2_FORNECE = SA2.A2_COD AND SE2.E2_LOJA = SA2.A2_LOJA AND "
cQuery += "     SA2.D_E_L_E_T_ <> '*' AND SA2.A2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
cQuery += "     SA2.A2_LOJA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "

cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "RC1" }),2]+" RC1 ON "
cQuery += "     RC1.RC1_NUMTIT = SE2.E2_NUM AND "
cQuery += "	    RC1.RC1_CC  BETWEEN '"+IniItem+"' And '"+IniFim+"' AND "
cQuery += "     RC1.D_E_L_E_T_ <> '*' "

cQuery += " LEFT OUTER JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "CTT" }),2]+" CTT ON "
cQuery += "     RC1.RC1_CC = CTT.CTT_CUSTO  AND "
cQuery += "     CTT.D_E_L_E_T_ <> '*' "

cQuery += " WHERE SE2.D_E_L_E_T_ <> '*' "
cQuery += "	And SE2.E2_EMIS1 BETWEEN '"+Dtos(MV_PAR01)+"' And '"+Dtos(mv_par02)+"'"
cQuery += "	And SE2.E2_VENCREA BETWEEN '"+Dtos(MV_PAR09)+"' And '"+Dtos(mv_par10)+"'"
cQuery += " AND SE2.E2_NATUREZ BETWEEN '"+MV_PAR13+"' AND '"+MV_PAR14+"'"
cQuery += "	And SE2.E2_PREFIXO = 'GPE' "

If MV_PAR12 # 1
	If MV_PAR12 == 2
		cQuery += " AND SE2.E2_SALDO > 0  "
	Else
		cQuery += " AND SE2.E2_SALDO <= 0  "
	EndIf
EndIf

cQuery := ChangeQuery(cQuery)

MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Gerando o arquivo empresa : "+cEmp )
TCSetField("QRY","E2_EMIS1","D")
TCSetField("QRY","E2_VENCREA","D")

nTotReg := 0
QRY->(dbEval({||nTotREG++}))
QRY->(dbGoTop())

DbSelectArea("QRY")
DbGotop()

ProcRegua(nTotReg)

While QRY->(!Eof())
	
	IncProc("Processando o Arquivo de trabalho..Emp: "+cEmp)
	
	DbSelectArea("TRB")
	
	
	RecLock("TRB",.T.)
	TRB->CC       := QRY->RC1_CC
	TRB->DESC     := QRY->CTT_DESC01
	TRB->DTDIGIT  := QRY->E2_EMIS1
	TRB->TOTAL    := QRY->E2_VALOR
	TRB->NOME     := QRY->A2_NOME
	TRB->FORNECE  := QRY->E2_FORNECE
	TRB->LOJA     := QRY->E2_LOJA
	TRB->DTVENCTO := QRY->E2_VENCREA
	TRB->DOC      := QRY->E2_PREFIXO+QRY->E2_NUM+QRY->E2_PARCELA
	TRB->NATUREZ  := QRY->E2_NATUREZ
	TRB->EMPRESA  := cEmp
	
	MsUnlock()
	
	DbSelectArea("QRY")
	DbSkip()
	
End

QRY->(DbCloseArea())


//Ira gerar os titulos Manuais

cQuery := " SELECT  SE2.E2_EMIS1 , SE2.E2_CCD, SE2.E2_VALOR , SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_NATUREZ, "
cQuery += "         SA2.A2_NOME, SE2.E2_VENCREA, CTT.CTT_DESC01, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA  "

cQuery += " FROM "+ aArq[Ascan(aArq,{|x|x[1] = "SE2" }),2]+" SE2 "

cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SA2" }),2]+" SA2 ON "
cQuery += "     SE2.E2_FORNECE = SA2.A2_COD AND SE2.E2_LOJA = SA2.A2_LOJA AND "
cQuery += "     SA2.D_E_L_E_T_ <> '*' AND SA2.A2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
cQuery += "     SA2.A2_LOJA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "

cQuery += " LEFT OUTER JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "CTT" }),2]+" CTT ON "
cQuery += "     SE2.E2_CCD = CTT.CTT_CUSTO  AND "
cQuery += "     CTT.D_E_L_E_T_ <> '*' "

cQuery += " WHERE SE2.D_E_L_E_T_ <> '*' "
cQuery += "	And SE2.E2_EMIS1 BETWEEN '"+Dtos(MV_PAR01)+"' And '"+Dtos(mv_par02)+"'"
cQuery += "	And SE2.E2_VENCREA BETWEEN '"+Dtos(MV_PAR09)+"' And '"+Dtos(mv_par10)+"'"
cQuery += " AND SE2.E2_NATUREZ BETWEEN '"+MV_PAR13+"' AND '"+MV_PAR14+"'"
cQuery += " AND SE2.E2_CCD BETWEEN '"+IniItem+"' AND '"+IniFim+"'"
cQuery += "	And SE2.E2_ORIGEM = 'FINA050' "

If MV_PAR12 # 1
	If MV_PAR12 == 2
		cQuery += " AND SE2.E2_SALDO > 0  "
	Else
		cQuery += " AND SE2.E2_SALDO <= 0  "
	EndIf
EndIf

cQuery := ChangeQuery(cQuery)

MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Gerando o arquivo empresa : "+cEmp )
TCSetField("QRY","E2_EMIS1","D")
TCSetField("QRY","E2_VENCREA","D")

nTotReg := 0
QRY->(dbEval({||nTotREG++}))
QRY->(dbGoTop())

DbSelectArea("QRY")
DbGotop()

ProcRegua(nTotReg)

While QRY->(!Eof())
	
	IncProc("Processando o Arquivo de trabalho..Emp: "+cEmp)
	
	DbSelectArea("TRB")
	
	
	RecLock("TRB",.T.)
	TRB->CC       := QRY->E2_CCD
	TRB->DESC     := QRY->CTT_DESC01
	TRB->DTDIGIT  := QRY->E2_EMIS1
	TRB->TOTAL    := QRY->E2_VALOR
	TRB->NOME     := QRY->A2_NOME
	TRB->FORNECE  := QRY->E2_FORNECE
	TRB->LOJA     := QRY->E2_LOJA
	TRB->DTVENCTO := QRY->E2_VENCREA
	TRB->DOC      := QRY->E2_PREFIXO+QRY->E2_NUM+QRY->E2_PARCELA
	TRB->NATUREZ  := QRY->E2_NATUREZ
	TRB->EMPRESA  := cEmp
	
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

AaDD(aBrowse,{"EMPRESA","","Empresa"})
AaDD(aBrowse,{"CC","","C.Custo"})
AaDD(aBrowse,{"DESC","","Descricao",""})
AaDD(aBrowse,{"NATUREZ","","Natureza",""})
AaDD(aBrowse,{"DTDIGIT","","Dt. Entrada",""})
AaDD(aBrowse,{"DTVENCTO","","Vencimento",""})
AaDD(aBrowse,{"VALIPI"   ,"","Vlr. IPI","@e 999,999.99"})
AaDD(aBrowse,{"TOTAL"   ,"","Vlr. Total","@e 99,999,999.99"})
AaDD(aBrowse,{"FORNECE","","Fornecedor",""})
AaDD(aBrowse,{"LOJA","","Loja",""})
AaDD(aBrowse,{"NOME","","Razao Social",""})

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

DEFINE MSDIALOG oDlg1 TITLE "Consulta CC - Periodo" From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

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

@ aPosObj[3,1]+10,aPosObj[3,2]+585 Button "&Imprimir"    Size 60,15 Action ImpCons() of oDlg1 Pixel //Localiza o Dia

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

AaDd(aDadosExcel,{ "Empresa","C.Custo",;
"Descricao",;
"Natureza",;
"Documento",;
"Dt.Entrada",;
"Vencimento",;
"Fornecedor",;
"Loja",;
"Razao Social",;
"Vlr. IPI",;
"Vlr. Total" })

nCol := Len(aDadosExcel[1])

DbSelectArea("TRB")
DbGoTop()

ProcRegua(RecCount())        // Total de Elementos da regua

While TRB->(!EOF())
	
	AaDD( aDadosExcel, { TRB->EMPRESA,TRB->CC,;
	TRB->DESC,;
	TRB->NATUREZ,;
	Substr(TRB->DOC,4,9) ,;
	Dtoc(TRB->DTDIGIT) ,;
	Dtoc(TRB->DTVENCTO) ,;
	TRB->FORNECE,;
	TRB->LOJA,;
	TRB->NOME,;
	Transform(TRB->VALIPI,"@e 999,999.99"),;
	Transform(TRB->TOTAL,"@e 99,999,999.99") }  )
	
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
AaDd(aCampos,{"DOC"      ,"C", 13,0})
AaDd(aCampos,{"CC"       ,"C",  9,0})
AaDd(aCampos,{"DESC"     ,"C", 20,0})
AaDd(aCampos,{"DTDIGIT"  ,"D",  8,0})
AaDd(aCampos,{"VALIPI"   ,"N", 11,2})
AaDd(aCampos,{"TOTAL"    ,"N", 17,2})
AaDd(aCampos,{"NOME"     ,"C", 30,0})
AaDd(aCampos,{"FORNECE"  ,"C",  6,0})
AaDd(aCampos,{"LOJA"     ,"C",  2,0})
AaDd(aCampos,{"DTVENCTO" ,"D",  8,0})
AaDd(aCampos,{"EMPRESA"  ,"C",  2,0})
AaDd(aCampos,{"NATUREZ"  ,"C", 10,0})

cArqTmp := CriaTrab(aCampos,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria o arquivo de Trabalhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

DbUseArea(.T.,,cArqTmp,"TRB",.F.,.F.)
IndRegua("TRB",cArqTmp,"EMPRESA+CC+DTOS(DTVENCTO)+DOC+FORNECE+LOJA",,,"Selecionando Registros..." )

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

nTipoRel := Escolha()

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

If nTipoRel == 1
	
	nVlrCC := 0
	nVlrTot := 0
	
	DbSelectArea("TRB")
	DbGotop()
	
	ProcRegua(RecCount())        // Total de Elementos da regua
	
	While TRB->(!EOF())
		
		
		If lFirst
			oPrn:StartPage()
			cTitulo := "Relatorio de Contas a Pagar por C.Custo "
			cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
			cNomEmp := SM0->M0_NOMECOM
			aTit    := {cTitulo,cNomEmp,cRod}
			nPag++
			U_CabRel(aTit,1,oPrn,nPag,"")
			
			CabCons(oPrn,1)
			
			lFirst = .F.
			
		EndIf
		
		nVlrCC := 0
		lPri := .T.
		cCC := TRB->CC
		
		While TRB->(!Eof()) .And. cCC == TRB->CC
			
			oPrn:Box(nLin,100,nLin+60,3300)
			
			oPrn:line(nLin, 350,nLin+60, 350)
			oPrn:line(nLin, 700,nLin+60, 700)
			oPrn:line(nLin, 900,nLin+60, 900)
			oPrn:line(nLin,1100,nLin+60,1100)
			oPrn:line(nLin,1200,nLin+60,1200)
			oPrn:line(nLin,1900,nLin+60,1900)
			oPrn:line(nLin,2100,nLin+60,2100)
			oPrn:line(nLin,2300,nLin+60,2300)
			oPrn:line(nLin,2550,nLin+60,2550)
			oPrn:line(nLin,2800,nLin+60,2800)
			oPrn:line(nLin,3050,nLin+60,3050)
			
			If lPri
				oPrn:Say(nLin+10,  110,TRB->CC       ,oFont9 ,100)
				oPrn:Say(nLin+10,  360,TRB->DESC     ,oFont9 ,100)
				lPri := .F.
			EndIf
			oPrn:Say(nLin+10,  710,Substr(TRB->DOC,4,9)+"-"+Substr(TRB->DOC,13,1) ,oFont9 ,100)
			oPrn:Say(nLin+10,  930,TRB->FORNECE    ,oFont9 ,100)
			oPrn:Say(nLin+10, 1120,TRB->LOJA       ,oFont9 ,100)
			oPrn:Say(nLin+10, 1220,TRB->NOME        ,oFont9 ,100)
			oPrn:Say(nLin+10, 1920,TRB->NATUREZ   ,oFont9 ,100)
			oPrn:Say(nLin+10, 2120,Dtoc(TRB->DTDIGIT)   ,oFont9 ,100)
			oPrn:Say(nLin+10, 2380,Dtoc(TRB->DTVENCTO) ,oFont9 ,100)
			oPrn:Say(nLin+10, 2580,Transform(TRB->TOTAL,"@e 999,999,999.99" )  ,oFont9 ,100)
			oPrn:Say(nLin+10, 2880,Transform(TRB->VALIPI,"@e 999,999,999.99" ) ,oFont9 ,100)
			oPrn:Say(nLin+10, 3080,Transform(TRB->TOTAL+TRB->VALIPI,"@e 999,999,999.99" ) ,oFont9 ,100)
			
			nLin += 60
			
			nVlrCC  += TRB->TOTAL+TRB->VALIPI
			nVlrTot += TRB->TOTAL+TRB->VALIPI
			
			If nLin > 2200
				oPrn:EndPage()
				
				oPrn:StartPage()
				cTitulo := "Relatorio de Contas a Pagar por C.Custo "
				cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
				cNomEmp := SM0->M0_NOMECOM
				aTit    := {cTitulo,cNomEmp,cRod}
				nPag++
				U_CabRel(aTit,1,oPrn,nPag,"")
				
				CabCons(oPrn,1)
				
			EndIf
			
			DbSelectArea("TRB")
			DbSkip()
			
		End
		
		If nVlrCC > 0
			
			nLin += 20
			
			oPrn:Box(nLin,100,nLin+60,3300)
			
			oPrn:line(nLin,3050,nLin+60,3050)
			oPrn:Say(nLin+10, 120,"Total C.Custo " ,oFont9 ,100)
			oPrn:Say(nLin+10, 3080,Transform(nVlrCC ,"@e 999,999,999.99" ) ,oFont9 ,100)
			
			nLin += 80
			
		EndIf
		
	End
	
	If nVlrTot > 0
		
		nLin += 20
		
		oPrn:Box(nLin,100,nLin+60,3300)
		
		oPrn:line(nLin,3050,nLin+60,3050)
		oPrn:Say(nLin+10, 120,"Total Geral " ,oFont9 ,100)
		oPrn:Say(nLin+10, 3080,Transform(nVlrTot ,"@e 999,999,999.99" ) ,oFont9 ,100)
		
		nLin += 80
		
	EndIf
	
Else
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice para Gerar o relatorio                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cNomArq  := CriaTrab(nil,.f.)
	IndRegua("TRB",cNomArq,"EMPRESA+NATUREZ+DTOS(DTVENCTO)+CC+DOC+FORNECE+LOJA",,,"Selecionando Registros..." )
	
	nVlrNat := 0
	nVlrTot := 0
	
	DbSelectArea("TRB")
	DbGotop()
	
	ProcRegua(RecCount())        // Total de Elementos da regua
	
	While TRB->(!EOF())
		
		
		If lFirst
			oPrn:StartPage()
			cTitulo := "Relatorio de Contas a Pagar por Natureza "
			cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
			cNomEmp := SM0->M0_NOMECOM
			aTit    := {cTitulo,cNomEmp,cRod}
			nPag++
			U_CabRel(aTit,1,oPrn,nPag,"")
			
			CabCons(oPrn,1)
			
			lFirst = .F.
			
		EndIf
		
		nVlrNat := 0
		lPri := .T.
		cNaturez := TRB->NATUREZ
		
		While TRB->(!Eof()) .And. cNaturez == TRB->NATUREZ
			
			oPrn:Box(nLin,100,nLin+60,3300)
			
			oPrn:line(nLin, 350,nLin+60, 350)
			oPrn:line(nLin, 700,nLin+60, 700)
			oPrn:line(nLin, 900,nLin+60, 900)
			oPrn:line(nLin,1100,nLin+60,1100)
			oPrn:line(nLin,1200,nLin+60,1200)
			oPrn:line(nLin,1900,nLin+60,1900)
			oPrn:line(nLin,2100,nLin+60,2100)
			oPrn:line(nLin,2300,nLin+60,2300)
			oPrn:line(nLin,2550,nLin+60,2550)
			oPrn:line(nLin,2800,nLin+60,2800)
			oPrn:line(nLin,3050,nLin+60,3050)
			
			If lPri
				oPrn:Say(nLin+10,  110,TRB->NATUREZ   ,oFont9 ,100)
				cDescNat := Posicione("SED",1,xFilial("SED")+TRB->NATUREZ,"ED_DESCRIC")
				oPrn:Say(nLin+10,  360,cDescNat     ,oArialNeg06 ,100)
				lPri := .F.
			EndIf
			oPrn:Say(nLin+10,  710,Substr(TRB->DOC,4,9)        ,oFont9 ,100)
			oPrn:Say(nLin+10,  930,TRB->FORNECE    ,oFont9 ,100)
			oPrn:Say(nLin+10, 1120,TRB->LOJA       ,oFont9 ,100)
			oPrn:Say(nLin+10, 1220,TRB->NOME        ,oFont9 ,100)
			oPrn:Say(nLin+10, 1920,TRB->CC         ,oFont9 ,100)
			oPrn:Say(nLin+10, 2120,Dtoc(TRB->DTDIGIT)   ,oFont9 ,100)
			oPrn:Say(nLin+10, 2380,Dtoc(TRB->DTVENCTO) ,oFont9 ,100)
			oPrn:Say(nLin+10, 2580,Transform(TRB->TOTAL,"@e 999,999,999.99" )  ,oFont9 ,100)
			oPrn:Say(nLin+10, 2880,Transform(TRB->VALIPI,"@e 999,999,999.99" ) ,oFont9 ,100)
			oPrn:Say(nLin+10, 3080,Transform(TRB->TOTAL+TRB->VALIPI,"@e 999,999,999.99" ) ,oFont9 ,100)
			
			nLin += 60
			
			nVlrNat += TRB->TOTAL+TRB->VALIPI
			nVlrTot += TRB->TOTAL+TRB->VALIPI
			
			If nLin > 2200
				oPrn:EndPage()
				
				oPrn:StartPage()
				cTitulo := "Relatorio de Contas a Pagar por Natureza "
				cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
				cNomEmp := SM0->M0_NOMECOM
				aTit    := {cTitulo,cNomEmp,cRod}
				nPag++
				U_CabRel(aTit,1,oPrn,nPag,"")
				
				CabCons(oPrn,1)
				
			EndIf
			
			DbSelectArea("TRB")
			DbSkip()
			
		End
		
		If nVlrNat > 0
			
			nLin += 20
			
			oPrn:Box(nLin,100,nLin+60,3300)
			
			oPrn:line(nLin,3050,nLin+60,3050)
			oPrn:Say(nLin+10, 120,"Total Natureza " ,oFont9 ,100)
			oPrn:Say(nLin+10, 3080,Transform(nVlrNat ,"@e 999,999,999.99" ) ,oFont9 ,100)
			
			nLin += 80
			
		EndIf
		
	End
	
	If nVlrTot > 0
		
		nLin += 20
		
		oPrn:Box(nLin,100,nLin+60,3300)
		
		oPrn:line(nLin,3050,nLin+60,3050)
		oPrn:Say(nLin+10, 120,"Total Geral " ,oFont9 ,100)
		oPrn:Say(nLin+10, 3080,Transform(nVlrTot ,"@e 999,999,999.99" ) ,oFont9 ,100)
		
		nLin += 80
		
	EndIf
	
	//IndRegua("TRB",cArqTmp,"EMPRESA+CC+DTOS(DTVENCTO)+DOC+FORNECE+LOJA",,,"Selecionando Registros..." )
	
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

oPrn:FillRect({nLin,100,nLin+60,3300},oBrush)

oPrn:Box(nLin,100,nLin+60,3300)

oPrn:line(nLin, 350,nLin+60, 350)
oPrn:line(nLin, 700,nLin+60, 700)
oPrn:line(nLin, 900,nLin+60, 900)
oPrn:line(nLin,1100,nLin+60,1100)
oPrn:line(nLin,1200,nLin+60,1200)
oPrn:line(nLin,2100,nLin+60,2100)
oPrn:line(nLin,2300,nLin+60,2300)
oPrn:line(nLin,2550,nLin+60,2550)
oPrn:line(nLin,2800,nLin+60,2800)
oPrn:line(nLin,3050,nLin+60,3050)

If nTipoRel == 1
	oPrn:Say(nLin+10,  110,"C.Custo"     ,oFont5 ,100)
	oPrn:Say(nLin+10,  360,"Descricao"   ,oFont5 ,100)
	oPrn:Say(nLin+10,  730,"Titulo"     ,oFont5 ,100)
	oPrn:Say(nLin+10,  910,"Fornecedor"  ,oFont5 ,100)
	oPrn:Say(nLin+10, 1120,"Loja"        ,oFont5 ,100)
	oPrn:Say(nLin+10, 1220,"Nome"        ,oFont5 ,100)
	oPrn:Say(nLin+10, 1910,"Natureza"    ,oFont5 ,100)
	oPrn:Say(nLin+10, 2110,"Entrada"     ,oFont5 ,100)
	oPrn:Say(nLin+10, 2310,"Vencimento"  ,oFont5 ,100)
	oPrn:Say(nLin+10, 2580,"Vlr Liquido" ,oFont5 ,100)
	oPrn:Say(nLin+10, 2880,"Vlr IPI"     ,oFont5 ,100)
	oPrn:Say(nLin+10, 3080,"Vlr Total"   ,oFont5 ,100)
	
Else
	
	oPrn:Say(nLin+10,  110,"Natureza"    ,oFont5 ,100)
	oPrn:Say(nLin+10,  360,"Descricao"   ,oFont5 ,100)
	oPrn:Say(nLin+10,  730,"Titulo"     ,oFont5 ,100)
	oPrn:Say(nLin+10,  910,"Fornecedor"  ,oFont5 ,100)
	oPrn:Say(nLin+10, 1120,"Loja"        ,oFont5 ,100)
	oPrn:Say(nLin+10, 1220,"Nome"        ,oFont5 ,100)
	oPrn:Say(nLin+10, 1910,"C.Custo"    ,oFont5 ,100)
	oPrn:Say(nLin+10, 2110,"Entrada"     ,oFont5 ,100)
	oPrn:Say(nLin+10, 2310,"Vencimento"  ,oFont5 ,100)
	oPrn:Say(nLin+10, 2580,"Vlr Liquido" ,oFont5 ,100)
	oPrn:Say(nLin+10, 2880,"Vlr IPI"     ,oFont5 ,100)
	oPrn:Say(nLin+10, 3080,"Vlr Total"   ,oFont5 ,100)
	
EndIf

nLin += 60

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
@ 23,30 RADIO oRadio Var nRadio Items "C.Custo","Natureza" 3D SIZE 60,10 of oDlg2 Pixel

@ 080,075 BMPBUTTON TYPE 1 ACTION Close(oDlg2)
ACTIVATE DIALOG oDlg2 CENTER

Return nRadio

Static Function SelCusto(cItem)

Local aArea     := GetArea()
Local cCusto    := ""
Local cTipoCc   := ""
	
DbSelectArea("CTD")
DbSetOrder(1)

If DbSeek(xFilial("CTD") + cItem) 
	cCusto := CTD->CTD_CUSTO
EndIf

RestArea( aArea )

Return cCusto

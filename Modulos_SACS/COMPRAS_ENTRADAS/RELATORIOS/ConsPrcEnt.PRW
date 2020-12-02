#INCLUDE "RWMAKE.CH"
#Include "Protheus.ch"
#INCLUDE "colors.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConsPrcEntบAutor  ณCarlos R. Moreira   บ Data ณ  26/05/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o Arquivo para Exportar para Planilha de Excel        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ConsPrcEnt()
Local aSays     := {}
Local aButtons  := {}
Local nOpca     := 0
Local cCadastro := OemToAnsi("Consulta o Preco do Produto das Notas Entradas")

Private  cArqTxt
Private cPerg := "CONSPRC"

PutSx1(cPerg,"01","Data Inicial               ?","","","mv_ch1","D",  8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{{"Data Inicial de processamento "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"02","Data Final                 ?","","","mv_ch2","D",  8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{{"Data Final de processamento   "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"03","Fornecedor de              ?","","","mv_ch3","C",  6,0,0,"G","","SA2","","","mv_par03","","","","","","","","","","","","","","","","",{{"Cliente Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"04","Fornecedor Ate             ?","","","mv_ch4","C",  6,0,0,"G","","SA2","","","mv_par04","","","","","","","","","","","","","","","","",{{"Cliente Final  "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"05","Loja  De                   ?","","","mv_ch5","C",  2,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",{{"Loja    Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"06","Loja  Ate                  ?","","","mv_ch6","C",  2,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",{{"Loja    Final  "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"07","CC Inicial                 ?","","","mv_ch7","C",  9,0,0,"G","","CTT","","","mv_par07","","","","","","","","","","","","","","","","",{{"Produto Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"08","CC Final                   ?","","","mv_ch8","C",  9,0,0,"G","","CTT","","","mv_par08","","","","","","","","","","","","","","","","",{{"Produto Final  "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"09","Produto Inicial            ?","","","mv_ch9","C", 15,0,0,"G","","SB1","","","mv_par09","","","","","","","","","","","","","","","","",{{"Data Inicial de processamento "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"10","Produto Final              ?","","","mv_cha","C", 15,0,0,"G","","SB1","","","mv_par10","","","","","","","","","","","","","","","","",{{"Data Final de processamento   "}},{{" "}},{{" "}},"")

aHelpPor :=	{"Define se a exportacao de dados sera consolidada entre empresas"}
aHelpEsp :=	{}
aHelpEng :=	{}

PutSx1( cPerg, 	"11","Consolidas as Empresas  ?","Consolidas as Empresas ?","Consolidas as Empresas ?","mv_chf","N",1,0,1,"C","","","","",;
"mv_par11","Nao","","","","Sim","","",;
"","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

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
Local aArq := {{"SD1"," "},{"SF1"," "},{"SA2"," "},{"SB1"," "},{"SF4"," "},{"CTT"," "}}

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
cQuery += "         SA2.A2_NOME, SD1.D1_COD,SD1.D1_DESCR, CTT.CTT_DESC01, SD1.D1_COD, SF1.F1_COND, SD1.D1_QUANT   "

cQuery += " FROM "+ aArq[Ascan(aArq,{|x|x[1] = "SF1" }),2]+" SF1 " 

cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SD1" }),2]+" SD1 ON "
cQuery += "     SD1.D1_DOC = SF1.F1_DOC AND SD1.D1_SERIE = SF1.F1_SERIE AND "
cQuery += "     SD1.D1_FORNECE = SF1.F1_FORNECE AND SD1.D1_LOJA = SF1.F1_LOJA AND "
cQuery += "	    SD1.D1_CC  BETWEEN '"+MV_PAR07+"' And '"+mv_par08+"' AND "
cQuery += "	    SD1.D1_COD BETWEEN '"+MV_PAR09+"' And '"+mv_par10+"' AND "
cQuery += "     SD1.D_E_L_E_T_ <> '*' AND SD1.D1_TIPO = 'N'"

cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SA2" }),2]+" SA2 ON "
cQuery += "     SD1.D1_FORNECE = SA2.A2_COD AND SD1.D1_LOJA = SA2.A2_LOJA AND "
cQuery += "     SA2.D_E_L_E_T_ <> '*' "

cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SF4" }),2]+" SF4 ON "
cQuery += "     SD1.D1_TES = SF4.F4_CODIGO  AND SF4.F4_DUPLIC = 'S' AND "
cQuery += "     SF4.D_E_L_E_T_ <> '*' AND SF4.F4_FILIAL = SD1.D1_FILIAL"

cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SB1" }),2]+" SB1 ON "
cQuery += "     SD1.D1_COD = SB1.B1_COD  AND  "
cQuery += "     SB1.D_E_L_E_T_ <> '*' "

cQuery += " LEFT OUTER JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "CTT" }),2]+" CTT ON "
cQuery += "     SD1.D1_CC = CTT.CTT_CUSTO  AND "
cQuery += "     CTT.D_E_L_E_T_ <> '*' "

cQuery += " WHERE SF1.D_E_L_E_T_ <> '*' "
cQuery += "	And SF1.F1_DTDIGIT BETWEEN '"+Dtos(MV_PAR01)+"' And '"+Dtos(mv_par02)+"'"

cQuery := ChangeQuery(cQuery)

MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Gerando o arquivo empresa : "+cEmp )
TCSetField("QRY","D1_DTDIGIT","D")

nTotReg := 0
QRY->(dbEval({||nTotREG++}))
QRY->(dbGoTop())

DbSelectArea("QRY")
DbGotop()

ProcRegua(nTotReg)

While QRY->(!Eof())
	
	IncProc("Processando o Arquivo de trabalho..Emp: "+cEmp)
	
	nPrc := ( QRY->D1_TOTAL + QRY->D1_VALIPI ) / QRY->D1_QUANT 
	
	DbSelectArea("TRB")
	                                                                                                
	If ! DbSeek( cEmp+QRY->D1_COD+Str(999999999.9999-nPRC,17,6)+QRY->F1_COND+DTOS(QRY->D1_DTDIGIT)+QRY->D1_CC+QRY->D1_FORNECE+QRY->D1_LOJA )
		
		RecLock("TRB",.T.)
		TRB->CC       := QRY->D1_CC
		TRB->DESC     := QRY->CTT_DESC01 
		TRB->DTDIGIT  := QRY->D1_DTDIGIT

		TRB->FORNECE  := QRY->D1_FORNECE
		TRB->LOJA     := QRY->D1_LOJA
		TRB->NOME     := QRY->A2_NOME
		
		TRB->PRCUNIT  := nPrc 
		
		TRB->PROD     := QRY->D1_COD
		TRB->DESCPRD  := QRY->D1_DESCR
        TRB->COND     := QRY->F1_COND 
		
		TRB->EMPRESA  := cEmp
		
		MsUnlock()
		
	EndIf

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
AaDD(aBrowse,{"PROD","","Produto"})
AaDD(aBrowse,{"DESCPRD","","Descricao",""})

AaDD(aBrowse,{"CC","","C.Custo"})
AaDD(aBrowse,{"DESC","","Descricao",""})

AaDD(aBrowse,{"DTDIGIT","","Dt. Entrada",""})

AaDD(aBrowse,{"PRCUNIT" ,"","Vlr. Unit","@e 999,999.9999"})

AaDD(aBrowse,{"FORNECE","","Fornecedor",""})
AaDD(aBrowse,{"LOJA","","Loja",""})
AaDD(aBrowse,{"NOME","","Razao Social",""})

AaDD(aBrowse,{"COND","","C.Pagamento"})

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

DEFINE MSDIALOG oDlg1 TITLE "Consulta Preco de Produto Entrada" From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

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

@ aPosObj[3,1]+10,aPosObj[3,2]+520 Button "Exp Excel"    Size 60,15 Action ExpCons() of oDlg1 Pixel //Localiza o Dia

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

AaDd(aDadosExcel,{ "Empresa",;
"Produto",;
"Descricao",;
"C.Custo",;
"Descricao",;
"Dt.Entrada",;
"Preco Unit.",;
"Fornecedor",;
"Loja",;
"Razao Social",;
"Cond.Pagto" })

nCol := Len(aDadosExcel[1])

DbSelectArea("TRB")
DbGoTop()

ProcRegua(RecCount())        // Total de Elementos da regua

While TRB->(!EOF())
	
	AaDD( aDadosExcel, { TRB->EMPRESA,;
	TRB->PROD,;
	TRB->DESCPRD,;
	TRB->CC,;
	TRB->DESC,;
	Dtoc(TRB->DTDIGIT) ,;
	Transform(TRB->PRCUNIT,"@e 999,999.9999"),;
	TRB->FORNECE,;
	TRB->LOJA,;
	TRB->NOME,;
	TRB->COND  }  )
	
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
AaDd(aCampos,{"CC"       ,"C",  9,0})
AaDd(aCampos,{"DESC"     ,"C", 20,0})
AaDd(aCampos,{"DTDIGIT"  ,"D",  8,0})
AaDd(aCampos,{"PRCUNIT"  ,"N", 17,4})
AaDd(aCampos,{"FORNECE"  ,"C",  6,0})
AaDd(aCampos,{"LOJA"     ,"C",  3,0})
AaDd(aCampos,{"NOME"     ,"C", 30,0})
AaDd(aCampos,{"EMPRESA"  ,"C",  2,0})
AaDd(aCampos,{"PROD"     ,"C", 15,0})
AaDd(aCampos,{"DESCPRD"  ,"C", 30,0})
AaDd(aCampos,{"COND"     ,"C",  3,0})

cArqTmp := CriaTrab(aCampos,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria o arquivo de Trabalhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

DbUseArea(.T.,,cArqTmp,"TRB",.F.,.F.)
IndRegua("TRB",cArqTmp,"EMPRESA+PROD+Str(999999999.9999-PRCUNIT,17,6)+COND+DTOS(DTDIGIT)+CC+FORNECE+LOJA",,,"Selecionando Registros..." )

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
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice para Gerar o Romaneio                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cNomArq  := CriaTrab(nil,.f.)
	IndRegua("TRB",cNomArq,"FORNECE+LOJA+PROD+Dtos(DTDIGIT)",,,OemToAnsi("Selecionando Registros..."))	//
	
	
	DbSelectArea("TRB")
	DbGotop()
	
	ProcRegua(RecCount())        // Total de Elementos da regua
	
	While TRB->(!EOF())
		
		
		If lFirst
			oPrn:StartPage()
			cTitulo := "Relatorio de Preco de produto entrada - Fornecedor"
			cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
			cNomEmp := SM0->M0_NOMECOM
			aTit    := {cTitulo,cNomEmp,cRod}
			nPag++
			U_CabRel(aTit,1,oPrn,nPag,"")
			
			CabCons(oPrn,nTipoRel)
			
			lFirst = .F.
			
		EndIf
		
		lPri := .T.
		cFornece := TRB->FORNECE
		
		While TRB->(!Eof()) .And. cFornece == TRB->FORNECE 
			
			oPrn:Box(nLin,100,nLin+60,3300)
			
			oPrn:line(nLin, 250,nLin+60, 250)
			oPrn:line(nLin, 350,nLin+60, 350)
			oPrn:line(nLin, 900,nLin+60, 900)
			oPrn:line(nLin,1050,nLin+60,1050)
			oPrn:line(nLin,1700,nLin+60,1700)
			oPrn:line(nLin,1900,nLin+60,1900)
//			oPrn:line(nLin,2280,nLin+60,2280)
			oPrn:line(nLin,2350,nLin+60,2350)
//			oPrn:line(nLin,2550,nLin+60,2550)
			oPrn:line(nLin,2800,nLin+60,2800)
			oPrn:line(nLin,3050,nLin+60,3050)
			
			If lPri
				oPrn:Say(nLin+10,  110,TRB->FORNECE  ,oFont9 ,100)
				oPrn:Say(nLin+10,  260,TRB->LOJA     ,oFont9 ,100)
				oPrn:Say(nLin+10,  360,TRB->NOME     ,oFont9 ,100)
				lPri := .F.
			EndIf
			
			oPrn:Say(nLin+10,  910,TRB->PROD     ,oFont9 ,100)
			oPrn:Say(nLin+10, 1060,TRB->DESCPRD  ,oFont9 ,100)
			oPrn:Say(nLin+10, 1710,TRB->CC       ,oFont9 ,100)
			oPrn:Say(nLin+10, 1910,TRB->DESC     ,oFont9 ,100)
                                                              
            cDescCond := Posicione("SE4",1,xFilial("SE4")+TRB->COND,"E4_DESCRI")                                                          
			oPrn:Say(nLin+10, 2360,TRB->COND+" - "+cDescCond   ,oFont9 ,100)
			oPrn:Say(nLin+10, 2880,Dtoc(TRB->DTDIGIT)   ,oFont9 ,100)
//			oPrn:Say(nLin+10, 2880,Transform(TRB->QUANT,"@e 999,999,999.99" ) ,oFont9 ,100)
			oPrn:Say(nLin+10, 3080,Transform(TRB->PRCUNIT,"@e 999,999,999.9999" ) ,oFont9 ,100)
			
			nLin += 60
			
			If nLin > 2200
				oPrn:EndPage()
				
				oPrn:StartPage()
			    cTitulo := "Relatorio de Preco de produto entrada - Fornecedor"
				cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
				cNomEmp := SM0->M0_NOMECOM
				aTit    := {cTitulo,cNomEmp,cRod}
				nPag++
				U_CabRel(aTit,1,oPrn,nPag,"")
				
				CabCons(oPrn,nTipoRel)
				
			EndIf
			
			DbSelectArea("TRB")
			DbSkip()
			
		End
		
		nLin += 20
	End
	
ElseIf nTipoRel == 2
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice para Gerar o Romaneio                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cNomArq  := CriaTrab(nil,.f.)
	IndRegua("TRB",cNomArq,"PROD+FORNECE",,,OemToAnsi("Selecionando Registros..."))	//
	
	DbSelectArea("TRB")
	DbGotop()
	
	ProcRegua(RecCount())        // Total de Elementos da regua
	
	While TRB->(!EOF())
		
		
		If lFirst
			oPrn:StartPage()
			cTitulo := "Relatorio de Preco de produto entrada - Produtos"
			cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
			cNomEmp := SM0->M0_NOMECOM
			aTit    := {cTitulo,cNomEmp,cRod}
			nPag++
			U_CabRel(aTit,1,oPrn,nPag,"")
			
			CabCons(oPrn,nTipoRel)
			
			lFirst = .F.
			
		EndIf
		
		lPri := .T.
		cProduto := TRB->PROD
		
		While TRB->(!Eof()) .And. cProduto == TRB->PROD
			
			oPrn:Box(nLin,100,nLin+60,3300)
			
			oPrn:line(nLin, 250,nLin+60, 250)
			oPrn:line(nLin, 900,nLin+60, 900)
			oPrn:line(nLin,1100,nLin+60,1100)
			oPrn:line(nLin,1200,nLin+60,1200)
			oPrn:line(nLin,1700,nLin+60,1700)
			oPrn:line(nLin,1900,nLin+60,1900)
			oPrn:line(nLin,2350,nLin+60,2350)
			//oPrn:line(nLin,2550,nLin+60,2550)
			oPrn:line(nLin,2800,nLin+60,2800)
			oPrn:line(nLin,3050,nLin+60,3050)
			
			If lPri
				oPrn:Say(nLin+10,  110,TRB->PROD     ,oFont9 ,100)
				oPrn:Say(nLin+10,  260,TRB->DESCPRD  ,oFont9 ,100)
				lPri := .F.
			EndIf
			
			oPrn:Say(nLin+10,  920,TRB->FORNECE  ,oFont9 ,100)
			oPrn:Say(nLin+10, 1120,TRB->LOJA     ,oFont9 ,100)
			oPrn:Say(nLin+10, 1220,TRB->NOME     ,oFont9 ,100)
			
			oPrn:Say(nLin+10, 1710,TRB->CC     ,oFont9 ,100)
			oPrn:Say(nLin+10, 1910,TRB->DESC   ,oFont9 ,100)
			                                
            cDescCond := Posicione("SE4",1,xFilial("SE4")+TRB->COND,"E4_DESCRI")                                                          			
			oPrn:Say(nLin+10, 2380,TRB->COND+"- "+cDescCond  ,oFont9 ,100)

			oPrn:Say(nLin+10, 2880,Dtoc(TRB->DTDIGIT)   ,oFont9 ,100)
			oPrn:Say(nLin+10, 3080,Transform(TRB->PRCUNIT,"@e 999,999,999.99" ) ,oFont9 ,100)
			
			nLin += 60
			
			If nLin > 2200
				oPrn:EndPage()
				
				oPrn:StartPage()
			    cTitulo := "Relatorio de Preco de produto entrada - Produtos"
				cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
				cNomEmp := SM0->M0_NOMECOM
				aTit    := {cTitulo,cNomEmp,cRod}
				nPag++
				U_CabRel(aTit,1,oPrn,nPag,"")
				
				CabCons(oPrn,nTipoRel)
				
			EndIf
			
			DbSelectArea("TRB")
			DbSkip()
			
		End
		
		nLin += 20
		
	End
	
	
Else
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice para Gerar o Romaneio                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cNomArq  := CriaTrab(nil,.f.)
	IndRegua("TRB",cNomArq,"CC+PROD+FORNECE",,,OemToAnsi("Selecionando Registros..."))	//

	DbSelectArea("TRB")
	DbGotop()
	
	ProcRegua(RecCount())        // Total de Elementos da regua
	
	While TRB->(!EOF())
		
		
		If lFirst
			oPrn:StartPage()
			cTitulo := "Relatorio de Preco de produto entrada - C.Custo"
			cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
			cNomEmp := SM0->M0_NOMECOM
			aTit    := {cTitulo,cNomEmp,cRod}
			nPag++
			U_CabRel(aTit,1,oPrn,nPag,"")
			
			CabCons(oPrn,3)
			
			lFirst = .F.
			
		EndIf
		
		lPri := .T.
		cCC    := TRB->CC
		
		While TRB->(!Eof()) .And. cCC == TRB->CC 
			
			oPrn:Box(nLin,100,nLin+60,3300)
			
			oPrn:line(nLin, 250,nLin+60, 250)
			oPrn:line(nLin, 900,nLin+60, 900)
			oPrn:line(nLin,1100,nLin+60,1100)                  
			oPrn:line(nLin,1200,nLin+60,1200)
			oPrn:line(nLin,1700,nLin+60,1700)
			oPrn:line(nLin,1900,nLin+60,1900)

			oPrn:line(nLin,2350,nLin+60,2350)

			oPrn:line(nLin,2800,nLin+60,2800)
			oPrn:line(nLin,3050,nLin+60,3050)
			
			If lPri
				oPrn:Say(nLin+10,  110,TRB->CC       ,oFont9 ,100)
				oPrn:Say(nLin+10,  360,TRB->DESC     ,oFont9 ,100)
				lPri := .F.
			EndIf
			
			oPrn:Say(nLin+10,  920,TRB->FORNECE  ,oFont9 ,100)
			oPrn:Say(nLin+10, 1120,TRB->LOJA     ,oFont9 ,100)
			oPrn:Say(nLin+10, 1220,TRB->NOME     ,oFont9 ,100)
			
			oPrn:Say(nLin+10, 1710,TRB->PROD  ,oFont9 ,100)
			oPrn:Say(nLin+10, 1910,Substr(TRB->DESCPRD,1,25)   ,oFont9 ,100)

            cDescCond := Posicione("SE4",1,xFilial("SE4")+TRB->COND,"E4_DESCRI")                                                          			
			oPrn:Say(nLin+10, 2380,TRB->COND+"- "+cDescCond  ,oFont9 ,100)

			oPrn:Say(nLin+10, 2880,Dtoc(TRB->DTDIGIT)   ,oFont9 ,100)
			oPrn:Say(nLin+10, 3080,Transform(TRB->PRCUNIT,"@e 999,999,999.99" ) ,oFont9 ,100)
			
			nLin += 60
			
			If nLin > 2200
				oPrn:EndPage()
				
				oPrn:StartPage()
			    cTitulo := "Relatorio de Preco de produto entrada - C.Custo"
				cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
				cNomEmp := SM0->M0_NOMECOM
				aTit    := {cTitulo,cNomEmp,cRod}
				nPag++
				U_CabRel(aTit,1,oPrn,nPag,"")
				
				CabCons(oPrn,3)
				
			EndIf
			
			DbSelectArea("TRB")
			DbSkip()
			
		End
		
		nLin += 20
		
	End
	
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

If nModo == 1
	
	oPrn:line(nLin, 250,nLin+60, 250)
	oPrn:line(nLin, 350,nLin+60, 350)
	oPrn:line(nLin, 900,nLin+60, 900)
	oPrn:line(nLin,1050,nLin+60,1050)
	oPrn:line(nLin,1700,nLin+60,1700)
	oPrn:line(nLin,1900,nLin+60,1900)
//	oPrn:line(nLin,2280,nLin+60,2280)
	oPrn:line(nLin,2350,nLin+60,2350)
//	oPrn:line(nLin,2550,nLin+60,2550)
	oPrn:line(nLin,2800,nLin+60,2800)
	oPrn:line(nLin,3050,nLin+60,3050)
	
	oPrn:Say(nLin+10,  110,"Fornec."   ,oFont5 ,100)
	oPrn:Say(nLin+10,  260,"Loja"         ,oFont5 ,100)
	oPrn:Say(nLin+10,  360,"Nome"         ,oFont5 ,100)
	oPrn:Say(nLin+10,  920,"Produto"      ,oFont5 ,100)
	oPrn:Say(nLin+10, 1120,"Descricao"    ,oFont5 ,100)
	oPrn:Say(nLin+10, 1730,"C.Custo"      ,oFont5 ,100)
	oPrn:Say(nLin+10, 1910,"Descricao"    ,oFont5 ,100)
//	oPrn:Say(nLin+10, 2290,"Mov"          ,oFont5 ,100)
	oPrn:Say(nLin+10, 2380,"Cond Pagto"    ,oFont5 ,100)
	oPrn:Say(nLin+10, 2880,"Dt Movimento" ,oFont5 ,100)
//	oPrn:Say(nLin+10, 2810,"Quantidade"   ,oFont5 ,100)
	oPrn:Say(nLin+10, 3080,"Preco Unit"        ,oFont5 ,100)
	
ElseIf nModo == 2
	
	oPrn:line(nLin, 250,nLin+60, 250)
	oPrn:line(nLin, 900,nLin+60, 900)
	oPrn:line(nLin,1100,nLin+60,1100)
	oPrn:line(nLin,1200,nLin+60,1200)
	oPrn:line(nLin,1700,nLin+60,1700)
	oPrn:line(nLin,1900,nLin+60,1900)
	oPrn:line(nLin,2350,nLin+60,2350)
	oPrn:line(nLin,2550,nLin+60,2550)
	oPrn:line(nLin,2800,nLin+60,2800)
	oPrn:line(nLin,3050,nLin+60,3050)
	
	oPrn:Say(nLin+10,  110,"Produto"       ,oFont5 ,100)
	oPrn:Say(nLin+10,  260,"Descricao"     ,oFont5 ,100)
	oPrn:Say(nLin+10,  930,"Fornedor"   ,oFont5 ,100)
	oPrn:Say(nLin+10, 1120,"Loja"         ,oFont5 ,100)
	oPrn:Say(nLin+10, 1220,"Nome"         ,oFont5 ,100)
	oPrn:Say(nLin+10, 1730,"C.Custo"      ,oFont5 ,100)
	oPrn:Say(nLin+10, 1910,"Descricao"    ,oFont5 ,100)
	oPrn:Say(nLin+10, 2380,"Cond Pagto"    ,oFont5 ,100)
	oPrn:Say(nLin+10, 2810,"Dt Movimento" ,oFont5 ,100)
	oPrn:Say(nLin+10, 3080,"Prc. Unit"    ,oFont5 ,100)
	
ElseIf nModo == 3
	
	oPrn:line(nLin, 250,nLin+60, 250)
	oPrn:line(nLin, 900,nLin+60, 900)
	oPrn:line(nLin,1100,nLin+60,1100)
	oPrn:line(nLin,1200,nLin+60,1200)
	oPrn:line(nLin,1700,nLin+60,1700)
	oPrn:line(nLin,1900,nLin+60,1900)
	oPrn:line(nLin,2350,nLin+60,2350)
	oPrn:line(nLin,2800,nLin+60,2800)
	oPrn:line(nLin,3050,nLin+60,3050)
	
	oPrn:Say(nLin+10,  110,"C.Custo"     ,oFont5 ,100)
	oPrn:Say(nLin+10,  360,"Descricao"   ,oFont5 ,100)
	oPrn:Say(nLin+10,  930,"Fornecedor"  ,oFont5 ,100)
	oPrn:Say(nLin+10, 1120,"Loja"        ,oFont5 ,100)
	oPrn:Say(nLin+10, 1220,"Nome"        ,oFont5 ,100)
	oPrn:Say(nLin+10, 1730,"Produto"     ,oFont5 ,100)
	oPrn:Say(nLin+10, 1910,"Descricao"   ,oFont5 ,100)
	oPrn:Say(nLin+10, 2380,"Cond Pagto"    ,oFont5 ,100)
	oPrn:Say(nLin+10, 2880,"Dt Movimento" ,oFont5 ,100)
	oPrn:Say(nLin+10, 3080,"Prc Unit"        ,oFont5 ,100)
	
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
ฑฑบUso       ณ Especifico Gtex                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Escolha()
Local oDlg2
Private nRadio := 1
Private oRadio

@ 0,0 TO 200,250 DIALOG oDlg2 TITLE "Modelo de Relatorio"

@ 05,05 TO 67,120 TITLE "Selecione a Ordem"
@ 18,30 RADIO oRadio Var nRadio Items "Fornecedor","Produto","C.Custo" 3D SIZE 60,10 of oDlg2 Pixel //,"Dt Entrada"

@ 080,075 BMPBUTTON TYPE 1 ACTION Close(oDlg2)
ACTIVATE DIALOG oDlg2 CENTER

Return nRadio



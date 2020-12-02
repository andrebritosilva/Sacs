#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PGPER02   ºAutor  ³Carlos R. Moreira   º Data ³  26/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ira gerar a relacao de Salarios                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PGPER02A()

Local aSays     := {}
Local aButtons  := {}
Local nOpca     := 0
Local cCadastro := OemToAnsi("Processa a relação de salarios")
Private  cArqTxt
Private cPerg := "PGPER02"

PutSx1(cPerg,"01","CC Inicial                 ?","","","mv_ch1","C",  9,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{{"Mes de processamento "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"02","CC Final                   ?","","","mv_ch2","C",  9,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{{"Data Final de processamento   "}},{{" "}},{{" "}},"")

aHelpPor :=	{"Define se a exportacao de dados sera consolidada entre empresas"}
aHelpEsp :=	{}
aHelpEng :=	{}

PutSx1( cPerg, 	"03","Consolidas as Empresas  ?","Consolidas as Empresas ?","Consolidas as Empresas ?","mv_ch2","N",1,0,1,"C","","","","",;
"mv_par03","Nao","","","","Sim","","",;
"","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{"Define a seleçao dos funcionarios"}
aHelpEsp :=	{}
aHelpEng :=	{}

PutSx1( cPerg, 	"04","Somente Funcionarios  ?","Consolidas as Empresas ?","Consolidas as Empresas ?","mv_ch4","N",1,0,1,"C","","","","",;
"mv_par04","Ativos","","","","Demitidos","","",;
"Ambos","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

Pergunte(cPerg,.F.)

Aadd(aSays, OemToAnsi(" Este programa ira processar o arquivo de Cadastro de Funcionarios "))
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Proc_Arq  ºAutor  ³Carlos R. Moreira   º Data ³  30/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ira gerar a Query de cada empresa e consolidar             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Gtex                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Proc_Arq(cEmp)
Local aNomArq := {}
Local aArq := {{"SRA"," "},{"SRJ"," "},{"CTT"," "},{"SX5"," "} } 

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

cQuery := "Select SRA.RA_FILIAL, SRA.RA_CC,SRA.RA_MAT, SRA.RA_NOME, SRA.RA_ADMISSA,SRA.RA_SALARIO,SRA.RA_SEXO,SRA.RA_CODFUNC,SRA.RA_NASC,SRA.RA_CIC, "
cQuery += "SRA.RA_RG, SRA.RA_ESTCIVI,SRA.RA_PIS,SRA.RA_DEMISSA,SRA.RA_VCTOEXP,SRA.RA_VCTEXP2, SRA.RA_EXAMEDI,SRA.RA_DTVTEST, SRA.RA_AVPRINI, SRA.RA_AVPRFIM, "
cQuery += "SRA.RA_GRINRAI, ISNULL(SX5INS.X5_DESCRI,' ') X5_DESINS, "
cQuery += "SRA.RA_SITFOLH,ISNULL(SRJ.RJ_DESC,' ') RJ_DESC,ISNULL(SRJ.RJ_CODCBO,' ') RJ_CODCBO,CTT.CTT_DESC01,ISNULL(SX5.X5_DESCRI,' ') X5_DESCRI From "+ aArq[Ascan(aArq,{|x|x[1] = "SRA" }),2]+" SRA " 
cQuery += "JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "CTT" }),2]+" CTT  ON "
cQuery += "     CTT.D_E_L_E_T_ <> '*' AND SRA.RA_CC  = CTT.CTT_CUSTO "
cQuery += "LEFT OUTER JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SRJ" }),2]+" SRJ ON "
cQuery += "    SRA.RA_CODFUNC = SRJ.RJ_FUNCAO And SRJ.D_E_L_E_T_ <> '*' "

cQuery += "LEFT OUTER JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SX5" }),2]+" SX5 ON "
cQuery += "    SRJ.RJ_CODCBO = SX5.X5_CHAVE  And SX5.X5_TABELA = 'Z2' And SX5.D_E_L_E_T_ <> '*' "

cQuery += "LEFT OUTER JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SX5" }),2]+" SX5INS ON "
cQuery += "    SRA.RA_GRINRAI = SX5INS.X5_CHAVE  And SX5INS.X5_TABELA = '26' And SX5INS.D_E_L_E_T_ <> '*' "

cQuery += "Where SRA.D_E_L_E_T_ <> '*'  And SRA.RA_CC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
If MV_PAR04 # 3 
   If MV_PAR04 == 1 
      cQuery += " AND  ( SRA.RA_SITFOLH = ' ' OR SRA.RA_SITFOLH = 'F' OR SRA.RA_SITFOLH = 'A' )  "
   Else
      cQuery += " AND  ( SRA.RA_SITFOLH = 'D' )  "
   EndIf    
EndIf 
cQuery += " Order by SRA.RA_NOME  "

cQuery := ChangeQuery(cQuery)

MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")
TCSetField("QRY","RA_ADMISSA","D")
TCSetField("QRY","RA_NASC","D")    
TCSetField("QRY","RA_DEMISSA","D")

TCSetField("QRY","RA_VCTOEXP","D")
TCSetField("QRY","RA_VCTEXP2","D")
TCSetField("QRY","RA_EXAMEDI","D")
TCSetField("QRY","RA_DTVTEST","D")

TCSetField("QRY","RA_AVPRINI","D")
TCSetField("QRY","RA_AVPRFIM","D")

nTotReg := 0
QRY->(dbEval({||nTotREG++}))
QRY->(dbGoTop())

DbSelectArea("QRY")
DbGotop()

ProcRegua(nTotReg)

While QRY->(!Eof())
	
	IncProc("Processando o Arquivo de trabalho..Emp: "+cEmp)
	
	//Necessito gravar somente um registro por empresa
	DbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->EMPRESA := cEmp
	TRB->MAT     := QRY->RA_MAT
	TRB->CC      := QRY->RA_CC
    TRB->DESC_CC := QRY->CTT_DESC01
	TRB->NOME    := QRY->RA_NOME
	TRB->NASC    := QRY->RA_NASC
	TRB->SEXO    := QRY->RA_SEXO
	TRB->ADMISSA := QRY->RA_ADMISSA 
	TRB->DEMISSA := QRY->RA_DEMISSA 	
    TRB->CODFUNC := QRY->RA_CODFUNC
	TRB->CARGO   := QRY->RJ_DESC
	TRB->SALARIO := QRY->RA_SALARIO
	TRB->SITFOLH  := QRY->RA_SITFOLH 
	TRB->CPF      := QRY->RA_CIC
	TRB->RG       := QRY->RA_RG
	TRB->ESTCIVI  := QRY->RA_ESTCIVI           
	TRB->PIS      := QRY->RA_PIS
	TRB->CODCBO   := QRY->RJ_CODCBO
	TRB->DESCBO   := QRY->X5_DESCRI 

	TRB->VCTOEXP  := QRY->RA_VCTOEXP
	TRB->VCTEXP2  := QRY->RA_VCTEXP2
	TRB->EXAMEDI  := QRY->RA_EXAMEDI
	TRB->DTVTEST  := QRY->RA_DTVTEST

	TRB->AVPRINI  := QRY->RA_AVPRINI
	TRB->AVPRFIM  := QRY->RA_AVPRFIM
	
	TRB->GRAUIN   := QRY->RA_GRINRAI  
	TRB->DESGRAU  := QRY->X5_DESINS 

	DbSelectArea("QRY")
	DbSkip()
	
End

QRY->(DbCloseArea())

(cAliasTrb)->(DbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRIARQTMP ºAutor  ³Carlos R. Moreira   º Data ³  05/30/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria o arquivo de trabalho                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Gtex                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CriaArqTmp()
Local aCampos := {}

AaDd(aCampos,{"OK"       ,"C",  2,0})
AaDd(aCampos,{"EMPRESA"  ,"C",  2,0})
AaDd(aCampos,{"MAT"      ,"C",  6,0})
AaDd(aCampos,{"CC"       ,"C",  9,0})
AaDd(aCampos,{"DESC_CC"  ,"C", 20,0})
AaDd(aCampos,{"NOME"     ,"C", 40,0})
AaDd(aCampos,{"NASC"     ,"D",  8,0})
AaDd(aCampos,{"ADMISSA"  ,"D",  8,0}) 
AaDd(aCampos,{"DEMISSA"  ,"D",  8,0})
AaDd(aCampos,{"CPF"      ,"C", 11,0})
AaDd(aCampos,{"CODFUNC"  ,"C",  5,0})
AaDd(aCampos,{"CARGO"    ,"C", 20,0})
AaDd(aCampos,{"SEXO"     ,"C",  1,0})
AaDd(aCampos,{"SALARIO"  ,"N", 17,2})
AaDd(aCampos,{"DEPTO"    ,"C", 15,0})
AaDd(aCampos,{"SITFOLH"  ,"C",  1,0})
AaDd(aCampos,{"RG"       ,"C", 15,0}) 
AaDd(aCampos,{"ESTCIVI"  ,"C",  1,0}) 
AaDd(aCampos,{"PIS"      ,"C", 11,0}) 
AaDd(aCampos,{"CODCBO"   ,"C",  6,0}) 
AaDd(aCampos,{"DESCBO"   ,"C", 30,0})

AaDd(aCampos,{"VCTOEXP"  ,"D",  8,0})
AaDd(aCampos,{"VCTEXP2"  ,"D",  8,0})
AaDd(aCampos,{"EXAMEDI"  ,"D",  8,0})
AaDd(aCampos,{"DTVTEST"  ,"D",  8,0})
AaDd(aCampos,{"DATAALT"  ,"D",  8,0})

AaDd(aCampos,{"AVPRINI"  ,"D",  8,0})
AaDd(aCampos,{"AVPRFIM"  ,"D",  8,0})

AaDd(aCampos,{"GRAUIN"   ,"C",  2,0}) 
AaDd(aCampos,{"DESGRAU"  ,"C", 20,0})


cArqTmp := CriaTrab(aCampos,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria o arquivo de Trabalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbUseArea(.T.,,cArqTmp,"TRB",.F.,.F.)
IndRegua("TRB",cArqTmp,"EMPRESA+MAT",,,"Selecionando Registros..." )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONS_NF   ºAutor  ³Microsiga           º Data ³  05/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
AaDD(aBrowse,{"CC","","Centro Custo"})
AaDD(aBrowse,{"DESC_CC","","Descr. Centro Custo"})
AaDD(aBrowse,{"NASC","","Dt Nascimento"})
AaDD(aBrowse,{"SEXO","","Sexo"})
AaDD(aBrowse,{"ADMISSA","","Dt Admissao"}) 
AaDD(aBrowse,{"DEMISSA","","Dt demissao"})
AaDD(aBrowse,{"CODFUNC","","Cod.Funcao"})
AaDD(aBrowse,{"CPF"   ,"","C.P.F.","@R 999.999.999-99"})
AaDD(aBrowse,{"CARGO","","Cargo"})
AaDD(aBrowse,{"DEPTO","","Departamento"})
AaDD(aBrowse,{"SALARIO"   ,"","Salario","@e 99,999,999.99"})
AaDD(aBrowse,{"SITFOLH","","Sit Folha"})
AaDD(aBrowse,{"RG","","R.G."})
AaDD(aBrowse,{"ESTCIVI","","Est.Civil"}) 
AaDD(aBrowse,{"PIS","","Pis"}) 
AaDD(aBrowse,{"CODCBO","","CBO 2002"}) 
AaDD(aBrowse,{"DESCBO","","Desc. CBO 2002"})

AaDd(aBrowse,{"VCTOEXP","","Vencto Exp"})
AaDd(aBrowse,{"VCTEXP2","","Vencto Exp 2"})
AaDd(aBrowse,{"EXAMEDI","","Vencto Exame Medico"})
AaDd(aBrowse,{"DTVTEST","","Vencto Estabilidade"})
AaDd(aBrowse,{"DATAALT","","Ult Alt Salario"})

AaDd(aBrowse,{"AVPRINI","","Dt Inicio Av Previo"})
AaDd(aBrowse,{"AVPRFIM","","Dt Final Av Previo"})

AaDd(aBrowse,{"GRAUIN","","Grau Instr"})
AaDd(aBrowse,{"DESGRAU","","Descricao Grau"})

DbSelectArea("TRB")
DbGoTop()

cMarca   := GetMark()
nOpca    :=0
lInverte := .F.
oFonte  := TFont():New( "TIMES NEW ROMAN",14.5,22,,.T.,,,,,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a  tela com o tree da origem e com o tree do destino    ³
//³resultado da comparacao.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//aAdd( aObjects, { 100, 100, .T., .T., .F. } )
//aAdd( aObjects, { 100, 100, .T., .T., .F. } )
//aInfo  := { aSize[1],aSize[2],aSize[3],aSize[4],3,3 }
//aPosObj:= MsObjSize( aInfo, aObjects, .T.,.T. )

AADD(aObjects,{100,025,.T.,.F.})
AADD(aObjects,{100,100,.T.,.T.})
AAdd( aObjects, { 0, 40, .T., .F. } )

aPosObj:=MsObjSize(aInfo,aObjects)

DEFINE MSDIALOG oDlg1 TITLE "Demostra os Indicadores" From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Passagem do parametro aCampos para emular tamb‚m a markbrowse para o ³
//³ arquivo de trabalho "TRB".                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oMark := MsSelect():New("TRB","","",aBrowse,@lInverte,@cMarca,{aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]})  //35,3,213,385

oMark:bMark := {| | fa060disp(cMarca,lInverte)}
oMark:oBrowse:lhasMark = .t.
oMark:oBrowse:lCanAllmark := .t.
oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

//@ aPosObj[1,1]+10,aPosObj[1,4]-210 Button "&Imprimir"    Size 60,15 Action ImprIndice() of oDlg1 Pixel //Localiza o Dia

@ aPosObj[1,1]+10,aPosObj[1,4]-140 Button "&Excel"    Size 60,15 Action ExpCons() of oDlg1 Pixel //Localiza o Dia

@ aPosObj[1,1]+10,aPosObj[1,4]-70 Button "&Fechar"    Size 60,15 Action {||oDlg1:End()} of oDlg1 Pixel //Localiza o Dia

ACTIVATE MSDIALOG oDlg1 CENTERED //ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||oDlg1:End()},.T.) CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONS_NF   ºAutor  ³Microsiga           º Data ³  05/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ExpCons()
Private aDadosExcel := {}

AaDd(aDadosExcel,{ "Empresa",;
"Centro Custo",;
"Descr. Centro Custo",;
"Matricula",;
"Nome",;
"Dt Admissao",;            
"Dt Demissao",;
"Cod.Funcao",;
"Cargo",;
"Salario",;
"Sit.Folha",;
"C.P.F.",;
"Dt Nasc",;
"R.G",;
"Est.Civil" ,;
"Sexo",;
"Pis" ,;
"CBO" ,;
"Desc. CBO",;
"Vencto Exp",;
"Vencto Exp 2",;
"Vencto Exame Medico",;
"Vencto Estabilidade",;
"Ult Alt Salario",;
"Dt Inicio Av Previo",;
"Dt Final Av Previo",;
"Grau Instr",;
"Desc Grau"})

nCol := Len(aDadosExcel[1])

DbSelectArea("TRB")
DbGoTop()

ProcRegua(RecCount())        // Total de Elementos da regua

While TRB->(!EOF())
	
	AaDD( aDadosExcel, { TRB->EMPRESA,;
	TRB->CC,;
	TRB->DESC_CC,;
	TRB->MAT,;
	TRB->NOME,;
	Dtoc(TRB->ADMISSA),;
	Dtoc(TRB->DEMISSA),;	
	TRB->CODFUNC,;
	TRB->CARGO,;
	Transform(TRB->SALARIO,"@E 999,999,999.99" ) ,;
	TRB->SITFOLH ,;
	Transform(TRB->CPF,"@R 999.999.999-99"),;
	Dtoc(TRB->NASC),;
	TRB->RG,;
	TRB->ESTCIVI,;
	TRB->SEXO,;
	TRB->PIS ,;
	TRB->CODCBO,;
	TRB->DESCBO ,;
	Dtoc(TRB->VCTOEXP),;
	Dtoc(TRB->VCTEXP2),;
	Dtoc(TRB->EXAMEDI),;
	Dtoc(TRB->DTVTEST),;
	Dtoc(TRB->DATAALT),;
	Dtoc(TRB->AVPRINI),;
	Dtoc(TRB->AVPRFIM),;
	TRB->GRAUIN,;
	TRB->DESGRAU})
	
	DbSelectArea("TRB")
	DbSkip()
	
End

Processa({||Run_Excel(aDadosExcel,nCol)},"Gerando a Integração com o Excel...")

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
		
		IncProc("Aguarde! Gerando arquivo de integração com Excel...") //
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
	MsgAlert( "Falha na criação do arquivo" ) //
Endif

Return

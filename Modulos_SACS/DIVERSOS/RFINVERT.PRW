#Include "Protheus.ch" 
#Include "RwMake.ch"
#Include "TbiConn.ch"         

/*BEGINDOC
**************************************************************************
* Programa  : RFINVERT 
* Autor     : Ana Paula Queiroga Faustino
* Descricao : Analise Vertical de Despesas
* Empresa   : SACS
* Data      : 17/06/2011
**************************************************************************
ENDDOC*/

User Function RFINVERT()

Local imprime := .T. 
Local aOrd    := {}
Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2  := "de acordo com os parametros informados pelo usuario."
Local cDesc3  := ""
Local cPict   := ""
Local titulo  := "Analise Vertical de Despesas"
Local nLin    := 80
Local Cabec1  := ""
Local Cabec2  := "Natureza  Grupo/Itens                                  Totais        % Grupo        % Total" 

Local cQry1     := ""
Local cQry2     := ""
Local aArea     := GetArea()
Local nTReg		:= 0
Local dData     := Ctod("00/00/00")
Local aNatureza := {}  
Local nTotPerc  := 0
Local cPeriodo  := Space(25)
Local cCusto    := Space(35)
Local cConsumo  := Space(20)

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "M"
Private nomeprog    := "RFINVERT" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RFINVERT" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString     := "SE2"  
Private cPerg		:= "RFINVERT"
Private _aReg		:= {} 

MV_PAR05 := "99/9999"
MV_PAR06 := "99/9999"

AjustaSX1(cPerg)
If !Pergunte(cPerg,.T.)
	Return
EndIf
cPeriodo := "Periodo: "+dtoc(MV_PAR01)+" ate "+dtoc(MV_PAR02)
cCusto   := "Centro Custo: "+MV_PAR03+ " ate "+MV_PAR04
cConsumo := "Consumo: "+MV_PAR05+" ate "+MV_PAR06

Cabec1 := "Periodo: "+dtoc(MV_PAR01)+" ate "+dtoc(MV_PAR02)+"     "+"Centro Custo: "+MV_PAR03+ " ate "+MV_PAR04+"     "+"Consumo: "+MV_PAR05+" ate "+MV_PAR06

RptStatus({|| Runreport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/******************************************************************/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,aNatureza)
/******************************************************************/
Local nOrdem
Local aOrd      := {}
Local nValor    := 0
Local nTotGer   := 0 
Local nRegistro := 0
Local aNatureza := {}  
Local nTotPerc  := 100
Local nSubTot   := 0

Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2  := "de acordo com os parametros informados pelo usuario."
Local cDesc3  := ""
Local cPict   := ""
Local titulo  := "Analise Vertical de Despesas"
Local nLin    := 80                      
Local Cabec1  := ""
Local Cabec2  := "Natureza Grupo/Itens                                   Totais        % Grupo        % Total"

Local cPeriodo:= Space(25)
Local cCusto  := Space(35)
Local cConsumo:= Space(20)

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "M"
Private nomeprog    := "RFINVERT" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RFINVERT" // Coloque aqui o nome do arquivo usado para impressao em disco

cPeriodo := "Periodo: "+dtoc(MV_PAR01)+" ate "+dtoc(MV_PAR02)
cCusto   := "Centro Custo: "+MV_PAR03+ " ate "+MV_PAR04
cConsumo := "Consumo: "+MV_PAR05+" ate "+MV_PAR06

Cabec1 := "Periodo: "+dtoc(MV_PAR01)+" ate "+dtoc(MV_PAR02)+"     "+"Centro Custo: "+MV_PAR03+ " ate "+MV_PAR04+"     "+"Consumo: "+MV_PAR05+" ate "+MV_PAR06

cQry1 := "SELECT SED.ED_CODIGO  AS CODIGO, "+CRLF
cQry1 += "		 SED.ED_DESCRIC AS DESCRICAO, "+CRLF
cQry1 += "		 SED.ED_TIPO    AS TIPO, "+CRLF
cQry1 += "		 SED.ED_PAI     AS PAI, "+CRLF
cQry1 += "       0              AS VALOR "+CRLF
cQry1 += "FROM "+RetSqlName("SED")+" SED "+CRLF
cQry1 += "WHERE SED.D_E_L_E_T_ = '' "+CRLF
cQry1 += "ORDER BY CODIGO, DESCRICAO,TIPO,PAI "+CRLF

//Executa query
cQry1 := ChangeQuery(cQry1)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry1),"TMP1",.T.,.T.)

dbSelectArea("TMP1")
dbGoTop()
nTReg := TMP1->(RecCount())
ProcRegua(nTReg)  

// MONTA ARRAY DE TODAS AS NATUREZAS
While !Eof()
	nPos := AScan(aNatureza,{|x| Trim(x[1]) == Trim(TMP1->CODIGO)})
	If nPos > 0 
		dbSkip()
	Else
		AAdd(aNatureza, {TMP1->CODIGO,TMP1->DESCRICAO,TMP1->TIPO,TMP1->PAI,TMP1->VALOR, nTotPerc, nTotPerc} ) 
		dbSkip()
	EndIf
EndDo

If MV_PAR05 == '  /    ' 
	MV_PAR05 := "       "
EndIf

cQry2 := "SELECT SE2.E2_NATUREZ AS CODIGO, "+CRLF
cQry2 += "		 SED.ED_DESCRIC AS DESCRICAO, "+CRLF
cQry2 += "		 SED.ED_TIPO    AS TIPO, "+CRLF
cQry2 += "		 SED.ED_PAI     AS PAI, "+CRLF
cQry2 += "		 SUM(SE2.E2_VLCRUZ) AS VALOR "+CRLF
cQry2 += "FROM "+RetSqlName("SE2")+" SE2 "+CRLF
cQry2 += "INNER JOIN "+RetSqlName("SED")+" SED ON SED.ED_CODIGO = SE2.E2_NATUREZ "+CRLF
cQry2 += "INNER JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_COD    = SE2.E2_FORNECE "+CRLF
cQry2 += "WHERE SE2.E2_BAIXA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' "+CRLF
cQry2 += "AND SE2.E2_CCD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "+CRLF
cQry2 += "AND SE2.E2_CONSUMO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "+CRLF
cQry2 += "AND SE2.E2_SALDO <> SE2.E2_VLCRUZ "+CRLF
cQry2 += "AND SE2.D_E_L_E_T_ = '' "+CRLF
cQry2 += "AND SA2.D_E_L_E_T_ = '' "+CRLF
cQry2 += "AND SED.D_E_L_E_T_ = '' "+CRLF
cQry2 += "GROUP BY SE2.E2_NATUREZ,SED.ED_DESCRIC,SED.ED_TIPO,SED.ED_PAI "+CRLF
cQry2 += "ORDER BY CODIGO, DESCRICAO, TIPO, PAI "+CRLF

//Executa query
cQry2 := ChangeQuery(cQry2)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry2),"TMP2",.T.,.T.)

//cQry2 += "AND SE2.E2_SALDO = 0 "+CRLF 
dbSelectArea("TMP2")
dbGoTop()
nTReg := TMP2->(RecCount())
ProcRegua(nTReg)  

// MONTA ARRAY DE TODAS AS NATUREZAS
//ADICIONA NO ARRAY OS VALORES CORRESPONDENTES A NATUREZA
While !Eof()

	If TMP2->PAI <> " "	
		nPos  := AScan(aNatureza,{|x| Trim(x[1]) == Trim(TMP2->CODIGO)})
		If nPos > 0
			aNatureza[nPos][5] += TMP2->VALOR
		EndIf

		nPos1 := AScan(aNatureza,{|x| Trim(x[1]) == Trim(TMP2->PAI)})
		If nPos1 > 0 
			aNatureza[nPos1][5] += TMP2->VALOR
			//nSubTot := nSubTot + TMP2->VALOR
		EndIf
	EndIf		
	IncProc()		
	TMP2->(DbSkip()) 
EndDo

nSubTot := 0
DbGotop()
For nX := 1 To Len(aNatureza)
	cTIPO  := aNatureza[nX][3]
	nValor := aNatureza[nX][5]
	If cTIPO == '1' .and. nVALOR <> 0
		nSubTot := nSubTot + aNatureza[nX][5]
	EndIf
Next

DbGoTop()
For nX := 1 To Len(aNatureza) 	
	cTIPO  := aNatureza[nX][3]
	nValor := aNatureza[nX][5]
	If cTIPO == '1' .and. nVALOR <> 0
		nTOTGER := aNatureza[nX][5]
		aNatureza[nX][7] := ((aNatureza[nX][5]*100) / nSubTot)
		//nSubTot := nSubTot + aNatureza[nX][5]
	EndIf
	If cTipo == '2'
		nTOTLIN := ((aNatureza[nX][5]*100) / nTOTGER)
		aNatureza[nX][6] := nTOTLIN
		aNatureza[nX][7] := ((aNatureza[nX][5]*100) / nSubTot)
	EndIf
Next
	
//Ativando Módulo Impressora
wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbGoTop()
If lAbortPrint
	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	Return
Endif

If nLin > 70 // Salto de Página. Neste caso o formulario tem 60 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif     

// Coloque aqui a logica da impressao do seu programa...
// Utilize PSAY para saida na impressora. Por exemplo:
// @nLin,00 PSAY SA1->A1_COD

For nX := 1 To Len(aNatureza)	
		
	If aNatureza[nX][5] > 0  .and. aNatureza[nX][3] == '1'
		nlin := nlin +4
		@ nlin,000 psay aNatureza[nX][1]
		@ nLin,010 psay aNatureza[nX][2]
		@ nlin,050 psay transform(aNatureza[nX][5],"@E 9,999,999.99")
		@ nlin,070 psay transform(aNatureza[nX][6],"@E 999.99")
		@ nlin,085 psay transform(aNatureza[nX][7],"@E 999.99")
		nlin := nlin + 1
		@ nlin,000 psay replicate("-",110)
	ElseIf aNatureza[nX][5] > 0  .and. aNatureza[nX][3] == '2'
		nlin := nlin +1
		@ nlin,000 psay aNatureza[nX][1]
		@ nLin,010 psay aNatureza[nX][2]
		@ nlin,050 psay Transform(aNatureza[nX][5],"@E 9,999,999.99")
		@ nlin,070 psay Transform(aNatureza[nX][6],"@E 999.99")
		@ nlin,085 psay transform(aNatureza[nX][7],"@E 999.99")
	EndIf

	If nLin > 70 // Salto de Página. Neste caso o formulario tem 70 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif     		
Next

nLin := nLin + 3 
@ nlin,020 psay "Total Geral ...............: "
@ nlin,050 psay transform(nSubTot,"@E 9,999,999.99")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)                                                                                                               
Endif

MS_FLUSH()

Return

/*************************************************************************
Função....: AjustaSX1
Autor.....: Ana Paula QFaustino
Data......: 10/05/2011
Descrição.: Ajusta o dicionario de perguntas (SX1)
Parâmetros: cPerg    => Grupo de Pergunta que está sendo ajustado
Retorno   : Nenhum
**************************************************************************/
Static Function AjustaSX1(cPerg)

PutSx1( cPerg, "01", "Data Baixa Inicial  ?", "Data Baixa Inicial  ?", "Data Baixa Inicial ?", "mv_ch1","D", 08, 0, 0, "G", "",   "", "", "", "mv_par01",,,,,,,,,,,,,,,,,{"Data da Baixa Inicial para",   "considerar na geração do relatório.", ""},{},{} )
PutSx1( cPerg, "02", "Data Baixa Final    ?", "Data Baixa Final    ?", "Data Baixa Final   ?", "mv_ch2","D", 08, 0, 0, "G", "",   "", "", "", "mv_par02",,,,,,,,,,,,,,,,,{"Data da Baixa Final para",     "considerar na geração do relatório.", ""},{},{} )
PutSx1( cPerg, "03", "Centro Custo Inicial?", "Centro Custo Inicial?", "Centro Custo Inicial?","mv_ch3","C", 09, 0, 0, "G", "","CTT", "", "", "mv_par03",,,,,,,,,,,,,,,,,{"Centro de Custo Inicial para", "considerar na geração do relatório.", ""},{},{} )
PutSx1( cPerg, "04", "Centro Custo Final  ?", "Centro Custo Final  ?", "Centro Custo Final  ?","mv_ch4","C", 09, 0, 0, "G", "","CTT", "", "", "mv_par04",,,,,,,,,,,,,,,,,{"Centro de Custo Final para",   "considerar na geração do relatório.", ""},{},{} )
PutSx1( cPerg, "05", "Mes/Consumo Inicial ?", "Mes/Consumo Inicial ?", "Mes/Consumo Inicial ?","mv_ch5","C", 07, 0, 0, "G", "",   "", "", "", "mv_par05",,,,,,,,,,,,,,,,,{"Mes/Consumo Inicial para",     "considerar na geração do relatório.", ""},{},{} )
PutSx1( cPerg, "06", "Mes/Consumo Final   ?", "Mes/Consumo Final   ?", "Mes/Consumo Final   ?","mv_ch6","C", 07, 0, 0, "G", "",   "", "", "", "mv_par06",,,,,,,,,,,,,,,,,{"Mes/Consumo Final para",       "considerar na geração do relatório.", ""},{},{} )

Return .T.

#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ _ENCFUN  º Autor ³ Cesar Padovani     º Data ³  15/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Encargos do Funcionario                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function _ENCFUN()

_lRet := .T.
_cStr := ""
// Verifica a existencia dos campos customizados
DbSelectArea("SX3")
DbSetOrder(2)
DbGoTop()
If !DbSeek("RA_PFHORA")
	_lRet := .F.
	_cStr := _cStr + "Campo: RA_PFHORA - Tipo: N - Tam: 12 - Dec: 2"+Chr(10)+Chr(13)
EndIf
If !DbSeek("RA_PFMES")
	_lRet := .F.
	_cStr := _cStr + "Campo: RA_PFMES - Tipo: N - Tam: 12 - Dec: 2"+Chr(10)+Chr(13)
EndIf
If !_lRet
	MsgInfo("É necerrário a criação dos campos abaixo: "+Chr(10)+Chr(13)+_cStr)
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2      := "de acordo com os parametros informados pelo usuario."
Private cDesc3      := "Encargos Funcionario"
Private cPict       := ""
Private titulo      := "Encargos Funcionario"
Private nLin        := 80
//Private Cabec1      := "R.A.   Nome                     Funcao               |           SALARIO            |Encargos Sociais Basicos |Enc.Sociais Rec.Incid.A  |Enc.Soc.Rec.Incid.Global A |Taxas e Reincidencias   |TOTAL 1       |TOTAL 2       |"
Private Cabec1      := "R.A.   Nome                                          |           SALARIO            |Encargos Sociais Basicos |Enc.Sociais Rec.Incid.A  |Enc.Soc.Rec.Incid.Global A |Taxas e Reincidencias   |TOTAL 1       |TOTAL 2       |"
Private Cabec2      := ""
Private imprime     := .T.
Private aOrd        := {} // {"Por Matricula","Por C.Custo"}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "_ENCFUN" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "_ENCFUN"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "_ENCFUN" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SRA"
Private cPerg       := "_ENCFUN"

DbSelectArea("SRA")
DbSetOrder(1)

ValidPerg()
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  02/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

_cSRA := RetSQLName("SRA")
_cSRJ := RetSQLName("SRJ")
_cQuery := ""
_cQuery += "SELECT "+_cSRA+".RA_MAT,"+_cSRA+".RA_CC,"+_cSRA+".RA_NOME,"+_cSRJ+".RJ_DESC,"+_cSRA+".R_E_C_N_O_  "
_cQuery += "FROM "+_cSRA+" "
_cQuery += "INNER JOIN "+_cSRJ+" ON "+_cSRA+".RA_CODFUNC="+_cSRJ+".RJ_FUNCAO "
_cQuery += "WHERE "+_cSRA+".D_E_L_E_T_ <> '*' "
_cQuery += "AND "+_cSRJ+".D_E_L_E_T_ <> '*' "
_cQuery += "AND "+_cSRA+".RA_CC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
_cQuery += "AND "+_cSRA+".RA_MAT BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
_cQuery += "ORDER BY "+_cSRJ+".RJ_DESC,"+_cSRA+".RA_MAT "
_cQuery := ChangeQuery(_cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRBSRA",.F.,.T.)

DbSelectArea("TRBSRA")
DbGoTop()
Count To _nTotReg

_nCont := 1
_nTGGrpA := 0
_nTGGrpB := 0
_nTGGrpC := 0
_nTGGrpD := 0
_nTGTot1 := 0
_nTGTot2 := 0
DbSelectArea("TRBSRA")
DbGoTop()
SetRegua(_nTotReg)
Do While !EOF()
	IncRegua()
	
	If _nCont > 5
		_nCont := 1
		nLin := 80
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	// Posiciona na Matricula do Funcionario
	DbSelectArea("SRA")
	DbGoTo(TRBSRA->R_E_C_N_O_)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida filtro do usuario na funcao SetPrint                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aReturn[7])
		If !&(aReturn[7])
			DbSelectArea("TRBSRA")
			DbSkip()
			Loop
		EndIf
	EndIf

	_cFunIni := TRBSRA->RJ_DESC
	_nTFGrpA := 0
	_nTFGrpB := 0
	_nTFGrpC := 0
	_nTFGrpD := 0
	_nTFTot1 := 0
	_nTFTot2 := 0
	@ nLin,000 PSay "Função: "+_cFunIni
	nLin++
	@ nLin,000 PSay Replicate("-",Limite)
	nLin++
	DbSelectArea("TRBSRA")
	Do While !Eof() .and. TRBSRA->RJ_DESC==_cFunIni
		If _nCont > 5
			_nCont := 1
			nLin := 80
		EndIf


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		// Posiciona na Matricula do Funcionario
		DbSelectArea("SRA")
		DbGoTo(TRBSRA->R_E_C_N_O_)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida filtro do usuario na funcao SetPrint                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aReturn[7])
			If !&(aReturn[7])
				DbSelectArea("TRBSRA")
				DbSkip()
				Loop
			EndIf
		EndIf

		//aAdd(aRegs,{cPerg,"01","Centro Custo De ?"      ,"","","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CTT","S","","","",""})
		//aAdd(aRegs,{cPerg,"02","Centro Custo Ate ?"     ,"","","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CTT","S","","","",""})
		//aAdd(aRegs,{cPerg,"03","Matricula De ?"         ,"","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA","S","","","",""})
		//aAdd(aRegs,{cPerg,"04","Matricula Ate ?"        ,"","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA","S","","","",""})
		//aAdd(aRegs,{cPerg,"05","% Custo Sobre PF ?"     ,"","","mv_ch5","N",06,2,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
		//aAdd(aRegs,{cPerg,"06","% Aux.Enfermidade ?"    ,"","","mv_ch6","N",06,2,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
		//aAdd(aRegs,{cPerg,"07","% Feriados ?"           ,"","","mv_ch7","N",06,2,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
		//aAdd(aRegs,{cPerg,"08","% DSR ?"                ,"","","mv_ch8","N",06,2,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
		//aAdd(aRegs,{cPerg,"09","% Aviso Previo"         ,"","","mv_ch9","N",06,2,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
		//aAdd(aRegs,{cPerg,"10","% Incid.Grupo A sobre B","","","mv_cha","N",06,2,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
		
		@ nLin,000 PSay Left(SRA->RA_MAT,6)
		@ nLin,008 PSay SRA->RA_NOME // Left(SRA->RA_NOME,25)
		//@ nLin,033 Psay Left(Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC"),20)
		@ nLin,053 PSay "|"
		@ nLin,084 PSay "|"
		
		// GRUPO A
		_nINSS    := mv_par11 // _RetPar14(SRA->RA_MAT,"X14_PEREMP")
		_nFGTS    := mv_par12 // _RetPar14(SRA->RA_MAT,"X14_FGTS") 
		_nSalEdu  := mv_par13 // _RetPar14(SRA->RA_MAT,"X14_SALEDU")
		_nSesi    := mv_par14 // _RetPar14(SRA->RA_MAT,"X14_SESI")
		_nSenSebr := mv_par15 // _RetPar14(SRA->RA_MAT,"X14_SENSEBR")
//		_nSenai   := mv_par15 // _RetPar14(SRA->RA_MAT,"X14_SENAI")
//		_nSebrae  := mv_par16 // _RetPar14(SRA->RA_MAT,"X14_SEBRAE")
		_nSeconci := mv_par16 // _RetPar14(SRA->RA_MAT,"X14_SECONCI")
		_nIncra   := mv_par17 // _RetPar14(SRA->RA_MAT,"X14_INCRA")
		_nSegAci  := mv_par18 // _RetPar14(SRA->RA_MAT,"X14_PERACT")
//		_nTotGrpA := _nINSS + _nFGTS + _nSalEdu + _nSesi + _nSenai + _nSebrae + _nIncra + _nSegAci
		_nTotGrpA := _nINSS + _nFGTS + _nSalEdu + _nSesi + _nSenSebr + _nSeconci + _nIncra + _nSegAci
		@ nLin,089 PSay "GRUPO A = "+Transform(_nTotGrpA,"@E 999.99")+"%"
		@ nLin,110 PSay "|"
		
		// GRUPO B
		_nFer1_3  := mv_par19 // _RetPar14(SRA->RA_MAT,"X14_PROFER")
		_nAuxEnf  := mv_par06
		_nFeriado := mv_par07
		_n13      := mv_par20 // _RetPar14(SRA->RA_MAT,"X14_PRO13")
		_nDSR     := mv_par08
		_nTotGrpB := _nFer1_3 + _nAuxEnf + _nFeriado + _n13 + _nDSR 
		@ nLin,114 PSay "GRUPO B = "+Transform(_nTotGrpB,"@E 999.99")+"%"
		@ nLin,136 PSay "|"
		
		// GRUPO C
		_nIndRes  := mv_par21 // _RetPar14(SRA->RA_MAT,"X14_PROVRE")
		_nAviPrev := mv_par09
		_nTotGrpC := _nIndRes + _nAviPrev
		@ nLin,141 PSay "GRUPO C = "+Transform(_nTotGrpC,"@E 999.99")+"%"
		@ nLin,164 PSay "|"
		
		// GRUPO D
		_nIncAB   := mv_par10
		_nTotGrpD := _nIncAB
		@ nLin,169 PSay "GRUPO D = "+Transform(_nTotGrpD,"@E 999.99")+"%"
		@ nLin,189 PSay "|"
		
		_nPGrpC1 := ((_nTotGrpA - _nFGTS - _nSeconci)*_nAviPrev)/100

		// TOTAL 1
		_nTotGer := _nTotGrpA + _nTotGrpB + _nTotGrpC + _nTotGrpD + _nPGrpC1
		@ nLin,190 PSay "Sal.+"+Transform(_nTotGer,"@E 999.99")+"%"
		@ nLin,204 PSay "|"
		
		// TOTAL 2
		@ nLin,205 PSay "Total A+PF"
		@ nLin,219 PSay "|"
		nLin++
		
		// SALARIOS
		_nVSalHr  := If(Alltrim(SRA->RA_CATFUNC)=="H",SRA->RA_SALARIO,SRA->RA_SALARIO/SRA->RA_HRSMES)
		_nVSalMes := If(Alltrim(SRA->RA_CATFUNC)$"M,P",SRA->RA_SALARIO,SRA->RA_SALARIO*SRA->RA_HRSMES)
		_nVPfHr   := SRA->RA_PFHORA
		_nVPfMes  := SRA->RA_PFMES
		//_nVCusPf  := _nVPfMes + ((_nVPfMes*mv_par05)/100)
		_nVCusPf  := (_nVPfMes*mv_par05)/100
		// VALORES DO GRUPO A
		_nVInss   := (_nVSalMes*_nINSS)/100
		_nVFgts   := (_nVSalMes*_nFGTS)/100
		_nVSalEdu := (_nVSalMes*_nSalEdu)/100
		_nVSesi   := (_nVSalMes*_nSesi)/100
		_nVSenSebr:= (_nVSalMes*_nSenSebr)/100
//		_nVSebrae := (_nVSalMes*_nSebrae)/100
//		_nVSenai  := (_nVSalMes*_nSenai)/100
		_nVSeconci:= (_nVSalMes*_nSeconci)/100
		_nVIncra  := (_nVSalMes*_nIncra)/100
		_nVSegAci := (_nVSalMes*_nSegAci)/100
		_nTVGrpA  := _nVInss + _nVFgts + _nVSalEdu + _nVSesi + _nVSenSebr + _nVSeconci + _nVIncra + _nVSegAci
//		_nTVGrpA  := _nVInss + _nVFgts + _nVSalEdu + _nVSesi + _nVSenai + _nVSebrae + _nVIncra + _nSegAci
		
		// VALORES DO GRUPO B
		_nVFer13  := (_nVSalMes*_nFer1_3)/100
		_nVAuxEnf := (_nVSalMes*_nAuxEnf)/100
		_nVFeriad := (_nVSalMes*_nFeriado)/100
		_nV13     := (_nVSalMes*_n13)/100
		_nVDSR    := (_nVSalMes*_nDSR)/100
		_nTVGrpB  := _nVFer13 + _nVAuxEnf + _nVFeriad + _nV13 + _nVDSR
		
		// VALORES DO GRUPO C
		_nVIndRes := (_nVSalMes*_nIndRes)/100
		_nVAviPre := (_nVSalMes*_nAviPrev)/100
		_nTVGrpC  := _nVIndRes + _nVAviPre
		                                  
		// VALORES DO GRUPO D
		_nVIncAB  := (_nVSalMes*_nIncAB)/100
		_nTVGrpD  := _nVIncAB
		
		// TOTAL 1 - Salario + _nTotGer
		_nVTot1   := _nVSalMes + ((_nVSalMes*_nTotGer)/100)
		
		// TOTAL 2 - TOTAL A + PF
		_nVTot2   := _nVTot1 + _nVPfMes + _nVCusPf
		
		//LayOut
		//0        10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
		//R.A.   Nome                      Funcao              |           SALARIO            |Encargos Sociais Basicos |Enc.Sociais Rec.Incid.A  |Enc.Soc.Rec.Incid.Global A |Taxas e Reincidencias   |TOTAL 1       |TOTAL 2       |
		//AAAAAA AAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAA|                              |    GRUPO A =  37,40%    |   GRUPO B =  47,61%     |    GRUPO C =  24,70%      |    GRUPO D =  11,29%   |Sal.+121,00%  |Total A+PF    |
		//                                                     |Salario Hr.....:999,999,999.99|INSS...: 20,00% 99,999.99|Fer.1/3: 12,50% 99,999.99|Ind.Resc :  4,20% 99,999.99|A p/ B: 11,29% 99,999.99|999,999,999.99|999,999,999.99|
		//Centro de Custo                                      |Salario Mes....:999,999,999.99|FGTS...:  8,00% 99,999.99|Aux.Enf:  1,11% 99,999.99|Avis.Prev: 20,50% 99,999.99|                        |              |              |
		//AAAAAAAAA-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   |P.F.HR.........:999,999,999.99|Sal.Edu:  2,50% 99,999.99|Feriad.:  3,50% 99,999.99|                           |                        |              |              |
		//                                                     |P.F.MES........:999,999,999.99|Sesi...:  1,80% 99,999.99|13º....: 11,00% 99,999.99|                           |                        |              |              |
		//                                                     |Cust PF  23,50%:999,999,999.99|Senai..:  1,30% 99,999.99|DSR....: 19,50% 99,999.99|                           |                        |              |              |
		//                                                     |                              |Sebrae.:  0,60% 99,999.99|                         |                           |                        |              |              |
		//                                                     |                              |Incra..:  0,20% 99,999.99|                         |                           |                        |              |              |
		//                                                     |                              |Seg.Aci:  3,00% 99,999.99|                         |                           |                        |              |              |
		//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
		// Primeira linha
		@ nLin,053 PSay "|"
		@ nLin,054 PSay "Salario Hr.....:"+Transform(_nVSalHr,"@E 999,999,999.99")
		@ nLin,084 PSay "|"
		@ nLin,085 PSay "INSS...:"+Transform(_nINSS,"@E 999.99")+"% "+Transform(_nVINSS,"@E 99,999.99") 
		@ nLin,110 PSay "|"
		@ nLin,111 PSay "Fer.1/3:"+Transform(_nFer1_3,"@E 999.99")+"% "+Transform(_nVFer13,"@E 99,999.99") 
		@ nLin,136 PSay "|"
		@ nLin,137 PSay "Ind.Resc :"+Transform(_nIndRes,"@E 999.99")+"% "+Transform(_nVIndRes,"@E 99,999.99") 
		@ nLin,164 PSay "|"
		@ nLin,165 PSay "A * B:"+Transform(_nIncAB,"@E 999.99")+"% "+Transform(_nVIncAB,"@E 99,999.99") 
		@ nLin,189 PSay "|"
		@ nLin,190 PSay Transform(_nVTot1,"@E 999,999,999.99")
		@ nLin,204 PSay "|"
		@ nLin,205 PSay Transform(_nVTot2,"@E 999,999,999.99")
		@ nLin,219 PSay "|"
		nLin++
	
		// Segunda linha
		@ nLin,053 PSay "|"
		@ nLin,054 PSay "Salario Mes....:"+Transform(_nVSalMes,"@E 999,999,999.99")
		@ nLin,084 PSay "|"
		@ nLin,085 PSay "FGTS...:"+Transform(_nFGTS,"@E 999.99")+"% "+Transform(_nVFgts,"@E 99,999.99") 
		@ nLin,110 PSay "|"
		@ nLin,111 PSay "Aux.Enf:"+Transform(_nAuxEnf,"@E 999.99")+"% "+Transform(_nVAuxEnf,"@E 99,999.99") 
		@ nLin,136 PSay "|"
		@ nLin,137 PSay "Avis.Prev:"+Transform(_nAviPrev,"@E 999.99")+"% "+Transform(_nVAviPre,"@E 99,999.99") 
		@ nLin,164 PSay "|"
		@ nLin,189 PSay "|"
		@ nLin,204 PSay "|"
		@ nLin,219 PSay "|"
		nLin++
	
		// Terceira linha
		@ nLin,053 PSay "|"
		@ nLin,054 PSay "P.F.HR.........:"+Transform(_nVPfHr,"@E 999,999,999.99")
		@ nLin,084 PSay "|"
		@ nLin,085 PSay "Sal.Edu:"+Transform(_nSalEdu,"@E 999.99")+"% "+Transform(_nVSalEdu,"@E 99,999.99") 
		@ nLin,110 PSay "|"
		@ nLin,111 PSay "Feriad.:"+Transform(_nFeriado,"@E 999.99")+"% "+Transform(_nVFeriad,"@E 99,999.99") 
		@ nLin,136 PSay "|"
		//@ nLin,137 PSay "Total Grupo C:    "+Transform(_nTVGrpC,"@E 99,999.99") 
		@ nLin,164 PSay "|"
		@ nLin,189 PSay "|"
		@ nLin,204 PSay "|"
		@ nLin,219 PSay "|"
		nLin++
	
		// Quarta linha
		@ nLin,053 PSay "|"
		@ nLin,054 PSay "P.F.MES........:"+Transform(_nVPfMes,"@E 999,999,999.99") // _nVCusPf
		@ nLin,084 PSay "|"
		@ nLin,085 PSay "Sesi...:"+Transform(_nSesi,"@E 999.99")+"% "+Transform(_nVSesi,"@E 99,999.99") 
		@ nLin,110 PSay "|"
		@ nLin,111 PSay "13º....:"+Transform(_n13,"@E 999.99")+"% "+Transform(_nV13,"@E 99,999.99") 
		@ nLin,136 PSay "|"
		@ nLin,137 PSay "Total Grupo C:    "+Transform(_nTVGrpC,"@E 99,999.99") 
		//@ nLin,137 PSay "---------------------------"
		@ nLin,164 PSay "|"
		@ nLin,189 PSay "|"
		@ nLin,204 PSay "|"
		@ nLin,219 PSay "|"
		nLin++
	
		// Quinta linha
		@ nLin,053 PSay "|"
		@ nLin,054 PSay "Cust PF "+Transform(mv_par05,"@E 999.99")+"%:"+Transform(_nVCusPf,"@E 999,999,999.99")
		@ nLin,084 PSay "|"
//		@ nLin,085 PSay "Senai..:"+Transform(_nSenai,"@E 999.99")+"% "+Transform(_nVSenai,"@E 99,999.99") 
		@ nLin,085 PSay "Sen/Seb:"+Transform(_nSenSebr,"@E 999.99")+"% "+Transform(_nVSenSebr,"@E 99,999.99") 
		@ nLin,110 PSay "|"
		@ nLin,111 PSay "DSR....:"+Transform(_nDSR,"@E 999.99")+"% "+Transform(_nVDSR,"@E 99,999.99") 
		@ nLin,136 PSay "|" 
		@ nLin,137 PSay "---------------------------"

		//_nVGrpC1 := (_nVSalMes*_nPGrpC1)/100
		//@ nLin,137 PSay "Grupo C1: "+Transform(_nPGrpC1,"@E 999.99")+"% "+Transform(_nVGrpC1,"@E 99,999.99") 
		@ nLin,164 PSay "|"
		@ nLin,189 PSay "|"
		@ nLin,204 PSay "|"
		@ nLin,219 PSay "|"
		nLin++
	
		// Sexta linha
		@ nLin,053 PSay "|"
		@ nLin,084 PSay "|"
		@ nLin,085 PSay "Seconci:"+Transform(_nSeconci,"@E 999.99")+"% "+Transform(_nVSeconci,"@E 99,999.99") 
        //@ nLin,085 PSay "Sebrae.:"+Transform(_nSebrae,"@E 999.99")+"% "+Transform(_nVSebrae,"@E 99,999.99") 
		@ nLin,110 PSay "|"
		@ nLin,136 PSay "|"
		
		_nVGrpC1 := (_nVSalMes*_nPGrpC1)/100
		@ nLin,137 PSay "Grupo C1: "+Transform(_nPGrpC1,"@E 999.99")+"% "+Transform(_nVGrpC1,"@E 99,999.99")
		@ nLin,164 PSay "|"
		@ nLin,189 PSay "|"
		@ nLin,204 PSay "|"
		@ nLin,219 PSay "|"
		nLin++
	
		// Setima linha
		@ nLin,053 PSay "|"
		@ nLin,084 PSay "|"
		@ nLin,085 PSay "Incra..:"+Transform(_nIncra,"@E 999.99")+"% "+Transform(_nVIncra,"@E 99,999.99") 
		@ nLin,110 PSay "|"
		@ nLin,136 PSay "|"
		@ nLin,164 PSay "|"
		@ nLin,189 PSay "|"
		@ nLin,204 PSay "|"
		@ nLin,219 PSay "|"
		nLin++
	
		// Oitava linha
		@ nLin,053 PSay "|"
		@ nLin,084 PSay "|"
		@ nLin,085 PSay "Seg.Aci:"+Transform(_nSegAci,"@E 999.99")+"% "+Transform(_nVSegAci,"@E 99,999.99") 
		@ nLin,110 PSay "|"
		@ nLin,136 PSay "|"
		@ nLin,164 PSay "|"
		@ nLin,189 PSay "|"
		@ nLin,204 PSay "|"
		@ nLin,219 PSay "|"
		nLin++
		
		// Nona linha
		@ nLin,053 PSay "|"
		@ nLin,084 PSay "|"
		@ nLin,085 PSay "Total Grupo A:  "+Transform(_nTVGrpA,"@E 99,999.99") 
		@ nLin,110 PSay "|"
		@ nLin,111 PSay "Total Grupo B:  "+Transform(_nTVGrpB,"@E 99,999.99") 
		@ nLin,136 PSay "|"
		@ nLin,137 PSay "Total C + C1 :    "+Transform(_nTVGrpC+_nVGrpC1,"@E 99,999.99") 
		@ nLin,164 PSay "|"
		@ nLin,165 PSay "Total Grupo D:"+Transform(_nTVGrpD,"@E 99,999.99") 
		@ nLin,189 PSay "|"
		@ nLin,204 PSay "|"
		@ nLin,219 PSay "|"
		nLin++
		
		@ nLin,000 PSay Replicate("-",Limite)
		nLin++
		_nCont++
		
		_nTFGrpA += _nTVGrpA
		_nTFGrpB += _nTVGrpB                                                     
		_nTFGrpC += _nTVGrpC+_nVGrpC1
		_nTFGrpD += _nTVGrpD
		_nTFTot1 += _nVTot1
		_nTFTot2 += _nVTot2
	
		_nTGGrpA += _nTVGrpA
		_nTGGrpB += _nTVGrpB
		_nTGGrpC += _nTVGrpC+_nVGrpC1
		_nTGGrpD += _nTVGrpD
		_nTGTot1 += _nVTot1
		_nTGTot2 += _nVTot2

		DbSelectArea("TRBSRA")
		DbSkip()
	EndDo
	@ nLin,000 PSay "Totais da Função "+Alltrim(_cFunIni)
	//@ nLin,053 PSay "|"
	//@ nLin,084 PSay "|"
	@ nLin,085 PSay "                "+Transform(_nTFGrpA,"@E 99,999.99") 
	//@ nLin,110 PSay "|"
	@ nLin,111 PSay "                "+Transform(_nTFGrpB,"@E 99,999.99") 
	//@ nLin,136 PSay "|"
	@ nLin,137 PSay "                  "+Transform(_nTFGrpC,"@E 99,999.99") 
	//@ nLin,164 PSay "|"
	@ nLin,165 PSay "              "+Transform(_nTFGrpD,"@E 99,999.99") 
	//@ nLin,189 PSay "|"
	@ nLin,190 PSay Transform(_nTFTot1,"@E 999,999,999.99")
	//@ nLin,204 PSay "|"
	@ nLin,205 PSay Transform(_nTFTot2,"@E 999,999,999.99")
	//@ nLin,219 PSay "|"
	nLin++ 
	@ nLin,000 PSay __PrtThinLine()
	nLin := 80
	DbSelectArea("TRBSRA")
EndDo
@ nLin,000 PSay __PrtThinLine()
nLin++
@ nLin,000 PSay "TOTAL GERAL"
//@ nLin,053 PSay "|"
//@ nLin,084 PSay "|"
@ nLin,085 PSay "                "+Transform(_nTGGrpA,"@E 99,999.99") 
//@ nLin,110 PSay "|"
@ nLin,111 PSay "                "+Transform(_nTGGrpB,"@E 99,999.99") 
//@ nLin,136 PSay "|"
@ nLin,137 PSay "                "+Transform(_nTGGrpC,"@E 99,999.99") 
//@ nLin,164 PSay "|"
@ nLin,165 PSay "              "+Transform(_nTGGrpD,"@E 99,999.99") 
//@ nLin,189 PSay "|"
@ nLin,190 PSay Transform(_nTGTot1,"@E 999,999,999.99")
//@ nLin,204 PSay "|"
@ nLin,205 PSay Transform(_nTGTot2,"@E 999,999,999.99")
//@ nLin,219 PSay "|"
nLin++ 
@ nLin,000 PSay __PrtThinLine()
nLin+=2

DbSelectArea("TRBSRA")
TRBSRA->(DbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_RetPar14 ºAutor  ³ Cesar Padovani     º Data ³  15/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o valor do campo do parametro 14                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _RetPar14(_cMat,_cCampo) // MsgInfo(U__RetPar14("000001","X14_SESI"))

_nVal := 0
_cMes := StrZero(Month(dDataBase),2)
_cAno := Alltrim(Str(Year(dDataBase)))

// Verifica o tipo de contrato no cadastro do functionario
DbSelectArea("SRA")
DbSetOrder(1)
If !Empty(SRA->RA_TPCONTR)
	// Verifica as configuracoes do campo no SIGAGPE
	_lOk   := .F.
	_cQuery := ""
	_cQuery += "SELECT R5_CAMPO,R5_REG,R5_DE,R5_QUANTOS "
	_cQuery += "		FROM SIGAGPE "
	_cQuery += "		WHERE SIGAGPE.D_E_L_E_T_ <> '*' "
	_cQuery += "		AND R5_ARQUIVO = 'X14' "
	_cQuery += "		AND R5_CAMPO = '"+_cCampo+"' "
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRBGPE",.F.,.T.)
	DbSelectArea("TRBGPE")
	Count To _nTotReg
	If _nTotReg > 0
		DbSelectArea("TRBGPE")
		DbGoTop()
		_lOk   := .T.
		_cReg := TRBGPE->R5_REG
		_nDe  := TRBGPE->R5_DE
		_nQt  := TRBGPE->R5_QUANTOS
	EndIf
	TRBGPE->(DbCloseArea())
	
	// Caso tenha encontrado as configuracoes do campo entao pesquisa o valor do mesmo na tabela SRX
	_lCont := .T.
	DbSelectArea("SRX")
	DbSetOrder(1)
	DbGoTop()
	DbSeek(xFilial("SRX")+"14",.T.)
	Do While !Eof() .and. Alltrim(SRX->RX_TIP)=="14" .and. _lCont
		//01          20120711 
		If Alltrim(SRX->RX_COD)=="01          "+_cAno+_cMes+Alltrim(SRA->RA_TPCONTR)+Substr(Alltrim(_cReg),2,1)//Alltrim(SRX->RX_COD)==Alltrim(SRA->RA_TPCONTR)+Substr(Alltrim(_cReg),2,1)
			_lCont := .F.
			_nVal := Val(Alltrim(Substr(SRX->RX_TXT,_nDe,_nQt)))
		EndIf
		DbSelectArea("SRX")
		DbSkip()
	EndDo
EndIf

Return _nVal

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ValidPerg ³Autor³ Cesar Padovani           ³Data³24/10/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica as perguntas incluindo-as caso nao existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()

cPerg := PADR(cPerg,10)
aRegs:={}
aAdd(aRegs,{cPerg,"01","Centro Custo De ?"      ,"","","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CTT","S","","","",""})
aAdd(aRegs,{cPerg,"02","Centro Custo Ate ?"     ,"","","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CTT","S","","","",""})
aAdd(aRegs,{cPerg,"03","Matricula De ?"         ,"","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA","S","","","",""})
aAdd(aRegs,{cPerg,"04","Matricula Ate ?"        ,"","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA","S","","","",""})

aAdd(aRegs,{cPerg,"05","% Custo Sobre PF ?"     ,"","","mv_ch5","N",06,2,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
aAdd(aRegs,{cPerg,"06","% Aux.Enfermidade ?"    ,"","","mv_ch6","N",06,2,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
aAdd(aRegs,{cPerg,"07","% Feriados ?"           ,"","","mv_ch7","N",06,2,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
aAdd(aRegs,{cPerg,"08","% DSR ?"                ,"","","mv_ch8","N",06,2,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
aAdd(aRegs,{cPerg,"09","% Aviso Previo"         ,"","","mv_ch9","N",06,2,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
aAdd(aRegs,{cPerg,"10","% Incid.Grupo A sobre B","","","mv_cha","N",06,2,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})

aAdd(aRegs,{cPerg,"11","% INSS ?          "     ,"","","mv_chb","N",06,2,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
aAdd(aRegs,{cPerg,"12","% FGTS ?          "     ,"","","mv_chc","N",06,2,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
aAdd(aRegs,{cPerg,"13","% Salario Educac. ?"    ,"","","mv_chd","N",06,2,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
aAdd(aRegs,{cPerg,"14","% Sesi ?          "     ,"","","mv_che","N",06,2,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
aAdd(aRegs,{cPerg,"15","% Senai ?         "     ,"","","mv_chf","N",06,2,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
aAdd(aRegs,{cPerg,"16","% Sebrae ?        "     ,"","","mv_chg","N",06,2,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
aAdd(aRegs,{cPerg,"17","% Incra ?         "     ,"","","mv_chh","N",06,2,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
aAdd(aRegs,{cPerg,"18","% Seguro Acid. ?  "     ,"","","mv_chi","N",06,2,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
aAdd(aRegs,{cPerg,"19","% Ferias 1/3 ?    "     ,"","","mv_chj","N",06,2,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
aAdd(aRegs,{cPerg,"20","% 13º ?           "     ,"","","mv_chk","N",06,2,0,"G","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
aAdd(aRegs,{cPerg,"21","% Inden.Rescisão ?"     ,"","","mv_chl","N",06,2,0,"G","","mv_par21","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})


For i:=1 to Len(aRegs)
	DbSelectArea("SX1")
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		dbCommit()
	EndIf
Next

Return

//aAdd(aRegs,{cPerg,"01","Centro Custo De ?"      ,"","","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CTT","S","","","",""})
//aAdd(aRegs,{cPerg,"02","Centro Custo Ate ?"     ,"","","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CTT","S","","","",""})
//aAdd(aRegs,{cPerg,"03","Matricula De ?"         ,"","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA","S","","","",""})
//aAdd(aRegs,{cPerg,"04","Matricula Ate ?"        ,"","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA","S","","","",""})
//aAdd(aRegs,{cPerg,"05","% Custo Sobre PF ?"     ,"","","mv_ch5","N",06,2,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
//aAdd(aRegs,{cPerg,"06","% Aux.Enfermidade ?"    ,"","","mv_ch6","N",06,2,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
//aAdd(aRegs,{cPerg,"07","% Feriados ?"           ,"","","mv_ch7","N",06,2,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
//aAdd(aRegs,{cPerg,"08","% DSR ?"                ,"","","mv_ch8","N",06,2,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
//aAdd(aRegs,{cPerg,"09","% Aviso Previo"         ,"","","mv_ch9","N",06,2,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})
//aAdd(aRegs,{cPerg,"10","% Incid.Grupo A sobre B","","","mv_cha","N",06,2,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"S","","","",""})

//LayOut
//0        10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
//R.A.   Nome                      Funcao               |           SALARIO            |Encargos Sociais Basicos |Enc.Sociais Rec.Incid.A  |Enc.Soc.Rec.Incid.Global A|Taxas e Reincidencias   |TOTAL 1       |TOTAL 2       |
//AAAAAA AAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAA |                              |     GRUPO A = 37,40%    |    GRUPO B = 47,61%     |     GRUPO C = 24,70%     |     GRUPO D = 11,29%   |Sal.+121% Enc.|Total A+PF    |
//                                                      |Salario Hr.....:999,999,999.99|INSS....:20,00% 99,999.99|Fer.1/3.:12,50% 99,999.99|Ind.Resc : 4,20% 99,999.99|A p/ B: 11,29% 99,999.99|999,999,999.99|999,999,999.99|
//Centro de Custo                                       |Salario Mes....:999,999,999.99|FGTS....: 8,00% 99,999.99|Aux.Enf.: 1,11% 99,999.99|Avis.Prev:20,50% 99,999.99|                        |              |              |
//AAAAAAAAA-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA    |P.F.HR.........:999,999,999.99|Sal.Edu.: 2,50% 99,999.99|Feriados: 3,50% 99,999.99|                          |                        |              |              |
//                                                      |P.F.MES........:999,999,999.99|Sesi....: 1,80% 99,999.99|13º.....:11,00% 99,999.99|                          |                        |              |              |
//                                                      |Custo PF 23,50%:999,999,999.99|Senai...: 1,30% 99,999.99|DSR.....:19,50% 99,999.99|                          |                        |              |              |
//                                                      |                              |Sebrae..: 0,60% 99,999.99|                         |                          |                        |              |              |
//                                                      |                              |Incra...: 0,20% 99,999.99|                         |                          |                        |              |              |
//                                                      |                              |Seg.Acid: 3,00% 99,999.99|                         |                          |                        |              |              |
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//

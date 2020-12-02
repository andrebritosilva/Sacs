#include "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CGCFOR    ºAutor  ³Carlos R. Moreira   º Data ³  05/17/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para o Pag-For do Bradesco                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Fortknox                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Pagacta()
//  PROGRAMA PARA SEPARAR A C/C DO CODIGO DE BARRA PARA O PROGRAMA DO PAGFOR - POSICOES ( 105 - 119 )
Local _CTACED := "000000000000000"

If Empty(SE2->E2_CODBAR)
	If Empty(SE2->E2_CCF)
		//_Ctaced := StrZero(Val(Substr(SA2->A2_NUMCON,1,10)),13,0)+ STRZERO(VAL(SA2->A2_DGCCF),1) - Antonio 16/05/2012  
		_Ctaced := StrZero(Val(Substr(SA2->A2_NUMCON,1,10)),13,0)+ SA2->A2_DGCCF
	Else
		//_Ctaced := StrZero(Val(Substr(SE2->E2_CCF,1,10)),13,0)+ STRZERO(VAL(SE2->E2_DGCCF),1)  - Antonio 16/05/2012
		_Ctaced := StrZero(Val(Substr(SE2->E2_CCF,1,10)),13,0)+ SE2->E2_DGCCF
	EndIf
ElseIf Substr(SE2->E2_CODBAR,1,3) == "237"
	_RETDIG := " "
	
	_nPos   := If(Len(Alltrim(SE2->E2_CODBAR))>44,24,37)
	
	_Ctaced := Substr(SE2->E2_CODBAR,_nPos,7)
	_DIG1   := val(SUBSTR(_Ctaced,1,1)) * 2
	_DIG2   := val(SUBSTR(_Ctaced,2,1)) * 7
	_DIG3   := val(SUBSTR(_Ctaced,3,1)) * 6
	_DIG4   := val(SUBSTR(_Ctaced,4,1)) * 5
	_DIG5   := val(SUBSTR(_Ctaced,5,1)) * 4
	_DIG6   := val(SUBSTR(_Ctaced,6,1)) * 3
	_DIG7   := val(SUBSTR(_Ctaced,7,1)) * 2
	_MULT   := _DIG1 + _DIG2 + _DIG3 + _DIG4 + _DIG5 + _DIG6 + _DIG7
	_RESTO  := _MULT % 11
	_RETDIG := Iif(_RESTO==0,"0",Iif(_RESTO==1,"0",str(11-_RESTO,1,0)))
	_Ctaced := "000000" + _Ctaced + _RETDIG + " "
	
EndIf

Return(_Ctaced)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGFOR_BRADESCOºAutor  ³Microsiga           º Data ³  06/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Pagagen()
//  PROGRAMA PARA SEPARAR A AGENCIA DO CODIGO DE BARRA PARA O PROGRAMA DO PAGFOR - POSICOES ( 99 - 104 )
_Agencia := "000000"

If Empty(SE2->E2_CODBAR)
	If Empty(SE2->E2_AGEF)
		_Agencia := STRZERO(VAL(SA2->A2_AGENCIA),5) + STRZERO(VAL(SUBS(SA2->A2_DGADF,1,1)),1)
	Else
		_Agencia := STRZERO(VAL(SE2->E2_AGEF),5) + STRZERO(VAL(SE2->E2_DGAGF),1)
	EndIf
ElseIf Substr(SE2->E2_CODBAR,1,3) == "237"
	_RETDIG  := " "
	_nCol    := IF(Len(Alltrim(SE2->E2_CODBAR))>44,5,20)
	_Agencia := Substr(SE2->E2_CODBAR,_nCol,4)
	_DIG1    := val(substr(_Agencia,1,1))*5
	_DIG2    := val(substr(_Agencia,2,1))*4
	_DIG3    := val(substr(_Agencia,3,1))*3
	_DIG4    := val(substr(_Agencia,4,1))*2
	_MULT    := _DIG1 + _DIG2 + _DIG3 + _DIG4
	_RESTO   := _MULT % 11
	_RETDIG  := If(_RESTO==0,"0",iif(_RESTO==1,"0",str(11-_RESTO,1,0)))
	_Agencia := "0" + _Agencia + _RETDIG
	
EndIf

Return(_Agencia)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGFOR_BRADESCOºAutor  ³Microsiga      º Data ³  06/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Pagban()
//  PROGRAMA PARA SEPARAR O BANCO DO FORNECEDOR PAGFOR - POSICOES ( 96 - 98 )

IF Empty(SE2->E2_CODBAR)
	If Empty(SE2->E2_BCOF)
		_Banco := SA2->A2_BANCO
	Else
		_BANCO := SE2->E2_BCOF
	EndIf
Else
	_BANCO := SUBSTR(SE2->E2_CODBAR,1,3)
EndIf

Return(_Banco)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGFOR_BRADESCOºAutor  ³Microsiga      º Data ³  06/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PagCar()

SetPrvt("_RETCAR,")

////  PROGRAMA PARA SELECIONAR A CARTEIRA NO CODIGO DE BARRAS QUANDO
////  NAO TIVER TEM QUE SER COLOCADO "00"

IF Substr(SE2->E2_CODBAR,1,3) != "237"
	_Retcar := "000"
Else
	_Retcar := If(Len(Alltrim(SE2->E2_CODBAR))>44,"0"+SUBS(SE2->E2_CODBAR,9,1)+SUBS(SE2->E2_CODBAR,11,1),"0" + SUBS(SE2->E2_CODBAR,24,2))
EndIf

Return(_Retcar)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGFOR_BRADESCOºAutor  ³Microsiga      º Data ³  06/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Pagdoc()

SetPrvt("_DOC,_TPAG")

/////  PROGRAMA GRAVAR AS POSICOES DE 374 A 413

_DOC  := ""
_TPAG := ""

If Empty(SE2->E2_CODBAR)
	If SE2->E2_BCOF == "237"
		_Doc := Space(40)
	Else
		If StrZero(Val(SA2->A2_CGC),15) == StrZero(Val(SM0->M0_CGC),15)
			If SE2->E2_VALOR >= 5000
				_TPAG := "01"
				_Doc  := "D000000" + _TPAG + "01" + SPACE(29)
			Else
				_TPAG := "01"
				_Doc  := "D000000" + _TPAG + "01" + SPACE(29)
			EndIf
			
		Else
			If SE2->E2_VALOR >= 5000
				_TPAG := "03"
				_Doc  := "C000000" + _TPAG + "01" + SPACE(29)
			Else
				_TPAG := "03"
				_Doc  := "C000000" + _TPAG + "01" + SPACE(29)
			EndIf
		EndIf
	EndIf
Else
	//	If Substr(SE2->E2_CODBAR,1,3) == "237" //Titulo do Bradesco
	//		_Doc := Space(25)+STRZERO(VAL(SA2->A2_CGC),15)
	//	Else
	If Len(Alltrim(SE2->E2_CODBAR)) > 44  //Linha digitavel
		_Doc:= SUBSTR(SE2->E2_CODBAR,5,5)+SUBSTR(SE2->E2_CODBAR,11,10)+SUBSTR(SE2->E2_CODBAR,22,10)+SUBSTR(SE2->E2_CODBAR,33,1)+SUBSTR(SE2->E2_CODBAR,4,1)+SPACE(13)
	Else
		_Doc :=SUBSTR(SE2->E2_CODBAR,20,25)+SUBSTR(SE2->E2_CODBAR,5,1)+Substr(SE2->E2_CODBAR,4,1)+SPACE(13)
		//		    +SUBSTR(SE2->E2_CODBAR,11,10)+SUBSTR(SE2->E2_CODBAR,22,10)++SUBSTR(SE2->E2_CODBAR,4,1))
	EndIf
	//	EndIf
	
EndIf

/*
If SUBSTR(SEA->EA_MODELO,1,2) $ "01/30"
_Doc  := Space(40)

Elseif SUBSTR(SEA->EA_MODELO,1,2) $ "03/07/08"

Do case
Case SEA->EA_TIPOPAG $ "15/50/60/80/90"
_TPAG := "03" // Pagamento de Duplicatas/Titulo                   ***
Case SEA->EA_TIPOPAG == "10"
_TPAG := "04" // Pagamento de Dividendos                          ***
Case SEA->EA_TIPOPAG == "30"
_TPAG := "06" // Pagamento de Salario                             ***
Case SEA->EA_TIPOPAG == "20"
_TPAG := "07" // Pagamento de Fornecedores/Honorarios             ***
Case SEA->EA_TIPOPAG == "40"
_TPAG := "08" // Operacoess de Cambio/Fundos/Bolsa de Valores     ***
Case SEA->EA_TIPOPAG == "22"
_TPAG := "09" // Repasse de Arrrec./Pagamento de Tributos         ***
Case SEA->EA_TIPOPAG == "98"

Endcase



Elseif SUBSTR(SEA->EA_MODELO,1,2) == "31"

EndIf
*/

Return(_DOC)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGFOR_BRADESCOºAutor  ³Microsiga           º Data ³  06/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Pagmod()

SetPrvt("_AMODEL,")

/////  PROGRAMA PARA INDICAR A MODALIDADE DO PAGAMENTO POS.264-265

If Empty(SE2->E2_CODBAR) //SUBSTR(SEA->EA_MODELO,1,2) == "01"
	If Empty(SE2->E2_BCOF)
		If !Empty(SA2->A2_BANCO)
			If SA2->A2_BANCO == "237"
				_aModel := "01"
			Else
				If SE2->E2_VALOR > 5000
					_aModel := "08"
				Else
					_aModel := "03"
				EndIf
				
			EndIf
		Else
			_aModel := "03"
		EndIf
	Else
		If SE2->E2_BCOF =="237"
			_aModel := "01"
		Else
			If SE2->E2_VALOR > 5000
				_aModel := "08"
			Else
				_aModel := "03"
			EndIf
		EndIf
	EndIf
Else
	If Substr(SE2->E2_CODBAR,1,3) == "237"
		_aModel := "31"
	Else
		_aModel := "31"
	EndIf
EndIf

Return(_aModel)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGFOR_BRADESCOºAutor  ³Microsiga           º Data ³  06/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Pagnos()

SetPrvt("_RETNOS,")

//// RETORNA O NOSSO NUMERO QUANDO COM VALOR NO E2_CODBAR, E ZEROS QUANDO NAO
//// TEM VALOR POSICAO ( 139 - 150 )

IF SUBS(SE2->E2_CODBAR,01,3) != "237"
	_RetNos := "000000000000"
Else
	If Len(Alltrim(SE2->E2_CODBAR)) > 44
		_RetNos := SUBS(SE2->E2_CODBAR,12,9)+"0"+SUBS(SE2->E2_CODBAR,21,1)  //Linha Digitavel
	Else
		_RetNos := SUBS(SE2->E2_CODBAR,26,9)+"0"+SUBS(SE2->E2_CODBAR,35,1)  //Codigo de Barras
	EndIf
EndIf

Return(_RETNOS)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGFOR_BRADESCOºAutor  ³Microsiga           º Data ³  06/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PAGVENC()

SetPrvt("_VENCVAL")

// VERIFICACAO DO VENCIMENTO DO CODIGO DE BARRAS

_VENCVAL  :=  "00000000000000"

If !Empty(Alltrim(SE2->E2_CODBAR))
	IF Len(Alltrim(SE2->E2_CODBAR)) > 44
		_VENCVAL := SUBSTR(SE2->E2_CODBAR,34,14)
	Else
		_VENCVAL := SUBSTR(SE2->E2_CODBAR,6,14)
	EndIf
	//ElseIf SE2->E2_DECRESC > 0 .Or. SE2->E2_ACRESC > 0
	//	_VENCVAL := "0000"+StrZero(SE2->E2_SALDO*100,10)
EndIf

Return(_VENCVAL)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGFOR_BRADESCOºAutor  ³Microsiga           º Data ³  06/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ValTot()

Local _area   := GetArea()
Local nTotal  := 0
//Local _Soma   := SOMAVALOR()
//local _Soma1  := 0
// Local _Desc   := 0

DbSelectArea("SEA")
DbSetOrder(1)
DbSeek(xFilial("SEA")+MV_PAR01 )

While SEA->(!Eof()) .And. SEA->EA_NUMBOR <= MV_PAR02
	
	SE2->(DbSetOrder(1))
	SE2->(DbSeek(xFilial("SE2")+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+SEA->EA_LOJA ))
	
	
	//	If !Empty(SE2->E2_CODBAR)
	//		If Len(Alltrim(SE2->E2_CODBAR)) > 44
	//			nTotal += If(Val(Substr(SE2->E2_CODBAR,38,10)) == 0,SE2->E2_SALDO*100,Val(Substr(SE2->E2_CODBAR,38,10)))
	//		Else
	//			nTotal += If(Val(Substr(SE2->E2_CODBAR,10,10)) == 0,SE2->E2_SALDO*100,Val(Substr(SE2->E2_CODBAR,10,10))) //Val(Substr(SE2->E2_CODBAR,10,10))
	//		EndIf
	//		nTotal += ( SE2->(E2_ACRESC-E2_DECRESC) ) * 100
	//	Else*/
	nTotal += ( SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC) ) * 100
	//	EndIf
	
	DbSelectArea("SEA")
	DbSkip()
	
End

RestArea(_area)

Return(nTotal)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RETVALOR  ºAutor  ³Carlos R. Moreira   º Data ³  06/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o valor do Titulo no CNAB                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RetValor()
Local aArea := GetArea()
Local nValor := 0

//If !Empty(SE2->E2_CODBAR)

//	If Len(Alltrim(SE2->E2_CODBAR)) > 44   //Linha Digitavel
//		nValor := If(Val(Substr(SE2->E2_CODBAR,38,10)) == 0,SE2->E2_SALDO*100,Val(Substr(SE2->E2_CODBAR,38,10))) //Val(Substr(SE2->E2_CODBAR, 38,10))
//	Else
//		nValor := If(Val(Substr(SE2->E2_CODBAR,10,10)) == 0,SE2->E2_SALDO*100,Val(Substr(SE2->E2_CODBAR,10,10))) //Val(Substr(SE2->E2_CODBAR, 10,10))
//	EndIf
//Else
nValor := ( SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC) ) * 100  //(SE2->E2_SALDO + SE2->E2_* 100
//EndIf

RestArea(aArea)
Return nValor

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGFOR_BRADESCOºAutor  ³Microsiga           º Data ³  07/16/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RetCGCFor()
Local cCNPJ := Replicate("0",15)

If SA2->A2_TIPO == "J"
    If !Empty(SA2->A2_CGCCOB)            
    	cCNPJ := STRZERO(VAL(SA2->A2_CGCCOB),15)
    Else
	    cCNPJ := STRZERO(VAL(SA2->A2_CGC),15)
	EndIf 
ElseIf SA2->A2_TIPO == "F"
	cCNPJ := Substr(SA2->A2_CGC,1,9)+"0000"+Substr(SA2->A2_CGC,10,2)
EndIf

Return cCNPJ


User Function RtDecres()
local nValPag := 0,nVlrCodBar := 0,nDecrescP := 0,nAcrescP := 0 ,nRSDifBole := 1 //GETNEWPAR("MV_DIFBOLE",1)

If Len(SE2->E2_CODBAR) > 44
	nVlrCodBar	:= Val(SubStr(SE2->E2_CODBAR,38,10))/100
Else
	nVlrCodBar	:= Val(SubStr(SE2->E2_CODBAR,10,10))/100
EndIf
// Quando o título tiver movimentação,tanto o descr como acresc.,são calculados para o saldo,zerando os saldos do Decresc./Acresc.
//If 	SE2->E2_SDACRES > 0 .OR. SE2->E2_SDDECRE > 0
//	nValPag := SE2->E2_SALDO + SE2->E2_ACRESC - SE2->E2_DECRESC
//Else
nValPag := SE2->E2_SALDO
//EndIf

IF EMPTY(SE2->E2_CODBAR).OR.(nVlrCodBar == 0  .AND. SUBSTR(SE2->E2_CODBAR,1,3) #"   ")  //SUBSTR(SE2->E2_CODBAR,6,14) == "00000000000000"
	nDecrescP := 0
	
ELSE
	
	IF	SE2->E2_VALOR <> nVlrCodBar .AND. SE2->E2_DECRESC > nRSDifBole  // Parametro MV_DIFBOLE Vlr entre o Boleto e o Sistema(E2_valor)
		nDecrescP := 0 //SE2->E2_VALOR - nValPag    // Pode ser tanto compensações(NDF)quanto E2_Decresc
	ELSE
		
		IF SE2->E2_DECRESC > nRSDifBole
			nDecrescP := SE2->E2_DECRESC * 100
		ELSE
			IF (SE2->E2_VALOR - SE2->E2_SALDO) > 0
				nDecrescP := ( SE2->E2_VALOR - SE2->E2_SALDO ) * 100
			ELSE
				nDecrescP := 0
			ENDIF
		ENDIF
	EndIf
ENDIF

//nDecrescP := StrZero(nDecrescP * 100, 15 )
Return(nDecrescP)


User Function RtAcresc()
local nValPag := 0,nVlrCodBar := 0,nDecrescP := 0,nAcrescP := 0,nVlrP := 0, _DTDES := "00000000" ,nRSDifBole := 1 //GETNEWPAR("MV_DIFBOLE",1)

If Len(SE2->E2_CODBAR) > 44
	nVlrCodBar	:= Val(SubStr(SE2->E2_CODBAR,38,10))/100
Else
	nVlrCodBar	:= Val(SubStr(SE2->E2_CODBAR,10,10))/100
EndIf
// Quando o título tiver movimentação,tanto o descr como acresc.,são calculados para o saldo,zerando os saldos do Decresc./Acresc.
//If 	SE2->E2_SDACRES > 0 .OR. SE2->E2_SDDECRE > 0
//	nValPag := SE2->E2_SALDO + SE2->E2_ACRESC - SE2->E2_DECRESC
//Else
nValPag := SE2->E2_SALDO
//EndIf

IF EMPTY(SE2->E2_CODBAR).OR.(nVlrCodBar == 0  .AND. SUBSTR(SE2->E2_CODBAR,1,3) #"   ") //SUBSTR(SE2->E2_CODBAR,6,14) == "00000000000000"
	nAcrescP := 0
ELSE
	
	IF	SE2->E2_VALOR <> nVlrCodBar .AND. SE2->E2_ACRESC > nRSDifBole   // // Parametro MV_DIFBOLE Vlr entre o Boleto e o Sistema(E2_valor)
		nAcrescP := 0
	ELSE
		IF SE2->E2_ACRESC > nRSDifBole
			nAcrescP := SE2->E2_ACRESC * 100
		ELSE
			nAcrescP := 0
		ENDIF
	EndIF
ENDIF

Return(nAcrescP)


User Function RTPGTOS(XVALOR)

local nValPag := 0,nVlrCodBar := 0,nDecrescP := 0,nAcrescP := 0,nVlrP := 0, _DTDES := "00000000" ,nRSDifBole := 1 //GETNEWPAR("MV_DIFBOLE",1)

If Len(SE2->E2_CODBAR) > 44
	nVlrCodBar	:= Val(SubStr(SE2->E2_CODBAR,38,10))/100
Else
	nVlrCodBar	:= Val(SubStr(SE2->E2_CODBAR,10,10))/100
EndIf
// Quando o título tiver movimentação,tanto o descr como acresc.,são calculados para o saldo,zerando os saldos do Decresc./Acresc.
//If 	SE2->E2_SDACRES > 0 .OR. SE2->E2_SDDECRE > 0
//	nValPag := SE2->E2_SALDO + SE2->E2_ACRESC - SE2->E2_DECRESC
//Else
nValPag := SE2->E2_SALDO
//EndIf

Do Case
	
	Case XVALOR  == "ACRESC"			//Têm Acréscimo
		IF EMPTY(SE2->E2_CODBAR).OR.(nVlrCodBar == 0  .AND. SUBSTR(SE2->E2_CODBAR,1,3) #"   ") //SUBSTR(SE2->E2_CODBAR,6,14) == "00000000000000"
			nAcrescP := 0
		ELSE
			
			IF	SE2->E2_VALOR <> nVlrCodBar .AND. SE2->E2_ACRESC > nRSDifBole   // // Parametro MV_DIFBOLE Vlr entre o Boleto e o Sistema(E2_valor)
				nAcrescP := 0
			ELSE
				IF SE2->E2_ACRESC > nRSDifBole
					nAcrescP := SE2->E2_ACRESC * 100
				ELSE
					nAcrescP := 0
				ENDIF
			EndIF
		ENDIF
		
		Return(nAcrescP)
		
	Case XVALOR  == "DECRESC"				// Têm Descréscimo
		
		IF EMPTY(SE2->E2_CODBAR).OR.(nVlrCodBar == 0  .AND. SUBSTR(SE2->E2_CODBAR,1,3) #"   ")  //SUBSTR(SE2->E2_CODBAR,6,14) == "00000000000000"
			nDecrescP := 0
			
		ELSE
			
			IF	SE2->E2_VALOR <> nVlrCodBar .AND. SE2->E2_DECRESC > nRSDifBole  // Parametro MV_DIFBOLE Vlr entre o Boleto e o Sistema(E2_valor)
				nDecrescP := 0 //SE2->E2_VALOR - nValPag    // Pode ser tanto compensações(NDF)quanto E2_Decresc
			ELSE
				
				IF SE2->E2_DECRESC > nRSDifBole
					nDecrescP := SE2->E2_DECRESC * 100
				ELSE
					IF (SE2->E2_VALOR - SE2->E2_SALDO) > 0
						nDecrescP := ( SE2->E2_VALOR - SE2->E2_SALDO ) * 100
					ELSE
						nDecrescP := 0
					ENDIF
				ENDIF
			EndIf
		ENDIF
		
		Return(nDecrescP)
		
	Case XVALOR  == "VLRPG"
		
		Return(nValPag)
		
	Case XVALOR  == "DTLIMT"     // Data Limite para pagamento quando tiver Decréscimo
		
		IF EMPTY(SE2->E2_CODBAR).OR.(nVlrCodBar == 0  .AND. SUBSTR(SE2->E2_CODBAR,1,3) #"   ") //SUBSTR(SE2->E2_CODBAR,6,14) == "00000000000000"
			_DTDES := "00000000"
			
		ELSE
			
			If	SE2->E2_VALOR <> nVlrCodBar .AND. SE2->E2_DECRESC > nRSDifBole
				
				_DTDES := "00000000"
				
			ELSE
				IF SE2->E2_DECRESC > nRSDifBole
					
					_DTDES := DTOS(SE2->E2_VENCREA)
					
				ELSE
					IF (SE2->E2_VALOR - SE2->E2_SALDO) > 0
						_DTDES := DTOS(SE2->E2_VENCREA)
					ELSE
						_DTDES := "00000000"
					ENDIF
				ENDIF
			EndIf
			
		ENDIF
		
		Return(_DTDES)
		
EndCase

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SisPag    ºAutor  ³Carlos R. Moreira   º Data ³  08/22/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o Codigo de Barras para o Sispag                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico GTEX                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CodBarR()

CODBARRA:=IIF(Len(Alltrim(SE2->E2_CODBAR)) > 44 ,SubStr(SE2->E2_CODBAR,1,4)+ SubStr(SE2->E2_CODBAR,33,1);
+ SubStr(SE2->E2_CODBAR,34,4)+ SubStr(SE2->E2_CODBAR,38,10)+ SubStr(SE2->E2_CODBAR,5,5);
+ SubStr(SE2->E2_CODBAR,11,10)+ SubStr(SE2->E2_CODBAR,22,10),SE2->E2_CODBAR)

Return(CODBARRA)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGFOR_BRADESCOºAutor  ³Microsiga           º Data ³  09/19/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NumSeqBra()
Local cNosso

If !ExisteSX6("MV_SEQBRAD")
	CriarSX6("MV_SEQBRAD","C","Num. seq arquivo CNAB do Banco Bradesco","100000001000")
EndIf

cNosso := StrZero(Val(GetMv("MV_SEQBRAD"))+1,10)

DbSelectArea("SE2")
RecLock("SE2",.F.)
SE2->E2_NUMBCO := cNosso
MsUnlock()

DbSelectArea("SX6")
DbSeek("  MV_SEQBRAD")
RecLock("SX6",.F.)
SX6->X6_CONTEUD := cNosso 
MsUnlock()

Return cNosso 

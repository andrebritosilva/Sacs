#include "rwmake.ch"
#include "Protheus.ch"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PATFA01  ³ Autor ³ Carlos R. Moreira     ³ Data ³16.03.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cadastra as Solicitacoes de Suprimentos                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PATFA01()
	Local nPos
	Local bBlock

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aRotina := {{"Pesquisar","AxPesqui", 0 , 1},;
		{"Visualizar" ,"U_PATFA01Visual", 0 , 2},;
		{"Incluir"    ,"U_PATFA01Inclui", 0 , 3},;
		{"Transferir" ,"U_PATFA01Transf" , 0 , 4 },;
		{"Devolucao"   ,"U_PATFA01Dev", 0 , 4 } ,;
		{"Canc Devol"  ,"U_PATFA01CDe", 0 , 4 } ,;
		{"Encerrar"   ,"U_PATFA01Enc", 0 , 4 } ,;
		{"Imprimir"   ,"U_PATFR01"     , 0 , 5 } ,;
		{"Anexar Doc"  ,"U_PATFANDOC"     , 0 , 5 } ,;
		{"Legenda"    ,"U_MostraLeg"   , 0 , 2 } }

//{"Alterar"   ,"U_PATFA01Altera", 0 , 4 },;

	Private	cCadastro := OemToAnsi("Movimentacao de Ativos")

	Private aCores := { { " Z6_STATUS = ' ' "  , 'ENABLE' },;
		{ " Z6_STATUS = 'E'" , 'DISABLE'  },;
		{ " Z6_STATUS = 'T'" , 'BR_AZUL'  },;
		{ " Z6_DTPRDEV <= dDatabase" , 'BR_AMARELO'  },;
		{ " Z6_STATUS = 'D'" , 'BR_LARANJA'  }}


	dbSelectArea("SZ6")
	dbSetOrder(1)

	mBrowse( 6, 1,22,75,"SZ6",,,,,,aCores )

	dbSelectArea("SZ6")
	Set Filter to
	dbSetOrder(1)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PFATA01vIS³ Autor ³ Carlos R. Moreira     ³ Data ³16.03.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de visualizacao de uma solicitacao international  ³±±
±±³          ³ Order                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void A105Visual(ExpC1,ExpN1,ExpN2)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN2 = Numero do registro                                 ³±±
±±³          ³ ExpN3 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Especifico                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PATFA01Visual(cAlias,nReg,nOpcx)

	Local aArea   := GetArea()
	Local nOpcA		:= 0
	Local lGravaOK	:= .T.
	Local cTabSol	:= ""
	Local nUsado    := 0
	Local nCntFor	:= 0
	Local aArea		:= GetArea()
	Local aBut105	:= {}
	Local oDlg
	Local oGet
	Local aObjects  := {},aPosObj  :={}
	Local aSize     := MsAdvSize()
	Local aInfo     := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	Private aTELA[0][0]
	Private aGETS[0]

	Private aHeader     := {}
	Private aCols       := {}
	Private lNext 		:= .F.

	INCLUI := .F.

	Private oTotal
	Private nTotal

	Private cUser     := SZ6->Z6_USER

	Private cMat      := SZ6->Z6_MAT
	Private cNomFunc  := SZ6->Z6_NOMFUNC

	Private cCC    := SZ6->Z6_CC
	Private cNomCC := SZ6->Z6_DESC_CC

	Private cCodigo := SZ6->Z6_COD

	Private dEmissao := SZ6->Z6_EMISSAO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do aHeader                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek( cAlias )
	While ( !EOF() .And. SX3->X3_ARQUIVO == cAlias )
		If ( X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL ) //.And.;
		
				If 	AllTrim(SX3->X3_CAMPO) = "Z6_PLACA" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DESCBEM" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_CONDICA" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DESCAVA" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DTRET" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DTPRDEV".Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_HRKMINI" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_CONDEV" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DESCFUN" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_VLRDESC" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_JUSDESC" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_HRKMFIM"
	
			nUsado++
			AADD(aHeader,{ AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT} )
		EndIf
		
	EndIf
	
	dbSelectArea("SX3")
	dbSkip()
	
EndDo

nTotal := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona ponteiro do arquivo no 1. registro valido          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( cAlias )
dbSetOrder(1)
dbSeek(xFilial("SZ6")+cCodigo  )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do Acols                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While ( !Eof() .And. SZ6->Z6_FILIAL == xFilial("SZ6") .And.;
		SZ6->Z6_COD == cCodigo )
	aadd(aCols,Array(nUsado+1))
	For nCntFor := 1 To nUsado
		If Upper(AllTrim(aHeader[nCntFor,2])) == "Z6_DESCBEM"
			aCOLS[Len(aCols)][nCntFor] := SZ6->Z6_DESCBEM //(FieldGet(FieldPos(aHeader[nCntFor][2])))
		Else
			If ( aHeader[nCntFor][10] != "V" )
				aCOLS[Len(aCols)][nCntFor] := SZ6->(FieldGet(FieldPos(aHeader[nCntFor][2])))
			Else
				aCOLS[Len(aCols)][nUsado] := CriaVar(aHeader[nCntFor])
			Endif
		EndIf
	Next nCntFor
	aCOLS[Len(aCols)][nUsado+1] := .F.

	dbSelectArea("SZ6")
	dbSkip()
	
EndDo

AADD(aObjects,{100,040,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})
AADD(aObjects,{100,030,.T.,.F.,.F.})

aPosObj:=MsObjSize(aInfo,aObjects)

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Movimentacao Ativo - Visualizar") OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4] OF oDlg PIXEL

@ aPosObj[3,1],aPosObj[3,2] TO aPosObj[3,3],aPosObj[3,4] OF oDlg PIXEL

@ 2.8 , 1    SAY OemToAnsi("Codigo") 	//
@ 2.8 , 4.3    MSGET cCodigo  When .F.

@ 2.8,  12    SAY OemToAnsi("Matricula") 	//
@ 2.8, 15    MSGET cMat   When .F.

@ 2.8,  40    SAY OemToAnsi("Nome Funcionario") 	//
@ 2.8, 46    MSGET cNomFunc  When .F.

@ 4.0 , 1    SAY OemToAnsi("C.Custo") 	//
@ 3.9 , 4.3    MSGET cCC  F3 "CTT"  When .F.

@ 4.0,  12    SAY OemToAnsi("Descricao") 	//
@ 3.9, 16    MSGET cNomCC   When .F.

@ 4.0,  40    SAY OemToAnsi("Emissao") 	//
@ 3.9, 45    MSGET dEmissao    When .F.

oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_PATFA01LinOK","U_PATF01TudOK",,.T.)

ACTIVATE MSDIALOG oDlg ON INIT ;
	EnchoiceBar(oDlg,{||nOpcA := 1,If(oGet:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()},,aBut105)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a entrada da rotina                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PATFA01Inc³ Autor ³ Carlos R. Moreira     ³ Data ³08.03.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de inclusao de Movimentacao Ativo      .      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PATFA01Inclui(cAlias,nReg,nOpcx)

	Local nOpcA		:= 0
	Local lGravaOK	:= .T.
	Local cTabSol	:= ""
	Local nUsado    := 0
	Local nCntFor	:= 0
	Local aArea		:= GetArea()
	Local aBut105	:= {}
	Local oDlg
	Local oGet
	Local aObjects  := {},aPosObj  :={}
	Local aSize     := MsAdvSize()
	Local aInfo     := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	Private aTELA[0][0]
	Private aGETS[0]

	Private aHeader     := {}
	Private aCols       := {}
	Private aRatAFH		:= {}


	INCLUI := .T.

	Private oTotal
	Private nTotal

	Private cUser     := __cUserID
	Private cNomUser  := UsrFullName(__cUserID )

	Private cMat      := Space(6)
	Private cNomFunc  := Space(40)

	Private cCC    := Space(9)
	Private cNomCC := Space(20)

	Private cCodigo := NextNumero("SZ6",1,"Z6_COD",.T.)

	Private dEmissao := dDatabase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do aHeader                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek( cAlias )
	While ( !EOF() .And. SX3->X3_ARQUIVO == cAlias )
		If ( X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL ) //.And.;
		
				If 	AllTrim(SX3->X3_CAMPO) = "Z6_PLACA" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DESCBEM" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_CONDICA" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DESCAVA" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DTRET" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DTPRDEV" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_HRKMINI"
			
			nUsado++
			AADD(aHeader,{ AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT} )
		EndIf
		
	EndIf
	
	dbSelectArea("SX3")
	dbSkip()
	
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do aCols                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aCols,Array(nUsado+1))
For nCntFor := 1 To nUsado
	aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
Next nCntFor
aCOLS[1][nUsado+1] := .F.

AADD(aObjects,{100,040,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})
AADD(aObjects,{100,030,.T.,.F.,.F.})

aPosObj:=MsObjSize(aInfo,aObjects)

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Movimentacao de Ativos") OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4] OF oDlg PIXEL

@ aPosObj[3,1],aPosObj[3,2] TO aPosObj[3,3],aPosObj[3,4] OF oDlg PIXEL

@ 2.8 , 1.5    SAY OemToAnsi("Numero") 	//
@ 2.8 , 4.3    MSGET cCodigo  When .F.

@ 2.8,  12    SAY OemToAnsi("Matricula") 	//
@ 2.8, 15    MSGET cMat  When .T. Valid ChkFunc(@cMat)

@ 2.8,  40    SAY OemToAnsi("Nome Usuario") 	//
@ 2.8, 46    MSGET cNomFunc  When .F.

@ 4.0 , 1    SAY OemToAnsi("C.Custo") 	//
@ 3.9 , 4.3    MSGET cCC  F3 "CTT" Valid Chk_CC(@cCC) When .T.

@ 4.0,  12    SAY OemToAnsi("Descricao") 	//
@ 3.9, 16    MSGET cNomCC   When .F.

@ 4.0,  40    SAY OemToAnsi("Emissao") 	//
@ 3.9, 45    MSGET dEmissao    When .F.

oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_PATFA01LinOK","U_PATF01TudOK",,.T.)
 
ACTIVATE MSDIALOG oDlg ON INIT ;
	EnchoiceBar(oDlg,{||nOpcA := 1,If(oGet:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()},,aBut105)
If ( nOpcA == 1 )
	Begin Transaction
		lGravaOk := PATFA01Grava(1,cCodigo)
		If !lGravaOk
		Else
			EvalTrigger()
			If ( __lSX8 )
				ConfirmSX8()
			Endif
		EndIf
	End Transaction
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a entrada da rotina                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( __lSX8 )
	RollBackSX8()
Endif
RestArea(aArea)
Return (nOpca)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A105Deleta³ Autor ³ Edson Mariate         ³ Data ³16.11.1998³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de exclusao de solicitacoes de compra             ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void A105Deleta(ExpCP,ExpN1,ExpN2)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN2 = Numero do registro                                 ³±±
±±³          ³ ExpN3 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PATFA01Dev(cAlias,nReg,nOpcx)

	Local aArea   := GetArea()
	Local nOpcA		:= 0
	Local lGravaOK	:= .T.
	Local cTabSol	:= ""
	Local nUsado    := 0
	Local nCntFor	:= 0
	Local aArea		:= GetArea()
	Local aBut105	:= {}
	Local oDlg
	Local oGet
	Local aObjects  := {},aPosObj  :={}
	Local aSize     := MsAdvSize()
	Local aInfo     := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	Private aTELA[0][0]
	Private aGETS[0]

	Private aHeader     := {}
	Private aCols       := {}
	Private lNext 		:= .F.

	INCLUI := .F.

	Private oTotal
	Private nTotal

	Private cUser     := SZ6->Z6_USER

	Private cMat      := SZ6->Z6_MAT
	Private cNomFunc  := SZ6->Z6_NOMFUNC

	Private cCC    := SZ6->Z6_CC
	Private cNomCC := SZ6->Z6_DESC_CC

	Private cCodigo := SZ6->Z6_COD

	Private dEmissao := SZ6->Z6_EMISSAO

	If SZ6->Z6_STATUS == "T"
		MsgStop("Ativo transferido nao pode ser encerrado")
		Return
	ElseIf SZ6->Z6_STATUS == "E"
		MsgStop("Movimentacao ja encerrada")
		Return

	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do aHeader                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek( cAlias )
	While ( !EOF() .And. SX3->X3_ARQUIVO == cAlias )
		If ( X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL ) //.And.;
		
				If 	AllTrim(SX3->X3_CAMPO) = "Z6_PLACA" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DESCBEM" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_CONDICA" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DESCAVA" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DTRET" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DTPRDEV".Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_HRKMINI" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_CONDEV" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_HRKMFIM"
			
//				AllTrim(SX3->X3_CAMPO) = "Z6_DESCFUN" .Or. ;
//				AllTrim(SX3->X3_CAMPO) = "Z6_VLRDESC" .Or. ;
//				AllTrim(SX3->X3_CAMPO) = "Z6_JUSDESC" .Or. ;

			nUsado++
			AADD(aHeader,{ AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT} )
		EndIf
		
	EndIf
	
	dbSelectArea("SX3")
	dbSkip()
	
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona ponteiro do arquivo no 1. registro valido          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( cAlias )
dbSetOrder(1)
dbSeek(xFilial("SZ6")+cCodigo  )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do Acols                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While ( !Eof() .And. SZ6->Z6_FILIAL == xFilial("SZ6") .And.;
		SZ6->Z6_COD == cCodigo )
	aadd(aCols,Array(nUsado+1))
	For nCntFor := 1 To nUsado
		If Upper(AllTrim(aHeader[nCntFor,2])) == "Z6_DESCBEM"
			aCOLS[Len(aCols)][nCntFor] := SZ6->Z6_DESCBEM //(FieldGet(FieldPos(aHeader[nCntFor][2])))
		Else
			If ( aHeader[nCntFor][10] != "V" )
				aCOLS[Len(aCols)][nCntFor] := SZ6->(FieldGet(FieldPos(aHeader[nCntFor][2])))
			Else
				aCOLS[Len(aCols)][nUsado] := CriaVar(aHeader[nCntFor])
			Endif
		EndIf
	Next nCntFor
	aCOLS[Len(aCols)][nUsado+1] := .F.

	dbSelectArea("SZ6")
	dbSkip()
	
EndDo

aCpos := {"Z6_CONDEV","Z6_HRKMFIM"} //"Z6_DESCFUN","Z6_JUSDESC","Z6_VLRDESC",
	
AADD(aObjects,{100,040,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})
AADD(aObjects,{100,030,.T.,.F.,.F.})

aPosObj:=MsObjSize(aInfo,aObjects)

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Movimentacao Ativo - Encerramento") OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4] OF oDlg PIXEL

@ aPosObj[3,1],aPosObj[3,2] TO aPosObj[3,3],aPosObj[3,4] OF oDlg PIXEL

@ 2.8 , 1    SAY OemToAnsi("Codigo") 	//
@ 2.8 , 4.3    MSGET cCodigo  When .F.

@ 2.8,  12    SAY OemToAnsi("Matricula") 	//
@ 2.8, 15    MSGET cMat   When .F.

@ 2.8,  40    SAY OemToAnsi("Nome Funcionario") 	//
@ 2.8, 46    MSGET cNomFunc  When .F.

@ 4.0 , 1    SAY OemToAnsi("C.Custo") 	//
@ 3.9 , 4.3    MSGET cCC  F3 "CTT"  When .F.

@ 4.0,  12    SAY OemToAnsi("Descricao") 	//
@ 3.9, 16    MSGET cNomCC   When .F.

@ 4.0,  40    SAY OemToAnsi("Emissao") 	//
@ 3.9, 45    MSGET dEmissao    When .F.

oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_PATFA01LinOK","U_PATF01TudOK",,.T.,aCpos,1)

//	oGet := MsGetDados():New(aPosObj[2,1]+70,aPosObj[2,2],aPosObj[2,3]+30,aPosObj[2,4],nOpcx,"U_TraObraLinOK","U_TraObraTudOK",,.T.,aCpos,1)//,,500)
ACTIVATE MSDIALOG oDlg ON INIT ;
	EnchoiceBar(oDlg,{||nOpcA := 1,If(oGet:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()},,aBut105)

If ( nOpcA == 1 )
	
	Begin Transaction

		//cObs := EditObs()
     
		DbSelectArea("SZ6")
		DbSetOrder(1)
		DbSeek(xFilial("SZ6")+cCodigo )
    
		While SZ6->(!Eof()) .And. SZ6->Z6_COD == cCodigo
    
			For nX := 1 to Len(aCols)

				If !aCols[nX,Len(aHeader)+1]
					If SZ6->Z6_PLACA == aCols[nX,Ascan(aHeader,{|x|AllTrim(UPPER(x[2]))="Z6_PLACA"})]
			
						Reclock("SZ6",.F.)
						SZ6->Z6_STATUS := "D"
						SZ6->Z6_DTDEV  := dDataBase
						SZ6->Z6_CONDEV  := aCols[nX,Ascan(aHeader,{|x|AllTrim(UPPER(x[2]))="Z6_CONDEV"})]
						SZ6->Z6_HRKMFIM := aCols[nX,Ascan(aHeader,{|x|AllTrim(UPPER(x[2]))="Z6_HRKMFIM"})]
						MsUnlock()

					EndIf
				EndIf
			Next

			DbSkip()

		End

	End Transaction
	
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a entrada da rotina                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsUnLockAll()
RestArea(aArea)
Return(nOpcA)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³                                                                       ³±±
±±³                                                                       ³±±
±±³                   ROTINAS DE CRITICA DE CAMPOS                        ³±±
±±³                                                                       ³±±
±±³                                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A105LinOk ³ Autor ³Edson Mariate          ³ Data ³16.11.1998³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validacao da Linha Ok.                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto da GetDados                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: .T. se valido                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA105                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PATFA01LinOk(o)

	Local lRet		:= .T.
	Local lDeleted	:= .F.
	Local nPosPlaca := Ascan(aHeader,{|x|Upper(Alltrim(x[2])) == "Z6_PLACA" } )

	If Inclui

		For nX := 1 to Len(aCols)
				
			If !aCols[nX,Len(aHeader)+1]
				If aCols[nX,nPosPlaca] == aCols[n,nPosPlaca] .And. nX # n .And. !aCols[nX,Len(aHeader)+1]
					MsgStop("A requisicao ja possui este ativo cadastrado. ")
					lRet := .F.
					Exit
				EndIf

			EndIf
		Next
   
		DbSelectArea("SZ6")
		DbSetOrder(4)
		If DbSeek(xFilial("SZ6")+aCols[n,nPosPlaca] )
  
			While SZ6->(!Eof()) .And. SZ6->Z6_PLACA == aCols[n,nPosPlaca]
      
				If Empty(SZ6->Z6_STATUS)
           
					MsgStop("Ativo ja utilizado na Requisicao "+SZ6->Z6_COD )
					Return .F.
				EndIf
         
				DbSkip()
                 
			End
		EndIf
	
	EndIf

Return( lRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A105TudOk ³ Autor ³Edson Mariate          ³ Data ³16.11.1998³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validacao da TudoOk                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto da GetDados                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: .T. se valido                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA105                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PATF01TudOK(oGetd)

	Local lRet := .T.

Return( lRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ma105Grava³ Autor ³Edson Mariate          ³ Data ³16.11.1998³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Efetua a Atualizacao das Solicitacoes ao Almoxarifado       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: [1] Inclusado                                        ³±±
±±³          ³       [2] Alteracao                                        ³±±
±±³          ³       [3] Exclusao                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: .T. se atualizado efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA105                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PATFA01Grava(nOpcao,cCodigo)

	Local nUsado	:= Len(aHeader)+1
	Local nx		:= 0
	Local ny		:= 0
	Local cMay  := ""
	Local nRecNo    := SZ6->(RecNo())
	Local lGrava    := .T.

	DbSelectArea("SZ6")
	DbSetOrder(1)
	DbSeek(xFilial("SZ6")+cCodigo )

	While SZ6->(!Eof()) .And. SZ6->Z6_COD == cCodigo
	
		RecLock("SZ6",.F.)
		SZ6->(DbDelete())
		MsUnlock()
	
		DbSkip()
	
	End

	If ( nOpcao != 3 )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consistir o ultimo n§ sequencial a ser gravado.      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nx := 1 To Len(aCols)
			lGrava := .T.
			If !aCols[nx][nUsado]
				dbSelectArea("SZ6")
				dbSetOrder(1)
				RecLock("SZ6",.T.)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza dados padroes da solicitacao ao almox.          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
				SZ6->Z6_FILIAL  := xFilial("SZ6")
				SZ6->Z6_COD     := cCodigo
				SZ6->Z6_CC      := cCC
				SZ6->Z6_DESC_CC := cNomCC
				SZ6->Z6_USER    := cUser
				SZ6->Z6_EMISSAO := dEmissao
				SZ6->Z6_STATUS  := " "
				SZ6->Z6_MAT     := cMat
				SZ6->Z6_NOMFUNC := cNomFunc
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza dados do corpo da SA.                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For ny := 1 To Len(aHeader)
					If ( aHeader[ny][10] != "V" )
						FieldPut(FieldPos(aHeader[ny][2]),aCols[nx][ny])
					EndIf
				Next ny
				MsUnLock()
			EndIf
		Next nx
	
	EndIf
	
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PATFA01   ºAutor  ³Microsiga           º Data ³  10/31/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Chk_CC(cCC)
	Local lRet := .T.

	If ! Empty(cCC)
	
		DbSelectArea("CTT")
		DbSEtOrder(1)
		If ! DbSeek(xFilial("CTT")+cCC )
			MsgStop("Centro de Custo nao cadastrado.." )
			Return .F.
		EndIf
	
		cNomCC := CTT->CTT_DESC01
	
	EndIf

Return lRet


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PFATA10Leg ³ Autor ³ Carlor R Moreira     ³ Data ³30.10.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Exibe uma janela contendo a legenda da mBrowse.              ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Scarlat                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MostraLeg()

	BrwLegenda("Movimentacao do Bem","Legenda",{	{"ENABLE",OemToAnsi("Aberto")},;
		{"BR_AZUL",OemToAnsi("Transferido")},;
		{"BR_AMARELO",OemToAnsi("Pendente Devolucao")},;
		{"BR_LARANJA",OemToAnsi("Devolvido Pend Encerramento")},;
		{"DISABLE",OemToAnsi("Encerrada")}} ) //,;
//	{"BR_AZUL",OemToAnsi("Devolucao")}} ) 

	Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PFATA10Leg ³ Autor ³ Carlor R Moreira     ³ Data ³30.10.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Exibe uma janela contendo a legenda da mBrowse.              ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Scarlat                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ChkFunc(cMat)
	Local lRet := .T.

	cMat := U_Selfunc(2,.T.)

	cNomfunc := Posicione("SRA",1,xFilial("SRA")+cMat,"RA_NOME")
	
	cCC   := Posicione("SRA",1,xFilial("SRA")+cMat,"RA_CC")

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PATFA01TRA³ Autor ³ Edson Mariate         ³ Data ³09.05.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Transferencia de ativos                        ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void A105Deleta(ExpCP,ExpN1,ExpN2)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN2 = Numero do registro                                 ³±±
±±³          ³ ExpN3 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PATFA01Transf(cAlias,nReg,nOpcx)
	Local aArea   := GetArea()
	Local nOpcA		:= 0
	Local lGravaOK	:= .T.
	Local cTabSol	:= ""
	Local nUsado    := 0
	Local nCntFor	:= 0
	Local aArea		:= GetArea()
	Local aBut105	:= {}
	Local oDlg
	Local oGet
	Local aObjects  := {},aPosObj  :={}
	Local aSize     := MsAdvSize()
	Local aInfo     := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	Private aTELA[0][0]
	Private aGETS[0]

	Private aHeader     := {}
	Private aCols       := {}
	Private lNext 		:= .F.

	INCLUI := .F.

	Private oTotal
	Private nTotal

	Private cUser     := SZ6->Z6_USER

	Private cMat      := SZ6->Z6_MAT
	Private cNomFunc  := SZ6->Z6_NOMFUNC

	Private cCC    := SZ6->Z6_CC
	Private cNomCC := SZ6->Z6_DESC_CC

	Private cCodigo := SZ6->Z6_COD

	Private dEmissao := SZ6->Z6_EMISSAO

	If SZ6->Z6_STATUS == "T"
		MsgStop("Este ativo nao pode ser Transferido. Já existe uma transferencia")
		Return
	EndIf
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do aHeader                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek( cAlias )
	While ( !EOF() .And. SX3->X3_ARQUIVO == cAlias )
		If ( X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL ) //.And.;
		
				If 	AllTrim(SX3->X3_CAMPO) = "Z6_PLACA" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DESCBEM" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_CONDICA" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DESCAVA" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DTRET" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DTPRDEV"
			
			nUsado++
			AADD(aHeader,{ AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT} )
		EndIf
		
	EndIf
	
	dbSelectArea("SX3")
	dbSkip()
	
EndDo

nTotal := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona ponteiro do arquivo no 1. registro valido          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( cAlias )
dbSetOrder(1)
dbSeek(xFilial("SZ6")+cCodigo  )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do Acols                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While ( !Eof() .And. SZ6->Z6_FILIAL == xFilial("SZ6") .And.;
		SZ6->Z6_COD == cCodigo )
	aadd(aCols,Array(nUsado+1))
	For nCntFor := 1 To nUsado
		If Upper(AllTrim(aHeader[nCntFor,2])) == "Z6_DESCBEM"
			aCOLS[Len(aCols)][nCntFor] := SZ6->Z6_DESCBEM //(FieldGet(FieldPos(aHeader[nCntFor][2])))
		Else
			If ( aHeader[nCntFor][10] != "V" )
				aCOLS[Len(aCols)][nCntFor] := SZ6->(FieldGet(FieldPos(aHeader[nCntFor][2])))
			Else
				aCOLS[Len(aCols)][nUsado] := CriaVar(aHeader[nCntFor])
			Endif
		EndIf
	Next nCntFor
	aCOLS[Len(aCols)][nUsado+1] := .F.

	dbSelectArea("SZ6")
	dbSkip()
	
EndDo

AADD(aObjects,{100,040,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})
AADD(aObjects,{100,030,.T.,.F.,.F.})

aPosObj:=MsObjSize(aInfo,aObjects)

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Movimentacao Ativo - Transferencia") OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4] OF oDlg PIXEL

@ aPosObj[3,1],aPosObj[3,2] TO aPosObj[3,3],aPosObj[3,4] OF oDlg PIXEL

@ 2.8 , 1    SAY OemToAnsi("Codigo") 	//
@ 2.8 , 4.3    MSGET cCodigo  When .F.

@ 2.8,  12    SAY OemToAnsi("Matricula") 	//
@ 2.8, 15    MSGET cMat   When .F.

@ 2.8,  40    SAY OemToAnsi("Nome Funcionario") 	//
@ 2.8, 46    MSGET cNomFunc  When .F.

@ 4.0 , 1    SAY OemToAnsi("C.Custo") 	//
@ 3.9 , 4.3    MSGET cCC  F3 "CTT"  When .F.

@ 4.0,  12    SAY OemToAnsi("Descricao") 	//
@ 3.9, 16    MSGET cNomCC   When .F.

@ 4.0,  40    SAY OemToAnsi("Emissao") 	//
@ 3.9, 45    MSGET dEmissao    When .F.

oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_PATFA01LinOK","U_PATF01TudOK",,.T.)

ACTIVATE MSDIALOG oDlg ON INIT ;
	EnchoiceBar(oDlg,{||nOpcA := 1,If(oGet:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()},,aBut105)

If ( nOpcA == 1 )
	
	Begin Transaction

		If MsgYesNo("Confirma a Transferencia do Ativo" )
  
			DbSelectArea("SZ6")
			DbSetOrder(1)
			DbSeek(xFilial("SZ6")+cCodigo )
    
			While SZ6->(!Eof()) .And. SZ6->Z6_COD == cCodigo
    
				Reclock("SZ6",.F.)
				SZ6->Z6_STATUS := "T"
				MsUnlock()
				DbSkip()

			End
    
			Private cUser     := __cUserID
			Private cNomUser  := UsrFullName(__cUserID )

			Private cMat      := Space(6)
			Private cNomFunc  := Space(40)

			Private cCC    := Space(9)
			Private cNomCC := Space(20)

			Private cCodigo := NextNumero("SZ6",1,"Z6_COD",.T.)

			Private dEmissao := dDatabase

			DEFINE MSDIALOG oDlg TITLE OemToAnsi("Movimentacao de Ativos") OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
			@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4] OF oDlg PIXEL

			@ aPosObj[3,1],aPosObj[3,2] TO aPosObj[3,3],aPosObj[3,4] OF oDlg PIXEL

			@ 2.8 , 1    SAY OemToAnsi("Numero") 	//
			@ 2.8 , 4.3    MSGET cCodigo  When .F.

			@ 2.8,  12    SAY OemToAnsi("Matricula") 	//
			@ 2.8, 15    MSGET cMat  When .T. Valid ChkFunc(@cMat)

			@ 2.8,  40    SAY OemToAnsi("Nome Usuario") 	//
			@ 2.8, 46    MSGET cNomFunc  When .F.

			@ 4.0 , 1    SAY OemToAnsi("C.Custo") 	//
			@ 3.9 , 4.3    MSGET cCC  F3 "CTT" Valid Chk_CC(@cCC) When .T.

			@ 4.0,  12    SAY OemToAnsi("Descricao") 	//
			@ 3.9, 16    MSGET cNomCC   When .F.

			@ 4.0,  40    SAY OemToAnsi("Emissao") 	//
			@ 3.9, 45    MSGET dEmissao    When .F.

			oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_PATFA01LinOK","U_PATF01TudOK",,.T.)
 
			ACTIVATE MSDIALOG oDlg ON INIT ;
				EnchoiceBar(oDlg,{||nOpcA := 1,If(oGet:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()},,aBut105)
			If ( nOpcA == 1 )
				Begin Transaction
					lGravaOk := PATFA01Grava(1,cCodigo)
					If !lGravaOk
					Else
						EvalTrigger()
						If ( __lSX8 )
							ConfirmSX8()
						Endif
					EndIf
				End Transaction
			EndIf
	
	
		EndIf
	
	End Transaction
	
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a entrada da rotina                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsUnLockAll()
RestArea(aArea)
Return(nOpcA)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PATFA01TRA³ Autor ³ Carlos R Moreira      ³ Data ³10.05.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Ordem de movimentacao de ativo                  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void A105Deleta(ExpCP,ExpN1,ExpN2)                         ³±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PATFR01()
	Local oPrn
	Local aArea := GetArea()
	
	Private oFont, cCode

	oFont  :=  TFont():New( "Arial",,15,,.T.,,,,,.F. )
	oFont3 :=  TFont():New( "Arial",,12,,.t.,,,,,.f. )
	oFont12:=  TFont():New( "Arial",,10,,.t.,,,,,.f. )
	oFont5 :=  TFont():New( "Arial",,10,,.f.,,,,,.f. )
	oFont9 :=  TFont():New( "Arial",, 8,,.T.,,,,,.f. )
	oArialNeg06 :=  TFont():New( "Arial",, 6,,.T.,,,,,.f. )
	oArialNeg07 :=  TFont():New( "Arial",, 7,,.T.,,,,,.f. )

	oFont1:= TFont():New( "Times New Roman",,28,,.t.,,,,,.t. )
	oFont2:= TFont():New( "Times New Roman",,11,,.t.,,,,,.f. )
	oFont4:= TFont():New( "Times New Roman",,20,,.t.,,,,,.f. )
	oFont7:= TFont():New( "Times New Roman",,18,,.t.,,,,,.f. )
	oFont11:=TFont():New( "Times New Roman",,10,,.t.,,,,,.t. )

	oFont6:= TFont():New( "HAETTENSCHWEILLER",,10,,.t.,,,,,.f. )

	oFont8:=  TFont():New( "Free 3 of 9",,44,,.t.,,,,,.f. )
	oFont10:= TFont():New( "Free 3 of 9",,38,,.t.,,,,,.f. )
	oFont13:= TFont():New( "Courier New",,10,,.t.,,,,,.f. )

	oCourier10N := TFont():New( "Courier New",,10,,.t.,,,,,.f. )
	oCourier12N := TFont():New( "Courier New",,12,,.t.,,,,,.f. )
	oCourier14N := TFont():New( "Courier New",,14,,.t.,,,,,.f. )

	oBrush  := TBrush():New(,CLR_HGRAY,,)
	oBrush1 := TBrush():New(,CLR_BLUE,,)
	oBrush2 := TBrush():New(,CLR_WHITE,,)

 
	oPrn := TMSPrinter():New()
	oPrn:SetPortrait()
	//oPrn:SetLandscape()
	oPrn:SetPaperSize(9)

	lEmail := .F. //MsgYesNo("Deseja enviar por Email..." )

	If lEmail
		cJPEG := CriaTrab(,.F.)
	EndIf

	oPrn:Setup()

	cOrdem := SZ6->Z6_COD
 
	lFirst := .T.
	nPag   := 0
	nLin   := 320

	aAtvDesc := {}
  
	DbSelectArea("SZ6")
	DbSetOrder(1)
	DbSeek(xFilial("SZ6")+cOrdem )
   
	ProcRegua(RecCount())        // Total de Elementos da regua

	While SZ6->(!EOF()) .And. SZ6->Z6_COD == cOrdem
	
		IncProc("Imprimindo Ficha de Movimentacao..")
			
		If lFirst
			oPrn:StartPage()
			cTitulo := "TERMO DE RESPONSABILIDADE DE GUARDA DE ATIVOS"
			cRod    := "INTERNO DE OBRA"
			aTit    := {cTitulo," ",cRod}
			nPag++
			CabRelAtv(aTit,2,oPrn,nPag,"")
			CabCons(oPrn,1)
				
			lFirst = .F.
				
		EndIf

		oPrn:Box(nLin,100,nLin+60,2300)
		
		oPrn:Line(nlin,350,nLin+60,350)
		
		oPrn:Line(nlin,1800,nLin+60,1800)
		oPrn:Line(nlin,2100,nLin+60,2100)
		

		oPrn:Say(nLin+15,  110,SZ6->Z6_PLACA  ,oFont9,100)
		oPrn:Say(nLin+15,  360,SZ6->Z6_DESCBEM ,oFont9,100)
     
		If SZ6->Z6_CONDICA == "S"
			cCond := "Sem Avarias"
		ElseIf SZ6->Z6_CONDICA == "D"
			cCond := "Desgaste Natural"
		ElseIf SZ6->Z6_CONDICA == "M"
			cCond := "Avaria por mau Uso"
		Else
			cCond := "Perda"
		EndIf
		 
		oPrn:Say(nLin+15,   1810,cCond  ,oFont9,100)
//		oPrn:Say(nLin+75,  630,"Descricao: "+SZ6->Z6_DESCAVA ,oFont5,100)
			
//		oPrn:Say(nLin+135, 110,"Data de Retirada : "+Dtoc(SZ6->Z6_DTRET)  ,oFont5,100)
			
		oPrn:Say(nLin+15, 2110,Dtoc(SZ6->Z6_DTPRDEV)  ,oFont9,100)

		nLin += 60
			
		If nLin > 3200
			oPrn:EndPage()
			lFirst := .T.
		EndIf

		If SZ6->Z6_DESCFUN == "S"
			AaDD( aAtvDesc, {SZ6->Z6_PLACA,SZ6->Z6_DESCBEM,SZ6->Z6_VLRDESC,SZ6->Z6_JUSDESC } )
		EndIf


		DbSelectArea("SZ6")
		DbSkip()
			
			
	End
 
	SZ6->(DbSkip(-1))
  
	nLin += 60
   
	oPrn:Say( nLin+15,  110,"Obrigações enquando o(s) Equipamento(s) estiver(em) sob minha Responsabilidade: " ,oFont9,100)
	
	nLin += 20
	oPrn:Say( nLin+45,  130,"a)	Responsabilidade pela guarda e conservação; " ,oFont9,100)
	oPrn:Say( nLin+75,  130,"b)	Qualquer ocorrência avisarei imediatamente o líder imediato e/ou Responsável pelos Ativos; " ,oFont9,100)
	oPrn:Say( nLin+105, 130,"c)	Cumprir as determinações do empregador para o uso adequado do(s) equipamento(s); " ,oFont9,100)
	oPrn:Say( nLin+135, 130,"d)	Responsabilizar-me pelos danos, quando usado de modo inadequado ou fora das atividades a que se destina, bem como o extravio; " ,oFont9,100)
	oPrn:Say( nLin+165, 130,"e)	Devolve-lo(s) caso ocorra meu desligamento da empresa; " ,oFont9,100)

	nLin += 20
	oPrn:Say( nLin+205,  110,"Declaro também: " ,oFont9,100)
	nLin += 20
	oPrn:Say( nLin+245,  130,"a)	Estou ciente  das  disposições  do  Art.462  e  § 1º   da  CLT,  e autorizo o desconto salarial proporcional  ao  custo  de  reparação  do  dano  se  não cumprir  " ,oFont9,100)
	oPrn:Say( nLin+275,  130,"as normas determinadas pela empresa;" ,oFont9,100)
	oPrn:Say( nLin+305,  130,"b)	Recebi treinamento devido para utilização do(s) mesmo(s); " ,oFont9,100)
  
	nLin += 400
  
	cData := StrZero(Day(SZ6->Z6_DTRET),2)+" de "+MesExtenso(Month(SZ6->Z6_DTRET))+" de "+StrZero(Year(SZ6->Z6_DTRET),4)
      
	oPrn:Say( nLin,  120, Alltrim(SM0->M0_CIDCOB)+", "+cData  ,oCourier10N,100 )
  
	nLin += 180
	oPrn:Line( nLin, 1500, nLin,2100 )
	oPrn:Say( nLin+ 20, 1550, Alltrim(SZ6->Z6_NOMFUNC)+" - "+SZ6->Z6_MAT  ,oCourier10N,100 )
	oPrn:Say( nLin+ 60, 1550, "RG : "+Posicione("SRA",1,xFilial("SRA")+SZ6->Z6_MAT,"RA_RG") ,oCourier10N,100 )
	
	oPrn:Say( 3310, 110, "1a via Responsável Destino / 2a via - Responsável Analista Patrimonial" ,oFont9,100 )

	oPrn:EndPage()

	cOrdem := SZ6->Z6_COD
 
	lFirst := .T.
	nPag   := 0
	nLin   := 320
	
	oPrn:StartPage()
	cTitulo := "DECLARAÇÃO DE REGULARIDADE COM A GUARDA DE "

	cRod    := "BENS PATRIMONIAIS"
	aTit    := {cTitulo," ",cRod}
	nPag++
	CabRelAtv(aTit,2,oPrn,nPag,"")

	nLin += 100
	
	oPrn:Say( nLin+45,  130,"Declaramos para os devidos fins, que o colaborador "+SZ6->Z6_NOMFUNC ,oCourier10N,100 )
	oPrn:Say( nLin+105,  130,"prestou conta dos bens constante no TERMO  DE  RESPONSABILIDADE  DE  GUARDA  DE  ATIVOS INTERNO ",oCourier10N,100 )
	oPrn:Say( nLin+165,  130,"DE OBRAS – nº Cód. "+SZ6->Z6_COD+" aonde  foram  conferidas  as  quantidades,  e  condições  de ",oCourier10N,100 )
	oPrn:Say( nLin+225,  130,"conversação, sendo concluído, não haver pendências em relação a estes.",oCourier10N,100 )

	oPrn:Say( nLin+285,  130,"Espaço Reservado para Ressalvas e descrição dos itens que se encontram com problemas ou avarias; ",oCourier10N,100 )

	If Len(aAtvDesc) > 0

		nLin += 360
	    
		oPrn:FillRect({nLin,100,nLin+60,2300},oBrush)
	
		oPrn:Box(nLin,100,nLin+60,2300)
	
		oPrn:Line(nlin,350,nLin+60,350)
		
		oPrn:Line(nlin,1000,nLin+60,1000)
		oPrn:Line(nlin,1250,nLin+60,1250)


		oPrn:Say(nLin+15,  110,"Placa"  ,oFont9,100)
		oPrn:Say(nLin+15,  360,"Descricao Bem" ,oFont9,100)
		 
		oPrn:Say(nLin+15, 1010,"Valor Desc"  ,oFont9,100)
		oPrn:Say(nLin+15, 1260,"Justificativa Dev" ,oFont9,100)

		nLin += 60
   
		For nX := 1 to Len(aAtvDesc)
   
			oPrn:Box(nLin,100,nLin+60,2300)
			oPrn:Say(nLin+15,  110,aAtvDesc[nX,1]  ,oFont9,100)
			oPrn:Say(nLin+15,  360,aAtvDesc[nX,2]  ,oFont9,100)
		 
			oPrn:Say(nLin+15, 1010,transform(aAtvDesc[nX,3],"@E 999,999,999.99")  ,oFont9,100)
			oPrn:Say(nLin+15, 1260,aAtvDesc[nX,4] ,oFont9,100)

			nLin += 60

		Next

		nLin += 60
   
	Else
	
		nLin += 360

		oPrn:Box(nLin,100,nLin+400,2300)

		nLin += 440
	
	EndIf
  
	oPrn:Say( nLin,  130,"Em caso de avaria justificada fica autorizado o desconto em folha de pagamento o valor descrito acima",oCourier10N,100 )

	nLin += 60
 
	oPrn:Say( nLin,  130,"Por ser verdade, firmo o presente recibo.",oCourier10N,100 )
	
	nLin += 60
  
	cData := StrZero(Day(SZ6->Z6_DTRET),2)+" de "+MesExtenso(Month(SZ6->Z6_DTRET))+" de "+StrZero(Year(SZ6->Z6_DTRET),4)
      
	oPrn:Say( nLin,  120, Alltrim(SM0->M0_CIDCOB)+", "+cData  ,oCourier10N,100 )
  
	nLin += 180
	oPrn:Line( nLin, 1500, nLin,2100 )
	oPrn:Say( nLin+ 20, 1550, Alltrim(SZ6->Z6_NOMFUNC)+" - "+SZ6->Z6_MAT  ,oCourier10N,100 )
	oPrn:Say( nLin+ 60, 1550, "RG : "+Posicione("SRA",1,xFilial("SRA")+SZ6->Z6_MAT,"RA_RG") ,oCourier10N,100 )

	oPrn:Say( 3310, 110, "1a via Responsável Destino / 2a via - Responsável Analista Patrimonial" ,oFont9,100 )

	If !lFirst
		oPrn:EndPage()
	EndIf


	oPrn:Preview()

	If lEmail .and. !Empty(cJPEG)
	
		_nLagArq	:= 1270 //870
		_nAltArq	:= 870 //1270
		_nZooArq	:= 140
	
		oPrn:SaveAllAsJPEG(cStartPath+cJPEG,_nLagArq,_nAltArq,_nZooArq)
	
	EndIf

	oPrn:End()

	If lEmail .and. !Empty(cJPEG)
		U_QNCXRMAIL({{cStartPath,cJPEG,"Roteiro de Assistencia Tecnica "}})
	EndIF

	If lEmail
	//	Deleta arquivos JPEG gerados pelos relatorios.
		FErase( cStartPath+cJPEG )
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CabCons   ºAutor  ³Carlos R. Moreira   º Data ³  19/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³monta o cabecalho da consulta                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CabCons(oPrn,nModo)

	nLin := 320
	
	oPrn:FillRect({nLin,100,nLin+80,2300},oBrush)
	
	oPrn:Box(nLin,100,nLin+80,2300)
	
	oPrn:Say(nLin+15,  110,"Centro de Custo : "+SZ6->Z6_CC+" - "+SZ6->Z6_DESC_CC  ,oFont,100)

	nLin += 80
	
	oPrn:Box(nLin,100,nLin+160,2300)

	oPrn:Say(nLin+15,  110,"Recebi o(s) Bem(ns) abaixo discriminados, que ficará(ão) sob minha responsabilidade, o qual utilizarei a partir dessa "  ,oFont12,100)

	oPrn:Say(nLin+75,  110,"data, comprometendo a usá-lo(s) adequadamente e entrega-lo(s) conforme me foi(ram) entregue(s): "  ,oFont12,100)
	
	nLin += 180

	oPrn:FillRect({nLin,100,nLin+60,2300},oBrush)
	
	oPrn:Box(nLin,100,nLin+60,2300)
	
	oPrn:Line(nlin,350,nLin+60,350)
		
	oPrn:Line(nlin,1800,nLin+60,1800)
	oPrn:Line(nlin,2100,nLin+60,2100)


	oPrn:Say(nLin+15,  110,"Placa"  ,oFont9,100)
	oPrn:Say(nLin+15,  360,"Descricao Bem" ,oFont9,100)
		 
	oPrn:Say(nLin+15, 1810,"Cond do Bem"  ,oFont9,100)
	oPrn:Say(nLin+15, 2110,"Dt Prev Dev" ,oFont9,100)

	nLin += 60
    
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EditObs   ºAutor  ³Carlos R Moreira    º Data ³  01/26/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atribui uma observacao a Ficha de movimentacao              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EditObs()
	Local cObs := Space(100)
	Local oDlgProc

	DEFINE MSDIALOG oDlgProc TITLE "Observacao da Devolucao" From 9,0 To 18,100 OF oMainWnd

	@ 5,3 to 41,395 of oDlgProc PIXEL

	@ 15,5 Say "Observacao: " Size 50,10  of oDlgProc Pixel
	@ 13,45 MSGet cObs  Picture "@S50"  Valid !Empty(cObs) Size 320 ,10 of oDlgProc Pixel

//	@ 50, 90 BMPBUTTON TYPE 1 Action GrvObs(@cObs,oDlgProc,nModo)
	@ 50,120 BMPBUTTON TYPE 1 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

Return cObs


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CABREL    ºAutor  ³Carlos R.Moreira    º Data ³  05/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Emite o cabecalho padrao para os relatorios customizados    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Escola Graduada                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function CabRelAtv(aTitulo,nForma,oPrn,nPag,cProg)
	Local cBitMap:= FisxLogo("1")

	oArial06Neg  :=  TFont():New( "Arial",,06,,.T.,,,,,.F. )
	
	oPrn:Box( 050, 100, 300,2300 )
	oPrn:SayBitmap( 100,180,cBitMap,220,180 )
	oPrn:Line( 050, 550, 300, 550 )
	oPrn:Line( 050, 1800, 300, 1800 )
	
//	nCol :=  1025 - ( (Len(Alltrim(aTitulo[2])) / 2 ) * 20 )
//	oPrn:Say(  80,  nCol, aTitulo[2],oFont2,100 )
	
	nCol :=  1025 - ( (Len(Alltrim(aTitulo[1])) / 2 ) * 20 )
	oPrn:Say( 150,  nCol, aTitulo[1],oFont2,100 )
	
	nCol :=  1025 - ( (Len(Alltrim(aTitulo[3])) / 2 ) * 20 )
	oPrn:Say( 220,  nCol, aTitulo[3],oFont2,100 )
	
	oPrn:Say( 80,  1820, "Ficha No.: ",oFont3,100 )
	
	oPrn:Say( 150, 1820, SZ6->Z6_COD ,oFont3,100 )

	nLin := 320
  
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PFATA01vIS³ Autor ³ Carlos R. Moreira     ³ Data ³16.03.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de visualizacao de uma solicitacao international  ³±±
±±³          ³ Order                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void A105Visual(ExpC1,ExpN1,ExpN2)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN2 = Numero do registro                                 ³±±
±±³          ³ ExpN3 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Especifico                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PATFA01Enc(cAlias,nReg,nOpcx)

	Local aArea   := GetArea()
	Local nOpcA		:= 0
	Local lGravaOK	:= .T.
	Local cTabSol	:= ""
	Local nUsado    := 0
	Local nCntFor	:= 0
	Local aArea		:= GetArea()
	Local aBut105	:= {}
	Local oDlg
	Local oGet
	Local aObjects  := {},aPosObj  :={}
	Local aSize     := MsAdvSize()
	Local aInfo     := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	Private aTELA[0][0]
	Private aGETS[0]

	Private aHeader     := {}
	Private aCols       := {}
	Private lNext 		:= .F.

	INCLUI := .F.

	Private oTotal
	Private nTotal

	Private cUser     := SZ6->Z6_USER

	Private cMat      := SZ6->Z6_MAT
	Private cNomFunc  := SZ6->Z6_NOMFUNC

	Private cCC    := SZ6->Z6_CC
	Private cNomCC := SZ6->Z6_DESC_CC

	Private cCodigo := SZ6->Z6_COD

	Private dEmissao := SZ6->Z6_EMISSAO

	If SZ6->Z6_STATUS # "D"
    
		MsgStop("Movimentacao nao pode ser encerrada, pois nao foi devolvido")
		Return
    
	Endif
      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do aHeader                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek( cAlias )
	While ( !EOF() .And. SX3->X3_ARQUIVO == cAlias )
		If ( X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL ) //.And.;
		
				If 	AllTrim(SX3->X3_CAMPO) = "Z6_PLACA" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DESCBEM" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_CONDICA" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DESCAVA" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DTRET" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DTPRDEV".Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_HRKMINI" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_CONDEV" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_DESCFUN" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_VLRDESC" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_JUSDESC" .Or. ;
				AllTrim(SX3->X3_CAMPO) = "Z6_HRKMFIM"
	
			nUsado++
			AADD(aHeader,{ AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT} )
		EndIf
		
	EndIf
	
	dbSelectArea("SX3")
	dbSkip()
	
EndDo

nTotal := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona ponteiro do arquivo no 1. registro valido          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( cAlias )
dbSetOrder(1)
dbSeek(xFilial("SZ6")+cCodigo  )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do Acols                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While ( !Eof() .And. SZ6->Z6_FILIAL == xFilial("SZ6") .And.;
		SZ6->Z6_COD == cCodigo )
	aadd(aCols,Array(nUsado+1))
	For nCntFor := 1 To nUsado
		If Upper(AllTrim(aHeader[nCntFor,2])) == "Z6_DESCBEM"
			aCOLS[Len(aCols)][nCntFor] := SZ6->Z6_DESCBEM //(FieldGet(FieldPos(aHeader[nCntFor][2])))
		Else
			If ( aHeader[nCntFor][10] != "V" )
				aCOLS[Len(aCols)][nCntFor] := SZ6->(FieldGet(FieldPos(aHeader[nCntFor][2])))
			Else
				aCOLS[Len(aCols)][nUsado] := CriaVar(aHeader[nCntFor])
			Endif
		EndIf
	Next nCntFor
	aCOLS[Len(aCols)][nUsado+1] := .F.

	dbSelectArea("SZ6")
	dbSkip()
	
EndDo

aCpos := {"Z6_DESCFUN","Z6_JUSDESC","Z6_VLRDESC"} //"Z6_DESCFUN","Z6_JUSDESC","Z6_VLRDESC", "Z6_CONDEV","Z6_HRKMFIM"

AADD(aObjects,{100,040,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})
AADD(aObjects,{100,030,.T.,.F.,.F.})

aPosObj:=MsObjSize(aInfo,aObjects)

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Movimentacao Ativo - Encerramento") OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4] OF oDlg PIXEL

@ aPosObj[3,1],aPosObj[3,2] TO aPosObj[3,3],aPosObj[3,4] OF oDlg PIXEL

@ 0.7 , 1    SAY OemToAnsi("Codigo") 	//
@ 0.6 , 4.3    MSGET cCodigo  When .F.

@ 0.7,  12    SAY OemToAnsi("Matricula") 	//
@ 0.6, 15    MSGET cMat   When .F.

@ 0.7,  40    SAY OemToAnsi("Nome Funcionario") 	//
@ 0.6, 46    MSGET cNomFunc  When .F.

@ 1.7 , 1    SAY OemToAnsi("C.Custo") 	//
@ 1.6 , 4.3    MSGET cCC  F3 "CTT"  When .F.

@ 1.7,  12    SAY OemToAnsi("Descricao") 	//
@ 1.6, 16    MSGET cNomCC   When .F.

@ 1.7,  40    SAY OemToAnsi("Emissao") 	//
@ 1.6, 45    MSGET dEmissao    When .F.

oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_PATFA01LinOK","U_PATF01TudOK",,.T.,aCpos,1)
//oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_PATFA01LinOK","U_PATF01TudOK",,.T.)

ACTIVATE MSDIALOG oDlg ON INIT ;
	EnchoiceBar(oDlg,{||nOpcA := 1,If(oGet:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()},,aBut105)

If ( nOpcA == 1 )
	
	Begin Transaction

		//cObs := EditObs()
     
		lTemDesc := .F.
		   
		DbSelectArea("SZ6")
		DbSetOrder(1)
		DbSeek(xFilial("SZ6")+cCodigo )
    
		While SZ6->(!Eof()) .And. SZ6->Z6_COD == cCodigo
    
			For nX := 1 to Len(aCols)
     
				If SZ6->Z6_PLACA == aCols[nX,Ascan(aHeader,{|x|AllTrim(UPPER(x[2]))="Z6_PLACA"})]
			
					Reclock("SZ6",.F.)
					SZ6->Z6_STATUS := "E"
					SZ6->Z6_DESCFUN := aCols[nX,Ascan(aHeader,{|x|AllTrim(UPPER(x[2]))="Z6_DESCFUN"})]
					SZ6->Z6_JUSDESC := aCols[nX,Ascan(aHeader,{|x|AllTrim(UPPER(x[2]))="Z6_JUSDESC"})]
					SZ6->Z6_VLRDESC := aCols[nX,Ascan(aHeader,{|x|AllTrim(UPPER(x[2]))="Z6_VLRDESC"})]

					MsUnlock()

				EndIf
   
				If SZ6->Z6_DESCFUN == "S"
				
					lTemDesc := .T.

				EndIf

			Next

			DbSkip()

		End
		
		If lTemDesc

			U_PATFR01()
      		
		EndIf
		
	End Transaction
	
EndIf
  
MsUnlockAll()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a entrada da rotina                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PFATA01vIS³ Autor ³ Carlos R. Moreira     ³ Data ³16.03.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de visualizacao de uma solicitacao international  ³±±
±±³          ³ Order                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void A105Visual(ExpC1,ExpN1,ExpN2)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN2 = Numero do registro                                 ³±±
±±³          ³ ExpN3 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Especifico                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PATFA01CDe()
	Local cCodigo := SZ6->Z6_COD
 
	If ! MsgYesNo("Deseja realmente estornar a Devolucao")
		Return
	EndIf

	DbSelectArea("SZ6")
	DbSetOrder(1)
	DbSeek(xFilial("SZ6")+cCodigo )
      
	While SZ6->(!Eof()) .And. SZ6->Z6_COD == cCodigo
			
		Reclock("SZ6",.F.)
		SZ6->Z6_STATUS := " "
		SZ6->Z6_DTDEV  := Ctod("")
		SZ6->Z6_CONDEV  := " "
		SZ6->Z6_HRKMFIM := " "
		MsUnlock()


		DbSkip()

	End
    
	MsgInfo("Estorno da Dev Efetuado com sucesso")
    
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Cad_SZ9   º Autor ³Carlos R. Moreira   º Data ³  15/03/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro as alteracoes de estruturas de produtso          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
  
  
User Function PATFANDOC()

	MsDocument( "SZ6", SZ6->(RecNo()),3,,,,.T.)

//MsDocument( "SZ9", SZ9->( Recno() ), 3 )

Return

#INCLUDE "Protheus.CH"
#INCLUDE "Protheus.CH"
#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"
#DEFINE TAMMAXXML 400000		// - Tamanho maximo do XML em  bytes
#DEFINE VBOX       080
#DEFINE HMARGEM    030

Static cTipoNfe := ""

#Command @ <nRow>,<nCol> TO <nToRow>,<nToCol> MULTILINE [<lModi: MODIFY>] [<lDel: DELETE>] [VALID <bLineOk>] [FREEZE <nFreeze>] [OBJECT <oMtl>] ;
	=> [ <oMtl> := ] IW_MultiLine(<nRow>,<nCol>,<nToRow>,<nToCol>,<.lModi.>,<.lDel.>,[\{||<bLineOk>\}],<nFreeze>)

#Command @ <nRow>,<nCol> GET <cVar> [PICTURE <cPicture>] [VALID <bValid>] [WHEN <bWhen>] [F3 <cF3>] [SIZE <nW>,<nH>] [OBJECT <oGet>] [<lMemo: MEMO>] [<lPass: PASSWORD>];
	=> [ <oGet> := ] IW_Edit(<nRow>,<nCol>,<(cVar)>,[<cPicture>],<nW>,<nH>,[\{||<bValid>\}],[\{||<bWhen>\}],[<cF3>],[<.lMemo.>],[<.lPass.>],[{|x| iif(PCount()>0,<cVar> := x,<cVar>) }])

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TRANSOBRASºAutor  ³Carlos R. Moreira   º Data ³  09/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ira gerar a transferencia de produtos para as obras         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TRANSOBRAS()
	Local aSize     := MsAdvSize(.T.)
	Local aObjects:={},aInfo:={},aPosObj:={}
	Local aInfo   :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	Local aCampos := {}

	If !ExisteSX6("MV_TESDESP")
		CriarSX6("MV_TESDESP","C","Define a Tes que ira montar os pedidos de transf Produtos de despesas","")
	EndIf

	cTesDesp := Alltrim(GetMV("MV_TESDESP"))

	AaDd(aCampos,{"OK"       ,"C",   2,0})
	AaDd(aCampos,{"PROD"     ,"C",  15,0})
	AaDd(aCampos,{"DESC"     ,"C",  60,0})
	AaDd(aCampos,{"ALMORI"   ,"C",   2,0})
	AaDd(aCampos,{"ALMDEST"  ,"C",   2,0})
	AaDd(aCampos,{"QTDE"     ,"N",  11,0})
	AaDd(aCampos,{"QTDLIB"   ,"N",  11,0})
	AaDd(aCampos,{"UPRC"     ,"N",  14,2})
	AaDd(aCampos,{"IDENT"    ,"C",   6,0})
	AaDd(aCampos,{"EQSERIE"  ,"C",  20,0})
	AaDd(aCampos,{"PRD_LOC"  ,"C",   1,0})
	AaDd(aCampos,{"QTDITEM"  ,"N",   2,0})
	AaDd(aCampos,{"DOC"      ,"C",   9,0})
	AaDd(aCampos,{"GRUPO"    ,"C",   4,0})
	AaDd(aCampos,{"CBASE"    ,"C",  10,0})
	AaDd(aCampos,{"ITEM"     ,"C",   4,0})

	cArqTmp := CriaTrab(aCampos,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria o arquo de Trabalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DbUseArea(.T.,,cArqTmp,"TRB",.F.,.F.)
	IndRegua("TRB",cArqTmp,"DESC",,,"Selecionando Registros..." )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aHeader := {}
	Private aCols   := {}
	Private copia   := {}
	Private caCols  := {}
	Private cVar3   := Space(15)
	Private nVar    := 1 //Space(6)
	Private nSaldo
	Private nSomait := 1
	Private nQtdIt  := GETMV("MV_NUMITEN")

	Private cOper     := Space(2)
	Private cDesCCOri := Space(30)
	Private cDesCCDes := Space(30)

	Private aRotina := {{"Pesquisar" ,"AxPesqui",0,1} ,;
		{"Visualizar","AxVisual",0,2} ,;
		{"Inclui","AxInclui",0,3} ,;
		{"Altera" ,"AxAltera",0,4} ,;
		{"Exclui" ,"AxDeleta",0,5} }

	lPv_auto := .T.

	lFont := TFont():New("Tahoma",,14,.T.,.T.)
	lFont1:= TFont():New("Tahoma",,18,.T.,.T.)
	lFont2:= TFont():New("Tahoma",,35,.T.,.T.)

	Private oFont1  := TFont():New( "TIMES NEW ROMAN",12.5,18,,.T.,,,,,.F.)
	Private oFont2  := TFont():New( "ARIAL",12.5,12,,.T.,,,,,.F.)
	Private oFont3  := TFont():New( "ARIAL",10.5,10,,.T.,,,,,.F.)
	Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)

//Ira Checar se existe cliente e fornecedor cadastrado para a empresa

	DbSelectArea("SA1")
	DbSetOrder(3)
	If !DbSeek(xFilial("SA1")+SM0->M0_CGC )
		MsgStop("Nao existe a empresa cadastrada como cliente. Favor Verificar")
		Return
	Else
		cCliente := SA1->A1_COD
		cLoja    := SA1->A1_LOJA
	EndIf

	DbSelectArea("SA2")
	DbSetOrder(3)
	If !DbSeek(xFilial("SA2")+SM0->M0_CGC )
		MsgStop("Nao existe a empresa cadastrada como fornecedor. Favor Verificar")
		Return
	Else
		cFornece := SA2->A2_COD
		cLojaFor := SA2->A2_LOJA
	EndIf

	_cSayTime:= SM0->M0_NOMECOM
	lverdadeiro:= .T.
	_npos:= 382
	_soma := 01

	oFont:= TFont():New("Tahoma",,-14,.T.,.T.)

	DbSelectArea("Sx3")
	DbSeek( "SB1" )

	nUsado := 0
	While !EOF() .And. X3_ARQUIVO == "SB1"
	
		If nUsado < 6
			If x3_usado != " " .And. cNivel >= X3_NIVEL
				If Alltrim(SX3->X3_CAMPO) == "B1_COD" .Or. Alltrim(SX3->X3_CAMPO) == "B1_DESC" .Or. Alltrim(SX3->X3_CAMPO) == "B1_PESBRU" .Or. Alltrim(SX3->X3_CAMPO) == "B1_EQUISER" ;
				   .Or.  Alltrim(SX3->X3_CAMPO) == "B1_ITEMATI"  .Or. Alltrim(SX3->X3_CAMPO) == "B1_CBASE"
					nUsado++
					ctitulo  := TRIM(X3_TITULO)
					ntamanho := X3_TAMANHO
					cPicture := X3_PICTURE
					If Alltrim(SX3->X3_CAMPO) == "B1_PESBRU"
						ctitulo := "Qtde"
						ntamanho := 8
						nDecimal := 2
						cPicture := "@e 99,999,999.99"
					ElseIf Alltrim(SX3->X3_CAMPO) == "B1_EQUISER"
						ctitulo := "Tipo"
						ntamanho := 6
						nDecimal := 0
						cPicture := "@!"
					ElseIf Alltrim(SX3->X3_CAMPO) == "B1_ITEMATI"
						ctitulo := "Item"
						ntamanho := 4
						nDecimal := 0
						cPicture := "@!"
					ElseIf Alltrim(SX3->X3_CAMPO) == "B1_CBASE"
						ctitulo := "Cod.Bem"
						ntamanho := 10
						nDecimal := 0
						cPicture := "@!"

					Endif
					AADD(aHeader,{ ctitulo, X3_CAMPO, cPICTURE,;
						nTAMANHO, X3_DECIMAL, X3_VALID,;
						X3_USADO, X3_TIPO, X3_ARQUIVO,X3_CONTEXT } )
				
				EndIf
			
			Endif
		
		EndIf
	
		DbSkip()
	
	End

	AaDD(aCols,Array(nUsado+1) )

	For nX := 1 to nUsado
		If nX == 1
			aCols[1][nX] := Space(30)
		Else
			aCols[1][nX] := CriaVar(aHeader[nX][2])
		EndIf
	Next
	aCOLS[1][nUsado+1] := .F. //Flag de Delecao

	nOpca    :=0
	lInverte := .F.
	cMarca   := GetMark()

	caCols := aClone(aCols)

	AADD(aObjects,{100,025,.T.,.F.})
	AADD(aObjects,{100,100,.T.,.T.})
	AAdd( aObjects, { 0, 40, .T., .F. } )

	aPosObj:=MsObjSize(aInfo,aObjects)

	aBrowse1 := {}
	AaDD(aBrowse1,{"OK","",""})
	AaDD(aBrowse1,{"PROD","","Produto"})
	AaDD(aBrowse1,{"DESC","","Descricao"})
	AaDD(aBrowse1,{"EQSERIE","","Serie Equip"})
	AaDD(aBrowse1,{"QTDE","","Quantidade","@E 999,999" })
	AaDD(aBrowse1,{"QTDLIB","","Qtde Sol","@E 999,999" })

	While .T.
	
	//Deixa o arquivo de trabalho sempre em branco
		DbSelectArea("TRB")
		Zap
	
		nOpcx  := 4
		cOper  := Space(2)
		cCCOri := Space(9)
		cCCDes := Space(9)
		cDesCCOri := Space(30)
		cDesCCDes := Space(30)
	
		cAlmOri  := Space(2)
		cAlmDest := Space(2)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criacao da Interface                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DEFINE MSDIALOG oDlg TITLE "Gera Pedidos de Transferencia de produtos" From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL
	
		@ 5,2   To 43,644 OF odlg PIXEL
		@ 49,2  To 97,644 OF odlg PIXEL
	
		@ 60,8    Say OemToAnsi("Operacao:" ) Size 37,8 Font oFont Color CLR_RED OF odlg PIXEL
	
		@ 60,100  Say OemToAnsi("Origem :" ) Size 37,8 Font oFont Color CLR_RED OF odlg PIXEL
	
		@ 60,380  Say OemToAnsi("Destino :" ) Size 37,8 Font oFont Color CLR_RED OF odlg PIXEL
	
		@ 58, 63  Get cOper   F3 "SZ5"     Size 25,10  Valid ChkOper(@cOper)
		@ 58,140  Get cCCOri  F3 "CTDOBR"  Size 60,10  Valid ChkCC(@cCCOri,1,oDlg)
		@ 58,420  Get cCCDes  F3 "CTDOBR"  Size 60,10  Valid ChkCC(@cCCDes,2,oDlg)
	
		@ 58,213  Get cDesCCOri Size 150,10  When .f.
		@ 58,490  Get cDesCCDes Size 150,10  When .f.
	
		oEspBmp := TBmpRep():New(09,592, 50, 28,, .T.,odlg, , , .F., .T., , , .F., , .T., , .F. )
		oEspBmp:cbmpfile := "LGMID"+SM0->M0_CODIGO+".PNG" //"logo0101.jpg"
	
		_oSayTime:=TSay():New(010,_npos,{||_cSayTime},oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLUE,,150,10,.T.,.F.,.T.,.F.,.F.)
	
		_oSayTime:lTransparent := .T.
	
		DlgRefresh(oDlg)
	
		oMark := MsSelect():New("TRB","","",aBrowse1,@lInverte,@cMarca,{aPosObj[2,1]+70,aPosObj[2,2],aPosObj[2,3]+30,aPosObj[2,4]})
	
		@ 18,104 Button OemToAnsi("Sair")    Size 36,16 ACTION {||nOpca:=2,Odlg:End()} Of odlg PIXEL font oFont
	
		ACTIVATE MSDIALOG odlg CENTERED
	
		If nOpca == 2
			Exit
		EndIf
	End

	TRB->(DbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFATA13   ºAutor  ³Microsiga           º Data ³  08/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ChkCC(cCC,nModo,oDlg)

	//cCC := BuscaCC(cCC)
	
	If Empty(cOper)
	
		MsgStop("Nao foi definida a operacao.")
	
		Return .T.
	
	EndIf

	If !Empty(cCC)
	
		DbSelectArea("CTD")
		DbSetOrder(1)
		If ! DbSeek(xFilial("CTD")+cCC )
			MsgStop("Obra nao cadastrada..")
			Return .F.
		EndIf
	
		If nModo == 1
			cDesCCOri := CTD->CTD_DESC01
			cAlmOri   := CTD->CTD_LOCAL
		Else
			If cCCOri == cCCDes
				MsgStop("Origem e destino nao podem ser iguais..")
				Return .F.
			EndIf
		
			cDesCCDes := CTD->CTD_DESC01
			cAlmDest  := CTD->CTD_LOCAL
		
			GeraArqTrb()
		
			oDlg:End()
		
			DbSelectArea("TRB")
			DbGoTop()
		
		EndIf
	
	EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TRANSFERENCIA PRODUTOS OBRASºAutor  ³Microsiga           º Data ³  07/16/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ChkOper(cOper)
	Local lRet := .T.

	If ! Empty(cOper)
	
		DbSelectArea("SZ5")
		DbSetOrder(1)
		If !DbSeek(xFilial("SZ5")+cOper)
			MsgStop("Operacao nao cadastrada.")
			lRet := .F.
		EndIf
	
	EndIf

Return lRet


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³PROCPED   º Autor ³ Cristiano Silva     º Data ³ 20/09/07   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao ³ Programa para gerar pedido/nota saida/nota entrada da      º±±
//±±º          | Industrial para Comercial                                  º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºAlteracao ³                                                            º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³ SIGAFAT - Especifico Scarlat                               º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function PROCPED()

	Local aCabec := {}
	Local aItens := {}
	Local aLinha := {}
	Local nX     := 0
	Local nY     := 0
	Local cDoc   := ""
	Local lOk    := .T.

	Private _condpg
	Private _cMunIbge
	Private _cTpclisc
	Private _cArea
	Private _cRedesca
	Public cPedido
	Public lprogauto := .T.

	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+cCliente )

	_CondPG := SA1->A1_COND

	cEmpDest := Space(2)
	cFilDest := Space(2)

	nPeso    := nVolume := 0
	cEspecie := Space(10)
	cMensPad  := Space(3)
	cMensNota := Space(80)
	cVeiculo  := Space(7)

	PegaDadosComp()

	aCabec := {}
	aItens := {}
	aadd(aCabec,{"C5_TIPO" ,"N",Nil})
	aadd(aCabec,{"C5_CLIENTE",SA1->A1_COD,Nil})
	aadd(aCabec,{"C5_LOJACLI",SA1->A1_LOJA,Nil})
	aadd(aCabec,{"C5_TRANSP","000002",Nil})
	aadd(aCabec,{"C5_CONDPAG","000",Nil}) //_condpg,Nil})
//aadd(aCabec,{"C5_PEDCLI"," ",Nil})
	aadd(aCabec,{"C5_TPFRETE","F",Nil})
	aadd(aCabec,{"C5_VEND1","000001",Nil})
	aadd(aCabec,{"C5_MENNOTA",cMensNota,Nil})
	aadd(aCabec,{"C5_MENPAD",cMensPad,Nil})

	aadd(aCabec,{"C5_PESOL",nPeso,Nil})
	aadd(aCabec,{"C5_PBRUTO",nPeso,Nil})

	aadd(aCabec,{"C5_VOLUME1",nVolume,Nil})
	aadd(aCabec,{"C5_ESPECI1",cEspecie,Nil})

	aadd(aCabec,{"C5_TABELA"," ",Nil})

//aadd(aCabec,{"C5_CNPJ",SA1->A1_CGC,Nil})

	Private lMsErroAuto := .F.

	aItensi := {}
	nItem   := 0

	DbSelectArea("TRB")
	DbGoTop()

	While TRB->(!Eof())
	
		cItem   := StrZero(++nItem,2)
	
		cProduto:= TRB->PROD
		nQtd	    := TRB->QTDLIB
		cLocal  := TRB->ALMORI
	
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+cProduto)
	
		nPrc := BuscaPrc(cProduto) //If(TRB->UPRC==0,1,TRB->UPRC) // Ultimo preco de compras
	
		nTot := nqtd*nPrc
	
		aLinha := {}
		aadd(aLinha,{"C6_ITEM"    ,cItem   ,Nil})
		aadd(aLinha,{"C6_PRODUTO" ,cProduto,Nil})
		aadd(aLinha,{"C6_QTDVEN"  ,nQtd    ,Nil})
		aadd(aLinha,{"C6_PRCVEN"  ,nPrc    ,Nil})
		aadd(aLinha,{"C6_PRUNIT"  ,nPrc    ,Nil})
		aadd(aLinha,{"C6_VALOR"   ,nTot    ,Nil})
		aadd(aLinha,{"C6_TES"     ,If(SB1->B1_PRD_LOC=="D",cTesDesp,SZ5->Z5_TESSAI) ,Nil})
		aadd(aLinha,{"C6_LOCAL"   ,cLocal  ,Nil})
		aadd(aLinha,{"C6_CC"      ,BusCusto(cCCDes),Nil})
		aadd(aLinha,{"C6_ITEMCTA" ,cCCDes,Nil})
		aadd(aLinha,{"C6_DESCRI"  ,TRB->DESC ,Nil})
	
		aadd(aItensi,aLinha)
	
		DbSelectArea("TRB")
		DbSkip()
	
	End

	MATA410(aCabec,aItensi,3)

	cPedido := SC5->C5_NUM

	If !lMsErroAuto
		Alert("Pedido incluido com sucesso "+cPedido )
	
		ConOut("Incluido com sucesso! "+cPedido)
	Else
		ConOut("Erro na inclusao!")
		MOSTRAERRO()
		Alert("Pedido não foi gerado")
		Return
	EndIf

	cNota:= LIBPED(cpedido,aItensi,_condpg)

  //Irei atualizar o C.Custo do Ativo 
  
  DbSelectArea("TRB")
  DbGoTop()
  
  While TRB->(!Eof()) 
  
     If Empty(TRB->CBASE)
        DbSkip()
        Loop
     EndIf 
      
     DbSelectArea("SN3")
     DbSetOrder(1)
     If DbSeek(xFilial("SN3")+TRB->CBASE+TRB->ITEM )
        
        RecLock("SN3",.F.)
	        SN3->N3_SUBCCON := cCCDes
	        SN3->N3_CCUSTO  := BusCusto(cCCDes)
	    MsUnlock()
        
     EndIf    
     DbSelectArea("TRB")
     DbSkip()
  End 

Return cNota

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFATA13   ºAutor  ³Carlos R. Moreira   º Data ³  07/19/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a liberacao do pedido de venda                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Gtex                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LIBPED(cPedido,aItensi,_condpg)

	wAreaAnt	 := GetArea()
	wAreaSC5	 := SC5->(GetArea())
	wAreaSC6	 := SC6->(GetArea())
	wAreaSC9	 := SC9->(GetArea())
	wAreaSB1	 := SB1->(GetArea())
	wAreaSB2	 := SB2->(GetArea())
	wAreaSF4	 := SF4->(GetArea())
	wAreaSA1	 := SA1->(GetArea())

	Conout("Função de Liberação de Pedido")

	DbSelectarea("SC5")
	DbSetOrder(1)
	If DBSeek(xFilial("SC5")+cPedido)
	
		nTipo := space(1)
		nStatus:= space(2)
		RecLock("SC5",.F.)
		SC5->C5_LIBEROK := "S"
		MsUnlock()
	
		DbSelectarea("SC6")
		DbSetorder(1)
		DbSeek(xFilial("SC6")+cPedido)
		While !Eof() .AND. C6_FILIAL+C6_NUM == xFilial("SC6")+cPedido
		
			DbSelectArea("SF4")
			DbSeek(xFilial("SF4")+SC6->C6_TES)
			DbSelectArea("SB2")
			dBSetOrder(1)
			If dBSeek(xfilial("SB2")+SC6->C6_PRODUTO+SC6->C6_Local) .and.;
					SF4->F4_ESTOQUE=="S"
			Endif
			SA1->(DbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA ))
		
			dbSelectArea("SC6")
		
			RecLock("SC6",.F.)
			SC6->C6_QTDLIB := SC6->C6_QTDVEN
			SC6->C6_OP     := "02"
			SC6->C6_TPOP   := "F"
			SC6->C6_CF     := IF(SA1->A1_EST == "SP",SF4->F4_CF,"6"+Substr(SF4->F4_CF,2,3))
			MsUnlock()
		/* MALIBDOFAT
		±±³Parametros³ExpN1: Registro do SC6                                      ³±±
		±±³          ³ExpN2: Quantidade a Liberar                                 ³±±
		±±³          ³ExpL3: Bloqueio de Credito                                  ³±±
		±±³          ³ExpL4: Bloqueio de Estoque                                  ³±±
		±±³          ³ExpL5: Avaliacao de Credito                                 ³±±
		±±³          ³ExpL6: Avaliacao de Estoque                                 ³±±
		±±³          ³ExpL7: Permite Liberacao Parcial                            ³±±
		±±³          ³ExpL8: Tranfere Locais automaticamente                      ³±±
		±±³          ³ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ³±±
		±±³          ³       apenas avalia ).                                     ³±±
		±±³          ³ExpbA: CodBlock a ser avaliado na gravacao do SC9           ³±±
		±±³          ³ExpAB: Array com Empenhos previamente escolhidos            ³±±
		±±³          ³       (impede selecao dos empenhos pelas rotinas)          ³±±
		±±³          ³ExpLC: Indica se apenas esta trocando lotes do SC9          ³±±
		±±³          ³ExpND: Valor a ser adicionado ao limite de credito          ³±±
		±±³          ³ExpNE: Quantidade a Liberar - segunda UM                    ³±±
		*/
			MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDLIB,.T.,.T.,.T.,.T.,.F.,.F.)
			RecLock("SC9",.F.)
			SC9->C9_BLEST  := " "
			SC9->C9_BLCRED := " "
			MsUnLock()
			ConOut("MALIBDOFAT Executada")
		
			dbSelectArea("SC6")
			DBSkip()
		Enddo
	
	Endif

// Retorna as areas originais
	RestArea(wAreaSF4)
	RestArea(wAreaSB2)
	RestArea(wAreaSB1)
	RestArea(wAreaSC9)
	RestArea(wAreaSC6)
	RestArea(wAreaSC5)
	RestArea(wAreaAnt)

	MsUnlockAll()

	ConOut("Fim da Liberação de Pedido")
	ConOut("Início Nota Fiscal")

	cNota := NotaSaida(3,cPedido,aItensi,_condpg)

Return(cNota)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PROCPED   ºAutor  ³Microsiga           º Data ³  07/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function NotaSaida(nOpc,cNumPed,aItens,_condpg)
	Local aPvlNfs := {}
	ConOut("Comeca Nota")

	nopc:=if(nopc==Nil,3,nopc)

// Posicionar as Tabelas Necessarias

	If nOpc ==3
	
		For i:=1 to len(aItens)
		
			SC9->(DbSetOrder(1))
			SC9->(DbSeek(xFilial("SC9")+cNumPed+aItens[i][1][2]) )                    //FILIAL+NUMERO+ITEM
			SC5->(DbSetOrder(1))
			SC5->(DbSeek(xFilial("SC5")+cNumPed) )                         //FILIAL+NUMERO
			SC6->(DbSetOrder(1))
			SC6->(DbSeek(xFilial("SC6")+cNumPed+aItens[i][1][2]) )                    //FILIAL+NUMERO+ITEM
			SE4->(DbSetOrder(1))
			SE4->(DbSeek(xFilial("SE4")+"001") )                           //FILIAL+NUMERO+ITEM+PRODUTO
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+aItens[i][2][2]) )               //FILIAL+PRODUTO
			SB2->(DbSetOrder(1))
			SB2->(DbSeek(xFilial("SB2")+aItens[i][2][2]+SC6->C6_LOCAL) )          //FILIAL+PRODUTO+LOCAL
			SF4->(DbSetOrder(1))
			SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES) )                            //FILIAL+CODIGO
		
			aAdd(aPvlNfs,{cNumPed,;
				aItens[i][1][2],;
				aItens[i][1][2],;
				aItens[i][3][2],;
				aItens[i][4][2],;
				aItens[i][2][2],;
				.f.,;
				SC9->(RecNo()),;
				SC5->(RecNo()),;
				SC6->(RecNo()),;
				SE4->(RecNo()),;
				SB1->(RecNo()),;
				SB2->(RecNo()),;
				SF4->(RecNo())})
		
		Next i
	
		cSerie := AllTrim(Posicione("SX5",1,xFilial("SX5")+"01","X5_CHAVE"))
	
		Pergunte("MT460A",.F.)
	
		cNota := MaPvlNfs(aPvlNfs,cSerie, .F., .F., .F., .F., .F., 0, 0, .F., .F.)
	
		aPvlNfs:={}
	
		MsgInfo("Gerada a Nota : "+cNota+" Iniciando a transmissao.." )
	
		cSerie   := SF2->F2_SERIE
		cNotaIni := SF2->F2_DOC
		cNotaFim := SF2->F2_DOC
		lCte     := .F.
		lRetorno := .T.
	          
		DbSelectArea("SF2")
	
		SpedNFeRe2(cSerie,cNotaIni,cNotaFim,lCTe,lRetorno)

		ConOut("Termina Nota")
	
		If SZ5->Z5_TPMOV == "T"
	
			DbSelectArea("TRB")
			DbGotop()
       
			While TRB->(!Eof())
       
				DbSelectArea("SB6")
				DbSetOrder(3)
				If DbSeek(xFilial("SB6")+TRB->IDENT )
					RecLock("SB6",.F.)
					SB6->B6_CC  := cCCDes
					Msunlock()
             
				EndIf
          
				DbSelectArea("TRB")
				DbSkip()
          
			End

		EndIf
	
		cCgcFor :=SM0->M0_CGC
	
		cEmpOri := cEmpAnt
		cFilOri := cFilAnt
	
	
		If SZ5->Z5_AUTOLIB == "S"
		
			U_GerTraObra(cEmpDest,cFilDest,cnota,aItensi,_condpg,cCgcFor,cSerie)
		
		EndIf
	
	
	EndIf

Return(cNota)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³GerIndCom º Autor ³ Cristiano Silva     º Data ³ 20/09/07   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao ³ Programa para gerar nota entrada da Ind. para Comercial    º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºAlteracao ³                                                            º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³ SIGAFAT - Especifico Scarlat                               º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function GerTraObra(cEmpa,cFiliala,cnota,aItensi,_condpg,cCgcFor,cSerie)

	Local aCabec := {}
	Local aLinha := {}
	Local nX := 0
	Local nY := 0
	Local cDoc := ""
	Local lOk := .T.

	Private aItensNota := {}
	PRIVATE lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

//PREPARE ENVIRONMENT EMPRESA _cEmpa Filial _cFiliala modulo 'FAT'
	Conout("Estou processando a Nota Fiscal de Entrada ")

//WfPrepEnv(cEmpA,cFiliala)

	Private aUF := {}

	aadd(aUF,{"RO","11"})
	aadd(aUF,{"AC","12"})
	aadd(aUF,{"AM","13"})
	aadd(aUF,{"RR","14"})
	aadd(aUF,{"PA","15"})
	aadd(aUF,{"AP","16"})
	aadd(aUF,{"TO","17"})
	aadd(aUF,{"MA","21"})
	aadd(aUF,{"PI","22"})
	aadd(aUF,{"CE","23"})
	aadd(aUF,{"RN","24"})
	aadd(aUF,{"PB","25"})
	aadd(aUF,{"PE","26"})
	aadd(aUF,{"AL","27"})
	aadd(aUF,{"MG","31"})
	aadd(aUF,{"ES","32"})
	aadd(aUF,{"RJ","33"})
	aadd(aUF,{"SP","35"})
	aadd(aUF,{"PR","41"})
	aadd(aUF,{"SC","42"})
	aadd(aUF,{"RS","43"})
	aadd(aUF,{"MS","50"})
	aadd(aUF,{"MT","51"})
	aadd(aUF,{"GO","52"})
	aadd(aUF,{"DF","53"})
	aadd(aUF,{"SE","28"})
	aadd(aUF,{"BA","29"})
	aadd(aUF,{"EX","99"})

	cDoc := cNota

	aNota := {}
	aadd(aNota,SF2->F2_SERIE)
	aadd(aNota,SF2->F2_DOC)
	aadd(aNota,SF2->F2_EMISSAO)

	cChave := aUF[aScan(aUF,{|x| x[1] == "SP"})][02]

	cChave += FsDateConv(aNota[03],"YYMM")+SM0->M0_CGC+"55"+StrZero(Val(aNota[01]),3)+StrZero(Val(aNota[02]),9)

	cChave+=Inverte(StrZero(Val(aNota[02]),9))+"0"

	aCabec := {}

	If Empty(cDoc)
		Conout("Documento em branco")
		Return
	EndIf

	Conout("Condicao Pagto: "+_condpg)

	Conout("Empresa Atual "+SM0->M0_CODIGO )

	DbSelectArea("SA2")
	DbSetOrder(3)
	DbSeek(xFilial("SA2")+cCgcFor )

	aadd(aCabec,{"F1_TIPO" ,"N"})
	aadd(aCabec,{"F1_FORMUL" ,"N"})
	aadd(aCabec,{"F1_DOC" ,(cDoc)})
	aadd(aCabec,{"F1_SERIE" ,cSerie})
	aadd(aCabec,{"F1_EMISSAO",Date()})
	aadd(aCabec,{"F1_DESPESA",0})
	aadd(aCabec,{"F1_FORNECE",SA2->A2_COD })
	aadd(aCabec,{"F1_LOJA" ,SA2->A2_LOJA })
	aadd(aCabec,{"F1_ESPECIE","NF"})

	aadd(aCabec,{"F1_COND",_condpg})
	aadd(aCabec,{"F1_DESCONT",0,NIL})
	aadd(aCabec,{"F1_SEGURO",0,NIL})
	aadd(aCabec,{"F1_FRETE",0,NIL})
	aadd(aCabec,{"F1_CHVNFE",cChave,NIL})

	DbSelectArea("SB1")
	DbSetOrder(1)

	For nX := 1 To Len(aItensi)
	
		DbSeek(xFilial("SB1")+aItensi[nx][2][2])
	
		cTesEnt := If(Empty(SZ5->Z5_TESENT),"102",SZ5->Z5_TESENT )
	
		aLinha := {}
		aadd(aLinha,{"D1_ITEM" ,STRZERO(nx,2),Nil})
		aadd(aLinha,{"D1_COD" ,aItensi[nx][2][2],Nil})
		aadd(aLinha,{"D1_QUANT",aItensi[nx][3][2],Nil})
		aadd(aLinha,{"D1_VUNIT",aItensi[nx][4][2],Nil})
		aadd(aLinha,{"D1_TOTAL",(aItensi[nx][3][2])*(aItensi[nx][4][2]),Nil})
		aadd(aLinha,{"D1_TES",cTesEnt,Nil})
		AaDd(aLinha,{"D1_LOCAL",cAlmDest,Nil})
		Aadd(aLinha,{"D1_CC",cCCDes,NIL})
		aadd(aLinha,{"D1_SEGURO",0,NIL})
		aadd(aLinha,{"D1_VALFRE",0,NIL})
		aadd(aLinha,{"D1_DESPESA",0,NIL})
		aadd(aLinha,{"AUTDELETA" ,"N",Nil}) // Incluir sempre no último elemento do array de cada item
	
		aadd(aItensNota,aLinha)
	
	Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Teste de Inclusao |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Conout("Entrando na Empresa Atual - Mata103 "+SM0->M0_CODIGO )

//	MATA103(aCabec,aItensNota,3)

	Conout("Saindo na Empresa Atual - Mata103 "+SM0->M0_CODIGO )

	If !lMsErroAuto
		Alert("Incluido Nota de entrada com sucesso! "+cDoc)
	Else
		MOSTRAERRO()
		ConOut("Erro na inclusao da nota de entrada!"+cDoc)
	EndIf

//Volta para empresa corrente

	DbSelectArea("SM0")

//RESET ENVIRONMENT
//RpcClearEnv()

//PREPARE ENVIRONMENT EMPRESA _cEmpa Filial _cFiliala modulo 'FAT'
	Conout("Estou processando a Nota Fiscal de Entrada na Comercial")

Return (cDoc)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraArqTrbºAutor  ³Carlos R Moreira    º Data ³  07/17/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera o arquivo de trabalho                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraArqTrb()
	Local oDlg1

//Limpo o Arquivo
	DbSelectArea("TRB")
	Zap

	If SZ5->Z5_TPMOV == "P"
	
		cQuery := " SELECT SB1.B1_COD, SB1.B1_DESC, SB1.B1_LOCPAD,SB1.B1_UPRC,SB1.B1_PRD_LOC "
		cQuery += " FROM "+RetsqlName("SB1")+" SB1 "
		cQuery += " WHERE  SB1.D_E_L_E_T_<>'*' AND SB1.B1_PRD_LOC <> ' ' "
	
		MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde selecionando os produtos..")
	
		DbSelectArea("QRY")
		DbGoTop()
	
		While QRY->(!Eof())
		
			If QRY->B1_PRD_LOC <> 'D'
			
				SB2->(DbSetOrder(1))
				If SB2->(DbSeek(xFilial("SB2")+QRY->B1_COD+If(Empty(cAlmOri),QRY->B1_LOCPAD,cAlmOri) ))
					nSaldo := SB2->B2_QATU
				Else
					nSaldo := 0
				EndIf
			
/*			If nSaldo <= 0
				QRY->(DbSkip())
				Loop
			EndIf */ 
			EndIf
		
			DbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->PROD   := QRY->B1_COD
			TRB->DESC   := QRY->B1_DESC
			TRB->QTDE   := nSaldo
			TRB->UPRC   := QRY->B1_UPRC
			TRB->ALMORI := If(Empty(cAlmOri),QRY->B1_LOCPAD,cAlmOri)
			TRB->PRD_LOC:= QRY->B1_PRD_LOC
			MsUnlock()
		
			DbSelectarea("QRY")
			DbSkip()
		
		End
	
	ElseIf SZ5->Z5_TPMOV == "A"
	
		cQuery := " SELECT SB1.B1_COD, SB1.B1_DESC, SB1.B1_LOCPAD,SB1.B1_UPRC,SB1.B1_GRUPO "
		cQuery += " FROM "+RetsqlName("SB1")+" SB1 "
		cQuery += " WHERE  SB1.D_E_L_E_T_<>'*' AND SB1.B1_PRD_LOC = 'A' "
	
		MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde selecionando os produtos..")
	
		DbSelectArea("QRY")
		DbGoTop()
	
		While QRY->(!Eof())
		
			If !Empty(SZ5->Z5_GRUPO)
      
				If ! QRY->B1_GRUPO $ SZ5->Z5_GRUPO
					DbSkip()
					Loop
				EndIf
      
			EndIf

    If SZ5->Z5_OPER == "05"
				SB2->(DbSetOrder(1))
				If SB2->(DbSeek(xFilial("SB2")+QRY->B1_COD+If(Empty(cAlmOri),QRY->B1_LOCPAD,cAlmOri) ))
					nSaldo := SB2->B2_QATU
				Else
					nSaldo := 0
				EndIf
			Else
			   nSaldo := 0  	
     EndIf 
     
			DbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->PROD   := QRY->B1_COD
			TRB->DESC   := QRY->B1_DESC
			TRB->UPRC   := QRY->B1_UPRC
			TRB->ALMORI := QRY->B1_LOCPAD
			TRB->GRUPO  := QRY->B1_GRUPO
			TRB->QTDE   := nSaldo
			MsUnlock()
		
			DbSelectarea("QRY")
			DbSkip()
		
		End
	
	ElseIf SZ5->Z5_TPMOV == "T"
	
		cQuery := " SELECT SB6.B6_PRODUTO, SB1.B1_DESC, SB6.B6_SALDO,SB6.B6_LOCAL, SB6.B6_IDENT,SB6.B6_PRUNIT,SB6.B6_EQSERIE, SB6.B6_DOC "
		cQuery += " FROM "+RetsqlName("SB6")+" SB6 "
		cQuery += " JOIN "+RetsqlName("SB1")+" SB1 ON "
		cQuery += " SB1.D_E_L_E_T_<>'*' AND SB6.B6_PRODUTO = SB1.B1_COD "
		cQuery += " WHERE  SB6.D_E_L_E_T_<>'*' AND SB6.B6_CC = '" + BusCusto(cCCOri) + "' AND SB6.B6_SALDO > 0 "
	
		MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde selecionando os produtos..")
	
		DbSelectArea("QRY")
		DbGoTop()
	
		While QRY->(!Eof())
		
			DbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->PROD    := QRY->B6_PRODUTO
			TRB->DESC    := QRY->B1_DESC
			TRB->QTDE    := QRY->B6_SALDO
			TRB->ALMORI  := QRY->B6_LOCAL
			TRB->IDENT   := QRY->B6_IDENT
			TRB->UPRC    := QRY->B6_PRUNIT
			TRB->EQSERIE := QRY->B6_EQSERIE
			TRB->DOC     := QRY->B6_DOC
			MsUnlock()
		
			DbSelectarea("QRY")
			DbSkip()
		
		End
	
	EndIf

	QRY->(DbCloseArea())

	lMostra := .T.

	aBrowse := {}
	AaDD(aBrowse,{"OK","",""})
	AaDD(aBrowse,{"PROD","","Produto"})
	AaDD(aBrowse,{"DESC","","Descricao"})
	AaDD(aBrowse,{"EQSERIE","","Serie"})
	AaDD(aBrowse,{"DOC","","NF Orig"})
	AaDD(aBrowse,{"QTDE","","Quantidade","@E 999,999" })
	AaDD(aBrowse,{"QTDLIB","","Qtde Sol","@E 999,999" })
	AaDD(aBrowse,{"ALMORI","","Alm. Origem"})

	DbSelectArea("TRB")
	TRB->(DbGoTop())

	If TRB->(Eof())
		MsgAlert("Nao existe produtos disponivel para a operacao.")
		Return .F.
	EndIf

	nOpca    :=0
	lInverte := .F.
	cMarca   := GetMark()
	cTit     := "Selecao de Produto"
	DEFINE MSDIALOG oDlg1   TITLE cTit From 9,0 To 25,100 OF oMainWnd

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Passagem do parametro aCampos para emular tamb‚m a markbrowse para o ³
//³ arquivo de trabalho "TRB".                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oMark := MsSelect():New("TRB","OK","",aBrowse,@lInverte,@cMarca,{15,3,118,395})

	oMark:bMark := {| | fa060disp(cMarca,lInverte)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca,1) }

	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||oDlg1:End()},1) centered

	If nOpca == 1
	
		aCols := {}
	
		DbSelectArea("TRB")
		DbGoTop()
	
		While TRB->(!Eof())
		
			If Empty(TRB->OK)
				Reclock("TRB",.F.)
				TRB->(DbDelete())
				MsUnlock()
				DbSkip()
				Loop
			EndIf
		
			If SZ5->Z5_TPMOV # "A"
				If TRB->PRD_LOC == "D" .And.  TRB->QTDITEM > 0
					For nX := 1 to TRB->QTDITEM
						AADD(aCOLS,{TRB->PROD,TRB->DESC,0,"","","",.F.})
					Next
				
				Else
					AADD(aCOLS,{TRB->PROD,TRB->DESC,0,TRB->IDENT,"","",.F.})
				EndIf
			Else

      If SZ5->Z5_OPER == "04" 
				
				   SelAtivo()
				   
      Else 
			   
			  //For nX := 1 to TRB->QTDITEM
			    AADD(aCOLS,{TRB->PROD,TRB->DESC,0,"","","",.F.})
			    //	AADD(aCOLS,{TRB->PROD,TRB->DESC,0,"",.F.})
			  //Next

			  EndIf 
			  
			EndIf
		
			Reclock("TRB",.F.)
			TRB->OK := Space(2)
			MsUnlock()
		
			DbSkip()
		
		End
	
		cIndex := CriaTrab(Nil,.F.)
		IndRegua("TRB",cIndex,"PROD+IDENT",,,"Selecionando Registros..." )
	
		n := 1
	
		If Len(aCols) > 0
		
			GetQtdPrd()
		
		EndIf
	
	EndIf

	DlgRefresh(oDlg)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FA060Disp ³ Autor ³ Carlos R. Moreira     ³ Data ³ 09/05/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exibe Valores na tela									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Especifico                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa060Disp(cMarca,lInverte)
	Local aTempos, cClearing, oCBXCLEAR, oDlgClear,lCOnf
	If IsMark("OK",cMarca,lInverte)
	
		If TRB->PRD_LOC == "D" .And. Empty(cTesDesp)
		
			MsgStop("Tes em branco para o produto de Despesa.")
		
			Reclock("TRB",.F.)
			TRB->OK := Space(2)
			MsUnlock()
		
		EndIf
	
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fa060Inve ºAutor  ³Carlos R. Moreira   º Data ³  19/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³inverte a Selecao dos Itens                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa060Inverte(cMarca)
	Local nReg := TRB->(Recno())
	Local cAlias := Alias()

	dbSelectArea("TRB")
	dbGoTop()
	While !Eof()
		RecLock("TRB")
		TRB->OK := IIF(TRB->OK == "  ",cMarca,"  ")
		MsUnlock()
		dbSkip()
	Enddo
	TRB->(dbGoto(nReg))
	oMark:oBrowse:Refresh(.t.)
Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³LchoiceBar³ Autor ³ Pilar S Albaladejo    ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mostra a EnchoiceBar na tela                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LchoiceBar(oDlg,bOk,bCancel,nOpcao)
	Local oBar, bSet15, bSet24, lOk
	Local lVolta :=.f.

	DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
	DEFINE BUTTON RESOURCE "S4WB011N" OF oBar GROUP ACTION ProcProd() TOOLTIP OemToAnsi("Procura Produto..")
	If SZ5->Z5_TPMOV == "A" .Or. SZ5->Z5_TPMOV == "P"
		DEFINE BUTTON RESOURCE "EDIT" OF oBar GROUP ACTION PegaQtd() TOOLTIP OemToAnsi("Digita a quantidade de itens..")
	EndIf
	DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
	SetKEY(15,oBtOk:bAction)
	DEFINE BUTTON oBtCan RESOURCE "FINAL" OF oBar ACTION ( lLoop:=.F.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP OemToAnsi("Cancelar - <Ctrl-X>")  //
	SetKEY(24,oBtCan:bAction)
	oDlg:bSet15 := oBtOk:bAction
	oDlg:bSet24 := oBtCan:bAction
	oBar:bRClicked := {|| AllwaysTrue()}

//DEFINE BUTTON oBtOk RESOURCE "FINAL" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
//SetKEY(15,oBtOk:bAction)
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProcPedidoºAutor  ³Carlos R. Moreira   º Data ³  19/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Localiza o Produto                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcProd()
	Local cProd := Space(15)
	Local oDlgProc

	DEFINE MSDIALOG oDlgProc TITLE "Procura Produto" From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,155 of oDlgProc PIXEL

	@ 15,5 Say "Produto :" Size 50,10  of oDlgProc Pixel
	@ 13,45 MSGet cProd   Size 60,10 of oDlgProc Pixel

	@ 50, 90 BMPBUTTON TYPE 1 Action PosProd(@cProd,oDlgProc)
	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

Return


Static Function PosProd(cProd,oDlgProc)

	TRB->(DbSeek(Alltrim(cProd),.T.))

	Close(oDlgProc)

Return

//Qtde de Itens de Ativos

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProcPedidoºAutor  ³Carlos R. Moreira   º Data ³  19/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Pega a quantidade de itens para o ativo                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PegaQtd()
	Local nQtdItem := 1
	Local oDlgProc

	If SZ5->Z5_TPMOV # "A"
	
		If TRB->PRD_LOC # "D"
			Return
		EndIf
	
	EndIf

	DEFINE MSDIALOG oDlgProc TITLE "Quantidade Itens "+Alltrim(TRB->PROD) From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,155 of oDlgProc PIXEL

	@ 15,5 Say "Quantidade :" Size 50,10  of oDlgProc Pixel
	@ 13,45 MSGet nQtdItem Picture "@E 99" Valid nQtdItem > 0 Size 60,10 of oDlgProc Pixel

	@ 50, 90 BMPBUTTON TYPE 1 Action GrvQtd(oDlgProc,nQtdItem)
//@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

Return


Static Function GrvQtd(oDlgProc,nQtdItem)

	DbSelectarea("TRB")
	RecLock("TRB",.F.)
	TRB->QTDITEM := nQtdItem
	MsUnlock()

	Close(oDlgProc)

Return

//Final


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TRANSOBRAºAutor  ³Microsiga           º Data ³  07/18/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Solicita as Quantidades dos produtos                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GetQtdPrd()
	Local oDlg
	Local aSize     := MsAdvSize(.T.)
	Local aObjects:={},aInfo:={},aPosObj:={}
	Local aInfo   :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	AADD(aObjects,{100,025,.T.,.F.})
	AADD(aObjects,{100,100,.T.,.T.})
	AAdd( aObjects, { 0, 40, .T., .F. } )

	aPosObj:=MsObjSize(aInfo,aObjects)

	aCpos := {"B1_DESC","B1_PESBRU"}

	nOpca := 0

	DEFINE MSDIALOG oDlg TITLE "Gera Pedidos de Transferencia de produtos" From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	@ 5,2   To 43,644 OF odlg PIXEL
	@ 49,2  To 97,644 OF odlg PIXEL

	@ 60,8    Say OemToAnsi("Operacao:" ) Size 37,8 Font oFont Color CLR_RED OF odlg PIXEL

	@ 60,100  Say OemToAnsi("Origem :" ) Size 37,8 Font oFont Color CLR_RED OF odlg PIXEL

	@ 60,380  Say OemToAnsi("Destino :" ) Size 37,8 Font oFont Color CLR_RED OF odlg PIXEL

	@ 58, 63  Get cOper   F3 "SZ5"     Size 25,10  When .F.
	@ 58,140  Get cCCOri  F3 "CTTOBR"  Size 60,10  When .F.
	@ 58,420  Get cCCDes  F3 "CTTOBR"  Size 60,10  When .F.

	@ 58,213  Get cDesCCOri Size 150,10  When .f.
	@ 58,490  Get cDesCCDes Size 150,10  When .f.

	oEspBmp := TBmpRep():New(09,592, 50, 28,, .T.,odlg, , , .F., .T., , , .F., , .T., , .F. )
	oEspBmp:cbmpfile := "LGMID"+SM0->M0_CODIGO+".PNG" //"logo0101.jpg"

	_oSayTime:=TSay():New(010,_npos,{||_cSayTime},oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLUE,,150,10,.T.,.F.,.T.,.F.,.F.)

	_oSayTime:lTransparent := .T.

//oGet := MSGetDados():New(aPosObj[2,1]+70,aPosObj[2,2],aPosObj[2,3]+30,aPosObj[2,4],nOpcx,"U_PFATA05LinOK","U_TraObraTudOK",,,aCpos,1) //,,.T.)
	oGet := MsGetDados():New(aPosObj[2,1]+70,aPosObj[2,2],aPosObj[2,3]+30,aPosObj[2,4],nOpcx,"U_TraObraLinOK","U_TraObraTudOK",,.T.,aCpos,1)//,,500)

//@ 18,004 Button OemToAnsi("Refazer") Size 36,16 ACTION REFAZER()  Of odlg PIXEL font oFont
	@ 18,054 Button OemToAnsi("Gerar") Size 36,16 ACTION {||nOpca:=1,Odlg:End()}  Of odlg PIXEL font oFont
	@ 18,104 Button OemToAnsi("Voltar")     Size 36,16 ACTION Odlg:End() Of odlg PIXEL font oFont

	ACTIVATE MSDIALOG odlg CENTERED

	If nOpca == 1
	
		If SZ5->Z5_TPMOV # "A"
		
			DbSelectArea("TRB")
			TRB->(DbGotop())
		
			While TRB->(!Eof())
			
				If TRB->PRD_LOC == "D"
					RecLock("TRB",.F.)
					TRB->(DbDelete())
					MsUnlock()
				EndIf
			
				TRB->(DbSkip())
			
			End
		
			For nX:= 1 to Len(aCols)
			
				If !aCols[nX,Len(aHeader)+1]
					SB1->(DbSetOrder(1))
					SB1->(DbSeek(xFilial("SB1")+aCols[nX,1]))
				
					If SB1->B1_PRD_LOC # "D"
						If DbSeek(aCols[nX,1]+aCols[nX,4])
							RecLock("TRB",.F.)
							TRB->QTDLIB := aCols[nX,3]
							TRB->DESC   := aCols[nX,2]
							MsUnlock()
						EndIf
					Else
					
						RecLock("TRB",.T.)
						TRB->PROD   := aCols[nX,1]
						TRB->QTDLIB := aCols[nX,3]
						TRB->DESC   := aCols[nX,2]
						TRB->ALMORI := Posicione("SB1",1,xFilial("SB1")+aCols[nX,1],"B1_LOCPAD")
						
						MsUnlock()
					
					EndIf
				EndIf
			Next
		
		Else
		
			DbSelectArea("TRB")
			cProd := TRB->PROD
			ZAP
		
			For nX:= 1 to Len(aCols)
			
				RecLock("TRB",.T.)
				TRB->PROD   := If(SZ5->Z5_OPER == "04",cProd,aCols[nX,1] ) //Mantenho o produto inicial
				TRB->QTDLIB := aCols[nX,3]
				TRB->DESC   := aCols[nX,2]
				TRB->ALMORI := Posicione("SB1",1,xFilial("SB1")+aCols[nX,1],"B1_LOCPAD")
				TRB->CBASE  := aCols[nX,5]
				TRB->ITEM   := aCols[nX,6]
				TRB->UPRC   := Posicione("SN3",1,xFilial("SN3")+TRB->CBASE+TRB->ITEM,"N3_VORIG1")
				MsUnlock()
			
			Next
		
		EndIf
		TRB->(DbGotop())
	
		LjMsgRun("Aguarde o final do processamento..","Aguarde",{||ProcPed()} )
	
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TraObraTudOKºAutor  ³Carlos R Moreira	 º Data ³  07/21/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se esta tudo ok                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TraObraTudOK()
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TraObraLinOK ºAutor ³Carlor R Moreira  º Data ³  07/21/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a linha de digitacao                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TraObraLinOK()
	Local lRet := .T.
	Local nQtde := Ascan(aHeader,{|x|Upper(Alltrim(x[2])) == "B1_PESBRU" } )
	Local nProd := Ascan(aHeader,{|x|Upper(Alltrim(x[2])) == "B1_COD" } )

/*
DbSelectArea("TRB")
DbSeek( aCols[n,nProd] )
If TRB->QTDE < aCols[n,nQtde] .And. SZ5->Z5_TPMOV # "A" .And. TRB->PRD_LOC # "D"
	
	MsgStop("Qtde liberada maior que a qtde disponivel. Qtde Dispo.: "+Transform(TRB->QTDE,"@E 999,999"))
	lRet := .F.
	
EndIf */

Return  lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BuscaPrc  ºAutor  ³Microsiga           º Data ³  07/28/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BuscaPrc(cProduto)
	Local nPrc := 0
	Local oDlg
	Local oProd, oPrc

	Private oFont1  := TFont():New( "TIMES NEW ROMAN",12.5,18,,.T.,,,,,.F.)
	Private oFont2  := TFont():New( "TIMES NEW ROMAN",12.5,12,,.T.,,,,,.F.)
	Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)
	Private oFont3  := TFont():New( "ARIAL",10.5,10,,.T.,,,,,.F.)

	Private oEquip, oSerie

	If SZ5->Z5_TPMOV # "A" .And. SB1->B1_PRD_LOC # "D"
	
		BeginSql Alias "PRC"
		
			Select MAX(D1_VUNIT) AS PRC  FROM %Table:SD1%  WHERE D_E_L_E_T_ <> '*' AND D1_COD = %exp:cProduto%
		
		EndSql
	
		nPrc := PRC->PRC
	
		If nPrc == 0
		
			nPrc := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_UPRC")
		
			If nPrc == 0  // Se continuar o preço zerado pede o valor
		
				cProd := ALLTRIM(TRB->PROD)+"-"+Alltrim(TRB->DESC)
	
				While .T.
		
					nOpca  := 0
		
					DEFINE MSDIALOG oDlg TITLE OemToAnsi("Valor do Produto") From 9,0 To 28,80 OF oMainWnd
		
					@   5,05 to 40,315 title "Produto "
		
					@   45,05 to 090,315 title "Valor"
		
					@ 17, 10 MSGET oProd VAR cProd When .T. SIZE 300,14  PIXEL;
						OF oDlg  COLOR CLR_HBLUE FONT oFont1 RIGHT  //VALID ChkRG(@cRG,oSay)
		
					@ 60, 10 MSGET oPrc VAR nPrc Picture "@E 999,999,999.99"  SIZE   300,14 PIXEL;
						OF oDlg  COLOR CLR_HBLUE FONT oFont1 RIGHT
		
					@ 120, 80 Button "&Confirma"     Size 50,15 Action {||nOpca:=1,oDlg:End()} of oDlg Pixel //Localiza o Dia
					@ 120,140 Button "&Cancelar"     Size 50,15 Action {||nOpca:=2,oDlg:End()} of oDlg Pixel //Localiza o Dia
		
					ACTIVATE MSDIALOG oDlg CENTERED
		
					If nOpca == 1
			
						If nPrc == 0
							MsgStop("Voce deve informar o valor do ativo.")
							Loop
						EndIf
			
						Exit
			
					EndIf
		
				End

			EndIf
		
		
		EndIf
	
		PRC->(DbCloseArea())
	
	Else
	
		cProd := ALLTRIM(TRB->PROD)+"-"+Alltrim(TRB->DESC)
	
		While .T.
		
			nPrc  := TRB->UPRC
			nOpca  := 0
		
			DEFINE MSDIALOG oDlg TITLE OemToAnsi("Valor do Produto") From 9,0 To 28,80 OF oMainWnd
		
			@   5,05 to 40,315 title "Produto "
		
			@   45,05 to 090,315 title "Valor"
		
			@ 17, 10 MSGET oProd VAR cProd When .T. SIZE 300,14  PIXEL;
				OF oDlg  COLOR CLR_HBLUE FONT oFont1 RIGHT  //VALID ChkRG(@cRG,oSay)
		
			@ 60, 10 MSGET oPrc VAR nPrc Picture "@E 999,999,999.99"  SIZE   300,14 PIXEL;
				OF oDlg  COLOR CLR_HBLUE FONT oFont1 RIGHT
		
			@ 120, 80 Button "&Confirma"     Size 50,15 Action {||nOpca:=1,oDlg:End()} of oDlg Pixel //Localiza o Dia
			@ 120,140 Button "&Cancelar"     Size 50,15 Action {||nOpca:=2,oDlg:End()} of oDlg Pixel //Localiza o Dia
		
			ACTIVATE MSDIALOG oDlg CENTERED
		
			If nOpca == 1
			
				If nPrc == 0
					MsgStop("Voce deve informar o valor do ativo.")
					Loop
				EndIf
			
				Exit
			
			EndIf
		
		End
	
	
	EndIf

Return nPrc


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TRANSFERENCIA PRODUTOS OBRASºAutor  ³Microsiga           º Data ³  07/28/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Inverte(uCpo, nDig)
	Local cRet	:= ""
	Default nDig := 9

	cRet	:=	GCifra(Val(uCpo),nDig)

Return(cRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PegaDadosCompºAutor  ³Microsiga           º Data ³  08/13/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PegaDadosComp()
	Local oDlgProc

	nPeso     := nVolume := 0
	cEspecie  := Space(10)
	cMensPad  := Space(3)
	cMensNota := Space(250)
	cVeiculo  := Space(7)

	While .T.
	
		DEFINE MSDIALOG oDlgProc TITLE "Dados Complementares para NF" From 9,0 To 29,80 OF oMainWnd
	
		@ 5,3 to 132,315 of oDlgProc PIXEL
	
		@ 13, 10 Say "Mensagem: " Size 60,10  of oDlgProc Pixel
	
		@ 13, 60 MsGet cMensNota  When .T.  Picture "@S60" SIZE 230, 10 OF oDlgProc PIXEL
	
		@ 33, 10  Say "Men. Pad:" Size 50,10  of oDlgProc Pixel
		@ 33, 60 MsGet cMensPad  F3 "SM4" When .T.  SIZE 30, 10 OF oDlgProc PIXEL
	
		@ 53, 10 Say "Peso : " Size 50,10  of oDlgProc Pixel
	
		@ 53, 60 MSGET nPeso Picture "@E 999,999,999" SIZE 70, 10 OF oDlgProc PIXEL
	
		@  73, 10 Say "Especie: " Size 50,10  of oDlgProc Pixel
	
		@  73, 60 MSGET cEspecie Picture "@!" SIZE 70, 10 OF oDlgProc PIXEL
	
		@  73, 210 Say "Volume: "  Size 50,10  of oDlgProc Pixel
	
		@  73, 240 MSGET nVolume  When .T. Picture "@E 999,999,999" SIZE 60, 10 OF oDlgProc PIXEL
	
		@  93, 210 Say "Veiculo: "  Size 50,10  of oDlgProc Pixel
	
		@  93, 240 MSGET cVeiculo  When .T. Valid VldPlaca(cVeiculo) SIZE 60, 10 OF oDlgProc PIXEL

		@ 134, 250 BMPBUTTON TYPE 1 Action Close(oDlgProc)
	//@ 70,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)
	
		ACTIVATE MSDIALOG oDlgProc Centered
	
	
		If MsgYesNo("Confirma os dados")
		
			Exit
		
		EndIf
	
	End

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GetIdEnt  ³ Autor ³Eduardo Riera          ³ Data ³18.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Obtem o codigo da entidade apos enviar o post para o Totvs  ³±±
±±³          ³Service                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: Codigo da entidade no Totvs Services                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RetIdEnti()
Return(GetIdEnt())

Static Function GetIdEnt()

	Local aArea  := GetArea()
	Local cIdEnt := ""
	Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local oWs
	Local lUsaGesEmp := IIF(FindFunction("FWFilialName") .And. FindFunction("FWSizeFilial") .And. FWSizeFilial() > 2,.T.,.F.)
	Local lEnvCodEmp := GetNewPar("MV_ENVCDGE",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oWS := WsSPEDAdm():New()
	oWS:cUSERTOKEN := "TOTVS"

	oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
	oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
	oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
	oWS:oWSEMPRESA:cFANTASIA   := IIF(lUsaGesEmp,FWFilialName(),Alltrim(SM0->M0_NOME))
	oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
	oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
	oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
	oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
	oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
	oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
	oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
	oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
	oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
	oWS:oWSEMPRESA:cCEP_CP     := Nil
	oWS:oWSEMPRESA:cCP         := Nil
	oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
	oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
	oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
	oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
	oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
	oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
	oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cINDSITESP  := ""
	oWS:oWSEMPRESA:cID_MATRIZ  := ""

	If lUsaGesEmp .And. lEnvCodEmp
		oWS:oWSEMPRESA:CIDEMPRESA:= FwGrpCompany()+FwCodFil()
	EndIf

	oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
	oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
	If oWs:ADMEMPRESAS()
		cIdEnt  := oWs:cADMEMPRESASRESULT
	Else
		Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
	EndIf

	RestArea(aArea)
Return(cIdEnt)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³SpedNFeTrf³ Autor ³Eduardo Riera          ³ Data ³21.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de remessa da Nota fiscal eletronica para o Totvs    ³±±
±±³          ³Service SPED                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: Mensagem de retorno                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias da tabela da Mbrowse                           ³±±
±±³          ³ExpC2: Serie                                                ³±±
±±³          ³ExpC3: Nota inicial                                         ³±±
±±³          ³ExpC4: Nota final                                           ³±±
±±³          ³ExpC5: Id da entidade empresarial                           ³±±
±±³          ³ExpC6: Ambiente de emissao da NFe                           ³±±
±±³          ³ExpC7: Modalidade de emissao da NFe                         ³±±
±±³          ³ExpC8: Versa da NFe                                         ³±±
±±³          ³ExpL9: Controle de encerramento                             ³±±
±±³          ³ExpL10: Controle de execucao em Job                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SpedNFeTrf(cAlias,cSerie,cNotaIni,cNotaFim,cIDEnt,cAmbiente,cModalidade,cVersao,lEnd,lCte,lAuto)

	Local aArea			:= GetArea()
	Local aNotas		:= {}
	Local aNotasOri		:= {}
	Local aRetNotas		:= {}
	Local aXml			:= {}
	Local aNfCup		:= {{"",CTOD("  /  /  "),"","","","","",""}} // Array com as Notas sobre cupom
	Local aMotivoCont	:= {}
	Local aInfnota		:= {}
	Local aValNFe		:= {}

	Local cRetorno		:= ""
	Local cAliasSF3		:= "SF3"
	Local cAliasSF1		:= "SF1"
	Local cWhere		:= ""
	Local cErro			:= ""
	Local cHoraIni		:= Time()
	Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cNfCup		:= "CF/SERIE:" // Identifica que eh Nf sobre Cup
	Local cFsimpFat		:= "F - Simples Faturamento"						// Identifica se é Nf sobre Cupom Nova validação Lj.

	Local dDataIni		:= Date()

	Local lQuery		:= .F.
	Local lRetorno		:= .T.
	Local lTMSCTe		:= SuperGetMv( "MV_TMSCTE", .F., .F. )
	Local lFISVALNFE	:= ExistBlock("FISVALNFE")
	Local lTermScan     := .F.

	Local nX			:= 0
	Local nY			:= 0
	Local nNFes			:= 0
	Local nXmlSize		:= 0
	Local nPosAux		:= 0 // Posicao auxiliar
	Local nTemp			:= 0

	Local oWs

	Default lCTe		:= .F.
	Default lAuto		:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a integridade da rotina caso exista filtro             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If (!lCTe)
//	dbSelectArea(cAlias)
//	dbClearFilter()
//	RetIndex(cAlias)
//EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alimenta o array    aInfnota                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aInfnota,cSerie)
	aadd(aInfnota,cNotaIni)
	aadd(aInfnota,cNotaFim)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Analisa parametros                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAmbiente   := SubStr(cAmbiente,1,1)
	cModalidade := SubStr(cModalidade,1,1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cancela as notas do dia anterior                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lAuto
		SpedNFeCan(cEmpAnt,cFilAnt,cIdEnt,cAmbiente,cModalidade,cVersao,aInfnota,lCTe)
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra as notas fiscais do dia                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem as informacoes de contigencia                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cModalidade$"2,3,5,7"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Contingencia SCAN - Quando a serie da NFe for menor que 900-999 ³
	//³	nao realiza transmissao e nao grava nas tabelas do SPED		    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cModalidade = "3"
			If Alltrim(cSerie) < "900"
				lTermScan	:= .T.
				lRetorno	:= .F.
			EndIf
		EndIf
	
		oWs2 := WsSpedCfgNFe():New()
		oWS2:cUSERTOKEN := "TOTVS"
		oWS2:cID_ENT    := cIdEnt
		oWS2:dDATEINIC  := SToD("  /  /    ")
		oWS2:dDATEFIM   := SToD("  /  /    ")
		oWS2:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
		oWS2:GetDateCont()
		If Type("oWS2:oWSGETDATECONTRESULT")=="O" .And. Type("oWS2:oWSGETDATECONTRESULT:OWSGETCONT")=="A" .And. Len(oWS2:oWSGETDATECONTRESULT:OWSGETCONT)>0
			aAdd(aMotivoCont,AllTrim(oWS2:oWSGETDATECONTRESULT:OWSGETCONT[Len(oWS2:oWSGETDATECONTRESULT:OWSGETCONT)]:CXMOTIVO))
			aAdd(aMotivoCont,oWS2:oWSGETDATECONTRESULT:OWSGETCONT[Len(oWS2:oWSGETDATECONTRESULT:OWSGETCONT)]:DDATEINIC)
			aAdd(aMotivoCont,AllTrim(oWS2:oWSGETDATECONTRESULT:OWSGETCONT[Len(oWS2:oWSGETDATECONTRESULT:OWSGETCONT)]:CTIMEINIC))
		EndIf
	EndIf
	If (!lCTe) .And. !lTermScan
		If !lAuto
			ProcRegua(Val(cNotaFim)-Val(cNotaIni)+1)
		EndIf
	//---------------Tratamento para Transmisso de notas de Entrada sem SF3 --------------------//
		If SF1->(FieldPos("F1_STATUS"))>0
			dbSelectArea("SF1")
			dbSetOrder(1)
			#IFDEF TOP
				cWhere := "%( (SF1.F1_FORMUL='S' And SF1.F1_STATUS='C'))%"
				cAliasSF1 := GetNextAlias()
				lQuery    := .T.
				BeginSql Alias cAliasSF1
				
					COLUMN F1_EMISSAO AS DATE
				
					SELECT	F1_FILIAL,F1_EMISSAO,F1_NFeLETR,F1_FORMUL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_ESPECIE,F1_STATUS				FROM %Table:SF1% SF1
					WHERE
					SF1.F1_FILIAL = %xFilial:SF1% AND
					SF1.F1_SERIE = %Exp:cSerie% AND
					SF1.F1_DOC >= %Exp:cNotaIni% AND
					SF1.F1_DOC <= %Exp:cNotaFim% AND
					%Exp:cWhere% AND
					SF1.%notdel%
				EndSql
				cWhere := ".T."
			#ELSE
				MsSeek(xFilial("SF1")+cNotaIni+cSerie,.T.)
			#ENDIF
			cWhere := "(F1_FORMUL='S' .And. F1_STATUS='C')"
		EndIf
	
		While !Eof() .And. xFilial("SF1") == (cAliasSF1)->F1_FILIAL .And.;
				(cAliasSF1)->F1_SERIE == cSerie .And.;
				(cAliasSF1)->F1_DOC >= cNotaIni .And.;
				(cAliasSF1)->F1_DOC <= cNotaFim
		/*
		+------------------------------------------------------+
		|PONTO DE ENTRADA PARA VALIDAÇÃO DA TRANSMISSAO DA NOTA|
		+------------------------------------------------------+
		*/
			If lFISVALNFE
				aValNFe:={}
				Aadd(aValNFe,"E")
				Aadd(aValNFe,(cAliasSF1)->F1_FILIAL)
				Aadd(aValNFe,(cAliasSF1)->F1_EMISSAO)
				Aadd(aValNFe,(cAliasSF1)->F1_DOC)
				Aadd(aValNFe,(cAliasSF1)->F1_SERIE)
				Aadd(aValNFe,(cAliasSF1)->F1_FORNECE)
				Aadd(aValNFe,(cAliasSF1)->F1_LOJA)
				Aadd(aValNFe,(cAliasSF1)->F1_ESPECIE)
				Aadd(aValNFe,(cAliasSF1)->F1_FORMUL)
				If !ExecBlock("FISVALNFE",.F.,.F.,aValNFe)
					dbSelectArea(cAliasSF1)
					dbSkip()
					Loop
				EndIf
			EndIf
		
			dbSelectArea(cAliasSF1)
			If ((cAliasSF1)->F1_FORMUL=="S") .And. aScan(aNotas,{|x| x[3]+x[4]==(cAliasSF1)->F1_SERIE+(cAliasSF1)->F1_DOC})==0 .And. (cAliasSF1)->F1_STATUS='C'
			
				If !lAuto
					IncProc("(1/2) "+"Preparando nota: "+(cAliasSF1)->F1_DOC) //
				EndIf
				If (AModNot((cAliasSF1)->F1_ESPECIE)$"55,57" .Or. cAmbiente=="2") .And. &cWhere
					aadd(aNotas,{})
					nX := Len(aNotas)
					aadd(aNotas[nX],"0")
					aadd(aNotas[nX],(cAliasSF1)->F1_EMISSAO)
					aadd(aNotas[nX],(cAliasSF1)->F1_SERIE)
					aadd(aNotas[nX],(cAliasSF1)->F1_DOC)
					aadd(aNotas[nX],(cAliasSF1)->F1_FORNECE)
					aadd(aNotas[nX],(cAliasSF1)->F1_LOJA)
					aadd(aNotas[nX],aMotivoCont)
					If !lAuto
						aadd(aNotasOri,{})
						nX := Len(aNotasOri)
					
						aadd(aNotasOri[nX],(cAliasSF1)->F1_DOC)
						aadd(aNotasOri[nX],(cAliasSF1)->F1_SERIE)
					EndIf
				EndIf
			EndIf
			dbSelectArea(cAliasSF1)
			dbSkip()
		EndDo
		If lQuery
			dbSelectArea(cAliasSF1)
			dbCloseArea()
			dbSelectArea("SF1")
		EndIf
	
	//-----------------------------------------------------------------//
	EndIf
	dbSelectArea("SF3")
	dbSetOrder(5)
	#IFDEF TOP
		lQuery    	:= .T.
		cAliasSF3	:= GetNextAlias()
		cQuery 		:= retQueryTrans( .F., cNotaIni, cNotaFim, cSerie )
		cQuery 		:= ChangeQuery( cQuery )
	
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAliasSF3, .F., .T.)
	
		TcSetField(cAliasSF3,"F3_ENTRADA","D",08,0)
		TcSetField(cAliasSF3,"F3_DTCANC","D",08,0)
	#ELSE
		MsSeek(xFilial("SF3")+cSerie+cNotaIni,.T.)
	#ENDIF
	cWhere := "((SubStr(F3_CFO,1,1) < '5' .AND. F3_FORMUL='S') .OR. (SubStr(F3_CFO,1,1) >= '5'))"
	While !Eof() .And. xFilial("SF3") == (cAliasSF3)->F3_FILIAL .And.;
			(cAliasSF3)->F3_SERIE == cSerie .And.;
			(cAliasSF3)->F3_NFISCAL >= cNotaIni .And.;
			(cAliasSF3)->F3_NFISCAL <= cNotaFim
	/*
	+------------------------------------------------------+
	|PONTO DE ENTRADA PARA VALIDAÇÃO DA TRANSMISSAO DA NOTA|
	+------------------------------------------------------+
	*/
		If lFISVALNFE
			aValNFe:={}
			Aadd(aValNFe,IF((cAliasSF3)->F3_CFO < "5","E","S"))
			Aadd(aValNFe,(cAliasSF3)->F3_FILIAL)
			Aadd(aValNFe,(cAliasSF3)->F3_ENTRADA)
			Aadd(aValNFe,(cAliasSF3)->F3_NFISCAL)
			Aadd(aValNFe,(cAliasSF3)->F3_SERIE)
			Aadd(aValNFe,(cAliasSF3)->F3_CLIEFOR)
			Aadd(aValNFe,(cAliasSF3)->F3_LOJA)
			Aadd(aValNFe,(cAliasSF3)->F3_ESPECIE)
			Aadd(aValNFe,(cAliasSF3)->F3_FORMUL)
			If !ExecBlock("FISVALNFE",.F.,.F.,aValNFe)
				dbSelectArea(cAliasSF3)
				dbSkip()
				Loop
			EndIf
		EndIf
	
		dbSelectArea(cAliasSF3)
		If (SubStr((cAliasSF3)->F3_CFO,1,1)>="5" .Or. (cAliasSF3)->F3_FORMUL=="S") .And. aScan(aNotas,{|x| x[3]+x[4]==(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_NFISCAL})==0 .And. ;
				( Val( (cAliasSF3)->F3_NFISCAL ) >= Val( cNotaIni ) .And. Val ( (cAliasSF3)->F3_NFISCAL ) <= Val( cNotaFim ) )
		
			If (!lCTe) .And. !lAuto
				IncProc("(1/2) "+"Preparando nota: "+(cAliasSF3)->F3_NFISCAL) //
			EndIf
		
			If (AModNot((cAliasSF3)->F3_ESPECIE)$"55,57" .Or. cAmbiente=="2") .And. Empty((cAliasSF3)->F3_DTCANC);
					.And. &cWhere
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³No caso de Nota Fiscal sobre cupom (SIGALOJA)³
			//³busca os dados do registro original.         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( cNfCup $ (cAliasSF3)->F3_OBSERV .or. ( cFsimpFat $ (cAliasSF3)->F3_OBSERV ) ) .AND. !LjAnalisaLeg(53)[1]
					LjVerNfCup(@aNotas		,cAliasSF3,@aNfCup,.T.,;
						aMotivoCont	)
				//Grava doc Original da Transmissão da NF-e
					aadd(aNotasOri,{})
					nX := Len(aNotasOri)
				
					aadd(aNotasOri[nX],(cAliasSF3)->F3_NFISCAL)
					aadd(aNotasOri[nX],(cAliasSF3)->F3_SERIE)
				Else
					aadd(aNotas,{})
					nX := Len(aNotas)
					aadd(aNotas[nX],IIF((cAliasSF3)->F3_CFO<"5","0","1"))
					aadd(aNotas[nX],(cAliasSF3)->F3_ENTRADA)
					aadd(aNotas[nX],(cAliasSF3)->F3_SERIE)
					aadd(aNotas[nX],(cAliasSF3)->F3_NFISCAL)
					aadd(aNotas[nX],(cAliasSF3)->F3_CLIEFOR)
					aadd(aNotas[nX],(cAliasSF3)->F3_LOJA)
					aadd(aNotas[nX],aMotivoCont)
					If !lAuto
						aadd(aNotasOri,{})
						nX := Len(aNotasOri)
						aadd(aNotasOri[nX],(cAliasSF3)->F3_NFISCAL)
						aadd(aNotasOri[nX],(cAliasSF3)->F3_SERIE)
					EndIf
				EndIf
			EndIf
		EndIf
		dbSelectArea(cAliasSF3)
		dbSkip()
	EndDo
	If lQuery
		dbSelectArea(cAliasSF3)
		dbCloseArea()
		dbSelectArea("SF3")
	EndIf
	If (!lCTe) .And. !lAuto
		ProcRegua(Len(aNotas))
	EndIf

	If lAuto
		NfeVldAuto(@aNotas,cAlias)
	EndIf

	oWs:= WsNFeSBra():New()
	oWs:cUserToken := "TOTVS"
	oWs:cID_ENT    := cIdEnt
	oWS:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"
	oWs:oWsNFe:oWSNOTAS :=  NFeSBRA_ARRAYOFNFeS():New()
	For nX := 1 To Len(aNotas)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso seja SCAN, e a Serie da NFe for menor que 900-999 nao eh transmitida NFe ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lTermScan
			If (!lCTe) .And. !lAuto
				IncProc("(2/2) "+"Transmitindo XML da nota: "+aNotas[nX][4]) //
			EndIf
		
		//-- Parametro do
			If lTMSCTe .And. lCTe
				aXml	:= ExecBlock("XmlCteSef",.F.,.F.,{aNotas[nX], cAmbiente, cVersao, cModalidade})
			Else
				If (Empty (aNfCup))
					nTemp := aScan( aNotasOri, { | x | x[1] == aNotas[nX][4] .and. x[2] == aNotas[nX][3] } )
				Else
					nTemp := nX
				EndIf
				if nTemp < 1
					loop
				endif
				If !lAuto
					aXml	:= ExecBlock("XmlNFeSef",.F.,.F.,{aNotas[nX],cVersao,cAmbiente,aNotasOri[nTemp]})
				Else
					aXml	:= ExecBlock("XmlNFeSef",.F.,.F.,{aNotas[nX],cVersao,cAmbiente,{"",""}})
				EndIf
			EndIf
		
			nXmlSize2 := Len(aXML[2])
		
			nPosAux := Ascan( aNfCup,{|x| x[7] == aNotas[nX][3] .AND. x[8] == aNotas[nX][4]})
		
			If nPosAux > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Caso encontre alguma Nf sobre cupom volta a numeração³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				LjVerNfCup(@aNotas[nX], NIL , aNfCup[nPosAux] , .F. )
			EndIf
		
			If  Len(aXML)==4 .And.!Empty (aXML[3]) .And. !Empty (aXML[4])
				aNotas[nX][4]:= aXML[3]
				aNotas[nX][3]:= aXML[4]
			EndIF
		
			If !Empty(aXML[2]) .And. nXmlSize2 <= TAMMAXXML
				If nXmlSize + Len(aXML[2]) <= TAMMAXXML
					nY++
					nNFes++
					nXmlSize += Len(aXML[2])
					aadd(oWs:oWsNFe:oWSNOTAS:oWSNFeS,NFeSBRA_NFeS():New())
				
					aadd(aRetNotas,aNotas[nX])
				
					oWs:oWsNFe:oWSNOTAS:oWsNFes[nY]:cID := aNotas[nX][3]+aNotas[nX][4]
					oWs:oWsNFe:oWSNOTAS:oWsNFes[nY]:cXML:= aXML[2]
				Else
					lRetorno := XMLRemessa(@oWs,@cErro,@aRetNotas,@nY,@nXmlSize,cIdEnt,cURL,lAuto)
					If !lRetorno
						Exit
					EndIf
					nX -- //- Diminui o contador para que seja pego a nota corrente
					Loop
				EndIF
			ElseIf !Empty(aXML[2]) .And. nXmlSize2 > TAMMAXXML
				If !lAuto
					Aviso("SPED"," "+CRLF+CRLF+" " +aNotas[nX][4]+" / "+aNotas[nX][3],{"OK"},3)
				Else
					Conout("SPED"," "+CRLF+CRLF+" "+aNotas[nX][4]+" / "+aNotas[nX][3],{"OK"},3)
				EndIf
				nXmlSize2 := 0
			EndIf
			If ((nY >=50 .Or. nX == Len(aNotas) .Or. nXmlSize>=TAMMAXXML) .And. nNFes > 0)
				XMLRemessa(@oWs,@cErro,@aRetNotas,@nY,@nXmlSize,cIdEnt,cURL,lAuto)
			EndIf
		EndIf
	Next nX
	If lRetorno
		cRetorno := "Você concluíu com sucesso a transmissão do Protheus para o Totvs Services SPED."+CRLF //
		cRetorno += "Verifique se as notas foram autorizadas na SEFAZ, utilizando a rotina 'Monitor'. Antes de imprimir a DANFe."+CRLF+CRLF //
		cRetorno += "Foram transmitidas "+AllTrim(Str(nNFes,18))+" nota(s) em "+IntToHora(SubtHoras(dDataIni,cHoraIni,Date(),Time()))+CRLF+CRLF //###
		cRetorno += cErro
	Else
		cRetorno := "Houve erro durante a transmissão para o Totvs Services SPED."+CRLF+CRLF //
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Contingencia SCAN - Exibe mensagem que nao foi transmitida NFe  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cModalidade = "3"
			cErro   := ": "+ "Série utilizada fora da faixa permitida no Ambiente SCAN (900-999)"
			cRetorno += cErro+CRLF+CRLF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Exibicao do range de NFe nao transmitidas						³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nX := 1 To Len(aNotas)
			
				cRetorno += "Segue abaixo a NF-e não transmitida: "  +CRLF
				cRetorno += "Serie" + ": " + aNotas[nX][3] 			+CRLF 		//
				cRetorno += "NF" + ": " + aNotas[nX][4] 			+CRLF+CRLF //
			
			Next nX
		Else
			cRetorno += cErro
		EndIf
	
	
	EndIf

	RestArea(aArea)

Return(cRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³XMLRemessa³ Autor ³ Gustavo. G. Rueda     ³ Data ³24.03.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao responsavel pela envio do XML ao TSS                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function XMLRemessa(oWs,cErro,aRetNotas,nTotNf,nXmlSize,cIdEnt,cURL,lAuto)
	Local nY
	Local lRetorno	:= .T.

	Default lAuto	:= .F.

	If nXmlSize>0 .And. oWs:Remessa()
		If Len(oWs:oWsRemessaResult:oWSID:cString) <> nTotNF
			cErro := "As notas abaixo foram recusadas, verifique a rotina 'Monitor' para saber os motivos."+CRLF+CRLF //
		EndIf
		For nY := 1 To Len(aRetNotas)
			If lAuto
				gravaCodRet( aRetNotas[nY] )
			Endif
			If Len(oWs:oWsRemessaResult:oWSID:cString) <> nY
				If aScan(oWs:oWsRemessaResult:oWSID:cString,aRetNotas[nY][3]+aRetNotas[nY][4])==0
					cErro += "NFe: "+aRetNotas[nY][3]+aRetNotas[nY][4]+CRLF
				EndIf
			EndIf
			If aRetNotas[nY][1] == "0"
				If SF1->(FieldPos("F1_FIMP"))>0
					dbSelectArea("SF1")
					dbSetOrder(1)
					If MsSeek(xFilial("SF1")+aRetNotas[nY][4]+aRetNotas[nY][3]+aRetNotas[nY][5]+aRetNotas[nY][6]) .And. SF1->F1_FIMP$"N, "
						RecLock("SF1")
						SF1->F1_FIMP := IIF(aScan(oWs:oWsRemessaResult:oWSID:cString,aRetNotas[nY][3]+AllTrim(aRetNotas[nY][4]))==0,"N","T")
						MsUnlock()
					EndIf
				EndIf
			Else
				dbSelectArea("SF2")
				dbSetOrder(1)
				If MsSeek(xFilial("SF2")+aRetNotas[nY][4]+aRetNotas[nY][3]+aRetNotas[nY][5]+aRetNotas[nY][6]) .And. SF2->F2_FIMP$"N, "
					RecLock("SF2")
					SF2->F2_FIMP := IIF(aScan(oWs:oWsRemessaResult:oWSID:cString,aRetNotas[nY][3]+AllTrim(aRetNotas[nY][4]))==0,"N","T")
					MsUnlock()
				EndIf
			EndIf
		Next nY
	
		If ExistBlock("FISENVNFE")
			ExecBlock("FISENVNFE",.F.,.F.,{oWs:oWsRemessaResult:oWSID:cString})
		EndIf
	
		oWs:= WsNFeSBra():New()
		oWs:cUserToken := "TOTVS"
		oWs:cID_ENT    := cIdEnt
		oWS:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"
		oWs:oWsNFe:oWSNOTAS :=  NFeSBRA_ARRAYOFNFeS():New()
		nTotNF := 0
		nXmlSize := 0
		aRetNotas := {}
	Else
		cErro := GetWscError(3)
		DEFAULT cErro := "Erro indeterminado"
		lRetorno := .F.
	EndIf
Return lRetorno


//--------------------------------------------------------------------------------------------
/*/{Protheus.doc} retQueryTrans
Retorna a string da query para transmissao dos documentos.

@author Sergio S. Fuzinaka
@since 06/02/2014
@version 12

@param	lAutoNFe		- Novo Auto NF-e
@param	cModelo			- Modelo do documento:	55 - NF-e
												57 - CT-e

@return cQuery			- String da query

/*/
//--------------------------------------------------------------------------------------------
Static Function retQueryTrans( lAutoNFe, cNotaIni, cNotaFim, cSerie, cModelo )

	Local cQuery		:= ""
	Local cEspecie		:= ""

	Default lAutoNFe	:= .F.
	Default cModelo		:= "55"

//-- Montagem da query
	cQuery := "SELECT F3_FILIAL, F3_ENTRADA, F3_NFeLETR, F3_CFO, F3_FORMUL, F3_NFISCAL, F3_SERIE, F3_CLIEFOR, "
	cQuery += "F3_LOJA, F3_ESPECIE, F3_DTCANC, F3_OBSERV, F3_CHVNFE, F3_CODNFE "
	cQuery += "FROM " + RetSqlName("SF3") + " "
	cQuery += "WHERE F3_FILIAL = '" + xFilial("SF3") + "' AND "
	cQuery += "((SUBSTRING(F3_CFO,1,1) < '5' AND F3_FORMUL = 'S') OR (SUBSTRING(F3_CFO,1,1) >= '5')) AND "
	cQuery += "F3_SERIE = '" + cSerie + "' AND "

	If lAutoNFe

		If cModelo == "55"
			cEspecie := "SPED"
		Else
			cEspecie := "CTE"
		Endif

		cQuery += "F3_ESPECIE = '" + cEspecie + "' AND "
	
		If SF3->(FieldPos("F3_CODRET")) > 0
			cQuery += "F3_CODRET = '' AND "
		Endif
	
		If SF3->(FieldPos("F3_CODRSEF")) > 0
			cQuery += "F3_CODRSEF = '' AND "
		Endif

		cQuery += "F3_DTCANC = '" + Space(8) + "' AND "
		cQuery += "D_E_L_E_T_ = '' "
	
		cQuery += "ORDER BY F3_NFISCAL"

	Else

		cQuery += "F3_NFISCAL >= '" + cNotaIni + "' AND "
		cQuery += "F3_NFISCAL <= '" + cNotaFim + "' AND "
		cQuery += "F3_DTCANC = '" + Space(8) + "' AND "
		cQuery += "D_E_L_E_T_ = ''"

	Endif

return( cQuery )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³SpedNFeRe2³ Autor ³Eduardo Riera          ³ Data ³21.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de remessa da Nota fiscal eletronica para o Totvs    ³±±
±±³          ³Service SPED - utilizada em personalizacoes                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Serie da NF                                          ³±±
±±³          ³ExpC2: Nota inicial                                         ³±±
±±³          ³ExpC3: Nota final                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SpedNFeRe2(cSerie,cNotaIni,cNotaFim,lCTe,lRetorno)

	Local aArea       := GetArea()
	Local aPerg       := {}
	Local aParam      := {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC))}
	Local aTexto      := {}
	Local aXML        := {}

	Local cRetorno    := ""
	Local cIdEnt      := ""
	Local cModalidade := ""
	Local cAmbiente   := ""
	Local cVersao     := ""
	Local cVersaoCTe  := ""
	Local cVersaoDpec := ""
	Local cMonitorSEF := ""
	Local cSugestao   := ""
	Local cURL        := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cUsaColab	  := GetNewPar("MV_SPEDCOL","N")
	Local cUSERNEOG	  := GetNewPar("MV_USERCOL","")
	Local cPASSWORD	  := GetNewPar("MV_PASSCOL","")
	Local cCONFALL	  := GetNewPar("MV_CONFALL","N")
	Local cDocsColab  := GetNewPar("MV_DOCSCOL","0")
	Local cParNfeRem  := SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEREM"
	Local cConteudo   := ""


	Local nRetCol	  := GetNewPar("MV_NRETCOL",10)
	Local nAmbCTeC	  := GetNewPar("MV_AMBICOL",2)
	Local nAmbNFeC	  := GetNewPar("MV_AMBCTEC",2)
	Local nX          := 0

	Local lOk         := .T.

	Local oWizard
	Local cModel      := "55"

	Local lNfeCancEven:= GetNewPar("MV_NFECAEV",.F.)	//-- Cancelamento de NF-e por Evento

	Private oWS       := Nil

	Default lCTe      := .F.
	Default lRetorno  := .F.
	If lCTE
		cModel:= "57"
	EndIf

	If cSerie == Nil
		MV_PAR01 := aParam[01] := PadR(ParamLoad(cParNfeRem,aPerg,1,aParam[01]),Len(SF2->F2_SERIE))
		MV_PAR02 := aParam[02] := PadR(ParamLoad(cParNfeRem,aPerg,2,aParam[02]),Len(SF2->F2_DOC))
		MV_PAR03 := aParam[03] := PadR(ParamLoad(cParNfeRem,aPerg,3,aParam[03]),Len(SF2->F2_DOC))
	Else
		MV_PAR01 := aParam[01] := cSerie
		MV_PAR02 := aParam[02] := cNotaIni
		MV_PAR03 := aParam[03] := cNotaFim
	EndIf

	aadd(aPerg,{1,"Serie da Nota Fiscal",aParam[01],"",".T.","",".T.",30,.F.})	//
	aadd(aPerg,{1,"Nota fiscal inicial",aParam[02],"",".T.","",".T.",30,.T.})	//
	aadd(aPerg,{1,"Nota fiscal final",aParam[03],"",".T.","",".T.",30,.T.})	//

	If IsReady()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Obtem o codigo da entidade                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cIdEnt := GetIdEnt()
	
		If !Empty(cIdEnt)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Obtem o ambiente de execucao do Totvs Services SPED                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oWS := WsSpedCfgNFe():New()
			oWS:cUSERTOKEN := "TOTVS"
			oWS:cID_ENT    := cIdEnt
			oWS:nAmbiente  := 0
			oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
			lOk := oWS:CFGAMBIENTE()
			cAmbiente := oWS:cCfgAmbienteResult
			If lOk
				lOk := oWs:CfgTSSVersao()
			EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Obtem a modalidade de comunicacao com a SEFAZ TSS ou TOTVS Colaboracao  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lOk .And. oWs:cCfgTssVersaoResult >= "1.35"
				oWS:cUSERTOKEN := "TOTVS"
				oWS:cID_ENT    := cIdEnt
				oWS:cUSACOLAB  := cUsaColab
				oWS:nNUMRETNF  := nRetCol
				oWS:nAMBIENTE  := 0
				oWS:nMODALIDADE:= 0
				oWS:cVERSAONFE := ""
				oWS:cVERSAONSE := ""
				oWS:cVERSAODPEC:= ""
				oWS:cVERSAOCTE := ""
				oWS:cUSERNEOG  := cUSERNEOG
				oWS:cPASSWORD  := cPASSWORD
				oWS:cCONFALL   := cCONFALL
				IF oWs:cCfgTssVersaoResult >= "1.43"
					If "1" $ Upper(cDocsColab)
						cConteudo += "1"
					EndiF
					If "2" $ Upper(cDocsColab)
						cConteudo += "2"
					EndIF
					If "3" $ Upper(cDocsColab)
						cConteudo += "3"
					EndIF
					If "4" $ Upper(cDocsColab)
						cConteudo := "4"
					EndIF
					If "0" $ Upper(cDocsColab)
						cConteudo := "0"
					EndIF
				//-- Cancelamento por Evento
					If oWs:cCfgTssVersaoResult >= "2.15"
						oWS:lNFeCancEvento := lNFeCancEven
					Endif
					oWS:cDOCSCOL	:= cConteudo
					oWS:nAMBNFECOLAB:= IIF(nAmbNFeC >= 1 .And. nAmbNFeC <=2,nAmbNFeC,2)
					oWS:nAMBCTECOLAB:= IIF(nAmbCTeC >= 1 .And. nAmbCTeC <=2,nAmbCTeC,2)
				EndIF
				oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
				oWS:CFGPARAMSPED()
			EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Obtem a modalidade de execucao do Totvs Services SPED                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lOk
				oWS:cUSERTOKEN := "TOTVS"
				oWS:cID_ENT    := cIdEnt
				oWS:nModalidade:= 0
				oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
				oWS:cModelo   := cModel
				lOk := oWS:CFGModalidade()
				cModalidade    := oWS:cCfgModalidadeResult
			EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Obtem a versao de trabalho da NFe do Totvs Services SPED                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lOk
				oWS:cUSERTOKEN := "TOTVS"
				oWS:cID_ENT    := cIdEnt
				oWS:cVersao    := "0.00"
				oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
				lOk := oWS:CFGVersao()
				cVersao        := oWS:cCfgVersaoResult
			EndIf
			If lOk
				oWS:cUSERTOKEN := "TOTVS"
				oWS:cID_ENT    := cIdEnt
				oWS:cVersao    := "0.00"
				oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
				lOk := oWS:CFGVersaoCTe()
				cVersaoCTe     := oWS:cCfgVersaoCTeResult
			EndIf
			If lOk
				oWS:cUSERTOKEN := "TOTVS"
				oWS:cID_ENT    := cIdEnt
				oWS:cVersao    := "0.00"
				oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
				lOk := oWS:CFGVersaoDpec()
				cVersaoDpec	   := oWS:cCfgVersaoDpecResult
			EndIf
			If lOk
				oWs:CfgTSSVersao()
				If oWs:cCfgTssVersaoResult >= "2.27A" .and. cModel == "57"
					oWS:cUSERTOKEN 		 	:= "TOTVS"
					oWS:cID_ENT    		 	:= cIdEnt
					oWS:_URL       		 	:= AllTrim(cURL)+"/SPEDCFGNFe.apw"
					oWS:cVERSAOGERALEPEC		:="2.00"
					oWS:cVERSAOEVENEPEC		:="2.00"
					oWS:cVERSAOGERALCANC		:="2.00"
					oWS:cVERSAOEVENCANC		:="2.00"
					oWS:cVERSAOGERALCCE		:="2.00"
					oWS:cVERSAOEVENCCE		:="2.00"
					oWS:cVERSAOGERALMULT		:=""
					oWS:cVERSAOEVENMULT		:=""
					oWS:nSEQLOTEEPEC			:=0
					If cVersaoCTe == "2.00"
						oWS:lCTECANCEVENTO		:= .T.
					Else
						oWS:lCTECANCEVENTO		:= .F.
					EndIf
					oWS:CFGEpecCte()
				EndIf
			EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica o status na SEFAZ                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lOk
				oWS:= WSNFeSBRA():New()
				oWS:cUSERTOKEN := "TOTVS"
				oWS:cID_ENT    := cIdEnt
				oWS:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"
				lOk := oWS:MONITORSEFAZMODELO()
				If lOk
					aXML := oWS:oWsMonitorSefazModeloResult:OWSMONITORSTATUSSEFAZMODELO
					For nX := 1 To Len(aXML)
					// NFC-e tem um metodo de remessa especifico REMESSA3
						If aXML[nX]:cModelo == "65"		//NFC-e
							Loop
						Endif
						Do Case
						Case aXML[nX]:cModelo == "55"
							cMonitorSEF += "- NFe"+CRLF
							cMonitorSEF += "Versao do layout: "+cVersao+CRLF	//
							If !Empty(aXML[nX]:cSugestao)
								cSugestao += "Sugestão"+"(NFe)"+": "+aXML[nX]:cSugestao+CRLF //
							EndIf
							
						Case aXML[nX]:cModelo == "57"
							cMonitorSEF += "- CTe"+CRLF
							cMonitorSEF += "Versao do layout: "+cVersaoCTe+CRLF	//
							If !Empty(aXML[nX]:cSugestao)
								cSugestao += "Sugestão"+"(CTe)"+": "+aXML[nX]:cSugestao+CRLF //
							EndIf
						EndCase
						cMonitorSEF += Space(6)+"Versão da mensagem"+": "+aXML[nX]:cVersaoMensagem+CRLF //
						cMonitorSEF += Space(6)+"Código do Status"+": "+aXML[nX]:cStatusCodigo+"-"+aXML[nX]:cStatusMensagem+CRLF //
						cMonitorSEF += Space(6)+"UF Origem"+": "+aXML[nX]:cUFOrigem //
						If !Empty(aXML[nX]:cUFResposta)
							cMonitorSEF += "("+aXML[nX]:cUFResposta+")"+CRLF //"UF Resposta"
						Else
							cMonitorSEF += CRLF
						EndIf
						If aXML[nX]:nTempoMedioSEF <> Nil
							cMonitorSEF += Space(6)+"Tempo de espera"+": "+Str(aXML[nX]:nTempoMedioSEF,6)+CRLF //
						EndIf
						If !Empty(aXML[nX]:cMotivo)
							cMonitorSEF += Space(6)+"Motivo"+": "+aXML[nX]:cMotivo+CRLF //
						EndIf
						If !Empty(aXML[nX]:cObservacao)
							cMonitorSEF += Space(6)+"Observação"+": "+aXML[nX]:cObservacao+CRLF //
						EndIf
					Next nX
				EndIf
			EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem da Interface                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ((lOk == .T. .or. lOk == Nil) .And. (!lCTe))
				aadd(aTexto,{})
				aTexto[1] := "Esta rotina tem como objetivo auxilia-lo na transmissão da Nota Fiscal eletrônica para o serviço Totvs Services SPED. "+" " //
				aTexto[1] += "Neste momento o Totvs Services SPED, está operando com a seguinte configuração: " +CRLF+CRLF //
				aTexto[1] += "Ambiente: "+cAmbiente+CRLF //
				aTexto[1] += "Modalidade de emissão: "+cModalidade+CRLF	//
				If !Empty(cSugestao)
					aTexto[1] += CRLF
					aTexto[1] += cSugestao
					aTexto[1] += CRLF
				EndIf
				aTexto[1] += cMonitorSEF
			
				aadd(aTexto,{})
		
				DEFINE WIZARD oWizard ;
					TITLE "Assistente de transmissão da Nota Fiscal Eletrônica";
					HEADER " ";
					MESSAGE " ";
					TEXT aTexto[1] ;
					NEXT {|| .T.} ;
					FINISH {||.T.}
		
				CREATE PANEL oWizard  ;
					HEADER "Assistente de transmissão da Nota Fiscal Eletrônica" ;//
				MESSAGE ""	;
					BACK {|| .T.} ;
					NEXT {|| ParamSave(cParNfeRem,aPerg,"1"),Processa({|lEnd| cRetorno := SpedNFeTrf(aArea[1],aParam[1],aParam[2],aParam[3],cIdEnt,cAmbiente,cModalidade,cVersao,@lEnd)}),aTexto[02]:= cRetorno,.T.} ;
					PANEL
				ParamBox(aPerg,"SPED - NFe",@aParam,,,,,,oWizard:oMPanel[2],cParNfeRem,.T.,.T.)
		
				CREATE PANEL oWizard  ;
					HEADER "Assistente de configuração da Nota Fiscal Eletrônica";//
				MESSAGE "";
					BACK {|| .T.} ;
					FINISH {|| .T.} ;
					PANEL
				@ 010,010 GET aTexto[2] MEMO SIZE 270, 115 READONLY PIXEL OF oWizard:oMPanel[3]
				ACTIVATE WIZARD oWizard CENTERED
			ElseIf (lCTe) .And. (lOk)
				SpedNFeTrf(aArea[1],aParam[1],aParam[2],aParam[3],cIdEnt,cAmbiente,cModalidade,cVersaoCTe,.T., lCTe)
			EndIf
			lRetorno := lOk
		Else
			lRetorno := .F.
		EndIf
	Else
		If (!lCTe)
			Aviso("SPED","Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!",{"OK"},3) //
		Else
			lRetorno := .F.
		EndIf
	EndIf

	RestArea(aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³IsReady   ³ Autor ³Eduardo Riera          ³ Data ³18.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se a conexao com a Totvs Sped Services pode ser    ³±±
±±³          ³estabelecida                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: URL do Totvs Services SPED                        OPC³±±
±±³          ³ExpN2: nTipo - 1 = Conexao ; 2 = Certificado             OPC³±±
±±³          ³ExpL3: Exibe help                                        OPC³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IsReady(cURL,nTipo,lHelp)

	Local nX       := 0
	Local cHelp    := ""
	Local oWS
	Local lRetorno := .F.
	DEFAULT nTipo := 1
	DEFAULT lHelp := .F.
	If !Empty(cURL) .And. !PutMV("MV_SPEDURL",cURL)
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial( "SX6" )
		SX6->X6_VAR     := "MV_SPEDURL"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "URL SPED NFe"
		MsUnLock()
		PutMV("MV_SPEDURL",cURL)
	EndIf
	SuperGetMv() //Limpa o cache de parametros - nao retirar
	DEFAULT cURL      := PadR(GetNewPar("MV_SPEDURL","http://"),250)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o servidor da Totvs esta no ar                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oWs := WsSpedCfgNFe():New()
	oWs:cUserToken := "TOTVS"
	oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"
	If oWs:CFGCONNECT()
		lRetorno := .T.
	Else
		If lHelp
			Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
		EndIf
		lRetorno := .F.
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o certificado digital ja foi transferido                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTipo <> 1 .And. lRetorno
		oWs:cUserToken := "TOTVS"
		oWs:cID_ENT    := GetIdEnt()
		oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"
		If oWs:CFGReady()
			lRetorno := .T.
		Else
			If nTipo == 3
				cHelp := IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
				If lHelp .And. !"003" $ cHelp
					Aviso("SPED",cHelp,{"OK"},3)
					lRetorno := .F.
				EndIf
			Else
				lRetorno := .F.
			EndIf
		EndIf
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o certificado digital ja foi transferido                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTipo == 2 .And. lRetorno
		oWs:cUserToken := "TOTVS"
		oWs:cID_ENT    := GetIdEnt()
		oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"
		If oWs:CFGStatusCertificate()
			If Len(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE) > 0
				For nX := 1 To Len(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE)
					If oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE[nx]:DVALIDTO-30 <= Date()
				
						Aviso("SPED","O certificado digital irá vencer em: "+Dtoc(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE[nX]:DVALIDTO),{"Voltar"},3) //
				
					EndIf
				Next nX
			EndIf
		EndIf
	EndIf

Return(lRetorno)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³SelAtivo  ³ Autor ³Carlos R Moreira       ³ Data ³18.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se a conexao com a Totvs Sped Services pode ser    ³±±
±±³          ³estabelecida                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function SelAtivo()
	Local aCampos := {}
	Local cCusto  := cCCOri
	
	cCusto := BuscaCC(cCCOri)
	
	AaDd(aCampos,{"OK"       ,"C",   2,0})
	AaDd(aCampos,{"PROD"     ,"C",  10,0})
	AaDd(aCampos,{"DESC"     ,"C",  60,0})
	AaDd(aCampos,{"CHAPA"    ,"C",   7,0})
	AaDd(aCampos,{"QTDE"     ,"N",  11,0})
	AaDd(aCampos,{"VALOR"     ,"N",  14,2})
	AaDd(aCampos,{"GRUPO"    ,"C",   4,0})
	AaDd(aCampos,{"ITEM"     ,"C",   4,0})


	cArqTmp := CriaTrab(aCampos,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria o arquo de Trabalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DbUseArea(.T.,,cArqTmp,"ATV",.F.,.F.)
	IndRegua("ATV",cArqTmp,"DESC+CHAPA",,,"Selecionando Registros..." )

	cGruAtv := TRB->GRUPO
	
	cCusto := BusCusto(cCusto)
	BeginSql Alias "QRYATV"

		SELECT     SN1.N1_CBASE, SN1.N1_ITEM, SN1.N1_DESCRIC, SN1.N1_QUANTD, SN1.N1_CHAPA, SN1.N1_GRUPO,
		SN3.N3_SUBCTA, SN3.N3_CCUSTO, SN3.N3_VORIG1
		FROM         %Table:SN1% SN1 JOIN
		%Table:SN3% SN3  ON SN1.N1_CBASE = SN3.N3_CBASE AND SN1.N1_ITEM = SN3.N3_ITEM
		AND SN3.%notdel% AND SN3.N3_SUBCTA = %Exp:cCusto%
		WHERE SN1.%notdel% AND SN1.N1_GRUPO = %Exp:cGruAtv%

	EndSql


	DbSelectArea("QRYATV")
	DbGoTop()

	While QRYATV->(!Eof())

		DbSelectArea("ATV")
		RecLock("ATV",.T.)
		ATV->PROD  := QRYATV->N1_CBASE
		ATV->DESC  := QRYATV->N1_DESCRIC
		ATV->CHAPA := QRYATV->N1_CHAPA
		ATV->QTDE  := QRYATV->N1_QUANTD
		ATV->VALOR := QRYATV->N3_VORIG1
		ATV->ITEM  := QRYATV->N1_ITEM
   
		MsUnlock()

		DbSelectArea("QRYATV")
		DbSkip()
   
	End

	aBrowse2 := {}
	AaDD(aBrowse2,{"OK","",""})
	AaDD(aBrowse2,{"PROD","","Produto"})
	AaDD(aBrowse2,{"DESC","","Descricao"})
	AaDD(aBrowse2,{"CHAPA","","Chapa"})
	AaDD(aBrowse2,{"QTDE","","Quantidade","@E 999,999" })
	AaDD(aBrowse2,{"VALOR","","Valor","@E 999,999" })

	DbSelectArea("ATV")
	ATV->(DbGoTop())

	If ATV->(Eof())
		MsgAlert("Nao existe produtos disponivel para a operacao.")
   QRYATV->(DbCloseArea())
		ATV->(DbCloseArea())
		Return .F.
	EndIf

	nOpca    :=0
	lInverte := .F.
	cMarca   := GetMark()
	cTit     := "Selecao de Ativo"
	DEFINE MSDIALOG oDlg1   TITLE cTit From 9,0 To 25,100 OF oMainWnd

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Passagem do parametro aCampos para emular tamb‚m a markbrowse para o ³
//³ arquivo de trabalho "TRB".                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oMark := MsSelect():New("ATV","OK","",aBrowse2,@lInverte,@cMarca,{15,3,118,395})

	oMark:bMark := {| | fa060d(cMarca,lInverte)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inv(cMarca,1) }

	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||oDlg1:End()},1) centered

	If nOpca == 1
	
		aCols := {}
	
		DbSelectArea("ATV")
		DbGoTop()
	
		While ATV->(!Eof())
		
			If Empty(ATV->OK)
				DbSkip()
				Loop
			EndIf
		
			AADD(aCOLS,{TRB->PROD,ATV->DESC,ATV->QTDE,"",ATV->PROD,ATV->ITEM,.F.})
		
			DbSelectArea("TRB")
			Reclock("TRB",.F.)
			TRB->UPRC  := ATV->VALOR
			TRB->CBASE := ATV->PROD
			TRB->ITEM  := ATV->ITEM
			MsUnLock()
		
			DbSelectArea("ATV")
			DbSkip()
		
		End
	
	EndIf

	QRYATV->(DbCloseArea())
	ATV->(DbCloseArea())

	DlgRefresh(oDlg)

Return
 
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FA060Disp ³ Autor ³ Carlos R. Moreira     ³ Data ³ 09/05/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exibe Valores na tela									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Especifico                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa060D(cMarca,lInverte)
	Local aTempos, cClearing, oCBXCLEAR, oDlgClear,lCOnf
	If IsMark("OK",cMarca,lInverte)
	
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fa060Inve ºAutor  ³Carlos R. Moreira   º Data ³  19/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³inverte a Selecao dos Itens                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa060Inv(cMarca)
	Local nReg := ATV->(Recno())
	Local cAlias := Alias()

	dbSelectArea("ATV")
	dbGoTop()
	While !Eof()
		RecLock("ATV")
		ATV->OK := IIF(ATV->OK == "  ",cMarca,"  ")
		MsUnlock()
		dbSkip()
	Enddo
	ATV->(dbGoto(nReg))
	oMark:oBrowse2:Refresh(.t.)
Return Nil

/*
//---------------------------------------------------------------------------
BuscaCC ºAutor  ³André Brito   º Data ³ 27/03/2020   
Busca centro de custo a partir do Item Contabil                
//---------------------------------------------------------------------------
*/

Static Function BuscaCC(cItem)

Local aArea     := GetArea()
Local cCusto    := ""

Default cItem   := ""

DbSelectArea("CTD")
DbSetOrder(1)

If DbSeek(xFilial("CTD") + cItem)
	cCusto      :=  CTD->CTD_CUSTO
EndIf

RestArea( aArea )

Return cCusto

/*
//---------------------------------------------------------------------------
VldPlaca ºAutor  ³André Brito   º Data ³ 15/04/2020   
Busca centro de custo a partir do Item Contabil                
//---------------------------------------------------------------------------
*/

Static Function VldPlaca(cPlaca)

Local aArea      := GetArea()
Local lRet       := .F.

Default cPlaca   := ""

DbSelectArea("DA3")
DbSetOrder(3)

If DbSeek(xFilial("DA3") + cPlaca)
	lRet := .T.
ElseIf Empty(cPlaca)
	lRet := .T.
Else
	MsgStop("Nao existe veículo com essa placa. Favor Verificar")
	lRet := .F.
EndIf

RestArea( aArea )

Return lRet


/*
//---------------------------------------------------------------------------
BusCusto ºAutor  ³André Brito   º Data ³ 15/04/2020   
Busca centro de custo a partir do Item Contabil                
//---------------------------------------------------------------------------
*/
Static Function BusCusto(cItem)

Local aArea     := GetArea()
Local cCusto    := ""
	
DbSelectArea("CTD")
DbSetOrder(1)

If DbSeek(xFilial("CTD") + cItem )
	cCusto      :=  CTD->CTD_CUSTO
EndIf

RestArea( aArea )

Return cCusto
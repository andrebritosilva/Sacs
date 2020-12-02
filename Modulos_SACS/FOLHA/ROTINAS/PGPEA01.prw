#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPGPEA01   บ Autor ณ Carlos R Moreira	 บ Data ณ  22/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ira gerar a Verba de desconto de Multa de Transito         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PGPEA01()

Local aSays     := {}
Local aButtons  := {}
Local nOpca     := 0

Private  cCadastro := OemToAnsi("Gera a Verba de Desconto de Multa de Transito")
Private  cArqTxt

Private aRotina := {{"Pesquisar" ,"AxPesqui",0,1} ,;
		             {"Visualizar","AxVisual",0,2} } 

Aadd(aSays, OemToAnsi(" Este programa ira ler o conteudo de um arquivo, e       "))
Aadd(aSays, OemToAnsi(" gerar o desconto na folha da respectiva multa para o    "))
Aadd(aSays, OemToAnsi(" devido funcionario.    "))

Aadd(aButtons, { 1, .T., { || nOpca := 1, FechaBatch()  }})
Aadd(aButtons, { 2, .T., { || FechaBatch() }})
//Aadd(aButtons, { 5, .T., { || Pergunte(cPerg,.T.) }})

FormBatch(cCadastro, aSays, aButtons)

If nOpca == 1
	
	Processa( { || ProcMulTra() }, "Processando Arquivo  . .")  //
	
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO5     บAutor  ณMicrosiga           บ Data ณ  12/22/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcMulTra()
Local oDlg
Local aCampos := {}
Local aSize     := MsAdvSize(.T.)
Local aObjects:={},aInfo:={},aPosObj:={}
Local aInfo   :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}
lOCAL oSCR1

Private oFont1  := TFont():New( "TIMES NEW ROMAN",12.5,18,,.T.,,,,,.F.)
Private oFont2  := TFont():New( "ARIAL",12.5,12,,.T.,,,,,.F.)
Private oFont3  := TFont():New( "ARIAL",10.5,10,,.T.,,,,,.F.)
Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)

//Array com os campos do Arquivo temporario
AADD(aCampos,{ "OK"      ,"C",02,0 } )
AADD(aCampos,{ "PEDIDO"  ,"C",06,0 } )
AADD(aCampos,{ "ITEM"    ,"C",04,0 } )
AADD(aCampos,{ "MAT"     ,"C",06,0 } )
AADD(aCampos,{ "NOME"    ,"C",25,0 } )
AADD(aCampos,{ "EMISSAO" ,"D", 8,0 } )
AADD(aCampos,{ "VALOR"   ,"N",11,2 } )
AADD(aCampos,{ "PARCELAS"   ,"N",2,0 } )
AADD(aCampos,{ "OBS"     ,"C",50,0 } ) 
AADD(aCampos,{ "DOC"     ,"C", 9,0 } )
AADD(aCampos,{ "SERIE"   ,"C", 3,0 } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria arquivo de trabalho                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cNomArq  := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq,"TRB", if(.T. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",cNomArq,"MAT",,,OemToAnsi("Selecionando Registros..."))	//

cQuery := "SELECT  SC7.C7_NUM, SC7.C7_ITEM, SC7.C7_MATFUNC, SRA.RA_NOME, SC7.C7_EMISSAO, SC7.C7_OBS, SC7.C7_TOTAL, SD1.D1_DOC, SD1.D1_SERIE "
cQuery += " FROM "+RetSqlName("SC7")+" SC7 "
cQuery += " INNER JOIN "+RetSqlName("SRA")+" SRA ON "
cQuery += " SRA.D_E_L_E_T_ <> '*' AND SRA.RA_MAT = SC7.C7_MATFUNC "

cQuery += " JOIN "+RetSqlName("SB1")+" SB1 ON "
cQuery += " SB1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = SC7.C7_PRODUTO AND SB1.B1_PRD_LOC = 'M' "

cQuery += " JOIN "+RetSqlName("SD1")+" SD1 ON "
cQuery += " SD1.D_E_L_E_T_ <> '*' AND SD1.D1_PEDIDO = SC7.C7_NUM AND SD1.D1_ITEMPC = SC7.C7_ITEM  "

cQuery += " WHERE SC7.D_E_L_E_T_ <> '*' AND SC7.C7_CONAPRO = 'L' AND SC7.C7_GERAFOL = ' ' "

TCSQLExec(cQuery)

MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")

TCSetField("QRY","C7_EMISSAO","D")

nTotReg := 0
QRY->(dbEval({||nTotREG++}))
QRY->(dbGoTop())

DbSelectArea("QRY")

ProcRegua(nTotReg)

While QRY->(!Eof())
	
	IncProc("Gerando as selecao de Pedido de Compras...")
	
	DbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->PEDIDO  := QRY->C7_NUM
	TRB->ITEM    := QRY->C7_ITEM
	TRB->MAT     := QRY->C7_MATFUNC
	TRB->NOME    := QRY->RA_NOME
	TRB->EMISSAO := QRY->C7_EMISSAO
	TRB->OBS     := QRY->C7_OBS
	TRB->VALOR   := QRY->C7_TOTAL 
	TRB->PARCELAS:= 1
	TRB->DOC     := QRY->D1_DOC
    TRB->SERIE   := QRY->D1_SERIE
	MsUnlock()
	
	DbSelectArea("QRY")
	DbSkip()
	
End

DbSelectArea("TRB")

cMarca  := GetMark()

aBrowse := {}
AaDD(aBrowse,{"OK","",""})
AaDD(aBrowse,{"PEDIDO","","Pedido"})
AaDD(aBrowse,{"ITEM","","Item"})
AaDD(aBrowse,{"MAT","","Funcionario"})
AaDD(aBrowse,{"NOME","","Nome"})
AaDD(aBrowse,{"EMISSAO","","Emissao"})
AaDD(aBrowse,{"DOC","","Documento"})
AaDD(aBrowse,{"VALOR","","Valor Multa","@E 99999999.99"})
AaDD(aBrowse,{"PARCELAS","","Parcelas","@E 99"})
AaDD(aBrowse,{"OBS","","Observacao"}) 

TRB->(DbGoTop())

AADD(aObjects,{ 80,015,.T.,.T.})

nOpca   :=0
lInverte := .F.

aPosObj:=MsObjSize(aInfo,aObjects)

While .T.
	
	DbSelectArea("TRB")
	
	DEFINE MSDIALOG oDlg1 TITLE "Selecionando as multas para desconto em folha" From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
	//ณ arquivo de trabalho "TRB".                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark := MsSelect():New("TRB","OK","",aBrowse,@lInverte,@cMarca,{aPosObj[1,1]+10,aPosObj[1,2]+10,aPosObj[1,3]-5,aPosObj[1,4]-10}) //,,,,,aCores)
	oMark:bMark := {|| U_DispBrow(cMarca,lInverte,"TRB",oMark)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || U_BrowInverte(cMarca,"TRB",oMark) }
	
	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||nOpca := 2,oDlg1:End()},.F.,1) centered
	
	If nOpca == 1
		
		lContinua := .F.
		
		DbSelectArea("TRB")
		DbGoTop()
		While TRB->(!Eof())
			
			If Empty(TRB->OK)
				DbSkip()
				Loop
			EndIf
			
			lContinua := .T.
			
			DbSkip()
			
		End
		
		If lContinua
			
			MsAguarde({||GeraDesc()},"Gerando os desconto na folha .." )
			
			
			If lContinua
				
				Exit
			Else
				
				TRB->(DbGotop())
				
			EndIf
		Else
			
			If Aviso("Atencao","Nao exite pedido selecionado. Deseja retornar ao processo ?", {"Voltar","Sair"} ) == 2
				Exit
			EndIf
			
		EndIf
		
	ElseIf nOpca == 2
		Exit
	EndIf
	
End

TRB->(DbCloseArea())
QRY->(DbCloseArea())
Return
/*/
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
Static Function LchoiceBar(oDlg,bOk,bCancel,lPesq,nTipo)
Local oBar, bSet15, bSet24, lOk
Local lVolta :=.f.

DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg

DEFINE BUTTON RESOURCE "PESQUISA" OF oBar GROUP ACTION ProcPedido() TOOLTIP OemToAnsi("Procura Pedido...")
DEFINE BUTTON RESOURCE "EDIT" OF oBar GROUP ACTION MosDocum() TOOLTIP OemToAnsi("Mostra o documento...")
DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
SetKEY(15,oBtOk:bAction)
DEFINE BUTTON oBtCan RESOURCE "CANCEL" OF oBar ACTION ( lLoop:=.F.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP OemToAnsi("Cancelar - <Ctrl-X>")  //
SetKEY(24,oBtCan:bAction)
oDlg:bSet15 := oBtOk:bAction
oDlg:bSet24 := oBtCan:bAction
oBar:bRClicked := {|| AllwaysTrue()}
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPGPEA01   บAutor  ณMicrosiga           บ Data ณ  12/23/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraDesc()

If !ExisteSX6("MV_VERBAMU")
	CriarSX6("MV_VERBAMU","C","Define a verba a ser utilizada para o desconto de multa","473")
EndIf

cVerba := GetMV("MV_VERBAMU")
cSemana     := Space(2)
c__Roteiro	:= "FOL"  
aPdv        := {}
aPd         := {}
_PerIni     := ""    

DbSelectArea("TRB")
DbGotop()

ProcRegua(RecCount())

While TRB->(!Eof())
	
	IncProc("Gerando os descontos das multas na folha.." )
	
	If Empty(TRB->OK)
		DbSkip()
		Loop
	EndIf
	
	DbSelectArea("SRA")
	DbSetOrder(1)
	DbSeek(xFilial("SRA")+TRB->MAT )
	
	DbSelectArea("RCH")
	DbSetOrder(8) //RCH_FILIAL+RCH_PROCES+RCH_ROTEIR+RCH_PERSEL   BY MVCARD
	If DbSeek(xFilial("RCH")+"00001"+"FOL"+"1" )
		_cPeriodo := RCH->RCH_PER
		_PerIni   := RCH->RCH_DTINI
		
	Else
		MsgAlert("Nใo foi possํvel encontrar um perํodo em aberto do Processo: "+_cProcess+" Roteiro: "+c__Roteiro+". Favor Verificar" )
		Return 
	EndIf
    /*DbSelectArea("SRC")
    DbSetorder(1)
    If !DbSeek(xFilial("SRC")+TRB->MAT+cVerba )
       RecLock("SRC",.T.)
       SRC->RC_FILIAL := xFilial("SRC")
       SRC->RC_MAT    := TRB->MAT
       SRC->RC_PD     := cVerba
       SRC->RC_TIPO1  := "V"
       SRC->RC_VALOR  := TRB->VALOR
       SRC->RC_DATA   := dDataBase
       SRC->RC_CC     := SRA->RA_CC
       SRC->RC_TIPO2  := "I"
       MsUnlock()

    Else
       Reclock("SRC",.F.)
       SRC->RC_VALOR += TRB->VALOR
       MsUnlock()
	EndIf */
	
	RecLock("SRK",.T.)
       SRK->RK_FILIAL 	:= xFilial("SRK")
       SRK->RK_MAT    	:= TRB->MAT
       SRK->RK_PD     	:= cVerba
       SRK->RK_VALORTO  := TRB->VALOR
       SRK->RK_PARCELA  := TRB->PARCELAS
       SRK->RK_VALORPA  := TRB->VALOR/TRB->PARCELAS
       SRK->RK_DOCUMEN  := TRB->PEDIDO+TRB->ITEM
       SRK->RK_VLSALDO  := TRB->VALOR
       SRK->RK_DTVENC   := _PerIni
       SRK->RK_CC 		:= SRA->RA_CC  
       SRK->rk_EMPCONS  := "N" 
       SRK->RK_DTMOVI  	:= dDatabase  
       SRK->RK_PERINI  	:= _cPeriodo
       SRK->RK_NUMPAGO 	:= "01"
       SRK->RK_PROCES  	:= "00001"
       SRK->RK_STATUS  	:= "2"        
       SRK->RK_NUMID   := "SRK"+xFilial("SRK")+  TRB->MAT + cVerba + TRB->PEDIDO+TRB->ITEM
       SRK->RK_DTREF   :=  dDatabase  
 	MsUnlock()
	
	DbSelectArea("SC7")
	DbSetOrder(1)
	If DbSeek(xFilial("SC7")+TRB->PEDIDO+TRB->ITEM )  
	   RecLock("SC7",.F.)
	   SC7->C7_GERAFOL := "S"
	   MsUnlock()
	EndIf 
	//fGeraVerba(cVerba,TRB->VALOR,,,,,"I",,,,.T.)
	
	DbSelectArea("TRB")
	DbSkip()
	
End

Return 



/*                                                                                                          

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPGPEA01   บAutor  ณMicrosiga           บ Data ณ  12/23/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MosDocum()
Local aArea := GetArea()

DbSelectArea("SF1")
DbSetOrder(1)
DbSeek(xFilial("SF1")+TRB->DOC+TRB->SERIE )

MsDocument( "SF1", SF1->( Recno() ), 1 )                       

RestArea(aArea)

Return 

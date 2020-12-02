#Include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO7     บAutor  ณMicrosiga           บ Data ณ  08/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona os funcionarios do RH que recebem e-mail de      บฑฑ
ฑฑบ          ณ aviso                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RhUsrMail()
Local aCampos := {}
Local oDlg1, oValor

AADD(aCampos,{"OK","C",2,0 })
AADD(aCampos,{"COD","C",6,0 })
AADD(aCampos,{"NOME","C",30,2 })

cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.F.,.F.)
IndRegua("TRB",cArqTrab,"NOME",,,"Selecionando Registros..." )

Private aAllUsers := {}

nEscolha := Escolha()

If nEscolha == 1
	If !ExisteSX6("MV_EMAILRH")
		CriarSX6("MV_EMAILRH","C","Guarda os usuarios do RH que recebem o aviso do desconto de multa","000179#000202")
	EndIf
	
	cEmail := Alltrim(GetMV("MV_EMAILRH"))
	
ElseIf nEscolha == 2
	
	If !ExisteSX6("MV_MAILFIS")
		CriarSX6("MV_MAILFIS","C","Guarda os usuarios do Fiscal que recebem o aviso de inclusao de fornecedor","")
	EndIf
	
	cEmail := Alltrim(GetMV("MV_MAILFIS"))
	
ElseIf nEscolha == 3
	
	If !ExisteSX6("MV_MAILPRD")
		CriarSX6("MV_MAILPRD","C","Guarda os usuarios que  recebem o aviso de inclusao de produto","")
	EndIf
	
	cEmail := Alltrim(GetMV("MV_MAILPRD"))

ElseIf nEscolha == 4
	
	If !ExisteSX6("MV_MAILATV")
		CriarSX6("MV_MAILATV","C","Guarda os usuarios que  recebem o aviso de manutencao de Ativo","")
	EndIf
	
	cEmail := Alltrim(GetMV("MV_MAILATV"))

ElseIf nEscolha == 5
	
	If !ExisteSX6("MV_MAILFAT")
		CriarSX6("MV_MAILFAT","C","Guarda os usuarios que  recebem o aviso de inclusao de clientes","")
	EndIf
	
	cEmail := Alltrim(GetMV("MV_MAILFAT"))

ElseIf nEscolha == 6
	
	If !ExisteSX6("MV_MAILSGI")
		CriarSX6("MV_MAILSGI","C","Guarda os usuarios que  recebem o aviso de fornecedores nao homologados","")
	EndIf
	
	cEmail := Alltrim(GetMV("MV_MAILSGI"))

EndIf

LjMsgRun("Selecionando os usuario..","Aguarde",{||BuscaUsr()} )

DbSelectArea("TRB")

cMarca   := GetMark()
nOpca    :=0
lInverte := .F.

For nX := 1 to Len(aAllUsers)
	
	If ! aAllUsers[nX,1,17]
		DbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->OK   := If(aAllUsers[nX,1,1] $ cEmail,cMarca," ")
		TRB->COD  := aAllUsers[nX,1,1]
		TRB->NOME := aAllUsers[nX,1,2]
		MsUnlock()
	EndIf
	
Next

TRB->(DbGoTop())

aBrowse := {}
AaDD(aBrowse,{"OK","",""})
AaDD(aBrowse,{"NOME","","Nome"})
AaDD(aBrowse,{"COD","","Usuario"})

//cMarca   := GetMark()
nOpca    :=0
lInverte := .F.

While .T.
	
	DEFINE MSDIALOG oDlg1 TITLE "Seleciona Usuario" From 9,0 To 37,80 OF oMainWnd
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
	//ณ arquivo de trabalho "TRB".                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark := MsSelect():New("TRB","OK","",aBrowse,@lInverte,@cMarca,{15,3,203,315})
	
	oMark:bMark := {| | fa060disp(cMarca,lInverte)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }
	
	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||oDlg1:End()},.F.) centered
	
	If nOpca == 1
		
		nVez := 0
		TRB->(DbGoTop())
		
		While TRB->(!Eof())
			If Empty(TRB->OK)
				DbSkip()
				Loop
			EndIf
			nVez++
			TRB->(DbSkip())
		End
		
		If nVez == 0
			MsgStop("Nao houve selecao de nenhum usuario")
			Loop
		ElseIf nVez > 10
			MsgStop("Selecao de usuarios excedido. Maximo de 5")
			Loop
		EndIf
		
		cNewUsers := ""
		lPri      := .T.
		TRB->(DbGoTop())
		
		While TRB->(!Eof())
			If Empty(TRB->OK)
				DbSkip()
				Loop
			EndIf
			
			If lPri
				cNewUsers := TRB->COD
				lPri := .F.
			Else
				cNewUsers += "#"+TRB->COD
			EndIf
			
			TRB->(DbSkip())
			
		End
		
		If nEscolha == 1
			DbSelectArea("SX6")
			DbSetOrder(1)
			DbSeek("  MV_EMAILRH")
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := cNewUsers
			MsUnlock()
		ElseIf nEscolha == 2
			DbSelectArea("SX6")
			DbSetOrder(1)
			DbSeek("  MV_MAILFIS")
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := cNewUsers
			MsUnlock()
			
		ElseIf nEscolha == 3
			DbSelectArea("SX6")
			DbSetOrder(1)
			DbSeek("  MV_MAILPRD")
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := cNewUsers
			MsUnlock()

		ElseIf nEscolha == 4
			DbSelectArea("SX6")
			DbSetOrder(1)
			DbSeek("  MV_MAILATV")
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := cNewUsers
			MsUnlock()

		ElseIf nEscolha == 4
			DbSelectArea("SX6")
			DbSetOrder(1)
			DbSeek("  MV_MAILATV")
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := cNewUsers
			MsUnlock()

		ElseIf nEscolha == 5
			DbSelectArea("SX6")
			DbSetOrder(1)
			DbSeek("  MV_MAILFAT")
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := cNewUsers
			MsUnlock()

		ElseIf nEscolha == 6
			DbSelectArea("SX6")
			DbSetOrder(1)
			DbSeek("  MV_MAILSGI")
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := cNewUsers
			MsUnlock()

		EndIf
		
		MsgInfo("Usuarios selecionados com sucesso")
		
		Exit
		
	Else 
	   
	   If MsgYesNo("Deseja realmente sair sem alterar o parametro")
	      Exit 
	   EndIf 
	EndIf
	
End

TRB->(DbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO7     บAutor  ณMicrosiga           บ Data ณ  08/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BuscaUsr()

aAllUsers := AllUsers()

Return


/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno	 ณFA060Disp ณ Autor ณ Carlos R. Moreira     ณ Data ณ 09/05/03 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Exibe Valores na tela									  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso		 ณ Especifico Escola Graduada                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Fa060Disp(cMarca,lInverte)
Local aTempos, cClearing, oCBXCLEAR, oDlgClear,lCOnf
If IsMark("OK",cMarca,lInverte)
	
Else
	
Endif
oMark:oBrowse:Refresh(.t.)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEGF003    บAutor  ณMicrosiga           บ Data ณ  02/19/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
DEFINE BUTTON RESOURCE "PESQUISA" OF oBar GROUP ACTION ProcUsr() TOOLTIP OemToAnsi("Procura Usuario...")    //
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
ฑฑบPrograma  ณProcTranspบAutor  ณCarlos R. Moreira   บ Data ณ  19/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLocaliza a Transportadora                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Scarlat                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcUsr()
Local cUsr := Space(30)
Local oDlgProc


DEFINE MSDIALOG oDlgProc TITLE "Procura Usuario" From 9,0 To 18,40 OF oMainWnd

@ 5,3 to 41,155 of oDlgProc PIXEL

@ 15,5 Say "Digite o Usuario.:" Size 50,10  of oDlgProc Pixel
@ 13,45 MSGet cUsr Size 60,10 of oDlgProc Pixel

@ 50, 90 BMPBUTTON TYPE 1 Action PosUsr(@cUsr,oDlgProc)
@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

ACTIVATE MSDIALOG oDlgProc Centered

Return

Static Function PosUsr(cUsr,oDlgProc)

TRB->(DbSeek(Alltrim(cUsr),.T.))

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

@ 0,0 TO 200,250 DIALOG oDlg2 TITLE "Selecione a Tabela"
@ 05,05 TO 67,120 TITLE "Selecione"
@ 10,30 RADIO oRadio Var nRadio Items "Recursos Humanos","Fiscal","Produto","Ativo","Clientes","SG1" 3D SIZE 60,10 of oDlg2 Pixel
@ 080,075 BMPBUTTON TYPE 1 ACTION Close(oDlg2)
ACTIVATE DIALOG oDlg2 CENTER

Return nRadio

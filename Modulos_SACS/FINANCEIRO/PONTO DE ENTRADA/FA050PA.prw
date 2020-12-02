#INCLUDE "Protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO5     �Autor  �Microsiga           � Data �  10/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ira mostrar os pedidos de adiantamento ref ao fornecedor   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA050PA()
	Local lRet := .T.
	Local aCampos := {}

	//��������������������������������������������������������������Ŀ
	//� Define array para arquivo de trabalho                        �
	//����������������������������������������������������������������
	AADD(aCampos,{ "OK"       ,"C",  2,0 } )
	AADD(aCampos,{ "DOC"      ,"C",  9,0 } )
	AADD(aCampos,{ "EMISSAO"  ,"D",  8,0 } )
	AADD(aCampos,{ "VALOR"    ,"N", 14,2 } )
	AADD(aCampos,{ "TIPO"     ,"C",  1,0 } )

	//���������������������������Ŀ
	//� Monta arquivo de trabalho �
	//�����������������������������
	cTrab:= CriaTrab(aCampos)

	If Select("TRB") > 0
		TRB->(DbCloseArea())
	Endif

	DbUseArea(.T.,,cTrab,"TRB",,.F. )

	IndRegua("TRB",cTrab,"DOC",,,"Selecionando Registros...")

	cQuery := " SELECT SC7.C7_NUM, SC7.C7_EMISSAO, C7_VLR_PA FROM "+RetSqlName("SC7")+" SC7 "
	cQuery += " WHERE SC7.D_E_L_E_T_ <> '*' AND SC7.C7_CONAPRO = 'L' AND SC7.C7_GERAPA = ' ' AND SC7.C7_PA = 'S' AND  "
	cQuery += " SC7.C7_FORNECE = '"+M->E2_FORNECE+"' AND SC7.C7_LOJA = '"+M->E2_LOJA+"' "

	cQuery    := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

	TCSetField("QRY","C7_EMISSAO","D")

	nTotReg := 0
	QRY->(dbEval({||nTotREG++}))
	QRY->(dbGoTop())

	DbSelectArea("QRY")

	ProcRegua(nTotReg)

	While QRY->(!Eof())

		DbSelectArea("TRB")
		If !TRB->(DbSeek(QRY->C7_NUM))
			RecLock("TRB",.T.)
			TRB->DOC     := QRY->C7_NUM
			TRB->EMISSAO := QRY->C7_EMISSAO
			TRB->VALOR   := QRY->C7_VLR_PA
			TRB->TIPO    := "P"
			MsUnlock()
		EndIf

		DbSelectArea("QRY")
		DbSkip()

	End

	QRY->(DbCloseArea())

	LJMsgRun("Verificando as NCC ..","Aguarde..",{||ProcNCC()} )

	TRB->(DbGotop())
	If TRB->(Eof())
		MsgStop("Fornecedor nao possui documento para selecao.")
		TRB->(DbCloseArea())
		Return .T.
	EndIf

	DbSelectArea("TRB")

	cMarca   := GetMark()
	aBrowse := {}
	AaDD(aBrowse,{"OK","",""})
	AaDD(aBrowse,{"DOC","","Documento"})
	AaDD(aBrowse,{"EMISSAO","","Emissao"})
	AaDD(aBrowse,{"VALOR","","Valor","@E 999,999,999.99"})

	While .T.

		TRB->(DbGoTop())

		nOpca    :=0
		lInverte := .F.
		DEFINE MSDIALOG oDlg1 TITLE "Seleciona o Documento" From 9,0 To 37,60 OF oMainWnd

		//����������������������������������������������������������������������Ŀ
		//� Passagem do parametro aCampos para emular tamb�m a markbrowse para o �
		//� arquivo de trabalho "TRB".                                           �
		//������������������������������������������������������������������������
		oMark := MsSelect():New("TRB","OK","",aBrowse,@lInverte,@cMarca,{15,3,203,235})

		oMark:bMark := {| | fa060disp(cMarca,lInverte)}
		oMark:oBrowse:lhasMark = .t.
		oMark:oBrowse:lCanAllmark := .t.
		oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

		ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||nOpca:=2,oDlg1:End()},.F.,2) centered

		If nOpca == 1

			nVez := 0

			DbSelectArea("TRB")
			DbGotop()

			While TRB->(!Eof())

				If !Empty(TRB->OK)
					nVez++
				EndIf
				DbSkip()
			End

			If nVez > 1
				MsgInfo("Voce deve selecionar somente um documento")
				Loop
			ElseIf nVez == 0
				MsgInfo("Nao houve sele��o de nenhum documento")
				Loop
			EndIf

			DbSelectArea("TRB")
			DbGotop()

			While TRB->(!Eof())

				If !Empty(TRB->OK)
					Exit
				EndIf
				DbSkip()

			End
			M->E2_PREFIXO := If(TRB->TIPO=="P","ADT","NCC")
			M->E2_NUM     := TRB->DOC
			M->E2_VALOR   := TRB->VALOR
			M->E2_DOC     := TRB->DOC
			M->E2_VENCTO  := dDataBase
			M->E2_VENCREA := dDataBase
			lRet := .T.
			Exit
		Else
			Exit
		EndIf

	End

	TRB->(DbCloseArea())

Return lRet

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FA060Disp � Autor � Carlos R. Moreira     � Data � 09/05/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Valores na tela									  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Especifico                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Fa060Disp(cMarca,lInverte)
	Local aTempos, cClearing, oCBXCLEAR, oDlgClear,lCOnf
	If IsMark("OK",cMarca,lInverte)
	Endif
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa060Inve �Autor  �Carlos R. Moreira   � Data �  19/07/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �inverte a Selecao dos Itens                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	PNE->(dbGoto(nReg))
	oMark:oBrowse:Refresh(.t.)
Return Nil

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �LchoiceBar� Autor � Pilar S Albaladejo    � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Mostra a EnchoiceBar na tela                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function LchoiceBar(oDlg,bOk,bCancel,nOpcao)
	Local oBar, bSet15, bSet24, lOk
	Local lVolta :=.f.

	DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
	DEFINE BUTTON RESOURCE "S4WB011N" OF oBar GROUP ACTION ProcPed() TOOLTIP OemToAnsi("Procura Documento..")
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ProcPedido�Autor  �Carlos R. Moreira   � Data �  19/07/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Localiza o Pedido                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ProcPed()
	Local cPedido := Space(9)
	Local oDlgProc

	DEFINE MSDIALOG oDlgProc TITLE "Procura Documento" From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,155 of oDlgProc PIXEL

	@ 15,5 Say "Documento :" Size 50,10  of oDlgProc Pixel
	@ 13,45 MSGet cPedido   Size 60,10 of oDlgProc Pixel

	@ 50, 90 BMPBUTTON TYPE 1 Action PosPed(@cPedido,oDlgProc)
	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

Return

Static Function PosPed(cPedido,oDlgProc)

	TRB->(DbSeek(Alltrim(cPedido),.T.))

	Close(oDlgProc)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA050PA   �Autor  �Microsiga           � Data �  10/25/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ProcNCC()

	cQuery := " SELECT SE1.E1_NUM, SE1.E1_EMISSAO, SE1.E1_SALDO FROM "+RetSqlName("SE1")+" SE1 "
	cQuery += " WHERE SE1.D_E_L_E_T_ <> '*'  AND SE1.E1_PA = ' ' AND  SE1.E1_SALDO > 0 AND SE1.E1_TIPO = 'NCC' AND "
	cQuery += " SE1.E1_CLIENTE = '"+M->E2_FORNECE+"' AND SE1.E1_LOJA = '"+M->E2_LOJA+"' "

	cQuery    := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

	TCSetField("QRY","E1_EMISSAO","D")

	nTotReg := 0
	QRY->(dbEval({||nTotREG++}))
	QRY->(dbGoTop())

	DbSelectArea("QRY")

	ProcRegua(nTotReg)

	While QRY->(!Eof())

		DbSelectArea("TRB")
		If !TRB->(DbSeek(QRY->E1_NUM))
			RecLock("TRB",.T.)
			TRB->DOC     := QRY->E1_NUM
			TRB->EMISSAO := QRY->E1_EMISSAO
			TRB->VALOR   := QRY->E1_SALDO
			TRB->TIPO    := "N"
			MsUnlock()
		EndIf

		DbSelectArea("QRY")
		DbSkip()

	End

	QRY->(DbCloseArea())

Return

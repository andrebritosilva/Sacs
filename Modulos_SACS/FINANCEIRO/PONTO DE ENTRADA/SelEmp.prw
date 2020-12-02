#Include "RWMAKE.CH"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SelEmp    �Autor  �Carlos R. Moreira   � Data �  06/21/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Seleciona as empresas                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SelEmp(cRet)
Local aEmp := {}
Local aCampos := {}
Local aUser := {}
Local aEmpUser := {}

PswOrder(1)
If PswSeek(__cUserId)
	aEmpresas  := PswRet()[2][6]
	If !Empty(aEmpresas) .And. aEmpresas[1] == "@@@@"
		If Select("SM0") > 0
			aEmpresas := {}
			nRecSM0 := SM0->(Recno())
			SM0->(dbGotop())
			While SM0->(!Eof())
				
				If SM0->M0_CODFIL # "01"
					DbSkip()
					Loop
				EndIf
				
				If SM0->M0_CODIGO == "91"
					DbSkip()
					Loop
				EndIf
				Aadd(aEmpresas,SM0->M0_CODIGO)
				SM0->(dbSkip())
			End
			SM0->(DbGoTo(nRecSM0))
		EndIf
	EndIf

EndIf

AaDd(aCampos,{"OK"        ,"C",2,0})
AaDd(aCampos,{"EMP"       ,"C", 2,0})
AaDd(aCampos,{"NOME"      ,"C",30,0})

cArqTmp := CriaTrab(aCampos,.T.)

//��������������������������Ŀ
//�Cria o arquivo de Trabalho�
//����������������������������

DbUseArea(.T.,,cArqTmp,"TRB1",.F.,.F.)
IndRegua("TRB1",cArqTmp,"EMP",,,"Selecionando Registros..." )

DbSelectArea("SM0")

aAreaSM0 := GetArea()

DbGotop()
ProcRegua( RecCount())

While SM0->(!Eof())
	
	IncProc("Processando a Empresa "+SM0->M0_CODIGO)
	
	//	nPesq := Ascan(aEmpUser,SM0->M0_CODIGO)
	//	If nPesq > 0 .Or. aEmpUser[01] == "@@"
	
	nPesq := Ascan(aEmpresas,SM0->M0_CODIGO)
	If nPesq > 0 .Or. aEmpresas[1] == "@@"
		
		DbSelectArea("TRB1")
		If !DbSeek(SM0->M0_CODIGO )
			RecLock("TRB1",.T.)
			TRB1->EMP       := SM0->M0_CODIGO
			TRB1->NOME      := SM0->M0_NOMECOM
			MsUnlock()
		EndIf
	EndIf
	DbSelectArea("SM0")
	SM0->(DbSkip())
	
End

TRB1->(DbGoTop())

aBrowse := {}
AaDD(aBrowse,{"OK","",""})
AaDD(aBrowse,{"EMP","","Empresa"})
AaDD(aBrowse,{"NOME","","Nome"})

nOpca    :=0
lInverte := .F.
cMarca   := GetMark()

DEFINE MSDIALOG oDlg1 TITLE "Seleciona Empresa" From 9,0 To 26,55 OF oMainWnd

//����������������������������������������������������������������������Ŀ
//� Passagem do parametro aCampos para emular tamb�m a markbrowse para o �
//� arquivo de trabalho "FUNC".                                           �
//������������������������������������������������������������������������
oMark := MsSelect():New("TRB1","OK","",aBrowse,@lInverte,@cMarca,{15,3,123,205})

oMark:bMark := {| | fa060disp(cMarca,lInverte)}
oMark:oBrowse:lhasMark = .t.
oMark:oBrowse:lCanAllmark := .t.
oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=0,oDlg1:End()},{||nOpca:=0,oDlg1:End()}) centered

DbSelectArea("TRB1")
DbGoTop()
aEmp := {}
lPri := .T.
While TRB1->(!Eof())
	
	
	If ! Empty(TRB1->OK)
		If cRet == "C"
			If lPri
				cEmp := TRB1->EMP
				lPri := .F.
			Else
				cEmp += "#"+TRB1->EMP
			EndIf
		ElseIf cRet == "V"
			AaDD(aEmp,TRB1->EMP)
		EndIf
		
	EndIf
	
	DbSkip()
	
End

TRB1->(DbCloseArea())

RestArea( aAreaSM0 )

Return If(cRet=="C",cEmp,aEmp)


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FA060Disp � Autor � Carlos R. Moreira     � Data � 09/05/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Valores na tela									  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Especifico Rhoss Print                                     ���
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
Local nReg := TRB1->(Recno())
Local cAlias := Alias()
dbSelectArea("TRB1")
dbGoTop()
While !Eof()
	RecLock("TRB1")
	TRB1->OK := IIF(TRB1->OK == "  ",cMarca,"  ")
	MsUnlock()
	dbSkip()
Enddo
TRB1->(dbGoto(nReg))
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
Static Function LchoiceBar(oDlg,bOk,bCancel)
Local oBar, bSet15, bSet24, lOk
Local lVolta :=.f.

DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
//DEFINE BUTTON RESOURCE "S4WB011N" OF oBar GROUP ACTION ProcNome() TOOLTIP OemToAnsi("Procura por Nome..")
DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
SetKEY(15,oBtOk:bAction)
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
���Programa  �ProcNome  �Autor  �Carlos R. Moreira   � Data �  19/07/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Localiza o Nome do Professor                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Escola Graduada                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ProcNome()
Local cNome := Space(20)
Local oDlgProc

DEFINE MSDIALOG oDlgProc TITLE "Procura Nome" From 9,0 To 18,40 OF oMainWnd

@ 5,3 to 41,155 of oDlgProc PIXEL

@ 15,5 Say "Digite o Nome: " Size 50,10 of oDlgProc Pixel
@ 13,45 Get cNome Picture "@!" Size 60,10 of oDlgProc Pixel

@ 50, 90 BMPBUTTON TYPE 1 Action PosNom(@cNome,oDlgProc)
@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

ACTIVATE MSDIALOG oDlgProc Centered

Return

Static Function PosNom(cNome,oDlgProc)

TRB1->(DbSeek(cNome,.T.))

Close(oDlgProc)

Return

Static Function BuscaUser()

aAllUsers:= AllUsers()

Return

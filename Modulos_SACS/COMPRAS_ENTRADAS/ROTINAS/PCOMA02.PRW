#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCOMA02   �Autor  �Carlos R. Moreira   � Data �  26/10/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Altera a data de entrega no pedido de compra               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Gtex                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PCOMA02()

aRotina := { { "Pesquisar" ,"AxPesqui" , 0 , 1, 0 },;
{ "Visualizar","AxVisual" , 0 , 2, 0 },;
{ "Alterar"   ,"U_PCOMA02A" , 0 , 4, 0} }

//Ira checar se o usuario tem permissao para digitacao do Inventario
Private cCodUsu := __cuserid
//If !cCodUsu $ "000052"
//   MsgStop("Usuario sem permissao de executar a rotina...")
//   Return
//EndIf

Private cCadastro := OemToAnsi("Acerto de Pedido de Compra")

mBrowse( 6, 1,22,75,"SC7")

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �EGF25A    � Autor � Carlos R. Moreira     � Data � 05.06.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de alteracao de Eventos de alunos                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � EGF25A   (ExpC1,ExpN1,ExpN2)                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Opcao selecionada no menu                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Graded                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function PCOMA02A(cAlias,nReg,nOpcx)
LOCAL nCnt,nSavRec
Local oDlg

nSavRec := SC7->(Recno())

If ( SC7->C7_QUANT - SC7->C7_QUJE ) <= 0 .Or. !Empty(SC7->C7_RESIDUO)
	MsgStop("Item ja atendido. Nao pode ser alterado.." )
	Return
EndIf

//��������������������������������������������������������������Ŀ
//� Monta a entrada de dados do arquivo                          �
//����������������������������������������������������������������
Private aTELA[0][0],aGETS[0],aHeader[0],Continua:=.F.,nUsado:=0

//��������������������������������������������������������������Ŀ
//� Monta o cabecalho                                            �
//����������������������������������������������������������������
cNewFor  := SPACE(6) 
//M->A1_REGIAO  := SA1->A1_REGIAO
//M->A1_CANAL   := SA1->A1_CANAL

SA2->(DbSetOrder(1))
SA2->(DbSeek(xFilial("SA2")+SC7->C7_FORNECE+ SC7->C7_LOJA ))


cFornece := SC7->C7_FORNECE+" "+ SC7->C7_LOJA+"-"+SA2->A2_NOME


nOpca:=0
DEFINE MSDIALOG oDlg TITLE OemToAnsi("Acerta o Ped. Compra "+SC7->C7_NUM) From 9,0 To 28,80 OF oMainWnd

oGrp1 := TGROUP():Create(oDlg)
oGrp1:cName := "oGrp1"
oGrp1:cCaption := "Fornecedor"
oGrp1:nLeft := 19
oGrp1:nTop := 30
oGrp1:nWidth := 588
oGrp1:nHeight := 47
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

oGrp2 := TGROUP():Create(oDlg)
oGrp2:cName := "oGrp2"
oGrp2:cCaption := "Novo Fornecedor"
oGrp2:nLeft := 19
oGrp2:nTop := 80
oGrp2:nWidth := 588
oGrp2:nHeight := 57
oGrp2:lShowHint := .F.
oGrp2:lReadOnly := .F.
oGrp2:Align := 0
oGrp2:lVisibleControl := .T.

@  24 ,  40  GET cFornece WHEN .F. SIZE 225,08

@  53 ,  80  GET cNewFor   SIZE 065,08 F3 "SA2"

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,oDlg:End()},{||nOpca:=2,oDlg:End()}) VALID nOpca != 0 CENTERED
IF nOpca == 1
	Begin Transaction
	PCOMA02Grava(cAlias)
	EvalTrigger( )
	End Transaction
Else
	MsUnlockAll( )
End
//��������������������������������������������������������������Ŀ
//� Restaura a integridade da janela                             �
//����������������������������������������������������������������
dbSelectArea(cAlias)
Go nSavRec

Return nOpca

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �PCOMA02Grava� Autor � Carlos R. Moreira     � Data � 05.06.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava as informacoes do Pedido de Compra                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function PCOMA02Grava(cAlias)


DbSelectArea("SC7")

RecLock("SC7",.F.)
SC7->C7_FORNECE  := cNewFor 
MsUnlock()


MsgInfo("Pedido atualizado com Sucesso..")

Return

#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCOMA01   �Autor  �Carlos R. Moreira   � Data �  26/10/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Altera os campos do cadastro de Fornecedor                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Gtex                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PCOMA01()

aRotina := { { "Pesquisar" ,"AxPesqui" , 0 , 1},;
			 { "Visualizar","AxVisual" , 0 , 2},;
			 { "Alterar"   ,"U_PCOMA01A" , 0 , 4} }

//Ira checar se o usuario tem permissao para digitacao do Inventario
Private cCodUsu := __cuserid

Private cCadastro := OemToAnsi("Atualiza o Dados Fornecedor")

mBrowse( 6, 1,22,75,"SA2")

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �PCOMA01   � Autor � Carlos R. Moreira     � Data � 05.06.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de alteracao de Cadastro de Fornecedor            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function PCOMA01A(cAlias,nReg,nOpcx)
LOCAL nCnt,nSavRec
Local oDlg

nSavRec := SA2->(Recno())

//��������������������������������������������������������������Ŀ
//� Monta a entrada de dados do arquivo                          �
//����������������������������������������������������������������
Private aTELA[0][0],aGETS[0],aHeader[0],Continua:=.F.,nUsado:=0

//��������������������������������������������������������������Ŀ
//� Monta o cabecalho                                            �
//����������������������������������������������������������������
M->A2_DTQUAL  := SA2->A2_DTQUAL  
M->A2_VLQUALI := SA2->A2_VLQUALI

cFornece     := SA2->A2_COD+" "+ SA2->A2_LOJA+"-"+SA2->A2_NOME

nOpca:=0
DEFINE MSDIALOG oDlg TITLE OemToAnsi("Qualifica o Fornecedor ") From 9,0 To 28,80 OF oMainWnd

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
oGrp2:cCaption := "Dt Qualificacao"
oGrp2:nLeft := 19
oGrp2:nTop := 80
oGrp2:nWidth := 268
oGrp2:nHeight := 47
oGrp2:lShowHint := .F.
oGrp2:lReadOnly := .F.
oGrp2:Align := 0
oGrp2:lVisibleControl := .T.

oGrp3 := TGROUP():Create(oDlg)
oGrp3:cName := "oGrp3"
oGrp3:cCaption := "Validade Qualificacao"
oGrp3:nLeft := 300
oGrp3:nTop := 80
oGrp3:nWidth := 308
oGrp3:nHeight := 47
oGrp3:lShowHint := .F.
oGrp3:lReadOnly := .F.
oGrp3:Align := 0
oGrp3:lVisibleControl := .T.

@  24 ,  40  GET cFornece WHEN .F. SIZE 225,08 

@  48 ,  40  GET M->A2_DTQUAL SIZE 065,08  

@  48 ,  170 GET M->A2_VLQUALI SIZE 045,08 

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,oDlg:End()},{||nOpca:=2,oDlg:End()}) VALID nOpca != 0 CENTERED
IF nOpca == 1
	Begin Transaction
		PCOMA01Grv(cAlias)
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
���Fun��o    �PCOMA01Grv � Autor � Carlos R. Moreira   � Data � 08.02.12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava as informacoes dos Fornecedores                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function PCOMA01Grv(cAlias)

dbSelectArea("SA2")
RecLock("SA2",.F.)
SA2->A2_DTQUAL  := M->A2_DTQUAL    
SA2->A2_VLQUALI := M->A2_VLQUALI   
MsUnlock()                                      

Return
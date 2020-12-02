#include "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EGC042    �Autor  �Microsiga           � Data �  10/31/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Elimina o Residuo do Pedido de Compra                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Graduada                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ELIMRESPC()

LOCAL nCnt,nSavRec
Local oDlg

nSavRec := SC7->(Recno())

lPedAtend := .T.

cPedido := SC7->C7_NUM
nVlrPed := 0

DbSelectArea("SC7")
DbSetOrder(1)
DbSeek(xFilial("SC7")+cPedido )

While SC7->(!Eof()) .And. SC7->C7_NUM == cPedido
	
	//Quando possuir um item em aberto
	If ( SC7->C7_QUANT - SC7->C7_QUJE ) > 0
		If SC7->C7_RESIDUO # "S"
			lPedAtend := .F.
		Endif
	EndIf
	
	DbSelectArea("SC7")
	DbSkip()
	
End

If lPedAtend
	MsgStop("Pedido ja atendido.  Nao possui item para eliminacao de residuo")
	Return
EndIf

lResiduo := .F.

DbSelectArea("SC7")
DbSetOrder(1)
DbSeek(xFilial("SC7")+cPedido )

While SC7->(!Eof()) .And. SC7->C7_NUM == cPedido
	
	//Quando possuir um item em aberto
	
	If SC7->C7_RESIDUO == "S"
		lResiduo := .T.
	Endif
	
	DbSelectArea("SC7")
	DbSkip()
	
End

If lResiduo
	MsgStop("Pedido ja foi eliminado residuo.")
	Return
EndIf

If !MsgYesNo("confirma a eliminacao do Pedido"+cPedido )
	Return
Endif

DbSelectArea("SC7")
DbSetOrder(1)
DbSeek(xFilial("SC7")+cPedido )

While SC7->(!Eof()) .And. SC7->C7_NUM == cPedido
	
	If ( SC7->C7_QUANT - SC7->C7_QUJE ) <= 0
		DbSkip()
		Loop
	EndIf
	
	DbSelectArea("SC7")
	RecLock("SC7",.F.)
	SC7->C7_RESIDUO := "S"
	MsUnlock()
	DbSkip()
	
End

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EGC042    �Autor  �Microsiga           � Data �  10/31/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Restaura os residuos que foram eliminados                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RESTRESPC()
LOCAL nCnt,nSavRec
Local oDlg

nSavRec := SC7->(Recno())

cPedido := SC7->C7_NUM

lResiduo := .F.

DbSelectArea("SC7")
DbSetOrder(1)
DbSeek(xFilial("SC7")+cPedido )

While SC7->(!Eof()) .And. SC7->C7_NUM == cPedido
	
	If SC7->C7_RESIDUO == "S"
		lResiduo := .T.
	Endif
	
	DbSelectArea("SC7")
	DbSkip()
	
End

If !lResiduo
	MsgStop("Pedido nao possui item com eliminacao de residuo.")
	Return
EndIf

If !MsgYesNo("Confirma a restauracao do Pedido"+cPedido )
	Return
Endif

DbSelectArea("SC7")
DbSetOrder(1)
DbSeek(xFilial("SC7")+cPedido )

While SC7->(!Eof()) .And. SC7->C7_NUM == cPedido
	
    If SC7->C7_RESIDUO # "S" 
       DbSkip()
       Loop
    EndIf  
    
	DbSelectArea("SC7")
	RecLock("SC7",.F.)
	SC7->C7_RESIDUO := " "
	MsUnlock()
	DbSkip()
	
End

Return

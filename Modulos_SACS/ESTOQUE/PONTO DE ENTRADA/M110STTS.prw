#INCLUDE "Protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M110STTS  �Autor  �Carlos R Moreira    � Data �  26/10/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ira mandar e-mails para o grupo do Fiscal                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M110STTS()
	Local aArea := GetArea()

	cSolic := ParamIxb[1]
	lOrcam := .F.

	If MsgYesNo("Solicitacao trata-se de Or�amento")

		lOrcam := .T.

	EndIf

	DbSelectArea("SC1")
	DbSetOrder(1)
	DbSeek(xFilial("SC1")+cSolic )

	While SC1->(!Eof()) .And. SC1->C1_NUM  == cSolic
   
   RecLock("SC1",.F.)
   SC1->C1_TPSOLIC := If(lOrcam,"O","N") 
   MsUnlock()
		DbSkip()
       
	End
       
	RestArea(aArea)
Return
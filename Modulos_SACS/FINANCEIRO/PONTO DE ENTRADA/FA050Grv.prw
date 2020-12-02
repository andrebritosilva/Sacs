#INCLUDE "Protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA050INC  �Autor  �Carlos R Moreira	 � Data �  10/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ira mostrar os pedidos de adiantamento ref ao fornecedor   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA050Grv()

If !Empty(M->E2_DOC)
	
	If Len(AllTrim(M->E2_DOC)) == 6
		DbSelectArea("SC7")
		DbSetOrder(1)
		If DbSeek(xFilial("SC7")+Alltrim(M->E2_DOC) )
			RecLock("SC7",.F.)
			SC7->C7_GERAPA := "S"
			SC7->C7_DATA_PA := dDataBase
			If SC7->C7_COND == "CXA"
			   SC7->C7_QUJE  := SC7->C7_QUANT
			   SC7->C7_ENCER := "E"
			EndIf 
			MsUnlock()
		EndIf
	Else
		DbSelectArea("SE1")
		DbSetOrder(29)
		DbSeek(xFilial("SE1")+M->E2_DOC )
		
		While SE1->(!Eof()) .And. M->E2_DOC == SE1->E1_NUM
			
			If SE1->E1_TIPO == "NCC"
				RecLock("SE1",.F.)
				SE1->E1_PA := "S"
				MsUnLock()
			EndIf
			
			DbSkip()
		End
		
	EndIf
	
EndIf

Return .T.

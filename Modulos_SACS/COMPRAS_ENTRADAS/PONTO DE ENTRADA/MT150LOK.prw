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
���Desc.     �Ira verificar se o produto ira ser revendido                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT150LOK()
	Local aArea := GetArea()

	Local nPosPrd    := aScan(aHeader,{|x| AllTrim(x[2]) == "C8_PRODUTO"})
	Local nPosTes    := aScan(aHeader,{|x| AllTrim(x[2]) == "C8_TES"})
//	Local nPosConta  := aScan(aHeader,{|x| AllTrim(x[2]) == "C8_CONTA"})

//Verifico se o Item nao esta deletado
	If !aCols[n][Len(aCols[n])]

     SB1->(DbSetorder(1))
     SB1->(DbSeek(xFilial("SB1")+aCols[n,nPosPrd] ))
     
     
   
	EndIf
       
	RestArea(aArea)
Return
#include "rwmake.ch"
#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103FIM  �Autor  �Carlos R Moreira    � Data �  03/21/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para alimentar a serie do equipamento no   ���
���          �arquivo de poder de terceiros e centro de custo             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103FIM()
Local aArea := GetArea()

nOpcao := ParamIxb[1]

If nOpcao == 3 .Or. nOpcao == 5  .Or. nOpcao == 4
	
	DbSelectArea("SD1")
	DbSetOrder(1)
	DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA )

    While SD1->(!Eof()) .And. SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA = ;
                              SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA

       
       cPoder3 := Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_PODER3")
       
       If cPoder3 == "R"
          
          DbSelectArea("SB6")
          DbSetOrder(3)
          DbSeek(xFilial("SB6")+SD1->D1_IDENTB6+SD1->D1_COD+cPoder3 )
          RecLock("SB6",.F.)
          SB6->B6_EQSERIE := SD1->D1_EQSERIE
          SB6->B6_CC      := SD1->D1_CC
          MsUnlock()
          
       EndIf
       
       DbSelectArea("SD1")
       DbSkip()
       
    End
    
EndIf 

RestArea(aArea)
Return
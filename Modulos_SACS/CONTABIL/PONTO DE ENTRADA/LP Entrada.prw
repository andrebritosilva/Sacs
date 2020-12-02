#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP65001D  �Autor  �Carlos R.Moreira    � Data �  06/07/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Lancamento padronizado de Compras (Retorno da conta Debito) ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LP65001D()
Local cConta := Space(20)
Local aArea  := GetArea()

If SF4->F4_ATUATF == "S"
	
	//�����������������������������������������Ŀ
	//�Retorna a Conta da Natureza do Ativo Fixo�
	//�������������������������������������������
	cConta := SD1->D1_CONTA
	
Else
	
	If !SB1->B1_TIPO $ "MO/HR/MC/ME/GG"
		cConta := SB1->B1_CONTA
	ElseIf SB1->B1_TIPO $ "ME/MC/GG"
		cConta := SD1->D1_CONTA
	Else
		If !Empty(SD1->D1_OP)
			cConta := SD1->D1_CONTA
		Else
			cConta := SD1->D1_CONTA 
		EndIf
	EndIf
	
EndIf

RestArea(aArea)

Return cConta

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP65001V  �Autor  �Carlos R.Moreira    � Data �  06/07/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Lancamento padronizado de Compras (Retorno o Valor )        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico voith                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LP65001V(cTipo)
Local nValor := 0
Local aArea  := GetArea()

If Substr(SD1->D1_CF,2,3) $ "604#912#916"
   Return nValor 
ElseIf Substr(SD1->D1_CF,2,3) $  "949#910"
   If SF4->F4_DUPLIC == "N"
      Return nValor
   EndIf    
EndIf 
   
If cTipo == 1
	
	If SF4->F4_ATUATF == "S"
		
		nValor := (SD1->D1_TOTAL + SD1->D1_VALIPI) - SD1->D1_VALICM
		
	ElseIf SF4->F4_PODER3 $ "N "
		If  SB1->B1_TIPO $ "MP/PA/MO/PS/MS/PI/SC"
			nValor := SD1->D1_TOTAL - SD1->D1_VALIMP5 - SD1->D1_VALIMP6 - SD1->D1_VALICM
		Else
			If SF4->F4_CREDICM == "S"
				nValor := (SD1->D1_TOTAL - SD1->D1_VALICM - SD1->D1_VALIMP5 - SD1->D1_VALIMP6 )
			Else
				nValor := SD1->D1_TOTAL - SD1->D1_VALIMP5 - SD1->D1_VALIMP6
			EndIf
		EndIf
		
	EndIf
	
Else

	IF SF4->F4_PODER3 $ "N "
		nValor := SD1->D1_TOTAL + SD1->D1_VALIPI
	EndIf

EndIf

RestArea( aArea )

Return( nValor )
     
#INCLUDE "rwmake.ch" 
#INCLUDE "PROTHEUS.CH" 
/* 
����������������������������������������������������������������������������� 
����������������������������������������������������������������������������� 
�������������������������������������������������������������������������ͻ�� 
���Programa �VLDFUNC    �Autor �Carlos R Moreira      � Data � 29/08/17   ��� 
�������������������������������������������������������������������������͹�� 
���Desc.     � Verifica se o funcionario ja trabalhou na anteriormente na ��� 
���          � empresa                                                    ��� 
�������������������������������������������������������������������������͹�� 
���Uso       � Especifico                                                ��� 
�������������������������������������������������������������������������ͼ�� 
����������������������������������������������������������������������������� 
����������������������������������������������������������������������������� 
*/ 

User Function VLDFUNC() 
	Local aArea := GetArea()
	Local lRet := .T. 

	DbSelectArea("SRA")
	DbSetOrder(5)
	If DbSeek(xFilial("SRA")+M->RA_CIC ) 
		If SRA->RA_SITFOLH == 'D'
			MsgStop("Funcionario j� trabalhou anteriormente na Empresa, Matricula: "+SRA->RA_MAT+" Deve se utilizar a copia de registro")
			lRet := .F. 
		EndIf 
	EndIf 

Return lRet 
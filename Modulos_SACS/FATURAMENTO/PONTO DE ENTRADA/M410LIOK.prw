#INCLUDE "Protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  M410LIOK     �Autor  �Guilherme Giuliano Data �  12/04/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para Validar o CFOP que o Usuario Digitou, ��
���          � e verficar se ele existe no cadastro de permissoes (SZ1)   ���
�������������������������������������������������������������������������͹��
���Uso       � Sacs                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

*****************************************************************************
User function M410LIOK
*****************************************************************************
Local lRet  := .F.
Local cCfop := acols[n][GDFIELDPOS("C6_CF")]
Local aArea := GetArea()
dbselectarea("SZ1")
dbsetorder(1)
SZ1->(dbgotop())
IF dbseek(xFilial("SZ1")+__CUSERID)
	While SZ1->Z1_CODUSR == __CUSERID
		IF substr(cCfop,2,3) == SZ1->Z1_CFOP
			lRet := .T.
			exit		
		ENDIF
		SZ1->(dbskip())
		loop
	Enddo
ELSE	               
	DbSelectArea("SC5")
	lRet  := .T.
ENDIF	
IF !lRet
	msgalert("O Usu�rio Logado n�o tem permiss�o para realizar opera��es com este CFOP!")
ENDIF
RestArea(aArea)
return lRet
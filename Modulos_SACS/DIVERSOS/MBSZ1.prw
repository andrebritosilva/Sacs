#INCLUDE "Protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  MBSZ1     �Autor  �Guilherme Giuliano   � Data �  12/04/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de usuarios e suas permissoes para o modulo de    ���
���          � faturamento                                                ���
�������������������������������������������������������������������������͹��
���Uso       � SACS                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*****************************************************************************
User Function MBSZ1
*****************************************************************************
Private cCadastro := "Cadastro de Permissoes de Usuario no Faturamento"

Private aRotina := {{"Pesquisar" ,"AxPesqui",0,1} ,;
		             {"Visualizar","AxVisual",0,2} ,;
		             {"Inclui","AxInclui",0,3} ,;
					{"Altera" ,"AxAltera",0,4} ,;//AxInclui(cAlias,nReg,nOpc,aAcho,cFunc,aCpos,cTudoOk,lF3,cTransact,aButtons,aParam,aAuto,lVirtual,lMaximized,cTela,lPanelFin,oFather,aDim,uArea)
					{"Exclui" ,"AxDeleta",0,5} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZ1"

dbSelectArea("SZ1")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return
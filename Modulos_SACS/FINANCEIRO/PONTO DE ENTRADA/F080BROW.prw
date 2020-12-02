#INCLUDE "RWMAKE.CH"
#include "Protheus.Ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FI050ROT  �Autor  �Carlos R. Moreira   � Data �  06/27/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Acrescenta nos rotinas no Menu                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F080BROW()

aRotina := { { OemToAnsi("Pesquisar"), "AxPesqui" , 0 , 1,,.F.},; //
	{ OemToAnsi("Visualizar"), "AxVisual" , 0 , 2},; //
	{ OemToAnsi("Baixar"), "FA080Tit" , 0 , 4},; //
	{ OemToAnsi("Lote"), "FA080Lot" , 0 , 4},; //
	{ OemToAnsi("Canc Baixa"), "FA080Can" , 0 , 5},; //
	{ OemToAnsi("Excluir Baixa"), "FA080Can" , 0 , 5,53},;	//"Excluir Baixa"
	{ "Visual C.Custo"   ,"U_Vis_CC", 0 , 6},;
	{ OemToAnsi("Le&genda"),"FA040Legenda", 0 , 6, ,.F.} } //

Return 

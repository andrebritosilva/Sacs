#include "rwmake.ch"
#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120BRW  �Autor  �Microsiga           � Data �  06/26/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT120BRW()

 //AAdd( aRotina, { 'Impr.SACS', 'U_Matr110("SC7", SC7->(recno()), 4)', 0, 4 } ) 
AAdd( aRotina, { 'Impr.Ped.Novo', 'U_EmiPedido()', 0, 4 } ) 
AAdd( aRotina, { 'Elim Residuo', 'U_ELIMRESPC()', 0, 4 } )                                                              
AAdd( aRotina, { 'Volta Residuo', 'U_RESTRESPC()', 0, 4 } )
AAdd( aRotina, { 'Reenvia Workflow', 'U_EnvWfPed()', 0, 4 } )

Return(aRotina)
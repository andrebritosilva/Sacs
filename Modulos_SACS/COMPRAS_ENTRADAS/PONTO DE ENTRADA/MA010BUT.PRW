#include "protheus.ch"

User Function MA010BUT()

Local aButtons := {}

aadd(aButtons,{ 'NOTE'      ,{||  U_MostrHist(2) },'Historico de Compras','Historico' } )

Return (aButtons)

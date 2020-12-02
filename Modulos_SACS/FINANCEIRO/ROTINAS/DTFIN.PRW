#INCLUDE "rwmake.ch"
#Include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDTFIN     บ Autor ณ Antonio Guedes     บ Data ณ  15/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Alteracao do Parametro de inicio de periodo Financeiro     บฑฑ
ฑฑบ          ณ MV_DATAFIN (Entrada) e MV_BXDTFIN (Baixas)                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Livros Fiscais  / Gtex Brasil                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DTFIN

Local oBitmap1
Local oSay1
Local oSBCancel1
Local oSNext
Static oDlg1

DEFINE MSDIALOG oDlg1 TITLE OemToAnsi("Altera็ใo de Parโmetro") FROM 000, 000  TO 150, 400 PIXEL

@ 032, 011 BITMAP oBitmap1 SIZE 085, 035 OF oDlg1 FILENAME "gtexlogo1.bmp" NOBORDER PIXEL
@ 009, 012 SAY oSay1 PROMPT OemToAnsi("Este programa altera o parametros MV_DATAFIN, impedindo lan็amentos com data anterior a data informada. Valor Atual: ") + DtoC(SuperGetMv( "MV_DATAFIN" )) SIZE 177, 019 OF oDlg1 COLORS 0, 16777215 PIXEL
DEFINE SBUTTON oSNext FROM 056, 167 TYPE 19 OF oDlg1 ONSTOP OemToAnsi("Pr๓ximo passo") ENABLE ACTION DTFIS2()
DEFINE SBUTTON oSBCancel1 FROM 056, 133 TYPE 02 OF oDlg1 ONSTOP OemToAnsi("Encerra sem alterar") ENABLE ACTION Close(oDlg1)

ACTIVATE MSDIALOG oDlg1 CENTERED


Return


Static Function DTFIS2()
Local oBitmap2
Local oGet1
Local dGet1 := SuperGetMv( "MV_DATAFIN",Date())
Local oSay1
Local oSBCancel1
Local oSOK
Static oDlg2

DEFINE MSDIALOG oDlg2 TITLE "Altera็ใo de Parโmetro" FROM 000, 000  TO 150, 400 PIXEL

@ 032, 011 BITMAP oBitmap2 SIZE 085, 035 OF oDlg2 FILENAME "gtexlogo1.bmp" NOBORDER PIXEL
@ 011, 012 SAY oSay1 PROMPT OemToAnsi("Informe o novo valor para MV_DATAFIN:") SIZE 107, 012 OF oDlg2 COLORS 0, 16777215 PIXEL
DEFINE SBUTTON oSOK FROM 056, 167 TYPE 01 OF oDlg2 ONSTOP OemToAnsi("Confirma altera็๕es") ENABLE ACTION GravaData(dGet1, oDlg2)
DEFINE SBUTTON oSBCancel1 FROM 056, 133 TYPE 02 OF oDlg2 ENABLE ACTION Close(oDlg2)
@ 010, 119 MSGET oGet1 VAR dGet1 SIZE 060, 010 OF oDlg2 PICTURE "__/__/__" COLORS 0, 16777215 HASBUTTON PIXEL

ACTIVATE MSDIALOG oDlg2 CENTERED
Close(oDlg1)
Return





Static Function GravaData(dData,oDlg2)

PutMV( "MV_DATAFIN", DTOS(dData) )

Close(oDlg2)

Return




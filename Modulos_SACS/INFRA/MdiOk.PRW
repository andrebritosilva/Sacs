/*/Program U_MDIOK.PRG/*/
#INCLUDE "PROTHEUS.CH"
/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun+"o    ³U_MdiOk           ³Autor Edson de Moraes ³ Data ³21/08/2017³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri+"o ³Funcao de Validacao do Acesso MDI                                     ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Retorno   ³lMdiOk                                                            ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Validar o Acesso ao Interface MDI                                     ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
User Function MdiOk()

	Local lMdiOk := .F.
	Local cCodUser := RetCodUsr ()
	Local cXmdi := ""
	OpenSX6()
	cXmdi :=SUPERGETMV("MV_XMDI",.F.,"000000")//INFORMAR NESTE PARAMETRO OS USUARIOS QUE TERÃO ACESSO AO SIGAMDI
	Begin Sequence                                                                 

		If cCodUser $ cXmdi
			lMdiOk := .T.
		Else
			lMdiOk := .F.
			MSGALERT("AO ENTRAR NO SISTEMA NA TELA DE PARAMETROS INCIAIS, PREENCHA O PRIMEIRO CAMPO COM SIGAADV")
		EndIF
	End Sequence
Return( lMdiOk )
#include "Protheus.ch"
#include "fileio.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103PN   ºAutor  ³Eduardo MAtias      º Data ³  04/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validar se o documento possui os     º±±
±±º          ³ arquivos anexados no formato PDF.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP11 Gtex                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103PN()

Local lRet    := .T.
Local cDocLog := SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
Local cDocFis := "\dirdoc\co"+SM0->M0_CODIGO+"\shared\"+SF1->F1_FORNECE+SF1->F1_LOJA+AllTrim(SF1->F1_DOC)+".pdf"
Local cDoc    := SF1->F1_FORNECE+SF1->F1_LOJA+AllTrim(SF1->F1_DOC)+".pdf"
Local msg1    := "Falha na classificação do documento."
Local msg2    := "Documento "+cDoc+" não foi anexado de forma correta na base de conhecimento."
Local msg3    := "Documento "+cDoc+" não foi localizado na base de conhecimento."
Local cAtivo  := GetNewPar("MV_MT103PN","S")

If cAtivo = "S" .AND.!INCLUI //.AND. SF1->F1_SCANNF <> "A"
	
	cAliasTop1 := GetNextAlias()
	
	cQuery1 := " SELECT AC9_CODENT,MAX(AC9_FILIAL) AS AC9_FILIAL,MAX(AC9_ENTIDA) AS AC9_ENTIDA,MAX(AC9_FILENT) AS AC9_FILENT "
	cQuery1 += " FROM "+retsqlname("AC9")
	cQuery1 += " WHERE AC9_FILIAL = '"+xFilial("AC9")+"' AND AC9_CODENT = '"+cDocLog+"' AND "+retsqlname("AC9")+".D_E_L_E_T_ ='' "
	cQuery1 += " GROUP BY AC9_CODENT "
	
	//memowrite("c:\MT103PN.sql",cQuery1)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAliasTop1,.T.,.T.)
	
	Do Case
		Case EMPTY((cALIASTOP1)->AC9_CODENT) .AND. FILE(cDocFis)
			lRet := .F.
			msgStop(msg1)
			msgInfo(msg2)
			FERASE(cDocFis)
		Case !EMPTY((cALIASTOP1)->AC9_CODENT) .AND. !FILE(cDocFis)
			lRet := .F.
			msgStop(msg1)
			msgInfo(msg2)
			DbSelectArea("AC9")
			DbSetOrder(2)
			If DbSeek(xFilial("AC9")+"SF1"+"01"+(cALIASTOP1)->AC9_CODENT)
				While !EOF () .AND. AC9->AC9_CODENT = (cALIASTOP1)->AC9_CODENT
					RecLock("AC9",.F.)
					DbDelete()
					MsUnLock()
					dbSkip()
				EndDo
			EndIf
		Case !EMPTY((cALIASTOP1)->AC9_CODENT) .AND. FILE(cDocFis)
			lRet := .T.
		OTHERWISE
			lRet := .F.
			Alert(msg3)
	ENDCASE
EndIf
Return(lRet)

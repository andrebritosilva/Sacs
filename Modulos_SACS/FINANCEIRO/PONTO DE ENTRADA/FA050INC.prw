#INCLUDE "Protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050INC  ºAutor  ³Carlos R Moreira	 º Data ³  10/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ira mostrar os pedidos de adiantamento ref ao fornecedor   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA050INC()
	Local lRet := .T.

	If Type("LTIT_AUTO") == "U"
		lTit_Auto := .F.
	EndIf

	If lTit_Auto
		Return .T.
	EndIf

	If Upper(FunName()) == "FINA050" .Or. Upper(FunName()) ==  "FINA750"

//	Return .T.
// EndIf


		If M->E2_DESDOBR # "S"
			If Alltrim(M->E2_TIPO) # "PA"
	
				MsgStop("Nao pode ser incluso titulos diferente de PA. ")
				lRet := .F.
	
			ElseIf Empty(M->E2_DOC)
	
				Aviso("Atencao","Nao pode ser incluso titulos de PA sem que possua um de pedido de compra aprovado. ",{"OK"})
//	If MsgYesNo("Deseja incluir mesmo assim")
//		Return .T.
//	EndIf
				lRet := .F.
	
			EndIf

			If Len(Alltrim(M->E2_DOC)) = 6
				DbSelectArea("SC7")
				DbSetOrder(1)
				If DbSeek(xFilial("SC7")+AllTrim(M->E2_DOC) )
		
					If SC7->C7_VLR_PA < M->E2_VALOR
			
						Aviso("Atencao","Valor do titulo nao pode ser superior ao informado no  pedido de compra aprovado. ",{"OK"})
						lRet := .F.
			
					EndIf
	
				EndIf
			EndIf
		EndIf
	EndIf

Return lRet

#include "rwmake.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103FIM  ºAutor  ³Microsiga           º Data ³  03/21/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para liberar a Nota de Venda quando se     º±±
±±º          ³Tratar de frete de venda                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Gtex                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION MT140TOK
LOCAL LRET := .t.
local lrettor := .f.

//Preenche com zeros o numero da nota
cNFiscal := StrZero(Val(cNFiscal),9)

sa2->(dbsetorder(1))
SA2->(DBSEEK(XFILIAL("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA ))

/*
If nPosPc > 0
	
	For nX :=1 To Len(aCols)

		DbSelectArea("SC7")
		DbSetOrder(14)
		If MsSeek(xFilEnt(xFilial("SC7"))+aCols[nx][nPosPc]+aCols[nx][nPosItPc]) 
		
			nQtde   := aCols[nX,nPosQuant] + SC7->C7_QUJE  + SC7->C7_QTDACLA //Qtde da Nota
			
			If nQtde > SC7->C7_QUANT  
			   
			   nPerc := ( ( nQtde - SC7->C7_QUANT ) / SC7->C7_QUANT ) * 100 
			   
			Else
			
			EndIf 
			lrettor := .F. //U_MAvaToler(SC7->C7_FORNECE, SC7->C7_LOJA,aCols[nx][nPoscod],aCols[nx][nPosquant]+SC7->C7_QUJE+SC7->C7_QTDACLA,SC7->C7_QUANT,aCols[nx][nPosvlr],xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,,M->dDEmissao,nDecimalPC,SC7->C7_TXMOEDA,))[1]
			//lRet := MaAvalToler(SC7->C7_FORNECE,SC7->C7_LOJA,SC7->C7_PRODUTO,aCols[nx][nPosQtd]+SC7->C7_QUJE+SC7->C7_QTDACLA-IIf(l103Class,SD1->D1_QUANT,0),SC7->C7_QUANT,aCols[nx][nPosVlr],xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,,M->dDEmissao,nDecimalPC,SC7->C7_TXMOEDA,))[1]
			
		EndIf
		If LRETtor
			lRet := .F.
			ALERT("Vlr Unitario da NF esta divergente do Pedido de Compra (3% DE TOLERANCIA)")
			exit
		ENDIF
		
	Next

EndIf 

*/ 

Return LRET


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ COMA020  ³ Autor ³ Aline Correa do Vale  ³ Data ³ 10.11.2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe: MaValToler(ExpC1,ExpC2,ExpC3,ExpN1,ExpN2,ExpN3,ExpN4,ExpL1,ExpL2)±±
±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ExpC1 = Codigo do Fornecedor                                 ³±±
±±³          ³ ExpC2 = Loja do Fornecedor                                   ³±±
±±³          ³ ExpC3 = Codigo do Produto                                    ³±±
±±³          ³ ExpN1 = Quantidade a entregar                                ³±±
±±³          ³ ExpN2 = Quantidade Original do Pedido                        ³±±
±±³          ³ ExpN3 = Preco a receber                                      ³±±
±±³          ³ ExpN4 = Preco Original do Pedido                             ³±±
±±³          ³ ExpL1 = Exibir Help                                          ³±±
±±³          ³ ExpL2 = Indica se verifica Qtde ou Valor                     ³±±
±±³          ³         .T. Verifica QTDE e Valor                            ³±±
±±³          ³         .F. Verifica somente VALOR                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MAvaToler(cFornece,cLoja,cProduto, nQtde, nQtdeOri, nPreco, nPrecoOri, lHelp, lQtde )

Local aArea		:= GetArea()
Local aAreaSA2	:= SA2->(GetArea())
Local aAreaSB1	:= SB1->(GetArea())
Local cAliasAIC := "AIC"
Local lAchou    := .F.
Local lBloqueio := .F.
Local lBLQTolNeg:= .F.
Local nPQtde    := 0
Local nPPreco   := 0
Local lTolerNeg := GetNewPar("MV_TOLENEG",.F.)
Local lCMA20Blq := .F.

DEFAULT cFornece := ""
DEFAULT cLoja    := ""
DEFAULT cProduto := ""
DEFAULT nQtde    := 0
DEFAULT nQtdeOri := 0
DEFAULT nPreco   := 0
DEFAULT nPrecoOri:= 0
DEFAULT lHelp    := .F.
DEFAULT lQtde	 := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o grupo de tributacao do cliente/fornecedor         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA2")
dbSetOrder(1)
MsSeek(xFilial("SA2")+cFornece+cLoja)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o grupo do produto                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1)
MsSeek(xFilial("SB1")+cProduto)
cGrpPrd := SB1->B1_GRUPO
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa por todas as regras validas para este caso          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("AIC")
dbSetOrder(2)
lAchou := .F.
If !Empty(cFornece+cLoja)
	If !Empty(cProduto)
		If !MsSeek(xFilial("AIC")+cFornece+cLoja+cProduto)
			lAchou := MsSeek(xFilial("AIC")+cFornece+Space(Len(cLoja))+cProduto)
		Else
			lAchou := .T.
		EndIf
	ElseIf !Empty(cGrpPrd)
		If !MsSeek(xFilial("AIC")+cFornece+cLoja+Space(Len(cProduto))+cGrpPrd)
			lAchou := MsSeek(xFilial("AIC")+cFornece+Space(Len(cLoja+cProduto))+cGrpPrd)
		Else
			lAchou := .T.
		EndIf
	Else
		If !MsSeek(xFilial("AIC")+cFornece+cLoja)
			lAchou := MsSeek(xFilial("AIC")+cFornece)
		Else
			lAchou := .T.
		EndIf
	EndIf
EndIf
If !lAchou .And. !Empty(cProduto)
	lAchou := MsSeek(xFilial("AIC")+Space(Len(cFornece+cLoja))+cProduto)
EndIf
If !lAchou .and. !Empty(cGrpPrd)
	If !MsSeek(xFilial("AIC")+Space(Len(cFornece+cLoja+cProduto))+cGrpPrd)
		If !MsSeek(xFilial("AIC")+cFornece+Space(Len(cLoja+cProduto))+cGrpPrd)
			If !MsSeek(xFilial("AIC")+cFornece+cLoja)
				If !MsSeek(xFilial("AIC")+Space(Len(cFornece+cLoja+cProduto))+cGrpPrd)
					lAchou := MsSeek(xFilial("AIC")+Space(Len(cFornece+cLoja+cProduto+cGrpPrd)))
				Else
					lAchou := .T.
				EndIf
			Else
				lAchou := .T.
			EndIf
		Else
			lAchou := .T.
		EndIf
	Else
		lAchou := .T.
	EndIf
Endif
If !lAchou
	lAchou := MsSeek(xFilial("AIC")+cFornece+cLoja)
EndIf

If !lAchou
	lAchou := MsSeek(xFilial("AIC")+Space(Len(cFornece+cLoja))+Space(Len(cProduto))+Space(Len(cGrpPrd)))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa por todas as regras validas para este caso          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(cAliasAIC)->(Eof()) .And. lAchou
	nPPreco := (cAliasAIC)->AIC_PPRECO
	nPQtde  := (cAliasAIC)->AIC_PQTDE
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se o parametro MV_TOLENEG estiver .T. o percentual de tolerancia ³
//³ do preco e da quantidade passam a validar tambem os valores da   |
//³ NFE que estiverem a menor que o PC aplicando o bloqueio quando os³
//³ valores ultrapassarem o percentual estabelecido da qtd e do Preco|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lAchou
	If (nQtde+nQtdeOri) > 0 .Or. (nPreco+nPrecoOri) > 0
		If lTolerNeg
			If ABS(((nQtde / nQtdeOri) -1) * 100) > nPQtde .Or. ABS(((nPreco / nPrecoOri) -1)*100) > nPPreco
				lBLQTolNeg := .T.
			EndIf
		EndIf
	EndIf
EndIf

/*

If ( lQtde )

If lAchou .And. (nQtde+nQtdeOri) > 0
If (((nQtde / nQtdeOri) -1)*100) > nPQtde .Or. lBLQTolNeg
If lHelp
Help(" ",1,"QTDLIBMAI")
EndIf
lBloqueio := .T.
EndIf
EndIf
EndIf

*/

If lAchou .And. (nPreco+nPrecoOri) > 0
	If (((nPreco / nPrecoOri) -1)*100) > nPPreco .Or. lBLQTolNeg
		If lHelp
			Help(" ",1,"PRCLIBMAI")
		EndIf
		lBloqueio := .T.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para regra de Bloqueio do Usuario       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lAchou .And. ExistBlock("CMA20BLQ")
	lCMA20Blq := ExecBlock("CMA20BLQ",.F.,.F.,{lBloqueio})
	If Valtype( lCMA20Blq ) == "L"
		lBloqueio := lCMA20Blq
	EndIf
EndIf

RestArea(aAreaSA2)
RestArea(aAreaSB1)
RestArea(aArea)
Return({lBloqueio,nPQtde, nPPreco})

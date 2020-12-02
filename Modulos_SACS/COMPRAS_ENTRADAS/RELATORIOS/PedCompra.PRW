#INCLUDE "RWMAKE.CH"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPEDCOM    บAutor  ณCarlos R.Moreira    บ Data ณ  23/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEmite o Pedido de Compra                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PEDCOM()

Private cStartPath 	:= GetSrvProfString("Startpath","")
Private cPerg, aRegs := {}
cPerg := "PEDCOM" //+Space(4)
Private lPergunta := .T.

aAdd(aRegs,{cPerg,"01","Pedido  de        ?","","","mv_ch1","C"   ,06    ,00      ,0   ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Pedido  Ate       ?","","","mv_ch2","C"   ,06    ,00      ,0   ,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Fornecedor de     ?","","","mv_ch3","C"   ,06    ,00      ,0   ,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","FOR",""})
aAdd(aRegs,{cPerg,"04","Fornecedor Ate    ?","","","mv_ch4","C"   ,06    ,00      ,0   ,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","FOR",""})
aAdd(aRegs,{cPerg,"05","Emissao    de     ?","","","mv_ch5","D"   ,08    ,00      ,0   ,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Emissao    Ate    ?","","","mv_ch6","D"   ,08    ,00      ,0   ,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Envia por email   ?","","","mv_ch7","N"   ,01    ,00      ,1   ,"C","","mv_par07","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})

U_ValidPerg(cPerg, aRegs )

If Pergunte(cPerg,.T.)
	
	Processa({|| EmiPedido() }, "Emite Pedido de Compra")
	
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEmiPedido บAutor  ณCarlos R.Moreira    บ Data ณ  10/04/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEmite o Pedido                                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Glass                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EmiPedido()
Local oPrn
Private oFont, cCode
Private cStartPath 	:= GetSrvProfString("Startpath","")

nHeight:=15
lBold:= .T.
lUnderLine:= .F.
lPixel:= .T.
lPrint:=.F.

//Verifico se existe a Variavel de controle de Pergunta
If TYPE("LPERGUNTA") = "U"
	lPergunta := .F.
EndIf

If !lPergunta
	MV_PAR01 := SC7->C7_NUM
	MV_PAR02 := SC7->C7_NUM
	MV_PAR03 := SC7->C7_FORNECE
	MV_PAR04 := SC7->C7_FORNECE
	MV_PAR05 := SC7->C7_EMISSAO
	MV_PAR06 := SC7->C7_EMISSAO
	
	IF MsgYesNo("Envia Pedido por e-mail")
		MV_PAR07 := 1
	Else
		MV_PAR07 := 2
	EndIf
	
EndIf

oFont   :=  TFont():New( "Arial",,15,,.T.,,,,,.F. )
oFont3  :=  TFont():New( "Arial",,12,,.t.,,,,,.f. )
oFont12 :=  TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont5  :=  TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont9  :=  TFont():New( "Arial",, 8,,.T.,,,,,.f. )
oFont14 :=  TFont():New( "Arial",, 5,,.T.,,,,,.f. )

oFont1:= TFont():New( "Times New Roman",,28,,.t.,,,,,.t. )
oFont2:= TFont():New( "Times New Roman",,14,,.t.,,,,,.f. )
oFont4:= TFont():New( "Times New Roman",,20,,.t.,,,,,.f. )
oFont7:= TFont():New( "Times New Roman",,18,,.t.,,,,,.f. )
oFont11:=TFont():New( "Times New Roman",,10,,.t.,,,,,.t. )

oFont6:= TFont():New( "HAETTENSCHWEILLER",,10,,.t.,,,,,.f. )

oFont8:=  TFont():New( "Free 3 of 9",,44,,.t.,,,,,.f. )
oFont10:= TFont():New( "Free 3 of 9",,38,,.t.,,,,,.f. )
oFont13:= TFont():New( "Courier New",,10,,.t.,,,,,.f. )

oPrn := TMSPrinter():New()

oPrn:Setup()

lEmail := (MV_PAR07==1)

If lEmail
	
	If MV_PAR01 # MV_PAR02
		
		MsgStop("Para envio de e-mail deve ser utilizado somente um pedido..")
		lEmail := .F.
		
	EndIf
	
EndIf

If lEmail
	cJPEG := CriaTrab(,.F.)
EndIf

oPrn:SetLandscape()
oPrn:SetPaperSize(9)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEmite o cabecalho da Faturaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private nVlrAdt,cSimbo

DbSelectArea("SC7")
DbSetOrder(1)
DbSeek( xFilial("SC7")+mv_par01,.T.)

While SC7->(!Eof()) .And. SC7->C7_NUM <= MV_PAR02 .And. xFilial("SC7") == SC7->C7_FILIAL
	
	cPedido := SC7->C7_NUM
	
	lPedLib := .T.
	     
	nVlrFre    := 0
	nMoeda  := 1
	nRec    := SC7->(Recno())
	nTotPro := 0
	While SC7->(!Eof()) .And. 	cPedido == SC7->C7_NUM .And. xFilial("SC7") == SC7->C7_FILIAL //+SC7->C7_FORNECE
		
		If SC7->C7_EMISSAO < MV_PAR05 .Or. SC7->C7_EMISSAO >  MV_PAR06
			SC7->(DbSkip())
			Loop
		EndIf
		
		If  SC7->C7_FORNECE < MV_PAR03 .Or. SC7->C7_FORNECE > MV_PAR04
			SC7->(DbSkip())
			Loop
		EndIf
		
		If SC7->C7_CONAPRO # "L"
			lPedLib := .F.
		EndIf
		
		SB1->(DbSeek(xFilial("SB1")+SC7->C7_PRODUTO ))
		
		aDesc := {}
		If Len(Alltrim(SC7->C7_DESCRI)) > 60
			For nX := 1 to Len(Alltrim(SC7->C7_DESCRI)) Step(60)
				AaDd(aDesc,Substr(Alltrim(SC7->C7_DESCRI),nX,60))
			Next
		Else
			AaDd(aDesc,Alltrim(SC7->C7_DESCRI))
		EndIf
		
		If !Empty(SC7->C7_OBS)
			nTotPro++
		EndIf
		
		If len(aDesc) > 1
			nTotPro += ( Len(aDesc)  - 1 )
		EndIf
		
		nVlrFre    += SC7->C7_VALFRE 
   nMoeda := SC7->C7_MOEDA 
	    
		nTotPro++
		SC7->(DbSkip())
		
	End
	
	If nTotPro <=  0
		Loop
	EndIf
	
	lPri   := .T.
	nLin   := 781
	nItens := 1
	nPag   := 1
	cObs   := ""
	nVlrTotPed := 0
	nVlrDesp   := 0
	nVlrIPI    := 0
	nVlrDesc   := 0
	nTaxa      := 0
	nTotPag := Int(( nTotPro / 23 )) + 1
	
	SC7->(DbGoTo(nRec))
	
	// MaFisEnd()
	// MaFisIniPC(SC7->C7_NUM)
	
  lImprOutMoe := .F. 
	If SC7->C7_OUTMOE > 1

	   If MsgYesNo("Imprime pedido com valores de outras Moedas")

       lImprOutMoe := .T. 
        
	   EndIf 

	EndIf 

	cLiber   := If( SC7->C7_CONAPRO == "L","Pedido Liberado","Pedido Bloqueado")
	cOutMoe  := SC7->C7_OUTMOE 
	nTaxa    := 0
	dEmissao := SC7->C7_EMISSAO
	cQuarter := "" //SC7->C7_ANOINV
	nVlrAdt  := 0
	cOrder   := "" //SC7->C7_ORDER
	cFilEnt  := SC7->C7_LOC_ENT
	cLocEnt  := SC7->C7_CC
	cLocEntEsp := SC7->C7_ENDENT
	cCondGer   := SC7->C7_OBSPED
	
	SE4->(DbSeek(xFilial("SE4")+SC7->C7_COND ))
	
	cCondPagto  := SC7->C7_COND+" - "+SE4->E4_DESCRI
	cCompPed    :=  Alltrim(UsrFullName(SC7->C7_USER))
	
	cAprov :=  ""
	
	//Pega o aprovador do Pedido de Compra
	SCR->(DbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM ))
	lPriAprov := .T.
	
	While SCR->(!Eof()) .And. Alltrim(SCR->CR_NUM) == SC7->C7_NUM .And. xFilial("SC7") == SC7->C7_FILIAL
		
		If SCR->CR_STATUS == "03"
			If lPriAprov
				cAprov := Alltrim(UsrFullName(SCR->CR_USER))
				lPriAprov := .F.
			Else
				cAprov += " / "+Alltrim(UsrFullName(SCR->CR_USER))
			EndIf
		EndIf
		
		SCR->(DbSkip())
		
	End
	
	While SC7->(!Eof()) .And. cPedido == SC7->C7_NUM //+SC7->C7_FORNECE
		
		If SC7->C7_EMISSAO < MV_PAR05 .Or. SC7->C7_EMISSAO >  MV_PAR06
			SC7->(DbSkip())
			Loop
		EndIf
		
		If  SC7->C7_FORNECE < MV_PAR03 .Or. SC7->C7_FORNECE > MV_PAR04
			SC7->(DbSkip())
			Loop
		EndIf
		
		If lPri
			
			oPrn:StartPage()
			U_CabPed(oPrn)
			lPri := .F.
			
			nLin := 530
			
			oPrn:Box(  nLin ,  100,  nLin + 80, 3300 )
			
			ImpCol(1,oPrn)
			
			oPrn:Say(  nLin +10, 110, "Item",oFont9 ,100)
			
			oPrn:Say(  nLin +10, 250 , "C๓digo",oFont9 ,100)
			
			oPrn:Say(  nLin +10, 420, "Descri็ใo",oFont9 ,100)
			
			oPrn:Say(  nLin +10, 1410, "Item "  ,oFont9 ,100)
			oPrn:Say(  nLin +40, 1410, "Critico",oFont9 ,100)
			
			
			oPrn:Say(  nLin +10, 1510, "CA",oFont9 ,100)
			oPrn:Say(  nLin +40, 1510, "(Siyo)",oFont9 ,100)
			
			oPrn:Say(  nLin +10, 1610, "FISQP",oFont9 ,100)
			
			
			oPrn:Say(  nLin +10, 1710, "Cert.",oFont9 ,100)
			oPrn:Say(  nLin +40, 1710, "C.Q.",oFont9 ,100)
			
			
			
			oPrn:Say(  nLin +20, 1820, "UM",oFont9 ,100)
			
			
			oPrn:Say(  nLin +10, 1980, "Qtde",oFont9 ,100)
			
			
			oPrn:Say(  nLin +10, 2250, "Pre็o",oFont9 ,100)
			oPrn:Say(  nLin +10, 2560, "Total",oFont9 ,100)
			
			oPrn:Say(  nLin +10, 2840, "IPI",oFont9 ,100)
			oPrn:Say(  nLin +10, 2910, "ICMS",oFont9 ,100)
			
			oPrn:Say(  nLin +10, 3000, "Data de",oFont9 ,100)
			oPrn:Say(  nLin +40, 3000, "Entrega",oFont9 ,100)
			
			oPrn:Say(  nLin +40, 3160, "C.C.",oFont9 ,100)
			
			nLin += 80
			
		EndIf
		
		aDesc := {}
		If Len(Alltrim(SC7->C7_DESCRI)) > 60
			For nX := 1 to Len(Alltrim(SC7->C7_DESCRI)) Step(60)
				AaDd(aDesc,Substr(Alltrim(SC7->C7_DESCRI),nX,60)) //If(nX==1,nX,((nX-1)*60)+1)
			Next
		Else
			AaDd(aDesc,Alltrim(SC7->C7_DESCRI))
		EndIf
		
		If Len(aDesc) > 1
			
			nDet := Int(Len(aDesc)/2)
			oPrn:Line(  nLin,  100, nLin, 3300 )
			
			For nX := 1 to Len(aDesc)
				
				ImpCol(2,oPrn)
				
				SC1->(DbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC ))
				
				SB1->(DbSeek(xFilial("SB1")+SC7->C7_PRODUTO ))
				
				If nX == nDet
					oPrn:Say( nLin+15,  110, SC7->C7_ITEM    ,oFont9,100)
					oPrn:Say( nLin+15,  190, SC7->C7_PRODUTO ,oFont9,100)
					
					oPrn:Say( nLin+15,  410, aDesc[nX] ,oFont9,100)
					
					oPrn:Say( nLin+15, 1420, If(SB1->B1_ITCRIT=="S","Sim","Nao") ,oFont9,100)
					
					oPrn:Say( nLin+15, 1520, If(SB1->B1_REQ1=="S","Sim","Nao") ,oFont9,100)
					
					oPrn:Say( nLin+15, 1620, If(SB1->B1_REQ2=="S","Sim","Nao") ,oFont9,100)
					
					oPrn:Say( nLin+15, 1720, If(SB1->B1_REQ3=="S","Sim","Nao") ,oFont9,100)
					
					oPrn:Say( nLin+15, 1820, SB1->B1_UM ,oFont9,100)
					
					oPrn:Say( nLin+15, 2000, Transform(SC7->C7_QUANT,"@e 999,999.999") ,oFont9,100)
					
					If lImprOutMoe

					   oPrn:Say( nLin+15, 2340, Transform(SC7->C7_UNOUTMO,"@e 999,999,999.99") ,oFont9,100)
					   oPrn:Say( nLin+15, 2520, Transform(SC7->C7_VLOUTMO,"@e 999,999,999.99") ,oFont9,100)
					
					Else

					   oPrn:Say( nLin+15, 2340, Transform(SC7->C7_PRECO,"@e 999,999,999.99") ,oFont9,100)
					   oPrn:Say( nLin+15, 2520, Transform(SC7->C7_TOTAL,"@e 999,999,999.99") ,oFont9,100)

					EndIf 
					oPrn:Say( nLin+15, 2820, Transform(SC7->C7_IPI,"@e 99") ,oFont9,100)
					oPrn:Say( nLin+15, 2920, Transform(SC7->C7_PICM,"@e 999") ,oFont9,100)
					oPrn:Say( nLin+15, 3000, Dtoc(SC7->C7_DATPRF) ,oFont9,100)
					oPrn:Say( nLin+15, 3180, SC7->C7_CC ,oFont9,100)
				Else
					oPrn:Say( nLin+15,  410, aDesc[nX] ,oFont9,100)
				EndIf
				nItens++
				nLin += 60
			Next
			oPrn:Line(  nLin,  100, nLin, 3300 )
			
		Else
			
			oPrn:Box(  nLin,  100, nLin+60, 3300 )
			
			ImpCol(2,oPrn)
			
			SC1->(DbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC ))
			
			SB1->(DbSeek(xFilial("SB1")+SC7->C7_PRODUTO ))
			
			oPrn:Say( nLin+15,  110, SC7->C7_ITEM    ,oFont9,100)
			oPrn:Say( nLin+15,  190, SC7->C7_PRODUTO ,oFont9,100)
			
			oPrn:Say( nLin+15,  410, aDesc[1] ,oFont9,100)
			
			oPrn:Say( nLin+15, 1420, If(SB1->B1_ITCRIT=="S","Sim","Nao") ,oFont9,100)
			
			oPrn:Say( nLin+15, 1520, If(SB1->B1_REQ1=="S","Sim","Nao") ,oFont9,100)
			
			oPrn:Say( nLin+15, 1620, If(SB1->B1_REQ2=="S","Sim","Nao") ,oFont9,100)
			
			oPrn:Say( nLin+15, 1720, If(SB1->B1_REQ3=="S","Sim","Nao") ,oFont9,100)
			
			oPrn:Say( nLin+15, 1840, SB1->B1_UM ,oFont9,100)
			
			oPrn:Say( nLin+15, 2000, Transform(SC7->C7_QUANT,"@e 999,999.999") ,oFont9,100)
			
					If lImprOutMoe

					   oPrn:Say( nLin+15, 2340, Transform(SC7->C7_UNOUTMO,"@e 999,999,999.99") ,oFont9,100)
					   oPrn:Say( nLin+15, 2520, Transform(SC7->C7_VLOUTMO,"@e 999,999,999.99") ,oFont9,100)
					
					Else

					   oPrn:Say( nLin+15, 2340, Transform(SC7->C7_PRECO,"@e 999,999,999.99") ,oFont9,100)
					   oPrn:Say( nLin+15, 2520, Transform(SC7->C7_TOTAL,"@e 999,999,999.99") ,oFont9,100)

					EndIf 
			
			oPrn:Say( nLin+15, 2820, Transform(SC7->C7_IPI,"@e 99") ,oFont9,100)
			oPrn:Say( nLin+15, 2920, Transform(SC7->C7_PICM,"@e 999") ,oFont9,100)
			oPrn:Say( nLin+15, 3000, Dtoc(SC7->C7_DATPRF) ,oFont9,100)
			oPrn:Say( nLin+15, 3180, SC7->C7_CC  ,oFont9,100)
			
		EndIf
		
		nVlrTotPed += If(lImprOutMoe,SC7->C7_VLOUTMO,SC7->C7_TOTAL)
		nVlrDesp   += SC7->C7_DESPESA
		nVlrDesc   += SC7->C7_VLDESC
		nVlrIPI    += If(lImprOutMoe,SC7->C7_VLOUTMO,SC7->C7_TOTAL) * ( SC7->C7_IPI / 100 )
		
		If !Empty(SC7->C7_OBS)
			nLin += 60
			nItens++
			oPrn:Box(  nLin,  100,nLin+60,3300 )
			oPrn:Say( nLin+15,  120, "Obs : "+SC7->C7_OBS ,oFont9,100)
			
		EndIf
		
		nLin += 60
		nItens++
		
		If nItens > 19
			
			nLin   := 781
			nItens := 1
			lPri := .T.
			oPrn:EndPage()
			oPrn:StartPage()
			
		EndIf
		
		SC7->(DbSkip())
		
	End
	
	FecPed(oPrn)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณImprime o rodape do Pedido ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	
	If nItens <= 23
		
		U_RodPed(oPrn)
		
		oPrn:EndPage()
		
	EndIf
	
	
End

oPrn:Preview()

If lEmail .and. !Empty(cJPEG)
	oPrn:SaveAllAsJPEG(cStartPath+cJPEG,1270,870,140)
EndIf

oPrn:End()

If lEmail .and. !Empty(cJPEG)
	If lPedLib
		U_QNCXRMAIL({{cStartPath,cJPEG,"Pedido de Compra"}})
	Else
		nOpc := Aviso("Atencao","Pedido de Compra encontra-se bloqueado nao sera enviado para o Fornecedor...",{"Enviar","Cancelar"} )
		If nOpc == 1
			U_QNCXRMAIL({{cStartPath,cJPEG,"Pedido de Compra"}})
		EndIf
	EndIf
EndIF

If lEmail
	//	Deleta arquivos JPEG gerados pelos relatorios.
	FErase( cStartPath+cJPEG )
EndIf

oPrn:End()

MS_FLUSH()

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabPed    บAutor  ณCarlos R. Moreira   บ Data ณ  29/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCabecalho do Pedido de Compra                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Escola Graduada                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CabPed(oPrn)
Local cAnoIni

//cBitMap:= "novologo.bmp"
cDir    := GetSrvProfString("StartPath","")
cBitMap :=  FisxLogo("1")
cNomEscola := SM0->M0_NOMECOM
cNomIng    := ""
cEndEscola := Alltrim(SM0->M0_ENDCOB)+"-"+Alltrim(SM0->M0_CIDCOB)+"-"+SM0->M0_ESTCOB+"-"+Transform(SM0->M0_CEPCOB,"@R 99999-999")  //"Av. Pres. Giovanni Gronchi, 4710 CEP 05724-002, Sใo Paulo, SP - Brazil"
cTelFax    := "Telefone: " //5511-3747-4901 Fax: 5511-3744-8771"
cCaiPost   := "" //Mailing address: Caixa Postal 1976 CEP 01059-970, Sใo Paulo, SP"
cHome      := "www.sacseng.com.br"
cComprador := "Empresa"

cPagina    := "Data : "+Dtoc(dDataBase)+" Pag.: "+Strzero(nPag++,3)+"/"+StrZero(nTotPag,3)
cSoliPor   := "Favor aceitar este pedido e confirmar entrega."
cSoliIng   := "Pls accept this as our order confirmation for the following items : "
cNote      := "Note: WE do not accept Backorders."
cCNPJ      :=  Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+ "   -    Insc. Estadual : "+SM0->M0_INSC

cNumPed    := "Pedido de Compra : "+SC7->C7_NUM

SA2->(DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA ))

cNomFor  := SA2->A2_NOME
cEndFor  := SA2->A2_END
cBaiFor  := SA2->A2_BAIRRO
cMunFor  := SA2->A2_MUN
cCepFor  := Transform(SA2->A2_CEP,"@R 99999-999")
cTelFor  := SA2->A2_TEL
cFaxFor  := SA2->A2_FAX
cCNPJFor := Transform(SA2->A2_CGC,"@R 99.999.999/9999-99")
cCodFor  := SA2->A2_COD

oPrn:Box( 050, 100, 420,3300 )

oPrn:Line( 050, 500, 420, 500 )
oPrn:Line( 050, 1900, 420,1900 )

oPrn:SayBitmap( 140,120,cBitMap,300,230 )

oPrn:Say(  60,  530, cComprador,oFont12,100 )
oPrn:Say( 125,  530, cNomEscola,oFont3,100 )
//oPrn:Say( 185,  530, cNomIng   ,oFont3,100 )
oPrn:Say( 185,  530, cEndEscola,oFont9,100 )
oPrn:Say( 255,  530, cTelFax   ,oFont5,100 )
oPrn:Say( 295,  530, cCaiPost  ,oFont5,100 )
oPrn:Say( 335,  530, cHome     ,oFont5,100 )
oPrn:Say( 375,  530, "CNPJ : "+cCNPJ ,oFont12,100 )

//Dados do Fornecedor
oPrn:Say(  60, 1920, "Dados do Fornecedor" ,oFont12,100 )
oPrn:Say( 115, 1920, cNomFor   ,oFont3,100 )
oPrn:Say( 165, 1920, cCodFor   ,oFont3,100 )
oPrn:Say( 215, 1920, cEndFor+" - "+cBaiFor   ,oFont5,100 )
oPrn:Say( 255, 1920, cMunFor   ,oFont5,100 )
oPrn:Say( 295, 1920, cCepFor  ,oFont5,100 )
oPrn:Say( 335, 1920, cTelFor+" - "+cFaxFor ,oFont5,100 )
oPrn:Say( 375, 1920, "CNPJ : "+cCNPJFor ,oFont12,100 )
oPrn:Say( 375,  2620, cPagina   ,oFont12,100 )

//oPrn:Say( 540, 110, cSoliPor   ,oFont3,100)
//oPrn:Say( 580, 110, cSoliIng   ,oFont3,100)
//oPrn:Say( 620, 110, cNote      ,oFont3,100)

oPrn:Box( 430, 100, 510, 1000 )
oPrn:Say( 445, 120, "Emissao : "+Dtoc(SC7->C7_EMISSAO) ,oFont ,100 )

oPrn:Box( 430, 2450, 510,3300 )
oPrn:Say( 445, 2550, cNumPed,oFont ,100 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRODPED    บAutor  ณCarlos R. Moreira   บ Data ณ  29/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEmite o Rodape do Pedido de Compra                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Escola Graduada                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RodPed(oPrn)

cMensPor1 := ""
cMensPor2 := ""
cMensPor3 := ""

cMensIng1 := ""

If cFilEnt == "M"
	cMensIng2 := "Local de Entrega : "+Alltrim(SM0->M0_ENDCOB)+" - "+Alltrim(SM0->M0_CIDCOB)+" - "+SM0->M0_ESTCOB+" - "+Transform(SM0->M0_CEPCOB,"@R 99999-999")
Else
	
	If !Empty(cLocEntEsp)
		
		cMensIng2 := "Local de Entrega: "+cLocEntEsp
	Else
		
		DbSelectArea("CTT")
		DbSetOrder(1)
		DbSeek(xFilial("CTT")+cLocEnt )
		
		cMensIng2 := "Local de Entrega: "+Alltrim(CTT->CTT_ENDER)+" - "+Alltrim(CTT->CTT_BAIRRO)+" - "+Alltrim(CTT->CTT_MUNIC)+" - "+CTT->CTT_ESTADO+" - "+Transform(CTT->CTT_CEP,"@R 99999-999")
	EndIf
	
EndIf

cMensIng3 := '"A nota fiscal deverแ mencionar necessariamente nosso numero de pedido" '

oPrn:Box( 2100, 100, 2250,3300)
oPrn:Line( 2180, 100, 2180,3300)
oPrn:Line( 2180, 1650, 2250,1650)

oPrn:Say( 2110,  110, cMensPor1  ,oFont12,100)
oPrn:Say( 2150,  110, cMensPor2  ,oFont12,100)
oPrn:Say( 2190,  110, cMensPor3  ,oFont12,100)
oPrn:Say( 2110, 1415, cMensIng1  ,oFont12,100)
oPrn:Say( 2125,  110, cMensIng2  ,oFont12,100)
oPrn:Say( 2190, 110, "Nota : "+cMensIng3  ,oFont12,100)
oPrn:Say( 2190, 1660, "Cons.Gerais : "+cCondGer  ,oFont12,100)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFecPed    บAutor  ณCarlos R.Moreira    บ Data ณ  02/12/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaz o Fechamento do Pedido de Compra                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Escola Graduada                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FecPed(oPrn)
 
If cOutMoe > 1 .And. lImprOutMoe  
	cSimBo := GetMV("MV_SIMB"+STR(cOutMoe,1))
Else
	cSimbo := "R$"
EndIf


oPrn:Box( 1880,  100, 1960,3300)
oPrn:Line( 1880, 700, 1960, 700)
oPrn:Line( 1880, 1200, 1960,1200)
oPrn:Line( 1880, 1500, 1960,1500)
oPrn:Line( 1880, 2000, 1960,2000)
oPrn:Line( 1880, 2650, 1960,2650)

oPrn:Say( 1900, 110, "Total Pedido :  "+cSimbo+" "+Transform(nVlrTotPed,"@e 999,999,999,999.99"),oFont12,100)

oPrn:Say( 1900, 710, "Despesas: "+Transform(nVlrDesp,"@e 999,999,999.99"),oFont12,100)
oPrn:Say( 1900,1210, "Frete: "+Transform(nVlrFre,"@e 999,999,999.99"),oFont12,100)

oPrn:Say( 1900, 1530, "IPI :   "+Transform(nVlrIPI,"@e 999,999,999,999.99"),oFont12,100)
oPrn:Say( 1900, 2010, "Desconto:  "+Transform(nVlrDesc,"@e 999,999,999,999.99"),oFont12,100)

nVlrLiqPed := nVlrTotPed + nVlrFre + nVlrIPI +nVlrDesp - nVlrDesc
oPrn:Say( 1900, 2660, "Total :  "+cSimbo+" "+Transform(nVlrLiqPed,"@e 999,999,999,999.99"),oFont12,100)

oPrn:Box( 1960, 100, 2030,3300)

oPrn:Say( 1980, 120, "Condi็ใo de Pagamento :  "+cCondPagto  ,oFont12,100)

oPrn:Line(1960,1910,2030,1910)

oPrn:Say( 1980,1930, "Comprador  :  "+cCompPed ,oFont12,100)

oPrn:Box( 2030, 100, 2100,3300)

If !Empty( cAprov )
	oPrn:Say( 2040,  120, cLiber ,oFont12,100)
	oPrn:Box( 2030, 1410, 2100,1411)
	oPrn:Say( 2040,  1415, "  Aprovadores : "+cAprov ,oFont12,100)
Else
	oPrn:Say( 2040,  110, cLiber ,oFont12,100)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpcol    บAutor  ณCarlos R. Moreira   บ Data ณ  29/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImprime as Colunas dos detalhes                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpCol(nTipo,oPrn)
Local nMais := If(nTipo==1,80,60)

oPrn:Line( nLin,  100, nLin+nMais, 100 )
oPrn:Line( nLin,  180, nLin+nMais, 180 )
oPrn:Line( nLin,  400, nLin+nMais, 400 )
//oPrn:Line( nLin, 1100, nLin+nMais,1100 )
//oPrn:Line( nLin, 1150, nLin+nMais,1150 )
//oPrn:Line( nLin, 1600, nLin+nMais,1200 )
oPrn:Line( nLin, 1400, nLin+nMais,1400 )
oPrn:Line( nLin, 1500, nLin+nMais,1500 )
oPrn:Line( nLin, 1600, nLin+nMais,1600 )
oPrn:Line( nLin, 1700, nLin+nMais,1700 )
oPrn:Line( nLin, 1800, nLin+nMais,1800 )
oPrn:Line( nLin, 1900, nLin+nMais,1900 )
oPrn:Line( nLin, 2200, nLin+nMais,2200 )
//oPrn:Line( nLin, 2300, nLin+nMais,2300 )
oPrn:Line( nLin, 2500, nLin+nMais,2500 )
oPrn:Line( nLin, 2800, nLin+nMais,2800 )
oPrn:Line( nLin, 2900, nLin+nMais,2900 )
oPrn:Line( nLin, 2980, nLin+nMais,2980 )
oPrn:Line( nLin, 3150, nLin+nMais,3150 )
oPrn:Line( nLin, 3300, nLin+nMais,3300 )

Return

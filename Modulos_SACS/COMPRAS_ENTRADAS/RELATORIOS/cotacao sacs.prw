#INCLUDE "RWMAKE.CH"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEGC018    บAutor  ณCarlos R.Moreira    บ Data ณ  28/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEmite a C	otacao para os fornecedores                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Escola Graduada                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function COTACAO()

	Private cStartPath 	:= GetSrvProfString("Startpath","")
	Private cPerg, aRegs := {}
	Private lPergunta := .T.

	Private cPerg
	cPerg := "COTACAO"

	aAdd(aRegs,{cPerg,"01","Cotacao de        ?","","","mv_ch1","C"   ,06    ,00      ,0   ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Cotacao  Ate      ?","","","mv_ch2","C"   ,06    ,00      ,0   ,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Fornecedor de     ?","","","mv_ch3","C"   ,06    ,00      ,0   ,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","FOR",""})
	aAdd(aRegs,{cPerg,"04","Fornecedor Ate    ?","","","mv_ch4","C"   ,06    ,00      ,0   ,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","FOR",""})
	aAdd(aRegs,{cPerg,"05","Somente em aberto ?","","","mv_ch5","N"   ,01    ,00      ,1   ,"C","","mv_par05","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Emissao de        ?","","","mv_ch6","D"   ,08    ,00      ,0   ,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","Emissao Ate       ?","","","mv_ch7","D"   ,08    ,00      ,0   ,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})

//	U_ValidPerg(cPerg, aRegs )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                         ณ
//ณ mv_par01     // Produto de                                   ณ
//ณ mv_par02     // Produto ate                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


	If Pergunte(cPerg,.T.)
	
		Processa({|| EmiCotacao() }, "Cotacao do Fornecedor")

	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEmiCotacaoบAutor  ณCarlos R.Moreira    บ Data ณ  10/04/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEmite a Cotacao                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Escola Graduada                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EmiCotacao()
	Local oPrn
	Private oFont, cCode
	nHeight:=15
	lBold:= .T.
	lUnderLine:= .F.
	lPixel:= .T.
	lPrint:=.F.

	oFont  :=  TFont():New( "Arial",,15,,.T.,,,,,.F. )
	oFont3 :=  TFont():New( "Arial",,12,,.t.,,,,,.f. )
	oFont12:=  TFont():New( "Arial",,10,,.t.,,,,,.f. )
	oFont5 :=  TFont():New( "Arial",,10,,.f.,,,,,.f. )
	oFont9 :=  TFont():New( "Arial",, 8,,.T.,,,,,.f. )
	oFont14 :=  TFont():New( "Arial",, 5,,.T.,,,,,.f. )

	oFont1:= TFont():New( "Times New Roman",,28,,.t.,,,,,.t. )
	oFont2:= TFont():New( "Times New Roman",,14,,.t.,,,,,.f. )
	oFont4:= TFont():New( "Times New Roman",,26,,.t.,,,,,.f. )
	oFont7:= TFont():New( "Times New Roman",,18,,.t.,,,,,.f. )
	oFont11:=TFont():New( "Times New Roman",,10,,.t.,,,,,.t. )

	oFont6:= TFont():New( "HAETTENSCHWEILLER",,10,,.t.,,,,,.f. )

	oFont8:=  TFont():New( "Free 3 of 9",,44,,.t.,,,,,.f. )
	oFont10:= TFont():New( "Free 3 of 9",,38,,.t.,,,,,.f. )
	oFont13:= TFont():New( "Courier New",,10,,.t.,,,,,.f. )

  oBrush  := TBrush():New(,CLR_HGRAY,,)
  oBrush1 := TBrush():New(,CLR_BLUE,,)
  oBrush2 := TBrush():New(,CLR_WHITE,,)

cObs := " "
cSolicit := " " 

	oPrn := TMSPrinter():New()
 oPrn:SetLandscape()  //SetPortrait()
//oPrn:StartPage()

	DbSelectArea("SC8")
	DbSetOrder(1)
	DbSeek( xFilial("SC8")+mv_par01,.t.)

	While SC8->(!Eof()) .And. SC8->C8_NUM <= MV_PAR02
	
		cCotacao := SC8->C8_NUM+SC8->C8_FORNECE

		nRec    := SC8->(Recno())
		nTotPro := 0
		While SC8->(!Eof()) .And. 	cCotacao == SC8->C8_NUM+SC8->C8_FORNECE

			If  SC8->C8_FORNECE < MV_PAR03 .Or. SC8->C8_FORNECE > MV_PAR04
				SC8->(DbSkip())
				Loop
			EndIf
        
			If SC8->C8_EMISSAO  < MV_PAR06 .Or. SC8->C8_EMISSAO > MV_PAR07
				SC8->(DbSkip())
				Loop
			EndIf
       
			If Mv_par05 == 1
				If !Empty(SC8->C8_NUMPED)
					SC8->(DbSkip())
					Loop
				EndIf
			EndIf
			nTotPro++
			SC8->(DbSkip())
       
		End
    
		If nTotPro == 0
			Loop
		EndIf
    
		lPri   := .T.
		nLin   := 781
		nItens := 1
		nPag   := 1
		nTotPag := Int(( nTotPro / 16 )) + 1
    
		SC8->(DbGoTo(nRec))
    
		While SC8->(!Eof()) .And. 	cCotacao == SC8->C8_NUM+SC8->C8_FORNECE

			If  SC8->C8_FORNECE < MV_PAR03 .Or. SC8->C8_FORNECE > MV_PAR04
				SC8->(DbSkip())
				Loop
			EndIf
           
			If SC8->C8_EMISSAO  < MV_PAR06 .Or. SC8->C8_EMISSAO > MV_PAR07
				SC8->(DbSkip())
				Loop
			EndIf

			If Mv_par05 == 1
				If !Empty(SC8->C8_NUMPED)
					SC8->(DbSkip())
					Loop
				EndIf
			EndIf

			If lPri
	      
				oPrn:StartPage()
				U_CabCot(oPrn)
				
				lPri := .F.
				oPrn:Box(  700,  100,  780, 3300 )
				oPrn:Line( 700,  200,  780, 200)
				oPrn:Line( 700,  500,  780, 500 )
				oPrn:Line( 700, 1600,  780,1600 )
				oPrn:Line( 700, 1750,  780,1750 )
				oPrn:Line( 700, 1800,  780,1800 )
				oPrn:Line( 700, 2100,  780,2100 )
				oPrn:Line( 700, 2300,  780,2300 )				
				oPrn:Line( 700, 2550,  780,2550 )				
				oPrn:Line( 700, 2800,  780,2800 )
				oPrn:Line( 700, 3050,  780,3050 )
					      	      	      	
				oPrn:Say(  710, 110, "Item",oFont3 ,100)
	
				oPrn:Say(  710, 210 , "C๓digo",oFont3 ,100)
	
				oPrn:Say(  710, 515, "Descri็ใo",oFont3 ,100)

				oPrn:Say(  710, 1615, "Entrega.",oFont9 ,100)
	      
				oPrn:Say(  710, 1755, "UM",oFont9 ,100)
				
				oPrn:Say(  710, 1855, "Qtde",oFont3 ,100)
				
				oPrn:Say(  710, 2110, "Vlr Unit",oFont3 ,100)
				
				oPrn:Say(  710, 2310, "Vlr Total",oFont3 ,100)
				
				oPrn:Say(  710, 2560, "Vlr IPI",oFont3 ,100)
												
				oPrn:Say(  710, 2810, "ICMS ST.",oFont3 ,100)

				oPrn:Say(  710, 3060, "Total c/ Imp",oFont3 ,100)

       nLin := 780
       	
			EndIf
		
				oPrn:Box(  nLin,  100,  nLin + 60 , 3300 )

				oPrn:Line( 700,  200,  780, 200)
				oPrn:Line( 700,  500,  780, 500 )
				oPrn:Line( 700, 1600,  780,1600 )
				oPrn:Line( 700, 1750,  780,1750 )
				oPrn:Line( 700, 1800,  780,1800 )
				oPrn:Line( 700, 2100,  780,2100 )
				oPrn:Line( 700, 2300,  780,2300 )				
				oPrn:Line( 700, 2550,  780,2550 )				
				oPrn:Line( 700, 2800,  780,2800 )
				oPrn:Line( 700, 3050,  780,3050 )

				oPrn:Line( nLin ,  200,  nLin + 60, 200)
				oPrn:Line( nLin ,  500,  nLin + 60, 500 )
				oPrn:Line( nLin , 1600,  nLin + 60,1600 )				
				oPrn:Line( nLin , 1750,  nLin + 60,1750 )
				oPrn:Line( nLin , 1800,  nLin + 60,1800 )
				oPrn:Line( nLin , 2100,  nLin + 60,2100 )
				oPrn:Line( nLin , 2300,  nLin + 60,2300 )			
				oPrn:Line( nLin , 2550,  nLin + 60,2550 )					
				oPrn:Line( nLin , 2800,  nLin + 60,2800 )
				oPrn:Line( nLin , 3050,  nLin + 60,3050 )
				
			SC1->(DbSeek(xFilial("SC1")+SC8->C8_NUMSC+SC8->C8_ITEMSC ))
         
			SB1->(DbSeek(xFilial("SB1")+SC8->C8_PRODUTO ))

			oPrn:Say( nLin+10,  120, SC8->C8_ITEM    ,oFont12,100)
			oPrn:Say( nLin+10,  210, SC8->C8_PRODUTO ,oFont9,100)
			oPrn:Say( nLin+10,  510, SC1->C1_DESCRI ,oFont9,100)
			oPrn:Say( nLin+10, 1610, Dtoc(SC8->C8_DATPRF) ,oFont9,100)
			oPrn:Say( nLin+10, 1755, SB1->B1_UM ,oFont9,100)
			oPrn:Say( nLin+10, 1850, Transform(SC8->C8_QUANT,"@e 999,999,999.99") ,oFont12,100)

			//oPrn:Say( nLin+10, 2105, Substr(SC8->C8_OBS,1,50) ,oFont14,100)
			//oPrn:Say( nLin+10, 2930, SC1->C1_SOLICIT,oFont9,100)
		
    cSolicit := SC1->C1_SOLICIT 
    cObs     := SC8->C8_OBS  
			nLin += 60

			nItens++
		
			If nItens > 16

				U_RodCot(oPrn)
           
				nLin   := 781
				nItens := 1
				lPri := .T.
				oPrn:EndPage()
				oPrn:StartPage()
		
			EndIf
		
			SC8->(DbSkip())
		
		End
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณImprime o rodape da Cartaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	
		If nItens <= 16
	
			U_RodCot(oPrn)
	
			oPrn:EndPage()
	   
		EndIf


	
	End

	oPrn:Preview()
	oPrn:End()

	MS_FLUSH()

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabCot    บAutor  ณCarlos R. Moreira   บ Data ณ  29/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCabecalho da Cotacao                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Escola Graduada                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CabCot(oPrn)

	cDir    := GetSrvProfString("StartPath","")
	cBitMap :=  FisxLogo("1")

	cNomEscola := SM0->M0_NOMECOM
	cNomIng    := ""
	cEndEscola := Alltrim(SM0->M0_ENDCOB)+"-"+Alltrim(SM0->M0_CIDCOB)+"-"+SM0->M0_ESTCOB+"-"+Transform(SM0->M0_CEPCOB,"@R 99999-999")  //"Av. Pres. Giovanni Gronchi, 4710 CEP 05724-002, Sใo Paulo, SP - Brazil"
	cTelFax    := "Telefone:  " //5511-3747-4901 Fax: 5511-3744-8771"
	cCaiPost   := "" //Mailing address: Caixa Postal 1976 CEP 01059-970, Sใo Paulo, SP"
	cHome      := "www.sacsengenharia.com.br"

	cComprador := "Comprador"

	cPagina    := "Data : "+Dtoc(dDataBase)+" Pag.: "+Strzero(nPag++,3)+"/"+StrZero(nTotPag,3)
	cSoliPor   := "Solicitamos a V.Sa. Cotar seu melhor pre็o e prazo de entrega para os Seguintes produtos : "

	cNumCot    := "Cota็ใo : "+SC8->C8_NUM
 
	SA2->(DbSeek(xFilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA ))

	cNomFor := SA2->A2_NOME
	cEndFor := SA2->A2_END
	cBaiFor := SA2->A2_BAIRRO
	cMunFor := SA2->A2_MUN
	cCepFor := Transform(SA2->A2_CEP,"@R 99999-999")
	cTelFor := "Telefone: ("+SA2->A2_DDD+") "+SA2->A2_TEL
	cFaxFor := SA2->A2_FAX
	cCodFor := "Codigo: "+SA2->A2_COD+" N.Fantasia: "+SA2->A2_NREDUZ 

	oPrn:Box( 050, 100, 500,500 )
	oPrn:SayBitmap( 100,150,cBitMap,300,300 )
	oPrn:Box( 050, 501, 500,1700 )
//Dados do Fornecedor
//oPrn:Say(  60,  820, cComprador,oFont,100 )
	oPrn:Say(  95,  530, cNomFor   ,oFont3,100 )
	oPrn:Say( 165,  530, cCodFor   ,oFont5,100 )
	oPrn:Say( 235,  530, cEndFor   ,oFont5,100 )
	oPrn:Say( 275,  530, cMunFor   ,oFont5,100 )
	oPrn:Say( 315,  530, cCepFor  ,oFont5,100 )
	oPrn:Say( 355,  530, cTelFor+" - "+cFaxFor ,oFont5,100 )

	oPrn:Box( 050, 1701, 500,3300 )
	oPrn:Say(  60, 1720, cComprador,oFont3,100 )
	oPrn:Say( 125, 1720, cNomEscola,oFont,100 )
	oPrn:Say( 185, 1720, cNomIng   ,oFont3,100 )
	oPrn:Say( 255, 1720, cEndEscola,oFont5,100 )
	oPrn:Say( 295, 1720, cTelFax   ,oFont5,100 )
	oPrn:Say( 335, 1720, cCaiPost  ,oFont5,100 )
	oPrn:Say( 375, 1720, cHome     ,oFont5,100 )
	oPrn:Say( 435, 2500, cPagina   ,oFont12,100 )

	oPrn:Say( 550, 110, cSoliPor   ,oFont3,100)

  oPrn:FillRect({550,2120,680,3300},oBrush)
	oPrn:Box( 550, 2120, 680,3300 )
	oPrn:Say( 570, 2430, cNumCot,oFont4 ,100 )

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRODCOT    บAutor  ณCarlos R. Moreira   บ Data ณ  29/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEmite o Rodape da Cotacao                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Escola Graduada                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RodCot(oPrn)

	cMensPor1 := "Favor nใo esquecer de mencionar em sua cota็ใo nossa refer๊ncia,condi็๕es de pagto e entrega."

//cMensIng1 := "Please do not forget to mention our reference, delivery"
//cMensIng2 := "and payment condition in your quotation. Shipping instructions will be sent after order approval. "

  oPrn:Box( 2100, 100, 2300,3300)
  
  oPrn:Line( 2100, 2800, 2200,2800)
  oPrn:Line( 2100, 2000, 2200,2000)
    
	oPrn:Line( 2200, 100, 2200,3300)
//oPrn:Box( 2100, 1410, 2250,1411) 

	oPrn:Say( 2140,  110, "Observacao : "+cObs ,oFont12,100)
	oPrn:Say( 2140,  2010, "Desconto pagamento a Vista : " ,oFont12,100)	
	oPrn:Say( 2140,  2810, "Solicitante : "+cSolicit ,oFont12,100)
	oPrn:Say( 2240,  110, cMensPor1  ,oFont3,100)
//	oPrn:Say( 2160,  110, cMensPor2  ,oFont12,100)
//oPrn:Say( 2120, 1415, cMensIng1  ,oFont12,100)
//oPrn:Say( 2160, 1415, cMensIng2  ,oFont12,100)
Return


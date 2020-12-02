#INCLUDE "RWMAKE.CH"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpMarObra บAutor ณCarlos R Moreira    บ Data ณ  13/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressao das m arcacoes do ponto da Obra                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ImpMarObra()

	Private cPerg := "IMPMAROBRA"

	PutSx1(cPerg,"01","Data Inicial               ?","","","mv_ch1","D",  8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{{"Data Inicial de processamento "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"02","Data Final                 ?","","","mv_ch2","D",  8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{{"Data Final de processamento   "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"03","CC Inicial                 ?","","","mv_ch3","C",  9,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",{{"C.Custo Inicial de processamento "}},{{" "}},{{" "}},"")
	PutSx1(cPerg,"04","CC Final                   ?","","","mv_ch4","C",  9,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",{{"C.Custo Final de processamento   "}},{{" "}},{{" "}},"")


	If Pergunte(cPerg,.T.)
	
		Processa({||U_ImpEspObra()},"Imprimindo o espelho de marcacao obra..")
	
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFATR25   บAutor  ณMicrosiga           บ Data ณ  04/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ImpEspObra()

	oFont  := TFont():New( "Arial",,15,,.t.,,,,,.F. )
	oFont3 := TFont():New( "Arial",,12,,.t.,,,,,.f. )
	oFont12:= TFont():New( "Arial",,10,,.t.,,,,,.f. )
	oFont5 := TFont():New( "Arial",,10,,.f.,,,,,.f. )
	oFont9 := TFont():New( "Arial",,8,,.f.,,,,,.f. )
	oFont14:= TFont():New( "Arial",,8,,.T.,,,,,.f. )
	oArial16N:= TFont():New( "Arial",,16,,.t.,,,,,.f. )
	oArialNeg06 :=  TFont():New( "Arial",, 6,,.T.,,,,,.f. )

	oFont1:= TFont():New( "Times New Roman",,28,,.t.,,,,,.t. )
	oFont2:= TFont():New( "Times New Roman",,14,,.t.,,,,,.f. )
	oFont4:= TFont():New( "Times New Roman",,20,,.t.,,,,,.f. )
	oFont7:= TFont():New( "Times New Roman",,18,,.t.,,,,,.f. )
	oFont11:=TFont():New( "Times New Roman",,10,,.t.,,,,,.t. )

	oFont6:= TFont():New( "HAETTENSCHWEILLER",,10,,.t.,,,,,.f. )

	oFont8:=  TFont():New( "Free 3 of 9",,44,,.t.,,,,,.f. )
	oFont10:= TFont():New( "Free 3 of 9",,38,,.t.,,,,,.f. )
	oFont13:= TFont():New( "Courier New",,12,,.t.,,,,,.f. )

	oBrush := TBrush():New(,CLR_HGRAY,,)
	oBrush1 := TBrush():New(,CLR_BLUE,,)
	oBrush2 := TBrush():New(,CLR_WHITE,,)

	oPrn := TMSPrinter():New()
	oPrn:SetPortrait()
	oPrn:SetPaperSize(9)

	lPri := .T.
	nPag := 0
	nLin := 490

	aFunc := {}
	  
	DbSelectArea("SRA")
	DbSetOrder(2)
	
	DbSeek(xFilial("SRA")+MV_PAR03,.T. )
	
	While SRA->(!Eof()) .And. SRA->RA_CC <= MV_PAR04
	
		If SRA->RA_ADMISSA > MV_PAR02
			SRA->(DbSkip())
			Loop
		EndIf
	      
		If !Empty(SRA->RA_DEMISSA)
			If SRA->RA_DEMISSA < MV_PAR01
				SRA->(DbSkip())
				Loop
			EndIf
		EndIf
	   
		AAdd(aFunc,{SRA->RA_MAT,SRA->RA_NOME} )
	   
		DbSelectArea("SRA")
		DbSkip()
	   
	End
	
	
	aMovim := {}
	
 For nX := MV_PAR01 TO MV_PAR02
 
     AaDD(aMovim,nX)
     
 Next     
     
/*
	DbSelectArea("SZ3")
	DbSetOrder(1)
	DbSeek(xFilial("SZ3")+Dtos(MV_PAR01),.T. )

	While SZ3->(!Eof()) .And. SZ3->Z3_DATA <= MV_PAR02
	

		If SZ3->Z3_CC < MV_PAR03 .Or. SZ3->Z3_CC > MV_PAR04
			DbSkip()
			Loop
		EndIf

		nPesq := Ascan(aMovim,SZ3->Z3_DATA )
    
		If nPesq == 0
       
			AaDD(aMovim,SZ3->Z3_DATA)
       
		EndIf
         
		DbSelectArea("SZ3")
		DbSkip()
    
	End

  */ 
  //Ordena o vetor para sair em ordem alfabetica
  aSort(aFunc,,,{|x,y|y[2]>x[2]} )   

	ProcRegua(Len(aMovim))

	For nX := 1   to Len( aMovim )

		IncProc("Imprimindo o espelho..")
   
		lPri := .T.
   
		For nFunc :=  1 to Len(afunc)
   
			DbSelectArea("SZ3")
			DbSetOrder(2)
			If DbSeek(xFilial("SZ3")+aFunc[nFunc,1]+Dtos(aMovim[nX]))

				If lPri
			
					oPrn:StartPage()
					nPag++
			
					CabPreEsp(oPrn,nPag,"ImpEspObra")
			
					nLin := 360
			
					oPrn:FillRect({nLin,100,nLin+80,2300},oBrush)
			
					oPrn:Box(nLin,100,nLin+80,2300)
			
					oPrn:Say(  nLin+20,  750, "Espelho de Ponto da Obra" ,oFont3,100 )
			
					oPrn:Say(  nLin+20,  1950, "Data : "+Dtoc(aMovim[nX])  ,oFont3,100 )
			
					nLin += 120
			
					oPrn:FillRect({nLin,100,nLin+60,2300},oBrush)
			
					oPrn:Box(nLin,  100,nLin+60,2300 )
					oPrn:Line(nLin, 300,nLin+60,300  )
					oPrn:Line(nLin,1100,nLin+60,1100 )
					oPrn:Line(nLin,1500,nLin+60,1500 )
					oPrn:Line(nLin,1600,nLin+60,1600 )
					oPrn:Line(nLin,1700,nLin+60,1700 )
					oPrn:Line(nLin,1800,nLin+60,1800 )
					oPrn:Line(nLin,1900,nLin+60,1900 )
					oPrn:Line(nLin,2000,nLin+60,2000 )
					oPrn:Line(nLin,2100,nLin+60,2100 )
					oPrn:Line(nLin,2200,nLin+60,2200 )
			
			
					oPrn:Say(  nLin+5,   120, "Matricula"    ,oFont9,100 )
					oPrn:Say(  nLin+5,   320, "Nome"        ,oFont9,100 )
					oPrn:Say(  nLin+5,  1200, "Pis"   ,oFont9,100 )
			
					oPrn:Say(  nLin+5,  1510, " 1a Ent"    ,oFont9,100 )
					oPrn:Say(  nLin+5,  1610, " 1a Sai"    ,oFont9,100 )
			
					oPrn:Say(  nLin+5,  1710, " 2a Ent"    ,oFont9,100 )
					oPrn:Say(  nLin+5,  1810, " 2a Sai"    ,oFont9,100 )
			
					oPrn:Say(  nLin+5,  1910, " 3a Ent"    ,oFont9,100 )
					oPrn:Say(  nLin+5,  2010, " 3a Sai"    ,oFont9,100 )
			
					oPrn:Say(  nLin+5,  2110, " 4a Ent"    ,oFont9,100 )
					oPrn:Say(  nLin+5,  2210, " 4a Sai"    ,oFont9,100 )
			
					nLin += 60
			
					lPri := .F.
			
				EndIf
		   
				oPrn:Box(nLin,  100,nLin+60,2300 )
				oPrn:Line(nLin, 300,nLin+60,300  )
				oPrn:Line(nLin,1100,nLin+60,1100 )
				oPrn:Line(nLin,1500,nLin+60,1500 )
				oPrn:Line(nLin,1600,nLin+60,1600 )
				oPrn:Line(nLin,1700,nLin+60,1700 )
				oPrn:Line(nLin,1800,nLin+60,1800 )
				oPrn:Line(nLin,1900,nLin+60,1900 )
				oPrn:Line(nLin,2000,nLin+60,2000 )
				oPrn:Line(nLin,2100,nLin+60,2100 )
				oPrn:Line(nLin,2200,nLin+60,2200 )
		
				oPrn:Say(  nLin+10,   120, SZ3->Z3_MAT ,oFont9,100 )
				oPrn:Say(  nLin+10,   320, SZ3->Z3_NOME ,oFont9,100 )
				oPrn:Say(  nLin+10,  1120, SZ3->Z3_PIS   ,oFont9,100 )
		
				oPrn:Say(  nLin+10,  1510, Transform(SZ3->Z3_1E,"@R 99:99") ,oFont9,100 )
				oPrn:Say(  nLin+10,  1610, Transform(SZ3->Z3_1S,"@R 99:99")  ,oFont9,100 )
		
				oPrn:Say(  nLin+10,  1710, Transform(SZ3->Z3_2E,"@R 99:99") ,oFont9,100 )
				oPrn:Say(  nLin+10,  1810, Transform(SZ3->Z3_2S,"@R 99:99")  ,oFont9,100 )
		
				oPrn:Say(  nLin+10,  1910, Transform(SZ3->Z3_3E,"@R 99:99") ,oFont9,100 )
				oPrn:Say(  nLin+10,  2010, Transform(SZ3->Z3_3S,"@R 99:99")  ,oFont9,100 )
		
				oPrn:Say(  nLin+10,  2110, Transform(SZ3->Z3_4E,"@R 99:99") ,oFont9,100 )
				oPrn:Say(  nLin+10,  2210, Transform(SZ3->Z3_4s,"@R 99:99")  ,oFont9,100 )
		
				nLin += 60
		
			Else
			
				If lPri
			
					oPrn:StartPage()
					nPag++
			
					CabPreEsp(oPrn,nPag,"ImpEspObra")
			
					nLin := 360
			
					oPrn:FillRect({nLin,100,nLin+80,2300},oBrush)
			
					oPrn:Box(nLin,100,nLin+80,2300)
			
					oPrn:Say(  nLin+20,  750, "Espelho de Ponto da Obra" ,oFont3,100 )
			
					oPrn:Say(  nLin+20,  1950, "Data : "+Dtoc(aMovim[nX])  ,oFont3,100 )
			
					nLin += 120
			
					oPrn:FillRect({nLin,100,nLin+60,2300},oBrush)
			
					oPrn:Box(nLin,  100,nLin+60,2300 )
					oPrn:Line(nLin, 300,nLin+60,300  )
					oPrn:Line(nLin,1100,nLin+60,1100 )
					oPrn:Line(nLin,1500,nLin+60,1500 )
					oPrn:Line(nLin,1600,nLin+60,1600 )
					oPrn:Line(nLin,1700,nLin+60,1700 )
					oPrn:Line(nLin,1800,nLin+60,1800 )
					oPrn:Line(nLin,1900,nLin+60,1900 )
					oPrn:Line(nLin,2000,nLin+60,2000 )
					oPrn:Line(nLin,2100,nLin+60,2100 )
					oPrn:Line(nLin,2200,nLin+60,2200 )
			
			
					oPrn:Say(  nLin+5,   120, "Matricula"    ,oFont9,100 )
					oPrn:Say(  nLin+5,   320, "Nome"        ,oFont9,100 )
					oPrn:Say(  nLin+5,  1200, "Pis"   ,oFont9,100 )
			
					oPrn:Say(  nLin+5,  1510, " 1a Ent"    ,oFont9,100 )
					oPrn:Say(  nLin+5,  1610, " 1a Sai"    ,oFont9,100 )
			
					oPrn:Say(  nLin+5,  1710, " 2a Ent"    ,oFont9,100 )
					oPrn:Say(  nLin+5,  1810, " 2a Sai"    ,oFont9,100 )
			
					oPrn:Say(  nLin+5,  1910, " 3a Ent"    ,oFont9,100 )
					oPrn:Say(  nLin+5,  2010, " 3a Sai"    ,oFont9,100 )
			
					oPrn:Say(  nLin+5,  2110, " 4a Ent"    ,oFont9,100 )
					oPrn:Say(  nLin+5,  2210, " 4a Sai"    ,oFont9,100 )
			
					nLin += 60
			
					lPri := .F.
			
				EndIf


				SRA->(DbSetOrder(1))
				SRA->(DbSeek(xFilial("SRA")+aFunc[nFunc,1] ))
	      
				oPrn:Box(nLin,  100,nLin+60,2300 )
				oPrn:Line(nLin, 300,nLin+60,300  )
				oPrn:Line(nLin,1100,nLin+60,1100 )
				oPrn:Line(nLin,1500,nLin+60,1500 )
				oPrn:Line(nLin,1600,nLin+60,1600 )
				oPrn:Line(nLin,1700,nLin+60,1700 )
				oPrn:Line(nLin,1800,nLin+60,1800 )
				oPrn:Line(nLin,1900,nLin+60,1900 )
				oPrn:Line(nLin,2000,nLin+60,2000 )
				oPrn:Line(nLin,2100,nLin+60,2100 )
				oPrn:Line(nLin,2200,nLin+60,2200 )
		
				oPrn:Say(  nLin+10,   120, SRA->RA_MAT ,oFont9,100 )
				oPrn:Say(  nLin+10,   320, SRA->RA_NOME ,oFont9,100 )
				oPrn:Say(  nLin+10,  1120, SRA->RA_PIS   ,oFont9,100 )

				nLin += 60
	     
			EndIf
			
			If nLin > 3100
				oPrn:EndPage()
				lPri := .T.
			EndIf
        

		Next
   	                           
		RodFinPon(oPrn)
   
		oPrn:EndPage()

	Next

	oPrn:Preview()
	oPrn:End()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCABREL    บAutor  ณCarlos R.Moreira    บ Data ณ  11/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEmite o cabecalho da Pre-Fatura de conhecimento de transportบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Scarlat                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CabPreEsp(oPrn,nPag,cProg)
	Local cBitMap:= FisxLogo("1")

	oArial06Neg  :=  TFont():New( "Arial",,06,,.T.,,,,,.F. )

	oPrn:Box( 050, 100, 300,2300 )
	oPrn:SayBitmap( 100,180,cBitMap,220,180 )
	oPrn:Line( 050, 550, 300, 550 )
	oPrn:Line( 050, 1800, 300, 1800 )

	cNomEmp  := SM0->M0_NOMECOM
	cEndEmp  := Alltrim(SM0->M0_ENDCOB)+"-"+Alltrim(SM0->M0_CIDCOB)+"-"+SM0->M0_ESTCOB+"-"+Transform(SM0->M0_CEPCOB,"@R 99999-999")
	cTelFax  := "Telefone: "
	cHome    := cTelFax + " www.sacseng.com.br/"

	cCNPJ      :=  "C.N.P.J.: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+ "   -    Insc. Estadual : "+SM0->M0_INSC

//Dados da Empresa
	oPrn:Say(  60,  570, cNomEmp ,oFont3,100 )
	oPrn:Say( 120,  570, cEndEmp ,oFont9,100 )
	oPrn:Say( 180,  570, cCNPJ   ,oFont5,100 )
	oPrn:Say( 240,  570, cHome   ,oFont5,100 )

	oPrn:Say( 80,  1820, "Emissใo : "+Dtoc(dDataBase),oFont3,100 )

	oPrn:Say( 150, 1820, "Pแgina  : "+StrZero(nPag,3),oFont3,100 )

	oPrn:Say( 220, 1820, "Hora  : "+Time(),oFont3,100 )

	oPrn:Say( 270, 2120, cProg ,oArial06Neg ,100 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRodPreFat บAutor  ณCarlos R Moreira    บ Data ณ  09/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIra gerar a impressao do Rodape com dados do usuario        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RodFinPon(oPrn)

	nLin := 3100
	oPrn:Box(nLin,100,nLin+200,2300)

	oPrn:Line(nLin,1300,nLin+200,1300)
	oPrn:Line(nLin,1800,nLin+200,1800)

	oPrn:Say( nLin+5,  120, "Assinatura e Carimbo Cliente" ,oArialNeg06,100 )
	oPrn:Say( nLin+5, 1315, "Data" ,oArialNeg06,100 )
	oPrn:Say( nLin+5, 1815, "Hora" ,oArialNeg06,100 )

Return

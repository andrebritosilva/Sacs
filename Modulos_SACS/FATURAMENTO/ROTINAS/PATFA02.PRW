#include "rwmake.ch"
#include "Protheus.ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PATFA02   ºAutor  ³Carlos R. Moreira   º Data ³  31/05/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ira emitir o termo de responsabilidade                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PATFA02()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aCores    := {}

	If cPaisLoc == "BRA"
		aCores    := {	{  'F2_TIPO=="N"'	 , 'DISABLE'},;		// NF Normal
		{  'F2_TIPO=="P"'	 , 'BR_AZUL'},;		// NF de Compl. IPI
		{  'F2_TIPO=="I"'	 , 'BR_MARRON'},;	// NF de Compl. ICMS
		{  'F2_TIPO=="C"'	 , 'BR_PINK'},;		// NF de Compl. Preco/Frete
		{  'F2_TIPO=="B"'	 , 'BR_CINZA'},;	// NF de Beneficiamento
		{  'F2_TIPO=="D"'  , 'BR_AMARELO'} }	// NF de Devolucao
	Else
		AAdd(aCores,{ 	'F2_TIPO	==	"N" 	.And. F2_TIPODOC	==	"01"', 'DISABLE'})		// NF Normal
		AAdd(aCores,{  'F2_TIPO	==	"C"	.And. F2_TIPODOC	$	"02/03"'	, 'BR_PINK'})		// NF de Compl. Preco/Frete
		AAdd(aCores,{  'F2_TIPO	==	"B"	'										, 'BR_CINZA'})		// NF de Beneficiamento
		AAdd(aCores,{  'F2_TIPO	==	"D"	.And. F2_TIPODOC	$	"06/07"' , 'BR_AMARELO'}) 	// NF de Devolucao
		AAdd(aCores,{  'F2_TIPO	==	"D"	.And. F2_TIPODOC	==	"61"' 	, 'BR_AZUL'})		// Remito de devolucao
		AAdd(aCores,{  'F2_TIPO	==	"N"	.And. F2_TIPODOC	==	"50"' 	, 'BR_MARRON'})	// Remito
		AAdd(aCores,{  'F2_TIPO	==	"B"	.And. F2_TIPODOC	==	"54"'    , 'BR_PRETO'}) 	// Remito transferencia
	EndIf

	Private aRotina := {	{ "Pesquisar","AxPesqui"	,0,1,0,.F.},;		// "Pesquisar"
	{ "Emitir Termo","U_PATFA02TER" , 0 , 4,NIL},;
		{ "Consultar","MC090Visual"	,0,2,0,NIL},;		// "Visualizar"
	{ "Legenda","MC090Legend"	,0,5,0,NIL} }	 	// "Legenda"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE cCadastro := "Consulta Nota Fiscal de Saida"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mBrowse(6,1,22,75,"SF2",,,,,,aCores)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PATFA02   ºAutor  ³Carlos R. Moreira   º Data ³  31/05/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ira emitir o termo de responsabilidade                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PATFA02TER(cNotaIni,cNotaFim)
	Local oPrn
	Local aArea := GetArea()
	
	Private oFont, cCode

	oFont  :=  TFont():New( "Arial",,15,,.T.,,,,,.F. )
	oFont3 :=  TFont():New( "Arial",,12,,.t.,,,,,.f. )
	oFont12:=  TFont():New( "Arial",,10,,.t.,,,,,.f. )
	oFont5 :=  TFont():New( "Arial",,10,,.f.,,,,,.f. )
	oFont9 :=  TFont():New( "Arial",, 8,,.T.,,,,,.f. )
	oArialNeg06 :=  TFont():New( "Arial",, 6,,.T.,,,,,.f. )
	oArialNeg07 :=  TFont():New( "Arial",, 7,,.T.,,,,,.f. )

	oFont1:= TFont():New( "Times New Roman",,28,,.t.,,,,,.t. )
	oFont2:= TFont():New( "Times New Roman",,11,,.t.,,,,,.f. )
	oFont4:= TFont():New( "Times New Roman",,20,,.t.,,,,,.f. )
	oFont7:= TFont():New( "Times New Roman",,18,,.t.,,,,,.f. )
	oFont11:=TFont():New( "Times New Roman",,10,,.t.,,,,,.t. )

	oFont6:= TFont():New( "HAETTENSCHWEILLER",,10,,.t.,,,,,.f. )

	oFont8:=  TFont():New( "Free 3 of 9",,44,,.t.,,,,,.f. )
	oFont10:= TFont():New( "Free 3 of 9",,38,,.t.,,,,,.f. )
	oFont13:= TFont():New( "Courier New",,10,,.t.,,,,,.f. )

	oCourier10N := TFont():New( "Courier New",,10,,.t.,,,,,.f. )
	oCourier12N := TFont():New( "Courier New",,12,,.t.,,,,,.f. )
	oCourier14N := TFont():New( "Courier New",,14,,.t.,,,,,.f. )

	oBrush  := TBrush():New(,CLR_HGRAY,,)
	oBrush1 := TBrush():New(,CLR_BLUE,,)
	oBrush2 := TBrush():New(,CLR_WHITE,,)
 
	oPrn := TMSPrinter():New()
	oPrn:SetPortrait()
	//oPrn:SetLandscape()
	oPrn:SetPaperSize(9)

	lEmail := .F. //MsgYesNo("Deseja enviar por Email..." )

	If lEmail
		cJPEG := CriaTrab(,.F.)
	EndIf

	oPrn:Setup()
 
	lFirst := .T.
	nPag   := 0
	nLin   := 0 

DbSelectArea("SF2")
DbSetOrder(1)
DbSeek(xFilial("SF2")+cNotaIni,.T. )

ProcRegua(RecCount())

While SF2->(!Eof()) .And. SF2->F2_DOC <= cNotaFim 

 lImpTermo := .F. 
 
 DbSelectArea("SD2")
 DbSetOrder(3)
 DbSeek(xFilial("SD2")+SF2->F2_DOC )
 
 While SD2->(!Eof()) .And. SD2->D2_DOC == SF2->F2_DOC 
 
    
    SB1->(DbSetOrder(1))
    SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD ))
    
    If SB1->B1_GRUPO $ "ATIV,ADMO,FERR"
       lImpTermo := .t.
       Exit
    EndIf 
       
    DbSkip()
    
 End 
 
 If ! lImpTermo
    DbSelectArea("SF2")
    DbSkip()
    Loop
 EndIf 
     
	oPrn:StartPage()

	cTitulo := "TERMO DE RESPONSABILIDADE DE GUARDA DE ATIVOS"
	cRod    := ""
	aTit    := {cTitulo," ",cRod}
	nPag++
	CabRelAtv(aTit,2,oPrn,nPag,"",1)
     
	nLin += 60
     
	oPrn:Say( nLin+15,  110,"Recebi o(s) Bem (ns) constante(s) na NOTA FISCAL DE TRANSFERENCIA n. "+SF2->F2_DOC ,oCourier10N,100 )
	oPrn:Say( nLin+75,  110,"anexo  a  este TERMO DE RESPONSABILIDADE, do(s) bem(ns) patrimonial(is)" ,oCourier10N,100 )
	oPrn:Say( nLin+135,  110,"	que esta(ão) sob minha responsabilidade." ,oCourier10N,100 )
	oPrn:Say( nLin+195, 110,"Comprometo-me  a cumprir todos os procedimentos e usá-lo(s) adequadamente, e devolve-lo(s)",oCourier10N,100 )
	oPrn:Say( nLin+255, 110,"	conforme recebido.",oCourier10N,100 )
	oPrn:Say( nLin+315, 110,"Qualquer ocorrência avisarei imediatamente o líder imediato e/ou Responsável pelos Ativos.",oCourier10N,100 )
	oPrn:Say( nLin+375, 110,"Cessará está responsabilidade:",oCourier10N,100 )
	oPrn:Say( nLin+435, 110,"1) Quando da transferência do(s) bem(ns) para outro responsável e/ou,devidamente documentado",oCourier10N,100 )
	oPrn:Say( nLin+495, 110,"2) Quando da minha rescisão contratual,  época  em  que   prestarei  contas  sobre  os  bens",oCourier10N,100 )
	oPrn:Say( nLin+555, 110,"	de minha ",oCourier10N,100 )
	oPrn:Say( nLin+615, 110,"A Atualização do FORMULÁRIO DE MOVIMENTAÇÃO DE BENS com as movimentações realizadas a partir",oCourier10N,100 )
	oPrn:Say( nLin+675, 110,"desta  data  terão  a  mesma validade para fins  deste  TERMO DE RESPONSABILIDADE, desde que  ",oCourier10N,100 )
	oPrn:Say( nLin+735, 110,"recebam a minha concordância e assinatura. ",oCourier10N,100 )

	nLin += 900
  
/*
	oPrn:Say( nLin,  120, "___________________________,_____ de _______________________________ de __________"   ,oCourier10N,100 )

  nLin += 90 
  
	oPrn:Say( nLin+15,  110,"_______________________________________________________ ",oCourier10N,100 )
	
	oPrn:Say( nLin+55,  110,"Nome: ",oCourier10N,100 )
	oPrn:Say( nLin+95,  110,"Cargo: ",oCourier10N,100 )
	oPrn:Say( nLin+135,  110,"RG: ",oCourier10N,100 )


	oPrn:Say( 1560,  100,"_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _",oCourier10N,100 )

	cTitulo := "DECLARAÇÃO DE REGULARIDADE COM A GUARDA DE BENS"
	cRod    := "PATRIMONIAIS"
	aTit    := {cTitulo," ",cRod} 

	CabRelAtv(aTit,2,oPrn,nPag,"",2)
			
	nLin += 60
  
	oPrn:Say( nLin+15,  110,"  Declaramos para os devidos fins, que o colaborador____________________________________________",oCourier10N,100 )
	oPrn:Say( nLin+55,  110,"prestou conta dos bens constante no TERMO  DE  RESPONSABILIDADE  DE  GUARDA  DE  ATIVOS – nº NF ",oCourier10N,100 )
	oPrn:Say( nLin+95,  110,SF2->F2_DOC +" aonde foram conferidas as quantidades, e condições  de  conversação, sendo concluído,",oCourier10N,100 )
	oPrn:Say( nLin+135,  110,"não haver pendências em relação a estes.",oCourier10N,100 )
*/
	oPrn:Say( nLin,  110,"Espaço Reservado para Ressalvas:",oCourier10N,100 )
  
	nLin += 60
  
	oPrn:Box(nLin,100,nLin+1200,2300)

	
	nLin += 1560
	
		oPrn:Say( nLin,  120, "______________________________,_____ de _______________________________ de __________"   ,oCourier10N,100 )

  nLin += 60 
  
	oPrn:Say( nLin+15,  110,"______________________________________________________ ",oCourier10N,100 )
	oPrn:Say( nLin+55,  110,"Nome: ",oCourier10N,100 )
	oPrn:Say( nLin+95,  110,"Cargo: ",oCourier10N,100 )
	oPrn:Say( nLin+135,  110,"RG: ",oCourier10N,100 )


	oPrn:Say( 3320,  110,"1a via Responsável Destino / 2a via - Responsável Analista Patrimonial",oCourier10N,100 )
	
	oPrn:EndPage()

  DbSelectArea("SF2")
  DbSkip()
  
End 


	oPrn:Preview()

	If lEmail .and. !Empty(cJPEG)
	
		_nLagArq	:= 1270 //870
		_nAltArq	:= 870 //1270
		_nZooArq	:= 140
	
		oPrn:SaveAllAsJPEG(cStartPath+cJPEG,_nLagArq,_nAltArq,_nZooArq)
	
	EndIf

	oPrn:End()

	If lEmail .and. !Empty(cJPEG)
		U_QNCXRMAIL({{cStartPath,cJPEG,"Roteiro de Assistencia Tecnica "}})
	EndIF

	If lEmail
	//	Deleta arquivos JPEG gerados pelos relatorios.
		FErase( cStartPath+cJPEG )
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CABREL    ºAutor  ³Carlos R.Moreira    º Data ³  05/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Emite o cabecalho padrao para os relatorios customizados    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function CabRelAtv(aTitulo,nForma,oPrn,nPag,cProg,nModo)
	Local cBitMap:= FisxLogo("1")

	oArial06Neg  :=  TFont():New( "Arial",,06,,.T.,,,,,.F. )
	
	nLin := If(nModo==1,50,1650)
 	
	oPrn:Box( nLin, 100, nLin+250,2300 )
	oPrn:SayBitmap( nLin+50,180,cBitMap,220,180 )
	oPrn:Line( nLin, 550, nLin+250, 550 )
	oPrn:Line( nLin, 1800, nLin+250, 1800 )
	
	oPrn:Say( nLin+30,  1820, "N.Fiscal.: ",oFont3,100 )
	
	nLin += 100

	nCol :=  1025 - ( (Len(Alltrim(aTitulo[1])) / 2 ) * 20 )
	oPrn:Say( nLin ,  nCol, aTitulo[1],oFont2,100 )
	
	oPrn:Say( nLin , 1820, SF2->F2_DOC ,oFont3,100 )

	nLin += 70
	
	nCol :=  1025 - ( (Len(Alltrim(aTitulo[3])) / 2 ) * 20 )
	oPrn:Say( nLin,  nCol, aTitulo[3],oFont2,100 )

	nLin += 100
  
Return





 
#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO7     บAutor  ณMicrosiga           บ Data ณ  04/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT241GRV()
Local aArea := GetArea()

PRIVATE nHdlPrv				      // Endereco do arquivo de contra prova dos lanctos cont.
PRIVATE lCriaHeader := .T.	// Para criar o header do arquivo Contra Prova
PRIVATE cLoteEst			      // Numero do lote para lancamentos do estoque
PRIVATE lCtbOnLine  := .F.	// Contabilizacao On Line
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posiciona numero do Lote para Lancamentos do Estoque         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX5")
dbSeek(xFilial()+"09EST")
cLoteEst:=IIf(Found(),Trim(X5Descri()),"EST ")
PRIVATE cArquivo			  // Nome do arquivo contra prova
PRIVATE lCabecalho := .F.
nTotal := 0

//Alert("Estou...")

cPadrao := "666"
lPadrao:=VerPadrao(cPadrao)
                            
DbSelectArea("SD3")
DbSetOrder(2)
DbSeek(xFilial("SD3")+cDocumento )

While SD3->(!Eof()) .And. SD3->D3_DOC == cDocumento
   
    SF5->(DbSeek(xFilial("SF5")+SD3->D3_TM ))   
    If SF5->F5_CONTAB # "S"
       DbSkip()
       Loop
    EndIf 
    
    If SD3->D3_ESTORNO == "S"
       Dbskip()
       Loop
    EndIf 
	
	IF lPadrao
		If !lCabecalho
			nHdlPrv := HeadProva(cLoteEst,"MT241GRV",Substr(cUsername,1,6),@cArquivo)
			lCabecalho := .T.
			//a370Cabecalho(@nHdlPrv,@cArquivo)
		Endif
		nTotal += DetProva(nHdlPrv,cPadrao,"MT241GRV",cLoteEst)
	Endif 

    DbSelectArea("SD3")
    RecLock("SD3",.F.)
    SD3->D3_DTLANC := dDataBase 
    MsUnlock()

    DbSkip()
    
End 


If nTotal > 0
	
	Pergunte("MTA240",.F.)
	lDigita   := Iif(mv_par01 == 1,.T.,.F.)
	lAglutina := Iif(mv_par02 == 1,.T.,.F.)
	//nTotal    := 0           

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se ele criou o arquivo de prova ele deve gravar o rodape'    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	RodaProva(nHdlPrv,nTotal)

	aCtbDia := {}
	
	cA100Incl(cArquivo,nHdlPrv,3,cLoteEst,lDigita,lAglutina) //,,,,,,aCtbDia)

EndIf 

RestArea(aArea)
Return

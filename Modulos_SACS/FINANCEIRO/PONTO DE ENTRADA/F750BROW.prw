#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F750BROW  ºAutor  ³Carlos R. Moreira   º Data ³  07/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inibe a funcao de incluir para o grupo do Cta a pagar      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Gtex                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F750BROW()
Local aRot080 := {}            
Local aRot050 := {}
Local aRot090 := {}
Local aRot240 := {}  
Local aRot241 := {}
Local aRot290 := {}
Local aRot390 := {}
Local aRot580 := {}
Local aRot426 := {}
//Local aRotina := {}
Local lAgrBot := GetNewPar("MV_BOTFUNP",.F.)	//Agrupa as Baixas e Borderos em sub-menus.
Local aRot080A:= {}
Local aRot240A:= {}
Local nGrupo := 0

aRotina := {} 

aRot080 :=	{	{ "Baixar", "Fin750080" , 0 , 4},; //"Baixar"
					{ "Lote", "Fin750080" , 0 , 4},; //
					{ "Canc Baixa", "Fin750080" , 0 , 5},; //
					{ "Excluir Baixa", "Fin750080" , 0 , 5,53},;
					{ "Cons Doc Entrada" ,"U_ConDocEnt", 0 , 6}} //

//Passado como parametro a posicao da opcao dentro da arotina
aRot050 :=	{		{ "Incluir", "Fin750050", 0 , 3},; 
                    { "Alterar", "Fin750050", 0 , 4},;  //   
					{ "Excluir", "Fin750050", 0 , 5},; //
					{ "Substituir", "Fin750050", 0 , 6} } //

If CtbInUse() .Or. MV_MULNATP
	Aadd(aRot050, { "Vis Rateio","Fin750050", 0 , 2}) //
Endif

aRot090 :=	{	{ "Parâmetros", "Fin750090"   ,0,1},; //
					{ "Automática", "Fin750090"   ,0,4} } //

If cPaisLoc != "BRA"
	Aadd(aRot090, { "Cancela Chq","Fin750090", 0 , 2}) //
EndIf

aRot240 :=	{	{ "Borderô", "Fin750240",0,3},; //
					{ "Cancelar" , "Fin750240",0,1} } //
					
aRot241 :=	{	{ "Borderô Imp.", "Fin750241",0,3},; //
					{ "Cancelar", "Fin750241",0,1} } //					

aRot290 :=	{	{ "Selecionar", "Fin750290",0,3},; //
					{ "Cancelar", "Fin750290",0,6} } //

aRot340 :=	{	{ "Selecionar", "Fin750340",0,4},; //
					{ "Cancelar", "Fin750340",0,6},; //
					{ "Estornar", "Fin750340",0,6} } //
					
aRot390 :=	{	{ "Chq s/Tit", "Fin750390",0,2},; //
					{ "Avulsos", "Fin750390",0,2},; //
					{ "Redeposito", "Fin750390",0,2},; //
					{ "Cancelar", "Fin750390",0,3} } //

aRot580 :=	{	{ "Manual", "Fin750580",0,2},; //
					{ "Automatica", "Fin750580",0,2},; //
					{ "Cancelar", "Fin750580",0,2} } //

aRot426 :=	{	{ "Gerar Arquivo", "Fin750426",0,3},; //
					{ "Receber Arquivo", "Fin750426",0,0}	 } //

If lAgrBot
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Agrupa as baixas em sub-menus.							     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRot080A :=	{	{ "Bai&xa Manual",aRot080,0,4},;	//
					{ "Baixa &Autom.",aRot090,0,4}}		//
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Agrupa os borderos em sub-menus.							 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRot240A :=	{	{ "Borderô",aRot240,0,3},; 	//
					{ "Borderô Imp.",aRot241,0,1} } 	//
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa 	  ³
//³ ----------- Elementos contidos por dimensao ------------	  ³
//³ 1. Nome a aparecer no cabecalho 									  ³
//³ 2. Nome da Rotina associada											  ³
//³ 3. Usado pela rotina													  ³
//³ 4. Tipo de Transa‡„o a ser efetuada								  ³
//³	 1 -Pesquisa e Posiciona em um Banco de Dados				  ³
//³	 2 -Simplesmente Mostra os Campos								  ³
//³	 3 -Inclui registros no Bancos de Dados						  ³
//³	 4 -Altera o registro corrente									  ³
//³	 5 -Exclui um registro cadastrado								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aRotina,	{ "Pesquisar", "AxPesqui" , 0 , 1,,.F.})  //
aAdd( aRotina,	{ "Visualizar","Fa050Visua", 0 , 2})  //
aAdd( aRotina,	{ "Contas a Pagar",aRot050, 0 , 3}) //
If !lAgrBot
	aAdd( aRotina,	{ "Baixa &Manual",aRot080, 0 , 5})  //
	aAdd( aRotina,	{ "Baixa &Autom.",aRot090, 0 , 4}) //
	aAdd( aRotina,	{ "&Borderô",aRot240, 0 , 5}) //   
	aAdd( aRotina,	{ "Bo&rderô Imp."   ,aRot241, 0 , 5}) //
Else	
	aAdd( aRotina,	{ "Bai&xas",aRot080A, 0 , 3}) //
	aAdd( aRotina,	{ "&Borderôs",aRot240A, 0 , 5}) //
EndIf
aAdd( aRotina,	{ "&Faturas",aRot290, 0 , 6}) //
aAdd( aRotina,	{ "Co&mpensação",aRot340, 0 , 6}) //
aAdd( aRotina,	{ "Cheq s/&Título",aRot390, 0 , 6}) //
aAdd( aRotina,	{ "Lib p/Pagto",aRot580, 0 , 6}) //
aAdd( aRotina,	{ "C&NAB",aRot426, 0 , 6}) //
aAdd( aRotina,	{ "Cons Doc Entrada"   ,"U_ConDocEnt", 0 , 6})
aAdd( aRotina,	{ "Le&genda","FA040Legenda", 0 , 6, ,.F.}) //

Return                                                        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FI050ROT  ºAutor  ³Microsiga           º Data ³  10/29/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta o contrato                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Scarlat                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ConDocEnt()
Local aArea := GetArea()

DbSelectArea("SF1")
DbSetOrder(1)
DbSeek(xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA )

MsDocument( "SF1", SF1->( Recno() ), 1 )                       

RestArea(aArea)
Return

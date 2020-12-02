//Tenta essa Dica:

//Vc poderia criar pastas logo após a grade de produtos.
//São 03 pontos de entrada:

//MT120TEL - Cria a pasta (s)
//MT120FOL - Mostra os campos criados no configurador
//MTA120G2 - Grava os dados
#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

User Function MT120TEL()

Local aArea := GetArea()

AAdd( aTitles, 'Tp Pedido/Cond Gerais' )
//AAdd( aTitles, 'Obs.Usado' )

RestArea( aArea )

Return Nil

//////////////////////////
User Function MT120FOL( )

Local aArea := GetArea()
Local nOpc := PARAMIXB[1]
Local aPosGet := PARAMIXB[2]
Local _oMemo := ""
Local aCombo	 := {"1=Normal","2=Previstos","3=Emergencial 1","4-Emergencial 2"}
Local oDlg
// Local cObsPed   := Space(100)

Static cTpPed  := "1"
Static cObsPed := Space(100)
Static _aIbipora := {}

cObsPed := If (nOpc == 4 .OR. nOpc == 2, sc7->C7_OBSPED, Space(100))
aadd(_aIbipora,If (nOpc == 4 .OR. nOpc == 2, sc7->C7_TIPPED, Space(01)))

If nOpc <> 1
	
	@ 006,aPosGet[1,1] SAY "Tipo Pedido : "  OF oFolder:aDialogs[7] PIXEL COLOR CLR_BLACK
	@ 005,aPosGet[1,2] COMBOBOX _aIbipora[1] VAR cTpPed ITEMS acombo SIZE 70,05 OF oFolder:aDialogs[7] PIXEL
	//@ 008,aPosGet[7,2] MSCOMBOBOX aObj[11] VAR cTpFrete       ITEMS      aCombo ON CHANGE A120VldCombo(cTpFrete,@aValores) .And. A120VFold("NF_FRETE",aValores[FRETE]) WHEN !l120Visual .And. !lMt120Ped SIZE 045,050 OF oFolder:aDialogs[3] PIXEL
	@ 026,aPosGet[1,1] SAY OemToAnsi('Cond Gerais:') OF oFolder:aDialogs[7] PIXEL SIZE 070,009
	@ 028,aPosGet[1,2] MSGET cObsPed PICTURE '@S50' OF oFolder:aDialogs[7] PIXEL SIZE 300,009
	
	//_oMemo:= tMultiget():New(015,aPosGet[1,1],{|u|if(Pcount()>0,_aIbipora[1]:=u,_aIbipora[1])},oFolder:aDialogs[7],200,041,,,,,,.T.)
	
Endif

RestArea( aArea )

Return Nil

////////////////////////////////////////
User Function MTA120G2()

Local aArea := GetArea()

SC7->C7_TIPPED := ctpped //_aIbipora[1]
SC7->C7_OBSPED := cObsPed 

RestArea( aArea )

Return 

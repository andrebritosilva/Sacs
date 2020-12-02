#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function AtuProd()

	Local aArea         := GetArea()
	Local aRet			:= {}
	Local aAreaCT1		:= CT1->(GetArea())
	Local aAreaCVD		:= CVD->(GetArea())
	Local aCfg			:= {}
	Local cCampos		:= ""
	Local lContinua		:= .T.
	Local oModCT1Imp	:= Nil

	Private oProcess   

	SaveInter()

	oModCT1Imp	:= FWLoadModel("CTBA020")

	aCfg := { { "SB1", cCampos, {|| FWMVCRotAuto(oModCT1Imp, "SB1", 3, { {"SB1MASTER",xAutoCab} }, , .T.) } }, {"SB5",,} }

	If ParamBox({	{6,"Selecione Arquivo",PadR("",150),"",,"", 90 ,.T.,"Alteração de Produtos","",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE}},;
					"Importar Estrutura de Produtos",@aRet) 

		oProcess:= MsNewProcess():New( {|lEnd| AvaImpCSV( lEnd, oProcess, aRet[1], aCfg )} )
		oProcess:Activate()

	EndIf

	oModCT1Imp:Destroy()
	oModCT1Imp := Nil

	RestInter()

	RestArea(aAreaCVD)
	RestArea(aAreaCT1)

Return Nil

RestInter()

Return .T.


//--------------------------------------------------
/*/{Protheus.doc} AvaImpCSV
Importa registros da planilha para a tabela SB1

@author André Brito
@since 02/12/2019
@version P12.1.17
 
@return 
/*/
//--------------------------------------------------

Static Function AvaImpCSV(lEnd, oProcess, cArq, aCfg , lProc)

Local cLinha      := ""
Local lPrim       := .T.
Local aCampos     := {}
Local aDados      := {}
Local aProds      := {}
Local i           := 0
Local x           := 0
Local lMsErroAuto := .F.
Local nAtual      := 0
Local nTotal      := 0
Local nTot2       := 0
Local nNumProd    := 0
Local aCab        := {}
Local oModel      := Nil
Local aArea       := GetArea()
Local aAreaSb1    := GetArea()
Local lRet        := .T.
Local cCofins     := ""
Local cPis        := ""
Local aProdutos   := {}
Local nInclu      := 0
Local cCod        := ""

Private aErro := {}
 
If !File(cArq)
	MsgStop("O arquivo "  + cArq + " não foi encontrado. A importação será abortada!","ATENCAO")
	Return
EndIf
 
FT_FUSE(cArq)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()

nTot2 := FT_FLASTREC()
oProcess:SetRegua1(nTot2)

While !FT_FEOF()
	

	oProcess:IncRegua1("Totais de produtos lidos: " + cValToChar(nNumProd))

	nNumProd := nNumProd + 1

	cLinha := FT_FREADLN()
 
	If lPrim
		aCampos := Separa(cLinha,";",.T.)
		lPrim := .F.
	Else
		If cLinha $ ";;;;;;;;;;;;;;;;;"
			Exit
		EndIf
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf
 
	FT_FSKIP()
EndDo

nTotal := Len(aDados)

Count To nTotal
oProcess:SetRegua2(nTotal)

DbSelectArea("SB1")
DbSetOrder(1)

For i := 1 to Len(aDados)


oProcess:IncRegua2("Alterando o produto: " + aDados[i][3] + "" + Str(i))

cCod := Padr(aDados[i][3],TamSx3('B1_COD')[1]) 

If DbSeek( xFilial("SB1") + cCod )
	
	RecLock("SB1",.F.)
		
		SB1->B1_GRUPO    := Alltrim(aDados[i][9])
		SB1->B1_CONTA    := Alltrim(aDados[i][46])
		SB1->B1_CONTAUX  := Alltrim(aDados[i][47])
		
	MsUnLock()
EndIf
	
	
Next

//U_AvcMsg(Len(aDados), nInclu, aProdutos)
 
FT_FUSE()

If lRet
	ApMsgInfo("Importação dos Produtos concluída com sucesso!","SUCESSO")
Else
	ApMsgInfo("Aconteceram erros na sua importação, verifique!","Conferência")
EndIf

RestArea(aArea)

Return


User Function AvcMsg(nDados, nInclu, aProdutos)

	Local lRetMens             := .F.
	Local oDlgMens
	Local oBtnOk, cTxtConf     := ""
	Local oBtnCnc, cTxtCancel  := ""
	Local oBtnSlv
	Local oFntTxt              := TFont():New("Verdana",,-011,,.F.,,,,,.F.,.F.)
	Local oMsg
	Local nIni                 := 1
	Local nFim                 := 50
	Local cMsg                 := ""
	Local cTitulo              := "Produtos importados"
	Local cQuebra              := CRLF + CRLF
	Local nTipo                := 1 // 1=Ok; 2= Confirmar e Cancelar
	Local lEdit                := .F.
    Local nX                   := 0

    cMsg  := "Total de produtos processados: " + Alltrim(Str(nDados)) + CRLF
    cMsg  += "Total de produtos inclusos: " + Alltrim(Str(nInclu))
    
	cTexto := "Função   - " + FunName()       + CRLF
	cTexto += "Usuário  - " + cUserName       + CRLF
	cTexto += "Data     - " + dToC(dDataBase) + CRLF
	cTexto += "Hora     - " + Time()          + CRLF
	cTexto += "Mensagem - " + cTitulo + cQuebra  + cMsg + " " + cQuebra
	cTexto += CRLF

	If nInclu != nDados
		cTexto += "Registros não inclusos:" + CRLF + CRLF
	EndIf

	For nX := 1 To Len(aProdutos)
		cTexto += "Código Produto: " + Alltrim(aProdutos[nX][1]) + CRLF
		cTexto += "Descrição Pedido: " + Alltrim(aProdutos[nX][2]) + CRLF
	Next
    
    //Definindo os textos dos botões
	If(nTipo == 1)
		cTxtConf:='Ok'
	Else
		cTxtConf:='Confirmar'
		cTxtCancel:='Cancelar'
	EndIf
 
    //Criando a janela centralizada com os botões
	DEFINE MSDIALOG oDlgMens TITLE cTitulo FROM 000, 000  TO 300, 400 COLORS 0, 16777215 PIXEL
        //Get com o Log
	@ 002, 004 GET oMsg VAR cTexto OF oDlgMens MULTILINE SIZE 191, 121 FONT oFntTxt COLORS 0, 16777215 HSCROLL PIXEL
	If !lEdit
		oMsg:lReadOnly := .T.
	EndIf
         
        //Se for Tipo 1, cria somente o botão OK
	If (nTipo==1)
		@ 127, 144 BUTTON oBtnOk  PROMPT cTxtConf   SIZE 051, 019 ACTION (lRetMens:=.T., oDlgMens:End()) OF oDlgMens PIXEL
         
        //Senão, cria os botões OK e Cancelar
	ElseIf(nTipo==2)
		@ 127, 144 BUTTON oBtnOk  PROMPT cTxtConf   SIZE 051, 009 ACTION (lRetMens:=.T., oDlgMens:End()) OF oDlgMens PIXEL
		@ 137, 144 BUTTON oBtnCnc PROMPT cTxtCancel SIZE 051, 009 ACTION (lRetMens:=.F., oDlgMens:End()) OF oDlgMens PIXEL
	EndIf
         
        //Botão de Salvar em Txt
	@ 127, 004 BUTTON oBtnSlv PROMPT "&Salvar em .txt" SIZE 051, 019 ACTION (SalvaArq(cMsg, cTitulo, Alltrim(Str(nDados)),cTexto)) OF oDlgMens PIXEL
	ACTIVATE MSDIALOG oDlgMens CENTERED
 
Return lRetMens

//--------------------------------------------------
 
Static Function SalvaArq(cMsg, cTitulo, cQtdDados, cTxt)

	Local cFileNom :='\x_arq_'+dToS(Date())+StrTran(Time(),":")+".txt"
	Local cQuebra  := CRLF + "+=======================================================================+" + CRLF
	Local lOk      := .T.
	Local cTexto   := ""
     
    //Pegando o caminho do arquivo
	cFileNom := cGetFile( "Arquivo TXT *.txt | *.txt", "Arquivo .txt...",,'',.T., GETF_LOCALHARD)
 
    //Se o nome não estiver em branco    
	If !Empty(cFileNom)
        //Teste de existência do diretório
		If ! ExistDir(SubStr(cFileNom,1,RAt('\',cFileNom)))
			Alert("Diretório não existe:" + CRLF + SubStr(cFileNom, 1, RAt('\',cFileNom)) + "!")
			Return
		EndIf

		cTexto := cTxt
         
        //Testando se o arquivo já existe
		If File(cFileNom)
			lOk := MsgYesNo("Arquivo já existe, deseja substituir?", "Atenção")
		EndIf
         
		If lOk
			MemoWrite(cFileNom, cTexto)
			MsgInfo("Arquivo Gerado com Sucesso:"+CRLF+cFileNom,"Atenção")
		EndIf
	EndIf

RestArea( aArea )

Return cConta
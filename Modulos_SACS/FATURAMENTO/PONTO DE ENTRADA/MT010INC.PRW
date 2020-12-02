#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M010INC   ºAutor  ³Carlos R.Moreira    º Data ³  30/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para replicar o cadatro de produtos       º±±
±±º          ³ para as outras empresas                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT010INC()
	Local aArea := GetArea()
	Local aEmp   := {}
	Local cProduto := SB1->B1_COD
	Local cRepoImagem := "http://painel.www1.sacseng.com.br:81/imagem/logo.jpg" //Alltrim(GetMV("MV_WFHTTPE"))+"/html/logo.jpg"
	Local oAviso

	If !INCLUI //nOpc # 1 
		RestArea(aArea)
		Return
	EndIf

 //  Return // tirar em qdo for em producao
   
	If !ExisteSX6("MV_MAILPRD")
		CriarSX6("MV_MAILPRD","C","Guarda os usuarios que receberao o aviso de inclusao de Produto","")
	EndIf

//Alert("Vou mandar email..." )

	cEmail := Alltrim(GetMV("MV_MAILPRD"))

	aEmail := {}

	nInicio := 1
                                                              
	While nInicio < Len(cEmail)
                
		cUser := Substr(cEmail,nInicio,6)
                 
		Aadd(aEmail,Alltrim(UsrRetMail(cUser)))
    
		nInicio += 7
    
	End

	If Len(aEmail) > 0
		For nX := 1 to Len(aEmail)

			oAviso:= TWFProcess():New('AVISOPRD','WFPRD')
	   oAviso:cPriority := "3"			
			oAviso:NewTask('Inclusao de Produto','\workflow\html\AvisoProduto.htm')
			oAviso:cTo := aEmail[nX]
			oAviso:cSubject := "Inclusao de Produto "
	
			oAviso:oHtml:ValByName("cRepoImagem"	, cRepoImagem)
	
			oAviso:oHtml:ValByName("cProduto"   , SB1->B1_COD)
			oAviso:oHtml:ValByName("cDescricao" , SB1->B1_DESC)
			oAviso:oHtml:ValByName("cTipo"      , SB1->B1_TIPO)
			cTes := SB1->B1_TE+" - "+Posicione("SF4",1,xFilial("SF4")+SB1->B1_TE,"F4_TEXTO")
			oAviso:oHtml:ValByName("cTes"       , cTes)
			cConta := SB1->B1_CONTA+" - "+Posicione("CT1",1,xFilial("CT1")+SB1->B1_CONTA,"CT1_DESC01")
			oAviso:oHtml:ValByName("cConta"     , cConta)
			oAviso:oHtml:ValByName("cFinalidade" , SB1->B1_FINALID)									
			oAviso:oHtml:ValByName("cUser"      , UsrFullName(__cUserID) )
	
//	oAviso:oHtml:ValByName("cObs" , Alltrim(SC7->C7_OBS))
		
			oAviso:Start()
			oAviso:Finish()

		Next

	EndIf

	RestArea(aArea)
Return

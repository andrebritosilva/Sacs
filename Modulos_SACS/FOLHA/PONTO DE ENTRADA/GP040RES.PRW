#INCLUDE "RWMAKE.CH"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GP040RES  ºAutor ³Carlos R Moreira    º Data ³  13/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para verificar se o funcionario tem algo   º±±
±±º          ³pedencia de ativo                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GP040RES()
Local aArea := GetArea()

DbSelectArea("SZ6")
DbSetOrder(2)
If DbSeek(xFilial("SZ6")+SRA->RA_MAT )

   While SZ6->(!Eof()) .And. SRA->RA_MAT == SZ6->Z6_MAT
   
        If Empty(SZ6->Z6_STATUS)
           
           EnviaAviso()
           
        EndIf
        
        SZ6->(DbSkip())     
   End
EndIf 

RestArea(aArea)
Return 

/*/

Envia o workflow de pendencia de ativo

/*/
Static Function EnviaAviso()
	Local aArea := GetArea()
	Local aEmp   := {}
	Local cAtivo := SZ6->Z6_PLACA 
	Local cRepoImagem := "http://192.32.222.42:83/wf/html/logo.jpg" //Alltrim(GetMV("MV_WFHTTPE"))+"/html/logo.jpg"
	Local oAviso

	If !ExisteSX6("MV_MAILATV")
		CriarSX6("MV_MAILAT","C","Guarda os usuarios que receberao o aviso de inclusao de Ativo","")
	EndIf

//Alert("Vou mandar email..." )

	cEmail := Alltrim(GetMV("MV_MAILATV"))

	aEmail := {}

	nInicio := 1
                                                              
	While nInicio < Len(cEmail)
                
		cUser := Substr(cEmail,nInicio,6)
                 
		Aadd(aEmail,Alltrim(UsrRetMail(cUser)))
    
		nInicio += 7
    
	End

	If Len(aEmail) > 0
		For nX := 1 to Len(aEmail)

			oAviso:= TWFProcess():New('AVISOATV','WFATV')
	   oAviso:cPriority := "3"			
			oAviso:NewTask('Pendencia de Ativo','\workflow\html\AvisoAtivo.htm')
			oAviso:cTo := aEmail[nX]
			oAviso:cSubject := "Aviso de Pendencia de Ativo "
	
			oAviso:oHtml:ValByName("cRepoImagem"	, cRepoImagem)
	
			oAviso:oHtml:ValByName("cAtivo"   , SZ6->Z6_PLACA+"    Requisição: "+SZ6->Z6_COD )
			oAviso:oHtml:ValByName("cDescricao" , SZ6->Z6_DESCBEM)
			oAviso:oHtml:ValByName("cFuncionario" , SZ6->Z6_MAT)
			oAviso:oHtml:ValByName("cNomeFunc"    , SZ6->Z6_NOMFUNC)
			oAviso:oHtml:ValByName("cCC"     , SZ6->Z6_CC )						
			oAviso:oHtml:ValByName("cDescCC"      , SZ6->Z6_DESC_CC )
	
//	oAviso:oHtml:ValByName("cObs" , Alltrim(SC7->C7_OBS))
		
			oAviso:Start()
			oAviso:Finish()

		Next

	EndIf

	RestArea(aArea)

Return 
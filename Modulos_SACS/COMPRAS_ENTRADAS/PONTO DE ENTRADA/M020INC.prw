#INCLUDE "Protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM020INC   บAutor  ณCarlos R Moreira    บ Data ณ  21/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIra mandar e-mails para o grupo do Fiscal                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function M020INC()
Local aArea := GetArea()
Local cRepoImagem := "http://painel.www1.sacseng.com.br:81/imagem/logo.jpg" //Alltrim(GetMV("MV_WFHTTPE"))+"/html/logo.jpg"
Local oAviso

If !ExisteSX6("MV_MAILFIS")
	CriarSX6("MV_MAILFIS","C","Guarda os usuarios do Fiscal que recebem o aviso de inclusao de Fornecedor","")
EndIf

//Alert("Vou mandar email..." )

cEmail := Alltrim(GetMV("MV_MAILFIS"))

aEmail := {}

nInicio := 1
                                                              
While nInicio < Len(cEmail)
                
    cUser := Substr(cEmail,nInicio,6)
                 
    Aadd(aEmail,Alltrim(UsrRetMail(cUser)))
    
    nInicio += 7 
    
End 

For nX := 1 to Len(aEmail)

    oAviso:= TWFProcess():New('AVISOFOR','WFFOR')
    	oAviso:cPriority := "3"
	oAviso:NewTask('Inclusao de Fornecedor','\workflow\html\AvisoFornecedor.htm')
	oAviso:cTo := aEmail[nX]
	oAviso:cSubject := "Inclusao de Fornecedor "
	
	oAviso:oHtml:ValByName("cRepoImagem"	, cRepoImagem)
	
	oAviso:oHtml:ValByName("cCodigo"  , SA2->A2_COD+" - "+SA2->A2_LOJA)
	oAviso:oHtml:ValByName("cNomeForn" , SA2->A2_NOME)
	oAviso:oHtml:ValByName("cCNPJ" , SA2->A2_CGC)
	oAviso:oHtml:ValByName("cFinalidade" , SA2->A2_LESCF)	
	
//	oAviso:oHtml:ValByName("cObs" , Alltrim(SC7->C7_OBS))
		
	oAviso:Start()
	oAviso:Finish()

Next

RestArea(aArea)
Return
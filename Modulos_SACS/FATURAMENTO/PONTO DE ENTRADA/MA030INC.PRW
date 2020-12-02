#INCLUDE "Protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM030INC   บAutor  ณCarlos R Moreira    บ Data ณ  06/06/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIra mandar e-mails para o grupo do Faturamento            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function M030INC()
Local aArea := GetArea()
Local cRepoImagem := "http://painel.www1.sacseng.com.br:81/imagem/logo.jpg" //Alltrim(GetMV("MV_WFHTTPE"))+"/html/logo.jpg"
Local oAviso

If !ExisteSX6("MV_MAILFAT")
	CriarSX6("MV_MAILFAT","C","Guarda os usuarios do Fiscal que recebem o aviso de inclusao de Clientes","")
EndIf

//Alert("Vou mandar email..." )

cEmail := Alltrim(GetMV("MV_MAILFAT"))

aEmail := {}

nInicio := 1
                                                              
While nInicio < Len(cEmail)
                
    cUser := Substr(cEmail,nInicio,6)
                 
    Aadd(aEmail,Alltrim(UsrRetMail(cUser)))
    
    nInicio += 7 
    
End 

For nX := 1 to Len(aEmail)

    oAviso:= TWFProcess():New('AVISOCLI','WFCLI')
    	oAviso:cPriority := "3"
	oAviso:NewTask('Inclusao de Fornecedor','\workflow\html\AvisoCliente.htm')
	oAviso:cTo := aEmail[nX]
	oAviso:cSubject := "Inclusao de Cliente "
	
	oAviso:oHtml:ValByName("cRepoImagem"	, cRepoImagem)
	
	oAviso:oHtml:ValByName("cCodigo"  , SA1->A1_COD+" - "+SA1->A1_LOJA)
	oAviso:oHtml:ValByName("cNomeCli" , SA1->A1_NOME)
	oAviso:oHtml:ValByName("cCNPJ" , SA1->A1_CGC)
	
//	oAviso:oHtml:ValByName("cObs" , Alltrim(SC7->C7_OBS))
		
	oAviso:Start()
	oAviso:Finish()

Next

RestArea(aArea)
Return
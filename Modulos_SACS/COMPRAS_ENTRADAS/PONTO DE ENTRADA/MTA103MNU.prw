#include "rwmake.ch"
#include "protheus.ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA130MNU ºAutor  ³Microsiga           º Data ³  10/28/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Acrescenta um item no menu do documento de entrada         º±±
±±º          ³                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA103MNU()
	Local lRet := .T.

	Local aArea := GetArea()

 AAdd( aRotina, { 'Reg Doc Orig', 'U_DOCORIG()', 0, 4 } )

	AAdd( aRotina, { 'Ac. Tipo Nota', 'U_ACETPNF()', 0, 4 } )

AAdd( aRotina, { 'Cons Doc PC', 'U_DOCPC()', 0, 4 } )
RestARea(aArea)

Return 



User Function DocOrig()

If SF1->F1_TPDOC == "S"

   MsgStop( "Ja foram apresentados documentos originais para esta nota")

   Return 
   
EndIf 
   
If MsgYesNo("Confirma a recepção dos documentos originais")

		DbSelectArea("SF1")
		RecLock("SF1",.F.)
		SF1->F1_TPDOC := "S"
		MsUnlock()

EndIf 

Return 

/*/

Ira acertar a especie de documento 

/*/

User Function ACETPNF()
	Local aArea := GetArea()

If Alltrim(SF1->F1_ESPECIE) == "SPED"

   MsgStop("Nota ja possui a especie correta." )
   
   Return 
   
EndIf 
    
If SF1->F1_FORNECE # "000114"

   MsgStop("Documento do Fornecedor nao permite alteracao" )
   
   Return 

EndIf 

	If MsgYesNo("Confirma o acerto da Nota ")


    DbSelectArea("SF2")
    DbSetorder(1)
    DbSeek(xFilial("SF2")+SF1->F1_DOC )
    
    DbSelectArea("SF3")
    DbSetOrder(6)
    DbSeek(xFilial("SF3")+SF1->F1_DOC )
    
    While SF3->(!Eof()) .And. SF1->F1_DOC == SF3->F3_NFISCAL 
    
       If SF3->F3_TIPO == "S"
          DbSkip()
          Loop
       EndIf 
       
       If SF3->F3_CLIEFOR # "000114" 
          DbSkip()
          Loop
       EndIf 
             
       RecLock("SF3",.F.)
       SF3->F3_ESPECIE := "SPED"
       SF3->F3_CHVNFE  := SF2->F2_CHVNFE 
       MsUnlock()
       DbSkip()
       
    End 
    

    DbSelectArea("SFT")
    DbSetOrder(6)
    DbSeek(xFilial("SFT")+"E"+SF1->F1_DOC )
    
    While SFT->(!Eof()) .And. SF1->F1_DOC == SFT->FT_NFISCAL 
    
       If SFT->FT_TIPO == "S"
          DbSkip()
          Loop
       EndIf 
       
       If SFT->FT_CLIEFOR # "000114" 
          DbSkip()
          Loop
       EndIf 
             
       RecLock("SFT",.F.)
       SFT->FT_ESPECIE := "SPED"
       SFT->FT_CHVNFE  := SF2->F2_CHVNFE 
       MsUnlock()
       DbSkip()
       
    End 

		DbSelectArea("SF1")
		RecLock("SF1",.F.)
   SF1->F1_ESPECIE := "SPED"
   SF1->F1_CHVNFE  := SF2->F2_CHVNFE 
		MsUnlock()

	EndIf


	RestArea(aArea)

Return


/*/

Consulta os documentos anexados no Pedido de Compra

/*/

User Function DOCPC()
Local aArea := GetArea()

DbSelectArea("SD1")
DbSetOrder(1)
DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA )

If Empty(SD1->D1_PEDIDO )

   MsgStop("Nota nao possui pedido de Compra")
   RestArea(aArea)
   Return
   
EndIf 

DbSelectArea("SC7")
DbSetOrder(1)
DbSeek(xFilial("SC7")+SD1->D1_PEDIDO )

MsDocument( "SC7", SC7->( Recno() ), 1 )

Return 
